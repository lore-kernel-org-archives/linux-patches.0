Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0342576;
	Mon,  2 Jun 2025 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872687; cv=none; b=iLZPSDZYyu9j6vTq+1B8O1N1hCgifOCgGiab91x+zLjMU2v3tU/pi3f+juzaZwvfB2OipZFgmxyO7cWrZPPrgfnQm+TmovwYPaCE7WjRYUnfBAC3OGKnk3YdEHE4ofbbU1KjBs6mQtzM/G+BY6OiBiwp/RhtDufDnxhIeFJXNNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872687; c=relaxed/simple;
	bh=nMnXKUuATEpZG42axsJNs3TRyx84YhSz4x5QUxN5ErA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VCuVsAboDpuumPDNQ0kbyom0MwI/wfksXVVbN2JcoQWsp0pnizVqhWhO4U0W3wyXHCy+NTIKqBTVE9HxRCEbkAK0+tVEsHGSvkkWel71HlJnExshvJKsiOC0ZTjQZqt6WjjYrzmAiSG9l8OHDML7eyECboH5amOCwzfA7resQjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A64e2kVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A64e2kVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C95C4CEEB;
	Mon,  2 Jun 2025 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872687;
	bh=nMnXKUuATEpZG42axsJNs3TRyx84YhSz4x5QUxN5ErA=;
	h=From:To:Cc:Subject:Date:From;
	b=A64e2kVPYU58b398EBGVdIHjXlGv1kjI+NI/qvvva/NebVunVBd4mLR4p05UFL0+D
	 QvF0EP5E0vcJAHRAq5YqnBLe+Q4RPE87kQTUqZxG0MooMLrGM7AFq8XAIhvg8EqnyO
	 AY96tpOHLRxB89WD/O6cv8R4ASmPr1aUwmQilcO0=
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
Subject: [PATCH 6.14 00/73] 6.14.10-rc1 review
Date: Mon,  2 Jun 2025 15:46:46 +0200
Message-ID: <20250602134241.673490006@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.14.10-rc1
X-KernelTest-Deadline: 2025-06-04T13:42+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.14.10 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.14.10-rc1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use list_first_entry_or_null for opinfo_get_list()

Nishanth Menon <nm@ti.com>
    net: ethernet: ti: am65-cpsw: Lower random mac address error print to info

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Ignore battery threshold change event notification

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - restore auto-mute mode for Dell Chrome platform

Valtteri Koskivuori <vkoskiv@gmail.com>
    platform/x86: fujitsu-laptop: Support Lifebook S2110 hotkeys

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid flushing data while holding directory locks in nfs_rename()

Purva Yeshi <purvayeshi550@gmail.com>
    char: tpm: tpm-buf: Add sanity check fallback in read helpers

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/xe: Save the gt pointer in lrc and drop the tile

Aradhya Bhatia <aradhya.bhatia@intel.com>
    drm/xe/xe2hpg: Add Wa_22021007897

Ilya Guterman <amfernusus@gmail.com>
    nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro

Alan Adamson <alan.adamson@oracle.com>
    nvme: all namespaces in a subsystem must adhere to a common atomic write size

Alessandro Grassi <alessandro.grassi@mailbox.org>
    spi: spi-sun4i: fix early activation

Algea Cao <algea.cao@rock-chips.com>
    phy: phy-rockchip-samsung-hdptx: Fix PHY PLL output 50.25MHz error

Hal Feng <hal.feng@starfivetech.com>
    phy: starfive: jh7110-usb: Fix USB 2.0 host occasional detection failure

Alan Adamson <alan.adamson@oracle.com>
    nvme: multipath: enable BLK_FEAT_ATOMIC_WRITES for multipathing

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: check stream id dml21 wrapper to get plane_id

George Shen <george.shen@amd.com>
    drm/amd/display: fix link_set_dpms_off multi-display MST corner case

Markus Burri <markus.burri@mt.com>
    gpio: virtuser: fix potential out-of-bound write

