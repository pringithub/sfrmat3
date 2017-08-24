% sfrmat3 and supporting functions            24 July 2009
%
% General info: readme.txt
% functions:
% ahamming - asymmetrical Hamming window
% cent     - array shift for centering data
% centerfig - calculates the position vector for figure
% centroid - finds centroid of vector
% clip - limit values for data low and high
% clipping - checks for image data clipping
% deriv1   - first derivative of array
% findedge - fits linear equation to data
% findfreq - find frequency for specified SFR value
% fir2fix - correction for MTF of derivative (difference) filter
% getoecf  - read and apply oecf LUT
% getroi   - select and return region of interest
% imageread - read image data
% inbox1   - dialogue box for data sampling for SFR calculation
% inbox3   - dialogue box for input of data sampling, weights
% inputdlg - creates a modal dialog box
% isarray  - check if input is array
% project  - projects data
% readraw1 - read images stored as raw (byte) data files
% readrawgui - User input needed for reading .raw files by imageread
% results  - Matlab function saves results computed by sfrmat2.m
% results2 -  saves results computed by sfrmat3
% rotate90 - 90 degree counterclockwise rotations of matrix
% rotatev  - rotate array
% rotatev2 - rotate edge array so the feature is vertical
% sampeff - sampling efficiency from SFR
% sfrmat3  - Main slanted-edge and color mis-registration programme
% splash   - displays simple splash window announcing program name
% std2 - std2 standard deviation of matrix elements
% test_sfrmat3 - run and compare sfrmat2 and sfrmat3
% textfig - puts text in figure

% Copyright (c) Peter D. Burns 2009 pdburns@ieee.org
