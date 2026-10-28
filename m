Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201249;
	b=FiipiwOVG3efLdA/j/4yrZ6J0eVbAVIXoru49da/CVNXMKusOryqjFV62SRyhUgYGRfG
	 /2B782NtALjuoYaJhG3B5cGxylm8Ccdsmm8ukj/Ex+clMzZBfAu1mX0U6tL1XTRQO83D0
	 ZxXB4fQbc30ASqsHi+U2f5651PCoagghETxrfqaOrOKY0s+QJv+/sCbJIRSI8N9XSdZT8
	 +bscbYDCsoAGSvjvEs2sVaIe9R2J0jF8kakiXSe0NeMBDaEo0glDzvvFTdLlPV3SM5M0i
	 h2jDx2ZtLbSA4Ygxh/VfMlDFeG2QUOcPAWG8x6l1XRzoJZ4rULGcJO21XBNsT6Cllhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qVnowDELd7CRQ8NYhgfuPmEIlYngDtzfuyXyIF1DOss=;
	b=UWken+01uCTidQV9Q0qZt/Cc4tvfVdxxp/6l2r5BD1dmBY6DqvENCUks14Z3T+JVfqB9
	 XHf38gsJdtbb2tipqxRYd0DrThRW9DKI/RtkCoXdlAbqrm+/k+GCEWWvwvy5Xb3r8bJNL
	 YOY3A9rGtsxVYVHdUb+yAAEsTZmPvis95TL9T2xwG5FIS2D4MTcY96PzvR5YoVX+FvYsJ
	 +3QHSLprFl+Jbw0kBz49mUNY7A0trfdJ0U4e5qkIkSwVzPML+X3dygfjYkEmEpGPD5VOs
	 AhZ4Bsr5hiARLH7PPWeRPYld34mzyABWHw4/myEZK6WYZU/n2RYm/kx6zfZO6TbRZWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ntCgSyXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE78606A31C;
	Wed, 28 Oct 2026 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ntCgSyXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091161F01829;
	Wed, 28 Oct 2026 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201248;
	bh=qVnowDELd7CRQ8NYhgfuPmEIlYngDtzfuyXyIF1DOss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntCgSyXlcAIpcVk295G326I54wO62mYtx6EcROPIx8/Esh+wlHIPqxQ73ck8RgZrD
	 8EqsFJAGCjmL45UQrZPH/9ZIKV40bOxHGoIM/gxMEdsYfqjz9zIj11f8kQ2ZYpiow/
	 +TS2lQxsAteER5S9+yF/4AkF3VC7JgGxGvWPx15p17zw5POD1Z5i4hg/gDHIUy3375
	 j3ZWrsvliCSnXrmT2E4b6SkYesnT637ZvpXUntXeCz8g+/++2nc5L6YVIgs/rCj1XH
	 81DetiV2eM3dz6c092c7v0vDwXDc+JWKkotUUiwiutSzMiACu5W0bLKnwzkGLLu4mD
	 WdsqgxvJCocCA==
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
Subject: [RFC PATCH v1 07/11] attestation: Add attestation helpers for PCI/TSM integration
Date: Wed, 28 Oct 2026 20:56:14 +0530
Message-ID: <20261028152618.1356860-8-aneesh.kumar@kernel.org>
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

Add helpers that let the following PCI/TSM patch coordinate device state
changes with attestation state.

PCI child-family operations use ctlv_attestation_op_pre() to acquire the
attestation lock before invoking the backend. They need to validate the
requested device generation before changing state and invalidating
previous evidence.

The existing attestation_state_changed() takes the attestation lock itself.
Factor out a locked variant so those operations can report a state
change without acquiring the same mutex again.

Also expose helpers to check for device-generation overflow, read the
current device generation, and acquire the instance mutex for notifications
outside CTLV dispatch.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/attestation/core/core.c | 40 +++++++++++++++++++++++++---
 include/linux/attestation.h     | 47 +++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/attestation/core/core.c b/drivers/attestation/core/core.c
index 914f29693aee..e35c45bc715d 100644
--- a/drivers/attestation/core/core.c
+++ b/drivers/attestation/core/core.c
@@ -430,14 +430,13 @@ void attestation_mr_destroy(struct attestation_mr *mr)
 }
 EXPORT_SYMBOL_NS_GPL(attestation_mr_destroy, "ATTESTATION");
 
