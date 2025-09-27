#!/bin/bash

# 颜色定义
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo -e "${GREEN}=== 管理后台系统启动脚本 ===${NC}\n"

# 默认环境
ENVIRONMENT="development"

# 检查是否安装了必要的工具
command -v python3 >/dev/null 2>&1 || { echo -e "${RED}错误: 需要安装 python3${NC}" >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo -e "${RED}错误: 需要安装 npm${NC}" >&2; exit 1; }
command -v psql >/dev/null 2>&1 || { echo -e "${YELLOW}警告: 未检测到 PostgreSQL, 数据库操作可能会失败${NC}" >&2; }

# 项目根目录
PROJECT_ROOT=$(pwd)

# 服务启动变量
START_SERVICE=""


# 启动后端
start_backend() {
    echo -e "${BLUE}启动后端服务...${NC}"
    cd "$PROJECT_ROOT/backend" || { echo -e "${RED}错误: 无法进入后端目录${NC}"; exit 1; }
    
    # 检查虚拟环境
    if [ ! -d "venv" ]; then
        echo -e "${YELLOW}创建Python虚拟环境...${NC}"
        python3 -m venv venv
    fi
    
    # 激活虚拟环境
    source venv/bin/activate || { echo -e "${RED}错误: 无法激活虚拟环境${NC}"; exit 1; }
    
    # 安装依赖
    echo -e "${YELLOW}安装后端依赖...${NC}"
    pip install -r requirements.txt
    
    # 运行迁移
    echo -e "${YELLOW}运行数据库迁移...${NC}"
    alembic upgrade head || echo -e "${YELLOW}警告: 迁移失败, 可能需要手动设置数据库${NC}"
    
    # 启动服务
    if [ "$ENVIRONMENT" = "production" ]; then
        echo -e "${GREEN}启动FastAPI生产环境服务...${NC}"
        # 生产环境使用Gunicorn或Uvicorn的生产模式
        uvicorn main:app --host 0.0.0.0 --port 8000 &
    else
        echo -e "${GREEN}启动FastAPI开发环境服务...${NC}"
        uvicorn main:app --reload --host 0.0.0.0 --port 8000 &
    fi
    BACKEND_PID=$!
    echo -e "${GREEN}后端服务已启动 (PID: $BACKEND_PID)${NC}"
    echo -e "${GREEN}API文档可访问: http://localhost:8000/docs${NC}"
}

# 启动前端
start_frontend() {
    echo -e "${BLUE}启动前端服务...${NC}"
    cd "$PROJECT_ROOT/frontend" || { echo -e "${RED}错误: 无法进入前端目录${NC}"; exit 1; }
    
    # 安装依赖
    echo -e "${YELLOW}安装前端依赖...${NC}"
    npm install
    
    # 启动服务
    if [ "$ENVIRONMENT" = "production" ]; then
        echo -e "${GREEN}启动Vue生产环境服务器...${NC}"
        npm run build
        # 使用预览模式运行生产构建
        npm run preview &
    else
        echo -e "${GREEN}启动Vue开发服务器...${NC}"
        npm run dev &
    fi
    FRONTEND_PID=$!
    echo -e "${GREEN}前端服务已启动 (PID: $FRONTEND_PID)${NC}"
    echo -e "${GREEN}前端可访问: http://localhost:3000${NC}"
}

# 清理函数
cleanup() {
    echo -e "\n${YELLOW}正在关闭服务...${NC}"
    if [ -n "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        echo -e "${GREEN}后端服务已停止${NC}"
    fi
    if [ -n "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
        echo -e "${GREEN}前端服务已停止${NC}"
    fi
    exit 0
}

# 注册清理函数
trap cleanup SIGINT SIGTERM

# 显示帮助信息
show_help() {
    echo -e "${GREEN}使用方法:${NC}"
    echo -e "  $0 [选项]"
    echo -e "\n${GREEN}选项:${NC}"
    echo -e "  -e, --env ENV    指定环境 (development 或 production), 默认: development"
    echo -e "  -s, --service SERVICE  指定要启动的服务 (backend 或 frontend)"
    echo -e "  -h, --help       显示帮助信息"
    echo -e "\n${GREEN}示例:${NC}"
    echo -e "  $0                  # 使用开发环境启动"
    echo -e "  $0 -e production   # 使用生产环境启动"
}

# 解析命令行参数
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -e|--env)
                ENVIRONMENT="$2"
                if [[ "$ENVIRONMENT" != "development" && "$ENVIRONMENT" != "production" ]]; then
                    echo -e "${RED}错误: 环境必须是 'development' 或 'production'${NC}"
                    exit 1
                fi
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -s|--service)
                START_SERVICE="$2"
                if [[ "$START_SERVICE" != "backend" && "$START_SERVICE" != "frontend" ]]; then
                    echo -e "${RED}错误: 服务必须是 'backend' 或 'frontend'${NC}"
                    exit 1
                fi
                shift 2
                ;;
            *)
                echo -e "${RED}错误: 未知选项 $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
}

# 主函数
main() {
    parse_args "$@"
    
    echo -e "${GREEN}使用 $ENVIRONMENT 环境启动服务${NC}"
    export ENVIRONMENT="$ENVIRONMENT"
    
    if [ "$START_SERVICE" = "backend" ]; then
        start_backend
    fi
    if [ "$START_SERVICE" = "frontend" ]; then
        start_frontend
    fi
    if [ -z "$START_SERVICE" ]; then
        start_backend
        start_frontend
    fi
    
    echo -e "\n${GREEN}所有服务已启动!${NC}"
    echo -e "${YELLOW}按 Ctrl+C 停止所有服务${NC}"
    
    # 保持脚本运行
    while true; do
        sleep 1
    done
}

# 执行主函数
main "$@"