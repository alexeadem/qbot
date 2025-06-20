kubectl delete deployment minio-deployment \
&&  kubectl delete pvc minio-pv-claim \
&& kubectl delete svc minio-service
