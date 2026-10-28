Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201222;
	b=V/JcmJ1IhqygnCwiIRvFebsRyU/nadSybCmSWdok2C4V652BW+GbWES6ylLkEKscCNMP
	 NZ78TmnGBSXN4TpMvlYFosvlSyU4UFTm9kbim/Mf8ESu57pLCERiccTHnoZf6QFmer3Zz
	 boWJn6n1yZ3amegAHdYxG+wQjxCZ1itHggFInXoKz/kgXUxO/C1AGrJ7q6KesoZOzgqln
	 Rv1TR4ePfzmMHKLZUvupqwrz4MfyWgq9QXmOnEYoyM8gOvczrvZfGy7w0QU3EI58q85gS
	 1W0BCwtVoLVTLMRIzfqKeIPpfSbfV01WWmaK4+tX4UQ6cmlAegyn0WywxUSS6HiYSkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TRxpEXUuN7gPpt3s5w1Tj/lUhtrcpCcaSbCchjk2ks8=;
	b=CWE5aukzayG2s/PaGFaYlPQjC1PJak7bjYkVUMLolnhGhrpmLwPN9e0B4/7LEpbegRH2
	 U9keS4OpnsgdxHaZplIua6fgYGTx8t8vsv6EXHJInFwl+jb3OuReTHnr+L6mjczFM4hAN
	 NSzYEgisCy6qP/J/7NEkhCX4LrdkTGc0gxFvzqV4sXg3yM160gmW6FWKEoDeLY+frurxp
	 DE731+T78FNcxTWzxL7hsssmQxfWgz03E9NQ6db+TugLaMjjjkAGub1UCfmzRCMRPrEfj
	 Fyznae8ig/QR/gI0jfr2JMmp8IE2qI+DCMwns7zR2SsjB8jBuebrC3KN6c4zRxvfOgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2Y3qePk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB5F606A31D;
	Wed, 28 Oct 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2Y3qePk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B171F01825;
	Wed, 28 Oct 2026 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201215;
	bh=TRxpEXUuN7gPpt3s5w1Tj/lUhtrcpCcaSbCchjk2ks8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2Y3qePkIWjAcvPQ4u3Nwv1vcJLv1h/88ootwvTArP+uEMHzVLiImyZ4wRIWgU/Vb
	 s6+15nnUfljKunLiOCwjst2maRx2gwrM4FKVHJnGY9R7dgfTrnHwmGHaW8081cR+MG
	 DAVG9pUyOo3Mr29ZRdgdLZmPEGV1pD3NVQtsNRo791OtsddV8jO6W2tZ9jEuakx0st
	 eRuBn/6TIzMvxsQcqO9b2DwpFGdDS7kt5c+vujFFkRoH+VA0cNmNIS29d6AQP2pgzz
	 eEZU7VbYM4h1/nGSzSCzg81LwDYh0GN0bEkamP41yHM1SvlOCoCPR6Z5xdJPvanyp1
	 iA1/sgWJCq9LQ==
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
Subject: [RFC PATCH v1 03/11] attestation: Enter secure operation when evidence is accepted
Date: Wed, 28 Oct 2026 20:56:10 +0530
Message-ID: <20261028152618.1356860-4-aneesh.kumar@kernel.org>
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

Use EVIDENCE_ACCEPT to enter secure operation after userspace has
checked the evidence. Check the referenced device and evidence
generations before calling the driver, and record acceptance on success.

Remove the separate DEVSEC_RUN command and callback.

Keep DEVSEC_STATE_GET so userspace can read both evidence acceptance and
device state. Clearing acceptance does not undo the device state change.
For example, with the following PCI/TSM patches:

  Operation              Evidence acceptance  TDISP state
  ---------------------  -------------------  -----------
  EVIDENCE_ACCEPT        Recorded             RUN
  EVIDENCE_ACCEPT_CLEAR  Cleared              RUN

After EVIDENCE_ACCEPT_CLEAR, DEVSEC_STATE_GET omits the accepted
evidence generation but still reports TDISP RUN.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ctlv/abi/ctlv-attestation.yaml  | 38 ++++-----
 .../ctlv/specs/ctlv-attestation.yaml          | 25 ------
 drivers/attestation/core/core.c               | 17 ----
 drivers/attestation/core/ctlv.c               | 45 +---------
 .../generated/ctlv_attestation_gen.c          | 29 ++-----
 .../generated/ctlv_attestation_gen.h          | 26 +-----
 drivers/attestation/providers/sim.c           | 35 ++------
 drivers/attestation/tests/core_kunit.c        | 19 +----
 include/linux/attestation.h                   |  5 +-
 include/uapi/linux/ctlv_attestation_gen.h     | 16 ----
 .../selftests/attestation/attestation_test.c  | 28 ++-----
 .../ctlv_attestation_sim_user_gen.c           | 83 +------------------
 .../ctlv_attestation_tdx_user_gen.c           | 83 +------------------
 .../attestation/ctlv_attestation_user_gen.c   | 83 +------------------
 .../attestation/ctlv_attestation_user_gen.h   | 52 +-----------
 15 files changed, 51 insertions(+), 533 deletions(-)

diff --git a/Documentation/ctlv/abi/ctlv-attestation.yaml b/Documentation/ctlv/abi/ctlv-attestation.yaml
index 31dbffa59416..0220c2e131d4 100644
--- a/Documentation/ctlv/abi/ctlv-attestation.yaml
+++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
@@ -22,7 +22,6 @@ flags:
   mr-device-caps: {read: 0, extend: 1, dynamic-topology: 2}
   mr-caps: {read: 0, extend: 1, removable: 2}
   mr-state-flags: {ima-active: 0}
-  devsec-caps: {run: 0}
   evidence-caps: {evidence-accept: 0, mr-selection: 1, privlevel: 2, service: 3}
 attr-groups:
   device:
@@ -47,10 +46,8 @@ attr-groups:
                        max-occurrences: 2}
       max-length: {id: 11, type: uint}
       evidence-flags: {id: 12, flags: evidence-caps}
-      devsec: {id: 13, type: nested}
-      devsec-flags: {id: 14, flags: devsec-caps}
-      blob-instance: {id: 15, type: uint, max: 4294967295}
-      hash-algo: {id: 16, type: uint, max: 20, max-occurrences: 21}
+      blob-instance: {id: 13, type: uint, max: 4294967295}
+      hash-algo: {id: 14, type: uint, max: 20, max-occurrences: 21}
   evidence:
     id: 3
     attrs:
@@ -138,18 +135,16 @@ attr-sets:
   device-state-event: {id: 20}
   mr-log-event: {id: 21}
   mr-log-ima: {id: 22}
-  devsec-cap: {id: 23}
-  evidence-generation-request: {id: 24}
-  devsec-state-reply: {id: 25}
-  devsec-run-reply: {id: 26}
-  evidence-state-event: {id: 27}
-  evidence-options: {id: 28, stub: true}
-  mr-options: {id: 29, stub: true}
-  evidence-mr-selection: {id: 30}
-  record-data: {id: 31}
-  mr-log-selection: {id: 32}
-  mr-log-request: {id: 33}
-  mr-log-reply: {id: 34}
+  evidence-generation-request: {id: 23}
+  devsec-state-reply: {id: 24}
+  evidence-state-event: {id: 25}
+  evidence-options: {id: 26, stub: true}
+  mr-options: {id: 27, stub: true}
+  evidence-mr-selection: {id: 28}
+  record-data: {id: 29}
+  mr-log-selection: {id: 30}
+  mr-log-request: {id: 31}
+  mr-log-reply: {id: 32}
 ops:
   device-get:
     abi: {id: 1, type: action, fd-access: read}
@@ -169,7 +164,6 @@ ops:
                         optional-attrs: [cap.blob-instance, cap.hash-algo]
                   optional-attrs: [cap.evidence-flags]
               - cap.mr: {attrs: [cap.mr-flags]}
