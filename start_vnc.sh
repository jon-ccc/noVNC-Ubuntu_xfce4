#!/bin/bash  

rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1
# 设置vnc密码
echo $VNC_PASS | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd
# 修改vnc.html 为 index.html
noVNC_path="/app/noVNC"
cp $noVNC_path/vnc.html $noVNC_path/index.html
cp $noVNC_path/utils/novnc_proxy $noVNC_path/utils/novnc_proxy.bak
sed -i 's/vnc.html/index.html/g' $noVNC_path/utils/novnc_proxy   
ls $noVNC_path/ -lha

# 启动 VNC 服务器并设置显示参数  
vncserver -geometry $GEOMETRY -depth $DEPTH :1 -localhost no


# 8888 是你将暴露给Web浏览器的端口，而 localhost:5901 是你的VNC服务器运行的地址和端口。  
/app/noVNC/utils/novnc_proxy --listen 8888 --vnc localhost:5901
