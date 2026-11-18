Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048283;
	b=xus4qxzuh8yt6XN2pSd7aon5Se23lWT6WqmWbv8gl1Vjnl+e/GU90IZlHBcsN0aVXyE4
	 3AXxHO62HBmwnUl33GcFm095TdZFfmNStk7I3JyhXc69M3XKhHd1SC7JTRgsT14DCZV07
	 dmh03H5aLgManWAih+gN4P/9TpiO1N3o5bjReaipSyrJCKYBgjudRPcBL+DZVeRcmecGx
	 dP5Cl57tBST+4DwArSIhFWkvdm8+H/eKQkK7iXrkGUXv5yft+Sdz1PpIPG9Kmd6Fn1pw+
	 EARswfG1JrOcv3BAu0ZnDq9r1Rwi48FOVEV0PTdWCoFNU8fzcp1FKuDwRzhe0+BM5Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jhWedttkv1w41S4V6d7tn8YZ5HD2I7fglcNbbtwkFAc=;
	b=Sk8hXM9yaZJsQ7k/Pn+huErPXHCdQUxCap5WYbLC0vc92RPbApzjO60yLuE66Rew69Dr
	 RA7obHJNmQw+lJ4aSCopJ2Aop0VBo9KFVC0s+nQi+h29Js0f0kvLcYJoJzWxw5qNG5EZ4
	 f9nON/P5qLhQif0Php8j/Hsz6TrKFtOmMJhC4I997W3Wg7p2hW5ZQfdeR5LiGApQ8G0sN
	 Ami77a/vnLzULPGOI2zMSdeyrqT55Zy6k2YP7nRBOWHduZcgcaGfXbHMTObx2w8wtJoft
	 gKMERpQf6zCTblpWoiETmcSvWf1eAgYWkds7mmlykkk42uSrYWZV7qIwKAG5KCVmkxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBCFwOU9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD17606A334;
	Thu, 19 Nov 2026 00:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBCFwOU9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D461F000C4;
	Thu, 19 Nov 2026 00:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048282;
	bh=jhWedttkv1w41S4V6d7tn8YZ5HD2I7fglcNbbtwkFAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBCFwOU9bAtOyi17xfkcJQ8gVJ16ZKQR9W7KV/wUeYCgTKkZ8eTJwRL9io2o65MAN
	 FZ2jdE1ghfIcVmk9wDwLgNzg5JiubNBwCn36PJoSP0po++I+xrL+f3m+HSw/WX3VWh
	 w3DbBsLlp50uwjpKhwObrYWi34pHm+c2j4tR0YBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1938/2857] phy: cadence: Sierra: Do not modify register when getting parent clock
Date: Wed, 18 Nov 2026 15:49:32 +0100
Message-ID: <20261118150310.992129848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6e86a6517f378..d560f4c1e686c 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -662,23 +662,16 @@ static const struct phy_ops noop_ops = {
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



