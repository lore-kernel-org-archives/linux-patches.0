Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E56189919;
	Mon, 24 Feb 2025 14:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409116; cv=none; b=PjlwwQnxmDLec6quoyrfUzIcXAPDSTug1FFGBjdciQcZzNm2/dhy4LYB6s1rdh7jx09DQKoib38pLdD8Hr1iGrdouw/qvQrW2DYe/dcZssyShkL0vaAFehpJTO5YG0py+iWVaoLXZMsR3bWG8IW8cUTKUUXyJZa3y5Jagd/N7so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409116; c=relaxed/simple;
	bh=4Fk2xL55soGQFUv2ghIVXyhvJTN+aSROozBAcHEQDyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEq3/abumrNzibxG7hu6oC6B5LKgNRRqPwSWppDayQEqIJGHYzWbbE0CPZeeMlOXMQ5Y0wdH/oTCylG2w5W/Q9gDyz9ew6n4Gg332yT3rGZ47500pILxBvgp8Hdu5683SUeoJVEGP8hMYYe2o0KOQS+7U3tKlnAZOxeFeJ6UkLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMhJYAG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMhJYAG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDF1C4CED6;
	Mon, 24 Feb 2025 14:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409116;
	bh=4Fk2xL55soGQFUv2ghIVXyhvJTN+aSROozBAcHEQDyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMhJYAG9N2W9r9TRudLOQgkYglckFK4QBmp+SvGcTbre7ApwW5NjA5aFtD1t1rilN
	 64/XC1fhwfFgRNKX7Bos0k22C2/6MvSJQLigxnTCDZEhqC2HIxKyGQbR3J/L6eSdUI
	 U8D8oRxeD/+/K/7TFRJdw5soDAEkBYVUf60ed7rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianling Shen <cnsztl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.13 102/138] arm64: dts: rockchip: change eth phy mode to rgmii-id for orangepi r1 plus lts
Date: Mon, 24 Feb 2025 15:35:32 +0100
Message-ID: <20250224142608.489799291@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianling Shen <cnsztl@gmail.com>

commit a6a7cba17c544fb95d5a29ab9d9ed4503029cb29 upstream.

In general the delay should be added by the PHY instead of the MAC,
and this improves network stability on some boards which seem to
need different delay.

Fixes: 387b3bbac5ea ("arm64: dts: rockchip: Add Xunlong OrangePi R1 Plus LTS")
Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Tianling Shen <cnsztl@gmail.com>
Link: https://lore.kernel.org/r/20250119091154.1110762-1-cnsztl@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts |    3 +--
 arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus.dts     |    1 +
 arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus.dtsi    |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts
@@ -17,8 +17,7 @@
 
 &gmac2io {
 	phy-handle = <&yt8531c>;
-	tx_delay = <0x19>;
-	rx_delay = <0x05>;
+	phy-mode = "rgmii-id";
 	status = "okay";
 
 	mdio {
--- a/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus.dts
@@ -15,6 +15,7 @@
 
 &gmac2io {
 	phy-handle = <&rtl8211e>;
+	phy-mode = "rgmii";
 	tx_delay = <0x24>;
 	rx_delay = <0x18>;
 	status = "okay";
--- a/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus.dtsi
@@ -109,7 +109,6 @@
 	assigned-clocks = <&cru SCLK_MAC2IO>, <&cru SCLK_MAC2IO_EXT>;
 	assigned-clock-parents = <&gmac_clk>, <&gmac_clk>;
 	clock_in_out = "input";
-	phy-mode = "rgmii";
 	phy-supply = <&vcc_io>;
 	pinctrl-0 = <&rgmiim1_pins>;
 	pinctrl-names = "default";


