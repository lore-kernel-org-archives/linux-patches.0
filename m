Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957842DBF75;
	Tue, 21 Jul 2026 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659962; cv=none; b=Jvj4z/ou86YVM5B8lIgec+KmN9qCz81BE/rNSsW7RGHL3Y0lon7Y7KWK/chCrOKPF2+4cpW8VK7G1jK9ZPVp4jm4DQtr+gZGrEa+wOTbPsX2Gpk1W9RN8yH3nYMejZdJqzMqFl1ftmtmEH31o6+hKAnJBnUqF7hPeo7Y0ahBbLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659962; c=relaxed/simple;
	bh=D8eowpiSYCdITkqDZIbpcmRgtincTOsV/ae2ak5YJ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBcObYq45vFsFo8OXk/FQGhJh7Yv2E1nHpzjP5Tgo17sZRAhUnW9ykoI0yQXMZt/OpUUg7fjk+YtFSfq0mxeboM1lNzmvnhlejCG32qdZRGA3UdllbiqBryylAD9tm4Jjge6m9SOwPQOz95tQ61Yi5EBNY5AGBrOWSNSHDH6L6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0n6yyf2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0n6yyf2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087221F000E9;
	Tue, 21 Jul 2026 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659961;
	bh=THoMAqMbXtKOeJGJFC1rD0KT1dAUHM45p0Kxo7aRejo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0n6yyf2e6x/iddeSUZoRyDlPf24Nw2efjXSiA5ZRh1pbyM5T5A9/uOeGp/e+lnmnN
	 ZQJ4DKxSBtmHnInwVzZ5flRiD0dQN6jvo9u6w25SLSYkI9A6nW4noLbMzsnOkYSWxT
	 w6OinIATSfjXK28wMltV7n6BQlKYxE7vPTpXgZ/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0799/2077] net: ethernet: oa_tc6: mdiobus->parent initialized with NULL
Date: Tue, 21 Jul 2026 17:07:52 +0200
Message-ID: <20260721152611.637430086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


