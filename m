Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750336C9CE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302215; cv=none; b=CuF89WA9H7cymrUsatCdni+EoDPw0Th+Vwc5TWLdxRrNL3tXju5sDqbRJSv+LCtcogJI5RsZZ4zv3oeeG7NWJJFbnfUhHhyAxZ6tQupkzKTdaV3LDBnR8GGaFcjd41QcphqaY7Q9cE/FvJ67Z33CpsJ779bJk6/DNCuJGTM5RCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302215; c=relaxed/simple;
	bh=9MlE/57VsyuTjkQfF3OzE31ZG7oWbY+zqB04Wd+gNwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YI4/zmoaQjR5wQTFkfAPFH7/ds01Z6HGTnXyoXB67ToaTfzK+hMNT8PZFHqUzOAeyWwvQkmOVTqbpOrmPXLyNgJMzELYBObm2R+WP6eFmvsG6Fwu2ukDkf11OrGxp4tJqW9aKlrgx4fz6nQztNMrQU3awPvAzPwGH7rGa+gcEKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTs6FxED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTs6FxED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431B4C116D0;
	Sat, 28 Feb 2026 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302214;
	bh=9MlE/57VsyuTjkQfF3OzE31ZG7oWbY+zqB04Wd+gNwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTs6FxEDGHqNNKNzbD37G7nDBWeddzg31dg4TcYjsM143sG5DamWVs4WpYcqsV81q
	 Y19euV/9OqECPRBS0GeqlKLMFiRaBEFtrUZiSBZ7+vyDz4BDvh3Cvpn7mMJZAJHGeG
	 JVp80erJWXBCeOExF1EhM51vRt3Na3wueHxLvgncvw39hG/S1bfk4tePKN2SW0y4vF
	 CsOjNNhUTnhDvwSIRiRqGk8hGRSPvDTBKie+hmuXnL1zyBegVB8fbgkSSL0cbn+vrV
	 4bdU9qfJ+jbIYcAZ4mmdtaO7puPrOCMqz6P8hzlpgaI4jOYEFqilBbrYpyNAK2eTvM
	 WgZ5yBZ4/YyAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/283] clk: qcom: gcc-ipq5018: flag sleep clock as critical
Date: Sat, 28 Feb 2026 13:06:03 -0500
Message-ID: <20260228180709.1583486-221-sashal@kernel.org>
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 04c4dc1f541135708d90a9b4632af51136f93ac3 ]

The sleep clock never be disabled. To avoid the kernel trying to disable
it and keep it always on, flag it as critical.

Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251128-ipq5018-sleep-clk-fix-v1-1-6f4b75ec336c@outlook.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index 915e84db3c97d..292eaa154737f 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1339,6 +1339,7 @@ static struct clk_branch gcc_sleep_clk_src = {
 			.name = "gcc_sleep_clk_src",
 			.parent_data = gcc_sleep_clk_data,
 			.num_parents = ARRAY_SIZE(gcc_sleep_clk_data),
+			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.51.0

