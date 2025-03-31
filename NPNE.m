function tau = NPNE(alpha, theta, dtheta, ddtheta, ndofparams)
%tau = NPNE(alpha, theta, dtheta, ddtheta, ndof)
% Computes the generalized torque using the Newton-Euler algorithm of the
% n degree of freedom pendulum
% Inputs:
%   alpha: gravtiy vector activation
%   theta, dtheta, ddtheta: states
%   ndof: number of degrees of freedom

ndof = ndofparams.ndof;
m = ndofparams.m;
I = ndofparams.I;
l_c = ndofparams.l_c;
l = ndofparams.l;
b = ndofparams.b;

u = zeros(ndof,1);

%% Parameters
g = -alpha*9.80665;

MDH = zeros(ndof+1, 4);
R = zeros(3,3,ndof+1);
P = zeros(3, ndof+1);
Pc = zeros(3, ndof);
for i = 1:ndof+1
    if i == 1
        MDH(i, :) = [0 0 0 theta(i)];
        P(:,i) = [0 0 0]';
        Pc(:,i) = [l_c(i) 0 0]';
    elseif i == ndof+1
        MDH(i, :) = [0 l(i-1) 0 0];
        P(:,i) = [l(i-1) 0 0]';
    else
        MDH(i, :) = [0 l(i-1) 0 theta(i)];
        P(:,i) = [l(i-1) 0 0]';
        Pc(:,i) = [l_c(i) 0 0]';
    end

    R(:,:,i) = [cos(MDH(i,4)), -sin(MDH(i,4)), 0;
        sin(MDH(i,4)),  cos(MDH(i,4)), 0;
        0 0 1];

end

w = zeros(3,ndof+1);
dw = zeros(3,ndof+1);
dv = zeros(3,ndof+1);
dvc = zeros(3,ndof);
Z = [0 0 1]';
dv(:,1) = [g;0;0];

F = zeros(3,ndof);
N = zeros(3,ndof);
for i = 1:ndof
    w(:,i+1) = R(:,:,i)'*w(:,i) + dtheta(i)*Z;
    dw(:,i+1) = R(:,:,i)'*dw(:,i) + ddtheta(i)*Z + cross(R(:,:,i)'*w(:,i), dtheta(i)*Z);
    dv(:,i+1) = R(:,:,i)'*(cross(dw(:,i), P(:,i)) + cross(w(:,i), cross(w(:,i), P(:,i))) + dv(:,i));
    dvc(:,i) = cross(dw(:,i+1), Pc(:,i)) + cross(w(:,i+1), cross(w(:,i+1), Pc(:,i))) + dv(:,i+1);
    F(:,i) = m(i)*dvc(:,i);
    N(:,i) = I(:,:,i)*dw(:,i+1) + cross(w(:,i+1), I(:,:,i)*w(:,i+1));
end

f = zeros(3,ndof+1);
n = zeros(3,ndof+1);
H = zeros(3,ndof);
for i = ndof:-1:1
    f(:,i) = R(:,:,i+1)*f(:,i+1) + F(:,i);
    H(:,i) = R(:,:,i+1)*n(:,i+1) + cross(Pc(:,i), F(:,i)) + cross(P(:,i+1), R(:,:,i+1)*f(:,i+1));
    n(:,i) = N(:,i) + H(:,i);
end

for i = 1:ndof
    u(i) = n(:,i)'*Z + b(i)*dtheta(i);
end

end