Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741D93B9D9D;
	Tue, 21 Jul 2026 21:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669540; cv=none; b=dW4PwOaEK5KXzgTjfpBCJwZV25S1U9N5CAvVBZehcmfA4w8uqqfbsq95gF9Vk4serNjD3tnLN9j6oThH7uZT7PnTBcUo1HFeWAEWnAyPoeMJ8C5elYhoS8x1F2d3LZMIS+AWqclCobMEm9BviYx3HPBhcGpj9b8OdTwo0Y5ihV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669540; c=relaxed/simple;
	bh=VFiCika2OTRJ4XH76lOMcsxLgkaua1DxlR2MMdkF/UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neyy0Phyvx8sUX9Fzsp5MjaW/VYW9RfhscX6VLZYW6Pw6Mm94UZOCy35gUgxSzPcds0uVRTgCvflRco1Nihh3lEuTkLfQF3lkrBco2/DrD5UDppksijOlSauVGxoX55VL/gYD74WBN2s7RNn1uk5WbIcO5A8bsZxm1ztM8vffMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfOaW6vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfOaW6vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0791F000E9;
	Tue, 21 Jul 2026 21:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669539;
	bh=JLJr6+II+GnI9bXmLdlQ8fj2vqsizZa9C9F1Fzwai60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfOaW6vzfKRge6SfIyrWOh4TDkbrb8R9aJpuywz9TQRqtd5I0IQnoQCpDTnYx9Gwt
	 NG1SJlH3ALH1EUZtOyTZV0MlBhrhltmJLydIp8D+tsIhNEBT3xFeS6w7fCQnX0h2zT
	 Uv2SgNfWexSDaPzhaJ4jTOEU9k4GaOrhNzZ85GvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0592/1067] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Tue, 21 Jul 2026 17:19:53 +0200
Message-ID: <20260721152437.847847947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



