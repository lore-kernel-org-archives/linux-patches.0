Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594303;
	b=uFslS2SKKGt13vrU9L5KEcSvwP2uqNx2CtRMKUHDulam/dTBymQK3oXaZIFTnQHbLfDu
	 accMAtK8qY6OyLgBJoK5QMM5AtjDChPwLXsx5gAxHuUqXnTgt3ygCD99uDwUl46PFW1SN
	 YTJp6qeHbrX6yFGH9fnCgGp609mUjWXQollo/+Ih+xcP+YuRdHzrfh7OeMiXg8nbLf9Ez
	 Ksu/ylVlVlLgTgJJlHY10nFYmx2McVs2IeRN95IlHXW7unovzdi82chFqjzu46ENBImhk
	 PbuE6vprSea7mh2F1Qw4i0b+nmnJXRnq0WjNznOVg6PITOWUWuR1BFcXol6KjkaEtYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0D4Zq22l4G2KiXjANxkdrpR8miKSx1pC8NSG5bL0gw=;
	b=L19wOkXAJM62gZQ9K1XU0YNXy+w0zQpfp2EX4wdGcvefPB9MUgrAL9l5MbDnCJAI9aCb
	 rbZ3gbhB+70BA6HwdY5xJfOxBq3syBV7GxUtVSIfuCsg3/YAfJjEzYwHpMmDMQbpBlNAN
	 kv+j8UFjJdIkv59px75zLNnaDREzPVgZ+08wJKnzxEfBQIiCXt7tJaytADRr+i6WaDw6N
	 OK2S+1YePrTlRZPqDUxvitT2vdr0LgZundHl2xU9LwWfT10JmiUhYfzrHu2tuerHeUrGz
	 EbouNGPrwX6xP+ITKhiTlRAQxC2JRANGLPXU7JSMgq/wkTHueQyMIlIGAXX8LUQ66ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GIhQ0Mpy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19877606A323;
	Wed, 25 Nov 2026 08:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GIhQ0Mpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373611F000CF;
	Wed, 25 Nov 2026 08:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594302;
	bh=N0D4Zq22l4G2KiXjANxkdrpR8miKSx1pC8NSG5bL0gw=;
	h=From:To:Cc:Subject:Date;
	b=GIhQ0MpymZ4U+X3daWjZQmf23+o6eWd1fEos509jC9FAeAL4N8bMEbJ1GZoB8fHKy
	 cx7XuVP3CjhgmT/lT13izKH4mIuPXbV1h+IsGqCe4tkOdpunapaVwdpa/RfZc2KVGy
	 6Ave6R8nXjjTkKaowWG1aXYW2KUpMn8v0KOuydqcKf1AUactnBuLAJSaziU5umAX3E
	 6ss3fYfTVGkMWQKFokCEQ/8ryRcBLS/PJfei/J/dR/VPc6uQ6blKe2rdJFfEEGu5wk
	 Y278qZhP/0BxX9frc3zjYjwRvcqLiIedzZjzIisRdHoanWfqCu9mce40BfvsxZ3qbs
	 Dhyy6QXuiWa9Q==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v10 00/18] iommufd: TSM-backed virtual IOMMUs for confidential guests
Date: Wed, 25 Nov 2026 13:41:03 +0530
Message-ID: <20261125081121.379481-1-aneesh.kumar@kernel.org>
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

This series adds IOMMUFD and PCI/TSM infrastructure for assigning PCI
devices to confidential guests. A TEE Security Manager (TSM) can provide a
virtual IOMMU (vIOMMU), and an IOMMUFD vDEVICE object represents a physical
device within that virtual IOMMU.

The series adds a common framework for operations on vDEVICE objects and
updates lifetime management to keep the VM and device-security resources
available while those objects are in use.

The Arm CCA backend is provided in a separate series, together with
operations for TEE Device Interface Security Protocol (TDISP) state changes
and access to cached device-attestation objects.

The full series, including the Arm CCA backend, is available at:

  https://git.gitlab.arm.com/linux-arm/linux-cca.git 
  branch: cca/topics/7.4/cca-da-integration-v2

Notes:
* Codex was used to assist with commit message formatting and code
  rearrangement.

Changes from v9:
https://lore.kernel.org/all/20261116081935.85372-1-aneesh.kumar@kernel.org
* Split the PCI/TSM get/put helpers from removal of the legacy bind/unbind
  interface.
* Split the TSM lookup/reference helpers from their IOMMUFD
  callers
* Replace allocated PCI/TSM contexts with get/put helpers that update the
  DSM user count on PF0. Remove unused context accessors and
  pci_tsm_is_configured().
* Add a tagged union for the physical IOMMU and TSM pointers in a vIOMMU.

Changes from v8:
https://lore.kernel.org/all/20261104161632.3547423-1-aneesh.kumar@kernel.org
* Drop the patch taking an additional KVM file reference for the
  iommufd_device lifetime.
* Rename the IOMMU_VDEVICE_OP reserved field to __reserved and return
  -EOPNOTSUPP when it is nonzero. Keep the ioctl table entries ordered.
* Collect Reviewed-by tags.
* Address review feedback.

Changes from v7:
https://lore.kernel.org/all/20261008055955.4014342-1-aneesh.kumar@kernel.org
* Replace IOMMU_VDEVICE_TSM_REQ with the common IOMMU_VDEVICE_OP ioctl
  framework. Keep operation definitions and callbacks in the Arm CCA
  backend series.
* Replace architecture-specific request dispatch, TSM result codes and
  buffer-residue returns with operation-specific request/response formats,
  a zero-success return convention and resp_len for response lengths.
* Hold a KVM file reference for the full iommufd_device lifetime and
  require matching device/vIOMMU KVM associations for vDEVICE allocation.
