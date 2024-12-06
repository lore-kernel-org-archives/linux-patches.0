Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35236149E0E;
	Fri,  6 Dec 2024 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497132; cv=none; b=F24zuM/sqhs8uGLmSNUl3kImyj6KRAh2E1Bvo9uAs234Zskm/hM1yF9YS3kB5y8U+wEXJ8BjXFug2L+ZESA7HcAgyfo0dY7TfBBizuOFvfkvpqFhs/lCJ4SJsve99y7/H8dKzqhc+tbs9rsHru2/oh0c+98Jmt1xjXR3NX6Q5+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497132; c=relaxed/simple;
	bh=xzwYor73umRPDs6NrjRvKbsRYulXiNigLQfKx4PE/x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9GY3varCweFsZtr5lg+tSVA0ASRjBxt7ITPE+Kqemklzn1F9OmpaX0iedhtSafM1cAL7LfRVqgpKhW00lunKtK12J51ov8rxCFAshRNGBvZdRWG9pXUezhw5aAPEkbvAT6624YgGbMf8DeX2OghPTxIOhEebHd29PI4z382tH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWbwUjEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWbwUjEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A5EC4CED1;
	Fri,  6 Dec 2024 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497132;
	bh=xzwYor73umRPDs6NrjRvKbsRYulXiNigLQfKx4PE/x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWbwUjEdhWeeAxMmFk7nXTs9sBFTrRwtBH1DyOmj2iheyt8XpLjtbPXyXVE5YKZ5H
	 EMyhWdzHgcDuKuxxew2PyaaflWPmBrqq87DUEBTIzjiUTWXpHEU9h3iuq1CKBPp7KO
	 dQQ2fBFATz/35klZLq0tx7CnLOMQfyjIf83/FNuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/676] drm/msm/dpu: drop LM_3 / LM_4 on SDM845
Date: Fri,  6 Dec 2024 15:30:23 +0100
Message-ID: <20241206143701.312784635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d39271061d67c6fcbe8f361c532b493069232cf8 ]

On the SDM845 platform ther are no LM_3 and LM_4 blocks. Drop them from
the SDM845 catalog.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/612586/
Link: https://lore.kernel.org/r/20240905-dpu-fix-sdm845-catalog-v1-2-3363d03998bd@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h   | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
index da0719588069b..3749c014870d3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
@@ -156,18 +156,6 @@ static const struct dpu_lm_cfg sdm845_lm[] = {
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_2,
 		.dspp = DSPP_2,
-	}, {
-		.name = "lm_3", .id = LM_3,
-		.base = 0x0, .len = 0x320,
-		.features = MIXER_SDM845_MASK,
-		.sblk = &sdm845_lm_sblk,
-		.pingpong = PINGPONG_NONE,
-	}, {
-		.name = "lm_4", .id = LM_4,
-		.base = 0x0, .len = 0x320,
-		.features = MIXER_SDM845_MASK,
-		.sblk = &sdm845_lm_sblk,
-		.pingpong = PINGPONG_NONE,
 	}, {
 		.name = "lm_5", .id = LM_5,
 		.base = 0x49000, .len = 0x320,
-- 
2.43.0



