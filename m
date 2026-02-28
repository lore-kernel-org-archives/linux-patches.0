Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4461347FCC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302441; cv=none; b=r777wJclnEQCG/MquXB0ArUItEMh2W9GQa83JaWSOoPBan6mWtsSnTu79xdURAVH86VQLkR0RfThLpWnVHJYXVmb+EH3cR3C54dmIf0xU5ik2/I6rz6Vk9bL7DDW7dvXYSLvN7Fbp+X03N3BusfGl4iyMko8j0TYgW8mocZpjBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302441; c=relaxed/simple;
	bh=s9Ohbn1Nnxgn79g47kdegEosP0Oh34R/PpcDYWBmv3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPqFSgemVFz3rAnEYUwSr6+y1cHFHePfYHORqQHLWddTp/ZpgR/Uixesa0CMCcjZGTxlHfNzpKsRVFNjI0vW9qMVKIXljFlWAesXmTZjQEP9Ys9v+h0TY0cQ1OUOoj3XicDMeVjI9tc83qEtytLpCPo69/rOs39OR2THMIfp7OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdOdzXte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdOdzXte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2874AC116D0;
	Sat, 28 Feb 2026 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302441;
	bh=s9Ohbn1Nnxgn79g47kdegEosP0Oh34R/PpcDYWBmv3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdOdzXtePp81vCPVEkhLAwaZ/tvzG4SrTd66Nfn7xDKofsmkXwL+9UzQS+BVydmnC
	 nNk0rmMTkHgn896Vgyxe10cNgn1XIvHxAZ09XlGY5WVRmMZPs/5HYYLjOst7+dBOVO
	 m7YJKhA+nsqmWoaU6AkmMBfXNeWS6hbXWoFlYeQskPJFOSTYY0G4drExcPwaGjBAaZ
	 xXUxR7nJNelDUDaKNR4nVqT5V27UsoKJ6L8oFamBYrIAxchilkli7QNp2xdLQCLJWQ
	 HY0AUnlNtOUf7PAcl16HuhEf7yNFY/yGKNG+NCvueaL679QKjc++1+Qe3cfu/vsMT6
	 E4Y7wfVXV5phQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/232] clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
Date: Sat, 28 Feb 2026 13:10:33 -0500
Message-ID: <20260228181127.1592657-180-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 3b32830f7466a..954076ff74a39 100644
--- a/drivers/clk/qcom/gcc-msm8953.c
+++ b/drivers/clk/qcom/gcc-msm8953.c
@@ -3947,7 +3947,6 @@ static struct gdsc cpp_gdsc = {
 	.pd = {
 		.name = "cpp_gdsc",
 	},
-	.flags = ALWAYS_ON,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.51.0

