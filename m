Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA75350A13;
	Wed, 22 Oct 2025 08:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761121173; cv=none; b=jK8yE/f1PoQ8v1gItkeRbatJDkP7l1fabrfcKCYhJA2ghqOFNHf8Hhx711gL6iFsOWNTsMkASo4VEfD+O5y4xu2X+wT9s9hpaleI02RE/n5ownxOEFIe6x9LYymzY41Hr2Pfl1RBPEIAWo9W1Q9D9MzEYBNA0N5Ok8Ja0G5L6nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761121173; c=relaxed/simple;
	bh=Cx9xNLDh14KweEK8tb2XevWWBccuFkSk+AAuABeNAOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lNlOTxBM9C1TAsAq1vnSdqm2g3SbMambhznJmo9/74YiioFOX65xsy+1X1/ClZF738MxwqS8WZ0f6849nLHJZ8DhD0EboEyVB/SCuWq+HjwlgWILfeqZNVKebGJSHEBtvOnjCNajYuQ6d4pngl9Wrc5nNMH3siiw5zTClmLw9Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJqmujKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJqmujKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01392C4CEE7;
	Wed, 22 Oct 2025 08:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761121172;
	bh=Cx9xNLDh14KweEK8tb2XevWWBccuFkSk+AAuABeNAOw=;
	h=From:To:Cc:Subject:Date:From;
	b=vJqmujKroe1fPv79DY8MfVt4Li7vRFYopJLS3P+Ie6TPFO5knJ6M0Vokr2AY+3/ge
	 gIPN+9Ivn/WCjCZZEwa4LWY1774Q7F4nxgMTMwvHY5dfN1u7N97FtzDle3rOeq/TUT
	 3G2utMCe92EkGkWP1qHhec9CgDotQuMDJYvI3SKg=
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
Subject: [PATCH 6.12 000/135] 6.12.55-rc2 review
Date: Wed, 22 Oct 2025 10:19:29 +0200
Message-ID: <20251022060141.370358070@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.55-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.55-rc2
X-KernelTest-Deadline: 2025-10-24T06:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.55 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Oct 2025 06:01:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.55-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.55-rc2

Guenter Roeck <linux@roeck-us.net>
    dmaengine: Add missing cleanup on module unload

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Apply workarounds for Neoverse-V3AE

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3AE definitions

Jakub Acs <acsjakub@amazon.de>
    mm/ksm: fix flag-dropping behavior in ksm_madvise

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Define a proc_layoutcommit for the FlexFiles layout type

Devarsh Thakkar <devarsht@ti.com>
    phy: cadence: cdns-dphy: Update calibration wait time for startup state machine

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: reset blackhole on success with non-loopback ifaces

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Use __sk_dst_get() and dst_dev_rcu() in mptcp_active_enable().

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Call dst_release() in mptcp_active_enable().

Sharath Chandra Vurukala <quic_sharathv@quicinc.com>
    net: Add locking to protect skb->dev access in ip_output

Eric Dumazet <edumazet@google.com>
    ipv4: adopt dst_dev, skb_dst_dev and skb_dst_dev_net[_rcu]

Eric Dumazet <edumazet@google.com>
    net: dst: add four helpers to annotate data-races around dst->dev

Eric Dumazet <edumazet@google.com>
    tcp: cache RTAX_QUICKACK metric in a hot cache line

Eric Dumazet <edumazet@google.com>
    tcp: convert to dev_net_rcu()

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix mailbox API compatibility by negotiating supported features

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix getting link speed data for E610 devices

Piotr Kwapulinski <piotr.kwapulinski@intel.com>
    ixgbevf: Add support for Intel(R) E610 device

Piotr Kwapulinski <piotr.kwapulinski@intel.com>
    PCI: Add PCI_VDEVICE_SUB helper macro

Jan Kara <jack@suse.cz>
    vfs: Don't leak disconnected dentries on umount

Al Viro <viro@zeniv.linux.org.uk>
    d_alloc_parallel(): set DCACHE_PAR_LOOKUP earlier

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix miscount of bandwidth event when reactivating previously unavailable RMID

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Refactor resctrl_arch_rmid_read()

Yu Kuai <yukuai3@huawei.com>
    md: fix mssing blktrace bio split events

John Garry <john.g.garry@oracle.com>
    md/raid10: Handle bio_split() errors

John Garry <john.g.garry@oracle.com>
    md/raid1: Handle bio_split() errors

John Garry <john.g.garry@oracle.com>
    md/raid0: Handle bio_split() errors

Xiao Liang <shaw.leon@gmail.com>
    padata: Reset next CPU when reorder sequence wraps around

