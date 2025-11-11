Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5AD2E9EB1;
	Tue, 11 Nov 2025 01:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823816; cv=none; b=HiqPMlACOTGcPe99wYn0fEqyDqv4USkLIavM1AITPJC3h45930Nfb5E5u5j7wzEZFF+qFeE58pV488+kupbvyQuDsSoW/fGt9q5FfGAnI8j4Wjrta65mS/8gYye/r6bVO0I2lWoAWcM+ZZ9SbuzRVeD6185ic3GJ6qK3Scs6n2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823816; c=relaxed/simple;
	bh=fF5KPeyNwXftviB+jvhP15DXFHlrPf47RVW8uicLnVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BM2YMC/tm0VKePBxwXAZMoXvDrkRkM4VxjCeli7H3IpJ80BF1euafrrf7FfYtO9JRZBcJZ/JQFZHI/amhvIei++ZQ457drVVNEzl8TXy9e/HAFO8apUKMQQxNCnH4K+3O0gma9PqieR2s7MyMjF/YjjsBarE81ieP+rTi3nsyFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAc2oJsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAc2oJsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02E9C2BC86;
	Tue, 11 Nov 2025 01:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823816;
	bh=fF5KPeyNwXftviB+jvhP15DXFHlrPf47RVW8uicLnVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAc2oJshDp/uEsssABfbFXLORYy9qN5hVPwa49yLf5svHeTanY7Vs5AXbVr4CPVQL
	 6A4leZ24aPdNEim+FPnUhzTchH/9zeJjhwC92bjIwbb1kVj9Dt1/QC2AhV5uhnIhYk
	 /V8C2Vs/c77gU9BlFrxiBSANWcB+JHgFnHNJzH2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/565] phy: cadence: cdns-dphy: Enable lower resolutions in dphy
Date: Tue, 11 Nov 2025 09:43:06 +0900
Message-ID: <20251111004534.309833853@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8d93a830ab8bf..a24df36e5c376 100644
--- a/drivers/phy/cadence/cdns-dphy.c
+++ b/drivers/phy/cadence/cdns-dphy.c
@@ -145,7 +145,7 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 
 	dlane_bps = opts->hs_clk_rate;
 
-	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
+	if (dlane_bps > 2500000000UL || dlane_bps < 80000000UL)
 		return -EINVAL;
 	else if (dlane_bps >= 1250000000)
 		cfg->pll_opdiv = 1;
@@ -155,6 +155,8 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 		cfg->pll_opdiv = 4;
 	else if (dlane_bps >= 160000000)
 		cfg->pll_opdiv = 8;
+	else if (dlane_bps >= 80000000)
+		cfg->pll_opdiv = 16;
 
 	cfg->pll_fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
 					  cfg->pll_ipdiv,
-- 
2.51.0



