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

let prevMonthBtn, nextMonthBtn, monthYearDisplay, calendarGrid, scheduleGrid;
let selectedDateDisplay, totalHoursDisplay;
let taskNameInput, startTimeSelect, durationSelect, addTaskBtn;

function initializeDOMElements() {
    prevMonthBtn = document.getElementById('prevMonth');
    nextMonthBtn = document.getElementById('nextMonth');
    monthYearDisplay = document.getElementById('monthYear');
    calendarGrid = document.getElementById('calendar');
    scheduleGrid = document.getElementById('scheduleGrid');
    selectedDateDisplay = document.getElementById('selectedDate');
    totalHoursDisplay = document.getElementById('totalHours');

    taskNameInput = document.getElementById('taskName');
    startTimeSelect = document.getElementById('startTime');
    durationSelect = document.getElementById('duration');
    addTaskBtn = document.getElementById('addTaskBtn');
}

let draggedTask = null;

// ============ 初始化 ============
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOMContentLoaded 觸發');
    
    initializeDOMElements();
    initializeTimeSelects();
    renderCalendar();
    renderSchedule();
    setupEventListeners();
    
    console.log('✅ Tech Vibe 應用已加載');
});

function initializeTimeSelects() {
    console.log('初始化時間選擇器...');
    
    if (!startTimeSelect) {
        console.error('startTimeSelect 不存在');
        return;
    }
    
    // 清空現有選項
    startTimeSelect.innerHTML = '';
    
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
    console.log('時間選擇器初始化完成');
}

function setupEventListeners() {
    console.log('設置事件監聽...');
    
    if (prevMonthBtn) {
        prevMonthBtn.addEventListener('click', () => {
            appState.currentMonth.setMonth(appState.currentMonth.getMonth() - 1);
            renderCalendar();
        });
    }

    if (nextMonthBtn) {
        nextMonthBtn.addEventListener('click', () => {
            appState.currentMonth.setMonth(appState.currentMonth.getMonth() + 1);
            renderCalendar();
        });
    }

    if (addTaskBtn) {
        addTaskBtn.addEventListener('click', handleAddTask);
    }

    if (taskNameInput) {
        taskNameInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') handleAddTask();
        });
    }
    
    console.log('事件監聽設置完成');
}

// ============ 月曆渲染 ============
function renderCalendar() {
    console.log('渲染月曆');
    
    const year = appState.currentMonth.getFullYear();
    const month = appState.currentMonth.getMonth();

    // 更新月份顯示
    if (monthYearDisplay) {
        monthYearDisplay.textContent = new Date(year, month).toLocaleDateString('zh-Hant', {
            year: 'numeric',
            month: 'long'
        });
    }

    // 清空日期
    if (calendarGrid) {
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

    if (!isOtherMonth) {
        dayEl.addEventListener('click', () => {
            appState.selectedDate = dateString;
            renderCalendar();
            renderSchedule();
        });
    }

    if (calendarGrid) {
        calendarGrid.appendChild(dayEl);
    }
}

// ============ 日程表渲染 ============
function renderSchedule() {
    console.log('渲染日程表，日期：', appState.selectedDate);
    
    // 更新日期顯示
    if (selectedDateDisplay) {
        const dateObj = new Date(appState.selectedDate);
        selectedDateDisplay.textContent = dateObj.toLocaleDateString('zh-Hant', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            weekday: 'long'
        });
    }

    // 更新總時數
    if (totalHoursDisplay) {
        const totalHours = appState.getTotalHoursForDate(appState.selectedDate);
        totalHoursDisplay.textContent = `今日規劃：${totalHours.toFixed(1)} 小時`;
    }

    // 清空日程網格
    if (scheduleGrid) {
        scheduleGrid.innerHTML = '';

        const tasksForDate = appState.getTasksForDate(appState.selectedDate);

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
}

function renderTask(task) {
    if (!scheduleGrid) return;
    
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
    console.log('處理新增任務');
    
    if (!taskNameInput || !startTimeSelect || !durationSelect) {
        console.error('輸入元素缺失');
        return;
    }
    
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

// 在 renderSchedule 函數之後添加時間標籤渲染
function renderTimeLabels() {
    const timeLabelsContainer = document.getElementById('timeLabels');
    if (!timeLabelsContainer) {
        console.error('timeLabels 容器不存在');
        return;
    }
    
    timeLabelsContainer.innerHTML = '';

    for (let h = 0; h < 24; h++) {
        const labelEl = document.createElement('div');
        labelEl.className = 'time-label hour';
        labelEl.textContent = `${String(h).padStart(2, '0')}:00`;
        timeLabelsContainer.appendChild(labelEl);

        const halfLabelEl = document.createElement('div');
        halfLabelEl.className = 'time-label';
        timeLabelsContainer.appendChild(halfLabelEl);
    }
}

// 修改 renderSchedule 以包含時間標籤
const originalRenderSchedule = renderSchedule;
renderSchedule = function() {
    originalRenderSchedule();
    renderTimeLabels();
};
