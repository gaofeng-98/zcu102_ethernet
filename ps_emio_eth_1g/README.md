# PS 1000BASE-X via EMIO v2022.1

## **Design Summary**

This project utilizes PS-GEM over EMIO to a 1G/2.5G Ethernet PCS/PMA or SGMII core. The core is configured for 1000BASE-X operation. This has been routed to the SFP cage on SFP0 for use on a ZCU102 board. System is configured to use the ZCU102 si570 at 156.25MHz.

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

`petalinux-create -t project -s ps_mio_eth_1g.bsp -n psemio_plnx`

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

1. Two patches are included in the PetaLinux project to address a clocking/reset issue involving the PCS/PMA IP. More information about the reset issue can be found in AR# 72806:

    https://www.xilinx.com/support/answers/72806.html

2. On boot, the following error will be seen:

    `[    6.929736] macb ff0b0000.ethernet eth0: unable to generate target frequency: 125000000 Hz`

    This can be safely ignored.

---

## **Validation**

### **Performance:**
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.

These performance numbers reflect an MTU of 1500.
```
xilinx-zcu102-20221:~$ iperf3 -c 192.168.1.2
Connecting to host 192.168.1.2, port 5201
[  5] local 192.168.1.10 port 56236 connected to 192.168.1.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   113 MBytes   950 Mbits/sec    0    214 KBytes
[  5]   1.00-2.00   sec   109 MBytes   914 Mbits/sec    0    214 KBytes
[  5]   2.00-3.00   sec   112 MBytes   941 Mbits/sec    0    214 KBytes
[  5]   3.00-4.00   sec   103 MBytes   862 Mbits/sec    0    214 KBytes
[  5]   4.00-5.00   sec   111 MBytes   931 Mbits/sec    0    214 KBytes
[  5]   5.00-6.00   sec   110 MBytes   926 Mbits/sec    0    214 KBytes
[  5]   6.00-7.00   sec   111 MBytes   934 Mbits/sec    0    214 KBytes
[  5]   7.00-8.00   sec   112 MBytes   938 Mbits/sec    0    214 KBytes
[  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec    0    214 KBytes
[  5]   9.00-10.00  sec   111 MBytes   928 Mbits/sec    0    214 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.08 GBytes   926 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  1.08 GBytes   925 Mbits/sec                  receiver

iperf Done.
```
---


## **Boot Log**
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
Net:
ZYNQ GEM: ff0b0000, mdio bus ff0b0000, phyaddr 9, interface gmii
zynq_gem ethernet@ff0b0000: Failed to read eth PHY id, err: -2
eth0: ethernet@ff0b0000
scanning bus for devices...
Hit any key to stop autoboot:  0
switch to partitions #0, OK
mmc0 is current device
Scanning mmc 0:1...
Found U-Boot script /boot.scr
2777 bytes read in 21 ms (128.9 KiB/s)
## Executing script at 20000000
Trying to load boot images from mmc0
39593672 bytes read in 2630 ms (14.4 MiB/s)
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
     Hash value:   92e0bd3b70ecc24cdd77804508e8183aab65b7f8829d0712f0ea585b5323dba7
   Verifying Hash Integrity ... sha256+ OK
## Loading ramdisk from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'ramdisk-1' ramdisk subimage
     Description:  petalinux-image-minimal
     Created:      2022-04-11  17:52:14 UTC
     Type:         RAMDisk Image
     Compression:  uncompressed
     Data Start:   0x10949a88
     Data Size:    29853381 Bytes = 28.5 MiB
     Architecture: AArch64
     OS:           Linux
     Load Address: unavailable
     Entry Point:  unavailable
     Hash algo:    sha256
     Hash value:   50ca2c271cf02072627d38ef8dbd030345f9153b27e08a9b1329407e0d52808a
   Verifying Hash Integrity ... sha256+ OK
