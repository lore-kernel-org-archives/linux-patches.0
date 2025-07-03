Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16430126BFF;
	Thu,  3 Jul 2025 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553943; cv=none; b=LQ+H30b9l63Nzbb+0MuOfwonN33dSYsAPJ6T6317nSVMrFJoW25LpyVD8FKBcxe7jFD3G/W/eMJ0aRYXshE5IFUFoYqJ7sMvvtXubuFBvrBqePO645lg5ScJ2Trnznb+fwriD/MRY0Af6mR9aJijLAX7jTrFB/1RHA89kn4mvMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553943; c=relaxed/simple;
	bh=HinZW6H1+VBPlbriUCR7/DXZsLObiKwnsn+g3Cht8e4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m7kEpAqwiNUljGofrt70ghA4YPGNmLH+BQWVMJ9y16g97ORIGMG0UB1C1HvO0dugfzIgh4Y76XpeDHqnCLhxd77pVVluzhHvNRmXcpGEFfIJZAN0wjuaDXxnFw517QdibbGNKM22W25iiuN3e1vbTB/sEfF5u3w3VKU9noUO9yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3jS88it; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3jS88it"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5704C4CEE3;
	Thu,  3 Jul 2025 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553941;
	bh=HinZW6H1+VBPlbriUCR7/DXZsLObiKwnsn+g3Cht8e4=;
	h=From:To:Cc:Subject:Date:From;
	b=Z3jS88it3alPzkpM//Cf2EZto+NV5auARaAS+xqkqAmgc9+vimWQkgsVtqOlG+gbS
	 gseiNY6dGH55rfl20g5P5uQrLQJIyrp5XkTUgJs446tOkEQHI77TvSwDKBtnaIPl6t
	 5qCiLmEURHMiW5s9HSfrrw+sASxdComH69I3U9Yo=
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
Subject: [PATCH 6.12 000/218] 6.12.36-rc1 review
Date: Thu,  3 Jul 2025 16:39:08 +0200
Message-ID: <20250703143955.956569535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.36-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.36-rc1
X-KernelTest-Deadline: 2025-07-05T14:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.36 release.
There are 218 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.36-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.36-rc1

Kevin Hao <haokexin@gmail.com>
    spi: fsl-qspi: Fix double cleanup in probe error path

Sasha Levin <sashal@kernel.org>
    btrfs: fix use-after-free on inode when scanning root during em shrinking

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix extent range end unlock in cow_file_range()

Han Xu <han.xu@nxp.com>
    spi: fsl-qspi: use devm function instead of driver remove

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: fsl-qspi: Support per spi-mem operation frequency switches

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: spi-mem: Add a new controller capability

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: spi-mem: Extend spi-mem operations with a per-operation maximum frequency

Qingfang Deng <dqfext@gmail.com>
    net: stmmac: Fix accessing freed irq affinity_hint

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Fix instruction hazard in gfx12 trap handler

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: remove gfx 12 trap handler page size cap

Andres Traumann <andres.traumann.01@gmail.com>
    ALSA: hda/realtek: Bass speaker fixup for ASUS UM5606KA

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Set hugetlb mmap base address aligned with pmd size

Sasha Levin <sashal@kernel.org>
    riscv/atomic: Do proper sign extension also for unsigned in arch_cmpxchg

Filipe Manana <fdmanana@suse.com>
    btrfs: do regular iput instead of delayed iput during extent map shrinking

Filipe Manana <fdmanana@suse.com>
    btrfs: make the extent map shrinker run asynchronously as a work queue job

Filipe Manana <fdmanana@suse.com>
    btrfs: skip inodes without loaded extent maps when shrinking extent maps

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fbdev-dma: Add shadow buffering for deferred I/O

Sasha Levin <sashal@kernel.org>
    drm/msm/dp: account for widebus and yuv420 during mode validation

Sasha Levin <sashal@kernel.org>
    usb: typec: tcpm: PSSourceOffTimer timeout in PR_Swap enters ERROR_RECOVERY

