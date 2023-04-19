apt install kubeadm kubectl kubelet

关闭交换分区
swapoff -a 

输出init参数内容
kubeadm config print init-defaults
输出join参数内容
kubeadm config print join-defaults

新旧版之间进行配置交换
kubeadm config migrate --v=5

列出镜像列表
kubeadm config images list
拉取到本地
kubeadm config images pull
初始化配置
kubeadm config print init-defaults > init.default.yaml

修改docker镜像源地址


sudo gpasswd -a $USER docker

vim /etc/docker/daemon.json

sudo vim /usr/lib/systemd/system/docker.socket
改为0666
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0666
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target

sudo systemctl daemon-reload
sudo systemctl restart docker.socket















