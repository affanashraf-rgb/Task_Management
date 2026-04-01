import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/task_model.dart';

class ExportService {
  Future<void> exportToCSV(List<Task> tasks) async {
    List<List<dynamic>> rows = [];
    rows.add(["ID", "Title", "Description", "Due Date", "Completed", "Repeat"]);

    for (var task in tasks) {
      rows.add([
        task.id,
        task.title,
        task.description,
        task.dueDate.toIso8601String(),
        task.isCompleted,
        task.repeat,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getTemporaryDirectory();
    final path = "\${directory.path}/tasks.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(path)], text: 'Exported Tasks CSV');
  }

  Future<void> exportToPDF(List<Task> tasks) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Task List", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              ...tasks.map((task) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Text("\${task.title} - \${task.isCompleted ? 'Completed' : 'Pending'}"),
              )),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'tasks.pdf');
  }
}
