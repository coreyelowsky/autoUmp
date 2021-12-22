clear all; close all; clc; imaqreset;

figure('Name', 'Live Stream');
uicontrol('String', 'Close', 'Callback', 'close(gcf)');

colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);

colorVidRes = get(colorVid, 'VideoResolution');
depthVidRes = get(depthVid, 'VideoResolution');
colorNBands = get(colorVid, 'NumberOfBands');
depthNBands = get(depthVid, 'NumberOfBands');

colorImage = image( zeros(colorVidRes(2), colorVidRes(1), colorNBands) );
depthImage = image( zeros(depthVidRes(2), depthVidRes(1), depthNBands) );

preview(colorVid, colorImage);
preview(depthVid, depthImage);

% http://www.mathworks.com/help/imaq/previewing-data.html#f11-68980