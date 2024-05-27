Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E38217E90E;
	Mon, 27 May 2024 19:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837202; cv=none; b=aPtzdv1l6LQeiA7XKNWx7CJ2H77YV6FvhrvXRnhB7k7zwTXCG7JC38mWXOsX72xnEQxgkJvjhyFthsdnYktHTnf0qqmVji3YSENT93lYSl5FnruHLp26S8F1BLknoSc+jmXmpdbCEVmufUSbUnJsRBhu/PqcVBpTLUGmz9M0Rws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837202; c=relaxed/simple;
	bh=Agxk1/k+6tBdRq22CjPgxDUr1Rjo9hccCu98i3uCe6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9OSzyFcSzFfFt/kySevY2DOCuRahuvheOG8h9CdTpO58ebJYLt1Ihgo7+SywzI9LrH1S9tcqmx1riywqwf6R6PPG00ThwfW9rOW9NJ6iK96G2gJacT+aRrt5jhqBkOJ/Gfj8zxmOxjS+z4kb8pdQYJcbii7EZ1QyKtOPwibGzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr2dVjeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr2dVjeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C2EC2BBFC;
	Mon, 27 May 2024 19:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837202;
	bh=Agxk1/k+6tBdRq22CjPgxDUr1Rjo9hccCu98i3uCe6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sr2dVjeVc/xz4pODYPqsIQNFYcTlprnjMtz/n5osRJKBxkCrqQY09AJHFTrpIrCE1
	 kM4kulzcsnuB9rQoH0u6dO06wjfyk2eWICFj2XQzUnmpxzIDAutSpPQW7yCduBUZg2
	 OGqmQXwTYMllLYlnVNDKQmhfi6tDOmv49th7tFqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Kim <jaewon02.kim@samsung.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 348/427] clk: samsung: exynosautov9: fix wrong pll clock id value
Date: Mon, 27 May 2024 20:56:35 +0200
Message-ID: <20240527185633.315352310@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaewon Kim <jaewon02.kim@samsung.com>

[ Upstream commit 04ee3a0b44e3d18cf6b0c712d14b98624877fd26 ]

All PLL id values of CMU_TOP were incorrectly set to FOUT_SHARED0_PLL.
It modified to the correct PLL clock id value.

Fixes: 6587c62f69dc ("clk: samsung: add top clock support for Exynos Auto v9 SoC")
Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20240328091000.17660-1-jaewon02.kim@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynosautov9.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynosautov9.c b/drivers/clk/samsung/clk-exynosautov9.c
index e9c06eb93e666..f04bacacab2cb 100644
--- a/drivers/clk/samsung/clk-exynosautov9.c
+++ b/drivers/clk/samsung/clk-exynosautov9.c
@@ -352,13 +352,13 @@ static const struct samsung_pll_clock top_pll_clks[] __initconst = {
 	/* CMU_TOP_PURECLKCOMP */
 	PLL(pll_0822x, FOUT_SHARED0_PLL, "fout_shared0_pll", "oscclk",
 	    PLL_LOCKTIME_PLL_SHARED0, PLL_CON3_PLL_SHARED0, NULL),
-	PLL(pll_0822x, FOUT_SHARED0_PLL, "fout_shared1_pll", "oscclk",
+	PLL(pll_0822x, FOUT_SHARED1_PLL, "fout_shared1_pll", "oscclk",
 	    PLL_LOCKTIME_PLL_SHARED1, PLL_CON3_PLL_SHARED1, NULL),
-	PLL(pll_0822x, FOUT_SHARED0_PLL, "fout_shared2_pll", "oscclk",
+	PLL(pll_0822x, FOUT_SHARED2_PLL, "fout_shared2_pll", "oscclk",
 	    PLL_LOCKTIME_PLL_SHARED2, PLL_CON3_PLL_SHARED2, NULL),
-	PLL(pll_0822x, FOUT_SHARED0_PLL, "fout_shared3_pll", "oscclk",
+	PLL(pll_0822x, FOUT_SHARED3_PLL, "fout_shared3_pll", "oscclk",
 	    PLL_LOCKTIME_PLL_SHARED3, PLL_CON3_PLL_SHARED3, NULL),
-	PLL(pll_0822x, FOUT_SHARED0_PLL, "fout_shared4_pll", "oscclk",
+	PLL(pll_0822x, FOUT_SHARED4_PLL, "fout_shared4_pll", "oscclk",
 	    PLL_LOCKTIME_PLL_SHARED4, PLL_CON3_PLL_SHARED4, NULL),
 };
 
-- 
2.43.0



