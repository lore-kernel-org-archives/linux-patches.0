Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E514DDB2F;
	Thu, 17 Sep 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658384; cv=none; b=ooufvk5yR29bxTYVkDdht+GRKHlJGhGxQhHhJSqzxENpN4n+nO693UNaGJlr4a+mf0mzjgvONPTVJzvH91Afkp/+K5LiJF6Df6eNXFE0tXfw3FZ/eQW92zW5x1jGjtBLYPOju/jrUY8kpYtlZ2IFKuiXdDIjEEABiNH2CPsPbAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658384; c=relaxed/simple;
	bh=efWa5tUgtYej7HTjFbHDfadaWZ4bf8F61x7JUJGGcG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XspRyoIPQxaUlI/eZexWv62h/tTBggtm1i+/pjTNxpW8Yldwunh6Zsg6nE6EVJoUUiUZ1E+v2ovfeiD5QLkZjPxWDfSlMopFR2uL6HdTrASsq+NhcuNJjc+x4viJKJvytbg431gLugSsHQPqtXx9kcoUgvuVW/N+6QovbrbFVYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lv/nzPcG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lv/nzPcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3FD1F000FF;
	Thu, 17 Sep 2026 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658366;
	bh=r00LG5fshK1trNiWQqggXFRe4wmjodBBz3P4hR5vetA=;
	h=From:To:Cc:Subject:Date;
	b=lv/nzPcGRymxDyTZ/nA2L/jVgriGqUuXawcK1VZpb2hH/WRr7AiZA/rkwbOJwYeO4
	 5UkSvn13qwZI2GcfJCgzFpdv64t4JsM+YRBIyxfnj3n0aSpWX8iiJpAyf9ldniUHKO
	 +OKDB5btY8O7VF3OG/9VmffgdIS5l0fFbC4QGlJI=
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
Subject: [PATCH 7.2 000/733] 7.2.7-rc1 review
Date: Thu, 17 Sep 2026 16:05:08 +0100
Message-ID: <20260917151350.597953846@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.7-rc1
X-KernelTest-Deadline: 2026-09-19T15:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.7 release.
There are 733 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 19 Sep 2026 15:12:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.7-rc1

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix and document DEBUG_PAGEALLOC

Griffin Kroah-Hartman <griffin@kroah.com>
    misc: amd-sbi: Add null check for devm_kasprintf()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    x86/mm/pat: Allocate split page tables as kernel page tables

Thomas Richter <tmricht@linux.ibm.com>
    s390/pai: Support CPU hotplug for PMU PAI

Thomas Richter <tmricht@linux.ibm.com>
    s390/pai: Move locking to event init and delete

Thomas Richter <tmricht@linux.ibm.com>
    s390/pai: Use PAI PMU index as parameter replacing event

Satyajit Roy <sroy14@alum.utk.edu>
    drm/amd/display: Honor Broadcast RGB for BT.2020 RGB output

Satyajit Roy <sroy14@alum.utk.edu>
    drm/amd/display: Propagate HDMI RGB quantization selectability

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip vport under deletion in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path

Dinh Nguyen <dinguyen@kernel.org>
    EDAC/altera: Use parent device for devres in altr_portb_setup()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()

Arda Doğu Ari <arfeliousheres@gmail.com>
    platform/x86: hp-wmi: Fix board_params typo for 8DD6 board

Radhey Kalra <radheykalra901@gmail.com>
    platform/x86: hp-wmi: Introduce board-specific feature data

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    drm/xe/i2c: Fix the interrupt handling

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    i2c: designware: Global register definitions

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Disable device buffer exporting

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/cdclk: Avoid spurious cdclk sanitization on PTL+

Chao Yu <chao@kernel.org>
    f2fs: fix to reset all pinned status during fggc

Chao Yu <chao@kernel.org>
    f2fs: fix to shrink gc_lock coverage in f2fs_gc_range()

Daeho Jeong <daehojeong@google.com>
    f2fs: accurately adjust free_sections during free_segment_range

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

Hungyu Lin <dennylin0707@gmail.com>
    media: qcom: iris: fix runtime PM reference leaks

Sang-Heon Jeon <ekffu200098@gmail.com>
    media: remove conditional return with no effect

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Synchronize HID command and report handling

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Validate HID report lengths

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Add per-device configuration

Gary Guo <gary@garyguo.net>
    usb: usbtmc: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    usb: xusbatm: don't rely on id table pointer arithmetic

Gary Guo <gary@garyguo.net>
    net: usb: pegasus: don't rely on id table pointer arithmetic

Gary Guo <gary@garyguo.net>
    usb: serial: spcp8x5: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    media: as102: do not rely on id table address comparison

Gary Guo <gary@garyguo.net>
    wifi: ath9k_htc: don't store usb_device_id

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix race between kexec and snd_soc_register_component()

Darrick J. Wong <djwong@kernel.org>
    xfs: actually check internal-rtdev fields in the superblock

Darrick J. Wong <djwong@kernel.org>
    xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent

Darrick J. Wong <djwong@kernel.org>
    xfs: advance the findparent inode scan cursor while holding ILOCK

Darrick J. Wong <djwong@kernel.org>
    xfs: always set xfs_healthmon::first_event when inserting at front of list

Darrick J. Wong <djwong@kernel.org>
    xfs: bail out on bitmap errors in xrep_agfl_fill

Darrick J. Wong <djwong@kernel.org>
    xfs: bump lost_prev_errors if we lose even the healthmon lost event

Darrick J. Wong <djwong@kernel.org>
    xfs: check healthmon outbuffer space correctly

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
    xfs: don't stash removename operations with unknown ftype

Darrick J. Wong <djwong@kernel.org>
    xfs: fix backwards mergeability logic in refcount scrubber

Darrick J. Wong <djwong@kernel.org>
    xfs: fix backwards skipping logic in xrep_quota_block

Darrick J. Wong <djwong@kernel.org>
    xfs: fix bnobt repair space reservation disposal failure

Lin Jiapeng <ljp1205831794@gmail.com>
    xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Darrick J. Wong <djwong@kernel.org>
    xfs: fix media verification ioctl for internal rt volumes

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
    xfs: fix under-reservation of blocks when repairing sf directories

Darrick J. Wong <djwong@kernel.org>
    xfs: fix unit conversions in per_binval computation

Darrick J. Wong <djwong@kernel.org>
    xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems

Javier Tia <javier@peridio.com>
    xfs: initialise args->total for parent pointer updates

Javier Tia <javier@peridio.com>
    xfs: initialise error in xfs_defer_finish_one()

Darrick J. Wong <djwong@kernel.org>
    xfs: lock the healthmon when inserting unmount event

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

Paulo Alcantara <pc@manguebit.org>
    smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()

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

Fan Wu <fanwu01@zju.edu.cn>
    smb: client: fix cifsFileInfo reference leak in deferred close

Bjoern Doebel <doebel@amazon.de>
    smb: client: fail DACL rewrite when the new DACL exceeds 64K

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix one-byte OOB read in smb2_parse_native_symlink()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix uid/gid override in getattr with posix extensions

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix WSL reparse point uid/gid override

Paulo Alcantara <pc@manguebit.org>
    smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid

Karl Mehltretter <kmehltretter@gmail.com>
    smb: client: pin DFS superblock in iterator callback

Diego Oliva <diego@bynar.io>
    smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()

Aohan Mei <henrymei@tencent.com>
    smb: client: reject userspace cifs.idmap descriptions

Diego Oliva <diego@bynar.io>
    smb: client: reject short READ responses in CIFSSMBRead()

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: userspace: fix address ID overflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset retrans_time when ADD_ADDR entry is reused

Kalpan Jani <kalpan.jani@mpiricsoftware.com>
    mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent race between disconnect() and rtx

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: lib: get counters for the right test

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: lib: dump nstat for the right test

Gang Yan <yangang@kylinos.cn>
    selftests: mptcp: fix an UAF in mptcp_connect.c

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: fix uninit-value in mptcp_write_data_fin

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: syncookies: remember the request backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: subflow: no need to copy thmac during ulp_clone

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: handle MPC data + csum reqd + no csum

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not reschedule the RTX timer for fallback sockets

Joe Damato <joe@dama.to>
    bnxt_en: Prevent queue stop with deferred completions

Joe Damato <joe@dama.to>
    bnxt_en: Bound SW TPA IDs to prevent crashes

Joe Damato <joe@dama.to>
    bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()

Joe Damato <joe@dama.to>
    bnxt_en: Propagate RX ring init failures in bnxt_init_nic()

Joe Damato <joe@dama.to>
    bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()

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
    media: rkvdec: bound HEVC tile loops and PPS id to the array capacity

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: hantro: bound G2 HEVC tile loop to the buffer capacity

