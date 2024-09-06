from ubuntu:20.04

RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list &&\
sed -i "s@http://.*security.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt-get install xfce4 xfce4-goodies  tigervnc-standalone-server tigervnc-xorg-extension -y
RUN DEBIAN_FRONTEND=noninteractive apt install fcitx fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-libpinyin fonts-wqy-zenhei -y
RUN apt-get install -y iproute2 vim firefox htop tree xfce4-panel-profiles


# 添加 NodeSource 的签名密钥和 PPA 并安装 Node.js LTS 版本
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

RUN apt install -y git

WORKDIR /app
# 复制当前文件夹下的 noVNC 文件夹到容器内的 /app 目录!
COPY ./noVNC.tar /tmp/noVNC.tar 
RUN tar -xvf /tmp/noVNC.tar -C /app/


# 根用户以复制启动脚本
USER root
COPY start_vnc.sh /start_vnc.sh
RUN chmod +x /start_vnc.sh


ARG VNC_PASS=123456
ARG user_path=root

# 设置 VNC 服务器配置
RUN mkdir -p ~/.vnc 

RUN echo $VNC_PASS

RUN echo '\n\
    #!/bin/sh \n\
    unset SESSION_MANAGER \n\
    unset DBUS_SESSION_BUS_ADDRESS \n\
    exec startxfce4  \n'\
    >> ~/.vnc/xstartup 
RUN chmod +x ~/.vnc/xstartup 

RUN echo ' \n\
    export LANG=zh_CN.UTF-8 \n\
    export LANGUAGE=zh_CN:en_US \n\
    export LC_CTYPE=zh_CN.UTF-8 \n\
    export GTK_IM_MODULE=fcitx \n\
    export QT_IM_MODULE=fcitx \n\
    export XMODIFIERS="@im=fcitx" \n\'\
    >> /etc/.xprofile

ENTRYPOINT /start_vnc.sh
