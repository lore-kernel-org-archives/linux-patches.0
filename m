Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517584;
	b=3UxpehzezCGXx9tAQ2GYyS42bbVg+38/Jk/dEadw5uqOKhj6QsM0rXb8Bb3uc3SvXWzG
	 uetWlXO/5YjcLUPz9W9VR3seypnF6gGG9094/g9SraDWfCMKlwVk4u3hNCwhUPluRejyB
	 vlpT+QrHh5g66ZiQCHYJG5jc8FtfS5lhMv2qeWwpyXt3Eb9YnevGRQIuiqAAOXC2hlycb
	 9sRv5bSDrNgniSjWCIloE2j8b0bC4RbncD2ZcxHjOIGzwozkAU72waNp9rKWlBrOxzLMY
	 E1OfcRh7jBYI5hatsYvroZPwhK7YkWVV/fppw0EjcFVH3IHJxMvFoHb9qVD2Q+WIBPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OiA++KVOcAAt1XjVBpM3SgjQo9cp64mQ4Jp+CeE0vuo=;
	b=iT0PC6T/CWM82sw3Z2/p1lrUn+jcSfDhf+sgziucCaJpZ5GBrRyzRWpHO1h5EracJYLG
	 nbhUAc3KiiwOLjMoXCM3ewDXrcwDyev57zi6RU44rhd6BPQNduRCyHm2+c4clkIW2/q0s
	 Mq7iM1qVPdNZ7NGJkkSQiMJh2Ix7O7voZ8jIyqT83eUVO6aqe8MFn2xr5J6kAvdQ86f/V
	 CYVAHwb+s7LOQ3Qz0cG45uCy/RjM/MItmKLFcMpSeXGBhjRZVatinWh1FI3cSpgyOUVq9
	 aDreb3+Wo96E6/Q/WYMkbHCwd8cxQXhIGHqSQFvSQ4rFtxjXQkhEl+VAtRw+k2NpBYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jhnWeLVY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C68606A324;
	Sun,  1 Nov 2026 07:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jhnWeLVY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667CC1F000C1;
	Sun,  1 Nov 2026 07:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517583;
	bh=OiA++KVOcAAt1XjVBpM3SgjQo9cp64mQ4Jp+CeE0vuo=;
	h=From:To:Cc:Subject:Date;
	b=jhnWeLVY0zKULho6+joy1cTY3NNgHE7oGtdq13aeEz0CyTfwCMtptzstvW5AW3tBz
	 kttsJZLrfM1DrsiCxE3tQQVl007VB9PloTUP0uwShMeogofjyEA1Or757rDgyW+3s6
	 lp2nPUUZTFRgNU9lEzpHVm5Y+Q8uy2W43l65aDw4u6ckuEQr2OqLJsFJJHOs3yzHAI
	 814DeGyLvoK8nRgH2qDt8CRZkz5PocMw0xWcMFz8B/doWhGs7LAuP+E8cWpXWPhCuF
	 idpLeUJYezPG4fl8JAlPHrJ+zpPOSv7ccdeOJIXgNXv4Gm8dj6GgfJ9cQvGZDROGKu
	 RTXrx4wAlkt1Q==
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
Subject: [RFC PATCH v3 00/13] KVM: guest_memfd: Add a common framework for device memory providers
Date: Sun,  1 Nov 2026 12:49:14 +0530
Message-ID: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
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
providers. It builds on the resource-provider API [1] and the existing
folio and RAM PFN backing support.

The VFIO provider, IOMMUFD integration and Arm CCA implementation are
available together at:

  https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend

This series depends on the resource-provider groundwork from:
[1] https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com

Notes:
* Codex assisted with implementation, review and series organization.

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
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Fred Griffoul <griffoul@gmail.com>
Cc: iommu@lists.linux.dev
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev


Aneesh Kumar K.V (Arm) (13):
  KVM: guest_memfd: Let providers prepare memory regions
  KVM: guest_memfd: Dispatch attribute conversion through backing
    operations
  KVM: guest_memfd: Let providers coordinate mapping changes
  KVM: guest_memfd: Dispatch revocation through backing operations
  KVM: guest_memfd: Split population by backing type
  KVM: guest_memfd: Support device-backed PFN providers
  KVM: guest_memfd: Support private/shared conversion of device memory
  KVM: guest_memfd: Track private device ranges after attribute updates
  KVM: guest_memfd: Expose device provider private state
  KVM: guest_memfd: Support range revocation of device mappings
  KVM: guest_memfd: Add shared device mmap through PFN providers
  KVM: guest_memfd: Remove device mappings on final close
  KVM: guest_memfd: Invalidate guest_memfd mappings before removing
    memslot bindings

 Documentation/virt/kvm/api.rst |  21 +-
 include/linux/guest_memfd.h    |  84 +++-
 include/linux/kvm_host.h       |   7 +
 virt/kvm/guest_memfd.c         | 690 ++++++++++++++++++++++++++-------
 4 files changed, 660 insertions(+), 142 deletions(-)

-- 
2.43.0

