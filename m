Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C92FAC05;
	Tue, 26 Aug 2025 11:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206768; cv=none; b=hvpZFlEW7av7MAsh+PNj99fr4Z+lARmhNabFIcPZejWpJkb6ZjZzKizg2ErLhrzRRiD4Gf+W923OYLGWHsKgaik36WgoBB4lrXWcN9J94SWgMORLjT0ic1z9SmO0APAxMXKfmnivBYFByJjJdG07c++Jo52sUcghUHDesgrNj2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206768; c=relaxed/simple;
	bh=Ez7O+KDr/w3CzS006JHUOCW1Kp1kZvLdwcrF5oBQvIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cZilN9PVueo3I2gusT42FngRrLZNZVvWOx152U9xAE3abh8/wIjd2Vj0sSq1cCsZwezE5cCvXEjX1Pkijm26NOQnBA4IPmPcTjqcgBV5DQWs7e6+4hbHk2wEVW4Og5D6s4dqIF2uUsfS8TVFmnCgdUfJs45IJVDGSr1o3h65GH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DN4jpP8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DN4jpP8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7C3C4CEF1;
	Tue, 26 Aug 2025 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206767;
	bh=Ez7O+KDr/w3CzS006JHUOCW1Kp1kZvLdwcrF5oBQvIQ=;
	h=From:To:Cc:Subject:Date:From;
	b=DN4jpP8Zo9tr0jRZJKhX7hxtZABgwE/6PQYGZFkBmW+WcSvELCcpJvNyxEqp0BjsX
	 27bb1Lf2SIky68ARLYQjhFdU+bgYXBGrhSxHEWcCKG1zVsvnk/mkMA2Pg36anSg/A4
	 lOnKlM2UGN2aqQg5ltwS5/2XNI0R3/mu+OVldMdY=
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
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 5.15 000/644] 5.15.190-rc1 review
Date: Tue, 26 Aug 2025 13:01:31 +0200
Message-ID: <20250826110946.507083938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.190-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.190-rc1
X-KernelTest-Deadline: 2025-08-28T11:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.190 release.
There are 644 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Aug 2025 11:08:21 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.190-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.190-rc1

Mikhail Lobanov <m.lobanov@rosa.ru>
    wifi: mac80211: check basic rates validity in sta_link_apply_parameters

Florian Westphal <fw@strlen.de>
    netfilter: nf_reject: don't leak dst refcount for loopback packets

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Enable limited access during lockdown

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Avoid unnecessary ioctl registration in debugfs

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation

Hangbin Liu <liuhangbin@gmail.com>
    bonding: update LACP activity flag after setting lacp_active

William Liu <will@willsroot.io>
    net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate

William Liu <will@willsroot.io>
    net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit

ValdikSS <iam@valdikss.org.ru>
    igc: fix disabling L1.2 PCI-E link substate on I226 on init

Jason Xing <kernelxing@tencent.com>
    ixgbe: xsk: resolve the negative overflow of budget in ixgbe_xmit_zc

Yuichiro Tsuji <yuichtsu@amazon.com>
    net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix timestamping for vsc8584

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: phy: Use netif_rx().

Qingfang Deng <dqfext@gmail.com>
    ppp: fix race conditions in ppp_fill_forward_path

Minhong He <heminhong@kylinos.cn>
    ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add

Chenyuan Yang <chenyuan0y@gmail.com>
    drm/amd/display: Add null pointer check in mod_hdcp_hdcp1_create_session()

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix size validation in convert_chmap_v3()

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix the hibmc loaded failed bug

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum: Forward packets with an IPv4 link-local source IP

Kees Cook <kees@kernel.org>
    iommu/amd: Avoid stack buffer overflow from kernel cmdline

Dan Carpenter <dan.carpenter@linaro.org>
    scsi: qla4xxx: Prevent a potential error pointer dereference

Wang Liang <wangliang74@huawei.com>
    net: bridge: fix soft lockup in br_multicast_query_expired()

Anantha Prabhu <anantha.prabhu@broadcom.com>
    RDMA/bnxt_re: Fix to initialize the PBL array

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Use static_branch_enable_cpuslocked() on cpusets_insane_config_key

Feng Tang <feng.tang@intel.com>
    mm/page_alloc: detect allocation forbidden by cpuset and bail out early

Tianxiang Peng <txpeng@tencent.com>
    x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper

Jinjiang Tu <tujinjiang@huawei.com>
    mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: as73211: Ensure buffer holes are zeroed

Pu Lehui <pulehui@huawei.com>
    tracing: Limit access to parser->buffer when trace_get_user failed

Steven Rostedt <rostedt@goodmis.org>
    tracing: Remove unneeded goto out logic

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: change invalid data error to -EBUSY

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    usb: xhci: Fix slot_id resource race conflict

Jan Beulich <jbeulich@suse.com>
    compiler: remove __ADDRESSABLE_ASM{_STR,}() again

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: check flush doesn't reset limits

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Fix duty and period setting

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Handle hardware enable and clock enable separately

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: mediatek: Implement .apply() callback

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Serialize admin queue BAR writes on 32-bit systems

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Drop unnecessary volatile from __iomem pointers

André Draszik <andre.draszik@linaro.org>
    scsi: ufs: exynos: Fix programming of HCI_UTRL_NEXUS_TYPE

David Lechner <dlechner@baylibre.com>
    iio: adc: ad_sigma_delta: change to buffer predisable

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Ensure we don't read past the ELF header

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix dest ring-buffer corruption when ring is full

Kefeng Wang <wangkefeng.wang@huawei.com>
    asm-generic: Add memory barrier dma_mb()

Marco Elver <elver@google.com>
    locking/barriers, kcsan: Support generic instrumentation

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: protect against spurious interrupts during probe

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: Add support for SSR trigger using fault injection

Sasha Levin <sashal@kernel.org>
    media: qcom: camss: cleanup media device allocated resource on error path

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    media: camss: Convert to platform remove callback returning void

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in dnode page

Imre Deak <imre.deak@intel.com>
    drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: disable add_addr retransmission when timeout is 0

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overclock DCE 6 by 15%

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Remove WARN_ON for device endpoint command timeouts

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Ignore late xferNotReady event to prevent halt timeout

Zenm Chen <zenmchen@gmail.com>
    USB: storage: Ignore driver CD mode for Realtek multi-mode Wi-Fi dongles

Thorsten Blum <thorsten.blum@linux.dev>
    usb: storage: realtek_cr: Use correct byte order for bcs->Residue

Mael GUERIN <mael.guerin@murena.io>
    USB: storage: Add unusual-devs entry for Novatek NTK96550-based camera

Marek Vasut <marek.vasut+renesas@mailbox.org>
    usb: renesas-xhci: Fix External ROM access timeouts

Xu Yang <xu.yang_2@nxp.com>
    usb: core: hcd: fix accessing unmapped memory in SINGLE_STEP_SET_FEATURE test

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix use of uninitialized memory in do_insn_ioctl() and do_insnlist_ioctl()

Edward Adam Davis <eadavis@qq.com>
    comedi: pcl726: Prevent invalid irq number

Ian Abbott <abbotti@mev.co.uk>
    comedi: Make insn_rw_emulate_bits() do insn->n samples

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive

Miaoqian Lin <linmq006@gmail.com>
    most: core: Drop device reference after usage in get_channel()

David Lechner <dlechner@baylibre.com>
    iio: proximity: isl29501: fix buffered read on big-endian systems

Salah Triki <salah.triki@gmail.com>
    iio: pressure: bmp280: Use IS_ERR() in bmp280_common_probe()

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Also allocate and copy hash for reading of filter files

Xu Yilun <yilun.xu@linux.intel.com>
    fpga: zynq_fpga: Fix the wrong usage of dma_map_sgtable()

Al Viro <viro@zeniv.linux.org.uk>
    use uniform permission checks for all mount propagation changes

Ye Bin <yebin10@huawei.com>
    fs/buffer: fix use-after-free when call bh_read() helper

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fill display clock and vblank time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Find first CRTC and its line time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DP audio DTO1 clock source on DCE 6.

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Avoid a NULL pointer dereference

Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>
    ALSA: hda/realtek: Add support for HP EliteBook x360 830 G6 and EliteBook 830 G6

Herton R. Krzesinski <herton@redhat.com>
    mm/debug_vm_pgtable: clear page table entries at destroy_args()

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix memory leak in squashfs_fill_super

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9763e: Rename the gli_set_gl9763e() for consistency

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Fix deadlock by moving removing flag earlier

Will Deacon <will@kernel.org>
    KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix default runtime and system PM levels

Archana Patni <archana.patni@intel.com>
    scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not queue data on closed subflows

Geliang Tang <geliang.tang@suse.com>
    mptcp: drop unused sk in mptcp_push_release

Mat Martineau <mathew.j.martineau@linux.intel.com>
    selftests: mptcp: Initialize variables to quiet gcc 12 warnings

Paolo Abeni <pabeni@redhat.com>
    mptcp: introduce MAPPING_BAD_CSUM

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix error mibs accounting

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: add missing join check

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover checksum

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover alt modes

Florian Westphal <fw@strlen.de>
    selftests: mptcp: make sendfile selftest work

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct linker when mixing clang and GNU ld

Li Zhong <floridsleeves@gmail.com>
    ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value

Nirmal Patel <nirmal.patel@linux.intel.com>
    PCI: vmd: Assign VMD IRQ domain before enumeration

Cong Wang <xiyou.wangcong@gmail.com>
    sch_htb: make htb_deactivate() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

Cong Wang <xiyou.wangcong@gmail.com>
    sch_drr: make drr_qlen_notify() idempotent

Qu Wenruo <wqu@suse.com>
    btrfs: populate otime when logging an inode item

Chao Gao <chao.gao@intel.com>
    KVM: VMX: Flush shadow VMCS on emergency reboot

Davide Caratti <dcaratti@redhat.com>
    net/sched: ets: use old 'nbands' while purging unused classes

Eric Dumazet <edumazet@google.com>
    net_sched: sch_ets: implement lockless ets_dump()

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_ets: properly init all active DRR list handles

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec: remove unneeded label and if-condition

Chen-Yu Tsai <wenst@chromium.org>
    platform/chrome: cros_ec: Use per-device lockdep key

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    platform/chrome: cros_ec: Make cros_ec_unregister() return void

Johan Hovold <johan@kernel.org>
    usb: dwc3: imx8mp: fix device leak at unbind

Youssef Samir <quic_yabdulra@quicinc.com>
    bus: mhi: host: Detect events pointing to unexpected TREs

Damien Le Moal <dlemoal@kernel.org>
    ata: Fix SATA_MOBILE_LPM_POLICY description in Kconfig

Johan Hovold <johan@kernel.org>
    usb: musb: omap2430: fix device leak at unbind

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: musb: omap2430: Convert to platform remove callback returning void

Anshuman Khandual <anshuman.khandual@arm.com>
    mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix the setting of capabilities when automounting a new filesystem

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Create an nfs4_server_set_init_caps() function

Johan Hovold <johan@kernel.org>
    net: enetc: fix device and OF node leak at probe