## Loading fdt from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'fdt-system-top.dtb' fdt subimage
     Description:  Flattened Device Tree blob
     Created:      2022-04-11  17:52:14 UTC
     Type:         Flat Device Tree
     Compression:  uncompressed
     Data Start:   0x1093bf20
     Data Size:    55959 Bytes = 54.6 KiB
     Architecture: AArch64
     Hash algo:    sha256
     Hash value:   754769f0c165f379bc9010feb4bc18e8e8d21f26d16416b7f979333ec822bdbc
   Verifying Hash Integrity ... sha256+ OK
   Booting using the fdt blob at 0x1093bf20
   Uncompressing Kernel Image
   Loading Ramdisk to 79f81000, end 7bbf96c5 ... OK
   Loading Device Tree to 000000007feef000, end 000000007feffa96 ... OK

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
[    0.000000] software IO TLB: mapped [mem 0x000000007beef000-0x000000007feef000] (64MB)
[    0.000000] Memory: 3732704K/4193280K available (14528K kernel code, 1012K rwdata, 4056K rodata, 2176K init, 571K bss, 198432K reserved, 262144K cma-reserved)
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu:     RCU event tracing is enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GIC: Adjusting CPU interface base to 0x00000000f902f000
[    0.000000] Root IRQ handler: gic_handle_irq
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] random: get_random_bytes called from start_kernel+0x474/0x6d4 with crng_init=0
[    0.000000] arch_timer: cp15 timer(s) running at 99.99MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x171015c90f, max_idle_ns: 440795203080 ns
[    0.000000] sched_clock: 56 bits at 99MHz, resolution 10ns, wraps every 4398046511101ns
[    0.008374] Console: colour dummy device 80x25
[    0.012400] Calibrating delay loop (skipped), value calculated using timer frequency.. 199.99 BogoMIPS (lpj=399996)
[    0.022753] pid_max: default: 32768 minimum: 301
[    0.027529] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.034701] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.043539] rcu: Hierarchical SRCU implementation.
[    0.047572] EFI services will not be available.
[    0.051884] smp: Bringing up secondary CPUs ...
[    0.056621] Detected VIPT I-cache on CPU1
[    0.056662] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.057090] Detected VIPT I-cache on CPU2
[    0.057117] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[    0.057512] Detected VIPT I-cache on CPU3
[    0.057537] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[    0.057585] smp: Brought up 1 node, 4 CPUs
[    0.091693] SMP: Total of 4 processors activated.
[    0.096365] CPU features: detected: 32-bit EL0 Support
[    0.101469] CPU features: detected: CRC32 instructions
[    0.106611] CPU: All CPU(s) started at EL2
[    0.110651] alternatives: patching kernel code
[    0.116178] devtmpfs: initialized
[    0.125659] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.129766] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.145181] pinctrl core: initialized pinctrl subsystem
[    0.145681] DMI not present or invalid.
[    0.148829] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.155527] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic allocations
[    0.161565] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.169374] audit: initializing netlink subsys (disabled)
[    0.174782] audit: type=2000 audit(0.116:1): state=initialized audit_enabled=0 res=1
[    0.175149] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.189205] ASID allocator initialised with 65536 entries
[    0.194617] Serial: AMBA PL011 UART driver
[    0.219862] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.220923] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    0.227596] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.234270] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    1.407902] cryptd: max_cpu_qlen set to 1000
[    1.434440] DRBG: Continuing without Jitter RNG
[    1.541875] raid6: neonx8   gen()  1950 MB/s
[    1.609928] raid6: neonx8   xor()  1455 MB/s
[    1.678002] raid6: neonx4   gen()  1997 MB/s
[    1.746064] raid6: neonx4   xor()  1425 MB/s
[    1.814144] raid6: neonx2   gen()  1893 MB/s
[    1.882200] raid6: neonx2   xor()  1312 MB/s
[    1.950286] raid6: neonx1   gen()  1617 MB/s
[    2.018335] raid6: neonx1   xor()  1111 MB/s
[    2.086409] raid6: int64x8  gen()  1252 MB/s
[    2.154474] raid6: int64x8  xor()   709 MB/s
[    2.222551] raid6: int64x4  gen()  1465 MB/s
[    2.290608] raid6: int64x4  xor()   777 MB/s
[    2.358684] raid6: int64x2  gen()  1280 MB/s
[    2.426761] raid6: int64x2  xor()   688 MB/s
[    2.494830] raid6: int64x1  gen()   946 MB/s
[    2.562898] raid6: int64x1  xor()   474 MB/s
[    2.562938] raid6: using algorithm neonx4 gen() 1997 MB/s
[    2.566890] raid6: .... xor() 1425 MB/s, rmw enabled
[    2.571820] raid6: using neon recovery algorithm
[    2.576933] iommu: Default domain type: Translated
[    2.581255] iommu: DMA domain TLB invalidation policy: strict mode
[    2.587705] SCSI subsystem initialized
[    2.591340] usbcore: registered new interface driver usbfs
[    2.596675] usbcore: registered new interface driver hub
[    2.601949] usbcore: registered new device driver usb
[    2.606995] mc: Linux media interface: v0.10
[    2.611196] videodev: Linux video capture interface: v2.00
[    2.616665] pps_core: LinuxPPS API ver. 1 registered
[    2.621559] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.630650] PTP clock support registered
[    2.634555] EDAC MC: Ver: 3.0.0
[    2.637937] zynqmp-ipi-mbox mailbox@ff990400: Registered ZynqMP IPI mbox with TX/RX channels.
[    2.646330] FPGA manager framework
[    2.649623] Advanced Linux Sound Architecture Driver Initialized.
[    2.655881] Bluetooth: Core ver 2.22
[    2.659111] NET: Registered PF_BLUETOOTH protocol family
[    2.664378] Bluetooth: HCI device and connection manager initialized
[    2.670695] Bluetooth: HCI socket layer initialized
[    2.675537] Bluetooth: L2CAP socket layer initialized
[    2.680559] Bluetooth: SCO socket layer initialized
[    2.685726] clocksource: Switched to clocksource arch_sys_counter
[    2.691594] VFS: Disk quotas dquot_6.6.0
[    2.695381] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.706985] NET: Registered PF_INET protocol family
[    2.707153] IP idents hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    2.716079] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
[    2.722896] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    2.730942] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    2.738396] TCP: Hash tables configured (established 32768 bind 32768)
[    2.744546] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.751214] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.758375] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    2.764184] RPC: Registered named UNIX socket transport module.
[    2.769744] RPC: Registered udp transport module.
[    2.774409] RPC: Registered tcp transport module.
[    2.779077] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.786132] PCI: CLS 0 bytes, default 64
[    2.789527] Trying to unpack rootfs image as initramfs...
[    2.795525] armv8-pmu pmu: hw perfevents: no interrupt-affinity property, guessing.
[    2.802701] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counters available
[    4.269147] Freeing initrd memory: 29152K
[    4.332524] Initialise system trusted keyrings
[    4.332654] workingset: timestamp_bits=46 max_order=20 bucket_order=0
[    4.338471] NFS: Registering the id_resolver key type
[    4.342767] Key type id_resolver registered
[    4.346906] Key type id_legacy registered
[    4.350905] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    4.357546] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    4.364912] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    4.411154] NET: Registered PF_ALG protocol family
[    4.411206] xor: measuring software checksum speed
[    4.419616]    8regs           :  2166 MB/sec
[    4.423498]    32regs          :  2565 MB/sec
[    4.428367]    arm64_neon      :  2114 MB/sec
[    4.428407] xor: using function: 32regs (2565 MB/sec)
[    4.433062] Key type asymmetric registered
[    4.437126] Asymmetric key parser 'x509' registered
[    4.442005] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 244)
[    4.449326] io scheduler mq-deadline registered
[    4.453827] io scheduler kyber registered
[    4.487472] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.489348] Serial: AMBA driver
[    4.492219] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    4.501936] brd: module loaded
[    4.505631] loop: module loaded
[    4.506621] mtdoops: mtd device (mtddev=name/number) must be supplied
[    4.512941] tun: Universal TUN/TAP device driver, 1.6
[    4.515023] CAN device driver interface
[    4.519454] SPI driver wl1271_spi has no spi_device_id for ti,wl1271
[    4.525052] SPI driver wl1271_spi has no spi_device_id for ti,wl1273
[    4.531361] SPI driver wl1271_spi has no spi_device_id for ti,wl1281
[    4.537673] SPI driver wl1271_spi has no spi_device_id for ti,wl1283
[    4.543988] SPI driver wl1271_spi has no spi_device_id for ti,wl1285
[    4.550302] SPI driver wl1271_spi has no spi_device_id for ti,wl1801
[    4.556618] SPI driver wl1271_spi has no spi_device_id for ti,wl1805
[    4.562933] SPI driver wl1271_spi has no spi_device_id for ti,wl1807
[    4.569246] SPI driver wl1271_spi has no spi_device_id for ti,wl1831
[    4.575560] SPI driver wl1271_spi has no spi_device_id for ti,wl1835
[    4.581875] SPI driver wl1271_spi has no spi_device_id for ti,wl1837
[    4.588282] usbcore: registered new interface driver asix
[    4.593590] usbcore: registered new interface driver ax88179_178a
[    4.599637] usbcore: registered new interface driver cdc_ether
[    4.605429] usbcore: registered new interface driver net1080
[    4.611049] usbcore: registered new interface driver cdc_subset
[    4.616929] usbcore: registered new interface driver zaurus
[    4.622478] usbcore: registered new interface driver cdc_ncm
[    4.628859] usbcore: registered new interface driver uas
[    4.633383] usbcore: registered new interface driver usb-storage
[    4.639995] rtc_zynqmp ffa60000.rtc: registered as rtc0
[    4.644515] rtc_zynqmp ffa60000.rtc: setting system clock to 2022-11-10T11:28:15 UTC (1668079695)
[    4.653384] i2c_dev: i2c /dev entries driver
[    4.659415] usbcore: registered new interface driver uvcvideo
[    4.664253] Bluetooth: HCI UART driver ver 2.3
[    4.667689] Bluetooth: HCI UART protocol H4 registered
[    4.672789] Bluetooth: HCI UART protocol BCSP registered
[    4.678081] Bluetooth: HCI UART protocol LL registered
[    4.683170] Bluetooth: HCI UART protocol ATH3K registered
[    4.688546] Bluetooth: HCI UART protocol Three-wire (H5) registered
[    4.694800] Bluetooth: HCI UART protocol Intel registered
[    4.700137] Bluetooth: HCI UART protocol QCA registered
[    4.705352] usbcore: registered new interface driver bcm203x
[    4.710961] usbcore: registered new interface driver bpa10x
[    4.716496] usbcore: registered new interface driver bfusb
[    4.721951] usbcore: registered new interface driver btusb
[    4.727416] usbcore: registered new interface driver ath3k
[    4.732907] EDAC MC: ECC not enabled
[    4.736503] EDAC DEVICE0: Giving out device to module edac controller cache_err: DEV edac (POLLED)
[    4.745450] EDAC DEVICE1: Giving out device to module zynqmp-ocm-edac controller zynqmp_ocm: DEV ff960000.memory-controller (INTERRUPT)
[    4.757821] sdhci: Secure Digital Host Controller Interface driver
[    4.763532] sdhci: Copyright(c) Pierre Ossman
[    4.767853] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.773879] ledtrig-cpu: registered to indicate activity on CPUs
[    4.779553] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
[    4.785920] zynqmp_firmware_probe Platform Management API v1.1
[    4.791645] zynqmp_firmware_probe Trustzone version v1.0
[    4.828562] securefw securefw: securefw probed
[    4.828859] alg: No test for xilinx-zynqmp-aes (zynqmp-aes)
[    4.833027] zynqmp_aes firmware:zynqmp-firmware:zynqmp-aes: AES Successfully Registered
[    4.841161] alg: No test for xilinx-keccak-384 (zynqmp-keccak-384)
[    4.847300] alg: No test for xilinx-zynqmp-rsa (zynqmp-rsa)
[    4.852797] usbcore: registered new interface driver usbhid
[    4.858176] usbhid: USB HID core driver
[    4.865223] ARM CCI_400_r1 PMU driver probed
[    4.865932] fpga_manager fpga0: Xilinx ZynqMP FPGA Manager registered
[    4.873066] usbcore: registered new interface driver snd-usb-audio
[    4.879643] pktgen: Packet Generator for packet performance testing. Version: 2.75
[    4.887082] Initializing XFRM netlink socket
[    4.890596] NET: Registered PF_INET6 protocol family
[    4.895927] Segment Routing with IPv6
[    4.899106] In-situ OAM (IOAM) with IPv6
[    4.903048] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    4.909203] NET: Registered PF_PACKET protocol family
[    4.913891] NET: Registered PF_KEY protocol family
[    4.918647] can: controller area network core
[    4.922985] NET: Registered PF_CAN protocol family
[    4.927717] can: raw protocol
[    4.930659] can: broadcast manager protocol
[    4.934813] can: netlink gateway - max_hops=1
[    4.939221] Bluetooth: RFCOMM TTY layer initialized
[    4.943990] Bluetooth: RFCOMM socket layer initialized
[    4.949091] Bluetooth: RFCOMM ver 1.11
[    4.952806] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.958077] Bluetooth: BNEP filters: protocol multicast
[    4.963271] Bluetooth: BNEP socket layer initialized
[    4.968197] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.974081] Bluetooth: HIDP socket layer initialized
[    4.979039] 8021q: 802.1Q VLAN Support v1.8
[    4.983279] 9pnet: Installing 9P2000 support
[    4.987421] Key type dns_resolver registered
[    4.991755] registered taskstats version 1
[    4.995709] Loading compiled-in X.509 certificates
[    5.001607] Btrfs loaded, crc32c=crc32c-generic, zoned=no, fsverity=no
[    5.016314] ff000000.serial: ttyPS0 at MMIO 0xff000000 (irq = 47, base_baud = 6249999) is a xuartps
[    5.025346] printk: console [ttyPS0] enabled
[    5.025346] printk: console [ttyPS0] enabled
[    5.029649] printk: bootconsole [cdns0] disabled
[    5.029649] printk: bootconsole [cdns0] disabled
[    5.039233] ff010000.serial: ttyPS1 at MMIO 0xff010000 (irq = 48, base_baud = 6249999) is a xuartps
[    5.052412] of-fpga-region fpga-full: FPGA Region probed
[    5.059150] xilinx-zynqmp-dma fd500000.dma-controller: ZynqMP DMA driver Probe success
[    5.067259] xilinx-zynqmp-dma fd510000.dma-controller: ZynqMP DMA driver Probe success
[    5.075361] xilinx-zynqmp-dma fd520000.dma-controller: ZynqMP DMA driver Probe success
[    5.083462] xilinx-zynqmp-dma fd530000.dma-controller: ZynqMP DMA driver Probe success
[    5.091558] xilinx-zynqmp-dma fd540000.dma-controller: ZynqMP DMA driver Probe success
[    5.099668] xilinx-zynqmp-dma fd550000.dma-controller: ZynqMP DMA driver Probe success
[    5.107769] xilinx-zynqmp-dma fd560000.dma-controller: ZynqMP DMA driver Probe success
[    5.115868] xilinx-zynqmp-dma fd570000.dma-controller: ZynqMP DMA driver Probe success
[    5.124029] xilinx-zynqmp-dma ffa80000.dma-controller: ZynqMP DMA driver Probe success
[    5.132127] xilinx-zynqmp-dma ffa90000.dma-controller: ZynqMP DMA driver Probe success
[    5.140219] xilinx-zynqmp-dma ffaa0000.dma-controller: ZynqMP DMA driver Probe success
[    5.148324] xilinx-zynqmp-dma ffab0000.dma-controller: ZynqMP DMA driver Probe success
[    5.156420] xilinx-zynqmp-dma ffac0000.dma-controller: ZynqMP DMA driver Probe success
[    5.164519] xilinx-zynqmp-dma ffad0000.dma-controller: ZynqMP DMA driver Probe success
[    5.172615] xilinx-zynqmp-dma ffae0000.dma-controller: ZynqMP DMA driver Probe success
[    5.180713] xilinx-zynqmp-dma ffaf0000.dma-controller: ZynqMP DMA driver Probe success
[    5.188969] macb ff0b0000.ethernet: Not enabling partial store and forward
[    5.199339] macb ff0b0000.ethernet eth0: Cadence GEM rev 0x50070106 at 0xff0b0000 irq 38 (00:0a:35:00:22:01)
[    5.209672] xilinx-axipmon ffa00000.perf-monitor: Probed Xilinx APM
[    5.216227] xilinx-axipmon fd0b0000.perf-monitor: Probed Xilinx APM
[    5.222725] xilinx-axipmon fd490000.perf-monitor: Probed Xilinx APM
[    5.229235] xilinx-axipmon ffa10000.perf-monitor: Probed Xilinx APM
[    5.232867] zynqmp_pll_disable() clock disable failed for apll_int, ret = -13
[    5.242938] pca953x 0-0020: supply vcc not found, using dummy regulator
[    5.249636] pca953x 0-0020: using no AI
[    5.254180] pca953x 0-0021: supply vcc not found, using dummy regulator
[    5.260862] pca953x 0-0021: using no AI
[    5.274162] i2c i2c-0: Added multiplexed i2c bus 2
[    5.285861] i2c i2c-0: Added multiplexed i2c bus 3
[    5.306070] random: fast init done
[    5.344549] i2c i2c-0: Added multiplexed i2c bus 4
[    5.349470] i2c i2c-0: Added multiplexed i2c bus 5
[    5.354265] pca954x 0-0075: registered 4 multiplexed busses for I2C mux pca9544
[    5.361625] cdns-i2c ff020000.i2c: 400 kHz mmio ff020000 irq 40
[    5.369032] at24 6-0054: supply vcc not found, using dummy regulator
[    5.375938] at24 6-0054: 1024 byte 24c08 EEPROM, writable, 1 bytes/write
[    5.382682] i2c i2c-1: Added multiplexed i2c bus 6
[    5.388056] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.395366] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.402670] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.409971] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.417285] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.424588] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.431897] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.439210] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.447640] si5341 7-0036: Chip: 5341 Grade: 1 Rev: 1
[    5.486932] i2c i2c-1: Added multiplexed i2c bus 7
[    5.494689] si570 8-005d: registered, current frequency 300000000 Hz
[    5.501083] i2c i2c-1: Added multiplexed i2c bus 8
[    5.508813] si570 9-005d: registered, current frequency 156250000 Hz
[    5.515206] i2c i2c-1: Added multiplexed i2c bus 9
[    5.520226] si5324 10-0069: si5328 probed
[    5.586485] si5324 10-0069: si5328 probe successful
[    5.591404] i2c i2c-1: Added multiplexed i2c bus 10
[    5.596411] i2c i2c-1: Added multiplexed i2c bus 11
[    5.601415] i2c i2c-1: Added multiplexed i2c bus 12
[    5.606426] i2c i2c-1: Added multiplexed i2c bus 13
[    5.611306] pca954x 1-0074: registered 8 multiplexed busses for I2C switch pca9548
[    5.619266] i2c i2c-1: Added multiplexed i2c bus 14
[    5.624287] i2c i2c-1: Added multiplexed i2c bus 15
[    5.629298] i2c i2c-1: Added multiplexed i2c bus 16
[    5.634313] i2c i2c-1: Added multiplexed i2c bus 17
[    5.639333] i2c i2c-1: Added multiplexed i2c bus 18
[    5.644348] i2c i2c-1: Added multiplexed i2c bus 19
[    5.649359] i2c i2c-1: Added multiplexed i2c bus 20
[    5.654385] i2c i2c-1: Added multiplexed i2c bus 21
[    5.659265] pca954x 1-0075: registered 8 multiplexed busses for I2C switch pca9548
[    5.666868] cdns-i2c ff030000.i2c: 400 kHz mmio ff030000 irq 41
[    5.676878] cdns-wdt fd4d0000.watchdog: Xilinx Watchdog Timer with timeout 60s
[    5.684353] cdns-wdt ff150000.watchdog: Xilinx Watchdog Timer with timeout 10s
[    5.692041] cpufreq: cpufreq_online: CPU0: Running at unlisted initial frequency: 1099999 KHz, changing to: 1099989 KHz
[    5.706716] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    5.713774] of_cfs_init
[    5.716235] of_cfs_init: OK
[    5.719198] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    5.737595] mmc0: SDHCI controller on ff170000.mmc [ff170000.mmc] using ADMA 64-bit
[    5.781636] mmc0: new high speed SDXC card at address aaaa
[    5.787523] mmcblk0: mmc0:aaaa SD64G 59.5 GiB
[    5.793603]  mmcblk0: p1
[    5.872036] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    5.878569] clk: Not disabling unused clocks
[    5.883058] ALSA device list:
[    5.886021]   No soundcards found.
[    5.889707] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    5.898332] cfg80211: failed to load regulatory.db
[    5.903669] Freeing unused kernel memory: 2176K
[    5.937774] Run /init as init process
[    5.955668] systemd[1]: systemd 249.7+ running in system mode (+PAM -AUDIT -SELINUX -APPARMOR +IMA -SMACK +SECCOMP -GCRYPT -GNUTLS -OPENSSL +ACL +BLKID -CURL -ELFUTILS -FIDO2 -IDN2 -IDN -IPTC +KMOD -LIBCRYPTSETUP +LIBFDISK -PCRE2 -PWQUALITY -P11KIT -QRENCODE -BZIP2 -LZ4 -XZ -ZLIB +ZSTD +XKBCOMMON +UTMP +SYSVINIT default-hierarchy=hybrid)
[    5.986049] systemd[1]: Detected architecture arm64.

