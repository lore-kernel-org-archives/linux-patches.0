Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585730;
	b=NYSmDpMhnbsFKWfVrbx3UhzpIkBRmNz3ZIISdD5dOma5feycw3iSRJNuYMTGGV+F0eHl
	 +4AoTfqILj32BVeA9Y8lCjuwJyLUIVryX0i/VMmoSkRj7GaR5QWHwLXRahmZ1joKc/Kco
	 XCJfRZZowv9s+J/uS6d80FPKPSDTHqb/BTd7hW9akEkeIZ95j4XjRE//Hkm+PZA6setCb
	 k4YOzF2lSbz2vF+YMTyvRYry9/dnS51ZKj/KR9wUhf8ckAoJ3Jf5vlXNWGXwSiG2xi0kv
	 ezWignmBLWzA9RnHIyP3SRAhTj+aV/PoeyoxEdTw+2bjRTVYGsAXznTNYVrKZZRBtvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M08hlivw7MLUA8ZOeFoJRyU2bKsDSx52yVp4I+uki1g=;
	b=G26xuTP3iS72/augpAYbWTwndocFeLFkP5BTanKp3B7UhoSiNHXl2ud4kIKFEZfbkIND
	 89Le6yAMEtVMl7Pq0nwKMdx4B+gmncS/fn4bgBPYovaAHYHSFEdgXmeezRRZTOfifaXEn
	 GwcP0poZPv82YE2MrYseS0kTs1qkGyoekBbofMrXsiumWSsXspPyCG1WjzOwKg37fg30e
	 G7ioUMiiX2V5vBSUuGht9eM1IGJILRZLb/KtV4fMGRN5sIzojChCT02sTVERz+J/z5ogA
	 O+cr1UamGhvCjWpmMBNSUbSXTCfiwYoEtmW3/nCMH/o6UnzW2hVbqMq1aXvNAH3lZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2F80eFk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E207606A337;
	Fri, 13 Nov 2026 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2F80eFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3CA1F000C6;
	Fri, 13 Nov 2026 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585730;
	bh=M08hlivw7MLUA8ZOeFoJRyU2bKsDSx52yVp4I+uki1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2F80eFkO4QRQT0VbGPiuT0nzgMQvfRrnJ1fAoLWrGayEm3uUP0TsJvLQXy32FTDY
	 MPKWIvKa/IxtACdS8OvnWEBdbm+eP0CEWYN4DtQj5uXwLv7kY+gAtdfLUXDmzNd6rH
	 KP4w6yDqCJpApuah+/mOz/Jd29WQeo67LcUafcuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 331/507] mm/memory-tiers: unregister empty tiers outside memory_tier_lock
Date: Fri, 13 Nov 2026 10:50:35 -0500
Message-ID: <20261113153806.643059534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-tiers.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b0..ddc135f55eb8b 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -571,21 +571,14 @@ static struct memory_tier *set_node_memory_tier(int node)
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
@@ -603,14 +596,10 @@ static bool clear_node_memory_tier(int node)
 		synchronize_rcu();
 		memtype = node_memory_types[node].memtype;
 		node_clear(node, memtype->nodes);
-		if (nodes_empty(memtype->nodes)) {
+		if (nodes_empty(memtype->nodes))
 			list_del_init(&memtype->tier_sibling);
-			if (list_empty(&memtier->memory_types))
-				destroy_memory_tier(memtier);
-		}
-		cleared = true;
 	}
-	return cleared;
+	return memtier;
 }
 
 static void release_memtype(struct kref *kref)
@@ -883,13 +872,21 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 {
 	struct memory_tier *memtier;
 	struct node_notify *nn = _arg;
+	bool empty = false;
 
 	switch (action) {
 	case NODE_REMOVED_LAST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(nn->nid))
+		memtier = clear_node_memory_tier(nn->nid);
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
 	case NODE_ADDED_FIRST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-- 
2.53.0



