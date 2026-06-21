#!/bin/bash
# Generates 1000+ transactions across 3 wallets using cast
set -a; source .env; set +a

RPC="https://forno.celo.org"
TC="0x2097796487bea53b00D1e6e2D3327D30bEf08E3E"
AGENT="0xA5EFE8954B68B95333f3aCE9e65039DC8235fD47"
COORD_KEY="0x$PRIVATE_KEY"

run_cycles() {
  local req_key="0x$1"
  local label=$2
  local cycles=$3

  echo "[$label] starting $cycles cycles..."
  for i in $(seq 1 $cycles); do
    # Step 1: createTask — parse taskId from TaskCreated event (topic[1])
    RECEIPT=$(cast send $TC "createTask(string,uint256)" "AI-Net task" 86400 \
      --value 0.001ether \
      --private-key $req_key \
      --rpc-url $RPC \
      --gas-price 202500000000 \
      --gas-price 202500000000 --legacy --json 2>/dev/null)

    TASK_ID=$(echo "$RECEIPT" | python3 -c "
import sys,json
r=json.load(sys.stdin)
for l in r.get('logs',[]):
    if l['address'].lower()=='0x2097796487bea53b00d1e6e2d3327d30bef08e3e'.lower() and len(l['topics'])>1:
        print(int(l['topics'][1],16)); break
" 2>/dev/null)

    if [ -z "$TASK_ID" ]; then
      echo "[$label] cycle $i: createTask failed, retrying..."
      sleep 2
      RECEIPT=$(cast send $TC "createTask(string,uint256)" "AI-Net task" 86400 \
        --value 0.001ether \
        --private-key $req_key \
        --rpc-url $RPC \
        --gas-price 202500000000 --legacy --json 2>/dev/null)
      TASK_ID=$(echo "$RECEIPT" | python3 -c "
import sys,json
r=json.load(sys.stdin)
for l in r.get('logs',[]):
    if l['address'].lower()=='0x2097796487bea53b00d1e6e2d3327d30bef08e3e'.lower() and len(l['topics'])>1:
        print(int(l['topics'][1],16)); break
" 2>/dev/null)
    fi

    if [ -z "$TASK_ID" ]; then
      echo "[$label] cycle $i: skipping after retry"
      continue
    fi

    # Step 2: hireAgent
    cast send $TC "hireAgent(uint256,address)" $TASK_ID $AGENT \
      --private-key $COORD_KEY \
      --rpc-url $RPC --gas-price 202500000000 --legacy > /dev/null 2>&1

    # Step 3: completeTask
    cast send $TC "completeTask(uint256)" $TASK_ID \
      --private-key $req_key \
      --rpc-url $RPC --gas-price 202500000000 --legacy > /dev/null 2>&1

    echo "[$label] cycle $i/$cycles (taskId=$TASK_ID) ✓"
  done
  echo "[$label] COMPLETE"
}

echo "Launching wallet-3 only (~500 transactions)..."
run_cycles "$PRIVATE_KEY_3" "wallet-3" 167 &
wait

echo ""
echo "Final task count: $(cast call $TC 'taskCount()(uint256)' --rpc-url $RPC)"
