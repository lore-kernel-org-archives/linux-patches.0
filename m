Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618097;
	b=0MAy6rV0/D3L8J13OxJGXqI6+3lQFwmOKXHNEPgwDZK2lQJyHmhb61LyNO9i8jsWOTnU
	 l5EKlkXw5t3nJfNL4fYclJa8jDyWe8YUdVnLQJbhjv+PlfMIxEo1fYUlkQNjnYD65nXVX
	 lG0KNJilG9jEp1kWsZXeBTKt89wr7VkcKXMh0xiiV4tTq3ufJVRBIA7hpZD1KgZmMpxcb
	 IjtENw+BUuxs5GeY69orcpJ+mAkl+UWr5NskveJyNJ6px6Rn16RFzp/ECNnER0Q2b/zuF
	 sDnWh9LUPh/w1Z7jYpd3H9dFHxtdKsQoK070endxrJTeSd/BNrdcfwYnxEcyRdbHyDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QGo3mE6a4G5nKT6nLjCnI69hdZWXebI05gC3ZZeZcgA=;
	b=Mgx9PPJNsSa6cvL4osgW0R9PEzpD4HBZa2r5vXeQWH/zeFHhzpWav1xyUQy4BLC7ewOq
	 0JZgIsRc5GgSb96laZ7e84o29Pyjw9iY8ZP56anMJI+mym0pn9D/CnPDcDh3KBeAf783X
	 B0XN53002lAKokXHkUCKQtlJNDxlknL/cJLR1Rz8k3Muw1DxSTE5eZIOtow7y/lLMcvY6
	 TAVaNNFwJRterWl2DEi8Q6CQbSGRVCUb0eEHOgp8eplRzU9fkIleEaPnBtHeGzkWiByea
	 vtYYN99ngpFDIG3tEVCQJQuE2Ppr2DMjBFaDZh90NMLGqZVw1WQccHtfelVCCRwTFog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U8hEhZhV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C721606A31E;
	Wed, 25 Nov 2026 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U8hEhZhV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3851F000C0;
	Wed, 25 Nov 2026 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618097;
	bh=QGo3mE6a4G5nKT6nLjCnI69hdZWXebI05gC3ZZeZcgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8hEhZhVdEreKPVNshsDoX0NL1tOo8kTOD6StaBwNL8VBTjB1xeWi8KjyifkRFeTU
	 6llf1xqYmnuKFwt9axdJkUj+yzhveA9Ycr7AzVoHr3ocIro7+1nGP/KyZgVVvyJJWD
	 O65M7oJucufbcNCHefprjEZO6oQQaNAdyvrpWg00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Animesh Manna <animesh.manna@intel.com>,
	Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0125/1005] drm/i915/cmtg: Disable CMTG after encoder disable in hsw_crtc_disable()
Date: Wed, 25 Nov 2026 15:24:23 +0100
Message-ID: <20261125143824.667705901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Animesh Manna <animesh.manna@intel.com>

[ Upstream commit 0a5bad4cd8b87b8d575e3efccaa06c02158db32f ]

hsw_crtc_disable() disables CMTG at the very start of the CRTC disable
sequence, before intel_encoders_disable(). With this ordering, the wait
for CMTG_STATE to clear after CMTG_ENABLE is cleared intermittently
times out:

  xe 0000:00:02.0: [drm] CMTG: A disable timeout
  WARNING: drivers/gpu/drm/i915/display/intel_cmtg.c:205 intel_cmtg_disable+0x331/0x3d0 [xe]

This is seen with igt@kms_hdr@bpc-switch-suspend, which repeatedly
disables and re-enables the eDP across modesets and suspend/resume.

Move the CMTG disable after intel_encoders_disable(), so the eDP-side
teardown (panel unprepare, ALPM disable, backlight off) has completed,
but keep it before intel_encoders_post_disable() and
intel_dpll_disable(). The transcoder timing generator, DDI buffer and
port PLL are therefore still running while CMTG_STATE is polled, and
the requirement to disable CMTG before the transcoder and the port PLL
feeding it are turned off is preserved.

v2:
- Modify commit description regarding PSR exit. [Dibin]
- Add fixes tag. [Jani, Dibin]
v3:
- Add a cover letter with links to v1 and v2 for the review
  history. [Dibin]

Fixes: c588a324183b ("drm/i915/cmtg: Add trigger to enable/disable cmtg")
Signed-off-by: Animesh Manna <animesh.manna@intel.com>
Reviewed-by: Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
Link: https://patch.msgid.link/20261026082906.802048-2-animesh.manna@intel.com
(cherry picked from commit f85fb6e8fd6cf7802285ccd2dbcb631efca8303f)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 10235c728db43..8210dbd6c438d 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1791,15 +1791,22 @@ static void hsw_crtc_disable(struct intel_atomic_state *state,
 		intel_atomic_get_old_crtc_state(state, crtc);
 	struct intel_crtc *pipe_crtc;
 
-	if (crtc->cmtg.enabled && intel_cmtg_is_allowed(old_crtc_state)) {
-		intel_cmtg_set_clk_select(old_crtc_state);
-		intel_cmtg_disable(old_crtc_state);
-	}
 	/*
 	 * FIXME collapse everything to one hook.
 	 * Need care with mst->ddi interactions.
 	 */
 	intel_encoders_disable(state, crtc);
+
+	/*
+	 * Disable CMTG after the encoders are disabled, but before the
+	 * transcoder and port PLL are torn down in
+	 * intel_encoders_post_disable()/intel_dpll_disable().
+	 */
+	if (crtc->cmtg.enabled && intel_cmtg_is_allowed(old_crtc_state)) {
+		intel_cmtg_set_clk_select(old_crtc_state);
+		intel_cmtg_disable(old_crtc_state);
+	}
+
 	intel_encoders_post_disable(state, crtc);
 
 	intel_dpll_disable(old_crtc_state);
-- 
2.53.0



