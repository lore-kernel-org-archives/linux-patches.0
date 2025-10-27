Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBDA30C35E;
	Mon, 27 Oct 2025 19:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592164; cv=none; b=MY8VjfifmxWmi4/cH4B59v4LVbxtIv7TLLO8pumcYZqyCwxncCQEw9H+KI4/MyfE4hIleDSIAwmV+z6ZYFRnHui84VvUFaaGmdtZUGauj4g5EviRrtsZKPDWjOlu7mzydsq+FpCDRyoPTgDwKwizekR1vJSHyhft6JwRcr8ZDII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592164; c=relaxed/simple;
	bh=7gsKDH5IdYB+LG9JjhJxYn8yTAa2p3dZLRo+t7bCRA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jdF/Y5isD6kie7amalBp8t8JIibz3SJFlJDJTrM+fGZWEgK3CoJZCh5lmQpEMbQUAU9y4CX3/5uupGuPeE/Va7eOJVNyhXskRIMzn9KhYJPVnqQ7LfmsluVGqSi2lzIDptFvdGxiVZ6aHlk1OzB1Tb2TlyZd495GCdWia75eDiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0OpTnrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0OpTnrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECAFC4CEF1;
	Mon, 27 Oct 2025 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592163;
	bh=7gsKDH5IdYB+LG9JjhJxYn8yTAa2p3dZLRo+t7bCRA4=;
	h=From:To:Cc:Subject:Date:From;
	b=e0OpTnrVwY2EIhVTzP9l7/1+ZdjJNOku5EXPdlT7hartGf6Ah9YU0eytgQvKaXjBY
	 f587wtpTOW/yRrHCVDATJRzMek4nV39nFAiSe1gGE7GTpTtuJtEWgaWwZJP1g5YelQ
	 MegEN/Jp7Vg2pnmXStSVlexP52FQxjOWzmg7fwK8=
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
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.1 000/157] 6.1.158-rc1 review
Date: Mon, 27 Oct 2025 19:34:21 +0100
Message-ID: <20251027183501.227243846@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.158-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.158-rc1
X-KernelTest-Deadline: 2025-10-29T18:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.158 release.
There are 157 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.158-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.158-rc1

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Apply workarounds for Neoverse-V3AE

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3AE definitions

Leon Hwang <leon.hwang@linux.dev>
    Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"

Jakub Acs <acsjakub@amazon.de>
    mm/ksm: fix flag-dropping behavior in ksm_madvise

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Update purge function to unregister the unused subchannels

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix miscount of bandwidth event when reactivating previously unavailable RMID

Maarten Lankhorst <dev@lankhorst.se>
    devcoredump: Fix circular locking dependency with devcd->mutex.

Darrick J. Wong <djwong@kernel.org>
    xfs: always warn about deprecated mount options

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    arch_topology: Fix incorrect error check in topology_parse_cpu_capacity()

Devarsh Thakkar <devarsht@ti.com>
    phy: cadence: cdns-dphy: Update calibration wait time for startup state machine

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix mailbox API compatibility by negotiating supported features

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbevf: fix getting link speed data for E610 devices

Piotr Kwapulinski <piotr.kwapulinski@intel.com>
    ixgbevf: Add support for Intel(R) E610 device

Piotr Kwapulinski <piotr.kwapulinski@intel.com>
    PCI: Add PCI_VDEVICE_SUB helper macro

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix wrong block mapping for multi-devices

Christoph Hellwig <hch@lst.de>
    f2fs: factor a f2fs_map_blocks_cached helper

Christoph Hellwig <hch@lst.de>
    f2fs: remove the create argument to f2fs_map_blocks

Christoph Hellwig <hch@lst.de>
    f2fs: add a f2fs_get_block_locked helper

Niklas Cassel <cassel@kernel.org>
    PCI: tegra194: Reset BARs when running in PCIe endpoint mode

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Fix potential double free in drm_sched_job_add_resv_dependencies

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid potential buffer over-read in parse_apply_sb_mount_options()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Define a proc_layoutcommit for the FlexFiles layout type

Jan Kara <jack@suse.cz>
    vfs: Don't leak disconnected dentries on umount

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Fix last write offset handling in layoutcommit

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Minor cleanup in layoutcommit processing

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD: Rework encoding and decoding of nfsd4_deviceid

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Fix programming sequence of "strap" settings

Siddharth Vadapalli <s-vadapalli@ti.com>
    PCI: j721e: Enable ACSPCIE Refclk if "ti,syscon-acspcie-proxy-ctrl" exists

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not flag the zero page as PG_mte_tagged

