Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177A5215777;
	Thu, 12 Dec 2024 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017510; cv=none; b=AGAkARK5ZLSDWxxoFD7QpvjAqBm1PhWX4do3uJEKFantJIJSqTWfjjetKpfpYx17lAJrGFli3Qst/R80sjL3MS09zTRVKfXiFM/yG791+xjehb6CZ527VOXYZ1bwye8cGQc0qsLVLSCU+XrOf68QLKhj79TCyRku/vUP9icYIns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017510; c=relaxed/simple;
	bh=QSvViQhCHOvi7y6iML8RlRhAC2GSbHcva9kJ7mVma/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E9NswGJFyKrErHAREveQoyZvGChOCJOlieONVcM4pj9DGp6wYjhc9wvc553s87+8QPrH02uLIGKnzpIKO9xpyBC7JT00msn+bcoOgOlDGiLeEw3GhXZdJGLPr0YD/5neZVijTYWn9OxSnuY4ipGc9Q0SZSP3MDKwsTpluVnKhe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XErJ0G5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XErJ0G5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E895C4CECE;
	Thu, 12 Dec 2024 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017509;
	bh=QSvViQhCHOvi7y6iML8RlRhAC2GSbHcva9kJ7mVma/0=;
	h=From:To:Cc:Subject:Date:From;
	b=XErJ0G5w33QTtdUHVCYGr7214SkcFD8pxFCefIyWygEmvkfr6ws/TUW86XfpzzZ64
	 FL2onQPC5Gn1MocLKwxYEt6mWo9I74+A4ns8CtwKOwoVWtu1AKxwa5ZruELYE+VopG
	 MjAGr9jktRz+ybomFequvmiNHRcY3r4LGhuXl+rg=
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
Subject: [PATCH 6.6 000/356] 6.6.66-rc1 review
Date: Thu, 12 Dec 2024 15:55:19 +0100
Message-ID: <20241212144244.601729511@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.66-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.66-rc1
X-KernelTest-Deadline: 2024-12-14T14:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.66 release.
There are 356 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.66-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.66-rc1

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: fix possible assignment of the same address to two devices

Frank Li <Frank.Li@nxp.com>
    i3c: master: Remove i3c_dev_disable_ibi_locked(olddev) on device hotjoin

Arnd Bergmann <arnd@arndb.de>
    serial: amba-pl011: fix build regression

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-wmi: Fix thermal profile initialization

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Update UMP group attributes for GTB blocks, too

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Don't reset resource alloc flag

Wen Gu <guwen@linux.alibaba.com>
    net/smc: fix incorrect SMC-D link group matching logic

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix build error without CONFIG_SND_DEBUG

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: rework resume handling for display (v2)

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Fix return status of avs_pcm_hw_constraints_init()

Heming Zhao <heming.zhao@suse.com>
    ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"

Luca Stefani <luca.stefani.ge1@gmail.com>
    btrfs: add cancellation points to trim loops

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: invensense: fix multiple odr switch when FIFO is off

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix STALL transfer event handling

Zheng Yejian <zhengyejian@huaweicloud.com>
    mm/damon/vaddr: fix issue in damon_va_evenly_split_region()

Richard Weinberger <richard@nod.at>
    jffs2: Fix rtime decompressor

Kinsey Moore <kinsey.moore@oarcorp.com>
    jffs2: Prevent rtime decompress memory corruption

Nikolay Kuratov <kniv@yandex-team.ru>
    KVM: x86/mmu: Ensure that kvm_release_pfn_clean() takes exact pfn from kvm_faultin_pfn()

Hari Bathini <hbathini@linux.ibm.com>
    selftests/ftrace: adjust offset for kprobe syntax error test

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Align the page tracking max message size with the device capability

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "unicode: Don't special case ignorable code points"

Damien Le Moal <dlemoal@kernel.org>
    x86: Fix build regression with CONFIG_KEXEC_JUMP enabled

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix to release eprobe when failed to add dyn_event

Haoyu Li <lihaoyu499@gmail.com>
    clk: en7523: Initialize num before accessing hws in en7523_register_clocks()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing snapshot drew unlock when root is dead during swap activation

Wander Lairson Costa <wander@redhat.com>
    sched/deadline: Fix warning in migrate_enable for boosted tasks

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Move bandwidth accounting into {en,de}queue_dl_entity

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Collect sched_dl_entity initialization

Peter Zijlstra <peterz@infradead.org>
    sched: Unify more update_curr*()

Peter Zijlstra <peterz@infradead.org>
    sched: Remove vruntime from trace_sched_stat_runtime()

Peter Zijlstra <peterz@infradead.org>
    sched: Unify runtime accounting across classes

Kir Kolyshkin <kolyshkin@gmail.com>
    sched/headers: Move 'struct sched_param' out of uapi, to work around glibc/musl breakage

Ingo Molnar <mingo@kernel.org>
    sched/fair: Rename check_preempt_curr() to wakeup_preempt()

Ingo Molnar <mingo@kernel.org>
    sched/fair: Rename check_preempt_wakeup() to check_preempt_wakeup_fair()

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Prevent wakeup of ksoftirqd during idle load balance

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Remove the unnecessary need_resched() check in nohz_csd_func()

David Hildenbrand <david@redhat.com>
    mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM

Hugh Dickins <hughd@google.com>
    mempolicy: fix migrate_pages(2) syscall return nr_failed

Adrian Huang <ahuang12@lenovo.com>
    sched/numa: fix memory leak due to the overwritten vma->numab_state

Raghavendra K T <raghavendra.kt@amd.com>
    sched/numa: Fix mm numa_scan_seq based unconditional scan

Jens Axboe <axboe@kernel.dk>
    io_uring/tctx: work around xa_store() allocation error issue

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    setlocalversion: work around "git describe" performance

Paulo Alcantara <pc@manguebit.com>
    smb: client: don't try following DFS links in cifs_tree_connect()

Inochi Amaoto <inochiama@gmail.com>
    serial: 8250_dw: Add Sophgo SG2044 quirk

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    rtc: cmos: avoid taking rtc_lock for extended period of time

Parker Newman <pnewman@connecttech.com>
    misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/prom_init: Fixup missing powermac #size-cells

Uwe Kleine-König <ukleinek@debian.org>
    ASoC: amd: yc: Add quirk for microphone on Lenovo Thinkpad T14s Gen 6 21M1CTO1WW

