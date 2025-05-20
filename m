Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546A6246789;
	Tue, 20 May 2025 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750159; cv=none; b=KzD9rXjrrItQ7kLnMvoNSi2nyfrUIzuATxU2t2VP5ZVLypFkdZnZOat30vhX0yAIqHwhBcILrM0fYmTGexmKUlEBlwn2ZeH4Rpk3o9JZXSAB3Pan+07LbKqqvvRmCnaPJNmuOKaO14OAA3/esIMSU0NiO7TozhnBq8kZijm18uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750159; c=relaxed/simple;
	bh=nLG30NNEFXz/TxZbSI8+wLjXcthcJcosBPx6NuYaYvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amzarNrkI1BEOX5pzZg7qScr+aqQhsBsiu8sM/7r3c+vFp3IwcodAT+jdOAFhfOQf1kmSderm3Ayguhu7y3kI0WUbdb3Rl0Odpz7RLR++6g2W1gGD8g+O+f4AyHpGeqoukQujTlZVSQbZWilUXTkQW0NeGN00AT66p29l4ByooI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6H0Nu+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6H0Nu+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F13C4CEE9;
	Tue, 20 May 2025 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750159;
	bh=nLG30NNEFXz/TxZbSI8+wLjXcthcJcosBPx6NuYaYvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6H0Nu+VwYh5hblYHHLif22xh7BSGdQPWJcNh7A7iwc6JW03l2m2B9qFvhdCbQNhw
	 s52suqH2kPtux6GK5JpMLTaNZFFVHxTeEO7YUTjhagn7Zqo6Jmm4cHkwyLpccecg1/
	 YwCF9yT8LhJypgcPlgPvv6q2RmEr5+MSuTa54WUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/143] net: ethernet: mtk_eth_soc: fix typo for declaration MT7988 ESW capability
Date: Tue, 20 May 2025 15:50:16 +0200
Message-ID: <20250520125812.454050107@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo-Cun Chen <bc-bocun.chen@mediatek.com>

[ Upstream commit 1bdea6fad6fb985ff13828373c48e337c4e939f9 ]

Since MTK_ESW_BIT is a bit number rather than a bitmap, it causes
MTK_HAS_CAPS to produce incorrect results. This leads to the ETH
driver not declaring MAC capabilities correctly for the MT7988 ESW.

Fixes: 445eb6448ed3 ("net: ethernet: mtk_eth_soc: add basic support for MT7988 SoC")
Signed-off-by: Bo-Cun Chen <bc-bocun.chen@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/b8b37f409d1280fad9c4d32521e6207f63cd3213.1747110258.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0a13f7c4684e0..272f178906d61 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4685,7 +4685,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	}
 
 	if (mtk_is_netsys_v3_or_greater(mac->hw) &&
-	    MTK_HAS_CAPS(mac->hw->soc->caps, MTK_ESW_BIT) &&
+	    MTK_HAS_CAPS(mac->hw->soc->caps, MTK_ESW) &&
 	    id == MTK_GMAC1_ID) {
 		mac->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
 						       MAC_SYM_PAUSE |
-- 
2.39.5



