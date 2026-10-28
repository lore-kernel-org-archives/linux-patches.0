Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201200;
	b=Cpr4tF7sKini8ibXkZoW0tQRbfAYiNR5da6ZmH31Ujma+KXr8ffPt7KltuB7Ag97UZMa
	 dBGibcCg0kNvGSVCzlPtQmSn151QpXsiWh+EnP5TYeczeZlFVmrZFgkkXX7F9q8k99yZI
	 hDB5piI+yS6BY4mfsbc5qB0JT+y1Ks8M6yHu/Fhxcmpjg+wSOCPKNz0p7pZTxoLi/OFUX
	 GdDAR4SQvdgIqyOMSgF6Yd/I7AUKK29lbjYP4ygY07DIH0fCtDaA/Qv/rsLiOhYBjhZUn
	 MHQmxPxru/wDuk2o1oKuVDM6ollaDuCdZnHUnIXDSdrBxA5TSrPIWImTWBKU0LRdj+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8pYBpkkKV6+EXkF78SRMwzZzBTvirtL8x4efzzr4c1g=;
	b=HPVHyUEAmhHFDaZTxgpFxSQdZ+uyb567Kkzcd+oXSOWf5i9ZNjId6d/PXRfs6PUklkKu
	 hnHKGejffs+SJSXdbwPxPJ8WXzHT3E8m4aRqwmyASJz2AR2+ZBsLH7FTFV4MeQccwk25Q
	 NWInZxZiHTcXtzLAuqg5OVz9ZyOScxt6qK7zCdp10xnEjH7DmnvaQm2YKKm11fEuj699X
	 yqf7IcCLXG8spl61voKgokcZ0HD21N4zgjiwrIBqLizqy+33vFXD0cqj2qeA8k105PD61
	 0WlEsXkB+UdERtl0p6n380LRVq8uZeyZ0FEgikLINm5RSUfjlRhwVqypYhyUyEO46wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGzkUP11;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FD0606A31E;
	Wed, 28 Oct 2026 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGzkUP11
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F41D1F031E1;
	Wed, 28 Oct 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201199;
	bh=8pYBpkkKV6+EXkF78SRMwzZzBTvirtL8x4efzzr4c1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGzkUP11AoZDPxt0W7mRJ4Pe3nfDF2OTZFoaC52pPcsOZCTnj9fpG42yHGse3bFf9
	 tugTXsyE94/CSb5qxzpcYu8FovbzRfHSzw6zaL6wWbGMX2XIjoeWhVAKmCvqxbN1Mg
	 HJ633uyp5/cy5JloUdSQNt/tDE9K2VMJ4ZKFsvD3gtFnarPeIK1t9sknlnm1kAfYDW
	 haTD6miNgzW6Zzb6D1CAl+6sGmDwD5vT2uiKPpmR25OoMutlXMXb1YQ+dutXrL7JUP
	 nRLo78328o0lYMOAc+dD0M5YxD2Bbh7btpkWtKCQ4v/nx/uJVtZT5f9UcUbWZdfCFI
	 /RUqa65L5kEZg==
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
Subject: [RFC PATCH v1 01/11] attestation: Restrict inherited operations per instance
Date: Wed, 28 Oct 2026 20:56:08 +0530
Message-ID: <20261028152618.1356860-2-aneesh.kumar@kernel.org>
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

Allow an attestation instance to enable only the operations supported by
its device. Update the operations and DEVICE_GET capabilities together
under the instance mutex.

The following PCI/TSM patch uses one attestation implementation for host
links and guest devices. Each instance must expose only the operations
supported by that device:

  Instance                Evidence  Evidence acceptance  TDISP state
  ----------------------  --------  -------------------  -----------
  Host link, PF0          Yes       Yes                  No
  Host link, non-PF0      Yes       No                   No
  Guest device           Yes       If supported         Yes

