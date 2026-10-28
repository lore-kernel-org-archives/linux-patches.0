Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201264;
	b=FQzJG3T2AZojDCoPnzRSvJW2qqt9wN17nTowQHn8kayWozEx89wAQJcpCzZeYKq42YtF
	 gmeYQl/KbBCOFkivZYTDxpdzTsNu1NusqCRE2rmhG99yq0epZk+8N6g51uboDMNB5fu8i
	 310fzi1TPDgMkXIHj9U+12+jdcy70HBnPpTrGN2b99p2xWodbS4F3JihQX79uLKVNkbXr
	 QlixW6qvQszLJV7bSJsEOd4IT//CJti7bDry/G+eYO7zIV4jDZvgwsZrkbzALfGuaEkW7
	 OB/u7Pdw65tBdUlPxesGJA6zc3sksFfSRcJPSwgfg6qKuDX/B1+PQFSgUBxmfNgwuxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pXrYeDJ3t3TAvNgDjvH/372IZWIKfKJTOI9R9yNqLo8=;
	b=J8S2ZZbVIavpzuPkHAuX4lY50XO/rnZ9xR4aFAEd3O+eJkErGJ/1s7MX0s9sQC6NsE2r
	 jtVsmYYjybQrNT6LjGLDQFALmJ2JjnSBPfQaFfuIb0jpOvCuWIgVDapSafWBOB8wPGJYR
	 VWmJCdOi9CAcNb/sznaEFBS1HmDEJmoqTYhI02mGt6Vm3QjXfOTxSdtB09np0CytPQSWw
	 01jERmD27vIxTHA6JEpllzXRZH/SpEBabAaQqc9Evcy5xAlf0LvIa1UEtnx5js7zmn/xf
	 oKYI/TDCI309oekhiQ3SzDl46STu8zFR1lg1U/R5UN5eqabJaDM3L2uaCrl7HAnMPKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7icHHdn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5D5606A31D;
	Wed, 28 Oct 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7icHHdn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D791F031E1;
	Wed, 28 Oct 2026 15:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201264;
	bh=pXrYeDJ3t3TAvNgDjvH/372IZWIKfKJTOI9R9yNqLo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7icHHdnrbZ6i1/TYVSooLSMSxPg6hHLOUUrGjS/Nm5z0Onq8IyTgMDFK+087sbcy
	 R/whP2Off8g2pgU2wg0FT5Qlyn3OwzRgdWiygamp9+Y/Zh4t08bAGOzmDGMnmZhMoy
	 hNQLNHJt1Ec+F0pcckv0yKC1aLsAkDUVZb/6e1M+ishAhjNdkXu6n+MESaMYbZeuWd
	 awqgfdx6mN5kpmOkkXKCj8j2wzDyLy3vfur46ebZKUuOfGq/zGI1DpgVXydyrxts9M
	 2cnlo7rJDYl6nWEibNeuXb6URe8qJJr6bfQd9GGCXwu5XcB0FjGaQySvYWq9/+J8cL
	 mv7m20CWfezeQ==
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
Subject: [RFC PATCH v1 09/11] crypto/ccp: Defer SEV-TIO link setup until evidence acceptance
Date: Wed, 28 Oct 2026 20:56:16 +0530
Message-ID: <20261028152618.1356860-10-aneesh.kumar@kernel.org>
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

AMD SEV-TIO currently establishes its SPDM session and enables IDE during
connect, before userspace can retrieve or accept the device identity.
Move AMD link setup behind its evidence_accept callback.

During connect, reserve TC0's stream ID, create the firmware context,
and forward only unencrypted identity discovery requests. Cache the
complete slot-zero certificate chain as firmware receives it. Once
firmware consumes that chain and yields its next request, pause the
exchange without transmitting an authentication or session-establishment
request. No IDE registers are programmed during this identity
collection.

Keep the generic callback optional until the following patch converts
CCA, the remaining legacy link backend, and requires evidence_accept for
every link backend.

Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: John Allen <john.allen@amd.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tio.c |  17 ++-
 drivers/crypto/ccp/sev-dev-tio.h |   5 +
 drivers/crypto/ccp/sev-dev-tsm.c | 189 ++++++++++++++++++++++++++-----
 3 files changed, 176 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
