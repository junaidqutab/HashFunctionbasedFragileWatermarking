clear all, close all, clc;

image = imread('lake.bmp'); % Read in the image 
[m, n, ~] = size(image);       % Gives rows, columns, ignores number of channels

% Starts by separating the image into RGB channels
message_R = image(:,:,1);      % Red channel
message_G = image(:,:,2);      % Green channel
message_B = image(:,:,3);      % Blue channel
flat_R = reshape(image(:,:,1)',[1 m*n]); % Reshapes Red channel matrix into a 1 by m*n uint8 array
flat_G = reshape(image(:,:,2)',[1 m*n]); % 
flat_B = reshape(image(:,:,3)',[1 m*n]); % 
flat_RGB = [flat_R, flat_G, flat_B];     % Concatenates all RGB vals, into one long 1 by 3*m*n array

string_RGB = num2str(flat_RGB);                         % Converts numeric matrices to a string
string_RGB = string_RGB(~isspace(num2str(string_RGB))); % Removes spaces - though this is not strictly necessary I think

% Perform hashing
sha256hasher = System.Security.Cryptography.SHA256Managed;           % Create hash object (?) - this part was copied from the forum post mentioned above, so no idea what it actually does
imageHash_uint8 = uint8(sha256hasher.ComputeHash(uint8(string_RGB))); % Find uint8 of hash, outputs as a 1x32 uint8 array
size(imageHash_uint8);
imageHash_uint8;
de2bi(imageHash_uint8);
sha256hasher = System.Security.Cryptography.SHA256Managed;  
x = [2,3,4];
uint8(sha256hasher.ComputeHash(uint8('12')));
bitset(x,1,1);

hash=uint8(sha256hasher.ComputeHash(uint8(num2str(i))))
hash = de2bi(hash)
size(hash(:))
sha256hasher = System.Security.Cryptography.SHA256Managed;  
% image = imread('boat512.bmp');
% size(image);
% r=size(image,1);
% c=size(image,2);
% d=size(image,3);
% out=zeros(r,c,d,'uint8');
% if d == 3
%     out(:,:,2)=image(:,:,2);
%     out(:,:,3)=image(:,:,3);
% end
% for i=1:32:size(image,1)
%     if i+31<=r
%         for j=1:32:c
%         x=image(i:i+15,j:j+15);
%         y=image(i:i+15,j+16:j+31);
%         z=image(i+16:i+31,j:j+15);
%         block=image(i+16:i+31,j+16:j+31);
%         three=[x(:),y(:),z(:)]; %Concatinating the 3 blocks
%         flatthree=three(:); %Flattenting the array
%         size(flatthree); 
%         tohash=num2str(flatthree); %Converting to string
%         tohash= tohash(~isspace(num2str(tohash)));%Removing space
%         size(tohash); 
%         hashed=uint8(sha256hasher.ComputeHash(uint8(tohash))); %Hashing
%         hashed;
%         binaryhash=de2bi(hashed); %Convert to binary
%         flattenbinary=binaryhash(:); %Flatten
%         count=1;
%         for a=1:16
%             for b=1:16
%             bitset(block(a,b),1,flattenbinary(count)); %Setting LSBs
%             count=count+1;
%             end
%         end
%         out(i:i+15,j:j+15)=x;
%         out(i:i+15,j+16:j+31)=y;
%         out(i+16:i+31,j:j+15)=z;
%         out(i+16:i+31,j+16:j+31)=block;
%         end
%     end
% end
% a=[];
% z=[2,1,3,4];
% y=[1,2,4,3];
% for i =1:4
% x=uint8(sha256hasher.ComputeHash(uint8(num2str(i))));
% binaryhash=de2bi(y);
% flattenbinary=binaryhash(:);
% flattenbinary(1:4)
% z(i)=bitset(z(i),1,flattenbinary(i))
% end
% bitget(z,1)
% 
% de2bi(4);
% b=bitget(4,1);   
% 
% for i=1:32:size(image,1)
%     
%     if i+31<=r
%         for j=1:32:c
%         x=image(i:i+15,j:j+15);
%         fir=i:i+15;
%         fir2=j:j+15;
%         sec=i:i+15;
%         sec2=j+16:j+31;
%         th=i+16:i+31;
%         th2=j:j+15;
%         fr=i+16:i+31;
%         fr2=j+16:j+31;
%         y=image(i:i+15,j+16:j+31);
%         z=image(i+16:i+31,j:j+15);
%         block=image(i+16:i+31,j+16:j+31);
%         size(x);
%         subplot(2,3,1);
%         imshow(x);
%         size(y);
%         subplot(2,3,2);
%         imshow(y);
%         subplot(2,3,3);
%         size(z);
%         imshow(z);
%         subplot(2,3,4);
%         imshow(image);
%         subplot(2,3,5);
%         size(block);
%         imshow(block);
%         three=[x(:),y(:),z(:)]; %Concatinating the 3 blocks
%         flatthree=three(:); %Flattenting the array
%         size(flatthree) 
%         tohash=num2str(flatthree); %Converting to string
%         tohash= tohash(~isspace(num2str(tohash)));%Removing space
%         size(tohash); 
%         hashed=uint8(sha256hasher.ComputeHash(uint8(tohash))); %Hashing
%         binaryhash=de2bi(hashed) %Convert to binary
%         flattenbinary=binaryhash(:) %Flatten
%         count=1;
%         for a=1:16
%             for b=1:16
%             bitset(block(a,b),1,flattenbinary(count)) %Setting LSBs
%             block(a,b);
%             count=count+1;
%             end
%         end
%         end
%     end
% end


%imageHash_hex = dec2hex(imageHash_uint8) % Convert uint8 to hex, if necessary. This step is optional depending on your application.
