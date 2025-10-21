Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE1C350A04;
	Tue, 21 Oct 2025 19:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076366; cv=none; b=WOtQEX+GUIw3fRcIkjQxsLAaDRlwGwtJE5pR9PR+l8eRv//RyooSQCrqJn+P1YqqjAnKfog9Sr7wd7rPPQOq/IzN/kz5q0AdIZoIxBaAxxWl4SWs+DiIKRIuHzKNvnjRxIh6DpcqUnKcXYQIvZJoTp4jjk2/9SMGorAqoS62Kdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076366; c=relaxed/simple;
	bh=4R0Z5VionK8WPuvsupblYEqRJlv5suqmfU+kH2hiyBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ape5xNRJHJiaTIdG37ksyCn+24VDAlxvlFsxJDhJZw/JtskYTYFljuq8R8bajZbA8epG2WTWD7u2UwYl/DBhIbYd36SsXmnop4Pax9awL10kG8HrWrN76JAZMwDivCnZ988vWoDrzz9iClP6yQUFGAIHB32pbHfE+uWekQ3hvcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyAuzx0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyAuzx0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBB8C4CEF7;
	Tue, 21 Oct 2025 19:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076365;
	bh=4R0Z5VionK8WPuvsupblYEqRJlv5suqmfU+kH2hiyBI=;
	h=From:To:Cc:Subject:Date:From;
	b=tyAuzx0YU0uXTv1a9mCWeGH0G7h7zz2e3/Czv2Vzs6QU2Cs545G9lFtpk/OzUArmZ
	 Vns02YzGfB4iJevx4vp3pXZ9MDrm1XHnB3cQ4S9G2ptW2DrcD95760PoBvH3b7h9og
	 6wPoRgRWy2VY5MrUhADeIjIxkW9oTVVRNVG+9MtY=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.6 000/105] 6.6.114-rc1 review
Date: Tue, 21 Oct 2025 21:50:09 +0200
Message-ID: <20251021195021.492915002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.114-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.114-rc1
X-KernelTest-Deadline: 2025-10-23T19:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.114 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.114-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.114-rc1

Niklas Cassel <cassel@kernel.org>
    PCI: tegra194: Reset BARs when running in PCIe endpoint mode

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Fix programming sequence of "strap" settings

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Enable ACSPCIE Refclk if "ti,syscon-acspcie-proxy-ctrl" exists

Jakub Acs <acsjakub@amazon.de>
    mm/ksm: fix flag-dropping behavior in ksm_madvise

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL

Brian Norris <briannorris@google.com>
    PCI/sysfs: Ensure devices are powered for config reads (part 2)

Scott Mayhew <smayhew@redhat.com>
    nfsd: decouple the xprtsec policy check from check_nfsd_access()

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix mailbox API compatibility by negotiating supported features

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix getting link speed data for E610 devices

Piotr Kwapulinski <piotr.kwapulinski@intel.com>
    ixgbevf: Add support for Intel(R) E610 device

Piotr Kwapulinski <piotr.kwapulinski@intel.com>
    PCI: Add PCI_VDEVICE_SUB helper macro

Devarsh Thakkar <devarsht@ti.com>
    phy: cadence: cdns-dphy: Update calibration wait time for startup state machine

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()

Jan Kara <jack@suse.cz>
    vfs: Don't leak disconnected dentries on umount

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Define a proc_layoutcommit for the FlexFiles layout type

Shashank A P <shashank.ap@samsung.com>
    fs: quota: create dedicated workqueue for quota_release_work

Kemeng Shi <shikemeng@huaweicloud.com>
    quota: remove unneeded return value of register_quota_format

Xiao Liang <shaw.leon@gmail.com>
    padata: Reset next CPU when reorder sequence wraps around

Darrick J. Wong <djwong@kernel.org>
    xfs: use deferred intent items for reaping crosslinked blocks

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: reorganize DMA aligned buffers in structure

Devarsh Thakkar <devarsht@ti.com>
    phy: cadence: cdns-dphy: Fix PLL lock and O_CMN_READY polling

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    phy: cdns-dphy: Store hs_clk_rate and return it

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Simplify pm_runtime setup

Bence Csókás <csokas.bence@prolan.hu>
    PM: runtime: Add new devm functions

