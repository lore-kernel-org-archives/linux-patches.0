Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517676;
	b=rl2v+sYCwx5KQcaln4pkeQCBwpsDpVBI8TpKTzztdm/5Hkw8j78bFbsa+vBHwgl67V+s
	 jtxZmWj8x7GnQ1RxSW92v9m/cRJYAxkGQF06iVG9om/NDs7dEBqPlWLvKRb1pa7PcnIrv
	 v7jyX+V3jaShetUHesPpDj9xEafBU5ifFuh8p7SEhghW/sFy2pIZi48FleYH3xp/GNdQP
	 VF+QJVRZc+u7n3+h8CAhCubSSI2472tbyKRknc+9MvdvBQ+BdnrbLudk9ftimm3x3xwfc
	 gIs2nVMUG9IyS+3Xe1wqJEPQD8XFnx4IevrH19H7os5qS+3y3GDs5QJgtDKGWSFj0Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=D4m/JGcSpfWlUHNyq+HDug6O08cNq5+XlprpGwSmc5Q=;
	b=v6IasUjeqx2f5xyJukjHOdCoIMpflnD4Aa3bXcC4laNfrJQ9VsUGktn+cXfJPzl/d89N
	 rhWq39a/SueE5TjVvCvej27cEUCd3qV9Xn4izSBR0BYhzCiCmCfB2YhF25ITHJrh4RwyM
	 evmjUJK5O4TJPfms20N/JoJM1EJjh7QoZc1iiZrnL/tGuyryMAfS9X0n7/kYf0f/flFNW
	 03P22kJFVDZgA0PC0vtnnZY8+oC94ig+JeIC1ThcpHpvXN6x3aBuof/AVJWpJFSxvA/cc
	 foassO0xPKabaQaDYiCanDh3iZcY+VN0TXQYOJjW6wERKPe6EhuGrfIR31U6dxLxoIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2E5pWYL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6C8606A324;
	Sun,  1 Nov 2026 07:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2E5pWYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B3F1F000C1;
	Sun,  1 Nov 2026 07:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517675;
	bh=D4m/JGcSpfWlUHNyq+HDug6O08cNq5+XlprpGwSmc5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2E5pWYLTvOJj1yYbIBlGDUj/ndVsun8A6oGmfLzXsyCcuI8ortKI7UawVnA3VCsr
	 WkF1gDLM/+IcC5u+aY7OIYhBCEF/QCnOULdh3lhTUAGnq5/KXIX1iH2dPrCRasFQi1
	 uZ4/qz60sSDZHRWiIoLNv7c6c1J71vIfJavXKpSA+H+w3HQAok9WruFAGMQBiEpu5S
	 NlljdKR695PPd82CemW5GVgrSuwviaVftmIOqywAiHsus7nZmtmi4Eq3+usohbziA2
	 GXHunXUiNTqF+DLCuQaKihvsBzfxvomWMrjhwQNItkBm8LTx5/x5wa0Cfp+Z03ZsE2
	 QM2QlwsmiDxAg==
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
Subject: [RFC PATCH v3 12/13] KVM: guest_memfd: Remove device mappings on final close
Date: Sun,  1 Nov 2026 12:49:26 +0530
Message-ID: <20261101071928.2462549-13-aneesh.kumar@kernel.org>
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

Remove device mappings before dropping the file's VM reference. Keep
memslot bindings available so invalidation can resolve device ranges to
guest addresses.

Hold the inode invalidate lock and provider exclusion across one common
invalidation interval covering both shared and private mappings. Clear
the slot file pointers before invalidation and remove bindings afterward.

Add an optional backing release() operation after invalidation. Device
backing clears its inode-owned private-range summary there, allowing TDI
cleanup after the last file user is gone. Do not convert file attributes
or reclaim BAR PFNs. Provider resources remain pinned until inode cleanup.
Guard callbacks for failed attachment before provider setup completes.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 7989c093a209..22793d3c6aff 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -47,6 +47,8 @@ struct kvm_gmem_backing_ops {
 				   kvm_pfn_t nr_pages);
 	/* Called after the common code stores the new attributes. */
 	void (*update_attributes)(struct inode *inode);
+	/* Finish file cleanup after invalidation, under provider exclusion. */
+	void (*release)(struct inode *inode);
 };
 
 struct gmem_inode {
@@ -86,6 +88,7 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 
 static void kvm_gmem_device_update_attributes(struct inode *inode);
 static int kvm_gmem_device_make_private(struct inode *inode, pgoff_t start, pgoff_t end);
+static void kvm_gmem_device_release(struct inode *inode);
 static bool gmem_device_has_private(struct guest_memfd_device *gdev);
 
 struct guest_memfd_device *kvm_gmem_get_device(struct inode *inode)
@@ -772,9 +775,11 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
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
@@ -793,17 +798,21 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 
 	filemap_invalidate_lock(inode->i_mapping);
 
+	gmem_provider_lock(gi);
+
 	xa_for_each(&f->bindings, index, slot)
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
 
@@ -1219,6 +1228,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
 	.make_private = kvm_gmem_device_make_private,
 	.make_shared = kvm_gmem_noop_conversion,
 	.update_attributes = kvm_gmem_device_update_attributes,
+	.release = kvm_gmem_device_release,
 };
 
 static const struct kvm_gmem_backing_ops *
@@ -1627,6 +1637,12 @@ static int kvm_gmem_device_make_private(struct inode *inode, pgoff_t start,
 	return 0;
 }
 
+/* No file users remain, so private attributes cannot create new mappings. */
+static void kvm_gmem_device_release(struct inode *inode)
+{
+	WRITE_ONCE(GMEM_I(inode)->device_has_private, false);
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resource_fd)
 {
 	static const char *name = "[kvm-gmem]";
-- 
2.43.0

