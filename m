Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469533AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302750; cv=none; b=j64t7Te8tWaQtv80Rnb7zNgFo6xe0I5GdAyfxNwwPnqz8JWk9oasmW4tyBoDcjBIvO42sG4zHQz2ZRhESeq1QQ+Kd6Pt0kqHE6LbhgfiIDO3/lWXMfva+VoTD/Ll0cXPj2csCHI6xCF2xmnmZ8QBQjVozbZaFzXPg6mOLNyhUO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302750; c=relaxed/simple;
	bh=GuegHkb+anV8bHPlVQnshA2LLSdvrip+5GPoGFUjs4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRPZmlPw7ko8f1uFtp1njIY4lu2AtROqWZpltk6SM5tF3r5os7iRrLWmdMZBji/WaPdZKbaRGejPsKAx612QhRIMJtxdk9trQ8xczKCtK56lwRHtiprfzLlgsHoZLgXOANu8iDYf+YhigRthRFJ0w76NL327k7YKoWOFiM3+Gl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VU88hHDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VU88hHDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0018C116D0;
	Sat, 28 Feb 2026 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302750;
	bh=GuegHkb+anV8bHPlVQnshA2LLSdvrip+5GPoGFUjs4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VU88hHDE8UGXrdiPa9MbhuSEJwnmcmWLpdxKpQoT3OBoSQGfg8EDhR90dgS9/sCQt
	 WpIgmnpIyHkxqySm5/yIRoGh2OkE6qQfUFX1TOpjpvoIooJLCLzBsBU+WAhz93uyuN
	 zfH3rMIXh7Vm5x88TepyP66PoyoIcJ+lIrspCb3F8Af1AFkfBctLKzyHCbJ+X0cJFD
	 OPvq44CN52QCMW50KCSZekZ//qj3i5uRtXn4vlFbMreacJ7T8As6vr7sY/4aFbXPtE
	 KEKdsi1jW8IAhlTfk2o6OJHq47Ueyy/2kPMDQIwcVhB10V2J2MEipPtc3rUTpOsne1
	 Glfw4cx5ZLouw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Hodina <petr.hodina@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/147] clk: qcom: dispcc-sdm845: Enable parents for pixel clocks
Date: Sat, 28 Feb 2026 13:17:06 -0500
Message-ID: <20260228181736.1605592-118-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index a71e103553bbb..8263723099019 100644
--- a/drivers/clk/qcom/dispcc-sdm845.c
+++ b/drivers/clk/qcom/dispcc-sdm845.c
@@ -291,7 +291,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk0_clk_src = {
 		.name = "disp_cc_mdss_pclk0_clk_src",
 		.parent_data = disp_cc_parent_data_4,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
@@ -306,7 +306,7 @@ static struct clk_rcg2 disp_cc_mdss_pclk1_clk_src = {
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

