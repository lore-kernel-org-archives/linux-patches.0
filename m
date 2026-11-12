Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469322;
	b=vJGp9MafYhQOVnDULahP3NdwJBV7WpkZoPb0lkNeE13/md0dHYLXLh0Ird4ziLN+9Gwz
	 NyZJ2tkfzusdtQfT2UbnJIn3EARILxTFCJKqvA9dgqnGjZuXnjbUGChXttk5MDv9LgwJx
	 DSZA6/IO1q77CJugjFSgywdFvRdDBV6X89UWlhb9jZMoJ/lGk4rIOM8+fhp/1VJLTOW+x
	 pmargl/9A6PzwpEVnjmzrZ9kh5t7tEl6VaRQVR75OZhsefpsiCN/DeTXMnmzjYB77u3Ss
	 nRzHEQc073Gri/zS2aIxKHDgmeXZn9aBQSE+9EtXEQbiU/l/IkwHtmNOx7woavAEWjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HE6cnZ1k4EYo8CjIQ8YBIHYyLNkvWrFk6ZCkmarWWxc=;
	b=q6VHvJEtV1w8X9SoXjhIqI3UYVknkZkhVoQWBEJsNLXOx0KFlpFrJGwITSJvSdfpbrDY
	 K59V3258zmcW0r5M2hhs5jYo/mYdiA7IM0r9GSr6oMnorWiFB8gVHx4eslTRWF3Gyt5Yp
	 gssDq67aWJI4DDrn3uUW0/f4XqjWcovuQSlKLztxgjCJV8awrEKsNa5CRDpznAjo81BPx
	 hU4NfCLKXeUAOsh6weBCr/LN99lJubJdHqlHmOYdJ0dsraEKVfOwovmPNztsTovMsCgPe
	 uWQq2VjbuVX5PXXjElTg6Yu1Wf672dcU6phgOGN2qEZVjgCKGxXbNgb0i1hBejL1g2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N92ndCwd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E179606A327;
	Thu, 12 Nov 2026 07:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N92ndCwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF931F00A0E;
	Thu, 12 Nov 2026 07:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469322;
	bh=HE6cnZ1k4EYo8CjIQ8YBIHYyLNkvWrFk6ZCkmarWWxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N92ndCwdpZx8AAKjgUKKar3I08JjFE9UaGhQJPBTCV+OPvSsG5LTuhXSjoIvZ9E67
	 5WiVijh5TlfqKKjkFjCrPd35zKHlRRzn6BkM1V6Jxje+BFfQTojsuIgZBguQlzJUL/
	 D99tdUd2DZRdqBcpzPtWz9eRBL/xHvbGYHNiD5KM6op0c4zHI8dhLq5+KvSUYmb5ti
	 aENwGAzdmZzm2RIZSNGoYirQCXPcrTZBlh27jZtcnnmnBSFRPZdznXYFLAn9E7cxp7
	 7MMK8oXTa576gsvbb1wg4lV+Mav7DPrjlYawgLIVqHsld5DPQA5SMTpAnYDHpY+uEh
	 sGz9bU3AQM8fQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v5 06/16] KVM: guest_memfd: Share memory through provider range lookup
Date: Thu, 12 Nov 2026 13:11:10 +0530
Message-ID: <20261112074120.1570072-7-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
References: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
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

Use provider range lookup for both folios and PFNs when converting memory
to shared. Skip holes without allocating pages and return lookup errors.

