Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F4C36728D;
	Sat, 12 Sep 2026 09:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205690; cv=none; b=f8v9oMbx2miVn66XV425MVOwgw+3hL/MzXza83xRYyKT9muW87mw94WkTuG6tajK2Uv3dy906P6dNO8gm8syJoODVhUF5ehu80O6xMk9Mv8Ik+FRBBustv9fPC4Cw32zAanwzfTytShkrf/KBiH2NWGScxYPbWAGH+AC2M1WFTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205690; c=relaxed/simple;
	bh=sjbWjLMyYdsqUh5EdRBjjZjljsuVLSAY1Ars2DghiSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eZ67LzouDGB4VLBMafj3WQXnTq1C++4ds/pYXLnscyCx1qUSZ3SY79j81XsEEK6yOBxlymR6qw/p8c0lO8zAQ0/tQ3l5LidgkWuqNvCElbAp2oz9rYuKffm4lVVGHknqlRHxMKEkBINUFaHJsmQg2Mgtxfv/U3BIdA9dUGtDUXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDFTJ3sM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDFTJ3sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455E11F000FF;
	Sat, 12 Sep 2026 09:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205680;
	bh=xLpJ28tjFkyON9B3pfl7SW/DkGmRXMWDNJ7qxjiWLE4=;
	h=From:To:Cc:Subject:Date;
	b=hDFTJ3sMiGqa39qV6jSZ4zsVom4v6wSdYSoZ/dziW8IOeOsgFEg6YWUawrgUfACWq
	 tsqkUT8rbWUIzyMttcvoP/2weaaigN6PAkKOZBaJOZ7npXVh0+a+FUj41RqkcnKKjj
	 mm1aTd3gk8z1mFLZoxlY5aumPAukp2pyV97M/3Wg=
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
Subject: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
Date: Sat, 12 Sep 2026 08:36:09 +0200
Message-ID: <20260912065623.398859879@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.52-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.52-rc1
X-KernelTest-Deadline: 2026-09-14T06:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.52 release.
There are 1518 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.52-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.52-rc1

Arnd Bergmann <arnd@arndb.de>
    wifi: mt76: fix airoha_npu dependency tracking

Salman Alghamdi <me@cipherat.com>
    staging: rtl8723bs: rtw_mlme: add bounds checks before ie_length subtraction

Shyam Sunder Reddy Padira <shyamsunderreddypadira@gmail.com>
    staging: rtl8723bs: os_dep: avoid NULL pointer dereference in rtw_cbuf_alloc

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: add missed gpio22 pin group

Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
    ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Remove redundant static variable and rename cstate check function

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Move max_cstate update out of the loop

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Remove redundant cstate check in acpi_processor_power_init

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate: Allow writes to dynamic_epp when state isn't modified

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate: Use "epp_default_dc" as default when dynamic_epp is disabled

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Add support for raw EPP writes

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Add static asserts for EPP indices

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Fix some whitespace issues

Jens Axboe <axboe@kernel.dk>
    io_uring/waitid: fix KCSAN warning on io_waitid->head

Jens Axboe <axboe@kernel.dk>
    io_uring/waitid: use io_waitid_remove_wq() consistently

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq: clamp quantum and initial_quantum in change path

Arnd Bergmann <arnd@arndb.de>
    Bluetooth: btmtk: hide unused btmtk_mt6639_devs[] array

Pavel Begunkov <asml.silence@gmail.com>
    tcp: reject non zerocopy devmem tx

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Add __rcu to netns_ipv4.mrt.

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Call ipmr_fib_lookup() under RCU.

Zhan Xusheng <zhanxusheng@xiaomi.com>
    erofs: fix EFSCORRUPTED on multi-algorithm images in z_erofs_map_sanity_check()

Gao Xiang <xiang@kernel.org>
    erofs: relax sanity check for tail pclusters due to ztailpacking

Keith Busch <kbusch@kernel.org>
    block: fix merging data-less bios

Keith Busch <kbusch@kernel.org>
    blk-mq-dma: always initialize dma state

Keith Busch <kbusch@kernel.org>
    block: save page offset gaps in cloned bio

Nathan Chancellor <nathan@kernel.org>
    integrity: Eliminate weak definition of arch_get_secureboot()

John Johansen <john.johansen@canonical.com>
    apparmor: fix kernel-doc comments for inview

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7581: fix incorrect led mapping in phy4_led1 pin function

Nathan Chancellor <nathan@kernel.org>
    pinctrl: airoha: Fix AIROHA_PINCTRL_CONFS_DRIVE_E2 in an7583_pinctrl_match_data

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: add missed gpio32 pin group

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix misprint in gpio19 pinconf

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix incorrect led mapping in phy4_led1 pin function

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix gpio21 pin group

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix phy1_led1 pin function

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: remove undefined groups from pcm_spi pin function

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix error handling in sd_probe() after large pool creation failure

Arnd Bergmann <arnd@arndb.de>
    phy: renesas: rcar-gen3-usb2: add regulator dependency

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Fix build with NO_SLANG=1

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: fix UHR capability validation

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: npu: Add missing rx_token_size initialization

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: restrict NPU/PPE active checks to MMIO devices

Heiko Carstens <hca@linux.ibm.com>
    s390/entry: Use lay instead of aghik

Vasily Gorbik <gor@linux.ibm.com>
    s390/kexec: Disable stack protector in s390_reset_system()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: vDSO: getrandom: Fix path to s390 chacha implementation

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Fix setting EPP in performance mode

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq/amd-pstate: Add POWER_SUPPLY select for dynamic EPP

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate: Grab "amd_pstate_driver_lock" when toggling dynamic_epp

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate: Return -ENOMEM on failure to allocate profile_name

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate: Reorder notifier unregistration and floor perf reset

EDAMAMEX <edame8080@gmail.com>
    cpufreq/amd-pstate: handle missing policy in dynamic EPP callbacks

Arnd Bergmann <arnd@arndb.de>
    usb: ucsi: huawei_gaokun: move typec_altmode off stack

John Ogness <john.ogness@linutronix.de>
    serial: 8250: Ignore flow control on suspend/resume with no_console_suspend

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: lg-laptop: Check ACPI_COMPANION() against NULL

Ian Rogers <irogers@google.com>
    perf tests kvm: Avoid leaving perf.data.guest file around

Steven Rostedt <rostedt@goodmis.org>
    tracing: Move d_max_latency out of CONFIG_FSNOTIFY protection

Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
    mtd: rawnand: pl353: Fix debug prints

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

Pascal Kneuper <PKneuper@dspace.de>
    net: stmmac: restore NET_IP_ALIGN in the RX DMA offset

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
    netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()

Marino Dzalto <marino.dzalto@gmail.com>
    netfilter: xt_HL: add pr_fmt and checkentry validation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: move hardware offload step after building the chain blob

Alice Mikityanska <alice@isovalent.com>
    virtio-net: Ensure that TCP packets don't overflow gso_segs

Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
    drm/xe/xe_gt_idle: Add CCS to the powergating info print

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Pass the IP proto mask in the TC selftest

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: use BIT_ULL() to prevent shift overflow on 32-bit archs

Yifei Chu <Chuyf26@linux.alibaba.com>
    net/smc: release the internal TCP sock on IPPROTO_SMC socket creation failure

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: sun4i-emac: Fix IRQ error handling

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

John Johansen <john.johansen@canonical.com>
    apparmor: policy_int make sure list heads are initialized before fail path

Thorsten Blum <thorsten.blum@linux.dev>
    apparmor: Replace sprintf/strcpy with scnprintf/strscpy in aa_policy_init

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

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/mm: skip COW tmpfile cases when fallocate() is unsupported

Frank Sorenson <sorenson@redhat.com>
    cifs: fix clearing stats for fastest execution of each smb2 command

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: fix NULL deref of af_xdp_zc_qidx on rep setup

Allison Henderson <achender@kernel.org>
    net/rds: use wq_has_sleeper() in rds_cong_map_updated()

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_ife: Only operate on Ethernet frames

Eric Dumazet <edumazet@google.com>
    net/sched: add qstats_cpu_drop_inc() helper

Wei Fang <wei.fang@nxp.com>
    net: enetc: restore RX ring congestion mode after ring reconfiguration

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-af: Fix TL3/TL2 link config ENA clearing

Xiang Mei <xmei5@asu.edu>
    net: qualcomm: rmnet: restore skb->dev on deaggregated frames

Anshumali Gaur <agaur@marvell.com>
    octeontx2-vf: fix workqueue and netdev race in probe/remove

Anshumali Gaur <agaur@marvell.com>
    octeontx2-af: fix NULL deref in NIX TM tree debugfs read path

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: honor XDP_TX_METADATA in zero-copy path

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: align TX metadata layout across ABIs

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: RFCOMM: Validate MTU in rfcomm_apply_pn() to prevent infinite loop

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: btnxpuart: Validate the FW dump header length

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Fix out-of-bounds DMA read in the TX path

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Take exclusive ownership of the SKB before TX

Ismail Tarim <ismailtarim7@gmail.com>
    Bluetooth: btmtk: Do not discard the subsystem reset timeout

Ismail Tarim <ismailtarim7@gmail.com>
    Bluetooth: btmtk: Do not report success when subsys reset fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Bluetooth: btmtk: Fix short read errors in btmtk_usb_reg_read()

Javier Tia <floss@jetm.me>
    Bluetooth: btmtk: Add MT6639 (MT7927) Bluetooth support

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix race l2cap_sock_cleanup_listen() vs. put_chan

Pavel Shpakovskiy <pashpakovskii@salutedevices.com>
    Bluetooth: mgmt: fix 'hdev->discovery.uuids' NULL dereference

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: process: Fix context switching MTE store-only tag check

Wei-Lin Chang <weilin.chang@arm.com>
    arm64: ptdump: Make note_page_flush() range aware

Geert Uytterhoeven <geert+renesas@glider.be>
    erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic

Dan Carpenter <error27@gmail.com>
    scsi: qla2xxx: Fix an loop timeout test

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: vmbus: Skip VMBus module cleanup for non-nested root partition

Thierry Reding <treding@nvidia.com>
    syscore: Pass context data to callbacks

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: fix pacing delay underflow with pacing offload

Rong Zhang <i@rong.moe>
    net: page_pool: Remove zone/policy GFP flags when allocating XArray entries

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix concurrent bitmap overwrite in PTP setup

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix MISC interrupt unmasking in non-MSI-X mode and device shutdown

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: introduce WX_STATE_DOWN to serialize device shutdown state

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: schedule hardware stats update in watchdog

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: replace busy-wait reset flag with kernel mutex

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: support RSC offload

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: support RX desc merge mode

Wei Fang <wei.fang@nxp.com>
    ptp: netc: fix period truncation and potential divide-by-zero in PEROUT

Thomas Walsh <thwalsh@redhat.com>
    bnxt_en: Gate TPH enablement behind BNXT_SUPPORTS_QUEUE_API check

Guenter Roeck <linux@roeck-us.net>
    bnxt_en: Fix call to hardware monitoring event handler

Cosmo Chou <chou.cosmo@gmail.com>
    rtc: pcf85363: Add error checking to regmap calls in probe()

Junrui Luo <moonafterrain@outlook.com>
    NFSv4/pnfs: key the data server cache on the NFS version

Junrui Luo <moonafterrain@outlook.com>
    NFSv4.2: fix LAYOUTSTATS send buffer exhaustion

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: free pending qentry in smc_llc_flow_stop() before memset

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: free stashed qentry before overwrite in REQ_ADD_LINK to ADD_LINK transition

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue

Mina Almasry <almasrymina@google.com>
    net: tcp: block mixing readable and unreadable frags

Eric Dumazet <edumazet@google.com>
    inetpeer: randomize RB-tree node comparison using SipHash

Eric Dumazet <edumazet@google.com>
    ip6mr: plug drop_reason to ip6mr_cache_report()

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Free mr_table after RCU grace period.

Eric Dumazet <edumazet@google.com>
    net: change sock_queue_rcv_skb_reason() to return a drop_reason

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Remove RTNL in ipmr_rules_init() and ipmr_net_init().

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Convert ipmr_net_exit_batch() to ->exit_rtnl().

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Move unregister_netdevice_many() out of ipmr_free_table().

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Move unregister_netdevice_many() out of mroute_clean_tables().

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

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Skip disabled vports when setting max TX speed

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Implement query_port_speed callback

Or Har-Toov <ohartoov@nvidia.com>
    IB/core: Add query_port_speed verb

Or Har-Toov <ohartoov@nvidia.com>
    IB/core: Add helper to convert port attributes to data rate

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Add support for querying bond speed

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Handle port and vport speed change events in MPESW

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: E-Switch, use state lock for vport state changes

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Propagate LAG effective max_tx_speed to vports

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Add max_tx_speed and its CAP bit to IFC

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: E-Switch, support eswitch inactive mode

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: MPFS, add support for dynamic enable/disable

Saeed Mahameed <saeedm@nvidia.com>
    devlink: Introduce switchdev_inactive eswitch mode

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Count delivered packets in rx_packets and rx_bytes

Victor Nogueira <victor@mojatatu.com>
    net/sched: add get_fill_size callbacks for actions missing them

Ruoyu Wang <ruoyuw560@gmail.com>
    net: bridge: Reject descending VLAN tunnel ranges

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    xsk: fix NULL pointer dereference in __xsk_rcv()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: avoid double checking against rx queue being full

Rustam Adilov <adilov@disroot.org>
    irqchip/irq-realtek-rtl: Use readl_be()/writel_be() instead of readl()/writel()

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Add mask for interrupt handling

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Add interrupt data structure

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Split out parent setup code

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Add multicore support

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/irq-realtek-rtl: Add/simplify register helpers

Namjae Jeon <linkinjeon@kernel.org>
    smb: server: remove unused DES crypto header

Thomas Huth <thuth@redhat.com>
    smb: server: Remove obsolete "select CRYPTO_LIB_DES" from Kconfig file

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mtpav: shut down output timer before card teardown

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: amlogic-spisg: Make sure clk_init_data is fully initialized

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/ucma: Allow path records to exactly fit the output buffer

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: core: Add scoped cleanup helper for card references

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Use logical cpu 0 irs_data for dynamic IST allocation

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Fix gicv5_init_common() error paths

Lorenzo Pieralisi <lpieralisi@kernel.org>
    irqchip/gic-v5: Check for NULL LPI domain on domain teardown

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Synchronize CPU interface disable

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

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzg2l: Fix loss of interrupt

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: zynqmp: Return optional clock lookup errors

Frank Sorenson <sorenson@redhat.com>
    cifs: remove dead size-update blocks in cifs_setattr_unix/nounix

Christopher Lusk <clusk@northecho.dev>
    smb: client: fix request buffer leak in smb2_new_read_req()

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

Laurence Rowe <laurencerowe@gmail.com>
    vsock: avoid timeout for non-blocking accept() with empty backlog

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

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid pinfile fragment on fragment:{block, segment} mode

Chao Yu <chao@kernel.org>
    f2fs: cleanup w/ f2fs_need_rand_{blk, seg, seg_blk}

liujinbao1 <liujinbao1@xiaomi.com>
    f2fs:Fix incomplete search range in f2fs_get_victim when f2fs_need_rand_seg is enabled

Xin Xie <xiexinet@gmail.com>
    net: hsr: free learned nodes on device setup failure

Qingfang Deng <qingfang.deng@linux.dev>
    pppox: drain queued packets on channel handoff

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: b53: fix error propagation from b53_fdb_dump()

Junseo Lim <zirajs7@gmail.com>
    net: kcm: Hold RCU read lock while running BPF parser

Prabu Thayalan <prabu.ponrajthayalan@amd.com>
    ionic: fix completion descriptor access with 2x desc size

Wei Fang <wei.fang@nxp.com>
    ptp: netc: skip PEROUT disable if channel is not enabled

Dan Carpenter <error27@gmail.com>
    drm/xe: tests: fix error message in xe_migrate_sanity_test()

Fan Gong <gongfan1@huawei.com>
    hinic3: Fix skb linearization mismatch and drop skb when skb_checksum_help() failed

Karl Mehltretter <kmehltretter@gmail.com>
    octeontx2-af: initialize lmac_bmap in rvu_mcs_set_lmac_bmap()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, xdp: move offload check into dev_xdp_install()

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

ZhangGuoDong <zhangguodong@kylinos.cn>
    pnfs/blocklayout: Fix device leaks on parse failure

Ruoyu Wang <ruoyuw560@gmail.com>
    NFSv4: remove callback IDR entry on client allocation failure

Arnaud Bonnet <abo@medichon.fr>
    nfs: refactor pNFS functions using clear_and_wake_up_bit

Arnaud Bonnet <abo@medichon.fr>
    nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper

Ze Tan <tanze@kylinos.cn>
    smb/server: fix session leak in ksmbd_session_register()

Hang Nan <2122295973@qq.com>
    ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: disconnect on SMB3 decryption failure

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

Gao Xiang <xiang@kernel.org>
    erofs: guard on-disk algorithm IDs against Z_EROFS_COMPRESSION_MAX

Gao Xiang <xiang@kernel.org>
    erofs: fix interlaced ztailpacking pclusters

Gao Xiang <xiang@kernel.org>
    erofs: error out obviously illegal extents in advance

Gao Xiang <xiang@kernel.org>
    erofs: clean up encoded map flags

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: preserve error status in smb2_handle_negotiate()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix invalid pointer dereference in ksmbd_stop_durable_scavenger()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: free preauth sessions on connection teardown

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: do not advertise unimplemented CA support

Yunseong Kim <yunseong.kim@est.tech>
    ksmbd: validate ipc response length before dereferencing its fields

Enzo Matsumiya <ematsumiya@suse.de>
    smb: server: fix leak of ksmbd_ipc_login_request_ext() returned buffer

Guangshuo Li <lgs201920130244@gmail.com>
    ksmbd: Do not skip lock checks for single-byte ranges

Marius Cristea <marius.cristea@microchip.com>
    hwmon: (emc1403) Drop hysteresis for low limit temperature

Guenter Roeck <linux@roeck-us.net>
    hwmon: (emc1403) Rely on subsystem locking

Szymon Wilczek <swilczek.lx@gmail.com>
    hwmon: (coretemp) Fix core_data leak on CPUs without PTS

John Johansen <john.johansen@canonical.com>
    apparmor: fix deadlock in complain-mode change_hat

Hongyan Xu <getshell@seu.edu.cn>
    block: mtip32xx: synchronize ioctls with device removal

Yao Sang <sangyao@kylinos.cn>
    ublk: reject non-power-of-2 zone sizes in SET_PARAMS

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

Tao Cui <cuitao@kylinos.cn>
    sched_ext/scx_flatcg: Fix cvtime true-up on slice expiry

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: lskcipher - propagate errors from unaligned crypt

Zhushuai Yin <yinzhushuai@huawei.com>
    crypto: hisilicon/sec2 - fix CCM algorithm long packet failure

Michal Blaszczyk <michalblk@google.com>
    selftests/sched_ext: Fix flaky ddsp failure tests on busy systems

Israel Téllez García <i.tellez@btesa.com>
    bpf: Fix pending_pos walk on 32-bit ring position wrap

Hongyan Xu <getshell@seu.edu.cn>
    ACPI: scan: fix bus ID cleanup on device_add() failures

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Remove trace_buffer::cpus

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Fix missing sign-ext for signed 1-byte and 2-byte kfunc args

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Use ping_command() for IPv6 pings in lwt_ip_encap

Leon Hwang <leon.hwang@linux.dev>
    selftests/bpf: Add tests to verify the fix of encapsulating VxLAN in lwt

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

John Keeping <jkeeping@inmusicbrands.com>
    ALSA: seq: midi: Serialize input teardown with event_input

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: midi: Optimize event_input locking with RCU

Yuho Choi <dbgh9129@gmail.com>
    clocksource/drivers/armada: Unwind timer clock on init failure

Guangshuo Li <lgs201920130244@gmail.com>
    clocksource/drivers/clps711x: Do not unmap clocksource MMIO

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/debug: Fix deadlock during unregister

