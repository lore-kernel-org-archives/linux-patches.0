Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264339C00B;
	Wed, 20 May 2026 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296280; cv=none; b=c9rFvL1/zBAVk696SKhR+gFfHPtfXivv8eMsO8EHurxGe6VPg1nihZbIkP5Lj+gRu3kk5a+HVSz5W3bBuZidBm3s6YZvTz+JzszURzbUlysyj+pwpYwnAPva9KPIDVHXg5BUSdOYdFDyNA5vdam/tCUXzoU06g980BPiBoHhcAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296280; c=relaxed/simple;
	bh=Z5Mw/O8Y5vVJ80TwBAEuZLC77PFnaq4vR/3X1+3x4M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaYa+Xz/GtuW47DrNAz8E1u/LzxglFeG9NsuH0zVzVJyzSUVr6pJP0pwHw9fNrrmMnUPveAwQhWRawMKYyLXFaUmGKw7s13GnFKwOxpcP0+ObeAs61UbbC+sTHJ8aULn34jWYvCRJ6t9WWMpls+8l6ZWkMyeNcTKbzDIP0gjTvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVJaZrwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVJaZrwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7DE1F000E9;
	Wed, 20 May 2026 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296279;
	bh=GIrYAfv3ROpmTdGpaJGQVXP3zD1uRbw8wifbYE8ho70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVJaZrwAto4Q3LDWo7Plze1AXYn78c0J7MxWdwdrWFw2tYKAMCT/+p/nuXrzz/DnJ
	 wOqUq96uY2MTGzsJ5uvIOX6f0jsig5RCpYaRSqMKm1kfa19ZHz14Utx2mEjai9RdrQ
	 KjRVKp/6GzuPlaegxqVXCFtF3gL6c9Lc/KyuexCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0698/1146] clk: qcom: dispcc-sm8450: use RCG2 ops for DPTX1 AUX clock source
Date: Wed, 20 May 2026 18:15:48 +0200
Message-ID: <20260520162203.988902012@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 141af1be817c42c7f1e1605348d4b1983d319bea ]

The clk_dp_ops are supposed to be used for DP-related clocks with a
proper MND divier. Use standard RCG2 ops for dptx1_aux_clk_src, the same
as all other DPTX AUX clocks in this driver.

Fixes: 16fb89f92ec4 ("clk: qcom: Add support for Display Clock Controller on SM8450")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260112-dp-aux-clks-v1-2-456b0c11b069@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8450.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm8450.c b/drivers/clk/qcom/dispcc-sm8450.c
index 9ce9fd28e55b2..2e91332dd92ab 100644
--- a/drivers/clk/qcom/dispcc-sm8450.c
+++ b/drivers/clk/qcom/dispcc-sm8450.c
@@ -409,7 +409,7 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_aux_clk_src = {
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_dp_ops,
+		.ops = &clk_rcg2_ops,
 	},
 };
 
-- 
2.53.0



