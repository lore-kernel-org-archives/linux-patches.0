Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B67170838;
	Mon, 23 Jun 2025 21:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712896; cv=none; b=mFa5PsmLQi7w6B5fqutvF2UeXrTvJuTJ+vkf4HRiiDkwl6+4RBMhejedlmYHq4Ew1y0jXGOlpAUopMMwft807dRBOO+IDWaQnPaigRqpQo9zMJJdGNebFuq+lotW37mH5BYEuWkf186DTl9u6HbiFvrQXTWw21UZa5X4mKrRCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712896; c=relaxed/simple;
	bh=pyNq0+A2MBcMPRsPSFMK/38RiKK+myFDnrsF4nB5NCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/9oZ5QAfzA9TSqZLk5vqk1+IfWuSvlHQPK8BW+7VUFuqsyRPzsdy0k5ScBV/NXViwfpbyG1U60kriAQogCUpXc7aA1mE54lcIT+j1yQr3ZfsGdE8dW6zbVU0hBqj9fyWfMLWYcSvWbrETFjTEzDLyGOhEWsTfMi9rImYdVKciw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ncv4jMO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ncv4jMO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B6CC4CEEA;
	Mon, 23 Jun 2025 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712896;
	bh=pyNq0+A2MBcMPRsPSFMK/38RiKK+myFDnrsF4nB5NCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ncv4jMO9+FrO7E9cxrUnRWHQhGS2nk1JSJaXdvGmA8Y1dt4DOoAIPrJbR8050te5s
	 kgTquPGGoIIMYJf9tbtcwEP7ONXnnzuFWD7Tk5jj74HYriUkbYuE8oUznQlggKLZfC
	 axTmle+N6FhIkqWM4tfaN5Mm5FYzxCU84cTsIZF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/355] arm64: dts: ti: k3-am65-main: Fix sdhci node properties
Date: Mon, 23 Jun 2025 15:05:12 +0200
Message-ID: <20250623130630.103070068@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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
index a4d35bc66f0b7..ec7b22fae7fd3 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -268,6 +268,8 @@ sdhci0: sdhci@4f80000 {
 		interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
+		ti,clkbuf-sel = <0x7>;
+		ti,trm-icp = <0x8>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-sd-hs = <0x0>;
@@ -278,8 +280,7 @@ sdhci0: sdhci@4f80000 {
 		ti,otap-del-sel-ddr50 = <0x5>;
 		ti,otap-del-sel-ddr52 = <0x5>;
 		ti,otap-del-sel-hs200 = <0x5>;
-		ti,otap-del-sel-hs400 = <0x0>;
-		ti,trm-icp = <0x8>;
+		ti,itap-del-sel-ddr52 = <0x0>;
 		dma-coherent;
 	};
 
@@ -290,18 +291,22 @@ sdhci1: sdhci@4fa0000 {
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
 		no-1-8-v;
 	};
-- 
2.39.5