Yuho Choi <dbgh9129@gmail.com>
    xenbus: Unregister reboot notifier on init failure

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq27520g4: fix REG_TTES address

Matti Vaittinen <mazziesaccount@gmail.com>
    power: supply: bd99954: Drop bad register fields

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    PCI/ASPM: Disable/restore ASPM on every function for multi-function devices

Felix Gu <ustc.gu@gmail.com>
    spi: img-spfi: don't disable runtime PM on DMA deferred probe

Vineet Gupta <vineet.gupta@linux.dev>
    selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM

David Matlack <dmatlack@google.com>
    selftests: harness: Mark test fixture objects __maybe_unused

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: harness: Restore order of test functions

Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>
    kunit: tool: fix _list_tests filtering wrong variable when list has TAP prefix

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Remove leftover feature tests for removed cxx and clang support

Karl Mehltretter <kmehltretter@gmail.com>
    super: fix dying superblock warning messages

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    PCI/ASPM: Use pcie_capability_clear_and_set_word() for ASPM disable/restore

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

Yuho Choi <dbgh9129@gmail.com>
    ubi: Fix rollback for explicit UBI device numbers

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

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: refactor to use helpers

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

Maurizio Lombardi <mlombard@redhat.com>
    nvme: expose active quirks in sysfs

Keith Busch <kbusch@kernel.org>
    nvme: remove virtual boundary for sgl capable devices

Keith Busch <kbusch@kernel.org>
    block: accumulate memory segment gaps per bio

Sven Peter <sven@kernel.org>
    nvme-apple: Never set the opcode in the NVMMU TCB

Sven Peter <sven@kernel.org>
    nvme-apple: Don't set a DMA direction for commands without a data transfer

Sven Peter <sven@kernel.org>
    nvme-apple: Destroy the admin queue on removal

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()

Alistair Francis <alistair.francis@wdc.com>
    nvme: Add the DHCHAP maximum HD IDs

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/irqflags: Add out-of-line definitions of arch_local_irq_*() for KMSAN

Coiby Xu <coxu@redhat.com>
    s390: Drop unnecessary CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT

Coiby Xu <coxu@redhat.com>
    integrity: Make arch_ima_get_secureboot integrity-wide

Josh Poimboeuf <jpoimboe@kernel.org>
    arm64: bti: Disable in-kernel BTI with recent versions of Clang

Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
    ASoC: qcom: q6apm: keep the graph start count in sync with the DSP

Babanpreet Singh <bbnpreetsingh@gmail.com>
    spi: sprd-adi: Fix probe succeeding without registering the controller

Esteban Urrutia <esteuwu@proton.me>
    phy: qcom: qmp-combo: Drop qmp_v4_calibrate_dp_phy

Abel Vesa <abelvesa@kernel.org>
    phy: qualcomm: qmp-combo: Add DP offsets and settings for Glymur platforms

Wesley Cheng <wesley.cheng@oss.qualcomm.com>
    phy: qualcomm: qmp-combo: Update QMP PHY with Glymur settings

Wesley Cheng <wesley.cheng@oss.qualcomm.com>
    phy: qualcomm: Update the QMP clamp register for V6

Faisal Hassan <faisal.hassan@oss.qualcomm.com>
    phy: qcom-qmp-combo: Use regulator_bulk_data with init_load_uA for regulator setup

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

John Johansen <john.johansen@canonical.com>
    apparmor: change fn_label_build() call to not return NULL

John Johansen <john.johansen@canonical.com>
    apparmor: split xxx_in_ns into its two separate semantic use cases

Michael Walle <mwalle@kernel.org>
    powerpc/configs: enable CONFIG_RAS to fix EDAC support

Kuniyuki Iwashima <kuniyu@google.com>
    amt: Don't support cross-netns setup.

Liang Luo <luoliang@kylinos.cn>
    selftests/sched_ext: Check skeleton open failure in exit test

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/cpuset: Use WRITE_ONCE() for shared prs_err updates

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping

Gabriele Monaco <gmonaco@redhat.com>
    cgroup/cpuset: Rename update_unbound_workqueue_cpumask() to update_isolation_cpumasks()

Guixin Liu <kanie@linux.alibaba.com>
    nvme-pci: release descriptor pools on probe failure

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: propagate percpu_ref_init() failure in nvmet_ns_enable()

Zhengrong Li <zhengrong_li@linux.alibaba.com>
    nvmet: fix Reservation Register Replace for unregistered host with IEKEY

Runyu Xiao <runyu.xiao@seu.edu.cn>
    sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE

Weiming Shi <bestswngs@gmail.com>
    SUNRPC: check rpc_sockaddr2uaddr() return value in rpcb_register_inet4/6

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Store the hwmon device in cros_ec_hwmon_priv

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Register the thermal devices after the hwmon ones

Guenter Roeck <linux@roeck-us.net>
    hwmon: Support guard() and scoped_guard for subsystem locks

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Add support for temperature thresholds

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Move temperature channel params to a macro

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (cros_ec) Split up supported features in the documentation

Marco Elver <elver@google.com>
    arm64: Disable KCSAN instrumentation in delay.o

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Fix opaque and string encoders for unbounded members

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Do not declare union XDR functions in the definitions header

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Address some checkpatch whitespace complaints

Karl Mehltretter <kmehltretter@gmail.com>
    m68k: Fix backtraces for non-running tasks

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

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads

Ian Rogers <irogers@google.com>
    perf python: Fix memory leak in pyrf__metrics_cb

Ian Rogers <irogers@google.com>
    perf python: Validate CPU and thread maps in pyrf_evsel__open

Ian Rogers <irogers@google.com>
    perf python: Handle Py_None for thread and cpu maps

Ian Rogers <irogers@google.com>
    perf python: Check counts_values size in set_values

Ian Rogers <irogers@google.com>
    perf test: Fix skiplist leak in cmd_test

Ian Rogers <irogers@google.com>
    perf test: Support dynamic test suites with setup callback and private data

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix uninitialized pthread_join

Ian Rogers <irogers@google.com>
    perf stat: Fix evsel_list leak in cmd_stat

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

Ihor Solodrai <ihor.solodrai@linux.dev>
    bpf: Avoid faultable build ID reads under mm locks

Ihor Solodrai <ihor.solodrai@linux.dev>
    bpf: Factor out stack_map build ID helpers

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

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: MSFT: validate evt_prefix_len against the response length

Guangshuo Li <lgs201920130244@gmail.com>
    Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btmtk: add MT7902 SDIO support

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btmtk: add MT7902 MCU support

Sean Wang <sean.wang@mediatek.com>
    mmc: sdio: add MediaTek MT7902 SDIO device ID

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
    pinctrl: airoha: fix pwm pin function for an7581 and an7583

Christian Marangi <ansuelsmth@gmail.com>
    pinctrl: airoha: convert PWM GPIO to macro

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7583: fix I2C0_SDA_PD register bit order

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: an7581: fix pinconf of i2c_scl/i2c_sda pins

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    pinctrl: airoha: fix mdio bitfield names

Christian Marangi <ansuelsmth@gmail.com>
    pinctrl: airoha: add support for Airoha AN7583 PINs

Christian Marangi <ansuelsmth@gmail.com>
    pinctrl: airoha: convert PHY LED GPIO to macro

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()

Leo Martins <loemra.dev@gmail.com>
    btrfs: avoid GFP_ATOMIC allocations in qgroup free paths

Qu Wenruo <wqu@suse.com>
    btrfs: use aligned range for locking in extent_fiemap()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't clobber the extent buffer when zeroing it out

Yichong Chen <chenyichong@uniontech.com>
    btrfs: retry verity reads for not-uptodate Merkle folios

Qu Wenruo <wqu@suse.com>
    btrfs: always wait for ordered extents to avoid OE races

David Sterba <dsterba@suse.com>
    btrfs: merge setting ret and return ret

Qu Wenruo <wqu@suse.com>
    btrfs: make btrfs_repair_io_failure() handle bs > ps cases without large folios

Filipe Manana <fdmanana@suse.com>
    btrfs: defrag: fix deadlock between defrag and delalloc space reservation

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix sd_done() sense handling condition

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails

Swarna Prabhu <sw.prabhu6@gmail.com>
    scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: Move the sd_config_discard() function definition

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: Move the sd_remove() function definition

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    scsi: sd: Convert to SCSI bus methods

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    scsi: core: sysfs: Make use of bus callbacks

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    scsi: core: Pass a struct scsi_driver to scsi_{,un}register_driver()

Tanushree Shah <tshah@linux.ibm.com>
    perf trace-event: Fix integer truncation in do_read() and skip()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: Record matched usb_device_id into btusb_data

Johan Hovold <johan@kernel.org>
    Bluetooth: btusb: refactor endpoint lookup

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

James Clark <james.clark@linaro.org>
    perf: arm_pmuv3: Zero initialize hw_id branch stack field

James Clark <james.clark@linaro.org>
    coresight: Refactor etm4_config_timestamp_event()

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix leaked trace id

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix underflow for usage of (nrseqstate - 1)

James Clark <james.clark@linaro.org>
    coresight: Change syncfreq to be a u8

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

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    phy: qcom-sgmii-eth: relax order of .power_on() vs .set_mode*()

Linkai Gong <gonglinkai@kylinos.cn>
    soc: fsl: qe: check platform_driver_register() in qe_ic_of_init()

Yichong Chen <chenyichong@uniontech.com>
    hugetlbfs: release subpool on fill_super failure

Simon Glass <sjg@chromium.org>
    pinctrl: rockchip: Reset the pin count when recalculating SoC data

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware_loader: do not queue completed sysfs fallback requests

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

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

Biju Das <biju.das.jz@bp.renesas.com>
    phy: renesas: phy-rcar-gen3-usb2: Fix devm action registration for disabled VBUS regulator

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Add regulator for OTG VBUS control

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Factor out VBUS control logic

Meghana Malladi <m-malladi@ti.com>
    arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node

Jan Kara <jack@suse.cz>
    ext4: fix spurious message about orphan cleanup on RO fs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Fixup emit_cntxcntl()

Steve Dunnagan <sdunnaga@redhat.com>
    leds: gpio: Clear error pointers for skipped LEDs

Arnd Bergmann <arnd@arndb.de>
    leds: gpio: Make legacy gpiolib interface optional

Arnd Bergmann <arnd@arndb.de>
    gpiolib: move legacy interface into linux/gpio/legacy.h

Sven Peter <sven@kernel.org>
    mfd: macsmc: Fix key count endianness annotation

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mfd: iqs62x: Reject zero-length firmware records

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

Marco Crivellari <marco.crivellari@suse.com>
    module: replace use of system_wq with system_dfl_wq

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    RDMA/siw: Fix use-after-free in siw_accept()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: post the full-feature receive buffers after session registration

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: delay the final Login Response until the session is registered

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
    drm/sun4i: vi scaler: Fix coefficient selection

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Clean up registered formats on c2c_hists__init() and c2c_hists__reinit() failure

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf c2c: Fix error masking, OOM, and unchecked caller errors in hpp_list__parse()

Ian Rogers <irogers@google.com>
    perf c2c: Use perf_env e_machine rather than arch

Namhyung Kim <namhyung@kernel.org>
    perf report: Update sort key state from -F option

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix histogram entry collapsing for -F option

Tianyou Li <tianyou.li@intel.com>
    perf c2c: Add annotation support to perf c2c report

Alexey Charkov <alchark@flipper.net>
    clk: rockchip: rk3576: fix source muxes for SPI0..SPI4

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: synchronize heartbeat callbacks with o2net teardown

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf libbfd: Fix memory leaks and NULL fclose in BPF disassembly

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bpf: Add PROG_TAGS to required arrays in __bpf_event__print_bpf_prog_info()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf libbfd: Validate BPF prog info arrays before pointer cast

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults

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

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    intel_idle: Add cmdline option to adjust C-states table

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    intel_idle: Initialize sysfs after cpuidle driver initialization

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Check load-acquire src ptr type before the load

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sar2130p: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs8550-aim300: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp-blackrock: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix ternary operator precedence in ksm_tests

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes

Mike Rapoport (Microsoft) <rppt@kernel.org>
    selftests/mm: ksm_tests: use kselftest framework

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix invalid storage access after __cgroup_bpf_attach failed

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: use rsc_table_for_each_entry() in rproc_handle_resources()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: Move resource table data structure to its own header

Imran Shaik <imran.shaik@oss.qualcomm.com>
    arm64: dts: qcom: agatti: Add missing CX power domain to DISPCC

Andreas Kemnade <andreas@kemnade.info>
    drm/omap: dsi: Do not copy isr table

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: sophgo: cv180x: Allow the DMA multiplexer to set channel number for DMA controller

Yichong Chen <chenyichong@uniontech.com>
    fat: release buffer head after rebuilding parent

Guangshuo Li <lgs201920130244@gmail.com>
    rapidio: clear mport->net when rio_add_net() fails

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

Caleb Sander Mateos <csander@purestorage.com>
    ublk: check for ublk_unmap_io() returning 0

Caleb Sander Mateos <csander@purestorage.com>
    ublk: check import_ubuf() return value

Tao Cui <cuitao@kylinos.cn>
    block/kyber-iosched: flush per-cpu latency buckets over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-iocost: collect per-cpu latency stats over possible CPUs

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

Niklas Cassel <cassel@kernel.org>
    misc: pci_endpoint_test: Check SUCCESS bit for doorbell status

Shukai Ni <shukai.ni@kuleuven.be>
    dm-integrity: replace forgeable discard filler with a keyed sector marker

Karl Mehltretter <kmehltretter@gmail.com>
    tty: clear cdev pointer after cdev_add() failure

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

Gou Hao <gouhao@uniontech.com>
    powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    pinctrl: spacemit: validate pins in pinconf callbacks

Yulin Lu <luyulin@eswincomputing.com>
    pinctrl: eswin: Fix Handling of PIN_CONFIG_PERSIST_STATE

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    firmware: coreboot: Validate table bounds

Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
    firmware: google: Add bounds checks in coreboot_table_populate()

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: stop PMSR before P2P and NAN teardown

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: cfg80211: Add an API to configure local NAN schedule

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: split out UHR operation information

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: nl80211: refactor nl80211_parse_chandef

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: cfg80211: add support to handle incumbent signal detected event from mac80211/driver

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: add initial UHR support

Johannes Berg <johannes.berg@intel.com>
    wifi: ieee80211: add some initial UHR definitions

Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
    wifi: nl80211: Add support for EPP peer indication

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: cfg80211: include S1G_NO_PRIMARY flag when sending channel

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: disconnect on CSA to channel 0

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: skip unused probe response countdown offsets

Slawomir Stepien <sst@poczta.fm>
    wifi: zd1211rw: reject secondary interfaces to prevent conflicts

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: send TWT teardown to peer after setup TX failure

Davidlohr Bueso <dave@stgolabs.net>
    perf/cxlpmu: Fix 64-bit write to 32-bit HDM filter register

Pranjal Shrivastava <praan@google.com>
    iommu/arm-smmu-v3: Convert to use atomic poll timeout

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Don't write to P0 in irritator on SME only systems

Karl Mehltretter <kmehltretter@gmail.com>
    kselftest/arm64: fp-ptrace: Fix checks for inactive SVE and SSVE regsets

Karl Mehltretter <kmehltretter@gmail.com>
    arm64/fpsimd: ptrace: Fix inactive SVE and SSVE regsets

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: smp: Fix IPI teardown for GICv5 flow

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations

Linghui Wu <linghui.wu@oss.qualcomm.com>
    wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: reject out-of-range link ids in mt76_vif_link()

shengwei.lu <shengwei.lu@mediatek.com>
    wifi: mt76: mt7925: Fix EHT Beamformee SS subfields to meet 802.11be minimum

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: advertise EHT 320MHz capabilities for 6GHz band

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: fix queue assignment for disassoc packets

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: report RX chain signal for all RX paths

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1

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
    wifi: mt76: mt7996: free vif links after clearing wcid entries on full reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: wake MCU waiters before aborting scan in L1 SER

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: skip key upload when adding an offchannel link

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement

Yonghong Song <yonghong.song@linux.dev>
    bpf, x86: Fix trampoline stack size for 128-bit arguments

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

Joy Zou <joy.zou@oss.nxp.com>
    regulator: core: use system_freezable_wq for init complete work

Andrey Golovko <andrey.golovko@gmail.com>
    ASoC: tas2783-sdw: drop stale regcache on uninitialized re-attach

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: codecs: tas2783-sdw: Propagate regcache_sync() errors

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: tas2783: Use new SoundWire enumeration helper

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: Add a helper function to wait for device initialisation

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

Can Peng <pengcan@kylinos.cn>
    ACPI: processor: Unregister cpufreq notifier on init failure

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Optimize ACPI idle driver registration

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: only consume the WO drop bit on WED v2 devices

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: add missing rdd_idx check when enabling background radar

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: use little-endian for bss_info_ra wire fields

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: don't leak MLD group index on remap alloc failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unwind state on add_interface failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config

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

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix out-of-bounds array access during hardware restart

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: set specific BSSINFO and STAREC commands after channel switch

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: support fixed rate for link station

Rex Lu <rex.lu@mediatek.com>
    wifi: mt76: fix RX data queuing of RRO 3.0

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: fix capability of EHT-MCS 15 in MRU

Chad Monroe <chad@monroe.io>
    wifi: mt76: mt7996: fix EAPOL source BSS for non-MLD stations

Eason Lai <Eason.Lai@mediatek.com>
    wifi: mt76: mt792x: Fix memory leak in SDIO TX path

Jared.Huang <jared.huang@mediatek.com>
    wifi: mt76: mt7925: fix msg len mismatch between driver and firmware

Jared.Huang <jared.huang@mediatek.com>
    wifi: mt76: mt7925: update clc before setting sar power table

Eason Lai <Eason.Lai@mediatek.com>
    wifi: mt76: mt7921: Add PCIe AER handler support to prevent system crash

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: always enable RRO queues for non-MT7992 chipset

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: Introduce the NPU generic layer

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: Move Q_READ/Q_WRITE definitions in dma.h

Zhi-Jun You <hujy652@gmail.com>
    wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: validate CLC firmware records

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

Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
    locking/lockdep: Fix NULL pointer dereference in __lock_set_class()

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

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md: skip redundant raid_disks update when value is unchanged

Chen Cheng <chencheng@fnnas.com>
    md: remove unused mddev argument from export_rdev

Chen Cheng <chencheng@fnnas.com>
    md/bitmap: resume array on backlog_store() error path

Vladimir Zapolskiy <vz@kernel.org>
    clk: qcom: Return expected ENOMEM error on dynamic allocation failure

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: gpucc-qcm2290: Park RCG's clk source at XO during disable

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF when reading bpf link info

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF in bpf_netns_link_update_prog

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: sc2731_charger: cancel work on remove

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: isp1704_charger: cancel work on remove

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: qcs6490-rb3gen2: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries

Shawn Guo <shengchao.guo@oss.qualcomm.com>
    arm64: dts: qcom: lemans: Move PCIe devices into soc node

Odelu Kukatla <odelu.kukatla@oss.qualcomm.com>
    arm64: dts: qcom: sa8775p: Add reg and clocks for QoS configuration

Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
    arm64: dts: qcom: lemans: add QCrypto node

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: lemans: add refgen regulator and use it for DSI

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: lemans: move USB PHYs to a proper place

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

Dawid Wróbel <me@dawidwrobel.com>
    arm64: dts: qcom: sm8250-xiaomi-elish: correct the board ID

Keith Busch <kbusch@kernel.org>
    block: fix dio leak on metadata mapping error

Christoph Hellwig <hch@lst.de>
    block: add a bio_endio_status helper

Christoph Hellwig <hch@lst.de>
    block: don't set BIO_QUIET for BLK_STS_AGAIN

Christoph Hellwig <hch@lst.de>
    blk-crypto: use on-stack skcipher requests for fallback en/decryption

