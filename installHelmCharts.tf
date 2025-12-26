resource "null_resource" "helm_install_boot" {

  triggers = {
    always_run = timestamp() # this ensures that this provisioner would be triggering all the time
  }

  provisioner "local-exec" {
    command = <<EOF
rm -rf .kube/config
aws eks update-kubeconfig --name "${var.env}-eks"
kubectl get nodes
echo "Installing Metrics Server"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
echo "Installing ArgoCD"
kubectl create ns argocd && true

sleep 3
kubectl apply -f https://raw.githubusercontent.com/B58-CloudDevOps/learn-kuberentes/refs/heads/main/argoCD/argo.yaml -n argocd

echo "Installing Nginx Ingress Controller"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo list
ls -lrth
echo "${path.module}/ingress.yaml"       # ${path.module} gives the path of the current/local module
helm upgrade -i ngx-ingress ingress-nginx/ingress-nginx -f ${path.module}/ingress.yaml

EOF
  }
}