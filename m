Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201231;
	b=rEUNDQsrNRIXSlSm+FJYlvGV7vT67HEf2JcoekDyUF1SQeomPaJkgaV8Q9EBGBz/EJlg
	 w9KmnrkGnK946l6rM5anwphbxpqoyft4LrO7P78cF0BHYj/WNQMOTPg50KM7QaE8utAJv
	 d4xc8I7eqoWb+eHgsCLtwcEreq6XRBZ5DPYGfGiWOfBOD9eTCLiC8UrjPRqrSghxMNsQt
	 0H2cOk5PPxWKnXkV+yhl9AHwd1G0CEgADV6l3zXvLrqWtpIMO3N3hl4vnPkv3tBUIa5gG
	 qerkW3DDQj9Yh7SuANEHkpf/x1RWFwWy2Wx897r4PHy9asEtWkr1G6XeTOLbPJx/F8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XDAHlEHK4fF2DgOqbqjtILNzcyY4pg2z31ZIES92ppU=;
	b=tb6XMn61nZb2hCfw8Hkf6AsCHTHWAiq2OHfWNWLbMkQMfs327hCT3PzdoQax/7MmNkpc
	 EulDb56LQIH7V7YWIgSRapZH6rlmDbUW5Uf2/PSwDs9xlp9uF/gJsiVoMB/137SzTwxgu
	 THN7i8gb38Ad8a3udxCWbs80p47JRLCREvTmg2WHryvqs1Q3L6GDC20o5cFH3h0jgH6bx
	 igrcQ1CyaYwXw77sEZQUMvGmneL80XPa4vmw32q5PgZxPHJIdTB25qHQ25rsDtKvPYsSP
	 ZfEi+RH7J1lCnZykAjlPJKwsXxQCL4pekXqxFHkGNMkNTmpde0X2HJrQC6yf7V00GGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nOm6CYwu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE63606A324;
	Wed, 28 Oct 2026 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nOm6CYwu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4361F01825;
	Wed, 28 Oct 2026 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201231;
	bh=XDAHlEHK4fF2DgOqbqjtILNzcyY4pg2z31ZIES92ppU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOm6CYwu76DAugTYpEHqglLICnbK1XgHYLImJeZZAIlfAJX0p51PC17FkggNUZJjQ
	 eO1Vi8n12ToyBe7TlnhP04jc9rmF8/+BSlPDkIWTXN0u0IzFsRRy63XLOt84xc6hro
	 XytGJJozmAMEWJgnfhl4ze6u+OSbNNHj5tsezQ9+2L+Qsw0dMm/223i1VtTZJ2W9O0
	 fWqQZt5mnbeDvGDLPPzLDl40dk75c0waxYISVvWqqBPiNA2v7/6hUtctFoLXkro7F8
	 ON/GxNkKU2mcgcTHwxlqrfJhd8i11vqKVMLQNRe6rIRZukeR3aRvOHM1V8x6uCjdSL
	 1OFIdphPdtZLQ==
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
Subject: [RFC PATCH v1 05/11] attestation: Make the evidence-get challenge attribute optional
Date: Wed, 28 Oct 2026 20:56:12 +0530
Message-ID: <20261028152618.1356860-6-aneesh.kumar@kernel.org>
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

The following PCI/TSM integration retrieves cached evidence through
EVIDENCE_GET. A challenge is used when refreshing that evidence, not
when reading the current cache, so requiring evidence.challenge forces
callers to supply an otherwise unused empty attribute.

Make evidence.challenge optional in the common request schema.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ctlv/abi/ctlv-attestation.yaml  |  2 +-
 .../ctlv/specs/ctlv-attestation.yaml          |  2 +-
 Documentation/driver-api/attestation.rst      | 12 ++++++++++
 drivers/attestation/core/ctlv.c               |  7 +++---
 .../generated/ctlv_attestation_gen.c          |  4 ++--
 .../generated/ctlv_attestation_gen.h          | 22 +++++++++----------
 .../selftests/attestation/attestation_test.c  |  4 +---
 .../ctlv_attestation_sim_user_gen.c           | 20 ++++++++---------
 .../ctlv_attestation_tdx_user_gen.c           | 20 ++++++++---------
 .../attestation/ctlv_attestation_user_gen.c   | 20 ++++++++---------
 .../attestation/tdx_attestation_test.c        |  9 ++++++--
 11 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/Documentation/ctlv/abi/ctlv-attestation.yaml b/Documentation/ctlv/abi/ctlv-attestation.yaml
