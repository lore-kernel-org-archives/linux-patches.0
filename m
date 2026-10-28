Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201257;
	b=LAYq9jpNj/zl73q0NBD5vpmDaN52LsWZedr6cf2U/xC7M8fv5Of/dHPj9iANMpQwvawK
	 sxF6dyRVG63O3Zf+hpEPZX+SvzyLtVxSQ2ew/5pJobB7rcQmtKs1UKVW98e6ktyIV97DP
	 h7yKO4cdpuojnAdA5LwsbH35yVEqrPkc2Bk0o8DNQLPJUz0KAvtyiShmL4Cic1Fnfy4QV
	 51/QVNH5DmVGDxP1JTjHAxwjBGqwMaGYzQg5ddM30vPIEVh/g2fZlBSAcOG2mWVKIbZJg
	 aYWrrUW4r+wfVEhJUX/JV8dqxlR62q//x6n4c2vdOzWJDFGuTAuFiex2mjgFLrZRzYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vse9G3ysHIb4+iqAAdjZISEypndJZaG/5E6wb/2u7XI=;
	b=p2dgTNAqz694FyEQee/4s0Sg4czH1C42csHbJzOuy6ao4yu7uoXsCq/TDf9frBlsjM9F
	 Xhr5UwDG+vypgVq1pofoI61/elzqi8gmWzv72A/yds6OF1K5uXi+W2xELsydKq8xipYbF
	 fdUwJMcfn8CerC3zygnTx5WdFhn1wu0SuOdlxg5MxjOzwF7dLsicEVm2XPdfhh3JLXV2j
	 iSMIx6fZ64dDU6HZyt3PNIXti6A8PTOYAxuv78E8Qx/2TS9qkhCOeszX7D/CwX+8ZVjwc
	 vexjeRzKAjE8zHzNdpJeEdG6ctl+QlLA/AVF+jo6isjbEml5ZZnQYbV81k1/PI1DEKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CR4seJW6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C77606A33E;
	Wed, 28 Oct 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CR4seJW6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658051F01829;
	Wed, 28 Oct 2026 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201256;
	bh=vse9G3ysHIb4+iqAAdjZISEypndJZaG/5E6wb/2u7XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CR4seJW6jhuSQbS8Bbpe/KFeW7y9GfpBIeBtL1y1wpt9oCc25bgokMY2gOICcA8eD
	 2ZO0BlRUE14N5nW+V81HiJfku+Xh7ZT4ljaCPjO1u9L2wgg7re4eZmpco2aa+zMEYo
	 GFjLtQD3Q/zjHCC0bBqonS4NsK3UnSg17j5euk0PYvXu43AOJ6vCrCuozU9srzXoov
	 DbyGPfMOXutV2VPMeFr8XhFgFFk2WIJIBiYcg4ZZhiVxrbQjffmSjC47zLBUvOvOpw
	 QsXefylf+6Xi85cA8trgXWXp6Y1hANqCrPNWE85ZvTO9Ha6gk5rk98dvKU+vMCh03M
	 KK4MgOTa0I2Uw==
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
Subject: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected and locked contexts
Date: Wed, 28 Oct 2026 20:56:15 +0530
Message-ID: <20261028152618.1356860-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
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
Content-Transfer-Encoding: 8bit

Create a PCI attestation instance only after sysfs connect or lock
succeeds. Export cached evidence through the common blob API and replace
the netlink evidence interface. Backends declare their evidence
capability bitmap; the common provider advertises and accepts only those
objects.

Route evidence acceptance to a link backend callback or guest ACCEPT.
Support an optional evidence.accept-object selector for any certificate
slot declared by the link backend, while the common core checks that the
object belongs to the retrieved evidence generation. Pass the selected
slot through pci_tsm.evidence.slot before invoking the backend.

Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: John Allen <john.allen@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-pci   | 108 ++---
 Documentation/ABI/testing/sysfs-class-tsm |   9 +-
 Documentation/driver-api/pci/tsm.rst      | 104 ++++-
 Documentation/netlink/specs/pci-tsm.yaml  | 151 -------
 drivers/crypto/ccp/sev-dev-tsm.c          |   1 +
 drivers/pci/Kconfig                       |   3 +
 drivers/pci/tsm/Makefile                  |   6 +-
 drivers/pci/tsm/attestation.c             | 525 ++++++++++++++++++++++
 drivers/pci/tsm/core.c                    | 430 ++++++++++--------
 drivers/pci/tsm/evidence.c                | 274 -----------
 drivers/pci/tsm/internal.h                |  26 ++
 drivers/pci/tsm/netlink.c                 |  43 --
 drivers/pci/tsm/netlink.h                 |  23 -
 drivers/virt/coco/arm-cca-guest/main.c    |  34 +-
 drivers/virt/coco/arm-cca-guest/rsi-da.c  |  16 +-
 include/linux/pci-tsm.h                   |  86 +++-
 include/linux/pci.h                       |   2 +
 include/uapi/linux/pci-tsm-netlink.h      | 101 -----
 samples/devsec/common.c                   |   1 -
 samples/devsec/link_tsm.c                 |   1 +
 samples/devsec/tsm.c                      |  32 +-
 21 files changed, 1075 insertions(+), 901 deletions(-)
 delete mode 100644 Documentation/netlink/specs/pci-tsm.yaml
 create mode 100644 drivers/pci/tsm/attestation.c
 delete mode 100644 drivers/pci/tsm/evidence.c
 create mode 100644 drivers/pci/tsm/internal.h
 delete mode 100644 drivers/pci/tsm/netlink.c
 delete mode 100644 drivers/pci/tsm/netlink.h
 delete mode 100644 include/uapi/linux/pci-tsm-netlink.h

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index adce5b6cba9f..56b1d92427ef 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -625,49 +625,56 @@ Description:
 What:		/sys/bus/pci/devices/.../tsm/
 Contact:	linux-coco@lists.linux.dev
 Description:
-		This directory only appears if a physical device function
-		supports authentication (PCIe CMA-SPDM), interface security
-		(PCIe TDISP), and is accepted for secure operation by the
-		platform TSM driver. This attribute directory appears
-		dynamically after the platform TSM driver loads. So, only after
-		the /sys/class/tsm/tsm0 device arrives can tools assume that
-		devices without a tsm/ attribute directory will never have one;
-		before that, the security capabilities of the device relative to
-		the platform TSM are unknown. See
-		Documentation/ABI/testing/sysfs-class-tsm.
+		Link TSM control and status. This directory appears when a link
+		TSM is registered for a capable PCIe function or its managed
+		subfunctions. The dsm attribute identifies the connected DSM.
+		Host PF0 exposes connect and disconnect controls. Evidence
+		retrieval and acceptance use CTLV attestation; see
+		Documentation/driver-api/pci/tsm.rst.
 
 What:		/sys/bus/pci/devices/.../tsm/connect
 Contact:	linux-coco@lists.linux.dev
 Description:
-		(RW) Write the name of a TSM (TEE Security Manager) device from
-		/sys/class/tsm to this file to establish a connection with the
-		device.  This typically includes an SPDM (DMTF Security
-		Protocols and Data Models) session over PCIe DOE (Data Object
-		Exchange) and may also include PCIe IDE (Integrity and Data
-		Encryption) establishment. Reads from this attribute return the
-		name of the connected TSM or the empty string if not
-		connected. A TSM device signals its readiness to accept PCI
-		connection via a KOBJ_CHANGE event. This is a "link" TSM
-		attribute, see Documentation/ABI/testing/sysfs-class-tsm.
+		(RW) On host PF0, write a link TSM name (tsmN) to associate the
+		device with that TSM and collect its supported identity evidence.
+		Reads return the associated TSM name, or an empty string.
+		Successful connect creates the CTLV attestation instance.
+		Backends may defer secure-session and stream setup until
+		userspace verifies the chain and issues CTLV evidence-accept.
 
 What:		/sys/bus/pci/devices/.../tsm/disconnect
 Contact:	linux-coco@lists.linux.dev
 Description:
-		(WO) Write the name of the TSM device that was specified
-		to 'connect' to teardown the connection.
-		The write fails with EBUSY while any vdevice depends on the
-		connection. Userspace must destroy those vdevices before
-		disconnecting the link. This is a
-		"link" TSM attribute, see
-		Documentation/ABI/testing/sysfs-class-tsm.
+		(WO) On host PF0, write the associated TSM name to release the
+		connection, including any established stream. Works before
+		evidence acceptance too. Successful disconnect removes the CTLV
+		attestation instance. Returns EBUSY while IOMMUFD vdevices
+		hold connection contexts.
+
+What:		/sys/bus/pci/devices/.../tsm/lock
+Contact:	linux-coco@lists.linux.dev
+Description:	(RW) Lock a TEE-capable device with a device-security TSM by
+		writing its name, for example "tsm0". Requires the device driver
+		to be detached. Reads return the associated TSM name or an empty
+		string. Successful locking collects evidence and creates the
+		device's CTLV attestation instance. CTLV evidence-accept enters
+		RUN after userspace has verified evidence from evidence-get.
+
+What:		/sys/bus/pci/devices/.../tsm/unlock
+Contact:	linux-coco@lists.linux.dev
+Description:	(WO) Unlock a device by writing its associated TSM name.
+		Requires the device driver to be detached. Successful unlock
+		revokes confidential-device acceptance and removes the CTLV
+		attestation instance. Failed unlock retains the error context
+		for retry through this file.
 
 What:		/sys/bus/pci/devices/.../tsm/dsm
 Contact:	linux-coco@lists.linux.dev
 Description:	(RO) Return PCI device name of this device's DSM (Device
 		Security Manager). When a device is in the connected state it
