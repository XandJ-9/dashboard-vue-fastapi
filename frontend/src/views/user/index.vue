<template>
  <div>
    <h2 class="my-6 text-2xl font-semibold text-gray-700 dark:text-gray-200">
      用户管理
    </h2>
    
    <!-- 操作栏 -->
    <div class="flex justify-between mb-6">
      <div class="flex">
        <div class="relative w-64 mr-4">
          <input
            class="w-full pl-10 pr-4 py-2 rounded-lg shadow focus:outline-none focus:shadow-outline text-gray-600 font-medium border-gray-300 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-300"
            type="text"
            placeholder="搜索用户..."
            v-model="searchQuery"
            @input="handleSearch"
          />
          <div class="absolute top-0 left-0 inline-flex items-center p-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-400" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
              <rect x="0" y="0" width="24" height="24" stroke="none"></rect>
              <circle cx="10" cy="10" r="7" />
              <line x1="21" y1="21" x2="15" y2="15" />
            </svg>
          </div>
        </div>
        <div>
          <select
            class="block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-300"
            v-model="roleFilter"
            @change="handleFilter"
          >
            <option value="">所有角色</option>
            <option value="admin">管理员</option>
            <option value="user">普通用户</option>
            <option value="editor">编辑</option>
          </select>
        </div>
      </div>
      <div>
        <button
          class="px-4 py-2 text-sm font-medium leading-5 text-white transition-colors duration-150 bg-primary-600 border border-transparent rounded-lg active:bg-primary-600 hover:bg-primary-700 focus:outline-none focus:shadow-outline-primary"
          @click="openAddUserModal"
        >
          添加用户
        </button>
      </div>
    </div>
    
    <!-- 用户表格 -->
    <div class="w-full overflow-hidden rounded-lg shadow-xs">
      <div class="w-full overflow-x-auto">
        <table class="w-full whitespace-no-wrap">
          <thead>
            <tr class="text-xs font-semibold tracking-wide text-left text-gray-500 uppercase border-b dark:border-gray-700 bg-gray-50 dark:text-gray-400 dark:bg-gray-800">
              <th class="px-4 py-3">用户</th>
              <th class="px-4 py-3">角色</th>
              <th class="px-4 py-3">状态</th>
              <th class="px-4 py-3">注册日期</th>
              <th class="px-4 py-3">操作</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y dark:divide-gray-700 dark:bg-gray-800">
            <tr v-for="user in filteredUsers" :key="user.id" class="text-gray-700 dark:text-gray-400">
              <td class="px-4 py-3">
                <div class="flex items-center text-sm">
                  <div class="relative hidden w-8 h-8 mr-3 rounded-full md:block">
                    <img class="object-cover w-full h-full rounded-full" :src="user.avatar" alt="" loading="lazy" />
                  </div>
                  <div>
                    <p class="font-semibold">{{ user.name }}</p>
                    <p class="text-xs text-gray-600 dark:text-gray-400">{{ user.email }}</p>
                  </div>
                </div>
              </td>
              <td class="px-4 py-3 text-sm">
                <span
                  class="px-2 py-1 font-semibold leading-tight rounded-full"
                  :class="{
                    'text-green-700 bg-green-100 dark:bg-green-700 dark:text-green-100': user.role === 'admin',
                    'text-gray-700 bg-gray-100 dark:bg-gray-700 dark:text-gray-100': user.role === 'user',
                    'text-blue-700 bg-blue-100 dark:bg-blue-700 dark:text-blue-100': user.role === 'editor'
                  }"
                >
                  {{ getRoleName(user.role) }}
                </span>
              </td>
              <td class="px-4 py-3 text-xs">
                <span
                  class="px-2 py-1 font-semibold leading-tight rounded-full"
                  :class="{
                    'text-green-700 bg-green-100 dark:bg-green-700 dark:text-green-100': user.status === 'active',
                    'text-orange-700 bg-orange-100 dark:bg-orange-700 dark:text-orange-100': user.status === 'pending',
                    'text-red-700 bg-red-100 dark:bg-red-700 dark:text-red-100': user.status === 'banned'
                  }"
                >
                  {{ getStatusName(user.status) }}
                </span>
              </td>
              <td class="px-4 py-3 text-sm">
                {{ formatDate(user.created_at) }}
              </td>
              <td class="px-4 py-3 text-sm">
                <div class="flex items-center space-x-4 text-sm">
                  <button
                    class="flex items-center justify-between px-2 py-2 text-sm font-medium leading-5 text-primary-600 rounded-lg dark:text-gray-400 focus:outline-none focus:shadow-outline-gray"
                    aria-label="Edit"
                    @click="editUser(user)"
                  >
                    <svg class="w-5 h-5" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z"></path>
                    </svg>
                  </button>
                  <button
                    class="flex items-center justify-between px-2 py-2 text-sm font-medium leading-5 text-primary-600 rounded-lg dark:text-gray-400 focus:outline-none focus:shadow-outline-gray"
                    aria-label="Delete"
                    @click="deleteUser(user)"
                  >
                    <svg class="w-5 h-5" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <!-- 分页 -->
      <div class="grid px-4 py-3 text-xs font-semibold tracking-wide text-gray-500 uppercase border-t dark:border-gray-700 bg-gray-50 sm:grid-cols-9 dark:text-gray-400 dark:bg-gray-800">
        <span class="flex items-center col-span-3">
          显示 {{ pagination.from }}-{{ pagination.to }} 共 {{ pagination.total }} 条
        </span>
        <span class="col-span-2"></span>
        <span class="flex col-span-4 mt-2 sm:mt-auto sm:justify-end">
          <nav aria-label="Table navigation">
            <ul class="inline-flex items-center">
              <li>
                <button
                  class="px-3 py-1 rounded-md rounded-l-lg focus:outline-none focus:shadow-outline-primary"
                  aria-label="Previous"
                  :disabled="pagination.current_page === 1"
                  @click="changePage(pagination.current_page - 1)"
                >
                  <svg class="w-4 h-4 fill-current" aria-hidden="true" viewBox="0 0 20 20">
                    <path d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
                  </svg>
                </button>
              </li>
              <li v-for="page in paginationPages" :key="page">
                <button
                  class="px-3 py-1 rounded-md focus:outline-none focus:shadow-outline-primary"
                  :class="{
                    'text-white bg-primary-600': page === pagination.current_page,
                    'text-gray-700 dark:text-gray-400': page !== pagination.current_page
                  }"
                  @click="changePage(page)"
                >
                  {{ page }}
                </button>
              </li>
              <li>
                <button
                  class="px-3 py-1 rounded-md rounded-r-lg focus:outline-none focus:shadow-outline-primary"
                  aria-label="Next"
                  :disabled="pagination.current_page === pagination.last_page"
                  @click="changePage(pagination.current_page + 1)"
                >
                  <svg class="w-4 h-4 fill-current" aria-hidden="true" viewBox="0 0 20 20">
                    <path d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" fill-rule="evenodd"></path>
                  </svg>
                </button>
              </li>
            </ul>
          </nav>
        </span>
      </div>
    </div>
    
    <!-- 用户表单模态框 -->
    <div
      class="fixed inset-0 z-30 flex items-end bg-black bg-opacity-50 sm:items-center sm:justify-center"
      v-if="isModalOpen"
    >
      <div
        class="w-full px-6 py-4 overflow-hidden bg-white rounded-t-lg dark:bg-gray-800 sm:rounded-lg sm:m-4 sm:max-w-xl"
        role="dialog"
      >
        <header class="flex justify-between">
          <h2 class="text-xl font-medium text-gray-700 dark:text-gray-300">
            {{ editingUser ? '编辑用户' : '添加用户' }}
          </h2>
          <button
            class="inline-flex items-center justify-center w-6 h-6 text-gray-400 transition-colors duration-150 rounded dark:hover:text-gray-200 hover:text-gray-700"
            aria-label="close"
            @click="closeModal"
          >
            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path
                d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                clip-rule="evenodd"
                fill-rule="evenodd"
              ></path>
            </svg>
          </button>
        </header>
        
        <!-- 用户表单 -->
        <div class="mt-4 mb-6">
          <form @submit.prevent="saveUser">
            <!-- 姓名 -->
            <div class="mb-4">
              <label class="block text-sm">
                <span class="text-gray-700 dark:text-gray-400">姓名</span>
                <input
                  class="block w-full mt-1 text-sm dark:border-gray-600 dark:bg-gray-700 focus:border-primary-400 focus:outline-none focus:shadow-outline-primary dark:text-gray-300 dark:focus:shadow-outline-gray form-input"
                  placeholder="请输入姓名"
                  v-model="userForm.name"
                />
              </label>
            </div>
            
            <!-- 邮箱 -->
            <div class="mb-4">
              <label class="block text-sm">
                <span class="text-gray-700 dark:text-gray-400">邮箱</span>
                <input
                  class="block w-full mt-1 text-sm dark:border-gray-600 dark:bg-gray-700 focus:border-primary-400 focus:outline-none focus:shadow-outline-primary dark:text-gray-300 dark:focus:shadow-outline-gray form-input"
                  placeholder="请输入邮箱"
                  type="email"
                  v-model="userForm.email"
                />
              </label>
            </div>
            
            <!-- 密码 -->
            <div class="mb-4" v-if="!editingUser">
              <label class="block text-sm">
                <span class="text-gray-700 dark:text-gray-400">密码</span>
                <input
                  class="block w-full mt-1 text-sm dark:border-gray-600 dark:bg-gray-700 focus:border-primary-400 focus:outline-none focus:shadow-outline-primary dark:text-gray-300 dark:focus:shadow-outline-gray form-input"
                  placeholder="请输入密码"
                  type="password"
                  v-model="userForm.password"
                />
              </label>
            </div>
            
            <!-- 角色 -->
            <div class="mb-4">
              <label class="block text-sm">
                <span class="text-gray-700 dark:text-gray-400">角色</span>
                <select
                  class="block w-full mt-1 text-sm dark:border-gray-600 dark:bg-gray-700 focus:border-primary-400 focus:outline-none focus:shadow-outline-primary dark:text-gray-300 dark:focus:shadow-outline-gray form-select"
                  v-model="userForm.role"
                >
                  <option value="admin">管理员</option>
                  <option value="user">普通用户</option>
                  <option value="editor">编辑</option>
                </select>
              </label>
            </div>
            
            <!-- 状态 -->
            <div class="mb-4">
              <label class="block text-sm">
                <span class="text-gray-700 dark:text-gray-400">状态</span>
                <select
                  class="block w-full mt-1 text-sm dark:border-gray-600 dark:bg-gray-700 focus:border-primary-400 focus:outline-none focus:shadow-outline-primary dark:text-gray-300 dark:focus:shadow-outline-gray form-select"
                  v-model="userForm.status"
                >
                  <option value="active">激活</option>
                  <option value="pending">待审核</option>
                  <option value="banned">禁用</option>
                </select>
              </label>
            </div>
            
            <!-- 提交按钮 -->
            <div class="flex justify-end">
              <button
                type="button"
                class="w-full px-5 py-3 text-sm font-medium leading-5 text-gray-700 transition-colors duration-150 border border-gray-300 rounded-lg dark:text-gray-400 sm:px-4 sm:py-2 sm:w-auto active:bg-transparent hover:border-gray-500 focus:border-gray-500 active:text-gray-500 focus:outline-none focus:shadow-outline-gray"
                @click="closeModal"
              >
                取消
              </button>
              <button
                type="submit"
                class="w-full px-5 py-3 ml-3 text-sm font-medium leading-5 text-white transition-colors duration-150 bg-primary-600 border border-transparent rounded-lg sm:w-auto sm:px-4 sm:py-2 active:bg-primary-600 hover:bg-primary-700 focus:outline-none focus:shadow-outline-primary"
              >
                保存
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    
    <!-- 删除确认模态框 -->
    <div
      class="fixed inset-0 z-30 flex items-end bg-black bg-opacity-50 sm:items-center sm:justify-center"
      v-if="isDeleteModalOpen"
    >
      <div
        class="w-full px-6 py-4 overflow-hidden bg-white rounded-t-lg dark:bg-gray-800 sm:rounded-lg sm:m-4 sm:max-w-xl"
        role="dialog"
      >
        <header class="flex justify-between">
          <h2 class="text-xl font-medium text-gray-700 dark:text-gray-300">
            确认删除
          </h2>
          <button
            class="inline-flex items-center justify-center w-6 h-6 text-gray-400 transition-colors duration-150 rounded dark:hover:text-gray-200 hover:text-gray-700"
            aria-label="close"
            @click="closeDeleteModal"
          >
            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path
                d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                clip-rule="evenodd"
                fill-rule="evenodd"
              ></path>
            </svg>
          </button>
        </header>
        
        <div class="mt-4 mb-6">
          <p class="mb-4 text-gray-700 dark:text-gray-300">
            确定要删除用户 "{{ userToDelete?.name }}" 吗？此操作不可撤销。
          </p>
          
          <div class="flex justify-end">
            <button
              type="button"
              class="w-full px-5 py-3 text-sm font-medium leading-5 text-gray-700 transition-colors duration-150 border border-gray-300 rounded-lg dark:text-gray-400 sm:px-4 sm:py-2 sm:w-auto active:bg-transparent hover:border-gray-500 focus:border-gray-500 active:text-gray-500 focus:outline-none focus:shadow-outline-gray"
              @click="closeDeleteModal"
            >
              取消
            </button>
            <button
              type="button"
              class="w-full px-5 py-3 ml-3 text-sm font-medium leading-5 text-white transition-colors duration-150 bg-red-600 border border-transparent rounded-lg sm:w-auto sm:px-4 sm:py-2 active:bg-red-600 hover:bg-red-700 focus:outline-none focus:shadow-outline-red"
              @click="confirmDelete"
            >
              删除
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

