Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A815A985D;
	Thu, 17 Sep 2026 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658406; cv=none; b=J7TkcrVk+hX7NXiuLz0ZWaUJfsAWQft5hl8AnFme3KIZIV/LcsHkANOnd/Z6ndWKn35baJg3CZ8a0jIR46JkW6xz1/oMEYrZ3GqcN9h1sS1zaU6N0zsxH4BMCDp2szege0VXklYTOGFGefxiejGJpoVvynKh+6zkLVHLaCSr4Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658406; c=relaxed/simple;
	bh=KEWYfwPkWD8XLpyWKrbTKJpdsVy5I4lqio9264m+N08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FZpg1pWrWqVvwLbAaRhuUU0JYzt5xoXm39SVbJVmo9L5c+NNPBSF2Lhr9TkQk8E0k3OR23npwatwdJ5dHasVPqwYLOuNIqhur3bih8eQU0zMD+Xxom2LfqRMMF/e5VVM4M+hr1VcN7T+uls39rzSfeOBdyXfRoLNk28Li8LstOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTd6ySXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTd6ySXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513291F00899;
	Thu, 17 Sep 2026 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658382;
	bh=3Z6/y1ImYaeVhqlktd3SkAyj6CtIFYRMXkq4S9B/jco=;
	h=From:To:Cc:Subject:Date;
	b=XTd6ySXS4uoPOeYdU3wbJ8ouHeJnYyhYWs0PePAMN96DGdiKmt8phSu21hSke+khm
	 SGXwOynxMLxeHCXMMvVlC1/XtjvPBESB+Myz/aufm75NqdLqWpBEg0NYJCROoIwWUw
	 OcFQv/LZHu1TMrb04rklUj6b9bQD8uEEk21M1j98=
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
Subject: [PATCH 6.18 0000/1250] 6.18.53-rc1 review
Date: Thu, 17 Sep 2026 15:56:35 +0100
Message-ID: <20260917151551.901433442@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.53-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.53-rc1
X-KernelTest-Deadline: 2026-09-19T15:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.53 release.
There are 1250 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 19 Sep 2026 15:13:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.53-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.53-rc1

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix and document DEBUG_PAGEALLOC

Griffin Kroah-Hartman <griffin@kroah.com>
    misc: amd-sbi: Add null check for devm_kasprintf()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm/ttm: Fix bo resource use-after-free

Matthew Brost <matthew.brost@intel.com>
    drm/ttm: Drop tt->restore after successful restore

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/ttm: Tidy usage of local variables a little bit

Paulo Alcantara <pc@manguebit.org>
    smb: client: use atomic_t for mnt_cifs_flags

Bjoern Doebel <doebel@amazon.de>
    smb: client: fail DACL rewrite when the new DACL exceeds 64K

Ralph Boehme <slow@samba.org>
    smb/client: fix security flag calculation when setting security descriptors

Ralph Boehme <slow@samba.org>
    smb: client: refactor ACL setting control flow in id_mode_to_cifs_acl()

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent race between disconnect() and rtx

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not reschedule the RTX timer for fallback sockets

Eric Dumazet <edumazet@google.com>
    tcp: remove icsk->icsk_retransmit_timer

Eric Dumazet <edumazet@google.com>
    tcp: introduce icsk->icsk_keepalive_timer

Eric Dumazet <edumazet@google.com>
    tcp: rename icsk_timeout() to tcp_timeout_expires()

Joe Damato <joe@dama.to>
    bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()

Jakub Kicinski <kuba@kernel.org>
    Reapply "bnxt_en: bring back rtnl_lock() in the bnxt_open() path"

Pavan Chebbi <pavan.chebbi@broadcom.com>
    fwctl/bnxt_en: Move common definitions to include/linux/bnxt/

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset retrans_time when ADD_ADDR entry is reused

Norbert Szetei <norbert@doyensec.com>
    landlock: Fix use-after-free of the source's parent directory

Günther Noack <gnoack3000@gmail.com>
    landlock: Use mem_is_zero() in is_layer_masks_allowed()

Günther Noack <gnoack3000@gmail.com>
    landlock: Transpose the layer masks data structure

Günther Noack <gnoack3000@gmail.com>
    landlock: Add access_mask_subset() helper

Günther Noack <gnoack3000@gmail.com>
    landlock: Clarify documentation for the IOCTL access right

Myeonghun Pak <mhun512@gmail.com>
    idpf: disable DIM work before freeing q_vectors

Pavan Kumar Linga <pavan.kumar.linga@intel.com>
    idpf: introduce idpf_q_vec_rsrc struct and move vector resources to it

Pavan Kumar Linga <pavan.kumar.linga@intel.com>
    idpf: introduce local idpf structure to store virtchnl queue chunks

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    idpf: Fix kernel-doc descriptions to avoid warnings

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: add sysfs feature entry for xattr prefixes

Gao Xiang <xiang@kernel.org>
    erofs: separate plain and compressed filesystems formally

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: macb: initialize PTP state before registering clock

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: unify device pointer naming convention

Kevin Hao <haokexin@gmail.com>
    net: macb: Use netif_napi_add_tx() instead of netif_napi_add() for TX NAPI

Kevin Hao <haokexin@gmail.com>
    net: macb: Replace open-coded implementation with napi_schedule()

Daehyeon Ko <4ncienth@gmail.com>
    exit: hold a reference to thread_pid across proc_flush_pid

Christian Brauner <brauner@kernel.org>
    ns: rename to exit_nsproxy_namespaces()

Christian Brauner <brauner@kernel.org>
    ns: add __ns_ref_read()

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: cttimeout: prevent UAF during module unload

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount

Dinh Nguyen <dinguyen@kernel.org>
    EDAC/altera: Use parent device for devres in altr_portb_setup()

Rounak Das <rounakdas2025@gmail.com>
    EDAC/altera: Use ECC manager compatible to select A10/S10 IRQ layout

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Undo the registration when enabling the histogram trigger fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Take the reference before publishing the named histogram trigger

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Set the trace clock before registering the histogram trigger

Steven Rostedt <rostedt@goodmis.org>
    tracing: Merge struct event_trigger_ops into struct event_command

Steven Rostedt <rostedt@goodmis.org>
    tracing: Remove get_trigger_ops() and add count_func() from trigger ops

Javier Tia <javier@peridio.com>
    xfs: initialise args->total for parent pointer updates

Esben Haabendal <esben@geanix.com>
    drm/bridge: ti-sn65dsi83: Fix error handling in sn65dsi83_reset_work()

Satyajit Roy <sroy14@alum.utk.edu>
    drm/amd/display: Honor Broadcast RGB for BT.2020 RGB output

Satyajit Roy <sroy14@alum.utk.edu>
    drm/amd/display: Propagate HDMI RGB quantization selectability

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Flush LSC untyped L1 dataport cache after rcs/ccs batches

Satyajit Roy <sroy14@alum.utk.edu>
    drm/amd/display: Rebuild InfoFrames on output color space changes

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: end write accounting from ->ki_complete

XingWang Xiang <v3rdant.xiang@gmail.com>
    genetlink: pin family module during policy dump

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix integer overflow in initrd size check

Sun Jian <sun.jian.kdev@gmail.com>
    init/main: read bootconfig header with get_unaligned_le32()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    x86/mm/pat: Allocate split page tables as kernel page tables

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    x86/mm/pat: Convert split_large_page() to use ptdescs

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: unhash the dentry before dropping the item in rmdir

Zihan Xi <zihanx@nebusec.ai>
    ipmr: account multicast table and route memory

Matthew Brost <matthew.brost@intel.com>
    drm/pagemap: dma-unmap pages before handling migration errors

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    drm/xe/i2c: Keep the i2c controller always enabled

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    i2c: designware: Global register definitions

Bob Zhou <bobzhou2@amd.com>
    drm/amdgpu: avoid force-completing uninitialized UVD rings

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: plumb timedout fence through to force completion

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Make amdgpu_vm_flush() non-failing in submission path

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: reorder IB schedule sequence

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add a helper to calculate ring distance

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix missing unwind in amdgpu_ib_schedule() error path

Wenjie Qi <qwjhust@gmail.com>
    f2fs: reject setattr size changes on large folio files

Chao Yu <chao@kernel.org>
    Revert: "f2fs: check in-memory block bitmap"

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    fou: Fix use-after-free in fou_create()

Daeho Jeong <daehojeong@google.com>
    f2fs: accurately adjust free_sections during free_segment_range

Chao Yu <chao@kernel.org>
    f2fs: fix to reclaim space in f2fs_allocate_pinning_section()

Chao Yu <chao@kernel.org>
    f2fs: embed f2fs_gc_kthread in f2fs_sb_info

Wenjie Qi <qwjhust@gmail.com>
    f2fs: limit recovery filename logging to stored length

Wenjie Qi <qwjhust@gmail.com>
    f2fs: validate MOVE_RANGE destination size

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip vport under deletion in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path

Hungyu Lin <dennylin0707@gmail.com>
    media: qcom: iris: fix runtime PM reference leaks

Sang-Heon Jeon <ekffu200098@gmail.com>
    media: remove conditional return with no effect

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: turn platform data into constants

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Add timeout while stop_streaming

Weiming Shi <bestswngs@gmail.com>
    net: appletalk: fix NULL pointer dereference in aarp_send_ddp()

Weiming Shi <bestswngs@gmail.com>
    i2c: smbus: reject oversized block transfers in the common path

Gary Guo <gary@garyguo.net>
    net: usb: pegasus: don't rely on id table pointer arithmetic

Gary Guo <gary@garyguo.net>
    media: as102: do not rely on id table address comparison

Gary Guo <gary@garyguo.net>
    usb: serial: spcp8x5: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    usb: usbtmc: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    wifi: ath9k_htc: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    usb: xusbatm: don't rely on id table pointer arithmetic

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Fix union declarations

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: kodiak: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sar2130p: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8650: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8750: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: talos: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: qcs6490-rb3gen2: Fix the PCIe iommu-map entries"

Atish Patra <atishp@meta.com>
    crypto: ccp - Fix possible deadlock in SEV init failure path

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: don't hold ci->m_lock while waiting for a lease break ack

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht4x) Add missing locks

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix UBSAN array-index-out-of-bounds in smb2_copychunk_range

Darrick J. Wong <djwong@kernel.org>
    xfs: actually check internal-rtdev fields in the superblock

Darrick J. Wong <djwong@kernel.org>
    xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent

Darrick J. Wong <djwong@kernel.org>
    xfs: advance the findparent inode scan cursor while holding ILOCK

Darrick J. Wong <djwong@kernel.org>
    xfs: bail out on bitmap errors in xrep_agfl_fill

Darrick J. Wong <djwong@kernel.org>
    xfs: compute dquot checksum after resetting dd_lsn in repair

Darrick J. Wong <djwong@kernel.org>
    xfs: count escaped corruption errors in scrub stats

Darrick J. Wong <djwong@kernel.org>
    xfs: cross-reference the rtgroup superblock extent, not block

Darrick J. Wong <djwong@kernel.org>
    xfs: destroy seen inode bitmap when we fail to add a dirpath

Darrick J. Wong <djwong@kernel.org>
    xfs: don't leak dqacct if rhashtable insertion fails

Darrick J. Wong <djwong@kernel.org>
    xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails

Darrick J. Wong <djwong@kernel.org>
    xfs: don't modify file attributes or poke fsnotify for dry runs

Darrick J. Wong <djwong@kernel.org>
    xfs: don't spin forever on zero-length dirents when salvaging them

Darrick J. Wong <djwong@kernel.org>
    xfs: fix backwards mergeability logic in refcount scrubber

Darrick J. Wong <djwong@kernel.org>
    xfs: fix backwards skipping logic in xrep_quota_block

Darrick J. Wong <djwong@kernel.org>
    xfs: fix bnobt repair space reservation disposal failure

Lin Jiapeng <ljp1205831794@gmail.com>
    xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Darrick J. Wong <djwong@kernel.org>
    xfs: fix name string recording in slowpath pptr tracepoints

Darrick J. Wong <djwong@kernel.org>
    xfs: fix parent rec lookup initialization in xrep_metapath_unlink

Eric Sandeen <sandeen@redhat.com>
    xfs: fix reclaimed page accounting in xfs_buf_free

Darrick J. Wong <djwong@kernel.org>
    xfs: fix replaying dirent removals into the temporary directory

Darrick J. Wong <djwong@kernel.org>
    xfs: fix rtrefcount btree block counting in scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: fix rtrmap cross-referencing elision logic

Darrick J. Wong <djwong@kernel.org>
    xfs: fix short ifork reaping computation in xreap_bmapi_binval

Darrick J. Wong <djwong@kernel.org>
    xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions

Darrick J. Wong <djwong@kernel.org>
    xfs: fix unit conversions in per_binval computation

Darrick J. Wong <djwong@kernel.org>
    xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems

Javier Tia <javier@peridio.com>
    xfs: initialise error in xfs_defer_finish_one()

Darrick J. Wong <djwong@kernel.org>
    xfs: log the tempip after we convert it to extents format

Darrick J. Wong <djwong@kernel.org>
    xfs: make the rtsummary repair fix the file size too

Darrick J. Wong <djwong@kernel.org>
    xfs: preserve owner on in-memory btree creation

Anuj Gupta <anuj20.g@samsung.com>
    xfs: release alleged child inode on metapath unlink error

Darrick J. Wong <djwong@kernel.org>
    xfs: report healthy filesystem events in scrub stats

Darrick J. Wong <djwong@kernel.org>
    xfs: report nonexistent parents as a filesystem corruption

Darrick J. Wong <djwong@kernel.org>
    xfs: reset parent pointer args before each dir tree unlink repair

Darrick J. Wong <djwong@kernel.org>
    xfs: signal inode btree xref error if get_rec returns an error

Darrick J. Wong <djwong@kernel.org>
    xfs: snapshot old AGFL before rewriting it

Darrick J. Wong <djwong@kernel.org>
    xfs: snapshot scrub stats when rendering them

Darrick J. Wong <djwong@kernel.org>
    xfs: strengthen the "is cow staging" helpers in scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: truncate quota file correctly when repairing quota file

Darrick J. Wong <djwong@kernel.org>
    xfs: use the rtgroup extent count to find rtrefcount gaps

Bjoern Doebel <doebel@amazon.de>
    smb: client: fix heap overflow in DACL owner/group rewrite

Bjoern Doebel <doebel@amazon.de>
    smb: client: avoid leaking refcount when cifs_sb_tlink() fails

Bjoern Doebel <doebel@amazon.de>
    smb: client: avoid leaking refcount in cifs_queue_oplock_break()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in wsl_to_fattr()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in posix_reparse_to_fattr()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in cifs_reparse_point_to_fattr()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix one-byte OOB read in smb2_parse_native_symlink()

Karl Mehltretter <kmehltretter@gmail.com>
    smb: client: pin DFS superblock in iterator callback

Diego Oliva <diego@bynar.io>
    smb: client: reject short READ responses in CIFSSMBRead()

Aohan Mei <henrymei@tencent.com>
    smb: client: reject userspace cifs.idmap descriptions

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: userspace: fix address ID overflow

Kalpan Jani <kalpan.jani@mpiricsoftware.com>
    mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0

Gang Yan <yangang@kylinos.cn>
    selftests: mptcp: fix an UAF in mptcp_connect.c

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: syncookies: remember the request backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: subflow: no need to copy thmac during ulp_clone

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: handle MPC data + csum reqd + no csum

Joe Damato <joe@dama.to>
    bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()

Joe Damato <joe@dama.to>
    bnxt_en: Propagate RX ring init failures in bnxt_init_nic()

Joe Damato <joe@dama.to>
    bnxt_en: Don't free the live ring's TPA state on queue restart failure

Joe Damato <joe@dama.to>
    bnxt_en: Only restore LRO if the device supports TPA

Michael Bommarito <michael.bommarito@gmail.com>
    media: v4l2-ctrls: validate AV1 tile counts

Michael Bommarito <michael.bommarito@gmail.com>
    media: v4l2-ctrls: validate HEVC tile counts

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: rockchip: reject AV1 frames exceeding the tile capacity

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: rockchip: guard VPU981 AV1 divisor and tile buffer

Haotian Zhang <vulab@iscas.ac.cn>
    media: v4l2-h264: Fix memcmp() size in B1 reference list comparison

Michael Bommarito <michael.bommarito@gmail.com>
    media: mediatek: vcodec: bound AV1 tile-start copy to the array capacity

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: hantro: bound G2 HEVC tile loop to the buffer capacity

Michael Bommarito <michael.bommarito@gmail.com>
    media: hevc: add bounded tile-count helpers

Vishnu Razdan <vrazdan@openai.com>
    hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS

Fan Wu <fanwu01@zju.edu.cn>
    hwmon: (gpio-fan) Fix use-after-free in alarm work

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (chipcap2) fix channels in humidity alarm notifications

Cong Nguyen <congnt264@gmail.com>
    hwmon: (applesmc) fix key backlight workqueue leak on register failure

Chengfeng Ye <nicoyip.dev@gmail.com>
    afs: Clear stale peer app data after address list changes

David Howells <dhowells@redhat.com>
    afs: Fix incorrect free in candidate cleanup in afs_lookup_server()

David Howells <dhowells@redhat.com>
    afs: Fix double-unmap of directory block

David Howells <dhowells@redhat.com>
    afs: Fix missing kunmap in afs_dir_search_bucket()

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: use BIT_ULL for u64 overflow masks

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: store available counter mask as bitmap

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Map EBUSY to EIO when key conversion fails repeatedly

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix wrong return code to engine in asynch callbacks

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix missing scrub of temp buffers with PAES algorithm

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to crypto engine

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix missing cra_flags in paes_s390

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix use of mutex in atomic context

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix skcipher_walk return code handling in aes_s390

Nagamani PV <nagamani@linux.ibm.com>
    s390/qeth: allow bridgeport queries despite OS_MISMATCH

Niklas Schnelle <schnelle@linux.ibm.com>
    iommu/s390: Fix NULL dereference in iova_to_phys() with ZPCI_TABLE_TYPE_RFX

leixiang <leixiang@kylinos.cn>
    KVM: PPC: Book3S HV: Set irqfd->producer only on success

Ibrahim Hashimov <security@auditcode.ai>
    mac802154: fix use-after-free of sdata via queued RX frames

Kyle Zeng <kylebot@openai.com>
    ipvs: reject invalid states in connection template sync records

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: flowlabel: cap duplicate leases per socket

Zihan Xi <zihanx@nebusec.ai>
    ipv4: fib: bound automatic table ID allocation

David Carlier <devnexen@gmail.com>
    ieee802154: hwsim: serialize pib updates to fix double-free

Fan Wu <fanwu01@zju.edu.cn>
    ieee802154: cc2520: fix FIFOP work use-after-free

Zhiling Zou <zhilinz@nebusec.ai>
    ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink

Yilin Zhang <yilinzhang@moonshot.ai>
    inet: frags: invalidate queues before flushing them

Weiming Shi <bestswngs@gmail.com>
    fbdev: vfb: defer cleanup until the last reference

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    erofs: preserve LZMA decoders on resize failure

Jeffin Philip <jeffinphilip14@gmail.com>
    fs: autofs: fix memory leak in autofs_fill_super()

Nathan Chancellor <nathan@kernel.org>
    scripts/sorttable: Mark long_size as __maybe_unused

Xiong Weimin <xiongweimin@kylinos.cn>
    vdpa: solidrun: Free IRQs after request failure

Xiong Weimin <xiongweimin@kylinos.cn>
    vdpa: ifcvf: Put device on unsupported feature error

Ilya Maximets <i.maximets@ovn.org>
    netfilter: report NLM_F_DUMP_FILTERED when all is filtered out

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: nf_log: unregister loggers before per-net teardown

Karl Mehltretter <kmehltretter@gmail.com>
    netfs: Fix uninitialized return value in netfs_unbuffered_write()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    net: phy: dp83td510: handle the active-high LED polarity mode

Norbert Szetei <norbert@doyensec.com>
    net: openvswitch: fix use-after-free of the flow table mask array

Fourie Zhang <littleddfu@gmail.com>
    net: mpls: clear inner_protocol when the last label is popped

Sahil Chandna <sahilchandna@linux.microsoft.com>
    net: mana: Reserve extra CQ slot for the fence completion CQE

