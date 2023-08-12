#QuanT
unitsize(1cm);
void draw_pic_ab(pair O=(0,0), real a, pen pcolor) {
  path square=O--(O.x+a, O.y)--(O.x+a, O.y+a)--(O.x, O.y+a)--cycle;
  filldraw(square, pcolor);
  draw(square^^O--(O.x+a, O.y+a)^^(O.x+a, O.y)--(O.x, O.y+a));
}

void draw_pic_c(pair O=(0,0), real a, real b) {
  path half_sq_a=O--(O.x, O.y+a)--(O.x-a/2, O.y+a/2)--cycle;
  path half_sq_b=(O.x, O.y+a)--(O.x, O.y+a-b)--(O.x+b/2, O.y+a-b/2)--cycle;
  
  filldraw(half_sq_a, gray(0.8));
  filldraw(half_sq_b, gray(0.6));
}

void draw_pic_d(pair O=(0,0), real a, real b) {
  real d=a-b;
  pair A=(O.x-b, O.y), B=(O.x, O.y+a), C=(O.x+d/2, O.y+d/2);
  pair M=(O.x-a/2, O.y+a/2);
  pair N=(O.x-b/2, O.y+a-b/2);
  pair P=extension(A, B, (O.x, O.y+a-b), N);
  pair Q=extension(A, B, O, M);
  
  path p0=A--O--B--cycle;
  path p1=O--B--M--cycle;
  path p2=O--A--(O.x-b/2, O.y+b/2)--cycle;
  path p3=M--N--P--Q--cycle;
  
  for (int i=0; i<4; ++i) {
    filldraw(rotate(i*90,C)*p1, gray(0.8));
    filldraw(rotate(i*90,C)*p2, gray(0.6));
    filldraw(rotate(i*90,C)*p3, gray(0.4));
    draw(rotate(i*90,C)*p0);
  }
}

void draw_pic_e(pair O=(0,0), real a, real b) {
  real d=a-b;
  pair A=(O.x-b, O.y), B=(O.x, O.y+a), C=(O.x+d/2, O.y+d/2);
  pair M=(O.x-a/2, O.y+a/2);
  pair N=(O.x-b/2, O.y+a-b/2);
  pair P=extension(A, B, (O.x, O.y+a-b), N);
  pair Q=extension(A, B, O, M);
  
  path p3=M--N--P--Q--cycle;
  path p4=shift(C-M)*p3;
  
  for (int i=0; i<4; ++i) filldraw(rotate(i*90,C)*p4, gray(0.4));
}

void draw_pic_f(pair O=(0,0), real a, real b) {
  real d=a-b;
  pair A=(O.x-b, O.y), B=(O.x, O.y+a), C=(O.x+d/2, O.y+d/2);
  path p0=A--O--B--cycle;
  
  path p2=O--A--(O.x-b/2, O.y+b/2)--cycle;
  
  pair M=(O.x-a/2, O.y+a/2);
  pair N=(O.x-b/2, O.y+a-b/2);
  pair P=extension(A, B, (O.x, O.y+a-b), N);
  pair Q=extension(A, B, O, M);
  
  path p1=O--B--N--P--Q--cycle;
  path p3=M--N--P--Q--cycle;
  path p4=shift(C-M)*p3;
  
  for (int i=0; i<4; ++i) {
    filldraw(rotate(i*90,C)*p2, gray(0.6));
    filldraw(rotate(i*90,C)*p1, gray(0.8));
  }
  
  for (int i=0; i<4; ++i) filldraw(rotate(i*90,C)*p4, gray(0.4));
  for (int i=0; i<4; ++i) draw(rotate(i*90,C)*p0);
}

void draw_pic_g(pair O=(0,0), real a, real b) {
  real d=a-b;
  pair A=(O.x-b, O.y), B=(O.x, O.y+a), C=(O.x+d/2, O.y+d/2);
  pair M=(O.x-a/2, O.y+a/2);
  pair N=(O.x-b/2, O.y+a-b/2);
  pair P=extension(A, B, (O.x, O.y+a-b), N);
  pair Q=extension(A, B, O, M);
  
  path p0=A--O--B--cycle;
  path p1=O--B--A--(O.x-b/2, O.y+b/2)--cycle;
  path p2=O--A--(O.x-b/2, O.y+b/2)--cycle;
  path [] p5 =Q--(O.x-b/2, O.y+b/2)^^P--(O.x, O.y+d);
  
  for (int i=0; i<4; ++i) {
    filldraw(rotate(i*90,C)*p2, gray(0.6));
    filldraw(rotate(i*90,C)*p1, gray(0.8));
  }
  
  filldraw(O--(O.x+d,O.y)--(O.x+d,O.y+d)--(O.x,O.y+d)--cycle, gray(0.4));
  for (int i=0; i<4; ++i) {
    draw(rotate(i*90,C)*p0);
    draw(rotate(i*90,C)*p5);
  }
}

/////////////////////////////

real a=3, b=2, c=sqrt(a^2-b^2);

draw_pic_ab((0,0), a=a, pcolor=gray(0.8));
draw_pic_ab((a+1,0), a=b, pcolor=gray(0.6));
draw_pic_c((3a,0), a=a, b=b);

draw_pic_d((0,-1.6a), a=a, b=b);
draw_pic_e((1.5a,-1.6a), a=a, b=b);
draw_pic_f((3a,-1.6a), a=a, b=b);
draw_pic_g((1.5a,-3.2a), a=a, b=b);

shipout(bbox(2mm, invisible));
