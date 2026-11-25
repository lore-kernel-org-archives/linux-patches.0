Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620736;
	b=npapz+F6Vk4WU+J1GtRQYOq1LKBknyh4baF1qYTzaoWqKwDmWa7f/0sUZCQ8m4vMLNiu
	 9FVHB4BsmlHGiWJYVsKEwEU/Ucg+IxjFoClEU8qLSywWEVvXFCMLnZ1gus1FaxsIIIb7L
	 Uhqyl4Mq2u7RTpH4cZQKeCsITAY4oUNONkZ0160FT0Rbt6qjXpAC7Qz+JLQuhWnS30Avj
	 HYa4BLvXiTUhksCgs8H5RSmOaZur6zR6JmszooYlc0t8fXMdLy+zWTCDaIWlJjEdMb/Q6
	 pKVoIupB1VizdWt9706V/B/8CPHZUmlkHrk4cnlJK8+/yQBm3xG4lhEqhc33zL0kTRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=ginCRwqjodUPWJt+psZFPU3aj6j4jcww7oqv/iT+qc0=;
	b=1mWb+7taIfac1OuEFdAzUjlpwOgKz/kIlUjiY+EGOMs1/ThZOoNWca/WEz4qiT5O6Psp
	 2B+1Xbl22KHJnuAqwByF2vNmLeyb2ZWh2kQ7tNa71f8TOM60Iehow9AxGIRDFE39agFyh
	 DqLxu1lS9sO/8n/7+/PqTF9viciAyCtXq71VFZ1n1AK/O214jtSvw0A75DDIxGb7hYlty
	 hd+ICexH34DCQrRqWOIAOBPOJBrTZoZ3bzCL8ww/o3612swgDGjMLizzmCy/4F5Wm/Bkc
	 rP8cFqwaHeSSQFHFdG5rrVZqMamYaW1rzKSYKoKuB8f9FQ7hcm5OyiOFWIyZ9vrmd0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddNuxE0i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DEC606A31E;
	Wed, 25 Nov 2026 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddNuxE0i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A881F000C0;
	Wed, 25 Nov 2026 15:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620736;
	bh=ginCRwqjodUPWJt+psZFPU3aj6j4jcww7oqv/iT+qc0=;
	h=From:To:Cc:Subject:Date;
	b=ddNuxE0iB2Khq0rpN3KdZvCx7DV00XwrZWvmnYy3jRxaUX0kYDvEyDAMFvEjkgHja
	 fNAusvVftapT2VzeW98RkH2njZ672dnTkshoVdr/zAEg3OFRKoaK23IUzZ6fJlR46g
	 fka96kb2WDEsGJMrWZdQx05+cbTX0LWoR/LP/7is=
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
Subject: [PATCH 6.18 000/990] 6.18.66-rc1 review
Date: Wed, 25 Nov 2026 15:22:47 +0100
Message-ID: <20261125143822.072087159@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.66-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.66-rc1
X-KernelTest-Deadline: 2026-11-27T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.66 release.
There are 990 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 27 Nov 2026 14:36:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.66-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.66-rc1

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free if write is called after disconnect

Karl Mehltretter <kmehltretter@gmail.com>
    mtd: core: avoid double-free of OTP NVMEM device

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Set unhashed_state in inet_twsk_hashdance_schedule().

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: ensure packet data is writable before modifying SRH and IPv6 DA

Yuya Kusakabe <yuya.kusakabe@gmail.com>
    net: ipv6: keep room for the mac header in dst_dev_overhead()

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    xfrm: hold net_device reference under RCU in bundle creation

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix bugs caused by switchdev deletion errors

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Don't disable GuCRC in suspend path

Riana Tauro <riana.tauro@intel.com>
    drm/xe/xe_survivability: Remove unused index

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix EHT TX MCS limitation due to wrong 20 MHz-only parsing

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    perf: Fix null pointer access in is_include_guest_event()

Christian Brauner <brauner@kernel.org>
    9p: free the session after a grace period

Stefano Garzarella <sgarzare@redhat.com>
    9p: fix privport option setting wrong RDMA field

Pierre Barre <pierre@barre.sh>
    9p: fix access mode flags being ORed instead of replaced

Sasha Levin <sashal@kernel.org>
    9p: fix memory leak in v9fs_init_fs_context error path

Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
    powerpc/watchdog: disable watchdog when watchdog_thresh=0

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

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: proximity: sx9500: ignore event config writes that don't change state

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: proximity: sx9324: fix out-of-bounds read of scan period table

Viral Patel <viral8854@gmail.com>
    iio: magnetometer: tlv493d: fix magnetic field scale

Shashank Mohan Jain <jain.sm@gmail.com>
    iio: magnetometer: mmc35240: leave cache-only mode before the cache sync

Alexander Sarmanow <as@discnull.de>
    iio: light: vcnl4035: Fix reversed ALS mode bit

Jan Remes <jan.remes@mycroftmind.com>
    iio: light: tsl2591: don't divide by zero

Jiale Yao <yaojiale02@163.com>
    iio: imu: kmx61: reject duplicate event disable

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: imu: inv_mpu6050: fix swapped accel and gyro startup times

Arnav Kapoor <kapoorarnav43@gmail.com>
    iio: imu: inv_mpu6050: fix magnetometer scale of Y and Z axes

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix parsing of all FIFO frames for odr change

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

Xu Rao <raoxu@uniontech.com>
    usb: xhci: disable the correct slot on alloc_dev failure

Uttkarsh Aggarwal <uttkarsh.aggarwal@oss.qualcomm.com>
    usb: typec: ucsi: Set ucsi->connector before enabling notifications

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
    serial: samsung: put the previous baud clock

Josef Bacik <josef@toxicpanda.com>
    serial: samsung: don't leak the tty on an RX IRQ

Josef Bacik <josef@toxicpanda.com>
    serial: rda: free the interrupt on shutdown

Josef Bacik <josef@toxicpanda.com>
    serial: core: respect runtime PM when sending x_char

Josef Bacik <josef@toxicpanda.com>
    serial: 8250_lpss: don't divide by 0 above 6.25 Mbaud

Josef Bacik <josef@toxicpanda.com>
    misc: vmw_vmci: wait for callbacks in event unsubscribe

Jiale Yao <yaojiale02@163.com>
    misc: ibmvmc: initialize HMC state before device registration

Guangshuo Li <lgs201920130244@gmail.com>
    misc: bcm-vk: fix DMA allocation memory leak

Josef Bacik <josef@toxicpanda.com>
    iio: sx9310: use the data of the I2C table

Josef Bacik <josef@toxicpanda.com>
    iio: hid-sensors: fix a division by zero

Josef Bacik <josef@toxicpanda.com>
    iio: addac: ad74413r: fix the values of set_multiple

Josef Bacik <josef@toxicpanda.com>
    iio: adc: check the result of ad_sd_init()

Josef Bacik <josef@toxicpanda.com>
    iio: accel: adxl380: don't stay in standby on -EINVAL

Josef Bacik <josef@toxicpanda.com>
    comedi: vmk80xx: report failed transfers of the K8061

Josef Bacik <josef@toxicpanda.com>
    comedi: ni_tio: Fix overflow of the clock period

Josef Bacik <josef@toxicpanda.com>
    comedi: ni_660x: don't poll without a DMA channel

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

Edward Adam Davis <eadavis@sina.com>
    dm cache: reject kcopyd client destory if it setup failed

Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
    dm: Reject table setup after queue or disk teardown

Mark Bundschuh <mkbund@amazon.com>
    dm: fix infinite loop in dm_blk_do_report_zones()

Daejun Park <daejun7.park@samsung.com>
    dm: fail a REQ_PREFLUSH bio with data when its preflush fails

Yaohan Li <shunsheng1218@gmail.com>
    dm: avoid double-dropping the zone reset submission reference

shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>
    dm log userspace: drop the device reference on error

liuyong <pkfxxxing@gmail.com>
    smb: client: validate descriptor headers before query result allocation

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: skip NULL channel in __cifs_put_smb_ses()

Paulo Alcantara <pc@manguebit.org>
    smb: client: retry writes that couldn't be issued due to a reconnect

Paulo Alcantara <pc@manguebit.org>
    smb: client: issue writes from a worker if the task is dying

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: hold the inode across cifs_oplock_break()

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

Amir Goldstein <amir73il@gmail.com>
    ovl: do not allow nfs_export with data-only layers

Giuseppe Scrivano <giuseppe@scrivano.org>
    ovl: return EIO if the lowerdata is missing

Amir Goldstein <amir73il@gmail.com>
    ovl: report the requested redirect_dir mode in conflicting options

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    ovl: reject different lower idmaps on the same fs

Giuseppe Scrivano <giuseppe@scrivano.org>
    ovl: do not always clear absolute_redirect

Yu Zhang <yuz08559@gmail.com>
    gpio: virtuser: remove the debugfs files before freeing the line data

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: virtuser: fix interrupt leak and UAF

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: sodaville: fix use-after-free bug when registering the irqchip

Cunhao Lu <1579567540@qq.com>
    gpio: rockchip: Fix debounce arithmetic for GPIO v2

Guangshuo Li <lgs201920130244@gmail.com>
    gpio: brcmstb: fix UAF after IRQ domain setup failure

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Preserve the pending G7 interrupt status on control writes

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Clear only the acked line's G4 interrupt status

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

Mike Rapoport (Microsoft) <rppt@kernel.org>
    LoongArch: Restore KFENCE pages through DMW on resume

Jinjie Ruan <ruanjinjie@huawei.com>
    LoongArch: kexec_file: Fix elf_headers memory leak in retry loop

Jinjie Ruan <ruanjinjie@huawei.com>
    LoongArch: kexec_file: Fix a modified cmdline leak

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
    hwmon: (scmi) Check channel config allocation

Pablo Mazzini <pmazzini@gmail.com>
    hwmon: (sy7636a) fix negative temperatures

Felix Radensky <fradensky@nvidia.com>
    hwmon: (pmbus/mp2975) Get vout fault limits dynamically

Guenter Roeck <linux@roeck-us.net>
    hwmon: (gpio-fan) Fix runtime PM imbalance in probe and teardown

Rupesh Majhi <zoone.rupert@gmail.com>
    hwmon: (aht10) Fix update_interval overflow on 64-bit

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

Zhao Feng <zhaofeng2@cmss.chinamobile.com>
    watchdog: npcm: fix clock prepare leak when setting timeout on a running watchdog

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Track DMA mapping state

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

Hungyu Lin <dennylin0707@gmail.com>
    timekeeping: Read getboottime64() offsets under the sequence counter

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Fix TCP-with-TLS transport class identification

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    software node: only let the owner release a managed node

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Cache post-resolution target frequency in __resolve_freq()

Li Zhaoxin <lizhaoxin04@baidu.com>
    cpufreq: intel_pstate: Use rdmsrq_safe() to read MSR_MISC_PWR_MGMT

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Clear last written P-state value on suspend

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Improve suspend-resume synchronization

Li RongQing <lirongqing@baidu.com>
    cpufreq: acpi-cpufreq: fix P-state index mismatch in extract_io()

Mark Brown <broonie@kernel.org>
    arm64: suspend: Save GCS state over suspend

Mark Brown <broonie@kernel.org>
    arm64: suspend: Save POR_EL0 over suspend

Zhao Gongyi <zhaogongyi@bytedance.com>
    arm64: ptrace: don't warn on missing siginfo in a group-stop

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: kexec_file: Do not use CMA for images with a non-zero text_offset

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Add Cortex-A715/A720 AMU core counter workaround

Mark Brown <broonie@kernel.org>
    arm64/gcs: Ignore attempts to change GCS mode during signal return

Cheng Yongkang <teel4res@gmail.com>
    fs/splice: clamp an over-reported write_iter result

Cheng Yongkang <teel4res@gmail.com>
    fs/proc: fix the write length returned by proc_sys_call_handler()

HyeongJun An <sammiee5311@gmail.com>
    fs/adfs: bound directory entry name length in adfs_fplus_getnext()

Christian Brauner <brauner@kernel.org>
    dcache: let d_invalidate() wait for a d_set_mounted() in flight

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: essiv - fix use-after-free in AEAD path

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: caam - reject overlong RSA CRT parameters

Ridong Chen <chenridong@xiaomi.com>
    cgroup/cpuset: Don't revive invalid partition without active CPU on hotplug

Zhao Li <enderaoelyther@gmail.com>
    Bluetooth: L2CAP: Keep recvmsg from resuming a closed channel

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    Bluetooth: hci_qca: fix use-after-free in ibs debugfs files

