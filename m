Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058624;
	b=q7JFWgyJbqoLcEEBGjtNbjVG+ZulKtFK30EXEbR2Tu8uthLKdSgKBxTjLnRqbYOxb9Gk
	 gnx+oc6/OfNJOl+X8q29mCIuq75ylLKBUOYAEyuBrkPCL4OpBwqKh+yJ4OzgbbMq6EwH3
	 MAxOcCsgFhYbitRjQvzTjpbt/IQraKxJCdyOpfR9tbuObYQu2Ki8sHStlsWV/BFNx3rW/
	 dG+nXT29sxWJUr3qFtcrftqFcyg5PeLO+6G2gYUg2gRPT/gbBKgM7Yj6cTA786gI81ywQ
	 3TJHu+gGm67zgOwPXkHxsFM3IPZnoxFB244k/OkFilFsAzJBeODXflH6Cp/q0w5eGbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uNFFOZjcksHp/cr0ZW0OTg5Cg9OwJbjiEg4mk3mXmR0=;
	b=mlAHyiPrfLfU+Xp1ojCJotd/u8Gwmat5cUYnuhKk6SEqvUYzotHXXwSRjQgAGH6LUT82
	 +quL+AQZzwUj8CU+Bc3YwTzVyWxCfTZ7nF9eAYT9WGXmHqhhHRjJqr/GO5aM8idh5pOGu
	 emz+2R12ySNvUCuzm45M3D9bF7+fWVh3oKcAQVZSJ0z6LHY/z0nIa6f6kDl2tkiOeEbzC
	 cPNRaDlTaetaqScfZhtjs/OP/vADhoG+ODONCfuuhDuDZzrQBpi7/j8LjiL3rWz+u1LA3
	 Sl6UVYc+SHtytJogG53oJTLUd5e5kDzBePdtkxAYAqpnu9pDBERZjTCI8xqZjrVjBNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cKUksDbm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC06606A31C;
	Thu, 19 Nov 2026 03:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cKUksDbm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD8E1F000C4;
	Thu, 19 Nov 2026 03:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058624;
	bh=uNFFOZjcksHp/cr0ZW0OTg5Cg9OwJbjiEg4mk3mXmR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKUksDbmJkq+iqnrnwAwCdVp2NrTtW8TTEczC8zdOdDtTmUQoq99oNZR2zs4nzo83
	 IEV7Rpn2d9UmV7mrfcWvPj63pnn6HTUArNdMdg0b91ceLIPKcPae5B6YpGpdy554Ad
	 LlDoe5BSonFl1yjqu6O8qJIuceZXxvqgXXCiLRQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0552/1848] ipv6: do not restart DAD for a dead ifaddr
Date: Wed, 18 Nov 2026 15:43:10 +0100
Message-ID: <20261118145938.040833755@linuxfoundation.org>
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

[ Upstream commit ffb668669ce4144347973d8b2fad449e9be0563d ]

addrconf_dad_failure() can create a stable-privacy replacement without
RTNL. After ipv6_add_addr() publishes it, addrconf_ifdown() can mark the
new ifaddr DEAD, clear its route, and unlink it before the recovery path
takes ifp2->lock.

The recovery path then unconditionally changes the state back to PREDAD
and queues delayed DAD work. The MTU teardown path can leave IF_READY
set. For an optimistic address, addrconf_dad_begin() can consequently
pass the cleared NULL route to ip6_ins_rt().

This follow-on was found by source review and was not separately
triggered at runtime.

The new ifaddr is already initialized in PREDAD. Under ifp2->lock, record
the retry and queue DAD only if teardown has not changed the state to
DEAD. If teardown wins after this check, the work observes DEAD and exits
without reviving the address.

This complements the existing lock_errdad check that preserves the original
ifaddr's DEAD state after the same function reacquires its lock.

Fixes: 5f40ef77adb2 ("ipv6: do retries on stable privacy addresses")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/r/179161099408.434549.14449036924552933828@kernel.org
Link: https://lore.kernel.org/r/20260513025509.3776405-1-lilinmao@kylinos.cn
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-5-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 41c2651dd1d39..0e45127b14cdd 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2130,6 +2130,7 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 			     ifp->idev->dev->name, &ifp->addr, eth_hdr(skb)->h_source);
 
 	if (ifp->flags & IFA_F_STABLE_PRIVACY) {
+		bool start_dad = false;
 		struct in6_addr new_addr;
 		struct inet6_ifaddr *ifp2;
 		int retries = ifp->stable_privacy_retry + 1;
@@ -2168,11 +2169,14 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 			goto lock_errdad;
 
 		spin_lock_bh(&ifp2->lock);
-		ifp2->stable_privacy_retry = retries;
-		ifp2->state = INET6_IFADDR_STATE_PREDAD;
+		if (ifp2->state != INET6_IFADDR_STATE_DEAD) {
+			ifp2->stable_privacy_retry = retries;
+			start_dad = true;
+		}
 		spin_unlock_bh(&ifp2->lock);
 
-		addrconf_mod_dad_work(ifp2, net->ipv6.sysctl.idgen_delay);
+		if (start_dad)
+			addrconf_mod_dad_work(ifp2, net->ipv6.sysctl.idgen_delay);
 		in6_ifa_put(ifp2);
 lock_errdad:
 		spin_lock_bh(&ifp->lock);
-- 
2.53.0



