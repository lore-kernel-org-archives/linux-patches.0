Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFA627EF5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEnBlihY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348F8C433CB;
	Mon,  9 Oct 2023 13:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858169;
	bh=FCTHsZN7ynK/t5Lag6KIJPe8375IqfM2MzrW2fFNVj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEnBlihY95xY266nA2pdmrtfTreiTMmxL/09aDtu2GpIGZBZOyZxP8X2DCR1UPVPu
	 uG8RLZwYWdj64DvtxV5YNSiQeeIHDOp6PRGMae+GacVs2fi4lTMuOuX8vnYDWcB3Lw
	 hpYdJ40s1LKk2XP0E/id5quaYDxwFN+6d8iJw6VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anson Huang <Anson.Huang@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/131] clk: imx: pll14xx: Add new frequency entries for pll1443x table
Date: Mon,  9 Oct 2023 15:01:17 +0200
Message-ID: <20231009130117.442903050@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 57795654fb553a78f07a9f92d87fb2582379cd93 ]

Add new frequency entries to pll1443x table to meet different
display settings requirement.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 72d00e560d10 ("clk: imx: pll14xx: dynamically configure PLL for 393216000/361267200Hz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-pll14xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
index 129a28c3366eb..e7bf6babc28b4 100644
--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -53,8 +53,10 @@ static const struct imx_pll14xx_rate_table imx_pll1416x_tbl[] = {
 };
 
 static const struct imx_pll14xx_rate_table imx_pll1443x_tbl[] = {
+	PLL_1443X_RATE(1039500000U, 173, 2, 1, 16384),
 	PLL_1443X_RATE(650000000U, 325, 3, 2, 0),
 	PLL_1443X_RATE(594000000U, 198, 2, 2, 0),
+	PLL_1443X_RATE(519750000U, 173, 2, 2, 16384),
 	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
 	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
 };
-- 
2.40.1



