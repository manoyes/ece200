module CLA_add_16(SUM, c_out,A,B, c_in);
output [15:0] SUM;
output c_out;
input [15:0] A,B;
input c_in;
wire c1,c2,c3,c4;
wire [3:0] S1, S2, S3, S4;

CLA_unit_16 CLA_u(c_out,c3,c2,c1, A, B, c_in);

CLA_adder_4 u1(S1, A[3:0], B[3:0],c_in);
CLA_adder_4 u2(S2, A[7:4], B[7:4],c1);
CLA_adder_4 u3(S3, A[11:8], B[11:8],c2);
CLA_adder_4 u4(S4, A[15:12], B[15:12],c3);

assign SUM = {S4, S3, S2, S1};
endmodule

module CLA_adder_4(sum, a, b, c_in);
output [3:0] sum;
input [3:0] a,b;
input c_in;

wire p0,g0, p1,g1, p2,g2, p3,g3;
wire c4, c3, c2, c1;
wire t00,t10,t11,t20,t21,t22,t30,t31,t32,t33;

// compute the p for each stage
xor(p0,a[0],b[0]);
xor(p1,a[1],b[1]);
xor(p2,a[2],b[2]);
xor(p3,a[3],b[3]);
// compute the g for each stage
and(g0,a[0],b[0]);
and(g1,a[1],b[1]);
and(g2,a[2],b[2]);
and(g3,a[3],b[3]);

// carry lookahead computation
and(t00,p0,c_in);
or(c1,t00,g0);

and(t10,p1,g0);
and(t11,p1, p0,c_in);
or(c2,t10,t11,g1);

and(t20,p2,g1);
and(t21,p2, p1,g0);
and(t22,p2, p1,p0,c_in);
or(c3,t20,t21,t22,g2);

and(t30,p3,g2);
and(t31,p3, p2,g1);
and(t32,p3, p2,p1,g0);
and(t33,p3, p2,p1,p0,c_in);
or(c4,t30,t31,t32,t33,g3);

// Compute Sum
xor(sum[0],p0,c_in);
xor(sum[1],p1,c1);
xor(sum[2],p2,c2);
xor(sum[3],p3,c3);

endmodule


module CLA_unit_16(c4,c3,c2,c1, a, b, c_in);
output c4,c3,c2,c1;
input [15:0] a,b;
input c_in;

wire p0,g0, p1,g1, p2,g2, p3,g3;
wire t00,t10,t11,t20,t21,t22,t30,t31,t32,t33;

CLA_Group_Generation4 u1(g0, p0, a[3:0], b[3:0]);
CLA_Group_Generation4 u2(g1, p1, a[7:4], b[7:4]);
CLA_Group_Generation4 u3(g2, p2, a[11:8], b[11:8]);
CLA_Group_Generation4 u4(g3, p3, a[15:12], b[15:12]);

// carry lookahead computation
and(t00,p0,c_in);
or(c1,t00,g0);

and(t10,p1,g0);
and(t11,p1, p0,c_in);
or(c2,t10,t11,g1);

and(t20,p2,g1);
and(t21,p2, p1,g0);
and(t22,p2, p1,p0,c_in);
or(c3,t20,t21,t22,g2);

and(t30,p3,g2);
and(t31,p3, p2,g1);
and(t32,p3, p2,p1,g0);
and(t33,p3, p2,p1,p0,c_in);
or(c4,t30,t31,t32,t33,g3);

endmodule


module CLA_Group_Generation4(G, P, a, b);
output G,P;
input [3:0] a,b;

wire p0,g0, p1,g1, p2,g2, p3,g3;
wire c4, c3, c2, c1;
wire t00,t10,t11,t20,t21,t22,t30,t31,t32,t33;

// compute the p for each stage
xor(p0,a[0],b[0]);
xor(p1,a[1],b[1]);
xor(p2,a[2],b[2]);
xor(p3,a[3],b[3]);
// compute the g for each stage
and(g0,a[0],b[0]);
and(g1,a[1],b[1]);
and(g2,a[2],b[2]);
and(g3,a[3],b[3]);

// Group carry lookahead computation
and(t30,p3,g2);
and(t31,p3, p2,g1);
and(t32,p3, p2,p1,g0);
or(G,t30,t31,t32,g3);

and(P,p0,p1,p2,p3);
endmodule