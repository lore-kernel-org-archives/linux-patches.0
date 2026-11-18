Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036763;
	b=04w+j0m5fI+DEqb2ENtxTYjabbWmDMBWErl+GXC1acd1OG/FBSl2+TixYWtYwO5d70Bi
	 dPxRViu9Dqq5U7VYrbZ3vt5qsZijfmlUtB2RbX39FThf9ZSnOa+4yA5nTlwFExtoK3/D8
	 4yR98bbAiUH5oQxpjQtlPHzqRRI0o3GksdAI4SzVx7pfj7XPVjiiDm2maR9co+CjmOnu2
	 0qKUxPGmv98gOZgPErvVorjiBdENYDX/jgZbPnpqJfaRVCnTtnsxyZvybLxYe/6dLoxbY
	 7gB1cb7ER/nNMXdKSR3hKD6PhfTr9335xElqLBIZ6OQ0WP4YVHvCIvbPvQqIbgQvrLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=028bRq3bqZGWhC7EGqU6dOyO8H/bUGyQHnUa0h9ie1A=;
	b=z9bzDPUux/OuquNOMM+r84ERpvVB1qAAXdtK+btki3oYI9xwF5tYMYPxhf1T3LDdlTk6
	 hUyud9cDX1iPn6lfdrmB7E8tf3T++qfvXyIvr9ZkC78mbhFmOV1TnAYwKCe8PRdP0hQc+
	 9c0l+39zlSUXHZ0OsEvkBsNhoUwxi2/YqqPekD0QcLo76168BECSnItOurnRhI49kXVxi
	 Rs7nu3SDixVZ5RTDKMHpRL85oJN8x2VA+CLSJO/rNRG/vfEaFE2Yif9fcdkcm95UkWsVH
	 GTgOam3MlAI7Etc40zeh0oE5uEmrp+BrIsCUbSTSHcDTBQ7wH622ONLJxauTpciyH4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxjDiggO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ADD606A320;
	Wed, 18 Nov 2026 21:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxjDiggO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C121F000C4;
	Wed, 18 Nov 2026 21:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036763;
	bh=028bRq3bqZGWhC7EGqU6dOyO8H/bUGyQHnUa0h9ie1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxjDiggOk4BPRedQMiUqkBYQ14B3UVxkwQ9x6TghIJ6QNzt4YsWsDpn1kuPfy9Y48
	 SejAO2C4XyNQApd5aHU/wixX2MTULJ3cybAbVcqcOeOEys9QHnZPzeJO893sO+alW7
	 fm7Twx71gwtEs312Bo2mXTZZKkSrMwHtLWJaImlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1175/3318] ipv6: remove ifaddr from hash during ifdown list cleanup
Date: Wed, 18 Nov 2026 15:29:57 +0100
Message-ID: <20261118150355.382173050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 47ea00e964439..7310af712f91f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3992,6 +3992,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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



