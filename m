Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063602;
	b=XdhTDILRNcO6auPdyHXtanzxEw7w3tm8gEq7CfH/mzyUIDIBCp/vAiqe8MTWkOz+2GYb
	 5h8RogXM5WAxBe8C5JhhDx+PGhrQBZA5dzceJQfMg7GYXoa4yqY9wB3Nl/+6YE25agGiv
	 XNLHTjg8HK16Pa768ThJUYji9c2pgtFE/L0EURMmJtVwZU28UTec8TesHszPeL/pK2Uu+
	 5RIQC5P1/xjuEtU1vQf/EuECEsq/8ojf78QuUfPH29vdKjKA5WKq1hEue1ipUB7YMAAy6
	 AmVHf7pZiI8Qf6VjI1l3gJTJuQtWx+ZuDymGm+F9OqLUttcomdVzjptgn8n96Xu+2Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gh6zWH7FQCnGKWi3rZIEDID+XJnZ5/gQIOvQSVLa5Ts=;
	b=xz7v1at/pjEj/ce33XplgbUKhygQxxztA3JCYrhbUzxs4DVjnFUh84OzQWO28qoIuJUk
	 642EltYgEASvmTgf8jXLV0SjQ/ilnb/iII2DeYNbBS8nOwASQCDhwsO0+Lg03RIE1zUf3
	 QiKPCO+pF0mQlc+UBgxt5Xy/09RrfBghIpMVMD73uEIen+KCQvpBMGeJ/FwxRqgbyHU0j
	 KYhOq4i+oWjB1AenweK0vYlQfDw/OkvQpwX8f2tVZQh12JMsgZjBvCCIz5u8eIzStL99C
	 ectGhZp3bcPSnOZ19OSgjHR2vvUsuR+ZuN03birM2IbPF08DKqv/6qR0i4Cznrv7puA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VGTZO1RE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD94A6082BDF;
	Sat,  7 Nov 2026 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VGTZO1RE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173D51F0089F;
	Sat,  7 Nov 2026 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063601;
	bh=gh6zWH7FQCnGKWi3rZIEDID+XJnZ5/gQIOvQSVLa5Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGTZO1REiVrMbEx3gFcgZPt0HSpZifUCmLmVy9VkVKy0XydHwEd5jXLz7H4P9VHkP
	 Z+3VVhM7xrTUnZChx36USrBEytIZVN4eJJXAl/DKiwI45dCPJ+tPDOm3qxhyOL5lfB
	 gYVhFSKoc40cV+wpr23jOAXjsjJ2sTeNvRFNb+FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 687/869] ipv6: initialize temporary ifaddr before publication
Date: Sat,  7 Nov 2026 08:56:09 -0500
Message-ID: <20261107134916.323131082@linuxfoundation.org>
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
index b353dea9aedc8..03d6543a51890 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -80,6 +80,9 @@ struct ifa6_config {
 	u8			ifa_proto;
 
 	const struct in6_addr	*peer_pfx;
+	struct inet6_ifaddr	*ifpub;
+	unsigned long		cstamp;
+	unsigned long		tstamp;
 
 	u32			rt_priority;
 	u32			ifa_flags;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index caf8f3bd2372f..e277b78313686 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1155,10 +1155,19 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
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
@@ -1491,6 +1500,9 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 
 	cfg.pfx = &addr;
 	cfg.scope = ipv6_addr_scope(cfg.pfx);
+	cfg.ifpub = ifp;
+	cfg.cstamp = now;
+	cfg.tstamp = tmp_tstamp;
 
 	ift = ipv6_add_addr(idev, &cfg, block, NULL);
 	if (IS_ERR(ift)) {
@@ -1501,12 +1513,6 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
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



