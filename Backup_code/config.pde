import processing.data.*;

import g4p_controls.*;

GTextField txf1, txf2, txf3;



String last_saved_date;
int frequency;
int i = 0;
JSONArray data;

String filePath = "config.json";

String paths[][] = new String[100][2];


void setup()
{
  size(1000, 750);
  ui();
  read();
}

void draw()
{
  background(150);


  fill(120);
  rect(10, 395, 170, 25);
  rect(130, 430, 50, 25);
  rect(10, 465, 170, 25);
  rect(130, 500, 50, 25);
  rect(375, 600, 50, 25);
  rect(375, 650, 50, 25);
  rect(500, 600, 100, 75);
  rect(0, 0, 750, 150);

  textSize(20);
  fill(255);
  text("last saved " + last_saved_date, 11, 415);
  text("Reset", 131, 450);
  text("once every " + frequency + " days", 11, 485);
  text("Send", 131, 520);
  text("Send", 378, 620);
  text("Clear", 378, 670);
  text("Save", 530, 643);
  textSize(100);
  text("Backup Maker", 90, 100);
  textSize(20);
  text("Configurator", 620, 125);

  textSize(10);
  fill(90);
  rect(750, 0, 250, 1000);
  for (int j = 0; j < i; j++)
  {
    fill(255);
    text(paths[j][0] + " to " + paths[j][1], 760, 20 * (j + 1));
    fill(255, 0, 0);
    rect(740, 20 * j + 8, 16, 16);
  }
}
boolean check_date(String old_date, String new_date, int days_passed)
{
  int old_time[] = int(split(old_date, "."));
  int new_time[] = int(split(new_date, "."));
  int old_days = old_time[0] + 30 * (old_time[1] - 1) + 365 * (old_time[2] - 1);
  int new_days = new_time[0] + 30 * (new_time[1] - 1) + 365 * (new_time[2] - 1);
  if (old_days + days_passed <= new_days) return true;
  else return false;


  //if (old_time[0] + 7 <= new_time[0]) return true; // chujowy sposob
  //else return false;
}
String current_date()
{
  String r = day() + "." + month() + "." + year();
  return r;
}
void mouseClicked()
{
  float x = mouseX;
  float y = mouseY;
  if (x > 130 && x < 180 && y > 500 && y < 525)
  {
    frequency = int(txf3.getText());
  }
  if (x > 130 && x < 180 && y > 430 && y < 455)
  {
    last_saved_date = current_date();
  }
  if (x > 375 && x < 425 && y > 600 && y < 625)
  {
    paths[i][0] = txf1.getText();
    paths[i][1] = txf2.getText();
    i++;
  }
  if (x > 375 && x < 425 && y > 650 && y < 675)
  {
    txf1.setText("");
    txf2.setText("");
  }
  if (x > 500 && x < 600 && y > 600 && y < 675)
  {
    save();
  }
  for (int j = 0; j < i; j++)
  {
    if (x > 740 && x < 756 && y > 20*j + 8 && y < 20*j + 24)
    {
      paths[j][0] = "";
      paths[j][1] = "";
      fill_gaps();
    }
  }
}
void ui()
{

  txf1 = new GTextField(this, 10, 600, 350, 25);
  txf1.tag = "txf1";
  txf1.setPromptText("from...");

  txf2 = new GTextField(this, 10, 650, 350, 25);
  txf2.tag = "txf2";
  txf2.setPromptText("to...");


  txf3 = new GTextField(this, 10, 500, 100, 25);
  txf3.tag = "txf2";
  txf3.setPromptText("frequency(days)");
}
void read()
{
  data = loadJSONArray(filePath);
  if (data == null)
  {
    data = new JSONArray();
  } else
  {
    JSONObject obj = data.getJSONObject(0);
    last_saved_date = obj.getString("last saved");
    frequency = obj.getInt("frequency");
  }
  boolean all = true;
  int i_temp = 0;
  while (all)
  {
    if (i_temp + 1 < data.size())
    {
      JSONObject obj = data.getJSONObject(i_temp + 1);
      paths[i_temp][0] = obj.getString("from");
      paths[i_temp][1] = obj.getString("to");
      i_temp++;
      i++;
    } else
    {
      all = false;
    }
  }
}

void save()
{
  JSONArray newData = new JSONArray();

  JSONObject newEntry = new JSONObject();

  newEntry.setString("last saved", last_saved_date);
  newEntry.setInt("frequency", frequency);

  newData.append(newEntry);
  for (int j = 0; j < i; j++)
  {
    JSONObject path = new JSONObject();
    path.setString("from", paths[j][0]);
    path.setString("to", paths[j][1]);
    newData.append(path);
  }


  saveJSONArray(newData, filePath);
}
void fill_gaps()
{
  boolean done = false;
  for (int j = 0; j < i; j++)
  {
    if (paths[j][0] == "")
    {
      paths[j][0] = paths[j + 1][0];
      paths[j][1] = paths[j + 1][1];
      paths[j + 1][0] = "";
      done = true;
    }
  }
  if (done) i--;
}
