function ret=Conv_2R(S1,S2,Size,S1orS2,DimNum)
if S1orS2==1
    if DimNum==3
        [~,S1Size,Dim]=size(S1);
        [~,S2Size]=size(S2);
        if Size==0
            ret=zeros(S1Size+1-S2Size,S1Size+1-S2Size,Dim);
            for i=1:Dim
                ret(:,:,i)=conv2(S1(:,:,i),rot90(S2,2),'valid');
            end
            return
        end   
    end
end
if S1orS2==2
    if DimNum==3
        [~,S1Size]=size(S1);
        [~,S2Size,Dim]=size(S2);
        if Size==0
            ret=zeros(S1Size+1-S2Size,S1Size+1-S2Size,Dim);
            for i=1:Dim
                ret(:,:,i)=conv2(S1,rot90(S2(:,:,i),2),'valid');
            end
            return
        end
        if Size==2
            ret=zeros(S1Size+S2Size-1,S1Size+S2Size-1,Dim);
            for i=1:Dim
                ret(:,:,i)=conv2(S1,S2(:,:,i),'full');% 10 *10     3*3*12
            end
            return
        end
    end
end
end