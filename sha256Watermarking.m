
%% 19L-1841 19L-2413

function varargout = sha256Watermarking(varargin)
% SHA256WATERMARKING MATLAB code for sha256Watermarking.fig
%      SHA256WATERMARKING, by itself, creates a new SHA256WATERMARKING or raises the existing
%      singleton*.
%
%      H = SHA256WATERMARKING returns the handle to a new SHA256WATERMARKING or the handle to
%      the existing singleton*.
%
%      SHA256WATERMARKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHA256WATERMARKING.M with the given input arguments.
%
%      SHA256WATERMARKING('Property','Value',...) creates a new SHA256WATERMARKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sha256Watermarking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sha256Watermarking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sha256Watermarking

% Last Modified by GUIDE v2.5 23-May-2022 17:31:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sha256Watermarking_OpeningFcn, ...
                   'gui_OutputFcn',  @sha256Watermarking_OutputFcn, ...
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


% --- Executes just before sha256Watermarking is made visible.
function sha256Watermarking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sha256Watermarking (see VARARGIN)

% Choose default command line output for sha256Watermarking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sha256Watermarking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sha256Watermarking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% LOAD IMAGE
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] =uigetfile('*.jpg;*.bmp;*','');
image = imread([path filename]);
axes(handles.axes1);
imshow(image);
guidata(hObject,handles);

%% HASH AND SAVE WITH WATERMARK
% --- Executes on button press in Hash.
function Hash_Callback(hObject, eventdata, handles)
% hObject    handle to Hash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=getimage(handles.axes1); %% Loading image
sha256hasher = System.Security.Cryptography.SHA256Managed; %% Hasher built into .net framework for windows
size(image);
image=uint8(image); %Convert to uint8 in case it isnt
r=size(image,1);
c=size(image,2);
d=size(image,3);
out=zeros(r,c,d,'uint8');
if d == 3 %If depth - 3, keep the 2 and 3 channel same
    out(:,:,2)=image(:,:,2);
    out(:,:,3)=image(:,:,3);
end
for i=1:32:size(image,1) %%Only alter channel 1
    if i+31<=r
        for j=1:32:c %Divide into 32x32
        x=image(i:i+15,j:j+15);  %First 16x16 block
        y=image(i:i+15,j+16:j+31); %Second 16x16 block
        z=image(i+16:i+31,j:j+15); %Third 16x16 block
        block=image(i+16:i+31,j+16:j+31); %Fourth 16x16 block
        three=[x(:),y(:),z(:)]; %Concatinating the 3 blocks
        flatthree=three(:); %Flattenting the array  
        size(flatthree);  
        tohash=num2str(flatthree); %Converting to string
        tohash= tohash(~isspace(num2str(tohash)));%Removing space
        size(tohash); 
        hashed=uint8(sha256hasher.ComputeHash(uint8(tohash))); %Hashing
        hashed;
        binaryhash=de2bi(hashed); %Convert to binary
        flattenbinary=binaryhash(:); %Flatten
        count=1;
        for a=1:16 %Alter the LSB of the fourth block
            for b=1:16
            block(a,b)=bitset(block(a,b),1,flattenbinary(count)); %Setting LSBs
            count=count+1;
            end
        end
        out(i:i+15,j:j+15)=x; %Save the image on the buffer
        out(i:i+15,j+16:j+31)=y;
        out(i+16:i+31,j:j+15)=z;
        out(i+16:i+31,j+16:j+31)=block;
        end
    end
end
axes(handles.axes2);
imshow(out);
imsave(handles.axes2);
guidata(hObject,handles);

%% Loading test image
% --- Executes on button press in loadtest.
function loadtest_Callback(hObject, eventdata, handles)
% hObject    handle to loadtest (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
[filename,path] =uigetfile('*.jpg;*.bmp;*','');
image = imread([path filename]);
axes(handles.Testimage);
imshow(image);
guidata(hObject,handles);

%% Ignore this function, not used now
% --- Executes on button press in groundtruth.
image = imread([path filename]);

%% Testing the watermark
% --- Executes on button press in Verify.
function Verify_Callback(hObject, eventdata, handles)
% hObject    handle to Verify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'string',' ');
test=getimage(handles.Testimage);
test=uint8(test);

