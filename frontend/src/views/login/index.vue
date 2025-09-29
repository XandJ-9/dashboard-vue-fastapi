<template>
  <div class="flex items-center min-h-screen p-6 bg-gray-50 dark:bg-gray-900">
    <div class="h-full max-w-4xl mx-auto overflow-hidden bg-white rounded-lg shadow-xl dark:bg-gray-800">
      <div class="flex flex-col overflow-y-auto md:flex-row">
        <div class="h-32 md:h-auto md:w-1/2">
          <img
            aria-hidden="true"
            class="object-cover w-full h-full dark:hidden"
            :src="officeLightImg"
            alt="Office"
          />
          <img
            aria-hidden="true"
            class="hidden object-cover w-full h-full dark:block"
            :src="officeDarkImg"
            alt="Office"
          />
        </div>
        <div class="flex items-center justify-center p-6 sm:p-12 md:w-1/2">
          <div class="w-full">
            <h1 class="mb-4 text-xl font-semibold text-gray-700 dark:text-gray-200">
              登录
            </h1>
            <form @submit.prevent="handleLogin">
              <div class="mb-4">
                <label class="block text-sm">
                  <span class="text-gray-700 dark:text-gray-400">用户名</span>
                  <input
                    v-model="username"
                    class="input text-sm dark:border-gray-600 dark:bg-gray-700 focus:border-primary-400 focus:outline-none focus:shadow-outline-primary dark:text-gray-300 dark:focus:shadow-outline-gray"
                    placeholder="请输入用户名"
                  />
                </label>
              </div>
              <div class="mb-6">
                <label class="block text-sm">
                  <span class="text-gray-700 dark:text-gray-400">密码</span>
                  <input
                    v-model="password"
                    class="input text-sm dark:border-gray-600 dark:bg-gray-700 focus:border-primary-400 focus:outline-none focus:shadow-outline-primary dark:text-gray-300 dark:focus:shadow-outline-gray"
                    placeholder="请输入密码"
                    type="password"
                  />
                </label>
              </div>
              
              <!-- 错误提示 -->
              <div v-if="error" class="mb-4 text-sm text-red-600 dark:text-red-400">
                {{ error }}
              </div>
              
              <!-- 登录按钮 -->
              <button
                type="submit"
                class="btn-primary w-full mt-4 text-sm font-medium leading-5 text-center transition-colors duration-150"
                :disabled="loading"
              >
                {{ loading ? '登录中...' : '登录' }}
              </button>
            </form>

            <hr class="my-8" />

            <p class="mt-4">
              <a
                class="text-sm font-medium text-primary-500 dark:text-primary-400 hover:underline"
                href="#"
              >
                忘记密码?
              </a>
            </p>
            <p class="mt-1">
              <a
                class="text-sm font-medium text-primary-500 dark:text-primary-400 hover:underline"
                href="#"
              >
                创建账户
              </a>
            </p>

            <hr class="my-8" />
            <button @click="goFeishuLogin" class="btn-secondary w-full mt-4 text-sm font-medium leading-5 text-center transition-colors duration-150 flex items-center justify-center gap-2">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M16.6667 10C16.6667 13.3137 14.1667 16 10 16C5.83333 16 3.33333 13.3137 3.33333 10C3.33333 6.68629 5.83333 4 10 4C14.1667 4 16.6667 6.68629 16.6667 10Z" fill="white"/>
                <path d="M10 13.3333C11.8536 13.3333 13.3333 11.8536 13.3333 10C13.3333 8.14644 11.8536 6.66667 10 6.66667C8.14644 6.66667 6.66667 8.14644 6.66667 10C6.66667 11.8536 8.14644 13.3333 10 13.3333Z" fill="#0065FF"/>
                <path d="M13.3333 10C13.3333 11.8536 11.8536 13.3333 10 13.3333C8.14644 13.3333 6.66667 11.8536 6.66667 10C6.66667 8.14644 8.14644 6.66667 10 6.66667C11.8536 6.66667 13.3333 8.14644 13.3333 10Z" fill="white" fill-opacity="0.3"/>
            </svg>
            第三方登录
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import officeLightImg from '@/assets/images/office-light.jpg'
import officeDarkImg from '@/assets/images/office-dark.jpg'


const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

// 表单数据
const username = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

const FEISHU_APP_ID = import.meta
const FEISHU_REDIRECT_URI = import.meta



// 处理登录
const handleLogin = async () => {
  // 表单验证
  if (!username.value || !password.value) {
    error.value = '请输入用户名和密码'
    return
  }
  
  loading.value = true
  error.value = ''
  
  try {
    const result = await authStore.login({
      username: username.value,
      password: password.value
    })
    
    if (result.success) {
      // 登录成功，重定向到之前的页面或默认页面
      const redirectPath = route.query.redirect || '/'
      router.push(redirectPath)
    } else {
      error.value = result.message
    }
  } catch (err) {
    error.value = '登录失败，请稍后再试'
    console.error('Login error:', err)
  } finally {
    loading.value = false
  }
}


const goFeishuLogin = () => {
  // 生成随机 state，防止 CSRF
  const state = Math.random().toString(36).substring(2)
  localStorage.setItem('feishu_state', state)

  // 拼接飞书 OAuth 授权地址
  const authUrl = `https://open.feishu.cn/open-apis/authen/v1/index?app_id=${FEISHU_APP_ID}&redirect_uri=${FEISHU_REDIRECT_URI}&state=${state}`
  console.log('Redirecting to:', authUrl)
  window.location.href = authUrl
}
</script>