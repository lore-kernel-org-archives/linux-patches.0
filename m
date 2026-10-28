Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201208;
	b=AKOlxECAogYxnskSVbFRC6LAyfrzAs+u2IsLub9uZAdgzPejx1gegiQrtyyafG6CN3db
	 tYZvsxWcu4rxRpQBUWTGy8qK+xjpHpYuzwCyzqx/1vom7Gi8AURlAJ12NH2n24uYgNjaW
	 GAwSJGwiJyVt7mOgBXerVYT/UPxDWp8pPqMocLxNq8SuvY6UHNlynHxgN9YeLGYET6C4D
	 4jW4uSYHl1e3rWHnBrbxFdcmAo8ZV+fg2NMultLe4nOuWgX5F2rBbJWC73z+KLiWPOivF
	 ccn2ksNYnF/SdRg/P+jb0HXUhCfii4989BYGATVVyVtKqOeyI5veaO5wxED5IP4y5yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VMYVFP/GDnj0bo/gDtuwt8seFSsnprbpSbN4tmF/aVg=;
	b=oDPfHIrBhPMk8YO+X8lyWTzB9EOAsYiWPYCh19roB/fKcroOrad4fvXMu55GFSTEc1Ai
	 6gPM0poF6Iyqy4EaevO8m1xQq0lZprkytyxg2zEU8WlURNpQr1nY8h07WOESM5yJNvg+Y
	 cKEtNjoCgecCbLlt7D6Uq3256HncXLBueogKwzDJ8lPzuJIEd905R4p2Wp8U4NdbTyLs+
	 TeR+xr1amITkUIkzuP037/qipoXogJAqXCd31JETao5jvVQtiNgBoiTHNhCEaUSUJc68I
	 WFjR/XDeGezCfNr6GivMOwhFNyn8KrXUtiH/HZ4JHpLxl1AIX4YK8zgs64fTHTPzLZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OMg7qjx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B9C606A31E;
	Wed, 28 Oct 2026 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OMg7qjx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C3E1F031E3;
	Wed, 28 Oct 2026 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201207;
	bh=VMYVFP/GDnj0bo/gDtuwt8seFSsnprbpSbN4tmF/aVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMg7qjx4spxLKuVYA/ireOIJV7OHkiIv4AtOGMznur9ORyoprcYuN8YGwoN60iNjz
	 1N2cyn/hOgJzTnzqpvKYALuQew034xwI23KQNTbt3GTGO1diyWcUDNgowzCXXGlumC
	 kkTbyL2v3xsQ7nIiYQ8A14QzNewpQeEUNyBypw7wFKwxeZjcsKpWBCS936BbRAroL8
	 OHoS+89YZmWU6nzOYmtkl1Bqb4Db+lJLgvVocbanhoAL+haBN0u5bsEgHkX7SvSutm
	 2l/4BXCrtGHnMB8K6ArCW2dFHPnUPV9zwk/U9sszn/gJdpP7B4g//cTZK5trpWdfXZ
	 XNTQMtgIwQmiw==
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
Subject: [RFC PATCH v1 02/11] attestation: Filter evidence objects per instance
Date: Wed, 28 Oct 2026 20:56:09 +0530
Message-ID: <20261028152618.1356860-3-aneesh.kumar@kernel.org>
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

Allow an attestation instance to expose only the evidence objects its
device supports. Add an optional evidence_object_supported() callback
and use it both when building DEVICE_GET capabilities and when checking
EVIDENCE_GET requests.

The following PCI/TSM patch uses one attestation implementation for
devices that support different evidence objects. Its list includes
certificate slots 0-7, SPDM VCA, measurements, and a TDISP interface
report. Each device must expose only the objects it supports, for
example:

  Instance                  Supported evidence objects
  ------------------------  ------------------------------------------
  Host link using slot zero Certificate slot 0
  CCA guest device          Certificate slot 0, VCA, measurements,
                            TDISP interface report
  Host PF0 after discovery  Certificate slots reported populated by SPDM

PCI/TSM checks the TSM driver's evidence_types bitmap or, after SPDM
discovery on a host PF0, the populated-slot bitmap. The preceding patch
controls whether EVIDENCE_GET is enabled; this patch controls which
objects that operation can retrieve.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/attestation/core/core.c |  8 ++++++--
 drivers/attestation/core/ctlv.c | 13 +++++++++++--
 include/linux/attestation.h     |  4 ++++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/attestation/core/core.c b/drivers/attestation/core/core.c
