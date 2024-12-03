Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2478153800;
	Tue,  3 Dec 2024 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240866; cv=none; b=NIymyiCUUCRZiC60/05W5Nt8vDJJKO1sOO5b6yyJGDCFOqRGdBUJUvo/4xz0U0HUyw/Xc5JLIniBKki+Avj2jHOak6k9JZbJ7/bcH3J/4vx/p7Z+H5gA1Ezodzkk7nDj0Yw1oey89cCh5zGqW4k7trMvnzU7Fwh8d6Kd9NtFxn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240866; c=relaxed/simple;
	bh=7+5RohIUozIluX7PuUOlG3h540Icwa4BjKlzpTin4fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1/7hKBV/RNPsNLOW9m7cr5AeRm6L4k/rib6M2KWAyxFAMGPlDHJAS1gPBt4mmEN4ofWUiECPMKlVV2pqdHb9dvF+bmEtQU/MVfvTuCtXg0AB2Ide/zb4/wVBz50c7VfQTKUw9ScedLDMbPMqGAeuoc6THxzU3BabdS9wXGMx1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZJM1M2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZJM1M2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CF3C4CECF;
	Tue,  3 Dec 2024 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240866;
	bh=7+5RohIUozIluX7PuUOlG3h540Icwa4BjKlzpTin4fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZJM1M2eS01XI3tUYuzt340wx6gtGzqPWMztezZ6x/ImoycnVsf7k0qeXAB/16vKI
	 oVh0SRWFPXXIpGp/QGqDjOy7PkXKqOzvjA07IpJpdAc+c3vnwOx0++Q/jF0yZRD0Hj
	 NIGVIPL5qu6XSSDqz2Iu5aMlyJ2bV1m+cr2oov8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/826] drm/msm/dpu: drop LM_3 / LM_4 on MSM8998
Date: Tue,  3 Dec 2024 15:39:45 +0100
Message-ID: <20241203144753.829923360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c59afe50773d5c972f6684f9bbd9a2ddb2fb92fa ]

On the MSM8998 platform ther are no LM_3 and LM_4 blocks. Drop them from
the MSM8998 catalog.

Fixes: 94391a14fc27 ("drm/msm/dpu1: Add MSM8998 to hw catalog")
Reported-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/612585/
Link: https://lore.kernel.org/r/20240905-dpu-fix-sdm845-catalog-v1-3-3363d03998bd@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h  | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
index 1d3e9666c7411..64c94e919a698 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
@@ -156,18 +156,6 @@ static const struct dpu_lm_cfg msm8998_lm[] = {
 		.sblk = &msm8998_lm_sblk,
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_2,
-	}, {
-		.name = "lm_3", .id = LM_3,
-		.base = 0x47000, .len = 0x320,
-		.features = MIXER_MSM8998_MASK,
-		.sblk = &msm8998_lm_sblk,
-		.pingpong = PINGPONG_NONE,
-	}, {
-		.name = "lm_4", .id = LM_4,
-		.base = 0x48000, .len = 0x320,
-		.features = MIXER_MSM8998_MASK,
-		.sblk = &msm8998_lm_sblk,
-		.pingpong = PINGPONG_NONE,
 	}, {
 		.name = "lm_5", .id = LM_5,
 		.base = 0x49000, .len = 0x320,
-- 
2.43.0



