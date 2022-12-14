# PL 10GBASE-R v2022.1

## **Design Summary**

This project utilizes AXI 10G/25G Ethernet Subsystem configured for 10GBASE-R. This has been routed to the SFP cage on SFP2 for use on a ZCU102 board. System is configured to use the ZCU102 si570 at 156.25MHz.

- `eth0` is configured as GEM3 routed via RGMII to the on-board PHY.
- `eth1` is configured as 10G/25G Ethernet Subsystem routed to SFP1.

---

## **Required Hardware**

- ZCU102
- SFP supporting 10GBASE-R
- 10G capable link partner

---

## **Build Instructions**

### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **Vitis**:

There is currently no baremetal Vitis support for the 10G/25G IP.

### **PetaLinux**:

Enter the `Software/PetaLinux/` directory. From the command line run the following:

`petalinux-create -t project -s pl_eth_10g.bsp -n pl_10g_plnx`

`cd pl_10g_plnx`

`petalinux-config --get-hw-description ../../../Hardware/pre-built/ --silentconfig`

`petalinux-build`

The PetaLinux project will be built using the configurations in the BSP.

Once the build is complete, the built images can be found in the `PetaLinux/images/linux/`
directory. To package these images for SD boot, run the following from the `PetaLinux` directory:

`petalinux-package --boot --u-boot --force`

Once packaged, the`boot.scr`, `BOOT.bin` and `image.ub` files (in the `PetaLinux/images/linux` directory) can be copied to an SD card, and used to boot.

---
## **Known Issues**

---

## **Validation**
### **Performance**
+ for detailed performance report please refer to performance.md under the same path.

### **Boot Log**

```

```
---

