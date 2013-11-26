function ExcuteOpfCtrlOperation(DSSText, opts)

nOpt = length(opts);

for i = 1 : nOpt
    DSSText.command = opts(i).opt;
    opts(i).status = 3 ; % excuted;
end


end