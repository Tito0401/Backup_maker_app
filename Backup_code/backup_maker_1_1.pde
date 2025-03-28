import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import processing.data.*;

String last_saved_date;
int frequency;
int i = 0;
JSONArray data;

String filePath = "config.json";
String paths[][] = new String[100][2];


void setup() 
{
  size(450,80);
  textSize(48);
  fill(0);
  text("Backup in progress...", 10, 50); 
}

void draw()
{
  read();
  if(check_date(last_saved_date, current_date(),frequency))backup();
  exit();
}

void backup()
{
  last_saved_date = current_date();
  for(int j = 0; j < i; j++)
  {
    File dir1 = new File(paths[j][0]);
    File dir2 = new File(paths[j][1]);
    if (dir1.isDirectory() && dir2.isDirectory()) 
    {
      copyDirectoryRecursively(dir1, dir2);
    } 
    else 
    {
      println("provided path " + j + " is not a directory.");
    }
  }
  save();
}
void copyDirectoryRecursively(File sourceDir, File destDir) {
  File[] filesInSourceDir = sourceDir.listFiles();
  
  if (filesInSourceDir != null) {
    for (File file : filesInSourceDir) {
      File destFile = new File(destDir, file.getName());
      
      if (file.isDirectory()) {
        // Create the directory if it does not exist in the destination
        if (!destFile.exists()) {
          destFile.mkdirs();
          println("Created directory: " + destFile.getPath());
        }
        // Recursively copy the subdirectory
        copyDirectoryRecursively(file, destFile);
      } else {
        // Copy the file if it does not exist in the destination
        if (!destFile.exists()) {
          try {
            Files.copy(file.toPath(), destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            println("Copied: " + file.getPath() + " to " + destFile.getPath());
          } catch (IOException e) {
            e.printStackTrace();
          }
        } else {
          println("Skipped (already exists): " + destFile.getPath());
        }
      }
    }
  }
}
void read()
{
  data = loadJSONArray(filePath);
  if (data == null) 
  {
    data = new JSONArray();
  }
  else
  {
    JSONObject obj = data.getJSONObject(0); 
    last_saved_date = obj.getString("last saved");
    frequency = obj.getInt("frequency");
  }
  boolean all = true;
  int i_temp = 0;
  while(all)
  {
    if(i_temp + 1 < data.size())
    {
      JSONObject obj = data.getJSONObject(i_temp + 1); 
      paths[i_temp][0] = obj.getString("from");
      paths[i_temp][1] = obj.getString("to");
      i_temp++;
      i++;
    }
    else
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
  newEntry.setInt("frequency",  frequency);
  
  newData.append(newEntry);
  for(int j = 0; j < i; j++)
  {
    JSONObject path = new JSONObject();
    path.setString("from", paths[j][0]);
    path.setString("to",  paths[j][1]);
    newData.append(path);
  }

  
  saveJSONArray(newData, filePath);
}

boolean check_date(String old_date,String new_date,int days_passed)
{
  int old_time[] = int(split(old_date,"."));
  int new_time[] = int(split(new_date,"."));
  int old_days = old_time[0] + 30 * (old_time[1] - 1) + 365 * (old_time[2] - 1);
  int new_days = new_time[0] + 30 * (new_time[1] - 1) + 365 * (new_time[2] - 1);
  if(old_days + days_passed <= new_days) return true;
  else return false;
  
  //if (old_time[0] + 7 <= new_time[0]) return true; // chujowy sposob
  //else return false;
}
String current_date()
{
  String r = day() + "." + month() + "." + year();
  return r;
}