Sasha Levin <sashal@kernel.org>
    drm/xe: Carve out wopcm portion from the stolen memory

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r-common: fix ad3541/2r ranges

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r: extract common code (no changes in behavior intended)

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r: changes to use FIELD_PREP

Qu Wenruo <wqu@suse.com>
    btrfs: do proper folio cleanup when cow_file_range() failed

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: realtek: add RTL8125D-internal PHY

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: realtek: merge the drivers for internal NBase-T PHY's

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: add support for RTL8125D

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/vma: reset VMA iterator on commit_merge() OOM failure

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: flag partial buffer mappings

Jens Axboe <axboe@kernel.dk>
    io_uring/net: mark iov as dynamically allocated even for single segments

Jens Axboe <axboe@kernel.dk>
    io_uring/net: always use current transfer count for buffer put

Jens Axboe <axboe@kernel.dk>
    io_uring/net: only consider msg_inq if larger than 1

Jens Axboe <axboe@kernel.dk>
    io_uring/net: only retry recv bundle for a full transfer

Jens Axboe <axboe@kernel.dk>
    io_uring/net: improve recv bundles

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: don't rely on user vaddr alignment

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: fix folio unpinning

Penglei Jiang <superman.xpt@gmail.com>
    io_uring: fix potential page leak in io_sqe_buffer_register()

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix Tx L4 checksum

Chang S. Bae <chang.seok.bae@intel.com>
    x86/pkeys: Simplify PKRU update in signal frame

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Refactor xfeature bitmask update code for sigframe XSAVE

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Rollback non processed entities on error

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix mpv playback corruption on weston

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: switch job hw_fence to amdgpu_fence

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: Fix SDMA UTC_L1 handling during start/stop sequences

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dsi: Fix off by one in BXT_MIPI_TRANS_VTOTAL

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe: Fix early wedge on GuC load failure

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Fix taking invalid lock on wedge

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Fix memset on iomem

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check dce_hwseq before dereferencing it

Frank Min <Frank.Min@amd.com>
    drm/amdgpu: Add kicker device detection

Yihan Zhu <Yihan.Zhu@amd.com>
    drm/amd/display: Fix RMCM programming seq errors

Matthew Auld <matthew.auld@intel.com>
    drm/xe/guc_submit: add back fix

Matthew Auld <matthew.auld@intel.com>
    drm/xe/sched: stop re-submitting signalled jobs

Matthew Auld <matthew.auld@intel.com>
    drm/xe/vm: move rebind_work init earlier

Zhongwei Zhang <Zhongwei.Zhang@amd.com>
    drm/amd/display: Correct non-OLED pre_T11_delay.

John Olender <john.olender@gmail.com>
    drm/amdgpu: amdgpu_vram_mgr_new(): Clamp lpfn to total vram

Wentao Liang <vulab@iscas.ac.cn>
    drm/amd/display: Add null pointer check for get_first_active_display()

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Wait for Clk and Data Lanes to be ready

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Check return value when getting default PHY config

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix connecting to next bridge

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix phy de-init and flag it so

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Fix race in GWS queue scheduling

Stephan Gerhold <stephan.gerhold@linaro.org>
    drm/msm/gpu: Fix crash when throttling GPU immediately during boot

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Unregister device before cleaning up on disconnect

Qiu-ji Chen <chenqiuji666@gmail.com>
    drm/tegra: Fix a possible null pointer dereference

Thierry Reding <treding@nvidia.com>
    drm/tegra: Assign plane type before registration

Maíra Canal <mcanal@igalia.com>
    drm/etnaviv: Protect the scheduler's pending list with its lock

Thomas Zimmermann <tzimmermann@suse.de>
    drm/cirrus-qemu: Fix pitch programming

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Fix comment on modeset lock

anvithdosapati <anvithdosapati@google.com>
    scsi: ufs: core: Fix clk scaling to be conditional in reset and restore

