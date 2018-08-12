function indeces = checkRectOverlap(inRect, compRects, thresh)
%CHECKRECTOVERLAP Check for overlapping rectangles
%  This function takes an input rectangle 'inRect' and compares it to all
%  of the rectanges in 'compRects' to check for overlap.
%
%  The amount of overlap is calculated as the area of intersection divided
%  by the area of union. If the rectangles are identical, this ratio will
%  be 1.0. For the purpose of validating results, two rectangles are
%  generally considered a close enough match if the ratio is greater than 
%  0.5. This ratio is specified with the 'thresh' parameter.
	indeces = [];

	% Get the coordinates of the top-left and bottom-right corners
	% of the rectangle.
	a1x = inRect(1, 1);
    a1y = inRect(1, 2);
    a2x = a1x + inRect(1, 3);
    a2y = a1y + inRect(1, 4);
	
	aArea = inRect(1, 3) * inRect(1, 4);

	for i = 1 : size(compRects, 1)
		b1x = compRects(i, 1);
		b1y = compRects(i, 2);
		b2x = b1x + compRects(i, 3);
		b2y = b1y + compRects(i, 4);

		bArea = compRects(i, 3) * compRects(i, 4);

        x_overlap = max(0, min(a2x, b2x) - max(a1x, b1x));
        y_overlap = max(0, min(a2y, b2y) - max(a1y, b1y));

		intersectArea = x_overlap * y_overlap;

		unionArea = aArea + bArea - intersectArea;

		if ((intersectArea / unionArea) > thresh)
			indeces = [indeces; i];
        end		
    end
end