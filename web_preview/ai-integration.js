/**
 * Tech Vibe AI 整合模組
 * 負責與後端 API 通信，調用 Hugging Face 模型進行任務分解
 */

const API_BASE_URL = 'http://localhost:3000'; // 開發環境
// const API_BASE_URL = 'https://your-production-api.com'; // 生產環境

/**
 * 調用後端 API 進行任務分解
 * @param {string} taskDescription - 任務描述文字
 * @returns {Promise<Object>} API 回應
 * 
 * 使用示例：
 * const result = await callDecomposeAPI('準備跨年派對');
 * if (result.status === 'success') {
 *   console.log(result.data.output);
 * } else {
 *   console.error(result.error);
 * }
 */
async function callDecomposeAPI(taskDescription) {
  try {
    // 驗證輸入
    if (!taskDescription || taskDescription.trim() === '') {
      return {
        status: 'error',
        data: null,
        error: '任務描述不能為空'
      };
    }

    // 發送請求到後端
    const response = await fetch(`${API_BASE_URL}/api/decompose`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        taskDescription: taskDescription.trim()
      })
    });

    // 檢查回應狀態
    if (!response.ok) {
      const errorData = await response.json();
      return {
        status: 'error',
        data: null,
        error: errorData.error || `HTTP ${response.status} 錯誤`
      };
    }

    // 解析並返回成功回應
    const data = await response.json();
    return data;

  } catch (error) {
    // 捕捉網路或其他錯誤
    return {
      status: 'error',
      data: null,
      error: `網路錯誤: ${error.message}`
    };
  }
}

/**
 * 檢查後端服務是否運行
 * @returns {Promise<boolean>}
 */
async function checkBackendHealth() {
  try {
    const response = await fetch(`${API_BASE_URL}/health`);
    return response.ok;
  } catch (error) {
    return false;
  }
}

/**
 * 解析 AI 輸出並轉換為任務物件
 * @param {string} aiOutput - AI 生成的文本
 * @returns {Array<Object>} 任務物件陣列
 * 
 * 示例輸出格式：
 * [
 *   { name: "聯繫朋友並發送邀請", duration: 0.5 },
 *   { name: "購買派對用品和食物", duration: 2 },
 * ]
 */
function parseAIOutput(aiOutput) {
  const tasks = [];
  const lines = aiOutput.split('\n').filter(line => line.trim());

  for (const line of lines) {
    // 匹配格式: "1. [任務名稱] - 預計時間：X小時"
    const match = line.match(/[\d]+\.\s*(.+?)\s*[-－]\s*預計時間[：:]\s*([\d.]+)/);
    if (match) {
      tasks.push({
        name: match[1].trim(),
        duration: parseFloat(match[2])
      });
    }
  }

  return tasks;
}

/**
 * 完整流程示例：從任務描述到創建任務
 * @param {string} taskDescription - 任務描述
 * @param {Function} createTaskCallback - 創建任務的回調函數
 * @returns {Promise<void>}
 */
async function decomposeAndCreateTasks(taskDescription, createTaskCallback) {
  try {
    // 1. 調用 AI API
    const result = await callDecomposeAPI(taskDescription);

    if (result.status !== 'success') {
      alert(`AI 分析失敗: ${result.error}`);
      return;
    }

    // 2. 解析 AI 輸出
    const parsedTasks = parseAIOutput(result.data.output);

    if (parsedTasks.length === 0) {
      alert('無法從 AI 回應中提取任務。請重試或手動添加任務。');
      console.log('AI 原始輸出:', result.data.output);
      return;
    }

    // 3. 創建任務
    for (const task of parsedTasks) {
      await createTaskCallback({
        name: task.name,
        duration: task.duration,
        startTime: '09:00' // 預設開始時間
      });
    }

    console.log(`✅ 成功建立 ${parsedTasks.length} 個子任務`);

  } catch (error) {
    console.error('任務分解流程出錯:', error);
    alert(`發生錯誤: ${error.message}`);
  }
}

// 導出函數（供 HTML 中的 script 使用）
window.AIIntegration = {
  callDecomposeAPI,
  checkBackendHealth,
  parseAIOutput,
  decomposeAndCreateTasks,
  API_BASE_URL
};
