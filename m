Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A542253FE;
	Thu, 12 Dec 2024 16:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021670; cv=none; b=q8AnLwmuVLslnOe+ZqHIOIA50Q7lM2n2m49my4dcoTWKCAxIVjL60CDbnTPYwpmN7vGfQViBx13+7wi+/qvcKEXK3d0Yb6QwymvUZfeeAeqSTCwo5fYyqRjGKp/Iblpvg33SCD1J/asbj9J+snPyatxZesbymdzTWwU0SIJEh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021670; c=relaxed/simple;
	bh=5WUyx2czoKgFEQlNqBZ6TbujTYYtREE6YCXFPMy/3qU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rM74szQzWSykS3APkS7n97RnwIcPdodZXpa/cD7Nf8smbERyUSHKWSzFpspnLiSQCxyKBgxjW42Os/CcvoSMhnshredg+fstRKngFILPmMORWjnjRyxc+eExlrSyiPcDBMjdd/fyJI+G+lPfX5pb3IQxV6xlcxqlsQtwOBgG4GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEz3WmGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEz3WmGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1F0C4CED0;
	Thu, 12 Dec 2024 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021670;
	bh=5WUyx2czoKgFEQlNqBZ6TbujTYYtREE6YCXFPMy/3qU=;
	h=From:To:Cc:Subject:Date:From;
	b=fEz3WmGa8DaSVOiXJV7/SliL7FZRNpC35RCC8gxxdDbXjyTraxo99vGYBWb2jATB7
	 uXfSJJ+Sn6zc3sJwAVZGGxPnsKtbjXwb0q4dhxpbcM9DimBCYn95KdPTnD3JCxL/+R
	 gkksLAgUmuDTnp31OwBr8pVdd5RfVBCR2mxc1iN4=
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
Subject: [PATCH 5.15 000/565] 5.15.174-rc1 review
Date: Thu, 12 Dec 2024 15:53:15 +0100
Message-ID: <20241212144311.432886635@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.174-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.174-rc1
X-KernelTest-Deadline: 2024-12-14T14:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.174 release.
There are 565 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.174-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.174-rc1

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix calling mgmt_device_connected

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: Fix af_ops of child socket pointing to released memory

Ameer Hamza <amhamza.mgc@gmail.com>
    media: venus: vdec: fixed possible memory leak issue

Arnd Bergmann <arnd@arndb.de>
    serial: amba-pl011: fix build regression

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: rework resume handling for display (v2)

Wayne Lin <wayne.lin@amd.com>
    drm/amd/display: Correct the defined value for AMDGPU_DMUB_NOTIFICATION_MAX

Tristram Ha <Tristram.Ha@microchip.com>
    net: dsa: microchip: correct KSZ8795 static MAC table access

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix uaf in l2cap_connect

Mark Rutland <mark.rutland@arm.com>
    arm64: smccc: Remove broken support for SMCCCv1.3 SVE discard hint

Mark Brown <broonie@kernel.org>
    arm64/sve: Discard stale CPU state when handling SVE traps

Ziwei Xiao <ziweixiao@google.com>
    gve: Fixes for napi_poll when budget is 0

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: core: Fix scsi_mode_select() buffer length handling

Zhang Zekun <zhangzekun11@huawei.com>
    Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"

Willem de Bruijn <willemb@google.com>
    fou: remove warn in gue_gro_receive on unsupported protocol

Stefan Berger <stefanb@linux.ibm.com>
    ima: Fix use-after-free on a dentry's dname.name

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - inject error before stopping queue

Heming Zhao <heming.zhao@suse.com>
    ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check BIOS images before it is used

Andy-ld Lu <andy-ld.lu@mediatek.com>
    mmc: mtk-sd: Fix error handle of probe function

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix STALL transfer event handling

Zheng Yejian <zhengyejian@huaweicloud.com>
    mm/damon/vaddr: fix issue in damon_va_evenly_split_region()

SeongJae Park <sj@kernel.org>
    mm/damon/vaddr-test: split a test function having >1024 bytes frame size

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

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix to release eprobe when failed to add dyn_event

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing snapshot drew unlock when root is dead during swap activation

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Prevent wakeup of ksoftirqd during idle load balance

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy

Valentin Schneider <valentin.schneider@arm.com>
    sched/fair: Add NOHZ balancer flag for nohz.next_balance updates

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Remove the unnecessary need_resched() check in nohz_csd_func()

Thomas Gleixner <tglx@linutronix.de>
    modpost: Add .irqentry.text to OTHER_SECTIONS

Nathan Chancellor <nathan@kernel.org>
    modpost: Include '.text.*' in TEXT_SECTIONS

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

Esther Shimanovich <eshimanovich@chromium.org>
    PCI: Detect and trust built-in Thunderbolt chips

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Mask ring interrupts before ring stop request

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

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not checking skb length on hci_acldata_packet

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

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: Dereference the ATCS ACPI buffer

Victor Lu <victorchengchi.lu@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for vega20_ih

Manikandan Muralidharan <manikandan.m@microchip.com>
    drm/panel: simple: Add Microchip AC69T88A LVDS Display panel

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

Marek Vasut <marex@denx.de>
    soc: imx8m: Probe the SoC driver as platform driver

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

Christian Brauner <brauner@kernel.org>
    epoll: annotate racy check

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

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: fix OOB map writes when deleting elements

Christian König <christian.koenig@amd.com>
    dma-buf: fix dma_fence_array_signaled v4

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    bpf: fix OOB devmap writes when deleting elements

Liequan Che <cheliequan@inspur.com>
    bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()

Gwendal Grignou <gwendal@chromium.org>
    scsi: ufs: core: sysfs: Prevent div by zero

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free on unload

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Supported speed displayed incorrectly for VPorts

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix NVMe and NPIV connect issue

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix abort in bsg timeout

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

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: can_set_termination(): allow sleeping GPIOs

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

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Enable Performance Counters before clearing them

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mpc52xx: Add cancel_work_sync before module remove

Björn Töpel <bjorn@rivosinc.com>
    tools: Override makefile ARCH variable if defined, but empty

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Notify xrun for low-latency mode

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Avoid reference to status->state

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add more disconnection checks at file ops

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Fix the sk_mem_uncharge logic in tcp_bpf_sendmsg