Darrick J. Wong <djwong@kernel.org>
    fuse: fix livelock in synchronous file put from fuseblk workers

Amir Goldstein <amir73il@gmail.com>
    fuse: allocate ff->release_args only if release is needed

Xiao Liang <shaw.leon@gmail.com>
    padata: Reset next CPU when reorder sequence wraps around

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended

David Lechner <dlechner@baylibre.com>
    iio: imu: inv_icm42600: use = { } instead of memset()

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

Florian Eckert <fe@dev.tdt.de>
    serial: 8250_exar: add support for Advantech 2 port card with Device ID 0x0018

Artem Shimko <a.shimko.dev@gmail.com>
    serial: 8250_dw: handle reset control deassert error

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: hdm_probe: Fix calling put_device() before device initialization

Victoria Votokina <Victoria.Votokina@kaspersky.com>
    most: usb: Fix use-after-free in hdm_disconnect

Junhao Xie <bigfoot@radxa.com>
    misc: fastrpc: Fix dma_buf object leak in fastrpc_map_lookup

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add wildcat lake P DID

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: fix divide-by-zero in comedi_buf_munge()

Alice Ryhl <aliceryhl@google.com>
    binder: remove "invalid inc weak" check

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: enable back DbC in resume if it was enabled before suspend

Andrey Konovalov <andreyknvl@gmail.com>
    usb: raw-gadget: do not limit transfer length

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    usb/core/quirks: Add Huawei ME906S to wakeup quirk

LI Qingwu <Qing-wu.Li@leica-geosystems.com.cn>
    USB: serial: option: add Telit FN920C04 ECM compositions

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Quectel RG255C

Renjun Wang <renjunw0@foxmail.com>
    USB: serial: option: add UNISOC UIS7720

Alok Tiwari <alok.a.tiwari@oracle.com>
    io_uring: correct __must_hold annotation in io_install_fixed_file

Anup Patel <apatel@ventanamicro.com>
    RISC-V: Don't print details of CPUs disabled in DT

Anup Patel <apatel@ventanamicro.com>
    RISC-V: Define pgprot_dmacoherent() for non-coherent devices

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark implicit tests as skipped if not supported

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'flush re-add' as skipped if not supported

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Ensure memory write completes before ringing TX doorbell

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Enforce descriptor type ordering

Michal Pecio <michal.pecio@gmail.com>
    net: usb: rtl8150: Fix frame padding

Sebastian Reichel <sebastian.reichel@collabora.com>
    net: stmmac: dwmac-rk: Fix disabling set_clock_selection

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix lock inversion in vsock_assign_transport()

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: clear extent cache after moving/defragmenting extents

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix keyboard resource preventing i8042 driver from registering

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: can_changelink(): allow disabling of automatic restart

Xi Ruoyao <xry111@xry111.site>
    ACPICA: Work around bogus -Wstringop-overread warning since GCC 11

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "cpuidle: menu: Avoid discarding useful information"

Tonghao Zhang <tonghao@bamaicloud.com>
    net: bonding: fix possible peer notify event loss or dup issue

Alexey Simakov <bigalex934@gmail.com>
    sctp: avoid NULL dereference when chunk data buffer is missing

Huang Ying <ying.huang@linux.alibaba.com>
    arm64, mm: avoid always making PTE dirty in pte_mkwrite()

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: fix the pointer passed to PTR_ALIGN on Tx path

Wei Fang <wei.fang@nxp.com>
    net: enetc: correct the value of ENETC_RXB_TRUESIZE

Johannes Wiesböck <johannes.wiesboeck@aisec.fraunhofer.de>
    rtnetlink: Allow deleting FDB entries in user namespace

Nathan Chancellor <nathan@kernel.org>
    net/mlx5e: Return 1 instead of 0 in invalid case in mlx5e_mpwrq_umr_entry_size()

Stefan Metzmacher <metze@samba.org>
    smb: server: let smb_direct_flush_send_list() invalidate a remote key first

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Remove PAGE_KERNEL_TEXT to fix startup failure

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: bitops: Fix find_*_bit() signatures

Junjie Cao <junjie.cao@intel.com>
    lkdtm: fortify: Fix potential NULL dereference on kmalloc failure

Yangtao Li <frank.li@vivo.com>
    hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix KMSAN uninit-value issue in hfs_find_set_zero_bits()

Alexander Aring <aahringo@redhat.com>
    dlm: check for defined force value in dlm_lockspace_release

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in hfsplus_delete_cat()

