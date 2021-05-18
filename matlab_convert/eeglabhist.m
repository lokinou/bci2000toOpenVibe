% EEGLAB history file generated on the 06-Mar-2021
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = eeg_checkset( EEG );
pop_writeeeg(EEG, 'C:\Users\lokinou\Nextcloud\Documents\requests\matthias\smr shennanigans\tutorial_bci2000_to_openvibe\matlab_convert\converted\converted.gdf', 'TYPE','GDF');
eeglab redraw;
