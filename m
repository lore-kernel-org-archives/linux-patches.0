Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF9936C9D4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302213; cv=none; b=oST3eJeIgU4M9gSqxkOFvBC+3W/CfeJvHVV2Fvtdqil9kQisZ5QWgb0eyW+36HUA2a746z9PsCYadDsEmWIRUsMnXgYs8S5WBdgwx2UkNEk2IIzsCZW4P+t2voTUuU+9J9b2xP5yevAxQ9EymuxC61gFm1d2pNsxGkRl42LPETs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302213; c=relaxed/simple;
	bh=u9pnSmoZS3EWYzQsH+xVNOk52tiuj80nYRCtaaQ8Q+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBqM3RXJGo8z1Bpe3G16yWjMUBrwcrQxy3rpGvCJ6YRJhyysPF8K3FAncu/FiA2p/M9xPEvoQez5+1uqVb5UaAQxHMUhaCebaGAxwtlx+o2jIOoQdv1zOmUbSQLcC2prJHFuWZGjz5vMSI8i11aFtp0ugrhf3B8VVfmUCFiJm4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nudxKZYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nudxKZYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99876C19424;
	Sat, 28 Feb 2026 18:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302213;
	bh=u9pnSmoZS3EWYzQsH+xVNOk52tiuj80nYRCtaaQ8Q+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nudxKZYItswt0ImqoQRd5+hqDDclbgj+I566bUAB1VNvGHJdMGWJ63GnVAqXLcNBU
	 KVOfh2jNrjF0RaX1ogEMGpFGzmcWmPQVIf9Ezpf0PdbZNQwk31pms9icEOKt4NvHv1
	 HUBojgnuwOHrRKJIT+Ub11j6pGbI4TJOOyN1EFQr7fWgS0Yyv13jFeoCnCiafXN8MZ
	 jwXK7MwRqU813AiVtHhTWMqj5yV4oUVSwbEHF7opuZKz3IU8G/jQve+Cqn4LpRDryT
	 EYcRpIjIRDo8PcL2VjUGdJMQkQMlx0sL0jVkStyWymzD54jBCptqkU0hN12//gEbJY
	 ytkF/eZzlO2Fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/283] clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
Date: Sat, 28 Feb 2026 13:06:01 -0500
Message-ID: <20260228180709.1583486-219-sashal@kernel.org>
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

[ Upstream commit 5f613e7034187179a9d088ff5fd02b1089d0cf20 ]

cpp_gdsc should not be always on, ALWAYS_ON flag was set accidentally.

Fixes: 9bb6cfc3c77e ("clk: qcom: Add Global Clock Controller driver for MSM8953")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251117-fix-gdsc-cpp-msm8917-msm8953-v1-1-db33adcff28a@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8953.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8953.c b/drivers/clk/qcom/gcc-msm8953.c
index e6e2ab1380f20..1689f08814063 100644
--- a/drivers/clk/qcom/gcc-msm8953.c
+++ b/drivers/clk/qcom/gcc-msm8953.c
@@ -3946,7 +3946,6 @@ static struct gdsc cpp_gdsc = {
 	.pd = {
 		.name = "cpp_gdsc",
 	},
-	.flags = ALWAYS_ON,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.51.0

