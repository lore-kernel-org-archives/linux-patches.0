Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76AB359A90
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302443; cv=none; b=ICWaFj+hTRdfutTCBcX///7FNrqFNPZYy+8x7EQ/ASOX8W9xGQIVIik3Y783rTWg4Z/fOjM+Q+uv8HSzYNk33HDsuCG97nx0WD8u0ZdusyoqoLjYSg7KvNP43YPmikRXDfz8vtr+JayRjJsQqHZXklIJoPD+malF5AxBWY7QfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302443; c=relaxed/simple;
	bh=CJ+Bz7cWYNKqpvbf/CNeALrzCXwwog1rvZ0IUKc6aw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=In6fJ+g1xBgvQjvQwhDNCXrJ5ChZWNxxNn7P09a/wElQ4oroWvsbiAQZR1/HSu7laxjNRcOPwYsO8YfThtsYP9TAvDJOY4jKUU9104jDAJgPaMbiMDgfayPAEl7WbzSX+FMkWP4nYTXLxFdZEOy7Ce5ZsFkev03awHgzG2ymQT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oAuOZIBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAuOZIBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FEFC19424;
	Sat, 28 Feb 2026 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302443;
	bh=CJ+Bz7cWYNKqpvbf/CNeALrzCXwwog1rvZ0IUKc6aw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAuOZIBoX8WSQuo62JVWilhRwPgdGXf7V9iHDpesGXaV4cytcDe7me7QVv5QDDib4
	 X6xCGcPZs1VpTT/uv/jT7LEVwbHfeXCzST3Dd1xEjKtJRXL3gT8zqF8ZycoF+/87Gb
	 P6/QGGti5rV2ymlRn8Z4iG1xZX4i9ZimaRwWgeqD6zmnD4yzqjx24TrjDB49nMeNI6
	 +vgrJYPKZrl6bSMkhOSDU4YGtHRVPA+BvpOjvFJ1iDd1H119AN9ZGzhFkyMywBuHY6
	 T6qYNC9cQQamhvSwRDhXBUi8rZNpFyjbc31op6FMti4IvC58oLTXFnJIwNlMHock+k
	 s0upaQKHd2+pA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Hodina <petr.hodina@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/232] clk: qcom: dispcc-sdm845: Enable parents for pixel clocks
Date: Sat, 28 Feb 2026 13:10:35 -0500
Message-ID: <20260228181127.1592657-182-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index e792e0b130d33..eae6dcff18da5 100644
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

