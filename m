Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795154622;
	b=BFeQ6DSPfFsHtNzZPavQJzK8ZxTiRXmPxO4gcoTdmUTvJUa/IjJZeSflR4GJHougOiGZ
	 dsxzjdrX5TlBLKGcCO92umP1+KbjaM/gqVYDqeErwcqCKlE3LO8AKU6ApUplev1i7ekpI
	 19eUmCctniJbvuKjBevK1olIGwoVd/QcHqSUg9hbgGUHdiWb/SZJjvAlFogCFAdSa1XB+
	 omrXeTiWduDeF7U2bbF6OBxHUbsyHVsEw8/eCMpRw+tLbI5qdJ6EGAJAspYtMmwRKCSMW
	 XhLAkSksEK9WMnUH+51JW7CK10kS4HMYOA06rT6mKzFh7/02BnCZPw/5zWh4xEsPVWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=6qAYCqetiNGHJBj9wgdx32V609Yn5aK2F85DGTH46Kg=;
	b=KLG9/JO1SmboXWkDTgcW7Ud8iVHNmmEtSDUGAfq9driDFgjhpbBt50GKyI/FftdDQinX
	 3h/+aUx04HmYGMXR6OUeWBhJr8xL1NbwdK6Mw4UXqGGqqF5mbpCF+Giz7JcmCk9gchN1C
	 K+SlleRAcqopgCQflcVl7L/hTTNATvnp7k4wPtZ7jb+3xfzyWvqlYkx9mo1AwAbHjDX2E
	 p9jzep07nXtdGdtbTp9VQ1HDzHq8evNZXPo2CDkmOUM1oHJ3ZjovTA8aIG8JRC8laLewz
	 oOSOZ8H2KD+413rBNISMG7Im0qznB7nJG2cq1n9Ofz8fvSty9tYKtbrEv6STePmui5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcH3Bxgg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA17606A50F;
	Fri, 20 Nov 2026 06:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcH3Bxgg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035C31F000CA;
	Fri, 20 Nov 2026 06:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795154622;
	bh=6qAYCqetiNGHJBj9wgdx32V609Yn5aK2F85DGTH46Kg=;
	h=From:To:Cc:Subject:Date;
	b=ZcH3BxggdKDo+T/uX4WM2JPTg17zSQSvlT9K1gAC15/meA4r2iwrDByaCQ++BZCDr
	 w047cjc1kFCp1phfzOh+DlgyRAG0hk0iOH7/qlFIUQpnbpHACwoJkO24TIX/CgnwOB
	 gnnViQ6lhaWX//4ioP/uLag/Ihte2p9KHsogVgJY=
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
Subject: [PATCH 5.15 0000/2178] 5.15.226-rc2 review
Date: Fri, 20 Nov 2026 06:57:07 +0100
Message-ID: <20261120055015.328810133@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.226-rc2
X-KernelTest-Deadline: 2026-11-22T05:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.226 release.
There are 2178 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.226-rc2

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix tuner clock error handling

Kees Cook <kees@kernel.org>
    seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()

Yoann Congal <yoann.congal@smile.fr>
    printk: Fix LOG_CPU_MAX_BUF_SHIFT when BASE_SMALL is enabled

Nathan Lynch <nathanl@linux.ibm.com>
    seq_buf: Make DECLARE_SEQ_BUF() usable

Akira Yokosawa <akiyks@gmail.com>
    docs/process/howto: Replace C89 with C11

Kalesh Singh <kaleshsingh@google.com>
    tracing/histogram: Fix documentation inline emphasis warning

Tim Gardner <tim.gardner@canonical.com>
    dmaengine: dw-axi-dmac: Fix uninitialized variable in axi_chan_block_xfer_start()

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()

Wang Yan <wangyan01@kylinos.cn>
    selftests/net: fix EVP_MD_CTX leak in tcp_mmap

Hannes Reinecke <hare@kernel.org>
    nvmet: do not return 'reserved' for empty TSAS values

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Restore quirk probing for ACPI-based systems

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: initialize sym->curr.tri to 'no' for all symbol types again

Eric Dumazet <edumazet@google.com>
    selftests/net: fix typo in tcp_mmap

Bagas Sanjaya <bagasdotme@gmail.com>
    tracing/histogram: Wrap remaining shell snippets in code blocks

Steven Price <steven.price@arm.com>
    irqchip/gic-v3-its: Fix over allocation in itt_alloc_pool()

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Decouple acpi_index from the optional device name element

Dominique Martinet <asmadeus@codewreck.org>
    libbpf: fix cross-endian build with newer libbpf

Imre Kaloz <kaloz@kernel.org>
    rtc: ds1685: do not sleep in the power-off handler

Imre Kaloz <kaloz@kernel.org>
    rtc: ds1685: arm the wake-up alarm at power-off only if an alarm is set

Nickolai Zeldovich <nickolai@csail.mit.edu>
    ucount: read the parent ucounts before dropping the rlimit count

Nickolai Zeldovich <nickolai@csail.mit.edu>
    splice: retry tee() instead of returning 0 when it races

Zhiyu Zhang <zhiyuzhang999@gmail.com>
    watch_queue: keep info_id separate from rcu_head

Jhonata Poma-Hansen <jhonata.poma@gmail.com>
    netlink: check sk_rcvbuf before charging the dump skb

Rosen Penev <rosenp@gmail.com>
    net: bgmac: fix TX DMA unmapping and slot cleanup

Wentao Liang <vulab@iscas.ac.cn>
    apparmor: Fix namespace reference leak in __aa_find_or_create_ns()

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: report a label allocation failure as -ENOMEM

Jamie Nguyen <jamien@nvidia.com>
    selftests: net: txtimestamp: fix out-of-bounds read in raw UDP checksum

Chris Mason <mason@kernel.org>
    rnbd-srv: publish the sess_dev at the end of OPEN

Guoqing Jiang <guoqing.jiang@linux.dev>
    block/rnbd-srv: rename one member in rnbd_srv_dev

Md Haris Iqbal <haris.iqbal@ionos.com>
    block/rnbd-srv: Replace sess_dev_list with index_idr

Josef Bacik <josef@toxicpanda.com>
    block/rnbd-srv: drop the sess_dev kobject unlocked

Josef Bacik <josef@toxicpanda.com>
    block/rnbd-srv: don't free the device on a sysfs error

Christoph Hellwig <hch@lst.de>
    rnbd-srv: remove the name field from struct rnbd_dev

Christoph Hellwig <hch@lst.de>
    rnbd-srv: remove struct rnbd_dev_blk_io

Christoph Hellwig <hch@lst.de>
    rnbd-srv: simplify bio mapping in process_rdma

Josef Bacik <josef@toxicpanda.com>
    drbd: take req_lock to skip the initial sync as peer

Josef Bacik <josef@toxicpanda.com>
    block: partitions/mac: compute the sectors in 64 bits

Josef Bacik <josef@toxicpanda.com>
    blk-mq: keep sharing tags fairly after a queue update

Josef Bacik <josef@toxicpanda.com>
    block: fix use-after-free of the disk in sync_bdevs()

Markus Probst <markus.probst@posteo.de>
    rtc: s35390a: Read 24-hour mode on access

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: s35390a: fix typo in comment

Nick Huang <sef1548@gmail.com>
    rtc: s35390a: use u8 instead of char for register buffer

André Draszik <andre.draszik@linaro.org>
    rtc: s35390a: drop needless struct s35390a::rtc member

ye xingchen <ye.xingchen@zte.com.cn>
    rtc: s35390a: Remove the unneeded result variable

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: s35390a: let the core handle the alarm resolution

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: add alarm related features

Markus Probst <markus.probst@posteo.de>
    rtc: s35390a: Fix alarm not disabling

Markus Probst <markus.probst@posteo.de>
    rtc: s35390a: Add missing newline to dev_err

Joas Antonio dos Santos <joasantonio108@gmail.com>
    net: dcb: initialize PFC value before calling getpfccfg

Josef Bacik <josef@toxicpanda.com>
    blk-cgroup: fix root io.stat byte counts on 32-bit

Josef Bacik <josef@toxicpanda.com>
    blk-throttle: don't truncate the cgroup v1 iops limits

Chris Mason <mason@kernel.org>
    nvmet: don't clear sq->ctrl for a Connect with sqsize 0

Chris Mason <mason@kernel.org>
    nvmet-rdma: fix double puts after a failed RDMA WRITE

Chris Mason <mason@kernel.org>
    nvmet-rdma: disable interrupts under rsp_wr_wait_lock

Chris Mason <mason@kernel.org>
    nvmet-rdma: flush nvmet-wq on module exit

Josef Bacik <josef@toxicpanda.com>
    nvme-loop: don't BUG() if a scan runs beside a reset

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: don't read a removed port at Connect time

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: stop listening when a port is removed

Rongzheng Wang <testwrzwrz@gmail.com>
    nvmet: use the enabled transport when disabling a port

Hannes Reinecke <hare@suse.de>
    nvmet: make TCP sectype settable via configfs

Hannes Reinecke <hare@suse.de>
    nvme: add TCP TSAS definitions

Qing Zhang <diasyzhang@tencent.com>
    nvmet: protect nvmet_ports_list with nvmet_config_sem

Avi Weiss <thnkslprpt@gmail.com>
    nvmet: prevent double-free after metadata SGL allocation failure

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: xilinx: formatter_pcm: Fix read-modify-write of AUD_CTRL in hw_params

Feng Yang <yangfeng@kylinos.cn>
    bpf: Fix out-of-bounds btf->types write for split BTF

Ömer Mete Kaya <omermetekaya0@gmail.com>
    usbnet: fix EVENT_RX_PAUSED race in usbnet_skb_return()

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: mv88e6xxx: fix 6351 family statistics snapshot

Paul Moses <p@1g4.org>
    perf mmap: Preserve the consumed cursor in forward mode

Paul Moses <p@1g4.org>
    perf mmap: Use the head selected by read_init

Len Brown <len.brown@intel.com>
    x86_energy_perf_policy: Cleanup: Check fseek() in VM path

Len Brown <len.brown@intel.com>
    x86_energy_perf_policy: Fix optarg keyword matching

Dudu Lu <phx0fer@gmail.com>
    net: xps: bound the cleanup loop by the old map's num_tc

Allison Henderson <achender@kernel.org>
    net/rds: do not initialize transports after rds_init() failed

Hongfu Li <lihongfu@kylinos.cn>
    rds:Simplify the allocation of slab caches

Xiu Jianfeng <xiujianfeng@huawei.com>
    net: rds: add missing __init/__exit annotations to module init/exit funcs

Cheng Yongkang <teel4res@gmail.com>
    net: tun: hold napi_mutex when deleting NAPI in tun_detach_all()

Sally Marcher <me@gry.sh>
    ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II

Nicolai Buchwitz <nb@tipi-net.de>
    net: usb: cdc_mbim: don't enable BHs in tx_fixup under netpoll

Nicolai Buchwitz <nb@tipi-net.de>
    net: usb: cdc_ncm: don't enable BHs in tx_fixup under netpoll

Binbin Deng <18983559317@163.com>
    net: atlantic: Unregister before clearing RXNFC rules

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: drop discovery frames with no MAC header

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix refcount panic in tipc_rcv() when receiving shared skb

Jerome Brunet <jbrunet@baylibre.com>
    clk: cdce925: Size the PLL child name buffer for any int

bui duc phuc <phucduc.bui@gmail.com>
    clk: lmk04832: Handle reset GPIO lookup errors

Dudu Lu <phx0fer@gmail.com>
    net/sched: taprio: unwind the netdevice notifier if register_qdisc() fails

Dudu Lu <phx0fer@gmail.com>
    net/sched: gred: keep the qdisc lock while updating the table

Hungyu Lin <dennylin0707@gmail.com>
    thermal: Fix CPU mask truncation in power limit trace event

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    libceph: reject bad connect_seq in msgr1 READY reply

Xiubo Li <xiubo.li@clyso.com>
    ceph: mark the superblock active after mounting

Max Kellermann <max.kellermann@ionos.com>
    ceph: remove unused field `i_cap_migration_resv`

Henry Martin <bsdhenrymartin@gmail.com>
    netlink: fix out-of-bounds bitmap access clearing stale mc groups

Avi Weiss <thnkslprpt@gmail.com>
    profiling: fix sampling step on 64-bit big-endian systems

Edward Adam Davis <eadavis@sina.com>
    kernel/reboot: avoid potential deadlocks during suspension

Feng Yang <yangfeng@kylinos.cn>
    bpf: Propagate btf_add_type() errors in btf_check_all_metas()

Haotian Zhang <vulab@iscas.ac.cn>
    scsi: elx: libefc: Fix resource leak in efcport_init() error path

Dudu Lu <phx0fer@gmail.com>
    net/sched: etf: initialise the sock_exterr_skb before filling it

Greg Thelen <gthelen@google.com>
    selftests/net: tcp_mmap: remove unused -k option and keepflag

Xiaoyan Li <lixiaoyan@google.com>
    selftests/net: Add SHA256 computation over data sent in tcp_mmap

Allison Henderson <achender@kernel.org>
    net/rds: keep the connected peer's scope id apart from the bound one

Allison Henderson <achender@kernel.org>
    net/rds: include the scope id in the sendmsg connection cache check

Eric Dumazet <edumazet@kernel.org>
    net: fix frag_list leak in skb_segment_list() error path

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: do not read past skb->len when injecting a frame

Florian Fuchs <fuchsfl@gmail.com>
    ALSA: sh: aica: Fix spu_memset() stride

Gregory Price (Meta) <gourry@gourry.net>
    cgroup/cpuset: check effective mems for a movable-only configuration

Jiale Yao <yaojiale02@163.com>
    regulator: irq: freeze deferred hardware access during suspend

Marco Crivellari <marco.crivellari@suse.com>
    regulator: irq_helper: replace use of system_wq with system_dfl_wq

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    regulator: irq_helper: Provide helper for trivial IRQ notifications

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    regulator: Add regulator_err2notif() helper

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: raven: Fix memory leak in acp3x_dma_close()

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: select CRYPTO_AES

Ivan Hu <ivan.hu@canonical.com>
    ACPICA: Initialize parser_state.aml_end in acpi_install_method()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    nsproxy: Fix cred leak in the error path of prepare_nsset()

Avi Weiss <thnkslprpt@gmail.com>
    signal: skip blocked signals in dequeue_synchronous_signal()

Tianyi Chen <hi@tychen.cc>
    eventpoll: propagate wakeup source creation failure in ep_modify()

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: follow AIF clock source changes in MCLK gating

Binbin Deng <18983559317@163.com>
    tipc: fix use-after-free of broadcast reception link at node release

Rand Deeb <rand.sec96@gmail.com>
    ata: libata-core: Ignore forced transfer modes the host does not support

Travis Howard <thoward@lafayetteinstrument.com>
    tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table

Tianyi Gao <tianyi@cloudflare.com>
    veth: schedule the peer's NAPI after XDP_TX when only GRO is enabled

Nikhil P. Rao <nikhil.rao@amd.com>
    ionic: fix port_info use-after-free on firmware recovery

Namhyung Kim <namhyung@kernel.org>
    perf c2c: Fix memory leaks on output fields

Leo Yan <leo.yan@linaro.org>
    perf c2c: Use 'peer' as default display for Arm64

Waldemar Brodkorb <wbx@openadk.org>
    sh: Select BINFMT_FLAT_NO_DATA_START_OFFSET for !MMU

Paul E. McKenney <paulmck@kernel.org>
    sh: Emulate one-byte cmpxchg

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: fix MCLK index used for setting MCLK rate

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: don't lose the AIF clock ratio when staying at 32kHz SYSCLK

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: fix MCLK gating for AIF clocks sourced from MCLK2

Anil Kaushik <anilkaushikwireless@gmail.com>
    gtp: hold RCU for the device lookup when adding a PDP context

Anil Kaushik <anilkaushikwireless@gmail.com>
    gtp: set a valid genl command in PDP context get and dump replies

Takashi Iwai <tiwai@suse.de>
    platform/x86: ibm_rtl: Fix potential OOB read at signature search

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: initialize status waiters before publishing them

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reserve xattr value tree metadata only once

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix invalid Next offset in interface info replies

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: wait for the RX poll to return before freeing the RX queue

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: fix netpoll races with RX replenish

Jiale Yao <yaojiale02@163.com>
    team: reject CAN, IEEE 802.15.4 and 6LoWPAN devices in team_port_add

Ido Schimmel <idosch@nvidia.com>
    ipv6: Hold RCU when emitting route hardware flags notification

Myeonghun Pak <mhun512@gmail.com>
    platform/x86: gpd pocket fan: Cancel work before releasing GPIOs

Eric Dumazet <edumazet@kernel.org>
    ipv6: account route exceptions to the netns of their dst

Sagi Maimon <maimon.sagi@gmail.com>
    net: axienet: release every RX buffer in axienet_dma_bd_release()

Myeonghun Pak <mhun512@gmail.com>
    net: hix5hd2: serialize timeout recovery with interface teardown

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: device: protect async RX resync state during device-down

Eric Dumazet <edumazet@kernel.org>
    tcp: tcp_metrics: use the socket netns, not the dst device netns

Eric Dumazet <edumazet@google.com>
    tcp_metrics: use dst_dev_net_rcu()

Fernando Fernandez Mancera <fmancera@suse.de>
    net: openvswitch: drop IP fragments on SCTP set action

Fernando Fernandez Mancera <fmancera@suse.de>
    net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions

HyeongJun An <sammiee5311@gmail.com>
    ASoC: cs42l56: Remove the ADC Mute Switch control

Liang Hao <haohlliang@gmail.com>
    timers: Clear pending_map on CPU hotplug

tangmeng <tangmeng@uniontech.com>
    timers: Move timer sysctl into the timer code

Karl Mehltretter <kmehltretter@gmail.com>
    rtc: class: Make the time32 hctosys limit configurable

James Hilliard <james.hilliard1@gmail.com>
    net: stmmac: avoid duplicate XSK TX completions

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: dss: avoid printing uninit csum

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: mpc: avoid printing uninit data

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Fix CQ resize destination index mask

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_api: reject duplicate actions in a batch

Gregory Price (Meta) <gourry@gourry.net>
    cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask

Cen Zhang <zzzccc427@gmail.com>
    ALSA: aloop: Keep the timer source alive until card release

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Remove channel-map controls before freeing substreams

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    nios2: ksyms: Declare __mulsi3 export

Sung Byeongchan <tjdqudcks0424@naver.com>
    netfilter: xt_dccp: handle reserved options as single-byte

Shuangfeng He <huangya90@gmail.com>
    netfilter: flowtable: use the vlan id, not the full tci, in the tuple key

Julian Anastasov <ja@ssi.bg>
    ipvs: fix more races around the overload flag

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: Fix CQ enable state tracking after AQ writes

Cen Zhang <zzzccc427@gmail.com>
    ALSA: oss: Keep emulation modules loaded until object teardown

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Protect the unregister notifier traversal

Troy Mitchell <troy.mitchell@linux.dev>
    dt-bindings: vendor-prefixes: Add Sensylink

Mikhail Zhilkin <csharper2005@gmail.com>
    dt-bindings: Add Sercomm (Suzhou) Corporation vendor prefix

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()

Zhiwei Zhang <202275009@qq.com>
    RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta350: Fix definition of limiter threshold controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta32x: Fix definition of limiter threshold controls

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Reject LAG selection when source MAC lookup fails

Yunsheng Lin <linyunsheng@huawei.com>
    RDMA/core: Remove 'device' argument from rdma_build_skb()

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Preserve the selected source GID on failed AH modification

Igor Velkov <iav@iav.lv>
    power: supply: gpio-charger: Report discharging without input power

Aleksandr Nogikh <nogikh@google.com>
    usb: gadget: dummy_hcd: prevent unbind via sysfs

Igor Skalkin <igor.skalkin@oss.qualcomm.com>
    usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't take a program with a target program for an iterator

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: restrict raw table targets/matches

Florian Westphal <fw@strlen.de>
    selftests: netfilter: fix return value in zone subtest

Florian Westphal <fw@strlen.de>
    selftests: netfilter: conntrack_vrf.sh: prefer socat, not iperf3

Florian Westphal <fw@strlen.de>
    selftests: netfilter: conntrack_vrf.sh: move to lib.sh infra

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix unlikely UaF in gc worker

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't take an extension for an iterator program

Josef Bacik <josef@toxicpanda.com>
    bpf: Bound the nesting that the BTF show code follows

Alexei Starovoitov <ast@kernel.org>
    bpf: Clear sk_refcnt of a clone before its storage is linked

Josef Bacik <josef@toxicpanda.com>
    bpf: Update the SRH state if End.B6 fails late

Josef Bacik <josef@toxicpanda.com>
    bpf: Pull the inner header for End.DT6 in End.BPF

Josef Bacik <josef@toxicpanda.com>
    bpf: Validate the SRH which End.DT6 uncovers in End.BPF

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields

Brad Fitzpatrick <bradfitz@tailscale.com>
    gre: keep the UDP tunnel GSO type when completing GRO

Joas Antonio dos Santos <joasantonio108@gmail.com>
    calipso: update payload_len when removing the CALIPSO option

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control

Sasha Levin <sashal@kernel.org>
    ARC: Strip libgcc debug information when generating BTF

Piotr Gliźniewicz <p.glizniewicz@gmail.com>
    ALSA: 6fire: take stream_mutex in the Digital Thru control

Ömer Mete Kaya <omermetekaya0@gmail.com>
    usbnet: fix smp_processor_id() use in preemptible context

Fabrice Derepas <fabrice.derepas@canonical.com>
    ima: reject a kexec buffer whose declared size exceeds the buffer

Tao Cui <cuitao@kylinos.cn>
    blk-iocost: account zone append completions in latency stats

Tao Cui <cuitao@kylinos.cn>
    blk-iocost: charge zone appends as writes

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix inverted tracefs validation when scanning /proc/mounts

Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
    HID: wacom: fix wacom_intuos_irq NULL pen_input deref

Stefano Munari <stefanomunari.sm@gmail.com>
    net: usb: lan78xx: reject invalid EEPROM write requests

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    macsec: prevent AES-GCM nonce reuse after packet number wrap

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Print a signed histogram key as signed

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Clamp the printed end of a histogram bucket at U64_MAX

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/histogram: Document variable stacktrace

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: docs: Update histogram doc for .percent/.graph and 'nohitcount'

Kalesh Singh <kaleshsingh@google.com>
    tracing/histogram: Document expression arithmetic and constants

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Print the bucket size as unsigned

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix ETDM probe error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix HDMI TX startup error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix ETDM startup error handling

Trevor Wu <trevor.wu@mediatek.com>
    ASoC: mediatek: mt8195: add dai id check before accessing array

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix ETDM MCLK error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Propagate IRQ lookup errors

Yang Li <yang.lee@linux.alibaba.com>
    ASoC: mediatek: mt8195: Remove unnecessary print function dev_err()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix runtime resume error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix FE startup error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix paired memif clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix main clock error handling

Trevor Wu <trevor.wu@mediatek.com>
    ASoC: mediatek: mt8195: enable apll tuner

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix timing system clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix register access clock error handling

Colin Ian King <colin.i.king@googlemail.com>
    ASoC: mediatek: mt8195: make several arrays static const

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: ops: Fix return value in snd_soc_limit_volume()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger

Hongbo Li <lihongbo22@huawei.com>
    ASoC: remove unused substream in macro soc_link_mark_pop

Sasha Levin <sashal@kernel.org>
    selftests: keep the build status from wrapping to success

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population

Serhat Kumral <serhatkumral1@gmail.com>
    IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()

Sasha Levin <sashal@kernel.org>
    kselftest/arm64: signal: copy each test binary only once

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Serialize snd_refcount put and sync

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Replace paylen by payload

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix ref error in rxe_av.c

Chengguang Xu <cgxu519@mykernel.net>
    RDMA/rxe: Change variable and function argument to proper type

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Lookup kernel AH from ah index in UD WQEs

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Replace ah->pd by ah->ibah.pd

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Create AH index and return to user space

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Move AV from rxe_send_wqe to rxe_send_wr

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add refcount for races between drain and unlink

Takashi Iwai <tiwai@suse.de>
    ALSA: Add simple refcount helper functions

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Use deferred fasync helper

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Don't free the tables of an enabled ITS

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Don't free a vPE table shared with another ITS

Steven Price <steven.price@arm.com>
    irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Split allocation from initialisation of its_node

Johan Hovold <johan+linaro@kernel.org>
    irqchip/gic-v3-its: Use irq_domain_create_hierarchy()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Reset each ITS's BASERn register before probe

Valentin Schneider <valentin.schneider@arm.com>
    irqchip/gic-v3-its: Postpone LPI pending table freeing and memreserve

Valentin Schneider <valentin.schneider@arm.com>
    irqchip/gic-v3-its: Give the percpu rdist struct its own flags field

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Clear vpt_page after freeing the pending table

Carolina Jubran <cjubran@nvidia.com>
    IB/IPoIB: Cancel normal flush work on device stop

Sagi Maimon <maimon.sagi@gmail.com>
    net: axienet: free outstanding TX buffers in axienet_dma_bd_release()

Kyrylo Biryuk <illofspeed@gmail.com>
    ata: libahci: re-enable FBS after error handling on a port multiplier

Long Zhao <longzhao@ambarella.com>
    dt-bindings: vendor-prefixes: add Ambarella

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()

Nicolai Buchwitz <nb@tipi-net.de>
    net/mlx5e: use skb_share_check() in the loopback selftest hook

Nicolai Buchwitz <nb@tipi-net.de>
    net: stmmac: selftests: use skb_share_check() in the loopback receive hook

Nicolai Buchwitz <nb@tipi-net.de>
    net: selftests: use skb_share_check() in the loopback receive hook

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Zero version data before parsing TLVs

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: btintel: propagate version TLV parsing errors

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: Drain RCU readers on registration failure

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_core: Keep RCU protection through LTK filtering

Hitalo Souza <enghitalo@gmail.com>
    Bluetooth: Add missing newline to bt_dev_{err,warn}_ratelimited()

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6LoWPAN: Use RCU-safe device list removal

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9492/1: alignment: fix LSR #32 and ASR #32 offset decoding

Atul Akella <atul.akella@gmail.com>
    rpmsg: virtio: fix error handling in TX buffer wait

Patrick Oppenlander <patrick.oppenlander@gmail.com>
    rpmsg: virtio: EPOLLOUT support

Dr. David Alan Gilbert <linux@treblig.org>
    rpmsg: virtio: Remove uncallable offchannel functions

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    rpmsg: core: add API to get MTU

Avi Weiss <thnkslprpt@gmail.com>
    rpmsg: mtk: release channel OF node on device teardown

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8737: Fix definition of zero cross switches

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8955: Fix definition of Treble Cutoff control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8991: Fix definition of right input PGA controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8990: Fix definition of right input PGA controls

Tim Douglas <me@timdoug.com>
    serial: pmac_zilog: report received breaks

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Unlink substreams before releasing them

Julian Anastasov <ja@ssi.bg>
    ipvs: fix buffer overflow when sending sync messages

Karl Mehltretter <kmehltretter@gmail.com>
    thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc

Florian Fainelli <florian.fainelli@broadcom.com>
    tools/thermal/tmon: Fix string truncation warning in optarg copy

Weigang He <geoffreyhe2@gmail.com>
    thermal/drivers/sprd: validate the sensor id from the device tree

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use fixed control index for us16x08 mixer elements

Cen Zhang <zzzccc427@gmail.com>
    ALSA: vmaster: Serialize hook registration with control callbacks

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Use kzalloc() for PCM buffer allocation

Takashi Iwai <tiwai@suse.de>
    ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()

Amadeusz Sławiński <amade@asmblr.net>
    ALSA: pcm: Fix driver_tstamp value reporting

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ocfs2: validate chunk and block counts of the local quota file

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix possible deadlock between nfs_sync_rwlock and fs_reclaim

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: retain all security xattrs during inode creation

Zhiling Zou <zhilinz@nebusec.ai>
    lib: validate in-memory LZ4 chunk length

Karl Mehltretter <kmehltretter@gmail.com>
    sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel-i2s: use optional API for gclk

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel-i2s: use optional API for muxclk

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel-i2s: fix MCK generator error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback

Palla Raghunath <raghunathpalla.0209@gmail.com>
    nvmet-fc: don't drop the last assoc reference in nvmet_fc_delete_ctrl()

Surabhi Gogte <sgogte@purestorage.com>
    nvme-tcp: store and use the caller's network namespace

Peijie Shao <shaopeijie@cestc.cn>
    nvme-tcp: fix selinux denied when calling sock_sendmsg

Keith Busch <kbusch@kernel.org>
    nvme: tcp: split controller bringup handling

Heiko Carstens <hca@linux.ibm.com>
    s390/uprobes: Fix off-by-one bug in emulated PER handling

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: rcg2: Clear force enable after rate failure

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: rcg2: Propagate force-enable status errors

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset

Yuho Choi <oss.patchbox@gmail.com>
    bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()

Yuho Choi <oss.patchbox@gmail.com>
    bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()

Linkai Gong <gonglinkai@kylinos.cn>
    char: scx200_gpio: check cdev_add() return value

Weigang He <geoffreyhe2@gmail.com>
    thermal/drivers/ti-soc-thermal: Cancel pending alert work on remove

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: pcmuio: validate the IRQs supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: pcmmio: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: dmm32at: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: dt2814: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: ni_atmio16d: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: comedi_parport: validate the IRQ supplied by userspace

Thomas Fourier <fourier.thomas@gmail.com>
    net: alacritech: fix dma_free_coherent() in error path

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: don't clobber the TX break bit in set_termios

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp_hybla: fix divide by zero on rtt0 == 0

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp_bic: fix divide by zero on max_increment == 0

Chien Wong <m@xv97.com>
    wifi: mac80211: fix encryption tailroom

Haitam Lazaar <haitam@lazaarsec.com>
    RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    clocksource/drivers/timer-mediatek: Fix random crash at boot

Joas Antonio dos Santos <joasantonio108@gmail.com>
    calipso: hash the cache key, not the option start, in calipso_cache_add()

Cen Zhang <zzzccc427@gmail.com>
    ALSA: rawmidi: Drain input work before freeing the runtime

Myeonghun Pak <mhun512@gmail.com>
    fbdev: gxt4500: Release WC setup on probe failure

Jiale Yao <yaojiale02@163.com>
    platform/olpc: Reserve space for a string terminator

Aleksandrova Alyona <aga@itb.spb.ru>
    platform/x86: intel_telemetry: initialize default trace verbosity

Dan Carpenter <error27@gmail.com>
    mm/hmm/test: reject overflowing page counts

Jiale Yao <yaojiale02@163.com>
    wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup

Jiale Yao <yaojiale02@163.com>
    wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup

Jiale Yao <yaojiale02@163.com>
    wifi: ath10k: avoid IDR mutation during TX cleanup

Kunwu Chan <kunwu.chan@gmail.com>
    rcutorture: Fix divide-by-zero with fwd_progress_div=1

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: codecs: rt5659: propagate GPIO errors

Roberto Bergantinos Corpas <rbergant@redhat.com>
    nfs: set gencount on protocol-specific remove

Haotian Zhang <vulab@iscas.ac.cn>
    mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()

bui duc phuc <phucduc.bui@gmail.com>
    power: supply: generic-adc-battery: Propagate charged GPIO errors

Sebastian Reichel <sre@kernel.org>
    power: supply: generic-adc-battery: convert to managed resources

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: fix swapped blocks existence check when tracing after COW

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup

Filipe Manana <fdmanana@suse.com>
    btrfs: fix off by one super block end offset calculation when writing super blocks

Jiale Yao <yaojiale02@163.com>
    ACPI: PCI: pci_link: clear driver_data before free

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Explicitly enable MMU interrupts at device init

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    RDMA/mlx5: Cancel software CQ notifications before teardown

Mark Zhang <markzhang@nvidia.com>
    RDMA/mlx5: Support driver APIs pre_destroy_cq and post_destroy_cq

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    RDMA/mlx5: Cancel deferred page-fault EQ work before teardown

Linkai Gong <gonglinkai@kylinos.cn>
    mailbox: arm_mhuv2: time out if the receiver never comes up

Beleswar Padhi <b-padhi@ti.com>
    mailbox: ti-msgmgr: Read exact number of trailing message bytes

Sang-Hoon Choi <csh0052@gmail.com>
    xhci: dbc: lock the minor IDR on registration failure

Leon Romanovsky <leon@kernel.org>
    PCI/P2PDMA: Gate the host bridge whitelist warning on verbose

Leon Romanovsky <leon@kernel.org>
    PCI/P2PDMA: Safely terminate ACS redirect lists

Kees Cook <keescook@chromium.org>
    seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()

Matthew Wilcox (Oracle) <willy@infradead.org>
    tracing: Move readpos from seq_buf to trace_seq

Sergey Senozhatsky <senozhatsky@chromium.org>
    seq_buf: Add seq_buf_do_printk() helper

Antoni Pokusinski <apokusinski01@gmail.com>
    rtc: abx80x: properly handle shared IRQs

Antoni Pokusinski <apokusinski01@gmail.com>
    rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: init radiotap iter after length checks

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: kill wake_txqs_tasklet on unregistration

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: use hlist_add_head_rcu()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: clear fragment cache entry 'is_protected'

Johannes Berg <johannes.berg@intel.com>
    wifi: ath6kl: don't take RTNL in del_virtual_intf

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: intel: Cancel delayed work at shutdown, too

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix potential OOB write in line6_capture_copy()

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Reject too small max packet sizes

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    sound: usb: remove third argument of usb_maxpacket()

Jan Beulich <jbeulich@suse.com>
    x86/PVH: don't truncate initrd address/size

Gui-Dong Han <hanguidong02@gmail.com>
    xen/blkback: Prevent missed completion when draining I/O

Jake Labelle <southampton.jake.labelle@gmail.com>
    nilfs2: reject non-regular inodes in dsync recovery

Rosen Penev <rosenp@gmail.com>
    crypto: talitos - init tasklets before requesting IRQs

Rosen Penev <rosenp@gmail.com>
    crypto: talitos - Use platform_get_irq() to retrieve interrupt

Rosen Penev <rosenp@gmail.com>
    crypto: talitos - use devm_platform_ioremap_resource()

Rosen Penev <rosenp@gmail.com>
    crypto: talitos - allocate channels with main struct

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Avoid non-operational GPU warning at regular device removal

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Add missing barriers for power_ref vs card->shutdown

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Check shutdown flag at D0 power-state, too

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Remove superfluous CONFIG_PM

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    ALSA: core: Make snd_card_disconnect() return void

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Simplify snd_power_ref_and_wait() with the standard macro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix potential UAF for gating jack

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Handle a malformed _DSM result in acpi_attr_is_visible()

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Stop reporting _DSM failures as -EPERM

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: common: Handle constraint return value in FE startup

Melissa Wen <mwen@igalia.com>
    drm/amd/display: use right type for amdgpu_dc_performance event entries

Melissa Wen <mwen@igalia.com>
    drm/amd/display: remove duplicated prev_p_state_change_support assignment

