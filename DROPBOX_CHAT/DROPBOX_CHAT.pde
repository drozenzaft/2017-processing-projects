//known issues: holding a valid key and then pressing a bad key crashes the program, and ctrl+key
//types a weird character, and i have no idea how to fix either of these
String[] cat;
//where the chatlog's data is stored
ArrayList<String> a, b;
//keys that shouldn't be typed
ArrayList<Integer> badKeys;
//a is the split arraylist of the previous text in the chatlog
//b is the split arraylist of the text currently in the field
int index, charLimit;
//index is where your vertical line thing is in the text field
//charLimit is the number of characters that you can still
//type into the text field before it won't let you type more
String time;
//for displaying the time
PFont font;
//processing's default font isn't monospaced, but i needed one
void setup() {
  size(1200, 600);
  a = new ArrayList<String>();
  b = new ArrayList<String>();
  index = 0;
  charLimit = 87;
  //String[] fontList = PFont.list();
  //printArray(fontList);
  font = createFont("Lucida Sans Typewriter Regular", 18);
  textFont(font);
  cat = loadStrings("chatlog.txt");
  for (int j = 0; j < cat.length; j++) {
    a.add(cat[j]);
  }
  badKeys = new ArrayList<Integer>();
  int[] badKeysArray = {13, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 157, 129, 131, 135, 20, 0, 27, 33, 34, 35, 
    36, 37, 38, 39, 40, 8, 9, 10, 17, 19, 20, 144, 145};
  for (int x : badKeysArray) badKeys.add(x);
}
void draw() {
  background(0);
  textSize(18);
  int hours = hour();
  String t = " PM";
  if (hours > 12) {
    hours %= 12;
  } else if (hours == 0) {
    hours = 12;
    t = " AM";
  } else if (hours < 12) {
    t = " AM";
  }
  String months = nf(month(), 2);
  String days = nf(day(), 2);
  String hour = nf(hours, 2);
  String minute = nf(minute(), 2);
  String second = nf(second(), 2);
  time = "["+months+"/"+days+"/"+year()+" - "+hour+":"+minute+":"+second+t+"] "+System.getProperty("user.name") + ": ";
  cat = loadStrings("chatlog.txt");
  String field = "";
  //for receiving chat input from others in-window
  if (cat.length > a.size()) {
    for (int i = a.size(); i < cat.length; i++) {
      a.add(cat[i]);
    }
  }
  for (int j = 0; j < 6; j++) {
    text(a.get(j), 3, j*20+20);
  }
  //displays previous lines of chat
  if (a.size() > 26) {
    for (int c = a.size()-1; c >= a.size()-20 && c >= 6; c--) {
      text(a.get(c), 3, height-55-((a.size()-c)*20+5));
    }
  } else {
    for (int c = 6; c < a.size(); c++) {
      text(a.get(c), 3, c*20+20);
    }
  }
  //the rest of the draw displays the text in the field
  for (int i = 0; i < b.size(); i++) {
    if (b.get(i).equals("\n")) field += "\\n";
    else if (i == index) {
      field += "|";
    }
    field += b.get(i);
  }
  if (index == b.size()) field += "|";
  text("Start typing: " + field, 10, height-55);
  stroke(255);
  line(160, height-55, width/1.2+width/16+width/30+width/600, height-55);
  //println(Arrays.toString(a.toArray(new String[]{})));
}
void keyPressed() {
  println(keyCode);
  //limit ensures that messages fit on the screen
  boolean limit = charLimit > 0;
  //arrow key control in text field
  if (keyCode == LEFT && index > 0) {
    index--;
  } else if (keyCode == RIGHT && index < b.size()) {
    index++;
    //tab: an extra space, if you have > 1 character remaining
  } else if (keyCode == TAB && limit) {
    if (charLimit > 1) {
      b.add(index, "  ");
      charLimit -= 2;
      index++;
    } else {
      b.add(index, " ");
      index++;
      charLimit--;
    }
    //up arrow key moves cursor to the beginning of the line
  } else if (keyCode == UP) {
    index = 0;
    //down arrow key moves cursor to the end of the line
  } else if (keyCode == DOWN) {
    index = b.size();
    //home key moves cursor to the beginning of the line
  } else if (keyCode == 35) {
    index = b.size();
    //end key moves cursor to the end of the line
  } else if (keyCode == 36) {
    index = 0;
    //backspace, well, backspaces
  } else if (keyCode == 8 && index > 0) {
    try {
      if (b.get(index).length() > 1) {
        charLimit += 2;
      } else {
        charLimit++;
      }
      index--;
      b.remove(index);
    }
    catch (IndexOutOfBoundsException e) {
      if (b.get(b.size()-1).length() > 1) {
        charLimit += 2;
      } else if (b.get(b.size()-1).length() == 1) {
        charLimit++;
      }
      b.remove(b.size()-1);
      index = b.size();
    }
  }
  //you can type while holding alt or shift, but alt or shift aren't typable characters themselves
  else if (keyCode == 16 || keyCode == 18) {
  }
    //pressing enter submits your message and writes to the file
  else if (keyCode == ENTER && notSpaces()) {
    enter();
  }
  //i don't want to type while these keys are pressed
  else if (badKeys.contains(keyCode) ) {
  }
  //for all keys with nonspecial functions: just types them
  else if (limit) {
    b.add(index, key+"");
    charLimit--;
    index++;
  }
}
//you cannot submit a blank message or a message with only spaces 
boolean notSpaces() {
  for (String s : b) {
    if (!s.equals(" ") && !s.equals("  ")) return true;
  }
  return false;
}
//unsplits the text field arraylist to prepare to write to the file
String unsplit(ArrayList<String> ar) {
  String ans = "";
  for (String a : ar) ans += a;
  return ans;
}
//appends the text in the text field to the other arraylist, which
//contains the previous messages in the chat log
String[] join(ArrayList<String> split) {
  String unsplit = unsplit(b);
  String[] ans = new String[split.size()+1];
  for (int i = 0; i < split.size(); i++) ans[i] = split.get(i);
  ans[ans.length-1] = unsplit;
  return ans;
}
//adds the timestamp, writes to the file, and resets the text field 
//called when you press enter
void enter() {
  b.add(0, time);
  saveStrings("chatlog.txt", join(a));
  a.add(unsplit(b));
  b = new ArrayList<String>();
  index = 0;
  charLimit = 87;
}