-		indicates that the platform TSM (TEE Security Manager) has made
-		a secure-session connection with a device's DSM. A DSM is always
-		physical function 0 and when the device supports TDISP (TEE
+		identifies the DSM associated with the platform TSM (TEE Security
+		Manager). This association can precede secure-session setup.
+		A DSM is always physical function 0 and when the device supports TDISP (TEE
 		Device Interface Security Protocol) its managed functions also
 		populate this tsm/dsm attribute. The managed functions of a DSM
 		are SR-IOV (Single Root I/O Virtualization) virtual functions,
@@ -692,45 +699,10 @@ Description:
 		available authentication methods for the device.
 
 		When present and the tsm/ attribute directory is present, the
-		authenticated attribute is an alias for the device 'connect'
-		state. See the 'tsm/connect' attribute for more details.
+		authenticated attribute reports the TSM name only after secure
+		session and stream setup succeed, otherwise an empty string.
+		Connection control uses tsm/connect and tsm/disconnect.
 		This is a "link" TSM attribute, see
 		Documentation/ABI/testing/sysfs-class-tsm.
 
-What:		/sys/bus/pci/devices/.../tsm/lock
-Contact:	linux-coco@lists.linux.dev
-Description:
-		(RW) Write the name of a TSM (TEE Security Manager) device
-		instance to this file to request that the platform transition
-		the PCIe device configuration to the TDISP LOCKED state. This
-		puts the device in a state where security sensitive
-		configuration setting can not be changed without transitioning
-		the device the PCIe TDISP ERROR state. Reads from this attribute
-		return the name of the TSM device instance that has arranged for
-		the device to be locked, or the empty string if not locked. A
-		TSM class device signals its readiness for lock requests via a
-		KOBJ_CHANGE event. Writes fail with EBUSY if this device is
-		bound to a driver. This is a "devsec" TSM attribute, see
-		Documentation/ABI/testing/sysfs-class-tsm. See
-		Documentation/driver-api/pci/tsm.rst for more details.
-
-What:		/sys/bus/pci/devices/.../tsm/unlock
-Contact:	linux-coco@lists.linux.dev
-Description:
-		(WO) Write the name of the TSM device that was specified to
-		'lock' to teardown the connection. Writes fail with EBUSY if
-		this device is bound to a driver. This is a "devsec" TSM
-		attribute, see Documentation/ABI/testing/sysfs-class-tsm.
 
-What:		/sys/bus/pci/devices/.../tsm/accept
-Contact:	linux-coco@lists.linux.dev
-Description:
-		(RW) Write "1" (or any boolean "true" string) to this file to
-		request that TSM transition the device from the TDISP LOCKED
-		state to the RUN state and arrange the for the secure IOMMU to
-		accept requests with T=1 in the PCIe packet header (TLP)
-		targeting private memory. Per TDISP the only exits from the RUN
-		state are via an explicit unlock request or an event that
-		transitions the device to the ERROR state. Writes fail with
-		EBUSY if this device is bound to a driver. This is a "devsec"
-		TSM attribute, see Documentation/ABI/testing/sysfs-class-tsm.
diff --git a/Documentation/ABI/testing/sysfs-class-tsm b/Documentation/ABI/testing/sysfs-class-tsm
index 76704501f082..854efd3f1b28 100644
--- a/Documentation/ABI/testing/sysfs-class-tsm
+++ b/Documentation/ABI/testing/sysfs-class-tsm
@@ -35,7 +35,8 @@ Description:
 			      transition assigned devices through the TDISP
 			      state machine UNLOCKED->LOCKED->RUN.
 
-		See the "tsm/" entries in
-		Documentation/ABI/testing/sysfs-bus-pci for the available PCI
-		device attributes when a TSM with the given "pci_mode" is
-		registered.
+		Host connection control uses the PCI device's tsm/connect and
+		tsm/disconnect sysfs files. Guest lifecycle operations use
+		ctlv-attestation-pci. The numeric suffix of tsmN is its
+		pci.tsm-id. See
+		Documentation/driver-api/pci/tsm.rst.
diff --git a/Documentation/driver-api/pci/tsm.rst b/Documentation/driver-api/pci/tsm.rst
index f20ec028935c..28c9ec5dd4e6 100644
--- a/Documentation/driver-api/pci/tsm.rst
+++ b/Documentation/driver-api/pci/tsm.rst
@@ -19,19 +19,29 @@ of an adversary. The adversarial threats are:
 - Virtual: Device MMIO presented to a guest may not actually map the
   device, device DMA may be redirected.
 
-In Linux a "tsm" is a broader concept. It is a class device interface to
-mitigate one or more of the above threats. A "tsm driver" registers a
-tsm device that publishes either the 'tsm/connect' or
-'tsm/{lock,accept}' set of attributes for the PCIe device. The typical
-expectation is that 'tsm/{lock,accept}' is published by a guest "tsm
-driver" to mitigate "Virtual" threats. The 'tsm/connect' interface is
-published by a host "tsm driver" to mitigate "Identity" and/or
-"Physical" threats.
+A TSM driver registers a class device under /sys/class/tsm. Its pci_mode
+identifies a host link manager or a guest device-security manager. PCI
+control uses the ``tsm/connect``, ``tsm/disconnect``, ``tsm/lock`` and
+``tsm/unlock`` sysfs files. Evidence uses a ``ctlv-attestation-pci`` instance,
+which inherits the common ``ctlv-attestation`` family. Only a successfully
+connected host DSM or locked guest device has a CTLV instance. Discovery and
+backend registration alone do not create instances.
+
+Operation availability
+======================
+
+CTLV provides DEVICE_GET, PCI STATE_GET, EVIDENCE_GET, EVIDENCE_ACCEPT,
+EVIDENCE_ACCEPT_CLEAR and DEVSEC_STATE_GET on established contexts. Backends
+declare the evidence objects and certificate slots they expose. The common
+state query omits TDISP state for a link context. PCI exposes no
+measurement-register operations.
+
+Guest EVIDENCE_REFRESH requires a locked context and a backend refresh
+callback. It is disabled after acceptance has entered RUN.
 
 Device Interface LOCK
 =====================
-The lock operation facilitated by tsm/lock (see
-Documentation/ABI/testing/sysfs-bus-pci) places the device in a mode
+Writing a guest TSM name to ``tsm/lock`` places the device in a mode
 where any security sensitive changes to the device configuration results
 in the device transitioning to the ERROR state. The device presents
 signed evidence of its LOCK state to the kernel through the tsm driver.
@@ -49,6 +59,80 @@ the TCB when locked, depending on the TSM architecture implementation,
 T=0 DMA from the device may be blocked until the device is next
 unlocked.
 
+Userspace sequence
+==================
+
+After sysfs connect or lock succeeds, discover the new instance through CTLV
+and use DEVICE_GET's ``pci.name`` to match the PCI BDF. DEVICE_GET exposes common
+evidence capabilities; PCI STATE_GET returns the current generation,
+connection/lock/acceptance state, selected TSM ID and, for a connected link, the
+DSM BDF. The TSM ID is the numeric suffix of /sys/class/tsm/tsmN. PCI
+EVIDENCE_REFRESH requires ``pci.generation`` from STATE_GET; a mismatch returns
+ESTALE before invoking the native backend.
+
+For a link backend that defers secure-link setup until evidence acceptance,
+write its TSM name to the DSM's ``tsm/connect`` sysfs file to collect identity
+evidence. DEVICE_GET advertises the backend's available objects and certificate
+slots; EVIDENCE_GET retrieves the cached chain. After verifying it, issue
+EVIDENCE_ACCEPT with the returned device and evidence generations to complete
+session and IDE setup. Writing the same TSM name to ``tsm/disconnect`` releases
+the context, including an identity context that has not been accepted.
+
+A guest verifier follows this sequence:
+
+1. Unbind the device driver and write the guest TSM name to ``tsm/lock``.
+   Successful locking collects and verifies the initial evidence, then publishes
+   the CTLV device.
+2. Optionally refresh evidence if the backend supports EVIDENCE_REFRESH.
+3. Use common EVIDENCE_GET to export objects from the current snapshot,
+   then verify identity, transcript, nonce, measurements and interface
+   report under the relying party's policy.
+4. Issue EVIDENCE_ACCEPT with the device and evidence generations returned by
+   EVIDENCE_GET. This invokes native ACCEPT and driver-core confidential-device
+   acceptance. The verdict is recorded only when both succeed. Acceptance keeps
+   the evidence generation binding and updates the verdict/state query version.
+   Repeated acceptance, including after EVIDENCE_ACCEPT_CLEAR, does not repeat
+   the native RUN transition. CLEAR only clears the userspace verdict.
+5. After unbinding the driver, write the TSM name to ``tsm/unlock`` to revoke
+   acceptance and tear down native mappings. Successful unlock removes the CTLV
+   instance. Another lock creates a new instance.
+
+Backends declare the evidence objects they provide in
+``pci_tsm_ops.evidence_types``, using bits from ``PCI_TSM_EVIDENCE_TYPE_*``.
+DEVICE_GET advertises only these objects and EVIDENCE_GET rejects other objects.
+The CCA guest and synthetic guest backend declare slot zero, VCA, measurements
+and interface reports. Host certificate slots are declared by the link backend.
+
+Host EVIDENCE_ACCEPT may select any advertised certificate slot through
+``evidence.accept-object``. The selected object must belong to the retrieved
+evidence generation. The provider passes the slot to the link backend through
+``pci_tsm.evidence.slot``; omitting the selector retains the existing slot.
+Once streams are connected, selecting a different slot returns EBUSY.
+
+Raw evidence and trusted digests are exported by the common blob API:
+
+================= ======================== ===================
+Native object     Common blob class        Format
+================= ======================== ===================
+cert0..cert7       cert-chain (instance N)  spdm-cert-chain
+VCA               spdm-vca                 spdm-vca
+measurements      spdm-measurements        spdm-measurements
+interface report  tdisp-report             tdisp-report
+================= ======================== ===================
+
+Use RAW for the wire bytes or TCB_DIGEST with the native digest algorithm
+(SHA-256, SHA-384 or SHA-512). Capabilities describe potential outputs;
+ENODATA means that the current TSM did not populate that object or
+representation, and EOPNOTSUPP means the selected digest algorithm does
+not match the native one. Provision output buffers using the advertised maximum
+length. The native cache remains private to PCI/TSM for MMIO report parsing.
+
+Refresh invalidates older evidence and verdicts. A backend refresh failure
+also invalidates them and requires recovery. Invalid object or challenge
+requests leave the context unchanged.
+
+Read-only ``tsm/dsm`` and ``authenticated`` sysfs status remain.
+
 Subsystem Interfaces
 ====================
 
diff --git a/Documentation/netlink/specs/pci-tsm.yaml b/Documentation/netlink/specs/pci-tsm.yaml
deleted file mode 100644
index eb7fc03bd705..000000000000
--- a/Documentation/netlink/specs/pci-tsm.yaml
+++ /dev/null
@@ -1,151 +0,0 @@
-# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
-#
----
-name: pci-tsm
-protocol: genetlink
-uapi-header: linux/pci-tsm-netlink.h
-doc: PCI TSM Evidence retrieval over generic netlink
-
-definitions:
-  -
-    type: const
-    name: max-object-size
-    value: 0x01000000
-  -
-    type: const
-    name: max-nonce-size
-    value: 256
-  -
-    type: const
-    name: max-obj-type
-    value: 4
-  -
-    name: evidence-type
-    type: enum
-    doc: PCI device security evidence objects
-    entries:
-      -
-        name: cert0
-        doc: SPDM certificate chain from device slot0
-      -
-        name: cert1
-        doc: SPDM certificate chain from device slot1
-      -
-        name: cert2
-        doc: SPDM certificate chain from device slot2
-      -
-        name: cert3
-        doc: SPDM certificate chain from device slot3
-      -
-        name: cert4
-        doc: SPDM certificate chain from device slot4
-      -
-        name: cert5
-        doc: SPDM certificate chain from device slot5
-      -
-        name: cert6
-        doc: SPDM certificate chain from device slot6
-      -
-        name: cert7
-        doc: SPDM certificate chain from device slot7
-      -
-        name: vca
-        doc: SPDM transcript of version, capabilities, and algorithms negotiation
-      -
-        name: measurements
-        doc: SPDM GET_MEASUREMENTS response
-      -
-        name: report
-        doc: TDISP GET_DEVICE_INTERFACE_REPORT response
-
-    render-max: true
-  -
-    name: evidence-type-flag
-    type: flags
-    doc: PCI device security evidence request flags
-    render-max: true
-    # NOTE! these values must match the name and order of evidence-type
-    entries:
-      -
-        name: cert0
-      -
-        name: cert1
-      -
-        name: cert2
-      -
-        name: cert3
-      -
-        name: cert4
-      -
-        name: cert5
-      -
-        name: cert6
-      -
-        name: cert7
-      -
-        name: vca
-      -
-        name: measurements
-      -
-        name: report
-  -
-    name: evidence-flag
-    type: flags
-    render-max: true
-    doc: Flags to control evidence retrieval
-    entries:
-      -
-        name: digest
-        doc: Request the TSM's private digest of an evidence object
-
-attribute-sets:
-  -
-    name: evidence-object
-    attributes:
-      -
-        name: type
-        type: u32
-        doc: evidence type-id
-      -
-        name: type-mask
-        type: u32
-        doc: evidence types as a flag mask
-      -
-        name: flags
-        type: u32
-        doc: evidence modifier flags like 'request TSM digest'
-      -
-        name: dev-name
-        type: string
-        doc: PCI device name
-      -
-        name: nonce
-        type: binary
-        checks:
-          max-len: max-nonce-size
-      -
-        name: val
-        type: binary
-        checks:
-          max-len: max-obj-size
-
-operations:
-  list:
-    -
-      name: evidence-read
-      doc: Read the PCI TSM objects of a given type mask
-      attribute-set: evidence-object
-      flags: [admin-perm]
-      dump:
-        pre: pci-tsm-nl-evidence-read-pre
-        post: pci-tsm-nl-evidence-read-post
-        request:
-          attributes:
-            - type-mask
-            - flags
-            - dev-name
-            - nonce
-        reply:
-          attributes:
-            - type
-            - val
diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 6d089714900c..e905ed9de9b5 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -307,6 +307,7 @@ static int dsm_connect(struct pci_dev *pdev)
 
 	tc_mask = streams_setup(dev_data->ide, ids);
 
+	dev_data->cert_slot = pdev->tsm->evidence.slot;
 	ret = sev_tio_dev_connect(dev_data, tc_mask, ids, dev_data->cert_slot);
 	ret = sev_tio_spdm_cmd(dsm, ret);
 	if (ret)
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index f7b7a6e269a2..b605eb2d4d5e 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -131,6 +131,9 @@ config PCI_TSM
 	select PCI_IDE
 	select PCI_DOE
 	select TSM
+	select CTLV
+	select ATTESTATION
+	select CRYPTO_HASH_INFO
 	help
 	  The TEE (Trusted Execution Environment) Device Interface
 	  Security Protocol (TDISP) defines a "TSM" as a platform agent
diff --git a/drivers/pci/tsm/Makefile b/drivers/pci/tsm/Makefile
index afa775224b8d..62181b8ca635 100644
--- a/drivers/pci/tsm/Makefile
+++ b/drivers/pci/tsm/Makefile
@@ -4,6 +4,6 @@
 
 obj-$(CONFIG_PCI_TSM) += tsm.o
 
-tsm-y := core.o
-tsm-$(CONFIG_NET) += netlink.o
-tsm-$(CONFIG_NET) += evidence.o
+ccflags-y += -I$(srctree)/drivers/attestation/generated
+
+tsm-y := core.o attestation.o ctlv_attestation_pci_gen.o
diff --git a/drivers/pci/tsm/attestation.c b/drivers/pci/tsm/attestation.c
new file mode 100644
index 000000000000..993c26664498
--- /dev/null
+++ b/drivers/pci/tsm/attestation.c
@@ -0,0 +1,525 @@
+// SPDX-License-Identifier: GPL-2.0
+/* PCI lifecycle and cached SPDM/TDISP evidence through CTLV attestation. */
+#include <crypto/hash_info.h>
+#include <linux/attestation.h>
+#include <linux/ctlv.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pci-tsm.h>
+#include <linux/tsm.h>
+
+#include "../pci.h"
+#include "ctlv_attestation_pci_gen.h"
+#include "internal.h"
+
+struct pci_tsm_attestation {
+	struct pci_dev *pdev;
+	struct ctlv_device *ctlvdev;
+	struct list_head retired;
+	bool attached;
+	/* Protected by pci_tsm_rwsem. */
+	bool active;
+	bool removing;
+};
+
+static void pci_attestation_update_locked(struct pci_tsm_attestation *pa,
+		bool att_locked)
+{
+	struct pci_dev *pdev = pa->pdev;
+	struct pci_tsm *tsm = pdev->tsm;
+	const struct pci_tsm_ops *ops = tsm ? tsm->tsm_dev->pci_ops : NULL;
+	bool link = tsm && tsm->dsm_dev;
+	bool devsec = tsm && !link;
+	bool accepted = device_cc_accepted(&pdev->dev);
+	bool present = !pa->removing && !pci_dev_is_disconnected(pdev);
+	unsigned int features = 0;
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+
+	if (devsec) {
+		ctlv_device_op_state_set(pa->ctlvdev, CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH,
+					 !present || !tsm || tsm->error ||
+					 accepted || !ops->refresh_evidence);
+	}
+
+	if (present) {
+		if (tsm && !tsm->error) {
+			features |= ATTESTATION_FEATURE_EVIDENCE;
+			if ((devsec && ops->accept) || (link && is_pci_tsm_pf0(pdev)))
+				features |= ATTESTATION_FEATURE_EVIDENCE_ACCEPT;
+		}
+
+		if (devsec)
+			features |= ATTESTATION_FEATURE_TDISP_STATE;
+	}
+
+	if (att_locked)
+		attestation_features_set_locked(ctlv_priv_parent(pa), features);
+	else
+		attestation_features_set(ctlv_priv_parent(pa), features);
+}
+
+void pci_tsm_attestation_update(struct pci_dev *pdev)
+{
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	if (pdev->tsm_attestation && !pdev->tsm_attestation->removing)
+		pci_attestation_update_locked(pdev->tsm_attestation, false);
+}
+
+void pci_tsm_attestation_notify_state_change(struct pci_dev *pdev)
+{
+	struct pci_tsm_attestation *pa = pdev->tsm_attestation;
+	struct attestation *att;
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	if (!pa || pa->removing)
+		return;
+
+	att = ctlv_priv_parent(pa);
+	/* The active CTLV operation already holds this instance's mutex. */
+	if (pa->active) {
+		attestation_state_changed_locked(att);
+		pci_attestation_update_locked(pa, true);
+		return;
+	}
+
+	/* Native notifications outside dispatch must acquire the mutex. */
+	attestation_lock(att);
+	attestation_state_changed_locked(att);
+	pci_attestation_update_locked(pa, true);
+	attestation_unlock(att);
+}
+
+void pci_tsm_attestation_remove(struct pci_dev *pdev, struct list_head *retired)
+{
+	struct pci_tsm_attestation *pa = pdev->tsm_attestation;
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	if (!pa || pa->removing)
+		return;
+
+	/* Revoke old descriptors before another session can be installed. */
+	pa->removing = true;
+	pdev->tsm_attestation_removing = true;
+	list_add_tail(&pa->retired, retired);
+}
+
+void pci_tsm_attestation_destroy(struct list_head *retired)
+{
+	struct pci_tsm_attestation *pa, *next;
+
+	/* ctlv_destroy() drains callbacks that may be waiting for pci_tsm_rwsem. */
+	list_for_each_entry_safe(pa, next, retired, retired) {
+		struct pci_dev *pdev = pci_dev_get(pa->pdev);
+
+		list_del(&pa->retired);
+		ctlv_destroy(pa->ctlvdev);
+
+		/* The common registry has now retired this parent as well. */
+		scoped_guard(rwsem_write, &pci_tsm_rwsem)
+			pdev->tsm_attestation_removing = false;
+
+		pci_dev_put(pdev);
+	}
+}
+
+int ctlv_attestation_pci_op_pre(void *priv, struct ctlv_op_ctx *ctx)
+{
+	struct pci_tsm_attestation *pa = priv;
+	int ret;
+
+	/* All native paths, including notifications, use PCI -> attestation. */
+	ret = down_write_killable(&pci_tsm_rwsem);
+	if (ret)
+		return ret;
+
+	if (pa->removing || !pa->pdev->tsm || pci_dev_is_disconnected(pa->pdev)) {
+		up_write(&pci_tsm_rwsem);
+		return -ENODEV;
+	}
+
+	ret = ctlv_attestation_op_pre(ctlv_priv_parent(pa), ctx);
+	if (ret) {
+		up_write(&pci_tsm_rwsem);
+		return ret;
+	}
+
+	pa->active = true;
+	pci_attestation_update_locked(pa, true);
+	return 0;
+}
+
+void ctlv_attestation_pci_op_post(void *priv, struct ctlv_op_ctx *ctx)
+{
+	struct pci_tsm_attestation *pa = priv;
+
+	pci_attestation_update_locked(pa, true);
+	pa->active = false;
+	ctlv_attestation_op_post(ctlv_priv_parent(pa), ctx);
+	up_write(&pci_tsm_rwsem);
+}
+
+static int pci_attestation_prepare(struct pci_tsm_attestation *pa, u64 generation)
+{
+	struct attestation *att = ctlv_priv_parent(pa);
+
+	if (generation != attestation_get_device_generation(att))
+		return -ESTALE;
+
+	return attestation_state_change_prepare(att);
+}
+
+static int pci_attestation_reply(struct pci_tsm_attestation *pa,
+		struct ctlv_cursor *reply)
+{
+	struct attestation *att = ctlv_priv_parent(pa);
+
+	if (!ctlv_attestation_pci_pci_generation_put(reply,
+				attestation_get_device_generation(att)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+int ctlv_attestation_pci_evidence_refresh_action(void *priv, struct ctlv_op_ctx *ctx,
+		const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct pci_tsm_attestation *pa = priv;
+	struct pci_tsm *tsm = pa->pdev->tsm;
+	const struct pci_tsm_ops *ops;
+	const void *challenge;
+	enum pci_tsm_evidence_type type;
+	u64 object;
+	u32 length = 0;
+	int ret;
+
+	object = ctlv_attestation_pci_evidence_refresh_object_get(request);
+	switch (object) {
+	case CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_SPDM_MEASUREMENTS:
+		type = PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS;
+		break;
+	case CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_TDISP_REPORT:
+		type = PCI_TSM_EVIDENCE_TYPE_REPORT;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	challenge = ctlv_attestation_pci_evidence_refresh_challenge_get(request, &length);
+	if ((type == PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS && length != 32) ||
+	    (type == PCI_TSM_EVIDENCE_TYPE_REPORT && length))
+		return -EINVAL;
+
+	ret = pci_attestation_prepare(pa,
+			ctlv_attestation_pci_evidence_refresh_generation_get(request));
+	if (ret)
+		return ret;
+
+	if (!tsm)
+		return -ENOTCONN;
+
+	if (tsm->error || device_cc_accepted(&pa->pdev->dev))
+		return -EBUSY;
+
+	ops = tsm->tsm_dev->pci_ops;
+	if (!ops->refresh_evidence)
+		return -EOPNOTSUPP;
+
+	ret = ops->refresh_evidence(tsm, type, 0, (void *)challenge, length);
+	/* Even a failed refresh may have changed device state. Retire all verdicts. */
+	if (ret)
+		tsm->error = true;
+
+	pci_tsm_attestation_notify_state_change(pa->pdev);
+	return ret ?: pci_attestation_reply(pa, reply);
+}
+
+int ctlv_attestation_pci_state_get_action(void *priv, struct ctlv_op_ctx *ctx,
+		const struct ctlv_cursor *request, struct ctlv_cursor *reply)
+{
+	struct pci_tsm_attestation *pa = priv;
+	struct pci_dev *pdev = pa->pdev;
+	struct pci_tsm *tsm = pdev->tsm;
+	bool accepted = device_cc_accepted(&pdev->dev);
+	bool ok = !pci_attestation_reply(pa, reply);
+
+	if (tsm && tsm->dsm_dev == pdev) {
+		struct pci_tsm_pf0 *pf0 = container_of(tsm, struct pci_tsm_pf0, base_tsm);
+
+		accepted = pf0->stream_connected;
+	}
+
+	ok &= ctlv_attestation_pci_pci_connected_put(reply, tsm && tsm->dsm_dev);
+	ok &= ctlv_attestation_pci_pci_locked_put(reply, tsm && !tsm->dsm_dev);
+	ok &= ctlv_attestation_pci_pci_accepted_put(reply, accepted);
+
+	if (tsm) {
+		ok &= ctlv_attestation_pci_pci_tsm_id_put(reply, tsm->tsm_dev->id);
+		if (tsm->dsm_dev)
+			ok &= ctlv_attestation_pci_pci_dsm_put(reply, pci_name(tsm->dsm_dev));
+	}
+
+	return ok ? 0 : -EMSGSIZE;
+}
+
+static const enum attestation_evidence_representation pci_representations[] = {
+	ATTESTATION_EVIDENCE_REPRESENTATION_RAW,
+	ATTESTATION_EVIDENCE_REPRESENTATION_TCB_DIGEST,
+};
+
+static const enum hash_algo pci_algorithms[] = {
+	HASH_ALGO_SHA256, HASH_ALGO_SHA384, HASH_ALGO_SHA512,
+};
+
+/* These describe potential outputs; availability depends on the native TSM. */
+#define PCI_OBJECT(_class, _instance, _slot, _format) { \
+	.blob_class = ATTESTATION_EVIDENCE_BLOB_##_class, \
+	.has_blob_instance = _instance, .blob_instance = _slot, \
+	.format = _format, .representations = pci_representations, \
+	.representations_count = ARRAY_SIZE(pci_representations), \
+	.hash_algorithms = pci_algorithms, \
+	.hash_algorithms_count = ARRAY_SIZE(pci_algorithms), \
+	.max_length = PCI_TSM_MAX_OBJECT_SIZE, \
+}
+
+static const struct attestation_evidence_supported_object pci_objects[] = {
+	PCI_OBJECT(CERT_CHAIN, true, 0, "spdm-cert-chain"),
+	PCI_OBJECT(CERT_CHAIN, true, 1, "spdm-cert-chain"),
+	PCI_OBJECT(CERT_CHAIN, true, 2, "spdm-cert-chain"),
+	PCI_OBJECT(CERT_CHAIN, true, 3, "spdm-cert-chain"),
+	PCI_OBJECT(CERT_CHAIN, true, 4, "spdm-cert-chain"),
+	PCI_OBJECT(CERT_CHAIN, true, 5, "spdm-cert-chain"),
+	PCI_OBJECT(CERT_CHAIN, true, 6, "spdm-cert-chain"),
+	PCI_OBJECT(CERT_CHAIN, true, 7, "spdm-cert-chain"),
+	PCI_OBJECT(SPDM_VCA, false, 0, "spdm-vca"),
+	PCI_OBJECT(SPDM_MEASUREMENTS, false, 0, "spdm-measurements"),
+	PCI_OBJECT(TDISP_REPORT, false, 0, "tdisp-report"),
+};
+
+static_assert(ARRAY_SIZE(pci_objects) == PCI_TSM_EVIDENCE_TYPE_MAX + 1);
+
+static const struct attestation_evidence_caps pci_evidence_caps = {
+	.supports_object_accept = true,
+	.objects = pci_objects,
+	.objects_count = ARRAY_SIZE(pci_objects),
+	.max_total_output_length = PCI_TSM_MAX_OBJECT_SIZE * ARRAY_SIZE(pci_objects) * 2,
+};
+
+static bool pci_evidence_object_supported(struct attestation *att,
+		const struct attestation_evidence_supported_object *object)
+{
+	struct pci_tsm_attestation *pa = ctlv_priv_child(att);
+	struct pci_tsm *tsm = pa->pdev->tsm;
+
+	if (!tsm)
+		return false;
+
+	return tsm->tsm_dev->pci_ops->evidence_types & BIT(object - pci_objects);
+}
+
+static int pci_evidence_get(struct attestation *att,
+		const struct attestation_evidence_request *request,
+		struct attestation_evidence_result *result)
+{
+	struct pci_tsm_attestation *pa = ctlv_priv_child(att);
+	struct pci_tsm *tsm = pa->pdev->tsm;
+	struct pci_tsm_evidence *evidence;
+	size_t i;
+	int ret;
+
+	if (!tsm)
+		return -ENOTCONN;
+
+	if (tsm->error)
+		return -EIO;
+
+	evidence = &tsm->evidence;
+	guard(rwsem_read)(&evidence->lock);
+	/* Validate the entire set before writing any of its outputs. */
+	for (i = 0; i < request->objects_count; i++) {
+		const struct attestation_evidence_object_request *req = &request->objects[i];
+		unsigned int type = req->supported_object - pci_objects;
+		struct pci_tsm_evidence_object *obj = &evidence->obj[type];
+
+		if (req->representation == ATTESTATION_EVIDENCE_REPRESENTATION_RAW) {
+			if (!obj->data || !obj->len)
+				return -ENODATA;
+
+			result->object_lengths[i] = obj->len;
+		} else {
+			if (!obj->digest)
+				return -ENODATA;
+
+			if (req->hash_algorithm != evidence->digest_algo)
+				return -EOPNOTSUPP;
+
+			result->object_lengths[i] = hash_digest_size[evidence->digest_algo];
+		}
+
+		if (result->object_lengths[i] > req->supported_object->max_length ||
+		    result->object_lengths[i] > ctlv_blob_len(req->output))
+			return -EMSGSIZE;
+	}
+
+	for (i = 0; i < request->objects_count; i++) {
+		const struct attestation_evidence_object_request *req = &request->objects[i];
+		unsigned int type = req->supported_object - pci_objects;
+		struct pci_tsm_evidence_object *obj = &evidence->obj[type];
+		const void *data = obj->digest;
+
+		if (req->representation == ATTESTATION_EVIDENCE_REPRESENTATION_RAW)
+			data = obj->data;
+
+		ret = ctlv_blob_write(req->output, 0, data, result->object_lengths[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int pci_evidence_accept(struct attestation *att,
+		const struct attestation_evidence_supported_object *object)
+{
+	struct pci_tsm_attestation *pa = ctlv_priv_child(att);
+	struct pci_tsm *tsm = pa->pdev->tsm;
+
+	if (!tsm)
+		return -ENOTCONN;
+
+	if (tsm->error)
+		return -EIO;
+
+	if (tsm->dsm_dev) {
+		if (!is_pci_tsm_pf0(pa->pdev))
+			return -EOPNOTSUPP;
+
+		if (!object)
+			return pci_tsm_evidence_accept(pa->pdev, tsm->evidence.slot);
+
+		if (object->blob_class != ATTESTATION_EVIDENCE_BLOB_CERT_CHAIN ||
+		    !object->has_blob_instance || object->blob_instance >= 8)
+			return -EINVAL;
+
+		return pci_tsm_evidence_accept(pa->pdev, object->blob_instance);
+	}
+
+	/* Clearing and restoring a verdict must not issue a second RUN. */
+	if (device_cc_accepted(&pa->pdev->dev))
+		return 0;
+
+	return pci_tsm_accept(pa->pdev);
+}
+
+static void pci_evidence_accept_clear(struct attestation *att)
+{
+	/* The common core owns the verdict and its generation binding. */
+}
+
+static int pci_tdisp_state_get(struct attestation *att,
+		enum attestation_tdisp_state *state)
+{
+	struct pci_tsm_attestation *pa = ctlv_priv_child(att);
+	struct pci_tsm *tsm = pa->pdev->tsm;
+
+	if (tsm && tsm->dsm_dev)
+		return -EOPNOTSUPP;
+
+	if (!tsm)
+		*state = ATTESTATION_TDISP_STATE_UNLOCKED;
+	else if (tsm->error)
+		*state = ATTESTATION_TDISP_STATE_ERROR;
+	else if (device_cc_accepted(&pa->pdev->dev))
+		*state = ATTESTATION_TDISP_STATE_RUN;
+	else
+		*state = ATTESTATION_TDISP_STATE_LOCKED;
+
+	return 0;
+}
+
+static const struct attestation_provider pci_attestation_provider = {
+	.evidence_caps = &pci_evidence_caps,
+	.evidence_object_supported = pci_evidence_object_supported,
+	.evidence_get = pci_evidence_get,
+	.evidence_accept = pci_evidence_accept,
+	.evidence_accept_clear = pci_evidence_accept_clear,
+	.tdisp_state_get = pci_tdisp_state_get,
+};
+
+size_t ctlv_attestation_pci_priv_size(void)
+{
+	return sizeof(struct pci_tsm_attestation);
+}
+
+const void *ctlv_attestation_pci_pre_init(const void *init_info)
+{
+	return &pci_attestation_provider;
+}
+
+struct pci_attestation_init {
+	struct pci_dev *pdev;
+	struct pci_tsm_attestation **result;
+};
+
+int ctlv_attestation_pci_init(struct ctlv_device *ctlvdev,
+		const void *init_info, void *priv)
+{
+	struct pci_tsm_attestation *pa = priv;
+	const struct pci_attestation_init *info = init_info;
+	struct pci_dev *pdev = info->pdev;
+
+	pa->pdev = pci_dev_get(pdev);
+	pa->ctlvdev = ctlvdev;
+
+	if (!pdev->tsm->dsm_dev)
+		ctlv_attestation_pci_evidence_refresh_provide(ctlvdev);
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	*info->result = pa;
+	pci_attestation_update_locked(pa, false);
+	return 0;
+}
+
+void ctlv_attestation_pci_fini(struct ctlv_device *ctlvdev, void *priv)
+{
+	struct pci_tsm_attestation *pa = priv;
+
+	if (pa->attached) {
+		guard(rwsem_write)(&pci_tsm_rwsem);
+		pa->pdev->tsm_attestation = NULL;
+	}
+	pci_dev_put(pa->pdev);
+}
+
+int ctlv_attestation_pci_device_info_fill(void *priv, struct ctlv_op_ctx *ctx,
+		const struct ctlv_cursor *request, struct ctlv_cursor *nest)
+{
+	struct pci_tsm_attestation *pa = priv;
+
+	return ctlv_attestation_pci_pci_name_put(nest, pci_name(pa->pdev)) ? 0 : -EMSGSIZE;
+}
+
+void ctlv_attestation_pci_device_info_read(void *priv, struct ctlv_op_ctx *ctx,
+		const struct ctlv_cursor *nest)
+{
+}
+
+int pci_tsm_attestation_add(struct pci_dev *pdev)
+{
+	struct pci_tsm_attestation *pa;
+	struct pci_attestation_init info = { .pdev = pdev, .result = &pa };
+	struct ctlv_device *ctlvdev;
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	ctlvdev = ctlv_create(&pdev->dev, &ctlv_attestation_pci_family, &info);
+	if (IS_ERR(ctlvdev))
+		return PTR_ERR(ctlvdev);
+
+	pa->attached = true;
+	pdev->tsm_attestation = pa;
+	return 0;
+}
+
+MODULE_IMPORT_NS("ATTESTATION");
+MODULE_IMPORT_NS("CTLV");
diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index c74b86dbf86b..170e043b1d3b 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -24,6 +24,9 @@
 #include <linux/unaligned.h>
 #include <linux/xarray.h>
 #include "../pci.h"
+#include "internal.h"
+
+DEFINE_FREE(pci_tsm_attestation_destroy, struct list_head *, pci_tsm_attestation_destroy(_T))
 
 /*
  * Provide a read/write lock against the init / exit of pdev tsm
@@ -225,8 +228,10 @@ static int probe_fn(struct pci_dev *pdev, void *dsm)
 	pdev->tsm = ops->probe(dsm_dev->tsm->tsm_dev, pdev);
 	pci_dbg(pdev, "setup TSM context: DSM: %s status: %s\n",
 		pci_name(dsm_dev), pdev->tsm ? "success" : "failed");
-	if (pdev->tsm)
+	if (pdev->tsm) {
+		pci_tsm_attestation_notify_state_change(pdev);
 		link_sysfs_enable(pdev);
+	}
 	return 0;
 }
 
@@ -251,10 +256,12 @@ static int pci_tsm_connect(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	if ((rc = ACQUIRE_ERR(mutex_intr, &lock)))
 		return rc;
 
+	pci_tsm->evidence.slot = 0;
 	rc = ops->connect(pdev);
 	if (rc)
 		return rc;
 
+	tsm_pf0->stream_connected = !ops->evidence_accept;
 	pdev->tsm = no_free_ptr(pci_tsm);
 
 	/*
@@ -285,7 +292,7 @@ static ssize_t connect_show(struct device *dev, struct device_attribute *attr,
 	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &lock)))
 		return rc;
 
-	if (!pdev->tsm)
+	if (!pdev->tsm || !pdev->tsm->dsm_dev)
 		return sysfs_emit(buf, "\n");
 
 	tsm_dev = pdev->tsm->tsm_dev;
@@ -304,35 +311,77 @@ static bool is_devsec_tsm(struct tsm_dev *tsm_dev)
 	return tsm_dev && tsm_dev->pci_ops && tsm_dev->pci_ops->devsec_ops.lock;
 }
 
+static bool pci_tsm_can_connect(struct tsm_dev *tsm_dev)
+{
+	const struct pci_tsm_ops *ops = tsm_dev ? tsm_dev->pci_ops : NULL;
+
+	return is_link_tsm(tsm_dev) && ops->remove && ops->connect && ops->disconnect;
+}
+
 static ssize_t connect_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t len)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	int rc, id;
 
-	rc = sscanf(buf, "tsm%d\n", &id);
-	if (rc != 1)
+	if (sscanf(buf, "tsm%d", &id) != 1 || id < 0)
 		return -EINVAL;
 
 	ACQUIRE(rwsem_write_kill, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &lock)))
+	rc = ACQUIRE_ERR(rwsem_write_kill, &lock);
+	if (rc)
 		return rc;
-
-	if (pdev->tsm)
+	if (pci_dev_is_disconnected(pdev))
+		return -ENODEV;
+	if (pdev->tsm || pdev->tsm_attestation_removing)
 		return -EBUSY;
 
 	struct tsm_dev *tsm_dev __free(put_tsm_dev) = find_tsm_dev(id);
-	if (!is_link_tsm(tsm_dev))
+	if (!pci_tsm_can_connect(tsm_dev))
 		return -ENXIO;
-
+	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
+		return -EINVAL;
 	rc = pci_tsm_connect(pdev, tsm_dev);
 	if (rc)
 		return rc;
-
-	return len;
+	rc = pci_tsm_attestation_add(pdev);
+	if (rc)
+		pci_tsm_disconnect(pdev);
+	return rc ? rc : len;
 }
 static DEVICE_ATTR_RW(connect);
 
+int pci_tsm_evidence_accept(struct pci_dev *pdev, unsigned int slot)
+{
+	struct pci_tsm_pf0 *pf0 = to_pci_tsm_pf0(pdev->tsm);
+	const struct pci_tsm_ops *ops = to_pci_tsm_ops(pdev->tsm);
+	int ret;
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	if (pf0->removing)
+		return -ENODEV;
+
+	if (pf0->stream_connected)
+		return pdev->tsm->evidence.slot == slot ? 0 : -EBUSY;
+
+	if (slot >= 8)
+		return -EINVAL;
+
+	pdev->tsm->evidence.slot = slot;
+	ret = ops->evidence_accept(pdev);
+	if (!ret)
+		pf0->stream_connected = true;
+	else if (pdev->tsm->error)
+		pci_tsm_attestation_notify_state_change(pdev);
+
+	return ret;
+}
+
+bool pci_tsm_can_lock(struct tsm_dev *tsm_dev)
+{
+	return is_devsec_tsm(tsm_dev) && tsm_dev->pci_ops->unlock;
+}
+
 static int remove_fn(struct pci_dev *pdev, void *data)
 {
 	tsm_remove(pdev->tsm);
@@ -384,8 +433,15 @@ struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
 		kfree(context);
 		return ERR_PTR(-ENODEV);
 	}
+
+	if (pf0->base_tsm.error || !pf0->stream_connected) {
+		kfree(context);
+		return ERR_PTR(-ENOTCONN);
+	}
+
 	if (!pf0->context_users)
 		reinit_completion(&pf0->contexts_drained);
+
 	pf0->context_users++;
 	context->pf0 = pf0;
 	context->pdev = pci_dev_get(pdev);
@@ -459,7 +515,7 @@ static int __pci_tsm_disconnect(struct pci_dev *pdev)
 	return 0;
 }
 
-static int pci_tsm_disconnect(struct pci_dev *pdev)
+int pci_tsm_disconnect(struct pci_dev *pdev)
 {
 	int ret = __pci_tsm_disconnect(pdev);
 
@@ -474,27 +530,29 @@ static ssize_t disconnect_store(struct device *dev,
 				size_t len)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct tsm_dev *tsm_dev;
+	LIST_HEAD(retired);
+	struct list_head *cleanup __free(pci_tsm_attestation_destroy) = &retired;
 	int rc;
 
 	ACQUIRE(rwsem_write_kill, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &lock)))
+	rc = ACQUIRE_ERR(rwsem_write_kill, &lock);
+	if (rc)
 		return rc;
 
-	if (!pdev->tsm)
+	if (!pdev->tsm || !pdev->tsm->dsm_dev)
 		return -ENXIO;
 
-	tsm_dev = pdev->tsm->tsm_dev;
-	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
+	if (!sysfs_streq(buf, dev_name(&pdev->tsm->tsm_dev->dev)))
 		return -EINVAL;
-	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev) &&
-	    to_pci_tsm_pf0(pdev->tsm)->removing)
+
+	if (to_pci_tsm_pf0(pdev->tsm)->removing)
 		return -ENODEV;
 
 	rc = pci_tsm_disconnect(pdev);
-	if (rc)
-		return rc;
-	return len;
+	if (!rc)
+		pci_tsm_attestation_remove(pdev, &retired);
+
+	return rc ? rc : len;
 }
 static DEVICE_ATTR_WO(disconnect);
 
@@ -510,7 +568,7 @@ static ssize_t dsm_show(struct device *dev, struct device_attribute *attr,
 		return rc;
 
 	tsm = pdev->tsm;
-	if (!tsm)
+	if (!tsm || !tsm->dsm_dev)
 		return sysfs_emit(buf, "\n");
 
 	return sysfs_emit(buf, "%s\n", pci_name(tsm->dsm_dev));
@@ -752,85 +810,67 @@ EXPORT_SYMBOL_GPL(pci_tsm_mmio_free);
  * that transition from a known DMA-idle (no active mappings) state. The "driver
  * detached" state is a coarse way to assert that requirement.
  */
-static int pci_tsm_accept(struct pci_dev *pdev)
+int pci_tsm_accept(struct pci_dev *pdev)
 {
 	int rc;
 
-	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &lock)))
-		return rc;
+	lockdep_assert_held_write(&pci_tsm_rwsem);
 
-	if (!pdev->tsm)
+	if (!is_devsec(pdev) || !to_pci_tsm_ops(pdev->tsm)->accept)
 		return -EINVAL;
 
 	ACQUIRE(device_intr, dev_lock)(&pdev->dev);
 	if ((rc = ACQUIRE_ERR(device_intr, &dev_lock)))
 		return rc;
 
-	if (pdev->dev.driver)
+	if (pdev->dev.driver || pdev->tsm->error ||
+	    device_cc_accepted(&pdev->dev))
 		return -EBUSY;
 
 	rc = to_pci_tsm_ops(pdev->tsm)->accept(pdev);
-	if (rc)
-		return rc;
-
-	return device_cc_accept(&pdev->dev);
-}
-
-static ssize_t accept_store(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t len)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	bool accept;
-	int rc;
-
-	rc = kstrtobool(buf, &accept);
-	if (rc)
-		return rc;
-
-	/*
-	 * TDISP can only go from RUN to UNLOCKED/ERROR, so there is no
-	 * 'unaccept' verb.
-	 */
-	if (!accept)
-		return -EINVAL;
-
-	rc = pci_tsm_accept(pdev);
-	if (rc)
-		return rc;
-
-	return len;
+	if (!rc)
+		rc = device_cc_accept(&pdev->dev);
+	if (rc) {
+		pdev->tsm->error = true;
+		pci_tsm_attestation_notify_state_change(pdev);
+	}
+	return rc;
 }
 
-static ssize_t accept_show(struct device *dev, struct device_attribute *attr,
-			   char *buf)
+/* The backend retains its context when hardware teardown fails. */
+int pci_tsm_unlock(struct pci_dev *pdev)
 {
-	return sysfs_emit(buf, "%d\n", device_cc_accepted(dev));
-}
-static DEVICE_ATTR_RW(accept);
+	const struct pci_tsm_ops *ops;
+	struct tsm_dev *tsm_dev;
+	int ret;
 
-/**
- * pci_tsm_unlock() - Transition TDI from LOCKED/RUN to UNLOCKED
- * @pdev: TDI device to unlock
- *
- * Returns void, requires all callers to have satisfied dependencies like making
- * sure the device is locked and detached from its driver.
- */
-static void pci_tsm_unlock(struct pci_dev *pdev)
-{
 	lockdep_assert_held_write(&pci_tsm_rwsem);
 	device_lock_assert(&pdev->dev);
+	if (!is_devsec(pdev))
+		return -EINVAL;
 
-	if (dev_WARN_ONCE(&pdev->dev, pdev->dev.driver,
-			  "unlock attempted on driver attached device\n"))
-		return;
+	if (pdev->dev.driver)
+		return -EBUSY;
 
+	tsm_dev = pdev->tsm->tsm_dev;
+	ops = tsm_dev->pci_ops;
 	device_cc_reject(&pdev->dev);
-	to_pci_tsm_ops(pdev->tsm)->unlock(pdev->tsm);
-	pdev->tsm = NULL;
+	ret = ops->unlock(pdev->tsm);
+	if (ret)
+		pdev->tsm->error = true;
+	else
+		pdev->tsm = NULL;
+	if (ret)
+		pci_tsm_attestation_notify_state_change(pdev);
+	if (!ret) {
+		put_device(&tsm_dev->dev);
+		module_put(ops->owner);
+		pci_dev_put(pdev);
+	}
+	return ret;
 }
 
-static int pci_tsm_lock(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+int pci_tsm_lock(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 {
 	const struct pci_tsm_ops *ops = tsm_dev->pci_ops;
 	struct pci_tsm *tsm;
@@ -845,88 +885,101 @@ static int pci_tsm_lock(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	if (pdev->dev.driver)
 		return -EBUSY;
 
+	if (!try_module_get(ops->owner))
+		return -ENODEV;
+
 	tsm = ops->lock(tsm_dev, pdev);
-	if (IS_ERR(tsm))
+	if (IS_ERR(tsm)) {
+		module_put(ops->owner);
 		return PTR_ERR(tsm);
+	}
+	pci_dev_get(pdev);
+	get_device(&tsm_dev->dev);
 
 	pdev->tsm = tsm;
 	return 0;
 }
 
+static ssize_t lock_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	guard(rwsem_read)(&pci_tsm_rwsem);
+	if (!is_devsec(pdev))
+		return sysfs_emit(buf, "\n");
+
+	return sysfs_emit(buf, "%s\n", dev_name(&pdev->tsm->tsm_dev->dev));
+}
+
 static ssize_t lock_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int rc, id;
+	int ret, id;
 
-	rc = sscanf(buf, "tsm%d\n", &id);
-	if (rc != 1)
+	if (sscanf(buf, "tsm%d", &id) != 1 || id < 0)
 		return -EINVAL;
 
 	ACQUIRE(rwsem_write_kill, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &lock)))
-		return rc;
+	ret = ACQUIRE_ERR(rwsem_write_kill, &lock);
+	if (ret)
+		return ret;
 
-	if (pdev->tsm)
+	if (pci_dev_is_disconnected(pdev))
+		return -ENODEV;
+
+	if (pdev->tsm || pdev->tsm_attestation_removing)
 		return -EBUSY;
 
 	struct tsm_dev *tsm_dev __free(put_tsm_dev) = find_tsm_dev(id);
-	if (!is_devsec_tsm(tsm_dev))
+	if (!pci_tsm_can_lock(tsm_dev))
 		return -ENXIO;
 
-	rc = pci_tsm_lock(pdev, tsm_dev);
-	if (rc)
-		return rc;
-	return len;
-}
-
-static ssize_t lock_show(struct device *dev, struct device_attribute *attr,
-			 char *buf)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct tsm_dev *tsm_dev;
-	int rc;
-
-	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &lock)))
-		return rc;
+	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
+		return -EINVAL;
 
