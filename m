Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A521B340D9D;
	Sat, 12 Sep 2026 10:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208308; cv=none; b=hQE2ifqF5pRjl24T+yF7DLBpDuG/Dd/zGh6Zw+50fp5F3YEeCDr+pmIW4WMLxO3B+06+5QXxg2u5C3Nv+dD3ik2mYma3Qa1/kAy4eIfn37kHl+dKr8siUgfT/V+TYO7xbyu3mmHb45YzpyzBTRt7RIV6DSWFytkvTtbadfm1EOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208308; c=relaxed/simple;
	bh=3xEoP5lMfy4EWFSVpNBfwY5VYuLzv9uuuEk+UEqaZJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B71rn9fwWBWYXhYbA8EGflLKX/VVxQKn6dneAQ+jwFtVVvLs4A813n4vpXTI2QWD9ZCLXtc7ha7LM2BUJ4fUAMdPDMk93TgFzsIMT3rpeNazKEUpwdbotkVujmvwlemEsWDX1xZ2RD8Hip1G6hlPehTuZ915s2fx5uW/H2JlK40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O9QQmL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O9QQmL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DEA1F000FF;
	Sat, 12 Sep 2026 10:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208306;
	bh=zyGh7x01t8l0/VjEWS+nAS75/hYgeM8F7yVGjFw6Wz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1O9QQmL40PQkjGsBG6op5l0AELW2eDuzYB0weeBOkc16L0uTn4iVganbMMC23hjAV
	 E7fxEAZBqEbqmjdudDvnX2+hev5NUa8ptn/kto55wilhA6JhBwKhosTt0EO91YPt5b
	 LSPvY4NgqJq0n/X1e2l/NEiFIE4zhKYRarB3iRjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Opdenacker <michael.opdenacker@rootcommit.com>,
	Yixun Lan <dlan@gentoo.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0554/1518] riscv: dts: spacemit: Add OrangePi R2S board device tree
Date: Sat, 12 Sep 2026 08:45:23 +0200
Message-ID: <20260912065635.971062495@linuxfoundation.org>
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

From: Michael Opdenacker <michael.opdenacker@rootcommit.com>

[ Upstream commit 63e572b11464a233f45ad469ba64b8b9e68a9cd1 ]

Add initial device tree support for the OrangePi RV2 board [1], which is
marketed as using the Ky X1 SoC but is identical in die and package
to the SpacemiT K1 SoC [2].

Enable UART0, to boot into a serial console

Two Gigabit Ethernet ports with RGMII interface standard support
are enabled, each port is connected to an external
Motorcomm YT8531C PHY chip which uses the GPIO for reset control.

Enable PDMA.

Enable 8 GB eMMC chip for storage.

Link: http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-R2S.html [1]
Link: https://www.spacemit.com/en/key-stone-k1 [2]
Signed-off-by: Michael Opdenacker <michael.opdenacker@rootcommit.com>
Reviewed-by: Yixun Lan <dlan@gentoo.org>
Link: https://lore.kernel.org/r/20251112044426.2351999-3-michael.opdenacker@rootcommit.com
Signed-off-by: Yixun Lan <dlan@gentoo.org>
Stable-dep-of: 8270311d70fd ("riscv: dts: spacemit: k1: Split gmac_clk_ref into independent pinctrl groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/Makefile         |  1 +
 .../boot/dts/spacemit/k1-orangepi-r2s.dts     | 90 +++++++++++++++++++
 2 files changed, 91 insertions(+)
 create mode 100644 arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts

diff --git a/arch/riscv/boot/dts/spacemit/Makefile b/arch/riscv/boot/dts/spacemit/Makefile
index 942ecb38bea03..95889e7269d1b 100644
--- a/arch/riscv/boot/dts/spacemit/Makefile
+++ b/arch/riscv/boot/dts/spacemit/Makefile
@@ -2,4 +2,5 @@
 dtb-$(CONFIG_ARCH_SPACEMIT) += k1-bananapi-f3.dtb
 dtb-$(CONFIG_ARCH_SPACEMIT) += k1-milkv-jupiter.dtb
 dtb-$(CONFIG_ARCH_SPACEMIT) += k1-musepi-pro.dtb
+dtb-$(CONFIG_ARCH_SPACEMIT) += k1-orangepi-r2s.dtb
 dtb-$(CONFIG_ARCH_SPACEMIT) += k1-orangepi-rv2.dtb
diff --git a/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts b/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts
new file mode 100644
index 0000000000000..58098c4a2aabd
--- /dev/null
+++ b/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright (C) 2025 Michael Opdenacker <michael.opdenacker@rootcommit.com>
+ */
+
+/dts-v1/;
+
+#include "k1.dtsi"
+#include "k1-pinctrl.dtsi"
+
+/ {
+	model = "OrangePi R2S";
+	compatible = "xunlong,orangepi-r2s", "spacemit,k1";
+
+	aliases {
+		serial0 = &uart0;
+		ethernet0 = &eth0;
+		ethernet1 = &eth1;
+	};
+
+	chosen {
+		stdout-path = "serial0";
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
+	pinctrl-names = "default";
+	pinctrl-0 = <&gmac0_cfg>;
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
+&eth1 {
+	phy-handle = <&rgmii1>;
+	phy-mode = "rgmii-id";
+	pinctrl-names = "default";
+	pinctrl-0 = <&gmac1_cfg>;
+	rx-internal-delay-ps = <0>;
+	tx-internal-delay-ps = <250>;
+	status = "okay";
+
+	mdio-bus {
+		#address-cells = <0x1>;
+		#size-cells = <0x0>;
+
+		reset-gpios = <&gpio K1_GPIO(115) GPIO_ACTIVE_LOW>;
+		reset-delay-us = <10000>;
+		reset-post-delay-us = <100000>;
+
+		rgmii1: phy@1 {
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
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_2_cfg>;
+	status = "okay";
+};
-- 
2.53.0



