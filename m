Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3282837F8BC;
	Sat, 12 Sep 2026 10:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207521; cv=none; b=R6KkVpBAGuUU7vFhMdnDf+Cp9M68C3wrJziwtiZh+V23SHgAcePteQny6fLNiRX0oZdsvxFM5bjv6xzcnmWSpbOJ0DNAEQ80YRQVW2KoHaKN2UdBB6pPMhvJtDDsE1w6trkr1fsYiqsFXF4b0orzgrCRqvvEwSZYtDk28RXqBoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207521; c=relaxed/simple;
	bh=16WxV/pr30U17aWgxFnecFx3H39uzI0ic3DEEgenmQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gieA1ODGTARcxWqPQOCCdMAAkguDhVZ9oVO5RRWBtcg2zzOyRxcd3oQvrqoeJyMle8kIozUUelyxUsuW6qFpgwELu1fdRRFbEKhe4WLpVZostCSCt7FsvahWeKGRcAPMESnF46JFyHT46yqYhfd+2SWAIMzmIIYLLWWMeiHhIAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11E1IGQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11E1IGQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B541F000FF;
	Sat, 12 Sep 2026 10:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207519;
	bh=qTOB8ers4aOHoiEVJXBi5q5io7YpwJaLa6Ym1iM8hQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11E1IGQ2izRvKHXT4APnoVcr34usdxGqG5dSK/zB02LgFjK5WjEtyVo3X5PpeEpaT
	 5eQ+KI9T9drKT5eR1EDC50ZcHNVmRQmWgzF0wNbHp8jWbRexqbt0KX7qBbr3Ao1n+d
	 U2uli8GYVFsOIYnwjrJnQnhsHqcl/VF3KzfG+i0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0430/1518] drm/msm/a6xx: Fix A663 GPUCC register list for state capture
Date: Sat, 12 Sep 2026 08:43:19 +0200
Message-ID: <20260912065633.177604806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit fc7ccbc6174b79ffab5be5dca5b6e253df22f030 ]

The GPUCC register list for A663 is incorrect, which can cause
out-of-bounds register access during GPU state capture.

Update it to use the correct register ranges.

Fixes: 5773cce8615c ("drm/msm/a6xx: Add support for A663")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730656/
Message-ID: <20260605-assorted-fixes-june-v1-3-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 918d2e504adec..8a412b7d3129f 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -1244,7 +1244,9 @@ static void a6xx_get_gmu_registers(struct msm_gpu *gpu,
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[1],
 		&a6xx_state->gmu_registers[1], true);
 
-	if (adreno_is_a621(adreno_gpu) || adreno_is_a623(adreno_gpu))
+	if (adreno_is_a621(adreno_gpu) ||
+	    adreno_is_a623(adreno_gpu) ||
+	    adreno_is_a663(adreno_gpu))
 		_a6xx_get_gmu_registers(gpu, a6xx_state, &a621_gpucc_reg,
 			&a6xx_state->gmu_registers[2], false);
 	else
-- 
2.53.0



