Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31683859DF;
	Tue, 10 Mar 2026 11:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141228; cv=none; b=sIRUdHDGahE3rWiTEB1AICOcpzF0f2m5Hf/39NmMjGP4pnofgTf+8FIWM3Hq13wWA3MJt3pR81/9XykKrWZByczVq8CuxGT80pT+fQu3eKmOofBsekypfJlC3I6yyU64qisGFcoemJuHHgS7ulvKrFQ6ET8tKX1OzUSxBCkDLFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141228; c=relaxed/simple;
	bh=q/y8tNWfBbeYXSO0t/ZVDOmywKaGelUvEQ3GXk8kRxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwJBiu5RTKVF1tOnj1VXj/uCxiV1+IhIqdEXD3kkVgmSNN/7uuPM9CWRyLKlUnjsQAXQbZqBL6TlurmvFjU+jse+nMIP7O/2bjo47qs/QGUUHPqkLELj3vIhIr3PfEmB7UIn7RW5SZUBsUxh9cBK2bOWlQG1KYTrCxIZhtVaHD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIKBJ/NW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIKBJ/NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32DEC2BC86;
	Tue, 10 Mar 2026 11:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141228;
	bh=q/y8tNWfBbeYXSO0t/ZVDOmywKaGelUvEQ3GXk8kRxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIKBJ/NW/hZMde1/rB0aWbnW4xjKOlpN4oB0Dm9aXXORfGUuINKC3VvoIDyd/K/Lf
	 KbdcPo0e+n5HTu49Mf869GmWCrC52+vTAZlnNsJ2LzbrkFmxhimUlumCMtKCP1Ad7j
	 SsRMbuQVjxk3asPHoNrVX+d/kmHQnMgzA3cy1/hvdTzeVv8UfTLnCwWOcnFhSBFt6z
	 5YEK7jmoEKrqpRq2IhzIO7TuyLhjJPhb+AeiGgfbUONP3UCaMZOspwdoSS+gt21Zqs
	 YsW0tqmRVwmEByd4uQexbEIemA19jpKQLdMS+GXdfAhqWi39OKtajMXthAhA6lowCk
	 wjkTUd7MI+EfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Hung <alex.hung@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 230/311] drm/amd/display: Use mpc.preblend flag to indicate 3D LUT
Date: Tue, 10 Mar 2026 07:04:37 -0400
Message-ID: <654dc2f413a1019d79a8c941071aee41d003b789.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit c28b3ec3ca034fd1abc832fef46ce36eb13f8fad ]

[WHAT]
New ASIC's 3D LUT is indicated by mpc.preblend.

Fixes: 0de2b1afea8d ("drm/amd/display: add 3D LUT colorop")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 43175f6164d32cb96362d16e357689f74298145c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c   | 6 ++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
index 20a76d81d532d..12c52bffe9964 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -1706,6 +1706,7 @@ __set_dm_plane_colorop_3dlut(struct drm_plane_state *plane_state,
 	struct dc_transfer_func *tf = &dc_plane_state->in_shaper_func;
 	struct drm_atomic_state *state = plane_state->state;
 	const struct amdgpu_device *adev = drm_to_adev(colorop->dev);
+	bool has_3dlut = adev->dm.dc->caps.color.dpp.hw_3d_lut || adev->dm.dc->caps.color.mpc.preblend;
 	const struct drm_device *dev = colorop->dev;
 	const struct drm_color_lut32 *lut3d;
 	uint32_t lut3d_size;
@@ -1722,7 +1723,7 @@ __set_dm_plane_colorop_3dlut(struct drm_plane_state *plane_state,
 	}
 
 	if (colorop_state && !colorop_state->bypass && colorop->type == DRM_COLOROP_3D_LUT) {
-		if (!adev->dm.dc->caps.color.dpp.hw_3d_lut) {
+		if (!has_3dlut) {
 			drm_dbg(dev, "3D LUT is not supported by hardware\n");
 			return -EINVAL;
 		}
@@ -1875,6 +1876,7 @@ amdgpu_dm_plane_set_colorop_properties(struct drm_plane_state *plane_state,
 	struct drm_colorop *colorop = plane_state->color_pipeline;
 	struct drm_device *dev = plane_state->plane->dev;
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	bool has_3dlut = adev->dm.dc->caps.color.dpp.hw_3d_lut || adev->dm.dc->caps.color.mpc.preblend;
 	int ret;
 
 	/* 1D Curve - DEGAM TF */
@@ -1907,7 +1909,7 @@ amdgpu_dm_plane_set_colorop_properties(struct drm_plane_state *plane_state,
 	if (ret)
 		return ret;
 
-	if (adev->dm.dc->caps.color.dpp.hw_3d_lut) {
+	if (has_3dlut) {
 		/* 1D Curve & LUT - SHAPER TF & LUT */
 		colorop = colorop->next;
 		if (!colorop) {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
index a2de3bba83464..cc124ab6aa7f7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
@@ -60,6 +60,7 @@ int amdgpu_dm_initialize_default_pipeline(struct drm_plane *plane, struct drm_pr
 	struct drm_colorop *ops[MAX_COLOR_PIPELINE_OPS];
 	struct drm_device *dev = plane->dev;
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	bool has_3dlut = adev->dm.dc->caps.color.dpp.hw_3d_lut || adev->dm.dc->caps.color.mpc.preblend;
 	int ret;
 	int i = 0;
 
@@ -112,7 +113,7 @@ int amdgpu_dm_initialize_default_pipeline(struct drm_plane *plane, struct drm_pr
 
 	i++;
 
-	if (adev->dm.dc->caps.color.dpp.hw_3d_lut) {
+	if (has_3dlut) {
 		/* 1D curve - SHAPER TF */
 		ops[i] = kzalloc(sizeof(*ops[0]), GFP_KERNEL);
 		if (!ops[i]) {
-- 
2.51.0

