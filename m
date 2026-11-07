Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063598;
	b=kPsLkeu7vqwCZe4j+TxNgWwhKi7Pdkbn9ybHdKT0+8tU7o9BJIaZ18F6aTlDiYh7P18h
	 ELcFOyyDVFAZ/ti5plsqpOvM2l64wHraK3KX2xkc71NxIQQT5DyuKHJbB3TEgB90ZDrZn
	 g5yQu+50FVsnMX27VOBTME5ydr34G98vfMrqIg7p4B0UsL5GFeQaQxd6ihcwNhgNiatCq
	 sZa5A4ISAB3RwhYU5cvOU3aoeQUI+c0/2OxnxYa2tV9wCnmY5TxoVYkCfKVSlvs6aDEz4
	 LkoqFN3xKiL3nFFbczLKWsDeUvCTM4lvWKwhV4ga4ikNA8sTv4JmWrCRqtX/XySTsxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a/OqVThHrXV+EGINJY6Lbn3V45ZbQ142a/Vg8kFKFyo=;
	b=mANymZK2lbCT5p8RFfwYSRCxeuSVHRU5S/AyNxRISEA52SvPOuJtcqLSgsBi1Ls7Jqg6
	 mLYgSjE2U6BX5sYHoZyU6Bu45BNp7TJ2aOtH+/plOucQpU2lCmDJ1VNGR2WF9MT0FBc38
	 3GOxVpibA8aQTxhId5ArtvQJ0jxuAk36WryU+64Q6UgJ0UX7r/8w/hV3mR4Z6w9U+p4TO
	 Z/TM+bf4SauikkJb3Vywhcs/yMzkRC82q4sbcOeijIDNrP2M5H+t4NjzqTSRXKtpdRG+j
	 oUwa4tiKmYMnQ90Kr+3jZhpgMmGxM8Zlz63Zs7aatOHbsy6mN5/idWE9ELG5b0QwjyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4eKVc8a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F5C6082BD5;
	Sat,  7 Nov 2026 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4eKVc8a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951A21F008A1;
	Sat,  7 Nov 2026 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063597;
	bh=a/OqVThHrXV+EGINJY6Lbn3V45ZbQ142a/Vg8kFKFyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4eKVc8a4Re+BfB1JBy0xfk16BO8fR8OvvxoTToPePCKzPoepwKYcYt7Swk5Uq3mA
	 YRLoEFKoWQLsTTv1wd0i7s+iy30v4f8z38xQDwt2D1mN4g+NDJZcJbcRosPyc0Gb/A
	 7G9j17GeVE/a29Obv56uKfEF2WQH4FT+xIK468tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 685/869] ipv6: remove ifaddr from hash during ifdown list cleanup
Date: Sat,  7 Nov 2026 08:56:07 -0500
Message-ID: <20261107134916.267583264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 81f5bda2a89fc..067d325291b9f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4006,6 +4006,10 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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



