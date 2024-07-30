Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A08189B86;
	Tue, 30 Jul 2024 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355504; cv=none; b=sg2bM1HvbZn9qvzjIgW8VcZ68Bm1P3bDnXnet/lAFvE9JxtkMSe3FuIPCFF2oIisvwt2cktGX50N+FJgBy5kdWmSoGR3ElgeSsjtrF6++3LzdPbKTLM+Xcr32yYZH5J1Q/jjZBkS1pBo5k6b69Y/XKav7YRlmym7E70JHZlSw00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355504; c=relaxed/simple;
	bh=KFGsXO+wRIFqgp3r4b1OUmMvc3MKiwkNmSd+aVZuKo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFH/CfMmXsJamFtbWk5XJ2cb8f9AtU/AE9krOzoS9sKP6vlZh/puh1q5pvRKejwdghAnNFNCCq4YEYl5ne+fBT+KKOnazO/8Q+usx/qwPAWvBoBcVkyePUP0I6DJcMlWzoqrsFbok6CUXzUdkkP7bMeJQhvFvAJfObihLYbbzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJ+YtBLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJ+YtBLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF269C4AF0A;
	Tue, 30 Jul 2024 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355504;
	bh=KFGsXO+wRIFqgp3r4b1OUmMvc3MKiwkNmSd+aVZuKo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJ+YtBLf7w6al4nPfql1CWK7Yc/JKAGI1OnFBwh1kEgx5qWekWagMTfaK0vXgaG6Z
	 7UsNI+WtfT/rtFaHhl8/+x4JMXbSfCX2hsDFWrVIfDAKmLa40gY8RIEmft6l95r/e7
	 FKGug8Atow2acPC/VTwSEnV+G3oLgUawbr0CXwHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 061/809] arm64: dts: rockchip: Update WIFi/BT related nodes on rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:38:57 +0200
Message-ID: <20240730151727.053761159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 12c3ec878cbe3709782e85b88124abecc3bb8617 ]

Update WiFi SDIO and BT UART related props to better reflect details
about the optional onboard RTL8723DS WiFi/BT module.

Also correct the compatible used for bluetooth to match the WiFi/BT
module used on the board.

Fixes: bc3753aed81f ("arm64: dts: rockchip: rock-pi-s add more peripherals")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-14-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3308-rock-pi-s.dts    | 40 +++++++++++++++++--
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index f6fb90e13ad01..f1d4118ffb7d6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -17,6 +17,7 @@ aliases {
 		ethernet0 = &gmac;
 		mmc0 = &emmc;
 		mmc1 = &sdmmc;
+		mmc2 = &sdio;
 	};
 
 	chosen {
@@ -235,6 +236,20 @@ &pinctrl {
 	pinctrl-names = "default";
 	pinctrl-0 = <&rtc_32k>;
 
+	bluetooth {
+		bt_reg_on: bt-reg-on {
+			rockchip,pins = <4 RK_PB3 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+
+		bt_wake_host: bt-wake-host {
+			rockchip,pins = <4 RK_PB4 RK_FUNC_GPIO &pcfg_pull_down>;
+		};
+
+		host_wake_bt: host-wake-bt {
+			rockchip,pins = <4 RK_PB2 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	gmac {
 		mac_rst: mac-rst {
 			rockchip,pins = <0 RK_PA7 RK_FUNC_GPIO &pcfg_pull_none>;
@@ -284,11 +299,24 @@ &sdio {
 	cap-sd-highspeed;
 	cap-sdio-irq;
 	keep-power-in-suspend;
-	max-frequency = <1000000>;
+	max-frequency = <100000000>;
 	mmc-pwrseq = <&sdio_pwrseq>;
+	no-mmc;
+	no-sd;
 	non-removable;
-	sd-uhs-sdr104;
+	sd-uhs-sdr50;
+	vmmc-supply = <&vcc_io>;
+	vqmmc-supply = <&vcc_1v8>;
 	status = "okay";
+
+	rtl8723ds: wifi@1 {
+		reg = <1>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <RK_PA0 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "host-wake";
+		pinctrl-names = "default";
+		pinctrl-0 = <&wifi_host_wake>;
+	};
 };
 
 &sdmmc {
@@ -320,12 +348,16 @@ &uart0 {
 };
 
 &uart4 {
+	uart-has-rtscts;
 	status = "okay";
 
 	bluetooth {
-		compatible = "realtek,rtl8723bs-bt";
-		device-wake-gpios = <&gpio4 RK_PB3 GPIO_ACTIVE_HIGH>;
+		compatible = "realtek,rtl8723ds-bt";
+		device-wake-gpios = <&gpio4 RK_PB2 GPIO_ACTIVE_HIGH>;
+		enable-gpios = <&gpio4 RK_PB3 GPIO_ACTIVE_HIGH>;
 		host-wake-gpios = <&gpio4 RK_PB4 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&bt_reg_on &bt_wake_host &host_wake_bt>;
 	};
 };
 
-- 
2.43.0



