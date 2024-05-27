Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E297C17E90E;
	Mon, 27 May 2024 19:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837258; cv=none; b=u/HHmD0PH6wxjSL18p9K8vQdUayxEiZamza+BbqcryjdpFqtbKOhSyvDvctgv5yjB0AK2PKnpIPyAXtBSzK6R9lVuTRkjhXLANdqLdecpvzvWM2uWDshk0RgISPVsaKIoS/+heDB1NkXB4K9cdn76Ry2GCiwlrc2d/h8AsCGoHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837258; c=relaxed/simple;
	bh=wvYtHrHbR8VvR1/oWQ8rOqUN1k3oB3jlR1Mv1jVt7k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCMzf2uGKqOg09VDDr6YDbUjvbzESK6SDeGzfMaZ9pxLEvyExg536nMkW0Hc+XEWuOP8ZITcXsDRo0oTcZOXgWt8oH1B/4Mk838jQluMd4FFisA7uDLPd69eQIDha9ZwOP3vbakSQoFr9nP4D6U7DCChgyXGTZeD34SOAvOa7no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wegru0st; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wegru0st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D2C2BBFC;
	Mon, 27 May 2024 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837257;
	bh=wvYtHrHbR8VvR1/oWQ8rOqUN1k3oB3jlR1Mv1jVt7k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wegru0stZG5bSWh0ADBT3NeB2khnCHHWiXVceYfd9ZukytoWrAOSBMnI1QbgvwLUp
	 dtJ2Vw+MO8hS8XjeTMWjqjw6BBC91TnCcrLNOtQTJ5SGH0UaJNf+cHOrrgh4bPgvP4
	 2Pb50Ms1aYJOb1oQckrDgmRPAN2tM5WWKdCVRWCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 372/427] clk: renesas: r9a07g043: Add clock and reset entry for PLIC
Date: Mon, 27 May 2024 20:56:59 +0200
Message-ID: <20240527185634.243199328@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 33532673d25d7..26b71547fdbe3 100644
--- a/drivers/clk/renesas/r9a07g043-cpg.c
+++ b/drivers/clk/renesas/r9a07g043-cpg.c
@@ -280,6 +280,10 @@ static struct rzg2l_mod_clk r9a07g043_mod_clks[] = {
 				0x5a8, 1),
 	DEF_MOD("tsu_pclk",	R9A07G043_TSU_PCLK, R9A07G043_CLK_TSU,
 				0x5ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_MOD("nceplic_aclk",	R9A07G043_NCEPLIC_ACLK, R9A07G043_CLK_P1,
+				0x608, 0),
+#endif
 };
 
 static struct rzg2l_reset r9a07g043_resets[] = {
@@ -338,6 +342,10 @@ static struct rzg2l_reset r9a07g043_resets[] = {
 	DEF_RST(R9A07G043_ADC_PRESETN, 0x8a8, 0),
 	DEF_RST(R9A07G043_ADC_ADRST_N, 0x8a8, 1),
 	DEF_RST(R9A07G043_TSU_PRESETN, 0x8ac, 0),
+#ifdef CONFIG_RISCV
+	DEF_RST(R9A07G043_NCEPLIC_ARESETN, 0x908, 0),
+#endif
+
 };
 
 static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
@@ -347,6 +355,7 @@ static const unsigned int r9a07g043_crit_mod_clks[] __initconst = {
 #endif
 #ifdef CONFIG_RISCV
 	MOD_CLK_BASE + R9A07G043_IAX45_CLK,
+	MOD_CLK_BASE + R9A07G043_NCEPLIC_ACLK,
 #endif
 	MOD_CLK_BASE + R9A07G043_DMAC_ACLK,
 };
-- 
2.43.0



