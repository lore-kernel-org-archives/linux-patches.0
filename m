Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDF42210C2;
	Thu, 12 Dec 2024 17:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023619; cv=none; b=DAH//zqYtqZm+Kk7AY9WfhSjF5NerVdLfY5rS0/jS32Ugp32GfFSTt8q+KBK9pHMMHwhPMwyIvPsjH8n/euVhJ92psg4f2UKWfHn7CjYNgFaZHTpW9Ed7heoe55aYBEXupvluObSmJeO6uXvttMl4cvdGn9eLuCkTZvlzDQaKsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023619; c=relaxed/simple;
	bh=4gRFBVHTatN+OqcmYzT1nA4NvisDaYdR7p4/qKQhkX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fAyL5wGE3MORNAcYpMETRsUyTtxdb/apTcg+I4o3nYJMRyUyPgXcu/8k1kbeaYwe4AP52JCPifl9jNfWRlVeNrN7LMFbMkBFeu6NdWa2BS0lGfS5n9fbdm1Pa0CzO3V+J8/fJqccTDvmKcNQkU99tF/Aej9lwGsBHhUNgoe0hUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADAobUTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADAobUTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5135AC4CED0;
	Thu, 12 Dec 2024 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023619;
	bh=4gRFBVHTatN+OqcmYzT1nA4NvisDaYdR7p4/qKQhkX0=;
	h=From:To:Cc:Subject:Date:From;
	b=ADAobUTfwE35VFj+Oh1Yd0HKhc2LO0SwdNkTFQ9DkBW3sLU1krJK1sT8tB7q4JdOH
	 fhFerANu2hrFxqFSPvRYnrnBsks/vPXI+idGsdCsUwX14Zd/S7OrsjDFVVSsrAV73I
	 5PlbG5USUHcD+Daf1bjqCdd/jfhGrr9PtHBK+fZE=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 5.10 000/459] 5.10.231-rc1 review
Date: Thu, 12 Dec 2024 15:55:38 +0100
Message-ID: <20241212144253.511169641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.231-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.231-rc1
X-KernelTest-Deadline: 2024-12-14T14:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.231 release.
There are 459 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.231-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.231-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    octeontx2-pf: Fix otx2_get_fecparam()

David S. Miller <davem@davemloft.net>
    octeontx2: Fix condition.

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Require entities to have a non-zero unique ID

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix out of bounds reads when finding clock sources

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: core: Fix scsi_mode_select() buffer length handling

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: sd: Fix sd_do_mode_sense() buffer length handling

Damien Le Moal <dlemoal@kernel.org>
    PCI: rockchip-ep: Fix address translation unit programming

Zhang Zekun <zhangzekun11@huawei.com>
    Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"

Thomas Gleixner <tglx@linutronix.de>
    modpost: Add .irqentry.text to OTHER_SECTIONS

Heming Zhao <heming.zhao@suse.com>
    ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check BIOS images before it is used

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix STALL transfer event handling

Richard Weinberger <richard@nod.at>
    jffs2: Fix rtime decompressor

Kinsey Moore <kinsey.moore@oarcorp.com>
    jffs2: Prevent rtime decompress memory corruption

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device

Jing Zhang <jingzhangos@google.com>
    KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "unicode: Don't special case ignorable code points"

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing snapshot drew unlock when root is dead during swap activation

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Prevent wakeup of ksoftirqd during idle load balance

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy

Valentin Schneider <valentin.schneider@arm.com>
    sched/fair: Add NOHZ balancer flag for nohz.next_balance updates

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Trigger the update of blocked load on newly idle cpu

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Merge for each idle cpu loop of ILB

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Remove unused parameter of update_nohz_stats

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Remove update of blocked load from newidle_balance

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Remove the unnecessary need_resched() check in nohz_csd_func()

Parker Newman <pnewman@connecttech.com>
    misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/prom_init: Fixup missing powermac #size-cells

Xi Ruoyao <xry111@xry111.site>
    MIPS: Loongson64: DTS: Really fix PCIe port nodes for ls7a

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: handle USB Error Interrupt if IOC not set

Defa Li <defa.li@mediatek.com>
    i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock

Mengyuan Lou <mengyuanlou@net-swift.com>
    PCI: Add ACS quirk for Wangxun FF5xxx NICs

Keith Busch <kbusch@kernel.org>
    PCI: Add 'reset_subordinate' to reset hierarchy below bridge

Qi Han <hanqi@vivo.com>
    f2fs: fix f2fs_bug_on when uninstalling filesystem call f2fs_evict_inode.

Yi Yang <yiyang13@huawei.com>
    nvdimm: rectify the illogical code within nd_dax_probe()

Barnabás Czémán <barnabas.czeman@mainlining.org>
    pinctrl: qcom-pmic-gpio: add support for PM8937

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Don't modify unknown block number in MTIOCGET

Mukesh Ojha <quic_mojha@quicinc.com>
    leds: class: Protect brightness_show() with led_cdev->led_access mutex

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add cond_resched() for no forced preemption model

Uros Bizjak <ubizjak@gmail.com>
    tracing: Use atomic64_inc_return() in trace_clock_counter()

Esben Haabendal <esben@geanix.com>
    pinctrl: freescale: fix COMPILE_TEST error with PINCTRL_IMX_SCU

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in __netpoll_setup

Jakub Kicinski <kuba@kernel.org>
    net/neighbor: clear error in case strict check is not set

Dmitry Antipov <dmantipov@yandex.ru>
    rocker: fix link status detection in rocker_carrier_init()

Jonas Karlman <jonas@kwiboo.se>
    ASoC: hdmi-codec: reorder channel allocation list

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e123 to device tables

Norbert van Bolhuis <nvbolhuis@gmail.com>
    wifi: brcmfmac: Fix oops due to NULL pointer dereference in brcmf_sdiod_sglist_rw()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    wifi: ipw2x00: libipw_rx_any(): fix bad alignment

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: set the right AMDGPU sg segment limitation

Victor Zhao <Victor.Zhao@amd.com>
    drm/amdgpu: skip amdgpu_device_cache_pci_state under sriov

Nihar Chaithanya <niharchaithanya@gmail.com>
    jfs: add a check to prevent array-index-out-of-bounds in dbAdjTree

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: fix array-index-out-of-bounds in jfs_readdir

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: fix shift-out-of-bounds in dbSplit

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: array-index-out-of-bounds fix in dtReadFirst

Levi Yun <yeoreum.yun@arm.com>
    dma-debug: fix a possible deadlock on radix_lock

Lang Yu <lang.yu@amd.com>
    drm/amdgpu: refine error handling in amdgpu_ttm_tt_pin_userptr

Rosen Penev <rosenp@gmail.com>
    wifi: ath5k: add PCI ID for Arcadyan devices

Rosen Penev <rosenp@gmail.com>
    wifi: ath5k: add PCI ID for SX76X

Ignat Korchagin <ignat@cloudflare.com>
    net: inet6: do not leave a dangling sk pointer in inet6_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: inet: do not leave a dangling sk pointer in inet_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: ieee802154: do not leave a dangling sk pointer in ieee802154_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: af_can: do not leave a dangling sk pointer in can_create()

Ignat Korchagin <ignat@cloudflare.com>
    Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()

Ignat Korchagin <ignat@cloudflare.com>
    af_packet: avoid erroring out after sock_init_data() in packet_create()

Elena Salomatkina <esalomatkina@ispras.ru>
    net/sched: cbs: Fix integer overflow in cbs_set_port_rate()

Simon Horman <horms@kernel.org>
    net: ethernet: fs_enet: Use %pa to format resource_size_t

Simon Horman <horms@kernel.org>
    net: fec_mpc52xx_phy: Use %pa to format resource_size_t

Zhu Jun <zhujun2@cmss.chinamobile.com>
    samples/bpf: Fix a resource leak

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't apply UDP padding quirk on RTL8126A

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()

