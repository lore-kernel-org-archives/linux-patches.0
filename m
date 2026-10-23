Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775049;
	b=Ku1rBIz7QQOIaiO5NCcJK1PGohJKivwvNXTwyNYEyn8GwN3k2jB2zT6XKfLOCb5D/ajA
	 zWxcKq8IKS3/xTkglqWbyQExG6Ys6gIxpkiQBCyjLg5lmAdU4mLweNCAUoml47VWVK825
	 o9oO92h2xkwsAjpg67007CK0/KdsC52FGSaKZjfA4PQIejHAGOyQYRAHsms192mUzknpy
	 AW2rQfmcBu3aJGyODE8xAV3WpQZEb7sGtgQzR18RSuk4iPe1iHMRWJ1J0QhclF/9EsLUM
	 qPhkYiTA34lHsmhgiSBrmV8GGtymMQrcR7HYkUx2+JOVPkIiFmXkGbegh+0jzKDtZKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3G+uw1T/EPkmFMIXsA8hwSwiMJutHHk+/Wpu7gAeqxQ=;
	b=i3kzEr3a24Q/ca6YRJiwBPcZ455eyhRJKTCHO41NhemPCHg0MuvxtpvaGncmoAnPTig9
	 oAhAf4EB4H7vqihcplEj/i1Cdza7+wgtvQHo1fT52YgAQY4qJcF9zOsyW6cq1CwsQ3s1G
	 TIGf9h+IlqdQrr2PAfYg1kk6LwYux3RmaJC/yk6gyrTez57oVJAyibvSZ7h3rUG6OOg8y
	 Kn5qYP3HNH4bYLAKzi6n733+GweLwylcEXLM4UuChFoDyzNhqWfl9v78klEE17ZRe8Pwg
	 vwHDFbOHtfRP9lSZzI9P3HJ6OtjL5P9/ntD6Bsf/oLsVIi2nBasX2ZDKWeTO8TrS2Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8LhfMQI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBB606A320;
	Fri, 23 Oct 2026 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8LhfMQI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF34A1F01825;
	Fri, 23 Oct 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775049;
	bh=3G+uw1T/EPkmFMIXsA8hwSwiMJutHHk+/Wpu7gAeqxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8LhfMQIdl+nUa2UWrr74TfeWBaQZNBEe+MY4Uhuk9gt3Rez5Y2xRbN20IOdKFDIe
	 RfSCFxECKOi1C8t8qC7W30wOlmxu2uCAwg6jCr0/ia1GSIAhbmQLuVDdcfBbZx4cTd
	 Cn8yGaQWzIkDLlc7/i4ceb1eD9OnnIrjIfCXy3VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 213/242] net: bridge: mcast: dont truncate the port group walk on teardown
Date: Fri, 23 Oct 2026 18:40:55 +0200
Message-ID: <20261023163718.838177330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yang <littleddfu@gmail.com>

commit 5a3f7a683aee56e1f15c9d53041f3236767eaae7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -813,7 +813,11 @@ static void __br_multicast_del_pg(struct
 	struct hlist_node *tmp;
 
 	rcu_assign_pointer(*pp, pg->next);
-	hlist_del_init(&pg->mglist);
+	/* Keep ->next (held under multicast_lock, freed later by the GC work):
+	 * a port->mglist teardown walk may have latched this node as its next,
+	 * and deleting other groups of the same port must not truncate it.
+	 */
+	hlist_del_init_rcu(&pg->mglist);
 	br_multicast_eht_clean_sets(pg);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent, false);
@@ -848,6 +852,13 @@ static void br_multicast_find_del_pg(str
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


