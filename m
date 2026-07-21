Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8E44028F7;
	Tue, 21 Jul 2026 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657974; cv=none; b=VaRvWGDplnoeeOupXTlJxsfNflHjiEmksYitAITFHJZZjcQdm6+26S29WI6n19uRstRkhPlZkNhFQMrjMUFcjk1TJKMX7LaP2XX8wJ+oUn/Kv7dZJbOS96H9srVgt2U4j1mJasuv8502hg7hquDgr6TaVUDC2GbdMqkzd9OKZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657974; c=relaxed/simple;
	bh=5X5FWtGkb+9DBLPbK9E+rLLqIgQuVddb+WYVbTFAJFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs9VpwosrDaDEYck1Rzmdfzb/8FyvJHrsQMT11vKc/PGS39k4xt4rICkiPx3W3qHS5C3zGXA1wZENsj0g4nbaY/bkpCK32nIuxB7N71JQJm5NIwI/3RaMHzjTQjy1yX5V9SiKMD6/ir2G8tXNHMQugLdpMTgl6ALOxIMrbKOnW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM2jjuX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM2jjuX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484431F00A3A;
	Tue, 21 Jul 2026 18:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657973;
	bh=sU09+7b8zsJ/VXgunYSPQ8+iTbSHiYof+5sxqoVQJ4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CM2jjuX3GInHBt1dThjrVZC7oEWpDUDdKvKiqKJptEPJyJ8oMv5gSy3D6W0De2LvV
	 lsFusV763ieH2b61XxeAQYlJIAEE6+shJhCGwanEO+1GdNEOr2Yb/0werRu2mOhvcB
	 kUMapxgl2Ndr+/x0nbCDw7zHEtMTb+izXDzSIolY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jan Klos <honza.klos@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0931/1611] net: phy: realtek: Clear MDIO_AN_10GBT_CTRL_ADV10G bit
Date: Tue, 21 Jul 2026 17:17:27 +0200
Message-ID: <20260721152536.325730929@linuxfoundation.org>
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

From: Jan Klos <honza.klos@gmail.com>

[ Upstream commit 510a283f4d12367a3f811f382a2c89202954bbd1 ]

On RTL8127A connected to a link partner that advertises 10000baseT
speed cannot be changed to anything other than 10000baseT as 10GbE
is always advertised regardless of any setting. Fix this by
clearing MDIO_AN_10GBT_CTRL_ADV10G bit in rtl822x_config_aneg()'s
call to phy_modify_mmd_changed().

Fixes: 83d962316128 ("net: phy: realtek: add RTL8127-internal PHY")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Jan Klos <honza.klos@gmail.com>
Link: https://patch.msgid.link/20260620011956.37181-1-honza.klos@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 7c3d277efaf07a..05df1a33b0e203 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -1330,7 +1330,8 @@ static int rtl822x_config_aneg(struct phy_device *phydev)
 		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2,
 					     RTL_MDIO_AN_10GBT_CTRL,
 					     MDIO_AN_10GBT_CTRL_ADV2_5G |
-					     MDIO_AN_10GBT_CTRL_ADV5G, adv);
+					     MDIO_AN_10GBT_CTRL_ADV5G |
+					     MDIO_AN_10GBT_CTRL_ADV10G, adv);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.53.0