Pei Xiao <xiaopei01@kylinos.cn>
    drm/sti: Add __iomem for mixer_dbg_mxn's parameter

Amir Mohammadi <amirmohammadi1999.am@gmail.com>
    bpftool: fix potential NULL pointer dereferencing in prog_dump()

Quentin Monnet <quentin@isovalent.com>
    bpftool: Remove asserts from JIT disassembler

Kartik Rajput <kkartik@nvidia.com>
    serial: amba-pl011: Fix RX stall when DMA is used

Thomas Gleixner <tglx@linutronix.de>
    serial: amba-pl011: Use port lock wrappers

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

Wen Gu <guwen@linux.alibaba.com>
    net/smc: fix LGR and link use-after-free issue

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: Limit backlog connections

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
    can: ems_usb: ems_usb_rx_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: ifi_canfd: ifi_canfd_handle_lec_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: m_can: m_can_handle_lec_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: c_can: c_can_handle_bus_err(): update statistics if skb allocation fails

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: do not increase rx statistics when generating a CAN rx error message frame

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: CANFD: store 64-bits hw timestamps

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()

Oleksandr Ocheretnyi <oocheret@cisco.com>
    iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: flush shader L1 cache after user commandstream

Ma Ke <make24@iscas.ac.cn>
    drm/sti: avoid potential dereference of error pointers

Ma Ke <make24@iscas.ac.cn>
    drm/sti: avoid potential dereference of error pointers in sti_gdp_atomic_check

Ma Ke <make24@iscas.ac.cn>
    drm/sti: avoid potential dereference of error pointers in sti_hqvdp_atomic_check

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't BUG_ON on ENOMEM from btrfs_lookup_extent_info() in walk_down_proc()

Yang Erkun <yangerkun@huawei.com>
    nfsd: fix nfs4_openowner leak when concurrent nfsd4_open occur

Yang Erkun <yangerkun@huawei.com>
    nfsd: make sure exp active before svc_export_show

Damien Le Moal <dlemoal@kernel.org>
    PCI: rockchip-ep: Fix address translation unit programming

Yuan Can <yuancan@huawei.com>
    dm thin: Add missing destroy_work_on_stack()

Oleksandr Tymoshenko <ovt@google.com>
    ovl: properly handle large files in ovl_security_fileattr

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Add link up check to ks_pcie_other_map_bus()

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Fix hibern8 notify callbacks

Alexandru Ardelean <aardelean@baylibre.com>
    util_macros.h: fix/rework find_closest() macros

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: Mark IRQ entries to fix stack depot warnings

Zicheng Qu <quzicheng@huawei.com>
    ad7780: fix division by zero in ad7780_write_raw()

Filipe Manana <fdmanana@suse.com>
    btrfs: ref-verify: fix use-after-free after invalid ref action

Lizhi Xu <lizhi.xu@windriver.com>
    btrfs: add a sanity check for btrfs root in btrfs_search_slot()

ChenXiaoSong <chenxiaosong2@huawei.com>
    btrfs: add might_sleep() annotations

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    quota: flush quota_release_work upon quota writeback

Long Li <leo.lilong@huawei.com>
    xfs: remove unknown compat feature check in superblock write validation

Darrick J. Wong <djwong@kernel.org>
    xfs: fix log recovery when unknown rocompat bits are set

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

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add sanity NULL check for the default mmap fault handler

Hans Verkuil <hverkuil@xs4all.nl>
    media: v4l2-core: v4l2-dv-timings: check cvt/gtf result

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    soc: fsl: rcpm: fix missing of_node_put() in copy_ippdexpcr1_setting()

Qiu-ji Chen <chenqiuji666@gmail.com>
    media: wl128x: Fix atomicity violation in fmc_send_cmd()

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Interpret tilt data from Intuos Pro BT as signed values

Muchun Song <songmuchun@bytedance.com>
    block: fix ordering between checking BLK_MQ_S_STOPPED request adding

Will Deacon <will@kernel.org>
    arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled

Huacai Chen <chenhuacai@kernel.org>
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

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: mediatek-hw: Fix wrong return value in mtk_cpufreq_get_cpu_power()

Cheng Ming Lin <chengminglin@mxic.com.tw>
    mtd: spi-nor: core: replace dummy buswidth from addr to data

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    spi: Fix acpi deferred irq probe

Jeongjun Park <aha310510@gmail.com>
    netfilter: ipset: add missing range check in bitmap_ip_uadt

Sai Kumar Cholleti <skmr537@gmail.com>
    gpio: exar: set value when external pull-up or pull-down is present

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: sh-sci: Clean sci_ports[0] after at earlycon exit"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Michal Vrastil <michal.vrastil@hidglobal.com>
    Revert "usb: gadget: composite: fix OS descriptors w_value logic"

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Fix double free in driver API bus_register()

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix TD invalidation under pending Set TR Dequeue

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

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries: Fix KVM guest detection for disabling hardlockup detector

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

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: sst: Fix used of uninitialized ctx to log an error

Joel Guittet <jguittet@witekio.com>
    Revert "drivers: clk: zynqmp: update divider round rate logic"

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-spear: fix call balance of sehci clk handling routines

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix out of bounds reads when finding clock sources

Qiu-ji Chen <chenqiuji666@gmail.com>
    xen: Fix the issue of resource not being properly released in xenbus_dev_probe()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix slab-use-after-free in smb3_preauth_hash_rsp

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix a possible DMA corruption

chao liu <liuzgyid@outlook.com>
    apparmor: fix 'Do simple duplicate message elimination'

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC256 depop procedure

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    counter: stm32-timer-cnt: Add check for clk_enable()

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

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix use-after-free of nreq in reqsk_timer_handler().

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    bnxt_en: Reserve rings after PCIe AER recovery if NIC interface is down

Eric Dumazet <edumazet@google.com>
    net: hsr: fix hsr_init_sk() vs network/transport headers.

Csókás, Bence <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Fix register name in verbose logging function

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: RPM: Fix mismatch in lmac type

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac-socfpga: Set RX watchdog interrupt as broken

Vitalii Mordan <mordan@ispras.ru>
    marvell: pxa168_eth: fix call balance of pep->clk handling routines

Rosen Penev <rosenp@gmail.com>
    net: mdio-ipq4019: add missing error check

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration

Pavan Chebbi <pavan.chebbi@broadcom.com>
    tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device

