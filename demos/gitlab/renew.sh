#/bin/bash

shopt -s expand_aliases

REPO=eadem
alias qbo="docker run --rm --name qbo-cli -e CLI_LOG=$CLI_LOG -e QBO_HOST=$QBO_HOST -e QBO_PORT=$QBO_PORT -e QBO_UID=$QBO_UID -e QBO_AUX=$QBO_AUX --network host -i -v ~/.qbo:/tmp/qbo $REPO/cli:latest cli"

qbo version | jq .version[]?

read -n 1 -s -r -p "<Press any key to continue>"
printf '\n'

KEY_CONTENT=$(qbo get acme -A | jq -r .acmes[]?.privkey | base64 -w 0)
CERT_CONTENT=$(qbo get acme -A | jq -r .acmes[]?.fullchain | base64 -w 0)

cat <<EOF > wildcard-tls-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: wildcard-tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: ${CERT_CONTENT}
  tls.key: ${KEY_CONTENT}
EOF

cat wildcard-tls-secret.yaml

kubectl get nodes
read -n 1 -s -r -p "<Press any key to continue>"

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: wildcard-tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: ${CERT_CONTENT}
  tls.key: ${KEY_CONTENT}
EOF

(set -x; kubectl get secret wildcard-tls -n default -o jsonpath="{.data.tls\.crt}" | base64 -d)
(set -x; kubectl get secret wildcard-tls -n default -o jsonpath="{.data.tls\.key}" | base64 -d)


