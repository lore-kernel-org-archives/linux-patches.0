Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D93C15198D;
	Wed,  5 Feb 2025 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764050; cv=none; b=hdSbqmaps0TLEA39/FqyPAWPQNvMj3a3nJYK0MQVYc/fxV5g1bixB9NdvhJEtKybJcOBuhkro8SCuLVEpPMATaRALGbFF+AgnUcY22/7h50ca3FreRfK3vyQUdplJxZmLIYor7/oDBthLEMfgglP0agoyNdJs0YJM0fhLCrVFP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764050; c=relaxed/simple;
	bh=4/3MdosVs4mzsSeQ5KZUMXnTRGSO0dnG09/Q13OABUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LryBqIpHYgY6QCC8iE5zB23YkLR8OKfHYo7YjSm7TYxaxJpPi/mePP9LhO+ztYSwfraMgQTFq3ibQAS43c0s1Y4UCdetdBktCSKlAdU4U0g29xaJaWKHpyH5rp+BsJh8CGlfMsXcMCT+giPzBTCj+Nh2syyAKv+2wVH3fKMj+dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phxC+b4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phxC+b4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C99C4CED6;
	Wed,  5 Feb 2025 14:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764050;
	bh=4/3MdosVs4mzsSeQ5KZUMXnTRGSO0dnG09/Q13OABUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phxC+b4VpjxKZZ4rgjiFJmJTbmkcdsh0BTOUD9FkB8q/grNsiRU6tvsP2+CRZvfaI
	 lhIDF7WOTrJN8xvRHrvbIsbtMSsUGhoCXnB0kJS6El87ykwoqP4FMhEz7c3Hr0Cdxy
	 uBjXl1bTVuZaC1d9h4wR/7YarSBa7EQ/ivvsh8ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/590] drm/msm/dpu: link DSPP_2/_3 blocks on SC8180X
Date: Wed,  5 Feb 2025 14:36:55 +0100
Message-ID: <20250205134457.554350093@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 0986163245df6bece47113e506143a7e87b0097d ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: f5abecfe339e ("drm/msm/dpu: enable DSPP and DSC on sc8180x")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629954/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-3-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index bab19ddd1d4f9..641023b102bf5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -163,6 +163,7 @@ static const struct dpu_lm_cfg sc8180x_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -170,6 +171,7 @@ static const struct dpu_lm_cfg sc8180x_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



