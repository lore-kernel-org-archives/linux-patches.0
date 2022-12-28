Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CDB1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C99C433EF;
	Wed, 28 Dec 2022 16:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246132;
	bh=87Fm83zzhdCo40yLR2Qb9vfcz28VPo8F2EtMDVbNYOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCrjurD8WfJqWoy7cP0OvBzHJoGg3R/Ist82mgcP/eNS84Vcz8ZvF8ZOAIy/Q0D2i
	 L7UE9DJHrcTN9vxNtc5HBwheG/1vmo5VUH4ZDHOai3MaCPEnsQQTvlVPxLi5wM9UbI
	 7A0GeaGYylRyGzKYFmiX8oKXtYsBYElPsq+NVdr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0995/1073] clk: renesas: r8a779f0: Add TMU and parent SASYNC clocks
Date: Wed, 28 Dec 2022 15:43:03 +0100
Message-Id: <20221228144355.151108173@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 1e56ebc9872feb2cf9a002c0a23d79a68f6493cb ]

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20220726210110.1444-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/clk/renesas/r8a779f0-cpg-mssr.c b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
index 9bd6746e6a07..738f71556621 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -108,6 +108,11 @@ static const struct cpg_core_clk r8a779f0_core_clks[] __initconst = {
 	DEF_FIXED("cbfusa",	R8A779F0_CLK_CBFUSA,	CLK_EXTAL,	2, 1),
 	DEF_FIXED("cpex",	R8A779F0_CLK_CPEX,	CLK_EXTAL,	2, 1),
 
+	DEF_FIXED("sasyncrt",	R8A779F0_CLK_SASYNCRT,	CLK_PLL5_DIV4,	48, 1),
+	DEF_FIXED("sasyncperd1", R8A779F0_CLK_SASYNCPERD1, CLK_PLL5_DIV4, 3, 1),
+	DEF_FIXED("sasyncperd2", R8A779F0_CLK_SASYNCPERD2, R8A779F0_CLK_SASYNCPERD1, 2, 1),
+	DEF_FIXED("sasyncperd4", R8A779F0_CLK_SASYNCPERD4, R8A779F0_CLK_SASYNCPERD1, 4, 1),
+
 	DEF_GEN4_SDH("sdh0",	R8A779F0_CLK_SD0H,	CLK_SDSRC,	   0x870),
 	DEF_GEN4_SD("sd0",	R8A779F0_CLK_SD0,	R8A779F0_CLK_SD0H, 0x870),
 
@@ -140,6 +145,11 @@ static const struct mssr_mod_clk r8a779f0_mod_clks[] __initconst = {
 	DEF_MOD("sdhi0",        706,    R8A779F0_CLK_SD0),
 	DEF_MOD("sys-dmac0",	709,	R8A779F0_CLK_S0D3_PER),
 	DEF_MOD("sys-dmac1",	710,	R8A779F0_CLK_S0D3_PER),
+	DEF_MOD("tmu0",		713,	R8A779F0_CLK_SASYNCRT),
+	DEF_MOD("tmu1",		714,	R8A779F0_CLK_SASYNCPERD2),
+	DEF_MOD("tmu2",		715,	R8A779F0_CLK_SASYNCPERD2),
+	DEF_MOD("tmu3",		716,	R8A779F0_CLK_SASYNCPERD2),
+	DEF_MOD("tmu4",		717,	R8A779F0_CLK_SASYNCPERD2),
 	DEF_MOD("wdt",		907,	R8A779F0_CLK_R),
 	DEF_MOD("pfc0",		915,	R8A779F0_CLK_CL16M),
 	DEF_MOD("tsc",		919,	R8A779F0_CLK_CL16M),
-- 
2.35.1



