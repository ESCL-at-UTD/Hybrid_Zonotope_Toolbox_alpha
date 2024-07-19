%% Testing Optimization integration
clear

n = 2; ng = 2;
X_G = sym('X_g_',[n,ng]);
X_c = sym('x_c_',[n,1]);

X = zono(X_G,X_c);
% X.G, X.c

%% propogation (linear map and plus)
A = [1,2;3,4]; b = ones(n,1);
X_{1} = X;
X_{2} = A*X_{1} + X + b;
for k = 3:5
    X_{k} = A*X_{k-1} + X_{k-1} + b;
end
% X_{end}.G, X_{end}.c

% % sym propogation <=== doesn't work w/ sym (but does for memZono)
% A = sym('A',[n,n]); b = sym('b',[n,1]);
% X_{1} = X;
% X_{2} = X_{1}.mtimes(A) + X + b;
% for k = 3:5
%     X_{k} = X_{k-1}.mtimes(A) + X_{k-2} + b;
% end


%% Cartisian Product
Y1 = cartProd(X_{end-1},X_{end-2});
Y2 = cartProd(cartProd(X_{end-1},X_{end-2}),X_{end-3});


%% Intersection works fine
and(X_{1},X_{2});
R = sym('R',[n,n]);
and(X_{1},X_{2},R);
R = sym('R',[3*n,n]);
and(X_{end},Y2,R);

% halfspaceIntersection (works for sym... not optimvar)
H = eye(n); f = ones(n,1);
X_half = halfspaceIntersection(X,H,f);
H = sym('H',[n n]); f = sym('f',[n 1]);
X_half = halfspaceIntersection(X,H,f);

% Union %<--- not working for sym... can't do if statements on
% abs() for determining on non-zero G... do something specific for sym?
% union(X_{1},X_{2})

% pontigan difference <=== not efficent/doesn't scale... apears to work
pontryDiff(X_{1},X_{2});
pontryDiff(X,X_half);

% boundaryBox <== doesn't work (calls sparse in function)
% boundingBox(X)