sha256hasher = System.Security.Cryptography.SHA256Managed;
size(test);
r=size(test,1);
c=size(test,2);
d=size(test,3);
flag=1;
out = test;
for i=1:32:r 
    if i+31<=r
        for j=1:32:c
        extracted=[];
        x=test(i:i+15,j:j+15);
        y=test(i:i+15,j+16:j+31);
        z=test(i+16:i+31,j:j+15);
        block=test(i+16:i+31,j+16:j+31);
        three=[x(:),y(:),z(:)]; %Concatinating the 3 blocks
        flatthree=three(:); %Flattenting the array
        size(flatthree); 
        tohash=num2str(flatthree); %Converting to string
        tohash= tohash(~isspace(num2str(tohash)));%Removing space
        size(tohash); 
        hashed=uint8(sha256hasher.ComputeHash(uint8(tohash))); %Hashing
        hashed;
        binaryhash=de2bi(hashed); %Convert to binary
        flattenbinary=binaryhash(:).'; %Flatten
        for a=1:16
            for b=1:16
            extracted=[extracted,bitget(block(a,b),1)]; %getting LSBs
            end
        end
        size(flattenbinary);
        size(extracted);
        if isequal(flattenbinary,extracted)==0 %Compare hashed value to the one stored in LSB
            flag=0;
        out(i:i+15,j:j+15)=0; %If not matched, set that block equal to 0 --> Black
        out(i:i+15,j+16:j+31)=0;
        out(i+16:i+31,j:j+15)=0;
        out(i+16:i+31,j+16:j+31)=0;
        if d==3 %If colored image, set the other channels to 0 too
        out(i:i+15,j:j+15,2)=0;
        out(i:i+15,j+16:j+31,2)=0;
        out(i+16:i+31,j:j+15,2)=0;
        out(i+16:i+31,j+16:j+31,2)=0;
        out(i:i+15,j:j+15,3)=0;
        out(i:i+15,j+16:j+31,3)=0;
        out(i+16:i+31,j:j+15,3)=0;
        out(i+16:i+31,j+16:j+31,3)=0;
        end
        end
        end
    end
end
flag %Flag if image is tampered or not
if flag==1
set(handles.text2,'string','Equal'); 
else
set(handles.text2,'string','Tampered');
end
axes(handles.axes5);
imshow(out);
guidata(hObject,handles);

%% Loading image to alter
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] =uigetfile('*.jpg;*.bmp;*','');
image = imread([path filename]);
axes(handles.axes6);
imshow(image);
guidata(hObject,handles);

%% Altering the image
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'string',' '); %Get max blocks to alter
test=getimage(handles.axes6);
test=uint8(test);
size(test);
r=size(test,1);
c=size(test,2);
d=size(test,3);
max=get(handles.edit1,'string');
if isempty(max)
    max=10;
else
    max=str2double(max);
end
out = test; %Setting new image equal to old so we can just change the required blocks
count=0;
blockno=1;
for i=1:32:r
    if i+31<=r
        for j=1:32:c
        block=test(i+16:i+31,j+16:j+31); %Fourth 16x16 block
        if rem(blockno,4)==0 && count<=max %If our block number is divisble by 4 and we have not reached max blocks to alter
        for w=1:16
            for z=1:16
            block(w,z)=bitset(block(w,z),1,0); %Alter LSB , set to 0
            end
        end
        out(i+16:i+31,j+16:j+31)=block; %Store in buffer
        count=count+1  %Number of blocks altered
        
        end
        blockno=blockno+1; %Block number
        end
        end
    end


axes(handles.axes7);
imshow(out);
imsave(handles.axes7); %Save altered image
guidata(hObject,handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