Chen Yu <yu.c.chen@intel.com>
    scsi: megaraid_sas: Fix invalid node index

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix kobject reference count leak

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on sysfs attribute creation failure

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on kobject creation failure

Iusico Maxim <iusico.maxim@libero.it>
    HID: lenovo: Restrict F7/9/11 mode to compact keyboards only

Chao Yu <chao@kernel.org>
    f2fs: fix to zero post-eof page

David Hildenbrand <david@redhat.com>
    mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix the creation of page_pool

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: spi-cadence-quadspi: Fix pm runtime unbalance

Mark Harmstone <maharmstone@fb.com>
    btrfs: update superblock's device bytes_used when dropping chunk

Filipe Manana <fdmanana@suse.com>
    btrfs: fix a race between renames and directory logging

Heinz Mauelshagen <heinzm@redhat.com>
    dm-raid: fix variable in journal device check

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: L2CAP: Fix L2CAP MTU negotiation

Fabio Estevam <festevam@gmail.com>
    serial: imx: Restore original RXTL for console to fix data loss

Aidan Stewart <astewart@tektelic.com>
    serial: core: restore of_node information in sysfs

Yao Zi <ziyao@disroot.org>
    dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8723bs: Avoid memset() in aes_cipher() and aes_decipher()

Xin Li (Intel) <xin@zytor.com>
    x86/traps: Initialize DR6 by writing its architectural reset value

Avadhut Naik <avadhut.naik@amd.com>
    EDAC/amd64: Fix size calculation for Non-Power-of-Two DIMMs

David Howells <dhowells@redhat.com>
    cifs: Fix reading into an ITER_FOLIOQ from the smbdirect code

David Howells <dhowells@redhat.com>
    cifs: Fix the smbd_response slab to allow usercopy

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of common smbdirect_socket_parameters

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: introduce smbdirect_socket_parameters

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of common smbdirect_socket

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: add smbdirect_socket.h

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: add smbdirect.h with public structures

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of common smbdirect_pdu.h

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: add smbdirect_pdu.h with protocol definitions

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix potential deadlock when reconnecting channels

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Process deferred GGTT node removals on device unwind

Jayesh Choudhary <j-choudhary@ti.com>
    drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type

Wolfram Sang <wsa+renesas@sang-engineering.com>
    drm/bridge: ti-sn65dsi86: make use of debugfs_init callback

Arnd Bergmann <arnd@arndb.de>
    drm/i915: fix build error some more

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Adjust output for discovery error handling

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/discovery: optionally use fw based ip discovery

Jakub Kicinski <kuba@kernel.org>
    net: selftests: fix TCP packet checksum

Salvatore Bonaccorso <carnil@debian.org>
    ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X507UAR

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Release atm_dev_mutex after removing procfs in atm_dev_deregister().

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: tc: replace underscores with dashes in names

Simon Horman <horms@kernel.org>
    net: enetc: Correct endianness handling in _enetc_rd_reg64

Adin Scannell <amscanne@meta.com>
    libbpf: Fix possible use-after-free for externs

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Add missing error check in start_io_thread()

Yan Zhai <yan@cloudflare.com>
    bnxt: properly flush XDP redirect lists

Stefano Garzarella <sgarzare@redhat.com>
    vsock/uapi: fix linux/vm_sockets.h userspace compilation errors

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: finish link init before RCU publish

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: mac80211: Create separate links for VLAN interfaces

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: mac80211: Add link iteration macro for link data

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Don't set -ECONNRESET for consumed OOB skb.

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: fix beacon interval calculation overflow

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: ionic: Fix DMA mapping tests

Yuan Chen <chenyuan@kylinos.cn>
    libbpf: Fix null pointer dereference in btf_dump__free on allocation failure

Al Viro <viro@zeniv.linux.org.uk>
    attach_recursive_mnt(): do not lock the covering tree when sliding something under it

Youngjun Lee <yjjuny.lee@samsung.com>
    ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: hci_core: Fix use-after-free in vhci_flush()