-	if (!pdev->tsm)
-		return sysfs_emit(buf, "\n");
+	ret = pci_tsm_lock(pdev, tsm_dev);
+	if (ret)
+		return ret;
 
-	tsm_dev = pdev->tsm->tsm_dev;
-	return sysfs_emit(buf, "%s\n", dev_name(&tsm_dev->dev));
+	ret = pci_tsm_attestation_add(pdev);
+	if (ret) {
+		guard(device)(&pdev->dev);
+		if (pci_tsm_unlock(pdev))
+			pci_warn(pdev, "TSM unlock failed after CTLV registration failure\n");
+	}
+	return ret ? ret : len;
 }
 static DEVICE_ATTR_RW(lock);
 
 static ssize_t unlock_store(struct device *dev, struct device_attribute *attr,
-			  const char *buf, size_t len)
+			    const char *buf, size_t len)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct tsm_dev *tsm_dev;
-	int rc;
+	LIST_HEAD(retired);
+	struct list_head *cleanup __free(pci_tsm_attestation_destroy) = &retired;
+	int ret;
 
 	ACQUIRE(rwsem_write_kill, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &lock)))
-		return rc;
-
-	if (!pdev->tsm)
-		return -EINVAL;
+	ret = ACQUIRE_ERR(rwsem_write_kill, &lock);
+	if (ret)
+		return ret;
 
