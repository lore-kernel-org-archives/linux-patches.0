Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3524CEE5;
	Thu,  3 Apr 2025 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693800; cv=none; b=eGUKtxzXpxJNwAhrPPxuFvxrsGrmm62n68BgogqsIXFWNxzOv8dnScpfLomV2Er2kPEgf7FPiI9K5Kl8K38/W4RFUiU84/sA/Bd7r+lOQIzqK8+2EvX5mpdckwLQGuQf0MctcmBARj6Oq55o95Yf2OVlACyRCAmyMBrOSdQ29m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693800; c=relaxed/simple;
	bh=6ZFaM/Uvwrkarz4SIQ5+CwXUuMrp3QkS4FpU3Q8kCKU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O0h6mcqovC3onpnvEQq/fMC86yECR4ZiWXaQNpi2rRp3i6r0rcmNkOBd55dd6JPvNgPXcmJUGLM/mNucc0Iwf41fUBgEHm7yLF8oHVZjFujZmV8fncQ0B1wYjpvZ+AZxtoW/3Bh/+b0XRBTbd9pmlw/JeCA+awi6ZfIXtUzpGZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiZ9KL90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiZ9KL90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE23C4CEE3;
	Thu,  3 Apr 2025 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693799;
	bh=6ZFaM/Uvwrkarz4SIQ5+CwXUuMrp3QkS4FpU3Q8kCKU=;
	h=From:To:Cc:Subject:Date:From;
	b=QiZ9KL90481kNW4i2W9iQvuJzEvjruf/nTcf4kWgSxiANkHQnAB22hnblsFMLWW3D
	 CBCT3rldjvvDOWz+P/aUgaTl2hNKUMD+64tlhkUOaF2qekmYxJw4ff8Qoha8BXttm8
	 Agq5TMAhoBDM9zfWGYbEzS9tMfkIY1df+yrsmDcw=
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
Subject: [PATCH 6.1 00/22] 6.1.133-rc1 review
Date: Thu,  3 Apr 2025 16:19:55 +0100
Message-ID: <20250403151620.960551909@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.133-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.133-rc1
X-KernelTest-Deadline: 2025-04-05T15:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.133 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.133-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.133-rc1

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    ARM: dts: imx6qdl-apalis: Fix poweroff on Apalis iMX6

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    media: i2c: et8ek8: Don't strip remove function when driver is builtin

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Fix NULL pointer access

Abhishek Tamboli <abhishektamboli9@gmail.com>
    usb: gadget: uvc: Fix ERR_PTR dereference in uvc_v4l2.c

John Keeping <jkeeping@inmusicbrands.com>
    serial: 8250_dma: terminate correct DMA in tx_dma_flush()

Luo Qiu <luoqiu@kylinsec.com.cn>
    memstick: rtsx_usb_ms: Fix slab-use-after-free in rtsx_usb_ms_drv_remove

Dominique Martinet <dominique.martinet@atmark-techno.com>
    net: usb: usbnet: restore usb%d name exception for local mac addresses

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FE990B composition

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FN990B composition

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

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check denominator crb_pipes before used

Yanjun Yang <yangyj.ee@gmail.com>
    ARM: Remove address checking for MMUless devices

Kees Cook <keescook@chromium.org>
    ARM: 9351/1: fault: Add "cut here" line for prefetch aborts

Kees Cook <keescook@chromium.org>
    ARM: 9350/1: fault: Implement copy_from_kernel_nofault_allowed()

Minjoong Kim <pwn9uin@gmail.com>
    atm: Fix NULL pointer dereference

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: hid-plantronics: Add mic mute mapping and generalize quirks

Terry Junge <linuxhid@cosmicgizmosystems.com>
    ALSA: usb-audio: Add quirk for Plantronics headsets to fix control names


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-apalis.dtsi              |  10 +-
 arch/arm/mm/fault.c                                |   8 ++
 drivers/counter/microchip-tcb-capture.c            |  19 +++
 drivers/counter/stm32-lptimer-cnt.c                |  24 ++--
 .../drm/amd/display/dc/dcn315/dcn315_resource.c    |   2 +-
 drivers/hid/hid-plantronics.c                      | 144 ++++++++++-----------
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |   4 +-
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/usbnet.c                           |  21 ++-
 drivers/tty/serial/8250/8250_dma.c                 |   2 +-
 drivers/tty/serial/8250/8250_pci.c                 |  46 +++++++
 drivers/usb/gadget/function/uvc_v4l2.c             |  12 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  13 +-
 net/atm/mpc.c                                      |   2 +
 net/ipv6/netfilter/nf_socket_ipv6.c                |  23 ++++
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/usb/mixer_quirks.c                           |  51 ++++++++
 19 files changed, 279 insertions(+), 110 deletions(-)


