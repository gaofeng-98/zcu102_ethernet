# PS 10/100/1000BASE-T via MIO v2022.1
## **Design Summary**

This project utilizes GEM3 configured for RGMII via MIO. This has been routed to the on-board TI DP83867 PHY found on the ZCU102.

---

## **Required Hardware**
- ZCU102
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
`petalinux-create -t project -s ps_mio_eth_1g.bsp -n psmio_plnx`

`cd psmio_plnx`

`petalinux-config --get-hw-description ../../../Hardware/pre-built/ --silentconfig`

`petalinux-build`

The PetaLinux project will be built using the configurations in the BSP.

Once the build is complete, the built images can be found in the `PetaLinux/images/linux/`
directory. To package these images for SD boot, run the following from the `PetaLinux` directory:

`petalinux-package --boot --fpga --u-boot --force`

Once packaged, the`boot.scr`, `BOOT.bin` and `image.ub` files (in the `PetaLinux/images/linux` directory) can be copied to an SD card, and used to boot.

---

## **Validation**

### **Performance:**
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.

These performance numbers reflect an MTU of 1500.
```
xilinx-zcu102-20221:~$ iperf3 -c 192.168.1.2
Connecting to host 192.168.1.2, port 5201
[  5] local 192.168.1.10 port 53584 connected to 192.168.1.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   113 MBytes   948 Mbits/sec    0    221 KBytes
[  5]   1.00-2.00   sec   112 MBytes   942 Mbits/sec    0    221 KBytes
[  5]   2.00-3.00   sec   111 MBytes   935 Mbits/sec    0    221 KBytes
[  5]   3.00-4.00   sec   110 MBytes   927 Mbits/sec    0    221 KBytes
[  5]   4.00-5.00   sec   112 MBytes   941 Mbits/sec    0    221 KBytes
[  5]   5.00-6.00   sec   112 MBytes   939 Mbits/sec    0    221 KBytes
[  5]   6.00-7.00   sec   112 MBytes   937 Mbits/sec    0    221 KBytes
[  5]   7.00-8.00   sec   112 MBytes   942 Mbits/sec    0    221 KBytes
[  5]   8.00-9.00   sec   106 MBytes   890 Mbits/sec    0    221 KBytes
[  5]   9.00-10.00  sec   111 MBytes   932 Mbits/sec    0    221 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   933 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  1.09 GBytes   932 Mbits/sec                  receiver

iperf Done.
```
---
### **boot log:**
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
eth0: ethernet@ff0e0000
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
39594176 bytes read in 2559 ms (14.8 MiB/s)
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
     Hash value:   fac3bc3e8c4289b1db1a76e4f823b2fc3f654d590d6fba798962311682254612
   Verifying Hash Integrity ... sha256+ OK
## Loading ramdisk from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'ramdisk-1' ramdisk subimage
     Description:  petalinux-image-minimal
     Created:      2022-04-11  17:52:14 UTC
     Type:         RAMDisk Image
     Compression:  uncompressed
     Data Start:   0x10949c1c
     Data Size:    29853481 Bytes = 28.5 MiB
     Architecture: AArch64
     OS:           Linux
     Load Address: unavailable
     Entry Point:  unavailable
     Hash algo:    sha256
     Hash value:   ed94638460d9cc4134cf4ac35d9ad951fa62706c688d04fd27f4504fd6e3ee24
   Verifying Hash Integrity ... sha256+ OK