Welcome to PetaLinux 2022.1_release_S04190222 (honister)!

[    6.021863] systemd[1]: Hostname set to <xilinx-zcu102-20221>.
[    6.027810] random: systemd: uninitialized urandom read (16 bytes read)
[    6.034457] systemd[1]: Initializing machine ID from random generator.
[    6.069496] systemd-sysv-generator[235]: SysV service '/etc/init.d/watchdog-init' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    6.097146] systemd-sysv-generator[235]: SysV service '/etc/init.d/nfsserver' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    6.121168] systemd-sysv-generator[235]: SysV service '/etc/init.d/nfscommon' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    6.145513] systemd-sysv-generator[235]: SysV service '/etc/init.d/inetd.busybox' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    6.170633] systemd-sysv-generator[235]: SysV service '/etc/init.d/dropbear' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    6.407902] systemd[1]: Queued start job for default target Multi-User System.
[    6.416043] random: systemd: uninitialized urandom read (16 bytes read)
[    6.451151] systemd[1]: Created slice Slice /system/getty.
[  OK  ] Created slice Slice /system/getty.
[    6.473837] random: systemd: uninitialized urandom read (16 bytes read)
[    6.481864] systemd[1]: Created slice Slice /system/modprobe.
[  OK  ] Created slice Slice /system/modprobe.
[    6.503093] systemd[1]: Created slice Slice /system/serial-getty.
[  OK  ] Created slice Slice /system/serial-getty.
[    6.526939] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[    6.550006] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[  OK  ] Started Dispatch Password …ts to Console Directory Watch.
[    6.573943] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Started Forward Password R…uests to Wall Directory Watch.
[    6.597969] systemd[1]: Reached target Path Units.
[  OK  ] Reached target Path Units.
[    6.613843] systemd[1]: Reached target Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[    6.633834] systemd[1]: Reached target Slice Units.
[  OK  ] Reached target Slice Units.
[    6.649852] systemd[1]: Reached target Swaps.
[  OK  ] Reached target Swaps.
[    6.666293] systemd[1]: Listening on RPCbind Server Activation Socket.
[  OK  ] Listening on RPCbind Server Activation Socket.
[    6.689837] systemd[1]: Reached target RPC Port Mapper.
[  OK  ] Reached target RPC Port Mapper.
[    6.710088] systemd[1]: Listening on Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[    6.725988] systemd[1]: Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[    6.750315] systemd[1]: Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Audit Socket.
[    6.770043] systemd[1]: Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket (/dev/log).
[    6.790119] systemd[1]: Listening on Journal Socket.
[  OK  ] Listening on Journal Socket.
[    6.806271] systemd[1]: Listening on Network Service Netlink Socket.
[  OK  ] Listening on Network Service Netlink Socket.
[    6.830126] systemd[1]: Listening on udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[    6.850036] systemd[1]: Listening on udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[    6.870069] systemd[1]: Listening on User Database Manager Socket.
[  OK  ] Listening on User Database Manager Socket.
[    6.896481] systemd[1]: Mounting Huge Pages File System...
         Mounting Huge Pages File System...
