Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029607;
	b=dbTLb/h1zvzXNtGJIuVM978XxOJyjjl8AkWClaJ/UPD54USP7gaSybURBoUO1Kb1Vcuh
	 ExuKPEES/F/3VdckVsRRFyV54s/bs1W9DkuGOo89EgJBo4poWAeWg8WK0mLtW7Wj2Oyr/
	 ttZq4VcBKJAVlKWqZocvG/3orU+Upcgq2cSRxyB4XRh25t4lu9kJnIufMNl1j3m8qP8bf
	 X0QlMMj0i0pWZb/T5Z0rY9K47NK55qVXkjQZO+EGz8RF8BGn/c0dhwt3vi0b1h5vbpPkQ
	 WIz1640vwid0FK4pFxkUy6Cwvta9ejGb/5fIsnTIMxMC1WMwY7ztNzEF48F7+BMnEUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pBfy7hAkjrntvGmFmITzqUdPJEidijlpzwmKCqyuGWs=;
	b=TwG5TwTQ0lC8pWxwxG/q5cdjnbRzo9Y9Q1ALA1ELuZSHMKHxBiZRaj+QuZPE1ZlvaTh2
	 qGsmZ+WjUfV+AG30Ol6x3tLaeR+UoP2eAAn0RvPsS2HWVfaSX/uhhmH8uhGRoirWdudcH
	 Kj059ysKefVtKcAYdQcgmoAyzvOz1cUineHxj5WvnIwCqjZZZp+xqirAs8aR2NuO14UgK
	 EPYLskA1xU5DSXGli98iJuonPV09Bd7zxr2fYOE0LEqvlQPscvW8PBeaT6zYJDRF5UF1P
	 49WpIuNsJoQrYjpHXz7UP3QDsSHpHV7GbQcMXA9jRAwJwar5iF67ymuY3tvOKaimBnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JQZV/ha6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A70D606A338;
	Wed, 18 Nov 2026 19:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQZV/ha6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A631F000C4;
	Wed, 18 Nov 2026 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029607;
	bh=pBfy7hAkjrntvGmFmITzqUdPJEidijlpzwmKCqyuGWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQZV/ha6RhL26kTBDyqe3fhu8ZCNd3bY+o4SD5zB23b8/uozxKvmXHNeOVKSWVVKT
	 Q3vm+6uf4l2d5qIpIa2zfrgUvgJE2Llf9QqTLmZ6vHgI4dDWPOkUpOXYRQg5asWSTP
	 AgKjH6u25MlrP443EyH2a3btoQuGpGiQ6TO8Hskk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0409/1756] phy: cadence: Sierra: Do not modify register when getting parent clock
Date: Wed, 18 Nov 2026 15:42:16 +0100
Message-ID: <20261118150025.034939497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dfc4f55d112e1..eac6819be8380 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -695,23 +695,16 @@ static const struct phy_ops noop_ops = {
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