Baoli Zhang <baoli.zhang@linux.intel.com>
    ASoC: SOF: ipc4-topology: Fix pin format leak in process widget setup

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Update last_busy in rpm_resume() for active devices

Paolo Bertinetti <paolobertinetti200f4@proton.me>
    perf/hw_breakpoint: Clear stop state in hw_breakpoint_add()

Phat Dinh <phatdt1116@gmail.com>
    perf/core: Do not resurrect cpuctx->cgrp after last cgroup event exit

Joas Antonio dos Santos <joasantonio108@gmail.com>
    openvswitch: advance by the real header length in get_ipv6_ext_hdrs()

Tim Menninger <tmenninger@everpuredata.com>
    NFSv4: Prevent indefinite waits for out-of-order OPEN stateids

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

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: only install push_pending_record for a TX context

Hungyu Lin <dennylin0707@gmail.com>
    tsacct: Keep task begin times stable across suspend

Jerome Mohm <jrmmhm.kernel@eldare.de>
    vsock/virtio: clear vqs[] to avoid a UAF on a failed PM restore

Rongzheng Wang <testwrzwrz@gmail.com>
    xsk: defer software checksum until the skb is complete

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    net: usb: lan78xx: let unregister_netdev() stop phylink

James Clark <jjc@jclark.com>
    net: stmmac: ptp: fix support for PTP_EXTTS_REQUEST2 ioctl

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

Jean-Paul Sergent <jpsergent@gmail.com>
    net: dst_metadata: fix memcmp overread in skb_metadata_dst_cmp

Hungyu Lin <dennylin0707@gmail.com>
    coda: honor the append state of each write

Mani Tofigh <mt4022@columbia.edu>
    btrfs: fix bio counter and bioc leak when async checksumming fails

Josef Bacik <josef@toxicpanda.com>
    mm/page_alloc: clear ->private of deferred free pages

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: snapshot the preferred zone against shrink rebuilds

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: detect zonelist rebuilds from memory hot-add

Josef Bacik <josef@toxicpanda.com>
    mm/page_alloc: keep the pagesets of an empty zone

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: don't undo another isolation in alloc_contig_range

Josef Bacik <josef@toxicpanda.com>
    mm/memory_hotplug: resize zones under their seqlock

Gregory Price (Meta) <gourry@gourry.net>
    mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()

Josef Bacik <josef@toxicpanda.com>
    mm: page_frag: refill the cache for large fragments

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

Sergei Nizovtsev <snizovtsev@cloudlinux.com>
    ALSA: caiaq: Kill EP1 URB before unregistering the input device

Zhiqi Zhang <zhiqizhangg@gmail.com>
    bootconfig: Allow keys with the maximum supported depth

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: Verify the key identity in __key_unlink_begin

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: Reject descriptions larger than KEY_MAX_DESC_SIZE

David Carlier <devnexen@gmail.com>
    tracing/eprobe: Install the trigger for every instance that enables the eprobe

Hao Li <hao.li@linux.dev>
    mm/slub: refill prefilled sheaves from the barn

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: avoid concurrent peer_del() in bt_6lowpan_disconnect

Nickolai Zeldovich <nickolai@csail.mit.edu>
    pidfs: do not report fields that do not fit into the caller's struct

Josef Bacik <josef@toxicpanda.com>
    blk-mq-dma: initialize the dma state for P2P, too

Jacob Keller <jacob.e.keller@intel.com>
    ice: use reference counting and SRCU for PTP port access

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Protect multiple routes insertion by table lock.

Chuck Lever <chuck.lever@oracle.com>
    tls: Honor O_NONBLOCK in tls_sw_splice_read()

Josef Bacik <josef@toxicpanda.com>
    block: don't enter reclaim under rq_qos_mutex

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return complete and aligned stream information

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: keep TX and RX hardware offload on the same device

Dudu Lu <phx0fer@gmail.com>
    net-sysfs: reject a one-entry RPS flow table

Junbin Zhang <sprooc69@gmail.com>
    sched_ext: Reject rq-lock-taking kfuncs in tracing programs

Denis Kulikov <dar1knessx@gmail.com>
    ksmbd: use the resolved share path for the share root

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Release invalid isolated CPUs with a shrunk root partition parent

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Release invalid isolated CPUs in compute_partition_effective_cpumask()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Prevent recursive call of remote_cpus_update() via update_cpumasks_hier()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Properly compute effective xcpus in update_parent_effective_cpumask()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Find furthest isolated ancestor for invalidated isolated partition

Pooyan Azad <pooyan.azadparvar@gmail.com>
    zram: fix short reads from block_state

Ian Rogers <irogers@google.com>
    perf lock contention: Filter events before creating lock_stat

Ajanesh Lal <ajaneshlal3@gmail.com>
    ALSA: hda/realtek: Add mute and mic-mute LEDs for HP ENVY 16 (103c:8be5)

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix durable reconnects for root shares

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: cache the resolved share path for durable reconnects

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: disconnect on invalid encryption transform flags

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: take bitmap_lock at the start of exfat_alloc_cluster()

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: fix used_clusters accounting during cluster allocation

Eric Dumazet <edumazet@kernel.org>
    ip6mr: clear skb->cb[] in reg_vif_xmit()

James Hilliard <james.hilliard1@gmail.com>
    xsk: freeze deferred pool teardown without blocking unregister

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Properly disabling partition when partition state switching fails

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Do housekeeping check before converting invalid partition to valid

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Consolidate isolated_cpus_can_update() into prstate_housekeeping_conflict()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    netfilter: flowtable: reset transport header after nf_flow_encap_pop()

Woojin Ji <random6.xyz@gmail.com>
    bpf: Zero-extend the index in inlined bpf_get_func_arg()

Sasha Levin <sashal@kernel.org>
    locking/atomic: arc, hexagon, openrisc: Define arch_cmpxchg_local()

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't take a dynptr argument for a local dynptr

Josef Bacik <josef@toxicpanda.com>
    bpf: Let bpf_dynptr_write() mark a global function

Josef Bacik <josef@toxicpanda.com>
    bpf: Free what map_free() unlinks for sleepable readers

Josef Bacik <josef@toxicpanda.com>
    bpf: Assume no bounds for a writable tp with tail calls

Josef Bacik <josef@toxicpanda.com>
    bpf: Assume no bounds for buffers behind a tail call

Josef Bacik <josef@toxicpanda.com>
    bpf: Count sleepable callbacks as sleepable map users

Josef Bacik <josef@toxicpanda.com>
    bpf: Keep a program until its bpf_wq callback has ended

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't hand out a linked element as extra element

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: make embedded sync follow the output carrier frequency

Ju Nan <junan76@163.com>
    pinctrl: stm32: Fix the unit of the hwspinlock timeout

Pengpeng Hou <hppiscas@163.com>
    irqchip/mst-intc: Validate the DT interrupt range

Kevin Dewald <kevin@simpleble.org>
    Bluetooth: hci_event: Fix LE link drop on remote features command status

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: fix PM flow for S0ix, S3 and S4

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: remove duplicate BTINTEL_PCIE_MAGIC_NUM definition

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Unpublish QP table before freeing it

Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
    RDMA/bnxt_re: Use kvzalloc for QP table allocation

Vikas Gupta <vikas.gupta@broadcom.com>
    bnge: skip dev_addr when building the VNIC unicast list

Jiale Yao <yaojiale02@163.com>
    wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: align real_num_tx_queues to mqprio configuration

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: set real_num_tx_queues to max(offset + count)

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Fix PM refcnt and autosuspend issues at device probe/remove

Kaifeng Wang <kaifengw@google.com>
    net: devmem: check uid and netns in net_devmem_get_binding()

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Preserve the LCPA I/O address space

Jacob Moroni <jmoroni@google.com>
    RDMA/core: Clear driver_udata before destroying objects in rdma_core

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq

Maksim Krasutski <krasutskimaksim@gmail.com>
    ALSA: hda/realtek: Fix mute LEDs on HP ENVY 17-cr1xxx

Dave Jiang <dave.jiang@intel.com>
    cxl/port: Attach endpoints to a dport under the lock that pins it

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-direct: Restore arch_dma_alloc() for the DMA_ATTR_NO_KERNEL_MAPPING case

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: reject zero RNR/MBSSID elements

Vineeth Karumanchi <vineeth.karumanchi@amd.com>
    net: macb: configure ENST registers for all queues

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Avoid a bad mixure of guard() and goto

Takashi Iwai <tiwai@suse.de>
    ALSA: pcmtest: Fix leak at probe error

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix TX coalesce race and div-by-zero in XDP/legacy path

Dmitry Morgun <d.morgun@ispras.ru>
    fs/ntfs3: check return values in indx_delete_entry()

Melissa Wen <mwen@igalia.com>
    drm/amd/display: declare amdgpu_dm_atomic_state_template as an event class

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7921: fix of_node reference leaks in regd update

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: free the WTBL index if a link allocation fails

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Recover coalesced cyclic callbacks

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix cyclic transfer residue

Qing Ming <a0yami@mailbox.org>
    dlm: validate node weights before building member array

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/a5xx: don't read the GPMU registers on GPUs without a GPMU

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Don't rb_erase() a never-inserted stream node

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Enforce physical block alignment of zoned writes

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Roll back freplace link state when bpf_arch_text_poke() fails

Lance Yang <lance.yang@linux.dev>
    mm/memory_hotplug: fix missing rollback in __add_pages()

Nathan Chancellor <nathan@kernel.org>
    serial: 8250_mid: Add missing module namespace import for SERIAL_8250

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix UAC2 mixer unit request handling

Ian Rogers <irogers@google.com>
    perf evsel: Clamp sample_id size for ksymbol, bpf, and text_poke events

Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    powerpc/interrupt: Use early_radix_enabled() in NMI real-mode guard

Abhishek Dubey <adubey@linux.ibm.com>
    powerpc/bpf: Move out dummy_tramp_addr after Long branch stub

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Serialize dcb_wq access against async notifier

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set QP event handler before firmware QPC insertion

Yishai Hadas <yishaih@nvidia.com>
    RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: fix readdir_r() with 64-bit directory offsets

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Rebase the exception callback subprog when dead subprogs are removed

Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
    arm64: dts: qcom: lemans-evk: fix SerDes PHY regulator supplies

Sudeep Holla <sudeep.holla@kernel.org>
    ACPI: PCC: Free channel on OpRegion deactivation

Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
    wifi: ath12k: fix out-of-bounds access on TX stats arrays

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix skb leak on monitor PPDU ID wraparound

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: free pending MSDUs on duplicate mon link descriptor

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-asus-vivobook-s15: Mark the EC reset gpio as reserved

Ian Rogers <irogers@google.com>
    perf machine: Add session back pointer to fix out of bounds read

Michael J. Ruhl <michael.j.ruhl@intel.com>
    platform/x86/intel/pmt: complete pcidev to device update

Joanne Koong <joannelkoong@gmail.com>
    fuse: zero the correct range on a short read reply

Hao Sun <sunhao.th@gmail.com>
    bpf: Fix uninit read for helper mem args on partially spilled slots

Hao Sun <sunhao.th@gmail.com>
    bpf: Fix uninit read for non-fetch atomics on partially spilled slots

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't converge a loop on an iterator that was created anew

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix overflow of jump offset in may_goto expansion

Alexei Starovoitov <ast@kernel.org>
    bpf: Adjust pc-relative insn copied into its own patch

Alexei Starovoitov <ast@kernel.org>
    bpf, x86: Fix timed may_goto with private stack

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: fix clk leak on error in audsys_clk_register

Puranjay Mohan <puranjay@kernel.org>
    bpf: Look at frame 0 when telling async callback entries apart

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check fastcall stack contract once for all stack accesses

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Preallocate hardware context schedulers

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: cs42l43: Move cancel_work_sync() into remove

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Keep target extended until its last freplace link detaches

Tate Whiteberg <whiteberg@arista.com>
    serial: 8250_mid: wait for LSR tx empty before setting termios

Tate Whiteberg <whiteberg@arista.com>
    serial: 8250: export and rename wait_for_xmitr()

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - hold cfg->lock when accessing config sections

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: unwind incomplete receive startup

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Process multiple IBIs per interrupt

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/connector: hdmi: Handle reset() state allocation failure

Ian Rogers <irogers@google.com>
    perf dso: Separate libbfd and cmd addr2line caches to fix confusion

Vitaliy Sochnev <sochnev.v.74@gmail.com>
    thermal/drivers/airoha: Request the EN7581 IRQ after zone registration

Guixin Liu <kanie@linux.alibaba.com>
    cxl/region: Unregister the pmem region when the bridge is unbound

Guixin Liu <kanie@linux.alibaba.com>
    cxl/cdat: Fix uninitialized stack use in bandwidth gathering

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix race between unmap and free BO

