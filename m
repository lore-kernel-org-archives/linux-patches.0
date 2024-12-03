Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540671DFE2A;
	Tue,  3 Dec 2024 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240857; cv=none; b=JH8Q0kdMP5nx3ciLtmqkbapo2p4oWeWRB6Yf84cCyN4eyQ6y8ADll9Zcnt5caPh10H5d8lbUqw4AYjlnvIW7dLeSr83SCtV6vJ2MbiYVMuTQW0V71VYXIBV+nVL/QQ0aUiRVCzEb7+yQ7GVD+OVNtMc6ugM87Fra0kf+Vwjk2AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240857; c=relaxed/simple;
	bh=rew1a4K2arvlcrBnQZJNP5GjXzvYjadzljekvx3wH2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl5b6ejyJWuLaDxViRhRVQJS9pMZ2DisO8y0moBsFf8mtxSD8mJRIy5dd9AIU7fTj+0YAQSsm0l3+VQAt4K/lnSAQTrRDMbJ6QJ1TCsB+2b3vp5VVZFExJH21o2eQvgnhKtI8CSzHSoS8cd/hOJXCIwRK8gdV2Zr2u3DsqHxjlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7ai1whP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7ai1whP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F66C4CECF;
	Tue,  3 Dec 2024 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240856;
	bh=rew1a4K2arvlcrBnQZJNP5GjXzvYjadzljekvx3wH2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7ai1whPwqYpdQS4cNwIl1B3dkF42J2qk99zYDxLxmXOGTZnI4Tu8PoErm7RMPapt
	 Sd6OuKu4FOlFHIxYqRycrizCdyuLdLx04js47pNx4ArMOm6YTUVRX889pjxIv1zzzd
	 Hehknv/GZhZUnTs/1qoyseqMisoiB9bzwi+kZGhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/826] drm/msm/dpu: on SDM845 move DSPP_3 to LM_5 block
Date: Tue,  3 Dec 2024 15:39:43 +0100
Message-ID: <20241203144753.751375089@linuxfoundation.org>
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
index 7a23389a57327..59eeea3dd2e9f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
@@ -161,7 +161,6 @@ static const struct dpu_lm_cfg sdm845_lm[] = {
 		.features = MIXER_SDM845_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.pingpong = PINGPONG_NONE,
-		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x0, .len = 0x320,
@@ -175,6 +174,7 @@ static const struct dpu_lm_cfg sdm845_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	},
 };
 
-- 
2.43.0



