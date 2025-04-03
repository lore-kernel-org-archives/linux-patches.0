Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE912505C1;
	Thu,  3 Apr 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693844; cv=none; b=qKwJBZUIQRM2Afb67zeZrtYqyLvgUyOf9vJiw+oHSwLsVetfDf46NeXLTBGS+a4vLfQCTvGwVbj1o5wjVDGBUIMWv2CQUgXlJF+L5gyBZMpXtFhK3C4X5v8bw7sMSddZu1BkEt6MUozJTeZBeMUIzTR+D89sDlYrTOG1rDqsxwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693844; c=relaxed/simple;
	bh=APU5efifNFFUqhtFFC2ibe6DJKnDvWz/xCs+I2bhP68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J3cMIORaAqH8/GueXh4OpKp7EvhElJIvMOc9gk/5PnnZLtfSGFr1t2SHhX+FmU9JToudhQRh59X7fJEc8pgwt80y/iuqxq+HbwlWMtj/K+wvlnm0VMrOspOJ1dbZX6KNmgDjS6znsFGV6c3nYWb4uT9syahyCYlJRhvd/EAZ7/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGUAvzcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGUAvzcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C85DC4CEE3;
	Thu,  3 Apr 2025 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693844;
	bh=APU5efifNFFUqhtFFC2ibe6DJKnDvWz/xCs+I2bhP68=;
	h=From:To:Cc:Subject:Date:From;
	b=jGUAvzcWFt8+0CCx9JGz+3isNsf8tJm0S1rm0xjfTL7V9hAazrg4RNlojTpgrtzMa
	 Z4I3DCrZa8fjOEn+4kkMvJPiEitLi/yBTb1J3Qh5lcafO8PGZUzPEUhqg0Bc4KTA9d
	 BYFF6dGvuCyyrF91GgG2THNg6R82Ts2EPzw/hYRk=
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
Subject: [PATCH 6.14 00/21] 6.14.1-rc1 review
Date: Thu,  3 Apr 2025 16:20:04 +0100
Message-ID: <20250403151621.130541515@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.14.1-rc1
X-KernelTest-Deadline: 2025-04-05T15:16+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.14.1 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.14.1-rc1

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

Andres Traumann <andres.traumann.01@gmail.com>
    ALSA: hda/realtek: Bass speaker fixup for ASUS UM5606KA

Dhruv Deshpande <dhrv.d@proton.me>
    ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx

Maxim Mikityanskiy <maxtram95@gmail.com>
    netfilter: socket: Lookup orig tuple for IPv6 SNAT

Abel Wu <wuyun.abel@bytedance.com>
    cgroup/rstat: Fix forceidle time in cpu.stat

Minjoong Kim <pwn9uin@gmail.com>
    atm: Fix NULL pointer dereference

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: hid-plantronics: Add mic mute mapping and generalize quirks

Terry Junge <linuxhid@cosmicgizmosystems.com>
    ALSA: usb-audio: Add quirk for Plantronics headsets to fix control names


-------------

Diffstat:

 Makefile                                  |   4 +-
 drivers/counter/microchip-tcb-capture.c   |  19 ++++
 drivers/counter/stm32-lptimer-cnt.c       |  24 +++--
 drivers/hid/hid-plantronics.c             | 144 ++++++++++++++----------------
 drivers/memstick/host/rtsx_usb_ms.c       |   1 +
 drivers/net/usb/qmi_wwan.c                |   2 +
 drivers/net/usb/usbnet.c                  |  21 +++--
 drivers/tty/serial/8250/8250_dma.c        |   2 +-
 drivers/tty/serial/8250/8250_pci.c        |  46 ++++++++++
 drivers/tty/serial/fsl_lpuart.c           |  17 ++++
 drivers/tty/serial/stm32-usart.c          |   4 +-
 drivers/usb/host/xhci-ring.c              |   4 +
 drivers/usb/host/xhci.h                   |  13 ++-
 kernel/cgroup/rstat.c                     |  29 +++---
 net/atm/mpc.c                             |   2 +
 net/ipv6/netfilter/nf_socket_ipv6.c       |  23 +++++
 sound/pci/hda/patch_realtek.c             |   2 +
 sound/usb/mixer_quirks.c                  |  51 +++++++++++
 tools/perf/Documentation/intel-hybrid.txt |  12 +--
 tools/perf/Documentation/perf-list.txt    |   2 +-
 tools/perf/arch/x86/util/iostat.c         |   2 +-
 tools/perf/builtin-stat.c                 |   2 +-
 tools/perf/util/mem-events.c              |   2 +-
 tools/perf/util/pmu.c                     |   4 +-
 24 files changed, 304 insertions(+), 128 deletions(-)


