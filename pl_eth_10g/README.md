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
+ for detailed performance report and test steps please refer to `performance.md` under the same path.

### **Boot Log**

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
ZYNQ GEM: ff0e0000, mdio bus ff0e0000, phyaddr 12, interface rgmii-id
zynq_gem ethernet@ff0e0000: Failed to read eth PHY id, err: -2
eth0: ethernet@ff0e0000AXI EMAC: 80010000, phyaddr 0, interface mii
, eth1: ethernet@80010000
scanning bus for devices...
SATA link 0 timeout.
SATA link 1 timeout.
AHCI 0001.0301 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
flags: 64bit ncq pm clo only pmp fbss pio slum part ccc apst
Hit any key to stop autoboot:  0
switch to partitions #0, OK
mmc0 is current device
Scanning mmc 0:1...
Found U-Boot script /boot.scr
2777 bytes read in 20 ms (134.8 KiB/s)
## Executing script at 20000000
Trying to load boot images from mmc0
39614828 bytes read in 2586 ms (14.6 MiB/s)
## Loading kernel from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'kernel-1' kernel subimage
     Description:  Linux kernel
     Created:      2022-04-11  17:52:14 UTC
     Type:         Kernel Image
     Compression:  gzip compressed
     Data Start:   0x100000fc
     Data Size:    9687533 Bytes = 9.2 MiB
     Architecture: AArch64
     OS:           Linux
     Load Address: 0x00200000
     Entry Point:  0x00200000
     Hash algo:    sha256
     Hash value:   8190549107d13f9b5400d8ce39ff4a3d194f1de8021cb2536b75fa3fb23dc72e
   Verifying Hash Integrity ... sha256+ OK
## Loading ramdisk from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'ramdisk-1' ramdisk subimage
     Description:  petalinux-image-minimal
     Created:      2022-04-11  17:52:14 UTC
     Type:         RAMDisk Image
     Compression:  uncompressed
     Data Start:   0x1094cce0
     Data Size:    29861651 Bytes = 28.5 MiB
     Architecture: AArch64
     OS:           Linux
     Load Address: unavailable
     Entry Point:  unavailable
     Hash algo:    sha256
     Hash value:   03b87585be52bb18011956b4db6970eacabda6dc1ce1c77a960400ce0db31504
   Verifying Hash Integrity ... sha256+ OK
