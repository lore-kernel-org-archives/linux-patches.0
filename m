Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793364051;
	b=TtoiG7tQ5GY5wUUqgD42YtNySoJLkDadB2Ihd08jjVG3VpXIk4HvpW7s20XazcJip3vF
	 BjOrVpV8gFu2yVtRPdFP3EVrklo6mPPH96IhLXPSFOo1UIqzFLCtlSspl3d//9Mmge8rG
	 qC+oi0VSaiTowBv8ZGDvGBvQvHuFIDJHm0vLnzRO2DE7Oz+ir0xanz1+G8gTtcuRXWfUl
	 vVhdAw5q/kQqBNU0sxt4gO46mpTKQzwlO5KQxiwedjB7L5ytSD+gsPyupPCvRPHCxb0ah
	 SsXjVj1l8/s9+QYTF3HV1Aq2sC5jNXlSNWxL2k8xXOro7rzkQxZDvgpvpDYk+KbeglA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793364051;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=QsWRUULncElOkf1r1RZbOEtc8LMV1HSqJrWBMqyS57U=;
	b=2KYAW2XGO3JwCT9XN0xNi04dxJXx54K2E2tlhc8+PiReNK8cMkJBDqTtMGlEnKJQ8b28
	 mIdLGao+w2v3M5G9Ch7tJB85wiiCEhfvqmJ9kXHQ7w6hrEMVmtX2OKPuN8Jk//0bumV/S
	 YZcLU5eL98U5zPak0zm7V91pIqNbc9tpRmSfBLvnJLOaW4Kl2G98GQ1ROzE93Nbry/yFP
	 jxxY8T1hlhdm6y/cjk6OssfHsUXlD3aIEBrtbPNvUWLPyHh7RaNFlTwJ+AyoC3unWwOCK
	 agvLl1MW/2eW98rOeyls8KBIU9k5dpsq0/ZAPee14n677WdgQGWrmPzye7Qmnv6kSPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CARRhfvX;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E261606A31A;
	Fri, 30 Oct 2026 12:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E261606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CARRhfvX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793364050; x=1824900050;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v+IH6Hjh/zaqusOfU2SkygwiLiSOjdHEjEXEunjq998=;
  b=CARRhfvXwuYN9wBdKYvByF2CASCslPQguxvue6AUwJzk4YP97lAVsMxJ
   S943BnpvgsQqIiz8o3J+LorFgfE78J4BFvt7jRJCJ4lFissOiZPp2zdHk
   RVpK4D37qerJ164xrVCSw7S1+pQVlItcqVq++l2BJY/VxYW00T83hapf9
   sMJblsbBI1v5c0lgFFWm4fLDMjen22yDyPFIqgDH8mYXEDmAtpCas7OTe
   RcJxkiZWfVvh0Q9k4w+BDovVreL+Ri5ytNfharncS28QoFm5kZBhSri+B
   X73J4yydLn9v5vp+GBXu74tSABh/j0hyN/qgwwUNslSDmlbPVy5Qetvaa
   Q==;
X-CSE-ConnectionGUID: lPlN6YzhSn2ApKKzkKc13Q==
X-CSE-MsgGUID: v9iswvrqRrmyMijG9VK8VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2013001"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2013001"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 05:40:49 -0700
X-CSE-ConnectionGUID: ZQoqx4s9QtuK3Odqwp4X7Q==
X-CSE-MsgGUID: Ktwj/kB9S0CI7FWevtP+gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5512269"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.47.46])
  by orviesa009.jf.intel.com with ESMTP; 30 Oct 2026 05:40:45 -0700
Date: Fri, 30 Oct 2026 20:34:28 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>,
	Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 00/11] PCI/TSM: Add CTLV attestation
Message-ID: <auSO1IDQ8iN6wHVv@yilunxu-OptiPlex-7050>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028152618.1356860-1-aneesh.kumar@kernel.org>

On Wed, Oct 28, 2026 at 08:56:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This series connects PCI/TSM to the common CTLV attestation interface.
> Userspace can discover a device's evidence objects, retrieve them, and
> accept the evidence before the kernel establishes a secure link or moves
> a guest device into TDISP RUN. It replaces the PCI/TSM netlink evidence
> interface while retaining connect, disconnect, lock and unlock in sysfs.
> 
> This series builds on the CTLV attestation series [1] and Arm CCA
> device-assignment support. It covers PCI/TSM attestation through
> certificate slot-zero.
> 
> The development tree is available at:
> 
>   https://gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-attestation
> 
> That branch also includes the follow-up Rust SPDM certificate-slot
> discovery work, generic attestation fixes, and CTLV tooling fixes.
> 
> [1] https://lore.kernel.org/all/20261015145053.3664509-1-jiri@resnulli.us
> 
> The host flow separates identity collection from session and IDE setup:
> 
>   sysfs connect
>     -> collect and cache the certificate chain
>   DEVICE_GET / EVIDENCE_GET
>     -> discover available objects and retrieve the chain for verification

