load test_data/data

% row 1 : pY
% row 2 : pZ
% row 3 : Y
% row 4 : Z
% row 5 : numFrames
% row 6 : kX
% row 7 : kY
% row 8 : kZ
% row 9 : error (m)


data(end,:) = 100*data(9,:); % convert errors to cm


averageHoriz = mean(abs(data(1,:) - data(3,:)))*100
averageVert = mean(abs(data(2,:) - data(4,:)))*100

p = polyfit(data(3,:) + data(7,:),data(9,:),1)

averageError = mean(data(9,:))

figure;

subplot(1,2,1)
plot(data(3,:) + data(7,:),data(9,:),'x')
xlabel('Distannce from Kinect (m) ')
ylabel('Error (cm)')
title('Error as a function of Distance from Kinect')

subplot(1,2,2)
plot(data(3,:) + data(7,:),data(5,:),'x')
xlabel('Distannce from Kinect (m) ')
ylabel('Number of Frames')
title('Number of Frames as a function of Distance from Kinect')