Sergey Zagursky <gvozdoder@gmail.com>
    media: ipu-bridge: do not use the CVS device lookup for IVSC

Michael Bommarito <michael.bommarito@gmail.com>
    media: hevc: add bounded tile-count helpers

Vishnu Razdan <vrazdan@openai.com>
    hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    hwmon: (mcp9982) Propagate one-shot polling errors

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

Mahmoud Nagy Adam <mngyadam@amazon.de>
    selftests: ublk: install test_common.sh and trace/ scripts

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

Norbert Szetei <norbert@doyensec.com>
    landlock: Fix use-after-free of the source's parent directory

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

Myeonghun Pak <mhun512@gmail.com>
    idpf: disable DIM work before freeing q_vectors

Weiming Shi <bestswngs@gmail.com>
    fbdev: vfb: defer cleanup until the last reference

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    erofs: preserve LZMA decoders on resize failure

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: add sysfs feature entry for xattr prefixes

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

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: cttimeout: prevent UAF during module unload

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

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: macb: initialize PTP state before registering clock

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

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: end write accounting from ->ki_complete

Satyajit Roy <sroy14@alum.utk.edu>
    drm/amd/display: Rebuild InfoFrames on output color space changes

Fangzhi Zuo <jerry.zuo@amd.com>
    drm/amd/display: Exit IPS before connector detection on resume

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Flush LSC untyped L1 dataport cache after rcs/ccs batches

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sched: Create a fake device for KUnit tests

Yudi Yang <2000jedi@gmail.com>
    drm/rockchip: analogix_dp: fix unchecked bound endpoint name length

Thorsten Blum <thorsten.blum@linux.dev>
    drm/i915: Fix memory leak in query_perf_config_list()

Sunil Khatri <sunil.khatri@amd.com>
    drm/drm_exec: fix up contended obj when num_objects is 0

Esben Haabendal <esben@geanix.com>
    drm/bridge: ti-sn65dsi83: Fix error handling in sn65dsi83_reset_work()

Leonardo Costa <leonardo.costa@toradex.com>
    drm/bridge: tc358768: Enforce input bus flags via atomic_check

Kevin Wang <kevin.wang@amd.com>
    drm/amd/pm: fix gpu metrics energy accumulator for smu 13.0.0/13.0.7

Andrea Parri <parri.andrea@gmail.com>
    hrtimer: Use hard expiry when updating timers on the same base

XingWang Xiang <v3rdant.xiang@gmail.com>
    genetlink: pin family module during policy dump

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    function_graph: Use the saved entry's size when reprinting it

Moritz Tanner <moritz.tanner@linbit.com>
    fs: don't return -EINVAL for successful nested thaw

Daehyeon Ko <4ncienth@gmail.com>
    exit: hold a reference to thread_pid across proc_flush_pid

Jann Horn <jannh@google.com>
    exec: do_close_on_exec() before taking exec_update_lock

Runyu Xiao <runyu.xiao@seu.edu.cn>
    cpufreq: initialize policy rwsem before sysfs publication

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: zero-initialize policy cpumask before sysfs publication

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix integer overflow in initrd size check

Rong Zhang <i@rong.moe>
    Bluetooth: btrtl: Don't leak return code when parsing firmware format v2

Xu Rao <raoxu@uniontech.com>
    Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: sti: initialize IRQ lock before requesting IRQ

Tianchu Chen <flynnnchen@tencent.com>
    ASoC: sprd: validate compress buffer sizes against fixed allocations

Yorick Rommers <yorick-rommers@hotmail.com>
    ASoC: amd: acp-da7219-max98357a: don't bind on Raven/Picasso boards

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ata: pata_legacy: remove documentation for removed module parameters

Rob Herring (Arm) <robh@kernel.org>
    accel: ethosu: Ensure SRAM region size matches job

Rob Herring (Arm) <robh@kernel.org>
    accel: ethosu: Ensure SRAM size is 0 on mapping failure

Rob Herring (Arm) <robh@kernel.org>
    accel: ethosu: Ensure cmd stream ends with a stop op

Rob Herring (Arm) <robh@kernel.org>
    accel: ethosu: Drop IRQF_SHARED flag

Rob Herring (Arm) <robh@kernel.org>
    accel: ethosu: Fix ethosu_job_open() return value

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    accel/ivpu: Limit firmware log name prints to field size

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate firmware log buffer metadata

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate full buffer range in ivpu_to_cpu_addr

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Undo the registration when enabling the histogram trigger fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Take the reference before publishing the named histogram trigger

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

Thomas Gleixner <tglx@kernel.org>
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

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/amdgpu: skip the VMID 0 flush for VRAM

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: skip gfx switch_power_profile during GPU reset

Harry Wentland <harry.wentland@amd.com>
    dm/amdgpu: fix malformed link_settings debugfs output

Andy Chiu <tchiu@tenstorrent.com>
    riscv: hwprobe: initialize pair->value in hwprobe_one_pair()

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

Gary Guo <gary@garyguo.net>
    rust: pin-init: use irrefutable pattern for `stack_pin_init`

Younes Akhouayri <git@younes.io>
    rust: num: seal Integer

Ali Ahmet Memiş <aliamemis@disroot.org>
    tracing: Don't dereference trace_event_file in deferred trigger free

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening a tracer options file

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix memory corruption from a "STACKTRACE" histogram key

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Set the trace clock before registering the histogram trigger

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tracing: Restore :mod: trailer after parsing in ftrace_set_clr_event()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix memory corruption from the histogram stacktrace modifier

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    ftrace: fork: Initialize function graph state before copy_exec_state()

Leon Hwang <leon.hwang@linux.dev>
    ftrace: Use rcu_assign_pointer() for tmp_ops filter hash

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    reboot: fix cad_pid use-after-free race

Zihan Xi <zihanx@nebusec.ai>
    ipmr: account multicast table and route memory

Zihan Xi <zihanx@nebusec.ai>
    ipv6: fix fib6 walker UAF on seq stop

Harry Yoo (Meta) <harry@kernel.org>
    mm/slab: take n->list_lock in __slab_try_return_freelist() to avoid race

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

Jasjeet Rangi <jrangi@purestorage.com>
    x86/MCE/AMD: Fix inverted interrupt enablement during storm handling

Jason Andryuk <jason.andryuk@amd.com>
    x86/amd_node: Avoid divide by zero on virtualized systems

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc: pci-ioda: Fix the stale irq chip reference

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/eeh: Fix recursive locking on devices without EEH sensitive driver

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/ps3: Fix repository.c build failure

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: unhash the dentry before dropping the item in rmdir

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: pin the symlink target's dirent instead of chasing ->ci_dentry

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands

Vincent Donnefort <vdonnefort@google.com>
    tracing/remotes: Catch nr_page_va overflow in ring_buffer_desc sizing

Vincent Donnefort <vdonnefort@google.com>
    tracing/remotes: Account for ring buffer page header in size calculation

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    scripts/mksysmap: fix escape of '$' in the __pi_ pattern

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    scripts/mksysmap: drop the MODULE_INFO() symbols from kallsyms

Karl Mehltretter <kmehltretter@gmail.com>
    tracing: Fix ring_buffer_read_page_size() kernel-doc

Binglei Wang <l3b2w1@gmail.com>
    erofs: add missing buf->off in erofs_bread()

Yang Xiuwei <yangxiuwei@kylinos.cn>
    ublk: clear force_abort in ublk_queue_reset_io_flags()

Stian Halseth <stian@itx.no>
    sunvdc: unmap LDC cookies when the descriptor send fails

David Howells <dhowells@redhat.com>
    block: Fix start and length check added to iov_iter_extract_bvecs()

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: fix wrong flag value in get_ipv6_ext_hdrs()

MD Danish Anwar <danishanwar@ti.com>
    net: hsr: enable promiscuous mode on interlink port with fwd offload

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix TX descriptor availability check for TSO traffic

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

Thomas Richter <tmricht@linux.ibm.com>
    perf/core: Allow list_del during perf_event_overflow()

Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
    drm/i915/dp: Gate UHBR SST SDP splitting on sink capability

Thibault Ferrante <thibault.ferrante@canonical.com>
    selftests/powerpc/tm: Fix tcheck() reading uninitialised CR value

Aboorva Devarajan <aboorvad@linux.ibm.com>
    powerpc/entry: Fix double accounting of user time on interrupt entry

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Move representor vnic reporter to eswitch devlink port

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: initialize ptp_lock at probe time

Aleksei Sviridkin <f@lex.la>
    net: phylink: initialise link_state before a forced major config

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

Varun Gupta <varun.gupta@intel.com>
    drm/xe: Guard page-fault worker with runtime PM check

Norbert Szetei <norbert@doyensec.com>
    nstree: check listing permission before taking a namespace reference

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

