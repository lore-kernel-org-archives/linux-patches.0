Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A959B1A072D;
	Tue, 27 Aug 2024 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771603; cv=none; b=kJZht4zsnaHPoogjZdED+gI7RY3XqrXMuyqKIyyBN3usBe8zdGGNcBeSCr1MizwnvTmV/G5muumNt4lo5R8MLdZGb+TVv+rYQQ7xetQWRvzIn4ktSc5vcC7p2Lh5DUCDuNt3qEaeIYqqtLugnl4mK61V7e7Al7QMdIKBqcyWGPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771603; c=relaxed/simple;
	bh=oYwxl/I95TQpu6PM2+iDV90CN4g2sMWqv2MOqREQv7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE66mzrSQ2fspdgBo4k80Tv3uL5+RRK8xYgEdPd5xnvitrDmDkW8i9W5tha74hEq6SaLKM2TuoDyqSlVCgdH6OXG02hzA6bfnBQ7vTsgbxcUoeGN4H1s3K8DX2fu7jWWlT3O4qvObnox8Wzlx/DV9Y358ZDwVs6nphiQYY4rS2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vttlRicM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vttlRicM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B71C61053;
	Tue, 27 Aug 2024 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771603;
	bh=oYwxl/I95TQpu6PM2+iDV90CN4g2sMWqv2MOqREQv7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vttlRicMQ+suLOLitxy8kVk7XADQH2fjkRJ3oX7hNdkxB5WmPbLBiX57VOo9Bx/bM
	 SUYbDhP0cqWHQZ/LDuL3jRGpzncrfvMjCkbK4V4doGREQw3FGtqKVUFhEjXdhrz61O
	 51DbarnG2rkVn/KF+TEQs+dsInBFT081jfe2z/94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 197/273] drm/msm/dpu: limit QCM2290 to RGB formats only
Date: Tue, 27 Aug 2024 16:38:41 +0200
Message-ID: <20240827143840.906948561@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 2db13c4a631505029ada9404e09a2b06a268c1c4 ]

The QCM2290 doesn't have CSC blocks, so it can not support YUV formats
even on ViG blocks. Fix the formats declared by _VIG_SBLK_NOSCALE().

Fixes: 5334087ee743 ("drm/msm: add support for QCM2290 MDSS")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/601048/
Link: https://lore.kernel.org/r/20240627-dpu-virtual-wide-v5-1-5efb90cbb8be@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 9b72977feafa4..e61b5681f3bbd 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -308,8 +308,8 @@ static const u32 wb2_formats_rgb_yuv[] = {
 	{ \
 	.maxdwnscale = SSPP_UNITY_SCALE, \
 	.maxupscale = SSPP_UNITY_SCALE, \
-	.format_list = plane_formats_yuv, \
-	.num_formats = ARRAY_SIZE(plane_formats_yuv), \
+	.format_list = plane_formats, \
+	.num_formats = ARRAY_SIZE(plane_formats), \
 	.virt_format_list = plane_formats, \
 	.virt_num_formats = ARRAY_SIZE(plane_formats), \
 	}
-- 
2.43.0



