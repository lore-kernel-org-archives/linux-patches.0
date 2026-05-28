Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC91C2FD7C3;
	Thu, 28 May 2026 20:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998778; cv=none; b=jqNCqZk9A0RBxH0Vj8M3MBlseG9eKWBpsO4ORzxlJ+8c06Z0pRws1PobAsjuTOeltO+WS7PfMzY1zo2VDxF+6+8dDqrSj2WmDrgK+kl9qdOmI08DDyJcShAJtRwAOx6PpYQUc2x5pjT74Hj8GTnwHh7386CTvYjCPQ8puyLAEo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998778; c=relaxed/simple;
	bh=Yl/diFDeOqC9hERiPHE85n5lZphmcp0V1RqWfbhcchA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBPOK4jspSrstjF7UyYGp0tudJu4tEKvb7d/hSlvX51yu74BFBpzCA1h6YSJEm/vHqAKA9wmRDcAYjYRxqnmO5GkQJWrVQNNobobR1HOL3+tv0wHjC36gdbrYcK8O12ukqvpCMimmh1jLob1lbglgKAiQtMhKWNFvwjmveoP+5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kE6lKUw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kE6lKUw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242BE1F000E9;
	Thu, 28 May 2026 20:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998777;
	bh=JrgeJwQvfwWwTJbNPyR+DeddSJ5NH9RzL7oeLVX2iWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kE6lKUw8ZW5vSyg6gypW6sskw8KG9HMHfdlLge2ypASahIkVSrc9X41I8zn/ytwJo
	 3Xl0P1T/H33PEvtGmD4bwJrk5tk1QHDkfFnnRkXDnx9rhZsmSzYae2YBwXLB4X7tt2
	 F0b5HyTjVUUPPMcGHzpJG7UE34jFCizPGaFgOPB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 294/461] drm/msm/dpu: fix UV scanlines calculation for YUV UBWC formats
Date: Thu, 28 May 2026 21:47:03 +0200
Message-ID: <20260528194655.727931432@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 933430f1709b089a0bf0b23ef0f047014ef899e7 ]

The UV scanlines is calculated with (height + 1) / 2 unlike
the Y scanlines, add back the correct scanlines calculation
for UBWC YUV formats.

Fixes: 2f3ff6ab8f5c ("drm/msm/dpu: use standard functions in _dpu_format_populate_plane_sizes_ubwc()")
Fixes: ada4a19ed21c ("drm/msm/dpu: rewrite _dpu_format_populate_plane_sizes_ubwc()")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/718309/
Link: https://lore.kernel.org/r/20260414-topic-sm8x50-msm-dpu1-formats-qc10c-v1-1-0b62325b9030@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
index 6e8883dbfad43..590922c4f69bf 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
@@ -61,7 +61,7 @@ static int _dpu_format_populate_plane_sizes_ubwc(
 	bool meta = MSM_FORMAT_IS_UBWC(fmt);
 
 	if (MSM_FORMAT_IS_YUV(fmt)) {
-		unsigned int stride, sclines;
+		unsigned int stride, y_sclines, uv_sclines;
 		unsigned int y_tile_width, y_tile_height;
 		unsigned int y_meta_stride, y_meta_scanlines;
 		unsigned int uv_meta_stride, uv_meta_scanlines;
@@ -77,23 +77,25 @@ static int _dpu_format_populate_plane_sizes_ubwc(
 				y_tile_width = 32;
 			}
 
-			sclines = round_up(fb->height, 16);
+			y_sclines = round_up(fb->height, 16);
+			uv_sclines = round_up((fb->height+1)>>1, 16);
 			y_tile_height = 4;
 		} else {
 			stride = round_up(fb->width, 128);
 			y_tile_width = 32;
 
-			sclines = round_up(fb->height, 32);
+			y_sclines = round_up(fb->height, 32);
+			uv_sclines = round_up((fb->height+1)>>1, 32);
 			y_tile_height = 8;
 		}
 
 		layout->plane_pitch[0] = stride;
 		layout->plane_size[0] = round_up(layout->plane_pitch[0] *
-			sclines, DPU_UBWC_PLANE_SIZE_ALIGNMENT);
+			y_sclines, DPU_UBWC_PLANE_SIZE_ALIGNMENT);
 
 		layout->plane_pitch[1] = stride;
 		layout->plane_size[1] = round_up(layout->plane_pitch[1] *
-			sclines, DPU_UBWC_PLANE_SIZE_ALIGNMENT);
+			uv_sclines, DPU_UBWC_PLANE_SIZE_ALIGNMENT);
 
 		if (!meta)
 			return 0;
-- 
2.53.0