Melissa Wen <mwen@igalia.com>
    drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state

Ting-Han Hou <ue081723@gmail.com>
    checkkconfigsymbols.py: Parse Git status output line by line

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt

Ahmed Naseef <naseefkm@gmail.com>
    wifi: mt76: mt7615: read MT7663 temperature from the correct offset

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: usb: fix source overread in mt76u_copy

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: mt76x02: validate RX padding before use

Jiale Yao <yaojiale02@163.com>
    pinctrl: sprd: free maps on DT map failure

Leizhen Zhang <lzsx618@gmail.com>
    gen_init_cpio: stop parsing on lines with a missing argument list

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Allow zero-length packet handling for EP1

Priyank Rathod <rathodpriyank@google.com>
    PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()

Robert Richter <rrichter@amd.com>
    PCI/AER: Forward RCH downstream port-detected errors to the CXL.mem dev handler

Dave Jiang <dave.jiang@intel.com>
    PCI/AER: Add optional logging callback for correctable error

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reject inconsistent xattr bucket during defrag

Wilson Felipe Pereira <wfelipe@google.com>
    init/main: fix false-positive kernel panic on environment variable overwrite

Wilson Felipe Pereira <wfelipe@google.com>
    init/main: fix off-by-one in argv_init cleanup

Florian Schmaus <florian.schmaus@codasip.com>
    selftests/epoll: fix race condition in multi-waiter wakeup tests

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix deadlock in inline-data truncate transactions

Petr Vorel <pvorel@suse.cz>
    checkpatch: skip CamelCase cache for --no-tree without root

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix link count underflow when removing corrupted directory

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-sun4i: sun4i_spi_fill_fifo(): always apply A10 FIFO fill level workaround

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-sun4i: sun4i_spi_transfer_one(): fix transfers for SUN4I_FIFO_DEPTH

Pengpeng Hou <pengpeng@iscas.ac.cn>
    sh: defconfig: Enable the current M66592 UDC symbol

Florian Fuchs <fuchsfl@gmail.com>
    sh: uaccess: Require offsettable operands for 64-bit user access

Chen-Yu Tsai <wens@kernel.org>
    arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine

Chen-Yu Tsai <wens@kernel.org>
    arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine

Yang Xiuwei <yangxiuwei@kylinos.cn>
    floppy: avoid NULL deref in reset_interrupt when cont is cleared

Karl Mehltretter <kmehltretter@gmail.com>
    floppy: flush pending work before releasing resources on init failure

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    NFS: filelayout: calculate dense stripe width in 64 bits

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: ioat: disable relaxed ordering before registering the device

Dan Carpenter <error27@gmail.com>
    wifi: carl9170: NUL terminate string in debugfs

Dan Carpenter <error27@gmail.com>
    wifi: b43legacy: debugfs: NUL terminate string in debugfs

Dan Carpenter <error27@gmail.com>
    wifi: b43: don't pass unterminated string to sscanf()

Dominic White <github@singe.za.net>
    wifi: cfg80211: allow zero HE OBSS PD offsets

Xueqin Luo <luoxueqin@kylinos.cn>
    cpufreq: sti: avoid NULL dereference in dev_err()

Xueqin Luo <luoxueqin@kylinos.cn>
    cpufreq: sparc-us2e: fix frequency table index copy-paste error

Hongyan Xu <getshell@seu.edu.cn>
    ASoC: mt6359-accdet: manage private workqueues with devres

Yaozhong Li <yaozhonguwl@gmail.com>
    arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly

Yaozhong Li <yaozhonguwl@gmail.com>
    arm64: dts: rockchip: fix analog headphone output on rk3399-firefly

Linus Walleij <linusw@kernel.org>
    ARM: dts: ux500: Use AB8505 charger compatible

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: AB8505: Enable charging options

Detlev Casanova <detlev.casanova@collabora.com>
    arm64: dts: rockchip: Rename rk3328 HDMI audio card

Jiale Yao <yaojiale02@163.com>
    ASoC: rt711-sdca: always cancel jack work on remove

Jiale Yao <yaojiale02@163.com>
    ASoC: rt711-sdw: always cancel jack work on remove

Jiale Yao <yaojiale02@163.com>
    ASoC: rt5682-sdw: always cancel jack work on remove

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Recover inactive AB8505 charger

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Skip absent AB8505 main charger

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Handle detection errors

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Respect AB8505 register layout

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_btemp: Fix event temperature reporting

Jan Stancek <jstancek@redhat.com>
    .gitignore: drop Module.markers

Linus Walleij <linusw@kernel.org>
    dt-bindings: power: supply: ab8500: Add AB8505 charger

Chen-Yu Tsai <wens@kernel.org>
    dt-bindings: media: sun4i-a10-video-engine: Fix IOMMU count for H6

Li Youhong <liyouhong@kylinos.cn>
    md/raid5: drain released_stripes before destroying the cache

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    md: take reconfig_mutex when enabling PPL on an inactive array

Laurence Oberman <loberman@redhat.com>
    scsi: st: Record the tape position after a successful MTLOAD

Laurence Oberman <loberman@redhat.com>
    scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Refuse a negative physblk_exp

Oleg Keri <okerixx@gmail.com>
    drm/msm/dp: don't report link training success after a reinit

Yuho Choi <dbgh9129@gmail.com>
    soc/tegra: flowctrl: Release OF node reference on error

Igor Velkov <iav@iav.lv>
    arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz

Igor Velkov <iav@iav.lv>
    arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and WP# pins

Matthias Goergens <matthias.goergens@gmail.com>
    isofs: return long Joliet names whole

Slavin Liu <bolin.liu@seu.edu.cn>
    clocksource/drivers/dbx500-prcmu: Check timer register mapping

Thorsten Blum <blum@kernel.org>
    hwrng: intel - return -ENOMEM when ioremap() fails

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: ftrtc010: fix integer overflow in time calculation

Thorsten Blum <blum@kernel.org>
    hwrng: intel - return -ENOMEM when kmalloc_obj() fails

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: tcrypt - Avoid reading req->base after submission

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    crypto: tcrypt - Drop leading newlines from prints

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    crypto: tcrypt - Use pr_info/pr_err

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: tcrypt - remove all multibuffer ahash tests

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: tcrypt - add asynchronous speed test for SM3

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel - handle authenc requests without plaintext

Hemanth Selam <hemanth.selam@gmail.com>
    nvdimm/pmem: Release gendisk on probe failure

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Drop reference on postfence

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Don't pass an ERR_PTR to drm_syncobj_replace_fence()

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Fix syncobj_in wait return value check

Chuanhong Guo <gch981213@gmail.com>
    pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array

Linkai Gong <gonglinkai@kylinos.cn>
    misc: enclosure: fix UAF on device_register() failure

Weigang He <geoffreyhe2@gmail.com>
    ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepare_cpus()

Weigang He <geoffreyhe2@gmail.com>
    ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: ftrtc010: fix clock resource leak on probe failure

André Draszik <andre.draszik@linaro.org>
    rtc: ftrtc010: drop needless struct ftrtc010_rtc::rtc_dev member

Karl Mehltretter <kmehltretter@gmail.com>
    OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc

Lucas Costa <2000.costalucas@gmail.com>
    staging: sm750fb: free cmap on framebuffer release

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/mdp5: drop cursor pipe for msm8x76

Qingfang Deng <qingfang.deng@linux.dev>
    ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x

Matthias Goergens <matthias.goergens@gmail.com>
    x86/hibernate: Ignore page-zero RAM in E820 checksum

Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>
    dt-bindings: vendor-prefixes: Add Sophos

Chen Wang <unicorn_wang@outlook.com>
    dt-bindings: vendor-prefixes: add milkv/sophgo

Icenowy Zheng <uwu@icenowy.me>
    dt-bindings: vendor-prefixes: add Source Parts and Lctech names

Andreas Kemnade <andreas@kemnade.info>
    rtc: bd70528: properly enable wakeup

Nguyễn Văn Cao Nguyên <nguyennvc@greennode.ai>
    RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET

Nicolas Schier <n.schier@fritz.com>
    kconfig: tests: Provide defconfig outfile for savedefconfig

Hongyan Xu <getshell@seu.edu.cn>
    RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit

Hongyan Xu <getshell@seu.edu.cn>
    RDMA/hfi1: shut down the trap timer before unregistering

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/siw: Fix length of first chunk in siw_try_1seg()

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id

Qingshuang Fu <fuqingshuang@kylinos.cn>
    selftests/timers: clocksource-switch: Fix unchecked open()/read()

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Don't WARN on unexpected info-response opcode

Karl Mehltretter <kmehltretter@gmail.com>
    time: Prevent time64_to_tm() day truncation on 32-bit

Jiale Yao <yaojiale02@163.com>
    RDMA/mad: Reject receive completions shorter than GRH

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Reject invalid queue_depth from the peer

Yili Zhang <zhangyili01@baidu.com>
    RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE

Pengpeng Hou <hppiscas@163.com>
    clk: si5351: fail prepare when PLL reset times out

Myeonghun Pak <mhun512@gmail.com>
    clk: ti: adpll: unregister OF clock provider on remove

Dairui Zhang <zhangdairui@gmail.com>
    IB/mad: fix UAF and double-free in RMPP receive reassembly

Ruoyu Wang <ruoyuw560@gmail.com>
    media: venus: Drop session events without an instance

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the PD and DPI table size

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Detect wrong sge_len passed for inline

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix integer overflow in send payload size computation

Finn Thain <fthain@linux-m68k.org>
    swim3: Fix FDEJECT ioctl for exclusive open

Finn Thain <fthain@linux-m68k.org>
    swim: Fix FDEJECT ioctl for exclusive open

Logan Odell <loganodell@google.com>
    PCI/IOV: Read VF config values that need not match PF

Li RongQing <lirongqing@baidu.com>
    IB/isert: Don't share drop_cmd_list across concurrent connection teardowns

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment

Karl Mehltretter <kmehltretter@gmail.com>
    soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc

Karl Mehltretter <kmehltretter@gmail.com>
    soc: ti: k3-ringacc: Correct ring API kernel-doc

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192-mt6359: Fix error handling in MTKAIF calibration

Nícolas F. R. A. Prado via Alsa-devel <alsa-devel@alsa-project.org>
    ASoC: mt8192: Remove function name log messages

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Propagate errors in TDM DAI DAPM event handlers

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Propagate mt8192_afe_gpio_request() errors in ADDA DAI

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: mt8192-afe-gpio: Use guard() for mutex locks

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: switch to devm_clk_get_optional()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix MCK clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix error handling in APLL enable functions

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix AFE clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix APLL mux error handling

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    spi: rspi: Fix DMA mode when the DMA controller is built as a module

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: rspi: Get rid of unused struct rspi_plat_data

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    spi: spi-rspi: Add support to deassert/assert reset line

Niko Huuskonen <niko.huuskonen.00@gmail.com>
    ALSA: caiaq: Fix the Kore controller key map

Arka Mondal <arka@arkamondal.net>
    iio: dac: ad5758: Fix the offset calculation

Arka Mondal <arka@arkamondal.net>
    iio: dac: ad5758: Reject out-of-range raw values

Chen-Yu Tsai <wenst@chromium.org>
    drm/exynos/fimd: fix register offset type in fimd_trigger()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: via82xx: use helper to activate DXS controls

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set RQ event handler for raw-packet QP

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set SRQ event handler before xarray insertion

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set WQ event handler before firmware RQ insertion

Yishai Hadas <yishaih@nvidia.com>
    RDMA/hns: Pin CQ buffer writable to match device DMA write access

Ginger Li <ginger.jzllee@gmail.com>
    wifi: mac80211: Fix a race when expiring a mesh path

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/vt-d: Fix IQE handling to cover all descriptors in submission range

Myeonghun Pak <mhun512@gmail.com>
    PCI: aardvark: Disable PHY on probe failures

Linus Walleij <linusw@kernel.org>
    ARM: dts: gemini: Use a level-high interrupt for TVE200

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: fix reset of ct seqadj when reopening a connection

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix secondary rail vote in ARC votes

Daniel Palmer <daniel@0x0f.com>
    m68k: apollo: Fix interrupt setup

WangYuli <wangyuli@uniontech.com>
    MIPS: Only check -msym32 when need-compiler

Orgad Shaneh <orgads@gmail.com>
    MIPS: Octeon: size the swiotlb for a modular OHCI platform driver

Aaron Kling <webgeek1234@gmail.com>
    dt-bindings: vendor-prefixes: Add Retroid Pocket

Marek Vasut <marek.vasut+renesas@mailbox.org>
    dt-bindings: vendor-prefixes: Add Retronix Technology Inc.

Adam Skladowski <a39.skl@gmail.com>
    dt-bindings: vendor-prefixes: Add LeEco

Bruno Produit <bruno.produit@trailofbits.com>
    hfs/hfsplus: serialize B-tree close against folio release

Aaron Kling <webgeek1234@gmail.com>
    dt-bindings: vendor-prefixes: Add Chip Wealth Technology

Jagan Teki <jagan@edgeble.ai>
    dt-bindings: vendor-prefixes: Document Chongzhou

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8183: Fix APLL enable error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8183: Fix clock handling in mux disable path

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure

Sudeep Holla <sudeep.holla@kernel.org>
    ACPICA: Fix PCC OperationRegion command offsets

Breno Leitao <leitao@debian.org>
    ACPICA: Fix memory leak in acpi_ds_create_field()

Xin Yin <yinxin.x@bytedance.com>
    writeback: size foreign flushes by target wb dirty pages

Qingfang Deng <qingfang.deng@linux.dev>
    mtd: block: prevent reclaim I/O during request processing

Jiebin Sun <jiebin.sun@intel.com>
    perf c2c: Fix documented default coalesce fields

Muzaffer Kadir <muzafferkadir@mainlining.org>
    dt-bindings: vendor-prefixes: Add General Mobile

Pengpeng Hou <hppiscas@163.com>
    iio: accel: bma220: publish the SPI driver ACPI alias

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5665: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5660: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5659: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5616: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1308: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1305: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1016: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1011: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: nau8540: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: ak4642: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: adau17x1: return cache sync errors from resume

Slavin Liu <bolin.liu@seu.edu.cn>
    ASoC: fsl_asrc: check the second front-end DMA channel

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: use regmap_write_bits to update clock source registers

Dmitrii Tulnov <tulnov.dl@gmail.com>
    kconfig: warn about malformed KCONFIG_PROBABILITY values

Myeonghun Pak <mhun512@gmail.com>
    mfd: da9150: Balance IRQ wake on teardown

Myeonghun Pak <mhun512@gmail.com>
    mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock

Vincent Jardin <vjardin@free.fr>
    dt-bindings: vendor-prefixes: add Free Mobile

Linus Walleij <linus.walleij@linaro.org>
    dt-bindings: Add vendor prefixes

Lin, Meng-Bo <linmengbo0689@protonmail.com>
    dt-bindings: vendor-prefixes: Add GPLUS

Icenowy Zheng <uwu@icenowy.me>
    dt-bindings: vendor-prefixes: add Genesys Logic

Zongmin Zhou <zhouzongmin@kylinos.cn>
    serial: sifive: fix off-by-one in console port bounds check

Ginger Li <ginger.jzllee@gmail.com>
    media: i2c: ov5648: Fix a data race on state->streaming

Finn Thain <fthain@linux-m68k.org>
    swim: Don't search beyond the first data mark

Finn Thain <fthain@linux-m68k.org>
    swim: Fix buffer overflow

Finn Thain <fthain@linux-m68k.org>
    swim: Don't use the mark register to read data

Finn Thain <fthain@linux-m68k.org>
    swim: Check error register during sector read

Finn Thain <fthain@linux-m68k.org>
    swim: Simplify return value initialization

Finn Thain <fthain@linux-m68k.org>
    swim: Check for CRC errors

Finn Thain <fthain@linux-m68k.org>
    swim: Handle FIFO timeout error

Finn Thain <fthain@linux-m68k.org>
    swim: Recalibrate when drive is probed

Finn Thain <fthain@linux-m68k.org>
    swim: Don't start motor until medium is present

Finn Thain <fthain@linux-m68k.org>
    swim: Configure parameter memory

Luis Chamberlain <mcgrof@kernel.org>
    swim: add helper for disk cleanup

Luis Chamberlain <mcgrof@kernel.org>
    swim: simplify using blk_cleanup_disk() on swim_remove()

Finn Thain <fthain@linux-m68k.org>
    swim: Perform ISM/IWM mode switching according to specs

Finn Thain <fthain@linux-m68k.org>
    swim: Don't disable drive after every sector

Finn Thain <fthain@linux-m68k.org>
    swim: Enable the drive when probing

Finn Thain <fthain@linux-m68k.org>
    swim: Select appropriate drive once only

Finn Thain <fthain@linux-m68k.org>
    swim: Assert strobe with stable outputs

Jiale Yao <yaojiale02@163.com>
    crypto: ccp - kill v5 IRQ tasklet during teardown

Jiale Yao <yaojiale02@163.com>
    crypto: ccp - kill v3 IRQ tasklet during teardown

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/siw: Fix qp use-after-free in siw_get_base_qp()

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/cxgb4: Fix skb reference leak in rx_pkt()

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/cxgb4: Fix neigh reference leak in rx_pkt()

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: free RX skb when URB submission fails

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Use dev_* instead of pr_info

Jeremy Bongio <jbongio@google.com>
    RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation

Jisheng Zhang <jszhang@kernel.org>
    regulator: mp886x: fix pontential division by zero

Jisheng Zhang <jszhang@kernel.org>
    regulator: mp886x: check get_voltage_sel() return value

Dmitry Antipov <dmantipov@yandex.ru>
    leds: flash: Prevent using uninitialized variable in flash_fault_show()

Li RongQing <lirongqing@baidu.com>
    RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb

Cong Nguyen <congnt264@gmail.com>
    leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure

Haibo Chen <haibo.chen@nxp.com>
    leds: pca9532: Check i2c_smbus_read_byte_data() return value

Andrea Parri <parri.andrea@gmail.com>
    pstore: reject persistent RAM zones too small for the buffer header

Andrea Parri <parri.andrea@gmail.com>
    pstore: don't leave an ERR_PTR in the ramoops zone pointer

Neil Armstrong <neil.armstrong@linaro.org>
    dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.

Pengpeng Hou <hppiscas@163.com>
    pmdomain: imx: Propagate SCU provider registration failures

Xiang Mei <xmei5@asu.edu>
    fs/ntfs3: validate $SDH entry size in ntfs_insert_security

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()

Xiang Mei (Microsoft) <xmei5@asu.edu>
    fs/ntfs3: check INDEX_ROOT resident size before use in ntfs_read_mft()

Daniel Borkmann <daniel@iogearbox.net>
    bpf, lsm: Reject writes into the BPF LSM program context

Hou Tao <houtao1@huawei.com>
    bpf: Factor out helpers for ctx access checking

Triet Hoang <triet.hoang.dev@gmail.com>
    clk: raspberrypi: Handle cpufreq device registration failure

Karl Asseily <karl@asseily.com>
    dt-bindings: vendor-prefixes: add ESS Technology

Felix Gu <ustc.gu@gmail.com>
    spi: mxic: fix ps_clk leak in runtime resume

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Validate the _CPC package header

Li RongQing <lirongqing@baidu.com>
    RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT

Slavin Liu <bolin.liu@seu.edu.cn>
    crypto: atmel-sha - reject initialization without a device

Julian Braha <julianbraha@gmail.com>
    kconfig: fix extra output from savedefconfig on out-of-range defaults

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: default to zero if int/hex symbol lacks default property

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: remove unneeded symbol_empty variable

Vladimir Oltean <vladimir.oltean@nxp.com>
    PCI: cadence: Preserve all error codes in cdns_plat_pcie_probe()

Nikolay Borisov <nik.borisov@suse.com>
    ata: sata_dwc_460ex: Don't enable interrupt if libATA core registration fails

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ata: sata_dwc_460ex: Use temporary variable for struct device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ata: sata_dwc_460ex: Use devm_platform_*ioremap_resource() APIs

Hari Mishal <harimishal1@gmail.com>
    drm/amd/pm: bound SCLK FCW range entries to the table size

Pengpeng Hou <hppiscas@163.com>
    clk: milbeaut: Return divider update timeouts

Zhihao Cheng <chengzhihao1@huawei.com>
    md/raid5: setup_conf: Fix null-ptr-def in error handling path

Yogesh Gaur <yogeshgaur.83@gmail.com>
    md/raid5: don't BUG() on an inconsistent reshape state from the superblock

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    md: reject v0.90 arrays with too many devices

Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
    staging: iio: adc: ad7816: Fix DMA safety issues in SPI transfers

Bart Van Assche <bvanassche@acm.org>
    scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp

Slavin Liu <bolin.liu@seu.edu.cn>
    ACPI: tables: handle failed initrd override mappings

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock

Sarthak Sharma <sarthak.sharma@arm.com>
    mm/gup_test: report actual pinned bytes

Sarthak Sharma <sarthak.sharma@arm.com>
    mm/gup_test: safely calculate GUP batch size

Samuel Moelius <sam.moelius@trailofbits.com>
    mm/gup_test: reject wrapped user ranges

Weiming Shi <bestswngs@gmail.com>
    ntfs3: fix out-of-bounds read in ntfs_read_mft()

Karl Mehltretter <kmehltretter@gmail.com>
    loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation

Rosen Penev <rosenp@gmail.com>
    dmaengine: mv_xor: kill tasklet on channel add error path

Yonghao Zhang <hyz3367@gmail.com>
    remoteproc: core: Set trace buffer name for diagnostics

Li RongQing <lirongqing@baidu.com>
    RDMA/uverbs: Make CQ handle mandatory for WQ creation

Miles Krause <mileskrause5200@gmail.com>
    memory: emif: fix device_node reference leak on np_ddr

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    memory: emif: Convert to platform remove callback returning void

Gregory CLEMENT <gregory.clement@bootlin.com>
    phy: cadence: Sierra: Do not modify register when getting parent clock

Linkai Gong <gonglinkai@kylinos.cn>
    firmware: imx: dsp: fix mailbox channel leak on kasprintf failure

Karl Mehltretter <kmehltretter@gmail.com>
    wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc

Thomas Weißschuh <linux@weissschuh.net>
    microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS

Thomas Weißschuh <linux@weissschuh.net>
    microblaze: uaccess: Zero out destination on failed get_user()

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: zero frame pages on read error

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs: Do not kmap page cache pages for compression

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs3: Remove calls to set/clear the error flag

Ian Rogers <irogers@google.com>
    perf header: Fix potential memory corruption in cpu_cache_level__read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: video: Fix backlight unregistration ordering

Karl Mehltretter <kmehltretter@gmail.com>
    ALSA: control: Fix virtual master creation reference in kernel-doc

Karl Mehltretter <kmehltretter@gmail.com>
    gfs2: Fix the return value in gfs2_get_link() kernel-doc

Karl Mehltretter <kmehltretter@gmail.com>
    ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc

Karl Mehltretter <kmehltretter@gmail.com>
    spi: Fix the return value in spi_new_ancillary_device() kernel-doc

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    x86/svm: Avoid sign extension of SVM_EVTINJ_VALID in 64-bit expressions

Nora Schiffer <nora.schiffer@ew.tq-group.com>
    ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    ARM: dts: imx7-tqma7: add SPI-NOR flash

Marek Vasut <marex@nabladev.com>
    ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a

Xueqin Luo <luoxueqin@kylinos.cn>
    cpuidle: teo: Do not return a disabled idle state

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200

Xueqin Luo <luoxueqin@kylinos.cn>
    cpuidle: menu: Do not return a disabled idle state

Christian Loehle <christian.loehle@arm.com>
    cpuidle: menu: Remove single state handling

Breno Leitao <leitao@debian.org>
    cpuidle: menu: Remove incorrect unlikely() annotation

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: remove unused link field in fw_packet structure

Karl Mehltretter <kmehltretter@gmail.com>
    firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Fix up and adjust acpi_unbind_one()

Jan Kara <jack@suse.cz>
    gfs2: Fix journaled truncate range end offset

Jiawen Liu <1298662399@qq.com>
    memory: exynos5422-dmc: handle clock enable failures

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - avoid OOB read when stripping RSA leading zeros

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    crypto: amlogic - Fix DMA memory leak in cipher error path

Jack Wang <jinpu.wang@ionos.com>
    crypto: amlogic - Fix dma_map_sg error check

Eric Dumazet <edumazet@google.com>
    ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup

Eric Dumazet <edumazet@google.com>
    sit: fix UAF in ipip6_tunnel_del_prl()

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Propagate mode enable read errors

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Test dedicated enable bits only

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Treat cut 1.0 VAUX3 as fixed

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Handle AB8505 VINTCORE selector 7

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Add AB8505 VAUX3 3.05 V setting

Babanpreet Singh <bbnpreetsingh@gmail.com>
    regulator: ab8500: Remove stale expand_register kernel-doc entry

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Fix AB8505 VANA voltage selectors

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan

Jia Wang <wangjia@ultrarisc.com>
    dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position

Jia Wang <wangjia@ultrarisc.com>
    dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access

Arnd Bergmann <arnd@arndb.de>
    Kbuild: move to -std=gnu11

Mark Rutland <mark.rutland@arm.com>
    Kbuild: use -Wdeclaration-after-statement

Jia Wang <wangjia@ultrarisc.com>
    dmaengine: dw-axi-dmac: Fix AXI burst length encoding

Rosen Penev <rosenp@gmail.com>
    dmaengine: fsl_raid: zero CF descriptor pool allocations

Keisuke Tsukuda <catnyaaan@outlook.com>
    usb: gadget: f_mass_storage: ignore class requests while inactive

Keisuke Tsukuda <catnyaaan@outlook.com>
    usb: gadget: composite: avoid warning on aborted delayed status

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    dmaengine: sprd: use clk_bulk API to fix clock imbalance

Pengpeng Hou <pengpeng@iscas.ac.cn>
    usb: musb: da8xx: depopulate OF children on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    usb: musb: da8xx: depopulate OF children on remove

Arka Mondal <arka@arkamondal.net>
    usb-storage: alauda: fix out-of-bounds zone index

Arka Mondal <arka@arkamondal.net>
    usb-storage: alauda: check the return value of alauda_read_map()

Arka Mondal <arka@arkamondal.net>
    usb-storage: alauda: do not do DMA from the stack

Yuho Choi <dbgh9129@gmail.com>
    USB: pci-quirks: Release EHCI device reference

Jiangong.Han <jiangong.han@windriver.com>
    USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init() fails

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    usb: image: microtek: stop SG processing after transfer errors

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix GID capacity loss in 64K system

Yuho Choi <dbgh9129@gmail.com>
    PCI: xgene: Use managed clock for PCIe controller

Karl Mehltretter <kmehltretter@gmail.com>
    efi/libstub: Fix efi_set_event_at() parameter documentation

Salah Triki <salah.triki@gmail.com>
    iio: imu: adis16400: Check return value of spi_setup()

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix use-after-free of the firmware event workqueue

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds sense buffer access

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds reply frame access

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Gracefully handle online FW update operation

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Add IOC reinit function

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Handle offline FW activation in graceful manner

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Code refactor of IOC init - part2

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Code refactor of IOC init - part1

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Display IOC firmware package version

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Update MPI3 headers - part2

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Add debug APIs based on logging_level bits

Linmao Li <lilinmao@kylinos.cn>
    power: supply: bq2515x: Propagate charge-enable read errors

Ryan Brue <ryanbrue.dev@gmail.com>
    power: supply: bq24190_charger: use the wake irq API

Peng Fan <peng.fan@nxp.com>
    PM: sleep: wakeirq: Introduce device-managed variant of dev_pm_set_wake_irq()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    PM: wakeup: implement devm_device_init_wakeup() helper

Johan Hovold <johan+linaro@kernel.org>
    PM: sleep: wakeirq: drop unused enable helpers

Bjorn Helgaas <bhelgaas@google.com>
    PM: wakeup: Unify device_init_wakeup() for PM_SLEEP and !PM_SLEEP

Karl Mehltretter <kmehltretter@gmail.com>
    power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()

Mikhail Lobanov <m.lobanov@rosalinux.ru>
    wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: utils: Adjust message printing macros for ACPI objects

Ian Gallagher <cdine@cdine.org>
    ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310

Vinod Koul <vkoul@kernel.org>
    dmaengine: zynqmp_dma: drop redundant label

Srinivas Neeli <srinivas.neeli@amd.com>
    dmaengine: xilinx_dma: Move descriptors to done list based on completion bit

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    dmaengine: xilinx_dma: Freeup active list based on descriptor completion bit

Srinivas Neeli <srinivas.neeli@amd.com>
    dmaengine: xilinx_dma: Fix MCDMA descriptor fields based on DMA direction

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API

Walker Chen <walker.chen@starfivetech.com>
    dmaengine: dw-axi-dmac: Add support for StarFive JH7110 DMA

Pandith N <pandith.n@intel.com>
    dmaengine: dw-axi-dmac: support DMAX_NUM_CHANNELS > 8

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Fix chan probe/remove error handling

Abin Joseph <abin.joseph@amd.com>
    dmaengine: zynqmp_dma: Add support for AMD Versal Gen 2 DMA IP

Michael Tretter <m.tretter@pengutronix.de>
    dmaengine: zynqmp_dma: simplify with dev_err_probe

Ruoyu Wang <ruoyuw560@gmail.com>
    dmaengine: img-mdc: Fix runtime PM usage counter leak

Myeonghun Pak <mhun512@gmail.com>
    dmaengine: mediatek: hsdma: fix runtime PM leak on init failure

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: sun6i-dma: Fix use-after-free in error handling paths

Samuel Holland <samuel@sholland.org>
    dmaengine: sun6i: Do not use virt_to_phys

Karl Mehltretter <kmehltretter@gmail.com>
    mtd: spinand: Fix spinand_manufacturer_ops kernel-doc

Manush Prajwal <manushprajwal555@gmail.com>
    pwm: lp3943: fix NULL pointer dereference for an unconfigured channel

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lp3943: Drop usage of pwm_[gs]et_chip_data()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt6797: fix wrong unwind order and error code in enable_clock

Chen-Yu Tsai <wenst@chromium.org>
    pwm: mtk-disp: Fix period readback

Karl Mehltretter <kmehltretter@gmail.com>
    irqchip/gic-v3-its: Don't WARN on LPI free allocation failure

Linkai Gong <gonglinkai@kylinos.cn>
    drivers/base/node: fix UAF on device_register() failure

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpio: crystalcove: add missing MODULE_ALIAS()

Felix Gu <ustc.gu@gmail.com>
    spi: mtk-nor: fix runtime PM usage count leak in probe error path

Dave Jiang <dave.jiang@intel.com>
    efi/cper: Read only validated fields in cper_mem_err_pack()

Dave Jiang <dave.jiang@intel.com>
    ACPI: extlog: Validate elog record length before walking sections

Dave Jiang <dave.jiang@intel.com>
    efi/cper: Reject an error status block length that wraps a u32

Dave Jiang <dave.jiang@intel.com>
    efi/cper: Reject CPER records with an out-of-range error_data_length

Jisheng Zhang <jszhang@kernel.org>
    regulator: mp886x: fix vsel_mask

Pengpeng Hou <pengpeng@iscas.ac.cn>
    memory: brcmstb_dpfe: validate firmware section sizes

Julius Bairaktaris <julius@bairaktaris.de>
    wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs

Fabrice Derepas <fabrice.derepas@canonical.com>
    crypto: asymmetric_keys - fix OOB read in pefile_parse_binary

Ruoyu Wang <ruoyuw560@gmail.com>
    hwrng: cctrng - Fix runtime PM usage counter leak

Paul Dolan <paul.dolan.dev@gmail.com>
    selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test

Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
    clk: Use the generic OF phandle parsing in only one place

Rosen Penev <rosenp@gmail.com>
    dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources

Rosen Penev <rosenp@gmail.com>
    dmaengine: fsl_raid: don't invoke client callback under desc_lock

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming

Danila Chernetsov <listdansp@mail.ru>
    dlm: validate lock modes in recovery messages

Alexander Aring <aahringo@redhat.com>
    dlm: use __le types for dlm header

Alexander Aring <aahringo@redhat.com>
    fs: dlm: add debugfs rawmsg send functionality

Alexander Aring <aahringo@redhat.com>
    fs: dlm: let handle callback data as void

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
    wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfigured

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    microblaze: prevent ptrace writes to MSR and pt_mode

Alexander A. Klimov <grandmaster@al2klimov.de>
    microblaze: CCF: fix refcount leak

Jerome Brunet <jbrunet@baylibre.com>
    clk: fix self-consuming provider module pinning

Orgad Shaneh <orgads@gmail.com>
    staging: octeon: schedule the TX cleanup tasklet every 1024th packet

Myeonghun Pak <mhun512@gmail.com>
    staging: rtl8723bs: disable SDIO function on block size failure

Ethan Tidmore <ethantidmore06@gmail.com>
    staging: rtl8723bs: remove unused private debug counters

Michael Straube <straube.linux@gmail.com>
    staging: rtl8723bs: move rtw_recv_indicatepkt to rtw_recv.c

Michael Straube <straube.linux@gmail.com>
    staging: rtl8723bs: remove wrapper rtw_init_recv_timer

Michael Straube <straube.linux@gmail.com>
    staging: rtl8723bs: remove return from void function

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    staging: rtl8723bs: change remaining printk to proper api

Felix Gu <ustc.gu@gmail.com>
    spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls

Ruoyu Wang <ruoyuw560@gmail.com>
    pwm: renesas-tpu: Fix runtime PM reference leak

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: renesas: Drop usage of pwm_[gs]et_chip_data()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: renesas-tpu: Improve maths to compute register settings

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: renesas-tpu: Rename variables to match the usual naming

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: renesas-tpu: Implement .apply() callback

David Heidelberg <david@ixit.cz>
    ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate unwinding sizes against record payload

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate sym string NUL-termination in code load

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate debug entries on native (non-swap) path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Check snprintf return before computing header size

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Bounds-check debug entry byte-swap loop

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Prevent integer underflow in debug info size calculation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate code_size against total_size in code load

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Fix debug_data and unwinding_data leaks

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Fix extended header read that always fails

Breno Leitao <leitao@debian.org>
    kexec_file: stop the top-down search before it underflows

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: fix spi1 location

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: fix vbus-supply for USB2 PHY

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada-388-helios4: fix vmmc property name

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada-385-clearfog-gtr: fix vmmc property name

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: fix lm75 supply name

Salah Triki <salah.triki@gmail.com>
    iio: temperature: tmp117: fix calibbias cache update on I2C write failure

Adi Nata <adinata.softwareengineer@gmail.com>
    iio: humidity: hts221: report available values via read_avail()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    spi: sh-msiof: propagate setup runtime-PM errors

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: sh-msiof: SITMDR1/SIRMDR1 bitfield conversion

Chandradhar Kumar <chandradhar.2003@gmail.com>
    regulator: fixed: reject incompatible platform devices

Yuan Chen <chenyuan_fl@163.com>
    bpftool: Fix spurious batch file read error

