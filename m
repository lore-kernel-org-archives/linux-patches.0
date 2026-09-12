Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB4A3806C6;
	Sat, 12 Sep 2026 07:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196864; cv=none; b=YLmlIxRZvRkOW2rtUOGjalDvTl6YnphqUlxnfr/G/VKSMrMG199q2NTUQDv3DXViW1ijsu9QaLlZeAdYiVfjCAbzv10za+nNLfACwifGfg64iazgYboI+UjOJAY0eF2DfO7sEsMTOD/+GkrdzaJY/mjS76mfPCGezhplaAcLgUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196864; c=relaxed/simple;
	bh=vQmneg+HQBukUaq9y6n/6MpysECLgi+hFYBc/Z64Sek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VKI0r5/5kxCwBIgT3eVkvU+z8ymR993s7VqNhHbjhWXfPkIPYg7M0xLD40X2NRwbj2aGM5kaTkJx1cfPgVlxG+MX3NW4RdMMhjIAm/Otc1oLcKqEr03/dNEg0IHDB0qRHLAuIUcPXkN96KDY4DQ8PU4fk+bfJ1oCwH46VUJFrNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2akuFKW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2akuFKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99491F000FF;
	Sat, 12 Sep 2026 07:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196853;
	bh=n2IY4lawsnBFYhv9K9KXjUt6ZEI8+ack0f+2MLT1Y+E=;
	h=From:To:Cc:Subject:Date;
	b=X2akuFKWbda7NTQ0jyImNSrIwBUZr76aBblwf/85zdAaCLaRp9yx8Hjofokd90qOd
	 Rr7I2SHD4a4lcDp/wFjZlObdcjGM0SFLFMbRh3xszODz0/6iHCNJORnez1dV2Qh60g
	 8sTJkwhcX4uteg/Q9HpxMxl+1fRdtCiI3r14dvmk=
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
Subject: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
Date: Sat, 12 Sep 2026 08:29:10 +0200
Message-ID: <20260912065648.999753832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.6-rc1
X-KernelTest-Deadline: 2026-09-14T06:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.6 release.
There are 1815 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.6-rc1

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq: clamp quantum and initial_quantum in change path

Pavel Begunkov <asml.silence@gmail.com>
    tcp: reject non zerocopy devmem tx

Steffen Klassert <steffen.klassert@secunet.com>
    Revert "esp: do not unref managed frag pages in esp_ssg_unref()"

Ben Cressey <ben@cressey.dev>
    dm-integrity: fix buffer overflow with keyed discard

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_htb: limit htb_classify inner-class filter hops

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: fix corruption of urgent data on multi-segment retransmit

Deepanshu Kartikey <kartikey406@gmail.com>
    usb: atm: usbatm: fix invalid ci_range initialization

bui duc phuc <phucduc.bui@gmail.com>
    net: fec: only stop PTP if it was initialized

Eric Dumazet <edumazet@google.com>
    slip: remove slip_hangup() to fix use-after-free in slip_receive_buf()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: bound qdisc_pkt_len to prevent qdisc soft lockup

Edoardo Pinci <epinci@outlook.com>
    net: dsa: mxl862xx: enable assisted learning on CPU port

Pascal Kneuper <PKneuper@dspace.de>
    net: stmmac: restore NET_IP_ALIGN in the RX DMA offset

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: drop gso_enabled_types and rely on netdev features

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Don't test flow control for small rx fifos

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Account for the UC filter list for filtering tests

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwxgmac: Account for the primary MAC address for UC filtering

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac4: Account for the primary MAC address for UC filtering

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac1000: Account for the primary MAC address for UC filtering

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Check multiple MMC counters

Anoop Vijay <anoop.c.vijay@intel.com>
    drm/xe/sysctrl: Read mailbox phase bit from hardware

Riana Tauro <riana.tauro@intel.com>
    drm/xe/xe_ras: Add support to get error counter value

Riana Tauro <riana.tauro@intel.com>
    drm/xe/uapi: Add additional error components to xe drm_ras

Daniel Pawlik <pawlik.dan@gmail.com>
    net: airoha: npu: fix missing streaming DMA mask

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/arm64: Fix MTE prctl TAP plan

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/arm64: Treat KSM merge_across_nodes as optional

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/arm64: Print missing MTE TAP headers

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Don't add invalid kcontrols to LED layer

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip double clone set expressions on element insert

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: move hardware offload step after building the chain blob

Alice Mikityanska <alice.kernel@fastmail.im>
    virtio-net: Ensure that TCP packets don't overflow gso_segs

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe: Reject page faults from non-fault-mode scratch VMs

Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
    drm/xe/xe_gt_idle: Add CCS to the powergating info print

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe: Do not apply WA 14025883347 to media 3503

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Pass the IP proto mask in the TC selftest

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: use BIT_ULL() to prevent shift overflow on 32-bit archs

Vitaliy Sochnev <sochnev.v.74@gmail.com>
    net: phy: air_en8811h: move LED GPIO configuration to config_init

Yifei Chu <Chuyf26@linux.alibaba.com>
    net/smc: release the internal TCP sock on IPPROTO_SMC socket creation failure

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: sun4i-emac: Fix IRQ error handling

Shengyu Qu <wiagn@4d2.org>
    ASoC: amd: acp-config: change quirks to cover all ASUS FA401EA variants

Haotian Zhang <vulab@iscas.ac.cn>
    samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-multi-modify

Haotian Zhang <vulab@iscas.ac.cn>
    samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-modify

Aleksandr Nogikh <nogikh@google.com>
    libceph: validate banner payload length

Xiubo Li <xiubo.li@clyso.com>
    ceph: revalidate ki_pos for O_APPEND writes after cap acquisition

Hongling Zeng <zenghongling@kylinos.cn>
    ceph: Fix ERR_PTR(0) in ceph_mkdir()

HyeongJun An <sammiee5311@gmail.com>
    ASoC: dapm: Fix off-by-one check on the second enum channel

Fuad Tabba <fuad.tabba@linux.dev>
    of/irq: Fix device node refcount leak in of_irq_get_affinity()

John Johansen <john.johansen@canonical.com>
    apparmor: policy_int make sure list heads are initialized before fail path

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: acomp - allocate async request context when cloning

Ruoyu Wang <ruoyuw560@gmail.com>
    tpm: st33zp24: Validate locality read result

Ruoyu Wang <ruoyuw560@gmail.com>
    tpm: st33zp24: Return zero on status read failure

Victor Nogueira <victor@mojatatu.com>
    net/sched: sch_teql: restore skb->dev on the slave failure path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sfq: clamp quantum to avoid signed overflow soft lockup

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: clamp quantum before hhf_change() to avoid overflow

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_pie: clamp default quantum to avoid signed overflow

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_codel: clamp default mtu to avoid disabling CoDel

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_codel: clamp default quantum and mtu

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq: add overflow bounds to quantum and initial quantum

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: fix a resource leak in copy_net_ns() error handling path

Mina Almasry <almasrymina@google.com>
    net: core: check skb_frags_readable before uncloning in skb_copy_ubufs

Eric Dumazet <edumazet@google.com>
    net/sched: act_skbmod: fix length calculations and avoid invalid header warnings

Karl Mehltretter <kmehltretter@gmail.com>
    selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC

Liam R. Howlett (Oracle) <liam@infradead.org>
    maple_tree: fix argument name in header

Liam R. Howlett (Oracle) <liam@infradead.org>
    maple_tree: catch race in mas_alloc_cyclic()

Usama Arif <usama.arif@linux.dev>
    mm/memcontrol: avoid false sharing between vmstats and events

Hongfu Li <lihongfu@kylinos.cn>
    selftests/mm: fix read_file() return value check

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/mm: skip COW tmpfile cases when fallocate() is unsupported

Ze Tan <tanze@kylinos.cn>
    smb/client: preserve open info type across compound queries

Frank Sorenson <sorenson@redhat.com>
    cifs: fix clearing stats for fastest execution of each smb2 command

Sai Krishna <saikrishnag@marvell.com>
    octeontx2-af: fix cn20k mailbox lifetime on repeated rvu_mbox_init()

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: fix NULL deref of af_xdp_zc_qidx on rep setup

Allison Henderson <achender@kernel.org>
    net/rds: use wq_has_sleeper() in rds_cong_map_updated()

Long Li <longli@microsoft.com>
    net: mana: Cap MSI-X vectors to the device MSI-X table size

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_ife: Only operate on Ethernet frames

Wei Fang <wei.fang@nxp.com>
    net: enetc: restore RX ring congestion mode for ENETC v4

Wei Fang <wei.fang@nxp.com>
    net: enetc: remove invalid code from enetc4_pl_mac_link_up()

Wei Fang <wei.fang@nxp.com>
    net: enetc: improve MAFT entry management with bitmap tracking

Wei Fang <wei.fang@nxp.com>
    net: enetc: convert ndo_set_rx_mode() to ndo_set_rx_mode_async()

Wei Fang <wei.fang@nxp.com>
    net: enetc: extract common helpers for MAC hash filter configuration

Wei Fang <wei.fang@nxp.com>
    net: enetc: extract common helpers for MAC promiscuous mode setting

Wei Fang <wei.fang@nxp.com>
    net: enetc: restore RX ring congestion mode after ring reconfiguration

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-af: Fix TL3/TL2 link config ENA clearing

Xiang Mei <xmei5@asu.edu>
    net: qualcomm: rmnet: restore skb->dev on deaggregated frames

Anshumali Gaur <agaur@marvell.com>
    octeontx2-vf: fix workqueue and netdev race in probe/remove

Anshumali Gaur <agaur@marvell.com>
    octeontx2-af: fix out-of-bounds read setting MSI-X irq affinity

Anshumali Gaur <agaur@marvell.com>
    octeontx2-af: fix NULL deref in NIX TM tree debugfs read path

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: honor XDP_TX_METADATA in zero-copy path

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: align TX metadata layout across ABIs

Radek Podgorny <radek@podgorny.cz>
    Bluetooth: do not leak an hci_conn when a second LE connect is rejected

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: RFCOMM: Validate MTU in rfcomm_apply_pn() to prevent infinite loop

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: btnxpuart: Validate the FW dump header length

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: add conditional locking annotations

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Fix out-of-bounds DMA read in the TX path

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Take exclusive ownership of the SKB before TX

Ismail Tarim <ismailtarim7@gmail.com>
    Bluetooth: btmtk: Do not discard the subsystem reset timeout

Ismail Tarim <ismailtarim7@gmail.com>
    Bluetooth: btmtk: Do not report success when subsys reset fails

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix race l2cap_sock_cleanup_listen() vs. put_chan

Pavel Shpakovskiy <pashpakovskii@salutedevices.com>
    Bluetooth: mgmt: fix 'hdev->discovery.uuids' NULL dereference

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: access chan->conn safely in get/setsockopt

Seongjae Jeong <jsjlee1020@gmail.com>
    f2fs: use adjusted write range after f2fs_write_checks()

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: process: Fix context switching MTE store-only tag check

Wei-Lin Chang <weilin.chang@arm.com>
    arm64: ptdump: Make note_page_flush() range aware

Bernd Schubert <bernd@bsbernd.com>
    fuse: Fix the condition to enable over-io-uring

Joanne Koong <joannelkoong@gmail.com>
    fuse: use release/acquire for fch->initialized

Baokun Li <libaokun@linux.alibaba.com>
    fuse: invalidate the correct range after O_APPEND direct write

Geert Uytterhoeven <geert+renesas@glider.be>
    erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic

Dan Carpenter <error27@gmail.com>
    scsi: qla2xxx: Fix an loop timeout test

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: vmbus: Skip VMBus module cleanup for non-nested root partition

Giuseppe Piscitelli <ooonea@gmail.com>
    net/sched: sch_cake: fix autorate reconfiguration throttling

Jian Shen <shenjian15@huawei.com>
    net: hibmcge: fix page_pool DMA direction mismatch

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: fix pacing delay underflow with pacing offload

Rong Zhang <i@rong.moe>
    net: page_pool: Remove zone/policy GFP flags when allocating XArray entries

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix concurrent bitmap overwrite in PTP setup

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix MISC interrupt unmasking in non-MSI-X mode and device shutdown

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: fix sleep in atomic context in MAC table access

Daniel Machon <daniel.machon@microchip.com>
    net: microchip: vcap: use port number instead of netdev name for debugfs

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: account classifier filter allocations to memcg

Wei Fang <wei.fang@nxp.com>
    ptp: netc: fix period truncation and potential divide-by-zero in PEROUT

Thomas Walsh <thwalsh@redhat.com>
    bnxt_en: Gate TPH enablement behind BNXT_SUPPORTS_QUEUE_API check

Guenter Roeck <linux@roeck-us.net>
    bnxt_en: Fix call to hardware monitoring event handler

Julian Braha <julianbraha@gmail.com>
    ASoC: fix unmet dependencies on PPC_BESTCOMM and SND_SOC_AC97_BUS

Cosmo Chou <chou.cosmo@gmail.com>
    rtc: pcf85363: Add error checking to regmap calls in probe()

Junrui Luo <moonafterrain@outlook.com>
    NFSv4/pnfs: key the data server cache on the NFS version

Junrui Luo <moonafterrain@outlook.com>
    NFSv4.2: fix LAYOUTSTATS send buffer exhaustion

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    NFSv4.1: zero referring call lists before decoding

Nikolay Aleksandrov <razor@blackwall.org>
    vxlan: fix reading neigh ha

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: arp/nd proxy: fix reading neigh ha

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: free pending qentry in smc_llc_flow_stop() before memset

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: free stashed qentry before overwrite in REQ_ADD_LINK to ADD_LINK transition

Li, Yifan <yifan2.li@intel.com>
    powercap: intel_rapl: Sign-extend the PMU delta on counter wraparound

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue

Mina Almasry <almasrymina@google.com>
    net: tcp: block mixing readable and unreadable frags

Eric Dumazet <edumazet@google.com>
    inetpeer: randomize RB-tree node comparison using SipHash

Eric Dumazet <edumazet@google.com>
    ip6mr: do not clone dst in ip6mr_cache_report()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: qlcnic: validate unified ROM sections before loading

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: add missing ref_tracker_dir_exit() to net_passive_dec()

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    ipv6: avoid divide by zero in rt6_multipath_rebalance

Eric Dumazet <edumazet@google.com>
    netdevsim: update queue NAPI association on queue reset

Ruoyu Wang <ruoyuw560@gmail.com>
    net: ipa: balance runtime PM reference on remove error

Marek Czernohous <marek@czernohous.de>
    forcedeth: stop the tx_timeout register dump past the requested window

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: E-Switch, preserve max tx speed on vport state modification

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Move vport DOWN state check out of mlx5_query_vport_max_tx_speed()

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: E-Switch, use state lock for vport state changes

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Count delivered packets in rx_packets and rx_bytes

Victor Nogueira <victor@mojatatu.com>
    net/sched: add get_fill_size callbacks for actions missing them

Ruoyu Wang <ruoyuw560@gmail.com>
    net: bridge: Reject descending VLAN tunnel ranges

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    xsk: fix NULL pointer dereference in __xsk_rcv()

Rustam Adilov <adilov@disroot.org>
    irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Add mask for interrupt handling

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Add interrupt data structure

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Split out parent setup code

Namjae Jeon <linkinjeon@kernel.org>
    smb: server: remove unused DES crypto header

Thomas Huth <thuth@redhat.com>
    smb: server: Remove obsolete "select CRYPTO_LIB_DES" from Kconfig file

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mtpav: shut down output timer before card teardown

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe: don't WARN on kernel job timeout when device already wedged

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: amlogic-spisg: Make sure clk_init_data is fully initialized

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/ucma: Allow path records to exactly fit the output buffer

Dennis Tighe <dennis.tighe@gmail.com>
    ntfs: validate usa_ofs before preserving the update sequence number

Dennis Tighe <dennis.tighe@gmail.com>
    ntfs: fix off-by-one page overflow in ntfs_decompress()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    sched/topology: Add a cpus_read_lock to rebuild_sched_domains()

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Defer default SPI and LPI IAFFID programming

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Use logical cpu 0 irs_data for dynamic IST allocation

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Release IRS iomem region on driver init failure

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Fix gicv5_init_common() error paths

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Disable IRSes on probe failures

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Check for NULL LPI domain on domain teardown

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Check get_logical_index() return value in MADT IAFFID parsing

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Synchronize CPU interface disable

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Clear per-CPU IRS data on teardown

Michael Pesa <michael.pesa@icloud.com>
    irqchip/ast2700-intc: Disable all interrupt merge banks on probe

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: visconti: Make sure clk_init_data is fully initialized

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: ti: Make sure clk_init_data is fully initialized

Bradley Morgan <include@grrlz.net>
    prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator

Karl Mehltretter <kmehltretter@gmail.com>
    lib/interval_tree: fix allocation warning messages

Linkai Gong <gonglinkai@kylinos.cn>
    rtc: gamecube: check return value of devm_rtc_register_device()

Ruoyu Wang <ruoyuw560@gmail.com>
    i2c: ocores: Disable clock on failed resume

Ryan Chen <ryan_chen@aspeedtech.com>
    irqchip/ast2700-intc: Avoid allocating in the irq_domain activate() callback

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzg2l: Fix loss of interrupt

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: zynqmp: Return optional clock lookup errors

Frank Sorenson <sorenson@redhat.com>
    cifs: remove dead size-update blocks in cifs_setattr_unix/nounix

Christopher Lusk <clusk@northecho.dev>
    smb: client: set replay flag on the read send-error retry path

Christopher Lusk <clusk@northecho.dev>
    smb: client: fix request buffer leak in smb2_new_read_req()

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: return EOPNOTSUPP for unsupported O_TMPFILE

Surendra Singh Chouhan <kr494167@gmail.com>
    rtc: spacemit: handle regmap_test_bits() error return

Yi Ding <yi.s.ding@gmail.com>
    rtc: pcf8563: fix clock provider leak on unbind

GuoHan Zhao <zhaoguohan@kylinos.cn>
    virtio: rtc: time out alarm requests

Li RongQing <lirongqing@baidu.com>
    vdpa/mlx5: fix wrong list iterated in add_direct_chain error path

Li RongQing <lirongqing@baidu.com>
    virtio_pci: fix wrong queue index for admin vq in intx path

Yufeng Wang <wangyufeng@kylinos.cn>
    vhost/net: fix clear_user start address in VHOST_GET_FEATURES_ARRAY

Denis V. Lunev <den@openvz.org>
    virtio_balloon: quiesce balloon work before device shutdown

Denis V. Lunev <den@openvz.org>
    virtio_balloon: factor out virtballoon_quiesce()

Denis V. Lunev <den@openvz.org>
    virtio: add virtio_device_shutdown() helper

Linfeng Sun  <linfeng.sun.dev@gamil.com>
    vdpa_sim: fix cleanup after worker creation failure

Michael S. Tsirkin <mst@redhat.com>
    virtio_balloon: disable indirect descriptors

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: do not update ctime when setxattr fails

Hyeontae Lee <wonju345@naver.com>
    ntfs: serialize resident iomap reads with mrec_lock

Joanne Koong <joannelkoong@gmail.com>
    ntfs: convert iomap ops to ->iomap_next()

Joanne Koong <joannelkoong@gmail.com>
    iomap: add ->iomap_next()

Joanne Koong <joannelkoong@gmail.com>
    iomap: split iomap_iter() logic into iomap_iter_next()

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: allow index root relocation

Pisit Preechapramoth <kml.delusion501@slmail.me>
    ntfs: reject unprivileged writes to reserved $LX* xattrs

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: respect per-file chmod mode over mount masks

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: apply Windows name checks only with windows_names

Alexandro Calo <alexandro.calo@nozominetworks.com>
    ntfs: Fix index_root heap OOB write in ntfs_ir_to_ib()

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: fix kmap_local_page() usage in compress

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs: Remove references to page->__folio_index

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs: Use zero_user_segment() in handle_bounds_compressed_page()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs: Remove use of __folio_index in handle_bounds_compressed_page()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ntfs: Inline zero_partial_compressed_page()

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: rewrite EA stream before updating metadata

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: remove empty EA attribute pair

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: validate final EA attribute size

Besar Wicaksono <bwicaksono@nvidia.com>
    perf vendor events arm64: Fix Tegra410 Olympus event 0x0197

Saurav Sachidanand <sauravsc@amazon.com>
    perf vendor events arm64: fix swapped MetricGroup for Tegra410 L1 prefetcher metrics

Jian-Ming Liao <Jm_Liao@asmedia.com.tw>
    i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()

Ruoyu Wang <ruoyuw560@gmail.com>
    bonding: initialize err for empty target lists

Nikolay Kulikov <nikolayof23@gmail.com>
    mlxbf-bootctl: fix the build error with FIELD_PREP()

Hemanth Selam <hemanth.selam@gmail.com>
    platform/x86/amd/hsmp: Reject negative power cap writes in hwmon

Guangshuo Li <lgs201920130244@gmail.com>
    platform/x86: hp-bioscfg: fix password encoding bounds check

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: use sock_error() to consume sk_err after a failed connect

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: don't check the listener's sk_err in vsock_accept()

HyeongJun An <sammiee5311@gmail.com>
    platform/x86: dell-wmi-sysman: Fix instance ID bounds

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: hash socket only after full initialisation in smc_sk_init()

Karl Mehltretter <kmehltretter@gmail.com>
    8139cp: fix Rx and Tx not being disabled in cp_suspend

Baul Lee <baul.lee@xbow.com>
    vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: Fix connection list comparison in proc output

Baokun Li <libaokun@linux.alibaba.com>
    fuse: check for NULL root inode in fuse_fill_super_submount

Daniel Baluta <daniel.baluta@nxp.com>
    soc: qcom: ubwc: Fix missing include

Baokun Li <libaokun@linux.alibaba.com>
    fuse: reject a duplicate fd= mount option

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: validate ef->size covers the record's name and value

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: fix out-of-bounds read in read_log_rec_buf()

Baokun Li <libaokun@linux.alibaba.com>
    cuse: wait for pending RCU callbacks on module exit

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix inverted default vlan notification

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    tls: fix RX desync on overlapping skbs

Ruoyu Wang <ruoyuw560@gmail.com>
    net: dsa: mv88e6xxx: Fix PCS link check on CMODE read error

Xiang Mei <xmei5@asu.edu>
    vxlan: vnifilter: enforce exact length of GROUP/GROUP6 attributes

Joas Antonio dos Santos <joasantonio108@gmail.com>
    ipvs: fix integer overflow in ftp helper port/address parsing

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: do not expose expectation DEAD flag

Florian Westphal <fw@strlen.de>
    netfilter: ipset: remove need to allocate memory on delete operations

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid pinfile fragment on fragment:{block, segment} mode

Chao Yu <chao@kernel.org>
    f2fs: cleanup w/ f2fs_need_rand_{blk, seg, seg_blk}

Anton Protopopov <a.s.protopopov@gmail.com>
    virtio_net: Fix resize of the RX ring

Xin Xie <xiexinet@gmail.com>
    net: hsr: free learned nodes on device setup failure

Qingfang Deng <qingfang.deng@linux.dev>
    pppox: drain queued packets on channel handoff

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: b53: fix error propagation from b53_fdb_dump()

Junseo Lim <zirajs7@gmail.com>
    net: kcm: Hold RCU read lock while running BPF parser

Petr Oros <poros@redhat.com>
    dpll: fix NULL deref in dpll_device_ops() during teardown race

Prabu Thayalan <prabu.ponrajthayalan@amd.com>
    ionic: fix completion descriptor access with 2x desc size

Eric Joyner <eric.joyner@amd.com>
    ionic: add missing dma_rmb() after the completion publish check

Wei Fang <wei.fang@nxp.com>
    ptp: netc: skip PEROUT disable if channel is not enabled

Dan Carpenter <error27@gmail.com>
    drm/xe: tests: fix error message in xe_migrate_sanity_test()

Fan Gong <gongfan1@huawei.com>
    hinic3: Fix skb linearization mismatch and drop skb when skb_checksum_help() failed

Karl Mehltretter <kmehltretter@gmail.com>
    octeontx2-af: initialize lmac_bmap in rvu_mcs_set_lmac_bmap()

bui duc phuc <phucduc.bui@gmail.com>
    can: m_can: Use of_property_present() for wakeup-source

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, xdp: move offload check into dev_xdp_install()

Mario Rugiero <mrugiero@gmail.com>
    regulator: tps65185: wait for the IC to wake before the first I2C access

Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
    clk: ti: mux: resolve parent clocks by DT index, not by name

Onur Özkan <work@onurozkan.dev>
    clk: devres: fix cleanup in devm_clk_get_optional_enabled_with_rate()

Michael Nemanov <michael.nemanov@vastdata.com>
    nfs: fix ENXIO on O_CREAT open of existing symlink over NFSv3

Zhansong Gao <zhsgao@hotmail.com>
    NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()

Jeuk Kim <jeuk20.kim@gmail.com>
    NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers

Guangshuo Li <lgs201920130244@gmail.com>
    NFS: Fix delayed delegation return list handling

ZhangGuoDong <zhangguodong@kylinos.cn>
    pnfs/blocklayout: Fix device leaks on parse failure

Ruoyu Wang <ruoyuw560@gmail.com>
    NFSv4: remove callback IDR entry on client allocation failure

Arnaud Bonnet <abo@medichon.fr>
    nfs: refactor pNFS functions using clear_and_wake_up_bit

Arnaud Bonnet <abo@medichon.fr>
    nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Retry stat generation in cgroup_iter_memcg

Ze Tan <tanze@kylinos.cn>
    smb/server: fix session counter on session removal

Ze Tan <tanze@kylinos.cn>
    smb/server: update session counter under sessions table lock

Ze Tan <tanze@kylinos.cn>
    smb/server: warn if ksmbd_proc_create() fails

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add procfs monitoring for active shares

Ze Tan <tanze@kylinos.cn>
    smb/server: fix session leak in ksmbd_session_register()

Hang Nan <2122295973@qq.com>
    ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle encrypted compressed requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: decrypt requests from expired encrypted sessions

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: disconnect on SMB3 decryption failure

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: scope session state changes to bound connections

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix encrypted request lookup on bound channels

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: expire SMB sessions when Kerberos tickets expire

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate SMB2 write offsets

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: detach blocked lock requests before freeing

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: safely discard unregistered deferred locks

Junseo Lim <zirajs7@gmail.com>
    bpf: Reject negative optlen in cgroup getsockopt hook

Andreas Schwab <schwab@linux-m68k.org>
    m68k: nfcon: Do not call console_is_registered() in nfcon_device()

Junseo Lim <zirajs7@gmail.com>
    bpf: Disallow bpf_{g,s}etsockopt() in cgroup UNIX getname hooks

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    erofs: fix unused pcluster_pools for higher page sizes

Junseo Lim <zirajs7@gmail.com>
    lwt_bpf: Restore reserved headroom after xmit program

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix vmlinux klp relocations for EXPORT_SYMBOL_FOR_MODULES()

Gao Xiang <xiang@kernel.org>
    erofs: guard on-disk algorithm IDs against Z_EROFS_COMPRESSION_MAX

Gao Xiang <xiang@kernel.org>
    erofs: fix interlaced ztailpacking pclusters

Ilan Dudnik <ilan.dudnik@safebreach.com>
    ksmbd: defer publishing granted locks to prevent UAF/double-free race

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: recognize replayed SMB2 lock sequences

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: preserve error status in smb2_handle_negotiate()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: call ksmbd_proc_cleanup() on module init failure

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: abort initialization when proc setup fails

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix invalid pointer dereference in ksmbd_stop_durable_scavenger()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: serialize oplock close with pending break ownership

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add SMB3 request replay support

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: retain connection for pending notify work

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: add AAPL kAAPL_SERVER_QUERY create context support

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix durable handle v2 default timeout units (60 -> 60000)

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: support access-based directory enumeration

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: free preauth sessions on connection teardown

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: do not advertise unimplemented CA support

Yunseong Kim <yunseong.kim@est.tech>
    ksmbd: validate ipc response length before dereferencing its fields

Yunseong Kim <yunseong.kim@est.tech>
    smb: smbdirect: release pending child sockets outside the handler lock

Yunseong Kim <yunseong.kim@est.tech>
    smb: smbdirect: avoid recursive listen.lock during cleanup

Yunseong Kim <yunseong.kim@est.tech>
    smb: smbdirect: destroy QP before mem pools on accept failure

Yunseong Kim <yunseong.kim@est.tech>
    smb: smbdirect: free completion queues with ib_free_cq()

Yunseong Kim <yunseong.kim@est.tech>
    ksmbd: fix slab-out-of-bounds read in ksmbd_alloc_user()

Enzo Matsumiya <ematsumiya@suse.de>
    smb: server: fix leak of ksmbd_ipc_login_request_ext() returned buffer

Guangshuo Li <lgs201920130244@gmail.com>
    ksmbd: Do not skip lock checks for single-byte ranges

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Check pointer type for all atomic RMW paths

Marius Cristea <marius.cristea@microchip.com>
    hwmon: (emc1403) Drop hysteresis for low limit temperature

Szymon Wilczek <swilczek.lx@gmail.com>
    hwmon: (coretemp) Fix core_data leak on CPUs without PTS

John Johansen <john.johansen@canonical.com>
    apparmor: fix deadlock in complain-mode change_hat

Mike Rapoport (Microsoft) <rppt@kernel.org>
    selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check

Hongyan Xu <getshell@seu.edu.cn>
    block: mtip32xx: synchronize ioctls with device removal

Yao Sang <sangyao@kylinos.cn>
    ublk: avoid teardown retry loop on xarray allocation failure

Yao Sang <sangyao@kylinos.cn>
    ublk: reject non-power-of-2 zone sizes in SET_PARAMS

Usama Arif <usama.arif@linux.dev>
    blk-iocost: clear delay state when freeing policy data

Usama Arif <usama.arif@linux.dev>
    blk-iolatency: clear delay state when freeing policy data

Niklas Cassel <cassel@kernel.org>
    null_blk: serialize configfs attribute updates with device setup

Zizhi Wo <wozizhi@huawei.com>
    null_blk: serialize configfs attribute stores with the lock

Zizhi Wo <wozizhi@huawei.com>
    null_blk: reject per-device queue resize for shared tag set

Zizhi Wo <wozizhi@huawei.com>
    null_blk: free zones array on device power-off

Zizhi Wo <wozizhi@huawei.com>
    null_blk: free global tag_set on init error path

Zizhi Wo <wozizhi@huawei.com>
    null_blk: register configfs subsystem after creating default devices

Zizhi Wo <wozizhi@huawei.com>
    null_blk: use DEFINE_MUTEX for the file-scope mutex

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mailbox: riscv-sbi-mpxy: validate RPMI notification lengths

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Fix command timeout due to missed interrupt

Linmao Li <lilinmao@kylinos.cn>
    mailbox: rockchip: disable pclk on probe failure and unbind

Jia Yang <jia.yang@oss.qualcomm.com>
    mailbox: qcom-cpucp: handle NULL data in send_data callback

