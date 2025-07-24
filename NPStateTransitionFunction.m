function x_out = NPStateTransitionFunction(x, params)

Ts = params(1);
ndof = params(2);

if nargin < 4
    solver = 'rk5';
end
solver = 'rk5';
NPparams = NPLoadParameters(ndof);

switch(solver)
    case 'euler'
        x_out = x + Ts*ndofDirectDynamics(x, ndof, NPparams);
    case 'rk4'
        k1 = NPDD(x, ndof, NPparams);
        k2 = NPDD(x + k1/2, ndof, NPparams);
        k3 = NPDD(x + k2/2, ndof, NPparams);
        k4 = NPDD(x + k3, ndof, NPparams);
        
        x_out = x + Ts/6*(k1 + 2*k2 + 2*k3 + k4);
    case 'heun'
        k1 = NPDD(x, ndof, NPparams);
        k2 = NPDD(x + Ts*k1, ndof, NPparams);
        x_out = x + Ts/2*(k1 + k2);
    case 'beuler'
        x_next = x;
        for i = 1:10
            x_next = x + Ts*NPDD(x_next, ndof, NPparams);
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

        k1 = Ts * NPDD(x, ndof, NPparams);
        k2 = Ts * NPDD(x + A(2, 1) * k1, ndof, NPparams);
        k3 = Ts * NPDD(x + A(3, 1) * k1 + A(3, 2) * k2, ndof, NPparams);
        k4 = Ts * NPDD(x + A(4, 1) * k1 + A(4, 2) * k2 + A(4, 3) * k3, ndof, NPparams);
        k5 = Ts * NPDD(x + A(5, 1) * k1 + A(5, 2) * k2 + A(5, 3) * k3 + A(5, 4) * k4, ndof, NPparams);
        k6 = Ts * NPDD(x + A(6, 1) * k1 + A(6, 2) * k2 + A(6, 3) * k3 + A(6, 4) * k4 + A(6, 5) * k5, ndof, NPparams);
        
        x_out = x + b5(1) * k1 + b5(3) * k3 + b5(4) * k4 + b5(5) * k5 + b5(6) * k6;
        

    otherwise
        x_out = x + Ts*NPDD(x, ndof, NPparams);
end

end