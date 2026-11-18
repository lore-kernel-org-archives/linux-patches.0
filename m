Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023659;
	b=u04K6Y93z89HmWBf/YeOOt0jeedkCY8nkzUQnpWyxW3d5/fZu/fsI8WCQYtY/2tlEL3x
	 A6xgynEdcbLu/Ii8Cqx/eVmvPJh03VgrjDej7k/H/VK9oWT7b7WvsQlcac8+eCG2Az8Eg
	 3PVDSH/87mfU604lZdGzLmXqqnxYo/1NczKFc6hhF8J3hFry5FgqooQD9BTlxMStzDQCE
	 5aF6C9NrHUWjMSGquM7seG2nFOrw4m2CvfrJngRZFH73noN0CUDJdX9sFu+hcA++QN1ce
	 F2roKPVGEhyqC07OvIT17SioTCFtsgubOVULZMkm+tqPorthuDeg7RJRdP23sznnmKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W4SWdasc6yUwz1g6v5G0x6lmUjrvb0i82W444p5i16o=;
	b=be5VLD4vJxmJbJIsmJBShAkL+4IeNspCWXfjUJCZvhJK5magdLksiS8r0sigbD8NZb9O
	 CGi6SHBVmG5lWc+IGNurOXyyYwJcA/L9nL+GfJSk2hnWZJ1bgAtJZpiNLUa5165Klyn++
	 czE6SpUxY2mapoLNQmMuih4BWXaNOxRcTpt97/P4hQrDHE72TRnGNjbQnYTccYbvVFRF7
	 7hrWwK3tQmC5KLepAzwUjiYRAtq/+2iD322UVdawy0VE6k3ZTv3COgMpZF8WhfQn8uycD
	 2SgsWTa6bDviRDDSIUhwCkCGp8BXGDXSIwzm/YDTabOWMy9sCMYGOamW35JU7uYZFaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w0tA/aTy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D500606A31C;
	Wed, 18 Nov 2026 17:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0tA/aTy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35D51F000C4;
	Wed, 18 Nov 2026 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023659;
	bh=W4SWdasc6yUwz1g6v5G0x6lmUjrvb0i82W444p5i16o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0tA/aTyhkEwjmj2jTwUi3hmJkLO+habFEg4EcKJLrGci7o+AARitb1l2l3/8TE11
	 QcyFsf38u9rHp0FEYxaEB8CiHB6YBUSJohJNX7jVYUv04WYeIysBYYYxd8VOGXyzQA
	 iqHCJUvjj28aJUG3tzlWlo3+QGC+kHFliu6AU4fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0448/2151] phy: cadence: Sierra: Do not modify register when getting parent clock
Date: Wed, 18 Nov 2026 15:36:23 +0100
Message-ID: <20261118150138.353451487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 92ab1a31646ae..dbeda7f01cbb2 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -698,23 +698,16 @@ static const struct phy_ops noop_ops = {
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



