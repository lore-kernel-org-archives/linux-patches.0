Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7BD21CC51;
	Sat, 14 Feb 2026 01:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031170; cv=none; b=Uwtj/6WlTZAqSS7D3GEtm7cVAw3bgDp8Iz4wLDZSZJB4oVtW1SWHOn+34Odn7iZL5JaAk6IsgBOIMQcvS8gxQ6Q4yh02LFgJ4HZpR/8pyZ9gM9WkdEGk4O+ooe/s9/SaVLVn1/pVwP6cXN6rpc07Wl9UNxvOCRE91FShtZFyRPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031170; c=relaxed/simple;
	bh=tE7ZSSo/0bx6AOCEaYQeAMSD6A7WTjcSK91L6/KMgds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmjzJr7iasjzB+UNeDjFDfD2XBOTYMcbWNeU6xyFt+pZsbC0fADLoB/FX0GuaIWyYlNff1irQzD3k9bBORT1d7nqYxRozAtd4D+xJFmBcXvMczvNlMloIir0FcDaq5v2ymHSMEo15MniDqj1Zbr1AiJkIygvTWLJY5zq3tIDwMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AE3SuPFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AE3SuPFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4492C19424;
	Sat, 14 Feb 2026 01:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031170;
	bh=tE7ZSSo/0bx6AOCEaYQeAMSD6A7WTjcSK91L6/KMgds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AE3SuPFbGiUNc4N3D5bH5kUm/wpAmIAO4zZDjjzP+wRTI6SHmV82ggEYSPUpBOiiU
	 SbIkgRqlX4VdtWhNleqPRsOJMuFojiWfFs+mvJo7aXvfH3PrO5hkqG+YgeIhN9cJxw
	 ZtpIdtYmE7vg42eoNgXI18ykmXJvLkgCJOIP3IsLj+jNHxXOOiZVXtYSPuFB1YXSbZ
	 vJ9vrl01T8RnEZn/vuJ/fZrJqO5DDdhiS2X35Bx+74Vfvmh4RxvUlUArAEa+fT634X
	 tXHVASaT8FJYthZTPna8fYxQAShvko1kZrP7bz/8pAJUwkFQM4GQSzDbGg6Z6846dd
	 94lTEw2CoPfoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	"Ovidiu (Ovi) Bunea" <ovidiu.bunea@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	aurabindo.pillai@amd.com,
	wayne.lin@amd.com,
	alvin.lee2@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Zhongwei.Zhang@amd.com,
	hvanzyll@amd.com,
	bpinnint@amd.com,
	danny.wang@amd.com,
	Wesley.Chalmers@amd.com
Subject: [PATCH AUTOSEL 6.19-6.6] drm/amd/display: Ensure link output is disabled in backend reset for PLL_ON
Date: Fri, 13 Feb 2026 19:59:27 -0500
Message-ID: <20260214010245.3671907-87-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 4589712e0111352973131bad975023b25569287c ]

[Why]
We're missing the code to actually disable the link output when we have
to leave the SYMCLK_ON but the TX remains OFF.

[How]
Port the code from DCN401 that detects SYMCLK_ON_TX_OFF and disable
the link output when the backend is reset.

Reviewed-by: Ovidiu (Ovi) Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Both DCN20 and DCN401 already have this code. DCN31 was missing it,
which confirms this is a genuine omission/bug. The fix brings DCN31 in
line with other display controller versions.

### 8. SUMMARY

**What it fixes**: DCN31 was missing link output disable logic during
backend reset when in `SYMCLK_ON_TX_OFF` state. This left the hardware
in an inconsistent state where the symbolic clock was active but the
transmitter was off and the link output wasn't properly disabled.

**Impact**: This affects AMD display hardware using DCN31
(Rembrandt/Yellow Carp APUs, Van Gogh, etc. - widely deployed in laptops
and desktops). The incomplete state transition could cause display
issues during mode changes, hotplug, or suspend/resume.

**Meets stable criteria**:
- Fixes a real bug (missing hardware state transition)
- Small and contained (one file, ~14 lines added)
- Obviously correct (ported from DCN401/DCN20 which already have this
  code)
- Tested-by and Reviewed-by tags present
- No new features or API changes

**Risk**: Very low. The code is guarded by specific state checks
(`SYMCLK_ON_TX_OFF`, `top_pipe == NULL`) and uses existing, well-tested
APIs. The same pattern exists in DCN20 and DCN401.

**Dependencies**: The required APIs (`get_link_hwss`,
`disable_link_output`, `SYMCLK_ON_TX_OFF` enum) already exist in the
codebase and should be available in stable trees that have DCN31
support.

This is a straightforward bug fix that brings DCN31 into consistency
with other DCN versions, fixing a missing hardware state transition that
could cause display issues for real users.

**YES**

 .../drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c  | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
index d1ecdb92b072b..20f700b59847c 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
@@ -546,8 +546,22 @@ static void dcn31_reset_back_end_for_pipe(
 	if (pipe_ctx->stream_res.tg->funcs->set_odm_bypass)
 		pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 				pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
+	/*
+	 * TODO - convert symclk_ref_cnts for otg to a bit map to solve
+	 * the case where the same symclk is shared across multiple otg
+	 * instances
+	 */
 	if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
-		pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
+		link->phy_state.symclk_ref_cnts.otg = 0;
+
+	if (pipe_ctx->top_pipe == NULL) {
+		if (link->phy_state.symclk_state == SYMCLK_ON_TX_OFF) {
+			const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
+
+			link_hwss->disable_link_output(link, &pipe_ctx->link_res, pipe_ctx->stream->signal);
+			link->phy_state.symclk_state = SYMCLK_OFF_TX_OFF;
+		}
+	}
 
 	set_drr_and_clear_adjust_pending(pipe_ctx, pipe_ctx->stream, NULL);
 
-- 
2.51.0

