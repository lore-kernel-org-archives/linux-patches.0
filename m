Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6498924E4B2;
	Thu,  3 Apr 2025 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694036; cv=none; b=XZq/RZfCUZWAh1o/YCrhpGEqCZqTq0F6DITrEfOvUTuLPnZsWfkFEl77MvDBgU/BVXFsXX0QgZHasr5AgL6nB8wVGLeUqFvY33CHNxW/u0N7qLlLjb8YAim0AuqWk1z6O9iZ/iDXNHCvr/hdD6x7dTogCUVGqUR5anZC6ZJ1Tjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694036; c=relaxed/simple;
	bh=ddWj3Z13XW8uzI3RDW2AgxXUlibDcIvQOoriVbRvwhg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MrYcdYeQABkwjorT521P9Dgbzxc2wlNPcqE7XaPcYR5BnUN+ovCbPhuOFW4y8Zsv1n3q051kRJ6EX98HSc0yHLVDgg+5+HcNJbD1U6EWVrlNN2HNDQQ5wulEivmfu3QcrftxyoZT8+PuJVxg/7up83VyvrgyqBNCRQIj4aePeKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5KZNVVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5KZNVVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA23EC4CEE5;
	Thu,  3 Apr 2025 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743694036;
	bh=ddWj3Z13XW8uzI3RDW2AgxXUlibDcIvQOoriVbRvwhg=;
	h=From:To:Cc:Subject:Date:From;
	b=y5KZNVVRybc5Y/mlrSMuLsLkN6Q5BqtxDbqToeoqB263DDxbqONdsnahMJCin3x2z
	 w65RE92CAn5pYnNT31ccGNrISWJhzm6/T6hs+svw9Z+osGoBgHxoBOujhzu5xDVZAN
	 KBO+hmWNHBDpQR87iDSf/loxHZzO+Wu9SfZiaTFg=
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
Subject: [PATCH 6.6 00/26] 6.6.86-rc1 review
Date: Thu,  3 Apr 2025 16:20:21 +0100
Message-ID: <20250403151622.415201055@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.86-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.86-rc1
X-KernelTest-Deadline: 2025-04-05T15:16+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.86 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.86-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.86-rc1

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

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: qcom: Only free platform MSIs when ESI is enabled

Changhuang Liang <changhuang.liang@starfivetech.com>
    reset: starfive: jh71x0: Fix accessing the empty member on JH7110 SoC

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm/page_alloc: fix memory accept before watermarks gets initialized

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Don't write DP_MSTM_CTRL after LT

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Add a helper to queue a topology probe

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Factor out function to queue a topology probe work

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
 arch/arm/mm/fault.c                                |   8 ++
 drivers/counter/microchip-tcb-capture.c            |  19 +++
 drivers/counter/stm32-lptimer-cnt.c                |  24 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  16 +--
 .../drm/amd/display/dc/dcn315/dcn315_resource.c    |   2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  36 +++++-
 drivers/hid/hid-plantronics.c                      | 144 ++++++++++-----------
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/usbnet.c                           |  21 ++-
 drivers/reset/starfive/reset-starfive-jh71x0.c     |   3 +
 drivers/tty/serial/8250/8250_dma.c                 |   2 +-
 drivers/tty/serial/8250/8250_pci.c                 |  46 +++++++
 drivers/tty/serial/fsl_lpuart.c                    |  17 +++
 drivers/ufs/host/ufs-qcom.c                        |   4 +-
 drivers/usb/gadget/function/uvc_v4l2.c             |  12 +-
 include/drm/display/drm_dp_mst_helper.h            |   2 +
 mm/page_alloc.c                                    |  14 +-
 net/atm/mpc.c                                      |   2 +
 net/ipv6/netfilter/nf_socket_ipv6.c                |  23 ++++
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/usb/mixer_quirks.c                           |  51 ++++++++
 23 files changed, 340 insertions(+), 114 deletions(-)


