IP=50.118.174.4
#IMAGE=$HOME/win10.iso
IMAGE=$HOME/winhd.disk
# kubectl virt image-upload pvc iso-win10 \
#NAME=iso-win10
NAME=iso-winhd
virtctl image-upload pvc $NAME \
--image-path=$IMAGE \
--access-mode=ReadWriteOnce \
--size=40G \
--uploadproxy-url=https://$IP \
--force-bind \
--insecure \
--wait-secs=60