-              - cap.devsec: {attrs: [cap.devsec-flags]}
         - device.info: {attrs: [device-info]}
   evidence-get:
     abi: {id: 2, type: action, availability: dynamic, optional: true}
@@ -256,17 +250,13 @@ ops:
       attrs: [device.generation]
       optional-attrs: [evidence.generation, evidence.accepted-generation,
                        devsec.tdisp-state, devsec.device-trust]
-  devsec-run:
-    abi: {id: 12, type: action, availability: dynamic, optional: true}
-    request: {attrs: [device.generation, evidence.generation]}
-    reply: {attrs: [device.generation]}
   evidence-state-changed:
-    abi: {id: 13, type: event}
+    abi: {id: 12, type: event}
     reply:
       attrs: [device.generation]
       optional-attrs: [evidence.generation, evidence.accepted-generation]
   mr-log-get:
-    abi: {id: 14, type: query, fd-access: read, optional: true}
+    abi: {id: 13, type: query, fd-access: read, optional: true}
     request:
       optional-attrs:
         - mr.selection: {attrs: [mr.id]}
diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
index 570a97b7538f..8494f716f9e9 100644
--- a/Documentation/ctlv/specs/ctlv-attestation.yaml
+++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
@@ -62,10 +62,6 @@ flags:
     values:
       - ima-active
 
-  - name: devsec-caps
-    values:
-      - run
-
   - name: evidence-caps
     values:
       - evidence-accept
@@ -115,10 +111,6 @@ attr-groups:
         type: uint
       - name: evidence-flags
         flags: evidence-caps
-      - name: devsec
-        attrs: devsec-cap
-      - name: devsec-flags
-        flags: devsec-caps
       - name: blob-instance
         type: uint
         max: 4294967295
@@ -306,7 +298,6 @@ attr-sets:
     optional-attrs:
       - cap.evidence
       - cap.mr
-      - cap.devsec
 
   - name: device-reply
     attrs:
@@ -429,9 +420,6 @@ attr-sets:
       - log.template-data
       - log.violation
 
-  - name: devsec-cap
-    attrs: cap.devsec-flags
-
   - name: evidence-generation-request
     attrs:
       - device.generation
@@ -445,9 +433,6 @@ attr-sets:
       - devsec.tdisp-state
       - devsec.device-trust
 
-  - name: devsec-run-reply
-    attrs: device.generation
-
   - name: evidence-state-event
     attrs: device.generation
     optional-attrs:
@@ -571,16 +556,6 @@ ops:
       attrs: devsec-state-reply
     suggested-reply-length: 1024
 
-  - name: devsec-run
-    type: action
-    fd-access: read-write
-    availability: dynamic
-    optional: true
-    request:
-      attrs: evidence-generation-request
-    reply:
-      attrs: devsec-run-reply
-
   - name: evidence-state-changed
     type: event
     reply:
diff --git a/drivers/attestation/core/core.c b/drivers/attestation/core/core.c
index 37d5d3233cf0..a1de19dcab7d 100644
--- a/drivers/attestation/core/core.c
+++ b/drivers/attestation/core/core.c
@@ -137,9 +137,6 @@ int attestation_provider_validate(const struct attestation_provider *provider)
 		if (ret)
 			return ret;
 	}
-	if (provider->devsec_run && (!provider->evidence_accept ||
-				     (!provider->tdisp_state_get && !provider->device_trust_get)))
-		return -EINVAL;
 	return 0;
 }
 
@@ -478,9 +475,6 @@ static unsigned int attestation_provider_features(const struct attestation_provi
 	if (provider->device_trust_get)
 		features |= ATTESTATION_FEATURE_DEVICE_TRUST;
 
-	if (provider->devsec_run)
-		features |= ATTESTATION_FEATURE_DEVSEC_RUN;
-
 	return features;
 }
 
@@ -498,10 +492,6 @@ int attestation_features_set_locked(struct attestation *att, unsigned int featur
 	    !(features & ATTESTATION_FEATURE_EVIDENCE))
 		return -EINVAL;
 
-	if ((features & ATTESTATION_FEATURE_DEVSEC_RUN) &&
-	    (!(features & ATTESTATION_FEATURE_EVIDENCE_ACCEPT) || !(features & state)))
-		return -EINVAL;
-
 	att->features = features;
 	if (supported & ATTESTATION_FEATURE_EVIDENCE)
 		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_EVIDENCE_GET,
@@ -520,9 +510,6 @@ int attestation_features_set_locked(struct attestation *att, unsigned int featur
 		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET,
 					 !(features & state));
 
-	if (supported & ATTESTATION_FEATURE_DEVSEC_RUN)
-		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_DEVSEC_RUN,
-					 !(features & ATTESTATION_FEATURE_DEVSEC_RUN));
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(attestation_features_set_locked, "ATTESTATION");
@@ -562,10 +549,6 @@ void attestation_provide_ops(struct attestation *att)
 		ctlv_attestation_devsec_state_get_provide(ctlvdev);
 		ctlv_attestation_devsec_state_get_enable(ctlvdev);
 	}
-	if (provider->devsec_run) {
-		ctlv_attestation_devsec_run_provide(ctlvdev);
-		ctlv_attestation_devsec_run_enable(ctlvdev);
-	}
 }
 
 int attestation_core_init(struct attestation *att, struct ctlv_device *ctlvdev,
diff --git a/drivers/attestation/core/ctlv.c b/drivers/attestation/core/ctlv.c
index baf9c39f2658..7f755b7aaf51 100644
--- a/drivers/attestation/core/ctlv.c
+++ b/drivers/attestation/core/ctlv.c
@@ -128,13 +128,6 @@ static int attestation_device_caps_put(struct attestation *att, struct ctlv_curs
 		ok &= ctlv_attestation_cap_mr_flags_put(&group, flags);
 		ctlv_nest_end(&group);
 	}
-	if (att->features & ATTESTATION_FEATURE_DEVSEC_RUN) {
-		if (!ctlv_attestation_cap_devsec_start(&caps_nest, &group))
-			return -EMSGSIZE;
-		ok &= ctlv_attestation_cap_devsec_flags_put(&group,
-							    CTLV_ATTESTATION_DEVSEC_CAPS_RUN);
-		ctlv_nest_end(&group);
-	}
 	ctlv_nest_end(&caps_nest);
 	return ok ? 0 : -EMSGSIZE;
 }
@@ -584,6 +577,7 @@ int ctlv_attestation_evidence_accept_action(void *priv, struct ctlv_op_ctx *ctx,
 	ret = attestation_events_prepare(att, &events, false, true, false);
 	if (ret)
 		return ret;
+	/* Acceptance authorizes this snapshot without retiring its generation binding. */
 	ret = att->provider->evidence_accept(att);
 	if (!ret) {
 		att->verdict_recorded = true;
@@ -960,40 +954,3 @@ int ctlv_attestation_devsec_state_get_query(void *priv, struct ctlv_op_ctx *ctx,
 		return -EMSGSIZE;
 	return ctlv_op_query_done(ctx, version);
 }
-
-int ctlv_attestation_devsec_run_action(void *priv, struct ctlv_op_ctx *ctx,
-				       const struct ctlv_cursor *request, struct ctlv_cursor *reply)
-{
-	struct attestation_event_batch events = {};
-	struct attestation *att = priv;
-	u64 device, evidence;
-	int ret;
-
-	device = ctlv_attestation_devsec_run_device_generation_get(request);
-	evidence = ctlv_attestation_devsec_run_evidence_generation_get(request);
-	if (device > UINT_MAX || evidence > UINT_MAX)
-		return -ESTALE;
-	if (!att->verdict_recorded || att->accepted_device_generation != device ||
-	    att->accepted_evidence_generation != evidence)
-		return -ESTALE;
-	ret = attestation_evidence_validate(att, device, evidence);
-	if (ret)
-		return ret;
-	ret = attestation_preflight(att, true, false, false);
-	if (ret)
-		return ret;
-	ret = attestation_events_prepare(att, &events, true, true, false);
-	if (ret)
-		return ret;
-	ret = att->provider->devsec_run(att);
-	if (ret)
-		goto out;
-	attestation_device_changed(att);
-	attestation_device_event_emit(&events, att->device_generation);
-	attestation_evidence_event_emit(&events, att);
-	if (!ctlv_attestation_device_generation_put(reply, att->device_generation))
-		ret = -EMSGSIZE;
-out:
-	attestation_events_abort(&events);
-	return ret;
-}
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.c b/drivers/attestation/generated/ctlv_attestation_gen.c
index 5882dd2c93a7..4afd0433e26f 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.c
+++ b/drivers/attestation/generated/ctlv_attestation_gen.c
@@ -23,21 +23,18 @@ static const struct ctlv_node_schema device_get_request_node_schemas[] = {
 static const struct ctlv_node_schema device_get_reply_node_schemas[] = {
 	CTLV_NODE_SCHEMA_ROOT(1, 3, 3),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 1, 0, U32_MAX),
-	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_DEVICE_CAPS, 1, 4, 3, 0),
+	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_DEVICE_CAPS, 1, 4, 2, 0),
 	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_DEVICE_INFO, 1, 0, 0, 0),