## Loading fdt from FIT Image at 10000000 ...
   Using 'conf-system-top.dtb' configuration
   Trying 'fdt-system-top.dtb' fdt subimage
     Description:  Flattened Device Tree blob
     Created:      2022-04-11  17:52:14 UTC
     Type:         Flat Device Tree
     Compression:  uncompressed
     Data Start:   0x1093bf20
     Data Size:    56361 Bytes = 55 KiB
     Architecture: AArch64
     Hash algo:    sha256
     Hash value:   e9214a3818df8c394e0b8909573ba780ef704e326b868b4bd5e854db96f6a912
   Verifying Hash Integrity ... sha256+ OK
   Booting using the fdt blob at 0x1093bf20
   Uncompressing Kernel Image
   Loading Ramdisk to 79f81000, end 7bbf9729 ... OK
   Loading Device Tree to 000000007feef000, end 000000007feffc28 ... OK

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
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x170f8de2d3, max_idle_ns: 440795206112 ns
[    0.000000] sched_clock: 56 bits at 99MHz, resolution 10ns, wraps every 4398046511101ns
[    0.008334] Console: colour dummy device 80x25
[    0.012399] Calibrating delay loop (skipped), value calculated using timer frequency.. 199.98 BogoMIPS (lpj=399960)
[    0.022755] pid_max: default: 32768 minimum: 301
[    0.027519] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.034704] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    0.043478] rcu: Hierarchical SRCU implementation.
[    0.047541] EFI services will not be available.
[    0.051878] smp: Bringing up secondary CPUs ...
[    0.056599] Detected VIPT I-cache on CPU1
[    0.056639] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.057042] Detected VIPT I-cache on CPU2
[    0.057066] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[    0.057434] Detected VIPT I-cache on CPU3
[    0.057456] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[    0.057500] smp: Brought up 1 node, 4 CPUs
[    0.091701] SMP: Total of 4 processors activated.
[    0.096373] CPU features: detected: 32-bit EL0 Support
[    0.101478] CPU features: detected: CRC32 instructions
[    0.106616] CPU: All CPU(s) started at EL2
[    0.110660] alternatives: patching kernel code
[    0.116118] devtmpfs: initialized
[    0.125134] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.129231] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.144284] pinctrl core: initialized pinctrl subsystem
[    0.144762] DMI not present or invalid.
[    0.147892] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.154543] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic allocations
[    0.160663] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.168478] audit: initializing netlink subsys (disabled)
[    0.173894] audit: type=2000 audit(0.112:1): state=initialized audit_enabled=0 res=1
[    0.174238] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.188308] ASID allocator initialised with 65536 entries
[    0.193717] Serial: AMBA PL011 UART driver
[    0.219381] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.220441] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    0.227111] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.233776] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    1.310050] cryptd: max_cpu_qlen set to 1000
[    1.334629] DRBG: Continuing without Jitter RNG
[    1.437241] raid6: neonx8   gen()  2129 MB/s
[    1.505298] raid6: neonx8   xor()  1582 MB/s
[    1.573362] raid6: neonx4   gen()  2183 MB/s
[    1.641422] raid6: neonx4   xor()  1554 MB/s
[    1.709491] raid6: neonx2   gen()  2066 MB/s
[    1.777543] raid6: neonx2   xor()  1420 MB/s
[    1.845610] raid6: neonx1   gen()  1764 MB/s
[    1.913665] raid6: neonx1   xor()  1212 MB/s
[    1.981736] raid6: int64x8  gen()  1366 MB/s
[    2.049786] raid6: int64x8  xor()   773 MB/s
[    2.117864] raid6: int64x4  gen()  1598 MB/s
[    2.185919] raid6: int64x4  xor()   849 MB/s
[    2.253992] raid6: int64x2  gen()  1396 MB/s
[    2.322042] raid6: int64x2  xor()   746 MB/s
[    2.390116] raid6: int64x1  gen()  1032 MB/s
[    2.458173] raid6: int64x1  xor()   517 MB/s
[    2.458212] raid6: using algorithm neonx4 gen() 2183 MB/s
[    2.462163] raid6: .... xor() 1554 MB/s, rmw enabled
[    2.467099] raid6: using neon recovery algorithm
[    2.472193] iommu: Default domain type: Translated
[    2.476532] iommu: DMA domain TLB invalidation policy: strict mode
[    2.482964] SCSI subsystem initialized
[    2.486611] usbcore: registered new interface driver usbfs
[    2.491953] usbcore: registered new interface driver hub
[    2.497224] usbcore: registered new device driver usb
[    2.502278] mc: Linux media interface: v0.10
[    2.506477] videodev: Linux video capture interface: v2.00
[    2.511942] pps_core: LinuxPPS API ver. 1 registered
[    2.516842] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.525934] PTP clock support registered
[    2.529836] EDAC MC: Ver: 3.0.0
[    2.533212] zynqmp-ipi-mbox mailbox@ff990400: Registered ZynqMP IPI mbox with TX/RX channels.
[    2.541606] FPGA manager framework
[    2.544902] Advanced Linux Sound Architecture Driver Initialized.
[    2.551151] Bluetooth: Core ver 2.22
[    2.554397] NET: Registered PF_BLUETOOTH protocol family
[    2.559665] Bluetooth: HCI device and connection manager initialized
[    2.565982] Bluetooth: HCI socket layer initialized
[    2.570825] Bluetooth: L2CAP socket layer initialized
[    2.575847] Bluetooth: SCO socket layer initialized
[    2.580997] clocksource: Switched to clocksource arch_sys_counter
[    2.586870] VFS: Disk quotas dquot_6.6.0
[    2.590672] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.601779] NET: Registered PF_INET protocol family
[    2.602428] IP idents hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    2.611235] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes, linear)
[    2.618189] TCP established hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    2.626218] TCP bind hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    2.633660] TCP: Hash tables configured (established 32768 bind 32768)
[    2.639848] UDP hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.646504] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes, linear)
[    2.653663] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    2.659450] RPC: Registered named UNIX socket transport module.
[    2.665041] RPC: Registered udp transport module.
[    2.669707] RPC: Registered tcp transport module.
[    2.674374] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.681378] PCI: CLS 0 bytes, default 64
[    2.684816] Trying to unpack rootfs image as initramfs...
[    2.690765] armv8-pmu pmu: hw perfevents: no interrupt-affinity property, guessing.
[    2.698061] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counters available
[    4.044597] Freeing initrd memory: 29152K
[    4.103033] Initialise system trusted keyrings
[    4.103165] workingset: timestamp_bits=46 max_order=20 bucket_order=0
[    4.108904] NFS: Registering the id_resolver key type
[    4.113311] Key type id_resolver registered
[    4.117417] Key type id_legacy registered
[    4.121412] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    4.128057] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    4.135421] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    4.178478] NET: Registered PF_ALG protocol family
[    4.178529] xor: measuring software checksum speed
[    4.186565]    8regs           :  2363 MB/sec
[    4.190231]    32regs          :  2798 MB/sec
[    4.195304]    arm64_neon      :  2307 MB/sec
[    4.195364] xor: using function: 32regs (2798 MB/sec)
[    4.200388] Key type asymmetric registered
[    4.204452] Asymmetric key parser 'x509' registered
[    4.209331] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 244)
[    4.216652] io scheduler mq-deadline registered
[    4.221153] io scheduler kyber registered
[    4.252126] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.253933] Serial: AMBA driver
[    4.256833] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    4.266283] brd: module loaded
[    4.269736] loop: module loaded
[    4.270701] mtdoops: mtd device (mtddev=name/number) must be supplied
[    4.277389] tun: Universal TUN/TAP device driver, 1.6
[    4.279654] CAN device driver interface
[    4.284058] SPI driver wl1271_spi has no spi_device_id for ti,wl1271
[    4.289701] SPI driver wl1271_spi has no spi_device_id for ti,wl1273
[    4.296013] SPI driver wl1271_spi has no spi_device_id for ti,wl1281
[    4.302328] SPI driver wl1271_spi has no spi_device_id for ti,wl1283
[    4.308642] SPI driver wl1271_spi has no spi_device_id for ti,wl1285
[    4.314958] SPI driver wl1271_spi has no spi_device_id for ti,wl1801
[    4.321273] SPI driver wl1271_spi has no spi_device_id for ti,wl1805
[    4.327588] SPI driver wl1271_spi has no spi_device_id for ti,wl1807
[    4.333903] SPI driver wl1271_spi has no spi_device_id for ti,wl1831
[    4.340218] SPI driver wl1271_spi has no spi_device_id for ti,wl1835
[    4.346533] SPI driver wl1271_spi has no spi_device_id for ti,wl1837
[    4.352936] usbcore: registered new interface driver asix
[    4.358251] usbcore: registered new interface driver ax88179_178a
[    4.364288] usbcore: registered new interface driver cdc_ether
[    4.370085] usbcore: registered new interface driver net1080
[    4.375706] usbcore: registered new interface driver cdc_subset
[    4.381588] usbcore: registered new interface driver zaurus
[    4.387139] usbcore: registered new interface driver cdc_ncm
[    4.393486] usbcore: registered new interface driver uas
[    4.398041] usbcore: registered new interface driver usb-storage
[    4.404626] rtc_zynqmp ffa60000.rtc: registered as rtc0
[    4.409180] rtc_zynqmp ffa60000.rtc: setting system clock to 2022-11-10T11:33:05 UTC (1668079985)
[    4.418048] i2c_dev: i2c /dev entries driver
[    4.424012] usbcore: registered new interface driver uvcvideo
[    4.428872] Bluetooth: HCI UART driver ver 2.3
[    4.432359] Bluetooth: HCI UART protocol H4 registered
[    4.437456] Bluetooth: HCI UART protocol BCSP registered
[    4.442747] Bluetooth: HCI UART protocol LL registered
[    4.447836] Bluetooth: HCI UART protocol ATH3K registered
[    4.453211] Bluetooth: HCI UART protocol Three-wire (H5) registered
[    4.459467] Bluetooth: HCI UART protocol Intel registered
[    4.464804] Bluetooth: HCI UART protocol QCA registered
[    4.470007] usbcore: registered new interface driver bcm203x
[    4.475628] usbcore: registered new interface driver bpa10x
[    4.481169] usbcore: registered new interface driver bfusb
[    4.486617] usbcore: registered new interface driver btusb
[    4.492081] usbcore: registered new interface driver ath3k
[    4.497572] EDAC MC: ECC not enabled
[    4.501170] EDAC DEVICE0: Giving out device to module edac controller cache_err: DEV edac (POLLED)
[    4.510112] EDAC DEVICE1: Giving out device to module zynqmp-ocm-edac controller zynqmp_ocm: DEV ff960000.memory-controller (INTERRUPT)
[    4.522466] sdhci: Secure Digital Host Controller Interface driver
[    4.528204] sdhci: Copyright(c) Pierre Ossman
[    4.532529] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.538519] ledtrig-cpu: registered to indicate activity on CPUs
[    4.544227] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
[    4.550589] zynqmp_firmware_probe Platform Management API v1.1
[    4.556322] zynqmp_firmware_probe Trustzone version v1.0
[    4.591411] securefw securefw: securefw probed
[    4.591692] alg: No test for xilinx-zynqmp-aes (zynqmp-aes)
[    4.595872] zynqmp_aes firmware:zynqmp-firmware:zynqmp-aes: AES Successfully Registered
[    4.603994] alg: No test for xilinx-keccak-384 (zynqmp-keccak-384)
[    4.610136] alg: No test for xilinx-zynqmp-rsa (zynqmp-rsa)
[    4.615631] usbcore: registered new interface driver usbhid
[    4.621024] usbhid: USB HID core driver
[    4.627916] ARM CCI_400_r1 PMU driver probed
[    4.628574] fpga_manager fpga0: Xilinx ZynqMP FPGA Manager registered
[    4.635890] usbcore: registered new interface driver snd-usb-audio
[    4.642464] pktgen: Packet Generator for packet performance testing. Version: 2.75
[    4.649882] Initializing XFRM netlink socket
[    4.653445] NET: Registered PF_INET6 protocol family
[    4.658748] Segment Routing with IPv6
[    4.661957] In-situ OAM (IOAM) with IPv6
[    4.665896] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    4.672034] NET: Registered PF_PACKET protocol family
[    4.676746] NET: Registered PF_KEY protocol family
[    4.681504] can: controller area network core
[    4.685853] NET: Registered PF_CAN protocol family
[    4.690574] can: raw protocol
[    4.693516] can: broadcast manager protocol
[    4.697670] can: netlink gateway - max_hops=1
[    4.702062] Bluetooth: RFCOMM TTY layer initialized
[    4.706846] Bluetooth: RFCOMM socket layer initialized
[    4.711950] Bluetooth: RFCOMM ver 1.11
[    4.715663] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.720936] Bluetooth: BNEP filters: protocol multicast
[    4.726129] Bluetooth: BNEP socket layer initialized
[    4.731056] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.736942] Bluetooth: HIDP socket layer initialized
[    4.741897] 8021q: 802.1Q VLAN Support v1.8
[    4.746135] 9pnet: Installing 9P2000 support
[    4.750279] Key type dns_resolver registered
[    4.754612] registered taskstats version 1
[    4.758570] Loading compiled-in X.509 certificates
[    4.764398] Btrfs loaded, crc32c=crc32c-generic, zoned=no, fsverity=no
[    4.778601] ff000000.serial: ttyPS0 at MMIO 0xff000000 (irq = 55, base_baud = 6249375) is a xuartps
[    4.787630] printk: console [ttyPS0] enabled
[    4.787630] printk: console [ttyPS0] enabled
[    4.791932] printk: bootconsole [cdns0] disabled
[    4.791932] printk: bootconsole [cdns0] disabled
[    4.801487] ff010000.serial: ttyPS1 at MMIO 0xff010000 (irq = 56, base_baud = 6249375) is a xuartps
[    4.814681] of-fpga-region fpga-full: FPGA Region probed
[    4.821204] nwl-pcie fd0e0000.pcie: host bridge /axi/pcie@fd0e0000 ranges:
[    4.828105] nwl-pcie fd0e0000.pcie:      MEM 0x00e0000000..0x00efffffff -> 0x00e0000000
[    4.836111] nwl-pcie fd0e0000.pcie:      MEM 0x0600000000..0x07ffffffff -> 0x0600000000
[    4.844195] nwl-pcie fd0e0000.pcie: Link is DOWN
[    4.848962] nwl-pcie fd0e0000.pcie: PCI host bridge to bus 0000:00
[    4.855143] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.860631] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xefffffff]
[    4.867501] pci_bus 0000:00: root bus resource [mem 0x600000000-0x7ffffffff pref]
[    4.875001] pci 0000:00:00.0: [10ee:d021] type 01 class 0x060400
[    4.881067] pci 0000:00:00.0: PME# supported from D0 D1 D2 D3hot
[    4.890848] pci 0000:00:00.0: PCI bridge to [bus 01-0c]
[    4.896394] xilinx-zynqmp-dma fd500000.dma-controller: ZynqMP DMA driver Probe success
[    4.904484] xilinx-zynqmp-dma fd510000.dma-controller: ZynqMP DMA driver Probe success
[    4.912567] xilinx-zynqmp-dma fd520000.dma-controller: ZynqMP DMA driver Probe success
[    4.920654] xilinx-zynqmp-dma fd530000.dma-controller: ZynqMP DMA driver Probe success
[    4.928736] xilinx-zynqmp-dma fd540000.dma-controller: ZynqMP DMA driver Probe success
[    4.936817] xilinx-zynqmp-dma fd550000.dma-controller: ZynqMP DMA driver Probe success
[    4.944900] xilinx-zynqmp-dma fd560000.dma-controller: ZynqMP DMA driver Probe success
[    4.952977] xilinx-zynqmp-dma fd570000.dma-controller: ZynqMP DMA driver Probe success
[    4.961139] xilinx-zynqmp-dma ffa80000.dma-controller: ZynqMP DMA driver Probe success
[    4.969224] xilinx-zynqmp-dma ffa90000.dma-controller: ZynqMP DMA driver Probe success
[    4.977304] xilinx-zynqmp-dma ffaa0000.dma-controller: ZynqMP DMA driver Probe success
[    4.985386] xilinx-zynqmp-dma ffab0000.dma-controller: ZynqMP DMA driver Probe success
[    4.993471] xilinx-zynqmp-dma ffac0000.dma-controller: ZynqMP DMA driver Probe success
[    5.001555] xilinx-zynqmp-dma ffad0000.dma-controller: ZynqMP DMA driver Probe success
[    5.009637] xilinx-zynqmp-dma ffae0000.dma-controller: ZynqMP DMA driver Probe success
[    5.017721] xilinx-zynqmp-dma ffaf0000.dma-controller: ZynqMP DMA driver Probe success
[    5.026034] xilinx-zynqmp-dpdma fd4c0000.dma-controller: Xilinx DPDMA engine is probed
[    5.034189] ahci-ceva fd0c0000.ahci: supply ahci not found, using dummy regulator
[    5.041743] ahci-ceva fd0c0000.ahci: supply phy not found, using dummy regulator
[    5.049167] ahci-ceva fd0c0000.ahci: supply target not found, using dummy regulator
[    5.067123] ahci-ceva fd0c0000.ahci: AHCI 0001.0301 32 slots 2 ports 6 Gbps 0x3 impl platform mode
[    5.076088] ahci-ceva fd0c0000.ahci: flags: 64bit ncq sntf pm clo only pmp fbs pio slum part ccc sds apst
[    5.086643] scsi host0: ahci-ceva
[    5.090235] scsi host1: ahci-ceva
[    5.093674] ata1: SATA max UDMA/133 mmio [mem 0xfd0c0000-0xfd0c1fff] port 0x100 irq 53
[    5.101594] ata2: SATA max UDMA/133 mmio [mem 0xfd0c0000-0xfd0c1fff] port 0x180 irq 53
[    5.110071] spi-nor spi0.0: found mt25qu512a, expected m25p80
[    5.116180] spi-nor spi0.0: mt25qu512a (131072 Kbytes)
[    5.121339] 3 fixed-partitions partitions found on MTD device spi0.0
[    5.127687] Creating 3 MTD partitions on "spi0.0":
[    5.132479] 0x000000000000-0x000001e00000 : "boot"
[    5.138111] 0x000001e00000-0x000001e40000 : "bootenv"
[    5.143943] 0x000001e40000-0x000004240000 : "kernel"
[    5.150486] xilinx_can ff070000.can can0: TDC Offset value not in range
[    5.158694] macb ff0e0000.ethernet: Not enabling partial store and forward
[    5.168759] macb ff0e0000.ethernet eth0: Cadence GEM rev 0x50070106 at 0xff0e0000 irq 39 (00:0a:35:00:22:01)
[    5.178982] xilinx-axipmon ffa00000.perf-monitor: Probed Xilinx APM
[    5.185517] xilinx-axipmon fd0b0000.perf-monitor: Probed Xilinx APM
[    5.191995] xilinx-axipmon fd490000.perf-monitor: Probed Xilinx APM
[    5.198480] xilinx-axipmon ffa10000.perf-monitor: Probed Xilinx APM
[    5.205785] pca953x 0-0020: supply vcc not found, using dummy regulator
[    5.212481] pca953x 0-0020: using no AI
[    5.217020] pca953x 0-0021: supply vcc not found, using dummy regulator
[    5.223694] pca953x 0-0021: using no AI
[    5.236545] i2c i2c-0: Added multiplexed i2c bus 2
[    5.247911] i2c i2c-0: Added multiplexed i2c bus 3
[    5.264469] random: fast init done
[    5.306197] i2c i2c-0: Added multiplexed i2c bus 4
[    5.311104] i2c i2c-0: Added multiplexed i2c bus 5
[    5.315900] pca954x 0-0075: registered 4 multiplexed busses for I2C mux pca9544
[    5.323254] cdns-i2c ff020000.i2c: 400 kHz mmio ff020000 irq 41
[    5.330568] at24 6-0054: supply vcc not found, using dummy regulator
[    5.337467] at24 6-0054: 1024 byte 24c08 EEPROM, writable, 1 bytes/write
[    5.344211] i2c i2c-1: Added multiplexed i2c bus 6
[    5.349542] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.356856] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.364160] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.371462] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.378766] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.386071] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.393377] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.400681] si5341 7-0036: no regulator set, defaulting vdd_sel to 2.5V for out
[    5.409103] si5341 7-0036: Chip: 5341 Grade: 1 Rev: 1
[    5.423270] ata1: SATA link down (SStatus 0 SControl 330)
[    5.428693] ata2: SATA link down (SStatus 0 SControl 330)
[    5.447518] i2c i2c-1: Added multiplexed i2c bus 7
[    5.455144] si570 8-005d: registered, current frequency 300000000 Hz
[    5.461539] i2c i2c-1: Added multiplexed i2c bus 8
[    5.481296] si570 9-005d: registered, current frequency 148500000 Hz
[    5.487684] i2c i2c-1: Added multiplexed i2c bus 9
[    5.492684] si5324 10-0069: si5328 probed
[    5.561371] si5324 10-0069: si5328 probe successful
[    5.566285] i2c i2c-1: Added multiplexed i2c bus 10
[    5.571277] i2c i2c-1: Added multiplexed i2c bus 11
[    5.576269] i2c i2c-1: Added multiplexed i2c bus 12
[    5.581268] i2c i2c-1: Added multiplexed i2c bus 13
[    5.586143] pca954x 1-0074: registered 8 multiplexed busses for I2C switch pca9548
[    5.594071] i2c i2c-1: Added multiplexed i2c bus 14
[    5.599077] i2c i2c-1: Added multiplexed i2c bus 15
[    5.604084] i2c i2c-1: Added multiplexed i2c bus 16
[    5.609099] i2c i2c-1: Added multiplexed i2c bus 17
[    5.614105] i2c i2c-1: Added multiplexed i2c bus 18
[    5.619111] i2c i2c-1: Added multiplexed i2c bus 19
[    5.624125] i2c i2c-1: Added multiplexed i2c bus 20
[    5.629134] i2c i2c-1: Added multiplexed i2c bus 21
[    5.634010] pca954x 1-0075: registered 8 multiplexed busses for I2C switch pca9548
[    5.641608] cdns-i2c ff030000.i2c: 400 kHz mmio ff030000 irq 42
[    5.651246] cdns-wdt fd4d0000.watchdog: Xilinx Watchdog Timer with timeout 60s
[    5.658709] cdns-wdt ff150000.watchdog: Xilinx Watchdog Timer with timeout 10s
[    5.666380] cpufreq: cpufreq_online: CPU0: Running at unlisted initial frequency: 1199880 KHz, changing to: 1199999 KHz
[    5.678941] zynqmp-display fd4a0000.display: vtc bridge property not present
[    5.688037] xilinx-dp-snd-codec fd4a0000.display:zynqmp_dp_snd_codec0: Xilinx DisplayPort Sound Codec probed
[    5.698127] xilinx-dp-snd-pcm zynqmp_dp_snd_pcm0: Xilinx DisplayPort Sound PCM probed
[    5.706189] xilinx-dp-snd-pcm zynqmp_dp_snd_pcm1: Xilinx DisplayPort Sound PCM probed
[    5.709881] mmc0: SDHCI controller on ff170000.mmc [ff170000.mmc] using ADMA 64-bit
[    5.722258] xilinx-dp-snd-card fd4a0000.display:zynqmp_dp_snd_card: Xilinx DisplayPort Sound Card probed
[    5.731840] OF: graph: no port node found in /axi/display@fd4a0000
[    5.738338] xlnx-drm xlnx-drm.0: bound fd4a0000.display (ops 0xffff800008f031e0)
[    5.759571] mmc0: new high speed SDXC card at address aaaa
[    5.765405] mmcblk0: mmc0:aaaa SD64G 59.5 GiB
[    5.771427]  mmcblk0: p1
[    6.825023] zynqmp-display fd4a0000.display: [drm] Cannot find any crtc or sizes
[    6.832662] [drm] Initialized xlnx 1.0.0 20130509 for fd4a0000.display on minor 0
[    6.840173] zynqmp-display fd4a0000.display: ZynqMP DisplayPort Subsystem driver probed
[    6.867661] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    6.873159] xhci-hcd xhci-hcd.1.auto: new USB bus registered, assigned bus number 1
[    6.880911] xhci-hcd xhci-hcd.1.auto: hcc params 0x0238f625 hci version 0x100 quirks 0x0000000002010810
[    6.890332] xhci-hcd xhci-hcd.1.auto: irq 62, io mem 0xfe200000
[    6.896468] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.15
[    6.904729] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.911950] usb usb1: Product: xHCI Host Controller
[    6.916820] usb usb1: Manufacturer: Linux 5.15.19-xilinx-v2022.1 xhci-hcd
[    6.923599] usb usb1: SerialNumber: xhci-hcd.1.auto
[    6.928762] hub 1-0:1.0: USB hub found
[    6.932531] hub 1-0:1.0: 1 port detected
[    6.936638] xhci-hcd xhci-hcd.1.auto: xHCI Host Controller
[    6.942138] xhci-hcd xhci-hcd.1.auto: new USB bus registered, assigned bus number 2
[    6.949800] xhci-hcd xhci-hcd.1.auto: Host supports USB 3.0 SuperSpeed
[    6.956489] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.15
[    6.964754] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.971971] usb usb2: Product: xHCI Host Controller
[    6.976838] usb usb2: Manufacturer: Linux 5.15.19-xilinx-v2022.1 xhci-hcd
[    6.983623] usb usb2: SerialNumber: xhci-hcd.1.auto
[    6.988803] hub 2-0:1.0: USB hub found
[    6.992573] hub 2-0:1.0: 1 port detected
[    6.999590] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    7.006604] of_cfs_init
[    7.009069] of_cfs_init: OK
[    7.012004] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    7.152830] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    7.159375] clk: Not disabling unused clocks
[    7.163931] ALSA device list:
[    7.166889]   #0: DisplayPort monitor
[    7.170828] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    7.171348] Freeing unused kernel memory: 2176K
[    7.179440] cfg80211: failed to load regulatory.db
[    7.209040] Run /init as init process
[    7.225946] systemd[1]: systemd 249.7+ running in system mode (+PAM -AUDIT -SELINUX -APPARMOR +IMA -SMACK +SECCOMP -GCRYPT -GNUTLS -OPENSSL +ACL +BLKID -CURL -ELFUTILS -FIDO2 -IDN2 -IDN -IPTC +KMOD -LIBCRYPTSETUP +LIBFDISK -PCRE2 -PWQUALITY -P11KIT -QRENCODE -BZIP2 -LZ4 -XZ -ZLIB +ZSTD +XKBCOMMON +UTMP +SYSVINIT default-hierarchy=hybrid)
[    7.256257] systemd[1]: Detected architecture arm64.

