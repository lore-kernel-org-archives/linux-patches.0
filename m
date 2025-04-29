Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DB2253B5F;
	Tue, 29 Apr 2025 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949812; cv=none; b=JfgL8pOIoNXxluVji90RH50pJPNEJcgCi1tiCg180/xM/puTghu5+UrB38kRNIZDt9ezL5ev/5ToOtjk5vszZvCH0cGYLzHyOTc8ex3QQnVLimmx7FOPdE+qhJeZriOSPOuvENMHGCzHbzmXSR0ca7T/UKx99aFpLAOg0l1GJDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949812; c=relaxed/simple;
	bh=tiehqfdkOh4c9kvjSsm/d+BPfaqoLO5uR5vwrzysW0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujxVr5BiVoVgZTsjPJSf323YRSpPKVLn2LHRXDD+aOa3ATFenycBsJfWu5imATl3+8ReVVDB2FWSGRUZIbvVZ4FTtzVeKcdpJXly4sJrsTfNBUC4xllqW1C69cHHdCe9kxVdCSQ1nT30IQb2RDVmrurgRVuNR2idadpuS6jV4Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gD2H7wD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gD2H7wD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9259C4CEE3;
	Tue, 29 Apr 2025 18:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949812;
	bh=tiehqfdkOh4c9kvjSsm/d+BPfaqoLO5uR5vwrzysW0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gD2H7wD852Oi2wlz6mUNnIJMdPrHBzOe6YFP55FfGl8+Mq7Z1EdgMLwFUzEpnYav8
	 GxIymXNIQQ0Td8C5U5Q1zgorl/kzj2ivg58tIUtwuwW1W+id550VEnCXZX4IvuvxX0
	 QND6N/BGF6X69r9cmn1I1KhgZU6Xb1lv+6qIceL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/167] clk: renesas: r9a07g04[34]: Use SEL_SDHI1_STS status configuration for SD1 mux
Date: Tue, 29 Apr 2025 18:42:13 +0200
Message-ID: <20250429161052.767896228@linuxfoundation.org>
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

[ Upstream commit 9b2a11c83859c06233049b134bd8ee974b284559 ]

The status configuration for SD1 mux clock is SEL_SDHI1_STS. Fix it.

Fixes: 16b86e5c03c5 ("clk: renesas: rzg2l: Refactor SD mux driver")
Reported-by: Hien Huynh <hien.huynh.px@renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240131102930.1841901-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 7f22a298d926 ("clk: renesas: r9a07g043: Fix HP clock source for RZ/Five")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a07g043-cpg.c | 2 +-
 drivers/clk/renesas/r9a07g044-cpg.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/r9a07g043-cpg.c b/drivers/clk/renesas/r9a07g043-cpg.c
index 31b7c24fe4d0f..284bab8366ef5 100644
--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -138,7 +138,7 @@ static const struct cpg_core_clk r9a07g043_core_clks[] __initconst = {
 	DEF_FIXED("SPI1", R9A07G043_CLK_SPI1, CLK_DIV_PLL3_C, 1, 4),
 	DEF_SD_MUX("SD0", R9A07G043_CLK_SD0, SEL_SDHI0, SEL_SDHI0_STS, sel_shdi,
 		   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
-	DEF_SD_MUX("SD1", R9A07G043_CLK_SD1, SEL_SDHI1, SEL_SDHI0_STS, sel_shdi,
+	DEF_SD_MUX("SD1", R9A07G043_CLK_SD1, SEL_SDHI1, SEL_SDHI1_STS, sel_shdi,
 		   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
 	DEF_FIXED("SD0_DIV4", CLK_SD0_DIV4, R9A07G043_CLK_SD0, 1, 4),
 	DEF_FIXED("SD1_DIV4", CLK_SD1_DIV4, R9A07G043_CLK_SD1, 1, 4),
diff --git a/drivers/clk/renesas/r9a07g044-cpg.c b/drivers/clk/renesas/r9a07g044-cpg.c
index 3ae1c792b104c..b61a17fd4cc33 100644
--- a/drivers/clk/renesas/r9a07g044-cpg.c
+++ b/drivers/clk/renesas/r9a07g044-cpg.c
@@ -178,7 +178,7 @@ static const struct {
 		DEF_FIXED("SPI1", R9A07G044_CLK_SPI1, CLK_DIV_PLL3_C, 1, 4),
 		DEF_SD_MUX("SD0", R9A07G044_CLK_SD0, SEL_SDHI0, SEL_SDHI0_STS, sel_shdi,
 			   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
-		DEF_SD_MUX("SD1", R9A07G044_CLK_SD1, SEL_SDHI1, SEL_SDHI0_STS, sel_shdi,
+		DEF_SD_MUX("SD1", R9A07G044_CLK_SD1, SEL_SDHI1, SEL_SDHI1_STS, sel_shdi,
 			   mtable_sdhi, 0, rzg2l_cpg_sd_clk_mux_notifier),
 		DEF_FIXED("SD0_DIV4", CLK_SD0_DIV4, R9A07G044_CLK_SD0, 1, 4),
 		DEF_FIXED("SD1_DIV4", CLK_SD1_DIV4, R9A07G044_CLK_SD1, 1, 4),
-- 
2.39.5