Johan Hovold <johan@kernel.org>
    net: hso: fix TIOCMIWAIT race

Weiming Shi <bestswngs@gmail.com>
    net: dsa: tag_brcm: legacy FCS: request needed tailroom

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: use option bits for CFM/MRP frame handlers

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/sched: act_api: release all action references on NEWACTION failure

David Carlier <devnexen@gmail.com>
    ring-buffer: Check resize_disabled before publishing the new subbuf order

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()

Gabriel Krisman Bertazi <krisman@suse.de>
    io_uring/net: don't overconsume buffers when using MSG_TRUNC

Gabriel Krisman Bertazi <krisman@suse.de>
    io_uring/net: let io_recv_buf_select return the length of the buffer region

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sched: Create a fake device for KUnit tests

Yudi Yang <2000jedi@gmail.com>
    drm/rockchip: analogix_dp: fix unchecked bound endpoint name length

Thorsten Blum <thorsten.blum@linux.dev>
    drm/i915: Fix memory leak in query_perf_config_list()

Sunil Khatri <sunil.khatri@amd.com>
    drm/drm_exec: fix up contended obj when num_objects is 0

Leonardo Costa <leonardo.costa@toradex.com>
    drm/bridge: tc358768: Enforce input bus flags via atomic_check

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    function_graph: Use the saved entry's size when reprinting it

Moritz Tanner <moritz.tanner@linbit.com>
    fs: don't return -EINVAL for successful nested thaw

Jann Horn <jannh@google.com>
    exec: do_close_on_exec() before taking exec_update_lock

Runyu Xiao <runyu.xiao@seu.edu.cn>
    cpufreq: initialize policy rwsem before sysfs publication

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: zero-initialize policy cpumask before sysfs publication

Rong Zhang <i@rong.moe>
    Bluetooth: btrtl: Don't leak return code when parsing firmware format v2

Xu Rao <raoxu@uniontech.com>
    Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: sti: initialize IRQ lock before requesting IRQ

Tianchu Chen <flynnnchen@tencent.com>
    ASoC: sprd: validate compress buffer sizes against fixed allocations

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    accel/ivpu: Limit firmware log name prints to field size

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate firmware log buffer metadata

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate full buffer range in ivpu_to_cpu_addr

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Keep the entry count when the histogram stats allocation fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Let histogram values keep the percent and graph modifiers

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram the field rejected for a bad modifier

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram var refs regardless of how often they are referenced

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram the var ref when its initialization fails

Henry Martin <bsdhenrymartin@gmail.com>
    tracing/user_events: Don't destroy fields when event removal fails

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tools/bootconfig: Fix integer overflow and truncation in size checks

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Plug clockevents replacement race

Ido Schimmel <idosch@nvidia.com>
    tunnels: Drop stale dst when building an ICMP error for PMTUD

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: validate cylinder group metadata before caching it

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: create the root dentry after loading cylinder metadata

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_mmio: disable IRQ wake before free_irq

James Hilliard <james.hilliard1@gmail.com>
    watchdog: sunxi_wdt: preserve boot-enabled watchdog

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: skip gfx switch_power_profile during GPU reset

Harry Wentland <harry.wentland@amd.com>
    dm/amdgpu: fix malformed link_settings debugfs output

Samuel Holland <samuel.holland@sifive.com>
    Revert "riscv: Reset pmm when PR_TAGGED_ADDR_ENABLE is not set"

Tristan Madani <tristan@talencesecurity.com>
    ALSA: usbusx2y: validate URB actual_length in interrupt callback

Tristan Madani <tristan@talencesecurity.com>
    ALSA: usbusx2y: fix in04_last array size mismatch with in04_buf

Kazuki Hanai <hnkz.64@gmail.com>
    ALSA: us122l: Prevent write upgrades for read mappings

Roman Prucha <zorgan.roman@gmail.com>
    ALSA: ctxfi: Fix CA20K2 S/PDIF passthrough

Miguel Ojeda <ojeda@kernel.org>
    drm/panic: clean new `clippy::needless_range_loop` lint for Rust 1.100.0

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `unknown_lints` in generated bindings for Rust < 1.88

John Hubbard <jhubbard@nvidia.com>
    rust: allow `clippy::as_underscore` in the generated bindings

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix memory corruption from a "STACKTRACE" histogram key

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tracing: Restore :mod: trailer after parsing in ftrace_set_clr_event()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix memory corruption from the histogram stacktrace modifier

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    reboot: fix cad_pid use-after-free race

Zihan Xi <zihanx@nebusec.ai>
    ipv6: fix fib6 walker UAF on seq stop

Pedro Falcato <pfalcato@suse.de>
    x86/alternatives: Exclude text poking against change_page_attr()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    x86/mm/pat: Acquire init_mm write lock on collapse to avoid UAF

Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
    x86/cfi: Fix FineIBT hash offset in cfi_get_func_hash()

Vernon Yang <yanglincheng@kylinos.cn>
    x86/mm: Fix user-space data loss with MADV_FREE and THP

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_node: Fix PCI device reference counting in amd_smn_init()

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aria - add missing vzeroupper in AVX-512 code

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aria - add missing vzeroupper in AVX2 code

Jason Andryuk <jason.andryuk@amd.com>
    x86/amd_node: Fix potential NULL pointer dereference

Jason Andryuk <jason.andryuk@amd.com>
    x86/amd_node: Avoid divide by zero on virtualized systems

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc: pci-ioda: Fix the stale irq chip reference

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/eeh: Fix recursive locking on devices without EEH sensitive driver

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/ps3: Fix repository.c build failure

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: pin the symlink target's dirent instead of chasing ->ci_dentry

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent out-of-bounds reads in share config responses

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    scripts/mksysmap: fix escape of '$' in the __pi_ pattern

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    scripts/mksysmap: drop the MODULE_INFO() symbols from kallsyms

Binglei Wang <l3b2w1@gmail.com>
    erofs: add missing buf->off in erofs_bread()

Stian Halseth <stian@itx.no>
    sunvdc: unmap LDC cookies when the descriptor send fails

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: fix wrong flag value in get_ipv6_ext_hdrs()

MD Danish Anwar <danishanwar@ti.com>
    net: hsr: enable promiscuous mode on interlink port with fwd offload

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix TX descriptor availability check for TSO traffic

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: add TSO check for header length

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: add stmmac_tso_header_size()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: fix TSO support when some channels have TBS available

Greg Marsden <greg.marsden@oracle.com>
    net/rds: fix tcp stream corruption with large pages

Long Li <longli@microsoft.com>
    net: mana: restore the XDP program pointer when pre-allocation fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    net: phy: dp83867: handle the active-high LED polarity mode

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: fix PF/CGX debugfs PCI bus lookup

Faicker Mo <faicker.mo@gmail.com>
    net: net_failover: Fix the deadlock in net_failover_slave_name_change()

Vladislav Karmanov <vladislav.karmanov.dev@gmail.com>
    net: phy: mediatek-ge: disable EEE on the MT7530 PHY

Aleksei Sviridkin <f@lex.la>
    net: ethernet: mtk_eth_soc: populate lpi_interfaces to fix EEE support

Christian Marangi <ansuelsmth@gmail.com>
    net: ethernet: mtk_eth_soc: fix supported_interface set after phylink_create

Joris Vaisvila <joey@tinyisr.com>
    net: ethernet: mtk_eth_soc: avoid writing to ESW registers on MT7628

Aleksei Sviridkin <f@lex.la>
    net: dsa: mt7530: populate lpi_interfaces to fix EEE support

Ahmed Naseef <naseefkm@gmail.com>
    net: dsa: mt7530: add EN7528 support

Aamir Ahmed <elb12345@hotmail.co.uk>
    net: hinic: fix mailbox segment buffer overflow

Li Youhong <liyouhong@kylinos.cn>
    net: sun4i-emac: fix missing of_node_put() for phy_node

Kuniyuki Iwashima <kuniyu@google.com>
    net/sched: cls_api: Don't replay RTM_GETCHAIN in tc_ctl_chain().

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: Fix in-place replace

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: Reject handle aliasing

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: free emptied bucket on filter move

Hui Su <sh_def@163.com>
    sched/core: Call wq_worker_tick() for the execution context

Hui Su <sh_def@163.com>
    sched: Account cgroup CPU time to the execution context

Vincent Guittot <vincent.guittot@linaro.org>
    sched/eevdf: Fix rb augmented with multi fields

Vincent Guittot <vincent.guittot@linaro.org>
    sched/eevdf: Fix augmented max_slice

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Prevent drain_pebs() reentry

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Correct pt_regs->flags update for PEBS path

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel/ds: Factor out PEBS group processing code to functions

Thomas Richter <tmricht@linux.ibm.com>
    perf/core: Allow list_del during perf_event_overflow()

Thibault Ferrante <thibault.ferrante@canonical.com>
    selftests/powerpc/tm: Fix tcheck() reading uninitialised CR value

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Move representor vnic reporter to eswitch devlink port

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Register SF resource on PF port representor

Or Har-Toov <ohartoov@nvidia.com>
    devlink: Add port-level resource registration infrastructure

Or Har-Toov <ohartoov@nvidia.com>
    devlink: Refactor resource functions to be generic

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: initialize ptp_lock at probe time

Qingfang Deng <qingfang.deng@linux.dev>
    ppp_synctty: ensure a writeable skb header

Eric Dumazet <edumazet@google.com>
    vxlan: initialize _md in vxlan_xmit_one()

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-pf: reset HTB scheduler topology before freeing queues

Ali Ahmet Memis <ali@iusegentoo.com>
    hwmon: (nct6694) do not expose enable on DTIN temperature channels

Linmao Li <lilinmao@kylinos.cn>
    hwmon: (corsair-cpro) Remove debugfs entries when probe fails

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors

Cong Nguyen <congnt264@gmail.com>
    hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()

Linmao Li <lilinmao@kylinos.cn>
    hwmon: (corsair-cpro) Create debugfs entries after hwmon registration

Marek Vasut <marex@nabladev.com>
    net: ks8851: Fix receiver error in 100BASE-TX mode following software power-down

Yicong Hui <yiconghui@gmail.com>
    net/micrel: Fix typos in micrel driver code comments

Jan Havran (Advantech Czech) <havran.jan@email.cz>
    net: dsa: lantiq_gswip: fix GSWIP_MDIO_PHY_FCONTX_EN value

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Sync timeout value if WDT was running at boot

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix undefined behavior

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix spurious reset on suspend

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Enable clock before accessing hardware registers

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix clock leak and spurious timer in settimeout()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Avoid division by zero

David Arcari <darcari@redhat.com>
    watchdog: fix hrtimer start when pretimeout is zero

Paolo Abeni <pabeni@redhat.com>
    mptcp: remove unneeded READ_ONCE() annotation

Nicolai Buchwitz <nb@tipi-net.de>
    net: macb: put the "mdio" child node reference on success

Nicolai Buchwitz <nb@tipi-net.de>
    net: macb: destroy the phylink instance on the probe error path

Naman Gulati <namangulati@google.com>
    ipv6: null-check fib6_node before accessing in __ip6_del_rt_siblings()

Long Li <longli@microsoft.com>
    net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: btusb: Fix leaked runtime PM reference in btusb_reset

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: btusb: mediatek: Fix leaked runtime PM reference in reset

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()

Ivan Hu <ivan.hu@canonical.com>
    Bluetooth: btmtk: Declare MT7920 (MT7961 1a) Bluetooth firmware

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: fix tx_handle bounds off-by-one

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: validate packet_len before skb_put_data

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Fix UAF of btusb_data by rx_work

Jakub Kicinski <kuba@kernel.org>
    eth: ice: don't dereference pointers from TP_printk()

Jacob Keller <jacob.e.keller@intel.com>
    ice: add missing xa_destroy for sched_node_ids

Joshua Hay <joshua.a.hay@intel.com>
    idpf: account for VLAN header when parsing RSC packet header

HyeongJun An <sammiee5311@gmail.com>
    ALSA: hda: Report a change when only the channel status bytes move

Karl Mehltretter <kmehltretter@gmail.com>
    drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER

Karl Mehltretter <kmehltretter@gmail.com>
    drm/adp: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX descriptors for freeq refill

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX drops once per frame

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: No mapping is a dropped rx

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count dropped frames as NAPI work

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Finish RX updates before NAPI completion

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Fix budget accounting

Alice Mikityanska <alice@isovalent.com>
    net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward

Alice Mikityanska <alice@isovalent.com>
    net: ipv6: Fix UDP length overflow with PMTU discover and big MTU

Alice Mikityanska <alice@isovalent.com>
    net: ipv4: Fix UDP length overflow with PMTU discover and big MTU

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Return immediately when manage_oob() returns NULL for 0-length buffer.

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Update last skb marker in manage_oob().

Karl Mehltretter <kmehltretter@gmail.com>
    virtio_input: stop callbacks before unregistering input device

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_input: reset device if input_register_device() fails

Andrew Stellman <astellman@stellman-greene.com>
    virtio-pci: return IRQ_HANDLED after non-zero ISR

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim_net: check TX pull result before RX copy

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim_blk: reject out-of-range sector starts

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: protect config_ctx from being freed under the config callback

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: don't install the eventfd_ctx_fdget() error in config_ctx

Jia Jia <physicalmtea@gmail.com>
    vhost/vdpa: reject VRING_NUM larger than device max

Jia Jia <physicalmtea@gmail.com>
    virtio_console: do not free control-out buffers on remove

Karl Mehltretter <kmehltretter@gmail.com>
    virtio: fix use-after-free in unregister_virtio_device()

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Preserve ICC_CR0_EL1 state

hpp.iscas <hppiscas@163.com>
    ASoC: mt6351: Publish the OF module alias

Florian Westphal <fw@strlen.de>
    netfilter: ip6_tables: set F_PROTO when proto value is nonzero

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: cope with concurrent instance destruction

hpp.iscas <hppiscas@163.com>
    ASoC: Intel: SST: Publish the PCI module aliases

hpp.iscas <hppiscas@163.com>
    ASoC: bcm: bcm63xx: Publish the OF module aliases

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht4x) Fix return value from heater_enable_store()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht4x) Rely on subsystem locking

Antonin Godard <antonin.godard@bootlin.com>
    Documentation: hwmon: replace full-width colon by a standard ASCII colon

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Decouple in0 and curr1 alarms

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Replace masks with enum in alert functions

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Parameterize ina2xx_data in ina226_alert_read()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ina2xx) Rely on subsystem locking

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Acquire hwmon_lock in shunt_resistor_show()

Guenter Roeck <linux@roeck-us.net>
    hwmon: Fix potential UAF in pec_store

Guenter Roeck <linux@roeck-us.net>
    Documentation/hwmon: Document hwmon_notify_event()

Geert Uytterhoeven <geert+renesas@glider.be>
    hwmon: (ltc4282) Make sure clk_init_data is fully initialized

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix premature break in init_iommu_one() again

Karl Mehltretter <kmehltretter@gmail.com>
    iommu/amd: Do not reallocate GA log buffers on resume

Li RongQing <lirongqing@baidu.com>
    iommu/amd: Add NUMA node affinity for IOMMU log buffers

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/riscv: Disable SADE

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    iommu/riscv: Add command queue lock

Edward Adam Davis <eadavis@sina.com>
    ALSA: caiaq: Decoupling ep1_in_urb in caiaq dev

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject non-scalar bpf_loop iteration counts

Vineeth Karumanchi <vineeth.karumanchi@amd.com>
    net: macb: fix NULL pointer dereference on unbind with fixed-link

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: rename bp->sgmii_phy field to bp->phy

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: ets: clamp quantum in parse and fallback paths

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: drr: clamp quantum in change class

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: pie: clamp psched_mtu in pie_drop_early

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: dualpi2: clamp psched_mtu at all call sites

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: clamp quantum in change and init paths

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sfq: clamp quantum in change path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_pie: clamp quantum in change path

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Keep HW timestamp stats monotonic across reconfiguration

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: E-Switch, prevent mc_list repopulation during vport disable

Yael Chemla <ychemla@nvidia.com>
    net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix use-after-free race in sample_restore_put()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: LAG, use local tracker to update active ports

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix setting RS FEC after remapping

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix missing FEC mode mapping for RS_544_514_INTERLEAVED_QUAD

Weiming Shi <bestswngs@gmail.com>
    net/sched: defer qdisc freeing after failed creation

XingWang Xiang <v3rdant.xiang@gmail.com>
    net: mctp: i3c: serialize probe with bus removal

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/kexec_file: Use inclusive range checks for excluded memory

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/kexec_file: Use inclusive range checks in add_usable_mem()

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: don't release PCI regions for VFs on reset

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: fix cmd_regs access racing BAR unmap on reset

Jamal Hadi Salim <jhs@mojatatu.com>
    net: reject oversized tx_queue_len at netlink parse time

Jamal Hadi Salim <jhs@mojatatu.com>
    net: cap tx_queue_len at S16_MAX to prevent oversized ring allocations

Seungwon Bae <qotmddnjs@ajou.ac.kr>
    vxlan: reject dynamic fdb entries that reference a nexthop id

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: folio_put() after error

Alexandra Winter <wintera@linux.ibm.com>
    dibs: Unregister dibs_class after error

Jori Koolstra <jkoolstra@xs4all.nl>
    dibs: change dibs_class to a const struct

Alexandra Winter <wintera@linux.ibm.com>
    dibs: Remove reset of static vars in dibs_init()

Jason Winter <jjx@live.nl>
    net: usb: cx82310_eth: drop URB after 0xffff reboot sentinel to prevent partial_data heap overflow

Nikhil P. Rao <nikhil.rao@amd.com>
    ionic: use netif_txq_maybe_stop() in ionic_tx()

Viswajith Murali <viswajithm@marvell.com>
    octeontx2-af: mcs: Clear stale X2P calibration state before calibration

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mcast: properly convert mglist to rcu

Jakub Kicinski <kuba@kernel.org>
    net: dsa: mv88e6xxx: bound the policy rule dump by the caller's buffer size

Jakub Kicinski <kuba@kernel.org>
    eth: nfp: drop the replaced rule from the list when reprogramming fails

Jakub Kicinski <kuba@kernel.org>
    eth: nfp: bound the ntuple rule dump by the caller's buffer size

Jakub Kicinski <kuba@kernel.org>
    net: dsa: bcm_sf2: bound the CFP rule dump by the caller's buffer size

Eric Dumazet <edumazet@google.com>
    bonding: use skb_cow_head() in bond_do_alb_xmit() and rlb_arp_xmit()

Ido Schimmel <idosch@nvidia.com>
    nexthop: Initialize extack in remove_nh_grp_entry()

Jiayuan Chen <jiayuan.chen@linux.dev>
    selftests/bpf: Fix flaky bpf_nf test when random NAT port is 0

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix to avoid creating trace instances with duplicate names

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Add boot-time backup of persistent ring buffer

Ning Ding <dingning04@gmail.com>
    bpf: Reject untrusted allocated-object pointers

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Require MEM_PERCPU for percpu kptr stores

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    thermal: sysfs: switch to use scnprintf() to suppress truncation warning

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't predict JMP32 pointer vs zero comparisons

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject legacy packet loads from callbacks

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark faultable stack helpers as sleepable

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark bpf_btf_find_by_name_kind() as sleepable

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check ancestor frames for rbtree callbacks

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Track verifier instruction stats for each subprogram

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Report maximum combined stack depth

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Print breakdown of insns processed by subprogs

Eduard Zingerman <eddyz87@gmail.com>
    bpf: share several utility functions as internal API

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Only enforce 8 frame call stack limit for all-static stacks

Taylor Bates <tmbates12@gmail.com>
    mlxsw: spectrum_ptp: Fix napi_gro_receive() call from GC workqueue context

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix tx_spb_ring_full() checking same slot cnt times

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: clear txcb->last before writing each descriptor

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Refactor and fix init_config access

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Honor NHLT override when setting up a path

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Allow the topology to carry NHLT data

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix unbalanced module reference count

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Do not ignore -ENOENT when loading a topology

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Clean up streams if their initialization fails

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Clean up the bus when fetching ML caps fails

