Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A05F1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97DDC433D2;
	Wed, 28 Dec 2022 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246071;
	bh=LTIEMs3jUwd4MNBCGFtthpNq7nlSQdLSupImvk5ZNcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfD9qmd/VlOd5hHiAuGUejebyiZdjm71yYHsG8UYPzBHXMYr1qFMXMyrC+gkLW2ou
	 7z3VnX5mpNtYRt0m/XKRj0bZJNJIXsnFGJ2FkLdIOXv+3GLQ5Z3BGLloLZl3lT21u5
	 8IDtSXZ6wezF5GgRUw6Dz5nl5Wt0aW2D1FKUZC3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0994/1073] clk: renesas: r8a779f0: Add SDH0 clock
Date: Wed, 28 Dec 2022 15:43:02 +0100
Message-Id: <20221228144355.118782601@linuxfoundation.org>
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

[ Upstream commit 9b5dd1ff705c68549f7a2a91dd8beee14bc543e1 ]

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20220711134656.277730-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 1e56ebc9872f ("clk: renesas: r8a779f0: Add TMU and parent SASYNC clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779f0-cpg-mssr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r8a779f0-cpg-mssr.c b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
index b7936f422c27..9bd6746e6a07 100644
--- a/drivers/clk/renesas/r8a779f0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779f0-cpg-mssr.c
@@ -108,7 +108,8 @@ static const struct cpg_core_clk r8a779f0_core_clks[] __initconst = {
 	DEF_FIXED("cbfusa",	R8A779F0_CLK_CBFUSA,	CLK_EXTAL,	2, 1),
 	DEF_FIXED("cpex",	R8A779F0_CLK_CPEX,	CLK_EXTAL,	2, 1),
 
-	DEF_GEN4_SD("sd0",	R8A779F0_CLK_SD0,	CLK_SDSRC,	0x870),
+	DEF_GEN4_SDH("sdh0",	R8A779F0_CLK_SD0H,	CLK_SDSRC,	   0x870),
+	DEF_GEN4_SD("sd0",	R8A779F0_CLK_SD0,	R8A779F0_CLK_SD0H, 0x870),
 
 	DEF_BASE("rpc",		R8A779F0_CLK_RPC,	CLK_TYPE_GEN4_RPC, CLK_RPCSRC),
 	DEF_BASE("rpcd2",	R8A779F0_CLK_RPCD2,	CLK_TYPE_GEN4_RPCD2, R8A779F0_CLK_RPC),
-- 
2.35.1