Andreas Kemnade <andreas@kemnade.info>
    drm/omap: dsi: avoid sending bta sync all the time in writes

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Prevent division by 0

Raveendra Talabattula <raveendra.talabattula@arm.com>
    drm/komeda: Fix bits parsing of GLB_CORE_ID

Nathan Chancellor <nathan@kernel.org>
    extract-cert: Wrap key_pass with '#ifdef USE_PKCS11_ENGINE'

Jan Stancek <jstancek@redhat.com>
    sign-file,extract-cert: use pkcs11 provider for OPENSSL MAJOR >= 3

Jan Stancek <jstancek@redhat.com>
    sign-file,extract-cert: avoid using deprecated ERR_get_error_line()

Jan Stancek <jstancek@redhat.com>
    sign-file,extract-cert: move common SSL helper functions to a header

Sean Christopherson <seanjc@google.com>
    KVM: x86: Unconditionally reset MMU context when emulating INIT

Milan Milicevic <Milan.Milicevic@amd.com>
    drm/amdgpu: publish IH enabled before PSP programs IH_RB_CNTL

Matthias Goergens <matthias.goergens@gmail.com>
    udf: don't use eloc after the end of the unallocated space table

Daejun Park <daejun7.park@samsung.com>
    xfs: add a flag to convert unwritten extents without allocating blocks

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate move extents against a stable EOF

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at

Pei Xiao <xiaopei01@kylinos.cn>
    comedi: dt2811: fix shift-out-of-bounds in IRQ check

Chuck Lever <cel@kernel.org>
    SUNRPC: Copy the deferred RPC Call from the head buffer

Yang Zi <2959243019@qq.com>
    comedi: addi_apci_3xxx: fix subdevice count underallocation

Amir Goldstein <amir73il@gmail.com>
    ovl: inherit FMODE_NONOTIFY when reading directory layers

Andrew Kanner <andrew.kanner@gmail.com>
    selinux: prevent KMSAN warning in selinux_inet_conn_request()

Daejun Park <daejun7.park@samsung.com>
    xfs: cap the block count of xfs_iomap_write_direct() at one extent

Daejun Park <daejun7.park@samsung.com>
    xfs: mark the inode preallocated for pNFS write layouts past EOF

Josef Bacik <josef@toxicpanda.com>
    mm/filemap: don't lose a folio lock wakeup to a signal

Lucas Tanure <lucas.tanure@neat.no>
    drm/vc4: hdmi: enable scrambling before the TMDS clock starts

Chengfeng Ye <nicoyip.dev@gmail.com>
    xfrm: retry inexact policy lookup after node reinsertion

Hongbin Wang <wh_bin@126.com>
    xfrm: Drop unused argument

Zhe Liu <liuzhe1@kylinos.cn>
    blk-iocost: account flush sequence latency only once

Bart Van Assche <bvanassche@acm.org>
    blk-iocost: Simplify ioc_rqos_done()

Josef Bacik <josef@toxicpanda.com>
    mm/mmu_notifier: finish non-blocking interval invalidation on error

Jann Horn <jannh@google.com>
    mm: document mmu_notifier_invalidate_range_start_nonblock()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Cap number of parent PTEs per SP at 1000 (the arbitrary rmap limit)

Yingjie Wang <1075151112@qq.com>
    nvmet: reject keep-alive timeouts that would overflow

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: make shmem_file() check the file's inode

Zhou Qiuyue <n0ps1edzz@gmail.com>
    ipv6: raw: fix use-after-free in rawv6_send_hdrinc()

David Hildenbrand (Arm) <david@kernel.org>
    mm/filemap: finish fault cleanup before dropping the fault lock

chenglong.ma <longpareto@gmail.com>
    vduse: fix VA/PA confusion in the coherent page fault path

Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>
    ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Avoid closing unowned DDC pins

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: read the xattr entry hash before defragmenting the bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not read the entry array of an empty xattr bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: use the stored hash when checking xattr bucket collision

renpanpan <renpanpan@kylinos.cn>
    drm/amdgpu: Only enable HDMI audio if display supports it

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Check for NULL platform device in hotplug callbacks

David Hildenbrand (Arm) <david@kernel.org>
    fork: take mmap_lock before copying mm_struct

David Hildenbrand (Arm) <david@kernel.org>
    mm/rmap: handle device-exclusive entries in folio_referenced_one()

Thorsten Blum <blum@kernel.org>
    hwrng: virtio - prevent use-after-free after a failed restore

Josef Bacik <josef@toxicpanda.com>
    mm/filemap: read mapping->a_ops->free_folio under i_lock

Cong Zhang <cong.zhang@oss.qualcomm.com>
    virtio_blk: use synchronous quiesce in virtblk_freeze_priv()

Jiale Yao <yaojiale02@163.com>
    hwmon: (aquacomputer_d5next) reject short status reports

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    apparmor: fix query_data() output overlapping the lookup key

Gregory Price <gourry@gourry.net>
    mm/userfaultfd: compare exact registration modes before skipping

David Hildenbrand (Arm) <david@kernel.org>
    mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs

Chris Mason <mason@kernel.org>
    mm/memory: reject remote COW faults on PFN mappings

Chris Down <chris@chrisdown.name>
    mm: make swapoff interruptible when unusing mms/shmem

Gregory Price (Meta) <gourry@gourry.net>
    mm/mempolicy: apply bind policies against the scoped allocation zone

Eklavya Singh <eklavyasingh2106@gmail.com>
    ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute

David Hildenbrand (Arm) <david@kernel.org>
    mm/vma: don't leak the charge for stack growth

Daejun Park <daejun7.park@samsung.com>
    nvme: unregister when pr_register() is given a zero new key

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: don't walk the CS chunks when allocating them failed

Guenter Roeck <linux@roeck-us.net>
    hwmon: (tmp108) Fix initial conversion delay and wait until ready

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()

Myeonghun Pak <mhun512@gmail.com>
    fbdev: kyro: Release WC setup on registration failure

Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
    fbdev: kyro: Use devm_ioremap_wc() for screen mem

Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
    fbdev: kyro: Use devm_ioremap() for mmio registers

Matthias Goergens <matthias.goergens@gmail.com>
    udf: fix preallocation discarding before an empty allocation extent

Chris Mason <mason@kernel.org>
    mm/huge_memory: fix truncate racing with PMD zapping

Chris Mason <mason@kernel.org>
    aio: fix NULL deref when a fault races ring truncation

Chengfeng Ye <nicoyip.dev@gmail.com>
    l2tp: snapshot sequencing state when building transmit headers

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Don't map an LPI from more than one event

Yu Zhang <yuz08559@gmail.com>
    scsi: target: Fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown

Ian Bridges <icb@fastmail.org>
    ksmbd: do not read past the DACL in the access denied debug message

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: keep the CS user fence BO in GTT

Milan Milicevic <Milan.Milicevic@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: enable Navi 48-bit IH timestamp counter

Yuho Choi <oss.patchbox@gmail.com>
    iommu/virtio: Reset device before deleting virtqueues on probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi: Handle msm_hdmi_power_on() errors during .atomic_pre_enable()

Chris Mason <mason@kernel.org>
    ovl: look up the index by the decoded origin

Leo Liu <leo.liu@amd.com>
    drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce/jpeg

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: do not give all non-blocking requests reserve access

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/huge pud: use transparent huge pud helpers only with CONFIG_TRANSPARENT_HUGEPAGE

Josef Bacik <josef@toxicpanda.com>
    mm/mremap: fix moving PUD leaves

Chris Mason <mason@kernel.org>
    backing-file: always end a queued write

Myeonghun Pak <mhun512@gmail.com>
    hwmon: (sht15) Stop deferred work before releasing its resources

Will Deacon <will@kernel.org>
    tools: linux/types.h: Add 128-bit integer types for arm64 UAPI structures

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Prevent O_APPEND open on OSS streams

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Optimize cpu_latency_qos_*() calls

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: cache the mount context for dentry lock callbacks

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ocfs2: constify struct ocfs2_lock_res_ops

Kyle Zeng <kylebot@openai.com>
    mptcp: pm: kernel: use RCU to free endpoint listeners

John Johansen <john.johansen@canonical.com>
    apparmor: on failed load ensure profile files are removed before parent

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Remove an always-false WARN_ONCE()

Konstantin Khorenko <khorenko@virtuozzo.com>
    selftests/core: fix unshare_test with large fs.nr_open

Al Viro <viro@zeniv.linux.org.uk>
    selftests:core: test coverage for dup_fd() failure handling in unshare_fd()

Chengfeng Ye <nicoyip.dev@gmail.com>
    mm/ksm: mark migration stores with WRITE_ONCE()

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: finish GPU recovery callbacks before restarting schedulers

Daejun Park <daejun7.park@samsung.com>
    xfs: don't skip free extents of the longest length in a whole-AG FITRIM

Chao Yu <chao@kernel.org>
    f2fs: fix to fetch ino via ino_of_node() under cache lock

Amir Goldstein <amir73il@gmail.com>
    ovl: inherit FMODE_NONOTIFY when opening directory realfiles

Darong Lu <zzyy19904204639@163.com>
    libceph: initialize CRUSH choose argument weights

Chao Yu <chao@kernel.org>
    f2fs: fix to update superblock crc in sanity_check_area_boundary()

Wei Yang <albinwyang@tencent.com>
    mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: remove fs entries created by a failed policy load

David Hildenbrand (Arm) <david@kernel.org>
    mm/userfaultfd: wake waiters when registration modes are removed

Jake Labelle <southampton.jake.labelle@gmail.com>
    nilfs2: validate directory position after llseek in readdir

Christian Brauner <brauner@kernel.org>
    proc: don't let an entry below /proc/<pid>/net be a mountpoint

Al Viro <viro@zeniv.linux.org.uk>
    switch procfs from d_set_d_op() to d_splice_alias_ops()

Al Viro <viro@zeniv.linux.org.uk>
    new helper: d_splice_alias_ops()

Al Viro <viro@zeniv.linux.org.uk>
    procfs: kill ->proc_dops

Christian Brauner <brauner@kernel.org>
    proc: add proc_splice_unmountable()

Al Viro <viro@zeniv.linux.org.uk>
    /proc/sys: use d_splice_alias() calling conventions to simplify failure exits

Cheng Yongkang <teel4res@gmail.com>
    io_uring/timeout: count cancelled timeouts in cq_timeouts

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: compress: fix buffer leak on failed SET_PARAMS

guolingxing <guolingxing@tju.edu.cn>
    btrfs: prevent deleting the wrong subvolume by ID

Yao Yiqi <yaoyiqi3@huawei.com>
    fbcon: Rebuild rotated font buffer on font change

Ian Bridges <icb@fastmail.org>
    ksmbd: enforce the read-only share flag when creating a stream

David Hildenbrand (Arm) <david@kernel.org>
    mm/ksm: fix use of a freed anon_vma at swap-in

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    9p/xen: drain response work after unbinding IRQ

Eric Dumazet <edumazet@kernel.org>
    inet: frags: limit the truesize of a reassembly queue

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Check validity of vmcs01 save area copied from SMRAM on RSM

Kyle Zeng <kylebot@openai.com>
    net/packet: check TX_RING fragments before memory accounting

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: keep gc's cleanup out of the live tree on allocation failure

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: don't chain a new shortcut onto an existing one

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: choose between splitting a node and a shortcut without gotos

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: move shortcut creation into a function of its own

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: move node splitting into a function of its own

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: fill the segment cache in one place

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: move in-place insertion into a function of its own

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: don't lose objects when a root shortcut is split at level 4

Linus Torvalds <torvalds@linux-foundation.org>
    assoc_array: don't lose objects when a shortcut is split on a word boundary

Len Baker <len.baker@gmx.com>
    assoc_array: Avoid open coded arithmetic in allocator arguments

Zhengchao Shao <shaozhengchao@huawei.com>
    ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    splice: fsnotify_access(fd)/fsnotify_modify(fd) in vmsplice

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    splice: fsnotify_access(in), fsnotify_modify(out) on success in tee

Eric Dumazet <edumazet@kernel.org>
    dlm: fix send buffer backpressure handling

Runyu Xiao <runyu.xiao@seu.edu.cn>
    media: sti: delta: use unaligned accessors for MJPEG SOF fields

Niklas Cassel <cassel@kernel.org>
    ata: libata: Do not leave ata_host_stop() registered when activation fails

Armaan Sandhu <armaan.sandhu0504@gmail.com>
    lib/cmdline: fix get_options() count and overflow with large ranges

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    drm/amdkfd: stop restore retries on device unplug

Guangshuo Li <lgs201920130244@gmail.com>
    media: atmel-isi: release unregistered video device on remove

Tim Douglas <me@timdoug.com>
    power: supply: generic-adc-battery: fix status with no supplier

Nikolaj Klitlund Børty <nbn@sj.dk>
    Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)

Myeonghun Pak <mhun512@gmail.com>
    fbdev: nvidia: Release write-combining handle on probe failure

Maurizio Casciano <mauriziocasciano7@gmail.com>
    power: supply: core: Honor supplied-from with CONFIG_OF=y

Francesco Orlando <francesco.orlando99@libero.it>
    Input: xpad - add GameSir Nova Lite support

Myeonghun Pak <mhun512@gmail.com>
    wifi: mt76: mt7615: restore DBDC state after ext PHY failure

Niklas Cassel <cassel@kernel.org>
    ata: libahci: Free the IRQs when activating a multi-IRQ host fails

Niklas Cassel <niklas.cassel@wdc.com>
    ata: ahci: print the lpm policy on boot

Wentao Liang <vulab@iscas.ac.cn>
    power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()

David Heidelberg <david@ixit.cz>
    mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: wcd934x: Fix an error handling path in wcd934x_slim_probe()

Maíra Canal <maira.canal@usp.br>
    mfd: wcd934x: Replace legacy gpio interface for gpiod

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200

Breno Leitao <leitao@debian.org>
    dcache: report a Tasks-RCU quiescent state in dentry_kill()

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: omap-sham - fix crypto engine cleanup

Fan Wu <fanwu01@zju.edu.cn>
    virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree

David Hildenbrand (Arm) <david@kernel.org>
    mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast

Samarth Narang <samarth.colleges@gmail.com>
    mm/ksm: keep soft-dirty when merging a page

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Turn vcpu->arch.pause into a counter

Henrik Enquist <henrik.enquist@gmail.com>
    ALSA: aloop: Update the PCM Slave controls for a matching playback

Henrik Enquist <henrik.enquist@gmail.com>
    ALSA: aloop: Don't constrain playback params in notify mode

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: initialize heartbeat regions before publishing them

Daeho Jeong <daehojeong@google.com>
    f2fs: release a removed xattr node in roll-forward recovery

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: fill the pwr_regs bulk regulators

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: use bulk regulator API

Sumit Kumar <sumit.kumar@oss.qualcomm.com>
    PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register

Hung-Jui Lin <alex.lin.programmer@gmail.com>
    posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: remove ifaddr from hash during ifdown list cleanup

Eric Dumazet <edumazet@google.com>
    ipv6/addrconf: allocate a per netns hash table

Eric Dumazet <edumazet@google.com>
    ip6mr: fix use-after-free in ip6mr_sk_done()

Eric Dumazet <edumazet@google.com>
    ip6mr: ip6mr_sk_done() can exit early in common cases

Breno Leitao <leitao@debian.org>
    ACPI: APEI: accumulate the queued flag across error sections

Adrian Ambrozewicz <aambrozewicz@nvidia.com>
    gpiolib: cdev: don't set GPIOD_FLAG_IS_OUT

Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
    mfd: tps65217: Use devres for IRQ domain and wake teardown

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/ttm: return an error when kmapping a BO without pages

Nicolai Buchwitz <nb@tipi-net.de>
    serial: amba-pl011: keep transmitter enabled when disabling RS485

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: amba-pl011: remove redundant code in rs485_config

Sean Young <sean@mess.org>
    media: serial_ir: Fix race condition where timer can be re-armed

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: bsg: Reject UIC commands with a non-zero result byte

Christian Brauner <brauner@kernel.org>
    iomap: don't mark unwritten parts of a folio uptodate

Breno Leitao <leitao@debian.org>
    mm/shmem: report RCU-tasks quiescent states while undoing a range

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe-17x: Fix write master selection for RDI lines

Linmao Li <lilinmao@kylinos.cn>
    PCI: cadence: Store the core controller in platform drvdata

Oleg Nesterov <oleg@redhat.com>
    signalfd: don't dequeue the forced fatal signals

Thomas Gleixner <tglx@linutronix.de>
    signal: Remove task argument from dequeue_signal()

Eric W. Biederman <ebiederm@xmission.com>
    signal: Requeue signals in the appropriate queue

Giorgi Kobakhia <gkobakhi@asu.edu>
    ocfs2: fix array out of bound access in __ocfs2_find_path()

Edward Adam Davis <eadavis@qq.com>
    ocfs2: fix oob in __ocfs2_find_path

Hsiu-Hsien Lee <swinds24@gmail.com>
    ext4: fix fast commit replay failing on a read-only mount

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid updating the superblock on a r/o mount if not needed

Ye Bin <yebin10@huawei.com>
    ext4: commit super block if fs record error when journal record without error

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: fix defragment writeback range truncation on 32-bit

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to adjust appropirate defragment pg_end

sung byeongchan <tjdqudcks0424@naver.com>
    ceph: validate MDS reply fragtree split array length

Alex Kazinsky <a.kazinsky@ideco.ru>
    ASoC: tlv320aic32x4: Prevent division by zero in divider callbacks

Guiting Shen <aarongt.shen@gmail.com>
    ASoC: tlv320aic32x4: Fix the divide by zero

Maxime Ripard <maxime@cerno.tech>
    ASoC: tlv320aic32x4: div: Switch to determine_rate

Nikolaos Karaolidis <nick@karaolidis.com>
    fs: don't lose inodes that another LRU walker is isolating

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    ceph: fix 32-bit overflow in readdir reply count check

Robert Foss <robert.foss@linaro.org>
    media: camss: vfe: Don't call hw_version() before its dependencies are met

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe: Fix VFE reset while another line is streaming

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Move vfe_disable into a common routine where applicable

Robert Foss <robert.foss@linaro.org>
    media: camss: vfe: Rework vfe_hw_version_read() function definition

Robert Foss <robert.foss@linaro.org>
    media: camss: vfe: Remove vfe_hw_version_read() argument

Robert Foss <robert.foss@linaro.org>
    media: camss: vfe: Decrease priority of of VFE HW version to 'dbg'

Robert Foss <robert.foss@linaro.org>
    media: camss: vfe: Don't read hardware version needlessly

Ridham Khurana <khurana.ridham222@gmail.com>
    hwmon: (lm70) Fix rounding of negative temperatures

Joanne Koong <joannelkoong@gmail.com>
    fuse: don't drop destination page cache on a zero byte copy reply

Ma Ke <make_ruc2021@163.com>
    i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()

Hans de Goede <hdegoede@redhat.com>
    i2c: acpi: Add i2c_acpi_new_device_by_fwnode() function

Hongyan Xu <getshell@seu.edu.cn>
    mfd: da903x: Cancel IRQ work during teardown

Nikolaos Karaolidis <nick@karaolidis.com>
    fs: rotate inodes whose page cache could not be dropped

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: bq27xxx: Ensure poll work is cancelled on remove

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    gpio: pca953x: Handle direction register read errors in IRQ paths

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Utilise temporary variable for struct gpio_chip

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    tpm: tpm2_probe: propagate transport errors

John Johansen <john.johansen@canonical.com>
    apparmor: fix refcount leak in aa_get_newest_profile()

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: do not touch WB registers when not streaming

Maciej Kucharek <qchcio@gmail.com>
    drm/amdgpu: reset SI ASIC on MacBookPros with VRAM at 0

Armin Wolf <W_Armin@gmx.de>
    hwmon: (acpi_power_meter) Fix 18.45 TW bug

Alexey Charkov <alchark@flipper.net>
    nvmem: rockchip-otp: Serialize reads

Rosen Penev <rosenp@gmail.com>
    nvmem: rockchip-otp: alloc clks with main struct

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    nvmem: rockchip-otp: Add clks and reg_read to rockchip_data

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix REQ_FUA processing

Takashi Iwai <tiwai@suse.de>
    ALSA: emux: Stop voices before freeing zones in all cases

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emux: simplify snd_sf_list.callback handling

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emux: centralize & improve patch info validation

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: prune vestiges of SNDRV_SFNT_SAMPLE_{BIDIR,REVERSE}_LOOP support

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: reject CS chunks too large for kvmalloc()

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen-blkfront: Fix IO race during unplug

Nickolai Zeldovich <nickolai@csail.mit.edu>
    mm/mlock: use a long for the page count in mlock_fixup()

Wentao Liang <vulab@iscas.ac.cn>
    xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()

Yao Yiqi <yaoyiqi3@huawei.com>
    fbcon: Retry rotated font allocation after failure

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn

Takashi Iwai <tiwai@suse.de>
    ALSA: emux: Fix UAF of soundfont zones at note-on

Myeonghun Pak <mhun512@gmail.com>
    leds: ktd2692: Pass context to regulator cleanup

Runyu Xiao <runyu.xiao@seu.edu.cn>
    block: amiflop: synchronize flush timer before track flush

Joanne Koong <joannelkoong@gmail.com>
    fuse: don't launder folios of a bad inode

Nickolai Zeldovich <nickolai@csail.mit.edu>
    ucount: take the rlimit reference before checking the limit

Roman Gushchin <roman.gushchin@linux.dev>
    signal: restore the override_rlimit logic

Alexey Gladkov <legion@kernel.org>
    ucounts: Split rlimit and ucount values and max values

Eric W. Biederman <ebiederm@xmission.com>
    ucounts: Use atomic_long_sub_return for clarity

Kaixuan Li <kaixuanli0131@gmail.com>
    f2fs: bound the SIT/NAT bitmaps by the checkpoint pack

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: bsg: Clear the reply buffer before use

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250_exar: store the GPIO platform device in struct exar8250

Parker Newman <pnewman@connecttech.com>
    serial: exar: fix checkpach warnings

Parker Newman <pnewman@connecttech.com>
    serial: exar: add optional board_init function

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_exar: Clear interrupts before registering handler

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix subflow bitfield misuse

Janne Grunau <j@jannau.net>
    wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload

Runyu Xiao <runyu.xiao@seu.edu.cn>
    IB/hfi1: Shutdown self-rearming timers before freeing

Jiaming Zhang <r772577952@gmail.com>
    nilfs2: force clear dirty state when restoring from the shadow map

Myeonghun Pak <mhun512@gmail.com>
    soc: fsl: dpio: Free the IRQ before releasing the I/O object

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Drive at 2.5 GT/s, error other speeds

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    xen/pcifront: check that an AER callback exists before calling it

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    xen/pcifront: Drop pcifront_common_process() tests of pcidev, pdrv

Guangshuo Li <lgs201920130244@gmail.com>
    irqchip/imx-intmux: Fix runtime PM teardown on remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    irqchip/imx-intmux: Convert to platform_driver::remove_new() callback

Ruide Cao <caoruide123@gmail.com>
    mptcp: fix MP_CAPABLE token migration when cloning reqsk

Luxiao Xu <rakukuip@gmail.com>
    mm/memory: constrain generic_access_phys() to page boundary

Sung Byeongchan <tjdqudcks0424@naver.com>
    virtiofs: validate fixed-output response length

Yuto Ohnuki <ytohnuki@amazon.com>
    virtiofs: add FUSE protocol validation

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: declare MCR and IER as volatile registers

Nanzhe Zhao <zhaonanzhe@xiaomi.com>
    f2fs: remove mappedtodisk flag usage in mmap write path

Josef Bacik <josef@toxicpanda.com>
    net: skbuff: don't BUG() on a bad csum_start in skb_copy_and_csum_dev()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mpu401: shut down timer before freeing MPU

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Add error cleanup in zpci_directed_irq_init()

Andrey Misiurov <andrey.misyrov@gmail.com>
    fbdev: core: Initialize modelist in framebuffer_alloc()

Fan Wu <fanwu01@zju.edu.cn>
    media: rockchip: rga: quiesce IRQ before releasing m2m state

Sven Püschel <s.pueschel@pengutronix.de>
    media: rockchip: rga: use clk_bulk api

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: rockchip: rga: fix clock cleanup

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded

Jiale Yao <yaojiale02@163.com>
    cxl/acpi: Check ACPI companion before use

David Hildenbrand (Arm) <david@kernel.org>
    mm: disallow ioremap'ing ordinary RAM in generic_access_phys()

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: Serialize WMI method evaluations with a mutex

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mailbox: altera: shut down RX polling timer on channel teardown

Krzysztof Karas <krzysztof.karas@intel.com>
    iommu/dma: Catch scatterlist length overflows

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: hci_debugfs: Pin module for debugfs file operations

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Move all debugfs handling to hci_debugfs.c

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda/hdmi: clamp sad_count in ELD proc write handler

Myeonghun Pak <mhun512@gmail.com>
    mfd: twl-core: Unregister the auxiliary platform device on unbind

Thorsten Blum <thorsten.blum@linux.dev>
    mfd: twl-core: Use i2c_check_functionality as boolean value

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mfd: twl: Remove platform data support

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: vgic-v3: Roll back assignments from the new region

Daeho Jeong <daehojeong@google.com>
    f2fs: return -EIO for a lost inode block after cp_error

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip-host: Do not attempt 5.0 GT/s retraining

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Handle period elapsed calls outside the locks

Gregory Price <gourry@gourry.net>
    mm/madvise: use folio_trylock() in the cold/pageout PMD split

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ata: sata_inic162x: remove dangerous broken driver

Wentao Liang <vulab@iscas.ac.cn>
    media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()

Myeonghun Pak <mhun512@gmail.com>
    ASoC: stm: stm32_i2s: request IRQ after regmap initialization

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: stm: stm32_i2s: Drop redundant error messages

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: i2s: remove irqf_oneshot flag

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: ignore non-fatal signals during synchronous log write wait

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: correct return value kernel-doc descriptions for the rest

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: free interrupt before the clock in error path

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree

Tom Verdonck <tom.verdonck@inspiral.be>
    hwmon: (tmp108) Fix jiffies wraparound in conversion-ready check

Yunpeng Tian <shionthanatos@gmail.com>
    udf: validate the device specification EA before using it

Marek Czernohous <marek@czernohous.de>
    drm/nouveau/pci: use config-space MSI rearm on MCP79/MCP7A (NVAC)

Naman Jain <namjain@linux.microsoft.com>
    x86/init: Initialize wall clock in get_rtc_noop()

Hungyu Lin <dennylin0707@gmail.com>
    mm/migrate: untag addresses when querying page nodes

Wang Jiang <jiangwang@kylinos.cn>
    drm/amd/display: skip pre-flip post_update on DCE

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: hwdep: Serialize DSP load requests

David Hildenbrand (Arm) <david@kernel.org>
    mm/madvise: fix data loss from MADV_FREE on a KSM page

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect

Daehyeon Ko <4ncienth@gmail.com>
    splice: avoid stale f_pos writeback on error

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    splice: always fsnotify_access(in), fsnotify_modify(out) on success

Chung-Chiang Cheng <cccheng@synology.com>
    splice: report related fsnotify events

Kyle Zeng <kylebot@openai.com>
    mm/page_vma_mapped: continue past nonmatching huge PMDs

Dominik Maier <dmnk@google.com>
    loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()

Ido Schimmel <idosch@nvidia.com>
    ipmr, ip6mr: validate packets injected into the register vif on xmit

Josef Bacik <josef@toxicpanda.com>
    mm/hugetlb: unmap the page where the other VMA maps it

Sinan Turunc <enscrpt@pm.me>
    ALSA: usb-audio: Bound packet copies by the PCM buffer size

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix bounce buffer overflow

Yuejie Shi <syjcnss@gmail.com>
    fs/ntfs3: validate the EA value length in ntfs_read_ea()

Xiang Mei <xmei5@asu.edu>
    ceph: fix integer overflow in the snap trace bounds check

Pedro Falcato <pfalcato@suse.de>
    mm/madvise: atomically clear the young bit on THP MADV_COLD

Vaibhav Nagare <vnagare@redhat.com>
    bnxt_en: don't leave an XDP program installed when the open fails

Kyle Zeng <kylebot@openai.com>
    netfilter: nf_reject: initialize IPCB at inet ingress

Jun Yang <junvyyang@tencent.com>
    sctp: re-point retained control chunks on association migration

David Lee <david.lee@trailofbits.com>
    sctp: hold shkey across socket migration

Seungjin Bae <eeodqql09@gmail.com>
    usb: typec: ucsi: ccg: Validate altmode index in GET_CURRENT_CAM response

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: ecc - Handle exceptional points in Shamir multiplication

Sergey Senozhatsky <senozhatsky@chromium.org>
    ext4: fix ABBA deadlock in ext4_rmdir()

Abdifatah Suruur <suruurism@gmail.com>
    xen/gntdev: prevent private mappings from becoming writable

Jinwang Li <jinwang.li@oss.qualcomm.com>
    Bluetooth: L2CAP: Ignore connection responses with wrong ident

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Only accept connection responses to outstanding requests

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject signalling responses in invalid states

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Clear oob_skb in scan_inflight()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0

Punnay Sharma <punnaysharma805@gmail.com>
    staging: media: av7110: fix sp8870 initialization failure state

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: ov5647: fix power cleanup on remove

Sakari Ailus <sakari.ailus@linux.intel.com>
    platform/x86: int3472: Fix uninitialised variable warning

Sean Young <sean@mess.org>
    media: meson-ir-tx: Ensure probe error is propagated

Yihao Han <hanyihao@vivo.com>
    media: meson-ir-tx: remove superfluous dev_err()

Sean Young <sean@mess.org>
    media: redrat3: Error path leaves device in transmitting state

Esben Haabendal <esben@geanix.com>
    iio: light: ltr501: Power down chip if request irq fails

Jiaming Zhang <r772577952@gmail.com>
    gfs2: reject invalid inode sizes

Tom Verdonck <tom.verdonck@inspiral.be>
    hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: usb-audio: Protect Roland control activation

Wentao Liang <vulab@iscas.ac.cn>
    mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()

Fan Wu <fanwu01@zju.edu.cn>
    media: mediatek: vpu: free IRQ before destroying watchdog workqueue

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: mtk-vpu: Remove redundant 'flush_workqueue()' calls

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: vgic-v3: Undo assignment on iodev registration failure

Fabio Cesari <fabio.cesari@gmail.com>
    iio: light: isl29028: fix runtime PM reference leak on error paths

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE enabled

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: don't sleep in the clk .is_enabled callback

Hui Peng <benquike@gmail.com>
    seccomp: restore knotif->state when SECCOMP_ADDFD_FLAG_SEND is interrupted

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: synchronize the IRQ before disabling clocks on stop

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix WB offset and gain register field masking

Fan Wu <fanwu01@zju.edu.cn>
    media: imx-jpeg: finish the job on device_run() error paths

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: mac80211: queue frames while off-channel

Andre Przywara <andre.przywara@arm.com>
    of/fdt: Ignore disabled memory nodes

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close

Takashi Iwai <tiwai@suse.de>
    ALSA: bcd2000: Fix race between rawmidi and disconnect

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: usx2y: Refuse a retried DSP load after a failure

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mips: Disable Octeon SHA code on little-endian kernels

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: don't drop local events queued during TVLV update

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: only update flags for TT events

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: ignore ROAM flag of received ADD changes

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: send ROAM_ADV on each roamed back client

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: clear ROAM flag when re-adding a pending local client

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: only transmit local ROAM flag together with DEL

Sven Eckelmann <sven@narfation.org>
    batman-adv: stop originator purge worker before freeing TT

Sven Eckelmann <sven@narfation.org>
    batman-adv: tpmeter: fix u32 truncation of reported bytes

Chengfeng Ye <nicoyip.dev@gmail.com>
    batman-adv: Close OGM aggregation before transmission

Sven Eckelmann <sven@narfation.org>
    batman-adv: Limit number of aggregated packets directly

Daehyeon Ko <4ncienth@gmail.com>
    crypto: algif_skcipher - rewind rounded output bytes

Jan Kara <jack@suse.cz>
    udf: Make sure there's enough space for LVID implementation use field

Jan Kara <jack@suse.cz>
    udf: Avoid invalid LVID used on mount

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/svm: drain fault handler before freeing svmm

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Force device table to maximum size

Joanne Chang <joannechien@google.com>
    f2fs: allow pinning empty compressed files

Jiucheng Xu <jiucheng.xu@amlogic.com>
    f2fs: force out-place update for all writes on compressed file

Federico Musto <federico@rimpianto.com>
    net: atl1c: drop oversized RX frames instead of panicking

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: arm64: Don't use the platform register x18

Igor Velkov <iav@iav.lv>
    genirq/kexec: Do not take the bus lock of an interrupt chip on the crash path

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Force UVC version for Avermedia GC515

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add autosuspend quirk for AVerMedia Live Gamer HD 2

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Disable autosuspend for Insta360 Link

Lee Jones <lee@kernel.org>
    tracing/histograms: Verify event_call identity when updating synth_event refcount

Zhao Gongyi <zhaogongyi@bytedance.com>
    ata: libata-scsi: reject data-in commands with a data-out buffer

Oliver Hartkopp <socketcan@hartkopp.net>
    can: raw, isotp: copy socket options outside of lock_sock()

SJ Park <sj@kernel.org>
    mm/damon/core: move static variable last_nr_regions to damon_ctx

Ido Schimmel <idosch@nvidia.com>
    vxlan: Stop rejecting dynamic FDB entries with a nexthop ID

Lee Jones <lee@kernel.org>
    HID: wacom: Fix Use-After-Free in wacom_bamboo_pad

Lee Jones <lee@kernel.org>
    HID: wacom: Fix Use-After-Free in wacom_intuos_pad

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: restore the ABI argument home area below pt_regs (PTO)

Michal Simek <michal.simek@xilinx.com>
    microblaze: Do loop unrolling for optimized memset implementation

Michal Simek <michal.simek@xilinx.com>
    microblaze: Use simple memset implementation from lib/string.c

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Preserve the interrupted context's exception registers

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Run the event handler on the kernel vectors

Guanglei Zhu <zhugl3@xiaopeng.com>
    ceph: clamp the inline data length in ceph_fill_inline_data()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: protect the receive lists with a per-device lock

Oliver Hartkopp <socketcan@hartkopp.net>
    can: replace ARPHRD_CAN type checks with can_get_ml_priv()

Marco Ziliani <rylos78@gmail.com>
    ata: libata-pmp: disable the SEMB port on Marvell 88SM9705

Thorsten Blum <blum@kernel.org>
    x86/boot: Fix off-by-one error in sme_clear_pgd()

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: kexec_file: Fix elf_headers memory leak in retry loop

Breno Leitao <leitao@debian.org>
    x86/nmi: Ignore negative NMI handler durations

Danish Khateeb <danishkhateeb03@gmail.com>
    perf/core: Don't send SIGTRAP after exec removed the event

Shao Mingyin <shao.mingyin@zte.com.cn>
    nvmet: bound the traddr and trsvcid configfs writes

