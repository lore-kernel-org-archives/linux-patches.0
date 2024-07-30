Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2318454A;
	Tue, 30 Jul 2024 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359013; cv=none; b=qtdA8ufdIlVpmUwTNhHTvYJ7EwdX/iuHkZqKXi83yMZmpMh6SdBv2ACS9+AAMNvwR9rBsC6PGw1OXN2MvexDQvtiWjVhNTESA1YJNCqzG9yj0WZD2WVGD00F4Ijq5DjWWc8fe3NZEYpjyR0IODV1E0i+BqDMlfMYBxwYHcFBy3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359013; c=relaxed/simple;
	bh=JgnERLX+uy2BmF8ndJjCm73+YLY4b30MmoyRfm+IBLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLc7f0DmJwIPb7N1uFPv/mQO4JAtOupOHtPur+yxgIar6MJi6fMpFfDfTvRPnfnoCQhnm9KRssHETIhT0ev8FOX9MWVKvWKTMKuvLd8HQzAZrNiHPzCMS4g4X8uyVJYK9SIywbTMlcq0RWcLIowtxNbMNUlMyIFCKYn/q3D0EOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asimi7lD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asimi7lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2F8C4AF0F;
	Tue, 30 Jul 2024 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359012;
	bh=JgnERLX+uy2BmF8ndJjCm73+YLY4b30MmoyRfm+IBLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asimi7lDqsEqM/mqdZKO8/N/QHdCm2PcfEpTi0EzFgarIsxsGlFOZymph61QkR1Np
	 /qaO4Otio2f6H96ugwMxIX7iSTnEGYl8HlNO8EsqX72sYivqSsGf7D8YQycDDZvnht
	 bVKE60LLT8KLAPou/TdBek0F/9QedjDlNbzsdqTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 414/809] clk: qcom: gpucc-sa8775p: Remove the CLK_IS_CRITICAL and ALWAYS_ON flags
Date: Tue, 30 Jul 2024 17:44:50 +0200
Message-ID: <20240730151741.045055177@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit e69386d4a42afa5da6bfdcd4ac5ec61e1db04c61 ]

The GPU clocks/GDSCs have been marked critical from the clock driver
but the GPU driver votes on these resources as per the HW requirement.
In the case where these clocks & GDSCs are left enabled, would have
power impact and also cause GPU stability/corruptions.
Fix the same by removing the CLK_IS_CRITICAL for clocks and ALWAYS_ON
flags for the GPU GDSCs.

Fixes: 0afa16afc36d ("clk: qcom: add the GPUCC driver for sa8775p")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20240612-sa8775p-v2-gcc-gpucc-fixes-v2-4-adcc756a23df@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sa8775p.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-sa8775p.c b/drivers/clk/qcom/gpucc-sa8775p.c
index 1167c42da39db..f965babf4330d 100644
--- a/drivers/clk/qcom/gpucc-sa8775p.c
+++ b/drivers/clk/qcom/gpucc-sa8775p.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2021-2022, Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2022, 2024, Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2023, Linaro Limited
  */
 
@@ -280,7 +280,7 @@ static struct clk_branch gpu_cc_ahb_clk = {
 				&gpu_cc_hub_ahb_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -294,7 +294,6 @@ static struct clk_branch gpu_cc_cb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data){
 			.name = "gpu_cc_cb_clk",
-			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -312,7 +311,7 @@ static struct clk_branch gpu_cc_crc_ahb_clk = {
 				&gpu_cc_hub_ahb_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -330,7 +329,7 @@ static struct clk_branch gpu_cc_cx_ff_clk = {
 				&gpu_cc_ff_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -348,7 +347,7 @@ static struct clk_branch gpu_cc_cx_gmu_clk = {
 				&gpu_cc_gmu_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags =  CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags =  CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_aon_ops,
 		},
 	},
@@ -362,7 +361,6 @@ static struct clk_branch gpu_cc_cx_snoc_dvm_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data){
 			.name = "gpu_cc_cx_snoc_dvm_clk",
-			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -380,7 +378,7 @@ static struct clk_branch gpu_cc_cxo_aon_clk = {
 				&gpu_cc_xo_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -398,7 +396,7 @@ static struct clk_branch gpu_cc_cxo_clk = {
 				&gpu_cc_xo_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags =  CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags =  CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -416,7 +414,7 @@ static struct clk_branch gpu_cc_demet_clk = {
 				&gpu_cc_demet_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_aon_ops,
 		},
 	},
@@ -430,7 +428,6 @@ static struct clk_branch gpu_cc_hlos1_vote_gpu_smmu_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data){
 			.name = "gpu_cc_hlos1_vote_gpu_smmu_clk",
-			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -448,7 +445,7 @@ static struct clk_branch gpu_cc_hub_aon_clk = {
 				&gpu_cc_hub_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_aon_ops,
 		},
 	},
@@ -466,7 +463,7 @@ static struct clk_branch gpu_cc_hub_cx_int_clk = {
 				&gpu_cc_hub_cx_int_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags =  CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags =  CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_aon_ops,
 		},
 	},
@@ -480,7 +477,6 @@ static struct clk_branch gpu_cc_memnoc_gfx_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data){
 			.name = "gpu_cc_memnoc_gfx_clk",
-			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -494,7 +490,6 @@ static struct clk_branch gpu_cc_sleep_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data){
 			.name = "gpu_cc_sleep_clk",
-			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -533,7 +528,7 @@ static struct gdsc cx_gdsc = {
 		.name = "cx_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE | RETAIN_FF_ENABLE | ALWAYS_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc gx_gdsc = {
-- 
2.43.0



