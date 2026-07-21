Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C90356A12;
	Tue, 21 Jul 2026 20:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666682; cv=none; b=BMP6Z32X31CgTsVaBsh333Ki0UH/ApZGvgaqbwvfRUEodFW9BtQjKMIVL3RyTk+iUTB68sXF8MikqcFxSGzYjXnsbO1odBajsPT/srBbaze4/KO7CJ1xF0/0pZsHF8k4SqQZDNIS4tVxS1FXZz/bSp1ZGlJikXNb+aZ9HmrtK2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666682; c=relaxed/simple;
	bh=p43H5gFWTQOx+9LVcYCursoppEyTlmsjb60Ork5UVo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/5MzH5NgJrlpZOFW8maK9XX59O6g0PKgXm0HTgBeGLesLAh1wT+KO88/AXpZe3VuaTrjJvngSMNHOLLBBX3dIJiKlLFISeEneEUMY7Yq2RG9x4tGIhEUwKAetK6xzeoQ6tfCRLiAp40strcqUP/0MSng4BpYhN5wRQmVHjUhO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNI5T3YZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNI5T3YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB501F000E9;
	Tue, 21 Jul 2026 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666681;
	bh=iV9IcFq+hasCSXHNMGcAoybZ33J51qvmGsYLoooJw/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNI5T3YZC04furCceosEfgpKQRGXIW71ZTr3djQFfzZK5QGTcILj3j8mL2a6z1IWB
	 Zbj9NaFax0Sm5B5wfiH8J1Pf/GxOnCciCtT99l5b3QY0pzQwAvZ9Tpm2SCCmzKsUUe
	 oIeEtwlMpAE1Uusy/CYdKVPn3dohJ+n0JGWaDG6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0738/1266] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Tue, 21 Jul 2026 17:19:35 +0200
Message-ID: <20260721152458.387108403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 57546e07e06ade..cdf4b41c54b2b1 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -327,7 +327,7 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
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



