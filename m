Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B791D175D;
	Wed,  2 Oct 2024 14:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878167; cv=none; b=ZqKxbGZi+hKrq6TXe6oYlSLie+au6wTkSraB4LYIo5XD229gZvWtfMCV2/ZXLQinc2BFbUsPZjY1zcwCM/zHUtWzrjil1x/57u3mboRdAMr1iiTYwB8dhttqW0TLOwpxxNT+FMUp4TgSbpHbcT90zreRuLfmsJ7C0XtnFD61Fdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878167; c=relaxed/simple;
	bh=HMvJZ0gMIXuMTbsiHoLxLkFex8YFPw8yzTKm5o26FUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuToAMS48lDo4zi3YF0kmiWVdxvGtlnlEAaCfOsnvAsFYYOHLl+3LmU3M/qTa6Ybv7m7boHxovTC1f2FIbCbhNTe4DhRFXJzJ+pK4WvEHb4IPGYSDbuC/5tfO1C2tVwytattIl3EbU+EnWc9q2FOxPcYUODJUJDpLQOgYDegFGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRnWBNrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRnWBNrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E74C4CEC2;
	Wed,  2 Oct 2024 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878167;
	bh=HMvJZ0gMIXuMTbsiHoLxLkFex8YFPw8yzTKm5o26FUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRnWBNrfoYw8dXaKqoJdnlm+ctIYj31hmBrzPcDjixZqxmIGZ2usYAuOGSYceDSU0
	 HBp/kNkJM1D48F+xJTaVRshkp89ubGpr6ir+XuzdOFV/80iOhiNpmHQQstkYCYu+ki
	 Q6UPjtKl4vQUlPldrpHDW/mDJsPP87r6laWoGa2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 322/634] clk: qcom: dispcc-sm8550: use rcg2_ops for mdss_dptx1_aux_clk_src
Date: Wed,  2 Oct 2024 14:57:02 +0200
Message-ID: <20241002125823.813138407@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 56918e2a7734d..6ac7a0cd7e063 100644
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



