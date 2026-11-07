Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065166;
	b=Go/LFXfWidAaawzfe/EEuua5aHbW0CPIfRgsJYVWWvCp/uOEpu/XaJ4FhgytDOmcRSNH
	 qaXDgWb8z1A+D45vi3mA34IRrTXQZafvuKV47DnZbde87xvCbEeV6Jp5ptKtlkCsEiea0
	 a6/0/KsZMvRrv+xqN4GnhzOLoV8jvc8BnNTuIyAAFl7gut1pFsgJUnUuHcKgYUgoo824v
	 oYwmyl53HJl9i29iJYa/cVptXr3ILgLS3n5aySwnLzzQMLf4Y6le+UnKZdKGvTtm/k0Vq
	 nqh2LhH/l2yztcrnAGwGSn7bISfmEOMbI6C9jLy6und+xt5RvKhl02uCQgEuURV/1Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sd3cPaLApvwl6UVkwCKBGohbuH6r5M61LFcWotF4nKI=;
	b=myXsY0BRovObMeI0iPNpOarU2c6FLtIblh0lq9ddFNrI5hHvoMiIg5NH47oZ2jaY0wIO
	 ZcUETqKuXsBwScb14BJgQ0ruDJQPJjeJYRRLuRKEiA6/NrLBMkbW9OQ8Zk0NMXy6vX1KC
	 NlxZe3Ox3OQyktPhAO/ffVkiMd6/+RGt6nDbzwvCro485oQixRno0zXcrlNx+2hgAJEkg
	 SptkZYIkUQpbTTtWtwVBIk/9w6wcxAcL1U2DNlsDKC7rC5GLLgvnpJ9ACp7EZlQ6F3/uo
	 a4ikSxDWfYmXwPqk96S1S/o0hNRFmvFTgNsvstRCDQ0veXbYs3KHcechIDEHlD4JG0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GD9GM+oI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319E7606A331;
	Sat,  7 Nov 2026 15:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GD9GM+oI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD5B1F0089F;
	Sat,  7 Nov 2026 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065166;
	bh=sd3cPaLApvwl6UVkwCKBGohbuH6r5M61LFcWotF4nKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GD9GM+oIa3AGhJND3cA/X1XDZrLPDiVlIAB8FUs2PObGiSkbGg2PvfDFJoVOanRGM
	 aG83349WOsok90qBfEXkHR/0nxLzW2y7xqMufe/89D7EjjYzVlYOVgbWcCqNrO7UV2
	 2l8zCimPNO7S+4PhzwoKrZS6FLZyAS4X3ojinuO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0971/1257] ipv6: remove ifaddr from hash during ifdown list cleanup
Date: Sat,  7 Nov 2026 08:54:27 -0500
Message-ID: <20261107135006.175741579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c90ee6dd7446c..72d7df23f7967 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4019,6 +4019,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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



