Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDCB15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C526BC433D7;
	Mon,  5 Dec 2022 19:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268257;
	bh=mau/BnPvUdpsNKgmTUgDPAQwzLNpDh6A5qnc6YH4Sc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djbbdTUVomPJ5dyYVrrdp3TTnzqj54muh5KLyXJN0usJgFdoL1l6n9mD33CHnFt0Q
	 tYHMpFTxjnKoROLYAvP0tMKuh2TkCeS0mkslFCDEdeG1rDMb3cHf8HPbGqJWlXs6yV
	 uyKX/SWsFPED4TuGB8/eoMbtAixUblvTTrYCrPnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 009/124] clk: samsung: exynos7885: Correct "div4" clock parents
Date: Mon,  5 Dec 2022 20:08:35 +0100
Message-Id: <20221205190808.707281682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Virag <virag.david003@gmail.com>

[ Upstream commit ef80c95c29dc67c3034f32d93c41e2ede398e387 ]

"div4" DIVs which divide PLLs by 4 are actually dividing "div2" DIVs by
2 to achieve a by 4 division, thus their parents are the respective
"div2" DIVs. These DIVs were mistakenly set to have the PLLs as parents.
This leads to the kernel thinking "div4"s and everything under them run
at 2x the clock speed. Fix this.

Fixes: 45bd8166a1d8 ("clk: samsung: Add initial Exynos7885 clock driver")
Signed-off-by: David Virag <virag.david003@gmail.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/r/20221013151341.151208-1-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos7885.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos7885.c b/drivers/clk/samsung/clk-exynos7885.c
index a7b106302706..368c50badd15 100644
--- a/drivers/clk/samsung/clk-exynos7885.c
+++ b/drivers/clk/samsung/clk-exynos7885.c
@@ -182,7 +182,7 @@ static const struct samsung_div_clock top_div_clks[] __initconst = {
 	    CLK_CON_DIV_PLL_SHARED0_DIV2, 0, 1),
 	DIV(CLK_DOUT_SHARED0_DIV3, "dout_shared0_div3", "fout_shared0_pll",
 	    CLK_CON_DIV_PLL_SHARED0_DIV3, 0, 2),
-	DIV(CLK_DOUT_SHARED0_DIV4, "dout_shared0_div4", "fout_shared0_pll",
+	DIV(CLK_DOUT_SHARED0_DIV4, "dout_shared0_div4", "dout_shared0_div2",
 	    CLK_CON_DIV_PLL_SHARED0_DIV4, 0, 1),
 	DIV(CLK_DOUT_SHARED0_DIV5, "dout_shared0_div5", "fout_shared0_pll",
 	    CLK_CON_DIV_PLL_SHARED0_DIV5, 0, 3),
@@ -190,7 +190,7 @@ static const struct samsung_div_clock top_div_clks[] __initconst = {
 	    CLK_CON_DIV_PLL_SHARED1_DIV2, 0, 1),
 	DIV(CLK_DOUT_SHARED1_DIV3, "dout_shared1_div3", "fout_shared1_pll",
 	    CLK_CON_DIV_PLL_SHARED1_DIV3, 0, 2),
-	DIV(CLK_DOUT_SHARED1_DIV4, "dout_shared1_div4", "fout_shared1_pll",
+	DIV(CLK_DOUT_SHARED1_DIV4, "dout_shared1_div4", "dout_shared1_div2",
 	    CLK_CON_DIV_PLL_SHARED1_DIV4, 0, 1),
 
 	/* CORE */
-- 
2.35.1



