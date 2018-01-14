%................................................................
% MATLAB codes for Finite Element Analysis
% problem9.m
% antonio ferreira 2008
% clear memory
clear all
% E; modulus of elasticity
% I: second moment of area
% L: length of bar
E=1; I=1; EI=E*I;
% generation of coordinates and connectivities
numberElements=5;
nodeCoordinates=linspace(0,1,numberElements+1)';
xx=nodeCoordinates;L=max(nodeCoordinates);
numberNodes=size(nodeCoordinates,1);
xx=nodeCoordinates(:,1);
for i=1:numberElements;
    elementNodes(i,1)=i;
    elementNodes(i,2)=i+1;
end
% distributed load
P=-1;
% for structure:
    % displacements: displacement vector
    % force : force vector
    % stiffness: stiffness matrix
    % GDof: global number of degrees of freedom
GDof=2*numberNodes;
U=zeros(GDof,1);
% stiffess matrix and force vector
[stiffness,force]=...
    formStiffnessBernoulliBeam(GDof,numberElements,...
    elementNodes,numberNodes,xx,EI,P);
% boundary conditions and solution
% clamped-clamped
%fixedNodeU =[1 2*numberElements+1]’;
%fixedNodeV =[2 2*numberElements+2]’;
% simply supported-simply supported
% fixedNodeU =[1 2*numberElements+1]'; fixedNodeV =[]';
% clamped at x=0
fixedNodeU =[1]'; fixedNodeV =[2]';

prescribedDof=[fixedNodeU;fixedNodeV];
% solution
displacements=solution(GDof,prescribedDof,stiffness,force);
% output displacements/reactions
outputDisplacementsReactions(displacements,stiffness,...
    GDof,prescribedDof)
% drawing deformed shape
U=displacements(1:2:2*numberNodes);
plot(nodeCoordinates,U,'.')


%--------------------
% Organise stiffness matrix into other form
nels = length(stiffness);
stiffness2 = zeros(size(stiffness));
for i = 1:nels
    for j = 1:nels
        if mod(i,2) == 1;rw = (i+1)/2;else rw=nels/2+(i/2);end
        if mod(j,2) == 1;cl = (j+1)/2;else cl=nels/2+(j/2);end
        
        stiffness2(rw,cl) = stiffness(i,j);
    end
end
% Remove rows that are zero for a cantileverd beam
stiffness2(1,:) = [];
stiffness2(:,1) = [];
stiffness2(nels/2,:) = [];
stiffness2(:,nels/2) = [];
