Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201281;
	b=hfJgzOu+OVE3DRXLB0psksuv5H62y6qeswLplItjp4MDlbdzIbXaJhkZR5lyZBNxga0Q
	 0b+DRdsx51NpA9eKFbLTn68GmEO3COU2tmxaWEdNV38Q5WB9m3RwZHCg71d6l84l2E57A
	 eyIGU25A+GfGVVfy70HlnFtZXdq08OJrUkxAlW5KfCEy8B5hFysU3VRrTlEtxGTrtllZt
	 Gc2O9FrV1+tFlY8FLilJInhr/eLgAE631+Fxcg2xOBdEyA+Qj7LDF79fStFwtPnU5nuCW
	 M18HDOV1Bv2C6lZGPPWoQUxPoTFRX5n3XC1UlI0pLwoy3XSlol4hp0tsTEiZYrTR9wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fQ5ICJZvo9sE1f7Ztr4VxqbPBKy2FoRlGzIcYO9hGjg=;
	b=vXiTejOjDM5LmH/GNvLpguzDNtpg81O8vN4ERYoLzMUGVk04Ikm1YfKkBgMXQ9A4srwg
	 9PP9tKGbfwiCfquQ3ipNMcJbENVqY7ZW3HyHtx/0XnSrZgK/30QQv1PHXi8agSVR7VyUR
	 eITAbsbasfFv2AtNz7hkOKHlUhTJHgMm+j6NOne1O2mtHUuEJC84X4AGVwYUx81JfvwjE
	 Z6v2baGMQBrn+96ZlIcqbzV+bt6dzBXZdhPtOh6Bc5tCdxVaeMJgYsCR3nVFJJA5ZOLri
	 KS4rv6s3P/3ODCViWxlWbskosPzFkLjainipAaUVmZJlUdrw9LZ38JMPz0IcjeYYi6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oo5+H/mX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6967606A31A;
	Wed, 28 Oct 2026 15:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oo5+H/mX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734621F01825;
	Wed, 28 Oct 2026 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201280;
	bh=fQ5ICJZvo9sE1f7Ztr4VxqbPBKy2FoRlGzIcYO9hGjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oo5+H/mXjDdHyznh2Jp06Kc5SHBnfpE1ZMLoBSePEhTDoc0OPkATXbHWPuWrm5KX5
	 vMyYfAeyREgrrHqjR9wbkeSP64SNBJDMHTbTxvocbF2x6BCk2yqpRG25ymaFDtknj8
	 rQGCH4XwckCyA3Xp4z+AG+PQqIpa7vD+yegBeHSo18lJSrL90K50JRtfviGCAuzN3d
	 HlkDZsOI5LvagWuQYc1T35+IcFmpyqpkAxLW5FCh2UPKSDUQhJ9mGiPDt8K5A7ML+Y
	 852woU4VkTOT4C81koQjisqxrkGF3/Lw7HgcZOwoVxR/PoHtAaN4kGEcEHOw4sND/z
	 IUOANYZpFiDAQ==
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
Subject: [RFC PATCH v1 11/11] virt: coco: arm-cca-guest: Refresh selected evidence against trusted digests
Date: Wed, 28 Oct 2026 20:56:18 +0530
Message-ID: <20261028152618.1356860-12-aneesh.kumar@kernel.org>
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

Refresh either measurements with a 32-byte challenge or the interface
report without one. Reject other objects and unsupported flags before
issuing native requests.

Verify refreshed bytes against the trusted digest, hash algorithm,
certificate slot and lock sequence. Check that the other cached object's
sequence is unchanged, then replace only the verified selected cache
entry. Keep the previous cache intact on failure and document refresh
constraints and generation invalidation.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-guest/main.c | 134 +++++++++++++++----------
 1 file changed, 83 insertions(+), 51 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-guest/main.c b/drivers/virt/coco/arm-cca-guest/main.c
index f50f3e660bbc..d9de5d6c0e37 100644
--- a/drivers/virt/coco/arm-cca-guest/main.c
+++ b/drivers/virt/coco/arm-cca-guest/main.c
@@ -174,86 +174,94 @@ static void unregister_cca_tsm_report(void *data)
 
 #ifdef CONFIG_PCI_TSM
 
