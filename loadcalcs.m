function [] = loadcalcs(B, wheel)

% function used to calculate the forces on each component in a push rod 
%	suspension system. 
%
% Use: loadcalcs(B, wheel)
% Argument "B" should be in the form of a vector with the values of 
%	ΣFx, ΣFy, ΣFz ΣMx, ΣMy, and ΣMz respectively
% Argument "Wheel" should be either 1 (rear) or 2 (front)
%
% Note: all calcs are for right side of car (if sitting in driver's seat).

% components of vectors describing the directions of the suspension members
% 	and therefore the direction of the resultant forces each component 
% 	should be an nx3 matrix where n is typically 1, but can be
% 	any number if multiple measurments are taken

% checks input arguments for validity

if numel(B) ~= 6
	fprintf('The matrix "B" you entered does not have 6 elements corresponding \n to ΣFx, ΣFy, ΣFz ΣMx, ΣMy, and ΣMz respectively. \n');
	return;
else
	if size(B,1) ~= 6
		B = B';
	end
end


if wheel == 1			%Rear
	
	% Rear Tie Rod
	TR =   [5.2,		 -4.17,		 -1.3];
	% Rear Lower Control Arm, Front
	LCAF = [25.438851,	 -6.759425,	 -1.769762;
		8.09,		 -2.72,		 -0.31];
	% Rear Lower Control Arm, Rear
	LCAR = [4.837878,	 -9.675756,	 -1.759228;
		2.63,		 -4.05,		 -0.15];
	% Rear Upper Control Arm, Front
	UCAF = [23.065203,	 -2.711059,	 -3.313228;
		6.89,		 -1.32,		 -1.83];
	% Rear Upper Control Arm, Rear
	UCAR = [2.469657,	 -5.645462,	 -3.289517;
		1.51,		 -3.88,		 -1.1];
	% Rear Push Rod
	PR =   [2.46		 -4.05,		 1.91];


	% each component is the distance between the wheel center and the 
	%force vector multiple measurments are allowed

	% r(position vector) for Rear Tie Rod
	r_TR =   [-2.48, -7.8,	 4.606299]; 
	% r(position vector) for Rear Lower Control Arm, Front
	r_LCAF = [0,	 -8.1,	 	 -3.976378];
	%r(position vector) for Rear Lower Control Arm, Rear
	r_LCAR = [0,	 -8.1,	 	 -3.976378];
	%r(position vector) for Rear Upper Control Arm, Front
	r_UCAF = [2.283, -7.8,		 4.685039];
	%r(position vector) for Rear Upper Control Arm, Rear
	r_UCAR = [2.283, -7.81,		 4.685039];
	%r(position vector) for Rear Push Rod
	r_PR =   [1.575, -9.225,	 -3.58268];

elseif wheel == 2

	% Front Tie Rod
	TR =   [1.32,	 -9.1,		 -0.85];
	% Front Lower Control Arm, Front
	LCAF = [6.85,	 -14.94,	 -0.75;
		3.41,	 -5.91,		 -0.29];
	% Front Lower Control Arm, Rear
	LCAR = [-7.65,	 -14.97,	 -0.75;
		-1.7,	 -4.195,	 -0.12];
	% Front Upper Control Arm, Front
	UCAF = [7.65,	 -9.787249,	 -1.912351;
		5.48,	 -6.49,		 -1.18];
	% Front Upper Control Arm, Rear
	UCAR = [-6.85,	 -9.787249,	 -1.912351;
		-2.56,	 -4.7,		 -0.5];
	% Front Push Rod
	PR =   [-1.22,	 -2.59,		 4.85];


	% each component is the distance between the wheel center and the 
	%force vector multiple measurments are allowed

	% r(position vector) for Front Tie Rod
	r_TR =   [-3.15, -4.5,		 -2.3622]; 
	% r(position vector) for Front Lower Control Arm, Front
	r_LCAF = [0,	 -3.125,	 -4.92126];
	%r(position vector) for Front Lower Control Arm, Rear
	r_LCAR = [0,	 -3.125,	 -4.92126];
	%r(position vector) for Front Upper Control Arm, Front
	r_UCAF = [0,	 -2.375,	 4.80315];
	%r(position vector) for Front Upper Control Arm, Rear
	r_UCAR = [0	 -2.375,	 4.80315];
	%r(position vector) for Front Push Rod
	r_PR =   [0,	 -5,		 -4.015748];

else

	fprintf('you entered an invalid wheel. Options are 1 (rear) and 2 (front).\n');
	return;

end


% takes multiple measurements into consideration
% see ./reduce.m
[TR] = reduce(TR);
[LCAF] = reduce(LCAF);
[LCAR] = reduce(LCAR);
[UCAF] = reduce(UCAF);
[UCAR] = reduce(UCAR);
[PR] = reduce(PR);


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


% sets A as concatonation of all force and moments vectors
A = [sig_fx; sig_fy; sig_fz; sig_mx; sig_my; sig_mz];


% solves the linear system of 6 unknowns and 6 equations

x = A\B;


% prints results
			fprintf(' Tie Rod: \t \t \t %f \n Lower Control Arm, Front: \t %f \n Lower Control Arm, Rear: \t %f \n Upper Control Arm, Front: \t %f \n Lower Control Arm, Rear: \t %f \n Push Rod: \t \t \t %f \n', x(1), x(2), x(3), x(4), x(5), x(6));

end