Christoph Hellwig <hch@lst.de>
    xfs: fix log CRC mismatches between i386 and other architectures

Christoph Hellwig <hch@lst.de>
    xfs: rename the old_crc variable in xlog_recover_process

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Fix last write offset handling in layoutcommit

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Minor cleanup in layoutcommit processing

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Rework encoding and decoding of nfsd4_deviceid

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()

Darrick J. Wong <djwong@kernel.org>
    block: fix race between set_blocksize and read paths

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Apply workarounds for Neoverse-V3AE

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3AE definitions

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_strcasecmp()

Xing Guo <higuoxing@gmail.com>
    selftests: arg_parsing: Ensure data is flushed to disk before reading.

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    HID: multitouch: fix name of Stylus input devices

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: only ignore 0 battery events for digitizers

Jiaming Zhang <r772577952@gmail.com>
    ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: make arg_parsing.c more robust to crashes

Youssef Samir <quic_yabdulra@quicinc.com>
    accel/qaic: Treat remaining == 0 as error in find_and_map_user_pages()

Randy Dunlap <rdunlap@infradead.org>
    ALSA: firewire: amdtp-stream: fix enum kernel-doc warnings

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix pelt lost idle time detection

Ingo Molnar <mingo@kernel.org>
    sched/balancing: Rename newidle_balance() => sched_balance_newidle()

Alok Tiwari <alok.a.tiwari@oracle.com>
    drm/rockchip: vop2: use correct destination rectangle height check

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/powerplay: Fix CIK shutdown temperature

Zhanjun Dong <zhanjun.dong@intel.com>
    drm/i915/guc: Skip communication warning on reset in progress

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Add DMI quirk to bypass jack debounce circuit

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Generalize helper to clear IRQ status

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Cancel jdet_work before handling jack ejection

Christophe Leroy <christophe.leroy@csgroup.eu>
    ASoC: codecs: Fix gain setting ranges for Renesas IDT821034 codec

Marek Vasut <marek.vasut@mailbox.org>
    drm/bridge: lt9211: Drop check for last nibble of version register

Fabian Vogt <fvogt@suse.de>
    riscv: kprobes: Fix probe address validation

Amit Chaudhary <achaudhary@purestorage.com>
    nvme-multipath: Skip nr_active increments in RETRY disposition

I Viswanath <viswanathiyyappan@gmail.com>
    net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Add error handling to lan78xx_init_mac_address

Sabrina Dubroca <sd@queasysnail.net>
    tls: don't rely on tx_work during send()

Sabrina Dubroca <sd@queasysnail.net>
    tls: wait for pending async decryptions if tls_strp_msg_hold fails

Sabrina Dubroca <sd@queasysnail.net>
    tls: always set record_type in tls_process_cmsg

Sabrina Dubroca <sd@queasysnail.net>
    tls: wait for async encrypt in case of error during latter iterations of sendmsg

Sascha Hauer <s.hauer@pengutronix.de>
    net: tls: wait for async completion on last message

Sabrina Dubroca <sd@queasysnail.net>
    tls: trim encrypted message to match the plaintext on short splice

Alexey Simakov <bigalex934@gmail.com>
    tg3: prevent use of uninitialized remote_adv and local_adv variables

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_tso_should_defer() vs large RTT

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: Avoid spurious link down messages during interface toggle

Dmitry Safonov <0x7f454c46@gmail.com>
    net/ip6_tunnel: Prevent perpetual tunnel growth

Linmao Li <lilinmao@kylinos.cn>
    r8169: fix packet truncation after S4 resume on RTL8168H/RTL8111H

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    doc: fix seg6_flowlabel path

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: handle dma_map_single() failure properly

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_plat_remove(): add missing pm_runtime_disable()

Yuezhang Mo <Yuezhang.Mo@sony.com>
    dax: skip read lock assertion for read-only filesystems

Benjamin Tissoires <bentiss@kernel.org>
    HID: multitouch: fix sticky fingers

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ncm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_acm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ecm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: Introduce free_usb_request helper

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: Store endpoint pointer in usb_request

Guoniu Zhou <guoniu.zhou@nxp.com>
    media: nxp: imx8-isi: m2m: Fix streaming cleanup on release

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: nxp: imx8-isi: Drop unused argument to mxc_isi_channel_chain()

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: remove ctx->suspended

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: properly clear channels during bind

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: fix uninitialized crtc reference in functions

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix PDC sleep sequence

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: De-spaghettify the use of memory barriers