// 模拟用户数据
const users = ref([
  {
    id: 1,
    name: '张三',
    email: 'zhangsan@example.com',
    role: 'admin',
    status: 'active',
    avatar: 'https://avatars.dicebear.com/api/initials/zs.svg',
    created_at: '2023-01-15T08:30:00Z'
  },
  {
    id: 2,
    name: '李四',
    email: 'lisi@example.com',
    role: 'user',
    status: 'active',
    avatar: 'https://avatars.dicebear.com/api/initials/ls.svg',
    created_at: '2023-02-20T10:15:00Z'
  },
  {
    id: 3,
    name: '王五',
    email: 'wangwu@example.com',
    role: 'editor',
    status: 'pending',
    avatar: 'https://avatars.dicebear.com/api/initials/ww.svg',
    created_at: '2023-03-10T14:45:00Z'
  },
  {
    id: 4,
    name: '赵六',
    email: 'zhaoliu@example.com',
    role: 'user',
    status: 'banned',
    avatar: 'https://avatars.dicebear.com/api/initials/zl.svg',
    created_at: '2023-04-05T09:20:00Z'
  },
  {
    id: 5,
    name: '钱七',
    email: 'qianqi@example.com',
    role: 'user',
    status: 'active',
    avatar: 'https://avatars.dicebear.com/api/initials/qq.svg',
    created_at: '2023-05-12T16:30:00Z'
  }
])

