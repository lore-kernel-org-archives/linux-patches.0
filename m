Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF5466B57;
	Tue, 16 Jun 2026 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627079; cv=none; b=S9pq+YBl39IHzq8wdtOErABgH7yrswbcOMUTzcAV19ODuLPUVQ4O+d2R/jEU9Tev0W6dcDYIjtth14kwVWcT9MPNmdW87/jQ+InNl5qtiGXqkB/IbJ0vMf9g0uzdxHCaOMdQA0b/c3elF5V1bAG8OIS6xtwnzxNhhxbBNoGfEdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627079; c=relaxed/simple;
	bh=n0k+IC02t5kcwUBCeUZy/avKOFheIHOK2H7OTq5Tc0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFEpifq6n8C/MpVLQWM84tLtmQqscZ23fOMcSP1Wpbx/YAiKvwcrtLzR86MHiXLvH/5FnfkXShP5cD/MR9PJyI4F55jFNMGKADEE68WjuT604rQcKvPdwg2ZNxvacEQLXgAAuqDuRHB5vwASbEsHNpbzFvIPE8C8ExZs7c1kd9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck6IdqW6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck6IdqW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B811B1F000E9;
	Tue, 16 Jun 2026 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627078;
	bh=pZ3vq+gnrOl6u2q5TsGsaOFiKHVor4YqH6FNJ2GoqAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ck6IdqW6iEA9J0Yo8/hzO9iIFH+sPEMOxn8C+UAo0UQQWyYZNOoCiTSYmdbVkvul9
	 F0+PEwLfc9iyUd3nagQYo73GYNwjr358TfIr++ZEOlhyfl4Sib8638UcAP6OzF6EPR
	 N2blEfUwM3jRq9R/O5rNPutycWr+IL/AcKBMsD40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= <jerome.debretagne@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/261] clk: qcom: dispcc-sc8280xp: Dont park mdp_clk_src at registration time
Date: Tue, 16 Jun 2026 20:29:14 +0530
Message-ID: <20260616145050.437534996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 5285b046757844435d1db96c1b5c3a6621b2979a ]

Parking disp{0,1}_cc_mdss_mdp_clk_src clk broke simplefb on HUAWEI
Gaokun3, the image will stuck at grey for seconds until msm takes
over framebuffer. Use clk_rcg2_shared_no_init_park_ops to skip it.

Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Tested-by: Jérôme de Bretagne <jerome.debretagne@gmail.com>
Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Link: https://lore.kernel.org/r/20260303150152.90685-1-mitltlatltl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sc8280xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sc8280xp.c b/drivers/clk/qcom/dispcc-sc8280xp.c
index c23cbb983d29ea..43d26616bd27bd 100644
--- a/drivers/clk/qcom/dispcc-sc8280xp.c
+++ b/drivers/clk/qcom/dispcc-sc8280xp.c
@@ -978,7 +978,7 @@ static struct clk_rcg2 disp0_cc_mdss_mdp_clk_src = {
 		.name = "disp0_cc_mdss_mdp_clk_src",
 		.parent_data = disp0_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp0_cc_parent_data_5),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
@@ -992,7 +992,7 @@ static struct clk_rcg2 disp1_cc_mdss_mdp_clk_src = {
 		.name = "disp1_cc_mdss_mdp_clk_src",
 		.parent_data = disp1_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp1_cc_parent_data_5),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



