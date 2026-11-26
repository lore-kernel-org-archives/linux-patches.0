Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795690693;
	b=mkuXVzR6nRBg/QJ634jA4SIL6dTWv34BT6WElec0y/T/PRPG/d8ensTwVIRmrBXSPZsQ
	 /BKN36M+wcBZB+UfIWu9oBPdwRDYwkusJaf8EH9I/ugHRZ/f+UJO53PlgchNvHgzYdyhB
	 s+T//wpyY9rLfZsEAn5sY0xrbo5k+rn0yDPalnpJKossqS+l74OX1VAV5T+YrxyiTEodm
	 d2IVcu85JA/zXZltdwJJW7yffZ0dQfbldxN/JWrHmZApy9G9/QMKlnqk/AuVzwIjJ8qK8
	 HjimRvTX6Y6Ar1dSdPeEFGes5n8Y++GFdsdO9G9Vffq6rkPSXa/+M9WOFIN7IUy07vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795690693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=Wyj80UdkRAHm4Ka25Mx9iOzQkcQ6mwqv/xqZxeOyQJs=;
	b=lQthPhjax28anNnwzzaXhw8RIPiVnl10LFc6k8jkKZgPdlpA95UA3E1a7w2Fr7MtOwYL
	 XKYn2gj/+N/T1Dk7N8ctn04qDQQBsvCHZAcNC+/BTvI0/OjSC97GpDYgzfKCIN4DVPosu
	 v/1To9lLek7tPmnviwCz6/qfBJIVUGMDZho7mOh8c0dWaIoRsuhXjl1oWI5hBRAIde+TY
	 KX3rLUWwEZsuNHujlmuigpvqWJxFC+WlbQA8UY4479GTDboKh0mRvVNzx2M3JxVZHaSNl
	 fMQfnNP48ARJCcFu/iAtlpI8Cb+NhAIGmOcHPaC+pGdOAUzqkQ12vikCU+twIHvXFKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IyNS0prK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A0606A330;
	Thu, 26 Nov 2026 10:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IyNS0prK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CD11F000C6;
	Thu, 26 Nov 2026 10:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795690692;
	bh=Wyj80UdkRAHm4Ka25Mx9iOzQkcQ6mwqv/xqZxeOyQJs=;
	h=From:To:Cc:Subject:Date;
	b=IyNS0prKH3qFBlV/3rjsu3vWp9/41ghdW6iYbTFyGDQHkkp1hwhjTYsKmLi3RVOd8
	 bwrp+RaNKrQTK6d7CD4MYqXu2KnGu+gkIqybxLDljZXzBSA3XGD+g2GfNCd26kG+Fo
	 zi4uYIHXjjQmg/sWYpk4cG0iSK5aOu6aK+/xHiVw=
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
Subject: [PATCH 6.12 000/815] 6.12.120-rc2 review
Date: Thu, 26 Nov 2026 11:58:31 +0100
Message-ID: <20261126105709.009001842@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.120-rc2
X-KernelTest-Deadline: 2026-11-28T10:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.120 release.
There are 815 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.120-rc2

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Preserve global boost state on failed updates

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    power: sequencing: qcom-wcn: fix bluetooth-wifi copypasta for WCN6855

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: clear stale buf->page after recycling on skb build failure

Pascal Kneuper <PKneuper@dspace.de>
    net: stmmac: restore NET_IP_ALIGN in the RX DMA offset

Furong Xu <0x1207@gmail.com>
    net: stmmac: Apply new page pool parameters when SPH is enabled

Daniel Gomez <da.gomez@samsung.com>
    radix-tree: add missing cleanup.h

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Set unhashed_state in inet_twsk_hashdance_schedule().

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
    iio: proximity: sx9324: fix out-of-bounds read of scan period table

Shashank Mohan Jain <jain.sm@gmail.com>
    iio: magnetometer: mmc35240: leave cache-only mode before the cache sync

Alexander Sarmanow <as@discnull.de>
    iio: light: vcnl4035: Fix reversed ALS mode bit

Jan Remes <jan.remes@mycroftmind.com>
    iio: light: tsl2591: don't divide by zero

Jiale Yao <yaojiale02@163.com>
    iio: imu: kmx61: reject duplicate event disable

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

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: atlas-ezo: Fix humidity channel read support

Andrea Amer <and.amer@gmail.com>
    iio: afe: rescale: expose offset if rescaler or source has one

Yu-Hsiang Tseng <asas1asas200@gmail.com>
    iio: acpi: Accept comma separated values in ROTM strings

Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
    iio: accel: kxsd9: Fix potential use-after-free on removal

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

Yaohan Li <shunsheng1218@gmail.com>
    dm: avoid double-dropping the zone reset submission reference

shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>
    dm log userspace: drop the device reference on error

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: skip NULL channel in __cifs_put_smb_ses()

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

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't block dying tasks waiting for writeback on fsync

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't block dying tasks waiting for writeback on close

liuyong <pkfxxxing@gmail.com>
    smb: client: compare owner and group SIDs using their encoded lengths

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    smb: client: bound invalid NTLMSSP signature diagnostic

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

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: bound pending OCB station allocations

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: bound pending IBSS station allocations

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

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Reject array count on non-dereference string sources

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix user-space dereference string array store type

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Check enabled and busy state before unlinking sibling probes

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Disallow attaching eprobes to fprobe events

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix 1-byte signed field fetch in get_event_field()

Mike Rapoport (Microsoft) <rppt@kernel.org>
    LoongArch: Restore KFENCE pages through DMW on resume

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

Dave Hansen <dave.hansen@linux.intel.com>
    x86/mm: Ensure write visibility during LDT installation

Guanglei Zhu <zhugl3@xiaopeng.com>
    tpm: eventlog: check the payload size before reading tag events

Eric Biggers <ebiggers@kernel.org>
    tpm: Check return value of crypto_kpp_set_secret()

Takashi Iwai <tiwai@suse.de>
    tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path

Hungyu Lin <dennylin0707@gmail.com>
    timekeeping: Read getboottime64() offsets under the sequence counter

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Fix TCP-with-TLS transport class identification

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    software node: only let the owner release a managed node

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Cache post-resolution target frequency in __resolve_freq()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Clear last written P-state value on suspend

Li RongQing <lirongqing@baidu.com>
    cpufreq: acpi-cpufreq: fix P-state index mismatch in extract_io()

Mark Brown <broonie@kernel.org>
    arm64: suspend: Save POR_EL0 over suspend

Zhao Gongyi <zhaogongyi@bytedance.com>
    arm64: ptrace: don't warn on missing siginfo in a group-stop

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Add Cortex-A715/A720 AMU core counter workaround

Cheng Yongkang <teel4res@gmail.com>
    fs/splice: clamp an over-reported write_iter result

Cheng Yongkang <teel4res@gmail.com>
    fs/proc: fix the write length returned by proc_sys_call_handler()

HyeongJun An <sammiee5311@gmail.com>
    fs/adfs: bound directory entry name length in adfs_fplus_getnext()

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

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    netfilter: flowtable: extend ct timeout of offloaded GRE flows

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    netfilter: xt_recent: do not call remove_proc_entry() under recent_lock

Eric Dumazet <edumazet@kernel.org>
    net: gro: do not undo remote checksum offload on merged packets

Kyle Zeng <kylebot@openai.com>
    net: gro: avoid parsing headers from shared fragments

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

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tcp: fix authentication bypass via unsupported TCP auth options

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: only install push_pending_record for a TX context

Hungyu Lin <dennylin0707@gmail.com>
    tsacct: Keep task begin times stable across suspend

Jerome Mohm <jrmmhm.kernel@eldare.de>
    vsock/virtio: clear vqs[] to avoid a UAF on a failed PM restore

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    net: mana: report RX checksum offload for IPv6

Jens Axboe <axboe@kernel.dk>
    net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls

Tapio Reijonen <tapio.reijonen@vaisala.com>
    net: dsa: microchip: initialize the IRQ access mutex

Jun Yang <junvyyang@tencent.com>
    net: bridge: use one headroom snapshot for ND replies

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: fix lgr/lnk lifetime vs diag reader race

Kyle Zeng <kylebot@openai.com>
    net/rds: Do not unpin a page after a failed atomic pin

Jiabin Deng <dengjiabin2023@gmail.com>
    net/mlx5e: SHAMPO, Disable end padding when relaxed ordering is supported

Davidlohr Bueso <dave@stgolabs.net>
    mctp: accept MSG_CMSG_COMPAT in recvmsg

Kyle Zeng <kylebot@openai.com>
    macsec: reject frames that decapsulate into runt Ethernet frames

Jean-Paul Sergent <jpsergent@gmail.com>
    net: dst_metadata: fix memcmp overread in skb_metadata_dst_cmp

Hungyu Lin <dennylin0707@gmail.com>
    coda: honor the append state of each write

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: detect zonelist rebuilds from memory hot-add

Josef Bacik <josef@toxicpanda.com>
    mm/page_alloc: keep the pagesets of an empty zone

Josef Bacik <josef@toxicpanda.com>
    mm/memory_hotplug: resize zones under their seqlock

Gregory Price (Meta) <gourry@gourry.net>
    mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()

