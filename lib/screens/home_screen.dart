import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF3F51B5)),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          _getTitle(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: const ClipOval(
                child: Icon(Icons.person, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(taskProvider),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 2 ? FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen())),
        backgroundColor: const Color(0xFF2962FF),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3F51B5),
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'TODAY'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'HISTORY'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'REPEAT'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'ANALYTICS'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SETTINGS'),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0: return 'Today';
      case 1: return 'History';
      case 2: return 'Repeat';
      case 3: return 'Analytics';
      case 4: return 'Settings';
      default: return 'Task Manager';
    }
  }

  Widget _buildBody(TaskProvider provider) {
    switch (_selectedIndex) {
      case 0: return _buildTodayView(provider);
      case 1: return _buildHistoryView(provider);
      case 2: return _buildRepeatView(provider);
      case 3: return const Center(child: Text("Analytics View"));
      case 4: return const Center(child: Text("Settings View"));
      default: return Container();
    }
  }

  Widget _buildTodayView(TaskProvider provider) {
    final todayTasks = provider.todayTasks;
    final totalToday = todayTasks.length;
    final completedToday = todayTasks.where((t) => t.isCompleted).length;
    final progress = totalToday == 0 ? 0.0 : completedToday / totalToday;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSummaryCard(
            title: 'YOUR DAILY MOMENTUM',
            mainValue: '${(progress * 100).toInt()}%',
            subText: 'Completed',
            bottomTextLeft: '$completedToday of $totalToday Tasks done',
            bottomTextRight: '${totalToday - completedToday} remaining',
            progress: progress,
          ),
          const SizedBox(height: 32),
          const Text(
            'Focus list',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF263238)),
          ),
          const SizedBox(height: 16),
          _buildTaskList(todayTasks, "No tasks for today"),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildRepeatView(TaskProvider provider) {
    final repeatTasks = provider.repeatedTasks;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'RECURRENCE ENGINE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3D5AFE),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Systematic Flow.',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Automating your core rituals to maintain cognitive capacity for deep, creative work.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF78909C),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          
          if (repeatTasks.isNotEmpty)
            _buildFeaturedRepeatCard(repeatTasks.first)
          else
            _buildEmptyFeaturedCard(),
            
          const SizedBox(height: 24),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0043CE),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                const SizedBox(height: 12),
                Text(
                  '${repeatTasks.length}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Active Automations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          ...repeatTasks.skip(1).map((task) => _buildRepeatTaskItem(task)).toList(),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildFeaturedRepeatCard(Task task) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.access_time_filled, color: Color(0xFF3D5AFE), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Strategic alignment and task pruning',
                      style: TextStyle(fontSize: 13, color: Color(0xFF90A4AE)),
                    ),
                  ],
                ),
              ),
              Switch(
                value: true, 
                onChanged: (v){},
                activeColor: const Color(0xFF2962FF),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SCHEDULE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF90A4AE))),
                    const SizedBox(height: 4),
                    Text(
                      task.repeat == 'daily' ? 'Every Day' : 'Every Monday',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A237E)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NEXT RUN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF90A4AE))),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, HH:mm').format(task.dueDate),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF3D5AFE)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                  SizedBox(width: 4),
                  Text('+2', style: TextStyle(fontSize: 12, color: Color(0xFF3D5AFE), fontWeight: FontWeight.bold)),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text('Edit Schedule', style: TextStyle(color: Color(0xFF3D5AFE), fontWeight: FontWeight.w800)),
                    Icon(Icons.chevron_right, size: 16, color: Color(0xFF3D5AFE)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF00796B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A237E)),
                    ),
                    Text(
                      task.repeat == 'daily' ? 'Daily at ${DateFormat('HH:mm').format(task.dueDate)}' : 'Weekly on Monday',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF78909C)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 20),
              Switch(
                value: true, 
                onChanged: (v){},
                activeColor: const Color(0xFF2962FF),
              ),
              const Spacer(),
              const Icon(Icons.more_vert, color: Color(0xFF78909C)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE8EAF6), width: 2),
      ),
      child: const Center(
        child: Text("No featured automation", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildHistoryView(TaskProvider provider) {
    final completedTasks = provider.completedTasks;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WEEKLY PERFORMANCE',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF5C6BC0), letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${completedTasks.length}',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF2962FF)),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Tasks Achieved',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A237E)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "You've reached 85% of your weekly focus goal. The editorial queue is looking pristine.",
                  style: TextStyle(fontSize: 14, color: Colors.blueGrey[700], height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("VELOCITY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.blueGrey[400])),
                          const SizedBox(height: 4),
                          const Text("+12% vs last week", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A237E))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("CONSISTENCY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.blueGrey[400])),
                          const SizedBox(height: 4),
                          const Text("5 Day Streak", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A237E))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Archive',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF263238)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Clear all', style: TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHistoryList(completedTasks),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF5C6BC0)),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Looking back fuels moving forward.\nOlder tasks are archived after 30 days.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String mainValue,
    required String subText,
    required String bottomTextLeft,
    required String bottomTextRight,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF0F4FF).withOpacity(0.8), const Color(0xFFF0F4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF5C6BC0), letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                mainValue,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF1A237E)),
              ),
              const SizedBox(width: 8),
              Text(
                subText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF5C6BC0)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bottomTextLeft, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1A237E), fontSize: 14)),
              Text(bottomTextRight, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF3F51B5), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE0E7FF),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3F51B5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, String emptyMessage) {
    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(child: Text(emptyMessage, style: const TextStyle(color: Colors.grey))),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskTile(task: tasks[index]),
    );
  }

  Widget _buildHistoryList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: Text("No archived tasks", style: TextStyle(color: Colors.grey))));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) => HistoryTaskTile(task: tasks[index]),
    );
  }
}

class HistoryTaskTile extends StatelessWidget {
  final Task task;
  const HistoryTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF00695C),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF263238)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.blueGrey[400]),
                        const SizedBox(width: 6),
                        Text(
                          "Completed ${DateFormat('MMM d, yyyy').format(task.dueDate)}",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey[400]),
                        ),
                        const SizedBox(width: 12),
                        const Text("•", style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 12),
                        const Text(
                          "STRATEGY", 
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF00897B), letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
