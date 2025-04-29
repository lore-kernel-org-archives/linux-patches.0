Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506DA21ABC6;
	Tue, 29 Apr 2025 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949685; cv=none; b=OKg/YitFAifFtU8uu+KIQhF3T88CihzFMsmGwGAE21/S6NjusJ5NrM4YyN0wTjLsYKwa7kEPuVJhcgWrUPToiAL627JUeWd8p+NALtM6Q7480kMyLcwlqgQACI44d9aTEpK3pDfkGCMpmDMEd3Uqa46dbORIHpqxOCPxaMTmL7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949685; c=relaxed/simple;
	bh=M/5OP2uk7xg1j3d02K2ZxXA0ecZ5lbK4Rl0XxpGAYNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY2VETQ8NYOl/eol/ALpjfwvCHCCVkrAAH4wNZiZJTgQCJogaxmgMVqWXgFFIHabYGhG15pAxpK0dHg/FQ9Kt9RITs8GeKxcQV3921X4NhXkezR7CndAk7OOfKCBukM3PhXRLUUpBF4mX2/ewwmRsUh28PmUvRhL+K0RWclvBUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hObHtrLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hObHtrLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6500C4CEEE;
	Tue, 29 Apr 2025 18:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949685;
	bh=M/5OP2uk7xg1j3d02K2ZxXA0ecZ5lbK4Rl0XxpGAYNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hObHtrLYiXrfHyHLZFXV2snAlCPyEQEq0gfmm40tlDl3z61+QPkfYkLf5v5GOWWA7
	 Cw8HVd602dEMg/etXEDoi28AhEtv8Q/vLtqbw+Oh3qWw8+4py+MW/yiJsduPzBCoUH
	 Yr96KoD7GlKwIpQGk2TmO8/j+VzFDwwNYSC+pFfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/167] clk: renesas: rzg2l: Remove CPG_SDHI_DSEL from generic header
Date: Tue, 29 Apr 2025 18:42:11 +0200
Message-ID: <20250429161052.688685350@linuxfoundation.org>
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

[ Upstream commit 3e8008fcf6b7f7c65ad2718c18fb79f37007f1a5 ]

Remove CPG_SDHI_DSEL and its bits from the generic header as RZ/G3S has
different offset registers and bits for this, thus avoid mixing them.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230929053915.1530607-10-claudiu.beznea@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 7f22a298d926 ("clk: renesas: r9a07g043: Fix HP clock source for RZ/Five")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a07g043-cpg.c | 7 +++++++
 drivers/clk/renesas/r9a07g044-cpg.c | 7 +++++++
 drivers/clk/renesas/rzg2l-cpg.h     | 4 ----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/r9a07g043-cpg.c b/drivers/clk/renesas/r9a07g043-cpg.c
index 0b56688ecbfc4..866d355911818 100644
--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -14,6 +14,13 @@
 
 #include "rzg2l-cpg.h"
 
+/* Specific registers. */
+#define CPG_PL2SDHI_DSEL	(0x218)
+
+/* Clock select configuration. */
+#define SEL_SDHI0		SEL_PLL_PACK(CPG_PL2SDHI_DSEL, 0, 2)
+#define SEL_SDHI1		SEL_PLL_PACK(CPG_PL2SDHI_DSEL, 4, 2)
+
 enum clk_ids {
 	/* Core Clock Outputs exported to DT */
 	LAST_DT_CORE_CLK = R9A07G043_CLK_P0_DIV2,
diff --git a/drivers/clk/renesas/r9a07g044-cpg.c b/drivers/clk/renesas/r9a07g044-cpg.c
index 02a4fc41bb6e1..ca56bc67da25e 100644
--- a/drivers/clk/renesas/r9a07g044-cpg.c
+++ b/drivers/clk/renesas/r9a07g044-cpg.c
@@ -15,6 +15,13 @@
 
 #include "rzg2l-cpg.h"
 
+/* Specific registers. */
+#define CPG_PL2SDHI_DSEL	(0x218)
+
+/* Clock select configuration. */
+#define SEL_SDHI0		SEL_PLL_PACK(CPG_PL2SDHI_DSEL, 0, 2)
+#define SEL_SDHI1		SEL_PLL_PACK(CPG_PL2SDHI_DSEL, 4, 2)
+
 enum clk_ids {
 	/* Core Clock Outputs exported to DT */
 	LAST_DT_CORE_CLK = R9A07G054_CLK_DRP_A,
diff --git a/drivers/clk/renesas/rzg2l-cpg.h b/drivers/clk/renesas/rzg2l-cpg.h
index f362a1d886338..a3f908e555552 100644
--- a/drivers/clk/renesas/rzg2l-cpg.h
+++ b/drivers/clk/renesas/rzg2l-cpg.h
@@ -19,7 +19,6 @@
 #define CPG_PL2_DDIV		(0x204)
 #define CPG_PL3A_DDIV		(0x208)
 #define CPG_PL6_DDIV		(0x210)
-#define CPG_PL2SDHI_DSEL	(0x218)
 #define CPG_CLKSTATUS		(0x280)
 #define CPG_PL3_SSEL		(0x408)
 #define CPG_PL6_SSEL		(0x414)
@@ -69,9 +68,6 @@
 #define SEL_PLL6_2	SEL_PLL_PACK(CPG_PL6_ETH_SSEL, 0, 1)
 #define SEL_GPU2	SEL_PLL_PACK(CPG_PL6_SSEL, 12, 1)
 
-#define SEL_SDHI0	DDIV_PACK(CPG_PL2SDHI_DSEL, 0, 2)
-#define SEL_SDHI1	DDIV_PACK(CPG_PL2SDHI_DSEL, 4, 2)
-
 #define EXTAL_FREQ_IN_MEGA_HZ	(24)
 
 /**
-- 
2.39.5



