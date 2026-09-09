Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11264275AFD;
	Wed,  9 Sep 2026 13:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961710; cv=none; b=bExn1loE9KiViur3ekR8FzZE+ZZwfdVYgRV1BSjj3gyU0WN9FG5z0dGW27eam3sBQ/MLkpN4VPdhF3/KDFFjPU1sFRgJbhOdoPYaPKvHCGOqPI0NqWj0SoVzi7wJ/TVVgm78b8N/OqnBhsNp4flAphqkhm2/jiWp4XY+JOwJK1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961710; c=relaxed/simple;
	bh=QJ6GzXSvz+D0bTT5FHsAgwaZwuehqNnLOBWmVgMciog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WhSyAd2go380sLHV/zRorIHsTKwFwHg9sEohkR4xUoFvHKTKStDB1Eabhtt3cdYAhiJF/nKaaz8osSlCrNUFntfwanR39WqGeXq6dd5DuB/Qs/SCfZ2mBBPLnd1BZ3UYuIcsaAjQ4qOE6veG6qzcxzplJOHvYbTTbrBZCMeG8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fd0tuWtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fd0tuWtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EFC1F00A3A;
	Wed,  9 Sep 2026 13:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961706;
	bh=Ql2g/TnA5Gx6BvE+RYCeiwkQerv2Og5eC3/SjJM2QH4=;
	h=From:To:Cc:Subject:Date;
	b=Fd0tuWttSChRJu0d63IK57pUMv5ne2tFgqJYZe5yv7KX2OVXoKFm6ccf/EK5qHI7T
	 6e21OG85M602Esad6h+vQtq/4qSfFMZY09omLsipPaqNVAJK90A0qxkM+diGX1NGf0
	 6auqHftSRqC/HiavM3rWfwb952Miw9TqIvb5Frzc=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 7.2 000/556] 7.2.5-rc1 review
Date: Wed,  9 Sep 2026 15:34:40 +0200
Message-ID: <20260909134230.441546314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.5-rc1
X-KernelTest-Deadline: 2026-09-11T13:42+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.5 release.
There are 556 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.5-rc1

Farhan Ali <alifm@linux.ibm.com>
    PCI: Allow per function PCI slots to fix slot reset on s390

Farhan Ali <alifm@linux.ibm.com>
    PCI: Introduce PCI_SLOT_PLACEHOLDER constant for slot_nr placeholder value

SJ Park <sj@kernel.org>
    mm/damon/vaddr: drop last same folio access check optimization

SJ Park <sj@kernel.org>
    mm/damon/paddr: drop last same folio access check reuse optimization

SJ Park <sj@kernel.org>
    mm/damon/ops-common: use nr_accesses moving sum for quota score

SJ Park <sj@kernel.org>
    mm/damon/core: avoid infinite kdamond_merge_regions() internal loop

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: ab8500_fg: fix use-after-free on remove

Pan Chuang <panchuang@vivo.com>
    power: supply: ab8500_fg: Remove redundant dev_err()/dev_err_probe()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: qcom: pas: Guard dtb metadata release with dtb_pas_id check

Chuck Lever <cel@kernel.org>
    rpcrdma: arm rn_done before publishing the notification

Jiri Olsa <jolsa@kernel.org>
    bpf: Disable preemption in bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Use stack id functions instead of __bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor stackid_new_bucket from __bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor stackid_fastpath function from __bpf_get_stackid

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor stackid_init function from __bpf_get_stackid

Abdifatah Suruur <suruurism@gmail.com>
    ksmbd: fix use-after-free in oplock break notification

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/gsp: fix vblank interrupts on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: fix head state readback on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: fix HDMI GCP AVMute register offsets on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: fix HDMI vendor infoframes on GB20x

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: route GSP-RM display MMIO through nvkm_disp_func hooks

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: move the GSP HDMI GCP AVMute write to engine/disp

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/disp: move GSP head-timing ISR and vblank helpers to tu102.c

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: clear the dirty flag when unwinding an OP_UNMAP_SPARSE

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: fix premature region free on failed OP_UNMAP_SPARSE

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: fix NULL deref unwinding an OP_MAP_SPARSE op

Faith Ekstrand <faith.ekstrand@collabora.com>
    drm/nouveau: Use write-combined maps for coherent

Marek Czernohous <marek@czernohous.de>
    drm/nouveau: unsubscribe the channel-kill event before the fence context

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau/gsp: use per-version DP_CONFIG_STREAM params on r570 firmware

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/dmem: fix mismatched DMA unmap size for large folios

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/dmem: fix callocated underflow on large folio split

Matthew Brost <matthew.brost@intel.com>
    drm/pagemap: Fix folio allocation fallback and use-after-put

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve stride validation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve panel-size validation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve framebuffer-size validation

Sunday Clement <Sunday.Clement@amd.com>
    drm/amdkfd: Reject zero-sized AQL queue allocations after size halving

Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
    drm/amdkfd: guard against NULL restore_mqd in CRIU queue restore

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdkfd: fix scope of mqd_mgr dereference in pqm_debugfs_mqds

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix error path at svm_migrate_copy_to_ram

Priya Hosur <Priya.Hosur@amd.com>
    drm/amdkfd: Add TLB flush after MES queue eviction/suspension

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: update the fw version for gfx12 userqueues

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: update the fw version for gfx11 userqueues

Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>
    drm/amdgpu: Skip accessing psp rum time db for APUs

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: force complete the MES ring fences on reset

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: force complete the KIQ ring fences on reset

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: fix Idle BOs list in VM debugfs status info

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: fix byte/dword unit mismatch in coredump IB dump

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix autosuspend cleanup during removal

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: Disable runtime PM for externally attached dGPUs

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: clamp the isolation index for rings outside a partition

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: delay ttm buffer func enablement on xgmi

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: check thunderbolt before switcheroo registration

Matthew Brost <matthew.brost@intel.com>
    drm/ttm: Drop tt->restore after successful restore

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_crtc_commit leak if signaled when PAGE_FLIP_EVENT is used

Kavan Smith <kavansmith82@gmail.com>
    drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value

Tao Yu <tao1.yu@intel.com>
    drm/gud: validate TV mode names before creating enum property

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/gud: NUL-terminate TV mode names read from the device

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu/vcn: fix integer overflow in dec_msg buffer count check

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx8: only apply compute quantums to KCQs

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Set gpuvm min page size to 4K on dcn35/36

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: Remove const Qualifier From Non-Pointer Fields

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: validate plane degamma LUT size for private color prop

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix HPD consideration for VGA/LVDS connectors on DCE

Linkai Gong <gonglinkai@kylinos.cn>
    drm/amd/display: fix dc_lock leak on GPU reset error paths

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: avoid divide-by-zero in __is_lut_linear()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hibmc: Use drm_atomic_helper_check_plane_state()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hibmc: Fix list of formats on the primary plane

Lyude Paul <lyude@redhat.com>
    drm/nouveau/disp/r535: Add scanline position support + head state support

Amit Barzilai <amit.barzilai22@gmail.com>
    drm/ssd130x: fix column and row end address in partial updates in ssd133x

Wentao Liang <vulab@iscas.ac.cn>
    drm/sun4i: fix refcount leak in sun4i_backend_init_sat()

Amit Barzilai <amit.barzilai22@gmail.com>
    drm/ssd130x: fix column and row end address in partial updates for ssd132x

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/i915: Guard against NULL driver_data in i915_pci_probe()

Nemesa Garg <nemesa.garg@intel.com>
    drm/i915/display: Clear SEL_FETCH_PLANE_CTL on plane disable

Danilo Krummrich <dakr@kernel.org>
    drm: fix race between partial drm_dev_register() failure and ioctl

Johan Hovold <johan@kernel.org>
    drm/panel-edp: fix i2c adapter leak on probe failure

Johan Hovold <johan@kernel.org>
    drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: fix firmware control interface bounds checks

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: harden firmware build-info bounds checks

Matthew Auld <matthew.auld@intel.com>
    drm/xe/vram: report FLAT_CCS base misalignment

Bob Zhou <bobzhou2@amd.com>
    drm/amdgpu: avoid force-completing uninitialized UVD rings

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/amdgpu: Fix init ordering in amdgpu_vram_mgr_init()

Chao Yu <chao@kernel.org>
    f2fs: fix to zero post-EOF data when extending file size

Chao Yu <chao@kernel.org>
    f2fs: fix to pass folio->index to f2fs_sanity_check_node_footer()

Chao Yu <chao@kernel.org>
    f2fs: fix to reclaim space in f2fs_allocate_pinning_section()

Chen Changcheng <chenchangcheng@kylinos.cn>
    f2fs: fix valid block count leak on data block allocation failure