Imre Kaloz <kaloz@kernel.org>
    MIPS: sgi-ip32: Leave MACE PCI control alone in config accesses

Imre Kaloz <kaloz@kernel.org>
    MIPS: sgi-ip32: Mask MACE PCI interrupts in CRIME only

Imre Kaloz <kaloz@kernel.org>
    MIPS: mm: Fix the cache error vector jump for XKPHYS kernels

Matthias Goergens <matthias.goergens@gmail.com>
    udf: don't let the extent type hide an exhausted free-space table extent

Christian Gmeiner <cgmeiner@igalia.com>
    drm/etnaviv: Flush the tile status cache through both the PE and BLT

James Clark <jjc@jclark.com>
    net: ethernet: ti: am65-cpsw-nuss: Enable timestamping of unicast PTP packets

Ray Zhang <sgzhang@google.com>
    net: count last skb of each sk_backlog pass in __release_sock()

Bryam Vargas <hexlabsecurity@proton.me>
    net/smc: don't spin in smc_rx_recvmsg() while a pipe holds spliced data

Sinan Turunc <enscrpt@pm.me>
    ALSA: usx2y: Guard the playback copy

Sinan Turunc <enscrpt@pm.me>
    ALSA: usx2y: Require a buffer of two URBs

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: caiaq: free the EP4 URB when input setup fails

Sinan Turunc <enscrpt@pm.me>
    ALSA: line6: Reject capture buffers smaller than two packets

Alex Kazinsky <a.kazinsky@ideco.ru>
    ALSA: cs46xx: Handle SCB creation failures before dereferencing

Chris Simpson <chris@nilk.net>
    ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts

Zhao Gongyi <zhaogongyi@bytedance.com>
    arm64: mm: validate /dev/mem mmap ranges without overflow

Ewan D. Milne <emilne@redhat.com>
    nvmet: don't return memory contents beyond valid data when reading ANA log page

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: clamp skb->queue_mapping before indexing the tx queue

Xia Yan <yanxia@cmss.chinamobile.com>
    ipv6: fix device binding after failed datagram connect

David Hildenbrand (Arm) <david@kernel.org>
    mm/ksm: reset the unstable trees of all nodes

Josef Bacik <josef@toxicpanda.com>
    mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit

Chris Mason <mason@kernel.org>
    mm/mmu_notifier: set ->mm only after mmgrab()

Josef Bacik <josef@toxicpanda.com>
    mm/mmu_gather: fix flushing ranges with 4 GiB or larger

Chris Mason <mason@kernel.org>
    mm/gup: fix out-of-bounds write for nr_pages == 0 in GUP-fast

Liu Changjie <liucj1228@outlook.com>
    can: peak_usb: pcan_usb_fd_decode_buf(): accept short uCAN end-of-list records

ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
    can: dev: can_fill_info(): don't wake up controller if interface is down

Oliver Hartkopp <socketcan@hartkopp.net>
    can: proc: skip stats calculation after reset in can_stat_update()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    can: proc: reset pkg_stats atomics individually

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: check the return values of can_rx_register() in isotp_bind()

Cunhao Lu <1579567540@qq.com>
    can: dev: can_put_echo_skb(): free skb on invalid echo index

Daejun Park <daejun7.park@samsung.com>
    xfs: clamp the pNFS layout range to the maximum file size

Daejun Park <daejun7.park@samsung.com>
    xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end

Reid Downing <skibletz@gmail.com>
    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

Hungyu Lin <dennylin0707@gmail.com>
    block: Return the soft block size for compat BLKBSZGET

Hungyu Lin <dennylin0707@gmail.com>
    inotify: do not coalesce rename events

Esben Haabendal <esben@geanix.com>
    drm/bridge: nwl-dsi: Limit LCDIF specific sync override

Esben Haabendal <esben@geanix.com>
    drm/bridge: nwl-dsi: Cleanup endpoint mux control selection

Kyle Zeng <kylebot@openai.com>
    net/sched: sch_qfq: prevent aggregate self-replacement

Jianyun Gao <jianyungao89@gmail.com>
    xfs: fix temporary cursor leak in btree shift corruption paths

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: wait for filecheck kobject release after a failed add

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: unlink socket containers before releasing resources

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: stop recovery before shutting down local allocators

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: serialize migration MLE cleanup on failure

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: keep locking_state within the cluster connection lifetime

Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
    fat: hold truncate_lock in fat_write_failed()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not read the entry array of an empty xattr block

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not index before the entry array when dividing an empty bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: find the xattr entry again after converting a block to a bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: find the xattr entry again after defragmenting a bucket

Andrew Morton <akpm@linux-foundation.org>
    openrisc: export __mulsi3 for modules

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry

Sean Christopherson <seanjc@google.com>
    KVM: x86: Conditionally resched when restarting REP string emulation

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (corsair-cpro) Cache fan target only after a successful command

Xia Yan <yana06070@163.com>
    veth: keep carrier off when resizing channels with a down peer

Fang Xieyan <fangxy@xiaopeng.com>
    vringh: reject empty / undersized indirect descriptor tables

Fang Xieyan <fangxy@xiaopeng.com>
    vringh: bound top-level re-entry into indirect tables

Tal Zussman <tz2294@columbia.edu>
    vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/v3d: Initialize timedout_batches when running a CSD job

Josef Bacik <josef@toxicpanda.com>
    mm/memfd: make f_pos accesses atomic

Chris Mason <mason@kernel.org>
    mm/mempolicy: charge shared policy nodes

Ian Bridges <icb@fastmail.org>
    ksmbd: grant a POSIX ACL group entry only to the group's members

Lu Yao <yaolu@kylinos.cn>
    drm/i915/gem: Reset err for each fence entry

Ian Bridges <icb@fastmail.org>
    ksmbd: require DELETE access for delete-on-close opens

Jamal Hadi Salim <jhs@mojatatu.com>
    bpf: Fix skb_pull() BUG in __bpf_redirect_neigh()

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: usx2y: Initialize idle URBs before submitting streams

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: us122l: Fix NULL dereference at hwdep open and release

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()

Shao Mingyin <shao.mingyin@zte.com.cn>
    scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store

Yuanhe Shu <xiangzao@linux.alibaba.com>
    scsi: target: Verify the iSCSI ISID is null-terminated

Yingjie Wang <x-professor@outlook.com>
    scsi: bsg: Report synchronous data copyback failures

guolingxing <guolingxing@tju.edu.cn>
    btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()

Masafumi Suzuki <shengshilingmu97@gmail.com>
    sctp: account for chunk padding in sctp_init_cause()

Lucas Tanure <lucas.tanure@neat.no>
    drm/vc4: hdmi: always cancel the scrambling work synchronously

Franck Baur <franck.baur.67@gmail.com>
    net: jme: keep RX MAC clock enabled for WoL

Sven Eckelmann <sven@narfation.org>
    batman-adv: fix skb leak when hard_iface is being released

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: initialize orig_node of unfilled candidate slots

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: don't decrement a server-owned zero nlink

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    9p/xen: validate the response size from the backend

Imre Kaloz <kaloz@kernel.org>
    scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Publish the output fence outside of job_lock

Zijing Yin <yzjaurora@gmail.com>
    wifi: cfg80211: fix out-of-bounds read in valid_rule()

Alex Kazinsky <a.kazinsky@ideco.ru>
    wifi: rsi: Skip TX aggregation setup for non-QoS frames

Weigang He <geoffreyhe2@gmail.com>
    wifi: mac80211: reload TDLS header pointer after skb_linearize()

André Draszik <andre.draszik@linaro.org>
    drm/drm_crtc: ensure dma_fence_ops remain valid during device unbind

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: espintcp: reorder operations within espintcp_init_sk

Qihang <q.h.hack.winter@gmail.com>
    xfrm: interface: validate the IP header on xmit

Zhao Zhang <zzhan461@ucr.edu>
    9p: fix caches_show() out-of-bounds write

Yifei Gao <gyf161023@gmail.com>
    9p/xen: fix refcount leak in p9_xen_response() on wrong tag

Michael Bommarito <michael.bommarito@gmail.com>
    9p/trans_virtio: reject mount tags longer than NAME_MAX at probe

Noam D. Eliyahu <noam.d.eliyahu@gmail.com>
    tg3: Invert restart quirk logic to restrict SNP power-down bypass

Hungyu Lin <dennylin0707@gmail.com>
    posix-timers: Accept NULL clock_getres() output in stubs

Yingjie Wang <x-professor@outlook.com>
    scsi: handle out-of-range SG_SET_TIMEOUT values

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    gpio: pca953x: Preserve wakeup accounting on parent IRQ failure

Henry Martin <bsdhenrymartin@gmail.com>
    rds: fix out-of-bounds conn_path walks via handshake exthdrs

Richard Patel <ripatel@wii.dev>
    genirq: Move interrupt thread exit_work object to irqaction

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: selftest: Pin module for selftest debugfs file operations

Guangshuo Li <lgs201920130244@gmail.com>
    mfd: ab8500: Fix child device leaks on probe failure

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/pnfs: Free the netid when draining a data-server address list

Chuck Lever <cel@kernel.org>
    NFSD: Resolve the recall-any mask names in the trace format

Kazuki Hanai <hnkz.64@gmail.com>
    media: mediatek: jpeg: Avoid context access after job finish

Rupesh Majhi <zoone.rupert@gmail.com>
    iio: pressure: dps310: fix CFG_REG bit definitions

Ruoyu Wang <ruoyuw560@gmail.com>
    media: adv748x: Fix endpoint reference leaks on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: require two-byte Cypress type 04 records

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't try to submit URBs after disconnection

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    pwm: tiehrpwm: Clear period on disable to allow reconfiguration

Weibin Liu <liuwb@xiaopeng.com>
    spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op

Daejun Park <daejun7.park@samsung.com>
    jbd2: don't advance j_fc_off before the buffer is recorded

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/vmcp: Initialize full session info to zero

Pufan Jin <cyan2254650260@gmail.com>
    spi: zynq-qspi: fix address buffer corruption and support 4-byte address

Rosen Penev <rosenp@gmail.com>
    net: bgmac: enable interrupts only after NAPI is ready

Rosen Penev <rosenp@gmail.com>
    mtd: rawnand: ndfc: use devm_platform_ioremap_resource()

Rosen Penev <rosenp@gmail.com>
    mtd: rawnand: ndfc: fix gcc uninitialized var

Arnd Bergmann <arnd@arndb.de>
    mtd: rawnand: ndfc: add CONFIG_OF dependency

Rosen Penev <rosenp@gmail.com>
    mtd: rawnand: ndfc: use ioread32be/iowrite32be and allow COMPILE_TEST

Darrick J. Wong <djwong@kernel.org>
    xfs: always report scrub errors in tracepoints

Eric Biggers <ebiggers@kernel.org>
    raid6: add missing vzeroupper to AVX2 code

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: bound da-node entry count against the correct geometry

Darrick J. Wong <djwong@kernel.org>
    xfs: reject absurdly large xattr value lengths in xchk_xattr_actor

Darrick J. Wong <djwong@kernel.org>
    xfs: rescan the AGs if incore delalloc counter is negative

Darrick J. Wong <djwong@kernel.org>
    xfs: allow softlimit with no hardlimit in quota scrub

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: delete session hash entries by pointer match

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    debugobjects: Use LD_WAIT_CONFIG instead of LD_WAIT_SLEEP

Peter Zijlstra <peterz@infradead.org>
    debugobjects,locking: Annotate debug_object_fill_pool() wait type violation

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Propagate errors from cross-CPU FFH calls

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Validate FFH register fields before hardware access

Eric Biggers <ebiggers@kernel.org>
    raid6: add missing vzeroupper to AVX-512 code

Eric Biggers <ebiggers@kernel.org>
    xor: add missing vzeroupper to AVX code

Eric Biggers <ebiggers@kernel.org>
    fsverity: Explicitly require FMODE_READ to retrieve hashes

Til Kaiser <mail@tk154.de>
    mlxsw: Initialize register query payloads

Jiale Yao <yaojiale02@163.com>
    HID: prodikeys: validate fixed-format MIDI reports

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    HID: hid-prodikeys: remove struct pk_device

Sean Christopherson <seanjc@google.com>
    KVM: x86: Preserve DR6.BLD (Bus Lock Detect) when delivering #DB payload

Keqiang Duan <duankeqiangcym@gmail.com>
    KVM: x86: Clear hardware HLT state when userspace makes a vCPU not-halted

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0

David Howells <dhowells@redhat.com>
    afs: Fix afs to abort the rxrpc call on send error

Chuck Lever <cel@kernel.org>
    NFSD: Map flex file layout IDs through the request's user namespace

Chuck Lever <cel@kernel.org>
    NFSD: Complete a cld upcall when copying its reply fails

Chuck Lever <cel@kernel.org>
    NFSD: Complete a cld upcall when the daemon closes the pipe

Chuck Lever <cel@kernel.org>
    NFSD: Move the cld upcall message out of the caller's stack frame

Jeff Layton <jlayton@kernel.org>
    nfsd: don't offer flexfiles layouts when NFSv3 isn't being served

Benjamin Coddington <bcodding@hammerspace.com>
    NFSv4/flexfiles: fail I/O to the data server once a lock is lost

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: bound POSIX lock data area by response length

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating

Darrick J. Wong <djwong@kernel.org>
    xfs: improve dirent bounds checking in scrub and repair

Darrick J. Wong <djwong@kernel.org>
    xfs: check for buffer overruns when examining local/remote xattr entries

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: validate SMB1 EA list bounds before parsing

Dominik Maier <dmnk@google.com>
    smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()

Luxiao Xu <rakukuip@gmail.com>
    smb: client: fix buffer overflow in SMB2_tcon()

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: fix fiemap wild read on empty truncated response

VeroFess <coderzeng@hotmail.com>
    smb: server: size directory name conversion buffer correctly

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: bound inode fork length against the fork size during log recovery

Chris Mason <mason@kernel.org>
    ovl: check that the parents of volatile/dirty are dirs

Chris Mason <mason@kernel.org>
    ovl: do not copy up a dentry that was removed

Chris Mason <mason@kernel.org>
    ovl: hold a reference on the parent in readdir

Chris Mason <mason@kernel.org>
    ovl: do not copy up an xattr value that was never read

Christian Brauner <brauner@kernel.org>
    ovl: use ovl_path_getxattr() wrapper

Christian Brauner <brauner@kernel.org>
    ovl: pass ofs to setattr operations

Christian Brauner <brauner@kernel.org>
    ovl: add ovl_upper_mnt_userns() wrapper

Chris Mason <mason@kernel.org>
    ovl: take a snapshot of the name for copy up

Eduard Zateev <hackerowskiy@gmail.com>
    smb: client: hold server info until cifsd exits

Kamil Sawicki <user148783812897@gmail.com>
    net: limit priority VLAN untag depth

Andrew Stellman <astellman@stellman-greene.com>
    nvmet-rdma: fix out-of-bounds write in nvmet_rdma_map_sgl_inline()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: x86: hdmi: fix chmap array missing terminator entry

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    SUNRPC: fix oversized GSS proxy token copy

David Howells <dhowells@redhat.com>
    rxrpc: Fix update of call->tx_pending without holding lock

Chuck Lever <cel@kernel.org>
    NFSD: Set nn->cld_net before registering the cld pipe

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: validate the data area in SMB2_read()

Tristan Madani <tristan@talencesecurity.com>
    ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment

Jason Perlow <jperlow@gmail.com>
    wifi: brcmfmac: map msgbuf RX packet IDs bidirectional

Avi Weiss <thnkslprpt@gmail.com>
    init/bootconfig: pass init arguments in documented order

Hungyu Lin <dennylin0707@gmail.com>
    fs: skip copy_file_range write limits when there is no data

Kyle Zeng <kylebot@openai.com>
    tcp: fix reordering addition overflow in MTU probing

Zhiling Zou <zhilinz@nebusec.ai>
    tcp: check congestion control restriction first

Kunhai Dai <daikunhai@didiglobal.com>
    blk-iocost: abort weight transfer on invalid donation weights

Josef Bacik <josef@toxicpanda.com>
    mount: refuse setns() with a shared fs_struct again

Eric Biggers <ebiggers@kernel.org>
    fsverity: Be more careful with return value of ->get_verity_descriptor()

Fang Xieyan <fangxy@xiaopeng.com>
    kgdb: Fix buffer overflow in the qRcmd packet handler

Fang Xieyan <fangxy@xiaopeng.com>
    kgdb: Fix buffer overflow in the 'M' and 'X' packet handlers

Fang Xieyan <fangxy@xiaopeng.com>
    kgdb: Fix buffer overflow in the 'm' packet handler

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: Finish the blk plug when integrity allocation fails

Guixin Liu <kanie@linux.alibaba.com>
    nvmet-fc: Tear down the association when the admin queue allocation fails

Andrea Parri <parri.andrea@gmail.com>
    nvmet-fc: only send read data for successful commands

Weiming Shi <bestswngs@gmail.com>
    nvmet-rdma: reject short connection requests

Tristan Madani <tristan@talencesecurity.com>
    ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Keep runtime PM state in sync across codec remove/probe

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs3: fix mapping pairs bounds check for alignment

Hyeontae Lee <wonju345@naver.com>
    fs/ntfs3: bound DeleteAttribute asize against rec->used in do_action

Hyeontae Lee <wonju345@naver.com>
    fs/ntfs3: bound CreateAttribute asize against record_size in do_action

David Yang <mmyangfl@gmail.com>
    net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring

Xia Yan <yanxia@cmss.chinamobile.com>
    macvlan: fix passthru promiscuity accounting while down

Jiale Yao <yaojiale02@163.com>
    drm/amdkfd: validate SRAT subtables before parsing

Luigi Lauro <luigi.lauro@gmail.com>
    drm/amd/display: take a runtime PM reference only when a CRTC turns on

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: stats: Fix potential out-of-bounds access in deferred reset

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Balance the runtime PM disable in codec remove

Eric Dumazet <edumazet@kernel.org>
    ixgbe: reserve TX timestamp after skb preparation

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda: Reject codec reset on ASoC (ext_ops) buses

Ido Schimmel <idosch@nvidia.com>
    ipmr: fully initialize the synthetic IP header in ipmr_get_route()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bonding: fix out-of-bounds read of arp_ip_target

Wei Jie Law <law.wei.jie@gt.tech.gov.sg>
    net: usb: pegasus: check rx pkt_len against the received length

Val Packett <val@packett.cool>
    ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch

sung byeongchan <tjdqudcks0424@naver.com>
    ceph: validate encoded xattr name lengths

sung byeongchan <tjdqudcks0424@naver.com>
    ceph: bound name skips in ceph_mdsmap_decode() by the message end

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    ceph: clamp MDS reply result code to the errno range

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    libceph: fix out-of-bounds reads from repeated CRUSH bucket entries

Wentao Liang <vulab@iscas.ac.cn>
    ceph: Fix mds session leak in __open_export_target_session()

Wentao Liang <vulab@iscas.ac.cn>
    ceph: Fix xattr buffer leak in __send_cap()

Felix Hoffmann <f3lix.dev@gmx.de>
    libceph: reject mismatched CRUSH weight-set sizes

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix multiple unsafe decodes in ceph_oloc_decode()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix unsafe decode in ceph_redirect_decode()

Xiubo Li <xiubo.li@clyso.com>
    libceph: only set read_from_replica on read requests

Xiang Mei <xmei5@asu.edu>
    ceph: reject mdsmaps that claim more than CEPH_MAX_MDS ranks

Max Kellermann <max.kellermann@ionos.com>
    ceph: avoid pending truncate during nonblocking cap acquire

Hungyu Lin <dennylin0707@gmail.com>
    time/namespace: Fix overflow when converting absolute deadlines

Hungyu Lin <dennylin0707@gmail.com>
    timers/itimer: Keep a nonzero value at CPU timer expiry

Wang Haoran <haoranwangsec@gmail.com>
    fbdev: atmel_lcdfb: fix list_first_entry() on possibly empty modelist in probe

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: remove zero-address nodes from IP tree on teardown

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: snapshot the dentry name while tracing file release

Hungyu Lin <dennylin0707@gmail.com>
    compat: avoid double rounding in times()

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    scsi: libiscsi_tcp: Prevent R2T range check overflow

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Clear stale UIC result byte before peer DME retries

Sasha Levin <sashal@kernel.org>
    cgroup: don't kill migrated processes through their exiting threads

Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
    timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path

Christian Marangi <ansuelsmth@gmail.com>
    i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len

Jean Delu <jeandelu@tutamail.com>
    parisc: eisa_enumerator: Fix out-of-bounds reads of the EEPROM buffer

Pei Xiao <xiaopei01@kylinos.cn>
    tpm: fix zero-length read discarding the pending response

Pei Xiao <xiaopei01@kylinos.cn>
    tpm: tpm_nsc: stop using the cleanup callback as dev.release

Pei Xiao <xiaopei01@kylinos.cn>
    tpm: tpm_nsc: fix NULL pointer dereference on init failure

Navon John Lukose <navonjohnlukose@gmail.com>
    i2c: designware: queue only one read command for block reads

Henry Martin <bsdhenrymartin@gmail.com>
    tipc: fix broadcast sender hang on last acker departure

Liu Chao <liuc63@xiaopeng.com>
    net: wwan: iosm: validate msg_head before indexing msg_ring

Runyu Xiao <runyu.xiao@seu.edu.cn>
    sh: maple: Use the matching IRQ cookie when invoking free_irq()

Julian Sun <sunjunchao@bytedance.com>
    writeback: clear old wb dirty state after inode switches

Julian Sun <sunjunchao@bytedance.com>
    writeback: reset dirtied_when when switching wbs

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reserve value tree metadata when moving an xattr into the inode

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reserve metadata for a new xattr block and its value tree

Matt Turner <mattst88@gmail.com>
    alpha: determine tininess after rounding in the FP emulation

Bryam Vargas <hexlabsecurity@proton.me>
    net/smc: queue the copied chunk when smc_tx_sendmsg() faults

Yingjie Wang <1075151112@qq.com>
    net: unix: reject negative max_dgram_qlen values

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    net/rds: ib: don't enable IRQs in rds_ib_conn_free()

Tingjie Zhong <catme0w@live.cn>
    fbdev: bitblit: Fix glyph clipping when fbcon pans

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: do not restart DAD for a dead ifaddr

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: initialize temporary ifaddr before publication

Keita Morisaki <kmta1236@gmail.com>
    drm/amd/display: Fix swap in median3() for DSC rate control

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: reject ANONONLY userptrs that span multiple VMAs

Maciej Kucharek <qchcio@gmail.com>
    drm/amdgpu: reset VI ASIC on Apple boards with VRAM at 0

Maciej Kucharek <qchcio@gmail.com>
    drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0

Luigi Lauro <luigi.lauro@gmail.com>
    drm/amdgpu: require _PR3 for BOCO

Nirmoy Das <nirmoyd@nvidia.com>
    blk-mq: clear stale inactive flag on hctx reuse

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: compress: add missing OPEN-state gate to SET_METADATA

Jamal Hadi Salim <jhs@mojatatu.com>
    netdevsim: reject cls_bpf programs bound to another device

Kir Kolyshkin <kolyshkin@gmail.com>
    cgroup: fix cgroup.kill for exited thread group leader

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (sht3x) Return the consumed count for heater writes

Gregory Price <gourry@gourry.net>
    rtc: cmos: Disable ACPI RTC event before handling it

Seongjae Jeong <jsjlee1020@gmail.com>
    f2fs: fix submit accounting for IPU writeback

Wenjie Qi <qwjhust@gmail.com>
    f2fs: flush SIT journal during filesystem resize

Sanan Hasanov <sanan.hasanov@ucf.edu>
    hwmon: (corsair-cpro) Make wait_input_report_lock IRQ safe

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/via: Apply runtime PM workaround for ASUS X55A

Magnus Lindholm <linmag7@gmail.com>
    alpha: invalidate the local context in flush_icache_user_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: invalidate the local context in flush_tlb_mm()

Magnus Lindholm <linmag7@gmail.com>
    alpha: fix the local TLB invalidate in the UP flush_tlb_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: fix the local TLB invalidate in flush_tlb_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: invalidate the local context in flush_tlb_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: only use a targeted tbi() when the target mm is really current

Magnus Lindholm <linmag7@gmail.com>
    alpha: run check_mmu_context() from finish_arch_post_lock_switch()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Skip events until fully initialized

Shubham Antil <shubham@octane.security>
    RDS/IB: validate receive fragment completions

Seung Min Shin <guncraft2000@naver.com>
    sctp: hold transport reference across connect wait

Zixuan Chai <petalzu987@gmail.com>
    ipv6: defrag: orphan skb before queuing

Jianyun Gao <jianyungao89@gmail.com>
    dax: Return errors from dax_core_init()

Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
    mfd: tps65217: Check return value when masking interrupt sources

Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
    mfd: tps65217: Fix NULL pointer dereference on IRQ init failure

Weibin Liu <liuwb@xiaopeng.com>
    spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: Don't replace an existing LINUX_EFI_MEMRESERVE table

Weibin Liu <liuwb@xiaopeng.com>
    spi: jcore: fix divide-by-zero when speed_hz is zero

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Don't clamp nvecs to zero when id_bits is 32

Hui Su <sh_def@163.com>
    cpufreq: schedutil: Serialize sugov_start() against rate limit updates

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Use default TxWindow for zero socket option

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject invalid TxWindow in configuration requests

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject mode changes on connected channels

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9491/1: alignment: restore uaccess state on emulation fault

Tim Douglas <me@timdoug.com>
    serial: pmac_zilog: push received data to the port that received it

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()

Denis Arefev <arefev@swemel.ru>
    ALSA: cs46xx: fix unit mismatch in DSP code area bounds check

Aamir Ahmed <elb12345@hotmail.co.uk>
    lib: decompress_bunzip2: fix integer overflow in run-length decoding

Matt Turner <mattst88@gmail.com>
    lib/decompress_bunzip2: fix off-by-one in run-length bounds check

Kaixuan Li <kaixuanli0131@gmail.com>
    f2fs: check every cur_*_segno[] entry on readonly images

Karl Mehltretter <kmehltretter@gmail.com>
    sh: intc: Sort the prio and sense lists after filling them

Andrea Parri <parri.andrea@gmail.com>
    nvmet: zns: don't leak stale memory in zone management receive

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nvmet: free the bvec on file namespace range errors

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-rdma: don't complete a request after a bogus remote invalidation

Andrea Parri <parri.andrea@gmail.com>
    iomap: don't lose a fiemap iteration error when emitting the last extent

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Fix NULL pointer dereference on VT switch + selection

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: smscufx: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: udlfb: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: xen-fbfront: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: ssd1307fb: check for fb_deferred_io_init() error

Yuanhe Shu <xiangzao@linux.alibaba.com>
    mm/page_alloc: do not boost watermarks in kdump capture kernels

Yongjian Mu <ymu@everpuredata.com>
    xprtrdma: trim head iovec when the payload arrives via a Write chunk

Tim Menninger <tmenninger@everpuredata.com>
    xprtrdma: prevent disconnect feedback during endpoint teardown

Weigang He <geoffreyhe2@gmail.com>
    mtd: parsers: qcom: fix offset/size overflow on large partitions

Wentao Liang <vulab@iscas.ac.cn>
    btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()

Ard Biesheuvel <ardb@kernel.org>
    arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO

Mikulas Patocka <mpatocka@redhat.com>
    dm-snapshot: fix crash if dm_io_client_create fails

Johan Hovold <johan@kernel.org>
    USB: serial: sierra: fix urb leak on write completion

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()

Wayne Chang <waynec@nvidia.com>
    usb: typec: ucsi_ccg: Add retry mechanism in ccg_read

Drobyshev Vladimir <enigma_137@icloud.com>
    USB: cdc-acm: add VeriFone VX820 device ID

Zongmin Zhou <zhouzongmin@kylinos.cn>
    slimbus: messaging: fix leaked PM vote on tid allocation failure

Johan Hovold <johan@kernel.org>
    USB: serial: usb_wwan: fix urb leak on disconnect

Michael Wyraz <michael@wyraz.de>
    USB: serial: option: add support for ASR 1286:4e3c modem

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Rolling Wireless RN947R

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix urb leak on disconnect

Myeonghun Pak <mhun512@gmail.com>
    soc: fsl: dpio: Fix cleanup on IRQ registration failure

Wentao Liang <vulab@iscas.ac.cn>
    clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()

Wentao Liang <vulab@iscas.ac.cn>
    clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()

Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
    mm/nommu: reject wrapping ranges in access_remote_vm()

Jinjie Ruan <ruanjinjie@huawei.com>
    ext4: fix out-of-bounds read in ext4_get_group_info()

Daejun Park <daejun7.park@samsung.com>
    ext4: don't report delalloc data as a hole on indirect-mapped inodes

Hemanth Selam <hemanth.selam@gmail.com>
    ext4: skip extra isize expansion while unmounting

Matthias Goergens <matthias.goergens@gmail.com>
    fanotify: report names longer than NAME_MAX

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Pass the device name length in UTF-16 code units

Josef Bacik <josef@toxicpanda.com>
    aoe: pull in the headers each received packet type reads

Wentao Liang <vulab@iscas.ac.cn>
    clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure

Wentao Liang <vulab@iscas.ac.cn>
    clocksource/drivers/fttmr010: Fix clk reference leak in error paths

Wentao Liang <vulab@iscas.ac.cn>
    wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: mt7615: cancel reset work during unregister

Eason Lai <eason.lai@mediatek.com>
    wifi: mt76: fix memory leak in USB TX path

Eason Lai <eason.lai@mediatek.com>
    wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory

Mark Anthony Agarro <markanthonyagarro@gmail.com>
    wifi: mt76: mt7615: do not tear down BSS/STA state for monitor vifs

Mark Anthony Agarro <markanthonyagarro@gmail.com>
    wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: free replay slots in ocfs2_recovery_exit()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: exit recovery thread on mount error path

Zi Yan <ziy@nvidia.com>
    USB: gadgetfs: do not WARN about excessively large memory allocations

Michael Liang <mliang@purestorage.com>
    fault-inject: fix dentry leak

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix fat_ent_write() for reverting the value

DAI RENJIE <drj19981414013@gmail.com>
    resource: fix lost wakeup when waiting for a muxed region

Nathan Chancellor <nathan@kernel.org>
    wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz

Denis Efremov (Oracle) <efremov@linux.com>
    floppy: return the drive state flags from the 32-bit FDGETDRVSTAT

Denis Efremov (Oracle) <efremov@linux.com>
    floppy: don't store a stack buffer in timeout_message

Chuck Lever <cel@kernel.org>
    svcrdma: Grant credits from the clamped sc_max_requests

Runyu Xiao <runyu.xiao@seu.edu.cn>
    perf: xgene: initialize lock before requesting IRQ

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_fg: Report sub-percent charge changes

Andrey Albershteyn <aalbersh@kernel.org>
    fsverity: hoist statx reporting of fs-verity flag

Tharit Tangkijwanichakul <tharitt97@gmail.com>
    media: hantro: Harden MPEG-2 control access against NULL

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: fix NULL deref on oversized frame

Guangshuo Li <lgs201920130244@gmail.com>
    media: mediatek: vpu: release reserved memory on remove

Michael Freidkin <freidkin@gmail.com>
    media: meson: vdec: size capture planes from the aligned canvas

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    crypto: nx - validate 'ignore' before subtracting in decompress

Thorsten Blum <blum@kernel.org>
    hwrng: core - reject unknown RNG names

Thorsten Blum <blum@kernel.org>
    hwrng: ba431 - fix reported byte count

Thorsten Blum <blum@kernel.org>
    hwrng: amd - report partial reads in non-blocking mode

ZhaoJinming <zhaojinming@uniontech.com>
    crypto: caam - fix double-free in caam_rsa_set_priv_key_form()

Wei Jie Law <98lawweijie@gmail.com>
    media: uvcvideo: Fix NULL deref on events for uninitialized controls

Imre Kaloz <kaloz@kernel.org>
    PCI: Disable MSI for ULi M1575 EHCI controller

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix uncommitted_blocks underflow

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix a crash if we attempt to use non-dax device

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix a quirk in statistics

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: report I/O error if flush failed

Kaho Jiang <kj2864@nyu.edu>
    media: em28xx: fix double free in em28xx_alloc_urbs

Ginger Li <ginger.jzllee@gmail.com>
    media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler

Guangshuo Li <lgs201920130244@gmail.com>
    media: rtl28xxu: fix SDR platform device leak

Wentao Liang <vulab@iscas.ac.cn>
    media: pvrusb2: Fix USB parent device leak in class_dev_create()

Guangshuo Li <lgs201920130244@gmail.com>
    media: tw686x: fix V4L2 device lifetime on probe failure

Tianchu Chen <flynnnchen@tencent.com>
    staging: rtl8723bs: fix RX buffer OOB write from device-reported length

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix racy TIOCMIWAIT implementation

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable

Runyu Xiao <runyu.xiao@seu.edu.cn>
    m68k: dmasound: Keep the Q40 IRQ handler registered

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: sgio2audio: Only free successfully requested IRQs

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe-17x: Fix write master buffer done being dropped

Ibrahim Hashimov <security@auditcode.ai>
    fs/ntfs3: fix integer overflow in find_log_rec() causing OOB read

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region

Piotr Kubik <piotr@kubik.pl>
    netfilter: ctnetlink: fix inverted IPv6 address match in dump filter

Orgad Shaneh <orgads@gmail.com>
    MIPS: mm: do not write a huge TLB entry when the probe misses

Ma Ke <make_ruc2021@163.com>
    ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()

Richard Weinberger <richard@nod.at>
    mtd: Call get_wunit() on the master partition

Wentao Liang <vulab@iscas.ac.cn>
    mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()

Orgad Shaneh <orgads@gmail.com>
    mtd: cfi_cmdset_0002: cap the write-buffer chunk at 256 bytes on an x8 device

Myeonghun Pak <mhun512@gmail.com>
    mtd: maps: pci: balance PCI enable on cleanup

Wentao Liang <vulab@iscas.ac.cn>
    mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()

Ridham Khurana <khurana.ridham222@gmail.com>
    hwmon: (lm95245) Fix negative temperature conversion

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix coupled regulators reference leak on removal

Guangshuo Li <lgs201920130244@gmail.com>
    ASoC: Intel: atom: Fix platform device leak on probe failure

Jiacheng Xu <stitch@zju.edu.cn>
    kobject: fix out-of-bounds access in kobject_action_type()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()

David Heidelberg <david@ixit.cz>
    mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral

Wentao Liang <vulab@iscas.ac.cn>
    media: vpif_display: Fix i2c adapter reference leak in vpif_probe()

Wentao Liang <vulab@iscas.ac.cn>
    media: au0828: Fix media device leak in au0828_usb_probe()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    media: adv7180: Initialize mutex before ancillary clients

Myeonghun Pak <mhun512@gmail.com>
    media: tw68: balance PCI enable on cleanup

Myeonghun Pak <mhun512@gmail.com>
    media: cx18: Disable PCI device on probe failure

Myeonghun Pak <mhun512@gmail.com>
    media: go7007: unregister the I2C adapter on USB probe failure

