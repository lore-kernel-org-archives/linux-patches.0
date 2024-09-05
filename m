Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626CC1494DB;
	Thu,  5 Sep 2024 10:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530532; cv=none; b=CzA2/LPdxI8CcN009lty1bZuYqzzhYzlyBelo4EpIe731VAY0eFL77u+2VwXyBz376NRvIAaqAzjwZTpfkxIbm5r1JZ1p1u1BiWf0cydAU3K2uWtDUrA7zi/Iy5JWZrjm2vBxOvyXvsXrdevJNWBIjWDChbFyZUjve3uURSOYM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530532; c=relaxed/simple;
	bh=57rufRxdFjqsV6hqT8spKkMxDU9l9rhAiVi5SXLb4xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxArZE5whxHYiZ/1MLoBzVJwsSbA3KWN8IdxRnXaA87MzgXtLCV4otFm2InLd1hSZGpUPrLmy5MGv5jZcATaCJWYR2xUhG7bnsKamycBQixS7Rwb1/11QXCQH7lsyjM5Bm6LQGRctOTJCsXX0HfHLUajwehWczBar1xcDDwAS1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxjQ6KeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxjQ6KeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F14C4CEC3;
	Thu,  5 Sep 2024 10:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530532;
	bh=57rufRxdFjqsV6hqT8spKkMxDU9l9rhAiVi5SXLb4xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxjQ6KeBIV2zyC1GvuFvB/JufmInkJAyljD5QAYd5p2Lrl92zGf0E0kf2ZxKhLnyy
	 a1YKqWC0s33mO55g2lPlSU21G1eRSiWF+3m9YPOplmKhrD23NK0gUprdQNflxWX7Aw
	 Yy/Vl9cgA0vG/ARkhDHihf6FLpM6wM3h47wDe15A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/101] drm/amdgpu/pm: Fix uninitialized variable agc_btc_response
Date: Thu,  5 Sep 2024 11:41:24 +0200
Message-ID: <20240905093718.172548673@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit df4409d8a04dd39d7f2aa0c5f528a56b99eaaa13 ]

Assign an default value to agc_btc_response in failed case

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 40592cab7810..c4d81c0aa18e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -2365,15 +2365,20 @@ static int vega10_acg_enable(struct pp_hwmgr *hwmgr)
 {
 	struct vega10_hwmgr *data = hwmgr->backend;
 	uint32_t agc_btc_response;
+	int ret;
 
 	if (data->smu_features[GNLD_ACG].supported) {
 		if (0 == vega10_enable_smc_features(hwmgr, true,
 					data->smu_features[GNLD_DPM_PREFETCHER].smu_feature_bitmap))
 			data->smu_features[GNLD_DPM_PREFETCHER].enabled = true;
 
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_InitializeAcg, NULL);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_InitializeAcg, NULL);
+		if (ret)
+			return ret;
 
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_RunAcgBtc, &agc_btc_response);
+		ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_RunAcgBtc, &agc_btc_response);
+		if (ret)
+			agc_btc_response = 0;
 
 		if (1 == agc_btc_response) {
 			if (1 == data->acg_loop_state)
-- 
2.43.0



