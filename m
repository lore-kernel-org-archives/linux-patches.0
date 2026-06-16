Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A2044E05B;
	Tue, 16 Jun 2026 15:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624663; cv=none; b=ZRVJibW/qI4Tbcph0Jvoj/KFAZd0SNVF7fWCJGJf+dqIva9ODxw1pyv+T2ul3Tzm/snvr2Z/40OF9d62AryvDHldj1G+EfVyIzgZA2+tKIue63Ji0+i54Rdoxl/EgS7iLerLmPodXjyPokHceDjBSMHb3hcIjDSYCajt6z6i570=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624663; c=relaxed/simple;
	bh=8WOfC5/DOQP1vdXG2hwUh27Q5tg+T93FtDLR2xJk5BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwZiPqrSHH3D+VNG+61xERey4LUjrKkdvonJMAT6gZty8Si5jPeG8FBSee8Dtc9ttxmwf9gevxW2hh5t3CGO3k9Q6JR7PpBPx0sOiqwxK2/3lyScDiqhUh19VtCpjhGEL1sDmy1EDE1PpJkNU2c/MXHNNZrJ7fHYgtqdLkm/GRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEMikakB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEMikakB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87B71F000E9;
	Tue, 16 Jun 2026 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624662;
	bh=z8g4uwPifVcennyRQwGfijDUK/YDIW8yrrV/f3gLWos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEMikakB5GBXm9hRvKstK1gSVibWwf7i3HZvwbkJKocZ1ZJfpn0Kdn5uNafwro5nP
	 D4NfS7IvarS1d1MHVMqWOIWdFX/o00knhZ+mzjXOZxSFfI4B4/PcGC8De1MDmqClHS
	 ZYa5ZyfUFhAnxdUzOe1ccpVM8Xt/Spk2Wh0hl5s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Pranay Samala <pranay.samala@intel.com>
Subject: [PATCH 7.0 334/378] drm/i915: Fix color blob reference handling in intel_plane_state
Date: Tue, 16 Jun 2026 20:29:25 +0530
Message-ID: <20260616145127.803645838@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

commit 26eb7c0a7ab09d83eec833db6a5a2bc60b9d4d9a upstream.

Take proper references for hw color blobs (degamma_lut, gamma_lut,
ctm, lut_3d) in intel_plane_duplicate_state() and drop them in
intel_plane_destroy_state().

v2:
- handle blobs in hw state clear

Cc: <stable@vger.kernel.org> #v6.19+
Fixes: 3b7476e786c2 ("drm/i915/color: Add framework to program PRE/POST CSC LUT")
Fixes: a78f1b6baf4d ("drm/i915/color: Add framework to program CSC")
Fixes: 65db7a1f9cf7 ("drm/i915/color: Add 3D LUT to color pipeline")
Reviewed-by: Pranay Samala <pranay.samala@intel.com> #v1
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patch.msgid.link/20260601082953.128539-4-chaitanya.kumar.borah@intel.com
(cherry picked from commit c6eea1925154b6697fe22b217faab9bb30635e6b)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_plane.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_plane.c
@@ -144,6 +144,15 @@ intel_plane_duplicate_state(struct drm_p
 	if (intel_state->hw.fb)
 		drm_framebuffer_get(intel_state->hw.fb);
 
+	if (intel_state->hw.degamma_lut)
+		drm_property_blob_get(intel_state->hw.degamma_lut);
+	if (intel_state->hw.gamma_lut)
+		drm_property_blob_get(intel_state->hw.gamma_lut);
+	if (intel_state->hw.ctm)
+		drm_property_blob_get(intel_state->hw.ctm);
+	if (intel_state->hw.lut_3d)
+		drm_property_blob_get(intel_state->hw.lut_3d);
+
 	return &intel_state->uapi;
 }
 
@@ -167,6 +176,16 @@ intel_plane_destroy_state(struct drm_pla
 	__drm_atomic_helper_plane_destroy_state(&plane_state->uapi);
 	if (plane_state->hw.fb)
 		drm_framebuffer_put(plane_state->hw.fb);
+
+	if (plane_state->hw.degamma_lut)
+		drm_property_blob_put(plane_state->hw.degamma_lut);
+	if (plane_state->hw.gamma_lut)
+		drm_property_blob_put(plane_state->hw.gamma_lut);
+	if (plane_state->hw.ctm)
+		drm_property_blob_put(plane_state->hw.ctm);
+	if (plane_state->hw.lut_3d)
+		drm_property_blob_put(plane_state->hw.lut_3d);
+
 	kfree(plane_state);
 }
 
@@ -317,6 +336,14 @@ static void intel_plane_clear_hw_state(s
 {
 	if (plane_state->hw.fb)
 		drm_framebuffer_put(plane_state->hw.fb);
+	if (plane_state->hw.degamma_lut)
+		drm_property_blob_put(plane_state->hw.degamma_lut);
+	if (plane_state->hw.gamma_lut)
+		drm_property_blob_put(plane_state->hw.gamma_lut);
+	if (plane_state->hw.ctm)
+		drm_property_blob_put(plane_state->hw.ctm);
+	if (plane_state->hw.lut_3d)
+		drm_property_blob_put(plane_state->hw.lut_3d);
 
 	memset(&plane_state->hw, 0, sizeof(plane_state->hw));
 }


