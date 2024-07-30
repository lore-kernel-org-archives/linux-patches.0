Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E8218951A;
	Tue, 30 Jul 2024 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355494; cv=none; b=dk49odgNNfebKktuavOWDzFHtjK8PLoT8NKYmgNuZxCo7CkEF78uAEIVxu9yIjI7WKv1FM/oRBXVklXT/G7gQKNrd5ccq4IjBR1H6Ts10eNMdzEFuLaNVE8kjkWqVm1ssEAtOysKc5yg+YMrFPAZwmqAgqv/bgDp62jicAZDWHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355494; c=relaxed/simple;
	bh=+s0kxuUp9Uza4XCXJJLGQT9VnieUIXhBlZ/kDu73KMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qF8Io5EYiRLJi/Xt3pTLBS3umfQw2pmF79PzEg93AoAVXAHt8FxUe5HTxEmzExKOm6IszAyu4d+YJOSiYaTNkkAjc4rJh5P3+r1/4x/Bq7SqabN/d+SNbN6BR86b6myXwirw5oT6qMHj1D1bm+l1If0uAVhTUUiFpD/T/WtPGt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiQvdm2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiQvdm2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F164CC4AF17;
	Tue, 30 Jul 2024 16:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355493;
	bh=+s0kxuUp9Uza4XCXJJLGQT9VnieUIXhBlZ/kDu73KMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiQvdm2Y8ly/mDXQvGduZmyK6dD3ogkciVk5+1hD2Nu1OuRX8ETZqQ7nBANgxcFpE
	 EwlC5r/HeO7R5ymjeyq1RHTx6jC6Bzjk+6JxfFulOdJ31KbYE2XP3WDuB921+Ruk+7
	 ROG5zMGoHakh/z+/cdMjG8VYgWw8VA4XcAhTCwpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/809] arm64: dts: rockchip: Add mdio and ethernet-phy nodes to rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:38:56 +0200
Message-ID: <20240730151727.014648521@linuxfoundation.org>
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
index d4cf6026241c4..f6fb90e13ad01 100644
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
 
 &gpio0 {
@@ -221,6 +235,12 @@ &pinctrl {
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



