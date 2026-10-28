Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201272;
	b=uo+ex4tIYA0ZYl3eywyFny3gfqlzbkyViI0MdKBs+cQXz5UCQr6wrWPoUoM+UaOCuxIN
	 El0eQU5ZW7CbChsI1zJgB6cz+3+jp/x7agj+b9/tEFL2ah/fFZ6cLTRFKNBOCyMvwB33R
	 SwIgZx7UXUa6z2K76Vysyn3l0hjPPy5+R8Z+RkPcMN1zsOYbuXAc+HQXpMekJ6Ld4PQ+u
	 hDw5WrwCm3sttM/5ocjj8Bd38vKdWeQZmB3sMz/XpmsCJRWJqaBmlezIbe3tQ3yAHmllV
	 mwLEtzn7+OzP3YmtTfij3mz55VsWbvXTlJIWno2geOrq7SOoGSsp/dFJL9C2SZc+lmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=O8+tg8ku2o5WhyJV3Jx112YugXczC93FFJMftzgoDEM=;
	b=teJgaA7XlDBiyvkl1EOisBcSvHYIWmQmYbk9EullU96vqS6aUMOHlBiBl1UNVQLRnQAN
	 cswmdzQMlBKcY2ddsA0TMwipqain8jdq+PZ/mAUf3Cj0nNvZ7TyEILeLxkqS2q+7Ma+8p
	 P+K8cl3k02SUUAJDDJwm8qqhP6WoxxunXJQtVUaFn/lJZ2YJOfLsjulp7I3LR05xhzUGu
	 /kOhlJs7jURkkBZtVtqVqNzlFvDIxvA792iJTSZQ1zjGdgpQnx9b5V9v9SWCSBg0z+3rZ
	 HZU+gXHLwTwpisXAQLgP2Nbw3ZE61Pn+U3NCbhmJJKSdk2ipvOt4ixgNCvEkiM1dl+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+3nSWl6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152E2606A31A;
	Wed, 28 Oct 2026 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+3nSWl6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACD61F01828;
	Wed, 28 Oct 2026 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201271;
	bh=O8+tg8ku2o5WhyJV3Jx112YugXczC93FFJMftzgoDEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+3nSWl6Ai8K0KUU/JGPcVWzNzPPNTavuXLayRWVdwDiTrQqlQRsSkw2V4YWRN4rq
	 AROlodpv3DqOhwilXRwWNPEdzreB4YT0o7wC4kr1oUF2bMdja68dBGQuaXMRuppIPS
	 fWkYkfBKdF/w8gMZZURqqe3/pKitNINeposCkjaF1dX3QwVYSSmB3GhPt8422KKBWy
	 ntZfW+eHtqemBUp0vupTfFInsg0unehW5fRgIixaBhlx0HgLZfxd7WkBKfH/9aA268
	 K/zV4XdOUWbBvIzTh6eNjQKnWDfOVvv6Ky3RCxQOfNyfSLM+QKgQRu05dZxhr9V8s6
	 NpQs/hlBqgQlw==
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
Subject: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero and establish streams after acceptance
Date: Wed, 28 Oct 2026 20:56:17 +0530
Message-ID: <20261028152618.1356860-11-aneesh.kumar@kernel.org>
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

Declare certificate slot zero as the CCA link backend evidence
capability. Limit connect to PDEV creation and slot-zero identity
collection. Copy the chain into the PCI evidence cache before publishing
the CTLV device.

Complete public-key submission, secure-session setup and stream
connection through evidence_accept after userspace verifies the chain.
Keep the evidence snapshot separate from the RMM communication cache and
release it on context removal.

