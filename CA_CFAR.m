clear,clc,close all

img = VHF_read_image('D:\E\Arshad\term 2\Microwave Remote Sensing\Works\Prj\CARABAS_VFH_CP\images\v02_2_6_1.a.Fbp.RFcorr.Geo.Magn',2000,3000,1,2000,1,3000);

%% pre-processing
%% multi looking
img = imfilter(img,fspecial('average',[3,3]));

%% lee filter
lee_kernel_size = [3,3];
STD_img = std(img(:));

mean_kernel = imfilter(img,fspecial('average',lee_kernel_size));

m = (lee_kernel_size(1)-1)/2; n = (lee_kernel_size(2)-1)/2;
paded_img = padarray(img,[m,n],0,'both');
STD_kernel = zeros(size(img));
for i = m+1:size(paded_img,1)-m
    for j = n+1:size(paded_img,2)-n
        win = paded_img(i-m:i+m,j-n:j+n);
        STD_kernel(i-m,j-n) = std(win(:));
    end
end
W = STD_kernel./(STD_kernel+STD_img);
lee_filtered_img = img.*W + mean_kernel.*(1-W);

%% median filter
med_filtered_img = medfilt2(lee_filtered_img,[3,3]);
%% Processing
%% CA-CFAR
S = stencil([35,35],[15,15]);
Z = imfilter(med_filtered_img,S);
PFA = 7e-03;
N = sum(sum(S~=0));
alpha = N*((PFA^(-1/N))-1);

th = alpha*Z;
ca_CFAR = med_filtered_img>th;

ca_CFAR = imopen(ca_CFAR,strel('square',3));

figure,imshow(ca_CFAR),title('CA-CFAR')

%% SOCA-CFAR
S = stencil([35,35],[15,15]);
row_guard = sum(S == 0); row_guard = row_guard(row_guard ~= 0); row_guard = row_guard(1);
col_guard = sum(S == 0,2);col_guard = col_guard(col_guard ~= 0); col_guard = col_guard(1);

Sl = zeros(size(S)); Sr = zeros(size(S)); St = zeros(size(S)); Sb = zeros(size(S));

Sl(1:end,1:(size(S,2)-col_guard)/2) = 1; Sl = Sl/sum(Sl(:));
Zl = imfilter(med_filtered_img,Sl);

Sr(1:end,(size(S,2)-col_guard)/2+col_guard+1:end) = 1; Sr = Sr/sum(Sr(:));
Zr = imfilter(med_filtered_img,Sr);

St(1:(size(S,1)-row_guard)/2,1:end) = 1; St = St/sum(St(:));
Zt = imfilter(med_filtered_img,St);

Sb((size(S,1)-row_guard)/2+row_guard+1:end,1:end) = 1; Sb = Sb/sum(Sb(:));
Zb = imfilter(med_filtered_img,Sb);

Z_SOCA = min(min(Zl,Zr),min(Zt,Zb));
th_SOCA = alpha*Z_SOCA;
SOCA_CFAR = med_filtered_img>th_SOCA;

SOCA_CFAR = imopen(SOCA_CFAR,strel('square',3));

figure,imshow(SOCA_CFAR),title('SOCA-CFAR')

%% GOCA-CFAR
Z_GOCA = max(max(Zl,Zr),max(Zt,Zb));
th_GOCA = alpha*Z_GOCA;
GOCA_CFAR = med_filtered_img>th_GOCA;

GOCA_CFAR = imopen(GOCA_CFAR,strel('square',2));

figure,imshow(GOCA_CFAR),title('GOCA-CFAR')











