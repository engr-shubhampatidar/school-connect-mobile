
import 'package:schoolconnect/export.dart';

class AppProviders {
  static MultiProvider init({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleProvider()),
      
      ],
      child: child,
    );
  }
}
