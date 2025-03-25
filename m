Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A9259CAD;
	Tue, 25 Mar 2025 12:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905756; cv=none; b=loO4O3wuk8sVhKVjxF8/aKND3hSol5tV6K4I37t5XWrvOvL0CVP6sI91OpL0ALiaUZOwsafj8M96/veklMDfxNAzNZD0auzjBaEPRxXweudSr0qD/gbF/EcS9pBYoD6qy3DJFbtzOX793MwTmM8KRBBorP10NWwjtv4DwENFxCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905756; c=relaxed/simple;
	bh=owbNrBj65sv6Ng67JmtbznHYX3XfDCa42r8qpUzkf/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDPCyk7yxHIpDrZbUsG9vWLmt3fs6N0UIBeK1Qq4LIp+vjCjw2y9YNHn1jqKty2NwkBVN2k1PmGaqkp0aMkha1MQ1Qh6xb9iIqWL/P3aIMjblS/cBcTZgwh1HCV5cKzN0aRoWEGdY9ds+Sh+4ioZ96B6jpenG+xyZQqr016BJ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1MVqCFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1MVqCFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FFFC4CEE4;
	Tue, 25 Mar 2025 12:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905756;
	bh=owbNrBj65sv6Ng67JmtbznHYX3XfDCa42r8qpUzkf/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1MVqCFZp+Mkb0zxiotRKZAV2KOAZMRdPjpQoPtzGcjdMtGUV5uehfEgTQGLkLc9f
	 gA0DX1quMv/ZxuzsewXNe3Uyon2YYTLxOSiN09wbapUlIKCWK3d7v0CSR29wS1a2r1
	 +DqG+ec+IPio9zpghtdTGLO4jkJNFmaTEeRntaLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/198] arm64: dts: freescale: tqma8mpql: Fix vqmmc-supply
Date: Tue, 25 Mar 2025 08:21:49 -0400
Message-ID: <20250325122200.513991076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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
index 7bd680a926ce7..c63144f2456e3 100644
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
@@ -194,7 +186,7 @@ &usdhc3 {
 	no-sd;
 	no-sdio;
 	vmmc-supply = <&reg_vcc3v3>;
-	vqmmc-supply = <&reg_vcc1v8>;
+	vqmmc-supply = <&buck5_reg>;
 	status = "okay";
 };
 
-- 
2.39.5



