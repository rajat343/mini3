import grpc, sys
from generated import work_pb2, work_pb2_grpc

def submit_task(server_address, task, weight):
    channel = grpc.insecure_channel(server_address)
    stub = work_pb2_grpc.TaskManagerStub(channel)
    response = stub.SubmitTask(work_pb2.TaskRequest(task=task, weight=int(weight)))
    print(f"Submitted '{task}' with weight {weight} to {server_address}: {response.status}")

if __name__ == '__main__':
    server = sys.argv[1]
    task = sys.argv[2]
    weight = sys.argv[3]
    submit_task(server, task, weight)
