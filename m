Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052932;
	b=39v7oDH1vgZDZEnOuxZvJ42m1/iZS+pCJS1g29v/BbXs6UzId+QXMOMSBjHPAyPLOK/V
	 bovP2vJxdMz6In+yCFCHzZvqf/sgE5DJm2mOq08O+0AP/TqUrOKZHxFL5grLREldlIs62
	 /uOWK9hL4YUNh3nnUc3vqroSpX5CuQcCJQtgOnnmdWW5684n/lnWxPCViEhc2BlNthqkL
	 MhSXiP5nntJymOpJbIysdCDugyde3v1FhdZb2USsBLH2y6t0gz0vu+Hz0wXXZfNYVdbaN
	 y5lBG0uoPx/R2tjCV+9Cn6UuBM6UTO0HKlJyFiHkFKFyU7LwNHQub80Qx2ofQS9J6aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aha8x344t9CYPyzi1pvgRfazQW6pAqgHTMKRLEyPaz0=;
	b=ABIE9IuBTWKpeKmu1wkXgGpsE3SBvD1EcN46VoHPo0cgCCHq4WsVytFIy60anR++RvQJ
	 zj+jJF6/Nwq+l0G4i9VzKMFz00jYd1oOtKuXnjcytJapsrFif6B/GN150vuCpuVxAs9ax
	 sUvPc9J/RXADqMoqlr4QuW+dknubJnyDsW+Tk1178SJG2PLl9FcmfPt/gnEuIx1fy7vED
	 dppZFeXY1/OxlqiDAOxff+XkL2drHZ363mzRudN1//nlxEPm1aa/lg9mFpt/V3wjYgoni
	 eoznlb34aBQn7F2+0IFxs0mbfGmMhCt/kgFUppFn4jofwp71EeQRz/52ahYU+6j01iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICQXJmIK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5A1606A325;
	Thu, 19 Nov 2026 01:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICQXJmIK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915071F000C4;
	Thu, 19 Nov 2026 01:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052932;
	bh=aha8x344t9CYPyzi1pvgRfazQW6pAqgHTMKRLEyPaz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICQXJmIKhreAwzWAo9ho8x9WodV1WxoRspofWLgV8pMdHzXagFK+0EgS5SfkNToSv
	 fw/jyHq/QJ5K+oYl1T0rFFD2XbLI/F4BKjtOakj4OU+S8TJWWBYjD+bQt6+G/FkA/r
	 aJxOKBZzIgaTiKlWU7PvT8Gt/7CDr+oXikoOe/88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0679/2214] ipv6: initialize temporary ifaddr before publication
Date: Wed, 18 Nov 2026 15:39:15 +0100
Message-ID: <20261118150038.945745834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit ed7f278812e540db507f683e5bf9b6d0a1f5bc1e ]

ipv6_create_tempaddr() holds a reference to the public ifaddr, publishes
the new temporary address through ipv6_add_addr(), and only then stores
the reference and final timestamps.

addrconf_ifdown() can remove the temporary address before ifpub is
stored, leaking the public ifaddr reference. Publishing ifpub alone is
insufficient: manage_tempaddrs() can then find the object before cstamp
and tstamp are final, update its lifetimes, and have the constructor
overwrite its timestamp with an older value.

This follow-on was found by source review and was not separately
triggered at runtime.

Pass the public ifaddr and both timestamps in ifa6_config. Initialize all
three fields before adding the temporary address to either the hash or
per-device lists. On success the existing public-ifaddr reference
transfers to the temporary object. On error it remains owned and released
by ipv6_create_tempaddr().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/r/179122559913.434549.12720841717630168470@kernel.org
Link: https://lore.kernel.org/r/179161099665.434549.5858601179492551889@kernel.org
Link: https://lore.kernel.org/r/20261007164548.GA1153540@shredder
Link: https://lore.kernel.org/r/20261012145240.GA779501@shredder
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-4-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h |  3 +++
 net/ipv6/addrconf.c    | 20 +++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index cda93578a41b4..637251ed33e49 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -73,6 +73,9 @@ struct ifa6_config {
 	unsigned int		plen;
 
 	const struct in6_addr	*peer_pfx;
+	struct inet6_ifaddr	*ifpub;
+	unsigned long		cstamp;
+	unsigned long		tstamp;
 
 	u32			rt_priority;
 	u32			ifa_flags;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f8061b62da030..f7889ada42125 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1145,10 +1145,19 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 		ifa->flags |= IFA_F_TENTATIVE;
 	ifa->valid_lft = cfg->valid_lft;
 	ifa->prefered_lft = cfg->preferred_lft;
-	ifa->cstamp = ifa->tstamp = jiffies;
 	ifa->tokenized = false;
 
 	ifa->rt = f6i;
+	ifa->ifpub = cfg->ifpub;
+	if (cfg->ifpub) {
+		ifa->cstamp = cfg->cstamp;
+		ifa->tstamp = cfg->tstamp;
+	} else {
+		unsigned long now = jiffies;
+
+		ifa->cstamp = now;
+		ifa->tstamp = now;
+	}
 
 	ifa->idev = idev;
 	in6_dev_hold(idev);
@@ -1434,6 +1443,9 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 
 	cfg.pfx = &addr;
 	cfg.scope = ipv6_addr_scope(cfg.pfx);
+	cfg.ifpub = ifp;
+	cfg.cstamp = now;
+	cfg.tstamp = tmp_tstamp;
 
 	ift = ipv6_add_addr(idev, &cfg, block, NULL);
 	if (IS_ERR(ift)) {
@@ -1444,12 +1456,6 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 		goto retry;
 	}
 
-	spin_lock_bh(&ift->lock);
-	ift->ifpub = ifp;
-	ift->cstamp = now;
-	ift->tstamp = tmp_tstamp;
-	spin_unlock_bh(&ift->lock);
-
 	addrconf_dad_start(ift);
 	in6_ifa_put(ift);
 	in6_dev_put(idev);
-- 
2.53.0



