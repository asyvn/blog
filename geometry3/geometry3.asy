/*Trần Quân 2021*/
import three;
import solids;
real epsgeo = 10 * sqrt(realEpsilon);
//Lấy điểm K trên AB sao cho AK=kAB
triple rpoint(real k, triple A, triple B) { 
	return (1-k)*A + k*B; //k*(B-A)+A;
}

//PA/PB = x/y
triple bary(triple A, triple B, real x, real y) {
    return (y*A + x*B)/(x+y);
}

triple bary(real x, real y, triple A, triple B) {
    return bary(A, B, x, y);
}

triple bary(real k, triple A, triple B) {
	return bary(k, 1, A, B);
}

triple bary(triple A, triple B, triple C, real x, real y, real z) {
    return (x*A + y*B + z*C) / (x+y+z);
}
triple bary(real x, real y, real z, triple A, triple B, triple C) {
    return (x*A + y*B + z*C) / (x+y+z);
}

triple bary(triple A, triple B, triple C, triple D, real x, real y, real z, real t) {
    return (x*A + y*B + z*C + t*D) / (x+y+z+t);
}
triple bary(real x, real y, real z, real t, triple A, triple B, triple C, triple D) {
    return (x*A + y*B + z*C + t*D) / (x+y+z+t);
}

//Trung điểm của AB
triple midpoint(triple A, triple B){
	return (A+B)/2;
}

//Trọng tâm tam giác ABC
triple centroid(triple A, triple B, triple C){
	return (A+B+C)/3;
}

//Tâm đường tròn nội tiếp tam giác ABC
triple incenter(triple A, triple B, triple C){
	real a = abs(B-C), b = abs(C-A), c = abs(A-B), p=a+b+c;
	return bary(A, B, C, a, b, c);
}

//Diện tích tam giác ABC
real area(triple A, triple B, triple C) {
    real a = abs(B-C), b = abs(C-A), c = abs(A-B), p = (a+b+c)/2;
    return sqrt(p*(p-a)*(p-b)*(p-c));
}

//Bán kính đường tròn nội tiếp tam giác ABC
real inradius(triple A, triple B, triple C){
	real a = abs(B-C), b = abs(C-A), c = abs(A-B), p = (a+b+c)/2;
	return area(A, B, C)/p;
}

//Đường tròn nội tiếp, lưu ý trả về path3
path3 incircle(triple A, triple B, triple C){
	return circle(incenter(A,B,C),inradius(A, B, C),normal(A--B--C));
}

//Trực tâm tam giác ABC
triple orthocenter(triple A, triple B, triple C){
    real a = abs(B-C), b = abs(C-A), c = abs(A-B), p = (a+b+c)/2;
    real f(real a, real b, real c) {
        return 1/(b^2+c^2-a^2);
    }
    real x = f(a, b, c), y = f(b, c, a), z = f(c, a, b);
    return bary(A, B, C, x, y, z);
}

//Tâm đường tròn ngoại tiếp tam giác ABC
triple circumcenter(triple A, triple B, triple C){
    real a = abs(B-C), b = abs(C-A), c = abs(A-B), p = (a+b+c)/2;
    real f(real a, real b, real c) {
        return a^2 *(b^2+c^2-a^2);
    }
    real x = f(a, b, c), y = f(b, c, a), z = f(c, a, b);
    return bary(A, B, C, x, y, z);
}

//Đường tròn ngoại tiếp tam giác ABC
path3 circumcircle(triple A, triple B, triple C) {
    triple c = circumcenter(A, B, C);
    return circle(c, abs(c-A), normal(A--B--C));
}

/*struct line3*/
struct line3 {
    triple A, B;
    triple slope; //vector chỉ phương

    path3 path(real k) {
        triple M = (A+B)/2;
        triple pA = rpoint(k, M, A), pB = rpoint(k, M, B);
        return pA--pB;
    }
    void operator init(triple A, triple B) {
        this.A=A;
        this.B=B;
        this.slope = B-A;

    }

}

