abstract class NavigationServiceBase {
  Future navigateTo(String route, Object? arguments);
  void navigateBack();
  void navigateBackToStart();
  Future navigateToGameOverPopup(bool gameWon);
}