Yang Chenzhi <yang.chenzhi@vivo.com>
    hfs: validate record offset in hfsplus_bmap_alloc

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix KMSAN uninit-value issue in __hfsplus_ext_cache_extent()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: make proper initalization of struct hfs_find_data

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: clear offset and space out of valid records in b-tree node

Simon Schuster <schuster.simon@siemens-energy.com>
    nios2: ensure that memblock.current_limit is set when setting pfn limits

Xichao Zhao <zhao.xichao@vivo.com>
    exec: Fix incorrect type for ret

Brian Norris <briannorris@google.com>
    PCI/sysfs: Ensure devices are powered for config reads (part 2)

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_strcasecmp()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    HID: multitouch: fix name of Stylus input devices

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: only ignore 0 battery events for digitizers

Jiaming Zhang <r772577952@gmail.com>
    ALSA: usb-audio: Fix NULL pointer deference in try_to_register_card

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

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Add DMI quirk to bypass jack debounce circuit

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Generalize helper to clear IRQ status

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Cancel jdet_work before handling jack ejection

Marek Vasut <marek.vasut@mailbox.org>
    drm/bridge: lt9211: Drop check for last nibble of version register

Fabian Vogt <fvogt@suse.de>
    riscv: kprobes: Fix probe address validation

I Viswanath <viswanathiyyappan@gmail.com>
    net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset

Oleksij Rempel <linux@rempel-privat.de>
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

Thomas Gleixner <tglx@linutronix.de>
    Bluetooth: hci_qca: Fix the teardown problem for real

Steven Rostedt (Google) <rostedt@goodmis.org>
    timers: Update the documentation to reflect on the new timer_shutdown() API

Thomas Gleixner <tglx@linutronix.de>
    timers: Provide timer_shutdown[_sync]()

Thomas Gleixner <tglx@linutronix.de>
    timers: Add shutdown mechanism to the internal functions

Thomas Gleixner <tglx@linutronix.de>
    timers: Split [try_to_]del_timer[_sync]() to prepare for shutdown mode

Thomas Gleixner <tglx@linutronix.de>
    timers: Silently ignore timers with a NULL function

Thomas Gleixner <tglx@linutronix.de>
    Documentation: Replace del_timer/del_timer_sync()

Thomas Gleixner <tglx@linutronix.de>
    timers: Replace BUG_ON()s

Steven Rostedt (Google) <rostedt@goodmis.org>
    clocksource/drivers/sp804: Do not use timer namespace for timer_shutdown() function

Steven Rostedt (Google) <rostedt@goodmis.org>
    clocksource/drivers/arm_arch_timer: Do not use timer namespace for timer_shutdown() function

Steven Rostedt (Google) <rostedt@goodmis.org>
    ARM: spear: Do not use timer namespace for timer_shutdown() function

Thomas Gleixner <tglx@linutronix.de>
    Documentation: Remove bogus claim about del_timer_sync()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ncm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_acm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ecm: Refactor bind path to use __free()

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Refactor bind path to use __free()

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

Marek Vasut <marek.vasut+renesas@mailbox.org>
    drm/rcar-du: dsi: Fix 1/2/3 lane support

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: CPPC: Avoid using CPUFREQ_ETERNAL as transition delay

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: rockchip - Fix dma_unmap_sg() nents value

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Check whether secure display TA loaded successfully

Gui-Dong Han <hanguidong02@gmail.com>
    drm/amdgpu: use atomic functions with memory barriers for vm fault info

Eugene Korenevsky <ekorenevsky@aliyun.com>
    cifs: parse_dfs_referrals: prevent oob on malformed input

Filipe Manana <fdmanana@suse.com>
    btrfs: do not assert we found block group item when creating free space tree

Filipe Manana <fdmanana@suse.com>
    btrfs: fix clearing of BTRFS_FS_RELOC_RUNNING if relocation already running

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: detect invalid INLINE_DATA + EXTENTS flag combination

Zhang Yi <yi.zhang@huawei.com>
    ext4: wait for ongoing I/O to complete before freeing blocks

Zhang Yi <yi.zhang@huawei.com>
    jbd2: ensure that all ongoing I/O complete before freeing blocks

Yi Cong <yicong@kylinos.cn>
    r8152: add error handling in rtl8152_driver_init

Shuhao Fu <sfual@cse.ust.hk>
    smb: client: Fix refcount leak for cifs_sb_tlink


-------------

