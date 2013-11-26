function [pload, qload] = ExtractMonitorDataOfPQLoad(DSSCircuit)

pload = [];
qload = [];

mons = DSSCircuit.Monitors;
iMon = mons.first;
% nMon = mons.count;
while iMon > 0
    n = mons.SampleCount;
    ba = mons.ByteStream;
    [r, c] = size(ba);
    sdata = typecast(ba(c-15:c-8), 'single');
    S = sdata(1)/1e3*exp(j*sdata(2)/180*pi);
    pload = [pload; real(S)];
    qload = [qload; imag(S)];
    iMon = mons.Next;
end

