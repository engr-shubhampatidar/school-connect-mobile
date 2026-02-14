class Apiserver {
  static const String baseurl =
      "https://school-connect-mgmt-backend.vercel.app/api";
  static const String loginteacher = "$baseurl/teacher/auth/login";
  static const String attendanceclass = "$baseurl/attendance/";

  static const String teacherclass = "$baseurl/teacher/class";

  static const String attendance = "$baseurl/attendance";

  // Leave management endpoints
  // GET  /leaves          -> fetch current user's leaves
  // POST /leaves          -> submit a new leave request
  static const String leaves = "$baseurl/leaves";

  // GET  /requests        -> fetch student requests (for admin/teacher)
  // PATCH /requests/{id}  -> update (approve/reject) a request
  static const String requests = "$baseurl/requests";

  // helper to build request-by-id URL
  static String requestById(String id) => "$baseurl/requests/$id";
}

// https://school-connect-mgmt-backend.vercel.app/api/attendance