[    6.916494] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[    6.940627] systemd[1]: Mounting Kernel Debug File System...
         Mounting Kernel Debug File System...
[    6.958160] systemd[1]: Condition check resulted in Kernel Trace File System being skipped.
[    6.969445] systemd[1]: Mounting Temporary Directory /tmp...
         Mounting Temporary Directory /tmp...
[    6.986068] systemd[1]: Condition check resulted in Create List of Static Device Nodes being skipped.
[    6.998437] systemd[1]: Starting Load Kernel Module configfs...
         Starting Load Kernel Module configfs...
[    7.017090] systemd[1]: Starting Load Kernel Module drm...
         Starting Load Kernel Module drm...
[    7.036835] systemd[1]: Starting Load Kernel Module fuse...
         Starting Load Kernel Module fuse...
[    7.056978] systemd[1]: Starting RPC Bind...
         Starting RPC Bind...
[    7.069939] systemd[1]: Condition check resulted in File System Check on Root Device being skipped.
[    7.079755] systemd[1]: Condition check resulted in Load Kernel Modules being skipped.
[    7.090194] systemd[1]: Mounting NFSD configuration filesystem...
         Mounting NFSD configuration filesystem...
[    7.108793] systemd[1]: Starting Remount Root and Kernel File Systems...
         Starting Remount Root and Kernel File Systems...
