Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055085;
	b=MHTIMEiHJn/ap2LZ1xblYVrGaI9oHjFiv9S9kA7hStauuFsDJvxDhp9Y+o0VFnv71HjX
	 KE5xy/TKOGsdpL2OsjlidfSiGLUlp5AZlEcQRPPgNCfImf6YhHPDTc/XbPt6e+NeM2p5Z
	 8XwvzDcB21QLoMhfsrvtWCBWi7SA0pXyWc2Vr7DYTWgTqlT4B4FP+Ck7YD5vix1mkd0Og
	 hY+C2kCSDTLlDRIvtfCGAR058mIsHPoLiEF8dPFEjqvZUnl+91Y6LJsA72DJs2pHSqJbL
	 BDMPSbj81UqkxX15zYcSmbVgzhdfLiQQ8emH7ZWFCue9DdaNrJXQjgOvldaFfj0+mTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZaUAM60PN9/Xr5uPaxy3rEKGMNSKYEivAG9KM9eG4C4=;
	b=r34HfOJwvvr2WJ/UqWcVLqgyugo5BVKz41u3Q1+U9kzdGGhxWCOSyE3tyMe1AoYtSNe3
	 VUq8lMo8GIK1CCr0OvNLAwqcC+UULxzPq8rKLwqKomDUKwn9rpj49MbxsPjK4cC52meLX
	 CMwyYPhnQlur063gU7wehjBxTjuu2vfARI5KIgzpxgh3T6M8MaV6u+ZtXomOLQrDzbOuQ
	 vVxEYtm5mbRDPSjmFGY/pK2QqBqpi7WTI/fvoQeKpimp7OKZ2F3d8OvSWtdSNWow1hczz
	 Do6w4Jvy+WV9pjsZBvmOnhdW+dJ8HIxrxhl1SEh+WdPrM+Xl7BCoEAtMNi73dZy8P7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8PsvFbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0424F606A31C;
	Thu, 19 Nov 2026 02:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8PsvFbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C7A1F000C4;
	Thu, 19 Nov 2026 02:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055084;
	bh=ZaUAM60PN9/Xr5uPaxy3rEKGMNSKYEivAG9KM9eG4C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8PsvFbh77eYQz2erbWTp+C6ZPp+kDgPQZOTs5cQAZxm+J67cFJ4z+u8VsCnBLHIu
	 3sJYKChPHiLcpiV/w5bXNPdOq3CMwFo7pICnZHiPrgIwxPQN6+v55AesFj5srKwL6K
	 UDKjNLzmdvrTsSrv6GBPedOsYuKPydX5xOr8719o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1503/2214] phy: cadence: Sierra: Do not modify register when getting parent clock
Date: Wed, 18 Nov 2026 15:52:59 +0100
Message-ID: <20261118150111.987700990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3e2d096d54fd7..4b062976267d6 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -439,23 +439,16 @@ static const struct phy_ops ops = {
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



