Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B50C19E7F7;
	Tue, 16 Jul 2024 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145625; cv=none; b=k+klSeTwXTD2FJAVKWJL+p7qv8qvjS5QJl8irkQGG9TjnKg3/o7oaxTz24dBPssLN/dP/SezSzMf12SCT9OsRnTGI/3fIBDCYufG1UDx7plT+2T0kktJSySk7nujiD6WqCAlAybj5exLytizVI+f8RU29GPfbA6Sk56+m3mE1iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145625; c=relaxed/simple;
	bh=MXOx57TR/ZqNLeRPdrwIYO9uuvjXnegjUzDB1E5hvnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYltktbmQx3nb1CWVaw6verwlgXhSwNffj/Ko9fStbwAixMil5J7NvpY1FojRyvcuYoVsCRma7SH5HdnyWgJibXFgZ6RlSSZHL9chIcL9+Hufz0Wkh2TD7LQAWuMIjnLzq5nDkTdMmhT5hvKjqgGAZo0RiPnlSVY3GD6jSRFx4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOvaqVLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOvaqVLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF71C4AF0E;
	Tue, 16 Jul 2024 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145625;
	bh=MXOx57TR/ZqNLeRPdrwIYO9uuvjXnegjUzDB1E5hvnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOvaqVLxX5gklseGprOY1Vo/iX/Rd1yDfGwcdAryYSb1L6Vna6iuTH8HJ3kvaJ8wa
	 QfRl0/gbDPK7KASWHxI3QXZEkfo2zx+D9Re42QaArYjSqDRa061nUM0UeQlFJLS+eK
	 EpQI1PjcZSI2FIG5InbHFrCHHZbF3JMzNYN5MCX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Hui Lee <jianhui.lee@canonical.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/121] net: ethernet: mtk-star-emac: set mac_managed_pm when probing
Date: Tue, 16 Jul 2024 17:31:32 +0200
Message-ID: <20240716152752.483485832@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



