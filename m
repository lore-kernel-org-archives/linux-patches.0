Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804670;
	b=OteCs4905EV5Cmmeoi77qN6Gn2dzz8WOb/n/lwh5lcEpkKS2n7+o4kfnpJFqc2x46jDG
	 d1bGbgRjqEo2wU5GOIjvLEMDS4J8Hk+xAw/o92pqH5QytPCulX0vkUUSN+zhGd4/iiyoI
	 qkaBE18FSGR7pB0YLRJrrtSF9o4R3Js951yLzvq7Nv1dPpykP4ijAfIBkXr1ikYHQjldx
	 SdR3M4JIknfuwhw4huvufj/k7ugnArb7Jq5oaAydMGYuMumsPaCZQU23iH8frXWbzThKM
	 7yUjUnqXghanxrEo435tBAnitrEjXT0wXEgTpvNsNzQAlLF0xVzIuH9RvCsYcBNIYyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WlGtj6Iesl/rn2p6NMaev8Rik6vPjNfXhUOknX2bOKk=;
	b=BqgBUiy3We4+jQWpPDcYzmA4RbIR42WXir2zkYdHHWucTqUyr8AGBE/aD4Mhg4NAslWz
	 rc9V2NHxI6SQrSD0wSK9In5POpcIw9Rb98r6UDXhQ7AbgidO4cqbTCu78nA+YVJ32W5tj
	 v15sIdpIcQoJWvaibV4MVsQo51/U53ACAWlsL9KvEztCBo1R5kNwWh31tsqgId4Z7eY/i
	 sngPx3MNdxmSjIK6cIuRnfObgjcgY1ucMi0lLIVHxr3NzetZe9GRh+sIgC9nk4TKxHKn/
	 ea3f3HX8u7s/nXxJadXNadbCwSjgiH20d7fOildukzruS7t1NxykxkmdEZ9E7SaOs/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkPX0TtG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377A0606D801;
	Wed,  4 Nov 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkPX0TtG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF611F00919;
	Wed,  4 Nov 2026 15:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804669;
	bh=WlGtj6Iesl/rn2p6NMaev8Rik6vPjNfXhUOknX2bOKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkPX0TtG7UidgZpkFYL6NjCNisl9JBjqyhXApm8zzGpP2rM4Y9+7QW/hj+XQfFkOC
	 o23BuIDWOex5yqKtmWtQIUK9+TFSp2DXOnRAxgifWlRFN7Pb4hVlTeyfm/BVxbHljE
	 +1/nNIY0dcdTXPIuP3etTkFStiFHnZQhWrZ5O63YgjPXPaHJgoM12E8ge6DPC+o2Sy
	 wRmO0lG3sef+Dre6rOBIQLgEt851RWLUf/6EaNLqSApdmNbHvPqVvsvo5gqUqT1B9X
	 eBqAw03W6QBw7SFrYIsNb9zDCLok0vgE4OBIvzNC5Jiy01naHCpVQxdP7YH/L04Znq
	 F5NlCnOCEverQ==
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
Subject: [RFC PATCH v4 09/25] KVM: guest_memfd: Support range revocation of device mappings
Date: Wed,  4 Nov 2026 20:33:06 +0530
Message-ID: <20261104150322.3516320-10-aneesh.kumar@kernel.org>
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

Give device backing a revoke operation that removes host and both shared
and private guest translations under provider exclusion, without reclaiming
MMIO PFNs or changing attributes. Keep fallocate and hole punching
unsupported for device memory.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 54b387d296a0..4c9ac047d06f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -543,6 +543,18 @@ static int kvm_gmem_ram_pfn_revoke(struct inode *inode, pgoff_t start, pgoff_t e
 	return 0;
 }
 
+static int kvm_gmem_device_revoke(struct inode *inode, pgoff_t start, pgoff_t end,
+		const unsigned long *pfn, bool put_pfn_range)
+{
+	/*
+	 * Common invalidation handles shared and private guest mappings. Only
+	 * host userspace mappings need to be unmapped here; MMIO has no RAM
+	 * pages to reclaim or provider allocations to release.
+	 */
+	unmap_mapping_pages(inode->i_mapping, start, end - start, true);
+	return 0;
+}
+
 static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 			      size_t nr_pages, const unsigned long *pfn,
 			      bool put_pfn_range)
@@ -1200,6 +1212,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
 };
 
 static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
+	.revoke = kvm_gmem_device_revoke,
 	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
 	.convert_attributes = kvm_gmem_device_convert_attributes,
 	.update_attributes = kvm_gmem_device_update_attributes,
-- 
2.43.0

