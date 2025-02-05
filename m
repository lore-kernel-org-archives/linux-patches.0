Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7532E634;
	Wed,  5 Feb 2025 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764383; cv=none; b=HlXFE3ZJt1/eGKEX/wzZh6HhVV9qaKbt3XwQtxMr1spozCV/EW/uBaFeD7kmRbw6iR+Zkc8uDToERIsA0K3mh6idxHP9rHd+j8iK/wX8sBqY4KJyBHB35rqIl1XgnbTZ/6zrMEyGoiPCmFSek93q0rUfqGDApqLfgakfOwhzqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764383; c=relaxed/simple;
	bh=0s++c3jgrs5rSQR1H8qXmLBO0Bsne+gIcMTTpZUULOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7KNg3BGplnEa0NGQrbb9/LeYOQXCoDOTWiiH0NRTRIfKcT6hNowmvUGmsdkdISKK9fkoIbfQXSROZJF26EQqQBW8VshmAmQla2WqJubbeBeifiK28E0jLJHWz9x27ErE1Pn+IXyXjqrzzCepnFq2eLg6Eb/mtPUP7LeEgwHinY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9ZnKKPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9ZnKKPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C32C4CED1;
	Wed,  5 Feb 2025 14:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764382;
	bh=0s++c3jgrs5rSQR1H8qXmLBO0Bsne+gIcMTTpZUULOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9ZnKKPpEUw7mY7mlHHe9an0B7AwAMJNyvbScwJA+aYCiBAFu35QMui9Rh9QZZEc6
	 SPghgw0RjJZOIjbe9Oh0zL8+bNihn/+N/NVzkguCN8dNRGdgFNk5fFy5QFyk521r97
	 aDD2ddg/0ScPjy64+yT2SQvkwCN/PEY8gc0v5jbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 073/623] drm/msm/dpu: link DSPP_2/_3 blocks on SM8650
Date: Wed,  5 Feb 2025 14:36:55 +0100
Message-ID: <20250205134459.019519405@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3d3ca0915aa3692a837f7235ca9d12db26f09911 ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: b94747f7d8c7 ("drm/msm/dpu: add support for SM8650 DPU")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629962/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-7-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h
index eb5dfff2ec4f4..e187e7b1cef16 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h
@@ -160,6 +160,7 @@ static const struct dpu_lm_cfg sm8650_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x400,
@@ -167,6 +168,7 @@ static const struct dpu_lm_cfg sm8650_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x400,
-- 
2.39.5