/*struct line3*/

void draw(line3 l, pen pcolor=black, real k=1.5) {
    draw(l.path(k), pcolor);
}

/*struct circle3*/
struct circle3 {
    triple c;
    real r;
    triple normal;

    void operator init(triple C, real r, triple normal) {
        this.c = C;
        this.r = r;
        this.normal = normal;
        //this.path = circle(c, r, normal);
    }
    //Đường tròn tâm c, đi qua A, vuông góc với normal
    void operator init(triple C, triple A, triple normal) {
        this.c = C;
        this.r = abs(C-A);
        this.normal = normal;
        //this.path = circle(c, r, normal);
    }
    path3 path() {
        return circle(c, r, normal);
    }
}
/*struct circle3*/

void draw(circle3 c, pen pcolor=black) {
    draw(c.path(), pcolor);
}

/*struct triangle3*/
struct triangle3 {
    triple A, B, C;
    triple normal;
    //path3 BC, CA, AB;

    real a() {return abs(B-C);}
    real b() {return abs(C-A);}
    real c() {return abs(A-B);}

    real area() {
        real p = (a()+b()+c())/2;
        return sqrt(p*(p-a())*(p-b())*(p-c()));
    }

    real alpha() {return degrees(acos((b()^2 + c()^2 - a()^2)/(2b() * c())));}
    real beta()  {return degrees(acos((c()^2 + a()^2 - b()^2)/(2c() * a())));}
    real gamma() {return degrees(acos((a()^2 + b()^2 - c()^2)/(2a() * b())));}
    path3 path() {return A--B--C--cycle;}

    void operator init(triple A, triple B, triple C) {
        this.A = A;
        this.B = B;
        this.C = C;
        this.normal = normal(A--B--C--cycle);
    }
}
/*struct triangle3*/

void draw(triangle3 t, pen pcolor=black) {
    draw(t.path(), pcolor);
}

triple incenter(triangle3 t) {
    return bary(t.A, t.B, t.C, t.a(), t.b(), t.c());
}

real inradius(triangle3 t){
	real p = (t.a()+t.b()+t.c())/2;
	return t.area()/p;
}

circle3 incircle(triangle3 t) {
    return circle3(incenter(t),inradius(t), t.normal);
}

//Tâm đường tròn ngoại tiếp tam giác ABC
triple circumcenter(triangle3 t){
    real f(real a, real b, real c) {
        return a^2 *(b^2+c^2-a^2);
    }
    real x = f(t.a(), t.b(), t.c()), y = f(t.b(), t.c(), t.a()), z = f(t.c(), t.a(), t.b());
    return bary(t.A, t.B, t.C, x, y, z);
}

//Đường tròn ngoại tiếp
circle3 circumcircle(triangle3 t){
	triple O=circumcenter(t);
	return circle3(O, t.A, t.normal);
}
triple centroid(triangle3 t) {
    return (t.A+t.B+t.C)/3;
}

triple orthocenter(triangle3 t){
    real f(real a, real b, real c) {
        return 1/(b^2+c^2-a^2);
    }
    real x = f(t.a(), t.b(), t.c()), y = f(t.b(), t.c(), t.a()), z = f(t.c(), t.a(), t.b());
    return bary(t.A, t.B, t.C, x, y, z);
}

//Hình chiếu của P lên mặt phẳng ABC.
triple project(triple P, triple A, triple B, triple C) {
    transform3 tp = planeproject(unit(cross(B-A,C-A)), A);
	return tp*P;
}

//Hình chiếu của A lên đường thẳng BC.
triple projectX(triple A, triple B, triple C) {
    //triangle3 t = triangle3(A, B, C);
    real a = abs(B-C), b = abs(C-A), c = abs(A-B);
    real beta = (c^2+a^2-b^2)/(2*c*a), gamma = (a^2+b^2-c^2)/(2*a*b);
	return bary(c*beta, b*gamma, B, C);
}

