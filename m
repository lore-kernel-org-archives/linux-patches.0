Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7B7333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301886; cv=none; b=o9almi/So65QiKUaSR5aIf1yO8510r1l7r6QfOQigSu/mPMm1UV4OL7NzXOTr6ruI7gLn9KwNxh1JyG6njWyH6jDRY5KAlzEIX5b2P/+P5DLIwL4nfuNpBKpPUuGzmpNH27xCaXxShNjmwjuw3L0gX/cmUdnRLjlnS2iwa8JzRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301886; c=relaxed/simple;
	bh=SgBw40HkhmUMh/fgewbB+4Mfp0G9CWUSemRHU4y62a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grchcr7eERKKREC+Ud7mavmMNUqwovn8mqSZIS2BIsYXuJCLJk25i78QGPisIg0PVJT82/CFlAcymU3AaKBplb6B5FXAoHofe5LmBV5wTl/GByyJw0WFx/9KlAHtwSO3EAw5B5BKSVOazQTbps5CQMa2vipLMQkVzJNV6krYte0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXp0mUFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXp0mUFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4089C19423;
	Sat, 28 Feb 2026 18:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301886;
	bh=SgBw40HkhmUMh/fgewbB+4Mfp0G9CWUSemRHU4y62a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXp0mUFn3ZBTTsSQOKS445IkxbbsKUgyAAa5LG0x4xQDuolUPl6pe6fodR7LemQO9
	 OG5D7c9kkJRVCkCtWTEBtD+cG8H/cJy43stjxbnvyaoodDy9mumFiuYdjUR1hnMc+q
	 8QMRO9BybHKZcbHU+sOIdLptJkqVjZ0NikowUrN8nE+do74hbhvYt7H9ACmvJuoHNq
	 RjEsgvQ5R+91/XZJkdQhL4nd97mL9Tqgt4gdt8q+JMVfBsXH1hBYULHQ+xCc5ZOOc6
	 bDikhcTImCiVw24M7jw0zjCkWCQlhFsCQG6q35+4GaYaonle8BGAOks1eqcGtAwAr3
	 n20uh5zmTxOAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Hodina <petr.hodina@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/385] clk: qcom: dispcc-sdm845: Enable parents for pixel clocks
Date: Sat, 28 Feb 2026 12:58:54 -0500
Message-ID: <20260228180011.1568201-312-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petr Hodina <petr.hodina@protonmail.com>

[ Upstream commit a1d63493634e98360140027fef49d82b1ff0a267 ]

Add CLK_OPS_PARENT_ENABLE to MDSS pixel clock sources to ensure parent
clocks are enabled during clock operations, preventing potential
stability issues during display configuration.

Fixes: 81351776c9fb ("clk: qcom: Add display clock controller driver for SDM845")
Signed-off-by: Petr Hodina <petr.hodina@protonmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20260107-stability-discussion-v2-1-ef7717b435ff@protonmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sdm845.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sdm845.c b/drivers/clk/qcom/dispcc-sdm845.c
index e6139e8f74dc0..1859c093a241b 100644
--- a/drivers/clk/qcom/dispcc-sdm845.c
+++ b/drivers/clk/qcom/dispcc-sdm845.c
@@ -280,7 +280,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk0_clk_src = {
 		.name = "disp_cc_mdss_pclk0_clk_src",
 		.parent_data = disp_cc_parent_data_4,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
@@ -295,7 +295,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk1_clk_src = {
 		.name = "disp_cc_mdss_pclk1_clk_src",
 		.parent_data = disp_cc_parent_data_4,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
-- 
2.51.0

