Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704955;
	b=t9ogINFq8ljiAr5LbryGc1YNK0fEdjTsc7XK8yGj0FPYi8A4Cq3NcMPG0CxiJULFpst+
	 DF/ZLHuZx2NHYO3bw9EsLAhzaBb9XXGNi7RzfO2hfwFytb2hjyEUTHH2cnq3PkdGDT3FV
	 JuQs1DBMj6jKPBNcCIsNRTxvHjPbGe9uGEhfntgTJ7yMKc++fc7JcTU5Os7Lq5ffAUyEW
	 Cbc27YEg4YpOCPHxdxGyYbbDFVWE1gvSJ/rdcanKCUoB71bHq1oxInv5lcmiQDv7wx9E9
	 Ypw5Z/2sU3T6+M4mqDX+zkKvpl1dBzGr13Za+BsW2UaTCP6Ti1WOoZZ3DC2yxsG3y+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=bZ0JdQ87slGlHj80EjocqAxW9CjWd11utKic/UELvVM=;
	b=nss+RzkvS6VSEnMC7XTAlCDVuq6+HjemCP8JWkSJDMsNR1u9rkHv6DZtyetrb/STh8hW
	 +yVerTo1GnXlcND38B4XszGnHXjMblBePbb77YWyd8LzSC5ePhlfkZbV6ztC+9irXT2YD
	 67ojg0JgOuCcw5omi4jeSUlxzxkMtX/RrwGCZ5q851XdbQLln66tkEpvNjWf1t/zQLJvg
	 57Iqzy7cRYPvrCoPz3hvecV2bsD1AmYIwW6ARQdvChFrX1gMgOt9b/mxvGe3O2Y5MRC1T
	 UQhRvfsbab6Cw+t441mr9uS3gPuf1nZ/G1w4uxi/32mV53UPwWelaWGVavH/u47IDxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKL+P6Kf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A770606A685;
	Thu, 26 Nov 2026 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKL+P6Kf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427711F000E1;
	Thu, 26 Nov 2026 14:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704955;
	bh=bZ0JdQ87slGlHj80EjocqAxW9CjWd11utKic/UELvVM=;
	h=From:To:Cc:Subject:Date;
	b=NKL+P6KfuQX3Go5m2MPIPD79/dIplqRnZfF2n3sjbeZ4W3PIpyn38EBVhUrJcONau
	 f/42Sb4AXjh7YOmwNtmpJixxx+MjmAXJkOxhK98YgnmtvQJjpYBVK1AwexXQQI5cqi
	 +UjW8h1rbrq2eBDtBYbXYdTlOUE3N0CRAv7mjVvc=
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
Subject: [PATCH 5.15 000/319] 5.15.227-rc1 review
Date: Thu, 26 Nov 2026 15:36:08 +0100
Message-ID: <20261126144006.732901931@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.227-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.227-rc1
X-KernelTest-Deadline: 2026-11-28T14:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

-------------
Note, this is the LAST 5.15.y kernel release to happen.  After this, it
is end-of-life.  You should not be using this kernel tree at all, UNLESS
you are an Android system.  If you are running Android, please go get
your 5.15.y updates from Google's public kernel tree after this release
for any "important" bugfixes for that platform as they will be keeping
it alive for another year or so for their specific platform
configurations and then it will wind down. But really, even Android
systems should have moved on by now to a more modern kernel...
-------------

This is the start of the stable review cycle for the 5.15.227 release.
There are 319 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 28 Nov 2026 14:39:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.227-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.227-rc1

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not checking skb length on hci_scodata_packet

Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>
    bootconfig: Trim unquoted values at end of file

Su Hui <suhui@nfschina.com>
    fs/stat.c: avoid harmless garbage value problem in vfs_statx_path()

Abdifatah Suruur <suruurism@gmail.com>
    vfio/fsl-mc: prevent read-only region mappings from becoming writable

Abdifatah Suruur <suruurism@gmail.com>
    vfio/platform: prevent read-only region mappings from becoming writable

Yongqiang Liu <liuyongqiang13@huawei.com>
    ARM: 9359/1: flush: check if the folio is reserved for no-mapping addresses

Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
    powerpc/watchdog: disable watchdog when watchdog_thresh=0

Hyunwoo Kim <imv4bel@gmail.com>
    tcp: fix NULL pointer dereference when restarting a Fast Open listener

Mani Tofigh <mt4022@columbia.edu>
    nvme: fix deadlock on nvme_subsystems_lock in nvme_init_subsystem()

Henry Martin <bsdhenrymartin@gmail.com>
    sctp: fix skb_over_panic when adding addresses with a pending delete of another family

Karl Mehltretter <kmehltretter@gmail.com>
    iio: trigger: Return an error when the trigger has no free irq

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

Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
    iio: accel: kxsd9: Fix potential use-after-free on removal

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: serialise MCR accesses

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential use-after-free on disconnect

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential fifo corruption

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential NULL-deref at open

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix potential close() use-after-free

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix NULL-deref on early status

Tristan Madani <tristan@talencesecurity.com>
    USB: serial: sierra: validate URB length in instat callback

