function ret=PoolingR(S)
Pooling_idx=2;
[x,~,z]=size(S);
ret=zeros(Pooling_idx*x,Pooling_idx*x,z);
Temp=S/(Pooling_idx*Pooling_idx);
ret(1:2:end,1:2:end,:)=Temp;
ret(1:2:end,2:2:end,:)=Temp;
ret(2:2:end,1:2:end,:)=Temp;
ret(2:2:end,2:2:end,:)=Temp;
end