Wenjie Qi <qwjhust@gmail.com>
    f2fs: protect critical_task_priority updates with s_umount

Chao Yu <chao@kernel.org>
    f2fs: fix to clear dirty flag on folio in error path

Chao Yu <chao@kernel.org>
    f2fs: fix to off-by-one issue in f2fs_zero_post_eof_page()

Chao Yu <chao@kernel.org>
    f2fs: fix to return -EFSCORRUPTED in f2fs_get_node_info() correctly

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: fix i_size when pinned fallocate partially fails

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()

Daeho Jeong <daehojeong@google.com>
    f2fs: fix to migrate all curseg types during free_segment_range

Wenjie Qi <qwjhust@gmail.com>
    f2fs: avoid NULL checkpoint thread access in sysfs

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    f2fs: fix folio_nr_pages() race after put in large folio invalidate

Guanghui Yang <3497809730@qq.com>
    f2fs: fix dentry folio leak in find_in_level

Chao Yu <chao@kernel.org>
    f2fs: embed f2fs_gc_kthread in f2fs_sb_info

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential section-unaligned pinfile

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: don't drop the top folio order in the f2fs_iostat tracepoint

Wenjie Qi <qwjhust@gmail.com>
    f2fs: limit recovery filename logging to stored length

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return writeback error from collapse range

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: use the mount idmap for the owner check in f2fs_xattr_advise_set()

Joanne Chang <joannechien@google.com>
    f2fs: dirty directory inodes on mtime/ctime update

Wenjie Qi <qwjhust@gmail.com>
    f2fs: validate MOVE_RANGE destination size

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid move_range and defragment on device_alias file

Wenjie Qi <qwjhust@gmail.com>
    f2fs: only redirty pinned folios in redirty_blocks

Hao-Qun Huang <alvinhuang0603@gmail.com>
    f2fs: reject overlapping move range after len expansion

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return symlink writeback errors

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Drop vport reference under lock in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid double completion in async IOCB timeout

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Quiesce response IRQ before freeing request queue

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix response queue over-consumption in __qla_consume_iocb()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Don't query firmware state while chip is down

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix FCE trace enable parsing in debugfs

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix cs84xx use-after-free on host teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Serialize flash version read in reset handler

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Initialize NVMe abort_work once at submission

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix BSG job leak on validate flash image error path

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound i2c->length in I2C bsg handlers

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Resume device before setting EOS flag

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Fix pipeline stall when queuing fails

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Defer job_finish() only when a DEC_PIC was queued

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Add timeout while stop_streaming

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: avoid skipping device_run while VPU has work

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Set inst->std during default format initialization

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Guard bit depth check with initial_info_obtained

Wangao Wang <wangao.wang@oss.qualcomm.com>
    media: qcom: iris: fix missing hfi_id in gen1 GOP_SIZE cap

Hungyu Lin <dennylin0707@gmail.com>
    media: qcom: iris: use disable_irq() during power-off

Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
    media: qcom: iris: fix state-change debug log printing stale value

Ruoyu Wang <ruoyuw560@gmail.com>
    media: zoran: Avoid freeing a registered video_device twice

Arash Golgol <arash.golgol@gmail.com>
    media: vimc: fix pixel format lookup in enum_framesizes

Uday Khare <udaykhare77@gmail.com>
    media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure

Mohammed EL Kadiri <med08elkadiri@gmail.com>
    media: venus: fix payload size calculation in parse_raw_formats()

Mohammed EL Kadiri <med08elkadiri@gmail.com>
    media: venus: fix payload size returned by parse_caps() and parse_alloc_mode()

Biren Pandya <birenpandya@gmail.com>
    media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link

Ming Qian <ming.qian@oss.nxp.com>
    media: v4l2-ctrls: Allow unknown HDR10 white point and luminance

Michael Bommarito <michael.bommarito@gmail.com>
    media: v4l2-ctrls: validate HEVC EXT SPS RPS counts

Xu Rao <raoxu@uniontech.com>
    media: v4l2-async: avoid deleting unlinked ASC entry on link error

Fan Wu <fanwu01@zju.edu.cn>
    media: ti: vpe: quiesce overflow recovery before freeing streams

Ilya Krutskih <devsec@tpz.ru>
    media: tda18250: fix possible integer overflow

Guangshuo Li <lgs201920130244@gmail.com>
    media: saa7164: fix cleanup on resource allocation failure

Lei Huang <huanglei@kylinos.cn>
    media: s2255: check firmware size before reading trailing marker

HyeongJun An <sammiee5311@gmail.com>
    media: s2255: bound JPEG frame size before copying into the buffer

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    media: rzg2l-cru: Align bytesperline to hardware DMA stride requirement

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: release URBs and stream buffers on start_streaming() failure

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: use vb2_video_unregister_device() on remove to fix DMA leak

Michael Bommarito <michael.bommarito@gmail.com>
    media: rkvdec: hevc: guard INTER_REF_PIC_SET_PRED index underflow

Michael Bommarito <michael.bommarito@gmail.com>
    media: rkvdec: hevc: tighten EXT SPS RPS control dimensions

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: rkvdec: Propagate platform_get_irq() errors

Sven Püschel <s.pueschel@pengutronix.de>
    media: rockchip: rga: don't change RGB quantization

Myeonghun Pak <mhun512@gmail.com>
    media: rc: sunxi-cir: Unregister rc device on probe failure

David Carlier <devnexen@gmail.com>
    media: mali-c55: Fix scaler factor overflow for large crop sizes

David Carlier <devnexen@gmail.com>
    media: mali-c55: Fix AEXP IHIST disable bit shift

David Carlier <devnexen@gmail.com>
    media: mali-c55: Fix clock leak on reset deassert failure

David Carlier <devnexen@gmail.com>
    media: mali-c55: fix dropped last AEC histogram zone weight

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Use BIT_ULL() for 64-bit stream masks

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Correct color map between V4L2 and ISI

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Fix stream ID validation bypass in crossbar routing

Johan Hovold <johan@kernel.org>
    media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup

Guangshuo Li <lgs201920130244@gmail.com>
    media: platform: mtk-mdp3: Fix SCP device refcounting

Christian Hewitt <christianshewitt@gmail.com>
    media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: iris: Enumerate cap->bus_info to differentiate between encoder and decoder

José María Martín <jmmartinf@hotmail.com>
    media: ipu-bridge: check all DMI entries when overriding sensor rotation

Cong Nguyen <congnt264@gmail.com>
    media: intel/ipu6: fix async notifier cleanup leak on parse error

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: imx355: Avoid calling imx355_power_off twice in error path

Benjamin Mugnier <benjamin.mugnier@foss.st.com>
    media: i2c: vd55g1: Fix media bus code initialization

Benjamin Mugnier <benjamin.mugnier@foss.st.com>
    media: i2c: vd55g1: Fix manual digital gain on color variant

Richard Leitner <richard.leitner@linux.dev>
    media: i2c: ov9282: restore flash duration calculation

Biren Pandya <birenpandya@gmail.com>
    media: i2c: ov7740: fix use-after-destroy in remove

Biren Pandya <birenpandya@gmail.com>
    media: i2c: ov02a10: fix endpoint parsing use-after-free

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: i2c: imx415: Return test pattern write errors

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: i2c: imx415: Release runtime PM reference on VBLANK error

Martin Hecht <mhecht73@gmail.com>
    media: i2c: alvium: Fix: Correct name of register in alvium_set_ctrl_auto_exposure

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: go7007: defer the ALSA v4l2 put until card release

Jiangong.Han <jiangong.han@windriver.com>
    media: em28xx: fix use-after-free of dev_next->devlist on disconnect

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    media: em28xx: defer audio-only extension registration

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: dt-bindings: nxp,imx8-isi: Drop fsl,blk-ctrl requirement for i.MX8ULP

Fan Wu <fanwu01@zju.edu.cn>
    media: cx23885: cancel NetUP CI work before teardown

Bryam Vargas <hexlabsecurity@proton.me>
    media: cx231xx: reject geometry changes while the VBI queue is busy

Ruoyu Wang <ruoyuw560@gmail.com>
    media: cobalt: Avoid freeing ALSA private data twice

Dawei Feng <dawei.feng@seu.edu.cn>
    media: cedrus: fix memory leak in cedrus_init_ctrls()

Ruoyu Wang <ruoyuw560@gmail.com>
    media: cec: Serialize exclusive follower delivery

Yi Ding <yi.s.ding@gmail.com>
    media: cec: meson: ao-cec-g12a: name the CEC core regmap to avoid debugfs clash

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec: extron-da-hd-4k-plus: add sanity check

Biren Pandya <birenpandya@gmail.com>
    media: cec: disable delayed work before freeing an interrupted transmit

