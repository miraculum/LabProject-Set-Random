                        % Extended Kalman update %
                        
% In:
%   x - mean state estimate of previous step
%   P - state covariance of previous step
%   u - control vector
%   h - valid function handle
%   R - Observation noise covariance matrix        (optional, default zero)
%   z - observation of the true state x
%   h1- first derivative of h in the form of function handle.

% Out:
%   x - Updated state mean
%   P - Updated state covariance
%   h1- first derivative of h in the form of function handle.        


function [x,P,h1] = updateExtendedKalman(x,P,u,h,R,z,h1)

    % Number of inputs control     
    if nargin < 4
        errorMessage('updateExtendedKalman requires at least 4 arguments');
    end
    if nargin < 5
        R = [];
    end
    
    if isempty(u)
      errorMessage("Control vetor 'u' is empty");
    end

        H = h1(x);
            
        y = z - h(x); 
        S = H * P * H' + R;            %Innovation (or residual) covariance
        K = P * H' / S;                %Near-optimal Kalman gain
        x = x + K * y;                 %Updated state estimate		
        I = eye(size(K,1));
        P = (I - K * H) * P;           %Updated covariance estimate	 