Xixin Liu <liuxixin@kylinos.cn>
    nvme-tcp: defer TLS inline send to io_work

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme: remove stale namespaces by NSID range during scan

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark sched_process_wait argument as nullable

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject resilient lock operations in rbtree callbacks

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject tail calls directly from callback frames

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark signal tracepoint siginfo arguments as scalar

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref in btf_var_show()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref when showing a void BTF type

Igor Paunovic <royalnet026@gmail.com>
    drm/rockchip: rk3066_hdmi: Add missing Kconfig selects

Igor Paunovic <royalnet026@gmail.com>
    drm/rockchip: dw_dp: Select DRM_BRIDGE_CONNECTOR

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix potential double-free at error path

HyeongJun An <sammiee5311@gmail.com>
    selftests/alsa: Fix the step check for INTEGER controls

Gao Xiang <xiang@kernel.org>
    erofs: disable LZ4 rolling decompression for now

Breno Leitao <leitao@debian.org>
    arm64: trans_pgd: clone only the linear map that exists at runtime

HW He <hw.he@mediatek.com>
    net: gro: Fix nesting of TCP GSO SKBs in skb_gro_receive_list()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: enable RX_DONE interrupt for RX queue 31

Allison Henderson <achender@kernel.org>
    net/rds: don't let rds_conn_shutdown() consume a concurrent drop

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: acquire the fastpath locks in rds_conn_shutdown()

Allison Henderson <achender@kernel.org>
    net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown

Allison Henderson <achender@kernel.org>
    net/rds: clear cp_flags bits individually in rds_conn_path_reset()

Allison Henderson <achender@kernel.org>
    net/rds: use clear_bit_unlock() in release_refill()

Allison Henderson <achender@kernel.org>
    net/rds: use wq_has_sleeper() in release_in_xmit()

Kuniyuki Iwashima <kuniyu@google.com>
    net: Remove conflicting altnames for dying netns in __dev_change_net_namespace().

Eric Dumazet <edumazet@google.com>
    bonding: do not clear curr_active_slave prematurely when releasing all slaves

Eduard Zingerman <eddyz87@gmail.com>
    bpf: reject BPF_PSEUDO_FUNC reference to the main program

Henry Martin <bsdhenrymartin@gmail.com>
    tracing/probes: Fix use-after-free on field name/type of events with multiple probes

Joas Antonio dos Santos <joasantonio108@gmail.com>
    netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()

Kyle Zeng <kylebot@openai.com>
    ipvs: fix reversed sequence option serialization

Yogesh Mohan Marimuthu <yogesh.mohanmarimuthu@amd.com>
    drm/amdgpu/userq: fix struct drm_amdgpu_info_device padding for 32bit compile

FAN YE <fy15309206903@gmail.com>
    btrfs: zstd: fix lost wakeup when waiting for a workspace

Qu Wenruo <wqu@suse.com>
    btrfs: do not force reloc root creation during qgroup_account_snapshot()

Avi Weiss <thnkslprpt@gmail.com>
    btrfs: send: fix lost error return value in will_overwrite_ref()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: finish active block group cleanup if call_zone_finish() fails

Qu Wenruo <wqu@suse.com>
    btrfs: return proper negative error code for update_raid_extent_item()

Qu Wenruo <wqu@suse.com>
    btrfs: fix the possible bioc_list memory leak during error

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    btrfs: fix transaction use-after-free in raid stripe insertion

James C. Owens <jamesowens@optonline.net>
    btrfs: scrub: report the failing sector's address, not the stripe base

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Program the MSP FIFO watermarks

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Allow repeated MSP prepare calls

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Remove obsolete PRCMU QoS calls

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Request the MSP MMIO resource

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Deassert the MSP reset during probe

Linus Walleij <linusw@kernel.org>
    mfd: db8500-prcmu: Fold dbx500 header into db8500

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Validate MSP DAI configuration

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Correct MSP frame and bit clock setup

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Propagate MSP setup errors

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Fix MSP stream lifecycle handling

John Ogness <john.ogness@linutronix.de>
    printk/nbcon: Change nbcon_irq_work to IRQ_WORK_LAZY

Qingyu Zhang <usupergate@gmail.com>
    ALSA: ump: do not touch legacy_rmidi before it exists

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-af: Fix limiting SRIOV VF count logic

Eric Dumazet <edumazet@google.com>
    locking/lockdep: Invalidate stale class_cache entries for zapped classes

Leo Yan <leo.yan@arm.com>
    perf/core: Skip empty AUX records with only format flags

Mario Limonciello <mario.limonciello@amd.com>
    x86/itmt: Don't make ITMT enablement depend on debugfs

Seiji Nishikawa <snishika@redhat.com>
    sched/rt,dl: Skip migrate-disabled tasks when picking a push candidate

John Stultz <jstultz@google.com>
    sched: Make class_schedulers avoid pushing current, and get rid of proxy_tag_curr()

Ivy Lopez <skunkolee@gmail.com>
    scsi: mpt3sas: Avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: check cpu_hw_evt before dereference in overflow IRQ

Eric Dumazet <edumazet@google.com>
    bonding: alb: fix uninitialized transport header access in alb_determine_nd()

Guanghui Yang <3497809730@qq.com>
    btrfs: restore active device pointers after failed sprout

Guanghui Yang <3497809730@qq.com>
    btrfs: detach failed sprout device from transaction update list

HyeongJun An <sammiee5311@gmail.com>
    ALSA: dummy: Report a change when one capture switch channel moves

Lu Yao <yaolu@kylinos.cn>
    drm/xe/oa: Remove sysfs entry on idr_alloc failure in xe_oa_add_config_ioctl()

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits

Ștefan Ghețu <stefanghetu9@gmail.com>
    ASoC: fsl_micfil: balance mclk enable/disable

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: Avoid IPL parameter append past command line

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: Fix physical memory search range

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: restore MFG widget enumeration after core split

Hui Su <sh_def@163.com>
    staging: fbtft: make dirty_lock IRQ-safe

Kuniyuki Iwashima <kuniyu@google.com>
    af_packet: Don't cast tpacket_hdr.tp_len to int in tpacket_parse_header().

Eric Dumazet <edumazet@google.com>
    ipv6: sr: restore network header before routing and forwarding

David Laight <david.laight.linux@gmail.com>
    tipc: Dont send random pad bytes in RESET/ACTIVATE messages

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix NULL deref in tipc_named_node_up() on empty publication list

Eric Dumazet <edumazet@google.com>
    ip6_gre: check tunnel info before xmit in ip6gre_tunnel_xmit

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: use copy-on-write RCU updates in ip6_mc_source()

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: fix RCU list diversion in ip6_mc_del1_src()

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_synctty: simplify tty disc_data access

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_async: simplify tty disc_data access

Eric Dumazet <edumazet@google.com>
    igmp: convert struct ip_sf_list to RCU

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_u32: fix duplicate handle when node ID pool is exhausted

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Fix for the wrong data type

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Disable tx queues on fatal error

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Improve the error recovery

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Protect skb pointer used by two different kernel instances

Ciprian Regus <ciprian.regus@analog.com>
    net: ethernet: oa_tc6: Add the OA_TC6_ prefix to standard registers

Ciprian Regus <ciprian.regus@analog.com>
    net: ethernet: oa_tc6: Export standard defined registers

Ciprian Regus <ciprian.regus@analog.com>
    net: ethernet: oa_tc6: Handle the OA TC6 SPI protected mode

Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
    net: ethernet: oa_tc6: Interrupt is active low, level triggered.

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Validate and program TDM slots correctly

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Correct digital interface format setup

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Repair the DAPM capture graph

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Reset the audio block before configuring it

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: clear FLAG_DEFER_SETUP only for same PID/PSM

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix chan mode for LE_CONN_REQ + EXT_FLOWCTL pchan

Aleksandr Nogikh <nogikh@google.com>
    Bluetooth: hci_core: Fix race condition during device registration

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: btintel: bound firmware ID by TLV length

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: btintel: validate version TLV value lengths

Jiacheng Xu <stitch@zju.edu.cn>
    workqueue: reject watchdog thresholds that overflow jiffies

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Clear automask on spurious interrupts

Wanwu Li <liwanwu@kylinos.cn>
    sched_ext: Fix vtime delta loss in scx_flatcg cgroup migration

Cheng-Yang Chou <yphbchou0911@gmail.com>
    sched_ext: Update demo schedulers and selftests to use scx_bpf_task_set_dsq_vtime()

Wanwu Li <liwanwu@kylinos.cn>
    sched_ext: Fix timer pinning and return value in scx_central

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/diag324: Preserve -EBUSY return code

Vasily Gorbik <gor@linux.ibm.com>
    s390/ipl: Fix NULL deref in dump_reipl without re-IPL parm block

Vasily Gorbik <gor@linux.ibm.com>
    s390/ipl: Fix NULL deref in kdump without re-IPL parm block

Heiko Carstens <hca@linux.ibm.com>
    s390/time: Use jiffies instead of jiffies_64

Heiko Carstens <hca@linux.ibm.com>
    s390/vtime: Use __this_cpu_read() / get rid of READ_ONCE()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: rate limit unmapped SID errors

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: propagate DACL parsing errors

Yilin Zhang <yilinzhang@moonshot.ai>
    ALSA: pcm: Serialize PCM mmap with buffer reallocation to fix page UAF

David Howells <dhowells@redhat.com>
    cachefiles: Fix potential UAF/KASAN warning

Edward Adam Davis <eadavis@qq.com>
    netfs: break unbuffered write when netfs_alloc_subrequest() fails

David Howells <dhowells@redhat.com>
    netfs: Fix subreq ref leak

David Howells <dhowells@redhat.com>
    netfs: Fix i_size update for partial transfer

David Howells <dhowells@redhat.com>
    netfs: Fix error vs transferred passed to ->ki_complete()

David Howells <dhowells@redhat.com>
    netfs: Fix unbuffered/DIO write partial transfer error return

Wang Yan <wangyan01@kylinos.cn>
    perf powerpc-vpadtl: Fix raw_size of DTL samples

Colin Ian King <colin.i.king@gmail.com>
    OPP: of: Fix potential multiplication overflow when calculating freq

Adrian Hunter <adrian.hunter@intel.com>
    perf symbol: Do not use debug file as the binary type

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix NULL pointer dereference in PM callbacks

Baul Lee <baul.lee@xbow.com>
    vxlan: mdb: Fix use-after-free in vxlan_mdb_remote_src_del()

James Nugraha <aslan.jnn@gmail.com>
    net: amd-xgbe: discard rx packets with bad FCS

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    raw: annotate disconnect-side IPv4 match writers

Henry Martin <bsdhenrymartin@gmail.com>
    sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    smb: client: transport: Fix debug printing in __release_mid()

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix integer truncation in collapse range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix data corruption in emulated insert range

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb: move copychunk definitions to common/smb2pdu.h

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: mark file sparse before emulating insert range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for zero range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for insert range

Milan P. Gandhi <mgandhi@redhat.com>
    scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()

Milan P. Gandhi <mgandhi@redhat.com>
    scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()

Xin Long <lucien.xin@gmail.com>
    sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: fix skb sizing and action leak on reoffload delete

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: size the RTM_GETACTION reply from the actions

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: budget all shared attributes in notify skbs

Dong Chenchen <dongchenchen2@huawei.com>
    net: iptunnel: fix stale transport header during tunnel decapsulation

Eric Dumazet <edumazet@google.com>
    tcp: use GFP_ATOMIC in tcp_send_active_reset()

Eric Dumazet <edumazet@google.com>
    net: icmp: avoid invalid transport header access in icmp_send tracepoint

Slawomir Stepien <sst@poczta.fm>
    drm/cirrus-qemu: Validate BAR0 size during probe

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: do not treat unreadable directory blocks as empty

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Remove __counted_by from struct amdxdna_cmd_chain

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: validate GUD_ROTATION_0 is present in supported rotations

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix REG INVARIANTS VIOLATION on speculative pointer arithmetic

Hongfu Li <lihongfu@kylinos.cn>
    selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter

Liang Luo <luoliang@kylinos.cn>
    sched_ext: Fix nonexistent field in sched-ext.rst example

Xixin Liu <liuxixin@kylinos.cn>
    nvmet-rdma: fix queue leak when connect backlog is exceeded

Xixin Liu <liuxixin@kylinos.cn>
    nvme-rdma: fix -EIO cleanup order in queue_rq

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Address potential out-of-bounds read in resp_worker()

Benjamin Leggett <benjamin@edera.io>
    drm/virtio: use the DMA API for resource backing on Xen

Dan Carpenter <error27@gmail.com>
    drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()

Jad Keskes <inasj268@gmail.com>
    EDAC/device_sysfs: Use kstrtouint() for poll_msec to prevent truncation

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel address decode for non-hash mode

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel selection hash

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix interleave boundary condition

Yazen Ghannam <yazen.ghannam@amd.com>
    RAS/AMD/ATL, EDAC/amd64: Only load ATL when needed

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: ensure interrupts are enabled in __do_user_fault()

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9484/1: enable interrupts when unhandled user faults are triggered

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Use platform_get_irq_optional() in cmos_platform_probe()

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Unlink scc_entry in unix_del_edge().

Eric Dumazet <edumazet@google.com>
    l2tp: fix tunnel and session refcount leak on seq_file release

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use memcmp() to compare ClientGUIDs

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath11k: cancel SSR work items during PCI shutdown

HyeongJun An <sammiee5311@gmail.com>
    ASoC: meson: aiu: Validate written enum values

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: topology: Check PCM and DAI name strings before use

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: fib: Don't dump dying fib_info in fib_leaf_notify().

Joe Damato <joe@dama.to>
    bnxt: fix head underflow on XDP head-grow

Jiri Olsa <jolsa@kernel.org>
    bpf: Guard __get_user acesss with access_ok for uprobe_multi data

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Proper rollback if the ioremap fails

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Replace waitqueue and flag with completion

Jie Gan <jie.gan@oss.qualcomm.com>
    coresight: platform: defer connection counter increment until alloc succeeds

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending and barrier reference leaks on discard failures

Xin Long <lucien.xin@gmail.com>
    sctp: fix err_chunk memory leaks in INIT handling

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    bpf: Mask pseudo pointer values in verifier logs

David Howells <dhowells@redhat.com>
    netfs: Fix barriering when walking subrequest list

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix malformed ISO_END/CONT handling

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Reject redirect helpers without a bpf_net_context

Gregor Herburger <gregor.herburger@linutronix.de>
    drm/vc4: hvs/v3d: Fix null dereference in unbind

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix integer overflow in tipc_recvmsg() and tipc_recvstream()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: drop_monitor: fix info leak in NET_DM_ATTR_PAYLOAD

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix size calculations for 64-bit attributes

Eric Dumazet <edumazet@google.com>
    drop_monitor: perform u64_stats updates under IRQ-disabled section

Vlatko Kosturjak <kost@linux.hr>
    ppp_async: drop the errored frame instead of resetting its headroom

Max Chou <max.chou@realtek.com>
    Bluetooth: btrtl: Add the support for RTL8761CUV

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Validate pattern input before stopping the sequence

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: skip unknown CLC firmware records

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: validate CLC firmware records

Wentao Guan <guanwentao@uniontech.com>
    iommu/arm-smmu-v3: Disable implementations during devm teardown

Gil Portnoy <dddhkts1@gmail.com>
    ksmbd: remove stale channels from all sessions on teardown

Andrii Nakryiko <andrii@kernel.org>
    bpftool: Strip all -Wformat* flags from bootstrap libbpf build

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state

Lin Xianglin <1021538027@qq.com>
    ASoC: amd: yc: Add DMI quirk for HyperX OMEN Gaming Laptop 16-ap1xxx

Zizhi Wo <wozizhi@huawei.com>
    scsi: core: Do not block on tag allocation in scsi_eh_lock_door()

Rudi Heitbaum <rudi@heitbaum.com>
    ASoC: rt5645: Perform the initial jack detect at probe

Jisheng Zhang <jszhang@kernel.org>
    spi: dw: fix wrong RX_SAMPLE_DLY setting after resume

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on WDC WD141KFGX-68FH9N0

Guenter Roeck <linux@roeck-us.net>
    hwmon: (corsair-psu) Fix linear11 calculation

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: flush backend after device ioctls

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for HP Victus Laptop 16-e1xxx

Hardik Garg <hargar@linux.microsoft.com>
    Drivers: hv: vmbus: add VTL2 redirect connection ID

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on WD Green 2.5 480GB

André Pragosa <pragosa512@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Victus 16-e0xxx (MB 88ED)

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on some WD drives

Robert Abrahamse <denobyte2@gmail.com>
    ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)

Jiale Yao <yaojiale02@163.com>
    Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame

Deepanshu Kartikey <kartikey406@gmail.com>
    wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()

Li Qiang <liqiang01@kylinos.cn>
    cifs: validate idmap key payload length

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/pseries: Ensure vpa,slb_shadow & dtl are unregistered during crash

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: pass the return value of skb_checksum_help()

Madhavender Singh <madhav@disroot.org>
    ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx

Markus Lindner <lindner.markus@outlook.at>
    ALSA: usb-audio: Add dB map quirk for Razer Barracuda X 2.4

Minhong He <heminhong@kylinos.cn>
    phonet: check register_netdevice_notifier() error in phonet_device_init()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/gma500: return errors from Oaktrail HDMI I2C reads

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: preserve VFS inherited POSIX ACL mask

Ibrahim Hashimov <security@auditcode.ai>
    wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    regulator: core: clamp voltage constraints before applying apply_uV

Jay Vadayath <jay@artiphishell.com>
    smb: client: bound dirent name against end of SMB response in cifs_filldir

Georgi Valkov <gvalkov@gmail.com>
    wifi: mwifiex: replace one-element arrays with flexible array members

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add HDA_CODEC_QUIRK for Samsung 750XBE/730XBE

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: acpi: validate WGDS table revision index

Daniel C. Ribeiro <dcoutinho.96@gmail.com>
    ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: bound aligned TLV advance in FW parser

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for HP Pavilion x360

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Don't schedule thermal work when queue isn't initialized

Pu Hu <hupu@transsion.com>
    arm64: kprobes: Allow reentering kprobes while single-stepping

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: add a check on the tid coming from the firmware

Yu Peng <pengyu@kylinos.cn>
    arm64: fixmap: Allow 256K early_ioremap() at any offset

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix a possible underflow

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate TX_CMD response layout

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Add quirks for new Dell laptops

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: flush dirty data before punching a hole

Tao Cui <cuitao@kylinos.cn>
    blk-cgroup: fix leaks and online flag on radix_tree_insert failure

Marcel Kłos <marcel@marmak.net.pl>
    ALSA: hda/realtek: Add quirk for HP EliteBook 830 G8 (8AB8) to enable mute LEDs

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: pcie: null RX pointers after free

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix sched scan IE sizing

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: parse beacon notif per layout

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix an off-by-1 boundary check

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate mac_link_id in session protect notif

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reloc root cleanup in merge_reloc_roots()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate sta_id in BA window status notif

Wang YuWei <1973615295@qq.com>
    spi: dw-dma: Wait for controller idle before completing Tx

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on reloc root after error in insert_dirty_subvol()

Dave Chen <davechen@synology.com>
    btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()

Pali Rohár <pali@kernel.org>
    cifs: Fix support for creating SFU fifo

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fail if wmfw file is missing

Rohit Sinha <rohitsinha12043@gmail.com>
    ALSA: hda/realtek - Add quirk for HP Victus 15-fa0xxx (MB 8A50)

Chen Bowen <hicbowen@gmail.com>
    ALSA: hda/realtek: Fix speakers on MECHREVO WUJIE Series

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: zero-initialize stack-allocated cifs_open_info_data

Pali Rohár <pali@kernel.org>
    cifs: Fix support for creating SFU socket

Tianze Shao <shaotianze@outlook.com>
    ASoC: rt712-sdca: reset codec at io_init to fix silent headphone

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rsi: validate beacon length before fixed buffer copy

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: mark the rcu locked areas properly

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: libipw: fix key index receive bound checks