Damien Le Moal <dlemoal@kernel.org>
    block: Make REQ_OP_ZONE_FINISH a write operation

Lukas Wunner <lukas@wunner.de>
    PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports

Sebastian Reichel <sebastian.reichel@collabora.com>
    usb: typec: fusb302: cache PD RX state

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix panic during namespace deletion with VF

Thorsten Blum <thorsten.blum@linux.dev>
    smb: server: Fix extension string in ksmbd_extract_shortname()

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()

Dave Hansen <dave.hansen@linux.intel.com>
    x86/fpu: Delay instruction pointer fixup until after warning

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix use-after-free in crypt_message when using async crypto

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Don't try to recover devices lost during warm reset.

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: avoid warm port reset during USB3 disconnect

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce/amd: Add default names for MCA banks and blocks

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Fix incorrect OFFSET calculation

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Restore lost scale assignments

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on ino and xnid

Nathan Chancellor <nathan@kernel.org>
    ARM: 9448/1: Use an absolute path to unified.h in KBUILD_AFLAGS

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64/entry: Mask DAIF in cpu_switch_to(), call_on_irq_stack()

Lin.Cao <lincao12@amd.com>
    drm/sched: Remove optimization that causes hang when killing dependent jobs

Haoxiang Li <haoxiang_li2024@163.com>
    ice: Fix a null pointer dereference in ice_copy_and_init_pkg()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    selftests/memfd: add test for mapping write-sealed memfd read-only

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: reinstate ability to map write-sealed memfd mappings read-only

Lorenzo Stoakes <lstoakes@gmail.com>
    mm: update memfd seal write check to include F_SEAL_WRITE

Lorenzo Stoakes <lstoakes@gmail.com>
    mm: drop the assumption that VM_SHARED always implies writable

Cong Wang <xiyou.wangcong@gmail.com>
    sch_qfq: make qfq_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: make hfsc_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_htb: make htb_qlen_notify() idempotent

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: kernel: flush: do not reset ADD_ADDR limit

Christoph Paasch <cpaasch@openai.com>
    mptcp: drop skb if MPTCP skb extension allocation fails

Eric Biggers <ebiggers@kernel.org>
    ipv6: sr: Fix MAC comparison to be constant-time

Jakub Acs <acsjakub@amazon.de>
    net, hsr: reject HSR frame if skb can't hold tag

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overwrite dce60_clk_mgr

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Restore cached power limit during resume

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: venc: Clamp param smaller than 1fps and bigger than 240

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: vdec: Clamp param smaller than 1fps and bigger than 240.

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: hfi: explicitly release IRQ during teardown

Vedang Nagar <quic_vnagar@quicinc.com>
    media: venus: Add a check for packet size after reading from shared memory

Zhang Shurong <zhang_shurong@foxmail.com>
    media: ov2659: Fix memory leaks in ov2659_probe()

Gui-Dong Han <hanguidong02@gmail.com>
    media: rainshadow-cec: fix TOCTOU race condition in rain_interrupt()

Ludwig Disterhof <ludwig@disterhof.eu>
    media: usbtv: Lock resolution while streaming

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l2-ctrls: Don't reset handler's error in v4l2_ctrl_handler_free()

Haoxiang Li <haoxiang_li2024@163.com>
    media: imx: fix a potential memory leak in imx_media_csc_scaler_device_init()

Bingbu Cao <bingbu.cao@intel.com>
    media: hi556: correct the test pattern configuration

Dan Carpenter <dan.carpenter@linaro.org>
    media: gspca: Add bounds checking to firmware parser

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Ensure power-domains are in a known state

Baokun Li <libaokun1@huawei.com>
    jbd2: prevent softlockup in jbd2_log_do_checkpoint()

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group removal on driver teardown

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group list head handling

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: fsmc: Add missing check after DMA map

Gabor Juhos <j4g8y7@gmail.com>
    mtd: spinand: propagate spinand_wait() errors from spinand_write_page()

Tim Harvey <tharvey@gateworks.com>
    hwmon: (gsc-hwmon) fix fan pwm setpoint show functions

Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
    pwm: imx-tpm: Reset counter if CMOD is 0

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix source ring-buffer corruption

Nathan Chancellor <nathan@kernel.org>
    wifi: brcmsmac: Remove const from tbl_ptr parameter in wlc_lcnphy_common_read_table()

Marek Szyprowski <m.szyprowski@samsung.com>
    zynq_fpga: use sgtable-based scatterlist wrappers

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Fix ata_to_sense_error() status handling

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Fix race between config read submit and interrupt completion

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix hole length calculation overflow in non-extent inodes

Liao Yuanhong <liaoyuanhong@vivo.com>
    ext4: use kmalloc_array() for array space allocation

Theodore Ts'o <tytso@mit.edu>
    ext4: don't try to clear the orphan_present feature block device is r/o

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix reserved gdt blocks handling in fsmap

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix fsmap end of range reporting with bigalloc

Andreas Dilger <adilger@dilger.ca>
    ext4: check fast symlink for ea_inode correctly

Helge Deller <deller@gmx.de>
    Revert "vgacon: Add check for vc_origin address range in vgacon_scroll()"

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mips/chacha: Fix clang build and remove unneeded byteswap

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: defkeymap: Map keycodes above 127 to K_HOLE

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: keyboard: Don't process Unicode characters in K_OFF mode

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    bus: mhi: host: Fix endianness of BHI vector table

Johan Hovold <johan@kernel.org>
    usb: dwc3: meson-g12a: fix device leaks at unbind

Johan Hovold <johan@kernel.org>
    usb: gadget: udc: renesas_usb3: fix device leak at unbind

Nathan Chancellor <nathan@kernel.org>
    usb: atm: cxacru: Merge cxacru_upload_firmware() into cxacru_heavy_init()

Finn Thain <fthain@linux-m68k.org>
    m68k: Fix lost column on framebuffer debug console

Dan Carpenter <dan.carpenter@linaro.org>
    cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()

Yunhui Cui <cuiyunhui@bytedance.com>
    serial: 8250: fix panic due to PSLVERR

Aditya Garg <gargaditya08@live.com>
    HID: magicmouse: avoid setting up battery timer when not needed

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Do not mark valid metadata as invalid

Youngjun Lee <yjjuny.lee@samsung.com>
    media: uvcvideo: Fix 1-byte out-of-bounds read in uvc_parse_format()

Breno Leitao <leitao@debian.org>
    mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock

Waiman Long <longman@redhat.com>
    mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()

Randy Dunlap <rdunlap@infradead.org>
    parisc: Makefile: fix a typo in palo.conf

Sravan Kumar Gundu <sravankumarlpu@gmail.com>
    fbdev: Fix vmalloc out-of-bounds write in fast_imageblit

Qu Wenruo <wqu@suse.com>
    btrfs: do not allow relocation of partially dropped subvolumes

Filipe Manana <fdmanana@suse.com>
    btrfs: fix log tree replay failure due to file with 0 links and extents

Oliver Neukum <oneukum@suse.com>
    cdc-acm: fix race between initial clearing halt and open

Eric Biggers <ebiggers@kernel.org>
    thunderbolt: Fix copy+paste error in match_service_id()

Ian Abbott <abbotti@mev.co.uk>
    comedi: fix race between polling and detaching

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    usb: typec: ucsi: Update power_supply on power role change

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: usb: Ensure mmc child device is active when card is present

Xinyu Liu <katieeliu@tencent.com>
    usb: core: config: Prevent OOB read in SS endpoint companion parsing

Baokun Li <libaokun1@huawei.com>
    ext4: fix largest free orders lists corruption on mb_optimize_scan switch

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: fix incorrect vm flags to map bo

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: replace regmap_write with regmap_update_bits

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai.h: merge DAI call back functions into ops

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai.c: add missing flag check at snd_soc_pcm_dai_probe()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    scsi: lpfc: Remove redundant assignment to avoid memory leak

Meagan Lloyd <meaganlloyd@linux.microsoft.com>
    rtc: ds1307: remove clear of oscillator stop flag (OSF) in probe

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix uninited ptr deref in block/scsi layout

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Handle RPC size limit for layoutcommits

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix disk addr range check in block/scsi layout

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix stripe mapping in block/scsi layout

John Garry <john.g.garry@oracle.com>
    block: avoid possible overflow for chunk_sectors check in blk_stack_limits()

Buday Csaba <buday.csaba@prolan.hu>
    net: phy: smsc: add proper reset flags for LAN8710A

Corey Minyard <corey@minyard.net>
    ipmi: Fix strcpy source and destination the same

Yann E. MORIN <yann.morin.1998@free.fr>
    kconfig: lxdialog: fix 'space' to (de)select options

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: fix potential memory leak in renderer_edited()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()

Breno Leitao <leitao@debian.org>
    ipmi: Use dev_warn_ratelimited() for incorrect message warnings

John Garry <john.g.garry@oracle.com>
    scsi: aacraid: Stop using PCI_IRQ_AFFINITY

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Generate correct identifiers for PR OUT transport IDs

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans

Shankari Anand <shankari.ak0208@gmail.com>
    kconfig: nconf: Ensure null termination where strncpy is used

Suchit Karunakaran <suchitkarunakaran@gmail.com>
    kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c

fangzhong.zhou <myth5@myth5.com>
    i2c: Force DLL0945 touchpad i2c freq to 100khz

Mikulas Patocka <mpatocka@redhat.com>
    dm-mpath: don't print the "loaded" message if registering fails

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: don't fail if GETHDRCAP is unsupported

Meagan Lloyd <meaganlloyd@linux.microsoft.com>
    rtc: ds1307: handle oscillator stop flag (OSF) for ds1341

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: add missing include to internal header

Purva Yeshi <purvayeshi550@gmail.com>
    md: dm-zoned-target: Initialize return variable r to avoid uninitialized use

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - add timeout for load_fvc completion poll

chenchangcheng <chenchangcheng@kylinos.cn>
    media: uvcvideo: Fix bandwidth issue for Alcor camera

Alex Guo <alexguo1023@gmail.com>
    media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar

Alex Guo <alexguo1023@gmail.com>
    media: dvb-frontends: dib7090p: fix null-ptr-deref in dib7090p_rw_on_apb()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    media: usb: hdpvr: disable zero-length read messages

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Increase FIFO trigger level to 374

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Return an appropriate colorspace from tc358743_set_fmt

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Check I2C succeeded during probe

Cheick Traore <cheick.traore@foss.st.com>
    pinctrl: stm32: Manage irq affinity settings

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Correctly handle ATA device errors

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure

Arnd Bergmann <arnd@arndb.de>
    RDMA/core: reduce stack using in nldev_stat_get_doit()

Yury Norov [NVIDIA] <yury.norov@gmail.com>
    RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()

Johan Adolfsson <johan.adolfsson@axis.com>
    leds: leds-lp50xx: Handle reg to get correct multi_index

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    MIPS: Don't crash in stack_top() for tasks without ABI or vDSO

Arnaud Lecomte <contact@arnaud-lcm.com>
    jfs: upper bound check of tree index in dbAllocAG