With AMD converted in the previous patch, CCA is the last link backend
that still establishes streams during connect. Now require
evidence_accept for every link backend and initialize newly connected
contexts without active streams. Reject link providers that omit the
callback, and remove the legacy connect-time session and IDE exception
from the API comments and documentation. Connect remains required at
this point; a later patch allows shared-discovery backends to omit it.

Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-pci  |   2 +-
 Documentation/driver-api/attestation.rst |  30 +++++
 Documentation/driver-api/pci/tsm.rst     |  70 +++++++++--
 drivers/pci/tsm/core.c                   |   5 +-
 drivers/virt/coco/arm-cca-host/main.c    | 143 ++++++++++++++++-------
 drivers/virt/coco/arm-cca-host/rmi-da.c  |   7 +-
 drivers/virt/coco/arm-cca-host/rmi-da.h  |   2 +
 include/linux/pci-tsm.h                  |   6 +-
 samples/devsec/link_tsm.c                |  16 ++-
 9 files changed, 222 insertions(+), 59 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 56b1d92427ef..391807e609f9 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -639,7 +639,7 @@ Description:
 		device with that TSM and collect its supported identity evidence.
 		Reads return the associated TSM name, or an empty string.
 		Successful connect creates the CTLV attestation instance.
-		Backends may defer secure-session and stream setup until
+		Link backends defer secure-session and stream setup until
 		userspace verifies the chain and issues CTLV evidence-accept.
 
 What:		/sys/bus/pci/devices/.../tsm/disconnect
diff --git a/Documentation/driver-api/attestation.rst b/Documentation/driver-api/attestation.rst
index d23b7c65d35b..2ab1d2bf031e 100644
--- a/Documentation/driver-api/attestation.rst
+++ b/Documentation/driver-api/attestation.rst
@@ -130,6 +130,36 @@ The next kernel requires the same selector and restored lifetime, rebuilds
 deduplication from committed IMA journal entries, and never imports the legacy
 IMA measurement-list buffer for this mode.
 
+PCI host identity and acceptance
+================================
+
+Host connections use ``tsm/connect`` and ``tsm/disconnect`` in the PCI device's
+sysfs directory. Write the link TSM name, such as ``tsm0``, to either file.
+Backends declare the evidence objects and certificate slots they expose;
+DEVICE_GET advertises these capabilities and EVIDENCE_GET exports the cached
+evidence. The common provider does not restrict host certificates to a fixed
+slot.
+
+After verifying a chain, issue EVIDENCE_ACCEPT with the device and evidence
+generations returned by EVIDENCE_GET. The ``evidence.accept-object`` selector
+identifies the certificate slot and must belong to the retrieved snapshot.
+The link backend's ``evidence_accept`` callback receives the selected slot in
+``pci_tsm.evidence.slot`` and establishes the secure session and streams.
+Every link backend must provide this callback; connect only prepares identity
+evidence and must defer secure-session and IDE setup until acceptance.
+Successful acceptance makes the connection available to IOMMUFD consumers.
+Repeating acceptance does not allocate another stream, and selecting a
+different slot after stream setup returns EBUSY.
+
+EVIDENCE_ACCEPT_CLEAR clears the recorded verifier verdict only. It leaves an
+established stream active; accepting the evidence again reuses that stream.
+Writing the TSM name to ``tsm/disconnect`` releases either an identity-only
+connection or its stream and identity resources. It returns EBUSY while
+IOMMUFD vdevices hold connection contexts.
+
+See Documentation/driver-api/pci/tsm.rst for backend-specific behavior and
+``ctlvctl`` examples of evidence retrieval and acceptance.
+
 Simulation provider
 ===================
 
diff --git a/Documentation/driver-api/pci/tsm.rst b/Documentation/driver-api/pci/tsm.rst
index 28c9ec5dd4e6..03bee3098d19 100644
--- a/Documentation/driver-api/pci/tsm.rst
+++ b/Documentation/driver-api/pci/tsm.rst
@@ -30,6 +30,11 @@ backend registration alone do not create instances.
 Operation availability
 ======================
 
+Every link backend must provide ``evidence_accept`` for secure-session and
+IDE setup after userspace verification. The ``connect`` callback prepares
+identity evidence without establishing the secure link. It is required for
+link backends.
+
 CTLV provides DEVICE_GET, PCI STATE_GET, EVIDENCE_GET, EVIDENCE_ACCEPT,
 EVIDENCE_ACCEPT_CLEAR and DEVSEC_STATE_GET on established contexts. Backends
 declare the evidence objects and certificate slots they expose. The common
