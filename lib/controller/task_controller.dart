import 'package:edo_task/service/db_service.dart';
import 'package:get/get.dart';
import 'package:edo_task/model/task';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getTasks();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
