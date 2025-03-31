function x_out = NPStateFunction(x, params)

Ts = params(1);
ndof = params(2);

if nargin < 4
    solver = 'rk5';
end

ndofparams = ndofLoadParameters(ndof);

switch(solver)
    case 'euler'
        x_out = x + Ts*ndofDirectDynamics(x, ndof, ndofparams);
    case 'rk4'
        k1 = ndofDirectDynamics(x, ndof, ndofparams);
        k2 = ndofDirectDynamics(x + k1/2, ndof, ndofparams);
        k3 = ndofDirectDynamics(x + k2/2, ndof, ndofparams);
        k4 = ndofDirectDynamics(x + k3, ndof, ndofparams);
        
        x_out = x + Ts/6*(k1 + 2*k2 + 2*k3 + k4);
    case 'heun'
        k1 = ndofDirectDynamics(x, ndof, ndofparams);
        k2 = ndofDirectDynamics(x + Ts*k1, ndof, ndofparams);
        x_out = x + Ts/2*(k1 + k2);
    case 'beuler'
        x_next = x;
        for i = 1:10
            x_next = x + Ts*ndofDirectDynamics(x_next, ndof, ndofparams);
        end
        x_out = x_next;
    case 'rk5'
        A = [0, 0, 0, 0, 0, 0, 0;
            1/5, 0, 0, 0, 0, 0, 0;
            3/40, 9/40, 0, 0, 0, 0, 0;
            44/45, -56/15, 32/9, 0, 0, 0, 0;
            19372/6561, -25360/2187, 64448/6561, -212/729, 0, 0, 0;
            9017/3168, -355/33, 46732/5247, 49/176, -5103/18656, 0, 0;
            35/384, 0, 500/1113, 125/192, -2187/6784, 11/84, 0];
        b5 = [35/384, 0, 500/1113, 125/192, -2187/6784, 11/84, 0];

        k1 = Ts * ndofDirectDynamics(x, ndof, ndofparams);
        k2 = Ts * ndofDirectDynamics(x + A(2, 1) * k1, ndof, ndofparams);
        k3 = Ts * ndofDirectDynamics(x + A(3, 1) * k1 + A(3, 2) * k2, ndof, ndofparams);
        k4 = Ts * ndofDirectDynamics(x + A(4, 1) * k1 + A(4, 2) * k2 + A(4, 3) * k3, ndof, ndofparams);
        k5 = Ts * ndofDirectDynamics(x + A(5, 1) * k1 + A(5, 2) * k2 + A(5, 3) * k3 + A(5, 4) * k4, ndof, ndofparams);
        k6 = Ts * ndofDirectDynamics(x + A(6, 1) * k1 + A(6, 2) * k2 + A(6, 3) * k3 + A(6, 4) * k4 + A(6, 5) * k5, ndof, ndofparams);
        
        x_out = x + b5(1) * k1 + b5(3) * k3 + b5(4) * k4 + b5(5) * k5 + b5(6) * k6;
        

    otherwise
        x_out = x + Ts*ndofDirectDynamics(x, ndof, ndofparams);
end

end