Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F07C1D223D;
	Wed,  2 Oct 2024 14:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879852; cv=none; b=bKBojZwQoET7+fvV1BIypCDv5p/We5zkXc2m1lRSFwtJHISD9LBGf8HZNzv7ZOSlXuWFZze9gayVrg8vmxuXteQkIo19g9m/zh0kQkU6N1yDKTGsdATYqi514TBCgtz50BbTynUTGsWr70vtrySlAyts6/wAePdJEHHtDsDXGFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879852; c=relaxed/simple;
	bh=k2tsakUFgN1OJ9qnDemBwg/54Id3THrRDAAmhXg9uIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yge0VhQF1+kRjXPa/JVuC5MotDdSpFp6/TfIZsV6mGNYMDfcrTFdSVgHVVCGqYO3UgL5x1GI+VCRYZF93XpWDB630Pfqobw+zKg8jjcJ8ZSuG5bdygfWJXK4iOmFrhTsPYvVkUJ9gxnJokm9cTGjRFOai5u7XwfbFkXvvzBqlbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFYK3M5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFYK3M5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB76FC4CEC2;
	Wed,  2 Oct 2024 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879852;
	bh=k2tsakUFgN1OJ9qnDemBwg/54Id3THrRDAAmhXg9uIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFYK3M5MtJxEV03A+SxXqb6w8uKg/JNjsoRZUVXItg2yCv5qeQxcjUaayAMlC5sNC
	 rdTQnv92S8o72bXYFxbRAhcPS7YRXrxO8LtKA1mV1+lm7+Z3JZdWdZnuZZHJ9Ud24G
	 5Ef+t9osVuNr2K5rCtlOvU7G0FyeTOYbXSa1h9kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/538] clk: imx: composite-8m: Less function calls in __imx8m_clk_hw_composite() after error detection
Date: Wed,  2 Oct 2024 14:58:18 +0200
Message-ID: <20241002125802.480521642@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 27a08c50ac1d8..eb5392f7a2574 100644
--- a/drivers/clk/imx/clk-composite-8m.c
+++ b/drivers/clk/imx/clk-composite-8m.c
@@ -220,7 +220,7 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 
 	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
 	if (!mux)
-		goto fail;
+		return ERR_CAST(hw);
 
 	mux_hw = &mux->hw;
 	mux->reg = reg;
@@ -230,7 +230,7 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 
 	div = kzalloc(sizeof(*div), GFP_KERNEL);
 	if (!div)
-		goto fail;
+		goto free_mux;
 
 	div_hw = &div->hw;
 	div->reg = reg;
@@ -260,7 +260,7 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
 	if (!mcore_booted) {
 		gate = kzalloc(sizeof(*gate), GFP_KERNEL);
 		if (!gate)
-			goto fail;
+			goto free_div;
 
 		gate_hw = &gate->hw;
 		gate->reg = reg;
@@ -272,13 +272,15 @@ struct clk_hw *__imx8m_clk_hw_composite(const char *name,
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