For a guest device, evidence acceptance requires the TSM driver's accept
callback. A device error also requires evidence retrieval and acceptance
to be disabled for that instance.

Currently, DEVSEC_STATE_GET calls the TDISP callback whenever that callback
is defined, even for a host link. The callback returns -EOPNOTSUPP for the
host link, causing the whole query to fail and hiding its evidence
acceptance verdict.

Track the enabled features separately for each instance. Use them both to
enable operations and to choose which state callbacks DEVSEC_STATE_GET
calls. A host link can then report its acceptance verdict without trying
to read TDISP state. Keep DEVICE_GET capabilities consistent with the
enabled operations.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ctlv/abi/ctlv-attestation.yaml  |  7 +-
 .../ctlv/specs/ctlv-attestation.yaml          |  3 +
 Documentation/driver-api/attestation.rst      | 14 ++++
 drivers/attestation/core/core.c               | 79 +++++++++++++++++-
 drivers/attestation/core/ctlv.c               | 10 +--
 drivers/attestation/core/internal.h           |  1 +
 .../generated/ctlv_attestation_gen.c          |  6 +-
 .../generated/ctlv_attestation_gen.h          |  6 ++
 drivers/attestation/tests/core_kunit.c        | 83 ++++++++++++++++++-
 include/linux/attestation.h                   | 33 ++++++++
 .../ctlv_attestation_sim_user_gen.c           |  6 +-
 .../ctlv_attestation_tdx_user_gen.c           |  6 +-
 .../attestation/ctlv_attestation_user_gen.c   |  6 +-
 13 files changed, 237 insertions(+), 23 deletions(-)

diff --git a/Documentation/ctlv/abi/ctlv-attestation.yaml b/Documentation/ctlv/abi/ctlv-attestation.yaml
index 48f7454ae6c0..31dbffa59416 100644
--- a/Documentation/ctlv/abi/ctlv-attestation.yaml
+++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
@@ -245,12 +245,13 @@ ops:
                   attrs: [log.template-name, log.template-data, log.violation]
               - record.item: {attrs: [record.format, record.data]}
   evidence-accept:
-    abi: {id: 9, type: action, optional: true}
+    abi: {id: 9, type: action, availability: dynamic, optional: true}
     request: {attrs: [device.generation, evidence.generation]}
   evidence-accept-clear:
-    abi: {id: 10, type: action, optional: true}
+    abi: {id: 10, type: action, availability: dynamic, optional: true}
   devsec-state-get:
-    abi: {id: 11, type: query, fd-access: read, optional: true}
+    abi: {id: 11, type: query, fd-access: read, availability: dynamic,
+          optional: true}
     reply:
       attrs: [device.generation]
       optional-attrs: [evidence.generation, evidence.accepted-generation,
diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
index 5a8da657cc8b..570a97b7538f 100644
--- a/Documentation/ctlv/specs/ctlv-attestation.yaml
+++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
@@ -551,6 +551,7 @@ ops:
   - name: evidence-accept
     type: action
     fd-access: read-write
+    availability: dynamic
     optional: true
     request:
       attrs: evidence-generation-request
@@ -558,11 +559,13 @@ ops:
   - name: evidence-accept-clear
     type: action
     fd-access: read-write
+    availability: dynamic
     optional: true
 
   - name: devsec-state-get
     type: query
     fd-access: read
+    availability: dynamic
     optional: true
     reply:
       attrs: devsec-state-reply
diff --git a/Documentation/driver-api/attestation.rst b/Documentation/driver-api/attestation.rst
index baf188aafe54..06af8df23a46 100644
--- a/Documentation/driver-api/attestation.rst
+++ b/Documentation/driver-api/attestation.rst
@@ -29,6 +29,20 @@ dynamic topology retains handles returned by ``attestation_mr_create()`` and
 passes each handle exactly once to ``attestation_mr_destroy()``.  Property
 storage remains valid for the handle's lifetime.
 
+Per-instance features
+=====================
+
+A provider descriptor describes the maximum capabilities of its instances.
+A child family may restrict evidence retrieval, verifier verdicts, TDISP or
+trust-state reporting and RUN through ``attestation_features_set_locked()``.
+The features must be a subset of the descriptor. Verdicts require evidence;
+RUN additionally requires verdicts and at least one native state reporter.
+Providers that do not restrict their features keep the descriptor's defaults.
+
+The setter updates dynamic CTLV operation availability and the capabilities
+reported by DEVICE_GET under the instance mutex. DEVSEC_STATE_GET omits native
+state reporters that the instance has disabled.
+
 State changes
 =============
 
diff --git a/drivers/attestation/core/core.c b/drivers/attestation/core/core.c
index 7d8430bda7ec..41fe1084c989 100644
--- a/drivers/attestation/core/core.c
+++ b/drivers/attestation/core/core.c
@@ -458,6 +458,78 @@ void attestation_state_changed(struct attestation *att)
 }
 EXPORT_SYMBOL_NS_GPL(attestation_state_changed, "ATTESTATION");
 
