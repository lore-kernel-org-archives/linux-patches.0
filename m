Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7E96BB5B;
	Tue, 23 Jan 2024 02:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975373; cv=none; b=bLUjFAA1S7itoOHzlHoMrjVeLspPvBW/VEEV0l02IpVTlkx6/D0TekdXwQ9hbuELLm9QhmSPKLtreH3brSz4woNY6K28BQ1/XVLrHtjwqGjWwZcF5fLu117jLB+lZ6wH7ivzkVKq5MYI6nPTEH9seBPOz+w2x3i6PkGRvBN4aM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975373; c=relaxed/simple;
	bh=/i9+coTjahBXLS/JwBFX8Dt0a6I5FZHcx8DWH/nYiTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwe98xwrTs+EEFEwPpuDUkmvfuVZ9eSMNz6UyVSqYVdXyzfejQaEEl/HhXzLjsPeU/dDpInkD+8am/CQB6LA5m3JL7Q/NsVHLg+UiwTIqQ21kG/g+Zk2szEG6mJlkHx3kZFCUkAIFxeGU7TE9W+DmRSTwaJ+i57647txzDJWgFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erozlHyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erozlHyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A4CC433C7;
	Tue, 23 Jan 2024 02:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975373;
	bh=/i9+coTjahBXLS/JwBFX8Dt0a6I5FZHcx8DWH/nYiTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erozlHyBjUhO+SipNh1Lavggt3s1c+p/ji2oyd0qbUTl5dFTvlE39IJTze2uvTH0q
	 /S85vr2aqTPtgfb8eFlfcQFu88Rkj2h9Q9vOKyeAOcOGJi+WDPj2qU0nPBEIY8qpst
	 J9lVxeI/Cnq39hjnX7WZR0pEAvJR8fsjjud1dcFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/583] clk: qcom: gcc-sm8550: Add the missing RETAIN_FF_ENABLE GDSC flag
Date: Mon, 22 Jan 2024 15:56:01 -0800
Message-ID: <20240122235821.511023412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 1fe8273c8d4088dd68faaab8640ec95f381cbf1e ]

All of the 8550's GCC GDSCs can and should use the retain registers so
as not to lose their state when entering lower power modes.

Fixes: 955f2ea3b9e9 ("clk: qcom: Add GCC driver for SM8550")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-3-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8550.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index 586126c4dd90..1c3d78500392 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -3002,7 +3002,7 @@ static struct gdsc pcie_0_gdsc = {
 		.name = "pcie_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc pcie_0_phy_gdsc = {
@@ -3011,7 +3011,7 @@ static struct gdsc pcie_0_phy_gdsc = {
 		.name = "pcie_0_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc pcie_1_gdsc = {
@@ -3020,7 +3020,7 @@ static struct gdsc pcie_1_gdsc = {
 		.name = "pcie_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc pcie_1_phy_gdsc = {
@@ -3029,7 +3029,7 @@ static struct gdsc pcie_1_phy_gdsc = {
 		.name = "pcie_1_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc ufs_phy_gdsc = {
@@ -3038,7 +3038,7 @@ static struct gdsc ufs_phy_gdsc = {
 		.name = "ufs_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc ufs_mem_phy_gdsc = {
@@ -3047,7 +3047,7 @@ static struct gdsc ufs_mem_phy_gdsc = {
 		.name = "ufs_mem_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc usb30_prim_gdsc = {
@@ -3056,7 +3056,7 @@ static struct gdsc usb30_prim_gdsc = {
 		.name = "usb30_prim_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc usb3_phy_gdsc = {
@@ -3065,7 +3065,7 @@ static struct gdsc usb3_phy_gdsc = {
 		.name = "usb3_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR,
+	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct clk_regmap *gcc_sm8550_clocks[] = {
-- 
2.43.0



