Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DB01AA1C3;
	Wed, 20 Nov 2024 12:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107555; cv=none; b=Cs1BX5CcmaSghCmka3SJt6lgzri+OhD8InxpYrffFNsBVNeVWyRs4EAzlIqMtAdmk1mDwHxT/geTzcfvTD5GG+BBt+V0ASZsvYjzP+V3xixXflR9BtBTCYCidO4MhQDi5ftLHCrzIstN8W4J0gF775LA3sNv3qKV3Kq+LmQ46wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107555; c=relaxed/simple;
	bh=wgTxN7rkd0S/zc//PWUO+qxSogO5zJfJmbC3vFZTFmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJhkn59d9ZxBsqHH47JMSV3i4t7Lrl2Nsalyt+DbfBNoGVh34rkvfxau9BfaMNk/hpyvNBtPSt/3g2GIok/CodvYWD3seHAwP1QOHpUvm5k6lRsggSVJVjl72tJqtM1HQNYwI3s7pjTDEpgHEvwnoWi1jHIUwbfaNW7TDL2rEP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyWpBH0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyWpBH0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B338BC4CED2;
	Wed, 20 Nov 2024 12:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107554;
	bh=wgTxN7rkd0S/zc//PWUO+qxSogO5zJfJmbC3vFZTFmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyWpBH0Fbc4zFYx3deBcmAZQKoqCLBlWmpkbu5DxaKPZdqOs2Wg6wVRvooeues/J2
	 tfgVwc9JlTw2ZRCl5NnMxyybnw1MkdrQQaRlx1PKjRTtCTH3d0j4VM8F2K8rjXL3pE
	 UVBuD/zEA1zS+L2TGee5FXP8giJIPL2/IQKVWlO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 095/107] drm/amd/pm: print pp_dpm_mclk in ascending order on SMU v14.0.0
Date: Wed, 20 Nov 2024 13:57:10 +0100
Message-ID: <20241120125631.863480631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Tim Huang <tim.huang@amd.com>

commit df0279e2a1c0735e8ca80c5df8d9f8f9fc120b4a upstream.

Currently, the pp_dpm_mclk values are reported in descending order
on SMU IP v14.0.0/1/4. Adjust to ascending order for consistency
with other clock interfaces.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d4be16ccfd5bf822176740a51ff2306679a2247e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
@@ -1132,7 +1132,7 @@ static int smu_v14_0_common_get_dpm_leve
 static int smu_v14_0_0_print_clk_levels(struct smu_context *smu,
 					enum smu_clk_type clk_type, char *buf)
 {
-	int i, size = 0, ret = 0;
+	int i, idx, ret = 0, size = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
 	uint32_t min, max;
 
@@ -1168,7 +1168,8 @@ static int smu_v14_0_0_print_clk_levels(
 			break;
 
 		for (i = 0; i < count; i++) {
-			ret = smu_v14_0_common_get_dpm_freq_by_index(smu, clk_type, i, &value);
+			idx = (clk_type == SMU_MCLK) ? (count - i - 1) : i;
+			ret = smu_v14_0_common_get_dpm_freq_by_index(smu, clk_type, idx, &value);
 			if (ret)
 				break;
 


