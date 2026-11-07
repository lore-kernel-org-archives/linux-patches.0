Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063603;
	b=WOkul8t+YSBKxHhDVsxExYp0FpF7HbBWF1ygMprnNl54ikekiciSK2AD16wdtASELOmZ
	 WYXzmj69eV3LOLCxO6pnjZZY6KigxcIlBjWlT4RPHsLGjWJcp/m7PYxLBtpZNksPNs77n
	 c+EtvHbU5hmVNs3yvrTR88RbJLDv20XGgRsdja4l9wZIGe5Wm6aKevs8WDA3/yRZXKDlW
	 uCtlfldjpUmT1I/UaVZqXe2JzWrjN0nBHqNmPVdUWXWMfvwY0WZlwq0v4hkAPs83G5a0+
	 w4N+d9KL649qVNEH6wNzlWE6Qdbo7MfuSj0AYpIBUp3Tm0hOYSkQwNKMt62TUwu9eIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mkvpaD/j+cX8GhZiqjJBQcmvKilPS/tIFrKxQMHRLbY=;
	b=xovKRUvaq3FdbD+Gom1qqhHAgf9JoHEwGCqmpo0YJUkPf7JA+qW+ecJitInkCE7q/5Z5
	 crIiGZOTRqU5a7CoSs64s/8PYBmKAVUUldf5pCo2tAPzQQRwBwDlG5teqcPgMe7XgEPz4
	 6B1LRtYJB7mlAyjJbalE+pInt/7BCsCO0qMPZ6V/DNa0y2ABTzcoZp1RbhFSEO2QZHFBz
	 9WcVYYvdqmvrONdY9LlzVMt7aokAq2X0YJCcUr0WQSK0ry1UyUa1GJGJCx+DGUwcCe83K
	 tdXVNhxIXZb11oYEP6LX0E6mEDCT3xIrRMnmRo7fuK70sc9K1W3LHxHngGaJKN4pNXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWtRhzAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FD6082BDF;
	Sat,  7 Nov 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWtRhzAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060CF1F0089F;
	Sat,  7 Nov 2026 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063603;
	bh=mkvpaD/j+cX8GhZiqjJBQcmvKilPS/tIFrKxQMHRLbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWtRhzAmP8JcaE3f3Mz3L/tf9+A9t75kwGp9O0c0u50/5jZUUnSkTs5ZV9Cnis0k2
	 ArSaJ1NkP2KdIdYW73l5t3PHwhTziqKQwv3BmKVTxn1BhiRVHFL0Bd2c+NSM2Zu7VA
	 m8bGXZQdwZf1itMA+TTijrxQ+JfPOMlqovu0/keQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 688/869] ipv6: do not restart DAD for a dead ifaddr
Date: Sat,  7 Nov 2026 08:56:10 -0500
Message-ID: <20261107134916.352990789@linuxfoundation.org>
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
index e277b78313686..527ae9fc1c41c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2198,6 +2198,7 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 			     ifp->idev->dev->name, &ifp->addr, eth_hdr(skb)->h_source);
 
 	if (ifp->flags & IFA_F_STABLE_PRIVACY) {
+		bool start_dad = false;
 		struct in6_addr new_addr;
 		struct inet6_ifaddr *ifp2;
 		int retries = ifp->stable_privacy_retry + 1;
@@ -2236,11 +2237,14 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
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