Myeonghun Pak <mhun512@gmail.com>
    media: marvell: manage the MMP camera clock provider

Rohinthan P <rokinthanp03@gmail.com>
    media: v4l2-ctrls: do nothing if controls[0] == NULL in cluster functions

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - fix ECDH destination DMA mapping

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - fix pointer dereference before length check

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    crypto: amlogic - Fix IRQ handler return value and fallthrough logic

Yuchao Zhang <ndaugoing@gmail.com>
    md: validate bblog_size when loading v1.x badblocks metadata

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nilfs2: fix checkpoint root lifetime on sysfs errors

Wentao Liang <vulab@iscas.ac.cn>
    drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()

Sean Young <sean@mess.org>
    media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()

Cong Nguyen <congnt264@gmail.com>
    staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error

Runyu Xiao <runyu.xiao@seu.edu.cn>
    PCI: pciehp: Make 'pciehp_poll_mode' parameter read-only

Hui Peng <benquike@gmail.com>
    ata: libata-scsi: abort multi-sector pass-through commands when multi_count is 0

Shehryar Ahmad <shehryar.amd@gmail.com>
    iio: accel: adis16201: fix channel order for buffer mode

Karl Mehltretter <kmehltretter@gmail.com>
    fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix rdev reference leak in regulator_resolve_supply()

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()

Shengming Hu <hu.shengming@zte.com.cn>
    cpufreq: conservative: Restrict deferred downscaling to low load

Martin Wilck <martin.wilck@suse.com>
    md/raid5: validate payload size before calculating payload_len

Cao Guanghui <caoguanghui@kylinos.cn>
    md/raid5: fix NULL pointer dereference in raid5_free_percpu

Cao Guanghui <caoguanghui@kylinos.cn>
    md/raid5: track disks array size to fix extra_page leak on error paths

Guangshuo Li <lgs201920130244@gmail.com>
    iio: accel: mma9553: disable autosuspend on remove

Guangshuo Li <lgs201920130244@gmail.com>
    iio: accel: mma9551: disable autosuspend on remove

Guangshuo Li <lgs201920130244@gmail.com>
    iio: accel: kxcjk-1013: Disable autosuspend on remove

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()

Liu Chao <liuc63@xiaopeng.com>
    usb: fotg210: validate endpoint index in ep0 handlers

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel-tdes - sync output bounce buffer before DMA

Yousef Alhouseen <alhouseenyousef@gmail.com>
    ntfs3: bound index head insertions by buffer capacity

Niklas Cassel <cassel@kernel.org>
    ata: ahci_st: Assert the power down reset in the probe() error path

Niklas Cassel <cassel@kernel.org>
    ata: ahci_st: Do not ignore errors when getting the reset controls

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to handle race between truncate and writeback

Kyle Zeng <kylebot@openai.com>
    affs: validate blocks before freeing them

Bradley Morgan <include@grrlz.net>
    PM: CPU: Restore synchronize_rcu() to cpu_pm_unregister_notifier()

Karl Mehltretter <kmehltretter@gmail.com>
    lib/842: require a complete history block for repeat templates

Karl Mehltretter <kmehltretter@gmail.com>
    lib/842: reject output overflows from index and short data

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel-aes - fix AADLENR for standalone GHASH

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel-tdes - zero-initialize device state

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: zero-initialize stateful decoder heap buffers

Juan Perdomo <jcperdomo100@gmail.com>
    media: cx231xx: preserve I2C transfer length

Maxim Skokov <skokovmaksimevg@gmail.com>
    media: vivid: round the height down to the vertical subsampling factor

Eric Kim <seohyun.kim@outlook.kr>
    sched/fair: Reset NUMA fault locality after scan period update

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr change not caught in certain cases

Runyu Xiao <runyu.xiao@seu.edu.cn>
    dmaengine: altera-msgdma: initialize state before requesting IRQ

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Restore mandatory samsung DP DT properties

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: stv0900: bound DiSEqC reply length to msg[] size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: stv090x: bound DiSEqC reply length to msg[] size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: adv7604: avoid negative array index in log_status when cp_read fails

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: reject ECC maximization on small pages

Xu Rao <raoxu@uniontech.com>
    media: m2m-deinterlace: fix default capture field

Punnay Sharma <punnaysharma805@gmail.com>
    staging: media: av7110: fix corrupted BER reporting in sp8870

Julian Braha <julianbraha@gmail.com>
    media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA

Jeffin Philip <jeffinphilip14@gmail.com>
    media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail

Piyush Patle <piyushpatle228@gmail.com>
    media: vidtv: fix frontend reference leak on unbind

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: make encoder CAPTURE dimensions read-only

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: fix out-of-bounds write on under-rounded coded dimensions

Younho Choi <gdool88@mju.ac.kr>
    media: vim2m: keep transaction buffer count stable while streaming

Runyu Xiao <runyu.xiao@seu.edu.cn>
    media: saa7146: Initialize interrupt lock before requesting IRQ

Shengzhuo Wei <me@cherr.cc>
    media: go7007: bound EZ-USB I2C transfers to the usb_buf size

Linkai Gong <gonglinkai@kylinos.cn>
    media: i2c: tc358743: add missing color-space strings

Ruoyu Wang <ruoyuw560@gmail.com>
    media: au0828: Free URBs when starting DVB streaming fails

Andi Shyti <andi.shyti@kernel.org>
    media: cx231xx: Fix cleanup path on failure

Baolin Liu <liubaolin@kylinos.cn>
    isofs: fix Rock Ridge CE extent validation on multisession media

Thorsten Blum <thorsten.blum@linux.dev>
    thermal: intel: powerclamp: Reject invalid window_size values

Karl Mehltretter <kmehltretter@gmail.com>
    fs_pin: publish pins with RCU list helpers

HyeongJun An <sammiee5311@gmail.com>
    mtd: spi-nor: sfdp: check the length of the xSPI Profile 1.0 table

Serin Yeh <serin.yeh@intel.com>
    media: i2c: ov8856: fix debug message to report actual CSI-2 lane count

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix queue/stack map u32 index overflow

hanzhijian <hanzhijian1991@gmail.com>
    clk: mstar: msc313-mpll: fix off-by-one in clock array allocation

イムティヤズ <reza1234khan1234@gmail.com>
    wifi: rtw88: fix out-of-bounds CAM write when key table is full

Justin Chen <justin.chen@broadcom.com>
    memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT

Justin Chen <justin.chen@broadcom.com>
    memory: brcmstb_dpfe: Fix out-of-bounds access due to DCPU offset

Sam Price <thesamprice@gmail.com>
    microblaze: preserve the MSR carry flags across signals

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: don't clobber r3/r4 restored by rt_sigreturn

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: reserve the ABI argument-home area in the signal frame

HyeongJun An <sammiee5311@gmail.com>
    remoteproc: elf_loader: Bound the section header table

Daehyeon Ko <4ncienth@gmail.com>
    ipc/mqueue: release notification resources during inode eviction

Daehyeon Ko <4ncienth@gmail.com>
    aio: prevent eventfd/epoll recursion on poll

Sean Young <sean@mess.org>
    media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled

Sean Young <sean@mess.org>
    media: meson-ir-tx: Ensure clock is disabled on unbind

Sean Young <sean@mess.org>
    media: redrat3: Ensure all urbs are suspended

Sean Young <sean@mess.org>
    media: redrat3: Ensure we don't read beyond the end of the packet

Sean Young <sean@mess.org>
    media: streamzap: Add missing rc_unregister_device()

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau: reject zero-size notifier object allocation

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: snapshot dentry names in file and setattr traces

Sean Young <sean@mess.org>
    media: rc: Fix ABBA deadlock by making locks more fine grained

Fan Wu <fanwu01@zju.edu.cn>
    scsi: dc395x: sync the waiting_timer before freeing the host

Fan Wu <fanwu01@zju.edu.cn>
    media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: take a reference on the parsed endpoints

Ping Cheng <ping.cheng@wacom.com>
    HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration

Lee Jones <lee@kernel.org>
    HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/cpum_cf: Check session mask before cpu offline

Chris Mason <mason@kernel.org>
    ovl: set OVL_WHITEOUTS before publishing the upper dir

Igor Putko <igorpetindev@gmail.com>
    serial: core: shut down initialized port on removal

Yuchao Zhang <ndaugoing@gmail.com>
    xen-blkfront: unbind irq before tearing down ring and shadow requests

Ruide Cao <caoruide123@gmail.com>
    mptcp: hold MP_JOIN msk ref when cloning reqsk

Tianchu Chen <flynnnchen@tencent.com>
    staging: rtl8723bs: fix protected RX frame validation in decrypt path

Richard Patel <ripatel@wii.dev>
    genirq: Defer kfree(irqaction) until irq_thread_dtor() finishes

Lee Jones <lee@kernel.org>
    HID: wacom: Redesign shared sibling data lifecycle

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB last_entry pointer from unbounded LastNameOffset

Diego Oliva <diego@bynar.io>
    smb: client: fix use-after-free infoleak via the readdir resume name

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix warning in CIFSFindNext()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix warning in CIFSFindFirst()

David Hildenbrand (Arm) <david@kernel.org>
    mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: fix buffer length underflow in RDMA transfers

Hyunwoo Kim <imv4bel@gmail.com>
    inet: reject unhashed sockets during established lookups

Josef Bacik <josef@toxicpanda.com>
    driver core: Limit the messages on a refused uevent

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: fix named stream write and EOF handling

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix invalid pointer dereference when get_inode_acl() fails

Jan Koester <j.koester@act-marketing.de>
    ksmbd: ignore network devices of other namespaces

Ian Bridges <icb@fastmail.org>
    ksmbd: fix session reference leak on compounded SESSION_SETUP

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: return end of file for reads past a named stream's data

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: preserve unreadable named streams on open

Myeonghun Pak <mhun512@gmail.com>
    backlight: lm3630a: Cancel delayed work before destroying workqueue

Xu Wang <vulab@iscas.ac.cn>
    backlight: lm3630a_bl: Remove redundant 'flush_workqueue()' calls

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: avoid restoring only in-memory EOF after allocation change

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix extended session security negotiation for raw NTLMSSP

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected

Dairui Zhang <zhangdairui@gmail.com>
    ksmbd: verify transform SessionId matches the decrypted header

Ian Bridges <icb@fastmail.org>
    ksmbd: fix out-of-bounds read when padding the final compound response

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent share root removal through empty paths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent stale data from being written by SMB2 WRITE requests

Abdifatah Suruur <suruurism@gmail.com>
    ksmbd: reserve space for the UTF-16 terminator in stream info

Giorgi Kobakhia <gkobakhi@asu.edu>
    ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()

Yuhang Zheng <z1652074432@gmail.com>
    net/sched: cls_flower: avoid stale mask references after delete

Johan Hovold <johan@kernel.org>
    driver core: fix parent lock use-after-free on USB disconnect

owen kwan <owen@verialabs.com>
    net/sched: sch_teql: fix use-after-free on lower qdisc drop

Zikang Gao <2715417602@qq.com>
    smb: client: do not pass a NULL buf to is_oplock_break()

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix early procfs exposure race

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate security descriptor offsets before pointer arithmetic

David Woodhouse <dwmw@amazon.co.uk>
    tun: Require CAP_NET_ADMIN to attach to an ownerless device

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: always lower timeout for non-closing RST packets

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype

Jiale Yao <yaojiale02@163.com>
    HID: roccat: savu: reject short special reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: ryos: reject short special reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: pyra: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: kovaplus: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: konepure: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: koneplus: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: isku: reject short button reports

Gabor Tanz <gabor.tanz@gmail.com>
    HID: quirks: Always poll the Anne Pro 2 with product ID a292

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    HID: picoLCD: check for fb_deferred_io_init() error

Jiale Yao <yaojiale02@163.com>
    HID: mcp2221: validate response report length

Jiale Yao <yaojiale02@163.com>
    HID: logitech-dj: validate unnumbered keyboard reports

Jiale Yao <yaojiale02@163.com>
    HID: elo: reject short touchscreen reports

Jiale Yao <yaojiale02@163.com>
    HID: cp2112: validate response report lengths

Jiale Yao <yaojiale02@163.com>
    HID: cougar: reject short special-key reports

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Fix out-of-bounds left shift by 32 in s32ton()

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Use report type from request node

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Remove unsupported motion-state field from accelerometer report

Jiale Yao <yaojiale02@163.com>
    HID: zydacron: validate key report length

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Add preempt_disable() around virtual-mode HPTE bit-lock users

Sean Christopherson <seanjc@google.com>
    KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Trigger new ASID allocation in both VMCBs on pCPU switch

Ameer Hamza <ameer.hamza@truenas.com>
    sunrpc: treat empty auth.unix.gid replies as negative entries

Zhiling Zou <zhilinz@nebusec.ai>
    SUNRPC: trace an accepted transport before publishing it

Chuck Lever <cel@kernel.org>
    SUNRPC: Reject a socket that already has an svc_sock attached

Chris Mason <clm@meta.com>
    sunrpc: pin gss module across auth_domain RCU free

Jeff Layton <jlayton@kernel.org>
    SUNRPC: keep the first error in svc_register()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: zero NFSv4 COMPOUND tag padding

Chuck Lever <cel@kernel.org>
    NFSD: Reject an oversized principal hash from nfsdcld

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: propagate SETXATTR value decode errors

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nfsd: preflight SEQUENCE replies before accepting a slot

NeilBrown <neil@brown.name>
    nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    nfsd: hold cl_lock in client_has_openowners()

Wentao Liang <vulab@iscas.ac.cn>
    nfsd: Fix id-to-name cache entry leak in idtoname_parse()

Chuck Lever <cel@kernel.org>
    NFSD: Fail a pool_threads read whose reply does not fit

Ameer Hamza <ameer.hamza@truenas.com>
    nfsd: don't modify a session slot when replaying its cached reply

Chuck Lever <cel@kernel.org>
    NFSD: Don't complete a cld upcall the daemon has not read

Chuck Lever <cel@kernel.org>
    NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    NFSD: copy SETXATTR data from all XDR buffer segments

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: clear XDR padding in GETXATTR replies

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/filelayout: Anchor page coalescing on pattern_offset

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET

Chuck Lever <cel@kernel.org>
    pnfs/blocklayout: Complete a device upcall when the pipe is closed

Chuck Lever <cel@kernel.org>
    pnfs/blocklayout: Complete a device upcall only on its own reply

Benjamin Coddington <ben.coddington@hammerspace.com>
    pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate

Darrick J. Wong <djwong@kernel.org>
    xfs: propagate errors while checking null siblings

Darrick J. Wong <djwong@kernel.org>
    xfs: opportunistically skip btree block checks

Darrick J. Wong <djwong@kernel.org>
    xfs: only written file data blocks can be shared

Darrick J. Wong <djwong@kernel.org>
    xfs: check for fragments when full-extent sharing matches

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: reject remote xattr entries with an out-of-range value length

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value

Aleksandr Nogikh <nogikh@google.com>
    media: usbtv: fix null-pointer dereference on disconnect

Johan Hovold <johan@kernel.org>
    media: usbtv: drop redundant device reference

Al Viro <viro@zeniv.linux.org.uk>
    ufs: fix ufs_read_cylinder() failure handling

Ido Schimmel <idosch@nvidia.com>
    net/sched: flower: Fix chain template offload

Darrick J. Wong <djwong@kernel.org>
    xfs: jump out of xchk_bmap_check_rmap if fatal signals

Darrick J. Wong <djwong@kernel.org>
    xfs: mark overfull dabtree node blocks as corrupt

Darrick J. Wong <djwong@kernel.org>
    xfs: check fork type against dabtree block magic number

Chris Mason <mason@kernel.org>
    ovl: read the nlink xattr of every indexed non-dir

Chris Mason <mason@kernel.org>
    ovl: fix a torn path in ovl_get_redirect()

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: pin refcount trees before dropping the lookup lock

Jiaming Zhang <r772577952@gmail.com>
    ocfs2: fix chunk number of the first chunk in a local quota file

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: cancel quota sync work before freeing quota info

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2/dlm: hold the lookup reference across convert AST enqueue

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: hold a lock reference across grant AST enqueue

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/heartbeat: unlink live slots when their node is missing

Sean Young <sean@mess.org>
    media: rc: mce_kbd: Fix inconsistent locking of keylock

Weigang He <geoffreyhe2@gmail.com>
    media: rc: fintek-cir: process a full RX buffer instead of overflowing it

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    phy: core: Fix race-condition between _of_phy_get() and try_module_get()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    resource: report a devm_request_resource() conflict under the lock

YANXIN LI <fadouse@pm.me>
    ufs: use u64 for directory size in ufs_last_byte

Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>
    usb: gadget: fix refcount underflow in gadgetfs_bind() error path

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: delete channel-context timers on deinit

Rik van Riel <riel@surriel.com>
    media: redrat3: fix UAF in probe error path leaving rc device registered

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: gspca: use vb2_video_unregister_device() on disconnect

Myeonghun Pak <mhun512@gmail.com>
    media: cx23885: unregister DVB bus when SP2 CI setup fails

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Add SRCU protection for virtual-mode HPT hcalls

Kyle Zeng <kylebot@openai.com>
    io_uring/io-wq: save worker type before dropping its reference

Yousef Alhouseen <alhouseenyousef@gmail.com>
    HID: hiddev: keep state alive through disconnect unlock

Xiang Mei <xmei5@asu.edu>
    fbdev: udlfb: don't rebuild the mode list while the framebuffer is in use

Yibo Tan <lhfff@tju.edu.cn>
    fbdev: atmel_lcdfb: Prevent FIFO work after removal

Karl Mehltretter <kmehltretter@gmail.com>
    klist: avoid accesses after waking klist_remove()

Ping Cheng <ping.cheng@wacom.com>
    HID: wacom: Write shared touch initial status only once

Lee Jones <lee@kernel.org>
    HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities

Heiko Carstens <hca@linux.ibm.com>
    s390/signal: Fix incorrect return address in signal frame

Heiko Carstens <hca@linux.ibm.com>
    s390/probes: Fix wrong opcode for cgrb fixup

Niklas Cassel <cassel@kernel.org>
    ata: sata_fsl: Fix use-after-free of host_priv on probe() failure

Binbin Deng <18983559317@163.com>
    apparmor: fix a use-after-free in aa_lookupn_ns()

Deepanshu Kartikey <kartikey406@gmail.com>
    media: imon: fix use-after-free in display_close via dev_dbg

Anuj Bolewar <bolewara@gmail.com>
    media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path

Pei Xiao <xiaopei01@kylinos.cn>
    media: cx23885: Fix use-after-free in cx23885_finidev due to race condition

Fan Wu <fanwu01@zju.edu.cn>
    media: au0828: fix use-after-free in bulk_timeout timer on disconnect

Chuck Lever <cel@kernel.org>
    lockd: Fix use-after-free in nlmsvc_retry_blocked

Günther Noack <gnoack@google.com>
    landlock: Fix superblock use-after-free in release_inode()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvmet-fc: fix use-after-free in nvmet_fc_ls_create_connection()

James Kim <james010kim@gmail.com>
    rapidio: mport_cdev: fix use-after-free in mport_mm_close()

Zijing Yin <yzjaurora@gmail.com>
    SUNRPC: fix netns use-after-free in write_gssp()

Andreas Wendleder <gonsolo@gmail.com>
    wifi: b43: fix use-after-free in b43_bcma_remove()

Li RongQing <lirongqing@baidu.com>
    x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: accept share config responses from ksmbd-tools before 3.5.3

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Fix potential UAF in reqsk_timer_handler().

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix WLED3 brightness register stride

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix unbalanced OVP IRQ enable at probe

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()

Kameron Carr <kameroncarr@linux.microsoft.com>
    Drivers: hv: vmbus: Bounds check the shared ring buffer indices

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: do not consume the inner header on egress

Antonio Quartulli <antonio@mandelbit.com>
    net/sched: fix packet reordering on requeue

Duoming Zhou <duoming@zju.edu.cn>
    cxgb4: fix use after free bugs caused by circular dependency problem

Shiming Cheng <shiming.cheng@mediatek.com>
    net: gro: fix double aggregation of flush-marked skbs

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Fix UAF in sock clone early bailouts

Yucheng Lu <kanolyc@gmail.com>
    net/sched: sch_netem: fix out-of-bounds access in packet corruption

Qing Luo <luoqing@kylinos.cn>
    sctp: auth: discard auth_chunk when skb_clone fails

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_output()

Eric Dumazet <edumazet@google.com>
    net: dst: introduce dst->dev_rcu

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state

Inseo An <y0un9sa@gmail.com>
    netfilter: nf_tables: fix use-after-free in nf_tables_addchain()

Eric Dumazet <edumazet@google.com>
    ipv4: start using dst_dev_rcu()

Bui Viet Dung <dungvn2345@gmail.com>
    wwan: wwan_hwsim: Pin module for debugfs file operations

Jonathan Gopel <jgopel@gmail.com>
    thunderbolt: Do not RPM complete unrelated subtrees on unplug

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: publish the filecheck owner before adding sysfs attributes

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: pin owning modules for open debugfs files

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: drain quorum work before removing the cluster

Wei Jie Law <law.wei.jie@gt.tech.gov.sg>
    net: usb: pegasus: do not advance rx_skb->data on dropped frames

Kaho Jiang <kj2864@nyu.edu>
    net: ipv4: add zero check for snd_cwnd_clamp

Xiang Mei <xmei5@asu.edu>
    media: go7007: only set audio_enabled if go7007_snd_init() succeeded

Xiang Mei <xmei5@asu.edu>
    media: em28xx: reject audio endpoint with zero packet size

Myeonghun Pak <mhun512@gmail.com>
    media: cx88: Disable PCI device on MPEG initialization failure

Xiang Mei <xmei5@asu.edu>
    libceph: bound mon_command ack decode to front len

Andrea Parri <parri.andrea@gmail.com>
    kcsan: Avoid division by zero in kcsan_prandom_u32_max()

Fang Xieyan <fangxy@xiaopeng.com>
    kcov: ignore an out-of-range comparison count in write_comp_data()

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    ceph: fail readdir when the MDS reply carries no dirfrag

Wentao Guan <guanwentao@uniontech.com>
    wifi: cfg80211: release locks on error in cfg80211_wext_siwgenie()

André Draszik <andre.draszik@linaro.org>
    kbuild: link-vmlinux.sh: improve detection of third pass requirement

Rohinthan P <rokinthanp03@gmail.com>
    media: em28xx: use video_unregister_device for radio_dev

Matus Gajdos <matuszpd@gmail.com>
    ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Fix status polling with octal DTR chips

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Rolling Wireless RN947R

Vladimir Murzin <vladimir.murzin@arm.com>
    usb: mtu3: Fix double dereference in TP_printk

Tarun Noonemunthala <ntarun2000@gmail.com>
    ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1xxx

Luis Banha <luisbanha26@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx

Tomasz Bojanowski <tomasz@bojanowski.me>
    ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI

Hernan Ganzo <gp@sneemgp.com>
    ALSA: hda/realtek: Limit internal mic boost on HP Pavilion 15 (103c:2164)

Jasper Firth <jasper.m.f@hotmail.com>
    ASoC: Intel: bytcr_rt5651: Add quirk for Chuwi Hi8 with generic DMI strings

Rosen Penev <rosenp@gmail.com>
    gpio: mvebu: keep resume masks within the irqchip cache

Dmitry Antipov <dmantipov@yandex.ru>
    HID: roccat: fix locking in roccat_connect() and roccat_disconnect()

Maurizio Lombardi <mlombard@redhat.com>
    nvme-fc: do not warn on controller removal race

Youth Cao <cocoh2os08@gmail.com>
    HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/conexant: Always enable the headset-mic pin on plugin

Xiubo Li <xiubo.li@clyso.com>
    ceph: do not cache negative dentries for snapped directories

Federico Valentín Andrade <fandrade@frba.utn.edu.ar>
    ALSA: usb-audio: Skip mixer creation on M-Audio Venom

Li Jun <lijun01@kylinos.cn>
    tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null

Dave Carey <carvsdriver@gmail.com>
    HID: multitouch: Fix stale MT slots when contact count drops to zero

Helge Deller <deller@gmx.de>
    fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo

Jenson Johnathon Reggentin <mail@jregg.de>
    docs: block: fix dead http link in blk-mq.rst

Chen Changcheng <chenchangcheng@kylinos.cn>
    scsi: snic: Fix SCSI host leak on workqueue allocation failure

Daeho Jeong <daehojeong@google.com>
    f2fs: avoid setting SBI_NEED_FSCK on transient resize failure

Robin Everaars <robineveraars@pm.me>
    ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: enable TCP keepalive for accepted connections

BingKun Yue <yuebingkun@kylinos.cn>
    fbdev: platinumfb: add error checking for ioremap calls

Randy Dunlap <rdunlap@infradead.org>
    fbdev: maxine: fix 64-bit build error

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()

Robert Leussler <robert.leussler@leica-geosystems.com>
    rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode

Jinqian Yang <yangjinqian1@huawei.com>
    virtio_ring: fix infinite loop in virtnet_poll_cleantx when device is broken

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()

Denis V. Lunev <den@openvz.org>
    virtio_balloon: warn on failed buffer add in tell_host()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: codec: max98926: fixup invert setup mask

Alex Elder <elder@riscstar.com>
    net: stmmac: use dma_addr_t for DMA addresses

Thomas Huth <thuth@redhat.com>
    smb: server: Free session data in user_session.c with kfree_sensitive()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: notify parent directory leases on child create

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: honor client signing-required in all modes

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject blocking compound lock requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix SMB2 byte-range lock end offset

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: cancel async requests when closing connection

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow FSCTL_SET_SPARSE without input buffer

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle empty QUERY_ALLOCATED_RANGES output

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: preserve access denied status for copychunk

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: protect private extended attributes

Israel Téllez García <i.tellez@btesa.com>
    libbpf: Fix ring buffer consumer loop on 32-bit position wrap

Yang Wen <anmuxixixi@gmail.com>
    exfat: keep FITRIM within the requested range

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/intel: Add sanity check for BAR0 size

Michail Tatas <michail.tatas@gmail.com>
    ipmi: Fix leak in __ipmi_bmc_register

Jiaming Zhang <r772577952@gmail.com>
    hfsplus: validate extent record length before writing it back

Dmytro Moroziuk <dmorozyk1@gmail.com>
    ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5

Matt Turner <mattst88@gmail.com>
    alpha: run the remote RTC access in a worker, not an IPI callback

Chao Shi <coshi036@gmail.com>
    nvme: ratelimit the completion-path messages driven by device data

Griffin Kroah-Hartman <griffin@kroah.com>
    nfc: nxp-nci: Add remove on IRQ error

Griffin Kroah-Hartman <griffin@kroah.com>
    nfc: mrvl: spi: Unregister dev on allocation fail

Geliang Tang <tanggeliang@kylinos.cn>
    nvme-tcp: look up host_iface in the current netns

Zhe Liu <liuzhe1@kylinos.cn>
    docs: cgroup-v2: fix stale "io" controller introduction

Brian Grech <bgrech@redhat.com>
    selftests/net: fin_ack_lat: fix latency threshold typo

Michal Pecio <michal.pecio@gmail.com>
    ALSA: usx2y: Stop clearing urb->hcpriv before submission

Pengpeng Hou <pengpeng@iscas.ac.cn>
    fbdev: udlfb: validate vendor descriptor items

Andreas Kemnade <andreas@kemnade.info>
    fbdev: omap2: dsi: do not copy isr table

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: error out on failed PHY_IAC command writes

Li Qiang <liqiang01@kylinos.cn>
    Bluetooth: hci_bcsp: validate received packet lengths

Chen Changcheng <chenchangcheng@kylinos.cn>
    Bluetooth: btrsi: Move set_bt_context after successful HCI registration

Junhao He <hejunhao3@h-partners.com>
    ACPI: APEI: Handle repeated SEA error storms

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd: Add DCN6 register headers

Filipe Manana <fdmanana@suse.com>
    btrfs: fix memory barrier order in reloc_root_is_dead()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Bluetooth: hci_nokia: validate firmware packet bounds

Pavel Zverev <playximik29@gmail.com>
    Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device

Rui Qi <qirui.001@bytedance.com>
    selftests/ftrace: Force C locale in ftracetest

Yunye Zhao <yunye.zhao@linux.alibaba.com>
    md: add cond_resched() to md_do_sync()'s skip path

Yu Kuai <yukuai@fygo.io>
    md/raid5: reject zero-sector reshape chunks

Junzhe Yu <junzheyu1@gmail.com>
    ext4: guard against NULL s_group_info in ext4_get_group_info

Pengpeng Hou <pengpeng@iscas.ac.cn>
    HID: rmi: check report length before trimming sentinel bytes

liulhong617 <liulhong617@gmail.com>
    arm64: mm: fix accidental linear mapping of no-map reserved memory

Carl Quist <equalizerjr@gmail.com>
    ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx

Jinhui Guo <guojinhui.liam@bytedance.com>
    net: usb: cdc_ether: add quirk for AMI BMC stale link events

Johan Alvarado <contact@c127.dev>
    net: stmmac: raise TX completion interrupt at the end of an xmit burst

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Snapshot intrc before freeing the request block

Simon Glass <sjg@chromium.org>
    kconfig: abort rather than loop for ever on EOF

Allison Henderson <achender@kernel.org>
    net/rds: unpin MR pages with unpin_user_pages_dirty_lock()

Sharath Srinivasan <sharath.srinivasan@oracle.com>
    net/rds: fix rds_message leak in the rds_send_xmit() drop path

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: hold the socket while an rds_mr references it

Allison Henderson <achender@kernel.org>
    net/rds: don't use unpin_user_pages_dirty_lock() from atomic context

Wahid Khan <wahidzk0091@gmail.com>
    HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware

Aaron Ma <mapengyu@gmail.com>
    HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle

Can Peng <pengcan@kylinos.cn>
    wifi: brcmfmac: validate msgbuf flowring IDs before use

Can Peng <pengcan@kylinos.cn>
    wifi: brcmfmac: Set DMA direction for msgbuf packet IDs

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: fix U-APSD service period termination

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: set the EOSP bit in the QoS header of the last released frame

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: call skb_valid_dst() before skb_dst()

Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
    netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets

Ahmed Naseef <naseefkm@gmail.com>
    wifi: mt76: mt7603: add 0x7592 EEPROM chip ID

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt76x02: report rx FCS errors to mac80211

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7603: free beacon SKB on error

Hari Mishal <harimishal1@gmail.com>
    virtio_console: take a kref in find_port_by_vq() to fix port UAF

이상호 <kudo3228@gmail.com>
    romfs: detect hard link cycles

bui duc phuc <phucduc.bui@gmail.com>
    regulator: rt6245: Restore state on enable failure

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/realtek: add missing error checks for COEF index reads in alc269

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix memory leak in indx_find_sort()

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/realtek: add missing NULL check for codec->bus->pci

Yichong Chen <chenyichong@uniontech.com>
    exfat: free new directory cluster if zeroing fails

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/conexant: Add NULL check for dc_mode_path

Gary Guo <gary@garyguo.net>
    ata: ata_generic: Don't store pci_device_id

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: support 48MHz clock for pll_p_out1

Chen Changcheng <chenchangcheng@kylinos.cn>
    media: cx88: fix memory leak in cx8802_register_driver() error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()

Jay Vadayath <jay@artiphishell.com>
    udf: bound lengthAllocDescs from unallocated space entry

Jan Kara <jack@suse.cz>
    udf: Fix bh leak for unallocated space entries

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: free ibmvfc_target allocations with mempool_free

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path

Jiaxing Hu <gahing@gahingwoo.com>
    iommu/rockchip: Clear stale page faults before enabling stall

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hsi: omap_ssi: remove debugfs on port creation failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    firmware: imx: scu: manage mailbox channels and global handle

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records

Senjin <senjin@hatchling.org>
    fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    ntfs3: fix info-leak in ntfs_rename()

Kyle Zeng <kylebot@openai.com>
    fs/ntfs3: reserve NUL byte when converting UTF-16 names

Brian Norris <briannorris@chromium.org>
    PCI/portdrv: Allow probing even without child services

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()

Benjamin Marzinski <bmarzins@redhat.com>
    bitops: make the *_bit_le functions use unsigned long

Zhang Yi <yi.zhang@huawei.com>
    ext4: check return value of ext4_get_block() in ext4_load_tail_bh()

Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
    wifi: ath10k: trigger hardware recovery upon rx failures

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: ath11k: validate regulatory capability phy_id

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Publish pgtbl_ops before releasing init_mutex

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Check pm_runtime_resume_and_get() return in probe

Heiko Schocher <hs@nabladev.com>
    drm/panel: simple: Add Kyocera tcg070wvlq panel

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: cfg80211: include cf1 offset when sending chandef

Kuan-Wei Chiu <visitorckw@gmail.com>
    riscv, bpf: Add support for BPF_MOVSX in RV32 JIT

Pengpeng Hou <pengpeng@iscas.ac.cn>
    power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    power: supply: cros_pchg: unregister EC notifier

Kuan-Wei Chiu <visitorckw@gmail.com>
    riscv, bpf: Add support for BPF_SDIV and BPF_SMOD in RV32 JIT

Shahar Tzarfati <shahar.tzarfati@intel.com>
    wifi: mac80211: ibss: read deauth reason_code after frame length check

Yun Zhou <yun.zhou@windriver.com>
    ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode

Ali Alaei <ali.alaei.tabatabaei@gmail.com>
    PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX

Baokun Li <libaokun@linux.alibaba.com>
    ext4: reduce max cluster size to match documented 256MB limit

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ACPI: FPDT: validate table and record lengths

Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
    platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3

Yousef Alhouseen <alhouseenyousef@gmail.com>
    media: go7007: s2250: propagate control I/O failures

Rituparna Warwatkar <rwarwatkar@gmail.com>
    media: dvb-core: fix feed leak on failed DMX_ADD_PID

Yuho Choi <dbgh9129@gmail.com>
    driver core: attribute_container: Unwind device_add() on attr failure

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: ibmvmc: reject oversized inbound messages

Pengpeng Hou <pengpeng@iscas.ac.cn>
    greybus: manifest: validate string descriptor header

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: hpilo: validate device queue entries before use

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: genwqe: handle a first DMA address of zero

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: bcm-vk: validate write size before allocation

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcmuio: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm816: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcmmio: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: aio_iiro_16: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm711: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: dt2811: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: das6402: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: quatech_daqp_cs: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm818: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_at_a2150: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_atmio16d: Add sanity check to interrupt handler

Pengpeng Hou <pengpeng@iscas.ac.cn>
    uio: sercos3: add missing MODULE_DEVICE_TABLE()

Michail Tatas <michail.tatas@gmail.com>
    USB: misc: uss720: Fix leak in get_1284_register

Oliver Neukum <oneukum@suse.com>
    usb: misc: cypress_cy7c63: check result of IO

Lucas Martins Alves <lucas.alves@lumal21.com.br>
    usb: musb: host: clear stale RX interrupt on three-strikes error

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec/core: drop cec_post_state_event call

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec: tegra_cec: don't break off msg on NACK

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    scsi: qla2xxx: Handle INTx not connected while passing through

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Wait for timeout worker completion on channel free

