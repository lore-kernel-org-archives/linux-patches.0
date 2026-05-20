Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB667347515;
	Wed, 20 May 2026 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301086; cv=none; b=UJLp0tf2z0bpqq5nojFYvEWLKQqvnh+VZIzu8gq0tJirMacX16bHzwZqZC5Z9Glss+iC4lwlb2u5Ot+kBjBTnV5tDe9yg42OUeIHTfzA7mtsfDxhiAzB8aIhJ2KPDEBgQe4A+uWZaNkCepL0mJa4eKqpk8OEiHsOifKk+aQovUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301086; c=relaxed/simple;
	bh=YGPxNxLwqrhZD21PQeknOIsFhBaZxfz+ClrGnS84Gvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnU5vO9R2zIfbWv7C7TqTRtIS6LFcLwEYYzIDXy50INhnKXiSKrmpYg/iRzYM1KECUolXVIi6pNUq2z9dmONdNxywnB7KQI5KAFHmfe0ZHRDwJ44jKqRnbL9bEMwwjpHx0ZI+0Mwv2qLEnP8kcrkv3VdAbmW6dc192cQ9rmanMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2midWth6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2midWth6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518821F000E9;
	Wed, 20 May 2026 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301085;
	bh=lP1lYezKVEn6bPfeiV3GMJHO7gP8GgKen/nSr41nDZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2midWth6MScB1Oz2vV3iMPV5uPZDp2tbVaX5/tNyMFviF0RdFUBB0EdWLnKg2GugY
	 QvPZrhlub0Sm8WkZYd5iPitAE8AScG0po3vx2Z02mOi/0eNoWk6cNvli59lwUwJauP
	 7rXrLzlgUlS3LkrD3diabEx4mJaHDblteNXpRZ40=
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
Subject: [PATCH 6.12 420/666] clk: qcom: dispcc-sc7180: Add missing MDSS resets
Date: Wed, 20 May 2026 18:20:31 +0200
Message-ID: <20260520162120.370244982@linuxfoundation.org>
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
index 4710247be5306..ae98fe4dcfb2b 100644
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



