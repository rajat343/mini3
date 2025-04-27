import grpc, threading, time, sys
from concurrent import futures
from generated import work_pb2, work_pb2_grpc
from task_manager import TaskManager

class TaskManagerServicer(work_pb2_grpc.TaskManagerServicer):
    def __init__(self, server_name):
        self.server_name = server_name
        self.task_manager = TaskManager()
        self.processing = False

    def SubmitTask(self, request, context):
        self.task_manager.add_task(request.task, request.weight)
        status = f"Task '{request.task}' added to {self.server_name} with weight {request.weight}"
        print(status)
        return work_pb2.TaskResponse(status=status)

    def StealTasks(self, request, context):
        if self.task_manager.current_load() == 0:
            return work_pb2.StealResponse(tasks=[])
        tasks = self.task_manager.steal_tasks(request.max_tasks)
        print(f"{self.server_name} gave tasks {tasks}")
        return work_pb2.StealResponse(tasks=tasks)

    def GetLoad(self, request, context):
        return work_pb2.LoadResponse(load=self.task_manager.current_load())

    def process_tasks(self):
        while True:
            task = self.task_manager.get_task()
            if task:
                self.processing = True
                print(f"{self.server_name} started processing task '{task}'")
                time.sleep(10)  # simulate task processing clearly
                print(f"{self.server_name} finished processing task '{task}'")
                self.processing = False
            else:
                self.processing = False
                time.sleep(2)

def adaptive_steal(all_ports, my_port, servicer):
    import random
    while True:
        time.sleep(3)
        if servicer.processing or servicer.task_manager.current_load() > 0:
            continue
        random.shuffle(all_ports)
        for port in all_ports:
            if port == my_port:
                continue
            try:
                with grpc.insecure_channel(f'localhost:{port}') as channel:
                    stub = work_pb2_grpc.TaskManagerStub(channel)
                    load_response = stub.GetLoad(work_pb2.LoadRequest())
                    if load_response.load > 1:
                        response = stub.StealTasks(work_pb2.StealRequest(max_tasks=1))
                        if response.tasks:
                            for task in response.tasks:
                                servicer.task_manager.add_task(task, weight=1)  # default weight clearly
                                print(f"{servicer.server_name} stole '{task}' from server {port}")
                            break
            except Exception as e:
                print(f"Stealing error: {e}")

def serve(port, server_name, all_ports):
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    servicer = TaskManagerServicer(server_name)
    work_pb2_grpc.add_TaskManagerServicer_to_server(servicer, server)
    server.add_insecure_port(f'[::]:{port}')
    server.start()
    print(f'✅ {server_name} started gRPC server on port {port}')
    # GIVE gRPC a moment to bind/listen
    time.sleep(3)
    # Now start task‐processing and stealing threads
    threading.Thread(target=servicer.process_tasks, daemon=True).start()
    threading.Thread(target=adaptive_steal, args=(all_ports, port, servicer), daemon=True).start()
    # Keep the server alive indefinitely
    server.wait_for_termination()

if __name__ == '__main__':
    port = int(sys.argv[1])
    server_name = sys.argv[2]
    all_ports = list(map(int, sys.argv[3:]))
    serve(port, server_name, all_ports)