index 41fe1084c989..37d5d3233cf0 100644
--- a/drivers/attestation/core/core.c
+++ b/drivers/attestation/core/core.c
@@ -54,8 +54,12 @@ static int attestation_evidence_caps_validate(const struct attestation_provider
 	const struct attestation_evidence_caps *caps = provider->evidence_caps;
 	size_t object_index;
 
-	if (!caps)
-		return provider->evidence_get ? -EINVAL : 0;
+	if (!caps) {
+		if (provider->evidence_get || provider->evidence_object_supported)
+			return -EINVAL;
+		return 0;
+	}
+
 	if (!provider->evidence_get || !caps->objects || !caps->objects_count ||
 	    caps->objects_count > 16 || caps->min_challenge_length > caps->max_challenge_length ||
 	    caps->max_challenge_length > 4096 || !caps->max_total_output_length)
diff --git a/drivers/attestation/core/ctlv.c b/drivers/attestation/core/ctlv.c
index 8f4fa48ffdc5..baf9c39f2658 100644
--- a/drivers/attestation/core/ctlv.c
+++ b/drivers/attestation/core/ctlv.c
@@ -33,15 +33,20 @@ attestation_representation_in(const struct attestation_evidence_supported_object
 }
 
 static const struct attestation_evidence_supported_object *
-attestation_evidence_object_find(const struct attestation_evidence_caps *caps,
+attestation_evidence_object_find(struct attestation *att,
 				 enum attestation_evidence_blob_class blob_class, bool has_instance,
 				 unsigned int instance, const char *format)
 {
+	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
 	size_t index;
 
 	for (index = 0; index < caps->objects_count; index++) {
 		const struct attestation_evidence_supported_object *object = &caps->objects[index];
 
+		if (att->provider->evidence_object_supported &&
+		    !att->provider->evidence_object_supported(att, object))
+			continue;
+
 		if (object->blob_class == blob_class && object->has_blob_instance == has_instance &&
 		    (!has_instance || object->blob_instance == instance) &&
 		    !strcmp(object->format, format))
@@ -85,6 +90,10 @@ static int attestation_device_caps_put(struct attestation *att, struct ctlv_curs
 			const struct attestation_evidence_supported_object *cap =
 				&caps->objects[index];
 
+			if (provider->evidence_object_supported &&
+			    !provider->evidence_object_supported(att, cap))
+				continue;
+
 			if (!ctlv_attestation_cap_object_start(&group, &object)) {
 				ok = false;
 				break;
@@ -184,7 +193,7 @@ attestation_evidence_decode_objects(struct attestation *att, struct ctlv_op_ctx
 		if (has_instance)
 			instance = ctlv_attestation_evidence_get_object_evidence_blob_instance_get(
 				&object);
-		supported = attestation_evidence_object_find(caps, blob_class, has_instance,
+		supported = attestation_evidence_object_find(att, blob_class, has_instance,
 							     instance, format);
 		if (!supported || !attestation_representation_in(supported, representation)) {
 			kfree(objects);
diff --git a/include/linux/attestation.h b/include/linux/attestation.h
index dede1b53f67a..364ab5029277 100644
--- a/include/linux/attestation.h
+++ b/include/linux/attestation.h
@@ -233,6 +233,8 @@ struct attestation_evidence_result {
 
 /**
  * struct attestation_provider - Immutable provider operations and properties.
+ * @evidence_object_supported: optionally restrict advertised and requested
+ *	evidence objects per instance; called under the instance lock
  * @evidence_get: produce requested evidence
  * @evidence_accept: record acceptance of the current evidence
  * @evidence_accept_clear: clear a recorded acceptance
@@ -247,6 +249,8 @@ struct attestation_evidence_result {
  * @mrs_count: number of fixed MRs
  */
 struct attestation_provider {
+	bool (*evidence_object_supported)(struct attestation *att,
+		const struct attestation_evidence_supported_object *object);
 	int (*evidence_get)(struct attestation *att,
 			    const struct attestation_evidence_request *request,
 			    struct attestation_evidence_result *result);
-- 
2.43.0