Rong Zhang <i@rong.moe>
    Bluetooth: Properly disable remote wakeup for MT7922/MT7925 on Ryzen platform

Jakub Kicinski <kuba@kernel.org>
    eth: ice: don't dereference pointers from TP_printk()

Jacob Keller <jacob.e.keller@intel.com>
    ice: add missing xa_destroy for sched_node_ids

Joshua Hay <joshua.a.hay@intel.com>
    idpf: account for VLAN header when parsing RSC packet header

Hans de Goede <johannes.goede@oss.qualcomm.com>
    platform/x86: x86-android-tablets: fix gpio_secondary_fwnode_init() not working

HyeongJun An <sammiee5311@gmail.com>
    ALSA: hda: Report a change when only the channel status bytes move

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/debug: Fix NULL pointer dereference in debug_set_level()

Karl Mehltretter <kmehltretter@gmail.com>
    drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER

Karl Mehltretter <kmehltretter@gmail.com>
    drm/adp: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX descriptors for freeq refill

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX drops once per frame

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count dropped frames as NAPI work

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Finish RX updates before NAPI completion

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Fix budget accounting

Aleksei Sviridkin <f@lex.la>
    net: macb: reject an unknown link speed in the taprio setup

Aleksei Sviridkin <f@lex.la>
    net: macb: zero the link settings taprio reads back

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vduse: return compat ioctl results directly

Alice Mikityanska <alice.kernel@fastmail.im>
    net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward

Alice Mikityanska <alice.kernel@fastmail.im>
    net: ipv6: Fix UDP length overflow with PMTU discover and big MTU

Alice Mikityanska <alice.kernel@fastmail.im>
    net: ipv4: Fix UDP length overflow with PMTU discover and big MTU

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Return immediately when manage_oob() returns NULL for 0-length buffer.

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Update last skb marker in manage_oob().

Karl Mehltretter <kmehltretter@gmail.com>
    virtio_input: stop callbacks before unregistering input device

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_input: reset device if input_register_device() fails

Jia Jia <physicalmtea@gmail.com>
    vhost: invalidate vring access on IOTLB transitions

Jia Jia <physicalmtea@gmail.com>
    vduse: validate virtqueue alignment

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

Alexander Graf <graf@amazon.com>
    virtio_ring: fix stale descriptor flags after a failed packed add

Sascha Bischoff <Sascha.Bischoff@arm.com>
    irqchip/gic-v5: Preserve ICC_CR0_EL1 state

hpp.iscas <hppiscas@163.com>
    ASoC: mt6351: Publish the OF module alias

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    regulator: pf1550: fix which regulator is notified

Florian Westphal <fw@strlen.de>
    netfilter: ip6_tables: set F_PROTO when proto value is nonzero

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: cope with concurrent instance destruction

Filipe Manana <fdmanana@suse.com>
    btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()

hpp.iscas <hppiscas@163.com>
    ASoC: Intel: SST: Publish the PCI module aliases

hpp.iscas <hppiscas@163.com>
    ASoC: bcm: bcm63xx: Publish the OF module aliases

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht4x) Fix return value from heater_enable_store()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht4x) Add missing locks

hanzhijian <hanzhijian1991@gmail.com>
    hwmon: (yogafan) fix non-kernel-doc comment

Antonin Godard <antonin.godard@bootlin.com>
    Documentation: hwmon: replace full-width colon by a standard ASCII colon

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Decouple in0 and curr1 alarms

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Replace masks with enum in alert functions

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Parameterize ina2xx_data in ina226_alert_read()

Jared Kangas <jkangas@redhat.com>
    hwmon: (ina2xx) Acquire hwmon_lock in shunt_resistor_show()

Guenter Roeck <linux@roeck-us.net>
    hwmon: Fix potential UAF in pec_store

Guenter Roeck <linux@roeck-us.net>
    Documentation/hwmon: Document hwmon_notify_event()

Geert Uytterhoeven <geert+renesas@glider.be>
    hwmon: (ltc4282) Make sure clk_init_data is fully initialized

Hemanth Selam <hemanth.selam@gmail.com>
    iommu/amd: Fix ineffective error check in nested domain allocation

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix premature break in init_iommu_one() again

Karl Mehltretter <kmehltretter@gmail.com>
    iommu/amd: Do not reallocate GA log buffers on resume

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    iommu/riscv: Avoid waiting on failed command enqueue

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    iommu/riscv: Serialize command queue publishing

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    iommu/riscv: Add command queue lock

Chengyu Zhu <hudsonzhu@tencent.com>
    erofs: delimit inode_share cache key components

Edward Adam Davis <eadavis@sina.com>
    ALSA: caiaq: Decoupling ep1_in_urb in caiaq dev

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject non-scalar bpf_loop iteration counts

Vineeth Karumanchi <vineeth.karumanchi@amd.com>
    net: macb: fix NULL pointer dereference on unbind with fixed-link

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
    net/mlx5e: Fix reporting support for all RS FEC variants

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix setting RS FEC after remapping

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix missing FEC mode mapping for RS_544_514_INTERLEAVED_QUAD

Weiming Shi <bestswngs@gmail.com>
    net/sched: defer qdisc freeing after failed creation

Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
    powerpc/entry: Fix irq_soft_mask corruption on replayed interrupt exit

XingWang Xiang <v3rdant.xiang@gmail.com>
    net: mctp: i3c: serialize probe with bus removal

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/kexec_file: Use inclusive range checks for excluded memory

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/kexec_file: Use inclusive range checks in add_usable_mem()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: propagate mark_chain_precision() errors out of loop_flag_is_zero()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: mark a NULL call argument precise

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

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix comment in tracing_buffers_splice_read()

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Cap static ring buffer nr_pages

Vincent Donnefort <vdonnefort@google.com>
    tracing: Fix subbuf resize races with trace_pipe_raw readers

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Remove ring_buffer_per_cpu::mapped

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Preserve inner map identity in callback frames

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark NULL kptr stores precise

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    bpf: Cancel special fields when recycling rhtab elements

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Preserve special fields in recycled rhtab elements

Jiayuan Chen <jiayuan.chen@linux.dev>
    selftests/bpf: Fix flaky bpf_nf test when random NAT port is 0

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix to avoid creating trace instances with duplicate names

Ning Ding <dingning04@gmail.com>
    bpf: Reject untrusted allocated-object pointers

Ning Ding <dingning04@gmail.com>
    bpf: Keep refcount_acquire nullable for borrowed RCU kptrs

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Require MEM_PERCPU for percpu kptr stores

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    thermal: sysfs: switch to use scnprintf() to suppress truncation warning

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Mark the zero register precise for a register-form NULL check

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't predict JMP32 pointer vs zero comparisons

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't resurrect a scalar id dropped by collect_linked_regs()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't infer non-NULL from a pointer with an unbounded offset

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

Eduard Zingerman <eddyz87@gmail.com>
    bpf: don't rewrite bpf_fastcall patterns entered by a jump

Eduard Zingerman <eddyz87@gmail.com>
    bpf: zero extend the result of an arena 32-bit cmpxchg

Taylor Bates <tmbates12@gmail.com>
    mlxsw: spectrum_ptp: Fix napi_gro_receive() call from GC workqueue context

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix tx_spb_ring_full() checking same slot cnt times

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: clear txcb->last before writing each descriptor

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Refactor and fix init_config access

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
    nvmet: print namespace IDs as unsigned 32bit value

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme: print namespace IDs as unsigned 32bit value

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme: remove stale namespaces by NSID range during scan

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Add checking nr_subbufs to persistent ring buffer validation

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark syscall helpers as sleepable

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

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Reject key-less BTF for hash maps

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

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc: Do not restore KUAP in arch_exit_to_user_mode_prepare()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc: Don't drop _TIF_RESTOREALL on syscall restart

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

Nicolai Buchwitz <nb@tipi-net.de>
    net: macb: exclude software FCS from TX byte statistics

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: unify device pointer naming convention

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

Eduard Zingerman <eddyz87@gmail.com>
    bpf: backtracking shouldn't clear outer frame R1-R5 for callbacks

Eduard Zingerman <eddyz87@gmail.com>
    bpf: backtrack_insn(): Handle ld_{abs,ind} subprog exit edge

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

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    platform/x86: x86-android-tablets: hold device reference for secondary fwnode teardown

John Ogness <john.ogness@linutronix.de>
    printk/nbcon: Change nbcon_irq_work to IRQ_WORK_LAZY

Qingyu Zhang <usupergate@gmail.com>
    ALSA: ump: do not touch legacy_rmidi before it exists

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix sparc build with atomic work state

Sunil Goutham <sgoutham@marvell.com>
    octeontx2-af: Fix limiting SRIOV VF count logic

