Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018592;
	b=HkvNjXHwE7SL7CFRqnqTyEQ/I/HfZvVywoh7g2eunhf35HRIha1c1cAaNvVlP+y2S+iT
	 kDNle0UIeqRXRPS6Q1cytxvn0Td5KcyQyDuJ7ihIFWoQacOEwgHkjKI4jU9zRZoz+TUQw
	 mgfl0mOOJKMXetsy2yQAcm5AtHhpM7XWY8BD0JPWa7rj2mYNoH3piHmjwXZTzmsD0Rn4m
	 AsZiEEMJBoL8jsnIs8aCZ7Euf2tnTXwGiiKa8YfRd8tjvCSGuldUqeAfxj1sP1KrWVn0t
	 EcAjdrzYPUOLVppQrDqyLMUjkfY081fYzNHFf1maq3yl6ZRNdmoGUxKDqGlAWr3OfQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mo5n90DEdO0SV//NORFZnzzRFsxUuXWLCNOe5FH0u+o=;
	b=1sx8gytYQV/VUwkt7IRSue3qC6BRp5gkK+att1yqQL/uQM400cmdPA3g6QVgKNqOtx3b
	 ubi4N2rSM6gUQCWkAD/O7J1it88QUmPU2lReakWOr91/MbEVPtvImF9saBd0UuZNUj/EP
	 P9/qfpnBf/+0uTbBSnZs/Nz9B/yTA5R83KyNr7FxHZz+bPXZtfwfmi+5rLOuEUURuJ9lS
	 TUsiPBl2rYXl3O/CT4+xDAeJaDJrb4FcWjF2s5vzjzDY8a85Bi012Commqg29W/v9wiCW
	 kj77LSHjYqT1uG0AeHO9tH3rT80wXdFrJ5QD8EnfmVza50cEsN4kqeeceRhtxh6sGJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yUzkowh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0380B606A32C;
	Wed, 18 Nov 2026 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yUzkowh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560441F000C4;
	Wed, 18 Nov 2026 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018591;
	bh=mo5n90DEdO0SV//NORFZnzzRFsxUuXWLCNOe5FH0u+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yUzkowhoicifz0y1GOzYMa7blQGBDzDpLFg0YZy8FBq3ylxf7Bior3LqcWgg4eoV
	 B+Bp/Or7WVO8/xc6EjfWay2e7vua42GxJCe61ArU2vzqHVzlBT+fx3OuXgk606JgS8
	 j2K3jZDjoIHaTKNW2OltCfASk9YKhZ6C/jlgqKNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Gilmore <dennis@ausil.us>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1294/2651] arm64: dts: rockchip: Use GPIO function for PCIe reset on Orange Pi 5 Pro
Date: Wed, 18 Nov 2026 15:42:14 +0100
Message-ID: <20261118150334.536293342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Gilmore <dennis@ausil.us>

[ Upstream commit e95e4fcdc4541e999888f297174e8f6f5f5f899a ]

The PERST# pins of pcie2x1l1 and pcie2x1l2 are used as reset-gpios,
but the default pinctrl state muxes them to the controllers' dedicated
PERST# function instead of GPIO.

Linux happens to work because the pin is switched to GPIO function
when it is requested as a GPIO, but the devicetree should describe the
pin function the board actually uses. Bootloaders such as U-Boot apply
the pinctrl state as described and do not change the function when the
GPIO is requested, and probing pcie2x1l2 then hangs.

Add GPIO pinctrl nodes for both reset pins and use them in place of
the PERST# function, like other RK3588 boards do.

Fixes: f47af8ebbe53 ("arm64: dts: rockchip: Add Orange Pi 5 Pro board support")
Signed-off-by: Dennis Gilmore <dennis@ausil.us>
Link: https://patch.msgid.link/20261002025746.3284691-1-dennis@ausil.us
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3588s-orangepi-5-pro.dts   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5-pro.dts b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5-pro.dts
index c9679bac1db73..783675337ab9a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5-pro.dts
@@ -188,7 +188,7 @@ package_fan1: package-fan1 {
 /* NVMe */
 &pcie2x1l1 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&pcie30x1m1_1_perstn>, <&pcie30x1m1_1_clkreqn>,
+	pinctrl-0 = <&pcie2_1_rst>, <&pcie30x1m1_1_clkreqn>,
 		    <&pcie30x1m1_1_waken>;
 	reset-gpios = <&gpio4 RK_PA2 GPIO_ACTIVE_HIGH>;
 	supports-clkreq;
@@ -199,7 +199,7 @@ &pcie2x1l1 {
 /* NIC */
 &pcie2x1l2 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&pcie20x1m0_perstn>, <&pcie20x1m0_clkreqn>,
+	pinctrl-0 = <&pcie2_2_rst>, <&pcie20x1m0_clkreqn>,
 		    <&pcie20x1m0_waken>;
 	reset-gpios = <&gpio3 RK_PD1 GPIO_ACTIVE_HIGH>;
 	vpcie3v3-supply = <&vcc3v3_eth>;
@@ -223,6 +223,16 @@ ethernet_en: ethernet-en {
 		};
 	};
 
+	pcie {
+		pcie2_1_rst: pcie2-1-rst {
+			rockchip,pins = <4 RK_PA2 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+
+		pcie2_2_rst: pcie2-2-rst {
+			rockchip,pins = <3 RK_PD1 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	usb {
 		vcc5v0_otg_en: vcc5v0-otg-en {
 			rockchip,pins = <0 RK_PC4 RK_FUNC_GPIO &pcfg_pull_down>;
-- 
2.53.0



