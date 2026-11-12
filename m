Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469333;
	b=UnvgA5T/eTHW8qutg1xWTcbbnbIm+bSHNU3RKhBavecnbFzXawd2h34tv6mcpUYC/al2
	 ZtMbHW1FuLJu/DOcqa70BX28hv0YgKBLRVuMm7Jrp3mplxILdiqC9DOcKZP/vKP3AmWkW
	 Hbt5RKFlKRW3xRuRxm75j307MwebbUG4PQQOLEbm19YAY1Bd2E78RR2YS7Tz1Fgy7vqnm
	 Qqy66JmuyKpkkctN2bsXjfzvovf2lJX2XYCYEUYaOwLsL/9Nm+zwV8hmBp4YIiamZvf58
	 ceibSQb/ydNwUe9SRvJc9NIbtsVMbeDXd0iPZsT8B8LgKxXOppnQO9M+tjJZ3cRCvJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=iUmorQisNLh8D/04/1BxMpv3F30MU/CV/umiEAlyLlQ=;
	b=nQuPCJGxQbw46ZFPYILimFVrPD6XpIVv95XmZl2A6uTPPb3ydgkeQ+cV+77i/Dvi6t1/
	 8q/oHJJ8UoHTndy6RAIK/0MjDhlnuzKAM3xQsBRma8ZX6COH3DPk3+76q/LisGW4CIYuK
	 /ypPKuaz8r0l8YhSAbYhjZ7X4eK2cHZcOxCF3WAky2XFNZ7R53T6CAm0yZNncr206tuai
	 GY8HRZ+ELYJqgumicsC0TZx8DFJZ4wvW3oSPKBdPNRpJ1A2bqYqj4rMETeAuX8QfA1+B/
	 gOwEmQqJtHicFfymm2tWxNJxevF1eD3UaaJQR33c1bcgqApbfJVfYsyY+yhrcNjMSrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAp8UH17;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB23606A32D;
	Thu, 12 Nov 2026 07:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAp8UH17
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4698B1F00A05;
	Thu, 12 Nov 2026 07:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469333;
	bh=iUmorQisNLh8D/04/1BxMpv3F30MU/CV/umiEAlyLlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAp8UH17INjunsxb7J7wChDbIBfMw19cGgVekiHCvwchRH7CpEifE/wTrNlufzTFO
	 XexvrkBUfaR+zxUW7EMhxkcntNuMgSXZrDT2Zt0OY6KlnFyFVs5qAweFjiHt/g9dXO
	 kNjIhjwMxr3LY7aSW9Kh0PecCQz0jBOI3q6M8V8rHJQPZPDuGuO3JUb9hmaPw2XyJ5
	 gjyXgQCdklLoKZui+ioPzji+vdb4bGhTGuWdcdWdLY7QZEy0TdkUYP7Z8QFYhtU1Vi
	 bMF4/wXEGr0VfUfXzp0wS3cey7UZAHEtsR2G8jAwx+LV2giTp7sVg9e/c2yN7G0Tqv
	 bW/Y+PK+dnq+g==
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
Subject: [RFC PATCH v5 08/16] KVM: guest_memfd: Use provider operations for fallocate allocation
Date: Thu, 12 Nov 2026 13:11:12 +0530
Message-ID: <20261112074120.1570072-9-aneesh.kumar@kernel.org>
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

Use allocate_range() for fallocate allocation so providers can supply
allocation and release callback. When a provider supplies neither callback,
guest_memfd handles allocation and release for it. Providers that supply
only release_range() cannot use fallocate(), including hole punching.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |   8 +++
 virt/kvm/guest_memfd.c      | 122 +++++++++++++++++++++++-------------
 2 files changed, 87 insertions(+), 43 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 2ed929a9dca5..e11b2392b001 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -49,12 +49,18 @@ struct guest_memfd_handle {
  *                      failure; it initially points to the range start. NULL
  *                      selects folio validation for folio providers; for
  *                      other providers, NULL skips this validation.
+ * @allocate_range: Preallocate [start, end), without architecture private
+ *                  preparation. Called with the inode invalidate lock held
+ *                  for read.
  * @release_range: Remove host mappings and release memory in [start, end),
  *                 after core guest invalidation, under the inode invalidate
  *                 write lock and any provider lock. Also called at final
  *                 inode cleanup, when no bindings remain. The optional pfn
  *                 identifies memory revoked by the provider. release_backing
  *                 is false for provider-initiated revocation, true otherwise.
+ *                 Supplying this without allocate_range()
+ *                 supports a fixed memory range and disables fallocate(),
+ *                 including hole punching.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -92,6 +98,8 @@ struct guest_memfd_provider_operations {
 	void (*unlock)(void *provider);
 	int (*prepare_attributes)(struct inode *inode, void *provider, pgoff_t start,
 			size_t nr_pages, u64 memory_attrs, pgoff_t *err_index);
+	int (*allocate_range)(struct inode *inode, void *provider,
+			      pgoff_t start, pgoff_t end);
 	int (*release_range)(struct inode *inode, void *provider,
 			pgoff_t start, pgoff_t end, const unsigned long *pfn,
 			u64 pfn_attrs, bool release_backing);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a224ae969d79..c6b1814b5e7e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -56,6 +56,10 @@ static int gmem_folio_lookup_pfn_range(struct inode *inode, void *provider,
 		pgoff_t index, unsigned long *pfn, size_t *nr_pages, u64 *pfn_attrs);
 static int gmem_folio_prepare_attributes(struct inode *inode, void *provider,
 		pgoff_t start, size_t nr_pages, u64 attrs, pgoff_t *err_index);
+static int gmem_folio_allocate_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end);
+static int gmem_pfn_allocate_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end);
 static int gmem_folio_release_range(struct inode *inode, void *provider,
 		pgoff_t start, pgoff_t end, const unsigned long *pfn,
 		u64 pfn_attrs, bool release_backing);
