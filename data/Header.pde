class Header extends Player {
  //"name","position","role","draftYear","points","rebounds","assists","steals","blocks"
  Header() {
    super("bs","hi",9999,2);
  }
  String toString() {
    info = new String[]{
    "Name","Position","Role","Draft Year","Points","Rebounds","Assists","Steals","Blocks"};
    return Arrays.toString(info).substring(1,Arrays.toString(info).length()-1);
  }
}