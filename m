Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517614;
	b=kasPcBk09EzKxZZ6yZqfjnwM6ia77anE3Cv35k33xBGW4pmMXoApMvnIso/sWmU1ee3n
	 niDe2qVJSHO8arU3+qLj5ErVCTv1bAWf9tw8A/tlFsWpP5gQkWVIGWPa+HVzsfb17OdNL
	 LUXDNY92L3+kQcBoyYNcAFhmKAkdApBanmwT873QwFDGuZQC4XFugYvQuJGQI0L/0JfLH
	 /mzBTTWndcqAq1OH1as+dqEApVa9FzoXQoS2piBNO2fO9NORRSGMOsDxW+sFMgqpVWGW2
	 g30qCzAUGz5PXuWB1PCxfG+qvK1KJA2MvJjBdu9O0qzE442XP5XtJ1QZLrTVmHHCu9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bs4uyaPnZxshU4E3g1QcBPm+s3NabikRYvRg5CpDYo8=;
	b=hukCp5dxLVluw/feFliBFMs/iYga+LZ25VrkCjXSB5iNMSt1CkoUTBux8x91o/yc9eKa
	 WhrQzAOJJzvDkNbiYkpavojDTfsyf6rIGSBjevityoBTYrO3jlZT0RgWpzGQ/hvUw48jo
	 0PerV5m7rZqwh4jhjEXp9TgmrIVDXY/8VgrHveTg4gLx99HO5DC8Yf70iS3gOMNJJywZE
	 PcHkbRZF27V4JT3yUWRW6qTvNiv1kHYPEI65srt0GoZaEsPCtFTF0D8CVM6iVmVlhj7D5
	 qHWRBQKPQBS5jYVsfjUDN2pW8KP9nZylMacDoTidzfMbVBvy7X+349FMMn2Iq9I8DMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RaVQFQOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB46606A32F;
	Sun,  1 Nov 2026 07:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RaVQFQOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBD51F000C1;
	Sun,  1 Nov 2026 07:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517614;
	bh=bs4uyaPnZxshU4E3g1QcBPm+s3NabikRYvRg5CpDYo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RaVQFQOrwecivmDcVvLNIUJkJwv3ybvR7d0PoEfGS4wC08nzWURNNjdmvvTsxB6UD
	 CWrhJAh0MlhpxjrC+nPZp/bH5HMt9TEoB4e4/DvoZdcFPGH0+cBC7j/XcbjwXhWj9k
	 nEO5PyF/TvU8mzqqU9M3nQkkQ+uZ78jyYQsxRBJy8BwpZ5Ic3wenH+aEW6Ngh5kYbw
	 FrQCbLtXQHfJVNsoFtQ3MWZxFa5sQVCjumfCrUmA0yI9YfPTETH4p9QtZhZPZaRHEQ
	 S+DcuO1hatQsEgh20rvdMin/0lQIrRO3F+JK3n1tAb7B4gtoSsbdxZ7AOqMqtaOkLY
	 jH4knRlLAxA5A==
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
Subject: [RFC PATCH v3 04/13] KVM: guest_memfd: Dispatch revocation through backing operations
Date: Sun,  1 Nov 2026 12:49:18 +0530
Message-ID: <20261101071928.2462549-5-aneesh.kumar@kernel.org>
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
index d1060b4c785f..6c91fec0259e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -34,6 +34,8 @@ struct gmem_file {
 static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot);
 
 struct kvm_gmem_backing_ops {
+	int (*revoke)(struct inode *inode, pgoff_t start, pgoff_t end,
+		const unsigned long *pfn, bool put_pfn_range);
 	int (*prepare_attributes)(struct inode *inode, pgoff_t start,
 			size_t nr_pages, u64 attrs, pgoff_t *err_index);
 	int (*make_private)(struct inode *inode, pgoff_t start, pgoff_t end);
@@ -481,14 +483,48 @@ static void kvm_gmem_pfn_reclaim(struct gmem_inode *gi, pgoff_t start, pgoff_t e
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
@@ -497,8 +533,6 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 	if (!nr_pages)
 		return 0;
 
-	offset = (loff_t)start << PAGE_SHIFT;
-	len = (loff_t)nr_pages << PAGE_SHIFT;
 	end = start + nr_pages;
 
 	/*
@@ -507,27 +541,17 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
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
@@ -1073,6 +1097,7 @@ static int kvm_gmem_ram_prepare_private_pfn(struct kvm *kvm, gfn_t gfn,
 }
 
 static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
+	.revoke = kvm_gmem_folio_revoke,
 	.prepare_attributes = kvm_gmem_folio_prepare_attributes,
 	.make_private = kvm_gmem_noop_conversion,
 	.make_shared = kvm_gmem_folio_make_shared,
@@ -1080,6 +1105,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
 };
 
 static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
+	.revoke = kvm_gmem_ram_pfn_revoke,
 	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
 	.make_private = kvm_gmem_noop_conversion,
 	.make_shared = kvm_gmem_ram_pfn_make_shared,
-- 
2.43.0

