Download Xilinx ISE 14.7 from Xilinx and install to your computer. (Install files are quite large, GWireless is recommended)

http://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools/v2012_4---14_7.html



Download Diligent Adept 2.3 from digilent website and install to your computer.

http://www.digilentinc.com/Products/Detail.cfm?NavPath=2,66,69&Prod=ADEPT&CFID=23189570&CFTOKEN=f349e52361f552ab-F2EC16D6-5056-0201-028152AA96F635CD



The license file can also be obtained by going to the Xilinx Product Licensing Site: 

http://www.xilinx.com/getlicense

Apply ISE WebPack license, load and manage the license by Xilinx Lisence Configration Manager.

==============================================================================================



Fixing Project Navigator, iMPACT and License Manager



Note: I am assuming you are using ISE 14.7 and have installed it to the default location



1. Open the following directory: C:\Xilinx\14.7\ISE_DS\ISE\lib\nt64

2. Find and rename libPortability.dll to libPortability.dll.orig

3. Make a copy of libPortabilityNOSH.dll (copy and paste it to the same directory) and rename it libPortability.dll

4. Copy libPortabilityNOSH.dll again, but this time navigate to C:\Xilinx\14.7\ISE_DS\common\lib\nt64 and paste it there

5. In C:\Xilinx\14.7\ISE_DS\common\lib\nt64 Find and rename libPortability.dll to libPortability.dll.orig

6. Rename libPortabilityNOSH.dll to libPortability.dll

================================================================================================

If you cannot open PlanAhead, follow the steps below:

Fixing PlanAhead not opening from 64-bit Project Navigator

PlanAhead will not open when you are running 64-bit Project Navigator (e.g. for I/O Pin Planning), it just displays the splash screen but never opens.

To fix it, we have to force PlanAhead to always run in 32-bit mode.

1. Open C:\Xilinx\14.7\ISE_DS\PlanAhead\bin and rename rdiArgs.bat to rdiArgs.bat.orig

2. Download the attached zip file(http://www.eevblog.com/forum/microcontrollers/guide-getting-xilinx-ise-to-work-with-windows-8-64-bit/?action=dlattach;attach=102040;PHPSESSID=a97c70b66d7d83b75a881a803874768d)

3. Extract it. You should now have a file named rdiArgs.bat

4. Copy the new rdiArgs.bat file to C:\Xilinx\14.7\ISE_DS\PlanAhead\bin

END