Nam Cao <namcao@linutronix.de>
    eventpoll: Replace rwlock with spinlock

Huang Xiaojia <huangxiaojia2@huawei.com>
    epoll: Remove ep_scan_ready_list() in comments

Zenm Chen <zenmchen@gmail.com>
    Bluetooth: btusb: Add USB ID 2001:332a for D-Link AX9U rev. A1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: CPPC: Avoid using CPUFREQ_ETERNAL as transition delay

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Check whether secure display TA loaded successfully

Gui-Dong Han <hanguidong02@gmail.com>
    drm/amdgpu: use atomic functions with memory barriers for vm fault info

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Fix potential double free in drm_sched_job_add_resv_dependencies

Eugene Korenevsky <ekorenevsky@aliyun.com>
    cifs: parse_dfs_referrals: prevent oob on malformed input

Celeste Liu <uwu@coelacanthus.name>
    can: gs_usb: increase max interface to U8_MAX

Celeste Liu <uwu@coelacanthus.name>
    can: gs_usb: gs_make_candev(): populate net_device->dev_port

Filipe Manana <fdmanana@suse.com>
    btrfs: do not assert we found block group item when creating free space tree

Boris Burkov <boris@bur.io>
    btrfs: fix incorrect readahead expansion length

Filipe Manana <fdmanana@suse.com>
    btrfs: fix clearing of BTRFS_FS_RELOC_RUNNING if relocation already running

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: detect invalid INLINE_DATA + EXTENTS flag combination

Zhang Yi <yi.zhang@huawei.com>
    ext4: wait for ongoing I/O to complete before freeing blocks

Zhang Yi <yi.zhang@huawei.com>
    jbd2: ensure that all ongoing I/O complete before freeing blocks

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix wrong block mapping for multi-devices

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Prevent access to vCPU events before init

Yi Cong <yicong@kylinos.cn>
    r8152: add error handling in rtl8152_driver_init

