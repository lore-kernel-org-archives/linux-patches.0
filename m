Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804620;
	b=m79NzFn18Lj4n833icRnpjzFjToWmyOJ6qj4M29DQj0XI31HQaNu/iIq1Qxi1ulaaHT4
	 2qkl7oy3j2V/6nc6t1kpPyMQNx2w6DX7iWjgV+JmmIgKqRMq5B+X9Dj0uANPbnoV5H3uB
	 7zvBHP46pPulKqQP8Z+UZEX27MhWaXH3fCwkkjjMJRsGZSgizHBMD8AQvRz6XvUge5cUD
	 zwa12HEtCKbheeoqRRiy+BkkwnG/kJDlVtY7jIH0FOeNLzwMNUPyfdbrBg2hT51NNg97w
	 lWo/9KrSEx62Q97lQTDUB1r82vo5VA9/mdRHEl1hXnfcbBCOOJqJYi3JayXO8ATP+QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vW3y0AW6/L7scRyv8WnCfxKhIMaL9extgDBA4/4sjSs=;
	b=OmI8cSgittqoOnxtpBCxLBGLNSmqJC1qvcREkp5/xa5Mr+PgK9y8V6tPZyqdjWaMB1lm
	 5raruiZx5PAl0g/BKQthWVWaCO2S1aagZnJmNbgqkbaV9Ivs8ONv+JrGVHw2AnRXjFmy0
	 wQMKLT/jBWd0jaKlykM6py8ETecr/1Fl0n/B8CMmnUeKdj8DkNNb/2S5VUo72FltCZbRk
	 mxLIx6eRe4H8VDiEDCBLihbpKVr+zIiyz/3ZafBkvOQvCJbyetPORdB2RjJQhMjafHXRC
	 CPs04isIRTVmQMZX1QVWVySDo61IpmkqrhwNYwa3tZ/uzIbtl18B8lhdupy2Uw23tiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HH3H1NQl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EC3606EE83;
	Wed,  4 Nov 2026 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HH3H1NQl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C461F0093A;
	Wed,  4 Nov 2026 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804619;
	bh=vW3y0AW6/L7scRyv8WnCfxKhIMaL9extgDBA4/4sjSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HH3H1NQlZ0xMqHJDg5i4s/eYyNrCeNeU4wYFTCtyan7zIzV+HIC/i0F7Q3HNeh10V
	 sSGqhobs1O+tDTnl6MvP8uCCII8lBKOY27FBXrk8sHgXmUwOP5WEiFh3yoiRmmLjth
	 jGxld24VL8wquyTFb5V3VfiEMWsA3ogay4pPM8JvvsbUK4su03TPJBuPOlRaCn1Zys
	 kr3gxI47IGHhGipIXZv1jgpMLmk6e7AKXcBQ8TGcXZxU9BjSBmqcy69oltgCytF2gZ
	 GS2airSYnRwc+SWAOmZGjD0XeW7n9y3gbF5G3h40zPv8EofBEU9Tsugk9036zj1evI
	 gkIPg6P/UcUKQ==
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
Subject: [RFC PATCH v4 01/25] KVM: guest_memfd: Let providers prepare memory regions
Date: Wed,  4 Nov 2026 20:32:58 +0530
Message-ID: <20261104150322.3516320-2-aneesh.kumar@kernel.org>
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
 virt/kvm/guest_memfd.c      | 15 ++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

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
index 48d14a20fc0b..291305888311 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1367,10 +1367,11 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
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
@@ -1390,10 +1391,22 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
 		goto err;
 
 	inode = file_inode(file);
+	gi = GMEM_I(inode);
 
 	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
 		goto err;
 
+	if (gi->provider_ops->prepare_memory_region) {
+		u32 flags = slot->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY);
+
+		ret = gi->provider_ops->prepare_memory_region(gi->provider, offset,
+							      size, flags);
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

