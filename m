Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795690682;
	b=Gs40PwmuKhdgHsABKNaReuaLm5UtskUv12F6ZHkyOqaaJUhPxrzW0yMmdSvvfkjz/fIl
	 US/hv2/nBqYrt9L4EDc1HUgjkQzuY4MXIqgG7MeLlfE2IcVOsaoL/DopLNTqWQc6EQNqS
	 okpZ2WwVYombYwgNkA+GJGkMoCmgH8RvtYImK+cud4rozBqZuxPRSwfi5+AJs6/GKCAdq
	 ng259CgF3gzwPzF77ArErLyOkYUzisgGBAFniVHYnfEKSY74to5q+mAl6h2R5uBqLbJ+c
	 oRcAEiyn68OvvqkWCs/vRk1iaL6atBEASwIK3Mey35ZMr2f5+ktxhEwe6M17ovUX+XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795690682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=tkRVveLe6G8UbPS9AVXKod8vhgkSmzDMxNewwanX6U8=;
	b=3Lq4RYnXcPbLW4QbmWiAkQ3jzC58CZQhJepKMwtIe3EzTEo8nByg+yrWqd9BJQggijYP
	 jU08qajufATUwD1zxF2mvMzcxJ1WhuAWZ1nWmjNKW8N3v5MkwwoPeMGI78HrzMvVOQon3
	 tmPEd2oiCux18aHklUiiZMyLiFD/ffC1OP1IycRMDBz/BaQx0jnvV6Ke8u02fKGgOTJOz
	 mMdg3VVleKGJDx/kIeNdTACA1Edm1/tVTS+9YEhM0wU8wByTLz+Kqozbzw7SCoh6ZEgDs
	 tct9LbuO7J2qiXVp6WzFDzsBXNYf9P2Nn1nMdH4qdkIm03ueEexO0oT8rfBhHeSTYOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K5eU8lK/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4782606A31E;
	Thu, 26 Nov 2026 10:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5eU8lK/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669621F000C0;
	Thu, 26 Nov 2026 10:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795690681;
	bh=tkRVveLe6G8UbPS9AVXKod8vhgkSmzDMxNewwanX6U8=;
	h=From:To:Cc:Subject:Date;
	b=K5eU8lK/44Je7kWhWgSUVXmv0wpN4yTyb2bQaSkc4ozeh2GSjEYlyjdlv2zvC3JeM
	 QtNodE3eu0zBy+kDye0hOmyF3qdjbnjrdBItl/ynh0l5BZrsOgnrIVn5GL8C1Omjl8
	 dR33Zwi9PJV9NAsXZ5g0gSWFLxImzLEeLws5EfSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
Date: Thu, 26 Nov 2026 11:58:20 +0100
Message-ID: <20261126105729.110697432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.7-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.3.7-rc2
X-KernelTest-Deadline: 2026-11-28T10:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.3.7 release.
There are 1002 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.7-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.3.7-rc2

Arnd Bergmann <arnd@arndb.de>
    drm: xe: select configfs

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Set unhashed_state in inet_twsk_hashdance_schedule().

Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
    powerpc/watchdog: disable watchdog when watchdog_thresh=0

Thomas Lamprecht <t.lamprecht@proxmox.com>
    drm/amd/display: Don't warn about links without an HPD GPIO

Hyunwoo Kim <imv4bel@gmail.com>
    tcp: fix NULL pointer dereference when restarting a Fast Open listener

Mani Tofigh <mt4022@columbia.edu>
    nvme: fix deadlock on nvme_subsystems_lock in nvme_init_subsystem()

Henry Martin <bsdhenrymartin@gmail.com>
    sctp: fix skb_over_panic when adding addresses with a pending delete of another family

Karol Wachowski <karol.wachowski@linux.intel.com>
    accel/ivpu: Defer recovery until probe completes

Hyunjung Ko <hj351016@gmail.com>
    gpio: mpsse: reject bulk-in endpoints smaller than 3 bytes

Mani Tofigh <mt4022@columbia.edu>
    blk-mq: take quiesce_lock when removing a queue from the tag set

Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
    fou: reserve headroom before pushing the encap header

Karl Mehltretter <kmehltretter@gmail.com>
    iio: trigger: Return an error when the trigger has no free irq

Changyul Lee <lcy8047@gmail.com>
    iio: trigger: free the trigger ID after device_del()

Salah Triki <salah.triki@gmail.com>
    iio: temperature: mlx90614: Fix dual channel probe condition check

Christopher Hoover <ch@murgatroid.com>
    iio: temperature: hid-sensor-temperature: Use per-instance callbacks

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: proximity: sx9500: ignore event config writes that don't change state

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: proximity: sx9360: fix sampling frequency write and available range

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: proximity: sx9324: fix out-of-bounds read of scan period table

Myeonghun Pak <mhun512@gmail.com>
    iio: proximity: hx9023s: Allocate trigger before requesting IRQ

Viral Patel <viral8854@gmail.com>
    iio: magnetometer: tlv493d: fix magnetic field scale

Shashank Mohan Jain <jain.sm@gmail.com>
    iio: magnetometer: mmc5633: leave cache-only mode before the cache sync

Shashank Mohan Jain <jain.sm@gmail.com>
    iio: magnetometer: mmc35240: leave cache-only mode before the cache sync

Alexander Sarmanow <as@discnull.de>
    iio: light: vcnl4035: Fix reversed ALS mode bit

Jan Remes <jan.remes@mycroftmind.com>
    iio: light: tsl2591: don't divide by zero

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: inv_sensors: prevent timestamps going back in time in transitions

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: inv_sensors: do not compute period estimation when updating odr

Jiale Yao <yaojiale02@163.com>
    iio: imu: kmx61: reject duplicate event disable

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: imu: inv_mpu6050: fix swapped accel and gyro startup times

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: imu: inv_mpu6050: fix magnetometer scale of Y and Z axes

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix parsing of all FIFO frames for odr change

Christopher Hoover <ch@murgatroid.com>
    iio: humidity: hid-sensor-humidity: Use per-instance callbacks

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: humidity: am2315: fix negative temperature decoding

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio: hid-sensors: fix fractional part for unit exponents -7 and -8

Maximilian Czirr <maxx-cz@web.de>
    iio: hid-sensor: Fix scale for magnetic north heading

Jiale Yao <yaojiale02@163.com>
    iio: gyro: bmg160: reject duplicate event disable

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    iio: dac: mcp4725: Update the cached DAC value only on success

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: common: scmi_sensors: fix truncating 64-bit divisions

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: atlas-ezo: Fix humidity channel read support

Andrea Amer <and.amer@gmail.com>
    iio: afe: rescale: expose offset if rescaler or source has one

Billy Tsai <billy_tsai@aspeedtech.com>
    iio: adc: aspeed: Use syscon phandle for trimming data when available

Yu-Hsiang Tseng <asas1asas200@gmail.com>
    iio: acpi: Accept comma separated values in ROTM strings

Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
    iio: accel: kxsd9: Fix potential use-after-free on removal

Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
    iio: accel: adxl313: add missing buffer selections in Kconfig

Billy Tsai <billy_tsai@aspeedtech.com>
    dt-bindings: iio: adc: Add syscon property for multi-SCU SoCs

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: serialise MCR accesses

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential use-after-free on disconnect

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential fifo corruption

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: move initial termios update to open()

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential NULL-deref at open

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential close() use-after-free

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix NULL-deref on early status

Johan Hovold <johan@kernel.org>
    USB: serial: upd78f0730: fix NULL-deref on hangup

Tristan Madani <tristan@talencesecurity.com>
    USB: serial: sierra: validate URB length in instat callback

Hui Peng <benquike@gmail.com>
    USB: serial: garmin_gps: validate packet data length in nat_receive()

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: fix the error handling of amdgpu_vm_init_entities()

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: skip GPUs without a VM when checkpointing the BO mappings

Josef Bacik <josef@toxicpanda.com>
    w1: w1_therm: leave the slaves of other families alone

Josef Bacik <josef@toxicpanda.com>
    w1: use the bus mutex for the "rw" file

Josef Bacik <josef@toxicpanda.com>
    w1: remove the master's files before taking its locks

Josef Bacik <josef@toxicpanda.com>
    w1: netlink: drop the slave after the bus is unlocked

Josef Bacik <josef@toxicpanda.com>
    w1: ds28e04: use the bus mutex to talk on the bus

Josef Bacik <josef@toxicpanda.com>
    w1: ds2805: use the bus mutex to talk on the bus

Josef Bacik <josef@toxicpanda.com>
    w1: ds2482: set the strong pull-up with its byte

Josef Bacik <josef@toxicpanda.com>
    w1: don't hold list_mutex while a slave is torn down

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: xilinx: unwind ZynqMP platform init on probe failure and remove

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: xilinx: re-assert resets on ZynqMP init error paths

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: xilinx: fix system suspend and resume PHY handling

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Wait for End Transfer completion on ep disable

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Track a timed out End Transfer

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Reset endpoint flags on controller start

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Reject requests to a disabled endpoint

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Recover from End Transfer timeout

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Issue no-op Start Transfer only for stream endpoints

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Clear delayed stop on End Transfer completion

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: trace: Restore request name assignment

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    usb: gadget: u_serial: pin ports while TTYs are installed

Brian Ellis <brianellis@gotenna.com>
    usb: gadget: u_serial: fix NULL deref in gs_close() after failed open

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    usb: gadget: f_ncm: restart the TX timer if the TX freelist is empty

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: f_midi: fix UAF race during IN request handling

Yu Zhang <yuz08559@gmail.com>
    usb: gadget: f_mass_storage: take filesem in nofua store to fix backing-file UAF

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: clear stale bandwidth data after hibernation

Xu Rao <raoxu@uniontech.com>
    usb: xhci: disable the correct slot on alloc_dev failure

Uttkarsh Aggarwal <uttkarsh.aggarwal@oss.qualcomm.com>
    usb: typec: ucsi: Set ucsi->connector before enabling notifications

Ali Ahmet Memiş <aliamemis@disroot.org>
    usb: typec: ucsi: debugfs: Fix GET commands on UCSI < 2.0

Ihor Urazov <z0rc3r@gmail.com>
    usb: typec: ucsi: acpi: Assume UCSI 1.0 on HP ZBook 8 G2i 14

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    usb: usbtest: prevent divide by zero in simple_io() with zero length

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    usb: uas: ignore UAS for ASMT135x bridges (174c:55aa)

Chaz Bailey <charles.s.bailey@gmail.com>
    usb: typec: nb7vpq904m: Set client data in probe to avoid crash on remove

Joonhoe Kim <26rote@gmail.com>
    usb: typec: mux: fsa4480: Keep the USB 2.0 switch on in DP-only modes

Josef Bacik <josef@toxicpanda.com>
    USB: serial: oti6858: fix the teardown order in close

Johan Hovold <johan@kernel.org>
    USB: serial: garmin_gps: fix deadlock on reset request

Rishabh Jain <rishabh.jain1198@gmail.com>
    usb: pci-quirks: always assert xHCI OS ownership

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix NULL-deref on hangup

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: fix misapplied compat_ptr() in tty_compat_ioctl()

Josef Bacik <josef@toxicpanda.com>
    thunderbolt: stream: Undo more if the start fails

Josef Bacik <josef@toxicpanda.com>
    serial: samsung: put the previous baud clock

Josef Bacik <josef@toxicpanda.com>
    serial: samsung: don't leak the tty on an RX IRQ

Josef Bacik <josef@toxicpanda.com>
    serial: rda: free the interrupt on shutdown

Josef Bacik <josef@toxicpanda.com>
    serial: imx: fix the tty reference of the wakeup event

Josef Bacik <josef@toxicpanda.com>
    serial: fsl_lpuart: fix tty ref of wakeup event

Josef Bacik <josef@toxicpanda.com>
    serial: core: respect runtime PM when sending x_char

Josef Bacik <josef@toxicpanda.com>
    serial: 8250_mxpcie: handle hangup during break

Josef Bacik <josef@toxicpanda.com>
    serial: 8250_lpss: don't divide by 0 above 6.25 Mbaud

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250_exar: check priv->gpio properly

Josef Bacik <josef@toxicpanda.com>
    misc: vmw_vmci: wait for callbacks in event unsubscribe

Jiale Yao <yaojiale02@163.com>
    misc: ibmvmc: initialize HMC state before device registration

Guangshuo Li <lgs201920130244@gmail.com>
    misc: bcm-vk: fix DMA allocation memory leak

Antonio Vázquez Blanco <antoniovazquezblanco@gmail.com>
    mei: me: add ice lake point LP iTouch DID

Josef Bacik <josef@toxicpanda.com>
    mei: lb: read the MTU once

Josef Bacik <josef@toxicpanda.com>
    iio: sx9310: use the data of the I2C table

Josef Bacik <josef@toxicpanda.com>
    iio: hid-sensors: fix a division by zero

Josef Bacik <josef@toxicpanda.com>
    iio: addac: ad74413r: fix the values of set_multiple

Josef Bacik <josef@toxicpanda.com>
    iio: adc: check the result of ad_sd_init()

Josef Bacik <josef@toxicpanda.com>
    iio: adc: ad7923: add the AD7927 to the SPI ID table

Josef Bacik <josef@toxicpanda.com>
    iio: accel: adxl380: don't stay in standby on -EINVAL

Josef Bacik <josef@toxicpanda.com>
    comedi: vmk80xx: report failed transfers of the K8061

Josef Bacik <josef@toxicpanda.com>
    comedi: ni_tio: Fix overflow of the clock period

Josef Bacik <josef@toxicpanda.com>
    comedi: ni_660x: don't poll without a DMA channel

Josef Bacik <josef@toxicpanda.com>
    comedi: fix endless recursion in comedi_event()

Josef Bacik <josef@toxicpanda.com>
    comedi: addi_apci_1500: fix clearing of the gate enable

Chris Mason <mason@kernel.org>
    vt: serialise the producers of the flip buffer

Mikulas Patocka <mpatocka@redhat.com>
    dm-thin: fix parsing of feature arguments

Mikulas Patocka <mpatocka@redhat.com>
    dm-thin: fix leak if __set_snapshot_details fails

Mikulas Patocka <mpatocka@redhat.com>
    dm-thin: fix data corruption if discard races with regular I/O

Li Youhong <liyouhong@kylinos.cn>
    dm-raid: fix use-after-free in raid_dtr()

Jay Vadayath <jay@artiphishell.com>
    dm-raid: bound array_position before indexing failed_devices

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: don't attempt to commit journal on disabled device

Sinan Polat <sinan86polat@gmail.com>
    dm-integrity: don't recalculate with HMAC because of a dirty bitmap

Josef Schlehofer <pepe.schlehofer@gmail.com>
    dm-crypt: defer async write submission to write thread

xietangxin <xietangxin@h-partners.com>
    dm-crypt: reject integrity_key_size with non-authenc AEAD ciphers

Mikulas Patocka <mpatocka@redhat.com>
    dm-cache: fix ending a cursor that never began

Mikulas Patocka <mpatocka@redhat.com>
    dm-cache: fix NULL pointer dereference on open failure

Kyrylo Biryuk <illofspeed@gmail.com>
    dm zoned: do not reclaim a random zone into another random zone

Kyrylo Biryuk <illofspeed@gmail.com>
    dm zoned: back off when reclaim cannot make progress

Chen Cheng <chencheng@fnnas.com>
    dm snapshot: fix discard writing into the next COW chunk

Chen Cheng <chencheng@fnnas.com>
    dm snapshot: split discards on chunk boundaries

wuyuehong <wuyuehong@cmss.chinamobile.com>
    dm snapshot: fix discard_granularity unit in snapshot_io_hints

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: don't leak bufio buffer if find_leaf fails

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: don't ignore writeback errors

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: test return value of node_copy

Weijiang Zhou <weijiang.zhou@unisoc.com>
    dm-verity: don't restart or panic on errors during system shutdown

Mikulas Patocka <mpatocka@redhat.com>
    dm-sysfs: fix misbehavior if kobject_init_and_add fails

guolingxing <guolingxing@tju.edu.cn>
    dm-pcache: do not advance dirty_tail after backing flush failure

Yingjie Wang <1075151112@qq.com>
    dm thin: avoid wrapping no_space_timeout

Yingjie Wang <x-professor@outlook.com>
    dm mpath: cap queue_if_no_path_timeout_secs

shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>
    dm mpath: fix buffer overflow in parse_hw_handler()

Zhao Feng <zhaofeng2@cmss.chinamobile.com>
    dm crypt: fix use of uninitialized percpu_counter in ctr error path

Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
    dm cache: validate the discard block size before narrowing

Edward Adam Davis <eadavis@sina.com>
    dm cache: reject kcopyd client destory if it setup failed

Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
    dm: Reject table setup after queue or disk teardown

Ming-Hung Tsai <mtsai@redhat.com>
    dm: fix use-after-free when dm_get_device() widens the open mode

Mark Bundschuh <mkbund@amazon.com>
    dm: fix infinite loop in dm_blk_do_report_zones()

Daejun Park <daejun7.park@samsung.com>
    dm: fail a REQ_PREFLUSH bio with data when its preflush fails

Yaohan Li <shunsheng1218@gmail.com>
    dm: avoid double-dropping the zone reset submission reference

shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>
    dm log userspace: drop the device reference on error

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't write back through O_DIRECT handles

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't spend read retries on reads cut short by a reconnect

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't retry failed writes forever regardless of mount options

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't give up writeback on the first replayable error

liuyong <pkfxxxing@gmail.com>
    smb: client: validate descriptor headers before query result allocation

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: skip NULL channel in __cifs_put_smb_ses()

Paulo Alcantara <pc@manguebit.org>
    smb: client: retry writes that couldn't be issued due to a reconnect

Paulo Alcantara <pc@manguebit.org>
    smb: client: retry writeback on interrupts and allocation failures

Paulo Alcantara <pc@manguebit.org>
    smb: client: let umount -f abort retried reads and writes

Paulo Alcantara <pc@manguebit.org>
    smb: client: issue writes from a worker if the task is dying

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: hold the inode across cifs_oplock_break()

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: hold server ref while queueing reconnect work

