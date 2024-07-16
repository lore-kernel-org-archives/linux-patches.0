Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA81419E809;
	Tue, 16 Jul 2024 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145313; cv=none; b=BUJ+exsZefU8TdDxRCl+++Y6FEqDn8N/Floh+lVhnh9t5+k0yr4LV5WyvHsSuEI8DjF7LQjuUKZ64DMzQfooLfk74dnt+aqMi2Cn4aE4PMXnckQD4Lsyjx8eviSvtfXiHY1sKS8Xvdj1L4gq6oEcfvT37U4hcclnabwl9tGpogg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145313; c=relaxed/simple;
	bh=Xx2CmBkOEShO1IHg+Hrohe1D0YE4pqzvEB/847ABjRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aryMI6shiFdzU2SSqZ87Cr85veHqSxDRmHOYyf7Z8U972C7wKGDpYxRKYYarfqr1TUYB9zdavI+4dFdQG8/HeRTg+Iz3c/VK1L5qQ1M+sXuFFWmQrn3SAbX4JRGoMNTrmS9AZxJDpj2hLovENc8aGymlVYqJbHhydLg6pbcqHqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul/8pEVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul/8pEVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3B1C4AF0B;
	Tue, 16 Jul 2024 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145312;
	bh=Xx2CmBkOEShO1IHg+Hrohe1D0YE4pqzvEB/847ABjRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ul/8pEVuQ4XnX9rO6rtNytDYBNAqhyYX3Mbq1RiR2E/65dd8Cx4NHM1g4kyPmgcUL
	 MkR4bypn/86BzE9UQu2s+71cjIm40KO6gK4EreOm/ufK1u23fKIuY1EiMCRYxb2yi0
	 YbJkaCfDWjoVZ/tKVddyPvVOT9+mnQyeSGQtOMY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Hui Lee <jianhui.lee@canonical.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/96] net: ethernet: mtk-star-emac: set mac_managed_pm when probing
Date: Tue, 16 Jul 2024 17:31:35 +0200
Message-ID: <20240716152747.445256689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Hui Lee <jianhui.lee@canonical.com>

[ Upstream commit 8c6790b5c25dfac11b589cc37346bcf9e23ad468 ]

The below commit introduced a warning message when phy state is not in
the states: PHY_HALTED, PHY_READY, and PHY_UP.
commit 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")

mtk-star-emac doesn't need mdiobus suspend/resume. To fix the warning
message during resume, indicate the phy resume/suspend is managed by the
mac when probing.

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Jian Hui Lee <jianhui.lee@canonical.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240708065210.4178980-1-jianhui.lee@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 7050351250b7a..ad27749c0931c 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1531,6 +1531,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
 	struct mtk_star_priv *priv;
+	struct phy_device *phydev;
 	struct net_device *ndev;
 	struct device *dev;
 	void __iomem *base;
@@ -1656,6 +1657,12 @@ static int mtk_star_probe(struct platform_device *pdev)
 	netif_napi_add(ndev, &priv->rx_napi, mtk_star_rx_poll);
 	netif_napi_add_tx(ndev, &priv->tx_napi, mtk_star_tx_poll);
 
+	phydev = of_phy_find_device(priv->phy_node);
+	if (phydev) {
+		phydev->mac_managed_pm = true;
+		put_device(&phydev->mdio.dev);
+	}
+
 	return devm_register_netdev(dev, ndev);
 }
 
-- 
2.43.0



