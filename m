Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B50D28640C;
	Wed, 25 Feb 2026 01:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983932; cv=none; b=WEzbwGenUeofLosslgamdBQYQZ8gJ/iaJn7Piw+0FlLX8w5w5CD8sJ4AL1HwI5NpNq99QxqN6GsMiQyzOlhrehS4PpeLfZ4TZaomF24YpNC6YGcXyd2iu6BqpT2nf1rEl9dpldBHqWS5Lnfxzl1tGQkkvm3/Hhoky4VhghhbEIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983932; c=relaxed/simple;
	bh=ruYe3W/FnP6B29Rh5qy6Jg3QwttutZefAaIaOHhZfkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KohJ1SWDE2NlN+If/N3vAi4S+jiFkqKCJSkQWtH3uDLD+ZvZpVuRLXGXsFrLE4pBLOYSXroBybAsLxCM1j52J5QGWNSewlrwRGkBMNKcDNR3Lpwm0Y5ODLzlVXptT17/Oc/L30jU2I/6lJGqv2QB9dEezVH/oyXvIkILeC25WJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lu0BBioe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lu0BBioe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1E6C116D0;
	Wed, 25 Feb 2026 01:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983932;
	bh=ruYe3W/FnP6B29Rh5qy6Jg3QwttutZefAaIaOHhZfkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lu0BBioeQWxQj7FFYm7IwAr0vypMgAtyG1+qpIFsYurhDP1gn2ENtdusFrq7vPR7Q
	 j7ab73G1uinqG1xqlRzDT3EmkZi2KEKUc9JKaQICDqQ0etCWQgbvbGEabcLpQC7eMU
	 TdnExq/fD/1EGBHRrP66Z9ulWpRD9tbDwcpSKf0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.18 198/641] drm/msm/disp: set num_planes to 1 for interleaved YUV formats
Date: Tue, 24 Feb 2026 17:18:44 -0800
Message-ID: <20260225012353.779455660@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