## Loading fdt from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'fdt-system-top.dtb' fdt subimage
     Description:  Flattened Device Tree blob
     Created:      2022-04-11  17:52:14 UTC
     Type:         Flat Device Tree
     Compression:  uncompressed
     Data Start:   0x1093d3fc
     Data Size:    63505 Bytes = 62 KiB
     Architecture: AArch64
     Hash algo:    sha256
     Hash value:   f9619871b9014016f2f915e19e161fe8b32b810832acd6be80b6f1acca23931d
   Verifying Hash Integrity ... sha256+ OK
   Booting using the fdt blob at 0x1093d3fc
   Uncompressing Kernel Image
   Loading Ramdisk to 79f7d000, end 7bbf7713 ... OK
   Loading Device Tree to 000000007feed000, end 000000007feff810 ... OK

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
[    0.000000] percpu: Embedded 18 pages/cpu s34840 r8192 d30696 u73728
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: detected: ARM erratum 845719
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1031940
[    0.000000] Kernel command line:  earlycon console=ttyPS0,115200 clk_ignore_unused root=/dev/ram0 rw
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] software IO TLB: mapped [mem 0x000000007beed000-0x000000007feed000] (64MB)
[    0.000000] Memory: 3732668K/4193280K available (14528K kernel code, 1012K rwdata, 4060K rodata, 2176K init, 571K bss, 198468K reserved, 262144K cma-reserved)
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
[    0.008344] Console: colour dummy device 80x25
[    0.012399] Calibrating delay loop (skipped), value calculated using timer frequency.. 199.99 BogoMIPS (lpj=399996)
[    0.022753] pid_max: default: 32768 minimum: 301
[    0.027521] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.034701] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.043490] rcu: Hierarchical SRCU implementation.
[    0.047546] EFI services will not be available.
[    0.051874] smp: Bringing up secondary CPUs ...
[    0.056601] Detected VIPT I-cache on CPU1
[    0.056641] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.057043] Detected VIPT I-cache on CPU2
[    0.057067] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[    0.057437] Detected VIPT I-cache on CPU3
[    0.057460] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[    0.057506] smp: Brought up 1 node, 4 CPUs
[    0.091693] SMP: Total of 4 processors activated.
[    0.096365] CPU features: detected: 32-bit EL0 Support
[    0.101470] CPU features: detected: CRC32 instructions
[    0.106610] CPU: All CPU(s) started at EL2
[    0.110651] alternatives: patching kernel code
[    0.116115] devtmpfs: initialized
[    0.125390] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.129489] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.144451] pinctrl core: initialized pinctrl subsystem
[    0.144934] DMI not present or invalid.
[    0.148060] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.154749] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic allocations
[    0.160830] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.168645] audit: initializing netlink subsys (disabled)
[    0.174053] audit: type=2000 audit(0.112:1): state=initialized audit_enabled=0 res=1
[    0.174412] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.188478] ASID allocator initialised with 65536 entries
[    0.193887] Serial: AMBA PL011 UART driver
[    0.221729] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.222802] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    0.229457] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.236117] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    1.312575] cryptd: max_cpu_qlen set to 1000
[    1.337300] DRBG: Continuing without Jitter RNG
[    1.439689] raid6: neonx8   gen()  2132 MB/s
[    1.507747] raid6: neonx8   xor()  1582 MB/s
[    1.575817] raid6: neonx4   gen()  2186 MB/s
[    1.643877] raid6: neonx4   xor()  1552 MB/s
[    1.711953] raid6: neonx2   gen()  2067 MB/s
[    1.780020] raid6: neonx2   xor()  1428 MB/s
[    1.848099] raid6: neonx1   gen()  1767 MB/s
[    1.916151] raid6: neonx1   xor()  1212 MB/s
[    1.984220] raid6: int64x8  gen()  1364 MB/s
[    2.052286] raid6: int64x8  xor()   772 MB/s
[    2.120358] raid6: int64x4  gen()  1601 MB/s
[    2.188433] raid6: int64x4  xor()   851 MB/s
[    2.256498] raid6: int64x2  gen()  1396 MB/s
[    2.324563] raid6: int64x2  xor()   747 MB/s
[    2.392640] raid6: int64x1  gen()  1033 MB/s
[    2.460702] raid6: int64x1  xor()   517 MB/s
[    2.460740] raid6: using algorithm neonx4 gen() 2186 MB/s
[    2.464693] raid6: .... xor() 1552 MB/s, rmw enabled
[    2.469628] raid6: using neon recovery algorithm
[    2.474745] iommu: Default domain type: Translated
[    2.479062] iommu: DMA domain TLB invalidation policy: strict mode
[    2.485502] SCSI subsystem initialized
[    2.489138] usbcore: registered new interface driver usbfs
[    2.494484] usbcore: registered new interface driver hub
[    2.499756] usbcore: registered new device driver usb
[    2.504796] mc: Linux media interface: v0.10
[    2.509003] videodev: Linux video capture interface: v2.00
[    2.514470] pps_core: LinuxPPS API ver. 1 registered
[    2.519367] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.528457] PTP clock support registered
[    2.532359] EDAC MC: Ver: 3.0.0
[    2.535748] zynqmp-ipi-mbox mailbox@ff990400: Registered ZynqMP IPI mbox with TX/RX channels.
[    2.544136] FPGA manager framework
[    2.547429] Advanced Linux Sound Architecture Driver Initialized.
[    2.553669] Bluetooth: Core ver 2.22
[    2.556918] NET: Registered PF_BLUETOOTH protocol family
[    2.562187] Bluetooth: HCI device and connection manager initialized
[    2.568503] Bluetooth: HCI socket layer initialized
[    2.573345] Bluetooth: L2CAP socket layer initialized
[    2.578367] Bluetooth: SCO socket layer initialized
[    2.583543] clocksource: Switched to clocksource arch_sys_counter
[    2.589379] VFS: Disk quotas dquot_6.6.0
[    2.593189] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.604442] NET: Registered PF_INET protocol family
[    2.604945] IP idents hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    2.613749] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
[    2.620702] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    2.628736] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    2.636173] TCP: Hash tables configured (established 32768 bind 32768)
[    2.642355] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.649018] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.656174] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    2.661968] RPC: Registered named UNIX socket transport module.
[    2.667553] RPC: Registered udp transport module.
[    2.672218] RPC: Registered tcp transport module.
[    2.676885] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.683902] PCI: CLS 0 bytes, default 64
[    2.687309] Trying to unpack rootfs image as initramfs...
[    2.693323] armv8-pmu pmu: hw perfevents: no interrupt-affinity property, guessing.
[    2.700518] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counters available
[    4.032380] Freeing initrd memory: 29160K
[    4.090655] Initialise system trusted keyrings
[    4.090799] workingset: timestamp_bits=46 max_order=20 bucket_order=0
[    4.096544] NFS: Registering the id_resolver key type
[    4.100977] Key type id_resolver registered
[    4.105042] Key type id_legacy registered
[    4.109035] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    4.115684] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    4.123046] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    4.166450] NET: Registered PF_ALG protocol family
[    4.166498] xor: measuring software checksum speed
[    4.174527]    8regs           :  2363 MB/sec
[    4.178194]    32regs          :  2799 MB/sec
[    4.183267]    arm64_neon      :  2308 MB/sec
[    4.183327] xor: using function: 32regs (2799 MB/sec)
[    4.188354] Key type asymmetric registered
[    4.192420] Asymmetric key parser 'x509' registered
[    4.197298] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 244)
[    4.204613] io scheduler mq-deadline registered
[    4.209110] io scheduler kyber registered
[    4.240213] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.242044] Serial: AMBA driver
[    4.244978] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    4.254347] brd: module loaded
[    4.257867] loop: module loaded
[    4.258885] mtdoops: mtd device (mtddev=name/number) must be supplied
[    4.265521] tun: Universal TUN/TAP device driver, 1.6
[    4.267744] CAN device driver interface
[    4.272206] SPI driver wl1271_spi has no spi_device_id for ti,wl1271
[    4.277789] SPI driver wl1271_spi has no spi_device_id for ti,wl1273
[    4.284099] SPI driver wl1271_spi has no spi_device_id for ti,wl1281
[    4.290411] SPI driver wl1271_spi has no spi_device_id for ti,wl1283
[    4.296725] SPI driver wl1271_spi has no spi_device_id for ti,wl1285
[    4.303041] SPI driver wl1271_spi has no spi_device_id for ti,wl1801
[    4.309356] SPI driver wl1271_spi has no spi_device_id for ti,wl1805
[    4.315676] SPI driver wl1271_spi has no spi_device_id for ti,wl1807
[    4.321984] SPI driver wl1271_spi has no spi_device_id for ti,wl1831
[    4.328298] SPI driver wl1271_spi has no spi_device_id for ti,wl1835
[    4.334614] SPI driver wl1271_spi has no spi_device_id for ti,wl1837
[    4.341019] usbcore: registered new interface driver asix
[    4.346329] usbcore: registered new interface driver ax88179_178a
[    4.352366] usbcore: registered new interface driver cdc_ether
[    4.358163] usbcore: registered new interface driver net1080
[    4.363784] usbcore: registered new interface driver cdc_subset
[    4.369665] usbcore: registered new interface driver zaurus
[    4.375215] usbcore: registered new interface driver cdc_ncm
[    4.381595] usbcore: registered new interface driver uas
[    4.386116] usbcore: registered new interface driver usb-storage
[    4.392715] rtc_zynqmp ffa60000.rtc: registered as rtc0
[    4.397253] rtc_zynqmp ffa60000.rtc: setting system clock to 2022-12-14T07:39:06 UTC (1671003546)
[    4.406124] i2c_dev: i2c /dev entries driver
[    4.412196] usbcore: registered new interface driver uvcvideo
[    4.416959] Bluetooth: HCI UART driver ver 2.3
[    4.420426] Bluetooth: HCI UART protocol H4 registered
[    4.425527] Bluetooth: HCI UART protocol BCSP registered
[    4.430817] Bluetooth: HCI UART protocol LL registered
[    4.435908] Bluetooth: HCI UART protocol ATH3K registered
[    4.441289] Bluetooth: HCI UART protocol Three-wire (H5) registered
[    4.447544] Bluetooth: HCI UART protocol Intel registered
[    4.452874] Bluetooth: HCI UART protocol QCA registered
[    4.458077] usbcore: registered new interface driver bcm203x
[    4.463697] usbcore: registered new interface driver bpa10x
[    4.469235] usbcore: registered new interface driver bfusb
[    4.474682] usbcore: registered new interface driver btusb
[    4.480145] usbcore: registered new interface driver ath3k
[    4.485644] EDAC MC: ECC not enabled
[    4.489242] EDAC DEVICE0: Giving out device to module edac controller cache_err: DEV edac (POLLED)
[    4.498184] EDAC DEVICE1: Giving out device to module zynqmp-ocm-edac controller zynqmp_ocm: DEV ff960000.memory-controller (INTERRUPT)
[    4.510551] sdhci: Secure Digital Host Controller Interface driver
[    4.516272] sdhci: Copyright(c) Pierre Ossman
[    4.520593] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.526600] ledtrig-cpu: registered to indicate activity on CPUs
[    4.532286] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
[    4.538648] zynqmp_firmware_probe Platform Management API v1.1
[    4.544382] zynqmp_firmware_probe Trustzone version v1.0
[    4.579840] securefw securefw: securefw probed
[    4.580144] alg: No test for xilinx-zynqmp-aes (zynqmp-aes)
[    4.584304] zynqmp_aes firmware:zynqmp-firmware:zynqmp-aes: AES Successfully Registered
[    4.592424] alg: No test for xilinx-keccak-384 (zynqmp-keccak-384)
[    4.598567] alg: No test for xilinx-zynqmp-rsa (zynqmp-rsa)
[    4.604067] usbcore: registered new interface driver usbhid
[    4.609448] usbhid: USB HID core driver
[    4.616400] ARM CCI_400_r1 PMU driver probed
[    4.617078] fpga_manager fpga0: Xilinx ZynqMP FPGA Manager registered
[    4.624332] usbcore: registered new interface driver snd-usb-audio
[    4.630927] pktgen: Packet Generator for packet performance testing. Version: 2.75
[    4.638321] Initializing XFRM netlink socket
[    4.641869] NET: Registered PF_INET6 protocol family
[    4.647181] Segment Routing with IPv6
[    4.650381] In-situ OAM (IOAM) with IPv6
[    4.654319] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    4.660472] NET: Registered PF_PACKET protocol family
[    4.665162] NET: Registered PF_KEY protocol family
[    4.669921] can: controller area network core
[    4.674258] NET: Registered PF_CAN protocol family
[    4.678992] can: raw protocol
[    4.681934] can: broadcast manager protocol
[    4.686088] can: netlink gateway - max_hops=1
[    4.690487] Bluetooth: RFCOMM TTY layer initialized
[    4.695260] Bluetooth: RFCOMM socket layer initialized
[    4.700370] Bluetooth: RFCOMM ver 1.11
[    4.704083] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.709352] Bluetooth: BNEP filters: protocol multicast
[    4.714546] Bluetooth: BNEP socket layer initialized
[    4.719473] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.725357] Bluetooth: HIDP socket layer initialized
[    4.730314] 8021q: 802.1Q VLAN Support v1.8
[    4.734550] 9pnet: Installing 9P2000 support
[    4.738699] Key type dns_resolver registered
[    4.743046] registered taskstats version 1
[    4.746985] Loading compiled-in X.509 certificates
[    4.752835] Btrfs loaded, crc32c=crc32c-generic, zoned=no, fsverity=no
[    4.767450] ff000000.serial: ttyPS0 at MMIO 0xff000000 (irq = 55, base_baud = 6249999) is a xuartps
[    4.776482] printk: console [ttyPS0] enabled
[    4.776482] printk: console [ttyPS0] enabled
[    4.780777] printk: bootconsole [cdns0] disabled
[    4.780777] printk: bootconsole [cdns0] disabled
[    4.790327] ff010000.serial: ttyPS1 at MMIO 0xff010000 (irq = 56, base_baud = 6249999) is a xuartps
[    4.803528] of-fpga-region fpga-full: FPGA Region probed
[    4.810055] nwl-pcie fd0e0000.pcie: host bridge /axi/pcie@fd0e0000 ranges:
[    4.816956] nwl-pcie fd0e0000.pcie:      MEM 0x00e0000000..0x00efffffff -> 0x00e0000000
[    4.824973] nwl-pcie fd0e0000.pcie:      MEM 0x0600000000..0x07ffffffff -> 0x0600000000
[    4.833050] nwl-pcie fd0e0000.pcie: Link is DOWN
[    4.837809] nwl-pcie fd0e0000.pcie: PCI host bridge to bus 0000:00
[    4.843994] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.849475] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xefffffff]
[    4.856347] pci_bus 0000:00: root bus resource [mem 0x600000000-0x7ffffffff pref]
[    4.863857] pci 0000:00:00.0: [10ee:d021] type 01 class 0x060400
[    4.869920] pci 0000:00:00.0: PME# supported from D0 D1 D2 D3hot
[    4.879868] pci 0000:00:00.0: PCI bridge to [bus 01-0c]
[    4.885414] xilinx-zynqmp-dma fd500000.dma-controller: ZynqMP DMA driver Probe success
[    4.893506] xilinx-zynqmp-dma fd510000.dma-controller: ZynqMP DMA driver Probe success
[    4.901588] xilinx-zynqmp-dma fd520000.dma-controller: ZynqMP DMA driver Probe success
[    4.909668] xilinx-zynqmp-dma fd530000.dma-controller: ZynqMP DMA driver Probe success
[    4.917750] xilinx-zynqmp-dma fd540000.dma-controller: ZynqMP DMA driver Probe success
[    4.925835] xilinx-zynqmp-dma fd550000.dma-controller: ZynqMP DMA driver Probe success
[    4.933923] xilinx-zynqmp-dma fd560000.dma-controller: ZynqMP DMA driver Probe success
[    4.942009] xilinx-zynqmp-dma fd570000.dma-controller: ZynqMP DMA driver Probe success
[    4.950165] xilinx-zynqmp-dma ffa80000.dma-controller: ZynqMP DMA driver Probe success
[    4.958251] xilinx-zynqmp-dma ffa90000.dma-controller: ZynqMP DMA driver Probe success
[    4.966334] xilinx-zynqmp-dma ffaa0000.dma-controller: ZynqMP DMA driver Probe success
[    4.974417] xilinx-zynqmp-dma ffab0000.dma-controller: ZynqMP DMA driver Probe success
[    4.982509] xilinx-zynqmp-dma ffac0000.dma-controller: ZynqMP DMA driver Probe success
[    4.990589] xilinx-zynqmp-dma ffad0000.dma-controller: ZynqMP DMA driver Probe success
[    4.998675] xilinx-zynqmp-dma ffae0000.dma-controller: ZynqMP DMA driver Probe success
[    5.006762] xilinx-zynqmp-dma ffaf0000.dma-controller: ZynqMP DMA driver Probe success
[    5.015081] xilinx-zynqmp-dpdma fd4c0000.dma-controller: Xilinx DPDMA engine is probed
[    5.023236] ahci-ceva fd0c0000.ahci: supply ahci not found, using dummy regulator
[    5.030791] ahci-ceva fd0c0000.ahci: supply phy not found, using dummy regulator
[    5.038216] ahci-ceva fd0c0000.ahci: supply target not found, using dummy regulator
[    5.056168] ahci-ceva fd0c0000.ahci: AHCI 0001.0301 32 slots 2 ports 6 Gbps 0x3 impl platform mode
[    5.065132] ahci-ceva fd0c0000.ahci: flags: 64bit ncq sntf pm clo only pmp fbs pio slum part ccc sds apst
[    5.075690] scsi host0: ahci-ceva
[    5.079280] scsi host1: ahci-ceva
[    5.082722] ata1: SATA max UDMA/133 mmio [mem 0xfd0c0000-0xfd0c1fff] port 0x100 irq 53
[    5.090636] ata2: SATA max UDMA/133 mmio [mem 0xfd0c0000-0xfd0c1fff] port 0x180 irq 53
[    5.099132] spi-nor spi0.0: found mt25qu512a, expected m25p80
[    5.105463] spi-nor spi0.0: mt25qu512a (131072 Kbytes)
[    5.110619] 3 fixed-partitions partitions found on MTD device spi0.0
[    5.116970] Creating 3 MTD partitions on "spi0.0":
[    5.121760] 0x000000000000-0x000001e00000 : "boot"
[    5.127427] 0x000001e00000-0x000001e40000 : "bootenv"
[    5.133256] 0x000001e40000-0x000004240000 : "kernel"
[    5.139843] xilinx_can ff070000.can can0: TDC Offset value not in range
[    5.148070] macb ff0e0000.ethernet: Not enabling partial store and forward
[    5.158147] macb ff0e0000.ethernet eth0: Cadence GEM rev 0x50070106 at 0xff0e0000 irq 39 (00:0a:35:00:22:01)
[    5.168756] xilinx_axienet 80010000.ethernet: couldn't find phy i/f
[    5.176251] xilinx-axipmon ffa00000.perf-monitor: Probed Xilinx APM
[    5.182781] xilinx-axipmon fd0b0000.perf-monitor: Probed Xilinx APM
[    5.189271] xilinx-axipmon fd490000.perf-monitor: Probed Xilinx APM
[    5.195763] xilinx-axipmon ffa10000.perf-monitor: Probed Xilinx APM
[    5.203055] pca953x 0-0020: supply vcc not found, using dummy regulator
[    5.209754] pca953x 0-0020: using no AI
[    5.214277] pca953x 0-0021: supply vcc not found, using dummy regulator
[    5.220951] pca953x 0-0021: using no AI
[    5.233915] i2c i2c-0: Added multiplexed i2c bus 2
[    5.245372] i2c i2c-0: Added multiplexed i2c bus 3
[    5.261980] random: fast init done
[    5.303732] i2c i2c-0: Added multiplexed i2c bus 4
[    5.308647] i2c i2c-0: Added multiplexed i2c bus 5
[    5.313437] pca954x 0-0075: registered 4 multiplexed busses for I2C mux pca9544
[    5.320795] cdns-i2c ff020000.i2c: 400 kHz mmio ff020000 irq 41
[    5.328134] at24 6-0054: supply vcc not found, using dummy regulator
[    5.335032] at24 6-0054: 1024 byte 24c08 EEPROM, writable, 1 bytes/write
[    5.341772] i2c i2c-1: Added multiplexed i2c bus 6
[    5.347108] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.354415] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.361722] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.369034] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.376338] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.383647] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.390954] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.398260] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.406680] si5341 7-0036: Chip: 5341 Grade: 1 Rev: 1
[    5.413781] ata2: SATA link down (SStatus 0 SControl 330)
[    5.419201] ata1: SATA link down (SStatus 0 SControl 330)
[    5.450690] i2c i2c-1: Added multiplexed i2c bus 7
[    5.458361] si570 8-005d: registered, current frequency 300000000 Hz
[    5.464749] i2c i2c-1: Added multiplexed i2c bus 8
[    5.469676] i2c i2c-1: Added multiplexed i2c bus 9
[    5.474683] si5324 10-0069: si5328 probed
[    5.539971] si5324 10-0069: si5328 probe successful
[    5.544887] i2c i2c-1: Added multiplexed i2c bus 10
[    5.549883] i2c i2c-1: Added multiplexed i2c bus 11
[    5.554881] i2c i2c-1: Added multiplexed i2c bus 12
[    5.559880] i2c i2c-1: Added multiplexed i2c bus 13
[    5.564761] pca954x 1-0074: registered 8 multiplexed busses for I2C switch pca9548
[    5.572691] i2c i2c-1: Added multiplexed i2c bus 14
[    5.577701] i2c i2c-1: Added multiplexed i2c bus 15
[    5.582711] i2c i2c-1: Added multiplexed i2c bus 16
[    5.587718] i2c i2c-1: Added multiplexed i2c bus 17
[    5.592729] i2c i2c-1: Added multiplexed i2c bus 18
[    5.597735] i2c i2c-1: Added multiplexed i2c bus 19
[    5.602750] i2c i2c-1: Added multiplexed i2c bus 20
[    5.607761] i2c i2c-1: Added multiplexed i2c bus 21
[    5.612644] pca954x 1-0075: registered 8 multiplexed busses for I2C switch pca9548
[    5.620248] cdns-i2c ff030000.i2c: 400 kHz mmio ff030000 irq 42
[    5.629907] cdns-wdt fd4d0000.watchdog: Xilinx Watchdog Timer with timeout 60s
[    5.637371] cdns-wdt ff150000.watchdog: Xilinx Watchdog Timer with timeout 10s
[    5.645061] cpufreq: cpufreq_online: CPU0: Running at unlisted initial frequency: 1199999 KHz, changing to: 1199988 KHz
[    5.659581] zynqmp-display fd4a0000.display: vtc bridge property not present
[    5.669094] xilinx-dp-snd-codec fd4a0000.display:zynqmp_dp_snd_codec0: Xilinx DisplayPort Sound Codec probed
[    5.679156] xilinx-dp-snd-pcm zynqmp_dp_snd_pcm0: Xilinx DisplayPort Sound PCM probed
[    5.687207] xilinx-dp-snd-pcm zynqmp_dp_snd_pcm1: Xilinx DisplayPort Sound PCM probed
[    5.690422] mmc0: SDHCI controller on ff170000.mmc [ff170000.mmc] using ADMA 64-bit
[    5.703308] xilinx-dp-snd-card fd4a0000.display:zynqmp_dp_snd_card: Xilinx DisplayPort Sound Card probed
[    5.712893] OF: graph: no port node found in /axi/display@fd4a0000
[    5.719402] xlnx-drm xlnx-drm.0: bound fd4a0000.display (ops 0xffff800008f031e0)
[    5.740363] mmc0: new high speed SDXC card at address aaaa
[    5.746201] mmcblk0: mmc0:aaaa SD64G 59.5 GiB
[    5.752224]  mmcblk0: p1
[    6.803568] zynqmp-display fd4a0000.display: [drm] Cannot find any crtc or sizes
[    6.811208] [drm] Initialized xlnx 1.0.0 20130509 for fd4a0000.display on minor 0
[    6.818712] zynqmp-display fd4a0000.display: ZynqMP DisplayPort Subsystem driver probed
[    6.849342] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    6.854840] xhci-hcd xhci-hcd.1.auto: new USB bus registered, assigned bus number 1
[    6.862586] xhci-hcd xhci-hcd.1.auto: hcc params 0x0238f625 hci version 0x100 quirks 0x0000000002010810
[    6.872010] xhci-hcd xhci-hcd.1.auto: irq 65, io mem 0xfe200000
[    6.878157] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.15
[    6.886422] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.893642] usb usb1: Product: xHCI Host Controller
[    6.898512] usb usb1: Manufacturer: Linux 5.15.19-xilinx-v2022.1 xhci-hcd
[    6.905296] usb usb1: SerialNumber: xhci-hcd.1.auto
[    6.910528] hub 1-0:1.0: USB hub found
[    6.914297] hub 1-0:1.0: 1 port detected
[    6.918415] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    6.923902] xhci-hcd xhci-hcd.1.auto: new USB bus registered, assigned bus number 2
[    6.931570] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0 SuperSpeed
[    6.938208] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.15
[    6.946475] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.953692] usb usb2: Product: xHCI Host Controller
[    6.958569] usb usb2: Manufacturer: Linux 5.15.19-xilinx-v2022.1 xhci-hcd
[    6.965349] usb usb2: SerialNumber: xhci-hcd.1.auto
[    6.970488] hub 2-0:1.0: USB hub found
[    6.974260] hub 2-0:1.0: 1 port detected
[    6.981391] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    6.988421] of_cfs_init
[    6.990871] of_cfs_init: OK
[    6.993855] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    7.134783] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    7.141321] clk: Not disabling unused clocks
[    7.145861] ALSA device list:
[    7.148819]   #0: DisplayPort monitor
[    7.152751] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    7.161370] cfg80211: failed to load regulatory.db
[    7.166682] Freeing unused kernel memory: 2176K
[    7.195587] Run /init as init process
[    7.212562] systemd[1]: systemd 249.7+ running in system mode (+PAM -AUDIT -SELINUX -APPARMOR +IMA -SMACK +SECCOMP -GCRYPT -GNUTLS -OPENSSL +ACL +BLKID -CURL -ELFUTILS -FIDO2 -IDN2 -IDN -IPTC +KMOD -LIBCRYPTSETUP +LIBFDISK -PCRE2 -PWQUALITY -P11KIT -QRENCODE -BZIP2 -LZ4 -XZ -ZLIB +ZSTD +XKBCOMMON +UTMP +SYSVINIT default-hierarchy=hybrid)
[    7.242897] systemd[1]: Detected architecture arm64.

