Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE4C34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301881; cv=none; b=KfgD/pc8B3ikdvcV/shbVlzK8sMJbPPxd+UD4tHqTAxrIGVV/erdlsab5uZlfHACSH6zx2UN8uSdSSAPnHWAUS9ScrsLh9qJxWAqwgK7N2zLoCjgVm4uKSJ41aEtaT8y9GnbpDROsH40sZSMtJyX7i05/s6jgJWQ4I9dx7of26A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301881; c=relaxed/simple;
	bh=5uNxe6x+7o/Faj+CiSMlLMjHBL57cjqVSVgiDR02buc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2931CRS4HXpSENQWFvGTbLrH8G6l48iWgdJuA/Q1Gnf+excT/xQnjjtJ/Xmh5tmuCEMtNMOdV9Uq3/EXkyzZw3cp7TCSOvxP/MIn+LEDWLlLZS4ASnlR+hhXh3awYsZNtRNl7WRR0cUdDYpzHglsCfJ77XgT5PgEb7ABhcabt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zxy5OGOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zxy5OGOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6647DC19424;
	Sat, 28 Feb 2026 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301881;
	bh=5uNxe6x+7o/Faj+CiSMlLMjHBL57cjqVSVgiDR02buc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zxy5OGOp/drtN4m7omsbIXoDxaAa5yokD5JbW3jP7H1Loc6Q7NicdHgVxnqN7eTP1
	 tc9UiHBHPVlSzKMCrsM7Zal/QNRLZSkJOuKKroVpeN3OOfIIer9rJ0E80hI+FjsNLQ
	 Nipemx2WsW6Iopp4rKYNBjimkE3IHw+wLSOXh4kO7AqUbXdnaMYFSvb0i8b65KPV62
	 /SbU8x3B2QNBjhybH3p8qLCq8sTenO8Qp8GxKcNPUdiErPL9XNKErTRhseYKTecTHZ
	 11SreH3wlVUe7xMTYfnCkEKyjzn2IGqyQDYTC9p1amogjB5on1Cq/XKvk7L/lQGSBR
	 hQjdlUIYFdhbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/385] clk: qcom: gcc-x1e80100: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 12:58:48 -0500
Message-ID: <20260228180011.1568201-306-sashal@kernel.org>
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

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit a468047c4e1c56783204a3ac551b843b4277c8fc ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-6-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 86cc8ecf16a48..0c49f0461ae32 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -1516,7 +1516,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1538,7 +1538,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

