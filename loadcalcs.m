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

% takes multiple measurements into consideration
for m = [TR, LCAF, LCAR, UCAF, UCAR, PR]
	if size(m,1) > 1			%checks for multiple rows (measurments)
		for i = [2:size(m,1)]
			mult_factor_array = m(1,:) ./ m(i,:);
			mult_factor = mean(mult_factor_array);
			m(i, :) = mult_factor .* m(i, :)
		end
		m = mean(m);
	end
end

% Error Checking
c = 1
for m = [TR, LCAF, LCAR, UCAF, UCAR, PR]
	if size(m,1) ~= 1
		fprintf('something is wrong. Matrix # %d member is not 1x3', c);
	end
	c = c+1
end
% End Error Checking
