Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203AC3DBD5E;
	Sat, 12 Sep 2026 10:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208253; cv=none; b=Xw28err4DMcWrCPbIipfF9M4MNXasGfOi2MncuFJ6e/3LsJF5BRhDglfmPoj6b8CULWLkPzwnn7kMjdCu592TLrVzuM7vVhlOE58UIeyJF+oCl/hEfTYxMYqAT8hn9GJsAqlqxGhQfNgk+dx7/ITmXe60C9ZUZeruDBw1CMnf4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208253; c=relaxed/simple;
	bh=sGtjEhUBpI2z9VaALcncST6+IqDYs7bXy2d0MywFec4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw0dH/njV3ExAyZXG1Bx1JzX8aDuT5HyWUsyYJs5vXCrVt82PDeW5+eQkmt0LoipjEh6TA/Y93l80heSvNyrMp79Ai5UEkMYQLO9ZIX7BOPwsPGeoRTXk04u3YxXYHVSwfZb0d0sdI2hcJjzA9U1CBuUSQuIfv298NsA9YJLcwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zz1SsTFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zz1SsTFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9511F000FF;
	Sat, 12 Sep 2026 10:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208251;
	bh=5iTdBztczicCiTjj94mSJIH0S7fQlDtztmbPPWJMgoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zz1SsTFJufkfvc2QCmIBYvmQllkUsxU2rQCc31nmdGxKlOYM2D2n16kAhixwnxxyg
	 izEd0I5wJhXb6uh5eDvdt/X7BdIHN2S2E+hLoUDM7g567UA/Rt4uufbasnNJ61IaCI
	 Vu/EIuIR2RoXBFIbh/lWSsqxiHLZgsVfzNLDmokg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Yixun Lan <dlan@gentoo.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0553/1518] riscv: dts: spacemit: add MusePi Pro board device tree
Date: Sat, 12 Sep 2026 08:45:22 +0200
Message-ID: <20260912065635.948081921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 0ee59934662dfb89b43a8392e64ac4880c2fca88 ]

Add initial device tree support for the MusePi Pro board [1].
The board is using the SpacemiT K1/M1 SoC.

This device tree is adapted from the SpacemiT vendor tree [2] and
enables basic board functionality, including UART console, LED, eMMC,
Ethernet, and PDMA.

Link: https://developer.spacemit.com/documentation?token=YJtdwnvvViPVcmkoPDpcvwfVnrh&type=pdf [1]
Link: https://gitee.com/bianbu-linux/linux-6.6/blob/k1-bl-v2.2.y/arch/riscv/boot/dts/spacemit/k1-x_MUSE-Pi-Pro.dts [2]
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Link: https://lore.kernel.org/r/20251023-k1-musepi-pro-dts-v4-2-01836303e10f@linux.spacemit.com
Signed-off-by: Yixun Lan <dlan@gentoo.org>
Stable-dep-of: 8270311d70fd ("riscv: dts: spacemit: k1: Split gmac_clk_ref into independent pinctrl groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/Makefile         |  1 +
 .../riscv/boot/dts/spacemit/k1-musepi-pro.dts | 79 +++++++++++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts

diff --git a/arch/riscv/boot/dts/spacemit/Makefile b/arch/riscv/boot/dts/spacemit/Makefile
index 1528326448706..942ecb38bea03 100644
--- a/arch/riscv/boot/dts/spacemit/Makefile
+++ b/arch/riscv/boot/dts/spacemit/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 dtb-$(CONFIG_ARCH_SPACEMIT) += k1-bananapi-f3.dtb
 dtb-$(CONFIG_ARCH_SPACEMIT) += k1-milkv-jupiter.dtb
+dtb-$(CONFIG_ARCH_SPACEMIT) += k1-musepi-pro.dtb
 dtb-$(CONFIG_ARCH_SPACEMIT) += k1-orangepi-rv2.dtb
diff --git a/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts b/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
new file mode 100644
index 0000000000000..29e333b670cf0
--- /dev/null
+++ b/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright (C) 2024 Yangyu Chen <cyy@cyyself.name>
+ * Copyright (C) 2025 SpacemiT, Inc
+ * Copyright (C) 2025 Troy Mitchell <troy.mitchell@linux.spacemit.com>
+ */
+
+/dts-v1/;
+
+#include "k1.dtsi"
+#include "k1-pinctrl.dtsi"
+
+/ {
+	model = "SpacemiT MusePi Pro";
+	compatible = "spacemit,musepi-pro", "spacemit,k1";
+
+	aliases {
+		ethernet0 = &eth0;
+		serial0 = &uart0;
+	};
+
+	chosen {
+		stdout-path = "serial0";
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		led1 {
+			label = "sys-led";
+			gpios = <&gpio K1_GPIO(96) GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "heartbeat";
+			default-state = "on";
+		};
+	};
+};
+
+&emmc {
+	bus-width = <8>;
+	mmc-hs400-1_8v;
+	mmc-hs400-enhanced-strobe;
+	non-removable;
+	no-sd;
+	no-sdio;
+	status = "okay";
+};
+
+&eth0 {
+	phy-handle = <&rgmii0>;
+	phy-mode = "rgmii-id";
+	pinctrl-0 = <&gmac0_cfg>;
+	pinctrl-names = "default";
+	rx-internal-delay-ps = <0>;
+	tx-internal-delay-ps = <0>;
+	status = "okay";
+
+	mdio-bus {
+		#address-cells = <0x1>;
+		#size-cells = <0x0>;
+
+		reset-gpios = <&gpio K1_GPIO(110) GPIO_ACTIVE_LOW>;
+		reset-delay-us = <10000>;
+		reset-post-delay-us = <100000>;
+
+		rgmii0: phy@1 {
+			reg = <0x1>;
+		};
+	};
+};
+
+&pdma {
+	status = "okay";
+};
+
+&uart0 {
+	pinctrl-0 = <&uart0_2_cfg>;
+	pinctrl-names = "default";
+	status = "okay";
+};
-- 
2.53.0