Liang Hao <haohlliang@gmail.com>
    gpio: dwapb: Mask interrupts at hardware initialization

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: mac80211: ibss: wait for in-flight TX on disconnect

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate rx/tx MLME callback frame lengths before access

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate SID namespace before mapping IDs

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: mark invalid session responses as signed

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: find bound sessions during reauthentication

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate assoc response length before status and IE access

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: libertas: reject short monitor TX frames

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rsi: avoid reading TKIP MIC keys for non-TKIP ciphers

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate deauth frame length before reason access

Corentin Labbe <clabbe@baylibre.com>
    wifi: ralink: RT2X00: init EEPROM properly

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ALSA: usb-audio: caiaq: validate EP1 reply lengths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix credit charge calculation for SMB2 QUERY_INFO

Perry Yuan <perry.yuan@amd.com>
    drm/amdgpu: flush pending RCU callbacks on module unload

Jetha Chan <jethachan@gmail.com>
    ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table

David Howells <dhowells@redhat.com>
    netfs: Fix decision whether to disallow write-streaming due to fscache use

David Howells <dhowells@redhat.com>
    cachefiles: Fix double fput

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/gntalloc: validate grant count before allocation

Farhad Alemi <farhad.alemi@berkeley.edu>
    freevxfs: don't BUG() on unknown typed-extent type

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/front-pgdir-shbuf: free grant reference head on errors

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/komeda: fix error handling for clk_prepare_enable() and callers

Shubham Nayak <shubhamnayak392reborn@gmail.com>
    ALSA: hda/realtek: Add quirk for HP Victus 16-e0xxx (88EE) to enable mute LED

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_expect: zero at allocation time

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend

Weiming Shi <bestswngs@gmail.com>
    btrfs: tree-checker: validate INODE_REF's namelen

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: core: Abort active target transfer on controller suspend

Baojun Xu <baojun.xu@ti.com>
    ASoC: tas2781: Update default register address to TAS2563

Haoxiang Li <haoxiang_li2024@163.com>
    fbdev: pm2fb: unwind WC setup on probe failure

Kamlesh Chhetty <kamleshkc2002@gmail.com>
    ALSA: hda: Add Lenovo Legion 7i 16IAX7 17AA3874 quirk

Arnd Bergmann <arnd@arndb.de>
    eth: mlx5: fix macsec dependency

Adriana Stancu <adriana@arista.com>
    rtc: bq32000: add delay between RTC reads

Yu Kuai <yukuai@fygo.io>
    blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: au1000: move free_irq out of the close-time spinlocked section

Pengpeng Hou <pengpeng@iscas.ac.cn>
    regulator: da9121: Use subvariant ids in the I2C table

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Use kstrtobool() to parse the ROM attribute input

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Fix race between pci_proc_init() and pci_bus_add_device()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: treat read-control opens as stat opens only for leases

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: break RH leases before delete-on-close

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: start file id allocation at 1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: deny renaming directory with open children

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: apply create security descriptor first

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: treat unnamed DATA stream as base file

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use connection ClientGUID for lease lookup

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: align SMB2 oplock break ack handling

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate SMB2 lease create contexts

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix lease break and ack state handling

Tommy Huang <tommy_huang@aspeedtech.com>
    rtc: aspeed: add AST2700 compatible

Xue Lei <Xue.Lei@windriver.com>
    rtc: mv: add suspend/resume support for wakeup

Samuel Moelius <sam.moelius@trailofbits.com>
    f2fs: validate inline dentry name lengths before conversion

Chris Aherin <chrisaherin@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga 7 16IAP7

Chen Cheng <chencheng@fnnas.com>
    md/raid5: let stripe batch bm_seq comparison wrap-safe

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mailbox: imx: use devm_of_platform_populate()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mailbox: imx: Add a channel shutdown field

Yu Kuai <yukuai@fygo.io>
    md/raid5: account discard IO

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mailbox: imx: Use devm_pm_runtime_enable()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix addr_filter_ranges lifetime

Hans Zhang <18255117159@163.com>
    PCI: plda: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: mediatek: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: rockchip: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: altera: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: iproc: Protect root bus removal with rescan lock

David Francis <David.Francis@amd.com>
    drm/amdkfd: Properly acquire queue buffers in CRIU restore

Jean-Louis Colaco <jean-louis.colaco@orange.fr>
    ALSA: usb-audio: Add quirk for YAMAHA CDS3000

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Use system unbound workqueue for soft IH ring

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: check find_first_zero_bit before __set_bit on kfd->doorbell_bitmap

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl

Matthew Bystrin <dev.mbstr@gmail.com>
    mfd: rsmu: Add 8a34002 support

Piotr Kubik <piotr@kubik.pl>
    leds: trigger: gpio: Use GPIOD_FLAGS_BIT_NONEXCLUSIVE

Akashdeep Kaur <a-kaur@ti.com>
    mfd: tps65219: Make poweroff handler conditional on system-power-controller

Tobias Deiminger <tobias.deiminger@linutronix.de>
    leds: pca9532: Don't stop blinking for non-zero brightness

Yousef Alhouseen <alhouseenyousef@gmail.com>
    leds: uleds: Return -EFAULT on copy_to_user() failure

Galen Hassen <rwekyes@gmail.com>
    ALSA: hda/conexant: Add pin config quirk for Lenovo IdeaPad Slim 5 16AKP10

Jakub Kicinski <kuba@kernel.org>
    tls: reject the combination of TLS and sockmap

Ai Chao <aichao@kylinos.cn>
    ALSA: usb-audio: Add quirk flags for SC13A

guoqi0226 <guoqi0226@163.com>
    spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()

Rob Herring (Arm) <robh@kernel.org>
    gpio: pisosr: Read "ngpios" as u32

Arnd Bergmann <arnd@arndb.de>
    scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()

Zhang Tianci <zhangtianci.1997@bytedance.com>
    fuse: set ff->flock only on success

Jiri Kosina <jikos@kernel.org>
    HID: hidpp: fix potential UAF in hidpp_connect_event()

Yung-Tse Cheng <mes900903@gmail.com>
    virtio-fs: avoid double-free on failed queue setup

Viktor Menshin <ripeeerr@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT

David Timber <dxdt@dev.snart.me>
    exfat: fix handling of damaged volume in exfat_create_upcase_table()

Rosen Penev <rosenp@gmail.com>
    sparc: Disable compat support with LLD

Leo Yan <leo.yan@arm.com>
    bpftool: Pass host flags to bootstrap libbpf

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix races in cifsd thread creation

Alice Mikityanska <alice@isovalent.com>
    net/sched: act_csum: don't mangle UDP tunnel GSO packets

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: propagate -ENOMEM correctly in unpack_table

Jijie Shao <shaojijie@huawei.com>
    net: hns3: improve the unused_tuple parameter setting

Agalakov Daniil <ade@amicon.ru>
    e1000e: limit endianness conversion to boundary words

Raf Dickson <rafdog35@gmail.com>
    vsock: use sk_acceptq_is_full() helper in all transports

Ido Schimmel <idosch@nvidia.com>
    ipv6: Honor oif when choosing nexthop for locally generated traffic

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp: ocp: add shutdown callback

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: xgmac2: disable RBUE in default RX interrupt mask

Rosen Penev <rosenp@gmail.com>
    sparc64: uprobes: add missing break

Chen Zhang <zhangchen01@kylinos.cn>
    Bluetooth: btusb: Add Realtek RTL8922AE VID/PID 0bda/d923

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_pdm: Handle runtime PM resume failures in set_fmt

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Add 50 ms delay before MAC init on BlazarIW

Samuel Moelius <sam.moelius@trailofbits.com>
    Bluetooth: L2CAP: validate connectionless PSM length

Cris <cxs1494089474@gmail.com>
    Bluetooth: btusb: Add support for TP-Link TL-UB250

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7925: Add VID/PID 0e8d/8c38

Rong Zhang <i@rong.moe>
    Bluetooth: btmtk: Disable remote wakeup for MT7922/MT7925

Hrvoje Nuic <hrvoje.nuic@gmail.com>
    Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV

Chen Zhang <zhangchen01@kylinos.cn>
    Bluetooth: btusb: Add Realtek RTL8922AE VID/PID 0bda/d922

Ravindra <ravindra@intel.com>
    Bluetooth: btusb: Add support for Intel Lizard Peak 2 (0x8087:0x0040)

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7922: Add VID/PID 0e8d/223c

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    spi: xilinx: let transfers timeout in case of no IRQ

Potin Lai <potin.lai.pt@gmail.com>
    hwmon: (pmbus/lm25066) Fix PMBus coefficients for LM5064/5066/5066i

Tze Yee Ng <tze.yee.ng@altera.com>
    dmaengine: dw-axi-dmac: fix PM for system sleep and channel alloc

Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
    dmaengine: altera-msgdma: Use memcpy_toio for descriptor FIFO writes

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add Dell Latitude 7530 to fan control whitelist

Dave Carey <carvsdriver@gmail.com>
    HID: multitouch: Honor ContactCount for Yoga Book 9 to suppress ghost contacts

Yuho Choi <dbgh9129@gmail.com>
    sctp: Unwind address notifier registration on failure

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme-fc: Do not cancel requests in io target before it is initialized

Nikolay Metchev <nikolaymetchev@gmail.com>
    platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table

Xu Rao <raoxu@uniontech.com>
    ata: libata-pmp: add JMicron JMS562 quirk

Moritz Baron <moritz.baron@stud.uni-hannover.de>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IRH8

Furst Blumier <seal@furst.blue>
    ALSA: hda/realtek: Add quirk for HP 255 15.6 inch G9 Notebook PC

Vamsi Attunuru <vattunuru@marvell.com>
    vdpa/octeon_ep: Use 4 bytes for mailbox signature

Evgenii Burenchev <evg28bur@yandex.ru>
    vdpa/ifcvf: handle dev_set_name() failure in ifcvf_vdpa_dev_add()

Guangshuo Li <lgs201920130244@gmail.com>
    net: lan966x: restore RX state on reload failure

George Moussalem <george.moussalem@outlook.com>
    net: dsa: qca8k: Add support for force mode for fixed link topology

Ben Maurer <bmaurer@meta.com>
    btrfs: use lockless read in nr_cached_objects shrinker callback

Anand Jain <asj@kernel.org>
    btrfs: use on-disk uuid for s_uuid in temp_fsid mounts

Kory Maincent <kory.maincent@bootlin.com>
    hwmon: (adt7462) Add of_match_table to support devicetree

Shubham Chakraborty <chakrabortyshubham66@gmail.com>
    hwmon: (raspberrypi) Fix delayed-work teardown race

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    PCI: Avoid FLR for MediaTek MT7925 WiFi

Lu Yao <yaolu@kylinos.cn>
    fbcon: don't suspend/resume when vc is graphics mode

KangNing Liao <lkangn.kernel@gmail.com>
    btrfs: protect sb_write_pointer() with invalidate lock

Breno Leitao <leitao@debian.org>
    netconsole: take target_cleanup_list_lock in drop_netconsole_target()

Jiajia Liu <liujiajia@kylinos.cn>
    wifi: mt76: transform aspm_conf for pci_disable_link_state

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: add 320MHz bandwidth to bss_rlm_tlv

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: populate EHT 320MHz MCS map in sta_rec

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: add Netgear A8500 USB device ID

Luis de Carlos <reskoldo73@gmail.com>
    platform/x86: msi-ec: Add support for MSI Pulse GL66 12th Gen

Javier Tia <floss@jetm.me>
    wifi: mt76: mt7925: handle 320MHz bandwidth in RXV and TXS

Gleb Sonichev <sonichev555@gmail.com>
    platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table

Chuck Lever <chuck.lever@oracle.com>
    tls: Flush backlog before waiting for a new record

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: mal: fix potential system hang in mal_remove()

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: quiesce DMA before freeing resources

Al Viro <viro@zeniv.linux.org.uk>
    configfs_depend_prep(): pass configfs_dirent instead of dentry

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Create ODP EQ for non-pinned dmabuf MRs

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Add request-pool slack for delayed recycling

Aurelien DESBRIERES <aurelien@hackers.camp>
    RDMA/rtrs-srv: Fix integer underflow in process_read and process_write

Tuo Li <islituo@gmail.com>
    ASoC: mediatek: mt8365-afe-pcm: fix possible NULL-pointer dereferences in mt8365_afe_suspend()

Dai Ngo <dai.ngo@oracle.com>
    NFS: fix eof updates after NFSv4.2 fallocate/zero-range

Zhang Cen <rollkingzzc@gmail.com>
    btrfs: tree-checker: validate names in ROOT_REF and ROOT_BACKREF

ZhengYuan Huang <gality369@gmail.com>
    btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()

Osama Abdelkader <osama.abdelkader@gmail.com>
    riscv: panic if IRQ handler stacks cannot be allocated

Rosen Penev <rosenp@gmail.com>
    netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()

Ruoyu Wang <ruoyuw560@gmail.com>
    ALSA: es18xx: check control allocation before private data setup

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    net: microchip: sparx5: clean up PSFP resources on flower setup failure

Maoyi Xie <maoyixie.tju@gmail.com>
    hsr: broadcast netlink notifications in the device's net namespace

Guangshuo Li <lgs201920130244@gmail.com>
    net: cpsw_new: unregister devlink on port registration failure

Dawei Feng <dawei.feng@seu.edu.cn>
    bpf: NUL-terminate replaced sysctl value

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Fix state and counter desync on loopback enable failure

Genevieve Chan <genevieve.chan@altera.com>
    firmware: stratix10-svc: fix FCS SMC call kernel-doc

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/umem: Make ib_umem_is_contiguous() safe on 32 bit

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/umem: Be careful about boundary conditions in ib_umem_find_best_pgsz()

Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>
    wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ipv6: use READ_ONCE() for bindv6only default in inet6_create()

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: Unwind debug trap enable on copy_to_user failure

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: fix SMI event cross-process information leak

Jakub Kicinski <kuba@kernel.org>
    net: ethtool: cmis_cdb: hold instance lock for ops locked devices

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Move the no-revision fixup to get_patch_level()

Koba Ko <kobak@nvidia.com>
    cxl/region: Validate partition index before array access

Rosen Penev <rosenp@gmail.com>
    ipmi: si: Use platform_get_irq_optional() to retrieve interrupt

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Guard against invalid box control address

Andrei Faleichyk <andrei.faleichyk@noogadev.com>
    ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP

Evelyn Ali <evelynali99@gmail.com>
    ALSA: hda/realtek: ALC882: Fixup for Clevo P775TM1

Michael Walle <mwalle@kernel.org>
    clk: keystone: don't cache clock rate

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: fix unchecked platform_get_irq return value

Shay Drory <shayd@nvidia.com>
    net/mlx5: E-Switch, align disable sequence with switchdev-to-legacy transition

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu/ras: add ras_suspend callback and use it for cp_ecc_error_irq

Cyrill Gorcunov <gorcunov@gmail.com>
    RDMA/irdma: Fix typo in SQ completions generation

Shay Drory <shayd@nvidia.com>
    net/mlx5e: Verify unique vhca_id count instead of range

Candice Li <candice.li@amd.com>
    drm/amdgpu: validate RAS EEPROM tbl_size before record count

Shiwu Zhang <shiwu.zhang@amd.com>
    drm/amdgpu: fix buffer overflow during vBIOS update

Candice Li <candice.li@amd.com>
    drm/amdgpu/pm: fix SmartShift bias sysfs store PM refcount on parse error

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: bound pp_dpm_set_pp_table() memcpy

Stanley.Yang <Stanley.Yang@amd.com>
    drm/amdgpu: harden FRU PIA parsing with bounded helpers

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdkfd: fix UAF race in destroy_queue_cpsch

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: Check for sharpening case when calculating max vtaps for scaler

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent queuing new commands if xhci is inaccessible

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Avoid DPMS-on for phantom stream

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: remove legacy 'num_trbs_free' tracking

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Improve Soft Retries after short transfers

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: add support for AX231

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix P2P-Device binding handling

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mld: don't WARN on WoWLAN suspend w/o netdetect

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: harden cfg80211_defragment_element()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: unify link STA removal in vif link removal

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: clarify beacon parsing with MBSSID/EMA

liuxixin <gliuxen@gmail.com>
    nvme: validate FDP configuration descriptor sizes

Priyansh Jain <priyansh.jain@oss.qualcomm.com>
    thermal/drivers/qcom/tsens: Atomic temperature read with hardware-guided retries

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: 8851bu: add Mercusys MA60XNB (2c4e:0128)

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix handling of NAPI on the remove path

David Yang <mmyangfl@gmail.com>
    net: dsa: sja1105: flower: reject cross-chip redirect

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix the error path in dpaa2_switch_rx()

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: rework FDB management on the bridge leave path

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: oss: Reject reads that cannot fit the next event

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: codecs: rk3328: Use managed GPIO and clock helpers

Alessandro Schino <7991aleschino@gmail.com>
    ntfs3: fix out-of-bounds read in ntfs_dir_emit() and hdr_find_e()

ZhengYuan Huang <gality369@gmail.com>
    fs/ntfs3: validate index entry key bounds

Yao Sang <sangyao@kylinos.cn>
    nvme: refresh multipath head zoned limits from path limits

ZhengYuan Huang <gality369@gmail.com>
    fs/ntfs3: preserve non-DOS attribute bits in system.dos_attrib

Adriano Vero <adri.vero.dev@gmail.com>
    powerpc/fadump: Add timeout to RTAS busy-wait loops

Simon Xue <xxm@rock-chips.com>
    iommu/rockchip: disable fetch dte time limit

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: txgbe: fix phylink leak on AML init failure

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: wwan: t7xx: Add delay between MD and SAP suspend

Wentao Liang <vulab@iscas.ac.cn>
    net: qrtr: fix node refcount leak on ctrl packet alloc failure

Shivang Upadhyay <shivangu@linux.ibm.com>
    ppc/fadump: invoke kmsg_dump in fadump panic path

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: scan: Honor _DEP for ACPI0016 PCI/CXL host bridge

liyouhong <liyouhong@kylinos.cn>
    ata: ahci: fail probe if BAR too small for claimed ports

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: ath12k: Prevent incorrect vif chanctx switch when handling multi-radio contexts

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: return error code to consumers on failures

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Prevent regulator double-disable in S4

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: fix invalid data access in ath11k_dp_rx_h_undecap_nwifi

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: Reserve VLAN header in MJS limit

Aaron Kling <webgeek1234@gmail.com>
    spi: tegra210-quad: Allocate DMA memory for DMA engine

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Also reset {insn,data}_cur on realloc failure

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: accel: mma8452: switch to non-devm request_threaded_irq()

Rik van Riel <riel@surriel.com>
    perf/ftrace: Fix WARNING in __unregister_ftrace_function

Miao Li <limiao@kylinos.cn>
    iio: light: stk3310: Deal with the ps interrupt issue in PM

Loic Poulain <loic.poulain@oss.qualcomm.com>
    media: qcom: camss: vfe-340: Proper client handling

Denzeel Oliva <wachiturroxd150@gmail.com>
    clk: samsung: exynos990: Fix PERIC0/1 USI clock types

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2E SoC

Karl Mehltretter <kmehltretter@gmail.com>
    tracing: Disable KCOV instrumentation for trace_irqsoff.o

Ion Agorria <ion@agorria.com>
    ARM: tegra: p880: Lower CPU thermal limit

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC

Svyatoslav Ryhel <clamor95@gmail.com>
    ARM: tegra: tf600t: Invert accelerometer calibration matrix

Osama Abdelkader <osama.abdelkader@gmail.com>
    mmc: davinci: fix mmc_add_host order in probe

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: only handle alert events when the peripheral is attached

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: page poisoning fix

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek devices

Kartik Rajput <kkartik@nvidia.com>
    soc/tegra: fuse: Register nvmem lookups at probe

Tiezhu Yang <yangtiezhu@loongson.cn>
    libbpf: Add __NR_bpf definition for LoongArch

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau/bios: skip the IFR header if present

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Complete coredump handling

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    x86/topology: Add missing struct declaration and attribute dependency

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau/gsp: add SEC2 to GA100 chip table

Alexandre Courbot <acourbot@nvidia.com>
    scripts: modpost: detect and report truncated buf_printf() output

shayderrr <darknessshayder@gmail.com>
    host1x: bus: Fix missing ops null check in error teardown

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzv2m: Use -ENOTSUPP instead of -EOPNOTSUPP

