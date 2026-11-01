Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517622;
	b=KaKOyuxzaJaGOunP/WmcQtJJFo0pbWTbuLAhIRI50j6iq/QradDU3RkQMtTph/t5K10G
	 3m7wPiqEbb/CMLviZkPJgApVPFpfWFrM/h6MJh8KQl7nUHj0Qm/UWsYLMdxUWOOz9VJH3
	 Q0sFz7Y9oWAaBCOBfGdhdWTtdFO54dnI+bKkDjbK6zFmEzp8h1shwnGsRxCUCSSBmVv85
	 iT8MCdCaiZTbIepKYMlttt/UavnyjvIcDP5sRKP4qau0RJk4Oi5g7XwMUWw/1QNGOMdku
	 wXIwalxjjzODVhj/dCSf7qXdiIu/9NU2nOznvyNMYR0jZtLw/ZUJUtlIq1StkkjV5sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WH8Xi2CQ6sm/MJzbjCLqtw/uq9YBVX1Uip9zya/PqPc=;
	b=uRf2oQ6kZNLHmsnJ+x1YfT5C8+6MvjQkdjCN3yJP4KRKDQDY034JpGhfau/sJRVLN20e
	 RTCOTPWMOVrxyeXLhUM3OkailDYJfGwdNIfJzabKHo/vEwxVlU1hXOBSU4BuuDdI034cX
	 6sSCUV44lkq+vF7ZSDdMTfs8lg27rulFyqULrjJDHMjrrDGxJSUXVY6vMaIFm0wniqnIW
	 vB2suFWphxlAuj4uQfcNQ86jEdtZ5fDJ60den4ndAPugXaEo0IZRNie7+ASU4cwgd4j03
	 zU30wy2s4lutiH6y0rvCPlAScQgMSns3OBC4XTZ5+yDuk+qA4ZwWJj3Ob3j2AIxPlNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqQznpi+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4546A606A324;
	Sun,  1 Nov 2026 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqQznpi+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26361F00A17;
	Sun,  1 Nov 2026 07:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517622;
	bh=WH8Xi2CQ6sm/MJzbjCLqtw/uq9YBVX1Uip9zya/PqPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqQznpi+4yl0qwTJHH+6gJniqhjWdb9rQhjMDqz7q7aSmc0MWj+GDsdujXay9gQ1c
	 kAiddQIxHbZRuylX+sgwVxia7kMEKJ6cgcelWHC1nIZliNtsPsISFMlct6QbDJhpWe
	 zjv4csY2AL5KXAZc6XqG1v/znGN5ooaWPOSNzhhMyucC4Fnu+wrHtn9EEDIVFYHuD9
	 hM73sUSk4qLdpb+LjsOpyL3XHEn2APejReJojWCNqHa4TtwXAZIXJ2jEBnC56pmqQD
	 7ObWiT+SxnLE3FTegFdHHyZg9DLYoFGM36gvbBDj8cW2zEyJj3RlV4f2BZo44Ip7Mi
	 O06HtKxkJv0Rg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v3 05/13] KVM: guest_memfd: Split population by backing type
Date: Sun,  1 Nov 2026 12:49:19 +0530
Message-ID: <20261101071928.2462549-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
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

Preallocation obtains cached folios for folio backing and walks provider
PFN ranges for RAM PFN backing. Both use the same range validation and
shared inode invalidate lock.

Move the two walks into backing-specific populate() operations. Keep
size checks and locking in kvm_gmem_allocate(), preserving signal
handling, folio references and PFN range stepping.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 101 +++++++++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 40 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6c91fec0259e..4c2fe151c33d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -34,6 +34,7 @@ struct gmem_file {
 static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot);
 
 struct kvm_gmem_backing_ops {
+	int (*populate)(struct inode *inode, pgoff_t start, pgoff_t end);
 	int (*revoke)(struct inode *inode, pgoff_t start, pgoff_t end,
 		const unsigned long *pfn, bool put_pfn_range);
 	int (*prepare_attributes)(struct inode *inode, pgoff_t start,
@@ -586,46 +587,11 @@ int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_revoke);
 
-static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
+static int kvm_gmem_folio_populate(struct inode *inode,
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
-			int max_order = 0;
-			kvm_pfn_t pfn;
-
-			if (signal_pending(current)) {
-				r = -EINTR;
-				break;
-			}
-
-			r = gmem_provider_get_pfn(gi, index, &pfn, &max_order);
-			if (r)
-				break;
-
-			max_nr_pages = 1UL << max_order;
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
@@ -653,7 +619,60 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		cond_resched();
 	}
 
-out_unlock:
+	return r;
+}
+
+static int kvm_gmem_ram_pfn_populate(struct inode *inode,
+		pgoff_t start, pgoff_t end)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t index;
+	int r = 0;
+
+	for (index = start; index < end; ) {
+		pgoff_t next_boundary;
+		pgoff_t max_nr_pages;
+		int max_order = 0;
+		kvm_pfn_t pfn;
+
+		if (signal_pending(current)) {
+			r = -EINTR;
+			break;
+		}
+
+		r = gmem_provider_get_pfn(gi, index, &pfn, &max_order);
+		if (r)
+			break;
+
+		max_nr_pages = 1UL << max_order;
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
+	const struct kvm_gmem_backing_ops *ops = GMEM_I(inode)->backing_ops;
+	pgoff_t start, end;
+	int r;
+
+	if (!ops->populate)
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
+	r = ops->populate(inode, start, end);
+
 	filemap_invalidate_unlock_shared(mapping);
 
 	return r;
@@ -1097,6 +1116,7 @@ static int kvm_gmem_ram_prepare_private_pfn(struct kvm *kvm, gfn_t gfn,
 }
 
 static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
+	.populate = kvm_gmem_folio_populate,
 	.revoke = kvm_gmem_folio_revoke,
 	.prepare_attributes = kvm_gmem_folio_prepare_attributes,
 	.make_private = kvm_gmem_noop_conversion,
@@ -1105,6 +1125,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
 };
 
 static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
+	.populate = kvm_gmem_ram_pfn_populate,
 	.revoke = kvm_gmem_ram_pfn_revoke,
 	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
 	.make_private = kvm_gmem_noop_conversion,
-- 
2.43.0