Welcome to PetaLinux 2022.1_release_S04190222 (honister)!

[    7.293154] systemd[1]: Hostname set to <xilinx-zcu102-20221>.
[    7.299099] random: systemd: uninitialized urandom read (16 bytes read)
[    7.305761] systemd[1]: Initializing machine ID from random generator.
[    7.339580] systemd-sysv-generator[247]: SysV service '/etc/init.d/watchdog-init' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.367098] systemd-sysv-generator[247]: SysV service '/etc/init.d/nfsserver' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.391125] systemd-sysv-generator[247]: SysV service '/etc/init.d/nfscommon' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.415573] systemd-sysv-generator[247]: SysV service '/etc/init.d/inetd.busybox' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.440615] systemd-sysv-generator[247]: SysV service '/etc/init.d/dropbear' lacks a native systemd unit file. Automatically generating a unit file for compatibility. Please update package to include a native systemd unit file, in order to make it more safe and robust.
[    7.659569] systemd[1]: Queued start job for default target Multi-User System.
[    7.667636] random: systemd: uninitialized urandom read (16 bytes read)
[    7.704478] systemd[1]: Created slice Slice /system/getty.
[  OK  ] Created slice Slice /system/getty.
[    7.725145] random: systemd: uninitialized urandom read (16 bytes read)
[    7.733055] systemd[1]: Created slice Slice /system/modprobe.
[  OK  ] Created slice Slice /system/modprobe.
[    7.754289] systemd[1]: Created slice Slice /system/serial-getty.
[  OK  ] Created slice Slice /system/serial-getty.
[    7.778180] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[    7.801273] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[  OK  ] Started Dispatch Password …ts to Console Directory Watch.
[    7.825202] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Started Forward Password R…uests to Wall Directory Watch.
[    7.849235] systemd[1]: Reached target Path Units.
[  OK  ] Reached target Path Units.
[    7.865110] systemd[1]: Reached target Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[    7.885092] systemd[1]: Reached target Slice Units.
[  OK  ] Reached target Slice Units.
[    7.901124] systemd[1]: Reached target Swaps.
[  OK  ] Reached target Swaps.
[    7.917510] systemd[1]: Listening on RPCbind Server Activation Socket.
[  OK  ] Listening on RPCbind Server Activati[    7.929023] zynqmp-display fd4a0000.display: [drm] Cannot find any crtc or sizes
on Socket.
[    7.949104] systemd[1]: Reached target RPC Port Mapper.
[  OK  ] Reached target RPC Port Mapper.
[    7.969351] systemd[1]: Listening on Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[    7.985245] systemd[1]: Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[    8.009547] systemd[1]: Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Audit Socket.
[    8.029293] systemd[1]: Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket (/dev/log).
[    8.049374] systemd[1]: Listening on Journal Socket.
[  OK  ] Listening on Journal Socket.
[    8.065510] systemd[1]: Listening on Network Service Netlink Socket.
[  OK  ] Listening on Network Service Netlink Socket.
[    8.089383] systemd[1]: Listening on udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[    8.109276] systemd[1]: Listening on udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[    8.129306] systemd[1]: Listening on User Database Manager Socket.
[  OK  ] Listening on User Database Manager Socket.
[    8.155575] systemd[1]: Mounting Huge Pages File System...
         Mounting Huge Pages File System...
