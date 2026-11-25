Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618094;
	b=1q+wUiae7JRDC6MC0l05qsWDhVgAOQsJR1+p4w9lXXd2qc5f9qkQFMProlO7kd6qyVTK
	 RWRfMgWRy5hwZUDsteTpyZmzsT3IX+Rh7jlmTuZa3rnx5DQUbgghuzOWdbHe5jsIhmeTY
	 Jdys80OUvup/w47vvogwQGOyexZBl8OLpuVy6YIwVbs1IIqGwogeafM/hygw1WHIyfpPX
	 UgvLInmZuXQU28WVOI+f4vjv1INqBZ0JdkdfR301Y2QVLOngidF5tTcYxz56Ndx33U3Yu
	 fDqBYWlrRJenrHQNteuczkVtvfEVBkRgmh5gmrEzPLSiz/Zhc/TTcAG14tEk+0nYhfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fwtIf4Z1G2ZUYMTk9hOQu6rqs4TJYX+7EAUblXzf5mU=;
	b=3Y2TLuQPyHr5aEQfkNv1KZo5G8og0RSKkmLdpQE6KFQI1RE2/90xI2QbpsTlzrvuDEK4
	 8nh1DEQMG/zYkxqV0oSJHJfwu3BWDnfhHOrA/JGF4oUho5gAZGzlSuASp0050+sx8C/MP
	 cBx9yaqU3NTnSb8KENOu3mGSsiqg3Q5XY7UIx6B//EYhRV1BzZH9QjY6m+jpXxNGXw6aA
	 zlbDDvMwM2J4aET9Cj53etSfHZY/moBCm116VvxSmroXGPoIMLUY3vBTTLOWyPIc2IHAx
	 qPfo4KJlPpDOiqXvt221g/iM3GmzBNp+NcopZ946lWvyJzO+x6nq/u/ZwLVD+rbG0rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJihtkje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6546F606A31E;
	Wed, 25 Nov 2026 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJihtkje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5B71F000CF;
	Wed, 25 Nov 2026 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618093;
	bh=fwtIf4Z1G2ZUYMTk9hOQu6rqs4TJYX+7EAUblXzf5mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJihtkjebXjkmQR4Gkp7RIGkbHchwoQSR62WooWZh8uCFXHSL42xoN/AMFr4DPK4s
	 vxRNSkpJJ3H0/sZI8yiXipCVJKg91w9f6e3yYG8Mlsp1iMzgcOI8pVt17Y1EMQCslP
	 pUPsiZ+4TPPeApRWccUgBLxIPGWCS24sIPqtVXuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0124/1005] drm/i915/display: Limit NVL TRANS_VTOTAL.Vtotal skip to A-step
Date: Wed, 25 Nov 2026 15:24:22 +0100
Message-ID: <20261125143824.645319021@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit f704594d36809780cf41fb201729dc1ac352c5d4 ]

The hardware issue which required us to keep vtotal as 0 has since been
fixed on B0 well, so applying the workaround there is no longer correct
and causes issues on B-stepping.
Restrict the workaround to A-step only, in both transcoder timing paths
and in the crtc_vtotal readout fixup in intel_vrr_get_config().

Fixes: a78d11e7859b ("drm/i915/display: Skip TRANS_VTOTAL.Vtotal write on NVL pre-C0")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Mitul Golani<mitulkumar.ajitkumar.golani@intel.com>
Link: https://patch.msgid.link/20261022040528.1403569-1-suraj.kandpal@intel.com
(cherry picked from commit b749007b1ed67bc5482d15d3a1f6fe74555a81df)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 4 ++--
 drivers/gpu/drm/i915/display/intel_vrr.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 9dfd095f325f7..10235c728db43 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -2779,7 +2779,7 @@ void intel_set_transcoder_timings(const struct intel_crtc_state *crtc_state,
 		       HSYNC_END(adjusted_mode->crtc_hsync_end - 1));
 
 	if (display->platform.novalake &&
-	    IS_DISPLAY_STEP(display, STEP_A0, STEP_C0))
+	    IS_DISPLAY_STEP(display, STEP_A0, STEP_B0))
 		crtc_vtotal = 1;
 
 	intel_de_write(display, TRANS_VTOTAL(display, transcoder),
@@ -2876,7 +2876,7 @@ void intel_set_transcoder_timings_lrr(const struct intel_crtc_state *crtc_state,
 	 * is the transcoder's undelayed vblank.
 	 */
 	if (display->platform.novalake &&
-	    IS_DISPLAY_STEP(display, STEP_A0, STEP_C0))
+	    IS_DISPLAY_STEP(display, STEP_A0, STEP_B0))
 		crtc_vtotal = 1;
 
 	intel_de_write(display, TRANS_VTOTAL(display, transcoder),
diff --git a/drivers/gpu/drm/i915/display/intel_vrr.c b/drivers/gpu/drm/i915/display/intel_vrr.c
index cfc0cfbff017a..6e03122743967 100644
--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -1110,7 +1110,7 @@ void intel_vrr_get_config(struct intel_crtc_state *crtc_state)
 		}
 
 		if (display->platform.novalake &&
-		    IS_DISPLAY_STEP(display, STEP_A0, STEP_C0))
+		    IS_DISPLAY_STEP(display, STEP_A0, STEP_B0))
 			crtc_state->hw.adjusted_mode.crtc_vtotal =
 				intel_vrr_vmin_vtotal(crtc_state);
 
-- 
2.53.0



