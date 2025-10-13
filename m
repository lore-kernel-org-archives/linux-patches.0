Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883F123F294;
	Mon, 13 Oct 2025 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369118; cv=none; b=UTGdV+vRovqn15CQvzbUPr/WFpEafjLbxclZGJbi2GYsU+MyaLLzHnbOPwMc8wqKqTw8HLRVWcSJZ0Dk9YNuoIj13y1GFfLhttiKG/SmeBZDCu0CP3ltObajl14Go+PQjLHsVQhvO4mxBdrGGAspU8u+Skv3M9JLEZ6o5BVH77M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369118; c=relaxed/simple;
	bh=/GTwU0p139y9tv+6Wob/2YAFaLk4/AYPxd9Vb/G3gMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbZGiJGznFcls2EB1qQATDgAsqgABa7lNG0pEXzOoqCUTTTrUujEiolHhkPrMN65z0C9FZufW1moMYqu0e9sHj1wEEudQxTIbWS/JL65JorFbY+6ovo9zEE0V8Q+BsPRXTxjhxtvixXUrSm9EN6IH3GLSmQKhqdq/+M9fZShlpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uz5oagxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uz5oagxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C820C4CEFE;
	Mon, 13 Oct 2025 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369118;
	bh=/GTwU0p139y9tv+6Wob/2YAFaLk4/AYPxd9Vb/G3gMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uz5oagxOjmWjX9UtImtS87XZBeDdBp3wjS3XD3tr3NxCvW1nmPcPK0CLX81/RvxcJ
	 QmiEMXAq3ZpxiyznNxYCwI+Q6ID2SxrzVPJdiw4xHbBxS/iGMl3lbCMXNqd61tOLHJ
	 /DDMhpy39uSR+1n/lkCne1XV5LlpIpko680PAv9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhovner <pavel@flipperdevices.com>,
	Alexey Charkov <alchark@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 135/563] arm64: dts: rockchip: Add WiFi on rk3576-evb1-v10
Date: Mon, 13 Oct 2025 16:39:56 +0200
Message-ID: <20251013144416.182287071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@gmail.com>

[ Upstream commit ebf8183ad08afc4fcabe1379a5098354829d950d ]

Add device tree nodes to enable the onboard Ampak AP6275P WiFi chip
connected over a PCIe link on Rockchip RK3576 EVB1.

It takes an external 32 kHz clock from the RTC chip and requires the
WIFI_REG_ON signal to be enabled before the bus is enumerated to
initialize properly.

Tested-by: Pavel Zhovner <pavel@flipperdevices.com>
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Link: https://lore.kernel.org/r/20250813-evb1-rtcwifibt-v1-2-d13c83422971@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 843367c7ed19 ("arm64: dts: rockchip: Fix network on rk3576 evb1 board")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3576-evb1-v10.dts     | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts b/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
index bfefd37a1ab8c..3007e0179611b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
@@ -232,6 +232,20 @@ vcc_ufs_s0: regulator-vcc-ufs-s0 {
 		regulator-max-microvolt = <3300000>;
 		vin-supply = <&vcc_sys>;
 	};
+
+	vcc_wifi_reg_on: regulator-wifi-reg-on {
+		compatible = "regulator-fixed";
+		enable-active-high;
+		gpios = <&gpio1 RK_PC6 GPIO_ACTIVE_HIGH>;
+		pinctrl-0 = <&wifi_reg_on>;
+		pinctrl-names = "default";
+		regulator-name = "wifi_reg_on";
+		regulator-always-on;
+		regulator-boot-on;
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		vin-supply = <&vcc_1v8_s3>;
+	};
 };
 
 &cpu_l0 {
@@ -242,6 +256,10 @@ &cpu_b0 {
 	cpu-supply = <&vdd_cpu_big_s0>;
 };
 
+&combphy0_ps {
+	status = "okay";
+};
+
 &combphy1_psu {
 	status = "okay";
 };
@@ -712,6 +730,30 @@ rgmii_phy1: phy@1 {
 	};
 };
 
+&pcie0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie0_rst>;
+	reset-gpios = <&gpio2 RK_PB4 GPIO_ACTIVE_HIGH>;
+	vpcie3v3-supply = <&vcc_3v3_s3>;
+	status = "okay";
+
+	pcie@0,0 {
+		reg = <0x0 0 0 0 0>;
+		bus-range = <0x0 0xf>;
+		device_type = "pci";
+		ranges;
+		#address-cells = <3>;
+		#size-cells = <2>;
+
+		wifi: wifi@0,0 {
+			compatible = "pci14e4,449d";
+			reg = <0x10000 0 0 0 0>;
+			clocks = <&hym8563>;
+			clock-names = "lpo";
+		};
+	};
+};
+
 &pcie1 {
 	reset-gpios = <&gpio4 RK_PC4 GPIO_ACTIVE_HIGH>;
 	vpcie3v3-supply = <&vcc3v3_pcie1>;
@@ -730,6 +772,12 @@ rtc_int: rtc-int {
 		};
 	};
 
+	pcie0 {
+		pcie0_rst: pcie0-rst {
+			rockchip,pins = <2 RK_PB4 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	usb {
 		usb_host_pwren: usb-host-pwren {
 			rockchip,pins = <0 RK_PC7 RK_FUNC_GPIO &pcfg_pull_none>;
@@ -743,6 +791,16 @@ usbc0_int: usbc0-int {
 			rockchip,pins = <0 RK_PA5 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
+
+	wifi {
+		wifi_reg_on: wifi-reg-on {
+			rockchip,pins = <1 RK_PC6 RK_FUNC_GPIO &pcfg_pull_up>;
+		};
+
+		wifi_wake_host: wifi-wake-host {
+			rockchip,pins = <0 RK_PB0 RK_FUNC_GPIO &pcfg_pull_down>;
+		};
+	};
 };
 
 &sdmmc {
-- 
2.51.0