Welcome to PetaLinux 2022.1_release_S04190222 (honister)!

[    7.283685] systemd[1]: Hostname set to <xilinx-zcu102-20221>.
[    7.289628] random: systemd: uninitialized urandom read (16 bytes read)
[    7.296266] systemd[1]: Initializing machine ID from random generator.
[    7.337817] systemd-sysv-generator[246]: SysV service '/etc/init.d/watchdog-init' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.365114] systemd-sysv-generator[246]: SysV service '/etc/init.d/nfsserver' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.389298] systemd-sysv-generator[246]: SysV service '/etc/init.d/nfscommon' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.413657] systemd-sysv-generator[246]: SysV service '/etc/init.d/inetd.busybox' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.438684] systemd-sysv-generator[246]: SysV service '/etc/init.d/dropbear' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.657533] systemd[1]: Queued start job for default target Multi-User System.
[    7.665638] random: systemd: uninitialized urandom read (16 bytes read)
[    7.702057] systemd[1]: Created slice Slice /system/getty.
[  OK  ] Created slice Slice /system/getty.
[    7.723674] random: systemd: uninitialized urandom read (16 bytes read)
[    7.731652] systemd[1]: Created slice Slice /system/modprobe.
[  OK  ] Created slice Slice /system/modprobe.
[    7.752809] systemd[1]: Created slice Slice /system/serial-getty.
[  OK  ] Created slice Slice /system/serial-getty.
[    7.776666] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[    7.799819] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[  OK  ] Started Dispatch Password …ts tt CCnsole DDrectory WWtch.
[    78Ǽȩȡ systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Started Forward Password R…uests to Wall Directory Watch.
[    7.847856] systemd[1]: Reached target Path Units.
[  OK  ] Reached target Path Units.
[    7.863656] systemd[1]: Reached target Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[    7.883648] systemd[1]: Reached target Slice Units.
[    7.888560] zynqmp-display fd4a0000.display: [drm] Cannot find any crtc or sizes
[  OK  ] Reached target Slice Units.
[    7.907670] systemd[1]: Reached target Swaps.
[  OK  ] Reached target Swaps.
[    7.924085] systemd[1]: Listening on RPCbind Server Activation Socket.
[  OK  ] Listening on RPCbind Server Activation Socket.
[    7.947638] systemd[1]: Reached target RPC Port Mapper.
[  OK  ] Reached target RPC Port Mapper.
[    7.967902] systemd[1]: Listening on Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[    7.983786] systemd[1]: Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[    8.008095] systemd[1]: Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Audit Socket.
[    8.027848] systemd[1]: Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket (/dev/log).
[    8.047919] systemd[1]: Listening on Journal Socket.
[  OK  ] Listening on Journal Socket.
[    8.064063] systemd[1]: Listening on Network Service Netlink Socket.
[  OK  ] Listening on Network Service Netlink Socket.
[    8.087922] systemd[1]: Listening on udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[    8.107838] systemd[1]: Listening on udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[    8.127845] systemd[1]: Listening on User Database Manager Socket.
[  OK  ] Listening on User Database Manager Socket.
[    8.154177] systemd[1]: Mounting Huge Pages File System...
         Mounting Huge Pages File System...
[    8.174213] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[    8.198291] systemd[1]: Mounting Kernel Debug File System...
         Mounting Kernel Debug File System...
[    8.215981] systemd[1]: Condition check resulted in Kernel Trace File System being skipped.
[    8.227060] systemd[1]: Mounting Temporary Directory /tmp...
         Mounting Temporary Directory /tmp...
[    8.243879] systemd[1]: Condition check resulted in Create List of Static Device Nodes being skipped.
[    8.256141] systemd[1]: Starting Load Kernel Module configfs...
         Starting Load Kernel Module configfs...
[    8.274790] systemd[1]: Starting Load Kernel Module drm...
         Starting Load Kernel Module drm...
[    8.294498] systemd[1]: Starting Load Kernel Module fuse...
         Starting Load Kernel Module fuse...
[    8.314517] systemd[1]: Starting RPC Bind...
         Starting RPC Bind...
[    8.327772] systemd[1]: Condition check resulted in File System Check on Root Device being skipped.
[    8.337529] systemd[1]: Condition check resulted in Load Kernel Modules being skipped.
[    8.347827] systemd[1]: Mounting NFSD configuration filesystem...
         Mounting NFSD configuration filesystem...
[    8.366445] systemd[1]: Starting Remount Root and Kernel File Systems...
         Starting Remount Root and Kernel File Systems...
[    8.390513] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[    8.410498] systemd[1]: Starting Coldplug All udev Devices...
         Starting Coldplug All udev Devices...
[    8.432197] systemd[1]: Started RPC Bind.
[  OK  ] Started RPC Bind.
[    8.448113] systemd[1]: Mounted Huge Pages File System.
[  OK  ] Mounted Huge Pages File System.
[    8.468062] systemd[1]: Mounted POSIX Message Queue File System.
[  OK  ] Mounted POSIX Message Queue File System.
[    8.492067] systemd[1]: Mounted Kernel Debug File System.
[  OK  ] Mounted Kernel Debug File System.
[    8.512059] systemd[1]: Mounted Temporary Directory /tmp.
[  OK  ] Mounted Temporary Directory /tmp.
[    8.532707] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[    8.541014] systemd[1]: Finished Load Kernel Module configfs.
[  OK  ] Finished Load Kernel Module configfs.
[    8.564557] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    8.572349] systemd[1]: Finished Load Kernel Module drm.
[  OK  ] Finished Load Kernel Module drm.
[    8.592296] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[    8.600187] systemd[1]: Finished Load Kernel Module fuse.
[  OK  ] Finished Load Kernel Module fuse.
[    8.619909] systemd[1]: proc-fs-nfsd.mount: Mount process exited, code=exited, status=32/n/a
[    8.628475] systemd[1]: proc-fs-nfsd.mount: Failed with result 'exit-code'.
[    8.636658] systemd[1]: Failed to mount NFSD configuration filesystem.
[FAILED] Failed to mount NFSD configuration filesystem.
See 'systemctl status proc-fs-nfsd.mount' for details.
[    8.671584] systemd[1]: Dependency failed for NFS server and services.
[DEPEND] Dependency failed for NFS server and services.
[    8.695589] systemd[1]: Dependency failed for NFS Mount Daemon.
[DEPEND] Dependency failed for NFS Mount Daemon.
[    8.715581] systemd[1]: nfs-mountd.service: Job nfs-mountd.service/start failed with result 'dependency'.
[    8.725179] systemd[1]: nfs-server.service: Job nfs-server.service/start failed with result 'dependency'.
[    8.736273] systemd[1]: Finished Remount Root and Kernel File Systems.
[  OK  ] Finished Remount Root and Kernel File Systems.
[    8.761067] systemd[1]: Finished Apply Kernel Variables.
[  OK  ] Finished Apply Kernel Variables.
[    8.786135] systemd[1]: Condition check resulted in FUSE Control File System being skipped.
[    8.797588] systemd[1]: Mounting Kernel Configuration File System...
         Mounting Kernel Configuration File System...
