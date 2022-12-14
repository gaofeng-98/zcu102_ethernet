# PL 1000BASE-X v2022.1

## **Design Summary**

This project utilizes AXI 1G/2.5G Ethernet Subsystem configured for 1000BASE-X. This has been routed to the SFP cage on SFP0 for use on a ZCU102 board. System is configured to use the ZCU102 si570 at 156.25MHz.

---

## **Required Hardware**

- ZCU102
- SFP module supporting 1000BASE-X

---

## **Build Instructions**

### **Vivado:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **Vitis**:

To build the Baremetal Example Applications for this project, create a new Vitis workspace in the `Software/Vitis` directory. Once created, build a new platform project targeting your exported xsa file from Vivado.

You can now create a new application project. Select `File > New > New Application Project`

Vitis offers several Ethernet-based example application projects which leverage the LwIP Library. These can be selected on the second page of the New Application Project dialogue.

### **PetaLinux**:

Enter the `Software/PetaLinux/` directory. From the command line run the following:

`petalinux-create -t project -s pl_eth_1g.bsp -n pl_1g_plnx`

`cd psemio_plnx`

`petalinux-config --get-hw-description ../../../Hardware/pre-built/ --silentconfig`

`petalinux-build`

The PetaLinux project will be built using the configurations in the BSP.

Once the build is complete, the built images can be found in the `PetaLinux/images/linux/`
directory. To package these images for SD boot, run the following from the `PetaLinux` directory:

`petalinux-package --boot --fpga --u-boot --force`

Once packaged, the`boot.scr`, `BOOT.bin` and `image.ub` files (in the `PetaLinux/images/linux` directory) can be copied to an SD card, and used to boot.

---
## **Known Issues**

---

## **Validation**


### **Performance:**
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.

These performance numbers reflect an MTU of 1500.
```
xilinx-zcu102-20221:~$ iperf3 -c 192.168.1.2
Connecting to host 192.168.1.2, port 5201
[  5] local 192.168.1.10 port 42390 connected to 192.168.1.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   112 MBytes   937 Mbits/sec    1    212 KBytes
[  5]   1.00-2.00   sec   104 MBytes   872 Mbits/sec    0    212 KBytes
[  5]   2.00-3.00   sec   112 MBytes   937 Mbits/sec    0    212 KBytes
[  5]   3.00-4.00   sec   112 MBytes   942 Mbits/sec    0    212 KBytes
[  5]   4.00-5.00   sec   111 MBytes   928 Mbits/sec    0    212 KBytes
[  5]   5.00-6.00   sec   112 MBytes   939 Mbits/sec    0    212 KBytes
[  5]   6.00-7.00   sec   108 MBytes   908 Mbits/sec    1    212 KBytes
[  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    0    212 KBytes
[  5]   8.00-9.00   sec   112 MBytes   940 Mbits/sec    0    212 KBytes
[  5]   9.00-10.00  sec   112 MBytes   936 Mbits/sec    0    212 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.08 GBytes   927 Mbits/sec    2             sender
[  5]   0.00-10.00  sec  1.08 GBytes   927 Mbits/sec                  receiver

iperf Done.
```

