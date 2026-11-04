Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804682;
	b=hHg5SsbrL5ar8QSx8ikRQ+Zmw07VkFxxKEvX+o2a1o0Rfq+n7SRKdKwYYfpDkZ7mS7al
	 jy1CphuK4uVQkYThpqnKsEK3R7nM57z5EujIQpqoPHzoCYI68k8e/rYwRR2P3kJKiETye
	 JtObXrxIZiJgaQY2eeTnp165e8PRUhLKBq403ixVWjA040jUxoUVH8UcfD0gajRE6D+Rq
	 KVZFGWRS/Wz5n2h6kajMaCSK7nUkcmuGgGK4eTXCbxNjQr2NLmxmW5/LXHqV4cuycN/W4
	 fM8dQHuiQv2UMJJwS0rc61NUeRH3OCEFYNvbUpNBd+gSPOLNiuT8y02tjVYzW5R1ZKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1ezqaL5YD96duRGS4vjO9PfU32AuIITUbuJkJoKchdQ=;
	b=Yw3Sc3S2g9TrBQTx8HareJZNJYxTkHxrhbCQfDPovXNnQq8rLFksdJX1fih8ka26uadz
	 eeHbFf22hYRprC362ZjEAXv8CVQq2J0nMyc+8CZjgzlhPv07HX8xgmb06S9u2la2FliCX
	 fARYL7ekvIXKxaFxzEXq6kAjnJ52EZaMGrAqI2vzeucB1IcNY25xIn0fj5Td/XPU3L5U+
	 sJNIAURFQ7mJoSxR41vdNRZOrfLs4ZZxAN5+cOBDBu+VL9t/fgl7wJlUNbN9wa4O9xkd9
	 q5KB1WXzXZ2ihtg6dBlAYGRRihBFE6Y1sT1sfCbiT7DRQUiFy5qREabxh7sS8QrM4+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2rCylQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2E5606A334;
	Wed,  4 Nov 2026 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2rCylQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEEB1F000C1;
	Wed,  4 Nov 2026 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804682;
	bh=1ezqaL5YD96duRGS4vjO9PfU32AuIITUbuJkJoKchdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2rCylQToQBALP5dXjvWVnmedyrtLWNAfqslsUAKennkoQN5ZzpvnqZ1b1bZdInpK
	 KcoWdmv5OtKBzFjg00jxiEAVA8Y7aklnDAhyZJ5emsVBqH+6Cvy1Qt42yQzl3YjDyx
	 qCjXrig4PG7nEHP84DVP1GLbWOiC7tR1pYFB1SpIw1jHXUIIgsnqGJrjS5M3TshOfb
	 ppZloNGWY43TmzXRCATJ1Qo1m26BcRHPnMJjUECVDYL6Z3qTndEnjoR8XVsCaDW5Ux
	 m65ydbYgVv1ybdUNWN3Bi0PzlHF9ykRcqdJqoNOw0i8DCYy6lurnNEajFmhTX+ApEG
	 +5gRa1RGUJdqw==
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
Subject: [RFC PATCH v4 11/25] KVM: guest_memfd: Clear private device state on final close
Date: Wed,  4 Nov 2026 20:33:08 +0530
Message-ID: <20261104150322.3516320-12-aneesh.kumar@kernel.org>
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

Add an optional backing release() callback after the generic
file-release path invalidates guest mappings. Device backing uses it to
clear has_private_ranges so device cleanup can proceed after the last
file user is gone.

Hold the provider lock across invalidation and the release callback so
device unlock cannot race with mapping removal and summary updates.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index dd567979d938..d3de2e7bb9f5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -65,6 +65,12 @@ struct kvm_gmem_backing_ops {
 			   kvm_pfn_t nr_pages, u64 attrs);
 	/* Called after the common code stores the new attributes. */
 	void (*update_attributes)(struct inode *inode);
+	/*
+	 * Finish file cleanup after invalidation. Caller holds kvm->slots_lock
+	 * and inode->i_mapping->invalidate_lock for write, between calls to
+	 * gmem_provider_lock() and gmem_provider_unlock().
+	 */
+	void (*release)(struct inode *inode);
 };
 
 struct gmem_inode {
@@ -104,6 +110,7 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 static void kvm_gmem_device_update_attributes(struct inode *inode);
 static int kvm_gmem_device_convert_attributes(struct inode *inode, pgoff_t start,
 					      pgoff_t end, u64 attrs);
+static void kvm_gmem_device_release(struct inode *inode);
 
 static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
 {
@@ -751,9 +758,11 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	struct gmem_file *f = file->private_data;
+	struct gmem_inode *gi = GMEM_I(inode);
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
+	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 
 	/*
 	 * Prevent concurrent attempts to *unbind* a memslot.  This is the last
@@ -766,6 +775,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 
 	filemap_invalidate_lock(inode->i_mapping);
 
+	gmem_provider_lock(gi);
+
 	/*
 	 * Note!  synchronize_srcu() is _not_ needed after nullifying memslot
 	 * bindings as slot->gmem.file cannot be set back to a non-null value
@@ -815,13 +826,15 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 		WRITE_ONCE(slot->gmem.file, NULL);
 
 	/*
-	 * All in-flight operations are gone and new bindings can be created.
+	 * All in-flight operations are gone and no new bindings can be created.
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_start(f, 0, -1ul,
-				    kvm_gmem_get_all_gfns_filter(inode));
+	__kvm_gmem_invalidate_start(f, 0, -1ul, filter);
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
+	if (gi->backing_ops && gi->backing_ops->release)
+		gi->backing_ops->release(inode);
+	gmem_provider_unlock(gi);
 
 	list_del(&f->entry);
 
@@ -1228,6 +1241,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
 	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
 	.convert_attributes = kvm_gmem_device_convert_attributes,
 	.update_attributes = kvm_gmem_device_update_attributes,
+	.release = kvm_gmem_device_release,
 };
 
 static const struct kvm_gmem_backing_ops *
@@ -1638,6 +1652,12 @@ static int kvm_gmem_device_convert_attributes(struct inode *inode, pgoff_t start
 	return 0;
 }
 
+/* No file users remain, so private attributes cannot create new mappings. */
+static void kvm_gmem_device_release(struct inode *inode)
+{
+	WRITE_ONCE(GMEM_I(inode)->device.has_private_ranges, false);
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resource_fd)
 {
 	static const char *name = "[kvm-gmem]";
-- 
2.43.0