Jia Yang <jia.yang@oss.qualcomm.com>
    mailbox: qcom-cpucp: fix PREEMPT_RT self-deadlock in IRQ handler

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Replace assert with runtime check in dso__read_symbol()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Guard against cache underflow on short reads in dso_cache__memcpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Use stored fd error instead of stale errno in file_read() and file_size()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Guard against errno==0 when dso__get_filename() returns NULL

Tejun Heo <tj@kernel.org>
    sched_ext: Make SCHED_CLASS_EXT select GENERIC_ALLOCATOR

Tao Cui <cuitao@kylinos.cn>
    sched_ext/scx_flatcg: Fix cvtime true-up on slice expiry

Tejun Heo <tj@kernel.org>
    sched_ext: Drop unlocked scx_rq_clock_invalidate() from scx_root_disable()

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: lskcipher - propagate errors from unaligned crypt

Zhushuai Yin <yinzhushuai@huawei.com>
    crypto: hisilicon/sec2 - fix CCM algorithm long packet failure

Michal Blaszczyk <michalblk@google.com>
    selftests/sched_ext: Fix flaky ddsp failure tests on busy systems

Israel Téllez García <i.tellez@btesa.com>
    bpf: Fix pending_pos walk on 32-bit ring position wrap

Ihor Solodrai <ihor.solodrai@linux.dev>
    selftests/bpf: Fix selftest build after filter.h update

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Use acpi_bus_get_primary_device()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: platform: Use acpi_bus_get_primary_device()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: bus: Introduce acpi_bus_get_primary_device()

Hongyan Xu <getshell@seu.edu.cn>
    ACPI: scan: fix bus ID cleanup on device_add() failures

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Remove trace_buffer::cpus

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Fix missing sign-ext for signed 1-byte and 2-byte kfunc args

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Fix arm64 KASAN false positive after bpf_throw

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Use ping_command() for IPv6 pings in lwt_ip_encap

Linmao Li <lilinmao@kylinos.cn>
    HID: tmff: Use 64-bit arithmetic for force feedback scaling

Xianglin Lin <1021538027@qq.com>
    HID: multitouch: reclassify HTIX5288 to WIN_8_FORCE_MULTI_INPUT_NSMU

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: SOF: validate topology volume range before allocation

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have trace_event_update_all() only handle module that is loading

Karl Mehltretter <kmehltretter@gmail.com>
    HID: haptic: don't write an uninitialized value to unhandled usages

Aleksandr Nogikh <nogikh@google.com>
    ALSA: core: Fix use-after-free in snd_card_do_free()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: reject out-of-range evcn in mi_enum_attr()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: fix integer overflow in MFT cluster validation

Puranjay Mohan <puranjay@kernel.org>
    bpf, arm64: Fix stack-passed arguments for indirect trampolines

Jijie Shao <shaojijie@huawei.com>
    net: page_pool: fix UAF in __page_pool_release_netmem_dma on xa_cmpxchg race

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Set task state before io_schedule_timeout()

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Fix for veristat file/prog filters processing

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check block offset is not negative

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    ocfs2: fix circular locking dependency in ocfs2_init_acl()

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate DIO orphan slot during inode read

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate orphan slot during inode read

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix double close in map dump

Bijan Tabatabai <btabatabai@wisc.edu>
    x86/pkeys: Fix pkey_alloc() return value when pkeys are not supported

Rui Qi <qirui.001@bytedance.com>
    selftests/cgroup: Preserve CPU hotplug write errors

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: fix max_qid race between configfs and controller allocation

John Keeping <jkeeping@inmusicbrands.com>
    ALSA: seq: midi: Serialize input teardown with event_input

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: midi: Optimize event_input locking with RCU

Yuho Choi <dbgh9129@gmail.com>
    clocksource/drivers/armada: Unwind timer clock on init failure

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/samsung_pwm: Switch to raw_spinlock_t type

Guangshuo Li <lgs201920130244@gmail.com>
    clocksource/drivers/clps711x: Do not unmap clocksource MMIO

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/debug: Fix deadlock during unregister

Yuho Choi <dbgh9129@gmail.com>
    xenbus: Unregister reboot notifier on init failure

Waiman Long <longman@redhat.com>
    sched/isolation: Defer freeing of cpumask memblock memory to initcall

Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
    selftests/namespaces: Fix racy pipe handshake in timens and pidns_separate

Hui Zhu <zhuhui@kylinos.cn>
    bpf: Fix UAF in bpf_trampoline_multi_attach_free on update failure

Willem de Bruijn <willemb@google.com>
    selftests: drv-net: so_txtime: fix qdisc replace with handle

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq27520g4: fix REG_TTES address

Matti Vaittinen <mazziesaccount@gmail.com>
    power: supply: bd99954: Drop bad register fields

Matti Vaittinen <mazziesaccount@gmail.com>
    power: supply: bd71828: Do not hide errors

Matti Vaittinen <mazziesaccount@gmail.com>
    power: supply: bd71828: Drop duplicate power-supply property

Matti Vaittinen <mazziesaccount@gmail.com>
    power: supply: bd71828: Fix current direction

Matti Vaittinen <mazziesaccount@gmail.com>
    power: supply: bd71815: Fix temperature reading

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix .kcfi_traps special section extraction

Puranjay Mohan <puranjay@kernel.org>
    objtool/klp: Fix vmlinux .klp.symid link error for .exitcall.exit symbols

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    PCI/ASPM: Disable/restore ASPM on every function for multi-function devices

Felix Gu <ustc.gu@gmail.com>
    spi: img-spfi: don't disable runtime PM on DMA deferred probe

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: spacemit: advertise only DMA-backed DAI streams

Vineet Gupta <vineet.gupta@linux.dev>
    selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM

David Matlack <dmatlack@google.com>
    selftests: harness: Mark test fixture objects __maybe_unused

Daniel Borkmann <daniel@iogearbox.net>
    bpf, s390: Clear fetch destination on faulting arena atomic

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: Clear fetch destination on faulting arena atomic

Daniel Borkmann <daniel@iogearbox.net>
    bpf, x86: Clear fetch destination on faulting arena atomic

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Derive the atomic load register in one place

Daniel Borkmann <daniel@iogearbox.net>
    bpf, riscv: Clear fetch destination on faulting arena atomic

Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>
    kunit: tool: fix _list_tests filtering wrong variable when list has TAP prefix

Dan Carpenter <error27@gmail.com>
    drm/amd/pm: silence uninitialized variable warnings

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Remove leftover feature tests for removed cxx and clang support

Julian Braha <julianbraha@gmail.com>
    backlight: ktd2801: Fix unmet dependency on GPIOLIB

Junjie Cao <junjie.cao@linux.dev>
    backlight: aw99706: Validate all DT property values consistently

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: cs42l43: Fix regmap defaults ordering

Will Deacon <will@kernel.org>
    arm64/efi: Avoid voluntary preemption with efi_mm installed

Christoph Hellwig <hch@lst.de>
    iomap: iomap_bio_read_folio_range_sync is missing a call to bio_uninit

Karl Mehltretter <kmehltretter@gmail.com>
    super: fix dying superblock warning messages

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    PCI/ASPM: Use pcie_capability_clear_and_set_word() for ASPM disable/restore

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix relocations for EXPORT_SYMBOL_FOR_MODULES() symbols

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Don't match local symbols against exports

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix cross-module klp relocation section naming

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix memory leak in error path of build_tree()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: validate parent port count before allocating nodes in build_tree()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: consolidate port counting in build_tree()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: add KUnit tests for failure of tree building

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: add KUnit tests for successful tree building

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: add KUnit test skeleton for node tree

Ran Hongyun <ranhongyun1@huawei.com>
    UBI: fix two issues in the ubi.mtd MODULE_PARM_DESC

Rosen Penev <rosenp@gmail.com>
    ASoC: xilinx: formatter_pcm: fix stream_data leak on open error

Yuho Choi <dbgh9129@gmail.com>
    mtd: ubi: Release device reference on busy detach

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Ignore replacement offset of empty x86 alternatives

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix size of empty special section entries

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix vmlinux .klp.symid link error for .no_trim_symbol symbols

Yuho Choi <dbgh9129@gmail.com>
    ubi: Fix rollback for explicit UBI device numbers

Ning Ding <dingning04@gmail.com>
    bpf: Compare iterator types during state pruning

Zhihao Cheng <chengzhihao1@huawei.com>
    UBI: fastmap: Pass to_be_tortured when reusing old fastmap PEBs

Zhihao Cheng <chengzhihao1@huawei.com>
    UBI: Preserve torture flag when rescheduling failed erasures

LiangCheng Wang <zaq14760@gmail.com>
    ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: pxa: Use devm_clk_get_optional() for extclk clock

Willem de Bruijn <willemb@google.com>
    idpf: add missing cpu_to_le32 in idpf_tx_splitq_build_flow_desc

Robert Malz <robert.malz@canonical.com>
    ice: acquire NVM lock around each flash read

Petr Oros <poros@redhat.com>
    ice: clear the default forwarding VSI rule when releasing a VSI

Przemyslaw Korba <przemyslaw.korba@intel.com>
    ice: fall back to SBQ when LL PHY timer interface times out

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/cma: Fix WARNING in res_to_rt

Fan Wu <fanwu01@zju.edu.cn>
    RDMA/cxgb4: Free debugfs on registration failure

Guangshuo Li <lgs201920130244@gmail.com>
    dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Handle uncommitted PHY config changes

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Fix rate recalculation for 3.2GHz FRL

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Guard against clk rate integer underflow

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Prevent divide-by-zero when computing clk rate

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Fix rate recalculation for high bpc

HyeongJun An <sammiee5311@gmail.com>
    ALSA: seq: Don't leak the extension cell pointer in the bounce payload

Yun Zhou <yun.zhou@windriver.com>
    nfc: nci: fix use of uninitialized memory in CORE_INIT_RSP parsing

Linmao Li <lilinmao@kylinos.cn>
    nfc: digital: Do not dump a NULL response in command completion

Yinhao Hu <dddddd@hust.edu.cn>
    nfc: pn533: hold a reference to the request skb during send_frame

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: llcp: bound SNL TLV parsing to the skb and add length checks

Zhenghang Xiao <kipreyyy@gmail.com>
    nfc: nci: fix double completion race in nci_data_exchange_complete

Breno Leitao <leitao@debian.org>
    nfc: llcp: read llcp_sock->local under the socket lock in getsockopt

Breno Leitao <leitao@debian.org>
    nfc: llcp: avoid userspace overflow on invalid optlen

Liang Hao <haohlliang@gmail.com>
    hrtimer: Account nr_retries on recovered interrupt retries

Chao Shi <coshi036@gmail.com>
    nvme: reject passthrough of driver-managed Set Features

Yang Xiuwei <yangxiuwei@kylinos.cn>
    nvme/ioctl: check SUBMIT_IO with nvme_cmd_allowed()

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: fix NULL pointer dereference in nvmet_execute_identify_ns_zns()

Sven Peter <sven@kernel.org>
    nvme-apple: Drop the PRP null check chicken bit

Sven Peter <sven@kernel.org>
    nvme-apple: Require page aligned buffers on the admin queue

Sven Peter <sven@kernel.org>
    nvme: Add a quirk for page aligned admin queue buffers

Sven Peter <sven@kernel.org>
    nvme-apple: Never set the opcode in the NVMMU TCB

Sven Peter <sven@kernel.org>
    nvme-apple: Don't set a DMA direction for commands without a data transfer

Sven Peter <sven@kernel.org>
    nvme-apple: Destroy the admin queue on removal

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/irqflags: Add out-of-line definitions of arch_local_irq_*() for KMSAN

Josh Poimboeuf <jpoimboe@kernel.org>
    arm64: bti: Disable in-kernel BTI with recent versions of Clang

Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
    ASoC: qcom: q6apm: keep the graph start count in sync with the DSP

Babanpreet Singh <bbnpreetsingh@gmail.com>
    spi: sprd-adi: Fix probe succeeding without registering the controller

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: entry: Avoid unnecessary local_irq_disable() on kernel exit

Esteban Urrutia <esteuwu@proton.me>
    phy: qcom: qmp-combo: Drop qmp_v4_calibrate_dp_phy

Esteban Urrutia <esteuwu@proton.me>
    phy: qcom: qmp-combo: Correct pre-emphasis table for QMP v4 DP PHYs

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Ignore missing VBUS regulator

Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
    rust: uapi: replace direct asm-generic/ioctl.h include with linux/ioctl.h

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix incorrect device ID in invalid PASID error message

John Johansen <john.johansen@canonical.com>
    apparmor: fix unconfined user namespace restriction forced stack

Michael Walle <mwalle@kernel.org>
    powerpc/configs: enable CONFIG_RAS to fix EDAC support

Willem de Bruijn <willemb@google.com>
    selftests: drv-net: so_txtime: only send test traffic to sch_etf

Mohsin Bashir <hmohsin@meta.com>
    selftests: drv-net: Test queue stall upon reconfig

Jia Wang <wangjia@ultrarisc.com>
    PCI: ultrarisc: Get and enable DP1000 PCIe controller clocks

Kuniyuki Iwashima <kuniyu@google.com>
    amt: Don't support cross-netns setup.

Simon Glass <sjg@chromium.org>
    pinctrl: rockchip: Decode drive strength in the get function

Liang Luo <luoliang@kylinos.cn>
    selftests/sched_ext: Check skeleton open failure in exit test

Rui Qi <qirui.001@bytedance.com>
    selftests/cgroup: Avoid awk -e in cpuset tests

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/cpuset: Use WRITE_ONCE() for shared prs_err updates

Guixin Liu <kanie@linux.alibaba.com>
    nvme-pci: release descriptor pools on probe failure

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: propagate percpu_ref_init() failure in nvmet_ns_enable()

Zhengrong Li <zhengrong_li@linux.alibaba.com>
    nvmet: fix Reservation Register Replace for unregistered host with IEKEY

Chuck Lever <cel@kernel.org>
    NFS: Return a delegation the client fails to record

Runyu Xiao <runyu.xiao@seu.edu.cn>
    sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE

Weiming Shi <bestswngs@gmail.com>
    SUNRPC: check rpc_sockaddr2uaddr() return value in rpcb_register_inet4/6

surendra <kr494167@gmail.com>
    hwmon: (pmbus/ltc4283) Add missing MODULE_DEVICE_TABLE for OF match table

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Store the hwmon device in cros_ec_hwmon_priv

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Register the thermal devices after the hwmon ones

Marco Elver <elver@google.com>
    arm64: Disable KCSAN instrumentation in delay.o

Chuck Lever <cel@kernel.org>
    xdrgen: Fix opaque and string encoders for unbounded members

Chuck Lever <cel@kernel.org>
    xdrgen: Add XDR width macros for short integer types

Chuck Lever <cel@kernel.org>
    xdrgen: Do not declare union XDR functions in the definitions header

Chuck Lever <cel@kernel.org>
    xdrgen: Emit a blank line ahead of enum declarations

Chuck Lever <cel@kernel.org>
    lockd: Regenerate NLMv4 XDR code

Jeff Layton <jlayton@kernel.org>
    nfsd: add protocol support for CB_NOTIFY

Chuck Lever <cel@kernel.org>
    NFSD: Release the export reference when reaping open stateids

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: move custom expectation support to helper

Florian Westphal <fw@strlen.de>
    netfilter: nft_ct: support expectation creation for natted flows

Karl Mehltretter <kmehltretter@gmail.com>
    m68k: Fix backtraces for non-running tasks

Yifei Gao <gyf161023@gmail.com>
    media: amd: isp4: fix self-deadlock in isp4sd_pwron_and_init() error path

Yifei Gao <gyf161023@gmail.com>
    media: amd: isp4: release partial allocations in isp4if_alloc_fw_gpumem()

Yuho Choi <dbgh9129@gmail.com>
    hwrng: imx-rngc - Disable clock on registration failure

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - remove dead ADF_HEX code

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: qat - use 2-arg strscpy where destination size is known

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Flush context cache with correct SID when tearing down aliases

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Tear down scalable-mode context on probe failure

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix iopf_refcount leak on RID domain replacement

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear Present bit before tearing down copied context entry

Desnes Nunes <desnesn@redhat.com>
    iommu/vt-d: Fix UCTP context table slot when copying root entries

Andrew Jones <andrew.jones@oss.qualcomm.com>
    iommu/dma: Restore locking around msi_page_list

Karl Mehltretter <kmehltretter@gmail.com>
    fbdev: clps711x-fb: Remove unreachable unregister_framebuffer() call

Danila Chernetsov <listdansp@mail.ru>
    fbdev: kyro: Validate overlay viewport coordinates

Myeonghun Pak <mhun512@gmail.com>
    fbdev: tdfxfb: fix PCI enable cleanup with pcim_enable_device()

Fabrice Derepas <fabrice.derepas@canonical.com>
    apparmor: fix integer overflow in verify_tags() bounds check

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads

Ian Rogers <irogers@google.com>
    perf python: Fix memory leak in pyrf__metrics_cb

Ian Rogers <irogers@google.com>
    perf python: Fix count_values memory leak in pyrf_evsel__read

Ian Rogers <irogers@google.com>
    perf python: Validate attribute setters in pyrf_evsel

Ian Rogers <irogers@google.com>
    perf python: Validate CPU and thread maps in pyrf_evsel__open

Ian Rogers <irogers@google.com>
    perf python: Handle Py_None for thread and cpu maps

Ian Rogers <irogers@google.com>
    perf python: Check counts_values size in set_values

Ian Rogers <irogers@google.com>
    perf test: Fix skiplist leak in cmd_test

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix uninitialized pthread_join

Ian Rogers <irogers@google.com>
    perf python: Fix memory leak in pyrf_evlist__get_pollfd

Ian Rogers <irogers@google.com>
    perf tools: Fix sb_evlist leaks in top and record

Ian Rogers <irogers@google.com>
    perf stat: Fix evsel_list leak in cmd_stat

Ian Rogers <irogers@google.com>
    perf script: Fix metric_evlist leak in script_find_metrics

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add SATA regulator supplies

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add vcc-supply to GPIO expander

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add vcc-supply to EEPROM

Tomáš Macholda <tomas.macholda@nic.cz>
    arm64: dts: turris-mox: fix usb3 phys

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    i3c: renesas: Don't register devices when ENTDAA times out

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    i3c: renesas: Follow a unified pattern for transfer and command initialization

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    i3c: renesas: Return immediately if there is no transfer

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    bpf: Fix mmap_lock leak in irq_work path

Guodong Xu <guodong@riscstar.com>
    riscv: cpufeature: Clarify ISA spec version for canonical order

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_api: fix teardown of an adopted proto on insert-race loss

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: gp2ap002: re-enable irq if runtime suspend fails

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: gp2ap002: Fix unbalanced runtime PM on repeated event writes

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: opt4060: Fix pointer type passed to div_u64_rem()

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix storage null-ptr-deref after replacing prog

Alvin Šipraga <alvin.sipraga@analog.com>
    pinctrl: fix PINCTRL_GENERIC_MUX not always being selectable

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: MSFT: validate evt_prefix_len against the response length

Guangshuo Li <lgs201920130244@gmail.com>
    Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: MGMT: free the HCI command when it is cancelled

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: MGMT: free the mesh send cancel command when it is cancelled

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_sync: free the advertising instance on the failure and cancel paths

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_conn: fix the SCO setup context lifetime

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btintel: Fix diagnostics event detection

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: use proto_lock for l2cap_data to fix l2cap_disconn_ind

HyeongJun An <sammiee5311@gmail.com>
    Bluetooth: virtio_bt: avoid OOB read of build info string

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: fix edge-triggered interrupts handling

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: fix IRQ mask/unmask code

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: add missed IRQ resource helpers

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: fix getting gpiochip/pinctrl pointers in the IRQ handling code

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: add missed get_direction() function for gpio_chip

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix spi group pins

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix muxing of non-gpio default pins

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7581: fix mux/conf of pcie_reset pins

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix I2C0_SDA_PD register bit order

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7581: fix pinconf of i2c_scl/i2c_sda pins

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: fix mdio bitfield names

Aaron Tomlin <atomlin@atomlin.com>
    perf sched: Handle missing trace samples in pipe mode

Aaron Tomlin <atomlin@atomlin.com>
    perf sched: Suppress latency table output when trace samples are missing

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()

Qu Wenruo <wqu@suse.com>
    btrfs: use aligned range for locking in extent_fiemap()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't clobber the extent buffer when zeroing it out

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: flush active metadata block group at btree_writepages() start

Yichong Chen <chenyichong@uniontech.com>
    btrfs: retry verity reads for not-uptodate Merkle folios

Leo Martins <loemra.dev@gmail.com>
    btrfs: replace writeback inhibition xarray with a fixed inline buffer

Sun YangKai <sunyangkai@fnnas.com>
    btrfs: check if root is readonly when setting posix acl

Qu Wenruo <wqu@suse.com>
    btrfs: make sure EXTENT_BUFFER_READING is cleared under refs_lock

Qu Wenruo <wqu@suse.com>
    btrfs: fix a lockdep caused by path resolution during device scan

Qu Wenruo <wqu@suse.com>
    btrfs: always wait for ordered extents to avoid OE races

Filipe Manana <fdmanana@suse.com>
    btrfs: defrag: fix deadlock between defrag and delalloc space reservation

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't force read-only on transient -EAGAIN from reloc merge

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix sd_done() sense handling condition

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix error handling in sd_probe() after large pool creation failure

Tanushree Shah <tshah@linux.ibm.com>
    perf trace-event: Fix integer truncation in do_read() and skip()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: Record matched usb_device_id into btusb_data

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: Fix BD_ADDR byte order in btusb_set_bdaddr_wcn6855()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btqca: Fix qca_set_bdaddr() waiting for wrong HCI event

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    sched/fair: Check CPU capacity before comparing group types during load balance

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    sched/fair: Also gate overloaded status update for SD_ASYM_CPUCAPACITY

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix stop/start with no update

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Use bitwise access for PERF_HES_STOPPED

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Factor out pt_config_enable()

Yuho Choi <dbgh9129@gmail.com>
    ACPI: video: Release PCI device reference after lookup

surendra <kr494167@gmail.com>
    thermal/drivers/spacemit: Validate clamped trip thresholds

Kazuma Kondo <kazuma-kondo@nec.com>
    ACPI: PCI: Avoid misleading _OSC messages for non-PCIe host bridges without _OSC

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas675x: sort the register default table

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    regulator: qcom-rpmh: Fix PMIC5 BOB bypass mode handling

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: Fix exception table metadata for arena load-acquire

Daniel Borkmann <daniel@iogearbox.net>
    bpf, x86: Fix exception table metadata for arena load-acquire

Daniel Borkmann <daniel@iogearbox.net>
    bpf, riscv: Add and use bpf_atomic_is_load_acq() helper

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Reject load-acquire from pointers requiring fault protection

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Disable driver unbind to avoid UAF

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Fix a NULL pointer dereference on unbinding after an error interrupt

James Clark <james.clark@linaro.org>
    perf: arm_pmuv3: Zero initialize hw_id branch stack field

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix leaked trace id

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix underflow for usage of (nrseqstate - 1)

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix wrong check of etm4x_sspcicrn_present()

Bruce Johnston <bjohnsto@redhat.com>
    md/raid1: don't set array_frozen in raid1_takeover()

Yu Kuai <yukuai@fygo.io>
    md/md-llbitmap: stop daemon timer rearm on destroy

Yu Kuai <yukuai@fygo.io>
    md/md-llbitmap: prevent create failure bitmap UAF

Yu Kuai <yukuai@fygo.io>
    md: avoid stale clone I/O accounting timestamps

Yu Kuai <yukuai@fygo.io>
    md: wait for behind writes before destroying bitmap

Yu Kuai <yukuai@fygo.io>
    md/raid5: round bitmap stripes with sector division

Esteban Urrutia <esteuwu@proton.me>
    phy: qcom: qmp-pcie: Add pcs_lane1 offset to V5 offsets

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom: qmp-usb: Fix possible NULL-deref on early runtime suspend

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom: snps-femto-v2: Fix possible NULL-deref on early runtime suspend

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom: qmp-usb-legacy: Fix possible NULL-deref on early runtime suspend

Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
    phy: qcom: sgmii-eth: vote for both voltage rails with correct current loads

Linkai Gong <gonglinkai@kylinos.cn>
    soc: fsl: qe: check platform_driver_register() in qe_ic_of_init()

Jan Kara <jack@suse.cz>
    ext4: fix transaction overflow during writeback

Jan Kara <jack@suse.cz>
    ext4: teach ext4_meta_trans_blocks() about number of allocated extents

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/mm: unpoison pages in memory-failure teardown

Yichong Chen <chenyichong@uniontech.com>
    hugetlbfs: release subpool on fill_super failure

Simon Glass <sjg@chromium.org>
    pinctrl: rockchip: Restrict the RV1103B 2-bit drive type to bank 2

Simon Glass <sjg@chromium.org>
    pinctrl: rockchip: Reset the pin count when recalculating SoC data

Prathamesh Shete <pshete@nvidia.com>
    pinctrl: tegra264: fix DAP2 DIN/DOUT pin assignment

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware_loader: do not queue completed sysfs fallback requests

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

Aksh Garg <a-garg7@ti.com>
    PCI: cadence: Fix host/endpoint dependencies for cadence-plat driver

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Use PFP on the compute queues too

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Fixup emitting SWITCH_BUFFER packets

Tanushree Shah <tshah@linux.ibm.com>
    perf trace-event: Fix buffer overflow in read_string()

Gerald Loacker <gerald.loacker@wolfvision.net>
    phy: rockchip: phy-rockchip-inno-csidphy: fix rk1808 hsfreq table

Felix Gu <ustc.gu@gmail.com>
    phy: sunplus: fix error handling in sp_uphy_init()

Felix Gu <ustc.gu@gmail.com>
    phy: renesas: rcar-gen2: Fix double of_node_put on phy creation failure

Biju Das <biju.das.jz@bp.renesas.com>
    phy: renesas: phy-rcar-gen3-usb2: Fix devm action registration for disabled VBUS regulator

Meghana Malladi <m-malladi@ti.com>
    arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: cix-ipbloq: Avoid build with 32bit archs

Jan Kara <jack@suse.cz>
    ext4: fix spurious message about orphan cleanup on RO fs

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Resize MST HDCP per-connector arrays to 32

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Fixup emit_cntxcntl()

Steve Dunnagan <sdunnaga@redhat.com>
    leds: gpio: Clear error pointers for skipped LEDs

Arnd Bergmann <arnd@arndb.de>
    leds: gpio: Make legacy gpiolib interface optional

Sven Peter <sven@kernel.org>
    mfd: macsmc: Fix key count endianness annotation

Qiang Yu <Qiang.Yu@amd.com>
    drm/amdgpu: read TRUNCATE_COORD_MODE on gfx12

Alex Deucher <alexander.deucher@amd.com>
    drm/gfx12: Program DB_RING_CONTROL

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mfd: iqs62x: Reject zero-length firmware records

Mark Brown <broonie@kernel.org>
    tools: Ensure tools copy of linux/filter.h exports the UAPI

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mfd: rave-sp: validate received frame payload lengths

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: hibernate: Restore DAIF state on error

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: hibernate: mask DAIF before restoring hibernated kernel

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: skip default WMM setup for AP_VLAN links

Leon Romanovsky <leon@kernel.org>
    RDMA/erdma: restrict the driver to little-endian systems

Petr Pavlu <petr.pavlu@suse.com>
    module/dups: Fix use-after-free in kmod_dup_req lifetime handling

Petr Pavlu <petr.pavlu@suse.com>
    module/dups: Inform duplicate requests about the result directly

Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
    module: use strscpy() to copy module names in stats and dup tracking

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    RDMA/siw: Fix use-after-free in siw_accept()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: post the full-feature receive buffers after session registration

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: delay the final Login Response until the session is registered

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: cadence_master: add BRA_NumBytes[8] support

Karl Mehltretter <kmehltretter@gmail.com>
    cpufreq: imx6q: fix out-of-bounds write when probed more than once

Karl Mehltretter <kmehltretter@gmail.com>
    cpufreq: imx6q: fix devres accumulation across driver rebind

Priya Bala Govindasamy <pgovind2@uci.edu>
    rust: cpufreq: Fix temporary write in Registration::bios_limit_callback

Priya Bala Govindasamy <pgovind2@uci.edu>
    rust: cpufreq: Add CPUFREQ_TABLE_END as last table entry in TableBuilder::to_table

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: hdmi-phy: Fix H6 8-bit MPLL config at 594 MHz

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: Drop node references while building component list

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: dw-hdmi: Drop TCON TOP port reference

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: tcon: Drop remote endpoint reference

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: crtc: Propagate layer initialization error

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: hdmi: Don't leak sync polarity bits into packet control

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: tcon: Drop TCON TOP device reference

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: tcon: Set output mux for DSI and LVDS

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: tcon-top: Keep mixer routes distinct

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: vi scaler: Restore opaque alpha in video modes

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: vi scaler: Fix coefficient selection

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: Fix V3s YUV scanline size

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Clean up registered formats on c2c_hists__init() and c2c_hists__reinit() failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Fix error masking, OOM, and unchecked caller errors in hpp_list__parse()

Alexey Charkov <alchark@flipper.net>
    clk: rockchip: rk3576: fix source muxes for SPI0..SPI4

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix sleepable check for tracing/lsm prog

Jiri Olsa <jolsa@kernel.org>
    bpf: Clear buf on error in __bpf_get_task_stack

Jiri Olsa <jolsa@kernel.org>
    bpf: Remove trace_in argument from __bpf_get_stack

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor callchain_finalize function from __bpf_get_stack

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor callchain_store function from __bpf_get_stack

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: o2hb: quiesce negotiate handlers and timeout work

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: synchronize heartbeat callbacks with o2net teardown

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf libbfd: Fix memory leaks and NULL fclose in BPF disassembly

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Add PROG_TAGS to required arrays in __bpf_event__print_bpf_prog_info()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf header: Use write lock when translating BPF prog info pointers

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf libbfd: Validate BPF prog info arrays before pointer cast

Farhan Ali <alifm@linux.ibm.com>
    vfio/pci: Avoid mapping BARs for devices with non-mappable BARs

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9484/1: enable interrupts when unhandled user faults are triggered

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9483/1: select HAVE_POSIX_CPU_TIMERS_TASK_WORK

Linus Walleij <linusw@kernel.org>
    ARM: 9481/2: breakpoint: CFI breakpoints only on demand

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Hold QP references for AE and CM processing

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Hold CQ references when processing EQ events

Yuntao Wang <yuntao.wang@linux.dev>
    kbuild: fix modules.builtin(.modinfo) targets in the top-level Makefile

Robertus Diawan Chris <robertusdchris@gmail.com>
    modpost: prevent leak when early return no suffix .o in read_symbols()

Sergei Litvin <litvindev@gmail.com>
    scripts/tags.sh: Prevent binary files appearing in cscope.files

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    intel_idle: Avoid using deep idle states during initialization

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    xen/xenbus: check otherend_id only after it has been initialized

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: hwmon: Remove hwmon class device along with its parent

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Check load-acquire src ptr type before the load

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: correct FRTS vidmem offset calculation

