Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804688;
	b=oNFGtAqg/52YwugogggWhdlbEDKZ7v5O3Oq5yQaHIBZPPbP5QArkw5aXpsFVlahNR4nu
	 nnaDPD0EX2/nn3//tU5GAEhck144/fPAAstGTnYlRefnaYUB3g0EqWE51OqOyYRSE/6b9
	 j6q8pE435oMg1wItrKLunKzdwE+qQFz+zC8alHYdHLCqgZS3JhF7P8kqZvac5Cla7UYxT
	 9jhme0DaufoenWk4PzmsIQThaOK0GDFjOnGIeIZUtNIBCxbqaxcF2cfeenrqC4e7Gu8BH
	 7BFbzQQ34/ix2HILFkvyPC4Vte9F/Z1E6ASjlblYIJLcqjFjtqMyOOsetGavekKUONg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rS40NRoMRb1Axjjj6DLrLlKdWsMdXuRqZ21vY/yTWC4=;
	b=CZhR48wDA43P/0qfAVjGw3jkHsin6rsw7UlUhFAPa5SFjsCp2q/3gB2vl9xNP2WgilJq
	 HBsviBnpvf2mG7RCUspaNYUYYixzgrWi8OEFlVq6sV6GR1d8dOrjSgBJIMkzvzkloAZvr
	 zMXPplqSzDhliaGc4TEeXIYRMYVm8lzahH9UXWeRUV2o0rr4WnAxwQ8pCBG+T9ves4hmV
	 EUkgPxhBdqQqfkH+GoHMncbpAPpvEh3tKgqpvbqpjTXjQ156iUJeMvIE42479L7CW18+u
	 nx+BbZy/LTt5zqQp2cGrG8uVr2rmfuhvP/eOCUFPZ8+wMrRdrnSFKEsX2TUq4rfRQXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=krUATiSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86482606A33E;
	Wed,  4 Nov 2026 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=krUATiSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D86B1F000C1;
	Wed,  4 Nov 2026 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804688;
	bh=rS40NRoMRb1Axjjj6DLrLlKdWsMdXuRqZ21vY/yTWC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krUATiSaTdc5CcZdzxygeRGDWGOF+1KIfBcpsteqisvuJzbk/ZRcl8A5IMmjEfKbD
	 DqBpYtxQNQktX1ttfPg1DcfUGCCpZ3Z8m9XIBmN70PKQ60pI2ZjrKwkvZoru7OfuHF
	 1qI4JMj07swSks4IW4xh025Xa6upRn4/ht+zwOcGRkU5qlf7k/N2POfepYAE37Z6Bi
	 pVecfsaLIB/HhJCPlu5ZsPp3sym/iHk5ekIcosNYx1EmSbsUo/9uS5OhQkrPdj/a7S
	 HQDOiORokzmOAtD2m9H72Ou3aK+mXkCs6uYolzoq0f+9J6bI/uXskIvaWjhXVIP1bh
	 utXPeW4f8x9jQ==
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
Subject: [RFC PATCH v4 12/25] KVM: guest_memfd: Invalidate mappings before memslot unbind
Date: Wed,  4 Nov 2026 20:33:09 +0530
Message-ID: <20261104150322.3516320-13-aneesh.kumar@kernel.org>
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

Use the generic invalidate_start/end helpers to remove shared and
private device mappings before removing the memslot's guest_memfd
binding.

Hold gmem_provider_lock() across invalidation and binding removal to
prevent device unlock from racing with teardown.

Keep the file attributes and has_private_ranges unchanged. Deleting a
memslot removes mappings but does not share the backing range. Device
unlock remains blocked until userspace shares the private ranges or
closes the last guest_memfd reference.

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
index d3de2e7bb9f5..870fe11c1c5c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1873,6 +1873,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
 	struct gmem_file *f;
+	struct gmem_inode *gi;
+	enum kvm_gfn_range_filter filter;
 
 	/*
 	 * Nothing to do if the underlying file was _already_ closed, as
@@ -1892,8 +1894,13 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
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
@@ -1902,6 +1909,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	 * to guarantee kvm_gmem_get_pfn() can't see the slot+file.
 	 */
 	WRITE_ONCE(slot->gmem.file, NULL);
+	gmem_provider_unlock(gi);
 	filemap_invalidate_unlock(file->f_mapping);
 }
 
-- 
2.43.0