Diffstat:

 .../RCU/Design/Requirements/Requirements.rst       |   2 +-
 Documentation/arm64/silicon-errata.rst             |   2 +
 Documentation/core-api/local_ops.rst               |   2 +-
 Documentation/kernel-hacking/locking.rst           |  17 +-
 Documentation/networking/seg6-sysctl.rst           |   3 +
 Documentation/timers/hrtimers.rst                  |   2 +-
 .../translations/it_IT/kernel-hacking/locking.rst  |  14 +-
 .../translations/zh_CN/core-api/local_ops.rst      |   2 +-
 Makefile                                           |   4 +-
 arch/arm/mach-spear/time.c                         |   8 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/arm64/kernel/cpufeature.c                     |  10 +-
 arch/arm64/kernel/mte.c                            |   2 +-
 arch/m68k/include/asm/bitops.h                     |  25 +-
 arch/mips/mti-malta/malta-setup.c                  |   2 +-
 arch/nios2/kernel/setup.c                          |  15 +
 arch/powerpc/include/asm/pgtable.h                 |  12 -
 arch/powerpc/mm/book3s32/mmu.c                     |   4 +-
 arch/powerpc/mm/pgtable_32.c                       |   2 +-
 arch/riscv/include/asm/pgtable.h                   |   2 +
 arch/riscv/kernel/cpu.c                            |   4 +-
 arch/riscv/kernel/probes/kprobes.c                 |  13 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  12 +-
 drivers/acpi/acpica/tbprint.c                      |   6 +
 drivers/android/binder.c                           |  11 +-
 drivers/base/arch_topology.c                       |   2 +-
 drivers/base/devcoredump.c                         | 138 +++++----
 drivers/base/power/runtime.c                       |  44 +++
 drivers/bluetooth/hci_qca.c                        |  10 +-
 drivers/clocksource/arm_arch_timer.c               |  12 +-
 drivers/clocksource/timer-sp804.c                  |   6 +-
 drivers/comedi/comedi_buf.c                        |   2 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  14 +-
 drivers/cpuidle/governors/menu.c                   |  21 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   7 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   3 +-
 drivers/gpu/drm/bridge/lontium-lt9211.c            |   3 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |  98 +++---
 drivers/gpu/drm/rcar-du/rcar_mipi_dsi.c            |   5 +-
 drivers/gpu/drm/rcar-du/rcar_mipi_dsi_regs.h       |   8 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +-
 drivers/gpu/drm/scheduler/sched_main.c             |  13 +-
 drivers/hid/hid-input.c                            |   5 +-
 drivers/hid/hid-multitouch.c                       |  28 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   5 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |  35 +--
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   5 +-
 drivers/misc/fastrpc.c                             |   2 +
 drivers/misc/lkdtm/fortify.c                       |   6 +
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/most/most_usb.c                            |  13 +-
 drivers/net/bonding/bond_main.c                    |  40 ++-
 drivers/net/can/dev/netlink.c                      |   6 +-
 drivers/net/can/m_can/m_can_platform.c             |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   1 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/dlink/dl2k.c                  |  23 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   2 +-
 drivers/net/ethernet/intel/ixgbevf/defines.h       |   6 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |  10 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h       |  13 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  46 ++-
 drivers/net/ethernet/intel/ixgbevf/mbx.h           |   8 +
 drivers/net/ethernet/intel/ixgbevf/vf.c            | 194 ++++++++++--
 drivers/net/ethernet/intel/ixgbevf/vf.h            |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  24 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   9 +-
 drivers/net/usb/lan78xx.c                          |  38 ++-
 drivers/net/usb/r8152.c                            |   7 +-
 drivers/net/usb/rtl8150.c                          |  11 +-
 drivers/pci/controller/cadence/pci-j721e.c         |  64 +++-
 drivers/pci/controller/dwc/pcie-tegra194.c         |  10 +
 drivers/pci/pci-sysfs.c                            |  10 +-
 drivers/phy/cadence/cdns-dphy.c                    | 133 ++++++--
 drivers/s390/cio/device.c                          |  37 ++-
 drivers/tty/serial/8250/8250_dw.c                  |   4 +-
 drivers/tty/serial/8250/8250_exar.c                |  11 +
 drivers/usb/core/quirks.c                          |   2 +
 drivers/usb/gadget/function/f_acm.c                |  42 ++-
 drivers/usb/gadget/function/f_ecm.c                |  48 ++-
 drivers/usb/gadget/function/f_ncm.c                |  78 ++---
 drivers/usb/gadget/function/f_rndis.c              |  85 +++---
 drivers/usb/gadget/legacy/raw_gadget.c             |   2 -
 drivers/usb/gadget/udc/core.c                      |   3 +
 drivers/usb/host/xhci-dbgcap.c                     |   9 +-
 drivers/usb/serial/option.c                        |  10 +
 fs/btrfs/free-space-tree.c                         |  15 +-
 fs/btrfs/relocation.c                              |  13 +-
 fs/dax.c                                           |   2 +-
 fs/dcache.c                                        |   2 +
 fs/dlm/lockspace.c                                 |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext4/ext4_jbd2.c                                |  11 +-
 fs/ext4/inode.c                                    |   8 +
 fs/ext4/super.c                                    |  17 +-
 fs/f2fs/data.c                                     | 108 ++++---
 fs/f2fs/f2fs.h                                     |   6 +-
 fs/f2fs/file.c                                     |  16 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/fuse/file.c                                     |  75 +++--
 fs/fuse/fuse_i.h                                   |   2 +-
 fs/hfs/bfind.c                                     |   8 +-
 fs/hfs/brec.c                                      |  27 +-
 fs/hfs/mdb.c                                       |   2 +-
 fs/hfsplus/bfind.c                                 |   8 +-
 fs/hfsplus/bnode.c                                 |  41 ---
 fs/hfsplus/btree.c                                 |   6 +
 fs/hfsplus/hfsplus_fs.h                            |  42 +++
 fs/hfsplus/super.c                                 |  25 +-
 fs/hfsplus/unicode.c                               |  24 ++
 fs/jbd2/transaction.c                              |  13 +-
 fs/nfsd/blocklayout.c                              |   5 +-
 fs/nfsd/blocklayoutxdr.c                           |   7 +-
 fs/nfsd/flexfilelayout.c                           |   8 +
 fs/nfsd/flexfilelayoutxdr.c                        |   3 +-
 fs/nfsd/nfs4layouts.c                              |   1 -
 fs/nfsd/nfs4proc.c                                 |  34 +--
 fs/nfsd/nfs4xdr.c                                  |  14 +-
 fs/nfsd/xdr4.h                                     |  36 ++-
 fs/ocfs2/move_extents.c                            |   5 +
 fs/smb/client/inode.c                              |   6 +-
 fs/smb/client/misc.c                               |  17 ++
 fs/smb/client/smb2ops.c                            |   8 +-
 fs/smb/server/ksmbd_netlink.h                      |   3 +-
 fs/smb/server/server.h                             |   1 +
 fs/smb/server/smb2pdu.c                            |   4 +
 fs/smb/server/transport_ipc.c                      |   1 +
 fs/smb/server/transport_rdma.c                     |  11 +-
 fs/smb/server/transport_tcp.c                      |  67 ++---
 fs/smb/server/transport_tcp.h                      |   1 +
 fs/xfs/libxfs/xfs_log_format.h                     |  30 +-
 fs/xfs/xfs_log.c                                   |   8 +-
 fs/xfs/xfs_log_priv.h                              |   4 +-
 fs/xfs/xfs_log_recover.c                           |  34 ++-
 fs/xfs/xfs_ondisk.h                                |   2 +
 fs/xfs/xfs_super.c                                 |  33 +-
 include/linux/cpufreq.h                            |   3 +
 include/linux/mm.h                                 |   2 +-
 include/linux/pci.h                                |  14 +
 include/linux/pm_runtime.h                         |   4 +
 include/linux/timer.h                              |   2 +
 include/linux/usb/gadget.h                         |  25 ++
 include/net/ip_tunnels.h                           |  15 +
 include/trace/events/f2fs.h                        |  11 +-
 io_uring/filetable.c                               |   2 +-
 kernel/padata.c                                    |   6 +-
 kernel/sched/fair.c                                |  38 +--
 kernel/time/timer.c                                | 335 ++++++++++++++++-----
 net/core/rtnetlink.c                               |   3 -
 net/ipv4/ip_tunnel.c                               |  14 -
 net/ipv4/tcp_output.c                              |  19 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/sctp/inqueue.c                                 |  13 +-
 net/tls/tls_main.c                                 |   7 +-
 net/tls/tls_sw.c                                   |  28 +-
 net/vmw_vsock/af_vsock.c                           |  38 +--
 rust/bindings/bindings_helper.h                    |   2 +
 rust/bindings/lib.rs                               |   1 +
 sound/firewire/amdtp-stream.h                      |   2 +-
 sound/soc/codecs/nau8821.c                         |  53 +++-
 sound/usb/card.c                                   |  10 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   6 +-
 tools/testing/selftests/vm/map_hugetlb.c           |   7 -
 175 files changed, 2099 insertions(+), 1084 deletions(-)