Pengpeng Hou <pengpeng@iscas.ac.cn>
    phy: samsung: usbdrd: propagate GS101 PIPE3 lock failures

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix unsafe use of handle_mm_fault()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Rearrange acpi_bind_one() to avoid breakage

Thomas Huth <thuth@redhat.com>
    crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data

Eric Dumazet <edumazet@google.com>
    sit: charge ip_tunnel_prl_entry allocations to memcg

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: preserve PPDU state across monitor status buffers

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Free sw_desc_pool on desc_pool_v alloc failure

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Fix PM rollback on sw_desc_pool alloc failure

Matt Turner <mattst88@gmail.com>
    perf thread: Fix live-session detection in thread__e_machine()

Dave Jiang <dave.jiang@intel.com>
    ACPI: APEI: GHES: Validate memory error section length before payload access

Jingbo Xu <jefflexu@linux.alibaba.com>
    fuse: don't bump attr_version for async direct read completion

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix unexpected wait when flushing notifier_wq

Davidlohr Bueso <dave@stgolabs.net>
    cxl/test: Map mock device nodes to an online node

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/panthor: Revisit reqs_lock handling in flush/reset paths

Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
    nvme-tcp: fix use-after-free in nvme_tcp_free_ctrl()

Guixin Liu <kanie@linux.alibaba.com>
    nvme-tcp: Validate the queue state under the queue lock in the address attribute

Salvatore Dipietro <dipiets@amazon.it>
    mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations

Josef Bacik <josef@toxicpanda.com>
    mm/userfaultfd: wake all waiters on unregister

Cunhao Lu <1579567540@qq.com>
    can: skb: make echo skb freeing safe in any IRQ context

Vidya Srinivas <vidya.srinivas@intel.com>
    drm/i915/display: Disable pipe joiner on WCL

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    inet: frags: prevent acceptance of partially authenticated reassembly

Kevin Wang <kevin.wang@amd.com>
    drm/amd/pm: preserve committed OD features for SMU 13.0.0/13.0.7

Ming Lei <tom.leiming@gmail.com>
    ublk: let STOP_DEV cancel the server's commands before its release

Jianping Li <jianping.li@oss.qualcomm.com>
    misc: fastrpc: Allocate entire reserved memory for Audio PD in probe

Abhishek Dubey <adubey@linux.ibm.com>
    powerpc/bpf: fix alignment of long branch trampoline address

Sean Young <sean@mess.org>
    media: rc: Add missing locking for keymap

Sean Young <sean@mess.org>
    media: rc: Replace open coded krealloc() for keymap

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Destroy a recalled delegation the client does not hold

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix folio is used after pte_unmap_unlock()

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Guard domain index uses against speculative bypass

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Explicitly use a card variable in _zcrypt_send_cprb

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix and improve zcrypt reply message verification checks

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Make apfs a real unsigned int field

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

Chuck Lever <chuck.lever@oracle.com>
    selftests: tls: Skip the zero_len tests when TLS is unavailable

Iustin Stolniceanu <iustin.stolniceanu@analog.com>
    net: phy: c45: select BASE-T1 type for the forced speed

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: IPsec, don't match upper proto selectors in crypto offload TX

Jiahao Xu <xujiahao@cmss.chinamobile.com>
    net: usb: cdc_ncm: don't underflow the NDP room check

Wenbo Sun <sunwenbo@cmss.chinamobile.com>
    amt: use ipv6_hdr() in amt_mldv1_leave_handler()

Wenbo Sun <sunwenbo@cmss.chinamobile.com>
    af_unix: Inherit SO_INQ in unix_stream_connect()

Jori Koolstra <jkoolstra@xs4all.nl>
    net: af_unix: useful handling of LSM denials on SCM_RIGHTS

Jori Koolstra <jkoolstra@xs4all.nl>
    net: scm: move scm_detach_fds() from common path to scm_recv_unix()

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().

Eric Dumazet <edumazet@kernel.org>
    net: virtio: fix UDP tunnel GSO header of VLAN tagged packets

Uri Dar <udar@nvidia.com>
    net/mlx5: Lag, Return error when enabling MPESW without LAG support

Antonio Quartulli <antonio@mandelbit.com>
    udp_tunnel: don't treat IPv4 sockets bound to an address as wildcard

Junyoung Jang <graypanda.inzag@gmail.com>
    igmp: use the joined device when leaving a multicast group

Gustavo Sousa <gustavo.sousa@intel.com>
    drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/wa_oob: Consolidate some OOB rules

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/pvc: Drop pre-prod workarounds

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Add a wrapper for SLPC set/unset params

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Decouple GuC RC code from xe_guc_pc

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/guc_pc: Use scope-based cleanup

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/forcewake: Add scope-based cleanup for forcewake

Sk Anirban <sk.anirban@intel.com>
    drm/xe/guc: Eliminate RPe caching for SLPC parameter handling

Shekhar Chauhan <shekhar.chauhan@intel.com>
    drm/xe/xe3: Add support for graphics IP versions 30.04 & 30.05

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

LiangCheng Wang <zaq14760@gmail.com>
    ASoC: max98090: keep the MIC boost across mic input power-up

Kavitha Daula <kavi@edera.dev>
    xen/grant-table: annotate on-stack work in gnttab_unmap_refs_sync()

Pengpeng Hou <hppiscas@163.com>
    drm/bridge: sii902x: validate I2S data lane values

Kyle Zeng <kylebot@openai.com>
    udp: check frag_list IP family before using skb_segment_list()

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

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Serialize TC and IPsec offload exclusion counters

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Fix ipsec core device access during profile changes

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

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Add logic to track PMD state via MAC/PCS signals

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Rename PCS IRQ to MAC IRQ as it is actually a MAC interrupt

Umang Pokhriyal <umangpokhriyall@gmail.com>
    tun: delete the flow entries of the moved queue on detach

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4: wake blocking lock waiters when a delegated lock is released

Eric Dumazet <edumazet@kernel.org>
    bonding: fix slave_cnt leak on XDP enslave failure

Denis V. Lunev <den@openvz.org>
    ovl: release the upperdir/workdir in-use locks before the umount sync

Christian Brauner <brauner@kernel.org>
    ovl: allow idmapping overlay mounts

Tianyi Gao <tianyi@cloudflare.com>
    net: fix mac_len of skbs copied by generic XDP

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: mac80211: abort chanswitch when leaving an IBSS

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: don't linearize SKBs unnecessarily

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

Li RongQing <lirongqing@baidu.com>
    team: fix promisc/allmulti leak in team_port_add error path

Nikola Z. Ivanov <zlatistiv@gmail.com>
    team: Add matching error label for failed action

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
    SUNRPC: wake poll waiters when an empty pipe is unlinked

Avi Weiss <thnkslprpt@gmail.com>
    NFS: restore directory index when resuming readdir

Avi Weiss <thnkslprpt@gmail.com>
    NFS: Fix inverted cross-directory rename check

Avi Weiss <thnkslprpt@gmail.com>
    NFS: update ctime for atime-only UTIME_NOW requests

Jeff Layton <jlayton@kernel.org>
    nfs: fix utimensat() for atime with delegated timestamps

Avi Weiss <thnkslprpt@gmail.com>
    NFS: honor UTIME_NOW atime with explicit mtime

Avi Weiss <thnkslprpt@gmail.com>
    NFSv4.1: retain MDS I/O until both thresholds are met

Eric Dumazet <edumazet@kernel.org>
    tcp: rate limit receive queue collapsing

Eric Dumazet <edumazet@google.com>
    tcp: move tp->bytes_acked to tcp_sock_write_tx group

Eric Dumazet <edumazet@google.com>
    tcp: move tp->first_tx_mstamp and tp->delivered_mstamp to tcp_sock_write_tx

Eric Dumazet <edumazet@google.com>
    tcp: move tp->segs_in and tp->segs_out to tcp_sock_write_txrx group

Eric Dumazet <edumazet@google.com>
    tcp: move tp->delivered and tp->delivered_ce to tcp_sock_write_tx group

Ilpo Järvinen <ij@kernel.org>
    tcp: try to avoid safer when ACKs are thinned

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

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: guard adata->sdw dereferences with NULL check in IRQ handler

Tyler Baker <tyler.baker@oss.qualcomm.com>
    ASoC: qcom: x1e80100: recreate the headset jack on card rebind

Hongyang Zhao <hongyang.zhao@thundersoft.com>
    ASoC: qcom: common: Add generic headset jack helpers

Prasad Kumpatla <prasad.kumpatla@oss.qualcomm.com>
    ASoC: qcom: common: add DAI-node TDM slot helpers

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: common: validate cpu dai id during parsing

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: dt-bindings: qcom: add LPASS LPI MI2S dai ids

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: sdw: remove redundant code

Tyler Baker <tyler.baker@oss.qualcomm.com>
    ASoC: soc-core: copy the DAI link names into the card

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: return -ENOENT from of_gpio_count() stub

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: fix fast-path cancellation in gpiod_get_array()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: fix GPIO descriptor leak in gpiod_get_array()

Badal Nilawar <badal.nilawar@intel.com>
    drm/xe/xe_late_bind_fw: Fix firmware leak on missing manifest entry

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Toggle the D3Cold enable flag at runtime resume

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe: Rebind BOs evicted before the first LR queue

Raag Jadav <raag.jadav@intel.com>
    drm/xe/hw_error: Guard csc_hw_error_work() with runtime PM

Mallesh Koujalagi <mallesh.koujalagi@intel.com>
    drm/xe/xe_survivability: Simplify runtime survivability error handling

Riana Tauro <riana.tauro@intel.com>
    drm/xe/xe_survivability: Redesign survivability mode

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Fix build with DRM_XE=y and CONFIGFS_FS=m

Helen Koike <koike@igalia.com>
    drm/xe/lrc: Restore CTX_CS_INDIRECT_CTX_OFFSET programming for pre-Xe2

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe/tuning: Restrict Anyhit NULL-query tuning to render engines

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe: Prevent VF memory IRQ from accessing a torn-down engine

Greg Thelen <gthelen@google.com>
    kho: check fdt_phys in is_kho_boot()

Pasha Tatashin <pasha.tatashin@soleen.com>
    liveupdate: kho: move to kernel/liveupdate

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

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Return -EOPNOTSUPP if no policy supports boost

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

Thomas Fourier <fourier.thomas@gmail.com>
    net/mlx5e: TC, Fix double free of branch in failure

Ridge Lomont <cyridge@proton.me>
    x86/kcfi: Don't emit KCFI_REFERENCE() in modules

Eric Dumazet <edumazet@kernel.org>
    tcp: bound snd_cwnd_clamp to TCP_MAX_SND_CWND

Hui Su <sh_def@163.com>
    sched/topology: Balance cluster static-key updates

Hui Su <sh_def@163.com>
    sched/pelt: Fix u32 truncation of the PELT period count

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR

Kan Liang <kan.liang@linux.intel.com>
    perf: Add sampling support for SIMD registers

Kan Liang <kan.liang@linux.intel.com>
    perf: Move and enhance has_extended_regs() for arch-specific use

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf: Eliminate duplicate arch-specific function definitions

Kan Liang <kan.liang@linux.intel.com>
    perf: Add APIs to create/release mediated guest vPMUs

James Clark <james.clark@linaro.org>
    perf: Add perf_event_attr::config4

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

Al Viro <viro@zeniv.linux.org.uk>
    introduce a flag for explicitly marking persistently pinned dentries

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: SB1250: Validate and update IRQ affinity

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Cobalt: Include legacy IDE ports in the PCI I/O window

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Alchemy: Save the Ethernet address before reusing PROM memory

Imre Kaloz <kaloz@kernel.org>
    MIPS: SGI-IP30: fix the defconfig defaults for the Bridge PROM and RTC

Rosen Penev <rosenp@gmail.com>
    MIPS: Avoid dead code/data elimination when using recordmcount

Eric Dumazet <edumazet@kernel.org>
    tcp: ipv6: free ireq->ipv6_opt after an RCU grace period

Long Zhao <longzhao@ambarella.com>
    gpio: regmap: free the irqchip if adding the irq domain fails

Linus Walleij <linusw@kernel.org>
    gpio: regmap: Support sparsed fixed direction

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

Jakub Kicinski <kuba@kernel.org>
    net: bonding: don't recurse on the slave's netdev ops lock

Jakub Kicinski <kuba@kernel.org>
    net: ethtool: add netif_get_link_ksettings() for correct ops-locked use

Kyle Zeng <kylebot@openai.com>
    ip6mr: Serialize multicast router socket ownership