Josef Bacik <josef@toxicpanda.com>
    mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone

Gregory Price (Meta) <gourry@gourry.net>
    mm/mmzone: read the zoneref slot once in zonelist_zone()

Avi Weiss <thnkslprpt@gmail.com>
    splice, net: avoid MSG_MORE when the bvec array fills

Christian Brauner <brauner@kernel.org>
    aio: don't let exit_aio() return before complete() is done

Mani Tofigh <mt4022@columbia.edu>
    eventpoll: wake the next waiter when a woken waiter is killed

Chris Mason <mason@kernel.org>
    backing-file: pass RWF_NOAPPEND to synchronous writes

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

Anfernee Cao <anferneemelokc5@gmail.com>
    mmc: mmci: fix DMA channel leak when mmc_add_host() fails

Steven Rostedt <rostedt@goodmis.org>
    tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc

Jaewon Jung <jaewon8868@gmail.com>
    selftests/ftrace: Add missing spaces after ! in probe syntax tests

Gichoon Han <gichoon.han@samsung.com>
    ALSA: usb-audio: Drop capture packets with bogus actual_length

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

Eric Dumazet <edumazet@kernel.org>
    tun: clear stale skb->protocol of NAPI frags skbs

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: don't leak buffers when XDP agg buffer allocation fails

Naman Gulati <namangulati@google.com>
    netdev-genl: ignore NETDEV_UNREGISTER rebroadcasts

Josef Bacik <josef@toxicpanda.com>
    blk-mq: don't trust the cookie in blk_mq_poll()

Eric Dumazet <edumazet@kernel.org>
    ppp: linearize and segment bridged packets when required

Chuck Lever <chuck.lever@oracle.com>
    tls: Honor O_NONBLOCK in tls_sw_splice_read()

Josef Bacik <josef@toxicpanda.com>
    block: don't enter reclaim under rq_qos_mutex

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return complete and aligned stream information

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: keep TX and RX hardware offload on the same device

Zhewei Yuan <yzwlhm@gmail.com>
    tcp: Fix fastreuse cache initialization on first bind

Tao Gong <gongtao0607@gmail.com>
    net: dsa: mt7530: trap frames to conduit in MFC on EN7581 and AN7583

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Prevent recursive call of remote_cpus_update() via update_cpumasks_hier()

Tal Zussman <tz2294@columbia.edu>
    ceph: wait for pending fscache write in write_folio_nounlock()

Pooyan Azad <pooyan.azadparvar@gmail.com>
    zram: fix short reads from block_state

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    gpiolib: Propagate emulated drive errors when setting arrays

Ian Rogers <irogers@google.com>
    perf lock contention: Filter events before creating lock_stat

Ajanesh Lal <ajaneshlal3@gmail.com>
    ALSA: hda/realtek: Add mute and mic-mute LEDs for HP ENVY 16 (103c:8be5)

Sasha Levin <sashal@kernel.org>
    selftests/proc: proc-pid-vm: fix unused variable warning on non-x86

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix durable reconnects for root shares

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: cache the resolved share path for durable reconnects

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: disconnect on invalid encryption transform flags

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix iface_list use-after-free during server reset

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
    cgroup/cpuset: Do housekeeping check before converting invalid partition to valid

Cen Zhang <zzzccc427@gmail.com>
    ALSA: aloop: Keep shared timer callbacks alive through close

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    netfilter: flowtable: reset transport header after nf_flow_encap_pop()

Adrian Ambrozewicz <aambrozewicz@nvidia.com>
    gpiolib: clear the event clock flags when a line is released

Woojin Ji <random6.xyz@gmail.com>
    bpf: Zero-extend the index in inlined bpf_get_func_arg()

Sasha Levin <sashal@kernel.org>
    locking/atomic: arc, hexagon, openrisc: Define arch_cmpxchg_local()

Josef Bacik <josef@toxicpanda.com>
    bpf: Follow the head if an skb is written from a slice

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't take a dynptr argument for a local dynptr

Josef Bacik <josef@toxicpanda.com>
    bpf: Let bpf_dynptr_write() mark a global function

Josef Bacik <josef@toxicpanda.com>
    bpf, cpumap: Hold the device of frames in the queue

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't let an extension reach further into the context than its target

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

Josef Bacik <josef@toxicpanda.com>
    bpf: Use the frame mem type in devmap egress XDP

Viktor Menshin <ripeeerr@gmail.com>
    ALSA: hda/realtek: Fix hiss/crackle on Lenovo Xiaoxin 14 GT (17aa:3912)

Ju Nan <junan76@163.com>
    pinctrl: stm32: Fix the unit of the hwspinlock timeout

Eric Dumazet <edumazet@kernel.org>
    tcp: use the echoed source route in cookie_v4_check()

Li RongQing <lirongqing@baidu.com>
    ublk: use global index for reported zones

Myeonghun Pak <mhun512@gmail.com>
    ASoC: rt5645: Shut down the button timer on removal

Pengpeng Hou <hppiscas@163.com>
    irqchip/mst-intc: Validate the DT interrupt range

David Howells <dhowells@redhat.com>
    rxrpc: Fix sendmsg length

David Howells <dhowells@redhat.com>
    rxrpc: Fix aborting in rxperf test server

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    iommufd: Keep reserved IOVA ranges when a replace within one IOAS fails

Kevin Dewald <kevin@simpleble.org>
    Bluetooth: hci_event: Fix LE link drop on remote features command status

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: fix mesh adv timeout units

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Add missing symsrc__destroy() for libbfd

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Fix symbol loading from libbfd

Jiale Yao <yaojiale02@163.com>
    wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup

Joonhoe Kim <26rote@gmail.com>
    ASoC: codecs: wcd939x: read the SoundWire port switches per channel

Guanghui Yang <3497809730@qq.com>
    btrfs: roll back sprout setup after device add failure

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: align real_num_tx_queues to mqprio configuration

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: set real_num_tx_queues to max(offset + count)

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Fix PM refcnt and autosuspend issues at device probe/remove

Kees Cook <kees@kernel.org>
    seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: arm_mhu_db: Remove redundant mbox_controller_unregister() on probe failure

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: qcom-ipcc: Remove redundant mbox_controller_unregister() on probe failure

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Preserve the LCPA I/O address space

Jacob Moroni <jmoroni@google.com>
    RDMA/core: Clear driver_udata before destroying objects in rdma_core

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq

Maksim Krasutski <krasutskimaksim@gmail.com>
    ALSA: hda/realtek: Fix mute LEDs on HP ENVY 17-cr1xxx

Matthew Wood <thepacketgeek@gmail.com>
    bpf, arm64: Fix racy plt target update in bpf_arch_text_poke()

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Ensure default group reports tasks on monitor-only systems

Leon Romanovsky <leon@kernel.org>
    PCI/P2PDMA: Do not tear down the allocate attribute on registration failure

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-direct: Restore arch_dma_alloc() for the DMA_ATTR_NO_KERNEL_MAPPING case

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: reject zero RNR/MBSSID elements

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use linked list for jack table

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
    wifi: mt76: mt7996: fix the hw-queues debugfs queue requests

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: enable the SKU power limit table

Aamir Ahmed <elb12345@hotmail.co.uk>
    wifi: mt76: mt7996: validate TLV length in mt7996_mcu_ie_countdown()

Andrei Vagin <avagin@google.com>
    proc: report SIGEV_NONE in /proc/pid/timers if target task has died

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Recover coalesced cyclic callbacks

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix cyclic transfer residue

Roman Demidov <roman.demidov.nn@gmail.com>
    drm/msm/a6xx: check pm_runtime_resume_and_get during resume

Qing Ming <a0yami@mailbox.org>
    dlm: validate node weights before building member array

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/a5xx: don't read the GPMU registers on GPUs without a GPMU

Marco Giunta <marco_giunta@outlook.it>
    ASoC: aw88399: skip BSTS check when boost converter is bypassed

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Don't rb_erase() a never-inserted stream node

Shawn Lin <shawn.lin@rock-chips.com>
    phy: rockchip: naneng-combphy: Fix TX detect RX termination errata

Yao Zi <ziyao@disroot.org>
    phy: rockchip: naneng-combphy: Add SoC prefix to register definitions

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Advance the write pointer over the data written

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Enforce physical block alignment of zoned writes

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Roll back freplace link state when bpf_arch_text_poke() fails

Hal Feng <hal.feng@starfivetech.com>
    riscv: dts: starfive: Correct pwm nodes

Guodong Xu <guodong@riscstar.com>
    riscv: dts: starfive: jh7110-common: revised device node

Yichong Chen <chenyichong@uniontech.com>
    debugfs: make debugfs_create_str() read-only

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mei: vsc-tp: initialize IRQ state before requesting interrupt

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: Zerorize dmb at allocation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix UAC2 mixer unit request handling

Ian Rogers <irogers@google.com>
    perf evsel: Clamp sample_id size for ksymbol, bpf, and text_poke events

Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    powerpc/interrupt: Use early_radix_enabled() in NMI real-mode guard

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set QP event handler before firmware QPC insertion

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent

Yishai Hadas <yishaih@nvidia.com>
    RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access