Shuhao Fu <sfual@cse.ust.hk>
    smb: client: Fix refcount leak for cifs_sb_tlink


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst        |   2 +
 Documentation/networking/seg6-sysctl.rst           |   3 +
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/arm64/kvm/arm.c                               |   6 +
 arch/riscv/kernel/probes/kprobes.c                 |  13 +-
 block/bdev.c                                       |  17 ++
 block/blk-zoned.c                                  |   5 +-
 block/fops.c                                       |  16 ++
 block/ioctl.c                                      |   6 +
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/base/power/runtime.c                       |  44 ++++
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/cpufreq/cppc_cpufreq.c                     |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   7 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   3 +-
 drivers/gpu/drm/bridge/lontium-lt9211.c            |   3 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  98 ++++-----
 drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c          |   9 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  38 ++--
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   6 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  10 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
 drivers/gpu/drm/scheduler/sched_main.c             |  13 +-
 drivers/hid/hid-input.c                            |   5 +-
 drivers/hid/hid-multitouch.c                       |  28 +--
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   8 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |  35 ++--
 .../media/platform/nxp/imx8-isi/imx8-isi-core.h    |   2 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c  |   2 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c | 225 +++++++++------------
 .../media/platform/nxp/imx8-isi/imx8-isi-pipe.c    |   2 +-
 drivers/net/can/m_can/m_can_platform.c             |   2 +-
 drivers/net/can/usb/gs_usb.c                       |  23 +--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   1 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/dlink/dl2k.c                  |  23 ++-
 drivers/net/ethernet/intel/ixgbevf/defines.h       |   6 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |  10 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h       |  13 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  46 ++++-
 drivers/net/ethernet/intel/ixgbevf/mbx.h           |   8 +
 drivers/net/ethernet/intel/ixgbevf/vf.c            | 194 +++++++++++++++---
 drivers/net/ethernet/intel/ixgbevf/vf.h            |   5 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/usb/lan78xx.c                          |  38 +++-
 drivers/net/usb/r8152.c                            |   7 +-
 drivers/nvme/host/multipath.c                      |   6 +-
 drivers/pci/controller/cadence/pci-j721e.c         |  64 +++++-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  10 +
 drivers/pci/pci-sysfs.c                            |  10 +-
 drivers/phy/cadence/cdns-dphy.c                    | 133 +++++++++---
 drivers/usb/gadget/function/f_acm.c                |  42 ++--
 drivers/usb/gadget/function/f_ecm.c                |  48 ++---
 drivers/usb/gadget/function/f_ncm.c                |  78 +++----
 drivers/usb/gadget/function/f_rndis.c              |  85 ++++----
 drivers/usb/gadget/udc/core.c                      |   3 +
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/free-space-tree.c                         |  15 +-
 fs/btrfs/relocation.c                              |  13 +-
 fs/dax.c                                           |   2 +-
 fs/dcache.c                                        |   2 +
 fs/eventpoll.c                                     | 145 +++----------
 fs/ext4/ext4_jbd2.c                                |  11 +-
 fs/ext4/inode.c                                    |   8 +
 fs/ext4/super.c                                    |  17 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/hfsplus/unicode.c                               |  24 +++
 fs/jbd2/transaction.c                              |  13 +-
 fs/nfsd/blocklayout.c                              |   5 +-
 fs/nfsd/blocklayoutxdr.c                           |   7 +-
 fs/nfsd/export.c                                   |  60 +++++-
 fs/nfsd/export.h                                   |   2 +
 fs/nfsd/flexfilelayout.c                           |   8 +
 fs/nfsd/flexfilelayoutxdr.c                        |   3 +-
 fs/nfsd/nfs4layouts.c                              |   1 -
 fs/nfsd/nfs4proc.c                                 |  34 ++--
 fs/nfsd/nfs4xdr.c                                  |  14 +-
 fs/nfsd/nfsfh.c                                    |  12 +-
 fs/nfsd/xdr4.h                                     |  36 +++-
 fs/nilfs2/the_nilfs.c                              |   3 -
 fs/ocfs2/super.c                                   |   6 +-
 fs/quota/dquot.c                                   |  13 +-
 fs/quota/quota_v1.c                                |   3 +-
 fs/quota/quota_v2.c                                |   9 +-
 fs/smb/client/inode.c                              |   6 +-
 fs/smb/client/misc.c                               |  17 ++
 fs/smb/client/smb2ops.c                            |   8 +-
 fs/smb/server/ksmbd_netlink.h                      |   3 +-
 fs/smb/server/server.h                             |   1 +
 fs/smb/server/smb2pdu.c                            |   4 +
 fs/smb/server/transport_ipc.c                      |   1 +
 fs/smb/server/transport_tcp.c                      |  67 +++---
 fs/smb/server/transport_tcp.h                      |   1 +
 fs/xfs/libxfs/xfs_log_format.h                     |  30 ++-
 fs/xfs/scrub/reap.c                                |  19 +-
 fs/xfs/xfs_log.c                                   |   8 +-
 fs/xfs/xfs_log_priv.h                              |   4 +-
 fs/xfs/xfs_log_recover.c                           |  34 +++-
 fs/xfs/xfs_ondisk.h                                |   2 +
 include/linux/cpufreq.h                            |   3 +
 include/linux/mm.h                                 |   2 +-
 include/linux/pci.h                                |  14 ++
 include/linux/pm_runtime.h                         |   4 +
 include/linux/quota.h                              |   2 +-
 include/linux/usb/gadget.h                         |  25 +++
 include/net/ip_tunnels.h                           |  15 ++
 kernel/padata.c                                    |   6 +-
 kernel/sched/fair.c                                |  38 ++--
 mm/shmem.c                                         |   7 +-
 net/ipv4/ip_tunnel.c                               |  14 --
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/tls/tls_main.c                                 |   7 +-
 net/tls/tls_sw.c                                   |  33 ++-
 rust/bindings/bindings_helper.h                    |   2 +
 rust/bindings/lib.rs                               |   1 +
 sound/firewire/amdtp-stream.h                      |   2 +-
 sound/soc/codecs/idt821034.c                       |  12 +-
 sound/soc/codecs/nau8821.c                         |  53 +++--
 sound/usb/card.c                                   |  10 +-
 .../testing/selftests/bpf/prog_tests/arg_parsing.c |  12 +-
 128 files changed, 1549 insertions(+), 924 deletions(-)