index c84e23982b43..ff51f09961c4 100644
--- a/drivers/crypto/ccp/sev-dev-tio.c
+++ b/drivers/crypto/ccp/sev-dev-tio.c
@@ -639,25 +639,23 @@ static void spdm_ctrl_init(struct spdm_ctrl *ctrl, struct tsm_dsm_tio *dev_data)
 static void spdm_ctrl_free(struct tsm_dsm_tio *dev_data)
 {
 	struct sev_tio_status *tio_status = to_tio_status(dev_data);
-	size_t len = tio_status->spdm_req_size_max -
-		(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
-		 sizeof(struct sla_buffer_hdr));
 	struct tsm_spdm *spdm = &dev_data->spdm;
 
 	sla_buffer_unmap(dev_data->resp, dev_data->respbuf);
 	sla_buffer_unmap(dev_data->req, dev_data->reqbuf);
 	spdm->rsp = NULL;
 	spdm->req = NULL;
-	sla_free(dev_data->req, len, true);
-	sla_free(dev_data->resp, len, false);
-	sla_free(dev_data->scratch, tio_status->spdm_scratch_size_max, true);
+	sla_free(dev_data->req, tio_status->spdm_req_size_max, true);
+	sla_free(dev_data->resp, tio_status->spdm_req_size_max, false);
+	sla_free(dev_data->scratch, dev_data->scratch_len, true);
 
 	dev_data->req.sla = 0;
 	dev_data->resp.sla = 0;
 	dev_data->scratch.sla = 0;
 	dev_data->respbuf = NULL;
 	dev_data->reqbuf = NULL;
-	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
+	sla_free(dev_data->output, dev_data->output_len, true);
+	dev_data->output = SLA_NULL;
 }
 
 static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
@@ -674,7 +672,7 @@ static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
 	dev_data->output = sla_alloc(dev_data->output_len, true);
 
 	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
-	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
+	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->output)) {
 		ret = -ENOMEM;
 		goto free_spdm_exit;
 	}
@@ -773,7 +771,8 @@ int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id,
 free_data_pg_exit:
 	snp_free_firmware_page(data_pg);
 free_ctx_exit:
-	sla_free(create.dev_ctx_sla, tio_status->devctx_size, true);
+	sla_free(dev_data->dev_ctx, tio_status->devctx_size, true);
+	dev_data->dev_ctx = SLA_NULL;
 	return ret;
 }
 
diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
index 67512b3dbc53..237da723483c 100644
--- a/drivers/crypto/ccp/sev-dev-tio.h
+++ b/drivers/crypto/ccp/sev-dev-tio.h
@@ -58,6 +58,11 @@ struct tio_dsm {
 	struct pci_tsm_pf0 tsm;
 	struct tsm_dsm_tio data;
 	struct sev_device *sev;
+	bool session_connected;
+	bool certificate_pending;
+	u16 certificate_request_len;
+	size_t certificate_offset;
+	int pending_spdm;
 };
 
 /* Data object IDs */
diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index e905ed9de9b5..14d7ef84ee36 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -9,6 +9,7 @@
 #include <linux/pci-doe.h>
 #include <linux/bitfield.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 
 #include <asm/sev-common.h>
 #include <asm/sev.h>
@@ -163,7 +164,7 @@ static int streams_register(struct pci_ide **ide)
 static void streams_unregister(struct pci_ide **ide)
 {
 	for (int i = 0; i < TIO_IDE_MAX_TC; ++i)
-		if (ide[i])
+		if (ide[i] && ide[i]->name)
 			pci_ide_stream_unregister(ide[i]);
 }
 
@@ -253,6 +254,7 @@ static void dsm_remove(struct pci_tsm *tsm)
 	if (is_pci_tsm_pf0(pdev)) {
 		struct tio_dsm *dsm = container_of(tsm, struct tio_dsm, tsm.base_tsm);
 
+		kvfree(tsm->evidence.obj[PCI_TSM_EVIDENCE_TYPE_CERT0].data);
 		pci_tsm_pf0_destructor(&dsm->tsm);
 		kfree(dsm);
 	}
@@ -283,12 +285,120 @@ static int dsm_create(struct tio_dsm *dsm)
 	return sev_tio_dev_create(&dsm->data, device_id, root_port_id, segment_id);
 }
 
