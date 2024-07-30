Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA4321019A;
	Tue, 30 Jul 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355293; cv=none; b=rm35pjzb9RzgyszLPO7Q0W9tOHQLBJklP5TH8H2J4W1SKhxKHR+UrpCFK+IR1ySiaK/DrSfMSL3mE5+1vtZXVwwljhZdE2v2cQWz6cXFtqPi8DROmsuAKFrpgeJFi3C9nNQeU94vrAwULTReJG3sBeYqLjaY9n2GBiU2YRpb1hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355293; c=relaxed/simple;
	bh=6O3laUNjq1xFPOJueENSyXr1gM/MB87ZJf19jboqVsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBn8F7oFhUiYUfEyAh28wIe6NT7yjXM0a6gz52YXJkjWRfxSZJl59/DI2VmWfYFyRtDvVGW0Kgu60b9s4u6vdJ1DSJyCGPj4k9DoqgzlXkN95fseRgK4sPRDUXewoWKLwxfkH5o9HIJKdNnVc5PH2S1CNKGww1DOW5jmFKS37sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rdubhe32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rdubhe32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9E1C32782;
	Tue, 30 Jul 2024 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355293;
	bh=6O3laUNjq1xFPOJueENSyXr1gM/MB87ZJf19jboqVsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rdubhe32hetTOGapCRrl2Y32UyOruk315sLnIb2rHdR6aJb0HG5wJnOU0lt1cIezb
	 jT67JQ89q0LjL+6rj2au3R98cspavUbwniz1hjrNYIwGUndP5GgPi5JuXD+usqW9ta
	 MIc75IF23opNbxsToCaaFAhzTkjNac+40/JzGUyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/568] arm64: dts: rockchip: Add mdio and ethernet-phy nodes to rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:42:32 +0200
Message-ID: <20240730151641.602277945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 4b64ed510ed946a4e4ca6d51d6512bf5361f6a04 ]

Be explicit about the Ethernet port and define mdio and ethernet-phy
nodes in the device tree for ROCK Pi S.

Fixes: bc3753aed81f ("arm64: dts: rockchip: rock-pi-s add more peripherals")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-8-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3308-rock-pi-s.dts    | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index e31b831cd5fb3..05e26cd1ab422 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -144,11 +144,25 @@ &emmc {
 
 &gmac {
 	clock_in_out = "output";
+	phy-handle = <&rtl8201f>;
 	phy-supply = <&vcc_io>;
-	snps,reset-gpio = <&gpio0 RK_PA7 GPIO_ACTIVE_LOW>;
-	snps,reset-active-low;
-	snps,reset-delays-us = <0 50000 50000>;
 	status = "okay";
+
+	mdio {
+		compatible = "snps,dwmac-mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		rtl8201f: ethernet-phy@1 {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			reg = <1>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&mac_rst>;
+			reset-assert-us = <20000>;
+			reset-deassert-us = <50000>;
+			reset-gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_LOW>;
+		};
+	};
 };
 
 &i2c1 {
@@ -159,6 +173,12 @@ &pinctrl {
 	pinctrl-names = "default";
 	pinctrl-0 = <&rtc_32k>;
 
+	gmac {
+		mac_rst: mac-rst {
+			rockchip,pins = <0 RK_PA7 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	leds {
 		green_led: green-led {
 			rockchip,pins = <0 RK_PA6 RK_FUNC_GPIO &pcfg_pull_none>;
-- 
2.43.0



