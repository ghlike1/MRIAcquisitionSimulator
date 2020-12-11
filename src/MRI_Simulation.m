function varargout = MRI_Simulation(varargin)
gui_Singleton = 1;
gui = struct('gui_Name',       mfilename, ...
             'gui_Singleton',  gui_Singleton, ...
             'gui_OpeningFcn', @MRI_Simulation_OpeningFcn, ...
             'gui_OutputFcn',  @MRI_Simulation_OutputFcn, ...
             'gui_LayoutFcn',  [] , ...
             'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui, varargin{:});
else
    gui_mainfcn(gui, varargin{:});
end

function MRI_Simulation_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set(handles.lines, 'Value', 3);
set(handles.points, 'Value', 3); 
guidata(hObject, handles);

function varargout = MRI_Simulation_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function pickPhantom_Callback(~, ~, handles)
opt = get(handles.pickPhantom, 'Value');
axes(handles.phantomAxes);
switch opt
    case 1
        clearAxes(handles)
    case 2
        imshow('../data/phantom_type1.png');
    case 3
        imshow('../data/phantom_type2.png');
    case 4
        imshow('../data/phatom_type3.jpeg');
    case 5
        [file, path, ~] = uigetfile({'*.png;*.jpg;*.jpeg;*.JPG;*.JPEG'});
        if ischar(file) && ischar(path)
            imdata = imread(strcat(path, file));
            if size(imdata, 3) == 3
                imdata = rgb2gray(imdata);
            end
            imdata = imresize(imdata, [3840,3840]);
            imshow(imdata);
        else
            clearAxes(handles)
        end
end

function pickPhantom_CreateFcn(hObject, ~, ~)
if ismac && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function run_Callback(~, ~, handles)
trajectory = get(handles.pickTrajectory, 'Value');

if(isempty(get(handles.phantomAxes, 'Children')))
    return;
end

lines = 2^(get(handles.lines, 'Value') + 3);
points = 2^(get(handles.points, 'Value') + 3);
maskPercent = get(handles.slider1, 'Value');
maskType = get(handles.popupmenu6, 'Value');

switch trajectory
    case 1
        return;
    case 2
        [MRI, mask] = MRI_Cartesian(getimage(handles.phantomAxes), lines, points, maskType - 2, maskPercent, invert);
        axes(handles.axes16);
        imshow(mask);
    case 3
        [MRI, mask] = MRI_Radial(getimage(handles.phantomAxes), lines, points, maskType - 2, maskPercent, invert);
        axes(handles.axes16);
        imshow(mask);

end

axes(handles.MRIAxes);
imshow(MRI, [0, max(MRI(:))]);

compareImg = abs(double(getimage(handles.phantomAxes)) - double(MRI)); 
axes(handles.diffAxes); 
imshow(compareImg, [0 max(compareImg(:))]);

function pickTrajectory_Callback(~, ~, handles)
opt = get(handles.pickTrajectory, 'Value');
axes(handles.trajectoryAxes);
switch opt
    case 1
        cla;
    case 2
        imshow('../data/cartesian.png');
    case 3
        imshow('../data/radial.png');
end

function pickTrajectory_CreateFcn(hObject, ~, ~)
if ismac && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clearAxes(handles)
    axes(handles.phantomAxes); cla;
    axes(handles.MRIAxes); cla;
    axes(handles.diffAxes); cla;

function linesText_Callback(hObject, ~, handles)
val = get(hObject, 'String');
if isempty(str2double(val))
    set(hObject, 'String', handles.trajInfo.num_lines);
else
    handles.trajInfo.num_lines = str2double(val);
    guidata(hObject, handles);
end

function linesText_CreateFcn(hObject, ~, ~)
if ismac && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pointsText_Callback(hObject, ~, handles)
val = get(hObject, 'String');
if isempty(str2double(val))
    set(hObject, 'String', handles.trajInfo.num_points_per_line);
else
    handles.trajInfo.num_points_per_line = str2double(val);
    guidata(hObject, handles);
end

function pointsText_CreateFcn(hObject, ~, ~)
if ismac && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lines_Callback(~, ~, ~)

function lines_CreateFcn(hObject, ~, ~)
if ismac && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function points_Callback(~, ~, ~)

function points_CreateFcn(hObject, ~, ~)
if ismac && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu6_Callback(~, ~, ~)

function popupmenu6_CreateFcn(hObject, ~, ~)
if ismac && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider1_Callback(~, ~, ~)

function slider1_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function radiobutton3_Callback(~, ~, ~)
