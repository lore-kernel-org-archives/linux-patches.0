Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817189;
	b=1jYCRvyetkSZfnyM1ZLYiZK437zt2qDgabACBKRt2FayElhyT+heW5wK+wn7xo9u9xi0
	 3Ebhn54SDjxUTQW7K8wD1VyXZ1oMQiSJoNWBa6XEv3EwxWYSkIFgWH7Xycz30e8M3SbrD
	 QVQnsQrvBeF+MdWqsRnZeBZtv8A0jOhFT7oE6LSlRax+6Pf82+IPetZvg39FousmYgXUi
	 2Z6ogfWGr8DW339marfqRT89yxljSvtLuDXz9s4NdF0xDSzs/vgZ5IIbZTghUk83hkQBz
	 YLRSSUuYSK2Y4Wu9j/6xSzxLOhXtJmMYKLdhhGTWxVMsZg21Zi2msdluptZkRWjHkEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gy2NqSH6MjEphqhvyddnbNYhdjMmE84xCCsXUr68E1k=;
	b=IAlgS1DY7JsYJvO34eygH61MP5+PXRaxpxL69xKtbulh+HGJK3H0446QAtPOPd9ih9FS
	 PGeD80mgdSilJdi1/gA3FAxFhA5oHg28qCfItiNpIxtu0C3mio8W2x/sjNuvYICiPWotd
	 lhpgrOt6VWZQzVBialRXTcrMxNT4FjHw5ocztOZiWf5eCr3dXiGyiZaeGnXCYlOlMGXB4
	 QpjrRXQtWaQd+rvqS47qByhEFW/zkDUR7VgMUCueAVpyIYpMOVUM/GtPbh4+NrPPs7XCg
	 G4WcQNURw2lJHjb72+9qgDks6FTNv9XsSNFA4gNsxeU9RcF+Q/Rlf0h+3Vb2MkCIOFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Vv8HEcU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFF9606A31C;
	Mon, 16 Nov 2026 08:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vv8HEcU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1014F1F000CE;
	Mon, 16 Nov 2026 08:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817188;
	bh=gy2NqSH6MjEphqhvyddnbNYhdjMmE84xCCsXUr68E1k=;
	h=From:To:Cc:Subject:Date;
	b=Vv8HEcU/3tf2d75zpw7BUQt2K7CHy0cy4pX4OKpwA8eT8Ebtr3W7aFogHvF+If2C9
	 elFRdmJB59exeKOB+6/sTY19alcryRCa2BfEuUtcZeMhHZMbF9/kx1kQ2HlvfBIR8s
	 UUCGI2aCDJS5T5urZMgk+Zj3cTi+u8Dr4RPTjoxeapl3Grk7YQ01KSi25PdCjeBA8M
	 2yyV17Yk+3MYop+E2xSJvTIOjcj6l/eaQFXAvY25t2Ckb3TwRV9sb5UAVyg9zPK0xk
	 md/Ni5DBsv8SGXI3MY7V7KYBBDV7NILKQ2almO+uwFzVgbDJ1qwxVKNAl71CD86cfN
	 BVh/MmYzLsk/g==
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
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v9 00/13] iommufd: TSM-backed virtual IOMMUs for confidential guests
Date: Mon, 16 Nov 2026 13:49:22 +0530
Message-ID: <20261116081935.85372-1-aneesh.kumar@kernel.org>
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

  https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/7.4/tdisp-host-rc3

Notes:
* Codex was used to assist with commit message formatting and code
  rearrangement.

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
* Move PCI/TSM core code into drivers/pci/tsm/core.c.
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
Cc: iommu@lists.linux.dev
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-coco@lists.linux.dev
Cc: linux-pci@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: patches@lists.linux.dev

Aneesh Kumar K.V (Arm) (11):
  virt: coco: tsm: Require PCI operations when registering a TSM
  virt: coco: tsm: Remove the device from lookup before PCI teardown
  virt: coco: tsm: Complete PCI registration before publishing the
    device
  iommufd: Add a vDEVICE operation ioctl framework
  PCI/TSM: Remove the legacy guest request interface
  PCI/TSM: Keep connections active while device contexts exist
  iommufd/viommu: Select vIOMMU operations before allocation
  iommufd/viommu: Allow PCI TSM backends to provide vIOMMU operations
  iommufd/viommu: Allow vIOMMUs without a parent HWPT
  PCI/TSM: Wait for device contexts before removing a DSM
  PCI/TSM: Wait for users during unregister

Nicolin Chen (1):
  iommufd/viommu: Keep a reference to the KVM file

Shameer Kolothum (1):
  iommufd/device: Associate KVM file pointer with iommufd_device

 Documentation/ABI/testing/sysfs-bus-pci       |  15 +-
 Documentation/userspace-api/iommufd.rst       |  44 +-
 drivers/crypto/ccp/sev-dev-tsm.c              |   4 +-
 drivers/iommu/amd/iommu.c                     |   3 +-
 drivers/iommu/amd/iommufd.c                   |  18 +-
 drivers/iommu/amd/iommufd.h                   |  11 +-
 drivers/iommu/amd/nested.c                    |   4 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  37 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   7 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  16 +-
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  24 +-
 drivers/iommu/iommufd/device.c                |   7 +-
 drivers/iommu/iommufd/hw_pagetable.c          |  14 +-
 drivers/iommu/iommufd/iommufd_private.h       |   3 +
 drivers/iommu/iommufd/main.c                  |   3 +
 drivers/iommu/iommufd/selftest.c              |  33 +-
 drivers/iommu/iommufd/viommu.c                | 155 ++++--
 drivers/pci/tsm/core.c                        | 448 ++++++++++--------
 drivers/vfio/iommufd.c                        |   3 +-
 drivers/virt/coco/tsm-core.c                  | 213 +++++++--
 include/linux/iommu.h                         |  20 +-
 include/linux/iommufd.h                       |  29 +-
 include/linux/pci-tsm.h                       | 154 +++---
 include/linux/tsm.h                           |  41 +-
 include/uapi/linux/iommufd.h                  |  36 +-
 25 files changed, 880 insertions(+), 462 deletions(-)


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
prerequisite-patch-id: 121492d71cc22b2adbfdedd668868c5a449ad764
prerequisite-patch-id: ed31fd728f0adba3d60dcd6f3bae8da1a2193bcc
-- 
2.43.0