Christoph Hellwig <hch@lst.de>
    blk-crypto: optimize bio splitting in blk_crypto_fallback_encrypt_bio

Christoph Hellwig <hch@lst.de>
    blk-crypto: submit the encrypted bio in blk_crypto_fallback_bio_prep

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

Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
    firmware: qcom_scm: Support multiple waitq contexts

Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
    firmware: qcom_scm: Add API to get waitqueue IRQ info

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en

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

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: consistently fail atomic writes that require splitting

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc/powerpc: mark ctr and xer as clobbered by system call

Yichong Chen <chenyichong@uniontech.com>
    fanotify: stop permission watchdog when timeout is zero

Chen Cheng <chencheng@fnnas.com>
    md/raid5: protect lockless recovery_offset accesses during reshape

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

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Pass --eh-frame-hdr to the linker

Heiko Carstens <hca@linux.ibm.com>
    s390/vdso: Rename vdso64 to vdso

Heiko Carstens <hca@linux.ibm.com>
    s390: Add stackprotector support

Heiko Carstens <hca@linux.ibm.com>
    s390: Remove compat support

Heiko Carstens <hca@linux.ibm.com>
    s390/syscalls: Add pt_regs parameter to SYSCALL_DEFINE0() syscall wrapper

Heiko Carstens <hca@linux.ibm.com>
    s390/ptrace: Rename psw_t32 to psw32_t

Hungyu Lin <dennylin0707@gmail.com>
    media: qcom: iris: handle runtime PM resume failure in core deinit

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

Fan Wu <fanwu01@zju.edu.cn>
    spi: davinci: switch to managed controller allocation

Guixin Liu <kanie@linux.alibaba.com>
    nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request

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

David Strahan <David.Strahan@microchip.com>
    scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch

David Lee <david.lee@trailofbits.com>
    nilfs2: prevent out-of-bounds read in super root block parsing

Joshua Crofts <joshua.crofts1@gmail.com>
    nilfs2: fix infinite loop in nilfs_clean_segments()

Alexey Charkov <alchark@flipper.net>
    clk: rockchip: Fix the fractional part denominator on RK3588/RK3576 PLLs

Akari Tsuyukusa <akkun11.open@gmail.com>
    clk: mediatek: mt8135: Fix inverted gate control for devapc_ck

longlong yan <yanlonglong@kylinos.cn>
    clk/x86: pmc_atom: add kasprintf return value check

Myeonghun Pak <mhun512@gmail.com>
    clk: palmas: Manage external-control prepare with devm

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    clk: mediatek: pllfh: Fix IO remapping leak in register_pllfhs error path

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    clk: mediatek: Refactor pllfh registration to pass device

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    clk: mediatek: Pass device to clk_hw_register for PLLs

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    clk: mediatek: Refactor pll registration to pass device

Guangshuo Li <lgs201920130244@gmail.com>
    clk: tegra: tegra124-emc: put EMC node on register failure

Ondrej Jirman <megi@xff.cz>
    arm64: dts: allwinner: sun50i-a64-pinephone: Fix mpu6050 mount matrix

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: fix per-STA profile length in cross-link CSA parsing

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
    iommu/tegra241-cmdqv: Don't run the error ISR before probe sets up vintfs

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Synchronize the error ISR against VINTF (de)init

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Publish an LVCMDQ only after it is fully initialized

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: reject restart table growth beyond U16_MAX entries

Ivy Lopez <skunkolee@gmail.com>
    staging: rtl8723bs: use kfree_sensitive() for key material

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom_scm: Introduce PAS context allocator helper function

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Prevent crash handling to race with rproc_del()

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: core: Attach rproc asynchronously in rproc_add() path via schedule_work()

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Allow shutdown of crashed processors

Peng Fan <peng.fan@nxp.com>
    remoteproc: core: Drop redundant initialization of 'ret' in rproc_shutdown()

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate: Set min_limit_freq based on bios_min_perf

Juan Martinez <juan.martinez@amd.com>
    cpufreq/amd-pstate: Add comment explaining nominal_perf usage for performance policy

Babanpreet Singh <bbnpreetsingh@gmail.com>
    w1: ds2482: Fix signedness bug in ds2482_w1_triplet()

Fan Wu <fanwu01@zju.edu.cn>
    spi: oc-tiny: switch to managed controller allocation

Myeonghun Pak <mhun512@gmail.com>
    clk: mediatek: mt6735: Unregister PLLs on probe failure

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

Maher Sanalla <msanalla@nvidia.com>
    RDMA/mlx5: Fix integer overflow of user QP buffer size

Can Peng <pengcan@kylinos.cn>
    crypto: keembay - publish OF module alias for OCS AES/SM4

Linmao Li <lilinmao@kylinos.cn>
    crypto: keembay - Initialize completion before requesting IRQ

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: debugfs: Reserve space for a string terminator

Babanpreet Singh <bbnpreetsingh@gmail.com>
    power: supply: sbs-battery: Use a per-device serial number buffer

Kohei Enju <enju.kohei@fujitsu.com>
    arm64: RSI: fix field-spanning write warning in attestation token init

James Clark <james.clark@linaro.org>
    tools/build: Allow versioning of all LLVM tools defined in Makefile.include

Justin Yeh <justin.yeh@mediatek.com>
    pinctrl: mediatek: free EINT resources on unbind

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Fix use-after-free in find_pos_and_ways() error path

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix memory leak on subtest_states reallocation

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix incorrect error checking for pthread_create

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

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: return PTR_ERR() from devm_drm_dev_alloc()

Weiming Wu <weiming3@asu.edu>
    fs/ntfs3: fix out-of-bounds read of INDEX_ROOT in reparse/objid init

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet

Can Peng <pengcan@kylinos.cn>
    drm/tve200: add OF module alias for autoloading

Ian Rogers <irogers@google.com>
    perf cap: Remove used_root parameter and simplify capability checks

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

Junhui Liu <junhui.liu@pigmoral.tech>
    riscv: dts: spacemit: k1: Split gmac_clk_ref into independent pinctrl groups

Michael Opdenacker <michael.opdenacker@rootcommit.com>
    riscv: dts: spacemit: Add OrangePi R2S board device tree

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    riscv: dts: spacemit: add MusePi Pro board device tree

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unrequest devices if driver registration fails

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Roll back partial protocol table registration

Marco Scardovi <scardracs@disroot.org>
    cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems

Marco Scardovi <scardracs@disroot.org>
    cpufreq/amd-pstate: Fix EPP return type and handle errors during initialization

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Add support for platform profile class

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Add dynamic energy performance preference

Gautham R. Shenoy <gautham.shenoy@amd.com>
    amd-pstate: Make certain freq_attrs conditionally visible

Mario Limonciello (AMD) <superm1@kernel.org>
    cpufreq/amd-pstate: Use sysfs_match_string() for epp

Qianheng Peng <pengqh1@chinatelecom.cn>
    cpufreq: amd-pstate-ut: Skip tests when amd-pstate driver is not active

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: allwinner: a10: Fix PMU interrupt

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

Yao Kai <yaokai34@huawei.com>
    ext4: validate readdir offset before accessing dirent

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: use fsdata to track inline data write state and fix race

Baokun Li <libaokun@linux.alibaba.com>
    ext4: drain in-flight DIO before buffered write fallback

Gerald Yang <gerald.yang@canonical.com>
    ext4: clear stale xarray tags on folios skipped during writeback

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

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/nldev: Fix locking when accessing mr->pd

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/restrack: Fix typos in the comments

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

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Silence array bounds warning in global_map_resize

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Check malloc result with ASSERT_NEQ in test_sha256

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Don't use cpu-type matching in cpu_vuln_blacklist

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8-ss-audio: Fix LPCG clock indices for ASRC0

Marco Elver <elver@google.com>
    kcsan: avoid unintended access checking in NMIs

TanZheng <tanzheng@kylinos.cn>
    RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters

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

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Reject arena frees below the arena base

Puranam V G Tejaswi <puranam.tejaswi@oss.qualcomm.com>
    drm/msm/a6xx: Fix RBBM_CLOCK_CNTL3_TP0 value in a730_hwcg

Yuho Choi <dbgh9129@gmail.com>
    driver core: soc: Unregister bus on early device registration failure

Alban Bedel <alban.bedel@lht.dlh.de>
    software node: Fix software_node_get_reference_args() with index -1

Ian Rogers <irogers@google.com>
    perf ui hists: Fix uninitialized stack memory free on pstack allocation failure

zhouminqiang <zhouminqiang2@huawei.com>
    mtd: part: reject MTDPART_OFS_RETAIN in mtd_add_partition()

Ruoyu Wang <ruoyuw560@gmail.com>
    mtd: mtdswap: Avoid freeing registered blktrans device twice

Guangshuo Li <lgs201920130244@gmail.com>
    mtd: intel-dg: Fix runtime PM error path in probe

Alexander Usyskin <alexander.usyskin@intel.com>
    mtd: intel-dg: wake card on operations

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: ti: knav_qmss: Remove debugfs file on teardown

Md Shofiqul Islam <shofiqtest@gmail.com>
    soc: ti: knav_qmss_queue: Implement resource cleanup in remove()

Xiang Mei <xmei5@asu.edu>
    vfio/pci: clear vdev->msi_perm after freeing it on init failure

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

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    speakup: keyhelp: guard letter_offsets possible out-of-range indexing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    accessibility: speakup: Fix incorrect string length computation in report_char_chartab_status()

Yuho Choi <dbgh9129@gmail.com>
    uio: Fix stale info pointer in failed registration path

Gui-Dong Han <hanguidong02@gmail.com>
    gpib: Move stuck SRQ update under lock

Cong Nguyen <congnt264@gmail.com>
    staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths

Mohammed Rizwan Kaniyate <mrizwank004@gmail.com>
    staging: rtl8723bs: remove multiple blank lines in core/

Minu Jin <s9430939@naver.com>
    staging: rtl8723bs: replace rtw_zmalloc() with kzalloc()

Nayana Mariyappa <nayana.mariyappa@gmail.com>
    staging: rtl8723bs: expand multiple assignment into separate statements

Khushal Chitturi <khushalchitturi@gmail.com>
    staging: rtl8723bs: fix operator and type cast spacing

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: use standard offsetof in cfg80211 operations

Sameeksha Sankpal <sameekshasankpal@gmail.com>
    staging: rtl8723bs: Fix operator spacing in rtw_security.c

David Lee <david.lee@trailofbits.com>
    UDF symlink pathComponent header OOB read

Karl Mehltretter <kmehltretter@gmail.com>
    tty: hvc: restrict HVC_DCC to ARMv6+ and ARM64

Xu Yang <xu.yang_2@nxp.com>
    usb: gadget: f_uac1_legacy: remove broken string configfs attributes

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: idle: Expand _LPI package sanity checks

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping

Pu Lehui <pulehui@huawei.com>
    bpf: Sync tail_call_reachable with callee state on entry

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/msm: Only fini scheduler after successful init

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm: Fix task_struct reference leak in recover_worker

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm/a6xx: Fix A621 GPUCC register list for state capture

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Rebase GMU register offsets

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm/a6xx: Fix A663 GPUCC register list for state capture

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm: Recover HW before retire hung submit

Shivam Rawat <shivrawa@qti.qualcomm.com>
    drm/msm/a6xx: Fix stale rpmh votes after suspend

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Avoid stack over-read in debug output helpers

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix offset calculation in trace_write_gather

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

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: geni-qcom: Fix sticky ret causing wrong return value on invalid proto

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: r8a78000: Drop duplicate "default ARCH_RENESAS"

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: gcc-glymur: Enable runtime PM

Ian Rogers <irogers@google.com>
    perf jevents: Add more components to the metric sorting order

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: correct frequencies in the Iris OPP table

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: sort out Iris power domains

George Moussalem <george.moussalem@outlook.com>
    arm64: qcom: ipq5018: Add GEPHY RX and TX clocks

George Moussalem <george.moussalem@outlook.com>
    arm64: dts: qcom: ipq5018: Correct CMN PLL reference clock rate

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

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix setting minimum P-state at init time

Gleb Markov <markov.gi@npc-ksb.ru>
    drm/amd/display: Remove unused-but-set variable hubp from

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amd/display: Fix DM I2C teardown race

Ruoyu Wang <ruoyuw560@gmail.com>
    media: ipu6: Do not free aux device pdata after init

Eugen Hristev <ehristev@kernel.org>
    media: bcm2835-unicam: Fix asc leaked in error/remove path

Biren Pandya <birenpandya@gmail.com>
    media: i2c: rdacm21: Fix missing media_entity_cleanup()

Qingshuang Fu <fuqingshuang@kylinos.cn>
    irqchip/renesas-irqc: Fix generic interrupt chip leak on remove

Yuho Choi <dbgh9129@gmail.com>
    PCI: xgene: Drop unnecessary OF node reference

Dan Carpenter <error27@gmail.com>
    cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()

John Groves <John@Groves.net>
    dax: read holder_ops once in dax_holder_notify_failure()

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
    firmware: arm_scmi: Unwind P2A receiver mailbox setup failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unwind TX receiver mailbox setup failure

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

Kyle Zeng <kylebot@openai.com>
    hfsplus: validate thread record before delete key rebuild

Alison Schofield <alison.schofield@intel.com>
    cxl/port: Restart port enumeration when a sibling adds the dport first

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Honor -EPROBE_DEFER from component register setup

Dave Jiang <dave.jiang@intel.com>
    cxl/mbox: Break poison list loop on an empty payload

Guzebing <Guzebing1612@gmail.com>
    cxl/memdev: Fix firmware upload exact-fit handling

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Simplify iommufd_device_remove_vdev()

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    rpmsg: glink: fix deadlock in endpoint destroy during driver detach

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    rpmsg: glink: remove duplicate code for rpmsg device remove

Dmitry Ilvokhin <d@ilvokhin.com>
    perf record: Fix multiple PERF_RECORD_COMPRESSED2 records per push

Dmitry Ilvokhin <d@ilvokhin.com>
    perf record: Return the written size from process_comp_header()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf zstd: Fix compression error path in zstd_compress_stream_to_records()

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: v4l2-async: Unregister sub-device if asc_list is empty

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
    RDMA/hfi1: Create workqueues before device initialization

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Remove redundant PCI device ID validation

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Free RX data on late probe failure

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Preserve unit 0 on allocation failure

Sean Rhodes <sean@starlabs.systems>
    misc: rtsx_usb: avoid USB I/O in runtime autosuspend

Pengpeng Hou <pengpeng@iscas.ac.cn>
    pmdomain: bcm: bcm2835: handle genpd provider registration errors

Evgenii Burenchev <evg28bur@yandex.ru>
    ALSA: hpi: Check transport errors during HPI6000 adapter initialization

Xiang Mei <xmei5@asu.edu>
    xfrm6: fix out-of-bounds write in xfrm6_input_addr() when secpath is full

Guangshuo Li <lgs201920130244@gmail.com>
    crash_dump: release keyring reference at the correct time

Yuho Choi <dbgh9129@gmail.com>
    hwrng: ks-sa - Fix runtime PM cleanup on registration failure

Atish Patra <atishp@meta.com>
    crypto: ccp - Fix memory leak in SEV INIT_EX path

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

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: phy: support per PHY RX statistics

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: mlo: rearrange MLSR link decision flow

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: debug: add parser to diagnose along DIAG_MAC fw element

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fw: parse firmware element of DIAG_MAC

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: add to read PCI configuration space from common code

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Require a BPF cpumask for bpf_cpumask_populate()

Tejun Heo <tj@kernel.org>
    tools/sched_ext: Strip compatibility macros for cgroup and dispatch APIs

Brian Masney <bmasney@redhat.com>
    clk: qcom: camcc-sc8280xp: unregister CAMCC_GDSC_CLK

Pengpeng Hou <pengpeng@iscas.ac.cn>
    bus: qcom-ebi2: use managed resources for clocks and children

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: qcom: rpmh-rsc: manage PM notifiers with devres

Yu Peng <pengyu@kylinos.cn>
    perf metricgroup: Fix metric expression copy leaks

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    drm/panel: samsung-s6d16d0: Power off on prepare failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    usb: typec: ucsi: gaokun: unwind notifier on UCSI register failure

Pengyu Luo <mitltlatltl@gmail.com>
    usb: ucsi: huawei_gaokun: support mode switching

Biju Das <biju.das.jz@bp.renesas.com>
    usb: renesas_usbhs: Fix power-off ordering on unbind

Fei Shao <fshao@chromium.org>
    usb: mtu3: allow system suspend during active gadget connection

Linmao Li <lilinmao@kylinos.cn>
    platform/surface: acpi-notify: Check ACPI companion before use

Linmao Li <lilinmao@kylinos.cn>
    platform/mellanox: mlxbf-pmc: Check ACPI_COMPANION() against NULL

Gary Guo <gary@garyguo.net>
    usb: fix UAF when probe runs concurrent to dyn ID removal

Ruoyu Wang <ruoyuw560@gmail.com>
    usb: gadget: aspeed_udc: check endpoint DMA allocation

Maoyi Xie <maoyixie.tju@gmail.com>
    usb: ljca: bound bank_num in ljca_enumerate_gpio()

Michael Bommarito <michael.bommarito@gmail.com>
    usb: gadget: configfs: fix out-of-bounds read of qw_sign

Nuno Sá <nuno.sa@analog.com>
    usb: gadget: f_fs: Fix fence cleanup in ffs_dmabuf_transfer() error paths

Guangshuo Li <lgs201920130244@gmail.com>
    serial: qcom-geni: do not advance stale DMA completions

Yuho Choi <dbgh9129@gmail.com>
    serial: ma35d1: Fix OF node reference leaks in console init

Fushuai Wang <wangfushuai@baidu.com>
    serial: 8250: Clear CON_PRINTBUFFER on port re-registration

John Ogness <john.ogness@linutronix.de>
    serial: 8250: Add support for console flow control

John Ogness <john.ogness@linutronix.de>
    serial: 8250: Set cons_flow on port registration

John Ogness <john.ogness@linutronix.de>
    serial: Replace driver usage of UPF_CONS_FLOW

John Ogness <john.ogness@linutronix.de>
    serial: core: Add dedicated uart_port field for console flow

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: qcom-geni: Fix missing error check on pm_runtime_get_sync()

Tengda Wu <wutengda@huaweicloud.com>
    perf capstone: Fix kernel map reference count leak

Liang Luo <luoliang@kylinos.cn>
    selftests/sched_ext: Fix bpf_link leak on early return in prog_run

Wolfram Sang <wsa+renesas@sang-engineering.com>
    hwspinlock: propagate errno when registering single lock

Felix Gu <gu_0233@qq.com>
    remoteproc: qcom_q6v5_adsp: Fix reference leak for device node

Armin Wolf <W_Armin@gmx.de>
    platform/x86: lg-laptop: Fix LED resource handling

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: lg-laptop: Convert ACPI driver to a platform one

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: lg-laptop: Drop debug-only ACPI notify handler

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

Andrew Murray <amurray@thegoodpenguin.co.uk>
    printk: Introduce console_flush_one_record

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

Wei Wang <wei.w.wang@hotmail.com>
    iommu/amd: Fix false positive in SB IOAPIC IVRS validation

Fu Hao <fuhao@open-hieco.net>
    iommu/amd: Add support for Hygon family 18h model 4h IOAPIC

Wei Wang <wei.w.wang@hotmail.com>
    iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors

Vladimir Zapolskiy <vz@kernel.org>
    iommu/msm: Return -ENOMEM on memory allocation failure in probe

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix security_bpf_map_create error handling

Akari Tsuyukusa <akkun11.open@gmail.com>
    iommu/mediatek-v1: Fix off-by-one in MT2701_LARB_NR_MAX

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

Tanushree Shah <tshah@linux.ibm.com>
    perf data convert json: Fix trace_seq memory leak in process_sample_event()

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    timens: Simplify some calls to put_time_ns()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    timens: Add a __free() wrapper for put_time_ns()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    timens: Remove dependency on the vDSO

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    vdso/timens: Move functions to new file

