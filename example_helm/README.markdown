[![ KUBE | HELM ](https://media.giphy.com/media/3SbHPr7tramfAyKrXV/giphy.gif)]

- RUN >
- export HELM_DEBUG="true"
- helm env
- helm list -n <your_namespace>
- Example deploy by standZ >
- helm upgrade --debug  --install --namespace prod  --values user/values-prod.yaml  --timeout 22s user ./user
- helm upgrade --debug  --install --namespace stage --values user/values-stage.yaml --timeout 22s user ./user
- helm upgrade --debug  --install --namespace dev   --values user/values-dev.yaml   --timeout 22s user ./user
- helm ls -A && --dry-run for a overview ...
- Create ingress.yaml &>
- Ing > helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace dev
- ✨Magic ✨

