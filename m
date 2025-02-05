Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473EB146A7A;
	Wed,  5 Feb 2025 13:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763316; cv=none; b=D1Oz1XV8v1pS22rU2VXd1TrlQmn4mkPEPXVizplzjbIlIzAXtV028cRvl2SuoWfpb9s3FsUF3PR9VHVLRz91tNZlcvCnzjdUkSbS0CnjX3QdYYwZYWaWzzSZhrpPk48/Tj54hh6FxSZ2ub7hcN9B/3KCiFUhOLPpXUxRZe3XUX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763316; c=relaxed/simple;
	bh=sLzihlSVSSSHIThAa350FyNhDhyFWD+RSLcnfwDm8xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZTjSa5MExRC6plzNLfOCRVZJ86qLPXy6dQA9cPHUaYcvXwBoY0R35LI0tdzSlbVSA9rz/4ZWVNptcfXmyQcyj5t5kP4mnlfZtF69VLYogjecSUIC0Tt7i3reCF5WbB5C1DrrhDMgZbzQWHlMZSzeN5/Zy7byjsOjCPpLX++GTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN96AF2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN96AF2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90DEC4CED6;
	Wed,  5 Feb 2025 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763316;
	bh=sLzihlSVSSSHIThAa350FyNhDhyFWD+RSLcnfwDm8xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN96AF2EXyVi7XmtmEfIDNnnHfuoxhKAe8lImEjrCMwYhsf46LS+vUWQyU91gulZK
	 baBY3Sr93gV9M5/FBsq1kcBwUBYI5PrqLHv+OQ1NIO1OAwDM3JhL/mYEdcwCBuFzT3
	 1KgaS5Msd8MzoShoNSqkrogbbM7OTdtpxsmw5Voo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/393] drm/msm/dpu: link DSPP_2/_3 blocks on SC8180X
Date: Wed,  5 Feb 2025 14:39:18 +0100
Message-ID: <20250205134421.797024947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 47de71e71e310..427dec0cd1d36 100644
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



