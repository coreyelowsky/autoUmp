function varargout = gui(varargin)


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_OpeningFcn, ...
    'gui_OutputFcn',  @gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)


% Choose default command line output for gui
handles.output = hObject;

handles.colorVideo = -1;
handles.depthVideo = -1;
handles.timeDataDepth = -1;
handles.metaData = -1;

handles.typeVideo = 1;
handles.videoLength = 1;
handles.actualFrameRate = -1;
handles.pixelCenters = -1;
handles.framesWithBall = -1;
handles.depthRange = [.5 1.5];
handles.ballSizeRange = [10 3000];
handles.kinectPos = [1 1 1];
handles.pixelRange = [1 640 1 480];
handles.batterHeight = [1 2];
handles.jointLoc = -1;
handles.batterFound = 0;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% Take Video Button
function takeVideo_Callback(hObject, eventdata, handles)

set(handles.videoReady,'String','Video is NOT READY');
[handles.colorVideo, handles.depthVideo,handles.timeDataDepth, handles.metaData] = takeVideo(handles.videoLength);
set(handles.videoReady,'String','Video is READY');

% track batter
[knees, letters, foundBatter, handles.jointLoc] = trackBatter(handles.metaData);
handles.batterFound = foundBatter;
if(foundBatter == 0)
    set(handles.bFoundText,'String','NO');
else
    handles.batterHeight(1) = handles.kinectPos(3) + knees;
    handles.batterHeight(2) = handles.kinectPos(3) + letters;
    set(handles.bFoundText,'String','YES');
end
set(handles.kh,'String',round(handles.batterHeight(1)*100)/100  );
set(handles.lh,'String',round(handles.batterHeight(2)*100)/100    );
guidata(hObject, handles);




% Play Video Button
function playVideo_Callback(hObject, eventdata, handles)

axes(handles.viewVideo);
cla;

if(handles.typeVideo == 1)
    if(handles.colorVideo ~= -1)
        playVideo(handles.colorVideo);
    end
else if(handles.typeVideo == 2)
        if(handles.depthVideo ~= -1)
            playVideo(handles.depthVideo);
        end
    end
end


% Find Ball Button
function trackBall_Callback(hObject, eventdata, handles)

[handles.pixelCenters, handles.framesWithBall] = findBall(handles.depthVideo, handles.depthRange, handles.ballSizeRange, handles.pixelRange);

if(handles.framesWithBall == -1)
    set(handles.framesFound,'String',0);
else
    set(handles.framesFound,'String', size(handles.framesWithBall,2));
end
guidata(hObject, handles);


% Plot 3D Button
function plot3D_Callback(hObject, eventdata, handles)
% if there is at least one frame
if(size(handles.framesWithBall,2) > 0)
    
    % convert to real world coordinated
    realWorldXYZ = kinect2World(handles.pixelCenters);
    
    % configure axies
    axes(handles.view3D);
    cla;
    rotate3d on;
    
    % strike or ball
    strike = plot3Dpath(realWorldXYZ,handles.kinectPos, handles.batterHeight);
    if(strike == 1)
        set(handles.strike,'String', 'STRIKE');
    else
        set(handles.strike,'String', 'BALL');
    end
    
    % calculate speed
    speed = calculateSpeed(handles.timeDataDepth, handles.framesWithBall,realWorldXYZ);
    set(handles.speed,'String', round(speed));
    
end


% Plot Path Video Button
function plotPathButton_Callback(hObject, eventdata, handles)

axes(handles.plotPathAxes);
cla;
pathVideo(handles.depthVideo, handles.pixelCenters, handles.framesWithBall, handles.pixelRange, handles.jointLoc);



% Load Data Button
function loadDataButton_Callback(hObject, eventdata, handles)

data = load(handles.dataFile);
handles.colorVideo = data.colorVideo;
handles.depthVideo = data.depthVideo;
handles.timeDataDepth = data.timeDataDepth;
handles.metaData = data.metaData;

