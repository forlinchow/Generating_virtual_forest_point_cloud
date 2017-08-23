function Pr=rot3d(P,origin,dirct,theta)
% 将坐标点P绕着，过origin点，方向为dirct的直线，旋转theta角
% P：需要旋转的做标集合，n×3矩阵
% origin：转轴通过的点，1×3向量
% direct：转轴方向向量，1×3向量
% theta：旋转角度，单位弧度
%
% By LaterComer of MATLAB技术论坛
% See also http://www.matlabsky.com
% Contact me matlabsky@gmail.com
% Modifid at 2011-07-26 19:51:32

dirct=dirct(:)/norm(dirct);

A_hat=dirct*dirct';

A_star=[0,         -dirct(3),      dirct(2)
        dirct(3),          0,     -dirct(1)
       -dirct(2),   dirct(1),            0];
I=eye(3);
M=A_hat+cos(theta)*(I-A_hat)+sin(theta)*A_star;
origin=repmat(origin(:)',size(P,1),1);
Pr=(P-origin)*M'+origin;