[    8.175633] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[    8.199760] systemd[1]: Mounting Kernel Debug File System...
         Mounting Kernel Debug File System...
[    8.217408] systemd[1]: Condition check resulted in Kernel Trace File System being skipped.
[    8.228449] systemd[1]: Mounting Temporary Directory /tmp...
         Mounting Temporary Directory /tmp...
[    8.245330] systemd[1]: Condition check resulted in Create List of Static Device Nodes being skipped.
[    8.257552] systemd[1]: Starting Load Kernel Module configfs...
         Starting Load Kernel Module configfs...
[    8.276208] systemd[1]: Starting Load Kernel Module drm...
         Starting Load Kernel Module drm...
[    8.295939] systemd[1]: Starting Load Kernel Module fuse...
         Starting Load Kernel Module fuse...
[    8.319931] systemd[1]: Starting RPC Bind...
         Starting RPC Bind...
[    8.333231] systemd[1]: Condition check resulted in File System Check on Root Device being skipped.
[    8.342956] systemd[1]: Condition check resulted in Load Kernel Modules being skipped.
[    8.353225] systemd[1]: Mounting NFSD configuration filesystem...
         Mounting NFSD configuration filesystem...
[    8.371861] systemd[1]: Starting Remount Root and Kernel File Systems...
         Starting Remount Root and Kernel File Systems...