[    7.132803] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[    7.152824] systemd[1]: Starting Coldplug All udev Devices...
         Starting Coldplug All udev Devices...
[    7.178700] systemd[1]: Started RPC Bind.
[  OK  ] Started RPC Bind.
[    7.194298] systemd[1]: Mounted Huge Pages File System.
[  OK  ] Mounted Huge Pages File System.
[    7.218266] systemd[1]: Mounted POSIX Message Queue File System.
[  OK  ] Mounted POSIX Message Queue File System.
[    7.246266] systemd[1]: Mounted Kernel Debug File System.
[  OK  ] Mounted Kernel Debug File System.
[    7.266300] systemd[1]: Mounted Temporary Directory /tmp.
[  OK  ] Mounted Temporary Directory /tmp.
[    7.290886] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[    7.299283] systemd[1]: Finished Load Kernel Module configfs.
[  OK  ] Finished Load Kernel Module configfs.
[    7.322548] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    7.330603] systemd[1]: Finished Load Kernel Module drm.
[  OK  ] Finished Load Kernel Module drm.
[    7.354539] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[    7.362599] systemd[1]: Finished Load Kernel Module fuse.
[  OK  ] Finished Load Kernel Module fuse.
[    7.386238] systemd[1]: proc-fs-nfsd.mount: Mount process exited, code=exited, status=32/n/a
[    7.394752] systemd[1]: proc-fs-nfsd.mount: Failed with result 'exit-code'.
[    7.403026] systemd[1]: Failed to mount NFSD configuration filesystem.
[FAILED] Failed to mount NFSD configuration filesystem.
See 'systemctl status proc-fs-nfsd.mount' for details.
[    7.437772] systemd[1]: Dependency failed for NFS server and services.
[DEPEND] Dependency failed for NFS server and services.
[    7.461774] systemd[1]: Dependency failed for NFS Mount Daemon.
[DEPEND] Dependency failed for NFS Mount Daemon.
[    7.481771] systemd[1]: nfs-mountd.service: Job nfs-mountd.service/start failed with result 'dependency'.
[    7.491371] systemd[1]: nfs-server.service: Job nfs-server.service/start failed with result 'dependency'.
[    7.502549] systemd[1]: Finished Remount Root and Kernel File Systems.
[  OK  ] Finished Remount Root and Kernel File Systems.
[    7.527328] systemd[1]: Finished Apply Kernel Variables.
[  OK  ] Finished Apply Kernel Variables.
[    7.552674] systemd[1]: Condition check resulted in FUSE Control File System being skipped.
[    7.564057] systemd[1]: Mounting Kernel Configuration File System...
         Mounting Kernel Configuration File System...