[    8.819911] systemd[1]: Condition check resulted in Rebuild Hardware Database being skipped.
[    8.828683] systemd[1]: Condition check resulted in Platform Persistent Storage Archival being skipped.
[    8.841193] systemd[1]: Starting Create System Users...
         Starting Create System Users...
[    8.859502] systemd[1]: Mounted Kernel Configuration File System.
[  OK  ] Mounted Kernel Configuration File System.
[    8.881632] systemd[1]: Finished Create System Users.
[  OK  ] Finished Create System Users.
[    8.898966] systemd[1]: Starting Create Static Device Nodes in /dev...
         Starting Create Static Device Nodes in /dev...
[    8.921789] systemd[1]: Finished Create Static Device Nodes in /dev.
[  OK  ] Finished Create Static Device Nodes in /dev.
[    8.943971] systemd[1]: Reached target Preparation for Local File Systems.
[  OK  ] Reached target Preparation for Local File Systems.
[    8.970727] systemd[1]: Mounting /var/volatile...
         Mounting /var/volatile...
[    8.991363] systemd[1]: Started Entropy Daemon based on the HAVEGE algorithm.
[  OK  ] Started Entropy Daemon based on the HAVEGE algorithm.
[    9.016363] systemd[1]: systemd-journald.service: unit configures an IP firewall, but the local system does not support BPF/cgroup firewalling.
[    9.029331] systemd[1]: (This warning is only shown for the first unit using IP firewalling.)
[    9.041674] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[    9.060027] systemd[1]: Starting Rule-based Manager for Device Events and Files...
         Starting Rule-based Manage…for Device Events and Files...