Liao Chen <liaochen4@huawei.com>
    drm/mcde: Enable module autoloading

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO 2 model

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Set AXI panic modes for the HVS

Rohan Barar <rohan.barar@gmail.com>
    media: cx231xx: Add support for Dexatek USB Video Grabber 1d19:6108

David Given <dg@cowlark.com>
    media: uvcvideo: Add a quirk for the Kaiweets KTI-W02 infrared camera

Marco Elver <elver@google.com>
    kcsan: Turn report_filterlist_lock into a raw_spinlock

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Don't leak pipe fds in pac.exec_sign_all()

Qu Wenruo <wqu@suse.com>
    btrfs: avoid unnecessary device path update for the same device

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Handle CPU hotplug remove during sampling

Pratyush Brahma <quic_pbrahma@quicinc.com>
    iommu/arm-smmu: Defer probe of clients after smmu device bound

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: update seq_file index in ocfs2_dlm_seq_next

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Further prevent card detect during shutdown

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-pci: Add DMI quirk for missing CD GPIO on Vexia Edu Atla 10 tablet

Cosmin Tanislav <demonsingur@gmail.com>
    regmap: detach regmap from dev on regmap_exit

Christian König <christian.koenig@amd.com>
    dma-buf: fix dma_fence_array_signaled v4

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    bpf: fix OOB devmap writes when deleting elements

Liequan Che <cheliequan@inspur.com>
    bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free on unload

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Supported speed displayed incorrectly for VPorts

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix NVMe and NPIV connect issue

Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>
    ALSA: hda/realtek: Add support for Samsung Galaxy Book3 360 (NP730QFG)

Nazar Bilinskyi <nbilinskyi@gmail.com>
    ALSA: hda/realtek: Enable mute and micmute LED on HP ProBook 430 G8

Marie Ramlow <me@nycode.dev>
    ALSA: usb-audio: add mixer mapping for Corsair HS80

Mark Rutland <mark.rutland@arm.com>
    arm64: ptrace: fix partial SETREGSET for NT_ARM_TAGGED_ADDR_CTRL

Kuan-Wei Chiu <visitorckw@gmail.com>
    tracing: Fix cmp_entries_dup() to respect sort() comparison rules

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    watchdog: rti: of: honor timeout-sec property

WangYuli <wangyuli@uniontech.com>
    HID: wacom: fix when get product name maybe null pointer

Hou Tao <houtao1@huawei.com>
    bpf: Fix exact match conditions in trie_get_next_key()

Hou Tao <houtao1@huawei.com>
    bpf: Handle BPF_EXIST and BPF_NOEXIST for LPM trie

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ocfs2: free inode when ocfs2_get_init_inode() fails

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mpc52xx: Add cancel_work_sync before module remove

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Fix the sk_mem_uncharge logic in tcp_bpf_sendmsg

Pei Xiao <xiaopei01@kylinos.cn>
    drm/sti: Add __iomem for mixer_dbg_mxn's parameter

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix dynamic address leak when 'assigned-address' is present

Frank Li <Frank.Li@nxp.com>
    i3c: master: Extend address status bit to 4 and add I3C_ADDR_SLOT_EXT_DESIRED

Frank Li <Frank.Li@nxp.com>
    i3c: master: Replace hard code 2 with macro I3C_ADDR_SLOT_STATUS_BITS

Jamie Iles <quic_jiles@quicinc.com>
    i3c: fix incorrect address slot lookup on 64-bit

Michal Simek <michal.simek@amd.com>
    dt-bindings: serial: rs485: Fix rs485-rts-delay property

Lino Sanfilippo <l.sanfilippo@kunbus.com>
    dt_bindings: rs485: Correct delay values

Charles Han <hanchunchao@inspur.com>
    gpio: grgpio: Add NULL check in grgpio_probe

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: grgpio: use a helper variable to store the address of ofdev->dev

Eric Dumazet <edumazet@google.com>
    geneve: do not assume mac header is set in geneve_xmit_skb()

Kory Maincent <kory.maincent@bootlin.com>
    ethtool: Fix wrong mod state in case of verbose and no_mask bitset

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: skip duplicated elements pending gc run

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Hold module reference while requesting a module

Xin Long <lucien.xin@gmail.com>
    net: sched: fix erspan_opt settings in cls_flower

Yuan Can <yuancan@huawei.com>
    igb: Fix potential invalid memory access in igb_init_module()

Louis Leseur <louis.leseur@gmail.com>
    net/qed: allow old cards not supporting "num_images" to work

Kuniyuki Iwashima <kuniyu@amazon.com>
    tipc: Fix use-after-free of kernel socket in cleanup_bearer().

Ivan Solodovnikov <solodovnikov.ia@phystech.edu>
    dccp: Fix memory leak in dccp_feat_change_recv

Jiri Wiesner <jwiesner@suse.de>
    net/ipv6: release expired exception dst cached in socket

Dmitry Antipov <dmantipov@yandex.ru>
    can: j1939: j1939_session_new(): fix skb reference counting

Eric Dumazet <edumazet@google.com>
    net: hsr: avoid potential out-of-bound access in fill_frame_info()

Martin Ottens <martin.ottens@fau.de>
    net/sched: tbf: correct backlog statistic for GSO packets

Ajay Kaher <ajay.kaher@broadcom.com>
    ptp: Add error handling for adjfine callback in ptp_clock_adjtime

Dmitry Antipov <dmantipov@yandex.ru>
    netfilter: x_tables: fix LED ID check in led_tg_check()

Jinghao Jia <jinghao7@illinois.edu>
    ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()

Oleksandr Ocheretnyi <oocheret@cisco.com>
    iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: flush shader L1 cache after user commandstream

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()

Yang Erkun <yangerkun@huawei.com>
    nfsd: fix nfs4_openowner leak when concurrent nfsd4_open occur

Yang Erkun <yangerkun@huawei.com>
    nfsd: make sure exp active before svc_export_show

Yuan Can <yuancan@huawei.com>
    dm thin: Add missing destroy_work_on_stack()

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Add link up check to ks_pcie_other_map_bus()

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Fix hibern8 notify callbacks

Alexandru Ardelean <aardelean@baylibre.com>
    util_macros.h: fix/rework find_closest() macros

Zicheng Qu <quzicheng@huawei.com>
    ad7780: fix division by zero in ad7780_write_raw()

Filipe Manana <fdmanana@suse.com>
    btrfs: ref-verify: fix use-after-free after invalid ref action

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    quota: flush quota_release_work upon quota writeback

Gustavo A. R. Silva <gustavoars@kernel.org>
    octeontx2-pf: Fix out-of-bounds read in otx2_get_fecparam()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: fix the naming style for mask definition

Dan Carpenter <dan.carpenter@linaro.org>
    sh: intc: Fix use-after-free bug in register_intc_controller()

Liu Jian <liujian56@huawei.com>
    sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Replace internal use of SOCKWQ_ASYNC_NOSPACE

Thiago Rafael Becker <trbecker@gmail.com>
    sunrpc: remove unnecessary test in rpc_task_set_client()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Convert rpc_client refcount to use refcount_t

Calum Mackay <calum.mackay@oracle.com>
    SUNRPC: correct error code comment in xs_tcp_setup_socket()

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when mounting nfs

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove incorrect code in do_eisa_entry()

Maxime Chevallier <maxime.chevallier@bootlin.com>
    rtc: ab-eoz9: don't fail temperature reads on undervoltage notification

Alex Zenla <alex@edera.dev>
    9p/xen: fix release of IRQ

Alex Zenla <alex@edera.dev>
    9p/xen: fix init sequence

Christoph Hellwig <hch@lst.de>
    block: return unsigned int from bdev_io_min

Qingfang Deng <qingfang.deng@siflower.com.cn>
    jffs2: fix use of uninitialized variable

Waqar Hameed <waqar.hameed@axis.com>
    ubifs: authentication: Fix use-after-free in ubifs_tnc_end_commit

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix duplicate slab cache names while attaching

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Correct the total block count by deducting journal reservation

