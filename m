Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038824;
	b=BhTyOxUZWj7YqpubcKlQtUy1JuDGLD+Smhy6emnEinzd+smXc5dIxAFPdcdF8Ub/Attd
	 vXEbw1ak733MESoNUC80C+fE+eXlrTbTpBqvcdYQfzdbUDyQ+Q+CVI7o8uoXDEGg1Toj9
	 rPBiOhXo+0MrJtoHhC5OZz22KoE2t7vwo2Ptt6y34ckf53oP9GsjM+lLo8bK7w0wK2KN1
	 ZkQLgSbeXAnM5G2q1C+bvyKXaAq7tSPeYILCu0oNMnphDAvXKv0SPrldAEUGEQwlFq4D0
	 alLS0oAkj3kW1A1Gy3rBjr50WUYiqchFj8s0p3Qn5mGp0GGbTPN9cEjRE9gpKzKmHFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NcZVxPgYhT3goEHJzSi3bT259zB6skL2D6uU2djpMDc=;
	b=kNLOXmRqV3wubuB0Y7CVQ6mViK5RreSGqK8WiS65PVkeVKttNEVmPGblb236i4jqdhRU
	 +SZb5/DVAnDkYFK9mm1FS+BTNNNVf0sMzBF/CdJuXM1Inyw2fjrAoOKTWsaj4VhKKvsxc
	 hanDJqiUR+aScfiW2o1sY3UuwDUw5SCAyLPoA6IkaPqDh5zi2uFwXmFV4Sdfk72DH3/vt
	 Chcg533LTn0/Lj2wgzklvkWhI63oRJBJwAp9vgzBUAs2WS04baPFC0OPXbr7cy+Ze9zd3
	 C2SiEuSHi5QcqbeyH2rVyIYsPqLWErd3WFEphCxHXuz8BpJFjiiTgGYfdGTOs7/B7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhqPrVLY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8B4606A31C;
	Wed, 18 Nov 2026 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhqPrVLY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF221F000C6;
	Wed, 18 Nov 2026 21:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038823;
	bh=NcZVxPgYhT3goEHJzSi3bT259zB6skL2D6uU2djpMDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhqPrVLYrQa+MuUEE6yeRDzb8HPHlOq7VaxI4BVFwRURqAXSlPhRLLs549FCSx7Gt
	 x4HQe8g5gUh5EkHwAezMkVCfaQQvtOXVOlwWOv7BH/WzviGxViB28bS5zAzDOLP2YS
	 +7Of90+aQUWSwsvYt5qWEz96qYFRCnTKNwnAEnUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1881/3318] mm/memory-tiers: unregister empty tiers outside memory_tier_lock
Date: Wed, 18 Nov 2026 15:41:43 +0100
Message-ID: <20261118150418.416655686@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 500624f28eca441e35f978979ccfb373202fefd3 ]

When offlining a node's last memory empties its tier,
clear_node_memory_tier() calls device_unregister() while holding
memory_tier_lock. A concurrent sysfs read can hold a kernfs active
reference and block in nodelist_show() on that mutex. device_unregister()
then waits in kernfs_drain() for the read to finish and release its active
reference, while the reader waits for the offlining task to release the
mutex.

Return the node's former tier from clear_node_memory_tier(), making the
helper more similar to set_node_memory_tier(), which also returns a
memory_tier pointer. Let the caller unlink an empty tier under
memory_tier_lock before rebuilding demotion targets, then unregister its
device after dropping the lock.

Fixes: 9832fb87834e ("mm/demotion: expose memory tier details via sysfs")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-46-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: adapted node notifications to memory notifications using status_change_nid and the existing last-memory guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-tiers.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 93cb8eed4bc23..72995fe83f47f 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -502,21 +502,14 @@ static struct memory_tier *set_node_memory_tier(int node)
 	return memtier;
 }
 
-static void destroy_memory_tier(struct memory_tier *memtier)
+static struct memory_tier *clear_node_memory_tier(int node)
 {
-	list_del(&memtier->list);
-	device_unregister(&memtier->dev);
-}
-
-static bool clear_node_memory_tier(int node)
-{
-	bool cleared = false;
 	pg_data_t *pgdat;
 	struct memory_tier *memtier;
 
 	pgdat = NODE_DATA(node);
 	if (!pgdat)
-		return false;
+		return NULL;
 
 	/*
 	 * Make sure that anybody looking at NODE_DATA who finds
@@ -534,14 +527,10 @@ static bool clear_node_memory_tier(int node)
 		synchronize_rcu();
 		memtype = node_memory_types[node].memtype;
 		node_clear(node, memtype->nodes);
-		if (nodes_empty(memtype->nodes)) {
+		if (nodes_empty(memtype->nodes))
 			list_del_init(&memtype->tier_sibiling);
-			if (list_empty(&memtier->memory_types))
-				destroy_memory_tier(memtier);
-		}
-		cleared = true;
 	}
-	return cleared;
+	return memtier;
 }
 
 static void release_memtype(struct kref *kref)
@@ -757,6 +746,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 {
 	struct memory_tier *memtier;
 	struct memory_notify *arg = _arg;
+	bool empty = false;
 
 	/*
 	 * Only update the node migration order when a node is
@@ -768,9 +758,16 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 	switch (action) {
 	case MEM_OFFLINE:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(arg->status_change_nid))
+		memtier = clear_node_memory_tier(arg->status_change_nid);
+		if (memtier) {
+			empty = list_empty(&memtier->memory_types);
+			if (empty)
+				list_del(&memtier->list);
 			establish_demotion_targets();
+		}
 		mutex_unlock(&memory_tier_lock);
+		if (empty)
+			device_unregister(&memtier->dev);
 		break;
 	case MEM_ONLINE:
 		mutex_lock(&memory_tier_lock);
-- 
2.53.0