Eric Dumazet <edumazet@google.com>
    atm: clip: prevent NULL deref in clip_push()

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    HID: wacom: fix crash in wacom_aes_battery_handler()

Haoxiang Li <haoxiang_li2024@163.com>
    drm/xe/display: Add check for alloc_ordered_workqueue()

Imre Deak <imre.deak@intel.com>
    drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS

Nam Cao <namcao@linutronix.de>
    Revert "riscv: misaligned: fix sleeping function called during misaligned access handling"

Nam Cao <namcao@linutronix.de>
    Revert "riscv: Define TASK_SIZE_MAX for __access_ok()"

Yu Kuai <yukuai3@huawei.com>
    lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio

Fedor Pchelkin <pchelkin@ispras.ru>
    s390/pkey: Prevent overflow in size calculation for memdup_user()

Oliver Schramm <oliver.schramm97@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Lenovo IdeaPad Slim 5 15

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write

Stefan Metzmacher <metze@samba.org>
    smb: client: remove \t from TP_printk statements

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Use correct DMI identifier for ASUSPRO-D840SA LPM quirk

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: robotfuzz-osif: disable zero-length read messages

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: tiny-usb: disable zero-length read messages

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Don't leave consecutive consumed OOB skbs.

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Trigger device recovery on engine reset/resume failure

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Add debugfs interface for setting HWS priority bands

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Separate DB ID and CMDQ ID allocations from CMDQ allocation

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Make command queue ID allocated on XArray

Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
    accel/ivpu: Remove copy engine support

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Do not fail on cmdq if failed to allocate preemption buffers

Janne Grunau <j@jannau.net>
    PCI: apple: Set only available ports up

Zhang Zekun <zhangzekun11@huawei.com>
    PCI: apple: Use helper function for_each_child_of_node_scoped()

Chao Yu <chao@kernel.org>
    f2fs: don't over-report free space or inodes in statvfs

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd9335: Fix missing free of regulator supplies

Peng Fan <peng.fan@nxp.com>
    ASoC: codec: wcd9335: Convert to GPIO descriptors

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: validate AG parameters in dbMount() to prevent crashes

Dave Kleikamp <dave.kleikamp@oracle.com>
    fs/jfs: consolidate sanity checking in dbMount

Filipe Manana <fdmanana@suse.com>
    btrfs: fix qgroup reservation leak on failure to allocate ordered extent

David Sterba <dsterba@suse.com>
    btrfs: use unsigned types for constants defined as bit shifts

Qu Wenruo <wqu@suse.com>
    btrfs: factor out nocow ordered extent and extent map generation into a helper

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    Revert "drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1

Qu Wenruo <wqu@suse.com>
    btrfs: handle csum tree error with rescue=ibadroots correctly

Kees Cook <kees@kernel.org>
    ovl: Check for NULL d_inode() in ovl_dentry_upper()

Ziqi Chen <quic_ziqichen@quicinc.com>
    scsi: ufs: core: Don't perform UFS clkscaling during host async scan

Dmitry Kandybka <d.kandybka@gmail.com>
    ceph: fix possible integer overflow in ceph_zero_objects()

Shuming Fan <shumingf@realtek.com>
    ASoC: rt1320: fix speaker noise when volume bar is 100%

Mario Limonciello <mario.limonciello@amd.com>
    ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ALSA: hda: Add new pci id for AMD GPU display HD audio controller

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Ignore unsol events for cards being shut down

Andy Chiu <andybnac@gmail.com>
    riscv: add a data fence for CMODX in the kernel mode

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: mux: do not return on EOPNOTSUPP in {mux, switch}_set

Jos Wang <joswang@lenovo.com>
    usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode

Peter Korsgaard <peter@korsgaard.com>
    usb: gadget: f_hid: wake up readers on disable/unbind

Robert Hodaszi <robert.hodaszi@digi.com>
    usb: cdc-wdm: avoid setting WDM_READ for ZLP-s

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: Add checks for snprintf() calls in usb_alloc_dev()