Yongliang Gao <leonylgao@tencent.com>
    rtc: check if __rtc_read_time was successful in rtc_timer_do_work()

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    rtc: abx80x: Fix WDT bit position of the status register

Jinjie Ruan <ruanjinjie@huawei.com>
    rtc: st-lpc: Use IRQF_NO_AUTOEN flag in request_irq()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.0: Fix a use-after-free problem in the asynchronous open()

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Always dump trace for specified task in show_stack

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the return value of elf_core_copy_task_fpregs

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix potential integer overflow during physmem setup

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Propagate TX failures in intentless mode as well

Yang Erkun <yangerkun@huawei.com>
    SUNRPC: make sure cache entry active before cache_show

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a potential integer overflow

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    lib: string_helpers: silence snprintf() output truncation warning

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix looping of queued SG entries

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix checking for number of TRBs left

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply quirk for Medion E15433

Dinesh Kumar <desikumar81@gmail.com>
    ALSA: hda/realtek: Fix Internal Speaker and Mic boost of Infinix Y4 Max

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Set PCBeep to default value for ALC274

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC225 depop procedure

Hans Verkuil <hverkuil@xs4all.nl>
    media: v4l2-core: v4l2-dv-timings: check cvt/gtf result

Qiu-ji Chen <chenqiuji666@gmail.com>
    media: wl128x: Fix atomicity violation in fmc_send_cmd()

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Interpret tilt data from Intuos Pro BT as signed values

Muchun Song <songmuchun@bytedance.com>
    block: fix ordering between checking BLK_MQ_S_STOPPED request adding

Will Deacon <will@kernel.org>
    arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled

Huacai Chen <chenhuacai@loongson.cn>
    sh: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Do not use drvdata in release

Bin Liu <b-liu@ti.com>
    serial: 8250: omap: Move pm_runtime_get_sync

Tiwei Bie <tiwei.btw@antgroup.com>
    um: net: Do not use drvdata in release

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Do not use drvdata in release

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: wl: Put source PEB into correct list if trying locking LEB failed

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    platform/chrome: cros_ec_typec: fix missing fwnode reference decrement

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    spi: Fix acpi deferred irq probe

Jeongjun Park <aha310510@gmail.com>
    netfilter: ipset: add missing range check in bitmap_ip_uadt

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Michal Vrastil <michal.vrastil@hidglobal.com>
    Revert "usb: gadget: composite: fix OS descriptors w_value logic"

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Fix double free in driver API bus_register()

Andrej Shadura <andrew.shadura@collabora.co.uk>
    Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix uninit-value in __exfat_get_dentry_set

Ahmed Ehab <bottaawesome633@gmail.com>
    locking/lockdep: Avoid creating new name string literals in lockdep_set_subclass()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    tty: ldsic: fix tty_ldisc_autoload sysctl's proc_handler

Jinjie Ruan <ruanjinjie@huawei.com>
    apparmor: test: Fix memory leak for aa_unpack_strdup()

Jann Horn <jannh@google.com>
    comedi: Flush partial mappings in error case

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix sending inotify event with unexpected filename

Lukas Wunner <lukas@wunner.de>
    PCI: Fix use-after-free of slot->bus on hot remove

Raghavendra Rao Ananta <rananta@google.com>
    KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - access 32-bit arguments as 32-bit

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix buffer full but size is 0 case

Qiu-ji Chen <chenqiuji666@gmail.com>
    ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()

Artem Sadovnikov <ancowi69@gmail.com>
    jfs: xattr: check invalid xattr size more strictly

Theodore Ts'o <tytso@mit.edu>
    ext4: fix FS_IOC_GETFSMAP handling

Jeongjun Park <aha310510@gmail.com>
    ext4: supress data-race warnings in ext4_free_inodes_{count,set}()

Benoît Sevens <bsevens@google.com>
    ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices

Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
    soc: qcom: socinfo: fix revision check in qcom_socinfo_probe()

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-spear: fix call balance of sehci clk handling routines

Qiu-ji Chen <chenqiuji666@gmail.com>
    xen: Fix the issue of resource not being properly released in xenbus_dev_probe()

chao liu <liuzgyid@outlook.com>
    apparmor: fix 'Do simple duplicate message elimination'

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC256 depop procedure

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add type for ALC287

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: clean up TIOCGSERIAL

Jinjie Ruan <ruanjinjie@huawei.com>
    misc: apds990x: Fix missing pm_runtime_disable()

Edward Adam Davis <eadavis@qq.com>
    USB: chaoskey: Fix possible deadlock chaoskey_list_lock

Oliver Neukum <oneukum@suse.com>
    USB: chaoskey: fail open after removal

Oliver Neukum <oneukum@suse.com>
    usb: yurex: make waiting on yurex_write interruptible

Jeongjun Park <aha310510@gmail.com>
    usb: using mutex lock and supporting O_NONBLOCK flag in iowarrior_read()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: light: al3010: Fix an error handling path in al3010_probe()

Paolo Abeni <pabeni@redhat.com>
    ipmr: fix tables suspicious RCU usage

Eric Dumazet <edumazet@google.com>
    ipmr: convert /proc handlers to rcu_read_lock()

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    bnxt_en: Reserve rings after PCIe AER recovery if NIC interface is down

Eric Dumazet <edumazet@google.com>
    net: hsr: fix hsr_init_sk() vs network/transport headers.

Alexander Lobakin <alobakin@pm.me>
    net: introduce a netdev feature for UDP GRO forwarding

Csókás, Bence <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Fix register name in verbose logging function

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken

Vitalii Mordan <mordan@ispras.ru>
    marvell: pxa168_eth: fix call balance of pep->clk handling routines

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration

Pavan Chebbi <pavan.chebbi@broadcom.com>
    tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device

Barnabás Czémán <barnabas.czeman@mainlining.org>
    power: supply: bq27xxx: Fix registers of bq27426

Hermes Zhang <chenhuiz@axis.com>
    power: supply: bq27xxx: Support CHARGE_NOW for bq27z561/bq28z610/bq34z100

Bart Van Assche <bvanassche@acm.org>
    power: supply: core: Remove might_sleep() from power_supply_put()

Randy Dunlap <rdunlap@infradead.org>
    fs_parser: update mount_api doc to match function signature

Avihai Horon <avihaih@nvidia.com>
    vfio/pci: Properly hide first-in-list PCIe extended capability

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix suboptimal range on iotlb iteration

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsd4_shutdown_copy()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent NULL dereference in nfsd4_process_cb_update()

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: qcom_q6v5_mss: Re-order writes to the IMEM region

Jonathan Marek <jonathan@marek.ca>
    rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Fix GLINK command prefix

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Send READ_NOTIFY command in FIFO full case

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Add TX_DATA_CONT command while sending

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Avoid garbage when not printing a syscall's arguments

Benjamin Peterson <benjamin@engflow.com>
    perf trace: Do not lose last events in a race

Antonio Quartulli <antonio@mandelbit.com>
    m68k: coldfire/device.c: only build FEC when HW macros are defined

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x

Benjamin Peterson <benjamin@engflow.com>
    perf trace: avoid garbage when not printing a trace event's arguments

Yongpeng Yang <yangyongpeng1@oppo.com>
    f2fs: check curseg->inited before write_sum_page in change_curseg

Christoph Hellwig <hch@lst.de>
    f2fs: remove the unused flush argument to change_curseg

Christoph Hellwig <hch@lst.de>
    f2fs: open code allocate_segment_by_default

Christoph Hellwig <hch@lst.de>
    f2fs: remove struct segment_allocation default_salloc_ops

Chao Yu <chao@kernel.org>
    f2fs: avoid using native allocate_segment_by_default()

LongPing Wei <weilongping@oppo.com>
    f2fs: fix the wrong f2fs_bug_on condition in f2fs_do_replace_block

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: cpqphp: Fix PCIBIOS_* return value confusion

weiyufeng <weiyufeng@kylinos.cn>
    PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads

Leo Yan <leo.yan@arm.com>
    perf probe: Correct demangled symbols in C++ program

Ian Rogers <irogers@google.com>
    perf probe: Fix libdw memory leak

James Clark <james.clark@linaro.org>
    perf cs-etm: Don't flush when packet_queue fills up

Nuno Sa <nuno.sa@analog.com>
    clk: clk-axi-clkgen: make sure to enable the AXI bus clock

Alexandru Ardelean <alexandru.ardelean@analog.com>
    clk: axi-clkgen: use devm_platform_ioremap_resource() short-hand

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: clock: axi-clkgen: include AXI clk

Alexandru Ardelean <alexandru.ardelean@analog.com>
    dt-bindings: clock: adi,axi-clkgen: convert old binding to yaml format

Zhen Lei <thunder.leizhen@huawei.com>
    fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev/sh7760fb: Alloc DMA memory from hardware device

Zhang Zekun <zhangzekun11@huawei.com>
    powerpc/kexec: Fix return of uninitialized variable

Michal Suchanek <msuchanek@suse.de>
    powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix uninitialized value in ocfs2_file_read_iter()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix NULL pointer derefernce in hns_roce_map_mr_sg()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()

Zeng Heng <zengheng4@huawei.com>
    scsi: fusion: Remove unused variable 'rc'

Ye Bin <yebin10@huawei.com>
    scsi: bfa: Fix use-after-free in bfad_im_module_exit()

Zhang Changzhong <zhangchangzhong@huawei.com>
    mfd: rt5033: Fix missing regmap_del_irq_chip()

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix dtl_access_lock to be a rw_semaphore

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: atmel: Fix possible memory leak

Yuan Can <yuancan@huawei.com>
    cpufreq: loongson2: Unregister platform_driver on failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for PMIC devices

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for TMU device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use dev_err_probe()

Marcus Folkesson <marcus.folkesson@gmail.com>
    mfd: da9052-spi: Change read-mask to write-mask

Jinjie Ruan <ruanjinjie@huawei.com>
    mfd: tps65010: Use IRQF_NO_AUTOEN flag in request_irq() to fix race

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Flag VDSO64 entry points as functions

Levi Yun <yeoreum.yun@arm.com>
    trace/trace_event_perf: remove duplicate samples on the first tracepoint event

Hangbin Liu <liuhangbin@gmail.com>
    wireguard: selftests: load nf_conntrack if not present

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in netpoll_poll_lock

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: fix use-after-free in device_for_each_child()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    driver core: Introduce device_find_any_child() helper

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Release resources at card release

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: us122l: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Use snd_card_free_when_closed() at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Cleanup probe and disconnect callbacks

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Coding style fixes

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Fix spaces

Mingwei Zheng <zmw12306@gmail.com>
    net: rfkill: gpio: Add check for clk_enable()

Yuan Can <yuancan@huawei.com>
    drm/amdkfd: Fix wrong usage of INIT_WORK()

Paolo Abeni <pabeni@redhat.com>
    selftests: net: really check for bg process completion

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Fix sk_msg_reset_curr

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_pop_data

Zijian Zhang <zijianzhang@bytedance.com>
    bpf, sockmap: Several fixes to bpf_msg_push_data

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Add push/pop checking for msg_verify_data in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix total_bytes in msg_loop_rx in test_sockmap

Liu Jian <liujian56@huawei.com>
    selftests, bpf: Add one test for sockmap with strparser

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix SENDPAGE data logic in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Add txmsg_pass to pull/push/pop in test_sockmap

Maurice Lambert <mauricelambert434@gmail.com>
    netlink: typographical error in nlmsg_type constants definition

Zichen Xie <zichenxie0106@gmail.com>
    drm/msm/dpu: cast crtc_clk calculation to u64 in _dpu_core_perf_calc_clk()

Yuan Can <yuancan@huawei.com>
    wifi: wfx: Fix error handling in wfx_core_init()

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: hold GPU lock across perfmon sampling

Doug Brown <doug@schmorgal.com>
    drm/etnaviv: fix power register offset on GC300

Marc Kleine-Budde <mkl@pengutronix.de>
    drm/etnaviv: dump: fix sparse warnings

Xiaolei Wang <xiaolei.wang@windriver.com>
    drm/etnaviv: Request pages from DMA32 zone on addressing_limited

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: rework linear window offset calculation

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()

Steven Price <steven.price@arm.com>
    drm/panfrost: Remove unused id_mask from struct panfrost_model

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c

Christina Jacob <cjacob@marvell.com>
    octeontx2-pf: ethtool fec mode support

Felix Manlunas <fmanlunas@marvell.com>
    octeontx2-af: Add new CGX_CMD to get PHY FEC statistics

Christina Jacob <cjacob@marvell.com>
    octeontx2-af: forward error correction configuration

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-pf: Calculate LBK link instead of hardcoding

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Mbox changes for 98xx

Matthias Schiffer <matthias.schiffer@tq-group.com>
    drm: fsl-dcu: enable PIXCLK on LS1021A

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fsl-dcu: Convert to Linux IRQ interfaces

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix txmsg_redir of test_txmsg_pull in test_sockmap

Zijian Zhang <zijianzhang@bytedance.com>
    selftests/bpf: Fix msg_verify_data in test_sockmap

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: tc358767: Fix link properties discovery

Hangbin Liu <liuhangbin@gmail.com>
    netdevsim: copy addresses for both in and out paths

Leon Romanovsky <leon@kernel.org>
    netdevsim: rely on XFRM state direction instead of flags

Leon Romanovsky <leon@kernel.org>
    xfrm: store and rely on direction to construct offload flags

Leon Romanovsky <leon@kernel.org>
    xfrm: rename xfrm_state_offload struct to allow reuse

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix the xdp_adjust_tail sample prog issue

Macpaul Lin <macpaul.lin@mediatek.com>
    ASoC: dt-bindings: mt6359: Update generic node name and dmic-mode

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: fix regmap_write_bits usage

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: fsl_micfil: use GENMASK to define register bit fields

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: fsl_micfil: do not define SHIFT/MASK for single bits

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: fsl_micfil: Drop unnecessary register read

Igor Prusov <ivprusov@salutedevices.com>
    dt-bindings: vendor-prefixes: Add NeoFidelity, Inc

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss2

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: fix invalid VHT parameters in supported_vht_mcs_rate_nss1

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Address race-condition in MMU flush

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/imx/dcss: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    wifi: p54: Use IRQF_NO_AUTOEN flag in request_irq()

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix locking in omap_gem_new_dmabuf()

Jeongjun Park <aha310510@gmail.com>
    wifi: ath9k: add range check for conn_rsp_epid in htc_connect_service()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused

Li Huafei <lihuafei1@huawei.com>
    media: atomisp: Add check for rgby_data memory allocation failure

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: atomisp: remove #ifdef HAS_NO_HMEM

Luo Qiu <luoqiu@kylinsec.com.cn>
    firmware: arm_scpi: Check the DVFS OPP count returned by the firmware

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Protect against array overrun during iMC config parsing

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: irq: Set lockdep class for hierarchical IRQ domains

Zhang Zekun <zhangzekun11@huawei.com>
    pmdomain: ti-sci: Add missing of_node_put() for args.np

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: cubieboard4: Fix DCDC5 regulator constraints

Clark Wang <xiaoning.wang@nxp.com>
    pwm: imx27: Workaround of the pwm output bug when decrease the duty cycle

Chen Ridong <chenridong@huawei.com>
    cgroup/bpf: only cgroup v2 can be attached by bpf programs

Chen Ridong <chenridong@huawei.com>
    Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm-hana: Add vdd-supply to second source trackpad

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mt8183: krane: Fix the address of eeprom at i2c4

Gregory Price <gourry@gourry.net>
    tpm: fix signed/unsigned bug when checking event logs

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mmc: mmc_spi: drop buggy snprintf()

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: geni-se: fix array underflow in geni_se_clk_tbl_get()