Timur Stukan <timur.stukan.linux@gmail.com>
    bonding: 3ad: don't set BOND_LINK_FAIL on a slave that is not up

Colton Pawielski <colton.pawielski@gmail.com>
    net: 8139cp: keep Rx masked while NAPI is scheduled

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Stop cs_dsp before calling cs_dsp_power_down()

Michał Kopeć <michal.kopec@3mdeb.com>
    ALSA: hda/core: Stop capability walk on empty capability header

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

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/pm: track BACO state in the SMU v11 ArmD3 sequence

Eric Dumazet <edumazet@kernel.org>
    tcp: ipv6: do not read ireq->pktopts from tcp_v6_send_synack()

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().

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

James Clark <jjc@jclark.com>
    net: ethernet: ti: am65-cpts: adjust perout genf following ptp changes

Jude Gyimah <jude.gyimah87@gmail.com>
    ASoC: rockchip_spdif: select REGMAP_MMIO

Sugar Zhang <sugar.zhang@rock-chips.com>
    ASoC: rockchip: spdif: Fill IEC958 CS info per params

Sugar Zhang <sugar.zhang@rock-chips.com>
    ASoC: rockchip: spdif: Add support for format S32_LE

Sugar Zhang <sugar.zhang@rock-chips.com>
    ASoC: rockchip: spdif: Add support for set mclk rate

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

Hannes Reinecke <hare@kernel.org>
    nvmet-auth: Do not print DH-HMAC-CHAP secrets

Chris Leech <cleech@redhat.com>
    nvme-auth: Hash DH shared secret to create session key

Eric Biggers <ebiggers@kernel.org>
    nvme-auth: common: use crypto library in nvme_auth_augmented_challenge()

Eric Biggers <ebiggers@kernel.org>
    nvme-auth: common: add HMAC helper functions

Eric Biggers <ebiggers@kernel.org>
    nvme-auth: common: add KUnit tests for TLS key derivation

Eric Biggers <ebiggers@kernel.org>
    nvme-auth: use proper argument types

Eric Biggers <ebiggers@kernel.org>
    nvme-auth: add NVME_AUTH_MAX_DIGEST_SIZE constant

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: ask for the TLS record type on every receive

Josef Bacik <josef@toxicpanda.com>
    nvme-loop: delete the controller if a reset fails

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-loop: do not alloc admin tag set during reset

Alexander Goodkind <alex@goodkind.io>
    net: ethernet: mediatek: preserve sibling PPE bindings

Florian Fainelli <florian.fainelli@broadcom.com>
    net: dsa: b53: Enable IGMP and MLD control packet CPU copies

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

Yu Kuai <yukuai@fnnas.com>
    blk-mq: add a new queue sysfs attribute async_depth

Yu Kuai <yukuai@fnnas.com>
    block: convert nr_requests to unsigned int

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

Jason Wang <jasowang@redhat.com>
    virtio_ring: factor out split indirect detaching logic

zhangdongchuan@eswincomputing.com <zhangdongchuan@eswincomputing.com>
    virtio_ring: code cleanup in detach_buf_split

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

Aaditya Kansal <aadityakansal390@gmail.com>
    ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH in smb server

Bart Van Assche <bvanassche@acm.org>
    mctp i3c: Fix locking in an error path

Danish Khateeb <danishkhateeb03@gmail.com>
    selftests/mm: merge: keep the far mremap() targets in the carveout

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

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: request the irq with the clock enabled

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: don't advertise EHT-MCS15 to firmware unless we support it

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: ath12k: Add EHT MCS/NSS rates to Peer Assoc

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: ath12k: add EHT rate handling to existing set rate functions

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: ath12k: generalize GI and LTF fixed rate functions

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

Karl Mehltretter <kmehltretter@gmail.com>
    virtio-spi: Fix virtio_spi_config kernel-doc

Alex Austin <alex.austin@amd.com>
    sfc: ptp: avoid racing PPS timestamp updates

Alex Austin <alex.austin@amd.com>
    sfc: ptp: serialize host and MC synchronization transactions

Alex Austin <alex.austin@amd.com>
    sfc: ptp: drop the stale frequency reset in efx_ptp_start()

Vladimir Zapolskiy <vz@kernel.org>
    drm/panel: visionox-r66451: Wait longer after the panel reset

Vladimir Zapolskiy <vz@kernel.org>
    drm/panel: visionox-r66451: Send the brightness value MSB first

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

Vlad Poenaru <vlad.wing@gmail.com>
    bnxt_en: Don't keep MSI-X vectors added before FW reserves them

Joas Antonio dos Santos <joasantonio108@gmail.com>
    net/mlx5: macsec: free struct mlx5_fs_id after an RCU grace period

Yuqiang Sun <izaiahsun@gmail.com>
    bpf: lwt: Free the skb when bpf_xmit() fails to expand the headroom

Rosen Penev <rosenp@gmail.com>
    spi: acpi: only look up the IRQ of confirmed SPI devices

Alban Bedel <alban.bedel@lht.dlh.de>
    spi: Fix ACPI SPI resources using relative path

Chris Mason <mason@kernel.org>
    bpf: Check the offset in bpf_skb_generic_{push,pop}()

Chris Mason <mason@kernel.org>
    bpf: Move the transport header with the moved headers

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
    bpf: Refuse to map an arena at address 0

Alexei Starovoitov <ast@kernel.org>
    bpf: Clamp the trace length before the skip test in stackid_init()

Jiri Olsa <jolsa@kernel.org>
    bpf: Avoid changing callchain in bpf_get_stackid_pe

Josef Bacik <josef@toxicpanda.com>
    bpf: Clamp the trace length in __bpf_get_stack() again

Jiri Olsa <jolsa@kernel.org>
    bpf: Avoid changing callchain in bpf_get_stack_pe

Hongjian Dai <daihongjian@kylinsec.com.cn>
    spi: pic32-sqi: fail transfer when the BD ring is exhausted

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_reject: prevent unbounded recursion in output hooks

Sasha Levin <sashal@kernel.org>
    ALSA: memalloc: Free the new pages when WC DMA mapping fails

Thomas Fourier <fourier.thomas@gmail.com>
    net: ipa: Fix double free of the interrupt structure on config error

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: reject attaching bearer of different media to the same occupied device

Jia Jia <physicalmtea@gmail.com>
    scsi: target: Validate REGISTER AND MOVE TransportID length

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
    btrfs: fix fiemap merging compressed extents

guolingxing <guolingxing@tju.edu.cn>
    btrfs: verity: propagate orphan insertion errors when enabling verity

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    bpf: Fix jited line info off by the CFI preamble

Avi Weiss <thnkslprpt@gmail.com>
    gpio: omap: Propagate runtime PM failures in probe and request

Michal Wilczynski <m.wilczynski@samsung.com>
    drm/imagination: Align rogue_fwif_hwrtdata to 64 bytes

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix transport header for inner IPv4 with IP options

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: fix IRQ disable imbalance in AHB ext interrupt handler

Filippo Falezza <effeffe99@gmail.com>
    wifi: ath10k: Stop unanswered temperature reads

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: do not store the create fid on special files

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: fall back to the normal open path for non-regular files

Omokefe Emmanuel Onanaroghene <emmaonana18@gmail.com>
    9p: fix kernel-doc warning for enum p9_session_flags

Remi Pommarel <repk@triplefau.lt>
    9p: Add mount option for negative dentry cache retention

Remi Pommarel <repk@triplefau.lt>
    9p: Cache negative dentries for lookup performance

Barret Rhoden <brho@google.com>
    9p: treat read return values of 0 as EOF

Remi Pommarel <repk@triplefau.lt>
    9p: Enable symlink caching in page cache

Matthew Whitehead <tedheadster@gmail.com>
    scsi: aha1542: Remove unneeded scsi_dma_unmap() call

Giuseppe Piscitelli <ooonea@gmail.com>
    scsi: scsi_debug: Drain target cleanup before module exit

Imre Kaloz <kaloz@kernel.org>
    scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: ath9k_htc: start ANI when an AP interface begins to beacon

Avi Weiss <thnkslprpt@gmail.com>
    fsnotify: preserve 64-bit pre-content ranges

Cosmin Ratiu <cratiu@nvidia.com>
    wifi: wext: Limit notifier event flushes to the device's netns

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

David Laight <david.laight.linux@gmail.com>
    net/9p: Replace strlen() strcpy() pair with strscpy()

Eric Sandeen <sandeen@redhat.com>
    9p: convert to the new mount API

Eric Sandeen <sandeen@redhat.com>
    9p: create a v9fs_context structure to hold parsed options

Eric Sandeen <sandeen@redhat.com>
    net/9p: move structures and macros to header files

Eric Sandeen <sandeen@redhat.com>
    fs/fs_parse: add back fsparam_u32hex

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: usb: Avoid crash with dynamically added device ID

Feng Ning <feng@innora.ai>
    staging: media: atomisp: use array3_size() for overflow-safe allocation

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: destroy force-feedback device on input unregistration

Bernard Pidoux <bernard.f6bvp@gmail.com>
    bpqether: keep a bpq device in step with its Ethernet device

Bernard Pidoux <bernard.f6bvp@gmail.com>
    bpqether: set both addresses or none in SIOCSBPQETHADDR

Bernard Pidoux <bernard.f6bvp@gmail.com>
    bpqether: reserve the Ethernet device's own header room on transmit

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

Jan Kara <jack@suse.cz>
    udf: validate VAT inode size for old VAT format

Lance Yang <lance.yang@linux.dev>
    mm/ksm: fix userfaultfd protection during merge and unmerge

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: give the sysctl timer limits in milliseconds

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: keep T1 running after answering a NAK

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: end a REJ recovery count once frames are acknowledged

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: reset a call when a DATA packet arrives out of sequence

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: drop a message being reassembled when a new one starts

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: send the unacknowledged frames again when T1 or T4 expires

Sasha Levin <sashal@kernel.org>
    Revert "drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts"

Melbin K Mathew <mlbnkm1@gmail.com>
    fbdev: serialize mode sysfs access with lock_fb_info()

Melbin K Mathew <mlbnkm1@gmail.com>
    fbdev: clear fb_info->mode before deleting a videomode

Melbin K Mathew <mlbnkm1@gmail.com>
    fbdev: bound mode sysfs output to the sysfs buffer

Long Li <leo.lilong@huawei.com>
    xfs: only assert new size for datafork during truncate extents

Gabriele Monaco <gmonaco@redhat.com>
    sched/deadline: Fix server stopping with runnable tasks

Peter Zijlstra <peterz@infradead.org>
    sched: Provide idle_rq() helper

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Fix dl_server stop condition

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Fix dl_server time accounting

Antheas Kapenekakis <lkml@antheas.dev>
    ALSA: hda/tas2781: Prevent throwing away custom calibration addresses

Vladimir Petrzhikovskii <vladimir@dfb.sh>
    virtio_net: check RX buffer length before DMA sync

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: platform: Use acpi_bus_get_primary_device()

Zizhi Wo <wozizhi@huawei.com>
    fs: aio: reject partial mremap to avoid Null-pointer-dereference error

Krittikun Wongnin <krittikunwongnin@gmail.com>
    ACPI: PM: Add Acer Aspire A515-53G to dmi_leave_unused_power_resources_on[]

Hakan Abay <hakan.abay84@gmail.com>
    ACPI: PM: Add unused power resource quirk for Casper Excalibur G900

Matthias Dittrich <dittrich.m@gmx.net>
    ACPI: PM: Add quirk for Acer Swift 3 SF314-56G (MX250)

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Enable Bus Lock VM exit

Baokun Li <libaokun@linux.alibaba.com>
    writeback: use a per-sb counter to drain inode wb switches at umount

Ilya Dryomov <idryomov@gmail.com>
    libceph: adapt ceph_x_challenge_blob hashing and msgr1 message signing

Ilya Dryomov <idryomov@gmail.com>
    libceph: add support for CEPH_CRYPTO_AES256KRB5

Ilya Dryomov <idryomov@gmail.com>
    libceph: introduce ceph_crypto_key_prepare()

Ilya Dryomov <idryomov@gmail.com>
    libceph: generalize ceph_x_encrypt_offset() and ceph_x_encrypt_buflen()

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

Eric Dumazet <edumazet@kernel.org>
    net: always dissect GSO packets in __virtio_net_hdr_to_skb()

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Pengpeng Hou <hppiscas@163.com>
    irqchip/sifive-plic: Avoid signed shift in interrupt enable mask

KP Singh <kpsingh@kernel.org>
    bpf: Reject NULL data/sig in bpf_verify_pkcs7_signature

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: move custom expectation support to helper

Florian Westphal <fw@strlen.de>
    netfilter: nft_ct: expectation timeouts are passed in milliseconds


