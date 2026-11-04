Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804768;
	b=yFzMbLji+xWGnIdIwRzbT1725ub8OzwV+/EwFpn27OxPN20DohXQz2zJPGRBCKRdb7Y1
	 QU4HUqc12t1kTlHva3i5SL+OsLmhNTqlXcWnQTafzi8yOvVN2CIeDljhgBWz48lc/nSBW
	 xnJDD7NVVVCFxBvOpGYcZ+p9VIZoshIjkL3EHEox8pJ7pk4X2hxfSWIe02dOzaEQnqZvQ
	 GFcpduCjpHhqgfeb7SuL7/ZttBPVw2ioBCY3ws68pROvlhxi9kGF3AjcJdmF4+p7V83zW
	 D3ViTcuaKxt8yBsE6bbCRB186U+dUuXqVuqlYDB3lTRpVUuguureC0h9L2n6xhYrN0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9XUu19nr/f7NGXbDq+W5w9qO3ygSqOJpP8i189RQgXI=;
	b=ABSA3ygFNyKxB3uyDnKgcsKuQpL3gLEdMmWG9n9p/MiVFk05twLbiC5EJyM2oktXiJE+
	 /d6DuZ/D4+nqbB2Doh+GPOH5yH2Oxm9lScs5/Ca8Igoizis6GaOO5BW8ddxEzdmQMOa13
	 Ey47kiAK0NjbRV7GSHDMEEmRZktp6VQOlHGsvwB3M7XM7eN+YYA7y88ZdqZnRX640532W
	 iQdOYphcldQYlRwLEg3FbakRx6Wp53A71d6pW7UcSuq8TxuS8oC8toLf2QBTEerJFviQM
	 RPOtuCoDUex8Ywq50zpGyvQS/kWmtqVM1D2b4Nh1U0R+8e7khE4HQOtzR7lLL2EbW7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQIYThW6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063F606A328;
	Wed,  4 Nov 2026 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQIYThW6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C5E1F00A15;
	Wed,  4 Nov 2026 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804767;
	bh=9XUu19nr/f7NGXbDq+W5w9qO3ygSqOJpP8i189RQgXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQIYThW66rDODt+C7H4yN0no9vsvbLmtEEKrtB56e7xJxpgN1y9zekCHkFpY3jL9t
	 7a0MwO7m1Zsy9YWw/CRb6NiC7EprtPnsRwuWcCz151oTyImEDqKuzkgrR4rBQBb6as
	 L0KL9VFMblMFQvIV36FTQ2AVAyZNO5r1rF7QWWA1ujc1xL6zVocbc8Vc1lQOaQtYa7
	 /GBPO1jTz9DppgDA4juqTOe5LoX7Pqp65USZprlW0qqKvqxABAOHXzPcZWk1avQMXT
	 e0tp6lGhhmqYiFUUiTW1eS0dPZsyS020Ng3uZ+hgkDgIefi1BBY9hKVN6Vc0n0qPFI
	 bZBp7029JUJYA==
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
Subject: [RFC PATCH v4 25/25] KVM: Document device-backed guest_memfd and VFIO usage
Date: Wed,  4 Nov 2026 20:33:22 +0530
Message-ID: <20261104150322.3516320-26-aneesh.kumar@kernel.org>
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

Describe device setup, VFIO access restrictions, mappings and lock ordering.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst     | 50 ++++++++++++++++++++++++++----
 Documentation/virt/kvm/locking.rst | 27 ++++++++++++++++
 2 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4482d34ec281..289b42224258 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6513,8 +6513,8 @@ The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can be
 specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
 
   ============================= ================================================
-  GUEST_MEMFD_FLAG_MMAP         Enable using mmap() on the guest_memfd file
-                                descriptor.
+  GUEST_MEMFD_FLAG_MMAP         Enable userspace mappings through guest_memfd,
+                                including shared VFIO PCI BAR resources.
   GUEST_MEMFD_FLAG_INIT_SHARED  Make all memory in the file shared during
                                 KVM_CREATE_GUEST_MEMFD (memory files created
                                 without INIT_SHARED will be marked private).
@@ -6540,10 +6540,48 @@ provider. PFN_MODE selects the PFN callbacks; providers that supply device
 operations additionally require INIT_SHARED and a VM supporting protected
 device mappings.
 
