Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A1B36C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302211; cv=none; b=HJeIhBFdfjIg40tfeVXiOH8ycrfgKoD/eFWQTi9A30QCnGU2A+pnh1tWubqS/1nEluXde9dSFTk0Dl3nI5JqSnSCO95ReE6Ma31GarTSq6aWbHsg0HtShKypCMjOZJt4U7ovIcKRQbXDJqEhJrxBsmWP1Ebbz/lIg4gtR2wogmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302211; c=relaxed/simple;
	bh=Lr1zEB1GzNvxTD1qHigQC5QyEbCZPxLGwK70P9xje9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0K/BsXo3IlbsK9ugIxn0eCTkemGlhwFFos2L1f62Plweoh/Vh7GOIlu7l/jpheVL1ppzHLol70jLyzVwrWy9SqZRE7wmsmxX8rK9a4fX2o1LwIwgcjR8a2BX6yJLxaljB4PWesUVU6GuEJOcXutlRU62KpaNA2EB50t04KSTvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s861vV6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s861vV6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAC7C2BC87;
	Sat, 28 Feb 2026 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302211;
	bh=Lr1zEB1GzNvxTD1qHigQC5QyEbCZPxLGwK70P9xje9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s861vV6U4oEknhOL3xHCqnsLWICf6iZcaljxIeM+1SwMjmhdwqDWY/Fg1+jkcsK6L
	 YTxjhgrnZsoZlmWoIp96bypXN3pK2yqZsfdjTNc7LZx32wtGmNEpMQpatKqPiQChY+
	 6mfZk5Qo0jwtZDzmFTIZnZxL7AFh/mmNx0zmC0mWgGfDYhNnyBv5iF2xUoe//a7aWt
	 gJCNw0FllvMixq1lBUIuVOT369kxfPiSVReTp6u2JcYkF40A1/beYKupOivMB4iDQv
	 n/X7iork/dvhpc6QIdWf2NSPvrYfURrihJzlzkX4SOMaKi7fdiWRrfgslTJQuc9te/
	 vh41UPdrMXc/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/283] clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 13:05:59 -0500
Message-ID: <20260228180709.1583486-217-sashal@kernel.org>
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

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 4b057462bb61a6571608ba393e6e018c9da9c9c3 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: 108cdc09b2de ("clk: qcom: Add GCC driver support for SDX75")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-4-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdx75.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sdx75.c b/drivers/clk/qcom/gcc-sdx75.c
index 573af17bd24ca..314bacd03374b 100644
--- a/drivers/clk/qcom/gcc-sdx75.c
+++ b/drivers/clk/qcom/gcc-sdx75.c
@@ -1033,7 +1033,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_17,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_17),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1057,7 +1057,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_18,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_18),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

