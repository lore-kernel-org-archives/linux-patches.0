Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4E21E9B05;
	Thu, 30 Jan 2025 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247405; cv=none; b=m/1kTuVNseXD45vQMJ5lvT2aXXej/o7j1wubSX2xwQBmzjwO5mfkNCVjR1rPMEjqo2pvQC5AQuw7tO4x/d/3KuuqfxrjSih4G/eSnCFmMkStIgw/JfZvSVk0mnoKBa/Or6n3PqU4CqdKcMo122IP1jPgSGAyeyU3hu9Ga8n+3mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247405; c=relaxed/simple;
	bh=VWv5N6e5PvOl1nUhh4PyIOS0YU+hPLCvZUQzzvL1lhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LO9ik8mnWYd1shwg+QEtf2HV23oBsP/A8HtFks9LQI1A25vf+iGluvjqPSGkTFk39kDdOZd2sQOe8aWdbBp/lzXIH4NIWIQE/h1ciRczFulIiguadt373S85suquz9zqLBbJ71CKcRHTkRZoiEFo1ftKTgXsKlWMDT21tcM+dg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rxH97R1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rxH97R1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3CEC4CED2;
	Thu, 30 Jan 2025 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247405;
	bh=VWv5N6e5PvOl1nUhh4PyIOS0YU+hPLCvZUQzzvL1lhw=;
	h=From:To:Cc:Subject:Date:From;
	b=0rxH97R1kis1rY76tT7lkMgFnwdYaaV2mCBJCFkIYQDzz4e452MKGQ9pyZSytupWv
	 9Bl1rmb5VoIKb1h+oTBPZydNkIH4aySXc81GsqjO/3sod2z1Exm4vQte8cjkNYPs7A
	 Kwa4366IUKR4yvz1rhVWMcuHD7xWpYP4JB6ABnMc=
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
Subject: [PATCH 6.1 00/49] 6.1.128-rc1 review
Date: Thu, 30 Jan 2025 15:01:36 +0100
Message-ID: <20250130140133.825446496@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.128-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.128-rc1
X-KernelTest-Deadline: 2025-02-01T14:01+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.128 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2025 14:01:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.128-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.128-rc1

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: samsung: midas_wm1811: Fix 'Headphone Switch' control creation

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix NULL ptr deref in crypto_aead_setkey()

Jack Greiner <jack@emoss.org>
    Input: xpad - add support for wooting two he (arm)

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - add unofficial Xbox 360 wireless receiver clone

Mark Pearson <mpearson-lenovo@squebb.ca>
    Input: atkbd - map F23 key to support default copilot shortcut

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for USB Audio Device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"

Qasim Ijaz <qasdev00@gmail.com>
    USB: serial: quatech2: fix null-ptr-deref in qt2_process_read_urb()

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix UAF in async decryption

Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: add a few rate index validity checks

Easwar Hariharan <eahariha@linux.microsoft.com>
    scsi: storvsc: Ratelimit warning logs to prevent VM denial of service

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_find()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix access to uninitialised lock in fc replay path

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Jiri Kosina <jkosina@suse.com>
    Revert "HID: multitouch: Add support for lenovo Y9000P Touchpad"

Alexey Dobriyan <adobriyan@gmail.com>
    block: fix integer overflow in BLKSECDISCARD

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix ets qdisc OOB Indexing

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix waiters missing wake ups

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag

Christoph Hellwig <hch@lst.de>
    xfs: respect the stable writes flag on the RT device

Christoph Hellwig <hch@lst.de>
    xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags

Darrick J. Wong <djwong@kernel.org>
    xfs: dquot recovery does not validate the recovered dquot

Darrick J. Wong <djwong@kernel.org>
    xfs: clean up dqblk extraction

Dave Chinner <dchinner@redhat.com>
    xfs: inode recovery does not validate the recovered inode

Omar Sandoval <osandov@fb.com>
    xfs: fix internal error from AGFL exhaustion

Leah Rumancik <leah.rumancik@gmail.com>
    xfs: up(ic_sema) if flushing data device fails

Christoph Hellwig <hch@lst.de>
    xfs: only remap the written blocks in xfs_reflink_end_cow_extent

Long Li <leo.lilong@huawei.com>
    xfs: abort intent items when recovery intents fail

Long Li <leo.lilong@huawei.com>
    xfs: factor out xfs_defer_pending_abort

Catherine Hoang <catherine.hoang@oracle.com>
    xfs: allow read IO and FICLONE to run concurrently

Christoph Hellwig <hch@lst.de>
    xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space

Cheng Lin <cheng.lin130@zte.com.cn>
    xfs: introduce protection for drop nlink

Darrick J. Wong <djwong@kernel.org>
    xfs: make sure maxlen is still congruent with prod when rounding down

