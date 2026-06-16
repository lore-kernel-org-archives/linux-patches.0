Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48EC44CAF9;
	Tue, 16 Jun 2026 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625433; cv=none; b=AWBfHzlSN5wDNJlzFiJ5UZPosT0228z7kjORSen3/qZiTP6kVx68D+iz1+ZtUAoAcIXPk2lMvpnUcSKIOsTkNqpykXZFz4Ncab6pGZ+IswigyKH8GfBD23ZUWx16ZaGbfWhnwyo0CZZok1FsODE5rucIrHvHYEm7Lwc57UiPPVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625433; c=relaxed/simple;
	bh=GBbmKVBFvYI7v0VNvunGZRv2GNmZSVf2iMzVZ/CxYss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iAqkVg4HCaidKfJzlsB7pmp8Y/d1RfHylXk1LOddqdTeysigNO+mWM6/e5+BH1/k45u/W4fAR39YMc5Bo7CXhed/uGdwOJyEhdGTIZJbPqkWFZVYNv76q1bPWw8ZL4R6mTn6CWMWsI1y4Y2cVRF++NgefroTISQdFMpFr7dFttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV+FZb+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV+FZb+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B321F000E9;
	Tue, 16 Jun 2026 15:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625432;
	bh=5CNpZqaKTh7VYsU7UpYDTMkgcMn2Tan1G0emEtRsUac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vV+FZb+C3QbtUoNGVrtZ5Ok4qclELDP3o6kjyvkwyy5YerKTr/F+vHsX/LtuPTN4J
	 3YJrnRs9Fjh8oBn74i9rqozJiyMGHrsX6tZbIxT1cE3Sru97vPHFF4fzyOtWe2t1dG
	 FEvSw2rlQ6U0Kc3h99bG12Lxq+SOJWEZIFlS3Qjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= <jerome.debretagne@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/325] clk: qcom: dispcc-sc8280xp: Dont park mdp_clk_src at registration time
Date: Tue, 16 Jun 2026 20:28:57 +0530
Message-ID: <20260616145104.753454197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e91dfed0f37e9b..acc927c2142ab5 100644
--- a/drivers/clk/qcom/dispcc-sc8280xp.c
+++ b/drivers/clk/qcom/dispcc-sc8280xp.c
@@ -977,7 +977,7 @@ static struct clk_rcg2 disp0_cc_mdss_mdp_clk_src = {
 		.name = "disp0_cc_mdss_mdp_clk_src",
 		.parent_data = disp0_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp0_cc_parent_data_5),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
@@ -991,7 +991,7 @@ static struct clk_rcg2 disp1_cc_mdss_mdp_clk_src = {
 		.name = "disp1_cc_mdss_mdp_clk_src",
 		.parent_data = disp1_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp1_cc_parent_data_5),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



