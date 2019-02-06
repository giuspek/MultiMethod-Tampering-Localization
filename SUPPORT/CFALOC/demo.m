% Demo of CFA localization algorithm
%
% Copyright (C) 2011 Signal Processing and Communications Laboratory (LESC),       
% Dipartimento di Elettronica e Telecomunicazioni - Università di Firenze                        
% via S. Marta 3 - I-50139 - Firenze, Italy                   
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

addpath('../');
filename = 'dev_0011.tif';

% dimensione of statistics
Nb = [14];
% number of cumulated bloks
Ns = 1;
% Pattern of CFA on green channel
bayer = [0, 1;
         1, 0];
     
im = imread(filename);
for j = 1:1
    [map, stat] = CFAloc(im, bayer, Nb(j),Ns);
    [h w] = size(map);
    %    NaN and Inf management
    stat(isnan(stat)) = 1;
    data = log(stat(:)); 
    data = data(not(isinf(data)|isnan(data)));
    % square root rule for bins
    n_bins = round(sqrt(length(data)));

    % plot result
    figure
    subplot(2,2,3), imagesc(map), axis equal, axis([1 w 1 h]), title(['Probability map (Nb = ',num2str(Nb(j)),')']);
    subplot(2,2,2), hist(data, n_bins), title('Histogram of the proposed feature');
end

disp(min(min(map)));
disp(max(max(map)));

if abs(max(max(map))) - 100 > abs(min(min(map)))
    prova = map < min(min(map)) + 0.05 * abs(max(max(map)) - min(min(map)));
    disp('Big GAP');
elseif max(max(map))) - abs(min(min(map))) > 5
    prova = map < 0; 
    disp('Small GAP');
else
    prova = map < -1000000;
end
subplot(2,2,4),
imshow(prova)


