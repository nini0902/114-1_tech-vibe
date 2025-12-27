// ============ 常數定義 ============
const SLOT_HEIGHT = 30; // 每個 0.5 小時的高度 (px)
const STORAGE_KEY = 'tech_vibe_schedule';

// ============ 任務類 ============
class Task {
    constructor(name, date, startTime, duration, id = null) {
        this.id = id || this.generateId();
        this.name = name;
        this.date = date; // YYYY-MM-DD format
        this.startTime = startTime; // HH:MM format
        this.duration = duration; // hours
        this.createdAt = new Date().toISOString();
    }

    generateId() {
        return 'task_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }

    getEndTime() {
        const [hours, minutes] = this.startTime.split(':').map(Number);
        const totalMinutes = hours * 60 + minutes + (this.duration * 60);
        const endHours = Math.floor(totalMinutes / 60) % 24;
        const endMinutes = totalMinutes % 60;
        return `${String(endHours).padStart(2, '0')}:${String(endMinutes).padStart(2, '0')}`;
    }

    getTopPosition() {
        const [hours, minutes] = this.startTime.split(':').map(Number);
        const totalSlots = (hours * 60 + minutes) / 30;
        return totalSlots * SLOT_HEIGHT;
    }

    getHeight() {
        const slots = (this.duration * 60) / 30;
        return slots * SLOT_HEIGHT;
    }

    toJSON() {
        return {
            id: this.id,
            name: this.name,
            date: this.date,
            startTime: this.startTime,
            duration: this.duration,
            createdAt: this.createdAt
        };
    }

    static fromJSON(json) {
        return new Task(json.name, json.date, json.startTime, json.duration, json.id);
    }
}

// ============ 應用狀態管理 ============
class AppState {
    constructor() {
        this.tasks = [];
        this.selectedDate = this.getTodayString();
        this.currentMonth = new Date();
        this.loadFromStorage();
    }

    getTodayString() {
        const today = new Date();
        return today.toISOString().split('T')[0];
    }

    addTask(task) {
        this.tasks.push(task);
        this.saveToStorage();
    }

    removeTask(taskId) {
        this.tasks = this.tasks.filter(t => t.id !== taskId);
        this.saveToStorage();
    }

    getTasksForDate(date) {
        return this.tasks.filter(t => t.date === date).sort((a, b) => {
            return a.startTime.localeCompare(b.startTime);
        });
    }

    getTotalHoursForDate(date) {
        return this.getTasksForDate(date).reduce((sum, task) => sum + task.duration, 0);
    }

    saveToStorage() {
        try {
            const data = {
                tasks: this.tasks.map(t => t.toJSON()),
                version: 1
            };
            localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
        } catch (e) {
            console.error('Error saving to storage:', e);
        }
    }