[    8.395922] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[    8.415945] systemd[1]: Starting Coldplug All udev Devices...
         Starting Coldplug All udev Devices...
[    8.437640] systemd[1]: Started RPC Bind.
[  OK  ] Started RPC Bind.
[    8.453543] systemd[1]: Mounted Huge Pages File System.
[  OK  ] Mounted Huge Pages File System.
[    8.473481] systemd[1]: Mounted POSIX Message Queue File System.
[  OK  ] Mounted POSIX Message Queue File System.
[    8.497512] systemd[1]: Mounted Kernel Debug File System.
[  OK  ] Mounted Kernel Debug File System.
[    8.517492] systemd[1]: Mounted Temporary Directory /tmp.
[  OK  ] Mounted Temporary Directory /tmp.
[    8.538178] systemd[1]: modprobe@configfs.service: Deactivated successfully.
[    8.546511] systemd[1]: Finished Load Kernel Module configfs.
[  OK  ] Finished Load Kernel Module configfs.
[    8.569789] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    8.577528] systemd[1]: Finished Load Kernel Module drm.
[  OK  ] Finished Load Kernel Module drm.
[    8.597779] systemd[1]: modprobe@fuse.service: Deactivated successfully.
[    8.605620] systemd[1]: Finished Load Kernel Module fuse.
[  OK  ] Finished Load Kernel Module fuse.
[    8.625358] systemd[1]: proc-fs-nfsd.mount: Mount process exited, code=exited, status=32/n/a
[    8.633988] systemd[1]: proc-fs-nfsd.mount: Failed with result 'exit-code'.
[    8.642163] systemd[1]: Failed to mount NFSD configuration filesystem.
[FAILED] Failed to mount NFSD configuration filesystem.
See 'systemctl status proc-fs-nfsd.mount' for details.
[    8.677046] systemd[1]: Dependency failed for NFS server and services.
[DEPEND] Dependency failed for NFS server and services.
[    8.705050] systemd[1]: Dependency failed for NFS Mount Daemon.
[DEPEND] Dependency failed for NFS Mount Daemon.
[    8.725038] systemd[1]: nfs-mountd.service: Job nfs-mountd.service/start failed with result 'dependency'.
[    8.734642] systemd[1]: nfs-server.service: Job nfs-server.service/start failed with result 'dependency'.
[    8.745731] systemd[1]: Finished Remount Root and Kernel File Systems.
[  OK  ] Finished Remount Root and Kernel File Systems.
[    8.770499] systemd[1]: Finished Apply Kernel Variables.
[  OK  ] Finished Apply Kernel Variables.
[    8.795707] systemd[1]: Condition check resulted in FUSE Control File System being skipped.
[    8.807120] systemd[1]: Mounting Kernel Configuration File System...
         Mounting Kernel Configuration File System...
