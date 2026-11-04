Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804614;
	b=aVqG5/QOgbqla+SMDOYb70RMI7ilpqAMTbjX+fmwiWrSS5l4DV73XXAz86B42/32CGOP
	 YqCijQiTzvNzCvTLSCTFcye8CX1a5z/+sxQawNJKDhE/y+edG3TwcCYInhiBzEMMRgVv3
	 WHOyLXFNayVYZ0SkWUpc/krilgb1YJ4nJUsKq+hLPsDrNTayXEL2VeR/Ppcvad811O1GZ
	 GbDrYJnqOqX7H0xkLB6feL8Bx6cr+v1flmSfp73k+DvCbo9O1uGlDqeXDBIOGH+UuaTUy
	 kcGCNwGKID74KXh0t1xecCaD7TbUFpLGPB2UyryvcNhEyhFKBu33AKSeEonAT0oJ6+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ggRHKQR+tnVpCkDd0ac2LRjtcpOMpokLMDyx1F51Qcs=;
	b=A5ze0V3gZu3ct+8pn5P/mxkRhfn3ohW2bm66dTDuqpR8lb/UZDDpdssb1bH9w/qeu9Qx
	 vr+jfFfdF2vusqVFP/PFN2+8C12pNqv+7+I/I1wvmBXFni5mUKow/7qLfZQW1OxkZt7aO
	 jGB96z5MSY/rRVmtmuyTuIGpci6ZT2GKkGH78HofrsjaSsBCgH/CsJgea68DDIWZHfTLR
	 Pg1CeQHWRuqcbgK5d/ZN8+XKlJJazNRdIwbg+ahKNyI5D4b4HlDgNsiArQsKoFbi/cBMc
	 oLafihW4AkFHtfExNcKOFiApz61nZrLM21rIFRuDKG6gRv9Wg6Q5D6InDTVaCC/UaAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTIZzUzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB97606A33E;
	Wed,  4 Nov 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTIZzUzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172261F000C1;
	Wed,  4 Nov 2026 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804613;
	bh=ggRHKQR+tnVpCkDd0ac2LRjtcpOMpokLMDyx1F51Qcs=;
	h=From:To:Cc:Subject:Date;
	b=NTIZzUzMxJP+6coME6Rr0OmO1n1pVKdiiey+P3ZPnG1jNIrlY4kwD+a1SVCvfuAWR
	 GPEeE/9DSxs246hFFOM3PGUHhdpfQDTq1GEH4grmJ349+FaMP7Zck037PbSWu6D0FH
	 XvudfHlmbuYrh1rzlqUpH6/LtPVoEuVytc44BUq9qhh8IxaXAA0o+rXH6E9PAcrI6E
	 AcUC3DMsfHuQk+0KeghZD/zet5zvFyKIwHnsGyNkoAp74SpZ9hHpCpgr4IUy41WmtI
	 8/9abD+jL+ShSKhxbeqy3QLChzjhMAuwiWvGJ+K1XJqLvmiRTMcw+9FtsrhWRuJr8K
	 s++TgWV0u5d0Q==
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
Subject: [RFC PATCH v4 00/25] KVM/VFIO: Add guest_memfd support for device MMIO
Date: Wed,  4 Nov 2026 20:32:57 +0530
Message-ID: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
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

This series adds the common guest_memfd framework for device memory and
a VFIO provider for PCI MMIO BARs, with IOMMUFD vDEVICE integration. It
builds on the resource-provider API [1] and the existing folio and RAM PFN
support.

Backing operations separate folio, RAM PFN and device MMIO handling while
sharing attribute updates and invalidation. Device conversion derives GPA
from memslot bindings and PA from provider PFNs. Revocation and cleanup
remove shared and private mappings without reclaiming MMIO PFNs.

Creating guest_memfd from an IOMMUFD-bound VFIO device rejects existing
VFIO BAR mappings, dma-buf exports and ioeventfd handlers, since these
allow access outside guest_memfd. Direct VFIO BAR access is then blocked;
GUEST_MEMFD_FLAG_MMAP enables shared userspace access through guest_memfd.

The device must be in D0. A runtime-PM reference keeps it active, and VFIO
blocks reset, power-state changes and userspace changes to Memory Enable
or Bus Master Enable while it supplies BAR PFNs to guest_memfd. MSI-X
SET_IRQS remains available; userspace must keep the table and PBA pages
shared when using host-managed MSI-X.

The series and the Arm CCA implementation are available together at:

  https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/7.4/tdisp-host

This series depends on:
[1] Resource-provider groundwork:
https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com
[2] IOMMUFD/TSM vIOMMU and vDEVICE support:
https://lore.kernel.org/all/20261008055955.4014342-1-aneesh.kumar@kernel.org/

Notes:
* Codex assisted with implementation, review and series organization.

Changes from v3:
https://lore.kernel.org/all/20261101071928.2462549-1-aneesh.kumar@kernel.org
* Include the VFIO PCI provider and IOMMUFD vDEVICE integration alongside
  the common guest_memfd framework; v3 posted only the common framework.
