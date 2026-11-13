Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590425;
	b=ULM+t/fQC7Ps1d8wPYQcmk/u2lZ52uRDD8QnRYYnZ/2I6AKNA5so4F7IhjsN2+x4GqXl
	 WqEzM2Cgo0wBe4wwGMyMi1XUj66gZnW/coWXWPu4NAmuVHvlHNHCBc3HLpOpxKBHyUxVO
	 OC0jKlq2EMFzsxJvqMKPBrqKORuMfAbs1F+lZb1fJ96t0aHZ37NH9xe4uu4pYTrhdCDCZ
	 6L2MIUCllMG57vINW0l4ye41kRhO6KCmYVCCnTBMZZYcvyCgAodTjrkE5l+9AQQW/mgxl
	 EphCzapbe0pmOAmo7xib/UBBfC9R82RflVD1cKWWJWFB9Z49t5W2pCzHmM/74ufRoLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7I5ZU+owi40/ByiV4wt9hisJHBeRvhlIIfld81U7rWU=;
	b=5QOEtS6Q0oe0BMesNaOZyRWlLoHRmSqdanXeWkbKQ97kRABRea/DuLS4ClJ3GyIYiKAW
	 R2WEcFDmslQcCObK1T1f9lxUp2FrWA1NeL6ntnDIgmKSbQIVdYMKEAySCDwtC7rvksY9G
	 lup6xlrn7AoxhkAIgS52MNLR0448ZB7k/wUHE7i/PFU2vaYRa1jKMTam6DupG/FkjSfD3
	 Ga4w1O0jUltPC1iVoMXfICAuoSOvNGQIeK8hw9TtaHvM7xTcYiBmNSlD20VLzm27iZWwH
	 C7xf/cWFYSIsPbBgXzxRb6SuzgNdh/HuW0Gi7Na4tD8pxi3xxIgJtuDrxSWCtyXrbsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WW3nyxFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DA8606A884;
	Fri, 13 Nov 2026 17:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WW3nyxFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6A71F000C4;
	Fri, 13 Nov 2026 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590425;
	bh=7I5ZU+owi40/ByiV4wt9hisJHBeRvhlIIfld81U7rWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WW3nyxFa/RFekNDQpexhRqLk/etqIoAIAjpZme975+BHbAaVC+pq0nBAYV9hVxekq
	 m+1YUyqEVV+gd3KwzCzHvedyI0Jwy8heJmiYLuLOgw3ZKAV/351r9451iIQKUPwUv6
	 vH0TO8rfiFNrE1LYJt2YjXqtDwQsnUkb+Z1Ehizo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/686] mm/memory-tiers: unregister empty tiers outside memory_tier_lock
Date: Fri, 13 Nov 2026 10:48:41 -0500
Message-ID: <20261113153834.154089883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 864811fff4093..fb3d63be1b897 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -561,21 +561,14 @@ static struct memory_tier *set_node_memory_tier(int node)
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
@@ -593,14 +586,10 @@ static bool clear_node_memory_tier(int node)
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
@@ -873,13 +862,21 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
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



