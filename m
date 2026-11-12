Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469344;
	b=aR6tS2G0a3ZDHKSdy2ohCk5wLsds3Kunpda1ZNWFyRUG5SeS69XfIgsj0PUYfoncz5Tr
	 Smbmk3aqJgvYr+CbJFCHIVX6hV34+Rn2hz+vJh4GNzqmuUR3tsPgFvgITh0REQ2XlrKZv
	 /IiSqfsHA26iL7bttWQQd5mlgqPTgcmQpSRId83t91Fgf/BlUZfMEmlMZaxdNd1fkq3Mg
	 +hQDDYvKieMPi1BPVndeXuK9Wb7QNBMXlMWalZtvN0AI3egG9LPJTbrOPXUGsbANgcCGD
	 AaLnd1PhtBk6Jvz+rQ2Jge8UMgzueOCgBSwgkdUgb5m+JH4+7TRpbxjXhawGsNSm8kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jiQk/6ewbuT9iekCPsyXSD03vyRNwTpuR8bjQs7mJmU=;
	b=hAWlarhmtvVEDTyLQMJ7X+x+BVEQ+BZ43QLmAZLjaWWOCtuLWhoYqH2hgRtpv8IUYqlq
	 +LSn6QRWgLW1t4LCkPh3sDMOZ2lOT0cDkHxCtQ65IxwFdT6K6Ug9ORJ17KLsNdyQffHFk
	 HfyyJDQ0V8B2vrY+Jy1zDA8Y/JBRW/mJ2Mt9TjYV2Bf/G6Y6cJljs9AgJZMo84TnazqsU
	 6fcreKppLDMuG7TxpjvBNH4k7etFqoiGOija5Jkb1nTpJ5EMgXeZVhhtxi2SqUkRRJ1CF
	 uc+y+isn3U9Es1a8xeVUkyPOpxxhQxnhbcF7Xj1lCOwcbtdiPfoIedjoOsfQHUNvQYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cirnWA+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42572606A330;
	Thu, 12 Nov 2026 07:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cirnWA+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109971F00A05;
	Thu, 12 Nov 2026 07:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469343;
	bh=jiQk/6ewbuT9iekCPsyXSD03vyRNwTpuR8bjQs7mJmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cirnWA+Joz2KgHzUa1T5n9eIqWmrvOCg14C0JhlYpyxsAwi7j/lrbvrS/Bod1peF+
	 Z2amUznGEF9I1iQ6CImvFPetw3k+apDhnyCz2R+VLzqS34NDjudwC2zwyuZn7jRgNZ
	 AxCIEkdTbA9gIkxCvPqyV/D1oWMBALnn886Eo0pcNi4lsRqWJKkKCitQMtoam1SDQV
	 PvM3nHhAu/foqd0fmV/eIeUpPLIInpUoSSeeSHERgSugPYIZiF+gphJhSFHPSPG4XO
	 TGhVTNLDuQ7fKlor/Z/EoIINZrVx5hmpS2hFqlWM0irzen5zfru8RkHt6TyLjmWQQv
	 fVapK/VItPu/A==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: [RFC PATCH v5 10/16] KVM: guest_memfd: Let providers prepare memory regions
Date: Thu, 12 Nov 2026 13:11:14 +0530
Message-ID: <20261112074120.1570072-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
References: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
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

Memory providers may need to check memslot flags and memory ranges before
KVM installs a memslot. Add an optional prepare_memory_region() callback to
the common provider operations

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
 virt/kvm/guest_memfd.c      | 14 ++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 777507191603..79e2983c3b26 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -37,6 +37,12 @@ struct guest_memfd_handle {
  * @attach: Attach to a resource file, perform filesystem-specific validation,
  *          and return an opaque provider context.
  * @release: Release provider context and unpin any resources.
+ * @prepare_memory_region: Optional check of a memory range and preparation
+ *                         for access. Called after common file checks and
+ *                         before publishing the memslot. Offset and size are
+ *                         in bytes. The flags contain only
+ *                         KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY bits.
+ *                         Return 0 on success or a negative error code.
  * @lock: Optional provider lock for mapping and attribute changes. Called
  *        with the inode invalidate lock held for write, before guest
  *        invalidation starts.
@@ -106,6 +112,8 @@ struct guest_memfd_handle {
 struct guest_memfd_provider_operations {
 	void *(*attach)(struct inode *gmem_inode, struct file *resource_file);
 	void (*release)(void *provider);
+	int (*prepare_memory_region)(void *provider, u64 offset, u64 size,
+				     u32 flags);
 	void (*lock)(void *provider);
 	void (*unlock)(void *provider);
 	int (*prepare_attributes)(struct inode *inode, void *provider, pgoff_t start,
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3a92f2453e8b..ffecc4b19a17 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1671,9 +1671,11 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
 				   unsigned int fd, uoff_t offset)
 {
 	uoff_t size = slot->npages << PAGE_SHIFT;
+	struct gmem_inode *gi;
 	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
+	int ret;
 
 
 	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
@@ -1694,10 +1696,22 @@ int kvm_gmem_prepare_memory_region(struct kvm *kvm, struct kvm_memory_slot *slot
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

