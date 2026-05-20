Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287583D8137;
	Wed, 20 May 2026 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296172; cv=none; b=aumZbm1HhKByPD+R+b4dnX+/22fpn19eilsrLcjBBxnP44U/qAyTwDe7DssxRO+mNi7trQkTr9EjkfEEpAEGh5ygQlyb+ELe/sfCD6BOMHhl530HZWgSWbHEhLdTtwOyUcg6QUYk7NZKB9zgdt/sWHutgoY+wT2EbF82b7bdaO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296172; c=relaxed/simple;
	bh=Lvk3TAwkyenN0/zLXPINqn6JO54DN6D//L+QqkAhCSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoDsDDZTyKcXUHTreSKfcWoEQxRQBigPTFcQqm+nfu2ULyBUhhj4Hy6c3GJF6gbCzxASIOWZ98pzAFvQvVfZIFw7PlVOjqjBvceZMB1a+kCi3CX6Z+lDXyUKl4hbZHDhlmjfacdWvkq45JNf5qXU51QQyjh+lPkrJu5TCokvGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOV8wyat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOV8wyat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841571F000E9;
	Wed, 20 May 2026 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296171;
	bh=RoOdOu7W2qqn53niUyfB1TbEbs5SXj9329tE17tGHxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOV8wyatZ2Uit1gTJzaQZreUAcohSF3u65HhzFhkQmxF/jHfK+Onr7EijqG+SHjDt
	 M6lG7LM8+ZLr5vn78+3zJffbuyw53ehav6VLv2YRIm+xUkinu+9iXzv1jz0wgi59UO
	 rbZFdSWs7UOpa77eJ3jxjbJfrMbN7jbhy3KZC5jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0699/1146] clk: renesas: r9a09g057: Fix ordering of module clocks array
Date: Wed, 20 May 2026 18:15:49 +0200
Message-ID: <20260520162204.010713460@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 79cac2b8dc1d9f63fbf6c6793e423052118cc51a ]

The r9a09g057_mod_clks array is sorted by CPG_CLKON register number and
bit position.  Move the RTC and RSPI module clock entries to their
correct position to restore the array sort order.

Fixes: 2efea3b35cc9 ("clk: renesas: r9a09g057: Add entries for RSCIs")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260125190314.26729-1-ovidiu.panait.rb@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a09g057-cpg.c | 40 ++++++++++++++---------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/renesas/r9a09g057-cpg.c b/drivers/clk/renesas/r9a09g057-cpg.c
index 6943cad318b5d..b0e43e5e50dde 100644
--- a/drivers/clk/renesas/r9a09g057-cpg.c
+++ b/drivers/clk/renesas/r9a09g057-cpg.c
@@ -296,6 +296,26 @@ static const struct rzv2h_mod_clk r9a09g057_mod_clks[] __initconst = {
 						BUS_MSTOP(5, BIT(13))),
 	DEF_MOD("wdt_3_clk_loco",		CLK_QEXTAL, 5, 2, 2, 18,
 						BUS_MSTOP(5, BIT(13))),
