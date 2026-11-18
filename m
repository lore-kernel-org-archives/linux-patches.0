Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028787;
	b=pnuQtM7QHWbNRev/B8qG45yp/hT+7WoGfJsZsQ47jPHVhapYXX16dLd8OHKvZ7Pvq/JE
	 5j3lx+qxiPxLP6L0CA46KMarSjzbiKHzFQdkEZR1HA2/QOy/sXXCQfMUxF1Qsaq2giFeV
	 MoBkU/hDMPK0S/xRbcGlivfA1sOHxDVqK1533knE71qxXz6VG5hjvfDzmANW1oKL4CQYx
	 WLmk6W86T9z+wbqr14UZYpawOAwdYIsvcxXmZykUXL3yeg/ytdPABfnwZoZ7ChL3/gzOt
	 hSw0QONpNi9ET1C+0iApXjg18UscQzpFY9pvmuMn9ZMoNVtkFgUTpiA8usrlCBKzYJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FYmsxJXjynFO8loQWILBjwyKwlZUeMRkPmPmWm4BFeo=;
	b=MwbLvz3pBDc8+YssOTPUP+IXLxQofPTMxR+HNevv9eq3XOLE997OgARfIuq8ztBhcn1Z
	 82OoYdq+QsEH2HHeg5rKESJJ/t/5ACjCV4ArDMdIZqlqN426AGPrTp9cpTsVEFwI0bQnC
	 D751Gg1e0IzcuBzLKIHI938qu4fQmxr3hYJLdM56lXjhhsuuDuMha3U61/LA0Nbq9qiAz
	 ANsymx36lLeDDzjY+HbVQXUjkoccnbM5LSA20XCHz50XmIFbx31Snq+sV2ms6oF6ErP4O
	 pK1njKBDNi50n6QVg+FrBH7feYYRZ7rnB/kG99pT7N4B7gJKhp3eXs05eWg2mwq9IkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HF5Guzcd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0AB606A32A;
	Wed, 18 Nov 2026 19:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HF5Guzcd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46261F000C4;
	Wed, 18 Nov 2026 19:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028787;
	bh=FYmsxJXjynFO8loQWILBjwyKwlZUeMRkPmPmWm4BFeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HF5Guzcdw15yQrOx0dAkw0ZfBxM6YX6gWQe5MU6hdeRmGAjihWLo0m7jZf/BnLbfk
	 fnCPBGzQcUhtsq0rFNLifzA6AEi+eNJF3mLu8bq+K3Jwj0eYkZA4LrUP3bb/4C9S5i
	 PiBw7q5nDrU4BVeIRGICjYkEQ5VhFUz3RLwEOf1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0120/1756] drm/amd/display: Reset DET of HUBPs without a plane before outstanding updates
Date: Wed, 18 Nov 2026 15:37:27 +0100
Message-ID: <20261118150012.959707930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit f3afbf7d832ab138655afc96bd42226775d03ce7 ]

[WHY]
DC asserts with:
WARNING: dc/hubbub/dcn401/dcn401_hubbub.c at dcn401_program_compbuf_segments
Call Trace:
<TASK>
dcn401_program_outstanding_updates+0x36/0x60 [amdgpu]
hwss_process_outstanding_hw_updates+0x33/0x40 [amdgpu]
commit_planes_for_stream+0x171f/0x1ff0 [amdgpu]
dc_update_state_execute+0xaa/0x170 [amdgpu]
dc_update_planes_and_stream+0x42/0x70 [amdgpu]
amdgpu_dm_atomic_commit_tail+0x16a9/0x4020 [amdgpu]
commit_tail+0xc3/0x1b0 [drm_kms_helper]

The DET left by the VBIOS on a HUBP without a plane can be larger than
the DET planned for the new state. The compbuf is sized for the planned
DET, so DET + compbuf can exceed the CRB size. Programming the compbuf
then triggers the ASSERT and sets CONFIG_ERROR in hardware.

[HOW]
Release the DET of HUBPs without a plane before the compbuf is
programmed.

