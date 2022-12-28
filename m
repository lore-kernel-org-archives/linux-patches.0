Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AEC1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E167C433D2;
	Wed, 28 Dec 2022 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241511;
	bh=NyCK2DCmunHbF2YtxfuT3EFR37RCzlhbdXdP+7WhXhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1jL22B7QeBOFg+boQs9pnsyte3lUBghNWehf26ZZ2RNItJd+KZZSSbKMyY2eJ326
	 uKf7YUotSPPfZxuAXe9fTKhC2AdrvAskZKIZ0IqFAL9q7hAvOwW+cam5GUvlTrUmKD
	 JHSPRzee5lfZQmUjgJYV36Mg9sJ8GOiCboBr6+Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0255/1146] clk: renesas: r8a779a0: Fix SD0H clock name
Date: Wed, 28 Dec 2022 15:29:54 +0100
Message-Id: <20221228144337.063969706@linuxfoundation.org>
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

[ Upstream commit db7076d5a7f0ca7dcf08f5095c74f86d4d0085ff ]

Correct the misspelled textual name of the SD0H clock.

Fixes: 470e3f0d0b15 ("clk: renesas: rcar-gen4: Introduce R-Car Gen4 CPG driver")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20221012184830.3199-1-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779a0-cpg-mssr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r8a779a0-cpg-mssr.c b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
index d74d46833012..e02542ca24a0 100644
--- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
@@ -116,7 +116,7 @@ static const struct cpg_core_clk r8a779a0_core_clks[] __initconst = {
 	DEF_FIXED("cp",		R8A779A0_CLK_CP,	CLK_EXTAL,	2, 1),
 	DEF_FIXED("cl16mck",	R8A779A0_CLK_CL16MCK,	CLK_PLL1_DIV2,	64, 1),
 
-	DEF_GEN4_SDH("sdh0",	R8A779A0_CLK_SD0H,	CLK_SDSRC,	   0x870),
+	DEF_GEN4_SDH("sd0h",	R8A779A0_CLK_SD0H,	CLK_SDSRC,	   0x870),
 	DEF_GEN4_SD("sd0",	R8A779A0_CLK_SD0,	R8A779A0_CLK_SD0H, 0x870),
 
 	DEF_BASE("rpc",		R8A779A0_CLK_RPC, CLK_TYPE_GEN4_RPC, CLK_RPCSRC),
-- 
2.35.1



