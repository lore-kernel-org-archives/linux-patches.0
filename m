Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422828;
	b=q1TRZKNbRWuZ9Fb1x9gyCYIZ0CibJHrJVWTceJr3IIOJhYQyoe3XhxcxpBO5sooce5n3
	 4E7vm0L21dn+t1et8Hc2yis7C19UxKpaONakaHV+/BOeCtjwEYu6Kp7OmVtB3w8pcG57L
	 xFpc/HAyglZKJAfToWhvmXI8XM3GUVyZBoDekNVEySLEaDJbcsWITl1uwtdSgYYMUoz+g
	 +CtKS4G8Nq7kVK6utTkGvCGGRCbygq/I4HE3t39lrCYDYm5DXKL3p4fxvIAuZj2fpeXuD
	 D/jOHVjETG/RU/K7CwTN4F294CTlaDawsQYx+L5ErS3Tm98GMF1UbYsj0oyOn6MX8/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+1fZ+krt+vzNzwK8rFQAhFc+bk+b5FPV1LAd7hc8WOA=;
	b=nTPa5j2HZ/AX9pSIWEld6qlxOLjc9kuKrv17M9AryfkE3K3cUbjKDdSfH06UURfpvtTV
	 Px3GE+uDXpMPPfZ5BxX7yWtHJ+odgmfO5nVKt/S6UPjW3pkL/1yGFXiIYiQrJ/zQl6sJ6
	 8/NBeS57DqCyGrV+NBfN8LvWlqP5fr5YUW4ErstZysn+XVeTgO/VqruQzkukb9a+yNbqg
	 +0QMdQOhaOwd51L3IG1uaqY0MymH8dNA5SIMFJRr/LnFaKXaLJFvGHiYqPPzeDfeFKT9A
	 rVarI251PzRbqupK7iB4CzVxTrwNuCG6Gylpnc4q0fidFhi9ktcJHXr5159pSUspG7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=liy8onB1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E5E606A31A;
	Mon, 23 Nov 2026 08:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=liy8onB1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC01F000C4;
	Mon, 23 Nov 2026 08:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422827;
	bh=+1fZ+krt+vzNzwK8rFQAhFc+bk+b5FPV1LAd7hc8WOA=;
	h=From:To:Cc:Subject:Date;
	b=liy8onB1uUxbEhYfGGD4DjWd1yVqyirivYPRPnm3vzEiPIT1y6VX2p8ykP/osZhAQ
	 cmKsabaXtGVw3sHAWHHBVAUh9Dnz1m0KBNGO6C24F9ryY0OZ0zOtOUmDITGAoz5suE
	 +zmSEcXwl6oV3Wyue6SIfQg2LvLcJIKbVGENnXdnrpbiusVk+/JCX6PDmNq5zQQMrk
	 NBAdoH4PIE2DgVA60mgi4cswkeTVgh1aD+6S7z5DP+4TxMxN1XfuUBzjbua+NY3a++
	 FYKsNWXBu3rrlWUlbuMSFw5U7rM50sLczieE9QiCD17lkRunB+ks+vyzEVBQK1OnZY
	 rI1GW9bkdtwsw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v1 00/10] PCI/TSM: Support guest TSM drivers
Date: Mon, 23 Nov 2026 14:03:27 +0530
Message-ID: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
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

This series adds the PCI/TSM support needed by a TEE Security Manager
(TSM) driver in a confidential guest. It adds device lock/unlock,
helpers for recording device acceptance and parsing MMIO reports, and
DMA callbacks used during PCI driver attachment. The guest TSM driver and
attestation commands using these interfaces are in follow-up series.

This series is based on Dan Williams' "[PATCH v2 00/19] PCI/TSM: TEE I/O
infrastructure" posting [1], particularly the guest LOCK/UNLOCK, ACCEPT
and MMIO report work [2-4]. It retains device_cc_accepted() and the
confidential-device acceptance model from that posting, with changes
adapted to the current PCI/TSM structures and reference APIs. Dan's
device-core acceptance helper and per-host-bridge IDE stream reporting
patch are also included.

This series does not adopt the Device Trust changes from Dan's "Device
Evidence and Trust for PCI Security Protocol (TDISP)" [5]. That work is
being developed separately in Leon Romanovsky's "driver core: Authorize
device trust before driver binding" series, [6]. Confidential-device
acceptance is kept separate from that driver-binding trust policy.

The guest flow separates three operations:

* Lock the device through tsm/lock. This requests the TEE Device Interface
  Security Protocol (TDISP) LOCKED state, so userspace can verify evidence
  about the locked configuration. Unlock releases the device configuration
  and the TSM driver's per-device state. Neither operation is permitted
  while a PCI driver is attached.
* Request device use through the attestation evidence-accept operation.
  A follow-up guest TSM driver validates the reported MMIO mappings,
  requests TDISP RUN and marks the device accepted. This series supplies
  the device acceptance state, MMIO report helpers and PCI/TSM locking
  helpers needed for that work.
* Enable DMA during PCI driver attachment, after platform DMA configuration
  and IOMMU setup, before the PCI driver's probe function. Disable DMA
  during driver detach and setup cleanup. Hold TSM user, device and module
  references until DMA cleanup finishes calling the TSM driver.

