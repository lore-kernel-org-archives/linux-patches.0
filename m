Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7780C17B515;
	Fri, 27 Sep 2024 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440078; cv=none; b=FnUwMJy97DeA4VZoQKLpg1HAcDMsrqUNfMRe2GviYxrSQwHC0vLyYo5beTUYH5tE6qsEQvkGvv0WTSJQ0iPVj9mz/D2UZUEkZjNh1t4dlVdNe1SI3kBnr0brHNAULOwyuYhZE+WavLTSkShtkguNAi+1JHTRLaHQaggEh2hfwIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440078; c=relaxed/simple;
	bh=RrPwdkbMT+9TMbPMe4Te+DVlw2cdVvTMg5yQq47rSPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eVc1vF81TfeMBn5GNMMofB7B0SyNt6QpWIP9DxCVP/XaA9FBzucNZd2bBwpcoeNimczq/wNz9xN6glfn8c2Dk0njCTkgXfjdISIq7ikwflE2JR4KYzfUPImpxAO0wBzHqySn44Z3YEyYtkPisS3KRYclrPPdSfm46kcb0cegtSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYpFAsW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYpFAsW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6E4C4CEC4;
	Fri, 27 Sep 2024 12:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440078;
	bh=RrPwdkbMT+9TMbPMe4Te+DVlw2cdVvTMg5yQq47rSPc=;
	h=From:To:Cc:Subject:Date:From;
	b=YYpFAsW6nOkCGU6LGuYIP2SbWbS+vLBfYNKPNR+oFaT81XR0wl1qI5aS/CN3CRIIs
	 w03dogKiLfFX7/uZOFz0bsAnXUILrHt16yzyeZiHU182CMSVjAkpzOy1ZfG1oD1Qle
	 wavrAxEzeKKsCSu1liWHJaCWLTfD5CIuv1iTP7lY=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.10 00/58] 6.10.12-rc1 review
Date: Fri, 27 Sep 2024 14:23:02 +0200
Message-ID: <20240927121718.789211866@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.10.12-rc1
X-KernelTest-Deadline: 2024-09-29T12:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.10.12 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.10.12-rc1

Edward Adam Davis <eadavis@qq.com>
    USB: usbtmc: prevent kernel-usb-infoleak

Junhao Xie <bigfoot@classfun.cn>
    USB: serial: pl2303: add device id for Macrosilicon MS3020

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: move mcp251xfd_timestamp_start()/stop() into mcp251xfd_chip_start/stop()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: properly indent labels

Keith Busch <kbusch@kernel.org>
    nvme-pci: qdepth 1 quirk

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Allocate memory for driver private data

Dan Carpenter <dan.carpenter@linaro.org>
    netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: make cgroupsv2 matching work with namespaces

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    powercap/intel_rapl: Fix the energy-pkg event for AMD CPUs

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    powercap/intel_rapl: Add support for AMD family 1Ah

Michał Winiarski <michal.winiarski@intel.com>
    drm: Expand max DRM device number to full MINORBITS

Michał Winiarski <michal.winiarski@intel.com>
    accel: Use XArray instead of IDR for minors

Michał Winiarski <michal.winiarski@intel.com>
    drm: Use XArray instead of IDR for minors

Ferry Meng <mengferry@linux.alibaba.com>
    ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()

Ferry Meng <mengferry@linux.alibaba.com>
    ocfs2: add bounds checking to ocfs2_xattr_find_entry()

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: spidev: Add missing spi_device_id for jg10309-01

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: fix the pp_dpm_pcie issue on smu v14.0.2/3

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools: hv: rm .*.cmd when make clean

Michael Kelley <mhklinux@outlook.com>
    x86/hyperv: Set X86_FEATURE_TSC_KNOWN_FREQ when Hyper-V provides frequency

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: check for XDP rings instead of bpf program when unconfiguring

Luke D. Jones <luke@ljones.dev>
    platform/x86/amd: pmf: Make ASUS GA403 quirk generic

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix hang in wait_for_response() for negproto

Liao Chen <liaochen4@huawei.com>
    spi: bcm63xx: Enable module autoloading

hongchi.peng <hongchi.peng@siengine.com>
    drm: komeda: Fix an issue related to normalized zpos

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: add HDMI codec ID for Intel PTL

Neil Armstrong <neil.armstrong@linaro.org>
    clk: qcom: gcc-sm8650: Don't use shared clk_ops for QUPs

Markuss Broks <markuss.broks@gmail.com>
    ASoC: amd: yc: Add a quirk for MSI Bravo 17 (D7VEK)

Fabio Estevam <festevam@gmail.com>
    spi: spidev: Add an entry for elgin,jg10309-01

Zhang Yi <zhangyi@everest-semi.com>
    ASoC: mediatek: mt8188-mt6359: Modify key

Liao Chen <liaochen4@huawei.com>
    ASoC: fix module autoloading

Liao Chen <liaochen4@huawei.com>
    ASoC: tda7419: fix module autoloading

Liao Chen <liaochen4@huawei.com>
    ASoC: google: fix module autoloading

