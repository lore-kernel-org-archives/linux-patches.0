Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201241;
	b=n7NhCxRDkLeVmB2EQf7uTjwb8Gnj2T7ohUVng6Z8ig2GjXYXv/3rDUGYhOg9tqLXY4Z9
	 VciCYat421cGfu2IkrR5DiiTXrGPeVKz5jtJIUCOY0i/5yl0l81R/9BZdVpxPmtjRCzp6
	 0+zLjxVeT24HDcvVBuP8B6wgowo1QhhKVo9YpFIqiE2zdoxUAqiONEuPV0iwlMKJKq6uY
	 /losbYSmWEnf9SSpTRZxNHt+xkjFhds5xNQbuJQsBW2VXCe6csbx35TR+nCJJXgIi/Tj0
	 2YZuyZc3KFrJ1uXaBfG8sJB0Vwmv9XF3yMRD065k3yZxIi0O7oTFAmWBkRQXCKD7AJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tgVwipkULVGhTHbPV91wk0Snx5XLbrbV+DZo/owgf20=;
	b=gRaIcCumM2T4VJASw93FaJbdY8ncDO5D1R5wLRRUie6hYEl4/g8M+hzfopihd8jtOw7g
	 wEPbdaUt7M9y0Hc7NI5W4CNnc6/mhEe26IWKdrIrvO/1+vxU90LvYcY4lGsGVw1ZlqMA6
	 8wT3tkVNMwxV3vAk90pwX8FHSzfWnyHD6WpXkHp+uiz3fy4i7fV4XijlyuGI4UaBj4Ko/
	 wcicTfPX0UmZqjQcoN/QdNlrUNPPaa7rqan7mMQATFoSql5+XZdCagJ+s7ftsKMeoBEu1
	 hbdty/TkaY4r8G2Q8D0vt+L/vfzXUkQ7s1KMOReS+S/YwzR1ZSCwvPMwfD8DhgchyZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jaYlamzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C65606A31D;
	Wed, 28 Oct 2026 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jaYlamzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED651F01828;
	Wed, 28 Oct 2026 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201240;
	bh=tgVwipkULVGhTHbPV91wk0Snx5XLbrbV+DZo/owgf20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaYlamzonK3M5ICuHPtoo+cgRh8l9y3/vyNMsac+Iqo13bkEKyxBJHHFqUhF/KRA0
	 vkdu/e08l80gC21TVHNZ6IR2jt35Y+UvP8nXcoBIeTzosBy6SOpBXuFEURNn4R1612
	 8XO6rOXcTkqNX0HicKyQt0inW+0OltdBRCIHedFkS5DLBAZav8j09iIfjcktrp1miK
	 LjGB8a7udjaUPFrPccRTdKqKPe2hgapdLxk3hzLjjDTj+Grjm0g4eObxmcqatZQzoH
	 uNaeyKSkY9gKKgT5z+pQ9LjuvbLdmNDcRoQ9BrFPQqE00i9bIBtWo/RIDze02sTkdh
	 4uUboXzum2b5Q==
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
	patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>
Subject: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation control family
Date: Wed, 28 Oct 2026 20:56:13 +0530
Message-ID: <20261028152618.1356860-7-aneesh.kumar@kernel.org>
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

Register ctlv-attestation-pci as a child of the common attestation
family. Add PCI state reporting and an object-selecting evidence refresh
operation with an optional challenge. Keep connect, disconnect, lock and
unlock in sysfs; IDE setup and TDISP run transition is driven by
evidence acceptance.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Dan Williams <djbw@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 .../ctlv/abi/ctlv-attestation-pci.yaml        |   43 +
 Documentation/ctlv/abi/families.registry.yaml |    1 +
 Documentation/ctlv/families.yaml              |    1 +
 Documentation/ctlv/generated-files.yaml       |   11 +
 .../ctlv/specs/ctlv-attestation-pci.yaml      |   79 +
 drivers/pci/tsm/ctlv_attestation_pci_gen.c    |  111 ++
 drivers/pci/tsm/ctlv_attestation_pci_gen.h    |  100 +
 include/uapi/linux/ctlv_attestation_pci_gen.h |   74 +
 include/uapi/linux/ctlv_families_gen.h        |    1 +
 tools/ctlv/tests/support.py                   |    3 +-
 tools/ctlv/tests/test_outputs.py              |    6 +-
 tools/ctlv/tests/test_semantics.py            |   38 +
 tools/ctlv/tests/test_spec.py                 |    1 +
 .../ctlv_attestation_pci_user_gen.c           | 1697 +++++++++++++++++
 .../ctlv_attestation_pci_user_gen.h           |  230 +++
 15 files changed, 2392 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ctlv/abi/ctlv-attestation-pci.yaml
 create mode 100644 Documentation/ctlv/specs/ctlv-attestation-pci.yaml
 create mode 100644 drivers/pci/tsm/ctlv_attestation_pci_gen.c
 create mode 100644 drivers/pci/tsm/ctlv_attestation_pci_gen.h
 create mode 100644 include/uapi/linux/ctlv_attestation_pci_gen.h
 create mode 100644 tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.c
 create mode 100644 tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.h

diff --git a/Documentation/ctlv/abi/ctlv-attestation-pci.yaml b/Documentation/ctlv/abi/ctlv-attestation-pci.yaml
new file mode 100644
index 000000000000..04fe5c0ab8fa
--- /dev/null
+++ b/Documentation/ctlv/abi/ctlv-attestation-pci.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+# Checked-in ABI snapshot of the ctlv-attestation-pci family, written by
+# "make -C tools/ctlv abi-update".
+#
+# The checker compares this family's declarations and inherited stub fills
+# against this file. Updating it is how a UAPI change gets reviewed; an update
+# that removes or renumbers anything, narrows a bound, or makes a placement
+# required is an ABI break, whatever this file says afterwards.
+family: {name: ctlv-attestation-pci, id: 6, inherits: ctlv-attestation,
+         pre-init: true}
+attr-groups:
+  pci:
+    id: 1
+    attrs:
+      name: {id: 1, type: string, min-length: 1, max-length: 31}
+      generation: {id: 2, type: uint, max: 4294967295}
+      tsm-id: {id: 3, type: uint, max: 2147483647}
+      connected: {id: 4, type: uint, max: 1}
+      locked: {id: 5, type: uint, max: 1}
+      accepted: {id: 6, type: uint, max: 1}
+      dsm: {id: 7, type: string, min-length: 1, max-length: 31}
+      object: {id: 8, enum: evidence-blob-class}
+      challenge: {id: 9, type: binary, length: 32}
+attr-sets:
+  change-reply: {id: 1}
+  state-reply: {id: 2}
+  refresh-request: {id: 3}
+fills:
+  device-info: {attrs: [pci.name]}
+ops:
+  state-get:
+    abi: {id: 1, type: action, fd-access: read}
+    reply:
+      attrs: [pci.generation, pci.connected, pci.locked, pci.accepted]
+      optional-attrs: [pci.tsm-id, pci.dsm]
+  evidence-refresh:
+    abi: {id: 2, type: action, availability: dynamic, optional: true}
+    request:
+      attrs: [pci.generation, pci.object]
+      optional-attrs: [pci.challenge]
+    reply: {attrs: [pci.generation]}
diff --git a/Documentation/ctlv/abi/families.registry.yaml b/Documentation/ctlv/abi/families.registry.yaml
index 7cdae176f5b4..a1a0836cef7e 100644
--- a/Documentation/ctlv/abi/families.registry.yaml
+++ b/Documentation/ctlv/abi/families.registry.yaml
@@ -10,3 +10,4 @@ families:
   - ctlv-test
   - ctlv-test-child
   - ctlv-attestation-sim
