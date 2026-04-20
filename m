Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA00B449EDF;
	Mon, 20 Apr 2026 13:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691811; cv=none; b=rl3jAIrIUFXSzjBJ5msVpN188hgPVNfMvhSmZxbuN3E8h5a0jFZbkxr72TGRKXzx8rij5BCmNhKK8g7D5T7JLimD07zna27EJXEVbWh7l1+gZsgCMEOW6yqcNYB8hv1uOvtYjZudnveFDdTPbHKZQUmdpivyCVAlxKXB2kXkWTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691811; c=relaxed/simple;
	bh=xeizyCHGGlAko4MG1AYNqaKuHebwdAelFEQ1WlPXm/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YszMBINgPYF4JB8faA3yELpaXy1nFQRiYmmcFCD2+wzY/tXsnNghWLMKZ8sG52kPrYDTmqPpyc9ltz/o6hrmyK2gwVwmMLsKuchnVevyRynP4p9BVg2XdL3t7Ts3gRnJ/UC60rj5u29vLmrgXdoev+vZ8xIjLHyKP6TvgdP8vIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=svi/ZR1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="svi/ZR1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4477C2BCB4;
	Mon, 20 Apr 2026 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691810;
	bh=xeizyCHGGlAko4MG1AYNqaKuHebwdAelFEQ1WlPXm/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svi/ZR1DjRmRfGDpxCy1OVUxtmEpIbiRN0gmHX8haaLN6aM5RVN60zBaywzotjP40
	 nliRpkB32DN7L7Ab7Ix/utAcjwKtZYVBoxKeEllIN+WuoFAo7lE4ji6uaM7ln2KOty
	 AN6sNNfAzT8jo4WH1iZ1gEh84AbubEiHltoCckNDJBe3kq7dXNOmq+AVm/jX2ImaRM
	 b8cn+T10pZnxUpDIq5sC6Td5TxUWJqmuaO2gmN4kbzyKOLBhvaaY5t0IXA56eUB4Mf
	 Nisgf3eDc43DpRflB207h0qR5JTQ3EMOGA0LnMu1ltd56JkvNDaMiRpqiqxKzadr0J
	 RSYL6CSHReDRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	m.szyprowski@samsung.com,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] dma-debug: track cache clean flag in entries
Date: Mon, 20 Apr 2026 09:20:02 -0400
Message-ID: <20260420132314.1023554-208-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit d5d846513128c1a3bc2f2d371f6e903177dea443 ]

If a driver is buggy and has 2 overlapping mappings but only
sets cache clean flag on the 1st one of them, we warn.
But if it only does it for the 2nd one, we don't.

Fix by tracking cache clean flag in the entry.

Message-ID: <0ffb3513d18614539c108b4548cdfbc64274a7d1.1767601130.git.mst@redhat.com>
Reviewed-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 3d48c9fd78dd ("dma-debug: suppress cacheline overlap warning when arch has no DMA alignment requirement")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 kernel/dma/debug.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 7e66d863d573f..43d6a996d7a78 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -63,6 +63,7 @@ enum map_err_types {
  * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
  * @paddr: physical start address of the mapping
  * @map_err_type: track whether dma_mapping_error() was checked
+ * @is_cache_clean: driver promises not to write to buffer while mapped
  * @stack_len: number of backtrace entries in @stack_entries
  * @stack_entries: stack of backtrace history
  */
@@ -76,7 +77,8 @@ struct dma_debug_entry {
 	int		 sg_call_ents;
 	int		 sg_mapped_ents;
 	phys_addr_t	 paddr;
-	enum map_err_types  map_err_type;
+	enum map_err_types map_err_type;
+	bool		 is_cache_clean;
 #ifdef CONFIG_STACKTRACE
 	unsigned int	stack_len;
 	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
@@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
 	return active_cacheline_set_overlap(cln, --overlap);
 }
 
-static int active_cacheline_insert(struct dma_debug_entry *entry)
+static int active_cacheline_insert(struct dma_debug_entry *entry,
+				   bool *overlap_cache_clean)
 {
 	phys_addr_t cln = to_cacheline_number(entry);
 	unsigned long flags;
 	int rc;
 
+	*overlap_cache_clean = false;
+
 	/* If the device is not writing memory then we don't have any
 	 * concerns about the cpu consuming stale data.  This mitigates
 	 * legitimate usages of overlapping mappings.
@@ -487,8 +492,16 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
 
 	spin_lock_irqsave(&radix_lock, flags);
 	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
-	if (rc == -EEXIST)
+	if (rc == -EEXIST) {
+		struct dma_debug_entry *existing;
+
 		active_cacheline_inc_overlap(cln);
+		existing = radix_tree_lookup(&dma_active_cacheline, cln);
+		/* A lookup failure here after we got -EEXIST is unexpected. */
+		WARN_ON(!existing);
+		if (existing)
+			*overlap_cache_clean = existing->is_cache_clean;
+	}
 	spin_unlock_irqrestore(&radix_lock, flags);
 
 	return rc;
@@ -583,20 +596,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
  */
 static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 {
+	bool overlap_cache_clean;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 	int rc;
 
+	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
+
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);
 	put_hash_bucket(bucket, flags);
 
-	rc = active_cacheline_insert(entry);
+	rc = active_cacheline_insert(entry, &overlap_cache_clean);
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST &&
-		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
+		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+		   !(entry->is_cache_clean && overlap_cache_clean) &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
2.53.0

