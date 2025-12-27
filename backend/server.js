import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const HF_API_TOKEN = process.env.HUGGING_FACE_API_TOKEN;
const HF_API_URL = 'https://api-inference.huggingface.co/models/google/flan-t5-base';

// 中介軟體
app.use(cors());
app.use(express.json());

// 健康檢查端點
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Tech Vibe Backend is running' });
});

// 任務分解 API 端點
// POST /api/decompose
// Request Body:
// {
//   "taskDescription": "準備跨年派對，邀請朋友，佈置場地，準備食物和飲料"
// }
//
// Response:
// {
//   "status": "success",
//   "data": {
//     "input": "準備跨年派對，邀請朋友，佈置場地，準備食物和飲料",
//     "output": "模型的文字結果"
//   },
//   "error": null
// }
app.post('/api/decompose', async (req, res) => {
  try {
    const { taskDescription } = req.body;

    // 驗證輸入
    if (!taskDescription || typeof taskDescription !== 'string') {
      return res.status(400).json({
        status: 'error',
        data: null,
        error: '缺少必要的 taskDescription 欄位或格式不正確'
      });
    }

    if (!HF_API_TOKEN) {
      return res.status(500).json({
        status: 'error',
        data: null,
        error: '伺服器未設定 Hugging Face API Token'
      });
    }

    // 構建提示詞 - 引導模型進行任務拆解
    const prompt = `將下列任務拆解成具體的子任務，並估算每項任務的時間（單位：小時）。請用清晰的格式列出。

任務: ${taskDescription}

請按照以下格式回答：
1. [子任務名稱] - 預計時間：X小時
2. [子任務名稱] - 預計時間：X小時
...

回答：`;

    // 呼叫 Hugging Face Inference API
    const hfResponse = await fetch(HF_API_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${HF_API_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        inputs: prompt,
        parameters: {
          max_length: 500,
          temperature: 0.7,
          top_p: 0.9
        }
      })
    });

    // 檢查回應狀態
    if (!hfResponse.ok) {
      const errorText = await hfResponse.text();
      console.error('Hugging Face API Error:', hfResponse.status, errorText);
      return res.status(hfResponse.status).json({
        status: 'error',
        data: null,
        error: `Hugging Face API 錯誤: ${hfResponse.status}`
      });
    }

    // 解析回應
    const responseData = await hfResponse.json();
    
    // 提取模型的輸出文本
    // Hugging Face flan-t5-base 的回應格式是陣列
    let output = '';
    if (Array.isArray(responseData) && responseData.length > 0) {
      output = responseData[0].generated_text || '';
    } else if (responseData.generated_text) {
      output = responseData.generated_text;
    }

    res.json({
      status: 'success',
      data: {
        input: taskDescription,
        output: output.trim()
      },
      error: null
    });

  } catch (error) {
    console.error('Server Error:', error);
    res.status(500).json({
      status: 'error',
      data: null,
      error: `伺服器錯誤: ${error.message}`
    });
  }
});

// 啟動伺服器
app.listen(PORT, () => {
  console.log(`🚀 Tech Vibe Backend running on http://localhost:${PORT}`);
  console.log(`📝 Task decompose API: POST http://localhost:${PORT}/api/decompose`);
  console.log(`🏥 Health check: GET http://localhost:${PORT}/health`);
});
