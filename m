Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201224;
	b=29BJ/xRUIfyTsiPLn90tBi3aqMPA7jH2slq2ijFSvQV+m+j5mNsCNSP0OUbLAq+E7u0A
	 hrtbtJT6dBNqJdxCWHMCOfA55cfyigAq4xXqFivnuChtUtx72Tk9p6lWLcgJxustViC53
	 MbTPWyxO/vOgfV5N5DqCGCLG8aKiNjGUEvxLrtzhwHGzRThoYVlGjdn8OvlbiZzzhxt/5
	 BJlYI8gHxxB0VXswU8/5LqoedtQPWHJQh8WSBTKlxEc2bsN1fJf3SiW+RdUWnnKLZzcHp
	 ls/4jwlkabaz0+ZMTYIWLVk/0v3941YfsSoqhtoGu0pJJaueKqQEcQrDWUNMQ93MhjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=edUHGnsFhT8tRmIUBN99iLyu5b7CxjjLlK3j1bU1x04=;
	b=0rCvhNbUndBH8bry8oYnn8WzqvF9wrriLvSCEx24P9GWV77D5xPv/gbRxID+RQBPruEN
	 qBngSk8za+RvpOom0byzZGYkKmUcqBgmdQUOcawR2K4iTVQzUaGrZSycvI87HRpINeOzZ
	 qJ2VMm3Vort5uTg0tWwrvImRo3NgOlhY/BCkPT+dzrV0vD2fb/zKnkpaNM2NkQ2KoyBAU
	 hZXirFq99LYiVYppTvtfkjhmS2JdBsxfPgtw08i2KlZheMvNoz9zIko76FuGbeqTUKM5r
	 V0Soz+ipXZpCckw1mD9Qx2bal13NLV4KF0hM1ZF2xROlJNOOdhreu7OEb2F/VEBeS9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="e2p/eSjD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBCC606A31D;
	Wed, 28 Oct 2026 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2p/eSjD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C031F01828;
	Wed, 28 Oct 2026 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201223;
	bh=edUHGnsFhT8tRmIUBN99iLyu5b7CxjjLlK3j1bU1x04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2p/eSjDU0c3ulrfWDapGjXjKpYsGlJQ2yImnvY4yfwm/skpqssubSu/fCnFIRCuw
	 KR3emweZGkS6MKVQXur7hezSKx04pXct7Xh4psD8/hIxROvMdNUsh/wJ7QdiwOVzG2
	 TT8cUI3XqIYjyjbCkq41INsDS2gipc1Qo4aTuaQqDfXAbs4ubhvLHJ7iJ9Gdlhu8+V
	 q/iJ2RfxBY/aEdxYXLZDneyooK/CG+rdgdnzjtOXNIN5pz+NSktSbYa4UxrYh8a8c9
	 R0BzFnUeS1TFZYY6vaGe8A9o2WPirtp0WDIjUpoLkPMFJw46L/aNSysFsUJefqoYtN
	 FqYl7v210Xqjw==
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
Subject: [RFC PATCH v1 04/11] attestation: Bind object selection to accepted evidence snapshots
Date: Wed, 28 Oct 2026 20:56:11 +0530
Message-ID: <20261028152618.1356860-5-aneesh.kumar@kernel.org>
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

Follow-up PCI/TSM patches expose multiple populated SPDM certificate slots
and let userspace choose which chain to authorize. Device and evidence
generations identify an evidence snapshot, but cannot express which
certificate chain userspace selected from that snapshot.

Allow EVIDENCE_ACCEPT to select a logical evidence object by class, format,
and optional instance. For example, a request can name device generation
D, evidence generation E, and CERT_CHAIN with format "spdm-cert-chain"
and instance 3. Pass the resolved object to the provider so PCI/TSM can
call pci_tsm_evidence_accept(pdev, 3), allowing the backend to authenticate
the selected chain and establish streams using it.

Current object availability is not enough to authorize that choice. The
selected object must also have been retrieved in the referenced evidence
snapshot. Track the retrieved object set in evidence generation ranges
and reject selectors absent from that snapshot:

  Retrieved in snapshot E  Selected object  Membership check
  -----------------------  ---------------  ----------------
  Certificate slot 0       Slot 0           Pass
  Certificate slot 0       Slot 3           -ESTALE
  Certificate slots 0, 3   Slot 3           Pass

Reject slot 3 in the second case even if the instance currently supports
it. Per-instance object filtering checks availability; snapshot membership
checks that the selected object was included in the referenced retrieval.
Passing the membership check does not bypass the existing generation or
provider checks.

Include the selected object in verdict idempotence checks. Otherwise,
accepting slot 0 and then selecting slot 3 with the same device and
evidence generations would incorrectly return success without calling the
provider again. Let the provider handle the changed selection instead.

