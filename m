Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500A775809;
	Mon, 14 Oct 2024 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917962; cv=none; b=tfKo77WDaxSObS8/ZZzVAOaGtFSnb/yK3MoHxffVdFR5br8Y1JEl92CBDFxGgMuAiJ2jv0hU1eiNLtBr0GogutAHRZ3J5ORvGwakEobfkPPO0dZjYx8IOUzAU01po2eoxmPoN/7mbhH2L6746Nf6xOGxVAKBytn7sV4mf3mIxAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917962; c=relaxed/simple;
	bh=E/J93sUeAkq+X7Udzm2rSqtZaVZwymMZGwVvI2oSW1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RA8bNPeu3nJYq/PY9LRBzQdbQAjDDkJQqeZWMSaqJx6CWl3VGEc8o09X4MKH/sDtwSw43tTEutvLM325ebLwIQW9WupfixPWDY3JbnuZ6iW2SAOMSdd6RkB979JnL0klTZvLtaU09fRVbgR/BzBOm2iCNofjph3JjgRB4nS7dIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocN70vWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocN70vWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956AAC4CEC7;
	Mon, 14 Oct 2024 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917962;
	bh=E/J93sUeAkq+X7Udzm2rSqtZaVZwymMZGwVvI2oSW1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocN70vWGPrtC9WWQvUStkZ5mnamCxjReBDcK6KdIyREA4KbqRAnPTmYBDYvMWF2TA
	 aXefHMz4ZEDa8oTEJE5m47skGQqEV+Yh2Ou2iVESr7IL6g5D7Diw7AK+6kYsyIaML+
	 BXCr0niLYf+niPOy6jkmY4g2jyXJMh2KdJSfSsYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/798] clk: imx: composite-8m: Less function calls in __imx8m_clk_hw_composite() after error detection
Date: Mon, 14 Oct 2024 16:12:17 +0200
Message-ID: <20241014141225.124136012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit fed6bf52c86df27ad4f39a72cdad8c27da9a50ba ]

The function “kfree” was called in up to three cases
by the function “__imx8m_clk_hw_composite” during error handling
even if the passed variables contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/147ca1e6-69f3-4586-b5b3-b69f9574a862@web.de
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Stable-dep-of: 8f32e9dd0916 ("clk: imx: composite-8m: Enable gate clk with mcore_booted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-8m.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/imx/clk-composite-8m.c b/drivers/clk/imx/clk-composite-8m.c
index 3e9a092e136c1..d36fb533da564 100644
--- a/drivers/clk/imx/clk-composite-8m.c
+++ b/drivers/clk/imx/clk-composite-8m.c
@@ -189,7 +189,7 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 
 	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
 	if (!mux)
-		goto fail;
+		return ERR_CAST(hw);
 
 	mux_hw = &mux->hw;
 	mux->reg = reg;
@@ -199,7 +199,7 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 
 	div = kzalloc(sizeof(*div), GFP_KERNEL);
 	if (!div)
-		goto fail;
+		goto free_mux;
 
 	div_hw = &div->hw;
 	div->reg = reg;
@@ -229,7 +229,7 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 	if (!mcore_booted) {
 		gate = kzalloc(sizeof(*gate), GFP_KERNEL);
 		if (!gate)
-			goto fail;
+			goto free_div;
 
 		gate_hw = &gate->hw;
 		gate->reg = reg;
@@ -241,13 +241,15 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 			mux_hw, mux_ops, div_hw,
 			divider_ops, gate_hw, &clk_gate_ops, flags);
 	if (IS_ERR(hw))
-		goto fail;
+		goto free_gate;
 
 	return hw;
 
-fail:
+free_gate:
 	kfree(gate);
+free_div:
 	kfree(div);
+free_mux:
 	kfree(mux);
 	return ERR_CAST(hw);
 }
-- 
2.43.0