Damien Le Moal <dlemoal@kernel.org>
    nvmet: pci-epf: cleanup nvmet_pci_epf_raise_irq()

Masahiro Yamada <masahiroy@kernel.org>
    um: let 'make clean' properly clean underlying SUBARCH as well

Sami Tolvanen <samitolvanen@google.com>
    kbuild: Require pahole <v1.28 or >v1.29 with GENDWARFKSYMS on X86

John Chau <johnchau@0atlas.com>
    platform/x86: thinkpad_acpi: Support also NEC Lavie X1475JAS

Jeff Layton <jlayton@kernel.org>
    nfs: don't share pNFS DS connections between net namespaces

Milton Barrera <miltonjosue2001@gmail.com>
    HID: quirks: Add ADATA XPG alpha wireless mouse support

Mario Limonciello <mario.limonciello@amd.com>
    HID: amd_sfh: Avoid clearing reports for SRA sensor

Purva Yeshi <purvayeshi550@gmail.com>
    dmaengine: idxd: cdev: Fix uninitialized use of sva in idxd_cdev_open

Christian Brauner <brauner@kernel.org>
    coredump: hand a pidfd to the usermode coredump helper

Christian Brauner <brauner@kernel.org>
    coredump: fix error handling for replace_fd()

Robin Murphy <robin.murphy@arm.com>
    iommu: Handle yet another race around registration

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Add CMN S3 ACPI binding

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Initialise cmn->cpu earlier

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Fix REQ2/SNP2 mixup

Pedro Tammela <pctammela@mojatatu.com>
    net_sched: hfsc: Address reentrant enqueue adding class to eltree twice

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-j784s4-j742s2-main-common: Fix length of serdes_ln_ctrl

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-j722s-main: Disable "serdes_wiz0" and "serdes_wiz1"

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-j722s-evm: Enable "serdes_wiz0" and "serdes_wiz1"

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-j721e-sk: Add requiried voltage supplies for IMX219

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-j721e-sk: Remove clock-names property from IMX219 overlay

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-am68-sk: Fix regulator hierarchy

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-am62x: Rename I2C switch to I2C mux in OV5640 overlay

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-am62x: Rename I2C switch to I2C mux in IMX219 overlay

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-am62x: Remove clock-names property from IMX219 overlay

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62p-j722s-common-main: Set eMMC clock parent to default

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62a-main: Set eMMC clock parent to default

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-main: Set eMMC clock parent to default

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100: Fix PCIe 3rd controller DBI size

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100: Add GPU cooling

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100: Apply consistent critical thermal shutdown

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100: Fix video thermal zone

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-yoga-slim7x: mark l12b and l15b always-on

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-qcp: mark l12b and l15b always-on

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-qcp: Fix vreg_l2j_1p2 voltage

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-lenovo-yoga-slim7x: Fix vreg_l2j_1p2 voltage

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-hp-x14: mark l12b and l15b always-on

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-hp-omnibook-x14: Fix vreg_l2j_1p2 voltage

Juerg Haefliger <juerg.haefliger@canonical.com>
    arm64: dts: qcom: x1e80100-hp-omnibook-x14: Enable SMB2360 0 and 1

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-dell-xps13-9345: mark l12b and l15b always-on

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100-asus-vivobook-s15: Fix vreg_l2j_1p2 voltage

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e001de-devkit: mark l12b and l15b always-on

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e001de-devkit: Fix vreg_l2j_1p2 voltage

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sm8650: Add missing properties for cryptobam

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sm8550: Add missing properties for cryptobam

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sm8450: Add missing properties for cryptobam

Alok Tiwari <alok.a.tiwari@oracle.com>
    arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node

Karthik Sanagavarapu <quic_kartsana@quicinc.com>
    arm64: dts: qcom: sa8775p: Remove cdsp compute-cb@10

