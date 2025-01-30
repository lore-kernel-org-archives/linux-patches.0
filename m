Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D62BB15;
	Thu, 30 Jan 2025 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245560; cv=none; b=r5NKHPz6gnUMUAKclqbhE+FdJff/6aBoAPl37/Qxai6uhur8tQq8oyUi/PPixkqDe66mOE5K/Opl0U+l6ed0WZ+ToyK936cwviRv2idGLlUol3nE73rxs/TxN806ot8aEw+m3MEDc+Gz6Q9epKtjgEOBk0NSmSdpf0r6miXbsS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245560; c=relaxed/simple;
	bh=lmNrBa/Hppu71b0Ym3PaKoW0EoP6tAtGudaU5PsXPRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QFJuIApZZ4uK38/cBG0pIWB2CUvEI4NgK03gP1tE5HJrG9pANXuAjAi2Y87mOh+F/vLQyx6AgGJcXHIJibnb7oWVduGv2tLCq9nBar0OJXrDwMdNhd3sKfcZAxxeL+Gi7crfSywKBVv+ndf8KXmeplEWahO7AsBu2Q25egzoOk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ0mvW4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ0mvW4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7C2C4CED2;
	Thu, 30 Jan 2025 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245559;
	bh=lmNrBa/Hppu71b0Ym3PaKoW0EoP6tAtGudaU5PsXPRA=;
	h=From:To:Cc:Subject:Date:From;
	b=FJ0mvW4kMwXoYiMj+HrcC+f/mr6eip2og9lXNUJS+mI85jNmHLlVLolNH9tdW083H
	 TGTy9z5psa4pT9aA3e/irVm1/Ow/eT9KXgXRmYrIzUY1Waa1rCyYSaxxNejl8idOGO
	 Wl8bwgFUkcYGXYg8eJVc9fCVpmp8hyxL5D/rhn6M=
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
Subject: [PATCH 6.13 00/25] 6.13.1-rc1 review
Date: Thu, 30 Jan 2025 14:58:46 +0100
Message-ID: <20250130133456.914329400@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.13.1-rc1
X-KernelTest-Deadline: 2025-02-01T13:34+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.13.1 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.13.1-rc1

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

Jann Horn <jannh@google.com>
    io_uring/rsrc: require cloned buffers to share accounting contexts

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Initialize brightness of LED trigger

Hans de Goede <hdegoede@redhat.com>
    wifi: rtl8xxxu: add more missing rtl8192cu USB IDs

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for USB Audio Device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: u_serial: Disable ep before setting port to null to fix the crash caused by port being null"

Qasim Ijaz <qasdev00@gmail.com>
    USB: serial: quatech2: fix null-ptr-deref in qt2_process_read_urb()

Easwar Hariharan <eahariha@linux.microsoft.com>
    scsi: storvsc: Ratelimit warning logs to prevent VM denial of service

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Linus Torvalds <torvalds@linux-foundation.org>
    cachestat: fix page cache statistics permission checking

Jiri Kosina <jikos@kernel.org>
    Revert "HID: multitouch: Add support for lenovo Y9000P Touchpad"

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix ets qdisc OOB Indexing

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle lack of EA support in smb2_query_path_info()

Chuck Lever <chuck.lever@oracle.com>
    libfs: Use d_children list to iterate simple_offset directories

Chuck Lever <chuck.lever@oracle.com>
    libfs: Replace simple_offset end-of-directory detection

Chuck Lever <chuck.lever@oracle.com>
    Revert "libfs: fix infinite directory reads for offset dir"

Chuck Lever <chuck.lever@oracle.com>
    Revert "libfs: Add simple_offset_empty()"

Chuck Lever <chuck.lever@oracle.com>
    libfs: Return ENOSPC when the directory offset range is exhausted

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag


-------------

Diffstat:

 Makefile                                     |   4 +-
 drivers/hid/hid-ids.h                        |   1 -
 drivers/hid/hid-multitouch.c                 |   8 +-
 drivers/hid/wacom_sys.c                      |  24 ++--
 drivers/input/joystick/xpad.c                |   9 +-
 drivers/input/keyboard/atkbd.c               |   2 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c |  20 ++++
 drivers/scsi/storvsc_drv.c                   |   8 +-
 drivers/usb/gadget/function/u_serial.c       |   8 +-
 drivers/usb/serial/quatech2.c                |   2 +-
 drivers/vfio/platform/vfio_platform_common.c |  10 ++
 fs/gfs2/file.c                               |   1 +
 fs/libfs.c                                   | 162 +++++++++++++--------------
 fs/smb/client/smb2inode.c                    | 104 ++++++++++++-----
 include/linux/fs.h                           |   1 -
 io_uring/rsrc.c                              |   7 ++
 mm/filemap.c                                 |  17 +++
 mm/shmem.c                                   |   4 +-
 net/sched/sch_ets.c                          |   2 +
 sound/usb/quirks.c                           |   2 +
 20 files changed, 251 insertions(+), 145 deletions(-)


