Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114251C5783;
	Tue, 27 Aug 2024 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771496; cv=none; b=liRwi1HSGR7DNcxtnz6jvoDJbt8BALVdghLBVaP7EXcPf05DfjuMxrwlj+kKccDzkYcB2bmnn0vC/X2fjXcxFb8dEaYkICPOTGqYtypUPYZAibSHHj/DqDi1p1QxCZEYw3H9yWJs3t3iu3ld83qfxLRfRlzxMyv8+8Kt1Mc8ivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771496; c=relaxed/simple;
	bh=BNFoQeFeBo4m8jYO0KyQ0fzqxpT+Dsu8o2E+BW9uZsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npq4a/xFijmC6UkHQCahtNKH+bKnJ5alOBqEnhagRN9Ywsg+D1Iwsa/9TMNE1AqRPkNTehIe7sM2//iZAGjYONsjgxQhCJlOfmiYsHxMdmy3+GoRevwrhnOC82nVgEQeHOXEDWR+Wqgl+hc1hiU0bRcQddn6OICP3HUACM7gkRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weNICcNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weNICcNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874E7C4DDEE;
	Tue, 27 Aug 2024 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771495;
	bh=BNFoQeFeBo4m8jYO0KyQ0fzqxpT+Dsu8o2E+BW9uZsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=weNICcNYTLL9a/iv3yMCV17cNoGO85ZiwK+Eghahtxafiv/0F0+fL9c4/p3kpKv80
	 ZGQ78JPko5okrK5wUNbK25QktVVLDKRmDR6lV42+A8mE/7v9EQVZw07SHogfWQ5Jon
	 JmG5d6UEABYivO0Q0j3WGNO9DE1uMqV9hrnXTol0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 198/273] drm/msm/dpu: relax YUV requirements
Date: Tue, 27 Aug 2024 16:38:42 +0200
Message-ID: <20240827143840.944936538@linuxfoundation.org>
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

[ Upstream commit cb18195914e353ece0e789e365a5a16872169805 ]

YUV formats require only CSC to be enabled. Even decimated formats
should not require scaler. Relax the requirement and don't check for the
scaler block while checking if YUV format can be enabled.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/601049/
Link: https://lore.kernel.org/r/20240627-dpu-virtual-wide-v5-2-5efb90cbb8be@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index eabc4813c649c..cbdb9628d962d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -746,10 +746,9 @@ static int dpu_plane_atomic_check_pipe(struct dpu_plane *pdpu,
 	min_src_size = MSM_FORMAT_IS_YUV(fmt) ? 2 : 1;
 
 	if (MSM_FORMAT_IS_YUV(fmt) &&
-	    (!pipe->sspp->cap->sblk->scaler_blk.len ||
-	     !pipe->sspp->cap->sblk->csc_blk.len)) {
+	    !pipe->sspp->cap->sblk->csc_blk.len) {
 		DPU_DEBUG_PLANE(pdpu,
-				"plane doesn't have scaler/csc for yuv\n");
+				"plane doesn't have csc for yuv\n");
 		return -EINVAL;
 	}
 
-- 
2.43.0



