Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BBD1F8EEF;
	Sat,  7 Jun 2025 10:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290882; cv=none; b=WYYPVZeHfPbJ5IMcWloeTGRi3CKv2Ry16X/L0p6p1coHEiCkGdGF0r75ROtLhs5A8lJ+1blqstNrT7YiqIVyxYAqr0oxpkcbZ3sYfAkMU98qgMeEiaMZW6eyKg++7E4QAM5PDsY8srKzcMsKVge8o5klRZX3J558EVpWpqo1jhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290882; c=relaxed/simple;
	bh=gQ6iv10a9cPNS0DPkw3ffaAWdV4vG5Dqs5WyLu8qM/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HeybKE8kKMQPMF8HPusuqii5IAqBA9AaRHT4z8KWouG4YxSmTzY/a9uRgheeM0A8qhp8NvRg8EGJauplX13qM7pM9Nuyel25GBiowmjvOQZFCIF8IrMFcT8VsSlLvl4PN51jO27xqIuNPDMYzMf49xqCkq41u53JvabZbDJCdzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTaGcSNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTaGcSNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751BCC4CEE4;
	Sat,  7 Jun 2025 10:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290882;
	bh=gQ6iv10a9cPNS0DPkw3ffaAWdV4vG5Dqs5WyLu8qM/I=;
	h=From:To:Cc:Subject:Date:From;
	b=VTaGcSNycN/XVa23jHO3GGfmByUEGY8KeUprqjyjEj9b3u21pbasbH2Z48Egl/gS2
	 kbZZagfFvMtqxkiN8ln3SmrVP/RtYU6LHj43IDBOv9yxMA46T0Ti+0XAsVcNOcTuTx
	 gO6UrIJd1fLtfwS+Ah/zUfsrwxNzxuC5vt71pPu4=
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
Subject: [PATCH 6.12 00/24] 6.12.33-rc1 review
Date: Sat,  7 Jun 2025 12:07:31 +0200
Message-ID: <20250607100717.910797456@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.33-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.33-rc1
X-KernelTest-Deadline: 2025-06-09T10:07+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.33 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.33-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.33-rc1

Aurabindo Pillai <aurabindo.pillai@amd.com>
    Revert "drm/amd/display: more liberal vmin/vmax update for freesync"

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: phy: imx8mq-usb: fix fsl,phy-tx-vboost-level-microvolt property

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    dt-bindings: usb: cypress,hx3: Add support for all variants

Sergey Senozhatsky <senozhatsky@chromium.org>
    thunderbolt: Do not double dequeue a configuration request

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix timeout value in get_stb

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

Jon Hunter <jonathanh@nvidia.com>
    Revert "cpufreq: tegra186: Share policy per cluster"

Ming Lei <ming.lei@redhat.com>
    block: fix adding folio to bio

Ajay Agarwal <ajayagarwal@google.com>
    PCI/ASPM: Disable L1 before disabling L1 PM Substates

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Update power island delays

Maciej Falkowski <maciej.falkowski@linux.intel.com>
    accel/ivpu: Add initial Panther Lake support

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Fix offset calculation for .start_secs < 0

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Make rtc_time64_to_tm() support dates before 1970

Sakari Ailus <sakari.ailus@linux.intel.com>
    Documentation: ACPI: Use all-string data node references

Gautham R. Shenoy <gautham.shenoy@amd.com>
    acpi-cpufreq: Fix nominal_freq units to KHz in get_max_boost_ratio()

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: set GPIO output value before setting direction

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: use correct OUTPUT_VAL register for GPIOs > 31

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid accessing uninitialized curseg

Pan Taixi <pantaixi@huaweicloud.com>
    tracing: Fix compilation warning on arm32


-------------

Diffstat:

 .../bindings/phy/fsl,imx8mq-usb-phy.yaml           |  3 +-
 .../devicetree/bindings/usb/cypress,hx3.yaml       | 19 ++++-
 .../acpi/dsd/data-node-references.rst              | 26 +++---
 Documentation/firmware-guide/acpi/dsd/graph.rst    | 11 +--
 Documentation/firmware-guide/acpi/dsd/leds.rst     |  7 +-
 Makefile                                           |  4 +-
 block/bio.c                                        | 11 ++-
 drivers/accel/ivpu/ivpu_drv.c                      |  1 +
 drivers/accel/ivpu/ivpu_drv.h                      | 10 ++-
 drivers/accel/ivpu/ivpu_fw.c                       |  3 +
 drivers/accel/ivpu/ivpu_hw_40xx_reg.h              |  2 +
 drivers/accel/ivpu/ivpu_hw_ip.c                    | 49 +++++++----
 drivers/bluetooth/hci_qca.c                        | 14 ++--
 drivers/cpufreq/acpi-cpufreq.c                     |  2 +-
 drivers/cpufreq/tegra186-cpufreq.c                 |  7 --
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 16 ++--
 drivers/pci/pcie/aspm.c                            | 94 ++++++++++++----------
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        | 14 ++--
 drivers/rtc/class.c                                |  2 +-
 drivers/rtc/lib.c                                  | 24 ++++--
 drivers/thunderbolt/ctl.c                          |  5 ++
 drivers/tty/serial/jsm/jsm_tty.c                   |  1 +
 drivers/usb/class/usbtmc.c                         |  4 +-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/serial/pl2303.c                        |  2 +
 drivers/usb/storage/unusual_uas.h                  |  7 ++
 drivers/usb/typec/ucsi/ucsi.h                      |  2 +-
 fs/f2fs/inode.c                                    |  7 ++
 fs/f2fs/segment.h                                  |  9 ++-
 kernel/trace/trace.c                               |  2 +-
 30 files changed, 218 insertions(+), 143 deletions(-)


