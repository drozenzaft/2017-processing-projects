import java.util.Arrays;
//Player,Position,ID,Draft Year,Projected SPM,Superstar,Starter,Role Player,Bust
String[][] data;
String[] lines;
ArrayList<Player> players;
void setup() {
  size(1280, 1280);
  players = new ArrayList<Player>();
  lines = loadStrings("projection.csv");
  data = new String[lines.length][];
  players.add(new Header());
  for (int i = 1; i < data.length; i++) {
    data[i] = split(lines[i], ",");
    players.add(new Player(data[i][0], data[i][1], Integer.parseInt(data[i][3]), Float.parseFloat(data[i][5])));
    println(players.get(i-1));
  }
}
void draw() {
  background(0);
  textSize(15);
  fill(255);
  println(players);
  stroke(255);
  int i = 0;
  int x = width/12;
  int factor = 90;
  for (Player p : players) {
    if (p.role.equals("Superstar") && p.draftYear >= 2003) {
      for (int j = 0; j < p.info.length; j++) {
        if (j == 0) factor = 220;
        else if (j == 2) factor = 120;
        else factor = 90;
        if (j != 0) line(x-factor/4, 0, x-factor/4, height);
        else line(x-100, i*14+17, width, i*14+17);
        text(p.info[j], x-100, i*14+17);
        x += factor;
      }
      x = width/12;
      i++;
    }
  }
  /*factor = 90;
   if (i <= height) {
   for (Player q : players) {
   if (q.role.equals("Starter")) {
   for (int j = 0; j < q.info.length; j++) {
   if (j == 0) factor = 220;
   else if (j == 2) factor = 120;
   else factor = 90;
   if (j != 0) line(x-factor/4, 0, x-factor/4, height);
   else line(x, i*14+17, width, i*14+17);
   text(q.info[j], x, i*14+17);
   x += factor;
   }
   x = width/12;
   i++;
   }
   }
   }
   factor = 90;*/
  if (i <= height) {
    for (Player r : players) {
      if (r.role.equals("Starter") && r.draftYear >= 2003 && r.draftYear <= 2009) {
        for (int j = 0; j < r.info.length; j++) {
          if (j == 0) factor = 220;
          else if (j == 2) factor = 120;
          else factor = 90;
          if (j != 0) line(x-factor/4, 0, x-factor/4, height);
          else line(x-100, i*14+17, width, i*14+17);
          text(r.info[j], x-100, i*14+17);
          x += factor;
        }
        x = width/12;
        i++;
      }
    }
  }
  fill(0);
  stroke(0);
  //rect(x,0,width,height);
}