class AttendanceClass {
  String? id;
  String? schoolId;
  String? classId;
  String? date;
  String? markedBy;
  String? status;
  List<Students>? students;
  String? createdAt;
  String? updatedAt;

  AttendanceClass({
    this.id,
    this.schoolId,
    this.classId,
    this.date,
    this.markedBy,
    this.status,
    this.students,
    this.createdAt,
    this.updatedAt,
  });

  AttendanceClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolId = json['schoolId'];
    classId = json['classId'];
    date = json['date'];
    markedBy = json['markedBy'];
    status = json['status'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(Students.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['schoolId'] = schoolId;
    data['classId'] = classId;
    data['date'] = date;
    data['markedBy'] = markedBy;
    data['status'] = status;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Students {
  String? id;
  String? attendanceId;
  String? studentId;
  String? status;
  String? createdAt;

  Students({
    this.id,
    this.attendanceId,
    this.studentId,
    this.status,
    this.createdAt,
  });

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attendanceId = json['attendanceId'];
    studentId = json['studentId'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attendanceId'] = attendanceId;
    data['studentId'] = studentId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
