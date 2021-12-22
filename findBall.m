function [pixelCenters, framesWithBall] = findBall(depthVideo, depthRange, pixelSizeRange, pixelRange)

%
% Looks for the ball in each frame of the video and if found, approximates
% pixel center locations of the ball by taking the mean of the all the
% pixel locations found
%
% Input : depthVideo
%         depthRange - 1x2 array, depth min and max in meters
%         pixelSizeRange - 1x2 array of pixel size min and max of ball
%         pixelRange - 1x4 array of pixel range to look at
% Output : pixelCenters -  nx3 matrix of ball center points where first
%                          column is x pixel location second column is y
%                          pixel location, and third  column is depth
%                          column is depth (n is number of points)
%          framesWithBall - frame numbers of the frames where a ball
%                           was found

% number of frames in the video
numFrames = size(depthVideo,4);

% frames to look at
frameRange = 1:numFrames;

% depth range to look at
minD = depthRange(1)*1000;
maxD = depthRange(2)*1000;

% pixel range to look in
xRange = 641-pixelRange(2):641-pixelRange(1); % limits [1,640]
yRange = pixelRange(3):pixelRange(4); % limits [1,480]


% range of object pixel size
pixelSizeMin = pixelSizeRange(1);
pixelSizeMax = pixelSizeRange(2);

% Initialize variables
centers  = [1 1 1];
fWithBall = 0;
count = 1;

speedSpread = [0 0 0 0];

for f = frameRange
    
    % array of data in pixelRange for one frame
    depth = depthVideo(min(yRange):max(yRange),min(xRange):max(xRange),:,f);
    
    % gets pixels where depth is in  depth range
    [y,x] = find(depth > minD & depth < maxD);
    
    % account for pixelRange
    actualX = x + min(xRange) - 1;
    actualY = y + min(yRange) - 1;
    % if # pixels found is in pixel size range
    
    if(size(x,1) > pixelSizeMin && size(x,1) < pixelSizeMax)
        xm = mean(actualX);
        ym = mean(actualY);
        dd = depth(round(mean(y)),round(mean(x)));
        centers(count,:) = [641-xm, ym,dd ];
        fWithBall(count) = f;
        
        
        % new calc for speed
        minX  = min(actualX);
        maxX = max(actualX);
        spread = maxX - minX;
        speedSpread(count,:) = [minX maxX dd spread];
        
        
        count = count + 1;
    end
    
end


% speed calculation based on largest spread of one point

% [q,sInd] = max(speedSpread(:,4));
% maxSpread = speedSpread(sInd,:);
% pp = kinect2World([maxSpread(1),0, maxSpread(3); maxSpread(2),0,maxSpread(3)]);
% pp = (pp(:,1)/1000); % m/s
% newSpeed = .00062*3600*(pp(2) - pp(1)) / (1/30) % m/s


pixelCenters = centers;

% set to -1 if none found
if(count == 1)
    framesWithBall = -1;
else
    framesWithBall = fWithBall;
end

end

