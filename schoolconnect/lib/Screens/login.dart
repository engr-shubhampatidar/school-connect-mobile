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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
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
              fontSize: 20,
              color: MyColor.color737373,
              fontWeight: FontWeight.w600,
            ),
          ),
          hSized10,

          // Container(
          //   height: 35,

          //   width: 175,
          //   decoration: const BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //     shape: BoxShape.rectangle,
          //     color: MyColor.colorEEF4FF, //remove this when you add image.
          //   ),

          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Container(
          //         width: 29,
          //         height: 29,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(10)),
          //           border: Border.all(color: MyColor.colorD7E3FC),
          //           shape: BoxShape.rectangle,
          //           color: MyColor.white, //remove this when you add image.
          //         ),
          //         child: Text("Admin"),
          //       ),
          //       Container(
          //         width: 29,
          //         height: 29,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(10)),
          //           border: Border.all(color: MyColor.colorD7E3FC),
          //           shape: BoxShape.rectangle,
          //           color: MyColor.white, //remove this when you add image.
          //         ),
          //         child: Text("Teacher"),
          //       ),
          //       Container(
          //         width: 29,
          //         height: 29,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(10)),
          //           border: Border.all(color: MyColor.colorD7E3FC),
          //           shape: BoxShape.rectangle,
          //           color: MyColor.white, //remove this when you add image.
          //         ),
          //         child: Text("Studnet"),
          //       ),
          //     ],
          //   ),
          // ),


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
            isSelected: roleProvider.selectedRole == UserRole.teacher,
          ),
          _roleButton(
            context,
            title: "Student",
            role: UserRole.student,
            isSelected: roleProvider.selectedRole == UserRole.student,
          ),
        ],
      ),
    );
  },
),
        ],
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
    child: GestureDetector(
      onTap: () {
        context.read<RoleProvider>().selectRole(role);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
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
            color: isSelected
                ? MyColor.colorD7E3FC
                : MyColor.color737373,
          ),
        ),
      ),
    ),
  );
}

}
