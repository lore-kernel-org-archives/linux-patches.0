Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984C1313270;
	Wed,  3 Dec 2025 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776196; cv=none; b=jnQ0+Bis7pG/i98PAclBSUe69ISoHQFclNhaiD86auWzvy8Rlz1DghYoiZt2WF5xrwHBPGKIucJ3YUCl8QtQwaWssQRLX2fhu53v+Hef5gR+zI92MNtU75s6jLEjYMig3RZN8+/2x6quRR5Pvco5+Qf86yLSuJXJtbFy+VFzgLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776196; c=relaxed/simple;
	bh=7Q2dkM39dSp7aAbwIx9f6IJsPx+O9A1dLqAK53UyHyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV2D34kp0JkqqlJnu5oB8qKGeyhqEmOd1gu/U82A379rC0xQGp3QBNIJfSbr5NFmwXbUMPoAf6GjMYa+wGmj6fKkE/F5Id9MSLFW1BtwP4UMggKG9H+weMvzh82UmvAcIkVIskWJw8WlgPclqI67rPHZXwgDsu+Gj69ec5tSvh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMtq7UPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMtq7UPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F8BC4CEF5;
	Wed,  3 Dec 2025 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776196;
	bh=7Q2dkM39dSp7aAbwIx9f6IJsPx+O9A1dLqAK53UyHyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMtq7UPQptbjVtR4CiEJrVIc9+wDFcz9RdkFPKviu8NkDBEYP0RLx3GGKL1yspZaL
	 2yyHEjdjgLQJlPjSB6b8kZn6c41PpcjErP1lq9eLWhumbg8yM5LEUOVqAlDE506rFQ
	 6pMqxpuvVwqUVJE0xO3pBQmBfRCZk+5/1U7hknxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/300] phy: cadence: cdns-dphy: Enable lower resolutions in dphy
Date: Wed,  3 Dec 2025 16:25:14 +0100
Message-ID: <20251203152404.697284933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harikrishna Shenoy <h-shenoy@ti.com>

[ Upstream commit 43bd2c44515f8ee5c019ce6e6583f5640387a41b ]

Enable support for data lane rates between 80-160 Mbps cdns dphy
as mentioned in TRM [0] by setting the pll_opdiv field to 16.
This change enables lower resolutions like 640x480 at 60Hz.

[0]: https://www.ti.com/lit/zip/spruil1
(Table 12-552. DPHY_TX_PLL_CTRL Register Field Descriptions)

Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Harikrishna Shenoy <h-shenoy@ti.com>
Link: https://lore.kernel.org/r/20250807052002.717807-1-h-shenoy@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/cdns-dphy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/cadence/cdns-dphy.c b/drivers/phy/cadence/cdns-dphy.c
index 90c4e9b5aac83..04cee5a00a5b4 100644
--- a/drivers/phy/cadence/cdns-dphy.c
+++ b/drivers/phy/cadence/cdns-dphy.c
@@ -115,7 +115,7 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 
 	dlane_bps = opts->hs_clk_rate;
 
-	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
+	if (dlane_bps > 2500000000UL || dlane_bps < 80000000UL)
 		return -EINVAL;
 	else if (dlane_bps >= 1250000000)
 		cfg->pll_opdiv = 1;
@@ -125,6 +125,8 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 		cfg->pll_opdiv = 4;
 	else if (dlane_bps >= 160000000)
 		cfg->pll_opdiv = 8;
+	else if (dlane_bps >= 80000000)
+		cfg->pll_opdiv = 16;
 
 	cfg->pll_fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
 					  cfg->pll_ipdiv,
-- 
2.51.0



