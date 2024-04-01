Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF994C129;
	Mon,  1 Apr 2024 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988529; cv=none; b=auCE7K7YA9pR59XDRPDeuzywDzr9i+JBYLmDzA9UFj/YQ+/bnyOwP3RFoHz/rfpVhmGFQIjJgyyE0N7n+ct2RN/7y9N1yk99Cgx3Q6ksT8Lv/ZQwk/0+6r5gPdEn6YB84U1tv2ohxszjDBDYUk0g9WLSz654vrPDSuQLVFw2+So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988529; c=relaxed/simple;
	bh=B/7ep8UT5KudqA8CX+fv/ZoCRkJMIwlsJzS8IBKc5ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ff2z4Fm0YXxhb0GW24yV0tLB62mgsW42bgiyBJk+EA7WMQJDd0vG3WLaBdXHutYqVVmcK4fOLJ8dbczBaqaNYv3ggtvLB8blvJMdw64VEIzoLP4Nle/inbCy1AAo4SJ4KAcJwb389R5Ru2EUwSnu57nJFS+Tsvir9LiQBuGHtoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deAB3KBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deAB3KBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC53C433C7;
	Mon,  1 Apr 2024 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988528;
	bh=B/7ep8UT5KudqA8CX+fv/ZoCRkJMIwlsJzS8IBKc5ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deAB3KBFTdaJI3HhXoJ/QtO9GZEv5XiuP0obBsLRg+FSqPv9rfGxkZl8Kr+qkc/BH
	 AKGspBmkNHoaiDlYTa1b1nTkAkJh/D3sYExLkx0dzRG279GiNBYPnl6HYnsV4rRAqT
	 YpZsHPkKBjR26ubTH0AyYvV4WOqkbJyzU/AqiR8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sohaib Nadeem <sohaib.nadeem@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 212/432] drm/amd/display: Override min required DCFCLK in dml1_validate
Date: Mon,  1 Apr 2024 17:43:19 +0200
Message-ID: <20240401152559.465827079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sohaib Nadeem <sohaib.nadeem@amd.com>

[ Upstream commit 26fbcb3da77efc77bd7327b7916338d773cca484 ]

[WHY]:
Increasing min DCFCLK addresses underflow issues that occur when phantom
pipe is turned on for some Sub-Viewport configs

[HOW]:
dcn32_override_min_req_dcfclk is added to override DCFCLK value in
dml1_validate when subviewport is being used.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c       | 1 +
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h       | 3 +++
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c   | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index e940dd0f92b73..3d335b1ca1089 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1866,6 +1866,7 @@ static bool dml1_validate(struct dc *dc, struct dc_state *context, bool fast_val
 	dc->res_pool->funcs->calculate_wm_and_dlg(dc, context, pipes, pipe_cnt, vlevel);
 
 	dcn32_override_min_req_memclk(dc, context);
+	dcn32_override_min_req_dcfclk(dc, context);
 
 	BW_VAL_TRACE_END_WATERMARKS();
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
index 58943835fb638..351c8a28438c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -41,6 +41,7 @@
 #define SUBVP_HIGH_REFRESH_LIST_LEN 4
 #define DCN3_2_MAX_SUBVP_PIXEL_RATE_MHZ 1800
 #define DCN3_2_VMIN_DISPCLK_HZ 717000000
+#define MIN_SUBVP_DCFCLK_KHZ 400000
 
 #define TO_DCN32_RES_POOL(pool)\
 	container_of(pool, struct dcn32_resource_pool, base)
@@ -185,6 +186,8 @@ bool dcn32_subvp_vblank_admissable(struct dc *dc, struct dc_state *context, int
 
 void dcn32_update_dml_pipes_odm_policy_based_on_context(struct dc *dc, struct dc_state *context, display_e2e_pipe_params_st *pipes);
 
+void dcn32_override_min_req_dcfclk(struct dc *dc, struct dc_state *context);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index c80d6485f6ffa..1f89428499f76 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -804,3 +804,9 @@ void dcn32_update_dml_pipes_odm_policy_based_on_context(struct dc *dc, struct dc
 		pipe_cnt++;
 	}
 }
+
+void dcn32_override_min_req_dcfclk(struct dc *dc, struct dc_state *context)
+{
+	if (dcn32_subvp_in_use(dc, context) && context->bw_ctx.bw.dcn.clk.dcfclk_khz <= MIN_SUBVP_DCFCLK_KHZ)
+		context->bw_ctx.bw.dcn.clk.dcfclk_khz = MIN_SUBVP_DCFCLK_KHZ;
+}
-- 
2.43.0



