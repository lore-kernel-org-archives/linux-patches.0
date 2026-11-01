Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517591;
	b=P0w6s2p+SQUqn9kB2rGzJscPOmqE9HJ2aSAD+5YObldqykFGppwz0fcXjPL8vR/yVnf3
	 fHhah1ThuKzyyt/AS+MhpfoS486Kso3lGxOGtfz3FBJ/qKlr5a/Wt7ZEo5wva3LDIcoi2
	 VSicEtxllpWMsWLKst5JqHKrWT8vHHdxxAxiJLULdc1HgwtMh/voAVS8jw1tDl5XNWetQ
	 nKx0RB3qGmG5au9kmjjF33NS7JnQyocZeG64+/NPnl2IOgFB/N6zBbgmI0l7l8fRHoW/2
	 a4pl7HBqMBL0WnQC4WJbV0Ljwwe0NJTr4kwDRc4CQ2YqLb2/voJc/vtKuSESPWsWKCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=U2bJvRDpyjkb23YNsRc7TcLbwo8f8tTQB/skY6j1TOw=;
	b=OipOhh6DMTsicQYfgS8Aosr0cljUjN1tsQXW3GJv7uemWDjWvmp9HzoGhhliBO1ic9aA
	 qBWOWXzfcUFm2W7Ew/8XpkT2/OqQ+FPb9Dj6xyZMa6KBLRVtabTsPdFrY8bRQ+unusIi4
	 P7gPnRJHifyoX4ynQRrpp1WDhiXMg1nGKWdQW8fH9IyX0E88Bugkd3dbHgo/utCT2NB+q
	 ALt+TWmHlvbJAP+7dHyMp4HPTZPDrxKnFkIQUQFA1EiVtnv9MMo72FDK1HIyt+vWJigkQ
	 fFARzfavmZjrMqyda3bjU/bAaMIWg6ZMiaVtpHxWperGrmWyHd1r5C+hZtETyfn6Z/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfgB5LKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39137606A327;
	Sun,  1 Nov 2026 07:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfgB5LKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B3C1F00919;
	Sun,  1 Nov 2026 07:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517591;
	bh=U2bJvRDpyjkb23YNsRc7TcLbwo8f8tTQB/skY6j1TOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfgB5LKjKvDqzOEnB9jGLL30LDRIdzaF7S967ilJnZndDaidemtvX1l5knDjMgXU5
	 yP4VzYqUd3b/1rnz+xg9NOZij+IyE1yP8RP1XwzRi+N6NfW7oMJUT+w37UVkhupB6N
	 nvzACqr+VAy6BWkgAiaqGbLnYkrzO7nmUWy0P+oSJ3GCne3kpGXTrZTFH3/uaRjAvO
	 cxMryZhOPLcyHfwuF0UNNTaKhjsdjVxZSfNEvbZutLkZ2U8nGeU4vDNG59iMtusg6v
	 RBTz24G3aBno6XoKyIR5CHbnDRw+LvTRr3MWBEUyqHIengKxfI/IZWklDWO+QQ1sxh
	 GKtPKkGtDZiog==
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
Subject: [RFC PATCH v3 01/13] KVM: guest_memfd: Let providers prepare memory regions
Date: Sun,  1 Nov 2026 12:49:15 +0530
Message-ID: <20261101071928.2462549-2-aneesh.kumar@kernel.org>
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

Memory providers may need to check memslot flags and backing ranges
before KVM installs a memslot. Add an optional prepare_memory_region()
callback to the common provider operations

Pass the byte offset, size and requested dirty-logging and read-only
flags, and return any error before publishing the slot. Providers do not
need access to KVM's memslot structure or internal flags. Existing
providers that do not implement the callback keep their current
behavior.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  8 ++++++++
 virt/kvm/guest_memfd.c      | 17 ++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 3e2c0714ca33..17407504307b 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -14,6 +14,12 @@ struct mempolicy;
  * @attach: Attach to a resource file, perform filesystem-specific validation,
  *          and return an opaque provider context.
  * @release: Release provider context and unpin any resources.
+ * @prepare_memory_region: Optional check of a memory range and preparation of
+ *                         access to its backing memory. Called after common
+ *                         file checks and before publishing the memslot.
+ *                         Offset and size are in bytes. The flags contain only
+ *                         KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY bits.
+ *                         Return 0 on success or a negative error code.
  * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
  *               Must return a pointer to a struct folio on success, or an
  *               ERR_PTR() error code on failure. Must never return NULL.
@@ -44,6 +50,8 @@ struct mempolicy;
 struct guest_memfd_provider_operations {
 	void *(*attach)(struct inode *gmem_inode, struct file *resource_file);
 	void (*release)(void *provider);
+	int (*prepare_memory_region)(void *provider, u64 offset, u64 size,
+				     u32 flags);
 	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
 				     struct mempolicy *mpol);
 	void (*invalidate_folio)(void *provider, struct folio *folio);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index db568ffaebd4..0aae8f9cef88 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1374,10 +1374,11 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
 				   unsigned int fd, uoff_t offset)
 {
 	uoff_t size = slot->npages << PAGE_SHIFT;
+	struct gmem_inode *gi;
 	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
-
+	int ret;
 
 	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
 	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
@@ -1397,10 +1398,24 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
 		goto err;
 
 	inode = file_inode(file);
+	gi = GMEM_I(inode);
 
 	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
 		goto err;
 
+	if (gi->provider_ops->prepare_memory_region) {
+		u32 flags = slot->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY);
+
+		filemap_invalidate_lock_shared(inode->i_mapping);
+		ret = gi->provider_ops->prepare_memory_region(gi->provider, offset,
+							      size, flags);
+		filemap_invalidate_unlock_shared(inode->i_mapping);
+		if (ret) {
+			fput(file);
+			return ret;
+		}
+	}
+
 	/*
 	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
 	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
-- 
2.43.0

