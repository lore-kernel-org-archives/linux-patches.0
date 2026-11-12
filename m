Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469312;
	b=SwUcBbU4spQ3FhHlVEcJtXDfw08ReTs8KmsDM4PQkhrAqndGvIBW/yUZ/CrFkIjsOzXh
	 dvlgbm7claDsg9EXtYiTDl3zxmTGkJ0f4usXsxAU2SWo7Fi6Y6O+4boGvDiqUGQVIQ4tz
	 3+3Ysq/2EJ3XX9Xh5tdlKKKcMNl4MRaeS6kbIGQVjP/05bhBCYGlyzJC3qsJ/hHUrZ+hz
	 4/dfRr/nOJwLf/TuChE7NjkmMa7nWL038lMgdWWSTx82JC/ZE16AxUfBC9tEvNGpOmwt3
	 Exf5qc5rd+cE8ghcY5c5xGbYqRkPX2XepL3Bla3mqIzK7afL0y+/Rz75hp8vISy/xQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DesgUR1FLNDSgs6rFKyr3K448pouVlN/AzKQsvGe5k0=;
	b=f/a/dEUZBKDTzVHhqE9re6OHsHEEunApNDSa7tM9kEuiFEnZrhKfhm1EM9Sc96Te11ww
	 AMl6qGuTuy/nlpVh2gHoYLQJ4hmjvW4YDffjIG8tDf6ATeWKq3mZdBNqPI/FuZ6qs0l6H
	 SJS50JP7Pmliy8Nhu6r6x54z4E4hIXXeQwTQYahiSvI/XvwFZMpm/diU+P21W7UjlP0xc
	 J+miEf2WBWrccGMQe6ZetufcJuDjD1LOet4+nryyl9ynvhHN7xfUMq4g2nPNSz3wpxE5v
	 /pQRDnO9/5BXj7MA25fUY/EpOHHCKZS6V7WTm/sjDPwBxEH5ob808z2+FHybh8Sef3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WTmAj6Lk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B4606A321;
	Thu, 12 Nov 2026 07:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WTmAj6Lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4C21F00A05;
	Thu, 12 Nov 2026 07:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469311;
	bh=DesgUR1FLNDSgs6rFKyr3K448pouVlN/AzKQsvGe5k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTmAj6Lket3WeGef6eZR57w6baDbYdRQ2GxurESP3c88BoIsCGwtJJ+9GOnD4EMlh
	 XAKqwUIHQKNHrPIgGfH3kalkmTvy+ktoFdmM/4RcrII8h1EWl9uU2XszHPQEFO22Bf
	 npFnc5v2nDB7IGMZLJyZ4eOmGLOFNBN2EGbEGmdhlAb1wiNIBrAZZLyMW/NbvmZs0p
	 mUKrkQX7ymZKchN+13adfVe4i2gP63V97L9n6Qy3QHQ139C4ogO8cY07gzt27/EPQF
	 toClbit3bKBbIYSWrSsPvn5u9cwLl2zLk7WalS388ck/kcHspB9zYoW/miPH04k+H5
	 Qmzu9BcKbu8vQ==
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
Subject: [RFC PATCH v5 04/16] KVM: guest_memfd: Add provider PFN range lookup
Date: Thu, 12 Nov 2026 13:11:08 +0530
Message-ID: <20261112074120.1570072-5-aneesh.kumar@kernel.org>
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

