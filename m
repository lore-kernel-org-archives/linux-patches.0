Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E560225A2C;
	Thu, 12 Dec 2024 15:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018792; cv=none; b=PmqGR4L96Gry+QpxTT3kQp47LJiwiHTLwUU1UiqIYPK5pg9Qj5Be12KYO4a46/+SG5V1IhJpHzKRlxyrEIEXosvjkBPooNLE86U/IfI7e805QCtSOlOkSwcttZuC3OwG9LrWn1BMSuPLERF1FFJcunSWbNt8bZJxEGeK6oYXoV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018792; c=relaxed/simple;
	bh=bd2kyyrcbMXk6PbbfpIxYpbbaHDu6OUYRqs5r0cAcEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HeMIO3A9uMcEgKoOjjsZD4JkPpqT/2xY25gdm15NPyvEAzKlorxCFZuYD1DZyq4qSDyb4X+IZ75Qjj9mtQgUAqoDhzZqL48NdjpPhEoIHkFVtAVC+IEgyDcy4vSkj1HTtEmqTI4C1LskLrFSRwbhuWx3wfDqiG2aglMNQYZ64NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1i6WSMcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i6WSMcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE301C4CECE;
	Thu, 12 Dec 2024 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018792;
	bh=bd2kyyrcbMXk6PbbfpIxYpbbaHDu6OUYRqs5r0cAcEI=;
	h=From:To:Cc:Subject:Date:From;
	b=1i6WSMcFQZlGpmuVlj+gPcnSbwQhQIw7WcXhC1uHp8oke/mBh3DgpHUnQOnObTCCw
	 vn9FgmTMCoSUivwEaXCYFS/qFUl2ZvrpBJbuHXVzgXD9AX1OiizOQUsGUOZIZhsQwd
	 GgGHStDkj8eb0NVEjCLtCSAHUgk3pnZh+YeZVpOk=
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
Subject: [PATCH 6.1 000/772] 6.1.120-rc1 review
Date: Thu, 12 Dec 2024 15:49:05 +0100
Message-ID: <20241212144349.797589255@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.120-rc1
X-KernelTest-Deadline: 2024-12-14T14:44+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.120 release.
There are 772 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.120-rc1

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible deadlocks

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    i3c: master: svc: Fix use after free vulnerability in svc_i3c_master Driver Due to Race Condition

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Sequential field availability check in mi_enum_attr()

Randy Dunlap <rdunlap@infradead.org>
    drm/msm: DEVFREQ_GOV_SIMPLE_ONDEMAND is no longer needed

Rob Clark <robdclark@chromium.org>
    PM / devfreq: Fix build issues with devfreq disabled

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: fix possible assignment of the same address to two devices

Frank Li <Frank.Li@nxp.com>
    i3c: master: Remove i3c_dev_disable_ibi_locked(olddev) on device hotjoin

Arnd Bergmann <arnd@arndb.de>
    serial: amba-pl011: fix build regression

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Don't reset resource alloc flag

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: rework resume handling for display (v2)

Zack Rusin <zack.rusin@broadcom.com>
    drm/ttm: Print the memory decryption status just once

Zack Rusin <zack.rusin@broadcom.com>
    drm/ttm: Make sure the mapped tt pages are decrypted when needed

Peilin Ye <peilin.ye@bytedance.com>
    veth: Use tstats per-CPU traffic counters

Peilin Ye <peilin.ye@bytedance.com>
    bpf: Fix dev's rx stats for bpf_redirect_peer traffic

Daniel Borkmann <daniel@iogearbox.net>
    net: Move {l,t,d}stats allocation to core and convert veth & vrf

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix helper writes to read-only maps

Shu Han <ebpqwerty472123@gmail.com>
    mm: call the security_mmap_file() LSM hook in remap_file_pages()

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Fix return status of avs_pcm_hw_constraints_init()

Mark Rutland <mark.rutland@arm.com>
    arm64: smccc: Remove broken support for SMCCCv1.3 SVE discard hint

Mark Brown <broonie@kernel.org>
    arm64/sve: Discard stale CPU state when handling SVE traps

Ziwei Xiao <ziweixiao@google.com>
    gve: Fixes for napi_poll when budget is 0

Zhang Zekun <zhangzekun11@huawei.com>
    Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"

Heming Zhao <heming.zhao@suse.com>
    ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check BIOS images before it is used

Andy-ld Lu <andy-ld.lu@mediatek.com>
    mmc: mtk-sd: Fix error handle of probe function

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix STALL transfer event handling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: wake up optimisations

Zheng Yejian <zhengyejian@huaweicloud.com>
    mm/damon/vaddr: fix issue in damon_va_evenly_split_region()

Richard Weinberger <richard@nod.at>
    jffs2: Fix rtime decompressor

Kinsey Moore <kinsey.moore@oarcorp.com>
    jffs2: Prevent rtime decompress memory corruption

Nikolay Kuratov <kniv@yandex-team.ru>
    KVM: x86/mmu: Ensure that kvm_release_pfn_clean() takes exact pfn from kvm_faultin_pfn()

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

Kunkun Jiang <jiangkunkun@huawei.com>
    KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device

Jing Zhang <jingzhangos@google.com>
    KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*

Jan Kara <jack@suse.cz>
    udf: Fold udf_getblk() into udf_bread()

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Align the page tracking max message size with the device capability

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

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Remove the unnecessary need_resched() check in nohz_csd_func()

Jared Kangas <jkangas@redhat.com>
    kasan: make report_lock a raw spinlock

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: suppress recursive reports for HW_TAGS

Jens Axboe <axboe@kernel.dk>
    io_uring/tctx: work around xa_store() allocation error issue

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

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: light: ltr501: Add LTER0303 to the supported devices

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: handle USB Error Interrupt if IOC not set

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix sleeping in atomic context for PREEMPT_RT

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

Gabriele Monaco <gmonaco@redhat.com>
    verification/dot2: Improve dot parser robustness

Kees Cook <kees@kernel.org>
    smb: client: memcpy() with surrounding object base address

Yi Yang <yiyang13@huawei.com>
    nvdimm: rectify the illogical code within nd_dax_probe()

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

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Make DMA mask configuration more flexible

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add cond_resched() for no forced preemption model

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

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not checking skb length on hci_acldata_packet

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e123 to device tables

Andrew Lunn <andrew@lunn.ch>
    dsa: qca8k: Use nested lock to avoid splat

Norbert van Bolhuis <nvbolhuis@gmail.com>
    wifi: brcmfmac: Fix oops due to NULL pointer dereference in brcmf_sdiod_sglist_rw()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    wifi: ipw2x00: libipw_rx_any(): fix bad alignment

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: set the right AMDGPU sg segment limitation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Make mic volume workarounds globally applicable

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

Philipp Stanner <pstanner@redhat.com>
    drm/sched: memset() 'job' in drm_sched_job_init()

Shengyu Qu <wiagn233@outlook.com>
    net: sfp: change quirks for Alcatel Lucent G-010S-P

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

Brahmajit Das <brahmajit.xyz@gmail.com>
    drm/display: Fix building with GCC 15

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()

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

Marek Vasut <marex@denx.de>
    soc: imx8m: Probe the SoC driver as platform driver

Keita Aihara <keita.aihara@sony.com>
    mmc: core: Add SD card quirk for broken poweroff notification

Rohan Barar <rohan.barar@gmail.com>
    media: cx231xx: Add support for Dexatek USB Video Grabber 1d19:6108

David Given <dg@cowlark.com>
    media: uvcvideo: Add a quirk for the Kaiweets KTI-W02 infrared camera

Breno Leitao <leitao@debian.org>
    perf/x86/amd: Warn only on new bits set

Marco Elver <elver@google.com>
    kcsan: Turn report_filterlist_lock into a raw_spinlock

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Don't leak pipe fds in pac.exec_sign_all()

Boris Burkov <boris@bur.io>
    btrfs: do not clear read-only when adding sprout device

Qu Wenruo <wqu@suse.com>
    btrfs: avoid unnecessary device path update for the same device

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Handle CPU hotplug remove during sampling

Christian Brauner <brauner@kernel.org>
    epoll: annotate racy check

Pratyush Brahma <quic_pbrahma@quicinc.com>
    iommu/arm-smmu: Defer probe of clients after smmu device bound

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

Liequan Che <cheliequan@inspur.com>
    bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again

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

John Garry <john.g.garry@oracle.com>
    scsi: scsi_debug: Fix hrtimer support for ndelay

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mpc52xx: Add cancel_work_sync before module remove

Björn Töpel <bjorn@rivosinc.com>
    tools: Override makefile ARCH variable if defined, but empty

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Notify xrun for low-latency mode

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Fix the sk_mem_uncharge logic in tcp_bpf_sendmsg

Pei Xiao <xiaopei01@kylinos.cn>
    drm/sti: Add __iomem for mixer_dbg_mxn's parameter

Amir Mohammadi <amirmohammadi1999.am@gmail.com>
    bpftool: fix potential NULL pointer dereferencing in prog_dump()

Quentin Monnet <quentin@isovalent.com>
    bpftool: Remove asserts from JIT disassembler

Larysa Zaremba <larysa.zaremba@intel.com>
    xsk: always clear DMA mapping information when unmapping the pool

Chen-Yu Tsai <wenst@chromium.org>
    drm/bridge: it6505: Fix inverted reset polarity

Kuro Chung <kuro.chung@ite.com.tw>
    drm/bridge: it6505: update usleep_range for RC circuit charge time

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    device property: Introduce device_for_each_child_node_scoped()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    device property: Add cleanup.h based fwnode_handle_put() scope based cleanup.

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Constify device child node APIs

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Clear secondary (not primary) EPC in pci_epc_remove_epf()

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: Use a separate lock for protecting epc->pci_epf list

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

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    i3c: Make i3c_master_unregister() return void

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