Xi Ruoyao <xry111@xry111.site>
    MIPS: Loongson64: DTS: Really fix PCIe port nodes for ls7a

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu/vcn: reset fw_shared when VCPU buffers corrupted on vcn v4.0.3

Alex Far <anf1980@gmail.com>
    ASoC: amd: yc: fix internal mic on Redmi G 2022

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: light: ltr501: Add LTER0303 to the supported devices

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: handle USB Error Interrupt if IOC not set

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix case when unmarked clusters intersect with zone

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix sleeping in atomic context for PREEMPT_RT

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Clean up Asus entries in acpi_quirk_skip_dmi_ids[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add skip i2c clients quirk for Acer Iconia One 8 A1-840

Chao Yu <chao@kernel.org>
    f2fs: fix to shrink read extent node in batches

Chao Yu <chao@kernel.org>
    f2fs: print message if fscorrupted was found in f2fs_new_node_page()

Defa Li <defa.li@mediatek.com>
    i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock

Mengyuan Lou <mengyuanlou@net-swift.com>
    PCI: Add ACS quirk for Wangxun FF5xxx NICs

Keith Busch <kbusch@kernel.org>
    PCI: Add 'reset_subordinate' to reset hierarchy below bridge

Esther Shimanovich <eshimanovich@chromium.org>
    PCI: Detect and trust built-in Thunderbolt chips

Jian-Hong Pan <jhp@endlessos.org>
    PCI: vmd: Set devices to D0 before enabling PM L1 Substates

Nirmal Patel <nirmal.patel@linux.ntel.com>
    PCI: vmd: Add DID 8086:B06F and 8086:B60B for Intel client SKUs

devi priya <quic_devipriy@quicinc.com>
    PCI: qcom: Add support for IPQ9574

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Mask ring interrupts before ring stop request

Qianqiang Liu <qianqiang.liu@163.com>
    KMSAN: uninit-value in inode_go_dump (5)

Qi Han <hanqi@vivo.com>
    f2fs: fix f2fs_bug_on when uninstalling filesystem call f2fs_evict_inode.

Gabriele Monaco <gmonaco@redhat.com>
    verification/dot2: Improve dot parser robustness

Kees Cook <kees@kernel.org>
    smb: client: memcpy() with surrounding object base address

Yi Yang <yiyang13@huawei.com>
    nvdimm: rectify the illogical code within nd_dax_probe()

Barnabás Czémán <barnabas.czeman@mainlining.org>
    thermal/drivers/qcom/tsens-v1: Add support for MSM8937 tsens

Barnabás Czémán <barnabas.czeman@mainlining.org>
    pinctrl: qcom: spmi-mpp: Add PM8937 compatible

Barnabás Czémán <barnabas.czeman@mainlining.org>
    pinctrl: qcom-pmic-gpio: add support for PM8937

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Don't modify unknown block number in MTIOCGET

Mukesh Ojha <quic_mojha@quicinc.com>
    leds: class: Protect brightness_show() with led_cdev->led_access mutex

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: tcsrcc-sm8550: add SAR2130P support

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: rpmh: add support for SAR2130P

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: rcg2: add clk_rcg2_shared_floor_ops

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Call lpfc_sli4_queue_unset() in restart and rmmod paths

Andrii Nakryiko <andrii@kernel.org>
    bpf: put bpf_link's program when link is safe to be deallocated

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Make DMA mask configuration more flexible

Mukesh Ojha <quic_mojha@quicinc.com>
    pinmux: Use sequential access to access desc->pinmux data

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add cond_resched() for no forced preemption model

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat: Make timerlat_top_cpu->*_count unsigned long long

Jan Stancek <jstancek@redhat.com>
    tools/rtla: fix collision with glibc sched_attr/sched_set_attr

Uros Bizjak <ubizjak@gmail.com>
    tracing: Use atomic64_inc_return() in trace_clock_counter()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracing/ftrace: disable preemption in syscall probe

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

Danil Pylaev <danstiv404@gmail.com>
    Bluetooth: Set quirks for ATS2851

Danil Pylaev <danstiv404@gmail.com>
    Bluetooth: Support new quirks for ATS2851

Danil Pylaev <danstiv404@gmail.com>
    Bluetooth: Add new quirks for ATS2851

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not checking skb length on hci_acldata_packet

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e123 to device tables

Andrew Lunn <andrew@lunn.ch>
    dsa: qca8k: Use nested lock to avoid splat

Hou Tao <houtao1@huawei.com>
    bpf: Call free_htab_elem() after htab_unlock_bucket()

Norbert van Bolhuis <nvbolhuis@gmail.com>
    wifi: brcmfmac: Fix oops due to NULL pointer dereference in brcmf_sdiod_sglist_rw()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    wifi: ipw2x00: libipw_rx_any(): fix bad alignment

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: set the right AMDGPU sg segment limitation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Make mic volume workarounds globally applicable

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio-net: fix overflow inside virtnet_rq_alloc

Victor Zhao <Victor.Zhao@amd.com>
    drm/amdgpu: skip amdgpu_device_cache_pci_state under sriov

Aleksandr Mishin <amishin@t-argos.ru>
    fsl/fman: Validate cell-index value obtained from Device Tree

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

Donald Hunter <donald.hunter@gmail.com>
    netlink: specs: Add missing bitset attrs to ethtool spec

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: Dereference the ATCS ACPI buffer

Victor Lu <victorchengchi.lu@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for vega20_ih

Philipp Stanner <pstanner@redhat.com>
    drm/sched: memset() 'job' in drm_sched_job_init()

Abhishek Chauhan <quic_abchauha@quicinc.com>
    net: stmmac: Programming sequence for VLAN packets with split header

Shengyu Qu <wiagn233@outlook.com>
    net: sfp: change quirks for Alcatel Lucent G-010S-P

Manikandan Muralidharan <manikandan.m@microchip.com>
    drm/panel: simple: Add Microchip AC69T88A LVDS Display panel

Amir Goldstein <amir73il@gmail.com>
    fanotify: allow reporting errors on failure to open fd

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
    Bluetooth: RFCOMM: avoid leaving dangling sk pointer in rfcomm_sock_alloc()

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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Use the new codec SSID matching

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use own quirk lookup helper

Brahmajit Das <brahmajit.xyz@gmail.com>
    drm/display: Fix building with GCC 15

Alexander Aring <aahringo@redhat.com>
    dlm: fix possible lkb_resource null dereference

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: check return value of ieee80211_probereq_get() for RNR

Liao Chen <liaochen4@huawei.com>
    drm/mcde: Enable module autoloading

Liao Chen <liaochen4@huawei.com>
    drm/bridge: it6505: Enable module autoloading

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO GEEK

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO Founder edition

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO 2 model

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Set AXI panic modes for the HVS

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid log spam for audio start failure

Callahan Kovacs <callahankovacs@gmail.com>
    HID: magicmouse: Apple Magic Trackpad 2 USB-C driver support

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Protect against array overflow when reading strings

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    regmap: maple: Provide lockdep (sub)class for maple tree's internal lock

Marek Vasut <marex@denx.de>
    soc: imx8m: Probe the SoC driver as platform driver

Peng Fan <peng.fan@nxp.com>
    mmc: sdhci-esdhc-imx: enable quirks SDHCI_QUIRK_NO_LED

Keita Aihara <keita.aihara@sony.com>
    mmc: core: Add SD card quirk for broken poweroff notification

Rohan Barar <rohan.barar@gmail.com>
    media: cx231xx: Add support for Dexatek USB Video Grabber 1d19:6108

David Given <dg@cowlark.com>
    media: uvcvideo: Add a quirk for the Kaiweets KTI-W02 infrared camera

Dmitry Perchanov <dmitry.perchanov@intel.com>
    media: uvcvideo: RealSense D421 Depth module metadata

Benjamin Tissoires <bentiss@kernel.org>
    HID: add per device quirk to force bind to hid-generic

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Adjust type of scldiv

Breno Leitao <leitao@debian.org>
    perf/x86/amd: Warn only on new bits set

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Make UART skip quirks work on PCI UARTs without an UID

Sarah Maedel <sarah.maedel@hetzner-cloud.de>
    hwmon: (nct6775) Add 665-ACE/600M-CL to ASUS WMI monitoring list

Marco Elver <elver@google.com>
    kcsan: Turn report_filterlist_lock into a raw_spinlock

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Don't leak pipe fds in pac.exec_sign_all()

Boris Burkov <boris@bur.io>
    btrfs: do not clear read-only when adding sprout device

Qu Wenruo <wqu@suse.com>
    btrfs: avoid unnecessary device path update for the same device

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't take dev_replace rwsem on task already holding it

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Handle CPU hotplug remove during sampling

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Log fp-stress child startup errors to stdout

Christian Brauner <brauner@kernel.org>
    epoll: annotate racy check

David Woodhouse <dwmw@amazon.co.uk>
    x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables

Jared Kangas <jkangas@redhat.com>
    kasan: make report_lock a raw spinlock

Kees Cook <kees@kernel.org>
    lib: stackinit: hide never-taken branch from compiler

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

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    dma-fence: Use kernel's sort for merging fences

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    dma-fence: Fix reference leak on fence merge failure path

Christian König <christian.koenig@amd.com>
    dma-buf: fix dma_fence_array_signaled v4

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    bpf: fix OOB devmap writes when deleting elements

David Woodhouse <dwmw@amazon.co.uk>
    x86/kexec: Restore GDT on return from ::preserve_context kexec

Thomas Gleixner <tglx@linutronix.de>
    modpost: Add .irqentry.text to OTHER_SECTIONS

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp5.2: do a posting read when flushing HDP

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix resetting msg rx state after topology removal

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Verify request type in the corresponding down message reply

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix MST sideband message body length check

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    cacheinfo: Allocate memory during CPU hotplug if not done from the primary CPU

Liequan Che <cheliequan@inspur.com>
    bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again

Steve French <stfrench@microsoft.com>
    smb3.1.1: fix posix mounts to older servers

Ralph Boehme <slow@samba.org>
    fs/smb/client: cifs_prime_dcache() for SMB3 POSIX reparse points

Ralph Boehme <slow@samba.org>
    fs/smb/client: Implement new SMB3 POSIX type

Ralph Boehme <slow@samba.org>
    fs/smb/client: avoid querying SMB2_OP_QUERY_WSL_EA for SMB3 POSIX

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Add missing post notify for power mode change

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

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ensure bits ASID[15:8] are masked out when the kernel uses 8-bit ASIDs

Kuan-Wei Chiu <visitorckw@gmail.com>
    tracing: Fix cmp_entries_dup() to respect sort() comparison rules

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_get_tef_len(): work around erratum DS80000789E 6.

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: can_set_termination(): allow sleeping GPIOs

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    watchdog: rti: of: honor timeout-sec property

Jordy Zomer <jordyzomer@google.com>
    ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write

Jordy Zomer <jordyzomer@google.com>
    ksmbd: fix Out-of-Bounds Read in ksmbd_vfs_stream_read

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Add architecture specific huge_pte_clear()

WangYuli <wangyuli@uniontech.com>
    HID: wacom: fix when get product name maybe null pointer

Roman Gushchin <roman.gushchin@linux.dev>
    mm: page_alloc: move mlocked flag clearance into free_pages_prepare()

Sean Christopherson <seanjc@google.com>
    x86/CPU/AMD: WARN when setting EFER.AUTOIBRS if and only if the WRMSR fails

Hou Tao <houtao1@huawei.com>
    bpf: Fix exact match conditions in trie_get_next_key()

Hou Tao <houtao1@huawei.com>
    bpf: Handle in-place update for full LPM trie correctly

Hou Tao <houtao1@huawei.com>
    bpf: Remove unnecessary kfree(im_node) in lpm_trie_update_elem

Hou Tao <houtao1@huawei.com>
    bpf: Handle BPF_EXIST and BPF_NOEXIST for LPM trie

Jakob Hauser <jahau@rocketmail.com>
    iio: magnetometer: yas530: use signed integer type for clamp limits

Randy Dunlap <rdunlap@infradead.org>
    scatterlist: fix incorrect func name in kernel-doc

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ocfs2: free inode when ocfs2_get_init_inode() fails

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Enable Performance Counters before clearing them

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt8188-mt6359: Remove hardcoded dmic codec

John Garry <john.g.garry@oracle.com>
    scsi: scsi_debug: Fix hrtimer support for ndelay

Suraj Sonawane <surajsonawane0215@gmail.com>
    scsi: sg: Fix slab-use-after-free read in sg_release()

Tao Lyu <tao.lyu@epfl.ch>
    bpf: Fix narrow scalar spill onto 64-bit spilled scalar slots

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: SOF: ipc3-topology: fix resource leaks in sof_ipc3_widget_setup_comp_dai()

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: ipc3-topology: Convert the topology pin index to ALH dai index

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mpc52xx: Add cancel_work_sync before module remove

Björn Töpel <bjorn@rivosinc.com>
    tools: Override makefile ARCH variable if defined, but empty

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Notify xrun for low-latency mode

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Fix seq port updates per FB info notify

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Update substream name from assigned FB names

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Use automatic cleanup of kfree()

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Fix the sk_mem_uncharge logic in tcp_bpf_sendmsg

Pei Xiao <xiaopei01@kylinos.cn>
    drm/sti: Add __iomem for mixer_dbg_mxn's parameter

Amir Mohammadi <amirmohammadi1999.am@gmail.com>
    bpftool: fix potential NULL pointer dereferencing in prog_dump()

Larysa Zaremba <larysa.zaremba@intel.com>
    xsk: always clear DMA mapping information when unmapping the pool

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Invoke proto::close on close()

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Fix poll() missing a queue

Ziqi Chen <quic_ziqichen@quicinc.com>
    scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Always initialize the UIC done completion

Chen-Yu Tsai <wenst@chromium.org>
    drm/bridge: it6505: Fix inverted reset polarity

Kuro Chung <kuro.chung@ite.com.tw>
    drm/bridge: it6505: update usleep_range for RC circuit charge time

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix dynamic address leak when 'assigned-address' is present

Frank Li <Frank.Li@nxp.com>
    i3c: master: Extend address status bit to 4 and add I3C_ADDR_SLOT_EXT_DESIRED

Frank Li <Frank.Li@nxp.com>
    i3c: master: Replace hard code 2 with macro I3C_ADDR_SLOT_STATUS_BITS

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter

Carlos Song <carlos.song@nxp.com>
    i3c: master: svc: use slow speed for first broadcast address

Carlos Song <carlos.song@nxp.com>
    i3c: master: support to adjust first broadcast address speed

Frank Li <Frank.Li@nxp.com>
    i3c: master: fix kernel-doc check warning

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: add hot join support

Frank Li <Frank.Li@nxp.com>
    i3c: master: add enable(disable) hot join in sys entry

Chao Yu <chao@kernel.org>
    f2fs: fix to drop all discards after creating snapshot on lvm device

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Stop trying to optimize cycle detection logic

Saravana Kannan <saravanak@google.com>
    driver core: Add FWLINK_FLAG_IGNORE to completely ignore a fwnode link

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Improve logs for cycle detection

Marcelo Dalmas <marcelo.dalmas@ge.com>
    ntp: Remove invalid cast in time offset math

Nathan Chancellor <nathan@kernel.org>
    powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Refactor CFLAGS for CVDSO build

Pratyush Brahma <quic_pbrahma@quicinc.com>
    iommu/arm-smmu: Defer probe of clients after smmu device bound

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: clear IDLE flag in mark_idle()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: do not mark idle slots that cannot be idle

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: split memory-tracking and ac-time tracking

Andy-ld Lu <andy-ld.lu@mediatek.com>
    mmc: mtk-sd: Fix MMC_CAP2_CRYPTO flag setting

Rosen Penev <rosenp@gmail.com>
    mmc: mtk-sd: fix devm_clk_get_optional usage

Andy-ld Lu <andy-ld.lu@mediatek.com>
    mmc: mtk-sd: Fix error handle of probe function

Rosen Penev <rosenp@gmail.com>
    mmc: mtk-sd: use devm_mmc_alloc_host

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Don't clear ep0 DWC3_EP_TRANSFER_STARTED

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: ep0: Don't reset resource alloc flag (including ep0)

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Rewrite endpoint allocation flow

Herve Codina <herve.codina@bootlin.com>
    soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure

Herve Codina <herve.codina@bootlin.com>
    soc: fsl: cpm1: qmc: Introduce qmc_{init,exit}_xcc() and their CPM1 version

Herve Codina <herve.codina@bootlin.com>
    soc: fsl: cpm1: qmc: Introduce qmc_init_resource() and its CPM1 version

Herve Codina <herve.codina@bootlin.com>
    soc: fsl: cpm1: qmc: Re-order probe() operations

Herve Codina <herve.codina@bootlin.com>
    soc: fsl: cpm1: qmc: Fix blank line and spaces

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    soc/fsl: cpm: qmc: Convert to platform remove callback returning void

Kartik Rajput <kkartik@nvidia.com>
    serial: amba-pl011: Fix RX stall when DMA is used

Thomas Gleixner <tglx@linutronix.de>
    serial: amba-pl011: Use port lock wrappers

Charles Han <hanchunchao@inspur.com>
    gpio: grgpio: Add NULL check in grgpio_probe

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: grgpio: use a helper variable to store the address of ofdev->dev

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Fix control transfer error on Etron xHCI host

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Don't issue Reset Device command to Etron xHCI host

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Combine two if statements for Etron xHCI host

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: remove XHCI_TRUST_TX_LENGTH quirk

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    xhci: Allow RPM on the USB controller (1022:43f7) by default

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Don't retire aborted MMIO instruction

Fuad Tabba <tabba@google.com>
    KVM: arm64: Change kvm_handle_mmio_return() return polarity

Eric Dumazet <edumazet@google.com>
    net: avoid potential UAF in default_operstate()

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Remove workaround to avoid syndrome for internal port

Eric Dumazet <edumazet@google.com>
    geneve: do not assume mac header is set in geneve_xmit_skb()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mlxsw: spectrum_acl_flex_keys: Constify struct mlxsw_afk_element_inst

Amit Cohen <amcohen@nvidia.com>
    mlxsw: Mark high entropy key blocks

Amit Cohen <amcohen@nvidia.com>
    mlxsw: Edit IPv6 key blocks to use one less block for multicast forwarding

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum_acl_flex_keys: Add 'ipv4_5b' flex key

Amit Cohen <amcohen@nvidia.com>
    mlxsw: Add 'ipv4_5' flex key

Kory Maincent <kory.maincent@bootlin.com>
    ethtool: Fix wrong mod state in case of verbose and no_mask bitset

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: skip duplicated elements pending gc run

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Hold module reference while requesting a module

Xin Long <lucien.xin@gmail.com>
    net: sched: fix erspan_opt settings in cls_flower

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_inner: incorrect percpu area handling under softirq

Yuan Can <yuancan@huawei.com>
    igb: Fix potential invalid memory access in igb_init_module()

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: downgrade logging of unsupported VF API version to debug

Jacob Keller <jacob.e.keller@intel.com>
    ixgbevf: stop attempting IPSEC offload on Mailbox API 1.5

Louis Leseur <louis.leseur@gmail.com>
    net/qed: allow old cards not supporting "num_images" to work

Wen Gu <guwen@linux.alibaba.com>
    net/smc: fix LGR and link use-after-free issue

Wen Gu <guwen@linux.alibaba.com>
    net/smc: initialize close_work early to avoid warning

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: refactoring initialization of smc sock

Wen Gu <guwen@linux.alibaba.com>
    net/smc: {at|de}tach sndbuf to peer DMB if supported

Wen Gu <guwen@linux.alibaba.com>
    net/smc: add operations to merge sndbuf with peer DMB

Wen Gu <guwen@linux.alibaba.com>
    net/smc: mark optional smcd_ops and check for support when called

Wen Gu <guwen@linux.alibaba.com>
    net/smc: compatible with 128-bits extended GID of virtual ISM device

Wen Gu <guwen@linux.alibaba.com>
    net/smc: define a reserved CHID range for virtual ISM devices

Wen Gu <guwen@linux.alibaba.com>
    net/smc: unify the structs of accept or confirm message for v1 and v2

Wen Gu <guwen@linux.alibaba.com>
    net/smc: introduce sub-functions for smc_clc_send_confirm_accept()

Wen Gu <guwen@linux.alibaba.com>
    net/smc: rename some 'fce' to 'fce_v2x' for clarity

Kuniyuki Iwashima <kuniyu@amazon.com>
    tipc: Fix use-after-free of kernel socket in cleanup_bearer().

Ivan Solodovnikov <solodovnikov.ia@phystech.edu>
    dccp: Fix memory leak in dccp_feat_change_recv

Jiri Wiesner <jwiesner@suse.de>
    net/ipv6: release expired exception dst cached in socket

Eric Dumazet <edumazet@google.com>
    ipv6: introduce dst_rt6_info() helper

Vadim Fedorenko <vadfed@meta.com>
    net-timestamp: make sk_tskey more predictable in error path

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-wmi: Ignore return value when writing thermal policy

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-wmi: Fix inconsistent use of thermal policies

Mohamed Ghanmi <mohamed.ghanmi@supcom.tn>
    platform/x86: asus-wmi: add support for vivobook fan profiles

Dmitry Antipov <dmantipov@yandex.ru>
    can: j1939: j1939_session_new(): fix skb reference counting

Eric Dumazet <edumazet@google.com>
    net: hsr: avoid potential out-of-bound access in fill_frame_info()

Martin Ottens <martin.ottens@fau.de>
    net/sched: tbf: correct backlog statistic for GSO packets

Ajay Kaher <ajay.kaher@broadcom.com>
    ptp: Add error handling for adjfine callback in ptp_clock_adjtime

Wei Fang <wei.fang@nxp.com>
    net: enetc: Do not configure preemptible TCs if SIs do not support

Maximilian Heyne <mheyne@amazon.de>
    selftests: hid: fix typo and exit code

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level

Dmitry Antipov <dmantipov@yandex.ru>
    netfilter: x_tables: fix LED ID check in led_tg_check()

Jinghao Jia <jinghao7@illinois.edu>
    ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: f81604: f81604_handle_can_bus_errors(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: ems_usb: ems_usb_rx_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sja1000: sja1000_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: hi311x: hi3110_can_ist(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: ifi_canfd: ifi_canfd_handle_lec_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: m_can: m_can_handle_lec_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: hi311x: hi3110_can_ist(): fix potential use-after-free

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: c_can: c_can_handle_bus_err(): update statistics if skb allocation fails

Alexander Kozhinov <ak.alexander.kozhinov@gmail.com>
    can: gs_usb: add usb endpoint address detection at driver probe step

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: add VID/PID for Xylanta SAINT3 product family

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()

Nick Chan <towinchenmi@gmail.com>
    watchdog: apple: Actually flush writes after requesting watchdog restart

Harini T <harini.t@amd.com>
    watchdog: xilinx_wwdt: Calculate max_hw_heartbeat_ms using clock frequency

Oleksandr Ocheretnyi <oocheret@cisco.com>
    iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-pci            |   11 +
 Documentation/admin-guide/blockdev/zram.rst        |    2 +-
 Documentation/netlink/specs/ethtool.yaml           |    7 +-
 Makefile                                           |    4 +-
 arch/arm64/kernel/ptrace.c                         |    6 +-
 arch/arm64/kvm/arm.c                               |    2 +-
 arch/arm64/kvm/mmio.c                              |   36 +-
 arch/arm64/mm/context.c                            |    4 +-
 arch/loongarch/include/asm/hugetlb.h               |   10 +
 arch/loongarch/mm/tlb.c                            |    2 +-
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          |   73 +-
 arch/powerpc/kernel/prom_init.c                    |   29 +-
 arch/powerpc/kernel/vdso/Makefile                  |   36 +-
 arch/s390/kernel/perf_cpum_sf.c                    |    4 +-
 arch/x86/events/amd/core.c                         |   10 +-
 arch/x86/include/asm/pgtable_types.h               |    8 +-
 arch/x86/kernel/cpu/amd.c                          |    2 +-
 arch/x86/kernel/relocate_kernel_64.S               |    8 +
 arch/x86/kvm/mmu/mmu.c                             |   10 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    5 +-
 arch/x86/mm/ident_map.c                            |    6 +-
 arch/x86/mm/pti.c                                  |    2 +-
 arch/x86/pci/acpi.c                                |  119 +
 drivers/acpi/x86/utils.c                           |   83 +-
 drivers/base/cacheinfo.c                           |   14 +-
 drivers/base/core.c                                |   69 +-
 drivers/base/regmap/internal.h                     |    1 +
 drivers/base/regmap/regcache-maple.c               |    3 +
 drivers/base/regmap/regmap.c                       |   13 +
 drivers/block/zram/Kconfig                         |   11 +-
 drivers/block/zram/zram_drv.c                      |   50 +-
 drivers/block/zram/zram_drv.h                      |    2 +-
 drivers/bluetooth/btusb.c                          |    4 +
 drivers/clk/clk-en7523.c                           |    4 +-
 drivers/clk/qcom/clk-rcg.h                         |    1 +
 drivers/clk/qcom/clk-rcg2.c                        |   48 +-
 drivers/clk/qcom/clk-rpmh.c                        |   13 +
 drivers/clk/qcom/tcsrcc-sm8550.c                   |   18 +-
 drivers/dma-buf/dma-fence-array.c                  |   28 +-
 drivers/dma-buf/dma-fence-unwrap.c                 |  126 +-
 drivers/gpio/gpio-grgpio.c                         |   26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   48 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |    5 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c              |    6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   30 +-
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c             |   27 +
 drivers/gpu/drm/bridge/ite-it6505.c                |   11 +-
 drivers/gpu/drm/display/drm_dp_dual_mode_helper.c  |    4 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   55 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   18 +
 drivers/gpu/drm/mcde/mcde_drv.c                    |    1 +
 drivers/gpu/drm/panel/panel-simple.c               |   28 +
 drivers/gpu/drm/radeon/r600_cs.c                   |    2 +-
 drivers/gpu/drm/scheduler/sched_main.c             |    8 +
 drivers/gpu/drm/sti/sti_mixer.c                    |    2 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |    2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |    2 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   11 +
 drivers/hid/hid-core.c                             |    5 +-
 drivers/hid/hid-generic.c                          |    3 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-magicmouse.c                       |   56 +-
 drivers/hid/wacom_sys.c                            |    3 +-
 drivers/hwmon/nct6775-platform.c                   |    2 +
 drivers/i3c/master.c                               |  193 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |    2 +-
 drivers/i3c/master/svc-i3c-master.c                |  140 +-
 .../iio/common/inv_sensors/inv_sensors_timestamp.c |    4 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |    2 -
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |    2 -
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |    1 -
 drivers/iio/light/ltr501.c                         |    2 +
 drivers/iio/magnetometer/yamaha-yas530.c           |   13 +-
 drivers/infiniband/core/addr.c                     |    6 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |   11 +
 drivers/leds/led-class.c                           |   14 +-
 drivers/md/bcache/super.c                          |    2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    2 +
 drivers/media/usb/uvc/uvc_driver.c                 |   20 +
 drivers/misc/eeprom/eeprom_93cx6.c                 |   10 +
 drivers/mmc/core/bus.c                             |    2 +
 drivers/mmc/core/card.h                            |    7 +
 drivers/mmc/core/core.c                            |    3 +
 drivers/mmc/core/quirks.h                          |    9 +
 drivers/mmc/core/sd.c                              |    2 +-
 drivers/mmc/host/mtk-sd.c                          |   64 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    6 +
 drivers/mmc/host/sdhci-pci-core.c                  |   72 +
 drivers/mmc/host/sdhci-pci.h                       |    1 +
 drivers/net/can/c_can/c_can_main.c                 |   26 +-
 drivers/net/can/dev/dev.c                          |    2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   58 +-
 drivers/net/can/m_can/m_can.c                      |   33 +-
 drivers/net/can/sja1000/sja1000.c                  |   65 +-
 drivers/net/can/spi/hi311x.c                       |   48 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   29 +-
 drivers/net/can/sun4i_can.c                        |   22 +-
 drivers/net/can/usb/ems_usb.c                      |   58 +-
 drivers/net/can/usb/f81604.c                       |   10 +-
 drivers/net/can/usb/gs_usb.c                       |   28 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    3 +
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    2 +-
 drivers/net/ethernet/freescale/fman/fman.c         |    1 -
 drivers/net/ethernet/freescale/fman/fman.h         |    3 +
 drivers/net/ethernet/freescale/fman/mac.c          |    5 +
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |    2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h    |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |    1 -
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   13 +-
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c   |   12 +-
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.h   |   17 +-
 .../ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c    |   20 +-
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c        |   96 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   14 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |    5 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |    5 +
 drivers/net/geneve.c                               |    2 +-
 drivers/net/phy/sfp.c                              |    3 +-
 drivers/net/virtio_net.c                           |   12 +-
 drivers/net/vrf.c                                  |    2 +-
 drivers/net/vxlan/vxlan_core.c                     |    2 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    8 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |    3 +
 drivers/nvdimm/dax_devs.c                          |    4 +-
 drivers/nvdimm/nd.h                                |    7 +
 drivers/pci/controller/dwc/pcie-qcom.c             |    1 +
 drivers/pci/controller/vmd.c                       |   17 +-
 drivers/pci/pci-sysfs.c                            |   26 +
 drivers/pci/pci.c                                  |    2 +-
 drivers/pci/pci.h                                  |    1 +
 drivers/pci/probe.c                                |   30 +-
 drivers/pci/quirks.c                               |   15 +-
 drivers/pinctrl/core.c                             |    3 +
 drivers/pinctrl/core.h                             |    1 +
 drivers/pinctrl/freescale/Kconfig                  |    2 +-
 drivers/pinctrl/pinmux.c                           |  173 +-
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |    2 +
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c            |    1 +
 drivers/platform/x86/asus-wmi.c                    |  109 +-
 drivers/ptp/ptp_clock.c                            |    3 +-
 drivers/rtc/rtc-cmos.c                             |   37 +-
 drivers/s390/net/ism_drv.c                         |   19 +-
 drivers/s390/net/qeth_core.h                       |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    1 +
 drivers/scsi/lpfc/lpfc_init.c                      |    2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   41 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |  124 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   15 +-
 drivers/scsi/scsi_debug.c                          |    2 +-
 drivers/scsi/sg.c                                  |    2 +-
 drivers/scsi/st.c                                  |   31 +-
 drivers/soc/fsl/qe/qmc.c                           |  141 +-
 drivers/soc/imx/soc-imx8m.c                        |  107 +-
 drivers/spi/spi-fsl-lpspi.c                        |    7 +-
 drivers/spi/spi-mpc52xx.c                          |    1 +
 drivers/thermal/qcom/tsens-v1.c                    |   21 +-
 drivers/thermal/qcom/tsens.c                       |    3 +
 drivers/thermal/qcom/tsens.h                       |    2 +-
 drivers/tty/serial/8250/8250_dw.c                  |    5 +-
 drivers/tty/serial/amba-pl011.c                    |   79 +-
 drivers/ufs/core/ufs-sysfs.c                       |    6 +
 drivers/ufs/core/ufs_bsg.c                         |    2 +-
 drivers/ufs/core/ufshcd-priv.h                     |    1 +
 drivers/ufs/core/ufshcd.c                          |   58 +-
 drivers/ufs/host/ufs-renesas.c                     |    9 +-
 drivers/usb/chipidea/udc.c                         |    2 +-
 drivers/usb/dwc3/core.h                            |    1 +
 drivers/usb/dwc3/ep0.c                             |    7 +-
 drivers/usb/dwc3/gadget.c                          |   89 +-
 drivers/usb/dwc3/gadget.h                          |    1 +
 drivers/usb/host/xhci-dbgcap.c                     |  135 +-
 drivers/usb/host/xhci-dbgcap.h                     |    2 +-
 drivers/usb/host/xhci-pci.c                        |   21 +-
 drivers/usb/host/xhci-rcar.c                       |    6 +-
 drivers/usb/host/xhci-ring.c                       |   29 +-
 drivers/usb/host/xhci.c                            |   19 +
 drivers/usb/host/xhci.h                            |    5 +-
 drivers/vfio/pci/mlx5/cmd.c                        |   47 +-
 drivers/watchdog/apple_wdt.c                       |    2 +-
 drivers/watchdog/iTCO_wdt.c                        |   21 +-
 drivers/watchdog/mtk_wdt.c                         |    6 +
 drivers/watchdog/rti_wdt.c                         |    3 +-
 drivers/watchdog/xilinx_wwdt.c                     |   75 +-
 fs/btrfs/dev-replace.c                             |    2 +
 fs/btrfs/extent-tree.c                             |    7 +-
 fs/btrfs/free-space-cache.c                        |    4 +-
 fs/btrfs/free-space-cache.h                        |    7 +
 fs/btrfs/fs.h                                      |    2 +
 fs/btrfs/inode.c                                   |    1 +
 fs/btrfs/volumes.c                                 |   50 +-
 fs/dlm/lock.c                                      |   10 +-
 fs/eventpoll.c                                     |    6 +-
 fs/f2fs/extent_cache.c                             |   69 +-
 fs/f2fs/inode.c                                    |    4 +-
 fs/f2fs/node.c                                     |    7 +-
 fs/f2fs/segment.c                                  |    9 +
 fs/f2fs/super.c                                    |   12 +
 fs/gfs2/super.c                                    |    2 +
 fs/jffs2/compr_rtime.c                             |    3 +
 fs/jfs/jfs_dmap.c                                  |    6 +
 fs/jfs/jfs_dtree.c                                 |   15 +
 fs/nilfs2/dir.c                                    |    2 +-
 fs/notify/fanotify/fanotify_user.c                 |   85 +-
 fs/ntfs3/run.c                                     |   40 +-
 fs/ocfs2/dlmglue.c                                 |    1 +
 fs/ocfs2/localalloc.c                              |   19 -
 fs/ocfs2/namei.c                                   |    4 +-
 fs/smb/client/cifsproto.h                          |    1 +
 fs/smb/client/cifssmb.c                            |    2 +-
 fs/smb/client/dfs.c                                |  188 +-
 fs/smb/client/inode.c                              |   94 +-
 fs/smb/client/readdir.c                            |   54 +-
 fs/smb/client/reparse.c                            |   90 +-
 fs/smb/client/smb2inode.c                          |    3 +-
 fs/smb/server/smb2pdu.c                            |    6 +
 fs/unicode/mkutf8data.c                            |   70 +
 fs/unicode/utf8data.c_shipped                      | 6703 ++++++++++----------
 include/drm/display/drm_dp_mst_helper.h            |    7 +
 include/linux/eeprom_93cx6.h                       |   11 +
 include/linux/eventpoll.h                          |    2 +-
 include/linux/fanotify.h                           |    1 +
 include/linux/fwnode.h                             |    2 +
 include/linux/hid.h                                |    2 +
 include/linux/i3c/master.h                         |   33 +-
 include/linux/leds.h                               |    2 +-
 include/linux/mm_types.h                           |    3 +
 include/linux/mmc/card.h                           |    1 +
 include/linux/pci.h                                |    6 +
 include/linux/platform_data/x86/asus-wmi.h         |    1 +
 include/linux/scatterlist.h                        |    2 +-
 include/linux/sched.h                              |    7 +-
 include/net/bluetooth/hci.h                        |   14 +
 include/net/bluetooth/hci_core.h                   |   10 +-
 include/net/ip6_fib.h                              |    6 +-
 include/net/ip6_route.h                            |   11 +-
 include/net/netfilter/nf_tables_core.h             |    1 +
 include/net/smc.h                                  |   28 +-
 include/sound/ump.h                                |   11 +
 include/trace/events/sched.h                       |   15 +-
 include/trace/trace_events.h                       |   36 +-
 include/uapi/linux/fanotify.h                      |    1 +
 include/uapi/linux/sched/types.h                   |    4 -
 include/ufs/ufshcd.h                               |   19 +-
 io_uring/tctx.c                                    |   13 +-
 kernel/bpf/devmap.c                                |    6 +-
 kernel/bpf/hashtab.c                               |   56 +-
 kernel/bpf/lpm_trie.c                              |   55 +-
 kernel/bpf/syscall.c                               |   22 +-
 kernel/bpf/verifier.c                              |    1 +
 kernel/dma/debug.c                                 |    8 +-
 kernel/kcsan/debugfs.c                             |   74 +-
 kernel/sched/core.c                                |   23 +-
 kernel/sched/deadline.c                            |  180 +-
 kernel/sched/fair.c                                |   98 +-
 kernel/sched/idle.c                                |    4 +-
 kernel/sched/rt.c                                  |   21 +-
 kernel/sched/sched.h                               |   27 +-
 kernel/sched/stop_task.c                           |   17 +-
 kernel/time/ntp.c                                  |    2 +-
 kernel/trace/trace_clock.c                         |    2 +-
 kernel/trace/trace_eprobe.c                        |    5 +
 kernel/trace/trace_syscalls.c                      |   12 +
 kernel/trace/tracing_map.c                         |    6 +-
 lib/stackinit_kunit.c                              |    1 +
 mm/damon/vaddr-test.h                              |    1 +
 mm/damon/vaddr.c                                   |    4 +-
 mm/kasan/report.c                                  |    6 +-
 mm/mempolicy.c                                     |  346 +-
 mm/page_alloc.c                                    |   15 +
 mm/swap.c                                          |   20 -
 net/bluetooth/6lowpan.c                            |    2 +-
 net/bluetooth/hci_core.c                           |   13 +-
 net/bluetooth/hci_event.c                          |    7 +
 net/bluetooth/hci_sync.c                           |    9 +-
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/rfcomm/sock.c                        |   10 +-
 net/can/af_can.c                                   |    1 +
 net/can/j1939/transport.c                          |    2 +-
 net/core/dst_cache.c                               |    2 +-
 net/core/filter.c                                  |    2 +-
 net/core/link_watch.c                              |    7 +-
 net/core/neighbour.c                               |    1 +
 net/core/netpoll.c                                 |    2 +-
 net/dccp/feat.c                                    |    6 +-
 net/ethtool/bitset.c                               |   48 +-
 net/hsr/hsr_forward.c                              |    2 +
 net/ieee802154/socket.c                            |   12 +-
 net/ipv4/af_inet.c                                 |   22 +-
 net/ipv4/ip_output.c                               |   13 +-
 net/ipv4/ip_tunnel.c                               |    2 +-
 net/ipv4/tcp_bpf.c                                 |   11 +-
 net/ipv6/af_inet6.c                                |   22 +-
 net/ipv6/icmp.c                                    |    8 +-
 net/ipv6/ila/ila_lwt.c                             |    4 +-
 net/ipv6/ip6_output.c                              |   31 +-
 net/ipv6/ip6mr.c                                   |    2 +-
 net/ipv6/ndisc.c                                   |    2 +-
 net/ipv6/ping.c                                    |    2 +-
 net/ipv6/raw.c                                     |    4 +-
 net/ipv6/route.c                                   |   34 +-
 net/ipv6/tcp_ipv6.c                                |    4 +-
 net/ipv6/udp.c                                     |   11 +-
 net/ipv6/xfrm6_policy.c                            |    2 +-
 net/l2tp/l2tp_ip6.c                                |    2 +-
 net/mpls/mpls_iptunnel.c                           |    2 +-
 net/netfilter/ipset/ip_set_core.c                  |    5 +
 net/netfilter/ipvs/ip_vs_proto.c                   |    4 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   14 +-
 net/netfilter/nf_flow_table_core.c                 |    8 +-
 net/netfilter/nf_flow_table_ip.c                   |    4 +-
 net/netfilter/nft_inner.c                          |   59 +-
 net/netfilter/nft_rt.c                             |    2 +-
 net/netfilter/nft_set_hash.c                       |   16 +
 net/netfilter/nft_socket.c                         |    2 +-
 net/netfilter/xt_LED.c                             |    4 +-
 net/packet/af_packet.c                             |   12 +-
 net/sched/cls_flower.c                             |    5 +-
 net/sched/sch_cbs.c                                |    2 +-
 net/sched/sch_tbf.c                                |   18 +-
 net/sctp/ipv6.c                                    |    2 +-
 net/smc/af_smc.c                                   |  226 +-
 net/smc/smc.h                                      |    8 +-
 net/smc/smc_clc.c                                  |  297 +-
 net/smc/smc_clc.h                                  |   50 +-
 net/smc/smc_core.c                                 |   98 +-
 net/smc/smc_core.h                                 |   18 +-
 net/smc/smc_diag.c                                 |    7 +-
 net/smc/smc_ism.c                                  |   66 +-
 net/smc/smc_ism.h                                  |   27 +-
 net/smc/smc_pnet.c                                 |    4 +-
 net/tipc/udp_media.c                               |    2 +-
 net/vmw_vsock/af_vsock.c                           |   70 +-
 net/xdp/xsk_buff_pool.c                            |    5 +-
 net/xdp/xskmap.c                                   |    2 +-
 net/xfrm/xfrm_policy.c                             |    3 +-
 samples/bpf/test_cgrp2_sock.c                      |    4 +-
 scripts/mod/modpost.c                              |    2 +-
 scripts/setlocalversion                            |   54 +-
 sound/core/seq/seq_ump_client.c                    |  110 +-
 sound/core/ump.c                                   |   75 +-
 sound/pci/hda/hda_auto_parser.c                    |   61 +-
 sound/pci/hda/hda_local.h                          |   28 +-
 sound/pci/hda/patch_analog.c                       |    6 +-
 sound/pci/hda/patch_cirrus.c                       |    8 +-
 sound/pci/hda/patch_conexant.c                     |   36 +-
 sound/pci/hda/patch_cs8409-tables.c                |    2 +-
 sound/pci/hda/patch_cs8409.h                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |   22 +-
 sound/pci/hda/patch_sigmatel.c                     |   22 +-
 sound/pci/hda/patch_via.c                          |    2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   14 +
 sound/soc/codecs/hdmi-codec.c                      |  144 +-
 sound/soc/intel/avs/pcm.c                          |    2 +-
 sound/soc/mediatek/mt8188/mt8188-mt6359.c          |    4 +-
 sound/soc/sof/ipc3-topology.c                      |   31 +-
 sound/usb/endpoint.c                               |   14 +-
 sound/usb/midi2.c                                  |    2 +
 sound/usb/mixer.c                                  |   58 +-
 sound/usb/mixer_maps.c                             |   10 +
 sound/usb/quirks.c                                 |   31 +-
 sound/usb/usbaudio.h                               |    4 +
 tools/bpf/bpftool/prog.c                           |   17 +-
 tools/scripts/Makefile.arch                        |    4 +-
 tools/testing/selftests/arm64/fp/fp-stress.c       |   15 +-
 tools/testing/selftests/arm64/pauth/pac.c          |    3 +
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |    2 +-
 tools/testing/selftests/hid/run-hid-tools-tests.sh |   16 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |    4 +-
 tools/testing/selftests/resctrl/resctrlfs.c        |    2 +-
 tools/tracing/rtla/src/timerlat_top.c              |    8 +-
 tools/tracing/rtla/src/utils.c                     |    4 +-
 tools/tracing/rtla/src/utils.h                     |    2 +
 tools/verification/dot2/automata.py                |   18 +-
 384 files changed, 8910 insertions(+), 6170 deletions(-)


