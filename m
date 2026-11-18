Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059794;
	b=ZSEkQIYfktfK42JH2EHVp6GDGAiQPLTXFl5D1UfXq86iTps00B2DHGAQrGAEAfe02DYU
	 Jn1LtZj4uE/zlfxC0JSiZX0/KVKY47zc7kpAN49XVb5ILTsx2Bk7WWvELKe5KRjTRbJij
	 VGy1t3XIxyfHGi7vSH/CXwItfeLk4ckEw45/dZCBy8zpV4G5ZV/DO71jaAwcCI9NUIsIj
	 XPq9mA9ZESgYUnvQc1m9D/vaLcItAifOm464TEKGUFq1INPny4fxYe9ayiP/AxQtq5Pcg
	 Ml77Vli2Ae+aw00Mu1E/hFEVLDcN4ntP94QV3ESnQZSlhv/09H5epDDq9KpTca/tOeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5GFebXB1jE5S8vfyXwIrmQ3rsqylzo8I7I6K8iIXZY=;
	b=I7BdICzsz95tQK3c5JZZDNKJljMkUd2y/DuqsphRC42ee0tXR2rybbqCRNoMmuhOFvrI
	 bxO1HLsZ1e3PKmNP8OVuyCSzEbElTumE/YKo606k894PZaSOBPf4qjzqDFi8IrBpGT2fe
	 TH16wM/F0uoXUclqaQ5Xpw68AoXCrt+rlTRRTnC5NfS6pZ85167Arcdlr9pca2AfmzuZm
	 h4rNatxJygSVQ/cCx9Ti8Hwd/e1FSdy9q4rEM2lN1ckwrwvH7Hh6IN4usQluWQAAYoDK/
	 jypfDHuGhkqWPMO37Gc0/oFK28yJNECB1e6IQTfTgBJ9VdavVaTEzypRsGXcCJgKgVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fURxz/FU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F28606A330;
	Thu, 19 Nov 2026 03:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fURxz/FU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBE11F000C5;
	Thu, 19 Nov 2026 03:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059793;
	bh=d5GFebXB1jE5S8vfyXwIrmQ3rsqylzo8I7I6K8iIXZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fURxz/FUOcT1XiXHNkzZLHsKFPcWY2r++iWtAuG24/YBObr+QlVIg8cgDEgMMixPT
	 izjFPxlGaiOx4JX9BvcW+vLUrfVovHRMPOtE6ajT1oyPBN/GAzcnM6fMuHJEr4F4/8
	 IH9JB5iWVgLIsl1vwrdpTqB7eL9ZPwZRk8qHE0jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0968/1848] ipv6: remove ifaddr from hash during ifdown list cleanup
Date: Wed, 18 Nov 2026 15:50:06 +0100
Message-ID: <20261118145957.479910129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8429bd481706f..ab65da6e63175 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3909,6 +3909,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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



