Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF673246F4;
	Sun,  7 Jun 2026 10:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827805; cv=none; b=nDvrlhTmBFbbhrhkaXoEpqsrx1qnb7lkvRPjyTf1HfiJL0VPDc0xXuy0xsGGm7Dsecj7oXni8PzgNOujtxPr/uZ9avl0JzugV4IBYQ/d/PLEzboYv++VhRHQqk7CCdegPKLBaqSMtphbbyH/3Il44nl6JXRi3U/X1DSxO/V+ixI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827805; c=relaxed/simple;
	bh=mTDUxBAV56FCPi+4ZGwqPfiq0rV6C6U8Qw/zvYAWDcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IzI32IyA5GKeKuYLqlDqdkHG/v1Je9QDCnZizYsdbg4KatMcpkSm3zAYgJL9HYGfnBn3HoPVDWNj88VQu4RdrzHnihzAC5hoW2AcBiHa8KxN2ZuYipeYsdyj3vYjk7Te6PxHW9Hw73c0BsJ+zsuF7x0NmDi+Bq57dYDoPExHqRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuoOYAIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuoOYAIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7408B1F00893;
	Sun,  7 Jun 2026 10:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827803;
	bh=joQ0SfsAVlHTvLDnBU/o01Hi29gSyXRy7gZuY9JPQBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuoOYAIw06QYuxTWqmU2mINLvgkmzl3EaF0mVuXBxrBHt2h0kntEimb3mGMwbA8cU
	 XuPzPVPq0coXx/A2xRLkqKyYsA7LxOaRTmolmfdmazDNsFhc9SeriHlCSC0SJj5pbz
	 Tvc/KW5TBPvW+nMrjsv0eFPReaENb1qwOTgkg1i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/315] drm/i915/psr: Apply Intel DPCD workaround when SDP on prior line used
Date: Sun,  7 Jun 2026 11:58:09 +0200
Message-ID: <20260607095731.394318870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/i915/display/intel_psr.c | 28 +++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 802a671b2afaaa..eed281b93cd84d 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -29,6 +29,7 @@
 #include <drm/drm_vblank.h>
 
 #include "i915_reg.h"
+#include "i915_utils.h"
 #include "intel_alpm.h"
 #include "intel_atomic.h"
 #include "intel_crtc.h"
@@ -1315,6 +1316,30 @@ static bool psr2_granularity_check(struct intel_dp *intel_dp,
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
@@ -1336,7 +1361,8 @@ static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_d
 		return false;
 
 	crtc_state->req_psr2_sdp_prior_scanline = true;
-	return true;
+
+	return apply_scanline_indication_wa(intel_dp, crtc_state);
 }
 
 static int intel_psr_entry_setup_frames(struct intel_dp *intel_dp,
-- 
2.53.0