+  - ctlv-attestation-pci
diff --git a/Documentation/ctlv/families.yaml b/Documentation/ctlv/families.yaml
index db8b5185af11..8c1efa5e66bb 100644
--- a/Documentation/ctlv/families.yaml
+++ b/Documentation/ctlv/families.yaml
@@ -16,3 +16,4 @@ families:
   - ctlv-test
   - ctlv-test-child
   - ctlv-attestation-sim
+  - ctlv-attestation-pci
diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
index 3e6cda5fd91f..505e1db064e1 100644
--- a/Documentation/ctlv/generated-files.yaml
+++ b/Documentation/ctlv/generated-files.yaml
@@ -67,3 +67,14 @@ families:
         tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.h
       user-source: >-
         tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
+
+  - name: ctlv-attestation-pci
+    source: Documentation/ctlv/specs/ctlv-attestation-pci.yaml
+    outputs:
+      uapi-header: include/uapi/linux/ctlv_attestation_pci_gen.h
+      kernel-header: drivers/pci/tsm/ctlv_attestation_pci_gen.h
+      kernel-source: drivers/pci/tsm/ctlv_attestation_pci_gen.c
+      user-header: >-
+        tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.h
+      user-source: >-
+        tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.c
diff --git a/Documentation/ctlv/specs/ctlv-attestation-pci.yaml b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
new file mode 100644
index 000000000000..edb35cede0c2
--- /dev/null
+++ b/Documentation/ctlv/specs/ctlv-attestation-pci.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+%YAML 1.2
+---
+family:
+  name: ctlv-attestation-pci
+  inherits: ctlv-attestation
+  pre-init: true
+
+attr-groups:
+  - name: pci
+    attrs:
+      - name: name
+        type: string
+        min-length: 1
+        max-length: 31
+      - name: generation
+        type: uint
+        max: 4294967295
+      - name: tsm-id
+        type: uint
+        max: 2147483647
+      - name: connected
+        type: uint
+        max: 1
+      - name: locked
+        type: uint
+        max: 1
+      - name: accepted
+        type: uint
+        max: 1
+      - name: dsm
+        type: string
+        min-length: 1
+        max-length: 31
+
+      - name: object
+        enum: evidence-blob-class
+      - name: challenge
+        type: binary
+        min-length: 32
+        max-length: 32
+
+attr-sets:
+  - name: device-info
+    attrs: pci.name
+  - name: change-reply
+    attrs: pci.generation
+  - name: state-reply
+    attrs:
+      - pci.generation
+      - pci.connected
+      - pci.locked
+      - pci.accepted
+    optional-attrs:
+      - pci.tsm-id
+      - pci.dsm
+
+  - name: refresh-request
+    attrs:
+      - pci.generation
+      - pci.object
+    optional-attrs:
+      - pci.challenge
+
+ops:
+  - name: state-get
+    type: action
+    fd-access: read
+    reply:
+      attrs: state-reply
+  - name: evidence-refresh
+    type: action
+    fd-access: read-write
+    availability: dynamic
+    optional: true
+    request:
+      attrs: refresh-request
+    reply:
+      attrs: change-reply
diff --git a/drivers/pci/tsm/ctlv_attestation_pci_gen.c b/drivers/pci/tsm/ctlv_attestation_pci_gen.c
new file mode 100644
index 000000000000..a857fe158dc8
--- /dev/null
+++ b/drivers/pci/tsm/ctlv_attestation_pci_gen.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
+/*	Documentation/ctlv/specs/ctlv-attestation-pci.yaml */
+/* CTLV-GEN kernel source */
+
+#define _CTLV_GENERATED_METADATA_ONLY
+#include <linux/array_size.h>
+#include <linux/build_bug.h>
+#include <linux/ctlv_family.h>
+#include <linux/export.h>
+#include <linux/limits.h>
+
+#include <uapi/linux/ctlv_gen.h>
+#include <uapi/linux/ctlv_attestation_pci_gen.h>
+
+#include "ctlv_attestation_pci_gen.h"
+
+static const struct ctlv_node_schema state_get_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(0, 0, 0),
+};
+
+static const struct ctlv_node_schema state_get_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 6, 4),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION, 1, 0, U32_MAX),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED, 1, 0, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED, 1, 0, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED, 1, 0, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID, 1, 0, 2147483647),
+	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_PCI_ATTR_PCI_DSM, 1, 1, 31),
+};
+
+static const struct ctlv_node_schema evidence_refresh_request_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 3, 2),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION, 1, 0, U32_MAX),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT, 1, 9),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE, 1, 32, 32),
+};
+
+static const struct ctlv_node_schema evidence_refresh_reply_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION, 1, 0, U32_MAX),
+};
+
+static const struct ctlv_node_schema device_info_fill_node_schemas[] = {
+	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
+	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_PCI_ATTR_PCI_NAME, 1, 1, 31),
+};
+
+/* The extension points this family fills. */
+static const struct ctlv_stub_fill_schema ctlv_attestation_pci_stub_fill_schemas[] = {
+	CTLV_STUB_FILL_SCHEMA(CTLV_FAMILY_ATTESTATION, CTLV_ATTESTATION_SET_DEVICE_INFO,
+			      device_info),
+};
+
+/* The ops this family declares, in declaration order. */
+const struct ctlv_op_schema ctlv_attestation_pci_op_schemas[] = {
+	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_PCI_OP_STATE_GET, CTLV_OP_FD_ACCESS_READ,
+			      CTLV_OP_AVAILABILITY_FIXED, 16, 184,
+			      CTLV_SCHEMA_TREE(state_get_request),
+			      CTLV_SCHEMA_TREE(state_get_reply)),
+	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH,
+			      CTLV_OP_FD_ACCESS_READ_WRITE, CTLV_OP_AVAILABILITY_DYNAMIC, 112, 40,
+			      CTLV_SCHEMA_TREE(evidence_refresh_request),
+			      CTLV_SCHEMA_TREE(evidence_refresh_reply), .optional = true),
+};
+
+/* The family ID is its position in the central registry. */
+const struct ctlv_family_schema ctlv_attestation_pci_schema = {
+	.name = "ctlv-attestation-pci",
+	.family_id = 6,
+	.ops = ctlv_attestation_pci_op_schemas,
+	.ops_count = ARRAY_SIZE(ctlv_attestation_pci_op_schemas),
+	.stub_fill_schemas = ctlv_attestation_pci_stub_fill_schemas,
+	.stub_fill_schemas_count = ARRAY_SIZE(ctlv_attestation_pci_stub_fill_schemas),
+};
+
+/* Maximum uevent cost for this family chain. */
+static_assert(150 <= CTLV_UEVENT_MAX_LEN);
+static_assert(5 <= CTLV_UEVENT_MAX_VARS);
+
+/* Guards for generated maxima. */
+static_assert(184 <= CTLV_MAX_INLINE_MESSAGE_LEN);
+
+/* Local action and query bindings in declaration order. */
+static const struct ctlv_op ctlv_attestation_pci_ops[] = {
+	CTLV_OP_ACTION(ctlv_attestation_pci_state_get),
+	CTLV_OP_ACTION(ctlv_attestation_pci_evidence_refresh),
+};
+
+/* Extension-point callbacks. */
+static const struct ctlv_stub_ops ctlv_attestation_pci_stub_ops[] = {
+	CTLV_STUB_OPS(CTLV_FAMILY_ATTESTATION, CTLV_ATTESTATION_SET_DEVICE_INFO,
+		      ctlv_attestation_pci_device_info),
+};
+
+/* Family descriptor used by ctlv_create(). */
+const struct ctlv_family ctlv_attestation_pci_family = {
+	.schema = &ctlv_attestation_pci_schema,
+	.parent = &ctlv_attestation_family,
+	.ops = ctlv_attestation_pci_ops,
+	.ops_count = ARRAY_SIZE(ctlv_attestation_pci_ops),
+	.pre = ctlv_attestation_pci_op_pre,
+	.post = ctlv_attestation_pci_op_post,
+	.priv_size = ctlv_attestation_pci_priv_size,
+	.pre_init = ctlv_attestation_pci_pre_init,
+	.init = ctlv_attestation_pci_init,
+	.fini = ctlv_attestation_pci_fini,
+	.stub_ops = ctlv_attestation_pci_stub_ops,
+	.stub_ops_count = ARRAY_SIZE(ctlv_attestation_pci_stub_ops),
+};
+EXPORT_SYMBOL_NS_GPL(ctlv_attestation_pci_family, "CTLV");
diff --git a/drivers/pci/tsm/ctlv_attestation_pci_gen.h b/drivers/pci/tsm/ctlv_attestation_pci_gen.h
new file mode 100644
index 000000000000..95cad4e7b0bf
--- /dev/null
+++ b/drivers/pci/tsm/ctlv_attestation_pci_gen.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
+/*	Documentation/ctlv/specs/ctlv-attestation-pci.yaml */
+/* CTLV-GEN kernel header */
+
+/* Kernel metadata and family API of the ctlv-attestation-pci CTLV family. */
+
+#ifndef _LINUX_CTLV_ATTESTATION_PCI_GEN_H
+#define _LINUX_CTLV_ATTESTATION_PCI_GEN_H
+
+#include <linux/ctlv_family.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+
+#include <uapi/linux/ctlv_attestation_pci_gen.h>
+
+#include "ctlv_attestation_gen.h"
+
+/* Ops this family declares, in declaration order. */
+extern const struct ctlv_op_schema ctlv_attestation_pci_op_schemas[];
+
+extern const struct ctlv_family_schema ctlv_attestation_pci_schema;
+
+/* Implemented by this family, one per action and query it declares. */
+int ctlv_attestation_pci_state_get_action(void *priv, struct ctlv_op_ctx *ctx,
+					  const struct ctlv_cursor *request,
+					  struct ctlv_cursor *reply);
+int ctlv_attestation_pci_evidence_refresh_action(void *priv, struct ctlv_op_ctx *ctx,
+						 const struct ctlv_cursor *request,
+						 struct ctlv_cursor *reply);
+
+/* Family-wide hooks around every effective non-core op. */
+int ctlv_attestation_pci_op_pre(void *priv, struct ctlv_op_ctx *ctx);
+void ctlv_attestation_pci_op_post(void *priv, struct ctlv_op_ctx *ctx);
+
+/* Core-allocated family priv lifecycle. */
+size_t ctlv_attestation_pci_priv_size(void);
+const void *ctlv_attestation_pci_pre_init(const void *init_info);
+int ctlv_attestation_pci_init(struct ctlv_device *ctlvdev, const void *init_info, void *priv);
+void ctlv_attestation_pci_fini(struct ctlv_device *ctlvdev, void *priv);
+
+/* device-info of ctlv-attestation: fill and read callbacks. */
+int ctlv_attestation_pci_device_info_fill(void *priv, struct ctlv_op_ctx *ctx,
+					  const struct ctlv_cursor *request,
+					  struct ctlv_cursor *nest);
+void ctlv_attestation_pci_device_info_read(void *priv, struct ctlv_op_ctx *ctx,
+					   const struct ctlv_cursor *nest);
+
+extern const struct ctlv_family ctlv_attestation_pci_family;
+
+#ifndef _CTLV_GENERATED_METADATA_ONLY
+
+/* Optional publication and dynamic availability helpers. */
+CTLV_OP_PROVIDE(ctlv_attestation_pci_evidence_refresh, CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH)
+CTLV_OP_ENABLE(ctlv_attestation_pci_evidence_refresh, CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH)
+CTLV_OP_DISABLE(ctlv_attestation_pci_evidence_refresh, CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH)
+
+/* Reading a validated message. A blob has a resolver instead of a getter. */
+CTLV_IN_REF(ctlv_attestation_pci_evidence_refresh_generation,
+	    &ctlv_attestation_pci_op_schemas[1].request, CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION,
+	    0, 0, CTLV_SCHEMA_UINT)
+CTLV_IN_HAS(ctlv_attestation_pci_evidence_refresh_generation)
+CTLV_IN_U64(ctlv_attestation_pci_evidence_refresh_generation)
+CTLV_IN_REF(ctlv_attestation_pci_evidence_refresh_object,
+	    &ctlv_attestation_pci_op_schemas[1].request, CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT, 0, 1,
+	    CTLV_SCHEMA_ENUM)
+CTLV_IN_HAS(ctlv_attestation_pci_evidence_refresh_object)
+CTLV_IN_U64(ctlv_attestation_pci_evidence_refresh_object)
+CTLV_IN_REF(ctlv_attestation_pci_evidence_refresh_challenge,
+	    &ctlv_attestation_pci_op_schemas[1].request, CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE, 0,
+	    2, CTLV_SCHEMA_BINARY)
+CTLV_IN_HAS(ctlv_attestation_pci_evidence_refresh_challenge)
+CTLV_IN_BINARY(ctlv_attestation_pci_evidence_refresh_challenge)
+CTLV_IN_REF(ctlv_attestation_pci_device_info_name,
+	    &ctlv_attestation_pci_schema.stub_fill_schemas[0].members,
+	    CTLV_ATTESTATION_PCI_ATTR_PCI_NAME, 0, 0, CTLV_SCHEMA_STRING)
+CTLV_IN_HAS(ctlv_attestation_pci_device_info_name)
+CTLV_IN_STRING(ctlv_attestation_pci_device_info_name)
+
+/* Writing a reply. An append is atomic; a nest ends with ctlv_nest_end(). */
+CTLV_PUT_STRING(ctlv_attestation_pci_pci_name, CTLV_ATTESTATION_PCI_ATTR_PCI_NAME,
+		CTLV_SCHEMA_STRING)
+CTLV_PUT_U64(ctlv_attestation_pci_pci_generation, CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION,
+	     CTLV_SCHEMA_UINT)
+CTLV_PUT_U64(ctlv_attestation_pci_pci_tsm_id, CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID,
+	     CTLV_SCHEMA_UINT)
+CTLV_PUT_U64(ctlv_attestation_pci_pci_connected, CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED,
+	     CTLV_SCHEMA_UINT)
+CTLV_PUT_U64(ctlv_attestation_pci_pci_locked, CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED,
+	     CTLV_SCHEMA_UINT)
+CTLV_PUT_U64(ctlv_attestation_pci_pci_accepted, CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED,
+	     CTLV_SCHEMA_UINT)
+CTLV_PUT_STRING(ctlv_attestation_pci_pci_dsm, CTLV_ATTESTATION_PCI_ATTR_PCI_DSM, CTLV_SCHEMA_STRING)
+CTLV_PUT_U64(ctlv_attestation_pci_pci_object, CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT,
+	     CTLV_SCHEMA_ENUM)
+CTLV_PUT_BINARY(ctlv_attestation_pci_pci_challenge, CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE,
+		CTLV_SCHEMA_BINARY)
+#endif /* _CTLV_GENERATED_METADATA_ONLY */
+
+#endif /* _LINUX_CTLV_ATTESTATION_PCI_GEN_H */
diff --git a/include/uapi/linux/ctlv_attestation_pci_gen.h b/include/uapi/linux/ctlv_attestation_pci_gen.h
new file mode 100644
index 000000000000..160385bc2c2d
--- /dev/null
+++ b/include/uapi/linux/ctlv_attestation_pci_gen.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
+/*	Documentation/ctlv/specs/ctlv-attestation-pci.yaml */
+/* CTLV-GEN uapi header */
+
+/*
+ * Constants of the ctlv-attestation-pci CTLV family. Attr and op IDs are complete; the wire format
+ * carrying them is in <linux/ctlv.h>.
+ *
+ * The inherited ctlv-attestation header is included here, so one include covers the whole effective
+ * schema.
+ */
+
+#ifndef _UAPI_LINUX_CTLV_ATTESTATION_PCI_GEN_H
+#define _UAPI_LINUX_CTLV_ATTESTATION_PCI_GEN_H
+
+#include <linux/ctlv.h>
+#include <linux/ctlv_attestation_gen.h>
+#include <linux/ctlv_families_gen.h>
+
+/* attr groups */
+enum _ctlv_attestation_pci_group {
+	CTLV_ATTESTATION_PCI_GROUP_PCI = 1,
+};
+
+#define _CTLV_ATTESTATION_PCI_ATTR(_group, _attr) \
+	CTLV_ATTR(CTLV_FAMILY_ATTESTATION_PCI, (_group), (_attr))
+
+/* attrs of group pci */
+#define _CTLV_ATTESTATION_PCI_ATTR_PCI(_attr) \
+	_CTLV_ATTESTATION_PCI_ATTR(CTLV_ATTESTATION_PCI_GROUP_PCI, \
+				   _CTLV_ATTESTATION_PCI_ATTR_PCI_##_attr)
+
+enum _ctlv_attestation_pci_attr_pci {
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_NAME = 1,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_DSM,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT,
+	_CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE,
+};
+
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_NAME _CTLV_ATTESTATION_PCI_ATTR_PCI(NAME)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION _CTLV_ATTESTATION_PCI_ATTR_PCI(GENERATION)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID _CTLV_ATTESTATION_PCI_ATTR_PCI(TSM_ID)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED _CTLV_ATTESTATION_PCI_ATTR_PCI(CONNECTED)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED _CTLV_ATTESTATION_PCI_ATTR_PCI(LOCKED)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED _CTLV_ATTESTATION_PCI_ATTR_PCI(ACCEPTED)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_DSM _CTLV_ATTESTATION_PCI_ATTR_PCI(DSM)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT _CTLV_ATTESTATION_PCI_ATTR_PCI(OBJECT)
+#define CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE _CTLV_ATTESTATION_PCI_ATTR_PCI(CHALLENGE)
+
+/* attr sets */
+enum _ctlv_attestation_pci_set {
+	CTLV_ATTESTATION_PCI_SET_CHANGE_REPLY = 1,
+	CTLV_ATTESTATION_PCI_SET_STATE_REPLY,
+	CTLV_ATTESTATION_PCI_SET_REFRESH_REQUEST,
+};
+
+/* ops */
+enum _ctlv_attestation_pci_op {
+	_CTLV_ATTESTATION_PCI_OP_STATE_GET = 1,
+	_CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH,
+};
+
+#define _CTLV_ATTESTATION_PCI_OP(_op) \
+	CTLV_OP(CTLV_FAMILY_ATTESTATION_PCI, _CTLV_ATTESTATION_PCI_OP_##_op)
+#define CTLV_ATTESTATION_PCI_OP_STATE_GET _CTLV_ATTESTATION_PCI_OP(STATE_GET)
+#define CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH _CTLV_ATTESTATION_PCI_OP(EVIDENCE_REFRESH)
+
+#endif /* _UAPI_LINUX_CTLV_ATTESTATION_PCI_GEN_H */
diff --git a/include/uapi/linux/ctlv_families_gen.h b/include/uapi/linux/ctlv_families_gen.h
index 19c478660429..bad143ec85fd 100644
--- a/include/uapi/linux/ctlv_families_gen.h
+++ b/include/uapi/linux/ctlv_families_gen.h
@@ -15,6 +15,7 @@ enum _ctlv_family {
 	CTLV_FAMILY_TEST,
 	CTLV_FAMILY_TEST_CHILD,
 	CTLV_FAMILY_ATTESTATION_SIM,
+	CTLV_FAMILY_ATTESTATION_PCI,
 };
 
 #endif /* _UAPI_LINUX_CTLV_FAMILIES_GEN_H */
diff --git a/tools/ctlv/tests/support.py b/tools/ctlv/tests/support.py
index c50bb6b5b831..ddddefe48d4c 100644
--- a/tools/ctlv/tests/support.py
+++ b/tools/ctlv/tests/support.py
@@ -31,7 +31,8 @@ FIXTURE_REGISTRY = TESTS_DIR / 'families.yaml'
 
 # Every registered family, in registry order.
 FAMILIES = ('ctlv', 'ctlv-attestation', 'ctlv-attestation-tdx',
-            'ctlv-test', 'ctlv-test-child', 'ctlv-attestation-sim')
+            'ctlv-test', 'ctlv-test-child', 'ctlv-attestation-sim',
+            'ctlv-attestation-pci')
 
 # The fixture families, in fixture registry order: a parent holding one of
 # every shape the language allows, and a child that inherits it.
diff --git a/tools/ctlv/tests/test_outputs.py b/tools/ctlv/tests/test_outputs.py
index 5be773189ae1..c2443b2963db 100644
--- a/tools/ctlv/tests/test_outputs.py
+++ b/tools/ctlv/tests/test_outputs.py
@@ -67,9 +67,9 @@ class TestGeneratedOutputs(unittest.TestCase):
     def test_manifest_is_complete_and_unique(self):
         plan = outputs.load(self.paths)
 
-        self.assertEqual(37, len(plan))
-        self.assertEqual(37, len({item.path for item in plan}))
-        self.assertEqual(37, len({(item.source, item.flavour)
+        self.assertEqual(42, len(plan))
+        self.assertEqual(42, len({item.path for item in plan}))
+        self.assertEqual(42, len({(item.source, item.flavour)
                                  for item in plan}))
         registry_outputs = [item for item in plan if item.family is None]
         self.assertEqual(
diff --git a/tools/ctlv/tests/test_semantics.py b/tools/ctlv/tests/test_semantics.py
index 70f0a99f44f6..c0fb0b336db7 100644
--- a/tools/ctlv/tests/test_semantics.py
+++ b/tools/ctlv/tests/test_semantics.py
@@ -576,6 +576,44 @@ class TestRecursion(unittest.TestCase):
                                  'the same members, node for node')
 
 
+class TestPciAttestationPolicy(unittest.TestCase):
+    def test_connection_controls_are_not_in_ctlv(self):
+        family = support.load('ctlv-attestation-pci')
+        names = {op.name for op in family.ops}
+        self.assertNotIn('connect', names)
+        self.assertNotIn('disconnect', names)
+        self.assertNotIn('lock', names)
+        self.assertNotIn('unlock', names)
+        self.assertNotIn('devsec-run', names)
+
+    def test_backend_dependent_operations_are_dynamic(self):
+        family = support.load('ctlv-attestation-pci')
+        for name in ('evidence-refresh', 'evidence-get', 'evidence-accept',
+                     'evidence-accept-clear', 'devsec-state-get'):
+            with self.subTest(op=name):
+                op = support.op(family, name)
+                self.assertEqual('dynamic', op.availability)
+                self.assertTrue(op.optional)
+
+    def test_refresh_selects_an_object_with_an_optional_challenge(self):
+        family = support.load('ctlv-attestation-pci')
+        request = support.op(family, 'evidence-refresh').request
+        target = support.placement(request, 'pci.object')
+        challenge = support.placement(request, 'pci.challenge')
+        self.assertTrue(target.required)
+        self.assertFalse(challenge.required)
+        self.assertEqual(family.attrs['evidence.blob-class'].decl.ref,
+                         target.attr.decl.ref)
+
+    def test_state_operations_are_fixed(self):
+        family = support.load('ctlv-attestation-pci')
+        for name in ('state-get', 'device-get'):
+            with self.subTest(op=name):
+                op = support.op(family, name)
+                self.assertEqual('fixed', op.availability)
+                self.assertFalse(op.optional)
+
+
 class TestDump(unittest.TestCase):
     def test_repeated_renders_are_identical(self):
         for name in support.ALL_FAMILIES:
diff --git a/tools/ctlv/tests/test_spec.py b/tools/ctlv/tests/test_spec.py
index d80b16673675..248db73b044d 100644
--- a/tools/ctlv/tests/test_spec.py
+++ b/tools/ctlv/tests/test_spec.py
@@ -347,6 +347,7 @@ class TestRegistry(unittest.TestCase):
         self.assertEqual(3, registry.family_id('ctlv-test'))
         self.assertEqual(4, registry.family_id('ctlv-test-child'))
         self.assertEqual(5, registry.family_id('ctlv-attestation-sim'))
+        self.assertEqual(6, registry.family_id('ctlv-attestation-pci'))
 
     def test_the_fixture_registry_numbers_the_fixture_families(self):
         registry = spec.load_registry(
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.c
new file mode 100644
index 000000000000..dcf1477f3941
--- /dev/null
+++ b/tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.c
@@ -0,0 +1,1697 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
+/*	Documentation/ctlv/specs/ctlv-attestation-pci.yaml */
+/* CTLV-GEN user source */
+
+#include <stdint.h>
+
+#include <ctlv.h>
+
+#include "ctlv_attestation_pci_user_gen.h"
+
+/* Effective request and reply schemas. */
+
+static const struct ctlv_node_schema device_get_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+};
+
+/* cap.object, attrs */
+static const struct ctlv_node_schema device_get_reply_caps_evidence_object_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 9,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_FORMAT,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 2,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 2,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+};
+
+/* cap.object, optional attrs */
+static const struct ctlv_node_schema
+	device_get_reply_caps_evidence_object_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_BLOB_INSTANCE,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 21,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+};
+
+/* cap.evidence, attrs */
+static const struct ctlv_node_schema device_get_reply_caps_evidence_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_OBJECT,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 16,
+		.attrs = device_get_reply_caps_evidence_object_attr_node_schemas,
+		.attrs_count = 4,
+		.optional_attrs = device_get_reply_caps_evidence_object_optional_attr_node_schemas,
+		.optional_attrs_count = 2,
+	},
+};
+
+/* cap.evidence, optional attrs */
+static const struct ctlv_node_schema device_get_reply_caps_evidence_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_EVIDENCE_FLAGS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 15,
+	},
+};
+
+/* cap.mr, attrs */
+static const struct ctlv_node_schema device_get_reply_caps_mr_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 7,
+	},
+};
+
+/* device.caps, optional attrs */
+static const struct ctlv_node_schema device_get_reply_caps_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_EVIDENCE,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = device_get_reply_caps_evidence_attr_node_schemas,
+		.attrs_count = 4,
+		.optional_attrs = device_get_reply_caps_evidence_optional_attr_node_schemas,
+		.optional_attrs_count = 1,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_CAP_MR,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = device_get_reply_caps_mr_attr_node_schemas,
+		.attrs_count = 1,
+	},
+};
+
+/* device.info, attrs */
+static const struct ctlv_node_schema device_get_reply_info_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 31,
+	},
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema device_get_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_CAPS,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.optional_attrs = device_get_reply_caps_optional_attr_node_schemas,
+		.optional_attrs_count = 2,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_INFO,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = device_get_reply_info_attr_node_schemas,
+		.attrs_count = 1,
+	},
+};
+
+static const struct ctlv_node_schema device_get_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = device_get_reply_attr_node_schemas,
+	.attrs_count = 3,
+};
+
+/* evidence.object, attrs */
+static const struct ctlv_node_schema evidence_get_request_object_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 9,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_REPRESENTATION,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 2,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_DATA,
+		.kind = CTLV_SCHEMA_BLOB,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_BLOB,
+		.blob_direction = CTLV_BLOB_DIRECTION_OUTPUT,
+		.blob_backings = 14,
+		.blob_max_length = 0xffffffffULL,
+		.blob_alignment = 1,
+	},
+};
+
+/* evidence.object, optional attrs */
+static const struct ctlv_node_schema evidence_get_request_object_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_INSTANCE,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+};
+
+/* evidence.selection, attrs */
+static const struct ctlv_node_schema evidence_get_request_selection_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema evidence_get_request_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 16,
+		.attrs = evidence_get_request_object_attr_node_schemas,
+		.attrs_count = 4,
+		.optional_attrs = evidence_get_request_object_optional_attr_node_schemas,
+		.optional_attrs_count = 2,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema evidence_get_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 4096,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_SELECTION,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 256,
+		.attrs = evidence_get_request_selection_attr_node_schemas,
+		.attrs_count = 2,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_PRIVLEVEL,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_SERVICE_PROVIDER,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_SERVICE_GUID,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 16,
+		.max_length = 16,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_SERVICE_MANIFEST_VERSION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_OPTIONS,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+	},
+};
+
+static const struct ctlv_node_schema evidence_get_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = evidence_get_request_attr_node_schemas,
+	.attrs_count = 1,
+	.optional_attrs = evidence_get_request_optional_attr_node_schemas,
+	.optional_attrs_count = 8,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema evidence_get_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT_LENGTH,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 16,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = UINT64_MAX,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema evidence_get_reply_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema evidence_get_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = evidence_get_reply_attr_node_schemas,
+	.attrs_count = 2,
+	.optional_attrs = evidence_get_reply_optional_attr_node_schemas,
+	.optional_attrs_count = 2,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_get_request_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema mr_get_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_get_request_attr_node_schemas,
+	.attrs_count = 1,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_get_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 21,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_CAPS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 7,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema mr_get_reply_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_STATE_FLAGS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 1,
+	},
+};
+
+static const struct ctlv_node_schema mr_get_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_get_reply_attr_node_schemas,
+	.attrs_count = 3,
+	.optional_attrs = mr_get_reply_optional_attr_node_schemas,
+	.optional_attrs_count = 2,
+};
+
+static const struct ctlv_node_schema mr_dump_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+};
+
+/* mr.item, attrs */
+static const struct ctlv_node_schema mr_dump_reply_item_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 21,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_CAPS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 7,
+	},
+};
+
+/* mr.item, optional attrs */
+static const struct ctlv_node_schema mr_dump_reply_item_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_STATE_FLAGS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 1,
+	},
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_dump_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ITEM,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 0, /* unlimited */
+		.attrs = mr_dump_reply_item_attr_node_schemas,
+		.attrs_count = 4,
+		.optional_attrs = mr_dump_reply_item_optional_attr_node_schemas,
+		.optional_attrs_count = 2,
+	},
+};
+
+static const struct ctlv_node_schema mr_dump_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_dump_reply_attr_node_schemas,
+	.attrs_count = 1,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_read_request_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema mr_read_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_OPTIONS,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+	},
+};
+
+static const struct ctlv_node_schema mr_read_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_read_request_attr_node_schemas,
+	.attrs_count = 1,
+	.optional_attrs = mr_read_request_optional_attr_node_schemas,
+	.optional_attrs_count = 2,
+};
+
+/* mr.value, attrs */
+static const struct ctlv_node_schema mr_read_reply_value_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 16,
+		.max_length = 64,
+	},
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_read_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_VALUE,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 21,
+		.attrs = mr_read_reply_value_attr_node_schemas,
+		.attrs_count = 2,
+	},
+};
+
+static const struct ctlv_node_schema mr_read_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_read_reply_attr_node_schemas,
+	.attrs_count = 3,
+};
+
+/* mr.value, attrs */
+static const struct ctlv_node_schema mr_extend_request_value_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 16,
+		.max_length = 64,
+	},
+};
+
+/* record.item, attrs */
+static const struct ctlv_node_schema mr_extend_request_item_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_FORMAT,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 4096,
+	},
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_extend_request_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_VALUE,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 21,
+		.attrs = mr_extend_request_value_attr_node_schemas,
+		.attrs_count = 2,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema mr_extend_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_OPTIONS,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_ITEM,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_extend_request_item_attr_node_schemas,
+		.attrs_count = 2,
+	},
+};
+
+static const struct ctlv_node_schema mr_extend_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_extend_request_attr_node_schemas,
+	.attrs_count = 2,
+	.optional_attrs = mr_extend_request_optional_attr_node_schemas,
+	.optional_attrs_count = 3,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_extend_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema mr_extend_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_extend_reply_attr_node_schemas,
+	.attrs_count = 2,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema device_state_changed_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema device_state_changed_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = device_state_changed_reply_attr_node_schemas,
+	.attrs_count = 1,
+};
+
+/* mr.value, attrs */
+static const struct ctlv_node_schema mr_log_entry_appended_reply_entry_value_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 16,
+		.max_length = 64,
+	},
+};
+
+/* log.mr, attrs */
+static const struct ctlv_node_schema mr_log_entry_appended_reply_entry_mr_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 21,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_CAPS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 7,
+	},
+};
+
+/* log.mr, optional attrs */
+static const struct ctlv_node_schema
+	mr_log_entry_appended_reply_entry_mr_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+/* log.ima, attrs */
+static const struct ctlv_node_schema mr_log_entry_appended_reply_entry_ima_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_TEMPLATE_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_TEMPLATE_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 0x10000ULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_VIOLATION,
+		.kind = CTLV_SCHEMA_BOOL,
+		.max_occurrences = 1,
+	},
+};
+
+/* record.item, attrs */
+static const struct ctlv_node_schema mr_log_entry_appended_reply_entry_item_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_FORMAT,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 4096,
+	},
+};
+
+/* notification.entry, attrs */
+static const struct ctlv_node_schema mr_log_entry_appended_reply_entry_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_EVENT,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 2,
+	},
+};
+
+/* notification.entry, optional attrs */
+static const struct ctlv_node_schema
+	mr_log_entry_appended_reply_entry_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_VALUE,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 21,
+		.attrs = mr_log_entry_appended_reply_entry_value_attr_node_schemas,
+		.attrs_count = 2,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_MR,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_log_entry_appended_reply_entry_mr_attr_node_schemas,
+		.attrs_count = 3,
+		.optional_attrs = mr_log_entry_appended_reply_entry_mr_optional_attr_node_schemas,
+		.optional_attrs_count = 1,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_IMA,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_log_entry_appended_reply_entry_ima_attr_node_schemas,
+		.attrs_count = 3,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_ITEM,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_log_entry_appended_reply_entry_item_attr_node_schemas,
+		.attrs_count = 2,
+	},
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema mr_log_entry_appended_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_NOTIFICATION_ENTRY,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_log_entry_appended_reply_entry_attr_node_schemas,
+		.attrs_count = 4,
+		.optional_attrs = mr_log_entry_appended_reply_entry_optional_attr_node_schemas,
+		.optional_attrs_count = 4,
+	},
+};
+
+static const struct ctlv_node_schema mr_log_entry_appended_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = mr_log_entry_appended_reply_attr_node_schemas,
+	.attrs_count = 1,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema evidence_accept_request_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema evidence_accept_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = evidence_accept_request_attr_node_schemas,
+	.attrs_count = 2,
+};
+
+static const struct ctlv_node_schema evidence_accept_clear_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+};
+
+static const struct ctlv_node_schema devsec_state_get_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema devsec_state_get_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema devsec_state_get_reply_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPTED_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVSEC_TDISP_STATE,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 4,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVSEC_DEVICE_TRUST,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 5,
+	},
+};
+
+static const struct ctlv_node_schema devsec_state_get_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = devsec_state_get_reply_attr_node_schemas,
+	.attrs_count = 1,
+	.optional_attrs = devsec_state_get_reply_optional_attr_node_schemas,
+	.optional_attrs_count = 4,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema evidence_state_changed_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema evidence_state_changed_reply_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPTED_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema evidence_state_changed_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = evidence_state_changed_reply_attr_node_schemas,
+	.attrs_count = 1,
+	.optional_attrs = evidence_state_changed_reply_optional_attr_node_schemas,
+	.optional_attrs_count = 2,
+};
+
+/* mr.selection, attrs */
+static const struct ctlv_node_schema mr_log_get_request_selection_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema mr_log_get_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_SELECTION,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 256,
+		.attrs = mr_log_get_request_selection_attr_node_schemas,
+		.attrs_count = 1,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_START_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_END_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema mr_log_get_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.optional_attrs = mr_log_get_request_optional_attr_node_schemas,
+	.optional_attrs_count = 3,
+};
+
+/* mr.value, attrs */
+static const struct ctlv_node_schema mr_log_get_reply_entry_value_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 16,
+		.max_length = 64,
+	},
+};
+
+/* log.mr, attrs */
+static const struct ctlv_node_schema mr_log_get_reply_entry_mr_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_SUPPORTED_HASH_ALGO,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 21,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 20,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_CAPS,
+		.kind = CTLV_SCHEMA_FLAGS,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
+		.flags_mask = 7,
+	},
+};
+
+/* log.mr, optional attrs */
+static const struct ctlv_node_schema mr_log_get_reply_entry_mr_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_REGISTER_INDEX,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+/* log.ima, attrs */
+static const struct ctlv_node_schema mr_log_get_reply_entry_ima_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_TEMPLATE_NAME,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_TEMPLATE_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 0x10000ULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_VIOLATION,
+		.kind = CTLV_SCHEMA_BOOL,
+		.max_occurrences = 1,
+	},
+};
+
+/* record.item, attrs */
+static const struct ctlv_node_schema mr_log_get_reply_entry_item_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_FORMAT,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 128,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_DATA,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 4096,
+	},
+};
+
+/* log.entry, attrs */
+static const struct ctlv_node_schema mr_log_get_reply_entry_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_EVENT,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 2,
+	},
+};
+
+/* log.entry, optional attrs */
+static const struct ctlv_node_schema mr_log_get_reply_entry_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_VALUE,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 21,
+		.attrs = mr_log_get_reply_entry_value_attr_node_schemas,
+		.attrs_count = 2,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_MR,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_log_get_reply_entry_mr_attr_node_schemas,
+		.attrs_count = 3,
+		.optional_attrs = mr_log_get_reply_entry_mr_optional_attr_node_schemas,
+		.optional_attrs_count = 1,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_IMA,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_log_get_reply_entry_ima_attr_node_schemas,
+		.attrs_count = 3,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_RECORD_ITEM,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = mr_log_get_reply_entry_item_attr_node_schemas,
+		.attrs_count = 2,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema mr_log_get_reply_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_START_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_MR_END_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_LOG_ENTRY,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 0, /* unlimited */
+		.attrs = mr_log_get_reply_entry_attr_node_schemas,
+		.attrs_count = 4,
+		.optional_attrs = mr_log_get_reply_entry_optional_attr_node_schemas,
+		.optional_attrs_count = 4,
+	},
+};
+
+static const struct ctlv_node_schema mr_log_get_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.optional_attrs = mr_log_get_reply_optional_attr_node_schemas,
+	.optional_attrs_count = 3,
+};
+
+static const struct ctlv_node_schema state_get_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema state_get_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 1,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 1,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 1,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema state_get_reply_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0x7fffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_DSM,
+		.kind = CTLV_SCHEMA_STRING,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 1,
+		.max_length = 31,
+	},
+};
+
+static const struct ctlv_node_schema state_get_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = state_get_reply_attr_node_schemas,
+	.attrs_count = 4,
+	.optional_attrs = state_get_reply_optional_attr_node_schemas,
+	.optional_attrs_count = 2,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema evidence_refresh_request_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT,
+		.kind = CTLV_SCHEMA_ENUM,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 1,
+		.max = 9,
+	},
+};
+
+/* root, optional attrs */
+static const struct ctlv_node_schema evidence_refresh_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 32,
+		.max_length = 32,
+	},
+};
+
+static const struct ctlv_node_schema evidence_refresh_request_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = evidence_refresh_request_attr_node_schemas,
+	.attrs_count = 2,
+	.optional_attrs = evidence_refresh_request_optional_attr_node_schemas,
+	.optional_attrs_count = 1,
+};
+
+/* root, attrs */
+static const struct ctlv_node_schema evidence_refresh_reply_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
+static const struct ctlv_node_schema evidence_refresh_reply_node_schema = {
+	.attr_id = CTLV_ATTR_ROOT,
+	.kind = CTLV_SCHEMA_NEST,
+	.max_occurrences = 1,
+	.attrs = evidence_refresh_reply_attr_node_schemas,
+	.attrs_count = 1,
+};
+
+/* Effective ops in declaration order. */
+static const struct ctlv_op_spec ctlv_attestation_pci_op_specs[] = {
+	{
+		.op_id = CTLV_ATTESTATION_OP_DEVICE_GET,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.request_max_len = 16,
+		.action_reply_max_len = 12944,
+		.request = &device_get_request_node_schema,
+		.reply = &device_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_GET,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
+		.optional = true,
+		.request_max_len = 26800,
+		.action_reply_max_len = 472,
+		.request = &evidence_get_request_node_schema,
+		.reply = &evidence_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_MR_GET,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.optional = true,
+		.request_max_len = 40,
+		.action_reply_max_len = 744,
+		.request = &mr_get_request_node_schema,
+		.reply = &mr_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_MR_DUMP,
+		.type = CTLV_OP_TYPE_QUERY,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.optional = true,
+		.request_max_len = 16,
+		.query_reply_min_len = 184,
+		.query_reply_suggested_len = 4096,
+		.request = &mr_dump_request_node_schema,
+		.reply = &mr_dump_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_MR_READ,
+		.type = CTLV_OP_TYPE_QUERY,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.optional = true,
+		.request_max_len = 80,
+		.query_reply_min_len = 112,
+		.query_reply_suggested_len = 4096,
+		.request = &mr_read_request_node_schema,
+		.reply = &mr_read_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_MR_EXTEND,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.optional = true,
+		.request_max_len = 6880,
+		.action_reply_max_len = 64,
+		.request = &mr_extend_request_node_schema,
+		.reply = &mr_extend_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_DEVICE_STATE_CHANGED,
+		.type = CTLV_OP_TYPE_EVENT,
+		.event_record_max_len = 64,
+		.reply = &device_state_changed_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_MR_LOG_ENTRY_APPENDED,
+		.type = CTLV_OP_TYPE_EVENT,
+		.event_record_max_len = 73416,
+		.reply = &mr_log_entry_appended_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
+		.optional = true,
+		.request_max_len = 64,
+		.request = &evidence_accept_request_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
+		.optional = true,
+		.request_max_len = 16,
+		.request = &evidence_accept_clear_request_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_DEVSEC_STATE_GET,
+		.type = CTLV_OP_TYPE_QUERY,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
+		.optional = true,
+		.request_max_len = 16,
+		.query_reply_min_len = 40,
+		.query_reply_suggested_len = 1024,
+		.request = &devsec_state_get_request_node_schema,
+		.reply = &devsec_state_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED,
+		.type = CTLV_OP_TYPE_EVENT,
+		.event_record_max_len = 112,
+		.reply = &evidence_state_changed_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_OP_MR_LOG_GET,
+		.type = CTLV_OP_TYPE_QUERY,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.optional = true,
+		.request_max_len = 10304,
+		.query_reply_min_len = 65600,
+		.query_reply_suggested_len = 131072,
+		.request = &mr_log_get_request_node_schema,
+		.reply = &mr_log_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_PCI_OP_STATE_GET,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ,
+		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.request_max_len = 16,
+		.action_reply_max_len = 184,
+		.request = &state_get_request_node_schema,
+		.reply = &state_get_reply_node_schema,
+	},
+	{
+		.op_id = CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH,
+		.type = CTLV_OP_TYPE_ACTION,
+		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
+		.optional = true,
+		.request_max_len = 112,
+		.action_reply_max_len = 40,
+		.request = &evidence_refresh_request_node_schema,
+		.reply = &evidence_refresh_reply_node_schema,
+	},
+};
+
+/* Family specification descriptor. */
+const struct ctlv_family_spec ctlv_attestation_pci_spec = {
+	.name = "ctlv-attestation-pci",
+	.family_id = 6,
+	.parent = &ctlv_attestation_spec,
+	.ops = ctlv_attestation_pci_op_specs,
+	.ops_count = 15,
+};
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.h b/tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.h
new file mode 100644
index 000000000000..468546732a43
--- /dev/null
+++ b/tools/testing/selftests/attestation/ctlv_attestation_pci_user_gen.h
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit, regenerate with tools/ctlv/ctlv-regen.sh, from: */
+/*	Documentation/ctlv/specs/ctlv-attestation-pci.yaml */
+/* CTLV-GEN user header */
+
+/* Userspace binding of the ctlv-attestation-pci CTLV family. */
+
+#ifndef _CTLV_CTLV_ATTESTATION_PCI_USER_GEN_H
+#define _CTLV_CTLV_ATTESTATION_PCI_USER_GEN_H
+
+#include <ctlv.h>
+
+#include <linux/ctlv_attestation_pci_gen.h>
+
+#include "ctlv_attestation_user_gen.h"
+
+/* What this family's specification says, for holding a device against it. */
+extern const struct ctlv_family_spec ctlv_attestation_pci_spec;
+
+/* Executing an op. A query is reassembled into the one reply it fills. */
+
+#define CTLV_ATTESTATION_PCI_OP_STATE_GET_REQUEST_MAX_LEN 16
+#define CTLV_ATTESTATION_PCI_OP_STATE_GET_ACTION_REPLY_MAX_LEN 184
+
+static inline int ctlv_attestation_pci_state_get_request_new(struct ctlv_msg **request)
+{
+	const __u32 len = CTLV_ATTESTATION_PCI_OP_STATE_GET_REQUEST_MAX_LEN;
+
+	return ctlv_msg_new(len, request);
+}
+
+static inline int ctlv_attestation_pci_state_get(struct ctlv_dev *dev, struct ctlv_msg *request,
+						 struct ctlv_reply **reply,
+						 struct ctlv_error *error)
+{
+	return ctlv_action(dev, CTLV_ATTESTATION_PCI_OP_STATE_GET, request, reply, error);
+}
+
+#define CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH_REQUEST_MAX_LEN 112
+#define CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH_ACTION_REPLY_MAX_LEN 40
+
+static inline int ctlv_attestation_pci_evidence_refresh_request_new(struct ctlv_msg **request)
+{
+	const __u32 len = CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH_REQUEST_MAX_LEN;
+
+	return ctlv_msg_new(len, request);
+}
+
+static inline int ctlv_attestation_pci_evidence_refresh(struct ctlv_dev *dev,
+							struct ctlv_msg *request,
+							struct ctlv_reply **reply,
+							struct ctlv_error *error)
+{
+	return ctlv_action(dev, CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH, request, reply, error);
+}
+
+/* Building a request. ctlv_msg_err() reports the first failure. */
+
+static inline int ctlv_attestation_pci_pci_name_put(struct ctlv_msg *msg, const char *value)
+{
+	return ctlv_put_str(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_NAME, value);
+}
+
+static inline int ctlv_attestation_pci_pci_generation_put(struct ctlv_msg *msg, __u64 value)
+{
+	return ctlv_put_u64(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION, value);
+}
+
+static inline int ctlv_attestation_pci_pci_tsm_id_put(struct ctlv_msg *msg, __u64 value)
+{
+	return ctlv_put_u64(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID, value);
+}
+
+static inline int ctlv_attestation_pci_pci_connected_put(struct ctlv_msg *msg, __u64 value)
+{
+	return ctlv_put_u64(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED, value);
+}
+
+static inline int ctlv_attestation_pci_pci_locked_put(struct ctlv_msg *msg, __u64 value)
+{
+	return ctlv_put_u64(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED, value);
+}
+
+static inline int ctlv_attestation_pci_pci_accepted_put(struct ctlv_msg *msg, __u64 value)
+{
+	return ctlv_put_u64(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED, value);
+}
+
+static inline int ctlv_attestation_pci_pci_dsm_put(struct ctlv_msg *msg, const char *value)
+{
+	return ctlv_put_str(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_DSM, value);
+}
+
+static inline int ctlv_attestation_pci_pci_object_put(struct ctlv_msg *msg, __u64 value)
+{
+	return ctlv_put_u64(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT, value);
+}
+
+static inline int ctlv_attestation_pci_pci_challenge_put(struct ctlv_msg *msg, const void *value,
+							 __u32 len)
+{
+	return ctlv_put_bin(msg, CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE, value, len);
+}
+
+/* Reading a reply or a record. A getter answers whether it could read. */
+
+static inline bool ctlv_attestation_pci_pci_name_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_NAME);
+}
+
+static inline bool ctlv_attestation_pci_pci_name_get(const struct ctlv_attr *nest,
+						     const char **value)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_NAME);
+	return attr && !ctlv_get_str(attr, value);
+}
+
+static inline bool ctlv_attestation_pci_pci_generation_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION);
+}
+
+static inline bool ctlv_attestation_pci_pci_generation_get(const struct ctlv_attr *nest,
+							   __u64 *value)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_GENERATION);
+	return attr && !ctlv_get_u64(attr, value);
+}
+
+static inline bool ctlv_attestation_pci_pci_tsm_id_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID);
+}
+
+static inline bool ctlv_attestation_pci_pci_tsm_id_get(const struct ctlv_attr *nest, __u64 *value)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_TSM_ID);
+	return attr && !ctlv_get_u64(attr, value);
+}
+
+static inline bool ctlv_attestation_pci_pci_connected_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED);
+}
+
+static inline bool ctlv_attestation_pci_pci_connected_get(const struct ctlv_attr *nest,
+							  __u64 *value)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_CONNECTED);
+	return attr && !ctlv_get_u64(attr, value);
+}
+
+static inline bool ctlv_attestation_pci_pci_locked_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED);
+}
+
+static inline bool ctlv_attestation_pci_pci_locked_get(const struct ctlv_attr *nest, __u64 *value)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_LOCKED);
+	return attr && !ctlv_get_u64(attr, value);
+}
+
+static inline bool ctlv_attestation_pci_pci_accepted_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED);
+}
+
+static inline bool ctlv_attestation_pci_pci_accepted_get(const struct ctlv_attr *nest, __u64 *value)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_ACCEPTED);
+	return attr && !ctlv_get_u64(attr, value);
+}
+
+static inline bool ctlv_attestation_pci_pci_dsm_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_DSM);
+}
+
+static inline bool ctlv_attestation_pci_pci_dsm_get(const struct ctlv_attr *nest,
+						    const char **value)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_DSM);
+	return attr && !ctlv_get_str(attr, value);
+}
+
+static inline bool ctlv_attestation_pci_pci_object_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT);
+}
+
+static inline bool ctlv_attestation_pci_pci_object_get(const struct ctlv_attr *nest, __u64 *value,
+						       bool *known)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_OBJECT);
+	return attr && !ctlv_get_enum(attr, 9, value, known);
+}
+
+static inline bool ctlv_attestation_pci_pci_challenge_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE);
+}
+
+static inline bool ctlv_attestation_pci_pci_challenge_get(const struct ctlv_attr *nest,
+							  const void **value, __u32 *len)
+{
+	const struct ctlv_attr *attr;
+
+	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_PCI_ATTR_PCI_CHALLENGE);
+	return attr && !ctlv_get_bin(attr, value, len);
+}
+
+#endif /* _CTLV_CTLV_ATTESTATION_PCI_USER_GEN_H */
-- 
2.43.0