-	tsm_dev = pdev->tsm->tsm_dev;
-	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
-		return -EINVAL;
+	if (pci_dev_is_disconnected(pdev))
+		return -ENODEV;
 
-	ACQUIRE(device_intr, dev_lock)(&pdev->dev);
-	if ((rc = ACQUIRE_ERR(device_intr, &dev_lock)))
-		return rc;
+	if (!is_devsec(pdev))
+		return -ENXIO;
 
-	if (pdev->dev.driver)
-		return -EBUSY;
+	if (!sysfs_streq(buf, dev_name(&pdev->tsm->tsm_dev->dev)))
+		return -EINVAL;
 
-	pci_tsm_unlock(pdev);
+	guard(device)(&pdev->dev);
+	ret = pci_tsm_unlock(pdev);
+	if (!ret)
+		pci_tsm_attestation_remove(pdev, &retired);
 
-	return len;
+	return ret ? ret : len;
 }
 static DEVICE_ATTR_WO(unlock);
 
@@ -948,85 +1001,68 @@ static bool pci_tsm_link_group_visible(struct kobject *kobj)
 	 * Show 'authenticated' and other attributes for the managed
 	 * sub-functions of a DSM.
 	 */
-	if (pdev->tsm)
+	if (pdev->tsm && pdev->tsm->dsm_dev)
 		return true;
 
 	return false;
 }
 DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(pci_tsm_link);
 