+static unsigned int attestation_provider_features(const struct attestation_provider *provider)
+{
+	unsigned int features = 0;
+
+	if (provider->evidence_caps)
+		features |= ATTESTATION_FEATURE_EVIDENCE;
+
+	if (provider->evidence_accept)
+		features |= ATTESTATION_FEATURE_EVIDENCE_ACCEPT;
+
+	if (provider->tdisp_state_get)
+		features |= ATTESTATION_FEATURE_TDISP_STATE;
+
+	if (provider->device_trust_get)
+		features |= ATTESTATION_FEATURE_DEVICE_TRUST;
+
+	if (provider->devsec_run)
+		features |= ATTESTATION_FEATURE_DEVSEC_RUN;
+
+	return features;
+}
+
+int attestation_features_set_locked(struct attestation *att, unsigned int features)
+{
+	unsigned int supported = attestation_provider_features(att->provider);
+	unsigned int state = ATTESTATION_FEATURE_TDISP_STATE |
+			     ATTESTATION_FEATURE_DEVICE_TRUST;
+
+	lockdep_assert_held(&att->lock);
+	if (features & ~supported)
+		return -EINVAL;
+
+	if ((features & ATTESTATION_FEATURE_EVIDENCE_ACCEPT) &&
+	    !(features & ATTESTATION_FEATURE_EVIDENCE))
+		return -EINVAL;
+
+	if ((features & ATTESTATION_FEATURE_DEVSEC_RUN) &&
+	    (!(features & ATTESTATION_FEATURE_EVIDENCE_ACCEPT) || !(features & state)))
+		return -EINVAL;
+
+	att->features = features;
+	if (supported & ATTESTATION_FEATURE_EVIDENCE)
+		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_EVIDENCE_GET,
+					 !(features & ATTESTATION_FEATURE_EVIDENCE));
+
+	if (supported & ATTESTATION_FEATURE_EVIDENCE_ACCEPT) {
+		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT,
+					 !(features & ATTESTATION_FEATURE_EVIDENCE_ACCEPT));
+		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
+					 !(features & ATTESTATION_FEATURE_EVIDENCE_ACCEPT));
+	}
+
+	state |= ATTESTATION_FEATURE_EVIDENCE_ACCEPT;
+
+	if (supported & state)
+		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET,
+					 !(features & state));
+
+	if (supported & ATTESTATION_FEATURE_DEVSEC_RUN)
+		ctlv_device_op_state_set(att->ctlvdev, CTLV_ATTESTATION_OP_DEVSEC_RUN,
+					 !(features & ATTESTATION_FEATURE_DEVSEC_RUN));
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(attestation_features_set_locked, "ATTESTATION");
+
+int attestation_features_set(struct attestation *att, unsigned int features)
+{
+	guard(mutex)(&att->lock);
+	return attestation_features_set_locked(att, features);
+}
+EXPORT_SYMBOL_NS_GPL(attestation_features_set, "ATTESTATION");
+
 void attestation_provide_ops(struct attestation *att)
 {
 	const struct attestation_provider *provider = att->provider;
@@ -469,6 +541,8 @@ void attestation_provide_ops(struct attestation *att)
 		if (provider->evidence_accept) {
 			ctlv_attestation_evidence_accept_provide(ctlvdev);
 			ctlv_attestation_evidence_accept_clear_provide(ctlvdev);
+			ctlv_attestation_evidence_accept_enable(ctlvdev);
+			ctlv_attestation_evidence_accept_clear_enable(ctlvdev);
 		}
 	}
 	if (provider->mr_caps) {
@@ -480,8 +554,10 @@ void attestation_provide_ops(struct attestation *att)
 		if (provider->mr_extend)
 			ctlv_attestation_mr_extend_provide(ctlvdev);
 	}
