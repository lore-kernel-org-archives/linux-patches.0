Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469376;
	b=wdJ9QTiNtBp9kpLHIyIKIjyX+OXsu6PRMd7jQYWUGpBXxr2/FkrhvjYNAana38UZ7+nv
	 ArQQl6fmj1ZKsteCCmix7iUS1XGSE5l/Dv4aU+GmqxplHdXrz3ZNnfn8W4vMCaxGUH0Qy
	 yq7uQ0Y7ljAo6juyZFMhYaxVSWY1LGKVOJu9Nh4Ez0E/TuO8oFq3Ydt7hIoOPQyknSuk/
	 Awjttd7J+XxMvJpIKuvwcxCrkgTP2rsrRZ/Q4E+jKxXB5jV2lOUhKeH70bGp/8PMViHfR
	 I4KlcYiCwHFP82YVVyqQEQ/93owK5GdC7AswCqxDU04KrgvNh62sp3OsMfIEN7LaiGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Pxnr80fWS+ZWZIzsZX1b3FRLCLNebt7uApoQNfIHwI0=;
	b=fDxZZqzMA7Nq7DNfNMl4PGE0H2vJHCcDyn06F56SIDRrSi+oRTA337C5H3WNS9df0tQT
	 +YBDKJrS0JidGEh19h4Zy3tny+0IsbyOmqMuBkpLjLsjXx/Oip/1KIBRI2wvyfnr1I1MR
	 iWuJzz4/tWnRJNEIYEILyWpVYL9k3xEK4wu9CbS6ae4R3M+OO5fvwFaeZ+2dVQY3jJvoa
	 mRLtq1fRoyn5+ZVSnuqUBNWPDsdaGTvhTBgEa4iMF4+IRRpDs7x19enYwuHAXushOFj1l
	 Si4n2sSIeaTtKM6IE131pXrMoVUUQLmnk6HlYBf/SrMpuHZBSTkN8O2eYYZHN26EeRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AacrlaxT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C663606A327;
	Thu, 12 Nov 2026 07:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AacrlaxT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D37B1F00A05;
	Thu, 12 Nov 2026 07:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469376;
	bh=Pxnr80fWS+ZWZIzsZX1b3FRLCLNebt7uApoQNfIHwI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AacrlaxTG2uHmH8rzhmGWRsg1KMtpEwisvSqvKHrV+bYsISwbsbe++F4lr9LVyvTb
	 o73pFIZQdAGtYOV3kWc2NdbRvk7M+NHAHutKM9DzSULfKnrk9UcC/gHEhChn48GDcj
	 UvTNGKVVq7pEpn/yPWy2Uq5LApJ2ywGwiZJ50PkJnxociwT36Ms0nFdLj7INlzT7VK
	 qf1F4Ip1sK+ISoZC94AXMfySPi3v8H6is3NPg1OCB1W9F70MMhDTiRq1NuduFmJ0FR
	 JnMRCHMOW/UpRXpkuZ6o1xqIh6xvfmoVrbAN1ezyVxYyFPfN6YB0sJMMfaTuA+8dr2
	 hCZ2tih/X8Ohw==
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
Subject: [RFC PATCH v5 16/16] KVM: guest_memfd: Invalidate mappings before memslot unbind
Date: Thu, 12 Nov 2026 13:11:20 +0530
Message-ID: <20261112074120.1570072-17-aneesh.kumar@kernel.org>
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

Use the generic invalidate_start/end helpers to remove shared and
private device mappings before removing the memslot's guest_memfd
binding.

Hold gmem_provider_lock_updates() across invalidation and binding removal to
prevent device unlock from racing with teardown.

Keep the file attributes and has_private_ranges unchanged. Deleting a
memslot removes mappings but does not share the memory range. Device unlock
remains blocked until userspace shares the private ranges or closes the
last guest_memfd reference.

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
index bdee42ff6b26..93e2ccfc4540 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1877,6 +1877,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
 	struct gmem_file *f;
+	struct gmem_inode *gi;
+	enum kvm_gfn_range_filter filter;
 
 	/*
 	 * Nothing to do if the underlying file was _already_ closed, as
@@ -1896,8 +1898,13 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * drops slots_lock, so there's no need to verify the file is live.
 	 */
 	f = file->private_data;
+	gi = GMEM_I(file_inode(file));
+	filter = kvm_gmem_get_all_gfns_filter(file_inode(file));
 
 	filemap_invalidate_lock(file->f_mapping);
+	gmem_provider_lock_updates(gi);
+	__kvm_gmem_invalidate_start(f, start, end, filter);
+	__kvm_gmem_invalidate_end(f, start, end);
 	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
 
 	/*
@@ -1906,6 +1913,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * to guarantee kvm_gmem_get_pfn() can't see the slot+file.
 	 */
 	WRITE_ONCE(slot->gmem.file, NULL);
+	gmem_provider_unlock_updates(gi);
 	filemap_invalidate_unlock(file->f_mapping);
 }
 
-- 
2.43.0

