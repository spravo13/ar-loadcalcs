function [] = loadcalcs(B)


% function used to calculate the forces on each component in a push rod suspension
%	system. 
% Input should be in the form of a column vector with the values of 
%	ΣFx, ΣFy, ΣFz ΣMx, ΣMy, and ΣMz respectively

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


% each component is the distance between the wheel center and the force vector
%multiple measurments are allowed

% r(position vector) for Tie Rod
r_TR = []; 
% r(position vector) for Lower Control Arm, Front
r_LCAF = [];
%r(position vector) for Lower Control Arm, Rear
r_LCAR = [];
%r(position vector) for Upper Control Arm, Front
r_UCAF = [];
%r(position vector) for Upper Control Arm, Rear
r_UCAR = [];
%r(position vector) for Push Rod
r_PR = [];


% takes multiple measurements into consideration
% see ./reduction.m
[TR] = reduction(TR);
[LCAF] = reduction(LCAF);
[LCAR] = reduction(LCAR);
[UCAF] = reduction(UCAF);
[UCAR] = reduction(UCAR);
[PR] = reduction(PR);


% normalizes (makes into unit vectors). Program assumes magnitude ~= 0
norm_TR = TR./norm(TR);
norm_LCAF = LCAF./norm(LCAF);
norm_LCAR = LCAR./norm(LCAR);
norm_UCAF = UCAF./norm(UCAF);
norm_UCAR = UCAR./norm(UCAR);
norm_PR = PR./norm(PR);


% Checks for r vectors not 1x3. (makes nx3 => 1x3)
% see ./r_avg
[r_TR] = r_avg(r_TR);
[r_LCAF] = r_avg(r_LCAF);
[r_LCAR] = r_avg(r_LCAR);
[r_UCAF] = r_avg(r_UCAF);
[r_UCAR] = r_avg(r_UCAR);
[r_PR] = r_avg(r_PR);


% creates components to be used in moment summations
m_TR = cross(r_TR, norm_TR);
m_LCAF = cross(r_LCAF, norm_LCAF);
m_LCAR = cross(r_LCAR, norm_LCAR);
m_UCAF = cross(r_UCAF, norm_UCAF);
m_UCAR = cross(r_UCAR, norm_UCAR);
m_PR = cross(r_PR, norm_PR);


% forms rows of matrix A (forces)
sig_fx = [norm_TR(1), norm_LCAF(1), norm_LCAR(1), norm_UCAF(1), norm_UCAR(1), norm_PR(1)];
sig_fy = [norm_TR(2), norm_LCAF(2), norm_LCAR(2), norm_UCAF(2), norm_UCAR(2), norm_PR(2)];
sig_fz = [norm_TR(3), norm_LCAF(3), norm_LCAR(3), norm_UCAF(3), norm_UCAR(3), norm_PR(3)];


% forms rows of matrix A (moments)
sig_mx = [m_TR(1), m_LCAF(1), m_LCAR(1), m_UCAF(1), m_UCAR(1), m_PR(1)];
sig_my = [m_TR(2), m_LCAF(2), m_LCAR(2), m_UCAF(2), m_UCAR(2), m_PR(2)];
sig_mz = [m_TR(3), m_LCAF(3), m_LCAR(3), m_UCAF(3), m_UCAR(3), m_PR(3)];


A = [sig_fx; sig_fy; sig_fz; sig_mx; sig_my; sig_mz];


x = A\B;

fprintf(' Tie Rod: \t \t \t %f \n Lower Control Arm, Front: \t %f \n Lower Control Arm, Rear: \t %f \n Upper Control Arm, Front: \t %f \n Lower Control Arm, Rear: \t %f \n Push Rod: \t \t \t %f \n', x(1), x(2), x(3), x(4), x(5), x(6));


end
