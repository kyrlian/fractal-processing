int imax = 100;
double limit = 4.0;
double eps = 0.0001;
double zoomstep = .9;
double panstep = .1;
int btnsize = 100;
double cx;
double cy;
double xmin;
double ymin;
double xmax;
double ymax;
double w;
double h;
boolean drag = false;
boolean redraw = true;
void setup() {
    fullScreen();//size(1024, 1024);
    colorMode(HSB);
    reset();
}
void updatecoords() {
    w = h * width / height;
    xmin = cx - w / 2;
    xmax = cx + w / 2;
    ymin = cy - h / 2;
    ymax = cy + h / 2;
    redraw = true;
}
void reset() {
    cx =-  0.6;
    cy = 0;
    h = 2 * 1.3;
    updatecoords();
}
void draw() {
    if (drag) {
        rawcopy();
    } else if (redraw) {
        background(0, 0, 0);
        frac();
        //  drawcontrols();
    }
    redraw = false;
}
void frac() {
    loadPixels();
    double step = w / width;
    double cr = xmin;
    for (int i = 0; i < width; i++) {
        double ci = ymin;
        for (int j = 0; j < height; j++) {
            int iter = 0;
            double zr = cr;
            double zi = ci;
            double dr = 1;
            double di = 0;
            while(iter<imax && (zr * zr + zi * zi)<limit && (dr * dr + di * di)>eps) {
                // d=2z
                dr = 2 * zr;
                di = 2 * zi;
                //z=z2+c
                double nzr = zr * zr - zi * zi + cr;
                zi = 2 * zr * zi + ci;
                zr = nzr;
                iter++;
            }
            color co = color(0, 0, 0);
            if (iter < imax && (dr * dr + di * di)>eps) {
                //int h = int( 255*log(iter)/log(imax));
                int h = int(255 * iter / imax);
                //int h = int(255/(zr*zr+zi*zi));
                co = color(h, 255, 255);
            }
            pixels[j * width + i] = co;
            ci += step;
        }
        cr += step;
    }
    updatePixels();
}
void drawcontrols() {
    // stroke(255, 0, 0);
    // noFill();
    // rect(0, 0,btnsize,btnsize);
    // rect(width - btnsize, 0, width, btnsize);
    // rect(0, height - btnsize,  btnsize, height);
    fill(0, 0, 0);
    textSize(btnsize);
    text("R", 10, btnsize - 10);
    text("-", width - 90, 90);
    // text("Q", 10, height - 10);
}
void rawcopy() {
    int mdx = mouseX - pmouseX;
    int mdy = mouseY - pmouseY;
    //drag image
    int cpw = width - abs(mdx);
    int cph = height - abs(mdy);
    int fx = 0;
    int fy = 0;
    if (mdx < 0) {
        fx =-  1 * mdx;
        }
    if (mdy < 0) {
        fy =-  1 * mdy;
        }
    //copy(tx, ty, cpw, cph, fx, fy,cpw, cph);
    loadPixels();
    color[] tpixels = new color[width * height];
    for (int i = fx; i < cpw; i++) {
        for (int j = fy; j < cph; j++) {
            int di = i + mdx;
            int dj = j + mdy;
            tpixels[dj * width + di] = pixels[j * width + i];
            }
        }
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            pixels[j * width + i] = tpixels[j * width + i];
            }
        }
    updatePixels();
    }

void mouseReleased() {
    if (drag == false) {
        if (mouseX < btnsize && mouseY < btnsize) {
            reset();
            } else if (mouseX > width - btnsize && mouseY < btnsize) {
            unzoom();
            } else {
            zoom();
            }
        }
    drag = false;
    }
void unzoom() {
    h = h / zoomstep;
    updatecoords();
    }
void zoom() {
    cx = xmin + mouseX * w / width;
    cy = ymin + mouseY * h / height;
    h = h * zoomstep;
    updatecoords();
    }
void drag() {
    drag = true;
    cx += (mouseX - pmouseX) * w / width;
    cy += (mouseY - pmouseY) * h / height;
    updatecoords();
    }
void mouseDragged() {
    drag();
    }
void keyPressed() {
    if (key == 'r') {
        reset();
        } else if (key == 'z' || keyCode ==  UP) {
        cy -= panstep * h;
        } else if (key == 's' || keyCode ==  DOWN) {
        cy += panstep * h;
        } else if (key == 'q'  || keyCode ==  LEFT) {
        cx -= panstep * w;
        } else if (key == 'd'  || keyCode ==  RIGHT) {
        cx += panstep * w;
        } else if (key == CODED) {
        if (keyCode == SHIFT) {
            h = h * zoomstep;
            } else if (keyCode == CONTROL) {
            h = h / zoomstep;
            }
        }
    updatecoords();
    }
