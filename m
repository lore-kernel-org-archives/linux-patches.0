Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804633;
	b=cX1tRoA7+t0VyVrY0q1wYxhPeKxfglhBcy/6HsYAgeurfHP8HJMPL5RZZrtg5c0+/7q+
	 cqR4Ue7hziopQsjpJjMAPPE468yBu0Zp6JVeTuZ7WkGnA3xfMKa4x+xw2La8Cks+H4/kb
	 5Oz8wiaw6z0wiuRoNz4POlkEj19xQmzSP6YK1gsu2f/IQDbh6SlLCeLtnkuQMxeH2PSRM
	 50elAHwOams+HPZoNBE9ska67Y9dwQ202ke06rnN6QXF24eVqlDgdKJLjivHmIOIrjNNF
	 e4Gi1fL0rUtxOviDOJ1DIwgqQdLlsBuzNj3Guoiyr5hJNLJy739o4gXai+0XtwAy8bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=O3E3ZZVrToECwsQn9kYn+edTvszvBZ01v1dND2FLV0I=;
	b=O3zno1AzvHbIPaKf+R0jDyPLoj/5V5mQedMub30+IbDGgJjbibBivHSkdDbdVlaGswAf
	 e8y73+ZPbhvts7/irdFcRb/KA59VQg27bT1O5SyYFJDa1NXMohvMpgFueulerAPv8D2vJ
	 ciYVlaPIzgfCNYulCBpTahWyNGxjZ6fhGD0pmBM5/9DediCSuWZOqaY95dqF8qznWHuqU
	 IEVZx7pOAO+d/YUxtDHcaZzkcfznZJnoMVnRKmWkJUbQB/KJFNyiM+M5TMXBoAYLvTXBV
	 xgzcPdDgW0Nx3lMsLM4V4jfo++ZpIqsyLOLLlUIIHwi+rttZDkXCTB2/MMdh8mqUGAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BTk6J5NE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9195606A32E;
	Wed,  4 Nov 2026 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BTk6J5NE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8F91F00A1B;
	Wed,  4 Nov 2026 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804632;
	bh=O3E3ZZVrToECwsQn9kYn+edTvszvBZ01v1dND2FLV0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTk6J5NEPVtJoOYbp4h3Bs8SA/zZ0WIMacjEAYUAzQ0he/vrIG5LhwDnuU9dL/c82
	 NUj48YsuGa3dyeKrHabNXC6zvLr+w/B1FV8RT27e+s0czfrGf+HMPQ2aJJKa4krNPx
	 0t3mnfB7ymgxY3HeeC9VWz6a+MwsCAIIWlesy4aWDytLdmE05iKoeHiSyu/OWGcBUC
	 XFHnx6yvcuQgp3lIkMuBB3R2FUtaREr/Y2EuT81HQH1U8nngSn5lwG96cKNrehBVnl
	 sAKIw3axl2O/dEk6R3LKovQG0CXoGJQlcTkMsCtcQoKYMnQdjMfMQ4zInEDrXmzNvz
	 +NgcWsnBsZS+w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
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
Subject: [RFC PATCH v4 03/25] KVM: guest_memfd: Let providers coordinate mapping changes
Date: Wed,  4 Nov 2026 20:33:00 +0530
Message-ID: <20261104150322.3516320-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
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

Resource providers may need to serialize host access with guest
invalidation, architecture conversion and publication of new attributes.

Add optional paired lock() and unlock() callbacks without exposing KVM
memslots or architecture requests through the provider interface. Reject
providers that supply only one callback.

Call gmem_provider_lock() with inode->i_mapping->invalidate_lock held
for write, after prepare_attributes() and before guest invalidation
starts. It invokes the provider's optional lock() callback. Call
gmem_provider_unlock() after invalidation ends, regardless of whether
conversion succeeds. Publish attributes before unlocking only when
conversion succeeds.

Subsequent revocation, memslot unbind and final file cleanup use the
same pair without changing attributes.

Existing providers omit both callbacks and retain their current behavior.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h | 11 +++++++++++
 virt/kvm/guest_memfd.c      | 37 ++++++++++++++++++++++++++++---------
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 17407504307b..9fc04f1188c1 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -20,6 +20,15 @@ struct mempolicy;
  *                         Offset and size are in bytes. The flags contain only
  *                         KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY bits.
  *                         Return 0 on success or a negative error code.