Phil Sutter <phil@nwl.cc>
    netfilter: nfnetlink: Fix for interrupted hook dumps

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: fix FD_SET(), FD_CLR() and FD_ISSET() on 64-bit

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Rebase the exception callback subprog when dead subprogs are removed

Andrei Vagin <avagin@google.com>
    x86/fpu: Fix potential underflow in xstate_calculate_size()

Sudeep Holla <sudeep.holla@kernel.org>
    ACPI: PCC: Free channel on OpRegion deactivation

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-asus-vivobook-s15: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1e78100-t14s: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-crd: Mark the EC reset gpio as reserved

Yibo Tan <lhfff@tju.edu.cn>
    sysctl: unregister tables before freeing bitmap

Tengda Wu <wutengda@huaweicloud.com>
    perf llvm: Fix memory leak of args->fileloc in symbol__disassemble_llvm()

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

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: fix clk leak on error in audsys_clk_register

Puranjay Mohan <puranjay@kernel.org>
    bpf: Look at frame 0 when telling async callback entries apart

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check fastcall stack contract once for all stack accesses

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Keep target extended until its last freplace link detaches

Myeonghun Pak <mhun512@gmail.com>
    serial: sh-sci: Unregister UART on sysfs setup failure

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - hold cfg->lock when accessing config sections

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: unwind incomplete receive startup

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Process multiple IBIs per interrupt

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/connector: hdmi: Handle reset() state allocation failure

Guixin Liu <kanie@linux.alibaba.com>
    cxl/region: Unregister the pmem region when the bridge is unbound

Guixin Liu <kanie@linux.alibaba.com>
    cxl/cdat: Fix uninitialized stack use in bandwidth gathering

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: fix amd_sof_acp_probe() error unwind ordering

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: fix amd_sof_acp_remove() teardown ordering

Shakeel Butt <shakeel.butt@linux.dev>
    kernfs: don't repeat or skip an entry when readdir resumes

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1015: make control calibration failures observable

Alison Schofield <alison.schofield@intel.com>
    cxl/port: Bound switch decoder target array access by nr_targets

Alison Schofield <alison.schofield@intel.com>
    cxl/hdm: Restore commit_end when decoder enumeration fails

Pengpeng Hou <pengpeng@iscas.ac.cn>
    phy: samsung: usbdrd: propagate GS101 PIPE3 lock failures

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Rearrange acpi_bind_one() to avoid breakage

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Carry out companion lookup under bus_type_sem

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Rework the success message in acpi_device_notify()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Reduce debug noise from acpi_device_notify()

Thomas Huth <thuth@redhat.com>
    crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data

Eric Dumazet <edumazet@google.com>
    sit: charge ip_tunnel_prl_entry allocations to memcg

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Free sw_desc_pool on desc_pool_v alloc failure

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Fix PM rollback on sw_desc_pool alloc failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: sta32x: make power restoration transactional

Dave Jiang <dave.jiang@intel.com>
    ACPI: APEI: GHES: Validate memory error section length before payload access

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: don't seed an S1G sta's last_rate

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete

Jingbo Xu <jefflexu@linux.alibaba.com>
    fuse: don't bump attr_version for async direct read completion

Davidlohr Bueso <dave@stgolabs.net>
    cxl/test: Map mock device nodes to an online node

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/panthor: Revisit reqs_lock handling in flush/reset paths

Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
    nvme-tcp: fix use-after-free in nvme_tcp_free_ctrl()

Guixin Liu <kanie@linux.alibaba.com>
    nvme-tcp: Validate the queue state under the queue lock in the address attribute

Hui Su <sh_def@163.com>
    perf evsel: Restrict incremental open error unwind

Salvatore Dipietro <dipiets@amazon.it>
    mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations

Alexandr <youdoit@mail.ru>
    ALSA: hda/realtek: Enable mute and mic-mute LEDs on HP ENVY 17-cr0xxx

Josef Bacik <josef@toxicpanda.com>
    mm/userfaultfd: wake all waiters on unregister

Cunhao Lu <1579567540@qq.com>
    can: skb: make echo skb freeing safe in any IRQ context

Daejun Park <daejun7.park@samsung.com>
    xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Disable linked plane sel fetch as well

Yingjie Wang <1075151112@qq.com>
    nvmet-tcp: validate the TLS handshake timeout

Sinan Turunc <enscrpt@pm.me>
    ALSA: ua101: Bound packet copies by the PCM buffer size

Fabricio Akio <fabricioakio@gmail.com>
    power: supply: qcom_smbx: set the charge enable after software control

Shen Lichuan <shenlichuan@vivo.com>
    power: supply: Correct multiple typos in comments

Jianping Li <jianping.li@oss.qualcomm.com>
    misc: fastrpc: Allocate entire reserved memory for Audio PD in probe

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: take rcu_read_lock in the USB/SDIO tx completion path

Sean Young <sean@mess.org>
    media: rc: Add missing locking for keymap

Sean Young <sean@mess.org>
    media: rc: Replace open coded krealloc() for keymap

Sean Christopherson <seanjc@google.com>
    x86/cpuid: Mark CPUID function 0x23 as being indexed

David Howells <dhowells@redhat.com>
    rxrpc: Fix lack of short-send handling in rxrpc_kernel_send_data()

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: validate NT transaction response layout and offsets

Paulo Alcantara <pc@manguebit.org>
    smb: client: reclaim credits for decrypted reads with no matching mid

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix folio is used after pte_unmap_unlock()

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix and improve zcrypt reply message verification checks

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Make apfs a real unsigned int field

Christian Brauner <brauner@kernel.org>
    coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps

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

Iustin Stolniceanu <iustin.stolniceanu@analog.com>
    net: phy: c45: select BASE-T1 type for the forced speed

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: IPsec, don't match upper proto selectors in crypto offload TX

Jiahao Xu <xujiahao@cmss.chinamobile.com>
    net: usb: cdc_ncm: don't underflow the NDP room check

Wenbo Sun <sunwenbo@cmss.chinamobile.com>
    amt: use ipv6_hdr() in amt_mldv1_leave_handler()

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().

Uri Dar <udar@nvidia.com>
    net/mlx5: Lag, Return error when enabling MPESW without LAG support

Junyoung Jang <graypanda.inzag@gmail.com>
    igmp: use the joined device when leaving a multicast group

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

Eric Dumazet <edumazet@google.com>
    net: rfs: add sock_rps_delete_flow() helper

Eric Dumazet <edumazet@kernel.org>
    fou: gue: check IP version of held packets for direct IP encapsulation

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Serialize TC and IPsec offload exclusion counters

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

Umang Pokhriyal <umangpokhriyall@gmail.com>
    tun: delete the flow entries of the moved queue on detach

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

Chenguang Zhao <zhaochenguang@kylinos.cn>
    i40e: xsk: fix multi-buffer XDP_PASS skb construction

Kyle Zeng <kylebot@openai.com>
    net: skbuff: preserve fclone lifetime when freeing stolen heads

Mark Korenberg <socketpair@gmail.com>
    ublk: publish a new device by its id only once it is set up

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Balance queue accounting when relocating a task

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Balance switch queue length on transport removal

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: preserve transport security policy when cloning clients

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: preserve timeout policy when cloning clients

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

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't wait for ordered extents in do_zone_finish()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: only change active zone counter on successful (de)activation

Samuel Leyva <samuelslg03idk@gmail.com>
    ASoC: amd: acp: es83xx: Enable speaker amplifier after the codec output

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: add soundwire wake irq handling

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: enable soundwire host wake irq mask

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: enable ACP_PME_EN register for ACP7.0 & ACP7.1 platforms

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: add ACP7.1 platform support

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: remove else condition in resume sequence

Tyler Baker <tyler.baker@oss.qualcomm.com>
    ASoC: soc-core: copy the DAI link names into the card

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: return -ENOENT from of_gpio_count() stub

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Toggle the D3Cold enable flag at runtime resume

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe: Rebind BOs evicted before the first LR queue

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

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Force sync policy boost with global boost on sysfs update

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: staticize cpufreq_boost_trigger_state()

Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
    iommu/amd: Clear amd_iommu_snp_en if snp_rmptable_init() fails

Benjamin Segall <bsegall@google.com>
    perf: Fix racy update of cpc->hrtimer_interval

Peter Zijlstra <peterz@infradead.org>
    perf/core: Detach 'struct perf_cpu_pmu_context' and 'struct pmu' lifetimes

Peter Zijlstra <peterz@infradead.org>
    perf/core: Add this_cpc() helper

Peter Zijlstra <peterz@infradead.org>
    perf/core: Merge struct pmu::pmu_disable_count into struct perf_cpu_pmu_context::pmu_disable_count

Peter Zijlstra <peterz@infradead.org>
    perf/core: Simplify perf_pmu_register()

Peter Zijlstra <peterz@infradead.org>
    perf/core: Simplify the perf_pmu_register() error path

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Avoid context migration from non-owners

Peter Zijlstra <peterz@infradead.org>
    locking/osq: Fix unlink queue corruption

Peter Zijlstra <peterz@infradead.org>
    locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering

Thomas Fourier <fourier.thomas@gmail.com>
    net/mlx5e: TC, Fix double free of branch in failure

Eric Dumazet <edumazet@kernel.org>
    tcp: bound snd_cwnd_clamp to TCP_MAX_SND_CWND