@@ -70,13 +75,64 @@ DSM BDF. The TSM ID is the numeric suffix of /sys/class/tsm/tsmN. PCI
 EVIDENCE_REFRESH requires ``pci.generation`` from STATE_GET; a mismatch returns
 ESTALE before invoking the native backend.
 
-For a link backend that defers secure-link setup until evidence acceptance,
-write its TSM name to the DSM's ``tsm/connect`` sysfs file to collect identity
-evidence. DEVICE_GET advertises the backend's available objects and certificate
-slots; EVIDENCE_GET retrieves the cached chain. After verifying it, issue
-EVIDENCE_ACCEPT with the returned device and evidence generations to complete
-session and IDE setup. Writing the same TSM name to ``tsm/disconnect`` releases
-the context, including an identity context that has not been accepted.
+The host writes a link TSM name to its DSM's ``tsm/connect`` sysfs file.
+Connect prepares an identity context and caches the evidence objects
+declared by the backend, without establishing a secure session or IDE
+streams. Use DEVICE_GET to discover the available objects and certificate
+slots, then use EVIDENCE_GET to retrieve an advertised ``cert-chain``
+instance. Verify the chain under the relying party's policy before issuing
+EVIDENCE_ACCEPT with the returned device and evidence generations.
+Acceptance completes session and stream setup. The authenticated attribute
+remains empty until setup succeeds.
+
+Use EVIDENCE_ACCEPT with ``evidence.accept-object`` selecting ``cert-chain``,
+format ``spdm-cert-chain``, and an advertised certificate slot as
+``evidence.blob-instance``. The selected object must have been retrieved in the
+referenced evidence generation; otherwise acceptance returns ESTALE.
+
+For example, use ``ctlvctl`` to export an advertised certificate chain (slot 0
+in this example)::
+
+  ctlvctl --spec-dir=./specs exec ctlv0 evidence-get --json '{
+    "evidence.object": [{
+      "evidence.blob-class": "cert-chain",
+      "evidence.format": "spdm-cert-chain",
+      "evidence.blob-instance": 0,
+      "evidence.representation": "raw",
+      "evidence.data": {
+        "file": "./cert0.bin", "data-buf-size": 16777216
+      }
+    }]
+  }'
+
+Verify ``cert0.bin`` under the relying party's policy before accepting it.
+Use the ``device.generation`` and ``evidence.generation`` values returned by
+EVIDENCE_GET. If they are 0 and 1 respectively::
+
+  ctlvctl --spec-dir=./specs exec ctlv0 evidence-accept --json '{
+    "device.generation": 0,
+    "evidence.generation": 1,
+    "evidence.accept-object": {
+      "evidence.blob-class": "cert-chain",
+      "evidence.format": "spdm-cert-chain",
+      "evidence.blob-instance": 0
+    }
+  }'
+
+The commands use ``ctlv0`` and ``./specs`` as examples; use the discovered CTLV
+instance and the directory containing the matching specification files.
+Generation pairs are scoped to an instance lifetime. Keep the same CTLV file
+descriptor open from evidence collection through acceptance in a production
+verifier, and discard its generation pair on close or ENODEV. The separate
+``ctlvctl`` invocations illustrate the request format and assume the instance
+remains unchanged between commands. ``ctlvctl`` exports evidence and submits
+the verdict; certificate verification is the relying party's responsibility.
+
+Write the same TSM name to ``tsm/disconnect`` to release identity and stream
+resources. Disconnect works before evidence acceptance too, and returns EBUSY
+while an IOMMUFD vdevice holds a connection context. EVIDENCE_ACCEPT_CLEAR only
+clears the verdict; disconnect owns stream teardown. VM assignment and native
+TDISP transport remain in IOMMUFD and the platform TSM driver.
 
 A guest verifier follows this sequence:
 
diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index 170e043b1d3b..983463dd0811 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -261,7 +261,7 @@ static int pci_tsm_connect(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	if (rc)
 		return rc;
 
-	tsm_pf0->stream_connected = !ops->evidence_accept;
+	tsm_pf0->stream_connected = false;
 	pdev->tsm = no_free_ptr(pci_tsm);
 
 	/*
@@ -315,7 +315,8 @@ static bool pci_tsm_can_connect(struct tsm_dev *tsm_dev)
 {
 	const struct pci_tsm_ops *ops = tsm_dev ? tsm_dev->pci_ops : NULL;
 
-	return is_link_tsm(tsm_dev) && ops->remove && ops->connect && ops->disconnect;
+	return is_link_tsm(tsm_dev) && ops->remove && ops->connect &&
+		ops->evidence_accept && ops->disconnect;
 }
 
 static ssize_t connect_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
index 0bad6001654b..0f12353322fa 100644
--- a/drivers/virt/coco/arm-cca-host/main.c
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -13,6 +13,8 @@
 #include <linux/tsm.h>
 #include <linux/cleanup.h>
 #include <linux/pci-doe.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #include "rmi-da.h"
 
@@ -66,6 +68,7 @@ static void cca_tsm_pci_remove(struct pci_tsm *tsm)
 	if (is_pci_tsm_pf0(pdev)) {
 		struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
 
+		kvfree(tsm->evidence.obj[PCI_TSM_EVIDENCE_TYPE_CERT0].data);
 		pci_tsm_pf0_destructor(&pf0_ep_dsc->pci);
 		kfree(pf0_ep_dsc);
 	} else {
@@ -212,7 +215,6 @@ static int pci_dev_addr_range(struct pci_dev *pdev, struct rmi_addr_range *pdev_
 static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long stream_id)
 {
 	int ret;
-	long stream_handle;
 	struct cca_host_rp_dsc *rp_dsc;
 	struct rmi_pdev_stream_params *params;
 	struct pci_dev *rp = pcie_find_root_port(pdev);
@@ -245,11 +247,9 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
 	params->ide_sid = stream_id;
 	params->num_addr_range = pci_dev_addr_range(pdev, params->addr_range);
 
-	ret = cca_pdev_stream_connect(pdev, rp, params, &stream_handle);
-	if (ret)
+	ret = cca_pdev_stream_connect(pdev, rp, params, &pf0_ep_dsc->stream_handle);
+	if (ret && !pf0_ep_dsc->stream_created)
 		cca_root_port_pdev_put(rp_dsc);
-	else
-		pf0_ep_dsc->stream_handle = stream_handle;
 
 	free_page((unsigned long)params);
 	return ret;
@@ -258,7 +258,6 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
 static int cca_pdev_create_ncoh_sys_stream(struct pci_dev *pdev)
 {
 	int ret;
-	long stream_handle;
 	struct rmi_pdev_stream_params *params;
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
 
@@ -273,9 +272,7 @@ static int cca_pdev_create_ncoh_sys_stream(struct pci_dev *pdev)
 	params->ide_sid = 0; /* ignored */
 	params->num_addr_range = pci_dev_addr_range(pdev, params->addr_range);
 
-	ret = cca_pdev_stream_connect(pdev, NULL, params, &stream_handle);
-	if (!ret)
-		pf0_ep_dsc->stream_handle = stream_handle;
+	ret = cca_pdev_stream_connect(pdev, NULL, params, &pf0_ep_dsc->stream_handle);
 
 	free_page((unsigned long)params);
 	return ret;
@@ -298,7 +295,65 @@ static inline bool cca_pdev_need_sel_ide_streams(struct pci_dev *pdev)
 	return pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT;
 }
 
