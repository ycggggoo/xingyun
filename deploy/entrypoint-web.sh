#!/bin/sh
# 启动前将构建期占位符替换为运行时配置
set -e

API_URL="${VITE_API_URL:-/api}"
WS_URL="${VITE_WS_URL:-ws://localhost:8080/message/bus}"

cd /usr/share/nginx/html

# 替换 API 基础地址占位符(构建模式 docker 写入)
find . -type f \( -name '*.js' -o -name '*.html' \) -exec \
  sed -i "s|__vg_base_url|${API_URL}|g" {} +

# 替换消息总线 WebSocket 地址(构建默认 ws://localhost:8080/message/bus)
if [ "${WS_URL}" != "ws://localhost:8080/message/bus" ]; then
  find . -type f -name '*.js' -exec \
    sed -i "s|ws://localhost:8080/message/bus|${WS_URL}|g" {} +
fi

echo "xingyun-web env injected: API_URL=${API_URL} WS_URL=${WS_URL}"
