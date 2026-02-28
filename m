Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4F36C9DA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302214; cv=none; b=WHJ695mYArYaPdzjPsArHMZNcMMSegTuueekBwMJU4oMf0ZvORhE1IL1SAbMyZRtQi/M9GPKFvS4mhndPHnMX+4W1X/XySYSvk0+b6HXQXsxuBGVOBu8Y6ok5OcfM2zxMCtqH9wu9gHh5VnXjnzMuGBpvy01oCcOilsgaEDYodI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302214; c=relaxed/simple;
	bh=hmmoqOcB36ddB9o6tayXv8dZ9cHa2AJdX4CtOkr9FJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+lcd+x9bAQ3eqRD/YhSWNnxkLx60Q1DNYBUGvyuo75etrVFO1Rv/UDGMazzU/gCTssnOBkM4xllGCYwsfqdk7WrPikX2MJbDYIrRFrPosaakP25NHaIp55IRpWVpjLd0rSp+AiZ7yAf/Q3LBcYYlazBFdbnSojVIcr6MOALxGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEOi5yp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEOi5yp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E54BC19423;
	Sat, 28 Feb 2026 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302214;
	bh=hmmoqOcB36ddB9o6tayXv8dZ9cHa2AJdX4CtOkr9FJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEOi5yp8Afzl6ydfjdYR6nJDbCn9haO1NqPpjFFtA//RimKZBbRf1fKRQxGu5mmTD
	 71wuVGn4BlMePK1y+JzJn2BM92p0tFjkCl3WkHnci8lIr9YboSFaylvEH8SyuPQ16j
	 DAok6pexuOlxKEGSmCDL/c5n/RJOdUZqeLDic5e2DrlWeaDlG/gndlb/7wV9SonM0Y
	 y0siYv9JhkGC+amE+pMi/wFwaktz4Sn7E1rLsDlRqK/B4U563i6MHRo1m1LZTlsnIA
	 PrtE++LVm/IjdR0jPeu9r6x5XJP/b2bBJc+OQrowCF7A57S0yakD2Ly5mV0D3eX9LA
	 pqbqszopkJh2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/283] clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
Date: Sat, 28 Feb 2026 13:06:02 -0500
Message-ID: <20260228180709.1583486-220-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit e4eb42f290aecac0ba355b1f8d7243be6de11f32 ]

cpp_gdsc should not be always on, ALWAYS_ON flag was set accidentally.

Fixes: 33cc27a47d3a ("clk: qcom: Add global clock controller driver for MSM8917")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251117-fix-gdsc-cpp-msm8917-msm8953-v1-2-db33adcff28a@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8917.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8917.c b/drivers/clk/qcom/gcc-msm8917.c
index f2dd132e2fb1c..0be62cb7a6228 100644
--- a/drivers/clk/qcom/gcc-msm8917.c
+++ b/drivers/clk/qcom/gcc-msm8917.c
@@ -3034,7 +3034,6 @@ static struct gdsc cpp_gdsc = {
 	.pd = {
 		.name = "cpp_gdsc",
 	},
-	.flags = ALWAYS_ON,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.51.0