Wei Qisen <weixiansen574@163.com>
    net: sfp: add quirk for OEM 2.5G optical modules

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: rework hfsplus_readdir() logic

ikaros <void0red@gmail.com>
    ACPICA: add boundary checks in two places

ikaros <void0red@gmail.com>
    ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()

Weiming Shi <bestswngs@gmail.com>
    ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()

ikaros <void0red@gmail.com>
    ACPICA: Enhance OEM ID and Table ID validation in acpi_ex_load_table_op()

ikaros <void0red@gmail.com>
    ACPICA: Add validation for node in acpi_ns_build_normalized_path()

ikaros <void0red@gmail.com>
    ACPICA: Add package limit checks in parser functions

ikaros <void0red@gmail.com>
    ACPICA: validate handler object type in two places

ikaros <void0red@gmail.com>
    ACPICA: Improve argument parsing in acpi_ps_get_next_simple_arg()

ikaros <void0red@gmail.com>
    ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)

ikaros <void0red@gmail.com>
    ACPICA: Prevent adding invalid references

ikaros <void0red@gmail.com>
    ACPICA: validate byte_count in acpi_ps_get_next_package_length()

ikaros <void0red@gmail.com>
    ACPICA: add boundary checks in acpi_ps_get_next_field()

ikaros <void0red@gmail.com>
    ACPICA: Fix use-after-free in acpi_ds_terminate_control_method()

ikaros <void0red@gmail.com>
    ACPICA: Fix condition check in acpi_ps_parse_loop()

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Initialize dsc_caps to 0

Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>
    drm/amd/pm/si: Fix updating clock limits from power states

Imre Deak <imre.deak@intel.com>
    drm/dp: Add DSC virtual DPCD quirk for Realtek MST branch device

Johny Lin <johnylin@google.com>
    ALSA: hda: cs35l41: imply SERIAL_MULTI_INSTANTIATE

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    net: thunderx: fix PTP device ref leak in nicvf_probe()

Martin Karsten <mkarsten@uwaterloo.ca>
    net: napi: Skip last poll when arming gro timer in busy poll

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: addrconf: fix temp address generation after prefix deprecation

Luka Gejak <luka.gejak@linux.dev>
    net: hsr: require valid EOT supervision TLV

Uwe Küchler <uwe@kuechler.org>
    ALSA: usb-audio: Add quirk for Novation Mininova

Mostafa Saleh <smostafa@google.com>
    irqchip/gic-v4: Don't advertise VLPIs if no ITS is probed

Stepan Ionichev <sozdayvek@gmail.com>
    iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind

Rosen Penev <rosenp@gmail.com>
    mips: cps: Assemble jr.hb with an R2 ISA level

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    drm/panel: simple: Add AM-1280800W8TZQW-T00H

Thomas Gleixner <tglx@kernel.org>
    genirq/manage: Make NMI cleanup RT safe

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: intel_rapl: Fix memory leak in rapl_add_package_cpuslocked()

Avinash Bhatt <avinash.bhatt@intel.com>
    wifi: iwlwifi: mld: keep healthy link on EMLSR missed beacon exit

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mld: purge async notifications upon nic error

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: mld: disallow puncturing in US/CA for WH

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: pcie: add two LNL PCI IDs

Avinash Bhatt <avinash.bhatt@intel.com>
    wifi: iwlwifi: Transition to basic uAPSD with MAC_PM_POWER_TABLE API VER_3

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mld: call iwl_mld_free_ap_early_key() for AP only

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: pcie: fix ACPI DSM check

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mld: honor BSS_CHANGED_BEACON_ENABLED

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: fix the access to CNVR TOP registers

Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
    thermal/drivers/tegra/soctherma: Switch to devm cooling device registration

Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
    clk: socfpga: agilex: implement l3_main_free_clk

Heiko Carstens <hca@linux.ibm.com>
    s390/zcore: Removed unused variables

Jiayuan Chen <jiayuan.chen@linux.dev>
    rds: annotate data-race around rs_seen_congestion

Maoyi Xie <maoyixie.tju@gmail.com>
    rds: filter RDS_INFO_* getsockopt by caller's netns

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: Remove arbitrary prioq insertion limit

Tao Cui <cuitao@kylinos.cn>
    RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()

Chenguang Zhao <zhaochenguang@kylinos.cn>
    netlabel: fix IPv6 unlabeled address add error handling

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: pci: enable LTR based on pcie control register

Sicong Huang <congei42@163.com>
    virt: acrn: Fix irqfd use-after-free during eventfd shutdown

Zqiang <qiang.zhang@linux.dev>
    rcu-tasks: Fix possible boot-time tests failed for the call_rcu_tasks()

Shiji Yang <yangshiji66@outlook.com>
    pwm: mediatek: set mt7628 pwm45_fixup flag to false

Sascha Bischoff <sascha.bischoff@arm.com>
    irqchip/gic-v5: Immediately exec priority drop following activate

Dave Penkler <dpenkler@gmail.com>
    gpib: Suppress setting END on error from NI_USB dongle

Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    char/nvram: Remove redundant nvram_mutex

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - remove sysfs group before hwrng

Herve Codina <herve.codina@bootlin.com>
    driver core: Avoid warning when removing a device while its supplier is unbinding

Stepan Ionichev <sozdayvek@gmail.com>
    tty: serial: 8250: protect against NULL uart->port.dev in register

Christian Marangi <ansuelsmth@gmail.com>
    usb: host: add ARCH_AIROHA in XHCI MTK dependency

Marco Felsch <m.felsch@pengutronix.de>
    serial: 8250: fix possible ISR soft lockup

Maoyi Xie <maoyixie.tju@gmail.com>
    usb: gadget: aspeed_udc: avoid past-the-end iterator in dequeue

Dave Carey <carvsdriver@gmail.com>
    USB: cdc-acm: start bulk-IN polling when ALWAYS_POLL_CTRL is set

Stepan Ionichev <sozdayvek@gmail.com>
    usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log

Oliver Neukum <oneukum@suse.com>
    usb: core: hcd: fix possible deadlock in rh control transfers

Adrian Wowk <dev@adrianwowk.com>
    usbip: vhci_hcd: fix NULL deref in status_show_vhci

Jérôme de Bretagne <jerome.debretagne@gmail.com>
    drm/panel-edp: Add LG LP129WT232166 panel

Nikhil Chatterjee <nikhilc1527@gmail.com>
    HID: bpf: Add Huion Inspiroy Frego M button quirk

Christoph Hellwig <hch@lst.de>
    isofs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    omfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    hpfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    jfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    qnx4: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    minix: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    bfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    affs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    ntfs3: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    befs: handle set_blocksize failures

Thomas Lin <thomas_lin@lecomputing.com>
    spi: dw-mmio: Add ACPI ID LECA0002 for LECARC SoCs

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Switch vport HCA cap helpers to kvzalloc

Allison Henderson <achender@kernel.org>
    net/rds: Don't sleep inside rds_ib_conn_path_shutdown

Eric Dumazet <edumazet@google.com>
    net/sched: sch_drr: make cl->quantum lockless

Eric Dumazet <edumazet@google.com>
    net: bridge: remove stale rcu_barrier() in br_multicast_dev_del()

Jan Volckaert <janvolck@gmail.com>
    net: usb: qmi_wwan: add MeiG SRM813Q

Matthew Leach <matthew.leach@collabora.com>
    PM: hibernate: call preallocate_image() after freeze prepare

Maurizio Lombardi <mlombard@redhat.com>
    nvme-core: align fabrics_q teardown with admin_q in nvme_free_ctrl

Yury Norov <ynorov@nvidia.com>
    bitfield: wire __bf_shf to __builtin_ctzll

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Verify Router Ready bit is set after router enumeration

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't call ieee80211_handle_reconfig_failure when not needed

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Increase timeout for Configuration Ready bit

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate SENSOR_UPDATE payload size

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Verify PCIe adapter in detect state before tunnel setup

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Improve multi-display DisplayPort tunnel allocation

Pooja Katiyar <pooja.katiyar@intel.com>
    thunderbolt: Don't access path config space on Lane 1 adapters in tb_switch_reset_host()

Ido Schimmel <idosch@nvidia.com>
    bridge: Add missing READ_ONCE() annotations around FDB destination port

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: check and drop invalid bad page records

Ce Sun <cesun102@amd.com>
    drm/amdgpu: avoid integer overflow in VA range check

Candice Li <candice.li@amd.com>
    drm/amdgpu: Bound GPIO I2C table entry count from VBIOS

Gangliang Xie <ganglxie@amd.com>
    drm/amdgpu: add first record offset check

Candice Li <candice.li@amd.com>
    drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw

Candice Li <candice.li@amd.com>
    drm/amdgpu: cap ATOM command table nesting depth

Xiang Liu <xiang.liu@amd.com>
    drm/amd/ras: reset CPER ring on corrupt entry size

Pierre Barre <pierre@barre.sh>
    9p: use kvzalloc for readdir buffer

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Populate FW common context ID before passing to the FW

Leonardo Bras <leo.bras@arm.com>
    arm64/daifflags: Make local_daif_*() helpers __always_inline

Osama Abdelkader <osama.abdelkader@gmail.com>
    arm64: panic from init_IRQ if IRQ handler stacks cannot be allocated

Pierre Barre <pierre@barre.sh>
    9p: invalidate readdir buffer on seek

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Don't timeout job if its fence has been signaled

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    iommu: arm-smmu-qcom: Ensure smmu is powered up in set_ttbr0_cfg

Andrea Righi <arighi@nvidia.com>
    sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: use atomic operation to achieve lockless serialization

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usx2y: Drain pending US-428 pipe-4 output commands

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: ice1724: Fix blocking open for independent surround PCMs

Ezio Galeazzi <eziogale@gmail.com>
    ALSA: hda/ca0132: add QUIRK_GENERIC path for Gigabyte GA-Z170X-Gaming G1

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on allocate_doorbell

Sunday Clement <Sunday.Clement@amd.com>
    drm/amdkfd: Fix OOB memory exposure in get_wave_state()

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id

Bjorn Helgaas <helgaas@kernel.org>
    PCI: Wait for device readiness after D3hot -> D0uninitialized transition

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu/userq: pin mqd and fw object bo to avoid eviction

Joonwon Kang <joonwonkang@google.com>
    mailbox: Make mbox_send_message() return error code when tx fails

Christoph Hellwig <hch@lst.de>
    iomap: don't make REQ_POLLED imply REQ_NOWAIT

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    drm/mediatek: dsi: Add compatible for mt8167-dsi

Leo Yan <leo.yan@arm.com>
    coresight: Disable source helpers in coresight_disable_path()

Leo Yan <leo.yan@arm.com>
    coresight: perf: Retrieve path and source from event data

Chenguang Zhao <zhaochenguang@kylinos.cn>
    RDMA/mlx5: Use QP port when decoding responder CQEs

Alessandro Baldi <baldovic@virgilio.it>
    media: imon: Add iMON VFD HID OEM v1.2 key mappings

Alexander Koskovich <akoskovich@pm.me>
    clk: qcom: clk-rpmh: Make all VRMs optional

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Reserve RX headroom to avoid skb reallocation

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - add support for atecc608b

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: sof_sdw: append dai type to dai link name unconditionally

Lukas Wunner <lukas@wunner.de>
    crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y

Kumar Meiyappan <kumar.meiyappan@microchip.com>
    scsi: pm8001: Reject non-fatal dump when controller is crashed

Kumar Meiyappan <kumar.meiyappan@microchip.com>
    scsi: pm8001: Reject firmware update in fatal error state

Alexey Klimov <alexey.klimov@linaro.org>
    clk: samsung: exynos850: mark APM I3C clocks as critical

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    soundwire: intel: Move suspend tracking from trigger to pm suspend

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drivers/of: validate status properties in reconfig state changes

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drivers/of: validate live-tree string properties before string use

Stefan Berger <stefanb@linux.ibm.com>
    integrity: Check for NULL returned by asymmetric_key_public_key

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: add support for RTL8367SB

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: phy: check length before parsing PHY status IE

Dave Carey <carvsdriver@gmail.com>
    HID: multitouch: Fix Yoga Book 9 14IAH10 touchscreen misclassification

Chen-Yu Tsai <wenst@chromium.org>
    drm/panel-edp: Add AUO B133HAN06.6 and BOE NV133FHM-N4F V8.0

Javier Achirica <jachirica@gmail.com>
    bus: mhi: host: pci_generic: Round up nr_irqs to power of two

Arash Golgol <arash.golgol@gmail.com>
    media: video-i2c: use vb2_video_unregister_device on driver removal

Ricardo Ribalda <ribalda@chromium.org>
    media: chips-media: wave5: Add range checks for dec_output_info

Sophie D <patches@scd31.com>
    drm/gud: Add RCade Display Adapter VID/PID pair

chunzhi.lin <linchunzhi0@gmail.com>
    net: phy: motorcomm: use device properties for firmware tuning

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: rework hfsplus_readdir() logic

Florian Eckert <fe@dev.tdt.de>
    PCI: intel-gw: Enable clock before PHY init

Xiang Liu <xiang.liu@amd.com>
    drm/amd/ras: Fix CPER ring debugfs read overflow

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: common-v1: bypass pinctrl GPIO layer in set GPIO direction

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix CRC open failure during active rendering

Brodie Abrew <brodie_abrew@selinc.com>
    platform/x86: sel3350-platform: Retain LED state on load and unload

Stepan Ionichev <sozdayvek@gmail.com>
    mmc: davinci: avoid NULL deref of host->data in IRQ handler

Manuel Lauss <manuel.lauss@gmail.com>
    serial: 8250_port: recognize UPIO_AU

Pengpeng Hou <pengpeng@iscas.ac.cn>
    genirq/proc: Size interrupt directory names for 10-digit interrupt numbers

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Add validation for host-provided max_segs

Albert Esteve <aesteve@redhat.com>
    drm/panel/tdo-tl070wsh30: Use refcounted allocation in place of devm_kzalloc()

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: Resolve kb_wake_angle visibility race

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, Handle destroying table that has a miss table

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, Check if device is down while polling for completion

Mark Pearson <mpearson-lenovo@squebb.ca>
    watchdog: lenovo_se10_wdt: Fix use-after-free and resource leak risk

Ranjani Vaidyanathan <ranjani.vaidyanathan@nxp.com>
    watchdog: imx7ulp_wdt: Keep WDOG running until A55 enters WFI on i.MX94

Mark Pearson <mpearson-lenovo@squebb.ca>
    watchdog: lenovo_se10_wdt: Add support for SE10 Gen 2 platform

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ASoC: ti: omap3pandora: update board check to use DT compatible

Wesley Cheng <wesley.cheng@oss.qualcomm.com>
    phy: qcom: m31-eusb2: Make USB repeater optional

Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
    drm/panel-edp: Add BOE NT140WHM-N4T, BOE NT140WHM-T05, BOE NV140FHM-N40

Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
    drm/panel-edp: Add AUO B140XTN07.5, AUO B140HAK03.5, AUO B116XTN02.3, AUO B140XTK02.4, AUO B140HAN07.7

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Relax capability check for eswitch query paths

Arnd Bergmann <arnd@arndb.de>
    media: qcom: camss: avoid format string warning

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()

Ziyi Guo <n7l8m4@u.northwestern.edu>
    dlm: add usercopy whitelist to dlm_cb cache

Parth Pancholi <parth.pancholi@toradex.com>
    drm/bridge: tc358768: Set pre_enable_prev_first for reverse order

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Add number of clock cells check

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: omap - add omap_des_unregister_algs helper

Ruoyu Wang <ruoyuw560@gmail.com>
    crypto: ixp4xx - fix buffer chain unwind on allocation failure

Justin Lai <justinlai0215@realtek.com>
    rtase: Fix flow control configuration

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: explicitly disable FTM responder on AP stop

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    media: em28xx-video: fix missing res_free() on init_usb_xfer failure

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family

Paul Cercueil <paul@crapouillou.net>
    media: v4l2-common: Always register clock with device-specific name

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: define .pot_clear() for 6321

Ben Reed <Ben.Reed@microchip.com>
    PCI: switchtec: Add Gen6 Device IDs

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family

Zhaoyang Yu <2426767509@qq.com>
    media: dm1105: fix missing error check for dma_alloc_coherent

David Heidelberg <david@ixit.cz>
    drm/panel: Enable GPIOLIB for panels which uses functions from it

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Prefer ROM BAR for default VGA device

Ovidiu Bunea <ovidiu.bunea@amd.com>
    drm/amd/display: Find link encoder for flexible DIG mapping cases

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Don't create multiple DMA tunnels on firmware connection manager

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Set tb->root_switch to NULL when domain is stopped

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep the domain reference while processing hotplug

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep XDomain reference during the lifetime of a service

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Don't disable lane adapter if XDomain lane bonding isn't possible

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Avoid reserved fields in path config space for USB4 routers

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: avoid out-of-bounds access in monitor

Ken Lin <kenlin5@quanta.corp-partner.google.com>
    media: platform: cros-ec: Add Kulnex and Moxoe to the match table

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Purge based on the cdev's online status

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: hardening: Reject zero max_num_queues from MANA_QUERY_VPORT_CONFIG

Riccardo Boninsegna <rboninsegna2@gmail.com>
    media: rc: mceusb: Add support for 04eb:e033

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    spi: spi-qcom-qspi: Fix incomplete error handling in runtime PM

Benjamin Marzinski <bmarzins@redhat.com>
    dm-raid: only requeue bios when dm is suspending

Brandon Brnich <b-brnich@ti.com>
    media: chips-media: wave5: Release m2m_ctx after Instance Removed from List

Brandon Brnich <b-brnich@ti.com>
    media: chips-media: wave5: Fix Reports from Kernel Lock Validator

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soundwire: validate DT compatible before parsing it

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: intel_auxdevice: Add cs42l43b to wake_capable_list

Danielle Ratson <danieller@nvidia.com>
    bridge: Do not suppress ARP probes and DAD NS unconditionally

Siew Chin Lim <elly.siew.chin.lim@intel.com>
    firmware: stratix10-svc: change get provision data to async SMC call

Marco Elver <elver@google.com>
    kcsan: Silence -Wmaybe-uninitialized when calling __kcsan_check_access()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl-asoc-card: reduce WM8904 PLL ratio to meet frequency limit

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Prevent IRQ storm from false SLVSTART on NPCM845

Jakub Kicinski <kuba@kernel.org>
    psp: validate IPv4 header fields in psp_dev_rcv()

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: disable CSI STBC for VHT 160MHz

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: disable HTC field in AP mode

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: suspend DIG when remain-on-channel

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
    wifi: rtw88: Add NULL check for chip->edcca_th in rtw_fw_adaptivity_result()

Nuno Sá <nuno.sa@analog.com>
    clk: clk-axi-clkgen: Add support versal timings

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: use chandef in ieee80211_get_sta_bw()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: always allow transmitting null-data on TXQs

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: check link is beaconing for color change

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: reject beacons with bad HE operation

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix issue of direct writes beyond end-of-file

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: cfg80211: reject duplicate wiphy cipher suite entries

Lukas Wunner <lukas@wunner.de>
    PCI: Stop setting cached power state to 'unknown' on unbind

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: avoid call to wcslen() in _start_c() inserted by clang

Hirokazu Honda <hiroh@chromium.org>
    tee: optee: Allow MT_NORMAL_TAGGED shared memory

Xu Yang <xu.yang_2@nxp.com>
    usb: gadget: udc: skip pullup() if already connected

Goldwyn Rodrigues <rgoldwyn@suse.de>
    ima: return error early if file xattr cannot be changed

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Add SR register cache for PM suspend/resume

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Propagate write errors in generic mixer put callbacks

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Handle RZ/V2H(P) IOLH configuration in PM cache

Kevin Tung <kevin.tung.openbmc@gmail.com>
    iio: adc: rtq6056: add i2c_device_id support

Douglas Anderson <dianders@chromium.org>
    driver core: Replace dev->can_match with dev_can_match()

Zhanjun Dong <zhanjun.dong@intel.com>
    drm/xe: Fix null pointer dereference in devcoredump cleanup

Jie Wang <jie.wang@intel.com>
    gfs2: move quota_init qc iterator increment

Arun T <arun.t@intel.com>
    gpio: usbio: Add ACPI device-id for NVL platforms

Jie Wang <jie.wang@intel.com>
    gfs2: fix quota init duplicate scan

