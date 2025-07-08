Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041702DECC4;
	Tue,  8 Jul 2025 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992962; cv=none; b=hjAVUOG5ZIeC6G/QVntWSx/0k5O61sOxp9k6nxEqxzkurRyutBfjba5isl4rgR6lJSTN3TRRXcu3M4bW+5ZzL/MY89XqVVQ3EZw60kVNDZwdS5JLA680UN4lVAzEzWNdnlgnw6qfops+BO6jjO1vpfmT7Mk6IDWtogcChpj/G1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992962; c=relaxed/simple;
	bh=sFEzJNaxQo/7Me9dEYjWVgFFGH9UYNb74oW5vuLeRCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UENsznenDJfSQrXtxJexqtQKgglyz2B0NoRYRL49Hna46IAR6OEB+DaptihxIzjYHL44eenOb/oYq6kGcP73HHum/pOEwnJfb7SAR5WRuVfqPM2NQcGUrpSD9/3cdYszjCJfchIAS4o4kPKSlIWY/mcQOIoIhktDXJ4Zf+OHvjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTLeLDFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTLeLDFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3471AC4CEED;
	Tue,  8 Jul 2025 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992961;
	bh=sFEzJNaxQo/7Me9dEYjWVgFFGH9UYNb74oW5vuLeRCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTLeLDFrpyjZNlhxcs0N1XbGAVUTEmdVKnncCc6aThdBDy6jtluPoeGKr3weIZ4UW
	 5zeg5iB5dxDF4lIE0U6VaH7Bolgl0d15lRA8LorKmk9rYeQjemI4M3qTw1hyZ670do
	 +fI4OjlLxNiIDI99E0nlVmmtQza9YqQNYlnRssus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/232] arm64: dts: renesas: Factor out White Hawk Single board support
Date: Tue,  8 Jul 2025 18:22:17 +0200
Message-ID: <20250708162245.133562663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d43c077cb88d800d0c2a372d70d5af75c6a16356 ]

Move the common parts for the Renesas White Hawk Single board to
white-hawk-single.dtsi, to enable future reuse.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/1661743b18a9ff9fac716f98a663b39fc8488d7e.1733156661.git.geert+renesas@glider.be
Stable-dep-of: 8ffec7d62c69 ("arm64: dts: renesas: white-hawk-single: Improve Ethernet TSN description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../renesas/r8a779g2-white-hawk-single.dts    | 62 +---------------
 .../boot/dts/renesas/white-hawk-single.dtsi   | 73 +++++++++++++++++++
 2 files changed, 74 insertions(+), 61 deletions(-)
 create mode 100644 arch/arm64/boot/dts/renesas/white-hawk-single.dtsi

diff --git a/arch/arm64/boot/dts/renesas/r8a779g2-white-hawk-single.dts b/arch/arm64/boot/dts/renesas/r8a779g2-white-hawk-single.dts
index 0062362b0ba06..48befde389376 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g2-white-hawk-single.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779g2-white-hawk-single.dts
@@ -7,70 +7,10 @@
 
 /dts-v1/;
 #include "r8a779g2.dtsi"
-#include "white-hawk-cpu-common.dtsi"
-#include "white-hawk-common.dtsi"
+#include "white-hawk-single.dtsi"
 
 / {
 	model = "Renesas White Hawk Single board based on r8a779g2";
 	compatible = "renesas,white-hawk-single", "renesas,r8a779g2",
 		     "renesas,r8a779g0";
 };
-
-&hscif0 {
-	uart-has-rtscts;
-};
-
-&hscif0_pins {
-	groups = "hscif0_data", "hscif0_ctrl";
-	function = "hscif0";
-};
-
-&pfc {
-	tsn0_pins: tsn0 {
-		mux {
-			groups = "tsn0_link", "tsn0_mdio", "tsn0_rgmii",
-				 "tsn0_txcrefclk";
-			function = "tsn0";
-		};
-
-		link {
-			groups = "tsn0_link";
-			bias-disable;
-		};
-
-		mdio {
-			groups = "tsn0_mdio";
-			drive-strength = <24>;
-			bias-disable;
-		};
-
-		rgmii {
-			groups = "tsn0_rgmii";
-			drive-strength = <24>;
-			bias-disable;
-		};
-	};
-};
-
-&tsn0 {
-	pinctrl-0 = <&tsn0_pins>;
-	pinctrl-names = "default";
-	phy-mode = "rgmii";
-	phy-handle = <&phy3>;
-	status = "okay";
-
-	mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		reset-gpios = <&gpio1 23 GPIO_ACTIVE_LOW>;
-		reset-post-delay-us = <4000>;
-
-		phy3: ethernet-phy@0 {
-			compatible = "ethernet-phy-id002b.0980",
-				     "ethernet-phy-ieee802.3-c22";
-			reg = <0>;
-			interrupts-extended = <&gpio4 3 IRQ_TYPE_LEVEL_LOW>;
-		};
-	};
-};
diff --git a/arch/arm64/boot/dts/renesas/white-hawk-single.dtsi b/arch/arm64/boot/dts/renesas/white-hawk-single.dtsi
new file mode 100644
index 0000000000000..20e8232f2f323
--- /dev/null
+++ b/arch/arm64/boot/dts/renesas/white-hawk-single.dtsi
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/*
+ * Device Tree Source for the White Hawk Single board
+ *
+ * Copyright (C) 2023-2024 Glider bv
+ */
+
+#include "white-hawk-cpu-common.dtsi"
+#include "white-hawk-common.dtsi"
+
+/ {
+	model = "Renesas White Hawk Single board";
+	compatible = "renesas,white-hawk-single";
+};
+
+&hscif0 {
+	uart-has-rtscts;
+};
+
+&hscif0_pins {
+	groups = "hscif0_data", "hscif0_ctrl";
+	function = "hscif0";
+};
+
+&pfc {
+	tsn0_pins: tsn0 {
+		mux {
+			groups = "tsn0_link", "tsn0_mdio", "tsn0_rgmii",
+				 "tsn0_txcrefclk";
+			function = "tsn0";
+		};
+
+		link {
+			groups = "tsn0_link";
+			bias-disable;
+		};
+
+		mdio {
+			groups = "tsn0_mdio";
+			drive-strength = <24>;
+			bias-disable;
+		};
+
+		rgmii {
+			groups = "tsn0_rgmii";
+			drive-strength = <24>;
+			bias-disable;
+		};
+	};
+};
+
+&tsn0 {
+	pinctrl-0 = <&tsn0_pins>;
+	pinctrl-names = "default";
+	phy-mode = "rgmii";
+	phy-handle = <&phy3>;
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		reset-gpios = <&gpio1 23 GPIO_ACTIVE_LOW>;
+		reset-post-delay-us = <4000>;
+
+		phy3: ethernet-phy@0 {
+			compatible = "ethernet-phy-id002b.0980",
+				     "ethernet-phy-ieee802.3-c22";
+			reg = <0>;
+			interrupts-extended = <&gpio4 3 IRQ_TYPE_LEVEL_LOW>;
+		};
+	};
+};
-- 
2.39.5