Chance Yang <chance.yang@kneron.us>
    usb: common: usb-conn-gpio: use a unique name for usb connector device

Jakub Lewalski <jakub.lewalski@nokia.com>
    tty: serial: uartlite: register uart driver in init

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: potential integer overflow in usbg_make_tpg()

Chenyuan Yang <chenyuan0y@gmail.com>
    misc: tps6594-pfsm: Add NULL pointer check in tps6594_pfsm_probe()

Purva Yeshi <purvayeshi550@gmail.com>
    iio: adc: ad_sigma_delta: Fix use of uninitialized status_pos

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc2: also exit clock_gating when stopping udc while suspended

James Clark <james.clark@linaro.org>
    coresight: Only check bottom two claim bits

Rengarajan S <rengarajan.s@microchip.com>
    8250: microchip: pci1xxxx: Add PCIe Hot reset disable support for Rev C0 and later devices

Benjamin Berg <benjamin.berg@intel.com>
    um: use proper care when taking mmap lock during segfault

Sami Tolvanen <samitolvanen@google.com>
    um: Add cmpxchg8b_emu and checksum functions to asm-prototypes.h

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: pressure: zpa2326: Use aligned_s64 for the timestamp

Lin.Cao <lincao12@amd.com>
    drm/scheduler: signal scheduled fence when kill job

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: seq64 memory unmap uses uninterruptible lock

Linggang Zeng <linggang.zeng@easystack.cn>
    bcache: fix NULL pointer in cache_set_flush()

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: fix a kfd_process ref leak

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: fix dm-raid max_write_behind setting

Hannes Reinecke <hare@kernel.org>
    nvme-tcp: sanitize request list handling

Hannes Reinecke <hare@kernel.org>
    nvme-tcp: fix I/O stalls on congested sockets

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Add workaround for errata ERR051624

Hector Martin <marcan@marcan.st>
    PCI: apple: Fix missing OF node reference in apple_pcie_setup_port

Wenbin Yao <quic_wenbyao@quicinc.com>
    PCI: dwc: Make link training more robust by setting PORT_LOGIC_LINK_WIDTH to one lane

Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
    dmaengine: xilinx_dma: Set dma_device directions

Yi Sun <yi.sun@intel.com>
    dmaengine: idxd: Check availability of workqueue allocated by idxd wq driver before using

Lukas Wunner <lukas@wunner.de>
    Revert "iommu/amd: Prevent binding other PCI drivers to IOMMU PCI devices"

Rudraksha Gupta <guptarud@gmail.com>
    rust: arm: fix unknown (to Clang) argument '-mno-fdpic'

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: module: place cleanup_module() in .exit.text section

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: provide zero as a unique ID to the Mac client

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow a filename to contain special characters on SMB3.1.1 posix extension

Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
    hwmon: (pmbus/max34440) Fix support for max34451

Scott Mayhew <smayhew@redhat.com>
    NFSv4: xattr handlers should check for absent nfs filehandles

Robert Richter <rrichter@amd.com>
    cxl/region: Add a dev_err() on missing target list entries

Guang Yuan Wu <gwu@ddn.com>
    fuse: fix race between concurrent setattrs from multiple nodes

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    leds: multicolor: Fix intensity setting while SW blinking

Matthew Sakai <msakai@redhat.com>
    dm vdo indexer: don't read request structure after enqueuing

Nikhil Jha <njha@janestreet.com>
    sunrpc: don't immediately retransmit on seqno miss

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max14577: Fix wakeup source leaks on device unbind

Peng Fan <peng.fan@nxp.com>
    mailbox: Not protect module_put with spin_lock_irqsave

Sagi Grimberg <sagi@grimberg.me>
    NFSv4.2: fix setattr caching of TIME_[MODIFY|ACCESS]_SET when timestamps are delegated

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: fix listxattr to return selinux security label

Han Young <hanyang.tony@bytedance.com>
    NFSv4: Always set NLINK even if the server doesn't support it

