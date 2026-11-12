Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469290;
	b=zP5Ih7oIgZGughVsF2ZQ+aDRmmvYNMJ27PY9itoxmPxTg2KaRZMvjrWZdFyQwkyklNgh
	 gLyr81sZl0eYWtdNwKR+hb8w0jcOaX5HFwky9qgRC61umA9apYm8Mgr5Z/Bm0nPJyYBBu
	 86QEXDp/5aI9PHhEDSzh6KowYgKL3+htTd3NY49j20A5tNaEQHBzvVt3bkEWsH9mOMEtT
	 nFk7rWye1igxd9b4B9UOblepx7dYvpPLNCCJEyI3pDkDZqDVOgclIO/mta6wfm3oHC4zP
	 i2QDWKwvbceY9ClYVD6oVRo1XRbcAq534CbYd5UTq07PCmAqitZiHY0rBoRzZbdRwkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0+XHl92WKvwhHUuO8b4CuK4owZNsBpenMK3Vh0VW7Do=;
	b=zoqpp5lWG/E7Bdy7IciF4bv61SrvJBN16Kh0rSCxBhsFYZLDLUr2o5U3S0X52QJXYIUT
	 v1PU30Xla3x2SEaG0/R3g7Wuno/mp+ls86ivkcIITLHoEGX61Z22QAxlSR3PA6MM4lFZ9
	 1wxQcXTs+y7vVx4KIIEge/+5b1KhRmnOByJs/JFiEzBajhPj1WkXY5X5wHngF+R66opiO
	 HmInDxNh0MEBL+2eI9PKKp0AVPcaHwcP14wKQ+OP3jVtV4EYXVo0lkVThnlIzXLjqap/K
	 3qt9DY6BnoduFF7kwjs/ZpGdHU7eHcEKG/y5LQHb8vHhMdbBXl9mu/BfEJrviR7UG/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="h4/E8SXE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2E2606A885;
	Thu, 12 Nov 2026 07:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h4/E8SXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCD11F00A05;
	Thu, 12 Nov 2026 07:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469289;
	bh=0+XHl92WKvwhHUuO8b4CuK4owZNsBpenMK3Vh0VW7Do=;
	h=From:To:Cc:Subject:Date;
	b=h4/E8SXE8eCIDKvYNmA6SIzFXxnJ6W3GIVA4lG+SeL6yWuG5/QiaJ/bTXAjyQD6Xd
	 rZN+CDbreZ5kcJymwg3IK2IG5cACmGvYa+xPe9v/lnThk7GUbY9QOyeaH06V2MmZZY
	 IT5Dx5WrwwVK9i41gYZRgeLNqiovLMFUpPGW5XqQX5PlTBnyfENmuMSQ4JsDan8VHN
	 16/T1SBbjoXnu68T4mh2ZcFcHFHci/iZK+c2DVMefjgrlEqikeaPlrp5czQ7yH1rhD
	 DPgM22LdulSdjsu30twsFuSgGoWNZVBvgT9FvlJ6tRAM0uNGPM4csyB/g4TEDBpUU0
	 q55wI/ApbwkkQ==
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
Subject: [RFC PATCH v5 00/16] KVM: guest_memfd: Add a common framework for device memory providers
Date: Thu, 12 Nov 2026 13:11:04 +0530
Message-ID: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
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

Confidential device assignment needs guest_memfd to manage device MMIO as
well as RAM. Device resources such as PCI BARs supply PFNs directly, and
their protected mappings need architecture-specific map and unmap
operations.

This series adds the common guest_memfd support needed by device memory
providers. It builds on the resource-provider API [1] and the existing support
for folios and RAM PFNs.

The VFIO provider, IOMMUFD integration and Arm CCA implementation are
available together at:

  https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend-v5

This series depends on the resource-provider groundwork from:
[1] https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com

Notes:
* Codex assisted with implementation, review and series organization.

Changes from v4:
https://lore.kernel.org/all/20261104150322.3516320-1-aneesh.kumar@kernel.org
* Leave VFIO changes out of this series to agree on guest_memfd changes
  that work with all providers.
* Replace the separate folio, RAM PFN and device operation tables with
  provider callbacks. Add callbacks for attribute validation, allocation,
  release, host mmap and host faults, with core helpers for providers that
  omit them.
* Use get_pfn() for both folios and PFNs through guest_memfd_handle. The
  handle carries the PFN, its attributes, contiguous range order and an
  optional folio reference. The core manages folio locking and references.
* Add nonallocating folio lookup through lookup_pfn_range() and require
  PFN providers to supply it alongside get_pfn(). Report PFN attributes
  separately from KVM shared/private memory attributes, including an MMIO
  flag.
