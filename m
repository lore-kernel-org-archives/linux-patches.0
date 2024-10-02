Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447251D095E;
	Wed,  2 Oct 2024 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878173; cv=none; b=pqfKEn4sx6+0I/PL/zse8qoYZWEZdGSdXkUpW35ZEPmRCwVfLYWQlsFbetlwGqEWiF8ugjasNzJN3gOR1pIpLVZaOfLDzEh8y0vDxVEJlyXaRHM5+6Vebn0yxYbZgY6bqZrYDgAv86oEAzniXfR444vyCaOGeEz870w7V3PGP/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878173; c=relaxed/simple;
	bh=YVRHVO4Ohj3Tv1YFHZyLhXwmVYPsCBt2aw0Zda6nj44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRQGkBrUDlKLAU3zoXTZ7h3qvXDApkRulSxlq66s2gue3MjdifzK2Cx1W+JSSTTXFarwqaPmp79qStpjJ7pbvijhTDhh/RGyjw8p7gWHEig7ATKzZXQuclE+BCcpIZv+w03RgS0u2GknIjUJKfoqUTD0xbbdkH8FggZ87uZZuWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqTt2mQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqTt2mQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B77DC4CEC5;
	Wed,  2 Oct 2024 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878172;
	bh=YVRHVO4Ohj3Tv1YFHZyLhXwmVYPsCBt2aw0Zda6nj44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqTt2mQs5RwFrYuIGneLxNwNYiTxW8VQSlozVBrV/4ds0J7WnC4m1E2fmEseKhNz+
	 s+74S8JzwO8u2chJC7NLh9fR6pL6HKHN96uAV086Qn0AszHO4Jxz8EGxUhI3N13FZp
	 2KZQeVIX6nnW9RA+pn355XT1aODOorTILH97Wt3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 324/634] clk: qcom: dispcc-sm8550: use rcg2_shared_ops for ESC RCGs
Date: Wed,  2 Oct 2024 14:57:04 +0200
Message-ID: <20241002125823.891428075@linuxfoundation.org>
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

[ Upstream commit c8bee3ff6c9220092b646ff929f9c832c1adab6d ]

Follow the recommendations and park disp_cc_mdss_esc[01]_clk_src to the
XO instead of disabling the clocks by using the clk_rcg2_shared_ops.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240717-dispcc-sm8550-fixes-v2-5-5c4a3128c40b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index abf03fe5727d3..1ba01bdb763b7 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -562,7 +562,7 @@ static struct clk_rcg2 disp_cc_mdss_esc0_clk_src = {
 		.parent_data = disp_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_5),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -577,7 +577,7 @@ static struct clk_rcg2 disp_cc_mdss_esc1_clk_src = {
 		.parent_data = disp_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_5),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.43.0