-static bool pci_tsm_devsec_group_visible(struct kobject *kobj)
+static umode_t pci_tsm_attr_visible(struct kobject *kobj,
+				  struct attribute *attr, int n)
 {
 	struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
 
-	return pci_tsm_devsec_count && has_tee(pdev);
-}
+	bool link = pci_tsm_link_group_visible(kobj);
+	bool devsec = pci_tsm_devsec_count && has_tee(pdev);
 
-/*
- * 'link' and 'devsec' TSMs share the same 'tsm/' sysfs group, so the TSM type
- * specific attributes need individual visibility checks.
- */
-static umode_t pci_tsm_attr_visible(struct kobject *kobj,
-				    struct attribute *attr, int n)
-{
-	if (pci_tsm_link_group_visible(kobj)) {
-		struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
+	if (n == 0 && !link && !devsec)
+		return SYSFS_GROUP_INVISIBLE;
 
-		if (attr == &dev_attr_dsm.attr) {
-			if (is_pci_tsm_pf0(pdev))
-				return attr->mode;
-			if (pdev->tsm && has_tee(pdev->tsm->dsm_dev))
-				return attr->mode;
-		}
+	if (attr == &dev_attr_connect.attr || attr == &dev_attr_disconnect.attr)
+		return link && is_pci_tsm_pf0(pdev) ? attr->mode : 0;
 
-		if (attr == &dev_attr_connect.attr ||
-		    attr == &dev_attr_disconnect.attr) {
-			if (is_pci_tsm_pf0(pdev))
-				return attr->mode;
-		}
-	}
-
-	if (pci_tsm_devsec_group_visible(kobj)) {
-		if (attr == &dev_attr_accept.attr ||
-		    attr == &dev_attr_lock.attr ||
-		    attr == &dev_attr_unlock.attr)
-			return attr->mode;
-	}
-
-	return 0;
-}
+	if (attr == &dev_attr_lock.attr || attr == &dev_attr_unlock.attr)
+		return devsec ? attr->mode : 0;
 
-static bool pci_tsm_group_visible(struct kobject *kobj)
-{
-	return pci_tsm_link_group_visible(kobj) ||
-	       pci_tsm_devsec_group_visible(kobj);
+	return link ? attr->mode : 0;
 }
-DEFINE_SYSFS_GROUP_VISIBLE(pci_tsm);
 
 static struct attribute *pci_tsm_attrs[] = {
 	&dev_attr_connect.attr,
 	&dev_attr_disconnect.attr,
-	&dev_attr_dsm.attr,
-	&dev_attr_accept.attr,
 	&dev_attr_lock.attr,
 	&dev_attr_unlock.attr,
+	&dev_attr_dsm.attr,
 	NULL
 };
 
 const struct attribute_group pci_tsm_attr_group = {
 	.name = "tsm",
 	.attrs = pci_tsm_attrs,
-	.is_visible = SYSFS_GROUP_VISIBLE(pci_tsm),
+	.is_visible = pci_tsm_attr_visible,
 };
 
 static ssize_t authenticated_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	/*
-	 * When the SPDM session established via TSM the 'authenticated' state
-	 * of the device is identical to the connect state.
-	 */
-	return connect_show(dev, attr, buf);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_tsm_pf0 *pf0;
+	int rc;
+
+	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
+	rc = ACQUIRE_ERR(rwsem_read_intr, &lock);
+	if (rc)
+		return rc;
+
+	if (!pdev->tsm || !pdev->tsm->dsm_dev)
+		return sysfs_emit(buf, "\n");
+
+	pf0 = to_pci_tsm_pf0(pdev->tsm);
+	if (!pf0 || !pf0->stream_connected || pf0->base_tsm.error)
+		return sysfs_emit(buf, "\n");
+
+	return sysfs_emit(buf, "%s\n", dev_name(&pdev->tsm->tsm_dev->dev));
 }
 static DEVICE_ATTR_RO(authenticated);
 
@@ -1127,6 +1163,7 @@ int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
 	}
 	tsm->pdev = pdev;
 	tsm->tsm_dev = tsm_dev;
+	pci_tsm_init_evidence(&tsm->evidence, 0, HASH_ALGO__LAST);
 
 	return 0;
 }
@@ -1149,6 +1186,7 @@ int pci_tsm_devsec_constructor(struct pci_dev *pdev, struct pci_tsm_devsec *tsm,
 	pci_tsm->dsm_dev = NULL;
 	pci_tsm->pdev = pdev;
 	pci_tsm->tsm_dev = tsm_dev;
+	pci_tsm_init_evidence(&pci_tsm->evidence, 0, HASH_ALGO__LAST);
 
 	return 0;
 }
@@ -1167,6 +1205,7 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
 	init_completion(&tsm->contexts_drained);
 	tsm->context_users = 0;
 	tsm->removing = false;
+	tsm->stream_connected = false;
 	/*
 	 * Low-level TSM drivers decide whether they can operate without a DOE
 	 * mailbox; some use an alternate transport for TDISP coordination.
@@ -1218,6 +1257,8 @@ int pci_tsm_register(struct tsm_dev *tsm_dev)
 				devsec_sysfs_enable(pdev);
 	}
 
+	for_each_pci_dev(pdev)
+		pci_tsm_attestation_update(pdev);
 	return 0;
 }
 
@@ -1230,7 +1271,8 @@ int pci_tsm_register(struct tsm_dev *tsm_dev)
  * with the TSM is torn down. Additionally, if there are no more TSMs
  * registered, the PCI tsm/ sysfs attributes are hidden.
  */
-static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev,
+			      struct list_head *retired)
 {
 	struct pci_tsm *tsm = pdev->tsm;
 
@@ -1269,8 +1311,11 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 
 	if (is_devsec_tsm(tsm_dev) && has_tee(pdev)) {
 		guard(device)(&pdev->dev);
-		pci_tsm_unlock(pdev);
+		if (pci_tsm_unlock(pdev))
+			pci_warn(pdev, "TSM unlock failed; retaining context\n");
 	}
+	if (!pdev->tsm)
+		pci_tsm_attestation_remove(pdev, retired);
 }
 
 void pci_tsm_destroy(struct pci_dev *pdev)
@@ -1279,8 +1324,10 @@ void pci_tsm_destroy(struct pci_dev *pdev)
 	struct completion *drained;
 	bool interrupted = false;
 	long rc;
+	LIST_HEAD(retired);
 
 	down_write(&pci_tsm_rwsem);
+	pci_tsm_attestation_remove(pdev, &retired);
 	if (pdev->tsm && is_link_tsm(pdev->tsm->tsm_dev) &&
 	    is_pci_tsm_pf0(pdev)) {
 		pf0 = to_pci_tsm_pf0(pdev->tsm);
@@ -1311,13 +1358,14 @@ void pci_tsm_destroy(struct pci_dev *pdev)
 		}
 		down_write(&pci_tsm_rwsem);
 	}
-	__pci_tsm_destroy(pdev, NULL);
+	__pci_tsm_destroy(pdev, NULL, &retired);
 	up_write(&pci_tsm_rwsem);
+	pci_tsm_attestation_destroy(&retired);
 }
 
 void pci_tsm_init(struct pci_dev *pdev)
 {
-	guard(rwsem_read)(&pci_tsm_rwsem);
+	guard(rwsem_write)(&pci_tsm_rwsem);
 
 	/*
 	 * Subfunctions are either probed synchronous with connect() or later
@@ -1337,10 +1385,9 @@ void pci_tsm_init(struct pci_dev *pdev)
 		 * The only path to init a Device Security Manager capable
 		 * device is via connect().
 		 */
-		if (!dsm->tsm)
+		if (!dsm->tsm || !is_link_tsm(dsm->tsm->tsm_dev))
 			return;
-		if (is_link_tsm(dsm->tsm->tsm_dev) &&
-		    to_pci_tsm_pf0(dsm->tsm)->removing)
+		if (to_pci_tsm_pf0(dsm->tsm)->removing)
 			return;
 		probe_fn(pdev, dsm);
 	}
@@ -1370,10 +1417,18 @@ static int pci_tsm_check_unregister(struct tsm_dev *tsm_dev)
 		}
 	}
 
+	if (is_devsec_tsm(tsm_dev)) {
+		for_each_pci_dev(pdev) {
+			if (pdev->tsm && pdev->tsm->tsm_dev == tsm_dev) {
+				pci_dev_put(pdev);
+				return -EBUSY;
+			}
+		}
+	}
 	return 0;
 }
 
