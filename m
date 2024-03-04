Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C8E8F58;
	Mon,  4 Mar 2024 21:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588484; cv=none; b=hv1YesMdUorEBkJcs4zcrWh1d1AR975MkfWRLU4xjYhBcfxvBqdSqrlBEmahUJ80IAzyXwd1RHPveywgyDrN5CzgpscRhmNV2rEjckuiyTelIeCQfFrR4QQj1rn39Cd5ZplBfhQjSKYMJtV/kKjsOLSyJv86h4406UwhP7uZqr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588484; c=relaxed/simple;
	bh=imLZv6uDGSWeQZL+kY3N/JKIG7biQs/tyGes9rkoqeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ce6rW/aztii/Ax4mxaLsqR2t4IePWtk6oCA0WYsrWA77lUtLe588vIfSwyR2GMJStZjRmIPwEoWm1eEkIpcg/N2O9GU96sarxweE4jUMRcTvFkTl1ZRF/mFDagxbJaHp4UpLaE+3OVlvF/AdsDdmRNwJG3nV/2Q1WJv+4ycHeT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LB/rovVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LB/rovVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A304C433F1;
	Mon,  4 Mar 2024 21:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588484;
	bh=imLZv6uDGSWeQZL+kY3N/JKIG7biQs/tyGes9rkoqeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB/rovVbmT84mvZScwMY2J+h/ViKmlLmkGJqu3tRPP1Zl1Lyovmeqjxx+hu4Fvkaa
	 6Sm9GUGhUlijVXMBxUrR/iYb0mddGIg9BVZYsWqunPvX2wceANzrKW6FRflLshjS6f
	 x0lCf5rp8Nd5smXzqZltgnE/gZZuqhsxP554lgI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/143] phy: freescale: phy-fsl-imx8-mipi-dphy: Fix alias name to use dashes
Date: Mon,  4 Mar 2024 21:24:04 +0000
Message-ID: <20240304211553.868588513@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 7936378cb6d87073163130e1e1fc1e5f76a597cf ]

Devicetree spec lists only dashes as valid characters for alias names.
Table 3.2: Valid characters for alias names, Devicee Specification,
Release v0.4

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Fixes: 3fbae284887de ("phy: freescale: phy-fsl-imx8-mipi-dphy: Add i.MX8qxp LVDS PHY mode support")
Link: https://lore.kernel.org/r/20240110093343.468810-1-alexander.stein@ew.tq-group.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c b/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c
index e625b32889bfc..0928a526e2ab3 100644
--- a/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c
+++ b/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.c
@@ -706,7 +706,7 @@ static int mixel_dphy_probe(struct platform_device *pdev)
 			return ret;
 		}
 
-		priv->id = of_alias_get_id(np, "mipi_dphy");
+		priv->id = of_alias_get_id(np, "mipi-dphy");
 		if (priv->id < 0) {
 			dev_err(dev, "Failed to get phy node alias id: %d\n",
 				priv->id);
-- 
2.43.0



