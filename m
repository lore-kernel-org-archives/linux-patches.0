Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1266316F8EF;
	Mon, 28 Oct 2024 06:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098095; cv=none; b=oRftBCdXsvNeH+jTGvIwZfd+KoobjBiOi35CPJ0+I2U8rb7ynwzU3xVPtjTAkgsY6DBqhSZZqPnWLdQ1VEsKEVas00jJgEn64X+b+Vlq7wgG0FPY/CdlukvJCaSPZFoBdY1dGbfV1UNKZaoBt592O3ROywaeLC+iz16o8ok16HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098095; c=relaxed/simple;
	bh=uMMAVXcLVSGT1GShPR0xbPKncF5Zb9+Fm9a1iy9iOx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gg1hgOkrIVjVC/QDPr1iRAliaT/g8xV+ua1xsS7DXLgPVTM7CnUNCH907ydy2bjG8wFMH2kNc0CFe2N8IRWEwjjDuldZEaGJYVnZ8cKtI5if5NT+LgEFO33pG7FRaK4rOLV49Hf7QrkYr+U8ctcyYmAmC4gpZZid0BVNijyX43w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGxyRw6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGxyRw6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A9AC4CEC3;
	Mon, 28 Oct 2024 06:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098094;
	bh=uMMAVXcLVSGT1GShPR0xbPKncF5Zb9+Fm9a1iy9iOx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGxyRw6btdMt8Mn2cEhOWhrMne1NpmqGpFdX595ED80eVG57FFvfpDMEUmWwuA0OP
	 ZPuCYsIm6ez31FRonqaVLZvO1/ziA/iMzP4E6NF1lavEQER13iU+8HLXEL3PImWCtX
	 or0wRh6kpS2CF+BdW7soYWBI3eUUcM+v/XxHTHPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 075/261] drm/msm/dpu: dont always program merge_3d block
Date: Mon, 28 Oct 2024 07:23:37 +0100
Message-ID: <20241028062313.909635607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8864ace938e03..d8a2edebfe8c3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -302,7 +302,7 @@ static void dpu_encoder_phys_vid_setup_timing_engine(
 	intf_cfg.stream_sel = 0; /* Don't care value for video mode */
 	intf_cfg.mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
 	intf_cfg.dsc = dpu_encoder_helper_get_dsc(phys_enc);
-	if (phys_enc->hw_pp->merge_3d)
+	if (intf_cfg.mode_3d && phys_enc->hw_pp->merge_3d)
 		intf_cfg.merge_3d = phys_enc->hw_pp->merge_3d->idx;
 
 	spin_lock_irqsave(phys_enc->enc_spinlock, lock_flags);
-- 
2.43.0



