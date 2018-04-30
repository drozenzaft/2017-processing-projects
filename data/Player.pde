class Player {
  String[] info;
  float points, rebounds, assists, steals, blocks;
  String name, position, role;
  int draftYear;
  float superstar, starter, rolePlayer, bust;
  Player(String nombre, String pos, int dY, float lbj) {
    name = nombre;
    position = pos;
    draftYear = dY;
    float stardom = random(50000);
    points = random(10)/10;
    rebounds = random(10)/10;
    assists = random(10)/10;
    steals = random(10)/10;
    blocks = random(10)/10;
    points += 18 + stardom/2500 + random(6);
    if (position.equals("PG")) {
      rebounds += 2 + random(8);
      assists += 4 + random(14);
      steals += 1 + random(3);
      blocks += random(1);
    }
    if (position.equals("SG")) {
      rebounds += 4 + random(5);
      assists += 3 + random(4);
      steals += 1 + random(3);
      blocks += random(1);
    }
    if (position.equals("SF")) {
      rebounds += 4 + random(8);
      assists += 4 + random(9);
      steals += random(3);
      blocks += random(2);
    }
    if (position.equals("PF")) {
      rebounds += 5 + random(7);
      assists += 1 + random(4);
      steals += random(2);
      blocks += random(5);
    }
    if (position.equals("C")) {
      rebounds += 7 + random(14);
      assists +=  1 + random(4);
      steals += random(2);
      blocks += random(5);
    }
    if (stardom*lbj > 4000) { //player is a superstar
      role = "Superstar";
      points /= 1.5;
      rebounds /= 1.5;
      assists /= 1.5;
      steals /= 1.5;
      blocks /= 1.5;
    } else if (stardom*lbj > 1000) {
      role = "Starter";
      points /= 3 + random(1) - random(1);
      rebounds /= 2.5;
      assists /= 2.5;
      steals /= 2.5;
      blocks /= 2.5;
    } else if (stardom*lbj > 500) {
      role = "Role Player";
      points /= 3.75;
      rebounds /= 3;
      assists /= 3;
      steals /= 3;
      blocks /= 3;
    } else {
      role = "Scrub";
    }
    println(name + "," + position + "," + role + ","+draftYear + "," +points + "," + rebounds + "," +assists+","+steals+","+blocks);
    println(lbj*stardom);
    tenths();
    setInfo();
  }
  String toString() {
    String a = Arrays.toString(info);
    return a.substring(1, a.length()-1);
  }
  void tenths() {
    points = round(points*10)/10.0;
    rebounds = round(rebounds*10)/10.0;
    assists = round(assists*10)/10.0;
    steals = round(steals*10)/10.0;
    blocks = round(blocks*10)/10.0;
  }
  void setInfo() {
    info = new String[9];
    info[0] = name;
    info[1] = position;
    info[2] = role;
    info[3] = ""+draftYear;
    info[4] = ""+points;
    info[5] = ""+rebounds;
    info[6] = ""+assists;
    info[7] = ""+steals;
    info[8] = ""+blocks;
  }
}