Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B25F415F05;
	Tue, 21 Jul 2026 18:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656884; cv=none; b=WjacOrMRVE7E6+6YDFFPW5wBZmcCGMOISdjCSVvBOzfly5tWLH0sYJ5TYPauEAEhUyoccoO1JXufHP5SyNSq/0TaJBrStlfS6w6Wz3cUqqyiFvurxjEsrbXOjSuGoVrXAMzhBk7ZP7vTQFap3SZBUvy6O+OllHd/MDFrKmROU+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656884; c=relaxed/simple;
	bh=qVlKWFoDigt0kTDwSLreLeseK6fVYQermA5hK+5g8E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I99F5WnIjQTRSvhe/pPIS1Ra5qpWAp5DLp+D8r/+oNW02Ab8dx2Xm2uLjkesrr9qFlUl3dsu6zIliltw4N+MFzBn1gr+VrjmnlXLYMPe5pgdD66IKw7apNd1cTQsAizlHS1f4WkY//9MLpyVJaWQex0sFd7VzkKwMJOkjeeKNe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=di03li2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="di03li2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3C11F000E9;
	Tue, 21 Jul 2026 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656883;
	bh=r0Ixu5SQoJlbT6PrZfRZskIeTBE+2FWyh4BVbjpsmh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=di03li2qBeKQtm+uCi9jtcX7ETAY2F0Hyx09DftYvGxPck5Jyo6O2Cs2iGLx0GPKD
	 oNykqLbhUgR6yi7jLjoq7vA7P9RrpdaTUbEeaXM+5DKLZ4epVbwvJOABX3qA4UZTSC
	 RsHxubbLYWBKVExU48rXV86nuEK3mllE9ivEgIFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0553/1611] net: ethernet: oa_tc6: mdiobus->parent initialized with NULL
Date: Tue, 21 Jul 2026 17:11:09 +0200
Message-ID: <20260721152527.818734732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit a221d3f7e3f3ea6a3b4bc511cf2a59242daa06e1 ]

As "dev" pointer in oa_tc6 structure is never initialized,
mbiobus->parent was initialized with NULL.  This change
fixes it by initializing it with device pointer of spi.

Fixes: 8f9bf857e43b ("net: ethernet: oa_tc6: implement internal PHY initialization")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260611-level-trigger-v5-2-4533a9e85ce2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -107,7 +107,6 @@
 
 /* Internal structure for MAC-PHY drivers */
 struct oa_tc6 {
-	struct device *dev;
 	struct net_device *netdev;
 	struct phy_device *phydev;
 	struct mii_bus *mdiobus;
@@ -518,7 +517,7 @@ static int oa_tc6_mdiobus_register(struc
 	tc6->mdiobus->read_c45 = oa_tc6_mdiobus_read_c45;
 	tc6->mdiobus->write_c45 = oa_tc6_mdiobus_write_c45;
 	tc6->mdiobus->name = "oa-tc6-mdiobus";
-	tc6->mdiobus->parent = tc6->dev;
+	tc6->mdiobus->parent = &tc6->spi->dev;
 
 	snprintf(tc6->mdiobus->id, ARRAY_SIZE(tc6->mdiobus->id), "%s",
 		 dev_name(&tc6->spi->dev));