-void attestation_state_changed(struct attestation *att)
+void attestation_state_changed_locked(struct attestation *att)
 {
 	struct attestation_event_batch events = {};
 	bool evidence;
 	int ret;
 
-	guard(mutex)
-		(&att->lock);
+	lockdep_assert_held(&att->lock);
 	if (!attestation_registered(att))
 		return;
 	evidence = att->evidence_generation > att->evidence_floor || att->verdict_recorded;
@@ -458,8 +457,43 @@ void attestation_state_changed(struct attestation *att)
 		attestation_evidence_event_emit(&events, att);
 	attestation_events_abort(&events);
 }
+EXPORT_SYMBOL_NS_GPL(attestation_state_changed_locked, "ATTESTATION");
+
+void attestation_state_changed(struct attestation *att)
+{
+	guard(mutex)(&att->lock);
+	attestation_state_changed_locked(att);
+}
 EXPORT_SYMBOL_NS_GPL(attestation_state_changed, "ATTESTATION");
 
+void attestation_lock(struct attestation *att)
+{
+	mutex_lock(&att->lock);
+}
+EXPORT_SYMBOL_NS_GPL(attestation_lock, "ATTESTATION");
+
+void attestation_unlock(struct attestation *att)
+{
+	mutex_unlock(&att->lock);
+}
+EXPORT_SYMBOL_NS_GPL(attestation_unlock, "ATTESTATION");
+
+int attestation_state_change_prepare(struct attestation *att)
+{
+	lockdep_assert_held(&att->lock);
+	if (!attestation_registered(att))
+		return -ENODEV;
+	return attestation_preflight(att, true, false, false);
+}
+EXPORT_SYMBOL_NS_GPL(attestation_state_change_prepare, "ATTESTATION");
+
+unsigned int attestation_get_device_generation(struct attestation *att)
+{
+	lockdep_assert_held(&att->lock);
+	return att->device_generation;
+}
+EXPORT_SYMBOL_NS_GPL(attestation_get_device_generation, "ATTESTATION");
+
 static unsigned int attestation_provider_features(const struct attestation_provider *provider)
 {
 	unsigned int features = 0;
diff --git a/include/linux/attestation.h b/include/linux/attestation.h
index 09ebd2af3a1e..0dae626b2e0e 100644
--- a/include/linux/attestation.h
+++ b/include/linux/attestation.h
@@ -299,6 +299,53 @@ void attestation_mr_destroy(struct attestation_mr *mr);
  */
 void attestation_state_changed(struct attestation *att);
 
+/**
+ * attestation_lock - Lock the attestation instance.
+ * @att: attestation instance
+ *
+ * CTLV operations already hold this mutex. Other callers must follow the
+ * same lock order as the provider's CTLV pre-hook.
+ * Do not call while holding an attestation instance mutex.
+ */
+void attestation_lock(struct attestation *att);
+
+/**
+ * attestation_unlock - Release the attestation instance mutex.
+ * @att: attestation instance locked by attestation_lock()
+ */
+void attestation_unlock(struct attestation *att);
+
+/**
+ * attestation_state_change_prepare - Check whether device state can change.
+ * @att: attestation instance
+ *
+ * Call with the instance mutex held, before changing device state.
+ *
+ * Return: 0 on success, -ENODEV if the instance is no longer registered,
+ * or -EOVERFLOW if the device generation cannot be incremented.
+ */
+int attestation_state_change_prepare(struct attestation *att);
+
+/**
+ * attestation_state_changed_locked - Report a device state change.
+ * @att: attestation instance
+ *
+ * Call with the instance mutex held.
+ *
+ * Advance the device generation, invalidate previous evidence and acceptance
+ * verdicts, and emit state-change events. Invalidation still occurs if
+ * allocating the events fails.
+ */
+void attestation_state_changed_locked(struct attestation *att);
+
+/**
+ * attestation_get_device_generation - Read the device generation.
+ * @att: attestation instance
+ *
+ * The caller must hold the instance mutex.
+ */
+unsigned int attestation_get_device_generation(struct attestation *att);
+
 /**
  * attestation_features_set_locked - Set enabled features with the mutex held.
  * @att: attestation instance
-- 
2.43.0

