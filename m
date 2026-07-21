Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB313B4EAC;
	Tue, 21 Jul 2026 18:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657612; cv=none; b=WwX9yukqy0AY407/xBqEUi2ymdyJkNfarRANaz3FE8micAMdREksqEvVTDawH/GJd4Zp/pfVqqpiK/TQ6oLXkVDmmzkIwNTyjNagvTWLlHfhTRtuLT34wheUnTdQSHYuJeCLHacrdF+VyLtz6jK3ntLPkzOF3646Cd1q5hVhC+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657612; c=relaxed/simple;
	bh=orfMqYTSffDDsWPvCQhHYO3JnFqwEqfNU33YYzVqHIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1+3J2JVvAA11IX1i92i1Eh3+xlj8PxNgA9vDf4dmdEoRRBjolJCRHyeCnulrJAru1nvL5/Ur786h8yKh+c0QYq4KM+MeEaI8m8cfjUF21cF4MLSjlqGC8mfJVdwvL7mX6mWjkXNML17Ag67g9245ff8634b8M3SW0vXV7jflQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8q9S9QF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8q9S9QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924B01F000E9;
	Tue, 21 Jul 2026 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657611;
	bh=Hr1L1gZmXzAKzrSqEhMM3UehHSHz9QTf7QsfRJLi+2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8q9S9QF20vHteACmvOXQnYdNWvAEUWCe5vt9yNcX7DEJTqER2Q4JKnxPRu9RvG+x
	 uqEZrrZqN0Bvtt+PaGZWIqgIedFxAAmuzUiXPmhedS24bizsVAGlh6Tnkyn2lxL6OS
	 S9q5FD45uScK/Aj3RygYBNJqu0fDOxU6E+yD8Zwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0828/1611] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Tue, 21 Jul 2026 17:15:44 +0200
Message-ID: <20260721152534.012974313@linuxfoundation.org>
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



