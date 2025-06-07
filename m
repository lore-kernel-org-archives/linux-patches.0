Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C91F4CB8;
	Sat,  7 Jun 2025 10:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290987; cv=none; b=GRaYqj50T3AyCd9hlL7teFcMeZk5O9DaaVQvUACFr2rwuGGVrZIf+Q+zATXuMeEEi/0D4z/BNcG2NHqAq8735byIynZbrIEdUoCBHQzuAMcrVmWEspDC8X432EsxHCDPwu7SkSQ0DfiC+o2n0xy5KHNAf29jFO9FsSA3rHM6bCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290987; c=relaxed/simple;
	bh=5izhTrwbML5NmL7+4ouvty7q20xLmR4Ux50PCxytBrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CKDonroKTgQSOkQeF1UTPmbK+jE6Hy3aKbYDIhOO9B/clNooKs97RibfBCARsUUM398GqjUgjk9VyYVaEuPjnNINLvy6UaTGs5WEXsl+tMvqt8nG+RN3PNX3rwHfWfMlBxympa4qhH/7rdfcHB/GaJmBVP+6KaApgbp1BrF1bck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIYqksS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIYqksS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B2C4CEE4;
	Sat,  7 Jun 2025 10:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290987;
	bh=5izhTrwbML5NmL7+4ouvty7q20xLmR4Ux50PCxytBrg=;
	h=From:To:Cc:Subject:Date:From;
	b=FIYqksS1O4YfTrLXowxDhl48zxHKlmze2ey5vheezELYQ9NtY5CO+7UAjyS5b0dkU
	 R3vVMq5eFsTpukTPFpNuBImP1b7jrzhYRA+Y6gjS35Kx7PDbgfF756zonbMuKWtLr3
	 XJBHrBnVJoTARQMPsBms5EW5okOkSC7u/PIQe51s=
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
Subject: [PATCH 6.14 00/24] 6.14.11-rc1 review
Date: Sat,  7 Jun 2025 12:07:40 +0200
Message-ID: <20250607100717.706871523@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.14.11-rc1
X-KernelTest-Deadline: 2025-06-09T10:07+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.14.11 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.14.11-rc1

Aurabindo Pillai <aurabindo.pillai@amd.com>
    Revert "drm/amd/display: more liberal vmin/vmax update for freesync"

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: phy: imx8mq-usb: fix fsl,phy-tx-vboost-level-microvolt property

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    dt-bindings: usb: cypress,hx3: Add support for all variants

David Lechner <dlechner@baylibre.com>
    dt-bindings: pwm: adi,axi-pwmgen: Fix clocks

Sergey Senozhatsky <senozhatsky@chromium.org>
    thunderbolt: Do not double dequeue a configuration request

Carlos Llamas <cmllamas@google.com>
    binder: fix yet another UAF in binder_devices

Dmitry Antipov <dmantipov@yandex.ru>
    binder: fix use-after-free in binderfs_evict_inode()

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix timeout value in get_stb

Arnd Bergmann <arnd@arndb.de>
    nvmem: rmem: select CONFIG_CRC32

Dustin Lundquist <dustin@null-ptr.net>
    serial: jsm: fix NPE during jsm_uart_port_init

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    Bluetooth: hci_qca: move the SoC type check to the right place

Qasim Ijaz <qasdev00@gmail.com>
    usb: typec: ucsi: fix Clang -Wsign-conversion warning

Charles Yeh <charlesyeh522@gmail.com>
    USB: serial: pl2303: add new chip PL2303GC-Q20 and PL2303GT-2AB

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: storage: Ignore UAS driver for SanDisk 3.2 Gen2 storage device

Jiayi Li <lijiayi@kylinos.cn>
    usb: quirks: Add NO_LPM quirk for SanDisk Extreme 55AE

Mike Marshall <hubcap@omnibond.com>
    orangefs: adjust counting code to recover from 665575cf

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Fix offset calculation for .start_secs < 0

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Make rtc_time64_to_tm() support dates before 1970

Sakari Ailus <sakari.ailus@linux.intel.com>
    Documentation: ACPI: Use all-string data node references

Gautham R. Shenoy <gautham.shenoy@amd.com>
    acpi-cpufreq: Fix nominal_freq units to KHz in get_max_boost_ratio()

Pritam Manohar Sutar <pritam.sutar@samsung.com>
    clk: samsung: correct clock summary for hsi1 block

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: set GPIO output value before setting direction

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: use correct OUTPUT_VAL register for GPIOs > 31

Pan Taixi <pantaixi@huaweicloud.com>
    tracing: Fix compilation warning on arm32


-------------

Diffstat:

 .../bindings/phy/fsl,imx8mq-usb-phy.yaml           |  3 +--
 .../devicetree/bindings/pwm/adi,axi-pwmgen.yaml    | 13 +++++++++--
 .../devicetree/bindings/usb/cypress,hx3.yaml       | 19 +++++++++++++---
 .../acpi/dsd/data-node-references.rst              | 26 ++++++++++------------
 Documentation/firmware-guide/acpi/dsd/graph.rst    | 11 ++++-----
 Documentation/firmware-guide/acpi/dsd/leds.rst     |  7 +-----
 Makefile                                           |  4 ++--
 drivers/android/binder.c                           | 16 +++++++++++--
 drivers/android/binder_internal.h                  |  8 +++++--
 drivers/android/binderfs.c                         |  2 +-
 drivers/bluetooth/hci_qca.c                        | 14 ++++++------
 drivers/clk/samsung/clk-exynosautov920.c           |  2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 16 +++++--------
 drivers/nvmem/Kconfig                              |  1 +
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        | 14 +++++++-----
 drivers/rtc/class.c                                |  2 +-
 drivers/rtc/lib.c                                  | 24 +++++++++++++++-----
 drivers/thunderbolt/ctl.c                          |  5 +++++
 drivers/tty/serial/jsm/jsm_tty.c                   |  1 +
 drivers/usb/class/usbtmc.c                         |  4 +++-
 drivers/usb/core/quirks.c                          |  3 +++
 drivers/usb/serial/pl2303.c                        |  2 ++
 drivers/usb/storage/unusual_uas.h                  |  7 ++++++
 drivers/usb/typec/ucsi/ucsi.h                      |  2 +-
 fs/orangefs/inode.c                                |  9 ++++----
 kernel/trace/trace.c                               |  2 +-
 27 files changed, 139 insertions(+), 80 deletions(-)


