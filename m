Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA58C13D;
	Thu, 30 Jan 2025 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245697; cv=none; b=O20s+mVvlXFiPG8OBzrFy2mmdZZmawJ3ixthIRRaFpHrXNrbLSuGiE/jOc5UsG58kRM1ALuywoUgDZntClXOo+KG3JnaDGVhJHyLMzNxtTaM14J7BIoA+My8ussm/mbLqjPwI0H56qxFY8ZT+482o49H987RXO+/hUTkolpeG9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245697; c=relaxed/simple;
	bh=gCRHDCCPfiXFVhqNmt72zRp/hZixAsQbrhL8GG0x9Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TPcaXuNvIrIqpXwsUDyADzQuEXzGWTkrNZYbtzLdSju3aOiB0LJla/ggFXdi9341DIqTUD4zqiAaq88LfIJjgh4gXJ9NDANzAbJR0o5RQq3dVduSwNoemiWKu+XswNcnfhb0KrwBxUqATXSJlRvTu5cLiSf7ni0dZ0S1TVuEnpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si7t5HVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si7t5HVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DCEC4CED2;
	Thu, 30 Jan 2025 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245696;
	bh=gCRHDCCPfiXFVhqNmt72zRp/hZixAsQbrhL8GG0x9Zw=;
	h=From:To:Cc:Subject:Date:From;
	b=si7t5HVSCL/5SDF1YRVhpB8+WrMyObBKB0Z84GtoZGQePcEPKL7PBMtwcuyUeXrtJ
	 XTEf+3EER67ePaN4M2KaoXpE4R3h5wtiuV5UwyDvDGoatsZIFF/QOM08g0hhuPg+9v
	 coqHRgEnB7bB/Sc77OvybqYn4beb7VvSaKlOXOxY=
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
Subject: [PATCH 6.12 00/40] 6.12.12-rc1 review
Date: Thu, 30 Jan 2025 14:59:00 +0100
Message-ID: <20250130133459.700273275@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.12-rc1
X-KernelTest-Deadline: 2025-02-01T13:35+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.12 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.12-rc1

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

Yosry Ahmed <yosryahmed@google.com>
    mm: zswap: move allocations during CPU init outside the lock

Yosry Ahmed <yosryahmed@google.com>
    mm: zswap: properly synchronize freeing resources during CPU hotunplug

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing depends on I2C

Russell Harmon <russ@har.mn>
    hwmon: (drivetemp) Set scsi command timeout to 10s

Philippe Simons <simons.philippe@gmail.com>
    irqchip/sunxi-nmi: Add missing SKIP_WAKE flag

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/connector: hdmi: Validate supported_formats matches ycbcr_420_allowed

Yage Geng <icoderdev@gmail.com>
    ALSA: hda/realtek: Fix volume adjustment issue on Lenovo ThinkBook 16P Gen5

Rob Herring (Arm) <robh@kernel.org>
    of/unittest: Add test that of_address_to_resource() fails on non-translatable address

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Initialize denominator defaults to 1

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Use HW lock mgr for PSR1

Xiang Zhang <hawkxiang.cpp@gmail.com>
    scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: cs42l43: Add codec force suspend/resume ops

Linus Walleij <linus.walleij@linaro.org>
    seccomp: Stub for !CONFIG_SECCOMP

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing selects for MFD_WM8994

Marian Postevca <posteuca@mutex.one>
    ASoC: codecs: es8316: Fix HW rate calculation for 48Mhz MCLK

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8994: Add depends on MFD core


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |   3 +-
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |   4 +-
 drivers/gpu/drm/drm_connector.c                    |   3 +
 drivers/hid/hid-ids.h                              |   1 -
 drivers/hid/hid-multitouch.c                       |   8 +-
 drivers/hid/wacom_sys.c                            |  24 +--
 drivers/hwmon/drivetemp.c                          |   2 +-
 drivers/input/joystick/xpad.c                      |   9 +-
 drivers/input/keyboard/atkbd.c                     |   2 +-
 drivers/irqchip/irq-sunxi-nmi.c                    |   3 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  20 +++
 drivers/of/unittest-data/tests-platform.dtsi       |  13 ++
 drivers/of/unittest.c                              |  14 ++
 drivers/scsi/scsi_transport_iscsi.c                |   4 +-
 drivers/scsi/storvsc_drv.c                         |   8 +-
 drivers/usb/gadget/function/u_serial.c             |   8 +-
 drivers/usb/serial/quatech2.c                      |   2 +-
 drivers/vfio/platform/vfio_platform_common.c       |  10 ++
 fs/gfs2/file.c                                     |   1 +
 fs/libfs.c                                         | 162 ++++++++++-----------
 fs/smb/client/smb2inode.c                          | 104 +++++++++----
 include/linux/fs.h                                 |   1 -
 include/linux/seccomp.h                            |   2 +-
 mm/filemap.c                                       |  19 +++
 mm/shmem.c                                         |   4 +-
 mm/zswap.c                                         |  90 ++++++++----
 net/sched/sch_ets.c                                |   2 +
 sound/pci/hda/patch_realtek.c                      |   4 +-
 sound/soc/codecs/Kconfig                           |   1 +
 sound/soc/codecs/cs42l43.c                         |   1 +
 sound/soc/codecs/es8316.c                          |  10 +-
 sound/soc/samsung/Kconfig                          |   6 +-
 sound/usb/quirks.c                                 |   2 +
 34 files changed, 367 insertions(+), 184 deletions(-)


