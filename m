Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5B01DDC22;
	Thu, 30 Jan 2025 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246529; cv=none; b=KPwaM+6raY59d6A5Bxi379EQysqR8Sg9wfQDDDAhJqdeW9Wy9u8jLKvioujFQReejGV79q3PdADl48yosuptpEfp443XxrAQizTga3NRNAyxxPxhai9vuVEIQuzLhXBSE8fY5uruW39UhJ7G4wdcc8GROO6+acst410mdRiQ77U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246529; c=relaxed/simple;
	bh=8zWhU41ndvJaNliM7IEN72PmnFRDUdYgWtsK1tXg06s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rf9xqhmpJw/6qzB+yBJ2MltAcspfAwL5gWjXApc8sXnqUV1LlyQ0O8jzt4v4yet8zkYA75dEsM+At/xBSKoj4bbjIPzhcwfhFUy/mb/fF0vT+gLlGD7qltNz3TlKM2v359oN8bUQMjNwdf6NVdQXi34u/+hXjLRAKSqWIZtKXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I239/gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I239/gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC6C4CED2;
	Thu, 30 Jan 2025 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246528;
	bh=8zWhU41ndvJaNliM7IEN72PmnFRDUdYgWtsK1tXg06s=;
	h=From:To:Cc:Subject:Date:From;
	b=1I239/ggY9DKIHz+ZFq/STSyvrsl2+wfw0QqyDDPEnVP5CpRZ+eT9lmcWgVbUw6EK
	 NvitUmlwaDMutvKeizXJVwrSHAOHouDnXlbgv/uQLvBE+KZhy7yEcFmtMIsGxRLaxI
	 PJfI1w2bDZtxOJJSQafPs0UlJHWvSmrgoyaCv2lE=
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
Subject: [PATCH 6.6 00/43] 6.6.75-rc1 review
Date: Thu, 30 Jan 2025 14:59:07 +0100
Message-ID: <20250130133458.903274626@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.75-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.75-rc1
X-KernelTest-Deadline: 2025-02-01T13:35+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.75 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.75-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.75-rc1

Jack Greiner <jack@emoss.org>
    Input: xpad - add support for wooting two he (arm)

Matheos Mattsson <matheos.mattsson@gmail.com>
    Input: xpad - add support for Nacon Evol-X Xbox One Controller

Leonardo Brondani Schenkel <leonardo@schenkel.net>
    Input: xpad - improve name of 8BitDo controller 2dc8:3106

Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
    Input: xpad - add QH Electronics VID/PID

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - add unofficial Xbox 360 wireless receiver clone

Mark Pearson <mpearson-lenovo@squebb.ca>
    Input: atkbd - map F23 key to support default copilot shortcut

Nicolas Nobelis <nicolas@nobelis.eu>
    Input: xpad - add support for Nacon Pro Compact

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for USB Audio Device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"

Qasim Ijaz <qasdev00@gmail.com>
    USB: serial: quatech2: fix null-ptr-deref in qt2_process_read_urb()

Easwar Hariharan <eahariha@linux.microsoft.com>
    scsi: storvsc: Ratelimit warning logs to prevent VM denial of service

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_find()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix access to uninitialised lock in fc replay path

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Linus Torvalds <torvalds@linux-foundation.org>
    cachestat: fix page cache statistics permission checking

Jiri Kosina <jkosina@suse.com>
    Revert "HID: multitouch: Add support for lenovo Y9000P Touchpad"

Alexey Dobriyan <adobriyan@gmail.com>
    block: fix integer overflow in BLKSECDISCARD

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix ets qdisc OOB Indexing

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle lack of EA support in smb2_query_path_info()

Chuck Lever <chuck.lever@oracle.com>
    libfs: Use d_children list to iterate simple_offset directories

Chuck Lever <chuck.lever@oracle.com>
    libfs: Replace simple_offset end-of-directory detection

Chuck Lever <chuck.lever@oracle.com>
    Revert "libfs: Add simple_offset_empty()"

Chuck Lever <chuck.lever@oracle.com>
    libfs: Return ENOSPC when the directory offset range is exhausted

Chuck Lever <chuck.lever@oracle.com>
    shmem: Fix shmem_rename2()

Chuck Lever <chuck.lever@oracle.com>
    libfs: Add simple_offset_rename() API

Chuck Lever <chuck.lever@oracle.com>
    libfs: Fix simple_offset_rename_exchange()

Chuck Lever <chuck.lever@oracle.com>
    libfs: Add simple_offset_empty()

Chuck Lever <chuck.lever@oracle.com>
    libfs: Define a minimum directory offset

Chuck Lever <chuck.lever@oracle.com>
    libfs: Re-arrange locking in offset_iterate_dir()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid CPU lockups due fifo occupancy check loop

Omid Ehtemam-Haghighi <omid.ehtemamhaghighi@menlosecurity.com>
    ipv6: Fix soft lockups in fib6_select_path under high next hop churn

Anastasia Belova <abelova@astralinux.ru>
    cpufreq: amd-pstate: add check for cpufreq_cpu_get's return value

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-core: Set ATA_QCFLAG_RTF_FILLED in fill_result_tf()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing depends on I2C

Russell Harmon <russ@har.mn>
    hwmon: (drivetemp) Set scsi command timeout to 10s

Philippe Simons <simons.philippe@gmail.com>
    irqchip/sunxi-nmi: Add missing SKIP_WAKE flag

Rob Herring (Arm) <robh@kernel.org>
    of/unittest: Add test that of_address_to_resource() fails on non-translatable address

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
 drivers/ata/libahci.c                              |  12 +-
 drivers/ata/libata-core.c                          |   8 +
 drivers/cpufreq/amd-pstate.c                       |   7 +-
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |   3 +-
 drivers/hid/hid-ids.h                              |   1 -
 drivers/hid/hid-multitouch.c                       |   8 +-
 drivers/hwmon/drivetemp.c                          |   2 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  10 +
 drivers/input/joystick/xpad.c                      |   9 +-
 drivers/input/keyboard/atkbd.c                     |   2 +-
 drivers/irqchip/irq-sunxi-nmi.c                    |   3 +-
 drivers/of/unittest-data/tests-platform.dtsi       |  13 +
 drivers/of/unittest.c                              |  14 ++
 drivers/scsi/scsi_transport_iscsi.c                |   4 +-
 drivers/scsi/storvsc_drv.c                         |   8 +-
 drivers/usb/gadget/function/u_serial.c             |   8 +-
 drivers/usb/serial/quatech2.c                      |   2 +-
 drivers/vfio/platform/vfio_platform_common.c       |  10 +
 fs/ext4/super.c                                    |   3 +-
 fs/gfs2/file.c                                     |   1 +
 fs/libfs.c                                         | 177 ++++++++++----
 fs/smb/client/smb2inode.c                          | 104 +++++---
 include/linux/fs.h                                 |   2 +
 include/linux/seccomp.h                            |   2 +-
 mm/filemap.c                                       |  19 ++
 mm/shmem.c                                         |   3 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv6/ip6_fib.c                                 |   8 +-
 net/ipv6/route.c                                   |  45 ++--
 net/sched/sch_ets.c                                |   2 +
 sound/soc/codecs/Kconfig                           |   1 +
 sound/soc/samsung/Kconfig                          |   6 +-
 sound/usb/quirks.c                                 |   2 +
 tools/testing/selftests/net/Makefile               |   1 +
 .../selftests/net/ipv6_route_update_soft_lockup.sh | 262 +++++++++++++++++++++
 37 files changed, 640 insertions(+), 137 deletions(-)


