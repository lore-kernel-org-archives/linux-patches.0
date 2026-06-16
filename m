Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEF835AC3E;
	Tue, 16 Jun 2026 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628323; cv=none; b=JsU8AZdFsPLtC5qZVlHYXwZDf2lGIjnqmpU6EQuvV7A5frIs+fwQBj/Ar6WIrVWX7TOeB97VcUYZrCd0d1mLCXnwwV034H9GLIZai7Ss2d82/cMjcmzHqIFg2mSckeWcWkgJHeMZ3Yo78d1P3e0cWPkVk+UkYUz7rWnQfLhz5B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628323; c=relaxed/simple;
	bh=asNNAArjyxfIySpwDt3Cc42mDJSg0ZlHSPi7RyDu2YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfJVrjLiD4m0+QZehMAfYHYhrUN6Urq8/RIq9Knb5/5l8jLDwEzxnAlslidjmBFQ80yZgGnF05qOI1swLb88DGBd6wuYjz5FbFa8qs2wGpv4pgwuCzgGgRMrk3jQqCWiinCsAdy0cUi8oywaYaGfjCKvtLgUN9FVwY/cY2Okd+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYvIkVra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYvIkVra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDDD1F000E9;
	Tue, 16 Jun 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628322;
	bh=ZGljjjpFLSWN+FiRK45u9jda7yyLmirnUfR3l/2PLo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYvIkVraLMpfF0KQFKxmQIfOEj1Sw8N4JH9EEtUekWRGqmH3Qa2+uipoQZhVF+28T
	 oKWQ7vq+Jc3up8pj5TuCkgNNpnFvzaK7XfvV6Kv4dn7G45m5QoCAjrZ9+2uhR1wKc8
	 kfeyAqIt8zVT3KXBs3oz4JC5gq3NOZE9z5UUHP4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/452] drm/i915/psr: Apply Intel DPCD workaround when SDP on prior line used
Date: Tue, 16 Jun 2026 20:24:59 +0530
Message-ID: <20260616145121.699645680@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49842f7877f435..416686a6566bab 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1007,6 +1007,30 @@ static bool psr2_granularity_check(struct intel_dp *intel_dp,
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
@@ -1028,7 +1052,8 @@ static bool _compute_psr2_sdp_prior_scanline_indication(struct intel_dp *intel_d
 		return false;
 
 	crtc_state->req_psr2_sdp_prior_scanline = true;
-	return true;
+
+	return apply_scanline_indication_wa(intel_dp, crtc_state);
 }
 
 static bool _compute_psr2_wake_times(struct intel_dp *intel_dp,
-- 
2.53.0



