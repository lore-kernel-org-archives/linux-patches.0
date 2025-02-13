Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F05D26B0B5;
	Thu, 13 Feb 2025 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458940; cv=none; b=aHl49Ffxyb6X8WHrhfPZc5bqMEtp55hjztb/4gvN26c3W//CzMEAN8/eRXPjcJ4thrUnrdWHCfgEIb/HbFW7kS6NfVUkXviWXWButBps872Gu1e4S4DXorcp8psMQuSxLfMjkGfzmpaZH5Mp+/tblZXQNF6SUo1Vvibj8YX9g/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458940; c=relaxed/simple;
	bh=4VzVpFww5MjfBuFajq7L85JBSFDOM0vsPvaLmU0/6/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEcO3aBlostX7Xgxl0V88HulCzoI22Oq6mPZUJoaWK/t+6Gs6cSAPE7Pv3wLqpUMnnmpKQYflFZf7+P2nP3RC4O/1054JTCbW/fDxZGmFrNvdzRoanPiq19IxLYGMlzfJnIyQqEz58e+mYABm/+Hwh8FH+bZv9QbNrCSHXG9MIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyIYzO2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyIYzO2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D85C4CED1;
	Thu, 13 Feb 2025 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458940;
	bh=4VzVpFww5MjfBuFajq7L85JBSFDOM0vsPvaLmU0/6/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyIYzO2fPWHA6jfowFeCur+NZks64sT9Xs0ih6PCP2C2i4XSttuISI0fhvsxv/rl+
	 TCSeQDhnaGguBGGkQspbCoJ7s3KdQcxrQ1ppaSjZ71O/bF7ysIN8PfiAaz/vgs7MsB
	 bwOa2g5nJ619eUbveP6SJ2xgBmrrAE0vsBxtq+8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 121/443] drm/i915/dp: fix the Adaptive sync Operation mode for SDP
Date: Thu, 13 Feb 2025 15:24:46 +0100
Message-ID: <20250213142445.281237903@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit 4466302262b38f5e6c65325035b4036a42efc934 ]

Currently we support Adaptive sync operation mode with dynamic frame
rate, but instead the operation mode with fixed rate is set.
This was initially set correctly in the earlier version of changes but
later got changed, while defining a macro for the same.

Fixes: a5bd5991cb8a ("drm/i915/display: Compute AS SDP parameters")
Cc: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Reviewed-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250130051609.1796524-4-mitulkumar.ajitkumar.golani@intel.com
(cherry picked from commit c5806862543ff6c2ad242409fcdf0667eac26dae)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index ff5ba7b3035f3..dfc600ff0b4e7 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2778,7 +2778,6 @@ static void intel_dp_compute_as_sdp(struct intel_dp *intel_dp,
 
 	crtc_state->infoframes.enable |= intel_hdmi_infoframe_enable(DP_SDP_ADAPTIVE_SYNC);
 
-	/* Currently only DP_AS_SDP_AVT_FIXED_VTOTAL mode supported */
 	as_sdp->sdp_type = DP_SDP_ADAPTIVE_SYNC;
 	as_sdp->length = 0x9;
 	as_sdp->duration_incr_ms = 0;
@@ -2789,7 +2788,7 @@ static void intel_dp_compute_as_sdp(struct intel_dp *intel_dp,
 		as_sdp->target_rr = drm_mode_vrefresh(adjusted_mode);
 		as_sdp->target_rr_divider = true;
 	} else {
-		as_sdp->mode = DP_AS_SDP_AVT_FIXED_VTOTAL;
+		as_sdp->mode = DP_AS_SDP_AVT_DYNAMIC_VTOTAL;
 		as_sdp->vtotal = adjusted_mode->vtotal;
 		as_sdp->target_rr = 0;
 	}
-- 
2.39.5



