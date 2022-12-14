# Performance
<table>
    <tr>
        <td> </td> 
        <td colspan="4">TCP (Gbps)</td> 
        <td colspan="4">UDP (Gbps)</td> 
   </tr>
    <tr>
        <td>MTU</td>    
        <td>TX</td> 
        <td>CPU%</td> 
        <td>RX</td> 
        <td>CPU%</td> 
        <td>TX</td> 
        <td>CPU%</td> 
        <td>RX</td> 
        <td>CPU%</td>
   </tr>
    <tr>
        <td>1500</td>    
        <td>3.55</td> 
        <td>85.8%</td> 
        <td>2.6</td> 
        <td>62.2%</td> 
        <td>3.3</td> 
        <td>99.9%</td> 
        <td>2.34</td> 
        <td>89.9%</td>
    </tr>
    <tr>
        <td>9000</td>    
        <td>9.6</td> 
        <td>62.2%</td> 
        <td>9.6</td> 
        <td>91.5%</td> 
        <td>9.9</td> 
        <td>87%</td> 
        <td>9</td> 
        <td>93.5%</td>
    </tr>  

</table>

+ These benchmark performance numbers were obtained by connecting Xilinx boards to Linux PC.
+ OS：Ubuntu18.04.1
+ CPU：Intel® Xeon(R) W-2145 CPU @ 3.70GHz × 16 
+ NIC：Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection. 
+ The tools used is iperf3
+ Performance benchmark numbers mentioned in below tables are for reference and dependent on multiple factors i.e setup , vivado design configuration  etc. 
+ NOTE: CPU utilization reported in below performance tables is an aggregate of all CPU's. i.e on ZynqMP platform, it reports combined utilization of all four A53 cores.


