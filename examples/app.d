import std.stdio;
import std.exception;
import std.string;
import std.conv;
import deimos.vix.vix;

void main(string[] args)
{
    if(args.length != 2)
    {
        writeln("invalid argument, should like: vixdemo.exe vmxfile");
        return;
    }
     VixHandle jobHandle = VixHost_Connect(VIX_API_VERSION, VIX_SERVICEPROVIDER_VMWARE_WORKSTATION,
			"", 0, "", "", 0, VIX_INVALID_HANDLE,  null, null);
	VixHandle hostHandle = VIX_INVALID_HANDLE;
	VixError vixError = VixJob_Wait(jobHandle, VIX_PROPERTY_JOB_RESULT_HANDLE, 
			&hostHandle,VIX_PROPERTY_NONE);
    enforce(VIX_SUCCEEDED(vixError), "VixHost_Connect fail");
    Vix_ReleaseHandle(jobHandle);
    
    jobHandle = VixVM_Open(hostHandle, toStringz(args[1]), null, null); 
	VixHandle vmHandle = VIX_INVALID_HANDLE;
	vixError = VixJob_Wait(jobHandle, VIX_PROPERTY_JOB_RESULT_HANDLE, &vmHandle, VIX_PROPERTY_NONE);
	enforce(VIX_SUCCEEDED(vixError), "VixVM_Open fail");
	Vix_ReleaseHandle(jobHandle);

    jobHandle = VixVM_PowerOn(vmHandle, VIX_VMPOWEROP_LAUNCH_GUI, 
			VIX_INVALID_HANDLE, null,  null);
	VixHandle snapshotHandle = VIX_INVALID_HANDLE;
	vixError = VixJob_Wait(jobHandle, VIX_PROPERTY_JOB_RESULT_HANDLE,
			&snapshotHandle, VIX_PROPERTY_NONE);
	Vix_ReleaseHandle(jobHandle);
	enforce(VIX_SUCCEEDED(vixError), "VixVM_PowerOn fail, erroCode:" ~ to!string(VIX_ERROR_CODE(vixError)));

    writeln("VixVM_PowerOn success");
}