Liao Chen <liaochen4@huawei.com>
    ASoC: intel: fix module autoloading

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: soc-acpi-cht: Make Lenovo Yoga Tab 3 X90F DMI match less strict

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_ring_init(): check TX-coalescing configuration

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: Limit coalescing to peripheral instances

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: clear trans->state earlier upon error

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: mac80211: free skb on error path in ieee80211_beacon_get_ap()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't wait for tx queues if firmware is dead

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: pause TCM when the firmware is stopped

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: fix iwl_mvm_max_scan_ie_fw_cmd_room()

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: fix iwl_mvm_scan_fits() calculation

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: lower message level for FW buffer destination

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Invalidate guest steal time address on vCPU reset

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Define ARCH_IRQ_INIT_FLAGS as IRQ_NOPROBE

Jacky Chou <jacky_chou@aspeedtech.com>
    net: ftgmac100: Ensure tx descriptor updates are visible

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Make Lenovo Yoga Tab 3 X90F DMI match less strict

Mathieu Fenniak <mathieu@fenniak.net>
    platform/x86: asus-wmi: Fix spurious rfkill on UX8406MA

Mike Rapoport <rppt@kernel.org>
    microblaze: don't treat zero reserved memory regions as error

Ross Brown <true.robot.ross@gmail.com>
    hwmon: (asus-ec-sensors) remove VRM temp X570-E GAMING

Thomas Blocher <thomas.blocher@ek-dev.de>
    pinctrl: at91: make it work with current gpiolib

Sherry Yang <sherry.yang@oracle.com>
    scsi: lpfc: Fix overflow build issue

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - FIxed ALC285 headphone no sound

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed ALC256 headphone no sound

Hongbo Li <lihongbo22@huawei.com>
    ASoC: allow module autoloading for table board_ids

Hongbo Li <lihongbo22@huawei.com>
    ASoC: allow module autoloading for table db1200_pids

YR Yang <yr.yang@mediatek.com>
    ASoC: mediatek: mt8188: Mark AFE_DAC_CON0 register as volatile

Albert Jakieła <jakiela@google.com>
    ASoC: SOF: mediatek: Add missing board compatible


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/loongarch/include/asm/hw_irq.h                |   2 +
 arch/loongarch/include/asm/kvm_vcpu.h              |   1 -
 arch/loongarch/kernel/irq.c                        |   3 -
 arch/loongarch/kvm/timer.c                         |   7 --
 arch/loongarch/kvm/vcpu.c                          |   2 +-
 arch/microblaze/mm/init.c                          |   5 -
 arch/x86/kernel/cpu/mshyperv.c                     |   1 +
 drivers/accel/drm_accel.c                          | 110 ++-------------------
 drivers/bluetooth/btintel_pcie.c                   |   2 +-
 drivers/clk/qcom/gcc-sm8650.c                      |  56 +++++------
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |   3 +
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c    |  10 +-
 drivers/gpu/drm/drm_drv.c                          |  97 +++++++++---------
 drivers/gpu/drm/drm_file.c                         |   2 +-
 drivers/gpu/drm/drm_internal.h                     |   4 -
 drivers/hwmon/asus-ec-sensors.c                    |   2 +-
 drivers/net/can/m_can/m_can.c                      |  16 +--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  42 ++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  14 ++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   2 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |   7 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   1 +
 drivers/net/ethernet/faraday/ftgmac100.c           |  26 +++--
 drivers/net/ethernet/intel/ice/ice_lib.c           |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  31 +++---
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   3 +-
 drivers/nvme/host/nvme.h                           |   5 +
 drivers/nvme/host/pci.c                            |  18 ++--
 drivers/pinctrl/pinctrl-at91.c                     |   5 +-
 drivers/platform/x86/amd/pmf/pmf-quirks.c          |   2 +-
 drivers/platform/x86/asus-nb-wmi.c                 |  20 +++-
 drivers/platform/x86/asus-wmi.h                    |   1 +
 drivers/platform/x86/x86-android-tablets/dmi.c     |   1 -
 drivers/powercap/intel_rapl_common.c               |  35 ++++++-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   2 +-
 drivers/spi/spi-bcm63xx.c                          |   1 +
 drivers/spi/spidev.c                               |   2 +
 drivers/usb/class/usbtmc.c                         |   2 +-
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   4 +
 fs/ocfs2/xattr.c                                   |  27 +++--
 fs/smb/client/connect.c                            |  14 ++-
 include/drm/drm_accel.h                            |  18 +---
 include/drm/drm_file.h                             |   5 +
 net/mac80211/tx.c                                  |   4 +-
 net/netfilter/nft_socket.c                         |  41 +++++++-
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/pci/hda/patch_realtek.c                      |  76 +++++++++-----
 sound/soc/amd/acp/acp-sof-mach.c                   |   2 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 ++
 sound/soc/au1x/db1200.c                            |   1 +
 sound/soc/codecs/chv3-codec.c                      |   1 +
 sound/soc/codecs/tda7419.c                         |   1 +
 sound/soc/google/chv3-i2s.c                        |   1 +
 sound/soc/intel/common/soc-acpi-intel-cht-match.c  |   1 -
 sound/soc/intel/keembay/kmb_platform.c             |   1 +
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c         |   1 +
 sound/soc/mediatek/mt8188/mt8188-mt6359.c          |  17 +++-
 sound/soc/sof/mediatek/mt8195/mt8195.c             |   3 +
 tools/hv/Makefile                                  |   2 +-
 69 files changed, 450 insertions(+), 359 deletions(-)