[    8.829354] systemd[1]: Condition check resulted in Rebuild Hardware Database being skipped.
[    8.838145] systemd[1]: Condition check resulted in Platform Persistent Storage Archival being skipped.
[    8.850560] systemd[1]: Starting Create System Users...
         Starting Create System Users...
[    8.868901] systemd[1]: Mounted Kernel Configuration File System.
[  OK  ] Mounted Kernel Configuration File System.
[    8.890913] systemd[1]: Finished Create System Users.
[  OK  ] Finished Create System Users.
[    8.908379] systemd[1]: Starting Create Static Device Nodes in /dev...
         Starting Create Static Device Nodes in /dev...
[    8.931079] systemd[1]: Finished Create Static Device Nodes in /dev.
[  OK  ] Finished Create Static Device Nodes in /dev.
[    8.953420] systemd[1]: Reached target Preparation for Local File Systems.
[  OK  ] Reached target Preparation for Local File Systems.
[    8.979887] systemd[1]: Mounting /var/volatile...
         Mounting /var/volatile...
[    8.996736] systemd[1]: Started Entropy Daemon based on the HAVEGE algorithm.
[  OK  ] Started Entropy Daemon based on the HAVEGE algorithm.
[    9.021831] systemd[1]: systemd-journald.service: unit configures an IP firewall, but the local system does not support BPF/cgroup firewalling.
[    9.034764] systemd[1]: (This warning is only shown for the first unit using IP firewalling.)
[    9.047066] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[    9.065414] systemd[1]: Starting Rule-based Manager for Device Events and Files...
         Starting Rule-based Manage…for Device Events and Files...