@@ -100,6 +104,7 @@ static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.get_pfn = gmem_folio_get_pfn,
 	.lookup_pfn_range = gmem_folio_lookup_pfn_range,
 	.prepare_attributes = gmem_folio_prepare_attributes,
+	.allocate_range = gmem_folio_allocate_range,
 	.release_range = gmem_folio_release_range,
 };
 
@@ -122,6 +127,10 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	if (ops->invalidate_folio && !ops->alloc_folio)
 		return false;
 
+	/* A fixed memory range may support release without supporting allocation. */
+	if (ops->allocate_range && !ops->release_range)
+		return false;
+
 	/* Custom folio get_pfn() needs matching host mapping callbacks. */
 	if (ops->alloc_folio && ops->get_pfn &&
 	    (gi->flags & GUEST_MEMFD_FLAG_MMAP))
@@ -148,11 +157,15 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 		}
 		if (!ops->prepare_attributes)
 			gi->provider_operations.prepare_attributes = gmem_folio_prepare_attributes;
-		if (!ops->release_range)
+		if (!ops->release_range) {
+			gi->provider_operations.allocate_range = gmem_folio_allocate_range;
 			gi->provider_operations.release_range = gmem_folio_release_range;
+		}
 	} else {
-		if (!ops->release_range)
+		if (!ops->release_range) {
+			gi->provider_operations.allocate_range = gmem_pfn_allocate_range;
 			gi->provider_operations.release_range = gmem_pfn_release_range;
+		}
 	}
 	gi->provider_ops = &gi->provider_operations;
 }
@@ -717,47 +730,11 @@ int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
 
-static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
+static int gmem_folio_allocate_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end)
 {
-	struct address_space *mapping = inode->i_mapping;
-	struct gmem_inode *gi = GMEM_I(inode);
-	pgoff_t start, index, end;
-	int r;
-
-	/* Dedicated guest is immutable by default. */
-	if (offset + len > i_size_read(inode))
-		return -EINVAL;
-
-	filemap_invalidate_lock_shared(mapping);
-
-	start = offset >> PAGE_SHIFT;
-	end = (offset + len) >> PAGE_SHIFT;
-
-	r = 0;
-	if (kvm_gmem_is_pfn_mode(gi)) {
-		for (index = start; index < end; ) {
-			pgoff_t next_boundary;
-			pgoff_t max_nr_pages;
-			struct guest_memfd_handle handle;
-
-			if (signal_pending(current)) {
-				r = -EINTR;
-				break;
-			}
-
-			r = gmem_provider_get_pfn(gi, index, &handle);
-			if (r)
-				break;
-
-			max_nr_pages = 1UL << handle.max_order;
-			gmem_unlock_handle(&handle);
-			gmem_put_handle(&handle);
-			next_boundary = ALIGN_DOWN(index + max_nr_pages, max_nr_pages);
-			index += min_t(size_t, next_boundary - index, end - index);
-			cond_resched();
-		}
-		goto out_unlock;
-	}
+	pgoff_t index;
+	int r = 0;
 
 	for (index = start; index < end; ) {
 		struct folio *folio;
@@ -785,7 +762,62 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		cond_resched();
 	}
 
-out_unlock:
+	return r;
+}
+
+static int gmem_pfn_allocate_range(struct inode *inode, void *provider,
+		pgoff_t start, pgoff_t end)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t index;
+	int r = 0;
+
+	for (index = start; index < end; ) {
+		pgoff_t next_boundary;
+		pgoff_t max_nr_pages;
+		struct guest_memfd_handle handle;
+
+		if (signal_pending(current)) {
+			r = -EINTR;
+			break;
+		}
+
+		r = gmem_provider_get_pfn(gi, index, &handle);
+		if (r)
+			break;
+
+		max_nr_pages = 1UL << handle.max_order;
+		gmem_unlock_handle(&handle);
+		gmem_put_handle(&handle);
+		next_boundary = ALIGN_DOWN(index + max_nr_pages, max_nr_pages);
+		index += min_t(size_t, next_boundary - index, end - index);
+		cond_resched();
+	}
+
+	return r;
+}
+
+static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
+	const struct guest_memfd_provider_operations *ops = gi->provider_ops;
+	pgoff_t start, end;
+	int r;
+
+	if (!ops->allocate_range)
+		return -EOPNOTSUPP;
+
+	/* Dedicated guest is immutable by default. */
+	if (offset + len > i_size_read(inode))
+		return -EINVAL;
+
+	filemap_invalidate_lock_shared(mapping);
+
+	start = offset >> PAGE_SHIFT;
+	end = (offset + len) >> PAGE_SHIFT;
+	r = ops->allocate_range(inode, gi->provider, start, end);
+
 	filemap_invalidate_unlock_shared(mapping);
 
 	return r;
@@ -796,6 +828,10 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 {
 	int ret;
 
+	/* Providers without allocation support cannot be hole punched either. */
+	if (!GMEM_I(file_inode(file))->provider_ops->allocate_range)
+		return -EOPNOTSUPP;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
-- 
2.43.0