Provide nonallocating folio range lookup and carry PFN attributes separately
from requested KVM memory attributes

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h       | 10 ++++--
 samples/kvm/mem_provider_sample.c |  6 ++--
 virt/kvm/guest_memfd.c            | 60 ++++++++++++++++++++++++++-----
 3 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index b63ca59773f9..d3b153a3d891 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -60,7 +60,10 @@ struct guest_memfd_handle {
  *                    is present. If backing memory is not available, return
  *                    -ENOENT. Return a negative error code on other failure.
  *                    The provider must define @get_pfn when @lookup_pfn_range
- *                    is defined.
+ *                    is defined, or omit both to use the folio helper.
+ *                    Lookup must not allocate memory or prepare it for access.
+ *                    PFNs remain stable under the inode invalidate lock and
+ *                    any provider lock held by conversion/reclaim callers.
  * @put_pfn_range: Release a range of PFNs previously obtained for a given
  *                 index.  The provider does not need to ensure that backing
  *                 memory is present. If backing memory is not available, the
@@ -79,8 +82,9 @@ struct guest_memfd_provider_operations {
 	void (*invalidate_folio)(void *provider, struct folio *folio);
 	int (*get_pfn)(struct inode *inode, void *provider, pgoff_t index,
 		       struct guest_memfd_handle *handle);
-	int (*lookup_pfn_range)(void *provider, pgoff_t index,
-				unsigned long *pfn, size_t *nr_pages);
+	int (*lookup_pfn_range)(struct inode *inode, void *provider, pgoff_t index,
+				unsigned long *pfn, size_t *nr_pages,
+				u64 *pfn_attrs);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
 };
 
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index f1b0698268c0..8eca914c49ef 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -197,8 +197,9 @@ static int mps_gmem_get_pfn(struct inode *inode, void *provider,
 	return 0;
 }
 
-static int mps_gmem_lookup_pfn_range(void *provider, pgoff_t index,
-				     unsigned long *pfn, size_t *nr_pages)
+static int mps_gmem_lookup_pfn_range(struct inode *inode, void *provider,
+		pgoff_t index, unsigned long *pfn,
+		size_t *nr_pages, u64 *pfn_attrs)
 {
 	struct file *resource_file = provider;
 	struct mps_info *info = resource_file->private_data;
@@ -211,6 +212,7 @@ static int mps_gmem_lookup_pfn_range(void *provider, pgoff_t index,
 
 	*pfn = info->base_pfn + index;
 	*nr_pages = 1;
+	*pfn_attrs = 0;
 	return 0;
 }
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5fda14a53488..ad9cc1bbe5d7 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -52,6 +52,8 @@ struct gmem_inode {
 
 static int gmem_folio_get_pfn(struct inode *inode, void *provider, pgoff_t index,
 		struct guest_memfd_handle *handle);
+static int gmem_folio_lookup_pfn_range(struct inode *inode, void *provider,
+		pgoff_t index, unsigned long *pfn, size_t *nr_pages, u64 *pfn_attrs);
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 {
@@ -88,6 +90,7 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.attach = gmem_native_attach,
 	.alloc_folio = gmem_native_alloc_folio,
 	.get_pfn = gmem_folio_get_pfn,
+	.lookup_pfn_range = gmem_folio_lookup_pfn_range,
 };
 
 static bool gmem_provider_ops_valid(struct gmem_inode *gi,
@@ -129,8 +132,10 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 {
 	gi->provider_operations = *ops;
 	if (ops->alloc_folio) {
-		if (!ops->get_pfn)
+		if (!ops->get_pfn) {
 			gi->provider_operations.get_pfn = gmem_folio_get_pfn;
+			gi->provider_operations.lookup_pfn_range = gmem_folio_lookup_pfn_range;
+		}
 	}
 	gi->provider_ops = &gi->provider_operations;
 }
@@ -239,13 +244,15 @@ static void gmem_put_handle(struct guest_memfd_handle *handle)
 
 #if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 static int gmem_provider_lookup_pfn_range(struct gmem_inode *gi, pgoff_t index,
-					  kvm_pfn_t *pfn, size_t *nr_pages)
+		kvm_pfn_t *pfn, size_t *nr_pages, u64 *pfn_attrs)
 {
 	unsigned long raw_pfn;
 	int r;
 
-	r = gi->provider_ops->lookup_pfn_range(gi->provider, index, &raw_pfn,
-					       nr_pages);
+	/* Initialize the length in case an error leaves it unset by the provider. */
+	*nr_pages = 0;
+	r = gi->provider_ops->lookup_pfn_range(&gi->vfs_inode, gi->provider, index, &raw_pfn,
+					       nr_pages, pfn_attrs);
 	if (r)
 		return r;
 
@@ -433,6 +440,38 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
+/* Conversion holds invalidate_lock for write, excluding truncation/allocation. */
+static int gmem_folio_lookup_pfn_range(struct inode *inode, void *provider,
+		pgoff_t index, unsigned long *pfn, size_t *nr_pages, u64 *pfn_attrs)
+{
+	struct folio *folio;
+
+	lockdep_assert_held_write(&inode->i_mapping->invalidate_lock);
+	folio = filemap_get_folio(inode->i_mapping, index);
+	if (IS_ERR(folio)) {
+		struct folio_batch fbatch;
+		pgoff_t end = i_size_read(inode) >> PAGE_SHIFT;
+		pgoff_t next = index;
+
+		if (PTR_ERR(folio) != -ENOENT)
+			return PTR_ERR(folio);
+
+		folio_batch_init(&fbatch);
+		if (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+			end = fbatch.folios[0]->index;
+			folio_batch_release(&fbatch);
+		}
+		*nr_pages = end - index;
+		return -ENOENT;
+	}
+
+	*pfn = folio_file_pfn(folio, index);
+	*nr_pages = folio_next_index(folio) - index;
+	*pfn_attrs = 0;
+	folio_put(folio);
+	return 0;
+}
+
 static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
 {
 	if (gmem_in_place_conversion)
@@ -525,11 +564,14 @@ static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t e
 		size_t step = 1;
 		size_t nr_pages;
 		kvm_pfn_t pfn;
+		u64 pfn_attrs;
+		int ret;
 
-		if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages)) {
-			step = min_t(size_t, nr_pages, end - index);
+		ret = gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages,
+						     &pfn_attrs);
+		step = min_t(size_t, max_t(size_t, nr_pages, 1), end - index);
+		if (!ret && !(pfn_attrs & GUEST_MEMFD_PFN_MMIO))
 			kvm_arch_gmem_reclaim(pfn, step);
-		}
 
 		index += step;
 		cond_resched();
@@ -1068,8 +1110,10 @@ static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end
 			size_t step = 1;
 			size_t nr_pages;
 			kvm_pfn_t pfn;
+			u64 pfn_attrs;
 
-			if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages)) {
+			if (!gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages,
+							    &pfn_attrs)) {
 				step = min_t(size_t, nr_pages, end - index);
 				kvm_arch_gmem_make_shared(pfn, step);
 			}
-- 
2.43.0