[    9.091400] systemd[1]: Mounted /var/volatile.
[  OK  ] Mounted /var/volatile.
[    9.105409] systemd[1]: Condition check resulted in Bind mount volatile /var/cache being skipped.
[    9.125157] systemd[1]: Condition check resulted in Bind mount volatile /var/lib being skipped.
[    9.147565] systemd[1]: Starting Load/Save Random Seed...
         Starting Load/Save Random Seed...
[    9.165213] systemd[1]: Condition check resulted in Bind mount volatile /var/spool being skipped.
[    9.181228] systemd[1]: Condition check resulted in Bind mount volatile /srv being skipped.
[    9.189765] systemd[1]: Reached target Local File Systems.
[  OK  ] Reached target Local File Systems.
[    9.228424] systemd[1]: Starting Rebuild Dynamic Linker Cache...
         Starting Rebuild Dynamic Linker Cache...
[    9.245869] systemd[1]: Started Journal Service.
[  OK  ] Started Journal Service.
[  OK  ] Started Rule-based Manager for Device Events and Files.
[  OK  ] Finished Coldplug All udev Devices.
[  OK  ] Finished Rebuild Dynamic Linker Cache.
         Starting Flush Journal to Persistent Storage...
         Starting Network Configuration...
[    9.354880] systemd-journald[278]: Received client request to flush runtime journal.
[  OK  ] Finished Flush Journal to Persistent Storage.
         Starting Create Volatile Files and Directories...