Ling Xu <quic_lxu5@quicinc.com>
    arm64: dts: qcom: sa8775p: Remove extra entries from the iommus property

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sa8775p: Add missing properties for cryptobam

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: ipq9574: Add missing properties for cryptobam

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    arm64: dts: rockchip: fix internal USB hub instability on RK3399 Puma

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    arm64: dts: socfpga: agilex5: fix gpio0 address

Axel Forsman <axfo@kvaser.com>
    can: kvaser_pciefd: Force IRQ edge in case of nested IRQ


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi     |   4 +-
 arch/arm64/boot/dts/qcom/ipq9574.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sa8775p.dtsi              | 248 ++---------------
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts       |   6 +-
 .../boot/dts/qcom/x1e80100-asus-vivobook-s15.dts   |   4 +-
 .../boot/dts/qcom/x1e80100-dell-xps13-9345.dts     |   2 +
 .../boot/dts/qcom/x1e80100-hp-omnibook-x14.dts     |  14 +-
 .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |   7 +-
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   6 +-
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             | 309 +++++++++++----------
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |  40 ++-
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   2 -
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   2 -
 .../boot/dts/ti/k3-am62p-j722s-common-main.dtsi    |   2 -
 .../arm64/boot/dts/ti/k3-am62x-sk-csi2-imx219.dtso |   3 +-
 .../arm64/boot/dts/ti/k3-am62x-sk-csi2-ov5640.dtso |   2 +-
 .../boot/dts/ti/k3-am62x-sk-csi2-tevi-ov5640.dtso  |   2 +-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   2 +
 arch/arm64/boot/dts/ti/k3-am68-sk-base-board.dts   |  13 +-
 .../boot/dts/ti/k3-j721e-sk-csi2-dual-imx219.dtso  |  35 ++-
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             |  31 +++
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts            |   8 +
 arch/arm64/boot/dts/ti/k3-j722s-main.dtsi          |   4 +
 .../boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi  |   2 +-
 arch/um/Makefile                                   |   1 +
 drivers/char/tpm/tpm-buf.c                         |   6 +-
 drivers/dma/idxd/cdev.c                            |   4 +-
 drivers/gpio/gpio-virtuser.c                       |  12 +-
 .../dc/dml2/dml21/dml21_translation_helper.c       |  20 +-
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |  13 +-
 drivers/gpu/drm/xe/regs/xe_gt_regs.h               |   1 +
 drivers/gpu/drm/xe/xe_lrc.c                        |   4 +-
 drivers/gpu/drm/xe/xe_lrc_types.h                  |   4 +-
 drivers/gpu/drm/xe/xe_wa.c                         |   4 +
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |   5 +
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/iommu/iommu.c                              |  26 +-
 drivers/net/can/kvaser_pciefd.c                    |  83 +++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/nvme/host/core.c                           |  30 +-
 drivers/nvme/host/multipath.c                      |   3 +-
 drivers/nvme/host/nvme.h                           |   3 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/pci-epf.c                      |  10 +-
 drivers/perf/arm-cmn.c                             |  11 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |   2 +
 drivers/phy/starfive/phy-jh7110-usb.c              |   7 +
 drivers/platform/x86/fujitsu-laptop.c              |  33 ++-
 drivers/platform/x86/thinkpad_acpi.c               |   7 +
 drivers/spi/spi-sun4i.c                            |   5 +-
 fs/coredump.c                                      |  65 ++++-
 fs/nfs/client.c                                    |   2 +
 fs/nfs/dir.c                                       |  15 +-
 fs/nfs/filelayout/filelayoutdev.c                  |   6 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/pnfs.h                                      |   4 +-
 fs/nfs/pnfs_nfs.c                                  |   9 +-
 fs/smb/server/oplock.c                             |   7 +-
 include/linux/coredump.h                           |   1 +
 include/linux/iommu.h                              |   2 +
 include/linux/nfs_fs_sb.h                          |  12 +-
 kernel/module/Kconfig                              |   5 +
 net/sched/sch_hfsc.c                               |   9 +-
 sound/pci/hda/patch_realtek.c                      |   5 +-
 70 files changed, 674 insertions(+), 540 deletions(-)


