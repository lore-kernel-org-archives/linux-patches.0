Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A545E19ADB5;
	Thu,  6 Jun 2024 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683366; cv=none; b=VdcQ5VUJ8gJBQksV1OUdTRXuU+buHbbs5ZxoT04WserPfk1ZWwUl97WlvnMJkW7rQk50LBOJgc+hZkgRQm8guxz1OH+yHURbvbtJoEm0Rs2zscKh591Cl3wfoiVo5kOFpYZy3eXUc2tZPWULGE3cJyO7GeyXnH4as/BKd+UzaOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683366; c=relaxed/simple;
	bh=UDlpF2RvaiiRxXzVtrN2hM5v+IXitGyokxGpBPvvTEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIlp9NPcwC6S50WeqtYKD64mhYB9OtI6t3ovW8NspQCCEB4QD0JVQbTSRuMuxIexhlfB1Tpc/hK8ESWXj/rsCYBPGkCxA8LaVcXMfZueLhMnWFXG9CJWcnQ0/R9m3AbZdcq3deoia36oQJdN/OmouVnnglmI4kRtXzx50oT54SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8DfDlVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8DfDlVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36682C32781;
	Thu,  6 Jun 2024 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683366;
	bh=UDlpF2RvaiiRxXzVtrN2hM5v+IXitGyokxGpBPvvTEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8DfDlVanJb49ZUJyCNZsB4/QluwH0b/KFevX2icubsQ8Sywp1YB8U0wIoFkF5ziQ
	 b3W2tDvV8IwlBUEaAXKAFyNL7pAey4vzwVMfTdiuCTfU0kBo0tKDTXeyMC/jM9drmH
	 cYNoDPSUlxmVjUfFGl+0eRCbamGCp5BUR9T65d1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/473] clk: renesas: r9a07g043: Add clock and reset entry for PLIC
Date: Thu,  6 Jun 2024 16:02:59 +0200
Message-ID: <20240606131708.251747001@linuxfoundation.org>
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
index 37475465100de..0b56688ecbfc4 100644
--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -252,6 +252,10 @@ static struct rzg2l_mod_clk r9a07g043_mod_clks[] = {
 				0x5a8, 1),
 	DEF_MOD("tsu_pclk",	R9A07G043_TSU_PCLK, R9A07G043_CLK_TSU,
 				0x5ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_MOD("nceplic_aclk",	R9A07G043_NCEPLIC_ACLK, R9A07G043_CLK_P1,
+				0x608, 0),
+#endif
 };
 
 static struct rzg2l_reset r9a07g043_resets[] = {
@@ -305,6 +309,10 @@ static struct rzg2l_reset r9a07g043_resets[] = {
 	DEF_RST(R9A07G043_ADC_PRESETN, 0x8a8, 0),
 	DEF_RST(R9A07G043_ADC_ADRST_N, 0x8a8, 1),
 	DEF_RST(R9A07G043_TSU_PRESETN, 0x8ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_RST(R9A07G043_NCEPLIC_ARESETN, 0x908, 0),
+#endif
+
 };
 
 static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
@@ -314,6 +322,7 @@ static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
 #endif
 #ifdef CONFIG_RISCV
 	MOD_CLK_BASE + R9A07G043_IAX45_CLK,
+	MOD_CLK_BASE + R9A07G043_NCEPLIC_ACLK,
 #endif
 	MOD_CLK_BASE + R9A07G043_DMAC_ACLK,
 };
-- 
2.43.0