Hui Peng <benquike@gmail.com>
    USB: serial: garmin_gps: validate packet data length in nat_receive()

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

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Recover from End Transfer timeout

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Clear delayed stop on End Transfer completion

Brian Ellis <brianellis@gotenna.com>
    usb: gadget: u_serial: fix NULL deref in gs_close() after failed open

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    usb: gadget: f_ncm: restart the TX timer if the TX freelist is empty

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: f_midi: fix UAF race during IN request handling

Yu Zhang <yuz08559@gmail.com>
    usb: gadget: f_mass_storage: take filesem in nofua store to fix backing-file UAF

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    usb: usbtest: prevent divide by zero in simple_io() with zero length

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    usb: uas: ignore UAS for ASMT135x bridges (174c:55aa)

Josef Bacik <josef@toxicpanda.com>
    USB: serial: oti6858: fix the teardown order in close

Johan Hovold <johan@kernel.org>
    USB: serial: garmin_gps: fix deadlock on reset request

Rishabh Jain <rishabh.jain1198@gmail.com>
    usb: pci-quirks: always assert xHCI OS ownership

Josef Bacik <josef@toxicpanda.com>
    serial: samsung: put the previous baud clock

Josef Bacik <josef@toxicpanda.com>
    serial: samsung: don't leak the tty on an RX IRQ

Josef Bacik <josef@toxicpanda.com>
    serial: 8250_lpss: don't divide by 0 above 6.25 Mbaud

Jiale Yao <yaojiale02@163.com>
    misc: ibmvmc: initialize HMC state before device registration

Guangshuo Li <lgs201920130244@gmail.com>
    misc: bcm-vk: fix DMA allocation memory leak

Josef Bacik <josef@toxicpanda.com>
    iio: hid-sensors: fix a division by zero

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

Jay Vadayath <jay@artiphishell.com>
    dm-raid: bound array_position before indexing failed_devices

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: don't attempt to commit journal on disabled device

Sinan Polat <sinan86polat@gmail.com>
    dm-integrity: don't recalculate with HMAC because of a dirty bitmap

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

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: don't leak bufio buffer if find_leaf fails

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

shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>
    dm log userspace: drop the device reference on error

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
    wifi: mac80211: recheck the OCB station limit before insertion

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: recheck the IBSS station limit before insertion

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: recheck injected headers after removing FCS

Wahid Khan <wahidzk0091@gmail.com>
    wifi: cfg80211: don't truncate the merged MBSSID profile length

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: release rejected nontransmitted BSS reference

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: ath9k_htc: do not start ANI before the first channel is set

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix 1-byte signed field fetch in get_event_field()

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

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Don't trust userspace-supplied result field in format check

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix wrong free and refcount leak in build_check_tcw error path

Rupesh Majhi <zoone.rupert@gmail.com>
    hwmon: (aht10) Fix update_interval overflow on 64-bit

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    xen/pvcalls: destroy the per-socket workqueue on release

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    xen/pvcalls: unwind pvcalls_new_active_socket() step by step

Andrey Misiurov <andrey.misyrov@gmail.com>
    xen/gntdev: fix deadlock between map ioctl and mmap

Dave Hansen <dave.hansen@linux.intel.com>
    x86/mm: Ensure write visibility during LDT installation

Guanglei Zhu <zhugl3@xiaopeng.com>
    tpm: eventlog: check the payload size before reading tag events

Takashi Iwai <tiwai@suse.de>
    tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path

Hungyu Lin <dennylin0707@gmail.com>
    timekeeping: Read getboottime64() offsets under the sequence counter

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    software node: only let the owner release a managed node

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Cache post-resolution target frequency in __resolve_freq()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Clear last written P-state value on suspend

Li RongQing <lirongqing@baidu.com>
    cpufreq: acpi-cpufreq: fix P-state index mismatch in extract_io()

Cheng Yongkang <teel4res@gmail.com>
    fs/proc: fix the write length returned by proc_sys_call_handler()

HyeongJun An <sammiee5311@gmail.com>
    fs/adfs: bound directory entry name length in adfs_fplus_getnext()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: essiv - fix use-after-free in AEAD path

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    Bluetooth: hci_qca: fix use-after-free in ibs debugfs files

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Update last_busy in rpm_resume() for active devices

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: encode configured zero metadata values

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_teql: reject qdiscs from another network namespace

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    netfilter: xt_recent: do not call remove_proc_entry() under recent_lock

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    hv_netvsc: Stop PPI parsing on invalid metadata

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

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: only install push_pending_record for a TX context

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    net: mana: report RX checksum offload for IPv6

Jens Axboe <axboe@kernel.dk>
    net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls

Jun Yang <junvyyang@tencent.com>
    net: bridge: use one headroom snapshot for ND replies

Kyle Zeng <kylebot@openai.com>
    net/rds: Do not unpin a page after a failed atomic pin

Davidlohr Bueso <dave@stgolabs.net>
    mctp: accept MSG_CMSG_COMPAT in recvmsg

