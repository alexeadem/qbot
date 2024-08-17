PVC=winhd-rve7

cat <<EOF > 1.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $PVC
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 35Gi
---
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: $PVC
spec:
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/domain: $PVC
    spec:
      domain:
        cpu:
          cores: 6
        devices:
          disks:
          - bootOrder: 1
            disk:
              bus: virtio
            name: harddrive
          interfaces:
            - masquerade: {}
              name: default
        machine:
          type: q35
        resources:
          requests:
            memory: 12G
      networks:
        - name: default
          pod: {}
      volumes:
      - name: harddrive
        persistentVolumeClaim:
          claimName: $PVC
EOF
