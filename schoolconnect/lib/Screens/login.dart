import 'package:schoolconnect/constants/Mycolor.dart';
import 'package:schoolconnect/constants/imageAssets.dart';
import 'package:schoolconnect/constants/sizesbox.dart';
import 'package:schoolconnect/export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
          Stack(
            children: [
              /// 🔴 Top Section
              Container(
                height: 288,
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
            width: 54,
            height: 54,
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
                  height: 44,
                  width: 260,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: MyColor.colorEEF4FF,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _roleButton(
                        context,
                        title: "Admin",
                        role: UserRole.admin,
                        isSelected: roleProvider.selectedRole == UserRole.admin,
                      ),
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

            /// 📧 Email Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
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
                          color: MyColor.ColorE83979,
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
                          color: MyColor.ColorE83979,
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
                      width: size.width * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.color021034,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text;
                          // TODO: implement sign-in logic
                          // temporary placeholder to avoid unused local warnings
                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter email and password',
                                ),
                              ),
                            );
                            return;
                          }
                        },
                        child: const Text(
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
