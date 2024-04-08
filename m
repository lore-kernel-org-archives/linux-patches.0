Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A6980045;
	Mon,  8 Apr 2024 13:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582031; cv=none; b=WBvGDf7WtWr3iXJxfNQLiqNeK6H9d/mv4E2DfT1NzG3RE9ak6aKrq4NGBkxoBIGygigoLxTZrdmLGCAxOvE1KTSXH+EAi7BGuv4b+0RpvcoUzxSZIiyF55sbF855GDVMIkLc5qzxZGIitsx4QuUdQlmG2V7npUmXXBohkdOjXsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582031; c=relaxed/simple;
	bh=ebCXqAqj/85FU2Y2jIzYrBEw6RD9YZXEFnzm69qNw48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrgNRSzVUTmvwLPGuELlEo6kEILZ0SvnyqD3Lovd4oYwA9A8b8VUfYBu1Ey+kHhsTNHw/HHtF0yv0zR3oUjX9eTSw6rPdxF3rtDIN85HK4T2YTS65qb9DHiPQakuCwUihl2roQsbKDp3dxFTqD3X6la6fpghQeh4K5vmlJHi1K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aD8qUvSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aD8qUvSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96D8C433C7;
	Mon,  8 Apr 2024 13:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582031;
	bh=ebCXqAqj/85FU2Y2jIzYrBEw6RD9YZXEFnzm69qNw48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aD8qUvSgk1p6wOk3N/C0k+daYnq4uUXGglTcrysZr1fTJfUVpWBXEX8YsF6+od+DZ
	 kxEA08j/LpSp3d5cdwwj0NS7I5f4afKwP4eOnSPdxjhfGlXIqIvhbFrZXWjkfu3N09
	 XdSQIgyOTv4wOMdBT8onL80yHPlOECgMcjD0ocD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 041/273] drm/amd/display: Update P010 scaling cap
Date: Mon,  8 Apr 2024 14:55:16 +0200
Message-ID: <20240408125310.566702685@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <charlene.liu@amd.com>

[ Upstream commit 038c532346418fb5ab09c8fc6d650283d9a02966 ]

[Why]
Keep the same as previous APU and also insert clock dump

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Charlene Liu <charlene.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: f341055b10bd ("drm/amd/display: Send DTBCLK disable message on first commit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c  | 25 +++++++++----------
 .../dc/resource/dcn35/dcn35_resource.c        |  2 +-
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 3db46bdc71a35..9cbab880c6233 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -384,19 +384,6 @@ static void dcn35_enable_pme_wa(struct clk_mgr *clk_mgr_base)
 	dcn35_smu_enable_pme_wa(clk_mgr);
 }
 
-void dcn35_init_clocks(struct clk_mgr *clk_mgr)
-{
-	uint32_t ref_dtbclk = clk_mgr->clks.ref_dtbclk_khz;
-
-	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
-
-	// Assumption is that boot state always supports pstate
-	clk_mgr->clks.ref_dtbclk_khz = ref_dtbclk;	// restore ref_dtbclk
-	clk_mgr->clks.p_state_change_support = true;
-	clk_mgr->clks.prev_p_state_change_support = true;
-	clk_mgr->clks.pwr_state = DCN_PWR_STATE_UNKNOWN;
-	clk_mgr->clks.zstate_support = DCN_ZSTATE_SUPPORT_UNKNOWN;
-}
 
 bool dcn35_are_clock_states_equal(struct dc_clocks *a,
 		struct dc_clocks *b)
@@ -421,7 +408,19 @@ static void dcn35_dump_clk_registers(struct clk_state_registers_and_bypass *regs
 		struct clk_mgr_dcn35 *clk_mgr)
 {
 }
+void dcn35_init_clocks(struct clk_mgr *clk_mgr)
+{
+	uint32_t ref_dtbclk = clk_mgr->clks.ref_dtbclk_khz;
 
+	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
+
+	// Assumption is that boot state always supports pstate
+	clk_mgr->clks.ref_dtbclk_khz = ref_dtbclk;	// restore ref_dtbclk
+	clk_mgr->clks.p_state_change_support = true;
+	clk_mgr->clks.prev_p_state_change_support = true;
+	clk_mgr->clks.pwr_state = DCN_PWR_STATE_UNKNOWN;
+	clk_mgr->clks.zstate_support = DCN_ZSTATE_SUPPORT_UNKNOWN;
+}
 static struct clk_bw_params dcn35_bw_params = {
 	.vram_type = Ddr4MemType,
 	.num_channels = 1,
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index 5fdcda8f86026..04d230aa8861f 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -701,7 +701,7 @@ static const struct dc_plane_cap plane_cap = {
 
 	// 6:1 downscaling ratio: 1000/6 = 166.666
 	.max_downscale_factor = {
-			.argb8888 = 167,
+			.argb8888 = 250,
 			.nv12 = 167,
 			.fp16 = 167
 	},
-- 
2.43.0



