function [bn, incidenceAngle] = getNormalBaseline(posP, posM, posS)
%GETNORMALBASELINE Summary of this function goes here
%   Detailed explanation goes here
% function [ vet_B ] = get_baseline_np( posP, posM, posS, Sgn )
% Compute the vector of baselines (normal and parallel) given:
%   posP [3,N]:   position vector of the target
%   posM [3,N]:   position vector of the master satellite when acquires the
%   baseline
%   posS [3,N]:   position vector of the slave satellite when acquires the
%
% posP = convertPositionFormat(posP);
% posM = convertPositionFormat(posM);
% posS = convertPositionFormat(posS);

N = size(posP,2);
if size(posM,1) ~= 3 || size(posS,1) ~= 3 || size(posP,1) ~= 3
    error('Wrong size(s) for state vectors, should be [3,N]')
end
if size(posM,2) ~= N || size(posS,2) ~= N
    error('State vectors of different sizes')
end

% compute the master range versor(s)
u1 = posP-posM;
u1norm = sqrt(u1(1,:).^2+u1(2,:).^2+u1(3,:).^2);
u1=u1./(ones(3,1)*u1norm); % along slant range
clear u1norm;
% compute the baseline vector(s)
vb = posS-posM;

% parallel baseline(s) is projection on the range versor
bp = sum(vb.*u1,1);

% normal basline(s)
bnv = vb - u1.*(ones(3,1)*bp);
bp = 0;
bnv = single(bnv);
bn = sqrt(bnv(1,:).^2+bnv(2,:).^2+bnv(3,:).^2);
% handle the sign
nsp = single(posS-posP);
nmp = single(posM-posP);
n1 = sqrt(nsp(1,:).^2+nsp(2,:).^2+nsp(3,:).^2);
n2 = sqrt(nmp(1,:).^2+nmp(2,:).^2+nmp(3,:).^2);
indm = n1 < n2;
bn(indm) = -bn(indm);

bn = bn';

%CosTheta = dot(u,v)/(norm(u)*norm(v));

%incidenceAngle = zeros(N,1,'single');   % Range, Theta elevation, Heading north
%disp(['Computing 3D sat location for ' num2str(Nl) ' grid points.'])
clear bnv bp indm N n1 n2 nmp nsp posM posS vb
CosTheta = dot(-u1,posP)./(vecnorm(posP).*vecnorm(-u1));
incidenceAngle = acosd(CosTheta);
% 
% parfor ip=1:N
%     u = posP(:,ip);
%     v = -u1(:,ip);
%     CosTheta = dot(v,u)/(norm(u)*norm(v));
%     incidenceAngle(ip) = acosd(CosTheta);
%    % S_ecef = posM(:,ip);
%     %P_ecef = img_ecef(ip,:)';
%     %  [lat, lon, h] = xyz2llh(P_ecef(1),P_ecef(2),P_ecef(3));
%     %S_ecef = Sat_zdM(:,ip);    
%     % Project Satellite center in earth tangent reference: East North Up
%     %SPue = ecef2enu(S_ecef,P_ecef);
%     %RS = norm(SPue,2);           % distance
%     %Spp = norm(SPue(1:2,1),2);      % projection in xy
%     %RS(ip) = atan2(SPue(3),Spp)/pi*180;        % elevation over horizon
%     %RS(3,ip) = rem(atan2(SPue(1),SPue(2))/pi*180-90,360);
% end

%incidenceAngle = 180-incidenceAngle;

end

