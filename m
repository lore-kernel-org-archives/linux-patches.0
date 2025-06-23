Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F281E87B;
	Mon, 23 Jun 2025 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684718; cv=none; b=Z6Ct4jlweVRflmlIlxFESzTlaYEa4kdDWkMYntWd6CaV7Zc1ni5iPtaEqX+b2S2E0ebtyKSIYyOr9iJlwNcgpVvyeMK0EK2Mvhlv+94eA+L7HUUYpWHTxFM2v+grT0f5fkF4vm850PIX81YDORmp+wNs7b8wnt2kTFjudcxGv7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684718; c=relaxed/simple;
	bh=09cb2uAtjWM1eUp29M52r/UYpzNDYYTbDIQ2QS8E3Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZajPAMXonVrzCAQ0G5k4BFnMwr8aMm8ekraUKJJpRjfrIe/geXje5mXCxeGLXxlqbIPfrdID6ejYZH74uptsZhB32uDzS+iCrlew6ZaUuMPJ3HNiEtGXVW3wyrr+AlxQ/juMxLvx1reGQJYHlhvJ2G3ZTSsIcbvfypVVpRi9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHg+Ef/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHg+Ef/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723EBC4CEEA;
	Mon, 23 Jun 2025 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684717;
	bh=09cb2uAtjWM1eUp29M52r/UYpzNDYYTbDIQ2QS8E3Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHg+Ef/uoU3UKKv0nztIXYKPlO3PQjMOpc1TCgqu9mHg1x+yqL8zxfCNUaqP/k1RV
	 rT+kOy2l44HkzLyynjXs1ILiHdS/VRxz3qiTKj8v2AC9AeVL39OT85GGdYGPHJgxTP
	 3SwO2dXAQXBm/04X+vQ690EKeHA/lEgTDdU/UT1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.15 159/592] phy: fsl-imx8mq-usb: fix phy_tx_vboost_level_from_property()
Date: Mon, 23 Jun 2025 15:01:57 +0200
Message-ID: <20250623130704.060949107@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit b15ee09ddb987a122e74fb0fdf1bd6e864959fd3 upstream.

The description of TX_VBOOST_LVL is wrong in register PHY_CTRL3
bit[31:29].

The updated description as below:
  011: Corresponds to a launch amplitude of 0.844 V.
  100: Corresponds to a launch amplitude of 1.008 V.
  101: Corresponds to a launch amplitude of 1.156 V.

This will fix the parsing function
phy_tx_vboost_level_from_property() to return correct value.

Fixes: 63c85ad0cd81 ("phy: fsl-imx8mp-usb: add support for phy tuning")
Cc: stable@vger.kernel.org
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20250430094502.2723983-3-xu.yang_2@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -317,12 +317,12 @@ static u32 phy_tx_preemp_amp_tune_from_p
 static u32 phy_tx_vboost_level_from_property(u32 microvolt)
 {
 	switch (microvolt) {
-	case 0 ... 960:
-		return 0;
-	case 961 ... 1160:
-		return 2;
-	default:
+	case 1156:
+		return 5;
+	case 844:
 		return 3;
+	default:
+		return 4;
 	}
 }
 


