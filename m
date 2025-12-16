Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FE7364058;
	Tue, 16 Dec 2025 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886959; cv=none; b=S/d4QiaviflKe83flnYLuKnfOMi3QaahG6ycK7Oqsz95xpXugkCM66jyO3H1Y7/LVZELjGHNNjhGlxFiFke8hdu6beRbqq0h9mjMcmxfWSP7lLxVW1l6tSy07cT4eheGF96jDhgbz4UHcqeyh11tLmjHwrYTPenTZl7GGiSaa7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886959; c=relaxed/simple;
	bh=LdgvYWKvhAPoyrh5pnTzALllXQYC1mmGZ1iicC6yTGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKRzNB+/dWUJqnIAWJBtStFi9VeCA4yEbMt+z59pK+tYPB0KCMVJmne47ht9derBwWwzO1eTFguH287TjqDJqQYtYgI7Rb5jgtkviRdInVSLmNST27qxte1iSjht7pDGtlu3YeAdsPKYs7RcWNSLIXGYGuCjkyAYfhNue4VnT8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGi+TcH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGi+TcH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56ACC4CEF1;
	Tue, 16 Dec 2025 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886959;
	bh=LdgvYWKvhAPoyrh5pnTzALllXQYC1mmGZ1iicC6yTGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGi+TcH7oYnFqdXyKA2LIGTPWmb94Pw0RZKJN9OIKXMH3tvGsldmjyxEFFQ1ysAcC
	 N5l6y5RGA/7J2oNJaT1uOb5S/tSbspBaGEwMhFiGAIpd9OzvOM4zSdnQEco1QhejHM
	 eGbKf5QSv627qI/UXHTWy4g5/muxWzzb1V3zP8hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luo Jie <quic_luoj@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/614] clk: qcom: gcc-ipq5424: Correct the icc_first_node_id
Date: Tue, 16 Dec 2025 12:07:31 +0100
Message-ID: <20251216111404.367037505@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Luo Jie <quic_luoj@quicinc.com>

[ Upstream commit 464ce94531f5a62ce29081a9d3c70eb4d525f443 ]

Update to use the expected icc_first_node_id for registering the icc
clocks, ensuring correct association of clocks with interconnect nodes.

Fixes: 170f3d2c065e ("clk: qcom: ipq5424: Use icc-clk for enabling NoC related clocks")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
Link: https://lore.kernel.org/r/20251014-qcom_ipq5424_nsscc-v7-1-081f4956be02@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5424.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq5424.c b/drivers/clk/qcom/gcc-ipq5424.c
index 3d42f3d85c7a9..71afa1b86b723 100644
--- a/drivers/clk/qcom/gcc-ipq5424.c
+++ b/drivers/clk/qcom/gcc-ipq5424.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (c) 2018,2020 The Linux Foundation. All rights reserved.
- * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/clk-provider.h>
@@ -3284,6 +3284,7 @@ static const struct qcom_cc_desc gcc_ipq5424_desc = {
 	.num_clk_hws = ARRAY_SIZE(gcc_ipq5424_hws),
 	.icc_hws = icc_ipq5424_hws,
 	.num_icc_hws = ARRAY_SIZE(icc_ipq5424_hws),
+	.icc_first_node_id = IPQ_APPS_ID,
 };
 
 static int gcc_ipq5424_probe(struct platform_device *pdev)
-- 
2.51.0



