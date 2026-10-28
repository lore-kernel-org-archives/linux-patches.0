Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215766;
	b=Gc6LtI0O0OSnM+nP/gBWprxPepe71ZHtjZWHLMzHtGyU8iEayulC30rbWrdUg1v/c4gm
	 mOGWGALAFDeEBTWwqRpmWINZ7RCT60T6L85JX6IHzN/YRkUmDAKJdGaB5XzEaniRYEixs
	 qEYC1345VDf2AGpTHaj+Y4o3dZ4yKWdTXHS4W62HKquPrex+7TODpwyW2falYgeTsQXaE
	 ijRzF/YRaLwqFBKUrddAfxCygvIipsjFUUw8lxM1cxMyPmHv8Z+2q1Nzte+zyJBdg6Hn8
	 MspBfYyeOlmi+1MbXLsXiPsIkz6JWbQDVpDiT+H2GsorakCrSiBrI6YThyfSWtygv8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MFbn5zUS11NgJFAyepvgx/VSVwMONsn+EoNdvVVji6s=;
	b=fYOUpDuM67VStqDgyiAzsE5JEZfVrIGSS/jN9ej3KUywpH7Vouq4ifR/nR5Pu0/977W/
	 wulKws+qVKs695EZq3/uyzL45S2HtPxh5PpM8ubHec++GYUGc4Vpj8re+Iyn+2H2ARCZz
	 nsyT9/GItOA93hiRuQbU3ZEXv4STtAbpPZ5i718V0gOfsOzHN9mQIscuWoXFyCGObOF1I
	 OV/b1TLTfwF59Ckxr00lgoaD5q4BU6su73WGBXCptoIxaP/Gfvo+w90ilb7NR+P94qdBf
	 jB0fxEMhhHkI8i0ydT+JMYIB7SKQnb700rZruLGR1DEbdkdoCRaJ4tVzxG85z7q8B3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t8dW762/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA0606A31E;
	Wed, 28 Oct 2026 19:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8dW762/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493E11F01825;
	Wed, 28 Oct 2026 19:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215765;
	bh=MFbn5zUS11NgJFAyepvgx/VSVwMONsn+EoNdvVVji6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8dW762/ypTzZzZVRrY0bWly4lpUgZJSkinbm6KjJhJTPM4jiKHBgrxWmrzPr5Qqa
	 iAiIfaGEFLcQ+slYMJdr3vja1nnm1cKVGMLT0s8wn0MDNEgNWUCxDzpv/7DrvosD6R
	 WYxtUpB0dkdQlI1x4NtuuL0a7dDsNAxJLHEJgy2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e0bd4e4815a910c0daa8@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1318/1887] ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()
Date: Wed, 28 Oct 2026 17:56:54 +0100
Message-ID: <20261028170529.422350007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 0569f67ed6a7af838e2141da93c68e6b6013f483 ]

It's pointless to call WARN_ON() in case of an allocation failure in
dev_change_net_namespace() and device_rename(), since it only leads to
useless splats caused by deliberate fault injections, so avoid it.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
Reported-by: syzbot+e0bd4e4815a910c0daa8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/000000000000f4a1b7061f9421de@google.com/#t
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://lore.kernel.org/20250403101935.991385-3-i.abramov@mt-integration.ru
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index b3b89a1cd2a4c..a5b1795408831 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -206,8 +206,10 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			continue;
 		wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
-		if (err)
+		if (err) {
+			WARN_ON(err && err != -ENOMEM);
 			break;
+		}
 		wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
 	}
 
@@ -223,7 +225,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
-			WARN_ON(err);
+			WARN_ON(err && err != -ENOMEM);
 			wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
 		}
 
@@ -233,7 +235,7 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	wpan_phy_net_set(&rdev->wpan_phy, net);
 
 	err = device_rename(&rdev->wpan_phy.dev, dev_name(&rdev->wpan_phy.dev));
-	WARN_ON(err);
+	WARN_ON(err && err != -ENOMEM);
 
 	return 0;
 }
-- 
2.53.0



