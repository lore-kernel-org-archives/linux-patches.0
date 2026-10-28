Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201192;
	b=LqQE+tgsynHIv3q5Sys1oaiGc35IigocomrUH1+8bWq+P6TOSHw8ZhgXgsFLneIRZpI7
	 tfgu26OiRTU7NOUhi1ACP3iA7gvnMzfMgSiYkWatUucNmXWFaFEFUIcc/7+EJOLw7QcI3
	 wwuoSCAY1ukUhNDfZxTwzpkCNUbX8gWA+vdFGJosWNc5IvzCjBMF0FJ9U23GBjU7efvra
	 GhsdBXzdO0cllpwfeAXKcGHZSCR8odHZnnxcJ/rt0nMW4QPkF/jJRLi57P0qNMy8T4XmX
	 3dkD/82qW23rRu2vJ51UWkezI5ARF95M+sd1zFCmWH2Ei/74MnGgUSA9B1ztIDyFPyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4QrQ4422nVWsVT0PKxpI5qL5io5ysuWs3V/welhce7M=;
	b=U5xON3+KzBupi03sSGf70eGCoKwgGnS3bley5kKsW7mbxQNT2PYdjUe+/dWvBXdev4lX
	 qA96Rtqbi3fgeNoJZkodK/ogGy9zE9zsfR8q5DDYHfwk68z3lVGa/+wZZIMLA1ZMsXaav
	 1k3NSQ4zLi9aJe5/NSDPluUQYTaQEQL+XlR3SICGJ5uvGoSgJ2wJ2Mt8E5198ICcO5hen
	 UBLsML13DdknHwRX1GBVs5CVIxqiCZ75YR+mt0uonQci5aRoqIDRT330YLMQOgUrAXlX0
	 1xblXG5xAjGF/3n2vL5vu74SULphUDPDVDkFsg5oTnyquUyutgFey6ovRdevxl1zKwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bahadChm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A588E606A322;
	Wed, 28 Oct 2026 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bahadChm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10ED1F01825;
	Wed, 28 Oct 2026 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201191;
	bh=4QrQ4422nVWsVT0PKxpI5qL5io5ysuWs3V/welhce7M=;
	h=From:To:Cc:Subject:Date;
	b=bahadChmlp5X+1KdDCUwA6mVpb3Bh+zDvAqW3dk/CEfkjgMnHVaGSrinjT3e6Drl6
	 Y2AzowKg42A8ir9RVgp3H8VVl1olxH86vusHiZfCeUkZs2MJZ+n0szHE/99+NN5sHJ
	 5mdYWXCzpBe8VKmPs8Nq3fU2U9cWAYRkp9Lmv+Se7qD6U6mWvlM444LxhDnoV6l0CO
	 p1DPqoe8AbrQiZCLHXBbvvZTm7XdZW2klHw+x88BzbWx7TwaT0murzYp83RytDdrxB
	 UsGWfRIIYm3P3USI/RDYF9LIekrXeudLd1k/LNo5j5W3l57OyXQMjOCSPshj/uT8qg
	 o4DMJN5kC0ieg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
	John Allen <john.allen@amd.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	patches@lists.linux.dev
Subject: [RFC PATCH v1 00/11] PCI/TSM: Add CTLV attestation
Date: Wed, 28 Oct 2026 20:56:07 +0530
Message-ID: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
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

This series connects PCI/TSM to the common CTLV attestation interface.
Userspace can discover a device's evidence objects, retrieve them, and
accept the evidence before the kernel establishes a secure link or moves
a guest device into TDISP RUN. It replaces the PCI/TSM netlink evidence
interface while retaining connect, disconnect, lock and unlock in sysfs.

This series builds on the CTLV attestation series [1] and Arm CCA
device-assignment support. It covers PCI/TSM attestation through
certificate slot-zero.

The development tree is available at:

  https://gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-attestation

That branch also includes the follow-up Rust SPDM certificate-slot
discovery work, generic attestation fixes, and CTLV tooling fixes.

[1] https://lore.kernel.org/all/20261015145053.3664509-1-jiri@resnulli.us

The host flow separates identity collection from session and IDE setup:

  sysfs connect
    -> collect and cache the certificate chain
  DEVICE_GET / EVIDENCE_GET
    -> discover available objects and retrieve the chain for verification
  EVIDENCE_ACCEPT
    -> establish the secure session and IDE streams
  sysfs disconnect
    -> release the identity context and any established streams