Eric Dumazet <edumazet@google.com>
    locking/lockdep: Invalidate stale class_cache entries for zapped classes

Leo Yan <leo.yan@arm.com>
    perf/core: Skip empty AUX records with only format flags

Mario Limonciello <mario.limonciello@amd.com>
    x86/itmt: Don't make ITMT enablement depend on debugfs

Shubhang Kaushik (Ampere) <sh@gentwo.org>
    sched/core: Skip rq->avg_idle update without a valid idle_stamp

Seiji Nishikawa <snishika@redhat.com>
    sched/rt,dl: Skip migrate-disabled tasks when picking a push candidate

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

Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
    accel/amdxdna: refuse to flush an imported BO

HyeongJun An <sammiee5311@gmail.com>
    ALSA: dummy: Report a change when one capture switch channel moves

Lu Yao <yaolu@kylinos.cn>
    drm/xe/oa: Remove sysfs entry on idr_alloc failure in xe_oa_add_config_ioctl()

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Fix probe deadlock waiting for SoundWire enumeration

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Request IRQ in cs35l56_common_probe()

Keith Busch <kbusch@kernel.org>
    block: save page offset gaps in cloned bio

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

Eric Dumazet <edumazet@google.com>
    net: bonding: annotate lockless writes with WRITE_ONCE()

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
    ipv6: mcast: use jiffies_delta_to_clock_t() in igmp6_mc_seq_show()

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: use rcu_assign_pointer() for __rcu list updates

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: fix delay calculation in igmp6_join_group()

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: use copy-on-write RCU updates in ip6_mc_source()

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: fix RCU list diversion in ip6_mc_del1_src()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool/klp: Fix checksums for constant pool references

Yafang Shao <laoar.shao@gmail.com>
    klp-build: Fix wrong index in funcs cleanup error path

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_synctty: simplify tty disc_data access

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_async: simplify tty disc_data access

Eric Dumazet <edumazet@google.com>
    igmp: convert struct ip_sf_list to RCU

Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>
    rust: samples: add missing newlines in rust_print_main

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

Arvind Yadav <arvind.yadav@intel.com>
    drm/pagemap: Reset migration page count on eviction retry

Arvind Yadav <arvind.yadav@intel.com>
    drm/pagemap: Prevent double migration of device pages

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Skip missing DMIC GPIOs on AB8505

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Remove the nonfunctional sidetone apply control

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: codecs: ab8500: Use guard() for mutex locks

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Validate and program TDM slots correctly

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Correct digital interface format setup

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Repair the DAPM capture graph

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Reset the audio block before configuring it

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-laptop: Fix ACPI event handling

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

Wanwu Li <liwanwu@kylinos.cn>
    sched_ext: Fix timer pinning and return value in scx_central

Heiko Carstens <hca@linux.ibm.com>
    s390/pai: Reduce excessive debug feature size

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/diag324: Preserve -EBUSY return code

Vasily Gorbik <gor@linux.ibm.com>
    s390/ipl: Fix NULL deref in dump_reipl without re-IPL parm block

Vasily Gorbik <gor@linux.ibm.com>
    s390/ipl: Fix NULL deref in kdump without re-IPL parm block

Heiko Carstens <hca@linux.ibm.com>
    s390/time: Use jiffies instead of jiffies_64

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix listener task lifetime on netdev events

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: rate limit unmapped SID errors

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: propagate DACL parsing errors

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: safely drain sessions during logoff

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: cancel async requests when closing connection

Miklos Szeredi <mszeredi@redhat.com>
    ovl: return EINVAL instead of EIO in case of mismatched user_ns

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/cdclk: Fix dg2_power_well_count() return type

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/i915/dp_mst: Remove duplicate intel_pfit_compute_config() call

Kiran Kumar K <kirankumark@marvell.com>
    octeontx2-af: fix CN20K default MCAM rule removal on port cleanup

Randy Dunlap <rdunlap@infradead.org>
    dma-buf: fix some kernel-doc warnings

Yilin Zhang <yilinzhang@moonshot.ai>
    ALSA: pcm: Serialize PCM mmap with buffer reallocation to fix page UAF

David Howells <dhowells@redhat.com>
    cachefiles: Fix potential UAF/KASAN warning

David Howells <dhowells@redhat.com>
    netfs: Fix read progress reporting

David Howells <dhowells@redhat.com>
    netfs: Mark folios with COPY_TO_CACHE whilst issuing subreqs

David Howells <dhowells@redhat.com>
    netfs: Fix readahead synchronisation issues by loading all folios upfront

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
    smb/client: invalidate fscache for fallocate range operations

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix stale page cache in insert/collapse range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix integer truncation in collapse range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix data corruption in emulated insert range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: mark file sparse before emulating insert range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for zero range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for insert range

sangram kumar yerra <sangram.k.y@intel.com>
    scsi: ufs: ufs-pci: Add MCQ support for Intel UFS 4.0 controllers

sangram kumar yerra <sangram.k.y@intel.com>
    scsi: ufs: ufs-pci: Add support for Intel UFS 4.0 HS-Gear5

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

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix dma mapping leak in stmmac_tso_xmit()

Eric Dumazet <edumazet@google.com>
    tcp: use GFP_ATOMIC in tcp_send_active_reset()

Eric Dumazet <edumazet@google.com>
    net: icmp: avoid invalid transport header access in icmp_send tracepoint

Eduard Zingerman <eddyz87@gmail.com>
    bpf: don't downgrade half-dead scalar zero spills to STACK_ZERO

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: leave HasEA flag untouched on setxattr failure

Eduard Zingerman <eddyz87@gmail.com>
    bpf: check_cond_jmp_op(): properly infer if register is null

Dennis Tighe <dennis.tighe@gmail.com>
    ntfs: reject invalid sectors_per_cluster in the boot sector

Dennis Tighe <dennis.tighe@gmail.com>
    ntfs: bound $AttrDef table walk to the loaded table size

Wentao Guan <guanwentao@uniontech.com>
    ntfs: treat any nonzero dio zero-range return as an error

Dennis Tighe <dennis.tighe@gmail.com>
    ntfs: do not mark the volume clean in sync_fs when errors were recorded

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: skip free cluster decrement when rollback fails

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: only count successfully cleared runs when freeing clusters

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: fix kmap_local leak in write_mft_record_nolock() error paths

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: return real error from ntfs_non_resident_attr_record_add()

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: preserve error code in ntfs_resident_attr_record_add()

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: return -ERANGE for undersized xattr buffer

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: propagate reparse index insertion failure

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: return DT_UNKNOWN on inode lookup failure in readdir

Slawomir Stepien <sst@poczta.fm>
    drm/cirrus-qemu: Validate BAR0 size during probe

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: do not treat unreadable directory blocks as empty

Tomeu Vizoso <tomeu@tomeuvizoso.net>
    accel: ethosu: Don't read the U65 rounding mode as a storage mode

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/cpuset: Preserve boot-isolated CPUs on partition release

Guopeng Zhang <zhangguopeng@kylinos.cn>
    selftests/cgroup: Drop invalid boot isolation comparison

Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
    accel/amdxdna: put the chained BO when its mapping fails

Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
    accel/amdxdna: reject a command chain that carries no commands

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Remove __counted_by from struct amdxdna_cmd_chain

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    printk: Don't WARN on kthread_run failure.

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: validate GUD_ROTATION_0 is present in supported rotations

Tejun Heo <tj@kernel.org>
    sched_ext: Fix spurious aborts in scx_bpf_dsq_move() on ownership change races

Hui Su <sh_def@163.com>
    bpf: Fix percpu map update indexing with sparse CPU IDs

Hui Su <sh_def@163.com>
    bpf: Fix BPF_F_CPU validation for sparse CPU IDs

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix REG INVARIANTS VIOLATION on speculative pointer arithmetic

Hongfu Li <lihongfu@kylinos.cn>
    selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter

Hemanth Selam <hemanth.selam@gmail.com>
    selftests/cgroup: set the test plan after the setup checks

Liang Luo <luoliang@kylinos.cn>
    sched_ext: Fix nonexistent field in sched-ext.rst example

Xixin Liu <liuxixin@kylinos.cn>
    nvmet-rdma: fix queue leak when connect backlog is exceeded

Kanchan Joshi <joshi.k@samsung.com>
    nvme: fix racy access to FDP placement id array

Kanchan Joshi <joshi.k@samsung.com>
    nvme: set ns->head in nvme_alloc_ns_head

Nilay Shroff <nilay@linux.ibm.com>
    nvme: add context annotations for nvme_subsystem::lock

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
    EDAC/igen6: Fix Raptor Lake-P logged error address

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel address decode for non-hash mode

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel selection hash

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix interleave boundary condition

Yazen Ghannam <yazen.ghannam@amd.com>
    RAS/AMD/ATL, EDAC/amd64: Only load ATL when needed

