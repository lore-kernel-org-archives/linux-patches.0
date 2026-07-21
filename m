Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7506D46D08F;
	Tue, 21 Jul 2026 19:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662820; cv=none; b=PfAt8Xnndnv3W9rYpddVQclfC1mRJOGNimYjUfC07j1s0z0RcaNcyGgzviiENTPHGhy7HnUgJQG3VmVFjM/PXKzLK5y7D8uF4rHFZ9ApqshY+YYjGM8CsRmd8+ATipIuceP54AWOWbkDTqqxYUl7DfBeMIDYc26bC8qsNsg8xOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662820; c=relaxed/simple;
	bh=OONrPJgjqjJmBJfdm7uaigXUMuZLwyLA7fSaBvCK5e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMerlXRcJo2ao5ib7OGHPbszoxf/fUvYyQ8ysG87enPzxq9XGxZjmHMaxVMoszxhaRVOGaadmmIstY3YPiZFztJwR87Mym2D9tW+jrgI+KAI18bOOZDnD4eZ0xdmwO0FWvHm7eeqyXTueEaviWakE/eTq/nNlSFYk/8Tg1zjgbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slcpKZb/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slcpKZb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB34D1F000E9;
	Tue, 21 Jul 2026 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662819;
	bh=5KpTnRsVPP1CAqU7JWuh5FxUcDRHLmRPM96zYJ4PPo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slcpKZb/ojBrc5VlmgpTObJammWdyGO4h9SzGKE5v0iJ6n6xTHJ0g3kwGrX+e1VWZ
	 WnrAVgUjemVE7HFEeDnI1dB33laNOScOC1jOF9x2WoLgPSYvUfGUa/4KWFEpgmSx80
	 1osuZqmfUmQM0aa+OTFvgtLV4VYGlvZtmFzHSjUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0588/1276] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Tue, 21 Jul 2026 17:17:11 +0200
Message-ID: <20260721152459.274067910@linuxfoundation.org>
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
index 88adb04e407220..4a4379c828b90e 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -351,7 +351,7 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
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