Petr Tesarik <ptesarik@suse.com>
    x86/tsx: Make tsx_ctrl_state static

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

Malaya Kumar Rout <malayarout91@gmail.com>
    selftests/bpf: Fix memory leak in msg_alloc_iov error path

Evgenii Burenchev <evg28bur@yandex.ru>
    ALSA: via82xx: Remove unreachable branch in snd_via686_pcm_pointer()

Dawei Feng <dawei.feng@seu.edu.cn>
    staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: replace pr_warn with dev_warn in fill and rx paths

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: ethernet-mem: replace pr_warn with dev_warn in free functions

Yuvraj Singh Chauhan <ysinghcin@gmail.com>
    staging: octeon: fix free_irq dev_id mismatch in cvm_oct_rx_shutdown

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

Ruoyu Wang <ruoyuw560@gmail.com>
    bus: qcom-ebi2: Fix clock leak on probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    bus: qcom-ebi2: Simplify with scoped for each OF child loop

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gcc-glymur: Move EVA clocks to critical clock list

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: hamoa: Fix clocks for HSPHYs

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name

Jens Glathe <jens.glathe@oldschoolsolutions.biz>
    arm64: dts: qcom: sc8280xp-blackrock: switch to uefi rtc offset

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
    perf vendor events amd: Update Zen 5 core events

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Add group validation

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Fix thread leaks on trace queue init failure

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: mark arg1 operand in __nolibc_syscall0() as write-only

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    fanotify: initialize permission event watchdog state

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rtw89: fix HE extended capability length check

Dmitry Morgun <d.morgun@ispras.ru>
    wifi: rtw89: check return values in rtw89_ops_start_ap()

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: update format of addr cam H2C command

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fill addr cam H2C command by struct

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: sensorhub: Fix memory overread in ring handler

Hisam Mehboob <hisamshar@gmail.com>
    selftests/rseq: Replace glibc-specific __GNUC_PREREQ with portable check

Hanlin Song <pgeorge8929@gmail.com>
    csky: Fix a4/a5 restoration in syscall trace path

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: orientation: hid-sensor-rotation: Avoid race between callback setup and device exposure

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    soundwire: qcom: Fix port exhaustion check in stream_alloc_ports

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: fix race between runtime PM and device removal

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure

Gregory Price <gourry@gourry.net>
    mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug

Gregory Price <gourry@gourry.net>
    mm: name the anonymous MMOP enum as enum mmop

Israel Batista <linux@israelbatista.dev.br>
    mm: change type of state in struct memory_block

Israel Batista <linux@israelbatista.dev.br>
    mm: convert memory block states (MEM_*) macros to enum

Sechang Lim <rhkrqnwk98@gmail.com>
    bpf,lsm: Drop bpf_prog_free from sleepable_lsm_hooks

Guillaume Maudoux <layus.on@gmail.com>
    selftests/bpf: Mask socket type flags in mptcpify prog

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: Systematically add SO_REUSEADDR in start_server_addr

Leon Hwang <leon.hwang@linux.dev>
    bpf: Copy per-CPU map value padding in copy_map_value_long()

Yichong Chen <chenyichong@uniontech.com>
    tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands

Yichong Chen <chenyichong@uniontech.com>
    tools/bpf/bpftool: Reset vmlinux BTF after map commands

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in Vega10 lookup

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in SMU7 lookup

Uday Khare <udaykhare77@gmail.com>
    regulator: tps6594: Fix device node reference leaks in multiphase loop

Ian Rogers <irogers@google.com>
    perf tests: Fix flakiness in branch stack sampling tests

Ian Rogers <irogers@google.com>
    perf test: Fixes for check branch stack sampling

Ian Rogers <irogers@google.com>
    perf tests: Fix flakiness in BPF counters test on hybrid systems

Namhyung Kim <namhyung@kernel.org>
    perf test: Fix perf stat --bpf-counters on hybrid machines

Ian Rogers <irogers@google.com>
    perf tests: Fix flakiness in trace record and replay test

Ian Rogers <irogers@google.com>
    perf tests: Add robust record retry helper and use subsecond workloads

Ian Rogers <irogers@google.com>
    perf test kvm: Add some basic perf kvm test coverage

Ian Rogers <irogers@google.com>
    perf tests: Skip metrics validation if system-wide recording lacks permission

Namhyung Kim <namhyung@kernel.org>
    perf test: Do not skip when some metrics tests succeeded

Ian Rogers <irogers@google.com>
    perf test all metrics: Fully ignore Default metric failures

Ian Rogers <irogers@google.com>
    perf test metrics: Update all metrics for possibly failing default metrics

Ian Rogers <irogers@google.com>
    perf test: Truncate test description to fit terminal width

Ian Rogers <irogers@google.com>
    perf test: Truncate printed test descriptions dynamically to avoid terminal wrapping

Ian Rogers <irogers@google.com>
    perf test: Add -j/--junit option for JUnit XML test reports

Ian Rogers <irogers@google.com>
    perf test: Fix subtest status alignment for multi-digit indexes

Ian Rogers <irogers@google.com>
    perf test: Add summary reporting

Ian Rogers <irogers@google.com>
    perf test: Show snippet failure output for verbose=1

Ian Rogers <irogers@google.com>
    perf test: Refactor parallel poll loop to drain all pipes simultaneously

Ian Rogers <irogers@google.com>
    perf test: Drain pipe after child finishes to avoid losing output

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: correct monitor destination ring size

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define

Jinjie Ruan <ruanjinjie@huawei.com>
    riscv: kexec_file: Fix crashk_low_res not exclude bug

Daniel McCarthy <daniel@dragonzap.com>
    pinctrl: bcm2835: Don't remove an unregistered GPIO chip

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails

Chen, Yu C <yu.c.chen@intel.com>
    sched/fair: Fix overflow in update_tg_cfs_runnable()

Wei Yang <richard.weiyang@gmail.com>
    mm/mm_init: fix incorrect node_spanned_pages

Henrik Grimler <henrik.grimler@axis.com>
    drm/lima: call drm_mm_init() with a valid allocation range

Brian Masney <bmasney@redhat.com>
    clk: imx: scu: drop redundant init.ops variable assignment

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx93-kontron: set memory node to 0x80000000/1GiB

Weigang He <geoffreyhe2@gmail.com>
    ARM: imx: fix device_node refcount leaks in imx7_src_init()

Weigang He <geoffreyhe2@gmail.com>
    ARM: imx: fix device_node refcount leak in imx_src_init()

Min zhang <zhangmin2026@yeah.net>
    clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller

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

Myeonghun Pak <mhun512@gmail.com>
    clk: versaclock7: Fix APLL clock leak on probe failure

Wei Hou <wei.hou@scaleflux.com>
    cxl/pci: Remove incorrect mbox.valid check in cxl_pci_type3_init_mailbox()

Richard Cheng <icheng@nvidia.com>
    cxl/mbox: Clamp mailbox output allocation to the payload size

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

Wanwu Li <liwanwu@kylinos.cn>
    sched_ext/scx_flatcg: Fix cvtime_delta race and add hweight scaling to bypass charging

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

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/rockchip: vop2: Add RK3576 to the RG swap special case

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Clear queue->active_job when v3d_fence_create() fails

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
    drm/rockchip: dw_dp: Simplify error handling

Andy Yan <andy.yan@rock-chips.com>
    drm/bridge: synopsys: dw-dp: Set pixel mode by platform data

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/bridge: synopsys: dw-dp: Support unregistering the AUX channel

Paul Kocialkowski <paulk@sys-base.io>
    drm: lcdif: Wait for vblank before disabling DMA

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
    KVM: x86: Extract REGS and SREGS runtime sync code to helpers

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize data structures for inject_pfault_token

Yosry Ahmed <yosry@kernel.org>
    KVM: x86: Disallow EFER.LME and EFER.LMA if long mode is not supported

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Remove VM-wide VNCR mapping counter

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: dt-bindings: nxp,imx8-isi: Drop fsl,blk-ctrl requirement for i.MX8ULP

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR unmapping

Oliver Upton <oupton@kernel.org>
    KVM: arm64: nv: Fully update VNCR fixmap state in kvm_translate_vncr()

Bryam Vargas <hexlabsecurity@proton.me>
    dm-pcache: validate the persisted dirty_tail chain at load

Bryam Vargas <hexlabsecurity@proton.me>
    dm-pcache: bound the logical key offset from persistent memory

Bryam Vargas <hexlabsecurity@proton.me>
    dm-pcache: reject a kset that overruns its segment

Yuhang.chen <yhchen312@gmail.com>
    wifi: rtw89: pci: add .shutdown callback to stop rfkill polling on reboot

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix wakeup from S3 after controller context loss

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix anon_stack check for unnamed bitfields in btf_find_struct_member

Muhammad Bilal <meatuni001@gmail.com>
    staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Add support for OMEN MAX 16-ak0xxx (8DD6)

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Fix msg_port restoration in amd_stb_debugfs_open_v2()

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/secretmem: properly account locked pages

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP

Usama Arif <usama.arif@linux.dev>
    mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix use-after-free of master->this

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Do not treat master device as a duplicate target

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Take trace_array reference before accessing its ftrace_ops

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: Fix test_ctl_hi field for DEFAULT_EVO PLLs

Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
    accel/amdxdna: return early from a zero-length flush

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: refcount requests for token lifetime

Hui Su <sh_def@163.com>
    io_uring/waitid: avoid siginfo copy during ring teardown

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags

Hui Su <sh_def@163.com>
    io_uring/waitid: honor task_work cancellation

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: always wake -ENOSPC waiters

Caleb Sander Mateos <csander@purestorage.com>
    io_uring: add wrapper type for io_req_tw_func_t arg

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: stop allocating child flush bio

Caleb Sander Mateos <csander@purestorage.com>
    io_uring: only call io_should_terminate_tw() once for ctx

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening options file

Guangshuo Li <lgs201920130244@gmail.com>
    i2c: qcom-cci: fix autosuspend cleanup

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Provide rt_mutex_.*_schedule() equivalents for futex scheduling

Li Chen <me@linux.beauty>
    nvdimm: pmem: keep PREFLUSH before data writes

Jens Axboe <axboe@kernel.dk>
    io_uring/waitid: have io_waitid_complete() remove wait queue entry

Steven Rostedt <rostedt@goodmis.org>
    tracing: Make printk_trace global for tracing system

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    i2c: qcom-cci: Remove overcautious disable_irq() calls

Peter Zijlstra <peterz@infradead.org>
    futex: Optimize futex hash bucket access patterns

Jan Kara <jack@suse.cz>
    udf: Fix data loss when converting inline inodes to out of line

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix BTF kflag check for anonymous struct member access

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Allow splice reads on static buffers

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate max level for set feature

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    platform/x86: int1092: Fix potential memory leak in sar_probe()

Yilin Zhang <yilinzhang@moonshot.ai>
    perf: Fix use-after-free when perf mmap() revival races with the last munmap()

Farhan Ali <alifm@linux.ibm.com>
    PCI: Allow per function PCI slots to fix slot reset on s390

Chao Shi <coshi036@gmail.com>
    nvme: skip the zoned limits update if the zone info query failed

Glenn Judd <gmj@meta.com>
    net/mlx5e: do not HW-GRO coalesce small frames

Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
    mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses

Baineng Shou <shoubaineng@gmail.com>
    misc: fastrpc: don't publish fd before copy_to_user() succeeds

Moksh Panicker <mokshpanicker.7@gmail.com>
    iio: light: apds9306: fix PM reference leak in apds9306_read_data()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix recursive locking during device registration

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Fix the MIXER enable default value

Baul Lee <baul.lee@xbow.com>
    ALSA: FCP: do not copy out an uninitialised init response

Li Chen <me@linux.beauty>
    nvdimm: preserve flush callback -ENOMEM

Jens Axboe <axboe@kernel.dk>
    io_uring: unify task_work cancelation checks

Steven Rostedt <rostedt@goodmis.org>
    tracing: Clean up use of trace_create_maxlat_file()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    i2c: qcom-cci: Do not check return value of cci_init()

Marco Elver <elver@google.com>
    compiler_types: Move lock checking attributes to compiler-context-analysis.h

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy

Jan Kara <jack@suse.cz>
    udf: Move udf_map_block() up

Martin Kaiser <martin@kaiser.cx>
    tracing/probes: ignore id update from btf_type_skip_modifiers

Vivek BalachandharTN <vivek.balachandhar@gmail.com>
    staging: rtl8723bs: fix spacing around operators

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Show persistent buffer dropped events in trace_pipe file

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Wrapper macros for ACQUIRE()/ACQUIRE_ERR()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Check for admin capability for write commands

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: intel_sar: Check ACPI_HANDLE() against NULL

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix deadlock in perf_mmap() failure path

Farhan Ali <alifm@linux.ibm.com>
    PCI: Introduce PCI_SLOT_PLACEHOLDER constant for slot_nr placeholder value

Caleb Sander Mateos <csander@purestorage.com>
    nvme: fold nvme_config_discard() into nvme_update_disk_info()

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Always calculate page size

Andrea Scian <andrea.scian@dave.eu>
    mtd: rawnand: pl353: Add message about ECC mode

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix device_register() error path

Baineng Shou <shoubaineng@gmail.com>
    dma-buf: dma-heap: don't publish fd before copy_to_user() succeeds

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tegra210_mixer: sort the register default table

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Relax __free() variable declarations

Sven Eckelmann <sven@narfation.org>
    batman-adv: fix TX priority extraction for BATADV_FORW_MCAST

SJ Park <sj@kernel.org>
    mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: avoid CRC corruption due to parallel claim add

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: atomically update mac addresses

Akhmed Zhitaev <zhitaevakh@gmail.com>
    drm/amd/display: Scale custom brightness curve from full range

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix backlight max_brightness to match exported range

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: xsk: Fix unlocked writing to ICOSQ


-------------

