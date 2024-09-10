Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29779188921;
	Tue, 10 Sep 2024 10:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963395; cv=none; b=bNzZ7KFTccnsU0jrsqp4im/RdSZSXRNqouCNli2WvcEQJcX1J0GOuLV3UXAPH/KnnGdmBetYhVOxuqEQ879c3vrMYYJcwr5dUyqD4seBBA31KIGbB9x9USg9S9Fmk5dbF46mCWtWZyTmTKafRkmDTx2FfL1RB4NgVVS2bW4uzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963395; c=relaxed/simple;
	bh=FegvPVOAgec5yL9kEG3lAlZLRmIoavSNsCqgv2FF4Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdgvJvDh+8tmac74w34vxj5gQO/cyO53dclcea52Sir4s6oU+sEcnnW6fYH3FK0yHmcnkT1GAcp0mifM1Dve+oTMDyoC2wWFZX0yYMyCdeCBXhPKV8/TqdbR4Dc4gmlCaddak4suQc9xfApOg6ZXPIrUSDnB/ugWfGwFXi1qtEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnulWzgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnulWzgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419D7C4CEC3;
	Tue, 10 Sep 2024 10:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963394;
	bh=FegvPVOAgec5yL9kEG3lAlZLRmIoavSNsCqgv2FF4Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnulWzgU05A94pzJcK3EzKj+ACEeKGYh32o+DoY1uFJgTiQX8ocvgRTA9IJlAlvD5
	 oEJcSIvZk/8WmlT8UryYt3xq69amxYP6nCTD6qrWi92iVhMwzKxHMfSMHwibqbU+zm
	 3IBYJ9E4mzq2BtLcVw4tmM6xZUxJ4OOy0MBJ9kfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/214] drm/amdgpu/pm: Fix uninitialized variable agc_btc_response
Date: Tue, 10 Sep 2024 11:30:47 +0200
Message-ID: <20240910092559.810375617@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fadceaba031e..81fd79a5fd7d 100644
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



