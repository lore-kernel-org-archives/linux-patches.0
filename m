Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3209149C7B;
	Fri,  4 Jul 2025 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751640287; cv=none; b=KrufmmuDXTNMV8fo736rjonYm9O1kXRD4W1mGiy8TcbBQP4gy2nnynyR8bxsaFLVotET+L0bC3Kb/WD/4vMlcpbNoaiHLdpL8u2fNvZ0eHQ99Be+R0p1rJDGyxKfiw/3oS5em7vtAcVHu3D7LpSC5RyNO2Izs5KKvBBkQH9m4es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751640287; c=relaxed/simple;
	bh=d8zsyaxJuBmvx9isc4YPJvd5Ccv+ncxfHW1LfmIqaoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p5uM9yZJC/iQPYbu5muxZBqX44Cds4Nr00vH3hrERv0Ixl0sHec5Y7IWt84Z03IvjrlQh/yn+4ssOibnf0Vm37FR6CGAv0W5e+dAXrrxDHqeBwZM95RH0/1wNLoMjjzXI7dreVCyWH2lTAMbS2QGCR3/UgdPF7avOU0oeKnkV+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFDhlDKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFDhlDKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F8AC4CEE3;
	Fri,  4 Jul 2025 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751640287;
	bh=d8zsyaxJuBmvx9isc4YPJvd5Ccv+ncxfHW1LfmIqaoQ=;
	h=From:To:Cc:Subject:Date:From;
	b=uFDhlDKbi/j0Lvn7yutmycJB9ZG/Mlaqk3ftrgEmYtnPcXqRNKTInEkYd7bPZdE+e
	 N+aKTSTxQTFH57aRuA4qBpnLFpwcGG5srRKJcrTZtz7pSw2h8lpALvXyQvPRAjXj9N
	 Vf+4VLAzLSbCJ13shzmWyrmgkA1T8TnrvUC48P3g=
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
Subject: [PATCH 6.15 000/263] 6.15.5-rc2 review
Date: Fri,  4 Jul 2025 16:44:42 +0200
Message-ID: <20250704125604.759558342@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.15.5-rc2
X-KernelTest-Deadline: 2025-07-06T12:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.15.5 release.
There are 263 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.15.5-rc2

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix AMDGPU_MAX_BL_LEVEL value

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Export full brightness range to userspace

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Optimize custom brightness curve

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Only read ACPI backlight caps once

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix default DC and AC levels

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Add debugging message for brightness caps

Cyril Bur <cyrilbur@tenstorrent.com>
    riscv: uaccess: Only restore the CSR_STATUS SUM bit

Jens Axboe <axboe@kernel.dk>
    io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: flag partial buffer mappings

Heiko Carstens <hca@linux.ibm.com>
    s390/ptrace: Fix pointer dereferencing in regs_get_kernel_stack_nth()

Chang S. Bae <chang.seok.bae@intel.com>
    x86/pkeys: Simplify PKRU update in signal frame

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Refactor xfeature bitmask update code for sigframe XSAVE

Danilo Krummrich <dakr@kernel.org>
    rust: devres: do not dereference to the internal Revocable

Danilo Krummrich <dakr@kernel.org>
    rust: devres: fix race in Devres::drop()

Danilo Krummrich <dakr@kernel.org>
    rust: revocable: indicate whether `data` has been revoked already

Danilo Krummrich <dakr@kernel.org>
    rust: completion: implement initial abstraction

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Get LTTPR IEEE OUI/Device ID From Closest LTTPR To Host

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Add early 8b/10b channel equalization test pattern sequence

Sasha Levin <sashal@kernel.org>
    sched_ext: Make scx_group_set_weight() always update tg->scx.weight

Sasha Levin <sashal@kernel.org>
    arm64: dts: qcom: x1e78100-t14s: fix missing HID supplies

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mes: add missing locking in helper functions

Eric Biggers <ebiggers@google.com>
    crypto: powerpc/poly1305 - add depends on BROKEN for now

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1-crd: Fix vreg_l2j_1p2 voltage

