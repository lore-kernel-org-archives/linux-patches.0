Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6E61F8938;
	Tue,  3 Dec 2024 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238453; cv=none; b=WV57a0CwgG5hlxEKOnCKATlxUPWkSz5mDHCq6wGOg3ehn6erOMZCNXvY6MjPnn9YDnDFmCw/Wcygt5aDIAiIzCzNR2wjbtcaPsrMLfdc7Pri8+nhBuV9noIHmdh7pomYFQeNwwNsLC2CGAB3T4PFNqBTCPnNoB1vWflUR2TAybA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238453; c=relaxed/simple;
	bh=Fym2598a3lUCrZbudiv5EokzJDfGi9tcH+XzOMBaFdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL2cWUQS7Y4iIG8ypm26jTL7jW4vFWc4mkjVM7PT3m3TlUNs3pbrfNbi2nqk0vJFIeXazeS9Yuw/U0b3G7Datdh0fLHRD8Mi9wTXaPrZ/p/8CX+OX6FElX2rDcL5cDCH3tprzMMNLStpaFR3UsNXJPLGFNACXD4unH6VmCz8DM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCH3bfbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCH3bfbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBC6C4CED8;
	Tue,  3 Dec 2024 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238453;
	bh=Fym2598a3lUCrZbudiv5EokzJDfGi9tcH+XzOMBaFdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCH3bfbYdvO0CXDOmRTcfgvBH56716xxIK4hdDNcmt0QJb1eRiIY4AdNQi6p8IHQi
	 vSUoGHyMbTp92ElOY4eyaHvMFjQb+q6dlamxhYlrznNPbHvtZ3YZAFrTCuP2XnramN
	 c6OaGh1Fv55yDfVapbkkjFZyujQfQxkYNxdI8+Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 283/817] drm/msm/dpu: on SDM845 move DSPP_3 to LM_5 block
Date: Tue,  3 Dec 2024 15:37:35 +0100
Message-ID: <20241203144006.852679510@linuxfoundation.org>
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



