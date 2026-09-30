Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920F14DB540;
	Wed, 30 Sep 2026 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786470; cv=none; b=S9fVzGKhL7kgRidkNeHixsqAnD1IXYZ3cOV0pUNdlE0Ze+JoHNiXlxUgN47xtKHPnFQ8DRtbqw54Zwp4pEc8B4kx+R/dRFQal9MJr4/oCiRIVQgFb0H7Lxxi2mgPT2H7bXVLNhxJQAbT9OBEDokWQpiyVaq7SHUHGcWQkI7V4V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786470; c=relaxed/simple;
	bh=EsYD1McWDC/cx7JjNLp2fEUvKS+XlWuaz6gVuxQJV5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1tD3c+3DTCcFnC/MFw1EFU1UrRFJ8NzaZ00jynjYRRHCtEyluWVAeh7z8PcdOqTyls2/TExhy41P4fHe4U2geDmOk7w0wK+UAONzr6c+AE6L4akw8AAJ4MmWPMOvHjjG8DW5q9cmtZ7Bzp8eOvmSFhha3Vfyd+3i1MH1Wmk0UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2l5Nc7Z4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2l5Nc7Z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFD41F000FF;
	Wed, 30 Sep 2026 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786469;
	bh=Wrh03rctoMm17lETwTkH7ysXVWrTUOrx0bkzJofKnys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2l5Nc7Z4bt7/3SfkP4u/hSJq14WThmQMB5nWHsEePJROV0ib2nDA1v8ch3p/b7gC5
	 11etgfRK7pBwSkk236Wyrr45R9B8cQ8ghC523Y7d+GhsISKveptdiDJgczM25igo+0
	 4VAjox7S5dViQrtnVjta9FRzen9Cn/lKOzzSs18I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 871/982] net: stmmac: selftests: Check the dev->features for S-TAG offload testing
Date: Wed, 30 Sep 2026 17:26:47 +0200
Message-ID: <20260930152435.459345823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit ba804b23d76d278ee475b8427fa7c5623ce5e270 ]

The S-TAG offload insertion incorrectly checks the dvlan (double vlan)
DMA cap, which is different than S-TAG support. Use
NETIF_F_HW_VLAN_STAG_TX to check if the feature is supported instead.

Note that this flag isn't set in stmmac yet, but contrary to ARP
offload, this is a feature that has a chance to get there eventually so
let's leave the selftest here for now. It'll report -EOPNOTSUPP in the
meantime.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260917215339.2022523-4-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 9ceb9ed751c93..e2fd7de10dd21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1395,7 +1395,7 @@ static int stmmac_test_vlanoff(struct stmmac_priv *priv)
 
 static int stmmac_test_svlanoff(struct stmmac_priv *priv)
 {
-	if (!priv->dma_cap.dvlan)
+	if (!(priv->dev->features & NETIF_F_HW_VLAN_STAG_TX))
 		return -EOPNOTSUPP;
 	return stmmac_test_vlanoff_common(priv, true);
 }
-- 
2.53.0



