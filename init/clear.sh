#!/bin/sh

#sudo systemctl daemon-reload
#sudo systemctl restart kubelet.service
#sudo kubeadm reset

sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml
sudo rm /etc/kubernetes/manifests/kube-controller-manager.yaml
sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml
sudo rm /etc/kubernetes/manifests/etcd.yaml