Edward Adam Davis <eadavis@qq.com>
    jfs: Regular file corruption check

Lizhi Xu <lizhi.xu@windriver.com>
    jfs: truncate good inode pages when hard link is 0

jackysliu <1972843537@qq.com>
    scsi: bfa: Double-free fix

Ziyan Fu <fuzy5@lenovo.com>
    watchdog: iTCO_wdt: Report error if timeout configuration fails

Shiji Yang <yangshiji66@outlook.com>
    MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}

Sebastian Reichel <sebastian.reichel@collabora.com>
    watchdog: dw_wdt: Fix default timeout

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    fs/orangefs: use snprintf() instead of sprintf()

Showrya M N <showrya@chelsio.com>
    scsi: libiscsi: Initialize iscsi_conn->dd_data only if memory is allocated

Theodore Ts'o <tytso@mit.edu>
    ext4: do not BUG when INLINE_DATA_FL lacks system.data xattr

Zhiqi Song <songzhiqi1@huawei.com>
    crypto: hisilicon/hpre - fix dma unmap sequence

Pali Rohár <pali@kernel.org>
    cifs: Fix calling CIFSFindFirst() for root path without msearch

Aaron Plattner <aplattner@nvidia.com>
    watchdog: sbsa: Adjust keepalive timeout to avoid MediaTek WS0 race condition

Jason Wang <jasowang@redhat.com>
    vhost: fail early when __vhost_add_used() fails

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix IP_MULTICAST_CTRL on BCM5325

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/ttm: Respect the shrinker core free target

Jakub Kicinski <kuba@kernel.org>
    uapi: in6: restore visibility of most IPv6 socket options

Emily Deng <Emily.Deng@amd.com>
    drm/ttm: Should to return the evict error

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix buffer overflow in fetching version id

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: rtlwifi: fix possible skb memory leak in _rtl_pci_init_one_rxdesc()

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent SWITCH_CTRL access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent DIS_LEARNING access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix b53_imp_vlan_setup for BCM5325

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: Return error for unknown admin queue command

Gal Pressman <gal@nvidia.com>
    net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Allow printing VanGogh OD SCLK levels without setting dpm to manual

Heiner Kallweit <hkallweit1@gmail.com>
    dpaa_eth: don't use fixed_phy_change_carrier

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: Check rate_idx range after addition

Mina Almasry <almasrymina@google.com>
    netmem: fix skb_frag_address_safe with unreadable skbs

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: rtlwifi: fix possible skb memory leak in `_rtl_pci_rx_interrupt()`.

Wen Chen <Wen.Chen3@amd.com>
    drm/amd/display: Fix 'failed to blank crtc!'

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect

Rand Deeb <rand.sec96@gmail.com>
    wifi: iwlwifi: dvm: fix potential overflow in rs_fill_link_cmd()

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Separate set_gsl from set_gsl_source_select

Jonas Rebmann <jre@pengutronix.de>
    net: fec: allow disable coalescing

Eric Work <work.eric@gmail.com>
    net: atlantic: add set_power to fw_ops for atl2 to fix wol

zhangjianrong <zhangjianrong5@huawei.com>
    net: thunderbolt: Fix the parameter passing of tb_xdomain_enable_paths()/tb_xdomain_disable_paths()

Rob Clark <robdclark@chromium.org>
    drm/msm: use trylock for debugfs

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Check inet6_dev->dead under idev->mc_lock in __ipv6_dev_mc_inc().

