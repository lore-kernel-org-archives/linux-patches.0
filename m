Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FAF2522A5;
	Tue, 29 Apr 2025 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949715; cv=none; b=RMTS4ntS1LuO3jlucUrO3ynKVX76vKGMbjYIA1yknvz2mjfZzrw/ivNGJOi7uKKt3pNyS09XdCEg02gO/VEqUqDpcPld5hHMSQrn+kuyZ0vXI3jU6pYBXGDeooLznPchIaSQRItNZzXCu1kuL8wMr1RXAfvZN8zy54tvE8UDiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949715; c=relaxed/simple;
	bh=85Z/20scaTccRNQEGfDHVZvQm0ROPnYFwmenJOnS7dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMPTQSSGpFbRKcxqkGsV0k5KtKs0ElUE0qMTaEhGFpF0mZp7smNMR6e3cDP9Ml7UMqm42YS+GWNF4e8fu+y7cIOA6XPT/Ny4k18oxzVd+7TLrYypLvI94p1v8PzdS9PmbF4pmFGMyVL4xCsa2FiA4XsWEovJwbYip12fgef1Js0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/PxS9SB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/PxS9SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1CEC4CEE3;
	Tue, 29 Apr 2025 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949715;
	bh=85Z/20scaTccRNQEGfDHVZvQm0ROPnYFwmenJOnS7dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/PxS9SBEuKpHGNOviNcxDZCgmq5ZkfXmlX7S8nxjN5eAMtXVRMMElCzIpi0xklBk
	 tbmwkYXkFMy7WbNN45YmByVTPebGjcWvGqp1d/Vpz/GEkMfJozIetYyR0bCg78o5Qo
	 7uV7hj1zgnP/fNHIC7LkffN4cFb8s0SAPUFPLSF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/167] clk: renesas: r9a07g04[34]: Fix typo for sel_shdi variable
Date: Tue, 29 Apr 2025 18:42:14 +0200
Message-ID: <20250429161052.807238559@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 46fb5dd9ca289953fa791b2bb060dac7f8002ae0 ]

Fix typo for sel_shdi variable.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240131102930.1841901-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 7f22a298d926 ("clk: renesas: r9a07g043: Fix HP clock source for RZ/Five")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a07g043-cpg.c | 6 +++---
 drivers/clk/renesas/r9a07g044-cpg.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/renesas/r9a07g043-cpg.c b/drivers/clk/renesas/r9a07g043-cpg.c
index 284bab8366ef5..1526de808576e 100644
--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -87,7 +87,7 @@ static const struct clk_div_table dtable_1_32[] = {
 /* Mux clock tables */
 static const char * const sel_pll3_3[] = { ".pll3_533", ".pll3_400" };
 static const char * const sel_pll6_2[]	= { ".pll6_250", ".pll5_250" };
-static const char * const sel_shdi[] = { ".clk_533", ".clk_400", ".clk_266" };
+static const char * const sel_sdhi[] = { ".clk_533", ".clk_400", ".clk_266" };
 
 static const u32 mtable_sdhi[] = { 1, 2, 3 };
 
@@ -136,9 +136,9 @@ static const struct cpg_core_clk r9a07g043_core_clks[] __initconst = {
 	DEF_MUX("HP", R9A07G043_CLK_HP, SEL_PLL6_2, sel_pll6_2),
 	DEF_FIXED("SPI0", R9A07G043_CLK_SPI0, CLK_DIV_PLL3_C, 1, 2),
 	DEF_FIXED("SPI1", R9A07G043_CLK_SPI1, CLK_DIV_PLL3_C, 1, 4),
-	DEF_SD_MUX("SD0", R9A07G043_CLK_SD0, SEL_SDHI0, SEL_SDHI0_STS, sel_shdi,
+	DEF_SD_MUX("SD0", R9A07G043_CLK_SD0, SEL_SDHI0, SEL_SDHI0_STS, sel_sdhi,
 		   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
-	DEF_SD_MUX("SD1", R9A07G043_CLK_SD1, SEL_SDHI1, SEL_SDHI1_STS, sel_shdi,
+	DEF_SD_MUX("SD1", R9A07G043_CLK_SD1, SEL_SDHI1, SEL_SDHI1_STS, sel_sdhi,
 		   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
 	DEF_FIXED("SD0_DIV4", CLK_SD0_DIV4, R9A07G043_CLK_SD0, 1, 4),
 	DEF_FIXED("SD1_DIV4", CLK_SD1_DIV4, R9A07G043_CLK_SD1, 1, 4),
diff --git a/drivers/clk/renesas/r9a07g044-cpg.c b/drivers/clk/renesas/r9a07g044-cpg.c
index b61a17fd4cc33..77e1a3a4ef1e6 100644
--- a/drivers/clk/renesas/r9a07g044-cpg.c
+++ b/drivers/clk/renesas/r9a07g044-cpg.c
@@ -106,7 +106,7 @@ static const struct clk_div_table dtable_16_128[] = {
 static const char * const sel_pll3_3[] = { ".pll3_533", ".pll3_400" };
 static const char * const sel_pll5_4[] = { ".pll5_foutpostdiv", ".pll5_fout1ph0" };
 static const char * const sel_pll6_2[]	= { ".pll6_250", ".pll5_250" };
-static const char * const sel_shdi[] = { ".clk_533", ".clk_400", ".clk_266" };
+static const char * const sel_sdhi[] = { ".clk_533", ".clk_400", ".clk_266" };
 static const char * const sel_gpu2[] = { ".pll6", ".pll3_div2_2" };
 
 static const u32 mtable_sdhi[] = { 1, 2, 3 };
@@ -176,9 +176,9 @@ static const struct {
 		DEF_MUX("HP", R9A07G044_CLK_HP, SEL_PLL6_2, sel_pll6_2),
 		DEF_FIXED("SPI0", R9A07G044_CLK_SPI0, CLK_DIV_PLL3_C, 1, 2),
 		DEF_FIXED("SPI1", R9A07G044_CLK_SPI1, CLK_DIV_PLL3_C, 1, 4),
-		DEF_SD_MUX("SD0", R9A07G044_CLK_SD0, SEL_SDHI0, SEL_SDHI0_STS, sel_shdi,
+		DEF_SD_MUX("SD0", R9A07G044_CLK_SD0, SEL_SDHI0, SEL_SDHI0_STS, sel_sdhi,
 			   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
-		DEF_SD_MUX("SD1", R9A07G044_CLK_SD1, SEL_SDHI1, SEL_SDHI1_STS, sel_shdi,
+		DEF_SD_MUX("SD1", R9A07G044_CLK_SD1, SEL_SDHI1, SEL_SDHI1_STS, sel_sdhi,
 			   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
 		DEF_FIXED("SD0_DIV4", CLK_SD0_DIV4, R9A07G044_CLK_SD0, 1, 4),
 		DEF_FIXED("SD1_DIV4", CLK_SD1_DIV4, R9A07G044_CLK_SD1, 1, 4),
-- 
2.39.5



