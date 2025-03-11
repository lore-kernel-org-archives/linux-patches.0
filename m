Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F24325E808;
	Tue, 11 Mar 2025 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706488; cv=none; b=sopYKcy/AZ8c+Zhz5Cc6AFjsdvC8YRF7sy6A4ib6PRN+OFN3WJaB/ogmgKP4VCW7OrPpMGq4fuYbJM69t3D9i/Ykx3DRvuASPHisf0Q8EirE2P9jrM6LH0TrFDzo43WESfGbajInn3zx1xgzfYRHGCdzciAs26Pe3GEk+PCFBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706488; c=relaxed/simple;
	bh=xe3d3eomMRww0dkbMxrL4YQ7EvpZa2AmWrC32xwcgek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7HO4VTV1LLjywYefl7TIsLerTqSkhuoQ0l6DL/EfDyseFX+AEbh4fuUu6hb5RpFkPWBuyoY2xF/psSa5Zepvmcn544tx5BHCuW4n5BqNlEC10XRKktm2zWgZMSfhjoHnBaSKxqiQlCDNGllARL0kKeYPmd1PrVt0Rl2zUcxSoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1M/zyUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1M/zyUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B33C4CEE9;
	Tue, 11 Mar 2025 15:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706488;
	bh=xe3d3eomMRww0dkbMxrL4YQ7EvpZa2AmWrC32xwcgek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1M/zyUjOu53ej9hjZ9VSyrVhH5ctO6zDATKk8WvSNWqd7cUZ5K09e9YxhaRjCCAH
	 oePTWu/YNrZhT4BdNHDCOASMGeY7lmP8oIEn0Im2fqvocXooRt+DpKKzQYr3vMdWVf
	 xxFKM4Ac85QZC0B9fJPUyjM2B1g0PJx9nud7juYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fparent@baylibre.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/462] arm64: dts: mediatek: mt8516: remove 2 invalid i2c clocks
Date: Tue, 11 Mar 2025 15:55:31 +0100
Message-ID: <20250311145800.920430830@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit 9cf6a26ae352a6a150662c0c4ddff87664cc6e3c ]

The two clocks "main-source" and "main-sel" are not present in the
driver and not defined in the binding documentation. Remove them
as they are not used and not described in the documentation.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
Link: https://lore.kernel.org/r/20211110193520.488-1-fparent@baylibre.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: eb72341fd92b ("arm64: dts: mediatek: mt8516: add i2c clock-div property")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 27 ++++++------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 247e89ee2f88e..5163dda398d56 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -308,14 +308,9 @@
 			reg = <0 0x11009000 0 0x90>,
 			      <0 0x11000180 0 0x80>;
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_LOW>;
-			clocks = <&topckgen CLK_TOP_AHB_INFRA_D2>,
-				 <&infracfg CLK_IFR_I2C0_SEL>,
-				 <&topckgen CLK_TOP_I2C0>,
+			clocks = <&topckgen CLK_TOP_I2C0>,
 				 <&topckgen CLK_TOP_APDMA>;
-			clock-names = "main-source",
-				      "main-sel",
-				      "main",
-				      "dma";
+			clock-names = "main", "dma";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			status = "disabled";
@@ -327,14 +322,9 @@
 			reg = <0 0x1100a000 0 0x90>,
 			      <0 0x11000200 0 0x80>;
 			interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_LOW>;
-			clocks = <&topckgen CLK_TOP_AHB_INFRA_D2>,
-				 <&infracfg CLK_IFR_I2C1_SEL>,
-				 <&topckgen CLK_TOP_I2C1>,
+			clocks = <&topckgen CLK_TOP_I2C1>,
 				 <&topckgen CLK_TOP_APDMA>;
-			clock-names = "main-source",
-				      "main-sel",
-				      "main",
-				      "dma";
+			clock-names = "main", "dma";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			status = "disabled";
@@ -346,14 +336,9 @@
 			reg = <0 0x1100b000 0 0x90>,
 			      <0 0x11000280 0 0x80>;
 			interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>;
-			clocks = <&topckgen CLK_TOP_AHB_INFRA_D2>,
-				 <&infracfg CLK_IFR_I2C2_SEL>,
-				 <&topckgen CLK_TOP_I2C2>,
+			clocks = <&topckgen CLK_TOP_I2C2>,
 				 <&topckgen CLK_TOP_APDMA>;
-			clock-names = "main-source",
-				      "main-sel",
-				      "main",
-				      "dma";
+			clock-names = "main", "dma";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			status = "disabled";
-- 
2.39.5



