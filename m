Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649AE3B0AF0;
	Sat, 17 Oct 2026 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255991; cv=none; b=U3BpOa4u6uQEeT0cZ+RulCyCB6MdrNum1jll7y1M6HNbCH0bZbyY2Wsw4CYtOaNildaikP8G6AHBPmykBvY61/akc8YBbsC+a/U4sFn90EEsFHMpL259UJIrFdYrNkr1QyhzaoEyDPOmGhZiTojjpY6EDLMGblB/BsmDK40sQ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255991; c=relaxed/simple;
	bh=ttNTox4frV4kuiTJMMslBklgjHJYnwZeB08YysbM2UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLkr9VDuLDrRib5upmlj7hF73mNcPnWnIwDW31dYtM6EczVUQYBFW1zz24ApccfhQSYJiHrN4vheCx8ty6zTYs4tdA9QFa+/paWpZ2hhJ2gEET0jE87AyASSo5rpgKF7WY6umOIJB6rFWkkJ8c8wGOlEy89YWtiTtgK/seVsSPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1ugb7XS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1ugb7XS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CC71F000C4;
	Sat, 17 Oct 2026 16:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255990;
	bh=G0IeNDEV4ZefU4/M6GZilR+3OsD6JVkb96iCtzbFdsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1ugb7XSmygUhf4tIZIZN1gPYGGzYSUh7bfnMVrFFo1DrpCcW3qJ45oreYJayfGj7
	 KngSIWyvvLfhWTgFFWUlE3YYBECW8/zonoiKnWS82Vbs1nTHx4q21uS3U20T+/PrJl
	 hzptLXnNf6kkrAoHLqdlo3vsdpnpczzhjC6+m4vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0088/1674] clk: qcom: Fix test_ctl_hi field for DEFAULT_EVO PLLs
Date: Sat, 17 Oct 2026 17:39:20 +0200
Message-ID: <20261017160433.397472775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit 830ead322c39c99bf972425b3c35323ec56c29de ]

CLK_ALPHA_PLL_TYPE_DEFAULT_EVO type PLLs do not have the PLL_TEST_CTL_U1
register, so clk_alpha_pll_configure() does not program test_ctl_hi1_val
for this PLL type.

The GCC PLL configurations for QCM2290, Shikra and SM6115 wrongly use
test_ctl_hi1_val instead of test_ctl_hi_val, deviating from the hardware
recommended settings. Fix them to use test_ctl_hi_val.

Fixes: 496d1a13d405 ("clk: qcom: Add Global Clock Controller driver for QCM2290")
Fixes: 01cf3e27824d ("clk: qcom: Add Global clock controller support on Qualcomm Shikra SoC")
Fixes: e88c533d8a2a ("clk: qcom: gcc-sm6115: Add missing PLL config properties")
Cc: stable@vger.kernel.org
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260729-pll-test-ctrl-fixup-v1-1-246d79589380@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ Omitted gcc-shikra.c changes because the driver is absent from the target branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcm2290.c | 6 +++---
 drivers/clk/qcom/gcc-sm6115.c  | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcm2290.c b/drivers/clk/qcom/gcc-qcm2290.c
index 7b9c978f92332..fc56996e4c419 100644
--- a/drivers/clk/qcom/gcc-qcm2290.c
+++ b/drivers/clk/qcom/gcc-qcm2290.c
@@ -116,7 +116,7 @@ static const struct alpha_pll_config gpll10_config = {
 	.vco_mask = GENMASK(21, 20),
 	.main_output_mask = BIT(0),
 	.config_ctl_val = 0x4001055B,
-	.test_ctl_hi1_val = 0x1,
+	.test_ctl_hi_val = 0x1,
 };
 
 static struct clk_alpha_pll gpll10 = {
@@ -148,7 +148,7 @@ static const struct alpha_pll_config gpll11_config = {
 	.vco_mask = GENMASK(21, 20),
 	.main_output_mask = BIT(0),
 	.config_ctl_val = 0x4001055B,
-	.test_ctl_hi1_val = 0x1,
+	.test_ctl_hi_val = 0x1,
 };
 
 static struct clk_alpha_pll gpll11 = {
@@ -309,7 +309,7 @@ static const struct alpha_pll_config gpll8_config = {
 	.post_div_val = 0x1 << 8,
 	.post_div_mask = GENMASK(11, 8),
 	.config_ctl_val = 0x4001055B,
-	.test_ctl_hi1_val = 0x1,
+	.test_ctl_hi_val = 0x1,
 };
 
 static struct clk_alpha_pll gpll8 = {
diff --git a/drivers/clk/qcom/gcc-sm6115.c b/drivers/clk/qcom/gcc-sm6115.c
index 13e521cd42596..ad3abb3aa6388 100644
--- a/drivers/clk/qcom/gcc-sm6115.c
+++ b/drivers/clk/qcom/gcc-sm6115.c
@@ -120,7 +120,7 @@ static const struct alpha_pll_config gpll10_config = {
 	.vco_mask = GENMASK(21, 20),
 	.main_output_mask = BIT(0),
 	.config_ctl_val = 0x4001055b,
-	.test_ctl_hi1_val = 0x1,
+	.test_ctl_hi_val = 0x1,
 	.test_ctl_hi_mask = 0x1,
 };
 
@@ -173,7 +173,7 @@ static const struct alpha_pll_config gpll11_config = {
 	.vco_val = 0x2 << 20,
 	.vco_mask = GENMASK(21, 20),
 	.config_ctl_val = 0x4001055b,
-	.test_ctl_hi1_val = 0x1,
+	.test_ctl_hi_val = 0x1,
 	.test_ctl_hi_mask = 0x1,
 };
 
@@ -367,7 +367,7 @@ static const struct alpha_pll_config gpll8_config = {
 	.post_div_val = 0x1 << 8,
 	.post_div_mask = GENMASK(11, 8),
 	.config_ctl_val = 0x4001055b,
-	.test_ctl_hi1_val = 0x1,
+	.test_ctl_hi_val = 0x1,
 	.test_ctl_hi_mask = 0x1,
 };
 
-- 
2.53.0