Edward Adam Davis <eadavis@qq.com>
    ext4: avoid infinite loops caused by residual data

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nvmem: core: Check input parameter for NULL in nvmem_unregister()

Jean-Paul Sergent <jpsergent@gmail.com>
    net: dst_metadata: fix memcmp overread in skb_metadata_dst_cmp

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: detect zonelist rebuilds from memory hot-add

Josef Bacik <josef@toxicpanda.com>
    mm/memory_hotplug: resize zones under their seqlock

Gregory Price (Meta) <gourry@gourry.net>
    mm/mmzone: read the zoneref slot once in zonelist_zone()

Christian Brauner <brauner@kernel.org>
    aio: don't let exit_aio() return before complete() is done

Igor Velkov <iav@iav.lv>
    mmc: meson-gx: name the limit of the CMD_CFG timeout field

Igor Velkov <iav@iav.lv>
    mmc: meson-gx: honour the busy timeout for R1b commands

Igor Velkov <iav@iav.lv>
    mmc: meson-gx: report busy from DAT0 alone

Anfernee Cao <anferneemelokc5@gmail.com>
    mmc: mmci: fix DMA channel leak when mmc_add_host() fails

Steven Rostedt <rostedt@goodmis.org>
    tracing/selftests: Fix false bashism in kprobe_non_uniq_symbol.tc

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

Jiahao Xu <xujiahao@cmss.chinamobile.com>
    net: usb: cdc_ncm: don't underflow the NDP room check

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().

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

LiangCheng Wang <zaq14760@gmail.com>
    ASoC: max98090: keep the MIC boost across mic input power-up

Kavitha Daula <kavi@edera.dev>
    xen/grant-table: annotate on-stack work in gnttab_unmap_refs_sync()

Pengpeng Hou <hppiscas@163.com>
    drm/bridge: sii902x: validate I2S data lane values

Eric Dumazet <edumazet@kernel.org>
    udp: do not use a cross-family sk_rx_dst in early demux

Eric Dumazet <edumazet@kernel.org>
    fou: gue: check IP version of held packets for direct IP encapsulation

Yuho Choi <oss.patchbox@gmail.com>
    ptp: kvm: x86: Leak clock_pair page if changing its encryption fails

Chase Hiltz <me@chasehil.tz>
    ipv4: route: don't blackhole in-use routes when retiring fnhe routes

Umang Pokhriyal <umangpokhriyall@gmail.com>
    tun: delete the flow entries of the moved queue on detach

Eric Dumazet <edumazet@kernel.org>
    bonding: fix slave_cnt leak on XDP enslave failure

Kyle Zeng <kylebot@openai.com>
    net: require a full socket in sock_confirm_neigh()

Yajun Deng <yajun.deng@linux.dev>
    neigh: introduce neigh_confirm() helper function

Kyle Zeng <kylebot@openai.com>
    net: protect negative destination advice with RCU

Li RongQing <lirongqing@baidu.com>
    team: fix promisc/allmulti leak in team_port_add error path

Nikola Z. Ivanov <zlatistiv@gmail.com>
    team: Add matching error label for failed action

Yaroslav Dudkov <aroslavdudkov622@gmail.com>
    ipv6: ignore link state in gateway check

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Balance queue accounting when relocating a task

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: Balance switch queue length on transport removal

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: preserve timeout policy when cloning clients

Avi Weiss <thnkslprpt@gmail.com>
    SUNRPC: wake poll waiters when an empty pipe is unlinked

Avi Weiss <thnkslprpt@gmail.com>
    NFSv4.1: retain MDS I/O until both thresholds are met

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: return -ENOENT from of_gpio_count() stub

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    tracing/probes: bound symstr stores to reserved length

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: fix MODE SELECT field pointer for block descriptor length

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata-scsi: Simplify ata_scsi_mode_select_xlat()

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: fix MODE SELECT handling of data after the mode page

Alexei Starovoitov <ast@kernel.org>
    ipv6: Check the Home Address option again before its address is used

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    ipv6: ICMPV6: Use swap() instead of open coding it

Eric Dumazet <edumazet@kernel.org>
    calipso: do not charge request socket options to the listener

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

Peter Zijlstra <peterz@infradead.org>
    locking/osq: Fix unlink queue corruption

Peter Zijlstra <peterz@infradead.org>
    locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering

David Laight <David.Laight@ACULAB.COM>
    locking/osq_lock: Clarify osq_wait_next() calling convention

Hui Su <sh_def@163.com>
    sched/pelt: Fix u32 truncation of the PELT period count

Siddharth Chintamaneni <sidchintamaneni@gmail.com>
    fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()

Max Kellermann <max.kellermann@ionos.com>
    fs/read_write: make default_llseek() killable

Max Kellermann <max.kellermann@ionos.com>
    include/linux/fs.h: add inode_lock_killable()

Hungyu Lin <dennylin0707@gmail.com>
    vfs: preserve subsecond timestamps at filesystem time limits

