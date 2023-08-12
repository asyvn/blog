#PT Sinh
size(12cm);
pen p1=gray+opacity(.2), p2=gray+opacity(.6), p3=gray;
real b=4.5, c=3,//b>=c
b1=sqrt(2)/2*b, c1=sqrt(2)/2*c,
a=sqrt(b^2+c^2),
d=b-c,
e=sqrt(2)*b*c/(b+c),
f=sqrt(2)/2*b-e,
g=f*c/b,
h=sqrt(2)/2*d;
pair O=(0,0),
A=sqrt(2)/2*d*dir(135),
A1=sqrt(2)/2*d*dir(-135),
B=A+c*dir(90),
C=A+b*dir(0),
D=A+d*dir(0),
E=A+e*dir(45),
F=A+b1*dir(45),
G=D+c1*dir(45),
H=D+(c1-g)*dir(45),
I=A+(b1-f-g)*dir(45),
J=F+f*dir(-45),
K=A+g*dir(45);
picture pic1, pic2, pic3, pic4, pic5, pic6, pic7;
filldraw(pic1,O--(0,b)--(b,b)--(b,0)--cycle,p1);
draw(pic1,O--(b,b)^^(b,0)--(0,b));
filldraw(pic2,O--(0,c)--(c,c)--(c,0)--cycle,p2);
draw(pic2,O--(c,c)^^(c,0)--(0,c));
fill(pic3,(0,b)--(0,b-c)--(0,b-c)+c1*dir(45)--cycle,p2);
filldraw(pic3,O--(0,b)--b1*dir(135)--cycle,p1);
draw(pic3,(0,b-c)--(0,b-c)+c1*dir(45)--(0,b));
for(int i=0;i<4;++i){
fill(pic4,rotate(90*i)*shift(O-F)*(E--F--G--H--cycle),p3);
fill(pic5,rotate(90*i)*(E--F--G--H--cycle),p3);
fill(pic5,rotate(90*i)*(A--B--I--cycle),p2);
fill(pic5,rotate(90*i)*(A--E--H--G--C--cycle),p1);
fill(pic6,rotate(90*i)*(A--B--I--cycle),p2);
fill(pic6,rotate(90*i)*(A--E--H--G--C--cycle),p1);
fill(pic7,rotate(90*i)*(O--A--A1--cycle),p3);
fill(pic7,rotate(90*i)*(A--B--I--cycle),p2);
fill(pic7,rotate(90*i)*(A--E--C--cycle),p1);
fill(pic7,rotate(90*i)*(B--I--E--cycle),p1);
}
for(int i=0;i<4;++i){
draw(pic4,rotate(90*i)*shift(O-F)*(J--G--H--E--F));
draw(pic5,rotate(90*i)*(A1--B--C^^A--F--C^^B--I^^G--H));
draw(pic6,rotate(90*i)*(A1--B--C^^K--E^^B--I^^C--G--H));
draw(pic7,rotate(90*i)*(A1--B--C^^A--E^^B--I^^D--H));
}
add(pic1);
add(shift(1.3b+1,0)*pic2);
add(shift(2b+1.5c+d,0)*pic3);
add(shift(1.3b+.5c+1,.5d-b-2)*pic4);
add(shift(2b+1.5c+d,.5d-b-2)*pic4);
add(shift(.5d,.5d-b-2)*pic5);
add(shift(2b+1.5c+d,.5d-b-2)*pic6);
add(shift(1.3b+.5c+1,.5d-3b-1)*pic7);
shipout(bbox(3mm,invisible));