Sasha Levin <sashal@kernel.org>
    arm64: dts: qcom: x1e78100-t14s: mark l12b and l15b always-on

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-crd: mark l12b and l15b always-on

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: Commonize X1 CRD DTSI

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix mpv playback corruption on weston

Peichen Huang <PeiChen.Huang@amd.com>
    drm/amd/display: Add dc cap for dp tunneling

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Add more checks for DSC / HUBP ONO guarantees

Frank Min <Frank.Min@amd.com>
    drm/amdgpu: add kicker fws loading for gfx11/smu13/psp13

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

Sonny Jiang <sonny.jiang@amd.com>
    drm/amdgpu: VCN v5_0_1 to prevent FW checking RB during DPG pause

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: disable workload profile switching when OD is enabled

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

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Work around Thunderbolt sink disconnect after SINK_COUNT_ESI read

Imre Deak <imre.deak@intel.com>
    drm/i915/ptl: Use everywhere the correct DDI port clock select mask

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

Thomas Zimmermann <tzimmermann@suse.de>
    drm/simpledrm: Do not upcast in release helpers

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/panel: simple: Tianma TM070JDHG34-00: add delays

Maíra Canal <mcanal@igalia.com>
    drm/etnaviv: Protect the scheduler's pending list with its lock

Thomas Zimmermann <tzimmermann@suse.de>
    drm/cirrus-qemu: Fix pitch programming

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Fix comment on modeset lock

Karan Tilak Kumar <kartilak@cisco.com>
    scsi: fnic: Turn off FDMI ACTIVE flags on link down

Karan Tilak Kumar <kartilak@cisco.com>
    scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out

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

Qasim Ijaz <qasdev00@gmail.com>
    HID: appletb-kbd: fix "appletb_backlight" backlight device reference counting

Chao Yu <chao@kernel.org>
    f2fs: fix to zero post-eof page

David Hildenbrand <david@redhat.com>
    mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"

Kairui Song <kasong@tencent.com>
    mm/shmem, swap: fix softlockup with mTHP swapin

Kairui Song <kasong@tencent.com>
    mm: userfaultfd: fix race of userfaultfd_move and swap cache

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix the creation of page_pool

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: spi-cadence-quadspi: Fix pm runtime unbalance

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: change security_compute_sid to return the ssid or tsid on match

Kuan-Wei Chiu <visitorckw@gmail.com>
    Revert "bcache: remove heap-related macros and switch to generic min_heap"

Kuan-Wei Chiu <visitorckw@gmail.com>
    Revert "bcache: update min_heap_callbacks to use default builtin swap"

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid inode pointer dereferences during log replay

Mark Harmstone <maharmstone@fb.com>
    btrfs: update superblock's device bytes_used when dropping chunk

Filipe Manana <fdmanana@suse.com>
    btrfs: fix a race between renames and directory logging

Kuan-Wei Chiu <visitorckw@gmail.com>
    bcache: remove unnecessary select MIN_HEAP

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

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix potential deadlock when reconnecting channels

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Process deferred GGTT node removals on device unwind

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/guc: Explicitly exit CT safe mode on unwind

Jayesh Choudhary <j-choudhary@ti.com>
    drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type

Wolfram Sang <wsa+renesas@sang-engineering.com>
    drm/bridge: ti-sn65dsi86: make use of debugfs_init callback

Arnd Bergmann <arnd@arndb.de>
    drm/i915: fix build error some more

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Adjust output for discovery error handling

Louis Chauvet <louis.chauvet@bootlin.com>
    drm: writeback: Fix drm_writeback_connector_cleanup signature

Charles Mirabile <cmirabil@redhat.com>
    riscv: fix runtime constant support for nommu kernels

Christoph Hellwig <hch@lst.de>
    nvme: fix atomic write size validation

Christoph Hellwig <hch@lst.de>
    nvme: refactor the atomic write unit detection

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

