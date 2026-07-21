Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED7D434E2F;
	Tue, 21 Jul 2026 22:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671991; cv=none; b=pqDRRAZTVRhPAFbtLW735xPO55CkdRv8B90gcLd1u5Xy64mYMWQ9xZ/+xeauoCgI8qlLeTDkvtMfV7xzS8xVICBKUorKrzGR3zfrYWyNRYn+ondVjr1s6tL8siYNb3l7PKkjaLOhzuM8eOYD0iFRdpyXGYCVFZbpi39iksRrVeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671991; c=relaxed/simple;
	bh=1OwBTluB8ADGnilLaXIUxLmj4cUdXEfIDAXEYhnBVTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqRcJWROIwbqa4pXoHhoFWeKEl+SJPZE3+9MqlgT6lKib8Y1rH4npYZm5qQt0zt9m/3+/Sp9c7BmgTUdr/Ij0SSe/VM31e0QqRIOjumREzJ1wdNBvVwg5XKGvNUdEkUmeJZltoWprB2Kce8oBJlMnmtm0P5NIaVTY/lS+0q0Y/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvsWMrRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvsWMrRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C8A1F000E9;
	Tue, 21 Jul 2026 22:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671989;
	bh=OKFipephcxFEaVa/euQaF/fxDEOuCaRMaTMsvyzCaYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvsWMrRkr0Wje9dC9lZxPLBt9bjyde8CZccifzE+fZ40Kj5Meca7aIDPSvV3jvZ92
	 waEBp9ttKk571203gwGV/nsYJcyQ3Yd8W/qDsqWG7RHyB39kS8WGo/lKl2kO6QAedx
	 hQUiD/3+Apcbee7fRg0fgX+glYwJtTxSYZgSYCfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 448/843] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Tue, 21 Jul 2026 17:21:23 +0200
Message-ID: <20260721152416.106503986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit e69ed6fc9fb3b386b5fcdb9f51623f122cee2ebd ]

There's no need to call WARN_ON() in cfg802154_pernet_exit(), since
every point of failure in cfg802154_switch_netns() is covered with
WARN_ON(), so remove it.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://lore.kernel.org/20250403101935.991385-4-i.abramov@mt-integration.ru
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index de259b5170ab17..b3b89a1cd2a4c1 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -324,7 +324,7 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
 	rtnl_lock();
 	list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
 		if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
-			WARN_ON(cfg802154_switch_netns(rdev, &init_net));
+			cfg802154_switch_netns(rdev, &init_net);
 	}
 	rtnl_unlock();
 }
-- 
2.53.0



