Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045670;
	b=t7/P6emJpQsL5Z0iLXJczz2ekDK9+4fINhK2rKc4IGktd3lKOnKkHYXj697gdw126eCf
	 nzmXJUpWpkwdrKLCiREXE512gZI6BG6TZJ9IQ4K+pQTlZzosC8jPwDOSBWT5LInwSHplb
	 p8nOvLze0rB1Zuuc9qtMWhvwcVkDtZDBufSaoCCcHn37Jg/0A2B5l52pdvkqHANTCrshf
	 NLr8nJDV4yJCYKdgawiJGpzi1/btnjzT2OkQlL8oLPW1tzTlDDkIoRGhkuPRqe3hwMU1W
	 rloNg3JpZbQwicpf4w1ogPsmfOeDKG4zcTkC+2NFjkkxeGHRSCz4YInROnLzNoBqwww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2f0qVgce0lH4pTZhXBMohnPJBJUSpUrfKDVOsjv9w2Y=;
	b=W7alfT0IBrsMuZrrDrMucldLA1mbnWkxq4pRolkczaYqJjAKXYXlAG4TFcea4ZL1MiUM
	 Gaf4VkMPrgaFLOulJjzfNHxW1yvzqiVJ7PbZ9eptnhlXFkFzUEQR6NshQSlptsj9E+RE+
	 fECgeJCRCZ/HhO7gzWOg4rAjueUTQjzqhCNzIh2xSvMdm5VejTC55n7Eb88qvSYCvAxYH
	 b8EeVsX3N0dA+3XiSTGnC8B39eLQmSBIYfqIbCo6WZZU9wDRl/NQJXodVweiYTq9XT9jX
	 S4JV4PD/m8fxtomcczMfYPs+UcU7o/ZT4V1e/Nz2WRsXr4kBqDlpcVcSooAumEcCJpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaJpeLvk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B70606A31C;
	Wed, 18 Nov 2026 23:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaJpeLvk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A6D1F000C6;
	Wed, 18 Nov 2026 23:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045669;
	bh=2f0qVgce0lH4pTZhXBMohnPJBJUSpUrfKDVOsjv9w2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaJpeLvk6CzP8e/XCCunK7uAmrGDzfp7zVdeMJYxfUB10RnXOFcX0JP5bcvxKiy3P
	 bKYlbyPsGedY8lcKZMPe2sMwrd2Y6vtkenaxMBk3WOJofGl3TVjpIMAQG1QI++iqiN
	 N1OuvnMympz5xBUJUORalThZq1rdqkvtxWbxtF9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1006/2857] ipv6: initialize temporary ifaddr before publication
Date: Wed, 18 Nov 2026 15:34:00 +0100
Message-ID: <20261118150237.817993928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1363f88eb11e0..66ac594d0278d 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -75,6 +75,9 @@ struct ifa6_config {
 	u8			ifa_proto;
 
 	const struct in6_addr	*peer_pfx;
+	struct inet6_ifaddr	*ifpub;
+	unsigned long		cstamp;
+	unsigned long		tstamp;
 
 	u32			rt_priority;
 	u32			ifa_flags;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 7e54b264f672f..9b21080754133 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1144,10 +1144,19 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
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
@@ -1438,6 +1447,9 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 
 	cfg.pfx = &addr;
 	cfg.scope = ipv6_addr_scope(cfg.pfx);
+	cfg.ifpub = ifp;
+	cfg.cstamp = now;
+	cfg.tstamp = tmp_tstamp;
 
 	ift = ipv6_add_addr(idev, &cfg, block, NULL);
 	if (IS_ERR(ift)) {
@@ -1448,12 +1460,6 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
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