John Hubbard <jhubbard@nvidia.com>
    gpu: nova-core: clean up FSP FRTS comments

Zhi Wang <zhiw@nvidia.com>
    gpu: nova-core: factor out common FSP message header

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: stream: Fix possible short reads/writes

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: stream: Restore consumer if copying from iter fails

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: talos-evk: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sa8155p-adp: Fix swapped USB and UFS QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: eliza-mtp: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: kaanapali: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sar2130p: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8650: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: purwa: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: hamoa: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sc7280: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sc7180: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs6490: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcm6490: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs8550-aim300: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8450: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8350: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8150: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sdm850: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sdm845: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sa8540p: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp-blackrock: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix ternary operator precedence in ksm_tests

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: handle EINVAL when configuring gigantic hugepages

Hongfu Li <lihongfu@kylinos.cn>
    selftests/mm: fix memleak in migration benchmark

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix invalid storage access after __cgroup_bpf_attach failed

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Add lockdown checks to legacy I/O and memory handlers

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Return -EINVAL for unsupported I/O BAR mmap

Jackie Dong <xy-jackie@139.com>
    ALSA: hda/realtek: ALC269 fixup for Yoga/Legion Mic noise

Imran Shaik <imran.shaik@oss.qualcomm.com>
    arm64: dts: qcom: agatti: Add missing CX power domain to DISPCC

Christoph Hellwig <hch@lst.de>
    block: handle nogenerate/noverify properly in fs-integrity

Christoph Hellwig <hch@lst.de>
    block: lift BIP_CHECK_FLAGS to include/linux/bio-integrity.h

Christoph Hellwig <hch@lst.de>
    block: remove bip_should_check

Yang Xiuwei <yangxiuwei@kylinos.cn>
    ublk: clear auto buf reg before updating io->buf in batch commit

Andreas Kemnade <andreas@kemnade.info>
    drm/omap: dsi: Do not copy isr table

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: sophgo: cv180x: Allow the DMA multiplexer to set channel number for DMA controller

Ning Ding <dingning04@gmail.com>
    bpf: Invalidate RCU pointers after final spin unlock

Yichong Chen <chenyichong@uniontech.com>
    fat: release buffer head after rebuilding parent

Guangshuo Li <lgs201920130244@gmail.com>
    rapidio: clear mport->net when rio_add_net() fails

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate external xattr entries when reading metadata

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate inline xattrs during inode block validation

Calvin Owens <calvin@wbinvd.org>
    pps-gpio: remove dead capture_clear code

Michael Byczkowski <by@by-online.de>
    pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler

Calvin Owens <calvin@wbinvd.org>
    pps: don't try to wait for negative timeouts in PPS_FETCH

Bradley Morgan <include@grrlz.net>
    lib/string: fix memchr_inv() for large ranges

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: keep heartbeat local node stable

Yang Xiuwei <yangxiuwei@kylinos.cn>
    ublk: validate auto buf reg before taking uring_cmd

Caleb Sander Mateos <csander@purestorage.com>
    ublk: check for ublk_unmap_io() returning 0

Caleb Sander Mateos <csander@purestorage.com>
    ublk: check import_ubuf() return value

Tao Cui <cuitao@kylinos.cn>
    block/kyber-iosched: flush per-cpu latency buckets over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-iocost: collect per-cpu latency stats over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-iolatency: account per-cpu latency stats over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-stat: drain per-cpu callback stats over possible CPUs

Zheng Qixing <zhengqixing@huawei.com>
    blk-cgroup: skip dying blkg in blkcg_activate_policy()

Zheng Qixing <zhengqixing@huawei.com>
    blk-cgroup: fix race between policy activation and blkg destruction

Breno Leitao <leitao@debian.org>
    phonet: pep: do not write beyond optlen in getsockopt

Zxyan Zhu <zxyan0222@gmail.com>
    net: stmmac: Skip PHY attach if custom PCS is in use

Sang-Heon Jeon <ekffu200098@gmail.com>
    iio: light: tsl2583: return zero in write_raw() on success

Sang-Heon Jeon <ekffu200098@gmail.com>
    iio: light: isl29028: return zero in write_raw() on success

Yuanshen Cao <alex.caoys@gmail.com>
    iio: light: tsl2772: fix ALS calibscale readback

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf arm-spe: Reject zero nr_cpu in metadata to prevent division by zero

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf intel-bts: Fix off-by-one in auxtrace_info minimum size check

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf intel-pt: Fix off-by-one in auxtrace_info minimum size check

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf auxtrace: Fix queue grow overflow and old array leak

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf thread-stack: Fix heap buffer overflow on branch stack wrap copy

Jiancheng Huang <jchuang@seu.edu.cn>
    HID: lg4ff: validate report length before fixed offsets

Chao Huang <huangchao@kylinos.cn>
    HID: i2c-hid: goodix: Disable VDD on VDDIO enable failure

Rosalie Wanders <rosalie@mailbox.org>
    HID: sony: add missing __packed to struct with static_assert()

Vicki Pfau <vi@endrift.com>
    HID: steam: Reject short reads

Vicki Pfau <vi@endrift.com>
    HID: steam: Improve logging and other cleanup

Vicki Pfau <vi@endrift.com>
    HID: steam: Add support for sensor events on the Steam Controller (2015)

Vicki Pfau <vi@endrift.com>
    HID: steam: Rename some constants that got renamed upstream

Vicki Pfau <vi@endrift.com>
    HID: steam: Refactor and clean up report parsing

Ai Chao <aichao@kylinos.cn>
    HID: i2c-hid: Fix "(null)" output when reading report descriptor fails

Yousef Alhouseen <alhouseenyousef@gmail.com>
    HID: synchronize input before cleaning up a failed probe

谢致邦 (XIE Zhibang) <Yeking@Red54.com>
    HID: i2c-hid: Refactor _DSM helper and add i2c-hid-acpi-prp0001 driver

Haoxiang Li <haoxiang_li2024@163.com>
    HID: logitech-hidpp: Fix FF device cleanup on init failure

Denis Benato <denis.benato@linux.dev>
    HID: asus: fix a off-by-one in mcu_parse_version_string() validation

Denis Benato <denis.benato@linux.dev>
    HID: asus: refactor the two workqueues and init sequence

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Fix unmap potentially unmapping the wrong iATU

Linmao Li <lilinmao@kylinos.cn>
    platform: arm64: qcom-hamoa-ec: reject incomplete responses

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Flush cached MSI write before unmapping the iATU

Niklas Cassel <cassel@kernel.org>
    misc: pci_endpoint_test: Check SUCCESS bit for doorbell status

Shukai Ni <shukai.ni@kuleuven.be>
    dm-integrity: replace forgeable discard filler with a keyed sector marker

Karl Mehltretter <kmehltretter@gmail.com>
    tty: clear cdev pointer after cdev_add() failure

Karl Mehltretter <kmehltretter@gmail.com>
    tty: skip cdev_del() when no cdev is registered

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: clear freed pointers on uart_register_driver() failure

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: do fallible allocations before the console can be registered

Karl Mehltretter <kmehltretter@gmail.com>
    serial: amba-pl011: keep console clock enabled for atomic writes

Karl Mehltretter <kmehltretter@gmail.com>
    serial: amba-pl011: unprepare console clock on unregister

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    soc: fsl: qe: implement get_direction()

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    soc: fsl: qe: properly scan GPIO nodes at startup

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    powerpc/irq: Fix missing r2 clobber in PCREL inline assembly

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    powerpc64/bpf: Fix build break for arch_bpf_timed_may_goto

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc64/bpf: Fix build break in bpf_jit_emit_func_call_rel()

Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
    powerpc/syscall: Fix syscall skip handling for seccomp and ptrace

Gou Hao <gouhao@uniontech.com>
    powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: propagate IPI init errors to prevent use-after-free

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: add error return value to xive_smp_probe()

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: make xive IPI allocation NULL-safe

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    pinctrl: spacemit: validate pins in pinconf callbacks

Surendra Singh Chouhan <kr494167@gmail.com>
    pinctrl: generic: free maps on pinctrl_generic_to_map() failure

Yulin Lu <luyulin@eswincomputing.com>
    pinctrl: eswin: Fix Handling of PIN_CONFIG_PERSIST_STATE

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix symbol resolution for duplicate data symbols

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Add .klp.symid for sympos disambiguation

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix false module dependencies caused by dead relocs

Joe Lawrence <joe.lawrence@redhat.com>
    objtool/klp: Normalize Module.symvers paths to module names

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix module name normalization for paths with dots

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    firmware: coreboot: Validate table bounds

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix mmap_lock deadlock on arena lock failure

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: stop PMSR before P2P and NAN teardown

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: disconnect on CSA to channel 0

Jason Huang <jason.huang2@infineon.com>
    wifi: brcmfmac: fix P2P action frame handling without device vif

Namhyung Kim <namhyung@kernel.org>
    perf build: Fix a build error on 32-bit x86

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: skip unused probe response countdown offsets

Slawomir Stepien <sst@poczta.fm>
    wifi: zd1211rw: reject secondary interfaces to prevent conflicts

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: clean up color-change beacon data on errors

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: send TWT teardown to peer after setup TX failure

Davidlohr Bueso <dave@stgolabs.net>
    perf/cxlpmu: Fix 64-bit write to 32-bit HDM filter register

Pranjal Shrivastava <praan@google.com>
    iommu/arm-smmu-v3: Convert to use atomic poll timeout

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Don't write to P0 in irritator on SME only systems

Will Deacon <will@kernel.org>
    arm64: ptrace: Keep 'orig_x0' in-sync with x0 on syscall entry

Karl Mehltretter <kmehltretter@gmail.com>
    kselftest/arm64: fp-ptrace: Fix checks for inactive SVE and SSVE regsets

Karl Mehltretter <kmehltretter@gmail.com>
    arm64/fpsimd: ptrace: Fix inactive SVE and SSVE regsets

Shanker Donthineni <sdonthineni@nvidia.com>
    arm_mpam: Apply T241-MPAM-6 to 63-bit counters

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: smp: Fix IPI teardown for GICv5 flow

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations

Linghui Wu <linghui.wu@oss.qualcomm.com>
    wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump

Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
    wifi: ath12k: fix encrypted EAPOL TX in encap offload mode

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: reject out-of-range link ids in mt76_vif_link()

shengwei.lu <shengwei.lu@mediatek.com>
    wifi: mt76: mt7925: Fix EHT Beamformee SS subfields to meet 802.11be minimum

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: fix queue assignment for disassoc packets

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: report RX chain signal for all RX paths

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: do not leave state behind after a failed WED attach

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: fix reg addr remap when addr is 0

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: release hif2 reference on probe IRQ failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix ext PHY use-after-free on register error path

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix double hif2 init on the non-WED path

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix MIB TX aggregation counter registers for mt7990

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: set MT76_SCANNING when starting a hw scan

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: clear stale link state on full reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: free vif links after clearing wcid entries on full reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: wake MCU waiters before aborting scan in L1 SER

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: skip key upload when adding an offchannel link

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement

Yonghong Song <yonghong.song@linux.dev>
    bpf, x86: Fix trampoline stack size for 128-bit arguments

Yonghong Song <yonghong.song@linux.dev>
    bpf: Reject >8 byte return values on return-reading trampoline paths

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Check snprintf truncation for guest kallsyms path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Free scandir entries in guest kernel map creation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Reset errno before strtol in guest kernel map creation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Don't abort guest map creation on first inaccessible dir

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Check snprintf truncation in machines__findnew()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Guard against NULL strlist in machines__findnew()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Fix NULL parent dereference in fork event processing

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Fix fd leak on bounds check in maps__set_modules_path_dir()

Michael Liang <mliang@purestorage.com>
    perf libdw: Fix outer-frame name resolution and spurious "(inlined)" tag

Alessio Podda <aleph.pi.gh@gmail.com>
    perf unwind-libdw: Fix unwinding of multi-threaded processes

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Add missing stub for sdca_fdl_free_state()

Joy Zou <joy.zou@oss.nxp.com>
    regulator: core: use system_freezable_wq for init complete work

Ashish Mhetre <amhetre@nvidia.com>
    arm64: tegra: Fix CMDQV interrupt type on Tegra264

Yuho Choi <dbgh9129@gmail.com>
    ARM: tegra: Fix OF node reference leaks in IRQ init

Andrey Golovko <andrey.golovko@gmail.com>
    ASoC: tas2783-sdw: drop stale regcache on uninitialized re-attach

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: codecs: tas2783-sdw: Propagate regcache_sync() errors

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix leak in ath11k_service_ready_ext_event()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dsi: Drop dev_pm_opp_set_rate(0)

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dp: Drop dev_pm_opp_set_rate(0)

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dpu: Drop sneaky dev_pm_opp_set_rate(0)

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Make wakeup range check overflow safe

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dp: do not reject wide-bus modes while a YUV420 mode is active

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dp: reject YUV420-only modes without VSC SDP support

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm: don't tear down KMS twice when KMS init fails

Yongxing Mou <yongxing.mou@oss.qualcomm.com>
    drm/msm/dpu: Fix DMA SSPP REC block offsets on DPU v13

Can Peng <pengcan@kylinos.cn>
    ACPI: processor: Unregister cpufreq notifier on init failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: only consume the WO drop bit on WED v2 devices

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: add missing rdd_idx check when enabling background radar

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: use little-endian for bss_info_ra wire fields

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: report data NSS for STBC frames in RX rate decode

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: cancel reset and rc work on device unregister

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: don't leak MLD group index on remap alloc failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix ER-SU 106-tone RU check in RX rate decode

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: decode the full VHT Rx STBC capability field

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unwind state on add_interface failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix out-of-bounds access in mmio copy helpers

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix HE DCM max-RU capability encoding

Rex Lu <rex.lu@mediatek.com>
    wifi: mt76: check txfree done event on the WED hw path

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix RXDMAD_C buffer recycling race

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix uninitialised RXDMAD_C descriptor info

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix stranded frames in mt76_txq_schedule_pending

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix 4th chain ACK RSSI bitmask in sta_poll

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: write RX header translation bit to the correct register

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: don't report a zero TX bitrate

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: clear wcid mask under mutex after RCU pointer clear

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]

Michael-CY Lee <michael-cy.lee@mediatek.com>
    wifi: mt76: assign link_id when sending probe request during scan

Michael-CY Lee <michael-cy.lee@mediatek.com>
    wifi: mt76: fix non-AQL packet accounting for MLO stations

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP

Rex Lu <rex.lu@mediatek.com>
    wifi: mt76: fix RX data queuing of RRO 3.0

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: fix capability of EHT-MCS 15 in MRU

Chad Monroe <chad@monroe.io>
    wifi: mt76: mt7996: fix non-MLD station num_sta leak

Chad Monroe <chad@monroe.io>
    wifi: mt76: mt7996: fix EAPOL source BSS for non-MLD stations

Eason Lai <Eason.Lai@mediatek.com>
    wifi: mt76: mt792x: Fix memory leak in SDIO TX path

Jared.Huang <jared.huang@mediatek.com>
    wifi: mt76: mt7925: fix msg len mismatch between driver and firmware

Jared.Huang <jared.huang@mediatek.com>
    wifi: mt76: mt7925: update clc before setting sar power table

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7927: set band index for sniffer mode

Eason Lai <Eason.Lai@mediatek.com>
    wifi: mt76: mt7921: Add PCIe AER handler support to prevent system crash

Eason Lai <Eason.Lai@mediatek.com>
    wifi: mt76: mt792x: fix use-after-free in mt76_rx_poll_complete

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: add init_wiphy callback

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7925: add NAN MCU helpers

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: connac: add NAN connection type

Zhi-Jun You <hujy652@gmail.com>
    wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: validate CLC firmware records

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: stop USB register access after bus hang

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: fix handling channel context with different bands in mt76_switch_vif_chanctx()

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length

Dmitry Gomzyakov <nicerok11@gmail.com>
    wifi: mt76: connac: add MT7991A (0x7991) to is_mt7996()

Yichong Chen <chenyichong@uniontech.com>
    fanotify: report full event length for FIONREAD

Muhammad Usama Anjum <usama.anjum@arm.com>
    misc: sgi-gru: remove interrupt-context page-table walks

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    misc: vmc_vmci: Fix potential memory leak in vmci_event_subscribe()

Jinjie Ruan <ruanjinjie@huawei.com>
    powerpc/crash: Fix possible memory leak in update_crash_elfcorehdr()

Rosen Penev <rosenp@gmail.com>
    powerpc/44x: Set GPIO chip parent

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    powerpc: implement get_direction() in cpm2

Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
    dma-resv: Fix undefined symbol when CONFIG_DMA_SHARED_BUFFER is disabled

Brian Foster <bfoster@redhat.com>
    iomap: release the folio batch on iomap callback failures

Karl Mehltretter <kmehltretter@gmail.com>
    dcache: keep shrink_dcache_for_umount() making progress on busy roots

Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
    locking/lockdep: Fix NULL pointer dereference in __lock_set_class()

Komal Bajaj <komal.bajaj@oss.qualcomm.com>
    pinctrl: qcom: shikra: Fix intr_target_width for summary interrupt routing

Martin Wilck <mwilck@suse.com>
    md/raid1: create serial pool adding rdev to array with serialize_policy=1

Yu Peng <pengyu@kylinos.cn>
    fs: annotate inode timestamp accessors

Can Peng <pengcan@kylinos.cn>
    i3c: master: adi: add OF module alias for autoloading

Jakub Kicinski <kuba@kernel.org>
    i3c: dw: avoid shift-out-of-bounds when DAA assigns no devices

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    swiotlb: Preserve allocation virtual address for dynamic pools

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    iommu/dma: Check atomic pool allocation result directly

Chen Cheng <chencheng@fnnas.com>
    md: scope memalloc_noio to allocation critical sections

Chen Cheng <chencheng@fnnas.com>
    md/bitmap: resume array on backlog_store() error path

Vladimir Zapolskiy <vz@kernel.org>
    clk: qcom: Return expected ENOMEM error on dynamic allocation failure

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: gpucc-qcm2290: Park RCG's clk source at XO during disable

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: gpucc-qcm2290: Keep the critical clocks always-on from probe

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: gpucc-qcm2290: Move to the latest common qcom_cc_probe() model

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: gpucc-qcm2290: Drop pm_clk handling

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: qcm2290: Update DISPCC and GPUCC GDSC *wait_val values

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: qcm2290: Add RETAIN_FF_ENABLE flag for DISPCC and GPUCC GDSCs

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: qcm2290: Set POLL_CFG_GDSCR flag for DISPCC and GPUCC GDSCs

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: dispcc-qcm2290: Enable runtime PM support

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: dispcc-qcm2290: Move to the latest common qcom_cc_probe() model

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: negcc-nord: keep GPU2 CFG clock enabled via critical CBCR

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gcc-nord: mark PCIe link clocks as critical

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: negcc-nord: use clk_regmap_phy_mux for USB3 pipe clock srcs

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: nord: use BRANCH_HALT_SKIP for PHY pipe clocks

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: eliza: Add fallback compatible for ADSP remoteproc

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone

Alexis Savery <asavery@google.com>
    platform/chrome: lightbar: Limit payload to max packet size

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF when reading bpf link info

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF in bpf_netns_link_update_prog

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: sc2731_charger: cancel work on remove

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: isp1704_charger: cancel work on remove

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs6490-rb3gen2-industrial-mezzanine: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs6490-rb3gen2: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs6490-thundercomm-minipc-g1iot: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs6490-radxa-dragon-q6a: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: lemans-evk-ifp-mezzanine: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: monaco-evk-ifp-mezzanine: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: monaco-monza-som: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: monaco: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: talos: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8650: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sar2130p: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: kodiak: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: kaanapali: Fix the PCIe iommu-map entries

Dawid Wróbel <me@dawidwrobel.com>
    arm64: dts: qcom: sm8250-xiaomi-elish: correct the board ID

Imran Shaik <imran.shaik@oss.qualcomm.com>
    arm64: dts: qcom: talos: Fix cpu6 1094.4MHz OPP frequency typo

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Fix PDC IRQ mapping

Keith Busch <kbusch@kernel.org>
    block: fix dio leak on metadata mapping error

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom: scm: Fix tzmem state on probe retry

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom: scm: Fix reserved memory cleanup on probe failure

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published

Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>
    firmware: qcom: scm: instrument SMC call path with tracepoints

Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>
    firmware: qcom: scm: add trace events for the SMC call interface

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en

Pradyot Kumar Nayak <pradyot.nayak@oss.qualcomm.com>
    arm64: dts: qcom: glymur-crd: Add FocalTech ft3d81 touchscreen support

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    soc: qcom: pmic_glink_altmode: Define the TBT extradata properly

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    clk: qcom: gcc-qcm2290: don't park QUP RCGs upon registration

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    arm64: dts: qcom: qcs404: Fix DTBS Check errors in usb controller nodes

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sdm632-motorola-ocean: Fix LED default trigger property

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8976-longcheer-l9360: Fix accidental node override

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8998: Don't pull-up I2C pins by default in sleep

Itai Handler <itai.handler@gmail.com>
    rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: dwc: ep: Clear MSI iATU mapping in dw_pcie_ep_cleanup()

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: consistently fail atomic writes that require splitting

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1: restrict atomic write limits and handle runtime constraints

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()

Fushuai Wang <wangfushuai@baidu.com>
    Revert "serial: 8250: Clear CON_PRINTBUFFER on port re-registration"

Cheng-Han Wu <hank20010209@gmail.com>
    selftests/zram: fix kernel_gte() for POSIX sh

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md: recheck spare changes before starting sync

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md: remove REQ_NOWAIT support from raid1/10/456

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc/powerpc: mark ctr and xer as clobbered by system call

Yichong Chen <chenyichong@uniontech.com>
    fanotify: stop permission watchdog when timeout is zero

Chen Cheng <chencheng@fnnas.com>
    md/raid5: protect lockless recovery_offset accesses during reshape

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: fix ETS QoS stats counter underflow and cross-channel corruption

Chen Cheng <chencheng@fnnas.com>
    md/raid5: fix lockless max_nr_stripes reads

Sajal Gupta <sajal2005gupta@gmail.com>
    md/raid5-ppl: fix use-after-free in ppl_do_flush()

Chen Cheng <chencheng@fnnas.com>
    md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency

Yuho Choi <dbgh9129@gmail.com>
    bus: mhi: host: Fix controller cleanup on EDL sysfs failure

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    bus: mhi: host: Flush the posted write after writing to MHI_SOC_RESET_REQ_OFFSET

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtlwifi: pci: fix error path in rtl_pci_probe()

Hongyan Xu <getshell@seu.edu.cn>
    platform/chrome: cros_ec_debugfs: Unregister panic notifier

Hongyan Xu <getshell@seu.edu.cn>
    platform/chrome: cros_ec_debugfs: Clean up console log on probe failure

Surendra Singh Chouhan <kr494167@gmail.com>
    regulator: tps65185: handle gpiod_get_value_cansleep() error returns

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Pass --eh-frame-hdr to the linker

Dan Carpenter <error27@gmail.com>
    media: stm32: dcmi: fix some error handling bugs in probe()

Hungyu Lin <dennylin0707@gmail.com>
    media: qcom: iris: handle runtime PM resume failure in core deinit

Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
    media: qcom: iris: Remove duplicate HFI_PROP_OPB_ENABLE entry

Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
    media: qcom: iris: Fix bitmask test in iris_allow_cmd()

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: remove objects from evit list after pinning them

Ali Tariq <alitariq45892@gmail.com>
    PCI: starfive: Fix unchecked pm_runtime_get_sync() in probe

Ali Tariq <alitariq45892@gmail.com>
    PCI: starfive: Fix Runtime PM handling and teardown ordering

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: validate TLV length in process_tpc_stats()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: Add vm_bind region with kbo range overlap check

Fan Wu <fanwu01@zju.edu.cn>
    spi: davinci: switch to managed controller allocation

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: reject out-of-range mdts values in configfs store

Guixin Liu <kanie@linux.alibaba.com>
    nvme-pci: return error when parsing a quirk string fails

Guixin Liu <kanie@linux.alibaba.com>
    nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: fix return status of RMI log page on allocation failure

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: reject login PDUs declaring more data than was received

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: reject PDUs declaring more data than was received

Cong Nguyen <congnt264@gmail.com>
    media: staging/ipu7: fix async notifier leak on init error

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: free STAG index when TPT entry write fails

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Send cong param changes to the resolved port mdev

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: spacemit: Make dtschema recognize the etherent PHY correctly on K3 com260 board

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: spacemit: Make dtschema recognize the etherent PHY correctly on K3 pico-itx board

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    clk: spacemit: k3: fix missing /2 factor in i2s sysclk dividers

David Strahan <David.Strahan@microchip.com>
    scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch

David Lee <david.lee@trailofbits.com>
    nilfs2: prevent out-of-bounds read in super root block parsing

Joshua Crofts <joshua.crofts1@gmail.com>
    nilfs2: fix infinite loop in nilfs_clean_segments()

Alexey Charkov <alchark@flipper.net>
    clk: rockchip: Fractional PLL coefficient on RK3588/RK3576 is two's complement

Alexey Charkov <alchark@flipper.net>
    clk: rockchip: Fix the fractional part denominator on RK3588/RK3576 PLLs

Gary Guo <gary@garyguo.net>
    PCI: Fix UAF when probe runs concurrent to dyn ID removal

Gary Guo <gary@garyguo.net>
    PCI: Fix dyn_id add TOCTOU

Gary Guo <gary@garyguo.net>
    PCI: Make pci_match_one_device() match on ID instead of device

Akari Tsuyukusa <akkun11.open@gmail.com>
    clk: mediatek: mt8135: Fix inverted gate control for devapc_ck

longlong yan <yanlonglong@kylinos.cn>
    clk/x86: pmc_atom: add kasprintf return value check

Myeonghun Pak <mhun512@gmail.com>
    clk: palmas: Manage external-control prepare with devm

Kostas Damaskinakis <kostas.damaskinakis@gmail.com>
    clk: eswin: Zero-initialize stack-allocated clk_init_data

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    clk: mediatek: pllfh: Fix IO remapping leak in register_pllfhs error path

Guangshuo Li <lgs201920130244@gmail.com>
    clk: tegra: tegra124-emc: put EMC node on register failure

Ondrej Jirman <megi@xff.cz>
    arm64: dts: allwinner: sun50i-a64-pinephone: Fix mpu6050 mount matrix

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: fix per-STA profile length in cross-link CSA parsing

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: dcmi: fix error handling on MDMA pool alloc failure

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Fix PBL chunk length computation

Peiyang He <peiyang_he@smail.nju.edu.cn>
    RDMA/rxe: Fix UAF in ODP init error-handling path

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Fix VINTF0 leak on the init-failure path

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Require exactly one Stream ID for a vSID

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Free the error IRQ before tearing down VINTFs

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Don't fall back to a freed smmu after devm_krealloc()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Don't run the error ISR before probe sets up vintfs

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Synchronize the error ISR against VINTF (de)init

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Publish an LVCMDQ only after it is fully initialized

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: reject restart table growth beyond U16_MAX entries

Ivy Lopez <skunkolee@gmail.com>
    staging: rtl8723bs: use kfree_sensitive() for key material

Ananthu C V <ananthu.cv@oss.qualcomm.com>
    arm64: dts: qcom: glymur: fix SoCCP memory mappings

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: qcom: q6v5: Request shutdown if crash is triggered host-side

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: qcom: pas: Add late attach support for subsystems

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Prevent crash handling to race with rproc_del()

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: core: Attach rproc asynchronously in rproc_add() path via schedule_work()

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Allow shutdown of crashed processors

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate: Set min_limit_freq based on bios_min_perf

Ian Rogers <irogers@google.com>
    perf annotate: Be robust to annotating without a thread

Ian Rogers <irogers@google.com>
    perf ui hists: In report UI ensure thread is set with reference counting

Alexandre Courbot <acourbot@nvidia.com>
    gpu: nova-core: fix packed registry table size

Zhi Wang <zhiw@nvidia.com>
    gpu: nova-core: build SetRegistry entries dynamically

Tejun Heo <tj@kernel.org>
    sched_ext: Abort directly from the hardlockup handler

Cheng-Yang Chou <yphbchou0911@gmail.com>
    sched_ext: Fix exit_cpu accuracy for lockup paths

Babanpreet Singh <bbnpreetsingh@gmail.com>
    w1: ds2482: Fix signedness bug in ds2482_w1_triplet()

Fan Wu <fanwu01@zju.edu.cn>
    spi: oc-tiny: switch to managed controller allocation

Myeonghun Pak <mhun512@gmail.com>
    clk: mediatek: mt6735: Unregister PLLs on probe failure

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI/pwrctrl: tc9563: Power off only the external ports in tc9563_pwrctrl_disable_port()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI/pwrctrl: tc9563: Fix parsing the integrated Ethernet MAC Endpoint node

Yichong Chen <chenyichong@uniontech.com>
    isofs: release zisofs block pointer buffer head

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: intel_rapl_tpmi: Handle PMU registration failure during probe

Rakesh Kota <rakesh.kota@oss.qualcomm.com>
    thermal/drivers/qcom-spmi-adc-tm5: Drop IIO_VAL_INT check in adc_tm5_get_temp

Christian Marangi <ansuelsmth@gmail.com>
    thermal/drivers/airoha: Fix copy paste error for sen internal

Christian Marangi <ansuelsmth@gmail.com>
    thermal/drivers/airoha: Fix copy paste error on clamp_t low temp

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: bus: Avoid confusing complaints regarding missing _OSC features

Maher Sanalla <msanalla@nvidia.com>
    RDMA/mlx5: Fix integer overflow of user QP buffer size

Can Peng <pengcan@kylinos.cn>
    crypto: keembay - publish OF module alias for OCS AES/SM4

Linmao Li <lilinmao@kylinos.cn>
    crypto: keembay - Initialize completion before requesting IRQ

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: debugfs: Reserve space for a string terminator

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: rpmb: Validate request frame length before parsing

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: core: Validate connected lane counts

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: Avoid NULL CQE dereference when reporting invalid tags

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: core: Validate string descriptors

Babanpreet Singh <bbnpreetsingh@gmail.com>
    power: supply: sbs-battery: Use a per-device serial number buffer

Kohei Enju <enju.kohei@fujitsu.com>
    arm64: RSI: fix field-spanning write warning in attestation token init

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: spacemit: Fix phy id check for the phy on com260 board

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: spacemit: Fix phy id check for the phy on pico-itx board

James Clark <james.clark@linaro.org>
    tools/build: Allow versioning of all LLVM tools defined in Makefile.include

Justin Yeh <justin.yeh@mediatek.com>
    pinctrl: mediatek: free EINT resources on unbind

Justin Yeh <justin.yeh@mediatek.com>
    pinctrl: mediatek: use devm_gpiochip_add_data() for GPIO chip

David Matlack <dmatlack@google.com>
    liveupdate: Remember FLB retrieve() status

David Matlack <dmatlack@google.com>
    liveupdate: Reference count outgoing FLB data

Jackie Liu <liuyun01@kylinos.cn>
    liveupdate: reject nonzero reserved value for SESSION_FINISH

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: spacemit: Add enough deassert time for the PHY on com260 board

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: spacemit: Add enough deassert time for the PHY on PICO ITX