Paulo Alcantara <pc@manguebit.org>
    smb: client: flush deferred handles of other names before a hard link open

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix out-of-bounds read in dfs_parse_target_referral()

Andrey Misiurov <andrey.misyrov@gmail.com>
    smb: client: fix OOB write when compounding SMB2_IOCTL with encryption

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix double conversion of DFS path in setup_dfs_ref()

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't block dying tasks waiting for writeback on fsync

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't block dying tasks waiting for writeback on close

liuyong <pkfxxxing@gmail.com>
    smb: client: compare owner and group SIDs using their encoded lengths

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    smb: client: bound invalid NTLMSSP signature diagnostic

Giuseppe Scrivano <giuseppe@scrivano.org>
    ovl: follow lower to lowerdata redirects from any lower layer

Amir Goldstein <amir73il@gmail.com>
    ovl: do not check the deferred lowerdata redirect on index lookup

Amir Goldstein <amir73il@gmail.com>
    ovl: do not allow nfs_export with data-only layers

Daejun Park <daejun7.park@samsung.com>
    ovl: bump the impure dir version when linking a file with origin

Giuseppe Scrivano <giuseppe@scrivano.org>
    ovl: return EIO if the lowerdata is missing

Amir Goldstein <amir73il@gmail.com>
    ovl: report the requested redirect_dir mode in conflicting options

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    ovl: reject different lower idmaps on the same fs

Amir Goldstein <amir73il@gmail.com>
    ovl: fix leak of lowerdata redirect on ovl_get_inode() failure

Amir Goldstein <amir73il@gmail.com>
    ovl: do not read the flags of a put upper dentry in lookup

Giuseppe Scrivano <giuseppe@scrivano.org>
    ovl: do not always clear absolute_redirect

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpiolib: synchronize updates of descriptor labels

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpiolib: fix stack out-of-bounds access in gpiochip_add_hog()

Yu Zhang <yuz08559@gmail.com>
    gpio: virtuser: remove the debugfs files before freeing the line data

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: virtuser: fix interrupt leak and UAF

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: sodaville: fix use-after-free bug when registering the irqchip

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: fix a race in shared desc release path

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpio: sa1100: defer GPIO chip registration to postcore_initcall

Cunhao Lu <1579567540@qq.com>
    gpio: rockchip: Fix debounce arithmetic for GPIO v2

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: of: fix potential misconfiguration of hogged lines

Wentao Liang <vulab@iscas.ac.cn>
    gpio: keep the chip reference when deferred setup fails

Guangshuo Li <lgs201920130244@gmail.com>
    gpio: brcmstb: fix UAF after IRQ domain setup failure

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Preserve the pending G7 interrupt status on control writes

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Clear only the acked line's G4 interrupt status

Ian Bridges <icb@fastmail.org>
    ksmbd: evaluate the DACL in order for explicit access requests

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: bound pending OCB station allocations

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: bound pending IBSS station allocations

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix use-after-free on TTLM disconnect

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: restore dormant links when link updates fail

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: reject invalid EHT guard intervals in airtime estimates

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: recheck the OCB station limit before insertion

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: recheck the IBSS station limit before insertion

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: recheck injected headers after removing FCS

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: drain link readers before stopping removed links

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: fix use-after-free when MLO link setup is rolled back

Wahid Khan <wahidzk0091@gmail.com>
    wifi: cfg80211: don't truncate the merged MBSSID profile length

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: preserve mesh A-MSDU lengths when adding mesh headers

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: release rejected nontransmitted BSS reference

Tristan Madani <tristmd@gmail.com>
    wifi: nxpwifi: validate scan response TLV sizes before indexed access

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211_hwsim: ignore non-generic netlink releases

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: ath9k_htc: do not start ANI before the first channel is set

Benoit Masson <yahoo@perenite.com>
    wifi: ath12k: assign device id from the WSI index

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Reject array count on non-dereference string sources

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix user-space dereference string array store type

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix missing BTF kind checks in char pointer/array helpers

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix BTF bitfield parsing and out-of-bounds buffer write

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Enable newly appended probe when target event is enabled

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Check enabled and busy state before unlinking sibling probes

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Disallow attaching eprobes to fprobe events

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix 1-byte signed field fetch in get_event_field()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/uprobes: Fix memory leak of tail in __trace_uprobe_create()

Paolo Bertinetti <paolobertinetti200f4@proton.me>
    tracing/perf: Clear stop state in perf_trace_add()

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Reject repeated PCH-PIC CTRL_INIT

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Propagate real error code in kvm_pch_pic_create()

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Clear device pointer in irqchip destroy callbacks

Mike Rapoport (Microsoft) <rppt@kernel.org>
    LoongArch: Restore KFENCE pages through DMW on resume

Jinjie Ruan <ruanjinjie@huawei.com>
    LoongArch: kexec_file: Fix elf_headers memory leak in retry loop

Jinjie Ruan <ruanjinjie@huawei.com>
    LoongArch: kexec_file: Fix a modified cmdline leak

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Make use of beqz and bnez for trampoline branches

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Make arena support depend on 128-bit cmpxchg

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: refuse reauthentication of an expired session as another user

Ian Bridges <icb@fastmail.org>
    ksmbd: keep group denials when a POSIX ACL entry decides access

Ian Bridges <icb@fastmail.org>
    ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow

Weiming Shi <bestswngs@gmail.com>
    sctp: reset stored flag for each association

Tim Budding <tim.budding@gmail.com>
    sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED

Tim Budding <tim.budding@gmail.com>
    sctp: fix I-FORWARD-TSN handling of fragments on other streams

Andrey Misiurov <andrey.misyrov@gmail.com>
    sctp: fix ASCONF address change on single-homed hosts

Kyle Zeng <kylebot@openai.com>
    sctp: avoid requeueing pending control chunks

Tim Budding <tim.budding@gmail.com>
    sctp: abort unordered partial delivery when its message is skipped

Kuba Piecuch <jpiecuch@google.com>
    sched_ext: Read exit_kind before flushing in scx_flush_disable_work()

Tejun Heo <tj@kernel.org>
    sched_ext: Factor out drain_offline_rq()

Tejun Heo <tj@kernel.org>
    sched_ext: Fix stale pick when the donor changes during dispatch

Seiji Nishikawa <snishika@redhat.com>
    sched/core: Do not touch SMT siblings that have not joined the core yet

Andrea Parri <parri.andrea@gmail.com>
    sched/core: Fix cpuset_mutex double unlock in __sched_setscheduler()

Andrea Parri <parri.andrea@gmail.com>
    sched/uclamp: Reject clamp values above SCHED_CAPACITY_SCALE

Andrea Parri <parri.andrea@gmail.com>
    sched/deadline: Fix spurious -EPERM for migration-disabled tasks

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Don't trust userspace-supplied result field in format check

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix wrong free and refcount leak in build_check_tcw error path

Stanislav Aleksandrov <lightofmysoul@gmail.com>
    hwmon: (max31760) Report 0 RPM before the first fan speed measurement

Stanislav Aleksandrov <lightofmysoul@gmail.com>
    hwmon: (max31760) Leave standby mode at probe

Stanislav Aleksandrov <lightofmysoul@gmail.com>
    hwmon: (max31760) Fix the local temperature limit registers

Sudeep Holla <sudeep.holla@kernel.org>
    hwmon: (scmi) Configure sensors before exposing channels

Xu Rao <raoxu@uniontech.com>
    hwmon: (scmi) Enable temperature sensors using their sensor IDs

Sudeep Holla <sudeep.holla@kernel.org>
    hwmon: (scmi) Check channel config allocation

Pablo Mazzini <pmazzini@gmail.com>
    hwmon: (sy7636a) fix negative temperatures

Felix Radensky <fradensky@nvidia.com>
    hwmon: (pmbus/mp2975) Get vout fault limits dynamically

Guenter Roeck <linux@roeck-us.net>
    hwmon: (gpio-fan) Fix runtime PM imbalance in probe and teardown

Rupesh Majhi <zoone.rupert@gmail.com>
    hwmon: (aht10) Fix update_interval overflow on 64-bit

Miguel Ojeda <ojeda@kernel.org>
    kbuild: rust: support stabilized flag `-Cprofile-sample-use` for Rust >= 1.100

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    xen/pvcalls: destroy the per-socket workqueue on release

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    xen/pvcalls: unwind pvcalls_new_active_socket() step by step

Qihang <q.h.hack.winter@gmail.com>
    xen/privcmd: fix double free when an irqfd is shut down twice

Andrey Misiurov <andrey.misyrov@gmail.com>
    xen/gntdev: fix deadlock between map ioctl and mmap

Hengyu Liang <hengyul@cs.unc.edu>
    x86/video: Preserve the default VGA fallback for legacy modes

Dave Hansen <dave.hansen@linux.intel.com>
    x86/mm: Ensure write visibility during LDT installation

Jason Andryuk <jason.andryuk@amd.com>
    x86/CPU/AMD: Don't print reset reason in VMs

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    watchdog: rzv2h: Drop runtime PM handling from WDTDCR init

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    watchdog: rzv2h: Use pm_runtime_put_sync()

Zhao Feng <zhaofeng2@cmss.chinamobile.com>
    watchdog: npcm: fix clock prepare leak when setting timeout on a running watchdog

Stanislav Aleksandrov <lightofmysoul@gmail.com>
    watchdog: gunyah_wdt: Re-enable the watchdog on resume

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Unmap DMA buffers on transfer timeout

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Track DMA mapping state

Kees Cook <kees@kernel.org>
    spi: axi-spi-engine: Start the program length at zero

Hyunjung Ko <hj351016@gmail.com>
    tpm: flush timeout work outside buffer_mutex to avoid deadlock

Guanglei Zhu <zhugl3@xiaopeng.com>
    tpm: eventlog: check the payload size before reading tag events

Eric Biggers <ebiggers@kernel.org>
    tpm: Check return value of crypto_kpp_set_secret()

Takashi Iwai <tiwai@suse.de>
    tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path

Avi Weiss <thnkslprpt@gmail.com>
    timekeeping: Refresh auxiliary base before offset validation

Avi Weiss <thnkslprpt@gmail.com>
    timekeeping: Reject cross timestamps for invalid AUX clocks

Hungyu Lin <dennylin0707@gmail.com>
    timekeeping: Read getboottime64() offsets under the sequence counter

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Fix TCP-with-TLS transport class identification

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    software node: only let the owner release a managed node

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix updates of cached resolved frequency and index

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Cache post-resolution target frequency in __resolve_freq()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Force passing target frequency to driver during resume

Li Zhaoxin <lizhaoxin04@baidu.com>
    cpufreq: intel_pstate: Use rdmsrq_safe() to read MSR_MISC_PWR_MGMT

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Clear last written P-state value on suspend

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Improve suspend-resume synchronization

Li RongQing <lirongqing@baidu.com>
    cpufreq: acpi-cpufreq: fix P-state index mismatch in extract_io()

Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
    arm64: suspend: Only track cpuidle context for idle tasks

Mark Brown <broonie@kernel.org>
    arm64: suspend: Save GCS state over suspend

Mark Brown <broonie@kernel.org>
    arm64: suspend: Save POR_EL0 over suspend

Zhao Gongyi <zhaogongyi@bytedance.com>
    arm64: ptrace: don't warn on missing siginfo in a group-stop

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: kexec_file: Do not use CMA for images with a non-zero text_offset

Chris Down <chris@chrisdown.name>
    arm64: hugetlb: Prevent write fault livelocks on stale TLB entries

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Add Cortex-A715/A720 AMU core counter workaround

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Extend the workaround for broken AMEVCNTR01 counter

Mark Brown <broonie@kernel.org>
    arm64/gcs: Ignore attempts to change GCS mode during signal return

Christian Brauner <brauner@kernel.org>
    fs: don't strand I_METADATA_WRITEBACK inodes outside the LRU

Cheng Yongkang <teel4res@gmail.com>
    fs/splice: clamp an over-reported write_iter result

Cheng Yongkang <teel4res@gmail.com>
    fs/proc: fix the write length returned by proc_sys_call_handler()

HyeongJun An <sammiee5311@gmail.com>
    fs/adfs: bound directory entry name length in adfs_fplus_getnext()

Christian Brauner <brauner@kernel.org>
    ext4: don't read the inode block in ext4_sync_inode_metadata()

Christian Brauner <brauner@kernel.org>
    ext4: use sb_find_get_block_nonatomic() in ext4_get_inode_loc_noio()

Christian Brauner <brauner@kernel.org>
    ext2: don't read the inode block in ext2_sync_inode_metadata()

Christian Brauner <brauner@kernel.org>
    ext2: add ext2_inode_block() helper

Josef Bacik <josef@toxicpanda.com>
    dcache: let umount find a disconnected ex-mountpoint

Josef Bacik <josef@toxicpanda.com>
    dcache: wait for a racing eviction of a secondary root

Christian Brauner <brauner@kernel.org>
    dcache: let d_invalidate() wait for a d_set_mounted() in flight

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: essiv - fix use-after-free in AEAD path

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: caam - reject overlong RSA CRT parameters

Mani Tofigh <mt4022@columbia.edu>
    cgroup: arm the notify timer only while the file exists

Tejun Heo <tj@kernel.org>
    cgroup/freezer: Fix exiting tasks left frozen forever after rmdir

Mani Tofigh <mt4022@columbia.edu>
    cgroup/freezer: walk exiting tasks in the v1 freezer

Ridong Chen <chenridong@xiaomi.com>
    cgroup/cpuset: Don't revive invalid partition without active CPU on hotplug

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Correctly set isolated_cpus when switching partition state

Zhao Li <enderaoelyther@gmail.com>
    Bluetooth: L2CAP: Keep recvmsg from resuming a closed channel

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    Bluetooth: hci_qca: fix use-after-free in ibs debugfs files

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    Bluetooth: btusb: fix use-after-free in force_poll_sync

Baoli Zhang <baoli.zhang@linux.intel.com>
    ASoC: SOF: ipc4-topology: Fix pin format leak in process widget setup

Michael McAllister <me@michaelmcallister.org>
    ASoC: qcom: q6asm: Reset PCM positions when preparing a stream

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: pcie-m2: fix serdev controller reference leak

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: pcie-m2: fix use-after-free in pwrseq_pcie_m2_vregs_enable()

Dennis Chen <dechen@redhat.com>
    Revert "powercap: intel_rapl: Expose all package CPUs in PMU cpumask"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Update last_busy in rpm_resume() for active devices

Paolo Bertinetti <paolobertinetti200f4@proton.me>
    perf/hw_breakpoint: Clear stop state in hw_breakpoint_add()

Phat Dinh <phatdt1116@gmail.com>
    perf/core: Do not resurrect cpuctx->cgrp after last cgroup event exit

Joas Antonio dos Santos <joasantonio108@gmail.com>
    openvswitch: advance by the real header length in get_ipv6_ext_hdrs()

Wahid Khan <wahidzk0091@gmail.com>
    ntfs: open the index allocation before reading or writing an index block

Wahid Khan <wahidzk0091@gmail.com>
    ntfs: do not read an index block outside $INDEX_ALLOCATION

Wahid Khan <wahidzk0091@gmail.com>
    ntfs: check the file name against the key length of an index entry

Tim Menninger <tmenninger@everpuredata.com>
    NFSv4: Prevent indefinite waits for out-of-order OPEN stateids

Christian Brauner <brauner@kernel.org>
    minix: don't read the inode block in minix_sync_inode_metadata()

Christian Brauner <brauner@kernel.org>
    minix: add minix_inode_block() helper

Eric Dumazet <edumazet@kernel.org>
    net: wait for in-flight device unregistrations before netns dismantle

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: require a full Ethernet header on egress

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: encode configured zero metadata values

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_teql: reject qdiscs from another network namespace

Paulo Alcantara <pc@manguebit.org>
    netfs: don't hang a read whose retry is abandoned

Paulo Alcantara <pc@manguebit.org>
    netfs: keep the prepare_read errno when abandoning read retries

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    netfs: preserve prepare_write errno on reissue

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    netfilter: flowtable: extend ct timeout of offloaded GRE flows

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    netfilter: xt_recent: do not call remove_proc_entry() under recent_lock

Zihan Xi <zihanx@nebusec.ai>
    netfilter: nf_dup: preserve guard across NFQUEUE reinjection

Eric Dumazet <edumazet@kernel.org>
    net: gro: invalidate frag0 after a pull

Eric Dumazet <edumazet@kernel.org>
    net: gro: do not undo remote checksum offload on merged packets

Kyle Zeng <kylebot@openai.com>
    net: gro: avoid parsing headers from shared fragments

Andrea Parri <parri.andrea@gmail.com>
    hv_sock: Report no unread data before a channel is available

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    hv_netvsc: Stop PPI parsing on invalid metadata

Joas Antonio dos Santos <joasantonio108@gmail.com>
    gtp: free the skb after handling an echo response

Chengfeng Ye <nicoyip.dev@gmail.com>
    ipvs: fix protocol data lifetime during namespace teardown

Chengfeng Ye <nicoyip.dev@gmail.com>
    ipvs: Defer application parent freeing until after RCU readers

Yingjie Wang <1075151112@qq.com>
    ipv6: reject routes without an inet6_dev

Xia Yan <yanxia@cmss.chinamobile.com>
    ipv6: fix cached route reuse for control messages

Daniël Trujillo <datrujillo@nvidia.com>
    ipv4: fib_trie: prevent speculative out-of-bounds child access

Kyle Zeng <kylebot@openai.com>
    ipv4: keep XFRM headers out of corked skb lengths

Kyle Zeng <kylebot@openai.com>
    mptcp: reject DATA_ACKs against a reversed send interval

Zixuan Chai <petalzu987@gmail.com>
    seg6: validate state in netfilter continuations

Hyunwoo Kim <imv4bel@gmail.com>
    tcp: fix request_sock use-after-free during Fast Open accept()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tcp: fix authentication bypass via unsupported TCP auth options

Hyunwoo Kim <imv4bel@gmail.com>
    tcp: do not coalesce segments after FIN