index 018417fe3682..373614f97021 100644
--- a/Documentation/ctlv/abi/ctlv-attestation.yaml
+++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
@@ -172,12 +172,12 @@ ops:
     abi: {id: 2, type: action, availability: dynamic, optional: true}
     request:
       attrs:
-        - evidence.challenge
         - evidence.object:
             attrs: [evidence.blob-class, evidence.format,
                     evidence.representation, evidence.data]
             optional-attrs: [evidence.blob-instance, evidence.hash-algo]
       optional-attrs:
+        - evidence.challenge
         - device.generation
         - evidence.selection: {attrs: [mr.id, evidence.hash-algo]}
         - evidence.privlevel
diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
index 98d6753d878f..e2371813ec25 100644
--- a/Documentation/ctlv/specs/ctlv-attestation.yaml
+++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
@@ -320,9 +320,9 @@ attr-sets:
 
   - name: evidence-request
     attrs:
-      - evidence.challenge
       - evidence.object
     optional-attrs:
+      - evidence.challenge
       - device.generation
       - evidence.selection
       - evidence.privlevel
diff --git a/Documentation/driver-api/attestation.rst b/Documentation/driver-api/attestation.rst
index 06af8df23a46..d23b7c65d35b 100644
--- a/Documentation/driver-api/attestation.rst
+++ b/Documentation/driver-api/attestation.rst
@@ -29,6 +29,18 @@ dynamic topology retains handles returned by ``attestation_mr_create()`` and
 passes each handle exactly once to ``attestation_mr_destroy()``.  Property
 storage remains valid for the handle's lifetime.
 
+Evidence retrieval
+==================
+
+``EVIDENCE_GET`` requests may omit ``evidence.challenge``. The core treats
+an omitted challenge as zero bytes and still enforces the provider's minimum
+and maximum challenge lengths. Providers that require a challenge, such as
+TDX, retain that requirement.
+
+Cached-evidence providers such as PCI/TSM can fetch the current evidence
+without a challenge. A challenge for fresh PCI/TSM evidence belongs to the
+separate evidence-refresh operation.
+
 Per-instance features
 =====================
 
diff --git a/drivers/attestation/core/ctlv.c b/drivers/attestation/core/ctlv.c
index f0238c4c4cf2..50aa3cb84ddd 100644
--- a/drivers/attestation/core/ctlv.c
+++ b/drivers/attestation/core/ctlv.c
@@ -350,13 +350,14 @@ static int attestation_evidence_request_decode(struct attestation *att, struct c
 					       struct ctlv_cursor *options)
 {
 	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
-	u32 challenge_length, guid_length;
+	u32 challenge_length = 0, guid_length;
 	const void *guid;
 	bool service;
 	int ret;
 
-	decoded->challenge =
-		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
+	if (ctlv_attestation_evidence_get_evidence_challenge_present(request))
+		decoded->challenge = ctlv_attestation_evidence_get_evidence_challenge_get(
+			request, &challenge_length);
 	decoded->challenge_length = challenge_length;
 	if (challenge_length < caps->min_challenge_length ||
 	    challenge_length > caps->max_challenge_length)
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.c b/drivers/attestation/generated/ctlv_attestation_gen.c
index a858a84da135..0bd4bc76b718 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.c
+++ b/drivers/attestation/generated/ctlv_attestation_gen.c
@@ -49,9 +49,9 @@ static const struct ctlv_stub_schema device_get_reply_stub_schemas[] = {
 };
 
 static const struct ctlv_node_schema evidence_get_request_node_schemas[] = {
-	CTLV_NODE_SCHEMA_ROOT(1, 9, 2),
-	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE, 1, 0, 4096),
+	CTLV_NODE_SCHEMA_ROOT(1, 9, 1),
 	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT, 16, 10, 6, 4),
