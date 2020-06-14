import 'task.dart';
import 'task_type.dart';

class Tasks {

  int index;
  List<Task> list = [];

  Tasks(int taskDuration, int shortRestDuration, int longRestDuration, int sets, int cycle) {
    this.index = 0;
    
    for (int c=0; c<cycle; c++) {
      for (int s=0; s<sets; s++) {
        list.add(Task(taskDuration, TaskType.task));
        if (!_isLastSet(s, sets)) {
          list.add(Task(shortRestDuration, TaskType.shortRest));
        }
      }
      list.add(Task(longRestDuration, TaskType.longRest));
    }
  }

  bool _isLastSet(int s, int sets) {
    return s == sets-1;
  }
}