Nathan Chancellor <nathan@kernel.org>
    powerpc/vdso: Include CLANG_FLAGS explicitly in ldflags-y

Nathan Chancellor <nathan@kernel.org>
    powerpc/vdso: Remove an unsupported flag from vgettimeofday-32.o with clang

Nathan Chancellor <nathan@kernel.org>
    powerpc/vdso: Improve linker flags

Nathan Chancellor <nathan@kernel.org>
    powerpc/vdso: Remove unused '-s' flag from ASFLAGS

Sathvika Vasireddy <sv@linux.ibm.com>
    powerpc/vdso: Skip objtool from running on VDSO files

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Don't clear ep0 DWC3_EP_TRANSFER_STARTED

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: ep0: Don't reset resource alloc flag (including ep0)

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Rewrite endpoint allocation flow

Kartik Rajput <kkartik@nvidia.com>
    serial: amba-pl011: Fix RX stall when DMA is used

Thomas Gleixner <tglx@linutronix.de>
    serial: amba-pl011: Use port lock wrappers

Charles Han <hanchunchao@inspur.com>
    gpio: grgpio: Add NULL check in grgpio_probe

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: grgpio: use a helper variable to store the address of ofdev->dev

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Don't retire aborted MMIO instruction

Fuad Tabba <tabba@google.com>
    KVM: arm64: Change kvm_handle_mmio_return() return polarity

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Remove workaround to avoid syndrome for internal port

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

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: downgrade logging of unsupported VF API version to debug

Jacob Keller <jacob.e.keller@intel.com>
    ixgbevf: stop attempting IPSEC offload on Mailbox API 1.5

Louis Leseur <louis.leseur@gmail.com>
    net/qed: allow old cards not supporting "num_images" to work

Wen Gu <guwen@linux.alibaba.com>
    net/smc: fix LGR and link use-after-free issue

Kuniyuki Iwashima <kuniyu@amazon.com>
    tipc: Fix use-after-free of kernel socket in cleanup_bearer().

Ivan Solodovnikov <solodovnikov.ia@phystech.edu>
    dccp: Fix memory leak in dccp_feat_change_recv

Jiri Wiesner <jwiesner@suse.de>
    net/ipv6: release expired exception dst cached in socket

Vadim Fedorenko <vadfed@meta.com>
    net-timestamp: make sk_tskey more predictable in error path

Dmitry Antipov <dmantipov@yandex.ru>
    can: j1939: j1939_session_new(): fix skb reference counting

Eric Dumazet <edumazet@google.com>
    net: hsr: avoid potential out-of-bound access in fill_frame_info()

Martin Ottens <martin.ottens@fau.de>
    net/sched: tbf: correct backlog statistic for GSO packets

Ajay Kaher <ajay.kaher@broadcom.com>
    ptp: Add error handling for adjfine callback in ptp_clock_adjtime

Jacob Keller <jacob.e.keller@intel.com>
    ptp: convert remaining drivers to adjfine interface

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level

Dmitry Antipov <dmantipov@yandex.ru>
    netfilter: x_tables: fix LED ID check in led_tg_check()

Jinghao Jia <jinghao7@illinois.edu>
    ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()

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

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: uniformly use "parent" as variable name for struct gs_usb

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_probe(): align block comment

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: remove leading space from goto labels

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()

Nick Chan <towinchenmi@gmail.com>
    watchdog: apple: Actually flush writes after requesting watchdog restart

Oleksandr Ocheretnyi <oocheret@cisco.com>
    iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call

Umio Yasuno <coelacanth_dream@protonmail.com>
    drm/amd/pm: update current_socclk and current_uclk in gpu_metrics on smu v13.0.7

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

Nathan Chancellor <nathan@kernel.org>
    powerpc: Adjust adding stack protector flags to KBUILD_CLAGS for clang

Nathan Chancellor <nathan@kernel.org>
    powerpc: Fix stack protector Kconfig test for clang

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad7923: Fix buffer overflow for tx_buf and ring_xfer

Zicheng Qu <quzicheng@huawei.com>
    iio: Fix fwnode_handle in __fwnode_iio_channel_get_by_name()

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

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int3400: Fix reading of current_uuid for active policy

Jiri Olsa <jolsa@kernel.org>
    fs/proc/kcore.c: Clear ret value in read_kcore_iter after successful iov_iter_zero

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Add link up check to ks_pcie_other_map_bus()

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Set mode as Root Complex for "ti,keystone-pcie" compatible

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()

Jinjie Ruan <ruanjinjie@huawei.com>
    i3c: master: svc: Fix pm_runtime_set_suspended() with runtime pm enabled

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Fix hibern8 notify callbacks

Alexandru Ardelean <aardelean@baylibre.com>
    util_macros.h: fix/rework find_closest() macros

Patrick Donnelly <pdonnell@redhat.com>
    ceph: extract entity name from device id

Linus Walleij <linus.walleij@linaro.org>
    ARM: 9431/1: mm: Pair atomic_set_release() with _read_acquire()

Linus Walleij <linus.walleij@linaro.org>
    ARM: 9430/1: entry: Do a dummy read from VMAP shadow

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: Mark IRQ entries to fix stack depot warnings

Linus Walleij <linus.walleij@linaro.org>
    ARM: 9429/1: ioremap: Sync PGDs for VMALLOC shadow

Zicheng Qu <quzicheng@huawei.com>
    ad7780: fix division by zero in ad7780_write_raw()

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

Wei Yang <richard.weiyang@gmail.com>
    maple_tree: refine mas_store_root() on storing NULL

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

Jinjie Ruan <ruanjinjie@huawei.com>
    media: amphion: Fix pm_runtime_set_suspended() with runtime pm enabled

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    media: platform: exynos4-is: Fix an OF node reference leak in fimc_md_is_isp_available

Li Zetao <lizetao1@huawei.com>
    media: ts2020: fix null-ptr-deref in ts2020_probe()

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Ensure power suppliers be suspended before detach them

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: i2c: tc358743: Fix crash in the probe error path when using polling

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mp-verdin: Fix SD regulator startup delay

Jinjie Ruan <ruanjinjie@huawei.com>
    media: i2c: dw9768: Fix pm_runtime_set_suspended() with runtime pm enabled

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Set video drvdata before register video device

Ming Qian <ming.qian@nxp.com>
    media: amphion: Set video drvdata before register video device

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: Fix SD regulator startup delay

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer

Filipe Manana <fdmanana@suse.com>
    btrfs: ref-verify: fix use-after-free after invalid ref action

Lizhi Xu <lizhi.xu@windriver.com>
    btrfs: add a sanity check for btrfs root in btrfs_search_slot()

ChenXiaoSong <chenxiaosong2@huawei.com>
    btrfs: add might_sleep() annotations

Filipe Manana <fdmanana@suse.com>
    btrfs: don't loop for nowait writes when checking for cross references

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    quota: flush quota_release_work upon quota writeback

Long Li <leo.lilong@huawei.com>
    xfs: remove unknown compat feature check in superblock write validation

Dan Carpenter <dan.carpenter@linaro.org>
    sh: intc: Fix use-after-free bug in register_intc_controller()

Liu Jian <liujian56@huawei.com>
    sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when mounting nfs

Masahiro Yamada <masahiroy@kernel.org>
    modpost: remove incorrect code in do_eisa_entry()

Maxime Chevallier <maxime.chevallier@bootlin.com>
    rtc: ab-eoz9: don't fail temperature reads on undervoltage notification

Namhyung Kim <namhyung@kernel.org>
    perf/arm-cmn: Ensure port and device id bits are set properly

Chun-Tse Shao <ctshao@google.com>
    perf/arm-smmuv3: Fix lockdep assert in ->event_init()

Alex Zenla <alex@edera.dev>
    9p/xen: fix release of IRQ

Alex Zenla <alex@edera.dev>
    9p/xen: fix init sequence

Christoph Hellwig <hch@lst.de>
    block: return unsigned int from bdev_io_min

Wolfram Sang <wsa+renesas@sang-engineering.com>
    rtc: rzn1: fix BCD to rtc_time conversion errors

Qingfang Deng <qingfang.deng@siflower.com.cn>
    jffs2: fix use of uninitialized variable

Waqar Hameed <waqar.hameed@axis.com>
    ubifs: authentication: Fix use-after-free in ubifs_tnc_end_commit

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix duplicate slab cache names while attaching

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Correct the total block count by deducting journal reservation

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: wl: Schedule fm_work if wear-leveling pool is empty

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

Yang Erkun <yangerkun@huawei.com>
    SUNRPC: make sure cache entry active before cache_show

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent a potential integer overflow

Ma Wupeng <mawupeng1@huawei.com>
    ipc: fix memleak if msg_init_ns failed in create_ipc_ns

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    lib: string_helpers: silence snprintf() output truncation warning

Ming Lei <ming.lei@redhat.com>
    ublk: fix error code for unsupported command

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix looping of queued SG entries

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix checking for number of TRBs left

Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
    usb: musb: Fix hardware lockup on first Rx endpoint request

Steve French <stfrench@microsoft.com>
    smb3: request handle caching when caching directories

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

Muchun Song <muchun.song@linux.dev>
    block: fix ordering between checking BLK_MQ_S_STOPPED request adding

Will Deacon <will@kernel.org>
    arm64: tls: Fix context-switching of tpidrro_el0 when kpti is enabled

Ming Lei <ming.lei@redhat.com>
    ublk: fix ublk_ch_mmap() for 64K page size

Huacai Chen <chenhuacai@kernel.org>
    sh: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Do not use drvdata in release

Bin Liu <b-liu@ti.com>
    serial: 8250: omap: Move pm_runtime_get_sync

