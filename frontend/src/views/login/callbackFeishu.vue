<template>
  <div class="callback-container">
    <div class="spinner"></div>
    <p>登录中，请稍候...</p>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const router = useRouter()

onMounted(async () => {
  const code = route.query.code
  const state = route.query.state
  const savedState = localStorage.getItem('feishu_state')

  // 校验 state，防止 CSRF 攻击
  if (!code || !state || state !== savedState) {
    alert('登录失败：无效的请求')
    router.push('/login')
    return
  }

    try {

    alert('返回code:'+code)
    // 调用后端接口，用 code 换取 token
    const res = await axios.post('/api/feishu/login', { code })

    if (res.data.token) {
      localStorage.setItem('TOKEN', res.data.token)
      router.push('/') // 登录成功跳首页
    } else {
      alert('登录失败')
      router.push('/login')
    }
  } catch (err) {
    console.error(err)
    alert('请求后端接口失败')
    router.push('/login')
  } finally {
    localStorage.removeItem('feishu_state')
    localStorage.removeItem('TOKEN')
  }
})
</script>

<style scoped>
.callback-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background-color: #f5f5f5;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(0, 101, 255, 0.2);
  border-left-color: #0065FF;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

p {
  margin-top: 16px;
  color: #333;
}
</style>