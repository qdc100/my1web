# 使用华为云镜像仓库的 Python 3.12 slim 版本作为基础镜像
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.12-slim

# 设置工作目录为 /app
WORKDIR /app

# 安装系统依赖
# gcc: 编译 Python 扩展包（如 psycopg2）所需的编译器
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 复制项目依赖文件到容器中
COPY requirements.txt .

# 安装 Python 依赖包
# --no-cache-dir: 不缓存下载的包，减小镜像体积
RUN pip install --no-cache-dir -r requirements.txt

# 复制整个项目代码到容器中
COPY . .

# 收集静态文件到 STATIC_ROOT 目录
# --noinput: 不询问确认，自动执行
RUN python manage.py collectstatic --noinput

# 暴露容器端口 8000，供外部访问
EXPOSE 8000

# 容器启动时执行的命令
# 使用 Gunicorn 作为 WSGI 服务器
# --bind: 绑定到所有网络接口的 8000 端口
# --workers: 启动 4 个工作进程处理请求
CMD ["gunicorn", "ll_project.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "4"]