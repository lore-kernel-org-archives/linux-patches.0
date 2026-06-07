Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A5E32AAD6;
	Sun,  7 Jun 2026 10:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828223; cv=none; b=b9hBJYW4SB9V1HbGHCDgsLCCaRM13cCJsT/IB9t9MjWhMyu06iu2kI/0vgn6XlvFR0/vF1VkJRv80AYUyghphrrGhjCTVbzFTXPcUpmZdQgWfY39swq+DN8c6qqfUHaVdTx7BHo7zGRsSHi0IM7JhelZlQOK+DmaQlZq4fgeV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828223; c=relaxed/simple;
	bh=UCd5hxF3pqSYUdH1tVljfLAOB8ppj0vUw3cQDyHKVn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGXD2UNN8AOTR1psDLSqU6o88uIs7LfIUx6ROLyT15KQhh31CBFWtxWnAtDC8OPuD22RwqruBrYt01ViYQCvLxKU0lu1tArJ+jhIRiPh8eZcM2XsYLqZUgKb4N/oUCYNVsGU7jt5Yf5jIo8MmIENqTN+aWlMObtE7C8JmqBWdLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGT8D6KO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGT8D6KO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB511F00893;
	Sun,  7 Jun 2026 10:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828222;
	bh=1TJOKY8YNYzBgzeKN1qBSzB2ng0tQT23eGCLYl88YHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGT8D6KOLuzXL42KtW3v0OJDHyUnXa5zdbQwXqj1SOY1bm0PuPKcEjLcmyLiAtUu6
	 0qyplDtpWDozI5wP/ZZ/cw+3CKL6PDa3sUnOEasSxJpgWvZIiHj8gXRXjA8eegkFNb
	 hBIjaPSWxAUPzJCNEj6/O02/2mGErCl2WDjJv54o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/307] drm/i915/psr: Apply Intel DPCD workaround when SDP on prior line used
Date: Sun,  7 Jun 2026 11:58:38 +0200
Message-ID: <20260607095732.207036408@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 4703049f768fc1c1caac754134118bee1a3af189 upstream.

There is Intel specific workaround DPCD address containing workaround for
case where SDP is on prior line. Apply this workaround according to values
in the offset.

Fixes: 61e887329e33 ("drm/i915/xelpd: Handle PSR2 SDP indication in the prior scanline")
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260515095756.2799483-4-jouni.hogander@intel.com
(cherry picked from commit c3fe899fbeac86ea4a5ca9dd845b2cbc0da46249)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 27 +++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 9c38b957701675..5173f5759ce888 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1303,6 +1303,30 @@ static bool psr2_granularity_check(struct intel_dp *intel_dp,
 	return true;
 }
 
+static bool apply_scanline_indication_wa(struct intel_dp *intel_dp,
+					 struct intel_crtc_state *crtc_state)
+{
+	u8 early_scanline_support = intel_dp->intel_wa_dpcd &
+		INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_EARLYSCANLINE_SDP_SUPPORT_MASK;
+
+	if (intel_dp->edp_dpcd[0] >= DP_EDP_15)
+		return true;
+
+	switch (early_scanline_support)	{
+	case INTEL_DPCD_INTEL_WA_REGISTER_CAPS_FALL_BACK_TO_PSR1:
+		crtc_state->req_psr2_sdp_prior_scanline = false;
+		return false;
+	case INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_WITH_EARLY_SCANLINE:
+		return true;
+	case INTEL_DPCD_INTEL_WA_REGISTER_CAPS_PSR2_WITHOUT_EARLY_SCANLINE:
+		crtc_state->req_psr2_sdp_prior_scanline = false;
+		return true;
+	default:
+		MISSING_CASE(early_scanline_support);
+		return false;
+	}
+}
+
 static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_dp,
 							struct intel_crtc_state *crtc_state)
 {
@@ -1324,7 +1348,8 @@ static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_d
 		return false;
 
 	crtc_state->req_psr2_sdp_prior_scanline = true;
-	return true;
+
+	return apply_scanline_indication_wa(intel_dp, crtc_state);
 }
 
 static int intel_psr_entry_setup_frames(struct intel_dp *intel_dp,
-- 
2.53.0



