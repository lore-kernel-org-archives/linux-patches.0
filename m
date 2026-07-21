Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF1386C39;
	Tue, 21 Jul 2026 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660860; cv=none; b=OcU+zhv/Q/M8wnpcxdz8/hfQus3D8GXe4vcOQLRncIipgHYk9/ayh3PhH88ZovsTNafGwHUlGcRK6jqWymq806hWZKGgiBVHtS5Vr8UN41dOXtHR515jTYkhrDiLowL5rOExRpSLNRtwPcnC0kbnTRnTU4jhW2SIJ+45y5Y+O4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660860; c=relaxed/simple;
	bh=IdVwdF+oYXAicqqK5d5GIxlHiq6Weel7Sf8sxVsei/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+lSPOj185/UZ4byQccFjuRHq5qeLCbf+Nsa24B6WnFWFjAuHrbhRHFRK06YSb88P+OzaDW+/Rq/KABjxZn/SgnHAHkR6vNmftXq7m5LEq3D+7eKZ0MqP+4Hu+uUrkeB1M4xOHRg2tDm5XsKoEbjT/KDA319AGhvIUecI8wGrg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bfgdc1iq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bfgdc1iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E30C1F000E9;
	Tue, 21 Jul 2026 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660859;
	bh=EC/f3u35t3Sfe6z/rmLT7VLisQ2D2DcJMtjXNQEOhCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bfgdc1iqrnudpk3PrXszEco465DSHJhDgGeuzeH3XlDLcFIp5wPadh+NkELX3jiUW
	 98MjKsz0BlmyHM0IuCCxi99feHKZWUvriYiIVdN/SRBGfCmdPYU/Tr0PxSM/a/nKaF
	 rAFKgAyAyEl096qxRZeAg4tE/ErhV4E/6NWoy1Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1138/2077] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Tue, 21 Jul 2026 17:13:31 +0200
Message-ID: <20260721152619.662344253@linuxfoundation.org>
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
index 987c633e2c549f..c0b8712018a16d 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -358,7 +358,7 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
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