-	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_EVIDENCE, 1, 7, 5, 4),
-	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_MR, 1, 12, 1, 1),
-	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_DEVSEC, 1, 13, 1, 1),
+	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_EVIDENCE, 1, 6, 5, 4),
+	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_MR, 1, 11, 1, 1),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH, 1, 0, U64_MAX),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH, 1, 0, U64_MAX),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH, 1, 0, U64_MAX),
-	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_OBJECT, 16, 14, 6, 4),
+	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_CAP_OBJECT, 16, 12, 6, 4),
 	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_CAP_EVIDENCE_FLAGS, 1,
 			       CTLV_ATTESTATION_EVIDENCE_CAPS_MASK),
 	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS, 1,
 			       CTLV_ATTESTATION_MR_DEVICE_CAPS_MASK),
-	CTLV_NODE_SCHEMA_FLAGS(CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS, 1,
-			       CTLV_ATTESTATION_DEVSEC_CAPS_MASK),
 	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS, 1, 9),
 	CTLV_NODE_SCHEMA_STRING(CTLV_ATTESTATION_ATTR_CAP_FORMAT, 1, 1, 128),
 	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION, 2, 2),
@@ -218,17 +215,6 @@ static const struct ctlv_node_schema devsec_state_get_reply_node_schemas[] = {
 	CTLV_NODE_SCHEMA_ENUM(CTLV_ATTESTATION_ATTR_DEVSEC_DEVICE_TRUST, 1, 5),
 };
 
-static const struct ctlv_node_schema devsec_run_request_node_schemas[] = {
-	CTLV_NODE_SCHEMA_ROOT(1, 2, 2),
-	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 1, 0, U32_MAX),
-	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION, 1, 0, U32_MAX),
-};
-
-static const struct ctlv_node_schema devsec_run_reply_node_schemas[] = {
-	CTLV_NODE_SCHEMA_ROOT(1, 1, 1),
-	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 1, 0, U32_MAX),
-};
-
 static const struct ctlv_node_schema evidence_state_changed_reply_node_schemas[] = {
 	CTLV_NODE_SCHEMA_ROOT(1, 3, 1),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 1, 0, U32_MAX),
