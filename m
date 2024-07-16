Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878CF12B72;
	Tue, 16 Jul 2024 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144910; cv=none; b=WV8dsQc0clOK/Oh0xVl5cTlTsFwARfdi6z+zVwrzVZ6+keVh41mnkdhMJT5uO5z0jDMuXHFpjIlDulNTItNl4pjxsCCFlLcAP9EiS5Wf31giPbV+Jq7zmq/PYU5EeNOcr+13zfrZ52WuOHsELDPhZMNI5IA0zcsC11oAiUJPSQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144910; c=relaxed/simple;
	bh=eo4TmgqCxcXYnqUsTfWQuqfqiy0cOXhFs0K6nh094Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y110kSFYQZrQw5hRQ3EOzcFm1SemSyHIpXLUn2P3Ch0KIalOmulL4rTsjotNrMOr0uyKALIGFWsk4VPxlbfEM7aenDDQ7fW+NUCce0jm+NwHP8emtw+mC/VbbBJ8GTHItdkdzaTXm/Ea3c80qP6B5D3Ho9a7iIXCwYmEyeIJQ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxdMyi2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxdMyi2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C980C116B1;
	Tue, 16 Jul 2024 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144910;
	bh=eo4TmgqCxcXYnqUsTfWQuqfqiy0cOXhFs0K6nh094Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxdMyi2vhTMsk/x0/QU8S9KyNYZPmi5AocaYf8mo8/OZstV4cvL/P3WpfLc3RsZK/
	 NNGClHHc6G3wkt3xiRjIe1UCmpndEu9Wx6qFVjH8+FVBrZ6CfJ91aGgt7C8ETE/Srw
	 MV6sbxOXmHj7bFE7Lv7/eUO3TIcQGepRKjsZgFlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Hui Lee <jianhui.lee@canonical.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 037/143] net: ethernet: mtk-star-emac: set mac_managed_pm when probing
Date: Tue, 16 Jul 2024 17:30:33 +0200
Message-ID: <20240716152757.415496556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 31aebeb2e2858..25989c79c92e6 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1524,6 +1524,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
 	struct mtk_star_priv *priv;
+	struct phy_device *phydev;
 	struct net_device *ndev;
 	struct device *dev;
 	void __iomem *base;
@@ -1649,6 +1650,12 @@ static int mtk_star_probe(struct platform_device *pdev)
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