Pali Rohár <pali@kernel.org>
    cifs: Fix encoding of SMB1 Session Setup NTLMSSP Request in non-UNICODE mode

Pali Rohár <pali@kernel.org>
    cifs: Fix cifs_query_path_info() for Windows NT servers

Pali Rohár <pali@kernel.org>
    cifs: Correctly set SMB1 SessionKey field in Session Setup Request


-------------

Diffstat:

 Documentation/devicetree/bindings/serial/8250.yaml |   2 +-
 Documentation/netlink/specs/tc.yaml                |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi |  12 +
 arch/loongarch/mm/mmap.c                           |   6 +-
 arch/riscv/include/asm/cmpxchg.h                   |   2 +-
 arch/riscv/include/asm/pgtable.h                   |   1 -
 arch/riscv/kernel/traps_misaligned.c               |   4 +-
 arch/riscv/mm/cacheflush.c                         |  15 +-
 arch/um/drivers/ubd_user.c                         |   2 +-
 arch/um/include/asm/asm-prototypes.h               |   5 +
 arch/um/kernel/trap.c                              | 129 +++-
 arch/x86/include/uapi/asm/debugreg.h               |  21 +-
 arch/x86/kernel/cpu/common.c                       |  24 +-
 arch/x86/kernel/fpu/signal.c                       |  11 +-
 arch/x86/kernel/fpu/xstate.h                       |  22 +-
 arch/x86/kernel/traps.c                            |  34 +-
 arch/x86/um/asm/checksum.h                         |   3 +
 drivers/accel/ivpu/ivpu_debugfs.c                  |  84 +++
 drivers/accel/ivpu/ivpu_drv.c                      |   6 +
 drivers/accel/ivpu/ivpu_drv.h                      |  10 +-
 drivers/accel/ivpu/ivpu_hw.c                       |  21 +
 drivers/accel/ivpu/ivpu_hw.h                       |   5 +
 drivers/accel/ivpu/ivpu_job.c                      | 203 +++---
 drivers/accel/ivpu/ivpu_job.h                      |   2 +
 drivers/accel/ivpu/ivpu_jsm_msg.c                  |  46 +-
 drivers/ata/ahci.c                                 |   2 +-
 drivers/cxl/core/region.c                          |   7 +
 drivers/dma/idxd/cdev.c                            |   4 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   2 +
 drivers/edac/amd64_edac.c                          |  57 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  64 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |  16 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |  17 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h          |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |   6 +-
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h     | 703 +++++++++++----------
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm |  82 +--
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |   2 +-
 .../dc/dml2/dml21/dml21_translation_helper.c       |   1 +
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |   5 +-
 .../amd/display/dc/dml2/dml2_translation_helper.c  |   1 +
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |   9 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   3 +
 drivers/gpu/drm/ast/ast_mode.c                     |   6 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |  32 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              | 109 ++--
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +-
 drivers/gpu/drm/drm_fbdev_dma.c                    | 219 +++++--
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   5 +-
 drivers/gpu/drm/i915/display/vlv_dsi.c             |   4 +-
 drivers/gpu/drm/i915/i915_pmu.c                    |   2 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |  11 +-
 drivers/gpu/drm/msm/dp/dp_drm.c                    |   5 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |   1 +
 drivers/gpu/drm/scheduler/sched_entity.c           |   1 +
 drivers/gpu/drm/tegra/dc.c                         |  17 +-
 drivers/gpu/drm/tegra/hub.c                        |   4 +-
 drivers/gpu/drm/tegra/hub.h                        |   3 +-
 drivers/gpu/drm/tiny/cirrus.c                      |   1 -
 drivers/gpu/drm/udl/udl_drv.c                      |   2 +-
 drivers/gpu/drm/xe/display/xe_display.c            |   2 +
 drivers/gpu/drm/xe/xe_ggtt.c                       |  11 +
 drivers/gpu/drm/xe/xe_gpu_scheduler.h              |  10 +-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |   8 +
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   7 +-
 drivers/gpu/drm/xe/xe_guc_ct.h                     |   5 +
 drivers/gpu/drm/xe/xe_guc_pc.c                     |   2 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |  23 +
 drivers/gpu/drm/xe/xe_guc_types.h                  |   5 +
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c             |  70 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   8 +-
 drivers/hid/hid-lenovo.c                           |  11 +-
 drivers/hid/wacom_sys.c                            |   7 +-
 drivers/hwmon/pmbus/max34440.c                     |  48 +-
 drivers/hwtracing/coresight/coresight-core.c       |   3 +-
 drivers/hwtracing/coresight/coresight-priv.h       |   1 +
 drivers/i2c/busses/i2c-robotfuzz-osif.c            |   6 +
 drivers/i2c/busses/i2c-tiny-usb.c                  |   6 +
 drivers/iio/adc/ad_sigma_delta.c                   |   4 +
 drivers/iio/dac/Makefile                           |   2 +-
 drivers/iio/dac/ad3552r-common.c                   | 248 ++++++++
 drivers/iio/dac/ad3552r.c                          | 553 +++-------------
 drivers/iio/dac/ad3552r.h                          | 223 +++++++
 drivers/iio/pressure/zpa2326.c                     |   2 +-
 drivers/iommu/amd/init.c                           |   3 -
 drivers/leds/led-class-multicolor.c                |   3 +-
 drivers/mailbox/mailbox.c                          |   2 +-
 drivers/md/bcache/super.c                          |   7 +-
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/dm-vdo/indexer/volume.c                 |  24 +-
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  34 +-
 drivers/mfd/max14577.c                             |   1 +
 drivers/misc/tps6594-pfsm.c                        |   3 +
 drivers/mtd/nand/spi/core.c                        |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  12 +-
 drivers/net/ethernet/realtek/r8169.h               |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  23 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |  10 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  11 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   6 +-
 drivers/net/phy/realtek.c                          |  54 +-
 drivers/nvme/host/tcp.c                            |  22 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  15 +
 drivers/pci/controller/dwc/pcie-designware.c       |   5 +-
 drivers/pci/controller/pcie-apple.c                |   7 +-
 drivers/s390/crypto/pkey_api.c                     |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   6 +-
 drivers/spi/spi-cadence-quadspi.c                  |  12 +-
 drivers/spi/spi-fsl-qspi.c                         |  48 +-
 drivers/spi/spi-mem.c                              |  34 +
 drivers/staging/rtl8723bs/core/rtw_security.c      |  44 +-
 drivers/tty/serial/8250/8250_pci1xxxx.c            |  10 +
 drivers/tty/serial/imx.c                           |  17 +-
 drivers/tty/serial/serial_base_bus.c               |   1 +
 drivers/tty/serial/uartlite.c                      |  25 +-
 drivers/ufs/core/ufshcd.c                          |   6 +-
 drivers/usb/class/cdc-wdm.c                        |  23 +-
 drivers/usb/common/usb-conn-gpio.c                 |  25 +-
 drivers/usb/core/usb.c                             |  14 +-
 drivers/usb/dwc2/gadget.c                          |   6 +
 drivers/usb/gadget/function/f_hid.c                |  19 +-
 drivers/usb/gadget/function/f_tcm.c                |   4 +-
 drivers/usb/typec/altmodes/displayport.c           |   4 +
 drivers/usb/typec/mux.c                            |   4 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   3 +-
 fs/btrfs/backref.h                                 |   4 +-
 fs/btrfs/direct-io.c                               |   4 +-
 fs/btrfs/disk-io.c                                 |   5 +-
 fs/btrfs/extent_io.h                               |   2 +-
 fs/btrfs/extent_map.c                              | 132 +++-
 fs/btrfs/extent_map.h                              |   3 +-
 fs/btrfs/fs.h                                      |   2 +
 fs/btrfs/inode.c                                   | 299 +++++----
 fs/btrfs/ordered-data.c                            |  14 +-
 fs/btrfs/raid56.c                                  |   5 +-
 fs/btrfs/super.c                                   |  13 +-
 fs/btrfs/tests/extent-io-tests.c                   |   6 +-
 fs/btrfs/volumes.c                                 |   6 +
 fs/btrfs/zstd.c                                    |   2 +-
 fs/ceph/file.c                                     |   2 +-
 fs/f2fs/file.c                                     |  38 ++
 fs/f2fs/super.c                                    |  30 +-
 fs/fuse/dir.c                                      |  11 +
 fs/jfs/jfs_dmap.c                                  |  41 +-
 fs/namespace.c                                     |   8 +-
 fs/nfs/inode.c                                     |  51 +-
 fs/nfs/nfs4proc.c                                  |  25 +-
 fs/overlayfs/util.c                                |   4 +-
 fs/proc/task_mmu.c                                 |   2 +-
 fs/smb/client/cifs_debug.c                         |  23 +-
 fs/smb/client/cifsglob.h                           |   2 +
 fs/smb/client/cifspdu.h                            |   6 +-
 fs/smb/client/cifssmb.c                            |   1 +
 fs/smb/client/connect.c                            |  58 +-
 fs/smb/client/misc.c                               |   8 +
 fs/smb/client/sess.c                               |  21 +-
 fs/smb/client/smb2ops.c                            |  14 +-
 fs/smb/client/smbdirect.c                          | 513 +++++++--------
 fs/smb/client/smbdirect.h                          |  62 +-
 fs/smb/client/trace.h                              |  24 +-
 fs/smb/common/smbdirect/smbdirect.h                |  37 ++
 fs/smb/common/smbdirect/smbdirect_pdu.h            |  55 ++
 fs/smb/common/smbdirect/smbdirect_socket.h         |  43 ++
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/smb2pdu.c                            |  72 ++-
 fs/smb/server/smb2pdu.h                            |   3 +
 include/linux/spi/spi-mem.h                        |  14 +-
 include/net/bluetooth/hci_core.h                   |   2 +
 include/uapi/drm/ivpu_accel.h                      |   6 +-
 include/uapi/linux/vm_sockets.h                    |   4 +
 io_uring/kbuf.c                                    |   1 +
 io_uring/kbuf.h                                    |   1 +
 io_uring/net.c                                     |  46 +-
 io_uring/rsrc.c                                    |  23 +-
 io_uring/rsrc.h                                    |   1 +
 lib/group_cpus.c                                   |   9 +-
 lib/maple_tree.c                                   |   4 +-
 mm/damon/sysfs-schemes.c                           |   1 +
 mm/gup.c                                           |  14 +-
 mm/vma.c                                           |  27 +-
 net/atm/clip.c                                     |  11 +-
 net/atm/resources.c                                |   3 +-
 net/bluetooth/hci_core.c                           |  34 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/core/selftests.c                               |   5 +-
 net/mac80211/chan.c                                |   3 +
 net/mac80211/ieee80211_i.h                         |  12 +
 net/mac80211/iface.c                               |  12 +-
 net/mac80211/link.c                                |  94 ++-
 net/mac80211/util.c                                |   2 +-
 net/sunrpc/clnt.c                                  |   9 +-
 net/unix/af_unix.c                                 |  31 +-
 rust/Makefile                                      |   2 +-
 rust/macros/module.rs                              |   1 +
 sound/pci/hda/hda_bind.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/rt1320-sdw.c                      |  17 +-
 sound/soc/codecs/wcd9335.c                         |  40 +-
 sound/usb/quirks.c                                 |   2 +
 sound/usb/stream.c                                 |   2 +
 tools/lib/bpf/btf_dump.c                           |   3 +
 tools/lib/bpf/libbpf.c                             |  10 +-
 .../selftests/bpf/progs/test_global_map_resize.c   |  16 +
 218 files changed, 3862 insertions(+), 2248 deletions(-)


