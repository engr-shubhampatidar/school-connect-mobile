import 'dart:math' as math;
import 'dart:convert';
import 'package:schoolconnect/constants/Mycolor.dart';
import 'package:schoolconnect/constants/ApiServer.dart';
import 'package:schoolconnect/constants/imageAssets.dart';
import 'package:schoolconnect/constants/sizesbox.dart';
import 'package:schoolconnect/export.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _rollController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rollController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final contentMaxWidth = math.min(size.width * 0.9, 600.0);
    final avatarSize = math.min(size.width * 0.14, 120.0);
    final horizontalPadding = math.min(size.width * 0.06, 40.0);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                /// 🔴 Top Section
                Container(
                  height: size.height * 0.33,
                  width: size.width,
                  color: MyColor.ColorE83979,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(AssetsImages.loginhero, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Logo
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Text(
                                      "MAXUSE",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "CS",
                                      style: TextStyle(
                                        fontSize: 4,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "INSTITUTE.",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            /// Heading
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Sign in to SchoolConnect",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Secure access For Admin, Teachers and Student",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🧍 Login Person Image (JUST NICHE)
              ],
            ),
            hSized30,
            Image.asset(
              AssetsImages.loginperson,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.contain,
            ),
            hSized10,
            Text(
              "Sign In Portal",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            hSized10,
            Text(
              "School Management System",
              style: TextStyle(
                fontSize: 11,
                color: MyColor.color737373,
                fontWeight: FontWeight.w600,
              ),
            ),
            hSized20,

            Consumer<RoleProvider>(
              builder: (context, roleProvider, _) {
                return Container(
                  height: size.height * 0.06,
                  width: contentMaxWidth,
                  padding: EdgeInsets.all(horizontalPadding * 0.25),
                  decoration: BoxDecoration(
                    color: MyColor.colorEEF4FF,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      // _roleButton(
                      //   context,
                      //   title: "Admin",
                      //   role: UserRole.admin,
                      //   isSelected: roleProvider.selectedRole == UserRole.admin,
                      // ),
                      _roleButton(
                        context,
                        title: "Teacher",
                        role: UserRole.teacher,
                        isSelected:
                            roleProvider.selectedRole == UserRole.teacher,
                      ),
                      _roleButton(
                        context,
                        title: "Student",
                        role: UserRole.student,
                        isSelected:
                            roleProvider.selectedRole == UserRole.student,
                      ),
                    ],
                  ),
                );
              },
            ),
            hSized30,

            /// 📧 Email / Roll Number Input Field
            Consumer<RoleProvider>(
              builder: (context, roleProvider, _) {
                final isStudent = roleProvider.selectedRole == UserRole.student;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isStudent ? 'Roll Number' : 'Email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: isStudent
                            ? _rollController
                            : _emailController,
                        keyboardType: isStudent
                            ? TextInputType.text
                            : TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: isStudent
                              ? 'Enter roll (e.g. 1C-AA-8561)'
                              : 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: MyColor.colorEEF4FF,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            hSized20,

            /// 🔒 Password Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          // TODO: navigate to reset password
                        },
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: MyColor.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xFF666666),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: MyColor.colorEEF4FF,
                          width: 1.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  hSized30,

                  // Sign In Button
                  Center(
                    child: SizedBox(
                      width: contentMaxWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.color021034,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (_isLoading) return;
                          setState(() {
                            _isLoading = true;
                          });

                          final role = context
                              .read<RoleProvider>()
                              .selectedRole;
                          final password = _passwordController.text.trim();

                          String url;
                          if (role == UserRole.teacher) {
                            url = Apiserver.loginteacher;
                          } else if (role == UserRole.admin) {
                            url = Apiserver.baseurl + "/api/admin/auth/login";
                          } else {
                            url = Apiserver.baseurl + "/api/student/auth/login";
                          }

                          Map<String, dynamic> payload;

                          if (role == UserRole.student) {
                            // For students validate roll first, then password
                            final roll = _rollController.text.trim();
                            final rollPattern = RegExp(
                              r'^[0-9][A-Z]-[A-Z]{2}-[0-9]{4}$',
                            );
                            if (roll.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter roll number'),
                                ),
                              );
                              setState(() => _isLoading = false);
                              return;
                            }
                            if (!rollPattern.hasMatch(roll.toUpperCase())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Invalid roll number. Expected format: 1C-AA-8561',
                                  ),
                                ),
                              );
                              setState(() => _isLoading = false);
                              return;
                            }
                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter password'),
                                ),
                              );
                              setState(() => _isLoading = false);
                              return;
                            }

                            payload = {
                              'roll': roll,
                              'password': password,
                              'role': 'student',
                            };
                          } else {
                            // For Admin/Teacher validate email first, then password
                            final email = _emailController.text.trim();
                            final emailPattern = RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            );
                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter email'),
                                ),
                              );
                              setState(() => _isLoading = false);
                              return;
                            }
                            if (!emailPattern.hasMatch(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid email'),
                                ),
                              );
                              setState(() => _isLoading = false);
                              return;
                            }
                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter password'),
                                ),
                              );
                              setState(() => _isLoading = false);
                              return;
                            }

                            // For Teacher, backend expects only email & password keys.
                            if (role == UserRole.teacher) {
                              payload = {'email': email, 'password': password};
                            } else {
                              // Admin still sends role along with email/password
                              payload = {
                                'email': email,
                                'password': password,
                                'role': 'admin',
                              };
                            }
                          }

                          if (role == UserRole.teacher) {
                            try {
                              final uri = Uri.parse(url);
                              final response = await http.post(
                                uri,
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode(payload),
                              );
                              debugPrint(
                                'Response status: ${response.statusCode}',
                              );
                              try {
                                final parsed = jsonDecode(response.body);
                                final pretty = const JsonEncoder.withIndent(
                                  '  ',
                                ).convert(parsed);
                                debugPrint('Response body (pretty):\n$pretty');
                              } catch (_) {
                                debugPrint(
                                  'Response body (raw): ${response.body}',
                                );
                              }
                              debugPrint(
                                'Response url: ${response.request?.url}',
                              );

                              if (response.statusCode >= 200 &&
                                  response.statusCode < 300) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login successful'),
                                  ),
                                );

                                // Try to extract token from response body and persist session
                                try {
                                  final bodyJson = jsonDecode(response.body);
                                  String? token;

                                  if (bodyJson is Map) {
                                    token =
                                        bodyJson['token']?.toString() ??
                                        bodyJson['accessToken']?.toString() ??
                                        bodyJson['access_token']?.toString();

                                    if (token == null &&
                                        bodyJson['data'] is Map) {
                                      final data = bodyJson['data'] as Map;
                                      token =
                                          data['token']?.toString() ??
                                          data['accessToken']?.toString() ??
                                          data['access_token']?.toString();
                                    }
                                  }

                                  if (token != null) {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('auth_token', token);
                                    await prefs.setString(
                                      'access_token',
                                      token,
                                    );
                                    await prefs.setString(
                                      'user_role',
                                      role.toString(),
                                    );
                                    debugPrint(
                                      'Saved auth_token: ${token.replaceAll(RegExp(r".(?!.{4})"), "*")}',
                                    );
                                    debugPrint(
                                      'Saved access_token key as well',
                                    );
                                  } else {
                                    debugPrint(
                                      'No token found in response. Response body: ${response.body}',
                                    );
                                  }
                                } catch (e) {
                                  debugPrint('Token parsing error: $e');
                                }

                                if (role == UserRole.teacher) {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/dashboard');
                                }
                                // token persisted (if present)
                              } else {
                                String message = 'Login failed';
                                try {
                                  final body = jsonDecode(response.body);
                                  if (body is Map && body['message'] != null) {
                                    message = body['message'].toString();
                                  }
                                } catch (_) {}
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Network error: $e')),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            // Do not call API for Admin/Student — only validate locally
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Login via API is enabled only for Teachers',
                                ),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),

                  hSized15,

                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            // TODO: show help or contact support
                          },
                          child: Text(
                            'Having trouble logging in?',
                            style: TextStyle(
                              color: MyColor.color021034,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        hSized8,
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            // TODO: show help or contact support
                          },
                          child: Text(
                            'Contact IT Support',
                            style: TextStyle(
                              color: MyColor.color377DFF,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        hSized10,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(
    BuildContext context, {
    required String title,
    required UserRole role,
    required bool isSelected,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent, // 🔥 important
        child: InkWell(
          splashColor: Colors.transparent, // ❌ no ripple
          highlightColor: Colors.transparent, // ❌ no black flash
          onTap: () {
            context.read<RoleProvider>().selectRole(role);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white
                  : MyColor.colorEEF4FF, // ❌ NEVER transparent
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: MyColor.colorD7E3FC)
                  : null,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MyColor.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
