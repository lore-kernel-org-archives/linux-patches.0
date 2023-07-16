Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1378F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43798C433C8;
	Sun, 16 Jul 2023 20:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538358;
	bh=u8Ij9n5Weanp9LhERdntN8g3Zjv/9SHSdsBbWTAcw30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqdzGv81pqFmGFBd9udynO8NCyq1eKOb0hKnfIsGoBInKRIZJVsZYs/yZhXIVTy60
	 5kA6L+Aek0GgR2OvJeggSMTzrbWUqsyPvUPBICYNiLEbBuKHK4aY7PdJdABJ9IETkk
	 ps0br60mQAFnKBc4tc/cTMXBT02GVuz9c4D10q4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thejasvi Konduru <t-konduru@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 395/800] arm64: dts: ti: k3-j784s4: Fix wakeup pinmux range and pinctrl node offsets
Date: Sun, 16 Jul 2023 21:44:08 +0200
Message-ID: <20230716194958.245808047@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thejasvi Konduru <t-konduru@ti.com>

[ Upstream commit 14462bd0b247d05070d48d0f02eb7ca2680ab7bd ]

The wkup_pmx register region in j784s4 has multiple non-addressable
regions, hence the existing wkup_pmx region is split as follows to
avoid the non-addressable regions. The pinctrl node offsets are
also corrected as per the newly split wkup_pmx* nodes.

wkup_pmx0 -> 13 pins (WKUP_PADCONFIG 0 - 12)
wkup_pmx1 -> 11 pins (WKUP_PADCONFIG 14 - 24)
wkup_pmx2 -> 72 pins (WKUP_PADCONFIG 26 - 97)
wkup_pmx3 -> 1 pin (WKUP_PADCONFIG 100)

Fixes: 4664ebd8346a ("arm64: dts: ti: Add initial support for J784S4 SoC")
Signed-off-by: Thejasvi Konduru <t-konduru@ti.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20230503083143.32369-1-t-konduru@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-evm.dts      | 30 +++++++++----------
 .../boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi     | 29 +++++++++++++++++-
 2 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts b/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
index e8e007e4a7d4f..34e9bc89ac663 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
@@ -141,28 +141,28 @@ J784S4_IOPAD(0x020, PIN_INPUT, 7) /* (AJ35) MCAN15_RX.GPIO0_8 */
 	};
 };
 
-&wkup_pmx0 {
+&wkup_pmx2 {
 	mcu_cpsw_pins_default: mcu-cpsw-pins-default {
 		pinctrl-single,pins = <
-			J784S4_WKUP_IOPAD(0x094, PIN_INPUT, 0) /* (A35) MCU_RGMII1_RD0 */
-			J784S4_WKUP_IOPAD(0x090, PIN_INPUT, 0) /* (B36) MCU_RGMII1_RD1 */
-			J784S4_WKUP_IOPAD(0x08c, PIN_INPUT, 0) /* (C36) MCU_RGMII1_RD2 */
-			J784S4_WKUP_IOPAD(0x088, PIN_INPUT, 0) /* (D36) MCU_RGMII1_RD3 */
-			J784S4_WKUP_IOPAD(0x084, PIN_INPUT, 0) /* (B37) MCU_RGMII1_RXC */
-			J784S4_WKUP_IOPAD(0x06c, PIN_INPUT, 0) /* (C37) MCU_RGMII1_RX_CTL */
-			J784S4_WKUP_IOPAD(0x07c, PIN_OUTPUT, 0) /* (D37) MCU_RGMII1_TD0 */
-			J784S4_WKUP_IOPAD(0x078, PIN_OUTPUT, 0) /* (D38) MCU_RGMII1_TD1 */
-			J784S4_WKUP_IOPAD(0x074, PIN_OUTPUT, 0) /* (E37) MCU_RGMII1_TD2 */
-			J784S4_WKUP_IOPAD(0x070, PIN_OUTPUT, 0) /* (E38) MCU_RGMII1_TD3 */
-			J784S4_WKUP_IOPAD(0x080, PIN_OUTPUT, 0) /* (E36) MCU_RGMII1_TXC */
-			J784S4_WKUP_IOPAD(0x068, PIN_OUTPUT, 0) /* (C38) MCU_RGMII1_TX_CTL */
+			J784S4_WKUP_IOPAD(0x02c, PIN_INPUT, 0) /* (A35) MCU_RGMII1_RD0 */
+			J784S4_WKUP_IOPAD(0x028, PIN_INPUT, 0) /* (B36) MCU_RGMII1_RD1 */
+			J784S4_WKUP_IOPAD(0x024, PIN_INPUT, 0) /* (C36) MCU_RGMII1_RD2 */
+			J784S4_WKUP_IOPAD(0x020, PIN_INPUT, 0) /* (D36) MCU_RGMII1_RD3 */
+			J784S4_WKUP_IOPAD(0x01c, PIN_INPUT, 0) /* (B37) MCU_RGMII1_RXC */
+			J784S4_WKUP_IOPAD(0x004, PIN_INPUT, 0) /* (C37) MCU_RGMII1_RX_CTL */
+			J784S4_WKUP_IOPAD(0x014, PIN_OUTPUT, 0) /* (D37) MCU_RGMII1_TD0 */
+			J784S4_WKUP_IOPAD(0x010, PIN_OUTPUT, 0) /* (D38) MCU_RGMII1_TD1 */
+			J784S4_WKUP_IOPAD(0x00c, PIN_OUTPUT, 0) /* (E37) MCU_RGMII1_TD2 */
+			J784S4_WKUP_IOPAD(0x008, PIN_OUTPUT, 0) /* (E38) MCU_RGMII1_TD3 */
+			J784S4_WKUP_IOPAD(0x018, PIN_OUTPUT, 0) /* (E36) MCU_RGMII1_TXC */
+			J784S4_WKUP_IOPAD(0x000, PIN_OUTPUT, 0) /* (C38) MCU_RGMII1_TX_CTL */
 		>;
 	};
 
 	mcu_mdio_pins_default: mcu-mdio-pins-default {
 		pinctrl-single,pins = <
-			J784S4_WKUP_IOPAD(0x09c, PIN_OUTPUT, 0) /* (A36) MCU_MDIO0_MDC */
-			J784S4_WKUP_IOPAD(0x098, PIN_INPUT, 0) /* (B35) MCU_MDIO0_MDIO */
+			J784S4_WKUP_IOPAD(0x034, PIN_OUTPUT, 0) /* (A36) MCU_MDIO0_MDC */
+			J784S4_WKUP_IOPAD(0x030, PIN_INPUT, 0) /* (B35) MCU_MDIO0_MDIO */
 		>;
 	};
 };
diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi
index f04fcb614cbe4..ed2b40369c59a 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi
@@ -50,7 +50,34 @@ mcu_ram: sram@41c00000 {
 	wkup_pmx0: pinctrl@4301c000 {
 		compatible = "pinctrl-single";
 		/* Proxy 0 addressing */
-		reg = <0x00 0x4301c000 0x00 0x178>;
+		reg = <0x00 0x4301c000 0x00 0x034>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx1: pinctrl@4301c038 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c038 0x00 0x02c>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx2: pinctrl@4301c068 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c068 0x00 0x120>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx3: pinctrl@4301c190 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c190 0x00 0x004>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
-- 
2.39.2



