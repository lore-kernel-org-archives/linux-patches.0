Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEED3F789B;
	Wed, 20 May 2026 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301029; cv=none; b=Q90EWRwwcyvXeVed0L4K7pk9IcqYmSLVP/jj732rG6SdUx7rkVSSVDqb/QEjuzi6dO0+Isj0eEYtV6HeyTFXc9uRUryyAaFN9AB6z9KEyykSixLkAQ95I6/MAc5yiKdNNHijZiD5v3Ci/yCLfRP0zC1oLNunQxacIdBsxHWOvjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301029; c=relaxed/simple;
	bh=z8URh5Sej+s48KVCztYX755UQRSfosloQQQLJay6UPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hbx5swdP0Iu9Q9RgD2WctyF56tTM9oKOq8Vj+Oi/nV9GwZ2bw8ohkjguFB4AuT+GmIkRe5/FFKzoyBUpdw6Qlb++MCZtztaZ0Hjckdqq+ha88DwgJiImpO8S5za6OeDh5aHPcJU7wYPr8gtBQZJgwB5lUIxwufCLGySDfnn8mLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEYVJB76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEYVJB76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758001F000E9;
	Wed, 20 May 2026 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301027;
	bh=tK48LIN4bPpJyyPsNjXUOs5CxYovXadVowdoOwRBcmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEYVJB76d91+wax58ETMhP5ViG1DjqzqP7Vwf2Wp/q0WiDM8o1WrdceHX9FxIqT3H
	 D032jQeZqSg/q67ke7dAwhRb2H0558dJvAMJ70BnsKYCHDBaoQ4zfrRENGobro4QZV
	 LWwXk96HfjBlayzlo8rtRSpa+CKKPk4XJrtaKUzc=
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
Subject: [PATCH 6.12 400/666] clk: qcom: dispcc-sm8450: use RCG2 ops for DPTX1 AUX clock source
Date: Wed, 20 May 2026 18:20:11 +0200
Message-ID: <20260520162119.927941325@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d1d3f60789ee0..8baaf94a119e3 100644
--- a/drivers/clk/qcom/dispcc-sm8450.c
+++ b/drivers/clk/qcom/dispcc-sm8450.c
@@ -364,7 +364,7 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_aux_clk_src = {
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_dp_ops,
+		.ops = &clk_rcg2_ops,
 	},
 };
 
-- 
2.53.0