Yingjie Wang <x-professor@outlook.com>
    tcp: free saved_syn after an RCU grace period

Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>
    tools/bootconfig: Close only opened braces in compact output

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: only install push_pending_record for a TX context

Hungyu Lin <dennylin0707@gmail.com>
    tsacct: Keep task begin times stable across suspend

Jerome Mohm <jrmmhm.kernel@eldare.de>
    vsock/virtio: clear vqs[] to avoid a UAF on a failed PM restore

Ian Rogers <irogers@google.com>
    vdso: Add VDSO_UNALIGNED_PACKED config option

Christian Brauner <brauner@kernel.org>
    udf: don't allocate the inode block in udf_sync_inode_metadata()

Rongzheng Wang <testwrzwrz@gmail.com>
    xsk: defer software checksum until the skb is complete

Tim Menninger <tmenninger@everpuredata.com>
    xprtrdma: serialize unmap_sync with xprt_disconnect

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    net: usb: lan78xx: let unregister_netdev() stop phylink

James Clark <jjc@jclark.com>
    net: stmmac: ptp: fix support for PTP_EXTTS_REQUEST2 ioctl

Zhao Gongyi <zhaogongyi@bytedance.com>
    net: netns: fix INT_MAX nsid cleanup

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    net: mana: report RX checksum offload for IPv6

Jens Axboe <axboe@kernel.dk>
    net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls

Tapio Reijonen <tapio.reijonen@vaisala.com>
    net: dsa: microchip: initialize the IRQ access mutex

Jun Yang <junvyyang@tencent.com>
    net: bridge: use one headroom snapshot for ND replies

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: fix link group ownership in handshake abort

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: fix lgr/lnk lifetime vs diag reader race

Kyle Zeng <kylebot@openai.com>
    net/rds: Do not unpin a page after a failed atomic pin

Jiabin Deng <dengjiabin2023@gmail.com>
    net/mlx5e: SHAMPO, Disable end padding when relaxed ordering is supported

Breno Leitao <leitao@debian.org>
    net/mlx5e: Fix queue stats access to queues without stats

Davidlohr Bueso <dave@stgolabs.net>
    mctp: accept MSG_CMSG_COMPAT in recvmsg

Kyle Zeng <kylebot@openai.com>
    macsec: reject frames that decapsulate into runt Ethernet frames

Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
    liveupdate: check for duplicate session before growing block set

Jean-Paul Sergent <jpsergent@gmail.com>
    net: dst_metadata: fix memcmp overread in skb_metadata_dst_cmp

Florian Bezdeka <florian.bezdeka@siemens.com>
    entry: Fix return type of syscall_trace_enter()

Florian Bezdeka <florian.bezdeka@siemens.com>
    entry: Complete syscall_enter_from_user_mode_work() to bool migration

Hungyu Lin <dennylin0707@gmail.com>
    coda: honor the append state of each write

Cheng Yongkang <teel4res@gmail.com>
    btrfs: reject refs=0 subvolume without DEAD in SUBVOL_SYNC_WAIT

Mani Tofigh <mt4022@columbia.edu>
    btrfs: fix bio counter and bioc leak when async checksumming fails

Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>
    bootconfig: Trim unquoted values at end of file

Breno Leitao <leitao@debian.org>
    ACPI: APEI: GHES: Fix severity check in ghes_log_hwerr()

Vlastimil Babka (SUSE) <vbabka@kernel.org>
    mm/page_alloc: remove the zone_spans_pfn() check from get_pfnblock_bitmap_bitidx()

Josef Bacik <josef@toxicpanda.com>
    mm/page_alloc: clear ->private of deferred free pages

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: snapshot the preferred zone against shrink rebuilds

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: detect zonelist rebuilds from memory hot-add

Josef Bacik <josef@toxicpanda.com>
    mm/page_alloc: keep the pagesets of an empty zone

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: reset can_retry_reserves when the slowpath restarts

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: don't undo another isolation in alloc_contig_range

Josef Bacik <josef@toxicpanda.com>
    mm: page_isolation: do not take slab pages for free

Josef Bacik <josef@toxicpanda.com>
    mm/memory_hotplug: resize zones under their seqlock

Gregory Price (Meta) <gourry@gourry.net>
    mm/mmzone: read each zoneref slot once when filtering by nodemask

Gregory Price (Meta) <gourry@gourry.net>
    mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()

Josef Bacik <josef@toxicpanda.com>
    mm: page_frag: refill the cache for large fragments

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt

Josef Bacik <josef@toxicpanda.com>
    mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone

Gregory Price (Meta) <gourry@gourry.net>
    mm/mmzone: read the zoneref slot once in zonelist_zone()

Christian Brauner <brauner@kernel.org>
    libfs: make i_rwsem the lock of the offset tree

Avi Weiss <thnkslprpt@gmail.com>
    splice, net: avoid MSG_MORE when the bvec array fills

Christian Brauner <brauner@kernel.org>
    fs: fix the SEEK_CUR f_lock condition

Christian Brauner <brauner@kernel.org>
    aio: don't let exit_aio() return before complete() is done

Mani Tofigh <mt4022@columbia.edu>
    eventpoll: wake the next waiter when a woken waiter is killed

Chen Linxuan <me@black-desk.cn>
    pidfd: restrict task access ioctls to the caller's pid namespace

Chris Mason <mason@kernel.org>
    backing-file: pass RWF_NOAPPEND to synchronous writes

Shashank Mohan Jain <jain.sm@gmail.com>
    errseq: don't let errseq_check_and_advance() hide later errors

Joshua Mulloy <joshuamulloy@gmail.com>
    memstick: core: don't clear dev->driver in memstick_device_remove()

Igor Velkov <iav@iav.lv>
    mmc: meson-gx: name the limit of the CMD_CFG timeout field

Igor Velkov <iav@iav.lv>
    mmc: meson-gx: report the longest busy wait the controller can do

Igor Velkov <iav@iav.lv>
    mmc: meson-gx: honour the busy timeout for R1b commands

Igor Velkov <iav@iav.lv>
    mmc: meson-gx: report busy from DAT0 alone

Ian Ray <ian.ray@gehealthcare.com>
    mmc: sdhci-esdhc-imx: map unsupported driver type to Type B

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mmc: omap: synchronize clock timer before disabling fclk

Anfernee Cao <anferneemelokc5@gmail.com>
    mmc: mmci: fix DMA channel leak when mmc_add_host() fails

Anfernee Cao <anferneemelokc5@gmail.com>
    mmc: sunxi: fix clock and runtime PM leaks on probe failure

Karl Mehltretter <kmehltretter@gmail.com>
    mmc: sdhci-brcmstb: don't log an error for missing BOOT registers

Olivier Louvignes <olivier@mgcrea.io>
    mmc: jz4740: Remove the host before resetting the controller

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Validate re-registration earlier in register_kretprobe()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Fix double free and NULL deref in unregister_kretprobes()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Fix error return and slot leak in __register_kprobe()

Steven Rostedt <rostedt@goodmis.org>
    tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc

Jaewon Jung <jaewon8868@gmail.com>
    selftests/ftrace: Add missing spaces after ! in probe syntax tests

Andrew Davison <andy@dvsn.net>
    ALSA: hda: Fix [codec] ID matching in patch files for IDs with bit 31 set

Gichoon Han <gichoon.han@samsung.com>
    ALSA: usb-audio: Drop capture packets with bogus actual_length

Angel J <iamanaws@httpd.dev>
    ALSA: hda/realtek: Fix the Dell XPS 8940 headset microphone

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: hda/cs420x: Add CS4208 fixup for MacBookAir 7,2"

Sergei Nizovtsev <snizovtsev@cloudlinux.com>
    ALSA: caiaq: Kill EP1 URB before unregistering the input device

Zhiqi Zhang <zhiqizhangg@gmail.com>
    bootconfig: Allow keys with the maximum supported depth

Yuansheng Yang <0xbeac@gmail.com>
    KEYS: Protect pkey method checks against type removal

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: Verify the key identity in __key_unlink_begin

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: Reject descriptions larger than KEY_MAX_DESC_SIZE

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: Expand key->{datalen,quotalen} to unsigned int

David Carlier <devnexen@gmail.com>
    tracing/eprobe: Install the trigger for every instance that enables the eprobe

Ridong Chen <chenridong@xiaomi.com>
    cpuset: generalize the validate_partition() interface

Jan Beulich <jbeulich@suse.com>
    Xen/gnttab: improve error handling in gnttab_dma_{alloc,free}_pages()

Jude Gyimah <jude.gyimah87@gmail.com>
    ALSA: aw2-alsa: select SND_PCM

Guixiong Wei <weiguixiong@bytedance.com>
    KEYS: do not let an unmatched key decide the search result

Manuel Ebner <manuelebnerli@mailbox.org>
    docs, kprobes: Fix bracket

Wenwen Fu <wenwfu@qti.qualcomm.com>
    tracing: skip boot kprobe setup when no events were requested

Eric Dumazet <edumazet@kernel.org>
    nsh: limit recursion in nsh_gso_segment()

Chuck Lever <cel@kernel.org>
    selftests: tls: Skip the zero_len tests when TLS is unavailable

Chuck Lever <cel@kernel.org>
    tls: Consume empty data records in tls_sw_splice_read()

Jakub Kicinski <kuba@kernel.org>
    tls: Break the connection after a burst of empty data records

Iustin Stolniceanu <iustin.stolniceanu@analog.com>
    net: phy: c45: select BASE-T1 type for the forced speed

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Fix false WARN_ON_ONCE in flow steering cleanup on RX init failure

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Rename state_destroy to rx_mode_active in flow steering

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: IPsec, don't match upper proto selectors in crypto offload TX

Jiahao Xu <xujiahao@cmss.chinamobile.com>
    net: usb: cdc_ncm: don't underflow the NDP room check

Wenbo Sun <sunwenbo@cmss.chinamobile.com>
    amt: use ipv6_hdr() in amt_mldv1_leave_handler()

Wenbo Sun <sunwenbo@cmss.chinamobile.com>
    af_unix: Inherit SO_INQ in unix_stream_connect()

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().

Eric Dumazet <edumazet@kernel.org>
    net: virtio: fix UDP tunnel GSO header of VLAN tagged packets

Uri Dar <udar@nvidia.com>
    net/mlx5: Lag, Return error when enabling MPESW without LAG support

Antonio Quartulli <antonio@mandelbit.com>
    udp_tunnel: don't treat IPv4 sockets bound to an address as wildcard

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/mlx5e: kTLS, Fix missing error unwind when enabling RX offload

Ivan Vecera <ivecera@redhat.com>
    ice: dpll: set the SyncE divider only for the port driving the output

Ivan Vecera <ivecera@redhat.com>
    ice: dpll: serialize changes of the SyncE CGU registers

Tao Cui <cuitao@kylinos.cn>
    sched_ext: Reject DSQ iterator kfuncs in tracing programs

Wei Wang <weiwan@google.com>
    net: Make PSP skb extension survive packet scrubbing

Junyoung Jang <graypanda.inzag@gmail.com>
    igmp: use the joined device when leaving a multicast group

Fa-Iz Faadhillah Ibrahim <faiz.faadhillah@gmail.com>
    ALSA: hda/realtek: Update quirk for Acer Predator PHN16-72

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - remove headphone MIC support for Dell Pro QC1255

Gustavo Sousa <gustavo.sousa@intel.com>
    drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/pf: Program LMTT directory pointer from each GT's init path

Varun Gupta <varun.gupta@intel.com>
    drm/xe/guc: Demote uncorrectable local error log on CRI

Daniel Charles <daniel.charles@intel.com>
    drm/xe/pm: Apply tile workarounds after PCODE initialization

Alexandre Cassen <acassen@corp.free.fr>
    net/mlx5: HWS, fix flow meter release on FTE update

Ofri Zangi <ofriz@xsightlabs.com>
    tls: fix async encryption race on weakly ordered architectures

Kalpesh Solanki <skalpesh942@gmail.com>
    tun: disallow setting IEEE 802.15.4 and 6LoWPAN link types via TUNSETLINK

Avi Weiss <thnkslprpt@gmail.com>
    net: ena: avoid RX copybreak for multi-descriptor packets

Breno Leitao <leitao@debian.org>
    net: ena: Keep the RX buffer mapped if skb allocation fails

Omar Ramadan <omar@blockcast.net>
    amt: tear down every amt device on an unregistering lower

Chris Mason <mason@kernel.org>
    tcp: Drop any segments if DEFER_CONNECT is set.

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Clear DEFER_CONNECT before tcp_connect() and in tcp_abort().

Zhan Xusheng <zhanxusheng@xiaomi.com>
    erofs: reset buf->off in erofs_init_metabuf()

LiangCheng Wang <zaq14760@gmail.com>
    ASoC: max98090: keep the MIC boost across mic input power-up

Kavitha Daula <kavi@edera.dev>
    xen/grant-table: annotate on-stack work in gnttab_unmap_refs_sync()

Pengpeng Hou <hppiscas@163.com>
    drm/bridge: sii902x: validate I2S data lane values

Kyle Zeng <kylebot@openai.com>
    udp: check frag_list IP family before using skb_segment_list()

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Flush on cursor update also when not using Selective Fetch

Janne Grunau <j@jannau.net>
    ASoC: apple: mca: Fix clock selection for clock consumer FEs

Anandu Padinhare <Anandu.Padinhare@electrifex.com>
    net: stmmac: count XDP_PASS frames in rx_packets on the XSK zero-copy path

Eric Dumazet <edumazet@kernel.org>
    net: gro: compare skb->protocol in gro_list_prepare()

Eric Dumazet <edumazet@kernel.org>
    udp: do not use a cross-family sk_rx_dst in early demux

Eric Dumazet <edumazet@kernel.org>
    tcp: do not resurrect a former listener with SO_ATTACH_REUSEPORT_[CE]BPF

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Do not allow buggy transitions between ehash and lhash2.

Eric Dumazet <edumazet@kernel.org>
    fou: gue: check IP version of held packets for direct IP encapsulation

Kuniyuki Iwashima <kuniyu@google.com>
    net: Fix memory_allocated leak in __sk_mem_raise_allocated().

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Serialize TC and IPsec offload exclusion counters

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Block E-Switch mode changes during IPsec state creation

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Block E-Switch mode changes during IPsec policy creation

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Fix ipsec core device access during profile changes

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Fix E-Switch races in uplink unbind

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Take HCA devcom lock before esw->mode_lock

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Serialize ipsec encap reservations with eswitch operations

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Release IPsec root table reference on RX setup failure

Chris Mason <mason@kernel.org>
    net: skbuff: uncharge trimmed zerocopy frags on error

Yuho Choi <oss.patchbox@gmail.com>
    ptp: kvm: x86: Leak clock_pair page if changing its encryption fails

Chase Hiltz <me@chasehil.tz>
    ipv4: route: don't blackhole in-use routes when retiring fnhe routes

Ivan Vecera <ivecera@redhat.com>
    dpll: notify about a reference sync pair only if it was added

Changyul Lee <lcy8047@gmail.com>
    net/mlx5: macsec: Don't remove fs_id when adding a rule fails

Shay Drory <shayd@nvidia.com>
    net/mlx5: E-switch, Restore host PF enable for ECPF that isn't E-switch manager

Tim Menninger <tmenninger@everpuredata.com>
    NFSv4/flexfiles: limit transport disconnects when cancelling I/O

Tim Menninger <tmenninger@everpuredata.com>
    SUNRPC: add request-scoped disconnects when cancelling tasks

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/flexfiles: Make the pinned device node pointer RCU-managed

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/flexfiles: Hold a device node reference for layoutstats encoding

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/flexfiles: Reference the device node across DS setup

Alexander Duyck <alexanderduyck@fb.com>
    net: Segment CHECKSUM_UNNECESSARY GSO skbs other than fraglist

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Wait for the outbound flush to complete on mailbox teardown

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Suspend phylink after taking the datapath down in ndo_stop

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Disable PTP completions during the Tx force-flush

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Fix service task races with ndo_stop and PM suspend

Umang Pokhriyal <umangpokhriyall@gmail.com>
    tun: delete the flow entries of the moved queue on detach

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4: remember that the server may send CB_NOTIFY_LOCK

Jeff Layton <jlayton@kernel.org>
    NFS: stamp after the server's ctime following a CLONE

Jeff Layton <jlayton@kernel.org>
    NFS: stamp after the server's ctime when truncating under delegated times

Jeff Layton <jlayton@kernel.org>
    NFS: don't let delegated c/mtime stamps go backward

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Protect current->mems_allowed read in cpuset_fork()

Zhang Qiao <zhangqiao22@huawei.com>
    sched_ext: Fix partial-SMT core counting in calc_shard_layout()

Eric Dumazet <edumazet@kernel.org>
    bonding: fix slave_cnt leak on XDP enslave failure

Orgad Shaneh <orgads@gmail.com>
    net: mana: fix XDP_REDIRECT of pre-allocated RX buffers

Denis V. Lunev <den@openvz.org>
    ovl: release the upperdir/workdir in-use locks before the umount sync

Tianyi Gao <tianyi@cloudflare.com>
    net: fix mac_len of skbs copied by generic XDP

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: mac80211: abort chanswitch when leaving an IBSS

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: don't linearize SKBs unnecessarily

Loïc Kassel <loic.kassel@gmail.com>
    wifi: mac80211_hwsim: use CLOCK_BOOTTIME for the beacon timer

Kyle Zeng <kylebot@openai.com>
    ipvlan: make outbound skb headers writable

Kyle Zeng <kylebot@openai.com>
    net: require a full socket in sock_confirm_neigh()

Kyle Zeng <kylebot@openai.com>
    net: protect negative destination advice with RCU

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag, free steering resources on LAG destroy failure

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: Use only loaded devices for PTP clock operations

Arnd Bergmann <arnd@arndb.de>
    net: octeontx2: fix building without DEBUGFS

Li RongQing <lirongqing@baidu.com>
    team: fix promisc/allmulti leak in team_port_add error path

Yaroslav Dudkov <aroslavdudkov622@gmail.com>
    ipv6: ignore link state in gateway check

