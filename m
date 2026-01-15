Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77E4274B43;
	Thu, 15 Jan 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496199; cv=none; b=ddLz8logad1YgMGs5itZ3Bjd/YEUOEx4OAG6NZOkhq0+8sbrsWzsJSwExEc+PTp5UwcmcUz2NQCiX59f8LNZVFvE45u7VgRQglpT2Z/2viZAhRb7Rfx8vR4YK+RvbaAbA1ihg3FSjNSMtyXtM2/Cv555qFpU6ozKKEUf44N6DCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496199; c=relaxed/simple;
	bh=yjO07nObxFmrrgswHfLENexGrVtPN0pDLKwsA3WWny0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjlLs83KXrT5feaOyVbUUQLfQd3gs6ign+YAGtBQagQZNTyVwXc58UW4/wEKQX6FKFA1HjUQjw6qbdBkaKnK0yhUejXmb7aTaP8lHWQlhTgBwPnvE2e9JFahTp1vlFvzk8KipWY+oqBaAaDRAIaaAAQ4bt2GMIUrf6MIONHTWNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8N9gQ+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8N9gQ+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CC3C116D0;
	Thu, 15 Jan 2026 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496198;
	bh=yjO07nObxFmrrgswHfLENexGrVtPN0pDLKwsA3WWny0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8N9gQ+fGHrbBbs5w8aMDTV4X4XvB0Qcx/e6GoGDnh0YyhHJyOJ5wGJrCh/o9G5wt
	 UJ85ko2kUjSEqdcIcMfk3d4IiMODpcMg4S71wzEuj4lBaL3ugxSWCOm9ZVEOtB9j1S
	 iYLf0kJe3dtK4xOlOvBAm8UDCTiqJxgIksHhE2ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/181] arm64: dts: ti: k3-am642-phyboard-electra-x27-gpio1-spi1-uart3: Fix schema warnings
Date: Thu, 15 Jan 2026 17:46:47 +0100
Message-ID: <20260115164204.851443974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Wadim Egorov <w.egorov@phytec.de>

[ Upstream commit d876bb9353d87dee0ae620300106e8def189c785 ]

Rename pinctrl nodes to comply with naming conventions required by
pinctrl-single schema. Also, replace invalid integer assignment in
SPI node with a boolean to align with omap-spi schema.

Fixes: 638ab30ce4c6 ("arm64: dts: ti: am64-phyboard-electra: Add DT overlay for X27 connector")
Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20251127122733.2523367-2-w.egorov@phytec.de
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../k3-am642-phyboard-electra-x27-gpio1-spi1-uart3.dtso   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-x27-gpio1-spi1-uart3.dtso b/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-x27-gpio1-spi1-uart3.dtso
index 996c42ec4253e..bea8efa3e9094 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-x27-gpio1-spi1-uart3.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-x27-gpio1-spi1-uart3.dtso
@@ -20,13 +20,13 @@
 };
 
 &main_pmx0 {
-	main_gpio1_exp_header_gpio_pins_default: main-gpio1-exp-header-gpio-pins-default {
+	main_gpio1_exp_header_gpio_pins_default: main-gpio1-exp-header-gpio-default-pins {
 		pinctrl-single,pins = <
 			AM64X_IOPAD(0x0220, PIN_INPUT, 7)	/* (D14) SPI1_CS1.GPIO1_48 */
 		>;
 	};
 
-	main_spi1_pins_default: main-spi1-pins-default {
+	main_spi1_pins_default: main-spi1-default-pins {
 		pinctrl-single,pins = <
 			AM64X_IOPAD(0x0224, PIN_INPUT, 0)	/* (C14) SPI1_CLK */
 			AM64X_IOPAD(0x021C, PIN_OUTPUT, 0)	/* (B14) SPI1_CS0 */
@@ -35,7 +35,7 @@
 		>;
 	};
 
-	main_uart3_pins_default: main-uart3-pins-default {
+	main_uart3_pins_default: main-uart3-default-pins {
 		pinctrl-single,pins = <
 			AM64X_IOPAD(0x0048, PIN_INPUT, 2)       /* (U20) GPMC0_AD3.UART3_RXD */
 			AM64X_IOPAD(0x004c, PIN_OUTPUT, 2)      /* (U18) GPMC0_AD4.UART3_TXD */
@@ -52,7 +52,7 @@
 &main_spi1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_spi1_pins_default>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 	status = "okay";
 };
 
-- 
2.51.0