Jonas Karlman <jonas@kwiboo.se>
    media: cec: core: Fix kmemleak due to missed rc_free_device() call

Eugen Hristev <ehristev@kernel.org>
    media: bcm2835-unicam: Fix pipeline wrong validation for unpacked formats

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Remove obsolete frame_count check in venc_start_session

Valery Borovsky <vebohr@gmail.com>
    media: airspy: use vb2_video_unregister_device() on disconnect to fix NULL deref

Danilo Krummrich <dakr@kernel.org>
    rust: drm: ioctl: fix unbounded lifetimes in ioctl handler arguments

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    LoongArch: Avoid preempt count underflow without probe

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: Do not save/restore percpu base register in rethook trampoline

Nathan Chancellor <nathan@kernel.org>
    LoongArch: Do not select HAVE_RUST when KASAN is enabled

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Fix acpi_package_ids[] array overflow

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Fix off-by-one error for insn_is_cast_user()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Move arena register slot below TCC context

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Expand module virtual address space to 2GB

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Refactor jump offset calculation in tail call

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Optimize redundant TCC loads in epilogue

Han Gao <gaohan@iscas.ac.cn>
    LoongArch: Add DIRECT_MAP_PHYSMEM_END definition

Zeng Chi <zengchi@kylinos.cn>
    LoongArch: KVM: Validate MSI data before routing it to EIOINTC

Zeng Chi <zengchi@kylinos.cn>
    LoongArch: KVM: Preserve memslot arch flags on KVM_MR_FLAGS_ONLY

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    LoongArch: KVM: Free init resources if kvm_init() fails

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Fix TOCTOU race on pv_features

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    LoongArch: KVM: Fix resource leak in kvm_loongarch_env_init() error path

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    LoongArch: KVM: Add unregister helpers for the KVM interrupt devices

Zeng Chi <zengchi@kylinos.cn>
    LoongArch: KVM: Fix PC double advance in kernel MMIO read fast path

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix uninitialized stack variable issue with dmsintc

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Correctly cap TLBI Range to the architural limit

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic: Reset in_kernel on private IRQ allocation failure

Kajetan Puchalski <kajetan.puchalski@arm.com>
    KVM: arm64: vgic: Fix detection of MI on no pending LR

Qihang <q.h.hack.winter@gmail.com>
    KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_tables

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Sign-extend VA for range-based TLBI invalidation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Remove VM-wide VNCR mapping counter

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Make VNCR invalidation participate in MMU invalidation retry

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR unmapping

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Correctly handle end of VA space TLBI invalidation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Handle negative S1 walk levels in VNCR TLB size evaluation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Consider SCTLR_EL2.M when mapping the L1 VNCR page

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Restore sigset on error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: keyop: use mmu_lock to read gmap->asce

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory corruption by not reinjecting CK machine checks

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize irq in reinject_machine_check

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize data structures for inject_pfault_token

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Take srcu when importing watchpoint data

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Free guest debug data on vcpu destroy

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix old_data leak in guest debug error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory leak in guest debug handling

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix length check __import_wp_info()

Yosry Ahmed <yosry@kernel.org>
    KVM: x86: Move enabling EFER.SVME and EFER.LMSLE to generic EFER setup

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ensure runtime reads of disabled_quirks are resolved once

Sean Christopherson <seanjc@google.com>
    KVM: x86: Serialize writes to disabled_quirks using kvm->lock

Carlos López <clopez@suse.de>
    KVM: x86: hyper-v: Clamp stimer deadline to avoid livelock

Phil Rosenthal <phil@phil.gs>
    KVM: x86/mmu: Consume the locked rmap value in the lockless rmap walk

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use CMPXCHG when clearing Accessed bit in TDP MMU

Yosry Ahmed <yosry@kernel.org>
    KVM: nVM: Ensure INVVPID is emulated on the correct physical CPU

Yosry Ahmed <yosry@kernel.org>
    KVM: nVMX: Service local TLB flushes on failed nested VM-Enter

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Ensure KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Decouple INVVPID operand checks from flushing of vpid02

Yosry Ahmed <yosry@kernel.org>
    KVM: nVMX: Always flush vpid02 on first use

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Validate arch_compat against host compatibility mode

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix reversed GENMASK() arguments in fault count mask

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Reject integration times with a non-zero seconds part

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix incompatible pointer type passed to div_u64_rem()

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix power down clearing bits of the wrong register

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: opt4060: Fix incorrect register name in threshold read error message

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: opt4060: Reject integration times with a non-zero seconds part

Paul Geurts <paul.geurts@prodrive-technologies.com>
    iio: ti-ads7138: Disable STATS_EN bit while reading conversion results

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()

Cong Nguyen <congnt264@gmail.com>
    iio: srf04: fix pm_runtime handling on probe error path

Can Peng <pengcan@kylinos.cn>
    iio: pressure: mpl115: Fix runtime PM cleanup

Rupesh Majhi <zoone.rupert@gmail.com>
    iio: pressure: dps310: fix NULL pointer dereference on ACPI probe

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: ltrf216a: fix runtime PM reference leak in error path

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    iio: light: gp2ap002: Disable regulators on resume failure

Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
    iio: light: cm32181: return zero after writing calibscale

Moksh Panicker <mokshpanicker.7@gmail.com>
    iio: light: apds9306: fix PM reference leak in apds9306_read_data()

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Update enable mask when using sensor fusion

Cong Nguyen <congnt264@gmail.com>
    iio: gyro: mpu3050: fix sign of raw angular velocity readings

Joshua Crofts <joshua.crofts1@gmail.com>
    iio: dac: mcp47feb02: add missing 'select REGMAP_I2C' to Kconfig

Erick Henrique <erick.henrique.rodrigues@usp.br>
    iio: dac: m62332: Fix regulator reference count imbalance

Can Peng <pengcan@kylinos.cn>
    iio: dac: ad5446: fix OF module device table

Babanpreet Singh <bbnpreetsingh@gmail.com>
    iio: dac: ad3552r-hs: fix scnprintf() buffer bound in data source show

Linmao Li <lilinmao@kylinos.cn>
    iio: chemical: sgp30: Handle IAQ thread creation failure

Fan Wu <fanwu01@zju.edu.cn>
    iio: chemical: atlas-sensor: use iio_trigger_poll_nested() to fix remove UAF

Moksh Panicker <mokshpanicker.7@gmail.com>
    iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable

Lars-Peter Clausen <lars@metafoo.de>
    iio: buffer: Tie IIO dma fence lock lifetime to the fence

Lars-Peter Clausen <lars@metafoo.de>
    iio: buffer: Make IIO DMA fence release RCU-safe

Lars-Peter Clausen <lars@metafoo.de>
    iio: buffer: Fix potential use-after-free in anonymous buffer release

Cong Nguyen <congnt264@gmail.com>
    iio: adc: pac1921: fix wrong channel used in trigger handler read

Joshua Crofts <joshua.crofts1@gmail.com>
    iio: adc: max34408: add missing 'select REGMAP_I2C' to Kconfig

Joshua Crofts <joshua.crofts1@gmail.com>
    iio: adc: max14001: add missing 'select REGMAP' to Kconfig

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: adi-axi-adc: add data size support for AD408X backend

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: ad4080: configure backend data size

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2783-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2783-sdw: drop duplicate reg_default entry

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2780: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2764: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tas2552: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: sti-sas: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: sgtl5000: sort the register default table

WenTao Liang <vulab@iscas.ac.cn>
    ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt721-sdca-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt715: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt715-sdca: sort the register default tables

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt715-sdca: drop duplicate reg_default entries

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt712-sdca-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt712-sdca-dmic: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt711: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt711-sdca: sort the register default tables

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt700: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt700: drop duplicate reg_default entry

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt298: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt286: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt274: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1318: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1318-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1316-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: rt1017-sdca-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: pm4125-sdw: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: pcm512x: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: ml26124: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: max9860: sort the register default table

Binbin Zhou <zhoubinbin@loongson.cn>
    ASoC: loongson: Fix error handling in ACPI property parsing

Haoxiang Li <haoxiang_li2024@163.com>
    AsoC: intel: sst: fix PCI device reference leak on probe failure

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: hdac_hda: Fix hlink refcount leak on component registration failure

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: fsl_easrc: sort the register default table

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: fsl_easrc: Use div64_u64 for 64-by-64 division

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: cx2072x: sort the register default table

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: cs35l34: drain threaded IRQ before runtime suspend

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: cs35l33: drain threaded IRQ before runtime suspend

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: adau1761: sort the register default table

Linkai Gong <gonglinkai@kylinos.cn>
    i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-mdm9607: Drop incorrect BIMC PLL and related clocks

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Fix enable_reg for gcc_blsp1_sleep_clk

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Drop incorrect system_noc_bfdcd_clk_src

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Drop incorrect apss_tcu_clk_src