[    7.586093] systemd[1]: Condition check resulted in Rebuild Hardware Database being skipped.
[    7.594814] systemd[1]: Condition check resulted in Platform Persistent Storage Archival being skipped.
[    7.607408] systemd[1]: Starting Create System Users...
         Starting Create System Users...
[    7.626020] systemd[1]: Mounted Kernel Configuration File System.
[  OK  ] Mounted Kernel Configuration File System.
[    7.651784] systemd[1]: Finished Create System Users.
[  OK  ] Finished Create System Users.
[    7.669335] systemd[1]: Starting Create Static Device Nodes in /dev...
         Starting Create Static Device Nodes in /dev...
[    7.695785] systemd[1]: Finished Create Static Device Nodes in /dev.
[  OK  ] Finished Create Static Device Nodes in /dev.
[    7.718159] systemd[1]: Reached target Preparation for Local File Systems.
[  OK  ] Reached target Preparation for Local File Systems.
[    7.744792] systemd[1]: Mounting /var/volatile...
         Mounting /var/volatile...
[    7.765851] systemd[1]: Started Entropy Daemon based on the HAVEGE algorithm.
[  OK  ] Started Entropy Daemon based on the HAVEGE algorithm.
[    7.790591] systemd[1]: systemd-journald.service: unit configures an IP firewall, but the local system does not support BPF/cgroup firewalling.
[    7.803530] systemd[1]: (This warning is only shown for the first unit using IP firewalling.)
[    7.816176] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[    7.834433] systemd[1]: Starting Rule-based Manager for Device Events and Files...
         Starting Rule-based Manage…for Device Events and Files...