    loadFromStorage() {
        try {
            const data = localStorage.getItem(STORAGE_KEY);
            if (data) {
                const parsed = JSON.parse(data);
                this.tasks = parsed.tasks.map(t => Task.fromJSON(t));
            }
        } catch (e) {
            console.error('Error loading from storage:', e);
            this.tasks = [];
        }
    }
}

// ============ 全局狀態和 DOM 元素 ============
const appState = new AppState();

const prevMonthBtn = document.getElementById('prevMonth');
const nextMonthBtn = document.getElementById('nextMonth');
const monthYearDisplay = document.getElementById('monthYear');
const calendarGrid = document.getElementById('calendar');
const scheduleGrid = document.getElementById('scheduleGrid');
const selectedDateDisplay = document.getElementById('selectedDate');
const totalHoursDisplay = document.getElementById('totalHours');

const taskNameInput = document.getElementById('taskName');
const startTimeSelect = document.getElementById('startTime');
const durationSelect = document.getElementById('duration');
const addTaskBtn = document.getElementById('addTaskBtn');

let draggedTask = null;

// ============ 初始化 ============
document.addEventListener('DOMContentLoaded', () => {
    initializeTimeSelects();
    renderCalendar();
    renderSchedule();
    setupEventListeners();
    console.log('✅ Tech Vibe 應用已加載');
});

function initializeTimeSelects() {
    for (let h = 0; h < 24; h++) {
        for (let m = 0; m < 60; m += 30) {
            const time = `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
            const option = document.createElement('option');
            option.value = time;
            option.textContent = time;
            startTimeSelect.appendChild(option);
        }
    }
    startTimeSelect.value = '09:00';
}

function setupEventListeners() {
    prevMonthBtn.addEventListener('click', () => {
        appState.currentMonth.setMonth(appState.currentMonth.getMonth() - 1);
        renderCalendar();
    });

    nextMonthBtn.addEventListener('click', () => {
        appState.currentMonth.setMonth(appState.currentMonth.getMonth() + 1);
        renderCalendar();
    });

    addTaskBtn.addEventListener('click', handleAddTask);
    taskNameInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') handleAddTask();
    });
}

// ============ 月曆渲染 ============
function renderCalendar() {
    const year = appState.currentMonth.getFullYear();
    const month = appState.currentMonth.getMonth();

    // 更新月份顯示
    monthYearDisplay.textContent = new Date(year, month).toLocaleDateString('zh-Hant', {
        year: 'numeric',
        month: 'long'
    });

    // 清空日期
    calendarGrid.innerHTML = '';

    // 獲取該月的第一天和天數
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const daysInPrevMonth = new Date(year, month, 0).getDate();

    // 添加前一月的灰色日期
    for (let i = firstDay - 1; i >= 0; i--) {
        const day = daysInPrevMonth - i;
        const date = new Date(year, month - 1, day);
        createDayElement(date, true);
    }

    // 添加本月日期
    for (let day = 1; day <= daysInMonth; day++) {
        const date = new Date(year, month, day);
        createDayElement(date, false);
    }

    // 添加下一月的灰色日期
    const totalCells = calendarGrid.children.length;
    const remainingCells = 42 - totalCells; // 6 週 × 7 天
    for (let day = 1; day <= remainingCells; day++) {
        const date = new Date(year, month + 1, day);
        createDayElement(date, true);
    }
}

function createDayElement(date, isOtherMonth) {
    const dayEl = document.createElement('div');
    dayEl.className = 'calendar-day';
    dayEl.textContent = date.getDate();

    if (isOtherMonth) {
        dayEl.classList.add('other-month');
    }

    const dateString = date.toISOString().split('T')[0];

    if (dateString === appState.selectedDate) {
        dayEl.classList.add('selected');
    }

    if (dateString === appState.getTodayString()) {
        dayEl.classList.add('today');
    }

    dayEl.addEventListener('click', () => {
        appState.selectedDate = dateString;
        renderCalendar();
        renderSchedule();
    });

    calendarGrid.appendChild(dayEl);
}

// ============ 日程表渲染 ============
function renderSchedule() {
    // 更新日期顯示
    const dateObj = new Date(appState.selectedDate);
    selectedDateDisplay.textContent = dateObj.toLocaleDateString('zh-Hant', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        weekday: 'long'
    });

    // 更新總時數
    const totalHours = appState.getTotalHoursForDate(appState.selectedDate);
    totalHoursDisplay.textContent = `今日規劃：${totalHours.toFixed(1)} 小時`;

    // 渲染時間標籤和槽位
    const timeLabelsContainer = document.querySelector('.time-labels');
    timeLabelsContainer.innerHTML = '';

    scheduleGrid.innerHTML = '';

    // 生成 24 小時 × 2 (每 0.5 小時一個槽位)
    const tasksForDate = appState.getTasksForDate(appState.selectedDate);

    // 添加時間標籤
    for (let h = 0; h < 24; h++) {
        const labelEl = document.createElement('div');
        labelEl.className = 'time-label hour';
        labelEl.textContent = `${String(h).padStart(2, '0')}:00`;
        timeLabelsContainer.appendChild(labelEl);

        // 每小時之間的半點
        const halfLabelEl = document.createElement('div');
        halfLabelEl.className = 'time-label';
        timeLabelsContainer.appendChild(halfLabelEl);
    }

    // 設置日程網格高度
    scheduleGrid.style.height = `${24 * SLOT_HEIGHT * 2}px`;

    // 渲染任務
    tasksForDate.forEach(task => {
        renderTask(task);
    });

    // 如果沒有任務，顯示提示
    if (tasksForDate.length === 0) {
        const emptyEl = document.createElement('div');
        emptyEl.className = 'empty-state';
        emptyEl.textContent = '點擊左側「新增任務」添加日程';
        scheduleGrid.appendChild(emptyEl);
    }
}

function renderTask(task) {
    const taskEl = document.createElement('div');
    taskEl.className = 'task-item';
    taskEl.dataset.taskId = task.id;
    taskEl.style.top = task.getTopPosition() + 'px';
    taskEl.style.height = task.getHeight() + 'px';

    taskEl.innerHTML = `
        <span class="task-name">${escapeHtml(task.name)}</span>
        <button class="task-delete" title="刪除">×</button>
    `;

    taskEl.querySelector('.task-delete').addEventListener('click', (e) => {
        e.stopPropagation();
        if (confirm('確定要刪除此任務嗎？')) {
            appState.removeTask(task.id);
            renderSchedule();
            showNotification('已刪除任務');
        }
    });

    taskEl.draggable = true;
    taskEl.addEventListener('dragstart', (e) => {
        draggedTask = task;
        taskEl.classList.add('dragging');
    });
    taskEl.addEventListener('dragend', () => {
        taskEl.classList.remove('dragging');
    });

    scheduleGrid.appendChild(taskEl);
}

// ============ 新增任務 ============
function handleAddTask() {
    const name = taskNameInput.value.trim();
    const startTime = startTimeSelect.value;
    const duration = parseFloat(durationSelect.value);

    if (!name) {
        alert('請輸入任務名稱');
        return;
    }

    const task = new Task(name, appState.selectedDate, startTime, duration);
    appState.addTask(task);

    // 清空輸入
    taskNameInput.value = '';
    startTimeSelect.value = '09:00';
    durationSelect.value = '2';

    renderSchedule();
    showNotification(`已新增「${name}」`);
}

// ============ 工具函數 ============
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function showNotification(message) {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4caf50;
        color: white;
        padding: 12px 20px;
        border-radius: 6px;
        font-size: 14px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        z-index: 1000;
        animation: slideIn 0.3s ease-out;
    `;
    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => notification.remove(), 300);
    }, 2500);
}

// 動畫定義
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(400px); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(400px); opacity: 0; }
    }
`;
document.head.appendChild(style);