Abbott Liu <liuwenliang@huawei.com>
    initrd: flush deferred fput() before mounting root

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: SB1250: Validate and update IRQ affinity

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: Alchemy: Save the Ethernet address before reusing PROM memory

Rosen Penev <rosenp@gmail.com>
    MIPS: Avoid dead code/data elimination when using recordmcount

Eric Dumazet <edumazet@kernel.org>
    tcp: ipv6: free ireq->ipv6_opt after an RCU grace period

Eric Dumazet <edumazet@google.com>
    ipv6/tcp: small drop monitor changes

Florian Westphal <fw@strlen.de>
    netfilter: nat: zero newrange before filling it in

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload

Joas Antonio dos Santos <joasantonio108@gmail.com>
    netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: x_tables: check target name before accessing verdict

Cheng Yongkang <teel4res@gmail.com>
    net: bridge: disable MRP ports before the FDB flush in del_nbp()

Timur Stukan <timur.stukan.linux@gmail.com>
    bonding: 3ad: don't set BOND_LINK_FAIL on a slave that is not up

Colton Pawielski <colton.pawielski@gmail.com>
    net: 8139cp: keep Rx masked while NAPI is scheduled

Michał Kopeć <michal.kopec@3mdeb.com>
    ALSA: hda/core: Stop capability walk on empty capability header

Florian Fainelli <florian.fainelli@broadcom.com>
    net: dsa: b53: restore the NSP IMP port 2 Gbps mode

Florian Fainelli <florian.fainelli@broadcom.com>
    net: dsa: b53: Force flow control for BCM5301X CPU port(s)

Florian Fainelli <florian.fainelli@broadcom.com>
    net: ethernet: bgmac: preserve forced 2.5 Gbps link speed

Zhao Li <enderaoelyther@gmail.com>
    Bluetooth: L2CAP: Clear request identifiers on incoming LE connections

Sasha Levin <sashal@kernel.org>
    ACPI: scan: Do not hold physical_node_lock across device_offline() and device_online()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Introduce acpi_fetch_acpi_dev()

Sasha Levin <sashal@kernel.org>
    ACPI: scan: Print the offline failure message in acpi_bus_offline()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/pm: track BACO state in the SMU v11 ArmD3 sequence

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Flush exception route while replacing nexthop.

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: ipv6: use the new fib6_nh_release_dsts helper in fib6_nh_release

Zhou Minqiang <zhouminqiang2@huawei.com>
    PM: runtime: Fix check_flush_dependency warning from pm_runtime_remove

Avi Weiss <thnkslprpt@gmail.com>
    net: skbuff: reject zero MPLS TTL before decrementing

Guillaume Nault <gnault@redhat.com>
    tcp: Fix dup-ack detection on non-SACK bidirectional data transfer.

Chris Mason <mason@kernel.org>
    nvmet-rdma: disconnect a queue on device removal

Bjorn Helgaas <bhelgaas@google.com>
    nvme: fix various comment typos

Daniel Wagner <dwagner@suse.de>
    nvme-tcp: handle number of queue changes

Chris Mason <mason@kernel.org>
    nvmet-rdma: queue the release work under the mutex

Chris Mason <mason@kernel.org>
    nvmet-rdma: take a device off the list last

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: limit the connections accepted per work run

Chris Mason <mason@kernel.org>
    nvmet-rdma: disconnect only established queues

Florian Fainelli <florian.fainelli@broadcom.com>
    net: dsa: b53: Enable IGMP and MLD control packet CPU copies

Niklas Cassel <cassel@kernel.org>
    null_blk: fix opening closed zones at the active zone limit

Zizhi Wo <wozizhi@huawei.com>
    block: partitions: reject GPT entries with starting_lba > ending_lba

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost: reject backend enable without a kick file

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-scsi: reject delayed virtqueue setup

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost-scsi: validate event queue descriptor direction

Eric Dumazet <edumazet@kernel.org>
    soreuseport: annotate data-races around reuse->socks[] and num_socks

Yifan Zhang <yfzhang23@stu.pku.edu.cn>
    ksmbd: require NUL-terminated EA names

Aaditya Kansal <aadityakansal390@gmail.com>
    ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH in smb server

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_core: Keep link-key filtering inside RCU

Catherine L <catherine.l@intel.com>
    Bluetooth: btintel: fix buffer over-read in fw payload

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

Martyn Welch <martyn.welch@collabora.com>
    gpio: mpc8xxx: Add wake on GPIO support

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: mpc8xxx: Convert to platform remove callback returning void

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    regulator: qcom_spmi: don't take a sleeping lock in the SAW IPI

Rob Herring (Arm) <robh@kernel.org>
    regulator: qcom_spmi: Drop unnecessary of_find_property() call

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vhost: reject invalid IOTLB update permissions

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: preserve event ordering

Alex Austin <alex.austin@amd.com>
    sfc: ptp: avoid racing PPS timestamp updates

Alex Austin <alex.austin@amd.com>
    sfc: ptp: serialize host and MC synchronization transactions

Alex Austin <alex.austin@amd.com>
    sfc: ptp: drop the stale frequency reset in efx_ptp_start()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: copy XDP metadata in AF_XDP zero-copy RX