+	DEF_MOD("rtc_0_clk_rtc",		CLK_PLLCM33_DIV16, 5, 3, 2, 19,
+						BUS_MSTOP(3, BIT(11) | BIT(12))),
+	DEF_MOD("rspi_0_pclk",			CLK_PLLCLN_DIV8, 5, 4, 2, 20,
+						BUS_MSTOP(11, BIT(0))),
+	DEF_MOD("rspi_0_pclk_sfr",		CLK_PLLCLN_DIV8, 5, 5, 2, 21,
+						BUS_MSTOP(11, BIT(0))),
+	DEF_MOD("rspi_0_tclk",			CLK_PLLCLN_DIV8, 5, 6, 2, 22,
+						BUS_MSTOP(11, BIT(0))),
+	DEF_MOD("rspi_1_pclk",			CLK_PLLCLN_DIV8, 5, 7, 2, 23,
+						BUS_MSTOP(11, BIT(1))),
+	DEF_MOD("rspi_1_pclk_sfr",		CLK_PLLCLN_DIV8, 5, 8, 2, 24,
+						BUS_MSTOP(11, BIT(1))),
+	DEF_MOD("rspi_1_tclk",			CLK_PLLCLN_DIV8, 5, 9, 2, 25,
+						BUS_MSTOP(11, BIT(1))),
+	DEF_MOD("rspi_2_pclk",			CLK_PLLCLN_DIV8, 5, 10, 2, 26,
+						BUS_MSTOP(11, BIT(2))),
+	DEF_MOD("rspi_2_pclk_sfr",		CLK_PLLCLN_DIV8, 5, 11, 2, 27,
+						BUS_MSTOP(11, BIT(2))),
+	DEF_MOD("rspi_2_tclk",			CLK_PLLCLN_DIV8, 5, 12, 2, 28,
+						BUS_MSTOP(11, BIT(2))),
 	DEF_MOD("rsci0_pclk",			CLK_PLLCLN_DIV16, 5, 13, 2, 29,
 						BUS_MSTOP(11, BIT(3))),
 	DEF_MOD("rsci0_tclk",			CLK_PLLCLN_DIV16, 5, 14, 2, 30,
@@ -396,26 +416,6 @@ static const struct rzv2h_mod_clk r9a09g057_mod_clks[] __initconst = {
 						BUS_MSTOP(11, BIT(12))),
 	DEF_MOD("rsci9_ps_ps1_n",		CLK_PLLCLN_DIV64, 8, 14, 4, 14,
 						BUS_MSTOP(11, BIT(12))),
-	DEF_MOD("rtc_0_clk_rtc",		CLK_PLLCM33_DIV16, 5, 3, 2, 19,
-						BUS_MSTOP(3, BIT(11) | BIT(12))),
-	DEF_MOD("rspi_0_pclk",			CLK_PLLCLN_DIV8, 5, 4, 2, 20,
-						BUS_MSTOP(11, BIT(0))),
-	DEF_MOD("rspi_0_pclk_sfr",		CLK_PLLCLN_DIV8, 5, 5, 2, 21,
-						BUS_MSTOP(11, BIT(0))),
-	DEF_MOD("rspi_0_tclk",			CLK_PLLCLN_DIV8, 5, 6, 2, 22,
-						BUS_MSTOP(11, BIT(0))),
-	DEF_MOD("rspi_1_pclk",			CLK_PLLCLN_DIV8, 5, 7, 2, 23,
-						BUS_MSTOP(11, BIT(1))),
-	DEF_MOD("rspi_1_pclk_sfr",		CLK_PLLCLN_DIV8, 5, 8, 2, 24,
-						BUS_MSTOP(11, BIT(1))),
-	DEF_MOD("rspi_1_tclk",			CLK_PLLCLN_DIV8, 5, 9, 2, 25,
-						BUS_MSTOP(11, BIT(1))),
-	DEF_MOD("rspi_2_pclk",			CLK_PLLCLN_DIV8, 5, 10, 2, 26,
-						BUS_MSTOP(11, BIT(2))),
-	DEF_MOD("rspi_2_pclk_sfr",		CLK_PLLCLN_DIV8, 5, 11, 2, 27,
-						BUS_MSTOP(11, BIT(2))),
-	DEF_MOD("rspi_2_tclk",			CLK_PLLCLN_DIV8, 5, 12, 2, 28,
-						BUS_MSTOP(11, BIT(2))),
 	DEF_MOD("scif_0_clk_pck",		CLK_PLLCM33_DIV16, 8, 15, 4, 15,
 						BUS_MSTOP(3, BIT(14))),
 	DEF_MOD("i3c_0_pclkrw",			CLK_PLLCLN_DIV16, 9, 0, 4, 16,
-- 
2.53.0



