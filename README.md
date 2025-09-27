# 管理后台系统

这是一个基于Vue 3和FastAPI构建的管理后台系统，包含用户认证、仪表盘和用户管理等功能。

## 项目结构

```
├── backend/           # FastAPI后端
│   ├── app/          # 应用代码
│   │   ├── api/      # API路由
│   │   ├── core/     # 核心配置
│   │   ├── crud/     # CRUD操作
│   │   ├── db/       # 数据库
│   │   ├── models/   # 数据库模型
│   │   └── schemas/  # Pydantic模式
│   ├── migrations/   # Alembic迁移
│   └── main.py       # 应用入口
└── frontend/         # Vue 3前端
    ├── public/       # 静态资源
    └── src/          # 源代码
        ├── api/      # API请求
        ├── components/# 组件
        ├── layouts/   # 布局
        ├── router/    # 路由
        ├── stores/    # Pinia状态
        └── views/     # 页面
```

## 功能特性

- 用户认证（登录/注册）
- 响应式仪表盘
- 用户管理（CRUD操作）
- 基于角色的权限控制
- 深色模式支持

## 技术栈

### 前端

- Vue 3 (Composition API)
- Vite
- Vue Router
- Pinia
- Tailwind CSS
- Axios

### 后端

- FastAPI
- SQLAlchemy
- Alembic
- 数据库支持
  - SQLite (开发环境)
  - PostgreSQL (生产环境)
- JWT认证

## 环境配置管理

本项目支持开发和生产两种环境配置，通过环境变量`ENVIRONMENT`来控制。

### 配置文件

- 后端配置文件：
  - `.env.development`：开发环境配置（使用SQLite数据库）
  - `.env.production`：生产环境配置（使用PostgreSQL数据库）

- 前端配置文件：
  - `.env.development`：开发环境配置
  - `.env.production`：生产环境配置

## 开始使用

### 使用启动脚本（推荐）

项目提供了一键启动脚本，可以根据指定的环境启动前后端服务：

```bash
# 开发环境启动（默认）
./start.sh

# 生产环境启动
./start.sh -e production

# 查看帮助
./start.sh --help
```

### 手动设置

#### 后端设置

1. 创建虚拟环境并安装依赖：

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

2. 设置数据库：

```bash
# 开发环境（使用SQLite）
export ENVIRONMENT=development

# 生产环境（使用PostgreSQL）
# export ENVIRONMENT=production
# 确保PostgreSQL已安装并运行
# psql -U postgres -c "CREATE DATABASE admin_dashboard;"

# 运行数据库迁移
alembic upgrade head
```

3. 启动后端服务器：

```bash
# 开发环境
uvicorn app.main:app --reload

# 生产环境
# uvicorn app.main:app
```

#### 前端设置

1. 安装依赖：

```bash
cd frontend
npm install
```

2. 启动服务器：

```bash
# 开发环境
npm run dev

# 生产环境
# npm run build
# npm run preview
```

## 访问应用

- 前端: http://localhost:3000
- 后端API: http://localhost:8000/api/v1
- API文档: http://localhost:8000/docs

## 默认管理员账户

- 用户名: admin
- 密码: admin123