Jens Axboe <axboe@kernel.dk>
    io_uring/net: mark iov as dynamically allocated even for single segments

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Add missing error check in start_io_thread()

Yan Zhai <yan@cloudflare.com>
    bnxt: properly flush XDP redirect lists

Stefano Garzarella <sgarzare@redhat.com>
    vsock/uapi: fix linux/vm_sockets.h userspace compilation errors

Al Viro <viro@zeniv.linux.org.uk>
    userns and mnt_idmap leak in open_tree_attr(2)

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

Ido Schimmel <idosch@nvidia.com>
    bridge: mcast: Fix use-after-free during router port configuration

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: ionic: Fix DMA mapping tests

Breno Leitao <leitao@debian.org>
    net: netpoll: Initialize UDP checksum field before checksumming

Yuan Chen <chenyuan@kylinos.cn>
    libbpf: Fix null pointer dereference in btf_dump__free on allocation failure

Al Viro <viro@zeniv.linux.org.uk>
    attach_recursive_mnt(): do not lock the covering tree when sliding something under it

Youngjun Lee <yjjuny.lee@samsung.com>
    ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: hci_core: Fix use-after-free in vhci_flush()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: fix for soundwire failures during hibernation exit sequence

Eric Dumazet <edumazet@google.com>
    atm: clip: prevent NULL deref in clip_push()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: fnic: Fix missing DMA mapping error in fnic_send_frame()

Dan Williams <dan.j.williams@intel.com>
    cxl/ras: Fix CPER handler device confusion

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    HID: wacom: fix crash in wacom_aes_battery_handler()

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-quicki2c: Enhance QuickI2C reset flow

Matthew Auld <matthew.auld@intel.com>
    drm/xe: move DPT l2 flush to a more sensible place

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/xe: Move DSB l2 flush to a more sensible place

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/snps_hdmi_pll: Fix 64-bit divisor truncation by using div64_u64

Haoxiang Li <haoxiang_li2024@163.com>
    drm/xe/display: Add check for alloc_ordered_workqueue()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mes: add compatibility checks for set_hw_resource_1

Takashi Iwai <tiwai@suse.de>
    drm/amd/display: Add sanity checks for drm_edid_raw()

Nam Cao <namcao@linutronix.de>
    Revert "riscv: misaligned: fix sleeping function called during misaligned access handling"

Nam Cao <namcao@linutronix.de>
    Revert "riscv: Define TASK_SIZE_MAX for __access_ok()"

Yu Kuai <yukuai3@huawei.com>
    lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()

David Hildenbrand <david@redhat.com>
    fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't assume uaddr alignment in io_vec_fill_bvec

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: don't rely on user vaddr alignment

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: fix folio unpinning

Fedor Pchelkin <pchelkin@ispras.ru>
    s390/pkey: Prevent overflow in size calculation for memdup_user()

Klara Modin <klarasmodin@gmail.com>
    riscv: export boot_cpu_hartid

Oliver Schramm <oliver.schramm97@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Lenovo IdeaPad Slim 5 15

Han Gao <rabenda.cn@gmail.com>
    riscv: vector: Fix context save/restore with xtheadvector

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix regression with native SMB symlinks

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write

Stefan Metzmacher <metze@samba.org>
    smb: client: remove \t from TP_printk statements

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Use correct DMI identifier for ASUSPRO-D840SA LPM quirk

Florian Fainelli <florian.fainelli@broadcom.com>
    scripts/gdb: fix dentry_name() lookup

Haiyue Wang <haiyuewa@163.com>
    fuse: fix runtime warning on truncate_folio_batch_exceptionals()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Check interrupt route from physical CPU

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix interrupt route update with EIOINTC

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Add address alignment check for IOCSR emulation

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Disable updating of "num_cpu" and "feature"

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Check validity of "num_cpu" from user space

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Avoid overflow with array index

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: robotfuzz-osif: disable zero-length read messages

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: tiny-usb: disable zero-length read messages

