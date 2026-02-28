Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC67736C9D3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302207; cv=none; b=pO0WWNFglVhxjokDJVETk1yzii9jif4AVxeb6q+ZfrKfFNQjGFyPB2MCe5u6yWKgL+ctGhyBLqIy055PzT7XslRt4Nq2XfLgRubU7WqMKjIN6YKHkzaaILluPgrqohI6M0XagY3oz22aB0imZbBfBbBnXFaGyJfyLiY1F31c+bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302207; c=relaxed/simple;
	bh=DNB9Q3TSsITaraF82B6N1G1tr7RXR7YoCOZkw4CrsJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zak6N8J6my/HcajznGO0BpGLpzdtHWbQhbx3gRhZimK7MOq4ne4yA2yfT38X+eaRMu6MCQ7BXMhZ9P4bczgeOU4ks2WTz9IR5nBDHy4N8Iew8H0b4Z7NUyPGoc7iqLq9WJIHKkJL/pIXyxqYIaJeuahtAropWUyZpU9Vri0N8GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oft0exEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oft0exEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A31C19424;
	Sat, 28 Feb 2026 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302207;
	bh=DNB9Q3TSsITaraF82B6N1G1tr7RXR7YoCOZkw4CrsJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oft0exEI/GBXvZ2ruTyM/VVduelpkzxMh4ErJ8nwJw/aADrwu26r6Y2xJ+HqvzAIB
	 lKO+ekQOOmCeIGeWcgNT+oL2ZFYcBE+NsZxjjAuaA6W0/I61/WHtTjYG7I2vxKk6PE
	 pOgT405xp4Ij+K+FJFtoonMrzXBLnB3cc0KB3IWo78sN4zX39H7OAfQtEIdabTHCwl
	 gBwj5ac0UkJgB5JM0GuiGAsgfZNN2paoHyjwe0t9G2Rgwpkc1mGDtgJV5HzsMsS5p0
	 y3ieLdtaNnuZ/qfSMPqAkEeFVUuijwkJ+fZVPZz9yfliAZMldamyQJFfKoizfc+rWo
	 VAoPqO/B/jWhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/283] clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs
Date: Sat, 28 Feb 2026 13:05:55 -0500
Message-ID: <20260228180709.1583486-213-sashal@kernel.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 1c06e3956054fb5a0930f07b02726b1774b6c700 ]

In line with commit a27ac3806b0a ("clk: qcom: gcc-sm8450: Use floor ops
for SDCC RCGs") done to fix issues with overclocked SD cards on SM8450
powered boards set floor clock operations for SDCC RCGs on SM8550.

This change fixes initialization of some SD cards, where the problem
is manifested by the SDHC driver:

    mmc0: Card appears overclocked; req 50000000 Hz, actual 100000000 Hz
    mmc0: error -110 whilst initialising SD card

Fixes: 955f2ea3b9e9 ("clk: qcom: Add GCC driver for SM8550")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251124212012.3660189-2-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index b30ece62216f7..3e5ce6fa68058 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -1025,7 +1025,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1048,7 +1048,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