+ * @lock: Optional provider exclusion for mapping and attribute changes. Called
+ *        with the inode invalidate lock held for write, before guest
+ *        invalidation starts. May sleep and must return with exclusion held.
+ *        Supply both lock and unlock, or neither.
+ * @unlock: Release exclusion acquired by lock(). Called after guest
+ *          invalidation ends and any successful attribute publication, with
+ *          the inode invalidate lock still held. The pair also covers range
+ *          revocation, memslot unbind and final file cleanup; those operations
+ *          do not change attributes.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -52,6 +61,8 @@ struct guest_memfd_provider_operations {
 	void (*release)(void *provider);
 	int (*prepare_memory_region)(void *provider, u64 offset, u64 size,
 				     u32 flags);
+	void (*lock)(void *provider);
+	void (*unlock)(void *provider);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3cb1523ad74e..20c72693c210 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -33,19 +33,20 @@ struct gmem_file {
 
 struct kvm_gmem_backing_ops {
 	/*
-	 * Validate the transition before guest invalidation and conversion.
-	 * Caller holds inode->i_mapping->invalidate_lock for write. May revoke
-	 * host mappings and check outstanding references. On failure, return an
-	 * error and set err_index to the failing offset; it defaults to the range
-	 * start.
+	 * Validate the transition before gmem_provider_lock(), guest invalidation
+	 * and conversion. Caller holds inode->i_mapping->invalidate_lock for write.
+	 * May revoke host mappings and check outstanding references. On failure,
+	 * return an error and set err_index to the failing offset; it defaults to
+	 * the range start.
 	 */
 	int (*prepare_attributes)(struct inode *inode, pgoff_t start,
 			size_t nr_pages, u64 attrs, pgoff_t *err_index);
 	/*
 	 * Complete range conversion after guest invalidation starts and before
 	 * attributes are published. Caller holds inode->i_mapping->invalidate_lock
-	 * for write. Shared memory must be safe for host access when the
-	 * attributes become visible; host faults bypass prepare_pfn().
+	 * for write and calls this between gmem_provider_lock() and
+	 * gmem_provider_unlock(). Shared memory must be safe for host access when
+	 * the attributes become visible; host faults bypass prepare_pfn().
 	 * NULL means no additional conversion is needed at this phase.
 	 */
 	int (*convert_attributes)(struct inode *inode, pgoff_t start, pgoff_t end,
@@ -125,6 +126,9 @@ static bool gmem_provider_ops_valid(struct gmem_inode *gi,
 	if (!ops || !ops->attach)
 		return false;
 
+	if (!!ops->lock != !!ops->unlock)
+		return false;
+
 	if (kvm_gmem_is_pfn_mode(gi))
 		return ops->get_pfn && ops->lookup_pfn_range;
 
@@ -226,6 +230,18 @@ static void gmem_provider_put_pfn_range(struct gmem_inode *gi, pgoff_t index,
 		gi->provider_ops->put_pfn_range(gi->provider, index, nr_pages);
 }
 
+static void gmem_provider_lock(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->lock)
+		gi->provider_ops->lock(gi->provider);
+}
+
+static void gmem_provider_unlock(struct gmem_inode *gi)
+{
+	if (gi->provider_ops && gi->provider_ops->unlock)
+		gi->provider_ops->unlock(gi->provider);
+}
+
 static void gmem_provider_release(struct gmem_inode *gi)
 {
 	if (gi->provider_ops && gi->provider_ops->release)
@@ -1121,8 +1137,7 @@ static int kvm_gmem_convert_attributes(struct inode *inode, pgoff_t start,
 }
 
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs,
-				     pgoff_t *err_index)
+		size_t nr_pages, u64 attrs, pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
@@ -1148,6 +1163,9 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (r)
 		goto destroy;
 
+	/* Call the provider's lock() before invalidation as well as conversion. */
+	gmem_provider_lock(gi);
+
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
@@ -1158,6 +1176,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (r)
 		mas_destroy(&mas);
 	kvm_gmem_invalidate_end(inode, start, end);
+	gmem_provider_unlock(gi);
 	goto out;
 
 destroy:
-- 
2.43.0