Gal Pressman <gal@nvidia.com>
    net/mlx5: Bridge, fix bogus MDB offload errors

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Remove gc_in_progress check in unix_peek_fpl().

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Convert unsigned long to u64 for GC.

Francesco Valla <francesco@valla.it>
    spi: virtio: move teardown to .remove()

Jiayuan Chen <jiayuan.chen@linux.dev>
    net: raw: fix ICMP unreachable sent when receive queue is full

Stefano Munari <stefanomunari.sm@gmail.com>
    net: usb: lan78xx: resume phylink on non-reset USB resume

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    idpf: free stashed XSk Rx frame when releasing the queue

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: free stashed Rx frame when cleaning the ring

Chenguang Zhao <zhaochenguang@kylinos.cn>
    i40e: xsk: fix multi-buffer XDP_PASS skb construction

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    libeth: xsk: do not free in-flight frags on XDP_TX completion

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: do not free in-flight frags on XDP_TX completion

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: fix leaking Rx buffers in multi-buffer path

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    i40e: xsk: fix xsk_buff_add_frag() error handling in Rx

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: fix list corruption in xsk_buff_add_frag()

Kyle Zeng <kylebot@openai.com>
    net: skbuff: preserve fclone lifetime when freeing stolen heads

Mark Korenberg <socketpair@gmail.com>
    ublk: publish a new device by its id only once it is set up

Mike Snitzer <snitzer@kernel.org>
    NFS/localio: hold the client across an asynchronous LOCALIO probe

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Balance queue accounting when relocating a task

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Balance switch queue length on transport removal

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: preserve transport security policy when cloning clients

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: preserve timeout policy when cloning clients

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: preserve fatal network errors during RPC binding

Avi Weiss <thnkslprpt@gmail.com>
    sunrpc: instantiate rpc_pipefs dentry before publishing it

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: wake poll waiters when an empty pipe is unlinked

Avi Weiss <thnkslprpt@gmail.com>
    NFS: restore directory index when resuming readdir

Avi Weiss <thnkslprpt@gmail.com>
    NFS: Fix inverted cross-directory rename check

Avi Weiss <thnkslprpt@gmail.com>
    NFS: update ctime for atime-only UTIME_NOW requests

Avi Weiss <thnkslprpt@gmail.com>
    NFS: honor UTIME_NOW atime with explicit mtime

Avi Weiss <thnkslprpt@gmail.com>
    NFSv4.1: retain MDS I/O until both thresholds are met

Zachary Huang <zuzhenhuang365@gmail.com>
    ASoC: es9356: fix the capture gain dB scale

Eric Dumazet <edumazet@kernel.org>
    tcp: rate limit receive queue collapsing

Cheng Yongkang <teel4res@gmail.com>
    btrfs: handle zero num_stripes in btrfs_chunk_item_size()

Filipe Manana <fdmanana@suse.com>
    btrfs: zstd: prevent leak of workspace below maximum level

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix lockdep splat on mount

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't wait for ordered extents in do_zone_finish()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: requeue block group if zone reset bails out

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix possible UAF in wait_eb_writebacks()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: only change active zone counter on successful (de)activation

Samuel Leyva <samuelslg03idk@gmail.com>
    ASoC: amd: acp: es83xx: Enable speaker amplifier after the codec output

Ridong Chen <chenridong@xiaomi.com>
    cgroup/cpuset: Reset partition data when an invalid partition stays invalid

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: guard adata->sdw dereferences with NULL check in IRQ handler

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Enable cycle counting when perfcnt is enabled

Tyler Baker <tyler.baker@oss.qualcomm.com>
    ASoC: qcom: x1e80100: recreate the headset jack on card rebind

Hongyang Zhao <hongyang.zhao@thundersoft.com>
    ASoC: qcom: common: Add generic headset jack helpers

Tyler Baker <tyler.baker@oss.qualcomm.com>
    ASoC: soc-core: copy the DAI link names into the card

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: return -ENOENT from of_gpio_count() stub

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: fix fast-path cancellation in gpiod_get_array()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: fix GPIO descriptor leak in gpiod_get_array()

Jagmeet Randhawa <jagmeet.randhawa@intel.com>
    drm/xe/guc: Do not attribute a TDR disable to a pending suspend

Jagmeet Randhawa <jagmeet.randhawa@intel.com>
    drm/xe/guc: Fix race around q->guc->suspend_pending access

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe/svm: Preserve default PAT index when resetting VMA attributes

Badal Nilawar <badal.nilawar@intel.com>
    drm/xe/xe_late_bind_fw: Fix firmware leak on missing manifest entry

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Access GT MMIO after pcode init

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Toggle the D3Cold enable flag at runtime resume

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe: Rebind BOs evicted before the first LR queue

Raag Jadav <raag.jadav@intel.com>
    drm/xe/pci_error: Flush GT wedge worker before bus reset

Raag Jadav <raag.jadav@intel.com>
    drm/xe: Move xe_device_wedged_fini() registration to xe_device_probe_early()

Raag Jadav <raag.jadav@intel.com>
    drm/xe/hw_error: Guard csc_hw_error_work() with runtime PM

Raag Jadav <raag.jadav@intel.com>
    drm/xe/gt: Use GT ordered workqueue for wedging

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Fix build with DRM_XE=y and CONFIGFS_FS=m

Helen Koike <koike@igalia.com>
    drm/xe/lrc: Restore CTX_CS_INDIRECT_CTX_OFFSET programming for pre-Xe2

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/gsc: Fix NVL-S GSC compatibility number

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe/tuning: Restrict Anyhit NULL-query tuning to render engines

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Handle unavailable memory controller sensors

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Add helpers to validate thermal sensor readings

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Fix thermal sensor data handling

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Decode mailbox temperature as sign-magnitude

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Fix pcode power limit handling

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/hwmon: Use shared pcode default timeout for power limit write

Karthik Poosa <karthik.poosa@intel.com>
    drm/xe/pcode: Increase default pcode mailbox timeout to 10ms

Michał Grzelak <michal.grzelak@intel.com>
    drm/xe/pcode: match argument naming with PCODE_DATAx

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/gt: Disable GT reset worker before engine teardown

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/guc: Protect timeout handling from device unplug

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe: Prevent VF memory IRQ from accessing a torn-down engine

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/xe/pat: Return error from xe_pat_init_early() on unknown platform

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/xe/gsc: Define GSC for NVL-S

Badal Nilawar <badal.nilawar@intel.com>
    drm/xe/cri: Expose device UID through sysfs

Greg Thelen <gthelen@google.com>
    kho: check fdt_phys in is_kho_boot()

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    tracing/probes: bound symstr stores to reserved length

Shao Mingyin <shao.mingyin@zte.com.cn>
    ata: libata-scsi: set the field pointer when rejecting CDL

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: pass the whole mode page to the MODE SELECT handlers

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: fix MODE SELECT field pointer for block descriptor length

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: fix MODE SELECT field pointer for unsupported subpages

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: do not accept subpage code FFh in MODE SELECT

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: fix MODE SELECT handling of data after the mode page

Alexei Starovoitov <ast@kernel.org>
    ipv6: Check the Home Address option again before its address is used

Eric Dumazet <edumazet@kernel.org>
    calipso: do not charge request socket options to the listener

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5e: Add missing Ethernet multicast octets to vport_rx_bytes sum

Jesper L. Nielsen <jln@pascal-audio.com>
    net: ethernet: ti: am65-cpts: keep port and direction when matching PTPv1 TX timestamps

Anil Kaushik <anilkaushikwireless@gmail.com>
    netlink: Do not call the unbind callback with the table locked

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    net/mlx5e: IPoIB, Fix QPN lookup race

Kyle Pepper <cochcoder@proton.me>
    Bluetooth: reject invalid LE supervision timeout relationships

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Serialize global boost updates

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Preserve global boost state on failed updates

Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
    iommu/amd: Clear amd_iommu_snp_en if snp_rmptable_init() fails

Benjamin Segall <bsegall@google.com>
    perf: Fix racy update of cpc->hrtimer_interval

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Avoid context migration from non-owners

Peter Zijlstra <peterz@infradead.org>
    locking/osq: Fix unlink queue corruption

Peter Zijlstra <peterz@infradead.org>
    locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering

Zhuangzhuang Wang <3050681779@qq.com>
    locking/lockdep: Fix inverted "on"/"last" CPU label in lockdep_print_held_locks()

Thomas Fourier <fourier.thomas@gmail.com>
    net/mlx5e: TC, Fix double free of branch in failure

Ridge Lomont <cyridge@proton.me>
    x86/kcfi: Don't emit KCFI_REFERENCE() in modules

Isaac Adjei <code@isaacadjei.me>
    gpio: mpfs: reject unsupported interrupt types

Eric Dumazet <edumazet@kernel.org>
    tcp: bound snd_cwnd_clamp to TCP_MAX_SND_CWND

Kayra Cizmeci <kayracizmeci@gmail.com>
    sched/cache: Ignore non-fair current in alb_break_llc()

Hui Su <sh_def@163.com>
    sched/topology: Balance cluster static-key updates

Hui Su <sh_def@163.com>
    sched/pelt: Fix u32 truncation of the PELT period count

Christian Loehle <christian.loehle@arm.com>
    sched/core: Account I/O waits independently of delayed dequeue

Nickolai Zeldovich <nickolai@csail.mit.edu>
    sched/deadline: Fix this_bw on class change of a dying task

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Simplify event state handling with IBS_CAPS_DIS

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR

Kan Liang <kan.liang@linux.intel.com>
    perf: Add sampling support for SIMD registers

Kan Liang <kan.liang@linux.intel.com>
    perf: Move and enhance has_extended_regs() for arch-specific use

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf: Eliminate duplicate arch-specific function definitions

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Reset CPU0 IBS state on syscore resume

Ian Rogers <irogers@google.com>
    perf/core: Clamp deferred callchain entry count to fit u16 header.size

Ian Rogers <irogers@google.com>
    perf/core: Include perf_event_attr::defer_output in is_sb_event() check

Siddharth Chintamaneni <sidchintamaneni@gmail.com>
    fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()

Jeff Layton <jlayton@kernel.org>
    statx: don't leak STATX_ATTR_CHANGE_MONOTONIC in stx_attributes_mask

Hungyu Lin <dennylin0707@gmail.com>
    vfs: preserve subsecond timestamps at filesystem time limits

Andrea Parri <parri.andrea@gmail.com>
    iov_iter: take an unsigned long segment count in import_iovec()

Abbott Liu <liuwenliang@huawei.com>
    initrd: flush deferred fput() before mounting root

Christian Brauner <brauner@kernel.org>
    libfs: end offset readdir at positions past DIR_OFFSET_EOD

Christian Brauner <brauner@kernel.org>
    libfs: walk offset directories in offset order

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: SB1250: Validate and update IRQ affinity

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Cobalt: Include legacy IDE ports in the PCI I/O window

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Alchemy: Save the Ethernet address before reusing PROM memory

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Alchemy: Register interrupt chips with the IRQ core

Imre Kaloz <kaloz@kernel.org>
    MIPS: SGI-IP30: fix the defconfig defaults for the Bridge PROM and RTC

Rosen Penev <rosenp@gmail.com>
    MIPS: Avoid dead code/data elimination when using recordmcount

Imre Kaloz <kaloz@kernel.org>
    MIPS: SGI-IP27: print the NMI dump on an nbcon console

Eric Dumazet <edumazet@kernel.org>
    tcp: ipv6: free ireq->ipv6_opt after an RCU grace period

Long Zhao <longzhao@ambarella.com>
    gpio: regmap: free the irqchip if adding the irq domain fails

Florian Westphal <fw@strlen.de>
    netfilter: nat: zero newrange before filling it in

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload

Joas Antonio dos Santos <joasantonio108@gmail.com>
    netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: x_tables: check target name before accessing verdict

Laveesh Bansal <laveeshb@laveeshbansal.com>
    netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()

Xingyuan Mo <hdthky0@gmail.com>
    netfilter: nft_set_rbtree: check catchall_sync return before queue_done

Qingfang Deng <qingfang.deng@linux.dev>
    tcp: initialize send sequence numbers before deferring TFO

Cheng Yongkang <teel4res@gmail.com>
    net: bridge: disable MRP ports before the FDB flush in del_nbp()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: set XDP metadata length on the page_pool RX path

Timur Stukan <timur.stukan.linux@gmail.com>
    bonding: fix missing down path on speed/duplex failure after FAIL->UP

Kyle Zeng <kylebot@openai.com>
    ip6mr: Serialize multicast router socket ownership

Timur Stukan <timur.stukan.linux@gmail.com>
    bonding: 3ad: don't set BOND_LINK_FAIL on a slave that is not up

Colton Pawielski <colton.pawielski@gmail.com>
    net: 8139cp: keep Rx masked while NAPI is scheduled

Jinseob Kim <kimjinseob88@gmail.com>
    gpiolib: reset lookup flags for each hogged line

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: Use inverted mute LED quirk for HP ZBook 8 G2a

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Stop cs_dsp before calling cs_dsp_power_down()

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fix mixed cleanup and goto in cs35l56_hda_fw_load()

Michał Kopeć <michal.kopec@3mdeb.com>
    ALSA: hda/core: Stop capability walk on empty capability header

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire: fix inverted streaming speed between tx and rx streams

Shivam Madlani <shivammadlani5@gmail.com>
    ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP OmniBook 7

Munique Feitoza <muniquefeitoz4@gmail.com>
    drm/nouveau: Fix CE channel creation on pre-Kepler GPUs

Rosen Penev <rosenp@gmail.com>
    drm/nouveau/fifo: map Kepler video engine contexts non-privileged

Frederic Konrad <fkonrad@amd.com>
    spi: cadence-quadspi: Fix race between DMA completion and transfer start

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix not updating of hdev->commands[] after reset

Florian Fainelli <florian.fainelli@broadcom.com>
    net: dsa: b53: restore the NSP IMP port 2 Gbps mode

Florian Fainelli <florian.fainelli@broadcom.com>
    net: ethernet: bgmac: preserve forced 2.5 Gbps link speed

Stanislavs Nilovs <valorcool@gmail.com>
    Bluetooth: qca: Disable SoC debug logging for WCN3950

Zhao Li <enderaoelyther@gmail.com>
    Bluetooth: L2CAP: Clear request identifiers on incoming LE connections

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_conn: Fix SCO/eSCO Transport_Unit_Size for HCI data path

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: wm_adsp: Prevent negative string length in wm_adsp_control_add()

Sasha Levin <sashal@kernel.org>
    ACPI: scan: Do not hold physical_node_lock across device_offline() and device_online()

Sasha Levin <sashal@kernel.org>
    ACPI: scan: Print the offline failure message in acpi_bus_offline()

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Fix memory leak on cs_dsp_power_up() error path

Stanley Jhu <stanleyjhu@google.com>
    PM: runtime: Update runtime_pm.rst for non-fatal resume errors

Brian Norris <briannorris@chromium.org>
    PM: runtime: Clarify ->runtime_idle() callback return value handling

Brian Norris <briannorris@chromium.org>
    PM: runtime: Add "Section" hyperlinks

Brian Norris <briannorris@chromium.org>
    PM: runtime: Misc improvements to runtime_pm.rst

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/pm: track BACO state in the SMU v11 ArmD3 sequence

Eric Dumazet <edumazet@kernel.org>
    tcp: ipv6: do not read ireq->pktopts from tcp_v6_send_synack()

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Flush rt->from in rt6_uncached_list_flush_dev().

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Batch rt6_uncached_list_flush_dev() in netdev_run_todo().

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: Batch rt_flush_dev() in netdev_run_todo().

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Flush exception route while replacing nexthop.

Zhou Minqiang <zhouminqiang2@huawei.com>
    PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove

Avi Weiss <thnkslprpt@gmail.com>
    net: skbuff: reject zero MPLS TTL before decrementing

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Hold the policy write lock when changing boost state

Guillaume Nault <gnault@redhat.com>
    tcp: Fix dup-ack detection on non-SACK bidirectional data transfer.

Hungyu Lin <dennylin0707@gmail.com>
    isofs: handle Rock Ridge long-form dates before 1900

Daejun Park <daejun7.park@samsung.com>
    erofs: treat files shared by inode_share as stacked

Joseph Kain <jkain@nuro.ai>
    net: stop defer_count outliving the deferred-free list

James Clark <jjc@jclark.com>
    net: ethernet: ti: am65-cpts: adjust perout genf following ptp changes

Jude Gyimah <jude.gyimah87@gmail.com>
    ASoC: rockchip_spdif: select REGMAP_MMIO

Jude Gyimah <jude.gyimah87@gmail.com>
    ASoC: rockchip_sai: select REGMAP_MMIO

Jude Gyimah <jude.gyimah87@gmail.com>
    ASoC: rockchip_pdm: select REGMAP_MMIO

Jude Gyimah <jude.gyimah87@gmail.com>
    ASoC: rockchip_i2s_tdm: select REGMAP_MMIO

Jude Gyimah <jude.gyimah87@gmail.com>
    ASoC: rockchip_i2s: select REGMAP_MMIO

Chris Mason <mason@kernel.org>
    nvmet-rdma: disconnect a queue on device removal

Chris Mason <mason@kernel.org>
    nvmet-rdma: queue the release work under the mutex

Chris Mason <mason@kernel.org>
    nvmet-rdma: take a device off the list last

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: limit the connections accepted per work run

Chris Mason <mason@kernel.org>
    nvmet-rdma: disconnect only established queues

Josef Bacik <josef@toxicpanda.com>
    nvmet-auth: keep the old keys if the new ones fail

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: ask for the TLS record type on every receive

Josef Bacik <josef@toxicpanda.com>
    nvme-loop: delete the controller if a reset fails

Eric Dumazet <edumazet@kernel.org>
    ipmr, ip6mr: queue netlink route queries out of band

Alexander Goodkind <alex@goodkind.io>
    net: ethernet: mediatek: preserve sibling PPE bindings

