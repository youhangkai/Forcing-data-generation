% forcing data generation.
% multi nc file read and write.

zero = 0;
inputfile_dir = "H:\tpqwl\precip\";
output_dir = "H:\TPQWL\";
count = 1;
for i = 2001:2020
    input_year = [inputfile_dir+i];
    output__year = [output_dir+"clmforc.GSWP3.c2011.0.5x0.5.TPQWL."+i];
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

        temp_surface_pressure_map = single(zeros(720,360,month_day*8));

        for k = 1:month_day
            
            if(k < 10)
                string_day = [input_month+zero+k];
            else
                string_day = [input_month+k];
            end
            
            input_file_path = [string_day+".nc"];

            %
            for hr = 1:3:22
                hour = ceil(hr/3);
                ori_map_specific_humidity = ncread(input_file_path,'QV10M');
                temp_specific_humidity_map(:,:,(8*(k-1))+hour) = fliplr(ori_map_specific_humidity(:,:,hr));

                ori_map_air_temperature = ncread(input_file_path,'T10M');
                temp_air_temperature_map(:,:,(8*(k-1))+hour) = fliplr(ori_map_air_temperature(:,:,hr));
            end



            %       
        end

        output_file_path = [output_month+".nc"];

        ncid_new = netcdf.open(output_file_path,'WRITE');

        read_CFT_id_TBOT = netcdf.inqVarID(ncid_new,'QBOT');
        read_CFT_org = netcdf.getVar(ncid_new,read_CFT_id_TBOT);
        read_CFT_org = temp_specific_humidity_map;
        netcdf.putVar(ncid_new,read_CFT_id_TBOT,read_CFT_org);
        netcdf.close(ncid_new);
        
        read_CFT_id_TBOT = netcdf.inqVarID(ncid_new,'TBOT');
        read_CFT_org = netcdf.getVar(ncid_new,read_CFT_id_TBOT);
        read_CFT_org = temp_air_temperature_map;
        netcdf.putVar(ncid_new,read_CFT_id_TBOT,read_CFT_org);
        netcdf.close(ncid_new);

        disp(["The file of "+i+"-"+j+" has been successfully generated!"]);
    end
end
disp("All files completed! finished!");