Vlatko Kosturjak <kost@linux.hr>
    ppp_async: drop the errored frame instead of resetting its headroom

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Validate pattern input before stopping the sequence

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: skip unknown CLC firmware records

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: validate CLC firmware records

Wentao Guan <guanwentao@uniontech.com>
    iommu/arm-smmu-v3: Disable implementations during devm teardown


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-erofs           |   2 +-
 Documentation/admin-guide/kernel-parameters.txt    |  37 --
 Documentation/hwmon/gpd-fan.rst                    |   2 +-
 Documentation/hwmon/hwmon-kernel-api.rst           |  15 +
 Documentation/netlink/specs/rt-link.yaml           |   2 +
 Documentation/scheduler/sched-ext.rst              |   2 +-
 MAINTAINERS                                        |   1 +
 Makefile                                           |   4 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |   6 +-
 arch/arm64/kernel/machine_kexec.c                  |   3 +-
 arch/arm64/tools/sysreg                            |   4 +-
 arch/powerpc/include/asm/entry-common.h            |  14 +-
 arch/powerpc/kernel/eeh_driver.c                   |   2 -
 arch/powerpc/kernel/interrupt.c                    |   2 +-
 arch/powerpc/kexec/file_load_64.c                  |   4 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   6 +-
 arch/powerpc/platforms/ps3/repository.c            |   5 +-
 arch/riscv/kernel/process.c                        |   4 +-
 arch/riscv/kernel/sys_hwprobe.c                    |   5 +-
 arch/s390/boot/ipl_parm.c                          |  26 +-
 arch/s390/boot/physmem_info.c                      |   2 +-
 arch/s390/crypto/aes_s390.c                        |  87 ++-
 arch/s390/crypto/paes_s390.c                       |  19 +-
 arch/s390/crypto/phmac_s390.c                      |  36 +-
 arch/s390/include/asm/pai.h                        |   1 -
 arch/s390/kernel/debug.c                           |   6 +-
 arch/s390/kernel/diag/diag324.c                    |   3 +-
 arch/s390/kernel/ipl.c                             |  12 +-
 arch/s390/kernel/perf_pai.c                        | 198 ++++--
 arch/s390/kernel/vtime.c                           |   6 +-
 arch/x86/crypto/aria-aesni-avx2-asm_64.S           |   6 +
 arch/x86/crypto/aria-gfni-avx512-asm_64.S          |   3 +
 arch/x86/events/intel/core.c                       |  33 +-
 arch/x86/events/intel/ds.c                         |  18 +-
 arch/x86/events/perf_event.h                       |   3 +
 arch/x86/include/asm/pgtable.h                     |   2 +-
 arch/x86/kernel/alternative.c                      | 111 ++--
 arch/x86/kernel/amd_node.c                         |  25 +-
 arch/x86/kernel/cpu/mce/amd.c                      |   2 +-
 arch/x86/kernel/itmt.c                             |   8 +-
 arch/x86/mm/pat/set_memory.c                       | 148 +++--
 block/bio.c                                        |   9 +
 drivers/accel/amdxdna/aie2_message.c               |   2 +-
 drivers/accel/amdxdna/amdxdna_ctx.c                |   4 +-
 drivers/accel/amdxdna/amdxdna_ctx.h                |   2 +-
 drivers/accel/amdxdna/amdxdna_gem.c                |  13 +-
 drivers/accel/ethosu/ethosu_device.h               |   1 +
 drivers/accel/ethosu/ethosu_drv.c                  |   3 +-
 drivers/accel/ethosu/ethosu_gem.c                  |  11 +-
 drivers/accel/ethosu/ethosu_job.c                  |  16 +-
 drivers/accel/ivpu/ivpu_fw_log.c                   |  87 +--
 drivers/accel/ivpu/ivpu_gem.h                      |  14 +-
 drivers/accel/ivpu/ivpu_ipc.c                      |   7 +-
 drivers/accel/qaic/qaic_control.c                  |  46 +-
 drivers/block/sunvdc.c                             |  17 +
 drivers/block/ublk_drv.c                           |   1 +
 drivers/bluetooth/btintel.c                        |  39 +-
 drivers/bluetooth/btintel_pcie.c                   |   9 +-
 drivers/bluetooth/btmtk.c                          |  11 +-
 drivers/bluetooth/btmtk.h                          |   1 +
 drivers/bluetooth/btqcomsmd.c                      |   6 +-
 drivers/bluetooth/btrtl.c                          |   5 +-
 drivers/bluetooth/btusb.c                          | 105 +++-
 drivers/bluetooth/hci_mrvl.c                       |   3 +-
 drivers/char/virtio_console.c                      |  21 +-
 drivers/clk/ux500/clk-prcmu.c                      |  20 +-
 drivers/clk/ux500/u8500_of_clk.c                   |   2 +-
 drivers/cpufreq/cpufreq.c                          |   6 +-
 drivers/cpuidle/cpuidle-ux500.c                    |   6 +-
 drivers/dibs/dibs_main.c                           |  10 +-
 drivers/edac/altera_edac.c                         |  10 +-
 drivers/edac/amd64_edac.c                          |   2 +
 drivers/edac/edac_device_sysfs.c                   |  11 +-
 drivers/edac/igen6_edac.c                          |  66 +-
 drivers/gpu/drm/adp/Kconfig                        |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  20 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  14 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  20 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   3 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |   6 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   2 -
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   4 +-
 drivers/gpu/drm/bridge/tc358768.c                  |  15 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |   6 +-
 drivers/gpu/drm/drm_exec.c                         |  13 +
 drivers/gpu/drm/drm_pagemap.c                      | 130 +++-
 drivers/gpu/drm/drm_panic_qr.rs                    |   4 +-
 drivers/gpu/drm/gud/gud_drv.c                      |   2 +
 drivers/gpu/drm/i915/display/intel_cdclk.c         |  10 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   2 +
 drivers/gpu/drm/i915/display/intel_dp.c            |  44 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   4 -
 drivers/gpu/drm/i915/i915_query.c                  |   4 +-
 drivers/gpu/drm/logicvc/Kconfig                    |   1 -
 drivers/gpu/drm/rockchip/Kconfig                   |   3 +
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    |   7 +-
 drivers/gpu/drm/scheduler/tests/mock_scheduler.c   |  11 +
 drivers/gpu/drm/tiny/cirrus-qemu.c                 |   3 +
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |  20 +
 drivers/gpu/drm/virtio/virtgpu_object.c            |   2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   6 +-
 drivers/gpu/drm/xe/Makefile                        |   4 +-
 drivers/gpu/drm/xe/instructions/xe_gpu_commands.h  |   1 +
 drivers/gpu/drm/xe/regs/xe_i2c_regs.h              |   2 +
 drivers/gpu/drm/xe/xe_amc.c                        | 197 ++++++
 drivers/gpu/drm/xe/xe_amc.h                        |  25 +
 drivers/gpu/drm/xe/xe_i2c.c                        | 128 ++--
 drivers/gpu/drm/xe/xe_i2c.h                        |  13 +-
 drivers/gpu/drm/xe/xe_oa.c                         |   6 +-
 drivers/gpu/drm/xe/xe_pagefault.c                  |  10 +
 drivers/gpu/drm/xe/xe_pagefault_types.h            |   3 +
 drivers/gpu/drm/xe/xe_ring_ops.c                   |  11 +
 drivers/hwmon/applesmc.c                           |   7 +-
 drivers/hwmon/aspeed-pwm-tacho.c                   |   4 +-
 drivers/hwmon/asus_rog_ryujin.c                    | 105 +++-
 drivers/hwmon/chipcap2.c                           |   9 +-
 drivers/hwmon/corsair-cpro.c                       |  24 +-
 drivers/hwmon/gpio-fan.c                           |  13 +-
 drivers/hwmon/hwmon.c                              |  21 +-
 drivers/hwmon/ina2xx.c                             | 163 ++++-
 drivers/hwmon/ltc4282.c                            |   2 +-
 drivers/hwmon/mcp9982.c                            |   2 +
 drivers/hwmon/nct6694-hwmon.c                      |  35 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   4 +-
 drivers/hwmon/sht4x.c                              |   8 +-
 drivers/hwmon/yogafan.c                            |   2 +-
 drivers/i2c/busses/i2c-designware-common.c         |   2 +
 drivers/i2c/busses/i2c-designware-core.h           |  85 +--
 drivers/i2c/busses/i2c-designware-master.c         |   2 +
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +
 drivers/iommu/amd/init.c                           |  22 +-
 drivers/iommu/amd/nested.c                         |   7 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   4 +-
 drivers/iommu/riscv/iommu.c                        | 121 ++--
 drivers/iommu/riscv/iommu.h                        |   2 +
 drivers/iommu/s390-iommu.c                         |   2 +
 drivers/irqchip/irq-gic-v5.c                       |   6 +-
 drivers/leds/leds-st1202.c                         |  10 +-
 drivers/media/i2c/mt9p031.c                        |   6 +-
 drivers/media/pci/intel/ipu-bridge.c               |  24 +
 .../vcodec/decoder/vdec/vdec_av1_req_lat_if.c      |   5 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |   7 +-
 drivers/media/platform/qcom/iris/iris_resources.c  |  15 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   7 +-
 drivers/media/platform/renesas/rcar-csi2.c         |   6 +-
 .../platform/rockchip/rkvdec/rkvdec-hevc-common.c  |  14 +-
 .../media/platform/rockchip/rkvdec/rkvdec-hevc.c   |   7 +-
 .../platform/rockchip/rkvdec/rkvdec-vdpu381-hevc.c |   2 +
 .../media/platform/samsung/s3c-camif/camif-core.c  |   7 +-
 .../platform/verisilicon/hantro_g2_hevc_dec.c      |   6 +-
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c       |  57 +-
 drivers/media/usb/as102/as102_usb_drv.c            |  75 +--
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  12 +-
 drivers/media/usb/gspca/jl2005bcd.c                |   7 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  32 +
 drivers/media/v4l2-core/v4l2-h264.c                |   3 +-
 drivers/mfd/ab8500-core.c                          |   2 +-
 drivers/mfd/db8500-prcmu.c                         |   6 +-
 drivers/misc/amd-sbi/rmi-core.c                    |   4 +
 drivers/net/bonding/bond_alb.c                     |  34 +-
 drivers/net/bonding/bond_main.c                    |  18 +-
 drivers/net/bonding/bond_options.c                 |   4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |   2 +
 drivers/net/dsa/lantiq/lantiq_gswip.h              |   2 +-
 drivers/net/dsa/mt7530-mmio.c                      |   1 +
 drivers/net/dsa/mt7530.c                           |  70 ++-
 drivers/net/dsa/mt7530.h                           |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  16 +-
 drivers/net/ethernet/airoha/airoha_eth.h           |   2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   2 +
 drivers/net/ethernet/amd/pds_core/fw.c             |  10 +-
 drivers/net/ethernet/amd/pds_core/main.c           |  10 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |   3 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  99 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_gso.c      |  21 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_gso.h      |   6 +-
 drivers/net/ethernet/cadence/macb.h                |  23 +-
 drivers/net/ethernet/cadence/macb_main.c           | 677 ++++++++++----------
 drivers/net/ethernet/cadence/macb_pci.c            |  46 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |  23 +-
 drivers/net/ethernet/cortina/gemini.c              |  77 ++-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c  |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |  64 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  34 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |  10 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  33 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  10 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   5 +-
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |  60 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  18 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  52 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  51 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |  37 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   1 +
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  19 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |  34 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |   8 +-
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |   1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  24 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  19 +-
 drivers/net/ethernet/oa_tc6.c                      | 436 ++++++++-----
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  93 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   1 -
 drivers/net/gtp.c                                  |   5 +
 drivers/net/ieee802154/cc2520.c                    |   5 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |  10 +-
 drivers/net/mctp/mctp-i3c.c                        |   9 +-
 drivers/net/net_failover.c                         |   2 +-
 drivers/net/phy/dp83867.c                          |   3 +
 drivers/net/phy/dp83td510.c                        |   3 +
 drivers/net/phy/mediatek/mtk-ge.c                  |  29 +
 drivers/net/phy/phylink.c                          |   2 +
 drivers/net/ppp/ppp_async.c                        |  89 +--
 drivers/net/ppp/ppp_synctty.c                      |  97 +--
 drivers/net/usb/cx82310_eth.c                      |   1 +
 drivers/net/usb/hso.c                              |   2 +-
 drivers/net/usb/pegasus.c                          |  54 +-
 drivers/net/usb/pegasus.h                          |   3 -
 drivers/net/vxlan/vxlan_core.c                     |  13 +-
 drivers/net/vxlan/vxlan_mdb.c                      |   8 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  12 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  33 +-
 drivers/nvme/host/core.c                           |  77 ++-
 drivers/nvme/host/nvme.h                           |  16 +-
 drivers/nvme/host/rdma.c                           |  18 +-
 drivers/nvme/host/sysfs.c                          |   2 +-
 drivers/nvme/host/tcp.c                            |   5 +
 drivers/nvme/host/zns.c                            |   4 +-
 drivers/nvme/target/configfs.c                     |   4 +-
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/pr.c                           |   2 +-
 drivers/nvme/target/rdma.c                         |  15 +-
 drivers/opp/of.c                                   |   2 +-
 drivers/perf/riscv_pmu_legacy.c                    |   5 +-
 drivers/perf/riscv_pmu_sbi.c                       |  98 ++-
 drivers/platform/x86/asus-laptop.c                 |   4 +-
 drivers/platform/x86/hp/hp-wmi.c                   | 129 ++--
 drivers/platform/x86/x86-android-tablets/core.c    |  12 +-
 drivers/ras/amd/atl/core.c                         |   1 -
 drivers/regulator/db8500-prcmu.c                   |  12 +-
 drivers/regulator/pf1550-regulator.c               |  82 ++-
 drivers/s390/net/ism_drv.c                         |   4 +-
 drivers/s390/net/qeth_l2.h                         |   3 +-
 drivers/s390/net/qeth_l2_main.c                    |  26 +-
 drivers/s390/net/qeth_l2_sys.c                     |   7 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |   8 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   5 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  49 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +
 drivers/scsi/qla2xxx/qla_fw.h                      |   4 +
 drivers/scsi/qla2xxx/qla_init.c                    |  14 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |  23 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  33 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |  49 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  10 +
 drivers/scsi/qla2xxx/qla_os.c                      |  15 +
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/thermal/db8500_thermal.c                   |  10 +-
 drivers/thermal/thermal_sysfs.c                    |  12 +-
 drivers/ufs/host/ufshcd-pci.c                      |  59 ++
 drivers/usb/atm/xusbatm.c                          |   6 +-
 drivers/usb/class/usbtmc.c                         |   2 -
 drivers/usb/serial/spcp8x5.c                       |   6 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   3 +-
 drivers/vdpa/solidrun/snet_main.c                  |   6 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   7 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  10 +-
 drivers/vhost/net.c                                |   2 +
 drivers/vhost/vdpa.c                               |  88 ++-
 drivers/vhost/vhost.c                              |  57 +-
 drivers/vhost/vhost.h                              |   1 +
 drivers/vhost/vsock.c                              |   2 +
 drivers/video/fbdev/vfb.c                          |  11 +-
 drivers/virtio/virtio.c                            |   2 +-
 drivers/virtio/virtio_input.c                      |   9 +-
 drivers/virtio/virtio_mmio.c                       |  16 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/virtio/virtio_ring.c                       |  38 +-
 drivers/watchdog/db8500_wdt.c                      |  22 +-
 drivers/watchdog/msc313e_wdt.c                     |  74 ++-
 drivers/watchdog/sunxi_wdt.c                       |  45 +-
 drivers/watchdog/watchdog_hrtimer_pretimeout.c     |   1 +
 fs/afs/addr_list.c                                 |   5 +-
 fs/afs/dir_edit.c                                  |   9 +-
 fs/afs/dir_search.c                                |  11 +-
 fs/afs/fs_probe.c                                  |   1 +
 fs/afs/internal.h                                  |   8 +
 fs/afs/server.c                                    |   1 -
 fs/autofs/inode.c                                  |   4 +-
 fs/btrfs/inode.c                                   |   3 +
 fs/btrfs/raid-stripe-tree.c                        |  25 +-
 fs/btrfs/raid-stripe-tree.h                        |   1 +
 fs/btrfs/scrub.c                                   |  24 +-
 fs/btrfs/send.c                                    |   2 +-
 fs/btrfs/transaction.c                             |  13 +-
 fs/btrfs/tree-log.c                                |  16 +
 fs/btrfs/volumes.c                                 |   4 +
 fs/btrfs/zoned.c                                   |  11 +-
 fs/btrfs/zstd.c                                    |  11 +-
 fs/cachefiles/xattr.c                              |  16 +-
 fs/configfs/dir.c                                  |   9 +
 fs/configfs/symlink.c                              |  24 +-
 fs/erofs/data.c                                    |   2 +-
 fs/erofs/decompressor.c                            |  55 +-
 fs/erofs/decompressor_lzma.c                       |  18 +-
 fs/erofs/internal.h                                |   6 +-
 fs/erofs/sysfs.c                                   |   2 +
 fs/erofs/xattr.c                                   |   9 +-
 fs/erofs/zdata.c                                   |  18 +-
 fs/exec.c                                          |  22 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/gc.c                                       |  52 +-
 fs/f2fs/segment.c                                  |   4 +-
 fs/netfs/buffered_read.c                           | 164 +++--
 fs/netfs/direct_write.c                            |  31 +-
 fs/netfs/internal.h                                |   3 +
 fs/netfs/misc.c                                    |  19 +
 fs/netfs/objects.c                                 |  32 +-
 fs/netfs/read_collect.c                            | 128 ++--
 fs/netfs/read_pgpriv2.c                            |  15 +-
 fs/netfs/read_retry.c                              |  13 +-
 fs/netfs/read_single.c                             |   2 +
 fs/netfs/rolling_buffer.c                          |  79 ++-
 fs/netfs/write_issue.c                             |   2 +
 fs/ntfs/attrib.c                                   |  10 +-
 fs/ntfs/ea.c                                       |  14 +-
 fs/ntfs/lcnalloc.c                                 |   9 +-
 fs/ntfs/mft.c                                      |   4 +-
 fs/ntfs/reparse.c                                  |   7 +-
 fs/ntfs/super.c                                    |  11 +-
 fs/overlayfs/super.c                               |   2 +-
 fs/smb/client/cifsacl.c                            |  95 ++-
 fs/smb/client/cifssmb.c                            |  26 +-
 fs/smb/client/file.c                               |  22 +-
 fs/smb/client/inode.c                              |  17 +-
 fs/smb/client/misc.c                               |  24 +-
 fs/smb/client/readdir.c                            |  17 +-
 fs/smb/client/reparse.c                            |  33 +-
 fs/smb/client/smb2ops.c                            | 188 +++++-
 fs/smb/client/trace.h                              |   1 +
 fs/smb/client/transport.c                          |  11 +-
 fs/smb/server/connection.c                         |  25 +
 fs/smb/server/ksmbd_work.h                         |   2 +-
 fs/smb/server/mgmt/user_session.c                  |  13 +-
 fs/smb/server/mgmt/user_session.h                  |   1 +
 fs/smb/server/smb2pdu.c                            |  47 +-
 fs/smb/server/smbacl.c                             |  67 +-
 fs/smb/server/transport_tcp.c                      |  36 +-
 fs/smb/server/vfs_cache.c                          |  17 +-
 fs/smb/server/vfs_cache.h                          |   1 +
 fs/super.c                                         |   9 +-
 fs/ufs/cylinder.c                                  |  10 +
 fs/ufs/dir.c                                       |   2 +-
 fs/ufs/super.c                                     |  17 +-
 fs/xfs/libxfs/xfs_btree_mem.c                      |   2 +
 fs/xfs/libxfs/xfs_btree_staging.c                  |   4 +-
 fs/xfs/libxfs/xfs_da_btree.c                       |   2 +-
 fs/xfs/libxfs/xfs_da_btree.h                       |   2 +
 fs/xfs/libxfs/xfs_defer.c                          |   2 +-
 fs/xfs/libxfs/xfs_exchmaps.c                       |  10 +
 fs/xfs/libxfs/xfs_parent.c                         |  12 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c               |   7 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c                   |   6 +-
 fs/xfs/scrub/agheader.c                            |   7 +
 fs/xfs/scrub/agheader_repair.c                     |  39 +-
 fs/xfs/scrub/alloc_repair.c                        |  18 +-
 fs/xfs/scrub/attr_repair.c                         |   2 +-
 fs/xfs/scrub/bmap.c                                |   2 +-
 fs/xfs/scrub/dir_repair.c                          |  31 +-
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
 fs/xfs/scrub/stats.c                               |  61 +-
 fs/xfs/scrub/stats.h                               |   4 +-
 fs/xfs/scrub/symlink_repair.c                      |   2 +-
 fs/xfs/scrub/tempfile.c                            |  29 +-
 fs/xfs/scrub/trace.h                               |  35 +-
 fs/xfs/xfs_buf.c                                   |   2 +-
 fs/xfs/xfs_exchmaps_item.c                         |  19 +-
 fs/xfs/xfs_exchrange.c                             |  12 +-
 fs/xfs/xfs_healthmon.c                             |  30 +-
 fs/xfs/xfs_verify_media.c                          |  24 +-
 include/drm/drm_pagemap.h                          |   8 +-
 include/linux/bpf.h                                |   3 +-
 include/linux/bpf_verifier.h                       |  21 +-
 include/linux/designware_i2c.h                     | 107 ++++
 include/linux/dma-fence-array.h                    |   1 -
 include/linux/dma-fence-chain.h                    |   9 +-
 include/linux/igmp.h                               |   7 +-
 include/linux/mfd/db8500-prcmu.h                   | 252 +++++++-
 include/linux/mfd/dbx500-prcmu.h                   | 575 -----------------
 include/linux/mmap_lock.h                          |   2 +
 include/linux/netfs.h                              |   5 +-
 include/linux/oa_tc6.h                             |  50 ++
 include/linux/perf/riscv_pmu.h                     |   2 +-
 include/linux/rbtree_augmented.h                   |  35 +-
 include/linux/ring_buffer.h                        |  24 +-
 include/linux/rolling_buffer.h                     |   6 +-
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |   5 +-
 include/linux/skbuff.h                             |   5 +
 include/media/v4l2-hevc.h                          |  41 ++
 include/net/cfg802154.h                            |   1 +
 include/net/if_inet6.h                             |   2 -
 include/net/ip.h                                   |   3 +-
 include/net/ip6_route.h                            |   2 +
 include/net/sch_generic.h                          |   2 +-
 include/net/tcp.h                                  |   3 +-
 include/trace/events/cachefiles.h                  |  19 +-
 include/trace/events/icmp.h                        |  13 +-
 include/trace/events/netfs.h                       |  30 +-
 include/uapi/drm/amdgpu_drm.h                      |   2 +-
 init/main.c                                        |  27 +-
 io_uring/net.c                                     |  51 +-
 io_uring/rw.c                                      |  29 +-
 kernel/bpf/arraymap.c                              |   5 +-
 kernel/bpf/backtrack.c                             |  64 +-
 kernel/bpf/bpf_iter.c                              |   2 +-
 kernel/bpf/btf.c                                   |  27 +-
 kernel/bpf/cfg.c                                   |   3 +
 kernel/bpf/fixups.c                                |   7 +-
 kernel/bpf/hashtab.c                               |  29 +-
 kernel/bpf/local_storage.c                         |   5 +-
 kernel/bpf/stackmap.c                              |   2 +
 kernel/bpf/states.c                                |  11 +-
 kernel/bpf/syscall.c                               |   2 +
 kernel/bpf/verifier.c                              | 263 ++++++--
 kernel/cgroup/cpuset.c                             |  39 +-
 kernel/events/core.c                               |   4 +-
 kernel/events/ring_buffer.c                        |   9 +-
 kernel/exit.c                                      |   9 +-
 kernel/fork.c                                      |   7 +-
 kernel/locking/lockdep.c                           |  50 +-
 kernel/nstree.c                                    |  10 +-
 kernel/printk/nbcon.c                              |   4 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/reboot.c                                    |  19 +-
 kernel/sched/core.c                                |  19 +-
 kernel/sched/deadline.c                            |   4 +-
 kernel/sched/ext/ext.c                             |  21 +-
 kernel/sched/fair.c                                |  18 +-
 kernel/sched/rt.c                                  |   4 +-
 kernel/signal.c                                    |  12 +
 kernel/time/clockevents.c                          |  35 +-
 kernel/time/hrtimer.c                              |  15 +-
 kernel/time/tick-broadcast.c                       |  36 +-
 kernel/time/tick-internal.h                        |   2 +
 kernel/trace/ftrace.c                              |   2 +-
 kernel/trace/ring_buffer.c                         | 226 ++++---
 kernel/trace/ring_buffer_benchmark.c               |   6 +-
 kernel/trace/trace.c                               | 152 +++--
 kernel/trace/trace.h                               |  11 +-
 kernel/trace/trace_events.c                        |   2 +
 kernel/trace/trace_events_hist.c                   |  86 +--
 kernel/trace/trace_events_trigger.c                |   4 +-
 kernel/trace/trace_events_user.c                   |  26 +-
 kernel/trace/trace_functions_graph.c               |   3 +
 kernel/trace/trace_probe.c                         |  48 +-
 kernel/trace/trace_probe.h                         |   2 +
 kernel/trace/trace_remote.c                        |   6 +-
 kernel/workqueue.c                                 |   3 +
 lib/iov_iter.c                                     |  18 +-
 mm/slub.c                                          |  22 +-
 net/bluetooth/hci_core.c                           |   4 +-
 net/bluetooth/hci_sysfs.c                          |  17 +-
 net/bluetooth/l2cap_core.c                         |  33 +-
 net/bluetooth/msft.c                               |   2 +-
 net/bridge/br_cfm.c                                |  11 +-
 net/bridge/br_device.c                             |   1 -
 net/bridge/br_input.c                              |  35 +-
 net/bridge/br_mrp.c                                |  13 +-
 net/bridge/br_multicast.c                          |   9 +-
 net/bridge/br_private.h                            |  26 +-
 net/core/dev.c                                     |  27 +-
 net/core/gro_cells.c                               |   2 +
 net/core/rtnetlink.c                               |   7 +-
 net/core/skbuff.c                                  |   7 +
 net/dsa/tag_brcm.c                                 |   1 +
 net/hsr/hsr_slave.c                                |  11 +-
 net/ieee802154/6lowpan/core.c                      |   2 +-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/igmp.c                                    | 210 ++++---
 net/ipv4/inet_fragment.c                           |   6 +
 net/ipv4/ip_output.c                               |   1 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/ipmr.c                                    |   3 +-
 net/ipv4/ipmr_base.c                               |   2 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/tcp.c                                     |  14 +-
 net/ipv4/tcp_offload.c                             |  22 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv4/tcp_timer.c                               |   6 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/exthdrs.c                                 |   4 +-
 net/ipv6/ip6_fib.c                                 |   4 +-
 net/ipv6/ip6_flowlabel.c                           |  19 +
 net/ipv6/ip6_gre.c                                 |   6 +-
 net/ipv6/ip6_output.c                              |   2 +
 net/ipv6/ip6mr.c                                   |   2 +-
 net/ipv6/mcast.c                                   | 148 +++--
 net/ipv6/netfilter/ip6_tables.c                    |   5 +
 net/ipv6/route.c                                   |   9 +-
 net/ipv6/tcpv6_offload.c                           |  15 +-
 net/mac802154/ieee802154_i.h                       |   8 +
 net/mac802154/iface.c                              |   6 +
 net/mac802154/main.c                               |   1 +
 net/mac802154/rx.c                                 | 120 +++-
 net/mac802154/scan.c                               |  10 +-
 net/mptcp/options.c                                |   8 +-
 net/mptcp/pm.c                                     |   2 +-
 net/mptcp/pm_kernel.c                              |   8 +
 net/mptcp/pm_userspace.c                           |  18 +-
 net/mptcp/protocol.c                               |  28 +-
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/subflow.c                                |   1 -
 net/mptcp/syncookies.c                             |   5 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  20 +-
 net/netfilter/nf_conntrack_netlink.c               |   2 +
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_log_syslog.c                      |   2 +-
 net/netfilter/nfnetlink_cttimeout.c                |   2 +-
 net/netfilter/nfnetlink_log.c                      |  15 +-
 net/netlink/genetlink.c                            |  21 +-
 net/openvswitch/flow.c                             |   4 +-
 net/openvswitch/flow_table.c                       |   4 +-
 net/packet/af_packet.c                             |   5 +-
 net/rds/connection.c                               |  89 ++-
 net/rds/ib_recv.c                                  |   9 +-
 net/rds/message.c                                  |   4 +-
 net/rds/send.c                                     |  14 +-
 net/rds/tcp.c                                      | 101 ++-
 net/rds/tcp_listen.c                               |   6 +-
 net/sched/act_api.c                                |  46 +-
 net/sched/cls_api.c                                |   2 +-
 net/sched/cls_route.c                              |  76 +--
 net/sched/cls_u32.c                                |  32 +-
 net/sched/sch_api.c                                |   2 +-
 net/sched/sch_drr.c                                |   3 +-
 net/sched/sch_dualpi2.c                            |  10 +-
 net/sched/sch_ets.c                                |  12 +-
 net/sched/sch_fq_pie.c                             |   3 +-
 net/sched/sch_generic.c                            |  24 +-
 net/sched/sch_hhf.c                                |   8 +-
 net/sched/sch_pie.c                                |   2 +-
 net/sched/sch_sfq.c                                |   7 +-
 net/sctp/sm_make_chunk.c                           |  14 +-
 net/sctp/sm_sideeffect.c                           |  11 +-
 net/tipc/link.c                                    |   6 +-
 net/tipc/name_table.c                              |  32 +-
 net/unix/af_unix.c                                 |  12 +-
 rust/bindings/lib.rs                               |   4 +-
 rust/kernel/num.rs                                 |   9 +-
 rust/pin-init/src/lib.rs                           |   8 +-
 rust/uapi/lib.rs                                   |   4 +-
 samples/rust/rust_print_main.rs                    |   8 +-
 scripts/livepatch/init.c                           |   2 +-
 scripts/mksysmap                                   |   4 +-
 scripts/sorttable.c                                |   2 +-
 security/landlock/fs.c                             |  18 +-
 sound/core/pcm_native.c                            |  35 +-
 sound/core/ump.c                                   |   4 +
 sound/drivers/dummy.c                              |   2 +-
 sound/hda/common/codec.c                           |   4 +-
 sound/hda/core/device.c                            |   5 +-
 sound/pci/ctxfi/cthw20k2.c                         |   1 +
 sound/soc/amd/acp-da7219-max98357a.c               |  23 +
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +-
 sound/soc/amd/yc/acp6x-pdm-dma.c                   |   2 +
 sound/soc/bcm/bcm63xx-i2s-whistler.c               |   1 +
 sound/soc/codecs/ab8500-codec.c                    | 690 +++++++++------------
 sound/soc/codecs/cs35l56-i2c.c                     |  10 +-
 sound/soc/codecs/cs35l56-sdw.c                     |   6 +-
 sound/soc/codecs/cs35l56-spi.c                     |  10 +-
 sound/soc/codecs/cs35l56.c                         | 124 +++-
 sound/soc/codecs/cs35l56.h                         |   4 +-
 sound/soc/codecs/mt6351.c                          |   1 +
 sound/soc/fsl/fsl_micfil.c                         |  21 +-
 sound/soc/intel/atom/sst/sst_pci.c                 |   1 +
 sound/soc/intel/avs/core.c                         |  29 +-
 sound/soc/intel/avs/debugfs.c                      |  12 +-
 sound/soc/intel/avs/path.c                         |  11 +-
 sound/soc/intel/avs/pcm.c                          |  34 +-
 sound/soc/intel/avs/topology.c                     |  49 +-
 sound/soc/intel/avs/topology.h                     |   5 +-
 sound/soc/sprd/sprd-pcm-compress.c                 |  15 +-
 sound/soc/sti/uniperif_reader.c                    |   4 +-
 sound/soc/ux500/ux500_msp_dai.c                    | 189 +++---
 sound/soc/ux500/ux500_msp_dai.h                    |  14 +-
 sound/soc/ux500/ux500_msp_i2s.c                    | 260 +++++---
 sound/soc/ux500/ux500_msp_i2s.h                    |  12 +-
 sound/usb/caiaq/audio.c                            |  10 +-
 sound/usb/caiaq/device.c                           |  36 +-
 sound/usb/caiaq/device.h                           |   4 +-
 sound/usb/caiaq/midi.c                             |   6 +-
 sound/usb/usx2y/us122l.c                           |   7 +-
 sound/usb/usx2y/usbusx2y.c                         |  10 +-
 sound/usb/usx2y/usbusx2y.h                         |   4 +-
 tools/bootconfig/main.c                            |  13 +-
 tools/objtool/klp-checksum.c                       |  21 +
 tools/perf/util/powerpc-vpadtl.c                   |   2 +-
 tools/perf/util/symbol.c                           |  11 +-
 tools/sched_ext/scx_central.bpf.c                  |   6 +-
 tools/sched_ext/scx_flatcg.bpf.c                   |   2 +-
 tools/testing/selftests/alsa/mixer-test.c          |   4 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |   8 +-
 .../bpf/progs/verifier_subprog_precision.c         |  12 +-
 tools/testing/selftests/cgroup/test_core.c         |   2 +-
 tools/testing/selftests/cgroup/test_cpu.c          |   2 +-
 tools/testing/selftests/cgroup/test_cpuset.c       |   2 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |   6 -
 tools/testing/selftests/cgroup/test_freezer.c      |   2 +-
 tools/testing/selftests/cgroup/test_kill.c         |   2 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   4 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   2 +-
 tools/testing/selftests/cgroup/test_pids.c         |   2 +-
 tools/testing/selftests/cgroup/test_zswap.c        |   2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  28 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   4 +-
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  26 +-
 tools/testing/selftests/net/pmtu.sh                |   2 +-
 tools/testing/selftests/net/test_vxlan_mdb.sh      |   6 +
 tools/testing/selftests/powerpc/tm/tm.h            |   8 +-
 tools/testing/selftests/ublk/Makefile              |   2 +
 655 files changed, 9896 insertions(+), 5497 deletions(-)