-static int __maybe_unused
-cca_update_dev_measurements(struct pci_dev *pdev, const u8 *nonce)
+static int cca_refresh_dev_evidence(struct pci_dev *pdev,
+		enum pci_tsm_evidence_type type, const u8 *nonce)
 {
-	int ret;
-	void *measurements;
-	size_t measurements_size;
-	int vdev_id = rsi_vdev_id(pdev);
-	struct pci_tsm_evidence *evidence;
-	struct rsi_vdevice_info *dev_info;
-	struct pci_tsm_evidence_object *obj;
 	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
+	struct pci_tsm_evidence *evidence = &dsc->pci.base_tsm.evidence;
+	struct pci_tsm_evidence_object *obj = &evidence->obj[type];
+	struct rsi_vdevice_info *dev_info;
+	bool report = type == PCI_TSM_EVIDENCE_TYPE_REPORT;
+	int vdev_id = rsi_vdev_id(pdev);
+	void *data;
+	u8 *digest;
+	u8 expected_hash_algo;
+	size_t size;
+	int object_type;
+	int ret;
 
-	/* Regenerate the measurement from the device */
-	ret = rhi_update_vdev_measurements_cache(pdev, nonce);
-	if (ret) {
-		pci_err(pdev, "failed to update device measurements from device (%d)\n", ret);
-		return ret;
+	if (report) {
+		object_type = RHI_DA_OBJECT_INTERFACE_REPORT;
+		ret = rhi_update_vdev_interface_report_cache(pdev);
+	} else {
+		object_type = RHI_DA_OBJECT_MEASUREMENT;
+		ret = rhi_update_vdev_measurements_cache(pdev, nonce);
 	}
-
-	ret = rhi_read_cached_object(vdev_id, RHI_DA_OBJECT_MEASUREMENT,
-				     &measurements, &measurements_size);
-	if (ret) {
-		pci_err(pdev, "failed to get device measurements from the host (%d)\n", ret);
+	if (ret)
 		return ret;
-	}
 
+	ret = rhi_read_cached_object(vdev_id, object_type, &data, &size);
+	if (ret)
+		return ret;
 	dev_info = kmalloc(sizeof(*dev_info), GFP_KERNEL);
 	if (!dev_info) {
 		ret = -ENOMEM;
-		goto free_measurements;
+		goto free_data;
 	}
-
 	if (rsi_vdev_get_info(vdev_id, virt_to_phys(dev_info))) {
-		pci_err(pdev, "failed to get device digests (%d)\n", ret);
 		ret = -EIO;
 		goto free_dev_info;
 	}
 
-	/* Make sure no unexpected lock/unlock operation happened from guest */
-	if (dsc->dev_info.lock_seq != dev_info->lock_seq) {
-		pci_err(pdev, "Unexpected lock/unlock operation from host (%d)\n", ret);
+	if (evidence->digest_algo == HASH_ALGO_SHA256)
+		expected_hash_algo = RSI_HASH_SHA_256;
+	else
+		expected_hash_algo = RSI_HASH_SHA_512;
+
+	/* Keep every cached object bound to the same locked device. */
+	if (dev_info->lock_seq != dsc->dev_info.lock_seq || dev_info->id_index ||
+	    dev_info->hash_algo != expected_hash_algo) {
 		ret = -EIO;
 		goto free_dev_info;
 	}
 
-	/*
-	 * Verify that the digests of the provided reports match with the
-	 * digests from RMM
-	 */
-	ret = cca_verify_digest(dev_info->hash_algo, measurements,
-				measurements_size, dev_info->meas_digest);
-	if (ret) {
-		pci_err(pdev, "RMM provided digest mismatch (%d)\n", ret);
-		goto free_dev_info;
+	if (report) {
+		if (dev_info->meas_seq != dsc->dev_info.meas_seq) {
+			ret = -EIO;
+			goto free_dev_info;
+		}
+		digest = dev_info->report_digest;
+	} else {
+		if (dev_info->report_seq != dsc->dev_info.report_seq) {
+			ret = -EIO;
+			goto free_dev_info;
+		}
+		digest = dev_info->meas_digest;
 	}
 
-	/* fill evidence details */
-	evidence = &dsc->pci.base_tsm.evidence;
+	ret = cca_verify_digest(dev_info->hash_algo, data, size, digest);
+	if (ret)
+		goto free_dev_info;
 
-	/* Now update the evidence under lock. */
+	/* Publish only after verification; failures preserve the old cache. */
 	down_write(&evidence->lock);
-	evidence->generation = dev_info->meas_seq;
-
-	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS];
-	if (obj->data)
-		kvfree(obj->data);
-	obj->data = measurements;
-	obj->len = measurements_size;
-
-	dsc->dev_info.meas_seq = dev_info->meas_seq;
-	memcpy(dsc->dev_info.meas_digest, dev_info->meas_digest, SHA512_DIGEST_SIZE);
+	kvfree(obj->data);
+	obj->data = data;
+	obj->len = size;
+	memcpy(obj->digest, digest, SHA512_DIGEST_SIZE);
+	if (report)
+		dsc->dev_info.report_seq = dev_info->report_seq;
+	else
+		dsc->dev_info.meas_seq = dev_info->meas_seq;
+	evidence->generation++;
 	up_write(&evidence->lock);
-
 	kfree(dev_info);
 	return 0;
 
 free_dev_info:
 	kfree(dev_info);
-free_measurements:
-	kvfree(measurements);
+free_data:
+	kvfree(data);
 	return ret;
 }
 
@@ -506,6 +514,29 @@ static int cca_tsm_accept(struct pci_dev *pdev)
 	return __cca_tsm_accept(pdev, dsc->dev_info.lock_seq);
 }
 
+static int cca_tsm_refresh_evidence(struct pci_tsm *tsm,
+		enum pci_tsm_evidence_type type, unsigned long flags,
+		void *nonce, size_t nonce_len)
+{
+	if (flags)
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS:
+		if (nonce_len != 32)
+			return -EINVAL;
+		break;
+	case PCI_TSM_EVIDENCE_TYPE_REPORT:
+		if (nonce_len)
+			return -EINVAL;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return cca_refresh_dev_evidence(tsm->pdev, type, nonce);
+}
+
 static struct pci_tsm_ops cca_devsec_pci_ops = {
 	.owner = THIS_MODULE,
 	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0) |
@@ -515,6 +546,7 @@ static struct pci_tsm_ops cca_devsec_pci_ops = {
 	.lock = cca_tsm_lock,
 	.unlock = cca_tsm_unlock,
 	.accept	 = cca_tsm_accept,
+	.refresh_evidence = cca_tsm_refresh_evidence,
 };
 
 static void cca_devsec_tsm_remove(void *tsm_dev)
-- 
2.43.0

