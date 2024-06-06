Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC1D1B29C8;
	Thu,  6 Jun 2024 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683409; cv=none; b=PYg9682S10g8DNpfKm6STVLQLyhl2Wgtaf2EG4lrY0nFHsvYunx8WA+9pX8azndft/FMpTae713lep6fsRanW4u8KSWwcDFPGSPVQCitYnuU0u+BnI/lAhrzyW2jGe2TsbBwF4UDM9oxtR4cJ34wzPEvQz+5qMMVtQrOsuJq9BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683409; c=relaxed/simple;
	bh=RBFgsTkCHG5pmLjZNRlFzSgUhnU2cJYyPsurb5lBnRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDWqVmmIbWyMqidnFN8UbETf4zPkZ6zVofNc1tUSSkcyCegPmLKjlkdXzaxyns+uA+SQElTlHwVV4Vc9/Hr8WjKHFmLZnIiiB5YBEL131pFgoPT4RNA5Phd9hoYYBgkLk8OBOm1TB2w772oS8ndqf1KzDcXrQ14cYhPBkxx1qYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vN0DTlgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN0DTlgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC09C2BD10;
	Thu,  6 Jun 2024 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683409;
	bh=RBFgsTkCHG5pmLjZNRlFzSgUhnU2cJYyPsurb5lBnRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN0DTlgbzuTfVUjcfu6HhBDBxMTCpfoyCOw7PrdY3TUlONPdIf16BX5blNGLDUfGt
	 +IbO21R+oB5nF57BUbU+9bPtrilm62CgCP5HLzq+22taT7xVRN+nQ9BoCkdYpbrqLN
	 L+soWp/a/Z348wZOcPzSkxZNNB01RQqs0kpkZfx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 353/744] clk: renesas: r9a07g043: Add clock and reset entry for PLIC
Date: Thu,  6 Jun 2024 16:00:25 +0200
Message-ID: <20240606131743.798178130@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a7a6d60aca44..6c6bc79b2e9ce 100644
--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -250,6 +250,10 @@ static struct rzg2l_mod_clk r9a07g043_mod_clks[] = {
 				0x5a8, 1),
 	DEF_MOD("tsu_pclk",	R9A07G043_TSU_PCLK, R9A07G043_CLK_TSU,
 				0x5ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_MOD("nceplic_aclk",	R9A07G043_NCEPLIC_ACLK, R9A07G043_CLK_P1,
+				0x608, 0),
+#endif
 };
 
 static struct rzg2l_reset r9a07g043_resets[] = {
@@ -303,6 +307,10 @@ static struct rzg2l_reset r9a07g043_resets[] = {
 	DEF_RST(R9A07G043_ADC_PRESETN, 0x8a8, 0),
 	DEF_RST(R9A07G043_ADC_ADRST_N, 0x8a8, 1),
 	DEF_RST(R9A07G043_TSU_PRESETN, 0x8ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_RST(R9A07G043_NCEPLIC_ARESETN, 0x908, 0),
+#endif
+
 };
 
 static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
@@ -312,6 +320,7 @@ static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
 #endif
 #ifdef CONFIG_RISCV
 	MOD_CLK_BASE + R9A07G043_IAX45_CLK,
+	MOD_CLK_BASE + R9A07G043_NCEPLIC_ACLK,
 #endif
 	MOD_CLK_BASE + R9A07G043_DMAC_ACLK,
 };
-- 
2.43.0



