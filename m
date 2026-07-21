Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D414C9567;
	Tue, 21 Jul 2026 15:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649428; cv=none; b=HwTVjHKAhMxLiMb5/IiwT5n3x8t0KM7umouMrsCcycOSKBuphldnigZJ4O5/mkFp66GTKYSoU2JS4SzeR5GhXjXOvHT/XrLlNmG5KyKPF77hLTKydxwderr5YIF/LSfzlyScVvM3GinqeTUpyR7uz+i+awUx3JWWioWf/bezecw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649428; c=relaxed/simple;
	bh=cpPTrI+WuCvJJxGmlprEb7rPKkt+rouiL7jUU3TsFl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogMsVcr6I8rEv/9SSRf3sTuxrRmeLEy8WT9ojPRbb31SdFopTSb9/pu7DsNzkcO/zfNBGKPSTgNfo7/FlkzZfwVt0QTMOw/8HJzAMosULCMoCjBeDb/5OU7bncCFqAAglJXBxEEgUPo7oePlLGFhzixnRc6w8rAh/id+PKVikdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mejcxkgv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mejcxkgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574B31F00A3A;
	Tue, 21 Jul 2026 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649426;
	bh=N/hzsOoImkArUGyerUl7cnAkh/RdZwF6CVeKk1zJrQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mejcxkgvHD2HbJluQLLrpXZCNCXLsQj1sxF//DhnCvy3wJhjfR7N8CUSgKMTS41nS
	 hLkeJnKmLPdQ2OUPGESFF6yupi3pG+c3xuCfcyEaspWGiYdsZdyXCjPK6tFA6U9oUe
	 QTY2AmfZMQtIOg4RD27NVdKKJx0Yd6AY1dv6Y+HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexandru Gagniuc <mr.nuke.me@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0574/2077] remoteproc: qcom_q6v5_wcss: drop redundant wcss_q6_bcr_reset
Date: Tue, 21 Jul 2026 17:04:07 +0200
Message-ID: <20260721152606.346124273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Gagniuc <mr.nuke.me@gmail.com>

[ Upstream commit 6ad61d0acd41044a949e84f96a5f8e02284d350f ]

The wcss_q6_bcr_reset used on QCS404, and wcss_q6_reset used on IPQ
are the same. "BCR reset" is redundant, and likely a mistake. Use the
documented "wcss_q6_reset" instead. Drop ".wcss_q6_reset_required"
from the descriptor, since all targets now need it.

This changes the bindings expectations, however, it actually fixes the
driver to consume the intended ones (qcom,q6v5.txt), which lists
"wcss_q6_reset" and *not* "wcss_q6_bcr_reset"

Fixes: 0af65b9b915e ("remoteproc: qcom: wcss: Add non pas wcss Q6 support for QCS404")

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Link: https://lore.kernel.org/r/20251208223315.3540680-1-mr.nuke.me@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_wcss.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_wcss.c b/drivers/remoteproc/qcom_q6v5_wcss.c
index c27200159a88a2..b391724cfd08e1 100644
--- a/drivers/remoteproc/qcom_q6v5_wcss.c
+++ b/drivers/remoteproc/qcom_q6v5_wcss.c
@@ -96,7 +96,6 @@ struct wcss_data {
 	unsigned int crash_reason_smem;
 	u32 version;
 	bool aon_reset_required;
-	bool wcss_q6_reset_required;
 	const char *ssr_name;
 	const char *sysmon_name;
 	int ssctl_id;
@@ -134,7 +133,6 @@ struct q6v5_wcss {
 	struct reset_control *wcss_aon_reset;
 	struct reset_control *wcss_reset;
 	struct reset_control *wcss_q6_reset;
-	struct reset_control *wcss_q6_bcr_reset;
 
 	struct qcom_q6v5 q6v5;
 
@@ -309,7 +307,7 @@ static int q6v5_wcss_qcs404_power_on(struct q6v5_wcss *wcss)
 		return ret;
 
 	/* Remove reset to the WCNSS QDSP6SS */
-	reset_control_deassert(wcss->wcss_q6_bcr_reset);
+	reset_control_deassert(wcss->wcss_q6_reset);
 
 	/* Enable Q6SSTOP_AHBFABRIC_CBCR clock */
 	ret = clk_prepare_enable(wcss->ahbfabric_cbcr_clk);
@@ -803,19 +801,10 @@ static int q6v5_wcss_init_reset(struct q6v5_wcss *wcss,
 		return PTR_ERR(wcss->wcss_reset);
 	}
 
-	if (desc->wcss_q6_reset_required) {
-		wcss->wcss_q6_reset = devm_reset_control_get_exclusive(dev, "wcss_q6_reset");
-		if (IS_ERR(wcss->wcss_q6_reset)) {
-			dev_err(wcss->dev, "unable to acquire wcss_q6_reset\n");
-			return PTR_ERR(wcss->wcss_q6_reset);
-		}
-	}
-
-	wcss->wcss_q6_bcr_reset = devm_reset_control_get_optional_exclusive(dev,
-							"wcss_q6_bcr_reset");
-	if (IS_ERR(wcss->wcss_q6_bcr_reset)) {
-		dev_err(wcss->dev, "unable to acquire wcss_q6_bcr_reset\n");
-		return PTR_ERR(wcss->wcss_q6_bcr_reset);
+	wcss->wcss_q6_reset = devm_reset_control_get_exclusive(dev, "wcss_q6_reset");
+	if (IS_ERR(wcss->wcss_q6_reset)) {
+		dev_err(wcss->dev, "unable to acquire wcss_q6_reset\n");
+		return PTR_ERR(wcss->wcss_q6_reset);
 	}
 
 	return 0;
@@ -1062,7 +1051,6 @@ static const struct wcss_data wcss_ipq8074_res_init = {
 	.firmware_name = "IPQ8074/q6_fw.mdt",
 	.crash_reason_smem = WCSS_CRASH_REASON,
 	.aon_reset_required = true,
-	.wcss_q6_reset_required = true,
 	.ops = &q6v5_wcss_ipq8074_ops,
 	.requires_force_stop = true,
 };
@@ -1072,7 +1060,6 @@ static const struct wcss_data wcss_qcs404_res_init = {
 	.firmware_name = "wcnss.mdt",
 	.version = WCSS_QCS404,
 	.aon_reset_required = false,
-	.wcss_q6_reset_required = false,
 	.ssr_name = "mpss",
 	.sysmon_name = "wcnss",
 	.ssctl_id = 0x12,
-- 
2.53.0



