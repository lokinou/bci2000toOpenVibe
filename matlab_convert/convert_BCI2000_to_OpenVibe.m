%Author: Loic Botrel
%Date: 05/03/2021
%email: loic.botrel(at)uni-wuerzburg.de 

% DEFINE HERE THE PATH TO EEGLAB
% note: you must beforehand ensure that you have the BCI2000Import and
% BioSig plugins installed by starting eeglab (type eeglab in console(
% then select File>Manage EEGLab Extensions
EEGLAB_DIR = 'C:\BCI\dev\eeglab2020_0';
PATH_TO_CONVERT = '.\to_convert';
PATH_CONVERTED = '.\converted\converted_openvibe.gdf';
addpath(EEGLAB_DIR);

% STARTING EEGLAB ---------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% -------------------------------------

% ensure our source folder is there
assert(isfolder(PATH_TO_CONVERT), sprintf('Error: Missing folder %s', PATH_TO_CONVERT));
%% search for file using the following regular expression patterns
file_pattern = sprintf('.*.dat');
flist = getAllFiles(PATH_TO_CONVERT, file_pattern);

%% load the files
% I tweaked the function because the original does not work because of
% bounds... 
EEG = pop_loadBCI2000_no_bounds(flist, {'StimulusCode'});
%EEG = pop_loadBCI2000(flist, {'StimulusCode', 'StimulusType', 'PhaseInSequence'});

EEG = eeg_checkset( EEG );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off','setname','BCI2000_imported'); 
eeglab redraw

%% Transform the events for them to become meaningful
% basically we transform events of type StimulusCode which have a different
% value (position) into individual types. Only types are recognized by
% EEGLab plots and Openvibe
EEG_stim = pop_selectevent( EEG, 'type',{'StimulusCode'},'position',1,...
    'renametype','s1','deleteevents','off');
% Translate sequence events
EEG_stim = pop_selectevent( EEG_stim, 'type',{'StimulusCode'},'position',2,...
    'renametype','s2','deleteevents','off');
EEG_stim = pop_selectevent( EEG_stim, 'type',{'StimulusCode'},'position',3,...
    'renametype','s3','deleteevents','off');
EEG_stim = pop_selectevent( EEG_stim, 'type',{'StimulusCode'},'position',4,...
    'renametype','s4','deleteevents','off');

EEG_stim = eeg_checkset( EEG_stim );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG_stim, 0,'gui','off','setname','Types_transformed'); 
eeglab redraw

%% Export the data to GDF
[filepath, name, ext] = fileparts(PATH_CONVERTED)
if (~isfolder(filepath))
    mkdir(filepath)
end %if

pop_writeeeg(EEG, PATH_CONVERTED, 'TYPE','GDF');