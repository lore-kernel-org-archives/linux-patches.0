Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209500;
	b=cuUJjLAzTf2XX5l225VT8mtvaxeGN5ntIDgF8XEUj1PgLylPlFOQsWM2ITn7LEy6j0Hl
	 uSHD7+Be44x/O/yz3soP5f/yb2rA9fKUPTSxU9KBX1geUo3FHIvGJAuZrnvGimVFhxyPX
	 xD4bmnq4Dov+st3xoHlRV+a1lnpN7ye67+PngYjcP0T9CyGbcF08a5OOfNcEsGGPbGqzA
	 yCqx5eiJ1JPw7S7/K1pwTlKuie+jzat3wR6hEv9B4Ei5DSS4IuhSBMVACMiwCaD236gCE
	 DBTiAqol4ZwEjm9UaGgl/D+ffWbuKiGLJ5Ugi4B4Mny00yYCvK1SnaqA7FkuiQ3yHlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z2bsCH3zQJ72SZReMKpKR90NkC7xOxlIzR+7LPJ8FJ0=;
	b=Uq9wLe2am5aZi37kTQG12tAebsKlETRycYV7mWjRPhTqlEgqhVIsq/ISkKnuUCHaJicg
	 zhtwT+g3SmRuY3icWBuKzaUYPfVqjPo9DT4p80zj/lXwBqK+twIf0SH9AaYpfqr/CUCin
	 Tmty6JYBktjdnv/VjJyDkpoqZ5mHBqbBi4vHSzhY+FnJ1abNCtAqAeQXZ0OC9H33xvk2T
	 YO8unYKwKRV9Vbh0M4nXtFGSVY8ugNqa8W6fgC/XMuqRm1KGCUg9w7S62JdGFz2Y9e9jb
	 qTHywTLaIr+7Z9vUY9Zu6cIMItPhn24YmgfAqP+LRwxhV6qWVz1qqWSCCjvaHlrzKjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIuSuZW0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AB7606A31E;
	Wed, 28 Oct 2026 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIuSuZW0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71441F01825;
	Wed, 28 Oct 2026 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209500;
	bh=Z2bsCH3zQJ72SZReMKpKR90NkC7xOxlIzR+7LPJ8FJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIuSuZW0oOomVGMPlhRe4pPSbTei9gglCUwDJRkcQ5vFlH6AuQrUPiX4sf5wR/xn6
	 7C/cFDfwMtAKUYYLTzxJoo2FAbdKu5zQBKzzMrWtz8fZvidPJQoWdt45e7QcF1gEDo
	 Jy8AMf42vfhKh/qcD2YUiW9PaPCU2SwVBnXRPvYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 493/516] net: bridge: mcast: dont truncate the port group walk on teardown
Date: Wed, 28 Oct 2026 18:00:45 +0100
Message-ID: <20261028170015.157514087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Jun Yang <littleddfu@gmail.com>

[ Upstream commit 5a3f7a683aee56e1f15c9d53041f3236767eaae7 ]

__br_multicast_disable_port_ctx() and br_multicast_del_port() walk
port->mglist with hlist_for_each_entry_safe(). However,
br_multicast_find_del_pg() can also delete other entries from the same
list through br_multicast_fwd_src_remove() or __fwd_del_star_excl().

If such an entry is the iterator's saved next node, hlist_del_init()
clears its ->next and terminates the walk early. The reproducer triggers
this in both teardown walks, leaving port groups in the bridge mdb with
a dangling ->key.port after del_nbp() frees the port:

  BUG: KASAN: slab-use-after-free in __mdb_fill_info+0x1191/0x1320
   __mdb_fill_info+0x1191/0x1320
   br_mdb_dump+0x594/0xe40
   rtnl_mdb_dump+0x1cf/0x5d0

Use hlist_del_init_rcu() to unlink the group while preserving ->next.
br_multicast_del_pg() and the teardown walks run under
br->multicast_lock. The GC worker must acquire the same lock before
detaching the group for destruction, so the node remains alive while
the walk uses the preserved pointer.

Preserving ->next means a walk can now reach a group that an earlier
iteration already deleted as a side effect. That group is off mp->ports,
so br_multicast_find_del_pg() would fall through its port scan and hit
the trailing WARN_ON(1). Skip such groups at the top of that helper: a
port group is put on port->mglist when it is created and only unlinked
when it is deleted, so hlist_unhashed() identifies exactly this case.

Fixes: b08123684bd5 ("net: bridge: mcast: install S,G entries automatically based on reports")
Cc: stable@vger.kernel.org
Suggested-by: Nikolay Aleksandrov <razor@blackwall.org>
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260831111330.199543-1-junvyyang@tencent.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Applied the br_multicast_del_pg() change to the existing __br_multicast_del_pg() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 53dd2d56c37ef..fdaf2db7173e6 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -596,7 +596,11 @@ static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	struct hlist_node *tmp;
 
 	rcu_assign_pointer(*pp, pg->next);
-	hlist_del_init(&pg->mglist);
+	/* Keep ->next (held under multicast_lock, freed later by the GC work):
+	 * a port->mglist teardown walk may have latched this node as its next,
+	 * and deleting other groups of the same port must not truncate it.
+	 */
+	hlist_del_init_rcu(&pg->mglist);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent);
 	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB);
@@ -629,6 +633,13 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 
+	/* A teardown walk over port->mglist can reach a group that an earlier
+	 * iteration already deleted as a side effect. It is off mp->ports by
+	 * now, so skip it instead of falling through to the WARN_ON() below.
+	 */
+	if (hlist_unhashed(&pg->mglist))
+		return;
+
 	mp = br_mdb_ip_get(br, &pg->key.addr);
 	if (WARN_ON(!mp))
 		return;
-- 
2.53.0