Invalidate mappings before conversion and publish shared attributes only
after conversion succeeds.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 126 ++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 64 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c69a8b7d046c..ffe0a8e0f2dd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1110,87 +1110,79 @@ static int gmem_folio_prepare_attributes(struct inode *inode, void *provider,
 	return 0;
 }
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
-static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
+static int gmem_provider_make_shared(struct inode *inode, pgoff_t start,
+		pgoff_t end)
 {
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 	struct gmem_inode *gi = GMEM_I(inode);
-	struct folio_batch fbatch;
-	pgoff_t next = start;
-	int i;
+	void *entry;
 
-	if (kvm_gmem_is_pfn_mode(gi)) {
-		pgoff_t index;
+	MA_STATE(mas, &gi->attributes, start, start);
 
-		for (index = start; index < end; ) {
-			size_t step = 1;
+	if (!kvm_arch_has_gmem_convert())
+		return 0;
+
+	mas_for_each(&mas, entry, end - 1) {
+		pgoff_t first = max(start, mas.index);
+		pgoff_t last = min(end, mas.last + 1);
+
+		if (!(kvm_gmem_get_attributes(inode, entry) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
+			continue;
+
+		while (first < last) {
 			size_t nr_pages;
-			kvm_pfn_t pfn;
 			u64 pfn_attrs;
-
-			if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages,
-							    &pfn_attrs)) {
-				step = min_t(size_t, nr_pages, end - index);
-				kvm_arch_gmem_make_shared(pfn, step);
+			kvm_pfn_t pfn;
+			int ret;
+
+			ret = gmem_provider_lookup_pfn_range(gi, first, &pfn, &nr_pages,
+							     &pfn_attrs);
+			if (ret == -ENOENT) {
+				/*
+				 * Skip the reported hole, advancing at least one page
+				 * even if nr_pages is zero, but stop at the end of this
+				 * attribute range.
+				 */
+				first += min_t(size_t, max_t(size_t, nr_pages, 1),
+					       last - first);
+				cond_resched();
+				continue;
 			}
+			if (ret)
+				return ret;
 
-			index += step;
-			cond_resched();
-		}
-		return;
-	}
+			nr_pages = min_t(size_t, nr_pages, last - first);
+			kvm_arch_gmem_make_shared(pfn, nr_pages);
+			ret = 0;
+			if (ret)
+				return ret;
 
-	folio_batch_init(&fbatch);
-	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
-		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
-			struct folio *folio = fbatch.folios[i];
-			pgoff_t start_index, end_index;
-			kvm_pfn_t start_pfn;
-			kvm_pfn_t nr_pages;
-
-			start_index = max(start, folio->index);
-			end_index = min(end, folio_next_index(folio));
-			/*
-			 * end_index is either in folio or points to
-			 * the first page of the next folio. Hence,
-			 * all pages in range [start_index, end_index)
-			 * are contiguous.
-			 */
-			start_pfn = folio_file_pfn(folio, start_index);
-			nr_pages = end_index - start_index;
-
-			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
+			first += nr_pages;
+			cond_resched();
 		}
-
-		folio_batch_release(&fbatch);
-		cond_resched();
 	}
-}
-#else
-static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
 #endif
+	return 0;
+}
 
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs,
-				     pgoff_t *err_index)
+		size_t nr_pages, u64 attrs, pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
 	struct gmem_inode *gi = GMEM_I(inode);
 	enum kvm_gfn_range_filter filter;
 	pgoff_t end = start + nr_pages;
-	struct maple_tree *mt;
 	struct ma_state mas;
 	int r = 0;
 
-	mt = &gi->attributes;
-
 	*err_index = start;
 	filemap_invalidate_lock(mapping);
 
 	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
 		goto out;
 
-	mas_init(&mas, mt, start);
+	mas_init(&mas, &gi->attributes, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r)
 		goto out;
@@ -1207,29 +1199,35 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (gi->provider_ops->prepare_attributes) {
 		r = gi->provider_ops->prepare_attributes(inode, gi->provider, start,
 							nr_pages, attrs, err_index);
-		if (r) {
-			mas_destroy(&mas);
-			goto out;
-		}
+		if (r)
+			goto destroy;
 	}
 
-	/*
-	 * From this point on guest_memfd has performed necessary
-	 * checks and can proceed to do guest-breaking changes.
-	 */
-
 	gmem_provider_lock_updates(gi);
 
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
-	if (!to_private && kvm_arch_has_gmem_convert())
-		kvm_gmem_make_shared(inode, start, end);
+	/*
+	 * Make existing pages host-accessible before publishing shared attributes.
+	 * Host faults map shared pages without performing architecture conversion.
+	 * Private conversion revokes host mappings here, but can defer making
+	 * pages private until a guest fault or prefault.
+	 */
+	if (!to_private)
+		r = gmem_provider_make_shared(inode, start, end);
 
-	mas_store_prealloc(&mas, xa_mk_value(attrs));
+	if (!r)
+		mas_store_prealloc(&mas, xa_mk_value(attrs));
 
+	if (r)
+		mas_destroy(&mas);
 	kvm_gmem_invalidate_end(inode, start, end);
 	gmem_provider_unlock_updates(gi);
+	goto out;
+
+destroy:
+	mas_destroy(&mas);
 out:
 	filemap_invalidate_unlock(mapping);
 	return r;
-- 
2.43.0

