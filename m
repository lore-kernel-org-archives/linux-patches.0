Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804664;
	b=nwQbeiXinxo0TD3+5GSQig6nwQzIErMaTW3qo0QiTpOG6TbLEtUmV1kPWeRXwkJVn90x
	 nWTAAw/r/Np/jdHf4BmL9Zt+pdI4ra1/jAgczMVJNdnyGltVTsnz8UobF9ydLTu5909p7
	 PWyLeOFfW+C0SGjjK2E0WT+WBCHEPzLGpISxQaAs4Tmo2IGI6MCEBsnS99NQN48j2hHs9
	 7QnXjL0OLTbWVmgEHeZAWsEA87u4t0LEmu/EOYs0cNWpZdR6FmGBz+qnjffTV0hWB3fUB
	 QVIfX+n3ek3Zgf9JIokukYlfG4vxnR+s0tEEyyQNg5iAO3nvjGDxY2Iqrq7qBzVFQ4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yTfWL4IyzrxKgk9+Qpl3hCJwDvIeCHc5gxMrrKy5QPY=;
	b=Tt1kMsK9s8QDHe5J1TWHmSM/rPgSuW0wlTtM3uwXXXGvrd001LFd0yQ73rvfKAQcWcT6
	 IYiWka0Z1alrkeJ9mmTfucXOOCWUAE2drjzHygjP49ATfhBQq55BZlAw+yV9YLUKgiPC9
	 rXBfnOoFC1Wya8NH+Kt21//uFD4Pjq5IoyOfrvmSg4/6JIbCShTFrIdAxUfdwRFuh1H6p
	 D0DAU8AMPJ7HbM8X8Ny98acs49uyt3YgmGQb9lbrdUjGgcjv8n9P+5IRm+9vIkPwz7J/W
	 wXekKhVbm/vUOoVJTtfLwSvgpQmQM20LKflIp+Bt0Kqgv1WioGQM1ivvr5zQV7uuaYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GxGpTRea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD87606D804;
	Wed,  4 Nov 2026 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GxGpTRea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D641F000C1;
	Wed,  4 Nov 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804663;
	bh=yTfWL4IyzrxKgk9+Qpl3hCJwDvIeCHc5gxMrrKy5QPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxGpTReaNOgHYmQ4twaILjmq5FXfEyGMn5UfafJ7JBdPfEW/8JVL+fhXXZOaYvnfy
	 olaQoc9ARVuvpwlWOLXKIhjW3s/YWh416e19j6aD1cveK8jBChcZ/+yHB+VGSjTdBF
	 SN20WdiCRosD1KAEPt2F4jdM3YfA3vQ20vUDRHA1tgoxbB5KcMFqWfU2xKd/6NDjF2
	 5HStE55Ed+5GO/TrtTUDUjFZgrKgJYcA4o2C9nM6bYl/fEsrVcebKsNFmzfGzLKonR
	 bjflfy0RQzXPs2ukNskoX6WcBJQi2eiPK586c2RbrXSjwGBukklZOg4d77tduqAiz7
	 ZGGlkOyiM/TrQ==
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
Subject: [RFC PATCH v4 08/25] KVM: guest_memfd: Track private device ranges after attribute updates
Date: Wed,  4 Nov 2026 20:33:05 +0530
Message-ID: <20261104150322.3516320-9-aneesh.kumar@kernel.org>
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

The following device access callbacks need to report whether any private
ranges remain without acquiring the inode invalidate lock under a
provider lock.

Add has_private_ranges to struct guest_memfd_device as a cached summary
of the committed attributes. Add an optional update_attributes() backing
operation and call it after storing new attributes on successful
conversion. Device backing scans the attribute tree to refresh the
summary; folio and RAM PFN backing leave the operation unset.

Providers read the summary directly with READ_ONCE(). Device unlock
checks hold the same lock as the provider lock()/unlock() callbacks
to serialize with conversion.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  5 +++++
 virt/kvm/guest_memfd.c      | 27 ++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 6bf44c62b7fe..9869e2ffb4a2 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -24,12 +24,17 @@ struct guest_memfd_device_binding {
  * @flags: GUEST_MEMFD_FLAG_* creation flags
  * @binding: Mapping owner and device ID set by attach(), with the underlying
  *           resources pinned until release()
+ * @has_private_ranges: Core-maintained summary of committed private ranges;
+ *                      providers read it with READ_ONCE(). Device unlock
+ *                      checks must hold the same lock as the provider's
+ *                      lock()/unlock() callbacks to serialize with conversion
  */
 struct guest_memfd_device {
 	struct kvm *kvm;
 	u64 size;
 	u64 flags;
 	struct guest_memfd_device_binding binding;
+	bool has_private_ranges;
 };
 
 /**
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a06abb6dda82..54b387d296a0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -63,6 +63,8 @@ struct kvm_gmem_backing_ops {
 	 */
 	int (*prepare_pfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			   kvm_pfn_t nr_pages, u64 attrs);
+	/* Called after the common code stores the new attributes. */
+	void (*update_attributes)(struct inode *inode);
 };
 
 struct gmem_inode {
@@ -99,6 +101,7 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 	return gi->provider_ops && gi->provider_ops->device_memory;
 }
 
+static void kvm_gmem_device_update_attributes(struct inode *inode);
 static int kvm_gmem_device_convert_attributes(struct inode *inode, pgoff_t start,
 					      pgoff_t end, u64 attrs);
 
@@ -1199,6 +1202,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
 static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
 	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
 	.convert_attributes = kvm_gmem_device_convert_attributes,
+	.update_attributes = kvm_gmem_device_update_attributes,
 };
 
 static const struct kvm_gmem_backing_ops *
@@ -1265,8 +1269,11 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
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
@@ -1509,6 +1516,24 @@ int __weak kvm_arch_gmem_device_map(struct kvm *kvm,
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
+	WRITE_ONCE(gi->device.has_private_ranges, private);
+}
+
 /*
  * Install protected device mappings for the provider PFNs when making a range
  * private. Protected device-mapping validation needs these mappings in place
-- 
2.43.0