Advertise object selection through evidence capabilities and enable it in
the simulator for regression coverage.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ctlv/abi/ctlv-attestation.yaml  | 12 ++-
 .../ctlv/specs/ctlv-attestation.yaml          | 10 +++
 drivers/attestation/core/core.c               |  1 +
 drivers/attestation/core/ctlv.c               | 83 +++++++++++++++++--
 drivers/attestation/core/internal.h           |  2 +
 .../generated/ctlv_attestation_gen.c          |  8 +-
 .../generated/ctlv_attestation_gen.h          | 22 +++++
 drivers/attestation/providers/sim.c           |  5 +-
 drivers/attestation/tests/core_kunit.c        |  4 +-
 include/linux/attestation.h                   |  8 +-
 include/uapi/linux/ctlv_attestation_gen.h     |  9 +-
 .../ctlv_attestation_sim_user_gen.c           | 52 +++++++++++-
 .../ctlv_attestation_tdx_user_gen.c           | 52 +++++++++++-
 .../attestation/ctlv_attestation_user_gen.c   | 52 +++++++++++-
 .../attestation/ctlv_attestation_user_gen.h   | 18 +++-
 15 files changed, 314 insertions(+), 24 deletions(-)

diff --git a/Documentation/ctlv/abi/ctlv-attestation.yaml b/Documentation/ctlv/abi/ctlv-attestation.yaml
index 0220c2e131d4..018417fe3682 100644
--- a/Documentation/ctlv/abi/ctlv-attestation.yaml
+++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
@@ -22,7 +22,8 @@ flags:
   mr-device-caps: {read: 0, extend: 1, dynamic-topology: 2}
   mr-caps: {read: 0, extend: 1, removable: 2}
   mr-state-flags: {ima-active: 0}
-  evidence-caps: {evidence-accept: 0, mr-selection: 1, privlevel: 2, service: 3}
+  evidence-caps: {evidence-accept: 0, mr-selection: 1, privlevel: 2, service: 3,
+                  object-selection: 4}
 attr-groups:
   device:
     id: 1
@@ -69,6 +70,7 @@ attr-groups:
       service-guid: {id: 15, type: binary, length: 16}
       service-manifest-version: {id: 16, type: uint, max: 4294967295}
       options: {id: 17, type: nested}
+      accept-object: {id: 18, type: nested}
   mr:
     id: 4
     attrs:
@@ -145,6 +147,7 @@ attr-sets:
   mr-log-selection: {id: 30}
   mr-log-request: {id: 31}
   mr-log-reply: {id: 32}
+  evidence-object-selector: {id: 33}
 ops:
   device-get:
     abi: {id: 1, type: action, fd-access: read}
@@ -240,7 +243,12 @@ ops:
               - record.item: {attrs: [record.format, record.data]}
   evidence-accept:
     abi: {id: 9, type: action, availability: dynamic, optional: true}
-    request: {attrs: [device.generation, evidence.generation]}
+    request:
+      attrs: [device.generation, evidence.generation]
+      optional-attrs:
+        - evidence.accept-object:
+            attrs: [evidence.blob-class, evidence.format]
+            optional-attrs: [evidence.blob-instance]
   evidence-accept-clear:
     abi: {id: 10, type: action, availability: dynamic, optional: true}
   devsec-state-get:
diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
index 8494f716f9e9..98d6753d878f 100644
--- a/Documentation/ctlv/specs/ctlv-attestation.yaml
+++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
@@ -68,6 +68,7 @@ flags:
       - mr-selection
       - privlevel
       - service
+      - object-selection
 
 attr-groups:
   - name: device
@@ -175,6 +176,8 @@ attr-groups:
         max: 4294967295
       - name: options
         attrs: evidence-options
+      - name: accept-object
+        attrs: evidence-object-selector
 
   - name: mr
     attrs:
@@ -424,6 +427,7 @@ attr-sets:
     attrs:
       - device.generation
       - evidence.generation
+    optional-attrs: evidence.accept-object
 
   - name: devsec-state-reply
     attrs: device.generation
@@ -470,6 +474,12 @@ attr-sets:
       - mr.end-generation
       - log.entry
 
+  - name: evidence-object-selector
+    attrs:
+      - evidence.blob-class
+      - evidence.format
+    optional-attrs: evidence.blob-instance
+
 ops:
   - name: device-get
     type: action
diff --git a/drivers/attestation/core/core.c b/drivers/attestation/core/core.c
index a1de19dcab7d..914f29693aee 100644
--- a/drivers/attestation/core/core.c
+++ b/drivers/attestation/core/core.c
@@ -248,6 +248,7 @@ void attestation_evidence_accept_clear_locked(struct attestation *att)
 		return;
 	att->provider->evidence_accept_clear(att);
 	att->verdict_recorded = false;
+	att->accepted_object = NULL;
 }
 
 static void attestation_evidence_ranges_clear(struct attestation *att, bool dependent_only)
diff --git a/drivers/attestation/core/ctlv.c b/drivers/attestation/core/ctlv.c
index 7f755b7aaf51..f0238c4c4cf2 100644
--- a/drivers/attestation/core/ctlv.c
+++ b/drivers/attestation/core/ctlv.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <crypto/hash_info.h>
+#include <linux/bitmap.h>
 #include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/limits.h>
