Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B9B43AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KX9ewAZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8FBC116B1;
	Wed, 15 Nov 2023 20:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081279;
	bh=bJNRL5OnLkp5GfzPVxPPlmYJoe45rPmHrmaDjlucwYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KX9ewAZgtOsqBhnvNdHdFZAI/WOSOomkYphXPY9zoOgvjdGYCWLtOJCGJP1r9Kibc
	 j942/3J5NBpQtiEz3AQeGtqP9/Emgp44tuCZlumhjA3ZygsAt6IVhXFi44KNMtnP20
	 lQyyUgem93/S/nqIOzwC93RsVRhgKInBfP15zi2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/244] clk: renesas: rzg2l: Simplify multiplication/shift logic
Date: Wed, 15 Nov 2023 15:34:12 -0500
Message-ID: <20231115203551.955939762@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 29db30c45f07c929c86c40a5b85f18b69c89c638 ]

"a * (1 << b)" == "a << b".

No change in generated code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/71e1cf2e30fb2d7966fc8ec6bab23eb7e24aa1c4.1645460687.git.geert+renesas@glider.be
Stable-dep-of: a2b23159499e ("clk: renesas: rzg2l: Fix computation formula")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 1c92e73cd2b8c..e435d88d9da89 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -155,7 +155,7 @@ static unsigned long rzg2l_cpg_pll_clk_recalc_rate(struct clk_hw *hw,
 	val1 = readl(priv->base + GET_REG_SAMPLL_CLK1(pll_clk->conf));
 	val2 = readl(priv->base + GET_REG_SAMPLL_CLK2(pll_clk->conf));
 	mult = MDIV(val1) + KDIV(val1) / 65536;
-	div = PDIV(val1) * (1 << SDIV(val2));
+	div = PDIV(val1) << SDIV(val2);
 
 	return DIV_ROUND_CLOSEST_ULL((u64)parent_rate * mult, div);
 }
-- 
2.42.0



