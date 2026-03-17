Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0053EBF20;
	Tue, 17 Mar 2026 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765565; cv=none; b=Ctkhh+2ACNMyohSddu1By/T7cmu5K9VO63ro3i8TMieqBoFqFM8HMfiQHWksdJJVVWmkoYQGUGPcdWVPkY1Qd/wK+YH96NlVYk4dK0Tpi+LNc9SYTxGGaUgw498EF3mYOmmrkIgyjNpFvMKdNYzqneF4s0lIWD4QMdie1n0uLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765565; c=relaxed/simple;
	bh=lfI2g9OQRSuuRfm3uCjRWEGHPNyEp/SLAmNz4kwjjSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTKzCTXf/8zHfffELYESamX0l7W9K7UoPY3AhLBqYtCOe0OahfHBKDN1rWefmFx65o0UqLLrfhelyJsR4uZK2HZ7fIg1BRJdxi5ECdtnEx4FeJAZKbs1r5WpjF1D4XvXrKTpcjlZkIBkaqPcgzhz1DkfURNPZSk/g6Vd427QQfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOJ2cvDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOJ2cvDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED113C4CEF7;
	Tue, 17 Mar 2026 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765565;
	bh=lfI2g9OQRSuuRfm3uCjRWEGHPNyEp/SLAmNz4kwjjSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOJ2cvDN9XAwl02wV+LcAfSW1bPtM+v4aRuXv343D09DGppDofpoJ1fhj0pEEf4KA
	 KwjrYyrBi2E2E2ecXMWhWzqgRztkL+dpHR827q0nB7E5f6wdtv7DUIGEGiI2PPS404
	 3hdGks2eVRJigI53kGGQV08tiHKO5wOcuXV+iKY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 040/378] drm/amdgpu: Fix kernel-doc comments for some LUT properties
Date: Tue, 17 Mar 2026 17:29:57 +0100
Message-ID: <20260317163008.460235424@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 52289ce48ef1f8a81cd39df1574098356e3c9d4c ]

The following members of struct amdgpu_mode_info do not have valid
references in the related kernel-doc sections:

 - plane_shaper_lut_property
 - plane_shaper_lut_size_property,
 - plane_lut3d_size_property

Correct all affected comment blocks.

Fixes: f545d82479b4 ("drm/amd/display: add plane shaper LUT and TF driver-specific properties")
Fixes: 671994e3bf33 ("drm/amd/display: add plane 3D LUT driver-specific properties")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ec5708d6e547f7efe2f009073bfa98dbc4c5c2ac)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
index dc8d2f52c7d61..e244c12ceb238 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
@@ -368,15 +368,15 @@ struct amdgpu_mode_info {
 
 	struct drm_property *plane_ctm_property;
 	/**
-	 * @shaper_lut_property: Plane property to set pre-blending shaper LUT
-	 * that converts color content before 3D LUT. If
-	 * plane_shaper_tf_property != Identity TF, AMD color module will
+	 * @plane_shaper_lut_property: Plane property to set pre-blending
+	 * shaper LUT that converts color content before 3D LUT.
+	 * If plane_shaper_tf_property != Identity TF, AMD color module will
 	 * combine the user LUT values with pre-defined TF into the LUT
 	 * parameters to be programmed.
 	 */
 	struct drm_property *plane_shaper_lut_property;
 	/**
-	 * @shaper_lut_size_property: Plane property for the size of
+	 * @plane_shaper_lut_size_property: Plane property for the size of
 	 * pre-blending shaper LUT as supported by the driver (read-only).
 	 */
 	struct drm_property *plane_shaper_lut_size_property;
@@ -400,10 +400,10 @@ struct amdgpu_mode_info {
 	 */
 	struct drm_property *plane_lut3d_property;
 	/**
-	 * @plane_degamma_lut_size_property: Plane property to define the max
-	 * size of 3D LUT as supported by the driver (read-only). The max size
-	 * is the max size of one dimension and, therefore, the max number of
-	 * entries for 3D LUT array is the 3D LUT size cubed;
+	 * @plane_lut3d_size_property: Plane property to define the max size
+	 * of 3D LUT as supported by the driver (read-only). The max size is
+	 * the max size of one dimension and, therefore, the max number of
+	 * entries for 3D LUT array is the 3D LUT size cubed.
 	 */
 	struct drm_property *plane_lut3d_size_property;
 	/**
-- 
2.51.0



