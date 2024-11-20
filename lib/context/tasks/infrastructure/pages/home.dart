import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_flutter/context/auth/domain/entities/auth.dart';
import 'package:todo_flutter/context/auth/infrastructure/service/auth_service.dart';
import 'package:todo_flutter/context/tasks/domain/entities/task.dart';
import 'package:todo_flutter/context/tasks/infrastructure/service/task_service.dart';
import 'package:intl/intl.dart';

class TaskValidators {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'El título es requerido';
    }
    if (value.length < 3) {
      return 'El título debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'La descripción es requerida';
    }
    return null;
  }

  static String? validateDueDate(DateTime? value) {
    if (value == null) {
      return 'La fecha es requerida';
    }
    if (value.isBefore(DateTime.now())) {
      return 'La fecha no puede ser anterior a hoy';
    }
    return null;
  }
}

class TaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSubmit;

  const TaskForm({
    Key? key,
    this.task,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  late String _status;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now().add(Duration(days: 1));
    _dueDateController =
        TextEditingController(text: DateFormat('dd/MM/yyyy').format(_dueDate));
    _status = widget.task?.status ?? 'pending';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _dueDate.isBefore(DateTime.now()) ? DateTime.now() : _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(_dueDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            validator: TaskValidators.validateTitle,
            decoration: const InputDecoration(
              labelText: 'Título de la tarea',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE94560)),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          TextFormField(
            controller: _descriptionController,
            validator: TaskValidators.validateDescription,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE94560)),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          TextFormField(
            controller: _dueDateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) => TaskValidators.validateDueDate(_dueDate),
            decoration: const InputDecoration(
              labelText: 'Fecha de Vencimiento',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE94560)),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          DropdownButtonFormField<String>(
            value: _status,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
            style: const TextStyle(color: Colors.white),
            dropdownColor: const Color(0xFF1F4068),
            decoration: const InputDecoration(
              labelText: 'Estado',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE94560)),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'pending',
                child: Text('Pendiente', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'in_progress',
                child:
                    Text('En Progreso', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'completed',
                child:
                    Text('Completado', style: TextStyle(color: Colors.white)),
              ),
            ],
            onChanged: (String? value) {
              if (value != null) {
                setState(() => _status = value);
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child:
                Text(widget.task == null ? 'Crear Tarea' : 'Actualizar Tarea'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        status: _status,
      );
      widget.onSubmit(task);
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  User user = User(id: "0", email: "email", name: "Cargand..");
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchTasks());
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUser());
  }

  Future<void> _fetchTasks() async {
    try {
      final taskService = Provider.of<TaskService>(context, listen: false);
      final fetchedTasks = await taskService.fetchTasks();

      setState(() {
        tasks = fetchedTasks;
      });

      /* final authService = Provider.of<AuthService>(context, listen: false);
      final userCurrent = await authService.getCurrentUser();

      setState(() {
        user = userCurrent;
      }); */
    } catch (e) {
      _showErrorSnackBar('Error al obtener tareas');
    }
  }

  Future<void> _loadUser() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userCurrent = await authService.getCurrentUser();

      setState(() {
        user = userCurrent;
      });
    } catch (e) {
      _showErrorSnackBar('Error al usuario');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _openTaskModal({Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F4068),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TaskForm(
                  task: task,
                  onSubmit: (Task updatedTask) async {
                    try {
                      final taskService =
                          Provider.of<TaskService>(context, listen: false);
                      if (task == null) {
                        await taskService.createTask(updatedTask);
                      } else {
                        await taskService.updateTask(updatedTask);
                      }
                      _fetchTasks();
                      Navigator.pop(context);
                    } catch (e) {
                      _showErrorSnackBar(
                          'Error al ${task == null ? 'crear' : 'actualizar'} la tarea');
                    }
                  },
                ),
                if (task != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final taskService =
                            Provider.of<TaskService>(context, listen: false);
                        await taskService.deleteTask(task.id);
                        _fetchTasks();
                        Navigator.pop(context);
                      } catch (e) {
                        _showErrorSnackBar('Error al eliminar la tarea');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('Eliminar Tarea'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<Task> _getFilteredTasks() {
    if (_currentFilter == 'all') return tasks;
    return tasks.where((task) => task.status == _currentFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();
    debugPrint("asdasd ${user.name}");
    return Scaffold(
      appBar: AppBar(
        title: Text("¿Qué tal, ${user.name} ?"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {}, // Implementar búsqueda
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {}, // Implementar notificaciones
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              authService.removeToken();
              context.go("/welcome");
            }, // Implementar logout
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Todas'),
                    selected: _currentFilter == 'all',
                    onSelected: (bool selected) {
                      setState(() => _currentFilter = 'all');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Pendientes'),
                    selected: _currentFilter == 'pending',
                    onSelected: (bool selected) {
                      setState(() => _currentFilter = 'pending');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('En Progreso'),
                    selected: _currentFilter == 'in_progress',
                    onSelected: (bool selected) {
                      setState(() => _currentFilter = 'in_progress');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Completadas'),
                    selected: _currentFilter == 'completed',
                    onSelected: (bool selected) {
                      setState(() => _currentFilter = 'completed');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'TAREAS DE HOY',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    task: filteredTasks[index],
                    onTap: () => _openTaskModal(task: filteredTasks[index]),
                    onStatusChanged: (bool? value) async {
                      try {
                        final taskService =
                            Provider.of<TaskService>(context, listen: false);
                        final updatedTask = filteredTasks[index];
                        updatedTask.status = value! ? 'completed' : 'pending';
                        await taskService.updateTask(updatedTask);
                        _fetchTasks();
                      } catch (e) {
                        _showErrorSnackBar(
                            'Error al actualizar el estado de la tarea');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskModal(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool?) onStatusChanged;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Checkbox(
              value: task.status == 'completed',
              onChanged: onStatusChanged,
              activeColor: const Color(0xFFE94560),
              checkColor: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: task.status == 'completed'
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(task.dueDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(task.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        statusText = 'Pendiente';
        break;
      case 'in_progress':
        chipColor = Colors.blue;
        statusText = 'En Progreso';
        break;
      case 'completed':
        chipColor = Colors.green;
        statusText = 'Completada';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Desconocido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10,
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
