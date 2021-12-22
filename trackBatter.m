function [knees, letters, foundBatter, jointLoc] = trackBatter(metaDataDepth)

% gets knees and letters height in meters relative to kinext position

% input : metaData
% output : knees (meters)
%        : letters (meters)
%        : foundBatter == 1 if at least one skeleton tracked
%        : jointLoc (pixel location of the 2 joints


% indices of desired joints
Shoulder_Center = 3;
Knee_Left = 14;


% initialize
knees = 0;
letters = 0;
foundBatter = 0;
jointLoc = -1;

% iterate through all the frames
for i=1 : size(metaDataDepth,1)
    
    anySkeletonsTracked = any(metaDataDepth(i).IsSkeletonTracked ~= 0);
    
    % if a skeleton was tracked
    if(anySkeletonsTracked >= 1)
        foundBatter = 1;
        jointCoordinates = metaDataDepth(i).JointWorldCoordinates(:, :, 1);
        jointIndices = metaDataDepth(i).JointImageIndices(:, :, 1);
        
        jointLoc(1) = jointIndices(Knee_Left,1);
        jointLoc(2) = jointIndices(Knee_Left,2);
        jointLoc(3) = jointIndices(Shoulder_Center,1);
        jointLoc(4) = jointIndices(Shoulder_Center,2);
       
        knees = jointCoordinates(Knee_Left,2);
        letters = jointCoordinates(Shoulder_Center,2) - .2; % subtract .15 meters for letters
        break
    end
    
end