Darrick J. Wong <djwong@kernel.org>
    xfs: fix units conversion error in xfs_bmap_del_extent_delay

Darrick J. Wong <djwong@kernel.org>
    xfs: rt stubs should return negative errnos when rt disabled

Darrick J. Wong <djwong@kernel.org>
    xfs: prevent rt growfs when quota is enabled

Darrick J. Wong <djwong@kernel.org>
    xfs: hoist freeing of rt data fork extent mappings

Darrick J. Wong <djwong@kernel.org>
    xfs: bump max fsgeom struct version

K Prateek Nayak <kprateek.nayak@amd.com>
    softirq: Allow raising SCHED_SOFTIRQ from SMP-call-function on RT kernel

Omid Ehtemam-Haghighi <omid.ehtemamhaghighi@menlosecurity.com>
    ipv6: Fix soft lockups in fib6_select_path under high next hop churn

Cosmin Tanislav <demonsingur@gmail.com>
    regmap: detach regmap from dev on regmap_exit

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing depends on I2C

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    ASoC: samsung: midas_wm1811: Map missing jack kcontrols

Philippe Simons <simons.philippe@gmail.com>
    irqchip/sunxi-nmi: Add missing SKIP_WAKE flag

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Use HW lock mgr for PSR1

Xiang Zhang <hawkxiang.cpp@gmail.com>
    scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request

Linus Walleij <linus.walleij@linaro.org>
    seccomp: Stub for !CONFIG_SECCOMP

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing selects for MFD_WM8994

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8994: Add depends on MFD core


-------------

Diffstat:

 Makefile                                           |   4 +-
 block/ioctl.c                                      |   9 +-
 drivers/base/regmap/regmap.c                       |  12 +
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |   3 +-
 drivers/hid/hid-ids.h                              |   1 -
 drivers/hid/hid-multitouch.c                       |   8 +-
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/input/keyboard/atkbd.c                     |   2 +-
 drivers/irqchip/irq-sunxi-nmi.c                    |   3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   9 +-
 drivers/scsi/scsi_transport_iscsi.c                |   4 +-
 drivers/scsi/storvsc_drv.c                         |   8 +-
 drivers/usb/gadget/function/u_serial.c             |   8 +-
 drivers/usb/serial/quatech2.c                      |   2 +-
 drivers/vfio/platform/vfio_platform_common.c       |  10 +
 fs/ext4/super.c                                    |   3 +-
 fs/gfs2/file.c                                     |   1 +
 fs/smb/client/smb2ops.c                            |  47 ++--
 fs/smb/client/smb2pdu.c                            |  10 +-
 fs/xfs/libxfs/xfs_alloc.c                          |  27 ++-
 fs/xfs/libxfs/xfs_bmap.c                           |  21 +-
 fs/xfs/libxfs/xfs_defer.c                          |  38 +--
 fs/xfs/libxfs/xfs_defer.h                          |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |   3 +
 fs/xfs/libxfs/xfs_rtbitmap.c                       |  33 +++
 fs/xfs/libxfs/xfs_sb.h                             |   2 +-
 fs/xfs/xfs_bmap_util.c                             |  24 +-
 fs/xfs/xfs_dquot.c                                 |   5 +-
 fs/xfs/xfs_dquot_item_recover.c                    |  21 +-
 fs/xfs/xfs_file.c                                  |  63 ++++-
 fs/xfs/xfs_inode.c                                 |  24 ++
 fs/xfs/xfs_inode.h                                 |  17 ++
 fs/xfs/xfs_inode_item_recover.c                    |  14 +-
 fs/xfs/xfs_ioctl.c                                 |  34 ++-
 fs/xfs/xfs_iops.c                                  |   7 +
 fs/xfs/xfs_log.c                                   |  23 +-
 fs/xfs/xfs_log_recover.c                           |   2 +-
 fs/xfs/xfs_reflink.c                               |   5 +
 fs/xfs/xfs_rtalloc.c                               |  33 ++-
 fs/xfs/xfs_rtalloc.h                               |  27 ++-
 include/linux/seccomp.h                            |   2 +-
 io_uring/io_uring.c                                |   4 +-
 kernel/softirq.c                                   |  15 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv6/ip6_fib.c                                 |   8 +-
 net/ipv6/route.c                                   |  45 ++--
 net/sched/sch_ets.c                                |   2 +
 sound/soc/codecs/Kconfig                           |   1 +
 sound/soc/samsung/Kconfig                          |   6 +-
 sound/soc/samsung/midas_wm1811.c                   |  24 +-
 sound/usb/quirks.c                                 |   2 +
 tools/testing/selftests/net/Makefile               |   1 +
 .../selftests/net/ipv6_route_update_soft_lockup.sh | 262 +++++++++++++++++++++
 54 files changed, 763 insertions(+), 191 deletions(-)