* Replace make_private()/make_shared() with an optional
  convert_attributes() callback, and prepare_private_pfn() with
  prepare_pfn(). Pass attributes to both so backing implementations can
  handle shared and private memory at attribute-update or PFN-lookup time.
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
* Introduce backing operations to separate folio, RAM PFN and device MMIO
  handling while sharing locking, invalidation and attribute updates.
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
Cc: Alex Williamson <alex@shazbot.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>
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

Aneesh Kumar K.V (Arm) (25):
  KVM: guest_memfd: Let providers prepare memory regions
  KVM: guest_memfd: Dispatch conversion through backing operations
  KVM: guest_memfd: Let providers coordinate mapping changes
  KVM: guest_memfd: Dispatch revocation through backing operations
  KVM: guest_memfd: Split population by backing type
  KVM: guest_memfd: Support device-backed PFN providers
  KVM: guest_memfd: Support private/shared conversion of device memory
  KVM: guest_memfd: Track private device ranges after attribute updates
  KVM: guest_memfd: Support range revocation of device mappings
  KVM: guest_memfd: Add shared device mmap through PFN providers
  KVM: guest_memfd: Clear private device state on final close
  KVM: guest_memfd: Invalidate mappings before memslot unbind
  vfio: Track device use by guest_memfd
  vfio/pci: Add helpers to check and serialize BAR state changes
  vfio/pci: Check command enable changes before updating device state
  vfio/pci: Check whether BAR state changes are allowed before reset
  vfio/pci: Check low-power requests before updating device state
  vfio/pci: Track userspace BAR mappings
  vfio/pci: Restrict host BAR access for guest_memfd providers
  vfio: Dispatch guest_memfd provider operations through the device file
  vfio: Serialize guest_memfd attachment with device file operations
  vfio/pci: Require D0 before providing guest_memfd BAR backing
  iommufd: Support MMIO provider attachment to vDEVICEs
  vfio/pci: Add a guest_memfd resource provider for MMIO BARs
  KVM: Document device-backed guest_memfd and VFIO usage

 Documentation/virt/kvm/api.rst     |  63 ++-
 Documentation/virt/kvm/locking.rst |  27 ++
 drivers/iommu/iommufd/viommu.c     |  86 ++++
 drivers/vfio/pci/Kconfig           |  11 +
 drivers/vfio/pci/Makefile          |   1 +
 drivers/vfio/pci/vfio_pci.c        |   3 +
 drivers/vfio/pci/vfio_pci_config.c | 134 ++++--
 drivers/vfio/pci/vfio_pci_core.c   | 120 ++++-
 drivers/vfio/pci/vfio_pci_dmabuf.c |   4 +
 drivers/vfio/pci/vfio_pci_gmem.c   | 327 +++++++++++++
 drivers/vfio/pci/vfio_pci_gmem.h   |  17 +
 drivers/vfio/pci/vfio_pci_priv.h   |  28 +-
 drivers/vfio/pci/vfio_pci_rdwr.c   |   4 +
 drivers/vfio/vfio_main.c           | 135 ++++++
 include/linux/guest_memfd.h        |  74 ++-
 include/linux/iommufd.h            |  26 ++
 include/linux/kvm_host.h           |   7 +
 include/linux/vfio.h               |  13 +
 include/linux/vfio_pci_core.h      |   7 +
 mm/shmem.c                         |   3 +-
 samples/kvm/mem_provider_sample.c  |   3 +-
 virt/kvm/guest_memfd.c             | 722 +++++++++++++++++++++++------
 22 files changed, 1627 insertions(+), 188 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.c
 create mode 100644 drivers/vfio/pci/vfio_pci_gmem.h


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
prerequisite-patch-id: 1d4a2fa9dc0f4b560e55f419d23835f0a9fbe485
prerequisite-patch-id: 21acd717af7d0f19db31afe0871a62b3b82ff21b
prerequisite-patch-id: 1d895ab7ebe362ca9b1941de8a58bc0a9a57124a
prerequisite-patch-id: b9003ee26d6e855f8e95aa6978372f009d98e737
prerequisite-patch-id: d8fdf7f17485c6a2905e689a5cd72c76d0d4c446
prerequisite-patch-id: 5fb6db464c1936ed74d2fc2fe4083aa9a3a968c7
prerequisite-patch-id: 03d76de408efeb5a2205079bb61face09255ca60
prerequisite-patch-id: a1635ac11bebba53e057e38c032b1e6b4cefffc4
prerequisite-patch-id: 851431bcda2a44f9475af58c86353be9aa9bbb4e
prerequisite-patch-id: 446c5c5033f7acc066ca98503af62798dca09d3c
prerequisite-patch-id: acbc4e19d554317c64bc813901434005a563da75
prerequisite-patch-id: 2c81e480010f916f7cf823b8db04e3dc90951b14
prerequisite-patch-id: 5b1537647264994178adb5e7f56d50c6cc49b234
prerequisite-patch-id: fa549035ee7387b3fe85177ae4c78b4a725a80b8
prerequisite-patch-id: 9dccd5e814d553649ee13c3f6c1cab4dc652acab
prerequisite-patch-id: 09de20b5a192aacbb036d35eecce3c94cc5680c5
prerequisite-patch-id: d0932c65d2a453e84f7917da27f9f6ae1da95856
prerequisite-patch-id: 7be8f39fdcfe7e504a9ac85e835a5dfb2ee414ba
prerequisite-patch-id: 5ee7e97d4814e41f362261deb9054485e561fc3b
prerequisite-patch-id: 45cd3951b114a26eac94390727287c1221862b5c
prerequisite-patch-id: 6d978b6f0561697e5b145e4b82d79ac8c89f9f31
prerequisite-patch-id: 9bd6979aa47dd00c87a3aa8feb1798486107ac4b
prerequisite-patch-id: 98438bd35d53340738a20fd8724b038c9de1207e
prerequisite-patch-id: 146dfaa64e29a4930adb60e9524c7613f888a241
prerequisite-patch-id: 170e27bc053fede8d24accca69809d3687faf668
prerequisite-patch-id: 789fe5bfb1183f6b9a9b0d817e5d1050a7999e1a
prerequisite-patch-id: 5dd6878d0476a9dd925aa8d7ef1cf18900cbcd82
prerequisite-patch-id: 1f0d1dca2a51df2283f1d83ed57dd9ce4e11b025
prerequisite-patch-id: 503eb8fb0bf9af163f344c2693d374b6a3093fd1
prerequisite-patch-id: 94e4777a58b357458bdce680bbb41c04c0c661f4
prerequisite-patch-id: 4c1f6b548994d239e5093ee1d268ef5a12a76873
prerequisite-patch-id: f6d13ac583d54fe1ae22adde87f5c68d8e8e41ce
prerequisite-patch-id: 7846b44d34507a9af6ac8a3fb263ee446ea56a1d
prerequisite-patch-id: 2d309198e27a3922b5cf5805ac5660ea92029219
prerequisite-patch-id: e1f75965298956ad87bb78969461eff31419b6eb
prerequisite-patch-id: 40ef669df2a64e5b28127059e4cea288d426f6f6
prerequisite-patch-id: d8adb8f100cb13423db02e7e7a834fa241ff04fe
prerequisite-patch-id: 75591ca138e7de26db6cd3e242a7f0ce56c4752c
prerequisite-patch-id: b1e2c46b473783f37490c29140498a0bb35ec7d3
prerequisite-patch-id: bc8b607986a132eef4daa5e20979d3f038d046ba
prerequisite-patch-id: c9de5cd8a95f8102597b49dcf70b8ec5825b9ec7
prerequisite-patch-id: 954606132449080c4e173eb06d114504f87d0322
prerequisite-patch-id: 82a44a46cf9d4cc3fcdc03c362fc4e86d1fc533a
prerequisite-patch-id: 23dbc9968c0b2570f40cd6c3b13337078334aa8d
prerequisite-patch-id: 6c6a5ca6d0a1b60158a47ed21f25889dd71dd9b7
prerequisite-patch-id: e4d1ba4119277d7772dbf6e81f748beab4e62856
prerequisite-patch-id: a32d69bdd1fb21b85547fdc026475e2d94ffbc28
prerequisite-patch-id: 2704fe13a294e1f33cfbee6cd27c11ee392a8b78
prerequisite-patch-id: ebb701b7e050327e798c172d897021806f7e6c35
prerequisite-patch-id: 03db7e48c976a019ce478883002670c4b1a33cd9
prerequisite-patch-id: a18608129e63bbbc6e89a4ca237863ba4c506a63
prerequisite-patch-id: a35607a73bd0329fd91a39bd7b9c855edb4b8798
prerequisite-patch-id: 6d57cd16d6c6e71c3da069c1d9eee1c86bdeee8d
prerequisite-patch-id: b64a5a718f540e7daf2dc4f0703422ad2cc52ebe
prerequisite-patch-id: eb9a9e4d7f4b7e439c5687786628f07c406864a4
prerequisite-patch-id: 2fe22fda60b4e4678bcf62d87bfd82181556af98
prerequisite-patch-id: 26211cbacdbc31a62524aa5ad402b0f3933d433e
prerequisite-patch-id: 02455f9ee70487d8b30b6aada5f5b62ff4e5ebe2
prerequisite-patch-id: 113da62f7845c2a9f86d24ed178cf52756917cc0
prerequisite-patch-id: 9ef3e8b12bc70690470035f0c6f351fa49562659
prerequisite-patch-id: 0953a92b86c0790554b64ebda5d6aed038a6cf0e
prerequisite-patch-id: 877e1c79e389936278122aa1efbdf99053b2d6c7
prerequisite-patch-id: 0b04c869d49a4c1ad96ff7b5d8e3b11c4069f23f
prerequisite-patch-id: 942b7480ddb281b9df74705f1a3a6e23a2440a43
prerequisite-patch-id: 98c3864233a7ba6d789ad260f4af170a020d2929
prerequisite-patch-id: 40dc0f2b1ab5e59f1f5de0be5134101ca896d13d
-- 
2.43.0

