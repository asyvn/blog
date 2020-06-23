//Một số hàm để vẽ các đường tròn tiếp xúc (apollonius problem).
//Version 1 of 23/06/2020
//Quân.T nhóm Quán Hình. email: quanhinh9@gmail.com
//https://www.facebook.com/groups/205466756603509/
//http://asymptote.sourceforge.net/doc/index.html
//www.piprime.fr/asymptote/
//http://cgmaths.fr/cgFiles/Dem_Rapide.pdf
//https://github.com/vectorgraphics/asymptote/blob/master/base/geometry.asy
//https://github.com/vEnhance/dotfiles/blob/master/asy/olympiad.asy

import geometry;

struct locuspl {
	bool finite;
	parabola parabola;
	line line;
}

//Tập hợp tâm các đường tròn đi qua A và tiếp xúc với đường thẳng l
locuspl locus(point A, line l) {
	locuspl tmp;
	if (A @ l ) {
		tmp.finite = false;
		tmp.line = perpendicular(A, l);
	}	else {
		tmp.finite = true;
		tmp.parabola = parabola(A, l);
	}
	return tmp;
}

void draw(locuspl la, pen pen) {
	if (la.finite) draw(la.parabola, pen);
	else draw(la.line, pen);
}

//Giao của hai tập hợp PL
point [] ips(locuspl la, locuspl lb) {
	point [] tmp;
	
	if (la.finite & lb.finite) {
		point [] cx = intersectionpoints(la.parabola, lb.parabola); 
		for (int i=0; i< cx.length; ++i) {
			if (finite(cx[i])) tmp.push(cx[i]);
		} 
	}
	
	if (la.finite == false & lb.finite) {
		point [] cx  = intersectionpoints(la.line, lb.parabola);
		for (int i=0; i< cx.length; ++i) {
				if (finite(cx[i])) tmp.push(cx[i]); 
			}
		}
	
	if (la.finite & lb.finite == false) {
		point [] cx  = intersectionpoints(la.parabola, lb.line);
		for (int i=0; i< cx.length; ++i) {
			if (finite(cx[i])) tmp.push(cx[i]);
		}
	}
	
	if (la.finite == false & lb.finite == false) {
		point cx = intersectionpoint(la.line, lb.line); 
		if (finite(cx)) tmp.push(cx);
	}
	
	return tmp;	
}

//Tâm các đường tròn đi qua A, B tiếp xúc với l
point [] centers(point a, point b, line l) {
	locuspl lca = locus(a, l), lcb = locus(b, l);
	point [] center = ips(lca, lcb);
	
	return center;
}

//Các đường tròn đi qua A, B và tiếp xúc với l
circle [] tangents(point a, point b, line l) {
	circle [] ct;
	point [] center = centers(a, b, l);
	for (int i = 0; i<center.length; ++i) {
		if (center[i] @ l == false) ct.push(circle(center[i], abs(center[i]-a)));
	}
	
	return ct;
}

//Tâm các đường tròn đi qua A và tiếp xúc với hai đường thẳng lm, ln
point [] centers(point a, line lm, line ln) {
	locuspl lcm = locus(a, lm), lcn = locus(a, ln);
	point [] center = ips(lcm, lcn);
	
	return center;
}

//Các đường tròn đi qua A và tiếp xúc với hai đường thẳng lm, ln
circle [] tangents(point a, line lm, line ln) {
	circle [] ct;
	point [] center = centers(a, lm, ln);
	for (int i = 0; i<center.length; ++i) {
		if (center[i] != a) ct.push(circle(center[i], abs(center[i]-a)));
	}
	
	return ct;
}


struct locuspc {
	int style;
	hyperbola hyperbola;
	ellipse ellipse;
	line line;
}

//Tập hợp tâm các đường tròn đi qua A và tiếp xúc với đường tròn c
locuspc locus(point a, circle c) {
	locuspc tmp;
	if (a @ c) {
		tmp.style = 0;
		tmp.line = line(a, c.C);
	} else {
		if (inside(c, a)) {
			tmp.style = -1;
			tmp.ellipse = ellipse(a, c.C, c.r/2);
		} else {
			tmp.style = 1;
			tmp.hyperbola = hyperbola(a, c.C, c.r/2);
		}
	}
	return tmp;
}

void draw(locuspc la, pen pen) {
	if (la.style == 1) draw(la.hyperbola, pen);
	if (la.style == -1) draw(la.ellipse, pen);
	if (la.style == 0) draw(la.line, pen);
}