Aurelien Jarno <aurelien@aurel32.net>
    riscv: dts: spacemit: improve RTL8211F PHY configuration on K3 Pico-ITX board

Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>
    power: reset: reboot-mode: Remove devres based allocations

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Fix use-after-free in find_pos_and_ways() error path

Julian Braha <julianbraha@gmail.com>
    pinctrl: fix unmet dependencies from missing GPIOLIB

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix memory leak on subtest_states reallocation

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix missing allocation null checks in test_progs.c

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix incorrect error checking for pthread_create

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix WARNING in bpf_tracing_link_release

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: lpc32xx: only run SoC init on LPC32xx hardware

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Fix CFI mismatch in task work callback

Fabio Estevam <festevam@gmail.com>
    arm64: dts: rockchip: Fix rk3566-bigtreetech-cb2 touchscreen property

Fabio Estevam <festevam@gmail.com>
    arm64: dts: rockchip: Fix Gru WLAN sideband interrupt

Damon Ding <damon.ding@rock-chips.com>
    arm64: dts: rockchip: Add missing hclk for RK3588 eDP1

Damon Ding <damon.ding@rock-chips.com>
    arm64: dts: rockchip: Add missing hclk for RK3588 eDP0

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix valid_size extension over a shared writable mapping

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: return PTR_ERR() from devm_drm_dev_alloc()

Weiming Wu <weiming3@asu.edu>
    fs/ntfs3: fix out-of-bounds read of INDEX_ROOT in reparse/objid init

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet

Can Peng <pengcan@kylinos.cn>
    drm/tve200: add OF module alias for autoloading

Aaron Tomlin <atomlin@atomlin.com>
    perf trace: Correct default cpumask formatting to hexadecimal

Ian Rogers <irogers@google.com>
    perf cap: Remove used_root parameter and simplify capability checks

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    ASoC: spacemit: rename clock inputs to match binding

Jerome Brunet <jbrunet@baylibre.com>
    clk: sunxi-ng: mux: fix determine helper rate propagation

Cosmo Chou <chou.cosmo@gmail.com>
    leds: pca9532: Fix phantom device registration on missing hardware

Malaya Kumar Rout <malayarout91@gmail.com>
    PM: hibernate: Fix memory leak in snapshot_write_next() error path

Leon Romanovsky <leon@kernel.org>
    RDMA/erdma: complete object teardown when the destroy command fails

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    xfrm: Fix skb double-free in xfrm_dev_direct_output()

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Avoid truncating AUX buffer sizes to int

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Flush thread stacks after decoder reset

Eliot Courtney <ecourtney@nvidia.com>
    gpu: nova-core: correct RISC-V HALTED field

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    riscv: dts: thead: th1520: remove pclk for I2C1

Junhui Liu <junhui.liu@pigmoral.tech>
    riscv: dts: spacemit: k1: Split gmac_clk_ref into independent pinctrl groups

Aurelien Jarno <aurelien@aurel32.net>
    riscv: dts: spacemit: set console baud rate on K3 Pico-ITX board

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    bitmap: Properly initialise destination bitmap for scatter & gather test

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unrequest devices if driver registration fails

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Roll back partial protocol table registration

EDAMAMEX <edame8080@gmail.com>
    cpufreq/amd-pstate: handle missing policy in dynamic EPP callbacks

Marco Scardovi <scardracs@disroot.org>
    cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems

Marco Scardovi <scardracs@disroot.org>
    cpufreq/amd-pstate: Fix EPP return type and handle errors during initialization

Qianheng Peng <pengqh1@chinatelecom.cn>
    cpufreq: amd-pstate-ut: Skip tests when amd-pstate driver is not active

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: allwinner: a10: Fix PMU interrupt

Zhang Yi <yi.zhang@huawei.com>
    ext4: skip tail block zeroing for inline data files

Xiang Mei <xmei5@asu.edu>
    ext4: check dir entry fits before reading the hash trailer in ext4_search_dir()

Guanghui Yang <3497809730@qq.com>
    ext4: fix buffer_head leak in ext4_init_orphan_info

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()

Matthew Leach <matthew.leach@collabora.com>
    wifi: ath12k: fix survey indexing across bands

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: Correctly copy the hint BSSID in WMI scan request

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: Correctly copy the hint BSSID in WMI scan request

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: refactor QMI memory assignment

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: switch to name-based reserved memory lookup

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath6kl: avoid buffer overreads in WMI event handlers

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: fix ML-STA authentication timeout on QCC2072

Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
    wifi: ath12k: advertise ieee_link_id in vdev start MLO params

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: ath12k: Set IEEE80211_OFFLOAD_ENCAP_4ADDR after tx_encap_type vdev param

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: ath12k: Advertise multicast Ethernet encapsulation offload support

Yao Kai <yaokai34@huawei.com>
    ext4: validate readdir offset before accessing dirent

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: use fsdata to track inline data write state and fix race

Baokun Li <libaokun@linux.alibaba.com>
    ext4: drain in-flight DIO before buffered write fallback

Gerald Yang <gerald.yang@canonical.com>
    ext4: clear stale xarray tags on folios skipped during writeback

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    thermal: intel: int3400: clean up ODVP on probe failures

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Declare eats_s1chk and eats_trans as host-endian u64

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Fix inverted fault report check in qcom_iommu_fault()

Haoxiang Li <haoxiang_li2024@163.com>
    iommu/qcom: Remove sysfs device on probe failure path

Li RongQing <lirongqing@baidu.com>
    iommu/amd: Fix undefined behavior in devid_write debugfs function

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix requested device removal race

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_dealloc_pd_user()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in uverbs_free_dmah()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_free_cq()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in counter_release()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_destroy_srq_user()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_destroy_cq_user()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix use after free in ib_query_qp()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Add rdma_restrack_begin/abort/commit_del() operations

Leon Romanovsky <leon@kernel.org>
    RDMA/mana_ib: drain QP references after partial table insertion

Myeonghun Pak <mhun512@gmail.com>
    RDMA/erdma: Fix CEQ tasklet use-after-free on removal

Takuma Fujiwara <t-fujiwara1@ti.com>
    PCI: j721e: Fix incorrect max_lanes for J7200

Leon Romanovsky <leon@kernel.org>
    RDMA/srpt: Pass the mapped task attribute to target_init_cmd()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark bpf_refcount field as unique

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Preserve unique-field state across nested structs

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix offset warn check for bpf_res_spin_lock

Kohei Enju <enju.kohei@fujitsu.com>
    virt: arm-cca-guest: use migrate_disable() for attestation token requests

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: battery: Adjust charging status validation check

Feng Jiang <jiangfeng@kylinos.cn>
    bpf, riscv: Fix extable handling for arena load_acquire

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Fix kernel stack corruption in tailcall with CFI

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Fix memory leak in bpf_jit_free

Ricardo B. Marlière <rbm@suse.com>
    libbpf: Search /lib64 and /lib in resolve_full_path()

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Fix lsm_bdev dev_t encoding mismatch

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Fix make install target

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Zero queue and stack outputs on lock failure

Yousef Alhouseen <alhouseenyousef@gmail.com>
    platform/x86: acer-wmi: reject missing gaming WMI results

Yun Zhou <yun.zhou@windriver.com>
    ext4: skip extra isize expansion during mount to prevent deadlock

Xiang Mei <xmei5@asu.edu>
    ext4: fix out-of-bounds read in ext4_read_inline_dir()

Yun Zhou <yun.zhou@windriver.com>
    ext4: fix circular lock dependency in ext4_ext_migrate

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: PCI: Clear driver_data on all paths that free the acpi_pci_root

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ACPI: processor: validate MADT IOAPIC entry bounds

Zhu Ling <zhuling2709@phytium.com.cn>
    ACPI: EC: Avoid _REG disconnect on GPIO IRQ defer

Pengpeng Hou <pengpeng@iscas.ac.cn>
    RDMA/nldev: validate dynamic counter attribute length

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()

Gary Guo <gary@garyguo.net>
    samples: rust: debugfs: fix excessive stack use

Gary Guo <gary@garyguo.net>
    rust: device: make lifetime on `Core` and `CoreInternal` invariant

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Silence maybe-uninitialized compiler warning in libarena

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Silence array bounds warning in global_map_resize

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Check malloc result with ASSERT_NEQ in test_sha256

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Check malloc result with ASSERT_NEQ in test_loader

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Don't use cpu-type matching in cpu_vuln_blacklist

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8-ss-audio: Fix LPCG clock indices for ASRC0

Marco Elver <elver@google.com>
    kcsan: avoid unintended access checking in NMIs

TanZheng <tanzheng@kylinos.cn>
    RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters

Leon Romanovsky <leon@kernel.org>
    RDMA/bnxt_re: Validate udata before executing commands

Jacob Moroni <jmoroni@google.com>
    RDMA/core: Add ib_no_udata_io() helper

Ibrahim Hashimov <security@auditcode.ai>
    RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]

Danila Chernetsov <listdansp@mail.ru>
    RDMA/hfi1: Propagate sdma_txinit_ahg() errors

Jun Yan <jerrysteve1101@gmail.com>
    arm64: dts: amlogic: meson-axg-s400: enable mipi_pcie_analog_dphy for PCIe

Jun Yan <jerrysteve1101@gmail.com>
    arm64: dts: amlogic: meson-axg: Add missing nand_rb0 pin to nand_all_pins

Can Peng <pengcan@kylinos.cn>
    phy: starfive: Fix runtime PM cleanup in JH7110 DPHY RX probe

Can Peng <pengcan@kylinos.cn>
    phy: starfive: Fix runtime PM cleanup in JH7110 DPHY TX probe

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: missing NULL check on match data

Linmao Li <lilinmao@kylinos.cn>
    ASoC: meson: Keep link pointers valid on realloc failure

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Clear stale requests on termination

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Serialize channel state checks

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Serialize abort state updates

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Terminate all descriptors without callbacks

Leon Hwang <leon.hwang@linux.dev>
    bpf: Disallow interpreter fallback for BPF_ADDR_PERCPU insn

Leon Hwang <leon.hwang@linux.dev>
    bpf: Disallow interpreter fallback for gotox insn

Leon Hwang <leon.hwang@linux.dev>
    bpf: Disallow interpreter fallback for arena-related insns

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Reject arena frees below the arena base

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Add CX power domain to GCC

Puranam V G Tejaswi <puranam.tejaswi@oss.qualcomm.com>
    drm/msm/a6xx: Fix RBBM_CLOCK_CNTL3_TP0 value in a730_hwcg

Yuho Choi <dbgh9129@gmail.com>
    driver core: soc: Unregister bus on early device registration failure

Alban Bedel <alban.bedel@lht.dlh.de>
    software node: Fix software_node_get_reference_args() with index -1

Ewan D. Milne <emilne@redhat.com>
    drivers: base: Remove statistics group if encryption group not created

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Associate BOs with every job that accesses them

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Convert submit helpers to operate on struct v3d_submit

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Make v3d_get_cpu_indirect_csd_params() a pure parser

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Introduce struct v3d_submit and convert CL/TFU/CSD ioctls

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Migrate BO reservation locking to DRM exec

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Extract v3d_job_add_syncobjs() helper

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Drop unused drm_encoder.h include from v3d_drv.h

Namhyung Kim <namhyung@kernel.org>
    perf build: Fix compiler errors with old capstone

Ian Rogers <irogers@google.com>
    perf ui hists: Fix uninitialized stack memory free on pstack allocation failure

zhouminqiang <zhouminqiang2@huawei.com>
    mtd: part: reject MTDPART_OFS_RETAIN in mtd_add_partition()

Ruoyu Wang <ruoyuw560@gmail.com>
    mtd: mtdswap: Avoid freeing registered blktrans device twice

Guangshuo Li <lgs201920130244@gmail.com>
    mtd: intel-dg: Fix runtime PM error path in probe

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: ti: knav_qmss: Remove debugfs file on teardown

Xiang Mei <xmei5@asu.edu>
    vfio/pci: clear vdev->msi_perm after freeing it on init failure

Alex Mastro <amastro@fb.com>
    vfio: selftests: Avoid VLAs

Myeonghun Pak <mhun512@gmail.com>
    char: xilinx_hwicap: unregister class on init errors

Pei Xiao <xiaopei01@kylinos.cn>
    ipack: ipoctal: fix UAF, null-ptr-deref, and use-after-free in cleanup on remove

Linmao Li <lilinmao@kylinos.cn>
    ppdev: prevent overflow when setting port timeout

Breno Leitao <leitao@debian.org>
    cacheinfo: don't propagate DT/ACPI error when arch supplies info (arm64)

Pengpeng Hou <pengpeng@iscas.ac.cn>
    misc: lan966x_pci: depopulate children on populate failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    misc: ad525x_dpot: use driver core groups for sysfs files

Gleb Markov <markov.gi@npc-ksb.ru>
    misc: rtsx: add missing write register handling

Gui-Dong Han <hanguidong02@gmail.com>
    misc: bcm-vk: Use acquire/release for msgq_inited

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    misc: pch_phub: Complete enum usage for device identification

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: lb: fix incorrect type in assignment

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    speakup: keyhelp: guard letter_offsets possible out-of-range indexing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    accessibility: speakup: Fix incorrect string length computation in report_char_chartab_status()

Yuho Choi <dbgh9129@gmail.com>
    uio: Fix stale info pointer in failed registration path

Arnd Bergmann <arnd@arndb.de>
    gpib: use 'static inline' instead of 'extern inline'

Gui-Dong Han <hanguidong02@gmail.com>
    gpib: Move stuck SRQ update under lock

Alexander A. Klimov <grandmaster@al2klimov.de>
    tlclk: if sscanf() fails, fall back to 0, not random value

Cong Nguyen <congnt264@gmail.com>
    staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths

David Lee <david.lee@trailofbits.com>
    UDF symlink pathComponent header OOB read

Karl Mehltretter <kmehltretter@gmail.com>
    tty: hvc: restrict HVC_DCC to ARMv6+ and ARM64

Xu Yang <xu.yang_2@nxp.com>
    usb: gadget: f_uac1_legacy: remove broken string configfs attributes

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: idle: Expand _LPI package sanity checks

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    crypto: aspeed - Propagate platform_get_irq() errors

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping

Chia-Yuan Li <leo.li@realtek.com>
    wifi: rtw89: fw: use MAC source for IO offload delay command

Can Guo <can.guo@oss.qualcomm.com>
    scsi: ufs: core: Avoid possible memory reclaim deadlock in TX EQTR context

Pu Lehui <pulehui@huawei.com>
    bpf: Sync tail_call_reachable with callee state on entry

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/msm: Only fini scheduler after successful init

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm: Fix task_struct reference leak in recover_worker

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm/a6xx: Fix IRQ storm during msm_recovery test

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm/a6xx: Fix A621 GPUCC register list for state capture

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm/a6xx: Fix A663 GPUCC register list for state capture

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm: Recover HW before retire hung submit

Shivam Rawat <shivrawa@qti.qualcomm.com>
    drm/msm/a6xx: Fix stale rpmh votes after suspend

Dan Carpenter <error27@gmail.com>
    drm/msm/adreno: fix use after free on error path in a6xx_gpu_init()

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Avoid stack over-read in debug output helpers

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix offset calculation in trace_write_gather

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Avoid double device_add when clients already present

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mei: pass correct argument to function

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mei: check SAP message length before reading it

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix duplicate output with --for-each-cgroup

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: geni-qcom: Fix sticky ret causing wrong return value on invalid proto

Iker Pedrosa <ikerpedrosam@gmail.com>
    drm/solomon: remove unneeded variables in blit functions

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a78000: Drop duplicate "default ARCH_RENESAS"

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: gcc-glymur: Enable runtime PM

Ian Rogers <irogers@google.com>
    perf jevents: Add more components to the metric sorting order

Namhyung Kim <namhyung@kernel.org>
    perf sched: Free subcommand string after perf sched stats

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks in perf sched stats report

Namhyung Kim <namhyung@kernel.org>
    perf sched: Add missing perf_session__delete()

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: milos: Add reset for sdhc_2

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: correct frequencies in the Iris OPP table

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: sort out Iris power domains

George Moussalem <george.moussalem@outlook.com>
    arm64: qcom: ipq5018: Add GEPHY RX and TX clocks

George Moussalem <george.moussalem@outlook.com>
    arm64: dts: qcom: ipq5018: Correct CMN PLL reference clock rate

Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
    arm64: dts: qcom: glymur-crd: merge duplicate &pmh0101_gpios node extensions

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: eliza: Enable first QUPv3 wrapper by default

Pengyu Luo <mitltlatltl@gmail.com>
    arm64: dts: qcom: sc8280xp-x13s: Fix the drive-strength of mclk pin

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8996-xiaomi-gemini: Fix up ti,drv2604 enable GPIO

Denis V. Lunev <den@openvz.org>
    x86/mm/pat: Take cpa_lock around large-page collapse

Maoyi Xie <maoyixie.tju@gmail.com>
    drm/bridge: tc358767: clamp the reported AUX read size to the request

Hongling Zeng <zenghongling@kylinos.cn>
    perf: evsel: Fix error handling in tp_format lookup

Uday Khare <udaykhare77@gmail.com>
    remoteproc: qcom: Fix glink->node reference leak in qcom_add_glink_subdev

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom_q6v5_mss: Fix MDM9607 subsystem control instance ID

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom_q6v5_mss: Make ssctl_id configurable per platform

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix setting minimum P-state at init time

Anas Khan <anxkhn28@gmail.com>
    drm/amd/display: remove duplicate link_dp_panel_replay.h include

Dyllan Kobal <dyllan.kobal@zetier.com>
    drm/amd/display: fix wrong register field in dccg35_set_hdmistreamclk_src_new

Gleb Markov <markov.gi@npc-ksb.ru>
    drm/amd/display: Remove unused-but-set variable hubp from

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amd/display: Fix DM I2C teardown race

Gregor Herburger <gregor.herburger@linutronix.de>
    OPP: Fix cleanup ordering

Ruoyu Wang <ruoyuw560@gmail.com>
    media: ipu6: Do not free aux device pdata after init

Eugen Hristev <ehristev@kernel.org>
    media: bcm2835-unicam: Fix asc leaked in error/remove path

Julian Braha <julianbraha@gmail.com>
    media: platform: amd: fix unmet dependency for VIDEO_V4L2_SUBDEV_API

Biren Pandya <birenpandya@gmail.com>
    media: i2c: rdacm21: Fix missing media_entity_cleanup()

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    media: ti: vpe: Select V4L2_FWNODE for VIP

Qingshuang Fu <fuqingshuang@kylinos.cn>
    irqchip/renesas-irqc: Fix generic interrupt chip leak on remove

Yuho Choi <dbgh9129@gmail.com>
    PCI: keystone: Fix OF node reference leak in init

Yuho Choi <dbgh9129@gmail.com>
    PCI: xgene: Drop unnecessary OF node reference

Dan Carpenter <error27@gmail.com>
    cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()

John Groves <John@Groves.net>
    dax: fix holder_ops race in fs_put_dax()

John Groves <John@Groves.net>
    dax: read holder_ops once in dax_holder_notify_failure()

John Groves <John@Groves.net>
    dax/fsdev: fail probe on invalid pgmap offset

John Groves <John@Groves.net>
    dax/fsdev: use __va(phys) for kaddr in direct_access

John Groves <John@Groves.net>
    dax/fsdev: clear pgmap ops and owner on unbind

John Groves <John@Groves.net>
    dax/fsdev: don't leave a dangling dev_dax->pgmap on probe failure

John Groves <John@Groves.net>
    dax/fsdev: clear vmemmap_shift when binding static pgmap

John Groves <John@Groves.net>
    dax/fsdev: fix multi-range offset in memory_failure handler

John Groves <John@Groves.net>
    dax: fix misleading comment about share/index union in dax_folio_reset_order()

Bryam Vargas <hexlabsecurity@proton.me>
    libnvdimm/labels: Bound the on-media label size before the shift

Liang Luo <luoliang@kylinos.cn>
    tools/sched_ext: scx_qmap: Fix stale API name in comment

Dan Carpenter <error27@gmail.com>
    regulator: adp5055: Fix error code in adp5055_of_parse_cb()

Richard Cheng <icheng@nvidia.com>
    cxl/features: Clamp Get Feature output size to the remaining buffer

Richard Cheng <icheng@nvidia.com>
    cxl/features: Reject Set Features output buffer smaller than the header

Richard Cheng <icheng@nvidia.com>
    cxl/features: Reject Get Feature count larger than the output buffer

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix transport device teardown lookup

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix SCMI device destroy lifetimes

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unwind P2A receiver mailbox setup failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unwind TX receiver mailbox setup failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix OF node reference handling

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Clear SystemPower flag on create failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Drop handle on protocol bind failures

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Protect device request lookup with RCU

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Use channel ID for transport teardown

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Reject out of range DT protocol IDs

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Avoid IDR updates while cleaning channels

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Free transport channel on IDR failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Clean up channels on setup failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Quiesce notifications before teardown

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unregister device notifier before IDR teardown

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Publish channel state before callbacks

David Stevens <stevensd@google.com>
    x86/entry/fred: Encode frame pointer on entry

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath11k: cap out-of-range rx MCS instead of leaving bogus rate

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath12k: fix rx_mpdu_start layout for QCC2072

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix MLO peer delete race

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix dp_link_peer dangling references on AP vdev rollback

Kyle Zeng <kylebot@openai.com>
    hfsplus: validate thread record before delete key rebuild

Alison Schofield <alison.schofield@intel.com>
    cxl/port: Restart port enumeration when a sibling adds the dport first

Dave Jiang <dave.jiang@intel.com>
    cxl/features: Serialize multi-part Get/Set Feature transfers

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Honor -EPROBE_DEFER from component register setup

Dave Jiang <dave.jiang@intel.com>
    cxl/mbox: Break poison list loop on an empty payload

Guzebing <Guzebing1612@gmail.com>
    cxl/memdev: Fix firmware upload exact-fit handling

Li Ming <ming.li@zohomail.com>
    cxl/test: Rework cxl_type2_mem_init() to use cxl_mock_platform_device_add()

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Simplify iommufd_device_remove_vdev()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a09g047: Fix PCIe dma-ranges memory space code

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a09g056: Fix PCIe dma-ranges memory space code

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: rzt2h-n2h-evk: Remove unused MII/GMII pins

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    rpmsg: glink: fix deadlock in endpoint destroy during driver detach

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Fix UAF from worker threads when domains are removed

Dmitry Ilvokhin <d@ilvokhin.com>
    perf record: Fix multiple PERF_RECORD_COMPRESSED2 records per push

Dmitry Ilvokhin <d@ilvokhin.com>
    perf record: Return the written size from process_comp_header()

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()

Liang Luo <luoliang@kylinos.cn>
    tools/sched_ext: scx_flatcg: Fix uninitialized stats on allocation failure

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: v4l2-async: Unregister sub-device if asc_list is empty

Sami Tolvanen <samitolvanen@google.com>
    rust: drm: gpuvm: require Send + Sync for the driver's associated data

yeeli <seven.yi.lee@gmail.com>
    iommufd/selftest: Fix dmabuf leak in iommufd_test_dmabuf_get()

Samuel Moelius <sam.moelius@trailofbits.com>
    iommufd/selftest: Avoid selftest dirty bitmap size wrap

Xiang Mei <xmei5@asu.edu>
    isofs: fix out-of-bounds page array access on empty zisofs block

James Calligeros <jcalligeros99@gmail.com>
    ASoC: apple: mca: increase SERDES reset delay

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Initialize debugfs after probe completes

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Stop flushing the global IB workqueue

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Free RX data on late probe failure

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Preserve unit 0 on allocation failure

Leon Romanovsky <leon@kernel.org>
    RDMA/rvt: Return NULL after port allocation failure

Sean Rhodes <sean@starlabs.systems>
    misc: rtsx_usb: avoid USB I/O in runtime autosuspend

Pengpeng Hou <pengpeng@iscas.ac.cn>
    pmdomain: bcm: bcm2835: handle genpd provider registration errors

Evgenii Burenchev <evg28bur@yandex.ru>
    ALSA: hpi: Check transport errors during HPI6000 adapter initialization

Maher Azzouzi <maherazz04@gmail.com>
    esp: do not unref managed frag pages in esp_ssg_unref()

Xiang Mei <xmei5@asu.edu>
    xfrm6: fix out-of-bounds write in xfrm6_input_addr() when secpath is full

Guangshuo Li <lgs201920130244@gmail.com>
    crash_dump: release keyring reference at the correct time

Yuho Choi <dbgh9129@gmail.com>
    hwrng: ks-sa - Fix runtime PM cleanup on registration failure

Atish Patra <atishp@meta.com>
    crypto: ccp - Fix memory leak in SEV INIT_EX path

Atish Patra <atishp@meta.com>
    crypto: ccp - Fix possible deadlock in SEV init failure path

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    Revert "drm/msm: dsi: fix PLL init in bonded mode"

Jens Glathe <jens.glathe@oldschoolsolutions.biz>
    drm/msm/dp: add missing drm_edid_connector_update() before add_modes on cached EDID

Allison Henderson <achender@kernel.org>
    RDMA/rxe: Avoid reprocessing the current packet after the QP enters the error state

Leon Romanovsky <leon@kernel.org>
    RDMA/ipoib: Drain RCU callbacks during module teardown

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Drain RCU callbacks during module teardown

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Wait for RCU callbacks before unloading ib_core

Mert Seftali <mertsftl@gmail.com>
    iio: accel: dmard09: Implement IIO_CHAN_INFO_SCALE

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready

Leon Hwang <leon.hwang@linux.dev>
    bpf: Mark tracing_multi trampolines as ftrace managed

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Require a BPF cpumask for bpf_cpumask_populate()

Brian Masney <bmasney@redhat.com>
    clk: qcom: camcc-sc8280xp: unregister CAMCC_GDSC_CLK

Pengpeng Hou <pengpeng@iscas.ac.cn>
    bus: qcom-ebi2: use managed resources for clocks and children

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: qcom: rpmh-rsc: manage PM notifiers with devres

Yu Peng <pengyu@kylinos.cn>
    perf metricgroup: Fix metric expression copy leaks

Yixun Lan <dlan@kernel.org>
    clk: spacemit: k3: fix parent clock of UFS aclk

Ian Rogers <irogers@google.com>
    perf record: Fix teardown hang on system-wide multi-threaded sessions

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    drm/panel: samsung-s6d16d0: Power off on prepare failure

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: imx: fix missing ret assignment for dev_err_probe

Pengpeng Hou <pengpeng@iscas.ac.cn>
    usb: typec: ucsi: gaokun: unwind notifier on UCSI register failure

Biju Das <biju.das.jz@bp.renesas.com>
    usb: renesas_usbhs: Fix power-off ordering on unbind

Fei Shao <fshao@chromium.org>
    usb: mtu3: allow system suspend during active gadget connection

Linmao Li <lilinmao@kylinos.cn>
    platform/surface: acpi-notify: Check ACPI companion before use

Linmao Li <lilinmao@kylinos.cn>
    platform/mellanox: mlxbf-pmc: Check ACPI_COMPANION() against NULL

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: fix resource leaks on probe failure

Gary Guo <gary@garyguo.net>
    usb: fix UAF when probe runs concurrent to dyn ID removal

Ruoyu Wang <ruoyuw560@gmail.com>
    usb: gadget: aspeed_udc: check endpoint DMA allocation

Maoyi Xie <maoyixie.tju@gmail.com>
    usb: ljca: bound bank_num in ljca_enumerate_gpio()

Xu Rao <raoxu@uniontech.com>
    usb: typec: tcpm: fix EPR AVS APDO maximum voltage decoding

Michael Bommarito <michael.bommarito@gmail.com>
    usb: gadget: configfs: fix out-of-bounds read of qw_sign

Nuno Sá <nuno.sa@analog.com>
    usb: gadget: f_fs: Fix fence cleanup in ffs_dmabuf_transfer() error paths

Qing Ming <a0yami@mailbox.org>
    usb: gadget: uac: validate rate list length before storing

Guangshuo Li <lgs201920130244@gmail.com>
    serial: qcom-geni: do not advance stale DMA completions

Yuho Choi <dbgh9129@gmail.com>
    serial: ma35d1: Fix OF node reference leaks in console init

Fushuai Wang <wangfushuai@baidu.com>
    serial: 8250: Clear CON_PRINTBUFFER on port re-registration

Ricardo Ribalda <ribalda@chromium.org>
    media: platform: amd: use refcount_t instead of atomic_t

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: qcom-geni: Fix missing error check on pm_runtime_get_sync()

Linmao Li <lilinmao@kylinos.cn>
    platform/x86: asus-wireless: Fail probe when there is no ACPI match

Tengda Wu <wutengda@huaweicloud.com>
    perf capstone: Fix kernel map reference count leak

Liang Luo <luoliang@kylinos.cn>
    selftests/sched_ext: Fix bpf_link leak on early return in prog_run

Wolfram Sang <wsa+renesas@sang-engineering.com>
    hwspinlock: propagate errno when registering single lock

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max

Val Packett <val@packett.cool>
    remoteproc: qcom_wcnss: Fix handling the lack of PD regulators in v3

Felix Gu <gu_0233@qq.com>
    remoteproc: qcom_q6v5_adsp: Fix reference leak for device node

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Drop scalar id on sign-extending narrowing stack fills

Armin Wolf <W_Armin@gmx.de>
    platform/x86: lg-laptop: Fix LED resource handling

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi-base: Fix handling of ultra performance key

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi-base: Fix resource leak on module load failure

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-privacy: Fix race condition

Lorenzo Pieralisi <lpieralisi@kernel.org>
    ACPI: RISC-V: Fix riscv_acpi_add_prt_dep() loop handling

Lorenzo Pieralisi <lpieralisi@kernel.org>
    ACPI: RISC-V: Check acpi_get_handle() status in riscv_acpi_add_prt_dep()

Lorenzo Pieralisi <lpieralisi@kernel.org>
    ACPI: RISC-V: Fix riscv_acpi_irq_get_dep() loop termination

John Ogness <john.ogness@linutronix.de>
    printk: Fix possible console use-after-free

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Validate LED reg property against channel count

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Disable channel when brightness is set to zero

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Fix brightness having no effect while pattern mode is active

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Set all pattern PWM slots to full after clearing pattern

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Fix spurious pattern sequence start in setup

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Fix pattern duration prescaler and pattern_clear skip marker

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Stop pattern sequence before reprogramming

Cosmo Chou <chou.cosmo@gmail.com>
    leds: pca9532: Fix inverted GPIO output polarity

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: tungsten-smarc: Remove unnecessary cells

Wei Wang <wei.w.wang@hotmail.com>
    iommu/amd: Fix false positive in SB IOAPIC IVRS validation

Wei Wang <wei.w.wang@hotmail.com>
    iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors

Vladimir Zapolskiy <vz@kernel.org>
    iommu/msm: Return -ENOMEM on memory allocation failure in probe

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix security_bpf_map_create error handling

