Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F06D366551;
	Tue, 16 Dec 2025 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887365; cv=none; b=eP1dYEsolwgoqsLCNoNwYu+eNL0zDE+RYjztUqVhS14DWO15kvel0bD+EG/oXTf4nmnEEZOJcx5n5YHJbY5XvykiNXfsMQoEIRFJGqNpIFnGY0fleyD/q9lcI0CYvoM4sJDuiRImkCy1WuWUtQX04IsnirPp9ljCECJbFkjRaYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887365; c=relaxed/simple;
	bh=aRnH7rvOaIn0aLEhD8a2qmeGtY2riHAtt4vnDR9QZw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEgBxflKHUdGciHIWQqjlViA0XHqVyPa4izIvTJ0IxVjH728QGDtWn0G1bvQoiA1IBHAGhFl3jdrds2YgIbzPSMHawnibBnXQZ9LmkT6wg6y3+hpz4JxHcljXZCSHhd656f9TDi1ohmcrlW9rl/dtZ1CFPfEYnK5HvCvI58sc90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNltOoKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNltOoKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DC1C4CEF1;
	Tue, 16 Dec 2025 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887365;
	bh=aRnH7rvOaIn0aLEhD8a2qmeGtY2riHAtt4vnDR9QZw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNltOoKJ9BXotuPIbrh+MhiGJx9pjq7UTnOIGdJjJx+7dQgZCw9rkeXjdSDmHDwYp
	 7xK7CEryYbHF6Qsyqmd5YQ8OhzCVbd4fLEQBCgLej9WIdYd/x8HOo6XyOBFkxgF8Tx
	 ar0jRoDyPxlCbwFFWAozN6bGMBWU6X94FdsqDKlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/614] clk: qcom: tcsrcc-glymur: Update register offsets for clock refs
Date: Tue, 16 Dec 2025 12:09:01 +0100
Message-ID: <20251216111407.664830432@linuxfoundation.org>
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

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit a4aa1ceb89f5c0d27a55671d88699cf5eae7331b ]

Update the register offsets for all the clock ref branches to match the
new address mapping in the TCSR subsystem.

Fixes: 2c1d6ce4f3da ("clk: qcom: Add TCSR clock driver for Glymur SoC")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251031-tcsrcc_glymur-v1-1-0efb031f0ac5@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/tcsrcc-glymur.c | 54 ++++++++++++++++----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/clk/qcom/tcsrcc-glymur.c b/drivers/clk/qcom/tcsrcc-glymur.c
index c1f8b6d10b7fd..215bc2ac548da 100644
--- a/drivers/clk/qcom/tcsrcc-glymur.c
+++ b/drivers/clk/qcom/tcsrcc-glymur.c
@@ -28,10 +28,10 @@ enum {
 };
 
 static struct clk_branch tcsr_edp_clkref_en = {
-	.halt_reg = 0x1c,
+	.halt_reg = 0x60,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x1c,
+		.enable_reg = 0x60,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_edp_clkref_en",
@@ -45,10 +45,10 @@ static struct clk_branch tcsr_edp_clkref_en = {
 };
 
 static struct clk_branch tcsr_pcie_1_clkref_en = {
-	.halt_reg = 0x4,
+	.halt_reg = 0x48,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x4,
+		.enable_reg = 0x48,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_pcie_1_clkref_en",
@@ -62,10 +62,10 @@ static struct clk_branch tcsr_pcie_1_clkref_en = {
 };
 
 static struct clk_branch tcsr_pcie_2_clkref_en = {
-	.halt_reg = 0x8,
+	.halt_reg = 0x4c,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x8,
+		.enable_reg = 0x4c,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_pcie_2_clkref_en",
@@ -79,10 +79,10 @@ static struct clk_branch tcsr_pcie_2_clkref_en = {
 };
 
 static struct clk_branch tcsr_pcie_3_clkref_en = {
-	.halt_reg = 0x10,
+	.halt_reg = 0x54,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x10,
+		.enable_reg = 0x54,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_pcie_3_clkref_en",
@@ -96,10 +96,10 @@ static struct clk_branch tcsr_pcie_3_clkref_en = {
 };
 
 static struct clk_branch tcsr_pcie_4_clkref_en = {
-	.halt_reg = 0x14,
+	.halt_reg = 0x58,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x14,
+		.enable_reg = 0x58,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_pcie_4_clkref_en",
@@ -113,10 +113,10 @@ static struct clk_branch tcsr_pcie_4_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb2_1_clkref_en = {
-	.halt_reg = 0x28,
+	.halt_reg = 0x6c,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x28,
+		.enable_reg = 0x6c,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb2_1_clkref_en",
@@ -130,10 +130,10 @@ static struct clk_branch tcsr_usb2_1_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb2_2_clkref_en = {
-	.halt_reg = 0x2c,
+	.halt_reg = 0x70,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x2c,
+		.enable_reg = 0x70,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb2_2_clkref_en",
@@ -147,10 +147,10 @@ static struct clk_branch tcsr_usb2_2_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb2_3_clkref_en = {
-	.halt_reg = 0x30,
+	.halt_reg = 0x74,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x30,
+		.enable_reg = 0x74,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb2_3_clkref_en",
@@ -164,10 +164,10 @@ static struct clk_branch tcsr_usb2_3_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb2_4_clkref_en = {
-	.halt_reg = 0x44,
+	.halt_reg = 0x88,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x44,
+		.enable_reg = 0x88,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb2_4_clkref_en",
@@ -181,10 +181,10 @@ static struct clk_branch tcsr_usb2_4_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb3_0_clkref_en = {
-	.halt_reg = 0x20,
+	.halt_reg = 0x64,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x20,
+		.enable_reg = 0x64,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb3_0_clkref_en",
@@ -198,10 +198,10 @@ static struct clk_branch tcsr_usb3_0_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb3_1_clkref_en = {
-	.halt_reg = 0x24,
+	.halt_reg = 0x68,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x24,
+		.enable_reg = 0x68,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb3_1_clkref_en",
@@ -215,10 +215,10 @@ static struct clk_branch tcsr_usb3_1_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb4_1_clkref_en = {
-	.halt_reg = 0x0,
+	.halt_reg = 0x44,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x0,
+		.enable_reg = 0x44,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb4_1_clkref_en",
@@ -232,10 +232,10 @@ static struct clk_branch tcsr_usb4_1_clkref_en = {
 };
 
 static struct clk_branch tcsr_usb4_2_clkref_en = {
-	.halt_reg = 0x18,
+	.halt_reg = 0x5c,
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
-		.enable_reg = 0x18,
+		.enable_reg = 0x5c,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_usb4_2_clkref_en",
@@ -268,7 +268,7 @@ static const struct regmap_config tcsr_cc_glymur_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = 0x44,
+	.max_register = 0x94,
 	.fast_io = true,
 };
 
-- 
2.51.0