//Đối xứng của P qua AB
triple reflect(triple P, triple A, triple B) {
	return rotate(180, A, B)*P;
}

//Hình chiếu vuông góc của P lên AB
triple project(triple P, triple A, triple B) {
    return (P + rotate(180, A, B)*P)/2;
}

triple project(triple P, line3 l) {
    return project(P, l.A, l.B);
}

/*struct sphere
Phương trình mặt cầu: x^2 + y^2 + z^2 + Dx + Ey + Fz + G = 0;
*/
struct sphere3 {
    triple c; //center
    real r; // radius
    real D, E, F, G;

    void operator init(triple c, real r) {
        this.c = c;
        this.r = r;
        this.D = -2c.x;
        this.E = -2c.y;
        this.F = -2c.z;
        this.G = c.x^2 + c.y^2 + c.z^2 - r^2;
    }
    void operator init(triple p1, triple p2, triple p3, triple p4) {
        real x1=p1.x, y1=p1.y, z1=p1.z;
        real x2=p2.x, y2=p2.y, z2=p2.z;
        real x3=p3.x, y3=p3.y, z3=p3.z;
        real x4=p4.x, y4=p4.y, z4=p4.z;
        real    t1 = -(x1^2 + y1^2 + z1^2),
                t2 = -(x2^2 + y2^2 + z2^2),
                t3 = -(x3^2 + y3^2 + z3^2),
                t4 = -(x4^2 + y4^2 + z4^2);
        real [][]arrT = {
                        {x1, y1, z1, 1},
                        {x2, y2, z2, 1},
                        {x3, y3, z3, 1},
                        {x4, y4, z4, 1}};
        real [][]arrD = {
                        {t1, y1, z1, 1},
                        {t2, y2, z2, 1},
                        {t3, y3, z3, 1},
                        {t4, y4, z4, 1}};
        real [][]arrE = {
                        {x1, t1, z1, 1},
                        {x2, t2, z2, 1},
                        {x3, t3, z3, 1},
                        {x4, t4, z4, 1}};
        real [][]arrF = {
                        {x1, y1, t1, 1},
                        {x2, y2, t2, 1},
                        {x3, y3, t3, 1},
                        {x4, y4, t4, 1}};
        real [][]arrG = {
                        {x1, y1, z1, t1},
                        {x2, y2, z2, t2},
                        {x3, y3, z3, t3},
                        {x4, y4, z4, t4}};
      	real dT = determinant(arrT);
      	if (dT != 0) {  
        	this.D = determinant(arrD)/dT;
        	this.E = determinant(arrE)/dT;
        	this.F = determinant(arrF)/dT;
        	this.G = determinant(arrG)/dT;
        	this.c = (-D/2, -E/2, -F/2);
        	this.r = 0.5*sqrt(D^2 + E^2 + F^2 - 4G);
        }
    }

}
/*struct sphere3*/