@@ -273,7 +259,7 @@ static const struct ctlv_node_schema mr_log_get_reply_node_schemas[] = {
 /* The ops this family declares, in declaration order. */
 const struct ctlv_op_schema ctlv_attestation_op_schemas[] = {
 	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_DEVICE_GET, CTLV_OP_FD_ACCESS_READ,
-			      CTLV_OP_AVAILABILITY_FIXED, 16, 12936,
+			      CTLV_OP_AVAILABILITY_FIXED, 16, 12896,
 			      CTLV_SCHEMA_TREE(device_get_request),
 			      CTLV_SCHEMA_TREE_STUBS(device_get_reply)),
 	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_EVIDENCE_GET, CTLV_OP_FD_ACCESS_READ_WRITE,
@@ -311,10 +297,6 @@ const struct ctlv_op_schema ctlv_attestation_op_schemas[] = {
 			     CTLV_OP_AVAILABILITY_DYNAMIC, 16, 40, 1024,
 			     CTLV_SCHEMA_TREE(devsec_state_get_request),
 			     CTLV_SCHEMA_TREE(devsec_state_get_reply), .optional = true),
-	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_DEVSEC_RUN, CTLV_OP_FD_ACCESS_READ_WRITE,
-			      CTLV_OP_AVAILABILITY_DYNAMIC, 64, 40,
-			      CTLV_SCHEMA_TREE(devsec_run_request),
-			      CTLV_SCHEMA_TREE(devsec_run_reply), .optional = true),
 	CTLV_OP_SCHEMA_EVENT(CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED, 112,
 			     CTLV_SCHEMA_TREE(evidence_state_changed_reply)),
 	CTLV_OP_SCHEMA_QUERY(CTLV_ATTESTATION_OP_MR_LOG_GET, CTLV_OP_FD_ACCESS_READ,
@@ -351,7 +333,6 @@ static const struct ctlv_op ctlv_attestation_ops[] = {
 	CTLV_OP_ACTION(ctlv_attestation_evidence_accept),
 	CTLV_OP_ACTION(ctlv_attestation_evidence_accept_clear),
 	CTLV_OP_QUERY(ctlv_attestation_devsec_state_get),
-	CTLV_OP_ACTION(ctlv_attestation_devsec_run),
 	CTLV_OP_QUERY(ctlv_attestation_mr_log_get),
 };
 
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.h b/drivers/attestation/generated/ctlv_attestation_gen.h
index a1f125690005..12716a7fa7af 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.h
+++ b/drivers/attestation/generated/ctlv_attestation_gen.h
@@ -43,9 +43,6 @@ int ctlv_attestation_evidence_accept_clear_action(void *priv, struct ctlv_op_ctx
 int ctlv_attestation_devsec_state_get_query(void *priv, struct ctlv_op_ctx *ctx,
 					    const struct ctlv_cursor *request,
 					    struct ctlv_cursor *reply);
-int ctlv_attestation_devsec_run_action(void *priv, struct ctlv_op_ctx *ctx,
-				       const struct ctlv_cursor *request,
-				       struct ctlv_cursor *reply);
 int ctlv_attestation_mr_log_get_query(void *priv, struct ctlv_op_ctx *ctx,
 				      const struct ctlv_cursor *request, struct ctlv_cursor *reply);
 
@@ -81,9 +78,6 @@ CTLV_OP_DISABLE(ctlv_attestation_evidence_accept_clear, CTLV_ATTESTATION_OP_EVID
 CTLV_OP_PROVIDE(ctlv_attestation_devsec_state_get, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET)
 CTLV_OP_ENABLE(ctlv_attestation_devsec_state_get, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET)
 CTLV_OP_DISABLE(ctlv_attestation_devsec_state_get, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET)
-CTLV_OP_PROVIDE(ctlv_attestation_devsec_run, CTLV_ATTESTATION_OP_DEVSEC_RUN)
-CTLV_OP_ENABLE(ctlv_attestation_devsec_run, CTLV_ATTESTATION_OP_DEVSEC_RUN)
-CTLV_OP_DISABLE(ctlv_attestation_devsec_run, CTLV_ATTESTATION_OP_DEVSEC_RUN)
 CTLV_OP_PROVIDE(ctlv_attestation_mr_log_get, CTLV_ATTESTATION_OP_MR_LOG_GET)
 
 /* Reading a validated message. A blob has a resolver instead of a getter. */
@@ -231,29 +225,20 @@ CTLV_IN_REF(ctlv_attestation_evidence_accept_evidence_generation,
 	    1, CTLV_SCHEMA_UINT)
 CTLV_IN_HAS(ctlv_attestation_evidence_accept_evidence_generation)
 CTLV_IN_U64(ctlv_attestation_evidence_accept_evidence_generation)
-CTLV_IN_REF(ctlv_attestation_devsec_run_device_generation, &ctlv_attestation_op_schemas[11].request,
-	    CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 0, 0, CTLV_SCHEMA_UINT)
-CTLV_IN_HAS(ctlv_attestation_devsec_run_device_generation)
-CTLV_IN_U64(ctlv_attestation_devsec_run_device_generation)
-CTLV_IN_REF(ctlv_attestation_devsec_run_evidence_generation,
-	    &ctlv_attestation_op_schemas[11].request, CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION, 0,
-	    1, CTLV_SCHEMA_UINT)
-CTLV_IN_HAS(ctlv_attestation_devsec_run_evidence_generation)
-CTLV_IN_U64(ctlv_attestation_devsec_run_evidence_generation)
-CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_selection, &ctlv_attestation_op_schemas[13].request,
+CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_selection, &ctlv_attestation_op_schemas[12].request,
 	    CTLV_ATTESTATION_ATTR_MR_SELECTION, 0, 0, CTLV_SCHEMA_NEST)
 #define ctlv_attestation_mr_log_get_mr_selection_for_each(_attr, _nest) \
 	CTLV_IN_FOR_EACH(ctlv_attestation_mr_log_get_mr_selection, _attr, _nest)
 CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_start_generation,
-	    &ctlv_attestation_op_schemas[13].request, CTLV_ATTESTATION_ATTR_MR_START_GENERATION, 0,
+	    &ctlv_attestation_op_schemas[12].request, CTLV_ATTESTATION_ATTR_MR_START_GENERATION, 0,
 	    1, CTLV_SCHEMA_UINT)
 CTLV_IN_HAS(ctlv_attestation_mr_log_get_mr_start_generation)
 CTLV_IN_U64(ctlv_attestation_mr_log_get_mr_start_generation)
-CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_end_generation, &ctlv_attestation_op_schemas[13].request,
+CTLV_IN_REF(ctlv_attestation_mr_log_get_mr_end_generation, &ctlv_attestation_op_schemas[12].request,
 	    CTLV_ATTESTATION_ATTR_MR_END_GENERATION, 0, 2, CTLV_SCHEMA_UINT)
 CTLV_IN_HAS(ctlv_attestation_mr_log_get_mr_end_generation)
 CTLV_IN_U64(ctlv_attestation_mr_log_get_mr_end_generation)
-CTLV_IN_REF(ctlv_attestation_mr_log_get_selection_mr_id, &ctlv_attestation_op_schemas[13].request,
+CTLV_IN_REF(ctlv_attestation_mr_log_get_selection_mr_id, &ctlv_attestation_op_schemas[12].request,
 	    CTLV_ATTESTATION_ATTR_MR_ID, 1, 0, CTLV_SCHEMA_UINT)
 CTLV_IN_HAS(ctlv_attestation_mr_log_get_selection_mr_id)
 CTLV_IN_U64(ctlv_attestation_mr_log_get_selection_mr_id)
@@ -282,9 +267,6 @@ CTLV_PUT_U64(ctlv_attestation_cap_max_length, CTLV_ATTESTATION_ATTR_CAP_MAX_LENG
 	     CTLV_SCHEMA_UINT)
 CTLV_PUT_U64(ctlv_attestation_cap_evidence_flags, CTLV_ATTESTATION_ATTR_CAP_EVIDENCE_FLAGS,
 	     CTLV_SCHEMA_FLAGS)
-CTLV_NEST_START(ctlv_attestation_cap_devsec, CTLV_ATTESTATION_ATTR_CAP_DEVSEC, CTLV_SCHEMA_NEST)
-CTLV_PUT_U64(ctlv_attestation_cap_devsec_flags, CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS,
-	     CTLV_SCHEMA_FLAGS)
 CTLV_PUT_U64(ctlv_attestation_cap_blob_instance, CTLV_ATTESTATION_ATTR_CAP_BLOB_INSTANCE,
 	     CTLV_SCHEMA_UINT)
 CTLV_PUT_U64(ctlv_attestation_cap_hash_algo, CTLV_ATTESTATION_ATTR_CAP_HASH_ALGO, CTLV_SCHEMA_UINT)
diff --git a/drivers/attestation/providers/sim.c b/drivers/attestation/providers/sim.c
index 5cf312285e85..7c35b1611f10 100644
--- a/drivers/attestation/providers/sim.c
+++ b/drivers/attestation/providers/sim.c
@@ -33,7 +33,6 @@ enum attestation_sim_callback {
 	ATTESTATION_SIM_CB_MR_EXTEND,
 	ATTESTATION_SIM_CB_TDISP_STATE_GET,
 	ATTESTATION_SIM_CB_DEVICE_TRUST_GET,
-	ATTESTATION_SIM_CB_DEVSEC_RUN,
 	ATTESTATION_SIM_CB_COUNT,
 };
 
@@ -55,7 +54,6 @@ struct attestation_sim {
 	struct attestation_sim_mr fixed[2];
 	enum attestation_tdisp_state tdisp_state;
 	enum attestation_device_trust_state trust_state;
-	bool pending_verdict;
 	bool notification_pending;
 };
 
@@ -196,7 +194,6 @@ static const char * const attestation_sim_callback_names[] = {
 	[ATTESTATION_SIM_CB_MR_EXTEND] = "mr_extend",
 	[ATTESTATION_SIM_CB_TDISP_STATE_GET] = "tdisp_state_get",
 	[ATTESTATION_SIM_CB_DEVICE_TRUST_GET] = "device_trust_get",
-	[ATTESTATION_SIM_CB_DEVSEC_RUN] = "devsec_run",
 };
 
 static enum attestation_sim_callback
@@ -585,16 +582,16 @@ static int attestation_sim_evidence_accept(struct attestation *att)
 	guard(mutex)(&sim->hardware_lock);
 	if (sim->notification_pending)
 		return -EAGAIN;
-	sim->pending_verdict = true;
+	if (sim->tdisp_state != ATTESTATION_TDISP_STATE_LOCKED &&
+	    sim->tdisp_state != ATTESTATION_TDISP_STATE_RUN)
+		return -EACCES;
+	sim->tdisp_state = ATTESTATION_TDISP_STATE_RUN;
 	return 0;
 }
 
 static void attestation_sim_evidence_accept_clear(struct attestation *att)
 {
-	struct attestation_sim *sim = attestation_sim_from_att(att);
-
-	guard(mutex)(&sim->hardware_lock);
-	sim->pending_verdict = false;
+	/* The common core owns the verdict; clearing it does not leave RUN. */
 }
 
 static int
@@ -633,26 +630,6 @@ attestation_sim_device_trust_get(
 	return 0;
 }
 
-static int attestation_sim_devsec_run(struct attestation *att)
-{
-	struct attestation_sim *sim = attestation_sim_from_att(att);
-	int ret;
-
-	ret = attestation_sim_callback_enter(
-		sim, ATTESTATION_SIM_CB_DEVSEC_RUN);
-	if (ret)
-		return ret;
-	guard(mutex)(&sim->hardware_lock);
-	if (sim->notification_pending)
-		return -EAGAIN;
-	if (sim->tdisp_state != ATTESTATION_TDISP_STATE_LOCKED ||
-	    !sim->pending_verdict)
-		return -EACCES;
-	sim->tdisp_state = ATTESTATION_TDISP_STATE_RUN;
-	sim->pending_verdict = false;
-	return 0;
-}
-
 static const struct attestation_provider attestation_sim_provider = {
 	.evidence_get = attestation_sim_evidence_get,
 	.evidence_accept = attestation_sim_evidence_accept,
@@ -661,7 +638,6 @@ static const struct attestation_provider attestation_sim_provider = {
 	.mr_extend = attestation_sim_mr_extend,
 	.tdisp_state_get = attestation_sim_tdisp_state_get,
 	.device_trust_get = attestation_sim_device_trust_get,
-	.devsec_run = attestation_sim_devsec_run,
 	.evidence_caps = &attestation_sim_evidence_caps,
 	.mr_caps = &attestation_sim_mr_caps,
 	.mrs = attestation_sim_mrs,
@@ -937,7 +913,6 @@ static ssize_t attestation_sim_state_write(struct file *file,
 		fixture->sim->notification_pending = true;
 		fixture->sim->tdisp_state = tdisp;
 		fixture->sim->trust_state = trust;
-		fixture->sim->pending_verdict = false;
 	}
 	att = ctlv_priv_parent(fixture->sim);
 	attestation_state_changed(att);
diff --git a/drivers/attestation/tests/core_kunit.c b/drivers/attestation/tests/core_kunit.c
index 7e4710370cfe..08cb5eabee1b 100644
--- a/drivers/attestation/tests/core_kunit.c
+++ b/drivers/attestation/tests/core_kunit.c
@@ -231,7 +231,7 @@ static void attestation_test_instance_features(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, fixture->att->features, features);
 	/* A child cannot enable a callback that its provider did not supply. */
 	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att,
-			features | ATTESTATION_FEATURE_DEVSEC_RUN), -EINVAL);
+			features | ATTESTATION_FEATURE_TDISP_STATE), -EINVAL);
 	KUNIT_EXPECT_EQ(test, fixture->att->features, features);
 	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att, 0), 0);
 	KUNIT_EXPECT_EQ(test, fixture->att->features, 0U);
