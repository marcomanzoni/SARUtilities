function SLC = generateSLCStruct(the_folder, ind_imma, polarization)
%GENERATESLCSTRUCT generate the struct SLC that is needed in order to
%launch scripts from the TWIGA project.

    SLC.ind_imma = ind_imma;
    SLC.data_fold_nam = the_folder;
    
    %% Create a time sorted list of files
    SLC.pol = 'VV';
    [SLC.img_fnams, SLC.gcd_fnam, SLC.dates] = get_sort_snap_fnames(SLC.data_fold_nam, SLC.pol);
    SLC.master_fnam = SLC.img_fnams(cell2mat({SLC.img_fnams.is_master})>0).name;
    
    if ismember(polarization, ["VV", "VH"])
        npols = 1;
    else
        npols = 2;
    end
    
    if npols == 2
        [HV_fnams, ~, HV_dates] = get_sort_snap_fnames(SLC.data_fold_nam, 'VH');
        if any(HV_dates - SLC.dates)
            error('HV dates not matching VV')
        end
        SLC.img_fnams_HV = HV_fnams;
    end
end