Jinjie Ruan <ruanjinjie@huawei.com>
    soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()

Alexander Stein <alexander.stein@ew.tq-group.com>
    spi: spi-fsl-lpspi: downgrade log level for pio mode

Mark Brown <broonie@kernel.org>
    clocksource/drivers:sp804: Make user selectable

Arnd Bergmann <arnd@arndb.de>
    clkdev: remove CONFIG_CLKDEV_LOOKUP

Marco Elver <elver@google.com>
    kcsan, seqlock: Fix incorrect assumption in read_seqbegin()

Miguel Ojeda <ojeda@kernel.org>
    time: Fix references to _msecs_to_jiffies() handling of values

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Chen Ridong <chenridong@huawei.com>
    crypto: bcm - add error check in the ahash_hmac_init function

Chen Ridong <chenridong@huawei.com>
    crypto: caam - add error check to caam_rsa_set_priv_key_form

Everest K.C <everestkc@everestkc.com.np>
    crypto: cavium - Fix the if condition to exit loop after timeout

Yi Yang <yiyang13@huawei.com>
    crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY

Priyanka Singh <priyanka.singh@nxp.com>
    EDAC/fsl_ddr: Fix bad bit shift operations

David Thompson <davthompson@nvidia.com>
    EDAC/bluefield: Fix potential integer overflow

Yuan Can <yuancan@huawei.com>
    firmware: google: Unregister driver_info on failure

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: caam - Fix the pointer passed to caam_qi_shutdown()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    hfsplus: don't query the device logical block size multiple times

Masahiro Yamada <masahiroy@kernel.org>
    s390/syscalls: Avoid creation of arch/arch/ directory

Aleksandr Mishin <amishin@t-argos.ru>
    acpi/arm64: Adjust error handling procedure in gtdt_parse_timer_block()

Masahiro Yamada <masahiroy@kernel.org>
    arm64: fix .data.rel.ro size assertion when CONFIG_LTO_CLANG

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Reinstate early console

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: mvme16x: Add and use "mvme16x.h"

Daniel Palmer <daniel@0x0f.com>
    m68k: mvme147: Fix SCSI controller IRQ numbers

Christoph Hellwig <hch@lst.de>
    nvme-pci: fix freeing of the HMB descriptor table

David Disseldorp <ddiss@suse.de>
    initramfs: avoid filename buffer overrun

Jonas Gorski <jonas.gorski@gmail.com>
    mips: asm: fix warning when disabling MIPS_FP_SUPPORT

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/xen/pvh: Annotate indirect branch as safe

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: fix printf type warnings about longs

Borislav Petkov (AMD) <bp@alien8.de>
    x86/barrier: Do not serialize MSR accesses on AMD

Puranjay Mohan <pjy@amazon.com>
    nvme: fix metadata handling in nvme-passthrough

Pali Rohár <pali@kernel.org>
    cifs: Fix buffer overflow when parsing NFS reparse points

Ard Biesheuvel <ardb@kernel.org>
    x86/stackprotector: Work around strict Clang TLS symbol requirements

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Idle tasks on offline CPUs are in quiescent states

Breno Leitao <leitao@debian.org>
    ipmr: Fix access to mfc_cache_list without lock held

Eryk Zagorski <erykzagorski@gmail.com>
    ALSA: usb-audio: Fix Yamaha P-125 Quirk Entry

David Wang <00107082@163.com>
    proc/softirqs: replace seq_printf with seq_put_decimal_ull_width

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()

Alexander Hölzl <alexander.hoelzl@gmx.net>
    can: j1939: fix error in J1939 documentation.

Mikhail Rudenko <mike.rudenko@gmail.com>
    regulator: rk808: Add apply_bit for BUCK3 on RK809

Charles Han <hanchunchao@inspur.com>
    soc: qcom: Add check devm_kasprintf() returned value

Benoît Monin <benoit.monin@gmx.fr>
    net: usb: qmi_wwan: add Quectel RG650V

Arnd Bergmann <arnd@arndb.de>
    x86/amd_nb: Fix compile-testing without CONFIG_AMD_NB

Piyush Raj Chouhan <piyushchouhan1598@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Infinix ZERO BOOK 13

Li Zhijian <lizhijian@fujitsu.com>
    selftests/watchdog-test: Fix system accidentally reset after watchdog-test

Ben Greear <greearb@candelatech.com>
    mac80211: fix user-power when emulating chanctx

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: resolve faulty mmap_region() error path behaviour

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: unconditionally close VMAs on error

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: avoid unsafe VMA hook invocation when error arises on mmap hook

Andrew Morton <akpm@linux-foundation.org>
    mm: revert "mm: shmem: fix data-race in shmem_getattr()"

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Never decrement pending_async_copies on error

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Initialize struct nfsd4_copy earlier

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Limit the number of concurrent async COPY operations

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Async COPY result needs to return a write verifier

Dai Ngo <dai.ngo@oracle.com>
    NFSD: initialize copy->cp_clp early in nfsd4_copy for use by trace point

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvbdev: fix the logic when DVB_DYNAMIC_MINORS is not set

Yang Yingliang <yangyingliang@huawei.com>
    mmc: core: fix return value check in devm_mmc_alloc_host()

Francesco Dolcini <francesco.dolcini@toradex.com>
    drm/bridge: tc358768: Fix DSI command tx

Aurelien Jarno <aurelien@aurel32.net>
    Revert "mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K"

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix UBSAN warning in ocfs2_verify_volume()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Bury Intel PT virtualization (guest/host mode) behind CONFIG_BROKEN

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix PA offset with unaligned starting iotlb map

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: uncache inode which has failed entering the group

Baoquan He <bhe@redhat.com>
    x86/mm: Fix a kdump kernel failure on SME system when CONFIG_IMA_KEXEC=y

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: kTLS, Fix incorrect page refcounting

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, lock FTE when checking if active

Jakub Kicinski <kuba@kernel.org>
    netlink: terminate outstanding dump on socket close

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: gcc-qcs404: fix initial rate of GPLL3

Michal Vokáč <michal.vokac@ysoft.com>
    leds: lp55xx: Remove redundant test for invalid channel number

guoweikang <guoweikang.kernel@gmail.com>
    ftrace: Fix regression with module command in stack_trace_filter

Vasiliy Kovalev <kovalev@altlinux.org>
    ovl: Filter invalid inodes with missing lookup function

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Stop stream during unregister

Gaosheng Cui <cuigaosheng1@huawei.com>
    media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()

Jinjie Ruan <ruanjinjie@huawei.com>
    media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()

Jinjie Ruan <ruanjinjie@huawei.com>
    media: venus: Fix pm_runtime_set_suspended() with runtime pm enabled

