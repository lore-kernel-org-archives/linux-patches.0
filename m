Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEBC2737FC;
	Sat, 12 Sep 2026 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198735; cv=none; b=JrQic46KTtffNTWBhT4nDjfp6IFZ8lsZ8WmV1x3o/PR+M9b/rGT++rBA608Baz1vMPg/if+nz9MYdMHRa0eOfYnFrewqzL96JlvwSpXyiHdXVb1zp3QIOqtcXSI7aDeSbBWAJ2lSQpXQk7SpcIbcf/lWTyzPnjOm9CBxKHoJNzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198735; c=relaxed/simple;
	bh=XcshriV5nXxDN4GXT+FSurCssoSFc3QLgWAbMnPqBP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAkhtOAYT0lBjxmVwwa/6a5k+TqbbEr6E8Y3tf0w/yqZ3fpLMWiO+6UFEia+c//Av780mars7eE5i2aVaZCvsuL34Km5EW15UDLX9YRubk0hYi3lZzFGum9GjlCORmrrdZ+Lpg2qUe6ti3b6C7eIGx70/sY16kXkKRMOJ8qfaHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yw25FuLy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yw25FuLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D0C1F000FF;
	Sat, 12 Sep 2026 07:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198733;
	bh=5Ub3XrbksMEh3WY+6AQ4cEnFoVF36G5Rj9KcMTF4PLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yw25FuLy0aOolkD36Z/d4DYdGZrEnioEZrOde3ss9vCxe6H8MAB/utpy+R+2vJL52
	 GK9J+HdZ6j4PW7UuLoywL3p8kKCMgsOtVCfBWc6BBCYAmFG99wszjZu13ce9cz4cSL
	 MrNBLOtfiENuLMW7kVaKoOluYGNerqjl0TMmE6mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0440/1815] remoteproc: qcom_q6v5_mss: Make ssctl_id configurable per platform
Date: Sat, 12 Sep 2026 08:36:30 +0200
Message-ID: <20260912065659.221381474@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 6aa64a4c89faec9daff36828df38f8f69498a870 ]

Currently, qcom_q6v5_mss hardcodes 0x12 as the instance ID for the
subsystem control (ssctl) QMI service. However, some platforms (e.g.
MDM9607) provide the service with a different instance ID (0x22).

Make it possible to override the ssctl_id per platform by adding it to the
platform-specific rproc_hexagon_res struct. The same pattern also exists
already inside qcom_q6v5_pas.

Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260706-qcom-q6v5-mss-mdm9607-ssctl-id-v1-1-f59e728af621@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 846baa5ab461 ("remoteproc: qcom_q6v5_mss: Fix MDM9607 subsystem control instance ID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index ae78f5c7c1b69..425601af50d1c 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -162,6 +162,7 @@ struct rproc_hexagon_res {
 	char **active_clk_names;
 	char **proxy_pd_names;
 	int version;
+	int ssctl_id;
 	bool need_mem_protection;
 	bool need_pas_mem_setup;
 	bool has_alt_reset;
@@ -2191,7 +2192,7 @@ static int q6v5_probe(struct platform_device *pdev)
 	qcom_add_smd_subdev(rproc, &qproc->smd_subdev);
 	qcom_add_pdm_subdev(rproc, &qproc->pdm_subdev);
 	qcom_add_ssr_subdev(rproc, &qproc->ssr_subdev, "mpss");
-	qproc->sysmon = qcom_add_sysmon_subdev(rproc, "modem", 0x12);
+	qproc->sysmon = qcom_add_sysmon_subdev(rproc, "modem", desc->ssctl_id);
 	if (IS_ERR(qproc->sysmon)) {
 		ret = PTR_ERR(qproc->sysmon);
 		goto remove_subdevs;
@@ -2271,6 +2272,7 @@ static const struct rproc_hexagon_res sc7180_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_SC7180,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res sc7280_mss = {
@@ -2301,6 +2303,7 @@ static const struct rproc_hexagon_res sc7280_mss = {
 	.has_ext_cntl_regs = true,
 	.has_vq6 = true,
 	.version = MSS_SC7280,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res sdm660_mss = {
@@ -2334,6 +2337,7 @@ static const struct rproc_hexagon_res sdm660_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_SDM660,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res sdm845_mss = {
@@ -2371,6 +2375,7 @@ static const struct rproc_hexagon_res sdm845_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_SDM845,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8998_mss = {
@@ -2404,6 +2409,7 @@ static const struct rproc_hexagon_res msm8998_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8998,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8996_mss = {
@@ -2444,6 +2450,7 @@ static const struct rproc_hexagon_res msm8996_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8996,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res mdm9607_mss = {
@@ -2479,6 +2486,7 @@ static const struct rproc_hexagon_res mdm9607_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MDM9607,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8909_mss = {
@@ -2515,6 +2523,7 @@ static const struct rproc_hexagon_res msm8909_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8909,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8916_mss = {
@@ -2562,6 +2571,7 @@ static const struct rproc_hexagon_res msm8916_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8916,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8917_mss = {
@@ -2606,6 +2616,7 @@ static const struct rproc_hexagon_res msm8917_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8917,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8937_mss = {
@@ -2650,6 +2661,7 @@ static const struct rproc_hexagon_res msm8937_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8937,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8940_mss = {
@@ -2694,6 +2706,7 @@ static const struct rproc_hexagon_res msm8940_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8940,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8953_mss = {
@@ -2731,6 +2744,7 @@ static const struct rproc_hexagon_res msm8953_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8953,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8974_mss = {
@@ -2785,6 +2799,7 @@ static const struct rproc_hexagon_res msm8974_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8974,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8226_mss = {
@@ -2824,6 +2839,7 @@ static const struct rproc_hexagon_res msm8226_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8226,
+	.ssctl_id = 0x12,
 };
 
 static const struct rproc_hexagon_res msm8926_mss = {
@@ -2871,6 +2887,7 @@ static const struct rproc_hexagon_res msm8926_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MSM8926,
+	.ssctl_id = 0x12,
 };
 
 static const struct of_device_id q6v5_of_match[] = {
-- 
2.53.0



