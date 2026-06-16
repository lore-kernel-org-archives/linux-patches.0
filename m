Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63A744104F;
	Tue, 16 Jun 2026 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623508; cv=none; b=HM+p91ZQzKyYRnLUwLMYPGSG0+YYoHEoP/Mk7WNXeEgMheuKY0sgQep63LR5rgA+qjbXAc197dA/eg9S29HDf6TaU04kANUUPyDn/yyJcGqFUOVpEO2/wSeH/RRG1N+uhAF0W8aOdFJh+ZCyq2RtvTJtFGa2EoCE5zGBg2tlbaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623508; c=relaxed/simple;
	bh=pKdO2y/INlBFq25zA9vqkLOzG+fBsq2ZkoV7rPl/SrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxLrUALR2sYSEd+qGbvn2i3Xe6RzsfHqpAg7KxHtx435feNHc6PhUUOQKImXmHPpTFjWPludUVvMDeEMYOVUoWeZyywhMrI+Jj+mX67AfSymev3Nab1lTXT9rjyqOuuN6bcxKMM+94ngkaruNm5oATEeAgVU3N9dI5uwx8XkETs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+fVgxO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+fVgxO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DD21F000E9;
	Tue, 16 Jun 2026 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623507;
	bh=QURLMW48Z19tCNaDIRDp426GRQAzCbey3HVR1hN120k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+fVgxO0wJMYjkFEsaTd9ZfjGqtlSWfnCMGDxWQaoJxK6F2v+F/0i9MPyEAh/sJy2
	 1Sl0zBx8tdCPyJEr20uXTiAE65oK6LG07SWeRCmzbLBipfHQLbrMC8OpYIdZQeoC+v
	 bvmTeWJrOEABOFCievLq8hIUzVsjqCAVE7CdDRf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Alex Hung <alex.hung@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Melissa Wen <melissa.srw@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 161/378] drm/colorop: Remove read-only comments from interpolation fields
Date: Tue, 16 Jun 2026 20:26:32 +0530
Message-ID: <20260616145118.729019106@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit e480228cf65583040c894bb9cc02e1d5b328cee0 ]

The lut1d_interpolation and lut3d_interpolation fields and their
associated properties were marked as read-only, but userspace
can set them via drm_atomic_colorop_set_property().

Fixes: 7fa3ee8c0a79 ("drm/colorop: Define LUT_1D interpolation")
Fixes: db971856bbe0 ("drm/colorop: Add 3D LUT support to color pipeline")
Reviewed-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Fixes: 9ba25915efba ("drm/amd/display: Add support for sRGB EOTF in DEGAM block")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patch.msgid.link/20260609110420.1298352-2-mwen@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_colorop.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/drm/drm_colorop.h b/include/drm/drm_colorop.h
index a3a32f9f918c73..5bcb510e56c0a7 100644
--- a/include/drm/drm_colorop.h
+++ b/include/drm/drm_colorop.h
@@ -296,7 +296,6 @@ struct drm_colorop {
 	/**
 	 * @lut1d_interpolation:
 	 *
-	 * Read-only
 	 * Interpolation for DRM_COLOROP_1D_LUT
 	 */
 	enum drm_colorop_lut1d_interpolation_type lut1d_interpolation;
@@ -304,7 +303,6 @@ struct drm_colorop {
 	/**
 	 * @lut3d_interpolation:
 	 *
-	 * Read-only
 	 * Interpolation for DRM_COLOROP_3D_LUT
 	 */
 	enum drm_colorop_lut3d_interpolation_type lut3d_interpolation;
@@ -312,7 +310,7 @@ struct drm_colorop {
 	/**
 	 * @lut1d_interpolation_property:
 	 *
-	 * Read-only property for DRM_COLOROP_1D_LUT interpolation
+	 * Property for DRM_COLOROP_1D_LUT interpolation
 	 */
 	struct drm_property *lut1d_interpolation_property;
 
@@ -340,7 +338,7 @@ struct drm_colorop {
 	/**
 	 * @lut3d_interpolation_property:
 	 *
-	 * Read-only property for DRM_COLOROP_3D_LUT interpolation
+	 * Property for DRM_COLOROP_3D_LUT interpolation
 	 */
 	struct drm_property *lut3d_interpolation_property;
 
-- 
2.53.0



