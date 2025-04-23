Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673AD2918F6;
	Wed, 23 Apr 2025 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421576; cv=none; b=DwYue+l1og9hvNYkf3p2iPCIY8pigC6alX2SF1y5PJ9r0swdYyVCoKM/BHltGl3mlvwnYYXXspwhUKPcpxHfmfmUPSRhmNql/XesUcveCS6+RWzeFuQsDTiDS2UNaK1fqTl3wUm09iRf/TUdju1O2uePqkek0m1xZJzIqwN9CKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421576; c=relaxed/simple;
	bh=ZGGn0ZSJlIvMUUy9v9pLApzdZz1TQqntaQ0d/6PGFQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ls5g+rpTUTBq1IjPZe0URWnRt1fkJl0XRnTmRdL1YPj5Pj6PK/ngnKnM9vbDJpVeNHDgwYv7ZM21BqqZvLBQQn34KkhfvyuWhSsG1X6Jy3blj9qZH+6C12sOn9UiS5coDbFvJbsP4t0MyrCAlDXHJevwTohOkFEQ3jqDjOVQ51I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5YpQBEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5YpQBEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA546C4CEE2;
	Wed, 23 Apr 2025 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421576;
	bh=ZGGn0ZSJlIvMUUy9v9pLApzdZz1TQqntaQ0d/6PGFQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5YpQBEn0xV2hYqg4O4EUAU7C9oybQRpMVxBlL3DyZzDe0Lfw0nBQgUdEkXO6Lrzx
	 HiJLnGMICQ1XDn3M0lTMRpMMn1t6WDQNHESf4cqFnAfHLWgL50X1VI69bHNThykn83
	 4IUdXM3XV3XzMnL82Tl+SIwi6+D9a1aOR79JycsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.14 207/241] drm/i915/dp: Reject HBR3 when sink doesnt support TPS4
Date: Wed, 23 Apr 2025 16:44:31 +0200
Message-ID: <20250423142628.996295699@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 584cf613c24a4250d9be4819efc841aa2624d5b6 upstream.

According to the DP spec TPS4 is mandatory for HBR3. We have
however seen some broken eDP sinks that violate this and
declare support for HBR3 without TPS4 support.

At least in the case of the icl Dell XPS 13 7390 this results
in an unstable output.

Reject HBR3 when TPS4 supports is unavailable on the sink.

v2: Leave breadcrumbs in dmesg to avoid head scratching (Jani)

Cc: stable@vger.kernel.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/5969
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250306210740.11886-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 38188a7f575dacba1120a59fd5d62c7f3313c0fa)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |   49 +++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -172,10 +172,28 @@ int intel_dp_link_symbol_clock(int rate)
 
 static int max_dprx_rate(struct intel_dp *intel_dp)
 {
+	struct intel_display *display = to_intel_display(intel_dp);
+	struct intel_encoder *encoder = &dp_to_dig_port(intel_dp)->base;
+	int max_rate;
+
 	if (intel_dp_tunnel_bw_alloc_is_enabled(intel_dp))
-		return drm_dp_tunnel_max_dprx_rate(intel_dp->tunnel);
+		max_rate = drm_dp_tunnel_max_dprx_rate(intel_dp->tunnel);
+	else
+		max_rate = drm_dp_bw_code_to_link_rate(intel_dp->dpcd[DP_MAX_LINK_RATE]);
 
-	return drm_dp_bw_code_to_link_rate(intel_dp->dpcd[DP_MAX_LINK_RATE]);
+	/*
+	 * Some broken eDP sinks illegally declare support for
+	 * HBR3 without TPS4, and are unable to produce a stable
+	 * output. Reject HBR3 when TPS4 is not available.
+	 */
+	if (max_rate >= 810000 && !drm_dp_tps4_supported(intel_dp->dpcd)) {
+		drm_dbg_kms(display->drm,
+			    "[ENCODER:%d:%s] Rejecting HBR3 due to missing TPS4 support\n",
+			    encoder->base.base.id, encoder->base.name);
+		max_rate = 540000;
+	}
+
+	return max_rate;
 }
 
 static int max_dprx_lane_count(struct intel_dp *intel_dp)
@@ -4188,6 +4206,9 @@ static void intel_edp_mso_init(struct in
 static void
 intel_edp_set_sink_rates(struct intel_dp *intel_dp)
 {
+	struct intel_display *display = to_intel_display(intel_dp);
+	struct intel_encoder *encoder = &dp_to_dig_port(intel_dp)->base;
+
 	intel_dp->num_sink_rates = 0;
 
 	if (intel_dp->edp_dpcd[0] >= DP_EDP_14) {
@@ -4198,10 +4219,7 @@ intel_edp_set_sink_rates(struct intel_dp
 				 sink_rates, sizeof(sink_rates));
 
 		for (i = 0; i < ARRAY_SIZE(sink_rates); i++) {
-			int val = le16_to_cpu(sink_rates[i]);
-
-			if (val == 0)
-				break;
+			int rate;
 
 			/* Value read multiplied by 200kHz gives the per-lane
 			 * link rate in kHz. The source rates are, however,
@@ -4209,7 +4227,24 @@ intel_edp_set_sink_rates(struct intel_dp
 			 * back to symbols is
 			 * (val * 200kHz)*(8/10 ch. encoding)*(1/8 bit to Byte)
 			 */
-			intel_dp->sink_rates[i] = (val * 200) / 10;
+			rate = le16_to_cpu(sink_rates[i]) * 200 / 10;
+
+			if (rate == 0)
+				break;
+
+			/*
+			 * Some broken eDP sinks illegally declare support for
+			 * HBR3 without TPS4, and are unable to produce a stable
+			 * output. Reject HBR3 when TPS4 is not available.
+			 */
+			if (rate >= 810000 && !drm_dp_tps4_supported(intel_dp->dpcd)) {
+				drm_dbg_kms(display->drm,
+					    "[ENCODER:%d:%s] Rejecting HBR3 due to missing TPS4 support\n",
+					    encoder->base.base.id, encoder->base.name);
+				break;
+			}
+
+			intel_dp->sink_rates[i] = rate;
 		}
 		intel_dp->num_sink_rates = i;
 	}


