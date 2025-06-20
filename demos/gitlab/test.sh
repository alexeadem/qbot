set -x
shopt -s expand_aliases
alias qbo=cli
#KEY_CONTENT=$(qbo get acme -A 2>/dev/null | jq -r .acmes[]?.privkey | base64 -w 0)
#CERT_CONTENT=$(qbo get acme -A 2>/dev/null | jq -r .acmes[]?.fullchain | base64 -w 0)

#echo $KEY_CONTENT | base64 -d | openssl rsa -noout -text
#echo $CERT_CONTENT | base64 -d | openssl rsa -noout -text
export CLI_LOG=notice

#(set -x; qbo get acme -A 2>/dev/null | jq -r .acmes[]?.privkey)
#(set -x; qbo get acme -A 2>/dev/null | jq -r .acmes[]?.fullchain)


(set -x; qbo get acme -A | jq -r .acmes[]?.privkey)
(set -x; qbo get acme -A | jq -r .acmes[]?.fullchain)