% track batter
[knees, letters, foundBatter, handles.jointLoc] = trackBatter(handles.metaData);
handles.batterFound = foundBatter;
if(foundBatter == 0)
    set(handles.bFoundText,'String','NO');
else
    handles.batterHeight(1) = handles.kinectPos(3) + knees;
    handles.batterHeight(2) = handles.kinectPos(3) + letters;
    set(handles.bFoundText,'String','YES');
end
set(handles.kh,'String',round(handles.batterHeight(1)*100)/100);
set(handles.lh,'String',round(handles.batterHeight(2)*100)/100);
guidata(hObject, handles);



% Save Data Button
function save_Callback(hObject, eventdata, handles)

colorVideo = handles.colorVideo;
depthVideo = handles.depthVideo;
timeDataDepth = handles.timeDataDepth;
metaData = handles.metaData;
C = cell(1,4);
C(1,1) = java.lang.String('colorVideo');
C(1,2) = java.lang.String('depthVideo');
C(1,3) = java.lang.String('timeDataDepth');
C(1,4) = java.lang.String('metaData');
uisave(C)






% Set Video Length Dropdown
function setVideoLength_Callback(hObject, eventdata, handles)

handles.videoLength = get(hObject,'Value');
guidata(hObject, handles);


% Set Video Type DropDown
function videoType_Callback(hObject, eventdata, handles)

handles.typeVideo = get(hObject,'Value');
guidata(hObject, handles);


% Set Depth Min
function depthMin_Callback(hObject, eventdata, handles)

handles.depthRange(1) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Depth Max
function depthMax_Callback(hObject, eventdata, handles)

handles.depthRange(2) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Ball Size Min
function ballSizeMin_Callback(hObject, eventdata, handles)

handles.ballSizeRange(1) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Ball Size Max
function ballSizeMax_Callback(hObject, eventdata, handles)

handles.ballSizeRange(2) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Kinect X Position
function xPos_Callback(hObject, eventdata, handles)

handles.kinectPos(1) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Kinect Y Position
function yPos_Callback(hObject, eventdata, handles)

handles.kinectPos(2) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Kinect Z Position
function zPos_Callback(hObject, eventdata, handles)

handles.kinectPos(3) = str2double(get(hObject,'String'));
guidata(hObject, handles);

% Set Letter Height
function letterHeight_Callback(hObject, eventdata, handles)

handles.batterHeight(1) = str2double(get(hObject,'String'));
guidata(hObject, handles);

% Set Knee Height
function kneeHeight_Callback(hObject, eventdata, handles)

handles.batterHeight(2) = str2double(get(hObject,'String'));
guidata(hObject, handles);

% Load Data File Name
function loadDataText_Callback(hObject, eventdata, handles)

handles.dataFile = get(hObject,'String');
guidata(hObject, handles);

% Set Pixel X Min
function pixelMinX_Callback(hObject, eventdata, handles)

handles.pixelRange(1) = str2double(get(hObject,'String'));
guidata(hObject, handles);

% Set Pixel X Max
function pixelMaxX_Callback(hObject, eventdata, handles)

handles.pixelRange(2) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Pixel Y Min
function pixelMinY_Callback(hObject, eventdata, handles)

handles.pixelRange(3) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% Set Pixel Y Max
function pixelMaxY_Callback(hObject, eventdata, handles)

handles.pixelRange(4) = str2double(get(hObject,'String'));
guidata(hObject, handles);







% ----------- Non Essesntial -----------------------------------------

function setVideoLength_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function videoType_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function depthMin_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function depthMax_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ballSizeMin_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ballSizeMax_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xPos_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function yPos_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function zPos_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function letterHeight_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function kneeHeight_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function loadDataText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pixelMinX_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pixelMaxX_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pixelMinY_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pixelMaxY_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function save_ButtonDownFcn(hObject, eventdata, handles)