[    7.860351] systemd[1]: Mounted /var/volatile.
[  OK  ] Mounted /var/volatile.
[    7.874191] systemd[1]: Condition check resulted in Bind mount volatile /var/cache being skipped.
[    7.893974] systemd[1]: Condition check resulted in Bind mount volatile /var/lib being skipped.
[    7.916142] systemd[1]: Starting Load/Save Random Seed...
         Starting Load/Save Random Seed...
[    7.933946] systemd[1]: Condition check resulted in Bind mount volatile /var/spool being skipped.
[    7.953919] systemd[1]: Condition check resulted in Bind mount volatile /srv being skipped.
[    7.962486] systemd[1]: Reached target Local File Systems.
[  OK  ] Reached target Local File Systems.
[    7.981065] systemd[1]: Starting Rebuild Dynamic Linker Cache...
         Starting Rebuild Dynamic Linker Cache...
[    7.998681] systemd[1]: Started Journal Service.
[  OK  ] Started Journal Service.
[  OK  ] Started Rule-based Manager for Device Events and Files.
[  OK  ] Finished Coldplug All udev Devices.
[  OK  ] Finished Rebuild Dynamic Linker Cache.
         Starting Flush Journal to Persistent Storage...
[    8.083022] systemd-journald[267]: Received client request to flush runtime journal.
         Starting Network Configuration...
