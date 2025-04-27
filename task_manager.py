import queue

class TaskManager:
    def __init__(self):
        self.tasks = queue.PriorityQueue()

    def add_task(self, task, weight):
        self.tasks.put((-weight, task))  # Max weight = Highest priority

    def get_task(self):
        if self.tasks.empty():
            return None
        return self.tasks.get()[1]

    def steal_tasks(self, max_tasks):
        stolen_tasks = []
        for _ in range(min(max_tasks, self.tasks.qsize())):
            stolen_tasks.append(self.tasks.get()[1])
        return stolen_tasks

    def current_load(self):
        return self.tasks.qsize()
