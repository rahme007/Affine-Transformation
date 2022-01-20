close all;
im1 = imread('walkway4_snipped.jpg');
im2 = imread('ladder_5_crop.jpg');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
%% Projection on walkway
im1 = imresize(im1, [600 600]);
im2 = imresize(im2,[600 300]);
im2 = padarray(im2,[0 105],0,'pre');
im3 = imfuse(im1,im2);
figure,imshow(im3)
set(gca,'Visible','on');

%% Perspective transformation
theta = 0;
tm = [cosd(theta) -sind(theta) 0.001; ...
    sind(theta) cosd(theta) 0.01; ...
    0 0 1];
tform_p =  projective2d(tm); %using affin2d transformation
pers = imwarp(im2,tform_p);
im_r = imresize(im1,size(pers));
pers = flip(pers);
%pers = padarray(pers,[400 305],0,'pre');
im_pers = imfuse(im_r,pers);
figure,imshow(im_pers)
%% Image Translation

%im2_tr = imtranslate(im2,[25 25],'OutputView','full');

%% Image Rotation (affine transformation) by 45 degree
% theta_x = pi/4;
% rot_matX = [ cos(theta_x) sin(theta_x) 0;
%     -sin(theta_x) cos(theta_x) 0; 0 0 1];
% t_formX = affine2d(rot_matX);
% im2_rot = imwarp(im2,t_formX);
% im4 = imfuse(im1,im2_rot);
% figure,imshow(im4)



%image padding

[Rows, Cols] = size(pers); 
Diagonal = sqrt(Rows^2 + Cols^2); 
RowPad = ceil(Diagonal - Rows) + 2;
ColPad = ceil(Diagonal - Cols) + 2;
imagepad = zeros(Rows+RowPad, Cols+ColPad);
imagepad(ceil(RowPad/2):(ceil(RowPad/2)+Rows-1),ceil(ColPad/2):(ceil(ColPad/2)+Cols-1)) = pers;

degree=45;

%midpoints
midx=ceil((size(imagepad,1)+1)/2);
midy=ceil((size(imagepad,2)+1)/2);

imagerot=zeros(size(imagepad));

%rotation
for i=1:size(imagepad,1)
    for j=1:size(imagepad,2)

         x=(i-midx)*cos(degree)-(j-midy)*sin(degree);
         y=(i-midx)*sin(degree)+(j-midy)*cos(degree);
         x=round(x)+midx;
         y=round(y)+midy;

         if (x>=1 && y>=1 && x<=size(imagepad,2) && y<=size(imagepad,1))
              imagerot(x,y)=imagepad(i,j); % k degrees rotated image         
         end

    end
end

 figure,imagesc(imagerot);
 colormap(gray(256));
 imagerot = imresize(imagerot,size(pers));
 figure,imshow(imfuse(im_r,imagerot))

%% Reflection
pers_angle = imrotate(pers,10);
pers1 = fliplr(pers_angle);
pers_r = [pers1 pers_angle];
pers_r = imresize(pers_r,size(im_r));
figure,imshow(pers_r)

im_ref = imfuse(im_r,pers_r);
figure,imshow(im_ref)