@@ -85,6 +86,8 @@ static int attestation_device_caps_put(struct attestation *att, struct ctlv_curs
 			flags |= CTLV_ATTESTATION_EVIDENCE_CAPS_PRIVLEVEL;
 		if (caps->supports_service_attestation)
 			flags |= CTLV_ATTESTATION_EVIDENCE_CAPS_SERVICE;
+		if (caps->supports_object_accept)
+			flags |= CTLV_ATTESTATION_EVIDENCE_CAPS_OBJECT_SELECTION;
 		ok &= ctlv_attestation_cap_evidence_flags_put(&group, flags);
 		for (index = 0; index < caps->objects_count; index++) {
 			const struct attestation_evidence_supported_object *cap =
@@ -311,7 +314,7 @@ static bool attestation_ranges_required(const struct attestation *att)
 	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
 	size_t index;
 
-	if (caps->supports_mr_selection)
+	if (caps->supports_mr_selection || caps->supports_object_accept)
 		return true;
 	for (index = 0; index < caps->objects_count; index++)
 		if (caps->objects[index].binds_mrs)
@@ -320,7 +323,7 @@ static bool attestation_ranges_required(const struct attestation *att)
 }
 
 static struct attestation_evidence_range *attestation_evidence_range_tail(struct attestation *att,
-									  bool mr_dependent)
+		bool mr_dependent, const unsigned long *objects)
 {
 	struct attestation_evidence_range *range;
 	unsigned long index;
@@ -331,6 +334,9 @@ static struct attestation_evidence_range *attestation_evidence_range_tail(struct
 			continue;
 		if (mr_dependent && range->mr_generation != att->log->generation)
 			continue;
+		if (objects && !bitmap_equal(range->objects, objects,
+					     att->provider->evidence_caps->objects_count))
+			continue;
 		return range;
 	}
 	return NULL;
@@ -419,6 +425,8 @@ int ctlv_attestation_evidence_get_action(void *priv, struct ctlv_op_ctx *ctx,
 	struct attestation_event_batch events = {};
 	struct ctlv_cursor options;
 	struct attestation *att = priv;
+	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
+	unsigned long *object_mask = NULL;
 	bool mr_dependent = false;
 	size_t index;
 	int put_ret;
@@ -431,6 +439,16 @@ int ctlv_attestation_evidence_get_action(void *priv, struct ctlv_op_ctx *ctx,
 						  &options);
 	if (ret)
 		goto out;
+	if (caps->supports_object_accept) {
+		object_mask = bitmap_zalloc(caps->objects_count, GFP_KERNEL);
+		if (!object_mask) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		for (index = 0; index < decoded.objects_count; index++)
+			__set_bit(decoded.objects[index].supported_object - caps->objects,
+				  object_mask);
+	}
 	result.object_lengths =
 		kcalloc(decoded.objects_count, sizeof(*result.object_lengths), GFP_KERNEL);
 	if (!result.object_lengths) {
@@ -445,9 +463,11 @@ int ctlv_attestation_evidence_get_action(void *priv, struct ctlv_op_ctx *ctx,
 		if (ret)
 			goto out;
 		if (attestation_ranges_required(att)) {
-			range = attestation_evidence_range_tail(att, mr_dependent);
+			range = attestation_evidence_range_tail(att, mr_dependent, object_mask);
 			if (!range) {
-				range = kzalloc_obj(*range, GFP_KERNEL);
+				size_t words = object_mask ? BITS_TO_LONGS(caps->objects_count) : 0;
+
+				range = kzalloc(struct_size(range, objects, words), GFP_KERNEL);
 				if (!range) {
 					ret = -ENOMEM;
 					goto out;
@@ -456,6 +476,9 @@ int ctlv_attestation_evidence_get_action(void *priv, struct ctlv_op_ctx *ctx,
 				range->end_generation = range->start_generation;
 				range->mr_dependent = mr_dependent;
 				range->mr_generation = att->log ? att->log->generation : 0;
+				if (object_mask)
+					bitmap_copy(range->objects, object_mask,
+						    caps->objects_count);
 				new_range = range;
 				ret = xa_reserve(&att->evidence_ranges, range->start_generation,
 						 GFP_KERNEL);
@@ -526,12 +549,14 @@ int ctlv_attestation_evidence_get_action(void *priv, struct ctlv_op_ctx *ctx,
 	}
 	attestation_events_abort(&events);
 	kfree(result.object_lengths);
+	bitmap_free(object_mask);
 	attestation_evidence_request_free(objects, decoded.objects_count, selection);
 	return ret;
 }
 
 static int attestation_evidence_validate(struct attestation *att, unsigned int device_generation,
-					 unsigned int evidence_generation)
+		unsigned int evidence_generation,
+		const struct attestation_evidence_supported_object *object)
 {
 	struct attestation_evidence_range *range;
 	unsigned long index;
@@ -550,17 +575,55 @@ static int attestation_evidence_validate(struct attestation *att, unsigned int d
 		if (range->mr_dependent &&
 		    (!att->log || range->mr_generation != att->log->generation))
 			return -ESTALE;
+		if (object && !test_bit(object - att->provider->evidence_caps->objects,
+				       range->objects))
+			return -ESTALE;
 		return 0;
 	}
 	return -ESTALE;
 }
 
+static int attestation_evidence_accept_object_decode(struct attestation *att,
+		const struct ctlv_cursor *request,
+		const struct attestation_evidence_supported_object **object)
+{
+	u64 instance = 0;
+	struct ctlv_cursor selector;
+	enum attestation_evidence_blob_class blob_class;
+	const char *format;
+	bool has_instance;
+
+	if (!ctlv_attestation_evidence_accept_evidence_accept_object_present(request))
+		return 0;
+	if (!att->provider->evidence_caps->supports_object_accept)
+		return -EOPNOTSUPP;
+	ctlv_attestation_evidence_accept_evidence_accept_object_get(&selector, request);
+	has_instance =
+		ctlv_attestation_evidence_accept_accept_object_evidence_blob_instance_present(
+		&selector);
+	if (has_instance)
+		instance =
+			ctlv_attestation_evidence_accept_accept_object_evidence_blob_instance_get(
+			&selector);
+	if (instance > UINT_MAX)
+		return -ERANGE;
+	blob_class =
+		ctlv_attestation_evidence_accept_accept_object_evidence_blob_class_get(
+			&selector);
+	format = ctlv_attestation_evidence_accept_accept_object_evidence_format_get(
+		&selector);
+	*object = attestation_evidence_object_find(att, blob_class, has_instance,
+						  instance, format);
+	return *object ? 0 : -EOPNOTSUPP;
+}
+
 int ctlv_attestation_evidence_accept_action(void *priv, struct ctlv_op_ctx *ctx,
 					    const struct ctlv_cursor *request,
 					    struct ctlv_cursor *reply)
 {
 	struct attestation_event_batch events = {};
 	struct attestation *att = priv;
+	const struct attestation_evidence_supported_object *object = NULL;
 	u64 device, evidence;
 	int ret;
 
@@ -568,21 +631,25 @@ int ctlv_attestation_evidence_accept_action(void *priv, struct ctlv_op_ctx *ctx,
 	evidence = ctlv_attestation_evidence_accept_evidence_generation_get(request);
 	if (device > UINT_MAX || evidence > UINT_MAX)
 		return -ESTALE;
-	ret = attestation_evidence_validate(att, device, evidence);
+	ret = attestation_evidence_accept_object_decode(att, request, &object);
+	if (ret)
+		return ret;
+	ret = attestation_evidence_validate(att, device, evidence, object);
 	if (ret)
 		return ret;
 	if (att->verdict_recorded && att->accepted_device_generation == device &&
-	    att->accepted_evidence_generation == evidence)
+	    att->accepted_evidence_generation == evidence && att->accepted_object == object)
 		return 0;
 	ret = attestation_events_prepare(att, &events, false, true, false);
 	if (ret)
 		return ret;
 	/* Acceptance authorizes this snapshot without retiring its generation binding. */
-	ret = att->provider->evidence_accept(att);
+	ret = att->provider->evidence_accept(att, object);
 	if (!ret) {
 		att->verdict_recorded = true;
 		att->accepted_device_generation = device;
 		att->accepted_evidence_generation = evidence;
+		att->accepted_object = object;
 		attestation_evidence_verdict_changed(att);
 		attestation_evidence_event_emit(&events, att);
 	}
diff --git a/drivers/attestation/core/internal.h b/drivers/attestation/core/internal.h
index 9e531e8483f7..7b444d61d996 100644
--- a/drivers/attestation/core/internal.h
+++ b/drivers/attestation/core/internal.h
@@ -25,6 +25,7 @@ struct attestation_evidence_range {
 	unsigned int end_generation;
 	bool mr_dependent;
 	unsigned int mr_generation;
+	unsigned long objects[];
 };
 
 struct attestation_mr_log_entry {
@@ -82,6 +83,7 @@ struct attestation {
 	bool verdict_recorded;
 	unsigned int accepted_device_generation;
 	unsigned int accepted_evidence_generation;
+	const struct attestation_evidence_supported_object *accepted_object;
 	unsigned int mr_read_generation;
 	unsigned int devsec_version;
 
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.c b/drivers/attestation/generated/ctlv_attestation_gen.c
index 4afd0433e26f..a858a84da135 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.c
+++ b/drivers/attestation/generated/ctlv_attestation_gen.c
@@ -193,9 +193,13 @@ static const struct ctlv_node_schema mr_log_entry_appended_reply_node_schemas[]
 };
 
 static const struct ctlv_node_schema evidence_accept_request_node_schemas[] = {
-	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
+	CTLV_NODE_SCHEMA_ROOT(1, 3, 2),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 1, 0, U32_MAX),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION, 1, 0, U32_MAX),
+	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT, 1, 4, 3, 2),
+	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS, 1, 9),
+	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT, 1, 1, 128),
+	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_INSTANCE, 1, 0, U32_MAX),
 };
 
 static const struct ctlv_node_schema evidence_accept_clear_request_node_schemas[] = {
@@ -286,7 +290,7 @@ const struct ctlv_op_schema ctlv_attestation_op_schemas[] = {
 	CTLV_OP_SCHEMA_EVENT(CTLV_ATTESTATION_OP_MR_LOG_ENTRY_APPENDED, 73416,
 			     CTLV_SCHEMA_TREE(mr_log_entry_appended_reply)),
 	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT, CTLV_OP_FD_ACCESS_READ_WRITE,
-			      CTLV_OP_AVAILABILITY_DYNAMIC, 64, 0,
+			      CTLV_OP_AVAILABILITY_DYNAMIC, 280, 0,
 			      CTLV_SCHEMA_TREE(evidence_accept_request), CTLV_SCHEMA_TREE_NONE(),
 			      .optional = true),
 	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.h b/drivers/attestation/generated/ctlv_attestation_gen.h
index 12716a7fa7af..95cb6a083633 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.h
+++ b/drivers/attestation/generated/ctlv_attestation_gen.h
@@ -225,6 +225,26 @@ CTLV_IN_REF(ctlv_attestation_evidence_accept_evidence_generation,
 	    1, CTLV_SCHEMA_UINT)
 CTLV_IN_HAS(ctlv_attestation_evidence_accept_evidence_generation)
 CTLV_IN_U64(ctlv_attestation_evidence_accept_evidence_generation)
+CTLV_IN_REF(ctlv_attestation_evidence_accept_evidence_accept_object,
+	    &ctlv_attestation_op_schemas[8].request, CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT,
+	    0, 2, CTLV_SCHEMA_NEST)
+CTLV_IN_HAS(ctlv_attestation_evidence_accept_evidence_accept_object)
+CTLV_IN_NEST(ctlv_attestation_evidence_accept_evidence_accept_object)
+CTLV_IN_REF(ctlv_attestation_evidence_accept_accept_object_evidence_blob_class,
+	    &ctlv_attestation_op_schemas[8].request, CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS, 3,
+	    0, CTLV_SCHEMA_ENUM)
+CTLV_IN_HAS(ctlv_attestation_evidence_accept_accept_object_evidence_blob_class)
+CTLV_IN_U64(ctlv_attestation_evidence_accept_accept_object_evidence_blob_class)
+CTLV_IN_REF(ctlv_attestation_evidence_accept_accept_object_evidence_format,
+	    &ctlv_attestation_op_schemas[8].request, CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT, 3, 1,
+	    CTLV_SCHEMA_STRING)
+CTLV_IN_HAS(ctlv_attestation_evidence_accept_accept_object_evidence_format)
+CTLV_IN_STRING(ctlv_attestation_evidence_accept_accept_object_evidence_format)
+CTLV_IN_REF(ctlv_attestation_evidence_accept_accept_object_evidence_blob_instance,
+	    &ctlv_attestation_op_schemas[8].request, CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_INSTANCE,
+	    3, 2, CTLV_SCHEMA_UINT)
+CTLV_IN_HAS(ctlv_attestation_evidence_accept_accept_object_evidence_blob_instance)
+CTLV_IN_U64(ctlv_attestation_evidence_accept_accept_object_evidence_blob_instance)
 CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_selection, &ctlv_attestation_op_schemas[12].request,
 	    CTLV_ATTESTATION_ATTR_MR_SELECTION, 0, 0, CTLV_SCHEMA_NEST)
 #define ctlv_attestation_mr_log_get_mr_selection_for_each(_attr, _nest) \
@@ -302,6 +322,8 @@ CTLV_PUT_U64(ctlv_attestation_evidence_service_manifest_version,
 	     CTLV_ATTESTATION_ATTR_EVIDENCE_SERVICE_MANIFEST_VERSION, CTLV_SCHEMA_UINT)
 CTLV_NEST_START(ctlv_attestation_evidence_options, CTLV_ATTESTATION_ATTR_EVIDENCE_OPTIONS,
 		CTLV_SCHEMA_NEST)
+CTLV_NEST_START(ctlv_attestation_evidence_accept_object,
+		CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT, CTLV_SCHEMA_NEST)
 CTLV_PUT_U64(ctlv_attestation_mr_id, CTLV_ATTESTATION_ATTR_MR_ID, CTLV_SCHEMA_UINT)
 CTLV_PUT_STRING(ctlv_attestation_mr_name, CTLV_ATTESTATION_ATTR_MR_NAME, CTLV_SCHEMA_STRING)
 CTLV_PUT_U64(ctlv_attestation_mr_hash_algo, CTLV_ATTESTATION_ATTR_MR_HASH_ALGO, CTLV_SCHEMA_UINT)
diff --git a/drivers/attestation/providers/sim.c b/drivers/attestation/providers/sim.c
index 7c35b1611f10..4a541462dc7e 100644
--- a/drivers/attestation/providers/sim.c
+++ b/drivers/attestation/providers/sim.c
@@ -179,6 +179,7 @@ static const struct attestation_evidence_caps attestation_sim_evidence_caps = {
 	.supports_mr_selection = true,
 	.supports_privlevel = true,
 	.supports_service_attestation = true,
+	.supports_object_accept = true,
 	.objects = attestation_sim_evidence_objects,
 	.objects_count = ARRAY_SIZE(attestation_sim_evidence_objects),
 };
@@ -570,7 +571,9 @@ attestation_sim_evidence_get(struct attestation *att,
 	return ret;
 }
 
-static int attestation_sim_evidence_accept(struct attestation *att)
+static int
+attestation_sim_evidence_accept(struct attestation *att,
+		const struct attestation_evidence_supported_object *object)
 {
 	struct attestation_sim *sim = attestation_sim_from_att(att);
 	int ret;
diff --git a/drivers/attestation/tests/core_kunit.c b/drivers/attestation/tests/core_kunit.c
index 08cb5eabee1b..898f5b34d32f 100644
--- a/drivers/attestation/tests/core_kunit.c
+++ b/drivers/attestation/tests/core_kunit.c
@@ -95,7 +95,9 @@ attestation_test_evidence_get(
 	return 0;
 }
 
-static int attestation_test_evidence_accept(struct attestation *att)
+static int
+attestation_test_evidence_accept(struct attestation *att,
+		const struct attestation_evidence_supported_object *object)
 {
 	return 0;
 }
diff --git a/include/linux/attestation.h b/include/linux/attestation.h
index 9813361ddd29..09ebd2af3a1e 100644
--- a/include/linux/attestation.h
+++ b/include/linux/attestation.h
@@ -154,6 +154,7 @@ struct attestation_evidence_supported_object {
  * @supports_mr_selection: requests may select MRs
  * @supports_privlevel: requests may select a privilege level
  * @supports_service_attestation: requests may identify a service
+ * @supports_object_accept: acceptance may select an object from its snapshot
  * @objects: supported evidence objects
  * @objects_count: number of objects
  */
@@ -164,6 +165,7 @@ struct attestation_evidence_caps {
 	bool supports_mr_selection;
 	bool supports_privlevel;
 	bool supports_service_attestation;
+	bool supports_object_accept;
 	const struct attestation_evidence_supported_object *objects;
 	size_t objects_count;
 };
@@ -235,7 +237,8 @@ struct attestation_evidence_result {
  * @evidence_object_supported: optionally restrict advertised and requested
  *	evidence objects per instance; called under the instance lock
  * @evidence_get: produce requested evidence
- * @evidence_accept: accept current evidence and enable secure operation
+ * @evidence_accept: accept evidence and enable secure operation; the optional
+ *		   object selector belongs to the referenced evidence snapshot
  * @evidence_accept_clear: clear a recorded acceptance
  * @mr_read: read one MR
  * @mr_extend: extend one MR
@@ -252,7 +255,8 @@ struct attestation_provider {
 	int (*evidence_get)(struct attestation *att,
 			    const struct attestation_evidence_request *request,
 			    struct attestation_evidence_result *result);
-	int (*evidence_accept)(struct attestation *att);
+	int (*evidence_accept)(struct attestation *att,
+		const struct attestation_evidence_supported_object *object);
 	void (*evidence_accept_clear)(struct attestation *att);
 	int (*mr_read)(struct attestation *att, unsigned int mr_id,
 		       const struct ctlv_cursor *mr_options,
diff --git a/include/uapi/linux/ctlv_attestation_gen.h b/include/uapi/linux/ctlv_attestation_gen.h
index 627c6f5f9377..f993def4fe57 100644
--- a/include/uapi/linux/ctlv_attestation_gen.h
+++ b/include/uapi/linux/ctlv_attestation_gen.h
@@ -106,6 +106,7 @@ enum _ctlv_attestation_evidence_caps_bit {
 	CTLV_ATTESTATION_EVIDENCE_CAPS_MR_SELECTION_BIT,
 	CTLV_ATTESTATION_EVIDENCE_CAPS_PRIVLEVEL_BIT,
 	CTLV_ATTESTATION_EVIDENCE_CAPS_SERVICE_BIT,
+	CTLV_ATTESTATION_EVIDENCE_CAPS_OBJECT_SELECTION_BIT,
 };
 
 #define CTLV_ATTESTATION_EVIDENCE_CAPS_EVIDENCE_ACCEPT \
@@ -115,11 +116,14 @@ enum _ctlv_attestation_evidence_caps_bit {
 #define CTLV_ATTESTATION_EVIDENCE_CAPS_PRIVLEVEL \
 	_BITULL(CTLV_ATTESTATION_EVIDENCE_CAPS_PRIVLEVEL_BIT)
 #define CTLV_ATTESTATION_EVIDENCE_CAPS_SERVICE _BITULL(CTLV_ATTESTATION_EVIDENCE_CAPS_SERVICE_BIT)
+#define CTLV_ATTESTATION_EVIDENCE_CAPS_OBJECT_SELECTION \
+	_BITULL(CTLV_ATTESTATION_EVIDENCE_CAPS_OBJECT_SELECTION_BIT)
 #define CTLV_ATTESTATION_EVIDENCE_CAPS_MASK \
 	(CTLV_ATTESTATION_EVIDENCE_CAPS_EVIDENCE_ACCEPT | \
 	 CTLV_ATTESTATION_EVIDENCE_CAPS_MR_SELECTION | \
 	 CTLV_ATTESTATION_EVIDENCE_CAPS_PRIVLEVEL | \
-	 CTLV_ATTESTATION_EVIDENCE_CAPS_SERVICE)
+	 CTLV_ATTESTATION_EVIDENCE_CAPS_SERVICE | \
+	 CTLV_ATTESTATION_EVIDENCE_CAPS_OBJECT_SELECTION)
 
 /* attr groups */
 enum _ctlv_attestation_group {
@@ -211,6 +215,7 @@ enum _ctlv_attestation_attr_evidence {
 	_CTLV_ATTESTATION_ATTR_EVIDENCE_SERVICE_GUID,
 	_CTLV_ATTESTATION_ATTR_EVIDENCE_SERVICE_MANIFEST_VERSION,
 	_CTLV_ATTESTATION_ATTR_EVIDENCE_OPTIONS,
+	_CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT,
 };
 
 #define CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE _CTLV_ATTESTATION_ATTR_EVIDENCE(CHALLENGE)
@@ -234,6 +239,7 @@ enum _ctlv_attestation_attr_evidence {
 #define CTLV_ATTESTATION_ATTR_EVIDENCE_SERVICE_MANIFEST_VERSION \
 	_CTLV_ATTESTATION_ATTR_EVIDENCE(SERVICE_MANIFEST_VERSION)
 #define CTLV_ATTESTATION_ATTR_EVIDENCE_OPTIONS _CTLV_ATTESTATION_ATTR_EVIDENCE(OPTIONS)
+#define CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT _CTLV_ATTESTATION_ATTR_EVIDENCE(ACCEPT_OBJECT)
 
 /* attrs of group mr */
 #define _CTLV_ATTESTATION_ATTR_MR(_attr) \
@@ -366,6 +372,7 @@ enum _ctlv_attestation_set {
 	CTLV_ATTESTATION_SET_MR_LOG_SELECTION,
 	CTLV_ATTESTATION_SET_MR_LOG_REQUEST,
 	CTLV_ATTESTATION_SET_MR_LOG_REPLY,
+	CTLV_ATTESTATION_SET_EVIDENCE_OBJECT_SELECTOR,
 };
 
 /* ops */
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
index a1223c4fd45e..795cf514c761 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
@@ -118,7 +118,7 @@ static const struct ctlv_node_schema device_get_reply_caps_evidence_optional_att
 		.kind = CTLV_SCHEMA_FLAGS,
 		.max_occurrences = 1,
 		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
-		.flags_mask = 15,
+		.flags_mask = 31,
 	},
 };
 
@@ -1003,6 +1003,39 @@ static const struct ctlv_node_schema mr_log_entry_appended_reply_node_schema = {
 	.attrs_count = 1,
 };
 
+/* evidence.accept-object, attrs */
+static const struct ctlv_node_schema evidence_accept_request_accept_object_attr_node_schemas[] = {
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
+};
+
+/* evidence.accept-object, optional attrs */
+static const struct ctlv_node_schema
+	evidence_accept_request_accept_object_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_INSTANCE,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
 /* root, attrs */
 static const struct ctlv_node_schema evidence_accept_request_attr_node_schemas[] = {
 	{
@@ -1023,12 +1056,27 @@ static const struct ctlv_node_schema evidence_accept_request_attr_node_schemas[]
 	},
 };
 
+/* root, optional attrs */
+static const struct ctlv_node_schema evidence_accept_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = evidence_accept_request_accept_object_attr_node_schemas,
+		.attrs_count = 2,
+		.optional_attrs = evidence_accept_request_accept_object_optional_attr_node_schemas,
+		.optional_attrs_count = 1,
+	},
+};
+
 static const struct ctlv_node_schema evidence_accept_request_node_schema = {
 	.attr_id = CTLV_ATTR_ROOT,
 	.kind = CTLV_SCHEMA_NEST,
 	.max_occurrences = 1,
 	.attrs = evidence_accept_request_attr_node_schemas,
 	.attrs_count = 2,
+	.optional_attrs = evidence_accept_request_optional_attr_node_schemas,
+	.optional_attrs_count = 1,
 };
 
 static const struct ctlv_node_schema evidence_accept_clear_request_node_schema = {
@@ -1488,7 +1536,7 @@ static const struct ctlv_op_spec ctlv_attestation_sim_op_specs[] = {
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
 		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
-		.request_max_len = 64,
+		.request_max_len = 280,
 		.request = &evidence_accept_request_node_schema,
 	},
 	{
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
index 2b6d4537466f..787edd7d8ce4 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
@@ -118,7 +118,7 @@ static const struct ctlv_node_schema device_get_reply_caps_evidence_optional_att
 		.kind = CTLV_SCHEMA_FLAGS,
 		.max_occurrences = 1,
 		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
-		.flags_mask = 15,
+		.flags_mask = 31,
 	},
 };
 
@@ -1019,6 +1019,39 @@ static const struct ctlv_node_schema mr_log_entry_appended_reply_node_schema = {
 	.attrs_count = 1,
 };
 
+/* evidence.accept-object, attrs */
+static const struct ctlv_node_schema evidence_accept_request_accept_object_attr_node_schemas[] = {
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
+};
+
+/* evidence.accept-object, optional attrs */
+static const struct ctlv_node_schema
+	evidence_accept_request_accept_object_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_INSTANCE,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
 /* root, attrs */
 static const struct ctlv_node_schema evidence_accept_request_attr_node_schemas[] = {
 	{
@@ -1039,12 +1072,27 @@ static const struct ctlv_node_schema evidence_accept_request_attr_node_schemas[]
 	},
 };
 
+/* root, optional attrs */
+static const struct ctlv_node_schema evidence_accept_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = evidence_accept_request_accept_object_attr_node_schemas,
+		.attrs_count = 2,
+		.optional_attrs = evidence_accept_request_accept_object_optional_attr_node_schemas,
+		.optional_attrs_count = 1,
+	},
+};
+
 static const struct ctlv_node_schema evidence_accept_request_node_schema = {
 	.attr_id = CTLV_ATTR_ROOT,
 	.kind = CTLV_SCHEMA_NEST,
 	.max_occurrences = 1,
 	.attrs = evidence_accept_request_attr_node_schemas,
 	.attrs_count = 2,
+	.optional_attrs = evidence_accept_request_optional_attr_node_schemas,
+	.optional_attrs_count = 1,
 };
 
 static const struct ctlv_node_schema evidence_accept_clear_request_node_schema = {
@@ -1504,7 +1552,7 @@ static const struct ctlv_op_spec ctlv_attestation_tdx_op_specs[] = {
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
 		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
-		.request_max_len = 64,
+		.request_max_len = 280,
 		.request = &evidence_accept_request_node_schema,
 	},
 	{
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
index 17756bf1afea..b278511f5776 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
@@ -118,7 +118,7 @@ static const struct ctlv_node_schema device_get_reply_caps_evidence_optional_att
 		.kind = CTLV_SCHEMA_FLAGS,
 		.max_occurrences = 1,
 		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
-		.flags_mask = 15,
+		.flags_mask = 31,
 	},
 };
 
@@ -989,6 +989,39 @@ static const struct ctlv_node_schema mr_log_entry_appended_reply_node_schema = {
 	.attrs_count = 1,
 };
 
+/* evidence.accept-object, attrs */
+static const struct ctlv_node_schema evidence_accept_request_accept_object_attr_node_schemas[] = {
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
+};
+
+/* evidence.accept-object, optional attrs */
+static const struct ctlv_node_schema
+	evidence_accept_request_accept_object_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_INSTANCE,
+		.kind = CTLV_SCHEMA_UINT,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
+		.min = 0,
+		.max = 0xffffffffULL,
+	},
+};
+
 /* root, attrs */
 static const struct ctlv_node_schema evidence_accept_request_attr_node_schemas[] = {
 	{
@@ -1009,12 +1042,27 @@ static const struct ctlv_node_schema evidence_accept_request_attr_node_schemas[]
 	},
 };
 
+/* root, optional attrs */
+static const struct ctlv_node_schema evidence_accept_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT,
+		.kind = CTLV_SCHEMA_NEST,
+		.max_occurrences = 1,
+		.attrs = evidence_accept_request_accept_object_attr_node_schemas,
+		.attrs_count = 2,
+		.optional_attrs = evidence_accept_request_accept_object_optional_attr_node_schemas,
+		.optional_attrs_count = 1,
+	},
+};
+
 static const struct ctlv_node_schema evidence_accept_request_node_schema = {
 	.attr_id = CTLV_ATTR_ROOT,
 	.kind = CTLV_SCHEMA_NEST,
 	.max_occurrences = 1,
 	.attrs = evidence_accept_request_attr_node_schemas,
 	.attrs_count = 2,
+	.optional_attrs = evidence_accept_request_optional_attr_node_schemas,
+	.optional_attrs_count = 1,
 };
 
 static const struct ctlv_node_schema evidence_accept_clear_request_node_schema = {
@@ -1474,7 +1522,7 @@ static const struct ctlv_op_spec ctlv_attestation_op_specs[] = {
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
 		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
-		.request_max_len = 64,
+		.request_max_len = 280,
 		.request = &evidence_accept_request_node_schema,
 	},
 	{
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h
index 67b8820b3efc..88d8ac5048d8 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h
+++ b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h
@@ -115,7 +115,7 @@ static inline int ctlv_attestation_mr_extend(struct ctlv_dev *dev, struct ctlv_m
 	return ctlv_action(dev, CTLV_ATTESTATION_OP_MR_EXTEND, request, reply, error);
 }
 
-#define CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_REQUEST_MAX_LEN 64
+#define CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_REQUEST_MAX_LEN 280
 
 static inline int ctlv_attestation_evidence_accept_request_new(struct ctlv_msg **request)
 {
@@ -373,6 +373,11 @@ static inline int ctlv_attestation_evidence_options_start(struct ctlv_msg *msg)
 	return ctlv_nest_start(msg, CTLV_ATTESTATION_ATTR_EVIDENCE_OPTIONS);
 }
 
+static inline int ctlv_attestation_evidence_accept_object_start(struct ctlv_msg *msg)
+{
+	return ctlv_nest_start(msg, CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT);
+}
+
 static inline int ctlv_attestation_mr_id_put(struct ctlv_msg *msg, __u64 value)
 {
 	return ctlv_put_u64(msg, CTLV_ATTESTATION_ATTR_MR_ID, value);
@@ -913,6 +918,17 @@ ctlv_attestation_evidence_options_get(const struct ctlv_attr *nest)
 	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_EVIDENCE_OPTIONS);
 }
 
+static inline bool ctlv_attestation_evidence_accept_object_present(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT);
+}
+
+static inline const struct ctlv_attr *
+ctlv_attestation_evidence_accept_object_get(const struct ctlv_attr *nest)
+{
+	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_EVIDENCE_ACCEPT_OBJECT);
+}
+
 static inline bool ctlv_attestation_mr_id_present(const struct ctlv_attr *nest)
 {
 	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_MR_ID);
-- 
2.43.0