//Giao đường thẳng và mặt cầu
triple [] intersectionpoints(triple p, triple q, triple c, real r) {
    triple []result;
    real x1=p.x, y1=p.y, z1=p.z;
    real x2=q.x, y2=q.y, z2=q.z;
    real xc=c.x, yc=c.y, zc=c.z;
    real A = (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2;
    real B = -2((x2-x1)*(xc-x1) + (y2-y1)*(yc-y1) + (zc-z1)*(z2-z1));
    real C = (xc-x1)^2 + (yc-y1)^2 + (zc-z1)^2-r^2;
    real delta = B^2-4*A*C;

    if (abs(delta)<epsgeo) {
        result.push(p + (-B/(2*A))*(q-p));
    } else if (delta>0) {
        real t1 = (-B + sqrt(delta))/(2*A), t2 = (-B - sqrt(delta))/(2*A);
        result.push(p + t1*(q-p));
        result.push(p + t2*(q-p));
    }

    return result;
}


/*struct tetrahedron
Tứ diện SABC:
- a = SA, b = SB, c=SC, d = BC, e = CA, f=AB
- Các cặp cạnh đối diện: (a, d), (b, e), (c, f)
- Các faces:    W = (d, e, f) = (A, B, C)
                X = (d, b, c) = (S, B, C)
                Y = (a, e, c) = (S, C, A)
                Z = (a, b, f) = (S, A, B) 
*/

struct tetrahedron {
    triple S, A, B, C;
    triple A, B, C;
    path3 W, X, Y, Z;
    //real a, b, c, d, e, f;

    real a() {return abs(S-A);}
    real b() {return abs(S-B);}
    real c() {return abs(S-C);}
    real d() {return abs(B-C);}
    real e() {return abs(C-A);}
    real f() {return abs(A-B);}

    real areaW() {return area(A, B, C);}
    real areaX() {return area(S, B, C);}
    real areaY() {return area(S, C, A);}
    real areaZ() {return area(S, A, B);}

    real volume() {
        triple H = project(S, A, B, C);
        return (abs(S-H)*area(A, B, C)/3);
    }

    void operator init(triple S, triple A, triple B, triple C) {
		this.S = S;
        this.A = A;
        this.B = B;
        this.C = C;
        this.W = A--B--C--cycle;
        this.X = S--B--C--cycle;
        this.Y = S--C--A--cycle;
        this.Z = S--A--B--cycle;
	}

    void draw(pen pcolor=Cyan) {
        draw(S--A^^S--B^^S--C^^A--B--C--cycle, pcolor);
    }
}

//Tâm hình cầu nội tiếp tứ diện
triple incenter(tetrahedron t) {
    return bary(t.S, t.A, t.B, t.C, t.areaW(), t.areaX(), t.areaY(), t.areaZ());
}

//Bán kính hình cầu nội tiếp tứ diện
real inradius(tetrahedron t) {
    real m = area(t.A, t.B, t.C);
    real n = area(t.S, t.B, t.C);
    real p = area(t.S, t.C, t.A);
    real q = area(t.S, t.A, t.B);
    return 3*t.volume()/(t.areaW()+t.areaX()+t.areaY()+t.areaZ());
}

//Hình cầu nội tiếp tứ diện
sphere3 insphere(tetrahedron t) {
    return sphere3(incenter(t), inradius(t));
}

//Trọng tâm tứ diện
triple centroid(tetrahedron t) {
    return bary(t.S, t.A, t.B, t.C, 1, 1, 1, 1);
}

//Điểm symmedian của tứ diện
triple symmedian(tetrahedron t) {
    return bary(t.S, t.A, t.B, t.C, t.areaW()^2, t.areaX()^2, t.areaY()^2, t.areaZ()^2);
}

//Điểm spieker của tứ diện
triple spieker(tetrahedron t) {
    real rho = t.areaX() + t.areaY() + t.areaZ();
    real alpha = t.areaW() + t.areaY() + t.areaZ();
    real beta = t.areaW() + t.areaX() + t.areaZ();
    real gamma = t.areaW() + t.areaY() + t.areaZ();

    return bary(t.S, t.A, t.B, t.C, rho, alpha, beta, gamma);
}

/*struct tetrahedron*/

//Kiểm tra P nằm trên mặt phẳng ax + by + cz + d =0
bool sameplane(triple P, real a, real b, real c, real d) {
    return (abs(a*P.x + b*P.y + c*P.z +d) <epsgeo);
}

//Khoảng cách từ P đến mặt phẳng ax + by + cz + d =0
real distance(triple P, real a, real b, real c, real d) {
    return abs(a*P.x + b*P.y + c*P.z + d)/sqrt(a^2+b^2+c^2);
}

//Khoảng cách từ P đến AB
real distance(triple P, triple A, triple B) {
    triple Q = project(P, A, B);
    return abs(P-Q);
}

bool sameline(triple P, triple A, triple B) {
    return (distance(P, A, B)<epsgeo);
}

//Hình chiếu vuông góc của P lên mặt phẳng ax + by + cz + d =0
triple project(triple P, real a, real b, real c, real d) {
  	triple result;
  	triple normal = (a, b, c);
    triple Q = P+normal-O;
	real k = distance(P, a, b, c, d)/abs(P-Q);
  	triple tmp=rpoint(k, P, Q);
  	if (sameplane(tmp, a, b, c, d)) result=rpoint(k, P, Q);
  	else result=rpoint(-k, P, Q);
	
    return result;
}

/*struct plane
Phương trình mặt phẳng: ax + by + cz + d = 0
*/
struct plane3 {
	real a, b, c, d;
	triple A, B, C;
    triple normal;
    //path3 path;
    
    void operator init(triple A, triple B, triple C) {
        this.A = A; this.B = B; this.C = C;
        this.normal = normal(A--B--C--cycle);
        //this.path = A--B--B+C-A--C--cycle;
        real x1 = A.x, y1 = A.y, z1 = A.z;
		real x2 = B.x, y2 = B.y, z2 = B.z;
		real x3 = C.x, y3 = C.y, z3 = C.z;
		real a1 = x2-x1, b1 = y2-y1, c1 = z2-z1;
		real a2 = x3-x1, b2 = y3-y1, c2 = z3-z1;
	    this.a = b1 * c2 - b2 * c1;
		this.b = a2 * c1 - a1 * c2;
		this.c = a1 * b2 - b1 * a2;
		this.d = (- a * x1 - b * y1 - c * z1);

    }
    void operator init(real a, real b, real c, real d) {
        this.a = a; this.b = b; this.c = c; this.d = d;
        this.normal = (a, b, c);
        triple pO = project(O, a, b, c, d);
        triple pX = project(X, a, b, c, d);
        triple pY = project(Y, a, b, c, d);
        triple pZ = project(Z, a, b, c, d);

        if (sameline(pY, pO, pX)) {
            this.A=pO; this.B=pX; this.C=pZ;
        } else {
            this.A=pO; this.B=pX; this.C=pY;
        }
        
        //this.path = A--B--B+C-A--C--cycle;
        //this.normal = normal(A--B--C--cycle);
        

    }

    path3 path() {
        return A--B--B+C-A--C--cycle;
    }
    
    surface surface(real k=1.5) {
        triple M = (B+C)/2;
      	triple D = B+C-A;
      	triple pA = rpoint(k, M, A), pB = rpoint(k, M, B),pC = rpoint(k, M, C),pD = rpoint(k, M, D);
      	return surface(pA--pB--pD--pC--cycle);
    }

    void draw(pen pcolor = palegray+opacity(0.4), real k=1){
    	triple M = (B+C)/2;
      	triple D = B+C-A;
      	triple pA = rpoint(k, M, A), pB = rpoint(k, M, B),pC = rpoint(k, M, C),pD = rpoint(k, M, D);
      	draw(surface(pA--pB--pD--pC--cycle), pcolor);
    }
}
 /*struct plane*/

void draw(plane3 pl, pen pcolor=black) {
    draw(pl.path(), pcolor);
}

void drawsurface(plane3 pl, pen pcolor=palegray+opacity(0.4), real k=1.5) {
    draw(pl.surface(k), pcolor);
}

bool operator @(triple P, plane3 pl) {
    return (sameplane(P, pl.a, pl.b, pl.c, pl.d));
}

triple project(triple P, plane3 pl) {
	return project(P, pl.A, pl.B, pl.C);
}

//Mặt phẳng qua P vuông góc với AB
plane3 perpendicular(triple P, triple A, triple B) {
 	triple n = B-A;
  	real a = n.x, b = n.y, c = n.z, d = -(a*P.x+b*P.y+c*P.z);
  	//triple pO = project(O, a, b, c, d); dot(pO, red);
	triple pX = project(X, a, b, c, d); //dot(pX, red);
	triple pY = project(Y, a, b, c, d); //dot(pY, red);
	triple pZ = project(Z, a, b, c, d); //dot(pZ, red);

	triple pA, pB, pC;

	if (sameline(pY, P, pX)==false) {
    	pA=P; pB=pX; pC=pY;
	} else if (sameline(pZ, P, pX)==false) {
		pA=P; pB=pX; pC=pZ;
	}
  	return plane3(pA, pB, pC);
}

/*
//Mặt phẳng qua P vuông góc với AB (P không nằm trên AB)
path3 perpendicularX(triple P, triple A, triple B) {
	return P--rotate(90, A, B)*P--rotate(180, A, B)*P--cycle;
}

plane3 perpendicularY(triple P, triple A, triple B) {
	return plane3(P, rotate(90, A, B)*P, rotate(180, A, B)*P);
}
*/

bool operator @(triple P, circle3 co) {
    bool result = false;
    plane3 pl = perpendicular(co.c, O, co.normal);
    if (P @ pl && abs(abs(co.c-P) - co.r) < epsgeo) result = true;
    return result;
}

//Giao của PQ và plane
triple intersectionpoint(triple P, triple Q, plane3 pl) {
    triple nPQ = Q-P;
    real t = -(pl.a*P.x + pl.b*P.y + pl.c*P.z +pl.d)/(pl.a*nPQ.x + pl.b*nPQ.y + pl.c*nPQ.z);
    return P+t*(Q-P);
}

triple intersectionpoint(line3 l, plane3 pl) {
    return intersectionpoint(l.A, l.B, pl);
}

//Giao của PQ và plane đi qua A, B, C
triple intersectionpoint(triple M, triple N, triple A, triple B, triple C){
	triple n=cross(B-A, C-A), d = N-M; //n = normal(A--B--C);
	return (dot(n, A-M)/dot(n, d))*d+M;
}

//Kiểm tra P, A, B, C đồng phẳng
bool sameplane(triple P, triple A, triple B, triple C) {
	triple n = cross(B-A, C-A);
	triple Q = planeproject(n, A)*P;
	return (abs(P-Q)<epsgeo);
}

//Trả về mặt phẳng chứa đường tròn c
plane3 circletoplane(circle3 co) {
    return perpendicular(co.c, O, co.normal);
}

bool operator @(triple P, sphere3 so) {
    return (abs(abs(so.c-P) - so.r) < epsgeo);
}

//Giao plane pa và pb
line3 intersect(plane3 pl1, plane3 pl2) {
    line3 result;
    real a1=pl1.a, b1=pl1.b, c1=pl1.c, d1=pl1.d;
    real a2=pl2.a, b2=pl2.b, c2=pl2.c, d2=pl2.d;
    real x0, y0, z0, a, b, c;
    
    if (a1*b2 - a2*b1 != 0) {
        x0 = (b1*d2 - b2*d1)/(a1*b2 - a2*b1);
        y0 = (a2*d1 - a1*d2)/(a1*b2 - a2*b1);
        z0 = 0;
        a = (b1*c2 - b2*c1)/(a1*b2 - a2*b1);
        b = (a2*c1 - a1*c2)/(a1*b2 - a2*b1);
        c = 1;
        //triple A = (x0, y0, z0), normal = (a, b, c);
        result = line3((x0, y0, z0), (x0+a, y0+b, z0+c));
        //result = line3(A, A+normal);
    }
    return result;
}

//Khoảng cách từ P đến mặt phẳng pl
real distance(triple P, plane3 pl) {
    return abs(pl.a*P.x + pl.b*P.y + pl.c*P.z + pl.d)/sqrt(pl.a^2+pl.b^2+pl.c^2);
}

//Khoảng cách giữa AB và PQ

real distance(triple A, triple B, triple P, triple Q) {
    triple n1 = B-A, n2 = Q-P;
    real a1 = n1.x, b1 = n1.y, c1 = n1.z;
    real x1 = A.x, y1 = A.y, z1 = A.z;
    real a2 = n2.x, b2 = n2.y, c2 = n2.z;
    real x2 = P.x, y2 = P.y, z2 = P.z;

    real m = (b1*c2-b2*c1)*(x2-x1) - (a1*c2-a2*c1)*(y2-y1) + (a1*b2-a2*b1)*(z2-z1);
    real n = sqrt((b1*c2-b2*c1)^2 + (a1*c2-a2*c1)^2 + (a1*b2-a2*b1)^2);
    return abs(m/n);
}

//Giao của mặt phẳng và mặt cầu
/*http://www.ambrsoft.com/TrigoCalc/Sphere/SpherePlaneIntersection_.htm
*/
circle3 intersect(sphere3 s, plane3 pl) {
    triple centerH = project(s.c, pl);
    real rH = sqrt(s.r^2 - abs(s.c-centerH)*abs(s.c-centerH));
    return circle3(centerH, rH, pl.normal);
}

circle3 intersect(plane3 pl, sphere3 s) {
    return intersect(s, pl);
}

//Giao hai đường thẳng
triple intersectionpoint(triple A, triple B, triple P, triple Q) {
    real m;
    if (sameplane(A, B, P, Q)) {

        triple n1 = B-A, n2 = Q-P;
        real a1 = n1.x, b1 = n1.y, c1 = n1.z;
        real x1 = A.x, y1 = A.y, z1 = A.z;

        real a2 = n2.x, b2 = n2.y, c2 = n2.z;
        real x2 = P.x, y2 = P.y, z2 = P.z;

        real D = - a1*b2 + a2*b1;
        real Dm = -b2*(x2-x1) + a2*(y2-y1);
        //real Dn = a1*(y2-y1) - b1*(x2-x1);
        if (abs(D)>=epsgeo) m = Dm/D;
        //n = Dn/D;
    }
    return A + m*(B-A);
}

//Giao hai đường thẳng
triple extension(triple A, triple B, triple C, triple D, real k=1000){
    triple M = (A+B)/2;
	triple A0 = rpoint(k,M,A), B0=rpoint(k,M,B), C0=rpoint(k,(C+D)/2, C), D0 = rpoint(k,(C+D)/2,D);
	return intersectionpoint(A0--B0,C0--D0);
}

//Giao đường thẳng và đường tròn
triple []intersectionpoints(line3 l, circle3 co) {
    triple []result;
    
    plane3 pl = circletoplane(co);
    
    if(l.A@pl && l.B@pl) {
        triple M = project(co.c, l);
        triple A;
        if (M != l.A) A = l.A;
        else A = l.B;

        real rm = sqrt(co.r^2 - abs(co.c-M)^2);
        real k = rm/abs(M-A);
        triple P = M+k*(A-M);

        if (P @ co) {
            result.push(P);
            result.push(2M-P);
        } else {
            P = M-k*(A-M);
            result.push(P);
            result.push(2M-P);
        }


    } else {
        triple N = intersectionpoint(l, pl);
        if (N @ co) result.push(N);
    }
    return result;
}

//Giao hai mặt cầu sa, sb
circle3 intersect(sphere3 sa, sphere3 sb) {
    circle3 result;
    if ((sa.r + sb.r - abs(sa.c-sb.c)) >= epsgeo) {
        real a = sa.r, b = sb.r, c = abs(sa.c-sb.c), p = (a+b+c)/2;
        real area = sqrt(p*(p-a)*(p-b)*(p-c));
        real rm = 2*area/c;
        triple M = bary(sqrt(a^2-rm^2), sqrt(b^2-rm^2), sa.c, sb.c);
        result = circle3(M, rm, sa.c-sb.c);
    }
    
    return result;
}

//Đường thẳng qua P song song với l
line3 parallel(triple P, line3 l) {
    return line3(P, P+l.A-l.B);
}

//Mặt phẳng qua P song song với pl
plane3 parallel(triple P, plane3 pl) {
    return perpendicular(P, O, pl.normal);
}

//Trả về true nếu P nằm trong mặt cầu s
bool isinside(triple P, sphere3 s) {
    return (abs(s.c - P) < s.r);
}

//Góc giữa hai mặt phẳng
real degrees(plane3 pl1, plane3 pl2) {
    real a1 = pl1.a, b1 = pl1.b, c1 = pl1.c, d1 = pl1.d;
    real a2 = pl2.a, b2 = pl2.b, c2 = pl2.c, d2 = pl2.d;
    return aCos(abs(a1*a2 + b1*b2 + c1*c2) /sqrt(a1^2+b1^2+c1^2)/sqrt(a2^2+b2^2+c2^2));
}

real angle(plane3 pl1, plane3 pl2) {
    real a1 = pl1.a, b1 = pl1.b, c1 = pl1.c, d1 = pl1.d;
    real a2 = pl2.a, b2 = pl2.b, c2 = pl2.c, d2 = pl2.d;
    return acos(abs(a1*a2 + b1*b2 + c1*c2) /sqrt(a1^2+b1^2+c1^2)/sqrt(a2^2+b2^2+c2^2));
}

/*struct inversion3*/
struct inversion3 {
  triple C;
  real k;

  void operator init(real k, triple C) {
	  this.C = C;
	  this.k = k;
  }
  void operator init(triple C, real k) {
	  this.C = C;
	  this.k = k;
  }

  void operator init(sphere3 so) {
      this.C = so.c;
      this.k = so.r^2;
  }
}

/*struct inversion3*/

//Nghịch đảo của điểm A
triple inverse3(triple A, triple C, real k) {
    real t = k/abs(C-A)^2;
    //return rpoint(t, C, A);
	return (1-t)*C + t*A;
}

triple operator *(inversion3 inv, triple A) {
  return inverse3(A, inv.C, inv.k);
}

//Nghịch đảo của mặt cầu sa
sphere3 inverse3(sphere3 sa, triple C, real k) {
	triple pA = sa.r*X+sa.c-O, pB = sa.r*Y+sa.c-O, pC = sa.r*Z+sa.c-O, pD = 2*sa.c-pA;
    triple iA = inverse3(pA, C, k), iB = inverse3(pB, C, k), iC = inverse3(pC, C, k), iD = inverse3(pD, C, k);
    return sphere3(iA, iB, iC, iD);
}

//Nghịch đảo của đường tròn (xem hướng khác)
circle3 inverse3(circle3 co, triple C, real k) {
	circle3 result;
	triple N = co.normal+co.c;
	triple pX = relpoint(co.path(), 0), pY = rotate(90, co.c, N)*pX, pZ = rotate(180, co.c, N)*pX;
	triple iX = inverse3(pX, C, k), iY = inverse3(pY, C, k), iZ = inverse3(pZ, C, k);
	return circumcircle(triangle3(iX, iY, iZ));
}

circle3 operator *(inversion3 inv, circle3 ca) {
  return inverse3(ca, inv.C, inv.k);
}

sphere3 operator *(inversion3 inv, sphere3 sa) {
  return inverse3(sa, inv.C, inv.k);
}

//Mặt phẳng qua điểm nghịch đảo của A và vuông góc với Ac;
plane3 polarplane(triple A, triple C, real r) {
    //real k = (r/abs(c-A))^2;
    //triple M = rpoint(k, c, A);
    triple M = inverse3(A, C, r^2);
    return perpendicular(M, A, C);
}

plane3 polarplane(triple A, sphere3 s) {
    return polarplane(A, s.c, s.r);
}

//Mặt phẳng qua A, B và tiếp xúc với mặt cầu s
plane3 []tangents(triple A, triple B, sphere3 s) {
    plane3 []result;
    plane3 pla = polarplane(A, s), plb = polarplane(B, s);
    line3 lab = intersect(pla, plb);
    circle3 ca = intersect(pla, s);
    triple []T = intersectionpoints(lab, ca);
    for (var P : T) result.push(plane3(A, B, P));
    
    return result;
}
/////////////////////