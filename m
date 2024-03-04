Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04121EB5A;
	Mon,  4 Mar 2024 21:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589095; cv=none; b=J1gQb7XafQlazOKpa78YjooCeT/p5fYvZsn80smhnRAXP8G1WBp+ow30Pz6aCdbv9Vti9UeHn4/8kxIwmlWiGPkQAyzd7xKDHv9oYjcWYuTcF6NtYfDo33Xt9RFeeCVd5LTMKukFPoz3TrzzL0CrmL4BUufDyhFvYyS6xgmNxy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589095; c=relaxed/simple;
	bh=W8J9FYc3B4oJtglOuU2DenJNun4zqzJcM58HNScrXKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja3BWmLDCchJ0VlefLJhROHNTxM8jatmYk5l5/MUwhzVCvc12M9+K0BmXxxqbmGT1IN9pcflOw0pv6guzMQniqE//a3oM4pBPFLgv/EpTcPOL73GgXMmTWHCKjccxyoRPEcr27kYpm1oZMIJJVwMhmlifvEzA3PzjbYoIGzRKYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blUlCERV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blUlCERV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423F2C433F1;
	Mon,  4 Mar 2024 21:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589095;
	bh=W8J9FYc3B4oJtglOuU2DenJNun4zqzJcM58HNScrXKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blUlCERVP5jgrZWSfSQT7fVdokS2v4Jh823AZoq75GxAwXI81YXwrzc1L52nbiqn5
	 FvJdOv0ebC5E4yI56y88kd3VvUSYrnN28iBv0ieyjWQfCbBXWlvpN0dtLPuLbLTO8f
	 NUUTlVf9TDKIXcp2HF36pGF1qTbuWNPWRoubKjGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/215] phy: freescale: phy-fsl-imx8-mipi-dphy: Fix alias name to use dashes
Date: Mon,  4 Mar 2024 21:24:21 +0000
Message-ID: <20240304211603.254928401@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