Heiko Stuebner <heiko.stuebner@cherry.de>
    clk: rockchip: rk3588: Don't change PLL rates when setting dclk_vop2_src

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-msm8939: Fix enable_reg for gcc_blsp1_sleep_clk

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-msm8916: Fix enable_reg for gcc_blsp1_sleep_clk

Pedro Kopper <pedro.kopper@microchip.com>
    clk: microchip: mpfs: fix regmap_update_bits() mask/val order

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: align gxbb_32k_clk_sel number of parents with actual count

Akari Tsuyukusa <akkun11.open@gmail.com>
    clk: mediatek: mt8196: Select REGMAP_MMIO for vlpckgen

Pavel Löbl <pavel@loebl.cz>
    clk: clocking-wizard: fix integer overflow in rate calculation

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: prevent CRC corruptions after claim flush

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: fix freeing of claims on meshif deletion

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: avoid unaligned fault in IP extraction

Sven Eckelmann <sven@narfation.org>
    batman-adv: mcast: linearize skbuff for packet generation

Sven Eckelmann <sven@narfation.org>
    batman-adv: mcast: ensure unshared skb for multicast packets

Sven Eckelmann <sven@narfation.org>
    batman-adv: fix TX priority extraction for BATADV_FORW_MCAST

Zhiling Zou <zhilinz@nebusec.ai>
    batman-adv: fix stale receive device on merged fragments

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: rawnand: validate ONFI extended parameter page sections

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: fix H6/H616 controller timings

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: describe tADL and tWHR delays

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: group controller delay tables

Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
    mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: nand: realtek-ecc: add missing MODULE_DEVICE_TABLE()

Xu Rao <raoxu@uniontech.com>
    mtd: mtdoops: free page bitmap when the backing MTD is removed

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: afs: validate v2 image info bounds

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix required lock not held during update of ap_matrix_mdev object

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix potential use of uninitialized apm_filtered bitmap

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix NULL deref in status_show() during queue probe

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix missing lock required to access list of ap_matrix_mdev objects

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix hot-unplug skipped when last AP adapter or domain removed

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix dereference matrix_mdev->kvm without checking for NULL

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix stale do_remove flag across iterations in vfio_ap_mdev_cfg_remove

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix stale pqap_hook pointer on error in vfio_ap_mdev_set_kvm()

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: stop watchdogs before booting kdump kernel

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/pseries: Move H_WATCHDOG definitions to a common header

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/pseries: Handle and log pseries-wdt registration failures

Muchun Song <muchun.song@linux.dev>
    powerpc/mm: fix wrong addr_pfn tracking in compound vmemmap population

Jinjie Ruan <ruanjinjie@huawei.com>
    powerpc/kexec_file: Prevent kexec range truncation

Jinjie Ruan <ruanjinjie@huawei.com>
    powerpc/kexec_file: Fix null-ptr-def in extra size calculation

Helge Deller <deller@gmx.de>
    parisc: Fix alignment of asm statements in head.S

Pei Xiao <xiaopei01@kylinos.cn>
    parisc: eisa: Fix infinite loop when parsing invalid IRQ value

Bryam Vargas <hexlabsecurity@proton.me>
    nvdimm/btt: reject an arena whose nfree is below the lane count

Narek Jilavyan <njilav@gmail.com>
    mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()

Longlong Xia <xialonglong@kylinos.cn>
    mm/hugetlb: keep max_huge_pages when dissolving surplus folios

Sourav Panda <souravpanda@google.com>
    mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio

Wupeng Ma <mawupeng1@huawei.com>
    mm/hugetlb: fix missing migratable flag on same-node hugetlb migration

Hui Su <sh_def@163.com>
    mm/migrate_device: avoid out-of-bounds writes for compound folios

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs

Abel Vesa <abel.vesa@oss.qualcomm.com>
    Revert "pmdomain: qcom: rpmhpd: Add missing MXC and MMCX power domains for Eliza"

Eric Dumazet <edumazet@google.com>
    Revert "once: don't use a work queue to reset sleepable static key"

caina <caina@uniontech.com>
    Revert "irqchip/mbigen: Fix mbigen node address layout"

Christian Marangi <ansuelsmth@gmail.com>
    pmdomain: airoha: fix unselectable AIROHA_CPU_PM_DOMAIN kconfig

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvmet-tcp: reject unsolicited H2CData PDUs

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvmet-tcp: fix out-of-bounds write when receiving an over-long PDU

Kazuki Hanai <hnkz.64@gmail.com>
    nvmet-auth: Synchronize timeout work during SQ teardown

Chao Shi <coshi036@gmail.com>
    nvme: skip the zoned limits update if the zone info query failed

Tristan Madani <tristan@talencesecurity.com>
    nvme: add missing SRCU grace period in error path

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: check the data direction of a C2HData PDU

Niklas Cassel <cassel@kernel.org>
    nvme-fc: fix double free of fabrics options when nvme_add_ctrl() fails

Xu Rao <raoxu@uniontech.com>
    nvme-fabrics: fix DHCHAP secret leak on parse failure

GuoHan Zhao <zhaoguohan@kylinos.cn>
    accel/ethosu: fix job completion fence cleanup

GuoHan Zhao <zhaoguohan@kylinos.cn>
    accel/ethosu: check MMIO mapping errors in probe

Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
    accel/amdxdna: return early from a zero-length flush

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Allow splice reads on static buffers

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix race between non-atomic ops and trigger-start

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: harmony: initialize locks before requesting IRQ

HyeongJun An <sammiee5311@gmail.com>
    ALSA: rawmidi: Return the error from snd_rawmidi_input_params()

Khushit Shah <khushit.shah@nutanix.com>
    arm64: errata: pass REVIDR when matching target implementation CPUs

Fuad Tabba <fuad.tabba@linux.dev>
    arm64: Don't read GMID_EL1 when MTE is disabled

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: mm: Fix the lockless page-table walk in show_pte()

Guangshuo Li <lgs201920130244@gmail.com>
    i2c: qcom-cci: fix autosuspend cleanup

Ahmad Byagowi <ahmadexp@gmail.com>
    i2c: mux: Fix channel node leak on adapter add failure

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    i2c: core: fix debugfs UAF on adapter removal

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    i2c: qcom-geni: update frequency table to fix timing parameters

Hongbo Yao <andy.xu@hj-micro.com>
    i2c: designware: Enable interrupt mask workaround for HJMC3001

Yilin Zhang <yilinzhang@moonshot.ai>
    perf: Fix use-after-free when perf mmap() revival races with the last munmap()

Haiyong Sun <sunhaiyong@loongson.cn>
    perf build: Add clang and rust target flags for LoongArch

Sizhe Liu <liusizhe5@huawei.com>
    perf hisi-ptt: Fix PTT trace TLP header parsing

Viktor Malik <vmalik@redhat.com>
    perf trace: Refactor augmented_raw_syscalls using bpf_for

Viktor Malik <vmalik@redhat.com>
    perf trace: Factor out BPF loop body

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix kernel address leakages in LBR stack

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Handle unset alarm weekday in rzn1_rtc_read_alarm

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Fix weekday underflow when alarm crosses month boundary

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Handle EPROBE_DEFER for optional pps interrupt

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: make the v1 soft limit knob inert

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: keep folio's objcg same as its node

Eric Dumazet <edumazet@google.com>
    mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()

Usama Arif <usama.arif@linux.dev>
    mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Baineng Shou <shoubaineng@gmail.com>
    misc: fastrpc: don't publish fd before copy_to_user() succeeds

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Protect kprobe_blacklist with RCU

Ju Nan <junan76@163.com>
    irqchip/stm32mp-exti: Fix the unit of the hwspinlock timeout

Bradley Morgan <brads@mainlining.org>
    ima: Check for ERR_PTR from dentry_path() in validate_hash_algo()

Hajo Noerenberg <hajo-linux-ide@noerenberg.de>
    ata: ahci: work around lost interrupts on Marvell 88SE61xx

Max Kellermann <max.kellermann@ionos.com>
    ceph: lock mutex in ceph_mds_check_access()

Hui Su <sh_def@163.com>
    bpf: Fix infinite loop in pcpu_freelist push with one possible CPU

Chen Pei <cp0613@linux.alibaba.com>
    bpf, riscv: Make arena support depend on ZACAS

Damien Le Moal <dlemoal@kernel.org>
    block: flag zoned disks with GENHD_FL_NO_PART

Ulf Hansson <ulf.hansson@oss.qualcomm.com>
    cpuidle: psci: Fix support for probe deferral by dropping the faux device

