Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320D11D0956;
	Wed,  2 Oct 2024 13:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876261; cv=none; b=sezKXWzzy1H0q4qVwVT2VLWm8bHkaSOE6eTKTSU1BuvntpqBFxJHDGj/pNteuyhcqQwrr7CeePTfumW2gJlwiOuVvosrd4mqwCrvrS5iJLoxde7rUulpP/ADKweXdUE3Abkn2u5Ke4qWFiP6ymhmH9t5yxVsSx3xyPuNT8TvriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876261; c=relaxed/simple;
	bh=OsUN2y/GXP5eFCbcljJUnBUhFewvjK3NoxozVrDbV28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+W6spUFchCr3pZARsFm3F8J5vnb13VKYfli5CgkTGKVDPKJ1fcGZA2d6VeaU0YHh10notOr2j7eAJ4IDnWAiLWCVeEawBvh5gofguwHI2c7v4Ap6gglq93K0Z/f1wi5Fh664FAtSDZpDmVG798Ovd2hgFdn1zs66xLQec7rbfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEOmOloA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEOmOloA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB89BC4CED2;
	Wed,  2 Oct 2024 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876261;
	bh=OsUN2y/GXP5eFCbcljJUnBUhFewvjK3NoxozVrDbV28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEOmOloAVemTjmP4hFHLZgR7uxoXyj9KxJKtcFRyjmFCnRp6TwmTWKXQ6tkCah4iE
	 XUZhnTV2qAQTM2DYhkkZLZfBhJQ/s1GHBlhEvhdQgrrP8wUd64gyyzH2sO6nI8Usu8
	 EiQsZXDFwxX+iK212hgsNVLVuY71qqdWs31Ztzt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 356/695] clk: qcom: dispcc-sm8550: use rcg2_ops for mdss_dptx1_aux_clk_src
Date: Wed,  2 Oct 2024 14:55:54 +0200
Message-ID: <20241002125836.655248041@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit cb4c00698f2f27d99a69adcce659370ca286cf2a ]

clk_dp_ops should only be used for DisplayPort pixel clocks. Use
clk_rcg2_ops for disp_cc_mdss_dptx1_aux_clk_src.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240717-dispcc-sm8550-fixes-v2-2-5c4a3128c40b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index 954b0f6fcea28..a98230540782c 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -400,7 +400,7 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_aux_clk_src = {
 		.parent_data = disp_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_dp_ops,
+		.ops = &clk_rcg2_ops,
 	},
 };
 
-- 
2.43.0



