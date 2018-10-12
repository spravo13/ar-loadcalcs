function [avg] = r_avg(r)
	if size(r,1) > 1
		avg = mean(r);
	else
		avg = r;
	end
end
