class TeacherClass {
  final ClassInfo classInfo;
  final List<Student> students;

  TeacherClass({required this.classInfo, required this.students});

  factory TeacherClass.fromJson(Map<String, dynamic> json) {
    return TeacherClass(
      classInfo: ClassInfo.fromJson(json['class']),
      students: (json['students'] as List)
          .map((e) => Student.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class': classInfo.toJson(),
      'students': students.map((e) => e.toJson()).toList(),
    };
  }
}

class ClassInfo {
  final String id;
  final String name;
  final String section;

  ClassInfo({required this.id, required this.name, required this.section});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'],
      name: json['name'],
      section: json['section'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'section': section};
  }
}

class Student {
  final String id;
  final String name;
  final String rollNo;
  final String photoUrl;

  Student({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.photoUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      rollNo: json['rollNo'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'rollNo': rollNo, 'photoUrl': photoUrl};
  }
}
