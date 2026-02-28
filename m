Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BFC375AAB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301753; cv=none; b=MNRJJtZrXxO06rLnIEj/WGdBlBK6Iya37MaDq9Tk3j8T7rUKnsoVnbJ9K+zwBhBbn9H8/4fd8AhMcuYV+JdpE2GoYQkl7Dx1Y1grj9QOo54rWP4gwkghtI6uIK5RjC/i0LaPGckEHhxZ1A6JFzFrUYLcUZmUL0FPaU7iF4rJcEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301753; c=relaxed/simple;
	bh=+ZVP6EIyE6lXd55iweAzyBma49OThhDRPeRC4mflIbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYyMoq/Mo/rO45B5Zmun/wXWnQH3u7D6OmWrLnXoho3v+2oXhIInI94YFYqNu5eux1FwRq/1zx6ps8mPZZHigRP9gw6nq28MehpP/IH+QSmiWY2bjD4Aw4/Uu/KkjPy43P/sI8SH6z31C2+8ximRl0xy3DDNGoKBGUQSNixn1cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PY226hu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PY226hu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB17C19425;
	Sat, 28 Feb 2026 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301752;
	bh=+ZVP6EIyE6lXd55iweAzyBma49OThhDRPeRC4mflIbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PY226hu0bHm5/gvKNYERutcpYBcQpW0oKKilC25zJVhXiOs5L+yB3VJGZIPm8qIQO
	 Yj8JNpKP4OljonJSLxyjXvGQlNDAbZW2nYRUoXF7vtpFIsSNlH4rF2XaECB8fu6EwC
	 VAvuEh1ePpnx+P4WmNE1WVcGW3e6wiWrKV6MK94o2+OlzNk97Q+AyBj15aNDGsQeMp
	 zUlXVSZ7Id15pzCxYLxW6uXzXRZZM2+DwFEabPvVVTpss8Yjgni5sje7CuJ2XphZat
	 IWxpJqD3hD6IUzzc5hXWll2ZNlqL6jGcKs6Qju9wEfbK24kqet3Ip27sUkSGaVXU26
	 j6gTnX6BHCC9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/385] drm/msm/disp: set num_planes to 1 for interleaved YUV formats
Date: Sat, 28 Feb 2026 12:56:18 -0500
Message-ID: <20260228180011.1568201-156-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 6421e1c5075b7e1536a8fcbe6b4086db07103048 ]

Interleaved YUV formats use only one plane for all pixel data. Specify
num_planes = 1 for those formats. This was left unnoticed since
_dpu_format_populate_plane_sizes_linear() overrides layout->num_planes.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Reviewed-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/688162/
Link: https://lore.kernel.org/r/20251114-dpu-formats-v3-1-cae312379d49@oss.qualcomm.com
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcm6490-fairphone-fp5
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp_format.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp_format.c b/drivers/gpu/drm/msm/disp/mdp_format.c
index 426782d50cb49..eebedb1a2636e 100644
--- a/drivers/gpu/drm/msm/disp/mdp_format.c
+++ b/drivers/gpu/drm/msm/disp/mdp_format.c
@@ -479,25 +479,25 @@ static const struct msm_format mdp_formats[] = {
 		0, BPC8, BPC8, BPC8,
 		C2_R_Cr, C0_G_Y, C1_B_Cb, C0_G_Y,
 		false, CHROMA_H2V1, 4, 2, MSM_FORMAT_FLAG_YUV,
-		MDP_FETCH_LINEAR, 2),
+		MDP_FETCH_LINEAR, 1),
 
 	INTERLEAVED_YUV_FMT(UYVY,
 		0, BPC8, BPC8, BPC8,
 		C1_B_Cb, C0_G_Y, C2_R_Cr, C0_G_Y,
 		false, CHROMA_H2V1, 4, 2, MSM_FORMAT_FLAG_YUV,
-		MDP_FETCH_LINEAR, 2),
+		MDP_FETCH_LINEAR, 1),
 
 	INTERLEAVED_YUV_FMT(YUYV,
 		0, BPC8, BPC8, BPC8,
 		C0_G_Y, C1_B_Cb, C0_G_Y, C2_R_Cr,
 		false, CHROMA_H2V1, 4, 2, MSM_FORMAT_FLAG_YUV,
-		MDP_FETCH_LINEAR, 2),
+		MDP_FETCH_LINEAR, 1),
 
 	INTERLEAVED_YUV_FMT(YVYU,
 		0, BPC8, BPC8, BPC8,
 		C0_G_Y, C2_R_Cr, C0_G_Y, C1_B_Cb,
 		false, CHROMA_H2V1, 4, 2, MSM_FORMAT_FLAG_YUV,
-		MDP_FETCH_LINEAR, 2),
+		MDP_FETCH_LINEAR, 1),
 
 	/* 3 plane YUV */
 	PLANAR_YUV_FMT(YUV420,
-- 
2.51.0