Diffstat:

 .../ABI/testing/configfs-usb-gadget-uac1_legacy    |    3 -
 Documentation/admin-guide/device-mapper/dm-ima.rst |    7 +-
 .../admin-guide/device-mapper/dm-integrity.rst     |   13 +
 Documentation/admin-guide/pm/amd-pstate.rst        |   34 +-
 .../devicetree/bindings/media/nxp,imx8-isi.yaml    |   11 +-
 Documentation/hwmon/cros_ec_hwmon.rst              |   26 +-
 Documentation/hwmon/emc1403.rst                    |    8 +-
 Documentation/hwmon/hwmon-kernel-api.rst           |    7 +-
 Documentation/leds/leds-st1202.rst                 |    2 +-
 Documentation/netlink/specs/devlink.yaml           |    2 +
 .../networking/devlink/devlink-eswitch-attr.rst    |   13 +
 Documentation/usb/gadget-testing.rst               |    3 -
 MAINTAINERS                                        |    3 +
 Makefile                                           |    6 +-
 arch/Kconfig                                       |    3 +
 arch/arm/boot/dts/allwinner/sun4i-a10.dtsi         |    2 +-
 arch/arm/boot/dts/marvell/armada-388-helios4.dts   |   13 +
 arch/arm/kernel/hw_breakpoint.c                    |   11 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |   12 +-
 arch/arm/mach-exynos/suspend.c                     |   48 +-
 arch/arm/mach-imx/src.c                            |    3 +
 arch/arm/mach-lpc32xx/common.c                     |    5 +-
 arch/arm/mach-lpc32xx/common.h                     |    2 +
 arch/arm/mach-lpc32xx/phy3250.c                    |    2 +
 arch/arm/mach-lpc32xx/pm.c                         |    5 +-
 arch/arm/mach-pxa/generic.h                        |    6 +-
 arch/arm/mach-pxa/irq.c                            |   10 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |   10 +-
 arch/arm/mach-pxa/mfp-pxa3xx.c                     |   10 +-
 arch/arm/mach-pxa/pxa25x.c                         |    4 +-
 arch/arm/mach-pxa/pxa27x.c                         |    4 +-
 arch/arm/mach-pxa/pxa3xx.c                         |    4 +-
 arch/arm/mach-pxa/smemc.c                          |   12 +-
 arch/arm/mach-s3c/irq-pm-s3c64xx.c                 |   12 +-
 arch/arm/mach-s5pv210/pm.c                         |   10 +-
 arch/arm/mach-versatile/integrator_ap.c            |   12 +-
 arch/arm/mm/cache-b15-rac.c                        |   12 +-
 arch/arm/mm/fault.c                                |   16 +-
 arch/arm64/Kconfig                                 |    2 +
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |    4 +-
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts     |    4 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |    3 +-
 arch/arm64/boot/dts/freescale/imx8-ss-audio.dtsi   |    8 +-
 .../boot/dts/freescale/imx93-kontron-osm-s.dtsi    |    4 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |    3 +-
 arch/arm64/boot/dts/qcom/hamoa.dtsi                |    4 +-
 arch/arm64/boot/dts/qcom/ipq5018.dtsi              |    5 +-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |  977 ++++-----
 .../boot/dts/qcom/msm8976-longcheer-l9360.dts      |    4 +-
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts |    2 +-
 .../boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi |    4 -
 arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts  |    5 -
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |   24 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi              |    1 +
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |   16 +-
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts       |   18 +-
 arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi       |    4 +-
 arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts     |    4 +-
 arch/arm64/boot/dts/qcom/sar2130p.dtsi             |    8 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |    5 +
 arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi     |    5 +
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |    8 +-
 .../arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts |   57 +-
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts        |   56 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   16 +-
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts          |    4 +-
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts     |    2 +-
 .../boot/dts/qcom/sc8280xp-microsoft-arcata.dts    |    4 +-
 .../boot/dts/qcom/sc8280xp-microsoft-blackrock.dts |   19 +-
 arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts |    2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   64 +-
 arch/arm64/boot/dts/qcom/sm6150.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |    6 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |    8 +-
 .../boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi  |    2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   48 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |    5 +-
 .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |    3 +-
 .../boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi  |    2 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |    4 +-
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi     |    4 +-
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi           |    2 +-
 arch/arm64/include/asm/kvm_host.h                  |    3 -
 arch/arm64/include/asm/processor.h                 |    2 +-
 arch/arm64/include/asm/ptdump.h                    |    2 +
 arch/arm64/include/asm/rsi_cmds.h                  |   27 +-
 arch/arm64/kernel/hibernate.c                      |   16 +-
 arch/arm64/kernel/ptrace.c                         |    4 +-
 arch/arm64/kernel/smp.c                            |    2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |    3 +-
 arch/arm64/kvm/nested.c                            |   64 +-
 arch/arm64/lib/Makefile                            |    4 +
 arch/arm64/mm/ptdump.c                             |   14 +-
 arch/arm64/net/bpf_jit_comp.c                      |   28 +-
 arch/csky/kernel/entry.S                           |    6 +-
 arch/loongarch/kernel/smp.c                        |   12 +-
 arch/m68k/emu/nfcon.c                              |    2 +-
 arch/m68k/kernel/traps.c                           |    4 +-
 arch/mips/alchemy/common/dbdma.c                   |   12 +-
 arch/mips/alchemy/common/irq.c                     |   24 +-
 arch/mips/alchemy/common/usb.c                     |   12 +-
 arch/mips/kernel/ptrace.c                          |    6 +-
 arch/mips/pci/pci-alchemy.c                        |   16 +-
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/configs/85xx-hw.config                |    1 +
 arch/powerpc/kernel/ima_arch.c                     |    5 -
 arch/powerpc/kernel/irq.c                          |   16 +-
 arch/powerpc/kernel/secure_boot.c                  |    6 +
 arch/powerpc/kernel/smp.c                          |    3 +
 arch/powerpc/kexec/crash.c                         |    2 +-
 arch/powerpc/platforms/44x/gpio.c                  |    1 +
 arch/powerpc/platforms/cell/spu_base.c             |   10 +-
 arch/powerpc/platforms/powermac/pic.c              |   12 +-
 arch/powerpc/sysdev/cpm_common.c                   |   13 +
 arch/powerpc/sysdev/fsl_lbc.c                      |   12 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   12 +-
 arch/powerpc/sysdev/ipic.c                         |   12 +-
 arch/powerpc/sysdev/mpic.c                         |   14 +-
 arch/powerpc/sysdev/mpic_timer.c                   |   10 +-
 arch/riscv/boot/dts/sophgo/cv180x.dtsi             |    2 +-
 arch/riscv/boot/dts/spacemit/Makefile              |    2 +
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts    |    4 +-
 arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts  |    4 +-
 arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts     |   79 +
 arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts   |   90 +
 arch/riscv/boot/dts/spacemit/k1-pinctrl.dtsi       |   24 +-
 arch/riscv/kernel/cpufeature.c                     |    3 +-
 arch/riscv/kernel/machine_kexec_file.c             |   14 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   19 +-
 arch/riscv/net/bpf_jit_core.c                      |    1 +
 arch/s390/Kconfig                                  |   22 +-
 arch/s390/Makefile                                 |   11 +-
 arch/s390/boot/Makefile                            |    1 +
 arch/s390/boot/boot.h                              |    4 +
 arch/s390/boot/ipl_data.c                          |    3 +-
 arch/s390/boot/ipl_parm.c                          |    6 +
 arch/s390/boot/stackprotector.c                    |    6 +
 arch/s390/boot/startup.c                           |    8 +
 arch/s390/configs/compat.config                    |    3 -
 arch/s390/hypfs/hypfs_sprp.c                       |    6 +-
 arch/s390/include/asm/arch-stackprotector.h        |   25 +
 arch/s390/include/asm/compat.h                     |  140 --
 arch/s390/include/asm/elf.h                        |   46 +-
 arch/s390/include/asm/ftrace.h                     |   19 +-
 arch/s390/include/asm/irqflags.h                   |   20 +-
 arch/s390/include/asm/lowcore.h                    |    3 +-
 arch/s390/include/asm/processor.h                  |   12 +-
 arch/s390/include/asm/ptrace.h                     |    2 +-
 arch/s390/include/asm/seccomp.h                    |    5 -
 arch/s390/include/asm/stackprotector.h             |   16 +
 arch/s390/include/asm/syscall.h                    |   19 +-
 arch/s390/include/asm/syscall_wrapper.h            |   95 +-
 arch/s390/include/asm/thread_info.h                |    2 -
 arch/s390/include/asm/unistd.h                     |    5 -
 arch/s390/include/asm/vdso-symbols.h               |   12 +-
 arch/s390/kernel/Makefile                          |   10 +-
 arch/s390/kernel/asm-offsets.c                     |    4 +
 arch/s390/kernel/audit.c                           |   16 -
 arch/s390/kernel/audit.h                           |   16 -
 arch/s390/kernel/compat_audit.c                    |   48 -
 arch/s390/kernel/compat_linux.c                    |  289 ---
 arch/s390/kernel/compat_linux.h                    |  101 -
 arch/s390/kernel/compat_ptrace.h                   |   64 -
 arch/s390/kernel/compat_signal.c                   |  420 ----
 arch/s390/kernel/debug.c                           |   10 +-
 arch/s390/kernel/entry.S                           |   17 +-
 arch/s390/kernel/ima_arch.c                        |   14 -
 arch/s390/kernel/ipl.c                             |    8 +-
 arch/s390/kernel/irqflags.c                        |   28 +
 arch/s390/kernel/module.c                          |    9 +
 arch/s390/kernel/perf_cpum_cf.c                    |    1 -
 arch/s390/kernel/perf_event.c                      |    1 -
 arch/s390/kernel/perf_regs.c                       |    3 -
 arch/s390/kernel/process.c                         |    9 +-
 arch/s390/kernel/ptrace.c                          |  524 -----
 arch/s390/kernel/setup.c                           |    1 -
 arch/s390/kernel/signal.c                          |   27 +-
 arch/s390/kernel/smp.c                             |    3 +
 arch/s390/kernel/stackprotector.c                  |  156 ++
 arch/s390/kernel/stacktrace.c                      |    3 -
 arch/s390/kernel/uprobes.c                         |    6 +-
 arch/s390/kernel/vdso.c                            |   36 +-
 arch/s390/kernel/{vdso32 => vdso}/.gitignore       |    2 +-
 arch/s390/kernel/vdso/Makefile                     |   81 +
 .../kernel/{vdso64 => vdso}/gen_vdso_offsets.sh    |    2 +-
 arch/s390/kernel/{vdso64 => vdso}/getcpu.c         |    0
 arch/s390/kernel/{vdso32 => vdso}/note.S           |    0
 arch/s390/kernel/{vdso64 => vdso}/vdso.h           |    6 +-
 .../{vdso64/vdso64.lds.S => vdso/vdso.lds.S}       |    0
 .../vdso64_generic.c => vdso/vdso_generic.c}       |    0
 .../kernel/{vdso64 => vdso}/vdso_user_wrapper.S    |    0
 .../vdso64_wrapper.S => vdso/vdso_wrapper.S}       |    8 +-
 .../kernel/{vdso64 => vdso}/vgetrandom-chacha.S    |    0
 arch/s390/kernel/{vdso64 => vdso}/vgetrandom.c     |    0
 arch/s390/kernel/vdso32/Makefile                   |   64 -
 arch/s390/kernel/vdso32/gen_vdso_offsets.sh        |   15 -
 arch/s390/kernel/vdso32/vdso32.lds.S               |  140 --
 arch/s390/kernel/vdso32/vdso32_wrapper.S           |   15 -
 arch/s390/kernel/vdso32/vdso_user_wrapper.S        |   22 -
 arch/s390/kernel/vdso64/.gitignore                 |    2 -
 arch/s390/kernel/vdso64/Makefile                   |   79 -
 arch/s390/kernel/vdso64/note.S                     |   13 -
 arch/s390/kernel/vmlinux.lds.S                     |   13 +
 arch/s390/kvm/kvm-s390.c                           |    4 +-
 arch/s390/mm/fault.c                               |    1 -
 arch/s390/mm/mmap.c                                |    1 -
 arch/s390/pci/pci_clp.c                            |    4 +-
 arch/sh/mm/pmb.c                                   |   10 +-
 arch/x86/entry/entry_64_fred.S                     |    2 +
 arch/x86/events/amd/ibs.c                          |   12 +-
 arch/x86/events/amd/uncore.c                       |   31 +
 arch/x86/events/intel/core.c                       |   10 +-
 arch/x86/events/intel/pt.c                         |   96 +-
 arch/x86/events/intel/uncore.c                     |    2 -
 arch/x86/events/perf_event.h                       |    2 +-
 arch/x86/hyperv/hv_init.c                          |   12 +-
 arch/x86/include/asm/efi.h                         |    4 +-
 arch/x86/include/asm/linkage.h                     |    2 +-
 arch/x86/include/asm/pkeys.h                       |    3 +
 arch/x86/kernel/amd_gart_64.c                      |   10 +-
 arch/x86/kernel/apic/apic.c                        |   12 +-
 arch/x86/kernel/apic/io_apic.c                     |   17 +-
 arch/x86/kernel/cpu/aperfmperf.c                   |   20 +-
 arch/x86/kernel/cpu/common.c                       |   25 +-
 arch/x86/kernel/cpu/cpu.h                          |    9 -
 arch/x86/kernel/cpu/intel_epb.c                    |   16 +-
 arch/x86/kernel/cpu/mce/core.c                     |   14 +-
 arch/x86/kernel/cpu/microcode/core.c               |   15 +-
 arch/x86/kernel/cpu/mtrr/legacy.c                  |   12 +-
 arch/x86/kernel/cpu/tsx.c                          |    9 +-
 arch/x86/kernel/cpu/umwait.c                       |   10 +-
 arch/x86/kernel/i8237.c                            |   10 +-
 arch/x86/kernel/i8259.c                            |   14 +-
 arch/x86/kernel/kvm.c                              |   12 +-
 arch/x86/kvm/Makefile                              |    4 +-
 arch/x86/kvm/regs.c                                |  787 +++++++
 arch/x86/kvm/x86.c                                 |  793 +------
 arch/x86/kvm/x86.h                                 |   16 +
 arch/x86/mm/pat/set_memory.c                       |    8 +-
 arch/x86/net/bpf_jit_comp.c                        |   14 +-
 arch/x86/platform/efi/efi.c                        |    2 +-
 block/bio.c                                        |   10 +
 block/blk-cgroup.c                                 |    5 +
 block/blk-core.c                                   |   13 +-
 block/blk-crypto-fallback.c                        |  407 ++--
 block/blk-crypto-internal.h                        |   19 +-
 block/blk-crypto.c                                 |   52 +-
 block/blk-iocost.c                                 |    2 +-
 block/blk-map.c                                    |    3 +
 block/blk-merge.c                                  |   48 +-
 block/blk-mq-dma.c                                 |    4 +-
 block/blk-mq.c                                     |   12 +-
 block/blk-stat.c                                   |    2 +-
 block/fops.c                                       |    9 +-
 block/kyber-iosched.c                              |    2 +-
 crypto/acompress.c                                 |   16 +-
 crypto/lskcipher.c                                 |    1 -
 drivers/accel/amdxdna/amdxdna_gem.c                |    4 +
 drivers/accessibility/speakup/keyhelp.c            |   17 +-
 drivers/accessibility/speakup/kobjects.c           |    6 +-
 drivers/acpi/battery.c                             |   44 +-
 drivers/acpi/ec.c                                  |   40 +-
 drivers/acpi/pci_link.c                            |   10 +-
 drivers/acpi/pci_root.c                            |    3 +-
 drivers/acpi/processor_core.c                      |   31 +-
 drivers/acpi/processor_driver.c                    |   16 +-
 drivers/acpi/processor_idle.c                      |  116 +-
 drivers/acpi/riscv/irq.c                           |   33 +-
 drivers/acpi/scan.c                                |   13 +-
 drivers/acpi/sleep.c                               |   12 +-
 drivers/acpi/video_detect.c                        |    4 +-
 drivers/base/cacheinfo.c                           |    9 +-
 drivers/base/firmware_loader/fallback.c            |   10 +
 drivers/base/firmware_loader/main.c                |   12 +-
 drivers/base/memory.c                              |    4 +-
 drivers/base/soc.c                                 |   15 +-
 drivers/base/swnode.c                              |    2 +-
 drivers/base/syscore.c                             |   82 +-
 drivers/block/mtip32xx/mtip32xx.c                  |    7 +
 drivers/block/mtip32xx/mtip32xx.h                  |    2 +
 drivers/block/null_blk/main.c                      |   78 +-
 drivers/block/ublk_drv.c                           |   20 +-
 drivers/bluetooth/btintel.c                        |    2 +-
 drivers/bluetooth/btmtk.c                          |  104 +-
 drivers/bluetooth/btmtk.h                          |    8 +-
 drivers/bluetooth/btmtksdio.c                      |   84 +-
 drivers/bluetooth/btnxpuart.c                      |   15 +-
 drivers/bluetooth/btqca.c                          |    3 +-
 drivers/bluetooth/btusb.c                          |   68 +-
 drivers/bluetooth/virtio_bt.c                      |    8 +-
 drivers/bus/mhi/ep/main.c                          |   15 +-
 drivers/bus/mhi/host/init.c                        |    4 +-
 drivers/bus/mhi/host/main.c                        |    6 +
 drivers/bus/mvebu-mbus.c                           |   16 +-
 drivers/bus/qcom-ebi2.c                            |   51 +-
 drivers/bus/ti-sysc.c                              |   12 +-
 drivers/char/hw_random/core.c                      |    4 +-
 drivers/char/hw_random/imx-rngc.c                  |    4 +-
 drivers/char/hw_random/ks-sa-rng.c                 |    9 +-
 drivers/char/ppdev.c                               |   10 +-
 drivers/char/tpm/st33zp24/st33zp24.c               |    8 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    5 +-
 drivers/clk/at91/pmc.c                             |   12 +-
 drivers/clk/clk-devres.c                           |   12 +-
 drivers/clk/clk-moxart.c                           |   14 -
 drivers/clk/clk-palmas.c                           |   14 +-
 drivers/clk/clk-versaclock7.c                      |    2 +-
 drivers/clk/hisilicon/reset.c                      |    2 +-
 drivers/clk/imx/clk-scu.c                          |    1 -
 drivers/clk/imx/clk-vf610.c                        |   12 +-
 drivers/clk/ingenic/jz4725b-cgu.c                  |    2 +-
 drivers/clk/ingenic/jz4740-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4755-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4760-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4770-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4780-cgu.c                   |    2 +-
 drivers/clk/ingenic/pm.c                           |   14 +-
 drivers/clk/ingenic/pm.h                           |    2 +-
 drivers/clk/ingenic/tcu.c                          |   12 +-
 drivers/clk/ingenic/x1000-cgu.c                    |    2 +-
 drivers/clk/ingenic/x1830-cgu.c                    |    2 +-
 drivers/clk/mediatek/clk-mt2701.c                  |    2 +-
 drivers/clk/mediatek/clk-mt2712-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt6735-apmixedsys.c       |    9 +-
 drivers/clk/mediatek/clk-mt6765.c                  |    2 +-
 drivers/clk/mediatek/clk-mt6779.c                  |    2 +-
 drivers/clk/mediatek/clk-mt6795-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt6797.c                  |    2 +-
 drivers/clk/mediatek/clk-mt7622-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt7629.c                  |    2 +-
 drivers/clk/mediatek/clk-mt7981-apmixed.c          |    2 +-
 drivers/clk/mediatek/clk-mt7986-apmixed.c          |    2 +-
 drivers/clk/mediatek/clk-mt7988-apmixed.c          |    2 +-
 drivers/clk/mediatek/clk-mt8135-apmixedsys.c       |    3 +-
 drivers/clk/mediatek/clk-mt8135.c                  |    5 +-
 drivers/clk/mediatek/clk-mt8167-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt8173-apmixedsys.c       |   14 +-
 drivers/clk/mediatek/clk-mt8183-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt8186-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt8188-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt8192-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt8195-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt8195-apusys_pll.c       |    3 +-
 drivers/clk/mediatek/clk-mt8196-apmixedsys.c       |    3 +-
 drivers/clk/mediatek/clk-mt8196-mcu.c              |    2 +-
 drivers/clk/mediatek/clk-mt8196-mfg.c              |    2 +-
 drivers/clk/mediatek/clk-mt8196-vlpckgen.c         |    2 +-
 drivers/clk/mediatek/clk-mt8365-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-mt8516-apmixedsys.c       |    2 +-
 drivers/clk/mediatek/clk-pll.c                     |   16 +-
 drivers/clk/mediatek/clk-pll.h                     |   14 +-
 drivers/clk/mediatek/clk-pllfh.c                   |  111 +-
 drivers/clk/mediatek/clk-pllfh.h                   |    2 +-
 drivers/clk/mvebu/common.c                         |   12 +-
 drivers/clk/nuvoton/clk-ma35d1-pll.c               |   42 +-
 drivers/clk/qcom/camcc-sc8280xp.c                  |   19 -
 drivers/clk/qcom/common.c                          |    4 +-
 drivers/clk/qcom/gcc-glymur.c                      |   33 +-
 drivers/clk/qcom/gcc-qcm2290.c                     |   18 +-
 drivers/clk/qcom/gcc-qcs8300.c                     |    8 +-
 drivers/clk/qcom/gcc-sm6115.c                      |    6 +-
 drivers/clk/qcom/gdsc.c                            |   25 +-
 drivers/clk/qcom/gpucc-qcm2290.c                   |    2 +-
 drivers/clk/rockchip/clk-pll.c                     |    9 +-
 drivers/clk/rockchip/clk-rk3288.c                  |   12 +-
 drivers/clk/rockchip/clk-rk3576.c                  |   11 +-
 drivers/clk/samsung/clk-s5pv210-audss.c            |   12 +-
 drivers/clk/samsung/clk.c                          |   12 +-
 drivers/clk/stm32/clk-stm32mp21.c                  |    1 +
 drivers/clk/stm32/clk-stm32mp25.c                  |    1 +
 drivers/clk/tegra/clk-tegra124-emc.c               |    1 +
 drivers/clk/tegra/clk-tegra210.c                   |   12 +-
 drivers/clk/ti/adpll.c                             |    4 +-
 drivers/clk/ti/divider.c                           |    2 +-
 drivers/clk/ti/mux.c                               |   22 +-
 drivers/clk/visconti/clkc.c                        |    2 +-
 drivers/clk/x86/clk-pmc-atom.c                     |    3 +
 drivers/clocksource/clps711x-timer.c               |    2 +-
 drivers/clocksource/timer-armada-370-xp.c          |   30 +-
 drivers/cpufreq/Kconfig.x86                        |   14 +
 drivers/cpufreq/amd-pstate-ut.c                    |    5 +
 drivers/cpufreq/amd-pstate.c                       |  463 ++++-
 drivers/cpufreq/amd-pstate.h                       |   17 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |    6 +-
 drivers/cpufreq/intel_pstate.c                     |   19 +-
 drivers/cpufreq/spear-cpufreq.c                    |    4 +-
 drivers/cpuidle/cpuidle-psci.c                     |   12 +-
 drivers/crypto/atmel-ecc.c                         |    3 +
 drivers/crypto/atmel-sha204a.c                     |    6 +-
 drivers/crypto/ccp/sev-dev.c                       |   17 +-
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
 drivers/crypto/xilinx/xilinx-trng.c                |   32 +-
 drivers/cxl/core/features.c                        |   12 +-
 drivers/cxl/core/mbox.c                            |   11 +-
 drivers/cxl/core/memdev.c                          |    2 +-
 drivers/cxl/core/port.c                            |    4 +-
 drivers/cxl/core/region.c                          |    7 +-
 drivers/cxl/pci.c                                  |   13 +-
 drivers/dax/super.c                                |   12 +-
 drivers/dma-buf/dma-heap.c                         |   80 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  104 +-
 drivers/dma/hisi_dma.c                             |    2 +-
 drivers/dma/mediatek/mtk-uart-apdma.c              |    2 +-
 drivers/dma/qcom/bam_dma.c                         |    1 +
 drivers/dma/xilinx/xilinx_dma.c                    |   12 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |    4 +-
 drivers/firewire/.kunitconfig                      |    1 +
 drivers/firewire/Kconfig                           |   15 +
 drivers/firewire/core-topology.c                   |   62 +-
 drivers/firewire/node-tree-test.c                  |  607 ++++++
 drivers/firmware/arm_scmi/bus.c                    |   89 +-
 drivers/firmware/arm_scmi/common.h                 |    2 +
 drivers/firmware/arm_scmi/driver.c                 |   77 +-
 drivers/firmware/arm_scmi/notify.c                 |   21 +
 drivers/firmware/arm_scmi/notify.h                 |    1 +
 drivers/firmware/arm_scmi/transports/mailbox.c     |   26 +-
 drivers/firmware/arm_scmi/transports/smc.c         |   15 +-
 drivers/firmware/google/coreboot_table.c           |   26 +-
 drivers/firmware/qcom/Makefile                     |    1 +
 drivers/firmware/qcom/qcom_scm-smc.c               |   12 +-
 drivers/firmware/qcom/qcom_scm.c                   |  194 +-
 drivers/firmware/qcom/qcom_scm.h                   |    3 +-
 drivers/firmware/qcom/qcom_scm_trace.h             |  143 ++
 drivers/firmware/qcom/qcom_tzmem.c                 |   13 +-
 drivers/gpio/gpio-mxc.c                            |   12 +-
 drivers/gpio/gpio-pxa.c                            |   12 +-
 drivers/gpio/gpio-sa1100.c                         |   12 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |   74 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   28 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    7 +
 .../gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c |    3 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   24 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |   35 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |    2 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |    2 +-
 drivers/gpu/drm/bridge/display-connector.c         |   36 +
 drivers/gpu/drm/bridge/synopsys/dw-dp.c            |   14 +-
 drivers/gpu/drm/bridge/tc358767.c                  |    2 +-
 drivers/gpu/drm/drm_dumb_buffers.c                 |    1 -
 drivers/gpu/drm/lima/lima_device.c                 |   12 +-
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |    2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  107 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   20 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |    5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h        |   68 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |    4 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |    3 +-
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
 drivers/gpu/drm/msm/msm_gpu.c                      |    6 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c               |    7 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h               |    1 +
 drivers/gpu/drm/msm/registers/adreno/a6xx_gmu.xml  |  248 +--
 drivers/gpu/drm/mxsfb/lcdif_kms.c                  |   15 +-
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |    7 +-
 drivers/gpu/drm/omapdrm/dss/dsi.h                  |    2 -
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c      |   10 +-
 drivers/gpu/drm/panthor/panthor_drv.c              |    2 +-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   22 +-
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c          |   45 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |    5 +-
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c       |   21 +-
 drivers/gpu/drm/sun4i/sun4i_crtc.c                 |    2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |    2 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |   22 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |    2 +
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |    2 +-
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c            |   18 +-
 drivers/gpu/drm/tve200/tve200_drv.c                |    1 +
 drivers/gpu/drm/v3d/v3d_sched.c                    |   60 +-
 drivers/gpu/drm/xe/tests/xe_migrate.c              |    3 +-
 drivers/gpu/drm/xe/xe_gt_idle.c                    |    3 +-
 drivers/gpu/host1x/debug.c                         |    4 +-
 drivers/gpu/host1x/hw/channel_hw.c                 |    5 +-
 drivers/hid/hid-core.c                             |    9 +
 drivers/hid/hid-haptic.c                           |    2 +-
 drivers/hid/hid-lg4ff.c                            |    8 +
 drivers/hid/hid-multitouch.c                       |    2 +-
 drivers/hid/hid-nintendo.c                         |    1 -
 drivers/hid/hid-roccat-kone.c                      |    8 +-
 drivers/hid/hid-steam.c                            |  516 +++--
 drivers/hid/i2c-hid/Makefile                       |    2 +-
 drivers/hid/i2c-hid/i2c-hid-acpi-prp0001.c         |  104 +
 drivers/hid/i2c-hid/i2c-hid-acpi.c                 |   54 +-
 drivers/hid/i2c-hid/i2c-hid-acpi.h                 |   33 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |    2 +-
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c            |    4 +-
 drivers/hv/vmbus_drv.c                             |   29 +-
 drivers/hwmon/coretemp.c                           |    1 +
 drivers/hwmon/cros_ec_hwmon.c                      |  121 +-
 drivers/hwmon/emc1403.c                            |   73 +-
 drivers/hwspinlock/hwspinlock_core.c               |    2 +-
 drivers/hwtracing/coresight/coresight-etm4x-cfg.c  |    2 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  111 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |    6 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   63 +-
 drivers/i2c/busses/i2c-ocores.c                    |    6 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |   24 +-
 drivers/i3c/master.c                               |   63 +-
 drivers/i3c/master/adi-i3c-master.c                |    1 +
 drivers/i3c/master/dw-i3c-master.c                 |   10 +-
 drivers/i3c/master/renesas-i3c.c                   |   28 +-
 drivers/idle/intel_idle.c                          |  194 +-
 drivers/iio/accel/dmard09.c                        |    7 +
 drivers/iio/light/apds9306.c                       |    8 +-
 drivers/iio/light/gp2ap002.c                       |   14 +-
 drivers/iio/light/isl29028.c                       |    2 +-
 drivers/iio/light/opt4060.c                        |    4 +-
 drivers/iio/light/tsl2583.c                        |    2 +-
 drivers/iio/light/tsl2772.c                        |    2 +-
 drivers/iio/orientation/hid-sensor-rotation.c      |   20 +-
 drivers/infiniband/core/cma.c                      |    6 +-
 drivers/infiniband/core/counters.c                 |    5 +-
 drivers/infiniband/core/cq.c                       |    2 +-
 drivers/infiniband/core/device.c                   |    2 +
 drivers/infiniband/core/nldev.c                    |   20 +-
 drivers/infiniband/core/restrack.c                 |  174 +-
 drivers/infiniband/core/restrack.h                 |    4 +
 drivers/infiniband/core/ucma.c                     |    2 +-
 drivers/infiniband/core/uverbs_cmd.c               |   10 +-
 drivers/infiniband/core/uverbs_std_types_device.c  |   42 +
 drivers/infiniband/core/uverbs_std_types_dmah.c    |    7 +-
 drivers/infiniband/core/verbs.c                    |   83 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    6 +-
 drivers/infiniband/hw/cxgb4/device.c               |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |    4 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |   15 +-
 drivers/infiniband/hw/erdma/Kconfig                |    2 +-
 drivers/infiniband/hw/erdma/erdma_cm.c             |    6 +-
 drivers/infiniband/hw/erdma/erdma_eq.c             |   10 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   39 +-
 drivers/infiniband/hw/erdma/erdma_verbs.h          |   40 +-
 drivers/infiniband/hw/hfi1/chip.c                  |    4 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |    2 -
 drivers/infiniband/hw/hfi1/init.c                  |   44 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   13 +-
 drivers/infiniband/hw/irdma/utils.c                |    6 +
 drivers/infiniband/hw/irdma/verbs.c                |  116 +-
 drivers/infiniband/hw/irdma/verbs.h                |    3 +
 drivers/infiniband/hw/mana/qp.c                    |   10 +-
 drivers/infiniband/hw/mlx5/cong.c                  |    8 +-
 drivers/infiniband/hw/mlx5/main.c                  |  127 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    2 +
 drivers/infiniband/hw/mlx5/qp.c                    |   25 +-
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
 drivers/iommu/amd/init.c                           |   58 +-
 drivers/iommu/amd/ppr.c                            |    2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |    9 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |  119 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |    6 +-
 drivers/iommu/dma-iommu.c                          |   26 +-
 drivers/iommu/intel/iommu.c                        |   31 +-
 drivers/iommu/intel/iommu.h                        |    2 +-
 drivers/iommu/intel/pasid.c                        |    9 +-
 drivers/iommu/iommufd/device.c                     |   13 +-
 drivers/iommu/iommufd/iommufd_private.h            |    9 +-
 drivers/iommu/iommufd/main.c                       |   20 +
 drivers/iommu/iommufd/selftest.c                   |    5 +-
 drivers/iommu/msm_iommu.c                          |    2 +-
 drivers/iommu/mtk_iommu_v1.c                       |    2 +-
 drivers/ipack/devices/ipoctal.c                    |   56 +-
 drivers/irqchip/exynos-combiner.c                  |   14 +-
 drivers/irqchip/irq-armada-370-xp.c                |   12 +-
 drivers/irqchip/irq-bcm7038-l1.c                   |   12 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   35 +-
 drivers/irqchip/irq-gic-v5-irs.c                   |    2 +-
 drivers/irqchip/irq-gic-v5.c                       |   11 +-
 drivers/irqchip/irq-i8259.c                        |   12 +-
 drivers/irqchip/irq-imx-gpcv2.c                    |   16 +-
 drivers/irqchip/irq-loongson-eiointc.c             |   12 +-
 drivers/irqchip/irq-loongson-htpic.c               |   10 +-
 drivers/irqchip/irq-loongson-htvec.c               |   12 +-
 drivers/irqchip/irq-loongson-pch-lpc.c             |   12 +-
 drivers/irqchip/irq-loongson-pch-pic.c             |   12 +-
 drivers/irqchip/irq-mchp-eic.c                     |   12 +-
 drivers/irqchip/irq-mst-intc.c                     |   12 +-
 drivers/irqchip/irq-mtk-cirq.c                     |   12 +-
 drivers/irqchip/irq-realtek-rtl.c                  |  189 +-
 drivers/irqchip/irq-renesas-irqc.c                 |    1 +
 drivers/irqchip/irq-renesas-rzg2l.c                |   16 +-
 drivers/irqchip/irq-sa11x0.c                       |   12 +-
 drivers/irqchip/irq-sifive-plic.c                  |   12 +-
 drivers/irqchip/irq-sun6i-r.c                      |   18 +-
 drivers/irqchip/irq-tegra.c                        |   12 +-
 drivers/irqchip/irq-vic.c                          |   12 +-
 drivers/leds/leds-gpio.c                           |   53 +-
 drivers/leds/leds-pca9532.c                        |   18 +-
 drivers/leds/leds-st1202.c                         |   96 +-
 drivers/leds/trigger/ledtrig-cpu.c                 |   14 +-
 drivers/macintosh/via-pmu.c                        |   12 +-
 drivers/mailbox/pcc.c                              |   41 +-
 drivers/mailbox/qcom-cpucp-mbox.c                  |   25 +-
 drivers/mailbox/riscv-sbi-mpxy-mbox.c              |   12 +-
 drivers/mailbox/rockchip-mailbox.c                 |   17 +-
 drivers/md/dm-integrity.c                          |  139 +-
 drivers/md/dm-pcache/cache.c                       |    7 +
 drivers/md/dm-pcache/cache.h                       |    3 +
 drivers/md/dm-pcache/cache_gc.c                    |    5 +
 drivers/md/dm-pcache/cache_key.c                   |   83 +
 drivers/md/dm-pcache/cache_writeback.c             |    8 +
 drivers/md/md-bitmap.c                             |    5 +-
 drivers/md/md-bitmap.h                             |    1 +
 drivers/md/md-llbitmap.c                           |   20 +-
 drivers/md/md.c                                    |  109 +-
 drivers/md/md.h                                    |    1 -
 drivers/md/raid1.c                                 |    2 -
 drivers/md/raid10.c                                |   14 +-
 drivers/md/raid5-ppl.c                             |    4 +-
 drivers/md/raid5.c                                 |   87 +-
 drivers/media/cec/core/cec-pin.c                   |    8 +-
 drivers/media/i2c/rdacm21.c                        |    5 +-
 drivers/media/pci/intel/ipu6/ipu6.c                |   10 +-
 drivers/media/platform/broadcom/bcm2835-unicam.c   |    2 +
 drivers/media/platform/qcom/iris/iris_core.c       |   12 +-
 drivers/media/platform/qcom/iris/iris_state.c      |    2 +-
 drivers/media/v4l2-core/v4l2-async.c               |   15 +-
 drivers/mfd/iqs62x.c                               |    2 +-
 drivers/mfd/macsmc.c                               |    8 +-
 drivers/mfd/rave-sp.c                              |   64 +-
 drivers/misc/ad525x_dpot-i2c.c                     |    1 +
 drivers/misc/ad525x_dpot-spi.c                     |    1 +
 drivers/misc/ad525x_dpot.c                         |  177 +-
 drivers/misc/ad525x_dpot.h                         |    3 +
 drivers/misc/bcm-vk/bcm_vk_msg.c                   |    6 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |    2 +
 drivers/misc/cardreader/rtsx_usb.c                 |   26 +-
 drivers/misc/fastrpc.c                             |   16 +-
 drivers/misc/lan966x_pci.c                         |    1 +
 drivers/misc/pci_endpoint_test.c                   |   11 +-
 drivers/misc/sgi-gru/grufault.c                    |  101 +-
 drivers/misc/sgi-gru/gruprocfs.c                   |    1 -
 drivers/misc/sgi-gru/grutables.h                   |    1 -
 drivers/misc/vmw_vmci/vmci_event.c                 |    4 +-
 drivers/mtd/devices/mtd_intel_dg.c                 |   76 +-
 drivers/mtd/mtdpart.c                              |    3 +-
 drivers/mtd/mtdswap.c                              |    1 +
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   10 +-
 drivers/mtd/ubi/attach.c                           |    4 +-
 drivers/mtd/ubi/build.c                            |   11 +-
 drivers/mtd/ubi/fastmap.c                          |    6 +-
 drivers/mtd/ubi/io.c                               |   11 +-
 drivers/mtd/ubi/ubi.h                              |    4 +-
 drivers/mtd/ubi/wl.c                               |   15 +-
 drivers/net/amt.c                                  |    3 +
 drivers/net/bonding/bond_netlink.c                 |    2 +-
 drivers/net/dsa/b53/b53_common.c                   |    2 +-
 drivers/net/dsa/mv88e6xxx/pcs-6352.c               |    5 +-
 drivers/net/ethernet/airoha/airoha_npu.c           |    2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c    |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   72 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |    9 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   14 +-
 drivers/net/ethernet/freescale/fec_main.c          |    6 +-
 drivers/net/ethernet/huawei/hinic3/hinic3_tx.c     |    9 +-
 drivers/net/ethernet/intel/ice/devlink/devlink.c   |   32 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   66 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |    8 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           |    3 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |    3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   10 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |   90 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h           |    2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |    6 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |   38 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |    3 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |    2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |    3 +-
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |    2 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |    6 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    6 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |    3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   20 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_xsk.c  |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   39 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |    2 +-
 .../ethernet/mellanox/mlx5/core/esw/adj_vport.c    |   37 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   21 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    7 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  211 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  222 ++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   11 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   39 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |   14 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |  116 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h |    9 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   24 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  102 +
 drivers/net/ethernet/nvidia/forcedeth.c            |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   27 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |  467 +++--
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |    1 +
 drivers/net/ethernet/realtek/8139cp.c              |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   11 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   41 +-
 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c    |   61 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   71 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   99 +-
 drivers/net/ethernet/wangxun/libwx/wx_ptp.c        |   18 +-
 drivers/net/ethernet/wangxun/libwx/wx_sriov.c      |    6 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   52 +-
 drivers/net/ethernet/wangxun/libwx/wx_vf.h         |    1 +
 drivers/net/ethernet/wangxun/libwx/wx_vf_common.c  |   14 +-
 drivers/net/ethernet/wangxun/libwx/wx_vf_lib.c     |    3 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c   |    6 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   48 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c |    6 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c     |    7 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   19 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |    2 +-
 .../net/ethernet/wangxun/txgbevf/txgbevf_main.c    |   11 +
 drivers/net/gtp.c                                  |    2 +
 drivers/net/ipa/ipa_main.c                         |    6 +-
 drivers/net/netdevsim/netdev.c                     |    2 +
 drivers/net/ppp/pppox.c                            |   17 +
 drivers/net/slip/slip.c                            |    8 -
 drivers/net/thunderbolt/main.c                     |    6 +-
 drivers/net/vxlan/vxlan_mdb.c                      |    9 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |    6 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    9 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   32 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   40 +-
 drivers/net/wireless/ath/ath12k/ahb.c              |   18 +-
 drivers/net/wireless/ath/ath12k/core.c             |   27 +-
 drivers/net/wireless/ath/ath12k/core.h             |    2 -
 drivers/net/wireless/ath/ath12k/qmi.c              |  168 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |   28 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   17 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    8 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    2 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |    4 +
 drivers/net/wireless/mediatek/mt76/Makefile        |    5 +
 drivers/net/wireless/mediatek/mt76/dma.c           |  125 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |   69 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   14 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  138 ++
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   24 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   18 +
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    3 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  103 +
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   40 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |    2 +-
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |   74 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   55 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   60 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  106 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   26 +
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   24 +-
 drivers/net/wireless/mediatek/mt76/npu.c           |  502 +++++
 drivers/net/wireless/mediatek/mt76/scan.c          |    5 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |   11 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    9 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    6 +-
 drivers/net/wireless/realtek/rtw89/cam.c           |  152 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |  439 +---
 drivers/net/wireless/realtek/rtw89/core.c          |   52 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   22 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |  387 +++-
 drivers/net/wireless/realtek/rtw89/fw.c            |   58 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |    9 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |    6 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    2 -
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   40 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   29 +
 drivers/net/wireless/realtek/rtw89/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   17 +-
 drivers/net/wireless/realtek/rtw89/rtw8851be.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    7 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852bte.c    |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8922ae.c     |    1 +
 drivers/net/wireless/realtek/rtw89/wow.c           |    6 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |    5 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |    8 +
 drivers/nfc/pn533/pn533.c                          |   21 +-
 drivers/nvdimm/label.c                             |   15 +-
 drivers/nvdimm/nd_virtio.c                         |  121 +-
 drivers/nvdimm/pmem.c                              |   15 +-
 drivers/nvdimm/region_devs.c                       |    5 +-
 drivers/nvdimm/virtio_pmem.c                       |   17 +-
 drivers/nvdimm/virtio_pmem.h                       |    6 +
 drivers/nvme/host/apple.c                          |   63 +-
 drivers/nvme/host/core.c                           |   79 +-
 drivers/nvme/host/fabrics.h                        |    6 +
 drivers/nvme/host/fc.c                             |    7 +
 drivers/nvme/host/ioctl.c                          |  117 +-
 drivers/nvme/host/nvme.h                           |   68 +
 drivers/nvme/host/pci.c                            |   29 +-
 drivers/nvme/host/rdma.c                           |    1 +
 drivers/nvme/host/sysfs.c                          |   23 +
 drivers/nvme/host/tcp.c                            |    1 +
 drivers/nvme/target/core.c                         |    3 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |   12 +-
 drivers/nvme/target/loop.c                         |    1 +
 drivers/nvme/target/pr.c                           |   27 +-
 drivers/nvme/target/rdma.c                         |   31 +-
 drivers/nvme/target/zns.c                          |    2 +-
 drivers/pci/controller/cadence/pci-j721e.c         |    4 +-
 drivers/pci/controller/pci-xgene.c                 |    5 +-
 drivers/pci/controller/plda/pcie-starfive.c        |   10 +-
 drivers/pci/hotplug/pnv_php.c                      |    2 +-
 drivers/pci/hotplug/rpaphp_slot.c                  |    2 +-
 drivers/pci/pci.c                                  |    5 +-
 drivers/pci/pcie/aspm.c                            |   19 +-
 drivers/pci/slot.c                                 |   67 +-
 drivers/perf/arm_pmuv3.c                           |    2 +-
 drivers/perf/arm_spe_pmu.c                         |    2 +-
 drivers/perf/cxl_pmu.c                             |    2 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |  736 ++++++-
 drivers/phy/qualcomm/phy-qcom-qmp-dp-phy-v8.h      |   25 +
 .../phy/qualcomm/phy-qcom-qmp-dp-qserdes-com-v8.h  |   52 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           |    1 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-aon-v6.h     |   12 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-aon-v8.h     |   17 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-misc-v5.h    |   12 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-misc-v8.h    |   12 +
 .../phy/qualcomm/phy-qcom-qmp-qserdes-lalb-v8.h    |  639 ++++++
 drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c     |   12 +-
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   12 +-
 drivers/phy/qualcomm/phy-qcom-qmp-usb43-pcs-v8.h   |   33 +
 .../qualcomm/phy-qcom-qmp-usb43-qserdes-com-v8.h   |  224 ++
 drivers/phy/qualcomm/phy-qcom-qmp.h                |    2 +
 drivers/phy/qualcomm/phy-qcom-sgmii-eth.c          |   43 +-
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c      |   26 +-
 drivers/phy/renesas/Kconfig                        |    1 +
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  187 +-
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c   |    2 +-
 drivers/phy/starfive/phy-jh7110-dphy-rx.c          |    5 +-
 drivers/phy/starfive/phy-jh7110-dphy-tx.c          |    5 +-
 drivers/phy/sunplus/phy-sunplus-usb2.c             |    6 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |    1 -
 drivers/pinctrl/mediatek/mtk-eint.c                |   25 +-
 drivers/pinctrl/mediatek/pinctrl-airoha.c          | 2198 +++++++++++---------
 drivers/pinctrl/pinctrl-eic7700.c                  |    3 +
 drivers/pinctrl/pinctrl-rockchip.c                 |   10 +
 drivers/pinctrl/spacemit/pinctrl-k1.c              |   10 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |    6 +-
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   |    9 +-
 drivers/platform/chrome/cros_ec_typec.c            |    6 +
 drivers/platform/mellanox/mlxbf-bootctl.c          |    1 +
 drivers/platform/mellanox/mlxbf-pmc.c              |   10 +-
 drivers/platform/surface/surface_acpi_notify.c     |    6 +-
 drivers/platform/x86/acer-wmi.c                    |    4 +-
 drivers/platform/x86/amd/hsmp/hwmon.c              |    3 +
 drivers/platform/x86/amd/pmc/mp1_stb.c             |   23 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |   17 +-
 drivers/platform/x86/dell/dell-wmi-privacy.c       |    4 +-
 .../x86/dell/dell-wmi-sysman/dell-wmi-sysman.h     |    2 +-
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |    5 +
 drivers/platform/x86/hp/hp-wmi.c                   |    4 +
 drivers/platform/x86/intel/int1092/intel_sar.c     |   39 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   14 +-
 drivers/platform/x86/lg-laptop.c                   |   79 +-
 drivers/pmdomain/bcm/bcm2835-power.c               |    7 +-
 drivers/power/reset/sc27xx-poweroff.c              |   10 +-
 drivers/power/supply/bd99954-charger.h             |   23 +-
 drivers/power/supply/bq27xxx_battery.c             |    6 +-
 drivers/power/supply/isp1704_charger.c             |    1 +
 drivers/power/supply/sbs-battery.c                 |    7 +-
 drivers/power/supply/sc2731_charger.c              |    2 +
 drivers/powercap/intel_rapl_tpmi.c                 |    5 +-
 drivers/pps/clients/pps-gpio.c                     |   66 +-
 drivers/pps/pps.c                                  |   10 +-
 drivers/ptp/ptp_netc.c                             |   13 +-
 drivers/rapidio/rio-scan.c                         |    1 +
 drivers/regulator/adp5055-regulator.c              |    2 +-
 drivers/regulator/core.c                           |    6 +-
 drivers/regulator/qcom-rpmh-regulator.c            |    6 +-
 drivers/regulator/tps6594-regulator.c              |   19 +-
 drivers/remoteproc/qcom_common.c                   |    4 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |    1 +
 drivers/remoteproc/remoteproc_core.c               |  156 +-
 drivers/remoteproc/remoteproc_sysfs.c              |    1 -
 drivers/rpmsg/qcom_glink_native.c                  |   44 +-
 drivers/rtc/rtc-gamecube.c                         |    4 +-
 drivers/rtc/rtc-pcf85363.c                         |   17 +-
 drivers/rtc/rtc-pcf8563.c                          |    4 +-
 drivers/rtc/rtc-spacemit-p1.c                      |    5 +-
 drivers/rtc/rtc-zynqmp.c                           |    7 +-
 drivers/s390/block/dasd.c                          |    1 -
 drivers/s390/block/dasd_eckd.c                     |   11 -
 drivers/s390/block/dasd_ioctl.c                    |    6 +-
 drivers/s390/char/con3270.c                        |   19 -
 drivers/s390/char/fs3270.c                         |    7 +-
 drivers/s390/char/sclp_ctl.c                       |   12 +-
 drivers/s390/char/tape_char.c                      |   26 -
 drivers/s390/char/vmcp.c                           |    7 +-
 drivers/s390/cio/chsc_sch.c                        |    7 +-
 drivers/s390/crypto/zcrypt_api.c                   |  195 --
 drivers/s390/crypto/zcrypt_card.c                  |    1 -
 drivers/s390/crypto/zcrypt_queue.c                 |    1 -
 drivers/s390/net/qeth_core_main.c                  |    4 +-
 drivers/scsi/ch.c                                  |    4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    2 +
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 -
 drivers/scsi/qla2xxx/qla_nx2.c                     |    2 +-
 drivers/scsi/scsi_sysfs.c                          |   77 +-
 drivers/scsi/sd.c                                  |  297 ++-
 drivers/scsi/ses.c                                 |    4 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   18 +
 drivers/scsi/sr.c                                  |    4 +-
 drivers/scsi/st.c                                  |    4 +-
 drivers/sh/clk/core.c                              |   10 +-
 drivers/sh/intc/core.c                             |   12 +-
 drivers/soc/bcm/brcmstb/biuctrl.c                  |   12 +-
 drivers/soc/fsl/qe/gpio.c                          |   25 +
 drivers/soc/fsl/qe/qe_ic.c                         |    3 +-
 drivers/soc/fsl/qe/qe_io.c                         |   15 +
 drivers/soc/qcom/rpmh-rsc.c                        |   37 +-
 drivers/soc/renesas/Kconfig                        |    1 -
 drivers/soc/samsung/exynos-pmu.c                   |    4 +-
 drivers/soc/tegra/pmc.c                            |   17 +-
 drivers/soc/ti/knav_qmss.h                         |    1 +
 drivers/soc/ti/knav_qmss_queue.c                   |   14 +-
 drivers/soundwire/bus.c                            |   31 +
 drivers/soundwire/qcom.c                           |    2 +-
 drivers/spi/spi-amlogic-spisg.c                    |    2 +-
 drivers/spi/spi-davinci.c                          |    7 +-
 drivers/spi/spi-geni-qcom.c                        |   17 +-
 drivers/spi/spi-img-spfi.c                         |    5 +-
 drivers/spi/spi-oc-tiny.c                          |   24 +-
 drivers/spi/spi-sprd-adi.c                         |    6 +
 drivers/staging/fbtft/fbtft-sysfs.c                |    2 +-
 drivers/staging/gpib/common/gpib_os.c              |   21 +-
 drivers/staging/gpib/common/iblib.c                |    3 -
 drivers/staging/greybus/audio_gb.c                 |   13 +
 drivers/staging/greybus/audio_manager_sysfs.c      |    2 +-
 drivers/staging/media/ipu7/ipu7-isys.c             |    1 +
 drivers/staging/media/ipu7/ipu7.c                  |    4 +-
 drivers/staging/octeon/ethernet-mem.c              |   43 +-
 drivers/staging/octeon/ethernet-mem.h              |    8 +-
 drivers/staging/octeon/ethernet-rx.c               |   53 +-
 drivers/staging/octeon/ethernet-rx.h               |   13 +-
 drivers/staging/octeon/ethernet-tx.c               |    2 +
 drivers/staging/octeon/ethernet.c                  |   43 +-
 drivers/staging/octeon/octeon-ethernet.h           |   14 +
 drivers/staging/rtl8723bs/core/rtw_ap.c            |    8 +-
 drivers/staging/rtl8723bs/core/rtw_cmd.c           |   89 +-
 drivers/staging/rtl8723bs/core/rtw_efuse.c         |    1 -
 drivers/staging/rtl8723bs/core/rtw_ioctl_set.c     |    1 -
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   29 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |  106 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          |   27 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |  159 +-
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     |    3 +-
 drivers/staging/rtl8723bs/core/rtw_xmit.c          |   97 +-
 drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c     |    2 +-
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |    2 +-
 drivers/staging/rtl8723bs/include/basic_types.h    |    1 +
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   29 +-
 drivers/staging/rtl8723bs/os_dep/os_intfs.c        |    2 +-
 drivers/staging/rtl8723bs/os_dep/osdep_service.c   |    7 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |    4 +-
 drivers/staging/rtl8723bs/os_dep/xmit_linux.c      |    2 +-
 drivers/staging/sm750fb/Kconfig                    |    1 +
 drivers/staging/sm750fb/sm750.c                    |    6 +-
 drivers/staging/sm750fb/sm750.h                    |    2 +-
 drivers/staging/sm750fb/sm750_accel.c              |    6 +-
 drivers/staging/sm750fb/sm750_accel.h              |    4 +-
 drivers/thermal/airoha_thermal.c                   |    4 +-
 .../intel/int340x_thermal/int3400_thermal.c        |    4 +-
 drivers/thermal/intel/intel_hfi.c                  |   12 +-
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c           |    3 -
 drivers/thermal/renesas/rcar_thermal.c             |   15 +-
 drivers/tty/hvc/Kconfig                            |    2 +-
 drivers/tty/serial/8250/8250_core.c                |    6 +
 drivers/tty/serial/8250/8250_port.c                |   21 +-
 drivers/tty/serial/amba-pl011.c                    |   48 +-
 drivers/tty/serial/bcm63xx_uart.c                  |    2 +-
 drivers/tty/serial/ma35d1_serial.c                 |   12 +-
 drivers/tty/serial/omap-serial.c                   |    2 +-
 drivers/tty/serial/pch_uart.c                      |    2 +-
 drivers/tty/serial/pxa.c                           |    2 +-
 drivers/tty/serial/qcom_geni_serial.c              |   10 +-
 drivers/tty/serial/samsung_tty.c                   |    8 +-
 drivers/tty/serial/serial_core.c                   |   21 +-
 drivers/tty/serial/serial_txx9.c                   |    4 +-
 drivers/tty/serial/sunsu.c                         |    2 +-
 drivers/tty/tty_io.c                               |    4 +-
 drivers/ufs/core/ufs-debugfs.c                     |    2 +-
 drivers/ufs/core/ufshcd.c                          |    5 +-
 drivers/uio/uio.c                                  |    5 +
 drivers/usb/atm/usbatm.c                           |    4 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  110 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |    1 +
 drivers/usb/cdns3/cdnsp-mem.c                      |   98 +-
 drivers/usb/core/driver.c                          |   12 +-
 drivers/usb/gadget/configfs.c                      |    4 +-
 drivers/usb/gadget/function/f_fs.c                 |    8 +-
 drivers/usb/gadget/function/f_mass_storage.c       |    3 +
 drivers/usb/gadget/function/f_uac1_legacy.c        |   56 -
 drivers/usb/gadget/function/u_uac1_legacy.h        |    3 -
 drivers/usb/gadget/udc/aspeed_udc.c                |   50 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |    1 -
 drivers/usb/misc/usb-ljca.c                        |    3 +
 drivers/usb/mtu3/mtu3_core.c                       |   11 +-
 drivers/usb/renesas_usbhs/common.c                 |    6 +-
 drivers/usb/typec/ucsi/debugfs.c                   |    1 +
 drivers/usb/typec/ucsi/ucsi.c                      |    2 +
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c        |   68 +-
 drivers/vdpa/mlx5/core/mr.c                        |    2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   25 +-
 drivers/vfio/pci/vfio_pci_config.c                 |    1 +
 drivers/vhost/net.c                                |    3 +-
 drivers/video/fbdev/clps711x-fb.c                  |    2 -
 drivers/video/fbdev/kyro/fbdev.c                   |   24 +-
 drivers/video/fbdev/tdfxfb.c                       |    2 +-
 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c    |   97 +-
 drivers/virtio/virtio.c                            |   41 +-
 drivers/virtio/virtio_balloon.c                    |   40 +-
 drivers/virtio/virtio_pci_common.c                 |    2 +-
 drivers/virtio/virtio_rtc_driver.c                 |   14 +-
 drivers/w1/masters/ds2482.c                        |    4 +
 drivers/xen/xen-acpi-processor.c                   |   12 +-
 drivers/xen/xenbus/xenbus_xs.c                     |   16 +-
 fs/btrfs/bio.c                                     |   68 +-
 fs/btrfs/bio.h                                     |    5 +-
 fs/btrfs/block-group.c                             |    3 +-
 fs/btrfs/ctree.c                                   |    3 +-
 fs/btrfs/defrag.c                                  |   50 +-
 fs/btrfs/delayed-inode.c                           |    4 +-
 fs/btrfs/disk-io.c                                 |   51 +-
 fs/btrfs/extent-io-tree.c                          |   10 +-
 fs/btrfs/extent-tree.c                             |   10 +-
 fs/btrfs/extent_io.c                               |   31 +-
 fs/btrfs/extent_io.h                               |   23 +-
 fs/btrfs/fiemap.c                                  |    4 +-
 fs/btrfs/file.c                                    |  103 +-
 fs/btrfs/free-space-tree.c                         |    4 +-
 fs/btrfs/inode-item.c                              |    7 +-
 fs/btrfs/inode.c                                   |   13 +-
 fs/btrfs/qgroup.c                                  |   37 +-
 fs/btrfs/relocation.c                              |    5 +-
 fs/btrfs/verity.c                                  |   16 +-
 fs/btrfs/volumes.c                                 |    9 +-
 fs/ceph/dir.c                                      |    2 +-
 fs/ceph/file.c                                     |   48 +
 fs/erofs/Kconfig                                   |    8 +-
 fs/erofs/decompressor.c                            |    2 +-
 fs/erofs/internal.h                                |   25 +-
 fs/erofs/zdata.c                                   |   31 +-
 fs/erofs/zmap.c                                    |   82 +-
 fs/ext4/dir.c                                      |   20 +-
 fs/ext4/ext4.h                                     |    1 +
 fs/ext4/file.c                                     |    7 +
 fs/ext4/inline.c                                   |   25 +-
 fs/ext4/inode.c                                    |   52 +-
 fs/ext4/migrate.c                                  |    3 +-
 fs/ext4/namei.c                                    |    2 +
 fs/ext4/orphan.c                                   |   10 +-
 fs/f2fs/f2fs.h                                     |   22 +-
 fs/f2fs/gc.c                                       |    5 +-
 fs/f2fs/segment.c                                  |    8 +-
 fs/f2fs/super.c                                    |    4 +-
 fs/fat/nfs.c                                       |    4 +-
 fs/fuse/cuse.c                                     |    5 +
 fs/fuse/inode.c                                    |    2 +
 fs/hfsplus/catalog.c                               |   25 +-
 fs/hfsplus/hfsplus_fs.h                            |    6 +
 fs/hugetlbfs/inode.c                               |    3 +-
 fs/inode.c                                         |   18 +-
 fs/isofs/compress.c                                |    7 +-
 fs/nfs/blocklayout/dev.c                           |   21 +-
 fs/nfs/client.c                                    |   14 +-
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
 fs/nilfs2/page.c                                   |   17 +-
 fs/nilfs2/segment.c                                |    4 +
 fs/nilfs2/the_nilfs.c                              |    6 +
 fs/notify/fanotify/fanotify.c                      |    1 +
 fs/notify/fanotify/fanotify_user.c                 |   12 +-
 fs/ntfs3/fslog.c                                   |   13 +-
 fs/ntfs3/fsntfs.c                                  |    8 +-
 fs/ntfs3/record.c                                  |   34 +-
 fs/ntfs3/super.c                                   |   13 +-
 fs/ntfs3/xattr.c                                   |   25 +-
 fs/ocfs2/acl.c                                     |  141 +-
 fs/ocfs2/acl.h                                     |   19 +-
 fs/ocfs2/cluster/heartbeat.c                       |   86 +-
 fs/ocfs2/cluster/heartbeat.h                       |    5 +
 fs/ocfs2/cluster/nodemanager.c                     |   23 +-
 fs/ocfs2/cluster/nodemanager.h                     |    2 +
 fs/ocfs2/cluster/tcp.c                             |   83 +-
 fs/ocfs2/cluster/tcp.h                             |    1 +
 fs/ocfs2/inode.c                                   |   16 +
 fs/ocfs2/namei.c                                   |   17 +-
 fs/ocfs2/xattr.c                                   |   86 +-
 fs/ocfs2/xattr.h                                   |    9 +-
 fs/resctrl/rdtgroup.c                              |   19 +-
 fs/smb/client/cifs_debug.c                         |    2 +-
 fs/smb/client/inode.c                              |   14 -
 fs/smb/client/smb2pdu.c                            |   16 +-
 fs/smb/server/Kconfig                              |    1 -
 fs/smb/server/auth.c                               |    2 +-
 fs/smb/server/connection.c                         |   19 +
 fs/smb/server/connection.h                         |    1 +
 fs/smb/server/mgmt/share_config.c                  |    7 +-
 fs/smb/server/mgmt/user_config.c                   |    1 +
 fs/smb/server/mgmt/user_session.c                  |   24 +-
 fs/smb/server/mgmt/user_session.h                  |    1 +
 fs/smb/server/server.c                             |    4 +-
 fs/smb/server/smb2ops.c                            |   11 +-
 fs/smb/server/smb2pdu.c                            |   15 +-
 fs/smb/server/smbacl.c                             |    4 +-
 fs/smb/server/transport_ipc.c                      |   12 +
 fs/smb/server/transport_tcp.c                      |    6 +
 fs/smb/server/vfs.c                                |    3 -
 fs/smb/server/vfs_cache.c                          |    5 +-
 fs/squashfs/cache.c                                |    2 +-
 fs/stat.c                                          |    2 +-
 fs/super.c                                         |    4 +-
 fs/udf/inode.c                                     |  129 +-
 fs/udf/super.c                                     |   23 +-
 fs/udf/symlink.c                                   |    2 +
 include/acpi/processor.h                           |    2 +
 include/drm/bridge/dw_dp.h                         |    8 +
 include/linux/bio.h                                |   22 +-
 include/linux/blk-mq.h                             |   16 +
 include/linux/blk_types.h                          |   12 +
 include/linux/bpf.h                                |   19 +-
 include/linux/compiler-context-analysis.h          |   32 +
 include/linux/compiler_types.h                     |   18 +-
 include/linux/dma-buf.h                            |    5 +
 include/linux/efi.h                                |    4 +-
 include/linux/filter.h                             |   31 +
 include/linux/firmware/qcom/qcom_scm.h             |   14 +
 include/linux/fs.h                                 |   20 +-
 include/linux/ftrace.h                             |    5 +-
 include/linux/gpio.h                               |  162 +-
 include/linux/gpio/legacy.h                        |  173 ++
 include/linux/hwmon.h                              |    3 +
 include/linux/i3c/master.h                         |    3 +
 include/linux/ieee80211-uhr.h                      |  220 ++
 include/linux/ieee80211.h                          |   33 +-
 include/linux/ima.h                                |    7 +-
 include/linux/io_uring_types.h                     |    7 +-
 include/linux/leds.h                               |    2 +
 include/linux/libnvdimm.h                          |    9 +
 include/linux/maple_tree.h                         |    2 +-
 include/linux/memory.h                             |   27 +-
 include/linux/memory_hotplug.h                     |   18 +-
 include/linux/mlx5/driver.h                        |    1 +
 include/linux/mlx5/fs.h                            |    1 +
 include/linux/mlx5/mlx5_ifc.h                      |    9 +-
 include/linux/mlx5/vport.h                         |    7 +
 include/linux/mmc/sdio_ids.h                       |    1 +
 include/linux/mroute_base.h                        |    3 +
 include/linux/nfs_xdr.h                            |    2 +-
 include/linux/nvme.h                               |    4 +
 include/linux/pci.h                                |   14 +-
 include/linux/pm_runtime.h                         |   24 +
 include/linux/remoteproc.h                         |  284 +--
 include/linux/rsc_table.h                          |  364 ++++
 include/linux/rtsx_usb.h                           |    3 +
 include/linux/sched/rt.h                           |    2 +
 include/linux/sched/user.h                         |    3 +-
 include/linux/secure_boot.h                        |   23 +
 include/linux/serial_core.h                        |   20 +
 include/linux/soc/airoha/airoha_offload.h          |    1 +
 include/linux/soc/qcom/ubwc.h                      |    1 +
 include/linux/soundwire/sdw.h                      |    8 +
 include/linux/syscore_ops.h                        |   17 +-
 include/linux/time_namespace.h                     |   39 +-
 include/linux/usb.h                                |    3 +-
 include/linux/virtio.h                             |    1 +
 include/linux/virtio_net.h                         |    4 +
 include/media/rc-map.h                             |    2 -
 include/net/act_api.h                              |    2 +-
 include/net/bluetooth/hci_core.h                   |    2 +-
 include/net/bluetooth/l2cap.h                      |    5 +
 include/net/cfg80211.h                             |  156 +-
 include/net/inetpeer.h                             |    4 +
 include/net/libeth/xsk.h                           |    2 +-
 include/net/netns/ipv4.h                           |    2 +-
 include/net/pkt_sched.h                            |    1 +
 include/net/sch_generic.h                          |    9 +-
 include/net/sock.h                                 |   17 +-
 include/net/xdp_sock_drv.h                         |   22 +-
 include/net/xsk_buff_pool.h                        |    3 +-
 include/rdma/ib_verbs.h                            |   21 +
 include/scsi/scsi_driver.h                         |    7 +-
 include/sound/core.h                               |    2 +
 include/trace/events/erofs.h                       |    7 +-
 include/uapi/linux/devlink.h                       |    1 +
 include/uapi/linux/if_xdp.h                        |    1 +
 include/uapi/linux/nl80211.h                       |  140 ++
 include/uapi/linux/time_types.h                    |    2 +-
 include/uapi/rdma/ib_user_ioctl_cmds.h             |    6 +
 init/Kconfig                                       |    4 +-
 io_uring/futex.c                                   |   16 +-
 io_uring/io_uring.c                                |   45 +-
 io_uring/io_uring.h                                |   17 +-
 io_uring/msg_ring.c                                |    3 +-
 io_uring/notif.c                                   |    5 +-
 io_uring/poll.c                                    |   13 +-
 io_uring/poll.h                                    |    2 +-
 io_uring/rw.c                                      |    5 +-
 io_uring/rw.h                                      |    2 +-
 io_uring/timeout.c                                 |   20 +-
 io_uring/uring_cmd.c                               |    5 +-
 io_uring/waitid.c                                  |   81 +-
 kernel/bpf/arena.c                                 |    2 +
 kernel/bpf/bpf_lsm.c                               |    1 -
 kernel/bpf/btf.c                                   |   30 +-
 kernel/bpf/cgroup.c                                |   27 +-
 kernel/bpf/cpumask.c                               |    6 +-
 kernel/bpf/helpers.c                               |    9 +-
 kernel/bpf/mmap_unlock_work.h                      |   51 +-
 kernel/bpf/net_namespace.c                         |   17 +-
 kernel/bpf/queue_stack_maps.c                      |    8 +-
 kernel/bpf/ringbuf.c                               |    2 +-
 kernel/bpf/stackmap.c                              |  192 +-
 kernel/bpf/syscall.c                               |   23 +-
 kernel/bpf/task_iter.c                             |   48 +-
 kernel/bpf/verifier.c                              |   55 +-
 kernel/cgroup/cpuset-internal.h                    |    2 +-
 kernel/cgroup/cpuset.c                             |  118 +-
 kernel/cpu_pm.c                                    |   12 +-
 kernel/crash_dump_dm_crypt.c                       |   15 +-
 kernel/dma/swiotlb.c                               |   31 +-
 kernel/events/core.c                               |   90 +-
 kernel/events/internal.h                           |    1 +
 kernel/events/ring_buffer.c                        |    2 +
 kernel/futex/core.c                                |  105 +-
 kernel/futex/futex.h                               |   28 +-
 kernel/futex/pi.c                                  |   37 +-
 kernel/futex/requeue.c                             |   20 +-
 kernel/futex/waitwake.c                            |   17 +-
 kernel/irq/generic-chip.c                          |   14 +-
 kernel/irq/pm.c                                    |   11 +-
 kernel/kcsan/core.c                                |   12 +-
 kernel/locking/lockdep.c                           |    2 +
 kernel/locking/rtmutex_api.c                       |    2 +
 kernel/module/dups.c                               |   99 +-
 kernel/module/stats.c                              |    2 +-
 kernel/power/snapshot.c                            |    5 +-
 kernel/power/wakelock.c                            |    2 +-
 kernel/printk/printk.c                             |  176 +-
 kernel/rcu/tree_plugin.h                           |   10 +-
 kernel/sched/core.c                                |   16 +
 kernel/sched/cpufreq_schedutil.c                   |    2 +-
 kernel/sched/fair.c                                |   31 +-
 kernel/sys.c                                       |    2 +-
 kernel/time/Makefile                               |    1 +
 kernel/time/clocksource.c                          |    8 +-
 kernel/time/namespace.c                            |  165 +-
 kernel/time/namespace_internal.h                   |   28 +
 kernel/time/namespace_vdso.c                       |  160 ++
 kernel/time/sched_clock.c                          |   22 +-
 kernel/time/timekeeping.c                          |   49 +-
 kernel/time/timer_migration.c                      |    4 +-
 kernel/trace/ftrace.c                              |   57 +-
 kernel/trace/ring_buffer.c                         |   67 +-
 kernel/trace/trace.c                               |  111 +-
 kernel/trace/trace.h                               |   12 +-
 kernel/trace/trace_btf.c                           |   31 +-
 kernel/trace/trace_btf.h                           |    3 +-
 kernel/trace/trace_events.c                        |    6 +-
 kernel/trace/trace_functions.c                     |    2 +-
 kernel/trace/trace_probe.c                         |   18 +-
 kernel/trace/trace_stack.c                         |    2 +-
 lib/interval_tree_test.c                           |    4 +-
 lib/maple_tree.c                                   |   43 +-
 lib/string.c                                       |    3 +-
 lib/test_hmm.c                                     |    2 +-
 lib/vdso/datastore.c                               |   25 -
 mm/damon/sysfs.c                                   |    6 +-
 mm/huge_memory.c                                   |    2 +
 mm/khugepaged.c                                    |    6 -
 mm/madvise.c                                       |    8 +
 mm/memory_hotplug.c                                |   13 +-
 mm/mm_init.c                                       |   19 +-
 mm/mremap.c                                        |   21 +-
 mm/secretmem.c                                     |  117 +-
 net/batman-adv/bridge_loop_avoidance.c             |   65 +-
 net/batman-adv/distributed-arp-table.c             |   58 +-
 net/batman-adv/mesh-interface.c                    |    7 +-
 net/batman-adv/types.h                             |    2 +-
 net/bluetooth/hci_conn.c                           |   20 +-
 net/bluetooth/hci_sync.c                           |   12 +-
 net/bluetooth/l2cap_sock.c                         |   36 +-
 net/bluetooth/mgmt.c                               |   40 +-
 net/bluetooth/msft.c                               |    5 +
 net/bluetooth/rfcomm/core.c                        |    4 +
 net/bridge/br_netlink_tunnel.c                     |    3 +-
 net/bridge/br_vlan.c                               |    4 +-
 net/can/bcm.c                                      |    5 +-
 net/can/isotp.c                                    |    3 +-
 net/can/j1939/socket.c                             |    3 +-
 net/can/raw.c                                      |    3 +-
 net/ceph/messenger_v2.c                            |    5 +
 net/core/dev.c                                     |   60 +-
 net/core/filter.c                                  |    4 -
 net/core/lwt_bpf.c                                 |   15 +-
 net/core/net_namespace.c                           |   25 +-
 net/core/page_pool.c                               |   71 +-
 net/core/skbuff.c                                  |    6 +-
 net/core/sock.c                                    |   20 +-
 net/devlink/netlink_gen.c                          |    2 +-
 net/hsr/hsr_device.c                               |    2 +
 net/ife/ife.c                                      |   14 +-
 net/ipv4/inetpeer.c                                |   38 +-
 net/ipv4/ipmr.c                                    |  186 +-
 net/ipv4/ipmr_base.c                               |   16 +
 net/ipv4/ping.c                                    |    3 +-
 net/ipv4/raw.c                                     |    3 +-
 net/ipv4/tcp.c                                     |    6 +-
 net/ipv4/tcp_output.c                              |    2 +-
 net/ipv6/ip6mr.c                                   |   22 +-
 net/ipv6/raw.c                                     |    3 +-
 net/ipv6/route.c                                   |    2 +-
 net/ipv6/xfrm6_input.c                             |    2 +-
 net/kcm/kcmsock.c                                  |    3 +
 net/mac80211/link.c                                |    3 +-
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/s1g.c                                 |    2 +-
 net/mac80211/spectmgmt.c                           |   11 +-
 net/mac80211/tx.c                                  |    3 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   10 +-
 net/netfilter/nf_nat_sip.c                         |    5 +
 net/netfilter/nf_tables_api.c                      |   14 +-
 net/netfilter/xt_cgroup.c                          |   12 +-
 net/netfilter/xt_hl.c                              |   27 +
 net/nfc/digital_core.c                             |    2 +-
 net/nfc/llcp_core.c                                |   29 +-
 net/nfc/llcp_sock.c                                |   14 +-
 net/nfc/nci/data.c                                 |   10 +-
 net/nfc/nci/rsp.c                                  |   41 +-
 net/phonet/pep.c                                   |    2 +-
 net/rds/cong.c                                     |    4 +-
 net/sched/act_api.c                                |    7 +-
 net/sched/act_bpf.c                                |   28 +-
 net/sched/act_ct.c                                 |   46 +
 net/sched/act_ctinfo.c                             |   11 +
 net/sched/act_ife.c                                |   63 +-
 net/sched/act_mpls.c                               |    2 +-
 net/sched/act_pedit.c                              |   24 +
 net/sched/act_police.c                             |   14 +-
 net/sched/act_sample.c                             |    9 +
 net/sched/act_skbedit.c                            |    2 +-
 net/sched/act_skbmod.c                             |   12 +-
 net/sched/act_tunnel_key.c                         |   80 +
 net/sched/cls_api.c                                |   18 +-
 net/sched/sch_api.c                                |    7 +-
 net/sched/sch_cake.c                               |    2 +-
 net/sched/sch_codel.c                              |    2 +-
 net/sched/sch_fifo.c                               |    2 +-
 net/sched/sch_fq.c                                 |   26 +-
 net/sched/sch_fq_codel.c                           |    8 +-
 net/sched/sch_fq_pie.c                             |    3 +-
 net/sched/sch_gred.c                               |    6 +-
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
 net/vmw_vsock/af_vsock.c                           |   23 +-
 net/wireless/core.c                                |   57 +-
 net/wireless/core.h                                |    4 +
 net/wireless/nl80211.c                             |  491 ++++-
 net/wireless/nl80211.h                             |    5 +-
 net/wireless/pmsr.c                                |    5 +-
 net/wireless/rdev-ops.h                            |   16 +
 net/wireless/reg.c                                 |    4 +-
 net/wireless/trace.h                               |   57 +
 net/wireless/util.c                                |  101 +-
 net/xdp/xsk.c                                      |   44 +-
 net/xdp/xsk_buff_pool.c                            |    7 +-
 net/xdp/xsk_queue.h                                |   16 +-
 net/xfrm/xfrm_output.c                             |    4 +-
 rust/kernel/cpufreq.rs                             |   24 +-
 rust/uapi/uapi_helper.h                            |    2 +-
 samples/ftrace/ftrace-direct-modify.c              |   12 +-
 samples/ftrace/ftrace-direct-multi-modify.c        |   12 +-
 scripts/mod/modpost.c                              |    6 +-
 scripts/tags.sh                                    |    2 +-
 security/apparmor/af_unix.c                        |    2 +-
 security/apparmor/apparmorfs.c                     |    2 +-
 security/apparmor/domain.c                         |  201 +-
 security/apparmor/include/lib.h                    |   31 +-
 security/apparmor/include/policy.h                 |    3 +
 security/apparmor/label.c                          |   26 +-
 security/apparmor/lib.c                            |   20 +-
 security/apparmor/mount.c                          |   17 +-
 security/apparmor/policy.c                         |   22 +-
 security/integrity/Makefile                        |    1 +
 security/integrity/efi_secureboot.c                |   56 +
 security/integrity/ima/ima_appraise.c              |    2 +-
 security/integrity/ima/ima_efi.c                   |   47 +-
 security/integrity/ima/ima_main.c                  |    3 +-
 security/integrity/integrity.h                     |    1 +
 security/integrity/platform_certs/load_uefi.c      |    2 +-
 security/smack/smack.h                             |    5 +-
 security/smack/smack_lsm.c                         |   67 +-
 security/smack/smackfs.c                           |  222 +-
 sound/core/control.c                               |    6 +-
 sound/core/control_led.c                           |   13 +-
 sound/core/init.c                                  |    4 +-
 sound/core/seq/seq_clientmgr.c                     |   16 +-
 sound/core/seq/seq_midi.c                          |   61 +-
 sound/drivers/mtpav.c                              |    4 +-
 sound/hda/common/proc.c                            |    2 +-
 sound/pci/asihpi/hpi6000.c                         |    5 +
 sound/pci/ice1712/ice1712.c                        |    7 +-
 sound/pci/via82xx_modem.c                          |   26 +-
 sound/soc/apple/mca.c                              |    6 +-
 sound/soc/codecs/rt700-sdw.c                       |    6 +-
 sound/soc/codecs/tas2783-sdw.c                     |   42 +-
 sound/soc/fsl/fsl-asoc-card.c                      |    4 +-
 sound/soc/fsl/fsl_audmix.c                         |   24 +-
 sound/soc/meson/meson-card-utils.c                 |   17 +-
 sound/soc/pxa/pxa-ssp.c                            |    7 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   12 +-
 sound/soc/soc-dapm.c                               |    2 +-
 sound/soc/sof/topology.c                           |   18 +-
 sound/soc/tegra/tegra210_mixer.c                   |   10 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |   14 +-
 sound/usb/fcp.c                                    |   38 +-
 sound/usb/mixer_scarlett2.c                        |   21 +-
 sound/usb/quirks.c                                 |   13 +-
 tools/bpf/bpftool/map.c                            |   16 +-
 tools/bpf/bpftool/sign.c                           |    7 +-
 tools/bpf/bpftool/struct_ops.c                     |    4 +
 tools/build/Makefile.feature                       |    2 -
 tools/build/feature/Makefile                       |   14 -
 tools/include/nolibc/arch-powerpc.h                |    2 +-
 tools/include/nolibc/arch-sparc.h                  |    2 +-
 tools/include/uapi/linux/if_xdp.h                  |    1 +
 tools/lib/bpf/libbpf.c                             |    3 +-
 .../xdrgen/templates/C/enum/declaration/enum.j2    |    1 -
 .../xdrgen/templates/C/enum/definition/close.j2    |    1 +
 .../xdrgen/templates/C/enum/definition/close_be.j2 |    1 +
 .../xdrgen/templates/C/pointer/encoder/string.j2   |    2 +
 .../C/pointer/encoder/variable_length_opaque.j2    |    2 +
 .../xdrgen/templates/C/struct/encoder/string.j2    |    2 +
 .../C/struct/encoder/variable_length_opaque.j2     |    2 +
 .../xdrgen/templates/C/union/definition/close.j2   |    5 -
 tools/perf/Documentation/perf-c2c.txt              |    7 +
 tools/perf/builtin-c2c.c                           |  296 ++-
 tools/perf/builtin-ftrace.c                        |   13 +-
 tools/perf/builtin-record.c                        |   55 +-
 tools/perf/builtin-stat.c                          |    9 +-
 .../arch/x86/amdzen5/floating-point.json           |  160 +-
 .../pmu-events/arch/x86/amdzen5/load-store.json    |    8 +-
 tools/perf/pmu-events/jevents.py                   |    5 +-
 tools/perf/pmu-events/metric.py                    |    6 +-
 tools/perf/tests/builtin-test.c                    |  864 +++++++-
 tools/perf/tests/shell/kvm.sh                      |  169 ++
 .../perf/tests/shell/lib/perf_metric_validation.py |   11 +-
 tools/perf/tests/shell/lib/perf_record.sh          |   58 +
 tools/perf/tests/shell/pipe_test.sh                |    4 +-
 .../shell/record+zstd_comp_decomp_multi_record.sh  |   63 +
 tools/perf/tests/shell/record.sh                   |  173 +-
 tools/perf/tests/shell/record_lbr.sh               |   50 +-
 tools/perf/tests/shell/stat_all_metrics.sh         |  112 +-
 tools/perf/tests/shell/stat_bpf_counters.sh        |   44 +-
 tools/perf/tests/shell/stat_metrics_values.sh      |    7 +
 tools/perf/tests/shell/test_brstack.sh             |  131 +-
 tools/perf/tests/shell/trace_record_replay.sh      |   38 +-
 tools/perf/tests/tests.h                           |    2 +
 tools/perf/ui/browsers/hists.c                     |    6 +-
 tools/perf/util/arm-spe.c                          |    4 +
 tools/perf/util/auxtrace.c                         |   15 +-
 tools/perf/util/bpf-event.c                        |    3 +-
 tools/perf/util/bpf-filter.c                       |   22 +-
 tools/perf/util/cap.c                              |    4 +-
 tools/perf/util/cap.h                              |    3 +-
 tools/perf/util/capstone.c                         |   13 +-
 tools/perf/util/compress.h                         |    6 +-
 tools/perf/util/cs-etm.c                           |   85 +-
 tools/perf/util/data-convert-json.c                |    1 +
 tools/perf/util/dso.c                              |   48 +-
 tools/perf/util/dso.h                              |   57 +-
 tools/perf/util/evsel.c                            |    2 +-
 tools/perf/util/hist.h                             |    8 +-
 tools/perf/util/intel-bts.c                        |    2 +-
 tools/perf/util/intel-pt.c                         |    2 +-
 tools/perf/util/libbfd.c                           |   23 +-
 tools/perf/util/machine.c                          |   43 +-
 tools/perf/util/metricgroup.c                      |    7 +-
 tools/perf/util/python.c                           |   66 +-
 tools/perf/util/sort.c                             |  167 +-
 tools/perf/util/symbol.c                           |    3 +-
 tools/perf/util/synthetic-events.c                 |    6 +-
 tools/perf/util/thread-stack.c                     |    2 +-
 tools/perf/util/trace-event-read.c                 |   33 +-
 tools/perf/util/util.c                             |   12 +-
 tools/perf/util/zstd.c                             |   40 +-
 tools/sched_ext/include/scx/compat.bpf.h           |  110 +-
 tools/sched_ext/scx_flatcg.bpf.c                   |   29 +-
 tools/sched_ext/scx_qmap.bpf.c                     |   16 +-
 tools/scripts/Makefile.include                     |   37 +-
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
 tools/testing/selftests/bpf/README.rst             |    4 +-
 tools/testing/selftests/bpf/network_helpers.c      |   10 +-
 tools/testing/selftests/bpf/network_helpers.h      |    5 +
 .../selftests/bpf/prog_tests/global_map_resize.c   |    8 +-
 .../selftests/bpf/prog_tests/lwt_ip_encap.c        |  152 +-
 tools/testing/selftests/bpf/prog_tests/mptcp.c     |   13 +-
 tools/testing/selftests/bpf/prog_tests/sha256.c    |    4 +-
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    3 +
 tools/testing/selftests/bpf/progs/mptcpify.c       |    2 +-
 .../selftests/bpf/progs/test_lwt_ip_encap.c        |  155 +-
 tools/testing/selftests/bpf/test_progs.c           |   11 +-
 tools/testing/selftests/bpf/test_sockmap.c         |    3 +-
 tools/testing/selftests/bpf/veristat.c             |   76 +-
 tools/testing/selftests/bpf/vmtest.sh              |   13 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |    5 +-
 tools/testing/selftests/kselftest_harness.h        |   14 +-
 tools/testing/selftests/lsm/common.c               |    4 +-
 tools/testing/selftests/mm/cow.c                   |    9 +-
 tools/testing/selftests/mm/ksm_tests.c             |  206 +-
 tools/testing/selftests/mm/memfd_secret.c          |   30 +-
 tools/testing/selftests/proc/proc-maps-race.c      |    3 +-
 tools/testing/selftests/proc/proc-pidns.c          |    1 +
 .../selftests/rseq/rseq-x86-thread-pointer.h       |    4 +-
 .../selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c  |   20 +-
 .../selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c |   13 +-
 tools/testing/selftests/sched_ext/exit.c           |    1 +
 tools/testing/selftests/sched_ext/prog_run.c       |   36 +-
 tools/testing/selftests/timers/leap-a-day.c        |   19 +-
 tools/testing/selftests/vDSO/vgetrandom-chacha.S   |    2 +-
 tools/testing/selftests/zram/zram_lib.sh           |    2 +-
 virt/kvm/kvm_main.c                                |   18 +-
 1613 files changed, 30327 insertions(+), 15639 deletions(-)


