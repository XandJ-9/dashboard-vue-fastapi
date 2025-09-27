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
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import officeLightImg from '../assets/images/office-light.jpg'
import officeDarkImg from '../assets/images/office-dark.jpg'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

// 表单数据
const username = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

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
</script>