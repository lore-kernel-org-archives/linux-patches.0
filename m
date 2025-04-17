Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB01825B665;
	Thu, 17 Apr 2025 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914923; cv=none; b=VGhkbYiRp25ZjMG0FKAof5XyD4h4FqRnx1Rlq+1VzRtkt4PJvlzlMvnEPGH/3JlpPKTXdmn6jX8zsEqmyRtmYphdl+PwOsTJw6mlENjGIkXXkmyXS6KGSXWhGo6uYHpcpQqjJjYkz+T1ghRB2r2wyHLU+CY2b8Hpj8A7boT3uqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914923; c=relaxed/simple;
	bh=QmW2HTWn9EbinXeNu1dKMkrjRYpHs5u1DheJU6p+wQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSRa7ne4dvGUo0GRIyGSCeRnNJpOI0kng9SWDsYGRLcjlXLm4eRdEFW9YeQglJ1LBt2+aXsxYKGrv1c12SeprmVd2uPZyor5Y0nH0doIgwnrzA7O8oF2KQFHX4Uf29NzvALCPAOV5poO1KvLUNsJXHge7BMDaEfIPAYGNDgJ4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2Hnhqqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2Hnhqqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9E7C4CEE4;
	Thu, 17 Apr 2025 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914922;
	bh=QmW2HTWn9EbinXeNu1dKMkrjRYpHs5u1DheJU6p+wQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2HnhqqtUD4VdnpgV4HVgDL/fqBDVexqE/ngl0Wm/kgLOCxZ3viZszFoMZu0O1D41
	 mtp1paYVG8U7nePIcAaxsM28ul1Jy7zXR62RB0iLVpOeZ9rZwu87OAqVZzeU85IsjE
	 rgtJxeG+wDLe3Ytpwc871PuljdIn7X2wgZbIIy+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.13 344/414] clk: renesas: r9a07g043: Fix HP clock source for RZ/Five
Date: Thu, 17 Apr 2025 19:51:42 +0200
Message-ID: <20250417175125.265861877@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit 7f22a298d926664b51fcfe2f8ea5feb7f8b79952 upstream.

According to the Rev.1.20 hardware manual for the RZ/Five SoC, the clock
source for HP is derived from PLL6 divided by 2.  Correct the
implementation by configuring HP as a fixed clock source instead of a
MUX.

The `CPG_PL6_ETH_SSEL' register, which is available on the RZ/G2UL SoC,
is not present on the RZ/Five SoC, necessitating this change.

Fixes: 95d48d270305ad2c ("clk: renesas: r9a07g043: Add support for RZ/Five SoC")
Cc: stable@vger.kernel.org
Reported-by: Hien Huynh <hien.huynh.px@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250127173159.34572-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/renesas/r9a07g043-cpg.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -89,7 +89,9 @@ static const struct clk_div_table dtable
 
 /* Mux clock tables */
 static const char * const sel_pll3_3[] = { ".pll3_533", ".pll3_400" };
+#ifdef CONFIG_ARM64
 static const char * const sel_pll6_2[]	= { ".pll6_250", ".pll5_250" };
+#endif
 static const char * const sel_sdhi[] = { ".clk_533", ".clk_400", ".clk_266" };
 
 static const u32 mtable_sdhi[] = { 1, 2, 3 };
@@ -137,7 +139,12 @@ static const struct cpg_core_clk r9a07g0
 	DEF_DIV("P2", R9A07G043_CLK_P2, CLK_PLL3_DIV2_4_2, DIVPL3A, dtable_1_32),
 	DEF_FIXED("M0", R9A07G043_CLK_M0, CLK_PLL3_DIV2_4, 1, 1),
 	DEF_FIXED("ZT", R9A07G043_CLK_ZT, CLK_PLL3_DIV2_4_2, 1, 1),
+#ifdef CONFIG_ARM64
 	DEF_MUX("HP", R9A07G043_CLK_HP, SEL_PLL6_2, sel_pll6_2),
+#endif
+#ifdef CONFIG_RISCV
+	DEF_FIXED("HP", R9A07G043_CLK_HP, CLK_PLL6_250, 1, 1),
+#endif
 	DEF_FIXED("SPI0", R9A07G043_CLK_SPI0, CLK_DIV_PLL3_C, 1, 2),
 	DEF_FIXED("SPI1", R9A07G043_CLK_SPI1, CLK_DIV_PLL3_C, 1, 4),
 	DEF_SD_MUX("SD0", R9A07G043_CLK_SD0, SEL_SDHI0, SEL_SDHI0_STS, sel_sdhi,


