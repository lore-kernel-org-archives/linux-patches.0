Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0C93FBECB;
	Wed, 20 May 2026 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302502; cv=none; b=l4Kmrmpe9QGbAHsGCYpQJOtfia0oWjhmMojZr4PNzEt0DyvQQwXf+UjQ5xd3sqKxXbzY320+WSrpE0sweYlIqVXokdfmlGyWimt52fKGjTy2TClD/Oegw/bTLnoCxPZKJuMagyMb6wH8MNc97hc25rxzEcyF0H8PdtbyZbw8jX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302502; c=relaxed/simple;
	bh=RC7jM3IKwA0GkkaKKTJhWqzTVUDWueRartZEqTtmfKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5ufcckF/olpBkGddi2wvFmgDrl/SiIiJkxFQw46ahVxLrEcsMU9ebJKqPFT/BJFBAQLTzlFDhA3/Ouo/k9csBbO6UqT21RIdfZkHXxbg2JpiW9zWnWW6u5xAZJQs/EwBKJqCBdjZrOLzAxcbEMp6L1/UPYaY38iNkASaCl8wu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bb4XGq6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bb4XGq6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79FE1F000E9;
	Wed, 20 May 2026 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302501;
	bh=YYIgvYo8fJYBB2fHe/Lcjs+FfekKOMwOps8/X6G0lJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb4XGq6FIXzO6iPZEtEUHg90MrL8UayDsCdZ/s0uxVXK220Xh2OOeTWK3jNcnf7wJ
	 7iFLRUD0EIYyD1zFMozhPWBtIm6bbsc3NiGj3bBCipTFS7CqAELcccvCyEf4C/sZUH
	 SbqF0aiQYP0QJiC3NY85wnxcjgGVZa00xSGg2IqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Val Packett <val@packett.cool>
Subject: [PATCH 6.6 290/508] clk: qcom: dispcc-sc7180: Add missing MDSS resets
Date: Wed, 20 May 2026 18:21:53 +0200
Message-ID: <20260520162104.928681364@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b0bc6011c5499bdfddd0390262bfa13dce1eff74 ]

The MDSS resets have so far been left undescribed. Fix that.

Fixes: dd3d06622138 ("clk: qcom: Add display clock controller driver for SC7180")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Tested-by: Val Packett <val@packett.cool> # sc7180-ecs-liva-qc710
Link: https://lore.kernel.org/r/20260120-topic-7180_dispcc_bcr-v1-2-0b1b442156c3@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sc7180.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/dispcc-sc7180.c b/drivers/clk/qcom/dispcc-sc7180.c
index 9536bfc72a43c..166a4170e76f7 100644
--- a/drivers/clk/qcom/dispcc-sc7180.c
+++ b/drivers/clk/qcom/dispcc-sc7180.c
@@ -16,6 +16,7 @@
 #include "clk-regmap-divider.h"
 #include "common.h"
 #include "gdsc.h"
+#include "reset.h"
 
 enum {
 	P_BI_TCXO,
@@ -635,6 +636,11 @@ static struct gdsc mdss_gdsc = {
 	.flags = HW_CTRL,
 };
 
+static const struct qcom_reset_map disp_cc_sc7180_resets[] = {
+	[DISP_CC_MDSS_CORE_BCR] = { 0x2000 },
+	[DISP_CC_MDSS_RSCC_BCR] = { 0x4000 },
+};
+
 static struct gdsc *disp_cc_sc7180_gdscs[] = {
 	[MDSS_GDSC] = &mdss_gdsc,
 };
@@ -686,6 +692,8 @@ static const struct qcom_cc_desc disp_cc_sc7180_desc = {
 	.config = &disp_cc_sc7180_regmap_config,
 	.clks = disp_cc_sc7180_clocks,
 	.num_clks = ARRAY_SIZE(disp_cc_sc7180_clocks),
+	.resets = disp_cc_sc7180_resets,
+	.num_resets = ARRAY_SIZE(disp_cc_sc7180_resets),
 	.gdscs = disp_cc_sc7180_gdscs,
 	.num_gdscs = ARRAY_SIZE(disp_cc_sc7180_gdscs),
 };
-- 
2.53.0