[  OK  ] Finished Flush Journal to Persistent Storage.
         Starting Create Volatile Files and Directories...
[  OK  ] Finished Create Volatile Files and Directories.
         Starting Run pending postinsts...
         Starting Rebuild Journal Catalog...
         Starting Network Time Synchronization...
         Starting Record System Boot/Shutdown in UTMP...
[    8.301659] Unloading old XRT Linux kernel modules
[    8.369842] Loading new XRT Linux kernel modules
[  OK  ] Finished Record System Boot/Shutdown in UTMP.
[    8.398276] zocl: loading out-of-tree module taints kernel.
[    8.517099] INFO: Creating ICD entry for Xilinx Platform
[  OK  ] Finished Rebuild Journal Catalog.
[  OK  ] Started Network Configuration.
[    8.861542] macb ff0b0000.ethernet eth0: PHY [ff0b0000.ethernet-ffffffff:09] driver [Xilinx PCS/PMA PHY] (irq=POLL)
[    8.890521] macb ff0b0000.ethernet eth0: configuring for phy/gmii link mode
[    8.913784] pps pps0: new PPS source ptp0
[    8.925890] macb ff0b0000.ethernet: gem-ptp-timer ptp clock registered.
[  OK  ] Finished Run pending postinsts.
[  OK  ] Listening on Load/Save RF …itch Status /dev/rfkill Watch.
         Starting Network Name Resolution...
         Starting Update is Completed...
[  OK  ] Finished Update is Completed.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Created slice Slice /system/systemd-fsck.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target System Time Set.
[  OK  ] Reached target Timer Units.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Listening on dropbear.socket.
[  OK  ] Reached target Socket Units.
[  OK  ] Reached target Basic System.
[  OK  ] Started Kernel Logging Service.
[  OK  ] Started System Logging Service.
[  OK  ] Started D-Bus System Message Bus.
         Starting LSB: NFS support for both client and server...
         Starting User Login Management...
[  OK  ] Found device /dev/mmcblk0p1.
[  OK  ] Started LSB: NFS support for both client and server.
[    9.575322] random: crng init done
[    9.578743] random: 7 urandom warning(s) missed due to ratelimiting
[  OK  ] Finished Load/Save Random Seed.
[  OK  ] Started Network Name Resolution.
[    9.941965] macb ff0b0000.ethernet eth0: unable to generate target frequency: 125000000 Hz
[    9.951401] macb ff0b0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
[    9.960907] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  OK  ] Started User Login Management.
[  OK  ] Reached target Network.
[  OK  ] Reached target Host and Network Name Lookups.
         Starting inetd.busybox.service...
[  OK  ] Started NFS status monitor for NFSv2/3 locking..
         Starting LSB: Kernel NFS server support...
         Starting File System Check on /dev/mmcblk0p1...
         Starting Permit User Sessions...
         Starting Target Communication Framework agent...
[  OK  ] Started inetd.busybox.service.
[FAILED] Failed to start LSB: Kernel NFS server support.
See 'systemctl status nfsserver.service' for details.
[  OK  ] Finished File System Check on /dev/mmcblk0p1.
[  OK  ] Finished Permit User Sessions.
[  OK  ] Started Target Communication Framework agent.
         Mounting /run/media/mmcblk0p1...
[  OK  ] Started Getty on tty1.
[  OK  ] Started Serial Getty on ttyPS0.
[  OK  ] Reached target Login Prompts.
[  OK  ] Reached target Multi-User System[   10.771201] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
.
         Starting Record Runlevel Change in UTMP...
[  OK  ] Mounted /run/media/mmcblk0p1.
[  OK  ] Finished Record Runlevel Change in UTMP.

PetaLinux 2022.1_release_S04190222 xilinx-zcu102-20221 ttyPS0

xilinx-zcu102-20221 login:
```
