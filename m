Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A5215A86D;
	Tue,  9 Jul 2024 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523989; cv=none; b=peKN10hzL9dOpiPt78BauEDbhG51aQA8wJ36zKxVn/qjv43ffY2w2FIdXFEVtGOTc7LsKDYWvFO01E3YU51d4vjWlGDYdUwWEJ03JGW177PbRCmpKp/jki3Qw7JOCMJC1HfhzdKdawZM1ZvgC6L1NqiPJJtFDuWMPLEWw5pcby4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523989; c=relaxed/simple;
	bh=F8YcsU92i/nNwdbLGdltISLhMj0EGKSiVFgyhuGgyNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YV8cI0/03tePOxIAJnROvBZRqByUf3No9aoEcmGYiXRcErDMuHJ6HnnL626F3xOUliTIy1mrlQzqGn/F37AvTOk+/VEYyY9g7wbVnnCuFyb2Xxn27JQ+HK5iVITzG7P9BMcnNsMA0xd/44R3BTsq0IHGdM45/GPfinPzROK4f4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyDeojSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyDeojSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573BEC3277B;
	Tue,  9 Jul 2024 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523988;
	bh=F8YcsU92i/nNwdbLGdltISLhMj0EGKSiVFgyhuGgyNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyDeojSWdZ/G2Ymp6LxLj+FzTWENLo3ZLOY3B3ArwiYFGbt48xidF8jqKAHcauwiG
	 SCBWygcfxcBV1TCS1fJYgRrz/rIjXp9Bh5T5B2Qveas8EU9/DstpAnCjzblddverhq
	 DF4XyiO47NGD6N8+IEjeS2ZWIJD0jTwjysQEH8tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 028/197] drm/amd/display: Add NULL pointer check for kzalloc
Date: Tue,  9 Jul 2024 13:08:02 +0200
Message-ID: <20240709110710.006921953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 8e65a1b7118acf6af96449e1e66b7adbc9396912 ]

[Why & How]
Check return pointer of kzalloc before using it.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c  | 8 ++++++++
 .../gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c  | 8 ++++++++
 .../drm/amd/display/dc/resource/dcn30/dcn30_resource.c    | 3 +++
 .../drm/amd/display/dc/resource/dcn31/dcn31_resource.c    | 5 +++++
 .../drm/amd/display/dc/resource/dcn314/dcn314_resource.c  | 5 +++++
 .../drm/amd/display/dc/resource/dcn315/dcn315_resource.c  | 2 ++
 .../drm/amd/display/dc/resource/dcn316/dcn316_resource.c  | 2 ++
 .../drm/amd/display/dc/resource/dcn32/dcn32_resource.c    | 5 +++++
 .../drm/amd/display/dc/resource/dcn321/dcn321_resource.c  | 2 ++
 .../drm/amd/display/dc/resource/dcn35/dcn35_resource.c    | 2 ++
 .../drm/amd/display/dc/resource/dcn351/dcn351_resource.c  | 2 ++
 11 files changed, 44 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
