<template>
  <div>
    <h2 class="my-6 text-2xl font-semibold text-gray-700 dark:text-gray-200">
      仪表盘
    </h2>
    
    <!-- 卡片统计 -->
    <div class="grid gap-6 mb-8 md:grid-cols-2 xl:grid-cols-4">
      <!-- 用户统计卡片 -->
      <div class="flex items-center p-4 bg-white rounded-lg shadow-xs dark:bg-gray-800">
        <div class="p-3 mr-4 text-orange-500 bg-orange-100 rounded-full dark:text-orange-100 dark:bg-orange-500">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z"></path>
          </svg>
        </div>
        <div>
          <p class="mb-2 text-sm font-medium text-gray-600 dark:text-gray-400">
            总用户数
          </p>
          <p class="text-lg font-semibold text-gray-700 dark:text-gray-200">
            {{ stats.totalUsers }}
          </p>
        </div>
      </div>
      
      <!-- 收入统计卡片 -->
      <div class="flex items-center p-4 bg-white rounded-lg shadow-xs dark:bg-gray-800">
        <div class="p-3 mr-4 text-green-500 bg-green-100 rounded-full dark:text-green-100 dark:bg-green-500">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4 4a2 2 0 00-2 2v4a2 2 0 002 2V6h10a2 2 0 00-2-2H4zm2 6a2 2 0 012-2h8a2 2 0 012 2v4a2 2 0 01-2 2H8a2 2 0 01-2-2v-4zm6 4a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"></path>
          </svg>
        </div>
        <div>
          <p class="mb-2 text-sm font-medium text-gray-600 dark:text-gray-400">
            本月收入
          </p>
          <p class="text-lg font-semibold text-gray-700 dark:text-gray-200">
            ¥ {{ stats.monthlyRevenue.toLocaleString() }}
          </p>
        </div>
      </div>
      
      <!-- 新订单统计卡片 -->
      <div class="flex items-center p-4 bg-white rounded-lg shadow-xs dark:bg-gray-800">
        <div class="p-3 mr-4 text-blue-500 bg-blue-100 rounded-full dark:text-blue-100 dark:bg-blue-500">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path d="M3 1a1 1 0 000 2h1.22l.305 1.222a.997.997 0 00.01.042l1.358 5.43-.893.892C3.74 11.846 4.632 14 6.414 14H15a1 1 0 000-2H6.414l1-1H14a1 1 0 00.894-.553l3-6A1 1 0 0017 3H6.28l-.31-1.243A1 1 0 005 1H3zM16 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM6.5 18a1.5 1.5 0 100-3 1.5 1.5 0 000 3z"></path>
          </svg>
        </div>
        <div>
          <p class="mb-2 text-sm font-medium text-gray-600 dark:text-gray-400">
            新订单
          </p>
          <p class="text-lg font-semibold text-gray-700 dark:text-gray-200">
            {{ stats.newOrders }}
          </p>
        </div>
      </div>
      
      <!-- 访问量统计卡片 -->
      <div class="flex items-center p-4 bg-white rounded-lg shadow-xs dark:bg-gray-800">
        <div class="p-3 mr-4 text-teal-500 bg-teal-100 rounded-full dark:text-teal-100 dark:bg-teal-500">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zM7 8H5v2h2V8zm2 0h2v2H9V8zm6 0h-2v2h2V8z" clip-rule="evenodd"></path>
          </svg>
        </div>
        <div>
          <p class="mb-2 text-sm font-medium text-gray-600 dark:text-gray-400">
            访问量
          </p>
          <p class="text-lg font-semibold text-gray-700 dark:text-gray-200">
            {{ stats.pageViews.toLocaleString() }}
          </p>
        </div>
      </div>
    </div>
    
    <!-- 图表和表格 -->
    <div class="grid gap-6 mb-8 md:grid-cols-2">
      <!-- 图表 -->
      <div class="min-w-0 p-4 bg-white rounded-lg shadow-xs dark:bg-gray-800">
        <h4 class="mb-4 font-semibold text-gray-800 dark:text-gray-300">
          收入趋势
        </h4>
        <div class="h-64 px-2 py-3">
          <!-- 这里可以集成图表库，如 Chart.js 或 ECharts -->
          <div class="flex items-center justify-center h-full text-gray-500 dark:text-gray-400">
            图表区域 - 集成图表库后显示
          </div>
        </div>
      </div>
      
      <!-- 最近活动 -->
      <div class="min-w-0 p-4 bg-white rounded-lg shadow-xs dark:bg-gray-800">
        <h4 class="mb-4 font-semibold text-gray-800 dark:text-gray-300">
          最近活动
        </h4>
        <div class="w-full overflow-hidden rounded-lg shadow-xs">
          <div class="w-full overflow-x-auto">
            <table class="w-full whitespace-no-wrap">
              <thead>
                <tr class="text-xs font-semibold tracking-wide text-left text-gray-500 uppercase border-b dark:border-gray-700 bg-gray-50 dark:text-gray-400 dark:bg-gray-800">
                  <th class="px-4 py-3">用户</th>
                  <th class="px-4 py-3">活动</th>
                  <th class="px-4 py-3">时间</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y dark:divide-gray-700 dark:bg-gray-800">
                <tr v-for="(activity, i) in recentActivities" :key="i" class="text-gray-700 dark:text-gray-400">
                  <td class="px-4 py-3">
                    <div class="flex items-center text-sm">
                      <div class="relative hidden w-8 h-8 mr-3 rounded-full md:block">
                        <img class="object-cover w-full h-full rounded-full" :src="activity.avatar" alt="" loading="lazy" />
                      </div>
                      <div>
                        <p class="font-semibold">{{ activity.user }}</p>
                      </div>
                    </div>
                  </td>
                  <td class="px-4 py-3 text-sm">
                    {{ activity.action }}
                  </td>
                  <td class="px-4 py-3 text-sm">
                    {{ activity.time }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// 模拟数据
const stats = ref({
  totalUsers: 12024,
  monthlyRevenue: 46389.45,
  newOrders: 376,
  pageViews: 78961
})

const recentActivities = ref([
  {
    user: '张三',
    avatar: 'https://avatars.dicebear.com/api/initials/zs.svg',
    action: '创建了新订单 #12345',
    time: '刚刚'
  },
  {
    user: '李四',
    avatar: 'https://avatars.dicebear.com/api/initials/ls.svg',
    action: '更新了个人资料',
    time: '10 分钟前'
  },
  {
    user: '王五',
    avatar: 'https://avatars.dicebear.com/api/initials/ww.svg',
    action: '完成了订单 #12340',
    time: '1 小时前'
  },
  {
    user: '赵六',
    avatar: 'https://avatars.dicebear.com/api/initials/zl.svg',
    action: '添加了新产品',
    time: '2 小时前'
  },
  {
    user: '钱七',
    avatar: 'https://avatars.dicebear.com/api/initials/qq.svg',
    action: '回复了工单 #5678',
    time: '3 小时前'
  }
])

// 模拟加载数据
onMounted(() => {
  // 这里可以添加实际的API调用
  console.log('Dashboard mounted')
})
</script>