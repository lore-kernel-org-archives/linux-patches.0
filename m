Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027551;
	b=BNGKugR1wZFB0vBFWQnDfAtYPtf8R9oNbGOMvTVm6z3x8O+sj4SH+y8aT/m1f+cZRq17
	 4YuVWjXyfNb4BHK0PqAn1htbnD1msLp/4JIDCkZ+36/C0+RLBBtMrHjeWB3MP8uE919OZ
	 ThsViFWOkVySXrBg8f+O1UDx+zL1I9mGqJiIRVB/bosoh5NW/hB3qoieWnBt3KRSzGKJp
	 F8CSrrgw01M5q7H+py0MLt87o5S5Zh02s2Sf5SNIwspjehQP5FyKd9UHaH7x5/VSe18uF
	 yhYUMPQJfxEjVfktbrN7/POXWltyVh/N66VPUU5NNIClsJt1D/sTybghrx0x4Fm6zKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jc658wY104oUEO90H/n1a1dmbDXp/qiMbCKW7Jqu4Ss=;
	b=Ve2M388d2Kl005oLNMknKUEBS4AWRMFi81lg5aAm00nCRnU0/IneBn2y4nuRnUGsWFXC
	 ZbWNHGnTojUHFi9FSEV6gzi7U3G8mCxMoIr32jg7dqR8OTG1aX9n+VYRLtT6pct32F6GL
	 wXYRROxIVBixZlttKlYnTnYzqvAQUlhD435s/+mn6+qmCxCXJOsKtDPRyCatKI2ovrU2q
	 XbDEmTtnRSKSKojpBEVGKDlgG/9XrnifjyvYEfhfk9ez0kxPi3gBr2kaRf+wud798MxyE
	 lW3AanSg4/PLQXG4NkD89DMJxM0FBgoKDOltAlZfu9++bbeoYU2WAofYh/0kcGwnIIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vvazva/r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CF860A2612;
	Wed, 18 Nov 2026 18:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vvazva/r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568DF1F000C6;
	Wed, 18 Nov 2026 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027550;
	bh=jc658wY104oUEO90H/n1a1dmbDXp/qiMbCKW7Jqu4Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvazva/r/EwOANhYIviNraBvQBcq0aZLNgZHtrh4b4ntZwol4XNttaGgucR4yPCV0
	 9V7okg/F5gXoGM/3QCg3W4h7fJbQIHrXvKAKWJmIx5/Ss79rt+c/efENR4aQFI+Ggn
	 lha95qgT6f6ag4QGG1alIIMd3cRpJ/GEi0j2CSBQ=
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
Subject: [PATCH 6.18 1822/2151] bridge: mcast: Delete empty MDB entry when port group creation fails
Date: Wed, 18 Nov 2026 15:59:17 +0100
Message-ID: <20261118150228.177724768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index a80ec51fe18d1..e43919fead898 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -819,6 +819,7 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
 	struct br_mdb_config sg_cfg;
 	struct br_ip sg_ip;
 	u8 flags = 0;
+	int err;
 
 	sg_ip = cfg->group;
 	sg_ip.src = src_ip->src;
@@ -842,7 +843,11 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
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
@@ -1047,6 +1052,7 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
 	struct net_bridge_mcast *brmctx;
 	struct br_ip group = cfg->group;
 	unsigned char flags = 0;
+	int err;
 
 	brmctx = __br_mdb_choose_context(br, entry, extack);
 	if (!brmctx)
@@ -1073,9 +1079,13 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
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
index c437cb684aebb..80ab7850eea1f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -647,6 +647,14 @@ static void br_multicast_del_mdb_entry(struct net_bridge_mdb_entry *mp)
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
 	struct net_bridge_mdb_entry *mp = timer_container_of(mp, t, timer);
@@ -1561,6 +1569,7 @@ __br_multicast_add_group(struct net_bridge_mcast *brmctx,
 	p = br_multicast_new_port_group(pmctx->port, group, *pp, 0, src,
 					filter_mode, RTPROT_KERNEL, NULL);
 	if (unlikely(!p)) {
+		br_multicast_del_group(mp);
 		p = ERR_PTR(-ENOMEM);
 		goto out;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e4c8bc8576df6..d1d8e94c333b3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -990,6 +990,7 @@ struct net_bridge_mdb_entry *
 br_mdb_ip_get(struct net_bridge *br, struct br_ip *dst);
 struct net_bridge_mdb_entry *
 br_multicast_new_group(struct net_bridge *br, struct br_ip *group);
+void br_multicast_del_group(struct net_bridge_mdb_entry *mp);
 struct net_bridge_port_group *
 br_multicast_new_port_group(struct net_bridge_port *port,
 			    const struct br_ip *group,
-- 
2.53.0



