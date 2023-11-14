int imax=255;
double limit=4.0;
double eps=0.0001;
int btnsize=100;
double xmin;
double ymin;
double xmax;
double ymax;
double w;
double h;
boolean drag=false;
void setup() {
  colorMode(HSB);
  reset();
}
void frac() {
  loadPixels();
  double step=w/width;
  double cr=xmin;
  for (int i = 0; i < width; i++) {
    double ci=ymin;
    for (int j = 0; j < height; j++) {
      int iter=0;
      double zr=cr;
      double zi=ci;
      double dr=1;
      double di=0;
      while ( iter<imax && (zr*zr+zi*zi)<limit && (dr*dr+di*di)>eps) {
        // d=2z
        dr = 2*zr;
        di = 2*zi;
        //z=z2+c
        double nzr=zr*zr-zi*zi+cr;
        zi=2*zr*zi+ci;
        zr=nzr;
        iter++;
      }
      color co=color(0, 0, 0);
      if (iter<imax && (dr*dr+di*di)>eps) {
        //int h = int( 255*log(iter)/log(imax));
        int h = int( 255*iter/imax);
        //int h = int(255/(zr*zr+zi*zi));
        co=color(h, 255, 255);
      }
      //set(i, j, c);
      pixels[j*width+i]=co;
      ci+=step;
    }
    cr+=step;
  }
  updatePixels();
}
void controls() {
  //stroke(255, 0, 0);
  //noFill();
  //rect(0, 0,btnsize, btnsize);
  //rect(width-btnsize, 0, width, btnsize);
  //rect(0, height-btnsize,  btnsize, height);
  fill(0, 0, 0);
  textSize(btnsize);
  text("R", 10, btnsize-10);
  text("-", width-90, 90);
  //text("Q", 10, height-10);
}
void rawcopy() {
  int mdx=mouseX-pmouseX;
  int mdy=mouseY-pmouseY;
  //drag image
  int cpw=width-abs(mdx);
  int cph=height-abs(mdy);
  int fx=0;
  int fy=0;
  if (mdx<0) {
    fx=-1*mdx;
  }
  if (mdy<0) {
    fy=-1*mdy;
  }
  //copy(tx, ty, cpw, cph, fx, fy, cpw, cph);
  loadPixels();
  color[] tpixels = new color[width*height];
  for (int i = fx; i < cpw; i++) {
    for (int j = fy; j < cph; j++) {
      int di=i+mdx;
      int dj=j+mdy;
      tpixels[dj*width+di]=pixels[j*width+i];
    }
  }
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      pixels[j*width+i]=tpixels[j*width+i];
    }
  }
  updatePixels();
}
void reset() {
  ymax=1.3;
  xmin=-2.0;
  h=2*ymax;
  w=h*width/height;
  ymin=ymax-h;
  xmax=xmin+w;
}
void draw() {
  if (drag) {
    rawcopy();
  } else {
    background(0, 0, 0);
    frac();
    controls();
  }
}
void mouseReleased() {//mousePressed() {
  if (drag == false) {
    if (mouseX<btnsize && mouseY<btnsize) {
      reset();
    } else if (mouseX>width- btnsize && mouseY<btnsize) {
      unzoom();
      //} else if (mouseX< btnsize && mouseY>height-btnsize) {
      // exit();
    } else {
      zoom();
    }
  }
  drag=false;
}
void unzoom() {
  xmin=xmin-w/2;
  ymin=ymin-h/2;
  w=w*2;
  h=h*2;
  xmax=xmin+w;
  ymax=ymin+h;
}
void zoom() {
  xmin=xmin+mouseX*w/width-w/4;
  ymin=ymin+mouseY*h/height-h/4;
  w=w/2;
  h=h/2;
  xmax=xmin+w;
  ymax=ymin+h;
}
void mouseDragged() {
  drag=true;
  int mdx=mouseX-pmouseX;
  int mdy=mouseY-pmouseY;
  //update coords for next draw
  double sdx=mdx*w/width;
  double sdy=mdy*h/height;
  xmin=xmin-sdx;
  ymin=ymin-sdy;
  xmax=xmin+w;
  ymax=ymin+h;
}