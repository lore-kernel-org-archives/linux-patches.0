Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0321813BAC3;
	Thu, 23 May 2024 13:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470453; cv=none; b=EgSpY1JNbY+13AFINBZ6wz+MSiaNT85xY0EwfJNW7phGzvAuUBfVftqlUHoSFagwqOZimC+JnV3+uM/RKoZrgRAm4yVSXpH1rVctom/pJxBiiQOmt5lwX3nq+N3QzeGlyRYU3oy8FEqyeXVOE1pWjtjVd7bqwMsAZRy21qxA/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470453; c=relaxed/simple;
	bh=ar6qY6T96THmaK4PF+VaWr6N1OIeuEpfrHMygoEs2Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EIBZJal2t7JVsc+sQ2JjCNKQ/5cp5zKcNTGrJQvA55T+DNx4ozRimwzbE1gIPp/e4kjzT9uCtkAJPSANuM5mD9/59Mma3JolRhsP+LtVs1TSh+58FPCFyTDbdDg/+Ed8M6YZH7+QRm5WnebjAK8JRxjZfXdCWikAtUvliTUstPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEvt5MrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEvt5MrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06851C2BD10;
	Thu, 23 May 2024 13:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470452;
	bh=ar6qY6T96THmaK4PF+VaWr6N1OIeuEpfrHMygoEs2Zo=;
	h=From:To:Cc:Subject:Date:From;
	b=QEvt5MrHT6ukSpbUXSx8wDujylPunhQ+jC96x4IW+Alr8JAg5k2r/I1HB/R6hCSDO
	 okAX1Z2Qa8mdEmmtFsF26b8wJN+IhmcklXpjzPYram0QvPrB9KjunzSQjs70MmtkPc
	 4AcC0BS+Uf0i6yXW5X9rX70HOSJRcrOFHHhA9LUU=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.1 00/45] 6.1.92-rc1 review
Date: Thu, 23 May 2024 15:12:51 +0200
Message-ID: <20240523130332.496202557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.92-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.92 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.92-rc1

Akira Yokosawa <akiyks@gmail.com>
    docs: kernel_include.py: Cope with docutils 0.21

Thomas Weißschuh <linux@weissschuh.net>
    admin-guide/hw-vuln/core-scheduling: fix return type of PR_SCHED_CORE_GET

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Do not use WARN when encode fails

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    remoteproc: mediatek: Make sure IPI buffer fits in L2TCM

Daniel Thompson <daniel.thompson@linaro.org>
    serial: kgdboc: Fix NMI-safety problems from keyboard reset code

Javier Carrasco <javier.carrasco@wolfvision.net>
    usb: typec: tipd: fix event checking for tps6598x

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix potential deadlock

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: fix link status when link is set to down/up

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Wait unconditionally after issuing EndXfer command

Carlos Llamas <cmllamas@google.com>
    binder: fix max_thread type inconsistency

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()

Mark Rutland <mark.rutland@arm.com>
    arm64: atomics: lse: remove stale dependency on JUMP_LABEL

Eric Sandeen <sandeen@redhat.com>
    xfs: short circuit xfs_growfs_data_private() if delta is zero

Hironori Shiina <shiina.hironori@gmail.com>
    xfs: get root inode correctly at bulkstat

Darrick J. Wong <djwong@kernel.org>
    xfs: fix log recovery when unknown rocompat bits are set

Darrick J. Wong <djwong@kernel.org>
    xfs: allow inode inactivation during a ro mount log recovery

Darrick J. Wong <djwong@kernel.org>
    xfs: invalidate xfs_bufs when allocating cow extents

Darrick J. Wong <djwong@kernel.org>
    xfs: estimate post-merge refcounts correctly

Darrick J. Wong <djwong@kernel.org>
    xfs: hoist refcount record merge predicates

Guo Xuenan <guoxuenan@huawei.com>
    xfs: fix super block buf log item UAF during force shutdown

Guo Xuenan <guoxuenan@huawei.com>
    xfs: wait iclog complete before tearing down AIL

Darrick J. Wong <djwong@kernel.org>
    xfs: attach dquots to inode before reading data/cow fork mappings

Darrick J. Wong <djwong@kernel.org>
    xfs: invalidate block device page cache during unmount

Long Li <leo.lilong@huawei.com>
    xfs: fix incorrect i_nlink caused by inode racing

Long Li <leo.lilong@huawei.com>
    xfs: fix sb write verify for lazysbcount

Darrick J. Wong <djwong@kernel.org>
    xfs: fix incorrect error-out in xfs_remove

Dave Chinner <dchinner@redhat.com>
    xfs: fix off-by-one-block in xfs_discard_folio()

Dave Chinner <dchinner@redhat.com>
    xfs: drop write error injection is unfixable, remove it