Filip Brozovic <fbrozovic@gmail.com>
    serial: 8250_fintek: Add support for F81216E

Michal Simek <michal.simek@amd.com>
    dt-bindings: serial: rs485: Fix rs485-rts-delay property

Tiwei Bie <tiwei.btw@antgroup.com>
    um: net: Do not use drvdata in release

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Do not use drvdata in release

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: wl: Put source PEB into correct list if trying locking LEB failed

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    platform/chrome: cros_ec_typec: fix missing fwnode reference decrement

Josh Poimboeuf <jpoimboe@kernel.org>
    parisc/ftrace: Fix function graph tracing disablement

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

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    wifi: brcmfmac: release 'root' node in all execution paths

Guilherme G. Piccoli <gpiccoli@igalia.com>
    wifi: rtlwifi: Drastically reduce the attempts to read efuse in case of failures

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Fix double free in driver API bus_register()

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix TD invalidation under pending Set TR Dequeue

Andrej Shadura <andrew.shadura@collabora.co.uk>
    Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix uninit-value in __exfat_get_dentry_set

Angelo Dureghello <adureghello@baylibre.com>
    dt-bindings: iio: dac: ad3552r: fix maximum spi speed

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: qcom: spmi: fix debugfs drive strength

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

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries: Fix KVM guest detection for disabling hardlockup detector

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf SPTE

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - access 32-bit arguments as 32-bit

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix buffer full but size is 0 case

Qiu-ji Chen <chenqiuji666@gmail.com>
    ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()

Ilya Zverev <ilya@zverev.info>
    ASoC: amd: yc: Add a quirk for microfone on Lenovo ThinkPad P14s Gen 5 21MES00B00

Artem Sadovnikov <ancowi69@gmail.com>
    jfs: xattr: check invalid xattr size more strictly

Theodore Ts'o <tytso@mit.edu>
    ext4: fix FS_IOC_GETFSMAP handling

Jeongjun Park <aha310510@gmail.com>
    ext4: supress data-race warnings in ext4_free_inodes_{count,set}()

Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
    soc: qcom: socinfo: fix revision check in qcom_socinfo_probe()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: sst: Fix used of uninitialized ctx to log an error

Catalin Marinas <catalin.marinas@arm.com>
    dma: allow dma_get_cache_alignment() to be overridden by the arch code

Catalin Marinas <catalin.marinas@arm.com>
    mm/slab: decouple ARCH_KMALLOC_MINALIGN from ARCH_DMA_MINALIGN

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled

Chen-Yu Tsai <wenst@chromium.org>
    Revert "arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled"

Benoît Sevens <bsevens@google.com>
    ALSA: usb-audio: Fix potential out-of-bound accesses for Extigy and Mbox devices

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_acl_tcam: Fix NULL pointer dereference in error path

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Hide Topdown metrics events if the feature is not enumerated

Boris Burkov <boris@bur.io>
    btrfs: qgroup: fix qgroup prealloc rsv leak in subvolume operations

Zqiang <qiang.zhang1211@gmail.com>
    rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check phantom_stream before it is used

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for function pointer in dcn20_set_output_transfer_func

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for clk_mgr in dcn32_init_hw

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for clk_mgr and clk_mgr->funcs in dcn30_init_hw

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: avoid NULL pointer dereference

Jammy Huang <jammy_huang@aspeedtech.com>
    media: aspeed: Fix memory overwrite if timing is 1600x900

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-spear: fix call balance of sehci clk handling routines

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix out of bounds reads when finding clock sources

Qiu-ji Chen <chenqiuji666@gmail.com>
    xen: Fix the issue of resource not being properly released in xenbus_dev_probe()

lei lu <llfamsec@gmail.com>
    xfs: add bounds checking to xlog_recover_process_data

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Validate hdwq pointers before dereferencing in reset/errata paths

lei lu <llfamsec@gmail.com>
    ntfs3: Add bounds checking to mi_enum_attr()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fixed overflow check in mi_enum_attr()

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Move devm_mbox_controller_register() after devm_pm_runtime_enable()

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: yc: Fix for enabling DMIC on acp6x via _DSD entry

chao liu <liuzgyid@outlook.com>
    apparmor: fix 'Do simple duplicate message elimination'

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update ALC256 depop procedure

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    counter: ti-ecap-capture: Add check for clk_enable()

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

Paolo Abeni <pabeni@redhat.com>
    ipmr: fix tables suspicious RCU usage

Paolo Abeni <pabeni@redhat.com>
    ip6mr: fix tables suspicious RCU usage

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix use-after-free of nreq in reqsk_timer_handler().

Michal Luczaj <mhal@rbox.co>
    rxrpc: Improve setsockopt() handling of malformed user input

Michal Luczaj <mhal@rbox.co>
    llc: Improve setsockopt() handling of malformed user input

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Add crypto_clone_tfm

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Add crypto_tfm_get

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix slab-use-after-free Read in set_powered_sync

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

Hangbin Liu <liuhangbin@gmail.com>
    net/ipv6: delete temporary address if mngtmpaddr is removed or unmanaged

Sidraya Jayagond <sidraya@linux.ibm.com>
    s390/iucv: MSG_PEEK causes memory leak in iucv_sock_destruct()

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration

Pavan Chebbi <pavan.chebbi@broadcom.com>
    tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix memory leak on device unplug by freeing PHY device

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: Fix double free issue with interrupt buffer allocation

Barnabás Czémán <barnabas.czeman@mainlining.org>
    power: supply: bq27xxx: Fix registers of bq27426

Bart Van Assche <bvanassche@acm.org>
    power: supply: core: Remove might_sleep() from power_supply_put()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Sign-extend return values

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix build failure with GCC 15 (-std=gnu23)

WANG Xuerui <git@xen0n.name>
    LoongArch: Tweak CFLAGS for Clang compatibility

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

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    remoteproc: qcom: pas: add minidump_id to SM8350 resources

Abel Vesa <abel.vesa@linaro.org>
    remoteproc: qcom: q6v5: Use _clk_get_optional for aggre2_clk

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

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid forcing direct write to use buffered IO on inline_data inode

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to avoid use GC_AT when setting gc_mode as GC_URGENT_LOW or GC_URGENT_MID

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

Arnaldo Carvalho de Melo <acme@kernel.org>
    perf ftrace latency: Fix unit on histogram first entry when using --use-nsec

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: cpqphp: Fix PCIBIOS_* return value confusion

weiyufeng <weiyufeng@kylinos.cn>
    PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads

Leo Yan <leo.yan@arm.com>
    perf probe: Correct demangled symbols in C++ program

Ian Rogers <irogers@google.com>
    perf probe: Fix libdw memory leak

Chao Yu <chao@kernel.org>
    f2fs: fix to account dirty data in __get_secs_required()

Qi Han <hanqi@vivo.com>
    f2fs: compress: fix inconsistent update of i_blocks in release_compress_blocks and reserve_compress_blocks

Ian Rogers <irogers@google.com>
    perf stat: Fix affinity memory leaks on error path

Levi Yun <yeoreum.yun@arm.com>
    perf stat: Close cork_fd when create_perf_stat_counter() failed

Todd Kjos <tkjos@google.com>
    PCI: Fix reset_method_store() memory leak

James Clark <james.clark@linaro.org>
    perf cs-etm: Don't flush when packet_queue fills up

Dan Carpenter <dan.carpenter@linaro.org>
    mailbox: arm_mhuv2: clean up loop in get_irq_chan_comb()

Paul Aurich <paul@darkrain42.org>
    smb: cached directories can be more than root file handle

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    pinctrl: k210: Undef K210_PC_DEFAULT

Nuno Sa <nuno.sa@analog.com>
    clk: clk-axi-clkgen: make sure to enable the AXI bus clock

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: clock: axi-clkgen: include AXI clk

Charles Han <hanchunchao@inspur.com>
    clk: clk-apple-nco: Add NULL check in applnco_probe

Zhen Lei <thunder.leizhen@huawei.com>
    fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev/sh7760fb: Alloc DMA memory from hardware device

Zhang Zekun <zhangzekun11@huawei.com>
    powerpc/kexec: Fix return of uninitialized variable

Michal Suchanek <msuchanek@suse.de>
    powerpc/sstep: make emulate_vsx_load and emulate_vsx_store static

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV: Avoid returning to nested hypervisor on pending doorbells

Gautam Menghani <gautam@linux.ibm.com>
    KVM: PPC: Book3S HV: Stop using vc->dpdes for nested KVM guests

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    dax: delete a stale directory pmem

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: fix uninitialized value in ocfs2_file_read_iter()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_power()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_cost()

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

Mirsad Todorovac <mtodorovac69@gmail.com>
    fs/proc/kcore.c: fix coccinelle reported ERROR instances

Zhang Changzhong <zhangchangzhong@huawei.com>
    mfd: rt5033: Fix missing regmap_del_irq_chip()

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix checks and print in pgtable_walk()

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix checks and print in dmar_fault_dump_ptes()

Dong Aisheng <aisheng.dong@nxp.com>
    clk: imx: clk-scu: fix clk enable state save and restore

Peng Fan <peng.fan@nxp.com>
    clk: imx: fracn-gppll: fix pll power up

Peng Fan <peng.fan@nxp.com>
    clk: imx: fracn-gppll: correct PLL initialization flow

Peng Fan <peng.fan@nxp.com>
    clk: imx: lpcg-scu: SW workaround for errata (e10858)

Biju Das <biju.das.jz@bp.renesas.com>
    clk: renesas: rzg2l: Fix FOUTPOSTDIV clk

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: d1: Fix PLL_AUDIO0 preset

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Check cqe flags to know imm_data vs inv_irkey

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix cpu stuck caused by printings during reset

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Remove unnecessary QP type checks

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Use dev_* printings in hem code instead of ibdev_*

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Add clear_hem return value to log

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix an AEQE overflow error caused by untimely update of eq_db_ci

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()

