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

安装之前检查
sudo kubeadm init phase preflight --v=5

不检查
sudo kubeadm init phase preflight --ignore-preflight-errors=

将docker配置中使用的cgroup改称与k8s一致的使用

添加
/etc/docker/daemon.json中添加

{
	"registry-mirrors": [
		"https://registry.docker-cn.com",
		"https://hub-mirror.c.163.com"
	],
	"exec-opts": [
		"native.cgroupdriver=systemd"
	]
}

重启docker
systemctl restart docker
重启kuberneto
systemctl restart kubelet

安装
修改配置文件 

apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 192.168.31.45
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  name: node
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    imageRepository: registry.aliyuncs.com/google_containers
    dataDir: /var/lib/etcd
    extraArgs:
      listen-client-urls: "http://10.100.0.1:2379"
imageRepository: registry.aliyuncs.com/google_containers
kind: ClusterConfiguration
kubernetesVersion: 1.27.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
  podSubnet: "10.244.0.0/24"
scheduler: {}
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd


修改配置
imageRepository: registry.aliyuncs.com/google_containers

启动拉取
sudo kubeadm config images pull --config=init.default.yaml --v=5


启动初始化
sudo kubeadm init --config=init-default.yaml --v=5

journalctl -f -u kubelet



----------------------------------------------------------------------------------------
sudo apt install net-tools
sudo apt-get update
sudo apt-get install docker.io
sudo vim /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://registry.docker-cn.com"
  ]
}
sudo systemctl daemon-reload
sudo systemctl restart docker
systemctl status docker


sudo apt update && sudo apt install -y apt-transport-https

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add

sudo vim /etc/apt/sources.list
添加
deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main

sudo cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d
sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl --allow-unauthenticated

swapoff -a

kubeadm config print init-defaults > init.default.yaml

修改文件内容

apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 10.28.239.88
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  name: node1
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.aliyuncs.com/google_containers
kind: ClusterConfiguration
kubernetesVersion: 1.27.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}




sudo kubeadm config images pull --config=init.default.yaml --v=5





