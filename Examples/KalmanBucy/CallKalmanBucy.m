function [] = CallKalmanBucy(inputs)

    calculate_RMSE=@(a,b) sqrt(mean((a(:)-b(:)).^2));
    iterations = 2;   xerror = zeros(1, iterations);  
    truexvalues = zeros(1, iterations); predxvalues = zeros(1, iterations);
    xdifference = zeros(1, iterations);
    
    %Kalman Bucy
    fprintf('Iteration = 1/%d\n',iterations);
    
    %True X
    [truex, z] = KBTrueX(inputs.F, inputs.realxstart, inputs.B,... 
    inputs.u, inputs.w, inputs.H, inputs.v);

    %Predicted X
    [predx, predp, predy] = KBPredictedX(inputs.F, inputs.predxstart,...
        inputs.P, inputs.H, inputs.Rk, inputs.u, inputs.Qk, inputs.B, z);

    %RMSE Error 
    xerror(1) = norm(calculate_RMSE(truex, predx));
    %Save true X and predicted X
    truexvalues(1) = norm(truex);
    predxvalues(1) = norm(predx);

    xdifference(1) = norm(truex) - norm(predx);
    

    %Cycle for all iterations
    for i = 1:(iterations-1)
        fprintf('Iteration = %d/%d\n',i+1,iterations);
        
        %Disturbance
        inputs.w = mvnrnd(zeros(size(inputs.Qk, 1), 1), inputs.Qk);
        inputs.v = mvnrnd(zeros(size(inputs.Rk, 1), 1), inputs.Rk);

        %True X
        [truex, z] = KBTrueX(inputs.F, truex, inputs.B,... 
            inputs.u, inputs.w, inputs.H, inputs.v);

        %Predicted X
        [predx, predp, predy] = KBPredictedX(inputs.F, predx,...
        predp, inputs.H, inputs.Rk, inputs.u, inputs.Qk, inputs.B, z);

        %RMSE Error
        xerror(i+1) = norm(calculate_RMSE(truex, predx));
        
        truexvalues(i+1) = norm(truex);
        predxvalues(i+1) = norm(predx);
        
        xdifference(i+1) = norm(truex) - norm(predx);
    end

    figure('Name','Kalman Bucy Filter');
    plot(1:iterations, xdifference);
    legend('True X - Predicted X')
    title('Kalman Bucy Filter: Subtraction','FontSize',14);
    ylim([-0.5 1]);
    
    figure('Name','Kalman Bucy');
    plot(1:iterations,truexvalues,'b', 1:iterations,predxvalues,'r');
    legend('true x','predicted x');
    title('True vs Predicted x  -  Kalman Bucy','FontSize',14);
    
    figure('Name','Kalman Bucy');
    plot(1:iterations, xerror);
    legend('rmse error')
    title('Kalman Bucy: RMSE','FontSize',14);
    