Compared with the earlier posting, evidence retrieval and acceptance use
attestation rather than PCI/TSM evidence storage and the sysfs accept
attribute.

This series is based on the IOMMUFD/TSM vIOMMU and vDEVICE work [7]. It
uses that series' TSM references, unregister waits and struct pci_tsm_context
references. The architecture-specific CCA host and guest drivers and their
SPDM attestation operations are in separate follow-up series.

The full patchset, including attestation, Device Trust, IOMMUFD,
guest_memfd and the Arm CCA host and guest changes, is available at:

  https://git.gitlab.arm.com/linux-arm/linux-cca.git
  branch: cca/topics/7.4/cca-da-integration-v1

Notes:
* Codex assisted with implementation, review and series organization.

[1] https://lore.kernel.org/all/20260303000207.1836586-1-dan.j.williams@intel.com/
[2] https://lore.kernel.org/all/20260303000207.1836586-7-dan.j.williams@intel.com/
[3] https://lore.kernel.org/all/20260303000207.1836586-8-dan.j.williams@intel.com/
[4] https://lore.kernel.org/all/20260303000207.1836586-10-dan.j.williams@intel.com/
[5] https://lore.kernel.org/all/20260705220819.2472765-1-djbw@kernel.org/
[6] https://lore.kernel.org/all/20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com/
[7] https://lore.kernel.org/all/20261116081935.85372-1-aneesh.kumar@kernel.org/

Cc: Dan Williams <djbw@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: driver-core@lists.linux.dev
Cc: linux-pci@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev

Aneesh Kumar K.V (Arm) (9):
  coco: tsm: Register the TSM class before device drivers
  PCI/TSM: Let TSM drivers discover the CMA DOE mailbox
  PCI/TSM: Defer TSM vDEVICE allocation until device setup completes
  PCI/TSM: Add association locking helpers for evidence acceptance
  PCI/TSM: Notify TSM drivers before waiting for TSM user references
  device core: Add helpers to record confidential device acceptance
  PCI/TSM: Add sysfs lock and unlock for guest-assigned devices
  PCI/TSM: Build encrypted MMIO descriptors from a supplied report
  PCI/TSM: Configure accepted device DMA during driver attachment

Dan Williams (1):
  PCI/TSM: Report active IDE streams per host bridge

 Documentation/ABI/testing/sysfs-bus-pci   |  35 +-
 Documentation/ABI/testing/sysfs-class-tsm |  32 +
 Documentation/driver-api/pci/tsm.rst      |  47 ++
 MAINTAINERS                               |   1 +
 drivers/base/Kconfig                      |   4 +
 drivers/base/Makefile                     |   1 +
 drivers/base/base.h                       |   9 +
 drivers/base/coco.c                       |  68 ++
 drivers/crypto/ccp/sev-dev-tsm.c          |   7 +
 drivers/pci/Kconfig                       |   2 +
 drivers/pci/ide.c                         |   4 +
 drivers/pci/pci-driver.c                  |  31 +-
 drivers/pci/tsm.c                         | 749 ++++++++++++++++++++--
 drivers/virt/coco/tsm-core.c              | 150 ++++-
 include/linux/device.h                    |  22 +
 include/linux/ioport.h                    |   1 +
 include/linux/pci-ide.h                   |   2 +
 include/linux/pci-tsm.h                   | 130 +++-
 include/linux/pci.h                       |   1 +
 include/linux/tsm.h                       |   4 +
 20 files changed, 1248 insertions(+), 52 deletions(-)
 create mode 100644 drivers/base/coco.c


base-commit: 65e4fd942f72a9dba0e4e257290c4fa1aa756854
prerequisite-patch-id: 121492d71cc22b2adbfdedd668868c5a449ad764
prerequisite-patch-id: 266d2641e47ccf8f57f8ca77d90d193f9cfabbbd
prerequisite-patch-id: 5502ecfa0b2659885b221f103d44d473c72fec03
prerequisite-patch-id: 6ec85de28f71ce761596e493a68a56242327c0b1
prerequisite-patch-id: f6e97602a5b06ffddd2cd3c2815bed27411d51e3
prerequisite-patch-id: 03d76de408efeb5a2205079bb61face09255ca60
prerequisite-patch-id: 51872ad4fcd244f3425b81f5a0f05acd4ffa5c39
prerequisite-patch-id: b56e823a40dc6d1e70e74a00cf3e1da2d0ecc9d7
prerequisite-patch-id: 53dcbe1d39b6848f778eba736a2779b0e587cfcb
prerequisite-patch-id: 66c884ec28e3d15a174dfb288858b174fb21480d
prerequisite-patch-id: 18a7425cf79e0a14ac934cb2a194b27a62d50c9d
prerequisite-patch-id: e47eb53d14d6f6180eb0606d721bfd55d74c96b3
prerequisite-patch-id: ce898fc01b883c3318a6bdb883578b8b4e4299a2
prerequisite-patch-id: 416778d72f4ade8c0f13b9fe3e619ec9d5e9634b
prerequisite-patch-id: d30d30bbe67196c41b592e79fd0c15a78bec0ae7
-- 
2.43.0

