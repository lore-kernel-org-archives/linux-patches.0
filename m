Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFAC289E06;
	Thu, 27 Nov 2025 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255444; cv=none; b=ReZFAWp7PGPraXMKo49GK5qmW4OpYzmpijX/7ByveJVN54AwazP6Z+n7yCf6K3saTzCLpph1uEfUS74oD4futZwiXBRJRGLMT635HJFK0sw7bfoPukCninATNuEdVEDzxaOlDP6BROFdnwJhmY7Gk2L+tSjGIKRJ/MfkLEc8tSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255444; c=relaxed/simple;
	bh=9feSEPv3Fsv9sdnmfNiYqM+FjIbxmpA7Zed4jsqjQIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqIHkpWM0wYmi1EUqW0XgxLglw+s1CZzgTzv3d3+Nu0WtWlB6VPThJDgjZSes4KSOJ+3f3zV1/25vsvKU7gRXdwOmhvABLveBFCl2+hPXFkQ1SeYaB2Axdgod13loJ0YMDyavrLLte1LzmqFKxMX5Ofez4XnWu6WJVvRN7h0FHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pISUZHhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pISUZHhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CD4C4CEF8;
	Thu, 27 Nov 2025 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255444;
	bh=9feSEPv3Fsv9sdnmfNiYqM+FjIbxmpA7Zed4jsqjQIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pISUZHhpYOg2xRr/w0pCSh3PbQikJkmw6VkFJqTC8hb+VWO8SVi/NwgU/Wwv82xSs
	 2K1pnteY8TAtXcwCIBmdJbamFJ3prf8vXDNy5kbj0O9gPieZcQhKADrnTJVzNIzfvM
	 Sdm3N7FZlZkD3iPI5XiQt3aRRTYEKDWZjmOC1otA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Martin Leung <martin.leung@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Ausef Yousof <Ausef.Yousof@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/112] drm/amd/display: avoid reset DTBCLK at clock init
Date: Thu, 27 Nov 2025 15:46:51 +0100
Message-ID: <20251127144036.839812870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 0ae47e971b9add8f7b8f8d55ac5f407f6f346758 ]

[why & how]
this is to init to HW real DTBCLK.
and use real HW DTBCLK status to update internal logic state

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Martin Leung <martin.leung@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: cfa0904a35fd ("drm/amd/display: Prevent Gating DTBCLK before It Is Properly Latched")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |   18 +++++++----
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -393,6 +393,7 @@ void dcn35_update_clocks(struct clk_mgr
 		if (clk_mgr_base->clks.dtbclk_en && !new_clocks->dtbclk_en) {
 			if (clk_mgr->base.ctx->dc->config.allow_0_dtb_clk)
 				dcn35_smu_set_dtbclk(clk_mgr, false);
+
 			clk_mgr_base->clks.dtbclk_en = new_clocks->dtbclk_en;
 		}
 		/* check that we're not already in lower */
@@ -410,11 +411,17 @@ void dcn35_update_clocks(struct clk_mgr
 		}
 
 		if (!clk_mgr_base->clks.dtbclk_en && new_clocks->dtbclk_en) {
-			dcn35_smu_set_dtbclk(clk_mgr, true);
-			clk_mgr_base->clks.dtbclk_en = new_clocks->dtbclk_en;
+			int actual_dtbclk = 0;
 
 			dcn35_update_clocks_update_dtb_dto(clk_mgr, context, new_clocks->ref_dtbclk_khz);
-			clk_mgr_base->clks.ref_dtbclk_khz = new_clocks->ref_dtbclk_khz;
+			dcn35_smu_set_dtbclk(clk_mgr, true);
+
+			actual_dtbclk = REG_READ(CLK1_CLK4_CURRENT_CNT);
+
+			if (actual_dtbclk) {
+				clk_mgr_base->clks.ref_dtbclk_khz = new_clocks->ref_dtbclk_khz;
+				clk_mgr_base->clks.dtbclk_en = new_clocks->dtbclk_en;
+			}
 		}
 
 		/* check that we're not already in D0 */
@@ -581,12 +588,10 @@ static bool dcn35_is_spll_ssc_enabled(st
 
 static void init_clk_states(struct clk_mgr *clk_mgr)
 {
-	struct clk_mgr_internal *clk_mgr_int = TO_CLK_MGR_INTERNAL(clk_mgr);
 	uint32_t ref_dtbclk = clk_mgr->clks.ref_dtbclk_khz;
+
 	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
 
-	if (clk_mgr_int->smu_ver >= SMU_VER_THRESHOLD)
-		clk_mgr->clks.dtbclk_en = true; // request DTBCLK disable on first commit
 	clk_mgr->clks.ref_dtbclk_khz = ref_dtbclk;	// restore ref_dtbclk
 	clk_mgr->clks.p_state_change_support = true;
 	clk_mgr->clks.prev_p_state_change_support = true;
@@ -597,6 +602,7 @@ static void init_clk_states(struct clk_m
 void dcn35_init_clocks(struct clk_mgr *clk_mgr)
 {
 	struct clk_mgr_internal *clk_mgr_int = TO_CLK_MGR_INTERNAL(clk_mgr);
+
 	init_clk_states(clk_mgr);
 
 	// to adjust dp_dto reference clock if ssc is enable otherwise to apply dprefclk