Akari Tsuyukusa <akkun11.open@gmail.com>
    iommu/mediatek-v1: Fix off-by-one in MT2701_LARB_NR_MAX

Tiezhu Yang <yangtiezhu@loongson.cn>
    bpf: Reject programs with inlined helpers if JIT is not available

Tiezhu Yang <yangtiezhu@loongson.cn>
    bpf: Introduce jit_required flag and remove bpf_prog_has_kfunc_call()

Yuho Choi <dbgh9129@gmail.com>
    bus: mhi: ep: Fix device refcount leak in the error path of MHI device creation

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    bpf: Fix use-after-free on mm_struct in bpf_find_vma()

Breno Leitao <leitao@debian.org>
    efi: fix stale reference to efi_recover_from_page_fault()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix vmlinux BTF prep race in bpf_get_btf_vmlinux

Tanushree Shah <tshah@linux.ibm.com>
    perf dso: Fix kallsyms DSO detection with fallback logic

Sandipan Das <sandipan.das@amd.com>
    perf vendor events amd: Reintroduce deprecated Zen 5 core events

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amdgpu/mes: Fix hung_queue_db_array loop limit for multi-XCC

Daniel Borkmann <daniel@iogearbox.net>
    bpftool: Check EVP_Digest when computing excl_prog_hash

Aleksandr Nogikh <nogikh@google.com>
    udf: Mark LVID buffer as uptodate before marking it dirty

Hongyan Xu <getshell@seu.edu.cn>
    usb: gadget: r8a66597: avoid double free of ep0_req in probe error path

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    usb: typec: ucsi: unregister debugfs entries on teardown

Dan Carpenter <error27@gmail.com>
    thermal/drivers/rcar: Fix error checking in probe()

Vidhu Sarwal <vidhu.linux@gmail.com>
    staging: media: ipu7: fix pm_runtime refcount leak in ipu7_resume()

Vidhu Sarwal <vidhu.linux@gmail.com>
    staging: media: ipu7: fix pm_runtime refcount leak in ipu7_init_fw_code_region_by_sys()

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Reject writes through untrusted BTF pointers

Tanushree Shah <tshah@linux.ibm.com>
    perf data convert json: Fix trace_seq memory leak in process_sample_event()

Jiawei Sun <abyssmystery@gmail.com>
    perf record: fix poll storm when monitored threads exit

Loic Poulain <loic.poulain@oss.qualcomm.com>
    clk: qcom: gcc-qcs8300: Use retention for USB power domains

Loic Poulain <loic.poulain@oss.qualcomm.com>
    clk: qcom: gcc-qcs8300: Use retention for PCIe power domains

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x-lenovo-flex-5g: Describe the display power net

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x-lenovo-flex-5g: Rename regulator nodes

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x-primus: Describe the display power net

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x-primus: Rename regulator nodes

Richard Acayan <mailingradian@gmail.com>
    arm64: dts: qcom: sdm670-google: add lpi reserved gpios

Yedaya Katsman <yedaya.ka@gmail.com>
    arm64: dts: qcom: sm6125-xiaomi-laurel-sprout: Fixup panel compatible

Jérôme de Bretagne <jerome.debretagne@gmail.com>
    arm64: dts: qcom: sc8280xp-arcata: Fix top USB-C DP alt mode

Herman van Hazendonk <github.com@herrie.org>
    clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()

Herman van Hazendonk <github.com@herrie.org>
    clk: qcom: gdsc: propagate gdsc_enable() failure for ALWAYS_ON domains

Herman van Hazendonk <github.com@herrie.org>
    clk: qcom: gdsc: propagate gdsc_check_status() errors from gdsc_poll_status

Brian Norris <briannorris@chromium.org>
    arm64: dts: qcom: Add #{address,size}-cells to Chromium-based /firmware

David Woodhouse <dwmw@amazon.co.uk>
    timekeeping: Account for monotonicity adjustment in ntp_error

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    y2038: uapi: Use 64-bit __kernel_old_timespec::tv_nsec on x32

Malaya Kumar Rout <malayarout91@gmail.com>
    time/namespace: Validate nanosecond field in proc_timens_set_offset()

Malaya Kumar Rout <malayarout91@gmail.com>
    timers/migration: Fix memory leak in tmigr_setup_groups() error path

Yuho Choi <dbgh9129@gmail.com>
    timekeeping: Unwind aux clock sysfs children on failure

Yuho Choi <dbgh9129@gmail.com>
    clocksource: Unregister subsystem on device registration failure

Jiangshan Yi <yijiangshan@kylinos.cn>
    selftests: timers: leap-a-day: Fix -w option and update usage comment

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Fix memleak in its_probe_one()

Wang Yan <wangyan01@kylinos.cn>
    selftests/lsm: Fix memory leak in attr_lsm_count

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix memory leak in msg_alloc_iov

Maxim Khmelevskii <max@linux.ibm.com>
    s390/bpf: Replace ly instruction with llgf

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Reject MEM_ALLOC BTF accesses past object bounds

Malaya Kumar Rout <malayarout91@gmail.com>
    selftests/bpf: Fix memory leak in msg_alloc_iov error path

Emil Tsalapatis <emil@etsalapatis.com>
    selftests/bpf: libarena: Clean up allocation state before buddy tests

Evgenii Burenchev <evg28bur@yandex.ru>
    ALSA: via82xx: Remove unreachable branch in snd_via686_pcm_pointer()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: unset sub_make_done before calling kselftest build system

Dawei Feng <dawei.feng@seu.edu.cn>
    staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: add missing tasklet_kill in cvm_oct_tx_shutdown

Dan Carpenter <error27@gmail.com>
    staging: fbtft: Use sysfs_emit_at() to print to sysfs file

Bryam Vargas <hexlabsecurity@proton.me>
    greybus: audio: bound the topology section sizes against the fetched size

Rong Zhang <i@rong.moe>
    staging: sm750fb: Add missing Kconfig dependency

Ahmet Sezgin Duran <ahmet@sezginduran.net>
    staging: sm750fb: gate dualview dataflow using g_dualview

Alexander A. Klimov <grandmaster@al2klimov.de>
    staging: greybus: audio: correct sscanf() return value check

Cen Zhang <zzzccc427@gmail.com>
    wifi: mac80211_hwsim: avoid NULL skb in stop queue drain

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: qcom: Skip PERST# GPIOs provided by downstream PCIe devices

Ruoyu Wang <ruoyuw560@gmail.com>
    bus: qcom-ebi2: Fix clock leak on probe failure

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp: sort reserved memory regions

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gcc-glymur: Move EVA clocks to critical clock list

Pradyot Kumar Nayak <pradyot.nayak@oss.qualcomm.com>
    arm64: dts: glymur-crd: Add reset GPIO to touchscreen node

Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
    arm64: dts: qcom: glymur-crd: Move common board nodes to shared DTSI

Sibi Sankar <sibi.sankar@oss.qualcomm.com>
    arm64: dts: qcom: glymur-crd: Add Embedded controller node

Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Fix gcc clock specifier for usb_mp_qmpphy nodes

Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
    arm64: dts: qcom: glymur: Fix unit-address mismatch for spmi_bus2

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: hamoa: Fix clocks for HSPHYs

Biswapriyo Nath <nathbappai@gmail.com>
    arm64: dts: qcom: sm6125: Use 64 bit addressing

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name

Jens Glathe <jens.glathe@oldschoolsolutions.biz>
    arm64: dts: qcom: sc8280xp-blackrock: switch to uefi rtc offset

Jie Gan <jie.gan@oss.qualcomm.com>
    arm64: dts: qcom: monaco: fix wrong connection for the replicator

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gxclkctl: Use custom disable callback for gx_gdsc

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gdsc: Add custom disable callback for GX GDSC

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Make nr_deadline_tasks an atomic_t

Haowen Tu <tuhaowen@uniontech.com>
    PM: sleep: Fix off-by-one in wakelocks number limit check

Yuho Choi <dbgh9129@gmail.com>
    bus: ti-sysc: Fix /chosen node reference leak

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvmet-rdma: fix response resource leak on queue teardown

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvmet-rdma: factor out response resource cleanup

Gui-Dong Han <hanguidong02@gmail.com>
    nvme-apple: Use acquire/release for queue enabled state

Miklos Szeredi <mszeredi@redhat.com>
    fuse: move "epoch" from dentry.d_time to fuse_dentry.epoch

Pengpeng Hou <pengpeng@iscas.ac.cn>
    RDMA/bng_re: return a timeout when firmware responses stall

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: talos: Fix GMU unit address

Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: wire UFS to ice instance

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Add refcounting to user ring MRs

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Add irdma_cq fields to track pbl allocations

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Add a refcount to track user ring MR associations

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Deduplicate the irdma_del_memlist logic

Myeonghun Pak <mhun512@gmail.com>
    crypto: keembay - Fix AEAD unregister count in error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: rk3288 - fail ahash requests on HASH idle timeout

Myeonghun Pak <mhun512@gmail.com>
    hwrng: omap - Fix probe error path cleanup

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwrng: xilinx-trng - propagate timeout before any data is read

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: sa2ul - stop probe if context pool creation fails

Lothar Rubusch <l.rubusch@gmail.com>
    crypto: atmel-sha204a - fix heap info leak on I2C transfer failure

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - reject hardware ECDH without a public key

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - clear AES key schedule from stack

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - cancel work on re-enable SR-IOV timeout

Manos Pitsidianakis <manos@pitsidianak.is>
    hwrng: core - fix rng list on registration error

Sandipan Das <sandipan.das@amd.com>
    perf vendor events amd: Update Zen 6 core events

Sandipan Das <sandipan.das@amd.com>
    perf vendor events amd: Update Zen 5 core events

Ondrej Mosnacek <omosnace@redhat.com>
    perf test amd ibs: avoid using executable heap

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Add group validation

Jiri Olsa <jolsa@kernel.org>
    libbpf: Detect uprobe syscall with new error

Jiri Olsa <jolsa@kernel.org>
    libbpf: Change has_nop_combo to work on top of nop10

Leo Yan <leo.yan@linux.dev>
    perf cs-etm: Filter synthesized branch samples

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Fix thread leaks on trace queue init failure

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: mark arg1 operand in __nolibc_syscall0() as write-only

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    fanotify: initialize permission event watchdog state

Jiri Olsa <jolsa@kernel.org>
    uprobes/x86: Move optimized uprobe from nop5 to nop10

Jiri Olsa <jolsa@kernel.org>
    uprobes/x86: Allow to copy uprobe trampolines on fork

Jiri Olsa <jolsa@kernel.org>
    uprobes/x86: Do not leak trampoline vma mapping on optimization failure

Jiri Olsa <jolsa@kernel.org>
    uprobes/x86: Remove struct uprobe_trampoline object

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rtw89: fix HE extended capability length check

Dmitry Morgun <d.morgun@ispras.ru>
    wifi: rtw89: check return values in rtw89_ops_start_ap()

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: fw: fix link ID filling for LPS MLO common info

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: sensorhub: Fix memory overread in ring handler

Wentao Guan <guanwentao@uniontech.com>
    wifi: rtw89: fw: correct preload field of w2 in rtw89_fw_h2c_default_cmac_tbl_be()

Dan Carpenter <error27@gmail.com>
    wifi: rtw89: debug: fix off by on in rtw89_ppdu_str()

Hisam Mehboob <hisamshar@gmail.com>
    selftests/rseq: Replace glibc-specific __GNUC_PREREQ with portable check

Hanlin Song <pgeorge8929@gmail.com>
    csky: Fix a4/a5 restoration in syscall trace path

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: orientation: hid-sensor-rotation: Avoid race between callback setup and device exposure

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    soundwire: qcom: Fix port exhaustion check in stream_alloc_ports

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix CPU stall in xilinx_dma_poll_timeout

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: fix race between runtime PM and device removal

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    leds: lp5860-spi: Fix an error handling path

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    leds: lp5860: Fix a potential double-unlock

Gregory Price <gourry@gourry.net>
    mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug

Sechang Lim <rhkrqnwk98@gmail.com>
    bpf,lsm: Drop bpf_prog_free from sleepable_lsm_hooks

Guillaume Maudoux <layus.on@gmail.com>
    selftests/bpf: Mask socket type flags in mptcpify prog

Leon Hwang <leon.hwang@linux.dev>
    bpf: Copy per-CPU map value padding in copy_map_value_long()

Yichong Chen <chenyichong@uniontech.com>
    tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands

Yichong Chen <chenyichong@uniontech.com>
    tools/bpf/bpftool: Reset vmlinux BTF after map commands

Andrii Nakryiko <andrii@kernel.org>
    bpftool: Strip all -Wformat* flags from bootstrap libbpf build

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in CRTC reset function

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in plane reset function

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: ti: j721e-evm: Avoid mixing goto with guard()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: samsung: i2s: Avoid mixing goto with guard()

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in Vega10 lookup

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in SMU7 lookup

Asad Kamal <asad.kamal@amd.com>
    drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read

Uday Khare <udaykhare77@gmail.com>
    regulator: tps6594: Fix device node reference leaks in multiphase loop

Arnd Bergmann <arnd@arndb.de>
    PCI: imx6: Fix building against PCI_PWRCTRL_GENERIC

Arnd Bergmann <arnd@arndb.de>
    PCI: imx6: Fix building against PCI_HOST_COMMON

Ian Rogers <irogers@google.com>
    perf tests: Fix flakiness in branch stack sampling tests

Ian Rogers <irogers@google.com>
    perf tests: Fix flakiness in BPF counters test on hybrid systems

Ian Rogers <irogers@google.com>
    perf tests: Fix flakiness in trace record and replay test

Ian Rogers <irogers@google.com>
    perf tests: Add robust record retry helper and use subsecond workloads

Ian Rogers <irogers@google.com>
    perf tests: Fix Python JIT dump profiling test failure

Ian Rogers <irogers@google.com>
    perf tests: Skip metrics validation if system-wide recording lacks permission

Ian Rogers <irogers@google.com>
    perf test: Truncate test description to fit terminal width

Ian Rogers <irogers@google.com>
    perf parse-events: Restrict core PMU bypass to --cputype option

Ian Rogers <irogers@google.com>
    perf evlist: Add reference count checking

Ian Rogers <irogers@google.com>
    perf evsel: Add reference count

Ian Rogers <irogers@google.com>
    perf evlist: Add reference count

Ian Rogers <irogers@google.com>
    perf util: Sort includes and add missed explicit dependencies

Ian Rogers <irogers@google.com>
    perf pmu: Recognize default_core as a core PMU in more places

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: correct monitor destination ring size

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: fix TLV32 length mask

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Propagate -ENOMEM on platform_device_alloc() failures

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Add hierarchy enumeration support for type2 device

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Refactor platform device enumerations

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Add test for module parameters

Thomas Richter <tmricht@linux.ibm.com>
    perf test: Skip failing 'perf test aslr' test case

Breno Leitao <leitao@debian.org>
    workqueue: only show running workers in stall diagnostics

Jinjie Ruan <ruanjinjie@huawei.com>
    riscv: kexec_file: Fix crashk_low_res not exclude bug

Akash Goel <akash.goel@arm.com>
    drm/panthor: Fix NPD issue on partial unmap of an evicted BO

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: Support sparse mappings

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: Pass vm_bind_op to vm_prepare_map_op_ctx

Daniel McCarthy <daniel@dragonzap.com>
    pinctrl: bcm2835: Don't remove an unregistered GPIO chip

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Keep cap_user_rdpmc in sync with RDPMC user-disable state

Felix Gu <ustc.gu@gmail.com>
    pinctrl: imx1: fix device_node leak in dt_is_flat_functions()

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix uncore_box ref/unref ordering

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Introduce PMU flags and broken state

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Factor out box setup code

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Let init_box() callback report failures

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix refcnt and other cleanups

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails

Chen, Yu C <yu.c.chen@intel.com>
    sched/fair: Fix overflow in update_tg_cfs_runnable()

Peter Zijlstra <peterz@infradead.org>
    sched/core: Fix inter-class wakeup_preempt()

Wei Yang <richard.weiyang@gmail.com>
    mm/mm_init: fix incorrect node_spanned_pages

Henrik Grimler <henrik.grimler@axis.com>
    drm/lima: call drm_mm_init() with a valid allocation range

Brian Masney <bmasney@redhat.com>
    clk: imx: scu: drop redundant init.ops variable assignment

Shengjiu Wang <shengjiu.wang@nxp.com>
    arm64: dts: imx8mp-ab2: Enable MU2 for DSP communication

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx95-toradex-smarc: add alias for lpuart5

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx93-kontron: set memory node to 0x80000000/1GiB

Li Jun <lijun01@kylinos.cn>
    firmware: imx: sm-misc: Add NULL check for kmalloc in syslog_show

Yuho Choi <dbgh9129@gmail.com>
    ARM: OMAP2+: Fix OF node reference leaks in omap_hwmod

Weigang He <geoffreyhe2@gmail.com>
    ARM: imx: fix device_node refcount leaks in imx7_src_init()

Weigang He <geoffreyhe2@gmail.com>
    ARM: imx: fix device_node refcount leak in imx_src_init()

Min zhang <zhangmin2026@yeah.net>
    clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller

Philipp Zabel <p.zabel@pengutronix.de>
    arm64: dts: imx8mp-frdm: Add missing HDMI DDC pinctrl

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: rework runtime PM handling in probe

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: rt700-sdw: always drain jack work on remove

Rosen Penev <rosenp@gmail.com>
    clk: stm32: add missing bitfield.h header

Joey Lu <a0987203069@gmail.com>
    clk: nuvoton: ma35d1: fix ma35d1_clk_pll_determine_rate logic

Joey Lu <a0987203069@gmail.com>
    clk: nuvoton: ma35d1: fix PLL_CTL1_FRAC bit field width and fractional calc

Joey Lu <a0987203069@gmail.com>
    clk: nuvoton: ma35d1: fix ignored div_u64 return values in PLL freq calculation

Alexander A. Klimov <grandmaster@al2klimov.de>
    clk: moxart: remove unused variables, fix refcount leak

Xuyang Dong <dongxuyang@eswincomputing.com>
    clk: eswin: Add CLK_IGNORE_UNUSED to NoC clock

David Carlier <devnexen@gmail.com>
    clk: canaan: Clear rate fields before reprogramming dividers

Myeonghun Pak <mhun512@gmail.com>
    clk: versaclock7: Fix APLL clock leak on probe failure

Yuho Choi <dbgh9129@gmail.com>
    ARM: imx: avic: Fix OF node reference leaks

Wei Hou <wei.hou@scaleflux.com>
    cxl/pci: Remove incorrect mbox.valid check in cxl_pci_type3_init_mailbox()

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx943: Correct PCIe outbound address space configuration

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx94: Correct PCIe outbound address space configuration

Richard Cheng <icheng@nvidia.com>
    cxl/mbox: Clamp mailbox output allocation to the payload size

Mert Seftali <mertsftl@gmail.com>
    ASoC: SOF: ipc4-topology: Return error for invalid number of formats

Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
    mtd: rawnand: pl353: Fix debug prints

Gui-Dong Han <hanguidong02@gmail.com>
    media: cec-pin: Fix event FIFO ordering

Weigang He <geoffreyhe2@gmail.com>
    soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()

Michael Bommarito <michael.bommarito@gmail.com>
    HID: roccat: bound device-supplied profile index

Christos Maragkos <whitetowersoftware@gmail.com>
    HID: nintendo: Fix imu_timestamp_us double increment per report

Philipp Weber <kernel@phwe.de>
    HID: core: quiesce input in hid_hw_stop() to prevent use-after-free

Amin Vakil <info@aminvakil.com>
    selftests: proc: include fcntl.h in proc-pidns

Maoyi Xie <maoyixie.tju@gmail.com>
    platform/chrome: cros_ec_typec: Reject out-of-bounds PD cap count

Jens Remus <jremus@linux.ibm.com>
    x86/cfi: Use symmetric SYM_START and SYM_END in __CFI_TYPE()

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: of-display-mode-bridge: Fix missing static const for the bridge funcs

Wanwu Li <liwanwu@kylinos.cn>
    sched_ext/scx_flatcg: Fix cvtime_delta race and add hweight scaling to bypass charging

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Avoid unnecessary cpus & mems update in cpuset_hotplug_update_tasks()

Konstantin Andreev <andreev@swemel.ru>
    smack: restrict smackfs/{direct,mapped} values to 0-255

Konstantin Andreev <andreev@swemel.ru>
    smack: deduplicate smackfs/{direct,mapped} file_operations

Dmitry Antipov <dmantipov@yandex.ru>
    smack: simplify write handlers of sysfs entries

Konstantin Andreev <andreev@swemel.ru>
    smack: fix incorrect task context in smack_msg_queue_msgrcv

Maxime Ripard <mripard@kernel.org>
    drm/bridge: cdns-mhdp8546: Return an error pointer on allocation failure

Maxime Ripard <mripard@kernel.org>
    drm/bridge: cdns-dsi: Return an error pointer on allocation failure

Deborah Brouwer <deborah.brouwer@collabora.com>
    rust: drm: gpuvm: update DriverGpuVm for DeviceContext

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/rockchip: vop2: Add RK3576 to the RG swap special case

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/display: hdmi-state-helper: Try subsampling in mode_valid

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Clear queue->active_job when v3d_fence_create() fails

Alexandre Courbot <acourbot@nvidia.com>
    gpu: nova-core: gsp: tu102: keep unloading if FWSEC-SB fails

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/bridge: display-connector: trigger initial HPD event for DP

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/bridge: display-connector: don't autoenable HPD IRQ

Damon Ding <damon.ding@rock-chips.com>
    drm/rockchip: analogix_dp: Fix OF node reference leak via auto cleanup

Damon Ding <damon.ding@rock-chips.com>
    drm/rockchip: analogix_dp: Enable hclk for RK3588

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: vop2: Wait for layer cfg done before switching LAYERSEL_REGDONE_SEL

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: vop2: Fix wrong wait target in layer cfg done check

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_dp: Release core resources

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_dp: Add missing newline in dev_err_probe() message

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/bridge: synopsys: dw-dp: Support unregistering the AUX channel

Paul Kocialkowski <paulk@sys-base.io>
    drm: lcdif: Wait for vblank before disabling DMA

Svyatoslav Ryhel <clamor95@gmail.com>
    drm/tegra: dsi: Re-add clear enable register if DSI was powered by bootloader

Maxime Ripard <mripard@kernel.org>
    drm/atomic: Drop drm_private_obj.state assignment from create_state

Yicong Hui <yiconghui@gmail.com>
    drm: Remove unused header in drm_dumb_buffers.c

Casey Schaufler <casey@schaufler-ca.com>
    Smack: Fix error in capability bypass

Yosry Ahmed <yosry@kernel.org>
    KVM: x86: Check EFER validity on KVM_SET_SREGS*

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move the bulk of register specific code from x86.c to regs.c

Sean Christopherson <seanjc@google.com>
    KVM: x86: Rename __{g,s}et_sregs2() => kvm_vcpu_ioctl_x86_{g,s}et_sregs2()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move get_segment_base() to regs.h, as kvm_get_segment_base()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Extract REGS and SREGS runtime sync code to helpers

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: Fix test_ctl_hi field for DEFAULT_EVO PLLs

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: refcount requests for token lifetime

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: always wake -ENOSPC waiters

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: stop allocating child flush bio

Li Chen <me@linux.beauty>
    nvdimm: pmem: keep PREFLUSH before data writes

Li Chen <me@linux.beauty>
    nvdimm: preserve flush callback -ENOMEM

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: move LRU size accounting on reparenting instead of copying it

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    ksmbd: fix tree connection use-after-free in smb2_tree_connect()

Ze Tan <tanze@kylinos.cn>
    smb/server: fix tree connection leak in smb2_tree_connect()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix maximum allowed access checks

Leo Martins <loemra.dev@gmail.com>
    btrfs: abort transaction before releasing tree_log_mutex on commit failure

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix BTF kflag check for anonymous struct member access

Martin Kaiser <martin@kaiser.cx>
    tracing/probes: ignore id update from btf_type_skip_modifiers

Muhammad Bilal <meatuni001@gmail.com>
    staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()

Jan Kara <jack@suse.cz>
    udf: Fix data loss when converting inline inodes to out of line

Jan Kara <jack@suse.cz>
    udf: Move udf_map_block() up

Bryam Vargas <hexlabsecurity@proton.me>
    dm-pcache: validate the persisted dirty_tail chain at load

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Do not treat master device as a duplicate target

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix use-after-free of master->this

Bryam Vargas <hexlabsecurity@proton.me>
    dm-pcache: validate seg_id fields from persistent memory

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix recursive locking during device registration

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix device_register() error path

SJ Park <sj@kernel.org>
    mm/damon/core: skip aging from repeated aggressive merging

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: avoid CRC corruption due to parallel claim add

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: atomically update mac addresses

Akhmed Zhitaev <zhitaevakh@gmail.com>
    drm/amd/display: Scale custom brightness curve from full range


-------------