-------------

Diffstat:

 Documentation/arch/arm64/gcs.rst                   |  13 +-
 Documentation/arch/arm64/silicon-errata.rst        |   4 +
 Documentation/block/ublk.rst                       |   7 +
 Documentation/core-api/kho/concepts.rst            |   2 +-
 .../bindings/iio/adc/aspeed,ast2600-adc.yaml       |  17 +
 .../bindings/sound/qcom,q6dsp-lpass-ports.yaml     |   5 +-
 Documentation/filesystems/9p.rst                   |   7 +-
 Documentation/gpu/xe/xe_firmware.rst               |   3 +
 .../networking/net_cachelines/tcp_sock.rst         |  12 +-
 Documentation/networking/tls-offload.rst           |  16 +-
 Documentation/trace/kprobes.rst                    |   2 +-
 MAINTAINERS                                        |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/include/uapi/asm/socket.h               |   2 +
 arch/arc/include/asm/cmpxchg.h                     |   4 +
 arch/arm/kernel/perf_regs.c                        |   6 -
 arch/arm64/Kconfig                                 |  32 ++
 arch/arm64/boot/dts/qcom/lemans-evk.dts            |   3 +-
 .../boot/dts/qcom/x1e80100-asus-vivobook-s15.dts   |   1 +
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |  20 +
 arch/arm64/kernel/cpufeature.c                     |   3 +-
 arch/arm64/kernel/kexec_image.c                    |   7 +
 arch/arm64/kernel/perf_regs.c                      |   6 -
 arch/arm64/kernel/ptrace.c                         |   8 +-
 arch/arm64/kernel/signal.c                         |  22 +-
 arch/arm64/kernel/topology.c                       |   3 +-
 arch/arm64/mm/proc.S                               |  20 +
 arch/arm64/tools/cpucaps                           |   1 +
 arch/csky/kernel/perf_regs.c                       |   6 -
 arch/hexagon/include/asm/cmpxchg.h                 |   6 +
 arch/loongarch/kernel/machine_kexec.c              |   2 +
 arch/loongarch/kernel/machine_kexec_file.c         |   4 +
 arch/loongarch/kernel/perf_regs.c                  |   6 -
 arch/loongarch/kvm/intc/pch_pic.c                  |  17 +-
 arch/loongarch/power/hibernate.c                   |   6 +
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/alchemy/common/prom.c                    |  23 +-
 arch/mips/cobalt/pci.c                             |  11 +-
 arch/mips/cobalt/setup.c                           |   4 +-
 arch/mips/configs/ip30_defconfig                   |   9 +-
 arch/mips/include/asm/mach-cobalt/cobalt.h         |   1 +
 arch/mips/include/uapi/asm/socket.h                |   2 +
 arch/mips/kernel/perf_regs.c                       |   6 -
 arch/mips/sibyte/sb1250/irq.c                      |   3 +
 arch/openrisc/include/asm/cmpxchg.h                |   2 +
 arch/parisc/include/uapi/asm/socket.h              |   2 +
 arch/parisc/kernel/perf_regs.c                     |   6 -
 arch/powerpc/include/asm/interrupt.h               |   5 +-
 arch/powerpc/kernel/watchdog.c                     |   3 +
 arch/powerpc/net/bpf_jit.h                         |   7 +-
 arch/powerpc/net/bpf_jit_comp.c                    |  62 ++-
 arch/powerpc/net/bpf_jit_comp32.c                  |   7 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |   7 +-
 arch/riscv/kernel/perf_regs.c                      |   6 -
 arch/sparc/include/uapi/asm/socket.h               |   2 +
 arch/um/drivers/vector_transports.c                |   1 +
 arch/x86/events/amd/ibs.c                          |  50 ++
 arch/x86/events/amd/uncore.c                       |   2 +-
 arch/x86/kernel/cpu/amd.c                          |   3 +-
 arch/x86/kernel/ldt.c                              |  12 +-
 arch/x86/kernel/perf_regs.c                        |   6 -
 arch/x86/kvm/Kconfig                               |   1 +
 arch/x86/kvm/vmx/tdx.c                             |  24 +-
 arch/x86/net/bpf_jit_comp.c                        |  12 +
 arch/x86/net/bpf_timed_may_goto.S                  |  10 +-
 arch/x86/video/video-common.c                      |   2 +-
 block/blk-cgroup.c                                 |  13 +-
 block/blk-core.c                                   |   1 +
 block/blk-iocost.c                                 |   5 +-
 block/blk-iolatency.c                              |   3 +-
 block/blk-mq-dma.c                                 |   2 +
 block/blk-mq-sched.c                               |   6 +-
 block/blk-mq.c                                     |   9 +
 block/blk-sysfs.c                                  |  42 ++
 block/blk-throttle.c                               |   3 +-
 block/elevator.c                                   |   1 +
 block/genhd.c                                      |   2 +-
 block/partitions/efi.c                             |   1 +
 crypto/essiv.c                                     |   2 +-
 drivers/accel/amdxdna/aie2_ctx.c                   | 117 ++--
 drivers/accel/amdxdna/aie2_pci.c                   |   9 +-
 drivers/accel/amdxdna/aie2_pci.h                   |   6 +-
 drivers/accel/amdxdna/amdxdna_gem.c                | 225 +++++---
 drivers/accel/amdxdna/amdxdna_gem.h                |   2 +-
 drivers/accel/ivpu/ivpu_pm.c                       |   9 +-
 drivers/acpi/acpi_pcc.c                            |  13 +
 drivers/acpi/acpi_platform.c                       |  16 +-
 drivers/acpi/apei/ghes.c                           |  41 ++
 drivers/acpi/glue.c                                |  58 +-
 drivers/acpi/power.c                               |  38 ++
 drivers/acpi/scan.c                                | 108 +++-
 drivers/ata/libata-core.c                          |   8 +-
 drivers/ata/libata-eh.c                            |  16 +-
 drivers/ata/libata-sata.c                          |   2 +-
 drivers/ata/libata-scsi.c                          | 178 ++++---
 drivers/base/power/runtime.c                       |   8 +-
 drivers/base/swnode.c                              |   7 +-
 drivers/block/null_blk/zoned.c                     |  48 +-
 drivers/block/ublk_drv.c                           | 105 +++-
 drivers/block/virtio_blk.c                         |  69 ++-
 drivers/block/zloop.c                              |   5 +-
 drivers/block/zram/zram_drv.c                      | 115 ++--
 drivers/bluetooth/btintel.c                        |  24 +-
 drivers/bluetooth/btintel_pcie.c                   |  47 +-
 drivers/bluetooth/btintel_pcie.h                   |   2 -
 drivers/bluetooth/btmtk.c                          |  49 +-
 drivers/bluetooth/btqca.c                          |   1 +
 drivers/bluetooth/hci_qca.c                        |   5 +
 drivers/char/tpm/eventlog/acpi.c                   |   4 +-
 drivers/char/tpm/eventlog/tpm1.c                   |   7 +
 drivers/char/tpm/tpm-dev-common.c                  |  12 +-
 drivers/char/tpm/tpm2-sessions.c                   |   4 +-
 drivers/comedi/drivers/addi_apci_1500.c            |   2 +-
 drivers/comedi/drivers/ni_660x.c                   |   3 +-
 drivers/comedi/drivers/ni_tio.c                    |   2 +-
 drivers/comedi/drivers/vmk80xx.c                   |  25 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   9 +-
 drivers/cpufreq/cpufreq.c                          | 110 +++-
 drivers/cpufreq/intel_pstate.c                     |  18 +-
 drivers/crypto/caam/caampkc.c                      |  75 ++-
 drivers/crypto/inside-secure/safexcel_hash.c       |   3 +
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |  49 +-
 drivers/cxl/core/cdat.c                            |   8 +-
 drivers/cxl/core/port.c                            | 121 +++--
 drivers/cxl/core/region.c                          |   6 +-
 drivers/dma/ste_dma40.c                            | 179 ++++++-
 drivers/dma/ste_dma40_ll.c                         |   8 +-
 drivers/dma/ste_dma40_ll.h                         |   2 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |  19 +-
 drivers/dpll/dpll_core.c                           |   3 +-
 drivers/dpll/zl3073x/dpll.c                        |  56 +-
 drivers/dpll/zl3073x/out.h                         |  40 ++
 drivers/firmware/cirrus/cs_dsp.c                   |   6 +
 drivers/gpio/gpio-aspeed.c                         |  19 +-
 drivers/gpio/gpio-brcmstb.c                        |   1 +
 drivers/gpio/gpio-mpc8xxx.c                        |  22 +-
 drivers/gpio/gpio-mpsse.c                          |   4 +
 drivers/gpio/gpio-omap.c                           |  13 +-
 drivers/gpio/gpio-regmap.c                         |  42 +-
 drivers/gpio/gpio-rockchip.c                       |  15 +-
 drivers/gpio/gpio-sodaville.c                      |   9 +-
 drivers/gpio/gpio-virtuser.c                       |  85 ++-
 drivers/gpio/gpiolib-of.h                          |   2 +-
 drivers/gpio/gpiolib.c                             |  35 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h    |  56 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |  20 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   | 193 +++++--
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   | 193 +++++--
 drivers/gpu/drm/bridge/sii902x.c                   |   8 +-
 drivers/gpu/drm/drm_connector.c                    |   5 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +-
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h       |   2 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  49 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   7 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c   |  13 +
 .../gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c    |  20 -
 drivers/gpu/drm/panel/panel-visionox-r66451.c      |   4 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  11 +
 drivers/gpu/drm/panthor/panthor_gpu.c              |  61 +--
 drivers/gpu/drm/xe/Makefile                        |   1 +
 drivers/gpu/drm/xe/regs/xe_lrc_layout.h            |   3 +
 drivers/gpu/drm/xe/xe_configfs.h                   |   2 +-
 drivers/gpu/drm/xe/xe_force_wake.c                 |   7 +
 drivers/gpu/drm/xe/xe_force_wake.h                 |  40 ++
 drivers/gpu/drm/xe/xe_gt.c                         |   3 +-
 drivers/gpu/drm/xe/xe_guc.c                        |   8 +-
 drivers/gpu/drm/xe/xe_guc_pc.c                     | 227 +++-----
 drivers/gpu/drm/xe/xe_guc_pc.h                     |   6 +-
 drivers/gpu/drm/xe/xe_guc_pc_types.h               |   2 -
 drivers/gpu/drm/xe/xe_guc_rc.c                     | 131 +++++
 drivers/gpu/drm/xe/xe_guc_rc.h                     |  16 +
 drivers/gpu/drm/xe/xe_hw_engine.c                  |  17 +-
 drivers/gpu/drm/xe/xe_hw_error.c                   |   7 +-
 drivers/gpu/drm/xe/xe_irq.c                        |   3 +
 drivers/gpu/drm/xe/xe_late_bind_fw.c               |  15 +-
 drivers/gpu/drm/xe/xe_lrc.c                        |   8 +-
 drivers/gpu/drm/xe/xe_memirq.c                     |   3 +
 drivers/gpu/drm/xe/xe_oa.c                         |  22 +-
 drivers/gpu/drm/xe/xe_oa_types.h                   |   3 -
 drivers/gpu/drm/xe/xe_pci.c                        |   5 +
 drivers/gpu/drm/xe/xe_survivability_mode.c         | 247 +++++----
 drivers/gpu/drm/xe/xe_survivability_mode.h         |   2 +-
 drivers/gpu/drm/xe/xe_survivability_mode_types.h   |  22 +-
 drivers/gpu/drm/xe/xe_tuning.c                     |   2 +-
 drivers/gpu/drm/xe/xe_uc.c                         |  10 +-
 drivers/gpu/drm/xe/xe_uc.h                         |   1 -
 drivers/gpu/drm/xe/xe_vm.c                         |   9 +-
 drivers/gpu/drm/xe/xe_wa.c                         |  16 +-
 drivers/gpu/drm/xe/xe_wa_oob.rules                 |  33 +-
 drivers/hwmon/aht10.c                              |   2 +-
 drivers/hwmon/gpio-fan.c                           |  24 +-
 drivers/hwmon/max31760.c                           |  12 +-
 drivers/hwmon/pmbus/mp2975.c                       | 207 ++++----
 drivers/hwmon/scmi-hwmon.c                         |  12 +-
 drivers/hwmon/sy7636a-hwmon.c                      |   2 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |  40 +-
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/accel/adxl380.c                        |  11 +-
 drivers/iio/accel/kxsd9.c                          |   2 +-
 drivers/iio/adc/ad7780.c                           |   4 +-
 drivers/iio/adc/ad7791.c                           |   4 +-
 drivers/iio/adc/ad7793.c                           |   4 +-
 drivers/iio/adc/max11205.c                         |   4 +-
 drivers/iio/addac/ad74413r.c                       |   2 +-
 drivers/iio/afe/iio-rescale.c                      |   3 +-
 drivers/iio/chemical/atlas-ezo-sensor.c            |   3 -
 .../iio/common/hid-sensors/hid-sensor-attributes.c |  14 +-
 drivers/iio/common/scmi_sensors/scmi_iio.c         |  27 +-
 drivers/iio/dac/mcp4725.c                          |   2 +
 drivers/iio/gyro/bmg160_core.c                     |   2 +-
 drivers/iio/humidity/am2315.c                      |  12 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |  24 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |  97 +++-
 drivers/iio/imu/kmx61.c                            |   2 +-
 drivers/iio/industrialio-acpi.c                    |   9 +
 drivers/iio/industrialio-trigger.c                 |   4 +-
 drivers/iio/light/tsl2591.c                        |  32 +-
 drivers/iio/light/vcnl4035.c                       |   4 +-
 drivers/iio/magnetometer/mmc35240.c                |   3 +-
 drivers/iio/magnetometer/tlv493d.c                 |   6 +-
 drivers/iio/proximity/sx9310.c                     |   2 +-
 drivers/iio/proximity/sx9324.c                     |  13 +-
 drivers/iio/proximity/sx9500.c                     |   6 +
 drivers/iio/temperature/mlx90614.c                 |   2 +-
 drivers/infiniband/core/rdma_core.c                |   2 +
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   4 +
 drivers/infiniband/hw/bnxt_re/main.c               |  26 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  14 +-
 drivers/infiniband/hw/mlx5/fs.c                    |   3 +
 drivers/infiniband/hw/mlx5/qp.c                    |  22 +-
 drivers/infiniband/hw/mlx5/qpc.c                   |  10 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c      |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  45 +-
 drivers/input/ff-core.c                            |   2 +-
 drivers/input/ff-memless.c                         |  10 +-
 drivers/input/input.c                              |   2 +
 drivers/iommu/amd/init.c                           |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  10 +-
 drivers/irqchip/irq-mst-intc.c                     |   3 +
 drivers/irqchip/irq-sifive-plic.c                  |   2 +-
 drivers/md/dm-cache-metadata.c                     |   4 +-
 drivers/md/dm-cache-target.c                       |   1 +
 drivers/md/dm-crypt.c                              |  22 +-
 drivers/md/dm-integrity.c                          |  30 +-
 drivers/md/dm-log-userspace-base.c                 |   6 +-
 drivers/md/dm-mpath.c                              |   6 +-
 drivers/md/dm-pcache/backing_dev.c                 |   4 +-
 drivers/md/dm-pcache/backing_dev.h                 |   2 +-
 drivers/md/dm-pcache/cache_writeback.c             |  28 +-
 drivers/md/dm-raid.c                               |   5 +-
 drivers/md/dm-snap.c                               |  18 +-
 drivers/md/dm-sysfs.c                              |  17 +-
 drivers/md/dm-thin-metadata.c                      |   5 +-
 drivers/md/dm-thin.c                               |   7 +-
 drivers/md/dm-verity-target.c                      |  27 +-
 drivers/md/dm-zone.c                               |   2 +
 drivers/md/dm-zoned-reclaim.c                      |  18 +-
 drivers/md/dm.c                                    |  19 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  13 +-
 drivers/md/persistent-data/dm-btree.c              |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   9 +-
 drivers/media/rc/rc-main.c                         | 125 +++--
 drivers/mfd/cs42l43-i2c.c                          |   8 +
 drivers/mfd/cs42l43-sdw.c                          |  10 +
 drivers/mfd/cs42l43.c                              |  12 +-
 drivers/mfd/cs42l43.h                              |   1 +
 drivers/misc/bcm-vk/bcm_vk_sg.c                    |  43 +-
 drivers/misc/fastrpc.c                             | 188 ++++---
 drivers/misc/ibmvmc.c                              |  16 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   7 +-
 drivers/mmc/host/jz4740_mmc.c                      |   5 +-
 drivers/mmc/host/meson-gx-mmc.c                    |  26 +-
 drivers/mmc/host/mmci.c                            |   4 +-
 drivers/mmc/host/omap.c                            |   4 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  17 +
 drivers/mmc/host/sunxi-mmc.c                       |  24 +-
 drivers/mtd/mtdcore.c                              |   1 +
 drivers/net/amt.c                                  |  61 +--
 drivers/net/bonding/bond_main.c                    | 108 ++--
 drivers/net/can/dev/skb.c                          |   6 +-
 drivers/net/dsa/b53/b53_common.c                   |  69 ++-
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/b53/b53_regs.h                     |  17 +
 drivers/net/dsa/bcm_sf2.c                          |   5 +
 drivers/net/dsa/microchip/ksz_common.c             |   1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  13 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   3 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   8 +-
 drivers/net/ethernet/broadcom/bnge/bnge_netdev.c   |  27 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  55 +-
 drivers/net/ethernet/cadence/macb.h                |   2 -
 drivers/net/ethernet/cadence/macb_main.c           |  23 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  35 +-
 drivers/net/ethernet/intel/ice/ice_adapter.c       |  17 +-
 drivers/net/ethernet/intel/ice/ice_adapter.h       |  17 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 125 +++--
 drivers/net/ethernet/intel/ice/ice_ptp.h           |   4 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  19 +-
 drivers/net/ethernet/intel/idpf/xsk.c              |   5 +
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   5 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |  27 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   5 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  38 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  65 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  19 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h |   6 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 248 ++++++---
 .../net/ethernet/mellanox/mlx5/core/lib/clock.h    |   2 +
 .../ethernet/mellanox/mlx5/core/lib/macsec_fs.c    |  41 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   8 +-
 .../mellanox/mlx5/core/steering/hws/fs_hws.h       |   2 +-
 drivers/net/ethernet/meta/fbnic/fbnic.h            |  10 +-
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h        |   7 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |  16 +
 drivers/net/ethernet/meta/fbnic/fbnic_irq.c        |  34 +-
 drivers/net/ethernet/meta/fbnic/fbnic_mac.c        |  81 ++-
 drivers/net/ethernet/meta/fbnic/fbnic_mac.h        |  40 +-
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |   8 +-
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.h     |   2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |  42 +-
 drivers/net/ethernet/meta/fbnic/fbnic_phylink.c    | 102 +++-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |  10 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   6 +
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |  10 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   7 +-
 drivers/net/ethernet/realtek/8139cp.c              |   8 +-
 drivers/net/ethernet/sfc/ptp.c                     | 108 ++--
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |   2 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   6 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 260 +++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  17 +-
 drivers/net/ethernet/ti/am65-cpts.c                |  67 ++-
 drivers/net/gtp.c                                  |  22 +-
 drivers/net/hamradio/bpqether.c                    |  62 ++-
 drivers/net/hyperv/rndis_filter.c                  |   6 +-
 drivers/net/ipa/ipa_interrupt.c                    |  12 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +-
 drivers/net/macsec.c                               |  15 +-
 drivers/net/mctp/mctp-i3c.c                        |   3 +-
 drivers/net/phy/phy-c45.c                          |  46 +-
 drivers/net/team/team_core.c                       |  12 +-
 drivers/net/tun.c                                  |  42 +-
 drivers/net/tun_vnet.h                             |   5 +-
 drivers/net/usb/cdc_ncm.c                          |   4 +-
 drivers/net/usb/lan78xx.c                          |  21 +-
 drivers/net/virtio_net.c                           |  51 +-
 drivers/net/wireless/ath/ath10k/core.c             |   1 +
 drivers/net/wireless/ath/ath10k/thermal.c          |   9 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |   2 +
 drivers/net/wireless/ath/ath12k/ahb.c              |  52 +-
 drivers/net/wireless/ath/ath12k/core.c             |   6 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  60 ++-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |  15 +-
 drivers/net/wireless/ath/ath12k/mac.c              | 430 ++++++++++++---
 drivers/net/wireless/ath/ath12k/mac.h              |  16 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |  12 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  31 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   4 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       | 140 +++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c     |   8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c     |   8 +-
 drivers/net/wireless/realtek/rtw89/usb.c           |   5 +-
 drivers/net/wireless/realtek/rtw89/usb.h           |   3 +-
 drivers/nvme/common/.kunitconfig                   |   6 +
 drivers/nvme/common/Kconfig                        |  10 +
 drivers/nvme/common/Makefile                       |   2 +
 drivers/nvme/common/auth.c                         | 291 ++++++----
 drivers/nvme/common/tests/auth_kunit.c             | 175 ++++++
 drivers/nvme/host/auth.c                           |  22 +-
 drivers/nvme/host/core.c                           |   4 +
 drivers/nvme/host/tcp.c                            |  54 +-
 drivers/nvme/target/Kconfig                        |   9 +
 drivers/nvme/target/admin-cmd.c                    |   4 +-
 drivers/nvme/target/auth.c                         |  98 ++--
 drivers/nvme/target/loop.c                         |  34 +-
 drivers/nvme/target/nvmet.h                        |   2 +-
 drivers/nvme/target/rdma.c                         |  55 +-
 drivers/nvme/target/tcp.c                          |  13 +-
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  66 ++-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  12 +-
 drivers/platform/x86/intel/pmt/class.c             |   4 +-
 drivers/platform/x86/intel/pmt/class.h             |   3 +-
 drivers/platform/x86/intel/pmt/discovery.c         |   2 +-
 drivers/power/sequencing/pwrseq-qcom-wcn.c         |   2 +-
 drivers/ptp/ptp_clock.c                            |   5 +
 drivers/ptp/ptp_kvm_x86.c                          |   7 +-
 drivers/ptp/ptp_private.h                          |   7 +-
 drivers/ptp/ptp_sysfs.c                            |  18 +-
 drivers/ptp/ptp_vclock.c                           | 123 +++--
 drivers/regulator/Kconfig                          |   1 +
 drivers/regulator/qcom_spmi-regulator.c            |  35 +-
 drivers/s390/block/dasd_eckd.c                     |   3 +-
 drivers/s390/block/dasd_ioctl.c                    |   4 +-
 drivers/s390/crypto/zcrypt_api.c                   |  41 +-
 drivers/s390/crypto/zcrypt_error.h                 |  28 +-
 drivers/s390/crypto/zcrypt_msgtype50.c             |  95 +++-
 drivers/s390/crypto/zcrypt_msgtype6.c              | 208 ++++++--
 drivers/s390/crypto/zcrypt_msgtype6.h              |   4 +-
 drivers/scsi/aha1542.c                             |   2 -
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   2 +-
 drivers/scsi/scsi_debug.c                          |  12 +
 drivers/soundwire/dmi-quirks.c                     |  42 ++
 drivers/spi/spi-cadence-quadspi.c                  |   4 +-
 drivers/spi/spi-pic32-sqi.c                        |   3 +-
 drivers/spi/spi-tegra210-quad.c                    |  31 +-
 drivers/spi/spi-virtio.c                           |  26 +-
 drivers/spi/spi.c                                  |  40 +-
 drivers/staging/greybus/raw.c                      |  23 +-
 .../staging/media/atomisp/pci/sh_css_param_dvs.c   |  11 +-
 .../media/atomisp/pci/sh_css_param_shading.c       |   4 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |  35 +-
 drivers/target/target_core_pr.c                    |   9 +-
 drivers/thermal/airoha_thermal.c                   |  25 +-
 drivers/tty/serial/8250/8250.h                     |   1 +
 drivers/tty/serial/8250/8250_lpss.c                |   3 +
 drivers/tty/serial/8250/8250_mid.c                 |  16 +-
 drivers/tty/serial/8250/8250_port.c                |  13 +-
 drivers/tty/serial/rda-uart.c                      |   2 +
 drivers/tty/serial/samsung_tty.c                   |   8 +-
 drivers/tty/serial/serial_core.c                   |  25 +-
 drivers/tty/serial/serial_port.c                   |   4 +-
 drivers/tty/tty_io.c                               |   3 +-
 drivers/tty/vt/keyboard.c                          |   6 +
 drivers/tty/vt/vt.c                                |   2 +
 drivers/usb/class/cdc-acm.c                        |  18 +-
 drivers/usb/dwc3/core.h                            |   4 +-
 drivers/usb/dwc3/dwc3-xilinx.c                     |  24 +-
 drivers/usb/dwc3/ep0.c                             |   2 +-
 drivers/usb/dwc3/gadget.c                          | 160 ++++--
 drivers/usb/gadget/function/f_mass_storage.c       |   8 +-
 drivers/usb/gadget/function/f_midi.c               |   4 +
 drivers/usb/gadget/function/f_ncm.c                |   7 +-
 drivers/usb/gadget/function/storage_common.c       |   7 +-
 drivers/usb/gadget/function/storage_common.h       |   3 +-
 drivers/usb/gadget/function/u_serial.c             | 170 ++++--
 drivers/usb/host/pci-quirks.c                      |  13 +-
 drivers/usb/host/xhci.c                            |   2 +-
 drivers/usb/misc/usbtest.c                         |   3 +
 drivers/usb/serial/garmin_gps.c                    |  31 +-
 drivers/usb/serial/io_edgeport.c                   | 141 +++--
 drivers/usb/serial/oti6858.c                       |  16 +-
 drivers/usb/serial/sierra.c                        |  18 +-
 drivers/usb/serial/upd78f0730.c                    |  13 +-
 drivers/usb/storage/uas-detect.h                   |   8 +-
 drivers/usb/typec/mux/fsa4480.c                    |   9 +-
 drivers/usb/typec/mux/nb7vpq904m.c                 |   1 +
 drivers/usb/typec/ucsi/ucsi.c                      |  10 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  10 +-
 drivers/vdpa/vdpa.c                                |   7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   7 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  15 +-
 drivers/vhost/scsi.c                               |  61 ++-
 drivers/vhost/test.c                               |   4 +
 drivers/vhost/vdpa.c                               |  87 ++-
 drivers/vhost/vhost.c                              |  33 +-
 drivers/video/fbdev/core/fbmem.c                   |   5 +-
 drivers/video/fbdev/core/fbsysfs.c                 |  59 ++-
 drivers/virtio/virtio_balloon.c                    |   3 +-
 drivers/virtio/virtio_pci_common.c                 |   2 +-
 drivers/virtio/virtio_ring.c                       |  70 +--
 drivers/w1/masters/ds2482.c                        |  36 +-
 drivers/w1/slaves/w1_ds2805.c                      |   8 +-
 drivers/w1/slaves/w1_ds28e04.c                     |  18 +-
 drivers/w1/slaves/w1_therm.c                       |  37 +-
 drivers/w1/w1.c                                    |  21 +-
 drivers/w1/w1_int.c                                |   8 +-
 drivers/w1/w1_netlink.c                            |   8 +-
 drivers/watchdog/npcm_wdt.c                        |  15 +-
 drivers/xen/gntdev.c                               |   8 +-
 drivers/xen/grant-table.c                          |  37 +-
 drivers/xen/privcmd.c                              |  15 +
 drivers/xen/pvcalls-back.c                         |  26 +-
 fs/9p/fid.c                                        |  11 +-
 fs/9p/v9fs.c                                       | 589 +++++++++++----------
 fs/9p/v9fs.h                                       |  58 +-
 fs/9p/v9fs_vfs.h                                   |  15 +
 fs/9p/vfs_addr.c                                   |  39 +-
 fs/9p/vfs_dentry.c                                 | 105 +++-
 fs/9p/vfs_dir.c                                    |   6 +-
 fs/9p/vfs_inode.c                                  |  28 +-
 fs/9p/vfs_inode_dotl.c                             |  90 +++-
 fs/9p/vfs_super.c                                  | 135 +++--
 fs/adfs/dir_fplus.c                                |   2 +
 fs/aio.c                                           |   7 +-
 fs/backing-file.c                                  |   7 +-
 fs/btrfs/bio.c                                     |   4 +
 fs/btrfs/fiemap.c                                  |   3 +-
 fs/btrfs/scrub.c                                   |   8 +-
 fs/btrfs/verity.c                                  |   2 +-
 fs/btrfs/volumes.h                                 |   5 +-
 fs/btrfs/zoned.c                                   |  81 ++-
 fs/btrfs/zstd.c                                    |   3 +-
 fs/coda/file.c                                     |   3 +-
 fs/dcache.c                                        |  46 +-
 fs/dlm/config.c                                    |   9 +-
 fs/dlm/member.c                                    |  17 +-
 fs/eventpoll.c                                     |  11 +-
 fs/exfat/fatent.c                                  |  20 +-
 fs/ext2/dir.c                                      |   3 +
 fs/file.c                                          |  10 +-
 fs/fs-writeback.c                                  |  97 ++--
 fs/fuse/dev.c                                      |  32 +-
 fs/fuse/file.c                                     |   2 +-
 fs/fuse/notify.c                                   |   2 +-
 fs/inode.c                                         |   3 +-
 fs/isofs/util.c                                    |   8 +-
 fs/libfs.c                                         | 133 ++---
 fs/netfs/read_retry.c                              |  17 +-
 fs/netfs/write_issue.c                             |   4 +-
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/inode.c                                     |  11 +-
 fs/nfs/localio.c                                   |  13 +-
 fs/nfs/nfs4proc.c                                  |  24 +-
 fs/nfs/pnfs.c                                      |   2 +-
 fs/nfsd/nfs4state.c                                | 196 +++++--
 fs/nfsd/state.h                                    |  13 +-
 fs/notify/fanotify/fanotify.h                      |   2 +-
 fs/notify/fsnotify.c                               |   2 +-
 fs/ntfs3/index.c                                   |  10 +
 fs/overlayfs/namei.c                               |  13 +-
 fs/overlayfs/overlayfs.h                           |  11 +-
 fs/overlayfs/ovl_entry.h                           |   2 +
 fs/overlayfs/params.c                              |  58 +-
 fs/overlayfs/super.c                               |  37 +-
 fs/overlayfs/util.c                                |  12 +
 fs/pidfs.c                                         |  12 +
 fs/proc/proc_sysctl.c                              |   5 +-
 fs/read_write.c                                    |  10 +-
 fs/smb/client/cifsacl.c                            |   5 +-
 fs/smb/client/cifsacl.h                            |  14 -
 fs/smb/client/cifsfs.c                             |  13 +-
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/connect.c                            |   3 +-
 fs/smb/client/dfs.c                                |  12 +-
 fs/smb/client/file.c                               | 100 +++-
 fs/smb/client/sess.c                               |   4 +-
 fs/smb/client/smb2pdu.c                            |  23 +-
 fs/smb/server/mgmt/share_config.c                  |  43 +-
 fs/smb/server/mgmt/share_config.h                  |   2 +
 fs/smb/server/smb2pdu.c                            | 223 +++++---
 fs/smb/server/vfs.c                                |   9 +-
 fs/smb/server/vfs_cache.c                          |  16 +-
 fs/splice.c                                        |  11 +-
 fs/stat.c                                          |   6 +-
 fs/udf/super.c                                     |  19 +-
 fs/userfaultfd.c                                   |  22 +-
 fs/xfs/xfs_inode.c                                 |   3 +-
 include/acpi/acpi_bus.h                            |   1 +
 include/dt-bindings/sound/qcom,q6dsp-lpass-ports.h |  12 +
 include/linux/blk-mq.h                             |   3 +-
 include/linux/blkdev.h                             |   3 +-
 include/linux/bpf.h                                |  16 +-
 include/linux/can/dev.h                            |   2 +-
 include/linux/can/skb.h                            |   4 +-
 include/linux/ceph/ceph_fs.h                       |   5 +-
 include/linux/compiler.h                           |   7 +-
 include/linux/cpufreq.h                            |   3 +
 include/linux/dcache.h                             |   1 +
 include/linux/ethtool.h                            |   2 +
 include/linux/fs.h                                 |  10 +-
 include/linux/fs_parser.h                          |   2 +
 include/linux/fsnotify.h                           |   4 +-
 include/linux/fsnotify_backend.h                   |   6 +-
 include/linux/gpio/regmap.h                        |   7 +
 include/linux/key.h                                |   3 +
 include/linux/mlx5/driver.h                        |   8 +-
 include/linux/mmzone.h                             |   3 +-
 include/linux/netdevice.h                          |   5 +
 include/linux/netdevice_xmit.h                     |   4 +-
 include/linux/nvme-auth.h                          |  44 +-
 include/linux/nvme.h                               |   5 +
 include/linux/perf_event.h                         |  34 ++
 include/linux/perf_regs.h                          |  36 +-
 include/linux/ptp_clock_kernel.h                   |   2 +-
 include/linux/sched.h                              |  16 +-
 include/linux/stat.h                               |   3 +
 include/linux/tcp.h                                |  37 +-
 include/linux/uio.h                                |   8 +-
 include/linux/virtio_net.h                         | 245 +++++++--
 include/media/rc-map.h                             |   2 -
 include/net/9p/client.h                            | 102 +++-
 include/net/9p/transport.h                         |   9 +-
 include/net/af_unix.h                              |   1 +
 include/net/bluetooth/hci_core.h                   |  15 +-
 include/net/dst.h                                  |   3 +-
 include/net/dst_metadata.h                         |   2 +
 include/net/gro.h                                  |  18 +-
 include/net/gso.h                                  |   2 +-
 include/net/inet_connection_sock.h                 |   1 +
 include/net/inet_frag.h                            |   1 +
 include/net/iw_handler.h                           |   8 +-
 include/net/libeth/xsk.h                           |  10 +-
 include/net/netfilter/nf_conntrack_helper.h        |   1 +
 include/net/netfilter/nf_dup_netdev.h              |  35 --
 include/net/netfilter/nf_queue.h                   |   1 +
 include/net/netfilter/nf_recursion.h               |  42 ++
 include/net/scm.h                                  |  13 +-
 include/net/sock.h                                 |  24 +-
 include/net/tcp.h                                  |   9 +
 include/net/tcp_ao.h                               |   3 +-
 include/net/xdp_sock_drv.h                         |   7 +-
 include/net/xfrm.h                                 |  17 +
 include/net/xsk_buff_pool.h                        |   3 +
 include/trace/events/huge_memory.h                 |   6 +-
 include/trace/events/oom.h                         |   8 +-
 include/uapi/asm-generic/socket.h                  |   2 +
 include/uapi/linux/mdio.h                          |  13 +-
 include/uapi/linux/perf_event.h                    |  51 +-
 include/uapi/linux/virtio_spi.h                    |   2 +-
 init/Kconfig                                       |   6 +
 init/do_mounts_rd.c                                |   5 +
 io_uring/futex.c                                   |   1 +
 io_uring/io-wq.c                                   |  44 +-
 io_uring/io_uring.c                                |   8 +-
 io_uring/io_uring.h                                |   1 +
 io_uring/kbuf.c                                    |   1 +
 io_uring/napi.c                                    |  31 +-
 io_uring/rsrc.c                                    |   7 +-
 io_uring/rw.c                                      |   4 +-
 io_uring/timeout.c                                 |   3 +-
 kernel/Kconfig.kexec                               |  34 --
 kernel/Makefile                                    |   4 +-
 kernel/bpf/arena.c                                 |  10 +-
 kernel/bpf/arraymap.c                              |   2 +-
 kernel/bpf/bpf_local_storage.c                     |   2 +-
 kernel/bpf/cgroup.c                                |  26 +-
 kernel/bpf/core.c                                  |  10 +-
 kernel/bpf/hashtab.c                               |  86 ++-
 kernel/bpf/helpers.c                               |  14 +-
 kernel/bpf/stackmap.c                              | 102 ++--
 kernel/bpf/syscall.c                               |   4 +-
 kernel/bpf/trampoline.c                            |  19 +-
 kernel/bpf/verifier.c                              | 210 ++++++--
 kernel/cgroup/cpuset-internal.h                    |   5 +
 kernel/cgroup/cpuset.c                             | 437 +++++++++------
 kernel/dma/direct.c                                |  21 +-
 kernel/events/core.c                               | 298 +++++++++--
 kernel/events/hw_breakpoint.c                      |   3 +-
 kernel/kprobes.c                                   |  82 +--
 kernel/liveupdate/Kconfig                          |  40 ++
 kernel/liveupdate/Makefile                         |   5 +
 kernel/{ => liveupdate}/kexec_handover.c           |   6 +-
 kernel/{ => liveupdate}/kexec_handover_debug.c     |   0
 kernel/{ => liveupdate}/kexec_handover_debugfs.c   |   0
 kernel/{ => liveupdate}/kexec_handover_internal.h  |   0
 kernel/locking/osq_lock.c                          |  62 ++-
 kernel/printk/printk.c                             |  34 +-
 kernel/sched/deadline.c                            |  89 +++-
 kernel/sched/ext.c                                 |  24 +-
 kernel/sched/fair.c                                |   9 +-
 kernel/sched/idle.c                                |  16 +-
 kernel/sched/pelt.c                                |   2 +-
 kernel/sched/sched.h                               |  25 +-
 kernel/sched/syscalls.c                            |  40 +-
 kernel/sched/topology.c                            |  16 +-
 kernel/time/timekeeping.c                          |   9 +-
 kernel/trace/trace_eprobe.c                        |  83 ++-
 kernel/trace/trace_event_perf.c                    |   3 +-
 kernel/trace/trace_fprobe.c                        |  22 +-
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.c                         |  20 +-
 kernel/trace/trace_probe_tmpl.h                    |  14 +-
 kernel/trace/trace_uprobe.c                        |  67 ++-
 kernel/tsacct.c                                    |  10 +-
 lib/bootconfig.c                                   |   2 +-
 lib/errseq.c                                       |  29 +-
 lib/iov_iter.c                                     |   6 +-
 mm/internal.h                                      |  11 +-
 mm/khugepaged.c                                    |   9 +-
 mm/ksm.c                                           |   4 +
 mm/memory_hotplug.c                                |  49 +-
 mm/mempolicy.c                                     |   4 +-
 mm/page_alloc.c                                    |  83 ++-
 mm/page_frag_cache.c                               |  21 +-
 mm/shmem.c                                         |   2 +-
 mm/slub.c                                          |  86 ++-
 net/9p/client.c                                    | 154 +-----
 net/9p/mod.c                                       |   2 +-
 net/9p/protocol.c                                  |  12 +-
 net/9p/trans_fd.c                                  | 144 +----
 net/9p/trans_rdma.c                                | 133 +----
 net/9p/trans_usbg.c                                |  14 +-
 net/9p/trans_virtio.c                              |   8 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/ax25/ax25_in.c                                 |  30 +-
 net/ax25/ax25_std_in.c                             |  23 +-
 net/batman-adv/bat_iv_ogm.c                        |   2 +-
 net/bluetooth/6lowpan.c                            |  21 +-
 net/bluetooth/hci_conn.c                           |  23 +-
 net/bluetooth/hci_core.c                           |  66 ++-
 net/bluetooth/hci_event.c                          |  68 ++-
 net/bluetooth/hci_sync.c                           | 116 +++-
 net/bluetooth/l2cap_core.c                         |   5 +-
 net/bluetooth/l2cap_sock.c                         |   3 +-
 net/bluetooth/mgmt.c                               |  45 +-
 net/bridge/br_arp_nd_proxy.c                       |   6 +-
 net/bridge/br_if.c                                 |   6 +-
 net/bridge/br_vlan.c                               |  31 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   2 +-
 net/ceph/Kconfig                                   |   1 +
 net/ceph/auth_x.c                                  | 195 +++++--
 net/ceph/auth_x_protocol.h                         |  38 ++
 net/ceph/crypto.c                                  | 269 ++++++++--
 net/ceph/crypto.h                                  |  21 +-
 net/ceph/messenger_v2.c                            |  14 +-
 net/compat.c                                       |   4 +-
 net/core/dev.c                                     |  12 +
 net/core/devmem.c                                  |   7 +-
 net/core/devmem.h                                  |   5 +
 net/core/filter.c                                  | 103 +++-
 net/core/gro.c                                     |  31 +-
 net/core/lwt_bpf.c                                 |  55 +-
 net/core/net-sysfs.c                               |   8 +
 net/core/netdev-genl.c                             |   6 +-
 net/core/scm.c                                     |  40 +-
 net/core/skbuff.c                                  |  18 +-
 net/core/sock_reuseport.c                          |  26 +-
 net/ethtool/ioctl.c                                |  17 +-
 net/ethtool/linkinfo.c                             |   4 +-
 net/ethtool/linkmodes.c                            |   4 +-
 net/ipv4/esp4_offload.c                            |   1 +
 net/ipv4/fib_trie.c                                |  14 +-
 net/ipv4/fou_core.c                                |  31 +-
 net/ipv4/igmp.c                                    |   2 +
 net/ipv4/inet_connection_sock.c                    |  23 +-
 net/ipv4/inet_fragment.c                           |   5 +
 net/ipv4/inet_hashtables.c                         |  11 +
 net/ipv4/inet_timewait_sock.c                      |   6 +-
 net/ipv4/ip_fragment.c                             |   3 +-
 net/ipv4/ip_output.c                               |   8 +-
 net/ipv4/ip_tunnel.c                               |   6 +-
 net/ipv4/netfilter/arp_tables.c                    |   5 +-
 net/ipv4/netfilter/ip_tables.c                     |   5 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |  12 +
 net/ipv4/raw.c                                     |  15 +-
 net/ipv4/route.c                                   |  25 +-
 net/ipv4/tcp.c                                     |  23 +-
 net/ipv4/tcp_fastopen.c                            |   2 +
 net/ipv4/tcp_input.c                               |  98 +++-
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
 net/ipv6/ip6_fib.c                                 |  54 +-
 net/ipv6/ip6_output.c                              |  13 +-
 net/ipv6/ip6mr.c                                   |  43 +-
 net/ipv6/mip6.c                                    |   9 +-
 net/ipv6/netfilter/ip6_tables.c                    |   5 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |  13 +
 net/ipv6/raw.c                                     |  15 +-
 net/ipv6/reassembly.c                              |   5 +-
 net/ipv6/route.c                                   |  32 +-
 net/ipv6/seg6_iptunnel.c                           |  46 +-
 net/ipv6/seg6_local.c                              | 264 +++++++--
 net/ipv6/sit.c                                     |   2 +-
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
 net/netfilter/ipvs/ip_vs_app.c                     |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  12 +-
 net/netfilter/nf_conntrack_helper.c                |  20 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_dup_netdev.c                      |   1 +
 net/netfilter/nf_flow_table_core.c                 |   1 +
 net/netfilter/nf_flow_table_ip.c                   |   2 +
 net/netfilter/nf_nat_masquerade.c                  |   4 +-
 net/netfilter/nf_queue.c                           |   1 +
 net/netfilter/nf_tables_api.c                      |  21 +-
 net/netfilter/nf_tables_offload.c                  |   3 +
 net/netfilter/nfnetlink_queue.c                    |  17 +-
 net/netfilter/nft_ct.c                             | 119 ++++-
 net/netfilter/nft_fwd_netdev.c                     |   1 +
 net/netfilter/nft_set_rbtree.c                     |   3 +-
 net/netfilter/xt_NETMAP.c                          |   4 +-
 net/netfilter/xt_recent.c                          |   7 +-
 net/netlink/af_netlink.c                           |   3 +-
 net/netrom/nr_out.c                                |   7 +-
 net/netrom/nr_subr.c                               |   6 +-
 net/netrom/nr_timer.c                              |   4 +
 net/netrom/sysctl_net_netrom.c                     |  17 +-
 net/nsh/nsh.c                                      |   7 +
 net/openvswitch/flow.c                             |  19 +-
 net/rds/rdma.c                                     |   5 +-
 net/rose/rose_in.c                                 |  21 +
 net/sched/act_ife.c                                |  13 +-
 net/sched/sch_teql.c                               |   9 +-
 net/sctp/sm_make_chunk.c                           |  43 +-
 net/sctp/sm_statefuns.c                            |  16 +-
 net/sctp/socket.c                                  |   2 +-
 net/sctp/stream.c                                  |   2 +
 net/sctp/stream_interleave.c                       |  38 +-
 net/smc/af_smc.c                                   |  21 +-
 net/smc/smc.h                                      |   1 +
 net/smc/smc_close.c                                |  14 +
 net/smc/smc_core.c                                 |  86 ++-
 net/smc/smc_core.h                                 |   6 +-
 net/smc/smc_diag.c                                 |  12 +-
 net/smc/smc_sysctl.c                               |   6 +-
 net/socket.c                                       |  11 +-
 net/sunrpc/clnt.c                                  |  10 +-
 net/sunrpc/rpc_pipe.c                              |   1 +
 net/sunrpc/xprtsock.c                              |   2 +-
 net/tipc/bearer.c                                  |  33 ++
 net/tls/tls_device.c                               |  24 +
 net/tls/tls_sw.c                                   |  25 +-
 net/unix/af_unix.c                                 |  15 +-
 net/unix/garbage.c                                 |  31 +-
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/vmw_vsock/hyperv_transport.c                   |   3 +
 net/vmw_vsock/virtio_transport.c                   |  16 +-
 net/wireless/core.c                                |   2 +-
 net/wireless/nl80211.c                             |   9 +-
 net/wireless/scan.c                                |   3 +-
 net/wireless/util.c                                |   6 +-
 net/wireless/wext-core.c                           |  33 +-
 net/xdp/xsk.c                                      |  28 +-
 net/xdp/xsk_buff_pool.c                            |  46 +-
 net/xfrm/xfrm_iptfs.c                              |   3 +-
 net/xfrm/xfrm_policy.c                             |  20 +-
 net/xfrm/xfrm_replay.c                             |   6 +-
 security/keys/key.c                                |  10 +-
 security/keys/keyctl.c                             |   2 -
 security/keys/keyring.c                            |  25 +-
 security/keys/request_key.c                        |  14 +-
 sound/core/memalloc.c                              |   2 +-
 sound/drivers/aloop.c                              |  11 +-
 sound/drivers/pcmtest.c                            |  66 +--
 sound/hda/codecs/realtek/alc269.c                  |  19 +-
 sound/hda/codecs/realtek/alc882.c                  |  10 +
 sound/hda/codecs/side-codecs/cs35l56_hda.c         |   2 +
 sound/hda/codecs/side-codecs/tas2781_hda.c         |   4 +-
 sound/hda/common/sysfs.c                           |   5 +-
 sound/hda/core/controller.c                        |  10 +-
 sound/pci/Kconfig                                  |   1 +
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c      |  16 +-
 sound/soc/amd/ps/pci-ps.c                          |  32 +-
 sound/soc/codecs/max98090.c                        |  22 +-
 sound/soc/codecs/wm_adsp.c                         |  10 +
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.c      |  12 +-
 sound/soc/meson/axg-fifo.c                         |  30 +-
 sound/soc/qcom/common.c                            | 222 +++++++-
 sound/soc/qcom/common.h                            |  20 +
 sound/soc/qcom/lpass.h                             |   3 +-
 sound/soc/qcom/qdsp6/q6afe.h                       |   3 +-
 sound/soc/qcom/qdsp6/q6apm.h                       |   3 +-
 sound/soc/qcom/sc8280xp.c                          |  33 +-
 sound/soc/qcom/sdw.c                               |  24 +-
 sound/soc/qcom/sdw.h                               |   6 +-
 sound/soc/qcom/sm8250.c                            |  33 +-
 sound/soc/qcom/x1e80100.c                          |  41 +-
 sound/soc/rockchip/Kconfig                         |   6 +
 sound/soc/rockchip/rockchip_spdif.c                |  97 +++-
 sound/soc/rockchip/rockchip_spdif.h                |  18 +-
 sound/soc/soc-core.c                               |  16 +
 sound/soc/sof/amd/acp.c                            |  32 +-
 sound/soc/sof/ipc4-topology.c                      |   2 +-
 sound/usb/caiaq/device.c                           |  11 +-
 sound/usb/mixer.c                                  |  23 +
 sound/usb/mixer.h                                  |   2 +
 sound/usb/pcm.c                                    |   6 +
 tools/include/nolibc/dirent.h                      |   7 +-
 tools/perf/builtin-lock.c                          |  61 ++-
 tools/perf/tests/hists_cumulate.c                  |   2 +-
 tools/perf/tests/hists_filter.c                    |   2 +-
 tools/perf/tests/hists_link.c                      |   2 +-
 tools/perf/tests/hists_output.c                    |   2 +-
 tools/perf/tests/thread-maps-share.c               |   2 +-
 tools/perf/util/dso.c                              |   2 +
 tools/perf/util/dso.h                              |  15 +
 tools/perf/util/evlist.c                           |   6 +-
 tools/perf/util/evsel.c                            |  59 ++-
 tools/perf/util/evsel.h                            |   1 +
 tools/perf/util/libbfd.c                           |  10 +-
 tools/perf/util/machine.c                          |   4 +-
 tools/perf/util/machine.h                          |  10 +-
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/srcline.c                          |   2 +
 tools/perf/util/thread.c                           |   8 +-
 tools/testing/cxl/test/cxl.c                       |   6 +-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |   2 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |  29 +-
 .../ftrace/test.d/dynevent/fprobe_syntax_errors.tc |   4 +-
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |   2 +-
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |   2 +-
 tools/testing/selftests/mm/merge.c                 |  33 +-
 .../tcp_bidir_fast_retransmit_nosack.pkt           |  42 ++
 tools/testing/selftests/net/tls.c                  |   3 +
 924 files changed, 16070 insertions(+), 7084 deletions(-)


