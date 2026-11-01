Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517684;
	b=qX+baJ+aAHXzfSiHn7jSqlbXLHdgxd1XU4YKbWEk5KpqbJrvlhVuo/S31F5+NjHJvOnO
	 5TYqTksmVCr0sEGev/CQPbxX2yU4mHvkC9qIIwpVUCDw3Ot8DuRLESrZlx1dwipo2rVZA
	 LmJ928GhOYyel7GedjPeJohxlgNYrv379ZR8bxllY7B4ENRzE2iJoGcfXgxnvBTCcorwL
	 A3oYzXmKlnu4DstVtUYErXr5Xm3TbOzK1sffP1h3ld86VYUyu7Lg/WlNRbKtlZxECWwhF
	 YsPZMAU9q/3kES4lAzkb3Wl260Dv2BUwoIskm1GYLtSJPjmKNxSXzVTKE62HfXk3dmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CnxSQSFjhZxe9NmxENfG/6Wbtj2Pz639pTmWBCT8kqk=;
	b=kxxieN3ecWAjK2W12OE6OFwv9ERIJEZkKQfcBbPkJH0CundkweHsekHM6vM0YCRJa/9P
	 7iaWbf2Eg05mT22Z0fMyOXL6TvCU83HcOAqZ6yxLP00ZpaFNjOq+juAq4q/pIpy/MlON5
	 76aG95nR9egxwo3xw+bibXaTQca+mxtZuZgLWETqfAsXmLKgbQ5mX5hUoCD4AchCEGPOT
	 rFk04IffX1XYyDDChnnsS9EA1Bo8kXt48T7ern98MM88STfzniABDklT+iOBTuO5xhw4Y
	 GKXtNgByLccjPAFSW4psm9llyJezZusywRxcYoATvvne8tuDrJLSjsUrTIzw8Vz6xTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPK+0Yfs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73D9606A324;
	Sun,  1 Nov 2026 07:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPK+0Yfs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6343D1F000C1;
	Sun,  1 Nov 2026 07:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517683;
	bh=CnxSQSFjhZxe9NmxENfG/6Wbtj2Pz639pTmWBCT8kqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPK+0YfsNec0hVI9LHu79lAkoTO4nTXpjPa4OCqL+HXaFaS77bq2FqzmljkXGGmJd
	 lP5rW/wTrabPqKhI6Z/Ww8bvtvDGALqaWPqzWq/S37H18F7mvGl9a6+urbj4xs1XRn
	 mTpP3x2VPuKT9CLB/QoZHK2p8xNmtIUnE/WY0iVul+UWWXiDSMjPbxxvEL3+lnKh7x
	 hOJ/NK2uvc50fh9y0Mwtj0joChmTglDdYKt1LI7gYEd47O0qndHT8bK9n4MWT+0sfi
	 znUGJwPxyyyGBnLnflI34Eyl08vake8TL9lKLirqEqqY/GbYBvIsHH627cN0cQoSkS
	 wa0/Qy0tHgw7g==
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
Subject: [RFC PATCH v3 13/13] KVM: guest_memfd: Invalidate guest_memfd mappings before removing memslot bindings
Date: Sun,  1 Nov 2026 12:49:27 +0530
Message-ID: <20261101071928.2462549-14-aneesh.kumar@kernel.org>
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

Unmap guest_memfd ranges before removing their offset-to-GPA bindings.
Invalidate shared and private mappings while holding inode and provider
exclusion, using the same common invalidation path as revocation.

Do not convert device attributes when deleting a memslot. Private file
attributes continue to block TDI UNLOCK after unbind; userspace must
explicitly share those ranges or release the last file reference.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 22793d3c6aff..e31234212dcf 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1860,6 +1860,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
 	struct gmem_file *f;
+	struct gmem_inode *gi;
+	enum kvm_gfn_range_filter filter;
 
 	/*
 	 * Nothing to do if the underlying file was _already_ closed, as
@@ -1879,8 +1881,13 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * drops slots_lock, so there's no need to verify the file is live.
 	 */
 	f = file->private_data;
+	gi = GMEM_I(file_inode(file));
+	filter = kvm_gmem_get_all_gfns_filter(file_inode(file));
 
 	filemap_invalidate_lock(file->f_mapping);
+	gmem_provider_lock(gi);
+	__kvm_gmem_invalidate_start(f, start, end, filter);
+	__kvm_gmem_invalidate_end(f, start, end);
 	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
 
 	/*
@@ -1888,6 +1895,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * cannot see this memslot.
 	 */
 	WRITE_ONCE(slot->gmem.file, NULL);
+	gmem_provider_unlock(gi);
 	filemap_invalidate_unlock(file->f_mapping);
 }
 
-- 
2.43.0