Diffstat:

 .../ABI/testing/configfs-usb-gadget-uac1_legacy    |    3 -
 Documentation/admin-guide/device-mapper/dm-ima.rst |    7 +-
 .../admin-guide/device-mapper/dm-integrity.rst     |   13 +
 Documentation/hwmon/emc1403.rst                    |    8 +-
 Documentation/leds/leds-st1202.rst                 |    2 +-
 Documentation/sunrpc/xdr/nfs4_1.x                  |  241 +++-
 Documentation/usb/gadget-testing.rst               |    3 -
 Makefile                                           |   10 +-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/allwinner/sun4i-a10.dtsi         |    2 +-
 arch/arm/boot/dts/marvell/armada-388-helios4.dts   |   13 +
 arch/arm/kernel/hw_breakpoint.c                    |   11 +-
 arch/arm/mach-imx/avic.c                           |    2 +
 arch/arm/mach-imx/src.c                            |    3 +
 arch/arm/mach-lpc32xx/common.c                     |    5 +-
 arch/arm/mach-lpc32xx/common.h                     |    2 +
 arch/arm/mach-lpc32xx/phy3250.c                    |    2 +
 arch/arm/mach-lpc32xx/pm.c                         |    5 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |   26 +-
 arch/arm/mach-tegra/irq.c                          |    9 +-
 arch/arm/mm/fault.c                                |   22 +-
 arch/arm64/Kconfig                                 |    2 +
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |    4 +-
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts     |    4 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |    3 +-
 arch/arm64/boot/dts/freescale/imx8-ss-audio.dtsi   |    8 +-
 arch/arm64/boot/dts/freescale/imx8mp-ab2.dts       |    4 +
 arch/arm64/boot/dts/freescale/imx8mp-frdm.dts      |    2 +
 .../boot/dts/freescale/imx93-kontron-osm-s.dtsi    |    4 +-
 arch/arm64/boot/dts/freescale/imx94.dtsi           |    5 +-
 arch/arm64/boot/dts/freescale/imx943.dtsi          |    5 +-
 .../boot/dts/freescale/imx95-toradex-smarc.dtsi    |    1 +
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |    3 +-
 .../boot/dts/mediatek/mt8390-tungsten-smarc.dtsi   |    4 -
 arch/arm64/boot/dts/nvidia/tegra264.dtsi           |   10 +-
 arch/arm64/boot/dts/qcom/agatti.dtsi               |    1 +
 arch/arm64/boot/dts/qcom/eliza-mtp.dts             |    4 +-
 arch/arm64/boot/dts/qcom/eliza.dtsi                |    4 +-
 arch/arm64/boot/dts/qcom/glymur-crd.dts            |  399 ------
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi           |  434 ++++++-
 arch/arm64/boot/dts/qcom/glymur.dtsi               |   25 +-
 arch/arm64/boot/dts/qcom/hamoa-iot-som.dtsi        |   20 +-
 .../qcom/hamoa-lenovo-ideacentre-mini-01q8x10.dts  |   20 +-
 arch/arm64/boot/dts/qcom/hamoa.dtsi                |    4 +-
 arch/arm64/boot/dts/qcom/ipq5018.dtsi              |    5 +-
 arch/arm64/boot/dts/qcom/kaanapali-mtp.dts         |    4 +-
 arch/arm64/boot/dts/qcom/kaanapali-qrd.dts         |    4 +-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi            |    4 +-
 arch/arm64/boot/dts/qcom/kodiak.dtsi               |    8 +-
 .../boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso    |   18 +-
 arch/arm64/boot/dts/qcom/lemans-evk.dts            |    4 +-
 arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi   |    8 +-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/milos.dtsi                |    2 +
 .../boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso    |   18 +-
 arch/arm64/boot/dts/qcom/monaco-monza-som.dtsi     |   16 +-
 arch/arm64/boot/dts/qcom/monaco.dtsi               |   24 +-
 .../boot/dts/qcom/msm8976-longcheer-l9360.dts      |    4 +-
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts |    2 +-
 .../boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi |    4 -
 arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts  |    5 -
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |   24 +-
 arch/arm64/boot/dts/qcom/purwa-iot-som.dtsi        |   20 +-
 arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts |    4 +-
 arch/arm64/boot/dts/qcom/qcm6490-idp.dts           |    4 +-
 .../boot/dts/qcom/qcm6490-particle-tachyon.dts     |    4 +-
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts   |    4 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |   16 +-
 .../boot/dts/qcom/qcs6490-radxa-dragon-q6a.dts     |   18 +-
 .../qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso |   50 +-
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts       |   22 +-
 .../dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts  |   22 +-
 .../boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts |    4 +-
 arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi       |    4 +-
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts           |    8 +-
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts           |    8 +-
 arch/arm64/boot/dts/qcom/sa8295p-adp.dts           |   16 +-
 arch/arm64/boot/dts/qcom/sa8540p-ride.dts          |    8 +-
 arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts     |    4 +-
 arch/arm64/boot/dts/qcom/sar2130p.dtsi             |    8 +-
 arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts   |    4 +-
 arch/arm64/boot/dts/qcom/sc7180-ecs-liva-qc710.dts |    4 +-
 arch/arm64/boot/dts/qcom/sc7180-idp.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |    9 +-
 arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi     |    5 +
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi           |    4 +-
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi         |    4 +-
 .../arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts |   73 +-
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts        |   72 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   16 +-
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts          |    4 +-
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts     |    2 +-
 .../boot/dts/qcom/sc8280xp-microsoft-arcata.dts    |    4 +-
 .../boot/dts/qcom/sc8280xp-microsoft-blackrock.dts |   19 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |   10 +-
 arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts |    2 +-
 arch/arm64/boot/dts/qcom/sdm670-google-common.dtsi |    5 +
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |    8 +-
 arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi |    4 +-
 arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi     |    4 +-
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |    8 +-
 .../boot/dts/qcom/sdm845-samsung-starqltechn.dts   |    4 +-
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts  |    4 +-
 .../dts/qcom/sdm845-xiaomi-beryllium-common.dtsi   |    4 +-
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts |    4 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   64 +-
 .../dts/qcom/sdm850-huawei-matebook-e-2019.dts     |    8 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |    8 +-
 arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts   |    8 +-
 .../boot/dts/qcom/sm6125-xiaomi-laurel-sprout.dts  |    2 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |  153 +--
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |    6 +-
 arch/arm64/boot/dts/qcom/sm8150-hdk.dts            |    8 +-
 .../boot/dts/qcom/sm8150-microsoft-surface-duo.dts |    4 +-
 arch/arm64/boot/dts/qcom/sm8150-mtp.dts            |    4 +-
 .../boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi   |    4 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8250-hdk.dts            |    8 +-
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts            |    8 +-
 .../boot/dts/qcom/sm8250-sony-xperia-edo.dtsi      |    4 +-
 .../boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi  |    2 +-
 arch/arm64/boot/dts/qcom/sm8250-xiaomi-pipa.dts    |    4 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   48 +-
 arch/arm64/boot/dts/qcom/sm8350-hdk.dts            |    8 +-
 .../dts/qcom/sm8350-microsoft-surface-duo2.dts     |    8 +-
 arch/arm64/boot/dts/qcom/sm8350-mtp.dts            |    8 +-
 .../boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi   |    4 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8450-hdk.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8450-qrd.dts            |    4 +-
 .../boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi   |    4 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8550-hdk.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8550-mtp.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8550-qrd.dts            |    4 +-
 .../dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts    |    4 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |    8 +-
 .../boot/dts/qcom/sm8650-ayaneo-pocket-s2.dts      |    4 +-
 arch/arm64/boot/dts/qcom/sm8650-hdk.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8650-mtp.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8650-qrd.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8750-mtp.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8750-qrd.dts            |    4 +-
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |    5 +-
 arch/arm64/boot/dts/qcom/talos-evk-som.dtsi        |    4 +-
 arch/arm64/boot/dts/qcom/talos.dtsi                |    8 +-
 arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi |   20 +-
 arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi  |   20 +-
 arch/arm64/boot/dts/qcom/x1-crd.dtsi               |   20 +-
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi        |   16 +-
 arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi   |   12 +-
 arch/arm64/boot/dts/qcom/x1-microsoft-denali.dtsi  |    8 +-
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts       |   20 +-
 .../dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi    |   20 +-
 .../boot/dts/qcom/x1e80100-dell-xps13-9345.dts     |   16 +-
 .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |   12 +-
 .../dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts    |   16 +-
 .../boot/dts/qcom/x1e80100-microsoft-romulus.dtsi  |   16 +-
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   20 +-
 .../boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts |   20 +-
 arch/arm64/boot/dts/renesas/r9a09g047.dtsi         |    2 +-
 arch/arm64/boot/dts/renesas/r9a09g056.dtsi         |    2 +-
 .../boot/dts/renesas/r9a09g077m44-rzt2h-evk.dts    |   14 +-
 .../boot/dts/renesas/r9a09g087m44-rzn2h-evk.dts    |   15 +-
 .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |    3 +-
 .../boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi  |    2 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |    4 +-
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi     |    4 +-
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi           |    2 +-
 arch/arm64/include/asm/processor.h                 |    2 +-
 arch/arm64/include/asm/ptdump.h                    |    2 +
 arch/arm64/include/asm/rsi_cmds.h                  |   27 +-
 arch/arm64/kernel/efi.c                            |    4 +-
 arch/arm64/kernel/entry-common.c                   |   30 +-
 arch/arm64/kernel/hibernate.c                      |   16 +-
 arch/arm64/kernel/ptrace.c                         |   54 +-
 arch/arm64/kernel/smp.c                            |    2 +-
 arch/arm64/lib/Makefile                            |    4 +
 arch/arm64/mm/ptdump.c                             |   14 +-
 arch/arm64/net/bpf_jit_comp.c                      |   68 +-
 arch/csky/kernel/entry.S                           |    6 +-
 arch/m68k/emu/nfcon.c                              |    2 +-
 arch/m68k/kernel/traps.c                           |    4 +-
 arch/mips/kernel/ptrace.c                          |    6 +-
 arch/powerpc/configs/85xx-hw.config                |    1 +
 arch/powerpc/include/asm/syscall.h                 |    6 +
 arch/powerpc/include/asm/thread_info.h             |    1 +
 arch/powerpc/include/asm/xive.h                    |    4 +-
 arch/powerpc/kernel/irq.c                          |   16 +-
 arch/powerpc/kernel/smp.c                          |    3 +
 arch/powerpc/kernel/syscall.c                      |    3 +
 arch/powerpc/kexec/crash.c                         |    2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |    6 +-
 arch/powerpc/net/bpf_timed_may_goto.S              |    2 +-
 arch/powerpc/platforms/44x/gpio.c                  |    1 +
 arch/powerpc/platforms/powernv/smp.c               |    8 +-
 arch/powerpc/platforms/pseries/smp.c               |    8 +-
 arch/powerpc/sysdev/cpm_common.c                   |   13 +
 arch/powerpc/sysdev/xive/common.c                  |   22 +-
 arch/riscv/boot/dts/sophgo/cv180x.dtsi             |    2 +-
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts    |    4 +-
 arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts  |    4 +-
 arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts     |    2 +-
 arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts   |    4 +-
 arch/riscv/boot/dts/spacemit/k1-pinctrl.dtsi       |   24 +-
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi        |    6 +-
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts       |   10 +-
 arch/riscv/boot/dts/thead/th1520.dtsi              |    3 +-
 arch/riscv/kernel/cpufeature.c                     |    3 +-
 arch/riscv/kernel/machine_kexec_file.c             |   14 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   28 +-
 arch/riscv/net/bpf_jit_core.c                      |    1 +
 arch/s390/include/asm/irqflags.h                   |   20 +-
 arch/s390/kernel/Makefile                          |    1 +
 arch/s390/kernel/debug.c                           |   10 +-
 arch/s390/kernel/irqflags.c                        |   28 +
 arch/s390/kernel/vdso/Makefile                     |    3 +-
 arch/s390/net/bpf_jit_comp.c                       |   15 +-
 arch/x86/entry/entry_64_fred.S                     |    2 +
 arch/x86/events/amd/uncore.c                       |   31 +
 arch/x86/events/core.c                             |    3 +-
 arch/x86/events/intel/core.c                       |    6 +-
 arch/x86/events/intel/pt.c                         |   96 +-
 arch/x86/events/intel/uncore.c                     |  151 ++-
 arch/x86/events/intel/uncore.h                     |   33 +-
 arch/x86/events/intel/uncore_discovery.c           |   21 +-
 arch/x86/events/intel/uncore_discovery.h           |    6 +-
 arch/x86/events/intel/uncore_nhmex.c               |    3 +-
 arch/x86/events/intel/uncore_snb.c                 |   82 +-
 arch/x86/events/intel/uncore_snbep.c               |   77 +-
 arch/x86/events/perf_event.h                       |    2 +-
 arch/x86/include/asm/linkage.h                     |    2 +-
 arch/x86/include/asm/pkeys.h                       |    3 +
 arch/x86/kernel/cpu/common.c                       |   25 +-
 arch/x86/kernel/uprobes.c                          |  408 ++++---
 arch/x86/kvm/Makefile                              |    4 +-
 arch/x86/kvm/regs.c                                |  874 ++++++++++++++
 arch/x86/kvm/regs.h                                |   30 +
 arch/x86/kvm/x86.c                                 |  885 +-------------
 arch/x86/kvm/x86.h                                 |    2 +
 arch/x86/mm/pat/set_memory.c                       |    8 +-
 arch/x86/net/bpf_jit_comp.c                        |   49 +-
 block/bio-integrity-auto.c                         |   10 +-
 block/bio-integrity-fs.c                           |    6 +-
 block/blk-cgroup.c                                 |    5 +
 block/blk-iocost.c                                 |    9 +-
 block/blk-iolatency.c                              |   13 +-
 block/blk-stat.c                                   |    2 +-
 block/fops.c                                       |    6 +-
 block/kyber-iosched.c                              |    2 +-
 crypto/acompress.c                                 |   16 +-
 crypto/lskcipher.c                                 |    1 -
 drivers/accessibility/speakup/keyhelp.c            |   17 +-
 drivers/accessibility/speakup/kobjects.c           |    6 +-
 drivers/acpi/acpi_platform.c                       |   16 +-
 drivers/acpi/battery.c                             |   44 +-
 drivers/acpi/bus.c                                 |   68 +-
 drivers/acpi/ec.c                                  |   40 +-
 drivers/acpi/pci_root.c                            |   14 +-
 drivers/acpi/processor_core.c                      |   31 +-
 drivers/acpi/processor_driver.c                    |    6 +
 drivers/acpi/processor_idle.c                      |   28 +-
 drivers/acpi/riscv/irq.c                           |   33 +-
 drivers/acpi/scan.c                                |   33 +-
 drivers/acpi/video_detect.c                        |    4 +-
 drivers/base/cacheinfo.c                           |    9 +-
 drivers/base/firmware_loader/fallback.c            |   10 +
 drivers/base/soc.c                                 |   15 +-
 drivers/base/swnode.c                              |    2 +-
 drivers/base/transport_class.c                     |    5 +-
 drivers/block/mtip32xx/mtip32xx.c                  |    7 +
 drivers/block/mtip32xx/mtip32xx.h                  |    2 +
 drivers/block/null_blk/main.c                      |   78 +-
 drivers/block/ublk_drv.c                           |  127 +-
 drivers/bluetooth/btintel.c                        |    2 +-
 drivers/bluetooth/btmtk.c                          |   11 +-
 drivers/bluetooth/btmtksdio.c                      |   40 +-
 drivers/bluetooth/btnxpuart.c                      |   15 +-
 drivers/bluetooth/btqca.c                          |    3 +-
 drivers/bluetooth/btusb.c                          |   17 +-
 drivers/bluetooth/virtio_bt.c                      |    8 +-
 drivers/bus/mhi/ep/main.c                          |   15 +-
 drivers/bus/mhi/host/init.c                        |    4 +-
 drivers/bus/mhi/host/main.c                        |    6 +
 drivers/bus/qcom-ebi2.c                            |   44 +-
 drivers/bus/ti-sysc.c                              |   12 +-
 drivers/char/hw_random/core.c                      |    4 +-
 drivers/char/hw_random/imx-rngc.c                  |    4 +-
 drivers/char/hw_random/ks-sa-rng.c                 |    9 +-
 drivers/char/hw_random/omap-rng.c                  |   30 +-
 drivers/char/hw_random/xilinx-trng.c               |   32 +-
 drivers/char/ppdev.c                               |   10 +-
 drivers/char/tlclk.c                               |   36 +-
 drivers/char/tpm/st33zp24/st33zp24.c               |    8 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    5 +-
 drivers/clk/clk-devres.c                           |   12 +-
 drivers/clk/clk-k230.c                             |    4 +
 drivers/clk/clk-moxart.c                           |   14 -
 drivers/clk/clk-palmas.c                           |   14 +-
 drivers/clk/clk-versaclock7.c                      |    2 +-
 drivers/clk/eswin/clk-eic7700.c                    |    3 +-
 drivers/clk/eswin/clk.c                            |    4 +-
 drivers/clk/hisilicon/reset.c                      |    2 +-
 drivers/clk/imx/clk-scu.c                          |    1 -
 drivers/clk/mediatek/clk-mt6735-apmixedsys.c       |    5 +-
 drivers/clk/mediatek/clk-mt8135.c                  |    5 +-
 drivers/clk/mediatek/clk-pllfh.c                   |   98 +-
 drivers/clk/nuvoton/clk-ma35d1-pll.c               |   42 +-
 drivers/clk/qcom/camcc-sc8280xp.c                  |   19 -
 drivers/clk/qcom/common.c                          |    4 +-
 drivers/clk/qcom/dispcc-qcm2290.c                  |   44 +-
 drivers/clk/qcom/gcc-glymur.c                      |   33 +-
 drivers/clk/qcom/gcc-nord.c                        |   45 +-
 drivers/clk/qcom/gcc-qcm2290.c                     |   18 +-
 drivers/clk/qcom/gcc-qcs8300.c                     |    8 +-
 drivers/clk/qcom/gcc-sm6115.c                      |    6 +-
 drivers/clk/qcom/gdsc.c                            |   47 +-
 drivers/clk/qcom/gdsc.h                            |    1 +
 drivers/clk/qcom/gpucc-qcm2290.c                   |   89 +-
 drivers/clk/qcom/gxclkctl-kaanapali.c              |    1 +
 drivers/clk/qcom/negcc-nord.c                      |   75 +-
 drivers/clk/rockchip/clk-pll.c                     |   16 +-
 drivers/clk/rockchip/clk-rk3576.c                  |   15 +-
 drivers/clk/rockchip/clk-rk3588.c                  |    4 +-
 drivers/clk/rockchip/clk.h                         |    8 +-
 drivers/clk/spacemit/ccu-k3.c                      |   17 +-
 drivers/clk/stm32/clk-stm32mp21.c                  |    1 +
 drivers/clk/stm32/clk-stm32mp25.c                  |    1 +
 drivers/clk/sunxi-ng/ccu_mux.c                     |   57 +-
 drivers/clk/tegra/clk-tegra124-emc.c               |    1 +
 drivers/clk/ti/adpll.c                             |    4 +-
 drivers/clk/ti/divider.c                           |    2 +-
 drivers/clk/ti/mux.c                               |   22 +-
 drivers/clk/visconti/clkc.c                        |    2 +-
 drivers/clk/x86/clk-pmc-atom.c                     |    3 +
 drivers/clocksource/clps711x-timer.c               |    2 +-
 drivers/clocksource/samsung_pwm_timer.c            |   22 +-
 drivers/clocksource/timer-armada-370-xp.c          |   18 +-
 drivers/cpufreq/amd-pstate-ut.c                    |    5 +
 drivers/cpufreq/amd-pstate.c                       |   47 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |    6 +-
 drivers/cpufreq/intel_pstate.c                     |   19 +-
 drivers/cpufreq/spear-cpufreq.c                    |    4 +-
 drivers/crypto/aspeed/aspeed-acry.c                |    2 +-
 drivers/crypto/aspeed/aspeed-hace.c                |    2 +-
 drivers/crypto/atmel-ecc.c                         |    3 +
 drivers/crypto/atmel-sha204a.c                     |    6 +-
 drivers/crypto/ccp/sev-dev.c                       |   19 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c           |    8 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   12 +-
 .../crypto/intel/keembay/keembay-ocs-aes-core.c    |    9 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |    2 +
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |   10 +-
 .../crypto/intel/qat/qat_common/adf_cfg_common.h   |    1 -
 .../crypto/intel/qat/qat_common/adf_cfg_services.c |    2 +-
 .../crypto/intel/qat/qat_common/adf_mstate_mgr.c   |    3 +-
 .../intel/qat/qat_common/adf_transport_debug.c     |    3 +-
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |    1 +
 .../crypto/intel/qat/qat_common/qat_compression.c  |    3 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |    7 +-
 drivers/crypto/sa2ul.c                             |    6 +-
 drivers/cxl/core/features.c                        |   15 +-
 drivers/cxl/core/mbox.c                            |   12 +-
 drivers/cxl/core/memdev.c                          |    2 +-
 drivers/cxl/core/port.c                            |    4 +-
 drivers/cxl/core/region.c                          |    7 +-
 drivers/cxl/pci.c                                  |   13 +-
 drivers/dax/dax-private.h                          |    2 -
 drivers/dax/fsdev.c                                |  139 ++-
 drivers/dax/super.c                                |   54 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  104 +-
 drivers/dma/hisi_dma.c                             |    2 +-
 drivers/dma/mediatek/mtk-uart-apdma.c              |    2 +-
 drivers/dma/qcom/bam_dma.c                         |    1 +
 drivers/dma/xilinx/xilinx_dma.c                    |   26 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |    4 +-
 drivers/dpll/dpll_core.c                           |   24 +-
 drivers/dpll/dpll_netlink.c                        |   59 +-
 drivers/firewire/.kunitconfig                      |    1 +
 drivers/firewire/Kconfig                           |   15 +
 drivers/firewire/core-topology.c                   |   62 +-
 drivers/firewire/node-tree-test.c                  |  607 ++++++++++
 drivers/firmware/arm_scmi/bus.c                    |  182 +--
 drivers/firmware/arm_scmi/common.h                 |    2 +
 drivers/firmware/arm_scmi/driver.c                 |   81 +-
 drivers/firmware/arm_scmi/notify.c                 |   21 +
 drivers/firmware/arm_scmi/notify.h                 |    1 +
 drivers/firmware/arm_scmi/transports/mailbox.c     |   26 +-
 drivers/firmware/arm_scmi/transports/smc.c         |   15 +-
 drivers/firmware/google/coreboot_table.c           |   17 +-
 drivers/firmware/imx/sm-misc.c                     |    3 +
 drivers/firmware/qcom/Makefile                     |    1 +
 drivers/firmware/qcom/qcom_scm-smc.c               |   12 +-
 drivers/firmware/qcom/qcom_scm.c                   |   42 +-
 drivers/firmware/qcom/qcom_scm.h                   |    2 +-
 drivers/firmware/qcom/qcom_scm_trace.h             |  143 +++
 drivers/firmware/qcom/qcom_tzmem.c                 |   13 +-
 drivers/gpib/common/gpib_os.c                      |   21 +-
 drivers/gpib/common/iblib.c                        |    3 -
 drivers/gpib/include/amccs5933.h                   |   10 +-
 drivers/gpib/tnt4882/mite.h                        |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |    2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   15 +
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |   74 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   22 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    7 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    8 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   10 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h |   10 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   12 +-
 .../gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c |    2 +-
 .../gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c |    3 +-
 .../dc/link/protocols/link_dp_irq_handler.c        |    1 -
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c  |   11 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   24 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |   35 +-
 .../gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_8_ppt.c   |    5 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |    2 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |    2 +-
 drivers/gpu/drm/bridge/display-connector.c         |   36 +
 drivers/gpu/drm/bridge/of-display-mode-bridge.c    |    2 +-
 drivers/gpu/drm/bridge/synopsys/dw-dp.c            |    6 +
 drivers/gpu/drm/bridge/tc358767.c                  |    2 +-
 drivers/gpu/drm/display/drm_hdmi_state_helper.c    |   15 +-
 drivers/gpu/drm/drm_atomic_state_helper.c          |    2 -
 drivers/gpu/drm/drm_dumb_buffers.c                 |    1 -
 drivers/gpu/drm/lima/lima_device.c                 |   12 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |    5 +
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |    2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |    5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |    8 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |    5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h        |   12 +
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c              |    5 +-
 .../drm/msm/disp/dpu1/catalog/dpu_13_0_kaanapali.h |   12 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |    4 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |    3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   12 +
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |   22 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   11 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |    5 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   28 +-
 drivers/gpu/drm/msm/dp/dp_panel.c                  |    4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |    2 -
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.h              |    1 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |   18 +-
 drivers/gpu/drm/msm/msm_drv.h                      |    8 -
 drivers/gpu/drm/msm/msm_gem_vma.c                  |    2 +
 drivers/gpu/drm/msm/msm_gpu.c                      |    8 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c               |    7 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h               |    1 +
 drivers/gpu/drm/mxsfb/lcdif_kms.c                  |   15 +-
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |    7 +-
 drivers/gpu/drm/omapdrm/dss/dsi.h                  |    2 -
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c      |   10 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |    2 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |   18 +
 drivers/gpu/drm/panthor/panthor_gem.h              |    2 +
 drivers/gpu/drm/panthor/panthor_mmu.c              |  251 +++-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   22 +-
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c          |   15 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |    5 +-
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c       |   21 +-
 drivers/gpu/drm/solomon/ssd130x.c                  |    9 +-
 drivers/gpu/drm/sun4i/sun4i_crtc.c                 |    2 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |    3 +
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |    2 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |   22 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |    2 +
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |    2 +-
 drivers/gpu/drm/sun4i/sun8i_mixer.c                |    2 +-
 drivers/gpu/drm/sun4i/sun8i_tcon_top.c             |   71 +-
 drivers/gpu/drm/sun4i/sun8i_tcon_top.h             |    6 +
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c            |   20 +-
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.h            |    1 +
 drivers/gpu/drm/tegra/dsi.c                        |    9 +
 drivers/gpu/drm/tve200/tve200_drv.c                |    1 +
 drivers/gpu/drm/v3d/Kconfig                        |    1 +
 drivers/gpu/drm/v3d/v3d_drv.h                      |   39 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   60 +-
 drivers/gpu/drm/v3d/v3d_submit.c                   |  737 ++++++------
 drivers/gpu/drm/xe/tests/xe_migrate.c              |    3 +-
 drivers/gpu/drm/xe/xe_gt_idle.c                    |    3 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |    6 +
 drivers/gpu/drm/xe/xe_pagefault.c                  |    2 +-
 drivers/gpu/drm/xe/xe_ras.c                        |   91 ++
 drivers/gpu/drm/xe/xe_ras.h                        |    3 +
 drivers/gpu/drm/xe/xe_ras_types.h                  |   26 +
 drivers/gpu/drm/xe/xe_sysctrl.c                    |    7 +-
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.c            |   36 +-
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.h            |    4 +-
 drivers/gpu/drm/xe/xe_sysctrl_mailbox_types.h      |    2 +
 drivers/gpu/drm/xe/xe_sysctrl_types.h              |    3 -
 drivers/gpu/drm/xe/xe_wa_oob.rules                 |    2 +-
 drivers/gpu/host1x/bus.c                           |    2 +-
 drivers/gpu/host1x/debug.c                         |    4 +-
 drivers/gpu/host1x/hw/channel_hw.c                 |    5 +-
 drivers/gpu/nova-core/fb/hal/gb100.rs              |    1 +
 drivers/gpu/nova-core/fb/hal/gb202.rs              |    1 +
 drivers/gpu/nova-core/fsp.rs                       |   87 +-
 drivers/gpu/nova-core/fsp/hal.rs                   |    4 +
 drivers/gpu/nova-core/fsp/hal/gb100.rs             |    6 +
 drivers/gpu/nova-core/fsp/hal/gb202.rs             |    9 +-
 drivers/gpu/nova-core/fsp/hal/gh100.rs             |    9 +-
 drivers/gpu/nova-core/gpu.rs                       |    6 +-
 drivers/gpu/nova-core/gsp/boot.rs                  |    2 +-
 drivers/gpu/nova-core/gsp/commands.rs              |   73 +-
 drivers/gpu/nova-core/gsp/hal/tu102.rs             |   19 +-
 drivers/gpu/nova-core/regs.rs                      |    2 +-
 drivers/hid/hid-asus.c                             |  430 +++++--
 drivers/hid/hid-core.c                             |    9 +
 drivers/hid/hid-haptic.c                           |    2 +-
 drivers/hid/hid-lg4ff.c                            |    8 +
 drivers/hid/hid-logitech-hidpp.c                   |   23 +-
 drivers/hid/hid-multitouch.c                       |    2 +-
 drivers/hid/hid-nintendo.c                         |    1 -
 drivers/hid/hid-roccat-kone.c                      |    8 +-
 drivers/hid/hid-sony.c                             |    2 +-
 drivers/hid/hid-steam.c                            |  516 +++++---
 drivers/hid/hid-tmff.c                             |    9 +-
 drivers/hid/i2c-hid/Makefile                       |    2 +-
 drivers/hid/i2c-hid/i2c-hid-acpi-prp0001.c         |  104 ++
 drivers/hid/i2c-hid/i2c-hid-acpi.c                 |   54 +-
 drivers/hid/i2c-hid/i2c-hid-acpi.h                 |   33 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |    2 +-
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c            |    4 +-
 drivers/hv/vmbus_drv.c                             |   15 +
 drivers/hwmon/coretemp.c                           |    1 +
 drivers/hwmon/cros_ec_hwmon.c                      |   17 +-
 drivers/hwmon/emc1403.c                            |   27 +-
 drivers/hwmon/ltc4283.c                            |    1 +
 drivers/hwspinlock/hwspinlock_core.c               |    2 +-
 drivers/hwtracing/coresight/coresight-etm4x-cfg.c  |    2 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   59 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |    6 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |    7 +-
 drivers/i2c/busses/i2c-ocores.c                    |    6 +-
 drivers/i3c/master.c                               |   63 +-
 drivers/i3c/master/adi-i3c-master.c                |    1 +
 drivers/i3c/master/dw-i3c-master.c                 |   10 +-
 drivers/i3c/master/mipi-i3c-hci/pio.c              |    7 +-
 drivers/i3c/master/renesas-i3c.c                   |   28 +-
 drivers/idle/intel_idle.c                          |   23 +
 drivers/iio/accel/dmard09.c                        |    7 +
 drivers/iio/dac/ad5686-spi.c                       |    9 +-
 drivers/iio/dac/ad5696-i2c.c                       |    9 +-
 drivers/iio/light/gp2ap002.c                       |   14 +-
 drivers/iio/light/isl29028.c                       |    2 +-
 drivers/iio/light/opt4060.c                        |    4 +-
 drivers/iio/light/tsl2583.c                        |    2 +-
 drivers/iio/light/tsl2772.c                        |    2 +-
 drivers/iio/orientation/hid-sensor-rotation.c      |   20 +-
 drivers/infiniband/core/cma.c                      |    6 +-
 drivers/infiniband/core/counters.c                 |    5 +-
 drivers/infiniband/core/cq.c                       |    2 +-
 drivers/infiniband/core/device.c                   |    1 +
 drivers/infiniband/core/nldev.c                    |    5 +
 drivers/infiniband/core/restrack.c                 |  165 ++-
 drivers/infiniband/core/restrack.h                 |    3 +
 drivers/infiniband/core/ucma.c                     |    2 +-
 drivers/infiniband/core/uverbs_std_types_dmah.c    |    7 +-
 drivers/infiniband/core/verbs.c                    |   32 +-
 drivers/infiniband/hw/bng_re/bng_fw.c              |   10 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   71 +-
 drivers/infiniband/hw/cxgb4/device.c               |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |   50 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   15 +-
 drivers/infiniband/hw/erdma/Kconfig                |    2 +-
 drivers/infiniband/hw/erdma/erdma_cm.c             |    6 +-
 drivers/infiniband/hw/erdma/erdma_eq.c             |   10 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   39 +-
 drivers/infiniband/hw/erdma/erdma_verbs.h          |   40 +-
 drivers/infiniband/hw/hfi1/init.c                  |   16 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   13 +-
 drivers/infiniband/hw/irdma/utils.c                |    6 +
 drivers/infiniband/hw/irdma/verbs.c                |  116 +-
 drivers/infiniband/hw/irdma/verbs.h                |    3 +
 drivers/infiniband/hw/mana/qp.c                    |   10 +-
 drivers/infiniband/hw/mlx5/cong.c                  |    8 +-
 drivers/infiniband/hw/mlx5/main.c                  |    7 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   25 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |    4 +-
 drivers/infiniband/sw/rxe/rxe_odp.c                |    1 +
 drivers/infiniband/sw/rxe/rxe_req.c                |   15 +
 drivers/infiniband/sw/rxe/rxe_resp.c               |    9 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    2 +
 drivers/infiniband/ulp/isert/ib_isert.c            |   85 +-
 drivers/infiniband/ulp/isert/ib_isert.h            |    1 +
 drivers/infiniband/ulp/srp/ib_srp.c                |   45 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    9 +-
 drivers/iommu/amd/debugfs.c                        |   12 +-
 drivers/iommu/amd/init.c                           |   36 +-
 drivers/iommu/amd/ppr.c                            |    2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |    9 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |  173 ++-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |    6 +-
 drivers/iommu/dma-iommu.c                          |   26 +-
 drivers/iommu/intel/iommu.c                        |   32 +-
 drivers/iommu/intel/iommu.h                        |    2 +-
 drivers/iommu/intel/pasid.c                        |    9 +-
 drivers/iommu/iommufd/device.c                     |   13 +-
 drivers/iommu/iommufd/iommufd_private.h            |    9 +-
 drivers/iommu/iommufd/main.c                       |   20 +
 drivers/iommu/iommufd/selftest.c                   |   12 +-
 drivers/iommu/msm_iommu.c                          |    2 +-
 drivers/iommu/mtk_iommu_v1.c                       |    2 +-
 drivers/ipack/devices/ipoctal.c                    |   56 +-
 drivers/irqchip/irq-ast2700-intc0.c                |    4 +-
 drivers/irqchip/irq-ast2700-intc1.c                |    3 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   23 +-
 drivers/irqchip/irq-gic-v5-irs.c                   |   38 +-
 drivers/irqchip/irq-gic-v5.c                       |   29 +-
 drivers/irqchip/irq-realtek-rtl.c                  |  127 +-
 drivers/irqchip/irq-renesas-irqc.c                 |    1 +
 drivers/irqchip/irq-renesas-rzg2l.c                |    4 +-
 drivers/leds/leds-gpio.c                           |   53 +-
 drivers/leds/leds-pca9532.c                        |   18 +-
 drivers/leds/leds-st1202.c                         |   96 +-
 drivers/leds/rgb/leds-lp5860-core.c                |    3 +-
 drivers/leds/rgb/leds-lp5860-spi.c                 |   10 +-
 drivers/mailbox/pcc.c                              |   41 +-
 drivers/mailbox/qcom-cpucp-mbox.c                  |   25 +-
 drivers/mailbox/riscv-sbi-mpxy-mbox.c              |   12 +-
 drivers/mailbox/rockchip-mailbox.c                 |   17 +-
 drivers/md/dm-integrity.c                          |  139 ++-
 drivers/md/dm-pcache/cache.c                       |   11 +
 drivers/md/dm-pcache/cache.h                       |   17 +
 drivers/md/dm-pcache/cache_gc.c                    |   16 +-
 drivers/md/dm-pcache/cache_key.c                   |   80 ++
 drivers/md/dm-pcache/cache_writeback.c             |   23 +-
 drivers/md/md-bitmap.c                             |   14 +-
 drivers/md/md-bitmap.h                             |    3 +-
 drivers/md/md-linear.c                             |    1 +
 drivers/md/md-llbitmap.c                           |   30 +-
 drivers/md/md.c                                    |   80 +-
 drivers/md/md.h                                    |    1 -
 drivers/md/raid0.c                                 |    1 +
 drivers/md/raid1-10.c                              |    8 +-
 drivers/md/raid1.c                                 |  121 +-
 drivers/md/raid10.c                                |  112 +-
 drivers/md/raid5-ppl.c                             |    4 +-
 drivers/md/raid5.c                                 |  108 +-
 drivers/media/cec/core/cec-pin.c                   |    8 +-
 drivers/media/i2c/rdacm21.c                        |    5 +-
 drivers/media/pci/intel/ipu6/ipu6.c                |   10 +-
 drivers/media/platform/amd/isp4/Kconfig            |    1 +
 drivers/media/platform/amd/isp4/isp4_interface.c   |   10 +-
 drivers/media/platform/amd/isp4/isp4_interface.h   |    2 +-
 drivers/media/platform/amd/isp4/isp4_subdev.c      |   30 +-
 drivers/media/platform/broadcom/bcm2835-unicam.c   |    2 +
 drivers/media/platform/qcom/iris/iris_core.c       |   12 +-
 .../platform/qcom/iris/iris_hfi_gen2_command.c     |    1 -
 drivers/media/platform/qcom/iris/iris_state.c      |    2 +-
 drivers/media/platform/st/stm32/stm32-dcmi.c       |   15 +-
 drivers/media/platform/ti/Kconfig                  |    1 +
 drivers/media/v4l2-core/v4l2-async.c               |   15 +-
 drivers/mfd/cs42l43.c                              |   16 +-
 drivers/mfd/iqs62x.c                               |    2 +-
 drivers/mfd/macsmc.c                               |    8 +-
 drivers/mfd/rave-sp.c                              |   64 +-
 drivers/misc/ad525x_dpot-i2c.c                     |    1 +
 drivers/misc/ad525x_dpot-spi.c                     |    1 +
 drivers/misc/ad525x_dpot.c                         |  177 +--
 drivers/misc/ad525x_dpot.h                         |    3 +
 drivers/misc/bcm-vk/bcm_vk_msg.c                   |    6 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |    2 +
 drivers/misc/cardreader/rtsx_usb.c                 |   26 +-
 drivers/misc/lan966x_pci.c                         |    1 +
 drivers/misc/mei/mei_lb.c                          |    4 +-
 drivers/misc/pch_phub.c                            |   20 +-
 drivers/misc/pci_endpoint_test.c                   |   11 +-
 drivers/misc/sgi-gru/grufault.c                    |  101 +-
 drivers/misc/sgi-gru/gruprocfs.c                   |    1 -
 drivers/misc/sgi-gru/grutables.h                   |    1 -
 drivers/misc/vmw_vmci/vmci_event.c                 |    4 +-
 drivers/mtd/devices/mtd_intel_dg.c                 |    2 +-
 drivers/mtd/mtdpart.c                              |    3 +-
 drivers/mtd/mtdswap.c                              |    1 +
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |    8 +-
 drivers/mtd/ubi/attach.c                           |    4 +-
 drivers/mtd/ubi/build.c                            |   11 +-
 drivers/mtd/ubi/fastmap.c                          |    6 +-
 drivers/mtd/ubi/io.c                               |   11 +-
 drivers/mtd/ubi/ubi.h                              |    4 +-
 drivers/mtd/ubi/wl.c                               |   15 +-
 drivers/net/amt.c                                  |    3 +
 drivers/net/bonding/bond_netlink.c                 |    2 +-
 drivers/net/can/m_can/m_can.c                      |    2 +-
 drivers/net/dsa/b53/b53_common.c                   |    2 +-
 drivers/net/dsa/mv88e6xxx/pcs-6352.c               |    5 +-
 drivers/net/dsa/mxl862xx/mxl862xx.c                |    1 +
 drivers/net/ethernet/airoha/airoha_eth.c           |   18 +-
 drivers/net/ethernet/airoha/airoha_eth.h           |    7 +-
 drivers/net/ethernet/airoha/airoha_npu.c           |    2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c    |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   72 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   11 +-
 .../net/ethernet/freescale/enetc/enetc4_debugfs.c  |   30 +-
 drivers/net/ethernet/freescale/enetc/enetc4_hw.h   |    4 -
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c   |  347 ++----
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |    7 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   76 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.h    |    4 -
 .../net/ethernet/freescale/enetc/enetc_pf_common.c |   84 ++
 .../net/ethernet/freescale/enetc/enetc_pf_common.h |    4 +
 drivers/net/ethernet/freescale/fec_main.c          |    6 +-
 drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c  |    2 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_tx.c     |    9 +-
 drivers/net/ethernet/intel/ice/devlink/devlink.c   |   32 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   18 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |    3 +
 drivers/net/ethernet/intel/ice/ice_nvm.c           |   90 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h           |    2 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |   38 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |    2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |    3 +-
 .../net/ethernet/marvell/octeontx2/af/cn20k/api.h  |    1 +
 .../marvell/octeontx2/af/cn20k/mbox_init.c         |   21 +-
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   43 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |    6 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    6 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |    3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   20 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_xsk.c  |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   20 +-
 .../ethernet/mellanox/mlx5/core/esw/adj_vport.c    |   22 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    4 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   44 +-
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |   11 +-
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.c   |    5 +-
 .../net/ethernet/microchip/vcap/vcap_api_debugfs.c |   21 +
 .../net/ethernet/microchip/vcap/vcap_api_debugfs.h |   14 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   19 +
 drivers/net/ethernet/nvidia/forcedeth.c            |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |    4 +
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   31 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |  467 ++++----
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |    1 +
 drivers/net/ethernet/realtek/8139cp.c              |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   30 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   57 +-
 drivers/net/ethernet/wangxun/libwx/wx_ptp.c        |   18 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |    2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c     |    5 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |    2 +-
 drivers/net/gtp.c                                  |    2 +
 drivers/net/ipa/ipa_main.c                         |    6 +-
 drivers/net/netdevsim/netdev.c                     |    2 +
 drivers/net/phy/air_en8811h.c                      |   18 +-
 drivers/net/ppp/pppox.c                            |   17 +
 drivers/net/slip/slip.c                            |    8 -
 drivers/net/thunderbolt/main.c                     |    6 +-
 drivers/net/virtio_net.c                           |   14 +
 drivers/net/vxlan/vxlan_core.c                     |   20 +-
 drivers/net/vxlan/vxlan_mdb.c                      |    9 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |    6 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    9 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   32 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   40 +-
 drivers/net/wireless/ath/ath12k/ahb.c              |   18 +-
 drivers/net/wireless/ath/ath12k/core.c             |   29 +-
 drivers/net/wireless/ath/ath12k/core.h             |   13 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |   46 +
 drivers/net/wireless/ath/ath12k/dp_tx.h            |    2 +
 drivers/net/wireless/ath/ath12k/hal.c              |    8 +-
 drivers/net/wireless/ath/ath12k/hal.h              |    5 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   72 +-
 drivers/net/wireless/ath/ath12k/peer.c             |  132 +-
 drivers/net/wireless/ath/ath12k/peer.h             |   14 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |  168 ++-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |   64 +-
 .../net/wireless/ath/ath12k/wifi7/hal_rx_desc.h    |   34 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |   61 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  160 ++-
 drivers/net/wireless/ath/ath12k/wmi.h              |    8 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   17 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    4 +
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    8 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    2 +-
 drivers/net/wireless/mediatek/mt76/channel.c       |   98 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   48 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |    2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   15 +
 drivers/net/wireless/mediatek/mt76/mcu.c           |   12 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    7 +
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    8 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    6 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   16 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    4 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   24 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   18 +
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  103 ++
 drivers/net/wireless/mediatek/mt76/mt7925/Makefile |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   56 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c    |  927 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7925/nan.h    |  419 +++++++
 drivers/net/wireless/mediatek/mt76/mt7925/regd.c   |   30 +
 drivers/net/wireless/mediatek/mt76/mt7925/regd.h   |    3 +
 drivers/net/wireless/mediatek/mt76/mt792x.h        |   38 +
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |   91 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   20 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   60 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   40 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   90 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   24 +-
 drivers/net/wireless/mediatek/mt76/scan.c          |   17 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |   11 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    9 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   11 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    6 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   10 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |    3 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |    2 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   35 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    2 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |    5 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |    8 +
 drivers/nfc/pn533/pn533.c                          |   21 +-
 drivers/nvdimm/label.c                             |   15 +-
 drivers/nvdimm/nd_virtio.c                         |  121 +-
 drivers/nvdimm/pmem.c                              |   15 +-
 drivers/nvdimm/region_devs.c                       |    5 +-
 drivers/nvdimm/virtio_pmem.c                       |   17 +-
 drivers/nvdimm/virtio_pmem.h                       |    6 +
 drivers/nvme/host/apple.c                          |   62 +-
 drivers/nvme/host/core.c                           |    5 +-
 drivers/nvme/host/fc.c                             |    6 +
 drivers/nvme/host/ioctl.c                          |  117 +-
 drivers/nvme/host/nvme.h                           |    7 +
 drivers/nvme/host/pci.c                            |    2 +
 drivers/nvme/target/admin-cmd.c                    |   12 +-
 drivers/nvme/target/configfs.c                     |   10 +-
 drivers/nvme/target/core.c                         |   54 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |   12 +-
 drivers/nvme/target/fabrics-cmd.c                  |    2 +-
 drivers/nvme/target/nvmet.h                        |    6 +
 drivers/nvme/target/pci-epf.c                      |    2 +-
 drivers/nvme/target/pr.c                           |   27 +-
 drivers/nvme/target/rdma.c                         |   31 +-
 drivers/nvme/target/zns.c                          |    2 +-
 drivers/of/irq.c                                   |    4 +-
 drivers/opp/core.c                                 |   13 +-
 drivers/pci/controller/cadence/Kconfig             |    4 +-
 drivers/pci/controller/cadence/pci-j721e.c         |    4 +-
 drivers/pci/controller/dwc/Kconfig                 |    2 +
 drivers/pci/controller/dwc/pci-keystone.c          |    6 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   19 +
 drivers/pci/controller/dwc/pcie-designware.h       |    1 +
 drivers/pci/controller/dwc/pcie-qcom.c             |   37 +
 drivers/pci/controller/dwc/pcie-ultrarisc.c        |   85 +-
 drivers/pci/controller/pci-xgene.c                 |    5 +-
 drivers/pci/controller/plda/pcie-starfive.c        |   10 +-
 drivers/pci/pci-driver.c                           |  192 +--
 drivers/pci/pci-sysfs.c                            |   26 +-
 drivers/pci/pci.h                                  |   41 +-
 drivers/pci/pcie/aspm.c                            |   19 +-
 drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c           |   24 +-
 drivers/pci/search.c                               |    8 +-
 drivers/perf/arm_pmuv3.c                           |    2 +-
 drivers/perf/arm_spe_pmu.c                         |    2 +-
 drivers/perf/cxl_pmu.c                             |    2 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |   33 +-
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           |    1 +
 drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c     |   12 +-
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   12 +-
 drivers/phy/qualcomm/phy-qcom-sgmii-eth.c          |   37 +-
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c      |   26 +-
 drivers/phy/renesas/phy-rcar-gen2.c                |    1 -
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |   27 +-
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c   |    2 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |  160 ++-
 drivers/phy/starfive/phy-jh7110-dphy-rx.c          |    5 +-
 drivers/phy/starfive/phy-jh7110-dphy-tx.c          |    5 +-
 drivers/phy/sunplus/phy-sunplus-usb2.c             |    6 +-
 drivers/pinctrl/Kconfig                            |    4 +-
 drivers/pinctrl/airoha/pinctrl-airoha.c            |  362 ++++--
 drivers/pinctrl/bcm/Kconfig                        |    2 +
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |    1 -
 drivers/pinctrl/freescale/pinctrl-imx1-core.c      |    7 +-
 drivers/pinctrl/mediatek/mtk-eint.c                |   25 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c           |    6 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   14 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |    2 +-
 drivers/pinctrl/pinctrl-eic7700.c                  |    3 +
 drivers/pinctrl/pinctrl-generic.c                  |   25 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   50 +-
 drivers/pinctrl/qcom/pinctrl-shikra.c              |    1 +
 drivers/pinctrl/spacemit/pinctrl-k1.c              |   10 +-
 drivers/pinctrl/tegra/pinctrl-tegra264.c           |   24 +-
 drivers/platform/arm64/qcom-hamoa-ec.c             |    4 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |    6 +-
 drivers/platform/chrome/cros_ec_lightbar.c         |    7 +-
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   |    9 +-
 drivers/platform/chrome/cros_ec_typec.c            |    6 +
 drivers/platform/mellanox/mlxbf-bootctl.c          |    1 +
 drivers/platform/mellanox/mlxbf-pmc.c              |   10 +-
 drivers/platform/surface/surface_acpi_notify.c     |    6 +-
 drivers/platform/x86/acer-wmi.c                    |    4 +-
 drivers/platform/x86/amd/hsmp/hwmon.c              |    3 +
 drivers/platform/x86/asus-wireless.c               |   11 +-
 drivers/platform/x86/asus-wmi.c                    |    6 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |   19 +-
 drivers/platform/x86/dell/dell-wmi-privacy.c       |    4 +-
 .../x86/dell/dell-wmi-sysman/dell-wmi-sysman.h     |    2 +-
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |    5 +
 drivers/platform/x86/lg-laptop.c                   |   21 +-
 drivers/pmdomain/bcm/bcm2835-power.c               |    7 +-
 drivers/power/reset/reboot-mode.c                  |   30 +-
 drivers/power/supply/bd71828-power.c               |   20 +-
 drivers/power/supply/bd99954-charger.h             |   23 +-
 drivers/power/supply/bq27xxx_battery.c             |    6 +-
 drivers/power/supply/isp1704_charger.c             |    1 +
 drivers/power/supply/sbs-battery.c                 |    7 +-
 drivers/power/supply/sc2731_charger.c              |    2 +
 drivers/powercap/intel_rapl_common.c               |   11 +-
 drivers/powercap/intel_rapl_tpmi.c                 |    5 +-
 drivers/pps/clients/pps-gpio.c                     |   66 +-
 drivers/pps/pps.c                                  |   10 +-
 drivers/ptp/ptp_netc.c                             |   13 +-
 drivers/pwm/pwm-samsung.c                          |   22 +-
 drivers/rapidio/rio-scan.c                         |    1 +
 drivers/regulator/adp5055-regulator.c              |    2 +-
 drivers/regulator/core.c                           |    6 +-
 drivers/regulator/qcom-rpmh-regulator.c            |    6 +-
 drivers/regulator/tps65185.c                       |   11 +-
 drivers/regulator/tps6594-regulator.c              |   19 +-
 drivers/remoteproc/qcom_common.c                   |    4 +-
 drivers/remoteproc/qcom_common.h                   |    6 +
 drivers/remoteproc/qcom_q6v5.c                     |    5 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |    1 +
 drivers/remoteproc/qcom_q6v5_mss.c                 |   19 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   68 ++
 drivers/remoteproc/qcom_sysmon.c                   |   19 +
 drivers/remoteproc/qcom_wcnss.c                    |   23 +-
 drivers/remoteproc/remoteproc_core.c               |   67 +-
 drivers/remoteproc/remoteproc_sysfs.c              |    1 -
 drivers/resctrl/mpam_devices.c                     |   10 +-
 drivers/rpmsg/qcom_glink_native.c                  |    3 -
 drivers/rtc/rtc-gamecube.c                         |    4 +-
 drivers/rtc/rtc-pcf85363.c                         |   17 +-
 drivers/rtc/rtc-pcf8563.c                          |    4 +-
 drivers/rtc/rtc-spacemit-p1.c                      |    5 +-
 drivers/rtc/rtc-zynqmp.c                           |    7 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    2 +
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 -
 drivers/scsi/qla2xxx/qla_nx2.c                     |    2 +-
 drivers/scsi/sd.c                                  |   55 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   18 +
 drivers/soc/fsl/qe/gpio.c                          |   25 +
 drivers/soc/fsl/qe/qe_ic.c                         |    3 +-
 drivers/soc/fsl/qe/qe_io.c                         |   15 +
 drivers/soc/qcom/pmic_glink_altmode.c              |    3 +-
 drivers/soc/qcom/rpmh-rsc.c                        |   37 +-
 drivers/soc/renesas/Kconfig                        |    1 -
 drivers/soc/samsung/exynos-pmu.c                   |    4 +-
 drivers/soc/ti/knav_qmss.h                         |    1 +
 drivers/soc/ti/knav_qmss_queue.c                   |    7 +-
 drivers/soundwire/cadence_master.c                 |   24 +-
 drivers/soundwire/qcom.c                           |    2 +-
 drivers/spi/spi-amlogic-spisg.c                    |    2 +-
 drivers/spi/spi-davinci.c                          |    7 +-
 drivers/spi/spi-geni-qcom.c                        |   17 +-
 drivers/spi/spi-img-spfi.c                         |    5 +-
 drivers/spi/spi-oc-tiny.c                          |   24 +-
 drivers/spi/spi-sprd-adi.c                         |    6 +
 drivers/staging/fbtft/fbtft-sysfs.c                |    2 +-
 drivers/staging/greybus/audio_gb.c                 |   13 +
 drivers/staging/greybus/audio_manager_sysfs.c      |    2 +-
 drivers/staging/media/ipu7/ipu7-isys.c             |    1 +
 drivers/staging/media/ipu7/ipu7.c                  |    4 +-
 drivers/staging/octeon/ethernet-rx.c               |    2 +
 drivers/staging/octeon/ethernet-tx.c               |    2 +
 drivers/staging/rtl8723bs/core/rtw_cmd.c           |    8 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   22 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |    4 +-
 drivers/staging/sm750fb/Kconfig                    |    1 +
 drivers/staging/sm750fb/sm750.c                    |    6 +-
 drivers/staging/sm750fb/sm750.h                    |    2 +-
 drivers/staging/sm750fb/sm750_accel.c              |    6 +-
 drivers/staging/sm750fb/sm750_accel.h              |    4 +-
 drivers/thermal/airoha_thermal.c                   |    4 +-
 .../intel/int340x_thermal/int3400_thermal.c        |    4 +-
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c           |    3 -
 drivers/thermal/renesas/rcar_thermal.c             |   15 +-
 drivers/thermal/spacemit/k1_tsensor.c              |    5 +-
 drivers/thermal/thermal_hwmon.c                    |   89 +-
 drivers/thunderbolt/stream.c                       |   12 +-
 drivers/tty/hvc/Kconfig                            |    2 +-
 drivers/tty/serial/amba-pl011.c                    |   48 +-
 drivers/tty/serial/ma35d1_serial.c                 |   12 +-
 drivers/tty/serial/qcom_geni_serial.c              |   10 +-
 drivers/tty/serial/serial_core.c                   |   32 +-
 drivers/tty/tty_io.c                               |    6 +-
 drivers/ufs/core/ufs-debugfs.c                     |    2 +-
 drivers/ufs/core/ufs-rpmb.c                        |    4 +
 drivers/ufs/core/ufs-txeq.c                        |   27 +-
 drivers/ufs/core/ufshcd.c                          |   33 +-
 drivers/uio/uio.c                                  |    5 +
 drivers/usb/atm/usbatm.c                           |    4 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    2 +-
 drivers/usb/core/driver.c                          |   12 +-
 drivers/usb/gadget/configfs.c                      |    4 +-
 drivers/usb/gadget/function/f_fs.c                 |    8 +-
 drivers/usb/gadget/function/f_uac1.c               |   13 +-
 drivers/usb/gadget/function/f_uac1_legacy.c        |   56 -
 drivers/usb/gadget/function/f_uac2.c               |   13 +-
 drivers/usb/gadget/function/u_uac1_legacy.h        |    3 -
 drivers/usb/gadget/udc/aspeed_udc.c                |   50 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |    1 -
 drivers/usb/misc/usb-ljca.c                        |    3 +
 drivers/usb/mtu3/mtu3_core.c                       |   11 +-
 drivers/usb/renesas_usbhs/common.c                 |    6 +-
 drivers/usb/typec/ucsi/debugfs.c                   |    1 +
 drivers/usb/typec/ucsi/ucsi.c                      |    2 +
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c        |   15 +-
 drivers/vdpa/mlx5/core/mr.c                        |    2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   25 +-
 drivers/vfio/pci/vfio_pci_config.c                 |    1 +
 drivers/vfio/pci/vfio_pci_core.c                   |    3 +
 drivers/vhost/net.c                                |    3 +-
 drivers/video/backlight/Kconfig                    |    2 +-
 drivers/video/backlight/aw99706.c                  |   15 +-
 drivers/video/fbdev/clps711x-fb.c                  |    2 -
 drivers/video/fbdev/kyro/fbdev.c                   |   24 +-
 drivers/video/fbdev/tdfxfb.c                       |    2 +-
 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c    |   97 +-
 drivers/virtio/virtio.c                            |   41 +-
 drivers/virtio/virtio_balloon.c                    |   40 +-
 drivers/virtio/virtio_pci_common.c                 |    2 +-
 drivers/virtio/virtio_rtc_driver.c                 |   14 +-
 drivers/w1/masters/ds2482.c                        |    4 +
 drivers/xen/xenbus/xenbus_probe.c                  |    3 +-
 drivers/xen/xenbus/xenbus_xs.c                     |   16 +-
 fs/btrfs/acl.c                                     |    4 +
 fs/btrfs/block-group.c                             |    8 +-
 fs/btrfs/defrag.c                                  |   50 +-
 fs/btrfs/disk-io.c                                 |   29 +-
 fs/btrfs/extent_io.c                               |  278 +++--
 fs/btrfs/fiemap.c                                  |    4 +-
 fs/btrfs/file.c                                    |  104 +-
 fs/btrfs/qgroup.c                                  |   18 +-
 fs/btrfs/relocation.c                              |   49 +-
 fs/btrfs/transaction.c                             |    8 +-
 fs/btrfs/transaction.h                             |   25 +-
 fs/btrfs/verity.c                                  |   16 +-
 fs/btrfs/volumes.c                                 |   37 +-
 fs/ceph/dir.c                                      |    2 +-
 fs/ceph/file.c                                     |   48 +
 fs/dax.c                                           |   12 +-
 fs/dcache.c                                        |    7 +-
 fs/erofs/Kconfig                                   |    8 +-
 fs/erofs/decompressor.c                            |    1 +
 fs/erofs/internal.h                                |    2 +-
 fs/erofs/zdata.c                                   |   12 +-
 fs/erofs/zmap.c                                    |   38 +-
 fs/exfat/exfat_fs.h                                |    2 +-
 fs/exfat/file.c                                    |  180 ++-
 fs/exfat/iomap.c                                   |   11 +-
 fs/ext4/dir.c                                      |   20 +-
 fs/ext4/ext4.h                                     |    6 +-
 fs/ext4/extents.c                                  |    2 +-
 fs/ext4/file.c                                     |    7 +
 fs/ext4/inline.c                                   |   25 +-
 fs/ext4/inode.c                                    |  131 +-
 fs/ext4/migrate.c                                  |    3 +-
 fs/ext4/namei.c                                    |    2 +
 fs/ext4/orphan.c                                   |   10 +-
 fs/ext4/xattr.c                                    |    2 +-
 fs/f2fs/f2fs.h                                     |   22 +-
 fs/f2fs/file.c                                     |   17 +-
 fs/f2fs/gc.c                                       |    2 +-
 fs/f2fs/segment.c                                  |    8 +-
 fs/f2fs/super.c                                    |    4 +-
 fs/fat/nfs.c                                       |    4 +-
 fs/fuse/cuse.c                                     |    8 +-
 fs/fuse/dev.c                                      |   14 +-
 fs/fuse/dev_uring.c                                |   29 +-
 fs/fuse/dir.c                                      |   23 +-
 fs/fuse/file.c                                     |    5 +-
 fs/fuse/fuse_i.h                                   |    2 +
 fs/fuse/inode.c                                    |    9 +-
 fs/fuse/readdir.c                                  |    2 +-
 fs/hfsplus/catalog.c                               |   25 +-
 fs/hfsplus/hfsplus_fs.h                            |    6 +
 fs/hugetlbfs/inode.c                               |    3 +-
 fs/inode.c                                         |   18 +-
 fs/iomap/bio.c                                     |    1 +
 fs/iomap/iter.c                                    |  130 +-
 fs/isofs/compress.c                                |    7 +-
 fs/lockd/nlm3xdr_gen.c                             |    2 +-
 fs/lockd/nlm3xdr_gen.h                             |    2 +-
 fs/lockd/nlm4xdr_gen.c                             |   47 +-
 fs/lockd/nlm4xdr_gen.h                             |    2 +-
 fs/nfs/blocklayout/dev.c                           |   21 +-
 fs/nfs/callback_xdr.c                              |    2 +-
 fs/nfs/client.c                                    |   14 +-
 fs/nfs/delegation.c                                |   20 +-
 fs/nfs/dir.c                                       |    7 +
 fs/nfs/filelayout/filelayoutdev.c                  |    3 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |    3 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |    3 +-
 fs/nfs/inode.c                                     |    4 +-
 fs/nfs/internal.h                                  |    1 +
 fs/nfs/nfs4client.c                                |    1 +
 fs/nfs/nfs4proc.c                                  |    4 +-
 fs/nfs/nfs4session.c                               |   16 +-
 fs/nfs/pnfs.c                                      |   35 +-
 fs/nfs/pnfs.h                                      |    3 +-
 fs/nfs/pnfs_nfs.c                                  |   14 +-
 fs/nfsd/nfs4state.c                                |    8 +-
 fs/nfsd/nfs4xdr_gen.c                              |  589 ++++++++-
 fs/nfsd/nfs4xdr_gen.h                              |    5 +-
 fs/nfsd/nfsd.h                                     |    9 +-
 fs/nfsd/trace.h                                    |    1 +
 fs/nilfs2/page.c                                   |   17 +-
 fs/nilfs2/segment.c                                |    4 +
 fs/nilfs2/the_nilfs.c                              |    6 +
 fs/notify/fanotify/fanotify.c                      |    1 +
 fs/notify/fanotify/fanotify_user.c                 |   12 +-
 fs/ntfs/attrib.c                                   |    7 +-
 fs/ntfs/compress.c                                 |   94 +-
 fs/ntfs/ea.c                                       |  120 +-
 fs/ntfs/ea.h                                       |    3 +-
 fs/ntfs/file.c                                     |   10 +-
 fs/ntfs/index.c                                    |   96 +-
 fs/ntfs/inode.c                                    |   79 +-
 fs/ntfs/inode.h                                    |    1 +
 fs/ntfs/iomap.c                                    |   62 +-
 fs/ntfs/mft.c                                      |   12 +-
 fs/ntfs/namei.c                                    |   10 +-
 fs/ntfs3/fslog.c                                   |   13 +-
 fs/ntfs3/fsntfs.c                                  |    8 +-
 fs/ntfs3/record.c                                  |   34 +-
 fs/ntfs3/super.c                                   |   13 +-
 fs/ntfs3/xattr.c                                   |   25 +-
 fs/ocfs2/acl.c                                     |  141 ++-
 fs/ocfs2/acl.h                                     |   19 +-
 fs/ocfs2/cluster/heartbeat.c                       |  142 ++-
 fs/ocfs2/cluster/heartbeat.h                       |    5 +
 fs/ocfs2/cluster/nodemanager.c                     |   23 +-
 fs/ocfs2/cluster/nodemanager.h                     |    2 +
 fs/ocfs2/cluster/tcp.c                             |  186 ++-
 fs/ocfs2/cluster/tcp.h                             |    2 +
 fs/ocfs2/inode.c                                   |   22 +-
 fs/ocfs2/namei.c                                   |   17 +-
 fs/ocfs2/xattr.c                                   |  301 ++++-
 fs/ocfs2/xattr.h                                   |   11 +-
 fs/resctrl/monitor.c                               |   60 +-
 fs/resctrl/rdtgroup.c                              |   71 +-
 fs/smb/client/cifs_debug.c                         |    2 +-
 fs/smb/client/dir.c                                |    2 +
 fs/smb/client/inode.c                              |   14 -
 fs/smb/client/smb2inode.c                          |    9 +-
 fs/smb/client/smb2pdu.c                            |   18 +-
 fs/smb/common/smb2pdu.h                            |    4 +-
 fs/smb/common/smbglob.h                            |    1 +
 fs/smb/server/Kconfig                              |    1 -
 fs/smb/server/auth.c                               |   20 +-
 fs/smb/server/compress.c                           |   76 +-
 fs/smb/server/compress.h                           |    1 +
 fs/smb/server/connection.c                         |   59 +-
 fs/smb/server/connection.h                         |    8 +-
 fs/smb/server/ksmbd_netlink.h                      |    6 +-
 fs/smb/server/ksmbd_work.c                         |    5 +
 fs/smb/server/ksmbd_work.h                         |   14 +
 fs/smb/server/mgmt/share_config.c                  |   64 +-
 fs/smb/server/mgmt/share_config.h                  |   25 +
 fs/smb/server/mgmt/tree_connect.c                  |   10 +
 fs/smb/server/mgmt/user_config.c                   |   12 +
 fs/smb/server/mgmt/user_session.c                  |   92 +-
 fs/smb/server/mgmt/user_session.h                  |    4 +
 fs/smb/server/misc.h                               |    4 +-
 fs/smb/server/oplock.c                             |  202 +++-
 fs/smb/server/oplock.h                             |    4 +-
 fs/smb/server/proc.c                               |   13 +-
 fs/smb/server/server.c                             |   61 +-
 fs/smb/server/server.h                             |    2 +
 fs/smb/server/smb2ops.c                            |   15 +-
 fs/smb/server/smb2pdu.c                            | 1265 +++++++++++++++++---
 fs/smb/server/smb2pdu.h                            |   60 +
 fs/smb/server/smbacl.c                             |  100 +-
 fs/smb/server/smbacl.h                             |    3 +-
 fs/smb/server/transport_ipc.c                      |   21 +
 fs/smb/server/transport_tcp.c                      |    6 +
 fs/smb/server/vfs.c                                |    3 -
 fs/smb/server/vfs_cache.c                          |   80 +-
 fs/smb/server/vfs_cache.h                          |   24 +
 fs/smb/smbdirect/accept.c                          |   16 +-
 fs/smb/smbdirect/connection.c                      |   13 +-
 fs/smb/smbdirect/socket.c                          |   98 +-
 fs/squashfs/cache.c                                |    2 +-
 fs/stat.c                                          |    2 +-
 fs/super.c                                         |    4 +-
 fs/udf/inode.c                                     |  129 +-
 fs/udf/super.c                                     |   23 +-
 fs/udf/symlink.c                                   |    2 +
 include/acpi/acpi_bus.h                            |    6 +
 include/asm-generic/vmlinux.lds.h                  |   10 +-
 include/clocksource/samsung_pwm.h                  |    2 +-
 include/cxl/mailbox.h                              |    2 +
 include/drm/bridge/dw_dp.h                         |    1 +
 include/linux/bio-integrity.h                      |    3 +
 include/linux/bpf.h                                |   36 +-
 include/linux/cpuset.h                             |    1 +
 include/linux/efi.h                                |    4 +-
 include/linux/filter.h                             |   55 +
 include/linux/fs.h                                 |   20 +-
 include/linux/fsl/ntmp.h                           |    2 +
 include/linux/i3c/master.h                         |    3 +
 include/linux/iomap.h                              |  111 +-
 include/linux/irqchip/arm-gic-v5.h                 |    2 +
 include/linux/leds.h                               |    2 +
 include/linux/libnvdimm.h                          |    9 +
 include/linux/liveupdate.h                         |   11 +-
 include/linux/maple_tree.h                         |    2 +-
 include/linux/memcontrol.h                         |    9 +-
 include/linux/memory_hotplug.h                     |    2 +-
 include/linux/mlx5/vport.h                         |    3 +-
 include/linux/nfs4.h                               |  127 --
 include/linux/nfs_xdr.h                            |    2 +-
 include/linux/pci.h                                |    1 +
 include/linux/remoteproc.h                         |   15 +-
 include/linux/rsc_table.h                          |   17 +-
 include/linux/rtsx_usb.h                           |    3 +
 include/linux/soc/qcom/ubwc.h                      |    1 +
 include/linux/sunrpc/xdrgen/_defs.h                |    2 +
 include/linux/sunrpc/xdrgen/nfs4_1.h               |  279 ++++-
 include/linux/sunrpc/xdrgen/nlm3.h                 |    2 +-
 include/linux/sunrpc/xdrgen/nlm4.h                 |    2 +-
 include/linux/uprobes.h                            |    5 -
 include/linux/usb.h                                |    3 +-
 include/linux/usb/pd.h                             |    2 +-
 include/linux/virtio.h                             |    1 +
 include/linux/virtio_net.h                         |    4 +
 include/media/rc-map.h                             |    2 -
 include/net/bluetooth/hci_core.h                   |    2 +-
 include/net/bluetooth/l2cap.h                      |    5 +
 include/net/inetpeer.h                             |    4 +
 include/net/libeth/xsk.h                           |    2 +-
 include/net/netfilter/nf_conntrack_helper.h        |    1 +
 include/net/netfilter/nf_tables.h                  |    2 -
 include/net/pkt_sched.h                            |    1 +
 include/net/xdp_sock_drv.h                         |   22 +-
 include/net/xsk_buff_pool.h                        |    3 +-
 include/rdma/uverbs_ioctl.h                        |   20 +
 include/sound/sdca_fdl.h                           |    4 +
 include/uapi/drm/panthor_drm.h                     |   12 +
 include/uapi/drm/xe_drm.h                          |   11 +-
 include/uapi/linux/if_xdp.h                        |    1 +
 include/uapi/linux/nfs4.h                          |    2 -
 include/uapi/linux/time_types.h                    |    2 +-
 kernel/Kconfig.preempt                             |    1 +
 kernel/bpf/arena.c                                 |   10 +-
 kernel/bpf/bpf_lsm.c                               |    1 -
 kernel/bpf/bpf_struct_ops.c                        |   12 +
 kernel/bpf/btf.c                                   |   47 +-
 kernel/bpf/cgroup.c                                |   27 +-
 kernel/bpf/const_fold.c                            |   11 +-
 kernel/bpf/core.c                                  |    7 +-
 kernel/bpf/cpumask.c                               |    6 +-
 kernel/bpf/fixups.c                                |   25 +-
 kernel/bpf/helpers.c                               |   17 +-
 kernel/bpf/liveness.c                              |    9 +-
 kernel/bpf/mmap_unlock_work.h                      |   51 +-
 kernel/bpf/net_namespace.c                         |   17 +-
 kernel/bpf/queue_stack_maps.c                      |    8 +-
 kernel/bpf/ringbuf.c                               |    2 +-
 kernel/bpf/stackmap.c                              |  148 ++-
 kernel/bpf/states.c                                |    3 +-
 kernel/bpf/syscall.c                               |   23 +-
 kernel/bpf/task_iter.c                             |   48 +-
 kernel/bpf/trampoline.c                            |   20 +-
 kernel/bpf/verifier.c                              |  160 ++-
 kernel/cgroup/cpuset-internal.h                    |    2 +-
 kernel/cgroup/cpuset.c                             |   79 +-
 kernel/crash_dump_dm_crypt.c                       |   15 +-
 kernel/dma/swiotlb.c                               |   31 +-
 kernel/events/uprobes.c                            |   10 -
 kernel/fork.c                                      |    1 -
 kernel/kcsan/core.c                                |   12 +-
 kernel/liveupdate/luo_flb.c                        |   20 +-
 kernel/liveupdate/luo_session.c                    |    6 +-
 kernel/locking/lockdep.c                           |    2 +
 kernel/module/dups.c                               |   99 +-
 kernel/module/stats.c                              |    2 +-
 kernel/power/snapshot.c                            |    5 +-
 kernel/power/wakelock.c                            |    2 +-
 kernel/printk/printk.c                             |   11 +-
 kernel/rcu/tree_plugin.h                           |   10 +-
 kernel/sched/cpufreq_schedutil.c                   |    2 +-
 kernel/sched/deadline.c                            |    6 +-
 kernel/sched/ext/ext.c                             |   59 +-
 kernel/sched/ext/internal.h                        |    2 -
 kernel/sched/fair.c                                |   34 +-
 kernel/sched/isolation.c                           |   16 +-
 kernel/sched/rt.c                                  |    3 +-
 kernel/sys.c                                       |    2 +-
 kernel/time/clocksource.c                          |    8 +-
 kernel/time/hrtimer.c                              |    4 +-
 kernel/time/namespace.c                            |    6 +-
 kernel/time/timekeeping.c                          |   27 +-
 kernel/time/timer_migration.c                      |    4 +-
 kernel/trace/ring_buffer.c                         |    2 -
 kernel/trace/trace.c                               |    2 +-
 kernel/trace/trace.h                               |    4 +-
 kernel/trace/trace_btf.c                           |   19 +-
 kernel/trace/trace_btf.h                           |    3 +-
 kernel/trace/trace_events.c                        |    6 +-
 kernel/trace/trace_probe.c                         |   18 +-
 kernel/workqueue.c                                 |   38 +-
 lib/interval_tree_test.c                           |    4 +-
 lib/maple_tree.c                                   |   43 +-
 lib/string.c                                       |    3 +-
 lib/test_bitmap.c                                  |    1 +
 lib/test_hmm.c                                     |    2 +-
 mm/damon/core.c                                    |   21 +-
 mm/damon/tests/core-kunit.h                        |    2 +-
 mm/memory_hotplug.c                                |    3 +-
 mm/mm_init.c                                       |   19 +-
 mm/mremap.c                                        |   21 +-
 mm/swap.c                                          |    9 +
 mm/vmscan.c                                        |    5 +
 net/batman-adv/bridge_loop_avoidance.c             |   65 +-
 net/batman-adv/distributed-arp-table.c             |   58 +-
 net/batman-adv/types.h                             |    2 +-
 net/bluetooth/hci_conn.c                           |   20 +-
 net/bluetooth/hci_sync.c                           |   26 +-
 net/bluetooth/l2cap_core.c                         |   23 +-
 net/bluetooth/l2cap_sock.c                         |  100 +-
 net/bluetooth/mgmt.c                               |   40 +-
 net/bluetooth/msft.c                               |    5 +
 net/bluetooth/rfcomm/core.c                        |    4 +
 net/bridge/br_arp_nd_proxy.c                       |   24 +-
 net/bridge/br_netlink_tunnel.c                     |    3 +-
 net/bridge/br_vlan.c                               |    4 +-
 net/ceph/messenger_v2.c                            |    5 +
 net/core/dev.c                                     |   60 +-
 net/core/filter.c                                  |    4 -
 net/core/lwt_bpf.c                                 |   15 +-
 net/core/net_namespace.c                           |   25 +-
 net/core/page_pool.c                               |   71 +-
 net/core/skbuff.c                                  |    6 +-
 net/hsr/hsr_device.c                               |    2 +
 net/ife/ife.c                                      |   14 +-
 net/ipv4/inetpeer.c                                |   38 +-
 net/ipv4/tcp.c                                     |    6 +-
 net/ipv4/tcp_output.c                              |    2 +-
 net/ipv6/ip6mr.c                                   |    3 +-
 net/ipv6/route.c                                   |    2 +-
 net/ipv6/xfrm6_input.c                             |    2 +-
 net/kcm/kcmsock.c                                  |    3 +
 net/mac80211/link.c                                |    3 +-
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/s1g.c                                 |    2 +-
 net/mac80211/spectmgmt.c                           |   11 +-
 net/mac80211/tx.c                                  |    3 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  174 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c         |    1 -
 net/netfilter/ipset/ip_set_hash_netportnet.c       |    1 -
 net/netfilter/ipvs/ip_vs_ftp.c                     |   10 +-
 net/netfilter/nf_conntrack_helper.c                |   14 +-
 net/netfilter/nf_conntrack_netlink.c               |    2 +-
 net/netfilter/nf_nat_sip.c                         |    5 +
 net/netfilter/nf_tables_api.c                      |   70 +-
 net/netfilter/nft_ct.c                             |  168 ++-
 net/netfilter/nft_dynset.c                         |   25 +-
 net/netfilter/xt_cgroup.c                          |   12 +-
 net/netfilter/xt_hl.c                              |    4 +-
 net/nfc/digital_core.c                             |    2 +-
 net/nfc/llcp_core.c                                |   29 +-
 net/nfc/llcp_sock.c                                |   14 +-
 net/nfc/nci/data.c                                 |   10 +-
 net/nfc/nci/rsp.c                                  |   41 +-
 net/phonet/pep.c                                   |    2 +-
 net/rds/cong.c                                     |    4 +-
 net/sched/act_api.c                                |    5 +-
 net/sched/act_bpf.c                                |   26 +
 net/sched/act_ct.c                                 |   46 +
 net/sched/act_ctinfo.c                             |   11 +
 net/sched/act_ife.c                                |   55 +-
 net/sched/act_pedit.c                              |   24 +
 net/sched/act_police.c                             |   12 +
 net/sched/act_sample.c                             |    9 +
 net/sched/act_skbmod.c                             |   12 +-
 net/sched/act_tunnel_key.c                         |   80 ++
 net/sched/cls_api.c                                |   21 +-
 net/sched/cls_basic.c                              |    6 +-
 net/sched/cls_bpf.c                                |    6 +-
 net/sched/cls_cgroup.c                             |    2 +-
 net/sched/cls_flow.c                               |    2 +-
 net/sched/cls_flower.c                             |    4 +-
 net/sched/cls_fw.c                                 |    4 +-
 net/sched/cls_matchall.c                           |    4 +-
 net/sched/cls_route.c                              |    4 +-
 net/sched/cls_u32.c                                |   11 +-
 net/sched/sch_api.c                                |    7 +-
 net/sched/sch_cake.c                               |    1 +
 net/sched/sch_codel.c                              |    2 +-
 net/sched/sch_fifo.c                               |    2 +-
 net/sched/sch_fq.c                                 |   26 +-
 net/sched/sch_fq_codel.c                           |    6 +-
 net/sched/sch_fq_pie.c                             |    3 +-
 net/sched/sch_gred.c                               |    4 +-
 net/sched/sch_hhf.c                                |    4 +
 net/sched/sch_htb.c                                |    7 +-
 net/sched/sch_plug.c                               |    2 +-
 net/sched/sch_sfq.c                                |    3 +-
 net/sched/sch_teql.c                               |    1 +
 net/smc/af_smc.c                                   |    2 +-
 net/smc/smc_inet.c                                 |   16 +
 net/smc/smc_llc.c                                  |    3 +
 net/sunrpc/rpcb_clnt.c                             |    4 +
 net/sunrpc/xprtsock.c                              |   20 +-
 net/tls/tls_strp.c                                 |   16 +-
 net/vmw_vsock/af_vsock.c                           |   16 +-
 net/wireless/core.c                                |    3 +
 net/wireless/nl80211.c                             |   10 +-
 net/xdp/xsk.c                                      |   30 +-
 net/xdp/xsk_buff_pool.c                            |    7 +-
 net/xfrm/xfrm_output.c                             |    4 +-
 rust/helpers/helpers.c                             |    2 +
 rust/kernel/cpufreq.rs                             |   24 +-
 rust/kernel/device.rs                              |   10 +-
 rust/kernel/drm/gpuvm/mod.rs                       |   32 +-
 rust/uapi/uapi_helper.h                            |    2 +-
 samples/ftrace/ftrace-direct-modify.c              |   12 +-
 samples/ftrace/ftrace-direct-multi-modify.c        |   12 +-
 samples/rust/rust_debugfs.rs                       |    4 +-
 samples/rust/rust_debugfs_scoped.rs                |    5 +-
 scripts/Makefile.vmlinux_o                         |    3 +
 scripts/livepatch/klp-build                        |    9 +
 scripts/mod/modpost.c                              |    7 +-
 scripts/tags.sh                                    |    2 +-
 security/apparmor/domain.c                         |  106 +-
 security/apparmor/include/policy.h                 |    3 +
 security/apparmor/lib.c                            |    4 +-
 security/apparmor/policy.c                         |   22 +-
 security/apparmor/policy_unpack.c                  |    2 +-
 security/smack/smack.h                             |    5 +-
 security/smack/smack_lsm.c                         |   67 +-
 security/smack/smackfs.c                           |  222 +---
 sound/core/control_led.c                           |    2 +
 sound/core/init.c                                  |    4 +-
 sound/core/seq/seq_clientmgr.c                     |   16 +-
 sound/core/seq/seq_midi.c                          |   61 +-
 sound/drivers/mtpav.c                              |    4 +-
 sound/hda/codecs/realtek/alc269.c                  |   13 +-
 sound/hda/common/proc.c                            |    2 +-
 sound/hda/controllers/Kconfig                      |    1 +
 sound/pci/asihpi/hpi6000.c                         |    5 +
 sound/pci/ice1712/ice1712.c                        |    7 +-
 sound/pci/via82xx_modem.c                          |   26 +-
 sound/soc/amd/acp-config.c                         |    2 +-
 sound/soc/apple/mca.c                              |    6 +-
 sound/soc/codecs/rt700-sdw.c                       |    6 +-
 sound/soc/codecs/tas2783-sdw.c                     |   26 +-
 sound/soc/codecs/tas675x.c                         |   18 +-
 sound/soc/fsl/Kconfig                              |    4 +-
 sound/soc/fsl/efika-audio-fabric.c                 |    2 -
 sound/soc/fsl/fsl-asoc-card.c                      |    4 +-
 sound/soc/fsl/fsl_audmix.c                         |   24 +-
 sound/soc/fsl/pcm030-audio-fabric.c                |    2 -
 sound/soc/meson/meson-card-utils.c                 |   17 +-
 sound/soc/pxa/pxa-ssp.c                            |    7 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   12 +-
 sound/soc/samsung/i2s.c                            |   25 +-
 sound/soc/soc-dapm.c                               |    2 +-
 sound/soc/sof/ipc4-topology.c                      |    2 +
 sound/soc/sof/topology.c                           |   18 +-
 sound/soc/spacemit/k1_i2s.c                        |   36 +-
 sound/soc/ti/j721e-evm.c                           |    4 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |   14 +-
 tools/bpf/bpftool/Makefile                         |    2 +-
 tools/bpf/bpftool/map.c                            |   16 +-
 tools/bpf/bpftool/sign.c                           |    7 +-
 tools/bpf/bpftool/struct_ops.c                     |    4 +
 tools/build/Makefile.feature                       |    2 -
 tools/build/feature/Makefile                       |   14 -
 tools/include/linux/filter.h                       |    1 +
 tools/include/nolibc/arch-powerpc.h                |    2 +-
 tools/include/nolibc/arch-sparc.h                  |    2 +-
 tools/include/uapi/linux/if_xdp.h                  |    1 +
 tools/lib/api/fd/array.c                           |   12 +-
 tools/lib/bpf/features.c                           |    4 +-
 tools/lib/bpf/libbpf.c                             |    3 +-
 tools/lib/bpf/usdt.c                               |   16 +-
 .../xdrgen/templates/C/enum/declaration/enum.j2    |    1 +
 .../xdrgen/templates/C/pointer/encoder/string.j2   |    2 +
 .../C/pointer/encoder/variable_length_opaque.j2    |    2 +
 .../xdrgen/templates/C/struct/encoder/string.j2    |    2 +
 .../C/struct/encoder/variable_length_opaque.j2     |    2 +
 .../xdrgen/templates/C/union/definition/close.j2   |    6 -
 tools/objtool/Build                                |    4 +-
 tools/objtool/arch/x86/special.c                   |   27 +
 tools/objtool/builtin-check.c                      |    7 +
 tools/objtool/check.c                              |    7 +
 tools/objtool/elf.c                                |   13 +
 tools/objtool/include/objtool/builtin.h            |    1 +
 tools/objtool/include/objtool/elf.h                |    1 +
 tools/objtool/include/objtool/klp.h                |   33 +-
 tools/objtool/include/objtool/special.h            |    7 +
 tools/objtool/klp-diff.c                           |  233 ++--
 tools/objtool/klp-post-link.c                      |   53 +-
 tools/objtool/klp-symid.c                          |  119 ++
 tools/objtool/klp-sympos.c                         |  411 +++++++
 tools/perf/arch/arm/util/cs-etm.c                  |   10 +-
 tools/perf/arch/arm64/util/arm-spe.c               |    8 +-
 tools/perf/arch/arm64/util/hisi-ptt.c              |    2 +-
 tools/perf/arch/x86/tests/amd-ibs-period.c         |   20 +-
 tools/perf/arch/x86/tests/hybrid.c                 |   22 +-
 tools/perf/arch/x86/tests/topdown.c                |    4 +-
 tools/perf/arch/x86/util/auxtrace.c                |    2 +-
 tools/perf/arch/x86/util/intel-bts.c               |    6 +-
 tools/perf/arch/x86/util/intel-pt.c                |    9 +-
 tools/perf/arch/x86/util/iostat.c                  |   14 +-
 tools/perf/bench/evlist-open-close.c               |   29 +-
 tools/perf/builtin-annotate.c                      |    7 +-
 tools/perf/builtin-c2c.c                           |  106 +-
 tools/perf/builtin-ftrace.c                        |   27 +-
 tools/perf/builtin-inject.c                        |    4 +-
 tools/perf/builtin-kvm.c                           |   14 +-
 tools/perf/builtin-kwork.c                         |    8 +-
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-record.c                        |  148 ++-
 tools/perf/builtin-report.c                        |    6 +-
 tools/perf/builtin-sched.c                         |  132 +-
 tools/perf/builtin-script.c                        |   16 +-
 tools/perf/builtin-stat.c                          |  112 +-
 tools/perf/builtin-top.c                           |  106 +-
 tools/perf/builtin-trace.c                         |  129 +-
 .../pmu-events/arch/arm64/nvidia/t410/metrics.json |   28 +-
 .../pmu-events/arch/arm64/nvidia/t410/misc.json    |    6 +-
 .../arch/x86/amdzen5/floating-point.json           |  160 ++-
 .../pmu-events/arch/x86/amdzen5/load-store.json    |    8 +-
 .../arch/x86/amdzen6/floating-point.json           |   34 +-
 tools/perf/pmu-events/jevents.py                   |    5 +-
 tools/perf/pmu-events/metric.py                    |    6 +-
 tools/perf/scripts/python/arm-cs-trace-disasm.py   |    9 +-
 tools/perf/tests/backward-ring-buffer.c            |   26 +-
 tools/perf/tests/builtin-test.c                    |  180 +--
 tools/perf/tests/code-reading.c                    |   14 +-
 tools/perf/tests/event-times.c                     |    6 +-
 tools/perf/tests/event_update.c                    |    4 +-
 tools/perf/tests/evsel-roundtrip-name.c            |    8 +-
 tools/perf/tests/evsel-tp-sched.c                  |    4 +-
 tools/perf/tests/expand-cgroup.c                   |   15 +-
 tools/perf/tests/hists_cumulate.c                  |    2 +-
 tools/perf/tests/hists_filter.c                    |    2 +-
 tools/perf/tests/hists_link.c                      |    2 +-
 tools/perf/tests/hists_output.c                    |    2 +-
 tools/perf/tests/hwmon_pmu.c                       |    7 +-
 tools/perf/tests/keep-tracking.c                   |   10 +-
 tools/perf/tests/mmap-basic.c                      |   24 +-
 tools/perf/tests/openat-syscall-all-cpus.c         |    6 +-
 tools/perf/tests/openat-syscall-tp-fields.c        |   26 +-
 tools/perf/tests/openat-syscall.c                  |    6 +-
 tools/perf/tests/parse-events.c                    |  150 +--
 tools/perf/tests/parse-metric.c                    |   11 +-
 tools/perf/tests/parse-no-sample-id-all.c          |    2 +-
 tools/perf/tests/perf-record.c                     |   38 +-
 tools/perf/tests/perf-time-to-tsc.c                |   12 +-
 tools/perf/tests/pfm.c                             |   12 +-
 tools/perf/tests/pmu-events.c                      |   21 +-
 tools/perf/tests/pmu.c                             |    4 +-
 tools/perf/tests/sample-parsing.c                  |   45 +-
 .../shell/coresight/test_arm_coresight_disasm.sh   |    4 +-
 tools/perf/tests/shell/inject_aslr.sh              |   10 +-
 tools/perf/tests/shell/jitdump-python.sh           |   69 +-
 tools/perf/tests/shell/kvm.sh                      |   61 +-
 .../perf/tests/shell/lib/perf_metric_validation.py |   11 +-
 tools/perf/tests/shell/lib/perf_record.sh          |   58 +
 tools/perf/tests/shell/pipe_test.sh                |    4 +-
 .../shell/record+zstd_comp_decomp_multi_record.sh  |   63 +
 tools/perf/tests/shell/record.sh                   |  173 +--
 tools/perf/tests/shell/record_lbr.sh               |   50 +-
 tools/perf/tests/shell/stat_all_metrics.sh         |   75 +-
 tools/perf/tests/shell/stat_bpf_counters.sh        |   28 +-
 tools/perf/tests/shell/stat_metrics_values.sh      |    7 +
 tools/perf/tests/shell/test_brstack.sh             |   99 +-
 .../tests/shell/test_dwarf_unwind_multithreaded.sh |   65 +
 tools/perf/tests/shell/trace_record_replay.sh      |   38 +-
 tools/perf/tests/sw-clock.c                        |   20 +-
 tools/perf/tests/switch-tracking.c                 |   11 +-
 tools/perf/tests/task-exit.c                       |   20 +-
 tools/perf/tests/time-utils-test.c                 |   14 +-
 tools/perf/tests/tool_pmu.c                        |    7 +-
 tools/perf/tests/topology.c                        |    4 +-
 tools/perf/tests/uncore-event-sorting.c            |    6 +-
 tools/perf/ui/browsers/annotate.c                  |    4 +-
 tools/perf/ui/browsers/hists.c                     |  163 ++-
 tools/perf/util/amd-sample-raw.c                   |    2 +-
 tools/perf/util/annotate-data.c                    |    2 +-
 tools/perf/util/annotate.c                         |   61 +-
 tools/perf/util/annotate.h                         |    3 +-
 tools/perf/util/arm-spe.c                          |    4 +
 tools/perf/util/auxtrace.c                         |   29 +-
 tools/perf/util/block-info.c                       |    4 +-
 tools/perf/util/bpf-event.c                        |    3 +-
 tools/perf/util/bpf-filter.c                       |   22 +-
 tools/perf/util/bpf_counter.c                      |    2 +-
 tools/perf/util/bpf_counter_cgroup.c               |   14 +-
 tools/perf/util/bpf_ftrace.c                       |    9 +-
 tools/perf/util/bpf_lock_contention.c              |   12 +-
 tools/perf/util/bpf_off_cpu.c                      |   44 +-
 tools/perf/util/bpf_trace_augment.c                |    8 +-
 tools/perf/util/cap.c                              |    4 +-
 tools/perf/util/cap.h                              |    3 +-
 tools/perf/util/capstone.c                         |   62 +-
 tools/perf/util/cgroup.c                           |   26 +-
 tools/perf/util/compress.h                         |    6 +-
 tools/perf/util/cs-etm.c                           |  105 +-
 tools/perf/util/data-convert-bt.c                  |    2 +-
 tools/perf/util/data-convert-json.c                |    1 +
 tools/perf/util/dso.c                              |   48 +-
 tools/perf/util/dso.h                              |   57 +-
 tools/perf/util/evlist.c                           |  494 ++++----
 tools/perf/util/evlist.h                           |  258 +++-
 tools/perf/util/evsel.c                            |  135 ++-
 tools/perf/util/evsel.h                            |   21 +-
 tools/perf/util/expr.c                             |    2 +-
 tools/perf/util/header.c                           |   74 +-
 tools/perf/util/header.h                           |    2 +-
 tools/perf/util/intel-bts.c                        |    2 +-
 tools/perf/util/intel-pt.c                         |    2 +-
 tools/perf/util/intel-tpebs.c                      |    7 +-
 tools/perf/util/iostat.c                           |    2 +-
 tools/perf/util/iostat.h                           |    2 +-
 tools/perf/util/kvm-stat.h                         |    2 +-
 tools/perf/util/libbfd.c                           |   23 +-
 tools/perf/util/libdw.c                            |   32 +-
 tools/perf/util/machine.c                          |   43 +-
 tools/perf/util/map.h                              |    9 +-
 tools/perf/util/metricgroup.c                      |   45 +-
 tools/perf/util/metricgroup.h                      |    4 +-
 tools/perf/util/parse-events.c                     |   40 +-
 tools/perf/util/parse-events.h                     |   17 +-
 tools/perf/util/parse-events.y                     |    2 +-
 tools/perf/util/perf_api_probe.c                   |   20 +-
 tools/perf/util/pfm.c                              |    4 +-
 tools/perf/util/pmu.c                              |    6 +-
 tools/perf/util/pmus.c                             |    2 +
 tools/perf/util/print-events.c                     |    2 +-
 tools/perf/util/python.c                           |  761 ++++++++----
 tools/perf/util/record.c                           |   11 +-
 tools/perf/util/s390-sample-raw.c                  |   21 +-
 tools/perf/util/sample-raw.c                       |    4 +-
 tools/perf/util/session.c                          |   48 +-
 tools/perf/util/sideband_evlist.c                  |   54 +-
 tools/perf/util/sort.c                             |   78 +-
 tools/perf/util/stat-display.c                     |    6 +-
 tools/perf/util/stat-shadow.c                      |   24 +-
 tools/perf/util/stat.c                             |   22 +-
 tools/perf/util/stream.c                           |    4 +-
 tools/perf/util/symbol.c                           |    3 +-
 tools/perf/util/synthetic-events.c                 |   17 +-
 tools/perf/util/thread-stack.c                     |    2 +-
 tools/perf/util/time-utils.c                       |   12 +-
 tools/perf/util/top.c                              |    4 +-
 tools/perf/util/trace-event-read.c                 |   33 +-
 tools/perf/util/unwind-libdw.c                     |   24 +-
 tools/perf/util/util.c                             |   12 +-
 tools/perf/util/zstd.c                             |   25 +-
 tools/sched_ext/include/scx/compat.bpf.h           |    2 +-
 tools/sched_ext/scx_flatcg.bpf.c                   |   19 +-
 tools/sched_ext/scx_flatcg.c                       |    4 +-
 tools/sched_ext/scx_qmap.bpf.c                     |    2 +-
 tools/scripts/Makefile.include                     |   37 +-
 tools/testing/cxl/test/cxl.c                       |  541 +++++++--
 tools/testing/cxl/test/hmem_test.c                 |    3 +-
 tools/testing/cxl/test/mock.h                      |    2 +
 tools/testing/kunit/kunit.py                       |    2 +-
 tools/testing/kunit/kunit_tool_test.py             |   12 +
 tools/testing/selftests/arm64/fp/fp-ptrace.c       |   47 +-
 tools/testing/selftests/arm64/fp/sve-test.S        |    7 +-
 .../selftests/arm64/mte/check_buffer_fill.c        |    2 +
 .../selftests/arm64/mte/check_child_memory.c       |    2 +
 .../selftests/arm64/mte/check_gcr_el1_cswitch.c    |    1 +
 .../selftests/arm64/mte/check_hugetlb_options.c    |    2 +
 .../selftests/arm64/mte/check_ksm_options.c        |   31 +-
 .../selftests/arm64/mte/check_mmap_options.c       |    2 +
 tools/testing/selftests/arm64/mte/check_prctl.c    |    2 +-
 .../selftests/arm64/mte/check_tags_inclusion.c     |    2 +
 tools/testing/selftests/arm64/mte/check_user_mem.c |    2 +
 tools/testing/selftests/bpf/Makefile               |    9 +-
 tools/testing/selftests/bpf/README.rst             |    4 +-
 .../bpf/libarena/include/libarena/userspace.h      |    2 +-
 .../selftests/bpf/libarena/src/common.bpf.c        |    6 +
 tools/testing/selftests/bpf/network_helpers.c      |    4 +-
 tools/testing/selftests/bpf/network_helpers.h      |    5 +
 .../selftests/bpf/prog_tests/cgroup_iter_memcg.c   |   43 +
 .../selftests/bpf/prog_tests/global_map_resize.c   |    8 +-
 tools/testing/selftests/bpf/prog_tests/libarena.c  |    8 +-
 .../selftests/bpf/prog_tests/libarena_asan.c       |    8 +-
 tools/testing/selftests/bpf/prog_tests/lsm_bdev.c  |    3 +-
 .../selftests/bpf/prog_tests/lwt_ip_encap.c        |   11 +-
 tools/testing/selftests/bpf/prog_tests/mptcp.c     |   13 +-
 tools/testing/selftests/bpf/prog_tests/sha256.c    |    4 +-
 .../selftests/bpf/prog_tests/uprobe_syscall.c      |    2 +-
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    3 +
 tools/testing/selftests/bpf/progs/mptcpify.c       |    2 +-
 tools/testing/selftests/bpf/test_loader.c          |    2 +-
 tools/testing/selftests/bpf/test_progs.c           |   22 +-
 tools/testing/selftests/bpf/test_sockmap.c         |    3 +-
 tools/testing/selftests/bpf/veristat.c             |   76 +-
 tools/testing/selftests/bpf/vmtest.sh              |   13 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |   18 +-
 .../testing/selftests/cgroup/test_cpuset_v1_hp.sh  |    2 +-
 tools/testing/selftests/drivers/net/config         |    5 +
 tools/testing/selftests/drivers/net/lib/py/env.py  |   11 +-
 .../testing/selftests/drivers/net/ring_reconfig.py |  255 +++-
 tools/testing/selftests/drivers/net/so_txtime.py   |   21 +-
 tools/testing/selftests/kselftest_harness.h        |    2 +-
 tools/testing/selftests/lsm/common.c               |    4 +-
 tools/testing/selftests/mm/cow.c                   |    9 +-
 tools/testing/selftests/mm/hmm-tests.c             |   21 +-
 tools/testing/selftests/mm/hugepage_settings.c     |    2 +-
 tools/testing/selftests/mm/khugepaged.c            |    4 +-
 tools/testing/selftests/mm/ksm_tests.c             |   28 +-
 tools/testing/selftests/mm/memory-failure.c        |   44 +-
 tools/testing/selftests/mm/thuge-gen.c             |   15 +-
 tools/testing/selftests/mm/vm_util.c               |   28 +-
 tools/testing/selftests/mm/vm_util.h               |    1 +
 tools/testing/selftests/namespaces/nsid_test.c     |    4 -
 tools/testing/selftests/proc/proc-maps-race.c      |    3 +-
 tools/testing/selftests/proc/proc-pidns.c          |    1 +
 .../selftests/rseq/rseq-x86-thread-pointer.h       |    4 +-
 .../selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c  |   20 +-
 .../selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c |   13 +-
 tools/testing/selftests/sched_ext/exit.c           |    1 +
 tools/testing/selftests/sched_ext/prog_run.c       |   36 +-
 tools/testing/selftests/timers/leap-a-day.c        |   19 +-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c |   26 +-
 tools/testing/selftests/zram/zram_lib.sh           |    2 +-
 1767 files changed, 31794 insertions(+), 14006 deletions(-)


