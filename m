Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD6F317160;
	Wed, 20 May 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298834; cv=none; b=redhedX6NoEaQLhDwTmYqOGuOy1rue+8cdEdDrxuhLbCrPsmC+CNyRQqZS4hVoANq1MImqKOyj7K6HlVOejyiQMmTEDyWCM7F6Kwebf3rIMVZ6LncBEZ6A7MPqXyGRa+NSW54dfNfSUHgnH4NFqkahgkh0TlYblyG7+S66PpiZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298834; c=relaxed/simple;
	bh=e2kY2YAfwKc7eOEutnDlJcd5B/WxOvxpQbJqBxMC5So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElUdqT9EclzmAaMUWwVrDYPB9FmRPIvTHbmaoOqN7JSp0Vybt5xVmvSF7GMnt1/glaUZD+PsuZhF3BEk3neMoL5vOTyeHLlaM5oNthuelIXX8QrPXwDlv6wPcqkrSJkfazC2vfOWhg7uLKkbO5EJmc62n2otAwpZdVK1+iyV4F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L99xFD7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L99xFD7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517811F000E9;
	Wed, 20 May 2026 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298832;
	bh=ZYI7eheosDs+ozWfCTh5uckf50DqMVHkR5rXC2AC2/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L99xFD7ttnUrt9svSxXbUt5ArBj4c7xb3/21g5xLdFMukbGgBEdOlrO7gUGAjB6NP
	 6rb5IbzGkagNK3ThNqmpF5tB6mtS2yazM1lyVByBYwOn3au1720Wu/SBTuJ4FqXY9f
	 y8B+tRCt7iq1/IF12UO/XGo5TwNng7PpZiXKribs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 560/957] clk: renesas: r9a09g057: Add entries for RSCIs
Date: Wed, 20 May 2026 18:17:23 +0200
Message-ID: <20260520162146.676660699@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 2efea3b35cc916f04f06b89f2e2557dbd9c48109 ]

