import processing.net.*;
import processing.serial.*;
 
Server myServer;
Serial com;
String cmd;
int num = 0;
int num1 = 0;
 
void setup(){
  size(300,300);
  myServer = new Server(this, 3330);
  com = new Serial(this, "/dev/cu.usbmodem1411", 9600);
}
 
void draw(){
 
  Client client = myServer.available();
   
  if(client!=null){
   
    println("Client IP Adress :"+client.ip());
     
    if(client.available()>0){
      String clientData = client.readString();
      println("------------"+clientData);
       
      String[] httpRequest = trim(split(clientData,'\n'));
      if(split(httpRequest[0]," ").length > 1){
        cmd = split(httpRequest[0]," ")[1]; 
        cmd = cmd.substring(1); 
      }
       
      if(!(cmd.equals("favicon.ico"))){
        //html head
        client.write("HTTP/1.1 200 OK\n");
        client.write("Content-Type: text/html\n");
        client.write("\n");
        //html body
        client.write("<!DOCTYPE html public \"-//W3C//DTD HTML 4.0Transitional//EN\"><br/>"); 
        client.write("<html>");
        client.write("<head>");
        client.write("<title>Heel Comtrol</title>");
        client.write("<style type=\"text/css\">html{background-color:#e4cdc6;}</style>");
        //client.write("<script type=\"text/javascript\"src =\"script.js\"></script>");
        client.write("<meta name=\"viewport\" content=\"\" />");
        client.write("<link rel=\"stylesheet\" media=\"all\" type=\"text/css\" href=\"text.css\" />");
        client.write("<link rel=\"stylesheet\" media=\"all\" type=\"text/css\" href=\"tablet.css\" />");
        client.write("<link rel=\"stylesheet\" media=\"all\" type=\"text/css\" href=\"http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css\" />");
        client.write("</head>");
        client.write("<body>");
        client.write("<CENTER>");
        client.write("<img src=\"http://cslagfe-aio-app000.c4sa.net/title.png\">");
        client.write("<hr>");
        client.write("<br><br><br>");
        //client.write("<input type=\"image\" src=\"w1.png\" alt=\"HIGH\" onClick=\"click(1)\">");
        //client.write("<input type=\"image\" src=\"w2.png\" alt=\"LOW\" onClick=\"click(0)\">");
        client.write("<a href=\"/?pin13=a\" target=\"ifr\" class=\"btn btn-xs\"><input type=\"image\" src=\"http://cslagfe-aio-app000.c4sa.net/w1.png\"  alt=\"HIGH\"></a>");
        client.write("<a href=\"/?pin13=b\" target=\"ifr\" class=\"btn btn-xs\"><input type=\"image\" src=\"http://cslagfe-aio-app000.c4sa.net/w2.png\"  alt=\"LOW\"></a>");
        client.write("<br>");
        client.write("<img src=\"http://cslagfe-aio-app000.c4sa.net/pinkH.png\">");
        client.write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
        client.write("<img src=\"http://cslagfe-aio-app000.c4sa.net/pink.png\">");
        client.write(" </CENTER>");
        client.write("<hr>");
        client.write("<div align=\"right\">");
        client.write("<font size = 4 color=\"#919191\">");
        client.write("by aoi fumi...</font></div>");
        client.write("</body>");
        client.write("</html>");
        //cmd=request.getHeader("Referer");
        //Arduino
        for(int i=0;i<httpRequest.length;i++){
          println("cmddddd"+httpRequest[i]);
          if(httpRequest[i].endsWith("pin13=a")){
             num++;
             com.write('a'+num);
             num1=0;
          }else if(httpRequest[i].endsWith("pin13=b")){ 
             num1++;
             com.write('b'+ 0);
            num=0;
          }
        }
        /*if(cmd.equals("a")){
           num++;
           com.write('a'+num);
           num1=0;
        }else if(cmd.equals("b")){ 
          num1++;
          com.write('b'+num1);
          num=0;
        }*/
      }

      //}
      client.stop();
    }
  }
}