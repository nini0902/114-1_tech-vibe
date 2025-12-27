// 常數定義
const BASE_UNIT = 30; // pixels per hour
const CONTAINER_HEIGHT = 480; // pixels (16 hours)
const STORAGE_KEY = 'tech_vibe_tasks';

// 任務類
class Task {
    constructor(name, duration, id = null, position = 'pool') {
        this.id = id || this.generateId();
        this.name = name;
        this.duration = parseFloat(duration);
        this.position = position; // 'pool' or 'container'
        this.createdAt = new Date().toISOString();
    }

    generateId() {
        return 'task_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }

    getHeight() {
        return this.duration * BASE_UNIT;
    }

    formatDuration() {
        if (this.duration === 0.5) return '30 分鐘';
        if (this.duration === 1.5) return '1.5 小時';
        if (Number.isInteger(this.duration)) return `${this.duration} 小時`;
        return `${this.duration} 小時`;
    }
}

// 應用狀態管理
class AppState {
    constructor() {
        this.tasks = [];
        this.loadFromStorage();
    }

    addTask(name, duration) {
        const task = new Task(name, duration);
        this.tasks.push(task);
        this.saveToStorage();
        return task;
    }

    removeTask(taskId) {
        this.tasks = this.tasks.filter(t => t.id !== taskId);
        this.saveToStorage();
    }

    getTasksInPool() {
        return this.tasks.filter(t => t.position === 'pool');
    }

    getTasksInContainer() {
        return this.tasks.filter(t => t.position === 'container');
    }

    moveTaskToContainer(taskId) {
        const task = this.tasks.find(t => t.id === taskId);
        if (task) {
            task.position = 'container';
            this.saveToStorage();
        }
    }

    moveTaskOutOfContainer(taskId) {
        const task = this.tasks.find(t => t.id === taskId);
        if (task) {
            task.position = 'pool';
            this.saveToStorage();
        }
    }

    getTotalDurationInContainer() {
        return this.getTasksInContainer().reduce((sum, task) => sum + task.duration, 0);
    }

    saveToStorage() {
        const data = {
            tasks: this.tasks.map(task => ({
                id: task.id,
                name: task.name,
                duration: task.duration,
                position: task.position,
                createdAt: task.createdAt
            }))
        };
        localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    }

    loadFromStorage() {
        try {
            const data = localStorage.getItem(STORAGE_KEY);
            if (data) {
                const parsed = JSON.parse(data);
                this.tasks = parsed.tasks.map(t => new Task(t.name, t.duration, t.id, t.position));
            }
        } catch (e) {
            console.error('Error loading from storage:', e);
            this.tasks = [];
        }
    }
}

// 全局狀態
const appState = new AppState();
let draggedTaskId = null;

// DOM 元素
const taskNameInput = document.getElementById('taskName');
const taskDurationSelect = document.getElementById('taskDuration');
const addTaskBtn = document.getElementById('addTaskBtn');
const taskPool = document.getElementById('taskPool');
const dayContainer = document.getElementById('dayContainer');

// 事件監聽
addTaskBtn.addEventListener('click', handleAddTask);
taskNameInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') handleAddTask();
});

taskPool.addEventListener('dragover', handleDragOver);
taskPool.addEventListener('drop', handleDropOnPool);
taskPool.addEventListener('dragleave', handleDragLeave);

dayContainer.addEventListener('dragover', handleDragOver);
dayContainer.addEventListener('drop', handleDropOnContainer);
dayContainer.addEventListener('dragleave', handleDragLeave);

// 處理新增任務
function handleAddTask() {
    const name = taskNameInput.value.trim();
    const duration = taskDurationSelect.value;

    if (!name) {
        alert('請輸入任務名稱');
        return;
    }

    appState.addTask(name, duration);
    taskNameInput.value = '';
    taskDurationSelect.value = '2';

    renderUI();
    showNotification('已新增任務');
}

