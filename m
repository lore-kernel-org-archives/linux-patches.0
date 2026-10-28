Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216680;
	b=eBvCFJJkkiCypICQlPh+Z18Oaw46tZT5Z5K/TUjjunFXM/78xyvostApZwP1DlwMGRup
	 S7bUez94jTH1RPf/akRGZy3HI+VRju5UG22fVzS035HK2fjDojg4XnX+L/p5fX1TkW7HL
	 10j/LmwognpEqIeDYTYD0f9uaVyllEqvVJlf7ILJhYxJtAKTf0WPcTSapSBOpwWwh/EjF
	 t2ouSUi+Etbd9Ps5KUEo6itFmbf8TAdVuOG7AfwFUTm2C1C0nuFuJhrH4SesjPs/B7/e7
	 kcWHWolMc/PnzDpOcP5HVzzdYKi5MgLWnft9d6lMFGFCcu9JL9/3jkm6gNpA814dzrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aewe5TftfYmMdGTv6nyVEzrOTkbybgNdlP38lkjKHIA=;
	b=IAwqfJjL1FyVOct/xu0Imy7EGjJ5D/DAag/zUib3FQhNjaxXzi+bV2hhK4EHX4ZD/+PO
	 LH6IHDVh6dSKcgNVDHRjK1gg7nMh5QBe8G8PZAfmXaOos4bL6F9bTNAtKC8SnA8xGc5Y6
	 /npMNDjrXlnb71eqNMgG/4LbVbLCNl42y5GC6iDEx2kWvUkOaDc/TtSwucSM15mwAa9tx
	 T5rMAbmUTtzeMe1iN+wOiDsRrviw4kc+UBgWS7VAgIUhBxgtUXWpnC1LxL1FBO0HxTGzE
	 szYMKT+xPnWMA0XrBHKLENJxGC1hi2Py05+tkflolol6Dvbg7FFZwV9rY2j+J55d4iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3qgQY5P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C138A606A31F;
	Wed, 28 Oct 2026 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3qgQY5P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9891F01825;
	Wed, 28 Oct 2026 19:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216679;
	bh=Aewe5TftfYmMdGTv6nyVEzrOTkbybgNdlP38lkjKHIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3qgQY5PKnG601cSXn99blGvcQK6Lc3FGTvOTAi+pVbO8N7cuI6S+dizec9HarupK
	 8qs1NwM3+fOh8qBmE2cfEAN/7RBh5/v0Ml7JSkZCQVGQDXQkaUY85vPn5fW+1ELYS4
	 +bjLFuLVdaMjY9Kh3+on20NpROYnqNatmCgww0ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1639/1887] mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
Date: Wed, 28 Oct 2026 18:02:15 +0100
Message-ID: <20261028170536.761661015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 2ebce860bdd7ae5e13002811bc9bbbf33fcfc221 ]

We miss a failed allocation check for pgdat->per_cpu_nodestats, which
results in a NULL deref when we offset into the per-cpu area.

Propagate -ENOMEM up the stack and leave per_cpu_nodestats pointing
at boot_nodestats so a later online can retry the allocation.

hotadd_init_pgdat() returns NULL on failure, which __try_online_node()
already maps to -ENOMEM.

On failure nothing needs to be unwound:
  - the node is never marked online
  - per_cpu_nodestats is left pointing at boot_nodestats
  - __add_memory_resource() cleans up pending memblock resources
  - later online attempts retry the per_cpu_nodestats allocation

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry%40gourry.net
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20260701221613.2818148-1-gourry@gourry.net
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memory_hotplug.h |  2 +-
 mm/memory_hotplug.c            |  3 ++-
 mm/page_alloc.c                | 14 +++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 9fcbf57065957..26846484aed7d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -330,7 +330,7 @@ extern void set_zone_contiguous(struct zone *zone);
 extern void clear_zone_contiguous(struct zone *zone);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 33b21fc6d90d9..1a6cc0161fb76 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1185,7 +1185,8 @@ static pg_data_t __ref *hotadd_init_pgdat(int nid)
 	pgdat = NODE_DATA(nid);
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_core_hotplug(pgdat);
+	if (free_area_init_core_hotplug(pgdat))
+		return NULL;
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5f679f699477c..85b189bcab7ec 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7730,7 +7730,7 @@ static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx,
  * NOTE: this function is only called during memory hotplug
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
-void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
@@ -7738,8 +7738,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 
 	pgdat_init_internals(pgdat);
 
-	if (pgdat->per_cpu_nodestats == &boot_nodestats)
-		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
+	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
+		struct per_cpu_nodestat __percpu *p;
+
+		p = alloc_percpu(struct per_cpu_nodestat);
+		if (!p)
+			return -ENOMEM;
+		pgdat->per_cpu_nodestats = p;
+	}
 
 	/*
 	 * Reset the nr_zones, order and highest_zoneidx before reuse.
@@ -7767,6 +7773,8 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 
 	for (z = 0; z < MAX_NR_ZONES; z++)
 		zone_init_internals(&pgdat->node_zones[z], z, nid, 0);
+
+	return 0;
 }
 #endif
 
-- 
2.53.0



