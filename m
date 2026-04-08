Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD473D9022;
	Wed,  8 Apr 2026 18:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674249; cv=none; b=vCKR3AiGDTuE8Ydi6T0NzYv8HVEJOMJo8SU3tUikHz3qelU6QwKBPwT1Jy/orbV3uKcgPxGXtL0nLpPfR8dzgjFxO8H1R9GHEuktk+1Xq03AgRnMPu4NEqpEpsLvW+ML3LgoIVWJodaapyCXnbQWw/d9RWaUs1kuODf2xf0EyuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674249; c=relaxed/simple;
	bh=00AhJHTGVwkhIpyo2MC4sQewpTYXDd9AfO4zD1rhC1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mxz0jSukWoE47WA6KzzW8fw6Wpc+Vg2DgpOrwQ6hYglI1Rrbt1Upb/w/+iF7rHx+HHSPhJ4xcS1b/n/rAjVNS0YNTIMMSjURyyZJJh3XBlkl4j3jFgm4xIzxlTzZdK+0TrJmDBlkJscEvyrM1D9tTTcCpKvBjiWejurvEV7Ko9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr2doF+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr2doF+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70238C19421;
	Wed,  8 Apr 2026 18:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674249;
	bh=00AhJHTGVwkhIpyo2MC4sQewpTYXDd9AfO4zD1rhC1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr2doF+88kDZOwvC23tc7hj6721/UlaQTVqT7Es6l6xAcsZm269eDbefOCoKc+q6y
	 Sb02OCU25Um+Xq9Goxs3DENpGfldONCEf2tYP/Wf6XXcxBAjpaXrRfBhLVbwVQfSY1
	 2J/Q2pvQWj5cXfYXCx8zJmGNsAzQzRCzGjUOlbtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@kde.org>,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 024/311] drm/amd/display: Fix gamma 2.2 colorop TFs
Date: Wed,  8 Apr 2026 20:00:24 +0200
Message-ID: <20260408175940.315212955@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit b49814033cb5224c818cfb04dccb3260da10cc4f ]

Use GAMMA22 for degamma/blend and GAMMA22_INV for shaper so
curves match the color pipeline.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5016
Tested-by: Xaver Hugl <xaver.hugl@kde.org>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d8f9f42effd767ffa7bbcd7e05fbd6b20737e468)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
index cc124ab6aa7f7..212c13b745d0c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c
@@ -37,19 +37,19 @@ const u64 amdgpu_dm_supported_degam_tfs =
 	BIT(DRM_COLOROP_1D_CURVE_SRGB_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_PQ_125_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_BT2020_INV_OETF) |
-	BIT(DRM_COLOROP_1D_CURVE_GAMMA22_INV);
+	BIT(DRM_COLOROP_1D_CURVE_GAMMA22);
 
 const u64 amdgpu_dm_supported_shaper_tfs =
 	BIT(DRM_COLOROP_1D_CURVE_SRGB_INV_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_PQ_125_INV_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_BT2020_OETF) |
-	BIT(DRM_COLOROP_1D_CURVE_GAMMA22);
+	BIT(DRM_COLOROP_1D_CURVE_GAMMA22_INV);
 
 const u64 amdgpu_dm_supported_blnd_tfs =
 	BIT(DRM_COLOROP_1D_CURVE_SRGB_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_PQ_125_EOTF) |
 	BIT(DRM_COLOROP_1D_CURVE_BT2020_INV_OETF) |
-	BIT(DRM_COLOROP_1D_CURVE_GAMMA22_INV);
+	BIT(DRM_COLOROP_1D_CURVE_GAMMA22);
 
 #define MAX_COLOR_PIPELINE_OPS 10
 
-- 
2.53.0



