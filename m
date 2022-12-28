Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB6C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA7C433EF;
	Wed, 28 Dec 2022 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241477;
	bh=Fo44WJ7OXFGSEe/SuBPMouoCYCjUaUsBgm+pGQrkSEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XK1Ugbkj2X1sWxRszSPrhYO1fRajbv2KvSbIU2A+lNU+f31zSUhr+gbdrtd5uUgxY
	 z9a1SBz6cxIE4RiXfF+Glw5BF5Ghu9LK3JTXvQBr40lzdttEN719useV3YTSwAQZVa
	 6Dh7kcJpi8yfAmqKuOOKcJdR9AVXEN5FVSHcQmsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0288/1073] clk: qcom: dispcc-sm6350: Add CLK_OPS_PARENT_ENABLE to pixel&byte src
Date: Wed, 28 Dec 2022 15:31:16 +0100
Message-Id: <20221228144335.839878737@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 92039e8c080c63748f8e133e7cfad33a75daefb6 ]

Add the CLK_OPS_PARENT_ENABLE flag to pixel and byte clk srcs to
ensure set_rate can succeed.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Fixes: 837519775f1d ("clk: qcom: Add display clock controller driver for  SM6350")
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221010155546.73884-1-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm6350.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm6350.c b/drivers/clk/qcom/dispcc-sm6350.c
index 0c3c2e26ede9..ea6f54ed846e 100644
--- a/drivers/clk/qcom/dispcc-sm6350.c
+++ b/drivers/clk/qcom/dispcc-sm6350.c
@@ -306,7 +306,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk0_clk_src = {
 		.name = "disp_cc_mdss_pclk0_clk_src",
 		.parent_data = disp_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_5),
-		.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE,
+		.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
@@ -385,7 +385,7 @@ static struct clk_branch disp_cc_mdss_byte0_clk = {
 				&disp_cc_mdss_byte0_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE,
+			.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE | CLK_OPS_PARENT_ENABLE,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.35.1



