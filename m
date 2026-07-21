Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10FD42DFEC;
	Tue, 21 Jul 2026 19:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662313; cv=none; b=cHrxjqUTK81ocyuDBvG8fxJSGWpGqyp5w07D/DjAbD4n5WXHprntQSHj2s1sWk/t88Zc3EZIpVH/tM3O6G8mBD2SJEcncjCXMD3JJYlU2BCLlxfvH3B8KlFfL6E0CIeIeylWYgpV7Vq90SZ/WWOCxv7jkr5gpizFEwHN0r3APdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662313; c=relaxed/simple;
	bh=l2jPpUg6tmgz89fOPQxmT+XkwIlzXl8ozFirPfnPApE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEjRcoE9/m4r9hmdj08eMyDXlTw8DThNiTSprS4qmyLO4vxGUsJLygMHbJYYV2M0E6lvO6V3kFn25dzxXU2nctYsocKogkPxUgmO/G/o4U0l4H7l/J7oFEyF+LPhUTbBd2oBa4OevGtC5MIF0CyTcPS7ivRnNJvgmFvq8U1eTDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjbGckqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjbGckqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E271F000E9;
	Tue, 21 Jul 2026 19:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662312;
	bh=H7D/vBk+lqm8MiFrT0ZmiPGacmMFRzVq4SGeciS9oy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjbGckqq1LgCvE/CV8x5bhaJ6SW7/tkya5lwphjpX0pOS5XaZ6gagumsyigygarAc
	 /nl7gAjI1FO5cgM6vCW4iC3rDu82r3r3fgum9kKBnkNnAkoXejacMN1pAos1oVdzPS
	 2fqXDxshZc5hoPrtjSe66Nff/baFgE7mJ/LQWVnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0396/1276] net: ethernet: oa_tc6: mdiobus->parent initialized with NULL
Date: Tue, 21 Jul 2026 17:13:59 +0200
Message-ID: <20260721152454.966559457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


