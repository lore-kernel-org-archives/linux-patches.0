Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4FE1779BD;
	Fri, 27 Sep 2024 12:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439883; cv=none; b=unQawbNdp/Xf6+ag6jbitMBQuiYTLXEsku10n2TqtHJ7eJ3ZeRN9Cd4otv8nJPlwHnXhc1Mh8Jm05PZKeWi/CmbEdpFatIooS5NBH435wbmsRgJOHsjrQUYw9fq9Mgpiv56281cv+GaAui54omcAhmIqmFXlnVDFREVcg+D5wVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439883; c=relaxed/simple;
	bh=Ra2iSzl5+YL+QRzGfdRAIhKQTe20Rlh7LlXazJQpJWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H2AU4jklroMaeWPzdPgv0bXU3D2hpO+bWciHSw0cjBC2/BQoyIifZxIYndlgcgOX0KZabm8Q/8GtfH69RqRDq/omSc879UkNRLRAjlNUswu1J/OU4jEDqmuJzbRPng4fVGTcEVp8QdauV4Xap3OkcuqjB9pzs81Yj1m75FzJoIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ay7eqnEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ay7eqnEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7E1C4CEC4;
	Fri, 27 Sep 2024 12:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439883;
	bh=Ra2iSzl5+YL+QRzGfdRAIhKQTe20Rlh7LlXazJQpJWg=;
	h=From:To:Cc:Subject:Date:From;
	b=Ay7eqnEfsIhIkJVuybsLmhuPOS7h/lEJEpxUZKPK4wlj+ur7GXqGQOt+p35NZgIpu
	 4OY+GJkXkzcl9vF/PqH2MqAmUPsW72oIPZNxL7LCKybhw0n3TKybiA6YL+GdScSrnH
	 UgjFqXt6T5tmeJSdhz67MrZgoMJsNNQ/w/GB9LTo=
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
Subject: [PATCH 6.6 00/54] 6.6.53-rc1 review
Date: Fri, 27 Sep 2024 14:22:52 +0200
Message-ID: <20240927121719.714627278@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.53-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.53-rc1
X-KernelTest-Deadline: 2024-09-29T12:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.53 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.53-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.53-rc1

Edward Adam Davis <eadavis@qq.com>
    USB: usbtmc: prevent kernel-usb-infoleak

Junhao Xie <bigfoot@classfun.cn>
    USB: serial: pl2303: add device id for Macrosilicon MS3020

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: move mcp251xfd_timestamp_start()/stop() into mcp251xfd_chip_start/stop()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: properly indent labels

Tony Luck <tony.luck@intel.com>
    x86/mm: Switch to new Intel CPU model defines

Keith Busch <kbusch@kernel.org>
    nvme-pci: qdepth 1 quirk

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: Ignore reconfiguration without direction

Ping-Ke Shih <pkshih@realtek.com>
    Revert "wifi: cfg80211: check wiphy mutex is held for wdev mutex"

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: missing iterator type in lookup walk

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: walk over current view on netlink dump

Dan Carpenter <dan.carpenter@linaro.org>
    netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: make cgroupsv2 matching work with namespaces

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

Hongyu Jin <hongyu.jin@unisoc.com>
    block: Fix where bio IO priority gets set

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    tools: hv: rm .*.cmd when make clean

Michael Kelley <mhklinux@outlook.com>
    x86/hyperv: Set X86_FEATURE_TSC_KNOWN_FREQ when Hyper-V provides frequency

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix hang in wait_for_response() for negproto

Liao Chen <liaochen4@huawei.com>
    spi: bcm63xx: Enable module autoloading

hongchi.peng <hongchi.peng@siengine.com>
    drm: komeda: Fix an issue related to normalized zpos

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: add HDMI codec ID for Intel PTL

Markuss Broks <markuss.broks@gmail.com>
    ASoC: amd: yc: Add a quirk for MSI Bravo 17 (D7VEK)

Fabio Estevam <festevam@gmail.com>
    spi: spidev: Add an entry for elgin,jg10309-01

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

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Define ARCH_IRQ_INIT_FLAGS as IRQ_NOPROBE

Jacky Chou <jacky_chou@aspeedtech.com>
    net: ftgmac100: Ensure tx descriptor updates are visible

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Make Lenovo Yoga Tab 3 X90F DMI match less strict

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
 arch/loongarch/kernel/irq.c                        |   3 -
 arch/microblaze/mm/init.c                          |   5 -
 arch/x86/kernel/cpu/mshyperv.c                     |   1 +
 arch/x86/mm/init.c                                 |  16 ++-
 block/blk-core.c                                   |  10 ++
 block/blk-mq.c                                     |  10 --
 drivers/accel/drm_accel.c                          | 110 ++-------------------
 drivers/gpio/gpiolib-cdev.c                        |  12 ++-
 drivers/gpu/drm/arm/display/komeda/komeda_kms.c    |  10 +-
 drivers/gpu/drm/drm_drv.c                          |  97 +++++++++---------
 drivers/gpu/drm/drm_file.c                         |   2 +-
 drivers/gpu/drm/drm_internal.h                     |   4 -
 drivers/hwmon/asus-ec-sensors.c                    |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  42 ++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  14 ++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   2 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |   7 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   1 +
 drivers/net/ethernet/faraday/ftgmac100.c           |  26 +++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  31 +++---
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   3 +-
 drivers/nvme/host/nvme.h                           |   5 +
 drivers/nvme/host/pci.c                            |  18 ++--
 drivers/pinctrl/pinctrl-at91.c                     |   5 +-
 drivers/platform/x86/x86-android-tablets/dmi.c     |   1 -
 drivers/powercap/intel_rapl_common.c               |   1 +
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
 include/net/netfilter/nf_tables.h                  |  13 +++
 net/mac80211/tx.c                                  |   4 +-
 net/netfilter/nf_tables_api.c                      |   5 +
 net/netfilter/nft_lookup.c                         |   1 +
 net/netfilter/nft_set_pipapo.c                     |   6 +-
 net/netfilter/nft_socket.c                         |  41 +++++++-
 net/wireless/core.h                                |   8 +-
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
 sound/soc/sof/mediatek/mt8195/mt8195.c             |   3 +
 tools/hv/Makefile                                  |   2 +-
 64 files changed, 384 insertions(+), 331 deletions(-)