-	if (provider->tdisp_state_get || provider->device_trust_get || provider->evidence_accept)
+	if (provider->tdisp_state_get || provider->device_trust_get || provider->evidence_accept) {
 		ctlv_attestation_devsec_state_get_provide(ctlvdev);
+		ctlv_attestation_devsec_state_get_enable(ctlvdev);
+	}
 	if (provider->devsec_run) {
 		ctlv_attestation_devsec_run_provide(ctlvdev);
 		ctlv_attestation_devsec_run_enable(ctlvdev);
@@ -502,6 +578,7 @@ int attestation_core_init(struct attestation *att, struct ctlv_device *ctlvdev,
 	xa_init(&att->mrs);
 	att->ctlvdev = ctlvdev;
 	att->provider = provider;
+	att->features = attestation_provider_features(provider);
 	for (index = 0; index < provider->mrs_count; index++) {
 		struct attestation_mr *mr;
 
diff --git a/drivers/attestation/core/ctlv.c b/drivers/attestation/core/ctlv.c
index b08356c3c027..8f4fa48ffdc5 100644
--- a/drivers/attestation/core/ctlv.c
+++ b/drivers/attestation/core/ctlv.c
@@ -60,7 +60,7 @@ static int attestation_device_caps_put(struct attestation *att, struct ctlv_curs
 
 	if (!ctlv_attestation_device_caps_start(reply, &caps_nest))
 		return -EMSGSIZE;
-	if (provider->evidence_caps) {
+	if (att->features & ATTESTATION_FEATURE_EVIDENCE) {
 		const struct attestation_evidence_caps *caps = provider->evidence_caps;
 
 		if (!ctlv_attestation_cap_evidence_start(&caps_nest, &group))
@@ -72,7 +72,7 @@ static int attestation_device_caps_put(struct attestation *att, struct ctlv_curs
 		ok &= ctlv_attestation_cap_max_total_output_length_put(&group,
 								       caps->max_total_output_length);
 		flags = 0;
-		if (provider->evidence_accept)
+		if (att->features & ATTESTATION_FEATURE_EVIDENCE_ACCEPT)
 			flags |= CTLV_ATTESTATION_EVIDENCE_CAPS_EVIDENCE_ACCEPT;
 		if (caps->supports_mr_selection)
 			flags |= CTLV_ATTESTATION_EVIDENCE_CAPS_MR_SELECTION;
@@ -119,7 +119,7 @@ static int attestation_device_caps_put(struct attestation *att, struct ctlv_curs
 		ok &= ctlv_attestation_cap_mr_flags_put(&group, flags);
 		ctlv_nest_end(&group);
 	}
-	if (provider->devsec_run) {
+	if (att->features & ATTESTATION_FEATURE_DEVSEC_RUN) {
 		if (!ctlv_attestation_cap_devsec_start(&caps_nest, &group))
 			return -EMSGSIZE;
 		ok &= ctlv_attestation_cap_devsec_flags_put(&group,
@@ -935,13 +935,13 @@ int ctlv_attestation_devsec_state_get_query(void *priv, struct ctlv_op_ctx *ctx,
 	if (att->verdict_recorded)
 		ok &= ctlv_attestation_evidence_accepted_generation_put(reply,
 									att->accepted_evidence_generation);
-	if (att->provider->tdisp_state_get) {
+	if (att->features & ATTESTATION_FEATURE_TDISP_STATE) {
 		ret = att->provider->tdisp_state_get(att, &state);
 		if (ret)
 			return ret;
 		ok &= ctlv_attestation_devsec_tdisp_state_put(reply, state);
 	}
-	if (att->provider->device_trust_get) {
+	if (att->features & ATTESTATION_FEATURE_DEVICE_TRUST) {
 		ret = att->provider->device_trust_get(att, &trust);
 		if (ret)
 			return ret;
diff --git a/drivers/attestation/core/internal.h b/drivers/attestation/core/internal.h
index bd84efb5abb8..9e531e8483f7 100644
--- a/drivers/attestation/core/internal.h
+++ b/drivers/attestation/core/internal.h
@@ -70,6 +70,7 @@ struct attestation_mr_log {
 struct attestation {
 	struct ctlv_device *ctlvdev;
 	const struct attestation_provider *provider;
+	unsigned int features;
 	unsigned int index;
 
 	/* Mutable instance, MR, verdict, and journal state. */
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.c b/drivers/attestation/generated/ctlv_attestation_gen.c
index 911b32255dd5..5882dd2c93a7 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.c
+++ b/drivers/attestation/generated/ctlv_attestation_gen.c
@@ -300,15 +300,15 @@ const struct ctlv_op_schema ctlv_attestation_op_schemas[] = {
 	CTLV_OP_SCHEMA_EVENT(CTLV_ATTESTATION_OP_MR_LOG_ENTRY_APPENDED, 73416,
 			     CTLV_SCHEMA_TREE(mr_log_entry_appended_reply)),
 	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT, CTLV_OP_FD_ACCESS_READ_WRITE,
-			      CTLV_OP_AVAILABILITY_FIXED, 64, 0,
+			      CTLV_OP_AVAILABILITY_DYNAMIC, 64, 0,
 			      CTLV_SCHEMA_TREE(evidence_accept_request), CTLV_SCHEMA_TREE_NONE(),
 			      .optional = true),
 	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
-			      CTLV_OP_FD_ACCESS_READ_WRITE, CTLV_OP_AVAILABILITY_FIXED, 16, 0,
+			      CTLV_OP_FD_ACCESS_READ_WRITE, CTLV_OP_AVAILABILITY_DYNAMIC, 16, 0,
 			      CTLV_SCHEMA_TREE(evidence_accept_clear_request),
 			      CTLV_SCHEMA_TREE_NONE(), .optional = true),
 	CTLV_OP_SCHEMA_QUERY(CTLV_ATTESTATION_OP_DEVSEC_STATE_GET, CTLV_OP_FD_ACCESS_READ,
-			     CTLV_OP_AVAILABILITY_FIXED, 16, 40, 1024,
+			     CTLV_OP_AVAILABILITY_DYNAMIC, 16, 40, 1024,
 			     CTLV_SCHEMA_TREE(devsec_state_get_request),
 			     CTLV_SCHEMA_TREE(devsec_state_get_reply), .optional = true),
 	CTLV_OP_SCHEMA_ACTION(CTLV_ATTESTATION_OP_DEVSEC_RUN, CTLV_OP_FD_ACCESS_READ_WRITE,
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.h b/drivers/attestation/generated/ctlv_attestation_gen.h
index 028026a82e8a..a1f125690005 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.h
+++ b/drivers/attestation/generated/ctlv_attestation_gen.h
@@ -73,8 +73,14 @@ CTLV_OP_PROVIDE(ctlv_attestation_mr_dump, CTLV_ATTESTATION_OP_MR_DUMP)
 CTLV_OP_PROVIDE(ctlv_attestation_mr_read, CTLV_ATTESTATION_OP_MR_READ)
 CTLV_OP_PROVIDE(ctlv_attestation_mr_extend, CTLV_ATTESTATION_OP_MR_EXTEND)
 CTLV_OP_PROVIDE(ctlv_attestation_evidence_accept, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT)
+CTLV_OP_ENABLE(ctlv_attestation_evidence_accept, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT)
+CTLV_OP_DISABLE(ctlv_attestation_evidence_accept, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT)
 CTLV_OP_PROVIDE(ctlv_attestation_evidence_accept_clear, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR)
+CTLV_OP_ENABLE(ctlv_attestation_evidence_accept_clear, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR)
+CTLV_OP_DISABLE(ctlv_attestation_evidence_accept_clear, CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR)
 CTLV_OP_PROVIDE(ctlv_attestation_devsec_state_get, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET)
+CTLV_OP_ENABLE(ctlv_attestation_devsec_state_get, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET)
+CTLV_OP_DISABLE(ctlv_attestation_devsec_state_get, CTLV_ATTESTATION_OP_DEVSEC_STATE_GET)
 CTLV_OP_PROVIDE(ctlv_attestation_devsec_run, CTLV_ATTESTATION_OP_DEVSEC_RUN)
 CTLV_OP_ENABLE(ctlv_attestation_devsec_run, CTLV_ATTESTATION_OP_DEVSEC_RUN)
 CTLV_OP_DISABLE(ctlv_attestation_devsec_run, CTLV_ATTESTATION_OP_DEVSEC_RUN)
diff --git a/drivers/attestation/tests/core_kunit.c b/drivers/attestation/tests/core_kunit.c
index 290c83009991..7e4710370cfe 100644
--- a/drivers/attestation/tests/core_kunit.c
+++ b/drivers/attestation/tests/core_kunit.c
@@ -142,11 +142,10 @@ static void attestation_test_provider_init(struct attestation_test *fixture)
 	};
 }
 
-static int attestation_test_create(struct kunit *test,
+static int attestation_test_create_provider(struct kunit *test,
 				   struct attestation_test *fixture,
 				   const char *name)
 {
-	attestation_test_provider_init(fixture);
 	fixture->parent = kunit_device_register(test, name);
 	if (IS_ERR(fixture->parent))
 		return PTR_ERR(fixture->parent);
@@ -168,6 +167,14 @@ static int attestation_test_create(struct kunit *test,
 		test, attestation_test_destroy, fixture);
 }
 
+static int attestation_test_create(struct kunit *test,
+				   struct attestation_test *fixture,
+				   const char *name)
+{
+	attestation_test_provider_init(fixture);
+	return attestation_test_create_provider(test, fixture, name);
+}
+
 static int attestation_test_init(struct kunit *test)
 {
 	struct attestation_test *fixture;
@@ -210,6 +217,76 @@ static void attestation_test_provider_contracts(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, PTR_ERR(created), -EINVAL);
 }
 
+static void attestation_test_instance_features(struct kunit *test)
+{
+	struct attestation_test *fixture = test->priv;
+	unsigned int features = ATTESTATION_FEATURE_EVIDENCE |
+				ATTESTATION_FEATURE_EVIDENCE_ACCEPT;
+
+	KUNIT_ASSERT_EQ(test, attestation_test_create(
+				test, fixture, "attestation-features"), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, features);
+	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att,
+			ATTESTATION_FEATURE_EVIDENCE_ACCEPT), -EINVAL);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, features);
+	/* A child cannot enable a callback that its provider did not supply. */
+	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att,
+			features | ATTESTATION_FEATURE_DEVSEC_RUN), -EINVAL);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, features);
+	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att, 0), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, 0U);
+	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att,
+			ATTESTATION_FEATURE_EVIDENCE), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features,
+			(unsigned int)ATTESTATION_FEATURE_EVIDENCE);
+	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att, features), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, features);
+}
+
+static int attestation_test_tdisp_state(struct attestation *att,
+					enum attestation_tdisp_state *state)
+{
+	*state = ATTESTATION_TDISP_STATE_LOCKED;
+	return 0;
+}
+
+static int attestation_test_run(struct attestation *att)
+{
+	return 0;
+}
+
+static void attestation_test_secure_features(struct kunit *test)
+{
+	struct attestation_test *fixture = test->priv;
+	unsigned int evidence = ATTESTATION_FEATURE_EVIDENCE |
+				ATTESTATION_FEATURE_EVIDENCE_ACCEPT;
+	unsigned int state = ATTESTATION_FEATURE_TDISP_STATE;
+	unsigned int run = ATTESTATION_FEATURE_DEVSEC_RUN;
+
+	attestation_test_provider_init(fixture);
+	fixture->provider.tdisp_state_get = attestation_test_tdisp_state;
+	fixture->provider.devsec_run = attestation_test_run;
+	KUNIT_ASSERT_EQ(test, attestation_test_create_provider(
+				test, fixture, "attestation-secure-features"), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence | state | run);
+	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att, run), -EINVAL);
+	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att,
+			evidence | run), -EINVAL);
+	KUNIT_EXPECT_EQ(test, attestation_features_set(fixture->att,
+			state | run), -EINVAL);
+	/* Unlocked, locked, RUN, and host verdict-only capability sets. */
+	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att, state), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, state);
+	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att,
+			evidence | state | run), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence | state | run);
+	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att,
+			evidence | state), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence | state);
+	KUNIT_ASSERT_EQ(test, attestation_features_set(fixture->att, evidence), 0);
+	KUNIT_EXPECT_EQ(test, fixture->att->features, evidence);
+}
+
 static void attestation_test_initial_journal(struct kunit *test)
 {
 	struct attestation_test *fixture = test->priv;
@@ -594,6 +671,8 @@ static void attestation_test_kexec_ima_roundtrip(struct kunit *test)
 static struct kunit_case attestation_test_cases[] = {
 	KUNIT_CASE(attestation_test_provider_contracts),
 	KUNIT_CASE(attestation_test_initial_journal),
+	KUNIT_CASE(attestation_test_instance_features),
+	KUNIT_CASE(attestation_test_secure_features),
 	KUNIT_CASE(attestation_test_target_extension),
 	KUNIT_CASE(attestation_test_failed_extension),
 	KUNIT_CASE(attestation_test_state_change),
diff --git a/include/linux/attestation.h b/include/linux/attestation.h
index ae6ca4024b2a..dede1b53f67a 100644
--- a/include/linux/attestation.h
+++ b/include/linux/attestation.h
@@ -14,6 +14,15 @@ struct attestation_mr;
 struct ctlv_blob;
 struct ctlv_cursor;
 
+/* Per-instance subsets of the immutable provider's capabilities. */
+enum attestation_feature {
+	ATTESTATION_FEATURE_EVIDENCE = 1U << 0,
+	ATTESTATION_FEATURE_EVIDENCE_ACCEPT = 1U << 1,
+	ATTESTATION_FEATURE_TDISP_STATE = 1U << 2,
+	ATTESTATION_FEATURE_DEVICE_TRUST = 1U << 3,
+	ATTESTATION_FEATURE_DEVSEC_RUN = 1U << 4,
+};
+
 enum attestation_evidence_representation {
 	ATTESTATION_EVIDENCE_REPRESENTATION_RAW =
 		CTLV_ATTESTATION_EVIDENCE_REPRESENTATION_RAW,
@@ -285,4 +294,28 @@ void attestation_mr_destroy(struct attestation_mr *mr);
  */
 void attestation_state_changed(struct attestation *att);
 
+/**
+ * attestation_features_set_locked - Set enabled features with the mutex held.
+ * @att: attestation instance
+ * @features: features to enable
+ *
+ * The caller must hold the instance mutex.
+ * Update operation availability and DEVICE_GET capabilities together.
+ *
+ * Return: 0 on success, or -EINVAL if the requested features are unsupported
+ * or their dependencies are not satisfied.
+ */
+int attestation_features_set_locked(struct attestation *att, unsigned int features);
+
+/**
+ * attestation_features_set - Set enabled features.
+ * @att: attestation instance
+ * @features: features to enable
+ *
+ * Takes the instance mutex. Follow the same lock order as the CTLV pre-hook.
+ *
+ * Return: 0 on success, or -EINVAL for unsupported features or unmet dependencies.
+ */
+int attestation_features_set(struct attestation *att, unsigned int features);
+
 #endif /* _LINUX_ATTESTATION_H */
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
index dd558431324e..bccac87ea4fc 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
@@ -1552,7 +1552,7 @@ static const struct ctlv_op_spec ctlv_attestation_sim_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT,
 		.type = CTLV_OP_TYPE_ACTION,
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 64,
 		.request = &evidence_accept_request_node_schema,
@@ -1561,7 +1561,7 @@ static const struct ctlv_op_spec ctlv_attestation_sim_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
 		.type = CTLV_OP_TYPE_ACTION,
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 16,
 		.request = &evidence_accept_clear_request_node_schema,
@@ -1570,7 +1570,7 @@ static const struct ctlv_op_spec ctlv_attestation_sim_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_DEVSEC_STATE_GET,
 		.type = CTLV_OP_TYPE_QUERY,
 		.fd_access = CTLV_OP_FD_ACCESS_READ,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 16,
 		.query_reply_min_len = 40,
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
index 50bd181d0d15..3395c0ffc3e5 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
@@ -1568,7 +1568,7 @@ static const struct ctlv_op_spec ctlv_attestation_tdx_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT,
 		.type = CTLV_OP_TYPE_ACTION,
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 64,
 		.request = &evidence_accept_request_node_schema,
@@ -1577,7 +1577,7 @@ static const struct ctlv_op_spec ctlv_attestation_tdx_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
 		.type = CTLV_OP_TYPE_ACTION,
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 16,
 		.request = &evidence_accept_clear_request_node_schema,
@@ -1586,7 +1586,7 @@ static const struct ctlv_op_spec ctlv_attestation_tdx_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_DEVSEC_STATE_GET,
 		.type = CTLV_OP_TYPE_QUERY,
 		.fd_access = CTLV_OP_FD_ACCESS_READ,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 16,
 		.query_reply_min_len = 40,
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
index d62affc3a491..6a363b29f80b 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
@@ -1538,7 +1538,7 @@ static const struct ctlv_op_spec ctlv_attestation_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT,
 		.type = CTLV_OP_TYPE_ACTION,
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 64,
 		.request = &evidence_accept_request_node_schema,
@@ -1547,7 +1547,7 @@ static const struct ctlv_op_spec ctlv_attestation_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_EVIDENCE_ACCEPT_CLEAR,
 		.type = CTLV_OP_TYPE_ACTION,
 		.fd_access = CTLV_OP_FD_ACCESS_READ_WRITE,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 16,
 		.request = &evidence_accept_clear_request_node_schema,
@@ -1556,7 +1556,7 @@ static const struct ctlv_op_spec ctlv_attestation_op_specs[] = {
 		.op_id = CTLV_ATTESTATION_OP_DEVSEC_STATE_GET,
 		.type = CTLV_OP_TYPE_QUERY,
 		.fd_access = CTLV_OP_FD_ACCESS_READ,
-		.availability = CTLV_OP_AVAILABILITY_FIXED,
+		.availability = CTLV_OP_AVAILABILITY_DYNAMIC,
 		.optional = true,
 		.request_max_len = 16,
 		.query_reply_min_len = 40,
-- 
2.43.0

