Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED9824EF7A;
	Thu,  3 Apr 2025 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693904; cv=none; b=bk/Drue5j45TbqD99yRfsHJJI5NjIR5E/evv9sdBUdjp9xUhd4FE40qBWBExVYzP2MQjNfejI051saE8uS9LY9+x24vu5NTolFmY4nErics42Fx9dL3/83HGFj1MeP5FBjW5q+s5yGGvegDhVvlkciQ8PN/nmliFMHmqxqHXSzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693904; c=relaxed/simple;
	bh=PI66Uzhh//hg0m/mX1FaOXb4mcFJ9gknPfwNvkdpYuY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eS15YW5kC1u8SKi8YwCKBoMAG+xDxOAa6u0Au/M2TTGo4YUFhbMtpNyWgxYt5ejyBihZbAjQ7bNEzza5oTgW5CdKawRZduq2W5fRA3ooFgykmVH097nPhRKlc4r0t7G9ho/PFYYpbZZkgy85Yu8H5d8c88x58PY31eSbpIHfPrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Th/0S+7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Th/0S+7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA26C4CEE3;
	Thu,  3 Apr 2025 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693904;
	bh=PI66Uzhh//hg0m/mX1FaOXb4mcFJ9gknPfwNvkdpYuY=;
	h=From:To:Cc:Subject:Date:From;
	b=Th/0S+7gjMrfN34A7PAURE7fjohIXxPs/jzT8WhrqYMwN7NscMP8zKxLAPibUshJJ
	 M1n2UwecRufZUMv5o4XPdt8ChpIvYpLYXaXIEBxML23rUHp82dklaiy/l1P3F0K3mx
	 5Uixs09sZIWKXXQGNN9tla9A38hLPV8d/nJuRc6g=
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
Subject: [PATCH 6.12 00/22] 6.12.22-rc1 review
Date: Thu,  3 Apr 2025 16:20:10 +0100
Message-ID: <20250403151622.055059925@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.22-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.22-rc1
X-KernelTest-Deadline: 2025-04-05T15:16+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.22 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.22-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.22-rc1

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: bch2_ioctl_subvolume_destroy() fixes

John Keeping <jkeeping@inmusicbrands.com>
    serial: 8250_dma: terminate correct DMA in tx_dma_flush()

Cheick Traore <cheick.traore@foss.st.com>
    serial: stm32: do not deassert RS485 RTS GPIO prematurely

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    perf tools: Fix up some comments and code to properly use the event_source bus

Luo Qiu <luoqiu@kylinsec.com.cn>
    memstick: rtsx_usb_ms: Fix slab-use-after-free in rtsx_usb_ms_drv_remove

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Apply the link chain quirk on NEC isoc endpoints

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Don't skip on Stopped - Length Invalid

Dominique Martinet <dominique.martinet@atmark-techno.com>
    net: usb: usbnet: restore usb%d name exception for local mac addresses

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FE990B composition

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FN990B composition

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers

Cameron Williams <cang1@live.co.uk>
    tty: serial: 8250: Add Brainboxes XC devices

Cameron Williams <cang1@live.co.uk>
    tty: serial: 8250: Add some more device IDs

William Breathitt Gray <wbg@kernel.org>
    counter: microchip-tcb-capture: Fix undefined counter channel state on probe

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-lptimer-cnt: fix error handling when enabling

Dhruv Deshpande <dhrv.d@proton.me>
    ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx

Maxim Mikityanskiy <maxtram95@gmail.com>
    netfilter: socket: Lookup orig tuple for IPv6 SNAT

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Don't write DP_MSTM_CTRL after LT

Scott Mayhew <smayhew@redhat.com>
    nfsd: fix legacy client tracking initialization

Minjoong Kim <pwn9uin@gmail.com>
    atm: Fix NULL pointer dereference

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: hid-plantronics: Add mic mute mapping and generalize quirks

Terry Junge <linuxhid@cosmicgizmosystems.com>
    ALSA: usb-audio: Add quirk for Plantronics headsets to fix control names


-------------

Diffstat:

 Makefile                                          |   4 +-
 drivers/counter/microchip-tcb-capture.c           |  19 +++
 drivers/counter/stm32-lptimer-cnt.c               |  24 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  16 +--
 drivers/hid/hid-plantronics.c                     | 144 ++++++++++------------
 drivers/memstick/host/rtsx_usb_ms.c               |   1 +
 drivers/net/usb/qmi_wwan.c                        |   2 +
 drivers/net/usb/usbnet.c                          |  21 +++-
 drivers/tty/serial/8250/8250_dma.c                |   2 +-
 drivers/tty/serial/8250/8250_pci.c                |  46 +++++++
 drivers/tty/serial/fsl_lpuart.c                   |  17 +++
 drivers/tty/serial/stm32-usart.c                  |   4 +-
 drivers/usb/host/xhci-ring.c                      |   4 +
 drivers/usb/host/xhci.h                           |  13 +-
 fs/bcachefs/fs-ioctl.c                            |   6 +-
 fs/nfsd/nfs4recover.c                             |   1 -
 net/atm/mpc.c                                     |   2 +
 net/ipv6/netfilter/nf_socket_ipv6.c               |  23 ++++
 sound/pci/hda/patch_realtek.c                     |   1 +
 sound/usb/mixer_quirks.c                          |  51 ++++++++
 tools/perf/Documentation/intel-hybrid.txt         |  12 +-
 tools/perf/Documentation/perf-list.txt            |   2 +-
 tools/perf/arch/x86/util/iostat.c                 |   2 +-
 tools/perf/builtin-stat.c                         |   2 +-
 tools/perf/util/mem-events.c                      |   2 +-
 tools/perf/util/pmu.c                             |   4 +-
 26 files changed, 298 insertions(+), 127 deletions(-)


