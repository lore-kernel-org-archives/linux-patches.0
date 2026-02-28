Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DDE36C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302216; cv=none; b=jlU9ycEU89pDSpbHy7uWe87ekHSVobKrXgMJYdCUYNd2Us6qXLdftGMWMmI1RgKuVo6AwkbWI3eurmCk+UnfRKM+lA1tFCqqX37D0y5TZbvPsGqZrpOBCBDe9lmneP1Y0vZ6jhQbR/yzXVbbXGzc6Jfq9sxn+Uk7ioBqlNgmkJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302216; c=relaxed/simple;
	bh=CJ+Bz7cWYNKqpvbf/CNeALrzCXwwog1rvZ0IUKc6aw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTA1dHQ/7OMYFIiY5CjAC4UufIzub0pWpDCoEqTmHcz5cej1mhjJgFgVgqJm2VeP64gSUltdSu1ZpzU3k1Yp33sPp61vBTEbtkWWn6Pj5PdLeQasDXNjZAMeJYsWsAKYlVL3OgNALNbWZmXKW7aF5TDuAVbtpCNYLJZ24uOg4Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egzpKTB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egzpKTB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8981C116D0;
	Sat, 28 Feb 2026 18:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302216;
	bh=CJ+Bz7cWYNKqpvbf/CNeALrzCXwwog1rvZ0IUKc6aw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egzpKTB3dogIScaPEhMvWCQ3WmU4nwNloxexX9H5MIH2pq5U027eJG+V4seEMhiC+
	 EfhM+VExIz0RayvubK9gzxLSwJmGy5jExoCXkq74h73N8Lr3jn+J5azTkQSg09eR1b
	 L5VaUdySKZDfEgRf9ets/vGeZzsFXaISZ2aDntuPE85IcLehHIvo99p9efuGtfb9s1
	 2/2n+nWQpkc8bzdqu5wNjDc0GlGyPWf0+pBztqq4ftbdoRRNg7jZXDxeS3SvcMyhO/
	 jAnA9JoipxMz+CqVbrzg/7DvwRTvl/kKX+6JV/Y0v/MTExM0gIXIT+d70uiAPXtfPf
	 hR/qi1A75xzgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Hodina <petr.hodina@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/283] clk: qcom: dispcc-sdm845: Enable parents for pixel clocks
Date: Sat, 28 Feb 2026 13:06:05 -0500
Message-ID: <20260228180709.1583486-223-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

