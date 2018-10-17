function [] = loadcalcs(B, wheel)

% function used to calculate the forces on each component in a push rod 
%	suspension system. 
%
% Use: loadcalcs(B, wheel)
% Argument "B" should be in the form of a vector with the values of 
%	ΣFx, ΣFy, ΣFz ΣMx, ΣMy, and ΣMz respectively
% Argument "Wheel" should be either 'rear' or 'front'
%
% Note: all calcs are for right side of car (if sitting in driver's seat).

% components of vectors describing the directions of the suspension members
% 	and therefore the direction of the resultant forces each component 
% 	should be an nx3 matrix where n is typically 1, but can be
% 	any number if multiple measurments are taken

% checks input arguments for validity

if numel(B) ~= 6
	fprintf('The matrix "B" you entered does not have 6 elements corresponding \n
		to ΣFx, ΣFy, ΣFz ΣMx, ΣMy, and ΣMz respectively');
	return;
else
	if size(B,1) ~= 6
		B = B'
	end
end

if wheel == 'rear'

	% Rear Tie Rod
	TR = [];
	% Rear Lower Control Arm, Front
	LCAF = [25.438851,	 -6.759425,	 -1.769762];
	% Rear Lower Control Arm, Rear
	LCAR = [4.837878,	 -9.675756,	 -1.759228];
	% Rear Upper Control Arm, Front
	UCAF = [23.065203,	 -2.711059,	 -3.313228];
	% Rear Upper Control Arm, Rear
	UCAR = [2.469657,	 -5.645462,	 -3.289517];
	% Rear Push Rod
	PR = [];


	% each component is the distance between the wheel center and the 
	%force vector multiple measurments are allowed

	% r(position vector) for Rear Tie Rod
	r_TR = []; 
	% r(position vector) for Rear Lower Control Arm, Front
	r_LCAF = [0,	 -5.5,	 	 0];
	%r(position vector) for Rear Lower Control Arm, Rear
	r_LCAR = [0,	 -5.5,	 	 0];
	%r(position vector) for Rear Upper Control Arm, Front
	r_UCAF = [0,	 -5.767212,	 0];
	%r(position vector) for Rear Upper Control Arm, Rear
	r_UCAR = [0,	 -5.767212,	 0];
	%r(position vector) for Rear Push Rod
	r_PR = [];

else if wheel == 'front'

	% Front Tie Rod
	TR = [];
	% Front Lower Control Arm, Front
	LCAF = [6.85,	 -14.94,	 -0.75];
	% Front Lower Control Arm, Rear
	LCAR = [-7.65	 -14.97,	 -0.75];
	% Front Upper Control Arm, Front
	UCAF = [7.65,	 -9.787249,	 -1.912351];
	% Front Upper Control Arm, Rear
	UCAR = [-6.85,	 -9.787249,	 -1.912351];
	% Front Push Rod
	PR = [];


	% each component is the distance between the wheel center and the 
	%force vector multiple measurments are allowed

	% r(position vector) for Front Tie Rod
	r_TR = []; 
	% r(position vector) for Front Lower Control Arm, Front
	r_LCAF = [0,	 -1.06,		 0];
	%r(position vector) for Front Lower Control Arm, Rear
	r_LCAR = [0,	 -1.06,		 0];
	%r(position vector) for Front Upper Control Arm, Front
	r_UCAF = [0,	 -1.862751	 0];
	%r(position vector) for Front Upper Control Arm, Rear
	r_UCAR = [0	 -1.862751	 0];
	%r(position vector) for Front Push Rod
	r_PR = [];

else

	fprintf('you entered an invalid wheel. Options are rear and front.');
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
