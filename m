Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FA729A2;
	Tue, 30 Jul 2024 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354966; cv=none; b=BfXk+4G7RY6jRJ5oI46tCWjbig65bzIc6CMXMtBfqbs9cGiUdTCGHfUmM+MKIwuwh5GFGrs1k6dWs4cvQoMXPQVjrxS/gxUeKlBLD+h5axo4vDSS10Nm19HxbXO+LuLbUZ44x9sY3SIztFe5VZOcBRt/MSP/5XHVr2MqLyU5DcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354966; c=relaxed/simple;
	bh=pszE8/Jpf5vBjUVYn4wSH8U/eiUoYd/aAK3YpygVe4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/bYARIJxuid0ormZk1utiGBVKr4GqRKtIkA01U9WFKfJVuSasxHJpNyU0pk4gKIjTOp91XIilUXnDxeqj2fvivQVZN80nLAC9ZSqXWIat/xiL3ssEODOk7a+bNx4KCaKrKc2u4QP+aa+/JGbZJMDvs5vHnA7l1M9hTB9uapg6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rt3wiIgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rt3wiIgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E002AC4AF0C;
	Tue, 30 Jul 2024 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354966;
	bh=pszE8/Jpf5vBjUVYn4wSH8U/eiUoYd/aAK3YpygVe4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt3wiIgbhAKEksgfvtlj4RVzkgok4qowADrQUOcsf3w0ASp5QN8jGj7y/GMU5AZfJ
	 g81DZbTc+Ruk2EU77KqaGgVCPgDvFKiLqeeH8jaytlr8ss+Hv1zMop26dFbUK3ltyW
	 5QylVKTMqTHa4GrqtK/pgz7wEQBqMBiuvuM1sgyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/440] arm64: dts: rockchip: Update WIFi/BT related nodes on rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:44:35 +0200
Message-ID: <20240730151617.406434827@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b4afdde6e94c..bc9e98fe0f013 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -17,6 +17,7 @@ aliases {
 		ethernet0 = &gmac;
 		mmc0 = &emmc;
 		mmc1 = &sdmmc;
+		mmc2 = &sdio;
 	};
 
 	chosen {
@@ -174,6 +175,20 @@ &pinctrl {
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
@@ -223,11 +238,24 @@ &sdio {
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
@@ -259,12 +287,16 @@ &uart0 {
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



