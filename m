Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1418D1BD9D3;
	Thu, 30 Jan 2025 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247303; cv=none; b=FEjabFErVi+jPJGfCWWKsrsziSzWcKr9jZ8pdWsk9z4DJA31fSXldJPmjU3AdiZYXdae0bKaBavt5z4bCwRXVIrk6n1X2kLQ8fRK6aSGjCsu6nlRextnXwOfowRs5KjTok8tSEPK16we8V2StM+E4KBr19EHAUYlWC2gMSVYZSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247303; c=relaxed/simple;
	bh=PGdkvtOqo287tXKkA04WtQt/r49vOTtnShkQJlVtqDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SPCQ8oSJ0+JcBaIzquWXW17XzyWh3y5BgkG6ZoH1yioqSugqZIjYiV2oWJovYTto2kICEQBCu0Q0ZDvX39ZslveI8QCNtPR1b3HYgmyBByEN/0lhf+Fee+8plxUeFyu9jqu014ZgIn1S9SExsml1s0A+LMVRWX5wpAP0HH1B584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPCUXNlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPCUXNlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AF7C4CED2;
	Thu, 30 Jan 2025 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247303;
	bh=PGdkvtOqo287tXKkA04WtQt/r49vOTtnShkQJlVtqDU=;
	h=From:To:Cc:Subject:Date:From;
	b=yPCUXNlhUHok8MIWtWnjd3Lmxay2u3CgudElcifBKwC4s77GW200AMVEKG/L6gavB
	 qGWQ/ELoLdPFuUqZqmUEqFSQYG6y2HNis1pxCCI206z1c3mmSPLI51JeANW2tkiaLS
	 BX/8wwBTEni0foUZ5dkrKngiM+7w84rHkTHOa+wU=
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
Subject: [PATCH 5.15 00/24] 5.15.178-rc1 review
Date: Thu, 30 Jan 2025 15:01:52 +0100
Message-ID: <20250130140127.295114276@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.178-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.178-rc1
X-KernelTest-Deadline: 2025-02-01T14:01+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.178 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2025 14:01:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.178-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.178-rc1

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

Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: add a few rate index validity checks

Easwar Hariharan <eahariha@linux.microsoft.com>
    scsi: storvsc: Ratelimit warning logs to prevent VM denial of service

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_find()

Akihiko Odaki <akihiko.odaki@gmail.com>
    platform/chrome: cros_ec_typec: Check for EC driver

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Additional check in ntfs_file_release

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: Fix not validating setsockopt user input

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix not validating setsockopt user input

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix ets qdisc OOB Indexing

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Truncate address space when flipping GFS2_DIF_JDATA flag

Paolo Abeni <pabeni@redhat.com>
    mptcp: don't always assume copied data in mptcp_cleanup_rbuf()

Cosmin Tanislav <demonsingur@gmail.com>
    regmap: detach regmap from dev on regmap_exit

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: samsung: Add missing depends on I2C

Philippe Simons <simons.philippe@gmail.com>
    irqchip/sunxi-nmi: Add missing SKIP_WAKE flag

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

 Makefile                                     |  4 ++--
 drivers/base/regmap/regmap.c                 | 12 ++++++++++++
 drivers/input/joystick/xpad.c                |  2 ++
 drivers/input/keyboard/atkbd.c               |  2 +-
 drivers/irqchip/irq-sunxi-nmi.c              |  3 ++-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c  |  7 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c  |  9 ++++++---
 drivers/platform/chrome/cros_ec_typec.c      |  3 +++
 drivers/scsi/scsi_transport_iscsi.c          |  4 +++-
 drivers/scsi/storvsc_drv.c                   |  8 +++++++-
 drivers/usb/gadget/function/u_serial.c       |  8 ++++----
 drivers/usb/serial/quatech2.c                |  2 +-
 drivers/vfio/platform/vfio_platform_common.c | 10 ++++++++++
 fs/gfs2/file.c                               |  1 +
 fs/ntfs3/file.c                              | 12 ++++++++++--
 include/linux/seccomp.h                      |  2 +-
 include/net/bluetooth/bluetooth.h            |  9 +++++++++
 net/bluetooth/rfcomm/sock.c                  | 14 +++++---------
 net/bluetooth/sco.c                          | 19 ++++++++-----------
 net/ipv4/ip_tunnel.c                         |  2 +-
 net/mptcp/protocol.c                         | 18 +++++++++---------
 net/sched/sch_ets.c                          |  2 ++
 sound/soc/codecs/Kconfig                     |  1 +
 sound/soc/samsung/Kconfig                    |  6 ++++--
 sound/usb/quirks.c                           |  2 ++
 25 files changed, 111 insertions(+), 51 deletions(-)


