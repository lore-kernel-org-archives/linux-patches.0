Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B420119D084;
	Mon, 23 Jun 2025 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714821; cv=none; b=WYvWPzpwHmCeccsSyOjCo1zQjoybTqsYIP4Hl9Wk4Xr7iuVLnV/XdD+sTfiSbMlIlGV4LsxeZ7h7KH0JjU3PflVbZLxex9u7PXH4zf9tbmXUd95wAYc1skbhWEapD1R2K7nipQVevXHblmyWZHQnOdGXL7/c0RlnxHCZCwIC8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714821; c=relaxed/simple;
	bh=fk4MNMz6+SwfTI+wFoI25W3CFnwtkha7LIA0JRQLORQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chbTIcmLo2pVA4VYWK+A+0hBGFnYQnDZCpR2MKurG+7RD/UXIl8DiAhobJW2FETC7kcpwaGNvPKBfJj5Sikktp6pNo5NWOuFUUp4prsNFwZY3UYt1ICeXN8q7feDrQHDg8yMvXoo7APLBNwvNc3/+sUjKG7/sVQt8jfkiAgOirE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jc3xw9IH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jc3xw9IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492BBC4CEEA;
	Mon, 23 Jun 2025 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714821;
	bh=fk4MNMz6+SwfTI+wFoI25W3CFnwtkha7LIA0JRQLORQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jc3xw9IHDVr6Cl3+v744CJ5JgwzIwHTzPyG5nGFJaZ8dXRFQBFPPHzhNeSItNN4GH
	 gESmVLFNeblUV+luUokvS2LWwxvtoh+/gOoagCJDSg3zFB5JU0A+CmESqDlBRVpEZe
	 HlMyQuMvA3gRdfz933bcsS0griz7DRGChfJHZV5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/508] arm64: dts: ti: k3-am65-main: Fix sdhci node properties
Date: Mon, 23 Jun 2025 15:04:23 +0200
Message-ID: <20250623130650.626231772@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 8ffe9cb889f2b831a9d5bbb1f7ad42d30e31170f ]

Update otap-del-sel properties as per datasheet [0].

Add missing clkbuf-sel and itap-del-sel values also as per
datasheet [0].

Move clkbuf-sel and ti,trm-icp above the otap-del-sel properties
so the sdhci nodes could be more uniform across platforms.

[0] https://www.ti.com/lit/ds/symlink/am6548.pdf

Fixes: eac99d38f861 ("arm64: dts: ti: k3-am654-main: Update otap-del-sel values")
Fixes: d7600d070fb0 ("arm64: dts: ti: k3-am65-main: Add support for sdhci1")
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20240423151732.3541894-2-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: f55c9f087cc2 ("arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 9854cf0e7f7b4..c09457fef2db0 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -262,6 +262,8 @@ sdhci0: mmc@4f80000 {
 		interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
+		ti,clkbuf-sel = <0x7>;
+		ti,trm-icp = <0x8>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-sd-hs = <0x0>;
@@ -272,8 +274,7 @@ sdhci0: mmc@4f80000 {
 		ti,otap-del-sel-ddr50 = <0x5>;
 		ti,otap-del-sel-ddr52 = <0x5>;
 		ti,otap-del-sel-hs200 = <0x5>;
-		ti,otap-del-sel-hs400 = <0x0>;
-		ti,trm-icp = <0x8>;
+		ti,itap-del-sel-ddr52 = <0x0>;
 		dma-coherent;
 	};
 
@@ -284,18 +285,22 @@ sdhci1: mmc@4fa0000 {
 		clocks = <&k3_clks 48 0>, <&k3_clks 48 1>;
 		clock-names = "clk_ahb", "clk_xin";
 		interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
+		ti,clkbuf-sel = <0x7>;
+		ti,trm-icp = <0x8>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-sd-hs = <0x0>;
-		ti,otap-del-sel-sdr12 = <0x0>;
-		ti,otap-del-sel-sdr25 = <0x0>;
+		ti,otap-del-sel-sdr12 = <0xf>;
+		ti,otap-del-sel-sdr25 = <0xf>;
 		ti,otap-del-sel-sdr50 = <0x8>;
 		ti,otap-del-sel-sdr104 = <0x7>;
 		ti,otap-del-sel-ddr50 = <0x4>;
 		ti,otap-del-sel-ddr52 = <0x4>;
 		ti,otap-del-sel-hs200 = <0x7>;
-		ti,clkbuf-sel = <0x7>;
-		ti,trm-icp = <0x8>;
+		ti,itap-del-sel-legacy = <0xa>;
+		ti,itap-del-sel-sd-hs = <0x1>;
+		ti,itap-del-sel-sdr12 = <0xa>;
+		ti,itap-del-sel-sdr25 = <0x1>;
 		dma-coherent;
 	};
 
-- 
2.39.5