Yuqiang Sun <izaiahsun@gmail.com>
    bpf: lwt: Free the skb when bpf_xmit() fails to expand the headroom

Rosen Penev <rosenp@gmail.com>
    spi: acpi: only look up the IRQ of confirmed SPI devices

Alban Bedel <alban.bedel@lht.dlh.de>
    spi: Fix ACPI SPI resources using relative path

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: remove duplicate parameters check in acpi_spi_add_resource()

Stefan Binding <sbinding@opensource.cirrus.com>
    spi: Support selection of the index of the ACPI Spi Resource before alloc

Stefan Binding <sbinding@opensource.cirrus.com>
    spi: Create helper API to lookup ACPI info for spi device

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: Remove unused function spi_busnum_to_master()

Chris Mason <mason@kernel.org>
    bpf: Move the transport header with the moved headers

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

Hongjian Dai <daihongjian@kylinsec.com.cn>
    spi: pic32-sqi: fail transfer when the BD ring is exhausted

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: reject attaching bearer of different media to the same occupied device

Jia Jia <physicalmtea@gmail.com>
    scsi: target: Validate REGISTER AND MOVE TransportID length

James Hilliard <james.hilliard1@gmail.com>
    ptp: unwind partially completed virtual clock creation

James Hilliard <james.hilliard1@gmail.com>
    ptp: drain virtual clock sysfs operations before unregistering children

Filipe Manana <fdmanana@suse.com>
    btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing

guolingxing <guolingxing@tju.edu.cn>
    btrfs: verity: propagate orphan insertion errors when enabling verity

Avi Weiss <thnkslprpt@gmail.com>
    gpio: omap: Propagate runtime PM failures in probe and request

Filippo Falezza <effeffe99@gmail.com>
    wifi: ath10k: Stop unanswered temperature reads

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath10k: Fix miscellaneous spelling errors

Sergey Ryazanov <ryazanov.s.a@gmail.com>
    ath10k: add encapsulation offloading support

Sergey Ryazanov <ryazanov.s.a@gmail.com>
    ath10k: turn rawmode into frame_mode

Matthew Whitehead <tedheadster@gmail.com>
    scsi: aha1542: Remove unneeded scsi_dma_unmap() call

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

Eric Van Hensbergen <ericvh@kernel.org>
    fs/9p: rework qid2ino logic

Eric Van Hensbergen <ericvh@kernel.org>
    fs/9p: switch vfsmount to use v9fs_get_new_inode

Feng Ning <feng@innora.ai>
    staging: media: atomisp: use array3_size() for overflow-safe allocation

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: destroy force-feedback device on input unregistration

Hui Peng <benquike@gmail.com>
    udf: validate vat20->lengthHeader and VAT inode size in udf_load_vat()

Jan Kara <jack@suse.cz>
    udf: validate VAT inode size for old VAT format

Zizhi Wo <wozizhi@huawei.com>
    fs: aio: reject partial mremap to avoid Null-pointer-dereference error

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Sasha Levin <sashal@kernel.org>
    bpf: Drop inet_conn_established from lsm sleepable hooks

Liang He <windhl@126.com>
    ARM: OMAP2+: omap4-common: Fix refcount leak bug

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Check cs flags.

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix recursive locking during device registration

Kory Maincent <kory.maincent@bootlin.com>
    net: ravb: Fix missing rtnl lock in suspend/resume path

Chris Mason <mason@kernel.org>
    mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: fix UAF of child socket on listener close

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: move custom expectation support to helper

Florian Westphal <fw@strlen.de>
    netfilter: nft_ct: expectation timeouts are passed in milliseconds

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Undup use uvc_endpoint_max_bpi() code


-------------

