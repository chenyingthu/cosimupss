function [ hasEvent ] = HasControlEvent(Config, present_step)
    hasEvent = (Config.opfControlPerod > 0) & (mod(present_step*Config.DSSStepsize, Config.opfControlPerod*60)==0);
end