-KVM_SET_MEMORY_ATTRIBUTES2 converts device memory using guest_memfd offsets.
-For private conversion, KVM resolves the guest address through the memslot
-binding and obtains the physical address from the provider. Shared conversion
-removes the protected device mappings before publishing shared attributes.
+For VFIO PCI device resources, resource_fd must refer to a VFIO device fd
+bound to IOMMUFD, with a vDEVICE belonging to the same VM. Set USE_RESOURCE,
+PFN_MODE and INIT_SHARED. File offsets use the VFIO region-offset namespace.
+Memslots must cover page-aligned ranges within a single memory-mapped I/O
+BAR that supports mmap. Dirty logging and read-only memslots are rejected
+with EINVAL.
+
+Creation fails with EBUSY if the device already supplies another guest_memfd,
+has VFIO BAR mappings, dma-buf exports or ioeventfd handlers, or userspace has
+enabled VFIO runtime suspend. The device is resumed and must be in D0; it is
+kept active until guest_memfd releases it.
+
+While guest_memfd uses the device, the following operations fail with EBUSY
+through any VFIO fd referring to it, even if all ranges are shared:
+
+- BAR read/write, mmap, new ioeventfd registration and dma-buf export.
+- VFIO_DEVICE_RESET, PCIe/AF function-level reset and hot reset affecting
+  the device.
+- Requests for D1, D2 or D3, enabling VFIO runtime suspend, and configuration
+  writes that change Memory Enable or Bus Master Enable.
+
+Rejected configuration writes leave the hardware and virtual registers
+unchanged. Unrelated configuration writes, queries and IRQ configuration
+remain available.
+
+GUEST_MEMFD_FLAG_MMAP permits MAP_SHARED mappings through guest_memfd.
+Without this flag, mmap fails with ENODEV.
+
+MSI-X SET_IRQS remains available. Userspace must keep the MSI-X table and
+PBA pages shared while host-managed MSI-X is in use and reject guest private
+mapping requests for those pages. The kernel does not enforce this policy.
+
+Use :ref:`KVM_SET_MEMORY_ATTRIBUTES2` to convert device memory by guest_memfd
+offset. Private conversion uses the memslot binding and provider PFNs to
+install protected device mappings before publishing private attributes.
+Shared conversion removes those mappings before publishing shared attributes.
+
+Revocation and memslot deletion remove shared and private mappings without
+changing file attributes. Private ranges still prevent device unlock after
+these operations; userspace must share them or release the last guest_memfd
+reference. Final release removes mappings and clears the private-range
+summary before releasing the device resources.
 
 When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
 always be consumed from guest_memfd, regardless of whether it is a shared or a
diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 662231e958a0..a2a6b4dd9a1f 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -58,6 +58,33 @@ On x86:
   kvm->arch.tdp_mmu_pages_lock and kvm->arch.mmu_unsync_pages_lock must
   also take kvm->arch.mmu_lock
 
+For device-backed guest_memfd, conversion takes locks in this order:
+
+- inode->i_mapping->invalidate_lock for write
+- IOMMUFD vDEVICE mmio_lock
+- VFIO vdev->memory_lock for read, during PFN lookup
+
+The inode invalidate lock protects attributes and offset-to-GPA bindings.
+The provider's lock()/unlock() callbacks hold mmio_lock across
+invalidation, conversion and publication of attributes. Device unlock takes
+the same mutex when checking for private ranges. Range revocation, memslot
+unbind and final file cleanup use the same order.
+
+PFN lookup during faults takes the inode invalidate lock for read, then
+memory_lock for read, without taking mmio_lock. memory_lock protects the
+power and Memory Enable checks and BAR PFN lookup against PCI state
+restore. Host faults retain the inode invalidate lock through PTE insertion.
+
+VFIO provider setup and release take gmem_lock for write, then
+dev_set->lock, before taking mmio_lock. Both outer locks protect updates to
+gmem_attached. VFIO file operations read this state under gmem_lock for
+read; reset checks can instead use dev_set->lock.
+
+VFIO resumes the device and takes a runtime-PM reference before acquiring
+mmio_lock during provider setup. It drops that reference after removing
+the provider from the vDEVICE during release. Runtime PM callbacks do not
+take the guest_memfd inode invalidate lock.
+
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
-- 
2.43.0

