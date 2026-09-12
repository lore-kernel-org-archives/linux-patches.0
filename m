Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BBD380FD6;
	Sat, 12 Sep 2026 08:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200644; cv=none; b=o57DbCZDEP6tiKqmbXvGwEwFCz4uc/hHjELVfNecVFgtKi5CzTxdwb1bOVWRpIbmO74l0YkYm9W09xYHfbfd4FAjw3VKdX0FQpZSl9RyNUFYcUr++eNMXTe/O8TFdXpPiVIiiGm+QH88bKl9r0MiOdE96x5T4OZMXFqHJNh3/9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200644; c=relaxed/simple;
	bh=jvSeYl/hvgg7LWO+IXcnbjM9uWJa9qSbFmyGm4gQb9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+SgS+OZotMO1KqKTKfBjwiAbiH3KSTqGfHfXDs+42N/ZckMSIpXOU+EFg89IlXkxlb3zX1FDZoGC6cRBXoC2+GUuVK7jamYsDlnIDZAMYFwEoZ1nSi6NMI4rwYrOUQrrnUU7TKUAnAM9h3AEOdIMhqtOW7qkyNjk78QXWc8aEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Icom8Mo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Icom8Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8031F000FF;
	Sat, 12 Sep 2026 08:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200642;
	bh=7WXl8A3AzZ9tz3XXPY44Q1AZTlwLq0UxGPtSksS2QKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Icom8MoaU8H/YyCsqlBifsFwwiWweucUP8/LFQmFRbxjYj9RPQFSXmljXp8GsbHz
	 8WljOSzFRGflbvpDzD/iJTo5vukpI+5X6vDU6rY2gYH4nu+1utliu6eki35nNFoucV
	 zgt/CrW9KXVl3tVx6STMG0Y6ih4+ONTjUAP6vtYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0833/1815] clk: qcom: qcm2290: Update DISPCC and GPUCC GDSC *wait_val values
Date: Sat, 12 Sep 2026 08:43:03 +0200
Message-ID: <20260912065708.469457528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit 08cfbfd81dd6e27167b1331e0c485bd0414cf5fe ]

Update the QCM2290 DISPCC and GPUCC GDSC wait_val fields to match the
hardware default values. Incorrect settings can cause the GDSC FSM to
stuck, leading to power on/off failures.

Fixes: cc517ea3333f ("clk: qcom: Add display clock controller driver for QCM2290")
Fixes: 8cab033628b1 ("clk: qcom: Add QCM2290 GPU clock controller driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260718-shikra-dispcc-gpucc-v6-7-62703e05ef0f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-qcm2290.c | 3 +++
 drivers/clk/qcom/gpucc-qcm2290.c  | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/clk/qcom/dispcc-qcm2290.c b/drivers/clk/qcom/dispcc-qcm2290.c
index 1b796698dff5a..d32fd3f8d7acd 100644
--- a/drivers/clk/qcom/dispcc-qcm2290.c
+++ b/drivers/clk/qcom/dispcc-qcm2290.c
@@ -451,6 +451,9 @@ static const struct qcom_reset_map disp_cc_qcm2290_resets[] = {
 
 static struct gdsc mdss_gdsc = {
 	.gdscr = 0x3000,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "mdss_gdsc",
 	},
diff --git a/drivers/clk/qcom/gpucc-qcm2290.c b/drivers/clk/qcom/gpucc-qcm2290.c
index 8d397cadc86aa..4e97a02d942ad 100644
--- a/drivers/clk/qcom/gpucc-qcm2290.c
+++ b/drivers/clk/qcom/gpucc-qcm2290.c
@@ -296,6 +296,9 @@ static struct clk_branch gpu_cc_hlos1_vote_gpu_smmu_clk = {
 static struct gdsc gpu_cx_gdsc = {
 	.gdscr = 0x106c,
 	.gds_hw_ctrl = 0x1540,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0x2,
 	.pd = {
 		.name = "gpu_cx_gdsc",
 	},
@@ -308,6 +311,9 @@ static struct gdsc gpu_gx_gdsc = {
 	.clamp_io_ctrl = 0x1508,
 	.resets = (unsigned int []){ GPU_GX_BCR },
 	.reset_count = 1,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0x2,
 	.pd = {
 		.name = "gpu_gx_gdsc",
 	},
-- 
2.53.0



