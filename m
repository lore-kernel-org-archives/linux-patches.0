Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB032571AC;
	Tue, 25 Mar 2025 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906109; cv=none; b=RwELcTjP48IUBde71jUyLwnOIln2+MPZxAXD1LnnkgKXIb3rXd4Jzu9z+FQtKT3kgzkrxjGsRGeAoDo80ER+pkml+6bRT/2TLcIGolZjDDBlhulZqM4r4K+UHeDks5gwUu7fUowTHzZIfo4iHmg1dTCcx8aMIHYajxmME76ths0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906109; c=relaxed/simple;
	bh=Sx49HA7a++bToXp8wGaNuPtey8FlObr/j86XxAXkXEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnNGxjckYLtZVkqFDMKUKJgKzambXIZR6+wfkqj/Tp5AtWtm8mrS+Ps4CHY2rkVY07cn43k/oRyNgGZGesLCXaVn3n5ySl2LpImYGWE/ycjBLbnDkljNFNeaSY16fjwVSspA/beve1ZScjUuYJbyjZIc0f2yI1G+BGPwc3rm2Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnCW18Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnCW18Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF3AC4CEE4;
	Tue, 25 Mar 2025 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906109;
	bh=Sx49HA7a++bToXp8wGaNuPtey8FlObr/j86XxAXkXEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnCW18KfpFqPxfT/zowvC3qr+v080ebLeYzW143bY4bhBurw+ihHfJuTu1GJUuveH
	 t1C/0/P5AK3Om+ZKWsHfWSABOBdnX82XhS4xQnrDSdaN6K05lxJ19EtUGIwXcezDFw
	 N8sUnEhIlWy1SMgtnAx+mKSB8oRuDpm0Eg7SXnnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/77] arm64: dts: freescale: tqma8mpql: Fix vqmmc-supply
Date: Tue, 25 Mar 2025 08:21:57 -0400
Message-ID: <20250325122144.335790974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 38f59e0e8bd2b3e1319716e4aeaeb9a6223b006d ]

eMMC is supplied by BUCK5 rail. Use the actual regulator instead of
a virtual fixed regulator.

Fixes: 418d1d840e421 ("arm64: dts: freescale: add initial device tree for TQMa8MPQL with i.MX8MP")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-tqma8mpql.dtsi     | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi
index ebc29a950ba9a..e9413c9ccafc5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later OR MIT
 /*
- * Copyright 2021-2022 TQ-Systems GmbH
- * Author: Alexander Stein <alexander.stein@tq-group.com>
+ * Copyright 2021-2025 TQ-Systems GmbH <linux@ew.tq-group.com>,
+ * D-82229 Seefeld, Germany.
+ * Author: Alexander Stein
  */
 
 #include "imx8mp.dtsi"
@@ -23,15 +24,6 @@ reg_vcc3v3: regulator-vcc3v3 {
 		regulator-max-microvolt = <3300000>;
 		regulator-always-on;
 	};
-
-	/* e-MMC IO, needed for HS modes */
-	reg_vcc1v8: regulator-vcc1v8 {
-		compatible = "regulator-fixed";
-		regulator-name = "VCC1V8";
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
-		regulator-always-on;
-	};
 };
 
 &A53_0 {
@@ -193,7 +185,7 @@ &usdhc3 {
 	no-sd;
 	no-sdio;
 	vmmc-supply = <&reg_vcc3v3>;
-	vqmmc-supply = <&reg_vcc1v8>;
+	vqmmc-supply = <&buck5_reg>;
 	status = "okay";
 };
 
-- 
2.39.5



