% takes multiple measurements into consideration
function [r] = reduction(m)
	if size(m,1) > 1			%checks for multiple rows (measurments)
		for i = [2:size(m,1)]
			mult_factor_array = m(1,:) ./ m(i,:);
			mult_factor = mean(mult_factor_array);
			m(i, :) = mult_factor .* m(i, :);
		end
		m = mean(m);
	end
	r = m;
end
