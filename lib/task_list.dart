import 'task.dart';
import 'task_type.dart';

class TaskList {

  int _index;
  List<Task> _list = [];

  TaskList(int taskDuration, int shortRestDuration, int longRestDuration, int sets, int cycles) {
    _index = 0;
    
    for (int c=0; c<cycles; c++) {
      for (int s=0; s<sets; s++) {
        _list.add(Task(taskDuration, TaskType.task));
        if (!_isLastSet(s, sets)) {
          _list.add(Task(shortRestDuration, TaskType.shortRest));
        }
      }
      _list.add(Task(longRestDuration, TaskType.longRest));
    }
  }

  bool _isLastSet(int s, int sets) {
    return s == sets-1;
  }

  int count() {
    return _list.length;
  }

  int currentTaskIndex() {
    return _index;
  }

  int currentTaskDuration() {
    return _list[_index].duration;
  }

  void next() {
    _index = (_index + 1) % _list.length;
  }

  Task task(int i) {
    return _list[i];
  }
}