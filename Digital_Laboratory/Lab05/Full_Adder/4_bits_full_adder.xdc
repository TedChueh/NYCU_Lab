set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { carry_in }]; 
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { augend1 }]; 
set_property -dict { PACKAGE_PIN H6   IOSTANDARD LVCMOS33 } [get_ports { augend2 }]; 
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { augend3 }]; 
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { augend4 }];

set_property -dict { PACKAGE_PIN T8   IOSTANDARD LVCMOS33 } [get_ports { addend1 }];
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { addend2 }];
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { addend3 }];
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { addend4 }];

set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { sum1 }]; 
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { sum2 }]; 
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { sum3 }]; 
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { sum4 }]; 

set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { carry_out }]; 