Is it possible that these two steps combined to one? They collect, cache
the certificates, then hand over the cache to userspace when requested. Why
not just use one user interface to collect and hand over the certificates?

And I see a further action is to use kernel native SPDM (rust SPDM) to
finish these 2 steps, so they will have nothing to do with TSM any more.


Could the flow be:

1. DEVICE_GET/EVIDENCE_GET
	-> collect and retrieve the certificates via native SPDM
2. sysfs connect
	-> establish the *TSM-based* secure session and IDE streams
3. sysfs disconnect
	-> release the *TSM-based* streams and identity context

This way we don't even touch the existing host side TSM.

>   EVIDENCE_ACCEPT
>     -> establish the secure session and IDE streams
>   sysfs disconnect
>     -> release the identity context and any established streams
> 
> Both AMD SEV-TIO and Arm CCA host drivers implement this flow using their
> existing firmware interfaces. AMD pauses the firmware SPDM exchange after
> collecting the certificate chain, before sending authentication or session
> establishment requests. CCA creates the PDEV and collects its certificate
> chain during connect, then completes session and stream setup on acceptance.
> After both conversions, every link driver must supply an evidence_accept
> callback; connect collects identity evidence without establishing streams.
> 
> This is the slot-zero baseline: the AMD and CCA host drivers expose their
> slot-zero certificate chains. A follow-up series adds shared SPDM identity
> discovery and selection among discovered certificate slots. The common
> interface supports any certificate slot advertised by the driver, and the
> same evidence-get and evidence-accept commands apply to both series.
> 
> For a guest device, sysfs lock collects the initial evidence and creates
> the CTLV instance. Userspace can optionally refresh supported objects,
> retrieve the cached evidence, verify it, and issue EVIDENCE_ACCEPT to enter
> RUN. The CCA guest driver supports refreshing measurements with a 32-byte
> challenge or an interface report without a challenge. It checks the new
> bytes against trusted digests and device state before replacing the
> selected cached object. Refresh is disabled after the device enters RUN.
> 
> EVIDENCE_GET reads the cached snapshot, so its challenge attribute becomes
> optional. EVIDENCE_REFRESH requests new evidence and invalidates previous
> evidence generations and acceptance. A failed backend refresh also
> invalidates them and requires recovery.
> 
> EVIDENCE_ACCEPT replaces the separate DEVSEC_RUN operation. Clearing
> acceptance leaves the hardware state unchanged: a guest device can remain
> in RUN, and host IDE streams remain established. DEVSEC_STATE_GET therefore
> continues to report acceptance and device state separately. Disconnect and
> unlock perform teardown.
> 
> The common attestation changes let each instance expose the operations and
> evidence objects its device supports. This allows host links and guest
> devices to share the PCI attestation implementation while advertising
> different capabilities. Additional locking and generation helpers let
> PCI/TSM coordinate state changes, evidence invalidation and notifications
> with CTLV operations.
> 
> The PCI child family adds STATE_GET and EVIDENCE_REFRESH to the inherited
> attestation operations. An instance appears only after a successful connect
> or lock and is removed on disconnect or unlock. DEVICE_GET includes the
> PCI name so userspace can associate an instance with its device.
> 
> The first five patches prepare the common attestation interface. The next
> three define and implement the PCI integration, including its locking
> helpers. The final three convert AMD and CCA host link setup and add CCA
> guest evidence refresh. The series builds on the existing CTLV attestation
> and PCI/TSM device-assignment support.
> 
> Notes:
> * I used Codex to help implement, review and organize the series.
> 
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Xu Yilun <yilun.xu@linux.intel.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Kiryl Shutsemau <kas@kernel.org>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: patches@lists.linux.dev
> 
> Aneesh Kumar K.V (Arm) (11):
>   attestation: Restrict inherited operations per instance
>   attestation: Filter evidence objects per instance
>   attestation: Enter secure operation when evidence is accepted
>   attestation: Bind object selection to accepted evidence snapshots
>   attestation: Make the evidence-get challenge attribute optional
>   PCI/TSM: Describe the PCI attestation control family
>   attestation: Add attestation helpers for PCI/TSM integration
>   PCI/TSM: Bind CTLV attestation to connected and locked contexts
>   crypto/ccp: Defer SEV-TIO link setup until evidence acceptance
>   virt: coco: arm-cca-host: Publish slot zero and establish streams
>     after acceptance
>   virt: coco: arm-cca-guest: Refresh selected evidence against trusted
>     digests
> 
>  Documentation/ABI/testing/sysfs-bus-pci       |  108 +-
>  Documentation/ABI/testing/sysfs-class-tsm     |    9 +-
>  .../ctlv/abi/ctlv-attestation-pci.yaml        |   43 +
>  Documentation/ctlv/abi/ctlv-attestation.yaml  |   59 +-
>  Documentation/ctlv/abi/families.registry.yaml |    1 +
>  Documentation/ctlv/families.yaml              |    1 +
>  Documentation/ctlv/generated-files.yaml       |   11 +
>  .../ctlv/specs/ctlv-attestation-pci.yaml      |   79 +
>  .../ctlv/specs/ctlv-attestation.yaml          |   40 +-
>  Documentation/driver-api/attestation.rst      |   56 +
>  Documentation/driver-api/pci/tsm.rst          |  160 +-
>  Documentation/netlink/specs/pci-tsm.yaml      |  151 --
>  drivers/attestation/core/core.c               |  123 +-
>  drivers/attestation/core/ctlv.c               |  156 +-
>  drivers/attestation/core/internal.h           |    3 +
>  .../generated/ctlv_attestation_gen.c          |   45 +-
>  .../generated/ctlv_attestation_gen.h          |   76 +-
>  drivers/attestation/providers/sim.c           |   40 +-
>  drivers/attestation/tests/core_kunit.c        |   72 +-
>  drivers/crypto/ccp/sev-dev-tio.c              |   17 +-
>  drivers/crypto/ccp/sev-dev-tio.h              |    5 +
>  drivers/crypto/ccp/sev-dev-tsm.c              |  188 +-
>  drivers/pci/Kconfig                           |    3 +
>  drivers/pci/tsm/Makefile                      |    6 +-
>  drivers/pci/tsm/attestation.c                 |  525 +++++
>  drivers/pci/tsm/core.c                        |  431 +++--
>  drivers/pci/tsm/ctlv_attestation_pci_gen.c    |  111 ++
>  drivers/pci/tsm/ctlv_attestation_pci_gen.h    |  100 +
>  drivers/pci/tsm/evidence.c                    |  274 ---
>  drivers/pci/tsm/internal.h                    |   26 +
>  drivers/pci/tsm/netlink.c                     |   43 -
>  drivers/pci/tsm/netlink.h                     |   23 -
>  drivers/virt/coco/arm-cca-guest/main.c        |  168 +-
>  drivers/virt/coco/arm-cca-guest/rsi-da.c      |   16 +-
>  drivers/virt/coco/arm-cca-host/main.c         |  143 +-
>  drivers/virt/coco/arm-cca-host/rmi-da.c       |    7 +-
>  drivers/virt/coco/arm-cca-host/rmi-da.h       |    2 +
>  include/linux/attestation.h                   |   93 +-
>  include/linux/pci-tsm.h                       |   86 +-
>  include/linux/pci.h                           |    2 +
>  include/uapi/linux/ctlv_attestation_gen.h     |   25 +-
>  include/uapi/linux/ctlv_attestation_pci_gen.h |   74 +
>  include/uapi/linux/ctlv_families_gen.h        |    1 +
>  include/uapi/linux/pci-tsm-netlink.h          |  101 -
>  samples/devsec/common.c                       |    1 -
>  samples/devsec/link_tsm.c                     |   17 +-
>  samples/devsec/tsm.c                          |   32 +-
>  tools/ctlv/tests/support.py                   |    3 +-
>  tools/ctlv/tests/test_outputs.py              |    6 +-
>  tools/ctlv/tests/test_semantics.py            |   38 +
>  tools/ctlv/tests/test_spec.py                 |    1 +
>  .../selftests/attestation/attestation_test.c  |   32 +-
>  .../ctlv_attestation_pci_user_gen.c           | 1697 +++++++++++++++++
>  .../ctlv_attestation_pci_user_gen.h           |  230 +++
>  .../ctlv_attestation_sim_user_gen.c           |  161 +-
>  .../ctlv_attestation_tdx_user_gen.c           |  161 +-
>  .../attestation/ctlv_attestation_user_gen.c   |  161 +-
>  .../attestation/ctlv_attestation_user_gen.h   |   70 +-
>  .../attestation/tdx_attestation_test.c        |    9 +-
>  59 files changed, 4678 insertions(+), 1644 deletions(-)
>  create mode 100644 Documentation/ctlv/abi/ctlv-attestation-pci.yaml
>  create mode 100644 Documentation/ctlv/specs/ctlv-attestation-pci.yaml
>  delete mode 100644 Documentation/netlink/specs/pci-tsm.yaml
>  create mode 100644 drivers/pci/tsm/attestation.c
>  create mode 100644 drivers/pci/tsm/ctlv_attestation_pci_gen.c
>  create mode 100644 drivers/pci/tsm/ctlv_attestation_pci_gen.h
>  delete mode 100644 drivers/pci/tsm/evidence.c
>  create mode 100644 drivers/pci/tsm/internal.h
>  delete mode 100644 drivers/pci/tsm/netlink.c
>  delete mode 100644 drivers/pci/tsm/netlink.h
>  create mode 100644 include/uapi/linux/ctlv_attestation_pci_gen.h
>  delete mode 100644 include/uapi/linux/pci-tsm-netlink.h
>  create mode 100644 tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.c
>  create mode 100644 tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.h
> 
> -- 
> 2.43.0
> 