Both AMD SEV-TIO and Arm CCA host drivers implement this flow using their
existing firmware interfaces. AMD pauses the firmware SPDM exchange after
collecting the certificate chain, before sending authentication or session
establishment requests. CCA creates the PDEV and collects its certificate
chain during connect, then completes session and stream setup on acceptance.
After both conversions, every link driver must supply an evidence_accept
callback; connect collects identity evidence without establishing streams.

This is the slot-zero baseline: the AMD and CCA host drivers expose their
slot-zero certificate chains. A follow-up series adds shared SPDM identity
discovery and selection among discovered certificate slots. The common
interface supports any certificate slot advertised by the driver, and the
same evidence-get and evidence-accept commands apply to both series.

For a guest device, sysfs lock collects the initial evidence and creates
the CTLV instance. Userspace can optionally refresh supported objects,
retrieve the cached evidence, verify it, and issue EVIDENCE_ACCEPT to enter
RUN. The CCA guest driver supports refreshing measurements with a 32-byte
challenge or an interface report without a challenge. It checks the new
bytes against trusted digests and device state before replacing the
selected cached object. Refresh is disabled after the device enters RUN.

EVIDENCE_GET reads the cached snapshot, so its challenge attribute becomes
optional. EVIDENCE_REFRESH requests new evidence and invalidates previous
evidence generations and acceptance. A failed backend refresh also
invalidates them and requires recovery.

EVIDENCE_ACCEPT replaces the separate DEVSEC_RUN operation. Clearing
acceptance leaves the hardware state unchanged: a guest device can remain
in RUN, and host IDE streams remain established. DEVSEC_STATE_GET therefore
continues to report acceptance and device state separately. Disconnect and
unlock perform teardown.

The common attestation changes let each instance expose the operations and
evidence objects its device supports. This allows host links and guest
devices to share the PCI attestation implementation while advertising
different capabilities. Additional locking and generation helpers let
PCI/TSM coordinate state changes, evidence invalidation and notifications
with CTLV operations.

The PCI child family adds STATE_GET and EVIDENCE_REFRESH to the inherited
attestation operations. An instance appears only after a successful connect
or lock and is removed on disconnect or unlock. DEVICE_GET includes the
PCI name so userspace can associate an instance with its device.

The first five patches prepare the common attestation interface. The next
three define and implement the PCI integration, including its locking
helpers. The final three convert AMD and CCA host link setup and add CCA
guest evidence refresh. The series builds on the existing CTLV attestation
and PCI/TSM device-assignment support.

Notes:
* I used Codex to help implement, review and organize the series.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: John Allen <john.allen@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: patches@lists.linux.dev

