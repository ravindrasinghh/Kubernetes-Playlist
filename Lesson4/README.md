### Lesson 4: Installing ArgoCD and Securing Access Using Amazon Cognito

In this lesson, you will learn how to install ArgoCD using a Helm chart and configure access through an NGINX Ingress Load Balancer. 
![ARGOCD](argo-png-latest.png)

# Before getting started:
1. Follow the instructions from the previous video to <b>create a EKS cluster with v1.30</b>

## Medium and Youtube Article Link:
- [Read the detailed guide on Medium](https://medium.com/@ravindrasinghh/integrate-api-gateway-with-aws-eks-nlb-e8f72be32d68)


Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) v1.0 or later
- AWS CLI configured with appropriate credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for interacting with your EKS cluster

##  Kubernetes YAML configuration file for Ingress
```
global:
  domain: https://argo.codedevops.cloud
repoServer:
  resources:
    requests:
      cpu: 100m
      memory: 128Mi            
server:
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
  config:
    url: "https://argo.codedevops.cloud" 
  extraArgs:
    - --insecure    
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      nginx.ingress.kubernetes.io/cors-expose-headers: "*, X-CustomResponseHeader"
      nlb.ingress.kubernetes.io/scheme: internet-facing
      nlb.ingress.kubernetes.io/target-type: instance
      nlb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
      nlb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:ap-south-1:434605749312:certificate/50eeb484-0d88-4617-bdf6-1d339f2f3b48"
    hosts:
      - argo.codedevops.cloud
```
## To log in:
Get the initial password for the admin user:
```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
```
##  Kubernetes YAML configuration file for Ingress + Cognito
```
global:
  domain: https://argo.codedevops.cloud
configs:
  params:
    "server.insecure": true
  cm:
    create: true        
  rbac:
    create: true
    policy.default: ''
    policy.csv: |
        g, argocd-readonly, role:readonly
        g, argocd-admin, role:admin
    scopes: '[groups]'   
repoServer:
  resources:
    requests:
      cpu: 100m
      memory: 128Mi            
server:
  config:
    url: "https://argo.codedevops.cloud"   
    oidc.config: |
        name: admin
        issuer: https://cognito-idp.ap-south-1.amazonaws.com/ap-south-1_YEwPaQA4Q  # Replace with your AWS SSO Issuer URL
        clientID: 3f8r6j111qidd2c2ft9rmh4vuc     # Replace with your AWS SSO Client ID
        clientSecret: 1gpls5t1pm3gjg3rfltsja6bkrdmt7j3jjdmsussogm8at3i1tj # Replace with your AWS SSO Client Secret
        redirectUrI: https://argo.codedevops.cloud/api/dex/callback
        requestedScopes: ["email", "openid", "phone"]
        requestedIDTokenClaims: {"groups": {"essential": true}}      
  extraArgs:
    - --insecure  
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      nginx.ingress.kubernetes.io/cors-expose-headers: "*, X-CustomResponseHeader"
      nlb.ingress.kubernetes.io/scheme: internet-facing
      nlb.ingress.kubernetes.io/target-type: instance
      nlb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
      nlb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:ap-south-1:434605749312:certificate/50eeb484-0d88-4617-bdf6-1d339f2f3b48"
    hosts:
      - argo.codedevops.cloud
```