@@ -250,36 +250,21 @@ static int attestation_test_tdisp_state(struct attestation *att,
 	return 0;
 }
 
-static int attestation_test_run(struct attestation *att)
-{
-	return 0;
-}
-
 static void attestation_test_secure_features(struct kunit *test)
 {
 	struct attestation_test *fixture = test->priv;
 	unsigned int evidence = ATTESTATION_FEATURE_EVIDENCE |
 				ATTESTATION_FEATURE_EVIDENCE_ACCEPT;
 	unsigned int state = ATTESTATION_FEATURE_TDISP_STATE;
-	unsigned int run = ATTESTATION_FEATURE_DEVSEC_RUN;
 
 	attestation_test_provider_init(fixture);
 	fixture->provider.tdisp_state_get = attestation_test_tdisp_state;
-	fixture->provider.devsec_run = attestation_test_run;
 	KUNIT_ASSERT_EQ(test, attestation_test_create_provider(
 				test, fixture, "attestation-secure-features"), 0);
-	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence | state | run);
-	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att, run), -EINVAL);
-	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att,
-			evidence | run), -EINVAL);
-	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att,
-			state | run), -EINVAL);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence | state);
 	/* Unlocked, locked, RUN, and host verdict-only capability sets. */
 	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att, state), 0);
 	KUNIT_EXPECT_EQ(test, fixture->att->features, state);
-	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att,
-			evidence | state | run), 0);
-	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence | state | run);
 	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att,
 			evidence | state), 0);
 	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence | state);
