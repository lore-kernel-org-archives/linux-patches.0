Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0638035B653;
	Wed,  8 Apr 2026 18:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673259; cv=none; b=SiJEVVEZL+YKbAUI+CBiwFxPYk69MXKY1WgAlmBJvZU+HvNVeL2MiCkkmlBk8nY5xMNZTr/kHFyA4cwBQHcoar8LDbE93dyS/4AifQ1S2CPOYz6zSrTO1gHAFz2vwyGRKF0sZiuY/Gli6EkTHuiKUikbKAGG3xSyg4z+g1WY0xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673259; c=relaxed/simple;
	bh=6sRItdu/rbrjEyKXlaTupuwbhGEZWVSz4kaISDFc2kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QKjKSNI0oHoKsMKYa9FrsYnRF9zC2q7oXBTfISVl9vh9ePpnQ4bHQy+0bVTCcH+fXR56My0nSPtH4pI6J/KUDfiSZi3EPUtHEvBFH8k8/9Lzmrx2urX5kjAqqB1GyQsCgVHI2HdIVFGIWQce/ctx424/U4xfK0gBXH4sknZOsHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqR0ng6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqR0ng6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9254AC19421;
	Wed,  8 Apr 2026 18:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673258;
	bh=6sRItdu/rbrjEyKXlaTupuwbhGEZWVSz4kaISDFc2kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqR0ng6W99AGdR52E/nGaCoxFCY4E2z1sGruY4bo+vJIDugMjbQrniUQ9QxkBoZ5u
	 7lWFP8zK/Q5lbsXyPwrBrgByjFbTWQq0WFmHPpxN4szGTnzNyil8RgeYNiXMD78L+5
	 DGS+YqKy+mINNYMnnE5tD6UmG3DvcOX6sS8HxmOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 163/277] drm/i915/dp: Use crtc_state->enhanced_framing properly on ivb/hsw CPU eDP
Date: Wed,  8 Apr 2026 20:02:28 +0200
Message-ID: <20260408175939.957264455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 9c9a57e4e337f94e23ddf69263fd0685c91155fb upstream.

Looks like I missed the drm_dp_enhanced_frame_cap() in the ivb/hsw CPU
eDP code when I introduced crtc_state->enhanced_framing. Fix it up so
that the state we program to the hardware is guaranteed to match what
we computed earlier.

Cc: stable@vger.kernel.org
Fixes: 3072a24c778a ("drm/i915: Introduce crtc_state->enhanced_framing")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260325135849.12603-3-ville.syrjala@linux.intel.com
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com>
(cherry picked from commit 799fe8dc2af52f35c78c4ac97f8e34994dfd8760)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/g4x_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/g4x_dp.c
+++ b/drivers/gpu/drm/i915/display/g4x_dp.c
@@ -137,7 +137,7 @@ static void intel_dp_prepare(struct inte
 			intel_dp->DP |= DP_SYNC_VS_HIGH;
 		intel_dp->DP |= DP_LINK_TRAIN_OFF_CPT;
 
-		if (drm_dp_enhanced_frame_cap(intel_dp->dpcd))
+		if (pipe_config->enhanced_framing)
 			intel_dp->DP |= DP_ENHANCED_FRAMING;
 
 		intel_dp->DP |= DP_PIPE_SEL_IVB(crtc->pipe);