Hui Su <sh_def@163.com>
    sched/topology: Balance cluster static-key updates

Hui Su <sh_def@163.com>
    sched/pelt: Fix u32 truncation of the PELT period count

Siddharth Chintamaneni <sidchintamaneni@gmail.com>
    fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()

Max Kellermann <max.kellermann@ionos.com>
    fs/read_write: make default_llseek() killable

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

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: SB1250: Validate and update IRQ affinity

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Alchemy: Save the Ethernet address before reusing PROM memory

Imre Kaloz <kaloz@kernel.org>
    MIPS: SGI-IP30: fix the defconfig defaults for the Bridge PROM and RTC

Rosen Penev <rosenp@gmail.com>
    MIPS: Avoid dead code/data elimination when using recordmcount

Eric Dumazet <edumazet@kernel.org>
    tcp: ipv6: free ireq->ipv6_opt after an RCU grace period

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

Qingfang Deng <qingfang.deng@linux.dev>
    tcp: initialize send sequence numbers before deferring TFO

Cheng Yongkang <teel4res@gmail.com>
    net: bridge: disable MRP ports before the FDB flush in del_nbp()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: set XDP metadata length on the page_pool RX path

Furong Xu <0x1207@gmail.com>
    net: stmmac: Switch to zero-copy in non-XDP RX path

Furong Xu <0x1207@gmail.com>
    net: stmmac: Unexport stmmac_rx_offset() from stmmac.h

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

Eric Dumazet <edumazet@google.com>
    inet: consolidate inet_csk_clone_lock()

Eric Dumazet <edumazet@google.com>
    inet: reduce inet_csk_clone_lock() indent level

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Flush exception route while replacing nexthop.

Zhou Minqiang <zhouminqiang2@huawei.com>
    PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove

Avi Weiss <thnkslprpt@gmail.com>
    net: skbuff: reject zero MPLS TTL before decrementing

Guillaume Nault <gnault@redhat.com>
    tcp: Fix dup-ack detection on non-SACK bidirectional data transfer.

Hungyu Lin <dennylin0707@gmail.com>
    isofs: handle Rock Ridge long-form dates before 1900

James Clark <jjc@jclark.com>
    net: ethernet: ti: am65-cpts: adjust perout genf following ptp changes

Chris Mason <mason@kernel.org>
    nvmet-rdma: disconnect a queue on device removal

Bjorn Helgaas <bhelgaas@google.com>
    nvme: fix various comment typos

Chris Mason <mason@kernel.org>
    nvmet-rdma: queue the release work under the mutex

Chris Mason <mason@kernel.org>
    nvmet-rdma: take a device off the list last

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: limit the connections accepted per work run

Chris Mason <mason@kernel.org>
    nvmet-rdma: disconnect only established queues

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: ask for the TLS record type on every receive

Alexander Goodkind <alex@goodkind.io>
    net: ethernet: mediatek: preserve sibling PPE bindings

Florian Fainelli <florian.fainelli@broadcom.com>
    net: dsa: b53: Enable IGMP and MLD control packet CPU copies

Kyle Zeng <kylebot@openai.com>
    tcp: wait for TIME_WAIT teardown before freeing per-netns ehash

Niklas Cassel <cassel@kernel.org>
    null_blk: don't finish zones to set them read-only or offline

Niklas Cassel <cassel@kernel.org>
    null_blk: fix opening closed zones at the active zone limit

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: reject negative tv_usec in SO_VM_SOCKETS_CONNECT_TIMEOUT

Avi Weiss <thnkslprpt@gmail.com>
    block: report the correct discard alignment in sysfs

zhangguopeng <zhangguopeng@kylinos.cn>
    block: Replace sprintf() with sysfs_emit()

Zizhi Wo <wozizhi@huawei.com>
    block: partitions: reject GPT entries with starting_lba > ending_lba

Shao Mingyin <shao.mingyin@zte.com.cn>
    virtio-blk: Fix zone append sector reporting in batched completion

John Ogness <john.ogness@linutronix.de>
    printk: Avoid multiple unregistration in unregister_console_locked()

Petr Mladek <pmladek@suse.com>
    printk: Allow to use the printk kthread immediately even for 1st nbcon

Josef Bacik <josef@toxicpanda.com>
    ext2: only flush DIRSYNC directories on every change

Mingbing Zhai <zhaimingbing@cmss.chinamobile.com>
    virtio_balloon: initialize wakeup_lock before virtqueues are set up

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-vdpa: initialize state before publishing cdev

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost: reject backend enable without a kick file

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-scsi: reject delayed virtqueue setup

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-scsi: validate event queue descriptor direction

Shuai Zhang <shuai.zhang@oss.qualcomm.com>
    power: sequencing: qcom-wcn: increase WCN7850 power-up delay

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    power: sequencing: qcom-wcn: improve support for wcn6855

Eric Dumazet <edumazet@kernel.org>
    soreuseport: annotate data-races around reuse->socks[] and num_socks

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    ksmbd: require NUL-terminated EA names

Aaditya Kansal <aadityakansal390@gmail.com>
    ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH in smb server

Bart Van Assche <bvanassche@acm.org>
    mctp i3c: Fix locking in an error path

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

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: take a private, writable frame before rewriting it in place

Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
    gpio: mpc8xxx: Fix potential use-after-free of IRQ domain

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: mpc8xxx: use a helper variable to store the address of pdev->dev

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: release the in-flight slot of a stale TX skb

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    regulator: qcom_spmi: don't take a sleeping lock in the SAW IPI

Yuho Choi <oss.patchbox@gmail.com>
    virtio_blk: Reset device on probe error paths after DRIVER_OK

Sergii Ushakov <sergiiushakov@google.com>
    virtio-blk: clamp max_segments to virtqueue ring size

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: drop the parent's vq callback before the call fd is released

Sean Christopherson <seanjc@google.com>
    irqbypass: Take ownership of producer/consumer token tracking

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost: reject invalid IOTLB update permissions

Xiang Mei <xmei5@asu.edu>
    vdpa: fix double free of the reply skb in vdpa_nl_cmd_dev_config_get_doit()

Maoxia <2312891301@qq.com>
    virtio_pci: add missing newline to the pmcsr error message

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: do not relock event vq mutex on send_evt fallback

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: preserve event ordering

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa: invalidate DMA mappings before releasing memory

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim: serialize IOTLB updates with dataplane access

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
    net: stmmac: copy XDP metadata in AF_XDP zero-copy RX

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: drop split frames on AF_XDP zero-copy RX

Furong Xu <0x1207@gmail.com>
    net: stmmac: Set dma_sync_size to zero for discarded frames

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

Guillaume Nault <gnault@redhat.com>
    ipv4: Convert ip_route_input_noref() to dscp_t.

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them

Weiming Shi <bestswngs@gmail.com>
    netfilter: nft_fwd_netdev: use recursion counter in neigh egress path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit

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

Filippo Falezza <effeffe99@gmail.com>
    wifi: ath10k: Stop unanswered temperature reads

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: do not store the create fid on special files

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: fall back to the normal open path for non-regular files

Matthew Whitehead <tedheadster@gmail.com>
    scsi: aha1542: Remove unneeded scsi_dma_unmap() call

Giuseppe Piscitelli <ooonea@gmail.com>
    scsi: scsi_debug: Drain target cleanup before module exit

Imre Kaloz <kaloz@kernel.org>
    scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: ath9k_htc: start ANI when an AP interface begins to beacon

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

Zijun Hu <quic_zijuhu@quicinc.com>
    fs/fs_parse: Delete macro fsparam_u32hex()

Joshua Murphy <joshuamurphy@posteo.net>
    net/9p/fd: support ipv6 for trans=tcp

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

Jens Axboe <axboe@kernel.dk>
    io_uring: enable toggle of iowait usage when waiting on CQEs

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

KP Singh <kpsingh@kernel.org>
    bpf: Reject NULL data/sig in bpf_verify_pkcs7_signature

Zizhi Wo <wozizhi@huawei.com>
    fs: aio: reject partial mremap to avoid Null-pointer-dereference error

Krittikun Wongnin <krittikunwongnin@gmail.com>
    ACPI: PM: Add Acer Aspire A515-53G to dmi_leave_unused_power_resources_on[]

Hakan Abay <hakan.abay84@gmail.com>
    ACPI: PM: Add unused power resource quirk for Casper Excalibur G900

Matthias Dittrich <dittrich.m@gmx.net>
    ACPI: PM: Add quirk for Acer Swift 3 SF314-56G (MX250)

Baokun Li <libaokun@linux.alibaba.com>
    writeback: use a per-sb counter to drain inode wb switches at umount

Jerome Marchand <jmarchan@redhat.com>
    bpf: Specify access type of bpf_sysctl_get_name args

Shuran Liu <electronlsr@gmail.com>
    bpf: Fix verifier assumptions of bpf_d_path's output buffer

Zesen Liu <ftyghome@gmail.com>
    bpf: Fix memory access flags in helper prototypes

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Pengpeng Hou <hppiscas@163.com>
    irqchip/sifive-plic: Avoid signed shift in interrupt enable mask

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Check cs flags.

