Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229AB15D1;
	Sat,  7 Jun 2025 10:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291074; cv=none; b=HIPw+PmLiAymiekw4Bb2LGx317gq+0IkTrosBY7en86tJypnD5S8zYgnmPA6UknajzBu/qQDZV1bmA3TuLF5RClrAijytZyXV+RF99sDASKyOKQ5/arkdotA+9k4yq4kn2GyRXk/uzM59vF/YhwUHxmPbBymJt7+jVIfNLi78wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291074; c=relaxed/simple;
	bh=CFlhZNHjyPqlGOUHEMsbtBUtnLVMDYM9nigDlV7KrsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PFiL6RegxGEvbywVTYjSG7KKM+CbOV3NCCB7d1AfLpfwXBGXdPcqvbYSoeq9d7MsmF6F8GfkE2ETy6xfyD6EcL/2Ng8XOAi8/HHnz94S54FPRcGb80ja9rV1V2IKiF+eKZZ/jDyC4c0ofaX0TNtEeQIa54bqj8kX8uvT6Qs8fow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVnaDFht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVnaDFht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73611C4CEE4;
	Sat,  7 Jun 2025 10:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291074;
	bh=CFlhZNHjyPqlGOUHEMsbtBUtnLVMDYM9nigDlV7KrsY=;
	h=From:To:Cc:Subject:Date:From;
	b=mVnaDFht0m/2wRkoD0b40p1cfl4EGbv2TXYXsoDiXkP+A6HA9JaJ+i36PJNZSbcPz
	 wiTwP7mYm7awBtgvJR0CcmFNqkYUDc5Wj/pyrrS43aArlgWL7s7u4Jw9NIt8D4iV44
	 XGXmHl4pCV8wCGaUnqYWrp7DlkGr38ksKWtHUABs=
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
Subject: [PATCH 6.15 00/34] 6.15.2-rc1 review
Date: Sat,  7 Jun 2025 12:07:41 +0200
Message-ID: <20250607100719.711372213@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.15.2-rc1
X-KernelTest-Deadline: 2025-06-09T10:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.15.2 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.15.2-rc1

Aurabindo Pillai <aurabindo.pillai@amd.com>
    Revert "drm/amd/display: more liberal vmin/vmax update for freesync"

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: phy: imx8mq-usb: fix fsl,phy-tx-vboost-level-microvolt property

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    dt-bindings: usb: cypress,hx3: Add support for all variants

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: remoteproc: qcom,sm8150-pas: Add missing SC8180X compatible

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

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Fix subvol to missing root repair

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Run may_delete_deleted_inode() checks in bch2_inode_rm()

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: delete dead code from may_delete_deleted_inode()

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Repair code for directory i_size

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Kill un-reverted directory i_size code

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Fix offset calculation for .start_secs < 0

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Make rtc_time64_to_tm() support dates before 1970

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    pinctrl: mediatek: eint: Fix invalid pointer dereference for v1 platforms

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

Ahmed Salem <x0rw3ll@gmail.com>
    ACPICA: Apply ACPI_NONSTRING in more places

Kees Cook <kees@kernel.org>
    ACPICA: Apply ACPI_NONSTRING

Kees Cook <kees@kernel.org>
    ACPICA: Introduce ACPI_NONSTRING

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "x86/smp: Eliminate mwait_play_dead_cpuid_hint()"

Pan Taixi <pantaixi@huaweicloud.com>
    tracing: Fix compilation warning on arm32


-------------

Diffstat:

 .../bindings/phy/fsl,imx8mq-usb-phy.yaml           |  3 +-
 .../devicetree/bindings/pwm/adi,axi-pwmgen.yaml    | 13 +++-
 .../bindings/remoteproc/qcom,sm8150-pas.yaml       |  3 +
 .../devicetree/bindings/usb/cypress,hx3.yaml       | 19 +++++-
 .../acpi/dsd/data-node-references.rst              | 26 ++++----
 Documentation/firmware-guide/acpi/dsd/graph.rst    | 11 ++--
 Documentation/firmware-guide/acpi/dsd/leds.rst     |  7 +-
 Makefile                                           |  4 +-
 arch/x86/kernel/smpboot.c                          | 54 +++++++++++++--
 drivers/acpi/acpica/acdebug.h                      |  2 +-
 drivers/acpi/acpica/aclocal.h                      |  4 +-
 drivers/acpi/acpica/nsnames.c                      |  2 +-
 drivers/acpi/acpica/nsrepair2.c                    |  2 +-
 drivers/android/binder.c                           | 16 ++++-
 drivers/android/binder_internal.h                  |  8 ++-
 drivers/android/binderfs.c                         |  2 +-
 drivers/bluetooth/hci_qca.c                        | 14 ++--
 drivers/clk/samsung/clk-exynosautov920.c           |  2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 16 ++---
 drivers/nvmem/Kconfig                              |  1 +
 drivers/pinctrl/mediatek/mtk-eint.c                | 26 ++++----
 drivers/pinctrl/mediatek/mtk-eint.h                |  5 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |  2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |  2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        | 14 ++--
 drivers/rtc/class.c                                |  2 +-
 drivers/rtc/lib.c                                  | 24 +++++--
 drivers/thunderbolt/ctl.c                          |  5 ++
 drivers/tty/serial/jsm/jsm_tty.c                   |  1 +
 drivers/usb/class/usbtmc.c                         |  4 +-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/serial/pl2303.c                        |  2 +
 drivers/usb/storage/unusual_uas.h                  |  7 ++
 drivers/usb/typec/ucsi/ucsi.h                      |  2 +-
 fs/bcachefs/dirent.c                               | 12 +---
 fs/bcachefs/dirent.h                               |  4 +-
 fs/bcachefs/errcode.h                              |  2 +
 fs/bcachefs/fs.c                                   |  8 ++-
 fs/bcachefs/fsck.c                                 |  8 +++
 fs/bcachefs/inode.c                                | 77 ++++++++++++++--------
 fs/bcachefs/namei.c                                |  4 +-
 fs/bcachefs/sb-errors_format.h                     |  4 +-
 fs/bcachefs/subvolume.c                            | 19 ++++--
 include/acpi/actbl.h                               |  6 +-
 include/acpi/actypes.h                             |  4 ++
 include/acpi/platform/acgcc.h                      |  8 +++
 kernel/trace/trace.c                               |  2 +-
 .../acpi/os_specific/service_layers/oslinuxtbl.c   |  2 +-
 tools/power/acpi/tools/acpidump/apfiles.c          |  2 +-
 50 files changed, 314 insertions(+), 158 deletions(-)