Darrick J. Wong <djwong@kernel.org>
    xfs: use deferred intent items for reaping crosslinked blocks

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: avoid possible TX wait initialization race

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Fix last write offset handling in layoutcommit

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Implement large extent array support in pNFS

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Minor cleanup in layoutcommit processing

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Rework encoding and decoding of nfsd4_deviceid

Sergey Bashirov <sergeybashirov@gmail.com>
    nfsd: Drop dprintk in blocklayout xdr functions

Sergey Bashirov <sergeybashirov@gmail.com>
    nfsd: Use correct error code when decoding extents

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Simplify pm_runtime setup

Bence Csókás <csokas.bence@prolan.hu>
    PM: runtime: Add new devm functions

Devarsh Thakkar <devarsht@ti.com>
    phy: cadence: cdns-dphy: Fix PLL lock and O_CMN_READY polling

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    phy: cdns-dphy: Store hs_clk_rate and return it

Christoph Hellwig <hch@lst.de>
    xfs: fix log CRC mismatches between i386 and other architectures

Christoph Hellwig <hch@lst.de>
    xfs: rename the old_crc variable in xlog_recover_process

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_strcasecmp()

Wilfred Mallawa <wilfred.mallawa@wdc.com>
    nvme/tcp: handle tls partially sent records in write_space()

Xing Guo <higuoxing@gmail.com>
    selftests: arg_parsing: Ensure data is flushed to disk before reading.

Li Qiang <liqiang01@kylinos.cn>
    ASoC: amd/sdw_utils: avoid NULL deref when devm_kasprintf() fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    HID: multitouch: fix name of Stylus input devices

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: only ignore 0 battery events for digitizers

Jiaming Zhang <r772577952@gmail.com>
    ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: make arg_parsing.c more robust to crashes

Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
    accel/qaic: Synchronize access to DBC request queue head & tail pointer

Youssef Samir <quic_yabdulra@quicinc.com>
    accel/qaic: Treat remaining == 0 as error in find_and_map_user_pages()

Jeffrey Hugo <quic_jhugo@quicinc.com>
    accel/qaic: Fix bootlog initialization ordering

Randy Dunlap <rdunlap@infradead.org>
    ALSA: firewire: amdtp-stream: fix enum kernel-doc warnings

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix pelt lost idle time detection

Alok Tiwari <alok.a.tiwari@oracle.com>
    drm/rockchip: vop2: use correct destination rectangle height check

Francesco Valla <francesco@valla.it>
    drm/draw: fix color truncation in drm_draw_fill24

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/powerplay: Fix CIK shutdown temperature

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix handling of harvesting for ip_discovery firmware

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add support for cyan skillfish without IP discovery

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add ip offset support for cyan skillfish

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

Ketil Johnsen <ketil.johnsen@arm.com>
    drm/panthor: Ensure MCU is disabled on suspend

I Viswanath <viswanathiyyappan@gmail.com>
    net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: Add error handling to lan78xx_init_mac_address

Breno Leitao <leitao@debian.org>
    netdevsim: set the carrier when the device goes up

Sabrina Dubroca <sd@queasysnail.net>
    tls: don't rely on tx_work during send()

Sabrina Dubroca <sd@queasysnail.net>
    tls: wait for pending async decryptions if tls_strp_msg_hold fails

Sabrina Dubroca <sd@queasysnail.net>
    tls: always set record_type in tls_process_cmsg

Sabrina Dubroca <sd@queasysnail.net>
    tls: wait for async encrypt in case of error during latter iterations of sendmsg

Sabrina Dubroca <sd@queasysnail.net>
    tls: trim encrypted message to match the plaintext on short splice

Alexey Simakov <bigalex934@gmail.com>
    tg3: prevent use of uninitialized remote_adv and local_adv variables

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: fix recursive locking in RPC handle list access

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
    can: m_can: fix CAN state in system PM

Sean Nyekjaer <sean@geanix.com>
    can: m_can: call deinit/init callback when going into suspend/resume

Sean Nyekjaer <sean@geanix.com>
    can: m_can: add deinit callback

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_chip_config(): bring up interface in correct state

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_handle_state_errors(): fix CAN state transition to Error Active

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_plat_remove(): add missing pm_runtime_disable()

Yuezhang Mo <Yuezhang.Mo@sony.com>
    dax: skip read lock assertion for read-only filesystems

Benjamin Tissoires <bentiss@kernel.org>
    HID: multitouch: fix sticky fingers

Jens Axboe <axboe@kernel.dk>
    Revert "io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: CPPC: Avoid using CPUFREQ_ETERNAL as transition delay

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ecm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_acm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ncm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: Introduce free_usb_request helper

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: Store endpoint pointer in usb_request

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: remove ctx->suspended

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: properly clear channels during bind

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: fix uninitialized crtc reference in functions

