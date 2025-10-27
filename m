Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B44727FD62;
	Mon, 27 Oct 2025 19:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592528; cv=none; b=MFEJYlL8KdV0T/OG/c81PS/r5bmZNgd00ZcLoqkvdNM3JZFaMJ/S3zhMcQCffAjOAmfEZ0LUVFzR/8NnlT2+Zyo1spMIiKMct4R7Rb2qdXn2Sj4uT3+lWNRpnqmXs1vQXm8WzlyI0JSqGfSUr6U4EJ3IPIc59fOr/25qx0OC4pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592528; c=relaxed/simple;
	bh=6frrJvwf7horupiheiaQO3U3UKPUIFD4+wnkUtMk7A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=royAA3JEEfpF6byAzQu9tj6aVzJ7YFYLZlIepCipcuWMgAn2HiBXpa8y8pOo2UO1KsOHBXsLoyfGvAKQg79eWYGEWqxMH0V19Iwa835CjhBOTlzvNmU53ff9DbcaE1QmMm678J4jPQIBxYQ6rxY4I/ZvPGwT/g9td4Q1fI5bWq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqtOu+uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqtOu+uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101E5C4CEF1;
	Mon, 27 Oct 2025 19:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592528;
	bh=6frrJvwf7horupiheiaQO3U3UKPUIFD4+wnkUtMk7A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqtOu+uNz51pJ9Rhn3oQZwH/lCv6REsF7Hc36WAASEPhMamNjztRvMmlmpXJRZNOj
	 tANEFGag/jGTXtOG7EWA22WsUhPY6ZOQXLbj9PnzKU/vYjrYi9FH1pwc+U0WNXk/Kc
	 U//tOIOk5sKcZflxT6IADToNv/cUizPrkWMmFkFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/157] phy: cdns-dphy: Store hs_clk_rate and return it
Date: Mon, 27 Oct 2025 19:36:20 +0100
Message-ID: <20251027183504.439603163@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 689a54acb56858c85de8c7285db82b8ae6dbf683 ]

The DPHY driver does not return the actual hs_clk_rate, so the DSI
driver has no idea what clock was actually achieved. Set the realized
hs_clk_rate to the opts struct, so that the DSI driver gets it back.

Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Tested-by: Parth Pancholi <parth.pancholi@toradex.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://lore.kernel.org/r/20250723-cdns-dphy-hs-clk-rate-fix-v1-1-d4539d44cbe7@ideasonboard.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 284fb19a3ffb ("phy: cadence: cdns-dphy: Fix PLL lock and O_CMN_READY polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/cadence/cdns-dphy.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/phy/cadence/cdns-dphy.c
+++ b/drivers/phy/cadence/cdns-dphy.c
@@ -80,6 +80,7 @@ struct cdns_dphy_cfg {
 	u8 pll_ipdiv;
 	u8 pll_opdiv;
 	u16 pll_fbdiv;
+	u32 hs_clk_rate;
 	unsigned int nlanes;
 };
 
@@ -155,6 +156,9 @@ static int cdns_dsi_get_dphy_pll_cfg(str
 					  cfg->pll_ipdiv,
 					  pll_ref_hz);
 
+	cfg->hs_clk_rate = div_u64((u64)pll_ref_hz * cfg->pll_fbdiv,
+				   2 * cfg->pll_opdiv * cfg->pll_ipdiv);
+
 	return 0;
 }
 
@@ -298,6 +302,7 @@ static int cdns_dphy_config_from_opts(st
 	if (ret)
 		return ret;
 
+	opts->hs_clk_rate = cfg->hs_clk_rate;
 	opts->wakeup = cdns_dphy_get_wakeup_time_ns(dphy) / 1000;
 
 	return 0;


