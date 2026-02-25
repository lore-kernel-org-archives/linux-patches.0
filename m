Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F3825A642;
	Wed, 25 Feb 2026 01:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983470; cv=none; b=tim2uJmRoh6PobIYnaN93EbcuMs+p3bkyC89pwdczG8NeZcMjspOJ9Xga8gb0hB6AqagO/MYOM42s5vV4l6Ai4nBYIqiovkKujQnHSkkRfJrEiQFkpfn6BZSAP5dGaO0e/eETODGqcitkRpte+/U+tPEyk7y8u379DXiUSFeONU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983470; c=relaxed/simple;
	bh=fBKzq1fTg6PK6/4S78HqTGtAebUPOSi59j0kvlczkvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWpJEKm/5u2uSLTudGy22EKwFzt7E292TPuwAgYEdH1HPFSor1bmDsIOY/eDOvr4IpQEI66Bkb0dHfu+PId5D7xjAZLpDa5bcJME9YGZ3D9Iz2IuFCazeq1cLPN9g6AOvb0jj7c8OFuxOb3ysyZUp+E0p53WP1H9R36FGuORC+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my3CV6ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my3CV6ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DD7C116D0;
	Wed, 25 Feb 2026 01:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983469;
	bh=fBKzq1fTg6PK6/4S78HqTGtAebUPOSi59j0kvlczkvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=my3CV6ie22MXPRJGqlO/t+QW+W3++NH8jxkThb8O/UP/KWx6/+vwpyAcHC1JrCgYQ
	 1+N2fRwCEElyIKHObgkIMfY9MYhVjzIGGJQUVfEP6aHm2ZvVad4j0aad3jV7Qaft1M
	 qr7qa8bEpMEDmB8K1A6K9iU9sSbYzEq5+ocmI720=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 585/781] phy: freescale: imx8qm-hsio: fix NULL pointer dereference
Date: Tue, 24 Feb 2026 17:21:34 -0800
Message-ID: <20260225012414.150304732@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



