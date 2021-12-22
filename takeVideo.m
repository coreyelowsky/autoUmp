function [colorVideo, depthVideo, timeDataDepth, metaDataDepth] = takeVideo(s)

%
% Takes Kinect video for specified amount of seconds
%
% Input : s (seconds to record video)
% Output : colorVideo
%          depthVideo
%          timeDataDepth
%          metaDataDepth

imaqreset;

framesPerSecond = 30;
framesPerTrigger = framesPerSecond*s;

colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);

flushdata(colorVid);
flushdata(depthVid);

triggerconfig([colorVid depthVid],'manual');

set([colorVid depthVid], 'FramesPerTrigger', framesPerTrigger,'TriggerRepeat',1000000000);

colorVid.FramesPerTrigger = framesPerTrigger;
depthVid.FramesPerTrigger = framesPerTrigger;

%skeletal
depthSrc = getselectedsource(depthVid);
depthSrc.TrackingMode = 'Skeleton';

start([colorVid depthVid]);

trigger([colorVid depthVid]);
colorVideo = getdata(colorVid);

[depthVideo, timeDataDepth, metaDataDepth] = getdata(depthVid);

% Clean up
stop([colorVid depthVid]);
stop(depthVid);
delete(colorVid);
delete(depthVid);
clear colorVid;
clear depthVid;

end