Linkai Gong <gonglinkai@kylinos.cn>
    cpuidle: dt_idle_genpd: kfree() the original name allocation

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Mark emulated IRQ as level-triggered

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Initialize IRQ data before requesting IRQs

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Complete descriptors before pausing

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Fix HDMA channel status register access

Martin Kaiser <martin@kaiser.cx>
    dmaengine: fsl-edma: tracing: no ptr dereference during log output

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    dma-direct: return struct page from dma_direct_alloc_from_pool()

Baineng Shou <shoubaineng@gmail.com>
    dma-buf: dma-heap: don't publish fd before copy_to_user() succeeds

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix resume-vs-remove race

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix race when loading and unloading a table

Ibrahim Hashimov <security@auditcode.ai>
    HID: wacom: validate report length in wacom_intuos_pro2_bt_irq

Wei Jie Law <98lawweijie@gmail.com>
    HID: rmi: fix OOB access with undersized RMI reports

Shen Yongchao <grayhat@foxmail.com>
    HID: bpf: serialize device reference release in struct_ops destroy path

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Synchronize the initialization of ftrace_ops

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Take trace_array reference before accessing its ftrace_ops

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Provide rt_mutex_.*_schedule() equivalents for futex scheduling

Yao Kai <yaokai34@huawei.com>
    futex: Prevent rcuwait use-after-free during requeue PI

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/secretmem: properly account locked pages

SJ Park <sj@kernel.org>
    mm/damon/core: initialize damos->last_applied

SJ Park <sj@kernel.org>
    mm/damon/core: handle region split failure in apply_min_nr_regions()

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: skip wrong region walk in commit_target_regions()

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: handle region split failure in filter_out()

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: check region count before testing in split_at()

SJ Park <sj@kernel.org>
    mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs: kobject_del() region and target (error) dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme region dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme filter dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs

SJ Park <sj@kernel.org>
    samples/damon/wsse: stop and free damon ctx when damon_call() fails

SJ Park <sj@kernel.org>
    samples/damon/wsse: handle damon_start() failure

SJ Park <sj@kernel.org>
    samples/damon/prcl: stop and free damon ctx when damon_call() fails

SJ Park <sj@kernel.org>
    samples/damon/prcl: handle damon_start() failure

SJ Park <sj@kernel.org>
    samples/damon/mtier: handle damon_stop() failure

SJ Park <sj@kernel.org>
    samples/damon/mtier: handle damon_start() failure

SJ Park <sj@kernel.org>
    mm/damon/vaddr-kunit: check region count in three_regions test

SJ Park <sj@kernel.org>
    mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()

SJ Park <sj@kernel.org>
    mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()

SJ Park <sj@kernel.org>
    mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()

Song Hu <husong@kylinos.cn>
    Docs/ABI/damon: fix typo in intervals_goal sysfs path

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: pm8001: Use rollback index when freeing MSI-X vectors

Thomas Lamprecht <t.lamprecht@proxmox.com>
    scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame

Rahul Chandelkar <rc@rexion.ai>
    scsi: bsg: Fix TOCTOU in io_uring passthrough command setup

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: bsg: Cap io_uring sense copy to max_response_len

Sujal Tuladhar <sujaltuladhar1231@gmail.com>
    scsi: target: iscsi: Reserve a terminator byte for the login payload

Honghui Jiang <jiang_hh2019@163.com>
    spi: Fix DMA mapping ownership on partial map failure

Can Peng <pengcan@kylinos.cn>
    spi: bcmbca-hsspi: disable clocks on resume failure

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx: disable clock on resume failure

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx-hsspi: disable clocks on resume failure

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Use HW PROG_RAM_DEPTH to validate firmware size

Paul Louvel <paul.louvel@bootlin.com>
    soc: fsl: qe: Add chained_irq_{enter,exit}() calls in cascade handler

Kanishka De Silva <kpskanna1915@gmail.com>
    ublk: clear VM_MAYWRITE on read-only ublk char device mmap

Bryan Lim <foxieflakey@gmail.com>
    userfaultfd: reset err to be 0 when move_pages_ptes succeeded

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening options file

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have show_event_filters/triggers files take trace array ref

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix anon_stack check for unnamed bitfields in btf_find_struct_member

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/qoriq: Disable clock on resume failure

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/imx: Disable clock on runtime resume failure

Arthur Gautier <baloo@superbaloo.net>
    xhci: fix lost bounce buffers on TDs spanning several ring segments

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read / stack overflow in rtw_get_wps_attr()

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: fix null pointer dereference in usb_put_function_instance()

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_midi: initialize work in f_midi_alloc()

Ivy Lopez <skunkolee@gmail.com>
    usb: gadget: f_midi2: fix use-after-free in string attribute show path

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()

Aleksandr Nogikh <nogikh@google.com>
    usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Fix OOB altmode array index

Sven Peter <sven@kernel.org>
    usb: typec: tipd: Fix Thunderbolt altmode VDOs for cd321x

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: qcom-pmic: cancel reset_work on stop

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: qcom-pmic-typec: drain cc_debounce_dwork if port_start() fails

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: qcom-pmic-typec: disable cc_debounce_dwork on stop

Marek Vasut <marex@nabladev.com>
    usb: typec: mux: Fix typec_switch_match()

Marek Vasut <marex@nabladev.com>
    usb: typec: mux: avoid duplicated mux switches

Chang Wu <kunjinkao.jp@gmail.com>
    usb: typec: hd3ss3220: track VBUS enable state per consumer

Myeonghun Pak <mhun512@gmail.com>
    usb: storage: realtek_cr: fix use-after-free on disconnect

Elson Serrao <elson.serrao@oss.qualcomm.com>
    usb: dwc3: clear forceRM when issuing EndTransfer

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: google: Initialise probe properties with DWC3_DEFAULT_PROPERTIES

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix wakeup from S3 after controller context loss

Liu Qi <liuqi@longcheer.com>
    usb-storage: ene_ub6250: fix race between scan work and probe

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: usbtv: keep device alive while ALSA card exists

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Increase delay for USB PHY reset

HyeongJun An <sammiee5311@gmail.com>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: image: mdc800: change kmalloc() to kzalloc()

Hari Mishal <harimishal1@gmail.com>
    drm/amd/display: fix division by zero in get_estimated_bw()

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during blocked-lock reaping

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during close_lru reaping

Chuck Lever <cel@kernel.org>
    NFSD: Consolidate the revocation-path client unpin

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during export state revocation

Chuck Lever <cel@kernel.org>
    NFSD: Guard admin state-revocation walks with NFSD_NET_UP

Chuck Lever <cel@kernel.org>
    NFSD: Annotate caller preconditions for the state-table walkers

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Forcefully invalidate SNP VMSA if its backing gmem page is zapped

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use split "zap all fast" helpers when invalidating memslot

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Split kvm_mmu_zap_all_fast() into "front" and "back" halves

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Fold kvm_mmu_zap_memslot() into kvm_arch_flush_shadow_memslot()

Rong Zhang <i@rong.moe>
    ACPI: battery: Protect all properties with a separated mutex

Rong Zhang <i@rong.moe>
    ACPI: battery: Use kstrtoul() over sscanf("%lu\n")

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: clean up device list on probe failure

Rosalie Wanders <rosalie@mailbox.org>
    HID: sony: use guard() and scoped_guard()

Sam Edwards <cfsworks@gmail.com>
    ceph: properly decrypt filenames in vmalloc() buffers

David Carlier <devnexen@gmail.com>
    zram: fix slot lock bit position on big-endian 64-bit

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    zram: move lockmap to be per-zram instead per table

Neill Kapron <nkapron@google.com>
    usb: gadget: f_fs: Fix Use-After-Free in AIO error path

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: ffs: fix mm lifetime handling

Brendan Jackman <brendan.jackman@linux.dev>
    mm/page_alloc: don't spin_trylock() in NMI on UP

Linus Torvalds <torvalds@linux-foundation.org>
    drm/xe: Don't hand out the flat CCS storage as usable VRAM

HE WEI（ギカク） <skyexpoc@gmail.com>
    fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()