index 3271c8c7905dd..4e036356b6a89 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
@@ -560,11 +560,19 @@ void dcn3_clk_mgr_construct(
 	dce_clock_read_ss_info(clk_mgr);
 
 	clk_mgr->base.bw_params = kzalloc(sizeof(*clk_mgr->base.bw_params), GFP_KERNEL);
+	if (!clk_mgr->base.bw_params) {
+		BREAK_TO_DEBUGGER();
+		return;
+	}
 
 	/* need physical address of table to give to PMFW */
 	clk_mgr->wm_range_table = dm_helpers_allocate_gpu_mem(clk_mgr->base.ctx,
 			DC_MEM_ALLOC_TYPE_GART, sizeof(WatermarksExternal_t),
 			&clk_mgr->wm_range_table_addr);
+	if (!clk_mgr->wm_range_table) {
+		BREAK_TO_DEBUGGER();
+		return;
+	}
 }
 
 void dcn3_clk_mgr_destroy(struct clk_mgr_internal *clk_mgr)
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index e506e4f969ca9..dda1173be35ea 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -1208,11 +1208,19 @@ void dcn32_clk_mgr_construct(
 	clk_mgr->smu_present = false;
 
 	clk_mgr->base.bw_params = kzalloc(sizeof(*clk_mgr->base.bw_params), GFP_KERNEL);
+	if (!clk_mgr->base.bw_params) {
+		BREAK_TO_DEBUGGER();
+		return;
+	}
 
 	/* need physical address of table to give to PMFW */
 	clk_mgr->wm_range_table = dm_helpers_allocate_gpu_mem(clk_mgr->base.ctx,
 			DC_MEM_ALLOC_TYPE_GART, sizeof(WatermarksExternal_t),
 			&clk_mgr->wm_range_table_addr);
+	if (!clk_mgr->wm_range_table) {
+		BREAK_TO_DEBUGGER();
+		return;
+	}
 }
 
 void dcn32_clk_mgr_destroy(struct clk_mgr_internal *clk_mgr)
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
index ecc477ef8e3b7..b427a98066c11 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
@@ -2050,6 +2050,9 @@ bool dcn30_validate_bandwidth(struct dc *dc,
 
 	BW_VAL_TRACE_COUNT();
 
+	if (!pipes)
+		goto validate_fail;
+
 	DC_FP_START();
 	out = dcn30_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate, true);
 	DC_FP_END();
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
index 2fb1d00ff9654..f38de5391176f 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
@@ -1311,6 +1311,8 @@ static struct hpo_dp_link_encoder *dcn31_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 	hpo_dp_link_encoder31_construct(hpo_dp_enc31, ctx, inst,
 					&hpo_dp_link_enc_regs[inst],
@@ -1767,6 +1769,9 @@ bool dcn31_validate_bandwidth(struct dc *dc,
 
 	BW_VAL_TRACE_COUNT();
 
+	if (!pipes)
+		goto validate_fail;
+
 	DC_FP_START();
 	out = dcn30_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate, true);
 	DC_FP_END();
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
index c97391edb5ff7..2791fc45bb8c7 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -1384,6 +1384,8 @@ static struct hpo_dp_link_encoder *dcn31_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 	hpo_dp_link_encoder31_construct(hpo_dp_enc31, ctx, inst,
 					&hpo_dp_link_enc_regs[inst],
@@ -1744,6 +1746,9 @@ bool dcn314_validate_bandwidth(struct dc *dc,
 
 	BW_VAL_TRACE_COUNT();
 
+	if (!pipes)
+		goto validate_fail;
+
 	if (filter_modes_for_single_channel_workaround(dc, context))
 		goto validate_fail;
 
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
index 515ba435f759c..4ce0f4bf1d9bb 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
@@ -1309,6 +1309,8 @@ static struct hpo_dp_link_encoder *dcn31_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 	hpo_dp_link_encoder31_construct(hpo_dp_enc31, ctx, inst,
 					&hpo_dp_link_enc_regs[inst],
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
index b9753d4606f89..efa5627b0c50a 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
@@ -1306,6 +1306,8 @@ static struct hpo_dp_link_encoder *dcn31_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 	hpo_dp_link_encoder31_construct(hpo_dp_enc31, ctx, inst,
 					&hpo_dp_link_enc_regs[inst],
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index ce1754cc1f463..1f5a91b764828 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1304,6 +1304,8 @@ static struct hpo_dp_link_encoder *dcn32_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 #undef REG_STRUCT
 #define REG_STRUCT hpo_dp_link_enc_regs
@@ -1751,6 +1753,9 @@ static bool dml1_validate(struct dc *dc, struct dc_state *context, bool fast_val
 
 	BW_VAL_TRACE_COUNT();
 
+	if (!pipes)
+		goto validate_fail;
+
 	DC_FP_START();
 	out = dcn32_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate);
 	DC_FP_END();
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
index 296a0a8e71459..e83d340ed6260 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
@@ -1288,6 +1288,8 @@ static struct hpo_dp_link_encoder *dcn321_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 #undef REG_STRUCT
 #define REG_STRUCT hpo_dp_link_enc_regs
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index 5d52853cac96a..cf0cb5cf4b5b2 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1368,6 +1368,8 @@ static struct hpo_dp_link_encoder *dcn31_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 #undef REG_STRUCT
 #define REG_STRUCT hpo_dp_link_enc_regs
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
index 909e14261f9b4..116b59123199f 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -1348,6 +1348,8 @@ static struct hpo_dp_link_encoder *dcn31_hpo_dp_link_encoder_create(
 
 	/* allocate HPO link encoder */
 	hpo_dp_enc31 = kzalloc(sizeof(struct dcn31_hpo_dp_link_encoder), GFP_KERNEL);
+	if (!hpo_dp_enc31)
+		return NULL; /* out of memory */
 
 #undef REG_STRUCT
 #define REG_STRUCT hpo_dp_link_enc_regs
-- 
2.43.0



