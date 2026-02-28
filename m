Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D194734250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301883; cv=none; b=EPajto8yxCj+XmP1+c/jUsEeCZkLYHz2mxPgVfBYu4OvF8hI6jSvuZPESeWFbLD4FHUpv2YsbGNNTk6jUrXJVm4QJWLmA3E0aqQ6l97yk/3EN9RQ0qbUmS21f4iBwGFlcswUwiei23uwlj+kN/NMWVM57Z94wEIFZEkpjywgCmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301883; c=relaxed/simple;
	bh=13Kgcwwrk+FhsARwHbznuYJFzshB8KHHwlYWODOlww4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLzXvSqUHFlKcG5Gt5MaLhQ96ZJw9OMtCwVSPK4N27mCb8Rnz2yZ06Sy7xQKCnbue5bS8t1IN8UARdAsz/2FoVkJ9vC2ewLXHAy/YNzYZmEUX52ziCmkKU1X/gGZuPPTt9eTESbl/ZtZl4Mk9IBtvczP/LsBMltVZ62tmLQBeoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0Gkki7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0Gkki7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB09C116D0;
	Sat, 28 Feb 2026 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301883;
	bh=13Kgcwwrk+FhsARwHbznuYJFzshB8KHHwlYWODOlww4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0Gkki7DJOUKESuwyTXamCwpYpFV+Mwa4dQUUrGmEkGsSYupY21LF/QuY3GJeqEEq
	 R9d0cMhS83THdBGhhXsm1JIOo7hNu/+IlnOfdqd7NabqZGDSbzpDNL4ITDc77+uVv1
	 Qk7MtWtfQXMgcb6LDIefKSxjyEEQIBGXQtsUjjMiiTk1MYhLBGRfQ5xfNMNt0n7Vam
	 GsvlqT4nbcYNUv6PHxoxyXvqRXm8976PFNjs8alCG28j+OUIXCxrjYTCbutxxfU3su
	 vIM//VUzNaXsQ+siP8rm1qXSZNXxm+cetYyx6cYvoXZ5cUDqkaVqEWRK4DMacEjQaF
	 UOXaKFnGN+3lg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/385] clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
Date: Sat, 28 Feb 2026 12:58:51 -0500
Message-ID: <20260228180011.1568201-309-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 3e2a2ae2ee6e9..cb5e18b084296 100644
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

