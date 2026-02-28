Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80EF34250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301884; cv=none; b=b08wXv2PyvexWw+YeOrUpqQwWKNsyh6tFhzpWf27RmYgu3z6SkFhJGOU6uYaVVY5BXaVpQ/UBjfjb0qe5hTiO8RQlTT1JNK3T9rD7MbATde/fX0eI3G14LRwIUKswqTAKmWFIeXw78qyoH3dDVHssgxE9/C01AWnZedA0ZPzOEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301884; c=relaxed/simple;
	bh=lTq8tF2SrsWTNPJMHBPozgeF7BoUO7m2XfbNiO9TTV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUUes0rR9j6YgN5WzepgHHHyqX7lHstSE/Y1h/+kuvLiBAN1yu5tYH9mFAvP/zYr0DjPxUlKN6kKJj4h+WMuvgt3PU2/+ke8Ed0BVn4unBG5MT/Pjh3qeRAawAatK9E3aIFxtqzKyiumPWcAyzyTw4MI7NMd4XOswAVU9xPhZ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhN8L/O0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhN8L/O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031C8C116D0;
	Sat, 28 Feb 2026 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301884;
	bh=lTq8tF2SrsWTNPJMHBPozgeF7BoUO7m2XfbNiO9TTV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhN8L/O0w9+oMYlhtqGMxBK0xaLUr8v9ug4lsP2TVMf6fbu8mviEjBbAs4KJqySE6
	 XiClRcnomy/gAVqb8yAzy4ud4Mqrhq1LzoMG45N1iPZKJr8lTCIOzanCYP7tVnUVG6
	 ppM6jOOL3iK9M1BaS5pSP1H/pkQp26dsskdcdQfLkB9XZgD2BjZ1QKfg5B4UOdM0XR
	 OR59JZ6xQLyoYrk9C/mGLThM066i5lM8giTR2w2W/uZ7PE6qh8xfxJMSEPCEhqRNdE
	 FT4qDGQkMdgzfbmE3dCiXUxx47vNnernA+v7VXFV/05hz19ahySVTNdFjIwFPTe1mg
	 +abSiv+vHvwmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/385] clk: qcom: gcc-ipq5018: flag sleep clock as critical
Date: Sat, 28 Feb 2026 12:58:52 -0500
Message-ID: <20260228180011.1568201-310-sashal@kernel.org>
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
index 24eb4c40da634..ee45ba9f13e06 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1340,6 +1340,7 @@ static struct clk_branch gcc_sleep_clk_src = {
 			.name = "gcc_sleep_clk_src",
 			.parent_data = gcc_sleep_clk_data,
 			.num_parents = ARRAY_SIZE(gcc_sleep_clk_data),
+			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.51.0