// 搜索和筛选
const searchQuery = ref('')
const roleFilter = ref('')

// 分页
const pagination = ref({
  current_page: 1,
  from: 1,
  to: 5,
  total: 5,
  per_page: 10,
  last_page: 1
})

// 计算分页页码
const paginationPages = computed(() => {
  const pages = []
  for (let i = 1; i <= pagination.value.last_page; i++) {
    pages.push(i)
  }
  return pages
})

// 过滤用户列表
const filteredUsers = computed(() => {
  let result = users.value
  
  // 搜索
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(user => 
      user.name.toLowerCase().includes(query) || 
      user.email.toLowerCase().includes(query)
    )
  }
  
  // 角色筛选
  if (roleFilter.value) {
    result = result.filter(user => user.role === roleFilter.value)
  }
  
  return result
})

// 模态框状态
const isModalOpen = ref(false)
const isDeleteModalOpen = ref(false)
const editingUser = ref(null)
const userToDelete = ref(null)

// 用户表单
const userForm = ref({
  name: '',
  email: '',
  password: '',
  role: 'user',
  status: 'active'
})

// 打开添加用户模态框
const openAddUserModal = () => {
  editingUser.value = null
  userForm.value = {
    name: '',
    email: '',
    password: '',
    role: 'user',
    status: 'active'
  }
  isModalOpen.value = true
}

