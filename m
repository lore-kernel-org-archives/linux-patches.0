Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDEA184E;
	Mon,  1 Dec 2025 11:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588652; cv=none; b=cre38CsfHrg8zy9TvKv18DZzoWWvFC+lLK62PGpzPo65GTy12OfzwJfxsDHrqOhVh9LntRW3fux59bJP10zFTI6zuYAF2e9JtWAiRXfOHKqB0LJnICl3ksQwHnJaPUIGIyBnWQmrNS44Q5tF4Kdf7uDuguhEt6EUDhYXGGAykHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588652; c=relaxed/simple;
	bh=JQ2dm1O7FUEgbRxjAEuOB3P0QEJwrn8oZIlJfxbEF2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDYsu9ayv6jb7r8P8sY8BRh4X/IufpuQjhIX9DjIFzoBgUkdKNKOqG3PEJAnW3Cps1gO5y9LbDdQE+vyeTRHJ5Yvm8x5GI8XVVa0ChnIK8UVhuLVHi8E+5dL8Aw3uL2guOZrRcG1q6bth46X5LzBMLh6ixAw6mwbwraj3mGH2Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPIf8J5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPIf8J5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5514DC4CEF1;
	Mon,  1 Dec 2025 11:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588652;
	bh=JQ2dm1O7FUEgbRxjAEuOB3P0QEJwrn8oZIlJfxbEF2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPIf8J5wwqURaffDrjtziX9gc9jn8agixQL+ggCRFpX3YPu4wiullzVvmEtkc5scX
	 4fRogDJxyOVsVbpLVYwvkCr6XDXQQT67Vz0T21PyZApSOa1qH6oXW+GH2z7ZOXIdib
	 SoS2lWoPJSIiN6vu8jytn17I4EaU6s6Q6VgJb+TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/187] phy: cadence: cdns-dphy: Enable lower resolutions in dphy
Date: Mon,  1 Dec 2025 12:23:08 +0100
Message-ID: <20251201112244.121241660@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



