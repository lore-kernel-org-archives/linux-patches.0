Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82212EB5CE;
	Tue, 17 Jun 2025 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176521; cv=none; b=iteMBqJmNsOTB3aEHE0YLljON4YU5h+BVIWzAbrndGu8Tc7RCQysMFg7eNsrgy0vXm9QqR5ew2ZY27gS/vJHwXabAopnWCqF4fQG3qF3Mw0FRNRWtnYTDIawUITrjKcGppy+RYpD/YX8wbxfiWIYZ1cQkOZ5IcxnFj/JSbfQeeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176521; c=relaxed/simple;
	bh=ZR6/XaJYkrzXRsvpLu2l6cpfvncMxHe0sEXmqHZnm7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9P7N4sQ5esB2zUWi+V3bgW2KCzIapRZt4WybxAkXeTEYeXYJlJzzHV69QjQ+fZSmFtZDfmEefneNm+tdU1cRx0wnZY1AK/NdC/fKWM2Cm+NsegGTZ4s9wPdLYUtfwGIFPTCam6jp8lJnTD/Aiihkvkhshah61XzHle2cv1qVHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/fl2jzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/fl2jzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9E4C4CEE3;
	Tue, 17 Jun 2025 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176521;
	bh=ZR6/XaJYkrzXRsvpLu2l6cpfvncMxHe0sEXmqHZnm7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/fl2jzMNp4Q2khnIKD72Cixxhu3xOS5fPE+pWeJ6tdUU78CkR8RG65xOGNDCMvVF
	 zFhfcT/Pmk4y24lqMWuFOn0mMVPDLPSUo/pJ449NdaFBaAAHq9K997RTHtGTq1xxJY
	 iHoZJOqSzmy5chFuSmrlpat3UZRc4DdMFu77I5Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Bhavya Kapoor <b-kapoor@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/356] arm64: dts: ti: k3-j721e-sk: Add support for multiple CAN instances
Date: Tue, 17 Jun 2025 17:26:40 +0200
Message-ID: <20250617152349.659382890@linuxfoundation.org>
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

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit 021d3d5f0741e5393a7a110ac909fc746b1e0a4d ]

CAN instance 0 in the mcu domain is brought on the J721E-SK board
through header J1. Thus, add its respective transceiver 1 dt node to add
support for this CAN instance.

CAN instances 0, 5 and 9 in the main domain are brought on the J721E-SK
board through headers J5, J6 and J2 respectively. Thus, add their
respective transceivers 2, 3 and 4 dt nodes to add support for these CAN
instances.

Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Reviewed-by: Bhavya Kapoor <b-kapoor@ti.com>
Link: https://lore.kernel.org/r/20240430131512.1327283-1-b-padhi@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: 97b67cc102dc ("arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts | 116 +++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
index d967b384071cf..5e03a7f58faa4 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -210,6 +210,42 @@ vdd_sd_dv_alt: gpio-regulator-tps659411 {
 			 <3300000 0x1>;
 	};
 
+	transceiver1: can-phy1 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&mcu_mcan0_gpio_pins_default>;
+		standby-gpios = <&wkup_gpio0 3 GPIO_ACTIVE_HIGH>;
+	};
+
+	transceiver2: can-phy2 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&main_mcan0_gpio_pins_default>;
+		standby-gpios = <&main_gpio0 65 GPIO_ACTIVE_HIGH>;
+	};
+
+	transceiver3: can-phy3 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&main_mcan5_gpio_pins_default>;
+		standby-gpios = <&main_gpio0 66 GPIO_ACTIVE_HIGH>;
+	};
+
+	transceiver4: can-phy4 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&main_mcan9_gpio_pins_default>;
+		standby-gpios = <&main_gpio0 67 GPIO_ACTIVE_HIGH>;
+	};
+
 	dp_pwr_3v3: fixedregulator-dp-prw {
 		compatible = "regulator-fixed";
 		regulator-name = "dp-pwr";
@@ -367,6 +403,45 @@ J721E_IOPAD(0x164, PIN_OUTPUT, 7) /* (V29) RGMII5_TD2 */
 		>;
 	};
 
+	main_mcan0_pins_default: main-mcan0-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x208, PIN_INPUT, 0) /* (W5) MCAN0_RX */
+			J721E_IOPAD(0x20c, PIN_OUTPUT, 0) /* (W6) MCAN0_TX */
+		>;
+	};
+
+	main_mcan0_gpio_pins_default: main-mcan0-gpio-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x108, PIN_INPUT, 7) /* (AD27) PRG0_PRU1_GPO2.GPIO0_65 */
+		>;
+	};
+
+	main_mcan5_pins_default: main-mcan5-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x050, PIN_INPUT, 6) /* (AE21) PRG1_PRU0_GPO18.MCAN5_RX */
+			J721E_IOPAD(0x04c, PIN_OUTPUT, 6) /* (AJ21) PRG1_PRU0_GPO17.MCAN5_TX */
+		>;
+	};
+
+	main_mcan5_gpio_pins_default: main-mcan5-gpio-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x10c, PIN_INPUT, 7) /* (AC25) PRG0_PRU1_GPO3.GPIO0_66 */
+		>;
+	};
+
+	main_mcan9_pins_default: main-mcan9-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x0d0, PIN_INPUT, 6) /* (AC27) PRG0_PRU0_GPO8.MCAN9_RX */
+			J721E_IOPAD(0x0cc, PIN_OUTPUT, 6) /* (AC28) PRG0_PRU0_GPO7.MCAN9_TX */
+		>;
+	};
+
+	main_mcan9_gpio_pins_default: main-mcan9-gpio-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x110, PIN_INPUT, 7) /* (AD29) PRG0_PRU1_GPO4.GPIO0_67 */
+		>;
+	};
+
 	dp0_pins_default: dp0-default-pins {
 		pinctrl-single,pins = <
 			J721E_IOPAD(0x1c4, PIN_INPUT, 5) /* SPI0_CS1.DP0_HPD */
@@ -549,6 +624,19 @@ J721E_WKUP_IOPAD(0xfc, PIN_INPUT_PULLUP, 0) /* (H24) WKUP_I2C0_SDA */
 		>;
 	};
 
+	mcu_mcan0_pins_default: mcu-mcan0-default-pins {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0x0ac, PIN_INPUT, 0) /* (C29) MCU_MCAN0_RX */
+			J721E_WKUP_IOPAD(0x0a8, PIN_OUTPUT, 0) /* (D29) MCU_MCAN0_TX */
+		>;
+	};
+
+	mcu_mcan0_gpio_pins_default: mcu-mcan0-gpio-default-pins {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0x0bc, PIN_INPUT, 7) /* (F27) WKUP_GPIO0_3 */
+		>;
+	};
+
 	/* Reset for M.2 M Key slot on PCIe1  */
 	mkey_reset_pins_default: mkey-reset-pns-default-pins {
 		pinctrl-single,pins = <
@@ -957,6 +1045,34 @@ &pcie1_rc {
 	num-lanes = <2>;
 };
 
+&mcu_mcan0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcu_mcan0_pins_default>;
+	phys = <&transceiver1>;
+	status = "okay";
+};
+
+&main_mcan0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&main_mcan0_pins_default>;
+	phys = <&transceiver2>;
+	status = "okay";
+};
+
+&main_mcan5 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&main_mcan5_pins_default>;
+	phys = <&transceiver3>;
+	status = "okay";
+};
+
+&main_mcan9 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&main_mcan9_pins_default>;
+	phys = <&transceiver4>;
+	status = "okay";
+};
+
 &ufs_wrapper {
 	status = "disabled";
 };
-- 
2.39.5



