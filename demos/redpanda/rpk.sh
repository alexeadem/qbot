#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"
PROFILE_NAME=eadem
LB=$(kubectl get svc redpanda-external -n redpanda  --ignore-not-found -o json | jq -r '.spec.externalIPs[0] | select ( . != null)')

echo $LB 

if rpk profile list | grep -q "$PROFILE_NAME"; then
  # Delete the existing profile
  rpk profile delete "$PROFILE_NAME"
fi

rpk profile create --from-profile <(kubectl get configmap --namespace redpanda redpanda-rpk -o go-template='{{ .data.profile }}' | sed s/31092/9094/g) eadem

cat ~/.config/rpk/rpk.yaml

DNS="$LB redpanda-0.cloud.eadem.com
$LB redpanda-1.cloud.eadem.com
$LB redpanda-2.cloud.eadem.com"

{
  grep -v "redpanda-[0-9]\.cloud\.eadem\.com" /etc/hosts
  echo "$DNS"
} | sudo tee /etc/hosts > /dev/null

echo /etc/hosts
rpk cluster info -X user=superuser -X pass=secretpassword -X sasl.mechanism=SCRAM-SHA-512
