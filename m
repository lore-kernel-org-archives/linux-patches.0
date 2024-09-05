Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2821018D65E;
	Thu,  5 Sep 2024 09:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529581; cv=none; b=qJw8xM2GlTCQa/Ig6WAmFaXupr81lAOf/T1p4ij9VbnWimpqV6DciQCbHh3IvOdIWHwQldlVtE9VXQxMcXHw6brEw4UWr9dZB+EMA7defDgu3GbnarGRyVOGT4qLirU7bWlI5GZNdbrRRyKJyOJExqXP5J6zwGNSJTq22ZnYOq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529581; c=relaxed/simple;
	bh=Dx5hwGxMznzgwSIFSC9VOrQOFdte3PPyaB66t1gXGqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5pZs7aJGsEWYQYYT9kTYOakJMOjsbOnYheRJFoZXD32E3wLwgBiOXsB83f01SFjDsS7JsXDHV/Sumciqw/PHPCoidPMH4LtZ6uKWbPNWU9dLYNRPeMFtBRs78OO1e41eSavA/YmwXaAfz299PUGmwoNwChHEj6AnUMb0iRYJtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysDE+9kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysDE+9kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EC9C4CEC3;
	Thu,  5 Sep 2024 09:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529580;
	bh=Dx5hwGxMznzgwSIFSC9VOrQOFdte3PPyaB66t1gXGqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysDE+9kt3ahGWCc7od0iS2XAl7Q59eL1MP9gAabr+YMUAvoK5JzbjQWSQeoyHitAG
	 byV/w6NVAZUB0JMTPZOgDZklwPTChWzQvhqmAAiKMR+061dGCJGilWe0OtlTRlQIHc
	 bHJtSvGRe8XATqrWygFqZoBMiirZ5+Jd2E0nlTIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 078/184] drm/amd/display: Fix index may exceed array range within fpu_update_bw_bounding_box
Date: Thu,  5 Sep 2024 11:39:51 +0200
Message-ID: <20240905093735.286777457@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 188fd1616ec43033cedbe343b6579e9921e2d898 ]

[Why]
Coverity reports OVERRUN warning. soc.num_states could
be 40. But array range of bw_params->clk_table.entries is 8.

[How]
Assert if soc.num_states greater than 8.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn302/dcn302_fpu.c | 10 ++++++++++
 drivers/gpu/drm/amd/display/dc/dml/dcn303/dcn303_fpu.c | 10 ++++++++++
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   | 10 ++++++++++
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c | 10 ++++++++++
 4 files changed, 40 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn302/dcn302_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn302/dcn302_fpu.c
index e2bcd205aa93..8da97a96b1ce 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn302/dcn302_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn302/dcn302_fpu.c
@@ -304,6 +304,16 @@ void dcn302_fpu_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_p
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
 
+		/* bw_params->clk_table.entries[MAX_NUM_DPM_LVL].
+		 * MAX_NUM_DPM_LVL is 8.
+		 * dcn3_02_soc.clock_limits[DC__VOLTAGE_STATES].
+		 * DC__VOLTAGE_STATES is 40.
+		 */
+		if (num_states > MAX_NUM_DPM_LVL) {
+			ASSERT(0);
+			return;
+		}
+
 		dcn3_02_soc.num_states = num_states;
 		for (i = 0; i < dcn3_02_soc.num_states; i++) {
 			dcn3_02_soc.clock_limits[i].state = i;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn303/dcn303_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn303/dcn303_fpu.c
index 3f02bb806d42..e968870a4b81 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn303/dcn303_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn303/dcn303_fpu.c
@@ -310,6 +310,16 @@ void dcn303_fpu_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_p
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
 
+		/* bw_params->clk_table.entries[MAX_NUM_DPM_LVL].
+		 * MAX_NUM_DPM_LVL is 8.
+		 * dcn3_02_soc.clock_limits[DC__VOLTAGE_STATES].
+		 * DC__VOLTAGE_STATES is 40.
+		 */
+		if (num_states > MAX_NUM_DPM_LVL) {
+			ASSERT(0);
+			return;
+		}
+
 		dcn3_03_soc.num_states = num_states;
 		for (i = 0; i < dcn3_03_soc.num_states; i++) {
 			dcn3_03_soc.clock_limits[i].state = i;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index f6fe0a64beac..ebcf5ece209a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -3232,6 +3232,16 @@ void dcn32_update_bw_bounding_box_fpu(struct dc *dc, struct clk_bw_params *bw_pa
 				dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 			}
 
+			/* bw_params->clk_table.entries[MAX_NUM_DPM_LVL].
+			 * MAX_NUM_DPM_LVL is 8.
+			 * dcn3_02_soc.clock_limits[DC__VOLTAGE_STATES].
+			 * DC__VOLTAGE_STATES is 40.
+			 */
+			if (num_states > MAX_NUM_DPM_LVL) {
+				ASSERT(0);
+				return;
+			}
+
 			dcn3_2_soc.num_states = num_states;
 			for (i = 0; i < dcn3_2_soc.num_states; i++) {
 				dcn3_2_soc.clock_limits[i].state = i;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
index ff4d795c7966..4297402bdab3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -803,6 +803,16 @@ void dcn321_update_bw_bounding_box_fpu(struct dc *dc, struct clk_bw_params *bw_p
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
 
+		/* bw_params->clk_table.entries[MAX_NUM_DPM_LVL].
+		 * MAX_NUM_DPM_LVL is 8.
+		 * dcn3_02_soc.clock_limits[DC__VOLTAGE_STATES].
+		 * DC__VOLTAGE_STATES is 40.
+		 */
+		if (num_states > MAX_NUM_DPM_LVL) {
+			ASSERT(0);
+			return;
+		}
+
 		dcn3_21_soc.num_states = num_states;
 		for (i = 0; i < dcn3_21_soc.num_states; i++) {
 			dcn3_21_soc.clock_limits[i].state = i;
-- 
2.43.0