Add hwss_reset_unused_det() and call it in the commit and flip paths,
to cover both seamless and non-seamless boots.

Fixes: 7a1eb6680939 ("drm/amd/display: Perform outstanding programming on full updates")
Cc: Dillon Varone <dillon.varone@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c93f6fc7175b445ba3b7c85a1fc31e4e4951bbc9)
Cc: stable@vger.kernel.org
[ sashal: added a missing header include to provide the complete struct hubbub definition ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      |  6 +++-
 .../drm/amd/display/dc/core/dc_hw_sequencer.c | 32 +++++++++++++++++++
 .../drm/amd/display/dc/hwss/hw_sequencer.h    |  3 ++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 0975616b53004..282de24961710 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2062,6 +2062,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		 * update pending complete before optimizing bandwidth.
 		 */
 		hwss_wait_for_odm_update_pending_complete(dc, context);
+		/* No DET may stay allocated to a HUBP without a plane (e.g. left over from VBIOS) */
+		hwss_reset_unused_det(dc, context);
 		/* pplib is notified if disp_num changed */
 		dc->hwss.optimize_bandwidth(dc, context);
 		/* Need to do otg sync again as otg could be out of sync due to otg
@@ -3802,8 +3804,10 @@ static void commit_planes_for_stream(struct dc *dc,
 	dc_exit_ips_for_hw_access(dc);
 
 	dc_z10_restore(dc);
-	if (update_type == UPDATE_TYPE_FULL && dc->optimized_required)
+	if (update_type == UPDATE_TYPE_FULL && dc->optimized_required) {
+		hwss_reset_unused_det(dc, dc->current_state);
 		hwss_process_outstanding_hw_updates(dc, dc->current_state);
+	}
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
 		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 5dcb0fb2f66a5..f7dd6e9114c20 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -32,6 +32,7 @@
 #include "resource.h"
 #include "dc_dmub_srv.h"
 #include "dc_state_priv.h"
+#include "dchubbub.h"
 
 #define NUM_ELEMENTS(a) (sizeof(a) / sizeof((a)[0]))
 
@@ -1056,6 +1057,37 @@ void hwss_wait_for_odm_update_pending_complete(struct dc *dc, struct dc_state *c
 	hwss_wait_for_all_blank_complete(dc, context);
 }
 
+void hwss_reset_unused_det(struct dc *dc, struct dc_state *context)
+{
+	struct hubbub *hubbub = dc->res_pool->hubbub;
+	unsigned int i, j;
+
+	if (!hubbub || !hubbub->funcs->program_det_segments)
+		return;
+
+	for (i = 0; i < dc->res_pool->pipe_count; i++) {
+		struct hubp *hubp = dc->res_pool->hubps[i];
+		bool hubp_in_use = false;
+
+		if (!hubp)
+			continue;
+
+		for (j = 0; j < dc->res_pool->pipe_count; j++) {
+			const struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[j];
+
+			/* A plane-less pipe renders from the DPG, its HUBP (assigned with the stream) needs no DET */
+			if (pipe->plane_state && pipe->plane_res.hubp &&
+					pipe->plane_res.hubp->inst == hubp->inst) {
+				hubp_in_use = true;
+				break;
+			}
+		}
+
+		if (!hubp_in_use)
+			hubbub->funcs->program_det_segments(hubbub, hubp->inst, 0);
+	}
+}
+
 void hwss_wait_for_no_pipes_pending(struct dc *dc, struct dc_state *context)
 {
 	int i;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
index 9ae6259f2db17..44df0067d8ccc 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
@@ -537,6 +537,9 @@ void hwss_wait_for_odm_update_pending_complete(struct dc *dc,
 void hwss_wait_for_no_pipes_pending(struct dc *dc,
 		struct dc_state *context);
 
+void hwss_reset_unused_det(struct dc *dc,
+		struct dc_state *context);
+
 void hwss_wait_for_outstanding_hw_updates(struct dc *dc,
 		struct dc_state *dc_context);
 
-- 
2.53.0