* Hold TSM device and user references as well as the backend module
  reference for the vIOMMU lifetime. Make unregister reject new users
  and wait for existing users before tearing down PCI connections.
* Coordinate DSM removal with TSM unregister so the completion used to
  wait for users remains valid throughout teardown.
* Complete PCI registration before publishing the TSM device and roll
  back PCI registration if publication fails. Require PCI operations
  when registering a TSM.
* Temporarily disable AMD vIOMMU allocation while its interfaces are updated.

Changes from v6:
https://lore.kernel.org/all/20260917140159.1163281-1-aneesh.kumar@kernel.org
* Replace the IOMMUFD provider registry with per-device TSM operation lookup.
* Move vIOMMU allocation size and initialization into the selected vIOMMU ops.
* Select parent HWPT policy from the vIOMMU ops flags.
* Pin a vIOMMU's TSM backend module through vIOMMU destruction.

Changes from v5:
https://lore.kernel.org/all/20260525154816.1029642-1-aneesh.kumar@kernel.org
* Replace the TSM bind/unbind interface with reference-counted contexts.
* Add the IOMMUFD vIOMMU provider abstraction.
* Route TSM guest requests through vIOMMU ops.

Changes from v4:
https://lore.kernel.org/all/20260427061005.901854-1-aneesh.kumar@kernel.org
* Switch VFIO/iommufd to use struct file *kvm_file instead of relying on
  kvm->users_count references.
* Define TSM request scope values globally in iommufd.
* Rename the ioctl to IOMMU_VDEVICE_TSM_REQ.
* Address other review feedback.

Changes from v2:
https://lore.kernel.org/all/20260309111704.2330479-1-aneesh.kumar@kernel.org
* Bump the series revision to v4 to keep it in sync with the dependent CCA DA
  patchsets. There was no v3 posting.
* Drop [PATCH v2 1/3] iommufd/viommu: Allow associating a KVM VM fd with a
  vIOMMU
* Add two new patches to associate a struct kvm * with iommufd objects:
  iommufd/device: Associate a kvm pointer to iommufd_device
  iommufd/viommu: Associate a kvm pointer to iommufd_viommu
* Address review feedback

Changes from v1:
https://lore.kernel.org/all/20250728135216.48084-8-aneesh.kumar@kernel.org
* Rebase onto the latest kernel
* Address review feedback
* Drop the TSM map ioctl; the KVM prefault patch will be used instead to
  ensure that private memory is preallocated


Cc: Alex Williamson <alex@shazbot.org>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com> 
CC: Jacob Pan <jacob.pan@linux.microsoft.com> 
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Krishna Reddy <vdumpa@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Thierry Reding <thierry.reding@kernel.org>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: iommu@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: patches@lists.linux.dev

Aneesh Kumar K.V (Arm) (16):
  MAINTAINERS: Update TSM file coverage and repository
  virt: coco: tsm: Require PCI operations when registering a TSM
  virt: coco: tsm: Remove the device from lookup before PCI teardown
  virt: coco: tsm: Complete PCI registration before publishing the
    device
  virt: coco: tsm: Register the TSM class before device drivers
  iommufd: Add a vDEVICE operation ioctl framework
  PCI/TSM: Remove the legacy guest request interface
  PCI/TSM: Add helpers to prevent disconnect while in use
  PCI/TSM: Remove the legacy bind and unbind interface
  iommufd/viommu: Select vIOMMU operations before allocation
  PCI/TSM: Add helpers to look up and reference a device's TSM
  iommufd/viommu: Identify physical IOMMU backing with a tag
  iommufd/viommu: Allow PCI TSM backends to provide vIOMMU operations
  iommufd/viommu: Allow vIOMMUs without a parent HWPT
  PCI/TSM: Wait for DSM users before removing PF0
  PCI/TSM: Wait for vIOMMUs to release the TSM before unregistering

Nicolin Chen (1):
  iommufd/viommu: Keep a reference to the KVM file

Shameer Kolothum (1):
  iommufd/device: Associate KVM file pointer with iommufd_device

 Documentation/ABI/testing/sysfs-bus-pci       |  15 +-
 Documentation/userspace-api/iommufd.rst       |  45 +-
 MAINTAINERS                                   |   2 +
 drivers/crypto/ccp/sev-dev-tsm.c              |   5 +-
 drivers/iommu/amd/iommu.c                     |   3 +-
 drivers/iommu/amd/iommufd.c                   |  18 +-
 drivers/iommu/amd/iommufd.h                   |  11 +-
 drivers/iommu/amd/nested.c                    |   4 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  38 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   7 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  16 +-
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  25 +-
 drivers/iommu/iommufd/device.c                |   7 +-
 drivers/iommu/iommufd/hw_pagetable.c          |  17 +-
 drivers/iommu/iommufd/iommufd_private.h       |   3 +
 drivers/iommu/iommufd/main.c                  |   3 +
 drivers/iommu/iommufd/selftest.c              |  34 +-
 drivers/iommu/iommufd/viommu.c                | 178 ++++++--
 drivers/pci/tsm.c                             | 417 +++++++++---------
 drivers/vfio/iommufd.c                        |   3 +-
 drivers/virt/coco/tsm-core.c                  | 230 ++++++++--
 include/linux/iommu.h                         |  20 +-
 include/linux/iommufd.h                       |  39 +-
 include/linux/pci-tsm.h                       | 120 ++---
 include/linux/tsm.h                           |  46 +-
 include/uapi/linux/iommufd.h                  |  36 +-
 26 files changed, 858 insertions(+), 484 deletions(-)


base-commit: 65e4fd942f72a9dba0e4e257290c4fa1aa756854
-- 
2.43.0

