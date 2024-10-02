Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8634218DF60;
	Wed,  2 Oct 2024 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876278; cv=none; b=NfOp6Kf1So3HJBSF94+Gd6GP3rC6EzHqGZL2TAkTVyaZ/zKiWcvtrfd7qEvMt6KV5r4iN3MplMEVUDaLUxQgkkjgUc6KHWZNWKfj/NZ85SgjhwCrsoD2JK00HY3g01LcHUeTnIB3OQARdb02j9i3Irlh2UFrU3mVrd0FfBw0bEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876278; c=relaxed/simple;
	bh=lpH6awnpzZrXg/pvQ34FGUcyd/fmrlyjjhBuG9RjEYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNZiQUttOLBboScuOdeL1mIPSMDEccHFQXwDOA2hJIV2wuEtiBaATQ4Eszoxodti72CC7vaAaHNeqlE35Ycs0/JBP4W6XWC0aNfAt5mMrt4cWmD8x8VK3/kxzvjq6ZQqo0QP65/B2K3RelrtTtwwycrfWriUAN64Y98ItbECbEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tst/bNAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tst/bNAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD20C4CECD;
	Wed,  2 Oct 2024 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876278;
	bh=lpH6awnpzZrXg/pvQ34FGUcyd/fmrlyjjhBuG9RjEYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tst/bNAurNyDUKIgUIwH4exFHCLWXVZs9y2LE+gioZ7sRYIqVuvUKAPnoGVxi9mR/
	 bAxiszzjfBr35oVfrYk892EbxLpnJv62yjrYMhO8hH++LcQ0LJk4y0iNdhyNwqY94x
	 uUciF91aL4HTOqp4zLEXbwUiUpAkAm6lc8/4tTho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 358/695] clk: qcom: dispcc-sm8550: use rcg2_shared_ops for ESC RCGs
Date: Wed,  2 Oct 2024 14:55:56 +0200
Message-ID: <20241002125836.734023016@linuxfoundation.org>
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
index eb7e432d9eeed..19066ea58224e 100644
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



