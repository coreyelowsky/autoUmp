function centersWorld = kinect2World(points)

% Transform pixel coordinates of kinect to real world coordinates
% Assumes Kinect is (0,0,0)
%
% Input : points -  nx3 matrix of ball center points where first
% Output: centersWorld - real world coordinates of points
%                        (0,0,0) is kinect
%
%                       y coordinate is the depth
%                       x coordinate is horizontal on the screen
%                       z coordinate is vertical on the screen
%
%   the (x, 0, 0) point is in the center

hFOV =  57; % degrees
vFOV = 43;  % degrees

hPixels = 640;
vPixels = 480;

xCentPix = hPixels/2;
yCentPix = vPixels/2;

centersWorld = zeros(1,3);

for i = 1:size(points,1)
    
    xPix = points(i, 1);
    yPix = points(i, 2);
    
    depth = points(i,3);
    
    % theta is the angle between y and x (counter clockwise horz)
    theta = (xPix - xCentPix) * hFOV / hPixels;
    
    % phi is the angle from x-y plane and z axis (vert)
    phi = (yCentPix - yPix) * vFOV / vPixels;
    
    x = tan(pi/180*theta) * depth;
    y = depth;
    z = tan(pi/180*phi) * depth;
    
    centersWorld(i, :) = [x, y, z];
    
end

end

