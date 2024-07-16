Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E391DDCE;
	Tue, 16 Jul 2024 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146209; cv=none; b=bX+w3/SfrX5mtoBuKCNbjk/iNgtV7R1mQqZUqh6e/I9FKX0tvRuay2l8iWTH4zORkNDttsf9piJLkIHlxIHRDX/t2YjPLILf6BordduzkoAzX8ow4Gxc8HP6wxzK0MjCnH+W9nbS+uCKUaA3WTcce0Ji8uvWoCaHAYybEP5w/WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146209; c=relaxed/simple;
	bh=482s+RPCh22koZ0kXhVJ3nDa+mQPw3WvwoDB7zheM70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwPthF3PUTkzi0JATxjpNxYdzobnhXCJ6dh5VVFBnFNNCtGrzmCZVMhc54SVIh1BDkQTF8Wlzrl3SoNBbB6ShK+6Mhdqc+uFVKdFpSclj1X/qh0gR+DYBgObsaYlIe1sEVDyT70JngFHd0svMkAz8Taq9dN7peUoeCbsYWiOe4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U405r0qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U405r0qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5545C116B1;
	Tue, 16 Jul 2024 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146209;
	bh=482s+RPCh22koZ0kXhVJ3nDa+mQPw3WvwoDB7zheM70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U405r0qnQtvW31SxfTaefBkyi+1FIrQk6daVts6A8df3gEyptzqMH/y4QFSLHJPUK
	 MwtCc5abC5fVhSm/aSgtr4uZ5AkZOYTyEFibwJPPLafQwwus1Xum9H3cGuD3aqGtK8
	 z3V5h3jAUqzUCynGC1CbkzqgpVdrut5fPpu3K9Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Hui Lee <jianhui.lee@canonical.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/144] net: ethernet: mtk-star-emac: set mac_managed_pm when probing
Date: Tue, 16 Jul 2024 17:32:39 +0200
Message-ID: <20240716152756.001623345@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 67f9e4415ae92..392648246d8f4 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1446,6 +1446,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
 	struct mtk_star_priv *priv;
+	struct phy_device *phydev;
 	struct net_device *ndev;
 	struct device *dev;
 	void __iomem *base;
@@ -1552,6 +1553,12 @@ static int mtk_star_probe(struct platform_device *pdev)
 
 	netif_napi_add(ndev, &priv->napi, mtk_star_poll, NAPI_POLL_WEIGHT);
 
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