Barnabás Czémán <barnabas.czeman@mainlining.org>
    power: supply: bq27xxx: Fix registers of bq27426

Bart Van Assche <bvanassche@acm.org>
    power: supply: core: Remove might_sleep() from power_supply_put()

Randy Dunlap <rdunlap@infradead.org>
    fs_parser: update mount_api doc to match function signature

Avihai Horon <avihaih@nvidia.com>
    vfio/pci: Properly hide first-in-list PCIe extended capability

Michael Ellerman <mpe@ellerman.id.au>
    selftests/mount_setattr: Fix failures on 64K PAGE_SIZE kernels

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix suboptimal range on iotlb iteration

Murad Masimov <m.masimov@maxima.ru>
    hwmon: (tps23861) Fix reporting of negative temperatures

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsd4_shutdown_copy()

Ye Bin <yebin10@huawei.com>
    svcrdma: fix miss destroy percpu_counter in svc_rdma_proc_init()

Luis Chamberlain <mcgrof@kernel.org>
    sunrpc: simplify two-level sysctl registration for svcrdma_parm_table

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

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Address an integer overflow

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

Todd Kjos <tkjos@google.com>
    PCI: Fix reset_method_store() memory leak

James Clark <james.clark@linaro.org>
    perf cs-etm: Don't flush when packet_queue fills up

Dan Carpenter <dan.carpenter@linaro.org>
    mailbox: arm_mhuv2: clean up loop in get_irq_chan_comb()

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    pinctrl: k210: Undef K210_PC_DEFAULT

Nuno Sa <nuno.sa@analog.com>
    clk: clk-axi-clkgen: make sure to enable the AXI bus clock

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: clock: axi-clkgen: include AXI clk

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

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix out-of-order issue of requester when setting FENCE

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

Dong Aisheng <aisheng.dong@nxp.com>
    clk: imx: clk-scu: fix clk enable state save and restore

Peng Fan <peng.fan@nxp.com>
    clk: imx: lpcg-scu: SW workaround for errata (e10858)

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix dtl_access_lock to be a rw_semaphore

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/mm/fault: Fix kfence page fault reporting

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

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: zynqmp: drop excess struct member description

Levi Yun <yeoreum.yun@arm.com>
    trace/trace_event_perf: remove duplicate samples on the first tracepoint event

Jiayuan Chen <mrpre@163.com>
    bpf: fix recursive lock when verdict program return SK_PASS

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

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: must hold rcu read lock while iterating object type list

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip transaction if update object is not implemented

Zichen Xie <zichenxie0106@gmail.com>
    drm/msm/dpu: cast crtc_clk calculation to u64 in _dpu_core_perf_calc_clk()

Yuan Can <yuancan@huawei.com>
    wifi: wfx: Fix error handling in wfx_core_init()

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: hold GPU lock across perfmon sampling

Doug Brown <doug@schmorgal.com>
    drm/etnaviv: fix power register offset on GC300

Xiaolei Wang <xiaolei.wang@windriver.com>
    drm/etnaviv: Request pages from DMA32 zone on addressing_limited

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()

Steven Price <steven.price@arm.com>
    drm/panfrost: Remove unused id_mask from struct panfrost_model

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c

Matthias Schiffer <matthias.schiffer@tq-group.com>
    drm: fsl-dcu: enable PIXCLK on LS1021A

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

Andrii Nakryiko <andrii@kernel.org>
    libbpf: fix sym_is_subprog() logic for weak global subprogs

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix the xdp_adjust_tail sample prog issue

Tony Ambardar <tony.ambardar@gmail.com>
    libbpf: Fix output .symtab byte-order during linking

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: anx7625: Drop EDID cache on bridge power off

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

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: Fix possible NULL dereference

Jeongjun Park <aha310510@gmail.com>
    wifi: ath9k: add range check for conn_rsp_epid in htc_connect_service()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused

Yao Zi <ziyao@disroot.org>
    platform/x86: panasonic-laptop: Return errno correctly in show callback

Qing Wang <wangqing@vivo.com>
    platform/x86: panasonic-laptop: Replace snprintf in show functions with sysfs_emit

Li Huafei <lihuafei1@huawei.com>
    media: atomisp: Add check for rgby_data memory allocation failure

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: atomisp: remove #ifdef HAS_NO_HMEM

Sergey Senozhatsky <senozhatsky@chromium.org>
    media: venus: provide ctx queue lock for ioctl synchronization

Dikshita Agarwal <quic_dikshita@quicinc.com>
    venus: venc: add handling for VIDIOC_ENCODER_CMD

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus : Addition of support for VIDIOC_TRY_ENCODER_CMD

Viswanath Boma <quic_vboma@quicinc.com>
    media: venus : Addition of EOS Event support for Encoder

Mansur Alisha Shaik <mansur@codeaurora.org>
    media: venus: vdec: decoded picture buffer handling during reconfig sequence

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: venc: Use pmruntime autosuspend

Luo Qiu <luoqiu@kylinsec.com.cn>
    firmware: arm_scpi: Check the DVFS OPP count returned by the firmware

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Protect against array overrun during iMC config parsing

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add supplies for fixed regulators

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Fix DP bridge supply names

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8183: jacuzzi: Move panel under aux-bus

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8183: jacuzzi: remove unused ddc-i2c-bus

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: irq: Set lockdep class for hierarchical IRQ domains

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: zynqmp-gqspi: Undo runtime PM changes at driver exit time​

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Avoid shift-out-of-bounds

Zhang Zekun <zhangzekun11@huawei.com>
    pmdomain: ti-sci: Add missing of_node_put() for args.np

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: cubieboard4: Fix DCDC5 regulator constraints

Clark Wang <xiaoning.wang@nxp.com>
    pwm: imx27: Workaround of the pwm output bug when decrease the duty cycle

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: Damu: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: burnet: add i2c2's i2c-scl-internal-delay-ns

Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
    arm64: dts: mt8183: fennel: add i2c2's i2c-scl-internal-delay-ns

Chen Ridong <chenridong@huawei.com>
    cgroup/bpf: only cgroup v2 can be attached by bpf programs

Chen Ridong <chenridong@huawei.com>
    Revert "cgroup: Fix memory leak caused by missing cgroup_bpf_offline"

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm-hana: Add vdd-supply to second source trackpad

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mt8183: kukui: Fix the address of eeprom at i2c4

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