Lukasz Kucharczyk <lukasz.kucharczyk@leica-geosystems.com>
    i2c: imx: fix emulated smbus block read

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: omap: Fix an error handling path in omap_i2c_probe()

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Don't leave consecutive consumed OOB skbs.

Haoxiang Li <haoxiang_li2024@163.com>
    drm/i915/display: Add check for alloc_ordered_workqueue() and alloc_workqueue()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: fix area release on registration failure

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: split out memory holders from area

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: improve area validation

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: move io_zcrx_iov_page

Chao Yu <chao@kernel.org>
    f2fs: don't over-report free space or inodes in statvfs

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd9335: Fix missing free of regulator supplies

Peng Fan <peng.fan@nxp.com>
    ASoC: codec: wcd9335: Convert to GPIO descriptors

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Rollback non processed entities on error

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Increase/decrease the PM counter per IOCTL

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Create uvc_pm_(get|put) functions

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Keep streaming state in the file handle

Filipe Manana <fdmanana@suse.com>
    btrfs: fix qgroup reservation leak on failure to allocate ordered extent

David Sterba <dsterba@suse.com>
    btrfs: use unsigned types for constants defined as bit shifts

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    Revert "drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1

Qu Wenruo <wqu@suse.com>
    btrfs: handle csum tree error with rescue=ibadroots correctly

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between async reclaim worker and close_ctree()

Kees Cook <kees@kernel.org>
    ovl: Check for NULL d_inode() in ovl_dentry_upper()

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: save the SR_SUM status over switches

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

Clément Léger <cleger@rivosinc.com>
    riscv: misaligned: declare misaligned_access_speed under CONFIG_RISCV_MISALIGNED

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix in_atomic() handling in do_secure_storage_access()

Andy Chiu <andybnac@gmail.com>
    riscv: add a data fence for CMODX in the kernel mode

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: mux: do not return on EOPNOTSUPP in {mux, switch}_set

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: typec: tipd: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    usb: typec: tcpci: Fix wakeup source leaks on device unbind

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

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Add support for 16-bit report size

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7606_spi: check error in ad7606B_sw_mode_config()

David Heidelberg <david@ixit.cz>
    iio: light: al3000a: Fix an error handling path in al3000a_probe()

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: adi-axi-dac: add cntrl chan check

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

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: Add Telit FN920C04 modem support

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: pressure: zpa2326: Use aligned_s64 for the timestamp

Lin.Cao <lincao12@amd.com>
    drm/scheduler: signal scheduled fence when kill job

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: seq64 memory unmap uses uninterruptible lock

Linggang Zeng <linggang.zeng@easystack.cn>
    bcache: fix NULL pointer in cache_set_flush()

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu/vcn2.5: read back register after written

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu/vcn3: read back register after written

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu/vcn4: read back register after written

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu/vcn5.0.1: read back register after written

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: fix a kfd_process ref leak

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: fix dm-raid max_write_behind setting

Hannes Reinecke <hare@kernel.org>
    nvme-tcp: sanitize request list handling

Hannes Reinecke <hare@kernel.org>
    nvme-tcp: fix I/O stalls on congested sockets

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlwifi: mld: Move regulatory domain initialization

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

Gregory Price <gourry@gourry.net>
    cxl: core/region - ignore interleave granularity when ways=1

Robert Richter <rrichter@amd.com>
    cxl/region: Add a dev_err() on missing target list entries

Guang Yuan Wu <gwu@ddn.com>
    fuse: fix race between concurrent setattrs from multiple nodes

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    leds: multicolor: Fix intensity setting while SW blinking

Matthew Sakai <msakai@redhat.com>
    dm vdo indexer: don't read request structure after enqueuing

Yikai Tsai <yikai.tsai.wiwynn@gmail.com>
    hwmon: (isl28022) Fix current reading calculation