Namhyung Kim <namhyung@kernel.org>
    tools/lib/api: Fix potential double-free from fdarray__grow()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: core: cancel crash_handler work in rproc_add() error path

Yousef Alhouseen <alhouseenyousef@gmail.com>
    media: go7007: avoid undefined shifts in MPEG-4 headers

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cx18: stop VBI start-code scan before short tail

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: ivtv: stop VBI start-code scan before short tail

Jurison Murati <eng.juri@gmail.com>
    media: i2c: ov8865: Program the sensor on stream start

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: check all modules for idle after reset

Jurison Murati <eng.juri@gmail.com>
    media: i2c: ov8865: Drop the runtime PM usage count on stream failure

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    iwlwifi: dvm: add missing cleaup for on error path

Hari Mishal <harimishal1@gmail.com>
    nvme: bound ns descriptor header and body to identify buffer

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: dmi-quirks: add a global ghost list

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: use vb2_video_unregister_device

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: requeue buffers if start_streaming fails

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: dev_info->pr_info since dev has been freed

Pengpeng Hou <pengpeng@iscas.ac.cn>
    pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: inode: fix mm lifetime handling

David Laight <david.laight.linux@gmail.com>
    usb_string_copy: Use kzalloc() to avoid leaking old data

Haoxiang Li <haoxiang_li2024@163.com>
    usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()

Haoxiang Li <haoxiang_li2024@163.com>
    tty: serial: pch_uart: add check for pci_get_slot()

Xu Rao <raoxu@uniontech.com>
    mmc: block: reject invalid perdev_minors before division

Arnd Bergmann <arnd@arndb.de>
    media: v4l2-tpg: reduce stack usage for kasan builds

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cec: tegra: add missing MODULE_DEVICE_TABLE()

Pranjal Shrivastava <praan@google.com>
    PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs

Devansh Soni <devanshsoni874@gmail.com>
    staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure

Xixin Liu <liuxixin@kylinos.cn>
    nvme: zns: cap zone report nr_zones by DMA buffer size

Jerome Brunet <jbrunet@baylibre.com>
    clk: sunxi-ng: fix ccu probe clock unregister on error

Marek Szyprowski <m.szyprowski@samsung.com>
    mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state

Ben Dooks <ben.dooks@codethink.co.uk>
    mmc: cqhci: fix to missed endian conversions

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: adc: max1241: add missing MODULE_DEVICE_TABLE()

Yun Zhou <yun.zhou@windriver.com>
    block: reject block device inodes with i_rdev == 0 in lookup_bdev()

William Hansen-Baird <william.hansen.baird@gmail.com>
    wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding

William Hansen-Baird <william.hansen.baird@gmail.com>
    wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()

Ben Dooks <ben.dooks@codethink.co.uk>
    dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID

Yun Zhou <yun.zhou@windriver.com>
    net: mvneta_bm: add suspend/resume support to prevent crash after resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    dmaengine: pl330: remove debugfs file on teardown

Jiayuan Chen <jiayuan.chen@linux.dev>
    netfilter: ebtables: bound num_counters like nentries in do_replace()

Yousef Alhouseen <alhouseenyousef@gmail.com>
    net: usb: rtl8150: handle link status read failures

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate legacy hwmgr PP table offsets

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Tonga PPTable subtable bounds

Xiang Liu <xiang.liu@amd.com>
    drm/amd/pm: Guard VBIOS AC timing table walk

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Tonga PowerPlay state array bounds

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds

Matthew Jacob <mjacob@feralsw.com>
    drm/amdgpu: Support some Barco AMD based graphics adapters

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: validate vega10 profile mode inputs

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Validate ATIF buffer length before use

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add checks to vbios fetch through ATRM

Abhijeeth Babu <babu.jeeth@gmail.com>
    i2c: acpi: Force ELAN1300 touchpads to 100 kHz

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure

Zizhi Wo <wozizhi@huawei.com>
    fat: reject name longer than NAME_MAX in msdos_format_name()

Bryam Vargas <hexlabsecurity@proton.me>
    iio: accel: fxls8962af: clamp the device-reported FIFO sample count

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: hdac_hdmi: Fix resource cleanup on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: tlv320aic26: remove keyclick sysfs file

William Theesfeld <william@theesfeld.net>
    clk: zynq: handle kasprintf() failure in periph_clk registration

Kemeng Shi <shikemeng@huaweicloud.com>
    irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cec: stm32: return an error when log-address wait times out

Kryštof Černý <cleverline1mc@gmail.com>
    w1: ds2482: add OF device match table

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/radeon: avoid double free in r600 DPM cleanup

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: Gate debugfs MMIO access on kernel lockdown

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: Validate OD DPM triples before mutating tables

Jonas Karlman <jonas@kwiboo.se>
    drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma-pcie: Reject devices without driver data

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Limit BO list entry count to prevent resource exhaustion

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: Fix off-by-one in check_imm signed range check

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring

Benjamin Cheng <benjamin.cheng@amd.com>
    drm/amdgpu/vce: Prevent partial address patches

Zihan Xi <zihanx@nebusec.ai>
    net: gso: limit recursive IP-in-IP segmentation

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: line6: Clear prev_fbuf on capture buffer release

Linus Torvalds <torvalds@linux-foundation.org>
    mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state

Juanlu Herrero <juanlu@fastmail.com>
    io_uring/poll: avoid retry wakeup loss when dropping ownership

Weiming Shi <bestswngs@gmail.com>
    asymmetric_keys: reject trust keys without IDs

Christian Brauner <brauner@kernel.org>
    coredump: hold RCU while releasing parked threads

Hyunwoo Kim <imv4bel@gmail.com>
    exec: Cleanup POSIX timers right after de_thread()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: split critical region in remap_file_pages() and invoke LSMs in between

Shu Han <ebpqwerty472123@gmail.com>
    mm: call the security_mmap_file() LSM hook in remap_file_pages()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: wait for negotiation before receiving another PDU

Zizhen Liu <pointerliu@126.com>
    net: skbuff: propagate shared-frag marker in skb_zerocopy()

Tu Dinh <ngoc-tu.dinh@vates.tech>
    xen-netback: Zero out sring pointers on unmap

Tu Dinh <ngoc-tu.dinh@vates.tech>
    xen-netback: Fix XenBus connection failure cleanup


-------------