+	CTLV_NODE_SCHEMA_BINARY(CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE, 1, 0, 4096),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 1, 0, U32_MAX),
 	CTLV_NODE_SCHEMA_NEST(CTLV_ATTESTATION_ATTR_EVIDENCE_SELECTION, 256, 16, 2, 2),
 	CTLV_NODE_SCHEMA_UINT(CTLV_ATTESTATION_ATTR_EVIDENCE_PRIVLEVEL, 1, 0, U32_MAX),
diff --git a/drivers/attestation/generated/ctlv_attestation_gen.h b/drivers/attestation/generated/ctlv_attestation_gen.h
index 95cb6a083633..bd55158d8819 100644
--- a/drivers/attestation/generated/ctlv_attestation_gen.h
+++ b/drivers/attestation/generated/ctlv_attestation_gen.h
@@ -81,15 +81,15 @@ CTLV_OP_DISABLE(ctlv_attestation_devsec_state_get, CTLV_ATTESTATION_OP_DEVSEC_ST
 CTLV_OP_PROVIDE(ctlv_attestation_mr_log_get, CTLV_ATTESTATION_OP_MR_LOG_GET)
 
 /* Reading a validated message. A blob has a resolver instead of a getter. */
+CTLV_IN_REF(ctlv_attestation_evidence_get_evidence_object, &ctlv_attestation_op_schemas[1].request,
+	    CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT, 0, 0, CTLV_SCHEMA_NEST)
+#define ctlv_attestation_evidence_get_evidence_object_for_each(_attr, _nest) \
+	CTLV_IN_FOR_EACH(ctlv_attestation_evidence_get_evidence_object, _attr, _nest)
 CTLV_IN_REF(ctlv_attestation_evidence_get_evidence_challenge,
-	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE, 0, 0,
+	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE, 0, 1,
 	    CTLV_SCHEMA_BINARY)
 CTLV_IN_HAS(ctlv_attestation_evidence_get_evidence_challenge)
 CTLV_IN_BINARY(ctlv_attestation_evidence_get_evidence_challenge)
-CTLV_IN_REF(ctlv_attestation_evidence_get_evidence_object, &ctlv_attestation_op_schemas[1].request,
-	    CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT, 0, 1, CTLV_SCHEMA_NEST)
-#define ctlv_attestation_evidence_get_evidence_object_for_each(_attr, _nest) \
-	CTLV_IN_FOR_EACH(ctlv_attestation_evidence_get_evidence_object, _attr, _nest)
 CTLV_IN_REF(ctlv_attestation_evidence_get_device_generation,
 	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_DEVICE_GENERATION, 0, 2,
 	    CTLV_SCHEMA_UINT)
@@ -125,32 +125,32 @@ CTLV_IN_REF(ctlv_attestation_evidence_get_evidence_options, &ctlv_attestation_op
 CTLV_IN_HAS(ctlv_attestation_evidence_get_evidence_options)
 CTLV_IN_NEST(ctlv_attestation_evidence_get_evidence_options)
 CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_blob_class,
-	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS, 2,
+	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_CLASS, 1,
 	    0, CTLV_SCHEMA_ENUM)
 CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_blob_class)
 CTLV_IN_U64(ctlv_attestation_evidence_get_object_evidence_blob_class)
 CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_format,
-	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT, 2, 1,
+	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_FORMAT, 1, 1,
 	    CTLV_SCHEMA_STRING)
 CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_format)
 CTLV_IN_STRING(ctlv_attestation_evidence_get_object_evidence_format)
 CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_representation,
 	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_REPRESENTATION,
-	    2, 2, CTLV_SCHEMA_ENUM)
+	    1, 2, CTLV_SCHEMA_ENUM)
 CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_representation)
 CTLV_IN_U64(ctlv_attestation_evidence_get_object_evidence_representation)
 CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_data,
-	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_DATA, 2, 3,
+	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_DATA, 1, 3,
 	    CTLV_SCHEMA_BLOB)
 CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_data)
 CTLV_IN_BLOB(ctlv_attestation_evidence_get_object_evidence_data)
 CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_blob_instance,
 	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_BLOB_INSTANCE,