Nikhil Jha <njha@janestreet.com>
    sunrpc: don't immediately retransmit on seqno miss

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: sprd-sc27xx: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: 88pm886: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max77705: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max14577: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max77541: Fix wakeup source leaks on device unbind

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

 Documentation/devicetree/bindings/serial/8250.yaml |    2 +-
 Documentation/netlink/specs/tc.yaml                |    4 +-
 Makefile                                           |    4 +-
 arch/arm64/boot/dts/qcom/x1-crd.dtsi               | 1277 ++++++++++++++++++++
 .../dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts     |   45 +
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          | 1270 +------------------
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |    2 +-
 arch/loongarch/kvm/intc/eiointc.c                  |   89 +-
 arch/powerpc/crypto/Kconfig                        |    1 +
 arch/riscv/include/asm/cpufeature.h                |    5 +-
 arch/riscv/include/asm/pgtable.h                   |    1 -
 arch/riscv/include/asm/processor.h                 |    1 +
 arch/riscv/include/asm/runtime-const.h             |    2 +-
 arch/riscv/include/asm/vector.h                    |   12 +-
 arch/riscv/kernel/asm-offsets.c                    |    5 +
 arch/riscv/kernel/entry.S                          |    9 +
 arch/riscv/kernel/setup.c                          |    1 +
 arch/riscv/kernel/traps_misaligned.c               |    6 +-
 arch/riscv/mm/cacheflush.c                         |   15 +-
 arch/s390/kernel/ptrace.c                          |    2 +-
 arch/s390/mm/fault.c                               |    2 +
 arch/um/drivers/ubd_user.c                         |    2 +-
 arch/um/include/asm/asm-prototypes.h               |    5 +
 arch/um/kernel/trap.c                              |  129 +-
 arch/x86/include/uapi/asm/debugreg.h               |   21 +-
 arch/x86/kernel/cpu/common.c                       |   24 +-
 arch/x86/kernel/fpu/signal.c                       |   11 +-
 arch/x86/kernel/fpu/xstate.h                       |   22 +-
 arch/x86/kernel/traps.c                            |   34 +-
 arch/x86/um/asm/checksum.h                         |    3 +
 drivers/ata/ahci.c                                 |    2 +-
 drivers/bus/mhi/host/pci_generic.c                 |   39 +
 drivers/cxl/core/ras.c                             |   47 +-
 drivers/cxl/core/region.c                          |    9 +-
 drivers/dma/idxd/cdev.c                            |    4 +-
 drivers/dma/xilinx/xilinx_dma.c                    |    2 +
 drivers/edac/amd64_edac.c                          |   57 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |    8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   16 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |   16 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c          |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |   17 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h          |    6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |    2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |    5 +
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c             |    9 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   10 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |    3 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |    2 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |    6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |   19 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   20 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   20 +
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            |   21 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |    1 +
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |    2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   97 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |    4 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   33 +
 drivers/gpu/drm/amd/display/dc/dc.h                |    8 +-
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h       |    4 +-
 .../dc/dml2/dml21/dml21_translation_helper.c       |    1 +
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |    5 +-
 .../amd/display/dc/dml2/dml2_translation_helper.c  |    1 +
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |    9 +-
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |   28 +
 .../display/dc/link/protocols/link_dp_capability.c |   46 +-
 .../display/dc/link/protocols/link_dp_capability.h |    3 +
 .../display/dc/link/protocols/link_dp_training.c   |    1 -
 .../dc/link/protocols/link_dp_training_8b_10b.c    |   52 +-
 .../amd/display/dc/resource/dcn31/dcn31_resource.c |    3 +
 .../display/dc/resource/dcn314/dcn314_resource.c   |    3 +
 .../amd/display/dc/resource/dcn35/dcn35_resource.c |    3 +
 .../display/dc/resource/dcn351/dcn351_resource.c   |    3 +
 .../amd/display/dc/resource/dcn36/dcn36_resource.c |    3 +
 .../drm/amd/display/include/link_service_types.h   |    2 +
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |    3 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |   22 +
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h            |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   12 +-
 drivers/gpu/drm/ast/ast_mode.c                     |    6 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |   32 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |  109 +-
 drivers/gpu/drm/drm_writeback.c                    |    7 +-
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |    5 +-
 drivers/gpu/drm/i915/display/intel_cx0_phy.c       |   27 +-
 drivers/gpu/drm/i915/display/intel_cx0_phy_regs.h  |   15 +-
 .../gpu/drm/i915/display/intel_display_driver.c    |   30 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   17 +
 drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c |    4 +-
 drivers/gpu/drm/i915/display/vlv_dsi.c             |    4 +-
 drivers/gpu/drm/i915/i915_pmu.c                    |    2 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |    1 +
 drivers/gpu/drm/panel/panel-simple.c               |    6 +
 drivers/gpu/drm/scheduler/sched_entity.c           |    1 +
 drivers/gpu/drm/tegra/dc.c                         |   17 +-
 drivers/gpu/drm/tegra/hub.c                        |    4 +-
 drivers/gpu/drm/tegra/hub.h                        |    3 +-
 drivers/gpu/drm/tiny/cirrus-qemu.c                 |    1 -
 drivers/gpu/drm/tiny/simpledrm.c                   |    4 +-
 drivers/gpu/drm/udl/udl_drv.c                      |    2 +-
 drivers/gpu/drm/xe/display/xe_display.c            |    2 +
 drivers/gpu/drm/xe/display/xe_dsb_buffer.c         |   11 +-
 drivers/gpu/drm/xe/display/xe_fb_pin.c             |    5 +-
 drivers/gpu/drm/xe/xe_ggtt.c                       |   11 +
 drivers/gpu/drm/xe/xe_gpu_scheduler.h              |   10 +-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |    8 +
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   17 +-
 drivers/gpu/drm/xe/xe_guc_ct.h                     |    5 +
 drivers/gpu/drm/xe/xe_guc_pc.c                     |    2 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |   23 +
 drivers/gpu/drm/xe/xe_guc_types.h                  |    5 +
 drivers/gpu/drm/xe/xe_vm.c                         |    8 +-
 drivers/hid/hid-appletb-kbd.c                      |    5 +
 drivers/hid/hid-lenovo.c                           |   11 +-
 .../intel-quicki2c/quicki2c-protocol.c             |   26 +-
 drivers/hid/wacom_sys.c                            |    7 +-
 drivers/hwmon/isl28022.c                           |    6 +-
 drivers/hwmon/pmbus/max34440.c                     |   48 +-
 drivers/hwtracing/coresight/coresight-core.c       |    3 +-
 drivers/hwtracing/coresight/coresight-priv.h       |    1 +
 drivers/i2c/busses/i2c-imx.c                       |    3 +-
 drivers/i2c/busses/i2c-omap.c                      |    7 +-
 drivers/i2c/busses/i2c-robotfuzz-osif.c            |    6 +
 drivers/i2c/busses/i2c-tiny-usb.c                  |    6 +
 drivers/iio/adc/ad7606_spi.c                       |    8 +-
 drivers/iio/adc/ad_sigma_delta.c                   |    4 +
 drivers/iio/dac/adi-axi-dac.c                      |   24 +
 drivers/iio/light/al3000a.c                        |    9 +-
 drivers/iio/light/hid-sensor-prox.c                |    3 +
 drivers/iio/pressure/zpa2326.c                     |    2 +-
 drivers/leds/led-class-multicolor.c                |    3 +-
 drivers/mailbox/mailbox.c                          |    2 +-
 drivers/md/bcache/Kconfig                          |    1 -
 drivers/md/bcache/alloc.c                          |   57 +-
 drivers/md/bcache/bcache.h                         |    2 +-
 drivers/md/bcache/bset.c                           |  116 +-
 drivers/md/bcache/bset.h                           |   40 +-
 drivers/md/bcache/btree.c                          |   69 +-
 drivers/md/bcache/extents.c                        |   43 +-
 drivers/md/bcache/movinggc.c                       |   33 +-
 drivers/md/bcache/super.c                          |   10 +-
 drivers/md/bcache/sysfs.c                          |    4 +-
 drivers/md/bcache/util.h                           |   67 +-
 drivers/md/bcache/writeback.c                      |   13 +-
 drivers/md/dm-raid.c                               |    2 +-
 drivers/md/dm-vdo/indexer/volume.c                 |   24 +-
 drivers/md/md-bitmap.c                             |    2 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   70 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   93 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    5 +
 drivers/mfd/88pm886.c                              |    6 +-
 drivers/mfd/max14577.c                             |    1 +
 drivers/mfd/max77541.c                             |    2 +-
 drivers/mfd/max77705.c                             |    4 +-
 drivers/mfd/sprd-sc27xx-spi.c                      |    5 +-
 drivers/misc/tps6594-pfsm.c                        |    3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    5 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   12 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/mld/fw.c        |    8 +-
 drivers/nvme/host/core.c                           |   83 +-
 drivers/nvme/host/nvme.h                           |    3 +-
 drivers/nvme/host/tcp.c                            |   22 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   15 +
 drivers/pci/controller/dwc/pcie-designware.c       |    5 +-
 drivers/pci/controller/pcie-apple.c                |    3 +
 drivers/s390/crypto/pkey_api.c                     |    2 +-
 drivers/scsi/fnic/fdls_disc.c                      |  122 +-
 drivers/scsi/fnic/fnic.h                           |    2 +-
 drivers/scsi/fnic/fnic_fcs.c                       |    2 +
 drivers/scsi/fnic/fnic_fdls.h                      |    1 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |    6 +-
 drivers/spi/spi-cadence-quadspi.c                  |   12 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |   44 +-
 drivers/tty/serial/8250/8250_pci1xxxx.c            |   10 +
 drivers/tty/serial/imx.c                           |   17 +-
 drivers/tty/serial/serial_base_bus.c               |    1 +
 drivers/tty/serial/uartlite.c                      |   25 +-
 drivers/ufs/core/ufshcd.c                          |    6 +-
 drivers/usb/class/cdc-wdm.c                        |   23 +-
 drivers/usb/common/usb-conn-gpio.c                 |   25 +-
 drivers/usb/core/usb.c                             |   14 +-
 drivers/usb/dwc2/gadget.c                          |    6 +
 drivers/usb/gadget/function/f_hid.c                |   19 +-
 drivers/usb/gadget/function/f_tcm.c                |    4 +-
 drivers/usb/typec/altmodes/displayport.c           |    4 +
 drivers/usb/typec/mux.c                            |    4 +-
 drivers/usb/typec/tcpm/tcpci_maxim_core.c          |    5 +-
 drivers/usb/typec/tipd/core.c                      |    2 +-
 fs/btrfs/backref.h                                 |    4 +-
 fs/btrfs/direct-io.c                               |    4 +-
 fs/btrfs/disk-io.c                                 |   25 +-
 fs/btrfs/extent_io.h                               |    2 +-
 fs/btrfs/inode.c                                   |   95 +-
 fs/btrfs/ordered-data.c                            |   14 +-
 fs/btrfs/raid56.c                                  |    5 +-
 fs/btrfs/tests/extent-io-tests.c                   |    6 +-
 fs/btrfs/tree-log.c                                |   14 +-
 fs/btrfs/volumes.c                                 |    6 +
 fs/btrfs/zstd.c                                    |    2 +-
 fs/ceph/file.c                                     |    2 +-
 fs/f2fs/file.c                                     |   38 +
 fs/f2fs/super.c                                    |   30 +-
 fs/fuse/dir.c                                      |   11 +
 fs/fuse/inode.c                                    |    4 +
 fs/namespace.c                                     |   18 +-
 fs/nfs/inode.c                                     |   51 +-
 fs/nfs/nfs4proc.c                                  |   25 +-
 fs/overlayfs/util.c                                |    4 +-
 fs/proc/task_mmu.c                                 |    2 +-
 fs/smb/client/cifsglob.h                           |    2 +
 fs/smb/client/cifspdu.h                            |    6 +-
 fs/smb/client/cifssmb.c                            |    1 +
 fs/smb/client/connect.c                            |   58 +-
 fs/smb/client/misc.c                               |    8 +
 fs/smb/client/reparse.c                            |   20 +-
 fs/smb/client/sess.c                               |   21 +-
 fs/smb/client/trace.h                              |   24 +-
 fs/smb/server/connection.h                         |    1 +
 fs/smb/server/smb2pdu.c                            |   72 +-
 fs/smb/server/smb2pdu.h                            |    3 +
 include/net/bluetooth/hci_core.h                   |    2 +
 include/uapi/linux/vm_sockets.h                    |    4 +
 io_uring/io_uring.c                                |    3 +-
 io_uring/kbuf.c                                    |    1 +
 io_uring/kbuf.h                                    |    1 +
 io_uring/net.c                                     |   34 +-
 io_uring/rsrc.c                                    |   57 +-
 io_uring/rsrc.h                                    |    3 +-
 io_uring/zcrx.c                                    |  101 +-
 io_uring/zcrx.h                                    |   11 +-
 kernel/sched/ext.c                                 |   12 +-
 lib/group_cpus.c                                   |    9 +-
 lib/maple_tree.c                                   |    4 +-
 mm/damon/sysfs-schemes.c                           |    1 +
 mm/gup.c                                           |   14 +-
 mm/memory.c                                        |   20 -
 mm/shmem.c                                         |    6 +-
 mm/swap.h                                          |   23 +
 mm/userfaultfd.c                                   |   33 +-
 net/atm/clip.c                                     |   11 +-
 net/atm/resources.c                                |    3 +-
 net/bluetooth/hci_core.c                           |   34 +-
 net/bluetooth/l2cap_core.c                         |    9 +-
 net/bridge/br_multicast.c                          |    9 +
 net/core/netpoll.c                                 |    2 +-
 net/core/selftests.c                               |    5 +-
 net/mac80211/chan.c                                |    3 +
 net/mac80211/ieee80211_i.h                         |   12 +
 net/mac80211/iface.c                               |   12 +-
 net/mac80211/link.c                                |   94 +-
 net/mac80211/util.c                                |    2 +-
 net/sunrpc/clnt.c                                  |    9 +-
 net/unix/af_unix.c                                 |   31 +-
 rust/Makefile                                      |    2 +-
 rust/bindings/bindings_helper.h                    |    1 +
 rust/helpers/completion.c                          |    8 +
 rust/helpers/helpers.c                             |    1 +
 rust/kernel/devres.rs                              |   53 +-
 rust/kernel/revocable.rs                           |   18 +-
 rust/kernel/sync.rs                                |    2 +
 rust/kernel/sync/completion.rs                     |  112 ++
 rust/macros/module.rs                              |    1 +
 scripts/gdb/linux/vfs.py                           |    2 +-
 security/selinux/ss/services.c                     |   16 +-
 sound/pci/hda/hda_bind.c                           |    2 +-
 sound/pci/hda/hda_intel.c                          |    3 +
 sound/pci/hda/patch_realtek.c                      |    1 +
 sound/soc/amd/ps/acp63.h                           |    4 +
 sound/soc/amd/ps/ps-common.c                       |   18 +
 sound/soc/amd/yc/acp6x-mach.c                      |    7 +
 sound/soc/codecs/rt1320-sdw.c                      |   17 +-
 sound/soc/codecs/wcd9335.c                         |   40 +-
 sound/usb/quirks.c                                 |    2 +
 sound/usb/stream.c                                 |    2 +
 tools/lib/bpf/btf_dump.c                           |    3 +
 tools/lib/bpf/libbpf.c                             |   10 +-
 .../selftests/bpf/progs/test_global_map_resize.c   |   16 +
 287 files changed, 4526 insertions(+), 2534 deletions(-)


