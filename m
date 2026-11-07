Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062485;
	b=jzQK6qaOY7Gl2/puFly22d64wiAyrCGTm4gMBRILd8ZjJJ9rvNK9yapFr0Nq8aJq6LfS
	 sawnnUDiD/VndA6HRCla0HKwLezXsWuAC2cTcWnVgyby2MUEFZulQTdl+BixEehpC74Vp
	 74qJ4Z8Uv7hi22A4d3QSBPf5xoTSOG8dxiiup/O0BFfPPtSx8oHgQxALqDdCGhGz6cOVQ
	 HhL3Phsf4z/qGDq+WtKh7HxVQdbBURzLUoL4XWrjE9yffHxOW5brn6t6SaUWCgDYt13IW
	 YuQ+KslwcLtL5yq5/swgPX9zpct2hx+Tv7aX6fxaIkjoLmVtA3F5tyBUrS+MHxuCgnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B+yq857aJ9I7HYkLg+2t+m2PUGTz7OEi6Pw5nZhrgvg=;
	b=ebVN3JeAr6lqIbWLcbVva3GxoOpQchm6tbgfhLc1Hm/AGJc2X6biACL9g/rqfDziVVII
	 H6A20m/wwPKbVktOlzyhr2kMlKwLPEusR2IsWPf8tYKoDI/rJL1QLz8w9WXo0rJ2yLoa7
	 6J7sNxAXzECHs90ezBWsC5uuOTvXmQEQKjcGbgq93hCLLN9Alj2hAp5HiZ3YTrsrenE/x
	 XoV4WnwlGnuoO/NuEW/COPweah/LEA7eLnXEc0J7uweljCYEYOoRD5iabz6a7HCozgz46
	 ilSzGxC8CP471/GBlXuxp6Y1ve4IFbNRAnPf3o8xefx7dv7flY5XKH8xD7GiR51R8oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDF2u6xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728CD6082BC3;
	Sat,  7 Nov 2026 14:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDF2u6xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213EA1F0089F;
	Sat,  7 Nov 2026 14:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062485;
	bh=B+yq857aJ9I7HYkLg+2t+m2PUGTz7OEi6Pw5nZhrgvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDF2u6xn9y8EIlfWTRa8df5LKk55VPVaB6vlKjuiZeH1I9h1TEhhDFh7o+wty3LBc
	 YulVOTs4yujyvefT8zuQDOTgkw/89LXZVjo/rFHE+Hjs10t98fxnsRwUo6vUzLSv/5
	 35PDIiTV9PE8mq2t68g6yaYN6PDVv2rIcdZMXHDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1386/1536] ipv6: remove ifaddr from hash during ifdown list cleanup
Date: Sat,  7 Nov 2026 08:56:42 -0500
Message-ID: <20261107135036.758286703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 6ace56ed7b13a9c6d4cb7ef0d82d3a3d53324a63 ]

addrconf_ifdown() clears the address hash before snapshotting the
per-device address list. A concurrent ipv6_add_addr() can publish an
address after the hash scan and before the list snapshot.

The ifdown path then removes the address from the device list and drops
the list-owned reference while it is still linked in the hash. Once the
remaining references are released, inet6_ifa_finish_destroy() warns, but
a DEAD address continues to kfree_rcu(). The hash therefore points to
freed memory that later RCU walkers can dereference.

This follow-on was found by source review and was not separately
triggered at runtime.

Remove each non-kept address from the hash immediately before removing
it from the per-device list. Keeping it hashed through the delete
notification blocks same-address publication until NETDEV_DOWN has been
delivered. hlist_del_init_rcu() is safe when the earlier hash scan
already removed the address.

This handles a late publisher captured by the list snapshot. The next
change serializes publication with teardown so an add cannot miss both
observations. Both changes are required when backporting the complete fix.

Fixes: 73a8bd74e261 ("ipv6: Revert 'administrative down' address handling changes.")
Cc: stable@vger.kernel.org
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20261004135117.GA206930@shredder
Link: https://lore.kernel.org/r/179161099539.434549.2238120015372268173@kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-2-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 33439672b071b..d7865f915d25d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4025,6 +4025,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 		}
 
 		if (!keep) {
+			spin_lock_bh(&net->ipv6.addrconf_hash_lock);
+			hlist_del_init_rcu(&ifa->addr_lst);
+			spin_unlock_bh(&net->ipv6.addrconf_hash_lock);
+
 			write_lock_bh(&idev->lock);
 			list_del_rcu(&ifa->if_list);
 			write_unlock_bh(&idev->lock);
-- 
2.53.0