Jinjie Ruan <ruanjinjie@huawei.com>
    cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Fix dtl_access_lock to be a rw_semaphore

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/mm/fault: Fix kfence page fault reporting

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: atmel: Fix possible memory leak

Biju Das <biju.das.jz@bp.renesas.com>
    mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: hyperbus: rpc-if: Convert to platform remove callback returning void

Geert Uytterhoeven <geert+renesas@glider.be>
    memory: renesas-rpc-if: Remove Runtime PM wrappers

Geert Uytterhoeven <geert+renesas@glider.be>
    memory: renesas-rpc-if: Pass device instead of rpcif to rpcif_*()

Geert Uytterhoeven <geert+renesas@glider.be>
    memory: renesas-rpc-if: Improve Runtime PM handling

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/fadump: Move fadump_cma_init to setup_arch() after initmem_init()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/fadump: Refactor and prepare fadump_cma_init for late init

Yuan Can <yuancan@huawei.com>
    cpufreq: loongson2: Unregister platform_driver on failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for PMIC devices

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for TMU device

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device

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

André Almeida <andrealmeid@igalia.com>
    unicode: Fix utf8_load() error path

Jiayuan Chen <mrpre@163.com>
    bpf: fix recursive lock when verdict program return SK_PASS

Hangbin Liu <liuhangbin@gmail.com>
    wireguard: selftests: load nf_conntrack if not present

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in netpoll_poll_lock

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: fix use-after-free in device_for_each_child()

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

Paolo Abeni <pabeni@redhat.com>
    ipv6: release nexthop on device removal

Eric Dumazet <edumazet@google.com>
    net: use unrcu_pointer() helper

Eric Dumazet <edumazet@google.com>
    sock_diag: allow concurrent operation in sock_diag_rcv_msg()

Eric Dumazet <edumazet@google.com>
    sock_diag: allow concurrent operations

Eric Dumazet <edumazet@google.com>
    sock_diag: add module pointer to "struct sock_diag_handler"

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

Lukasz Luba <lukasz.luba@arm.com>
    drm/msm/gpu: Check the status of registration to PM QoS

Rob Clark <robdclark@chromium.org>
    drm/msm/gpu: Bypass PM QoS constraint for idle clamp

Rob Clark <robdclark@chromium.org>
    drm/msm/gpu: Add devfreq tuning debugfs

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()

Xu Kuohai <xukuohai@huawei.com>
    bpf, arm64: Remove garbage frame for struct_ops trampoline

Steven Price <steven.price@arm.com>
    drm/panfrost: Remove unused id_mask from struct panfrost_model

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dcbnl.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dmac_flt.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c

Dipendra Khadka <kdipendra88@gmail.com>
    octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_flows.c

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

Andrii Nakryiko <andrii@kernel.org>
    libbpf: never interpret subprogs in .text as entry programs

Andrii Nakryiko <andrii@kernel.org>
    libbpf: fix sym_is_subprog() logic for weak global subprogs

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: add missing header include for htons

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Fix backtrace printing for selftests crashes

Stanislav Fomichev <sdf@google.com>
    selftests/bpf: Add csum helpers

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

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Correct logic on stopping an HVS channel

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Remove incorrect limit from hvs_dlist debugfs function

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Fix dlist debug not resetting the next entry pointer

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid hang with debug registers when suspended

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Don't write gamma luts on 2711

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/mm: Mark drm_mm_interval_tree*() functions with __maybe_unused

Yao Zi <ziyao@disroot.org>
    platform/x86: panasonic-laptop: Return errno correctly in show callback

Li Huafei <lihuafei1@huawei.com>
    media: atomisp: Add check for rgby_data memory allocation failure

Sergey Senozhatsky <senozhatsky@chromium.org>
    media: venus: provide ctx queue lock for ioctl synchronization

Dikshita Agarwal <quic_dikshita@quicinc.com>
    venus: venc: add handling for VIDIOC_ENCODER_CMD

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
    arm64: dts: mt8183: cozmo: add i2c2's i2c-scl-internal-delay-ns

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

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mt8195: Fix dtbs_check error for infracfg_ao node

Michal Simek <michal.simek@amd.com>
    microblaze: Export xmb_manager functions

Gaosheng Cui <cuigaosheng1@huawei.com>
    drivers: soc: xilinx: add the missing kfree in xlnx_add_cb_for_suspend()

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()

Alexander Stein <alexander.stein@ew.tq-group.com>
    spi: spi-fsl-lpspi: downgrade log level for pio mode

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    clocksource/drivers/timer-ti-dm: Fix child node refcount handling

Mark Brown <broonie@kernel.org>
    clocksource/drivers:sp804: Make user selectable

Marco Elver <elver@google.com>
    kcsan, seqlock: Fix incorrect assumption in read_seqbegin()

Marco Elver <elver@google.com>
    kcsan, seqlock: Support seqcount_latch_t

Peter Zijlstra <peterz@infradead.org>
    seqlock/latch: Provide raw_read_seqcount_latch_retry()

Miguel Ojeda <ojeda@kernel.org>
    time: Fix references to _msecs_to_jiffies() handling of values

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/lib: Fix memory leak on error in thermal_genl_auto()

Daniel Lezcano <daniel.lezcano@linaro.org>
    tools/lib/thermal: Make more generic the command encoding function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Chen Ridong <chenridong@huawei.com>
    crypto: bcm - add error check in the ahash_hmac_init function

Chen Ridong <chenridong@huawei.com>
    crypto: caam - add error check to caam_rsa_set_priv_key_form

Lifeng Zheng <zhenglifeng1@huawei.com>
    ACPI: CPPC: Fix _CPC register setting issue

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (nct6775-core) Fix overflows seen when writing limit attributes

Baruch Siach <baruch@tkos.co.il>
    doc: rcu: update printed dynticks counter bits

Li Huafei <lihuafei1@huawei.com>
    crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()

Orange Kao <orange@aiven.io>
    EDAC/igen6: Avoid segmentation fault on module unload

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - disable same error report before resetting

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

Christoph Hellwig <hch@lst.de>
    virtio_blk: reverse request order in virtio_queue_rqs

Christoph Hellwig <hch@lst.de>
    nvme-pci: reverse request order in nvme_queue_rqs

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    hfsplus: don't query the device logical block size multiple times

Masahiro Yamada <masahiroy@kernel.org>
    s390/syscalls: Avoid creation of arch/arch/ directory

Christoph Hellwig <hch@lst.de>
    block: fix bio_split_rw_at to take zone_write_granularity into account

Zizhi Wo <wozizhi@huawei.com>
    netfs/fscache: Add a memory barrier for FSCACHE_VOLUME_CREATING

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix missing pos updates in cachefiles_ondemand_fd_write_iter()

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

Jan Kara <jack@suse.cz>
    ext4: avoid remount errors with 'abort' mount option

Jan Kara <jack@suse.cz>
    ext4: make 'abort' mount option handling standard

Yang Erkun <yangerkun@huawei.com>
    brd: defer automatic disk creation until module initialization succeeds

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Do not unregister the subchannel based on DNV

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: fix printf type warnings about longs

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: fix printf type warnings about __u64

Borislav Petkov (AMD) <bp@alien8.de>
    x86/barrier: Do not serialize MSR accesses on AMD

Li Zhijian <lizhijian@fujitsu.com>
    fs/inode: Prevent dump_mapping() accessing invalid dentry.d_name.name

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Initialize denominators' default to 1

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: avoid to add interface to list twice when SER

Dmitry Kandybka <d.kandybka@gmail.com>
    mptcp: fix possible integer overflow in mptcp_reset_tout_timer

Thomas Weißschuh <linux@weissschuh.net>
    fbdev: efifb: Register sysfs groups through driver core

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible crash on mgmt_index_removed

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Add helper functions to manipulate cmd_sync queue

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null-initialized variables

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL check for function pointer in dcn32_set_output_transfer_func

Marco Pagani <marpagan@redhat.com>
    fpga: manager: add owner module and take its refcount

Marco Pagani <marpagan@redhat.com>
    fpga: bridge: add owner module and take its refcount

Pali Rohár <pali@kernel.org>
    cifs: Fix buffer overflow when parsing NFS reparse points

Ard Biesheuvel <ardb@kernel.org>
    x86/stackprotector: Work around strict Clang TLS symbol requirements

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix invalid FIFO access with special register set

Wang Liang <wangliang74@huawei.com>
    net: fix crash when config small gso_max_size/gso_ipv4_max_size

Kent Overstreet <kent.overstreet@linux.dev>
    closures: Change BUG_ON() to WARN_ON()

Breno Leitao <leitao@debian.org>
    ipmr: Fix access to mfc_cache_list without lock held

Harith G <harith.g@alifsemi.com>
    ARM: 9420/1: smp: Fix SMP for xip kernels

Eryk Zagorski <erykzagorski@gmail.com>
    ALSA: usb-audio: Fix Yamaha P-125 Quirk Entry

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Define a default value for VM_DATA_DEFAULT_FLAGS

John Watts <contact@jookia.org>
    ASoC: audio-graph-card2: Purge absent supplies for device tree nodes

David Wang <00107082@163.com>
    proc/softirqs: replace seq_printf with seq_put_decimal_ull_width

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Make Lenovo Yoga Tab 3 X90F DMI match less strict

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()

Luo Yifan <luoyifan@cmss.chinamobile.com>
    ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()

Markus Petri <mp@mpetri.org>
    ASoC: amd: yc: Support dmic on another model of Lenovo Thinkpad E14 Gen 6

