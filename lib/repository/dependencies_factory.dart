import 'package:recipe_app/repository/shared_prefs_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependenciesFactory {
  Stream<SharedPreferences> sharedPreferences() =>
      SharedPreferences.getInstance().asStream();

  RepoFactory repoFactory() => RepoFactory();
}

class DependenciesHelper {
  static DependenciesFactory dependenciesFactory() => DependenciesFactory();
}

class RepoFactory {
  SharedPrefRepo sharedPrefRepo() => SharedPrefRepo();
}
