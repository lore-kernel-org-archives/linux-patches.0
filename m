Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8254A1D2B1E;
	Wed,  2 Oct 2024 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879885; cv=none; b=hw7AphyfAXWZyWGrYhdKBDvntbi19hF5VM7fHWiO+VCS5KwVQqYLijt8BfU9oKiTtYvzjOSyU+VT0M8D76/UlbABdTZBhnd33YjzY/N2d4xOdeScTOIypLoTk+VNEy7P84qx8wE/LcbtLL/T373z9kJG/HwqZ7F2yOP31+WPxH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879885; c=relaxed/simple;
	bh=KxhOdn1cgVFxex8rXFHlWOLq2jV8hW8hbw7nrKIwcOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBKijrGfIlOPc8DBM+kDo3w4IHToTWELXICPCpfUYzPbl162SKBMosSbXBJHM+RSCaX046sptrfenWLMagNkmlEOaNyBVHklu0uxrMsvjW/f5k6RCFL5fQvPq9POCPrw/uuVNlGHdajBCy3jR6VSEMaedbAwTumT2o0i+iz+kcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+EoL/QS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+EoL/QS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0995EC4CEC2;
	Wed,  2 Oct 2024 14:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879885;
	bh=KxhOdn1cgVFxex8rXFHlWOLq2jV8hW8hbw7nrKIwcOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+EoL/QSWeJmQxmDC9QWpVfItyCRlmithDp0bYRanpKI3D40XlAS3P8ibxkb6AH0V
	 6rxKhC/G8vdoZ7P2T/kaf3a32BLWXYne0b5ikOtY7WaBviVkkQEpprfnkUSdh9z3ig
	 +Wnx38ed1Ut0fsxWJBFIYpNdSMjnBTmXjNi53e+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/538] clk: qcom: dispcc-sm8650: Update the GDSC flags
Date: Wed,  2 Oct 2024 14:58:31 +0200
Message-ID: <20241002125802.993610222@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7de10ddbdb9d03651cff5fbdc8cf01837c698526 ]

Add missing POLL_CFG_GDSCR to the MDSS GDSC flags.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240717-dispcc-sm8550-fixes-v2-4-5c4a3128c40b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index 72558ef25e9e8..9b63d62057ed5 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -1611,7 +1611,7 @@ static struct gdsc mdss_gdsc = {
 		.name = "mdss_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL | RETAIN_FF_ENABLE,
+	.flags = POLL_CFG_GDSCR | HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc mdss_int2_gdsc = {
@@ -1620,7 +1620,7 @@ static struct gdsc mdss_int2_gdsc = {
 		.name = "mdss_int2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL | RETAIN_FF_ENABLE,
+	.flags = POLL_CFG_GDSCR | HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct clk_regmap *disp_cc_sm8550_clocks[] = {
-- 
2.43.0