Diffstat:

 .gitignore                                         |     1 -
 Documentation/ABI/testing/sysfs-bus-pci            |    14 +-
 Documentation/ABI/testing/sysfs-class-power-mp2629 |     2 +-
 Documentation/PCI/pci-error-recovery.rst           |     7 +
 Documentation/admin-guide/LSM/LoadPin.rst          |    10 +-
 Documentation/admin-guide/cgroup-v2.rst            |    10 +-
 Documentation/block/blk-mq.rst                     |     2 +-
 .../media/allwinner,sun4i-a10-video-engine.yaml    |    21 +-
 .../power/supply/stericsson,ab8500-charger.yaml    |    76 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |    52 +
 Documentation/filesystems/fsverity.rst             |     3 +
 Documentation/filesystems/overlayfs.rst            |     3 +-
 Documentation/networking/ip-sysctl.rst             |     3 +-
 Documentation/process/howto.rst                    |     2 +-
 Documentation/process/programming-language.rst     |     6 +-
 Documentation/trace/histogram.rst                  |   245 +-
 Documentation/translations/it_IT/process/howto.rst |     2 +-
 .../it_IT/process/programming-language.rst         |     4 +-
 Documentation/translations/ja_JP/howto.rst         |     2 +-
 Documentation/translations/ko_KR/howto.rst         |     2 +-
 Documentation/translations/zh_CN/process/howto.rst |     2 +-
 .../zh_CN/process/programming-language.rst         |     3 +-
 Documentation/translations/zh_TW/process/howto.rst |     2 +-
 .../zh_TW/process/programming-language.rst         |     3 +-
 MAINTAINERS                                        |     1 +
 Makefile                                           |    11 +-
 arch/alpha/include/asm/mmu_context.h               |    15 +-
 arch/alpha/include/asm/sfp-machine.h               |     4 +
 arch/alpha/include/asm/switch_to.h                 |     1 -
 arch/alpha/include/asm/tlbflush.h                  |     3 +-
 arch/alpha/kernel/rtc.c                            |    37 +-
 arch/alpha/kernel/smp.c                            |    15 +-
 arch/arc/Makefile                                  |     9 +-
 arch/arc/lib/Makefile                              |     8 +
 arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi     |     2 +-
 arch/arm/boot/dts/armada-388-helios4.dts           |    23 +-
 arch/arm/boot/dts/armada-395-gp.dts                |     1 -
 arch/arm/boot/dts/gemini.dtsi                      |     2 +-
 arch/arm/boot/dts/imx7-tqma7.dtsi                  |    83 +-
 arch/arm/boot/dts/ste-ab8505.dtsi                  |    21 +-
 arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts          |     2 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |     2 +
 arch/arm/mach-mvebu/Kconfig                        |     4 +-
 arch/arm/mach-vexpress/platsmp.c                   |     4 +-
 arch/arm/mach-vexpress/v2m.c                       |     4 +-
 arch/arm/mm/alignment.c                            |    61 +-
 arch/arm/mm/dma-mapping.c                          |     5 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |     4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |     9 +
 .../boot/dts/amlogic/meson-sm1-odroid-hc4.dts      |     4 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |     2 +-
 .../boot/dts/qcom/sdm845-xiaomi-beryllium.dts      |     6 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |     2 +-
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts    |    32 +-
 arch/arm64/crypto/poly1305-armv8.pl                |     2 +-
 arch/arm64/include/asm/kvm_host.h                  |     2 +-
 arch/arm64/include/asm/sdei.h                      |     3 +-
 arch/arm64/kernel/efi.c                            |     8 +-
 arch/arm64/kernel/entry-common.c                   |    40 +-
 arch/arm64/kernel/machine_kexec.c                  |     2 +-
 arch/arm64/kernel/machine_kexec_file.c             |     2 +
 arch/arm64/kernel/sdei.c                           |    61 +-
 arch/arm64/kernel/topology.c                       |    13 +-
 arch/arm64/kernel/vdso32/Makefile                  |     3 +-
 arch/arm64/kvm/arm.c                               |    36 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |    40 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |    30 +-
 arch/arm64/mm/mmap.c                               |     4 +-
 arch/arm64/mm/mmu.c                                |    14 +
 arch/arm64/net/bpf_jit_comp.c                      |     4 +-
 arch/m68k/apollo/dn_ints.c                         |     6 +
 arch/microblaze/Makefile                           |     6 +-
 arch/microblaze/include/asm/entry.h                |    13 +
 arch/microblaze/include/asm/processor.h            |     2 +-
 arch/microblaze/include/asm/string.h               |     2 +
 arch/microblaze/include/asm/uaccess.h              |     3 +-
 arch/microblaze/kernel/cpu/cpuinfo.c               |     1 +
 arch/microblaze/kernel/entry.S                     |   294 +-
 arch/microblaze/kernel/hw_exception_handler.S      |     5 +
 arch/microblaze/kernel/process.c                   |     5 +-
 arch/microblaze/kernel/ptrace.c                    |     3 +
 arch/microblaze/kernel/signal.c                    |    26 +
 arch/microblaze/lib/memset.c                       |    33 +-
 arch/mips/Makefile                                 |    22 +-
 arch/mips/cavium-octeon/dma-octeon.c               |     2 +-
 arch/mips/mm/cex-gen.S                             |    16 +
 arch/mips/mm/tlb-r4k.c                             |    21 +-
 arch/mips/pci/ops-mace.c                           |    26 +-
 arch/mips/pci/pci-ip32.c                           |     9 +-
 arch/mips/sgi-ip32/ip32-irq.c                      |    45 +-
 arch/nios2/kernel/nios2_ksyms.c                    |     1 +
 arch/openrisc/kernel/or32_ksyms.c                  |     1 +
 arch/powerpc/kvm/book3s_hv.c                       |    76 +-
 arch/powerpc/kvm/book3s_paired_singles.c           |     7 +-
 arch/riscv/net/bpf_jit_comp32.c                    |    47 +-
 arch/s390/kernel/perf_cpum_cf.c                    |     3 +-
 arch/s390/kernel/process.c                         |    12 +-
 arch/s390/kernel/signal.c                          |     6 +-
 arch/s390/kernel/uprobes.c                         |     2 +-
 arch/s390/lib/probes.c                             |     2 +-
 arch/s390/mm/hugetlbpage.c                         |     2 +-
 arch/s390/mm/mmap.c                                |     2 +-
 arch/s390/pci/pci_irq.c                            |    26 +-
 arch/sh/Kconfig                                    |     2 +
 arch/sh/boards/board-sh7785lcr.c                   |     2 +-
 arch/sh/configs/migor_defconfig                    |     2 +-
 arch/sh/configs/sdk7786_defconfig                  |     2 +-
 arch/sh/configs/shx3_defconfig                     |     2 +-
 arch/sh/include/asm/cmpxchg.h                      |     3 +
 arch/sh/include/asm/uaccess_32.h                   |     8 +-
 arch/x86/events/intel/uncore.c                     |     5 +-
 arch/x86/include/asm/cpufeatures.h                 |     5 +
 arch/x86/include/asm/kvm-x86-ops.h                 |     1 +
 arch/x86/include/asm/kvm_host.h                    |     7 +
 arch/x86/include/asm/svm.h                         |     4 +-
 arch/x86/include/asm/xor_avx.h                     |     4 +
 arch/x86/kernel/acpi/cppc_msr.c                    |    15 +
 arch/x86/kernel/cpu/amd.c                          |    18 +
 arch/x86/kernel/nmi.c                              |     8 +
 arch/x86/kernel/process.c                          |     1 +
 arch/x86/kernel/x86_init.c                         |     2 +-
 arch/x86/kvm/hyperv.c                              |     2 +
 arch/x86/kvm/mmu/mmu.c                             |    13 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |    24 +-
 arch/x86/kvm/svm/nested.c                          |    26 +-
 arch/x86/kvm/svm/svm.c                             |    21 +-
 arch/x86/kvm/svm/svm.h                             |     2 +
 arch/x86/kvm/vmx/nested.c                          |     9 +
 arch/x86/kvm/vmx/vmx.c                             |     6 +-
 arch/x86/kvm/x86.c                                 |    91 +-
 arch/x86/mm/mem_encrypt_identity.c                 |     2 +-
 arch/x86/platform/pvh/enlighten.c                  |     2 +
 arch/x86/power/hibernate.c                         |    51 +-
 block/bdev.c                                       |    22 +
 block/blk-cgroup.c                                 |     6 +-
 block/blk-iocost.c                                 |    10 +-
 block/blk-mq.c                                     |     4 +
 block/blk-throttle.c                               |     3 +-
 block/bsg.c                                        |     5 +-
 block/ioctl.c                                      |     4 +-
 block/partitions/mac.c                             |     4 +-
 crypto/Kconfig                                     |     6 +-
 crypto/algif_skcipher.c                            |    13 +-
 crypto/asymmetric_keys/restrict.c                  |     2 +
 crypto/asymmetric_keys/verify_pefile.c             |     5 +
 crypto/ecc.c                                       |    33 +-
 crypto/tcrypt.c                                    |   424 +-
 crypto/testmgr.c                                   |    10 +-
 crypto/testmgr.h                                   |   339 +-
 drivers/accessibility/speakup/selection.c          |     6 +
 drivers/acpi/acpi_extlog.c                         |     9 +
 drivers/acpi/acpi_fpdt.c                           |    55 +-
 drivers/acpi/acpi_video.c                          |    12 +-
 drivers/acpi/acpica/dsfield.c                      |     3 +-
 drivers/acpi/acpica/exfield.c                      |    11 +-
 drivers/acpi/acpica/nsxfname.c                     |     1 +
 drivers/acpi/apei/ghes.c                           |    16 +-
 drivers/acpi/button.c                              |    23 +
 drivers/acpi/cppc_acpi.c                           |    32 +-
 drivers/acpi/glue.c                                |    10 +-
 drivers/acpi/pci_link.c                            |     1 +
 drivers/acpi/tables.c                              |     3 +
 drivers/ata/Kconfig                                |     7 -
 drivers/ata/Makefile                               |     1 -
 drivers/ata/ahci_st.c                              |    78 +-
 drivers/ata/ata_generic.c                          |     6 +-
 drivers/ata/libahci.c                              |    45 +-
 drivers/ata/libahci_platform.c                     |     4 +
 drivers/ata/libata-core.c                          |    89 +-
 drivers/ata/libata-pmp.c                           |    14 +
 drivers/ata/libata-scsi.c                          |    32 +-
 drivers/ata/libata-sff.c                           |    15 +-
 drivers/ata/pata_cs5520.c                          |     2 +-
 drivers/ata/sata_dwc_460ex.c                       |    49 +-
 drivers/ata/sata_fsl.c                             |    26 +-
 drivers/ata/sata_inic162x.c                        |   906 -
 drivers/ata/sata_qstor.c                           |     8 +-
 drivers/base/attribute_container.c                 |     7 +-
 drivers/base/bus.c                                 |     4 +-
 drivers/base/core.c                                |     4 +-
 drivers/base/dd.c                                  |     8 +-
 drivers/base/node.c                                |    17 +-
 drivers/base/power/wakeirq.c                       |    75 +-
 drivers/base/power/wakeup.c                        |    30 -
 drivers/block/amiflop.c                            |    69 +-
 drivers/block/aoe/aoenet.c                         |    14 +-
 drivers/block/drbd/drbd_receiver.c                 |     2 +
 drivers/block/floppy.c                             |    13 +-
 drivers/block/loop.c                               |     6 +-
 drivers/block/rnbd/rnbd-srv-dev.c                  |    62 +-
 drivers/block/rnbd/rnbd-srv-dev.h                  |    19 +-
 drivers/block/rnbd/rnbd-srv-sysfs.c                |    31 +-
 drivers/block/rnbd/rnbd-srv.c                      |    99 +-
 drivers/block/rnbd/rnbd-srv.h                      |    10 +-
 drivers/block/swim.c                               |   196 +-
 drivers/block/swim3.c                              |     8 +-
 drivers/block/swim_asm.S                           |   136 +-
 drivers/block/virtio_blk.c                         |     2 +-
 drivers/block/xen-blkback/blkback.c                |     7 +
 drivers/block/xen-blkfront.c                       |    15 +-
 drivers/bluetooth/btintel.c                        |     6 +-
 drivers/bluetooth/btrsi.c                          |     3 +-
 drivers/bluetooth/btusb.c                          |     4 +
 drivers/bluetooth/hci_bcsp.c                       |     5 +-
 drivers/bluetooth/hci_nokia.c                      |    20 +
 drivers/bluetooth/virtio_bt.c                      |     4 +-
 drivers/bus/arm-cci.c                              |     6 +-
 drivers/char/hw_random/amd-rng.c                   |     2 +-
 drivers/char/hw_random/ba431-rng.c                 |     2 +-
 drivers/char/hw_random/cctrng.c                    |     7 +-
 drivers/char/hw_random/core.c                      |     1 +
 drivers/char/hw_random/intel-rng.c                 |     5 +-
 drivers/char/hw_random/virtio-rng.c                |     7 +
 drivers/char/ipmi/ipmi_msghandler.c                |     1 +
 drivers/char/scx200_gpio.c                         |     8 +-
 drivers/char/tpm/tpm-dev-common.c                  |     3 +
 drivers/char/tpm/tpm2-cmd.c                        |     3 +-
 drivers/char/tpm/tpm_nsc.c                         |     8 +-
 drivers/char/tpm/tpm_tis_spi.h                     |     8 +-
 drivers/char/virtio_console.c                      |    13 +-
 drivers/clk/bcm/clk-raspberrypi.c                  |     2 +
 drivers/clk/clk-cdce925.c                          |     9 +-
 drivers/clk/clk-lmk04832.c                         |     3 +
 drivers/clk/clk-milbeaut.c                         |    10 +-
 drivers/clk/clk-si5351.c                           |    20 +-
 drivers/clk/clk.c                                  |    51 +-
 drivers/clk/clk.h                                  |     5 +-
 drivers/clk/clkdev.c                               |     4 +-
 drivers/clk/imx/clk-imx8qxp-lpcg.c                 |     1 +
 drivers/clk/imx/clk-imx8qxp.c                      |     1 +
 drivers/clk/imx/clk.c                              |    15 +-
 drivers/clk/mstar/clk-msc313-mpll.c                |     2 +-
 drivers/clk/qcom/clk-rcg2.c                        |     9 +-
 drivers/clk/qcom/mmcc-msm8996.c                    |     4 +-
 drivers/clk/qcom/mmcc-sdm660.c                     |     2 +-
 drivers/clk/sunxi-ng/ccu_common.c                  |    12 +-
 drivers/clk/tegra/clk-pll.c                        |     1 +
 drivers/clk/ti/adpll.c                             |     1 +
 drivers/clk/zynq/clkc.c                            |     8 +
 drivers/clocksource/clksrc-dbx500-prcmu.c          |     2 +
 drivers/clocksource/timer-digicolor.c              |     2 +
 drivers/clocksource/timer-fttmr010.c               |     2 +
 drivers/clocksource/timer-mediatek.c               |     4 +-
 drivers/comedi/drivers/addi_apci_3xxx.c            |     2 +-
 drivers/comedi/drivers/aio_iiro_16.c               |     3 +
 drivers/comedi/drivers/comedi_parport.c            |     3 +-
 drivers/comedi/drivers/das6402.c                   |    10 +-
 drivers/comedi/drivers/dmm32at.c                   |     3 +-
 drivers/comedi/drivers/dt2811.c                    |     9 +-
 drivers/comedi/drivers/dt2814.c                    |     3 +-
 drivers/comedi/drivers/ni_at_a2150.c               |    13 +-
 drivers/comedi/drivers/ni_atmio16d.c               |     7 +-
 drivers/comedi/drivers/pcl711.c                    |     3 +-
 drivers/comedi/drivers/pcl816.c                    |     3 +-
 drivers/comedi/drivers/pcl818.c                    |     3 +-
 drivers/comedi/drivers/pcmmio.c                    |     6 +-
 drivers/comedi/drivers/pcmuio.c                    |    10 +-
 drivers/comedi/drivers/quatech_daqp_cs.c           |     4 +-
 drivers/cpufreq/cpufreq_conservative.c             |     8 +-
 drivers/cpufreq/cpufreq_governor.c                 |    29 +-
 drivers/cpufreq/cpufreq_governor.h                 |     2 +
 drivers/cpufreq/cpufreq_stats.c                    |     4 +
 drivers/cpufreq/sparc-us2e-cpufreq.c               |    11 +-
 drivers/cpufreq/sti-cpufreq.c                      |     4 +-
 drivers/cpuidle/governors/menu.c                   |     8 +-
 drivers/cpuidle/governors/teo.c                    |    11 +
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |    29 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |     7 +-
 drivers/crypto/atmel-aes.c                         |     4 +-
 drivers/crypto/atmel-sha.c                         |    17 +
 drivers/crypto/atmel-tdes.c                        |     6 +-
 drivers/crypto/caam/caampkc.c                      |     6 +
 drivers/crypto/ccp/ccp-dev-v3.c                    |     4 +
 drivers/crypto/ccp/ccp-dev-v5.c                    |     4 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    22 +-
 drivers/crypto/nx/nx-842.c                         |     2 +
 drivers/crypto/omap-sham.c                         |     1 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |     8 +-
 drivers/crypto/talitos.c                           |    93 +-
 drivers/crypto/talitos.h                           |     5 +-
 drivers/cxl/acpi.c                                 |     8 +-
 drivers/dax/super.c                                |     2 +-
 drivers/dma/altera-msgdma.c                        |    10 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   178 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h              |    39 +-
 drivers/dma/dw-edma/dw-edma-pcie.c                 |     3 +
 drivers/dma/fsl_raid.c                             |    32 +-
 drivers/dma/img-mdc-dma.c                          |     2 +-
 drivers/dma/ioat/init.c                            |    18 +-
 drivers/dma/mediatek/mtk-hsdma.c                   |    26 +-
 drivers/dma/mv_xor.c                               |     1 +
 drivers/dma/pl330.c                                |    19 +-
 drivers/dma/plx_dma.c                              |    10 +-
 drivers/dma/qcom/bam_dma.c                         |    12 +-
 drivers/dma/sprd-dma.c                             |    45 +-
 drivers/dma/sun6i-dma.c                            |    57 +-
 drivers/dma/xilinx/xilinx_dma.c                    |    46 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |    74 +-
 drivers/firmware/efi/cper.c                        |    51 +-
 drivers/firmware/efi/libstub/Makefile              |     2 +-
 drivers/firmware/efi/libstub/efi-stub.c            |     8 +
 drivers/firmware/efi/libstub/efistub.h             |     4 +-
 drivers/firmware/imx/imx-dsp.c                     |     6 +-
 drivers/firmware/imx/imx-scu.c                     |    25 +-
 drivers/firmware/imx/scu-pd.c                      |    10 +-
 drivers/fpga/fpga-mgr.c                            |     2 +-
 drivers/gpio/gpio-crystalcove.c                    |     1 +
 drivers/gpio/gpio-mvebu.c                          |    33 +-
 drivers/gpio/gpio-pca953x.c                        |    28 +-
 drivers/gpio/gpiolib-cdev.c                        |     5 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    68 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |    17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |    10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |    43 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |    20 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |     7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    44 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |     4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |     3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |     4 +
 drivers/gpu/drm/amd/amdgpu/cik.c                   |    10 +
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |     5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |     5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |     5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |     5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |     8 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |     5 +-
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c             |    42 +-
 drivers/gpu/drm/amd/amdgpu/si.c                    |    10 +
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c              |     6 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |     6 +-
 drivers/gpu/drm/amd/amdgpu/vce_v4_0.c              |     6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |     4 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |    10 +
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |    35 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |     8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |    14 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h    |    24 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |     6 +-
 drivers/gpu/drm/amd/display/dc/dc_types.h          |     2 +-
 .../gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c   |     2 +-
 .../amd/include/asic_reg/dcn/dcn_6_0_0_offset.h    | 15799 +++++
 .../amd/include/asic_reg/dcn/dcn_6_0_0_sh_mask.h   | 58556 +++++++++++++++++++
 .../amd/include/asic_reg/dpcs/dpcs_6_0_0_offset.h  |    47 +
 .../amd/include/asic_reg/dpcs/dpcs_6_0_0_sh_mask.h |    55 +
 .../include/asic_reg/mmhub/mmhub_5_0_1_offset.h    |    17 +
 .../include/asic_reg/mmhub/mmhub_5_0_1_sh_mask.h   |    17 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |    31 +-
 .../amd/pm/powerplay/hwmgr/process_pptables_v1_0.c |   673 +-
 .../drm/amd/pm/powerplay/hwmgr/processpptables.c   |   446 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |    36 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |    48 +-
 .../pm/powerplay/hwmgr/vega10_processpptables.c    |    59 +-
 .../pm/powerplay/hwmgr/vega12_processpptables.c    |     7 +
 .../pm/powerplay/hwmgr/vega20_processpptables.c    |     7 +
 .../gpu/drm/arm/display/include/malidp_product.h   |    10 +-
 drivers/gpu/drm/arm/malidp_crtc.c                  |     1 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |    13 +-
 drivers/gpu/drm/bridge/nwl-dsi.c                   |    17 +-
 drivers/gpu/drm/drm_crtc.c                         |    15 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |    40 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |     6 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |     2 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |     2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |     6 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c           |     9 -
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |     3 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |    35 +-
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |     6 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |    48 +-
 drivers/gpu/drm/msm/hdmi/hdmi_hpd.c                |    24 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |    47 +-
 drivers/gpu/drm/nouveau/include/nvkm/subdev/pci.h  |     1 +
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |     4 +
 drivers/gpu/drm/nouveau/nouveau_svm.c              |    13 +
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |     2 +-
 .../gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c    |    20 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pci/Kbuild     |     1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c    |    36 +
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |    63 +-
 drivers/gpu/drm/panel/panel-simple.c               |     3 +
 drivers/gpu/drm/panfrost/panfrost_devfreq.c        |     2 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |    11 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |    21 +-
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |     7 +-
 drivers/gpu/drm/tegra/submit.c                     |    12 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |     7 +
 drivers/gpu/drm/v3d/v3d_sched.c                    |     2 +
 drivers/gpu/drm/vc4/vc4_gem.c                      |    10 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |     9 +-
 drivers/gpu/host1x/hw/cdma_hw.c                    |     2 +-
 drivers/greybus/manifest.c                         |     2 +
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |     4 +-
 .../amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.h  |     2 -
 .../hid_descriptor/amd_sfh_hid_report_desc.h       |     7 -
 drivers/hid/hid-core.c                             |     4 +-
 drivers/hid/hid-cougar.c                           |     3 +
 drivers/hid/hid-cp2112.c                           |     9 +-
 drivers/hid/hid-elo.c                              |     3 +
 drivers/hid/hid-ids.h                              |     4 +
 drivers/hid/hid-logitech-dj.c                      |     3 +
 drivers/hid/hid-mcp2221.c                          |     2 +-
 drivers/hid/hid-multitouch.c                       |    19 +-
 drivers/hid/hid-picolcd_fb.c                       |    12 +-
 drivers/hid/hid-prodikeys.c                        |   122 +-
 drivers/hid/hid-quirks.c                           |     2 +
 drivers/hid/hid-rmi.c                              |     2 +-
 drivers/hid/hid-roccat-isku.c                      |     3 +
 drivers/hid/hid-roccat-koneplus.c                  |     3 +
 drivers/hid/hid-roccat-konepure.c                  |     3 +
 drivers/hid/hid-roccat-kovaplus.c                  |     3 +
 drivers/hid/hid-roccat-pyra.c                      |     3 +
 drivers/hid/hid-roccat-ryos.c                      |     3 +
 drivers/hid/hid-roccat-savu.c                      |     3 +
 drivers/hid/hid-roccat.c                           |     8 +-
 drivers/hid/hid-zydacron.c                         |     3 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |     2 +-
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |     5 +-
 drivers/hid/usbhid/hiddev.c                        |    37 +-
 drivers/hid/wacom_sys.c                            |   192 +-
 drivers/hid/wacom_wac.c                            |   114 +-
 drivers/hid/wacom_wac.h                            |     6 +-
 drivers/hsi/controllers/omap_ssi_core.c            |     3 +
 drivers/hv/ring_buffer.c                           |    29 +-
 drivers/hwmon/acpi_power_meter.c                   |    10 +-
 drivers/hwmon/aquacomputer_d5next.c                |     6 +
 drivers/hwmon/coretemp.c                           |    13 +-
 drivers/hwmon/corsair-cpro.c                       |    12 +-
 drivers/hwmon/lm70.c                               |     6 +-
 drivers/hwmon/lm87.c                               |     7 +-
 drivers/hwmon/lm95245.c                            |     6 +-
 drivers/hwmon/nct6683.c                            |     4 +-
 drivers/hwmon/pmbus/q54sj108a2.c                   |     2 +
 drivers/hwmon/sht15.c                              |    28 +-
 drivers/hwmon/sht3x.c                              |     5 +-
 drivers/hwmon/tmp102.c                             |     8 +-
 drivers/hwmon/tmp108.c                             |    26 +-
 drivers/i2c/busses/i2c-designware-master.c         |     8 +
 drivers/i2c/busses/i2c-mt7621.c                    |     9 +-
 drivers/i2c/i2c-core-acpi.c                        |    24 +-
 drivers/iio/accel/adis16201.c                      |    10 +-
 drivers/iio/accel/bma220_spi.c                     |     3 +-
 drivers/iio/accel/fxls8962af-core.c                |     2 +
 drivers/iio/accel/kxcjk-1013.c                     |     1 +
 drivers/iio/accel/mma9551.c                        |     1 +
 drivers/iio/accel/mma9553.c                        |     1 +
 drivers/iio/adc/max1241.c                          |     1 +
 drivers/iio/dac/ad5758.c                           |     6 +-
 drivers/iio/humidity/hts221_core.c                 |   106 +-
 drivers/iio/imu/adis16400.c                        |     5 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |     8 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |     8 +-
 drivers/iio/light/isl29028.c                       |    23 +-
 drivers/iio/light/ltr501.c                         |     2 +-
 drivers/iio/pressure/dps310.c                      |     6 +-
 drivers/iio/temperature/tmp117.c                   |     9 +-
 drivers/infiniband/core/lag.c                      |    19 +-
 drivers/infiniband/core/mad.c                      |     2 +
 drivers/infiniband/core/mad_rmpp.c                 |     7 +-
 drivers/infiniband/core/nldev.c                    |     5 +-
 drivers/infiniband/core/uverbs_std_types_device.c  |     1 +
 drivers/infiniband/core/uverbs_std_types_wq.c      |     2 +-
 drivers/infiniband/core/verbs.c                    |     3 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    50 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |     9 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |     5 +-
 drivers/infiniband/hw/hfi1/chip.c                  |     4 +-
 drivers/infiniband/hw/hfi1/fault.c                 |     1 -
 drivers/infiniband/hw/hfi1/sdma.c                  |     3 +
 drivers/infiniband/hw/hfi1/verbs.c                 |     4 +
 drivers/infiniband/hw/hns/hns_roce_cq.c            |     1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |    37 +-
 drivers/infiniband/hw/irdma/ctrl.c                 |     2 +-
 drivers/infiniband/hw/irdma/pble.c                 |     6 +-
 drivers/infiniband/hw/irdma/verbs.c                |    10 +-
 drivers/infiniband/hw/mlx5/cq.c                    |    24 +-
 drivers/infiniband/hw/mlx5/main.c                  |     2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |     2 +
 drivers/infiniband/hw/mlx5/odp.c                   |     2 +-
 drivers/infiniband/hw/mlx5/qp.c                    |     8 +-
 drivers/infiniband/hw/mlx5/qpc.c                   |     8 +-
 drivers/infiniband/hw/mlx5/srq.c                   |     3 +-
 drivers/infiniband/hw/mlx5/wr.c                    |     1 +
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |     2 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |     2 +-
 drivers/infiniband/sw/rxe/rxe_av.c                 |    37 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |     8 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |     4 +
 drivers/infiniband/sw/rxe/rxe_net.c                |    17 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |     9 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |    80 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |     2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |    34 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |     8 +-
 drivers/infiniband/sw/siw/siw_main.c               |     5 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |    20 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |     7 +
 drivers/infiniband/ulp/isert/ib_isert.c            |     2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |    32 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |     2 +-
 drivers/input/joystick/xpad.c                      |     2 +
 drivers/iommu/amd/init.c                           |    23 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |    11 +-
 drivers/iommu/dma-iommu.c                          |    20 +-
 drivers/iommu/intel/dmar.c                         |    70 +-
 drivers/iommu/rockchip-iommu.c                     |    13 +
 drivers/iommu/virtio-iommu.c                       |     6 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   499 +-
 drivers/irqchip/irq-gic-v3.c                       |     1 +
 drivers/irqchip/irq-imx-intmux.c                   |    29 +-
 drivers/leds/flash/leds-ktd2692.c                  |    10 +-
 drivers/leds/led-class-flash.c                     |     2 +-
 drivers/leds/leds-lm3692x.c                        |     4 +-
 drivers/leds/leds-pca9532.c                        |     9 +-
 drivers/mailbox/arm_mhuv2.c                        |     9 +-
 drivers/mailbox/mailbox-altera.c                   |     2 +-
 drivers/mailbox/qcom-ipcc.c                        |     6 +
 drivers/mailbox/ti-msgmgr.c                        |    12 +-
 drivers/md/dm-snap-persistent.c                    |     7 +-
 drivers/md/dm-writecache.c                         |    55 +-
 drivers/md/md.c                                    |    21 +-
 drivers/md/raid5-cache.c                           |    34 +-
 drivers/md/raid5.c                                 |    62 +-
 drivers/md/raid5.h                                 |     1 +
 drivers/media/cec/core/cec-adap.c                  |     1 -
 drivers/media/cec/platform/stm32/stm32-cec.c       |    16 +-
 drivers/media/cec/platform/tegra/tegra_cec.c       |    14 +-
 drivers/media/common/cypress_firmware.c            |     2 +
 drivers/media/common/saa7146/saa7146_core.c        |     3 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    14 +-
 drivers/media/dvb-core/dmxdev.c                    |    11 +-
 drivers/media/dvb-frontends/stv0900_core.c         |     2 +
 drivers/media/dvb-frontends/stv090x.c              |     2 +
 drivers/media/i2c/adv7180.c                        |     2 +-
 drivers/media/i2c/adv748x/adv748x-core.c           |    13 +-
 drivers/media/i2c/adv7604.c                        |     3 +-
 drivers/media/i2c/ov5647.c                         |     4 +
 drivers/media/i2c/ov5648.c                         |     4 +-
 drivers/media/i2c/ov8856.c                         |     3 +-
 drivers/media/i2c/ov8865.c                         |    48 +-
 drivers/media/i2c/tc358743.c                       |     3 +-
 drivers/media/pci/cx18/cx18-driver.c               |     9 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |     2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |     4 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |    14 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    10 +-
 drivers/media/pci/ivtv/ivtv-vbi.c                  |     2 +-
 drivers/media/pci/tw68/tw68-core.c                 |     2 +-
 drivers/media/pci/tw686x/tw686x-core.c             |    10 +
 drivers/media/platform/atmel/atmel-isc-base.c      |    51 +-
 drivers/media/platform/atmel/atmel-isc-regs.h      |     6 +
 drivers/media/platform/atmel/atmel-isc.h           |     1 +
 drivers/media/platform/atmel/atmel-isi.c           |     7 +-
 drivers/media/platform/atmel/atmel-sama5d2-isc.c   |     7 +-
 drivers/media/platform/atmel/atmel-sama7g5-isc.c   |     7 +-
 drivers/media/platform/davinci/vpif_capture.c      |     5 +-
 drivers/media/platform/davinci/vpif_display.c      |     3 +
 drivers/media/platform/exynos4-is/fimc-lite.c      |     3 +-
 drivers/media/platform/imx-jpeg/mxc-jpeg.c         |    21 +-
 drivers/media/platform/m2m-deinterlace.c           |     2 +-
 drivers/media/platform/marvell-ccic/Kconfig        |     1 +
 drivers/media/platform/marvell-ccic/mmp-driver.c   |     5 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |     4 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |     6 +-
 drivers/media/platform/qcom/camss/camss-vfe-170.c  |    71 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c  |     8 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c  |     8 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-8.c  |     8 +-
 drivers/media/platform/qcom/camss/camss-vfe.c      |    43 +-
 drivers/media/platform/qcom/camss/camss-vfe.h      |    11 +-
 drivers/media/platform/qcom/venus/hfi_msgs.c       |     3 +
 drivers/media/platform/rockchip/rga/rga.c          |    69 +-
 drivers/media/platform/rockchip/rga/rga.h          |     7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |     4 +-
 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c |     7 +-
 drivers/media/rc/fintek-cir.c                      |     4 +
 drivers/media/rc/imon.c                            |     5 -
 drivers/media/rc/ir-hix5hd2.c                      |     5 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |     5 +-
 drivers/media/rc/meson-ir-tx.c                     |    18 +-
 drivers/media/rc/rc-ir-raw.c                       |    38 +-
 drivers/media/rc/redrat3.c                         |    32 +-
 drivers/media/rc/serial_ir.c                       |     2 +-
 drivers/media/rc/streamzap.c                       |     1 +
 drivers/media/test-drivers/vicodec/codec-fwht.h    |     2 +-
 drivers/media/test-drivers/vicodec/vicodec-core.c  |    16 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |     4 +
 drivers/media/test-drivers/vidtv/vidtv_demod.c     |     9 -
 drivers/media/test-drivers/vim2m.c                 |    29 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |    13 +
 drivers/media/usb/au0828/au0828-core.c             |     4 +
 drivers/media/usb/au0828/au0828-dvb.c              |    20 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |     2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |     2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    14 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |     2 +
 drivers/media/usb/em28xx/em28xx-audio.c            |     7 +
 drivers/media/usb/em28xx/em28xx-cards.c            |     2 +-
 drivers/media/usb/em28xx/em28xx-core.c             |     3 -
 drivers/media/usb/em28xx/em28xx-video.c            |    26 +-
 drivers/media/usb/go7007/go7007-driver.c           |     5 +-
 drivers/media/usb/go7007/go7007-fw.c               |    28 +-
 drivers/media/usb/go7007/go7007-usb.c              |     8 +
 drivers/media/usb/go7007/s2250-board.c             |    54 +-
 drivers/media/usb/gspca/gspca.c                    |     3 +-
 drivers/media/usb/hackrf/hackrf.c                  |     7 +-
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c          |     1 +
 drivers/media/usb/usbtv/usbtv-core.c               |     6 +-
 drivers/media/usb/usbtv/usbtv-video.c              |     4 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |     2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |    34 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |    12 +-
 drivers/memory/brcmstb_dpfe.c                      |    34 +-
 drivers/memory/emif.c                              |     9 +-
 drivers/memory/samsung/exynos5422-dmc.c            |    11 +-
 drivers/mfd/ab8500-core.c                          |    44 +-
 drivers/mfd/da903x.c                               |    35 +-
 drivers/mfd/da9150-core.c                          |     8 +-
 drivers/mfd/intel_quark_i2c_gpio.c                 |    52 +-
 drivers/mfd/ipaq-micro.c                           |     2 +-
 drivers/mfd/tps65217.c                             |    72 +-
 drivers/mfd/twl-core.c                             |   346 +-
 drivers/mfd/wcd934x.c                              |    34 +-
 drivers/misc/bcm-vk/bcm_vk_msg.c                   |    18 +-
 drivers/misc/enclosure.c                           |     3 +-
 drivers/misc/genwqe/card_utils.c                   |     2 +-
 drivers/misc/hpilo.c                               |     7 +-
 drivers/misc/ibmvmc.c                              |     7 +
 drivers/mmc/core/block.c                           |     5 +
 drivers/mmc/host/cqhci-core.c                      |    14 +-
 drivers/mmc/host/dw_mmc.c                          |     1 +
 drivers/mtd/chips/cfi_cmdset_0002.c                |    15 +
 drivers/mtd/maps/amd76xrom.c                       |     2 +
 drivers/mtd/maps/l440gx.c                          |     2 -
 drivers/mtd/maps/pci.c                             |     2 +-
 drivers/mtd/mtd_blkdevs.c                          |     5 +
 drivers/mtd/mtdcore.c                              |     2 +-
 drivers/mtd/mtdsuper.c                             |     4 +-
 drivers/mtd/nand/raw/Kconfig                       |     3 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |     6 +-
 drivers/mtd/nand/raw/ndfc.c                        |    41 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |     1 +
 drivers/mtd/nand/raw/sunxi_nand.c                  |     3 +
 drivers/mtd/parsers/qcomsmempart.c                 |     4 +-
 drivers/mtd/spi-nor/sfdp.c                         |     4 +
 drivers/net/bonding/bond_main.c                    |     2 +-
 drivers/net/can/dev/netlink.c                      |     4 +-
 drivers/net/can/dev/skb.c                          |     1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |     7 +-
 drivers/net/dsa/mt7530.c                           |    24 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |     8 +-
 drivers/net/ethernet/alacritech/slicoss.c          |     2 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |     2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    33 +
 drivers/net/ethernet/broadcom/bgmac.c              |    61 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    25 +-
 drivers/net/ethernet/broadcom/tg3.c                |    42 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |     2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |     1 +
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |    12 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |    34 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    40 +-
 drivers/net/ethernet/jme.c                         |    37 +-
 drivers/net/ethernet/jme.h                         |     1 +
 drivers/net/ethernet/marvell/mvneta.c              |    18 +
 drivers/net/ethernet/marvell/mvneta_bm.c           |    72 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |     4 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |     4 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |     4 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |     2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |     2 +-
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |    15 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |    13 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |     3 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |     3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    13 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |     2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |     4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    86 +-
 drivers/net/gtp.c                                  |     7 +-
 drivers/net/macsec.c                               |     5 +
 drivers/net/macvlan.c                              |     3 +-
 drivers/net/netdevsim/bpf.c                        |    11 +
 drivers/net/ppp/ppp_generic.c                      |     1 +
 drivers/net/ppp/pppoe.c                            |    25 +-
 drivers/net/team/team.c                            |    11 +
 drivers/net/tun.c                                  |    18 +-
 drivers/net/usb/cdc_ether.c                        |    16 +
 drivers/net/usb/cdc_mbim.c                         |     5 +-
 drivers/net/usb/cdc_ncm.c                          |     7 +-
 drivers/net/usb/lan78xx.c                          |     9 +-
 drivers/net/usb/pegasus.c                          |    16 +-
 drivers/net/usb/qmi_wwan.c                         |     1 +
 drivers/net/usb/rtl8150.c                          |     4 +-
 drivers/net/usb/usbnet.c                           |    32 +-
 drivers/net/veth.c                                 |     7 +-
 drivers/net/vxlan/vxlan_core.c                     |    14 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |     6 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    12 +-
 drivers/net/wireless/ath/ath11k/ce.c               |     2 +-
 drivers/net/wireless/ath/ath11k/core.c             |     3 +-
 drivers/net/wireless/ath/ath11k/dp.c               |     2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    19 +-
 drivers/net/wireless/ath/ath11k/mac.c              |    33 +-
 drivers/net/wireless/ath/ath11k/mac.h              |     2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |     6 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |     2 -
 drivers/net/wireless/ath/ath9k/channel.c           |     2 +
 drivers/net/wireless/ath/carl9170/debug.c          |     5 +-
 drivers/net/wireless/broadcom/b43/debugfs.c        |     2 +-
 drivers/net/wireless/broadcom/b43/main.c           |     5 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c  |     2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |     6 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    49 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |     2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |     1 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    17 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |     2 +
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |     1 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    76 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |     2 +
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |     1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    33 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    18 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    47 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    22 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    39 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |     6 -
 drivers/net/wireless/realtek/rtw88/debug.c         |     5 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |     2 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |     2 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |     5 +
 drivers/net/wwan/wwan_hwsim.c                      |     4 +
 drivers/net/xen-netback/netback.c                  |     9 +-
 drivers/net/xen-netback/xenbus.c                   |     8 +-
 drivers/nfc/nfcmrvl/spi.c                          |     4 +
 drivers/nfc/nxp-nci/i2c.c                          |     4 +-
 drivers/nvdimm/pmem.c                              |     6 +-
 drivers/nvme/host/core.c                           |    11 +-
 drivers/nvme/host/fc.c                             |     2 +-
 drivers/nvme/host/nvme.h                           |     6 +-
 drivers/nvme/host/pci.c                            |     6 +-
 drivers/nvme/host/rdma.c                           |     1 +
 drivers/nvme/host/tcp.c                            |    36 +-
 drivers/nvme/host/zns.c                            |     8 +-
 drivers/nvme/target/admin-cmd.c                    |    16 +-
 drivers/nvme/target/configfs.c                     |   103 +-
 drivers/nvme/target/core.c                         |    17 +-
 drivers/nvme/target/fabrics-cmd.c                  |     3 +-
 drivers/nvme/target/fc.c                           |    33 +-
 drivers/nvme/target/io-cmd-bdev.c                  |     5 +-
 drivers/nvme/target/io-cmd-file.c                  |     4 +-
 drivers/nvme/target/loop.c                         |     2 -
 drivers/nvme/target/nvmet.h                        |     8 +
 drivers/nvme/target/rdma.c                         |    31 +-
 drivers/nvme/target/tcp.c                          |     7 +-
 drivers/nvme/target/zns.c                          |    10 +
 drivers/nvmem/rockchip-otp.c                       |    95 +-
 drivers/of/fdt.c                                   |     3 +
 drivers/opp/of.c                                   |     2 +-
 drivers/parisc/eisa_enumerator.c                   |    15 +-
 drivers/pci/ats.c                                  |     7 +-
 drivers/pci/controller/cadence/pcie-cadence-plat.c |    38 +-
 drivers/pci/controller/dwc/pcie-designware.c       |    11 +-
 drivers/pci/controller/dwc/pcie-designware.h       |     1 +
 drivers/pci/controller/pci-aardvark.c              |    31 +-
 drivers/pci/controller/pci-xgene.c                 |    11 +-
 drivers/pci/controller/pcie-rockchip-host.c        |    16 -
 drivers/pci/controller/pcie-rockchip.c             |    14 +-
 drivers/pci/controller/pcie-rockchip.h             |     1 -
 drivers/pci/controller/vmd.c                       |     3 +
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |     8 +-
 drivers/pci/hotplug/pciehp_core.c                  |     2 +-
 drivers/pci/iov.c                                  |    25 -
 drivers/pci/p2pdma.c                               |    10 +-
 drivers/pci/pci-label.c                            |    94 +-
 drivers/pci/pci.h                                  |     4 -
 drivers/pci/pcie/Kconfig                           |     9 +
 drivers/pci/pcie/aer.c                             |   103 +-
 drivers/pci/pcie/portdrv_core.c                    |    28 +-
 drivers/pci/probe.c                                |    15 +-
 drivers/pci/quirks.c                               |     4 +-
 drivers/pci/xen-pcifront.c                         |    57 +-
 drivers/perf/xgene_pmu.c                           |     4 +-
 drivers/phy/cadence/phy-cadence-sierra.c           |    11 +-
 drivers/phy/phy-core.c                             |    45 +-
 drivers/pinctrl/mediatek/pinctrl-mt7629.c          |     2 +-
 drivers/pinctrl/pinctrl-sx150x.c                   |     1 +
 drivers/pinctrl/sprd/pinctrl-sprd.c                |     3 +
 drivers/platform/olpc/olpc-ec.c                    |     2 +-
 drivers/platform/x86/asus-nb-wmi.c                 |     1 +
 drivers/platform/x86/asus-wmi.c                    |    11 +
 drivers/platform/x86/gpd-pocket-fan.c              |     9 +-
 drivers/platform/x86/hp/hp-wmi.c                   |     6 +-
 drivers/platform/x86/ibm_rtl.c                     |     8 +-
 drivers/platform/x86/intel/int3472/discrete.c      |    16 +-
 drivers/platform/x86/intel/telemetry/core.c        |     4 +
 drivers/power/reset/piix4-poweroff.c               |     1 +
 drivers/power/supply/ab8500_btemp.c                |    28 +-
 drivers/power/supply/ab8500_chargalg.c             |     9 +-
 drivers/power/supply/ab8500_charger.c              |   118 +-
 drivers/power/supply/ab8500_fg.c                   |    21 +-
 drivers/power/supply/bq24190_charger.c             |     9 +-
 drivers/power/supply/bq2515x_charger.c             |    15 +-
 drivers/power/supply/bq27xxx_battery.c             |    16 +-
 drivers/power/supply/cros_peripheral_charger.c     |    13 +-
 drivers/power/supply/generic-adc-battery.c         |    86 +-
 drivers/power/supply/gpio-charger.c                |     5 +-
 drivers/power/supply/ltc2941-battery-gauge.c       |     3 +
 drivers/power/supply/power_supply_core.c           |    83 +-
 drivers/pwm/pwm-lp3943.c                           |    22 +-
 drivers/pwm/pwm-mtk-disp.c                         |     4 +-
 drivers/pwm/pwm-renesas-tpu.c                      |   285 +-
 drivers/pwm/pwm-tiehrpwm.c                         |     3 +
 drivers/rapidio/devices/rio_mport_cdev.c           |     5 +-
 drivers/regulator/ab8500.c                         |   159 +-
 drivers/regulator/core.c                           |     4 +
 drivers/regulator/fixed.c                          |     4 +
 drivers/regulator/irq_helpers.c                    |    77 +-
 drivers/regulator/mp886x.c                         |    13 +-
 drivers/regulator/rt6245-regulator.c               |     5 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |     2 +-
 drivers/remoteproc/remoteproc_core.c               |     4 +
 drivers/remoteproc/remoteproc_elf_loader.c         |    23 +-
 drivers/rpmsg/mtk_rpmsg.c                          |     1 +
 drivers/rpmsg/rpmsg_core.c                         |    21 +
 drivers/rpmsg/rpmsg_internal.h                     |     2 +
 drivers/rpmsg/virtio_rpmsg_bus.c                   |   128 +-
 drivers/rtc/Kconfig                                |    21 +
 drivers/rtc/class.c                                |     8 +-
 drivers/rtc/rtc-ab-eoz9.c                          |     1 +
 drivers/rtc/rtc-abx80x.c                           |    58 +-
 drivers/rtc/rtc-bd70528.c                          |     5 +
 drivers/rtc/rtc-brcmstb-waketimer.c                |     1 +
 drivers/rtc/rtc-cmos.c                             |     6 +-
 drivers/rtc/rtc-ds1307.c                           |     2 +-
 drivers/rtc/rtc-ds1685.c                           |    20 +-
 drivers/rtc/rtc-ftrtc010.c                         |    26 +-
 drivers/rtc/rtc-s35390a.c                          |   152 +-
 drivers/s390/block/dasd.c                          |    10 +-
 drivers/s390/char/vmcp.c                           |     4 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |     8 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c                 |    20 +-
 drivers/scsi/dc395x.c                              |    10 +-
 drivers/scsi/elx/libefc/efclib.c                   |     2 +
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    10 +-
 drivers/scsi/libiscsi_tcp.c                        |     3 +-
 drivers/scsi/libsas/sas_task.c                     |     2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h              |    59 +-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h               |    15 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h                |   128 +-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h                |    44 +
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h                |    14 +
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h          |    31 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |    28 +-
 drivers/scsi/mpi3mr/mpi3mr_debug.h                 |   135 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   871 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |    97 +-
 drivers/scsi/pm8001/pm8001_defs.h                  |    98 +
 drivers/scsi/pm8001/pm8001_hwi.c                   |     2 +-
 drivers/scsi/pm8001/pm8001_hwi.h                   |     4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |     2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h                   |   100 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    15 +-
 drivers/scsi/scsi_bsg.c                            |     6 +-
 drivers/scsi/scsi_debug.c                          |     4 +-
 drivers/scsi/scsi_ioctl.c                          |    11 +-
 drivers/scsi/snic/snic_main.c                      |     1 +
 drivers/scsi/st.c                                  |    75 +
 drivers/scsi/ufs/ufs_bsg.c                         |     6 +-
 drivers/scsi/ufs/ufshcd.c                          |    12 +-
 drivers/sh/intc/core.c                             |    11 +-
 drivers/sh/maple/maple.c                           |     4 +-
 drivers/slimbus/messaging.c                        |     2 +-
 drivers/soc/fsl/dpio/dpio-driver.c                 |     9 +-
 drivers/soc/ixp4xx/ixp4xx-qmgr.c                   |     1 +
 drivers/soc/tegra/flowctrl.c                       |     7 +-
 drivers/soundwire/dmi-quirks.c                     |    21 +-
 drivers/spi/spi-bcm-qspi.c                         |     3 +-
 drivers/spi/spi-cadence-quadspi.c                  |     3 +-
 drivers/spi/spi-jcore.c                            |     2 +
 drivers/spi/spi-mtk-nor.c                          |     1 +
 drivers/spi/spi-mxic.c                             |     8 +-
 drivers/spi/spi-npcm-fiu.c                         |     8 +
 drivers/spi/spi-omap2-mcspi.c                      |     2 -
 drivers/spi/spi-rspi.c                             |    86 +-
 drivers/spi/spi-sh-msiof.c                         |    50 +-
 drivers/spi/spi-sun4i.c                            |    26 +-
 drivers/spi/spi-zynq-qspi.c                        |     6 +-
 drivers/spi/spi.c                                  |     2 +-
 drivers/staging/greybus/uart.c                     |    32 +-
 drivers/staging/iio/adc/ad7816.c                   |     6 +-
 drivers/staging/media/av7110/sp8870.c              |     5 +-
 drivers/staging/media/hantro/hantro_g1_mpeg2_dec.c |     5 +
 drivers/staging/media/imx/imx-media-csc-scaler.c   |     1 +
 drivers/staging/media/meson/vdec/vdec.c            |     2 +-
 drivers/staging/octeon/ethernet-tx.c               |     2 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |    13 -
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |     9 +-
 drivers/staging/rtl8723bs/core/rtw_pwrctrl.c       |     6 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          |    76 +-
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c       |     4 +-
 drivers/staging/rtl8723bs/hal/hal_com.c            |    20 +-
 drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c  |    16 +-
 drivers/staging/rtl8723bs/hal/sdio_halinit.c       |     8 +-
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |     7 +
 drivers/staging/rtl8723bs/include/drv_types.h      |    41 -
 drivers/staging/rtl8723bs/include/recv_osdep.h     |     4 -
 drivers/staging/rtl8723bs/os_dep/os_intfs.c        |    21 +-
 drivers/staging/rtl8723bs/os_dep/recv_linux.c      |    44 -
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |    50 +-
 drivers/staging/sm750fb/sm750.c                    |    10 +-
 drivers/target/target_core_device.c                |    18 +-
 drivers/target/target_core_fabric_lib.c            |    10 +
 drivers/target/target_core_tpg.c                   |    10 +-
 drivers/target/target_core_user.c                  |     5 +
 drivers/thermal/intel/intel_powerclamp.c           |     3 +-
 drivers/thermal/sprd_thermal.c                     |     6 +
 drivers/thermal/ti-soc-thermal/ti-bandgap.c        |    10 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |     4 +
 drivers/thunderbolt/icm.c                          |     6 +-
 drivers/tty/serial/8250/8250_exar.c                |    59 +-
 drivers/tty/serial/8250/8250_lpss.c                |     7 +-
 drivers/tty/serial/amba-pl011.c                    |    30 +-
 drivers/tty/serial/max310x.c                       |    17 +-
 drivers/tty/serial/pch_uart.c                      |     5 +
 drivers/tty/serial/pmac_zilog.c                    |     5 +-
 drivers/tty/serial/sc16is7xx.c                     |     2 +
 drivers/tty/serial/serial_core.c                   |     7 +
 drivers/tty/serial/sifive.c                        |     2 +-
 drivers/uio/uio_sercos3.c                          |     1 +
 drivers/usb/class/cdc-acm.c                        |     6 +-
 drivers/usb/core/driver.c                          |     1 -
 drivers/usb/core/message.c                         |     1 +
 drivers/usb/gadget/composite.c                     |     2 +-
 drivers/usb/gadget/configfs.c                      |     4 +-
 drivers/usb/gadget/function/f_mass_storage.c       |     7 +-
 drivers/usb/gadget/legacy/inode.c                  |    24 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |     4 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |    17 +-
 drivers/usb/gadget/udc/fsl_qe_udc.c                |     8 +-
 drivers/usb/host/pci-quirks.c                      |     1 +
 drivers/usb/host/xhci-dbgtty.c                     |     2 +
 drivers/usb/host/xhci-ring.c                       |     9 +-
 drivers/usb/image/microtek.c                       |     1 +
 drivers/usb/misc/cypress_cy7c63.c                  |     8 +-
 drivers/usb/misc/uss720.c                          |     1 +
 drivers/usb/mon/mon_main.c                         |     3 +
 drivers/usb/mtu3/mtu3_trace.h                      |     4 +-
 drivers/usb/musb/da8xx.c                           |     8 +-
 drivers/usb/musb/musb_host.c                       |    14 +-
 drivers/usb/serial/option.c                        |     5 +
 drivers/usb/serial/sierra.c                        |     3 +-
 drivers/usb/serial/usb_wwan.c                      |     3 +
 drivers/usb/storage/alauda.c                       |    95 +-
 drivers/usb/typec/tcpm/tcpm.c                      |     9 +-
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |    33 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |    11 +-
 drivers/vhost/vdpa.c                               |     8 +-
 drivers/vhost/vringh.c                             |    27 +-
 drivers/video/backlight/lm3630a_bl.c               |     2 +-
 drivers/video/backlight/qcom-wled.c                |    35 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |    24 +-
 drivers/video/fbdev/core/bitblit.c                 |     7 +-
 drivers/video/fbdev/core/fbcon.c                   |    64 +
 drivers/video/fbdev/core/fbcon_rotate.c            |     3 +-
 drivers/video/fbdev/core/fbsysfs.c                 |     1 +
 drivers/video/fbdev/gxt4500.c                      |     1 +
 drivers/video/fbdev/kyro/fbdev.c                   |    19 +-
 drivers/video/fbdev/nvidia/nvidia.c                |     1 +
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |     9 +-
 drivers/video/fbdev/platinumfb.c                   |    35 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |     6 +-
 drivers/video/fbdev/smscufx.c                      |     9 +-
 drivers/video/fbdev/ssd1307fb.c                    |     6 +-
 drivers/video/fbdev/udlfb.c                        |    36 +-
 drivers/video/fbdev/xen-fbfront.c                  |     7 +-
 drivers/virtio/virtio_balloon.c                    |     6 +-
 drivers/virtio/virtio_ring.c                       |     8 +
 drivers/w1/masters/ds2482.c                        |     8 +
 drivers/xen/gntdev-dmabuf.c                        |     4 +-
 drivers/xen/gntdev.c                               |     7 +
 fs/9p/v9fs.c                                       |    16 +-
 fs/9p/vfs_inode.c                                  |     8 +
 fs/affs/bitmap.c                                   |     2 +-
 fs/afs/rxrpc.c                                     |    34 +-
 fs/aio.c                                           |    18 +-
 fs/btrfs/ctree.h                                   |     2 +-
 fs/btrfs/disk-io.c                                 |     6 +-
 fs/btrfs/inode.c                                   |     3 -
 fs/btrfs/ioctl.c                                   |    11 +
 fs/btrfs/qgroup.c                                  |     4 +-
 fs/btrfs/relocation.c                              |    13 +-
 fs/btrfs/sysfs.c                                   |     1 +
 fs/btrfs/volumes.c                                 |     6 +-
 fs/ceph/addr.c                                     |     3 +
 fs/ceph/caps.c                                     |     6 +
 fs/ceph/dir.c                                      |    14 +-
 fs/ceph/inode.c                                    |     3 +-
 fs/ceph/mds_client.c                               |    26 +-
 fs/ceph/mdsmap.c                                   |    12 +-
 fs/ceph/snap.c                                     |     7 +-
 fs/ceph/super.c                                    |     9 +
 fs/ceph/super.h                                    |     1 -
 fs/ceph/xattr.c                                    |    10 +
 fs/cifs/cifsacl.c                                  |     2 +
 fs/cifs/cifsfs.c                                   |    20 +-
 fs/cifs/cifsglob.h                                 |     2 +
 fs/cifs/cifssmb.c                                  |   256 +-
 fs/cifs/connect.c                                  |    42 +-
 fs/cifs/readdir.c                                  |     3 +
 fs/cifs/smb2ops.c                                  |    35 +-
 fs/cifs/smb2pdu.c                                  |    35 +-
 fs/coredump.c                                      |     4 +
 fs/dcache.c                                        |    65 +-
 fs/dlm/debug_fs.c                                  |    37 +
 fs/dlm/dir.c                                       |     2 +-
 fs/dlm/dlm_internal.h                              |    10 +-
 fs/dlm/lock.c                                      |    99 +-
 fs/dlm/lowcomms.c                                  |    25 +-
 fs/dlm/lowcomms.h                                  |     4 +-
 fs/dlm/member.c                                    |     2 +-
 fs/dlm/midcomms.c                                  |    78 +-
 fs/dlm/midcomms.h                                  |     2 +
 fs/dlm/rcom.c                                      |    42 +-
 fs/dlm/requestqueue.c                              |     7 +-
 fs/dlm/util.c                                      |    26 -
 fs/dlm/util.h                                      |     2 -
 fs/eventpoll.c                                     |    18 +-
 fs/exec.c                                          |    30 +-
 fs/exfat/balloc.c                                  |    31 +-
 fs/exfat/dir.c                                     |     8 +-
 fs/ext4/balloc.c                                   |     6 +-
 fs/ext4/ext4.h                                     |     5 +-
 fs/ext4/extents.c                                  |    26 +-
 fs/ext4/indirect.c                                 |    17 +
 fs/ext4/inode.c                                    |    18 +-
 fs/ext4/namei.c                                    |    11 +-
 fs/ext4/super.c                                    |    33 +-
 fs/f2fs/compress.c                                 |    10 +-
 fs/f2fs/data.c                                     |     8 +-
 fs/f2fs/file.c                                     |    23 +-
 fs/f2fs/gc.c                                       |     9 +-
 fs/f2fs/node.c                                     |    58 +-
 fs/f2fs/segment.c                                  |     3 +-
 fs/f2fs/super.c                                    |    39 +-
 fs/fat/fat.h                                       |     2 +-
 fs/fat/fatent.c                                    |    21 +-
 fs/fat/file.c                                      |     3 +-
 fs/fat/inode.c                                     |     2 +
 fs/fat/misc.c                                      |     6 +-
 fs/fat/namei_msdos.c                               |     3 +
 fs/fs-writeback.c                                  |    24 +-
 fs/fs_pin.c                                        |     9 +-
 fs/fuse/file.c                                     |    12 +-
 fs/fuse/virtio_fs.c                                |    80 +-
 fs/gfs2/bmap.c                                     |     2 +-
 fs/gfs2/glops.c                                    |    10 +-
 fs/gfs2/inode.c                                    |     2 +-
 fs/hfs/btree.c                                     |     7 +-
 fs/hfsplus/btree.c                                 |     7 +-
 fs/hfsplus/extents.c                               |     2 +
 fs/hugetlbfs/inode.c                               |     2 +-
 fs/inode.c                                         |    15 +-
 fs/iomap/buffered-io.c                             |     3 +-
 fs/iomap/fiemap.c                                  |     8 +-
 fs/isofs/dir.c                                     |     4 +-
 fs/isofs/inode.c                                   |     2 +
 fs/isofs/isofs.h                                   |    13 +-
 fs/isofs/joliet.c                                  |    27 +-
 fs/isofs/namei.c                                   |     3 +-
 fs/isofs/rock.c                                    |    11 +-
 fs/jbd2/journal.c                                  |     2 +-
 fs/ksmbd/Kconfig                                   |     1 +
 fs/ksmbd/auth.c                                    |     3 +-
 fs/ksmbd/connection.c                              |    22 +
 fs/ksmbd/mgmt/user_session.c                       |     4 +-
 fs/ksmbd/misc.c                                    |     8 +-
 fs/ksmbd/oplock.c                                  |     9 +-
 fs/ksmbd/server.c                                  |    21 +
 fs/ksmbd/smb2pdu.c                                 |   362 +-
 fs/ksmbd/smb2pdu.h                                 |     1 +
 fs/ksmbd/smbacl.c                                  |    37 +-
 fs/ksmbd/transport_ipc.c                           |    16 +-
 fs/ksmbd/transport_rdma.c                          |     1 -
 fs/ksmbd/transport_tcp.c                           |    15 +
 fs/ksmbd/vfs.c                                     |    79 +-
 fs/ksmbd/vfs.h                                     |     1 +
 fs/lockd/svclock.c                                 |     2 +
 fs/namespace.c                                     |     2 +-
 fs/nfs/blocklayout/blocklayout.h                   |     5 -
 fs/nfs/blocklayout/rpc_pipefs.c                    |    79 +-
 fs/nfs/callback_xdr.c                              |     9 +-
 fs/nfs/dir.c                                       |    13 +-
 fs/nfs/filelayout/filelayout.c                     |    13 +-
 fs/nfs/filelayout/filelayoutdev.c                  |    17 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |    25 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |    17 +-
 fs/nfs/internal.h                                  |     1 +
 fs/nfs/netns.h                                     |     5 +-
 fs/nfs/nfs3proc.c                                  |     8 +
 fs/nfs/nfs4_fs.h                                   |     2 +
 fs/nfs/nfs4proc.c                                  |    13 +
 fs/nfs/nfs4state.c                                 |    38 +-
 fs/nfs/pnfs.c                                      |     2 +
 fs/nfs/pnfs.h                                      |     1 +
 fs/nfs/pnfs_nfs.c                                  |    21 +-
 fs/nfs/proc.c                                      |     8 +
 fs/nfsd/blocklayout.c                              |     4 +-
 fs/nfsd/flexfilelayout.c                           |    24 +-
 fs/nfsd/flexfilelayoutxdr.c                        |     4 +-
 fs/nfsd/flexfilelayoutxdr.h                        |     5 +-
 fs/nfsd/nfs4idmap.c                                |     4 +-
 fs/nfsd/nfs4layouts.c                              |     7 +-
 fs/nfsd/nfs4proc.c                                 |     6 +-
 fs/nfsd/nfs4recover.c                              |    87 +-
 fs/nfsd/nfs4state.c                                |    40 +-
 fs/nfsd/nfs4xdr.c                                  |    26 +-
 fs/nfsd/nfsctl.c                                   |    12 +-
 fs/nfsd/pnfs.h                                     |     4 +-
 fs/nfsd/xdr4.h                                     |     1 +
 fs/nilfs2/dir.c                                    |    34 +
 fs/nilfs2/gcinode.c                                |    24 +-
 fs/nilfs2/inode.c                                  |    22 +-
 fs/nilfs2/ioctl.c                                  |     2 +-
 fs/nilfs2/mdt.c                                    |     6 +-
 fs/nilfs2/namei.c                                  |     8 +-
 fs/nilfs2/page.c                                   |    50 +-
 fs/nilfs2/page.h                                   |     4 +-
 fs/nilfs2/recovery.c                               |    49 +-
 fs/nilfs2/segbuf.c                                 |    12 +-
 fs/nilfs2/segment.c                                |    54 +-
 fs/nilfs2/sysfs.c                                  |     5 +-
 fs/nilfs2/the_nilfs.c                              |    46 +-
 fs/notify/fanotify/fanotify.c                      |     7 +-
 fs/notify/fanotify/fanotify.h                      |    21 +-
 fs/notify/inotify/inotify_fsnotify.c               |     2 +-
 fs/ntfs3/attrib.c                                  |     2 +-
 fs/ntfs3/dir.c                                     |     5 +
 fs/ntfs3/frecord.c                                 |    17 +-
 fs/ntfs3/fslog.c                                   |    29 +-
 fs/ntfs3/fsntfs.c                                  |     3 +
 fs/ntfs3/index.c                                   |    14 +-
 fs/ntfs3/inode.c                                   |    19 +-
 fs/ntfs3/namei.c                                   |     9 +-
 fs/ntfs3/super.c                                   |     2 +-
 fs/ntfs3/xattr.c                                   |    27 +-
 fs/ocfs2/alloc.c                                   |    18 +-
 fs/ocfs2/cluster/heartbeat.c                       |    96 +-
 fs/ocfs2/cluster/netdebug.c                        |     4 +
 fs/ocfs2/cluster/nodemanager.c                     |    10 +-
 fs/ocfs2/cluster/quorum.c                          |     7 +-
 fs/ocfs2/cluster/quorum.h                          |     1 +
 fs/ocfs2/cluster/tcp.c                             |    13 +-
 fs/ocfs2/dcache.h                                  |     5 +-
 fs/ocfs2/dlm/dlmconvert.c                          |    10 +-
 fs/ocfs2/dlm/dlmdebug.c                            |     5 +
 fs/ocfs2/dlm/dlmlock.c                             |     8 +-
 fs/ocfs2/dlm/dlmmaster.c                           |    70 +-
 fs/ocfs2/dlmglue.c                                 |    97 +-
 fs/ocfs2/dlmglue.h                                 |     5 +-
 fs/ocfs2/export.c                                  |    10 +-
 fs/ocfs2/file.c                                    |   102 +-
 fs/ocfs2/filecheck.c                               |     7 +-
 fs/ocfs2/inode.c                                   |     5 +-
 fs/ocfs2/journal.c                                 |    18 +-
 fs/ocfs2/journal.h                                 |     2 +-
 fs/ocfs2/move_extents.c                            |    62 +-
 fs/ocfs2/namei.c                                   |     6 +-
 fs/ocfs2/ocfs2.h                                   |     2 +-
 fs/ocfs2/quota_local.c                             |    36 +-
 fs/ocfs2/refcounttree.c                            |    15 +-
 fs/ocfs2/super.c                                   |    20 +-
 fs/ocfs2/xattr.c                                   |   414 +-
 fs/ocfs2/xattr.h                                   |    12 +-
 fs/overlayfs/copy_up.c                             |    69 +-
 fs/overlayfs/dir.c                                 |    18 +-
 fs/overlayfs/export.c                              |     4 +-
 fs/overlayfs/file.c                                |     4 +-
 fs/overlayfs/inode.c                               |    24 +-
 fs/overlayfs/namei.c                               |    52 +-
 fs/overlayfs/overlayfs.h                           |    83 +-
 fs/overlayfs/ovl_entry.h                           |     5 +
 fs/overlayfs/readdir.c                             |    68 +-
 fs/overlayfs/super.c                               |    17 +-
 fs/overlayfs/util.c                                |    31 +-
 fs/proc/array.c                                    |     2 +-
 fs/proc/base.c                                     |     9 +-
 fs/proc/generic.c                                  |    11 +-
 fs/proc/internal.h                                 |    15 +-
 fs/proc/namespaces.c                               |     3 +-
 fs/proc/proc_sysctl.c                              |    17 +-
 fs/pstore/ram.c                                    |     1 +
 fs/pstore/ram_core.c                               |     6 +
 fs/read_write.c                                    |     8 +-
 fs/romfs/super.c                                   |     8 +
 fs/signalfd.c                                      |    29 +-
 fs/splice.c                                        |    97 +-
 fs/stat.c                                          |     6 +-
 fs/udf/balloc.c                                    |    11 +-
 fs/udf/inode.c                                     |    47 +-
 fs/udf/super.c                                     |    45 +-
 fs/udf/truncate.c                                  |     7 +-
 fs/ufs/cylinder.c                                  |    31 +-
 fs/ufs/dir.c                                       |     2 +-
 fs/userfaultfd.c                                   |    14 +-
 fs/verity/measure.c                                |    10 +
 fs/verity/open.c                                   |    38 +-
 fs/verity/read_metadata.c                          |    14 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |    13 +
 fs/xfs/libxfs/xfs_bmap.c                           |    12 +
 fs/xfs/libxfs/xfs_bmap.h                           |    10 +-
 fs/xfs/libxfs/xfs_btree.c                          |     4 +-
 fs/xfs/libxfs/xfs_da_btree.c                       |    13 +
 fs/xfs/scrub/attr.c                                |    18 +
 fs/xfs/scrub/bmap.c                                |     7 +
 fs/xfs/scrub/btree.c                               |    16 +-
 fs/xfs/scrub/common.c                              |     7 +-
 fs/xfs/scrub/dabtree.c                             |    27 +-
 fs/xfs/scrub/dir.c                                 |    61 +-
 fs/xfs/scrub/fscounters.c                          |     7 +-
 fs/xfs/scrub/quota.c                               |     8 +-
 fs/xfs/scrub/refcount.c                            |    17 +-
 fs/xfs/xfs_discard.c                               |     5 +-
 fs/xfs/xfs_inode_item_recover.c                    |    20 +-
 fs/xfs/xfs_ioctl32.c                               |     4 +-
 fs/xfs/xfs_iomap.c                                 |     8 +
 fs/xfs/xfs_pnfs.c                                  |    30 +-
 include/acpi/acpi_bus.h                            |     2 +-
 include/asm-generic/bitops/le.h                    |    18 +-
 include/asm-generic/tlb.h                          |     3 +-
 include/drm/ttm/ttm_bo_api.h                       |     4 +-
 include/kvm/arm_vgic.h                             |     1 +
 include/linux/acpi.h                               |    24 +-
 include/linux/assoc_array_priv.h                   |     2 +-
 include/linux/bpf.h                                |    23 +
 include/linux/can/can-ml.h                         |     3 +
 include/linux/clk-provider.h                       |    22 +-
 include/linux/damon.h                              |     6 +
 include/linux/dcache.h                             |     3 +
 include/linux/device.h                             |     5 +
 include/linux/device/bus.h                         |     3 -
 include/linux/fault-inject.h                       |    10 +-
 include/linux/firewire.h                           |     1 -
 include/linux/fs.h                                 |     4 +-
 include/linux/hiddev.h                             |     2 +
 include/linux/i2c.h                                |    17 +-
 include/linux/interrupt.h                          |     3 +
 include/linux/irqchip/arm-gic-v3.h                 |     3 +-
 include/linux/libata.h                             |     6 +
 include/linux/lockdep.h                            |    14 +
 include/linux/lockdep_types.h                      |     1 +
 include/linux/mfd/da9150/core.h                    |     1 +
 include/linux/mfd/twl.h                            |    55 -
 include/linux/mmu_notifier.h                       |    10 +-
 include/linux/mtd/spinand.h                        |     2 +-
 include/linux/nvme.h                               |    10 +
 include/linux/pci.h                                |     3 +
 include/linux/pgtable.h                            |     2 +
 include/linux/pm_wakeirq.h                         |    10 +-
 include/linux/pm_wakeup.h                          |    48 +-
 include/linux/proc_fs.h                            |     2 +
 include/linux/regulator/driver.h                   |    36 +
 include/linux/rpmsg.h                              |    10 +
 include/linux/sched/signal.h                       |     6 +-
 include/linux/seq_buf.h                            |    27 +-
 include/linux/shmem_fs.h                           |    15 +-
 include/linux/skbuff.h                             |     8 +
 include/linux/soc/ti/k3-ringacc.h                  |    31 +-
 include/linux/spi/rspi.h                           |    18 -
 include/linux/timer.h                              |     8 -
 include/linux/trace_seq.h                          |     2 +
 include/linux/user_namespace.h                     |    36 +-
 include/linux/watch_queue.h                        |     6 +-
 include/math-emu/op-common.h                       |    23 +-
 include/math-emu/soft-fp.h                         |     8 +
 include/media/v4l2-ctrls.h                         |     6 +
 include/net/addrconf.h                             |     3 +
 include/net/bluetooth/bluetooth.h                  |     4 +-
 include/net/dst.h                                  |    16 +-
 include/net/espintcp.h                             |     5 +-
 include/net/inet_frag.h                            |     9 +
 include/net/ip_tunnels.h                           |     3 +
 include/net/ip_vs.h                                |    50 +-
 include/net/mptcp.h                                |     9 +
 include/net/netfilter/nf_conntrack_seqadj.h        |     1 +
 include/net/netns/can.h                            |     2 +-
 include/net/netns/ipv6.h                           |     4 +
 include/net/sch_generic.h                          |     4 +
 include/net/sctp/sm.h                              |     1 +
 include/sound/control.h                            |     4 +-
 include/sound/core.h                               |    27 +-
 include/sound/hwdep.h                              |     1 +
 include/sound/pcm.h                                |     4 +-
 include/sound/pcm_oss.h                            |     1 +
 include/sound/soc-component.h                      |     2 +-
 include/trace/events/thermal.h                     |     4 +-
 include/trace/misc/nfs.h                           |    10 +
 include/uapi/linux/firewire-cdev.h                 |     4 +-
 include/uapi/linux/rtc.h                           |     4 +-
 include/uapi/rdma/rdma_user_rxe.h                  |    10 +-
 include/video/maxinefb.h                           |     4 +-
 init/Kconfig                                       |     4 +-
 init/main.c                                        |    14 +-
 io_uring/io-wq.c                                   |     8 +-
 io_uring/io_uring.c                                |     6 +-
 ipc/mqueue.c                                       |     7 +
 kernel/bpf/bpf_iter.c                              |     7 +
 kernel/bpf/bpf_lsm.c                               |     4 +-
 kernel/bpf/btf.c                                   |    27 +-
 kernel/bpf/queue_stack_maps.c                      |     3 +
 kernel/cgroup/cgroup.c                             |     2 +-
 kernel/cgroup/cpuset.c                             |    17 +-
 kernel/cpu_pm.c                                    |     9 +-
 kernel/debug/gdbstub.c                             |    55 +-
 kernel/events/core.c                               |     9 +
 kernel/fork.c                                      |    41 +-
 kernel/irq/internals.h                             |     2 +
 kernel/irq/irqdomain.c                             |     4 +-
 kernel/irq/manage.c                                |    86 +-
 kernel/kcov.c                                      |     8 +
 kernel/kcsan/core.c                                |     7 +-
 kernel/kexec_file.c                                |     4 +-
 kernel/locking/lockdep.c                           |    28 +-
 kernel/nsproxy.c                                   |     2 +-
 kernel/profile.c                                   |     2 +-
 kernel/rcu/rcutorture.c                            |     2 +-
 kernel/reboot.c                                    |     4 +-
 kernel/resource.c                                  |    11 +-
 kernel/sched/cpufreq_schedutil.c                   |    14 +-
 kernel/sched/fair.c                                |     7 +-
 kernel/seccomp.c                                   |     7 +-
 kernel/signal.c                                    |    40 +-
 kernel/sys.c                                       |     5 +-
 kernel/sysctl.c                                    |    11 -
 kernel/time/itimer.c                               |     2 +-
 kernel/time/namespace.c                            |     2 +-
 kernel/time/posix-cpu-timers.c                     |     4 +-
 kernel/time/posix-stubs.c                          |     4 +-
 kernel/time/posix-timers.c                         |    18 +-
 kernel/time/timeconv.c                             |     6 +-
 kernel/time/timekeeping.c                          |     3 +-
 kernel/time/timer.c                                |    55 +-
 kernel/trace/bpf_trace.c                           |    16 +-
 kernel/trace/trace.c                               |    21 +-
 kernel/trace/trace_events_hist.c                   |    34 +-
 kernel/trace/trace_events_synth.c                  |    10 +
 kernel/trace/trace_seq.c                           |     6 +-
 kernel/trace/trace_synth.h                         |     1 +
 kernel/ucount.c                                    |    62 +-
 kernel/user_namespace.c                            |    10 +-
 kernel/watch_queue.c                               |     2 +-
 lib/842/842_decompress.c                           |     7 +-
 lib/assoc_array.c                                  |   377 +-
 lib/cmdline.c                                      |    13 +-
 lib/cmdline_kunit.c                                |    39 +
 lib/debugobjects.c                                 |    15 +-
 lib/decompress_bunzip2.c                           |     6 +-
 lib/decompress_unlz4.c                             |     4 +
 lib/fault-inject.c                                 |     7 +-
 lib/klist.c                                        |    16 +-
 lib/kobject_uevent.c                               |     8 +-
 lib/raid6/avx2.c                                   |     6 +
 lib/raid6/avx512.c                                 |     6 +
 lib/raid6/recov_avx2.c                             |     2 +
 lib/raid6/recov_avx512.c                           |     2 +
 lib/seq_buf.c                                      |    52 +-
 lib/test_hmm.c                                     |     2 +
 mm/damon/core.c                                    |     5 +-
 mm/filemap.c                                       |    98 +-
 mm/gup.c                                           |     9 +-
 mm/gup_test.c                                      |    17 +-
 mm/huge_memory.c                                   |     8 +-
 mm/hugetlb.c                                       |    24 +-
 mm/internal.h                                      |     3 +
 mm/khugepaged.c                                    |     2 +-
 mm/ksm.c                                           |    31 +-
 mm/madvise.c                                       |    18 +-
 mm/memfd.c                                         |     2 +
 mm/memory.c                                        |    35 +-
 mm/mempolicy.c                                     |     6 +-
 mm/migrate.c                                       |     2 +-
 mm/mlock.c                                         |     2 +-
 mm/mmap.c                                          |    86 +-
 mm/mmu_notifier.c                                  |    24 +-
 mm/mremap.c                                        |    17 +-
 mm/nommu.c                                         |     6 +-
 mm/page_alloc.c                                    |    16 +-
 mm/page_vma_mapped.c                               |    22 +-
 mm/rmap.c                                          |    15 +-
 mm/shmem.c                                         |    13 +-
 mm/swapfile.c                                      |     4 +-
 mm/util.c                                          |    13 +
 net/9p/trans_virtio.c                              |     5 +
 net/9p/trans_xen.c                                 |    14 +-
 net/batman-adv/bat_iv_ogm.c                        |     9 +
 net/batman-adv/distributed-arp-table.c             |     1 +
 net/batman-adv/main.c                              |    12 +-
 net/batman-adv/main.h                              |     3 -
 net/batman-adv/tp_meter.c                          |     2 +-
 net/batman-adv/translation-table.c                 |   145 +-
 net/batman-adv/types.h                             |     8 +-
 net/bluetooth/6lowpan.c                            |     4 +-
 net/bluetooth/hci_core.c                           |   128 +-
 net/bluetooth/hci_debugfs.c                        |   132 +
 net/bluetooth/hci_debugfs.h                        |     5 +
 net/bluetooth/l2cap_core.c                         |    95 +-
 net/bluetooth/l2cap_sock.c                         |     4 +
 net/bluetooth/selftest.c                           |     1 +
 net/bluetooth/smp.c                                |     1 +
 net/bridge/netfilter/ebtables.c                    |    12 +-
 net/can/af_can.c                                   |    51 +-
 net/can/bcm.c                                      |    50 +-
 net/can/gw.c                                       |     7 +-
 net/can/isotp.c                                    |   228 +-
 net/can/proc.c                                     |    69 +-
 net/can/raw.c                                      |   136 +-
 net/ceph/messenger_v1.c                            |     8 +-
 net/ceph/mon_client.c                              |     2 +-
 net/ceph/osd_client.c                              |    13 +-
 net/ceph/osdmap.c                                  |    18 +-
 net/core/bpf_sk_storage.c                          |     9 +-
 net/core/dev.c                                     |     9 +-
 net/core/dst.c                                     |     2 +-
 net/core/filter.c                                  |    50 +-
 net/core/selftests.c                               |     2 +-
 net/core/skbuff.c                                  |    28 +-
 net/core/sock.c                                    |     9 +-
 net/dcb/dcbnl.c                                    |     2 +
 net/ipv4/af_inet.c                                 |     3 +
 net/ipv4/bpf_tcp_ca.c                              |     9 +-
 net/ipv4/gre_offload.c                             |     2 +-
 net/ipv4/icmp.c                                    |     8 +-
 net/ipv4/inet_connection_sock.c                    |    16 +-
 net/ipv4/inet_fragment.c                           |     4 +
 net/ipv4/inet_hashtables.c                         |     5 +-
 net/ipv4/ip_fragment.c                             |    10 +-
 net/ipv4/ip_tunnel.c                               |    14 +-
 net/ipv4/ipmr.c                                    |    11 +-
 net/ipv4/metrics.c                                 |     5 +
 net/ipv4/netfilter/nf_reject_ipv4.c                |    11 +-
 net/ipv4/route.c                                   |     7 +-
 net/ipv4/syncookies.c                              |     2 +
 net/ipv4/tcp_bic.c                                 |    14 +-
 net/ipv4/tcp_cong.c                                |     4 +-
 net/ipv4/tcp_hybla.c                               |    16 +-
 net/ipv4/tcp_input.c                               |     4 +-
 net/ipv4/tcp_metrics.c                             |    20 +-
 net/ipv4/tcp_output.c                              |     2 +-
 net/ipv6/addrconf.c                                |    58 +-
 net/ipv6/calipso.c                                 |     6 +-
 net/ipv6/datagram.c                                |     4 +
 net/ipv6/inet6_hashtables.c                        |     4 +-
 net/ipv6/ip6_offload.c                             |     4 +
 net/ipv6/ip6_output.c                              |    27 +-
 net/ipv6/ip6mr.c                                   |    11 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |     2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |    13 +-
 net/ipv6/raw.c                                     |     3 +
 net/ipv6/reassembly.c                              |     1 +
 net/ipv6/route.c                                   |    20 +-
 net/ipv6/sit.c                                     |     4 +-
 net/l2tp/l2tp_core.c                               |    47 +-
 net/l2tp/l2tp_core.h                               |     5 +-
 net/l2tp/l2tp_debugfs.c                            |     4 +-
 net/l2tp/l2tp_netlink.c                            |     9 +-
 net/l2tp/l2tp_ppp.c                                |     7 +-
 net/mac80211/debugfs.c                             |     2 +-
 net/mac80211/ibss.c                                |     4 +-
 net/mac80211/ieee80211_i.h                         |     2 +-
 net/mac80211/main.c                                |     2 +
 net/mac80211/mesh_pathtbl.c                        |    17 +-
 net/mac80211/rx.c                                  |     1 +
 net/mac80211/tdls.c                                |     3 +-
 net/mac80211/tx.c                                  |    57 +-
 net/mptcp/options.c                                |     9 +-
 net/mptcp/pm_netlink.c                             |     1 +
 net/mptcp/protocol.h                               |    10 +-
 net/mptcp/subflow.c                                |    48 +-
 net/mptcp/token.c                                  |    65 +-
 net/mptcp/token_test.c                             |     4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |     8 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    38 +-
 net/netfilter/ipvs/ip_vs_dh.c                      |    16 +-
 net/netfilter/ipvs/ip_vs_fo.c                      |     2 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |     4 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |     8 +-
 net/netfilter/ipvs/ip_vs_lc.c                      |     2 +-
 net/netfilter/ipvs/ip_vs_mh.c                      |     2 +-
 net/netfilter/ipvs/ip_vs_nq.c                      |     2 +-
 net/netfilter/ipvs/ip_vs_ovf.c                     |     2 +-
 net/netfilter/ipvs/ip_vs_rr.c                      |     2 +-
 net/netfilter/ipvs/ip_vs_sed.c                     |     4 +-
 net/netfilter/ipvs/ip_vs_sh.c                      |     2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |    23 +-
 net/netfilter/ipvs/ip_vs_twos.c                    |     4 +-
 net/netfilter/ipvs/ip_vs_wlc.c                     |     4 +-
 net/netfilter/ipvs/ip_vs_wrr.c                     |     2 +-
 net/netfilter/nf_conntrack_core.c                  |     5 +
 net/netfilter/nf_conntrack_netlink.c               |     8 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |     6 +-
 net/netfilter/nf_conntrack_seqadj.c                |    17 +
 net/netfilter/nf_flow_table_ip.c                   |     4 +-
 net/netfilter/nf_synproxy_core.c                   |     4 +-
 net/netfilter/nf_tables_api.c                      |     1 +
 net/netfilter/nft_compat.c                         |    15 +
 net/netfilter/nft_meta.c                           |     6 +-
 net/netfilter/nft_rt.c                             |     6 +-
 net/netfilter/nft_xfrm.c                           |     9 +-
 net/netfilter/xt_dccp.c                            |     2 +-
 net/netlink/af_netlink.c                           |    12 +-
 net/openvswitch/actions.c                          |     9 +
 net/packet/af_packet.c                             |    12 +-
 net/rds/af_rds.c                                   |    31 +-
 net/rds/bind.c                                     |     4 +-
 net/rds/ib_cm.c                                    |     6 +-
 net/rds/ib_rdma.c                                  |     4 +-
 net/rds/ib_recv.c                                  |    13 +-
 net/rds/message.c                                  |    26 +
 net/rds/rdma.c                                     |    63 +-
 net/rds/rdma_transport.c                           |     7 +-
 net/rds/rds.h                                      |    18 +-
 net/rds/recv.c                                     |    17 +-
 net/rds/send.c                                     |    27 +-
 net/rds/tcp.c                                      |     9 +-
 net/rds/tcp_recv.c                                 |     4 +-
 net/rxrpc/sendmsg.c                                |    57 +-
 net/sched/act_api.c                                |    21 +-
 net/sched/act_ife.c                                |     4 +
 net/sched/cls_api.c                                |     9 +-
 net/sched/cls_flower.c                             |    72 +-
 net/sched/sch_etf.c                                |     1 +
 net/sched/sch_generic.c                            |    51 +-
 net/sched/sch_gred.c                               |    16 +-
 net/sched/sch_netem.c                              |     5 +-
 net/sched/sch_qfq.c                                |     3 +
 net/sched/sch_taprio.c                             |    11 +-
 net/sched/sch_teql.c                               |    14 +-
 net/sctp/associola.c                               |     4 +
 net/sctp/endpointola.c                             |     4 +
 net/sctp/sm_make_chunk.c                           |    14 +-
 net/sctp/socket.c                                  |    83 +-
 net/smc/smc_rx.c                                   |    39 +-
 net/smc/smc_tx.c                                   |     7 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |    29 +-
 net/sunrpc/svc.c                                   |     9 +-
 net/sunrpc/svc_xprt.c                              |    16 +-
 net/sunrpc/svcauth_unix.c                          |     7 +
 net/sunrpc/svcsock.c                               |     3 +
 net/sunrpc/xprtrdma/rpc_rdma.c                     |    27 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |     3 +-
 net/sunrpc/xprtrdma/verbs.c                        |     9 +-
 net/tipc/bearer.c                                  |     4 +
 net/tipc/group.c                                   |    19 +-
 net/tipc/node.c                                    |     2 +-
 net/tipc/socket.c                                  |    12 +-
 net/tls/tls_device.c                               |    21 +-
 net/unix/garbage.c                                 |    20 +-
 net/unix/sysctl_net_unix.c                         |     4 +-
 net/wireless/nl80211.c                             |    10 +-
 net/wireless/reg.c                                 |     3 +
 net/wireless/wext-sme.c                            |     6 +-
 net/xfrm/espintcp.c                                |    41 +-
 net/xfrm/xfrm_interface_core.c                     |     8 +
 net/xfrm/xfrm_policy.c                             |    26 +-
 scripts/checkkconfigsymbols.py                     |     2 +-
 scripts/checkpatch.pl                              |     2 +
 scripts/extract-cert.c                             |   144 +-
 scripts/kconfig/conf.c                             |    33 +-
 scripts/kconfig/symbol.c                           |    71 +-
 scripts/kconfig/tests/conftest.py                  |     9 +-
 .../kconfig/tests/randconfig_probability/Kconfig   |    12 +
 .../tests/randconfig_probability/__init__.py       |   130 +
 scripts/kconfig/tests/savedefconfig_range/Kconfig  |    60 +
 .../kconfig/tests/savedefconfig_range/__init__.py  |     8 +
 scripts/kconfig/tests/savedefconfig_range/config   |     7 +
 .../tests/savedefconfig_range/expected_defconfig   |     0
 scripts/link-vmlinux.sh                            |    19 +-
 scripts/mod/modpost.c                              |     4 +-
 scripts/sign-file.c                                |   132 +-
 scripts/ssl-common.h                               |    32 +
 security/apparmor/apparmorfs.c                     |    15 +-
 security/apparmor/include/label.h                  |     6 +-
 security/apparmor/include/policy_ns.h              |    16 +
 security/apparmor/label.c                          |    15 +-
 security/apparmor/policy.c                         |    16 +
 security/apparmor/policy_ns.c                      |     8 +-
 security/integrity/ima/ima_template.c              |     5 +
 security/landlock/fs.c                             |    10 +-
 security/selinux/netlabel.c                        |     1 +
 sound/core/compress_offload.c                      |    12 +-
 sound/core/control.c                               |     4 +
 sound/core/hwdep.c                                 |    14 +-
 sound/core/init.c                                  |    95 +-
 sound/core/jack.c                                  |     2 +-
 sound/core/misc.c                                  |    27 +
 sound/core/oss/mixer_oss.c                         |    36 +-
 sound/core/oss/pcm_oss.c                           |    12 +
 sound/core/pcm.c                                   |    14 +-
 sound/core/pcm_compat.c                            |     4 +-
 sound/core/pcm_lib.c                               |     2 +-
 sound/core/pcm_local.h                             |     6 +
 sound/core/pcm_native.c                            |   109 +-
 sound/core/rawmidi.c                               |     3 +
 sound/core/seq/oss/seq_oss_device.h                |     1 +
 sound/core/seq/oss/seq_oss_event.c                 |     3 +
 sound/core/seq/oss/seq_oss_init.c                  |     2 +
 sound/core/vmaster.c                               |     7 +-
 sound/drivers/aloop.c                              |    48 +-
 sound/drivers/mpu401/mpu401_uart.c                 |     8 +-
 sound/isa/sb/emu8000_patch.c                       |    13 -
 sound/mips/sgio2audio.c                            |    13 +-
 sound/oss/dmasound/dmasound_q40.c                  |    65 +-
 sound/pci/cs46xx/dsp_spos.c                        |     4 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |     3 +-
 sound/pci/emu10k1/emu10k1_patch.c                  |    85 +-
 sound/pci/hda/hda_codec.c                          |     8 +-
 sound/pci/hda/hda_eld.c                            |     6 +-
 sound/pci/hda/hda_intel.c                          |    19 +-
 sound/pci/hda/hda_jack.c                           |     9 +-
 sound/pci/hda/hda_sysfs.c                          |     4 +
 sound/pci/hda/patch_conexant.c                     |    17 +-
 sound/pci/hda/patch_hdmi.c                         |     3 +-
 sound/pci/hda/patch_realtek.c                      |    40 +-
 sound/pci/hda/patch_via.c                          |     1 +
 sound/pci/via82xx.c                                |    11 +-
 sound/sh/aica.c                                    |     2 +-
 sound/soc/amd/raven/acp3x-pcm-dma.c                |     4 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |     2 +-
 sound/soc/amd/vangogh/acp5x-pcm-dma.c              |     2 +-
 sound/soc/atmel/atmel-i2s.c                        |    43 +-
 sound/soc/atmel/atmel-pcm-pdc.c                    |     2 +
 sound/soc/codecs/adau17x1.c                        |     4 +-
 sound/soc/codecs/ak4642.c                          |     3 +-
 sound/soc/codecs/arizona-jack.c                    |     1 +
 sound/soc/codecs/cs42l56.c                         |     1 -
 sound/soc/codecs/da732x.c                          |     2 +-
 sound/soc/codecs/hdac_hda.c                        |    16 +
 sound/soc/codecs/hdac_hdmi.c                       |    10 +-
 sound/soc/codecs/max98926.c                        |     2 +-
 sound/soc/codecs/mt6359-accdet.c                   |    50 +-
 sound/soc/codecs/nau8540.c                         |     4 +-
 sound/soc/codecs/rt1011.c                          |     4 +-
 sound/soc/codecs/rt1016.c                          |     4 +-
 sound/soc/codecs/rt1305.c                          |     4 +-
 sound/soc/codecs/rt1308.c                          |     4 +-
 sound/soc/codecs/rt5616.c                          |     3 +-
 sound/soc/codecs/rt5659.c                          |    10 +-
 sound/soc/codecs/rt5660.c                          |     4 +-
 sound/soc/codecs/rt5665.c                          |     4 +-
 sound/soc/codecs/rt5682-sdw.c                      |     3 +-
 sound/soc/codecs/rt711-sdca-sdw.c                  |     6 +-
 sound/soc/codecs/rt711-sdw.c                       |     8 +-
 sound/soc/codecs/sta32x.c                          |    20 +-
 sound/soc/codecs/sta350.c                          |    20 +-
 sound/soc/codecs/tlv320aic26.c                     |     6 +
 sound/soc/codecs/tlv320aic32x4-clk.c               |    35 +-
 sound/soc/codecs/tlv320aic32x4.h                   |     5 +-
 sound/soc/codecs/wcd-mbhc-v2.c                     |     8 +-
 sound/soc/codecs/wcd9335.c                         |    12 +
 sound/soc/codecs/wm5100.c                          |     2 +-
 sound/soc/codecs/wm8510.c                          |     2 +-
 sound/soc/codecs/wm8737.c                          |     8 +-
 sound/soc/codecs/wm8750.c                          |     2 +-
 sound/soc/codecs/wm8955.c                          |     2 +-
 sound/soc/codecs/wm8983.c                          |     2 +-
 sound/soc/codecs/wm8985.c                          |     2 +-
 sound/soc/codecs/wm8990.c                          |    10 +-
 sound/soc/codecs/wm8991.c                          |    10 +-
 sound/soc/codecs/wm8994.c                          |   162 +-
 sound/soc/codecs/wm8994.h                          |     2 +
 sound/soc/codecs/wm_hubs.c                         |     2 +-
 sound/soc/fsl/fsl_asrc.c                           |     8 +-
 sound/soc/fsl/fsl_asrc_dma.c                       |     5 +
 sound/soc/fsl/imx-pcm-rpmsg.c                      |     2 +-
 sound/soc/intel/atom/sst/sst_acpi.c                |    14 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |    17 +
 sound/soc/mediatek/common/mtk-afe-fe-dai.c         |     8 +-
 sound/soc/mediatek/mt6797/mt6797-afe-clk.c         |    14 +-
 sound/soc/mediatek/mt8183/mt8183-afe-clk.c         |    22 +-
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c         |   143 +-
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c        |    90 +-
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |    10 +-
 sound/soc/mediatek/mt8192/mt8192-dai-adda.c        |    44 +-
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c         |    20 +-
 .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |    39 +-
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c         |   357 +-
 sound/soc/mediatek/mt8195/mt8195-afe-clk.h         |    11 +
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c         |   109 +-
 sound/soc/mediatek/mt8195/mt8195-dai-adda.c        |    17 +-
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c        |   274 +-
 sound/soc/mediatek/mt8195/mt8195-dai-pcm.c         |    26 +-
 sound/soc/qcom/qdsp6/q6afe.c                       |    10 +-
 sound/soc/rockchip/rockchip_i2s.c                  |     4 +-
 sound/soc/soc-ac97.c                               |     4 +-
 sound/soc/soc-component.c                          |     2 +-
 sound/soc/soc-link.c                               |    10 +-
 sound/soc/soc-ops.c                                |    10 +-
 sound/soc/stm/stm32_i2s.c                          |    27 +-
 sound/soc/ti/davinci-mcasp.c                       |     1 +
 sound/soc/xilinx/xlnx_formatter_pcm.c              |    18 +-
 sound/synth/emux/emux.c                            |    16 +-
 sound/synth/emux/emux_synth.c                      |     9 +-
 sound/synth/emux/soundfont.c                       |    71 +-
 sound/usb/6fire/control.c                          |     7 +
 sound/usb/bcd2000/bcd2000.c                        |    62 +-
 sound/usb/caiaq/device.c                           |     3 +-
 sound/usb/caiaq/input.c                            |    31 +-
 sound/usb/endpoint.c                               |    40 +-
 sound/usb/line6/capture.c                          |    49 +-
 sound/usb/line6/capture.h                          |     2 +-
 sound/usb/line6/pcm.c                              |    20 +-
 sound/usb/line6/playback.c                         |    31 +-
 sound/usb/midi.c                                   |    26 +-
 sound/usb/mixer.c                                  |   116 +-
 sound/usb/mixer.h                                  |     5 +-
 sound/usb/mixer_maps.c                             |     4 +
 sound/usb/mixer_quirks.c                           |     2 +-
 sound/usb/mixer_us16x08.c                          |     3 +-
 sound/usb/pcm.c                                    |    21 +-
 sound/usb/quirks-table.h                           |    24 +
 sound/usb/quirks.c                                 |     2 +
 sound/usb/usx2y/us122l.c                           |    27 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |     5 +
 sound/usb/usx2y/usb_stream.c                       |    15 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |    46 +-
 sound/usb/usx2y/usx2yhwdeppcm.c                    |     2 +-
 sound/x86/intel_hdmi_audio.c                       |     9 +-
 tools/bpf/bpftool/main.c                           |    16 +-
 tools/bpf/bpftool/tracelog.c                       |     2 +-
 tools/include/linux/types.h                        |     5 +
 tools/lib/api/fd/array.c                           |     5 +-
 tools/lib/bpf/btf.c                                |     4 +-
 tools/lib/bpf/ringbuf.c                            |     2 +-
 tools/lib/perf/mmap.c                              |     2 +-
 tools/perf/Documentation/perf-c2c.txt              |     2 +-
 tools/perf/builtin-c2c.c                           |    62 +-
 tools/perf/util/header.c                           |    18 +-
 tools/perf/util/jitdump.c                          |   119 +-
 tools/perf/util/mmap.c                             |     3 +-
 .../x86_energy_perf_policy.c                       |    18 +-
 tools/testing/selftests/Makefile                   |     4 +-
 tools/testing/selftests/arm64/signal/Makefile      |     4 +-
 .../selftests/clone3/clone3_clear_sighand.c        |     6 +-
 tools/testing/selftests/core/Makefile              |     2 +-
 tools/testing/selftests/core/unshare_test.c        |   109 +
 .../filesystems/epoll/epoll_wakeup_test.c          |    32 +-
 tools/testing/selftests/ftrace/ftracetest          |     3 +
 tools/testing/selftests/net/Makefile               |     2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |    46 +-
 tools/testing/selftests/net/fin_ack_lat.c          |     2 +-
 tools/testing/selftests/net/tcp_mmap.c             |   110 +-
 tools/testing/selftests/net/txtimestamp.c          |    23 +-
 tools/testing/selftests/netfilter/conntrack_vrf.sh |   140 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   179 +
 .../testing/selftests/timers/clocksource-switch.c  |    23 +-
 tools/thermal/tmon/tmon.c                          |     2 +-
 usr/gen_init_cpio.c                                |     1 +
 1770 files changed, 98525 insertions(+), 12097 deletions(-)


