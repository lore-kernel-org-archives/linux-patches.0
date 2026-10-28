Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212547;
	b=gdbLe/Dw5GcAUMJ8+m7kV5MjNd1BBwoUwtxtaden8vK0AJ+hXpXYexrGHv41xm80M9RK
	 YYO6mjUGU9TrJMlk07oQiymdHGbKPX6y8/hadIrEBMg/MFAihuaJoxH/6Aa5DrGYNhNs7
	 hUb+q9qcmWi3N2rX1nquDyWQXSUS3l4Nij3CXq23NZZj6Fqy1pBUQ1z7Ma7zs66X9bkxb
	 64IgjRd+LI6hhjspqsE3YGKJbxpZnVQKZuw+y0PCW0YrVPbKlQGRhq5meYU4cKuKBPcZy
	 F001VFCU5V1K8OXlR71fOuTeE7+e4os+SESAL9Odl2/wiZQ69RJM/f+8BCjTkQa3gzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWAH0iyoQyuntGRo8oQsETUK6ijVqrIF+sD8gDdS2M4=;
	b=YLFIyYpVIxg06pqAMHWN9Oy9i4VbYPWw72KvIP5rZRF1TP1lf1i97NZwZ8vr0kDBqz5e
	 TKHdI4W4ho22mdN2JfwQwf3nvq/Jsz/g2TLJjYzTfgfUSXPJR7x7uhSis6GYP59h1O2PY
	 CBSuYjLOoDRQeDu8KpfS5moUv2+sqRFj+5rXroiIWC28UXQ7zh2hflH9x+/xZohB0rT5q
	 tumDQZIXN7zTtpY5Yryyx50DNhvViHs3CRdgiUv9Hh3C6Jm2AzdvnAxVByTGIdlqhHI/V
	 3okk1zo668wSvZcK0Pa9kkwsuC2sKWIWHMKqfLOityzph77HutxiuGPaOObR/iTR+9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXSEHLfg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D76606A31C;
	Wed, 28 Oct 2026 18:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXSEHLfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B021F031E0;
	Wed, 28 Oct 2026 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212546;
	bh=RWAH0iyoQyuntGRo8oQsETUK6ijVqrIF+sD8gDdS2M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXSEHLfgCqPClnRASPuRXZ5kgOMNFdQ1Y10bddvMqkz9LcCxsfJjZaXZiUYzFFRVR
	 IbRGvqqY8ThLCAzEI5rOZ+LlRkIsZDsYwS+V5b7eF98StQsEz94Fl4yb5ZUTnE1r9m
	 5p8/4camts0BgFlcJRRMkizg/bKxOFBiygC8pkeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0191/1887] drm/amd/display: Validate function returns
Date: Wed, 28 Oct 2026 17:38:07 +0100
Message-ID: <20261028170503.582928342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 673f816b9e1e92d1f70e1bf5f21b531e0ff9ad6c ]

[WHAT & HOW]
Function return values must be checked before data can be used
in subsequent functions.

This fixes 4 CHECKED_RETURN issues reported by Coverity.

[ Backport to 6.1.y: adapted the visual-panel, watermark, and
  link-detection checks to their older locations. The upstream DMUB
  run-list/D3 path is absent; the older dc_dmub_srv_cmd_queue() already
  checks and logs idle-wait failures but, unlike upstream, still retries
  the queue once afterwards. No DMUB queue change is included. ]

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c    | 3 +--
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c        | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 82b747c0ed693..1d3d9a82c4637 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2808,8 +2808,7 @@ bool perform_link_training_with_retries(
 		if (status == LINK_TRAINING_ABORT) {
 			enum dc_connection_type type = dc_connection_none;
 
-			dc_link_detect_sink(link, &type);
-			if (type == dc_connection_none) {
+			if (dc_link_detect_sink(link, &type) && type == dc_connection_none) {
 				DC_LOG_HW_LINK_TRAINING("%s: Aborting training because sink unplugged\n", __func__);
 				break;
 			}
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 31bb7e782c6b1..35e8f22d30204 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -396,7 +396,8 @@ void dc_dmub_srv_get_visual_confirm_color_cmd(struct dc *dc, struct pipe_ctx *pi
 	enum dmub_status status;
 	unsigned int panel_inst = 0;
 
-	dc_get_edp_link_panel_inst(dc, pipe_ctx->stream->link, &panel_inst);
+	if (!dc_get_edp_link_panel_inst(dc, pipe_ctx->stream->link, &panel_inst))
+		return;
 
 	memset(&cmd, 0, sizeof(cmd));
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c
index aacb1fb5c73eb..d2eebe39a55e3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubbub.c
@@ -595,7 +595,8 @@ static bool hubbub2_program_watermarks(
 		hubbub1->base.ctx->dc->clk_mgr->clks.p_state_change_support == false)
 		safe_to_lower = true;
 
-	hubbub1_program_pstate_watermarks(hubbub, watermarks, refclk_mhz, safe_to_lower);
+	if (hubbub1_program_pstate_watermarks(hubbub, watermarks, refclk_mhz, safe_to_lower))
+		wm_pending = true;
 
 	REG_SET(DCHUBBUB_ARB_SAT_LEVEL, 0,
 			DCHUBBUB_ARB_SAT_LEVEL, 60 * refclk_mhz);
-- 
2.53.0



