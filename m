Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76EB361DB5;
	Wed,  8 Apr 2026 18:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673916; cv=none; b=kVb4KDYl5VR9qlTI0zuBULutGXfHKbb3NztxmzYvOpQsdnDdqDHwGwp2UzA6GptdHKf7FmolesFvs2rOO9Fha4vz/az/7gBlDbwpAuXNaIVGSVOHmLGio5Cl8aD0e2LASj7pHsTkS6q7/FHxDd6u5y2cACOJ9FyyTsEYOOc31hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673916; c=relaxed/simple;
	bh=MtlpGGwKwboCGr+f491B43fbiBGxwKd+2GQi4EEjXd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHyQRp5nwfYPyUWGgc90bH7XOVbJlaVGJ8itC7h8m0sSAhAkyfLqYAXzEYDBdaLGQmvs9TAPVqoG8Dv56mvCONIn9gi4VKYu+SbZcnXvenxNVKnNlUQMYDu3b0rjrK6DpAzd72ay5bXDyRVKmG7u92YcF8O5uwjtupOytGWpo7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbN62kjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbN62kjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDCFC19421;
	Wed,  8 Apr 2026 18:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673916;
	bh=MtlpGGwKwboCGr+f491B43fbiBGxwKd+2GQi4EEjXd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbN62kjWKWGmLCbVWZjxQYIHEtjmZRFY3pSuql9VPRMzZFvLkoyTxNEWSi9o24tpT
	 Eh9YnBlW9a6bp7FNVTKVnjSqwpHC8JVWkdEFrRHKRRxsJ5HOeKqvG83XQm3uagAC2+
	 L5XRbsrEPptm9GdHRjCx3WVS+GzS30bbyGgMOPII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.12 137/242] drm/i915/dp: Use crtc_state->enhanced_framing properly on ivb/hsw CPU eDP
Date: Wed,  8 Apr 2026 20:02:57 +0200
Message-ID: <20260408175932.216501174@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
@@ -134,7 +134,7 @@ static void intel_dp_prepare(struct inte
 			intel_dp->DP |= DP_SYNC_VS_HIGH;
 		intel_dp->DP |= DP_LINK_TRAIN_OFF_CPT;
 
-		if (drm_dp_enhanced_frame_cap(intel_dp->dpcd))
+		if (pipe_config->enhanced_framing)
 			intel_dp->DP |= DP_ENHANCED_FRAMING;
 
 		intel_dp->DP |= DP_PIPE_SEL_IVB(crtc->pipe);