[    9.085964] systemd[1]: Mounted /var/volatile.
[  OK  ] Mounted /var/volatile.
[    9.099974] systemd[1]: Condition check resulted in Bind mount volatile /var/cache being skipped.
[    9.119704] systemd[1]: Condition check resulted in Bind mount volatile /var/lib being skipped.
[    9.137933] systemd[1]: Starting Load/Save Random Seed...
         Starting Load/Save Random Seed...
[    9.155734] systemd[1]: Condition check resulted in Bind mount volatile /var/spool being skipped.
[    9.175712] systemd[1]: Condition check resulted in Bind mount volatile /srv being skipped.
[    9.184232] systemd[1]: Reached target Local File Systems.
[  OK  ] Reached target Local File Systems.
[    9.206017] systemd[1]: Starting Rebuild Dynamic Linker Cache...
         Starting Rebuild Dynamic Linker Cache...
[    9.241108] systemd[1]: Started Rule-based Manager for Device Events and Files.
[  OK  ] Started Rule-based Manager for Device Events and Files.
[    9.264127] systemd[1]: Started Journal Service.
[  OK  ] Started Journal Service.
[  OK  ] Finished Rebuild Dynamic Linker Cache.
         Starting Flush Journal to Persistent Storage...
[    9.328819] systemd-journald[278]: Received client request to flush runtime journal.
         Starting Network Configuration...