Florian Fainelli <florian.fainelli@broadcom.com>
    net: dsa: b53: Enable IGMP and MLD control packet CPU copies

ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
    can: dev: can_tdc_fill_info(): don't read automatic TDCV if interface is down

Cunhao Lu <1579567540@qq.com>
    can: skb: make CAN skb allocation failure paths IRQ-safe

James Fantin-Hardesty <james.fantin-hardesty@seagate.com>
    nvmet: fix arbitration burst field mask

Kyle Zeng <kylebot@openai.com>
    tcp: wait for TIME_WAIT teardown before freeing per-netns ehash

Niklas Cassel <cassel@kernel.org>
    null_blk: don't finish zones to set them read-only or offline

Niklas Cassel <cassel@kernel.org>
    null_blk: fix opening closed zones at the active zone limit

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: reject negative tv_usec in SO_VM_SOCKETS_CONNECT_TIMEOUT

Yunye Zhao <yunye.zhao@linux.alibaba.com>
    virtio_blk: freeze the virtqueue layout at probe time

Shao Mingyin <shao.mingyin@zte.com.cn>
    zloop: reject mismatched conventional zone files on restore

Shao Mingyin <shao.mingyin@zte.com.cn>
    zloop: fix the error code in the blk_mq_alloc_disk message

Avi Weiss <thnkslprpt@gmail.com>
    block: report the correct discard alignment in sysfs

Zizhi Wo <wozizhi@huawei.com>
    block: partitions: reject GPT entries with starting_lba > ending_lba

Shao Mingyin <shao.mingyin@zte.com.cn>
    virtio-blk: Fix zone append sector reporting in batched completion

Jianan Huang <jnhuang95@gmail.com>
    blk-mq: reset queue state on scheduler teardown

John Ogness <john.ogness@linutronix.de>
    printk: Avoid multiple unregistration in unregister_console_locked()

Josef Bacik <josef@toxicpanda.com>
    ext2: only flush DIRSYNC directories on every change

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: fix page reference leak in misaligned I/O fallback

Mingbing Zhai <zhaimingbing@cmss.chinamobile.com>
    virtio_balloon: initialize wakeup_lock before virtqueues are set up

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-vdpa: initialize state before publishing cdev

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost: reject backend enable without a kick file

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-scsi: reject delayed virtqueue setup

sungbyeongchan <tjdqudcks0424@naver.com>
    virtio_ring: use shadow flags when detaching split descriptors

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-scsi: validate event queue descriptor direction

Shuai Zhang <shuai.zhang@oss.qualcomm.com>
    power: sequencing: qcom-wcn: increase WCN7850 power-up delay

Eric Dumazet <edumazet@kernel.org>
    xfrm: iptfs: fix skb leak on error in __input_process_payload()

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: do not count PI bytes in the data length

Eric Dumazet <edumazet@kernel.org>
    soreuseport: annotate data-races around reuse->socks[] and num_socks

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    ksmbd: require NUL-terminated EA names

Bart Van Assche <bvanassche@acm.org>
    mctp i3c: Fix locking in an error path

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vrr: Fix intel_vrr_dcb_vmin_vblank_start()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    wifi: nxpwifi: guard the 11ax response handlers against a detached command buffer

Danish Khateeb <danishkhateeb03@gmail.com>
    selftests/mm: merge: keep the far mremap() targets in the carveout

Xu Yunxiang <xyx2021@mail.ustc.edu.cn>
    bpf: Propagate scalar precision through stack arguments

Alexei Starovoitov <ast@kernel.org>
    bpf: Emit timed may_goto for JITed progs only

Kevin Dewald <kevin@simpleble.org>
    Bluetooth: MGMT: Fix discovery stuck after a failed Stop Discovery

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    Bluetooth: validate retained LE Set CIG Parameters command length

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    Bluetooth: validate retained LE Create CIS command length

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_core: Initialize advertising RPA work only once

Kevin Dewald <kevin@simpleble.org>
    Bluetooth: MGMT: Clear disabled connection parameters when loading none

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_sync: Copy the resolving-list IRK under RCU

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: SMP: Protect LTK encryption with RCU

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: SMP: Protect link keys during LTK derivation

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_core: Keep link-key filtering inside RCU

Ismail Tarim <ismailtarim7@gmail.com>
    Bluetooth: btmtk: fix error handling in btmtk_usb_isointf_init()

Tobias Wilken <tooangel@tooangel.de>
    Bluetooth: MGMT: Return RFKILLED for Set Powered on a blocked controller

Shuai Zhang <shuai.zhang@oss.qualcomm.com>
    Bluetooth: mgmt: reply to cancelled mgmt commands instead of silently dropping

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_sync: Protect resolving-list lookups

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_sync: Copy the LE accept list under hdev->lock

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: derive the firmware ISO setting from MTK_ISO_THRESHOLD

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: bound the ISO payload length by the controller's MTU

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: drop zero-length ISO packets from endpoint padding

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Update the CIS host feature when enabling LE

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Hold incoming data until encryption key size is known

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Convert hci_conn flags to a bitmap

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: MGMT: Add management security level changed event

Peng Fan <peng.fan@nxp.com>
    Bluetooth: use assign_bit() where applicable

Kevin Dewald <kevin@simpleble.org>
    Bluetooth: hci_event: Clear explicit connect state on LE connection

Catherine L <catherine.l@intel.com>
    Bluetooth: btintel: fix buffer over-read in fw payload

Akhil Arul <akhilarul324@gmail.com>
    Bluetooth: hci_core: Fix queuing rx_work while workqueue is drained

Binbin Deng <18983559317@163.com>
    Bluetooth: hci_core: Initialize LTK before publication

Binbin Deng <18983559317@163.com>
    Bluetooth: hci_core: Initialize link key before publication

Binbin Deng <18983559317@163.com>
    Bluetooth: hci_core: Initialize IRK before publication

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix invalid Supervision_Timeout in LE Set Default Rate

Alexandre Mergnat <amergnat@baylibre.com>
    regulator: mt6363: Fix VEMC voltage selection

Alexandre Mergnat <amergnat@baylibre.com>
    regulator: mt6363: Use 8-bit register values

GIBEOM LEE (이기범) <rtx4060@gmail.com>
    regulator: mt6363: Fix the registers of the VSRAM CPU and APU LDOs

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't trust pointers spilled in slots that a callee can write

Alexei Starovoitov <ast@kernel.org>
    bpf: Prepare static analysis passes for callx instruction

Yonghong Song <yonghong.song@linux.dev>
    bpf: Rename bpf_call_summary::num_params to arg_slot_cnt

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix the join of fp+0 with a value that is not a pointer to stack

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: request the irq with the clock enabled

Shubhang Kaushik (Ampere) <sh@gentwo.org>
    sched_ext: Reject scx_bpf_destroy_dsq() in tracing programs

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't move a MAP_FIXED address in arena_get_unmapped_area()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: re-apply taprio offload in __stmmac_open() and stmmac_resume()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: pass the desired EST enable state to est_configure()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: initialize est_lock at probe time

James Clark <jjc@jclark.com>
    net: stmmac: ptp: switch to gettimex64() interface

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: propagate PTP init failures in __stmmac_open() and stmmac_resume()

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: don't advertise EHT-MCS15 to firmware unless we support it

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    net: phy: don't require RTNL to detach a PHY from an unregistered netdev

Markus Stockhausen <markus.stockhausen@gmx.de>
    net: phy: add phy_detach_internal() helper

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: take a private, writable frame before rewriting it in place

Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
    gpio: mpc8xxx: Fix potential use-after-free of IRQ domain

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: release the in-flight slot of a stale TX skb

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    regulator: qcom_spmi: don't take a sleeping lock in the SAW IPI

Yuho Choi <oss.patchbox@gmail.com>
    virtio_blk: Reset device on probe error paths after DRIVER_OK

Jia Jia <physicalmtea@gmail.com>
    vduse: avoid infinite loop when no affinity CPU is online

Sergii Ushakov <sergiiushakov@google.com>
    virtio-blk: clamp max_segments to virtqueue ring size

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: drop the parent's vq callback before the call fd is released

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost: reject invalid IOTLB update permissions

Xiang Mei <xmei5@asu.edu>
    vdpa: fix double free of the reply skb in vdpa_nl_cmd_dev_config_get_doit()

Maoxia <2312891301@qq.com>
    virtio_pci: add missing newline to the pmcsr error message

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost: fix dirty logging for in-order used ring entries

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: do not relock event vq mutex on send_evt fallback

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: preserve event ordering

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa: invalidate DMA mappings before releasing memory

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim: serialize IOTLB updates with dataplane access

Li RongQing <lirongqing@baidu.com>
    virtio_ring: reset IN_ORDER state in virtqueue_init()

Karl Mehltretter <kmehltretter@gmail.com>
    virtio-spi: Fix virtio_spi_config kernel-doc

Alex Austin <alex.austin@amd.com>
    sfc: ptp: avoid racing PPS timestamp updates

Alex Austin <alex.austin@amd.com>
    sfc: ptp: serialize host and MC synchronization transactions

Alex Austin <alex.austin@amd.com>
    sfc: ptp: drop the stale frequency reset in efx_ptp_start()

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: don't allow resident values to overlap the attribute header

Vladimir Zapolskiy <vz@kernel.org>
    drm/panel: visionox-r66451: Wait longer after the panel reset

Vladimir Zapolskiy <vz@kernel.org>
    drm/panel: visionox-r66451: Send the brightness value MSB first

Daejun Park <daejun7.park@samsung.com>
    erofs: apply the stacked fs check to extra file-backed devices

Daniel Machon <daniel.machon@microchip.com>
    net: lan966x: don't free XDP buffers in fdma tx clear with budget 0

Giuseppe Piscitelli <ooonea@gmail.com>
    ata: libata-core: Check device support before querying power state

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix XDP RX buffer DMA sync length

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix VLAN tag stripping on short and non-linear RX frames

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: copy XDP metadata in AF_XDP zero-copy RX

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: drop multi-buffer frames in XDP mode

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: drop split frames on AF_XDP zero-copy RX

James Hilliard <james.hilliard1@gmail.com>
    net: stmmac: take ownership of saved RX state at poll entry

Niklas Cassel <cassel@kernel.org>
    ata: libata-eh: Retry non-NCQ commands when their sense data asks for it

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-sata: allow re-enabling NCQ with the same queue_depth

Eric Dumazet <edumazet@kernel.org>
    tcp: do not let tcp_collapse() drive sk_forward_alloc negative

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    ipv6: fix fib6 walker UAF on NLM_F_REPLACE

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    gpio: shared-proxy: Drop the vote when switching to input

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    gpio: shared-proxy: Drive the default value when no votes are cast

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    gpio: shared-proxy: Drop the vote of a released proxy on write failure

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    gpio: shared-proxy: Fix race between concurrent first users

Vlad Poenaru <vlad.wing@gmail.com>
    bnxt_en: Don't keep MSI-X vectors added before FW reserves them

Joas Antonio dos Santos <joasantonio108@gmail.com>
    net/mlx5: macsec: free struct mlx5_fs_id after an RCU grace period

Animesh Manna <animesh.manna@intel.com>
    drm/i915/cmtg: Disable CMTG after encoder disable in hsw_crtc_disable()

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/display: Limit NVL TRANS_VTOTAL.Vtotal skip to A-step

Yuqiang Sun <izaiahsun@gmail.com>
    bpf: lwt: Free the skb when bpf_xmit() fails to expand the headroom

Michał Kopeć <michal@nozomi.space>
    firmware: coreboot: Don't skip CBMEM entries outside of known memory

Rosen Penev <rosenp@gmail.com>
    spi: acpi: only look up the IRQ of confirmed SPI devices

Alban Bedel <alban.bedel@lht.dlh.de>
    spi: Fix ACPI SPI resources using relative path

James Calligeros <jcalligeros99@gmail.com>
    ASoC: tas2770: Configure transmit clock edge when setting DAI format

Chris Mason <mason@kernel.org>
    bpf: Check the offset in bpf_skb_generic_{push,pop}()

Chris Mason <mason@kernel.org>
    bpf: Use the inner transport header after a decap

Chris Mason <mason@kernel.org>
    bpf: Move the transport header with the moved headers

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't let lwt_in progs call into IPv6 when it is disabled

Alexei Starovoitov <ast@kernel.org>
    bpf: Require BPF_LWT_REROUTE when an lwt_in prog changes the protocol

Alexei Starovoitov <ast@kernel.org>
    bpf: Reset skb->cb after an lwt prog pushes an IP header

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't leave a stale MAC header in bpf_lwt_push_ip_encap()

Chris Mason <mason@kernel.org>
    bpf: Move the MAC header in bpf_lwt_seg6_adjust_srh()

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't look for the SRH again in the End.BPF helpers

Chris Mason <mason@kernel.org>
    bpf: Limit the SRH length in bpf_lwt_seg6_adjust_srh()

Alexei Starovoitov <ast@kernel.org>
    bpf: Set a dst for test runs of lwt_in progs

Chris Mason <mason@kernel.org>
    bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't let bpf_skb_adjust_room() raise gso_size to GSO_BY_FRAGS

Chris Mason <mason@kernel.org>
    bpf, cgroup: Keep the skb network offset signed

Chris Mason <mason@kernel.org>
    bpf: Require prog fd or capability for cgroup detach

Alexei Starovoitov <ast@kernel.org>
    bpf: Remove the WARN from arena_get_unmapped_area()

Alexei Starovoitov <ast@kernel.org>
    bpf: Refuse an arena mmap() longer than max_entries pages

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't let bpf_arena_free_pages() see a half-set user range

Alexei Starovoitov <ast@kernel.org>
    bpf: Refuse to map an arena at address 0

Alexei Starovoitov <ast@kernel.org>
    bpf: Clamp the trace length before the skip test in stackid_init()

Josef Bacik <josef@toxicpanda.com>
    bpf: Clamp the trace length in __bpf_get_stack() again

Hongjian Dai <daihongjian@kylinsec.com.cn>
    spi: pic32-sqi: fail transfer when the BD ring is exhausted

Alexei Starovoitov <ast@kernel.org>
    bpf, x86: Fix bpf_throw() in a prog with a private stack

Tang Bin <tangbin@cmss.chinamobile.com>
    ASoC: codecs: lpass-rx-macro: fix PM ref leak in swclk_gate_enable

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_reject: prevent unbounded recursion in output hooks

Ayushman Rout <ayushmanrout27@gmail.com>
    bpf: Fix bpf_dynptr_copy() for overlapping ranges in one packet

Sasha Levin <sashal@kernel.org>
    ALSA: hda/core: Fix double free on stream page allocation failure

Sasha Levin <sashal@kernel.org>
    ALSA: memalloc: Free the new pages when WC DMA mapping fails

Thomas Fourier <fourier.thomas@gmail.com>
    net: ipa: Fix double free of the interrupt structure on config error

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: reject attaching bearer of different media to the same occupied device

Jia Jia <physicalmtea@gmail.com>
    scsi: target: Validate REGISTER AND MOVE TransportID length

Vincent YUE <vince@palmit.com.au>
    scsi: mpt3sas: Register devices during SANITIZE

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Use combined sense codes

Fernando Fernandez Mancera <fmancera@suse.de>
    net/smc: fix limit_smc_hs sysctl on big-endian architecture

James Hilliard <james.hilliard1@gmail.com>
    ptp: vclock: preserve missing hardware timestamps

James Hilliard <james.hilliard1@gmail.com>
    ptp: vclock: serialize extended samples with counter updates

James Hilliard <james.hilliard1@gmail.com>
    ptp: vclock: propagate physical clock sampling errors

James Hilliard <james.hilliard1@gmail.com>
    ptp: unwind partially completed virtual clock creation

James Hilliard <james.hilliard1@gmail.com>
    ptp: drain virtual clock sysfs operations before unregistering children

Zhi-Jun You <hujy652@gmail.com>
    net: ethernet: mtk_wed: setup WDMA_RING_TX(0) for non-DBDC MT7986

Zhi-Jun You <hujy652@gmail.com>
    net: ethernet: mtk_wed: free up rings during detach

Zhi-Jun You <hujy652@gmail.com>
    net: ethernet: mtk_wed: fix reset condition for rx wdma

Zhi-Jun You <hujy652@gmail.com>
    net: ethernet: mtk_wed: skip ring reset in wdma_tx_ring_setup for WED v3

Puranjay Mohan <puranjay@kernel.org>
    bpf: Drop percpu_counter from the htab element count

Thomas Fourier <fourier.thomas@gmail.com>
    btrfs: zoned: fix double free of bitmaps on clone failure

Filipe Manana <fdmanana@suse.com>
    btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing

Filipe Manana <fdmanana@suse.com>
    btrfs: scrub: fix lost error return value when scrubbing raid56 parity stripe

Filipe Manana <fdmanana@suse.com>
    btrfs: fix fiemap merging compressed extents

guolingxing <guolingxing@tju.edu.cn>
    btrfs: verity: propagate orphan insertion errors when enabling verity

Tejun Heo <tj@kernel.org>
    sched_ext: Call ops.sub_attach() only while the cgroup is online

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    bpf: Fix jited line info off by the CFI preamble

Daniel Borkmann <daniel@iogearbox.net>
    x86/ftrace: Mark jmp mode by clearing bit 63 of trampoline address

Avi Weiss <thnkslprpt@gmail.com>
    gpio: omap: Propagate runtime PM failures in probe and request

Michal Wilczynski <m.wilczynski@samsung.com>
    drm/imagination: Align rogue_fwif_hwrtdata to 64 bytes

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix transport header for inner IPv4 with IP options

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: set MSDU payload correctly

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: fix IRQ disable imbalance in AHB ext interrupt handler

Filippo Falezza <effeffe99@gmail.com>
    wifi: ath10k: Stop unanswered temperature reads

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: avoid overflow when limiting attribute read length

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: initialize VCN when inserting index entries

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: do not store the create fid on special files

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: fall back to the normal open path for non-regular files

Omokefe Emmanuel Onanaroghene <emmaonana18@gmail.com>
    9p: fix kernel-doc warning for enum p9_session_flags

Barret Rhoden <brho@google.com>
    9p: treat read return values of 0 as EOF

