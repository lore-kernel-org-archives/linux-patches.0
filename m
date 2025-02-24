Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D63424886B;
	Mon, 24 Feb 2025 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409010; cv=none; b=Hqn+KSeYFIVXJPFTaVB2krkIEaVB1sIyBQ4/U0Lgvn14EOPThhbtIp/6B60beeihB1DgTxQweU6LJhOLiAkzYpRgglObNkdCWqoLQUA1Saz6bhQuClfU9FSNZdvYBghRLd6nrBp/Uc0gwoG7DSn/nk3Dzw4l6RQZW/rkEbCnb7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409010; c=relaxed/simple;
	bh=+mSXZ8ZNfuoBunKGgd/CW8NDqr5+hIZ6VzUO1QgBF7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8UNTJwNtXT0OmVD588Hog5ApUb3IeIw+UVgtgG0wuenXkECAKAT7LzOPPl35Hf6jFZITVRx6rlfeAeo6pCAh/ivau3WYIWpUSPLNicCaiML7v7eCTBdAaBe0wexfzW5B+/hU5tAfpUI0hF107osUxmB3AOtKID7Xdh90VjHFas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVE216/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVE216/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628FBC4CED6;
	Mon, 24 Feb 2025 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409010;
	bh=+mSXZ8ZNfuoBunKGgd/CW8NDqr5+hIZ6VzUO1QgBF7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVE216/QrFL7+79DgAePtI1sK80gXwcCGuBWgYGepHJv4FtbxhCSupQaBSutF6+CZ
	 YYtUUTreNjYFywPNc84c7Dr8XQBLP260vk7bgpafe2Y74RENMlS+GJM6Gxl10c+udZ
	 EUxXCUHuvO86bbDuK+lJ/xYiA+TBDhObhu9HG3Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 071/138] drm/msm/dpu: enable DPU_WB_INPUT_CTRL for DPU 5.x
Date: Mon, 24 Feb 2025 15:35:01 +0100
Message-ID: <20250224142607.266642195@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

[ Upstream commit af0a4a2090cce732c70ad6c5f4145b43f39e3fe9 ]

Several DPU 5.x platforms are supposed to be using DPU_WB_INPUT_CTRL,
to bind WB and PINGPONG blocks, but they do not. Change those platforms
to use WB_SM8250_MASK, which includes that bit.

Fixes: 1f5bcc4316b3 ("drm/msm/dpu: enable writeback on SC8108X")
Fixes: ab2b03d73a66 ("drm/msm/dpu: enable writeback on SM6125")
Fixes: 47cebb740a83 ("drm/msm/dpu: enable writeback on SM8150")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/628876/
Link: https://lore.kernel.org/r/20241214-dpu-drop-features-v1-2-988f0662cb7e@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h  | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
index 421afacb72480..36cc9dbc00b5c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
@@ -297,7 +297,7 @@ static const struct dpu_wb_cfg sm8150_wb[] = {
 	{
 		.name = "wb_2", .id = WB_2,
 		.base = 0x65000, .len = 0x2c8,
-		.features = WB_SDM845_MASK,
+		.features = WB_SM8250_MASK,
 		.format_list = wb2_formats_rgb,
 		.num_formats = ARRAY_SIZE(wb2_formats_rgb),
 		.clk_ctrl = DPU_CLK_CTRL_WB2,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index 641023b102bf5..e8eacdb47967a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -304,7 +304,7 @@ static const struct dpu_wb_cfg sc8180x_wb[] = {
 	{
 		.name = "wb_2", .id = WB_2,
 		.base = 0x65000, .len = 0x2c8,
-		.features = WB_SDM845_MASK,
+		.features = WB_SM8250_MASK,
 		.format_list = wb2_formats_rgb,
 		.num_formats = ARRAY_SIZE(wb2_formats_rgb),
 		.clk_ctrl = DPU_CLK_CTRL_WB2,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h
index d039b96beb97c..76f60a2df7a89 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h
@@ -144,7 +144,7 @@ static const struct dpu_wb_cfg sm6125_wb[] = {
 	{
 		.name = "wb_2", .id = WB_2,
 		.base = 0x65000, .len = 0x2c8,
-		.features = WB_SDM845_MASK,
+		.features = WB_SM8250_MASK,
 		.format_list = wb2_formats_rgb,
 		.num_formats = ARRAY_SIZE(wb2_formats_rgb),
 		.clk_ctrl = DPU_CLK_CTRL_WB2,
-- 
2.39.5



