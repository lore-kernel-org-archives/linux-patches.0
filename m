Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028651;
	b=15+6oRJRdR1m+UjErXuFQiolCET5DqhhSgF3rlNOyc4sgbkI74n35ZLvxHorr43BSdh7
	 VI/T+5YoMcgPFoOWlRb65bQd2X0I382zJ1UuXF/utvrIcDnHNTAzwtQ+ppgT4/uKRoDUF
	 W79Ayk71mvY2Y3bsKy3fjrk4iAJ379l4+3LvWYnS4/RMSa4Diu48s/TwDabdbGFDIRfsz
	 inJZksXoV+hXcLEI+9PjsysAbstpymo+xMOsrPOX3FAmjt2Zs83CHiO8WhRs/4XDh1NyG
	 lRBalKX1pH2stnNYCnIT87StKYp5Uu3GnQQHRtdxgQzcvr2VjpOzAFk+MtXWL/TAz+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5y5BNd3BWuCe/Eam0bF9SrqwujHVv7C/Wt9UswiUhQ=;
	b=eSFzMbB8j/FRo3uZqKwjAJ6wB0Z2LHDcGTflyPyhoru2TbEzFzHUTI147q/eR/r23mAm
	 QHuZj79hnewlrvRWIXrm/sejXfBIfncj3TF8HrQtrCYddf24S3TP1CHvXxSCO9ZxGXqCn
	 dykDfqkSxbzzihQ1Rf2rtKgPd82V6QrCjxSfiDni9VZOJP5LM5z3iSYUDtCnCAhMSfebb
	 b9o0wuBMRKRhTkEIHqrlo+Vt4N5iM++wlMnetIP/ybHL1xxIgTxHRLZWDWqb8ID/nrv58
	 JuKblwrI01C+Tl+cuVEGhxwTad7cO9Bf63mwQtZw/rblQXE63c1c0L7Wtb+2elEzDAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zlp/YIT6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7CD606A320;
	Wed, 18 Nov 2026 19:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zlp/YIT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7841F000C5;
	Wed, 18 Nov 2026 19:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028651;
	bh=c5y5BNd3BWuCe/Eam0bF9SrqwujHVv7C/Wt9UswiUhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zlp/YIT6z5Tn0XwsVNgQfcB/jnDaDEcFp+J+AgMfWlJtEl39hFBH2e97m55u87eD8
	 ufWiH6FtOYwvu5BmWDKOmR6a9dxyxaiax/jsvbYQQAcBsCDK8jp2iM3N7MvPuKxLA1
	 gUc4iaTiZchMXUPPzh69YV6LSEYFJLrxwKSaCAtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0028/1756] mm/memory-tiers: unregister empty tiers outside memory_tier_lock
Date: Wed, 18 Nov 2026 15:35:55 +0100
Message-ID: <20261118150008.998263831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted node notifications to the existing memory-notifier API using arg->status_change_nid instead of nn->nid. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-tiers.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index fc14fe53e9b75..a8733cd8d554b 100644
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
@@ -873,6 +862,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 {
 	struct memory_tier *memtier;
 	struct memory_notify *arg = _arg;
+	bool empty = false;
 
 	/*
 	 * Only update the node migration order when a node is
@@ -884,9 +874,16 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
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



