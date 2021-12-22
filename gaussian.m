
% average 62% strikes

% all values in cm

plateWidth = 43.18;
plateHeight = 60.96; % approximately 2 feet
ballRadius = 23.5;

strikes =0;
trials = 100;
sd = 39.5; % found through guess and check


for i = 1:trials
    % center of ball
    x(i) = normrnd(0,sd);
    y(i) = normrnd(0,sd);
    
    if(x(i) >= -plateWidth/2-ballRadius & x(i) <= plateWidth/2+ballRadius & ...
            y(i) >= -plateHeight/2-ballRadius & y(i) <= plateHeight/2+ballRadius)
        strikes = strikes + 1;
    end
end



scatter(x,y,100)
hold on
plot([-plateWidth/2 -plateWidth/2 plateWidth/2 plateWidth/2 -plateWidth/2],...
    [-plateHeight plateHeight plateHeight -plateHeight -plateHeight]);
percentageStrike = strikes /trials

% pause
%
% mu = [0 0];
% Sigma = [1 0; 0 1];
% x = -3:.2:3; y = -3:.2:3;
% [X,Y] = meshgrid(x,y);
% F = mvnpdf([X(:) Y(:)],mu,Sigma);
% F = reshape(F,length(x),length(y));
% surf(x,y,F);
% caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
% axis([-3 3 -3 3 0 .4])
% xlabel('x1'); ylabel('x2'); zlabel('Probability Density');