// 编辑用户
const editUser = (user) => {
  editingUser.value = user
  userForm.value = {
    name: user.name,
    email: user.email,
    role: user.role,
    status: user.status
  }
  isModalOpen.value = true
}

// 关闭模态框
const closeModal = () => {
  isModalOpen.value = false
}

// 保存用户
const saveUser = () => {
  if (editingUser.value) {
    // 更新现有用户
    const index = users.value.findIndex(u => u.id === editingUser.value.id)
    if (index !== -1) {
      users.value[index] = {
        ...users.value[index],
        name: userForm.value.name,
        email: userForm.value.email,
        role: userForm.value.role,
        status: userForm.value.status
      }
    }
  } else {
    // 添加新用户
    const newUser = {
      id: users.value.length + 1,
      name: userForm.value.name,
      email: userForm.value.email,
      role: userForm.value.role,
      status: userForm.value.status,
      avatar: `https://avatars.dicebear.com/api/initials/${userForm.value.name.substring(0, 2)}.svg`,
      created_at: new Date().toISOString()
    }
    users.value.push(newUser)
  }
  
  closeModal()
}

// 删除用户
const deleteUser = (user) => {
  userToDelete.value = user
  isDeleteModalOpen.value = true
}

// 关闭删除确认模态框
const closeDeleteModal = () => {
  isDeleteModalOpen.value = false
  userToDelete.value = null
}

// 确认删除
const confirmDelete = () => {
  if (userToDelete.value) {
    users.value = users.value.filter(u => u.id !== userToDelete.value.id)
    closeDeleteModal()
  }
}

// 搜索处理
const handleSearch = () => {
  pagination.value.current_page = 1
}

// 筛选处理
const handleFilter = () => {
  pagination.value.current_page = 1
}

// 切换页码
const changePage = (page) => {
  pagination.value.current_page = page
}

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN')
}

// 获取角色名称
const getRoleName = (role) => {
  const roleMap = {
    admin: '管理员',
    user: '用户',
    editor: '编辑'
  }
  return roleMap[role] || role
}

// 获取状态名称
const getStatusName = (status) => {
  const statusMap = {
    active: '激活',
    pending: '待审核',
    banned: '禁用'
  }
  return statusMap[status] || status
}

// 初始化
onMounted(() => {
  // 这里可以添加实际的API调用
  console.log('UserManagement mounted')
})
</script>