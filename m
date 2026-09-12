Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F671415F36;
	Sat, 12 Sep 2026 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210027; cv=none; b=SZ+NyPjfjglOWHT4jdUTs94DZRE7ONJupUYd9Q6/OLFSQqoC6QTh1BS8GLmoiITJJAq398TmTc5dsgRfGxJSMwA2mNNwS8h7Wd0ia1O1rBRTax431lL7goroWZwUFPNEQOoYt20qSYllo84UwbMF5nrV3jEU1J53UV8j0eam5ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210027; c=relaxed/simple;
	bh=6QCUP1nZBLm6T5wEzr3Hls2kDSGzC9CT07UQKiKxpco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbWGQrBaoffNlEfG9/cYs9L64PBFv58Ym2hEEya/DmQQMJIQVBR3knDis6mHxPWwrRb9urj6QVseevcWHvvVr3FUiHCv9r2pGxFh6bCe3VhIlbn00tsY4tkIgQEfMB2zA1EwdIiH9o0MwIJniS7P2CIOq3oHTapLwP2xu6ZCT2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4PTeMyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4PTeMyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6F01F000FF;
	Sat, 12 Sep 2026 10:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210025;
	bh=2GEYXDa9kRWT+2/70HAd4+zssQJhuQbLkSkxHywIrqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4PTeMyzBUbdAnthVpTgaXaku+34SPZLAzBgGnCa5aZXPedqIJXBV5sJuep4YBNLn
	 BUeW7Zn3oUgk3yFVeKHQRE/qkvIuqX/0RscajYcgvoNrhUzUOG3O/wQDQviP8labi3
	 9VnJVBTkbivyW9artDLcLjWqeV0Szau6eM2eXux4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0942/1518] arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node
Date: Sat, 12 Sep 2026 08:51:51 +0200
Message-ID: <20260912065644.762382566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 197df050a10fe216971b45a79f07195c86a02236 ]

MDIO clock index changed from 62:3 to 81:0 to match proper clock
definition in the SoC device tree. Clock Id 81:0 belongs to ICSSG0
core clock, where as 62 belongs to EQEP2 device.

See: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am64x/clocks.html

Fixes: c9087e3898a1d0 ("arm64: dts: ti: k3-am64-main: Add ICSSG nodes")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Link: https://patch.msgid.link/20260706092229.82674-1-m-malladi@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index d872cc671094f..b7e5de3669ad6 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -1401,7 +1401,7 @@ tx_pru0_1: txpru@c000 {
 		icssg0_mdio: mdio@32400 {
 			compatible = "ti,davinci_mdio";
 			reg = <0x32400 0x100>;
-			clocks = <&k3_clks 62 3>;
+			clocks = <&k3_clks 81 0>;
 			clock-names = "fck";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.53.0