-static void __pci_tsm_unregister(struct tsm_dev *tsm_dev)
+static void __pci_tsm_unregister(struct tsm_dev *tsm_dev, struct list_head *retired)
 {
 	struct pci_dev *pdev = NULL;
 
@@ -1382,19 +1437,26 @@ static void __pci_tsm_unregister(struct tsm_dev *tsm_dev)
 		pci_tsm_link_count--;
 	if (is_devsec_tsm(tsm_dev))
 		pci_tsm_devsec_count--;
-	for_each_pci_dev_reverse(pdev)
-		__pci_tsm_destroy(pdev, tsm_dev);
+	for_each_pci_dev_reverse(pdev) {
+		__pci_tsm_destroy(pdev, tsm_dev, retired);
+		pci_tsm_attestation_update(pdev);
+	}
 }
 
 void pci_tsm_unregister(struct tsm_dev *tsm_dev)
 {
+	LIST_HEAD(retired);
+	struct list_head *cleanup __free(pci_tsm_attestation_destroy) = &retired;
+
 	guard(rwsem_write)(&pci_tsm_rwsem);
-	__pci_tsm_unregister(tsm_dev);
+	__pci_tsm_unregister(tsm_dev, &retired);
 }
 
 /* Remove class lookup and PCI connections without admitting new users. */
 int pci_tsm_unregister_device(struct tsm_dev *tsm_dev)
 {
+	LIST_HEAD(retired);
+	struct list_head *cleanup __free(pci_tsm_attestation_destroy) = &retired;
 	int rc;
 
 	guard(rwsem_write)(&pci_tsm_rwsem);
@@ -1403,7 +1465,7 @@ int pci_tsm_unregister_device(struct tsm_dev *tsm_dev)
 		return rc;
 
 	device_del(&tsm_dev->dev);
-	__pci_tsm_unregister(tsm_dev);
+	__pci_tsm_unregister(tsm_dev, &retired);
 	return 0;
 }
 
diff --git a/drivers/pci/tsm/evidence.c b/drivers/pci/tsm/evidence.c
deleted file mode 100644
index 4d475b3dd6f6..000000000000
--- a/drivers/pci/tsm/evidence.c
+++ /dev/null
@@ -1,274 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (C) 2026 Intel Corporation */
-
-#include <crypto/hash_info.h>
-#include <linux/bitfield.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/netlink.h>
-#include <linux/pci.h>
-#include <linux/pci-tsm.h>
-#include <linux/slab.h>
-#include <net/genetlink.h>
-#include <net/netlink.h>
-
-#include "netlink.h"
-
-struct pci_tsm_evidence_ctx {
-	struct pci_dev *pdev;
-	unsigned long type_mask;
-	unsigned long flags;
-	void *nonce;
-	int generation;
-	int type;
-	u32 offset;
-	u16 nonce_len;
-};
-
-#define PCI_TSM_EVIDENCE_START U32_MAX
-#define PCI_TSM_EVIDENCE_OBJECT_START (U32_MAX - 1)
-int pci_tsm_nl_evidence_read_pre(struct netlink_callback *cb)
-{
-	struct pci_tsm_evidence_ctx *ctx = (struct pci_tsm_evidence_ctx *)cb->ctx;
-	const struct genl_info *info = genl_info_dump(cb);
-	unsigned long type_mask_unknown;
-	struct nlattr *attr;
-	struct device *dev;
-	char name[32];
-
-	NL_ASSERT_CTX_FITS(struct pci_tsm_evidence_ctx);
-
-	if (GENL_REQ_ATTR_CHECK(info, PCI_TSM_A_EVIDENCE_OBJECT_TYPE_MASK)) {
-		NL_SET_ERR_MSG(info->extack, "missing object request mask");
-		return -EINVAL;
-	}
-
-	attr = info->attrs[PCI_TSM_A_EVIDENCE_OBJECT_TYPE_MASK];
-	ctx->type_mask = nla_get_u32(attr);
-	type_mask_unknown = ctx->type_mask & ~PCI_TSM_EVIDENCE_TYPE_FLAG_MASK;
-	if (type_mask_unknown) {
-		NL_SET_ERR_MSG_FMT(info->extack,
-				   "unsupported object request %#lx",
-				   type_mask_unknown);
-		return -EINVAL;
-	}
-
-	attr = info->attrs[PCI_TSM_A_EVIDENCE_OBJECT_FLAGS];
-	if (attr) {
-		ctx->flags = nla_get_u32(attr);
-		if (ctx->flags & ~PCI_TSM_EVIDENCE_FLAG_MASK) {
-			NL_SET_BAD_ATTR(info->extack, attr);
-			return -EINVAL;
-		}
-	}
-
-	if (GENL_REQ_ATTR_CHECK(info, PCI_TSM_A_EVIDENCE_OBJECT_DEV_NAME)) {
-		NL_SET_ERR_MSG(info->extack, "missing device name");
-		return -EINVAL;
-	}
-
-	attr = info->attrs[PCI_TSM_A_EVIDENCE_OBJECT_DEV_NAME];
-	if (nla_strscpy(name, attr, sizeof(name)) < 0) {
-		NL_SET_BAD_ATTR(info->extack, attr);
-		return -EINVAL;
-	}
-
-	dev = bus_find_device_by_name(&pci_bus_type, NULL, name);
-	if (!dev) {
-		NL_SET_ERR_MSG_FMT(info->extack, "device '%s' not found", name);
-		return -ENODEV;
-	}
-	ctx->pdev = to_pci_dev(dev);
-
-	ctx->type =
-		find_first_bit(&ctx->type_mask, PCI_TSM_EVIDENCE_TYPE_MAX + 1);
-	if (ctx->type > PCI_TSM_EVIDENCE_TYPE_MAX) {
-		NL_SET_ERR_MSG(info->extack, "no evidence type requested");
-		return -EINVAL;
-	}
-	ctx->offset = PCI_TSM_EVIDENCE_START;
-
-	return 0;
-}
-
-int pci_tsm_nl_evidence_read_post(struct netlink_callback *cb)
-{
-	struct pci_tsm_evidence_ctx *ctx =
-		(struct pci_tsm_evidence_ctx *)cb->ctx;
-
-	pci_dev_put(ctx->pdev);
-	return 0;
-}
-
-static size_t evidence_len(struct pci_tsm_evidence *evidence,
-			   struct pci_tsm_evidence_object *obj,
-			   unsigned long flags)
-{
-	if (flags & PCI_TSM_EVIDENCE_FLAG_DIGEST) {
-		if (obj->digest)
-			return hash_digest_size[evidence->digest_algo];
-		return 0;
-	}
-	return obj->len;
-}
-
-static void *evidence_data(struct pci_tsm_evidence_object *obj,
-			   unsigned long flags)
-{
-	if (flags & PCI_TSM_EVIDENCE_FLAG_DIGEST)
-		return obj->digest;
-	return obj->data;
-}
-
-static int __pci_tsm_evidence_read(struct sk_buff *skb,
-				   struct netlink_callback *cb)
-{
-	struct pci_tsm_evidence_ctx *ctx =
-		(struct pci_tsm_evidence_ctx *)cb->ctx;
-	struct pci_dev *pdev = ctx->pdev;
-	struct pci_tsm_evidence *evidence = &pdev->tsm->evidence;
-	struct pci_tsm_evidence_object *obj = &evidence->obj[ctx->type];
-	size_t object_len = evidence_len(evidence, obj, ctx->flags);
-	void *object_data = evidence_data(obj, ctx->flags);
-	size_t available, overhead, len;
-	void *hdr;
-	int rc;
-
-	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-			  &pci_tsm_nl_family, NLM_F_MULTI,
-			  PCI_TSM_CMD_EVIDENCE_READ);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	if (ctx->offset == PCI_TSM_EVIDENCE_OBJECT_START) {
-		rc = nla_put_u32(skb, PCI_TSM_A_EVIDENCE_OBJECT_TYPE,
-				 ctx->type);
-		if (rc)
-			goto out_cancel;
-		ctx->offset = 0;
-	}
-
-	available = skb_tailroom(skb);
-	overhead = nla_total_size(0) + NLA_ALIGNTO;
-	if (available <= overhead) {
-		rc = -EMSGSIZE;
-		goto out_cancel;
-	}
-
-	if (object_len)
-		len = min(available - overhead, object_len - ctx->offset);
-	else
-		len = 0;
-
-	rc = nla_put(skb, PCI_TSM_A_EVIDENCE_OBJECT_VAL, len,
-		     object_data + ctx->offset);
-	if (rc)
-		goto out_end;
-
-	ctx->offset += len;
-	if (ctx->offset < object_len) {
-		rc = 1;
-		goto out_end;
-	}
-
-	ctx->type = find_next_bit(&ctx->type_mask,
-				  PCI_TSM_EVIDENCE_TYPE_MAX + 1, ctx->type + 1);
-	/* no more evidence types requested */
-	if (ctx->type > PCI_TSM_EVIDENCE_TYPE_MAX) {
-		rc = 0;
-		goto out_end;
-	}
-	ctx->offset = PCI_TSM_EVIDENCE_OBJECT_START;
-	rc = 1;
-
-out_end:
-	genlmsg_end(skb, hdr);
-	if (rc > 0)
-		return skb->len;
-	return rc;
-
-out_cancel:
-	genlmsg_cancel(skb, hdr);
-	return rc;
-}
-
-static int pci_tsm_evidence_read(struct sk_buff *skb,
-				 struct netlink_callback *cb)
-{
-	struct pci_tsm_evidence_ctx *ctx =
-		(struct pci_tsm_evidence_ctx *)cb->ctx;
-	const struct genl_info *info = genl_info_dump(cb);
-	struct pci_tsm_evidence *evidence;
-	struct pci_dev *pdev = ctx->pdev;
-	int rc;
-
-	ACQUIRE(rwsem_read_intr, tsm_lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &tsm_lock))) {
-		NL_SET_ERR_MSG(info->extack,
-			       "interrupted acquiring TSM context");
-		return rc;
-	}
-
-	if (!pdev->tsm) {
-		NL_SET_ERR_MSG(info->extack, "no TSM context");
-		return -ENXIO;
-	}
-
-	evidence = &pdev->tsm->evidence;
-	ACQUIRE(rwsem_read_intr, evidence_lock)(&evidence->lock);
-	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &evidence_lock))) {
-		NL_SET_ERR_MSG(info->extack, "interrupted acquiring evidence");
-		return rc;
-	}
-
-	/* generation is only valid when non-zero */
-	if (ctx->offset == PCI_TSM_EVIDENCE_START) {
-		if (!evidence->generation) {
-			NL_SET_ERR_MSG(info->extack, "no evidence available");
-			return -ENXIO;
-		}
-		ctx->generation = evidence->generation;
-		ctx->offset = PCI_TSM_EVIDENCE_OBJECT_START;
-	}
-
-	if (ctx->generation != evidence->generation) {
-		NL_SET_ERR_MSG(info->extack, "evidence updated during read");
-		return -EAGAIN;
-	}
-
-	return __pci_tsm_evidence_read(skb, cb);
-}
-
-static int pci_tsm_evidence_refresh(struct pci_tsm_evidence_ctx *ctx)
-{
-	return -EOPNOTSUPP;
-}
-
-int pci_tsm_nl_evidence_read_dumpit(struct sk_buff *skb,
-				    struct netlink_callback *cb)
-{
-	struct pci_tsm_evidence_ctx *ctx =
-		(struct pci_tsm_evidence_ctx *)cb->ctx;
-	const struct genl_info *info = genl_info_dump(cb);
-
-	/* Attempt one refresh per dump request before reading */
-	if (ctx->offset == PCI_TSM_EVIDENCE_START && ctx->nonce) {
-		int rc = pci_tsm_evidence_refresh(ctx);
-
-		if (rc) {
-			NL_SET_ERR_MSG_FMT(info->extack,
-					   "evidence refresh failed: %d", rc);
-			return rc;
-		}
-		ctx->nonce = NULL;
-	}
-	return pci_tsm_evidence_read(skb, cb);
-}
-
-static int __init pci_tsm_nl_init(void)
-{
-	return genl_register_family(&pci_tsm_nl_family);
-}
-
-subsys_initcall(pci_tsm_nl_init);
diff --git a/drivers/pci/tsm/internal.h b/drivers/pci/tsm/internal.h
new file mode 100644
index 000000000000..613267a84b8f
--- /dev/null
+++ b/drivers/pci/tsm/internal.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _PCI_TSM_INTERNAL_H
+#define _PCI_TSM_INTERNAL_H
+
+#include <linux/types.h>
+
+struct pci_dev;
+struct list_head;
+struct tsm_dev;
+
+/* All helpers require pci_tsm_rwsem held for write. */
+bool pci_tsm_can_lock(struct tsm_dev *tsm_dev);
+void pci_tsm_attestation_update(struct pci_dev *pdev);
+int pci_tsm_attestation_add(struct pci_dev *pdev);
+void pci_tsm_attestation_remove(struct pci_dev *pdev, struct list_head *retired);
+int pci_tsm_evidence_accept(struct pci_dev *pdev, unsigned int slot);
+int pci_tsm_disconnect(struct pci_dev *pdev);
+int pci_tsm_lock(struct pci_dev *pdev, struct tsm_dev *tsm_dev);
+int pci_tsm_unlock(struct pci_dev *pdev);
+int pci_tsm_accept(struct pci_dev *pdev);
+void pci_tsm_attestation_notify_state_change(struct pci_dev *pdev);
+
+/* Call after dropping PCI and device locks to drain retired CTLV requests. */
+void pci_tsm_attestation_destroy(struct list_head *retired);
+
+#endif
diff --git a/drivers/pci/tsm/netlink.c b/drivers/pci/tsm/netlink.c
deleted file mode 100644
index 26fadb727666..000000000000
--- a/drivers/pci/tsm/netlink.c
+++ /dev/null
@@ -1,43 +0,0 @@
-// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
-/* Do not edit directly, auto-generated from: */
-/*	Documentation/netlink/specs/pci-tsm.yaml */
-/* YNL-GEN kernel source */
-/* To regenerate run: tools/net/ynl/ynl-regen.sh */
-
-#include <net/netlink.h>
-#include <net/genetlink.h>
-
-#include "netlink.h"
-
-#include <uapi/linux/pci-tsm-netlink.h>
-
-/* PCI_TSM_CMD_EVIDENCE_READ - dump */
-static const struct nla_policy pci_tsm_evidence_read_nl_policy[PCI_TSM_A_EVIDENCE_OBJECT_NONCE + 1] = {
-	[PCI_TSM_A_EVIDENCE_OBJECT_TYPE_MASK] = { .type = NLA_U32, },
-	[PCI_TSM_A_EVIDENCE_OBJECT_FLAGS] = { .type = NLA_U32, },
-	[PCI_TSM_A_EVIDENCE_OBJECT_DEV_NAME] = { .type = NLA_NUL_STRING, },
-	[PCI_TSM_A_EVIDENCE_OBJECT_NONCE] = NLA_POLICY_MAX_LEN(PCI_TSM_MAX_NONCE_SIZE),
-};
-
-/* Ops table for pci_tsm */
-static const struct genl_split_ops pci_tsm_nl_ops[] = {
-	{
-		.cmd		= PCI_TSM_CMD_EVIDENCE_READ,
-		.start		= pci_tsm_nl_evidence_read_pre,
-		.dumpit		= pci_tsm_nl_evidence_read_dumpit,
-		.done		= pci_tsm_nl_evidence_read_post,
-		.policy		= pci_tsm_evidence_read_nl_policy,
-		.maxattr	= PCI_TSM_A_EVIDENCE_OBJECT_NONCE,
-		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
-	},
-};
-
-struct genl_family pci_tsm_nl_family __ro_after_init = {
-	.name		= PCI_TSM_FAMILY_NAME,
-	.version	= PCI_TSM_FAMILY_VERSION,
-	.netnsok	= true,
-	.parallel_ops	= true,
-	.module		= THIS_MODULE,
-	.split_ops	= pci_tsm_nl_ops,
-	.n_split_ops	= ARRAY_SIZE(pci_tsm_nl_ops),
-};
diff --git a/drivers/pci/tsm/netlink.h b/drivers/pci/tsm/netlink.h
deleted file mode 100644
index 34f3fb6ba2b7..000000000000
--- a/drivers/pci/tsm/netlink.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
-/* Do not edit directly, auto-generated from: */
-/*	Documentation/netlink/specs/pci-tsm.yaml */
-/* YNL-GEN kernel header */
-/* To regenerate run: tools/net/ynl/ynl-regen.sh */
-
-#ifndef _LINUX_PCI_TSM_GEN_H
-#define _LINUX_PCI_TSM_GEN_H
-
-#include <net/netlink.h>
-#include <net/genetlink.h>
-
-#include <uapi/linux/pci-tsm-netlink.h>
-
-int pci_tsm_nl_evidence_read_pre(struct netlink_callback *cb);
-int pci_tsm_nl_evidence_read_post(struct netlink_callback *cb);
-
-int pci_tsm_nl_evidence_read_dumpit(struct sk_buff *skb,
-				    struct netlink_callback *cb);
-
-extern struct genl_family pci_tsm_nl_family;
-
-#endif /* _LINUX_PCI_TSM_GEN_H */
diff --git a/drivers/virt/coco/arm-cca-guest/main.c b/drivers/virt/coco/arm-cca-guest/main.c
index 50a21317c941..f50f3e660bbc 100644
--- a/drivers/virt/coco/arm-cca-guest/main.c
+++ b/drivers/virt/coco/arm-cca-guest/main.c
@@ -340,8 +340,7 @@ static int cca_collect_dev_evidence(struct pci_dev *pdev, struct cca_guest_dsc *
 	down_write(&evidence->lock);
 	evidence->generation = dev_info->meas_seq;
 
-	/* we default to slot 0 in pdev_create */
-	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_CERT0];
+	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_CERT0 + evidence->slot];
 	WARN_ON(obj->data);
 	obj->data = certificate;
 	obj->len = certificate_size;
