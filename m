Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2D02522B4;
	Tue, 27 May 2025 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366948; cv=none; b=BVoO+tI8MRVJXWEVMy2pb1KPWXLbDVKsyf3HbaV9uBeOtLPk3uso0qoLOHMvAwxhxa0uHzJPJFZ6ZgwM0A7gybkgpItJIxqmAoL8lOTWX7x7Mtr584zrxEO4iyMhVE35EY7hKortlK91WQPpv3d8gPAh/RSunLfOXhAh8qYfJbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366948; c=relaxed/simple;
	bh=imTj+ulpNt/26w6HRquUE9boDaEaxScxthHjd0+Rg3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyzlE3diRWwrUXzWcyQJT9FxOb3tHhSsBQxp2zOUiravcy1LsZoT08wBurinHRE64Qui+F/JpkmXY1MEDShzf35X59xbODyq6HY5+Doe6PKjIjBhbZKQHPo6HRjSl1vJvfLmffhhQLZXbNvw/SkV9Ont31qoFcnjD1B3+3weumQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1paY7Xt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1paY7Xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBADC4CEE9;
	Tue, 27 May 2025 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366948;
	bh=imTj+ulpNt/26w6HRquUE9boDaEaxScxthHjd0+Rg3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1paY7XteFU0eS9es1fp36ZiRXCe+ZLrAuPLMLgq94UoQd5raYnmXJRE1yTuWwd3X
	 V5DVqyg1VGc8xqccrS94mc6HRuM5AEE4qW6XR/qsb92pjx1b4ot/GbfLzApcL7PvLT
	 ApcJh/ckRAJymWBbs3Mrw05HBhElUapcUxE+J5yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 229/783] drm/amd/display: remove minimum Dispclk and apply oem panel timing.
Date: Tue, 27 May 2025 18:20:26 +0200
Message-ID: <20250527162522.449483041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 756e58e83e89d372b94269c0cde61fe55da76947 ]

[why & how]
1. apply oem panel timing (not only on OLED)
2. remove MIN_DPP_DISP_CLK request in driver.

This fix will apply for dcn31x but not
sync with DML's output.

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c | 2 --
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c | 2 --
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c      | 3 ++-
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index 827b24b3442ad..e4d22f74f9869 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -194,8 +194,6 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 	// workaround: Limit dppclk to 100Mhz to avoid lower eDP panel switch to plus 4K monitor underflow.
 	if (new_clocks->dppclk_khz < MIN_DPP_DISP_CLK)
 		new_clocks->dppclk_khz = MIN_DPP_DISP_CLK;
-	if (new_clocks->dispclk_khz < MIN_DPP_DISP_CLK)
-		new_clocks->dispclk_khz = MIN_DPP_DISP_CLK;
 
 	if (should_set_clock(safe_to_lower, new_clocks->dppclk_khz, clk_mgr->base.clks.dppclk_khz)) {
 		if (clk_mgr->base.clks.dppclk_khz > new_clocks->dppclk_khz)
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
index 37c39756fece4..49efea0c8fcff 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
@@ -201,8 +201,6 @@ static void dcn316_update_clocks(struct clk_mgr *clk_mgr_base,
 	// workaround: Limit dppclk to 100Mhz to avoid lower eDP panel switch to plus 4K monitor underflow.
 	if (new_clocks->dppclk_khz < 100000)
 		new_clocks->dppclk_khz = 100000;
-	if (new_clocks->dispclk_khz < 100000)
-		new_clocks->dispclk_khz = 100000;
 
 	if (should_set_clock(safe_to_lower, new_clocks->dppclk_khz, clk_mgr->base.clks.dppclk_khz)) {
 		if (clk_mgr->base.clks.dppclk_khz > new_clocks->dppclk_khz)
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index fc4fb4055ab00..94ceccfc04982 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1065,7 +1065,8 @@ void dce110_edp_backlight_control(
 			DC_LOG_DC("edp_receiver_ready_T9 skipped\n");
 	}
 
-	if (!enable && link->dpcd_sink_ext_caps.bits.oled) {
+	if (!enable) {
+		/*follow oem panel config's requirement*/
 		pre_T11_delay += link->panel_config.pps.extra_pre_t11_ms;
 		msleep(pre_T11_delay);
 	}
-- 
2.39.5