+static int cca_tsm_publish_certificate(struct pci_dev *pdev)
+{
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+	struct pci_tsm_evidence *evidence = &pdev->tsm->evidence;
+	struct pci_tsm_evidence_object *obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_CERT0];
+	struct cache_object *cache;
+	void *data;
+
+	/* On-chip endpoints can connect without SPDM identity collection. */
+	if (!pf0_ep_dsc->pci.doe_mb)
+		return 0;
+
+	guard(mutex)(&pf0_ep_dsc->pdev.object_lock);
+	cache = pf0_ep_dsc->cert_chain.cache;
+	if (!cache || !cache->offset)
+		return -ENODATA;
+
+	/* Later RMM communication may reallocate the original cache. */
+	data = kvmemdup(cache->buf, cache->offset, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	guard(rwsem_write)(&evidence->lock);
+	obj->data = data;
+	obj->len = cache->offset;
+	return 0;
+}
+
 static int cca_tsm_connect(struct pci_dev *pdev)
+{
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+	int ret;
+
+	ret = init_dev_communication_buffers(pdev, &pf0_ep_dsc->pdev.comm_data);
+	if (ret)
+		return ret;
+
+	ret = cca_pdev_create(pdev);
+	if (ret)
+		goto err_pdev_create;
+
+	ret = cca_pdev_collect_identity(pdev);
+	if (ret)
+		goto pdev_destroy;
+
+	ret = cca_tsm_publish_certificate(pdev);
+	if (ret)
+		goto pdev_destroy;
+
+	return 0;
+
+pdev_destroy:
+	cca_pdev_stop_and_destroy(pdev);
+err_pdev_create:
+	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
+	return ret;
+}
+
+static int cca_tsm_evidence_accept(struct pci_dev *pdev)
 {
 	struct pci_dev *rp = pcie_find_root_port(pdev);
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
@@ -309,9 +364,18 @@ static int cca_tsm_connect(struct pci_dev *pdev)
 	if (WARN_ON(!is_pci_tsm_pf0(pdev)))
 		return -EIO;
 
+	/* Connect collected identity from slot zero for this PDEV. */
+	if (pdev->tsm->evidence.slot != 0)
+		return -EOPNOTSUPP;
+
 	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
-	if (cca_pdev_need_sel_ide_streams(pdev)) {
+	if (cca_pdev_needs_key(pdev)) {
+		ret = cca_pdev_set_public_key(pdev);
+		if (ret)
+			goto err_key;
+	}
 
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
 		ide = pci_ide_stream_alloc(pdev);
 		if (!ide) {
 			ret = -ENOMEM;
@@ -344,42 +408,26 @@ static int cca_tsm_connect(struct pci_dev *pdev)
 			goto err_tsm;
 	}
 
-	ret = init_dev_communication_buffers(pdev, &pf0_ep_dsc->pdev.comm_data);
-	if (ret)
-		goto err_comm_buff;
-	ret = cca_pdev_create(pdev);
-	if (ret)
-		goto err_pdev_create;
-
-	ret = cca_pdev_collect_identity(pdev);
-	if (ret)
-		goto pdev_destroy;
-
-	if (cca_pdev_needs_key(pdev)) {
-		ret = cca_pdev_set_public_key(pdev);
-		if (ret)
-			goto pdev_destroy;
-	}
 	/* Create IDE streams */
 	ret = cca_pdev_create_streams(pdev, stream_id);
 	if (ret)
-		goto pdev_destroy;
+		goto err_stream_connect;
 	/*
 	 * Once ide is setup, enable the stream at the endpoint
 	 * Root port will be done by RMM
 	 */
-	if (cca_pdev_need_sel_ide_streams(pdev))
-		pci_ide_stream_enable(pdev, ide);
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
+		ret = pci_ide_stream_enable(pdev, ide);
+		if (ret)
+			goto err_stream_connect;
+	}
 
 	return 0;
 
-pdev_destroy:
-	cca_pdev_stop_and_destroy(pdev);
-err_pdev_create:
-	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
-err_comm_buff:
-	if (cca_pdev_need_sel_ide_streams(pdev))
-		tsm_ide_stream_unregister(ide);
+err_stream_connect:
+	/* Retain partial RMM/IDE state for sysfs disconnect to release. */
+	pdev->tsm->error = true;
+	return ret;
 err_tsm:
 	if (cca_pdev_need_sel_ide_streams(pdev)) {
 		pci_ide_stream_teardown(rp, ide);
@@ -391,7 +439,9 @@ static int cca_tsm_connect(struct pci_dev *pdev)
 		pci_ide_stream_free(ide);
 	pf0_ep_dsc->sel_stream = NULL;
 err_stream_alloc:
-
+	return ret;
+err_key:
+	pdev->tsm->error = true;
 	return ret;
 }
 
@@ -405,26 +455,33 @@ static void cca_tsm_disconnect(struct pci_dev *pdev)
 	if (!pf0_ep_dsc)
 		return;
 
-	if (cca_pdev_need_sel_ide_streams(pdev))
-		ide = pf0_ep_dsc->sel_stream;
+	ide = pf0_ep_dsc->sel_stream;
+	if (pf0_ep_dsc->stream_created) {
+		if (!cca_pdev_need_sel_ide_streams(pdev))
+			rp = NULL;
 
-	cca_pdev_disconnect_stream(pdev, rp, pf0_ep_dsc->stream_handle);
-	if (rp)
-		cca_root_port_pdev_put(to_cca_rp_dsc(rp));
+		cca_pdev_disconnect_stream(pdev, rp, pf0_ep_dsc->stream_handle);
+		if (rp)
+			cca_root_port_pdev_put(to_cca_rp_dsc(rp));
+
+		pf0_ep_dsc->stream_created = false;
+	}
 
 	cca_pdev_stop_and_destroy(pdev);
 	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
 
-	if (cca_pdev_need_sel_ide_streams(pdev)) {
+	if (ide) {
 		pci_ide_stream_release(ide);
 		pf0_ep_dsc->sel_stream = NULL;
 	}
 }
 
 static struct pci_tsm_ops cca_link_pci_ops = {
+	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0),
 	.probe = cca_tsm_pci_probe,
 	.remove = cca_tsm_pci_remove,
 	.connect = cca_tsm_connect,
+	.evidence_accept = cca_tsm_evidence_accept,
 	.disconnect = cca_tsm_disconnect,
 	.owner = THIS_MODULE,
 	.viommu_get_ops = cca_viommu_get_ops,
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index c4f505753bf9..d18812b91c31 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -92,8 +92,9 @@ static int init_pdev_params(struct pci_dev *pdev, struct rmi_pdev_params *params
 	params->pdev_id = rid;
 	params->hb_base = cfg->res.start;
 	params->routing_id = pci_ide_segment(pdev);
-	/* slot number for certificate chain default to zero */
-	params->id_index = 0;
+	/* Root ports do not use an SPDM certificate chain. */
+	if (params->flags & RMI_PDEV_FLAGS_SPDM)
+		params->id_index = 0;
 	params->hash_algo = RMI_HASH_SHA_256;
 	/* no multi function device here. */
 	params->rid_base = rid;
@@ -921,6 +922,8 @@ int cca_pdev_stream_connect(struct pci_dev *pdev1, struct pci_dev *pdev2,
 	if (rmi_pdev_stream_connect(stream_params_phys, stream_handle))
 		return -EIO;
 
+	/* Keep the handle and peer alive even if communication fails below. */
+	to_cca_pf0_ep_dsc(pdev1)->stream_created = true;
 	return submit_stream_work(pdev1, pdev2, *stream_handle);
 }
 
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 00a68afc0cb8..2024ca6cb9f3 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -87,6 +87,7 @@ struct cca_host_pdev_dsc {
  * @pdev: pdev communication context
  * @sel_stream: Selective IDE Stream descriptor
  * @stream_handle: Stream handle returned by stream connect
+ * @stream_created: RMM allocated a stream, including incomplete setup
  * @rmi_signature_algorithm: Signature algorithm used for public key
  * @cert_chain: cetrificate chain
  * @vca: SPDM's Version-Capabilities-Algorithms cache object
@@ -96,6 +97,7 @@ struct cca_host_pf0_ep_dsc {
 	struct cca_host_pdev_dsc pdev;
 	struct pci_ide *sel_stream;
 	unsigned long stream_handle;
+	bool stream_created;
 
 	char *rmi_signature_algorithm;
 	struct {
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 8fd209a2c32b..a2b439edbd0c 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -88,11 +88,11 @@ struct pci_tsm_ops {
 	 * @probe: establish context with the TSM (allocate / wrap 'struct
 	 *	   pci_tsm') for follow-on link operations
 	 * @remove: destroy link operations context
-	 * @connect: collect device identity; required for link backends; legacy
-	 *	     backends may also establish IDE
+	 * @connect: collect device identity; required for link backends;
+	 *	     session and IDE setup must wait for @evidence_accept
 	 * @evidence_accept: establish the secure session and IDE after evidence
 	 *		  acceptance, using pci_tsm::evidence.slot as the selected
-	 *		  certificate slot; optional for legacy backends
+	 *		  certificate slot; required for link backends
 	 * @disconnect: teardown the secure link
 	 *
 	 * Context: All callbacks run under pci_tsm_rwsem held for write to sync
diff --git a/samples/devsec/link_tsm.c b/samples/devsec/link_tsm.c
index 61cf6c16e1b5..a6644b276a88 100644
--- a/samples/devsec/link_tsm.c
+++ b/samples/devsec/link_tsm.c
@@ -132,6 +132,10 @@ static void devsec_link_tsm_pci_remove(struct pci_tsm *tsm)
 static DECLARE_BITMAP(devsec_stream_ids, NR_TSM_STREAMS);
 static struct pci_ide *devsec_streams[NR_TSM_STREAMS];
 
+static bool fail_stream_connect;
+module_param(fail_stream_connect, bool, 0600);
+MODULE_PARM_DESC(fail_stream_connect, "Fail stream setup after identity collection");
+
 static unsigned long *alloc_devsec_stream_id(unsigned long *stream_id)
 {
 	unsigned long id;
@@ -146,7 +150,7 @@ static unsigned long *alloc_devsec_stream_id(unsigned long *stream_id)
 DEFINE_FREE(free_devsec_stream, unsigned long *, if (_T) clear_bit(*_T, devsec_stream_ids))
 
 /*
- * Reference consumer for a TSM driver "connect" operation callback. The
+ * Reference consumer for a TSM driver "evidence_accept" operation callback. The
  * low-level TSM driver understands details about the platform the PCI
  * core does not, like number of available streams that can be
  * established per host bridge. The expected flow is:
@@ -168,11 +172,20 @@ DEFINE_FREE(free_devsec_stream, unsigned long *, if (_T) clear_bit(*_T, devsec_s
  * or use model sequencing.
  */
 static int devsec_link_tsm_connect(struct pci_dev *pdev)
+{
+	/* probe() populated the synthetic identity; allocate streams on accept. */
+	return 0;
+}
+
+static int devsec_link_tsm_evidence_accept(struct pci_dev *pdev)
 {
 	struct pci_dev *rp = pcie_find_root_port(pdev);
 	unsigned long __stream_id;
 	int rc;
 
+	if (fail_stream_connect)
+		return -EIO;
+
 	dev_dbg(pci_tsm_host(pdev), "%s\n", pci_name(pdev));
 
 	unsigned long *stream_id __free(free_devsec_stream) =
@@ -235,6 +248,7 @@ static struct pci_tsm_ops devsec_link_pci_ops = {
 	.probe = devsec_link_tsm_pci_probe,
 	.remove = devsec_link_tsm_pci_remove,
 	.connect = devsec_link_tsm_connect,
+	.evidence_accept = devsec_link_tsm_evidence_accept,
 	.disconnect = devsec_link_tsm_disconnect,
 };
 
-- 
2.43.0