Li Zetao <lizetao1@huawei.com>
    media: ts2020: fix null-ptr-deref in ts2020_probe()

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: i2c: tc358743: Fix crash in the probe error path when using polling

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-pci            |   11 +
 .../devicetree/bindings/clock/adi,axi-clkgen.yaml  |   67 +
 .../devicetree/bindings/clock/axi-clkgen.txt       |   25 -
 .../devicetree/bindings/serial/rs485.yaml          |   19 +-
 .../devicetree/bindings/sound/mt6359.yaml          |   10 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 Documentation/filesystems/mount_api.rst            |    3 +-
 Documentation/networking/j1939.rst                 |    2 +-
 Makefile                                           |    4 +-
 arch/arm/Kconfig                                   |    2 -
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts        |    4 +-
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |    3 +
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi  |    8 +
 .../boot/dts/mediatek/mt8183-kukui-krane.dtsi      |    4 +-
 arch/arm64/include/asm/mman.h                      |   10 +-
 arch/arm64/kernel/process.c                        |    2 +-
 arch/arm64/kernel/ptrace.c                         |    6 +-
 arch/arm64/kernel/vmlinux.lds.S                    |    6 +-
 arch/arm64/kvm/pmu-emul.c                          |    1 -
 arch/arm64/kvm/vgic/vgic-its.c                     |   32 +-
 arch/arm64/kvm/vgic/vgic.h                         |   24 +
 arch/m68k/coldfire/device.c                        |    8 +-
 arch/m68k/include/asm/mcfgpio.h                    |    2 +-
 arch/m68k/include/asm/mvme147hw.h                  |    4 +-
 arch/m68k/kernel/early_printk.c                    |    9 +-
 arch/m68k/mvme147/config.c                         |   30 +
 arch/m68k/mvme147/mvme147.h                        |    6 +
 arch/m68k/mvme16x/config.c                         |    2 +
 arch/m68k/mvme16x/mvme16x.h                        |    6 +
 arch/mips/Kconfig                                  |    3 -
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          |   73 +-
 arch/mips/include/asm/switch_to.h                  |    2 +-
 arch/mips/pic32/Kconfig                            |    1 -
 arch/powerpc/include/asm/dtl.h                     |    4 +-
 arch/powerpc/include/asm/sstep.h                   |    5 -
 arch/powerpc/include/asm/vdso.h                    |    1 +
 arch/powerpc/kernel/prom_init.c                    |   29 +-
 arch/powerpc/kexec/file_load_64.c                  |    9 +-
 arch/powerpc/lib/sstep.c                           |   12 +-
 arch/powerpc/platforms/pseries/dtl.c               |    8 +-
 arch/powerpc/platforms/pseries/lpar.c              |    8 +-
 arch/s390/kernel/perf_cpum_sf.c                    |    4 +-
 arch/s390/kernel/syscalls/Makefile                 |    2 +-
 arch/sh/Kconfig                                    |    1 -
 arch/sh/kernel/cpu/proc.c                          |    2 +-
 arch/um/drivers/net_kern.c                         |    2 +-
 arch/um/drivers/ubd_kern.c                         |    2 +-
 arch/um/drivers/vector_kern.c                      |    3 +-
 arch/um/kernel/physmem.c                           |    6 +-
 arch/um/kernel/process.c                           |    2 +-
 arch/um/kernel/sysrq.c                             |    2 +-
 arch/x86/Makefile                                  |    3 +-
 arch/x86/crypto/aegis128-aesni-asm.S               |   29 +-
 arch/x86/entry/entry.S                             |   15 +
 arch/x86/events/intel/pt.c                         |   11 +-
 arch/x86/events/intel/pt.h                         |    2 +
 arch/x86/include/asm/amd_nb.h                      |    5 +-
 arch/x86/include/asm/asm-prototypes.h              |    3 +
 arch/x86/include/asm/barrier.h                     |   18 -
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/processor.h                   |   18 +
 arch/x86/kernel/cpu/amd.c                          |    3 +
 arch/x86/kernel/cpu/common.c                       |    9 +
 arch/x86/kernel/cpu/hygon.c                        |    3 +
 arch/x86/kernel/vmlinux.lds.S                      |    3 +
 arch/x86/kvm/vmx/vmx.c                             |    4 +-
 arch/x86/mm/ioremap.c                              |    6 +-
 arch/x86/platform/pvh/head.S                       |    2 +
 block/blk-mq.c                                     |    6 +
 block/blk-mq.h                                     |   13 +
 crypto/pcrypt.c                                    |   12 +-
 drivers/acpi/arm64/gtdt.c                          |    2 +-
 drivers/base/bus.c                                 |    2 +
 drivers/base/core.c                                |   20 +
 drivers/base/regmap/regmap-irq.c                   |    4 +
 drivers/base/regmap/regmap.c                       |   12 +
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/clk/Kconfig                                |    6 +-
 drivers/clk/Makefile                               |    3 +-
 drivers/clk/clk-axi-clkgen.c                       |   26 +-
 drivers/clk/qcom/gcc-qcs404.c                      |    1 +
 drivers/clocksource/Kconfig                        |    9 +-
 drivers/cpufreq/loongson2_cpufreq.c                |    4 +-
 drivers/crypto/bcm/cipher.c                        |    5 +-
 drivers/crypto/caam/caampkc.c                      |   11 +-
 drivers/crypto/caam/qi.c                           |    2 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |    6 +-
 drivers/dma-buf/dma-fence-array.c                  |   28 +-
 drivers/edac/bluefield_edac.c                      |    2 +-
 drivers/edac/fsl_ddr_edac.c                        |   22 +-
 drivers/firmware/arm_scpi.c                        |    3 +
 drivers/firmware/efi/tpm.c                         |   17 +-
 drivers/firmware/google/gsmi.c                     |    6 +-
 drivers/gpio/gpio-grgpio.c                         |   26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |    5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |    5 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |   14 +
 drivers/gpu/drm/bridge/tc358767.c                  |    7 +
 drivers/gpu/drm/bridge/tc358768.c                  |   21 +-
 drivers/gpu/drm/drm_mm.c                           |    2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |    6 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |    3 +-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c              |   10 +
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |   13 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  100 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |   21 +
 drivers/gpu/drm/fsl-dcu/Kconfig                    |    1 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c          |  143 +-
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h          |    3 +
 drivers/gpu/drm/imx/dcss/dcss-crtc.c               |    6 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |    6 +-
 drivers/gpu/drm/mcde/mcde_drv.c                    |    1 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |    4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |    2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   10 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |    1 -
 drivers/gpu/drm/radeon/r600_cs.c                   |    2 +-
 drivers/gpu/drm/sti/sti_mixer.c                    |    2 +-
 drivers/gpu/drm/v3d/v3d_mmu.c                      |   29 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   11 +
 drivers/hid/wacom_sys.c                            |    3 +-
 drivers/hid/wacom_wac.c                            |    4 +-
 drivers/i3c/master.c                               |   88 +-
 drivers/iio/adc/ad7780.c                           |    2 +-
 drivers/iio/light/al3010.c                         |   11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    7 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |    2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |    7 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |   11 +
 drivers/leds/led-class.c                           |   14 +-
 drivers/leds/leds-lp55xx-common.c                  |    3 -
 drivers/md/bcache/super.c                          |    2 +-
 drivers/md/dm-thin.c                               |    1 +
 drivers/media/dvb-core/dvbdev.c                    |   15 +-
 drivers/media/dvb-frontends/ts2020.c               |    8 +-
 drivers/media/i2c/adv7604.c                        |    5 +-
 drivers/media/i2c/adv7842.c                        |   13 +-
 drivers/media/i2c/tc358743.c                       |    4 +-
 drivers/media/platform/qcom/venus/core.c           |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   15 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    2 +
 drivers/media/usb/gspca/ov534.c                    |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  106 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  132 +-
 drivers/message/fusion/mptsas.c                    |    4 +-
 drivers/mfd/da9052-spi.c                           |    2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c                 |  208 +-
 drivers/mfd/rt5033.c                               |    4 +-
 drivers/mfd/tps65010.c                             |    8 +-
 drivers/misc/apds990x.c                            |   12 +-
 drivers/misc/eeprom/eeprom_93cx6.c                 |   10 +
 drivers/mmc/core/bus.c                             |    2 +
 drivers/mmc/core/core.c                            |    3 +
 drivers/mmc/core/host.c                            |    6 +-
 drivers/mmc/host/Kconfig                           |    4 +-
 drivers/mmc/host/dw_mmc.c                          |    4 +-
 drivers/mmc/host/mmc_spi.c                         |    9 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   72 +
 drivers/mmc/host/sdhci-pci.h                       |    1 +
 drivers/mtd/nand/raw/atmel/pmecc.c                 |    8 +-
 drivers/mtd/nand/raw/atmel/pmecc.h                 |    2 -
 drivers/mtd/ubi/attach.c                           |   12 +-
 drivers/mtd/ubi/wl.c                               |    9 +-
 drivers/net/can/sun4i_can.c                        |   22 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/broadcom/tg3.c                |    3 +
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    2 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |    2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   88 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    8 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   22 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   86 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   85 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   65 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |    4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.c    |    2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |    2 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   28 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |    8 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  170 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |    3 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |   14 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   19 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   14 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |    2 +
 drivers/net/geneve.c                               |    2 +-
 drivers/net/netdevsim/ipsec.c                      |   11 +-
 drivers/net/usb/lan78xx.c                          |   11 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/wireless/ath/ath10k/mac.c              |    4 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    3 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    8 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |    4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    4 +-
 drivers/nvdimm/dax_devs.c                          |    4 +-
 drivers/nvdimm/nd.h                                |    7 +
 drivers/nvme/host/core.c                           |    7 +-
 drivers/nvme/host/pci.c                            |   16 +-
 drivers/pci/controller/dwc/pci-keystone.c          |   11 +
 drivers/pci/controller/pcie-rockchip-ep.c          |   18 +-
 drivers/pci/controller/pcie-rockchip.h             |    4 +
 drivers/pci/hotplug/cpqphp_pci.c                   |   19 +-
 drivers/pci/pci-sysfs.c                            |   26 +
 drivers/pci/pci.c                                  |    2 +-
 drivers/pci/pci.h                                  |    1 +
 drivers/pci/quirks.c                               |   15 +-
 drivers/pci/slot.c                                 |    4 +-
 drivers/pinctrl/freescale/Kconfig                  |    2 +-
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |    2 +
 drivers/platform/chrome/cros_ec_typec.c            |    1 +
 drivers/platform/x86/intel_bxtwc_tmu.c             |   22 +-
 drivers/power/supply/bq27xxx_battery.c             |   72 +-
 drivers/power/supply/power_supply_core.c           |    2 -
 drivers/ptp/ptp_clock.c                            |    3 +-
 drivers/pwm/pwm-imx27.c                            |   98 +-
 drivers/regulator/rk808-regulator.c                |    2 +
 drivers/remoteproc/qcom_q6v5_mss.c                 |    3 +
 drivers/rpmsg/qcom_glink_native.c                  |  175 +-
 drivers/rtc/interface.c                            |    7 +-
 drivers/rtc/rtc-ab-eoz9.c                          |    7 -
 drivers/rtc/rtc-abx80x.c                           |    2 +-
 drivers/rtc/rtc-st-lpc.c                           |    5 +-
 drivers/scsi/bfa/bfad.c                            |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    1 +
 drivers/scsi/qedf/qedf_main.c                      |    1 +
 drivers/scsi/qedi/qedi_main.c                      |    1 +
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |   10 -
 drivers/scsi/qla2xxx/qla_mid.c                     |    1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   15 +-
 drivers/scsi/scsi_lib.c                            |   21 +-
 drivers/scsi/sd.c                                  |    7 +
 drivers/scsi/st.c                                  |   31 +-
 drivers/scsi/ufs/ufs-exynos.c                      |   16 +-
 drivers/sh/intc/core.c                             |    2 +-
 drivers/soc/qcom/qcom-geni-se.c                    |    3 +-
 drivers/soc/qcom/socinfo.c                         |    8 +-
 drivers/soc/ti/smartreflex.c                       |    4 +-
 drivers/soc/ti/ti_sci_pm_domains.c                 |    4 +
 drivers/spi/atmel-quadspi.c                        |    2 +-
 drivers/spi/spi-fsl-lpspi.c                        |   14 +-
 drivers/spi/spi-mpc52xx.c                          |    1 +
 drivers/spi/spi.c                                  |   13 +-
 drivers/staging/board/Kconfig                      |    2 +-
 drivers/staging/comedi/comedi_fops.c               |   12 +
 drivers/staging/greybus/uart.c                     |    3 -
 drivers/staging/media/allegro-dvt/allegro-core.c   |    4 +-
 .../pci/isp/kernels/bh/bh_2/ia_css_bh.host.c       |    2 -
 .../raw_aa_binning_1.0/ia_css_raa.host.c           |    2 -
 .../pci/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c  |    5 -
 .../media/atomisp/pci/runtime/binary/src/binary.c  |    4 -
 drivers/staging/media/atomisp/pci/sh_css_params.c  |   12 +-
 drivers/staging/wfx/main.c                         |   17 +-
 drivers/tty/serial/8250/8250_omap.c                |    4 +-
 drivers/tty/tty_ldisc.c                            |    2 +-
 drivers/usb/chipidea/udc.c                         |    2 +-
 drivers/usb/dwc3/gadget.c                          |   15 +-
 drivers/usb/gadget/composite.c                     |   18 +-
 drivers/usb/host/ehci-spear.c                      |    7 +-
 drivers/usb/host/xhci-dbgcap.c                     |  135 +-
 drivers/usb/host/xhci-dbgcap.h                     |    2 +-
 drivers/usb/misc/chaoskey.c                        |   35 +-
 drivers/usb/misc/iowarrior.c                       |   50 +-
 drivers/usb/misc/yurex.c                           |    5 +-
 drivers/usb/typec/tcpm/wcove.c                     |    4 -
 drivers/vdpa/mlx5/core/mr.c                        |   12 +-
 drivers/vfio/pci/vfio_pci_config.c                 |   16 +-
 drivers/video/fbdev/sh7760fb.c                     |   11 +-
 drivers/watchdog/iTCO_wdt.c                        |   21 +-
 drivers/watchdog/mtk_wdt.c                         |    6 +
 drivers/watchdog/rti_wdt.c                         |    3 +-
 drivers/xen/xenbus/xenbus_probe.c                  |    8 +-
 fs/btrfs/extent-tree.c                             |    1 -
 fs/btrfs/inode.c                                   |    1 +
 fs/btrfs/ref-verify.c                              |    1 +
 fs/btrfs/volumes.c                                 |   38 +-
 fs/cifs/smb2ops.c                                  |    6 +
 fs/exfat/namei.c                                   |    1 +
 fs/ext4/fsmap.c                                    |   54 +-
 fs/ext4/mballoc.c                                  |   18 +-
 fs/ext4/mballoc.h                                  |    1 +
 fs/ext4/super.c                                    |    8 +-
 fs/f2fs/f2fs.h                                     |    2 +-
 fs/f2fs/file.c                                     |    2 +-
 fs/f2fs/inode.c                                    |    4 +-
 fs/f2fs/segment.c                                  |   92 +-
 fs/f2fs/segment.h                                  |    6 -
 fs/hfsplus/hfsplus_fs.h                            |    3 +-
 fs/hfsplus/wrapper.c                               |    2 +
 fs/jffs2/compr_rtime.c                             |    3 +
 fs/jffs2/erase.c                                   |    7 +-
 fs/jfs/jfs_dmap.c                                  |    6 +
 fs/jfs/jfs_dtree.c                                 |   15 +
 fs/jfs/xattr.c                                     |    2 +-
 fs/nfs/internal.h                                  |    2 +-
 fs/nfs/nfs4proc.c                                  |    8 +-
 fs/nfsd/export.c                                   |    5 +-
 fs/nfsd/netns.h                                    |    1 +
 fs/nfsd/nfs4callback.c                             |   16 +-
 fs/nfsd/nfs4proc.c                                 |   43 +-
 fs/nfsd/nfs4recover.c                              |    3 +-
 fs/nfsd/nfs4state.c                                |   20 +
 fs/nfsd/xdr4.h                                     |    1 +
 fs/nilfs2/btnode.c                                 |    2 -
 fs/nilfs2/dir.c                                    |    2 +-
 fs/nilfs2/gcinode.c                                |    4 +-
 fs/nilfs2/mdt.c                                    |    1 -
 fs/nilfs2/page.c                                   |    2 +-
 fs/notify/fsnotify.c                               |   23 +-
 fs/ocfs2/aops.h                                    |    2 +
 fs/ocfs2/dlmglue.c                                 |    1 +
 fs/ocfs2/file.c                                    |    4 +
 fs/ocfs2/localalloc.c                              |   19 -
 fs/ocfs2/namei.c                                   |    4 +-
 fs/ocfs2/resize.c                                  |    2 +
 fs/ocfs2/super.c                                   |   13 +-
 fs/overlayfs/util.c                                |    3 +
 fs/proc/softirqs.c                                 |    2 +-
 fs/quota/dquot.c                                   |    2 +
 fs/ubifs/super.c                                   |    6 +-
 fs/ubifs/tnc_commit.c                              |    2 +
 fs/unicode/mkutf8data.c                            |   70 +
 fs/unicode/utf8data.h_shipped                      | 6703 ++++++++++----------
 include/linux/blkdev.h                             |    2 +-
 include/linux/device.h                             |    2 +
 include/linux/eeprom_93cx6.h                       |   11 +
 include/linux/i3c/master.h                         |    9 +-
 include/linux/jiffies.h                            |    2 +-
 include/linux/leds.h                               |    2 +-
 include/linux/lockdep.h                            |    2 +-
 include/linux/mman.h                               |    7 +-
 include/linux/netdev_features.h                    |    4 +-
 include/linux/netpoll.h                            |    2 +-
 include/linux/seqlock.h                            |   12 +-
 include/linux/sunrpc/clnt.h                        |    3 +-
 include/linux/sunrpc/xprtsock.h                    |    1 +
 include/linux/util_macros.h                        |   56 +-
 include/media/v4l2-dv-timings.h                    |   18 +-
 include/net/xfrm.h                                 |   16 +-
 include/uapi/linux/rtnetlink.h                     |    2 +-
 init/initramfs.c                                   |   15 +
 kernel/bpf/devmap.c                                |    6 +-
 kernel/bpf/lpm_trie.c                              |   27 +-
 kernel/cgroup/cgroup.c                             |   21 +-
 kernel/dma/debug.c                                 |    8 +-
 kernel/kcsan/debugfs.c                             |   74 +-
 kernel/rcu/tasks.h                                 |    2 +-
 kernel/sched/core.c                                |    6 +-
 kernel/sched/fair.c                                |  113 +-
 kernel/sched/idle.c                                |    6 +
 kernel/sched/sched.h                               |   15 +-
 kernel/time/time.c                                 |    2 +-
 kernel/trace/ftrace.c                              |    3 +
 kernel/trace/trace_clock.c                         |    2 +-
 kernel/trace/trace_event_perf.c                    |    6 +
 kernel/trace/tracing_map.c                         |    6 +-
 lib/string_helpers.c                               |    2 +-
 mm/internal.h                                      |   19 +
 mm/mmap.c                                          |   82 +-
 mm/nommu.c                                         |    9 +-
 mm/shmem.c                                         |    5 -
 mm/util.c                                          |   33 +
 net/9p/trans_xen.c                                 |    9 +-
 net/bluetooth/hci_sysfs.c                          |   15 +-
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/rfcomm/sock.c                        |   10 +-
 net/can/af_can.c                                   |    1 +
 net/can/j1939/transport.c                          |    2 +-
 net/core/filter.c                                  |   88 +-
 net/core/neighbour.c                               |    1 +
 net/core/netpoll.c                                 |    2 +-
 net/dccp/feat.c                                    |    6 +-
 net/ethtool/bitset.c                               |   48 +-
 net/ethtool/common.c                               |    1 +
 net/hsr/hsr_device.c                               |    4 +-
 net/hsr/hsr_forward.c                              |    2 +
 net/ieee802154/socket.c                            |   12 +-
 net/ipv4/af_inet.c                                 |   22 +-
 net/ipv4/ipmr.c                                    |   50 +-
 net/ipv4/ipmr_base.c                               |    3 +-
 net/ipv4/tcp_bpf.c                                 |   11 +-
 net/ipv6/af_inet6.c                                |   22 +-
 net/ipv6/ip6mr.c                                   |    8 +-
 net/ipv6/route.c                                   |    6 +-
 net/mac80211/main.c                                |    2 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |    7 +-
 net/netfilter/ipset/ip_set_core.c                  |    5 +
 net/netfilter/ipvs/ip_vs_proto.c                   |    4 +-
 net/netfilter/nft_set_hash.c                       |   16 +
 net/netfilter/xt_LED.c                             |    4 +-
 net/netlink/af_netlink.c                           |   31 +-
 net/netlink/af_netlink.h                           |    2 -
 net/packet/af_packet.c                             |   12 +-
 net/rfkill/rfkill-gpio.c                           |    8 +-
 net/sched/cls_flower.c                             |    5 +-
 net/sched/sch_cbs.c                                |    2 +-
 net/sched/sch_tbf.c                                |   18 +-
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |    2 +-
 net/sunrpc/cache.c                                 |    4 +-
 net/sunrpc/clnt.c                                  |   53 +-
 net/sunrpc/debugfs.c                               |    2 +-
 net/sunrpc/rpc_pipe.c                              |    2 +-
 net/sunrpc/xprtsock.c                              |   29 +-
 net/tipc/udp_media.c                               |    2 +-
 net/xfrm/xfrm_device.c                             |   10 +-
 net/xfrm/xfrm_state.c                              |    4 +-
 net/xfrm/xfrm_user.c                               |    5 +-
 samples/bpf/test_cgrp2_sock.c                      |    4 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |    1 +
 scripts/mod/file2alias.c                           |    5 +-
 scripts/mod/modpost.c                              |    2 +-
 security/apparmor/capability.c                     |    2 +
 security/apparmor/policy_unpack_test.c             |    6 +
 sound/pci/hda/patch_realtek.c                      |  166 +-
 sound/soc/codecs/da7219.c                          |    9 +-
 sound/soc/codecs/hdmi-codec.c                      |  144 +-
 sound/soc/dwc/Kconfig                              |    2 +-
 sound/soc/fsl/fsl_micfil.c                         |   74 +-
 sound/soc/fsl/fsl_micfil.h                         |  270 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   15 +
 sound/soc/rockchip/Kconfig                         |   14 +-
 sound/soc/stm/stm32_sai_sub.c                      |    6 +-
 sound/usb/6fire/chip.c                             |   10 +-
 sound/usb/caiaq/audio.c                            |   10 +-
 sound/usb/caiaq/audio.h                            |    1 +
 sound/usb/caiaq/device.c                           |   19 +-
 sound/usb/caiaq/input.c                            |   12 +-
 sound/usb/caiaq/input.h                            |    1 +
 sound/usb/clock.c                                  |   32 +-
 sound/usb/mixer_maps.c                             |   10 +
 sound/usb/quirks-table.h                           |   14 +-
 sound/usb/quirks.c                                 |   19 +-
 sound/usb/usx2y/us122l.c                           |   66 +-
 sound/usb/usx2y/us122l.h                           |    2 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |   84 +-
 sound/usb/usx2y/usX2Yhwdep.h                       |    2 +-
 sound/usb/usx2y/usb_stream.c                       |   75 +-
 sound/usb/usx2y/usb_stream.h                       |   23 +-
 sound/usb/usx2y/usbus428ctldefs.h                  |   18 +-
 sound/usb/usx2y/usbusx2y.c                         |  227 +-
 sound/usb/usx2y/usbusx2y.h                         |    8 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |  344 +-
 sound/usb/usx2y/usx2yhwdeppcm.c                    |  305 +-
 tools/perf/builtin-trace.c                         |   16 +-
 tools/perf/util/cs-etm.c                           |   25 +-
 tools/perf/util/probe-finder.c                     |   21 +-
 tools/perf/util/probe-finder.h                     |    4 +-
 .../selftests/arm64/mte/check_tags_inclusion.c     |    4 +-
 tools/testing/selftests/arm64/pauth/pac.c          |    3 +
 tools/testing/selftests/bpf/test_sockmap.c         |  194 +-
 tools/testing/selftests/net/pmtu.sh                |    2 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |    3 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |    3 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |    6 +
 tools/testing/selftests/wireguard/netns.sh         |    1 +
 466 files changed, 8576 insertions(+), 6114 deletions(-)


