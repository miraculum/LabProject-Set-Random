                        % Kalman Filter update %
    
% In:
%   X - Nx1 mean state estimate after prediction step
%   P - NxN state covariance after prediction step
%   H - Measurement matrix.
%   R - Measurement noise covariance.
%   z - observation of the true state x

% Out:
%   X  - Updated state mean
%   P  - Updated state covariance
%   Y  - Measurement post-fit residual
 

function [X, P, Y] = updateKalman(X, P, H, R, z)

    %Innovation or measurement pre-fit residual
    Y = z - H * X;
    
    %Innovation (or pre-fit residual) covariance
    S = H * P * H' + R;
    
    %Optimal Kalman gain
    K = P * H' * S^(-1);
    
    %Updated (a posteriori) state estimate
    X = X + K * Y;
    
    %Declaring identity matrix
    [m,n] = size(K * H);
    I = eye(m, n);
    
    %Updated (a posteriori) estimate covariance
    P = (I - K * H) * P;
    %P = P - K*H*P;
    
    %Measurement post-fit residual
    Y = z - H * X;