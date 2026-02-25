Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2C42D4805;
	Wed, 25 Feb 2026 06:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002683; cv=none; b=h5bZBrqymhK1zYDl2CJ3EJgDa8/Y0Ao1pNKFJHXDOyYmMyv3OKIhHeyxikAkLqfYU+d72gOTsPhWaP/hr2ZcSW+I4EVbqBAz0sWYc53o63o2SKaNWNc7r1ac1cUyoIVM/I2JWV/da9/K/Ic9VuNsgezgMGrHDAFz7ktzUmAGuU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002683; c=relaxed/simple;
	bh=0OudECk8Fg15T6CUa7tUCubkcxzt13E4tkllrI8x47o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COO+FHpH/M1m66miy+H75r6gWIgq2+d3wkH4jnQk5pX9jLfTeu3UpxOPaQaNkG7W0F68xcLV3SwBy4mgn5QGt+OcYSD8sP/E++JZm+CoamkZMP7RXERCo0boTYpRb5tQDTe+Skj5xPqimIBCj3KxkzaXw3SFGHpXjzBgAG3x+00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAoJRomU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAoJRomU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DEBC116D0;
	Wed, 25 Feb 2026 06:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002683;
	bh=0OudECk8Fg15T6CUa7tUCubkcxzt13E4tkllrI8x47o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAoJRomUVoHxiQc0LvkH87H03vdaauDezximDjl9XAqlJTUlMXXZCBwqXYjywAjYw
	 sPZPScJe9D/rJVn2UGBmd9jytIwOOSTEMhoFnfSfTEdp2RVY1r/v7gn9QqBgDFbOpi
	 QVMCz19SrqMnAXniGjKwTaOVLeVc8F5gHF05BnVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/641] phy: freescale: imx8qm-hsio: fix NULL pointer dereference
Date: Tue, 24 Feb 2026 17:23:20 -0800
Message-ID: <20260225012400.004355070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit 4dd5d4c0361af0a3fd24f45c815996abf4429770 ]

During the probe the refclk_pad pointer is set to NULL if the
'fsl,refclk-pad-mode' property is not defined in the devicetree node. But
in imx_hsio_configure_clk_pad() this pointer is unconditionally used which
could result in a NULL pointer dereference. So check the pointer before to
use it.

Fixes: 82c56b6dd24f ("phy: freescale: imx8qm-hsio: Add i.MX8QM HSIO PHY driver support")
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Link: https://patch.msgid.link/20260114-phy-fsl-imx8qm-hsio-fix-null-pointer-dereference-v1-1-730e941be464@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8qm-hsio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
index 977d21d753a59..279b8ac7822df 100644
--- a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
+++ b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
@@ -251,7 +251,7 @@ static void imx_hsio_configure_clk_pad(struct phy *phy)
 	struct imx_hsio_lane *lane = phy_get_drvdata(phy);
 	struct imx_hsio_priv *priv = lane->priv;
 
-	if (strncmp(priv->refclk_pad, "output", 6) == 0) {
+	if (priv->refclk_pad && strncmp(priv->refclk_pad, "output", 6) == 0) {
 		pll = true;
 		regmap_update_bits(priv->misc, HSIO_CTRL0,
 				   HSIO_IOB_A_0_TXOE | HSIO_IOB_A_0_M1M0_MASK,
-- 
2.51.0



