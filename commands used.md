gcloud init
gcloud container clusters create yolo-cluster --zone africa-south1-a --num-nodes=3
gcloud container clusters get-credentials yolo-cluster --zone africa-south1-a
gcloud compute disks create yolo-disk --size=10GB --zone=africa-south1-a
kubectl get pv
kubectl get pvc
kubectl get pods
kubectl get svc
