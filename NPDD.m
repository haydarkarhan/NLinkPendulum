function dz = NPDD(z, ndof, ndofparams)
dz = zeros(size(z));
dz(1:ndof) = z(ndof+1:end);

theta = z(1:ndof);
dtheta = z(ndof+1:2*ndof);

E = eye(ndof);
M = zeros(ndof);
O = zeros(ndof,1);

% Direct dynamic calculations
H = ndofNE(1, theta, dtheta, O, ndofparams);
for i = 1:ndof
    M(:,i) = ndofNE(0, theta, O, E(:,i), ndofparams);
end
dz(ndof+1:2*ndof) = M\(-H);
end