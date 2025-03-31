function ndofparams = NPLoadParameters(ndof)
% ndofparams = ndofLoadParameters(ndof)

%% Parameter values (modify if needed)
% subscript j: value of parameter in joints 1:N
% subscript 1: value of parameter in first joint if different from j
% subscript end: value of parameter in last joint if different from j

% Mass
m_1 = 0.018400377960769;
m_j = 0.0035197;
m_end = 0.0269907;

% Inertia around rotating axis (not the center of mass)
Izz_1 = 2.9315401806075e-6;
Izz_j = 1.1997769713183e-6;
Izz_end = 7.60430998068e-6;

% Center of mass
l_c_1 = 0.0034993794536687;
l_c_j = 0.02827190757535;
l_c_end = 0.053692432518384;

% Distance between frames
l_j = 0.057;

% Viscous friction
% b_1 = 0.0008;
% b_j = 0.00008*0.1;  % since all joints after 2 are identical, friction is fixed
b_1 = 0.000356;
b_j = 1.6641e-5;

%% Defining as iteratable vectors for use in NE algorithm (do not change)
m = m_j*ones(1,ndof);
m(1) = m_1;
m(end) = m_end;

Izz = Izz_j*ones(1,ndof);
Izz(1) = Izz_1;
Izz(end) = Izz_end;

I = zeros(3,3,ndof);
for i = 1:ndof
    I(:,:,i) = diag([0 0 Izz(i)]);
end

l_c = l_c_j*ones(1,ndof);
l_c(1) = l_c_1;
l_c(end) = l_c_end;

l = l_j*ones(1,ndof);

b = b_j*ones(1,ndof);
b(1) = b_1;

ndofparams.m = m;
ndofparams.I = I;
ndofparams.l_c = l_c;
ndofparams.l = l;
ndofparams.b = b;
ndofparams.ndof = ndof;