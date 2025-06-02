Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC111DE2CC;
	Mon,  2 Jun 2025 13:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872165; cv=none; b=OscrunBSOSbUXH6RA5Ji3hc1FqI7/DkU7ZE8WD23bQAgGmVpsIzL/VdPK18jPMwk0TmRS9sOKDU8nFuzStxrFyTyJ9YAq3Mkx8fYNg7xp0Q5ZmyhbRTP1beGTX4Nl7sfG0bUXSdEMF9wq3W1QlzVIUdik4PGItXHYKhrGR5UvJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872165; c=relaxed/simple;
	bh=9BRhHLHwHfZnsOdrUuyLODNLgJjqs+HEmZVk+lD4POc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rDaMgu9PFm3gEbUO4sbc4rU+3GEGpsuHC0QTxkpX3X0OeuqMzwIaMYyJXu2xCBLZQdJp2pHj9Sd9db6G3VegsdyO3eLCNEBdZPR2cWpNcw5fFHIN3/OMP8KnC4xnlo2nBE7OzETEr8nx0HqkXjMDatkkM3pG3ogPGxaG4mCwlR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft+XXN3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft+XXN3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC06C4CEEB;
	Mon,  2 Jun 2025 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872165;
	bh=9BRhHLHwHfZnsOdrUuyLODNLgJjqs+HEmZVk+lD4POc=;
	h=From:To:Cc:Subject:Date:From;
	b=Ft+XXN3d6TGYPn7nutOnWXqfgREajGnatoo1AqJ2DGDYXwu0oBb3aJaoev52+sFB8
	 bDgkhKWd6ykVnV5HxONHQnPUNrUwwn30thsEHLxJpwvrl/Z92+dMJY1/yY9x2dZuKZ
	 Yog1hrkjV1k0OkR3vMTcEfboHeyEQ0U9SUJPOyIg=
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
Subject: [PATCH 6.15 00/49] 6.15.1-rc1 review
Date: Mon,  2 Jun 2025 15:46:52 +0200
Message-ID: <20250602134237.940995114@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.15.1-rc1
X-KernelTest-Deadline: 2025-06-04T13:42+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.15.1 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.15.1-rc1

Robin Murphy <robin.murphy@arm.com>
    iommu: Handle yet another race around registration

Robin Murphy <robin.murphy@arm.com>
    iommu: Avoid introducing more races

Christian Brauner <brauner@kernel.org>
    coredump: hand a pidfd to the usermode coredump helper

Christian Brauner <brauner@kernel.org>
    coredump: fix error handling for replace_fd()

Christian Brauner <brauner@kernel.org>
    pidfs: move O_RDWR into pidfs_alloc_file()

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

Sebastian Reichel <sebastian.reichel@collabora.com>
    arm64: dts: rockchip: Add missing SFC power-domains to rk3576

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    arm64: dts: rockchip: fix internal USB hub instability on RK3399 Puma

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    arm64: dts: socfpga: agilex5: fix gpio0 address


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
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   2 +
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
 drivers/iommu/iommu.c                              |  34 ++-
 drivers/perf/arm-cmn.c                             |  11 +-
 fs/coredump.c                                      |  65 ++++-
 fs/pidfs.c                                         |   1 +
 include/linux/coredump.h                           |   1 +
 include/linux/iommu.h                              |   2 +
 net/sched/sch_hfsc.c                               |   9 +-
 37 files changed, 447 insertions(+), 440 deletions(-)


