import java.io.IOException;
import java.net.InetSocketAddress;
import net.spy.memcached.MemcachedClient;
import spymemhelper.SpyMemHelper;

% hostname='localhost';
% portNum = 11211;
%MemcachedClient c;
% addr = InetSocketAddress(hostname, portNum);
% c = javaObjectEDT('net.spy.memcached.MemcachedClient',addr);
% try
%     c = net.spy.memcached.MemcachedClient(addr);
% catch ME
%     disp('exception');
% end;
helper = javaObjectEDT('spymemhelper.SpyMemHelper');
helper.set('testKeyMat','testValueMat');
v = helper.get('testKeyMat');
disp(v);