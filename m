Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8B210E0;
	Fri,  6 Dec 2024 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497129; cv=none; b=AO0WtRvdYU5EROnh06YYwFwVUPBlZhjKoA9WAVrdemewa2e5F6kEEhZ+o+XDDZK/XuH5spVNhQrlfxILneoI+IEy6uu4g44T0C8LpuX5ADEf8hhdjq/72LmbD5bi7sMeOgrMRfwboxJbHAUuEtcs8McP76k55LNAiU3nj+0Nzd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497129; c=relaxed/simple;
	bh=gp3O3/Q0jd8Nh+3rTu/WzYiHEbW1AGHUKrIo8FEZLb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUuG/8qMHwZWB/vSZLz9Vya6HEmlHYybGPOIfbw7IaNTIKqU+9aHbSru2XuWdoOV+aiJO+QGQMGl6XOqBj5xQfvGTtxuvmIp7hrXwLRjAgbrkrc6SrrVqcVpCBugg1gMsBkMw4wAJu6lQc1qdjeadJMpbwRdxhmRpBDWUChT6M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/X6bRCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/X6bRCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A273C4CED1;
	Fri,  6 Dec 2024 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497128;
	bh=gp3O3/Q0jd8Nh+3rTu/WzYiHEbW1AGHUKrIo8FEZLb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/X6bRCYSjLj2TAcmdPUblRcLX+un86gAnKNIqJqHIsz6KHiT7+SEq8rw++tmz2fs
	 elXyQke/tyBUrUIkBX42nJq+2hZk2/UT4qhy5ZMOfffPo+sbX7s7A2RfOVnKmXAoPI
	 B+gnPeb8yrOEwJxFbq1BJRxyTLVMG4hp+o551YG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/676] drm/msm/dpu: on SDM845 move DSPP_3 to LM_5 block
Date: Fri,  6 Dec 2024 15:30:22 +0100
Message-ID: <20241206143701.274590991@linuxfoundation.org>
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

[ Upstream commit 768a272d5357269b17b4b06dd8647e21bdc0ca3c ]

On the SDM845 platform the DSPP_3 is used by the LM_5. Correct
corresponding entries in the sdm845_lm array.

Fixes: c72375172194 ("drm/msm/dpu/catalog: define DSPP blocks found on sdm845")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/612584/
Link: https://lore.kernel.org/r/20240905-dpu-fix-sdm845-catalog-v1-1-3363d03998bd@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
index 88a5177dfdb73..da0719588069b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
@@ -162,7 +162,6 @@ static const struct dpu_lm_cfg sdm845_lm[] = {
 		.features = MIXER_SDM845_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.pingpong = PINGPONG_NONE,
-		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x0, .len = 0x320,
@@ -176,6 +175,7 @@ static const struct dpu_lm_cfg sdm845_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	},
 };
 
-- 
2.43.0



