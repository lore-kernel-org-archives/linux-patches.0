Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1C261FDF;
	Mon, 27 May 2024 19:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838671; cv=none; b=oIfsx+B5K/g3EXsQqKY21EFlvzxu3xF4ofDmtpoDZFIUfaREL/G6sGefJfHiJh2hkwDDOLnzoStJMBdA0MDwnn+fCGbAkoIS25EBZQju1h7mMZ+ygCk9Zw7x8/3KztHuVbEUo5sghmkk/y5aN7tShhmscxed3GQNOktmvpm5lM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838671; c=relaxed/simple;
	bh=Dlq3By1VQbl91H0fXgDW5p/vbOS0UlRXiqcF1xpUVBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTP7z6gICtcdmoGNilrPIJ/vQCH+iPWmeoffoeYsE1toB5AELAx9PF6ZLyrgw+F0CI46++0P+m78jnJYTcMogY/8v9Hj0+502JQhCTU5u/Bgln8omwSxuB+7QykdQ/i+SAgN7jO9gzbjaxqNtwQ8FpHpjIILfthFexYrg3bLK6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFahT9ZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFahT9ZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340AEC2BBFC;
	Mon, 27 May 2024 19:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838671;
	bh=Dlq3By1VQbl91H0fXgDW5p/vbOS0UlRXiqcF1xpUVBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFahT9ZEaqVPBI/9J/FVfetm5EoqYKMFae0gy8qXTw/Cg9wQZrB2xlPnZO+82PGIq
	 RC73X4t30G0j9ImzPl9Zg+Dlsyb4tY2LEqr+NKIsBuPbd5zlPXKd6I4310uQKTDz7c
	 FEpsLQ2RIM6FL4dOrFADjFJ0z7NOn3Lyaev8cAeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 440/493] clk: renesas: r9a07g043: Add clock and reset entry for PLIC
Date: Mon, 27 May 2024 20:57:22 +0200
Message-ID: <20240527185644.652896542@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 44019387fce230beda35b83da3a2c9fc5787704e ]

Add the missing clock and reset entry for PLIC. Also add
R9A07G043_NCEPLIC_ACLK to the critical clocks list.

Fixes: 95d48d270305ad2c ("clk: renesas: r9a07g043: Add support for RZ/Five SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240403200952.633084-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a07g043-cpg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/renesas/r9a07g043-cpg.c b/drivers/clk/renesas/r9a07g043-cpg.c
index 075ade0925d45..9ad7ceb3ab1ba 100644
--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -265,6 +265,10 @@ static struct rzg2l_mod_clk r9a07g043_mod_clks[] = {
 				0x5a8, 1),
 	DEF_MOD("tsu_pclk",	R9A07G043_TSU_PCLK, R9A07G043_CLK_TSU,
 				0x5ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_MOD("nceplic_aclk",	R9A07G043_NCEPLIC_ACLK, R9A07G043_CLK_P1,
+				0x608, 0),
+#endif
 };
 
 static struct rzg2l_reset r9a07g043_resets[] = {
@@ -318,6 +322,10 @@ static struct rzg2l_reset r9a07g043_resets[] = {
 	DEF_RST(R9A07G043_ADC_PRESETN, 0x8a8, 0),
 	DEF_RST(R9A07G043_ADC_ADRST_N, 0x8a8, 1),
 	DEF_RST(R9A07G043_TSU_PRESETN, 0x8ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_RST(R9A07G043_NCEPLIC_ARESETN, 0x908, 0),
+#endif
+
 };
 
 static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
@@ -327,6 +335,7 @@ static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
 #endif
 #ifdef CONFIG_RISCV
 	MOD_CLK_BASE + R9A07G043_IAX45_CLK,
+	MOD_CLK_BASE + R9A07G043_NCEPLIC_ACLK,
 #endif
 	MOD_CLK_BASE + R9A07G043_DMAC_ACLK,
 };
-- 
2.43.0



