function strike =  plot3Dpath(centers, kinectPosition, sZoneHeight)

% Input: centers (n x 3) and is in mm
%        kinectPosition: all positive values in meters
% plots trajectory of baseball
% all values plotted in feet

% x is horiz
% y is depth
% z is vert

closeX = 17/12; % front of home plate
strike = 0;

% distances in meters that kinect is from (0,0,0) apex of home plate

% centers is in mm so convert to feet
centers = (centers/1000)*3.28084;

% converts from meters to feet
kinectX = kinectPosition(1)*3.28084;
kinectY = kinectPosition(2)*3.28084;
kinectZ = kinectPosition(3)*3.28084;

% converts from meters to feet
kh = sZoneHeight(1)*3.28084;
lh = sZoneHeight(2)*3.28084;

% home plate (values in vectors are inches, divide by 12 for feet)
plateX = [0 8.5  17 17 8.5 0]./12;
plateY = [0 -8.5 -8.5 8.5 8.5 0]./12;
plateZ = [0 0 0 0 0 0]./12;

% plot plate
fill3(plateX, plateY, plateZ, 'Black')
hold on

% plot 3d strike zone
a = fill3([8.5 17 17 8.5 8.5]/12,-8.5*ones(5,1)/12,[kh kh lh lh kh],'Green');
set(a,'FaceAlpha',0.5);
a = fill3([8.5 17 17 8.5 8.5]/12,8.5*ones(5,1)/12,[kh kh lh lh kh],'Green');
set(a,'FaceAlpha',0.5);
a = fill3([0 8.5 8.5 0 0]/12,[0 -8.5 -8.5 0 0]/12,[kh kh lh lh kh],'Green');
set(a,'FaceAlpha',0.5);
a = fill3([0 8.5 8.5 0 0]/12,[0 8.5 8.5 0 0]/12,[kh kh lh lh kh],'Green');
set(a,'FaceAlpha',0.5);
a = fill3(17*ones(5,1)/12,[8.5 -8.5 -8.5 8.5 8.5]/12,[kh kh lh lh kh],'Green');
set(a,'FaceAlpha',0.5);
a = fill3([0 8.5  17 17 8.5 0]./12,[0 -8.5 -8.5 8.5 8.5 0]./12,kh*ones(6,1),'Green');
set(a,'FaceAlpha',0.5);
a = fill3([0 8.5  17 17 8.5 0]./12,[0 -8.5 -8.5 8.5 8.5 0]./12,lh*ones(6,1),'Green');
set(a,'FaceAlpha',0.5);

centerX = centers(:,1) + kinectX;
centerY = centers(:,2) - kinectY;
centerZ = centers(:,3) + kinectZ;

% Plots all of the baseballs given the center positions
for i =1:length(centerX)
    
    r=2.94/2/12;
    phi=linspace(0,pi,30);
    theta=linspace(0,2*pi,40);
    [phi,theta]=meshgrid(phi,theta);
    
    x=r*sin(phi).*cos(theta);
    y=r*sin(phi).*sin(theta);
    z=r*cos(phi);
    m = surf(x + centerX(i),y + centerY(i),z + centerZ(i));
    set(m,'FaceColor','Black','FaceAlpha',0.5);
end

% Extrapolate path

if(size(centerX,1) > 1)
    
    % center of the baseball's last detected position
    extrapX = centerX(end,:);
    extrapY = centerY(end,:);
    extrapZ = centerZ(end,:);
    
    % estimated trajectory of the ball at the last known position
    diffX = centerX(end,:) - centerX(end-1,:);
    diffY = centerY(end,:) - centerY(end-1,:);
    diffZ = centerZ(end,:) - centerZ(end-1,:);
    
    i = 1;
    while(extrapX(i) > -2)
        i = i+1;
        % predicts the remaining path of the ball using a linear estimation
        % based off the final trajectory
        extrapX(i) = diffX + extrapX(i-1);
        extrapY(i) = diffY + extrapY(i-1);
        extrapZ(i) = diffZ + extrapZ(i-1);
      
    end
    plot3(extrapX,extrapY,extrapZ, '-b');
end

% creates more points inbetween extrapolated points
extrapLine = 0;
n = 1000;
for i = 1:size(extrapX,2) -1
    ex = linspace(extrapX(i), extrapX(i+1),n)';
    ey = linspace(extrapY(i), extrapY(i+1),n)';
    ez = linspace(extrapZ(i), extrapZ(i+1),n)';
    e = [ex ey ez];
    if( i == 1)
        extrapLine = e;
    else
        extrapLine = vertcat(extrapLine, e);
    end
end


% get position for testing
a = find(extrapLine(:,1) > closeX)
xyz = extrapLine(a(end),:)./3.2804;
yz = xyz(2:3)

% decide if strike or not
radius = 2.94/2/12;
xTopPlate = (sqrt(144 - 8.5*8.5) + 8.5)/12;
for i = 1:size(extrapLine,1)
    x = extrapLine(i,1);
    y = extrapLine(i,2);
    z = extrapLine(i,3);
    if( x - radius <= xTopPlate && x + radius >= 0 )
        if(z - radius <= lh && z + radius >= kh)
            if(y + radius >= -8.5/12 && y - radius <= 8.5/12)
                strike = 1;
                break;
            end
        end
    end
end

% Connect balls with dotted line
plot3(centerX,centerY,centerZ, '--');
axis([-5 10 -20 20 0 10])
grid on

end

