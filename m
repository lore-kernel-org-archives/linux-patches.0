Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7466241665;
	Thu, 13 Feb 2025 14:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457448; cv=none; b=PGgyRXTlakE/3+oxsbcNxPoTuI8/CkOaI/4Uq7w0ILOuJZg4p+x7z5y3MXQagqzqShaPtcJBDeoYJratdouwle6OcXi4YfiduukKDpBog32enoMCNaDoSkRabku8AlsURRFTyHcIq03KiNTgC5UhjcdCLyoBpZrJ3B8n3b4u9nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457448; c=relaxed/simple;
	bh=rsIBgcZE1w2KAluVyDJmm9W4hOJx0eQyn+F7VTabLug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSgsxMywFJhA5C8Ei28DByh7jfiG7/fSwWtjiINM+0W+Nw1XLLYVcUH+gU5wa1nDRAY/oHmI9M29OZBSXSTsy0wQDSx5Kd2f9jEn2I7VJqfDQlhLZnvSTCEh6sK0fQjf4JyM7yGmCsg3/U37GVYfTUr52MTezfmRQ6Vi1Nl20AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SwABRSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SwABRSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5487AC4CED1;
	Thu, 13 Feb 2025 14:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457447;
	bh=rsIBgcZE1w2KAluVyDJmm9W4hOJx0eQyn+F7VTabLug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SwABRSb/HH02JnaRT92F+RoHqyV5L+02npk4bSJOsidnnqWHvZdrdCqd/o0HHMus
	 lc9yQ9IZ7oui3WGx+xcM0SY+vL7X0Hza0GNOXU4WGpgPthfsVIwyS7wLmd0AzaxUME
	 eTtf+iH3i8B9wxubyrauWvnQXC7mFQHKhEX2K1GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/422] drm/i915/dp: fix the Adaptive sync Operation mode for SDP
Date: Thu, 13 Feb 2025 15:24:22 +0100
Message-ID: <20250213142440.913983690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 90fa73575feb1..7befd260f5949 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2738,7 +2738,6 @@ static void intel_dp_compute_as_sdp(struct intel_dp *intel_dp,
 
 	crtc_state->infoframes.enable |= intel_hdmi_infoframe_enable(DP_SDP_ADAPTIVE_SYNC);
 
-	/* Currently only DP_AS_SDP_AVT_FIXED_VTOTAL mode supported */
 	as_sdp->sdp_type = DP_SDP_ADAPTIVE_SYNC;
 	as_sdp->length = 0x9;
 	as_sdp->duration_incr_ms = 0;
@@ -2750,7 +2749,7 @@ static void intel_dp_compute_as_sdp(struct intel_dp *intel_dp,
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



