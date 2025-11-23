# KEDA + GKE Cluster for Autoscalling



## Architecture Diagram

```
Pub/Sub Topic
     ↓ (messages)
Pub/Sub Subscription ──→ KEDA (in namespace keda)
                               ↓ watches subscription size
                     ScaledObject (in default namespace)
                               ↓
                   Deployment keda-demo (0–10 pods)
```

## Prerequisites

```bash
gcloud auth login
gcloud config set project supple-alpha-474315-q5   # or your own project
terraform -v   # ≥ 1.5
helm --version
kubectl
```

## One-command full setup (copy-paste everything)

```bash
# 1. Clone & enter repo
git clone https://github.com/yourname/gke-keda-pubsub-serverless.git
cd gke-keda-serverless

# 2. Deploy GKE + networking with Terraform
terraform init
terraform apply -auto-approve

# 3. Connect kubectl
gcloud container clusters get-credentials primary --region us-east1 --project supple-alpha-474315-q5

# 4. Install KEDA with Workload Identity (already configured in Helm values)
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm upgrade --install keda kedacore/keda \
  --namespace keda --create-namespace \
  --set serviceAccount.annotations."iam.gke.io/gcp-service-account"=keda-operator@supple-alpha-474315-q5.iam.gserviceaccount.com

# 5. Annotate KEDA operator ServiceAccount (one-time)
kubectl annotate serviceaccount keda-operator -n keda \
  iam.gke.io/gcp-service-account=keda-operator@supple-alpha-474315-q5.iam.gserviceaccount.com --overwrite

# 6. Deploy the demo app + KEDA scaler
kubectl apply -f k8s/

# 7. Done! You now have serverless Pub/Sub consumers
```

## Flood test (watch the magic)

```bash
# Terminal 1 – flood messages
./scripts/generate-messages.sh

# Terminal 2 – watch pods explode
kubectl get pods -l app=keda-demo -w
```

You will see:
- 0 pods → 1 pod in < 6 seconds
- 10 pods in < 15 seconds
- Stop script (Ctrl+C) → back to 0 pods in ~20 seconds

## Instantly empty the queue (scale-down now)

```bash
gcloud pubsub subscriptions seek keda-demo-topic-subscription \
  --time=$(date -u -d "5 minutes" +"%Y-%m-%dT%H:%M:%SZ") \
  --project=supple-alpha-474315-q5
```

## Files explained

| File/Path                     | Purpose |
|-------------------------------|-----------------------------------------------|
| `terraform/`                  | GKE Autopilot private cluster + VPC + node pools |
| `terraform/keda-service-accounts.tf` | Creates `keda-operator` GCP SA + Workload Identity binding |
| `k8s/app.yaml`                | ServiceAccount + Deployment (fast consumer) |
| `k8s/keda-scaledobject.yml`   | TriggerAuthentication + ScaledObject (the magic) |
| `scripts/generate-messages.sh`| Floods 1 message/sec (feel free to make it faster) |

## Clean up (when you’re done showing off)

```bash
# Delete everything
kubectl delete -f k8s/
helm uninstall keda -n keda
terraform destroy -auto-approve
```

## Result

You now have a **real serverless platform** that:
- Scales from 0 → 10 pods in seconds
- Costs $0 when idle
- Uses only Workload Identity (no keys, no secrets)
- Is 100 % managed by Terraform + Helm + kubectl

Perfect for event-driven microservices, background jobs, webhooks, etc.

Made with by Ahmed Wagdy 