// 處理任務刪除
function handleDeleteTask(taskId) {
    if (confirm('確定要刪除此任務嗎？')) {
        appState.removeTask(taskId);
        renderUI();
        showNotification('已刪除任務');
    }
}

// 拖曳事件處理
function handleDragStart(e, taskId) {
    draggedTaskId = taskId;
    e.target.classList.add('dragging');
    e.dataTransfer.effectAllowed = 'move';
}

function handleDragEnd(e) {
    e.target.classList.remove('dragging');
}

function handleDragOver(e) {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
    e.currentTarget.classList.add('drag-over');
}

function handleDragLeave(e) {
    e.currentTarget.classList.remove('drag-over');
}

function handleDropOnPool(e) {
    e.preventDefault();
    e.currentTarget.classList.remove('drag-over');
    if (draggedTaskId) {
        appState.moveTaskOutOfContainer(draggedTaskId);
        renderUI();
    }
}

function handleDropOnContainer(e) {
    e.preventDefault();
    e.currentTarget.classList.remove('drag-over');
    if (draggedTaskId) {
        appState.moveTaskToContainer(draggedTaskId);
        renderUI();
    }
}

// 創建任務區塊 DOM
function createTaskBlockElement(task) {
    const block = document.createElement('div');
    block.className = `task-block ${task.position === 'container' ? 'in-container' : ''}`;
    
    if (task.position === 'container') {
        block.style.height = task.getHeight() + 'px';
    }

    block.draggable = true;
    block.addEventListener('dragstart', (e) => handleDragStart(e, task.id));
    block.addEventListener('dragend', handleDragEnd);

    block.innerHTML = `
        <div class="task-name">${escapeHtml(task.name)}</div>
        <div class="task-duration">${task.formatDuration()}</div>
        <button class="task-delete-btn" title="刪除任務">×</button>
    `;

    block.querySelector('.task-delete-btn').addEventListener('click', () => {
        handleDeleteTask(task.id);
    });

    return block;
}

// 轉義 HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// 更新 UI
function renderUI() {
    // 更新任務池
    const tasksInPool = appState.getTasksInPool();
    taskPool.innerHTML = '';

    if (tasksInPool.length === 0) {
        const emptyState = document.createElement('div');
        emptyState.className = 'empty-state';
        emptyState.textContent = '拖曳任務到右側\n開始規劃一天';
        taskPool.appendChild(emptyState);
    } else {
        tasksInPool.forEach(task => {
            taskPool.appendChild(createTaskBlockElement(task));
        });
    }

    // 更新容器
    const tasksInContainer = appState.getTasksInContainer();
    dayContainer.innerHTML = '';

    if (tasksInContainer.length === 0) {
        const emptyState = document.createElement('div');
        emptyState.className = 'empty-state';
        emptyState.textContent = '拖曳任務到這裡';
        dayContainer.appendChild(emptyState);
    } else {
        tasksInContainer.forEach(task => {
            dayContainer.appendChild(createTaskBlockElement(task));
        });

        // 顯示總時長提示
        const totalDuration = appState.getTotalDurationInContainer();
        if (totalDuration > 16) {
            const warning = document.createElement('div');
            warning.style.cssText = `
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: #ff9800;
                color: white;
                padding: 12px 16px;
                border-radius: 6px;
                font-size: 14px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                z-index: 1000;
            `;
            warning.textContent = `⚠️ 今日規劃超時：${totalDuration.toFixed(1)} 小時`;
            document.body.appendChild(warning);
            setTimeout(() => warning.remove(), 3000);
        }
    }
}

// 顯示通知
function showNotification(message) {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: #4caf50;
        color: white;
        padding: 12px 20px;
        border-radius: 6px;
        font-size: 14px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        z-index: 1000;
        animation: slideDown 0.3s ease-out;
    `;
    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideUp 0.3s ease-out';
        setTimeout(() => notification.remove(), 300);
    }, 2500);
}

// 初始化
document.addEventListener('DOMContentLoaded', () => {
    renderUI();
    console.log('✅ Tech Vibe 應用已加載');
});