Matthew Whitehead <tedheadster@gmail.com>
    scsi: aha1542: Remove unneeded scsi_dma_unmap() call

Giuseppe Piscitelli <ooonea@gmail.com>
    scsi: core: Balance the pseudo target reap reference

Giuseppe Piscitelli <ooonea@gmail.com>
    scsi: scsi_debug: Drain target cleanup before module exit

Imre Kaloz <kaloz@kernel.org>
    scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts

Davidlohr Bueso <dave@stgolabs.net>
    dma-buf: validate the attachment before asserting its reservation lock

Karl Mehltretter <kmehltretter@gmail.com>
    dma-buf: keep the DMA flags in the DMABUF_DEBUG copy

Leon Romanovsky <leon@kernel.org>
    dma-buf: Restore the scatterlist entry count before freeing

Wang Wensheng <wsw9603@163.com>
    printk_ringbuffer: Fix space_used() when blk_lpos->next overflows

Bart Van Assche <bvanassche@acm.org>
    ntfs: Fix error handling in __ntfs_create()

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: ath9k_htc: start ANI when an AP interface begins to beacon

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: Fix failure to create ath12k_dp_peer on MLO reconnect

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    wifi: ath12k: fix decap of MSDUs spanning multiple RX buffers

Avi Weiss <thnkslprpt@gmail.com>
    fsnotify: preserve 64-bit pre-content ranges

Cosmin Ratiu <cratiu@nvidia.com>
    wifi: wext: Limit notifier event flushes to the device's netns

Devin Wittmayer <lucid_duck@justthetip.ca>
    drm/panic: Accept a trailing newline in panic_screen

Antony Antony <antony.antony@secunet.com>
    docs: xfrm: include mark in XFRM_MSG_MIGRATE_STATE EEXIST tuple

Antony Antony <antony.antony@secunet.com>
    xfrm: pass extack through to xfrm_init_replay() from xfrm_init_state()

Antony Antony <antony.antony@secunet.com>
    xfrm: include mark in MIGRATE_STATE SA collision check

Antony Antony <antony.antony@secunet.com>
    xfrm: fix hw offload state leak on xfrm_do_migrate_state() error path

Antony Antony <antony.antony@secunet.com>
    xfrm: fix use-after-free of migrated state in xfrm_do_migrate_state()

Antony Antony <antony.antony@secunet.com>
    xfrm: state: exact mark/mask match for SPI-keyed control-plane SA lookups

Deepanshu Kartikey <kartikey406@gmail.com>
    batman-adv: avoid WARN_ON for orig_ifinfo allocation failure

Shubham Antil <shubham@octane.security>
    xfrm: zero-initialise km_event in the replay-notify path

Haobin Wu <853555@gmail.com>
    9p: skip intermediate directory entry name copy in p9dirent_read()

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    net/9p/usbg: Fix use-after-free on usb9pfs_clear_tx

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    net/9p/usbg: fix descriptor cleanup use-after-free

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    9p: use fc->net_ns for network namespace in RDMA and socket transports

Nick Venenga <nick@venenga.com>
    wifi: rtw89: 8922au: add ASUS BE93

Nick Venenga <nick@venenga.com>
    wifi: rtw89: 8922au: Add support for TP-Link TBE400U

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: usb: Avoid crash with dynamically added device ID

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: destroy force-feedback device on input unregistration

Bryan Cochrane <bcochrane@google.com>
    bnxt_en: Take RTNL before netif_close() when aborting FW reset

Mikhail Malyshev <mike.malyshev@gmail.com>
    io_uring/io-wq: apply the current cpuset to new workers

Siddharth Chintamaneni <sidchintamaneni@gmail.com>
    io_uring/kbuf: initialize arg->out_len from arg->max_len in io_buffers_select()

Cheng Yongkang <teel4res@gmail.com>
    io_uring/rsrc: keep the old file when a file update fails

Cheng Yongkang <teel4res@gmail.com>
    io_uring/timeout: don't rearm a multishot timeout on cancel

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: show stuck workers rather than WARN on a slow exit

Yang Xiuwei <yangxiuwei@kylinos.cn>
    io_uring/rw: fail soft links on IOPOLL short or error IO

Yang Xiuwei <yangxiuwei@kylinos.cn>
    io_uring/futex: fail soft links when cancelling a wait

Yang Xiuwei <yangxiuwei@kylinos.cn>
    io_uring: fail soft links on negative IOU_COMPLETE results

Cinq Prairie <notprairie@gmail.com>
    io_uring/napi: don't end the single NAPI busy poll early on need_resched()

Hui Peng <benquike@gmail.com>
    udf: validate vat20->lengthHeader and VAT inode size in udf_load_vat()

Sasha Levin <sashal@kernel.org>
    Revert "drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts"

Vladimir Petrzhikovskii <vladimir@dfb.sh>
    virtio_net: check RX buffer length before DMA sync

Antheas Kapenekakis <lkml@antheas.dev>
    ALSA: hda/tas2781: Prevent throwing away custom calibration addresses

Krittikun Wongnin <krittikunwongnin@gmail.com>
    ACPI: PM: Add Acer Aspire A515-53G to dmi_leave_unused_power_resources_on[]

Hakan Abay <hakan.abay84@gmail.com>
    ACPI: PM: Add unused power resource quirk for Casper Excalibur G900

Matthias Dittrich <dittrich.m@gmx.net>
    ACPI: PM: Add quirk for Acer Swift 3 SF314-56G (MX250)

Hao Li <hao.li@linux.dev>
    mm/slub: refill prefilled sheaves from the barn

Sergey Lebedev <lsa.uz@pm.me>
    soundwire: dmi-quirks: drop the ghost RT1320 on the Surface Pro 11 (Intel)

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Lenovo Pro 9

Sataporn Saijai <excursively@gmail.com>
    soundwire: dmi-quirks: add Lenovo Yoga Slim 7i 14IPH11

Eric Dumazet <edumazet@kernel.org>
    net: virtio: validate outer protocol of UDP tunnel GSO packets

Eric Dumazet <edumazet@kernel.org>
    tun: clear stale skb->protocol of NAPI frags skbs


-------------

