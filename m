Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065169;
	b=SnVaVfo+jXcE7L7HTOhPpcEaPvDHzJ2BIKLzk61QgMad/WuVj7WbtTrKb/kB98bGkqI2
	 zVf6vqWUfsdP9YIfDn5YpP6U8Svz+QiDmREpa6WqxARmFDq7kWbadYuhwiBkxp1d+dhwe
	 XXeUK95bulIpM677IRRKBh6W1vGAeNxsmLVkc+H99glQCg7K1XJHp4+1yHDo8TAvg7r77
	 8kX5mne00uBrBzkVroQteDh0e0TlJae+5b5rPjBqlzPGgvKWPEndFI9QzjUal/2WBR7/9
	 7THSh7+ePEvnv7Uy3TXx2qFWcKn5PDeX5itTm3K4QT7/Ty4B6NB4hD4krMVAMrmjpXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9CPaboNnCfPQLYTxmnvxwm6lZqiHhGxSSFKOrP4fydg=;
	b=W0qrXAbo7WpwBhrzFLb1FpF521wtk9B7SWSJ/yPfe3j3K5MCZRpE+UdZ83WLm8oMliWY
	 q2nf6I+NOCAon4mBh6BF7clFCjjqQCfVzzg3RFrZ0bq1nF320XkXYCMa4nxY+1IjZqEC7
	 ZWN7/TwQrLzMaeArl1HtYqk6US0/pVPo4F+aiDw2OBANp/O2jQ+es+kuhKu2s5oWhjRYr
	 CoQHJamuFq1O9WkQXJI2O61ulAvSHlr9hnO3X6YPa1QGSot3e2nNITofLxu2zMyDJSV0y
	 MaY0PJBxQEEA+6e+27quXwuXu4UMi4C/Cj59bcgcIbbqRBteQ7s3S0QZihwwpP9FRKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iutYD30j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90809606A33A;
	Sat,  7 Nov 2026 15:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iutYD30j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3542E1F0089F;
	Sat,  7 Nov 2026 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065169;
	bh=9CPaboNnCfPQLYTxmnvxwm6lZqiHhGxSSFKOrP4fydg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iutYD30jg7D27WL9YU6HnwYIHLcNcsNZBUMQM3MiUPBIEduaYQtMZnb9IFikMkml8
	 Gi5CTmLNBkaAhOKq/yOiB7Ud8kZf8MHQsmGU5XhEt9Tsig3E5LfxMsj0J0YOpFd+60
	 PDkJCnRlpwgWk2Mulok418xw24cBpjoRI+Yf6tTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0973/1257] ipv6: initialize temporary ifaddr before publication
Date: Sat,  7 Nov 2026 08:54:29 -0500
Message-ID: <20261107135006.231803808@linuxfoundation.org>
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
index e6764245995f2..6818057cf7275 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -81,6 +81,9 @@ struct ifa6_config {
 	u8			ifa_proto;
 
 	const struct in6_addr	*peer_pfx;
+	struct inet6_ifaddr	*ifpub;
+	unsigned long		cstamp;
+	unsigned long		tstamp;
 
 	u32			rt_priority;
 	u32			ifa_flags;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3bede30d4e989..df56668122619 100644
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



