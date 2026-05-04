# DTN Simulation (Earth-Relay-Mars)

이 프로젝트는 ION(Interplanetary Overly Network) DTN을 사용하여 지구(Earth)에서 화성(Mars)으로 파일을 전송하는 시나리오를 시뮬레이션합니다. 중간에 라즈베리 파이(Relay) 노드가 있다고 가정하며, 각 노드는 독립된 환경(PC 등)에서 실행됩니다.

## 네트워크 구성
- **Earth (Node 1)**: 파일 송신부 (Flask Web UI 제공)
- **Relay (Node 3)**: 중간 전달자 (라즈베리 파이 등 외부 기기)
- **Mars (Node 2)**: 파일 수신부 (Flask Web UI 제공)

## 설치 및 실행 방법

### 0. 공통 준비 (각 PC)
- Docker가 설치되어 있어야 합니다.
- 모든 기기는 동일한 네트워크에 연결되어 있어야 하며, 서로 IP 통신이 가능해야 합니다.

### 1. Relay(라즈베리 파이) IP 설정
메인 디렉토리에서 라즈베리 파이의 IP를 입력하여 설정 파일을 업데이트합니다.
```bash
chmod +x set_relay_ip.sh
./set_relay_ip.sh <라즈베리파이_IP>
```

### 2. 지구(Earth) 노드 실행 (PC 1)
`earth` 폴더의 내용을 PC 1로 복사한 후 실행합니다.
```bash
cd earth
docker build -t dtn-earth -f Dockerfile.earth .
docker run -d --name earth -p 5000:5000 --cap-add=NET_ADMIN dtn-earth
```
- 브라우저 접속: `http://localhost:5000`

### 3. 화성(Mars) 노드 실행 (PC 2)
`mars` 폴더의 내용을 PC 2로 복사한 후 실행합니다.
```bash
cd mars
docker build -t dtn-mars -f Dockerfile.mars .
docker run -d --name mars -p 5001:5000 --cap-add=NET_ADMIN dtn-mars
```
- 브라우저 접속: `http://<PC2_IP>:5001`

## 주요 도구
- **bpsendfile**: 파일을 번들로 묶어 전송합니다.
- **bprecvfile**: 수신된 번들을 파일로 복원합니다.
- **ionadmin, bpadmin 등**: ION 노드 관리 도구입니다.

## 주의 사항
- 중간 Relay 노드(라즈베리 파이)에서도 ION이 실행 중이어야 하며, 1번 노드와 2번 노드에 대한 경로 설정이 완료되어 있어야 데이터가 전달됩니다.