Guoniu Zhou <guoniu.zhou@nxp.com>
    media: nxp: imx8-isi: m2m: Fix streaming cleanup on release

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: nxp: imx8-isi: Drop unused argument to mxc_isi_channel_chain()

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix PDC sleep sequence

Miaoqian Lin <linmq006@gmail.com>
    cdx: Fix device node reference leak in cdx_msi_domain_init

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    irqdomain: cdx: Switch to of_fwnode_handle()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Check whether secure display TA loaded successfully

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix MMAP2 event device with backing files

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix MMAP event path names with backing files

Adrian Hunter <adrian.hunter@intel.com>
    perf/core: Fix address filter match with backing files

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdgpu: fix gfx12 mes packet status return check

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

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix memory leaks when rejecting a non SINGLE data profile without an RST

Boris Burkov <boris@bur.io>
    btrfs: fix incorrect readahead expansion length

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix memory leak on duplicated memory in the qgroup assign ioctl

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

Hao Ge <gehao@kylinos.cn>
    slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL

Shuhao Fu <sfual@cse.ust.hk>
    smb: client: Fix refcount leak for cifs_sb_tlink

Conor Dooley <conor.dooley@microchip.com>
    rust: cfi: only 64-bit arm and x86 support CFI_CLANG

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/guc: Check GuC running state before deregistering exec queue


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst        |   2 +
 Documentation/networking/seg6-sysctl.rst           |   3 +
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   1 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/arm64/kvm/arm.c                               |   6 +
 arch/riscv/kernel/probes/kprobes.c                 |  13 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  46 +++--
 drivers/accel/qaic/qaic.h                          |   2 +
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/accel/qaic/qaic_data.c                     |  12 +-
 drivers/accel/qaic/qaic_debugfs.c                  |   5 +-
 drivers/accel/qaic/qaic_drv.c                      |   3 +
 drivers/base/power/runtime.c                       |  44 ++++
 drivers/cdx/cdx_msi.c                              |   5 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  14 +-
 drivers/dma/idxd/init.c                            |   2 +
 drivers/gpu/drm/amd/amdgpu/Makefile                |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  48 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 .../gpu/drm/amd/amdgpu/cyan_skillfish_reg_init.c   |  56 +++++
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   7 +-
 drivers/gpu/drm/amd/amdgpu/nv.h                    |   1 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   3 +-
 drivers/gpu/drm/bridge/lontium-lt9211.c            |   3 +-
 drivers/gpu/drm/drm_draw.c                         |   2 +-
 drivers/gpu/drm/drm_draw_internal.h                |   2 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  98 ++++-----
 drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c          |   9 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  28 ++-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   6 +
 drivers/gpu/drm/panthor/panthor_fw.c               |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
 drivers/gpu/drm/scheduler/sched_main.c             |  13 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |  13 +-
 drivers/hid/hid-input.c                            |   5 +-
 drivers/hid/hid-multitouch.c                       |  28 +--
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |  35 ++--
 drivers/md/md-linear.c                             |   1 +
 drivers/md/raid0.c                                 |  16 ++
 drivers/md/raid1.c                                 |  37 +++-
 drivers/md/raid10.c                                |  55 ++++-
 drivers/md/raid5.c                                 |   2 +
 .../media/platform/nxp/imx8-isi/imx8-isi-core.h    |   2 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c  |   2 +-
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c | 225 +++++++++------------
 .../media/platform/nxp/imx8-isi/imx8-isi-pipe.c    |   2 +-
 drivers/net/can/m_can/m_can.c                      |  86 +++++---
 drivers/net/can/m_can/m_can.h                      |   1 +
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
 drivers/net/netdevsim/netdev.c                     |   7 +
 drivers/net/usb/lan78xx.c                          |  38 +++-
 drivers/net/usb/r8152.c                            |   7 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  39 ++--
 drivers/net/wireless/realtek/rtw89/core.h          |   6 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   2 -
 drivers/nvme/host/multipath.c                      |   6 +-
 drivers/nvme/host/tcp.c                            |   3 +
 drivers/phy/cadence/cdns-dphy.c                    | 133 +++++++++---
 drivers/usb/gadget/function/f_acm.c                |  42 ++--
 drivers/usb/gadget/function/f_ecm.c                |  48 ++---
 drivers/usb/gadget/function/f_ncm.c                |  78 +++----
 drivers/usb/gadget/function/f_rndis.c              |  85 ++++----
 drivers/usb/gadget/udc/core.c                      |   3 +
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/free-space-tree.c                         |  15 +-
 fs/btrfs/ioctl.c                                   |   2 +-
 fs/btrfs/relocation.c                              |  13 +-
 fs/btrfs/zoned.c                                   |   2 +-
 fs/dax.c                                           |   2 +-
 fs/dcache.c                                        |  12 +-
 fs/ext4/ext4_jbd2.c                                |  11 +-
 fs/ext4/inode.c                                    |   8 +
 fs/f2fs/data.c                                     |   2 +-
 fs/hfsplus/unicode.c                               |  24 +++
 fs/jbd2/transaction.c                              |  13 +-
 fs/nfsd/blocklayout.c                              |  33 +--
 fs/nfsd/blocklayoutxdr.c                           | 171 ++++++++++------
 fs/nfsd/blocklayoutxdr.h                           |   8 +-
 fs/nfsd/flexfilelayout.c                           |   8 +
 fs/nfsd/flexfilelayoutxdr.c                        |   3 +-
 fs/nfsd/nfs4layouts.c                              |   1 -
 fs/nfsd/nfs4proc.c                                 |  36 ++--
 fs/nfsd/nfs4xdr.c                                  |  25 +--
 fs/nfsd/nfsd.h                                     |   1 +
 fs/nfsd/pnfs.h                                     |   1 +
 fs/nfsd/xdr4.h                                     |  39 +++-
 fs/smb/client/inode.c                              |   6 +-
 fs/smb/client/misc.c                               |  17 ++
 fs/smb/client/smb2ops.c                            |   8 +-
 fs/smb/server/mgmt/user_session.c                  |   7 +-
 fs/smb/server/smb2pdu.c                            |   9 +-
 fs/smb/server/transport_ipc.c                      |  12 ++
 fs/xfs/libxfs/xfs_log_format.h                     |  30 ++-
 fs/xfs/libxfs/xfs_ondisk.h                         |   2 +
 fs/xfs/scrub/reap.c                                |   9 +-
 fs/xfs/xfs_log.c                                   |   8 +-
 fs/xfs/xfs_log_priv.h                              |   4 +-
 fs/xfs/xfs_log_recover.c                           |  34 +++-
 include/linux/mm.h                                 |   2 +-
 include/linux/pci.h                                |  14 ++
 include/linux/pm_runtime.h                         |   4 +
 include/linux/usb/gadget.h                         |  25 +++
 include/net/dst.h                                  |  32 +++
 include/net/inet6_hashtables.h                     |   2 +-
 include/net/inet_connection_sock.h                 |   3 +-
 include/net/inet_hashtables.h                      |   2 +-
 include/net/ip.h                                   |  11 +-
 include/net/ip_tunnels.h                           |  15 ++
 include/net/route.h                                |   2 +-
 io_uring/rw.c                                      |   2 +-
 kernel/events/core.c                               |   8 +-
 kernel/padata.c                                    |   6 +-
 kernel/sched/fair.c                                |  26 +--
 mm/slub.c                                          |   9 +-
 net/core/dst.c                                     |   4 +-
 net/core/sock.c                                    |  14 +-
 net/ipv4/icmp.c                                    |  24 ++-
 net/ipv4/igmp.c                                    |   2 +-
 net/ipv4/ip_fragment.c                             |   2 +-
 net/ipv4/ip_output.c                               |  19 +-
 net/ipv4/ip_tunnel.c                               |  14 --
 net/ipv4/ip_vti.c                                  |   4 +-
 net/ipv4/netfilter.c                               |   4 +-
 net/ipv4/route.c                                   |   8 +-
 net/ipv4/tcp_fastopen.c                            |   4 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/tcp_ipv4.c                                |  12 +-
 net/ipv4/tcp_metrics.c                             |   8 +-
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv4/xfrm4_output.c                            |   2 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/ipv6/tcp_ipv6.c                                |  22 +-
 net/mptcp/ctrl.c                                   |   9 +-
 net/tls/tls_main.c                                 |   7 +-
 net/tls/tls_sw.c                                   |  31 ++-
 rust/bindings/bindings_helper.h                    |   1 +
 sound/firewire/amdtp-stream.h                      |   2 +-
 sound/soc/amd/acp/acp-sdw-sof-mach.c               |   2 +-
 sound/soc/codecs/idt821034.c                       |  12 +-
 sound/soc/codecs/nau8821.c                         |  53 +++--
 sound/usb/card.c                                   |  10 +-
 .../testing/selftests/bpf/prog_tests/arg_parsing.c |  12 +-
 162 files changed, 1911 insertions(+), 959 deletions(-)


