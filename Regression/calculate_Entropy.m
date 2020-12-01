% Calculating entropy
% used in InfoGainonFeature

function [Entropy ] = calculate_Entropy(p, n, r)
    switch nargin
        case 2
            A = p/(p+n);
            B = n/(p+n);
            Entropy = -A.*log2(A)-B.*log2(B);
        case 3
            A = p/(p+n+r);
            B = n/(p+n+r);
            C = r/(p+n+r);
            Entropy = -A.*log2(A)-B.*log2(B)-C.*log2(C);
        otherwise
            A = p/(p+n);
            B = n/(p+n);
            Entropy = -A.*log2(A)-B.*log2(B);
    end  
end