Diffstat:

 Documentation/spi/spi-summary.rst                  |   8 -
 Documentation/trace/kprobes.rst                    |   2 +-
 Makefile                                           |   4 +-
 arch/arm/mach-omap2/omap4-common.c                 |   1 +
 arch/arm/mm/flush.c                                |   3 +
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/alchemy/common/prom.c                    |  23 ++-
 arch/mips/sibyte/sb1250/irq.c                      |   3 +
 arch/powerpc/kernel/watchdog.c                     |   3 +
 arch/x86/kernel/ldt.c                              |  12 +-
 block/partitions/efi.c                             |   1 +
 crypto/essiv.c                                     |   2 +-
 drivers/acpi/scan.c                                | 142 ++++++++++++++----
 drivers/ata/libata-scsi.c                          |  35 +++--
 drivers/base/power/runtime.c                       |   8 +-
 drivers/base/swnode.c                              |   7 +-
 drivers/block/null_blk/zoned.c                     |  13 +-
 drivers/bluetooth/btintel.c                        |  24 ++-
 drivers/bluetooth/hci_qca.c                        |   5 +
 drivers/char/tpm/eventlog/acpi.c                   |   4 +-
 drivers/char/tpm/eventlog/tpm1.c                   |   7 +
 drivers/comedi/drivers/addi_apci_1500.c            |   2 +-
 drivers/comedi/drivers/ni_660x.c                   |   3 +-
 drivers/comedi/drivers/ni_tio.c                    |   2 +-
 drivers/comedi/drivers/vmk80xx.c                   |  25 ++--
 drivers/cpufreq/acpi-cpufreq.c                     |   9 +-
 drivers/cpufreq/cpufreq.c                          |  18 ++-
 drivers/cpufreq/intel_pstate.c                     |  14 +-
 drivers/gpio/gpio-brcmstb.c                        |   1 +
 drivers/gpio/gpio-mpc8xxx.c                        |  97 +++++++-----
 drivers/gpio/gpio-omap.c                           |  13 +-
 drivers/gpio/gpio-rockchip.c                       |  15 +-
 drivers/gpio/gpio-sodaville.c                      |   9 +-
 drivers/gpio/gpiolib-of.h                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |  20 ++-
 drivers/gpu/drm/bridge/sii902x.c                   |   8 +-
 drivers/hwmon/aht10.c                              |   2 +-
 drivers/i3c/master.c                               |  39 +++--
 drivers/iio/accel/kxsd9.c                          |   2 +-
 drivers/iio/afe/iio-rescale.c                      |   3 +-
 drivers/iio/chemical/atlas-ezo-sensor.c            |   3 -
 .../iio/common/hid-sensors/hid-sensor-attributes.c |  14 +-
 drivers/iio/dac/mcp4725.c                          |   2 +
 drivers/iio/gyro/bmg160_core.c                     |   2 +-
 drivers/iio/humidity/am2315.c                      |  12 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   2 +
 drivers/iio/imu/kmx61.c                            |   2 +-
 drivers/iio/industrialio-trigger.c                 |   1 +
 drivers/iio/light/tsl2591.c                        |  32 ++--
 drivers/iio/light/vcnl4035.c                       |   4 +-
 drivers/iio/magnetometer/mmc35240.c                |   3 +-
 drivers/input/ff-core.c                            |   2 +-
 drivers/input/input.c                              |   2 +
 drivers/md/dm-cache-metadata.c                     |   4 +-
 drivers/md/dm-cache-target.c                       |   1 +
 drivers/md/dm-crypt.c                              |  12 +-
 drivers/md/dm-integrity.c                          |  30 +++-
 drivers/md/dm-log-userspace-base.c                 |   6 +-
 drivers/md/dm-mpath.c                              |   6 +-
 drivers/md/dm-raid.c                               |   3 +-
 drivers/md/dm-snap.c                               |  12 +-
 drivers/md/dm-sysfs.c                              |  17 ++-
 drivers/md/dm-thin-metadata.c                      |   5 +-
 drivers/md/dm-thin.c                               |   6 +-
 drivers/md/dm-zoned-reclaim.c                      |  18 ++-
 drivers/md/persistent-data/dm-btree.c              |   8 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   4 +-
 drivers/media/usb/uvc/uvc_video.c                  |   3 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/misc/bcm-vk/bcm_vk_sg.c                    |  43 +++++-
 drivers/misc/ibmvmc.c                              |  16 +-
 drivers/mmc/host/meson-gx-mmc.c                    |  23 ++-
 drivers/mmc/host/mmci.c                            |   4 +-
 drivers/net/bonding/bond_main.c                    |  24 ++-
 drivers/net/dsa/b53/b53_common.c                   |  67 +++++++++
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/b53/b53_regs.h                     |  17 +++
 drivers/net/dsa/bcm_sf2.c                          |   5 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  13 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   3 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   8 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  26 ++--
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   7 +-
 drivers/net/ethernet/realtek/8139cp.c              |   8 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   8 +-
 drivers/net/ethernet/sfc/ptp.c                     | 108 +++++++++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +-
 drivers/net/hyperv/rndis_filter.c                  |   6 +-
 drivers/net/team/team.c                            |  12 +-
 drivers/net/tun.c                                  |   6 +-
 drivers/net/usb/cdc_ncm.c                          |   4 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |   4 +-
 drivers/net/wireless/ath/ath10k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath10k/core.c             |  14 +-
 drivers/net/wireless/ath/ath10k/core.h             |   5 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |   2 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |   2 +-
 drivers/net/wireless/ath/ath10k/debug.c            |   2 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   2 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   6 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  73 +++++++--
 drivers/net/wireless/ath/ath10k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath10k/pci.h              |   2 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |   2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   2 +-
 drivers/net/wireless/ath/ath10k/thermal.c          |  11 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |   4 +-
 drivers/net/wireless/ath/ath10k/usb.h              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |  14 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   8 +-
 drivers/nvme/host/core.c                           |   4 +
 drivers/nvme/host/fc.c                             |   4 +-
 drivers/nvme/host/tcp.c                            |  26 +++-
 drivers/nvme/target/fc.c                           |   6 +-
 drivers/nvme/target/rdma.c                         |  57 ++++---
 drivers/nvme/target/tcp.c                          |   8 +-
 drivers/nvmem/core.c                               |   3 +-
 drivers/ptp/ptp_clock.c                            |   5 +
 drivers/ptp/ptp_kvm_x86.c                          |   7 +-
 drivers/ptp/ptp_private.h                          |   1 +
 drivers/ptp/ptp_sysfs.c                            |  14 +-
 drivers/regulator/Kconfig                          |   1 +
 drivers/regulator/qcom_spmi-regulator.c            |  35 ++++-
 drivers/s390/block/dasd_eckd.c                     |   3 +-
 drivers/s390/block/dasd_ioctl.c                    |   4 +-
 drivers/scsi/aha1542.c                             |   2 -
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   2 +-
 drivers/spi/spi-pic32-sqi.c                        |   3 +-
 drivers/spi/spi.c                                  | 163 +++++++++++++--------
 .../staging/media/atomisp/pci/sh_css_param_dvs.c   |  11 +-
 .../media/atomisp/pci/sh_css_param_shading.c       |   4 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |  35 +++--
 drivers/target/target_core_pr.c                    |   9 +-
 drivers/tty/serial/8250/8250_lpss.c                |   3 +
 drivers/tty/serial/samsung_tty.c                   |   8 +-
 drivers/tty/vt/keyboard.c                          |   6 +
 drivers/tty/vt/vt.c                                |   2 +
 drivers/usb/dwc3/gadget.c                          |   6 +
 drivers/usb/gadget/function/f_mass_storage.c       |   8 +-
 drivers/usb/gadget/function/f_midi.c               |   4 +
 drivers/usb/gadget/function/f_ncm.c                |   7 +-
 drivers/usb/gadget/function/storage_common.c       |   7 +-
 drivers/usb/gadget/function/storage_common.h       |   3 +-
 drivers/usb/gadget/function/u_serial.c             |   3 +
 drivers/usb/host/pci-quirks.c                      |  13 +-
 drivers/usb/misc/usbtest.c                         |   3 +
 drivers/usb/serial/garmin_gps.c                    |  31 ++--
 drivers/usb/serial/io_edgeport.c                   |  77 +++++++---
 drivers/usb/serial/oti6858.c                       |  16 +-
 drivers/usb/serial/sierra.c                        |  18 ++-
 drivers/usb/storage/uas-detect.h                   |   8 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |  10 +-
 drivers/vfio/platform/vfio_platform_common.c       |  10 +-
 drivers/vhost/scsi.c                               |  27 +++-
 drivers/vhost/test.c                               |   4 +
 drivers/vhost/vhost.c                              |   3 +-
 drivers/w1/masters/ds2482.c                        |  36 +++--
 drivers/w1/slaves/w1_ds2805.c                      |   8 +-
 drivers/w1/slaves/w1_ds28e04.c                     |  18 +--
 drivers/w1/slaves/w1_therm.c                       |  37 +++--
 drivers/w1/w1.c                                    |  21 ++-
 drivers/w1/w1_int.c                                |   8 +-
 drivers/w1/w1_netlink.c                            |   8 +-
 drivers/xen/gntdev.c                               |   8 +-
 drivers/xen/grant-table.c                          |  37 ++++-
 drivers/xen/pvcalls-back.c                         |  26 ++--
 fs/9p/v9fs_vfs.h                                   |   7 +-
 fs/9p/vfs_dir.c                                    |  10 +-
 fs/9p/vfs_inode.c                                  |  26 +---
 fs/9p/vfs_inode_dotl.c                             |   6 +-
 fs/9p/vfs_super.c                                  |  29 +---
 fs/adfs/dir_fplus.c                                |   2 +
 fs/aio.c                                           |   7 +-
 fs/btrfs/scrub.c                                   |   8 +-
 fs/btrfs/verity.c                                  |   2 +-
 fs/ext4/extents.c                                  |   8 +-
 fs/inode.c                                         |   3 +-
 fs/ksmbd/smb2pdu.c                                 |  30 ++--
 fs/nfs/pnfs.c                                      |   2 +-
 fs/proc/proc_sysctl.c                              |   5 +-
 fs/read_write.c                                    |  14 +-
 fs/stat.c                                          |   3 +
 fs/udf/super.c                                     |  19 ++-
 include/acpi/acpi_bus.h                            |   2 +
 include/linux/fs.h                                 |  10 ++
 include/linux/i3c/master.h                         |   3 +
 include/linux/key.h                                |   3 +
 include/linux/mmzone.h                             |   3 +-
 include/linux/spi/spi.h                            |   7 +-
 include/net/9p/client.h                            |   2 +-
 include/net/arp.h                                  |   8 +-
 include/net/bluetooth/hci_core.h                   |  13 +-
 include/net/dst_metadata.h                         |   2 +
 include/net/ndisc.h                                |  16 +-
 include/net/neighbour.h                            |  11 ++
 include/net/netfilter/nf_conntrack_helper.h        |   1 +
 include/net/sock.h                                 |  29 ++--
 init/do_mounts_rd.c                                |   5 +
 kernel/bpf/bpf_lsm.c                               |   4 -
 kernel/locking/osq_lock.c                          |  81 ++++++----
 kernel/sched/pelt.c                                |   2 +-
 kernel/time/timekeeping.c                          |   8 +-
 kernel/trace/trace_eprobe.c                        |  12 +-
 kernel/trace/trace_kprobe.c                        |   3 +
 kernel/trace/trace_probe_tmpl.h                    |  14 +-
 lib/bootconfig.c                                   |   7 +-
 mm/internal.h                                      |  11 +-
 mm/khugepaged.c                                    |   4 +
 mm/memory_hotplug.c                                |  44 ++++--
 mm/page_alloc.c                                    |   4 +-
 net/9p/protocol.c                                  |  12 +-
 net/batman-adv/bat_iv_ogm.c                        |   2 +-
 net/bluetooth/hci_core.c                           |  35 +++--
 net/bluetooth/l2cap_core.c                         |   5 +-
 net/bridge/br_arp_nd_proxy.c                       |   6 +-
 net/bridge/br_if.c                                 |   6 +-
 net/core/filter.c                                  |  91 ++++++++++--
 net/core/lwt_bpf.c                                 |  12 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/sock_reuseport.c                          |  17 ++-
 net/ipv4/fib_trie.c                                |  14 +-
 net/ipv4/fou_core.c                                |  12 ++
 net/ipv4/igmp.c                                    |   2 +
 net/ipv4/inet_connection_sock.c                    |  20 ++-
 net/ipv4/ip_output.c                               |   8 +-
 net/ipv4/netfilter/arp_tables.c                    |   5 +-
 net/ipv4/netfilter/ip_tables.c                     |   5 +-
 net/ipv4/route.c                                   |  25 +++-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/udp.c                                     |   5 +-
 net/ipv6/calipso.c                                 |  12 +-
 net/ipv6/exthdrs.c                                 |   5 +-
 net/ipv6/exthdrs_core.c                            |   7 +-
 net/ipv6/icmp.c                                    |  10 +-
 net/ipv6/ip6_output.c                              |  13 +-
 net/ipv6/mip6.c                                    |   9 +-
 net/ipv6/netfilter/ip6_tables.c                    |   5 +-
 net/ipv6/route.c                                   |  34 ++---
 net/ipv6/seg6_iptunnel.c                           |  46 +++++-
 net/ipv6/seg6_local.c                              |  55 ++++++-
 net/ipv6/tcp_ipv6.c                                |   6 +-
 net/ipv6/udp.c                                     |   5 +-
 net/iucv/af_iucv.c                                 |   9 ++
 net/mac80211/ibss.c                                |  23 ++-
 net/mac80211/ieee80211_i.h                         |   3 +
 net/mac80211/ocb.c                                 |  23 ++-
 net/mac80211/tx.c                                  |   6 +
 net/mctp/af_mctp.c                                 |   2 +-
 net/mptcp/options.c                                |  12 +-
 net/mptcp/protocol.c                               |  10 ++
 net/netfilter/ipvs/ip_vs_app.c                     |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  12 +-
 net/netfilter/nf_conntrack_helper.c                |  20 ++-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_nat_masquerade.c                  |   4 +-
 net/netfilter/nf_tables_api.c                      |  21 ++-
 net/netfilter/nf_tables_offload.c                  |   3 +
 net/netfilter/nft_ct.c                             | 126 ++++++++++++----
 net/netfilter/xt_NETMAP.c                          |   4 +-
 net/netfilter/xt_recent.c                          |   7 +-
 net/rds/rdma.c                                     |   5 +-
 net/sched/act_ife.c                                |   6 +-
 net/sched/sch_teql.c                               |   9 +-
 net/sctp/sm_make_chunk.c                           |  43 +++---
 net/sctp/sm_statefuns.c                            |  16 +-
 net/sctp/socket.c                                  |   2 +-
 net/sctp/stream.c                                  |   2 +
 net/sctp/stream_interleave.c                       |  38 ++---
 net/socket.c                                       |  11 +-
 net/sunrpc/clnt.c                                  |   5 +-
 net/sunrpc/rpc_pipe.c                              |   1 +
 net/tipc/bearer.c                                  |  33 +++++
 net/tls/tls_sw.c                                   |  16 +-
 net/wireless/scan.c                                |   3 +-
 net/xfrm/xfrm_replay.c                             |   6 +-
 security/keys/key.c                                |  10 +-
 security/keys/keyctl.c                             |   2 -
 security/keys/keyring.c                            |  25 +++-
 security/keys/request_key.c                        |  14 +-
 sound/hda/hdac_controller.c                        |  10 +-
 sound/pci/Kconfig                                  |   1 +
 sound/soc/codecs/max98090.c                        |  22 +--
 sound/soc/meson/axg-fifo.c                         |  30 ++--
 sound/usb/caiaq/device.c                           |  11 +-
 sound/usb/pcm.c                                    |   6 +
 tools/bootconfig/test-bootconfig.sh                |  18 +++
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |   2 +-
 .../tcp_bidir_fast_retransmit_nosack.pkt           |  42 ++++++
 296 files changed, 2763 insertions(+), 1195 deletions(-)


