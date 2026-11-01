Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517645;
	b=Q4eHSlo3UwHbGHe3ieu17S+9UleyxNVP9oRtxJmJMeLeQqE3uDOs/YmPAGjcB/g27fCB
	 IuNroM4xoH/3AJJi2dLM3E5QbXAuqSWP8YQU8jbYxUl7t3TW3JUGNlilpgUEGhmOEiEu9
	 IpRr4vIpkntvnY0RopR4kz00e886OZAEbjzHtaIijKT53CcmQa0cECajjQj6iA6p+Qb1x
	 uDsjpEt7FvnSnDluzR/gcnU6QyCIT4fbFkHSmkvM358qAWdoZzMODfAEjrvuYLz67haqk
	 ryoGNB2cSSEYFeFaXdSoMIcjqyNM9Hu3/eQrYIj6+2P2gC43n//BZL2wb6TDsLQ1lpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cDLMhPREWdiiuVrlPViYI+QhD9Z6i4FxtLJ9bFe56UU=;
	b=SU90L1TsA+VSm4wiKdLkiO+83Al0zyAyZLpgHRK8ww3a6UPAuVQjhPLCOb2HyEg+eB03
	 7F9UxoUVBPizkdX48FtH/FAeqd4UD0fXJO8N+NAoEHKHCoJwZINu7sjfCQZ9J8GAlIH+v
	 yLs8oVgnhHJ/fwRV/I7Ec+MhAuYYP1X+58/sJ0poiG4D1MP+A2OnS1H3WzN4vGGPsC2A8
	 7LNr/j0cTf2tld+Eyn9WuQy/EayZyWd9OPqMDs4Iarxnbb8f9xdQ5Ld+5NJhQmBBkn6mg
	 T0eqv0ixm6wlKnSJtB1Fu7NomjjghR3hOX7v6TmsNgBWtWFA07dWkQYGyGNJ+brvLCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L2SuKdwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13E606A325;
	Sun,  1 Nov 2026 07:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L2SuKdwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08751F000C1;
	Sun,  1 Nov 2026 07:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517645;
	bh=cDLMhPREWdiiuVrlPViYI+QhD9Z6i4FxtLJ9bFe56UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2SuKdwEgKz8FpgVJseBeORDCG+wswZwlVZcE5hpvbnX+3rjIqKZZDOoT2LELI47y
	 AX1YRoVm4qYzU7GrXR5hE+cuXgGxkIASWh38PYmx9bk7yfZqbEeZxE1eIW9BUOhJ+c
	 RCERJr3f310SAQlRDKGUXS00EYmXetgRUrUI6Njot34SoMYuWZaRR81ilHwVCAnAIz
	 sutHH9QQif/hVk7iIwzcq0Q7ToQ3Mxs5y5OcGauaVXWQnhA9/LHaP60lUxdqxq3s9m
	 FdmkeGhtOLMTBts+kFUZRHa3emvsbi5z142HwtgTu3HEYAJkCTgmW8pcnnyQUj63Lb
	 S6DDesHcWh/xw==
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
Subject: [RFC PATCH v3 08/13] KVM: guest_memfd: Track private device ranges after attribute updates
Date: Sun,  1 Nov 2026 12:49:22 +0530
Message-ID: <20261101071928.2462549-9-aneesh.kumar@kernel.org>
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

The following device access callbacks need to report whether any private
ranges remain without acquiring the inode invalidate lock under a
provider lock.

Add device_has_private as a cached summary of the committed attributes.
Add an optional update_attributes() backing operation and call it after
storing new attributes on successful conversion. Device backing scans
the attribute tree to refresh the summary; folio and RAM PFN backing
leave the operation unset.

Run the hook after both private and shared conversions, before releasing
conversion locks. The scan must see the newly stored attributes, including
the removal of the last private range. Keep this bookkeeping separate
from the architecture mapping operations.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3bf26490f4e9..af1e4798ace1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -44,6 +44,8 @@ struct kvm_gmem_backing_ops {
 	/* Prepare private RAM state after lookup, before returning a guest PFN. */
 	int (*prepare_private_pfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				   kvm_pfn_t nr_pages);
+	/* Called after the common code stores the new attributes. */
+	void (*update_attributes)(struct inode *inode);
 };
 
 struct gmem_inode {
@@ -56,6 +58,7 @@ struct gmem_inode {
 	const struct kvm_gmem_backing_ops *backing_ops;
 
 	struct guest_memfd_device device;
+	bool device_has_private;
 
 	u64 flags;
 	/*
@@ -80,6 +83,7 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 	return gi->provider_ops && gi->provider_ops->device_memory;
 }
 
+static void kvm_gmem_device_update_attributes(struct inode *inode);
 static int kvm_gmem_device_make_private(struct inode *inode, pgoff_t start, pgoff_t end);
 
 struct guest_memfd_device *kvm_gmem_get_device(struct inode *inode)
@@ -1182,6 +1186,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
 	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
 	.make_private = kvm_gmem_device_make_private,
 	.make_shared = kvm_gmem_noop_conversion,
+	.update_attributes = kvm_gmem_device_update_attributes,
 };
 
 static const struct kvm_gmem_backing_ops *
@@ -1241,8 +1246,11 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	r = kvm_gmem_convert_attributes(inode, start, end, attrs);
-	if (!r)
+	if (!r) {
 		mas_store_prealloc(&mas, xa_mk_value(attrs));
+		if (gi->backing_ops->update_attributes)
+			gi->backing_ops->update_attributes(inode);
+	}
 
 	if (r)
 		mas_destroy(&mas);
@@ -1502,6 +1510,24 @@ int __weak kvm_arch_gmem_device_map(struct kvm *kvm,
 	return -EOPNOTSUPP;
 }
 
+static void kvm_gmem_device_update_attributes(struct inode *inode)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	void *entry;
+	bool private = false;
+
+	MA_STATE(mas, &gi->attributes, 0, 0);
+
+	mas_for_each(&mas, entry, ULONG_MAX) {
+		if (kvm_gmem_get_attributes(&gi->vfs_inode, entry) &
+		    KVM_MEMORY_ATTRIBUTE_PRIVATE) {
+			private = true;
+			break;
+		}
+	}
+	WRITE_ONCE(gi->device_has_private, private);
+}
+
 /* The inode lock protects attributes and the offset-to-GPA bindings. */
 static int kvm_gmem_device_make_private(struct inode *inode, pgoff_t start,
 					pgoff_t end)
@@ -2042,6 +2068,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->provider_ops = NULL;
 	gi->backing_ops = NULL;
 	memset(&gi->device, 0, sizeof(gi->device));
+	gi->device_has_private = false;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
-- 
2.43.0

