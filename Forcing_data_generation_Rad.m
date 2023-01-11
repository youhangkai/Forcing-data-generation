% forcing data generation.
% multi nc file read and write.

zero = 0;
inputfile_dir = "H:\radiation\2001_2020\";
output_dir = "H:\cesm_forcing_data\solar\";
count = 1;
parfor i = 2001:2020
    input_year = [inputfile_dir+i];
    output__year = [output_dir+"clmforc.GSWP3.c2011.0.5x0.5.Solr."+i];
    for j = 1:12
        if(j < 10)
            input_month = [input_year+zero+j];
            output_month = [output__year+"-"+zero+j];
        else
            input_month = [input_year+j];
            output_month = [output__year+"-"+j];
        end

        if(j == 1)
            month_day = 31;
        %elseif(j == 2) && (mod(i,4) == 0)
        %    month_day = 29;
        %elseif(j == 2) && (mod(i,4) ~= 0)
        elseif(j == 2)
            month_day = 28;
        elseif(j == 3)
            month_day = 31;
        elseif(j == 4)
            month_day = 30;
        elseif(j == 5)
            month_day = 31;
        elseif(j == 6)
            month_day = 30;
        elseif(j == 7)
            month_day = 31;
        elseif(j == 8)
            month_day = 31;
        elseif(j == 9)
            month_day = 30;
        elseif(j == 10)
            month_day = 31;
        elseif(j == 11)
            month_day = 30;
        elseif(j == 12)
            month_day = 31;
        end

        temp_radiation_map = single(zeros(720,360,month_day*8));

        for k = 1:month_day
            
            if(k < 10)
                string_day = [input_month+zero+k];
            else
                string_day = [input_month+k];
            end
            
            input_file_path = [string_day+".nc"];

            %
            for hr = 2:3:23
                hour = ceil(hr/3);
                ori_map = ncread(input_file_path,'SWGDN');
                temp_radiation_map(:,:,(8*(k-1))+hour) = fliplr(ori_map(:,:,hr));
            end



            %       
        end

        output_file_path = [output_month+".nc"];

        ncid_new = netcdf.open(output_file_path,'WRITE');
        read_CFT_id = netcdf.inqVarID(ncid_new,'FSDS');
        read_CFT_org = netcdf.getVar(ncid_new,read_CFT_id);
        read_CFT_org = temp_radiation_map;
        netcdf.putVar(ncid_new,read_CFT_id,read_CFT_org);
        netcdf.close(ncid_new);

        time = 0.0625000:0.125:(0.0625000+0.125*(month_day*8-1));
        time = single(time)';
        ncid_new = netcdf.open(output_file_path,'WRITE');
        read_CFT_id = netcdf.inqVarID(ncid_new,'time');
        read_CFT_org = netcdf.getVar(ncid_new,read_CFT_id);
        read_CFT_org = time;
        netcdf.putVar(ncid_new,read_CFT_id,read_CFT_org);
        netcdf.close(ncid_new);

        disp(["The file of "+i+"-"+j+" has been successfully generated!"]);
    end
end
disp("All files completed! finished!");
