Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804639;
	b=f/84yAnaGKq6cYFYRFxjDu8HSPsNAvMFZKRV1II9QaXJr09LqKqyBAcdX7CqB0rY/uYi
	 C65zQrbaB7bJzO0fv1YiV/XxsDh8L29E02mOWfpt4xInIjFDvJq1Nbisy3qnQ/TuBegnE
	 0i243wlX1RE3xfwPtUWlzEJflOWVIgHlue/cSAwGHZv1i5odtMJfpDV0eZPNQLxIj5/QI
	 FzdhyD6KOYbWlv5ReOi1ew06ORCulSoobaOFSqj6N0YUQeDSw6xiTAnveUgwI4Hx+47Hu
	 FKHYb0N0SZcKvkevcuZKl+AE3gBWNRvFyvW3iRMP8pmRK8cytCiewZEZ1KuIB7gX7qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=22FBzhEimgUJAz+7WuE5Wz0zgC4u7PHGyV0ZGAglNwQ=;
	b=0rFtfK/TDiVa8l4d7pDv9fT/LRk7ShlEf5MHDHxp2T+TS3A1by2JB9VxT1Vfg2LOMwJr
	 jP/6BQdLsHdOJ7f+EG9KWcXOFEpNUxZmGjM/LY26ioSY5nqaGqVG5W1ufb251xdhkGqHR
	 QsoNxSd+R3jN1bJggMnXe0szGYPYNbSJjX0xYR8l9HxEMm5x6Ql8Na4co9SlXfEil3b8P
	 wZSIXRTONLP8NV77XngCfFss9hnbZIiPEnAYQNu1QDzXzDzQP/loiD12z1Ybfq4OpuLQh
	 vxulPZsljwvAbyNpulmHaT8g3tr1oIIUtudAAS1IL07CNbOV0lWFIz/IFmga2rUpsrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKlhmCTz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B87606D835;
	Wed,  4 Nov 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKlhmCTz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B321F000C1;
	Wed,  4 Nov 2026 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804638;
	bh=22FBzhEimgUJAz+7WuE5Wz0zgC4u7PHGyV0ZGAglNwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKlhmCTzHWtx1T6JKsEsHCkUruKkAtHE2YobbqZy4kxzIq4UY/pUtJ4/h0QAmA1rQ
	 hWZQCp6UzNPWGkaIaw6grooR9laiD/S2caNZfmdow/Va+SvO6mPSf6KpPTFTixTb4T
	 UHftqLPRZqewcV3EJ5fo3Gam2XxrqFP5b/ATrN9wbahrEs98JQfD/tfGLwBUh7njdj
	 nkTqUjkgrMhwE8SvsgfLSxtucl064jdFWQ+uksf97kjTulpxpE/O0VD1cEN6+qnicn
	 AED4ph1AQ+6PcV5s3np6WPAi9UurFY/isz3TjHXsXgyEAhiK6GrKo7qSBkrwKgK1jn
	 5OJGXh/cgCNvg==
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
Subject: [RFC PATCH v4 04/25] KVM: guest_memfd: Dispatch revocation through backing operations
Date: Wed,  4 Nov 2026 20:33:01 +0530
Message-ID: <20261104150322.3516320-5-aneesh.kumar@kernel.org>
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

Revocation truncates cached folios for folio backing, while RAM PFN
backing unmaps host mappings, reclaims architecture state and optionally
releases provider PFNs. Move that into backing-specific revoke()
operations.

Hold optional provider exclusion across invalidation and revocation,
inside the inode invalidate lock. Keep reclamation and provider PFN
release in the backing operation rather than the common sequence.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 62 ++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 20c72693c210..4280c3b740ef 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -32,6 +32,8 @@ struct gmem_file {
 };
 
 struct kvm_gmem_backing_ops {
+	int (*revoke)(struct inode *inode, pgoff_t start, pgoff_t end,
+		const unsigned long *pfn, bool put_pfn_range);
 	/*
 	 * Validate the transition before gmem_provider_lock(), guest invalidation
 	 * and conversion. Caller holds inode->i_mapping->invalidate_lock for write.
@@ -473,14 +475,48 @@ static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t e
 static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t end) {}
 #endif
 
+static int kvm_gmem_folio_revoke(struct inode *inode, pgoff_t start, pgoff_t end,
+		const unsigned long *pfn, bool put_pfn_range)
+{
+	loff_t offset = (loff_t)start << PAGE_SHIFT;
+	loff_t len = (loff_t)(end - start) << PAGE_SHIFT;
+
+	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	return 0;
+}
+
+static int kvm_gmem_ram_pfn_revoke(struct inode *inode, pgoff_t start, pgoff_t end,
+		const unsigned long *pfn, bool put_pfn_range)
+{
+	loff_t offset = (loff_t)start << PAGE_SHIFT;
+	loff_t len = (loff_t)(end - start) << PAGE_SHIFT;
+	size_t nr_pages = end - start;
+
+	unmap_mapping_range(inode->i_mapping, offset, len, 0);
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+	if (pfn)
+		kvm_arch_gmem_reclaim(*pfn, nr_pages);
+	else
+		kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
+#endif
+	if (put_pfn_range)
+		gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
+	return 0;
+}
+
 static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 			      size_t nr_pages, const unsigned long *pfn,
 			      bool put_pfn_range)
 {
 	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 	pgoff_t max_pages = i_size_read(inode) >> PAGE_SHIFT;
-	loff_t offset, len;
+	struct gmem_inode *gi = GMEM_I(inode);
+	const struct kvm_gmem_backing_ops *ops = gi->backing_ops;
 	pgoff_t end;
+	int r;
+
+	if (!ops->revoke)
+		return -EOPNOTSUPP;
 
 	if (start >= max_pages)
 		return 0;
@@ -489,8 +525,6 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 	if (!nr_pages)
 		return 0;
 
-	offset = (loff_t)start << PAGE_SHIFT;
-	len = (loff_t)nr_pages << PAGE_SHIFT;
 	end = start + nr_pages;
 
 	/*
@@ -499,27 +533,17 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
+	gmem_provider_lock(gi);
+
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
-	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
-		unmap_mapping_range(inode->i_mapping, offset, len, 0);
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
-		if (pfn)
-			kvm_arch_gmem_reclaim(*pfn, nr_pages);
-		else
-			kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
-#endif
-		if (put_pfn_range)
-			gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
-	} else {
-		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
-	}
+	r = ops->revoke(inode, start, end, pfn, put_pfn_range);
 
 	kvm_gmem_invalidate_end(inode, start, end);
-
+	gmem_provider_unlock(gi);
 	filemap_invalidate_unlock(inode->i_mapping);
 
-	return 0;
+	return r;
 }
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
@@ -1098,12 +1122,14 @@ static int kvm_gmem_ram_prepare_pfn(struct kvm *kvm, gfn_t gfn,
 }
 
 static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
+	.revoke = kvm_gmem_folio_revoke,
 	.prepare_attributes = kvm_gmem_folio_prepare_attributes,
 	.convert_attributes = kvm_gmem_folio_convert_attributes,
 	.prepare_pfn = kvm_gmem_ram_prepare_pfn,
 };
 
 static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
+	.revoke = kvm_gmem_ram_pfn_revoke,
 	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
 	.convert_attributes = kvm_gmem_ram_pfn_convert_attributes,
 	.prepare_pfn = kvm_gmem_ram_prepare_pfn,
-- 
2.43.0

