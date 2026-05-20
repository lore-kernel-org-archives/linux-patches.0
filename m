Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137D33F59D;
	Wed, 20 May 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297169; cv=none; b=Y0/DJygB3cFpXzVcMqfPZ2OWeJGD8V4ZBBHeV5Hjnh1fjQyy1Y0nGCkihm6WfF8IvmOt0Dg8Th8PzxkomwErrhVrH5mvksKINAJf7GBNfqgMK+7clykD4xwXWXEe5TYrDVZ1ql7hUvOtzbNiiU/tq1aUJ7DT80gzrrM4vUjonsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297169; c=relaxed/simple;
	bh=RHkQ/6XUl9TSb/2j5VGW2SirKm+JY2pqEYBttG4jCjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZnq/4Znd5trXLeLOF80KzMeW8B8KbCAp2TMbDBou6pcm0xF7ef+NNXhFJQXPtLYscm6Knzk0da/xCbwATIM4fGVtJ6hYJRmWTKWrcHaUo1vU7yEAdEPTJH6+l7y6IgcyIz5OLhSVATmNyLJ1NOI7QShG5XxD0QVP4MkKF0RXSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykAR/nWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykAR/nWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA3D1F000E9;
	Wed, 20 May 2026 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297167;
	bh=6E/yF+OH3lL3QnDlg9kAftR0IRK8RKqpr7kyJl36sRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykAR/nWcTjczeqgfcFPNdi3yBREMwAE9BLqYAN7jl7pqbg/ZcmUkZk+XX1VBd2e4U
	 AUT75Er4DFoMOQSnVMsnex/0zBU+K5xT90VNHEshrTURK4nHHgR7phO3PMTKGldhK0
	 x/cd2AgpaxzjNRg7ZGLzFrHBS5J7S+u5tUCobodc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DeepChirp <DeepChirp@outlook.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 7.0 1075/1146] drm/i915/dp: Fix VSC dynamic range signaling for RGB formats
Date: Wed, 20 May 2026 18:22:05 +0200
Message-ID: <20260520162212.560714769@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit 1ae15b6c7965d137eef21f2cc7d367b29cb88369 upstream.

For RGB, set dynamic_range to CTA or VESA based on
crtc_state->limited_color_range so sinks apply correct
quantization. YCbCr remains limited (CTA) range.
(DP v1.4, Table 5-1)

v2:
- Added Reported-by and Tested-by tags

v3:
- Add back YCbCr comment(Suraj)

Cc: stable@vger.kernel.org #v5.8+
Reported-by: DeepChirp <DeepChirp@outlook.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/15874
Tested-by: DeepChirp <DeepChirp@outlook.com>
Fixes: 9799c4c3b76e ("drm/i915/dp: Add compute routine for DP VSC SDP")
Assisted-by: GitHub-Copilot:GPT-5.4
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260505090920.2479112-1-chaitanya.kumar.borah@intel.com
(cherry picked from commit 38e10ddae6f8d42a2e8437fcd25a1cac51106c64)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2981,8 +2981,13 @@ static void intel_dp_compute_vsc_colorim
 	drm_WARN_ON(display->drm,
 		    vsc->bpc == 6 && vsc->pixelformat != DP_PIXELFORMAT_RGB);
 
-	/* all YCbCr are always limited range */
-	vsc->dynamic_range = DP_DYNAMIC_RANGE_CTA;
+	/* All YCbCr formats are always limited range. */
+	if (vsc->pixelformat == DP_PIXELFORMAT_RGB)
+		vsc->dynamic_range = crtc_state->limited_color_range ?
+			DP_DYNAMIC_RANGE_CTA : DP_DYNAMIC_RANGE_VESA;
+	else
+		vsc->dynamic_range = DP_DYNAMIC_RANGE_CTA;
+
 	vsc->content_type = DP_CONTENT_TYPE_NOT_DEFINED;
 }
 