@@ -367,6 +366,11 @@ static int cca_collect_dev_evidence(struct pci_dev *pdev, struct cca_guest_dsc *
 	memcpy(dsc->dev_info.vca_digest, dev_info->protocol_data_digest, SHA512_DIGEST_SIZE);
 	memcpy(dsc->dev_info.meas_digest, dev_info->meas_digest, SHA512_DIGEST_SIZE);
 	memcpy(dsc->dev_info.report_digest, dev_info->report_digest, SHA512_DIGEST_SIZE);
+	evidence->obj[PCI_TSM_EVIDENCE_TYPE_CERT0 + evidence->slot].digest =
+		dsc->dev_info.cert_digest;
+	evidence->obj[PCI_TSM_EVIDENCE_TYPE_VCA].digest = dsc->dev_info.vca_digest;
+	evidence->obj[PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS].digest = dsc->dev_info.meas_digest;
+	evidence->obj[PCI_TSM_EVIDENCE_TYPE_REPORT].digest = dsc->dev_info.report_digest;
 	up_write(&evidence->lock);
 
 	kfree(dev_info);
@@ -416,6 +420,11 @@ static struct pci_tsm *cca_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *pde
 		goto free_dev_info;
 	}
 
+	if (dev_info->id_index) {
+		ret = -EOPNOTSUPP;
+		goto free_dev_info;
+	}
+
 	/* Collect the lock sequence number. */
 	cca_dsc->dev_info.lock_seq = dev_info->lock_seq;
 
@@ -450,7 +459,7 @@ static struct pci_tsm *cca_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *pde
 	return ERR_PTR(ret);
 }
 
-static void cca_tsm_unlock(struct pci_tsm *tsm)
+static int cca_tsm_unlock(struct pci_tsm *tsm)
 {
 	long ret;
 	struct pci_dev *pdev = tsm->pdev;
@@ -460,20 +469,22 @@ static void cca_tsm_unlock(struct pci_tsm *tsm)
 	ret = cca_unmap_evidence_report_range(tsm->pdev);
 	if (ret) {
 		pci_err(tsm->pdev, "failed to invalidate the interface report\n");
-		goto err_out;
+		return ret;
 	}
 
-	cca_device_unlock(tsm->pdev);
+	ret = cca_device_unlock(tsm->pdev);
+	if (ret)
+		return ret;
+
 	if (cca_dsc->pci.mmio)
 		pci_tsm_mmio_teardown(cca_dsc->pci.mmio);
 
-err_out:
-	/*
-	 * No error handling from this function. Leave the device locked
-	 */
 	if (cca_dsc->pci.mmio)
 		pci_tsm_mmio_free(tsm->pdev, cca_dsc->pci.mmio);
+	for (int i = 0; i <= PCI_TSM_EVIDENCE_TYPE_MAX; i++)
+		kvfree(tsm->evidence.obj[i].data);
 	kfree(cca_dsc);
+	return 0;
 }
 
 static int __cca_tsm_accept(struct pci_dev *pdev, unsigned long lock_seq)
@@ -496,6 +507,11 @@ static int cca_tsm_accept(struct pci_dev *pdev)
 }
 
 static struct pci_tsm_ops cca_devsec_pci_ops = {
+	.owner = THIS_MODULE,
+	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0) |
+			  BIT(PCI_TSM_EVIDENCE_TYPE_VCA) |
+			  BIT(PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS) |
+			  BIT(PCI_TSM_EVIDENCE_TYPE_REPORT),
 	.lock = cca_tsm_lock,
 	.unlock = cca_tsm_unlock,
 	.accept	 = cca_tsm_accept,
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
index b83b0b654ac3..f7a3c24817bb 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
@@ -268,28 +268,26 @@ int cca_device_accept(struct pci_dev *pdev, unsigned long lock_seq)
 		goto err_mmio_setup;
 	}
 
+	/* Keep partial mappings reachable until a successful UNLOCK. */
+	dsc->pci.mmio = tsm_mmio;
 	ret = cca_map_evidence_report_range(pdev, tsm_mmio);
 	if (ret) {
 		pci_err(pdev, "failed to validate the interface report\n");
-		goto err_evidence_report_map;
+		return ret;
 	}
 
 	ret = rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_RUN);
 	if (ret) {
 		pci_err(pdev, "failed to switch the device (%u) to RUN state\n", ret);
-		goto err_tdi_config_run;
+		return ret;
 	}
 
-	if (rsi_vdev_enable_dma(vdev_id, &dsc->dev_info))
+	if (rsi_vdev_enable_dma(vdev_id, &dsc->dev_info)) {
 		pci_err(pdev, "failed to enable DMA from the device\n");
-
-	dsc->pci.mmio = no_free_ptr(tsm_mmio);
+		return -EIO;
+	}
 	return 0;
 
-err_tdi_config_run:
-	cca_unmap_evidence_report_range(pdev);
-err_evidence_report_map:
-	pci_tsm_mmio_teardown(tsm_mmio);
 err_mmio_setup:
 	pci_tsm_mmio_free(pdev, tsm_mmio);
 	return ret;
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index ac8895925500..8fd209a2c32b 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -5,9 +5,45 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/rwsem.h>
+#include <linux/sizes.h>
 #include <uapi/linux/hash_info.h>
 #include <uapi/linux/iommufd.h>
-#include <uapi/linux/pci-tsm-netlink.h>
+
+
+#define PCI_TSM_MAX_OBJECT_SIZE SZ_16M
+
+/**
+ * enum pci_tsm_evidence_type - PCI device security evidence objects
+ * @PCI_TSM_EVIDENCE_TYPE_CERT0: SPDM certificate chain from device slot0
+ * @PCI_TSM_EVIDENCE_TYPE_CERT1: SPDM certificate chain from device slot1
+ * @PCI_TSM_EVIDENCE_TYPE_CERT2: SPDM certificate chain from device slot2
+ * @PCI_TSM_EVIDENCE_TYPE_CERT3: SPDM certificate chain from device slot3
+ * @PCI_TSM_EVIDENCE_TYPE_CERT4: SPDM certificate chain from device slot4
+ * @PCI_TSM_EVIDENCE_TYPE_CERT5: SPDM certificate chain from device slot5
+ * @PCI_TSM_EVIDENCE_TYPE_CERT6: SPDM certificate chain from device slot6
+ * @PCI_TSM_EVIDENCE_TYPE_CERT7: SPDM certificate chain from device slot7
+ * @PCI_TSM_EVIDENCE_TYPE_VCA: SPDM transcript of version, capabilities, and
+ *   algorithms negotiation
+ * @PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS: SPDM GET_MEASUREMENTS response
+ * @PCI_TSM_EVIDENCE_TYPE_REPORT: TDISP GET_DEVICE_INTERFACE_REPORT response
+ */
+enum pci_tsm_evidence_type {
+	PCI_TSM_EVIDENCE_TYPE_CERT0,
+	PCI_TSM_EVIDENCE_TYPE_CERT1,
+	PCI_TSM_EVIDENCE_TYPE_CERT2,
+	PCI_TSM_EVIDENCE_TYPE_CERT3,
+	PCI_TSM_EVIDENCE_TYPE_CERT4,
+	PCI_TSM_EVIDENCE_TYPE_CERT5,
+	PCI_TSM_EVIDENCE_TYPE_CERT6,
+	PCI_TSM_EVIDENCE_TYPE_CERT7,
+	PCI_TSM_EVIDENCE_TYPE_VCA,
+	PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS,
+	PCI_TSM_EVIDENCE_TYPE_REPORT,
+
+	/* private: */
+	__PCI_TSM_EVIDENCE_TYPE_MAX,
+	PCI_TSM_EVIDENCE_TYPE_MAX = (__PCI_TSM_EVIDENCE_TYPE_MAX - 1)
+};
 
 struct iommufd_viommu_ops;
 struct module;
@@ -26,6 +62,8 @@ struct tsm_dev;
  * @viommu_get_ops: Return operations for a supported TSM-owned vIOMMU type,
  *		  or NULL if unsupported
  * @owner: Module providing the vIOMMU operations, if built as a module
+ * @evidence_types: bitmap of PCI_TSM_EVIDENCE_TYPE_* objects the backend
+ *		   makes available through the evidence cache
  *
  * The vIOMMU owner holds a TSM device reference and pins the backend module
  * before querying @viommu_get_ops, releasing both after vIOMMU destruction.
