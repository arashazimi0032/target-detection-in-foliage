function out = VHF_read_image(infile,N_cols,N_rows,col_start,col_end,row_start,row_end)

% out = VHF_read_image(infile,N_cols,N_rows,col_start,col_end,row_start,row_end)
%200
% Reads an image stored as IEEE floating point with big-endian byte ordering.  
% 
% infile    - File to read
% N_cols    - Number of columns of the image stored in the file
% N_rows    - Number of rows of the image stored in the file
% col_start - Start reading from this column
% col_end   - End reading at this column
% row_start - Start reading from this row
% row_end   - End reading at this row 
% out       - Output data matrix of size (row_end-row_start+1)x(col_end-col_start+1)
%
% Valid values for col_start/col_end [1 <= col_start <= col_end <= N_cols]
% Valid values for row_start/row_end [1 <= row_start <= row_end <= N_rows]

NC = col_end - col_start + 1;
NR = row_end - row_start + 1;

if NC > N_cols
    disp('WARNING in read_image: Number of columns to read exceeds maximum limit');
    disp('WARNING in read_image: Setting colums to read to equal the limit');
    NC = N_cols;
end
if NR > N_rows
    disp('WARNING in read_image: Number of rows to read exceeds maximum limit');
    disp('WARNING in read_image: Setting rows to read to equal the limit');
    NR = N_rows;
end

fid = fopen(infile,'r', 'ieee-be');

out=zeros(NC,NR);

col_start = col_start - 1;
col_end = col_end - 1;
row_start = row_start - 1;
row_end = row_end - 1;

for jj=0:NR-1,
    status=fseek(fid,(N_cols*(row_start+jj)+col_start)*4,-1);
    out(:,jj+1)=fread(fid,NC,'float');
end

out = out.';

status=fclose(fid);
