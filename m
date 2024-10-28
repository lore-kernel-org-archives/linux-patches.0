Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626018EFC9;
	Mon, 28 Oct 2024 06:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097231; cv=none; b=tu+yH+edR9JKUowK7lSYnaK7niehakbOeGnHR9dzocBLVM4qIAkkfJ7KmFcReaRH/KU1CE3bFOI+CCS810DxzdaiKDcr0vBI+lH8f8+fEbx7NvhQ1hH5c6kj+Hk5rILxXopRlyvFczGaJfrSEVFAoS75ednwIXadfp6Qk7jNwus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097231; c=relaxed/simple;
	bh=cy5zIdtL1eoFZ2EMbvck4gAalv3mTtoyXCGjAmY5YoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj6nu0WrI1SgBmr/QdRrIfMkpsd2LkbDsuxVzPDGP+yzVT2PQaH5YimFg4GrWLIrhobGmQJKSIOnwHcvFHyKxWpX09YTB4QKcZ44TqOuJ0bHHs/wYFQSms3arjfrs8dSv3Em+ocIjc6ROKutnKruXfmJWejVolpjIFT82Jsw8YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/xunpH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/xunpH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1835C4CEC7;
	Mon, 28 Oct 2024 06:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097231;
	bh=cy5zIdtL1eoFZ2EMbvck4gAalv3mTtoyXCGjAmY5YoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/xunpH4Dl/lrj5SwXxpQTijf/A9eMMujhx+1quNUVCkdAc8ciWDRh4VI1ddQmYtJ
	 4U5Tm1h/bdlzqYTZzAsRBb7NfPkj3RiRoFeB8LeXMaw56s51j9YHGL4LtgmgADVGKk
	 LK4pZ9vZy6nBSFiJFJbi+qE9Et9LDaj/mRKrSugw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/137] drm/msm/dpu: dont always program merge_3d block
Date: Mon, 28 Oct 2024 07:24:38 +0100
Message-ID: <20241028062259.871777508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit f87f3b80abaf7949e638dd17dfdc267066eb52d5 ]

Only program the merge_3d block for the video phys encoder when the 3d
blend mode is not NONE

Fixes: 3e79527a33a8 ("drm/msm/dpu: enable merge_3d support on sm8150/sm8250")
Suggested-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/619095/
Link: https://lore.kernel.org/r/20241009-merge3d-fix-v1-1-0d0b6f5c244e@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index 9232c646747dc..aba2488c32fa1 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -277,7 +277,7 @@ static void dpu_encoder_phys_vid_setup_timing_engine(
 	intf_cfg.stream_sel = 0; /* Don't care value for video mode */
 	intf_cfg.mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
 	intf_cfg.dsc = dpu_encoder_helper_get_dsc(phys_enc);
-	if (phys_enc->hw_pp->merge_3d)
+	if (intf_cfg.mode_3d && phys_enc->hw_pp->merge_3d)
 		intf_cfg.merge_3d = phys_enc->hw_pp->merge_3d->idx;
 
 	spin_lock_irqsave(phys_enc->enc_spinlock, lock_flags);
-- 
2.43.0