Marco Elver <elver@google.com>
    kcsan, seqlock: Fix incorrect assumption in read_seqbegin()

Marco Elver <elver@google.com>
    kcsan, seqlock: Support seqcount_latch_t

Peter Zijlstra <peterz@infradead.org>
    seqlock/latch: Provide raw_read_seqcount_latch_retry()

Thomas Gleixner <tglx@linutronix.de>
    timekeeping: Consolidate fast timekeeper

Miguel Ojeda <ojeda@kernel.org>
    time: Fix references to _msecs_to_jiffies() handling of values

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Chen Ridong <chenridong@huawei.com>
    crypto: bcm - add error check in the ahash_hmac_init function

Chen Ridong <chenridong@huawei.com>
    crypto: caam - add error check to caam_rsa_set_priv_key_form

Lifeng Zheng <zhenglifeng1@huawei.com>
    ACPI: CPPC: Fix _CPC register setting issue

Orange Kao <orange@aiven.io>
    EDAC/igen6: Avoid segmentation fault on module unload

Everest K.C <everestkc@everestkc.com.np>
    crypto: cavium - Fix the if condition to exit loop after timeout

Yi Yang <yiyang13@huawei.com>
    crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY

Priyanka Singh <priyanka.singh@nxp.com>
    EDAC/fsl_ddr: Fix bad bit shift operations

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Initialize thermal zones before registering them

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - remove faulty arbiter config reset

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

Yang Erkun <yangerkun@huawei.com>
    brd: defer automatic disk creation until module initialization succeeds

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    brd: remove brd_devices_mutex mutex

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Do not unregister the subchannel based on DNV

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

Harith G <harith.g@alifsemi.com>
    ARM: 9420/1: smp: Fix SMP for xip kernels

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

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-base: Handle META key Lock/Unlock events

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-smbios-base: Extends support to Alienware products

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

Benjamin Große <ste3ls@gmail.com>
    usb: add support for new USB device ID 0x17EF:0x3098 for the r8152 driver

Ben Greear <greearb@candelatech.com>
    mac80211: fix user-power when emulating chanctx

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: Use the sync timepoint API in suspend

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: sst: Support LPE0F28 ACPI HID

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add support for non ACPI instantiated codec

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_async_write_reschedule_io must not recurse into the writeback code

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

Paolo Abeni <pabeni@redhat.com>
    mptcp: cope racing subflow creation in mptcp_rcv_space_adjust

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

Jiri Olsa <jolsa@kernel.org>
    lib/buildid: Fix build ID parsing logic

Andre Przywara <andre.przywara@arm.com>
    mmc: sunxi-mmc: Fix A100 compatible description

Samuel Holland <samuel@sholland.org>
    mmc: sunxi-mmc: Add D1 MMC variant

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

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Treat vpid01 as current if L2 is active, but with VPID disabled

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix PA offset with unaligned starting iotlb map

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: uncache inode which has failed entering the group

Jinjiang Tu <tujinjiang@huawei.com>
    mm: fix NULL pointer dereference in alloc_pages_bulk_noprof

Baoquan He <bhe@redhat.com>
    x86/mm: Fix a kdump kernel failure on SME system when CONFIG_IMA_KEXEC=y

Harith G <harith.g@alifsemi.com>
    ARM: 9419/1: mm: Fix kernel memory mapping for xip kernels

Wei Fang <wei.fang@nxp.com>
    samples: pktgen: correct dev to DEV

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5e: CT: Fix null-ptr-deref in add rule err flow

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: kTLS, Fix incorrect page refcounting

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, lock FTE when checking if active

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop: Fix a dereferenced before check warning

Jakub Kicinski <kuba@kernel.org>
    netlink: terminate outstanding dump on socket close

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: gcc-qcs404: fix initial rate of GPLL3

Michal Vokáč <michal.vokac@ysoft.com>
    leds: lp55xx: Remove redundant test for invalid channel number

Mostafa Saleh <smostafa@google.com>
    iommu/io-pgtable-arm: Fix stage-2 map/unmap for concatenated tables

MengEn Sun <mengensun@tencent.com>
    vmstat: call fold_vm_zone_numa_events() before show per zone NUMA event

guoweikang <guoweikang.kernel@gmail.com>
    ftrace: Fix regression with module command in stack_trace_filter

