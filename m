Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F0B1A00CE;
	Tue, 21 Oct 2025 20:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077110; cv=none; b=Gj3UueRua7dq2MojNSjtgIgUX/uAUsTCCfYzHMEVzKcKAKDdrTYYly7OWDOsqFkIQpFveE2L48S+BbNabBLpmev2rzGXrYYG1aIUKAqxFAnU1WBTKqaK7Q0q9EpxkZx8i7Kp8XM2mbrF8n2oeuNbm55aiBSvw0ratrrES4W1j8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077110; c=relaxed/simple;
	bh=9ivT0IJhuq7+iwxaJhTP9Mh7tlWc8GPuddFik4Rd72U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lyg8/cT00S1i1tpzEv1bJHUU9VaEaJjhGyf0lgUtGZz6xUP5IsEybKYbbRJ9p1amiEnSoUZYF1ssDcZSDbAGtU/1t3PeTDGSQIk92JeEJKrUCgL7CDwvAhnMqBAkPHPe1pmDA+8uZLuCO7fuyWhm5es2lyhq3WronJQLL+/oq1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3cRyuBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3cRyuBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08ECC4CEF1;
	Tue, 21 Oct 2025 20:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077110;
	bh=9ivT0IJhuq7+iwxaJhTP9Mh7tlWc8GPuddFik4Rd72U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3cRyuBZwtQzFmKA83xrZNKtz4ixxLU4MgvhczARW/bnkQHYw5EZvJDHhZOsjWsu5
	 sq9Pyjxj6dG27cDYLFMn6rNpZiIgyy/R5kAMzvEnLm7nVkpiY+0FTv3gEwpSEVu6+X
	 BDVwWQyGIvSVdjfWQR1CGRXUu8NByW74+HrDSozQ=
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
Subject: [PATCH 6.12 097/136] phy: cdns-dphy: Store hs_clk_rate and return it
Date: Tue, 21 Oct 2025 21:51:25 +0200
Message-ID: <20251021195038.293330258@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
@@ -79,6 +79,7 @@ struct cdns_dphy_cfg {
 	u8 pll_ipdiv;
 	u8 pll_opdiv;
 	u16 pll_fbdiv;
+	u32 hs_clk_rate;
 	unsigned int nlanes;
 };
 
@@ -154,6 +155,9 @@ static int cdns_dsi_get_dphy_pll_cfg(str
 					  cfg->pll_ipdiv,
 					  pll_ref_hz);
 
+	cfg->hs_clk_rate = div_u64((u64)pll_ref_hz * cfg->pll_fbdiv,
+				   2 * cfg->pll_opdiv * cfg->pll_ipdiv);
+
 	return 0;
 }
 
@@ -297,6 +301,7 @@ static int cdns_dphy_config_from_opts(st
 	if (ret)
 		return ret;
 
+	opts->hs_clk_rate = cfg->hs_clk_rate;
 	opts->wakeup = cdns_dphy_get_wakeup_time_ns(dphy) / 1000;
 
 	return 0;


