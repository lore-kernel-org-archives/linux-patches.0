Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039773;
	b=F8oSe2D+/ywKSLZuEQtK/jp/sJoTkV2EeF6DaEzZGhmwcqiBiH453m0CxbHIngY4AgOx
	 j1kJtiNtNvjG+ANrKR8osYdKHuajMU0Z7MuMMUCeY4fdmhJLdBaldSQL8iJh/OO0u+30z
	 DBJyzoVb5sYsDeJy2t6DT5Sprg/Y6IBn9/b/HI/iLPjZXUlPn2efcTQIfb/NnmNFkOEjI
	 myXNzjxtmE3Fsy6daRBGPrAZSD2CW7r7YmsYjLaQ6l7rkbt8wpwKkgOrSJ8AMpDEmzGJ6
	 vJI218WLvAb09ZeilfMvLkvwEXSY8/IDfaTwZnD036vdrvLR0TWIbOseYNDD4N9KNew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kqyJcVTlOhUVnAP6/anwoOgy1WwGNkhEgkugU+//rqA=;
	b=UhSOKdHcy0br0gvMHCsK7DeX1uITh0BC7BEjFcnGkPTQi4IWnISbP7S0Gro3FgSiNOEJ
	 GZfSfJDSiUDoutdml5fxfnCk1cOvhDA3YMP3do5tprUa/8FjMPfZQZzB9SyAeJwFbgQEF
	 x7qQasuwXT32AMlV3tfcUFyju8C1Ab5zKZ9cmUs1oX3ytc/dEjonJcVjy5ouO6Fyj61MP
	 gsNLRIi2qMqzNyU48c01h7i4cLaEaeJ8ua9jrGuYMT+elGiOxKbcSHi3KQ1ugzXcqfYeG
	 PZG/BWUUXN0jADH5lhB/fW+gXtGiu51deO6+ypr7PWSffyglKzFL8/aCGEQ42Clh3mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiPuwmlS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C4D606A325;
	Wed, 18 Nov 2026 22:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiPuwmlS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F481F000C4;
	Wed, 18 Nov 2026 22:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039773;
	bh=kqyJcVTlOhUVnAP6/anwoOgy1WwGNkhEgkugU+//rqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OiPuwmlSM1dYnJZQNFjwWvVMA+Tv5WJJGSRE3hQtrJJrrpE4+cR6N8IBq1Z+WrPkb
	 0XXMVyCVJxwo+1F9qUVQrRnfCilukjuJ8G69RT2pvuTKz2QQComWAlLw8lyvHp+TDw
	 ZrD0HWEdO2XAcRvZSUbxllsLOOantoxREXTxlWMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2219/3318] phy: cadence: Sierra: Do not modify register when getting parent clock
Date: Wed, 18 Nov 2026 15:47:21 +0100
Message-ID: <20261118150428.465156246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 955e68eb3067842067b7b5395a3f8c278428802a ]

The get_parent() callback for the PLL_CMNLC1 clock was incorrectly
writing to the register while determining the parent clock index. This
unintended register access forces the PHY back into training mode. If
the PHY is already configured, this unexpected change prevents it from
exiting training mode.

Remove the register write operation to ensure the PHY remains stable
during the get_parent() callback.

Fixes: da08aab940092 ("phy: cadence: Sierra: Fix to get correct parent for mux clocks")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260306-fix_sierra_get_parent-v2-1-cafe89ee5382@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/phy-cadence-sierra.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/cadence/phy-cadence-sierra.c b/drivers/phy/cadence/phy-cadence-sierra.c
index d4eb93ce82323..c0e8ed769e6ad 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -694,23 +694,16 @@ static const struct phy_ops noop_ops = {
 static u8 cdns_sierra_pll_mux_get_parent(struct clk_hw *hw)
 {
 	struct cdns_sierra_pll_mux *mux = to_cdns_sierra_pll_mux(hw);
-	struct regmap_field *plllc1en_field = mux->plllc1en_field;
-	struct regmap_field *termen_field = mux->termen_field;
 	struct regmap_field *field = mux->pfdclk_sel_preg;
 	unsigned int val;
 	int index;
 
 	regmap_field_read(field, &val);
 
-	if (strstr(clk_hw_get_name(hw), clk_names[CDNS_SIERRA_PLL_CMNLC1])) {
+	if (strstr(clk_hw_get_name(hw), clk_names[CDNS_SIERRA_PLL_CMNLC1]))
 		index = clk_mux_val_to_index(hw, cdns_sierra_pll_mux_table[CMN_PLLLC1], 0, val);
-		if (index == 1) {
-			regmap_field_write(plllc1en_field, 1);
-			regmap_field_write(termen_field, 1);
-		}
-	} else {
+	else
 		index = clk_mux_val_to_index(hw, cdns_sierra_pll_mux_table[CMN_PLLLC], 0, val);
-	}
 
 	return index;
 }
-- 
2.53.0



