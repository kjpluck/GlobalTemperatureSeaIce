import com.hamoid.*;
VideoExport videoExport;

HashMap<Integer, TemperatureExtent> data = new HashMap<Integer,TemperatureExtent>();
PFont theFont;
int framesPerPoint = 30;

void setup()
{
  loadData();
  
  theFont = createFont("segoeui.ttf", 64);
  textFont(theFont);
  
  size(1000,1000);
  strokeWeight(15);
  background(0);
  stroke(255);
  fill(255);
  textAlign(CENTER);
  
  
    videoExport = new VideoExport(this);
    videoExport.setFrameRate(60);
    videoExport.startMovie();
}

void draw()
{
  background(0);
  
  pushStyle();
    textSize(40);
    text("Global Temperature vs. Global Sea Ice Extent", 500, 75);
    textSize(20);
    text("@KevPluck", 500, 875);
    text("NSIDC, NASA GISS", 500, 850);
  popStyle();
  
  pushStyle();
  pushMatrix();
    textSize(30);
    text("Global Temperature Anomaly from 1951-1980 means (°C)", 500, 960);
    translate(45, 500);
    rotate(-HALF_PI);
    text("Global Sea Ice Extent (Million km²)", 0,0);
  popMatrix();
  popStyle();
  
  
  pushStyle();
    textSize(20);
    for(float temp = 0.2; temp <= 1; temp+= 0.2)
    {
      text(nf(temp, 0, 1), temp * 950, 910);
    }
    
    textAlign(LEFT);
    for(float extent = 21; extent <= 24.5; extent+= 0.5)
    {
      text(nf(extent, 0, 0), 70 , 1000.0 - ((extent - 20.4) * 200.0));
    }
  popStyle();
  
  int maxYear = 1980 + frameCount / framesPerPoint;
  
  
  pushStyle();
    textSize(80);
    text(maxYear-1, 500, 175);
  popStyle();
  
  for(int year = 1979; year < maxYear; year++)
  {
    TemperatureExtent thePoint = data.get(year);
    float extent = thePoint.Extent;
    float temperature = thePoint.Temperature;
    
    float x = temperature * 950.0;
    float y = 1000.0 - ((extent - 20.4) * 200.0); 
    
    point(x, y);
  }
  
  
  if(maxYear == 2022)
  {
    for(int i = 0; i < 60*5; i++)
    {
      videoExport.saveFrame();
    }
    
    videoExport.endMovie();
    exit();
    return;
  }
    
  if(maxYear > 1979)
  {
    float interYear = float(frameCount % framesPerPoint) / float(framesPerPoint);
    float easedInterYear = easeInCubic(interYear);
    TemperatureExtent prevYear = data.get(maxYear - 1);
    TemperatureExtent thisYear = data.get(maxYear);
    
    float x = prevYear.Temperature + ((thisYear.Temperature - prevYear.Temperature) * easedInterYear);
    float y = prevYear.Extent + ((thisYear.Extent - prevYear.Extent) * easedInterYear);
    
    x = x * 950.0;
    y = 1000.0 - ((y - 20.4) * 200.0); 
    
    point(x,y);
  }
  
  videoExport.saveFrame();
  
}

void loadData()
{
  String[] lines = loadStrings("data.txt");
  for(String line : lines)
  {
    String[] splitLine = line.split("\t");
    Integer year = int(splitLine[0]);
    float extent = float(splitLine[1]);
    float temperature = float(splitLine[2]);
    data.put(year, new TemperatureExtent(temperature, extent));
  }
}

float easeInCubic(float x) {
  return x * x * x;
}
