Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F86C1F7560;
	Tue,  3 Dec 2024 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238456; cv=none; b=a0ak4ZjYL1UTOY//ArzI8qI2og2Xy01k1qwQLP/7NJfSI2WhAeZltVVfA7vzHPrM36yiTo8fXZwLgWro/LELmi+RddLiJUBkomrfaT+eNGmCT7ew+oWvFCZKvqwL2rI4WqeCT4Z4HxOK13LUDMwnf8ljzbrd/DYV6eOBRxzgU6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238456; c=relaxed/simple;
	bh=WlFlNZMUb4vBo7+oDBOviFGc2uTM8mQ+Cqki3MU0pF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEFC8zhpqNPPXZdC8i4AkOO1UG5bOaa2nGqEEsyxsoxpejiDhRYfRBivK82USGVwRKUMytaAJeWliScyY40hloPtSeVPGGVboueE3dGQus8pQLzrvRtmgDnR/eO+ihjQB2zM4gzJAxSbvvMdL/xPqCLTEfn/EmKxd7OMTl1v0rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=he+HELCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="he+HELCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06388C4CECF;
	Tue,  3 Dec 2024 15:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238456;
	bh=WlFlNZMUb4vBo7+oDBOviFGc2uTM8mQ+Cqki3MU0pF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=he+HELCvua285RgGo/hdKauuVJl400HduGkZmxYyDweipdUeJJJvUP0f/sqRnRI0t
	 k5QEiNVLlnXQwx9mQscCQWs0pif7TTwhcHdjCT8dPqFleCWtFbvTs1WEEoRgXcs+OK
	 DwrgAv8xko76c1GYZEREd4XezKYGdYrlv8HpJz9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 284/817] drm/msm/dpu: drop LM_3 / LM_4 on SDM845
Date: Tue,  3 Dec 2024 15:37:36 +0100
Message-ID: <20241203144006.893198858@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index 59eeea3dd2e9f..72bd4f7e9e504 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
@@ -155,18 +155,6 @@ static const struct dpu_lm_cfg sdm845_lm[] = {
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