Aneesh Kumar K.V (Arm) (11):
  attestation: Restrict inherited operations per instance
  attestation: Filter evidence objects per instance
  attestation: Enter secure operation when evidence is accepted
  attestation: Bind object selection to accepted evidence snapshots
  attestation: Make the evidence-get challenge attribute optional
  PCI/TSM: Describe the PCI attestation control family
  attestation: Add attestation helpers for PCI/TSM integration
  PCI/TSM: Bind CTLV attestation to connected and locked contexts
  crypto/ccp: Defer SEV-TIO link setup until evidence acceptance
  virt: coco: arm-cca-host: Publish slot zero and establish streams
    after acceptance
  virt: coco: arm-cca-guest: Refresh selected evidence against trusted
    digests

 Documentation/ABI/testing/sysfs-bus-pci       |  108 +-
 Documentation/ABI/testing/sysfs-class-tsm     |    9 +-
 .../ctlv/abi/ctlv-attestation-pci.yaml        |   43 +
 Documentation/ctlv/abi/ctlv-attestation.yaml  |   59 +-
 Documentation/ctlv/abi/families.registry.yaml |    1 +
 Documentation/ctlv/families.yaml              |    1 +
 Documentation/ctlv/generated-files.yaml       |   11 +
 .../ctlv/specs/ctlv-attestation-pci.yaml      |   79 +
 .../ctlv/specs/ctlv-attestation.yaml          |   40 +-
 Documentation/driver-api/attestation.rst      |   56 +
 Documentation/driver-api/pci/tsm.rst          |  160 +-
 Documentation/netlink/specs/pci-tsm.yaml      |  151 --
 drivers/attestation/core/core.c               |  123 +-
 drivers/attestation/core/ctlv.c               |  156 +-
 drivers/attestation/core/internal.h           |    3 +
 .../generated/ctlv_attestation_gen.c          |   45 +-
 .../generated/ctlv_attestation_gen.h          |   76 +-
 drivers/attestation/providers/sim.c           |   40 +-
 drivers/attestation/tests/core_kunit.c        |   72 +-
 drivers/crypto/ccp/sev-dev-tio.c              |   17 +-
 drivers/crypto/ccp/sev-dev-tio.h              |    5 +
 drivers/crypto/ccp/sev-dev-tsm.c              |  188 +-
 drivers/pci/Kconfig                           |    3 +
 drivers/pci/tsm/Makefile                      |    6 +-
 drivers/pci/tsm/attestation.c                 |  525 +++++
 drivers/pci/tsm/core.c                        |  431 +++--
 drivers/pci/tsm/ctlv_attestation_pci_gen.c    |  111 ++
 drivers/pci/tsm/ctlv_attestation_pci_gen.h    |  100 +
 drivers/pci/tsm/evidence.c                    |  274 ---
 drivers/pci/tsm/internal.h                    |   26 +
 drivers/pci/tsm/netlink.c                     |   43 -
 drivers/pci/tsm/netlink.h                     |   23 -
 drivers/virt/coco/arm-cca-guest/main.c        |  168 +-
 drivers/virt/coco/arm-cca-guest/rsi-da.c      |   16 +-
 drivers/virt/coco/arm-cca-host/main.c         |  143 +-
 drivers/virt/coco/arm-cca-host/rmi-da.c       |    7 +-
 drivers/virt/coco/arm-cca-host/rmi-da.h       |    2 +
 include/linux/attestation.h                   |   93 +-
 include/linux/pci-tsm.h                       |   86 +-
 include/linux/pci.h                           |    2 +
 include/uapi/linux/ctlv_attestation_gen.h     |   25 +-
 include/uapi/linux/ctlv_attestation_pci_gen.h |   74 +
 include/uapi/linux/ctlv_families_gen.h        |    1 +
 include/uapi/linux/pci-tsm-netlink.h          |  101 -
 samples/devsec/common.c                       |    1 -
 samples/devsec/link_tsm.c                     |   17 +-
 samples/devsec/tsm.c                          |   32 +-
 tools/ctlv/tests/support.py                   |    3 +-
 tools/ctlv/tests/test_outputs.py              |    6 +-
 tools/ctlv/tests/test_semantics.py            |   38 +
 tools/ctlv/tests/test_spec.py                 |    1 +
 .../selftests/attestation/attestation_test.c  |   32 +-
 .../ctlv_attestation_pci_user_gen.c           | 1697 +++++++++++++++++
 .../ctlv_attestation_pci_user_gen.h           |  230 +++
 .../ctlv_attestation_sim_user_gen.c           |  161 +-
 .../ctlv_attestation_tdx_user_gen.c           |  161 +-
 .../attestation/ctlv_attestation_user_gen.c   |  161 +-
 .../attestation/ctlv_attestation_user_gen.h   |   70 +-
 .../attestation/tdx_attestation_test.c        |    9 +-
 59 files changed, 4678 insertions(+), 1644 deletions(-)
 create mode 100644 Documentation/ctlv/abi/ctlv-attestation-pci.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv-attestation-pci.yaml
 delete mode 100644 Documentation/netlink/specs/pci-tsm.yaml
 create mode 100644 drivers/pci/tsm/attestation.c
 create mode 100644 drivers/pci/tsm/ctlv_attestation_pci_gen.c
 create mode 100644 drivers/pci/tsm/ctlv_attestation_pci_gen.h
 delete mode 100644 drivers/pci/tsm/evidence.c
 create mode 100644 drivers/pci/tsm/internal.h
 delete mode 100644 drivers/pci/tsm/netlink.c
 delete mode 100644 drivers/pci/tsm/netlink.h
 create mode 100644 include/uapi/linux/ctlv_attestation_pci_gen.h
 delete mode 100644 include/uapi/linux/pci-tsm-netlink.h
 create mode 100644 tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.c
 create mode 100644 tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.h

-- 
2.43.0

