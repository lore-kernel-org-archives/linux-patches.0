Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042177;
	b=OOpmDYB8DZVCY23vPwbVkkn2vWWwHIT8mvDcOl6kMo2beFF3EL5z4tVCZl3rRLlWuEQg
	 QMA6kNPBWOytULq6Oe3uWRDd8S6b/rqyN4HKJWaX2fytbvIt+bjD/SQu2BUaQRvCBItxl
	 XVgAHRdB75bpEp5o9A5Z2K1sinLpcM0S78YTHLU8GD/JUNoZrWn5Wa5IHQNnenR/l3/i0
	 KfgvkchxQFeIcjmLYcODJvQWSGnPBtOAFNyo/OIuFt1KYDKSyOt5HoI99wu/AJ9Rhor6r
	 m9HrKJShq1lDFSNJiEUZE+IltFrUeraUSnl5xy6cAeZklV/jU84noET0ex0xg6+hQCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TxLsZri/Me3GeYyHKTEeIH7qW/8vnPPyLukwl5Udcw4=;
	b=0PB/5YWzCq6UfdYalIZUA9gdE4/T4J1MX2RZj0O1qXXRRE/jMJJy4o7XcraJ4sLZx0Jt
	 yV4pWuJS06/g5YJRhRNv4x8iIQVjjL1KQD3ShLZDFJCw+rwP5yvlawCdtgKSeR8YrohUC
	 rbTRtM+NlqNJ2QB9VjrXWRmCZBvSde/ljOZA+268bBoSr2spC51hXxYRz8HjW3ZE4E+6A
	 ZGfxh4EpD4hEgt1meom26zmtOn63eu079FMI+JntHx+RRTtZn7GDen27i9NY2ZPclG2BN
	 pDfaGMua28pI/1azhBbi5HF04iPNJfNqNN/NlcxjlSZWAMXHbfTLvXfinSsGopm4QVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3INPoN7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4BB606A31C;
	Wed, 18 Nov 2026 22:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3INPoN7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0D51F000C4;
	Wed, 18 Nov 2026 22:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042176;
	bh=TxLsZri/Me3GeYyHKTEeIH7qW/8vnPPyLukwl5Udcw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3INPoN7zHHwFZl1NKYpxNE/jHYd3BDCbtDEqg3QsWCl4O9MyqpTgm1tDoRjySm2Q
	 /V7re5uzAJUMrmITgbYfF4Zoq+auYcxcB1QphPLhmqAn7Mh9XtY9VLocu6RBrT/oyc
	 BUabUJiCcQy9BhAnkGoomX9/c6DZOnLOMGvMycLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlong Ma <yunlong_ma@buaa.edu.cn>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Gabriel Goller <g.goller@proxmox.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3078/3318] bridge: mcast: Delete empty MDB entry when port group creation fails
Date: Wed, 18 Nov 2026 16:01:40 +0100
Message-ID: <20261118150452.419863441@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 1d0590f96fa4133578b7370ea9ce1d871f6bfc21 ]

When a port group cannot be created for a new group, the MDB entry that
was created for it is left with no ports and is not joined by the host.
Its timer is never armed, so the entry is never deleted, but it is
counted towards mcast_hash_max. When this maximum is reached, the bridge
disables multicast snooping.

