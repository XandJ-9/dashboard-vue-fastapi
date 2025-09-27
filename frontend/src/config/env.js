// 环境变量配置文件

// 获取环境变量，如果不存在则使用默认值
const getEnvVariable = (key, defaultValue = '') => {
  return import.meta.env[key] || defaultValue
}

export const config = {
  // 当前环境
  env: getEnvVariable('VITE_APP_ENV', 'development'),
  // API基础URL
  apiUrl: getEnvVariable('VITE_APP_API_URL', 'http://localhost:8000'),
  // API前缀
  apiPrefix: getEnvVariable('VITE_APP_API_PREFIX', '/api'),
  // 应用标题
  appTitle: getEnvVariable('VITE_APP_TITLE', '管理后台'),
  // 判断是否为生产环境
  isProd: getEnvVariable('VITE_APP_ENV') === 'production',
  // 判断是否为开发环境
  isDev: getEnvVariable('VITE_APP_ENV') === 'development' || !getEnvVariable('VITE_APP_ENV'),
}

export default config