Vasiliy Kovalev <kovalev@altlinux.org>
    ovl: Filter invalid inodes with missing lookup function

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Require entities to have a non-zero unique ID

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

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Ensure power suppliers be suspended before detach them

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: i2c: tc358743: Fix crash in the probe error path when using polling

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Set video drvdata before register video device

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-pci            |   11 +
 .../devicetree/bindings/clock/adi,axi-clkgen.yaml  |   22 +-
 .../devicetree/bindings/serial/rs485.yaml          |   19 +-
 .../devicetree/bindings/sound/mt6359.yaml          |   10 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 Documentation/filesystems/mount_api.rst            |    3 +-
 Documentation/locking/seqlock.rst                  |    2 +-
 Documentation/networking/j1939.rst                 |    2 +-
 Makefile                                           |    4 +-
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts        |    4 +-
 arch/arm/kernel/head.S                             |   12 +-
 arch/arm/kernel/psci_smp.c                         |    7 +
 arch/arm/mm/idmap.c                                |    7 +
 arch/arm/mm/mmu.c                                  |   34 +-
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |    3 +
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi  |    8 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts   |    3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |    3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi  |    3 +
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |   57 +-
 .../boot/dts/mediatek/mt8183-kukui-kakadu.dtsi     |    4 +-
 .../boot/dts/mediatek/mt8183-kukui-kodama.dtsi     |    4 +-
 .../boot/dts/mediatek/mt8183-kukui-krane.dtsi      |    4 +-
 arch/arm64/include/asm/mman.h                      |   10 +-
 arch/arm64/kernel/fpsimd.c                         |    1 +
 arch/arm64/kernel/process.c                        |    2 +-
 arch/arm64/kernel/ptrace.c                         |    6 +-
 arch/arm64/kernel/smccc-call.S                     |   35 +-
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
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          |   73 +-
 arch/mips/include/asm/switch_to.h                  |    2 +-
 arch/parisc/Kconfig                                |    1 +
 arch/parisc/include/asm/cache.h                    |   11 +-
 arch/powerpc/include/asm/dtl.h                     |    4 +-
 arch/powerpc/include/asm/sstep.h                   |    5 -
 arch/powerpc/include/asm/vdso.h                    |    1 +
 arch/powerpc/kernel/prom_init.c                    |   29 +-
 arch/powerpc/kernel/setup_64.c                     |    1 +
 arch/powerpc/kexec/file_load_64.c                  |    9 +-
 arch/powerpc/lib/sstep.c                           |   12 +-
 arch/powerpc/mm/fault.c                            |   10 +-
 arch/powerpc/platforms/pseries/dtl.c               |    8 +-
 arch/powerpc/platforms/pseries/lpar.c              |    8 +-
 arch/s390/kernel/entry.S                           |    4 +
 arch/s390/kernel/kprobes.c                         |    6 +
 arch/s390/kernel/perf_cpum_sf.c                    |    4 +-
 arch/s390/kernel/syscalls/Makefile                 |    2 +-
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
 arch/x86/kvm/vmx/nested.c                          |   30 +-
 arch/x86/kvm/vmx/vmx.c                             |    6 +-
 arch/x86/mm/ioremap.c                              |    6 +-
 arch/x86/pci/acpi.c                                |  119 +
 block/blk-mq.c                                     |    6 +
 block/blk-mq.h                                     |   13 +
 crypto/pcrypt.c                                    |   12 +-
 drivers/acpi/arm64/gtdt.c                          |    2 +-
 drivers/acpi/cppc_acpi.c                           |    1 -
 drivers/base/bus.c                                 |    2 +
 drivers/base/core.c                                |   20 +
 drivers/base/regmap/regmap-irq.c                   |    4 +
 drivers/base/regmap/regmap.c                       |   12 +
 drivers/block/brd.c                                |   99 +-
 drivers/clk/clk-axi-clkgen.c                       |   22 +-
 drivers/clk/imx/clk-lpcg-scu.c                     |   37 +-
 drivers/clk/imx/clk-scu.c                          |    2 +-
 drivers/clk/qcom/gcc-qcs404.c                      |    1 +
 drivers/clk/zynqmp/divider.c                       |   66 +-
 drivers/clocksource/Kconfig                        |    3 +-
 drivers/comedi/comedi_fops.c                       |   12 +
 drivers/counter/stm32-timer-cnt.c                  |   16 +-
 drivers/cpufreq/loongson2_cpufreq.c                |    4 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |    2 +-
 drivers/crypto/bcm/cipher.c                        |    5 +-
 drivers/crypto/caam/caampkc.c                      |   11 +-
 drivers/crypto/caam/qi.c                           |    2 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |    6 +-
 drivers/crypto/hisilicon/qm.c                      |   51 +-
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |    4 -
 drivers/dma-buf/dma-fence-array.c                  |   28 +-
 drivers/edac/bluefield_edac.c                      |    2 +-
 drivers/edac/fsl_ddr_edac.c                        |   22 +-
 drivers/edac/igen6_edac.c                          |    2 +
 drivers/firmware/arm_scpi.c                        |    3 +
 drivers/firmware/efi/tpm.c                         |   17 +-
 drivers/firmware/google/gsmi.c                     |    6 +-
 drivers/firmware/smccc/smccc.c                     |    4 -
 drivers/gpio/gpio-exar.c                           |   10 +-
 drivers/gpio/gpio-grgpio.c                         |   26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   48 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |    5 +-
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c             |   27 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |    5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    2 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |   14 +
 drivers/gpu/drm/bridge/analogix/anx7625.c          |    2 +
 drivers/gpu/drm/bridge/tc358767.c                  |    7 +
 drivers/gpu/drm/bridge/tc358768.c                  |   21 +-
 drivers/gpu/drm/drm_mm.c                           |    2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |    6 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |    3 +-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c              |   10 +
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |    7 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |   48 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |   21 +
 drivers/gpu/drm/fsl-dcu/Kconfig                    |    1 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c          |   15 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.h          |    3 +
 drivers/gpu/drm/imx/dcss/dcss-crtc.c               |    6 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |    6 +-
 drivers/gpu/drm/mcde/mcde_drv.c                    |    1 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |    4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |    2 +-
 drivers/gpu/drm/omapdrm/dss/base.c                 |   25 +-
 drivers/gpu/drm/omapdrm/dss/omapdss.h              |    3 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |    4 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   10 +-
 drivers/gpu/drm/panel/panel-simple.c               |   28 +
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |    1 -
 drivers/gpu/drm/radeon/r600_cs.c                   |    2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |    8 +-
 drivers/gpu/drm/sti/sti_cursor.c                   |    3 +
 drivers/gpu/drm/sti/sti_gdp.c                      |    3 +
 drivers/gpu/drm/sti/sti_hqvdp.c                    |    3 +
 drivers/gpu/drm/sti/sti_mixer.c                    |    2 +-
 drivers/gpu/drm/v3d/v3d_mmu.c                      |   29 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |    2 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   11 +
 drivers/hid/wacom_sys.c                            |    3 +-
 drivers/hid/wacom_wac.c                            |    4 +-
 drivers/hwmon/tps23861.c                           |    2 +-
 drivers/i3c/master.c                               |    5 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |    2 +-
 drivers/iio/adc/ad7780.c                           |    2 +-
 drivers/iio/light/al3010.c                         |   11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    7 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |    2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |    2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |    1 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |    7 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |   11 +
 drivers/iommu/io-pgtable-arm.c                     |   18 +-
 drivers/leds/led-class.c                           |   14 +-
 drivers/leds/leds-lp55xx-common.c                  |    3 -
 drivers/mailbox/arm_mhuv2.c                        |    8 +-
 drivers/md/bcache/super.c                          |    2 +-
 drivers/md/dm-thin.c                               |    1 +
 drivers/media/dvb-core/dvbdev.c                    |   15 +-
 drivers/media/dvb-frontends/ts2020.c               |    8 +-
 drivers/media/i2c/adv7604.c                        |    5 +-
 drivers/media/i2c/adv7842.c                        |   13 +-
 drivers/media/i2c/tc358743.c                       |    4 +-
 drivers/media/platform/allegro-dvt/allegro-core.c  |    4 +-
 drivers/media/platform/imx-jpeg/mxc-jpeg.c         |    4 +-
 drivers/media/platform/qcom/venus/core.c           |    2 +-
 drivers/media/platform/qcom/venus/core.h           |   12 +
 drivers/media/platform/qcom/venus/helpers.c        |   53 +-
 drivers/media/platform/qcom/venus/helpers.h        |    3 +
 drivers/media/platform/qcom/venus/vdec.c           |   11 +-
 drivers/media/platform/qcom/venus/venc.c           |  191 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   15 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    2 +
 drivers/media/usb/gspca/ov534.c                    |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  113 +-
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
 drivers/mmc/host/dw_mmc.c                          |    4 +-
 drivers/mmc/host/mmc_spi.c                         |    9 +-
 drivers/mmc/host/mtk-sd.c                          |    9 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   72 +
 drivers/mmc/host/sdhci-pci.h                       |    1 +
 drivers/mmc/host/sunxi-mmc.c                       |   15 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |    8 +-
 drivers/mtd/nand/raw/atmel/pmecc.h                 |    2 -
 drivers/mtd/spi-nor/core.c                         |    2 +-
 drivers/mtd/ubi/attach.c                           |   12 +-
 drivers/mtd/ubi/wl.c                               |    9 +-
 drivers/net/can/at91_can.c                         |    6 -
 drivers/net/can/c_can/c_can_main.c                 |   31 +-
 drivers/net/can/cc770/cc770.c                      |    3 -
 drivers/net/can/dev/dev.c                          |    6 +-
 drivers/net/can/dev/rx-offload.c                   |    6 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   63 +-
 drivers/net/can/kvaser_pciefd.c                    |    5 -
 drivers/net/can/m_can/m_can.c                      |   38 +-
 drivers/net/can/mscan/mscan.c                      |    9 +-
 drivers/net/can/pch_can.c                          |    3 -
 drivers/net/can/peak_canfd/peak_canfd.c            |    4 -
 drivers/net/can/rcar/rcar_can.c                    |    6 +-
 drivers/net/can/rcar/rcar_canfd.c                  |    4 -
 drivers/net/can/sja1000/sja1000.c                  |    2 -
 drivers/net/can/sun4i_can.c                        |   29 +-
 drivers/net/can/usb/ems_usb.c                      |   60 +-
 drivers/net/can/usb/esd_usb2.c                     |    2 -
 drivers/net/can/usb/etas_es58x/es58x_core.c        |    7 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |    2 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |    8 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |    4 -
 drivers/net/can/usb/peak_usb/pcan_usb.c            |    2 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   13 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |    1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   12 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    2 -
 drivers/net/can/usb/ucan.c                         |    6 +-
 drivers/net/can/usb/usb_8dev.c                     |    2 -
 drivers/net/can/xilinx_can.c                       |    9 +-
 drivers/net/dsa/microchip/ksz8795.c                |   18 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/broadcom/tg3.c                |    3 +
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    2 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |    2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |    7 +
 drivers/net/ethernet/google/gve/gve_rx.c           |    4 -
 drivers/net/ethernet/google/gve/gve_tx.c           |    4 -
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |    5 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    4 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   10 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   19 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   14 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |    2 +
 drivers/net/geneve.c                               |    2 +-
 drivers/net/mdio/mdio-ipq4019.c                    |    5 +-
 drivers/net/netdevsim/ipsec.c                      |   11 +-
 drivers/net/usb/lan78xx.c                          |   11 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/usb/r8152.c                            |    1 +
 drivers/net/wireless/ath/ath10k/mac.c              |    4 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    3 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    2 +
 drivers/net/wireless/intersil/p54/p54spi.c         |    4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    4 +-
 drivers/nvdimm/dax_devs.c                          |    4 +-
 drivers/nvdimm/nd.h                                |    7 +
 drivers/nvme/host/ioctl.c                          |    7 +-
 drivers/nvme/host/pci.c                            |   16 +-
 drivers/pci/controller/dwc/pci-keystone.c          |   11 +
 drivers/pci/controller/pcie-rockchip-ep.c          |   16 +-
 drivers/pci/controller/pcie-rockchip.h             |    4 +
 drivers/pci/hotplug/cpqphp_pci.c                   |   19 +-
 drivers/pci/pci-sysfs.c                            |   26 +
 drivers/pci/pci.c                                  |    7 +-
 drivers/pci/pci.h                                  |    1 +
 drivers/pci/probe.c                                |   30 +-
 drivers/pci/quirks.c                               |   15 +-
 drivers/pci/slot.c                                 |    4 +-
 drivers/pinctrl/freescale/Kconfig                  |    2 +-
 drivers/pinctrl/pinctrl-k210.c                     |    2 +-
 drivers/pinctrl/pinctrl-zynqmp.c                   |    1 -
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |    2 +
 drivers/platform/chrome/cros_ec_typec.c            |    1 +
 drivers/platform/x86/dell/dell-smbios-base.c       |    1 +
 drivers/platform/x86/dell/dell-wmi-base.c          |    6 +
 drivers/platform/x86/intel/bxtwc_tmu.c             |   22 +-
 drivers/platform/x86/panasonic-laptop.c            |   26 +-
 drivers/power/supply/bq27xxx_battery.c             |   37 +-
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
 drivers/s390/cio/cio.c                             |    6 +-
 drivers/s390/cio/device.c                          |   18 +-
 drivers/scsi/bfa/bfad.c                            |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    1 +
 drivers/scsi/qedf/qedf_main.c                      |    1 +
 drivers/scsi/qedi/qedi_main.c                      |    1 +
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |  124 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   15 +-
 drivers/scsi/scsi_lib.c                            |   21 +-
 drivers/scsi/st.c                                  |   31 +-
 drivers/scsi/ufs/ufs-exynos.c                      |   16 +-
 drivers/scsi/ufs/ufs-sysfs.c                       |    6 +
 drivers/sh/intc/core.c                             |    2 +-
 drivers/soc/fsl/rcpm.c                             |    1 +
 drivers/soc/imx/soc-imx8m.c                        |  107 +-
 drivers/soc/qcom/qcom-geni-se.c                    |    3 +-
 drivers/soc/qcom/socinfo.c                         |    8 +-
 drivers/soc/ti/smartreflex.c                       |    4 +-
 drivers/soc/ti/ti_sci_pm_domains.c                 |    4 +
 drivers/spi/atmel-quadspi.c                        |    2 +-
 drivers/spi/spi-fsl-lpspi.c                        |   14 +-
 drivers/spi/spi-mpc52xx.c                          |    1 +
 drivers/spi/spi-tegra210-quad.c                    |    2 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |    2 +
 drivers/spi/spi.c                                  |   13 +-
 .../pci/isp/kernels/bh/bh_2/ia_css_bh.host.c       |    2 -
 .../raw_aa_binning_1.0/ia_css_raa.host.c           |    2 -
 .../pci/isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c  |    5 -
 .../media/atomisp/pci/runtime/binary/src/binary.c  |    4 -
 drivers/staging/media/atomisp/pci/sh_css_params.c  |   12 +-
 drivers/staging/wfx/main.c                         |   17 +-
 drivers/thermal/thermal_core.c                     |    2 +-
 drivers/tty/serial/8250/8250_omap.c                |    4 +-
 drivers/tty/serial/amba-pl011.c                    |   79 +-
 drivers/tty/tty_ldisc.c                            |    2 +-
 drivers/usb/chipidea/udc.c                         |    2 +-
 drivers/usb/dwc3/gadget.c                          |   15 +-
 drivers/usb/gadget/composite.c                     |   18 +-
 drivers/usb/host/ehci-spear.c                      |    7 +-
 drivers/usb/host/xhci-dbgcap.c                     |  135 +-
 drivers/usb/host/xhci-dbgcap.h                     |    2 +-
 drivers/usb/host/xhci-ring.c                       |   18 +-
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
 fs/btrfs/ctree.c                                   |   10 +-
 fs/btrfs/extent-tree.c                             |    1 -
 fs/btrfs/inode.c                                   |    1 +
 fs/btrfs/ref-verify.c                              |    1 +
 fs/btrfs/volumes.c                                 |   38 +-
 fs/cifs/smb2ops.c                                  |    6 +
 fs/eventpoll.c                                     |    6 +-
 fs/exfat/namei.c                                   |    1 +
 fs/ext4/fsmap.c                                    |   54 +-
 fs/ext4/mballoc.c                                  |   18 +-
 fs/ext4/mballoc.h                                  |    1 +
 fs/ext4/super.c                                    |    8 +-
 fs/f2fs/inode.c                                    |    4 +-
 fs/f2fs/segment.c                                  |   74 +-
 fs/f2fs/segment.h                                  |    6 -
 fs/hfsplus/hfsplus_fs.h                            |    3 +-
 fs/hfsplus/wrapper.c                               |    2 +
 fs/jffs2/compr_rtime.c                             |    3 +
 fs/jffs2/erase.c                                   |    7 +-
 fs/jfs/jfs_dmap.c                                  |    6 +
 fs/jfs/jfs_dtree.c                                 |   15 +
 fs/jfs/xattr.c                                     |    2 +-
 fs/ksmbd/server.c                                  |    4 +-
 fs/nfs/internal.h                                  |    2 +-
 fs/nfs/nfs4proc.c                                  |    8 +-
 fs/nfs/write.c                                     |    2 -
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
 fs/overlayfs/inode.c                               |    7 +-
 fs/overlayfs/util.c                                |    3 +
 fs/proc/softirqs.c                                 |    2 +-
 fs/quota/dquot.c                                   |    2 +
 fs/ubifs/super.c                                   |    6 +-
 fs/ubifs/tnc_commit.c                              |    2 +
 fs/unicode/mkutf8data.c                            |   70 +
 fs/unicode/utf8data.h_shipped                      | 6703 ++++++++++----------
 fs/xfs/libxfs/xfs_sb.c                             |   10 +-
 fs/xfs/xfs_log.c                                   |   17 -
 include/linux/arm-smccc.h                          |   30 +-
 include/linux/blkdev.h                             |    2 +-
 include/linux/device.h                             |    2 +
 include/linux/eeprom_93cx6.h                       |   11 +
 include/linux/eventpoll.h                          |    2 +-
 include/linux/jiffies.h                            |    2 +-
 include/linux/leds.h                               |    2 +-
 include/linux/lockdep.h                            |    2 +-
 include/linux/mman.h                               |    7 +-
 include/linux/netpoll.h                            |    2 +-
 include/linux/pci.h                                |    6 +
 include/linux/rbtree_latch.h                       |    2 +-
 include/linux/seqlock.h                            |  107 +-
 include/linux/sunrpc/xprtsock.h                    |    1 +
 include/linux/util_macros.h                        |   56 +-
 include/media/v4l2-dv-timings.h                    |   18 +-
 include/net/xfrm.h                                 |   16 +-
 include/sound/pcm.h                                |   20 +-
 include/uapi/linux/rtnetlink.h                     |    2 +-
 init/initramfs.c                                   |   15 +
 kernel/bpf/devmap.c                                |    6 +-
 kernel/bpf/lpm_trie.c                              |   27 +-
 kernel/cgroup/cgroup.c                             |   21 +-
 kernel/dma/debug.c                                 |    8 +-
 kernel/kcsan/debugfs.c                             |   74 +-
 kernel/printk/printk.c                             |    2 +-
 kernel/rcu/tasks.h                                 |    2 +-
 kernel/sched/core.c                                |    4 +-
 kernel/sched/fair.c                                |   26 +-
 kernel/sched/sched.h                               |    8 +-
 kernel/time/sched_clock.c                          |    2 +-
 kernel/time/time.c                                 |    2 +-
 kernel/time/timekeeping.c                          |   24 +-
 kernel/trace/ftrace.c                              |    3 +
 kernel/trace/trace_clock.c                         |    2 +-
 kernel/trace/trace_eprobe.c                        |    5 +
 kernel/trace/trace_event_perf.c                    |    6 +
 kernel/trace/tracing_map.c                         |    6 +-
 lib/buildid.c                                      |    2 +-
 lib/string_helpers.c                               |    2 +-
 mm/damon/vaddr-test.h                              |   94 +-
 mm/damon/vaddr.c                                   |    4 +-
 mm/internal.h                                      |   19 +
 mm/mmap.c                                          |   86 +-
 mm/nommu.c                                         |    9 +-
 mm/page_alloc.c                                    |    3 +-
 mm/shmem.c                                         |    5 -
 mm/util.c                                          |   33 +
 mm/vmstat.c                                        |    1 +
 net/9p/trans_xen.c                                 |    9 +-
 net/bluetooth/hci_core.c                           |   13 +-
 net/bluetooth/hci_event.c                          |    2 +-
 net/bluetooth/hci_sysfs.c                          |   15 +-
 net/bluetooth/l2cap_core.c                         |    9 -
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/rfcomm/sock.c                        |   10 +-
 net/can/af_can.c                                   |    1 +
 net/can/j1939/transport.c                          |    2 +-
 net/core/filter.c                                  |   88 +-
 net/core/neighbour.c                               |    1 +
 net/core/netpoll.c                                 |    2 +-
 net/core/skmsg.c                                   |    4 +-
 net/dccp/feat.c                                    |    6 +-
 net/ethtool/bitset.c                               |   48 +-
 net/hsr/hsr_device.c                               |    4 +-
 net/hsr/hsr_forward.c                              |    2 +
 net/ieee802154/socket.c                            |   12 +-
 net/ipv4/af_inet.c                                 |   22 +-
 net/ipv4/fou.c                                     |    2 +-
 net/ipv4/inet_connection_sock.c                    |    2 +-
 net/ipv4/ipmr_base.c                               |    3 +-
 net/ipv4/tcp_bpf.c                                 |   11 +-
 net/ipv6/af_inet6.c                                |   22 +-
 net/ipv6/route.c                                   |    6 +-
 net/mac80211/main.c                                |    2 +
 net/mptcp/protocol.c                               |    3 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |    7 +-
 net/netfilter/ipset/ip_set_core.c                  |    5 +
 net/netfilter/ipvs/ip_vs_proto.c                   |    4 +-
 net/netfilter/nf_tables_api.c                      |   19 +-
 net/netfilter/nft_set_hash.c                       |   16 +
 net/netfilter/xt_LED.c                             |    4 +-
 net/netlink/af_netlink.c                           |   31 +-
 net/netlink/af_netlink.h                           |    2 -
 net/packet/af_packet.c                             |   12 +-
 net/rfkill/rfkill-gpio.c                           |    8 +-
 net/sched/cls_flower.c                             |    5 +-
 net/sched/sch_cbs.c                                |    2 +-
 net/sched/sch_tbf.c                                |   18 +-
 net/smc/af_smc.c                                   |   57 +
 net/smc/smc.h                                      |    6 +-
 net/sunrpc/cache.c                                 |    4 +-
 net/sunrpc/clnt.c                                  |   33 +-
 net/sunrpc/xprtrdma/svc_rdma.c                     |   40 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |    8 +-
 net/sunrpc/xprtsock.c                              |   23 +-
 net/tipc/udp_media.c                               |    2 +-
 net/xdp/xskmap.c                                   |    2 +-
 net/xfrm/xfrm_device.c                             |   10 +-
 net/xfrm/xfrm_state.c                              |    4 +-
 net/xfrm/xfrm_user.c                               |    5 +-
 samples/bpf/test_cgrp2_sock.c                      |    4 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |    1 +
 samples/pktgen/pktgen_sample01_simple.sh           |    2 +-
 scripts/mod/file2alias.c                           |    5 +-
 scripts/mod/modpost.c                              |    6 +-
 security/apparmor/capability.c                     |    2 +
 security/apparmor/policy_unpack_test.c             |    6 +
 security/integrity/ima/ima_api.c                   |   16 +-
 security/integrity/ima/ima_template_lib.c          |   17 +-
 sound/core/oss/pcm_oss.c                           |   42 +-
 sound/core/pcm.c                                   |    9 +-
 sound/core/pcm_compat.c                            |    4 +-
 sound/core/pcm_lib.c                               |   16 +-
 sound/core/pcm_native.c                            |  132 +-
 sound/hda/intel-dsp-config.c                       |    4 +
 sound/pci/hda/patch_realtek.c                      |  157 +-
 sound/soc/codecs/da7219.c                          |    9 +-
 sound/soc/codecs/hdmi-codec.c                      |  144 +-
 sound/soc/fsl/fsl_micfil.c                         |   74 +-
 sound/soc/fsl/fsl_micfil.h                         |  270 +-
 sound/soc/intel/atom/sst/sst_acpi.c                |   64 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   48 +-
 sound/soc/stm/stm32_sai_sub.c                      |    6 +-
 sound/usb/6fire/chip.c                             |   10 +-
 sound/usb/caiaq/audio.c                            |   10 +-
 sound/usb/caiaq/audio.h                            |    1 +
 sound/usb/caiaq/device.c                           |   19 +-
 sound/usb/caiaq/input.c                            |   12 +-
 sound/usb/caiaq/input.h                            |    1 +
 sound/usb/clock.c                                  |   24 +-
 sound/usb/endpoint.c                               |   14 +-
 sound/usb/mixer_maps.c                             |   10 +
 sound/usb/quirks-table.h                           |   14 +-
 sound/usb/quirks.c                                 |   19 +-
 sound/usb/usx2y/us122l.c                           |    5 +-
 sound/usb/usx2y/usbusx2y.c                         |    2 +-
 tools/bpf/bpftool/jit_disasm.c                     |   51 +-
 tools/bpf/bpftool/main.h                           |   25 +-
 tools/bpf/bpftool/map.c                            |    1 -
 tools/bpf/bpftool/prog.c                           |   22 +-
 tools/lib/bpf/libbpf.c                             |    2 +-
 tools/lib/bpf/linker.c                             |    2 +
 tools/perf/builtin-trace.c                         |   16 +-
 tools/perf/util/cs-etm.c                           |   25 +-
 tools/perf/util/probe-finder.c                     |   21 +-
 tools/perf/util/probe-finder.h                     |    4 +-
 tools/scripts/Makefile.arch                        |    4 +-
 .../selftests/arm64/mte/check_tags_inclusion.c     |    4 +-
 tools/testing/selftests/arm64/pauth/pac.c          |    3 +
 tools/testing/selftests/bpf/test_sockmap.c         |  194 +-
 .../selftests/mount_setattr/mount_setattr_test.c   |    2 +-
 tools/testing/selftests/net/pmtu.sh                |    2 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |    3 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |    3 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |    6 +
 tools/testing/selftests/wireguard/netns.sh         |    1 +
 586 files changed, 9034 insertions(+), 6190 deletions(-)


