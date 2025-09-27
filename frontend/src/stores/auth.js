import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { userApi } from '@/api/user'
import api from '../api'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(localStorage.getItem('user') || '')
  
  const isAuthenticated = computed(() => !!token.value)
  
  async function login(credentials) {
    try {
      const formData = new FormData()
      formData.append('username', credentials.username)
      formData.append('password', credentials.password)
      const response = await userApi.login(formData)
      token.value = response.access_token
      user.value = response.user
      
      localStorage.setItem('token', token.value)
      localStorage.setItem('user', JSON.stringify(user.value))
      
      // 设置 api 默认请求头
      api.defaults.headers.common['Authorization'] = `Bearer ${token.value}`
      
      return { success: true }
    } catch (error) {
      return { 
        success: false, 
        message: error.response?.data?.detail || '登录失败，请检查您的凭据'
      }
    }
  }
  
  function logout() {
    token.value = ''
    user.value = null
    
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    
    // 清除 api 默认请求头
    delete api.defaults.headers.common['Authorization']
  }
  
  // 初始化 api 请求头
  if (token.value) {
    api.defaults.headers.common['Authorization'] = `Bearer ${token.value}`
  }
  
  return { 
    token,
    user,
    isAuthenticated,
    login,
    logout
  }
})