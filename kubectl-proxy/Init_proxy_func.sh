#!/bin/bash

# 모든 함수 목록 가져오기
functions=$(faas-cli list --quiet)

# 각 함수를 삭제
for function in $functions; do
    echo "Deleting function: $function"
    faas-cli remove $function
done

echo "All functions deleted."

# grafaas-proxy 삭제
kubectl delete -f ./grafaas-proxy/nginx-configmap.yaml -n openfaas
kubectl delete -f ./grafaas-proxy/nginx-deployment.yaml -n openfaas
kubectl delete -f ./grafaas-proxy/nginx-service.yaml -n openfaas

echo "Grafaas-proxy deleted."

FUNC_NAMESPACE="openfaas-fn"
CONTAINER_NAME="grafaas"

# 점 순환을 위한 dots 변수 초기화
dots=1

# openfaas-fn 네임스페이스의 Pod 상태 확인
while true; do
    # Pod 목록 가져오기
    # pods=$(kubectl get pods -n $FUNC_NAMESPACE --no-headers 2>/dev/null)
    pods=($(faas-cli list --quiet))

    # Pod가 존재하는지 확인
    if [ -z "$pods" ]; then
    printf "\n"
        printf "openfaas-fn 의 함수가 모두 삭제되었습니다.\n"
        break
    else
        # Pod가 존재하는 동안 대기 중 메시지 출력
        case $dots in
            1) printf "\ropenfaas-fn 네임스페이스에 Pod가 존재합니다. 대기 중.  " ;;
            2) printf "\ropenfaas-fn 네임스페이스에 Pod가 존재합니다. 대기 중.. " ;;
            3) printf "\ropenfaas-fn 네임스페이스에 Pod가 존재합니다. 대기 중... " ;;
        esac

        # dots 값 순환
        dots=$(( (dots % 3) + 1 ))
        sleep 0.5  # 5초 대기 후 다시 확인
    fi
done

# 점 순환을 위한 dots 변수 초기화
dots=1

# 컨테이너가 정상적으로 실행 중인지 확인
while true; do
    # 컨테이너 상태 확인
    CONTAINER_STATUS=$(docker ps -f "name=$CONTAINER_NAME" --format "{{.Status}}")

    if [[ "$CONTAINER_STATUS" != *"Up"* ]]; then
    printf "\n"
        printf "$CONTAINER_NAME 컨테이너가 정상적으로 삭제되었습니다.\n"
        break
    else
        # 대기 중 메시지 출력
        case $dots in
            1) printf "\r$CONTAINER_NAME 컨테이너가 아직 삭제되지 않았습니다. 대기 중.  " ;;
            2) printf "\r$CONTAINER_NAME 컨테이너가 아직 삭제되지 않았습니다. 대기 중.. " ;;
            3) printf "\r$CONTAINER_NAME 컨테이너가 아직 삭제되지 않았습니다. 대기 중... " ;;
        esac

        # dots 값 순환
        dots=$(( (dots % 3) + 1 ))
        sleep 0.5  # 0.5초 대기 후 다시 확인
    fi
done