Linus Walleij <linusw@kernel.org>
    wifi: ath9k: Obtain system GPIOS from descriptors

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Check SMUv13.0.6/12 metrics integrity

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/panel: jadard-jd9365da-h3: set prepare_prev_first

Dominik Kaszewski <dominik.kaszewski@amd.com>
    drm/amd/display: Fix DPMS using partially updated pipe context

Biju Das <biju.das.jz@bp.renesas.com>
    drm: renesas: rzg2l_mipi_dsi: Fix deassert/assert of CMN_RSTB signal

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    drm: rz-du: Ensure correct suspend/resume ordering with VSP

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/guc: Add support for NO_RESPONSE_BUSY in CTB

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: wait for the MC firmware to complete its boot

Boris Brezillon <boris.brezillon@collabora.com>
    drm/gem: Consider GEM object reclaimable if shrinking fails

Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
    drm/panel-edp: Add CSW PNB601LS1-2 and LGD LP116WHA-SPB1

SJ Park <sj@kernel.org>
    mm/damon/core: avoid infinite kdamond_merge_regions() internal loop

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Set gpuvm min page size to 4K on dcn35/36


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-erofs           |   6 +-
 Documentation/hwmon/gpd-fan.rst                    |   2 +-
 Documentation/hwmon/hwmon-kernel-api.rst           |  15 +
 Documentation/netlink/specs/rt-link.yaml           |   2 +
 .../net_cachelines/inet_connection_sock.rst        |   2 +-
 Documentation/scheduler/sched-ext.rst              |   2 +-
 MAINTAINERS                                        |   1 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts   |   6 +-
 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts       |  13 +
 arch/arm/mach-ux500/cpu-db8500.c                   |   6 +-
 arch/arm/mm/fault.c                                |  12 +-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts       |  18 +-
 arch/arm64/boot/dts/qcom/sar2130p.dtsi             |   8 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |  16 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  64 +--
 arch/arm64/boot/dts/qcom/sm6150.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  12 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |   4 +-
 arch/arm64/include/asm/daifflags.h                 |  10 +-
 arch/arm64/include/asm/fixmap.h                    |   6 +-
 arch/arm64/include/asm/kprobes.h                   |   6 +
 arch/arm64/kernel/irq.c                            |  29 +-
 arch/arm64/kernel/machine_kexec.c                  |   3 +-
 arch/arm64/kernel/probes/kprobes.c                 |  23 +-
 arch/arm64/tools/sysreg                            |   4 +-
 arch/mips/kernel/cps-vec.S                         |   6 +
 arch/powerpc/kernel/eeh_driver.c                   |   2 -
 arch/powerpc/kernel/setup-common.c                 |   8 +
 arch/powerpc/kexec/file_load_64.c                  |   4 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   6 +-
 arch/powerpc/platforms/ps3/repository.c            |   5 +-
 arch/powerpc/platforms/pseries/kexec.c             |  13 +-
 arch/powerpc/platforms/pseries/rtas-fadump.c       |  80 +--
 arch/powerpc/platforms/pseries/rtas-fadump.h       |   6 +
 arch/riscv/kernel/irq.c                            |  22 +-
 arch/riscv/kernel/process.c                        |   4 +-
 arch/s390/boot/ipl_parm.c                          |  26 +-
 arch/s390/boot/physmem_info.c                      |   2 +-
 arch/s390/crypto/aes_s390.c                        |  87 ++--
 arch/s390/crypto/paes_s390.c                       |  19 +-
 arch/s390/crypto/phmac_s390.c                      |  36 +-
 arch/s390/kernel/diag/diag324.c                    |   3 +-
 arch/s390/kernel/ipl.c                             |  12 +-
 arch/s390/kernel/vtime.c                           |  25 +-
 arch/sparc/Kconfig                                 |   1 +
 arch/sparc/kernel/uprobes.c                        |   1 +
 arch/x86/crypto/aria-aesni-avx2-asm_64.S           |   6 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S          |   3 +
 arch/x86/events/intel/core.c                       |  33 +-
 arch/x86/events/intel/ds.c                         | 184 ++++---
 arch/x86/events/intel/uncore_discovery.c           |  33 +-
 arch/x86/events/perf_event.h                       |   3 +
 arch/x86/include/asm/pgtable.h                     |   2 +-
 arch/x86/include/asm/topology.h                    |   3 +
 arch/x86/kernel/alternative.c                      | 111 ++--
 arch/x86/kernel/amd_node.c                         |  25 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  12 +-
 arch/x86/kernel/itmt.c                             |   8 +-
 arch/x86/mm/pat/set_memory.c                       | 147 ++++--
 block/blk-cgroup.c                                 |  13 +-
 crypto/Makefile                                    |   5 +
 drivers/accel/amdxdna/amdxdna_ctx.h                |   2 +-
 drivers/accel/ivpu/ivpu_fw_log.c                   |  87 ++--
 drivers/accel/ivpu/ivpu_gem.h                      |  14 +-
 drivers/accel/ivpu/ivpu_ipc.c                      |   7 +-
 drivers/accel/qaic/qaic_control.c                  |  46 +-
 drivers/acpi/acpi_apd.c                            |   7 +
 drivers/acpi/acpica/dsmethod.c                     |  43 ++
 drivers/acpi/acpica/evhandler.c                    |  11 +
 drivers/acpi/acpica/exconfig.c                     |  26 +-
 drivers/acpi/acpica/exoparg3.c                     |   2 +-
 drivers/acpi/acpica/nsnames.c                      |   6 +
 drivers/acpi/acpica/nsprepkg.c                     |   7 +
 drivers/acpi/acpica/nsxfname.c                     |   4 +
 drivers/acpi/acpica/psargs.c                       | 134 ++++-
 drivers/acpi/acpica/psloop.c                       |  30 +-
 drivers/acpi/acpica/psparse.c                      |  14 +
 drivers/acpi/acpica/utcopy.c                       |  10 +-
 drivers/acpi/acpica/utresrc.c                      |  30 ++
 drivers/acpi/pci_root.c                            |   4 +
 drivers/acpi/scan.c                                |   1 +
 drivers/ata/ahci.c                                 |  22 +
 drivers/ata/libata-core.c                          |  10 +
 drivers/ata/libata-pmp.c                           |   7 +-
 drivers/base/core.c                                |  13 +-
 drivers/base/dd.c                                  |  10 +-
 drivers/block/sunvdc.c                             |  17 +
 drivers/bluetooth/btintel.c                        |  39 +-
 drivers/bluetooth/btintel_pcie.c                   |  22 +-
 drivers/bluetooth/btmtk.c                          |  11 +
 drivers/bluetooth/btmtk.h                          |   1 +
 drivers/bluetooth/btqcomsmd.c                      |   6 +-
 drivers/bluetooth/btrtl.c                          |  21 +-
 drivers/bluetooth/btusb.c                          |  45 +-
 drivers/bluetooth/hci_mrvl.c                       |   3 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  46 ++
 drivers/bus/mhi/host/pci_generic.c                 |   3 +-
 drivers/char/ipmi/ipmi_si_platform.c               |   5 +-
 drivers/char/nvram.c                               |  16 +-
 drivers/char/virtio_console.c                      |  21 +-
 drivers/clk/clk-axi-clkgen.c                       |   5 +-
 drivers/clk/keystone/sci-clk.c                     |   8 +
 drivers/clk/qcom/clk-rpmh.c                        |   8 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             |   3 +
 drivers/clk/samsung/clk-exynos850.c                |   5 +-
 drivers/clk/samsung/clk-exynos990.c                | 307 +++++------
 drivers/clk/socfpga/clk-agilex.c                   |   2 +
 drivers/clk/ux500/clk-prcmu.c                      |  20 +-
 drivers/clk/ux500/u8500_of_clk.c                   |   2 +-
 drivers/cpufreq/cpufreq.c                          |   6 +-
 drivers/cpuidle/cpuidle-ux500.c                    |   6 +-
 drivers/crypto/atmel-ecc.c                         |   3 +
 drivers/crypto/atmel-sha204a.c                     |   3 +-
 drivers/crypto/ccp/sev-dev.c                       |   2 +-
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |  25 +-
 drivers/crypto/omap-des.c                          |  26 +-
 drivers/cxl/core/region.c                          |   3 +
 drivers/dibs/dibs_main.c                           |  25 +-
 drivers/dma/altera-msgdma.c                        |  24 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  11 +-
 drivers/edac/altera_edac.c                         | 115 +++--
 drivers/edac/altera_edac.h                         |   1 +
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/edac/edac_device_sysfs.c                   |  11 +-
 drivers/edac/igen6_edac.c                          |  27 +-
 drivers/firmware/arm_scmi/base.c                   |  15 +-
 drivers/firmware/arm_scmi/sensors.c                |  10 +-
 drivers/firmware/stratix10-svc.c                   |   4 +-
 drivers/gpio/gpio-ath79.c                          |  57 +-
 drivers/gpio/gpio-dwapb.c                          |  17 +
 drivers/gpio/gpio-pisosr.c                         |   4 +-
 drivers/gpio/gpio-usbio.c                          |   1 +
 drivers/gpu/drm/adp/Kconfig                        |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |  24 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c           |  18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c     |  97 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |  22 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |  34 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  59 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |  34 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |  29 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c          |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  11 +
 drivers/gpu/drm/amd/amdgpu/atom.c                  |  11 +
 drivers/gpu/drm/amd/amdgpu/atom.h                  |   3 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 -
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c           |  14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c              |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c             |   6 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |  11 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  12 +-
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |   7 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  20 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   3 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  22 +-
 .../amd/display/dc/dml2/dml2_translation_helper.c  |   1 +
 .../gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c |   8 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  12 +-
 .../amd/display/dc/link/accessories/link_dp_cts.c  |   2 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |   6 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   8 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  31 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   3 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |   4 +
 drivers/gpu/drm/arm/display/komeda/komeda_dev.c    |   6 +-
 drivers/gpu/drm/arm/display/komeda/komeda_drv.c    |  14 +-
 drivers/gpu/drm/arm/malidp_drv.c                   |  22 +-
 drivers/gpu/drm/bridge/tc358768.c                  |  17 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |   3 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +
 drivers/gpu/drm/drm_exec.c                         |  13 +
 drivers/gpu/drm/drm_gem.c                          |  10 +
 drivers/gpu/drm/drm_pagemap.c                      |  10 +-
 drivers/gpu/drm/drm_panic_qr.rs                    |   4 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |  21 +-
 drivers/gpu/drm/gud/gud_drv.c                      |   3 +
 drivers/gpu/drm/i915/i915_query.c                  |   4 +-
 drivers/gpu/drm/imagination/pvr_context.c          |  32 +-
 drivers/gpu/drm/imagination/pvr_queue.c            |   7 +-
 drivers/gpu/drm/logicvc/Kconfig                    |   1 -
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |   1 +
 .../gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c   | 110 +++-
 drivers/gpu/drm/panel/Kconfig                      |  11 +-
 drivers/gpu/drm/panel/panel-edp.c                  |  13 +
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c   |   2 +
 drivers/gpu/drm/panel/panel-simple.c               |  28 +
 drivers/gpu/drm/panel/panel-tdo-tl070wsh30.c       |  14 +-
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c       |  16 +
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h       |   2 +
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c     |  18 +-
 drivers/gpu/drm/rockchip/Kconfig                   |   3 +
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   7 +-
 drivers/gpu/drm/scheduler/tests/mock_scheduler.c   |  11 +
 drivers/gpu/drm/tiny/cirrus-qemu.c                 |   3 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |  53 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |  47 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |  12 +-
 drivers/gpu/drm/ttm/ttm_pool.c                     |  37 +-
 drivers/gpu/drm/ttm/ttm_resource.c                 |   6 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   2 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |  20 +
 drivers/gpu/drm/virtio/virtgpu_object.c            |   2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   6 +-
 drivers/gpu/drm/xe/instructions/xe_gpu_commands.h  |   1 +
 drivers/gpu/drm/xe/regs/xe_i2c_regs.h              |   2 +
 drivers/gpu/drm/xe/xe_devcoredump.c                |   6 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |  38 +-
 drivers/gpu/drm/xe/xe_i2c.c                        |  61 ++-
 drivers/gpu/drm/xe/xe_i2c.h                        |   1 +
 drivers/gpu/drm/xe/xe_oa.c                         |   6 +-
 drivers/gpu/drm/xe/xe_ring_ops.c                   |  16 +-
 drivers/gpu/host1x/bus.c                           |   4 +-
 .../hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c    |  87 ++++
 drivers/hid/hid-logitech-hidpp.c                   |   1 +
 drivers/hid/hid-multitouch.c                       | 147 +++++-
 drivers/hv/connection.c                            |  47 +-
 drivers/hv/hyperv_vmbus.h                          |   2 +
 drivers/hwmon/adt7462.c                            |   8 +
 drivers/hwmon/applesmc.c                           |   7 +-
 drivers/hwmon/aspeed-pwm-tacho.c                   |   4 +-
 drivers/hwmon/chipcap2.c                           |   9 +-
 drivers/hwmon/corsair-cpro.c                       |  24 +-
 drivers/hwmon/corsair-psu.c                        |  23 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   8 +
 drivers/hwmon/gpio-fan.c                           |  13 +-
 drivers/hwmon/hwmon.c                              |  21 +-
 drivers/hwmon/ina2xx.c                             | 183 +++++--
 drivers/hwmon/ltc4282.c                            |   2 +-
 drivers/hwmon/nct6694-hwmon.c                      |  35 +-
 drivers/hwmon/pmbus/lm25066.c                      |  60 +--
 drivers/hwmon/pmbus/pmbus_core.c                   |   4 +-
 drivers/hwmon/raspberrypi-hwmon.c                  |  12 +-
 drivers/hwmon/sht4x.c                              |  44 +-
 drivers/hwtracing/coresight/coresight-core.c       |  29 +-
 drivers/hwtracing/coresight/coresight-etm-perf.c   | 116 +++--
 drivers/hwtracing/coresight/coresight-platform.c   |  12 +-
 drivers/hwtracing/coresight/coresight-priv.h       |   1 +
 drivers/i2c/busses/i2c-designware-common.c         |   2 +
 drivers/i2c/busses/i2c-designware-core.h           |  85 +--
 drivers/i2c/busses/i2c-designware-master.c         |   2 +
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +
 drivers/i2c/i2c-core-smbus.c                       |  12 +
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c           |   4 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c           |   4 +-
 drivers/i3c/master/svc-i3c-master.c                |   9 +
 drivers/iio/accel/mma8452.c                        |  19 +-
 drivers/iio/adc/qcom-spmi-iadc.c                   |  18 +-
 drivers/iio/adc/rtq6056.c                          |  10 +-
 drivers/iio/light/stk3310.c                        |  76 ++-
 drivers/infiniband/core/counters.c                 |  10 +-
 drivers/infiniband/core/umem.c                     |  18 +-
 drivers/infiniband/hw/bnxt_re/debugfs.c            |   2 +-
 drivers/infiniband/hw/bnxt_re/main.c               |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  11 +
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |   2 +-
 drivers/infiniband/hw/irdma/hw.c                   |   7 +-
 drivers/infiniband/hw/irdma/main.h                 |   3 +-
 drivers/infiniband/hw/irdma/utils.c                |  14 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   3 +-
 drivers/infiniband/hw/mlx5/main.c                  |  11 +
 drivers/infiniband/hw/mlx5/mr.c                    |   4 +
 drivers/infiniband/hw/mlx5/odp.c                   |   3 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  12 +-
 drivers/iommu/amd/init.c                           |  31 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   4 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   9 +
 drivers/iommu/riscv/iommu.c                        |   7 +-
 drivers/iommu/riscv/iommu.h                        |   2 +
 drivers/iommu/rockchip-iommu.c                     |   8 +
 drivers/iommu/s390-iommu.c                         |   2 +
 drivers/irqchip/irq-gic-v3-its.c                   |   1 +
 drivers/irqchip/irq-gic-v5.c                       |  19 +-
 drivers/leds/leds-pca9532.c                        |   8 +-
 drivers/leds/leds-st1202.c                         |  10 +-
 drivers/leds/trigger/ledtrig-gpio.c                |   3 +-
 drivers/leds/uleds.c                               |  11 +-
 drivers/mailbox/imx-mailbox.c                      |  64 ++-
 drivers/mailbox/mailbox.c                          |   6 +-
 drivers/md/dm-raid.c                               |   6 +
 drivers/md/md.h                                    |   2 +
 drivers/md/raid10.c                                |   5 +
 drivers/md/raid5.c                                 |  42 +-
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c   |   4 +
 drivers/media/i2c/mt9p031.c                        |   6 +-
 drivers/media/i2c/video-i2c.c                      |   2 +-
 drivers/media/pci/dm1105/dm1105.c                  |   7 +-
 .../platform/chips-media/wave5/wave5-helper.c      |   4 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |  59 ++-
 .../platform/chips-media/wave5/wave5-vpuapi.c      |  11 +-
 .../platform/chips-media/wave5/wave5-vpuconfig.h   |   1 +
 .../vcodec/decoder/vdec/vdec_av1_req_lat_if.c      |   5 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |   7 +-
 drivers/media/platform/qcom/camss/camss-csiphy.c   |  10 +-
 drivers/media/platform/qcom/camss/camss-vfe-340.c  |  84 +--
 .../platform/qcom/iris/iris_platform_common.h      |  10 +-
 .../media/platform/qcom/iris/iris_platform_gen2.c  |   8 +-
 .../platform/qcom/iris/iris_platform_sm8250.c      |   2 +-
 drivers/media/platform/qcom/iris/iris_resources.c  |  15 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   7 +-
 drivers/media/platform/renesas/rcar-csi2.c         |   6 +-
 .../media/platform/samsung/s3c-camif/camif-core.c  |   7 +-
 .../platform/verisilicon/hantro_g2_hevc_dec.c      |   6 +-
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c       |  57 +-
 drivers/media/rc/imon.c                            |   4 +
 drivers/media/rc/mceusb.c                          |   2 +
 drivers/media/usb/as102/as102_usb_drv.c            |  75 ++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  12 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   4 +-
 drivers/media/usb/gspca/jl2005bcd.c                |   7 +-
 drivers/media/v4l2-core/v4l2-common.c              |  13 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  32 ++
 drivers/media/v4l2-core/v4l2-h264.c                |   3 +-
 drivers/mfd/ab8500-core.c                          |   2 +-
 drivers/mfd/db8500-prcmu.c                         |   6 +-
 drivers/mfd/rsmu_i2c.c                             |   2 +
 drivers/mfd/rsmu_spi.c                             |   2 +
 drivers/mfd/tps65219.c                             |  14 +-
 drivers/misc/amd-sbi/rmi-core.c                    |   4 +
 drivers/mmc/core/queue.c                           |   8 +-
 drivers/mmc/host/davinci_mmc.c                     |  16 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   2 +
 drivers/net/bonding/bond_alb.c                     |  32 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |   2 +
 drivers/net/dsa/lantiq/lantiq_gswip.h              |   2 +-
 drivers/net/dsa/mt7530-mmio.c                      |   1 +
 drivers/net/dsa/mt7530.c                           |  70 ++-
 drivers/net/dsa/mt7530.h                           |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  23 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   |  22 +-
 drivers/net/dsa/qca/qca8k.h                        |   1 +
 drivers/net/dsa/realtek/rtl8365mb.c                |  14 +
 drivers/net/dsa/sja1105/sja1105_flower.c           |   4 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |  14 +-
 drivers/net/ethernet/airoha/airoha_eth.h           |   4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   2 +
 drivers/net/ethernet/amd/au1000_eth.c              |   3 +-
 drivers/net/ethernet/amd/pds_core/core.c           |   4 +
 drivers/net/ethernet/amd/pds_core/fw.c             |  10 +-
 drivers/net/ethernet/amd/pds_core/main.c           |  10 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |   3 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  86 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   2 +-
 drivers/net/ethernet/cadence/macb.h                |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |  54 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |  11 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   8 +-
 drivers/net/ethernet/cortina/gemini.c              |  77 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  69 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  12 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c  |   4 +-
 drivers/net/ethernet/ibm/emac/core.c               |   8 +-
 drivers/net/ethernet/ibm/emac/mal.c                |   6 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  19 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |  64 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  20 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   2 +-
 drivers/net/ethernet/intel/idpf/idpf.h             |  70 ++-
 drivers/net/ethernet/intel/idpf/idpf_dev.c         |  16 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |  78 +--
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        | 327 +++++++-----
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |  14 +-
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c      |  16 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    | 204 ++++----
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h    |  26 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |  10 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  33 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  10 +-
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |  60 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  62 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c   |  27 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  52 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  51 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |  74 +++
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  14 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.c |  12 +
 .../mellanox/mlx5/core/steering/hws/table.c        |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |  34 +-
 drivers/net/ethernet/micrel/ks8842.c               |   4 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |  10 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |   4 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   4 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  20 +
 .../net/ethernet/microchip/sparx5/sparx5_psfp.c    |   5 +-
 .../ethernet/microchip/sparx5/sparx5_tc_flower.c   |  18 +-
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |   1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  30 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  19 +-
 drivers/net/ethernet/oa_tc6.c                      | 514 +++++++++++-------
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  13 +-
 drivers/net/ethernet/realtek/rtase/rtase.h         |   4 +
 drivers/net/ethernet/realtek/rtase/rtase_main.c    |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 111 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   1 -
 drivers/net/ethernet/ti/cpsw_new.c                 |   4 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c     |   1 +
 drivers/net/gtp.c                                  |   5 +
 drivers/net/ieee802154/cc2520.c                    |   5 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |  10 +-
 drivers/net/mctp/mctp-i3c.c                        |   9 +-
 drivers/net/net_failover.c                         |   2 +-
 drivers/net/netconsole.c                           |   2 +
 drivers/net/phy/dp83867.c                          |   3 +
 drivers/net/phy/dp83td510.c                        |   3 +
 drivers/net/phy/mediatek/mtk-ge.c                  |  29 ++
 drivers/net/phy/motorcomm.c                        |  41 +-
 drivers/net/phy/sfp.c                              |   2 +
 drivers/net/ppp/ppp_async.c                        |  89 +---
 drivers/net/ppp/ppp_synctty.c                      |  97 +---
 drivers/net/usb/cx82310_eth.c                      |   1 +
 drivers/net/usb/hso.c                              |   2 +-
 drivers/net/usb/pegasus.c                          |  54 +-
 drivers/net/usb/pegasus.h                          |   3 -
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/vxlan/vxlan_core.c                     |  13 +-
 drivers/net/vxlan/vxlan_mdb.c                      |   8 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  50 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |   4 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   8 +
 drivers/net/wireless/ath/ath12k/mac.c              |  87 +++-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  12 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  33 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   3 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/rf-gf.c     |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |  48 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  18 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   7 +-
 drivers/net/wireless/intel/iwlwifi/mld/ap.c        |  25 +-
 drivers/net/wireless/intel/iwlwifi/mld/ap.h        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mld/d3.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mld/iface.c     |  18 -
 drivers/net/wireless/intel/iwlwifi/mld/iface.h     |   3 -
 drivers/net/wireless/intel/iwlwifi/mld/link.c      |  17 +-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |  12 +-
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mld/mld.c       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mld/notif.c     |   6 -
 drivers/net/wireless/intel/iwlwifi/mld/power.c     | 177 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  45 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   5 +-
 .../net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c    |   9 +-
 .../net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c |  28 +-
 drivers/net/wireless/marvell/libertas/tx.c         |   7 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |  18 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |   8 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  33 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   9 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   5 +
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |   3 +
 drivers/net/wireless/mediatek/mt76/pci.c           |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   3 +
 drivers/net/wireless/realtek/rtw89/core.c          |  10 +-
 drivers/net/wireless/realtek/rtw89/mac_be.c        |   4 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  16 +-
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c     |   3 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   8 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   6 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   6 +-
 drivers/net/wwan/t7xx/t7xx_pci.c                   |   3 +
 drivers/nvme/host/core.c                           |  44 +-
 drivers/nvme/host/fc.c                             |   7 +-
 drivers/nvme/host/rdma.c                           |  18 +-
 drivers/nvme/host/tcp.c                            |   5 +
 drivers/nvme/target/rdma.c                         |  15 +-
 drivers/of/base.c                                  |  43 +-
 drivers/of/dynamic.c                               |  20 +-
 drivers/of/property.c                              |  27 +-
 drivers/of/unittest.c                              |  32 ++
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/dwc/pcie-intel-gw.c         |  19 +-
 drivers/pci/controller/pcie-altera.c               |   2 +
 drivers/pci/controller/pcie-iproc.c                |   2 +
 drivers/pci/controller/pcie-mediatek.c             |   2 +
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +
 drivers/pci/controller/plda/pcie-plda-host.c       |   2 +
 drivers/pci/pci-driver.c                           |  10 +-
 drivers/pci/pci-sysfs.c                            |  14 +-
 drivers/pci/pci.c                                  |  24 +-
 drivers/pci/proc.c                                 |  79 ++-
 drivers/pci/quirks.c                               |   5 +
 drivers/pci/switch/switchtec.c                     |  16 +
 drivers/perf/riscv_pmu_legacy.c                    |   5 +-
 drivers/perf/riscv_pmu_sbi.c                       |  98 ++--
 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c          |   2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |  13 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |   8 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |  41 +-
 drivers/pinctrl/renesas/pinctrl-rzv2m.c            |   4 +-
 drivers/platform/chrome/cros_ec_sensorhub.c        |   6 +-
 drivers/platform/chrome/cros_ec_sysfs.c            |   5 +-
 drivers/platform/x86/dell/dell-laptop.c            |   9 +
 drivers/platform/x86/intel/hid.c                   |   7 +
 drivers/platform/x86/msi-ec.c                      |   1 +
 drivers/platform/x86/sel3350-platform.c            | 136 +++--
 drivers/powercap/intel_rapl_common.c               |   3 +-
 drivers/ptp/ptp_ocp.c                              |   1 +
 drivers/pwm/pwm-mediatek.c                         |   2 +-
 drivers/ras/amd/atl/core.c                         |   1 -
 drivers/regulator/core.c                           | 163 +++---
 drivers/regulator/da9121-regulator.c               |  18 +-
 drivers/regulator/db8500-prcmu.c                   |  12 +-
 drivers/rtc/rtc-aspeed.c                           |   1 +
 drivers/rtc/rtc-bq32k.c                            |   9 +
 drivers/rtc/rtc-cmos.c                             |  13 +-
 drivers/rtc/rtc-mv.c                               |  23 +
 drivers/s390/char/zcore.c                          |   8 +-
 drivers/s390/cio/device.c                          |   2 +-
 drivers/s390/net/ism_drv.c                         |   4 +-
 drivers/s390/net/qeth_l2.h                         |   3 +-
 drivers/s390/net/qeth_l2_main.c                    |  26 +-
 drivers/s390/net/qeth_l2_sys.c                     |   7 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |   8 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   5 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   8 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   7 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |  47 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +
 drivers/scsi/qla2xxx/qla_fw.h                      |   4 +
 drivers/scsi/qla2xxx/qla_init.c                    |  14 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |  23 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  33 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |  49 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  10 +
 drivers/scsi/qla2xxx/qla_os.c                      |  15 +
 drivers/scsi/scsi_error.c                          |   2 +-
 drivers/soc/tegra/fuse/fuse-tegra.c                |  14 +-
 drivers/soundwire/bus.c                            |   4 +
 drivers/soundwire/dmi-quirks.c                     |  35 ++
 drivers/soundwire/intel.c                          |  31 +-
 drivers/soundwire/intel_ace2x.c                    |  39 +-
 drivers/soundwire/intel_auxdevice.c                |   2 +
 drivers/soundwire/slave.c                          |   4 +-
 drivers/spi/spi-dw-dma.c                           |   3 +-
 drivers/spi/spi-dw-mmio.c                          |   7 +-
 drivers/spi/spi-dw.h                               |   1 +
 drivers/spi/spi-qcom-qspi.c                        |  44 +-
 drivers/spi/spi-tegra210-quad.c                    |  29 +-
 drivers/spi/spi-xilinx.c                           |   6 +-
 drivers/spi/spi.c                                  |   9 +-
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c          |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/tee/optee/call.c                           |   3 +-
 drivers/thermal/db8500_thermal.c                   |  10 +-
 drivers/thermal/qcom/tsens.c                       | 111 ++--
 drivers/thermal/qcom/tsens.h                       |   1 +
 drivers/thermal/tegra/soctherm.c                   |   6 +-
 drivers/thermal/thermal_sysfs.c                    |  12 +-
 drivers/thunderbolt/icm.c                          |  10 +
 drivers/thunderbolt/path.c                         |  31 +-
 drivers/thunderbolt/switch.c                       |   6 +
 drivers/thunderbolt/tb.c                           |   9 +-
 drivers/thunderbolt/tb.h                           |   1 +
 drivers/thunderbolt/tb_regs.h                      |  16 +
 drivers/thunderbolt/tunnel.c                       |  35 ++
 drivers/thunderbolt/usb4.c                         |  35 +-
 drivers/thunderbolt/xdomain.c                      |  49 +-
 drivers/tty/serial/8250/8250_core.c                |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   9 +
 drivers/usb/atm/xusbatm.c                          |   6 +-
 drivers/usb/class/cdc-acm.c                        |   6 +
 drivers/usb/class/usbtmc.c                         |   2 -
 drivers/usb/core/hcd.c                             |  14 +-
 drivers/usb/gadget/udc/aspeed_udc.c                |   7 +-
 drivers/usb/gadget/udc/core.c                      |   7 +-
 drivers/usb/gadget/udc/goku_udc.c                  |   3 +-
 drivers/usb/host/Kconfig                           |   2 +-
 drivers/usb/host/xhci-dbgcap.c                     |   5 +-
 drivers/usb/host/xhci-mem.c                        |   6 -
 drivers/usb/host/xhci-ring.c                       |   9 +-
 drivers/usb/host/xhci.c                            |   4 +
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/spcp8x5.c                       |   6 +-
 drivers/usb/usbip/vhci_sysfs.c                     |  52 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  14 +-
 drivers/vdpa/octeon_ep/octep_vdpa_main.c           |   6 +-
 drivers/vdpa/solidrun/snet_main.c                  |   6 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   7 +-
 drivers/vhost/scsi.c                               |   3 +-
 drivers/vhost/vdpa.c                               |  88 +++-
 drivers/video/fbdev/core/fbcon.c                   |   9 +-
 drivers/video/fbdev/pm2fb.c                        |   1 +
 drivers/video/fbdev/vfb.c                          |  11 +-
 drivers/virt/acrn/irqfd.c                          |  75 +--
 drivers/virtio/virtio.c                            |   2 +-
 drivers/virtio/virtio_input.c                      |   9 +-
 drivers/virtio/virtio_mmio.c                       |  16 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/db8500_wdt.c                      |  22 +-
 drivers/watchdog/imx7ulp_wdt.c                     |  10 +-
 drivers/watchdog/lenovo_se10_wdt.c                 |  82 ++-
 drivers/watchdog/msc313e_wdt.c                     |  74 ++-
 drivers/watchdog/sunxi_wdt.c                       |  45 +-
 drivers/watchdog/watchdog_hrtimer_pretimeout.c     |   1 +
 drivers/xen/gntalloc.c                             |  13 +-
 drivers/xen/xen-front-pgdir-shbuf.c                |  12 +-
 fs/9p/vfs_dir.c                                    |  14 +-
 fs/affs/affs.h                                     |   5 -
 fs/affs/super.c                                    |   6 +-
 fs/afs/addr_list.c                                 |   5 +-
 fs/afs/dir_edit.c                                  |   9 +-
 fs/afs/dir_search.c                                |  11 +-
 fs/afs/fs_probe.c                                  |   1 +
 fs/afs/internal.h                                  |   8 +
 fs/afs/server.c                                    |   1 -
 fs/autofs/inode.c                                  |   4 +-
 fs/befs/linuxvfs.c                                 |   3 +-
 fs/bfs/inode.c                                     |   3 +-
 fs/btrfs/disk-io.c                                 |  11 +-
 fs/btrfs/inode.c                                   |   6 +-
 fs/btrfs/ioctl.c                                   |  11 +-
 fs/btrfs/raid-stripe-tree.c                        |  25 +-
 fs/btrfs/raid-stripe-tree.h                        |   1 +
 fs/btrfs/relocation.c                              |  47 +-
 fs/btrfs/scrub.c                                   |  24 +-
 fs/btrfs/send.c                                    |   2 +-
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/transaction.c                             |  13 +-
 fs/btrfs/tree-checker.c                            |  41 ++
 fs/btrfs/volumes.c                                 |  10 +-
 fs/btrfs/zoned.c                                   |  13 +-
 fs/btrfs/zstd.c                                    |  11 +-
 fs/cachefiles/namei.c                              |   1 -
 fs/cachefiles/xattr.c                              |  16 +-
 fs/configfs/dir.c                                  |  25 +-
 fs/configfs/symlink.c                              |  24 +-
 fs/dlm/memory.c                                    |   4 +-
 fs/erofs/data.c                                    |   2 +-
 fs/erofs/decompressor.c                            |  55 +-
 fs/erofs/decompressor_lzma.c                       |  18 +-
 fs/erofs/internal.h                                |   6 +-
 fs/erofs/sysfs.c                                   |   4 +-
 fs/erofs/zdata.c                                   |  18 +-
 fs/exec.c                                          |  22 +-
 fs/exfat/nls.c                                     |  19 +-
 fs/f2fs/debug.c                                    |   4 -
 fs/f2fs/f2fs.h                                     |  29 +-
 fs/f2fs/file.c                                     |  18 +-
 fs/f2fs/gc.c                                       |  51 +-
 fs/f2fs/gc.h                                       |  27 +-
 fs/f2fs/inline.c                                   |   7 +
 fs/f2fs/recovery.c                                 |  33 +-
 fs/f2fs/segment.c                                  |  56 +-
 fs/f2fs/segment.h                                  |   6 -
 fs/f2fs/super.c                                    |   4 +-
 fs/f2fs/sysfs.c                                    |  18 +-
 fs/freevxfs/vxfs_bmap.c                            |   3 +-
 fs/fuse/file.c                                     |   3 +-
 fs/fuse/virtio_fs.c                                |   2 +
 fs/gfs2/bmap.c                                     |  19 +
 fs/gfs2/bmap.h                                     |   1 +
 fs/gfs2/file.c                                     |  10 +
 fs/gfs2/quota.c                                    |  36 +-
 fs/hfs/catalog.c                                   |   9 -
 fs/hfs/dir.c                                       |  28 +-
 fs/hfs/hfs.h                                       |   3 +-
 fs/hfs/hfs_fs.h                                    |   2 -
 fs/hfs/inode.c                                     |   4 -
 fs/hfsplus/catalog.c                               |  11 -
 fs/hfsplus/dir.c                                   |  28 +-
 fs/hfsplus/hfsplus_fs.h                            |   5 +-
 fs/hfsplus/inode.c                                 |  40 +-
 fs/hfsplus/super.c                                 |   2 -
 fs/hpfs/super.c                                    |   3 +-
 fs/iomap/direct-io.c                               |   2 +-
 fs/isofs/inode.c                                   |   3 +-
 fs/jfs/super.c                                     |   3 +-
 fs/minix/inode.c                                   |   3 +-
 fs/netfs/buffered_read.c                           |   2 +-
 fs/netfs/buffered_write.c                          |   2 +-
 fs/netfs/direct_write.c                            |  31 +-
 fs/netfs/internal.h                                |  12 +
 fs/netfs/read_retry.c                              |   7 +-
 fs/netfs/write_issue.c                             |   2 +
 fs/netfs/write_retry.c                             |   7 +-
 fs/nfs/nfs42proc.c                                 |  15 +-
 fs/ntfs3/dir.c                                     |   4 +-
 fs/ntfs3/fslog.c                                   |  28 +-
 fs/ntfs3/index.c                                   |  41 +-
 fs/ntfs3/super.c                                   |   8 +-
 fs/ntfs3/xattr.c                                   |   4 +-
 fs/omfs/inode.c                                    |   6 +-
 fs/qnx4/inode.c                                    |   3 +-
 fs/smb/client/cached_dir.c                         |   2 +-
 fs/smb/client/cifs_fs_sb.h                         |   8 +-
 fs/smb/client/cifs_ioctl.h                         |   2 +-
 fs/smb/client/cifs_unicode.c                       |   4 +-
 fs/smb/client/cifsacl.c                            | 105 ++--
 fs/smb/client/cifsfs.c                             |  66 +--
 fs/smb/client/cifsglob.h                           |  10 +-
 fs/smb/client/cifspdu.h                            |   8 -
 fs/smb/client/cifssmb.c                            |   8 +
 fs/smb/client/connect.c                            |  70 +--
 fs/smb/client/dfs_cache.c                          |   2 +-
 fs/smb/client/dir.c                                |  16 +-
 fs/smb/client/file.c                               |  37 +-
 fs/smb/client/fs_context.c                         | 110 ++--
 fs/smb/client/inode.c                              |  80 +--
 fs/smb/client/ioctl.c                              |   2 +-
 fs/smb/client/link.c                               |   6 +-
 fs/smb/client/misc.c                               |  36 +-
 fs/smb/client/readdir.c                            |  25 +-
 fs/smb/client/reparse.c                            |  27 +-
 fs/smb/client/reparse.h                            |   4 +-
 fs/smb/client/smb1ops.c                            |   6 +-
 fs/smb/client/smb2file.c                           |   2 +-
 fs/smb/client/smb2misc.c                           |   4 +-
 fs/smb/client/smb2ops.c                            | 198 +++++--
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/smb/client/smb2pdu.h                            |  24 -
 fs/smb/client/transport.c                          |  11 +-
 fs/smb/client/xattr.c                              |   6 +-
 fs/smb/common/smb2pdu.h                            |  29 ++
 fs/smb/server/mgmt/share_config.c                  |  36 +-
 fs/smb/server/mgmt/user_session.c                  |  25 +-
 fs/smb/server/misc.c                               |  14 +-
 fs/smb/server/oplock.c                             | 166 ++++--
 fs/smb/server/oplock.h                             |   2 +-
 fs/smb/server/server.c                             |   6 +
 fs/smb/server/smb2misc.c                           |   9 +-
 fs/smb/server/smb2pdu.c                            | 281 +++++-----
 fs/smb/server/smb2pdu.h                            |  20 -
 fs/smb/server/smbacl.c                             |  88 ++--
 fs/smb/server/transport_ipc.c                      |  21 +-
 fs/smb/server/vfs.c                                |  46 +-
 fs/smb/server/vfs_cache.c                          |  28 +-
 fs/smb/server/vfs_cache.h                          |   8 +-
 fs/super.c                                         |   9 +-
 fs/ufs/cylinder.c                                  |  10 +
 fs/ufs/dir.c                                       |   2 +-
 fs/ufs/super.c                                     |  17 +-
 fs/xfs/libxfs/xfs_btree_mem.c                      |   2 +
 fs/xfs/libxfs/xfs_btree_staging.c                  |   4 +-
 fs/xfs/libxfs/xfs_defer.c                          |   2 +-
 fs/xfs/libxfs/xfs_exchmaps.c                       |  10 +
 fs/xfs/libxfs/xfs_parent.c                         |  13 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c               |   7 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c                   |   6 +-
 fs/xfs/scrub/agheader.c                            |   7 +
 fs/xfs/scrub/agheader_repair.c                     |  39 +-
 fs/xfs/scrub/alloc_repair.c                        |  18 +-
 fs/xfs/scrub/bmap.c                                |   2 +-
 fs/xfs/scrub/dir_repair.c                          |  10 +-
 fs/xfs/scrub/dirtree.c                             |  31 +-
 fs/xfs/scrub/dirtree_repair.c                      |   2 +
 fs/xfs/scrub/findparent.c                          |  56 +-
 fs/xfs/scrub/ialloc.c                              |   4 +
 fs/xfs/scrub/metapath.c                            |   4 +-
 fs/xfs/scrub/quota_repair.c                        |  14 +-
 fs/xfs/scrub/quotacheck.c                          |   4 +-
 fs/xfs/scrub/reap.c                                |   6 +-
 fs/xfs/scrub/refcount.c                            |   8 +-
 fs/xfs/scrub/rgsuper.c                             |   6 +-
 fs/xfs/scrub/rtrefcount.c                          |  82 ++-
 fs/xfs/scrub/rtsummary_repair.c                    |   3 +-
 fs/xfs/scrub/scrub.c                               |   3 +-
 fs/xfs/scrub/stats.c                               |  61 ++-
 fs/xfs/scrub/stats.h                               |   4 +-
 fs/xfs/scrub/symlink_repair.c                      |   2 +-
 fs/xfs/scrub/trace.h                               |  35 +-
 fs/xfs/xfs_buf.c                                   |   2 +-
 fs/xfs/xfs_exchmaps_item.c                         |  19 +-
 fs/xfs/xfs_exchrange.c                             |  12 +-
 include/linux/adi-axi-common.h                     |   2 +
 include/linux/bio.h                                |  14 -
 include/linux/bitfield.h                           |   2 +-
 .../bnxt/bnxt_ulp.h => include/linux/bnxt/ulp.h    |   0
 include/linux/bpf.h                                |   1 +
 include/linux/bpf_verifier.h                       |  12 +-
 include/linux/designware_i2c.h                     | 107 ++++
 include/linux/device.h                             |   9 +-
 include/linux/firmware/intel/stratix10-smc.h       |  18 +-
 include/linux/igmp.h                               |   7 +-
 include/linux/kcsan-checks.h                       |   6 +-
 include/linux/mailbox_controller.h                 |   2 +
 include/linux/mfd/db8500-prcmu.h                   | 252 ++++++++-
 include/linux/mfd/dbx500-prcmu.h                   | 575 ---------------------
 include/linux/mmap_lock.h                          |   2 +
 include/linux/ns_common.h                          |   7 +-
 include/linux/nsproxy.h                            |   2 +-
 include/linux/oa_tc6.h                             |  50 ++
 include/linux/perf/riscv_pmu.h                     |   2 +-
 include/linux/platform_data/cros_ec_proto.h        |   2 +
 include/linux/rbtree_augmented.h                   |  35 +-
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |   5 +-
 include/linux/skbuff.h                             |   5 +
 include/linux/switchtec.h                          |   1 +
 include/linux/thunderbolt.h                        |   2 +
 include/media/v4l2-hevc.h                          |  41 ++
 include/net/cfg80211.h                             |   2 +-
 include/net/cfg802154.h                            |   1 +
 include/net/devlink.h                              |  10 +-
 include/net/if_inet6.h                             |   2 -
 include/net/inet_connection_sock.h                 |  20 +-
 include/net/ip.h                                   |   3 +-
 include/net/ip6_route.h                            |   2 +
 include/net/ip_fib.h                               |   5 +
 include/net/netdev_lock.h                          |   6 +
 include/net/netfilter/nf_conntrack_timeout.h       |  27 +-
 include/net/sch_generic.h                          |   2 +-
 include/net/sock.h                                 |   9 +-
 include/net/tcp.h                                  |   3 +-
 include/rdma/ib_umem.h                             |  15 +-
 include/sound/tas2781.h                            |   4 +-
 include/trace/events/cachefiles.h                  |  19 +-
 include/trace/events/icmp.h                        |  13 +-
 include/uapi/drm/amdgpu_drm.h                      |   2 +-
 include/uapi/linux/landlock.h                      |  37 +-
 include/uapi/sound/intel/avs/tokens.h              |   6 +
 init/main.c                                        |  36 +-
 io_uring/net.c                                     |  51 +-
 io_uring/rw.c                                      |  25 +-
 kernel/bpf/bpf_iter.c                              |   2 +-
 kernel/bpf/btf.c                                   |  27 +-
 kernel/bpf/cgroup.c                                |   1 +
 kernel/bpf/disasm.c                                |   5 +-
 kernel/bpf/log.c                                   |   4 +-
 kernel/bpf/stackmap.c                              |   2 +
 kernel/bpf/verifier.c                              | 245 +++++++--
 kernel/cgroup/cgroup.c                             |   6 +-
 kernel/events/core.c                               |   7 +-
 kernel/events/ring_buffer.c                        |   9 +-
 kernel/exit.c                                      |  11 +-
 kernel/fork.c                                      |   2 +-
 kernel/irq/manage.c                                |  37 +-
 kernel/irq/proc.c                                  |   7 +-
 kernel/locking/lockdep.c                           |  50 +-
 kernel/nsproxy.c                                   |   2 +-
 kernel/power/hibernate.c                           |  46 +-
 kernel/printk/nbcon.c                              |   2 +-
 kernel/rcu/tasks.h                                 |   3 +-
 kernel/reboot.c                                    |  19 +-
 kernel/sched/core.c                                |  33 +-
 kernel/sched/deadline.c                            |  18 +-
 kernel/sched/fair.c                                |  29 +-
 kernel/sched/rt.c                                  |  15 +-
 kernel/signal.c                                    |  12 +
 kernel/time/clockevents.c                          |  35 +-
 kernel/time/tick-broadcast.c                       |  36 +-
 kernel/time/tick-internal.h                        |   2 +
 kernel/trace/Makefile                              |   5 +-
 kernel/trace/bpf_trace.c                           |  11 +
 kernel/trace/ring_buffer.c                         |  21 +-
 kernel/trace/trace.c                               |  68 ++-
 kernel/trace/trace.h                               | 125 ++---
 kernel/trace/trace_eprobe.c                        |  19 +-
 kernel/trace/trace_event_perf.c                    |  12 +-
 kernel/trace/trace_events.c                        |   2 +
 kernel/trace/trace_events_hist.c                   | 209 +++-----
 kernel/trace/trace_events_trigger.c                | 344 +++++-------
 kernel/trace/trace_events_user.c                   |  26 +-
 kernel/trace/trace_functions_graph.c               |   3 +
 kernel/trace/trace_probe.c                         |  48 +-
 kernel/trace/trace_probe.h                         |   2 +
 kernel/workqueue.c                                 |   3 +
 mm/damon/core.c                                    |  13 +-
 net/9p/client.c                                    |   2 +-
 net/appletalk/aarp.c                               |   5 +
 net/bluetooth/hci_core.c                           |   4 +-
 net/bluetooth/hci_sysfs.c                          |  17 +-
 net/bluetooth/iso.c                                |  31 +-
 net/bluetooth/l2cap_core.c                         |  38 +-
 net/bluetooth/msft.c                               |   2 +-
 net/bluetooth/rfcomm/core.c                        |   5 +
 net/bridge/br_arp_nd_proxy.c                       |  16 +-
 net/bridge/br_cfm.c                                |  11 +-
 net/bridge/br_device.c                             |   3 +-
 net/bridge/br_fdb.c                                |   7 +-
 net/bridge/br_input.c                              |  37 +-
 net/bridge/br_mrp.c                                |  13 +-
 net/bridge/br_multicast.c                          |  11 +-
 net/bridge/br_private.h                            |  26 +-
 net/core/dev.c                                     |  89 ++--
 net/core/drop_monitor.c                            |  18 +-
 net/core/filter.c                                  |  17 +-
 net/core/gro_cells.c                               |   2 +
 net/core/rtnetlink.c                               |   7 +-
 net/core/skbuff.c                                  |   7 +
 net/devlink/port.c                                 |   2 +
 net/devlink/resource.c                             | 161 ++++--
 net/dsa/tag_brcm.c                                 |   1 +
 net/ethtool/cmis_cdb.c                             |   3 +
 net/ethtool/cmis_fw_update.c                       |   8 +-
 net/ethtool/module.c                               |   2 +
 net/hsr/hsr_forward.c                              |   2 +-
 net/hsr/hsr_netlink.c                              |   9 +-
 net/hsr/hsr_slave.c                                |  11 +-
 net/ieee802154/6lowpan/core.c                      |   2 +-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fib_trie.c                                |   4 +
 net/ipv4/fou_core.c                                |   2 +-
 net/ipv4/igmp.c                                    | 210 +++++---
 net/ipv4/inet_connection_sock.c                    |  12 +-
 net/ipv4/inet_diag.c                               |   8 +-
 net/ipv4/inet_fragment.c                           |   6 +
 net/ipv4/ip_output.c                               |   1 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/ipmr.c                                    |   3 +-
 net/ipv4/ipmr_base.c                               |   2 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/tcp.c                                     |  14 +-
 net/ipv4/tcp_ipv4.c                                |   8 +-
 net/ipv4/tcp_offload.c                             |  22 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv4/tcp_timer.c                               |  29 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/addrconf.c                                |  10 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/exthdrs.c                                 |   4 +-
 net/ipv6/ip6_fib.c                                 |   4 +-
 net/ipv6/ip6_flowlabel.c                           |  19 +
 net/ipv6/ip6_gre.c                                 |   6 +-
 net/ipv6/ip6_output.c                              |   2 +
 net/ipv6/ip6mr.c                                   |   2 +-
 net/ipv6/mcast.c                                   | 116 +++--
 net/ipv6/netfilter/ip6_tables.c                    |   5 +
 net/ipv6/route.c                                   |  14 +-
 net/ipv6/tcp_ipv6.c                                |   8 +-
 net/ipv6/tcpv6_offload.c                           |  15 +-
 net/l2tp/l2tp_debugfs.c                            |   4 +
 net/l2tp/l2tp_ppp.c                                |  56 +-
 net/mac80211/cfg.c                                 |   9 +-
 net/mac80211/chan.c                                |  10 +-
 net/mac80211/ibss.c                                |   9 +-
 net/mac80211/ieee80211_i.h                         |   9 +
 net/mac80211/link.c                                |  30 ++
 net/mac80211/mlme.c                                |  97 ++--
 net/mac80211/parse.c                               |   4 +
 net/mac80211/status.c                              |   9 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac80211/util.c                                |   6 +-
 net/mac802154/ieee802154_i.h                       |   8 +
 net/mac802154/iface.c                              |   6 +
 net/mac802154/main.c                               |   1 +
 net/mac802154/rx.c                                 | 120 ++++-
 net/mac802154/scan.c                               |  10 +-
 net/mptcp/options.c                                |   7 +-
 net/mptcp/pm.c                                     |   2 +-
 net/mptcp/pm_kernel.c                              |   8 +
 net/mptcp/pm_userspace.c                           |  18 +-
 net/mptcp/protocol.c                               |  55 +-
 net/mptcp/protocol.h                               |   5 +-
 net/mptcp/subflow.c                                |   1 -
 net/mptcp/syncookies.c                             |   5 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  13 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  20 +-
 net/netfilter/nf_conntrack_core.c                  |   6 +-
 net/netfilter/nf_conntrack_expect.c                |   3 +-
 net/netfilter/nf_conntrack_netlink.c               |  13 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_conntrack_timeout.c               |  27 +-
 net/netfilter/nf_log_syslog.c                      |   6 +-
 net/netfilter/nfnetlink_cttimeout.c                | 114 ++--
 net/netfilter/nfnetlink_log.c                      |  28 +-
 net/netfilter/nft_ct.c                             |   7 +-
 net/netfilter/xt_CT.c                              |   2 +-
 net/netlabel/netlabel_unlabeled.c                  |   2 +-
 net/netlink/genetlink.c                            |  21 +-
 net/openvswitch/flow.c                             |   4 +-
 net/openvswitch/flow_table.c                       |   4 +-
 net/packet/af_packet.c                             |   5 +-
 net/phonet/pn_dev.c                                |  30 +-
 net/psp/psp_main.c                                 |   9 +
 net/qrtr/af_qrtr.c                                 |   4 +-
 net/rds/af_rds.c                                   |  63 ++-
 net/rds/connection.c                               | 102 +++-
 net/rds/ib_cm.c                                    |  25 +-
 net/rds/ib_recv.c                                  |   9 +-
 net/rds/message.c                                  |   4 +-
 net/rds/send.c                                     |  16 +-
 net/rds/tcp.c                                      | 164 ++++--
 net/rds/tcp_listen.c                               |   6 +-
 net/sched/act_api.c                                |  46 +-
 net/sched/act_csum.c                               |   8 +-
 net/sched/cls_api.c                                |   8 +-
 net/sched/cls_route.c                              |  76 +--
 net/sched/cls_u32.c                                |  32 +-
 net/sched/sch_api.c                                |   2 +-
 net/sched/sch_drr.c                                |  13 +-
 net/sched/sch_dualpi2.c                            |  10 +-
 net/sched/sch_ets.c                                |  12 +-
 net/sched/sch_fq_pie.c                             |   3 +-
 net/sched/sch_generic.c                            |  24 +-
 net/sched/sch_hhf.c                                |   8 +-
 net/sched/sch_pie.c                                |   2 +-
 net/sched/sch_sfq.c                                |   7 +-
 net/sctp/ipv6.c                                    |  12 +-
 net/sctp/protocol.c                                |  10 +-
 net/sctp/sm_make_chunk.c                           |  14 +-
 net/sctp/sm_sideeffect.c                           |  11 +-
 net/sctp/sm_statefuns.c                            |   5 +
 net/sunrpc/xprtrdma/verbs.c                        |  21 +-
 net/tipc/link.c                                    |   6 +-
 net/tipc/name_table.c                              |  32 +-
 net/tipc/socket.c                                  |   4 +-
 net/tls/tls_main.c                                 |  11 +
 net/tls/tls_sw.c                                   |  12 +
 net/unix/af_unix.c                                 |  12 +-
 net/unix/garbage.c                                 |   1 +
 net/vmw_vsock/hyperv_transport.c                   |   2 +-
 net/vmw_vsock/vmci_transport.c                     |   2 +-
 net/wireless/core.c                                |  21 +
 net/wireless/mlme.c                                | 105 ++--
 net/wireless/nl80211.c                             |  13 +-
 net/wireless/scan.c                                |   6 +-
 net/wireless/wext-sme.c                            |   9 +
 rust/bindings/lib.rs                               |   4 +-
 rust/uapi/lib.rs                                   |   4 +-
 scripts/mksysmap                                   |   4 +-
 scripts/mod/modpost.c                              |  11 +-
 scripts/sorttable.c                                |   2 +-
 security/apparmor/match.c                          |  22 +-
 security/integrity/digsig_asymmetric.c             |   4 +
 security/integrity/ima/ima_appraise.c              |   5 +
 security/landlock/access.h                         |  35 +-
 security/landlock/audit.c                          |  81 +--
 security/landlock/audit.h                          |   3 +-
 security/landlock/domain.c                         |  44 +-
 security/landlock/domain.h                         |   3 +-
 security/landlock/fs.c                             | 353 ++++++-------
 security/landlock/net.c                            |   9 +-
 security/landlock/ruleset.c                        |  89 ++--
 security/landlock/ruleset.h                        |   6 +-
 sound/core/pcm_native.c                            |  35 +-
 sound/core/seq/oss/seq_oss_rw.c                    |   3 +-
 sound/core/seq/seq_prioq.c                         |  14 +-
 sound/core/ump.c                                   |   4 +
 sound/drivers/dummy.c                              |   2 +-
 sound/hda/codecs/Kconfig                           |   1 +
 sound/hda/codecs/ca0132.c                          | 111 +++-
 sound/hda/codecs/conexant.c                        |  12 +
 sound/hda/codecs/realtek/alc269.c                  |  40 ++
 sound/hda/codecs/realtek/alc882.c                  |  22 +
 sound/hda/codecs/side-codecs/Kconfig               |   2 +
 .../hda/codecs/side-codecs/cs35l41_hda_property.c  |   2 +
 sound/hda/codecs/side-codecs/cs35l56_hda.c         |  30 +-
 sound/hda/common/codec.c                           |   4 +-
 sound/hda/core/device.c                            |   5 +-
 sound/isa/es18xx.c                                 |   4 +
 sound/pci/ctxfi/cthw20k2.c                         |   1 +
 sound/pci/ice1712/ice1724.c                        |  19 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  21 +
 sound/soc/amd/yc/acp6x-pdm-dma.c                   |   2 +
 sound/soc/bcm/bcm63xx-i2s-whistler.c               |   1 +
 sound/soc/codecs/ab8500-codec.c                    | 543 ++++++++++---------
 sound/soc/codecs/mt6351.c                          |   1 +
 sound/soc/codecs/pcm3168a.c                        |  21 +-
 sound/soc/codecs/rk3328_codec.c                    |  54 +-
 sound/soc/codecs/rt5645.c                          |   4 +
 sound/soc/codecs/rt712-sdca.c                      |  11 +
 sound/soc/fsl/fsl-asoc-card.c                      |   8 +-
 sound/soc/fsl/fsl_micfil.c                         |  21 +-
 sound/soc/intel/atom/sst/sst_pci.c                 |   1 +
 sound/soc/intel/avs/core.c                         |  29 +-
 sound/soc/intel/avs/debugfs.c                      |  12 +-
 sound/soc/intel/avs/path.c                         |  24 +-
 sound/soc/intel/avs/pcm.c                          |  34 +-
 sound/soc/intel/avs/topology.c                     | 162 +++++-
 sound/soc/intel/avs/topology.h                     |  13 +-
 sound/soc/intel/boards/sof_sdw.c                   |  25 +-
 sound/soc/intel/catpt/ipc.c                        |   8 +
 sound/soc/intel/catpt/loader.c                     |   3 +
 sound/soc/intel/catpt/registers.h                  |  12 +
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c         |  13 +-
 sound/soc/meson/aiu-acodec-ctrl.c                  |   3 +
 sound/soc/meson/aiu-codec-ctrl.c                   |   3 +
 sound/soc/qcom/qdsp6/q6apm.c                       |  10 +-
 sound/soc/rockchip/rockchip_pdm.c                  |  16 +-
 sound/soc/rockchip/rockchip_spdif.c                |   1 +
 sound/soc/soc-topology.c                           |  37 +-
 sound/soc/sprd/sprd-pcm-compress.c                 |  15 +-
 sound/soc/sti/uniperif_reader.c                    |   4 +-
 sound/soc/ti/omap3pandora.c                        |   5 +-
 sound/soc/ux500/ux500_msp_dai.c                    | 189 +++----
 sound/soc/ux500/ux500_msp_dai.h                    |  14 +-
 sound/soc/ux500/ux500_msp_i2s.c                    | 260 +++++++---
 sound/soc/ux500/ux500_msp_i2s.h                    |  12 +-
 sound/usb/caiaq/audio.c                            |  10 +-
 sound/usb/caiaq/device.c                           |  53 +-
 sound/usb/caiaq/device.h                           |   4 +-
 sound/usb/caiaq/input.c                            |   6 +
 sound/usb/caiaq/midi.c                             |   6 +-
 sound/usb/mixer.c                                  |  17 +-
 sound/usb/mixer_maps.c                             |  25 +
 sound/usb/quirks-table.h                           |  22 +
 sound/usb/quirks.c                                 |   4 +
 sound/usb/usx2y/us122l.c                           |   7 +-
 sound/usb/usx2y/usbusx2y.c                         |  49 +-
 sound/usb/usx2y/usbusx2y.h                         |   4 +-
 tools/bootconfig/main.c                            |  13 +-
 tools/bpf/bpftool/Makefile                         |   6 +-
 tools/build/feature/test-bpf.c                     |   2 +
 tools/include/nolibc/crt.h                         |   2 +-
 tools/lib/bpf/bpf.c                                |   2 +
 tools/lib/bpf/gen_loader.c                         |   2 +
 .../xdrgen/templates/C/union/declaration/close.j2  |   4 +
 tools/perf/util/powerpc-vpadtl.c                   |   2 +-
 tools/perf/util/symbol.c                           |  11 +-
 tools/sched_ext/scx_central.bpf.c                  |   6 +-
 tools/sched_ext/scx_flatcg.bpf.c                   |  14 +-
 tools/sched_ext/scx_simple.bpf.c                   |   6 +-
 tools/testing/selftests/alsa/mixer-test.c          |   4 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |   8 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  |   8 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |   8 +-
 .../selftests/bpf/progs/test_global_func3.c        |  18 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  28 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   4 +-
 tools/testing/selftests/net/pmtu.sh                |   2 +-
 tools/testing/selftests/net/test_vxlan_mdb.sh      |   6 +
 tools/testing/selftests/powerpc/tm/tm.h            |   8 +-
 .../selftests/sched_ext/select_cpu_vtime.bpf.c     |   6 +-
 1202 files changed, 16489 insertions(+), 8703 deletions(-)


