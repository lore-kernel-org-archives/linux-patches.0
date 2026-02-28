Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD8039B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302614; cv=none; b=DD7px4f1xHgoKrjk2+o+s2PRRx1qlYdGHAEaDUcReh66C9nRjvrV3qw1VF3xRxgLUQJ9rFtwhUlVkxmEbFfz3c+HpniQaRjII9ewEUu8GvyrdjrAyyecLue3Ha3qXidganq9XDSvt6EO0Gq4huHii3BcmSiTPqDivlforVLceiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302614; c=relaxed/simple;
	bh=CJ+Bz7cWYNKqpvbf/CNeALrzCXwwog1rvZ0IUKc6aw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNfz3EhoL3wD+dpBjMKKojD8wAFo8zGj5NzdzRII6IQ5Y+1kdAztd6sGnVmUmUAKKvwz38EBgfsIMEnsUPMMXaR74Vz8nqs/8g1ZyIZwO+ugPbPYVpnWHddMx0OEkqUOM6ClhzoJf9TNl4z6eodXmll1N8MqjNkwxC4RW0EbX+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvUaur1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvUaur1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03675C19424;
	Sat, 28 Feb 2026 18:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302614;
	bh=CJ+Bz7cWYNKqpvbf/CNeALrzCXwwog1rvZ0IUKc6aw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvUaur1NqySY1BrLsvO1lwUAVkECSjLzW2u3SWWv7ZBqo9DYZmCsNTXYOXj8Rhdtr
	 sgNFefoo57r8sYooCtGQwZkqcussf2GlkKmKbwhfsmZwdz+U7Lst3USAxNxIwiZ7Zk
	 QBKlwl8JkagdYtY97hmscI99HqTMKNkPcOVt+QWyxMUhBPNocCoYzymuXLqswjg48N
	 0K3i25e6JaA7ENp3ssJF7Mvmuy2FhbYXcXUCykVGGhu2+vZbrjpEKqwXk3TM3ml6IQ
	 Yktl7CdOzrOx2dfv1vRCBDoMIVT4INEXhPyJjQdhQQWkHNQJRwGrXvBhbAlZV5/MIk
	 9Regtrwa4Wbtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Hodina <petr.hodina@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/164] clk: qcom: dispcc-sdm845: Enable parents for pixel clocks
Date: Sat, 28 Feb 2026 13:14:30 -0500
Message-ID: <20260228181505.1600663-131-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

