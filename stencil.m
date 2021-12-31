function S = stencil(totalsize,guardsize)

if length(totalsize) == 1
    totalsize = [totalsize,totalsize];
end
if length(guardsize) == 1
    guardsize = [guardsize,guardsize];
end

if (totalsize(1) <= guardsize(1)) || (totalsize(2) <= guardsize(2))
    error('total size of the Stencil must be greater than guard size!')
end
if length(totalsize) > 2 || length(guardsize) > 2
    error('input arguments must be 2-by-2 or scaler!')
end
if (rem(totalsize,2) == [0,0]) | (rem(guardsize,2) == [0,0])
    error('all sizes must be odd!')
end

S = ones(totalsize);
guard = ones(guardsize);

dr = size(S,1) - size(guard,1);
dc = size(S,2) - size(guard,2);

guard = padarray(guard,[dr/2,dc/2],0,'both');

S = S - guard;
S = S/sum(S(:));

end