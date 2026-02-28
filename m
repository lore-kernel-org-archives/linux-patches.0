Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8D333A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301904; cv=none; b=IAZysAdebnsAkOQTr/vy3+Opi5Li8o+FLv9vCzfkksxnoF2VYBqyZHqqReFGY0OxWvMU82KJx1xqjabjacR3L3PQ+crbthF9tdheu6UmCMwceSR1U8ZTvfARCb4xi7NPg/c6PFciafBvCx3A41HCK0+APq1KnZdi6uR1rowOmlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301904; c=relaxed/simple;
	bh=H42VNue+BVALDJ51CvyLyugpHI8BhLd2VyEs0zpwiLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS5MyV/S4iKOibDfaeNaxnINYr/RqUjkHZ7el3sg95AVsoz+6MuhZTj4GMh3GTBiVkdP9V1e1+AnjxRfvLMrIGN3jCRigtPn5r5C4kZPppcLb5E3/JXCENe6LXRhms8auX7jgwAGGJzkGVzGdOSHd7ygxVVQyN66iXK99i523+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAXfV5li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAXfV5li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978E1C116D0;
	Sat, 28 Feb 2026 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301904;
	bh=H42VNue+BVALDJ51CvyLyugpHI8BhLd2VyEs0zpwiLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAXfV5li2rM0Bq7YSmeeMRw+/CeXF9sAqGiaqMb30DPk9GvFdoEJd8009kZDJQvFi
	 u1stj3Z9XfLp5YbtoQ0XYIo8TPeD9mMugviMFt9Mi7pGfOuwAYpLu2IeAKYscuYzux
	 6HFH7MrRsGJccPmQoR58fTyikNa7ApxBCCPq6koupZszXIalp4+K/W703287IrS640
	 d5gQ+LvMDql0d82sPvLws9qo8lN1jTvAsq4H/S+JHJPcPQamgLwoEK3AYu1wsGdaJM
	 APph9quhzIo0N/brrfT6vNvqXhfJbX0P/o73lPmv3YP9APq5wncghSHC6BQqrxFylz
	 sTijHKx8lgpgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Richard <thomas.richard@bootlin.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/385] phy: freescale: imx8qm-hsio: fix NULL pointer dereference
Date: Sat, 28 Feb 2026 12:59:16 -0500
Message-ID: <20260228180011.1568201-334-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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