Diffstat:

 .../ABI/testing/sysfs-driver-intel-xe-gpu          |  10 +
 Documentation/arch/arm64/gcs.rst                   |  13 +-
 Documentation/arch/arm64/silicon-errata.rst        |  12 +
 .../bindings/iio/adc/aspeed,ast2600-adc.yaml       |  17 +
 Documentation/filesystems/9p.rst                   |   2 +-
 Documentation/filesystems/overlayfs.rst            |  24 +-
 .../networking/net_cachelines/tcp_sock.rst         |   1 +
 .../networking/xfrm/xfrm_migrate_state.rst         |  25 +-
 Documentation/power/runtime_pm.rst                 |  89 ++++--
 Documentation/trace/kprobes.rst                    |   2 +-
 Makefile                                           |   4 +-
 arch/arm/kernel/perf_regs.c                        |   6 -
 arch/arm64/Kconfig                                 |  44 ++-
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |  28 ++
 arch/arm64/kernel/cpufeature.c                     |   3 +-
 arch/arm64/kernel/kexec_image.c                    |   7 +
 arch/arm64/kernel/perf_regs.c                      |   6 -
 arch/arm64/kernel/ptrace.c                         |   8 +-
 arch/arm64/kernel/signal.c                         |  22 +-
 arch/arm64/kernel/suspend.c                        |  11 +-
 arch/arm64/kernel/topology.c                       |   3 +-
 arch/arm64/mm/hugetlbpage.c                        |  21 +-
 arch/arm64/mm/proc.S                               |  20 ++
 arch/arm64/tools/cpucaps                           |   1 +
 arch/csky/kernel/perf_regs.c                       |   6 -
 arch/loongarch/include/asm/inst.h                  |  21 ++
 arch/loongarch/kernel/inst.c                       |  28 ++
 arch/loongarch/kernel/machine_kexec.c              |   2 +
 arch/loongarch/kernel/machine_kexec_file.c         |   4 +
 arch/loongarch/kernel/perf_regs.c                  |   6 -
 arch/loongarch/kvm/intc/dmsintc.c                  |   1 +
 arch/loongarch/kvm/intc/eiointc.c                  |   1 +
 arch/loongarch/kvm/intc/ipi.c                      |   1 +
 arch/loongarch/kvm/intc/pch_pic.c                  |  18 +-
 arch/loongarch/net/bpf_jit.c                       |  16 +-
 arch/loongarch/power/hibernate.c                   |   6 +
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/alchemy/common/irq.c                     |  11 +-
 arch/mips/alchemy/common/prom.c                    |  23 +-
 arch/mips/cobalt/pci.c                             |  11 +-
 arch/mips/cobalt/setup.c                           |   4 +-
 arch/mips/configs/ip30_defconfig                   |   9 +-
 arch/mips/include/asm/mach-cobalt/cobalt.h         |   1 +
 arch/mips/kernel/perf_regs.c                       |   6 -
 arch/mips/sgi-ip27/ip27-nmi.c                      |   8 +
 arch/mips/sibyte/sb1250/irq.c                      |   3 +
 arch/parisc/kernel/perf_regs.c                     |   6 -
 arch/powerpc/kernel/watchdog.c                     |   3 +
 arch/riscv/kernel/perf_regs.c                      |   6 -
 arch/s390/net/bpf_jit_comp.c                       |   2 -
 arch/x86/events/amd/ibs.c                          | 199 ++++++++++--
 arch/x86/events/amd/uncore.c                       |   2 +-
 arch/x86/kernel/cpu/amd.c                          |   3 +-
 arch/x86/kernel/ftrace_64.S                        |   6 +-
 arch/x86/kernel/ldt.c                              |  12 +-
 arch/x86/kernel/perf_regs.c                        |   6 -
 arch/x86/net/bpf_jit_comp.c                        |   7 +-
 arch/x86/video/video-common.c                      |   2 +-
 block/blk-mq-sched.c                               |   6 +-
 block/blk-mq.c                                     |   3 +
 block/genhd.c                                      |   2 +-
 block/partitions/efi.c                             |   1 +
 crypto/essiv.c                                     |   2 +-
 drivers/accel/ivpu/ivpu_pm.c                       |   9 +-
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/power.c                               |  38 +++
 drivers/acpi/scan.c                                | 108 +++++--
 drivers/ata/libata-core.c                          |   8 +-
 drivers/ata/libata-eh.c                            |  16 +-
 drivers/ata/libata-sata.c                          |   2 +-
 drivers/ata/libata-scsi.c                          | 178 ++++++-----
 drivers/base/power/runtime.c                       |   8 +-
 drivers/base/swnode.c                              |   7 +-
 drivers/block/null_blk/zoned.c                     |  48 ++-
 drivers/block/ublk_drv.c                           |  23 +-
 drivers/block/virtio_blk.c                         | 100 +++++-
 drivers/block/zloop.c                              |   5 +-
 drivers/bluetooth/btintel.c                        |  24 +-
 drivers/bluetooth/btmtk.c                          |  49 ++-
 drivers/bluetooth/btqca.c                          |   1 +
 drivers/bluetooth/btusb_main.c                     |  10 +-
 drivers/bluetooth/hci_qca.c                        |   5 +
 drivers/char/tpm/eventlog/acpi.c                   |   4 +-
 drivers/char/tpm/eventlog/tpm1.c                   |   7 +
 drivers/char/tpm/tpm-dev-common.c                  |  12 +-
 drivers/char/tpm/tpm2-sessions.c                   |   4 +-
 drivers/comedi/comedi_fops.c                       |   2 +-
 drivers/comedi/drivers/addi_apci_1500.c            |   2 +-
 drivers/comedi/drivers/ni_660x.c                   |   3 +-
 drivers/comedi/drivers/ni_tio.c                    |   2 +-
 drivers/comedi/drivers/vmk80xx.c                   |  25 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   9 +-
 drivers/cpufreq/cpufreq.c                          | 162 +++++++---
 drivers/cpufreq/intel_pstate.c                     |  18 +-
 drivers/crypto/caam/caampkc.c                      |  75 ++---
 drivers/dma-buf/dma-buf-mapping.c                  |   6 +-
 drivers/dma-buf/dma-buf.c                          |   4 +
 drivers/dpll/dpll_core.c                           |   3 +-
 drivers/firmware/cirrus/cs_dsp.c                   |   6 +
 drivers/firmware/google/coreboot_table.c           |  42 ++-
 drivers/gpio/gpio-aspeed.c                         |  19 +-
 drivers/gpio/gpio-brcmstb.c                        |   1 +
 drivers/gpio/gpio-mpc8xxx.c                        |  22 +-
 drivers/gpio/gpio-mpfs.c                           |   2 +
 drivers/gpio/gpio-mpsse.c                          |   4 +
 drivers/gpio/gpio-omap.c                           |  13 +-
 drivers/gpio/gpio-regmap.c                         |   5 +
 drivers/gpio/gpio-rockchip.c                       |  15 +-
 drivers/gpio/gpio-sa1100.c                         |  32 +-
 drivers/gpio/gpio-shared-proxy.c                   |  98 +++++-
 drivers/gpio/gpio-sodaville.c                      |   9 +-
 drivers/gpio/gpio-virtuser.c                       |  85 +++--
 drivers/gpio/gpiolib-of.c                          |   2 +-
 drivers/gpio/gpiolib-of.h                          |   2 +-
 drivers/gpio/gpiolib-shared.c                      |   6 +-
 drivers/gpio/gpiolib-shared.h                      |   1 +
 drivers/gpio/gpiolib.c                             |  69 ++--
 drivers/gpio/gpiolib.h                             |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   4 +-
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.c  |   5 +-
 .../amd/display/dc/dio/dcn10/dcn10_link_encoder.c  |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |  20 +-
 drivers/gpu/drm/bridge/sii902x.c                   |   8 +-
 drivers/gpu/drm/drm_panic.c                        |   2 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  19 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |   7 +-
 drivers/gpu/drm/i915/display/intel_vrr.c           |  12 +-
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h       |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   7 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c   |  13 +
 .../gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c    |  20 --
 drivers/gpu/drm/panel/panel-visionox-r66451.c      |   4 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |   7 +-
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c        |   3 +
 drivers/gpu/drm/xe/Kconfig                         |   1 +
 drivers/gpu/drm/xe/display/xe_display_pcode.c      |   4 +-
 drivers/gpu/drm/xe/regs/xe_gt_regs.h               |   1 +
 drivers/gpu/drm/xe/regs/xe_lrc_layout.h            |   3 +
 drivers/gpu/drm/xe/regs/xe_regs.h                  |   2 +
 drivers/gpu/drm/xe/xe_configfs.h                   |  28 --
 drivers/gpu/drm/xe/xe_device.c                     |  25 +-
 drivers/gpu/drm/xe/xe_device.h                     |   4 +
 drivers/gpu/drm/xe/xe_device_sysfs.c               |  36 +++
 drivers/gpu/drm/xe/xe_device_types.h               |   7 +
 drivers/gpu/drm/xe/xe_gpu_scheduler_types.h        |   5 +-
 drivers/gpu/drm/xe/xe_gt.c                         |  74 +++--
 drivers/gpu/drm/xe/xe_gt_types.h                   |   9 +
 drivers/gpu/drm/xe/xe_guc.c                        |   1 -
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h       |   5 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 | 132 +++++---
 drivers/gpu/drm/xe/xe_hw_engine.c                  |  17 +-
 drivers/gpu/drm/xe/xe_hw_error.c                   |   2 +
 drivers/gpu/drm/xe/xe_hwmon.c                      | 187 +++++++----
 drivers/gpu/drm/xe/xe_irq.c                        |   3 +
 drivers/gpu/drm/xe/xe_late_bind_fw.c               |  15 +-
 drivers/gpu/drm/xe/xe_lmtt.c                       |  58 +++-
 drivers/gpu/drm/xe/xe_lmtt.h                       |   5 +-
 drivers/gpu/drm/xe/xe_lrc.c                        |   8 +-
 drivers/gpu/drm/xe/xe_memirq.c                     |   3 +
 drivers/gpu/drm/xe/xe_pat.c                        |  11 +-
 drivers/gpu/drm/xe/xe_pat.h                        |   4 +-
 drivers/gpu/drm/xe/xe_pci.c                        |   7 +
 drivers/gpu/drm/xe/xe_pci_error.c                  |   4 +-
 drivers/gpu/drm/xe/xe_pci_types.h                  |   2 +
 drivers/gpu/drm/xe/xe_pcode.c                      |   4 +-
 drivers/gpu/drm/xe/xe_pcode.h                      |   6 +-
 drivers/gpu/drm/xe/xe_pm.c                         |  20 +-
 drivers/gpu/drm/xe/xe_svm.c                        |   1 +
 drivers/gpu/drm/xe/xe_tuning.c                     |   2 +-
 drivers/gpu/drm/xe/xe_uc_fw.c                      |   1 +
 drivers/gpu/drm/xe/xe_vm.c                         |   9 +-
 drivers/gpu/drm/xe/xe_wa.c                         |   5 +-
 drivers/gpu/drm/xe/xe_wa_oob.rules                 |   1 +
 drivers/hwmon/aht10.c                              |   2 +-
 drivers/hwmon/gpio-fan.c                           |  24 +-
 drivers/hwmon/max31760.c                           |  12 +-
 drivers/hwmon/pmbus/mp2975.c                       | 207 ++++++------
 drivers/hwmon/scmi-hwmon.c                         |  25 +-
 drivers/hwmon/sy7636a-hwmon.c                      |   2 +-
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/accel/adxl380.c                        |  11 +-
 drivers/iio/accel/kxsd9.c                          |   2 +-
 drivers/iio/adc/ad7780.c                           |   4 +-
 drivers/iio/adc/ad7791.c                           |   4 +-
 drivers/iio/adc/ad7793.c                           |   4 +-
 drivers/iio/adc/ad7923.c                           |   1 +
 drivers/iio/adc/aspeed_adc.c                       |  25 +-
 drivers/iio/adc/max11205.c                         |   4 +-
 drivers/iio/addac/ad74413r.c                       |   2 +-
 drivers/iio/afe/iio-rescale.c                      |   3 +-
 drivers/iio/chemical/atlas-ezo-sensor.c            |   3 -
 .../iio/common/hid-sensors/hid-sensor-attributes.c |  14 +-
 .../iio/common/inv_sensors/inv_sensors_timestamp.c |  24 +-
 drivers/iio/common/scmi_sensors/scmi_iio.c         |  27 +-
 drivers/iio/dac/mcp4725.c                          |   2 +
 drivers/iio/gyro/bmg160_core.c                     |   2 +-
 drivers/iio/humidity/am2315.c                      |  12 +-
 drivers/iio/humidity/hid-sensor-humidity.c         |  14 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |  24 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |  97 ++++--
 drivers/iio/imu/kmx61.c                            |   2 +-
 drivers/iio/industrialio-acpi.c                    |   9 +
 drivers/iio/industrialio-trigger.c                 |   4 +-
 drivers/iio/light/tsl2591.c                        |  32 +-
 drivers/iio/light/vcnl4035.c                       |   4 +-
 drivers/iio/magnetometer/mmc35240.c                |   3 +-
 drivers/iio/magnetometer/mmc5633.c                 |   3 +-
 drivers/iio/magnetometer/tlv493d.c                 |   6 +-
 drivers/iio/proximity/hx9023s.c                    |  16 +-
 drivers/iio/proximity/sx9310.c                     |   2 +-
 drivers/iio/proximity/sx9324.c                     |  13 +-
 drivers/iio/proximity/sx9360.c                     |  29 +-
 drivers/iio/proximity/sx9500.c                     |   6 +
 drivers/iio/temperature/hid-sensor-temperature.c   |  14 +-
 drivers/iio/temperature/mlx90614.c                 |   2 +-
 drivers/input/ff-core.c                            |   2 +-
 drivers/input/ff-memless.c                         |  23 --
 drivers/input/input.c                              |   5 +-
 drivers/iommu/amd/init.c                           |   1 +
 drivers/md/dm-cache-metadata.c                     |   4 +-
 drivers/md/dm-cache-target.c                       |  15 +-
 drivers/md/dm-crypt.c                              |  22 +-
 drivers/md/dm-integrity.c                          |  30 +-
 drivers/md/dm-ioctl.c                              |   2 +-
 drivers/md/dm-log-userspace-base.c                 |   6 +-
 drivers/md/dm-mpath.c                              |   6 +-
 drivers/md/dm-pcache/backing_dev.c                 |   4 +-
 drivers/md/dm-pcache/backing_dev.h                 |   2 +-
 drivers/md/dm-pcache/cache_writeback.c             |  28 +-
 drivers/md/dm-raid.c                               |   5 +-
 drivers/md/dm-snap.c                               |  18 +-
 drivers/md/dm-sysfs.c                              |  17 +-
 drivers/md/dm-table.c                              | 146 +++++----
 drivers/md/dm-thin-metadata.c                      |   5 +-
 drivers/md/dm-thin.c                               |   7 +-
 drivers/md/dm-verity-target.c                      |  27 +-
 drivers/md/dm-zone.c                               |   2 +
 drivers/md/dm-zoned-reclaim.c                      |  18 +-
 drivers/md/dm.c                                    |  21 +-
 drivers/md/dm.h                                    |  18 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  13 +-
 drivers/md/persistent-data/dm-btree.c              |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   9 +-
 drivers/memstick/core/memstick.c                   |   1 -
 drivers/misc/bcm-vk/bcm_vk_sg.c                    |  43 ++-
 drivers/misc/ibmvmc.c                              |  16 +-
 drivers/misc/mei/hw-me-regs.h                      |   1 +
 drivers/misc/mei/mei_lb.c                          |  12 +-
 drivers/misc/mei/pci-me.c                          |   1 +
 drivers/misc/vmw_vmci/vmci_event.c                 |   7 +-
 drivers/mmc/host/jz4740_mmc.c                      |   5 +-
 drivers/mmc/host/meson-gx-mmc.c                    |  26 +-
 drivers/mmc/host/mmci.c                            |   4 +-
 drivers/mmc/host/omap.c                            |   4 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |  11 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  17 +
 drivers/mmc/host/sunxi-mmc.c                       |  24 +-
 drivers/net/amt.c                                  |  61 ++--
 drivers/net/bonding/bond_main.c                    |  87 ++---
 drivers/net/can/dev/netlink.c                      |  17 +-
 drivers/net/can/dev/skb.c                          |   6 +-
 drivers/net/dsa/b53/b53_common.c                   |  69 +++-
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/b53/b53_regs.h                     |  17 +
 drivers/net/dsa/bcm_sf2.c                          |   5 +
 drivers/net/dsa/microchip/ksz_common.c             |   1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  13 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   3 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  49 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  35 +-
 drivers/net/ethernet/intel/ice/ice_adapter.c       |   2 +
 drivers/net/ethernet/intel/ice/ice_adapter.h       |   4 +
 drivers/net/ethernet/intel/ice/ice_dpll.c          |  11 +-
 drivers/net/ethernet/intel/ice/ice_dpll.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   8 +-
 drivers/net/ethernet/intel/ice/ice_tspll.c         |   8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  19 +-
 drivers/net/ethernet/intel/idpf/xsk.c              |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 -
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   5 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   5 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  99 ++++--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  90 +++---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  19 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  48 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  15 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  88 ++---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 248 +++++++++++----
 .../net/ethernet/mellanox/mlx5/core/lib/clock.h    |   2 +
 .../ethernet/mellanox/mlx5/core/lib/macsec_fs.c    |  41 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   8 +-
 .../mellanox/mlx5/core/steering/hws/fs_hws.h       |   2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h        |   5 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |  16 +
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |  38 ++-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |  10 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   6 +
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |  10 +-
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |   9 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  18 +-
 drivers/net/ethernet/realtek/8139cp.c              |   8 +-
 drivers/net/ethernet/sfc/ptp.c                     | 108 ++++---
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |   2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   7 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c   |  61 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.h   |   8 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 333 ++++++++++++-------
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |  65 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  99 +++---
 drivers/net/ethernet/ti/am65-cpts.c                |  98 ++++--
 drivers/net/gtp.c                                  |  22 +-
 drivers/net/hyperv/rndis_filter.c                  |   6 +-
 drivers/net/ipa/ipa_interrupt.c                    |  12 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +-
 drivers/net/macsec.c                               |  15 +-
 drivers/net/mctp/mctp-i3c.c                        |   3 +-
 drivers/net/phy/phy-c45.c                          |  46 ++-
 drivers/net/phy/phy_device.c                       | 176 +++++-----
 drivers/net/team/team_core.c                       |   9 +-
 drivers/net/tun.c                                  |  21 +-
 drivers/net/tun_vnet.h                             |   5 +-
 drivers/net/usb/cdc_ncm.c                          |   4 +-
 drivers/net/usb/lan78xx.c                          |  21 +-
 drivers/net/virtio_net.c                           |  65 ++--
 drivers/net/wireless/ath/ath10k/core.c             |   1 +
 drivers/net/wireless/ath/ath10k/thermal.c          |   9 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |   2 +
 drivers/net/wireless/ath/ath12k/ahb.c              |  11 +-
 drivers/net/wireless/ath/ath12k/core.c             |   3 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   8 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  17 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcc2072.c    |  30 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    |  32 +-
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.c    |  30 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   8 +-
 drivers/net/wireless/nxp/nxpwifi/11ax.c            |  67 ++--
 drivers/net/wireless/nxp/nxpwifi/scan.c            |  18 +-
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c     |   8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852au.c     |   8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c     |   8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c     |   8 +-
 drivers/net/wireless/realtek/rtw89/rtw8922au.c     |  14 +-
 drivers/net/wireless/realtek/rtw89/usb.c           |   5 +-
 drivers/net/wireless/realtek/rtw89/usb.h           |   3 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |   4 +-
 drivers/nvme/host/core.c                           |   4 +
 drivers/nvme/target/admin-cmd.c                    |   4 +-
 drivers/nvme/target/auth.c                         |  69 ++--
 drivers/nvme/target/loop.c                         |   5 +-
 drivers/nvme/target/rdma.c                         |  55 ++--
 drivers/nvme/target/tcp.c                          |  13 +-
 drivers/power/sequencing/pwrseq-pcie-m2.c          |  46 ++-
 drivers/power/sequencing/pwrseq-qcom-wcn.c         |   2 +-
 drivers/powercap/intel_rapl_common.c               |  15 +-
 drivers/ptp/ptp_clock.c                            |   5 +
 drivers/ptp/ptp_kvm_x86.c                          |   7 +-
 drivers/ptp/ptp_private.h                          |   7 +-
 drivers/ptp/ptp_sysfs.c                            |  18 +-
 drivers/ptp/ptp_vclock.c                           | 123 ++++---
 drivers/regulator/Kconfig                          |   1 +
 drivers/regulator/mt6363-regulator.c               | 156 +++------
 drivers/regulator/qcom_spmi-regulator.c            |  35 +-
 drivers/s390/block/dasd_eckd.c                     |   3 +-
 drivers/s390/block/dasd_ioctl.c                    |   4 +-
 drivers/scsi/aha1542.c                             |   2 -
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  71 +++--
 drivers/scsi/scsi_debug.c                          |   1 +
 drivers/scsi/scsi_scan.c                           |   5 +-
 drivers/soundwire/dmi-quirks.c                     |  42 +++
 drivers/spi/spi-axi-spi-engine.c                   |   2 +
 drivers/spi/spi-cadence-quadspi.c                  |   4 +-
 drivers/spi/spi-pic32-sqi.c                        |   3 +-
 drivers/spi/spi-tegra210-quad.c                    |  41 ++-
 drivers/spi/spi-virtio.c                           |  26 +-
 drivers/spi/spi.c                                  |  40 ++-
 drivers/target/target_core_pr.c                    |   9 +-
 drivers/thunderbolt/stream.c                       |   6 +
 drivers/tty/serial/8250/8250_exar.c                |   2 +-
 drivers/tty/serial/8250/8250_lpss.c                |   3 +
 drivers/tty/serial/8250/8250_mxpcie.c              |  13 +-
 drivers/tty/serial/fsl_lpuart.c                    |  10 +-
 drivers/tty/serial/imx.c                           |  10 +-
 drivers/tty/serial/rda-uart.c                      |   2 +
 drivers/tty/serial/samsung_tty.c                   |   8 +-
 drivers/tty/serial/serial_core.c                   |  25 +-
 drivers/tty/serial/serial_port.c                   |   4 +-
 drivers/tty/tty_io.c                               |   3 +-
 drivers/tty/vt/keyboard.c                          |   6 +
 drivers/tty/vt/vt.c                                |   2 +
 drivers/usb/class/cdc-acm.c                        |  18 +-
 drivers/usb/dwc3/core.h                            |   4 +-
 drivers/usb/dwc3/dwc3-xilinx.c                     | 123 +++++--
 drivers/usb/dwc3/ep0.c                             |   2 +-
 drivers/usb/dwc3/gadget.c                          | 160 ++++++----
 drivers/usb/dwc3/trace.h                           |   1 +
 drivers/usb/gadget/function/f_mass_storage.c       |   8 +-
 drivers/usb/gadget/function/f_midi.c               |   4 +
 drivers/usb/gadget/function/f_ncm.c                |   7 +-
 drivers/usb/gadget/function/storage_common.c       |   7 +-
 drivers/usb/gadget/function/storage_common.h       |   3 +-
 drivers/usb/gadget/function/u_serial.c             | 170 ++++++++--
 drivers/usb/host/pci-quirks.c                      |  13 +-
 drivers/usb/host/xhci-mem.c                        |  16 +-
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/usb/misc/usbtest.c                         |   3 +
 drivers/usb/serial/garmin_gps.c                    |  31 +-
 drivers/usb/serial/io_edgeport.c                   | 141 ++++----
 drivers/usb/serial/oti6858.c                       |  16 +-
 drivers/usb/serial/sierra.c                        |  18 +-
 drivers/usb/serial/upd78f0730.c                    |  13 +-
 drivers/usb/storage/uas-detect.h                   |   8 +-
 drivers/usb/typec/mux/fsa4480.c                    |   9 +-
 drivers/usb/typec/mux/nb7vpq904m.c                 |   1 +
 drivers/usb/typec/ucsi/debugfs.c                   |   3 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  10 +-
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |  35 ++
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  10 +-
 drivers/vdpa/vdpa.c                                |   7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   7 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  15 +-
 drivers/vhost/scsi.c                               |  61 +++-
 drivers/vhost/test.c                               |   4 +
 drivers/vhost/vdpa.c                               |  87 ++++-
 drivers/vhost/vhost.c                              |  33 +-
 drivers/virtio/virtio_balloon.c                    |   3 +-
 drivers/virtio/virtio_pci_common.c                 |   2 +-
 drivers/virtio/virtio_ring.c                       |   8 +-
 drivers/w1/masters/ds2482.c                        |  36 ++-
 drivers/w1/slaves/w1_ds2805.c                      |   8 +-
 drivers/w1/slaves/w1_ds28e04.c                     |  18 +-
 drivers/w1/slaves/w1_therm.c                       |  37 ++-
 drivers/w1/w1.c                                    |  21 +-
 drivers/w1/w1_int.c                                |   8 +-
 drivers/w1/w1_netlink.c                            |   8 +-
 drivers/watchdog/gunyah_wdt.c                      |  27 +-
 drivers/watchdog/npcm_wdt.c                        |  15 +-
 drivers/watchdog/rzv2h_wdt.c                       |  10 +-
 drivers/xen/gntdev.c                               |   8 +-
 drivers/xen/grant-table.c                          |  37 ++-
 drivers/xen/privcmd.c                              |  15 +
 drivers/xen/pvcalls-back.c                         |  26 +-
 fs/9p/v9fs.h                                       |  26 +-
 fs/9p/vfs_addr.c                                   |   3 +
 fs/9p/vfs_dir.c                                    |   6 +-
 fs/9p/vfs_inode.c                                  |  10 +
 fs/9p/vfs_inode_dotl.c                             |  36 ++-
 fs/adfs/dir_fplus.c                                |   2 +
 fs/aio.c                                           |   4 +-
 fs/backing-file.c                                  |   7 +-
 fs/btrfs/bio.c                                     |   4 +
 fs/btrfs/fiemap.c                                  |   3 +-
 fs/btrfs/ioctl.c                                   |   8 +-
 fs/btrfs/scrub.c                                   |  10 +-
 fs/btrfs/verity.c                                  |   2 +-
 fs/btrfs/volumes.h                                 |   5 +-
 fs/btrfs/zoned.c                                   |  81 +++--
 fs/btrfs/zstd.c                                    |   3 +-
 fs/coda/file.c                                     |   3 +-
 fs/dcache.c                                        |  44 ++-
 fs/erofs/data.c                                    |   1 +
 fs/erofs/super.c                                   |  23 +-
 fs/eventpoll.c                                     |  11 +-
 fs/ext2/dir.c                                      |   3 +
 fs/ext2/inode.c                                    |  61 ++--
 fs/ext4/inode.c                                    |  17 +-
 fs/file.c                                          |  10 +-
 fs/inode.c                                         |  16 +-
 fs/isofs/util.c                                    |   8 +-
 fs/libfs.c                                         | 133 +++-----
 fs/minix/bitmap.c                                  |  37 ++-
 fs/minix/inode.c                                   |  16 +-
 fs/minix/minix.h                                   |   1 +
 fs/netfs/read_retry.c                              |  17 +-
 fs/netfs/write_issue.c                             |   4 +-
 fs/nfs/delegation.h                                |   2 +
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             | 223 ++++++++-----
 fs/nfs/flexfilelayout/flexfilelayout.h             |  29 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          | 160 ++++++----
 fs/nfs/inode.c                                     |  69 +++-
 fs/nfs/localio.c                                   |  13 +-
 fs/nfs/nfs42proc.c                                 |  25 +-
 fs/nfs/nfs4proc.c                                  |   7 +-
 fs/nfs/pnfs.c                                      |   2 +-
 fs/notify/fanotify/fanotify.h                      |   2 +-
 fs/notify/fsnotify.c                               |   2 +-
 fs/ntfs/attrib.c                                   |   9 +-
 fs/ntfs/dir.c                                      |  14 +
 fs/ntfs/index.c                                    |  32 +-
 fs/ntfs/inode.c                                    |   2 +-
 fs/ntfs/namei.c                                    |   6 +-
 fs/overlayfs/dir.c                                 |  20 +-
 fs/overlayfs/namei.c                               |  61 +++-
 fs/overlayfs/overlayfs.h                           |  22 +-
 fs/overlayfs/ovl_entry.h                           |   2 +
 fs/overlayfs/params.c                              |  91 ++++--
 fs/overlayfs/params.h                              |   2 +
 fs/overlayfs/super.c                               |  52 ++-
 fs/overlayfs/util.c                                |  12 +
 fs/pidfs.c                                         |   8 +
 fs/proc/proc_sysctl.c                              |   5 +-
 fs/read_write.c                                    |  10 +-
 fs/smb/client/cifs_fs_sb.h                         |   2 +
 fs/smb/client/cifsacl.c                            |  11 +-
 fs/smb/client/cifsacl.h                            |  14 -
 fs/smb/client/cifsfs.c                             |  23 +-
 fs/smb/client/cifsglob.h                           |   4 +
 fs/smb/client/cifsproto.h                          |   2 +
 fs/smb/client/connect.c                            |   3 +-
 fs/smb/client/dfs.c                                |  12 +-
 fs/smb/client/file.c                               | 205 +++++++++++-
 fs/smb/client/sess.c                               |   4 +-
 fs/smb/client/smb2ops.c                            |   9 +-
 fs/smb/client/smb2pdu.c                            |  95 +++---
 fs/smb/client/smb2proto.h                          |   9 +
 fs/smb/server/mgmt/user_config.h                   |   5 +
 fs/smb/server/smb2pdu.c                            |  31 +-
 fs/smb/server/smbacl.c                             | 215 ++++++++++---
 fs/smb/server/smbacl.h                             |   2 +-
 fs/splice.c                                        |  11 +-
 fs/stat.c                                          |   6 +-
 fs/udf/inode.c                                     |  31 +-
 fs/udf/super.c                                     |  14 +-
 include/acpi/acpi_bus.h                            |   1 +
 include/linux/blk-mq.h                             |   3 +-
 include/linux/bpf.h                                |   2 +
 include/linux/bpf_verifier.h                       |   8 +-
 include/linux/compiler.h                           |   7 +-
 include/linux/cpufreq.h                            |   7 +-
 include/linux/entry-common.h                       |   4 +-
 include/linux/fs.h                                 |   2 +-
 include/linux/fs/super_types.h                     |   2 +-
 include/linux/fsnotify.h                           |   4 +-
 include/linux/fsnotify_backend.h                   |   6 +-
 include/linux/ftrace.h                             |   8 +-
 include/linux/iio/common/inv_sensors_timestamp.h   |   3 +-
 include/linux/input.h                              |   3 -
 include/linux/key.h                                |   7 +-
 include/linux/mlx5/driver.h                        |   8 +-
 include/linux/mmzone.h                             |   3 +-
 include/linux/mroute_base.h                        |   2 +
 include/linux/netdevice_xmit.h                     |   4 +-
 include/linux/nfs_fs_sb.h                          |   1 +
 include/linux/perf_event.h                         |  28 ++
 include/linux/perf_regs.h                          |  36 +--
 include/linux/ptp_clock_kernel.h                   |   2 +-
 include/linux/regulator/mt6363-regulator.h         |   1 +
 include/linux/sched.h                              |   2 +
 include/linux/stat.h                               |   3 +
 include/linux/sunrpc/sched.h                       |   4 +
 include/linux/sunrpc/xprt.h                        |   5 +
 include/linux/tcp.h                                |  10 +-
 include/linux/uio.h                                |   8 +-
 include/linux/virtio_net.h                         | 181 ++++++++++-
 include/net/9p/client.h                            |   2 +-
 include/net/bluetooth/hci_core.h                   | 135 ++++----
 include/net/bluetooth/mgmt.h                       |  14 +
 include/net/dst_metadata.h                         |   2 +
 include/net/gro.h                                  |  18 +-
 include/net/gso.h                                  |   2 +-
 include/net/inet_common.h                          |   2 +-
 include/net/inet_connection_sock.h                 |   1 +
 include/net/ip6_route.h                            |   7 +
 include/net/iw_handler.h                           |   8 +-
 include/net/libeth/xsk.h                           |  10 +-
 include/net/mana/mana.h                            |   5 +-
 include/net/net_namespace.h                        |   1 +
 include/net/netfilter/nf_dup_netdev.h              |  35 --
 include/net/netfilter/nf_queue.h                   |   1 +
 include/net/netfilter/nf_recursion.h               |  42 +++
 include/net/request_sock.h                         |   3 +-
 include/net/route.h                                |   6 +
 include/net/sock.h                                 |  24 +-
 include/net/tcp.h                                  |   9 +
 include/net/tcp_ao.h                               |   3 +-
 include/net/tls.h                                  |   1 +
 include/net/xdp_sock_drv.h                         |   7 +-
 include/net/xfrm.h                                 |   7 +
 include/trace/events/oom.h                         |   8 +-
 include/uapi/linux/mdio.h                          |  13 +-
 include/uapi/linux/perf_event.h                    |  49 ++-
 include/uapi/linux/virtio_spi.h                    |   2 +-
 include/vdso/unaligned.h                           |  16 +
 init/do_mounts_rd.c                                |   5 +
 io_uring/futex.c                                   |   1 +
 io_uring/io-wq.c                                   |  68 +++-
 io_uring/io_uring.c                                |   8 +-
 io_uring/io_uring.h                                |   1 +
 io_uring/kbuf.c                                    |   1 +
 io_uring/napi.c                                    |  31 +-
 io_uring/rsrc.c                                    |   6 +-
 io_uring/rw.c                                      |   4 +-
 io_uring/timeout.c                                 |   3 +-
 kernel/bpf/arena.c                                 |  29 +-
 kernel/bpf/backtrack.c                             |  31 +-
 kernel/bpf/cgroup.c                                |  26 +-
 kernel/bpf/const_fold.c                            |   3 +-
 kernel/bpf/core.c                                  |   8 +-
 kernel/bpf/fixups.c                                |   9 +-
 kernel/bpf/hashtab.c                               |  64 ++--
 kernel/bpf/helpers.c                               |  16 +-
 kernel/bpf/liveness.c                              | 131 +++++---
 kernel/bpf/stackmap.c                              |  33 +-
 kernel/bpf/states.c                                |  14 +
 kernel/bpf/verifier.c                              |   8 +-
 kernel/cgroup/cgroup.c                             |  22 +-
 kernel/cgroup/cpuset.c                             | 174 ++++++----
 kernel/cgroup/legacy_freezer.c                     |  40 ++-
 kernel/events/core.c                               | 230 +++++++++++---
 kernel/events/hw_breakpoint.c                      |   3 +-
 kernel/kprobes.c                                   |  82 +++--
 kernel/liveupdate/kexec_handover.c                 |   2 +-
 kernel/liveupdate/luo_session.c                    |  21 +-
 kernel/locking/lockdep.c                           |   2 +-
 kernel/locking/osq_lock.c                          |  62 +++-
 kernel/printk/printk.c                             |  34 +-
 kernel/printk/printk_ringbuffer.c                  |   8 +-
 kernel/sched/core.c                                |  42 +--
 kernel/sched/core_sched.c                          |   3 +-
 kernel/sched/deadline.c                            |   2 +-
 kernel/sched/ext/cid.c                             |   8 +-
 kernel/sched/ext/ext.c                             |  62 +++-
 kernel/sched/ext/inlines.h                         |  37 ++-
 kernel/sched/ext/internal.h                        |   4 +
 kernel/sched/ext/sub.c                             |  13 +
 kernel/sched/fair.c                                |   9 +-
 kernel/sched/pelt.c                                |   2 +-
 kernel/sched/sched.h                               |  26 +-
 kernel/sched/syscalls.c                            |  10 +-
 kernel/sched/topology.c                            |  16 +-
 kernel/time/timekeeping.c                          |  12 +-
 kernel/trace/trace_eprobe.c                        |  83 ++---
 kernel/trace/trace_event_perf.c                    |   3 +-
 kernel/trace/trace_fprobe.c                        |  22 +-
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.c                         |  79 ++++-
 kernel/trace/trace_probe_tmpl.h                    |  14 +-
 kernel/trace/trace_uprobe.c                        |  67 ++--
 kernel/tsacct.c                                    |  10 +-
 lib/bootconfig.c                                   |   7 +-
 lib/errseq.c                                       |  29 +-
 lib/iov_iter.c                                     |   6 +-
 lib/vdso/Kconfig                                   |  10 +
 mm/memory_hotplug.c                                |  51 ++-
 mm/mempolicy.c                                     |   4 +-
 mm/mmzone.c                                        |  11 +-
 mm/page_alloc.c                                    |  78 +++--
 mm/page_frag_cache.c                               |  21 +-
 mm/page_isolation.c                                |   7 +
 mm/shmem.c                                         |   2 +-
 mm/slub.c                                          |  81 +++++
 net/9p/protocol.c                                  |  12 +-
 net/9p/trans_fd.c                                  |  11 +-
 net/9p/trans_rdma.c                                |   2 +-
 net/9p/trans_usbg.c                                |  10 +-
 net/batman-adv/bat_iv_ogm.c                        |   2 +-
 net/bluetooth/hci_conn.c                           | 132 +++++---
 net/bluetooth/hci_core.c                           |  66 ++--
 net/bluetooth/hci_event.c                          | 353 ++++++++++++++-------
 net/bluetooth/hci_sync.c                           | 198 +++++++++---
 net/bluetooth/iso.c                                |  35 +-
 net/bluetooth/l2cap_core.c                         |  23 +-
 net/bluetooth/l2cap_sock.c                         |  25 +-
 net/bluetooth/mgmt.c                               | 121 ++++++-
 net/bluetooth/rfcomm/core.c                        |   6 +-
 net/bluetooth/rfcomm/sock.c                        |   5 +-
 net/bluetooth/sco.c                                |  10 +-
 net/bluetooth/smp.c                                |  53 ++--
 net/bpf/test_run.c                                 |   3 +-
 net/bridge/br_arp_nd_proxy.c                       |   6 +-
 net/bridge/br_if.c                                 |   6 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   2 +-
 net/core/dev.c                                     |  62 +++-
 net/core/filter.c                                  | 138 ++++++--
 net/core/gro.c                                     |  31 +-
 net/core/lwt_bpf.c                                 |  57 +++-
 net/core/net_namespace.c                           |  17 +-
 net/core/skbuff.c                                  |  65 +++-
 net/core/sock.c                                    |   4 +-
 net/core/sock_reuseport.c                          |  26 +-
 net/ipv4/af_inet.c                                 |  10 +-
 net/ipv4/esp4_offload.c                            |   1 +
 net/ipv4/fib_trie.c                                |  14 +-
 net/ipv4/fou_core.c                                |  31 +-
 net/ipv4/igmp.c                                    |   2 +
 net/ipv4/inet_connection_sock.c                    |  29 +-
 net/ipv4/inet_hashtables.c                         |  11 +
 net/ipv4/inet_timewait_sock.c                      |   6 +-
 net/ipv4/ip_output.c                               |   8 +-
 net/ipv4/ip_tunnel.c                               |   6 +-
 net/ipv4/ipmr.c                                    | 104 +++---
 net/ipv4/netfilter/arp_tables.c                    |   5 +-
 net/ipv4/netfilter/ip_tables.c                     |   5 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |  12 +
 net/ipv4/raw.c                                     |  15 +-
 net/ipv4/route.c                                   |  36 ++-
 net/ipv4/tcp.c                                     |  16 +-
 net/ipv4/tcp_fastopen.c                            |   2 +
 net/ipv4/tcp_input.c                               |  80 ++++-
 net/ipv4/tcp_ipv4.c                                |  25 +-
 net/ipv4/tcp_metrics.c                             |   3 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/udp.c                                     |   5 +-
 net/ipv4/udp_offload.c                             |  10 +-
 net/ipv4/udp_tunnel_core.c                         |   6 +-
 net/ipv6/calipso.c                                 |  12 +-
 net/ipv6/esp6_offload.c                            |   1 +
 net/ipv6/exthdrs.c                                 |   5 +-
 net/ipv6/exthdrs_core.c                            |   7 +-
 net/ipv6/icmp.c                                    |   7 +-
 net/ipv6/ip6_fib.c                                 |  50 ++-
 net/ipv6/ip6_output.c                              |  13 +-
 net/ipv6/ip6mr.c                                   | 112 ++++---
 net/ipv6/mip6.c                                    |   9 +-
 net/ipv6/netfilter/ip6_tables.c                    |   5 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |  13 +
 net/ipv6/raw.c                                     |  15 +-
 net/ipv6/route.c                                   |  54 +++-
 net/ipv6/seg6_iptunnel.c                           |  46 ++-
 net/ipv6/seg6_local.c                              | 124 ++++++--
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/udp.c                                     |   5 +-
 net/iucv/af_iucv.c                                 |   9 +
 net/mac80211/airtime.c                             |   2 +
 net/mac80211/ibss.c                                |  27 +-
 net/mac80211/ieee80211_i.h                         |   3 +
 net/mac80211/link.c                                |  13 +-
 net/mac80211/mlme.c                                |  25 +-
 net/mac80211/ocb.c                                 |  23 +-
 net/mac80211/rx.c                                  |   7 +-
 net/mac80211/tx.c                                  |   6 +
 net/mctp/af_mctp.c                                 |   2 +-
 net/mptcp/options.c                                |  12 +-
 net/mptcp/protocol.c                               |   5 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  12 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_dup_netdev.c                      |   1 +
 net/netfilter/nf_flow_table_core.c                 |   1 +
 net/netfilter/nf_nat_masquerade.c                  |   4 +-
 net/netfilter/nf_queue.c                           |   1 +
 net/netfilter/nf_tables_api.c                      |  21 +-
 net/netfilter/nf_tables_offload.c                  |   3 +
 net/netfilter/nfnetlink_queue.c                    |  17 +-
 net/netfilter/nft_fwd_netdev.c                     |   1 +
 net/netfilter/nft_set_rbtree.c                     |   3 +-
 net/netfilter/xt_NETMAP.c                          |   4 +-
 net/netfilter/xt_recent.c                          |   7 +-
 net/netlink/af_netlink.c                           |   3 +-
 net/nsh/nsh.c                                      |   7 +
 net/openvswitch/flow.c                             |  19 +-
 net/rds/rdma.c                                     |   5 +-
 net/sched/act_ife.c                                |  13 +-
 net/sched/sch_teql.c                               |   9 +-
 net/sctp/sm_make_chunk.c                           |  43 +--
 net/sctp/sm_statefuns.c                            |  16 +-
 net/sctp/socket.c                                  |   2 +-
 net/sctp/stream.c                                  |   2 +
 net/sctp/stream_interleave.c                       |  38 +--
 net/smc/af_smc.c                                   |  21 +-
 net/smc/smc.h                                      |   1 +
 net/smc/smc_close.c                                |  14 +
 net/smc/smc_core.c                                 |  86 +++--
 net/smc/smc_core.h                                 |   6 +-
 net/smc/smc_diag.c                                 |  12 +-
 net/smc/smc_sysctl.c                               |   6 +-
 net/socket.c                                       |  11 +-
 net/sunrpc/clnt.c                                  | 108 +++++--
 net/sunrpc/rpc_pipe.c                              |   3 +-
 net/sunrpc/sunrpc.h                                |   8 +
 net/sunrpc/xprt.c                                  | 107 ++++++-
 net/sunrpc/xprtrdma/frwr_ops.c                     |  89 ++++--
 net/sunrpc/xprtrdma/transport.c                    |   2 +
 net/sunrpc/xprtrdma/verbs.c                        |  16 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |  10 +-
 net/sunrpc/xprtsock.c                              |   2 +-
 net/tipc/bearer.c                                  |  33 ++
 net/tls/tls_sw.c                                   |  93 ++++--
 net/unix/af_unix.c                                 |   1 +
 net/unix/garbage.c                                 |  31 +-
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/vmw_vsock/hyperv_transport.c                   |   3 +
 net/vmw_vsock/virtio_transport.c                   |  16 +-
 net/wireless/core.c                                |   2 +-
 net/wireless/scan.c                                |   3 +-
 net/wireless/util.c                                |   6 +-
 net/wireless/wext-core.c                           |  33 +-
 net/xdp/xsk.c                                      |  23 +-
 net/xfrm/xfrm_iptfs.c                              |   3 +-
 net/xfrm/xfrm_replay.c                             |   6 +-
 net/xfrm/xfrm_state.c                              |  98 +++++-
 net/xfrm/xfrm_user.c                               |  49 +--
 scripts/Makefile.autofdo                           |   2 +-
 security/keys/key.c                                |  10 +-
 security/keys/keyctl.c                             |   2 -
 security/keys/keyctl_pkey.c                        | 100 ++++--
 security/keys/keyring.c                            |  25 +-
 security/keys/request_key.c                        |  14 +-
 sound/core/memalloc.c                              |   2 +-
 sound/firewire/tascam/tascam-stream.c              |   4 +-
 sound/hda/codecs/cirrus/cs420x.c                   |   2 -
 sound/hda/codecs/realtek/alc269.c                  |  31 +-
 sound/hda/codecs/realtek/alc882.c                  |  10 +
 sound/hda/codecs/side-codecs/cs35l56_hda.c         |  14 +-
 sound/hda/codecs/side-codecs/tas2781_hda.c         |   4 +-
 sound/hda/common/sysfs.c                           |   5 +-
 sound/hda/core/controller.c                        |  15 +-
 sound/pci/Kconfig                                  |   1 +
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c      |  16 +-
 sound/soc/amd/ps/pci-ps.c                          |  32 +-
 sound/soc/apple/mca.c                              |  10 +-
 sound/soc/codecs/es9356.c                          |   4 +-
 sound/soc/codecs/lpass-rx-macro.c                  |   2 +-
 sound/soc/codecs/max98090.c                        |  22 +-
 sound/soc/codecs/tas2770.c                         |   9 +
 sound/soc/codecs/tas2770.h                         |   4 +-
 sound/soc/codecs/wm_adsp.c                         |  10 +
 sound/soc/meson/axg-fifo.c                         |  30 +-
 sound/soc/qcom/common.c                            |  61 +++-
 sound/soc/qcom/common.h                            |   3 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   3 +
 sound/soc/qcom/qdsp6/q6asm.c                       |   2 +
 sound/soc/qcom/x1e80100.c                          |  18 ++
 sound/soc/rockchip/Kconfig                         |   5 +
 sound/soc/soc-core.c                               |  16 +
 sound/soc/sof/amd/acp.c                            |  32 +-
 sound/soc/sof/ipc4-topology.c                      |   2 +-
 sound/usb/caiaq/device.c                           |  11 +-
 sound/usb/pcm.c                                    |   6 +
 tools/bootconfig/main.c                            |  29 +-
 tools/bootconfig/samples/exp-good-mixed-kv1.bconf  |   5 +
 tools/bootconfig/samples/good-mixed-kv1.bconf      |   5 +
 tools/bootconfig/test-bootconfig.sh                |  18 ++
 .../selftests/bpf/progs/verifier_live_stack.c      |  12 +-
 .../selftests/bpf/progs/verifier_may_goto_1.c      |   1 +
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |  18 ++
 .../ftrace/test.d/dynevent/fprobe_syntax_errors.tc |   4 +-
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |   2 +-
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |   2 +-
 tools/testing/selftests/mm/merge.c                 |  33 +-
 .../tcp_bidir_fast_retransmit_nosack.pkt           |  42 +++
 tools/testing/selftests/net/tls.c                  |   3 +
 868 files changed, 13410 insertions(+), 5629 deletions(-)