//PPC - Tâm các đường tròn đi qua A, B và tiếp xúc với đường tròn cc
point [] centers(point A, point B, circle cc) {
	point [] center;
	locuspc lcA = locus(A, cc); line lAB = bisector(A, B);
	
	if (lcA.style == 1) {
		point [] cx = intersectionpoints(lcA.hyperbola, lAB);
		for (int i=0; i<cx.length; ++i) {
			if (finite(cx[i])) center.push(cx[i]);
		}
	} else if (lcA.style == -1) {
		point [] cx = intersectionpoints(lcA.ellipse, lAB);
		for (int i=0; i<cx.length; ++i) {
			if (finite(cx[i])) center.push(cx[i]);
		}
	} else {
		point cx = intersectionpoint(lcA.line, lAB);
		if (finite(cx)) center.push(cx);
	}
	
	return center;
}

//PPC - Các đường tròn đi qua A, B và tiếp xúc với đường tròn cc
circle [] tangents(point A, point B, circle cc) {
	circle [] ct;
	point [] center = centers(A, B, cc);
	for (int i = 0; i<center.length; ++i) {
		if (center[i] != A & center[i] != cc.C) ct.push(circle(center[i], abs(center[i]-A)));
	}
	
	return ct;
}

//PLC - Tâm các đường tròn đi qua A tiếp xúc với đường thẳng lm và đường tròn cc
point [] centers (point A, line lm, circle cc) {
	point [] center;
	locuspl lca = locus(A, lm);
	locuspc lcb = locus(A, cc); 
	
	if (lca.finite) {
		point [] cx; 
		if (lcb.style == 1) {
			cx = intersectionpoints(lca.parabola, lcb.hyperbola);
			for (int i=0; i < cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
			
		} else if (lcb.style == -1) {
			cx = intersectionpoints(lca.parabola, lcb.ellipse);
			for (int i=0; i < cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}	
		} else {
			cx = intersectionpoints(lca.parabola, lcb.line);
			for (int i=0; i < cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		}
	} else {
		point [] cx; 
		if (lcb.style == 1) {
			cx = intersectionpoints(lca.line, lcb.hyperbola);
			for (int i=0; i < cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		} else if (lcb.style == -1) {
			cx = intersectionpoints(lca.line, lcb.ellipse);
			for (int i=0; i < cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}	
		} else {
			point cy = intersectionpoint(lca.line, lcb.line);
			if (finite(cy)) center.push(cy);
		}
	}
	
	return center;
}

//PLC - Các đường tròn đi qua A tiếp xúc với đường thẳng lm và đường tròn cc
circle [] tangents(point A, line lm, circle cc) {
	circle [] ct;
	point [] center = centers(A, lm, cc);
	for (int i = 0; i<center.length; ++i) {
		if (center[i] != A & center[i] != cc.C) ct.push(circle(center[i], abs(center[i]-A)));
	}
	
	return ct;
}

//PCC - Tâm các đường tròn đi qua A tiếp xúc với đường tròn cb, cc
point [] centers(point A, circle cb, circle cc) {
	point [] center;
	locuspc lcB = locus(A, cb), lcC = locus(A, cc);
	
	if (lcB.style == 1) {
		point [] cx;
		if (lcC.style == 1) {
			cx = intersectionpoints(lcB.hyperbola, lcC.hyperbola);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		} else if (lcC.style == -1) {
			cx = intersectionpoints(lcB.hyperbola, lcC.ellipse);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		} else {
			cx = intersectionpoints(lcB.hyperbola, lcC.line);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		}

	} else if (lcB.style == -1) {
		point [] cx;
		if (lcC.style == 1) {
			cx = intersectionpoints(lcB.ellipse, lcC.hyperbola);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		} else if (lcC.style == -1) {
			cx = intersectionpoints(lcB.ellipse, lcC.ellipse);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		} else {
			cx = intersectionpoints(lcB.ellipse, lcC.line);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		}

	} else {
		point [] cx;
		if (lcC.style == 1) {
			cx = intersectionpoints(lcB.line, lcC.hyperbola);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		} else if (lcC.style == -1) {
			cx = intersectionpoints(lcB.line, lcC.ellipse);
			for (int i=0; i<cx.length; ++i) {
				if (finite(cx[i])) center.push(cx[i]);
			}
		} else {
			point cy = intersectionpoint(lcB.line, lcC.line);
			if (finite(cy)) center.push(cy);
		}
	}
	
	return center;
}

//Kiểm tra tiếp xúc của hai đường tròn.
bool checktangent(circle c1, circle c2){
	bool tmp=false;
	point T[]=intersectionpoints(c1, line(c1.C,c2.C));
	if ((T[0] @ c2) | (T[1] @ c2)) tmp=true;
	return tmp;
}

//PCC - Các đường tròn đi qua A tiếp xúc với đường tròn cb, cc
//Có cần thiết kiểm tra tiếp xúc?
circle [] tangents(point A, circle cb, circle cc) {
	point [] center = centers(A, cb, cc);
	circle [] ct;
	for (int i = 0; i<center.length; ++ i) {
		if (center[i] !=A & center[i] !=cb.C & center[i] !=cc.C) {
			circle cx = circle(center[i], abs(center[i]-A));
			if (checktangent(cx, cb) & checktangent(cx, cc)) ct.push(cx);
		}
	}
	
	return ct;
}

//Tập hợp tâm các đường tròn tiếp xúc với đường thẳng lm và đường tròn cc
locuspl [] locus(line lm, circle cc) {
	locuspl [] tmp;
	point P = projection(lm)*cc.C;
	point [] q =  intersectionpoints(perpendicular(cc.C, lm), cc);
	
	point [] v;
	line [] ld;
	
	for (int i = 0; i<q.length; ++i) {
		if (finite(q[i])) {
			v.push((P + q[i])/2);
			ld.push(parallel(rotate(180, v[i])*cc.C, lm));
		}
	
	}
	
	for (int i = 0; i<ld.length; ++i) tmp.push(locus(cc.C, ld[i]));
	
	return tmp;
}

// Trả về đường tròn tâm A, tiếp xúc với đường thẳng lm
circle circlepl(point A, line lm) {
	circle tmp; 
	if (A @ lm == false) tmp = circle(A, distance(A, lm));
	return tmp;
}

//LLC - Tâm các đường tròn tiếp xúc với hai đường thẳng lm, ln và đường tròn cc
//Có thể xét giao với đường phân giác (lm, ln)
point [] centers(line lm, line ln, circle cc) {
	point [] tmp;
	locuspl [] la = locus(lm, cc);
	locuspl [] lb = locus(ln, cc);
	for (int i = 0; i<la.length; ++i)
		for (int j=0; j<lb.length; ++j){
		point [] cx = ips(la[i], lb[j]);
		for (int k=0; k<cx.length; ++k) {
			if (finite(cx[k]) & cx[k] != cc.C & distance(cx[k], lm)>=epsgeo & distance(cx[k], ln) >= epsgeo & abs(distance(cx[k], lm) - distance(cx[k], ln) ) <epsgeo ) tmp.push(cx[k]);
		}
			
	}
	return tmp;
}

//LLC - Các đường tròn tiếp xúc với hai đường thẳng lm, ln và đường tròn cc
circle [] tangents(line lm, line ln, circle cc) {
	circle [] ct;
	
	point [] center = centers(lm, ln, cc);
	for (int i=0; i<center.length; ++i) {
		if (center[i] != cc.C & distance(center[i], lm)>=epsgeo) ct.push(circlepl(center[i], lm));
	}
	
	return ct;
}

//LCC - Tâm các đường tròn tiếp xúc với đường thẳng lm và hai đường tròn cb, cc
point [] centers(line lm, circle cb, circle cc) {
	point [] tmp;
	locuspl [] lb = locus(lm, cb);
	locuspl [] lc = locus(lm, cc);
	for (int i = 0; i<lb.length; ++i) {
		for (int j=0; j<lc.length; ++j){
			point [] cx = ips(lb[i], lc[j]);
			for (int k=0; k<cx.length; ++k) {
				if (finite(cx[k])) tmp.push(cx[k]);
			}
		}
	}
	return tmp;
}

//LCC - Các đường tròn tiếp xúc với đường thẳng lm và hai đường tròn cb, cc
circle [] tangents(line lm, circle cb, circle cc) {
	circle [] ct;
	
	point [] center = centers(lm, cb, cc);
	for (int i=0; i<center.length; ++i) {
		if (center[i] != cb.C & center[i] != cc.C) ct.push(circlepl(center[i], lm));
	}
	
	return ct;
}

//CCC - Tập hợp tâm các đường tròn tiếp xúc với hai đường tròn ca, cb
locuspc [] locus(circle ca, circle cb) {
	locuspc [] lc2c;
	real d = abs(ca.C - cb.C);
	real m = abs(ca.r - cb.r)/2, n = abs(ca.r + cb.r)/2;
	
	if (2*m < epsgeo) {
		locuspc lcx;
		lcx.style = 0;
		lcx.line = bisector(ca.C, cb.C);
		lc2c.push(lcx); 
	} else {
		locuspc lcm, lcn;
		if (abs(2*m-d) < epsgeo) {
			lcm.style = 0;
			lcm.line = line(ca.C, cb.C);
		} else if (2*m-d >= epsgeo) {
			lcm.style = -1;
			lcm.ellipse = ellipse(ca.C, cb.C, m);
		} else {
			lcm.style = 1;
			lcm.hyperbola = hyperbola (ca.C, cb.C, m);
		}
		
		if (abs(2*n-d) < epsgeo) {
			lcn.style = 0;
			lcn.line = line(ca.C, cb.C);
		} else if (2*n-d >= epsgeo) {
			lcn.style = -1;
			lcn.ellipse = ellipse(ca.C, cb.C, n);
		} else {
			lcn.style = 1;
			lcn.hyperbola = hyperbola (ca.C, cb.C, n);
		}
		
		lc2c.push(lcm);
		lc2c.push(lcn);		
	}
	
	return lc2c;
}

point [] ips(locuspc lb, locuspc lc) {
point [] center;

	if (lb.style == 1 & lc.style == 1) center = intersectionpoints(lb.hyperbola, lc.hyperbola);
	if (lb.style == 1 & lc.style == -1) center = intersectionpoints(lb.hyperbola, lc.ellipse);
	if (lb.style == 1 & lc.style == 0) center = intersectionpoints(lb.hyperbola, lc.line);

	if (lb.style == -1 & lc.style == 1) center = intersectionpoints(lb.ellipse, lc.hyperbola);
	if (lb.style == -1 & lc.style == -1) center = intersectionpoints(lb.ellipse, lc.ellipse);
	if (lb.style == -1 & lc.style == 0) center = intersectionpoints(lb.ellipse, lc.line);
	
	if (lb.style == 0 & lc.style == 1) center = intersectionpoints(lb.line, lc.hyperbola);	
	if (lb.style == 0 & lc.style == -1) center = intersectionpoints(lb.line, lc.ellipse);
	if (lb.style == 0 & lc.style == 0) center.push(intersectionpoint(lb.line, lc.line));
	
	return center;
}

//CCC - Tâm các đường tròn tiếp xúc với ba đường tròn ca, cb, cc
point [] centers(circle ca, circle cb, circle cc) {
	point [] center;
	locuspc [] lcm, lcn;
	
	if (ca.C == cb.C) {
		lcm = locus(ca, cc);
		lcn = locus(cb, cc);
	} else if (ca.C == cc.C) {
		lcm = locus(ca, cb);
		lcn = locus(cc, cb);
	} else {
		lcm = locus(cb, ca);
		lcn = locus(cc, ca);
	}
	
	for (int i = 0; i < lcm.length; ++i) {
		for (int j = 0; j < lcn.length; ++j ){
			point [] cx = ips(lcm[i], lcn[j]);
			for (int k = 0; k < cx.length; ++k ) {
				if (finite(cx[k]) & cx[k] != ca.C & cx[k] != cb.C & cx[k] != cc.C) center.push(cx[k]); 
			}	
		}
	}
	
	return center;
}

//Trả về đường tròn tâm A tiếp xúc với đường tròn c
circle [] circlepc(point A, circle c) {
	circle [] tmp;
	point [] p = intersectionpoints(c, line(A, c.C));
	for (int i=0; i< p.length; ++i) {
		if (abs(A-p[i]) >= epsgeo ) tmp.push(circle(A, abs(A-p[i])));
	}
	
	return tmp;
}

//CCC - Các đường tròn tiếp xúc với ba đường tròn ca, cb, cc
circle [] tangents(circle ca, circle cb, circle cc) {
	circle [] ct;
	point [] center = centers(ca, cb, cc);
	
	for (int i=0; i<center.length; ++i) {
		circle [] cx = circlepc(center[i], ca);
		for (int i=0; i < cx.length; ++i) {
			if (checktangent(cx[i], cb) & checktangent(cx[i], cc)) ct.push(cx[i]);
		
		}
	}
	
	return ct;
}
