Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804645;
	b=tnnGpIA0/rjqUwjHe79Cq3m4NOAz+vDSvXyUs77Xh7LFedA/c5CuoXWIUREfzPWCnXmg
	 WNznqsQMzqNxFDrBFp66/j+OhxG+AKinQWx+QV0YC4vB8wBQpI2h78Y2he5m5+mMVuYDY
	 8TaID7G/j2Qqo82Rvmn0NmEarMG86gHNsmgftbrcY1NcMBd1YxBjoOEaz30OeUIS8VL2I
	 e8blJjboHGXtLjs5UHP4L17EWlLxMMxu6dAEgIdTBdQUuvXuNO+BJvmU2dXsjw+cFUDXG
	 EXTRxYJKdjrAGAPb2SfLozbkaO8eOTeRpAoVdhDTxto27Ku6PTRY+i5iThIALKbDPLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=37YpjaOgNccrGcYsvQbgZqV6HiURURtIIQXB5fcYtQQ=;
	b=l5ayChtgPWIZNY1mOZDVnAnzLo+iMnad3A9sJoaN1BvInrF/UjIRZGTDH0pNR/oTM8nn
	 zULGQWb/uNLjzXlMT3guf4EHf6tZf8jJfncp/38EkzJCiKHCROFrggVFP5NYvlsBlg1Ss
	 XkVKf5P1B2t0ythYzj1iGBdF9F3jKrJh1PQCjZ8UX52uUc3EJK9E8+RnFPAufszKR5CJc
	 dNRxZPg9u7maB4ffIg5KAkBVPI70kMZPXbIDY1k3Zb06yrJVoeV3l0kmZQLs7VQxr5X66
	 o3i6GAZxHugmryhfZxD79Hln3AmSlLXxbzGpGPMLOAzVBpJGPTla9avLPQD9yMGQ6Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVHSuLsZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA86606A32D;
	Wed,  4 Nov 2026 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVHSuLsZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492131F00919;
	Wed,  4 Nov 2026 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804644;
	bh=37YpjaOgNccrGcYsvQbgZqV6HiURURtIIQXB5fcYtQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVHSuLsZL6mz71XqI0NoifxWphWSKFWfitBn84QOxNc8Z0e+QG5j0gebPyOSDom0I
	 7BK97oLwjXGS4ynLyXW08w4/GTz6+XCv+//Y29VGlpQ4VEcro3MvSE57Pq3sMiTvOR
	 oe1d91OWfW2YYlNomdAJJgYAyfY42AE8/FO89mtZtEJdMdPuxsRsbuiInatwZTt2mR
	 ZuROz84xJLCuXL6aghR/2i8huRlIOn3Z+4MHhIGN/IM0LTTFnf4oy7iFSwWCJSV4Vn
	 dNXJnTS0KFdRBLOsLnSuJBkDsBraOdqLv7vKPfTuPooiGW+9QaKFlI30pELwIiVLhK
	 5QGQusNEBq0Uw==
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
Subject: [RFC PATCH v4 05/25] KVM: guest_memfd: Split population by backing type
Date: Wed,  4 Nov 2026 20:33:02 +0530
Message-ID: <20261104150322.3516320-6-aneesh.kumar@kernel.org>
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
index 4280c3b740ef..5a4da27f0434 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -32,6 +32,7 @@ struct gmem_file {
 };
 
 struct kvm_gmem_backing_ops {
+	int (*populate)(struct inode *inode, pgoff_t start, pgoff_t end);
 	int (*revoke)(struct inode *inode, pgoff_t start, pgoff_t end,
 		const unsigned long *pfn, bool put_pfn_range);
 	/*
@@ -578,46 +579,11 @@ int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
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
@@ -645,7 +611,60 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
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
@@ -1122,6 +1141,7 @@ static int kvm_gmem_ram_prepare_pfn(struct kvm *kvm, gfn_t gfn,
 }
 
 static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
+	.populate = kvm_gmem_folio_populate,
 	.revoke = kvm_gmem_folio_revoke,
 	.prepare_attributes = kvm_gmem_folio_prepare_attributes,
 	.convert_attributes = kvm_gmem_folio_convert_attributes,
@@ -1129,6 +1149,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_folio_backing_ops = {
 };
 
 static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
+	.populate = kvm_gmem_ram_pfn_populate,
 	.revoke = kvm_gmem_ram_pfn_revoke,
 	.prepare_attributes = kvm_gmem_ram_pfn_prepare_attributes,
 	.convert_attributes = kvm_gmem_ram_pfn_convert_attributes,
-- 
2.43.0