Dave Chinner <dchinner@redhat.com>
    xfs: use iomap_valid method to detect stale cached iomaps

Dave Chinner <dchinner@redhat.com>
    iomap: write iomap validity checks

Dave Chinner <dchinner@redhat.com>
    xfs: xfs_bmap_punch_delalloc_range() should take a byte range

Dave Chinner <dchinner@redhat.com>
    iomap: buffered write failure should not truncate the page cache

Dave Chinner <dchinner@redhat.com>
    xfs,iomap: move delalloc punching to iomap

Dave Chinner <dchinner@redhat.com>
    xfs: use byte ranges for write cleanup ranges

Dave Chinner <dchinner@redhat.com>
    xfs: punching delalloc extents on write failure is racy

Dave Chinner <dchinner@redhat.com>
    xfs: write page faults in iomap are not buffered writes

Mengqi Zhang <mengqi.zhang@mediatek.com>
    mmc: core: Add HS400 tuning in HS400es initialization

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix memory leak in tpm2_key_encode()

NeilBrown <neilb@suse.de>
    nfsd: don't allow nfsd threads to be signalled.

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    mfd: stpmic1: Fix swapped mask/unmask in irq chip

Sergey Shtylyov <s.shtylyov@omp.ru>
    pinctrl: core: handle radix_tree_insert() errors in pinctrl_register_one_pin()

Jacob Keller <jacob.e.keller@intel.com>
    ice: remove unnecessary duplicate checks for VF VSI ID

Jacob Keller <jacob.e.keller@intel.com>
    ice: pass VSI pointer into ice_vc_isvalid_q_id

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix another TX stall caused by wrong ISR flag handling

Jose Fernandez <josef@netflix.com>
    drm/amd/display: Fix division by zero in setup_dsc_config


-------------

Diffstat:

 .../admin-guide/hw-vuln/core-scheduling.rst        |   4 +-
 Documentation/sphinx/kernel_include.py             |   1 -
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   1 -
 arch/arm64/include/asm/lse.h                       |   1 -
 drivers/android/binder.c                           |   2 +-
 drivers/android/binder_internal.h                  |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   3 +
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c        |   7 +-
 drivers/mfd/stpmic1.c                              |   5 +-
 drivers/mmc/core/mmc.c                             |   9 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  22 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   3 -
 drivers/net/ethernet/micrel/ks8851_common.c        |  18 +-
 drivers/net/usb/ax88179_178a.c                     |  37 ++-
 drivers/pinctrl/core.c                             |  14 +-
 drivers/remoteproc/mtk_scp.c                       |  10 +-
 drivers/tty/serial/kgdboc.c                        |  30 ++-
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/typec/tipd/core.c                      |  45 ++--
 drivers/usb/typec/tipd/tps6598x.h                  |  11 +
 drivers/usb/typec/ucsi/displayport.c               |   4 -
 fs/iomap/buffered-io.c                             | 254 ++++++++++++++++++++-
 fs/iomap/iter.c                                    |  19 +-
 fs/nfs/callback.c                                  |   9 +-
 fs/nfsd/nfs4proc.c                                 |   5 +-
 fs/nfsd/nfssvc.c                                   |  12 -
 fs/xfs/libxfs/xfs_bmap.c                           |   8 +-
 fs/xfs/libxfs/xfs_errortag.h                       |  12 +-
 fs/xfs/libxfs/xfs_refcount.c                       | 146 ++++++++++--
 fs/xfs/libxfs/xfs_sb.c                             |   7 +-
 fs/xfs/xfs_aops.c                                  |  37 +--
 fs/xfs/xfs_bmap_util.c                             |  10 +-
 fs/xfs/xfs_bmap_util.h                             |   2 +-
 fs/xfs/xfs_buf.c                                   |   1 +
 fs/xfs/xfs_buf_item.c                              |   2 +
 fs/xfs/xfs_error.c                                 |  27 ++-
 fs/xfs/xfs_file.c                                  |   2 +-
 fs/xfs/xfs_fsops.c                                 |   4 +
 fs/xfs/xfs_icache.c                                |   6 +
 fs/xfs/xfs_inode.c                                 |  16 +-
 fs/xfs/xfs_ioctl.c                                 |   4 +-
 fs/xfs/xfs_iomap.c                                 | 177 ++++++++------
 fs/xfs/xfs_iomap.h                                 |   6 +-
 fs/xfs/xfs_log.c                                   |  53 ++---
 fs/xfs/xfs_mount.c                                 |  15 ++
 fs/xfs/xfs_pnfs.c                                  |   6 +-
 include/linux/iomap.h                              |  47 +++-
 net/sunrpc/svc_xprt.c                              |  16 +-
 security/keys/trusted-keys/trusted_tpm2.c          |  25 +-
 50 files changed, 866 insertions(+), 299 deletions(-)