Vishnu Sankar <vishnuocv@gmail.com>
    platform/x86: thinkpad_acpi: Fix for ThinkPad's with ECFW showing incorrect fan speed

Alexander Hölzl <alexander.hoelzl@gmx.net>
    can: j1939: fix error in J1939 documentation.

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools/lib/thermal: Remove the thermal.h soft link when doing make clean

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

Jiayuan Chen <mrpre@163.com>
    bpf: fix filed access without lock

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


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-pci            |   11 +
 Documentation/ABI/testing/sysfs-fs-f2fs            |    7 +-
 Documentation/RCU/stallwarn.rst                    |    2 +-
 .../devicetree/bindings/clock/adi,axi-clkgen.yaml  |   22 +-
 .../devicetree/bindings/iio/dac/adi,ad3552r.yaml   |    2 +-
 .../devicetree/bindings/serial/rs485.yaml          |   19 +-
 .../devicetree/bindings/sound/mt6359.yaml          |   10 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 Documentation/driver-api/fpga/fpga-bridge.rst      |    7 +-
 Documentation/driver-api/fpga/fpga-mgr.rst         |   34 +-
 Documentation/filesystems/mount_api.rst            |    3 +-
 Documentation/locking/seqlock.rst                  |    2 +-
 Documentation/networking/j1939.rst                 |    2 +-
 Makefile                                           |    4 +-
 arch/arm/boot/dts/sun9i-a80-cubieboard4.dts        |    4 +-
 arch/arm/kernel/entry-armv.S                       |    8 +
 arch/arm/kernel/head.S                             |    4 +
 arch/arm/kernel/psci_smp.c                         |    7 +
 arch/arm/mm/idmap.c                                |    7 +
 arch/arm/mm/ioremap.c                              |   35 +-
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |    3 +
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |    2 +-
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi   |    2 +-
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi  |    8 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts   |    3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts    |    2 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |    3 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi  |    3 +
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |   56 +-
 .../boot/dts/mediatek/mt8183-kukui-kakadu.dtsi     |    4 +-
 .../boot/dts/mediatek/mt8183-kukui-kodama.dtsi     |    4 +-
 .../boot/dts/mediatek/mt8183-kukui-krane.dtsi      |    4 +-
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |    2 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |    2 +-
 arch/arm64/kernel/fpsimd.c                         |    1 +
 arch/arm64/kernel/process.c                        |    2 +-
 arch/arm64/kernel/ptrace.c                         |    6 +-
 arch/arm64/kernel/smccc-call.S                     |   35 +-
 arch/arm64/kernel/vmlinux.lds.S                    |    6 +-
 arch/arm64/kvm/arm.c                               |    2 +-
 arch/arm64/kvm/mmio.c                              |   36 +-
 arch/arm64/kvm/pmu-emul.c                          |    1 -
 arch/arm64/kvm/vgic/vgic-its.c                     |   32 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |    7 +-
 arch/arm64/kvm/vgic/vgic.h                         |   24 +
 arch/arm64/mm/context.c                            |    4 +-
 arch/arm64/net/bpf_jit_comp.c                      |   47 +-
 arch/loongarch/Makefile                            |   21 +-
 arch/loongarch/include/asm/hugetlb.h               |   10 +
 arch/loongarch/include/asm/page.h                  |    5 +-
 arch/loongarch/include/asm/percpu.h                |    6 +-
 arch/loongarch/mm/tlb.c                            |    2 +-
 arch/loongarch/net/bpf_jit.c                       |    2 +-
 arch/loongarch/vdso/Makefile                       |    2 +-
 arch/m68k/coldfire/device.c                        |    8 +-
 arch/m68k/include/asm/mcfgpio.h                    |    2 +-
 arch/m68k/include/asm/mvme147hw.h                  |    4 +-
 arch/m68k/kernel/early_printk.c                    |    9 +-
 arch/m68k/mvme147/config.c                         |   30 +
 arch/m68k/mvme147/mvme147.h                        |    6 +
 arch/m68k/mvme16x/config.c                         |    2 +
 arch/m68k/mvme16x/mvme16x.h                        |    6 +
 arch/microblaze/kernel/microblaze_ksyms.c          |   10 +
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          |   73 +-
 arch/mips/include/asm/switch_to.h                  |    2 +-
 arch/parisc/kernel/ftrace.c                        |    2 +-
 arch/powerpc/Kconfig                               |    4 +-
 arch/powerpc/Makefile                              |   13 +-
 arch/powerpc/include/asm/dtl.h                     |    4 +-
 arch/powerpc/include/asm/fadump.h                  |    7 +
 arch/powerpc/include/asm/sstep.h                   |    5 -
 arch/powerpc/include/asm/vdso.h                    |    1 +
 arch/powerpc/kernel/fadump.c                       |   23 +-
 arch/powerpc/kernel/prom_init.c                    |   29 +-
 arch/powerpc/kernel/setup-common.c                 |    6 +-
 arch/powerpc/kernel/setup_64.c                     |    1 +
 arch/powerpc/kernel/vdso/Makefile                  |   55 +-
 arch/powerpc/kexec/file_load_64.c                  |    9 +-
 arch/powerpc/kvm/book3s_hv.c                       |   10 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |   14 +-
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
 arch/x86/events/amd/core.c                         |   10 +-
 arch/x86/events/intel/core.c                       |   34 +-
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
 arch/x86/kvm/mmu/mmu.c                             |    5 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    5 +-
 arch/x86/kvm/mmu/spte.c                            |   18 +-
 arch/x86/pci/acpi.c                                |  119 +
 block/blk-merge.c                                  |   10 +-
 block/blk-mq.c                                     |    6 +
 block/blk-mq.h                                     |   13 +
 crypto/api.c                                       |   63 +-
 crypto/internal.h                                  |    8 +
 crypto/pcrypt.c                                    |   12 +-
 drivers/acpi/arm64/gtdt.c                          |    2 +-
 drivers/acpi/cppc_acpi.c                           |    1 -
 drivers/base/bus.c                                 |    2 +
 drivers/base/core.c                                |   69 +-
 drivers/base/property.c                            |    6 +-
 drivers/base/regmap/regmap-irq.c                   |    4 +
 drivers/base/regmap/regmap.c                       |   12 +
 drivers/block/brd.c                                |   66 +-
 drivers/block/ublk_drv.c                           |   17 +-
 drivers/block/virtio_blk.c                         |   46 +-
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/clk/clk-apple-nco.c                        |    3 +
 drivers/clk/clk-axi-clkgen.c                       |   22 +-
 drivers/clk/imx/clk-fracn-gppll.c                  |   10 +-
 drivers/clk/imx/clk-lpcg-scu.c                     |   37 +-
 drivers/clk/imx/clk-scu.c                          |    2 +-
 drivers/clk/qcom/gcc-qcs404.c                      |    1 +
 drivers/clk/renesas/rzg2l-cpg.c                    |   11 +-
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c               |    2 +-
 drivers/clocksource/Kconfig                        |    3 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |    4 +-
 drivers/comedi/comedi_fops.c                       |   12 +
 drivers/counter/stm32-timer-cnt.c                  |   16 +-
 drivers/counter/ti-ecap-capture.c                  |    7 +-
 drivers/cpufreq/cppc_cpufreq.c                     |    6 +
 drivers/cpufreq/loongson2_cpufreq.c                |    4 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |    2 +-
 drivers/crypto/bcm/cipher.c                        |    5 +-
 drivers/crypto/caam/caampkc.c                      |   11 +-
 drivers/crypto/caam/qi.c                           |    2 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |    6 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   35 +-
 drivers/crypto/hisilicon/qm.c                      |   47 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   35 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   35 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    2 +-
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |    4 -
 drivers/dax/pmem/Makefile                          |    7 -
 drivers/dax/pmem/pmem.c                            |   10 -
 drivers/dma-buf/dma-fence-array.c                  |   28 +-
 drivers/dma-buf/dma-fence-unwrap.c                 |  126 +-
 drivers/edac/bluefield_edac.c                      |    2 +-
 drivers/edac/fsl_ddr_edac.c                        |   22 +-
 drivers/edac/igen6_edac.c                          |    2 +
 drivers/firmware/arm_scpi.c                        |    3 +
 drivers/firmware/efi/tpm.c                         |   17 +-
 drivers/firmware/google/gsmi.c                     |    6 +-
 drivers/firmware/smccc/smccc.c                     |    4 -
 drivers/fpga/fpga-bridge.c                         |   57 +-
 drivers/fpga/fpga-mgr.c                            |   82 +-
 drivers/gpio/gpio-exar.c                           |   10 +-
 drivers/gpio/gpio-grgpio.c                         |   26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   48 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |    5 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c              |    6 +-
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c             |   27 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |    5 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |   14 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |    3 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |    7 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c |   11 +-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |    3 +
 .../display/dc/dml/dcn20/display_rq_dlg_calc_20.c  |    2 +-
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |    7 +-
 .../amd/display/dc/dml/dml1_display_rq_dlg_calc.c  |    2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |    2 +
 drivers/gpu/drm/bridge/analogix/anx7625.c          |    2 +
 drivers/gpu/drm/bridge/ite-it6505.c                |   11 +-
 drivers/gpu/drm/bridge/tc358767.c                  |    7 +
 drivers/gpu/drm/display/drm_dp_dual_mode_helper.c  |    4 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   55 +-
 drivers/gpu/drm/drm_mm.c                           |    2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   19 +-
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
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |    2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |    2 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |   12 +
 drivers/gpu/drm/msm/msm_drv.h                      |    9 +
 drivers/gpu/drm/msm/msm_gpu.h                      |   15 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |  148 +-
 drivers/gpu/drm/omapdrm/dss/base.c                 |   25 +-
 drivers/gpu/drm/omapdrm/dss/omapdss.h              |    3 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |    4 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   10 +-
 drivers/gpu/drm/panel/panel-simple.c               |   28 +
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |    1 -
 drivers/gpu/drm/radeon/r600_cs.c                   |    2 +-
 drivers/gpu/drm/scheduler/sched_main.c             |    8 +
 drivers/gpu/drm/sti/sti_cursor.c                   |    3 +
 drivers/gpu/drm/sti/sti_gdp.c                      |    3 +
 drivers/gpu/drm/sti/sti_hqvdp.c                    |    3 +
 drivers/gpu/drm/sti/sti_mixer.c                    |    2 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   13 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |   12 +
 drivers/gpu/drm/v3d/v3d_mmu.c                      |   29 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |    2 +-
 drivers/gpu/drm/vc4/vc4_drv.h                      |    1 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |    6 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   31 +-
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-magicmouse.c                       |   56 +-
 drivers/hid/wacom_sys.c                            |    3 +-
 drivers/hid/wacom_wac.c                            |    4 +-
 drivers/hwmon/nct6775-core.c                       |    7 +-
 drivers/hwmon/tps23861.c                           |    2 +-
 drivers/i3c/master.c                               |  201 +-
 drivers/i3c/master/dw-i3c-master.c                 |    5 +-
 drivers/i3c/master/i3c-master-cdns.c               |    5 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |    4 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |    2 +-
 drivers/i3c/master/svc-i3c-master.c                |  148 +-
 drivers/iio/adc/ad7780.c                           |    2 +-
 drivers/iio/adc/ad7923.c                           |    4 +-
 drivers/iio/inkern.c                               |    2 +-
 drivers/iio/light/al3010.c                         |   11 +-
 drivers/iio/light/ltr501.c                         |    2 +
 drivers/iio/magnetometer/yamaha-yas530.c           |   13 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    7 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |    2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |    4 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |    1 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   74 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  172 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |    6 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |   11 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   56 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |    4 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |   11 +
 drivers/iommu/intel/iommu.c                        |   40 +-
 drivers/iommu/io-pgtable-arm.c                     |   18 +-
 drivers/leds/flash/leds-mt6360.c                   |    3 +-
 drivers/leds/led-class.c                           |   14 +-
 drivers/leds/leds-lp55xx-common.c                  |    3 -
 drivers/mailbox/arm_mhuv2.c                        |    8 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   12 +-
 drivers/md/bcache/closure.c                        |   10 +-
 drivers/md/bcache/super.c                          |    2 +-
 drivers/md/dm-thin.c                               |    1 +
 drivers/media/dvb-frontends/ts2020.c               |    8 +-
 drivers/media/i2c/adv7604.c                        |    5 +-
 drivers/media/i2c/adv7842.c                        |   13 +-
 drivers/media/i2c/dw9768.c                         |   10 +-
 drivers/media/i2c/tc358743.c                       |    4 +-
 drivers/media/platform/allegro-dvt/allegro-core.c  |    4 +-
 drivers/media/platform/amphion/vpu_drv.c           |    2 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |    2 +-
 drivers/media/platform/aspeed/aspeed-video.c       |    4 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |    4 +-
 drivers/media/platform/qcom/venus/core.c           |    2 +-
 drivers/media/platform/qcom/venus/core.h           |   11 +
 drivers/media/platform/qcom/venus/vdec.c           |    4 +
 drivers/media/platform/qcom/venus/venc.c           |   72 +
 .../media/platform/samsung/exynos4-is/media-dev.h  |    5 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   15 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    2 +
 drivers/media/usb/gspca/ov534.c                    |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  113 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  132 +-
 drivers/memory/renesas-rpc-if.c                    |   42 +-
 drivers/message/fusion/mptsas.c                    |    4 +-
 drivers/mfd/da9052-spi.c                           |    2 +-
 drivers/mfd/intel_soc_pmic_bxtwc.c                 |  138 +-
 drivers/mfd/rt5033.c                               |    4 +-
 drivers/mfd/tps65010.c                             |    8 +-
 drivers/misc/apds990x.c                            |   12 +-
 drivers/misc/eeprom/eeprom_93cx6.c                 |   10 +
 drivers/mmc/core/bus.c                             |    2 +
 drivers/mmc/core/card.h                            |    7 +
 drivers/mmc/core/core.c                            |    3 +
 drivers/mmc/core/quirks.h                          |    9 +
 drivers/mmc/core/sd.c                              |    2 +-
 drivers/mmc/host/mmc_spi.c                         |    9 +-
 drivers/mmc/host/mtk-sd.c                          |    9 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   72 +
 drivers/mmc/host/sdhci-pci.h                       |    1 +
 drivers/mtd/hyperbus/rpc-if.c                      |   31 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |    8 +-
 drivers/mtd/nand/raw/atmel/pmecc.h                 |    2 -
 drivers/mtd/spi-nor/core.c                         |    2 +-
 drivers/mtd/ubi/attach.c                           |   12 +-
 drivers/mtd/ubi/fastmap-wl.c                       |   19 +-
 drivers/mtd/ubi/wl.c                               |   11 +-
 drivers/mtd/ubi/wl.h                               |    3 +-
 drivers/net/can/c_can/c_can_main.c                 |   26 +-
 drivers/net/can/dev/dev.c                          |    2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   58 +-
 drivers/net/can/m_can/m_can.c                      |   33 +-
 drivers/net/can/sja1000/sja1000.c                  |   65 +-
 drivers/net/can/spi/hi311x.c                       |   48 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   29 +-
 drivers/net/can/sun4i_can.c                        |   22 +-
 drivers/net/can/usb/ems_usb.c                      |   58 +-
 drivers/net/can/usb/gs_usb.c                       |  104 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/broadcom/tg3.c                |    3 +
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   11 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c     |   13 +-
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    2 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   13 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |    2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |    7 +
 drivers/net/ethernet/google/gve/gve_rx.c           |    4 -
 drivers/net/ethernet/google/gve/gve_tx.c           |    4 -
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h    |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |    1 -
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |    5 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    4 +
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |    5 +
 .../ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c |    9 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   10 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   10 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |   14 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   13 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |    1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |    5 +
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    |    4 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    4 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        |   13 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   14 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    2 +-
 drivers/net/ethernet/sfc/ptp.c                     |    7 +-
 drivers/net/ethernet/sfc/siena/ptp.c               |    7 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |    2 +
 drivers/net/ethernet/ti/am65-cpts.c                |    5 +-
 drivers/net/geneve.c                               |    2 +-
 drivers/net/mdio/mdio-ipq4019.c                    |    5 +-
 drivers/net/netdevsim/ipsec.c                      |   11 +-
 drivers/net/phy/sfp.c                              |    3 +-
 drivers/net/usb/lan78xx.c                          |   42 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/usb/r8152.c                            |    1 +
 drivers/net/veth.c                                 |   44 +-
 drivers/net/vrf.c                                  |   24 +-
 drivers/net/wireless/ath/ath10k/mac.c              |    4 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    3 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |    3 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    2 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   12 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |    4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    4 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   11 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    4 +-
 drivers/net/wireless/realtek/rtw89/util.h          |   18 +
 drivers/net/wireless/silabs/wfx/main.c             |   17 +-
 drivers/nvdimm/dax_devs.c                          |    4 +-
 drivers/nvdimm/nd.h                                |    7 +
 drivers/nvme/host/pci.c                            |   55 +-
 drivers/pci/controller/dwc/pci-keystone.c          |   12 +
 drivers/pci/controller/pcie-rockchip-ep.c          |   16 +-
 drivers/pci/controller/pcie-rockchip.h             |    4 +
 drivers/pci/endpoint/pci-epc-core.c                |   13 +-
 drivers/pci/hotplug/cpqphp_pci.c                   |   19 +-
 drivers/pci/pci-sysfs.c                            |   26 +
 drivers/pci/pci.c                                  |    7 +-
 drivers/pci/pci.h                                  |    1 +
 drivers/pci/probe.c                                |   30 +-
 drivers/pci/quirks.c                               |   15 +-
 drivers/pci/slot.c                                 |    4 +-
 drivers/perf/arm-cmn.c                             |    4 +-
 drivers/perf/arm_smmuv3_pmu.c                      |   19 +-
 drivers/pinctrl/freescale/Kconfig                  |    2 +-
 drivers/pinctrl/pinctrl-k210.c                     |    2 +-
 drivers/pinctrl/pinctrl-zynqmp.c                   |    1 -
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |    4 +-
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c            |    1 +
 drivers/platform/chrome/cros_ec_typec.c            |    1 +
 drivers/platform/x86/dell/dell-smbios-base.c       |    1 +
 drivers/platform/x86/dell/dell-wmi-base.c          |    6 +
 drivers/platform/x86/intel/bxtwc_tmu.c             |   22 +-
 drivers/platform/x86/panasonic-laptop.c            |   10 +-
 drivers/platform/x86/thinkpad_acpi.c               |   28 +-
 drivers/power/supply/bq27xxx_battery.c             |   37 +-
 drivers/power/supply/power_supply_core.c           |    2 -
 drivers/ptp/ptp_clock.c                            |    3 +-
 drivers/ptp/ptp_dte.c                              |    5 +-
 drivers/pwm/pwm-imx27.c                            |   98 +-
 drivers/regulator/rk808-regulator.c                |    2 +
 drivers/remoteproc/qcom_q6v5_mss.c                 |    6 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   44 +-
 drivers/rpmsg/qcom_glink_native.c                  |  101 +-
 drivers/rtc/interface.c                            |    7 +-
 drivers/rtc/rtc-ab-eoz9.c                          |    7 -
 drivers/rtc/rtc-abx80x.c                           |    2 +-
 drivers/rtc/rtc-cmos.c                             |   37 +-
 drivers/rtc/rtc-rzn1.c                             |    8 +-
 drivers/rtc/rtc-st-lpc.c                           |    5 +-
 drivers/s390/cio/cio.c                             |    6 +-
 drivers/s390/cio/device.c                          |   18 +-
 drivers/scsi/bfa/bfad.c                            |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   13 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   11 +
 drivers/scsi/qedf/qedf_main.c                      |    1 +
 drivers/scsi/qedi/qedi_main.c                      |    1 +
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |  124 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   15 +-
 drivers/scsi/scsi_debug.c                          |    2 +-
 drivers/scsi/st.c                                  |   31 +-
 drivers/sh/intc/core.c                             |    2 +-
 drivers/soc/fsl/rcpm.c                             |    1 +
 drivers/soc/imx/soc-imx8m.c                        |  107 +-
 drivers/soc/qcom/qcom-geni-se.c                    |    3 +-
 drivers/soc/qcom/socinfo.c                         |    8 +-
 drivers/soc/ti/smartreflex.c                       |    4 +-
 drivers/soc/ti/ti_sci_pm_domains.c                 |    4 +
 drivers/soc/xilinx/xlnx_event_manager.c            |    4 +-
 drivers/spi/atmel-quadspi.c                        |    2 +-
 drivers/spi/spi-fsl-lpspi.c                        |   14 +-
 drivers/spi/spi-mpc52xx.c                          |    1 +
 drivers/spi/spi-rpc-if.c                           |   14 +-
 drivers/spi/spi-tegra210-quad.c                    |    2 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |    2 +
 drivers/spi/spi.c                                  |   13 +-
 drivers/staging/media/atomisp/pci/sh_css_params.c  |    2 +
 .../intel/int340x_thermal/int3400_thermal.c        |    2 +-
 drivers/thermal/thermal_core.c                     |    2 +-
 drivers/tty/serial/8250/8250_dw.c                  |    5 +-
 drivers/tty/serial/8250/8250_fintek.c              |   14 +-
 drivers/tty/serial/8250/8250_omap.c                |    4 +-
 drivers/tty/serial/amba-pl011.c                    |   79 +-
 drivers/tty/serial/sc16is7xx.c                     |    5 +
 drivers/tty/tty_ldisc.c                            |    2 +-
 drivers/ufs/core/ufs-sysfs.c                       |    6 +
 drivers/ufs/core/ufshcd.c                          |   11 +-
 drivers/ufs/host/ufs-exynos.c                      |   16 +-
 drivers/ufs/host/ufs-renesas.c                     |    9 +-
 drivers/usb/chipidea/udc.c                         |    2 +-
 drivers/usb/dwc3/core.h                            |    1 +
 drivers/usb/dwc3/ep0.c                             |    7 +-
 drivers/usb/dwc3/gadget.c                          |  104 +-
 drivers/usb/dwc3/gadget.h                          |    1 +
 drivers/usb/gadget/composite.c                     |   18 +-
 drivers/usb/host/ehci-spear.c                      |    7 +-
 drivers/usb/host/xhci-dbgcap.c                     |  135 +-
 drivers/usb/host/xhci-dbgcap.h                     |    2 +-
 drivers/usb/host/xhci-ring.c                       |   18 +-
 drivers/usb/misc/chaoskey.c                        |   35 +-
 drivers/usb/misc/iowarrior.c                       |   50 +-
 drivers/usb/misc/yurex.c                           |    5 +-
 drivers/usb/musb/musb_gadget.c                     |   13 +-
 drivers/usb/typec/tcpm/wcove.c                     |    4 -
 drivers/vdpa/mlx5/core/mr.c                        |    4 +-
 drivers/vfio/pci/mlx5/cmd.c                        |   47 +-
 drivers/vfio/pci/vfio_pci_config.c                 |   16 +-
 drivers/video/fbdev/efifb.c                        |   11 +-
 drivers/video/fbdev/sh7760fb.c                     |   11 +-
 drivers/watchdog/apple_wdt.c                       |    2 +-
 drivers/watchdog/iTCO_wdt.c                        |   21 +-
 drivers/watchdog/mtk_wdt.c                         |    6 +
 drivers/watchdog/rti_wdt.c                         |    3 +-
 drivers/xen/xenbus/xenbus_probe.c                  |    8 +-
 fs/btrfs/ctree.c                                   |   10 +-
 fs/btrfs/ctree.h                                   |    2 -
 fs/btrfs/extent-tree.c                             |    3 +-
 fs/btrfs/inode.c                                   |   14 +-
 fs/btrfs/ioctl.c                                   |   36 +-
 fs/btrfs/ref-verify.c                              |    1 +
 fs/btrfs/root-tree.c                               |   10 -
 fs/btrfs/volumes.c                                 |   42 +-
 fs/cachefiles/ondemand.c                           |    4 +-
 fs/ceph/super.c                                    |   10 +-
 fs/eventpoll.c                                     |    6 +-
 fs/exfat/namei.c                                   |    1 +
 fs/ext4/ext4.h                                     |    1 +
 fs/ext4/fsmap.c                                    |   54 +-
 fs/ext4/mballoc.c                                  |   18 +-
 fs/ext4/mballoc.h                                  |    1 +
 fs/ext4/super.c                                    |   33 +-
 fs/f2fs/file.c                                     |    8 +-
 fs/f2fs/gc.c                                       |    2 +
 fs/f2fs/inode.c                                    |    4 +-
 fs/f2fs/segment.c                                  |   74 +-
 fs/f2fs/segment.h                                  |   41 +-
 fs/fscache/volume.c                                |    3 +-
 fs/hfsplus/hfsplus_fs.h                            |    3 +-
 fs/hfsplus/wrapper.c                               |    2 +
 fs/inode.c                                         |   10 +-
 fs/jffs2/compr_rtime.c                             |    3 +
 fs/jffs2/erase.c                                   |    7 +-
 fs/jfs/jfs_dmap.c                                  |    6 +
 fs/jfs/jfs_dtree.c                                 |   15 +
 fs/jfs/xattr.c                                     |    2 +-
 fs/nfs/internal.h                                  |    2 +-
 fs/nfs/nfs4proc.c                                  |    8 +-
 fs/nfsd/export.c                                   |    5 +-
 fs/nfsd/nfs4callback.c                             |   16 +-
 fs/nfsd/nfs4proc.c                                 |    7 +-
 fs/nfsd/nfs4recover.c                              |    3 +-
 fs/nfsd/nfs4state.c                                |   19 +
 fs/nilfs2/dir.c                                    |    2 +-
 fs/notify/fsnotify.c                               |   23 +-
 fs/ntfs3/record.c                                  |   32 +-
 fs/ocfs2/aops.h                                    |    2 +
 fs/ocfs2/dlmglue.c                                 |    1 +
 fs/ocfs2/file.c                                    |    4 +
 fs/ocfs2/localalloc.c                              |   19 -
 fs/ocfs2/namei.c                                   |    4 +-
 fs/overlayfs/inode.c                               |    7 +-
 fs/overlayfs/util.c                                |    3 +
 fs/proc/kcore.c                                    |   11 +-
 fs/proc/softirqs.c                                 |    2 +-
 fs/quota/dquot.c                                   |    2 +
 fs/smb/client/cached_dir.c                         |    2 +-
 fs/smb/client/cifssmb.c                            |    2 +-
 fs/smb/client/smb2ops.c                            |    8 +-
 fs/smb/server/smb2pdu.c                            |    6 +
 fs/ubifs/super.c                                   |    6 +-
 fs/ubifs/tnc_commit.c                              |    2 +
 fs/udf/inode.c                                     |   46 +-
 fs/unicode/mkutf8data.c                            |   70 +
 fs/unicode/utf8-core.c                             |    2 +-
 fs/unicode/utf8data.c_shipped                      | 6703 ++++++++++----------
 fs/xfs/libxfs/xfs_sb.c                             |    7 -
 fs/xfs/xfs_log_recover.c                           |    5 +-
 include/drm/display/drm_dp_mst_helper.h            |    7 +
 include/drm/ttm/ttm_tt.h                           |    7 +
 include/linux/arm-smccc.h                          |   30 +-
 include/linux/blkdev.h                             |    2 +-
 include/linux/bpf.h                                |    7 +-
 include/linux/cache.h                              |    6 +
 include/linux/crypto.h                             |    1 +
 include/linux/devfreq.h                            |    7 +-
 include/linux/dma-mapping.h                        |    5 +-
 include/linux/eeprom_93cx6.h                       |   11 +
 include/linux/eventpoll.h                          |    2 +-
 include/linux/fpga/fpga-bridge.h                   |   10 +-
 include/linux/fpga/fpga-mgr.h                      |   26 +-
 include/linux/fwnode.h                             |    2 +
 include/linux/hisi_acc_qm.h                        |    8 +-
 include/linux/i3c/master.h                         |   35 +-
 include/linux/jiffies.h                            |    2 +-
 include/linux/leds.h                               |    2 +-
 include/linux/lockdep.h                            |    2 +-
 include/linux/mmc/card.h                           |    1 +
 include/linux/netdevice.h                          |   30 +-
 include/linux/netpoll.h                            |    2 +-
 include/linux/pci-epc.h                            |    2 +
 include/linux/pci.h                                |    6 +
 include/linux/property.h                           |   20 +-
 include/linux/rbtree_latch.h                       |    2 +-
 include/linux/scatterlist.h                        |    2 +-
 include/linux/seqlock.h                            |  107 +-
 include/linux/slab.h                               |   14 +-
 include/linux/sock_diag.h                          |   10 +-
 include/linux/util_macros.h                        |   56 +-
 include/media/v4l2-dv-timings.h                    |   18 +-
 include/memory/renesas-rpc-if.h                    |   18 +-
 include/net/bluetooth/hci_sync.h                   |   12 +
 include/net/sock.h                                 |    2 +-
 include/trace/trace_events.h                       |   36 +-
 include/uapi/linux/rtnetlink.h                     |    2 +-
 include/ufs/ufshcd.h                               |   19 +-
 init/initramfs.c                                   |   15 +
 io_uring/io_uring.c                                |   12 +-
 io_uring/tctx.c                                    |   13 +-
 ipc/namespace.c                                    |    4 +-
 kernel/bpf/devmap.c                                |    6 +-
 kernel/bpf/helpers.c                               |    6 +-
 kernel/bpf/lpm_trie.c                              |   55 +-
 kernel/bpf/syscall.c                               |    3 +-
 kernel/bpf/verifier.c                              |   41 +-
 kernel/cgroup/cgroup.c                             |   21 +-
 kernel/dma/debug.c                                 |    8 +-
 kernel/kcsan/debugfs.c                             |   74 +-
 kernel/printk/printk.c                             |    2 +-
 kernel/rcu/tasks.h                                 |   82 +-
 kernel/sched/core.c                                |    4 +-
 kernel/sched/fair.c                                |    2 +-
 kernel/time/ntp.c                                  |    2 +-
 kernel/time/sched_clock.c                          |    2 +-
 kernel/time/time.c                                 |    2 +-
 kernel/time/timekeeping.c                          |    4 +-
 kernel/trace/bpf_trace.c                           |    6 +-
 kernel/trace/ftrace.c                              |    3 +
 kernel/trace/trace_clock.c                         |    2 +-
 kernel/trace/trace_eprobe.c                        |    5 +
 kernel/trace/trace_event_perf.c                    |    6 +
 kernel/trace/trace_syscalls.c                      |   12 +
 kernel/trace/tracing_map.c                         |    6 +-
 lib/maple_tree.c                                   |   13 +-
 lib/stackinit_kunit.c                              |    1 +
 lib/string_helpers.c                               |    2 +-
 mm/damon/vaddr-test.h                              |    1 +
 mm/damon/vaddr.c                                   |    4 +-
 mm/kasan/report.c                                  |   65 +-
 mm/mmap.c                                          |    4 +
 mm/page_alloc.c                                    |   15 +
 mm/swap.c                                          |   20 -
 mm/vmstat.c                                        |    1 +
 net/9p/trans_xen.c                                 |    9 +-
 net/bluetooth/hci_core.c                           |   13 +-
 net/bluetooth/hci_sync.c                           |  132 +-
 net/bluetooth/hci_sysfs.c                          |   15 +-
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/mgmt.c                               |   61 +-
 net/bluetooth/rfcomm/sock.c                        |   20 +-
 net/can/af_can.c                                   |    1 +
 net/can/j1939/transport.c                          |    2 +-
 net/core/dev.c                                     |   61 +-
 net/core/filter.c                                  |   95 +-
 net/core/gen_estimator.c                           |    2 +-
 net/core/neighbour.c                               |    1 +
 net/core/netpoll.c                                 |    2 +-
 net/core/rtnetlink.c                               |    2 +-
 net/core/skmsg.c                                   |    4 +-
 net/core/sock_diag.c                               |  114 +-
 net/dccp/feat.c                                    |    6 +-
 net/ethtool/bitset.c                               |   48 +-
 net/hsr/hsr_device.c                               |    4 +-
 net/hsr/hsr_forward.c                              |    2 +
 net/ieee802154/socket.c                            |   12 +-
 net/ipv4/af_inet.c                                 |   22 +-
 net/ipv4/cipso_ipv4.c                              |    2 +-
 net/ipv4/inet_connection_sock.c                    |    2 +-
 net/ipv4/inet_diag.c                               |   11 +-
 net/ipv4/ip_output.c                               |   13 +-
 net/ipv4/ipmr.c                                    |   44 +-
 net/ipv4/ipmr_base.c                               |    3 +-
 net/ipv4/tcp.c                                     |    2 +-
 net/ipv4/tcp_bpf.c                                 |   18 +-
 net/ipv4/tcp_fastopen.c                            |    7 +-
 net/ipv4/udp.c                                     |    2 +-
 net/ipv6/addrconf.c                                |   41 +-
 net/ipv6/af_inet6.c                                |   24 +-
 net/ipv6/ip6_fib.c                                 |    2 +-
 net/ipv6/ip6_output.c                              |   13 +-
 net/ipv6/ip6mr.c                                   |   40 +-
 net/ipv6/ipv6_sockglue.c                           |    3 +-
 net/ipv6/route.c                                   |   16 +-
 net/iucv/af_iucv.c                                 |   26 +-
 net/llc/af_llc.c                                   |    2 +-
 net/mac80211/main.c                                |    2 +
 net/mptcp/protocol.c                               |    4 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |    7 +-
 net/netfilter/ipset/ip_set_core.c                  |    5 +
 net/netfilter/ipvs/ip_vs_proto.c                   |    4 +-
 net/netfilter/nf_tables_api.c                      |   19 +-
 net/netfilter/nft_set_hash.c                       |   16 +
 net/netfilter/nft_socket.c                         |    2 +-
 net/netfilter/xt_LED.c                             |    4 +-
 net/netlink/diag.c                                 |    1 +
 net/packet/af_packet.c                             |   12 +-
 net/packet/diag.c                                  |    1 +
 net/rfkill/rfkill-gpio.c                           |    8 +-
 net/rxrpc/af_rxrpc.c                               |    7 +-
 net/sched/act_api.c                                |    2 +-
 net/sched/cls_flower.c                             |    5 +-
 net/sched/sch_cbs.c                                |    2 +-
 net/sched/sch_tbf.c                                |   18 +-
 net/smc/af_smc.c                                   |    2 +
 net/smc/smc_diag.c                                 |    1 +
 net/sunrpc/cache.c                                 |    4 +-
 net/sunrpc/xprtrdma/svc_rdma.c                     |   40 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |    8 +-
 net/sunrpc/xprtsock.c                              |    1 +
 net/tipc/diag.c                                    |    1 +
 net/tipc/udp_media.c                               |    2 +-
 net/unix/diag.c                                    |    1 +
 net/vmw_vsock/diag.c                               |    1 +
 net/xdp/xsk_buff_pool.c                            |    5 +-
 net/xdp/xsk_diag.c                                 |    1 +
 net/xdp/xskmap.c                                   |    2 +-
 samples/bpf/test_cgrp2_sock.c                      |    4 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |    1 +
 scripts/mod/file2alias.c                           |    5 +-
 scripts/mod/modpost.c                              |    2 +-
 security/apparmor/capability.c                     |    2 +
 security/apparmor/policy_unpack_test.c             |    6 +
 sound/core/pcm_native.c                            |    6 +-
 sound/hda/intel-dsp-config.c                       |    4 +
 sound/pci/hda/patch_realtek.c                      |  157 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   39 +-
 sound/soc/codecs/da7219.c                          |    9 +-
 sound/soc/codecs/hdmi-codec.c                      |  144 +-
 sound/soc/fsl/fsl_micfil.c                         |    4 +-
 sound/soc/generic/audio-graph-card2.c              |    3 +
 sound/soc/intel/atom/sst/sst_acpi.c                |   64 +-
 sound/soc/intel/avs/pcm.c                          |    2 +-
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
 sound/usb/mixer.c                                  |   58 +-
 sound/usb/mixer_maps.c                             |   10 +
 sound/usb/quirks-table.h                           |   14 +-
 sound/usb/quirks.c                                 |   58 +-
 sound/usb/usbaudio.h                               |    4 +
 sound/usb/usx2y/us122l.c                           |    5 +-
 sound/usb/usx2y/usbusx2y.c                         |    2 +-
 tools/bpf/bpftool/jit_disasm.c                     |   51 +-
 tools/bpf/bpftool/main.h                           |   25 +-
 tools/bpf/bpftool/map.c                            |    1 -
 tools/bpf/bpftool/prog.c                           |   22 +-
 tools/lib/bpf/libbpf.c                             |    4 +-
 tools/lib/bpf/linker.c                             |    2 +
 tools/lib/thermal/Makefile                         |    4 +-
 tools/lib/thermal/commands.c                       |   52 +-
 tools/perf/builtin-ftrace.c                        |    2 +-
 tools/perf/builtin-stat.c                          |   52 +-
 tools/perf/builtin-trace.c                         |   16 +-
 tools/perf/util/cs-etm.c                           |   25 +-
 tools/perf/util/evlist.c                           |   19 +-
 tools/perf/util/evlist.h                           |    1 +
 tools/perf/util/probe-finder.c                     |   21 +-
 tools/perf/util/probe-finder.h                     |    4 +-
 tools/scripts/Makefile.arch                        |    4 +-
 .../selftests/arm64/mte/check_tags_inclusion.c     |    4 +-
 .../testing/selftests/arm64/mte/mte_common_util.c  |    4 +-
 tools/testing/selftests/arm64/pauth/pac.c          |    3 +
 tools/testing/selftests/bpf/network_helpers.h      |   44 +
 tools/testing/selftests/bpf/test_progs.c           |    9 +-
 tools/testing/selftests/bpf/test_sockmap.c         |  165 +-
 .../selftests/mount_setattr/mount_setattr_test.c   |    2 +-
 tools/testing/selftests/net/pmtu.sh                |    2 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |    3 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |    3 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |    6 +
 tools/testing/selftests/wireguard/netns.sh         |    1 +
 tools/tracing/rtla/src/utils.c                     |    4 +-
 tools/tracing/rtla/src/utils.h                     |    2 +
 tools/verification/dot2/automata.py                |   18 +-
 775 files changed, 11374 insertions(+), 7070 deletions(-)


