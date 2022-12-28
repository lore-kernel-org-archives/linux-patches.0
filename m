Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2661863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D43C433D2;
	Wed, 28 Dec 2022 15:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241913;
	bh=UfMPzCVzGrow/+bBjfRgfwOs03pviK4RhyZEeHAT7GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2G34cd7q93a1mu7sfLcMXzUHFzkqW4QkC/PmFFE8akC6w6qcSkZESBnrWhS3tRS8
	 IdmQ/XUqtbaYFZZi6/v3X4ErWwg/EA2K4d8RG/iO+JfFTqXiC8/fq6PFjeBEK2FWnW
	 JM/W3LnnHfkUoh8JmpU1vpmuKBrwjwnftrBrq978=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0304/1146] clk: renesas: r8a779f0: Fix HSCIF parent clocks
Date: Wed, 28 Dec 2022 15:30:43 +0100
Message-Id: <20221228144338.410556521@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c258e3ab639112d8f5ae9df9a873750ae2623ce2 ]

As serial communication requires a clean clock signal, the High Speed
Serial Communication Interfaces with FIFO (HSCIF) are clocked by a clock
that is not affected by Spread Spectrum or Fractional Multiplication.

Hence change the parent clocks for the HSCIF modules from the S0D3_PER
clock to the SASYNCPERD1 clock (which has the same clock rate), cfr.
R-Car S4-8 Hardware User's Manual rev. 0.81.

Fixes: 080bcd8d5997 ("clk: renesas: r8a779f0: Add HSCIF clocks")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20221103143440.46449-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/r8a779f0-cpg-mssr.c b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
index 9504497caaf2..f293a8a54fb2 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -126,10 +126,10 @@ static const struct cpg_core_clk r8a779f0_core_clks[] __initconst = {
 };
 
 static const struct mssr_mod_clk r8a779f0_mod_clks[] __initconst = {
-	DEF_MOD("hscif0",	514,	R8A779F0_CLK_S0D3),
-	DEF_MOD("hscif1",	515,	R8A779F0_CLK_S0D3),
-	DEF_MOD("hscif2",	516,	R8A779F0_CLK_S0D3),
-	DEF_MOD("hscif3",	517,	R8A779F0_CLK_S0D3),
+	DEF_MOD("hscif0",	514,	R8A779F0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif1",	515,	R8A779F0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif2",	516,	R8A779F0_CLK_SASYNCPERD1),
+	DEF_MOD("hscif3",	517,	R8A779F0_CLK_SASYNCPERD1),
 	DEF_MOD("i2c0",		518,	R8A779F0_CLK_S0D6_PER),
 	DEF_MOD("i2c1",		519,	R8A779F0_CLK_S0D6_PER),
 	DEF_MOD("i2c2",		520,	R8A779F0_CLK_S0D6_PER),
-- 
2.35.1