Add clock and reset entries for the RSCI IPs.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251203094147.6429-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 1b4f047dc401 ("clk: renesas: r9a09g057: Remove entries for WDT{0,2,3}")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a09g057-cpg.c | 126 ++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/drivers/clk/renesas/r9a09g057-cpg.c b/drivers/clk/renesas/r9a09g057-cpg.c
index 4e47fea3f8946..ac3d309365b45 100644
--- a/drivers/clk/renesas/r9a09g057-cpg.c
+++ b/drivers/clk/renesas/r9a09g057-cpg.c
@@ -44,6 +44,9 @@ enum clk_ids {
 	CLK_PLLCLN_DIV2,
 	CLK_PLLCLN_DIV8,
 	CLK_PLLCLN_DIV16,
+	CLK_PLLCLN_DIV64,
+	CLK_PLLCLN_DIV256,
+	CLK_PLLCLN_DIV1024,
 	CLK_PLLDTY_ACPU,
 	CLK_PLLDTY_ACPU_DIV2,
 	CLK_PLLDTY_ACPU_DIV4,
@@ -144,6 +147,9 @@ static const struct cpg_core_clk r9a09g057_core_clks[] __initconst = {
 	DEF_FIXED(".pllcln_div2", CLK_PLLCLN_DIV2, CLK_PLLCLN, 1, 2),
 	DEF_FIXED(".pllcln_div8", CLK_PLLCLN_DIV8, CLK_PLLCLN, 1, 8),
 	DEF_FIXED(".pllcln_div16", CLK_PLLCLN_DIV16, CLK_PLLCLN, 1, 16),
+	DEF_FIXED(".pllcln_div64", CLK_PLLCLN_DIV64, CLK_PLLCLN, 1, 64),
+	DEF_FIXED(".pllcln_div256", CLK_PLLCLN_DIV256, CLK_PLLCLN, 1, 256),
+	DEF_FIXED(".pllcln_div1024", CLK_PLLCLN_DIV1024, CLK_PLLCLN, 1, 1024),
 
 	DEF_DDIV(".plldty_acpu", CLK_PLLDTY_ACPU, CLK_PLLDTY, CDDIV0_DIVCTL2, dtable_2_64),
 	DEF_FIXED(".plldty_acpu_div2", CLK_PLLDTY_ACPU_DIV2, CLK_PLLDTY_ACPU, 1, 2),
@@ -239,6 +245,106 @@ static const struct rzv2h_mod_clk r9a09g057_mod_clks[] __initconst = {
 						BUS_MSTOP(5, BIT(13))),
 	DEF_MOD("wdt_3_clk_loco",		CLK_QEXTAL, 5, 2, 2, 18,
 						BUS_MSTOP(5, BIT(13))),
+	DEF_MOD("rsci0_pclk",			CLK_PLLCLN_DIV16, 5, 13, 2, 29,
+						BUS_MSTOP(11, BIT(3))),
+	DEF_MOD("rsci0_tclk",			CLK_PLLCLN_DIV16, 5, 14, 2, 30,
+						BUS_MSTOP(11, BIT(3))),
+	DEF_MOD("rsci0_ps_ps3_n",		CLK_PLLCLN_DIV1024, 5, 15, 2, 31,
+						BUS_MSTOP(11, BIT(3))),
+	DEF_MOD("rsci0_ps_ps2_n",		CLK_PLLCLN_DIV256, 6, 0, 3, 0,
+						BUS_MSTOP(11, BIT(3))),
+	DEF_MOD("rsci0_ps_ps1_n",		CLK_PLLCLN_DIV64, 6, 1, 3, 1,
+						BUS_MSTOP(11, BIT(3))),
+	DEF_MOD("rsci1_pclk",			CLK_PLLCLN_DIV16, 6, 2, 3, 2,
+						BUS_MSTOP(11, BIT(4))),
+	DEF_MOD("rsci1_tclk",			CLK_PLLCLN_DIV16, 6, 3, 3, 3,
+						BUS_MSTOP(11, BIT(4))),
+	DEF_MOD("rsci1_ps_ps3_n",		CLK_PLLCLN_DIV1024, 6, 4, 3, 4,
+						BUS_MSTOP(11, BIT(4))),
+	DEF_MOD("rsci1_ps_ps2_n",		CLK_PLLCLN_DIV256, 6, 5, 3, 5,
+						BUS_MSTOP(11, BIT(4))),
+	DEF_MOD("rsci1_ps_ps1_n",		CLK_PLLCLN_DIV64, 6, 6, 3, 6,
+						BUS_MSTOP(11, BIT(4))),
+	DEF_MOD("rsci2_pclk",			CLK_PLLCLN_DIV16, 6, 7, 3, 7,
+						BUS_MSTOP(11, BIT(5))),
+	DEF_MOD("rsci2_tclk",			CLK_PLLCLN_DIV16, 6, 8, 3, 8,
+						BUS_MSTOP(11, BIT(5))),
+	DEF_MOD("rsci2_ps_ps3_n",		CLK_PLLCLN_DIV1024, 6, 9, 3, 9,
+						BUS_MSTOP(11, BIT(5))),
+	DEF_MOD("rsci2_ps_ps2_n",		CLK_PLLCLN_DIV256, 6, 10, 3, 10,
+						BUS_MSTOP(11, BIT(5))),
+	DEF_MOD("rsci2_ps_ps1_n",		CLK_PLLCLN_DIV64, 6, 11, 3, 11,
+						BUS_MSTOP(11, BIT(5))),
+	DEF_MOD("rsci3_pclk",			CLK_PLLCLN_DIV16, 6, 12, 3, 12,
+						BUS_MSTOP(11, BIT(6))),
+	DEF_MOD("rsci3_tclk",			CLK_PLLCLN_DIV16, 6, 13, 3, 13,
+						BUS_MSTOP(11, BIT(6))),
+	DEF_MOD("rsci3_ps_ps3_n",		CLK_PLLCLN_DIV1024, 6, 14, 3, 14,
+						BUS_MSTOP(11, BIT(6))),
+	DEF_MOD("rsci3_ps_ps2_n",		CLK_PLLCLN_DIV256, 6, 15, 3, 15,
+						BUS_MSTOP(11, BIT(6))),
+	DEF_MOD("rsci3_ps_ps1_n",		CLK_PLLCLN_DIV64, 7, 0, 3, 16,
+						BUS_MSTOP(11, BIT(6))),
+	DEF_MOD("rsci4_pclk",			CLK_PLLCLN_DIV16, 7, 1, 3, 17,
+						BUS_MSTOP(11, BIT(7))),
+	DEF_MOD("rsci4_tclk",			CLK_PLLCLN_DIV16, 7, 2, 3, 18,
+						BUS_MSTOP(11, BIT(7))),
+	DEF_MOD("rsci4_ps_ps3_n",		CLK_PLLCLN_DIV1024, 7, 3, 3, 19,
+						BUS_MSTOP(11, BIT(7))),
+	DEF_MOD("rsci4_ps_ps2_n",		CLK_PLLCLN_DIV256, 7, 4, 3, 20,
+						BUS_MSTOP(11, BIT(7))),
+	DEF_MOD("rsci4_ps_ps1_n",		CLK_PLLCLN_DIV64, 7, 5, 3, 21,
+						BUS_MSTOP(11, BIT(7))),
+	DEF_MOD("rsci5_pclk",			CLK_PLLCLN_DIV16, 7, 6, 3, 22,
+						BUS_MSTOP(11, BIT(8))),
+	DEF_MOD("rsci5_tclk",			CLK_PLLCLN_DIV16, 7, 7, 3, 23,
+						BUS_MSTOP(11, BIT(8))),
+	DEF_MOD("rsci5_ps_ps3_n",		CLK_PLLCLN_DIV1024, 7, 8, 3, 24,
+						BUS_MSTOP(11, BIT(8))),
+	DEF_MOD("rsci5_ps_ps2_n",		CLK_PLLCLN_DIV256, 7, 9, 3, 25,
+						BUS_MSTOP(11, BIT(8))),
+	DEF_MOD("rsci5_ps_ps1_n",		CLK_PLLCLN_DIV64, 7, 10, 3, 26,
+						BUS_MSTOP(11, BIT(8))),
+	DEF_MOD("rsci6_pclk",			CLK_PLLCLN_DIV16, 7, 11, 3, 27,
+						BUS_MSTOP(11, BIT(9))),
+	DEF_MOD("rsci6_tclk",			CLK_PLLCLN_DIV16, 7, 12, 3, 28,
+						BUS_MSTOP(11, BIT(9))),
+	DEF_MOD("rsci6_ps_ps3_n",		CLK_PLLCLN_DIV1024, 7, 13, 3, 29,
+						BUS_MSTOP(11, BIT(9))),
+	DEF_MOD("rsci6_ps_ps2_n",		CLK_PLLCLN_DIV256, 7, 14, 3, 30,
+						BUS_MSTOP(11, BIT(9))),
+	DEF_MOD("rsci6_ps_ps1_n",		CLK_PLLCLN_DIV64, 7, 15, 3, 31,
+						BUS_MSTOP(11, BIT(9))),
+	DEF_MOD("rsci7_pclk",			CLK_PLLCLN_DIV16, 8, 0, 4, 0,
+						BUS_MSTOP(11, BIT(10))),
+	DEF_MOD("rsci7_tclk",			CLK_PLLCLN_DIV16, 8, 1, 4, 1,
+						BUS_MSTOP(11, BIT(10))),
+	DEF_MOD("rsci7_ps_ps3_n",		CLK_PLLCLN_DIV1024, 8, 2, 4, 2,
+						BUS_MSTOP(11, BIT(10))),
+	DEF_MOD("rsci7_ps_ps2_n",		CLK_PLLCLN_DIV256, 8, 3, 4, 3,
+						BUS_MSTOP(11, BIT(10))),
+	DEF_MOD("rsci7_ps_ps1_n",		CLK_PLLCLN_DIV64, 8, 4, 4, 4,
+						BUS_MSTOP(11, BIT(10))),
+	DEF_MOD("rsci8_pclk",			CLK_PLLCLN_DIV16, 8, 5, 4, 5,
+						BUS_MSTOP(11, BIT(11))),
+	DEF_MOD("rsci8_tclk",			CLK_PLLCLN_DIV16, 8, 6, 4, 6,
+						BUS_MSTOP(11, BIT(11))),
+	DEF_MOD("rsci8_ps_ps3_n",		CLK_PLLCLN_DIV1024, 8, 7, 4, 7,
+						BUS_MSTOP(11, BIT(11))),
+	DEF_MOD("rsci8_ps_ps2_n",		CLK_PLLCLN_DIV256, 8, 8, 4, 8,
+						BUS_MSTOP(11, BIT(11))),
+	DEF_MOD("rsci8_ps_ps1_n",		CLK_PLLCLN_DIV64, 8, 9, 4, 9,
+						BUS_MSTOP(11, BIT(11))),
+	DEF_MOD("rsci9_pclk",			CLK_PLLCLN_DIV16, 8, 10, 4, 10,
+						BUS_MSTOP(11, BIT(12))),
+	DEF_MOD("rsci9_tclk",			CLK_PLLCLN_DIV16, 8, 11, 4, 11,
+						BUS_MSTOP(11, BIT(12))),
+	DEF_MOD("rsci9_ps_ps3_n",		CLK_PLLCLN_DIV1024, 8, 12, 4, 12,
+						BUS_MSTOP(11, BIT(12))),
+	DEF_MOD("rsci9_ps_ps2_n",		CLK_PLLCLN_DIV256, 8, 13, 4, 13,
+						BUS_MSTOP(11, BIT(12))),
+	DEF_MOD("rsci9_ps_ps1_n",		CLK_PLLCLN_DIV64, 8, 14, 4, 14,
+						BUS_MSTOP(11, BIT(12))),
 	DEF_MOD("rtc_0_clk_rtc",		CLK_PLLCM33_DIV16, 5, 3, 2, 19,
 						BUS_MSTOP(3, BIT(11) | BIT(12))),
 	DEF_MOD("rspi_0_pclk",			CLK_PLLCLN_DIV8, 5, 4, 2, 20,
@@ -403,6 +509,26 @@ static const struct rzv2h_reset r9a09g057_resets[] __initconst = {
 	DEF_RST(7, 6, 3, 7),		/* WDT_1_RESET */
 	DEF_RST(7, 7, 3, 8),		/* WDT_2_RESET */
 	DEF_RST(7, 8, 3, 9),		/* WDT_3_RESET */
+	DEF_RST(8, 1, 3, 18),		/* RSCI0_PRESETN */
+	DEF_RST(8, 2, 3, 19),		/* RSCI0_TRESETN */
+	DEF_RST(8, 3, 3, 20),		/* RSCI1_PRESETN */
+	DEF_RST(8, 4, 3, 21),		/* RSCI1_TRESETN */
+	DEF_RST(8, 5, 3, 22),		/* RSCI2_PRESETN */
+	DEF_RST(8, 6, 3, 23),		/* RSCI2_TRESETN */
+	DEF_RST(8, 7, 3, 24),		/* RSCI3_PRESETN */
+	DEF_RST(8, 8, 3, 25),		/* RSCI3_TRESETN */
+	DEF_RST(8, 9, 3, 26),		/* RSCI4_PRESETN */
+	DEF_RST(8, 10, 3, 27),		/* RSCI4_TRESETN */
+	DEF_RST(8, 11, 3, 28),		/* RSCI5_PRESETN */
+	DEF_RST(8, 12, 3, 29),		/* RSCI5_TRESETN */
+	DEF_RST(8, 13, 3, 30),		/* RSCI6_PRESETN */
+	DEF_RST(8, 14, 3, 31),		/* RSCI6_TRESETN */
+	DEF_RST(8, 15, 4, 0),		/* RSCI7_PRESETN */
+	DEF_RST(9, 0, 4, 1),		/* RSCI7_TRESETN */
+	DEF_RST(9, 1, 4, 2),		/* RSCI8_PRESETN */
+	DEF_RST(9, 2, 4, 3),		/* RSCI8_TRESETN */
+	DEF_RST(9, 3, 4, 4),		/* RSCI9_PRESETN */
+	DEF_RST(9, 4, 4, 5),		/* RSCI9_TRESETN */
 	DEF_RST(7, 9, 3, 10),		/* RTC_0_RST_RTC */
 	DEF_RST(7, 10, 3, 11),		/* RTC_0_RST_RTC_V */
 	DEF_RST(7, 11, 3, 12),		/* RSPI_0_PRESETN */
-- 
2.53.0



