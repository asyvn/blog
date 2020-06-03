import geometry;
unitsize(1cm);
defaultpen(fontsize(9pt));

point A=(2,5); dot(Label("$A$",align=NW),A);
point B=(0,0); dot(Label("$B$",align=SW),B);
point C=(8,0); dot(Label("$C$",align=SE),C);
triangle t=triangle(A,B,C); draw(t);

point I=incenter(t); dot(Label("$I$",align=NW),I);
point X=incenter(triangle(I,B,C));
point Y=incenter(triangle(I,C,A));
point Z=incenter(triangle(I,A,B));
point D=projection(t.BC)*X; //dot(Label("$D$",align=SE),D);
point E=projection(t.CA)*Y; //dot(Label("$E$",align=NE),E);
point F=projection(t.AB)*Z; //dot(Label("$F$",align=NW),F);

line la=reflect(line(Y,Z))*line(A,I); //draw(la);
point P=intersectionpoint(la,t.AB);
point Q=intersectionpoint(la,t.CA);
draw(incircle(triangle(P,B,D))^^incircle(triangle(Q,C,D)));

line lb=reflect(line(Z,X))*line(B,I); //draw(lb);
point R=intersectionpoint(lb,t.AB);
draw(incircle(triangle(R,A,E)));

dot(A^^B^^C^^I, Fill(white));