[  OK  ] Finished Coldplug All udev Devices.
[  OK  ] Finished Flush Journal to Persistent Storage.
         Starting Create Volatile Files and Directories...
[  OK  ] Reached target Sound Card.
[  OK  ] Finished Create Volatile Files and Directories.
         Starting Run pending postinsts...
         Starting Rebuild Journal Catalog...
         Starting Network Time Synchronization...
         Starting Record System Boot/Shutdown in UTMP    9.594008] Unloading old XRT Linux kernel modules
m...
[    9.609212] Loading new XRT Linux kernel modules
[    9.644104] zocl: loading out-of-tree module taints kernel.
[  OK  ] Finished Record System Boot/Shutdown in UTMP.
[    9.691936] INFO: Creating ICD entry for Xilinx Platform
[  OK  ] Finished Rebuild Journal Catalog.
         Starting Update is Completed...
[  OK  ] Started Network Configuration.
         Starting Network Name Resolution...
[    9.763927] macb ff0e0000.ethernet eth0: PHY [ff0e0000.ethernet-ffffffff:0c] driver [TI DP83867] (irq=POLL)
[    9.776084] macb ff0e0000.ethernet eth0: configuring for phy/rgmii-id link mode
[  OK  ] Finished Update is Completed.
[    9.805070] pps pps0: new PPS source ptp0
[    9.810855] macb ff0e0000.ethernet: gem-ptp-timer ptp clock registered.
[  OK  ] Finished Run pending postinsts.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Started Network Name Resolution.
[   10.853104] random: crng init done
[   10.856523] random: 7 urandom warning(s) missed due to ratelimiting
[  OK  ] Finished Load/Save Random Seed.
[  OK  ] Created slice Slice /system/systemd-fsck.
[  OK  ] Reached target Network.
[  OK  ] Reached target Host and Network Name Lookups.
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target System Time Set.
[  OK  ] Reached target Timer Units.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Listening on dropbear.socket.
[  OK  ] Reached target Socket Units.
[  OK  ] Reached target Basic System.
[  OK  ] Listening on Load/Save RF …itch SSatus //ev/rfkill Watch.
[  OK  ] Started Kernel Logging Service.
[  OK  ] Started System Logging Service.
[  OK  ] Started D-Bus System Message Bus.
[  OK  ] Started NFS status monitor for NFSv2/3 locking..
         Starting LSB: NFS support for both client and server...
         Starting File System Check on /dev/mmcblk0p1...
         Starting User Login Management...
         Starting Permit User Sessions...
         Starting Target Communication Framework agent...
[  OK  ] Started LSB: NFS support for both client and server.
[  OK  ] Finished File System Check on /dev/mmcblk0p1.
[  OK  ] Finished Permit User Sessions.
[  OK  ] Started Target Communication Framework agent.
         Mounting /run/media/mmcblk0p1...
[  OK  ] Started Getty on tty1.
         Starting inetd.busybox.service...
         Starting LSB: Kernel NFS server support...
[   11.913363] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  OK  ] Started Serial Getty on ttyPS0.
[  OK  ] Reached target Login Prompts.
[  OK  ] Mounted /run/media/mmcblk0p1.
[  OK  ] Started inetd.busybox.service.
[FAILED] Failed to start LSB: Kernel NFS server support.
See 'systemctl status nfsserver.service' for details.
[  OK  ] Started User Login Management.
[  OK  ] Reached target Multi-User System.
         Starting Record Runlevel Change in UTMP...
[  OK  ] Finished Record Runlevel Change in UTMP.

PetaLinux 2022.1_release_S04190222 xilinx-zcu102-20221 ttyPS0

xilinx-zcu102-20221 login:
```
---