Norbert Szetei <norbert@doyensec.com>
    net: skbuff: don't skb_tx_error() the source skb in skb_zerocopy()


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   8 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |  49 +----
 .../devicetree/bindings/media/nxp,imx8-isi.yaml    |   4 +-
 Documentation/trace/hisi-ptt.rst                   |  28 +--
 .../media/v4l/ext-ctrls-colorimetry.rst            |  12 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/cpu.h                       |   1 +
 arch/arm64/include/asm/cpufeature.h                |   7 -
 arch/arm64/include/asm/kvm_host.h                  |   3 -
 arch/arm64/include/asm/kvm_nested.h                |  20 ++
 arch/arm64/kernel/cpu_errata.c                     |   2 +-
 arch/arm64/kernel/cpufeature.c                     |  33 +++-
 arch/arm64/kernel/cpuinfo.c                        |   2 +-
 arch/arm64/kvm/at.c                                |   2 -
 arch/arm64/kvm/hyp/vhe/switch.c                    |   3 +-
 arch/arm64/kvm/nested.c                            | 139 +++++++++-----
 arch/arm64/kvm/sys_regs.c                          |  11 ++
 arch/arm64/kvm/vgic/vgic-init.c                    |   1 +
 arch/arm64/kvm/vgic/vgic-its.c                     |   8 +
 arch/arm64/kvm/vgic/vgic-v3-nested.c               |   2 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  12 +-
 arch/arm64/mm/fault.c                              |  12 +-
 arch/loongarch/Kconfig                             |   2 +-
 arch/loongarch/include/asm/kvm_dmsintc.h           |   1 +
 arch/loongarch/include/asm/kvm_eiointc.h           |   1 +
 arch/loongarch/include/asm/kvm_host.h              |   1 +
 arch/loongarch/include/asm/kvm_ipi.h               |   1 +
 arch/loongarch/include/asm/kvm_pch_pic.h           |   1 +
 arch/loongarch/include/asm/pgtable.h               |   9 +-
 arch/loongarch/kernel/acpi.c                       |   3 +-
 arch/loongarch/kernel/kprobes.c                    |   3 +
 arch/loongarch/kernel/rethook_trampoline.S         |   2 -
 arch/loongarch/kvm/exit.c                          |   1 -
 arch/loongarch/kvm/intc/dmsintc.c                  |   8 +-
 arch/loongarch/kvm/intc/eiointc.c                  |   5 +
 arch/loongarch/kvm/intc/ipi.c                      |   5 +
 arch/loongarch/kvm/intc/pch_pic.c                  |   8 +
 arch/loongarch/kvm/main.c                          |  39 +++-
 arch/loongarch/kvm/mmu.c                           |  10 +
 arch/loongarch/kvm/vcpu.c                          |   8 +-
 arch/loongarch/kvm/vm.c                            |   1 +
 arch/loongarch/mm/init.c                           |  17 +-
 arch/loongarch/net/bpf_jit.c                       |  40 ++--
 arch/parisc/kernel/head.S                          |   1 +
 arch/powerpc/include/asm/papr-watchdog.h           |  64 +++++++
 arch/powerpc/include/asm/reg.h                     |  12 ++
 arch/powerpc/kexec/file_load_64.c                  |   2 +-
 arch/powerpc/kexec/ranges.c                        |  12 +-
 arch/powerpc/kvm/book3s_hv.c                       |  15 +-
 arch/powerpc/kvm/powerpc.c                         |   6 +
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   7 +-
 arch/powerpc/platforms/pseries/setup.c             |  28 ++-
 arch/riscv/net/bpf_jit_comp64.c                    |  10 +-
 arch/s390/include/asm/nmi.h                        |   3 +
 arch/s390/kernel/nmi.c                             |   5 +-
 arch/s390/kvm/guestdbg.c                           |   9 +-
 arch/s390/kvm/interrupt.c                          |  26 +--
 arch/s390/kvm/kvm-s390.c                           |  22 ++-
 arch/x86/events/intel/core.c                       |  10 +-
 arch/x86/events/intel/lbr.c                        |  12 +-
 arch/x86/events/perf_event.h                       |   2 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   4 +
 arch/x86/include/asm/kvm_host.h                    |   6 +
 arch/x86/kvm/hyperv.c                              |  25 ++-
 arch/x86/kvm/mmu/mmu.c                             | 107 ++++++-----
 arch/x86/kvm/mmu/tdp_iter.h                        |   7 +
 arch/x86/kvm/mmu/tdp_mmu.c                         |  20 +-
 arch/x86/kvm/svm/sev.c                             |  80 ++++++--
 arch/x86/kvm/svm/svm.c                             |   6 +-
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/vmx/nested.c                          |  75 ++++----
 arch/x86/kvm/x86.c                                 |  17 +-
 arch/x86/kvm/x86.h                                 |   2 +-
 block/genhd.c                                      |   7 +
 drivers/accel/amdxdna/amdxdna_gem.c                |   3 +
 drivers/accel/ethosu/ethosu_drv.c                  |   2 +
 drivers/accel/ethosu/ethosu_job.c                  |  10 +-
 drivers/acpi/battery.c                             | 155 +++++++++++-----
 drivers/ata/ahci.c                                 |  49 +++++
 drivers/block/ublk_drv.c                           |   6 +
 drivers/block/zram/zram_drv.c                      |  27 ++-
 drivers/block/zram/zram_drv.h                      |  16 +-
 drivers/clk/mediatek/Kconfig                       |   1 +
 drivers/clk/meson/gxbb.c                           |   2 +-
 drivers/clk/microchip/clk-mpfs.c                   |   2 +-
 drivers/clk/qcom/gcc-mdm9607.c                     | 182 +-----------------
 drivers/clk/qcom/gcc-msm8916.c                     |   5 +-
 drivers/clk/qcom/gcc-msm8939.c                     |   5 +-
 drivers/clk/rockchip/clk-rk3588.c                  |   2 +-
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c         |   4 +-
 drivers/cpuidle/cpuidle-psci.c                     |  42 ++---
 drivers/cpuidle/dt_idle_genpd.c                    |   3 +-
 drivers/dma-buf/dma-buf.c                          |  20 ++
 drivers/dma-buf/dma-heap.c                         |  80 ++++----
 drivers/dma/dw-edma/dw-edma-core.c                 |  24 ++-
 drivers/dma/dw-edma/dw-hdma-v0-core.c              |   2 +-
 drivers/dma/fsl-edma-trace.h                       |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c   |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  59 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   3 +
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   8 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   3 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  23 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  56 ++++--
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  12 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |  13 ++
 .../dml21/src/dml2_core/dml2_core_shared_types.h   |   4 +-
 .../display/dc/dml2_0/dml2_translation_helper.c    |   1 +
 drivers/gpu/drm/amd/display/dc/link/link_factory.c |   2 +-
 .../display/dc/link/protocols/link_dp_dpia_bw.c    |   5 +
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   3 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   2 +
 drivers/gpu/drm/drm_drv.c                          |  34 +++-
 drivers/gpu/drm/drm_pagemap.c                      | 128 ++++++++++---
 drivers/gpu/drm/gud/gud_connector.c                |  12 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |  54 ++----
 drivers/gpu/drm/i915/display/intel_cursor.c        |  15 +-
 drivers/gpu/drm/i915/display/skl_universal_plane.c |  15 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   3 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  12 ++
 drivers/gpu/drm/nouveau/include/nvkm/engine/disp.h |   1 +
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   9 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |  18 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   6 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  10 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/Kbuild    |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/ga102.c   |  13 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gb202.c   | 191 +++++++++++++++++++
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gv100.c   |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h    |   4 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/ior.h     |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/priv.h    |  17 ++
 drivers/gpu/drm/nouveau/nvkm/engine/disp/tu102.c   |  86 ++++++++-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/disp.c | 129 ++++++-------
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/disp.c |  64 +++++++
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c  |   9 +
 .../nouveau/nvkm/subdev/gsp/rm/r570/nvrm/disp.h    |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/rm.h    |   5 +
 drivers/gpu/drm/panel/panel-edp.c                  |  19 +-
 drivers/gpu/drm/panthor/panthor_fw.c               |  22 ++-
 drivers/gpu/drm/solomon/ssd130x.c                  |   9 +-
 drivers/gpu/drm/sun4i/sun4i_backend.c              |   2 +-
 drivers/gpu/drm/sysfb/ofdrm.c                      |   8 +-
 drivers/gpu/drm/sysfb/simpledrm.c                  |  74 ++++++--
 drivers/gpu/drm/ttm/ttm_pool.c                     |  15 +-
 drivers/gpu/drm/xe/xe_vram.c                       |  26 ++-
 drivers/hid/bpf/hid_bpf_struct_ops.c               |  17 +-
 drivers/hid/hid-rmi.c                              |  46 ++++-
 drivers/hid/hid-sony.c                             |  87 ++++-----
 drivers/hid/wacom_wac.c                            |  13 ++
 drivers/i2c/busses/i2c-designware-platdrv.c        |   2 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |  11 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   4 +-
 drivers/i2c/i2c-core-base.c                        |   6 +
 drivers/i2c/i2c-mux.c                              |   1 +
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/iio/adc/Kconfig                            |   2 +
 drivers/iio/adc/ad4080.c                           |   5 +
 drivers/iio/adc/adi-axi-adc.c                      |  30 +++
 drivers/iio/adc/pac1921.c                          |   2 +-
 drivers/iio/adc/ti-ads7138.c                       |  42 ++++-
 drivers/iio/chemical/atlas-sensor.c                |  19 +-
 drivers/iio/chemical/sgp30.c                       |   3 +
 drivers/iio/dac/Kconfig                            |   1 +
 drivers/iio/dac/ad3552r-hs.c                       |   2 +-
 drivers/iio/dac/ad5446-i2c.c                       |   2 +-
 drivers/iio/dac/m62332.c                           |  17 +-
 drivers/iio/gyro/mpu3050-core.c                    |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_fusion.c     |   5 +
 drivers/iio/industrialio-buffer.c                  |  38 ++--
 drivers/iio/light/apds9306.c                       |   8 +-
 drivers/iio/light/cm32181.c                        |   2 +-
 drivers/iio/light/gp2ap002.c                       |  10 +-
 drivers/iio/light/ltrf216a.c                       |   3 +-
 drivers/iio/light/opt4001.c                        |  37 ++--
 drivers/iio/light/opt4060.c                        |   5 +-
 drivers/iio/pressure/dps310.c                      |   3 +-
 drivers/iio/pressure/mpl115.c                      |  11 +-
 drivers/iio/proximity/srf04.c                      |   1 +
 drivers/iio/temperature/hid-sensor-temperature.c   |   3 +-
 drivers/irqchip/irq-mbigen.c                       |  20 +-
 drivers/irqchip/irq-stm32mp-exti.c                 |   4 +-
 drivers/md/dm.c                                    |  14 +-
 drivers/media/cec/core/cec-adap.c                  |  10 +-
 drivers/media/cec/core/cec-core.c                  |   2 -
 drivers/media/cec/platform/meson/ao-cec-g12a.c     |   1 +
 .../extron-da-hd-4k-plus/extron-da-hd-4k-plus.c    |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  23 ++-
 drivers/media/i2c/alvium-csi2.c                    |   2 +-
 drivers/media/i2c/imx355.c                         |   3 +-
 drivers/media/i2c/imx415.c                         |   4 +-
 drivers/media/i2c/ov02a10.c                        |  12 +-
 drivers/media/i2c/ov7740.c                         |   4 +-
 drivers/media/i2c/ov9282.c                         |   3 +-
 drivers/media/i2c/vd55g1.c                         |  32 +++-
 drivers/media/i2c/video-i2c.c                      |   8 +-
 drivers/media/pci/cobalt/cobalt-alsa-main.c        |   1 -
 drivers/media/pci/cx23885/cimax2.c                 |   1 +
 drivers/media/pci/intel/ipu-bridge.c               |   8 +-
 drivers/media/pci/intel/ipu6/ipu6-isys.c           |   1 +
 drivers/media/pci/saa7164/saa7164-core.c           |   8 +-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 drivers/media/platform/amphion/venc.c              |   2 -
 .../media/platform/arm/mali-c55/mali-c55-core.c    |   2 +
 .../media/platform/arm/mali-c55/mali-c55-params.c  |   1 +
 .../platform/arm/mali-c55/mali-c55-registers.h     |   2 +-
 .../media/platform/arm/mali-c55/mali-c55-resizer.c |   2 +-
 drivers/media/platform/broadcom/bcm2835-unicam.c   |   3 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |  64 +++++--
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |   6 +-
 .../platform/chips-media/wave5/wave5-vpuconfig.h   |   2 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |   6 +-
 .../platform/nxp/imx8-isi/imx8-isi-crossbar.c      |   6 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   2 +-
 drivers/media/platform/qcom/iris/iris_ctrls.c      |   2 +-
 drivers/media/platform/qcom/iris/iris_hfi_gen1.c   |  16 +-
 .../platform/qcom/iris/iris_platform_common.h      |   1 -
 drivers/media/platform/qcom/iris/iris_state.c      |   2 +-
 drivers/media/platform/qcom/iris/iris_vidc.c       |  11 +-
 drivers/media/platform/qcom/iris/iris_vpu_common.c |   2 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     |   9 +-
 .../media/platform/renesas/rzg2l-cru/rzg2l-video.c |   5 +
 drivers/media/platform/rockchip/rga/rga3-hw.c      |  12 +-
 .../platform/rockchip/rkvdec/rkvdec-hevc-common.c  |   3 +
 drivers/media/platform/rockchip/rkvdec/rkvdec.c    |   8 +-
 drivers/media/platform/ti/vpe/vip.c                |  37 +++-
 drivers/media/rc/sunxi-cir.c                       |   9 +-
 drivers/media/test-drivers/vimc/vimc-capture.c     |   4 +-
 drivers/media/tuners/tda18250.c                    |   4 +-
 drivers/media/usb/airspy/airspy.c                  |  19 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   3 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   2 +
 drivers/media/usb/go7007/snd-go7007.c              |  10 +-
 drivers/media/usb/s2255/s2255drv.c                 |  11 ++
 drivers/media/usb/usbtv/usbtv-audio.c              |  11 ++
 drivers/media/v4l2-core/v4l2-async.c               |   1 -
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  64 +++++--
 drivers/media/v4l2-core/v4l2-fwnode.c              |   2 +
 drivers/misc/fastrpc.c                             |  16 +-
 drivers/mtd/mtdoops.c                              |   3 +
 drivers/mtd/nand/ecc-realtek.c                     |   1 +
 drivers/mtd/nand/raw/nand_onfi.c                   |  27 ++-
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   5 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  | 113 +++++++++---
 drivers/mtd/parsers/afs.c                          |   7 +
 drivers/nvdimm/btt.c                               |   8 +
 drivers/nvme/host/core.c                           |  24 ++-
 drivers/nvme/host/fabrics.c                        |   2 +
 drivers/nvme/host/fc.c                             |  26 ++-
 drivers/nvme/host/tcp.c                            |   7 +
 drivers/nvme/target/auth.c                         |   6 +
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/nvmet.h                        |   2 +
 drivers/nvme/target/tcp.c                          |  10 +
 drivers/parisc/eisa.c                              |   5 +
 drivers/pci/hotplug/pnv_php.c                      |   2 +-
 drivers/pci/hotplug/rpaphp_slot.c                  |   2 +-
 drivers/pci/pci.c                                  |   5 +-
 drivers/pci/slot.c                                 |  50 +++--
 drivers/pmdomain/mediatek/Kconfig                  |   5 +-
 drivers/pmdomain/qcom/rpmhpd.c                     |   4 -
 drivers/power/supply/ab8500_fg.c                   |  32 ++--
 drivers/remoteproc/qcom_q6v5_pas.c                 |  13 +-
 drivers/rtc/rtc-rzn1.c                             |  30 ++-
 drivers/s390/crypto/vfio_ap_ops.c                  | 203 ++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_base.c          |  13 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   4 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   6 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  46 +++--
 drivers/scsi/qla2xxx/qla_dbg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  61 ++++++-
 drivers/scsi/qla2xxx/qla_inline.h                  |  13 ++
 drivers/scsi/qla2xxx/qla_isr.c                     |  39 +++-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  28 ++-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  31 +++-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/scsi/scsi_bsg.c                            |  47 +++--
 drivers/soc/fsl/qe/qe_ports_ic.c                   |   7 +
 drivers/soc/qcom/qcom-geni-se.c                    |  24 +--
 drivers/spi/spi-bcm63xx-hsspi.c                    |   8 +-
 drivers/spi/spi-bcm63xx.c                          |   6 +-
 drivers/spi/spi-bcmbca-hsspi.c                     |   8 +-
 drivers/spi/spi.c                                  |  34 ++--
 drivers/staging/media/meson/vdec/vdec.c            |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   7 +
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   3 +
 drivers/target/iscsi/iscsi_target_login.c          |   2 +-
 drivers/thermal/imx_thermal.c                      |   9 +-
 drivers/thermal/qoriq_thermal.c                    |  13 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   | 111 ++++++++++-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   1 +
 drivers/usb/cdns3/cdnsp-mem.c                      |  98 ++++------
 drivers/usb/dwc3/dwc3-google.c                     |   1 +
 drivers/usb/dwc3/ep0.c                             |   2 +-
 drivers/usb/dwc3/gadget.c                          |  21 ++-
 drivers/usb/gadget/function/f_fs.c                 |  31 +++-
 drivers/usb/gadget/function/f_mass_storage.c       |   5 +-
 drivers/usb/gadget/function/f_midi.c               |   2 +-
 drivers/usb/gadget/function/f_midi2.c              |  17 +-
 drivers/usb/gadget/functions.c                     |   2 +-
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 drivers/usb/host/xhci-ring.c                       |  32 +++-
 drivers/usb/image/mdc800.c                         |   4 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +
 drivers/usb/storage/realtek_cr.c                   |   9 +-
 drivers/usb/typec/hd3ss3220.c                      |   9 +-
 drivers/usb/typec/mux.c                            |  21 ++-
 .../usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c    |   2 +
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |   5 +
 drivers/usb/typec/tcpm/tcpm.c                      |  28 ++-
 drivers/usb/typec/tipd/core.c                      |  17 +-
 drivers/usb/typec/tipd/tps6598x.h                  |   4 +-
 drivers/usb/typec/ucsi/displayport.c               |   2 +-
 drivers/watchdog/pseries-wdt.c                     |  53 +-----
 fs/ceph/crypto.c                                   |  50 +++--
 fs/ceph/mds_client.c                               |  12 +-
 fs/ceph/mds_client.h                               |   1 +
 fs/f2fs/data.c                                     |   8 +-
 fs/f2fs/debug.c                                    |   4 -
 fs/f2fs/dir.c                                      |   7 +-
 fs/f2fs/f2fs.h                                     |  29 ++-
 fs/f2fs/file.c                                     | 170 +++++++++++++----
 fs/f2fs/gc.c                                       |  38 ++--
 fs/f2fs/gc.h                                       |  27 +--
 fs/f2fs/inline.c                                   |   2 +-
 fs/f2fs/iostat.c                                   |   6 +
 fs/f2fs/namei.c                                    |  17 +-
 fs/f2fs/node.c                                     |  10 +-
 fs/f2fs/recovery.c                                 |  41 +++--
 fs/f2fs/segment.c                                  |  18 +-
 fs/f2fs/super.c                                    |   4 +-
 fs/f2fs/sysfs.c                                    |  30 +--
 fs/f2fs/xattr.c                                    |   2 +-
 fs/nfsd/nfs4proc.c                                 |   5 +
 fs/nfsd/nfs4state.c                                | 118 ++++++++----
 fs/nfsd/nfsctl.c                                   |   6 +-
 fs/ntfs3/frecord.c                                 |  20 +-
 fs/smb/server/oplock.c                             |  79 ++++++--
 include/linux/dma-buf.h                            |   1 +
 include/linux/ftrace.h                             |   5 +-
 include/linux/kprobes.h                            |   1 +
 include/linux/kvm_host.h                           |   1 +
 include/linux/pci.h                                |   8 +-
 include/linux/sched/rt.h                           |   2 +
 include/linux/sched/user.h                         |   3 +-
 include/linux/soc/qcom/geni-se.h                   |   4 +
 include/trace/events/f2fs.h                        |  20 +-
 kernel/bpf/percpu_freelist.c                       |  35 +++-
 kernel/bpf/percpu_freelist.h                       |   1 +
 kernel/bpf/stackmap.c                              | 173 ++++++++++++------
 kernel/dma/direct.c                                |  18 +-
 kernel/events/core.c                               |  20 +-
 kernel/futex/pi.c                                  |  16 +-
 kernel/futex/requeue.c                             |  12 +-
 kernel/kprobes.c                                   |  14 +-
 kernel/locking/rtmutex_api.c                       |   2 +
 kernel/sched/core.c                                |  16 ++
 kernel/trace/ftrace.c                              |  70 ++++---
 kernel/trace/ring_buffer.c                         |  11 +-
 kernel/trace/trace.c                               |  67 ++++++-
 kernel/trace/trace.h                               |   5 +-
 kernel/trace/trace_btf.c                           |  12 +-
 kernel/trace/trace_events.c                        |  28 ++-
 kernel/trace/trace_functions.c                     |   2 +-
 kernel/trace/trace_stack.c                         |   2 +-
 lib/once.c                                         |   2 +-
 mm/damon/core.c                                    |  27 ++-
 mm/damon/ops-common.c                              |   5 +-
 mm/damon/paddr.c                                   |  20 +-
 mm/damon/sysfs-schemes.c                           |  18 +-
 mm/damon/sysfs.c                                   |  29 ++-
 mm/damon/tests/core-kunit.h                        |  33 +++-
 mm/damon/tests/vaddr-kunit.h                       |   5 +
 mm/damon/vaddr.c                                   |  34 +---
 mm/huge_memory.c                                   |   2 +
 mm/hugetlb.c                                       |  20 +-
 mm/hugetlb_cgroup.c                                |   7 +-
 mm/hugetlb_cma.c                                   |  21 ++-
 mm/khugepaged.c                                    |   6 -
 mm/madvise.c                                       |   8 +
 mm/memcontrol-v1.c                                 |  43 +++--
 mm/memcontrol.c                                    | 113 ++++++++++--
 mm/mempolicy.c                                     |   2 +-
 mm/migrate_device.c                                |  18 ++
 mm/page_alloc.c                                    |   6 +-
 mm/secretmem.c                                     | 116 +++++++++++-
 mm/userfaultfd.c                                   |   4 +-
 net/batman-adv/bridge_loop_avoidance.c             |  15 +-
 net/batman-adv/distributed-arp-table.c             |   8 +-
 net/batman-adv/main.c                              |   4 +
 net/batman-adv/mesh-interface.c                    |   7 +-
 net/batman-adv/multicast_forw.c                    |   7 +-
 net/core/skbuff.c                                  |   5 +-
 net/sunrpc/xprtrdma/ib_client.c                    |  26 ++-
 rust/kernel/drm/ioctl.rs                           |   6 +
 samples/damon/mtier.c                              |  14 +-
 samples/damon/prcl.c                               |  11 +-
 samples/damon/wsse.c                               |  11 +-
 security/integrity/ima/ima_appraise.c              |   2 +
 sound/core/pcm_native.c                            |   2 +
 sound/core/rawmidi.c                               |   2 +-
 sound/parisc/harmony.c                             |   6 +-
 sound/soc/codecs/adau1761.c                        |  34 ++--
 sound/soc/codecs/cs35l33.c                         |  14 +-
 sound/soc/codecs/cs35l34.c                         |  14 +-
 sound/soc/codecs/cx2072x.c                         | 134 +++++++-------
 sound/soc/codecs/hdac_hda.c                        |   4 +-
 sound/soc/codecs/max9860.c                         |   2 +-
 sound/soc/codecs/ml26124.c                         |   4 +-
 sound/soc/codecs/pcm512x.c                         |  40 ++--
 sound/soc/codecs/pm4125-sdw.c                      |   2 +-
 sound/soc/codecs/rt1017-sdca-sdw.h                 |  10 +-
 sound/soc/codecs/rt1316-sdw.c                      |   2 +-
 sound/soc/codecs/rt1318-sdw.c                      |   2 +-
 sound/soc/codecs/rt1318.c                          |   4 +-
 sound/soc/codecs/rt274.c                           |   8 +-
 sound/soc/codecs/rt286.c                           |  14 +-
 sound/soc/codecs/rt298.c                           |  14 +-
 sound/soc/codecs/rt700-sdw.h                       |  11 +-
 sound/soc/codecs/rt711-sdca-sdw.h                  |   6 +-
 sound/soc/codecs/rt711-sdw.h                       |  10 +-
 sound/soc/codecs/rt712-sdca-dmic.h                 |   6 +-
 sound/soc/codecs/rt712-sdca-sdw.h                  |  11 +-
 sound/soc/codecs/rt715-sdca-sdw.h                  |  48 +++--
 sound/soc/codecs/rt715-sdw.h                       |  32 ++--
 sound/soc/codecs/rt721-sdca-sdw.h                  |  44 ++---
 sound/soc/codecs/sgtl5000.c                        |   2 +-
 sound/soc/codecs/sti-sas.c                         |   2 +-
 sound/soc/codecs/tas2552.c                         |  14 +-
 sound/soc/codecs/tas2764.c                         |   2 +-
 sound/soc/codecs/tas2780.c                         |   2 +-
 sound/soc/codecs/tas2783-sdw.c                     | 177 +++++++++---------
 sound/soc/fsl/fsl_easrc.c                          |   8 +-
 sound/soc/fsl/mpc5200_psc_i2s.c                    |   1 +
 sound/soc/intel/atom/sst/sst_pci.c                 |   4 +-
 sound/soc/loongson/loongson_card.c                 |   6 +-
 sound/soc/samsung/aries_wm8994.c                   |   1 +
 sound/usb/midi.c                                   |   2 +
 tools/perf/Makefile.config                         |   2 +
 .../util/bpf_skel/augmented_raw_syscalls.bpf.c     | 155 ++++++++++------
 .../util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c   |  47 ++---
 .../util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h   |  12 ++
 tools/testing/selftests/mm/memfd_secret.c          |  30 +--
 virt/kvm/guest_memfd.c                             |   4 +
 461 files changed, 5681 insertions(+), 2746 deletions(-)