Since commit b57e8d870d52 ("net: bridge: Maintain number of MDB entries
in net_bridge_mcast_port"), port group creation also fails when the port
reached its mcast_max_groups limit. A host behind such a port can
therefore disable snooping by sending reports for new groups, which is
what the limit is meant to prevent. The RTM_NEWMDB path has the same
problem.

Fix by deleting the entry after a failure if it is unused. Delete it
immediately rather than arming its timer, so that it stops counting
towards the maximum right away.

Fixes: b57e8d870d52 ("net: bridge: Maintain number of MDB entries in net_bridge_mcast_port")
Reported-by: Yunlong Ma <yunlong_ma@buaa.edu.cn>
Closes: https://lore.kernel.org/netdev/2f5b61e2.1e71a.1a11fcb3809.Coremail.yunlong_ma@buaa.edu.cn/
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Gabriel Goller <g.goller@proxmox.com>
Reviewed-by: Gabriel Goller <g.goller@proxmox.com>
Link: https://patch.msgid.link/20261016101407.2030133-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mdb.c       | 16 +++++++++++++---
 net/bridge/br_multicast.c |  9 +++++++++
 net/bridge/br_private.h   |  1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 96bea0c8408fe..8a93630d0791c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -791,6 +791,7 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
 	struct br_mdb_config sg_cfg;
 	struct br_ip sg_ip;
 	u8 flags = 0;
+	int err;
 
 	sg_ip = cfg->group;
 	sg_ip.src = src_ip->src;
@@ -814,7 +815,11 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
 	sg_cfg.filter_mode = MCAST_INCLUDE;
 	sg_cfg.rt_protocol = cfg->rt_protocol;
 	sg_cfg.nlflags = cfg->nlflags;
-	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
+	err = br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
+	if (err)
+		br_multicast_del_group(sgmp);
+
+	return err;
 }
 
 static int br_mdb_add_group_src(const struct br_mdb_config *cfg,
@@ -1019,6 +1024,7 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
 	struct net_bridge_mcast *brmctx;
 	struct br_ip group = cfg->group;
 	unsigned char flags = 0;
+	int err;
 
 	brmctx = __br_mdb_choose_context(br, entry, extack);
 	if (!brmctx)
@@ -1045,9 +1051,13 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
 		flags |= MDB_PG_FLAGS_PERMANENT;
 
 	if (br_multicast_is_star_g(&group))
-		return br_mdb_add_group_star_g(cfg, mp, brmctx, flags, extack);
+		err = br_mdb_add_group_star_g(cfg, mp, brmctx, flags, extack);
 	else
-		return br_mdb_add_group_sg(cfg, mp, brmctx, flags, extack);
+		err = br_mdb_add_group_sg(cfg, mp, brmctx, flags, extack);
+	if (err)
+		br_multicast_del_group(mp);
+
+	return err;
 }
 
 static int __br_mdb_add(const struct br_mdb_config *cfg,
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index f7c8602bec338..db8a87852768e 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -646,6 +646,14 @@ static void br_multicast_del_mdb_entry(struct net_bridge_mdb_entry *mp)
 	queue_work(system_long_wq, &br->mcast_gc_work);
 }
 
+void br_multicast_del_group(struct net_bridge_mdb_entry *mp)
+{
+	if (mp->ports || mp->host_joined)
+		return;
+
+	br_multicast_del_mdb_entry(mp);
+}
+
 static void br_multicast_group_expired(struct timer_list *t)
 {
 	struct net_bridge_mdb_entry *mp = from_timer(mp, t, timer);
@@ -1560,6 +1568,7 @@ __br_multicast_add_group(struct net_bridge_mcast *brmctx,
 	p = br_multicast_new_port_group(pmctx->port, group, *pp, 0, src,
 					filter_mode, RTPROT_KERNEL, NULL);
 	if (unlikely(!p)) {
+		br_multicast_del_group(mp);
 		p = ERR_PTR(-ENOMEM);
 		goto out;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 958d12ebb660f..54a7408ba0f6a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -979,6 +979,7 @@ struct net_bridge_mdb_entry *
 br_mdb_ip_get(struct net_bridge *br, struct br_ip *dst);
 struct net_bridge_mdb_entry *
 br_multicast_new_group(struct net_bridge *br, struct br_ip *group);
+void br_multicast_del_group(struct net_bridge_mdb_entry *mp);
 struct net_bridge_port_group *
 br_multicast_new_port_group(struct net_bridge_port *port,
 			    const struct br_ip *group,
-- 
2.53.0



