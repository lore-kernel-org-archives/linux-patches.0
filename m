Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A63A237162;
	Tue, 17 Jun 2025 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176708; cv=none; b=pCfQAKFeoMYWIsmViMmyleFVO9UM/k/upUQ7q+LbMD2KI1P2lYT3qQE3zt5d8PyXTpuckIx1yEW7SoHn32x5CFQ4lfIpqXLDV1PbUZpfezNijFkQrTIHqGBQV4EaHX11CqFb/K1aWVPWIt2GwF38gXnlMGJks9ij+lCk1zNqS6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176708; c=relaxed/simple;
	bh=n/+VfxFcfcn3Hrf6HuLc0Y3S+WWT/On9G0vQLQXMVU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJrUFeZdUZ8SThgtDLyGdRKOul/0IFLizz6oUEsL9IdlwDTXkc9ndcKIg7JJN0aevuBAHndMgrxY+O4RMG3+WOkbT++wp85ujco3g3NUBpuGlP6loxdAGIJkHUWYySFypXpVgfwdpnHn05PkWaMLY21JVJvNzQ8WKFrQYUH/Cr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avFTQQ/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avFTQQ/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A003DC4CEE3;
	Tue, 17 Jun 2025 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176708;
	bh=n/+VfxFcfcn3Hrf6HuLc0Y3S+WWT/On9G0vQLQXMVU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avFTQQ/T3G+kobA9dfWpdKTOuFqSYZYgvz5Y+2fV5pPZ8hG8YP3d00ZktnHBPoxTV
	 QXYk0CTSEpUOdr3455dab0yMTqTlkZ27Sc+LaJdDe91G9SszSg82ViJa8j9ewSaKSA
	 L+yjrzyjEL9pQg2gVHaR/rKDGHhhaJGQvQH2Kn+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/356] arm64: dts: ti: k3-j721e-sk: Model CSI2RX connector mux
Date: Tue, 17 Jun 2025 17:26:39 +0200
Message-ID: <20250617152349.620551373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaishnav Achath <vaishnav.a@ti.com>

[ Upstream commit f87c88947396674586a42a163b72efa3999e3dee ]

J721E SK has the CSI2RX routed to a MIPI CSI connector and to 15-pin
RPi camera connector through an analog mux with GPIO control, model that
so that an overlay can control the mux state according to connected
cameras. Also provide labels to the I2C mux bus instances so that a
generic overlay can be used across multiple platforms.

J721E SK schematics: https://www.ti.com/lit/zip/sprr438

Signed-off-by: Vaishnav Achath <vaishnav.a@ti.com>
Reviewed-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240215085518.552692-6-vaishnav.a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: 97b67cc102dc ("arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
index ccacb65683b5b..d967b384071cf 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -286,6 +286,15 @@ tfp410_out: endpoint {
 			};
 		};
 	};
+
+	csi_mux: mux-controller {
+		compatible = "gpio-mux";
+		#mux-state-cells = <1>;
+		mux-gpios = <&main_gpio0 88 GPIO_ACTIVE_HIGH>;
+		idle-state = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&main_csi_mux_sel_pins_default>;
+	};
 };
 
 &main_pmx0 {
@@ -352,6 +361,12 @@ J721E_IOPAD(0x214, PIN_OUTPUT, 4) /* (V4) MCAN1_TX.USB1_DRVVBUS */
 		>;
 	};
 
+	main_csi_mux_sel_pins_default: main-csi-mux-sel-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x164, PIN_OUTPUT, 7) /* (V29) RGMII5_TD2 */
+		>;
+	};
+
 	dp0_pins_default: dp0-default-pins {
 		pinctrl-single,pins = <
 			J721E_IOPAD(0x1c4, PIN_INPUT, 5) /* SPI0_CS1.DP0_HPD */
@@ -707,14 +722,14 @@ i2c-mux@70 {
 		reg = <0x70>;
 
 		/* CSI0 I2C */
-		i2c@0 {
+		cam0_i2c: i2c@0 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0>;
 		};
 
 		/* CSI1 I2C */
-		i2c@1 {
+		cam1_i2c: i2c@1 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <1>;
-- 
2.39.5