Chris Mason <mason@kernel.org>
    mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: move custom expectation support to helper

Florian Westphal <fw@strlen.de>
    netfilter: nft_ct: expectation timeouts are passed in milliseconds


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   5 +
 Documentation/arch/arm64/silicon-errata.rst        |   4 +
 .../bindings/iio/adc/aspeed,ast2600-adc.yaml       |  17 +
 Documentation/filesystems/mount_api.rst            |   1 -
 Documentation/networking/rxrpc.rst                 |   8 +-
 Documentation/networking/tls-offload.rst           |  16 +-
 Documentation/trace/kprobes.rst                    |   2 +-
 Makefile                                           |   4 +-
 arch/arc/include/asm/cmpxchg.h                     |   4 +
 arch/arm64/Kconfig                                 |  32 ++
 .../dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts     |   1 +
 .../boot/dts/qcom/x1e80100-asus-vivobook-s15.dts   |   1 +
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |   1 +
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |  20 +
 arch/arm64/kernel/cpufeature.c                     |   3 +-
 arch/arm64/kernel/ptrace.c                         |   8 +-
 arch/arm64/kernel/topology.c                       |   3 +-
 arch/arm64/mm/proc.S                               |   8 +
 arch/arm64/net/bpf_jit_comp.c                      |  32 +-
 arch/arm64/tools/cpucaps                           |   1 +
 arch/hexagon/include/asm/cmpxchg.h                 |   6 +
 arch/loongarch/power/hibernate.c                   |   6 +
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/alchemy/common/prom.c                    |  23 +-
 arch/mips/configs/ip30_defconfig                   |   9 +-
 arch/mips/sibyte/sb1250/irq.c                      |   3 +
 arch/openrisc/include/asm/cmpxchg.h                |   2 +
 arch/powerpc/include/asm/interrupt.h               |   5 +-
 arch/powerpc/kernel/watchdog.c                     |   3 +
 arch/riscv/boot/dts/starfive/jh7100-common.dtsi    |  28 +-
 arch/riscv/boot/dts/starfive/jh7100.dtsi           |  67 ++-
 arch/riscv/boot/dts/starfive/jh7110-common.dtsi    |  32 +-
 arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts |  21 +
 .../boot/dts/starfive/jh7110-pine64-star64.dts     |  21 +
 .../dts/starfive/jh7110-starfive-visionfive-2.dtsi |  24 +
 arch/riscv/boot/dts/starfive/jh7110.dtsi           |  67 ++-
 arch/x86/events/amd/uncore.c                       |   2 +-
 arch/x86/include/asm/cpuid.h                       |   1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   2 +-
 arch/x86/kernel/fpu/xstate.c                       |   8 +-
 arch/x86/kernel/ldt.c                              |  12 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 block/blk-cgroup.c                                 |  13 +-
 block/blk-iocost.c                                 |   5 +-
 block/blk-iolatency.c                              |   3 +-
 block/blk-mq.c                                     |  18 +-
 block/blk-sysfs.c                                  |  24 +-
 block/blk-throttle.c                               |   3 +-
 block/genhd.c                                      |  30 +-
 block/partitions/efi.c                             |   1 +
 crypto/essiv.c                                     |   2 +-
 drivers/accel/ivpu/ivpu_pm.c                       |   9 +-
 drivers/acpi/acpi_pcc.c                            |  13 +
 drivers/acpi/apei/ghes.c                           |  41 ++
 drivers/acpi/glue.c                                | 132 +++--
 drivers/acpi/power.c                               |  38 ++
 drivers/acpi/scan.c                                | 108 +++-
 drivers/ata/libata-core.c                          |   8 +-
 drivers/ata/libata-eh.c                            |  16 +-
 drivers/ata/libata-sata.c                          |   2 +-
 drivers/ata/libata-scsi.c                          | 178 ++++---
 drivers/base/power/runtime.c                       |   8 +-
 drivers/base/swnode.c                              |   7 +-
 drivers/block/null_blk/zoned.c                     |  48 +-
 drivers/block/ublk_drv.c                           |  25 +-
 drivers/block/virtio_blk.c                         |  69 ++-
 drivers/block/zram/zram_drv.c                      | 115 +++--
 drivers/bluetooth/btintel.c                        |  24 +-
 drivers/bluetooth/btmtk.c                          |  49 +-
 drivers/bluetooth/hci_qca.c                        |   5 +
 drivers/char/tpm/eventlog/acpi.c                   |   4 +-
 drivers/char/tpm/eventlog/tpm1.c                   |   7 +
 drivers/char/tpm/tpm2-sessions.c                   |   4 +-
 drivers/comedi/drivers/addi_apci_1500.c            |   2 +-
 drivers/comedi/drivers/ni_660x.c                   |   3 +-
 drivers/comedi/drivers/ni_tio.c                    |   2 +-
 drivers/comedi/drivers/vmk80xx.c                   |  25 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   9 +-
 drivers/cpufreq/cpufreq.c                          |  21 +-
 drivers/cpufreq/intel_pstate.c                     |  14 +-
 drivers/crypto/caam/caampkc.c                      |  75 ++-
 drivers/crypto/inside-secure/safexcel_hash.c       |   3 +
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |  49 +-
 drivers/cxl/core/cdat.c                            |   8 +-
 drivers/cxl/core/hdm.c                             |  23 +-
 drivers/cxl/core/port.c                            |  20 +-
 drivers/cxl/core/region.c                          |   6 +-
 drivers/dma/ste_dma40.c                            | 179 ++++++-
 drivers/dma/ste_dma40_ll.c                         |   8 +-
 drivers/dma/ste_dma40_ll.h                         |   2 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |  19 +-
 drivers/dpll/dpll_core.c                           |   3 +-
 drivers/firmware/cirrus/cs_dsp.c                   |   6 +
 drivers/gpio/gpio-brcmstb.c                        |   1 +
 drivers/gpio/gpio-mpc8xxx.c                        |  68 +--
 drivers/gpio/gpio-omap.c                           |  13 +-
 drivers/gpio/gpio-rockchip.c                       |  15 +-
 drivers/gpio/gpio-sodaville.c                      |   9 +-
 drivers/gpio/gpio-virtuser.c                       |  85 ++-
 drivers/gpio/gpiolib-of.h                          |   2 +-
 drivers/gpio/gpiolib.c                             |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h    |  56 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |  20 +-
 drivers/gpu/drm/bridge/sii902x.c                   |   8 +-
 drivers/gpu/drm/drm_connector.c                    |   5 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  27 +-
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h       |   2 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  49 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  33 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   7 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c   |  13 +
 .../gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c    |  20 -
 drivers/gpu/drm/panel/panel-visionox-r66451.c      |   4 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  12 +
 drivers/gpu/drm/panthor/panthor_gpu.c              |  61 +--
 drivers/gpu/drm/xe/xe_pci.c                        |   3 +
 drivers/gpu/drm/xe/xe_vm.c                         |   9 +-
 drivers/hwmon/aht10.c                              |   2 +-
 drivers/hwmon/max31760.c                           |  12 +-
 drivers/hwmon/pmbus/mp2975.c                       | 207 ++++----
 drivers/hwmon/scmi-hwmon.c                         |  12 +-
 drivers/hwmon/sy7636a-hwmon.c                      |   2 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |  40 +-
 drivers/iio/accel/adxl380.c                        |  11 +-
 drivers/iio/accel/kxsd9.c                          |   2 +-
 drivers/iio/addac/ad74413r.c                       |   2 +-
 drivers/iio/afe/iio-rescale.c                      |   3 +-
 drivers/iio/chemical/atlas-ezo-sensor.c            |   3 -
 .../iio/common/hid-sensors/hid-sensor-attributes.c |  14 +-
 drivers/iio/dac/mcp4725.c                          |   2 +
 drivers/iio/gyro/bmg160_core.c                     |   2 +-
 drivers/iio/humidity/am2315.c                      |  12 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |  24 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   2 +
 drivers/iio/imu/kmx61.c                            |   2 +-
 drivers/iio/industrialio-acpi.c                    |   9 +
 drivers/iio/industrialio-trigger.c                 |   4 +-
 drivers/iio/light/tsl2591.c                        |  32 +-
 drivers/iio/light/vcnl4035.c                       |   4 +-
 drivers/iio/magnetometer/mmc35240.c                |   3 +-
 drivers/iio/proximity/sx9310.c                     |   2 +-
 drivers/iio/proximity/sx9324.c                     |  13 +-
 drivers/iio/temperature/mlx90614.c                 |   2 +-
 drivers/infiniband/core/rdma_core.c                |   2 +
 drivers/infiniband/hw/mlx5/fs.c                    |   3 +
 drivers/infiniband/hw/mlx5/main.c                  |  50 +-
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
 drivers/iommu/iommufd/device.c                     |   8 +-
 drivers/irqchip/irq-mst-intc.c                     |   3 +
 drivers/irqchip/irq-sifive-plic.c                  |   2 +-
 drivers/mailbox/arm_mhu_db.c                       |   1 -
 drivers/mailbox/qcom-ipcc.c                        |   5 +-
 drivers/md/dm-cache-metadata.c                     |   4 +-
 drivers/md/dm-cache-target.c                       |   1 +
 drivers/md/dm-crypt.c                              |  22 +-
 drivers/md/dm-integrity.c                          |  30 +-
 drivers/md/dm-log-userspace-base.c                 |   6 +-
 drivers/md/dm-mpath.c                              |   6 +-
 drivers/md/dm-raid.c                               |   5 +-
 drivers/md/dm-snap.c                               |  18 +-
 drivers/md/dm-sysfs.c                              |  17 +-
 drivers/md/dm-thin-metadata.c                      |   5 +-
 drivers/md/dm-thin.c                               |   7 +-
 drivers/md/dm-verity-target.c                      |  27 +-
 drivers/md/dm-zoned-reclaim.c                      |  18 +-
 drivers/md/dm.c                                    |  15 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  13 +-
 drivers/md/persistent-data/dm-btree.c              |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   9 +-
 drivers/media/rc/rc-main.c                         | 125 +++--
 drivers/misc/bcm-vk/bcm_vk_sg.c                    |  43 +-
 drivers/misc/fastrpc.c                             | 198 +++----
 drivers/misc/ibmvmc.c                              |  16 +-
 drivers/misc/mei/vsc-tp.c                          |  15 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   7 +-
 drivers/mmc/host/meson-gx-mmc.c                    |  26 +-
 drivers/mmc/host/mmci.c                            |   4 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  17 +
 drivers/net/amt.c                                  |  61 +--
 drivers/net/bonding/bond_main.c                    |  24 +-
 drivers/net/can/dev/skb.c                          |   6 +-
 drivers/net/dsa/b53/b53_common.c                   |  69 ++-
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/b53/b53_regs.h                     |  17 +
 drivers/net/dsa/bcm_sf2.c                          |   5 +
 drivers/net/dsa/microchip/ksz_common.c             |   1 +
 drivers/net/dsa/mt7530.c                           |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  13 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   3 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  51 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  13 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   5 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |  27 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  45 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  19 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/lib/macsec_fs.c    |  41 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h        |   4 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |  16 +
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   6 +
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |  10 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   7 +-
 drivers/net/ethernet/realtek/8139cp.c              |   8 +-
 drivers/net/ethernet/sfc/ptp.c                     | 108 ++--
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |   2 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  15 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 121 +++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  18 +-
 drivers/net/ethernet/ti/am65-cpts.c                |  67 ++-
 drivers/net/gtp.c                                  |  22 +-
 drivers/net/hamradio/bpqether.c                    |  62 ++-
 drivers/net/hyperv/rndis_filter.c                  |   6 +-
 drivers/net/ipa/ipa_interrupt.c                    |  12 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +-
 drivers/net/ipvlan/ipvlan_l3s.c                    |   6 +-
 drivers/net/macsec.c                               |  15 +-
 drivers/net/mctp/mctp-i3c.c                        |   3 +-
 drivers/net/phy/phy-c45.c                          |  46 +-
 drivers/net/ppp/ppp_generic.c                      |  95 +++-
 drivers/net/ppp/pppoe.c                            |   1 +
 drivers/net/team/team_core.c                       |  12 +-
 drivers/net/tun.c                                  |  12 +-
 drivers/net/usb/cdc_ncm.c                          |   4 +-
 drivers/net/wireless/ath/ath10k/core.c             |   1 +
 drivers/net/wireless/ath/ath10k/thermal.c          |   9 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |   2 +
 drivers/net/wireless/ath/ath11k/ahb.c              |   5 +-
 drivers/net/wireless/ath/ath12k/core.c             |   3 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |   2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  12 +-
 drivers/net/wireless/ath/ath12k/mac.h              |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  26 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   3 +
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    | 296 +++++++----
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   5 +
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  46 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |  23 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |  28 +
 drivers/net/wireless/realtek/rtl8xxxu/core.c       | 140 ++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 drivers/nvme/host/core.c                           |   4 +
 drivers/nvme/host/fc.c                             |   4 +-
 drivers/nvme/host/tcp.c                            |  57 +-
 drivers/nvme/target/fc.c                           |   6 +-
 drivers/nvme/target/rdma.c                         |  57 +-
 drivers/nvme/target/tcp.c                          |  39 +-
 drivers/pci/p2pdma.c                               |   8 +-
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c | 294 ++++++-----
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  51 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  12 +-
 drivers/power/sequencing/pwrseq-qcom-wcn.c         | 103 +++-
 drivers/power/supply/88pm860x_battery.c            |   4 +-
 drivers/power/supply/ab8500_btemp.c                |   2 +-
 drivers/power/supply/charger-manager.c             |   2 +-
 drivers/power/supply/da9030_battery.c              |   4 +-
 drivers/power/supply/max8925_power.c               |   2 +-
 drivers/power/supply/qcom_battmgr.c                |   2 +-
 drivers/power/supply/qcom_smbx.c                   |  13 +-
 drivers/ptp/ptp_clock.c                            |   5 +
 drivers/ptp/ptp_kvm_x86.c                          |   7 +-
 drivers/ptp/ptp_private.h                          |   7 +-
 drivers/ptp/ptp_sysfs.c                            |  18 +-
 drivers/ptp/ptp_vclock.c                           | 121 +++--
 drivers/regulator/Kconfig                          |   1 +
 drivers/regulator/qcom_spmi-regulator.c            |  35 +-
 drivers/s390/block/dasd_eckd.c                     |   3 +-
 drivers/s390/block/dasd_ioctl.c                    |   4 +-
 drivers/s390/crypto/zcrypt_error.h                 |  28 +-
 drivers/s390/crypto/zcrypt_msgtype50.c             |  95 +++-
 drivers/s390/crypto/zcrypt_msgtype6.c              | 208 ++++++--
 drivers/s390/crypto/zcrypt_msgtype6.h              |   4 +-
 drivers/s390/net/ism_drv.c                         |   3 +-
 drivers/scsi/aha1542.c                             |   2 -
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   2 +-
 drivers/scsi/scsi_debug.c                          |  38 +-
 drivers/spi/spi-cadence-quadspi.c                  |   4 +-
 drivers/spi/spi-pic32-sqi.c                        |   3 +-
 drivers/spi/spi.c                                  |  40 +-
 .../staging/media/atomisp/pci/sh_css_param_dvs.c   |  11 +-
 .../media/atomisp/pci/sh_css_param_shading.c       |   4 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |  35 +-
 drivers/target/target_core_pr.c                    |   9 +-
 drivers/tty/serial/8250/8250_lpss.c                |   3 +
 drivers/tty/serial/rda-uart.c                      |   2 +
 drivers/tty/serial/samsung_tty.c                   |   8 +-
 drivers/tty/serial/sh-sci.c                        |   8 +-
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
 drivers/vfio/pci/vfio_pci_intrs.c                  |   9 +-
 drivers/vhost/scsi.c                               |  42 +-
 drivers/vhost/test.c                               |   4 +
 drivers/vhost/vdpa.c                               |  95 +++-
 drivers/vhost/vhost.c                              |   3 +-
 drivers/virtio/virtio_balloon.c                    |   3 +-
 drivers/virtio/virtio_pci_common.c                 |   2 +-
 drivers/w1/masters/ds2482.c                        |  36 +-
 drivers/w1/slaves/w1_ds2805.c                      |   8 +-
 drivers/w1/slaves/w1_ds28e04.c                     |  18 +-
 drivers/w1/slaves/w1_therm.c                       |  37 +-
 drivers/w1/w1.c                                    |  21 +-
 drivers/w1/w1_int.c                                |   8 +-
 drivers/w1/w1_netlink.c                            |   8 +-
 drivers/xen/gntdev.c                               |   8 +-
 drivers/xen/grant-table.c                          |  37 +-
 drivers/xen/privcmd.c                              |  15 +
 drivers/xen/pvcalls-back.c                         |  26 +-
 fs/9p/v9fs.c                                       | 572 +++++++++++----------
 fs/9p/v9fs.h                                       |   7 +-
 fs/9p/vfs_dir.c                                    |   6 +-
 fs/9p/vfs_inode.c                                  |  10 +
 fs/9p/vfs_inode_dotl.c                             |  36 +-
 fs/9p/vfs_super.c                                  | 130 +++--
 fs/adfs/dir_fplus.c                                |   2 +
 fs/afs/rxrpc.c                                     |   8 +-
 fs/aio.c                                           |   7 +-
 fs/backing-file.c                                  |   7 +-
 fs/btrfs/fiemap.c                                  |   3 +-
 fs/btrfs/scrub.c                                   |   8 +-
 fs/btrfs/verity.c                                  |   2 +-
 fs/btrfs/volumes.c                                 |  37 ++
 fs/btrfs/zoned.c                                   |  38 +-
 fs/ceph/addr.c                                     |  12 +
 fs/coda/file.c                                     |   3 +-
 fs/coredump.c                                      |   5 +
 fs/debugfs/file.c                                  |  81 +--
 fs/dlm/config.c                                    |   9 +-
 fs/dlm/member.c                                    |  17 +-
 fs/eventpoll.c                                     |  11 +-
 fs/exfat/fatent.c                                  |  20 +-
 fs/ext2/dir.c                                      |   3 +
 fs/fs-writeback.c                                  |  97 ++--
 fs/fuse/file.c                                     |   2 +-
 fs/inode.c                                         |   3 +-
 fs/isofs/util.c                                    |   8 +-
 fs/kernfs/dir.c                                    |  40 +-
 fs/libfs.c                                         |   2 +-
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/inode.c                                     |  11 +-
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/nfs/pnfs.c                                      |   2 +-
 fs/ntfs3/index.c                                   |  10 +
 fs/overlayfs/namei.c                               |  13 +-
 fs/overlayfs/overlayfs.h                           |  11 +-
 fs/overlayfs/ovl_entry.h                           |   2 +
 fs/overlayfs/params.c                              |  48 +-
 fs/overlayfs/super.c                               |  37 +-
 fs/overlayfs/util.c                                |  12 +
 fs/proc/base.c                                     |  10 +-
 fs/proc/proc_sysctl.c                              |   5 +-
 fs/read_write.c                                    |  14 +-
 fs/smb/client/cifsacl.c                            |   5 +-
 fs/smb/client/cifsfs.c                             |  13 +-
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/cifsproto.h                          |   1 +
 fs/smb/client/cifssmb.c                            |  32 +-
 fs/smb/client/connect.c                            |   6 +-
 fs/smb/client/dfs.c                                |   2 +-
 fs/smb/client/file.c                               |  94 +++-
 fs/smb/client/sess.c                               |   4 +-
 fs/smb/client/smb2ops.c                            |   6 +-
 fs/smb/client/smb2pdu.c                            |  12 +-
 fs/smb/server/mgmt/share_config.c                  |  43 +-
 fs/smb/server/mgmt/share_config.h                  |   2 +
 fs/smb/server/smb2pdu.c                            | 223 +++++---
 fs/smb/server/transport_tcp.c                      |   7 +-
 fs/smb/server/vfs_cache.c                          |  16 +-
 fs/splice.c                                        |  11 +-
 fs/stat.c                                          |   6 +-
 fs/udf/super.c                                     |  19 +-
 fs/userfaultfd.c                                   |  22 +-
 fs/xfs/xfs_aops.c                                  |   2 +-
 fs/xfs/xfs_file.c                                  |   2 +-
 fs/xfs/xfs_inode.c                                 |   3 +-
 fs/xfs/xfs_iomap.c                                 |  20 +-
 fs/xfs/xfs_iomap.h                                 |   3 +-
 fs/xfs/xfs_pnfs.c                                  |   9 +-
 include/acpi/acpi_bus.h                            |   1 +
 include/linux/blk-mq.h                             |   3 +-
 include/linux/bpf.h                                |  14 +-
 include/linux/can/dev.h                            |   2 +-
 include/linux/can/skb.h                            |   4 +-
 include/linux/cpufreq.h                            |   5 -
 include/linux/fs.h                                 |   8 +
 include/linux/fs_parser.h                          |   2 +-
 include/linux/idr.h                                |  17 +
 include/linux/irqbypass.h                          |  35 +-
 include/linux/key.h                                |   3 +
 include/linux/mlx5/driver.h                        |   8 +-
 include/linux/mmzone.h                             |   3 +-
 include/linux/netdevice.h                          |   5 +
 include/linux/netdevice_xmit.h                     |   3 +
 include/linux/perf_event.h                         |   6 +-
 include/linux/ppp_channel.h                        |   1 +
 include/linux/sched.h                              |  16 +-
 include/linux/stat.h                               |   3 +
 include/linux/tcp.h                                |   3 +
 include/linux/uio.h                                |   8 +-
 include/media/rc-map.h                             |   2 -
 include/net/9p/client.h                            | 100 +++-
 include/net/9p/transport.h                         |   9 +-
 include/net/af_rxrpc.h                             |   5 +-
 include/net/bluetooth/hci_core.h                   |  15 +-
 include/net/dst_metadata.h                         |   2 +
 include/net/gro.h                                  |   8 +-
 include/net/gso.h                                  |   2 +-
 include/net/inet_connection_sock.h                 |   2 +
 include/net/netfilter/nf_conntrack_helper.h        |   1 +
 include/net/netfilter/nf_dup_netdev.h              |   2 +
 include/net/netfilter/nf_recursion.h               |  42 ++
 include/net/netns/netfilter.h                      |   1 +
 include/net/route.h                                |   7 +-
 include/net/rps.h                                  |  24 +
 include/net/sock.h                                 |  24 +-
 include/net/tcp.h                                  |   9 +
 include/net/tcp_ao.h                               |   3 +-
 include/net/xsk_buff_pool.h                        |   3 +
 include/sound/hda_codec.h                          |   6 +-
 include/trace/events/huge_memory.h                 |   6 +-
 include/trace/events/oom.h                         |   8 +-
 include/trace/events/rxrpc.h                       |   2 +-
 include/uapi/linux/io_uring.h                      |   2 +
 include/uapi/linux/mdio.h                          |  13 +-
 init/do_mounts_rd.c                                |   5 +
 io_uring/futex.c                                   |   1 +
 io_uring/io-wq.c                                   |  44 +-
 io_uring/io_uring.c                                |  39 +-
 io_uring/io_uring.h                                |   1 +
 io_uring/kbuf.c                                    |   1 +
 io_uring/napi.c                                    |  31 +-
 io_uring/rsrc.c                                    |  25 +-
 io_uring/rw.c                                      |   4 +-
 io_uring/timeout.c                                 |   3 +-
 kernel/bpf/arena.c                                 |  10 +-
 kernel/bpf/arraymap.c                              |   2 +-
 kernel/bpf/cgroup.c                                |  28 +-
 kernel/bpf/core.c                                  |  10 +-
 kernel/bpf/cpumap.c                                |  30 +-
 kernel/bpf/devmap.c                                |   1 +
 kernel/bpf/hashtab.c                               |  23 +-
 kernel/bpf/helpers.c                               |  11 +-
 kernel/bpf/stackmap.c                              | 102 ++--
 kernel/bpf/syscall.c                               |  19 +-
 kernel/bpf/trampoline.c                            |  19 +-
 kernel/bpf/verifier.c                              | 173 ++++++-
 kernel/cgroup/cpuset-internal.h                    |   5 +
 kernel/cgroup/cpuset.c                             |  27 +-
 kernel/dma/direct.c                                |  21 +-
 kernel/events/core.c                               | 215 ++++----
 kernel/locking/osq_lock.c                          |  62 ++-
 kernel/printk/internal.h                           |   2 +
 kernel/printk/nbcon.c                              |  26 +-
 kernel/printk/printk.c                             |  52 +-
 kernel/sched/deadline.c                            |  89 ++--
 kernel/sched/fair.c                                |   9 +-
 kernel/sched/idle.c                                |  16 +-
 kernel/sched/pelt.c                                |   2 +-
 kernel/sched/sched.h                               |  31 +-
 kernel/sched/syscalls.c                            |  42 +-
 kernel/sched/topology.c                            |  16 +-
 kernel/time/timekeeping.c                          |   8 +-
 kernel/trace/bpf_trace.c                           |  13 +-
 kernel/trace/trace_eprobe.c                        |  83 ++-
 kernel/trace/trace_fprobe.c                        |   8 +-
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.c                         |  12 +-
 kernel/trace/trace_probe_tmpl.h                    |  14 +-
 kernel/trace/trace_uprobe.c                        |   8 +-
 kernel/tsacct.c                                    |  10 +-
 lib/bootconfig.c                                   |   2 +-
 lib/iov_iter.c                                     |   6 +-
 lib/seq_buf.c                                      |   2 +-
 lib/test_sysctl.c                                  |   2 +-
 mm/gup.c                                           |  17 +-
 mm/internal.h                                      |  11 +-
 mm/khugepaged.c                                    |  14 +-
 mm/ksm.c                                           |   4 +
 mm/memory_hotplug.c                                |  44 +-
 mm/mempolicy.c                                     |   4 +-
 mm/page_alloc.c                                    |  44 +-
 net/9p/client.c                                    | 154 +-----
 net/9p/mod.c                                       |   2 +-
 net/9p/protocol.c                                  |  12 +-
 net/9p/trans_fd.c                                  | 194 ++-----
 net/9p/trans_rdma.c                                | 133 +----
 net/9p/trans_usbg.c                                |  14 +-
 net/9p/trans_virtio.c                              |   8 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/ax25/ax25_in.c                                 |  30 +-
 net/ax25/ax25_std_in.c                             |  23 +-
 net/batman-adv/bat_iv_ogm.c                        |   2 +-
 net/bluetooth/hci_conn.c                           |  23 +-
 net/bluetooth/hci_core.c                           |  66 ++-
 net/bluetooth/hci_event.c                          |  68 ++-
 net/bluetooth/hci_sync.c                           | 122 ++++-
 net/bluetooth/l2cap_core.c                         |   5 +-
 net/bluetooth/l2cap_sock.c                         |   3 +-
 net/bluetooth/mgmt.c                               |  45 +-
 net/bridge/br_arp_nd_proxy.c                       |   6 +-
 net/bridge/br_if.c                                 |   6 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   2 +-
 net/core/dev.c                                     |  12 +
 net/core/filter.c                                  | 143 ++++--
 net/core/gro.c                                     |  11 +-
 net/core/lwt_bpf.c                                 |  60 ++-
 net/core/netdev-genl.c                             |   6 +
 net/core/skbuff.c                                  |  18 +-
 net/core/sock_reuseport.c                          |  26 +-
 net/dccp/ipv4.c                                    |   3 -
 net/dccp/ipv6.c                                    |   9 +-
 net/ipv4/fib_trie.c                                |  14 +-
 net/ipv4/fou_core.c                                |  31 +-
 net/ipv4/igmp.c                                    |   2 +
 net/ipv4/inet_connection_sock.c                    |  93 ++--
 net/ipv4/inet_hashtables.c                         |  19 +-
 net/ipv4/inet_timewait_sock.c                      |   6 +-
 net/ipv4/ip_fragment.c                             |   4 +-
 net/ipv4/ip_input.c                                |   2 +-
 net/ipv4/ip_output.c                               |   8 +-
 net/ipv4/ip_tunnel.c                               |   6 +-
 net/ipv4/netfilter/arp_tables.c                    |   5 +-
 net/ipv4/netfilter/ip_tables.c                     |   5 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |  12 +
 net/ipv4/route.c                                   |  31 +-
 net/ipv4/syncookies.c                              |  12 +-
 net/ipv4/tcp.c                                     |   5 +-
 net/ipv4/tcp_fastopen.c                            |   2 +
 net/ipv4/tcp_input.c                               |  19 +-
 net/ipv4/tcp_ipv4.c                                |  27 +-
 net/ipv4/tcp_metrics.c                             |   3 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/udp.c                                     |   7 +-
 net/ipv4/udp_offload.c                             |   9 +-
 net/ipv4/xfrm4_input.c                             |   2 +-
 net/ipv4/xfrm4_protocol.c                          |   2 +-
 net/ipv6/calipso.c                                 |  12 +-
 net/ipv6/exthdrs.c                                 |   5 +-
 net/ipv6/exthdrs_core.c                            |   7 +-
 net/ipv6/icmp.c                                    |   7 +-
 net/ipv6/ip6_fib.c                                 |  50 +-
 net/ipv6/ip6_output.c                              |  13 +-
 net/ipv6/ip6mr.c                                   |  43 +-
 net/ipv6/mip6.c                                    |   9 +-
 net/ipv6/netfilter/ip6_tables.c                    |   5 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |  13 +
 net/ipv6/route.c                                   |  16 +-
 net/ipv6/seg6_iptunnel.c                           |  46 +-
 net/ipv6/seg6_local.c                              | 124 ++++-
 net/ipv6/sit.c                                     |   2 +-
 net/ipv6/tcp_ipv6.c                                |  17 +-
 net/ipv6/udp.c                                     |   5 +-
 net/iucv/af_iucv.c                                 |   9 +
 net/mac80211/airtime.c                             |   2 +
 net/mac80211/ibss.c                                |  27 +-
 net/mac80211/ieee80211_i.h                         |   4 +-
 net/mac80211/link.c                                |  13 +-
 net/mac80211/mlme.c                                |  12 +-
 net/mac80211/ocb.c                                 |  23 +-
 net/mac80211/rate.c                                |   1 -
 net/mac80211/rx.c                                  |   7 +-
 net/mac80211/s1g.c                                 |   8 -
 net/mac80211/tx.c                                  |   6 +
 net/mctp/af_mctp.c                                 |   2 +-
 net/mptcp/options.c                                |  12 +-
 net/netfilter/core.c                               |  17 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  12 +-
 net/netfilter/nf_conntrack_helper.c                |  20 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_dup_netdev.c                      |  18 +-
 net/netfilter/nf_flow_table_core.c                 |   1 +
 net/netfilter/nf_flow_table_ip.c                   |   2 +
 net/netfilter/nf_nat_masquerade.c                  |   4 +-
 net/netfilter/nf_tables_api.c                      |  21 +-
 net/netfilter/nf_tables_offload.c                  |   3 +
 net/netfilter/nfnetlink_hook.c                     |  20 +-
 net/netfilter/nft_ct.c                             | 119 ++++-
 net/netfilter/nft_fwd_netdev.c                     |  28 +-
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
 net/rxrpc/rxperf.c                                 |  32 +-
 net/rxrpc/sendmsg.c                                |  44 +-
 net/sched/act_ife.c                                |  13 +-
 net/sched/sch_teql.c                               |   9 +-
 net/sctp/sm_make_chunk.c                           |  43 +-
 net/sctp/sm_statefuns.c                            |  16 +-
 net/sctp/socket.c                                  |   4 +-
 net/sctp/stream.c                                  |   2 +
 net/sctp/stream_interleave.c                       |  38 +-
 net/smc/af_smc.c                                   |  10 +-
 net/smc/smc.h                                      |   1 +
 net/smc/smc_close.c                                |  14 +
 net/smc/smc_core.c                                 |   8 +-
 net/smc/smc_diag.c                                 |  12 +-
 net/smc/smc_sysctl.c                               |   6 +-
 net/socket.c                                       |  11 +-
 net/sunrpc/clnt.c                                  |   6 +-
 net/sunrpc/rpc_pipe.c                              |   1 +
 net/sunrpc/xprtsock.c                              |   2 +-
 net/tipc/bearer.c                                  |  33 ++
 net/tls/tls_device.c                               |  24 +
 net/tls/tls_sw.c                                   |  25 +-
 net/unix/garbage.c                                 |   3 -
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/vmw_vsock/virtio_transport.c                   |  16 +-
 net/wireless/nl80211.c                             |   9 +-
 net/wireless/scan.c                                |   3 +-
 net/wireless/util.c                                |   6 +-
 net/xdp/xsk.c                                      |   5 +
 net/xdp/xsk_buff_pool.c                            |  43 +-
 net/xfrm/xfrm_replay.c                             |   6 +-
 security/keys/key.c                                |  10 +-
 security/keys/keyctl.c                             |   2 -
 security/keys/keyring.c                            |  25 +-
 security/keys/request_key.c                        |  14 +-
 sound/core/memalloc.c                              |   2 +-
 sound/drivers/aloop.c                              |  23 +-
 sound/drivers/pcmtest.c                            |  66 +--
 sound/hda/hdac_controller.c                        |  10 +-
 sound/pci/Kconfig                                  |   1 +
 sound/pci/hda/cs35l56_hda.c                        |   2 +
 sound/pci/hda/hda_codec.c                          |   1 -
 sound/pci/hda/hda_jack.c                           |  79 +--
 sound/pci/hda/hda_jack.h                           |   1 +
 sound/pci/hda/patch_realtek.c                      |  52 +-
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c      |  16 +-
 sound/soc/codecs/aw88399.c                         |  13 +
 sound/soc/codecs/aw88399.h                         |   5 +
 sound/soc/codecs/max98090.c                        |  22 +-
 sound/soc/codecs/rt1015.c                          |  81 ++-
 sound/soc/codecs/rt5645.c                          |   7 +-
 sound/soc/codecs/sta32x.c                          | 101 +++-
 sound/soc/codecs/wcd939x.c                         |  10 +-
 sound/soc/codecs/wcd939x.h                         |   1 -
 sound/soc/codecs/wm_adsp.c                         |  10 +
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.c      |  12 +-
 sound/soc/meson/axg-fifo.c                         |  30 +-
 sound/soc/soc-core.c                               |  16 +
 sound/soc/sof/amd/Kconfig                          |   6 +-
 sound/soc/sof/amd/acp-dsp-offset.h                 |  10 +
 sound/soc/sof/amd/acp.c                            | 141 ++++-
 sound/soc/sof/amd/acp.h                            |   5 +
 sound/soc/sof/amd/pci-acp70.c                      |   7 +-
 sound/soc/sof/intel/hda-codec.c                    |   4 +-
 sound/soc/sof/ipc4-topology.c                      |   2 +-
 sound/usb/caiaq/device.c                           |  11 +-
 sound/usb/misc/ua101.c                             |  29 +-
 sound/usb/mixer.c                                  |  23 +
 sound/usb/mixer.h                                  |   2 +
 sound/usb/pcm.c                                    |   6 +
 tools/include/nolibc/types.h                       |   6 +-
 tools/perf/builtin-lock.c                          |  61 ++-
 tools/perf/tests/pe-file-parsing.c                 |   2 +-
 tools/perf/util/disasm.c                           |   4 +-
 tools/perf/util/evlist.c                           |   6 +-
 tools/perf/util/evsel.c                            |  61 ++-
 tools/perf/util/evsel.h                            |   1 +
 tools/perf/util/symbol.c                           |   9 +-
 tools/testing/cxl/test/cxl.c                       |   6 +-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |   2 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |   1 +
 .../ftrace/test.d/dynevent/fprobe_syntax_errors.tc |   4 +-
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |   2 +-
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |   2 +-
 .../tcp_bidir_fast_retransmit_nosack.pkt           |  42 ++
 tools/testing/selftests/proc/proc-pid-vm.c         |   2 -
 tools/testing/shared/linux/cleanup.h               |   2 +
 virt/kvm/eventfd.c                                 |   7 +-
 virt/lib/irqbypass.c                               |  44 +-
 731 files changed, 10838 insertions(+), 5120 deletions(-)


