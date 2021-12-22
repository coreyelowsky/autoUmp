function speed = calculateSpeed(timeDataDepth, framesWithBall, centers)

% calculate speed of the pitch

% input : timeDataDepth
%       : framesWithBall
%       : centers (realWorld)

% if there's at least 2 points
if(size(centers,2) > 1)
    tSec = timeDataDepth(framesWithBall(1)) - timeDataDepth(framesWithBall(2));
    tHour = (tSec / 60 / 60);
    distmMeters = centers(2,1) - centers(1,1);
    distMiles = (distmMeters*.000621)/1000;
    speed = distMiles / tHour;
else
    speed = -1;
end

end

