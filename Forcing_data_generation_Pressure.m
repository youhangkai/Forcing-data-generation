% forcing data generation.
% multi nc file read and write.

zero = 0;
inputfile_dir = "H:\tpqwl\precip\";
output_dir = "H:\cesm_forcing_data\precip\";
count = 1;

Start_year = 2019;
Start_month = 5;
End_year = 2020;

for i = Start_year:End_year
    input_year = [inputfile_dir+i];
    output__year = [output_dir+"clmforc.GSWP3.c2011.0.5x0.5.Prec."+i];

    if(i == Start_year)
        ST = Start_month;
    else
        ST = 1;
    end

    for j = ST:12
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

        %temp_radiation_map = single(zeros(720,360,month_day*8));
        temp_precipitation_map = single(zeros(720,360,month_day*8));

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
                ori_map = ncread(input_file_path,'PRECTOTCORR');
                temp_precipitation_map(:,:,(8*(k-1))+hour) = ori_map(:,:,hr);
            end



            %       
        end

        output_file_path = [output_month+".nc"];

        ncid_new = netcdf.open(output_file_path,'WRITE'); % open nc file as 'read-write' mode
        read_CFT_id = netcdf.inqVarID(ncid_new,'PRECTmms'); % read var id
        read_CFT_org = netcdf.getVar(ncid_new,read_CFT_id); % get variable
        read_CFT_org = temp_precipitation_map;
        netcdf.putVar(ncid_new,read_CFT_id,read_CFT_org); % write new CFT
        netcdf.close(ncid_new); % close nc file

        disp(["The file of "+i+"-"+j+" has been successfully generated!"]);
    end
end
disp("All files completed! finished!");
