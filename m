Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047416;
	b=XDMcOWGAECPK8IpWOt/MJQJd1VFFFhE0/oSSxXXSdiyqjQdlzZIpWW1Y5MxqH3aoU0xM
	 6eTxouRUYdX4acApVy0pMcwxGO5ncFBwVFx/bxhOh2of4jzyPH6woCn/9P/dFuQUamfzo
	 WxddvOljcn49iRl920KgLIDN1P9tMIC7UNBj0j3ilQy8KnbIYlCeQkDTX4RXBeQ3n7dQo
	 /e3N/lk4T1oIK2TFS6si4UcQGyedUvUWonFoxexAtU+C0mlsZib+tgI1Lw7x8VJbs9E+o
	 tA1l8OS8VKvYXoeIuV3Zld7d6Lo+WooCexNwmynKoVk6yOgGyUDDqAKqQFw9vlc24UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPapc5hBcnGdQGCAgftXCsGLqgte6sHzf/swONUoak4=;
	b=kx7yqY116TSq79a1R5xwXlRhJzXFFhCm9vvLJpmk7wwRNzSb/AsyOl+CKEhHuk1J1MFx
	 FgCW9I2g3CgDvQweCkJNXK0dfBDjXlbZVOxaCYd6v9Elo1KV0v35PKJf7aSZL/OcUGsBO
	 JqzSa1Z7X7V5l7rSoPk1DE2ZYnnxy8FmPNYpVHUa0cG3e2HyDi93QNk55fKCU62J1gsUX
	 +DXc2p1jIZOtTh0JztgwWf00a/seFA4uThZoDFRdVa3ltgQg7KlhvrYY4spLuF1upcDPu
	 tndZXH/VkA4BUHUb0MOFihdf3gvURz7xUW974zJhV5yOpm1GA+1ktplynSBoUNJWa+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoOMPvIt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC00D606A320;
	Thu, 19 Nov 2026 00:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OoOMPvIt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D09D1F000C4;
	Thu, 19 Nov 2026 00:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047416;
	bh=JPapc5hBcnGdQGCAgftXCsGLqgte6sHzf/swONUoak4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoOMPvItYcaI+j5tk+JEaFHbMD7DqUozBao9PrLubbgwk4ElbK+xukZRRGSHRL/v2
	 OtMLOXaLhbsq9Oy2jwOztwopxQOg+O/HHOXL2sUAER74I7rwbXq/fObjsXJowTaPHC
	 kU3zHJzYWl2hm3u/E1mlTlbO3urVVwz1jhXga++o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1630/2857] mm/memory-tiers: unregister empty tiers outside memory_tier_lock
Date: Wed, 18 Nov 2026 15:44:24 +0100
Message-ID: <20261118150300.030973582@linuxfoundation.org>
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
[ sashal: adapted node hotplug notifications to the older memory notifier API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-tiers.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index ba863f46759d3..77f531d788e87 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -495,21 +495,14 @@ static struct memory_tier *set_node_memory_tier(int node)
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
@@ -527,14 +520,10 @@ static bool clear_node_memory_tier(int node)
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
@@ -598,6 +587,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 {
 	struct memory_tier *memtier;
 	struct memory_notify *arg = _arg;
+	bool empty = false;
 
 	/*
 	 * Only update the node migration order when a node is
@@ -609,9 +599,16 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
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