+/* Only identity discovery requests may leave the host before acceptance. */
+static int dsm_identity_request(struct tio_dsm *dsm)
+{
+	struct tsm_spdm *spdm = &dsm->data.spdm;
+	const u8 *req = spdm->req;
+
+	if (spdm->req_len < 4)
+		return -EPROTO;
+
+	switch (req[1]) {
+	case 0x84: /* GET_VERSION */
+	case 0xe1: /* GET_CAPABILITIES */
+	case 0xe3: /* NEGOTIATE_ALGORITHMS */
+	case 0x81: /* GET_DIGESTS */
+		dsm->certificate_pending = false;
+		return 0;
+	case 0x82: /* GET_CERTIFICATE */
+		if (spdm->req_len < 8 || (req[2] & 0xf) ||
+		    get_unaligned_le16(req + 4) != dsm->certificate_offset)
+			return -EPROTO;
+		dsm->certificate_request_len = get_unaligned_le16(req + 6);
+		if (!dsm->certificate_request_len)
+			return -EPROTO;
+		dsm->certificate_pending = true;
+		return 0;
+	case 0xff: /* RESPOND_IF_READY preserves the pending certificate request. */
+		return 0;
+	default:
+		return -EPROTO;
+	}
+}
+
+static int dsm_cache_certificate(struct tio_dsm *dsm)
+{
+	struct pci_tsm_evidence_object *object =
+		&dsm->tsm.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_CERT0];
+	struct tsm_spdm *spdm = &dsm->data.spdm;
+	const u8 *rsp = spdm->rsp;
+	size_t portion, remainder, total;
+
+	if (spdm->rsp_len < 4)
+		return -EPROTO;
+	if (rsp[1] != 0x02) /* CERTIFICATE */
+		return 0;
+	if (!dsm->certificate_pending || spdm->rsp_len < 8 || (rsp[2] & 0xf))
+		return -EPROTO;
+
+	portion = get_unaligned_le16(rsp + 4);
+	remainder = get_unaligned_le16(rsp + 6);
+	total = dsm->certificate_offset + portion + remainder;
+	if (!portion || portion > dsm->certificate_request_len ||
+	    portion > spdm->rsp_len - 8 || total > U16_MAX)
+		return -EPROTO;
+
+	if (!object->data) {
+		object->data = kvmalloc(total, GFP_KERNEL);
+		if (!object->data)
+			return -ENOMEM;
+		object->len = total;
+	} else if (total != object->len) {
+		return -EPROTO;
+	}
+
+	memcpy((u8 *)object->data + dsm->certificate_offset, rsp + 8, portion);
+	dsm->certificate_offset += portion;
+	dsm->certificate_pending = false;
+	if (!remainder && (object->len < 4 ||
+			   get_unaligned_le16(object->data) != object->len))
+		return -EPROTO;
+
+	return 0;
+}
+
+static int dsm_collect_identity(struct tio_dsm *dsm, int ret)
+{
+	struct pci_tsm_evidence_object *object =
+		&dsm->tsm.base_tsm.evidence.obj[PCI_TSM_EVIDENCE_TYPE_CERT0];
+	struct tsm_spdm *spdm = &dsm->data.spdm;
+
+	while (ret == PCI_DOE_FEATURE_CMA || ret == PCI_DOE_FEATURE_SSESSION) {
+		/* Firmware consumed this exact chain; resume only after acceptance. */
+		if (object->len && dsm->certificate_offset == object->len) {
+			dsm->pending_spdm = ret;
+			return 0;
+		}
+		if (ret != PCI_DOE_FEATURE_CMA)
+			return -EPROTO;
+		ret = dsm_identity_request(dsm);
+		if (ret)
+			return ret;
+
+		ret = pci_doe(dsm->tsm.doe_mb, PCI_VENDOR_ID_PCI_SIG,
+			      PCI_DOE_FEATURE_CMA, spdm->req, spdm->req_len,
+			      spdm->rsp, spdm->rsp_len);
+		if (ret < 0)
+			return ret;
+		spdm->rsp_len = ret;
+		ret = dsm_cache_certificate(dsm);
+		if (ret)
+			return ret;
+		ret = sev_tio_continue(&dsm->data);
+	}
+
+	/* Connect must stop before session establishment, with a complete chain. */
+	return ret < 0 ? ret : -EPROTO;
+}
+
+static void dsm_disconnect(struct pci_dev *pdev);
+
 static int dsm_connect(struct pci_dev *pdev)
 {
 	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
 	struct tsm_dsm_tio *dev_data = &dsm->data;
 	u8 ids[TIO_IDE_MAX_TC];
-	u8 tc_mask;
 	int ret;
 
 	if (pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
@@ -300,35 +410,54 @@ static int dsm_connect(struct pci_dev *pdev)
 	ret = stream_alloc(pdev, dev_data->ide, 0);
 	if (ret)
 		return ret;
-
 	ret = dsm_create(dsm);
 	if (ret)
-		goto ide_free_exit;
+		goto disconnect;
+
+	/* Reserve TC0's stream ID without programming or enabling IDE. */
+	memset(ids, 0xff, sizeof(ids));
+	ids[0] = dev_data->ide[0]->stream_id;
+	dev_data->cert_slot = 0;
+	ret = sev_tio_dev_connect(dev_data, BIT(0), ids, dev_data->cert_slot);
+	ret = dsm_collect_identity(dsm, ret);
+	if (!ret)
+		return 0;
+
+disconnect:
+	dsm_disconnect(pdev);
+	return ret;
+}
 
-	tc_mask = streams_setup(dev_data->ide, ids);
+static int dsm_evidence_accept(struct pci_dev *pdev)
+{
+	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
+	struct tsm_dsm_tio *dev_data = &dsm->data;
+	u8 ids[TIO_IDE_MAX_TC];
+	int ret;
 
-	dev_data->cert_slot = pdev->tsm->evidence.slot;
-	ret = sev_tio_dev_connect(dev_data, tc_mask, ids, dev_data->cert_slot);
-	ret = sev_tio_spdm_cmd(dsm, ret);
-	if (ret)
-		goto free_exit;
+	if (pdev->tsm->evidence.slot)
+		return -EOPNOTSUPP;
+	if (!dsm->pending_spdm)
+		return -ENODATA;
 
-	streams_enable(dev_data->ide);
+	streams_setup(dev_data->ide, ids);
+	ret = sev_tio_spdm_cmd(dsm, dsm->pending_spdm);
+	dsm->pending_spdm = 0;
+	if (ret)
+		goto err_session;
+	dsm->session_connected = true;
 
+	ret = streams_enable(dev_data->ide);
+	if (ret)
+		goto err_session;
 	ret = streams_register(dev_data->ide);
 	if (ret)
-		goto free_exit;
-
+		goto err_session;
 	return 0;
 
-free_exit:
-	sev_tio_dev_reclaim(dev_data);
-
-	streams_disable(dev_data->ide);
-ide_free_exit:
-
-	streams_teardown(dev_data->ide);
-
+err_session:
+	/* Disconnect owns cleanup after firmware or IDE setup has started. */
+	pdev->tsm->error = true;
 	return ret;
 }
 
@@ -339,14 +468,20 @@ static void dsm_disconnect(struct pci_dev *pdev)
 	struct tsm_dsm_tio *dev_data = &dsm->data;
 	int ret;
 
-	ret = sev_tio_dev_disconnect(dev_data, force);
-	ret = sev_tio_spdm_cmd(dsm, ret);
-	if (ret && !force) {
-		ret = sev_tio_dev_disconnect(dev_data, true);
-		sev_tio_spdm_cmd(dsm, ret);
+	/* A paused or failed connect needs forced firmware cleanup. */
+	if (dev_data->reqbuf && dev_data->respbuf) {
+		force |= !dsm->session_connected;
+		ret = sev_tio_dev_disconnect(dev_data, force);
+		ret = sev_tio_spdm_cmd(dsm, ret);
+		if (ret && !force) {
+			ret = sev_tio_dev_disconnect(dev_data, true);
+			sev_tio_spdm_cmd(dsm, ret);
+		}
 	}
 
 	sev_tio_dev_reclaim(dev_data);
+	dsm->session_connected = false;
+	dsm->pending_spdm = 0;
 
 	streams_disable(dev_data->ide);
 	streams_unregister(dev_data->ide);
@@ -357,6 +492,8 @@ static struct pci_tsm_ops sev_tsm_ops = {
 	.probe = dsm_probe,
 	.remove = dsm_remove,
 	.connect = dsm_connect,
+	.evidence_accept = dsm_evidence_accept,
+	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0),
 	.disconnect = dsm_disconnect,
 };
 
-- 
2.43.0

