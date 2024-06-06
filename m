Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0E919AD95;
	Thu,  6 Jun 2024 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683354; cv=none; b=G2xvmociLaAPdDTCmrV7FnG9zq59H5OqgJ6RYu15xW7engFBpH4n5x5PLnPr5rjzmPWRMRFRZH/lfhhIirNwlV86yPTTek3q5DKsVmAa4EXBU0P4Baqgx3Fr6vkCMlfNcW1PyXly8a+bH34eTmPXjb0Qu8etJgC2sTuFlwTdAoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683354; c=relaxed/simple;
	bh=z4aRGPAVQACr0NGriOSnI5PoOzqX55otaCpUtZWH9aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPWZaQUD6AITkIlPKWSZMGGLwjtoWc2uCywncMWm1yrBBpb9POYiL1seFusTU9w9UsYMMvzAYl23+DsiifSa90YLv2KdNYQaavOInLJTHFQDzrRO3VebWxeUTUf9NsCsJckkWurnVmsieVT2kEcT9J7aLOP4xDX/cy6fBxMemdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRXicqGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRXicqGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3671DC4AF07;
	Thu,  6 Jun 2024 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683354;
	bh=z4aRGPAVQACr0NGriOSnI5PoOzqX55otaCpUtZWH9aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRXicqGgxwiLPPAXrxjhgkX60xZtnuk/9ldolK/Dx+ILYGIhzW28iLzvtJLui2ueJ
	 DHXZ6lUxJB7DlwIzyBfvCsUShqgfUjYPWAS/Sb+1QB8ZQ2rN+m1f1ez986X1wqS3/W
	 y6akRiekc3eqwrZVPX0B9yB7f4Tl2DC78hP/MC9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Kim <jaewon02.kim@samsung.com>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/473] clk: samsung: exynosautov9: fix wrong pll clock id value
Date: Thu,  6 Jun 2024 16:02:44 +0200
Message-ID: <20240606131707.606598285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b16320bba667..c360639562755 100644
--- a/drivers/clk/samsung/clk-exynosautov9.c
+++ b/drivers/clk/samsung/clk-exynosautov9.c
@@ -343,13 +343,13 @@ static const struct samsung_pll_clock top_pll_clks[] __initconst = {
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



