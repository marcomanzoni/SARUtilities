function saveFigureIntoFolder(outputFolder, fileName)
%SAVEFIGURE Save the current figure as .fig and as a .pdf. Uses the
%export_fig function from matlab central. Inside output folder it will
%generate a folder named fileName with inside the two files called filename
%
%   inputs:
%           - outputFolder: [string] folder where I have to save the images
%           - fileName: [string] file name of the image without the
%           extension

if not(exist(outputFolder, 'dir'))
    error("The output folder does not exist or I don't have permissions");
end

folderName = fullfile(outputFolder, fileName);
mkdir(folderName);
set(gcf, 'Color', 'w');

savefig(fullfile(folderName, sprintf("%s.fig", fileName)))
export_fig(fullfile(folderName, sprintf("%s.pdf", fileName)));

end

