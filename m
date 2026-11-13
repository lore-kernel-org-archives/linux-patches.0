Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585774;
	b=ynS98YWSrBS51dl/r4K1BOaF4CtDOzK+R0Sf0bir83mPW4nx6p9Z+JjXfA2r8PBsvmn6
	 ldm4pHOlc9C2kvjavNwTmm9MYA71xqZ/5b0UxTlvsFJZgo7uBN2wE/CRRtpYliurAaI7b
	 zUzDX8uzhpIGtQn9jcgvsiguAvd+8COy2zI25K/E05Pq/Hw9xmezbjMi6uw+PlCsHJZ1U
	 dXU2FMM8BePx3XFfNmoR9rd1TLvWQyDZHzcp5JyBAilyfZ2Abclk9FxjOpQG5ARF0Dlyf
	 zFcG78qmbypCXt9H07zrbOn+VbjP9v0F2pUoBH94bvbGj7Lf69MTNjsz9teXlEmrYxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lLWkKF7ksWd7Opi8wtZ7sRpM2Manlfsz6/k/nKmmngI=;
	b=nmSXlyKCfagxwbRnaqnbLRqeX2JzB9Zci7C3+2vcvLf5+qjlJRLmojNXRH65drfSaNHM
	 OTDwtFVusauuSMLcCy+ylVViKR14KoUGkYp7yWVo0s+Pt3BzEmVXg3Fve/TbUMicSk7x1
	 cWNIPjaRUGchITozgwrBhqH/HzwFZTazsPvck+TQ7KtA6G8yYai0Bj8TN2+7JcN5cdOyx
	 CwMkbXS+IRGG1Wt7/VJhz7JXI8v5J9Jrx440xVCaeOHUQjuoCjudo4+LjbuqeY0YpOSdc
	 M/Qcw4rhIoJ8AdvEtUwWMRDvlSYmXDihPZOg1tQSwjmowLaaBGM+gIzjFtwkeAhyzPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASf5Gp+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FE6606D45A;
	Fri, 13 Nov 2026 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASf5Gp+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4801F000C4;
	Fri, 13 Nov 2026 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585774;
	bh=lLWkKF7ksWd7Opi8wtZ7sRpM2Manlfsz6/k/nKmmngI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASf5Gp+2CDK1CW3dw8WibZHNgoxO9BcGmJlUkyQRsD4uEtiInyKVOL5EaiBomBW2+
	 Sr3YG8ZqEJjayRYla+KdRPMyGN5wKKXhEVBmDJnUYINTnAXVesP9XtAJWG7HVHxyzE
	 jSRx7PE89hD4t4YIzm5at1QN1AmpwGxLjS5Y+hxQ=
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
Subject: [PATCH 7.3 363/507] drm/amd/display: Reset DET of HUBPs without a plane before outstanding updates
Date: Fri, 13 Nov 2026 10:51:07 -0500
Message-ID: <20261113153808.235173475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      |  6 +++-
 .../drm/amd/display/dc/core/dc_hw_sequencer.c | 31 +++++++++++++++++++
 .../drm/amd/display/dc/hwss/hw_sequencer.h    |  3 ++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 519ac878ada1b..60b903edff2f8 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2452,6 +2452,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		 * update pending complete before optimizing bandwidth.
 		 */
 		hwss_wait_for_odm_update_pending_complete(dc, context);
+		/* No DET may stay allocated to a HUBP without a plane (e.g. left over from VBIOS) */
+		hwss_reset_unused_det(dc, context);
 		/* pplib is notified if disp_num changed */
 		dc->hwss.optimize_bandwidth(dc, context);
 		/* Need to do otg sync again as otg could be out of sync due to otg
@@ -4885,8 +4887,10 @@ static void commit_planes_for_stream(struct dc *dc,
 	dc_exit_ips_for_hw_access(dc);
 
 	dc_z10_restore(dc);
-	if (update_type == UPDATE_TYPE_FULL && dc->optimized_required)
+	if (update_type == UPDATE_TYPE_FULL && dc->optimized_required) {
+		hwss_reset_unused_det(dc, dc->current_state);
 		hwss_process_outstanding_hw_updates(dc, dc->current_state);
+	}
 
 	if (update_type != UPDATE_TYPE_FAST && dc->res_pool->funcs->prepare_mcache_programming)
 		dc->res_pool->funcs->prepare_mcache_programming(dc, context);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index ef4987d449cb2..d4dbdf7d05065 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -3047,6 +3047,37 @@ void hwss_wait_for_odm_update_pending_complete(struct dc *dc, struct dc_state *c
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
index cdf2562a9a402..0d64a0c1913d9 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h
@@ -1807,6 +1807,9 @@ void hwss_wait_for_odm_update_pending_complete(struct dc *dc,
 void hwss_wait_for_no_pipes_pending(struct dc *dc,
 		struct dc_state *context);
 
+void hwss_reset_unused_det(struct dc *dc,
+		struct dc_state *context);
+
 void hwss_wait_for_outstanding_hw_updates(struct dc *dc,
 		struct dc_state *dc_context);
 
-- 
2.53.0