[  OK  ] Reached target Sound Card.
[  OK  ] Finished Create Volatile Files and Directories.
         Starting Run pending postinsts...
         Starting Rebuild Journal Catalog...
         Starting Network Time Synchronization...
         Starting Record System Boot/Shutdown in UTMP...
[    9.585285] Unloading old XRT Linux kernel modules
[  OK  ] Finished Record System Boot/Shutdown in UTMP.
[    9.632107] Loading new XRT Linux kernel modules
[    9.651736] zocl: loading out-of-tree module taints kernel.
[    9.745024] INFO: Creating ICD entry for Xilinx Platform
[  OK  ] Finished Rebuild Journal Catalog.
[  OK  ] Started Network Configuration.
[   10.109602] macb ff0e0000.ethernet eth0: PHY [ff0e0000.ethernet-ffffffff:0c] driver [TI DP83867] (irq=POLL)
[   10.119405] macb ff0e0000.ethernet eth0: configuring for phy/rgmii-id link mode
[  OK  ] Listening on Load/Save RF …itch Status /dev/rfkill Watch.
[   10.187177] pps pps0: new PPS source ptp0
[   10.209828] macb ff0e0000.ethernet: gem-ptp-timer ptp clock registered.
         Starting Network Name Resolution...
         Starting Update is Completed...
[  OK  ] Finished Update is Completed.
[  OK  ] Finished Run pending postinsts.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Started Network Name Resolution.
[   10.887781] random: crng init done
[   10.891211] random: 7 urandom warning(s) missed due to ratelimiting
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
[   11.841992] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.

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

xilinx-zcu102-20221 login: [   14.270736] macb ff0e0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control tx
[   14.278339] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

xilinx-zcu102-20221 login:
```
## **Known Issues**

---