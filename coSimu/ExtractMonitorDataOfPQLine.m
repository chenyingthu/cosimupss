function [plineHead, qlineHead, plineTail, qlineTail] = ExtractMonitorDataOfPQLine(DSSCircuit)

plineHead = [];
qlineHead = [];
plineTail = [];
qlineTail = [];

mons = DSSCircuit.Monitors;
iMon = mons.first;
% nMon = mons.count;
while iMon > 0
    if strcmp(mons.name(1:4), 'line')
        
        n = mons.SampleCount;
        ba = mons.ByteStream;
        [r, c] = size(ba);
        sdata = typecast(ba(c-15:c-8), 'single');
        S = sdata(1)/1e3*exp(j*sdata(2)/180*pi);
        if (mons.name(5) == 'h')
            plineHead = [plineHead; real(S)];
            qlineHead = [qlineHead; imag(S)];
        else
            plineTail = [plineTail; real(S)];
            qlineTail = [qlineTail; imag(S)];
        end
    end
            
    iMon = mons.Next;
end

