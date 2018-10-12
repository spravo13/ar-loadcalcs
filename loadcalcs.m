clear all, close all, clc

% components of vectors describing the directions of the suspension members
% and therefore the direction of the resultant forces

% each component should be an nx3 matrix where n is typically 1, but can be
% any number if multiple measurments are taken

% Tie Rod
TR = [];
% Lower Control Arm, Front
LCAF = [];
% Lower Control Arm, Rear
LCAR = [];
% Upper Control Arm, Front
UCAF = [];
% Upper Control Arm, Rear
UCAR = [];
% Push Rod
PR = [];

%TR = [1,1,1; 10, 10, 10]
%LCAF = [2,2,2]
%LCAR = [3,3,3]
%UCAF = [4,4,4]
%UCAR = [5,5,5]
%PR = [6,6,6]

% takes multiple measurements into consideration

[TR] = reduction(TR)
[LCAF] = reduction(LCAF)
[LCAR] = reduction(LCAR)
[UCAF] = reduction(UCAF)
[UCAR] = reduction(UCAR)
[PR] = reduction(PR)