Thomas Fourier <fourier.thomas@gmail.com>
    (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't complete management TX on SAE commit

Sven Schnelle <svens@linux.ibm.com>
    s390/stp: Remove udelay from stp_sync_clock()

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: fix scan request validation

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix accounting after global limits change

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: thunderx: Fix format-truncation warning in bgx_acpi_match_id()

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: fix incorrect MTU in broadcast routes

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Fix interface type validation

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Prevent duplicate binds

Paul E. McKenney <paulmck@kernel.org>
    rcu: Protect ->defer_qs_iw_pending from data race

Breno Leitao <leitao@debian.org>
    arm64: Mark kernel as tainted on SAE and SError panic

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Properly access RCU protected qdisc_sleeping variable

Thomas Fourier <fourier.thomas@gmail.com>
    net: ag71xx: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    et131x: Add missing check after DMA map

Alok Tiwari <alok.a.tiwari@oracle.com>
    be2net: Use correct byte order and format string for TCP seq and ack_seq

Sven Schnelle <svens@linux.ibm.com>
    s390/time: Use monotonic clock in get_cycles()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: reject HTC bit for management frames

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Prevent recursion of default variable options

Anthoine Bourgeois <anthoine.bourgeois@vates.tech>
    xen/netfront: Fix TX response spurious interrupts

Xinxin Wan <xinxin.wan@intel.com>
    ASoC: codecs: rt5640: Retry DEVICE_ID verification

Jonathan Santos <Jonathan.Santos@analog.com>
    iio: adc: ad7768-1: Ensure SYNC_IN pulse minimum timing requirement

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Avoid precedence issues in mixer_quirks macros

Christophe Leroy <christophe.leroy@csgroup.eu>
    ALSA: pcm: Rewrite recalculate_boundary() to avoid costly loop

Lucy Thrun <lucy.thrun@digital-rabbithole.de>
    ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control

Tomasz Michalec <tmichalec@google.com>
    platform/chrome: cros_ec_typec: Defer probe on missing EC parent

Kees Cook <kees@kernel.org>
    platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches

Gautham R. Shenoy <gautham.shenoy@amd.com>
    pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()

Oliver Neukum <oneukum@suse.com>
    usb: core: usb_submit_urb: downgrade type check

Tomasz Michalec <tmichalec@google.com>
    usb: typec: intel_pmc_mux: Defer probe if SCU IPC isn't present

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()

Alok Tiwari <alok.a.tiwari@oracle.com>
    ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4

Mark Brown <broonie@kernel.org>
    ASoC: hdac_hdmi: Rate limit logging on connection and disconnection

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Avoid warning when overriding return thunk

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()

Peter Robinson <pbrobinson@gmail.com>
    reset: brcmstb: Enable reset drivers for ARCH_BCM2835

Eliav Farber <farbere@amazon.com>
    pps: clients: gpio: fix interrupt handling order in remove path

Breno Leitao <leitao@debian.org>
    ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path

Sarthak Garg <quic_sartgarg@quicinc.com>
    mmc: sdhci-msm: Ensure SD card power isn't ON when card removed

Sebastian Ott <sebott@redhat.com>
    ACPI: processor: fix acpi_object initialization

tuhaowen <tuhaowen@uniontech.com>
    PM: sleep: console: Fix the black screen issue

Hsin-Te Yuan <yuanhsinte@chromium.org>
    thermal: sysfs: Return ENODATA instead of EAGAIN for reads

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()

Zhu Qiyu <qiyuzhu2@amd.com>
    ACPI: PRM: Reduce unnecessary printing to avoid user confusion

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests: tracing: Use mutex_unlock for testing glob filter

Aaron Kling <webgeek1234@gmail.com>
    ARM: tegra: Use I/O memcpy to write to IRAM

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: tps65912: check the return value of regmap_update_bits()

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: define time_t in terms of __kernel_old_time_t

David Collins <david.collins@oss.qualcomm.com>
    thermal/drivers/qcom-spmi-temp-alarm: Enable stage 2 shutdown when required

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    EDAC/synopsys: Clear the ECC counters on init

Lifeng Zheng <zhenglifeng1@huawei.com>
    PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()

Alexander Kochetkov <al.kochet@gmail.com>
    ARM: rockchip: fix kernel hang during smp initialization

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Exit governor when failed to start old governor

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: wcd934x: check the return value of regmap_update_bits()

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing errors during surprise removal

Jay Chen <shawn2000100@gmail.com>
    usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing warnings for dying controller

Benson Leung <bleung@chromium.org>
    usb: typec: ucsi: psy: Set current max to 100mA for BC 1.2 and Default

Cynthia Huang <cynthia@andestech.com>
    selftests/futex: Define SYS_futex on 32-bit architectures with 64-bit time_t

Prashant Malani <pmalani@google.com>
    cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag

Su Hui <suhui@nfschina.com>
    usb: xhci: print xhci->xhc_state when queue_command failed

Al Viro <viro@zeniv.linux.org.uk>
    securityfs: don't pin dentries twice, once is enough...

Wei Gao <wegao@suse.com>
    ext2: Handle fiemap on empty files to prevent EINVAL

Rong Zhang <ulin0208@gmail.com>
    fs/ntfs3: correctly create symlink for relative path

Lizhi Xu <lizhi.xu@windriver.com>
    fs/ntfs3: Add sanity check for file name

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-sata: Disallow changing LPM state if not supported

Al Viro <viro@zeniv.linux.org.uk>
    better lockdep annotations for simple_recursive_removal()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix not erasing deleted b-tree node issue

Sarah Newman <srn@prgmr.com>
    drbd: add missing kref_get in handle_write_conflicts

Jan Kara <jack@suse.cz>
    udf: Verify partition map count

NeilBrown <neil@brown.name>
    smb/server: avoid deadlock when linking with ReplaceIfExists

Kees Cook <kees@kernel.org>
    arm64: Handle KCOV __init vs inline mismatches

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    hfsplus: don't use BUG_ON() in hfsplus_create_attributes_file()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds in hfsplus_bnode_read()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix slab-out-of-bounds in hfs_bnode_read()

Jeongjun Park <aha310510@gmail.com>
    ptp: prevent possible ABBA deadlock in ptp_clock_freerun()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Avoid using invalid recent intervals data

Len Brown <len.brown@intel.com>
    intel_idle: Allow loading ACPI tables for any family

Xin Long <lucien.xin@gmail.com>
    sctp: linearize cloned gso packets in sctp_rcv

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: fix refcount leak on table dump

Sabrina Dubroca <sd@queasysnail.net>
    udp: also consider secpath when evaluating ipsec use for checksumming

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: perflib: Move problematic pr->performance check

Jiayi Li <lijiayi@kylinos.cn>
    ACPI: processor: perflib: Fix initial _PPC limit application

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Documentation: ACPI: Fix parent device references

Jann Horn <jannh@google.com>
    eventpoll: Fix semi-unbounded recursion

Sasha Levin <sashal@kernel.org>
    fs: Prevent file descriptor table allocations exceeding INT_MAX

Ma Ke <make24@iscas.ac.cn>
    sunvdc: Balance device refcount in vdc_port_mpgroup_check

Dai Ngo <dai.ngo@oracle.com>
    NFSD: detect mismatch of file handle and delegation stateid in OPEN op

Jeff Layton <jlayton@kernel.org>
    nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()

Xu Yang <xu.yang_2@nxp.com>
    net: usb: asix_devices: add phy_mask for ax88772 mdio bus

Johan Hovold <johan@kernel.org>
    net: dpaa: fix device leak when querying time stamp info

Johan Hovold <johan@kernel.org>
    net: gianfar: fix device leak when querying time stamp info

Fedor Pchelkin <pchelkin@ispras.ru>
    netlink: avoid infinite retry looping in netlink_unicast()

Harald Mommer <harald.mommer@oss.qualcomm.com>
    gpio: virtio: Fix config space reading.

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 cluster segment descriptors

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 power domain descriptors, too

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't use int for ABI

Tao Xue <xuetao09@huawei.com>
    usb: gadget : fix use-after-free in composite_dev_cleanup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: mm: tlb-r4k: Uniquify TLB entries on init

Thorsten Blum <thorsten.blum@linux.dev>
    ALSA: intel_hdmi: Fix off-by-one error in __hdmi_lpe_audio_probe()

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    net: usbnet: Fix the wrong netif_carrier_on() call

John Ernberg <john.ernberg@actia.se>
    net: usbnet: Avoid potential RCU stall on LINK_CHANGE event

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W709

Budimir Markovic <markovicbudimir@gmail.com>
    vsock: Do not allow binding to VMADDR_PORT_ANY

Quang Le <quanglex97@gmail.com>
    net/packet: fix a race in packet_set_ring() and packet_notifier()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    selftests/perf_events: Add a mmap() correctness test

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Prevent VMA split of buffer mappings

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Exit early on perf_mmap() fail

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Don't leak AUX buffer refcount on allocation failure

Eric Dumazet <edumazet@google.com>
    pptp: fix pptp_xmit() error path

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done() cleanup before notifying the callers.

Stefan Metzmacher <metze@samba.org>
    smb: server: let recv_done() avoid touching data_transfer after cleanup/move

Stefan Metzmacher <metze@samba.org>
    smb: server: let recv_done() consistently call put_recvmsg/smb_direct_disconnect_rdma_connection

Stefan Metzmacher <metze@samba.org>
    smb: server: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already

Stefan Metzmacher <metze@samba.org>
    smb: server: remove separate empty_recvmsg_queue

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()

Michal Schmidt <mschmidt@redhat.com>
    benet: fix BUG when creating VFs

Wang Liang <wangliang74@huawei.com>
    net: drop UFO packets in udp_rcv_segment()

Eric Dumazet <edumazet@google.com>
    ipv6: reject malicious packets in ipv6_gso_segment()

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_segs when LRO is used

Eric Dumazet <edumazet@google.com>
    pptp: ensure minimal skb length in pptp_xmit()

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix parsing of unicast frames

Jakub Kicinski <kuba@kernel.org>
    netpoll: prevent hanging NAPI when netcons gets enabled

Benjamin Coddington <bcodding@redhat.com>
    NFS: Fixup allocation flags for nfsiod's __GFP_NORETRY

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Add calls to might_alloc()

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: another fix for listxattr

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    pNFS/flexfiles: don't attempt pnfs on fatal DS errors

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Fix surprise plug detection and recovery

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc/eeh: Make EEH driver device hotplug safe

Maciej W. Rozycki <macro@orcam.me.uk>
    powerpc/eeh: Rely on dev->link_active_reporting

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc/eeh: Export eeh_unfreeze_pe()

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Work around switches with broken presence detection

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Clean up allocated IRQs on unplug

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: fix ConfigList::updateListAllforAll()

Seunghui Lee <sh043.lee@samsung.com>
    scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume

Tomas Henzl <thenzl@redhat.com>
    scsi: mpt3sas: Fix a fw_event memory leak

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in devs.path

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid panic in f2fs_evict_inode

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_sync_inode_meta()

Chao Yu <chao@kernel.org>
    f2fs: doc: fix wrong quota mount option description

Abinash Singh <abinashlalotra@gmail.com>
    f2fs: fix KMSAN uninit-value in extent_info usage

Brian Masney <bmasney@redhat.com>
    rtc: rv3028: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: pcf8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: pcf85063: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: hym8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: ds1307: fix incorrect maximum clock rate handling

Uros Bizjak <ubizjak@gmail.com>
    ucount: fix atomic_long_inc_below() argument type

Petr Pavlu <petr.pavlu@suse.com>
    module: Restore the moduleparam prefix length check

Ryan Lee <ryan.lee@canonical.com>
    apparmor: ensure WB_HISTORY_SIZE value is a power of 2

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Check flow_dissector ctx accesses are aligned

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Fix log flooding with target does not exist errors

Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
    mtd: rawnand: atmel: set pmecc data setup time

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: rockchip: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: atmel: Fix dma_mapping_error() address

Zheng Yu <zheng.yu@northwestern.edu>
    jfs: fix metapage reference count leak in dbAllocCtl

Chenyuan Yang <chenyuan0y@gmail.com>
    fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix seq_file position update in adf_ring_next()

Ben Hutchings <benh@debian.org>
    sh: Do not use hyphen in exported variable name

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: nbpfaxi: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: mv_xor: Fix missing check after DMA map and missing unmap

Dan Carpenter <dan.carpenter@linaro.org>
    fs/orangefs: Allow 2 more characters in do_c_string()

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-vntb: Fix the incorrect usage of __iomem attribute

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: stream: restore params when prepare ports fail

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: img-hash - Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: keembay - Fix dma_unmap_sg() nents value

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    hwrng: mtk - handle devm_pm_runtime_enable errors

Dan Carpenter <dan.carpenter@linaro.org>
    watchdog: ziirave_wdt: check record length in ziirave_firm_verify()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: isci: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: mvsas: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value

Paul Kocialkowski <paulk@sys-base.io>
    clk: sunxi-ng: v3s: Fix de clock definition

Leo Yan <leo.yan@arm.com>
    perf tests bp_account: Fix leaked file descriptor

Arnd Bergmann <arnd@arndb.de>
    kernel: trace: preemptirq_delay_test: use offstack cpu mask

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix -Wframe-larger-than issue

Mengbiao Xiong <xisme1998@gmail.com>
    crypto: ccp - Fix crash when rebind ccp device for ccp.ko

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: inside-secure - Fix `dma_unmap_sg()` nents value

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks for evsel->priv in timehist

Nuno Sá <nuno.sa@analog.com>
    clk: clk-axi-clkgen: fix fpfd_max frequency for zynq

Yuan Chen <chenyuan@kylinos.cn>
    pinctrl: sunxi: Fix memory leak on krealloc failure

Jerome Brunet <jbrunet@baylibre.com>
    PCI: endpoint: pci-epf-vntb: Return -ENOENT if pci_epc_get_next_free_bar() fails

Charles Han <hanchunchao@inspur.com>
    power: supply: max14577: Handle NULL pdata when CONFIG_OF is not set

Charles Han <hanchunchao@inspur.com>
    power: supply: cpcap-charger: Fix null check for power_supply_get_by_name

Rohit Visavalia <rohit.visavalia@amd.com>
    clk: xilinx: vcu: unregister pll_post only if registered correctly

James Cowgill <james.cowgill@blaize.com>
    media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check

Henry Martin <bsdhenrymartin@gmail.com>
    clk: davinci: Add NULL check in davinci_lpsc_clk_register()

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: fix possible integer overflow in erase_xfer()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Fix engine load inaccuracy

Hans Zhang <18255117159@163.com>
    PCI: rockchip-host: Fix "Unexpected Completion" log message

Stanislav Fomichev <sdf@fomichev.me>
    vrf: Drop existing dst reference in vrf_ip6_input_dst

Xiumei Mu <xmu@redhat.com>
    selftests: rtnetlink.sh: remove esp4_offload after test

Florian Westphal <fw@strlen.de>
    netfilter: xt_nfacct: don't assume acct name is null-terminated

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Assign netdev.dev_port based on device channel index

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Store device channel index

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE

Remi Pommarel <repk@triplefau.lt>
    Reapply "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: mac80211: Don't call fq_flow_idx() for management frames

Thomas Fourier <fourier.thomas@gmail.com>
    mwl8k: Add missing check after DMA map

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: Fix RX skb size for aggregation disabled

Juergen Gross <jgross@suse.com>
    xen/gntdev: remove struct gntdev_copy_batch from stack

Eric Dumazet <edumazet@google.com>
    net_sched: act_ctinfo: use atomic64_t for three counters

William Liu <will@willsroot.io>
    net/sched: Restrict conditions for adding duplicating netems to qdisc tree

Tiwei Bie <tiwei.btw@antgroup.com>
    um: rtc: Avoid shadowing err in uml_rtc_start()

Johan Korsnes <johan.korsnes@gmail.com>
    arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX

Fedor Pchelkin <pchelkin@ispras.ru>
    netfilter: nf_tables: adjust lockdep assertions handling

Fedor Pchelkin <pchelkin@ispras.ru>
    drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value

Finn Thain <fthain@linux-m68k.org>
    m68k: Don't unregister boot console needlessly

Stav Aviram <saviram@nvidia.com>
    net/mlx5: Check device memory pointer before usage

xin.guo <guoxin0309@gmail.com>
    tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range

Sergey Senozhatsky <senozhatsky@chromium.org>
    wifi: ath11k: clear initialized flag for deinit-ed srng lists

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iwlwifi: Add missing check for alloc_ordered_workqueue

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: iwlwifi: Fix memory leak in iwl_mvm_init()

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: rtl818x: Kill URBs before clearing tx status queue

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size, again

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix psock incorrectly pointing to sk

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed

Steven Rostedt <rostedt@goodmis.org>
    selftests/tracing: Fix false failure of subsystem event test

Alok Tiwari <alok.a.tiwari@oracle.com>
    staging: nvec: Fix incorrect null termination of battery manufacturer

Brahmajit Das <listout@listout.xyz>
    samples: mei: Fix building on musl libc

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Init policy->rwsem before it may be possibly used

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Initialize cpufreq-based frequency-invariance later

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode

Lifeng Zheng <zhenglifeng1@huawei.com>
    PM / devfreq: Check governor before using governor->name

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Fix HS400 USDHC clock speed

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed

Annette Kobou <annette.kobou@kontron.de>
    ARM: dts: imx6ul-kontron-bl-common: Fix RTS polarity for RS485 interface

Albin Törnqvist <albin.tornqvist@codiax.se>
    arm: dts: ti: omap: Fixup pinheader typo

Lucas De Marchi <lucas.demarchi@intel.com>
    usb: early: xhci-dbc: Fix early_ioremap leak

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "vmci: Prevent the dispatching of uninitialized payloads"

Denis OSTERLAND-HEIM <denis.osterland@diehl.com>
    pps: fix poll support

Lizhi Xu <lizhi.xu@windriver.com>
    vmci: Prevent the dispatching of uninitialized payloads

Abdun Nihaal <abdun.nihaal@gmail.com>
    staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()

Charalampos Mitrodimas <charmitro@posteo.net>
    usb: misc: apple-mfi-fastcharge: Make power supply names unique

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: vfxxx: Correctly use two tuples for timer address

Dmitry Vyukov <dvyukov@google.com>
    selftests: Fix errno checking in syscall_user_dispatch test

Arnd Bergmann <arnd@arndb.de>
    ASoC: ops: dynamically allocate struct snd_ctl_elem_value

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    Revert "fs/ntfs3: Replace inode_trylock with inode_lock"

Yangtao Li <frank.li@vivo.com>
    hfsplus: remove mutex_lock check in hfsplus_free_extents

RubenKelevra <rubenkelevra@gmail.com>
    fs_context: fix parameter name in infofc() macro

Arnd Bergmann <arnd@arndb.de>
    ASoC: Intel: fix SND_SOC_SOF dependencies

Arnd Bergmann <arnd@arndb.de>
    ethernet: intel: fix building with large NR_CPUS

Xu Yang <xu.yang_2@nxp.com>
    usb: phy: mxs: disconnect line when USB charger is attached

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: add USB PHY event

Daniel Dadap <ddadap@nvidia.com>
    ALSA: hda: Add missing NVIDIA HDA codec IDs

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_test: Fix possible deletion of uninitialized timers

Dmitry Antipov <dmantipov@yandex.ru>
    jfs: reject on-disk inodes of an unsupported type

Michael Zhivich <mzhivich@akamai.com>
    x86/bugs: Fix use of possibly uninit value in amd_check_tsa_microcode()

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow switching to mode accessory to mux properly

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow to use sink in accessory mode

Harry Yoo <harry.yoo@oracle.com>
    mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid file types when reading inodes

Praveen Kaligineedi <pkaligineedi@google.com>
    gve: Fix stuck TX queue for DQ queue format

Jacek Kowalski <jacek@jacekk.info>
    e1000e: ignore uninitialized checksum word on tgp

Jacek Kowalski <jacek@jacekk.info>
    e1000e: disregard NVM checksum on tgp when valid checksum bit is not set

Ma Ke <make24@iscas.ac.cn>
    dpaa2-switch: Fix device reference count leak in MAC endpoint handling

Ma Ke <make24@iscas.ac.cn>
    dpaa2-eth: Fix device reference count leak in MAC endpoint handling

Dawid Rezler <dawidrezler.patches@gmail.com>
    ALSA: hda/realtek - Add mute LED support for HP Pavilion 15-eg0xxx

Ma Ke <make24@iscas.ac.cn>
    bus: fsl-mc: Fix potential double device reference in fsl_mc_get_endpoint()

Viresh Kumar <viresh.kumar@linaro.org>
    i2c: virtio: Avoid hang by using interruptible completion wait

Yang Xiwen <forbidden405@outlook.com>
    i2c: qup: jump out of the loop in case of timeout

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots

Jian Shen <shenjian15@huawei.com>
    net: hns3: fixed vf get max channels bug

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: disable interrupt when ptp init failed

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix concurrent setting vlan filter issue

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class

Kito Xu (veritas501) <hxzene@gmail.com>
    net: appletalk: Fix use-after-free in AARP proxy probe

Dennis Chen <dechen@redhat.com>
    i40e: report VF tx_dropped with tx_errors instead of tx_discards

Yajun Deng <yajun.deng@linux.dev>
    i40e: Add rx_missed_errors for buffer exhaustion

Abdun Nihaal <abdun.nihaal@gmail.com>
    regmap: fix potential memory leak of regmap_bus

Xilin Wu <sophon@radxa.com>
    interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node

Maor Gottlieb <maorg@nvidia.com>
    RDMA/core: Rate limit GID cache warning messages

Alessandro Carminati <acarmina@redhat.com>
    regulator: core: fix NULL dereference on unbind due to stale coupling data

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    Input: gpio-keys - fix a sleep while atomic with PREEMPT_RT

Peter Zijlstra <peterz@infradead.org>
    x86: Pin task-stack in __get_wchan()

Peter Zijlstra <peterz@infradead.org>
    x86: Fix __get_wchan() for !STACKTRACE

Kees Cook <keescook@chromium.org>
    sched: Add wrapper for get_wchan() to keep task blocked

Qi Zheng <zhengqi.arch@bytedance.com>
    x86: Fix get_wchan() to support the ORC unwinder

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix panic when calling skb_linearize

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix kobject cleanup

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl: Do not change CLAMPING bit if ENABLE bit cannot be changed

Alexander Gordeev <agordeev@linux.ibm.com>
    mm/vmalloc: leave lazy MMU mode on PTE mapping error

Arun Raghavan <arun@asymptotic.io>
    ASoC: fsl_sai: Force a software reset when starting in consumer mode

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: dwc3: qcom: Don't leave BCR asserted

Drew Hamilton <drew.hamilton@zetier.com>
    usb: musb: fix gadget state on disconnect

Paul Cercueil <paul@crapouillou.net>
    usb: musb: Add and use inline functions musb_{get,set}_state

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing of delayed work used for post resume purposes

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: fix detection of high tier USB3 devices behind suspended hubs

Al Viro <viro@zeniv.linux.org.uk>
    clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns

Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
    sched: Change nr_uninterruptible type to unsigned long

William Liu <will@willsroot.io>
    net/sched: Return NULL when htb_lookup_leaf encounters an empty rbtree

Joseph Huang <Joseph.Huang@garmin.com>
    net: bridge: Do not offload IGMP/MLD messages

Dong Chenchen <dongchenchen2@huawei.com>
    net: vlan: fix VLAN 0 refcount imbalance of toggling filtering during runtime

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to adjust outgoing MTU

Yue Haibing <yuehaibing@huawei.com>
    ipv6: mcast: Delay put pmc->idev in mld_del_delrec()

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_size when LRO is used

Ben Ben-Ishay <benishay@nvidia.com>
    net/mlx5e: Add support to klm_umr_wqe

Tariq Toukan <tariqt@nvidia.com>
    lib: bitmap: Introduce node-aware alloc API

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: If an unallowed command is received consider it a failure

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: Fix null-ptr-deref in l2cap_sock_resume_cb()

Oliver Neukum <oneukum@suse.com>
    usb: net: sierra: check for no status endpoint

Marius Zachmann <mail@mariuszachmann.de>
    hwmon: (corsair-cpro) Validate the size of the received input buffer

Paolo Abeni <pabeni@redhat.com>
    selftests: net: increase inter-packet timeout in udpgro.sh

Hangbin Liu <liuhangbin@gmail.com>
    selftests: udpgro: report error when receive failed

Yu Kuai <yukuai3@huawei.com>
    nvme: fix misaccounting of nvme-mpath inflight I/O

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix use-after-free in cifs_oplock_break

Sam Shih <sam.shih@mediatek.com>
    pinctrl: mediatek: moore: check if pin_desc is valid before use

Kuniyuki Iwashima <kuniyu@google.com>
    rpl: Fix use-after-free in rpl_do_srh_inline().

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix race condition on qfq_aggregate

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: emaclite: Fix missing pointer increment in aligned_read()

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject %p% format string in bprintf-like helpers

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix initialization of data for instructions that write to subdevice

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix use of uninitialized data in insn_rw_emulate_bits()

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix some signed shift left operations

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fail COMEDI_INSNLIST ioctl if n_insns is too large

Ian Abbott <abbotti@mev.co.uk>
    comedi: das6402: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: das16m1: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: aio_iiro_16: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcl812: Fix bit shift out of bounds

Chen Ni <nichen@iscas.ac.cn>
    iio: adc: stm32-adc: Fix race in installing chained IRQ handler

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Reorder mode_list[] entries

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Fix MAX1363_4X_CHANS/MAX1363_8X_CHANS[]

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Don't disable channels that aren't enabled

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Cleanup resources in stack-order

Maulik Shah <maulik.shah@oss.qualcomm.com>
    pmdomain: governor: Consider CPU latency tolerance from pm_domain_cpu_gov

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Workaround for Errata i2312

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    mmc: sdhci-pci: Quirk for broken command queuing on Intel GLK-based Positivo models

Thomas Fourier <fourier.thomas@gmail.com>
    mmc: bcm2835: Fix dma_unmap_sg() nents value

Nathan Chancellor <nathan@kernel.org>
    memstick: core: Zero initialize id_reg in h_memstick_read_dev_id()

Jan Kara <jack@suse.cz>
    isofs: Verify inode mode when loading from disk

Dan Carpenter <dan.carpenter@linaro.org>
    dmaengine: nbpfaxi: Fix memory corruption in probe()

Yun Lu <luyun@kylinos.cn>
    af_packet: fix soft lockup issue caused by tpacket_snd()

Yun Lu <luyun@kylinos.cn>
    af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()

Nathan Chancellor <nathan@kernel.org>
    phonet/pep: Move call to pn_skb_get_dst_sockaddr() earlier in pep_sock_accept()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add down_write(trace_event_sem) when adding trace event

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: do not bypass hid_hw_raw_request

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure __hid_request reserves the report ID as the first byte

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure the allocated report buffer can contain the reserved report ID

Thomas Fourier <fourier.thomas@gmail.com>
    pch_uart: Fix dma_sync_sg_for_device() nents value

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - set correct controller type for Acer NGR200

Alok Tiwari <alok.a.tiwari@oracle.com>
    thunderbolt: Fix bit masking in tb_dp_port_set_hops()

Clément Le Goffic <clement.legoffic@foss.st.com>
    i2c: stm32: fix the device used for the DMA map

Xinyu Liu <1171169449@qq.com>
    usb: gadget: configfs: Fix OOB read on empty string write

Ryan Mann (NDI) <rmann@ndigital.com>
    USB: serial: ftdi_sio: add support for NDI EMGUIDE GEMINI

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W640

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE910C04 (ECM) composition

Wayne Chang <waynec@nvidia.com>
    phy: tegra: xusb: Fix unbalanced regulator disable in UTMI PHY mode


-------------

Diffstat:

 Documentation/filesystems/f2fs.rst                 |   6 +-
 Documentation/firmware-guide/acpi/i2c-muxes.rst    |   8 +-
 Documentation/memory-barriers.txt                  |  11 +-
 Documentation/networking/mptcp-sysctl.rst          |   2 +
 Makefile                                           |   6 +-
 arch/alpha/include/asm/processor.h                 |   2 +-
 arch/alpha/kernel/process.c                        |   5 +-
 arch/arc/include/asm/processor.h                   |   2 +-
 arch/arc/kernel/stacktrace.c                       |   4 +-
 arch/arm/Makefile                                  |   2 +-
 arch/arm/boot/dts/am335x-boneblack.dts             |   2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi      |   1 -
 arch/arm/boot/dts/vfxxx.dtsi                       |   2 +-
 arch/arm/include/asm/processor.h                   |   2 +-
 arch/arm/kernel/process.c                          |   4 +-
 arch/arm/mach-rockchip/platsmp.c                   |  15 +-
 arch/arm/mach-tegra/reset.c                        |   2 +-
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   2 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   2 +
 arch/arm64/include/asm/acpi.h                      |   2 +-
 arch/arm64/include/asm/processor.h                 |   2 +-
 arch/arm64/kernel/entry.S                          |   6 +
 arch/arm64/kernel/fpsimd.c                         |   4 +-
 arch/arm64/kernel/process.c                        |   4 +-
 arch/arm64/kernel/traps.c                          |   1 +
 arch/arm64/mm/fault.c                              |   1 +
 arch/arm64/mm/ptdump_debugfs.c                     |   3 -
 arch/csky/include/asm/processor.h                  |   2 +-
 arch/csky/kernel/stacktrace.c                      |   5 +-
 arch/h8300/include/asm/processor.h                 |   2 +-
 arch/h8300/kernel/process.c                        |   5 +-
 arch/hexagon/include/asm/processor.h               |   2 +-
 arch/hexagon/kernel/process.c                      |   4 +-
 arch/ia64/include/asm/processor.h                  |   2 +-
 arch/ia64/kernel/process.c                         |   5 +-
 arch/m68k/Kconfig.debug                            |   2 +-
 arch/m68k/include/asm/processor.h                  |   2 +-
 arch/m68k/kernel/early_printk.c                    |  42 +--
 arch/m68k/kernel/head.S                            |  39 ++-
 arch/m68k/kernel/process.c                         |   4 +-
 arch/microblaze/include/asm/processor.h            |   2 +-
 arch/microblaze/kernel/process.c                   |   2 +-
 arch/mips/crypto/chacha-core.S                     |  20 +-
 arch/mips/include/asm/processor.h                  |   2 +-
 arch/mips/include/asm/vpe.h                        |   8 +
 arch/mips/kernel/process.c                         |  24 +-
 arch/mips/mm/tlb-r4k.c                             |  56 +++-
 arch/nds32/include/asm/processor.h                 |   2 +-
 arch/nds32/kernel/process.c                        |   7 +-
 arch/nios2/include/asm/processor.h                 |   2 +-
 arch/nios2/kernel/process.c                        |   5 +-
 arch/openrisc/include/asm/processor.h              |   2 +-
 arch/openrisc/kernel/process.c                     |   2 +-
 arch/parisc/Makefile                               |   2 +-
 arch/parisc/include/asm/processor.h                |   2 +-
 arch/parisc/kernel/process.c                       |   5 +-
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/include/asm/processor.h               |   2 +-
 arch/powerpc/kernel/eeh.c                          |   1 +
 arch/powerpc/kernel/eeh_driver.c                   |  48 ++--
 arch/powerpc/kernel/eeh_pe.c                       |  11 +-
 arch/powerpc/kernel/pci-hotplug.c                  |   3 +
 arch/powerpc/kernel/process.c                      |   9 +-
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c      |   6 +-
 arch/riscv/include/asm/processor.h                 |   2 +-
 arch/riscv/kernel/stacktrace.c                     |  12 +-
 arch/s390/hypfs/hypfs_dbfs.c                       |  19 +-
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/s390/include/asm/timex.h                      |  13 +-
 arch/s390/kernel/process.c                         |   4 +-
 arch/s390/kernel/time.c                            |   2 +-
 arch/s390/mm/dump_pagetables.c                     |   2 -
 arch/sh/Makefile                                   |  10 +-
 arch/sh/boot/compressed/Makefile                   |   4 +-
 arch/sh/boot/romimage/Makefile                     |   4 +-
 arch/sh/include/asm/processor_32.h                 |   2 +-
 arch/sh/kernel/process_32.c                        |   5 +-
 arch/sparc/include/asm/processor_32.h              |   2 +-
 arch/sparc/include/asm/processor_64.h              |   2 +-
 arch/sparc/kernel/process_32.c                     |   5 +-
 arch/sparc/kernel/process_64.c                     |   5 +-
 arch/um/drivers/rtc_user.c                         |   2 +-
 arch/um/include/asm/processor-generic.h            |   2 +-
 arch/um/kernel/process.c                           |   5 +-
 arch/x86/include/asm/processor.h                   |   2 +-
 arch/x86/include/asm/xen/hypercall.h               |   6 +-
 arch/x86/kernel/cpu/amd.c                          |   2 +
 arch/x86/kernel/cpu/bugs.c                         |   5 +-
 arch/x86/kernel/cpu/hygon.c                        |   3 +
 arch/x86/kernel/cpu/mce/amd.c                      |  13 +-
 arch/x86/kernel/process.c                          |  62 ++---
 arch/x86/kvm/vmx/vmx.c                             |   5 +-
 arch/x86/mm/extable.c                              |   5 +-
 arch/xtensa/include/asm/processor.h                |   2 +-
 arch/xtensa/kernel/process.c                       |   5 +-
 block/blk-settings.c                               |   2 +-
 drivers/acpi/acpi_processor.c                      |   2 +-
 drivers/acpi/apei/ghes.c                           |   2 +
 drivers/acpi/prmt.c                                |  26 +-
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/acpi/processor_perflib.c                   |  11 +
 drivers/ata/Kconfig                                |  35 ++-
 drivers/ata/libata-sata.c                          |   5 +
 drivers/ata/libata-scsi.c                          |  20 +-
 drivers/base/power/domain_governor.c               |  18 +-
 drivers/base/power/runtime.c                       |   5 +
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/block/drbd/drbd_receiver.c                 |   6 +-
 drivers/block/sunvdc.c                             |   4 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  19 +-
 drivers/bus/mhi/host/boot.c                        |   8 +-
 drivers/bus/mhi/host/internal.h                    |   4 +-
 drivers/bus/mhi/host/main.c                        |  15 +-
 drivers/char/hw_random/mtk-rng.c                   |   4 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   8 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |  59 +++--
 drivers/clk/clk-axi-clkgen.c                       |   2 +-
 drivers/clk/davinci/psc.c                          |   5 +
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   3 +-
 drivers/clk/xilinx/xlnx_vcu.c                      |   4 +-
 drivers/comedi/comedi_fops.c                       |  68 ++++-
 drivers/comedi/comedi_internal.h                   |   1 +
 drivers/comedi/drivers.c                           |  47 ++--
 drivers/comedi/drivers/aio_iiro_16.c               |   3 +-
 drivers/comedi/drivers/comedi_test.c               |   2 +-
 drivers/comedi/drivers/das16m1.c                   |   3 +-
 drivers/comedi/drivers/das6402.c                   |   3 +-
 drivers/comedi/drivers/pcl726.c                    |   3 +-
 drivers/comedi/drivers/pcl812.c                    |   3 +-
 drivers/cpufreq/armada-8k-cpufreq.c                |   2 +-
 drivers/cpufreq/cppc_cpufreq.c                     |   2 +-
 drivers/cpufreq/cpufreq.c                          |  29 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 drivers/cpuidle/governors/menu.c                   |  21 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   3 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   8 +-
 drivers/crypto/img-hash.c                          |   2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   8 +-
 drivers/crypto/keembay/keembay-ocs-hcu-core.c      |   8 +-
 drivers/crypto/marvell/cesa/cipher.c               |   4 +-
 drivers/crypto/marvell/cesa/hash.c                 |   5 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |  16 +-
 .../crypto/qat/qat_common/adf_transport_debug.c    |   4 +-
 drivers/devfreq/devfreq.c                          |  10 +-
 drivers/devfreq/governor_userspace.c               |   6 +-
 drivers/dma/mv_xor.c                               |  21 +-
 drivers/dma/nbpfaxi.c                              |  24 +-
 drivers/edac/synopsys_edac.c                       |  93 +++----
 drivers/fpga/zynq-fpga.c                           |  10 +-
 drivers/gpio/gpio-tps65912.c                       |   7 +-
 drivers/gpio/gpio-virtio.c                         |   9 +-
 drivers/gpio/gpio-wcd934x.c                        |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   4 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +
 .../gpu/drm/amd/display/dc/bios/command_table.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   1 -
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    |   2 -
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |  40 +--
 .../amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c   |  31 +--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  11 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   3 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c    |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   6 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |  37 ++-
 drivers/gpu/drm/drm_dp_helper.c                    |   2 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |   4 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   3 +-
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |   9 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |  27 +-
 drivers/gpu/drm/ttm/ttm_pool.c                     |   8 +-
 drivers/gpu/drm/ttm/ttm_resource.c                 |   3 +
 drivers/hid/hid-core.c                             |  21 +-
 drivers/hid/hid-magicmouse.c                       |  51 ++--
 drivers/hwmon/corsair-cpro.c                       |   5 +
 drivers/hwmon/gsc-hwmon.c                          |   4 +-
 drivers/i2c/busses/i2c-qup.c                       |   4 +-
 drivers/i2c/busses/i2c-stm32.c                     |   8 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |   4 +-
 drivers/i2c/busses/i2c-virtio.c                    |  15 +-
 drivers/i2c/i2c-core-acpi.c                        |   1 +
 drivers/i3c/internals.h                            |   1 +
 drivers/i3c/master.c                               |   2 +-
 drivers/idle/intel_idle.c                          |   2 +-
 drivers/iio/adc/ad7768-1.c                         |  23 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   4 +-
 drivers/iio/adc/max1363.c                          |  43 ++-
 drivers/iio/adc/stm32-adc-core.c                   |   7 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |   6 +-
 drivers/iio/light/as73211.c                        |   2 +-
 drivers/iio/light/hid-sensor-prox.c                |   8 +-
 drivers/iio/pressure/bmp280-core.c                 |   9 +-
 drivers/iio/proximity/isl29501.c                   |  14 +-
 drivers/infiniband/core/cache.c                    |   4 +-
 drivers/infiniband/core/nldev.c                    |  22 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   2 +
 drivers/infiniband/hw/hfi1/affinity.c              |  44 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  15 +-
 drivers/infiniband/hw/mlx5/dm.c                    |   2 +-
 drivers/input/joystick/xpad.c                      |   2 +-
 drivers/input/keyboard/gpio_keys.c                 |   4 +-
 drivers/interconnect/qcom/sc7280.c                 |   1 +
 drivers/iommu/amd/init.c                           |   4 +-
 drivers/leds/leds-lp50xx.c                         |  11 +-
 drivers/md/dm-ps-historical-service-time.c         |   4 +-
 drivers/md/dm-ps-queue-length.c                    |   4 +-
 drivers/md/dm-ps-round-robin.c                     |   4 +-
 drivers/md/dm-ps-service-time.c                    |   4 +-
 drivers/md/dm-zoned-target.c                       |   2 +-
 drivers/media/cec/usb/rainshadow/rainshadow-cec.c  |   3 +-
 drivers/media/dvb-frontends/dib7000p.c             |  10 +
 drivers/media/i2c/hi556.c                          |  26 +-
 drivers/media/i2c/ov2659.c                         |   3 +-
 drivers/media/i2c/tc358743.c                       |  86 +++---
 drivers/media/platform/qcom/camss/camss.c          |  10 +-
 drivers/media/platform/qcom/venus/core.c           |  21 +-
 drivers/media/platform/qcom/venus/core.h           |   2 +
 drivers/media/platform/qcom/venus/dbgfs.c          |   9 +
 drivers/media/platform/qcom/venus/dbgfs.h          |  13 +
 drivers/media/platform/qcom/venus/hfi_venus.c      |   5 +
 drivers/media/platform/qcom/venus/vdec.c           |   5 +-
 drivers/media/platform/qcom/venus/venc.c           |   5 +-
 drivers/media/usb/gspca/vicam.c                    |  10 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   6 +
 drivers/media/usb/usbtv/usbtv-video.c              |   4 +
 drivers/media/usb/uvc/uvc_driver.c                 |   3 +
 drivers/media/usb/uvc/uvc_video.c                  |  21 +-
 drivers/media/v4l2-core/v4l2-common.c              |   8 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   9 +-
 drivers/memstick/core/memstick.c                   |   3 +-
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/misc/cardreader/rtsx_usb.c                 |  16 +-
 drivers/mmc/host/bcm2835.c                         |   3 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |   4 +-
 drivers/mmc/host/sdhci-msm.c                       |  14 +
 drivers/mmc/host/sdhci-pci-core.c                  |   3 +-
 drivers/mmc/host/sdhci-pci-gli.c                   |   4 +-
 drivers/mmc/host/sdhci_am654.c                     |   9 +-
 drivers/most/core.c                                |   2 +-
 drivers/mtd/ftl.c                                  |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   6 +
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |  15 ++
 drivers/mtd/nand/spi/core.c                        |   5 +-
 drivers/net/bonding/bond_3ad.c                     |  25 ++
 drivers/net/bonding/bond_options.c                 |   1 +
 drivers/net/can/kvaser_pciefd.c                    |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/dsa/b53/b53_common.c                   |  63 +++--
 drivers/net/dsa/b53/b53_regs.h                     |   2 +
 drivers/net/ethernet/agere/et131x.c                |  36 +++
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   |  39 +++
 drivers/net/ethernet/atheros/ag71xx.c              |   9 +
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   4 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   8 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 -
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  15 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  15 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  14 +-
 drivers/net/ethernet/freescale/fec_main.c          |  34 ++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |   4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |   1 +
 drivers/net/ethernet/google/gve/gve_main.c         |  67 ++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  36 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   3 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   2 +
 drivers/net/ethernet/intel/e1000e/nvm.c            |   6 +
 drivers/net/ethernet/intel/fm10k/fm10k.h           |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  18 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |   1 +
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   2 +-
 drivers/net/hyperv/hyperv_net.h                    |   3 +
 drivers/net/hyperv/netvsc_drv.c                    |  29 +-
 drivers/net/phy/dp83640.c                          |   6 +-
 drivers/net/phy/mscc/mscc.h                        |  12 +
 drivers/net/phy/mscc/mscc_main.c                   |  12 +
 drivers/net/phy/mscc/mscc_ptp.c                    |  50 +++-
 drivers/net/phy/mscc/mscc_ptp.h                    |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +-
 drivers/net/phy/smsc.c                             |   1 +
 drivers/net/ppp/ppp_generic.c                      |  17 +-
 drivers/net/ppp/pptp.c                             |  18 +-
 drivers/net/thunderbolt.c                          |   8 +-
 drivers/net/usb/asix_devices.c                     |   1 +
 drivers/net/usb/sierra_net.c                       |   4 +
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireless/ath/ath11k/hal.c              |  25 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/marvell/mwl8k.c               |   4 +
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  23 +-
 drivers/net/xen-netfront.c                         |   5 -
 drivers/nvme/host/core.c                           |   4 +
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +-
 drivers/pci/controller/vmd.c                       |   3 +
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |   4 +-
 drivers/pci/endpoint/pci-ep-cfs.c                  |   1 +
 drivers/pci/endpoint/pci-epf-core.c                |   2 +-
 drivers/pci/hotplug/pnv_php.c                      | 235 ++++++++++++++--
 drivers/pci/pci-acpi.c                             |   4 +-
 drivers/pci/pci.c                                  |   8 +-
 drivers/pci/probe.c                                |   2 +-
 drivers/phy/tegra/xusb-tegra186.c                  |  61 +++--
 drivers/pinctrl/mediatek/pinctrl-moore.c           |  18 ++
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   1 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |  11 +-
 drivers/platform/chrome/cros_ec.c                  |  23 +-
 drivers/platform/chrome/cros_ec.h                  |   2 +-
 drivers/platform/chrome/cros_ec_i2c.c              |   4 +-
 drivers/platform/chrome/cros_ec_lpc.c              |   4 +-
 drivers/platform/chrome/cros_ec_spi.c              |   4 +-
 drivers/platform/chrome/cros_ec_typec.c            |   4 +-
 drivers/platform/x86/ideapad-laptop.c              |   2 +-
 drivers/platform/x86/think-lmi.c                   |  27 +-
 drivers/platform/x86/thinkpad_acpi.c               |   4 +-
 drivers/power/supply/cpcap-charger.c               |   5 +-
 drivers/power/supply/max14577_charger.c            |   4 +-
 drivers/powercap/intel_rapl_common.c               |  23 +-
 drivers/pps/clients/pps-gpio.c                     |   5 +-
 drivers/pps/pps.c                                  |  11 +-
 drivers/ptp/ptp_private.h                          |   5 +
 drivers/ptp/ptp_vclock.c                           |   7 +
 drivers/pwm/pwm-imx-tpm.c                          |   9 +
 drivers/pwm/pwm-mediatek.c                         |  78 ++++--
 drivers/regulator/core.c                           |   1 +
 drivers/reset/Kconfig                              |  10 +-
 drivers/rtc/rtc-ds1307.c                           |  17 +-
 drivers/rtc/rtc-hym8563.c                          |   2 +-
 drivers/rtc/rtc-pcf85063.c                         |   2 +-
 drivers/rtc/rtc-pcf8563.c                          |   2 +-
 drivers/rtc/rtc-rv3028.c                           |   2 +-
 drivers/scsi/aacraid/comminit.c                    |   3 +-
 drivers/scsi/bfa/bfad_im.c                         |   1 +
 drivers/scsi/ibmvscsi_tgt/libsrp.c                 |   6 +-
 drivers/scsi/isci/request.c                        |   2 +-
 drivers/scsi/libiscsi.c                            |   3 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   1 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |   4 +
 drivers/scsi/mpi3mr/mpi3mr.h                       |   6 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  17 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  22 +-
 drivers/scsi/mvsas/mv_sas.c                        |   4 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/scsi/scsi_transport_sas.c                  |  62 ++++-
 drivers/scsi/ufs/ufs-exynos.c                      |   4 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |  42 ++-
 drivers/scsi/ufs/ufshcd.c                          |  10 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  13 +-
 drivers/soc/qcom/mdt_loader.c                      |  41 +++
 drivers/soc/tegra/pmc.c                            |  51 ++--
 drivers/soundwire/stream.c                         |   2 +-
 drivers/staging/fbtft/fbtft-core.c                 |   1 +
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   2 +-
 drivers/staging/nvec/nvec_power.c                  |   2 +-
 drivers/target/target_core_fabric_lib.c            |  65 +++--
 drivers/target/target_core_internal.h              |   4 +-
 drivers/target/target_core_pr.c                    |  18 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |  43 ++-
 drivers/thermal/thermal_sysfs.c                    |   9 +-
 drivers/thunderbolt/domain.c                       |   2 +-
 drivers/thunderbolt/switch.c                       |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/serial/pch_uart.c                      |   2 +-
 drivers/tty/vt/defkeymap.c_shipped                 | 112 ++++++++
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/usb/atm/cxacru.c                           | 172 ++++++------
 drivers/usb/chipidea/ci.h                          |  18 +-
 drivers/usb/chipidea/udc.c                         |  10 +
 drivers/usb/class/cdc-acm.c                        |  11 +-
 drivers/usb/core/config.c                          |  10 +-
 drivers/usb/core/hcd.c                             |   8 +-
 drivers/usb/core/hub.c                             |  60 ++++-
 drivers/usb/core/hub.h                             |   1 +
 drivers/usb/core/quirks.c                          |   1 +
 drivers/usb/core/urb.c                             |   2 +-
 drivers/usb/dwc3/dwc3-imx8mp.c                     |   6 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   3 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   7 +-
 drivers/usb/dwc3/ep0.c                             |  20 +-
 drivers/usb/dwc3/gadget.c                          |  19 +-
 drivers/usb/early/xhci-dbc.c                       |   4 +
 drivers/usb/gadget/composite.c                     |   5 +
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/gadget/udc/renesas_usb3.c              |   1 +
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-mem.c                        |  24 +-
 drivers/usb/host/xhci-pci-renesas.c                |   7 +-
 drivers/usb/host/xhci-ring.c                       |  19 +-
 drivers/usb/host/xhci.c                            |  24 +-
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/misc/apple-mfi-fastcharge.c            |  24 +-
 drivers/usb/musb/musb_core.c                       |  62 ++---
 drivers/usb/musb/musb_core.h                       |  11 +
 drivers/usb/musb/musb_debugfs.c                    |   6 +-
 drivers/usb/musb/musb_gadget.c                     |  30 ++-
 drivers/usb/musb/musb_host.c                       |   6 +-
 drivers/usb/musb/musb_virthub.c                    |  18 +-
 drivers/usb/musb/omap2430.c                        |  16 +-
 drivers/usb/phy/phy-mxs-usb.c                      |   4 +-
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   3 +
 drivers/usb/serial/option.c                        |   7 +
 drivers/usb/storage/realtek_cr.c                   |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  29 ++
 drivers/usb/typec/mux/intel_pmc_mux.c              |   2 +-
 drivers/usb/typec/tcpm/fusb302.c                   |   8 +
 drivers/usb/typec/tcpm/tcpm.c                      |  64 +++--
 drivers/usb/typec/ucsi/psy.c                       |   2 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   1 +
 drivers/usb/typec/ucsi/ucsi.h                      |   7 +-
 drivers/vhost/scsi.c                               |   4 +-
 drivers/vhost/vhost.c                              |   3 +
 drivers/video/console/vgacon.c                     |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   9 +-
 drivers/video/fbdev/imxfb.c                        |   9 +-
 drivers/watchdog/dw_wdt.c                          |   2 +
 drivers/watchdog/iTCO_wdt.c                        |   6 +-
 drivers/watchdog/sbsa_gwdt.c                       |  50 +++-
 drivers/watchdog/ziirave_wdt.c                     |   3 +
 drivers/xen/gntdev-common.h                        |   4 +
 drivers/xen/gntdev.c                               |  71 +++--
 fs/btrfs/relocation.c                              |  19 ++
 fs/btrfs/tree-log.c                                |  53 ++--
 fs/buffer.c                                        |   2 +-
 fs/cifs/cifssmb.c                                  |  10 +
 fs/cifs/file.c                                     |  10 +-
 fs/cifs/smb2ops.c                                  |   7 +-
 fs/cifs/smbdirect.c                                |  14 +-
 fs/eventpoll.c                                     |  60 ++++-
 fs/ext2/inode.c                                    |  12 +-
 fs/ext4/fsmap.c                                    |  23 +-
 fs/ext4/indirect.c                                 |   4 +-
 fs/ext4/inline.c                                   |  19 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |  35 ++-
 fs/ext4/orphan.c                                   |   5 +-
 fs/ext4/super.c                                    |   2 +
 fs/f2fs/extent_cache.c                             |   2 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/inode.c                                    |  28 +-
 fs/f2fs/node.c                                     |  10 +
 fs/file.c                                          |  15 ++
 fs/hfs/bnode.c                                     |  93 +++++++
 fs/hfsplus/bnode.c                                 |  92 +++++++
 fs/hfsplus/extents.c                               |   3 -
 fs/hfsplus/unicode.c                               |   7 +
 fs/hfsplus/xattr.c                                 |   6 +-
 fs/hugetlbfs/inode.c                               |   2 +-
 fs/isofs/inode.c                                   |   9 +-
 fs/jbd2/checkpoint.c                               |   1 +
 fs/jfs/file.c                                      |   3 +
 fs/jfs/inode.c                                     |   2 +-
 fs/jfs/jfs_dmap.c                                  |  10 +-
 fs/jfs/jfs_imap.c                                  |  13 +-
 fs/ksmbd/smb2pdu.c                                 |  16 +-
 fs/ksmbd/smb_common.c                              |   2 +-
 fs/ksmbd/transport_rdma.c                          |  97 +++----
 fs/libfs.c                                         |   4 +-
 fs/namespace.c                                     |  39 ++-
 fs/nfs/blocklayout/blocklayout.c                   |   4 +-
 fs/nfs/blocklayout/dev.c                           |   5 +-
 fs/nfs/blocklayout/extent_tree.c                   |  20 +-
 fs/nfs/client.c                                    |  44 ++-
 fs/nfs/export.c                                    |  11 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  26 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/internal.h                                  |  10 +-
 fs/nfs/nfs4client.c                                |  15 +-
 fs/nfs/nfs4proc.c                                  |  12 +-
 fs/nfs/pnfs.c                                      |  11 +-
 fs/nfsd/nfs4state.c                                |  34 ++-
 fs/nilfs2/inode.c                                  |   9 +-
 fs/ntfs3/dir.c                                     |   3 +
 fs/ntfs3/file.c                                    |   5 +-
 fs/ntfs3/inode.c                                   |  31 ++-
 fs/orangefs/orangefs-debugfs.c                     |   8 +-
 fs/squashfs/super.c                                |  14 +-
 fs/udf/super.c                                     |  13 +-
 include/asm-generic/barrier.h                      |  33 +++
 include/linux/bitmap.h                             |   2 +
 include/linux/blk_types.h                          |   8 +-
 include/linux/compiler.h                           |   8 -
 include/linux/cpuset.h                             |  17 ++
 include/linux/fs.h                                 |   4 +-
 include/linux/fs_context.h                         |   2 +-
 include/linux/if_vlan.h                            |   6 +-
 include/linux/memfd.h                              |  14 +
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mm.h                                 |  76 ++++--
 include/linux/mmzone.h                             |  22 ++
 include/linux/moduleparam.h                        |   5 +-
 include/linux/pci.h                                |  10 +-
 include/linux/platform_data/cros_ec_proto.h        |   4 +
 include/linux/pps_kernel.h                         |   1 +
 include/linux/sched.h                              |   1 +
 include/linux/skbuff.h                             |  31 ++-
 include/linux/usb/usbnet.h                         |   1 +
 include/linux/xarray.h                             |  15 ++
 include/net/bond_3ad.h                             |   1 +
 include/net/cfg80211.h                             |   2 +-
 include/net/mac80211.h                             |   2 +
 include/net/tc_act/tc_ctinfo.h                     |   6 +-
 include/net/udp.h                                  |  24 +-
 include/sound/soc-dai.h                            |  13 +
 include/uapi/linux/in6.h                           |   4 +-
 include/uapi/linux/io_uring.h                      |   2 +-
 kernel/bpf/helpers.c                               |  11 +-
 kernel/cgroup/cpuset.c                             |  23 ++
 kernel/events/core.c                               |  20 +-
 kernel/fork.c                                      |   2 +-
 kernel/power/console.c                             |   7 +-
 kernel/rcu/tree_plugin.h                           |   3 +
 kernel/sched/core.c                                |  19 ++
 kernel/sched/deadline.c                            |   4 +-
 kernel/sched/loadavg.c                             |   2 +-
 kernel/sched/rt.c                                  |   6 +
 kernel/sched/sched.h                               |   2 +-
 kernel/trace/ftrace.c                              |  19 +-
 kernel/trace/preemptirq_delay_test.c               |  13 +-
 kernel/trace/trace.c                               |  33 ++-
 kernel/trace/trace.h                               |   8 +-
 kernel/trace/trace_events.c                        |   5 +
 kernel/ucount.c                                    |   2 +-
 lib/bitmap.c                                       |  13 +
 mm/debug_vm_pgtable.c                              |   9 +-
 mm/filemap.c                                       |   2 +-
 mm/hmm.c                                           |   2 +-
 mm/kmemleak.c                                      |  10 +-
 mm/madvise.c                                       |   2 +-
 mm/memfd.c                                         |   2 +-
 mm/memory-failure.c                                |   8 +
 mm/mmap.c                                          |  10 +-
 mm/page_alloc.c                                    |  13 +
 mm/ptdump.c                                        |   2 +
 mm/shmem.c                                         |   2 +-
 mm/vmalloc.c                                       |  17 +-
 mm/zsmalloc.c                                      |   3 +
 net/8021q/vlan.c                                   |  42 ++-
 net/8021q/vlan.h                                   |   1 +
 net/appletalk/aarp.c                               |  24 +-
 net/bluetooth/l2cap_core.c                         |  26 +-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bluetooth/smp.c                                |  21 +-
 net/bluetooth/smp.h                                |   1 +
 net/bridge/br_multicast.c                          |  16 ++
 net/bridge/br_private.h                            |   2 +
 net/bridge/br_switchdev.c                          |   3 +
 net/caif/cfctrl.c                                  | 294 ++++++++++-----------
 net/core/filter.c                                  |   3 +
 net/core/netpoll.c                                 |   7 +
 net/core/skmsg.c                                   |  57 ++--
 net/hsr/hsr_slave.c                                |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   6 +-
 net/ipv4/route.c                                   |   1 -
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/udp_offload.c                             |   2 +-
 net/ipv6/addrconf.c                                |   7 +-
 net/ipv6/ip6_offload.c                             |   4 +-
 net/ipv6/mcast.c                                   |  13 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   5 +-
 net/ipv6/rpl_iptunnel.c                            |   8 +-
 net/ipv6/seg6_hmac.c                               |   6 +-
 net/mac80211/cfg.c                                 |  13 +-
 net/mac80211/mlme.c                                |   9 +-
 net/mac80211/tx.c                                  |  10 +-
 net/mctp/af_mctp.c                                 |  28 +-
 net/mptcp/options.c                                |   7 +-
 net/mptcp/pm_netlink.c                             |  14 +-
 net/mptcp/protocol.c                               |  17 +-
 net/mptcp/protocol.h                               |  11 +-
 net/mptcp/subflow.c                                |  20 +-
 net/ncsi/internal.h                                |   2 +-
 net/ncsi/ncsi-rsp.c                                |   1 +
 net/netfilter/nf_conntrack_netlink.c               |  24 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/xt_nfacct.c                          |   4 +-
 net/netlink/af_netlink.c                           |   2 +-
 net/packet/af_packet.c                             |  39 ++-
 net/phonet/pep.c                                   |   2 +-
 net/sched/act_ctinfo.c                             |  19 +-
 net/sched/sch_cake.c                               |  14 +-
 net/sched/sch_codel.c                              |   5 +-
 net/sched/sch_drr.c                                |   7 +-
 net/sched/sch_ets.c                                |  46 ++--
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_hfsc.c                               |   8 +-
 net/sched/sch_htb.c                                |  19 +-
 net/sched/sch_netem.c                              |  40 +++
 net/sched/sch_qfq.c                                |  40 ++-
 net/sctp/input.c                                   |   2 +-
 net/tls/tls_sw.c                                   |  13 +
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/wireless/mlme.c                                |   3 +-
 samples/mei/mei-amt-version.c                      |   2 +-
 scripts/kconfig/gconf.c                            |   8 +-
 scripts/kconfig/lxdialog/inputbox.c                |   6 +-
 scripts/kconfig/lxdialog/menubox.c                 |   2 +-
 scripts/kconfig/nconf.c                            |   2 +
 scripts/kconfig/nconf.gui.c                        |   1 +
 scripts/kconfig/qconf.cc                           |   2 +-
 security/apparmor/include/match.h                  |   3 +-
 security/apparmor/match.c                          |   1 +
 security/inode.c                                   |   2 -
 sound/core/pcm_native.c                            |  19 +-
 sound/pci/hda/patch_ca0132.c                       |   7 +-
 sound/pci/hda/patch_hdmi.c                         |  19 ++
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/pci/intel8x0.c                               |   2 +-
 sound/soc/codecs/hdac_hdmi.c                       |  10 +-
 sound/soc/codecs/rt5640.c                          |   5 +
 sound/soc/fsl/fsl_sai.c                            |  30 ++-
 sound/soc/generic/audio-graph-card.c               |   2 +-
 sound/soc/intel/boards/Kconfig                     |   2 +-
 sound/soc/soc-core.c                               |  28 ++
 sound/soc/soc-dai.c                                |  59 +++--
 sound/soc/soc-dapm.c                               |   4 +
 sound/soc/soc-ops.c                                |  28 +-
 sound/usb/mixer_quirks.c                           |  14 +-
 sound/usb/mixer_scarlett_gen2.c                    |   8 +
 sound/usb/stream.c                                 |  25 +-
 sound/usb/validate.c                               |  14 +-
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 tools/bpf/bpftool/net.c                            |  15 +-
 tools/include/linux/sched/mm.h                     |   2 +
 tools/include/nolibc/std.h                         |   4 +-
 tools/perf/builtin-sched.c                         |  12 +
 tools/perf/tests/bp_account.c                      |   1 +
 tools/perf/util/evsel.c                            |  11 +
 tools/perf/util/evsel.h                            |   2 +
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |   4 +-
 tools/testing/ktest/ktest.pl                       |   5 +-
 .../ftrace/test.d/event/subsystem-enable.tc        |  28 +-
 .../ftrace/test.d/ftrace/func-filter-glob.tc       |   2 +-
 tools/testing/selftests/futex/include/futextest.h  |  11 +
 tools/testing/selftests/memfd/memfd_test.c         |  43 +++
 tools/testing/selftests/net/mptcp/Makefile         |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  28 +-
 .../selftests/net/mptcp/mptcp_connect_checksum.sh  |   5 +
 .../selftests/net/mptcp/mptcp_connect_mmap.sh      |   5 +
 .../selftests/net/mptcp/mptcp_connect_sendfile.sh  |   5 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   1 +
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   1 +
 tools/testing/selftests/net/rtnetlink.sh           |   6 +
 tools/testing/selftests/net/udpgro.sh              |  46 ++--
 tools/testing/selftests/perf_events/.gitignore     |   1 +
 tools/testing/selftests/perf_events/Makefile       |   2 +-
 tools/testing/selftests/perf_events/mmap.c         | 236 +++++++++++++++++
 .../selftests/syscall_user_dispatch/sud_test.c     |  50 ++--
 677 files changed, 6081 insertions(+), 2515 deletions(-)


