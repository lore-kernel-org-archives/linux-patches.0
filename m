Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24891376A0C;
	Wed, 20 May 2026 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298839; cv=none; b=kDhDhdTuXers+hlrVKgsMJP7w6/j0JZ2xLUq7Vju5SqyFnxWXwdlIP8Yk/jcnvMIzIXPAnipdr1atewRJaqFZ37hFJ4IT4bCIWVV0mVef/Rtdy4mtQcxGECVpOCQJtPbmsFHIwGEQprWviblgC5VtE9LbrYJdnNONRlqeT35bsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298839; c=relaxed/simple;
	bh=py8ytkshYJSb239qkuu0wEEwWUEvkvjaxixfL2vI0Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTU/8S/ksw7PkhYRnfTuSc8wtj2ldOfUGmwi/zb7y5AXl/lkeuItZjTFp9n0oW1ArkIw2R4Zn5xNEbWndNMQOS1ZM3vXgn0V2JpxnuS4mAgjDAnJnuUz+K+75tZsXAR2wdP3rQX6aI/9D7uy89ufCM43mUf1evottKgRaHFCQgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+wIOKRW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+wIOKRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE861F00893;
	Wed, 20 May 2026 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298838;
	bh=7EOYsbD1UiPzsoLQjVYbF7/eqEqBfzP5gV2d6DfQbag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+wIOKRWh3II+VxZUER6sh6fVdFUFnkMerki8FTvo8rz1oWD08TEc9/ZPn+dvuiOV
	 Ymm0387MetRNlsVJB3peFxfKlq3T9y/Dq6r5ClT8dEs0VRJ0l8bp4Q6DwtXYl5tJE7
	 F4aARZRRwDrfdP0okWotZbSjQ7qX1hREQKwTsjm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 562/957] clk: renesas: r9a09g057: Remove entries for WDT{0,2,3}
Date: Wed, 20 May 2026 18:17:25 +0200
Message-ID: <20260520162146.717992745@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 1b4f047dc4010d51821694cc4ed73b52b3040a5c ]

The HW user manual for the Renesas RZ/V2H(P) SoC specifies
that only the WDT1 IP is supposed to be used by Linux,
while the WDT{0,2,3} IPs are supposed to be used by the CM33
and CR8 cores.

Remove the clock and reset entries for WDT{0,2,3} to prevent
interfering with the CM33 and CR8 cores.

This change is harmless as only WDT1 is used by Linux, there
are no users for the WDT{0,2,3} cores.

Fixes: 3aeccbe08171 ("clk: renesas: r9a09g057: Add clock and reset entries for GTM/RIIC/SDHI/WDT")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260203124247.7320-4-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a09g057-cpg.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/clk/renesas/r9a09g057-cpg.c b/drivers/clk/renesas/r9a09g057-cpg.c
index 647e394727f6b..5d799dd9fbfc1 100644
--- a/drivers/clk/renesas/r9a09g057-cpg.c
+++ b/drivers/clk/renesas/r9a09g057-cpg.c
@@ -229,22 +229,10 @@ static const struct rzv2h_mod_clk r9a09g057_mod_clks[] __initconst = {
 						BUS_MSTOP(11, BIT(15))),
 	DEF_MOD("gtm_7_pclk",			CLK_PLLCLN_DIV16, 4, 10, 2, 10,
 						BUS_MSTOP(12, BIT(0))),
-	DEF_MOD("wdt_0_clkp",			CLK_PLLCM33_DIV16, 4, 11, 2, 11,
-						BUS_MSTOP(3, BIT(10))),
-	DEF_MOD("wdt_0_clk_loco",		CLK_QEXTAL, 4, 12, 2, 12,
-						BUS_MSTOP(3, BIT(10))),
 	DEF_MOD("wdt_1_clkp",			CLK_PLLCLN_DIV16, 4, 13, 2, 13,
 						BUS_MSTOP(1, BIT(0))),
 	DEF_MOD("wdt_1_clk_loco",		CLK_QEXTAL, 4, 14, 2, 14,
 						BUS_MSTOP(1, BIT(0))),
-	DEF_MOD("wdt_2_clkp",			CLK_PLLCLN_DIV16, 4, 15, 2, 15,
-						BUS_MSTOP(5, BIT(12))),
-	DEF_MOD("wdt_2_clk_loco",		CLK_QEXTAL, 5, 0, 2, 16,
-						BUS_MSTOP(5, BIT(12))),
-	DEF_MOD("wdt_3_clkp",			CLK_PLLCLN_DIV16, 5, 1, 2, 17,
-						BUS_MSTOP(5, BIT(13))),
-	DEF_MOD("wdt_3_clk_loco",		CLK_QEXTAL, 5, 2, 2, 18,
-						BUS_MSTOP(5, BIT(13))),
 	DEF_MOD("rtc_0_clk_rtc",		CLK_PLLCM33_DIV16, 5, 3, 2, 19,
 						BUS_MSTOP(3, BIT(11) | BIT(12))),
 	DEF_MOD("rspi_0_pclk",			CLK_PLLCLN_DIV8, 5, 4, 2, 20,
@@ -505,10 +493,7 @@ static const struct rzv2h_reset r9a09g057_resets[] __initconst = {
 	DEF_RST(7, 2, 3, 3),		/* GTM_5_PRESETZ */
 	DEF_RST(7, 3, 3, 4),		/* GTM_6_PRESETZ */
 	DEF_RST(7, 4, 3, 5),		/* GTM_7_PRESETZ */
-	DEF_RST(7, 5, 3, 6),		/* WDT_0_RESET */
 	DEF_RST(7, 6, 3, 7),		/* WDT_1_RESET */
-	DEF_RST(7, 7, 3, 8),		/* WDT_2_RESET */
-	DEF_RST(7, 8, 3, 9),		/* WDT_3_RESET */
 	DEF_RST(8, 1, 3, 18),		/* RSCI0_PRESETN */
 	DEF_RST(8, 2, 3, 19),		/* RSCI0_TRESETN */
 	DEF_RST(8, 3, 3, 20),		/* RSCI1_PRESETN */
-- 
2.53.0