### **Boot Log:**
```
Xilinx Zynq MP First Stage Boot Loader
Release 2022.1   Apr 11 2022  -  09:29:50
NOTICE:  BL31: v2.6(release):v1.1-9207-g67ca59c67
NOTICE:  BL31: Built : 03:46:40, Mar 24 2022


U-Boot 2022.01 (Apr 04 2022 - 07:53:54 +0000)

CPU:   ZynqMP
Silicon: v2
Model: ZynqMP ZCU102 Rev1.0
Board: Xilinx ZynqMP
DRAM:  4 GiB
PMUFW:  v1.1
EL Level:       EL2
Chip ID:        zu9eg
NAND:  0 MiB
MMC:   mmc@ff170000: 0
Loading Environment from FAT... *** Error - No Valid Environment Area found
*** Warning - bad env area, using default environment

In:    serial
Out:   serial
Err:   serial
Bootmode: LVL_SHFT_SD_MODE1
Reset reason:   EXTERNAL
Net:   AXI EMAC: 80000000, phyaddr 2, interface 1000base-x
axi_emac ethernet@80000000: Failed to read eth PHY id, err: -2
eth0: ethernet@80000000
scanning bus for devices...
Hit any key to stop autoboot:  0
switch to partitions #0, OK
mmc0 is current device
Scanning mmc 0:1...
Found U-Boot script /boot.scr
2777 bytes read in 20 ms (134.8 KiB/s)
## Executing script at 20000000
Trying to load boot images from mmc0
39597240 bytes read in 2548 ms (14.8 MiB/s)
## Loading kernel from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'kernel-1' kernel subimage
     Description:  Linux kernel
     Created:      2022-04-11  17:52:14 UTC
     Type:         Kernel Image
     Compression:  gzip compressed
     Data Start:   0x100000fc
     Data Size:    9682194 Bytes = 9.2 MiB
     Architecture: AArch64
     OS:           Linux
     Load Address: 0x00200000
     Entry Point:  0x00200000
     Hash algo:    sha256
     Hash value:   34517c1d29013e292bd10704a0a71e52987d622285c444caaad924b0f3c9965b
   Verifying Hash Integrity ... sha256+ OK
## Loading ramdisk from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'ramdisk-1' ramdisk subimage
     Description:  petalinux-image-minimal
     Created:      2022-04-11  17:52:14 UTC
     Type:         RAMDisk Image
     Compression:  uncompressed
     Data Start:   0x1094a580
     Data Size:    29854143 Bytes = 28.5 MiB
     Architecture: AArch64
     OS:           Linux
     Load Address: unavailable
     Entry Point:  unavailable
     Hash algo:    sha256
     Hash value:   e397016cea34b5b765ce3a4b2f7f9eeb4d03ca8afdff7d58d9942df78c312e81
   Verifying Hash Integrity ... sha256+ OK
## Loading fdt from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'fdt-system-top.dtb' fdt subimage
     Description:  Flattened Device Tree blob
     Created:      2022-04-11  17:52:14 UTC
     Type:         Flat Device Tree
     Compression:  uncompressed
     Data Start:   0x1093bf20
     Data Size:    58766 Bytes = 57.4 KiB
     Architecture: AArch64
     Hash algo:    sha256
     Hash value:   44bb01eb2a791723a95540f42632c94c9e00469afccccd0a5d3692937a06f74e
   Verifying Hash Integrity ... sha256+ OK
   Booting using the fdt blob at 0x1093bf20
   Uncompressing Kernel Image
   Loading Ramdisk to 79f80000, end 7bbf89bf ... OK
   Loading Device Tree to 000000007feee000, end 000000007feff58d ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 5.15.19-xilinx-v2022.1 (oe-user@oe-host) (aarch64-xilinx-linux-gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.37.20210721) #1 SMP Mon Apr 11 17:52:14 UTC 2022
[    0.000000] Machine model: ZynqMP ZCU102 Rev1.0
[    0.000000] earlycon: cdns0 at MMIO 0x00000000ff000000 (options '115200n8')
[    0.000000] printk: bootconsole [cdns0] enabled
[    0.000000] efi: UEFI not found.
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x0000000000000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000087fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000007fefffff]
[    0.000000]   node   0: [mem 0x0000000800000000-0x000000087fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000087fffffff]
[    0.000000] On node 0, zone Normal: 256 pages in unavailable ranges
[    0.000000] cma: Reserved 256 MiB at 0x0000000069c00000
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.2
[    0.000000] percpu: Embedded 18 pages/cpu s34776 r8192 d30760 u73728
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: detected: ARM erratum 845719
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1031940
[    0.000000] Kernel command line:  earlycon console=ttyPS0,115200 clk_ignore_unused
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] software IO TLB: mapped [mem 0x000000007beee000-0x000000007feee000] (64MB)
[    0.000000] Memory: 3732688K/4193280K available (14528K kernel code, 1012K rwdata, 4056K rodata, 2176K init, 571K bss, 198448K reserved, 262144K cma-reserved)
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu:     RCU event tracing is enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GIC: Adjusting CPU interface base to 0x00000000f902f000
[    0.000000] Root IRQ handler: gic_handle_irq
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] random: get_random_bytes called from start_kernel+0x474/0x6d4 with crng_init=0
[    0.000000] arch_timer: cp15 timer(s) running at 33.33MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x7b0074340, max_idle_ns: 440795202884 ns
[    0.000000] sched_clock: 56 bits at 33MHz, resolution 30ns, wraps every 2199023255543ns
[    0.008309] Console: colour dummy device 80x25
[    0.012396] Calibrating delay loop (skipped), value calculated using timer frequency.. 66.66 BogoMIPS (lpj=133332)
[    0.022666] pid_max: default: 32768 minimum: 301
[    0.027419] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.034613] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.043324] rcu: Hierarchical SRCU implementation.
[    0.047428] EFI services will not be available.
[    0.051774] smp: Bringing up secondary CPUs ...
[    0.056483] Detected VIPT I-cache on CPU1
[    0.056522] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.056888] Detected VIPT I-cache on CPU2
[    0.056911] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[    0.057246] Detected VIPT I-cache on CPU3
[    0.057267] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[    0.057308] smp: Brought up 1 node, 4 CPUs
[    0.091606] SMP: Total of 4 processors activated.
[    0.096277] CPU features: detected: 32-bit EL0 Support
[    0.101381] CPU features: detected: CRC32 instructions
[    0.106518] CPU: All CPU(s) started at EL2
[    0.110562] alternatives: patching kernel code
[    0.115951] devtmpfs: initialized
[    0.124636] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.128734] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.142916] pinctrl core: initialized pinctrl subsystem
[    0.143378] DMI not present or invalid.
[    0.146539] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.153103] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic allocations
[    0.159301] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.167112] audit: initializing netlink subsys (disabled)
[    0.172513] audit: type=2000 audit(0.112:1): state=initialized audit_enabled=0 res=1
[    0.172831] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.186937] ASID allocator initialised with 65536 entries
[    0.192344] Serial: AMBA PL011 UART driver
[    0.214160] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.215214] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    0.221884] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.228542] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    1.197723] cryptd: max_cpu_qlen set to 1000
[    1.220066] DRBG: Continuing without Jitter RNG
[    1.319873] raid6: neonx8   gen()  2371 MB/s
[    1.387918] raid6: neonx8   xor()  1756 MB/s
[    1.455973] raid6: neonx4   gen()  2427 MB/s
[    1.524024] raid6: neonx4   xor()  1724 MB/s
[    1.592093] raid6: neonx2   gen()  2296 MB/s
[    1.660136] raid6: neonx2   xor()  1585 MB/s
[    1.728209] raid6: neonx1   gen()  1963 MB/s
[    1.796252] raid6: neonx1   xor()  1348 MB/s
[    1.864310] raid6: int64x8  gen()  1516 MB/s
[    1.932361] raid6: int64x8  xor()   858 MB/s
[    2.000416] raid6: int64x4  gen()  1780 MB/s
[    2.068471] raid6: int64x4  xor()   947 MB/s
[    2.136544] raid6: int64x2  gen()  1552 MB/s
[    2.204596] raid6: int64x2  xor()   834 MB/s
[    2.272661] raid6: int64x1  gen()  1148 MB/s
[    2.340718] raid6: int64x1  xor()   575 MB/s
[    2.340756] raid6: using algorithm neonx4 gen() 2427 MB/s
[    2.344711] raid6: .... xor() 1724 MB/s, rmw enabled
[    2.349642] raid6: using neon recovery algorithm
[    2.354685] iommu: Default domain type: Translated
[    2.359075] iommu: DMA domain TLB invalidation policy: strict mode
[    2.365491] SCSI subsystem initialized
[    2.369145] usbcore: registered new interface driver usbfs
[    2.374496] usbcore: registered new interface driver hub
[    2.379762] usbcore: registered new device driver usb
[    2.384809] mc: Linux media interface: v0.10
[    2.389015] videodev: Linux video capture interface: v2.00
[    2.394479] pps_core: LinuxPPS API ver. 1 registered
[    2.399380] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.408470] PTP clock support registered
[    2.412373] EDAC MC: Ver: 3.0.0
[    2.415725] zynqmp-ipi-mbox mailbox@ff990400: Registered ZynqMP IPI mbox with TX/RX channels.
[    2.424124] FPGA manager framework
[    2.427425] Advanced Linux Sound Architecture Driver Initialized.
[    2.433664] Bluetooth: Core ver 2.22
[    2.436931] NET: Registered PF_BLUETOOTH protocol family
[    2.442200] Bluetooth: HCI device and connection manager initialized
[    2.448516] Bluetooth: HCI socket layer initialized
[    2.453359] Bluetooth: L2CAP socket layer initialized
[    2.458380] Bluetooth: SCO socket layer initialized
[    2.463525] clocksource: Switched to clocksource arch_sys_counter
[    2.469396] VFS: Disk quotas dquot_6.6.0
[    2.473200] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.483901] NET: Registered PF_INET protocol family
[    2.484958] IP idents hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    2.493615] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
[    2.500711] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    2.508726] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    2.516153] TCP: Hash tables configured (established 32768 bind 32768)
[    2.522363] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.529024] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.536175] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    2.541949] RPC: Registered named UNIX socket transport module.
[    2.547566] RPC: Registered udp transport module.
[    2.552231] RPC: Registered tcp transport module.
[    2.556899] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.563849] PCI: CLS 0 bytes, default 64
[    2.567320] Trying to unpack rootfs image as initramfs...
[    2.573192] armv8-pmu pmu: hw perfevents: no interrupt-affinity property, guessing.
[    2.580504] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counters available
[    3.797495] Freeing initrd memory: 29152K
[    3.850728] Initialise system trusted keyrings
[    3.850854] workingset: timestamp_bits=46 max_order=20 bucket_order=0
[    3.856563] NFS: Registering the id_resolver key type
[    3.861071] Key type id_resolver registered
[    3.865113] Key type id_legacy registered
[    3.869108] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    3.875752] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    3.883115] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    3.923228] NET: Registered PF_ALG protocol family
[    3.923277] xor: measuring software checksum speed
[    3.930895]    8regs           :  2626 MB/sec
[    3.934622]    32regs          :  3110 MB/sec
[    3.939620]    arm64_neon      :  2564 MB/sec
[    3.940103] xor: using function: 32regs (3110 MB/sec)
[    3.945126] Key type asymmetric registered
[    3.949190] Asymmetric key parser 'x509' registered
[    3.954066] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 244)
[    3.961394] io scheduler mq-deadline registered
[    3.965887] io scheduler kyber registered
[    3.994471] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.996185] Serial: AMBA driver
[    3.999063] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    4.008282] brd: module loaded
[    4.011445] loop: module loaded
[    4.012317] mtdoops: mtd device (mtddev=name/number) must be supplied
[    4.019451] tun: Universal TUN/TAP device driver, 1.6
[    4.021998] CAN device driver interface
[    4.026306] SPI driver wl1271_spi has no spi_device_id for ti,wl1271
[    4.032043] SPI driver wl1271_spi has no spi_device_id for ti,wl1273
[    4.038359] SPI driver wl1271_spi has no spi_device_id for ti,wl1281
[    4.044670] SPI driver wl1271_spi has no spi_device_id for ti,wl1283
[    4.050984] SPI driver wl1271_spi has no spi_device_id for ti,wl1285
[    4.057298] SPI driver wl1271_spi has no spi_device_id for ti,wl1801
[    4.063613] SPI driver wl1271_spi has no spi_device_id for ti,wl1805
[    4.069927] SPI driver wl1271_spi has no spi_device_id for ti,wl1807
[    4.076242] SPI driver wl1271_spi has no spi_device_id for ti,wl1831
[    4.082557] SPI driver wl1271_spi has no spi_device_id for ti,wl1835
[    4.088871] SPI driver wl1271_spi has no spi_device_id for ti,wl1837
[    4.095263] usbcore: registered new interface driver asix
[    4.100581] usbcore: registered new interface driver ax88179_178a
[    4.106627] usbcore: registered new interface driver cdc_ether
[    4.112419] usbcore: registered new interface driver net1080
[    4.118040] usbcore: registered new interface driver cdc_subset
[    4.123922] usbcore: registered new interface driver zaurus
[    4.129468] usbcore: registered new interface driver cdc_ncm
[    4.135718] usbcore: registered new interface driver uas
[    4.140373] usbcore: registered new interface driver usb-storage
[    4.146891] rtc_zynqmp ffa60000.rtc: registered as rtc0
[    4.151512] rtc_zynqmp ffa60000.rtc: setting system clock to 2022-11-10T11:23:28 UTC (1668079408)
[    4.160371] i2c_dev: i2c /dev entries driver
[    4.166103] usbcore: registered new interface driver uvcvideo
[    4.171096] Bluetooth: HCI UART driver ver 2.3
[    4.174688] Bluetooth: HCI UART protocol H4 registered
[    4.179786] Bluetooth: HCI UART protocol BCSP registered
[    4.185075] Bluetooth: HCI UART protocol LL registered
[    4.190165] Bluetooth: HCI UART protocol ATH3K registered
[    4.195538] Bluetooth: HCI UART protocol Three-wire (H5) registered
[    4.201789] Bluetooth: HCI UART protocol Intel registered
[    4.207130] Bluetooth: HCI UART protocol QCA registered
[    4.212331] usbcore: registered new interface driver bcm203x
[    4.217952] usbcore: registered new interface driver bpa10x
[    4.223487] usbcore: registered new interface driver bfusb
[    4.228943] usbcore: registered new interface driver btusb
[    4.234400] usbcore: registered new interface driver ath3k
[    4.239889] EDAC MC: ECC not enabled
[    4.243473] EDAC DEVICE0: Giving out device to module edac controller cache_err: DEV edac (POLLED)
[    4.252418] EDAC DEVICE1: Giving out device to module zynqmp-ocm-edac controller zynqmp_ocm: DEV ff960000.memory-controller (INTERRUPT)
[    4.264750] sdhci: Secure Digital Host Controller Interface driver
[    4.270525] sdhci: Copyright(c) Pierre Ossman
[    4.274850] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.280799] ledtrig-cpu: registered to indicate activity on CPUs
[    4.286539] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
[    4.292905] zynqmp_firmware_probe Platform Management API v1.1
[    4.298640] zynqmp_firmware_probe Trustzone version v1.0
[    4.331110] securefw securefw: securefw probed
[    4.331364] alg: No test for xilinx-zynqmp-aes (zynqmp-aes)
[    4.335571] zynqmp_aes firmware:zynqmp-firmware:zynqmp-aes: AES Successfully Registered
[    4.343679] alg: No test for xilinx-keccak-384 (zynqmp-keccak-384)
[    4.349814] alg: No test for xilinx-zynqmp-rsa (zynqmp-rsa)
[    4.355323] usbcore: registered new interface driver usbhid
[    4.360727] usbhid: USB HID core driver
[    4.367293] ARM CCI_400_r1 PMU driver probed
[    4.367892] fpga_manager fpga0: Xilinx ZynqMP FPGA Manager registered
[    4.375553] usbcore: registered new interface driver snd-usb-audio
[    4.382051] pktgen: Packet Generator for packet performance testing. Version: 2.75
[    4.389524] Initializing XFRM netlink socket
[    4.393137] NET: Registered PF_INET6 protocol family
[    4.398424] Segment Routing with IPv6
[    4.401655] In-situ OAM (IOAM) with IPv6
[    4.405585] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    4.411721] NET: Registered PF_PACKET protocol family
[    4.416436] NET: Registered PF_KEY protocol family
[    4.421196] can: controller area network core
[    4.425534] NET: Registered PF_CAN protocol family
[    4.430268] can: raw protocol
[    4.433209] can: broadcast manager protocol
[    4.437363] can: netlink gateway - max_hops=1
[    4.441747] Bluetooth: RFCOMM TTY layer initialized
[    4.446536] Bluetooth: RFCOMM socket layer initialized
[    4.451640] Bluetooth: RFCOMM ver 1.11
[    4.455350] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.460627] Bluetooth: BNEP filters: protocol multicast
[    4.465823] Bluetooth: BNEP socket layer initialized
[    4.470747] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.476631] Bluetooth: HIDP socket layer initialized
[    4.481585] 8021q: 802.1Q VLAN Support v1.8
[    4.485814] 9pnet: Installing 9P2000 support
[    4.489968] Key type dns_resolver registered
[    4.494294] registered taskstats version 1
[    4.498258] Loading compiled-in X.509 certificates
[    4.504039] Btrfs loaded, crc32c=crc32c-generic, zoned=no, fsverity=no
[    4.517707] ff000000.serial: ttyPS0 at MMIO 0xff000000 (irq = 46, base_baud = 6249999) is a xuartps
[    4.526737] printk: console [ttyPS0] enabled
[    4.526737] printk: console [ttyPS0] enabled
[    4.531038] printk: bootconsole [cdns0] disabled
[    4.531038] printk: bootconsole [cdns0] disabled
[    4.540559] ff010000.serial: ttyPS1 at MMIO 0xff010000 (irq = 47, base_baud = 6249999) is a xuartps
[    4.553749] of-fpga-region fpga-full: FPGA Region probed
[    4.560356] xilinx-zynqmp-dma fd500000.dma-controller: ZynqMP DMA driver Probe success
[    4.568433] xilinx-zynqmp-dma fd510000.dma-controller: ZynqMP DMA driver Probe success
[    4.576501] xilinx-zynqmp-dma fd520000.dma-controller: ZynqMP DMA driver Probe success
[    4.584569] xilinx-zynqmp-dma fd530000.dma-controller: ZynqMP DMA driver Probe success
[    4.592632] xilinx-zynqmp-dma fd540000.dma-controller: ZynqMP DMA driver Probe success
[    4.600701] xilinx-zynqmp-dma fd550000.dma-controller: ZynqMP DMA driver Probe success
[    4.608769] xilinx-zynqmp-dma fd560000.dma-controller: ZynqMP DMA driver Probe success
[    4.616836] xilinx-zynqmp-dma fd570000.dma-controller: ZynqMP DMA driver Probe success
[    4.624961] xilinx-zynqmp-dma ffa80000.dma-controller: ZynqMP DMA driver Probe success
[    4.633032] xilinx-zynqmp-dma ffa90000.dma-controller: ZynqMP DMA driver Probe success
[    4.641090] xilinx-zynqmp-dma ffaa0000.dma-controller: ZynqMP DMA driver Probe success
[    4.649157] xilinx-zynqmp-dma ffab0000.dma-controller: ZynqMP DMA driver Probe success
[    4.657225] xilinx-zynqmp-dma ffac0000.dma-controller: ZynqMP DMA driver Probe success
[    4.665292] xilinx-zynqmp-dma ffad0000.dma-controller: ZynqMP DMA driver Probe success
[    4.673357] xilinx-zynqmp-dma ffae0000.dma-controller: ZynqMP DMA driver Probe success
[    4.681420] xilinx-zynqmp-dma ffaf0000.dma-controller: ZynqMP DMA driver Probe success
[    4.689564] xilinx_axienet 80000000.ethernet: TX_CSUM 2
[    4.694787] xilinx_axienet 80000000.ethernet: RX_CSUM 2
[    4.700015] xilinx_axienet 80000000.ethernet (unnamed net_device) (uninitialized): xlnx,phy-type is deprecated, Please upgrade your device tree to use phy-mode
[    4.717544] xilinx-axipmon ffa00000.perf-monitor: Probed Xilinx APM
[    4.724086] xilinx-axipmon fd0b0000.perf-monitor: Probed Xilinx APM
[    4.730549] xilinx-axipmon fd490000.perf-monitor: Probed Xilinx APM
[    4.733864] zynqmp_pll_disable() clock disable failed for dpll_int, ret = -13
[    4.744037] xilinx-axipmon ffa10000.perf-monitor: Probed Xilinx APM
[    4.751192] pca953x 0-0020: supply vcc not found, using dummy regulator
[    4.757879] pca953x 0-0020: using no AI
[    4.762366] pca953x 0-0021: supply vcc not found, using dummy regulator
[    4.769034] pca953x 0-0021: using no AI
[    4.781391] i2c i2c-0: Added multiplexed i2c bus 2
[    4.792393] i2c i2c-0: Added multiplexed i2c bus 3
[    4.811933] random: fast init done
[    4.849825] i2c i2c-0: Added multiplexed i2c bus 4
[    4.854728] i2c i2c-0: Added multiplexed i2c bus 5
[    4.859520] pca954x 0-0075: registered 4 multiplexed busses for I2C mux pca9544
[    4.866866] cdns-i2c ff020000.i2c: 400 kHz mmio ff020000 irq 39
[    4.874111] at24 6-0054: supply vcc not found, using dummy regulator
[    4.880964] at24 6-0054: 1024 byte 24c08 EEPROM, writable, 1 bytes/write
[    4.887699] i2c i2c-1: Added multiplexed i2c bus 6
[    4.893001] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.900304] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.907608] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.914909] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.922214] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.929519] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.936822] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.944127] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    4.952514] si5341 7-0036: Chip: 5341 Grade: 1 Rev: 1
[    4.990152] i2c i2c-1: Added multiplexed i2c bus 7
[    4.997698] si570 8-005d: registered, current frequency 300000000 Hz
[    5.004079] i2c i2c-1: Added multiplexed i2c bus 8
[    5.011598] si570 9-005d: registered, current frequency 156250000 Hz
[    5.017984] i2c i2c-1: Added multiplexed i2c bus 9
[    5.022956] si5324 10-0069: si5328 probed
[    5.087700] si5324 10-0069: si5328 probe successful
[    5.092607] i2c i2c-1: Added multiplexed i2c bus 10
[    5.097586] i2c i2c-1: Added multiplexed i2c bus 11
[    5.102567] i2c i2c-1: Added multiplexed i2c bus 12
[    5.107550] i2c i2c-1: Added multiplexed i2c bus 13
[    5.112426] pca954x 1-0074: registered 8 multiplexed busses for I2C switch pca9548
[    5.120339] i2c i2c-1: Added multiplexed i2c bus 14
[    5.125329] i2c i2c-1: Added multiplexed i2c bus 15
[    5.130318] i2c i2c-1: Added multiplexed i2c bus 16
[    5.135309] i2c i2c-1: Added multiplexed i2c bus 17
[    5.140300] i2c i2c-1: Added multiplexed i2c bus 18
[    5.145289] i2c i2c-1: Added multiplexed i2c bus 19
[    5.150283] i2c i2c-1: Added multiplexed i2c bus 20
[    5.155285] i2c i2c-1: Added multiplexed i2c bus 21
[    5.160162] pca954x 1-0075: registered 8 multiplexed busses for I2C switch pca9548
[    5.167757] cdns-i2c ff030000.i2c: 400 kHz mmio ff030000 irq 40
[    5.177207] cpufreq: cpufreq_online: CPU0: Running at unlisted initial frequency: 1333333 KHz, changing to: 1333320 KHz
[    5.191402] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    5.198408] of_cfs_init
[    5.200871] of_cfs_init: OK
[    5.203814] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    5.219546] mmc0: SDHCI controller on ff170000.mmc [ff170000.mmc] using ADMA 64-bit
[    5.266052] mmc0: new high speed SDXC card at address aaaa
[    5.271911] mmcblk0: mmc0:aaaa SD64G 59.5 GiB
[    5.277909]  mmcblk0: p1
[    5.331911] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    5.338443] clk: Not disabling unused clocks
[    5.342935] ALSA device list:
[    5.345892]   No soundcards found.
[    5.349558] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    5.350063] Freeing unused kernel memory: 2176K
[    5.358172] cfg80211: failed to load regulatory.db
[    5.387565] Run /init as init process
[    5.403568] systemd[1]: systemd 249.7+ running in system mode (+PAM -AUDIT -SELINUX -APPARMOR +IMA -SMACK +SECCOMP -GCRYPT -GNUTLS -OPENSSL +ACL +BLKID -CURL -ELFUTILS -FIDO2 -IDN2 -IDN -IPTC +KMOD -LIBCRYPTSETUP +LIBFDISK -PCRE2 -PWQUALITY -P11KIT -QRENCODE -BZIP2 -LZ4 -XZ -ZLIB +ZSTD +XKBCOMMON +UTMP +SYSVINIT default-hierarchy=hybrid)
[    5.433863] systemd[1]: Detected architecture arm64.

Welcome to PetaLinux 2022.1_release_S04190222 (honister)!

[    5.479687] systemd[1]: Hostname set to <xilinx-zcu102-20221>.
[    5.485609] random: systemd: uninitialized urandom read (16 bytes read)
[    5.492235] systemd[1]: Initializing machine ID from random generator.
[    5.523166] systemd-sysv-generator[234]: SysV service '/etc/init.d/watchdog-init' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    5.550294] systemd-sysv-generator[234]: SysV service '/etc/init.d/nfsserver' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    5.574341] systemd-sysv-generator[234]: SysV service '/etc/init.d/nfscommon' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    5.598668] systemd-sysv-generator[234]: SysV service '/etc/init.d/inetd.busybox' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    5.623748] systemd-sysv-generator[234]: SysV service '/etc/init.d/dropbear' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    5.823934] systemd[1]: Queued start job for default target Multi-User System.
[    5.831952] random: systemd: uninitialized urandom read (16 bytes read)
[    5.862039] systemd[1]: Created slice Slice /system/getty.
[  OK  ] Created slice Slice /system/getty.
[    5.883686] random: systemd: uninitialized urandom read (16 bytes read)
[    5.891472] systemd[1]: Created slice Slice /system/modprobe.
[  OK  ] Created slice Slice /system/modprobe.
[    5.912668] systemd[1]: Created slice Slice /system/serial-getty.
[  OK  ] Created slice Slice /system/serial-getty.
[    5.936524] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[    5.959783] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[  OK  ] Started Dispatch Password …ts to Console Directory Watch.
[    5.983703] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Started Forward Password R…uests to Wall Directory Watch.
[    6.007729] systemd[1]: Reached target Path Units.
[  OK  ] Reached target Path Units.
[    6.023623] systemd[1]: Reached target Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[    6.043607] systemd[1]: Reached target Slice Units.
[  OK  ] Reached target Slice Units.
[    6.059621] systemd[1]: Reached target Swaps.
[  OK  ] Reached target Swaps.
[    6.076000] systemd[1]: Listening on RPCbind Server Activation Socket.
[  OK  ] Listening on RPCbind Server Activation Socket.
[    6.099609] systemd[1]: Reached target RPC Port Mapper.
[  OK  ] Reached target RPC Port Mapper.
[    6.119819] systemd[1]: Listening on Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[    6.135736] systemd[1]: Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[    6.160021] systemd[1]: Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Audit Socket.
[    6.179798] systemd[1]: Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket (/dev/log).
[    6.199856] systemd[1]: Listening on Journal Socket.
[  OK  ] Listening on Journal Socket.
[    6.215992] systemd[1]: Listening on Network Service Netlink Socket.
[  OK  ] Listening on Network Service Netlink Socket.
[    6.239856] systemd[1]: Listening on udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[    6.259787] systemd[1]: Listening on udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[    6.279810] systemd[1]: Listening on User Database Manager Socket.
[  OK  ] Listening on User Database Manager Socket.
[    6.305931] systemd[1]: Mounting Huge Pages File System...
         Mounting Huge Pages File System...
[    6.325971] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[    6.350107] systemd[1]: Mounting Kernel Debug File System...
         Mounting Kernel Debug File System...
[    6.367922] systemd[1]: Condition check resulted in Kernel Trace File System being skipped.
[    6.378846] systemd[1]: Mounting Temporary Directory /tmp...
         Mounting Temporary Directory /tmp...
[    6.395857] systemd[1]: Condition check resulted in Create List of Static Device Nodes being skipped.
[    6.407864] systemd[1]: Starting Load Kernel Module configfs...
         Starting Load Kernel Module configfs...
[    6.426470] systemd[1]: Starting Load Kernel Module drm...
         Starting Load Kernel Module drm...
[    6.446274] systemd[1]: Starting Load Kernel Module fuse...
         Starting Load Kernel Module fuse...
[    6.466375] systemd[1]: Starting RPC Bind...
         Starting RPC Bind...
[    6.479734] systemd[1]: Condition check resulted in File System Check on Root Device being skipped.
[    6.489411] systemd[1]: Condition check resulted in Load Kernel Modules being skipped.
[    6.499495] systemd[1]: Mounting NFSD configuration filesystem...
         Mounting NFSD configuration filesystem...
[    6.518223] systemd[1]: Starting Remount Root and Kernel File Systems...
         Starting Remount Root and Kernel File Systems...
[    6.546295] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[    6.566260] systemd[1]: Starting Coldplug All udev Devices...
         Starting Coldplug All udev Devices...
[    6.587665] systemd[1]: Started RPC Bind.
[  OK  ] Started RPC Bind.
[    6.604115] systemd[1]: Mounted Huge Pages File System.
[  OK  ] Mounted Huge Pages File System.
[    6.624009] systemd[1]: Mounted POSIX Message Queue File System.
[  OK  ] Mounted POSIX Message Queue File System.
[    6.648018] systemd[1]: Mounted Kernel Debug File System.
[  OK  ] Mounted Kernel Debug File System.
[    6.668156] systemd[1]: Mounted Temporary Directory /tmp.
[  OK  ] Mounted Temporary Directory /tmp.
[    6.688502] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[    6.696709] systemd[1]: Finished Load Kernel Module configfs.
[  OK  ] Finished Load Kernel Module configfs.
[    6.720239] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    6.727887] systemd[1]: Finished Load Kernel Module drm.
[  OK  ] Finished Load Kernel Module drm.
[    6.748207] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[    6.755936] systemd[1]: Finished Load Kernel Module fuse.
[  OK  ] Finished Load Kernel Module fuse.
[    6.775895] systemd[1]: proc-fs-nfsd.mount: Mount process exited, code=exited, status=32/n/a
[    6.784340] systemd[1]: proc-fs-nfsd.mount: Failed with result 'exit-code'.
[    6.792420] systemd[1]: Failed to mount NFSD configuration filesystem.
[FAILED] Failed to mount NFSD configuration filesystem.
See 'systemctl status proc-fs-nfsd.mount' for details.
[    6.835566] systemd[1]: Dependency failed for NFS Mount Daemon.
[DEPEND] Dependency failed for NFS Mount Daemon.
[    6.855564] systemd[1]: Dependency failed for NFS server and services.
[DEPEND] Dependency failed for NFS server and services.
[    6.879573] systemd[1]: nfs-server.service: Job nfs-server.service/start failed with result 'dependency'.
[    6.889167] systemd[1]: nfs-mountd.service: Job nfs-mountd.service/start failed with result 'dependency'.
[    6.900110] systemd[1]: Finished Remount Root and Kernel File Systems.
[  OK  ] Finished Remount Root and Kernel File Systems.
[    6.924931] systemd[1]: Finished Apply Kernel Variables.
[  OK  ] Finished Apply Kernel Variables.
[    6.950240] systemd[1]: Condition check resulted in FUSE Control File System being skipped.
[    6.961248] systemd[1]: Mounting Kernel Configuration File System...
         Mounting Kernel Configuration File System...
[    6.983934] systemd[1]: Condition check resulted in Rebuild Hardware Database being skipped.
[    6.992569] systemd[1]: Condition check resulted in Platform Persistent Storage Archival being skipped.
[    7.004776] systemd[1]: Starting Create System Users...
         Starting Create System Users...
[    7.023155] systemd[1]: Mounted Kernel Configuration File System.
[  OK  ] Mounted Kernel Configuration File System.
[    7.045261] systemd[1]: Finished Create System Users.
[  OK  ] Finished Create System Users.
[    7.062698] systemd[1]: Starting Create Static Device Nodes in /dev...
         Starting Create Static Device Nodes in /dev...
[    7.085310] systemd[1]: Finished Create Static Device Nodes in /dev.
[  OK  ] Finished Create Static Device Nodes in /dev.
[    7.107944] systemd[1]: Reached target Preparation for Local File Systems.
[  OK  ] Reached target Preparation for Local File Systems.
[    7.134384] systemd[1]: Mounting /var/volatile...
         Mounting /var/volatile...
[    7.151051] systemd[1]: Started Entropy Daemon based on the HAVEGE algorithm.
[  OK  ] Started Entropy Daemon based on the HAVEGE algorithm.
[    7.176301] systemd[1]: systemd-journald.service: unit configures an IP firewall, but the local system does not support BPF/cgroup firewalling.
[    7.189296] systemd[1]: (This warning is only shown for the first unit using IP firewalling.)
[    7.201312] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[    7.219621] systemd[1]: Starting Rule-based Manager for Device Events and Files...
         Starting Rule-based Manage…for Device Events and Files...
[    7.245663] systemd[1]: Mounted /var/volatile.
[  OK  ] Mounted /var/volatile.
[    7.259965] systemd[1]: Condition check resulted in Bind mount volatile /var/cache being skipped.
[    7.279704] systemd[1]: Condition check resulted in Bind mount volatile /var/lib being skipped.
[    7.301882] systemd[1]: Starting Load/Save Random Seed...
         Starting Load/Save Random Seed...
[    7.319726] systemd[1]: Condition check resulted in Bind mount volatile /var/spool being skipped.
[    7.331697] systemd[1]: Condition check resulted in Bind mount volatile /srv being skipped.
[    7.340202] systemd[1]: Reached target Local File Systems.
[  OK  ] Reached target Local File Systems.
[    7.371176] systemd[1]: Starting Rebuild Dynamic Linker Cache...
         Starting Rebuild Dynamic Linker Cache...
[    7.392583] systemd[1]: Started Journal Service.
[  OK  ] Started Journal Service.
[  OK  ] Started Rule-based Manager for Device Events and Files.
[  OK  ] Finished Coldplug All udev Devices.
[  OK  ] Finished Rebuild Dynamic Linker Cache.
         Starting Flush Journal to Persistent Storage...
[    7.496506] systemd-journald[268]: Received client request to flush runtime journal.
         Starting Network Configuration...
[  OK  ] Finished Flush Journal to Persistent Storage.
         Starting Create Volatile Files and Directories...
[  OK  ] Finished Create Volatile Files and Directories.
         Starting Run pending postinsts...
         Starting Rebuild Journal Catalog...
[    7.745776] Unloading old XRT Linux kernel modules
         Starting Network Time Synchronization...
[    7.757513] Loading new XRT Linux kernel modules
[    7.770685] zocl: loading out-of-tree module taints kernel.
         Starting Record System Boot/Shutdown in UTMP...
[    7.914153] INFO: Creating ICD entry for Xilinx Platform
[  OK  ] Finished Record System Boot/Shutdown in UTMP.
[  OK  ] Finished Rebuild Journal Catalog.
[  OK  ] Started Network Configuration.
[    8.126029] xilinx_axienet 80000000.ethernet eth0: Link is Down
[    8.134206] net eth0: Promiscuous mode enabled.
[  OK  ] Finished Run pending postinsts.
[  OK  ] Started Network Time Synchronization.
[    8.599399] random: crng init done
[    8.602832] random: 7 urandom warning(s) missed due to ratelimiting
[  OK  ] Finished Load/Save Random Seed.
[  OK  ] Created slice Slice /system/systemd-fsck.
[  OK  ] Reached target System Time Set.
[  OK  ] Listening on Load/Save RF …itch Status /dev/rfkill Watch.
         Starting File System Check on /dev/mmcblk0p1...
         Starting Network Name Resolution...
         Starting Update is Completed...
[  OK  ] Finished File System Check on /dev/mmcblk0p1.
[  OK  ] Finished Update is Completed.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timer Units.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Listening on dropbear.socket.
[  OK  ] Reached target Socket Units.
[  OK  ] Reached target Basic System.
         Mounting /run/media/mmcblk0p1...
[  OK  ] Started Kernel Logging Service.
[  OK  ] Started System Logging Service.
[  OK  ] Started D-Bus System Message Bus.
[    9.434281] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
         Starting LSB: NFS support for both client and server...
         Starting User Login Management...
[  OK  ] Started Network Name Resolution.
[  OK  ] Mounted /run/media/mmcblk0p1.
[  OK  ] Started LSB: NFS support for both client and server.
[  OK  ] Reached target Network.
[  OK  ] Reached target Host and Network Name Lookups.
         Starting inetd.busybox.service...
[  OK  ] Started NFS status monitor for NFSv2/3 locking..
         Starting LSB: Kernel NFS server support...
         Starting Permit User Sessions...
         Starting Target Communication Framework agent...
[  OK  ] Started inetd.busybox.service.
[FAILED] Failed to start LSB: Kernel NFS server support.
See 'systemctl status nfsserver.service' for details.
[  OK  ] Finished Permit User Sessions.
[  OK  ] Started Target Communication Framework agent.
[  OK  ] Started User Login Management.
[  OK  ] Started Getty on tty1.
[  OK  ] Started Serial Getty on ttyPS0.
[  OK  ] Reached target Login Prompts.
[  OK  ] Reached target Multi-User System.
         Starting Record Runlevel Change in UTMP...
[  OK  ] Finished Record Runlevel Change in UTMP.

PetaLinux 2022.1_release_S04190222 xilinx-zcu102-20221 ttyPS0

xilinx-zcu102-20221 login: [   16.311670] xilinx_axienet 80000000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
[   16.320235] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   16.329596] net eth0: Promiscuous mode enabled.

xilinx-zcu102-20221 login:
```
---