-	    2, 4, CTLV_SCHEMA_UINT)
+	    1, 4, CTLV_SCHEMA_UINT)
 CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_blob_instance)
 CTLV_IN_U64(ctlv_attestation_evidence_get_object_evidence_blob_instance)
 CTLV_IN_REF(ctlv_attestation_evidence_get_object_evidence_hash_algo,
-	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_HASH_ALGO, 2, 5,
+	    &ctlv_attestation_op_schemas[1].request, CTLV_ATTESTATION_ATTR_EVIDENCE_HASH_ALGO, 1, 5,
 	    CTLV_SCHEMA_UINT)
 CTLV_IN_HAS(ctlv_attestation_evidence_get_object_evidence_hash_algo)
 CTLV_IN_U64(ctlv_attestation_evidence_get_object_evidence_hash_algo)
diff --git a/tools/testing/selftests/attestation/attestation_test.c b/tools/testing/selftests/attestation/attestation_test.c
index bd831b0ef14f..40be7fd0c492 100644
--- a/tools/testing/selftests/attestation/attestation_test.c
+++ b/tools/testing/selftests/attestation/attestation_test.c
@@ -374,15 +374,13 @@ TEST_F(attestation, extension_record_log_and_event)
 static int evidence_get(struct ctlv_dev *dev, void *output, size_t output_length,
 			struct ctlv_reply **reply, struct ctlv_error *error)
 {
-	static const unsigned char challenge[] = "freshness";
 	struct ctlv_msg *request;
 	int ret;
 
 	ret = ctlv_attestation_evidence_get_request_new(&request);
 	if (ret)
 		return ret;
-	ctlv_attestation_evidence_challenge_put(
-		request, challenge, sizeof(challenge) - 1);
+	/* Providers with a zero minimum accept an omitted challenge. */
 	ctlv_attestation_evidence_object_start(request);
 	ctlv_attestation_evidence_blob_class_put(
 		request, CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_PRIMARY);
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
index 795cf514c761..89b7db4df55b 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_sim_user_gen.c
@@ -279,14 +279,6 @@ static const struct ctlv_node_schema evidence_get_request_selection_attr_node_sc
 
 /* root, attrs */
 static const struct ctlv_node_schema evidence_get_request_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
-		.kind = CTLV_SCHEMA_BINARY,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
-		.min_length = 0,
-		.max_length = 4096,
-	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT,
 		.kind = CTLV_SCHEMA_NEST,
@@ -300,6 +292,14 @@ static const struct ctlv_node_schema evidence_get_request_attr_node_schemas[] =
 
 /* root, optional attrs */
 static const struct ctlv_node_schema evidence_get_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 4096,
+	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
 		.kind = CTLV_SCHEMA_UINT,
@@ -359,9 +359,9 @@ static const struct ctlv_node_schema evidence_get_request_node_schema = {
 	.kind = CTLV_SCHEMA_NEST,
 	.max_occurrences = 1,
 	.attrs = evidence_get_request_attr_node_schemas,
-	.attrs_count = 2,
+	.attrs_count = 1,
 	.optional_attrs = evidence_get_request_optional_attr_node_schemas,
-	.optional_attrs_count = 7,
+	.optional_attrs_count = 8,
 };
 
 /* root, attrs */
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
index 787edd7d8ce4..cdf54af49a81 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_tdx_user_gen.c
@@ -295,14 +295,6 @@ static const struct ctlv_node_schema evidence_get_request_selection_attr_node_sc
 
 /* root, attrs */
 static const struct ctlv_node_schema evidence_get_request_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
-		.kind = CTLV_SCHEMA_BINARY,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
-		.min_length = 0,
-		.max_length = 4096,
-	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT,
 		.kind = CTLV_SCHEMA_NEST,
@@ -316,6 +308,14 @@ static const struct ctlv_node_schema evidence_get_request_attr_node_schemas[] =
 
 /* root, optional attrs */
 static const struct ctlv_node_schema evidence_get_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 4096,
+	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
 		.kind = CTLV_SCHEMA_UINT,
@@ -375,9 +375,9 @@ static const struct ctlv_node_schema evidence_get_request_node_schema = {
 	.kind = CTLV_SCHEMA_NEST,
 	.max_occurrences = 1,
 	.attrs = evidence_get_request_attr_node_schemas,
-	.attrs_count = 2,
+	.attrs_count = 1,
 	.optional_attrs = evidence_get_request_optional_attr_node_schemas,
-	.optional_attrs_count = 7,
+	.optional_attrs_count = 8,
 };
 
 /* root, attrs */
diff --git a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
index b278511f5776..077f8c7fbc81 100644
--- a/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
+++ b/tools/testing/selftests/attestation/ctlv_attestation_user_gen.c
@@ -265,14 +265,6 @@ static const struct ctlv_node_schema evidence_get_request_selection_attr_node_sc
 
 /* root, attrs */
 static const struct ctlv_node_schema evidence_get_request_attr_node_schemas[] = {
-	{
-		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
-		.kind = CTLV_SCHEMA_BINARY,
-		.max_occurrences = 1,
-		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
-		.min_length = 0,
-		.max_length = 4096,
-	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_OBJECT,
 		.kind = CTLV_SCHEMA_NEST,
@@ -286,6 +278,14 @@ static const struct ctlv_node_schema evidence_get_request_attr_node_schemas[] =
 
 /* root, optional attrs */
 static const struct ctlv_node_schema evidence_get_request_optional_attr_node_schemas[] = {
+	{
+		.attr_id = CTLV_ATTESTATION_ATTR_EVIDENCE_CHALLENGE,
+		.kind = CTLV_SCHEMA_BINARY,
+		.max_occurrences = 1,
+		.present = CTLV_NODE_SCHEMA_HAS_MIN_LENGTH | CTLV_NODE_SCHEMA_HAS_MAX_LENGTH,
+		.min_length = 0,
+		.max_length = 4096,
+	},
 	{
 		.attr_id = CTLV_ATTESTATION_ATTR_DEVICE_GENERATION,
 		.kind = CTLV_SCHEMA_UINT,
@@ -345,9 +345,9 @@ static const struct ctlv_node_schema evidence_get_request_node_schema = {
 	.kind = CTLV_SCHEMA_NEST,
 	.max_occurrences = 1,
 	.attrs = evidence_get_request_attr_node_schemas,
-	.attrs_count = 2,
+	.attrs_count = 1,
 	.optional_attrs = evidence_get_request_optional_attr_node_schemas,
-	.optional_attrs_count = 7,
+	.optional_attrs_count = 8,
 };
 
 /* root, attrs */
diff --git a/tools/testing/selftests/attestation/tdx_attestation_test.c b/tools/testing/selftests/attestation/tdx_attestation_test.c
index a06315af2021..1a370a529f50 100644
--- a/tools/testing/selftests/attestation/tdx_attestation_test.c
+++ b/tools/testing/selftests/attestation/tdx_attestation_test.c
@@ -165,8 +165,9 @@ static int tdx_evidence_get(struct ctlv_dev *dev, const char *format,
 	ret = ctlv_attestation_evidence_get_request_new(&request);
 	if (ret)
 		return ret;
-	ctlv_attestation_evidence_challenge_put(request, challenge,
-						challenge_length);
+	if (challenge)
+		ctlv_attestation_evidence_challenge_put(request, challenge,
+							challenge_length);
 	ctlv_attestation_evidence_object_start(request);
 	ctlv_attestation_evidence_blob_class_put(request,
 						 CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_PRIMARY);
@@ -244,6 +245,10 @@ TEST_F(tdx_attestation, common_validation_precedes_native_calls)
 	struct ctlv_reply *reply;
 	struct ctlv_msg *request;
 
+	EXPECT_EQ(-EINVAL,
+		  tdx_evidence_get(self->dev, "tdx-tdreport-1.0", NULL, 0,
+				   report.bytes, sizeof(report.bytes), &reply,
+				   &self->error));
 	EXPECT_EQ(-EINVAL,
 		  tdx_evidence_get(self->dev, "tdx-tdreport-1.0", challenge,
 				   sizeof(challenge) - 1, report.bytes,
-- 
2.43.0

