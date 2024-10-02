Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C521D016B;
	Wed,  2 Oct 2024 13:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876142; cv=none; b=NQO/mRz34i/DO5oJaCWkTmx868Xzd6m9kTB0vyHumWDvAmP/gRwlGDzw+At5QSppOjHT1QPOh07Ezvv4TMSkiQd9oPoJlAvv/rsm7P8m+0rfUFTBOrJ/KdtSUnhu+5DDQMsmGHV4HrCI1byBq/5mDFb7jwLxY5A09ZsIGZ0qsso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876142; c=relaxed/simple;
	bh=Ex+8TFRZcxJfI/ygAaVFzlzRVVtmlJOq/XstKYcTbBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti9D5ytHSEdgKdyxPhMVVKZucGcY3Bo9T8VnlBILy20d61gVDZgQqO+wMxPhTXe7FB+yIaYT/Qye9CGSCs6182ix6b1I1q82qeITRXZ33LdINpxZWH8BL4ZsbE2C9yjhWnhKhzJjzyUzK2Tw2HuA3SsRbfRIBN8M5fMXFKZ7g0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAkFWd0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAkFWd0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6908CC4CEC5;
	Wed,  2 Oct 2024 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876141;
	bh=Ex+8TFRZcxJfI/ygAaVFzlzRVVtmlJOq/XstKYcTbBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAkFWd0OrjIcqFiz2nymEHZkKg3T+8ZXpTFptX8HWyNfPfmZ5lpXWnnb+z5W7ftA7
	 sb2ucHAndDgtKyqUnXuvmNtH/wI0rP9gpW2OycXqBXnT0DH9f3tAsRes1RjPq5ZQUA
	 pJg/x6P0cBftUbprbLj2b4nG+DKXuDW8PsnbUhzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 342/695] clk: imx: clk-audiomix: Correct parent clock for earc_phy and audpll
Date: Wed,  2 Oct 2024 14:55:40 +0200
Message-ID: <20241002125836.102782170@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit d40371a1c963db688b37826adaf5ffdafb0862a1 ]

According to Reference Manual of i.MX8MP
The parent clock of "earc_phy" is "sai_pll_out_div2",
The parent clock of "audpll" is "osc_24m".

Add CLK_GATE_PARENT() macro for usage of specifying parent clock.

Fixes: 6cd95f7b151c ("clk: imx: imx8mp: Add audiomix block control")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/1718350923-21392-6-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp-audiomix.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mp-audiomix.c b/drivers/clk/imx/clk-imx8mp-audiomix.c
index b381d6f784c89..0767d613b68b0 100644
--- a/drivers/clk/imx/clk-imx8mp-audiomix.c
+++ b/drivers/clk/imx/clk-imx8mp-audiomix.c
@@ -154,6 +154,15 @@ static const struct clk_parent_data clk_imx8mp_audiomix_pll_bypass_sels[] = {
 		PDM_SEL, 2, 0						\
 	}
 
+#define CLK_GATE_PARENT(gname, cname, pname)						\
+	{								\
+		gname"_cg",						\
+		IMX8MP_CLK_AUDIOMIX_##cname,				\
+		{ .fw_name = pname, .name = pname }, NULL, 1,		\
+		CLKEN0 + 4 * !!(IMX8MP_CLK_AUDIOMIX_##cname / 32),	\
+		1, IMX8MP_CLK_AUDIOMIX_##cname % 32			\
+	}
+
 struct clk_imx8mp_audiomix_sel {
 	const char			*name;
 	int				clkid;
@@ -171,14 +180,14 @@ static struct clk_imx8mp_audiomix_sel sels[] = {
 	CLK_GATE("earc", EARC_IPG),
 	CLK_GATE("ocrama", OCRAMA_IPG),
 	CLK_GATE("aud2htx", AUD2HTX_IPG),
-	CLK_GATE("earc_phy", EARC_PHY),
+	CLK_GATE_PARENT("earc_phy", EARC_PHY, "sai_pll_out_div2"),
 	CLK_GATE("sdma2", SDMA2_ROOT),
 	CLK_GATE("sdma3", SDMA3_ROOT),
 	CLK_GATE("spba2", SPBA2_ROOT),
 	CLK_GATE("dsp", DSP_ROOT),
 	CLK_GATE("dspdbg", DSPDBG_ROOT),
 	CLK_GATE("edma", EDMA_ROOT),
-	CLK_GATE("audpll", AUDPLL_ROOT),
+	CLK_GATE_PARENT("audpll", AUDPLL_ROOT, "osc_24m"),
 	CLK_GATE("mu2", MU2_ROOT),
 	CLK_GATE("mu3", MU3_ROOT),
 	CLK_PDM,
-- 
2.43.0