diff --git a/include/linux/attestation.h b/include/linux/attestation.h
index 364ab5029277..9813361ddd29 100644
--- a/include/linux/attestation.h
+++ b/include/linux/attestation.h
@@ -20,7 +20,6 @@ enum attestation_feature {
 	ATTESTATION_FEATURE_EVIDENCE_ACCEPT = 1U << 1,
 	ATTESTATION_FEATURE_TDISP_STATE = 1U << 2,
 	ATTESTATION_FEATURE_DEVICE_TRUST = 1U << 3,
-	ATTESTATION_FEATURE_DEVSEC_RUN = 1U << 4,
 };
 
 enum attestation_evidence_representation {
@@ -236,13 +235,12 @@ struct attestation_evidence_result {
  * @evidence_object_supported: optionally restrict advertised and requested
  *	evidence objects per instance; called under the instance lock
  * @evidence_get: produce requested evidence
- * @evidence_accept: record acceptance of the current evidence
+ * @evidence_accept: accept current evidence and enable secure operation
  * @evidence_accept_clear: clear a recorded acceptance
  * @mr_read: read one MR
  * @mr_extend: extend one MR
  * @tdisp_state_get: get the TDISP state
  * @device_trust_get: get the provider trust state
- * @devsec_run: enter the provider's secure state
  * @evidence_caps: evidence capabilities, or NULL
  * @mr_caps: MR capabilities, or NULL
  * @mrs: fixed MR properties
@@ -266,7 +264,6 @@ struct attestation_provider {
 			       enum attestation_tdisp_state *state);
 	int (*device_trust_get)(struct attestation *att,
 				enum attestation_device_trust_state *trust);
-	int (*devsec_run)(struct attestation *att);
 	const struct attestation_evidence_caps *evidence_caps;
 	const struct attestation_mr_caps *mr_caps;
 	const struct attestation_mr_props *mrs;
diff --git a/include/uapi/linux/ctlv_attestation_gen.h b/include/uapi/linux/ctlv_attestation_gen.h
index 2921bea50151..627c6f5f9377 100644
--- a/include/uapi/linux/ctlv_attestation_gen.h
+++ b/include/uapi/linux/ctlv_attestation_gen.h
@@ -100,14 +100,6 @@ enum _ctlv_attestation_mr_state_flags_bit {
 	_BITULL(CTLV_ATTESTATION_MR_STATE_FLAGS_IMA_ACTIVE_BIT)
 #define CTLV_ATTESTATION_MR_STATE_FLAGS_MASK CTLV_ATTESTATION_MR_STATE_FLAGS_IMA_ACTIVE
 
-/* flags devsec-caps */
-enum _ctlv_attestation_devsec_caps_bit {
-	CTLV_ATTESTATION_DEVSEC_CAPS_RUN_BIT,
-};
-
-#define CTLV_ATTESTATION_DEVSEC_CAPS_RUN _BITULL(CTLV_ATTESTATION_DEVSEC_CAPS_RUN_BIT)
-#define CTLV_ATTESTATION_DEVSEC_CAPS_MASK CTLV_ATTESTATION_DEVSEC_CAPS_RUN
-
 /* flags evidence-caps */
 enum _ctlv_attestation_evidence_caps_bit {
 	CTLV_ATTESTATION_EVIDENCE_CAPS_EVIDENCE_ACCEPT_BIT,
@@ -174,8 +166,6 @@ enum _ctlv_attestation_attr_cap {
 	_CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION,
 	_CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH,
 	_CTLV_ATTESTATION_ATTR_CAP_EVIDENCE_FLAGS,
-	_CTLV_ATTESTATION_ATTR_CAP_DEVSEC,
-	_CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS,
 	_CTLV_ATTESTATION_ATTR_CAP_BLOB_INSTANCE,
 	_CTLV_ATTESTATION_ATTR_CAP_HASH_ALGO,
 };
@@ -195,8 +185,6 @@ enum _ctlv_attestation_attr_cap {
 #define CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION _CTLV_ATTESTATION_ATTR_CAP(REPRESENTATION)
 #define CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH _CTLV_ATTESTATION_ATTR_CAP(MAX_LENGTH)
 #define CTLV_ATTESTATION_ATTR_CAP_EVIDENCE_FLAGS _CTLV_ATTESTATION_ATTR_CAP(EVIDENCE_FLAGS)
-#define CTLV_ATTESTATION_ATTR_CAP_DEVSEC _CTLV_ATTESTATION_ATTR_CAP(DEVSEC)
-#define CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS _CTLV_ATTESTATION_ATTR_CAP(DEVSEC_FLAGS)
 #define CTLV_ATTESTATION_ATTR_CAP_BLOB_INSTANCE _CTLV_ATTESTATION_ATTR_CAP(BLOB_INSTANCE)
 #define CTLV_ATTESTATION_ATTR_CAP_HASH_ALGO _CTLV_ATTESTATION_ATTR_CAP(HASH_ALGO)
 
@@ -368,10 +356,8 @@ enum _ctlv_attestation_set {
 	CTLV_ATTESTATION_SET_DEVICE_STATE_EVENT,
 	CTLV_ATTESTATION_SET_MR_LOG_EVENT,
 	CTLV_ATTESTATION_SET_MR_LOG_IMA,
-	CTLV_ATTESTATION_SET_DEVSEC_CAP,
 	CTLV_ATTESTATION_SET_EVIDENCE_GENERATION_REQUEST,
 	CTLV_ATTESTATION_SET_DEVSEC_STATE_REPLY,
-	CTLV_ATTESTATION_SET_DEVSEC_RUN_REPLY,
 	CTLV_ATTESTATION_SET_EVIDENCE_STATE_EVENT,
 	CTLV_ATTESTATION_SET_EVIDENCE_OPTIONS,
 	CTLV_ATTESTATION_SET_MR_OPTIONS,
@@ -395,7 +381,6 @@ enum _ctlv_attestation_op {
 	_CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT,
 	_CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
 	_CTLV_ATTESTATION_OP_DEVSEC_STATE_GET,
-	_CTLV_ATTESTATION_OP_DEVSEC_RUN,
 	_CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED,
 	_CTLV_ATTESTATION_OP_MR_LOG_GET,
 };
@@ -412,7 +397,6 @@ enum _ctlv_attestation_op {
 #define CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT _CTLV_ATTESTATION_OP(EVIDENCE_ACCEPT)
 #define CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR _CTLV_ATTESTATION_OP(EVIDENCE_ACCEPT_CLEAR)
 #define CTLV_ATTESTATION_OP_DEVSEC_STATE_GET _CTLV_ATTESTATION_OP(DEVSEC_STATE_GET)
-#define CTLV_ATTESTATION_OP_DEVSEC_RUN _CTLV_ATTESTATION_OP(DEVSEC_RUN)
 #define CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED _CTLV_ATTESTATION_OP(EVIDENCE_STATE_CHANGED)
 #define CTLV_ATTESTATION_OP_MR_LOG_GET _CTLV_ATTESTATION_OP(MR_LOG_GET)
 
diff --git a/tools/testing/selftests/attestation/attestation_test.c b/tools/testing/selftests/attestation/attestation_test.c
index 5f1caaac859e..bd831b0ef14f 100644
--- a/tools/testing/selftests/attestation/attestation_test.c
+++ b/tools/testing/selftests/attestation/attestation_test.c
@@ -154,7 +154,7 @@ FIXTURE_TEARDOWN(attestation)
 
 TEST_F(attestation, discovery_and_caps)
 {
-	const struct ctlv_attr *caps, *evidence, *mr, *devsec, *info;
+	const struct ctlv_attr *caps, *evidence, *mr, *info;
 	struct ctlv_reply *reply;
 	const char *name = NULL;
 	__u64 generation = 1;
@@ -175,10 +175,8 @@ TEST_F(attestation, discovery_and_caps)
 	ASSERT_NE(NULL, caps);
 	evidence = ctlv_attestation_cap_evidence_get(caps);
 	mr = ctlv_attestation_cap_mr_get(caps);
-	devsec = ctlv_attestation_cap_devsec_get(caps);
 	ASSERT_NE(NULL, evidence);
 	ASSERT_NE(NULL, mr);
-	ASSERT_NE(NULL, devsec);
 	EXPECT_TRUE(ctlv_attestation_cap_evidence_flags_get(evidence, &flags,
 							    &unknown));
 	EXPECT_EQ(0, unknown);
@@ -526,6 +524,7 @@ TEST_F(attestation, evidence_verdict_and_run)
 		unsigned char data[EVIDENCE_MAX];
 	} output;
 	struct ctlv_reply *reply;
+	const struct ctlv_attr *root;
 	struct ctlv_msg *request;
 	const __u64 subscriptions[] = {
 		CTLV_ATTESTATION_OP_DEVICE_STATE_CHANGED,
@@ -557,6 +556,13 @@ TEST_F(attestation, evidence_verdict_and_run)
 	expect_event(_metadata, self->dev,
 		     CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED);
 
+	ASSERT_EQ(0, ctlv_attestation_devsec_state_get(self->dev, NULL, &reply, &self->error));
+	root = ctlv_reply_root(reply);
+	EXPECT_TRUE(ctlv_attestation_devsec_tdisp_state_get(root, &state, &known));
+	EXPECT_TRUE(known);
+	EXPECT_EQ(CTLV_ATTESTATION_TDISP_STATE_RUN, state);
+	ctlv_reply_free(reply);
+
 	ASSERT_EQ(0,
 		  ctlv_attestation_evidence_accept_clear_request_new(&request));
 	ASSERT_EQ(0, ctlv_attestation_evidence_accept_clear(
@@ -569,22 +575,6 @@ TEST_F(attestation, evidence_verdict_and_run)
 	expect_event(_metadata, self->dev,
 		     CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED);
 
-	ASSERT_EQ(0, ctlv_attestation_devsec_run_request_new(&request));
-	ctlv_attestation_device_generation_put(request, device_generation);
-	ctlv_attestation_evidence_generation_put(
-		request, evidence_generation);
-	ASSERT_EQ(0, ctlv_attestation_devsec_run(
-			  self->dev, request, &reply, &self->error));
-	ctlv_msg_free(request);
-	EXPECT_TRUE(ctlv_attestation_device_generation_get(
-		ctlv_reply_root(reply), &device_generation));
-	EXPECT_EQ(2, device_generation);
-	ctlv_reply_free(reply);
-	expect_event(_metadata, self->dev,
-		     CTLV_ATTESTATION_OP_DEVICE_STATE_CHANGED);
-	expect_event(_metadata, self->dev,
-		     CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED);
-
 	ASSERT_EQ(0, ctlv_attestation_devsec_state_get(
 			  self->dev, NULL, &reply, &self->error));
 	EXPECT_TRUE(ctlv_attestation_devsec_tdisp_state_get(
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
index bccac87ea4fc..a1223c4fd45e 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
@@ -133,17 +133,6 @@ static const struct ctlv_node_schema device_get_reply_caps_mr_attr_node_schemas[
 	},
 };
 
-/* cap.devsec, attrs */
-static const struct ctlv_node_schema device_get_reply_caps_devsec_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS,
-		.kind = CTLV_SCHEMA_FLAGS,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
-		.flags_mask = 1,
-	},
-};
-
 /* device.caps, optional attrs */
 static const struct ctlv_node_schema device_get_reply_caps_optional_attr_node_schemas[] = {
 	{
@@ -162,13 +151,6 @@ static const struct ctlv_node_schema device_get_reply_caps_optional_attr_node_sc
 		.attrs = device_get_reply_caps_mr_attr_node_schemas,
 		.attrs_count = 1,
 	},
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_CAP_DEVSEC,
-		.kind = CTLV_SCHEMA_NEST,
-		.max_occurrences = 1,
-		.attrs = device_get_reply_caps_devsec_attr_node_schemas,
-		.attrs_count = 1,
-	},
 };
 
 /* device.info, attrs */
@@ -198,7 +180,7 @@ static const struct ctlv_node_schema device_get_reply_attr_node_schemas[] = {
 		.kind = CTLV_SCHEMA_NEST,
 		.max_occurrences = 1,
 		.optional_attrs = device_get_reply_caps_optional_attr_node_schemas,
-		.optional_attrs_count = 3,
+		.optional_attrs_count = 2,
 	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_INFO,
@@ -1119,54 +1101,6 @@ static const struct ctlv_node_schema devsec_state_get_reply_node_schema = {
 	.optional_attrs_count = 4,
 };
 
-/* root, attrs */
-static const struct ctlv_node_schema devsec_run_request_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-};
-
-static const struct ctlv_node_schema devsec_run_request_node_schema = {
-	.attr_id = CTLV_ATTR_ROOT,
-	.kind = CTLV_SCHEMA_NEST,
-	.max_occurrences = 1,
-	.attrs = devsec_run_request_attr_node_schemas,
-	.attrs_count = 2,
-};
-
-/* root, attrs */
-static const struct ctlv_node_schema devsec_run_reply_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-};
-
-static const struct ctlv_node_schema devsec_run_reply_node_schema = {
-	.attr_id = CTLV_ATTR_ROOT,
-	.kind = CTLV_SCHEMA_NEST,
-	.max_occurrences = 1,
-	.attrs = devsec_run_reply_attr_node_schemas,
-	.attrs_count = 1,
-};
-
 /* root, attrs */
 static const struct ctlv_node_schema evidence_state_changed_reply_attr_node_schemas[] = {
 	{
@@ -1475,7 +1409,7 @@ static const struct ctlv_op_spec ctlv_attestation_sim_op_specs[] = {
 		.fd_access = CTLV_OP_FD_ACCESS_READ,
 		.availability = CTLV_OP_AVAILABILITY_FIXED,
 		.request_max_len = 16,
-		.action_reply_max_len = 13016,
+		.action_reply_max_len = 12976,
 		.request = &device_get_request_node_schema,
 		.reply = &device_get_reply_node_schema,
 	},
@@ -1578,17 +1512,6 @@ static const struct ctlv_op_spec ctlv_attestation_sim_op_specs[] = {
 		.request = &devsec_state_get_request_node_schema,
 		.reply = &devsec_state_get_reply_node_schema,
 	},
-	{
-		.op_id = CTLV_ATTESTATION_OP_DEVSEC_RUN,
-		.type = CTLV_OP_TYPE_ACTION,
-		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
-		.optional = true,
-		.request_max_len = 64,
-		.action_reply_max_len = 40,
-		.request = &devsec_run_request_node_schema,
-		.reply = &devsec_run_reply_node_schema,
-	},
 	{
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED,
 		.type = CTLV_OP_TYPE_EVENT,
@@ -1615,5 +1538,5 @@ const struct ctlv_family_spec ctlv_attestation_sim_spec = {
 	.family_id = 5,
 	.parent = &ctlv_attestation_spec,
 	.ops = ctlv_attestation_sim_op_specs,
-	.ops_count = 14,
+	.ops_count = 13,
 };
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
index 3395c0ffc3e5..2b6d4537466f 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
@@ -133,17 +133,6 @@ static const struct ctlv_node_schema device_get_reply_caps_mr_attr_node_schemas[
 	},
 };
 
-/* cap.devsec, attrs */
-static const struct ctlv_node_schema device_get_reply_caps_devsec_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS,
-		.kind = CTLV_SCHEMA_FLAGS,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
-		.flags_mask = 1,
-	},
-};
-
 /* device.caps, optional attrs */
 static const struct ctlv_node_schema device_get_reply_caps_optional_attr_node_schemas[] = {
 	{
@@ -162,13 +151,6 @@ static const struct ctlv_node_schema device_get_reply_caps_optional_attr_node_sc
 		.attrs = device_get_reply_caps_mr_attr_node_schemas,
 		.attrs_count = 1,
 	},
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_CAP_DEVSEC,
-		.kind = CTLV_SCHEMA_NEST,
-		.max_occurrences = 1,
-		.attrs = device_get_reply_caps_devsec_attr_node_schemas,
-		.attrs_count = 1,
-	},
 };
 
 /* device.info, attrs */
@@ -214,7 +196,7 @@ static const struct ctlv_node_schema device_get_reply_attr_node_schemas[] = {
 		.kind = CTLV_SCHEMA_NEST,
 		.max_occurrences = 1,
 		.optional_attrs = device_get_reply_caps_optional_attr_node_schemas,
-		.optional_attrs_count = 3,
+		.optional_attrs_count = 2,
 	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_INFO,
@@ -1135,54 +1117,6 @@ static const struct ctlv_node_schema devsec_state_get_reply_node_schema = {
 	.optional_attrs_count = 4,
 };
 
-/* root, attrs */
-static const struct ctlv_node_schema devsec_run_request_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-};
-
-static const struct ctlv_node_schema devsec_run_request_node_schema = {
-	.attr_id = CTLV_ATTR_ROOT,
-	.kind = CTLV_SCHEMA_NEST,
-	.max_occurrences = 1,
-	.attrs = devsec_run_request_attr_node_schemas,
-	.attrs_count = 2,
-};
-
-/* root, attrs */
-static const struct ctlv_node_schema devsec_run_reply_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-};
-
-static const struct ctlv_node_schema devsec_run_reply_node_schema = {
-	.attr_id = CTLV_ATTR_ROOT,
-	.kind = CTLV_SCHEMA_NEST,
-	.max_occurrences = 1,
-	.attrs = devsec_run_reply_attr_node_schemas,
-	.attrs_count = 1,
-};
-
 /* root, attrs */
 static const struct ctlv_node_schema evidence_state_changed_reply_attr_node_schemas[] = {
 	{
@@ -1491,7 +1425,7 @@ static const struct ctlv_op_spec ctlv_attestation_tdx_op_specs[] = {
 		.fd_access = CTLV_OP_FD_ACCESS_READ,
 		.availability = CTLV_OP_AVAILABILITY_FIXED,
 		.request_max_len = 16,
-		.action_reply_max_len = 13128,
+		.action_reply_max_len = 13088,
 		.request = &device_get_request_node_schema,
 		.reply = &device_get_reply_node_schema,
 	},
@@ -1594,17 +1528,6 @@ static const struct ctlv_op_spec ctlv_attestation_tdx_op_specs[] = {
 		.request = &devsec_state_get_request_node_schema,
 		.reply = &devsec_state_get_reply_node_schema,
 	},
-	{
-		.op_id = CTLV_ATTESTATION_OP_DEVSEC_RUN,
-		.type = CTLV_OP_TYPE_ACTION,
-		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
-		.optional = true,
-		.request_max_len = 64,
-		.action_reply_max_len = 40,
-		.request = &devsec_run_request_node_schema,
-		.reply = &devsec_run_reply_node_schema,
-	},
 	{
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED,
 		.type = CTLV_OP_TYPE_EVENT,
@@ -1631,5 +1554,5 @@ const struct ctlv_family_spec ctlv_attestation_tdx_spec = {
 	.family_id = 2,
 	.parent = &ctlv_attestation_spec,
 	.ops = ctlv_attestation_tdx_op_specs,
-	.ops_count = 14,
+	.ops_count = 13,
 };
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
index 6a363b29f80b..17756bf1afea 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
@@ -133,17 +133,6 @@ static const struct ctlv_node_schema device_get_reply_caps_mr_attr_node_schemas[
 	},
 };
 
-/* cap.devsec, attrs */
-static const struct ctlv_node_schema device_get_reply_caps_devsec_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS,
-		.kind = CTLV_SCHEMA_FLAGS,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_FLAGS_MASK,
-		.flags_mask = 1,
-	},
-};
-
 /* device.caps, optional attrs */
 static const struct ctlv_node_schema device_get_reply_caps_optional_attr_node_schemas[] = {
 	{
@@ -162,13 +151,6 @@ static const struct ctlv_node_schema device_get_reply_caps_optional_attr_node_sc
 		.attrs = device_get_reply_caps_mr_attr_node_schemas,
 		.attrs_count = 1,
 	},
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_CAP_DEVSEC,
-		.kind = CTLV_SCHEMA_NEST,
-		.max_occurrences = 1,
-		.attrs = device_get_reply_caps_devsec_attr_node_schemas,
-		.attrs_count = 1,
-	},
 };
 
 /* root, attrs */
@@ -186,7 +168,7 @@ static const struct ctlv_node_schema device_get_reply_attr_node_schemas[] = {
 		.kind = CTLV_SCHEMA_NEST,
 		.max_occurrences = 1,
 		.optional_attrs = device_get_reply_caps_optional_attr_node_schemas,
-		.optional_attrs_count = 3,
+		.optional_attrs_count = 2,
 	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_INFO,
@@ -1105,54 +1087,6 @@ static const struct ctlv_node_schema devsec_state_get_reply_node_schema = {
 	.optional_attrs_count = 4,
 };
 
-/* root, attrs */
-static const struct ctlv_node_schema devsec_run_request_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-};
-
-static const struct ctlv_node_schema devsec_run_request_node_schema = {
-	.attr_id = CTLV_ATTR_ROOT,
-	.kind = CTLV_SCHEMA_NEST,
-	.max_occurrences = 1,
-	.attrs = devsec_run_request_attr_node_schemas,
-	.attrs_count = 2,
-};
-
-/* root, attrs */
-static const struct ctlv_node_schema devsec_run_reply_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
-		.kind = CTLV_SCHEMA_UINT,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN | CTLV_NODE_SCHEMA_HAS_MAX,
-		.min = 0,
-		.max = 0xffffffffULL,
-	},
-};
-
-static const struct ctlv_node_schema devsec_run_reply_node_schema = {
-	.attr_id = CTLV_ATTR_ROOT,
-	.kind = CTLV_SCHEMA_NEST,
-	.max_occurrences = 1,
-	.attrs = devsec_run_reply_attr_node_schemas,
-	.attrs_count = 1,
-};
-
 /* root, attrs */
 static const struct ctlv_node_schema evidence_state_changed_reply_attr_node_schemas[] = {
 	{
@@ -1461,7 +1395,7 @@ static const struct ctlv_op_spec ctlv_attestation_op_specs[] = {
 		.fd_access = CTLV_OP_FD_ACCESS_READ,
 		.availability = CTLV_OP_AVAILABILITY_FIXED,
 		.request_max_len = 16,
-		.action_reply_max_len = 12936,
+		.action_reply_max_len = 12896,
 		.request = &device_get_request_node_schema,
 		.reply = &device_get_reply_node_schema,
 	},
@@ -1564,17 +1498,6 @@ static const struct ctlv_op_spec ctlv_attestation_op_specs[] = {
 		.request = &devsec_state_get_request_node_schema,
 		.reply = &devsec_state_get_reply_node_schema,
 	},
-	{
-		.op_id = CTLV_ATTESTATION_OP_DEVSEC_RUN,
-		.type = CTLV_OP_TYPE_ACTION,
-		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
-		.optional = true,
-		.request_max_len = 64,
-		.action_reply_max_len = 40,
-		.request = &devsec_run_request_node_schema,
-		.reply = &devsec_run_reply_node_schema,
-	},
 	{
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_STATE_CHANGED,
 		.type = CTLV_OP_TYPE_EVENT,
@@ -1601,5 +1524,5 @@ const struct ctlv_family_spec ctlv_attestation_spec = {
 	.family_id = 1,
 	.parent = &ctlv_spec,
 	.ops = ctlv_attestation_op_specs,
-	.ops_count = 14,
+	.ops_count = 13,
 };
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h
index f4b7a4d3c0ce..67b8820b3efc 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h
+++ b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.h
@@ -18,7 +18,7 @@ extern const struct ctlv_family_spec ctlv_attestation_spec;
 /* Executing an op. A query is reassembled into the one reply it fills. */
 
 #define CTLV_ATTESTATION_OP_DEVICE_GET_REQUEST_MAX_LEN 16
-#define CTLV_ATTESTATION_OP_DEVICE_GET_ACTION_REPLY_MAX_LEN 12936
+#define CTLV_ATTESTATION_OP_DEVICE_GET_ACTION_REPLY_MAX_LEN 12896
 
 static inline int ctlv_attestation_device_get_request_new(struct ctlv_msg **request)
 {
@@ -165,22 +165,6 @@ static inline int ctlv_attestation_devsec_state_get(struct ctlv_dev *dev, struct
 	return ctlv_query(dev, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET, request, reply, error);
 }
 
-#define CTLV_ATTESTATION_OP_DEVSEC_RUN_REQUEST_MAX_LEN 64
-#define CTLV_ATTESTATION_OP_DEVSEC_RUN_ACTION_REPLY_MAX_LEN 40
-
-static inline int ctlv_attestation_devsec_run_request_new(struct ctlv_msg **request)
-{
-	const __u32 len = CTLV_ATTESTATION_OP_DEVSEC_RUN_REQUEST_MAX_LEN;
-
-	return ctlv_msg_new(len, request);
-}
-
-static inline int ctlv_attestation_devsec_run(struct ctlv_dev *dev, struct ctlv_msg *request,
-					      struct ctlv_reply **reply, struct ctlv_error *error)
-{
-	return ctlv_action(dev, CTLV_ATTESTATION_OP_DEVSEC_RUN, request, reply, error);
-}
-
 #define CTLV_ATTESTATION_OP_MR_LOG_GET_REQUEST_MAX_LEN 10304
 #define CTLV_ATTESTATION_OP_MR_LOG_GET_QUERY_REPLY_MIN_LEN 65600
 #define CTLV_ATTESTATION_OP_MR_LOG_GET_QUERY_REPLY_SUGGESTED_LEN 131072
@@ -276,16 +260,6 @@ static inline int ctlv_attestation_cap_evidence_flags_put(struct ctlv_msg *msg,
 	return ctlv_put_u64(msg, CTLV_ATTESTATION_ATTR_CAP_EVIDENCE_FLAGS, value);
 }
 
-static inline int ctlv_attestation_cap_devsec_start(struct ctlv_msg *msg)
-{
-	return ctlv_nest_start(msg, CTLV_ATTESTATION_ATTR_CAP_DEVSEC);
-}
-
-static inline int ctlv_attestation_cap_devsec_flags_put(struct ctlv_msg *msg, __u64 value)
-{
-	return ctlv_put_u64(msg, CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS, value);
-}
-
 static inline int ctlv_attestation_cap_blob_instance_put(struct ctlv_msg *msg, __u64 value)
 {
 	return ctlv_put_u64(msg, CTLV_ATTESTATION_ATTR_CAP_BLOB_INSTANCE, value);
@@ -721,30 +695,6 @@ static inline bool ctlv_attestation_cap_evidence_flags_get(const struct ctlv_att
 	return attr && !ctlv_get_flags(attr, CTLV_ATTESTATION_EVIDENCE_CAPS_MASK, value, unknown);
 }
 
-static inline bool ctlv_attestation_cap_devsec_present(const struct ctlv_attr *nest)
-{
-	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_CAP_DEVSEC);
-}
-
-static inline const struct ctlv_attr *ctlv_attestation_cap_devsec_get(const struct ctlv_attr *nest)
-{
-	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_CAP_DEVSEC);
-}
-
-static inline bool ctlv_attestation_cap_devsec_flags_present(const struct ctlv_attr *nest)
-{
-	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS);
-}
-
-static inline bool ctlv_attestation_cap_devsec_flags_get(const struct ctlv_attr *nest, __u64 *value,
-							 __u64 *unknown)
-{
-	const struct ctlv_attr *attr;
-
-	attr = ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_CAP_DEVSEC_FLAGS);
-	return attr && !ctlv_get_flags(attr, CTLV_ATTESTATION_DEVSEC_CAPS_MASK, value, unknown);
-}
-
 static inline bool ctlv_attestation_cap_blob_instance_present(const struct ctlv_attr *nest)
 {
 	return ctlv_attr_find(nest, CTLV_ATTESTATION_ATTR_CAP_BLOB_INSTANCE);
-- 
2.43.0