# Table of content
|   | TCP | UDP |
|----------|----------|----------|
| TX | [TCP_TX_MTU1500](#tcp_tx_mtu1500) | [UDP_TX_MTU1500](#udp_tx_mtu1500) |
|    | [TCP_TX_MTU9000](#tcp_tx_mtu9000) | [UDP_TX_MTU9000](#udp_tx_mtu9000) |
| RX | [TCP_RX_MTU1500](#tcp_rx_mtu1500) | [UDP_RX_MTU1500](#udp_rx_mtu1500) |
|    | [TCP_RX_MTU9000](#tcp_rx_mtu9000) | [UDP_RX_MTU9000](#udp_rx_mtu9000) |


# Pre-requisites:
+ Set Ethernet AXI MCDMA TX interrupt affinity to core-1
```
echo 2 > /proc/irq/xx/smp_affinity
```
+ Run iperf servers on ZynqMP (core1, core2 and core3)
```
iperf3 -s -p 5101 -A 1 &
iperf3 -s -p 5102 -A 2 &
iperf3 -s -p 5103 -A 3 &
```
+ Enable RFS(receive flow steering) & Set R/W buffer size
```
//RFS is disabled by default. To enable RFS, we must edit rps_sock_flow_entries and rps_flow_cnt
//For details refer : https://www.kernel.org/doc/Documentation/networking/scaling.txt
echo 32768 > /proc/sys/net/core/rps_sock_flow_entries
echo 2048 > /sys/class/net/eth1/queues/rx-0/rps_flow_cnt
echo 2048 > /sys/class/net/eth1/queues/rx-1/rps_flow_cnt
echo 2048 > /sys/class/net/eth1/queues/rx-2/rps_flow_cnt

echo 16777216 > /proc/sys/net/core/rmem_max
echo 16777216 > /proc/sys/net/core/rmem_default
echo 16777216 > /proc/sys/net/core/wmem_max
echo 16777216 > /proc/sys/net/core/wmem_default
```
+ Run iperf servers on the remote host
```
server:~# iperf3 -s -p 5101 & ; iperf3 -s -p 5102 & ; iperf3 -s -p 5103 & ; iperf3 -s -p 5104 &
```


## TCP_TX_MTU1500
```
#commands in a_test_eth.sh
echo "SERVER_IP is 192.168.1.2"
iperf3 -c 192.168.1.2 -p 5202 -i 45 -t 45 -b 4000M -Z -T 5202 -A 2 &
sleep 1s
iperf3 -c 192.168.1.2 -p 5203 -i 45 -t 45 -b 4000M -Z -T 5203 -A 3 &
sleep 1s
mpstat -P ALL 1 40
```
<details>
<summary>terminal log</summary>

```
./a_test_eth.sh  
SERVER_IP is 192.168.1.2
5202:  Connecting to host 192.168.1.2, port 5202
5203:  Connecting to host 192.168.1.2, port 5203
5202:  [  5] local 192.168.1.10 port 48816 connected to 192.168.1.2 port 5202
5203:  [  5] local 192.168.1.10 port 45190 connected to 192.168.1.2 port 5203
```
</details>


<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all    0.28    0.00   49.56    0.00    9.83   26.13    0.00    0.00   14.20
Average:       0    0.00    0.00    0.05    0.00    6.84   72.07    0.00    0.00   21.04
Average:       1    0.03    0.00    0.13    0.00   31.73   32.69    0.00    0.00   35.44
Average:       2    0.68    0.00   98.55    0.00    0.48    0.03    0.00    0.00    0.28
Average:       3    0.40    0.00   98.80    0.00    0.50    0.02    0.00    0.00    0.27  
```
</details>
 
<details>
<summary>performance</summary>

```
5202:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5202:  [  5]   0.00-45.00  sec  9.31 GBytes  1.78 Gbits/sec  182    325 KBytes       
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bitrate         Retr
5202:  [  5]   0.00-45.00  sec  9.31 GBytes  1.78 Gbits/sec  182             sender
5202:  [  5]   0.00-45.00  sec  9.31 GBytes  1.78 Gbits/sec                  receiver
5202:  
5202:  iperf Done.

5203:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5203:  [  5]   0.00-45.00  sec  9.28 GBytes  1.77 Gbits/sec  162    341 KBytes       
5203:  - - - - - - - - - - - - - - - - - - - - - - - - -
5203:  [ ID] Interval           Transfer     Bitrate         Retr
5203:  [  5]   0.00-45.00  sec  9.28 GBytes  1.77 Gbits/sec  162             sender
5203:  [  5]   0.00-45.00  sec  9.28 GBytes  1.77 Gbits/sec                  receiver
5203:  
5203:  iperf Done.
```
</details>


 












## UDP_TX_MTU1500
```
#commands in a_test_eth.sh
echo "SERVER_IP is 192.168.1.2"
iperf3 -u -P 2 -c 192.168.1.2 -p 5201 -i 60 -t 60 -b 2500M -Z -T 5201 -A 0 &
sleep 1s
iperf3 -u -P 2 -c 192.168.1.2 -p 5202 -i 60 -t 60 -b 2500M -Z -T 5202 -A 1 &
sleep 1s
iperf3 -u -P 2 -c 192.168.1.2 -p 5203 -i 60 -t 60 -b 2500M -Z -T 5203 -A 2 &
sleep 1s
iperf3 -u -P 2 -c 192.168.1.2 -p 5204 -i 60 -t 60 -b 2500M -Z -T 5204 -A 3 &
sleep 1s
mpstat -P ALL 1 40
```

<details>
<summary>terminal log</summary>

```
./a_test_eth.sh 
SERVER_IP is 192.168.1.2
5201:  Connecting to host 192.168.1.2, port 5201
5201:  [  5] local 192.168.1.10 port 54417 connected to 192.168.1.2 port 5201
5201:  [  7] local 192.168.1.10 port 50678 connected to 192.168.1.2 port 5201
5202:  Connecting to host 192.168.1.2, port 5202
5202:  [  5] local 192.168.1.10 port 50488 connected to 192.168.1.2 port 5202
5202:  [  7] local 192.168.1.10 port 56364 connected to 192.168.1.2 port 5202
5203:  Connecting to host 192.168.1.2, port 5203
5203:  [  5] local 192.168.1.10 port 55263 connected to 192.168.1.2 port 5203
5203:  [  7] local 192.168.1.10 port 42296 connected to 192.168.1.2 port 5203
5204:  Connecting to host 192.168.1.2, port 5204
5204:  [  5] local 192.168.1.10 port 60722 connected to 192.168.1.2 port 5204
5204:  [  7] local 192.168.1.10 port 44425 connected to 192.168.1.2 port 5204  
```
</details>

<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all   10.87    0.00   78.13    0.00    6.73    4.27    0.00    0.00    0.00
Average:       0   12.65    0.00   87.12    0.00    0.22    0.00    0.00    0.00    0.00
Average:       1    4.32    0.00   52.30    0.00   26.35   17.03    0.00    0.00    0.00
Average:       2   12.95    0.00   86.87    0.00    0.18    0.00    0.00    0.00    0.00
Average:       3   13.57    0.00   86.23    0.00    0.17    0.02    0.00    0.00    0.00 
```
</details>

<details>
<summary>performance</summary>

```
5201:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5201:  [  5]   0.00-60.00  sec  3.35 GBytes   479 Mbits/sec  2480818  
5201:  [  7]   0.00-60.00  sec  3.35 GBytes   479 Mbits/sec  2480818  
5201:  [SUM]   0.00-60.00  sec  6.69 GBytes   958 Mbits/sec  4961636  
5201:  - - - - - - - - - - - - - - - - - - - - - - - - -
5201:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5201:  [  5]   0.00-60.00  sec  3.35 GBytes   479 Mbits/sec  0.000 ms  0/2480818 (0%)  sender
5201:  [  5]   0.00-60.01  sec  3.34 GBytes   479 Mbits/sec  0.025 ms  1749/2480818 (0.071%)  receiver
5201:  [  7]   0.00-60.00  sec  3.35 GBytes   479 Mbits/sec  0.000 ms  0/2480818 (0%)  sender
5201:  [  7]   0.00-60.01  sec  3.34 GBytes   479 Mbits/sec  0.025 ms  1740/2480818 (0.07%)  receiver
5201:  [SUM]   0.00-60.00  sec  6.69 GBytes   958 Mbits/sec  0.000 ms  0/4961636 (0%)  sender
5201:  [SUM]   0.00-60.01  sec  6.69 GBytes   957 Mbits/sec  0.025 ms  3489/4961636 (0.07%)  receiver
5201:  
5201:  iperf Done.

5202:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5202:  [  5]   0.00-60.00  sec  1.81 GBytes   260 Mbits/sec  1345518  
5202:  [  7]   0.00-60.00  sec  1.81 GBytes   260 Mbits/sec  1345518  
5202:  [SUM]   0.00-60.00  sec  3.63 GBytes   520 Mbits/sec  2691036  
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5202:  [  5]   0.00-60.00  sec  1.81 GBytes   260 Mbits/sec  0.000 ms  0/1345518 (0%)  sender
5202:  [  5]   0.00-60.01  sec  1.81 GBytes   260 Mbits/sec  0.016 ms  318/1345518 (0.024%)  receiver
5202:  [  7]   0.00-60.00  sec  1.81 GBytes   260 Mbits/sec  0.000 ms  0/1345518 (0%)  sender
5202:  [  7]   0.00-60.01  sec  1.81 GBytes   260 Mbits/sec  0.019 ms  326/1345518 (0.024%)  receiver
5202:  [SUM]   0.00-60.00  sec  3.63 GBytes   520 Mbits/sec  0.000 ms  0/2691036 (0%)  sender
5202:  [SUM]   0.00-60.01  sec  3.63 GBytes   519 Mbits/sec  0.018 ms  644/2691036 (0.024%)  receiver
5202:  
5202:  iperf Done.

5203:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5203:  [  5]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  2472652  
5203:  [  7]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  2472652  
5203:  [SUM]   0.00-60.00  sec  6.67 GBytes   955 Mbits/sec  4945304  
5203:  - - - - - - - - - - - - - - - - - - - - - - - - -
5203:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5203:  [  5]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  0.000 ms  0/2472652 (0%)  sender
5203:  [  5]   0.00-60.01  sec  3.33 GBytes   477 Mbits/sec  0.021 ms  652/2472652 (0.026%)  receiver
5203:  [  7]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  0.000 ms  0/2472652 (0%)  sender
5203:  [  7]   0.00-60.01  sec  3.33 GBytes   477 Mbits/sec  0.022 ms  663/2472652 (0.027%)  receiver
5203:  [SUM]   0.00-60.00  sec  6.67 GBytes   955 Mbits/sec  0.000 ms  0/4945304 (0%)  sender
5203:  [SUM]   0.00-60.01  sec  6.67 GBytes   954 Mbits/sec  0.022 ms  1315/4945304 (0.027%)  receiver
5203:  
5203:  iperf Done.

5204:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5204:  [  5]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  2469293  
5204:  [  7]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  2469293  
5204:  [SUM]   0.00-60.00  sec  6.66 GBytes   953 Mbits/sec  4938586  
5204:  - - - - - - - - - - - - - - - - - - - - - - - - -
5204:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5204:  [  5]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  0.000 ms  0/2469293 (0%)  sender
5204:  [  5]   0.00-60.01  sec  3.33 GBytes   476 Mbits/sec  0.023 ms  2001/2469293 (0.081%)  receiver
5204:  [  7]   0.00-60.00  sec  3.33 GBytes   477 Mbits/sec  0.000 ms  0/2469293 (0%)  sender
5204:  [  7]   0.00-60.01  sec  3.33 GBytes   476 Mbits/sec  0.024 ms  2012/2469293 (0.081%)  receiver
5204:  [SUM]   0.00-60.00  sec  6.66 GBytes   953 Mbits/sec  0.000 ms  0/4938586 (0%)  sender
5204:  [SUM]   0.00-60.01  sec  6.65 GBytes   953 Mbits/sec  0.023 ms  4013/4938586 (0.081%)  receiver
5204:  
5204:  iperf Done.
```
</details>




























## TCP_TX_MTU9000
```
#commands in a_test_eth.sh
echo "SERVER_IP is 192.168.1.2"
#sudo ifconfig eth1 down
#sudo ifconfig eth1 mtu 9000
#sudo ifconfig eth1 inet 192.168.1.10
#sudo ifconfig eth1 up
iperf3 -c 192.168.1.2 -p 5201 -i 60 -t 60 -b 4800M -T 5201 -A 2 &
sleep 1s
iperf3 -c 192.168.1.2 -p 5202 -i 60 -t 60 -b 4800M -T 5202 -A 3 &
sleep 1s
mpstat -P ALL 1 40
```
<details>
<summary>terminal log</summary>

```
./a_test_eth.sh 
SERVER_IP is 192.168.1.2
5201:  Connecting to host 192.168.1.2, port 5201
5201:  [  5] local 192.168.1.10 port 45218 connected to 192.168.1.2 port 5201
5202:  Connecting to host 192.168.1.2, port 5202
5202:  [  5] local 192.168.1.10 port 48838 connected to 192.168.1.2 port 5202  
```
</details>

<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all    0.68    0.00   42.43    0.00    9.48    9.67    0.00    0.00   37.75
Average:       0    0.03    0.00    0.13    0.00   13.90   24.31    0.00    0.00   61.64
Average:       1    0.05    0.00    0.13    0.00   23.20    8.94    0.00    0.00   67.68
Average:       2    2.01    0.00   82.10    0.00    0.36    5.65    0.00    0.00    9.87
Average:       3    0.74    0.00   87.10    0.00    0.35    0.32    0.00    0.00   11.49 
```
</details>

<details>
<summary>performance</summary>

```
5201:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5201:  [  5]   0.00-60.00  sec  33.5 GBytes  4.80 Gbits/sec   58    900 KBytes       
5201:  - - - - - - - - - - - - - - - - - - - - - - - - -
5201:  [ ID] Interval           Transfer     Bitrate         Retr
5201:  [  5]   0.00-60.00  sec  33.5 GBytes  4.80 Gbits/sec   58             sender
5201:  [  5]   0.00-60.01  sec  33.5 GBytes  4.80 Gbits/sec                  receiver
5201:  
5201:  iperf Done.

5202:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5202:  [  5]   0.00-60.00  sec  33.5 GBytes  4.80 Gbits/sec   39    830 KBytes       
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bitrate         Retr
5202:  [  5]   0.00-60.00  sec  33.5 GBytes  4.80 Gbits/sec   39             sender
5202:  [  5]   0.00-60.01  sec  33.5 GBytes  4.80 Gbits/sec                  receiver
5202:  
5202:  iperf Done.
```
</details>



























## UDP_TX_MTU9000 
```
#commands
#echo "SERVER_IP is 192.168.1.2"
#sudo ifconfig eth1 down
#sudo ifconfig eth1 mtu 9000
#sudo ifconfig eth1 inet 192.168.1.10
#sudo ifconfig eth1 up
iperf3 -u -P 2 -c 192.168.1.2 -p 5201 -i 60 -t 60 -b 2400M -Z -T 5201 -A 0 &
sleep 1s
iperf3 -u -P 2 -c 192.168.1.2 -p 5202 -i 60 -t 60 -b 2400M -Z -T 5202 -A 1 &
sleep 1s
iperf3 -u -P 2 -c 192.168.1.2 -p 5203 -i 60 -t 60 -b 2400M -Z -T 5203 -A 2 &
sleep 1s
iperf3 -u -P 2 -c 192.168.1.2 -p 5204 -i 60 -t 60 -b 2400M -Z -T 5204 -A 3 &
sleep 1s
mpstat -P ALL 1 40
```

<details>
<summary>terminal log</summary>

```
./a_test_eth.sh 
SERVER_IP is 192.168.1.2
5201:  Connecting to host 192.168.1.2, port 5201
5201:  [  5] local 192.168.1.10 port 54308 connected to 192.168.1.2 port 5201
5201:  [  7] local 192.168.1.10 port 34007 connected to 192.168.1.2 port 5201
5202:  Connecting to host 192.168.1.2, port 5202
5202:  [  5] local 192.168.1.10 port 48463 connected to 192.168.1.2 port 5202
5202:  [  7] local 192.168.1.10 port 45824 connected to 192.168.1.2 port 5202
5203:  Connecting to host 192.168.1.2, port 5203
5203:  [  5] local 192.168.1.10 port 55994 connected to 192.168.1.2 port 5203
5203:  [  7] local 192.168.1.10 port 54990 connected to 192.168.1.2 port 5203
5204:  Connecting to host 192.168.1.2, port 5204
5204:  [  5] local 192.168.1.10 port 38335 connected to 192.168.1.2 port 5204
5204:  [  7] local 192.168.1.10 port 39157 connected to 192.168.1.2 port 5204  
```
</details>

<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all    7.17    0.00   68.81    0.00    7.02    3.84    0.00    0.00   13.16
Average:       0    8.48    0.00   74.08    0.00    0.72    0.03    0.00    0.00   16.70
Average:       1    3.07    0.00   50.43    0.00   25.91   15.28    0.00    0.00    5.31
Average:       2    8.40    0.00   77.69    0.00    0.72    0.03    0.00    0.00   13.17
Average:       3    8.71    0.00   73.09    0.00    0.69    0.03    0.00    0.00   17.48 
```
</details>

<details>
<summary>performance</summary>

```
5201:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5201:  [  5]   0.00-60.00  sec  9.55 GBytes  1.37 Gbits/sec  1146314  
5201:  [  7]   0.00-60.00  sec  9.41 GBytes  1.35 Gbits/sec  1129343  
5201:  [SUM]   0.00-60.00  sec  19.0 GBytes  2.72 Gbits/sec  2275657  
5201:  - - - - - - - - - - - - - - - - - - - - - - - - -
5201:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5201:  [  5]   0.00-60.00  sec  9.55 GBytes  1.37 Gbits/sec  0.000 ms  0/1146314 (0%)  sender
5201:  [  5]   0.00-60.01  sec  9.55 GBytes  1.37 Gbits/sec  0.026 ms  22/1146314 (0.0019%)  receiver
5201:  [  7]   0.00-60.00  sec  9.41 GBytes  1.35 Gbits/sec  0.000 ms  0/1129343 (0%)  sender
5201:  [  7]   0.00-60.01  sec  9.41 GBytes  1.35 Gbits/sec  0.031 ms  28/1129343 (0.0025%)  receiver
5201:  [SUM]   0.00-60.00  sec  19.0 GBytes  2.72 Gbits/sec  0.000 ms  0/2275657 (0%)  sender
5201:  [SUM]   0.00-60.01  sec  19.0 GBytes  2.71 Gbits/sec  0.028 ms  50/2275657 (0.0022%)  receiver
5201:  
5201:  iperf Done.

5202:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5202:  [  5]   0.00-60.00  sec  6.60 GBytes   944 Mbits/sec  791625  
5202:  [  7]   0.00-60.00  sec  5.65 GBytes   808 Mbits/sec  677443  
5202:  [SUM]   0.00-60.00  sec  12.2 GBytes  1.75 Gbits/sec  1469068  
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5202:  [  5]   0.00-60.00  sec  6.60 GBytes   944 Mbits/sec  0.000 ms  0/791625 (0%)  sender
5202:  [  5]   0.00-60.01  sec  6.60 GBytes   944 Mbits/sec  0.021 ms  0/791625 (0%)  receiver
5202:  [  7]   0.00-60.00  sec  5.65 GBytes   808 Mbits/sec  0.000 ms  0/677443 (0%)  sender
5202:  [  7]   0.00-60.01  sec  5.65 GBytes   808 Mbits/sec  0.021 ms  0/677443 (0%)  receiver
5202:  [SUM]   0.00-60.00  sec  12.2 GBytes  1.75 Gbits/sec  0.000 ms  0/1469068 (0%)  sender
5202:  [SUM]   0.00-60.01  sec  12.2 GBytes  1.75 Gbits/sec  0.021 ms  0/1469068 (0%)  receiver
5202:  
5202:  iperf Done.

5203:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5203:  [  5]   0.00-60.00  sec  9.82 GBytes  1.41 Gbits/sec  1178223  
5203:  [  7]   0.00-60.00  sec  9.84 GBytes  1.41 Gbits/sec  1180830  
5203:  [SUM]   0.00-60.00  sec  19.7 GBytes  2.81 Gbits/sec  2359053  
5203:  - - - - - - - - - - - - - - - - - - - - - - - - -
5203:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5203:  [  5]   0.00-60.00  sec  9.82 GBytes  1.41 Gbits/sec  0.000 ms  0/1178223 (0%)  sender
5203:  [  5]   0.00-60.01  sec  9.82 GBytes  1.41 Gbits/sec  0.025 ms  0/1178223 (0%)  receiver
5203:  [  7]   0.00-60.00  sec  9.84 GBytes  1.41 Gbits/sec  0.000 ms  0/1180830 (0%)  sender
5203:  [  7]   0.00-60.01  sec  9.84 GBytes  1.41 Gbits/sec  0.026 ms  0/1180828 (0%)  receiver
5203:  [SUM]   0.00-60.00  sec  19.7 GBytes  2.81 Gbits/sec  0.000 ms  0/2359053 (0%)  sender
5203:  [SUM]   0.00-60.01  sec  19.7 GBytes  2.81 Gbits/sec  0.026 ms  0/2359051 (0%)  receiver
5203:  
5203:  iperf Done.

5204:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5204:  [  5]   0.00-60.00  sec  9.50 GBytes  1.36 Gbits/sec  1139959  
5204:  [  7]   0.00-60.00  sec  9.38 GBytes  1.34 Gbits/sec  1125399  
5204:  [SUM]   0.00-60.00  sec  18.9 GBytes  2.70 Gbits/sec  2265358  
5204:  - - - - - - - - - - - - - - - - - - - - - - - - -
5204:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5204:  [  5]   0.00-60.00  sec  9.50 GBytes  1.36 Gbits/sec  0.000 ms  0/1139959 (0%)  sender
5204:  [  5]   0.00-60.01  sec  9.50 GBytes  1.36 Gbits/sec  0.019 ms  152/1139959 (0.013%)  receiver
5204:  [  7]   0.00-60.00  sec  9.38 GBytes  1.34 Gbits/sec  0.000 ms  0/1125399 (0%)  sender
5204:  [  7]   0.00-60.01  sec  9.38 GBytes  1.34 Gbits/sec  0.020 ms  151/1125399 (0.013%)  receiver
5204:  [SUM]   0.00-60.00  sec  18.9 GBytes  2.70 Gbits/sec  0.000 ms  0/2265358 (0%)  sender
5204:  [SUM]   0.00-60.01  sec  18.9 GBytes  2.70 Gbits/sec  0.019 ms  303/2265358 (0.013%)  receiver
5204:  
5204:  iperf Done.
```
</details>
















## TCP_RX_MTU9000
```
#commands
#---------------used on PC-----------------------
#echo "SERVER_IP is 192.168.1.10"
#sudo ifconfig enp179s0f0 down
#sudo ifconfig enp179s0f0 mtu 9000
#sudo ifconfig enp179s0f0 inet 192.168.1.2
#sudo ifconfig enp179s0f0 up
iperf3 -c 192.168.1.10 -p 5201 -i 60 -t 60 -b 3200M -Z -T 5201 &
sleep 1s
iperf3 -c 192.168.1.10 -p 5202 -i 60 -t 60 -b 3200M -Z -T 5202 &
sleep 1s
iperf3 -c 192.168.1.10 -p 5203 -i 60 -t 60 -b 3200M -Z -T 5203 &
```

<details>
<summary>terminal log</summary>

```
./a_test_eth.sh 
SERVER_IP is 192.168.1.10
5201:  Connecting to host 192.168.1.10, port 5201
5202:  Connecting to host 192.168.1.10, port 5202  
5203:  Connecting to host 192.168.1.10, port 5203
```
</details>

<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all    0.52    0.00   27.87    0.00    7.60   55.55    0.00    0.00    8.47
Average:       0    0.03    0.00    0.08    0.00   20.87   75.19    0.00    0.00    3.84
Average:       1    0.67    0.00   37.31    0.00    7.99   48.88    0.00    0.00    5.14
Average:       2    0.58    0.00   39.72    0.00    0.79   46.80    0.00    0.00   12.10
Average:       3    0.74    0.00   34.00    0.00    0.68   51.68    0.00    0.00   12.91  
```
</details>

<details>
<summary>performance</summary>

```
5201:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5201:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec  135    891 KBytes       
5201:  - - - - - - - - - - - - - - - - - - - - - - - - -
5201:  [ ID] Interval           Transfer     Bitrate         Retr
5201:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec  135             sender
5201:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec                  receiver
5201:  
5201:  iperf Done.

5202:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5202:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec   49    987 KBytes       
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bitrate         Retr
5202:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec   49             sender
5202:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec                  receiver
5202:  
5202:  iperf Done.

5203:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5203:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec  149   1.02 MBytes       
5203:  - - - - - - - - - - - - - - - - - - - - - - - - -
5203:  [ ID] Interval           Transfer     Bitrate         Retr
5203:  [  5]   0.00-60.00  sec  22.4 GBytes  3.20 Gbits/sec  149             sender
5203:  [  5]   0.00-59.99  sec  22.4 GBytes  3.20 Gbits/sec                  receiver
5203:  
5203:  iperf Done.
```
</details>







## UDP_RX_MTU9000
```
#commands
#---------------used on board--------------------
#echo f > /sys/class/net/eth1/queues/rx-0/rps_cpus
#echo 32768 > /proc/sys/net/core/rps_sock_flow_entries
#echo 2048 > /sys/class/net/eth1/queues/rx-0/rps_flow_cnt
#echo 2048 >  /sys/class/net/eth1/queues/rx-1/rps_flow_cnt
#---------------used on server-----------------------
#echo "SERVER_IP is 192.168.1.10"
#sudo ifconfig enp179s0f0 down
#sudo ifconfig enp179s0f0 mtu 9000
#sudo ifconfig enp179s0f0 inet 192.168.1.2
#sudo ifconfig enp179s0f0 up
iperf3 -u -c 192.168.1.10 -p 5201 -i 60 -t 60 -b 3000M -Z -T 5201 -l 8972 &
sleep 1s
iperf3 -u -c 192.168.1.10 -p 5202 -i 60 -t 60 -b 3000M -Z -T 5202 -l 8972 &
sleep 1s
iperf3 -u -c 192.168.1.10 -p 5203 -i 60 -t 60 -b 3000M -Z -T 5203 -l 8972 &
```

+ NOTE: Since 4.19 kernel we need to explictly set buffer length to avoid fragmentation.

<details>
<summary>terminal log</summary>

```
./a_test_eth.sh 
SERVER_IP is 192.168.1.10
5201:  Connecting to host 192.168.1.10, port 5201
5201:  [  4] local 192.168.1.2 port 52847 connected to 192.168.1.10 port 5201
5202:  Connecting to host 192.168.1.10, port 5202
5202:  [  4] local 192.168.1.2 port 41079 connected to 192.168.1.10 port 5202 
5203:  Connecting to host 192.168.1.10, port 5203
5203:  [  4] local 192.168.1.2 port 42039 connected to 192.168.1.10 port 5203    
```
</details>

<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all    4.56    0.00   52.65    0.00    7.49   28.80    0.00    0.00    6.50
Average:       0    0.03    0.00    0.03    0.00   27.41   65.56    0.00    0.00    6.97
Average:       1    5.68    0.00   67.09    0.00    1.77   18.12    0.00    0.00    7.34
Average:       2    5.35    0.00   68.28    0.00    1.76   18.41    0.00    0.00    6.20
Average:       3    6.58    0.00   67.97    0.00    1.79   18.14    0.00    0.00    5.53 
```
</details>

<details>
<summary>performance</summary>

```
5201:  [ ID] Interval           Transfer     Bandwidth       Total Datagrams
5201:  [  4]   0.00-60.00  sec  27.1 GBytes  3.88 Gbits/sec  3245182  
5201:  - - - - - - - - - - - - - - - - - - - - - - - - -
5201:  [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
5201:  [  4]   0.00-60.00  sec  27.1 GBytes  3.88 Gbits/sec  0.036 ms  2176964/3245182 (67%)  
5201:  [  4] Sent 3245182 datagrams
5201:  
5201:  iperf Done.

5202:  [ ID] Interval           Transfer     Bandwidth       Total Datagrams
5202:  [  4]   0.00-60.00  sec  27.1 GBytes  3.88 Gbits/sec  3244178  
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
5202:  [  4]   0.00-60.00  sec  27.1 GBytes  3.88 Gbits/sec  0.012 ms  2781195/3244178 (86%)  
5202:  [  4] Sent 3244178 datagrams
5202:  
5202:  iperf Done. 
  
#board log
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-60.00  sec  8.93 GBytes  1.28 Gbits/sec  0.036 ms  2176964/3245182 (67%)  receiver

[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-59.99  sec  3.87 GBytes   554 Mbits/sec  0.012 ms  2781195/3244178 (86%)  receiver
```
</details>











## UDP_RX_MTU1500
```
#commands
#---------------used on board--------------------
#echo f > /sys/class/net/eth1/queues/rx-0/rps_cpus
#echo 32768 > /proc/sys/net/core/rps_sock_flow_entries
#echo 2048 > /sys/class/net/eth1/queues/rx-0/rps_flow_cnt
#echo 2048 >  /sys/class/net/eth1/queues/rx-1/rps_flow_cnt
#---------------used on PC-----------------------
#echo "SERVER_IP is 192.168.1.10"
#sudo ifconfig enp179s0f0 down
#sudo ifconfig enp179s0f0 mtu 1500
#sudo ifconfig enp179s0f0 inet 192.168.1.2
#sudo ifconfig enp179s0f0 up
iperf3 -u -c 192.168.1.10 -p 5201 -i 60 -t 60 -b 800M -Z -T 5201 -l 1472 &
sleep 1s
iperf3 -u -c 192.168.1.10 -p 5202 -i 60 -t 60 -b 800M -Z -T 5202 -l 1472 &
sleep 1s
iperf3 -u -c 192.168.1.10 -p 5203 -i 60 -t 60 -b 800M -Z -T 5203 -l 1472 &
```
+ NOTE: Since 4.19 kernel we need to explictly set buffer length to avoid fragmentation.

<details>
<summary>terminal log</summary>

```
./a_test_eth.sh 
5201:  Connecting to host 192.168.1.10, port 5201
5201:  [  4] local 192.168.1.2 port 33907 connected to 192.168.1.10 port 5201
5202:  Connecting to host 192.168.1.10, port 5202
5202:  [  4] local 192.168.1.2 port 35162 connected to 192.168.1.10 port 5202  
5203:  Connecting to host 192.168.1.10, port 5203
5203:  [  4] local 192.168.1.2 port 38144 connected to 192.168.1.10 port 5203 
```
</details>

<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all    5.80    0.00   44.76    0.00    6.54   32.80    0.00    0.00   10.10
Average:       0    0.00    0.00    0.05    0.00   23.89   64.46    0.00    0.00   11.60
Average:       1    7.62    0.00   56.98    0.00    1.13   23.20    0.00    0.00   11.07
Average:       2    7.51    0.00   59.74    0.00    1.10   22.35    0.00    0.00    9.30
Average:       3    7.70    0.00   59.45    0.00    1.13   23.22    0.00    0.00    8.50  
```
</details>

<details>
<summary>performance</summary>

```
5201:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5201:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  4076026  
5201:  - - - - - - - - - - - - - - - - - - - - - - - - -
5201:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5201:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  0.000 ms  0/4076026 (0%)  sender
5201:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  0.002 ms  1207/4076026 (0.03%)  receiver
5201:  
5201:  iperf Done.

5202:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5202:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  4076029  
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5202:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  0.000 ms  0/4076029 (0%)  sender
5202:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  0.001 ms  1152/4076029 (0.028%)  receiver
5202:  
5202:  iperf Done.

5203:  [ ID] Interval           Transfer     Bitrate         Total Datagrams
5203:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  4076068  
5203:  - - - - - - - - - - - - - - - - - - - - - - - - -
5203:  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
5203:  [  5]   0.00-60.00  sec  5.59 GBytes   800 Mbits/sec  0.000 ms  0/4076068 (0%)  sender
5203:  [  5]   0.00-59.99  sec  5.59 GBytes   800 Mbits/sec  0.014 ms  1161/4075959 (0.028%)  receiver
5203:  
5203:  iperf Done.  
```
</details>








## TCP_RX_MTU1500
```
#commands
#---------------used on server-----------------------
echo "SERVER_IP is 192.168.1.10"
#sudo ifconfig enp179s0f0 down
#sudo ifconfig enp179s0f0 mtu 1500
#sudo ifconfig enp179s0f0 inet 192.168.1.2
#sudo ifconfig enp179s0f0 up
iperf3 -c 192.168.1.10 -p 5201 -i 60 -t 60 -b 1000M -Z -T 5201 &
sleep 1s
iperf3 -c 192.168.1.10 -p 5202 -i 60 -t 60 -b 1000M -Z -T 5202 &
sleep 1s
iperf3 -c 192.168.1.10 -p 5203 -i 60 -t 60 -b 1000M -Z -T 5203 &
```

<details>
<summary>terminal log</summary>

```
./a_test_eth.sh 
5201:  Connecting to host 192.168.1.10, port 5201
5201:  [  4] local 192.168.1.2 port 33907 connected to 192.168.1.10 port 5201
5202:  Connecting to host 192.168.1.10, port 5202
5202:  [  4] local 192.168.1.2 port 35162 connected to 192.168.1.10 port 5202 
5203:  Connecting to host 192.168.1.10, port 5203
5203:  [  4] local 192.168.1.2 port 32232 connected to 192.168.1.10 port 5203  
```
</details>

<details>
<summary>cpu load</summary>

```
Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
Average:     all    0.31    0.00    9.27    0.00    2.92   49.74    0.00    0.00   37.76
Average:       0    0.03    0.00    0.08    0.00    4.23   61.94    0.00    0.00   33.73
Average:       1    0.34    0.00   11.71    0.00    6.40   43.46    0.00    0.00   38.10
Average:       2    0.38    0.00   13.01    0.00    0.38   46.91    0.00    0.00   39.31
Average:       3    0.49    0.00   12.85    0.00    0.38   46.10    0.00    0.00   40.17  
```
</details>

<details>
<summary>performance</summary>

```

5201:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5201:  [  5]   0.00-60.00  sec  6.33 GBytes   906 Mbits/sec  61988   96.2 KBytes       
5201:  - - - - - - - - - - - - - - - - - - - - - - - - -
5201:  [ ID] Interval           Transfer     Bitrate         Retr
5201:  [  5]   0.00-60.00  sec  6.33 GBytes   906 Mbits/sec  61988             sender
5201:  [  5]   0.00-60.00  sec  6.33 GBytes   906 Mbits/sec                  receiver
5201:  
5201:  iperf Done.

5202:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5202:  [  5]   0.00-60.00  sec  6.25 GBytes   894 Mbits/sec  63178    100 KBytes       
5202:  - - - - - - - - - - - - - - - - - - - - - - - - -
5202:  [ ID] Interval           Transfer     Bitrate         Retr
5202:  [  5]   0.00-60.00  sec  6.25 GBytes   894 Mbits/sec  63178             sender
5202:  [  5]   0.00-60.00  sec  6.24 GBytes   894 Mbits/sec                  receiver
5202:  
5202:  iperf Done.

5203:  [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
5203:  [  5]   0.00-60.00  sec  6.03 GBytes   863 Mbits/sec  58521    170 KBytes       
5203:  - - - - - - - - - - - - - - - - - - - - - - - - -
5203:  [ ID] Interval           Transfer     Bitrate         Retr
5203:  [  5]   0.00-60.00  sec  6.03 GBytes   863 Mbits/sec  58521             sender
5203:  [  5]   0.00-60.00  sec  6.03 GBytes   863 Mbits/sec                  receiver
5203:  
5203:  iperf Done.  
```
</details>




