#!/bin/bash


#Attackserver 시작
./attackserver/build.sh

ATK_SERVER_CONTAINER="attackserver"
dots=1
# Attackserver 컨테이너가 정상적으로 실행 중인지 확인
while true; do
    # 컨테이너 상태 확인
    CONTAINER_STATUS=$(docker ps -f "name=$ATK_SERVER_CONTAINER" --format "{{.Status}}")

    if [[ "$CONTAINER_STATUS" == *"Up"* ]]; then
    printf "\n"
        printf "$ATK_SERVER_CONTAINER 컨테이너가 정상적으로 실행되었습니다.\n"
        break
    else
        # 대기 중 메시지 출력
        case $dots in
            1) printf "\r$ATK_SERVER_CONTAINER 컨테이너가 아직 실행되지 않았습니다. 대기 중.  " ;;
            2) printf "\r$ATK_SERVER_CONTAINER 컨테이너가 아직 실행되지 않았습니다. 대기 중.. " ;;
            3) printf "\r$ATK_SERVER_CONTAINER 컨테이너가 아직 실행되지 않았습니다. 대기 중... " ;;
        esac

        # dots 값 순환
        dots=$(( (dots % 3) + 1 ))
        sleep 0.5  # 0.5초 대기 후 다시 확인
    fi
done

CC_DB_CONTAINER="cc-db"
dots=1
# cc-db 컨테이너가 정상적으로 실행 중인지 확인
while true; do
    # 컨테이너 상태 확인
    CONTAINER_STATUS=$(docker ps -f "name=$CC_DB_CONTAINER" --format "{{.Status}}")

    if [[ "$CONTAINER_STATUS" == *"Up"* ]]; then
    printf "\n"
        printf "$CC_DB_CONTAINER 컨테이너가 정상적으로 실행되었습니다.\n"
        break
    else
        # 대기 중 메시지 출력
        case $dots in
            1) printf "\r$CC_DB_CONTAINER 컨테이너가 아직 실행되지 않았습니다. 대기 중.  " ;;
            2) printf "\r$CC_DB_CONTAINER 컨테이너가 아직 실행되지 않았습니다. 대기 중.. " ;;
            3) printf "\r$CC_DB_CONTAINER 컨테이너가 아직 실행되지 않았습니다. 대기 중... " ;;
        esac

        # dots 값 순환
        dots=$(( (dots % 3) + 1 ))
        sleep 0.5  # 0.5초 대기 후 다시 확인
    fi
done

#grafaas-proxy 시작

IMAGE_NAME="jjhwan7099/grafaas:latest"

echo "NAME: CLUSTER-IP: PORT/PROTOCOL" > ./grafaas-proxy/k8s_services_info
kubectl get svc --all-namespaces -o jsonpath='{range .items[*]}{.metadata.name}: {.spec.clusterIP}: {range .spec.ports[*]}{.port}/{.protocol} {" "}{end}{"\n"}{end}' >> ./grafaas-proxy/k8s_services_info

# Build the Docker image
docker build --network=host -t  $IMAGE_NAME ./grafaas-proxy/. || { echo "Docker build failed"; exit 1; }

# Push the Docker image
docker push $IMAGE_NAME || { echo "Docker push failed"; exit 1; }

rm ./grafaas-proxy/k8s_services_info

# Kubernetes service start
kubectl apply -f ./grafaas-proxy/nginx-configmap.yaml -n openfaas || { echo "Failed to apply nginx-configmap"; exit 1; }
kubectl apply -f ./grafaas-proxy/nginx-deployment.yaml -n openfaas || { echo "Failed to apply nginx-deployment"; exit 1; }
kubectl apply -f ./grafaas-proxy/nginx-service.yaml -n openfaas || { echo "Failed to apply nginx-service"; exit 1; }


CONTAINER_NAME="grafaas"
# 점 순환을 위한 dots 변수 초기화
dots=1

# 컨테이너가 정상적으로 실행 중인지 확인
while true; do
    # 컨테이너 상태 확인
    CONTAINER_STATUS=$(docker ps -f "name=$CONTAINER_NAME" --format "{{.Status}}")

    if [[ "$CONTAINER_STATUS" == *"Up"* ]]; then
    printf "\n"
        printf "$CONTAINER_NAME 컨테이너가 정상적으로 실행되었습니다.\n"
        break
    else
        # 대기 중 메시지 출력
        case $dots in
            1) printf "\r$CONTAINER_NAME 컨테이너가 아직 실행되지 않았습니다. 대기 중.  " ;;
            2) printf "\r$CONTAINER_NAME 컨테이너가 아직 실행되지 않았습니다. 대기 중.. " ;;
            3) printf "\r$CONTAINER_NAME 컨테이너가 아직 실행되지 않았습니다. 대기 중... " ;;
        esac

        # dots 값 순환
        dots=$(( (dots % 3) + 1 ))
        sleep 0.5  # 0.5초 대기 후 다시 확인
    fi
done
