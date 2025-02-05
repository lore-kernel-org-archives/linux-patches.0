Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017D614B080;
	Wed,  5 Feb 2025 14:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764370; cv=none; b=X42tZTwYPm7ENtyh1KA8Uyi7bqLp7fR3emVew6H8WOl9VhcCft9AtggOYpMHetjnreT89UUg+4m7g4ZkdT9+f2XwGapchYrVtmaEnHqmzthTFg5ITwv6Dbgl10IAmmCJa0CAbQV6Cx83sQI+TG/0nBgnaIh0nonA4ABGXrTSRNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764370; c=relaxed/simple;
	bh=yRmAh2Z2xh00K2o7GOfSsPHDUeZOFebQgC8tHSK6udU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2zSasMHwMDg3cRElxB9W0+Ua4kJQA6d1R8Nt6p0+a/WgzMytXNx0/7+uaBhoPWQhjo1rGz4yaKP71kj7p/qOZZ/4xvTtkK0whIzhCwEdp09XuCvOZ2RHXSnvaj4Rtu8DnGWG7yrvFD09gCS2RFb4zO5Q5g8a3JZNmF7gvtcA9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwHa2c4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwHa2c4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2826C4CED1;
	Wed,  5 Feb 2025 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764369;
	bh=yRmAh2Z2xh00K2o7GOfSsPHDUeZOFebQgC8tHSK6udU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwHa2c4hyNLiwlpuGyatb411DRDmEDMPEnw2X4s1ofUIhVedDr3+rWXs+zkoWEgxs
	 3LSr1CYQBZNzglc3B1suMC+EB8QqzTSxbEagRtoNwCRNgW2/tDwnG3MCyxsD0JoPif
	 VIRyjP6Iqow03yz18o+d8mnAPk26PK//BNAHq6iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 072/623] drm/msm/dpu: link DSPP_2/_3 blocks on SM8550
Date: Wed,  5 Feb 2025 14:36:54 +0100
Message-ID: <20250205134458.981319662@linuxfoundation.org>
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

[ Upstream commit e21f9d85b05361bc343b11ecf84ac12c9cccbc3e ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: efcd0107727c ("drm/msm/dpu: add support for SM8550")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629961/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-6-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
index ad48defa154f7..a1dbbf5c652ff 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
@@ -160,6 +160,7 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -167,6 +168,7 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