* Remove convert_attributes() and prepare_pfn(). Make existing pages
  shared through provider range lookup, independently of VM bindings,
  before publishing shared attributes. Leave private conversion to guest
  faults or prefaults
* Pass KVM explicitly to attach() for use during attachment only.
* Use the provider mmap and fault callbacks for shared device mappings.
  Set noncached, decrypted protections in the VMA

Changes from v3:
https://lore.kernel.org/all/20261101071928.2462549-1-aneesh.kumar@kernel.org
* Include the VFIO PCI provider and IOMMUFD vDEVICE integration alongside
  the common guest_memfd framework; v3 posted only the common framework.
* Replace make_private()/make_shared() with an optional convert_attributes()
  callback, and prepare_private_pfn() with prepare_pfn(). Pass attributes to
  both to handle shared and private memory at attribute-update or PFN-lookup
  time.
* Pass the device context directly to provider attach(), removing
  kvm_gmem_get_device() and avoiding a VFIO dependency on KVM symbols.
* Store has_private_ranges in guest_memfd_device so providers can read
  the core-maintained summary directly instead of calling has_private().
* Serialize VFIO file operations with provider setup and release using
  gmem_lock. Reject existing BAR mappings, dma-buf exports and ioeventfd
  handlers, and block direct VFIO BAR access while guest_memfd uses the
  device. Shared userspace mappings go through guest_memfd.
* Require D0 and hold a runtime-PM reference while guest_memfd uses the
  device. Block VFIO reset, power-state changes and userspace changes to
  Memory Enable or Bus Master Enable during that time.

Changes from v2:
https://lore.kernel.org/all/20261017073149.1303738-1-aneesh.kumar@kernel.org
* Rebase on the v2 alternative-provider series and separate the common
  guest_memfd framework from the VFIO, IOMMUFD and Arm CCA integration.
* Separate folio, RAM PFN and device MMIO handling, with common locking,
  invalidation and attribute updates.
* Replace prepare_conversion()/finish_conversion() with non-failing
  lock()/unlock() callbacks.
* Convert device memory through ordinary file-offset attribute updates.
  Derive GPA from memslot bindings and PA from provider PFNs, removing the
  device request object.
* Allow shared and private device PFN lookup in the common layer. Include
  both mapping types in generic invalidation and leave architecture
  mapping policy to the backend.
* Support device range revocation through the common revoke path without
  reclaiming MMIO PFNs or changing attributes.
* Add shared device mmap through the existing get_pfn() fault path. Keep
  VMA protections and flags in the core
* Require only get_pfn() for device providers; lookup_pfn_range() remains
  required for RAM PFN providers.

Changes from v1:
https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org
* Require GUEST_MEMFD_FLAG_MMAP to allow VFIO BAR mmap while a provider is
  attached; disable it by default.
* Use the common guest_memfd_provider_operations for folio and PFN
  providers. Select operations through the resource mapping superblock
  and forward VFIO operations to the device driver.

Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Fred Griffoul <griffoul@gmail.com>
Cc: iommu@lists.linux.dev
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev


Aneesh Kumar K.V (Arm) (16):
  KVM: guest_memfd: Add a handle for provider PFNs
  KVM: guest_memfd: Get PFNs through common provider operations
  KVM: guest_memfd: Let providers coordinate mapping changes
  KVM: guest_memfd: Add provider PFN range lookup
  KVM: guest_memfd: Let providers validate attribute changes
  KVM: guest_memfd: Share memory through provider range lookup
  KVM: guest_memfd: Release and revoke memory through provider
    operations
  KVM: guest_memfd: Use provider operations for fallocate allocation
  KVM: guest_memfd: Use provider operations for host mappings and faults
  KVM: guest_memfd: Let providers prepare memory regions
  KVM: guest_memfd: Pass KVM explicitly to provider attach
  KVM: guest_memfd: Support devices through common provider operations
  KVM: guest_memfd: Notify providers after private attribute updates
  KVM: guest_memfd: Enable shared host mappings for device providers
  KVM: guest_memfd: Notify providers during file release
  KVM: guest_memfd: Invalidate mappings before memslot unbind

 Documentation/virt/kvm/api.rst    |   6 +-
 include/linux/guest_memfd.h       | 152 ++++-
 include/linux/kvm_host.h          |   5 +
 mm/shmem.c                        |   3 +-
 samples/kvm/mem_provider_sample.c |  22 +-
 virt/kvm/guest_memfd.c            | 996 +++++++++++++++++++++---------
 6 files changed, 868 insertions(+), 316 deletions(-)

-- 
2.43.0

