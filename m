Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327AA29A2;
	Tue, 30 Jul 2024 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354953; cv=none; b=tSIRDePaCX8srxsWNKGmth5cZmxzY1fxjXeKvNWxLze8rGxWaGrCPvbp6WpeXMysjTHP5UoJkr2WJJidxLnXSb9IGbnmLBTDKI3ix8CSjEJ2FJKcYIiu3y870rtZ+m6YlgoFLwAGxdlnUFMztH1lauhwopSiy5JiEWIfTHq4oSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354953; c=relaxed/simple;
	bh=t/w6xrl3adiiNOoDu9E3QHTIPoY/RGrP3w/xHaF7ios=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxyHwM/cbKr06A6d8MsH/mbZ7R0Qmyvk6u7n3N1YI6EOxSzQfKN7ygezecyHHPjLDQKBpsDkfNPTt6ZmPExLgfIMcbFp46TJQOZKGuBRQyuRfmxPQfrstUwSFa9DvzjbNRI5t37AO7yzBfeVHjE52bdcB4XWj5WpoB5Dd1ipGPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycmrJ/QJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycmrJ/QJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA44BC32782;
	Tue, 30 Jul 2024 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354953;
	bh=t/w6xrl3adiiNOoDu9E3QHTIPoY/RGrP3w/xHaF7ios=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycmrJ/QJK14y4C4/lZeSazTq8R8hCrNjSpGhY+nPZJEhSMvHVBJ3IlGNliQ5MPhJs
	 PkTfABOu+xi5KDR+KDnpkV0PRyllqWcpkepDS1paznIX1cB3OUsNEf1GqCcesZV830
	 pYnZrsFmAxiKzZUjLx0bR5ih0pzjtL1KQq4qWBgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/440] arm64: dts: rockchip: Add mdio and ethernet-phy nodes to rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:44:34 +0200
Message-ID: <20240730151617.367687441@linuxfoundation.org>
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
index a78e76c865e8e..6b4afdde6e94c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -145,11 +145,25 @@ &emmc {
 
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
@@ -160,6 +174,12 @@ &pinctrl {
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