@@ -41,6 +79,7 @@ struct tsm_dev;
  */
 struct pci_tsm_ops {
 	struct module *owner;
+	unsigned long evidence_types;
 	const struct iommufd_viommu_ops *(*viommu_get_ops)(
 		struct device *dev, enum iommu_viommu_type type);
 
@@ -49,21 +88,26 @@ struct pci_tsm_ops {
 	 * @probe: establish context with the TSM (allocate / wrap 'struct
 	 *	   pci_tsm') for follow-on link operations
 	 * @remove: destroy link operations context
-	 * @connect: establish / validate a secure connection (e.g. IDE)
-	 *	     with the device
+	 * @connect: collect device identity; required for link backends; legacy
+	 *	     backends may also establish IDE
+	 * @evidence_accept: establish the secure session and IDE after evidence
+	 *		  acceptance, using pci_tsm::evidence.slot as the selected
+	 *		  certificate slot; optional for legacy backends
 	 * @disconnect: teardown the secure link
 	 *
-	 * Context: @probe, @remove, @connect, and @disconnect run under
-	 * pci_tsm_rwsem held for write to sync with TSM unregistration and
-	 * mutual exclusion of @connect and @disconnect. @connect and
-	 * @disconnect additionally run under the DSM lock (struct
-	 * pci_tsm_pf0::lock) as well as @probe and @remove of the subfunctions.
+	 * Context: All callbacks run under pci_tsm_rwsem held for write to sync
+	 * with TSM unregistration and exclude concurrent link operations.
+	 * @connect and @disconnect additionally run under the DSM lock (struct
+	 * pci_tsm_pf0::lock), as do @probe and @remove of the subfunctions.
+	 * @evidence_accept runs under the attestation instance lock; the write
+	 * semaphore also excludes IOMMUFD consumers that take the DSM lock.
 	 */
 	struct_group_tagged(pci_tsm_link_ops, link_ops,
 		struct pci_tsm *(*probe)(struct tsm_dev *tsm_dev,
 					 struct pci_dev *pdev);
 		void (*remove)(struct pci_tsm *tsm);
 		int (*connect)(struct pci_dev *pdev);
+		int (*evidence_accept)(struct pci_dev *pdev);
 		void (*disconnect)(struct pci_dev *pdev);
 	);
 
@@ -72,18 +116,19 @@ struct pci_tsm_ops {
 	 * @lock: establish context with the TSM (allocate / wrap 'struct
 	 *	  pci_tsm') for follow-on security state transitions from the
 	 *	  LOCKED state
-	 * @unlock: destroy TSM context and return device to UNLOCKED state
+	 * @unlock: return device to UNLOCKED and free context on success; retain
+	 *          context on failure and return a negative errno
 	 * @accept: accept a locked TDI for use, move it to RUN state
 	 *
 	 * Context: @lock and @unlock run under pci_tsm_rwsem held for write to
 	 * sync with TSM unregistration and each other. @accept runs under
-	 * pci_tsm_rwsem held for read. All operations run under the device lock
+	 * pci_tsm_rwsem held for write. All operations run under the device lock
 	 * for mutual exclusion with driver attach and detach.
 	 */
 	struct_group_tagged(pci_tsm_devsec_ops, devsec_ops,
 		struct pci_tsm *(*lock)(struct tsm_dev *tsm_dev,
 					struct pci_dev *pdev);
-		void (*unlock)(struct pci_tsm *tsm);
+		int (*unlock)(struct pci_tsm *tsm);
 		int (*accept)(struct pci_dev *pdev);
 	);
 
@@ -101,15 +146,14 @@ struct pci_tsm_ops {
  *
  * There are multiple population and verification models for these blobs
  * depending on TSM policy. Some examples:
- * 1/ Host (link) TSM: populates certs and provides a device signed measurement
- *    transcript PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS
+ * 1/ Host (link) TSM: exposes supported certificate chains for
+ *    userspace verification before evidence acceptance establishes the stream.
  * 2/ Guest (devsec) TSM: receives untrusted blobs via guest-to-host shared
  *    memory protocol and then requests digests of the same via guest-to-host
  *    encrypted protocol.
- * The expectation is that all of these blobs are received in an SPDM session
- * with a signed transcript, however not all TSMs provide the full transcript of
- * these objects' retrieval and instead require asking the TSM for cached
- * digests of the blobs over trusted TSM channels.
+ * Host certificate retrieval precedes SPDM session establishment. Not all TSMs
+ * provide full transcripts; devsec TSMs may instead supply cached evidence
+ * digests over trusted TSM channels.
  */
 struct pci_tsm_evidence_object {
 	void *data;
@@ -119,9 +163,9 @@ struct pci_tsm_evidence_object {
 
 /**
  * struct pci_tsm_evidence - Retrieved evidence for SPDM session GET commands
- * @slot: certificate slot used by a link TSM for connect.
+ * @slot: certificate slot selected when accepting host evidence.
  * @generation: refresh_evidence() invocation detection
- * @digest_algo: payload size of PCI_TSM_EVIDENCE_FLAG_DIGEST requests
+ * @digest_algo: algorithm of native trusted evidence digests
  * @lock: synchronize dumps vs refresh_evidence()
  * @obj: array of evidence objects a TSM might populate
  *
@@ -145,6 +189,7 @@ struct pci_tsm_evidence {
  * @dsm_dev: PCI Device Security Manager for link operations on @pdev
  * @tsm_dev: PCI TEE Security Manager device for Link Confidentiality or Device
  *	     Function Security operations
+ * @error: hardware transition failed; require disconnect/unlock before reuse
  * @evidence: cached evidence from SPDM session establishment (connect), or
  *	      TDISP bind (lock)
  *
@@ -170,6 +215,7 @@ struct pci_tsm {
 	struct pci_dev *dsm_dev;
 	struct tsm_dev *tsm_dev;
 	struct pci_tsm_evidence evidence;
+	bool error;
 };
 
 /**
@@ -180,6 +226,7 @@ struct pci_tsm {
  *	blocks link disconnect
  * @contexts_drained: completed when the last context is released
  * @removing: reject new contexts while the DSM is being removed
+ * @stream_connected: secure session and stream setup completed
  * @doe_mb: PCIe Data Object Exchange mailbox
  */
 struct pci_tsm_pf0 {
@@ -188,6 +235,7 @@ struct pci_tsm_pf0 {
 	unsigned int context_users;
 	struct completion contexts_drained;
 	bool removing;
+	bool stream_connected;
 	struct pci_doe_mb *doe_mb;
 };
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d31a8d107b1e..39541d217fac 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -580,6 +580,8 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_TSM
 	struct pci_tsm *tsm;		/* TSM operation state */
+	struct pci_tsm_attestation *tsm_attestation; /* Connected/locked CTLV instance */
+	bool tsm_attestation_removing; /* CTLV teardown is draining requests */
 #endif
 	u16		acs_cap;	/* ACS Capability offset */
 	u16		acs_capabilities; /* ACS Capabilities */
diff --git a/include/uapi/linux/pci-tsm-netlink.h b/include/uapi/linux/pci-tsm-netlink.h
deleted file mode 100644
index a0e8b044e1b8..000000000000
--- a/include/uapi/linux/pci-tsm-netlink.h
+++ /dev/null
@@ -1,101 +0,0 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
-/* Do not edit directly, auto-generated from: */
-/*	Documentation/netlink/specs/pci-tsm.yaml */
-/* YNL-GEN uapi header */
-/* To regenerate run: tools/net/ynl/ynl-regen.sh */
-
-#ifndef _UAPI_LINUX_PCI_TSM_NETLINK_H
-#define _UAPI_LINUX_PCI_TSM_NETLINK_H
-
-#define PCI_TSM_FAMILY_NAME	"pci-tsm"
-#define PCI_TSM_FAMILY_VERSION	1
-
-#define PCI_TSM_MAX_OBJECT_SIZE	16777216
-#define PCI_TSM_MAX_NONCE_SIZE	256
-#define PCI_TSM_MAX_OBJ_TYPE	4
-
-/**
- * enum pci_tsm_evidence_type - PCI device security evidence objects
- * @PCI_TSM_EVIDENCE_TYPE_CERT0: SPDM certificate chain from device slot0
- * @PCI_TSM_EVIDENCE_TYPE_CERT1: SPDM certificate chain from device slot1
- * @PCI_TSM_EVIDENCE_TYPE_CERT2: SPDM certificate chain from device slot2
- * @PCI_TSM_EVIDENCE_TYPE_CERT3: SPDM certificate chain from device slot3
- * @PCI_TSM_EVIDENCE_TYPE_CERT4: SPDM certificate chain from device slot4
- * @PCI_TSM_EVIDENCE_TYPE_CERT5: SPDM certificate chain from device slot5
- * @PCI_TSM_EVIDENCE_TYPE_CERT6: SPDM certificate chain from device slot6
- * @PCI_TSM_EVIDENCE_TYPE_CERT7: SPDM certificate chain from device slot7
- * @PCI_TSM_EVIDENCE_TYPE_VCA: SPDM transcript of version, capabilities, and
- *   algorithms negotiation
- * @PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS: SPDM GET_MEASUREMENTS response
- * @PCI_TSM_EVIDENCE_TYPE_REPORT: TDISP GET_DEVICE_INTERFACE_REPORT response
- */
-enum pci_tsm_evidence_type {
-	PCI_TSM_EVIDENCE_TYPE_CERT0,
-	PCI_TSM_EVIDENCE_TYPE_CERT1,
-	PCI_TSM_EVIDENCE_TYPE_CERT2,
-	PCI_TSM_EVIDENCE_TYPE_CERT3,
-	PCI_TSM_EVIDENCE_TYPE_CERT4,
-	PCI_TSM_EVIDENCE_TYPE_CERT5,
-	PCI_TSM_EVIDENCE_TYPE_CERT6,
-	PCI_TSM_EVIDENCE_TYPE_CERT7,
-	PCI_TSM_EVIDENCE_TYPE_VCA,
-	PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS,
-	PCI_TSM_EVIDENCE_TYPE_REPORT,
-
-	/* private: */
-	__PCI_TSM_EVIDENCE_TYPE_MAX,
-	PCI_TSM_EVIDENCE_TYPE_MAX = (__PCI_TSM_EVIDENCE_TYPE_MAX - 1)
-};
-
-/*
- * PCI device security evidence request flags
- */
-enum pci_tsm_evidence_type_flag {
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT0 = 1,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT1 = 2,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT2 = 4,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT3 = 8,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT4 = 16,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT5 = 32,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT6 = 64,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_CERT7 = 128,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_VCA = 256,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_MEASUREMENTS = 512,
-	PCI_TSM_EVIDENCE_TYPE_FLAG_REPORT = 1024,
-
-	/* private: */
-	PCI_TSM_EVIDENCE_TYPE_FLAG_MASK = 2047,
-};
-
-/**
- * enum pci_tsm_evidence_flag - Flags to control evidence retrieval
- * @PCI_TSM_EVIDENCE_FLAG_DIGEST: Request the TSM's private digest of an
- *   evidence object
- */
-enum pci_tsm_evidence_flag {
-	PCI_TSM_EVIDENCE_FLAG_DIGEST = 1,
-
-	/* private: */
-	PCI_TSM_EVIDENCE_FLAG_MASK = 1,
-};
-
-enum {
-	PCI_TSM_A_EVIDENCE_OBJECT_TYPE = 1,
-	PCI_TSM_A_EVIDENCE_OBJECT_TYPE_MASK,
-	PCI_TSM_A_EVIDENCE_OBJECT_FLAGS,
-	PCI_TSM_A_EVIDENCE_OBJECT_DEV_NAME,
-	PCI_TSM_A_EVIDENCE_OBJECT_NONCE,
-	PCI_TSM_A_EVIDENCE_OBJECT_VAL,
-
-	__PCI_TSM_A_EVIDENCE_OBJECT_MAX,
-	PCI_TSM_A_EVIDENCE_OBJECT_MAX = (__PCI_TSM_A_EVIDENCE_OBJECT_MAX - 1)
-};
-
-enum {
-	PCI_TSM_CMD_EVIDENCE_READ = 1,
-
-	__PCI_TSM_CMD_MAX,
-	PCI_TSM_CMD_MAX = (__PCI_TSM_CMD_MAX - 1)
-};
-
-#endif /* _UAPI_LINUX_PCI_TSM_NETLINK_H */
diff --git a/samples/devsec/common.c b/samples/devsec/common.c
index 5dc4152e8b99..641266ca0b7f 100644
--- a/samples/devsec/common.c
+++ b/samples/devsec/common.c
@@ -5,7 +5,6 @@
 #include <linux/pci.h>
 #include <linux/pci-tsm.h>
 #include <linux/vmalloc.h>
-#include <uapi/linux/pci-tsm-netlink.h>
 
 #include "devsec.h"
 
diff --git a/samples/devsec/link_tsm.c b/samples/devsec/link_tsm.c
index 864ddf592db4..61cf6c16e1b5 100644
--- a/samples/devsec/link_tsm.c
+++ b/samples/devsec/link_tsm.c
@@ -231,6 +231,7 @@ static void devsec_link_tsm_disconnect(struct pci_dev *pdev)
 }
 
 static struct pci_tsm_ops devsec_link_pci_ops = {
+	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0),
 	.probe = devsec_link_tsm_pci_probe,
 	.remove = devsec_link_tsm_pci_remove,
 	.connect = devsec_link_tsm_connect,
diff --git a/samples/devsec/tsm.c b/samples/devsec/tsm.c
index 7d480a306e13..6ff88ca83906 100644
--- a/samples/devsec/tsm.c
+++ b/samples/devsec/tsm.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2024 - 2026 Intel Corporation */
 
 #define dev_fmt(fmt) "devsec: " fmt
+#include <crypto/hash_info.h>
 #include <linux/device/faux.h>
 #include <linux/pci-tsm.h>
 #include <linux/module.h>
@@ -10,6 +11,13 @@
 #include <linux/tsm.h>
 #include "devsec.h"
 
+static bool fail_accept;
+module_param(fail_accept, bool, 0600);
+MODULE_PARM_DESC(fail_accept, "Fail native ACCEPT for recovery testing");
+static bool fail_unlock;
+module_param(fail_unlock, bool, 0600);
+MODULE_PARM_DESC(fail_unlock, "Fail native UNLOCK while retaining its context");
+
 struct devsec_dev_data {
 	struct pci_tsm_devsec pci;
 };
@@ -32,17 +40,30 @@ static struct pci_tsm *devsec_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *
 	if (rc)
 		return ERR_PTR(rc);
 
+	devsec_evidence_busy();
+	pci_tsm_init_evidence(&devsec_data->pci.base_tsm.evidence, 0, HASH_ALGO_SHA384);
+	devsec_init_evidence(&devsec_data->pci.base_tsm.evidence);
+	/* The sample uses the same synthetic payload for all guest reports. */
+	devsec_data->pci.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_VCA] =
+		devsec_data->pci.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS];
+	devsec_data->pci.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_REPORT] =
+		devsec_data->pci.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS];
 	return &no_free_ptr(devsec_data)->pci.base_tsm;
 }
 
-static void devsec_tsm_unlock(struct pci_tsm *tsm)
+static int devsec_tsm_unlock(struct pci_tsm *tsm)
 {
 	struct devsec_dev_data *devsec_data = to_devsec_data(tsm);
 	struct pci_tsm_devsec *devsec_tsm = to_pci_tsm_devsec(tsm);
 
-	pci_tsm_mmio_teardown(devsec_tsm->mmio);
+	if (READ_ONCE(fail_unlock))
+		return -EIO;
+	if (devsec_tsm->mmio)
+		pci_tsm_mmio_teardown(devsec_tsm->mmio);
 	kfree(devsec_tsm->mmio);
+	devsec_evidence_idle();
 	kfree(devsec_data);
+	return 0;
 }
 
 static int devsec_tsm_accept(struct pci_dev *pdev)
@@ -54,6 +75,8 @@ static int devsec_tsm_accept(struct pci_dev *pdev)
 		kzalloc(struct_size(mmio, mmio, PCI_NUM_RESOURCES), GFP_KERNEL);
 	if (!mmio)
 		return -ENOMEM;
+	if (READ_ONCE(fail_accept))
+		return -EIO;
 
 	/*
 	 * Typically this range request would come from the TDISP Interface
@@ -78,6 +101,11 @@ static int devsec_tsm_accept(struct pci_dev *pdev)
 }
 
 static struct pci_tsm_ops devsec_pci_ops = {
+	.owner = THIS_MODULE,
+	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0) |
+			  BIT(PCI_TSM_EVIDENCE_TYPE_VCA) |
+			  BIT(PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS) |
+			  BIT(PCI_TSM_EVIDENCE_TYPE_REPORT),
 	.lock = devsec_tsm_lock,
 	.unlock = devsec_tsm_unlock,
 	.accept = devsec_tsm_accept,
-- 
2.43.0

