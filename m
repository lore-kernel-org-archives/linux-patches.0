Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594416;
	b=jDfve0bavgSAhXu+gT+KDerjsLnFTsy5xMCYnfyGoF9xzBFzBe956KseSvNQlA1utimK
	 PkRF35Rc/D0qwt5RwH42moX60NmQpE/6CR4e+x+WalfkRp6a2KmoP5ZiQx+t9q+Hmx5PH
	 qj+kCa1/Rjc0AcJeEdU29eMqzpPciyN+wWBAKmlUMxLwYUSiTQCJORkONxq1QemINZXGm
	 4jFO8Y+0P9Ga6Qiyhes2MOZDtLmgLe046C+4VqLA1yoxKQODlF1+TIpntNJeT+9uaFBfR
	 vSBkctuYlRVkTKS+tG2k8Vn5kcD4ASnuAzaqXVIzjlAdRScQICn/QqrD0Ak6+7NvX4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=B82UJrpQi9umGTi4HsQSfxMUzEkhSimmx1lnjHTY/ys=;
	b=Udlx8zghLrSstoE3jZx6CwLZs4gZlIV8K8MYCUhClUpZwdLCZpUgXSkm18JMKUvuOCs3
	 nov1QdAmIyl39u89rak84Pb5JhD7rhox3yUdkflIEBh18T5pz+jO4EgVAQA0d1eyGFmGr
	 MiMAiwpvF6Xp5d00vFCmwDOd/Mtc9bDoNNSpL4O5iqW/L/3NUNiF4TwcjIQCkwR2B5dgf
	 Mxm7kUbt18lSGv0VqT3w3DN9JsDxTDg3x0sBZjzZE3F/Qtv0qwl7ps3UT4NnIuLfuhKJO
	 inkrzdSpQxicZl4rdAbkrcmVAqd7Ra0J/VtcCTBwqUSvDqK6kBlrToSCBF2jI96voLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bh1zOmh9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5634606A321;
	Wed, 25 Nov 2026 08:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bh1zOmh9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BD61F000CA;
	Wed, 25 Nov 2026 08:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594416;
	bh=B82UJrpQi9umGTi4HsQSfxMUzEkhSimmx1lnjHTY/ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bh1zOmh9Odb+urHpPxR6UlEKOhHJMhO0uqKEQGCBILDS1U1FwYwRvA6QRcu74JkFe
	 qSzPa0cKPTIiMtEzeW9VpkFjACQp53+Rx4ysY6ymGCXunuzTbW12pFTEHDQAEFOLIA
	 9g8oQOCdwa4z5nkqm994ElgF6xDz3cdVVAe8/V0fYveyRqJq19ov/YVmfLbhAJA6dM
	 FnfUwGp0yKddhQWw1Af1BETNjpv9ZENwes+RMzOBmUmT5seOiWLrUBUdubG7H9Hdwa
	 w3h8pRvzzd3rdWiZMqk2J0BhFaV4GW99V9ajPAPjqZqH1BPvwsEaPIUQb03tVw2Eov
	 Mx5a8YuyMd0cQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v10 09/18] PCI/TSM: Remove the legacy guest request interface
Date: Wed, 25 Nov 2026 13:41:12 +0530
Message-ID: <20261125081121.379481-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261125081121.379481-1-aneesh.kumar@kernel.org>
References: <20261125081121.379481-1-aneesh.kumar@kernel.org>
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

Guest TSM requests can now be dispatched through the IOMMUFD
IOMMU_VDEVICE_OP ioctl. Remove the PCI-device-based guest request entry
point, its scope enum and the corresponding PCI/TSM driver callback.


Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/pci/tsm.c       | 60 ----------------------------------------
 include/linux/pci-tsm.h | 61 +----------------------------------------
 2 files changed, 1 insertion(+), 120 deletions(-)

diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 5fdcd7f2e820..1423c64dc9c8 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -375,66 +375,6 @@ int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u32 tdi_id)
 }
 EXPORT_SYMBOL_GPL(pci_tsm_bind);
 
-/**
- * pci_tsm_guest_req() - helper to marshal guest requests to the TSM driver
- * @pdev: @pdev representing a bound tdi
- * @scope: caller asserts this passthrough request is limited to TDISP operations
- * @req_in: Input payload forwarded from the guest
- * @in_len: Length of @req_in
- * @req_out: Output payload buffer response to the guest
- * @out_len: Length of @req_out on input, bytes filled in @req_out on output
- * @tsm_code: Optional TSM arch specific result code for the guest TSM
- *
- * This is a common entry point for requests triggered by userspace KVM-exit
- * service handlers responding to TDI information or state change requests. The
- * scope parameter limits requests to TDISP state management, or limited debug.
- * This path is only suitable for commands and results that are the host kernel
- * has no use, the host is only facilitating guest to TSM communication.
- *
- * Returns 0 on success and -error on failure and positive "residue" on success
- * but @req_out is filled with less then @out_len, or @req_out is NULL and a
- * residue number of bytes were not consumed from @req_in.  On success or
- * failure @tsm_code may be populated with a TSM implementation specific result
- * code for the guest to consume.
- *
- * Context: Caller is responsible for calling this within the pci_tsm_bind()
- * state of the TDI.
- */
-ssize_t pci_tsm_guest_req(struct pci_dev *pdev, enum pci_tsm_req_scope scope,
-			  sockptr_t req_in, size_t in_len, sockptr_t req_out,
-			  size_t out_len, u64 *tsm_code)
-{
-	struct pci_tsm_pf0 *tsm_pf0;
-	struct pci_tdi *tdi;
-	int rc;
-
-	/* Forbid requests that are not directly related to TDISP operations */
-	if (scope > PCI_TSM_REQ_STATE_CHANGE)
-		return -EINVAL;
-
-	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &lock)))
-		return rc;
-
-	if (!pdev->tsm)
-		return -ENXIO;
-
-	if (!is_link_tsm(pdev->tsm->tsm_dev))
-		return -ENXIO;
-
-	tsm_pf0 = to_pci_tsm_pf0(pdev->tsm);
-	ACQUIRE(mutex_intr, ops_lock)(&tsm_pf0->lock);
-	if ((rc = ACQUIRE_ERR(mutex_intr, &ops_lock)))
-		return rc;
-
-	tdi = pdev->tsm->tdi;
-	if (!tdi)
-		return -ENXIO;
-	return to_pci_tsm_ops(pdev->tsm)->guest_req(tdi, scope, req_in, in_len,
-						    req_out, out_len, tsm_code);
-}
-EXPORT_SYMBOL_GPL(pci_tsm_guest_req);
-
 static void pci_tsm_unbind_all(struct pci_dev *pdev)
 {
 	pci_tsm_walk_fns_reverse(pdev, __pci_tsm_unbind, NULL);
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index a6435aba03f9..6fe3d0ea875f 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -3,12 +3,10 @@
 #define __PCI_TSM_H
 #include <linux/mutex.h>
 #include <linux/pci.h>
-#include <linux/sockptr.h>
 
 struct pci_tsm;
 struct tsm_dev;
 struct kvm;
-enum pci_tsm_req_scope;
 
 /*
  * struct pci_tsm_ops - manage confidential links and security state
@@ -34,14 +32,13 @@ struct pci_tsm_ops {
 	 * @disconnect: teardown the secure link
 	 * @bind: bind a TDI in preparation for it to be accepted by a TVM
 	 * @unbind: remove a TDI from secure operation with a TVM
-	 * @guest_req: marshal TVM information and state change requests
 	 *
 	 * Context: @probe, @remove, @connect, and @disconnect run under
 	 * pci_tsm_rwsem held for write to sync with TSM unregistration and
 	 * mutual exclusion of @connect and @disconnect. @connect and
 	 * @disconnect additionally run under the DSM lock (struct
 	 * pci_tsm_pf0::lock) as well as @probe and @remove of the subfunctions.
-	 * @bind, @unbind, and @guest_req run under pci_tsm_rwsem held for read
+	 * @bind and @unbind run under pci_tsm_rwsem held for read
 	 * and the DSM lock.
 	 */
 	struct_group_tagged(pci_tsm_link_ops, link_ops,
@@ -53,11 +50,6 @@ struct pci_tsm_ops {
 		struct pci_tdi *(*bind)(struct pci_dev *pdev,
 					struct kvm *kvm, u32 tdi_id);
 		void (*unbind)(struct pci_tdi *tdi);
-		ssize_t (*guest_req)(struct pci_tdi *tdi,
-				     enum pci_tsm_req_scope scope,
-				     sockptr_t req_in, size_t in_len,
-				     sockptr_t req_out, size_t out_len,
-				     u64 *tsm_code);
 	);
 
 	/*
@@ -159,46 +151,6 @@ static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
 	return PCI_FUNC(pdev->devfn) == 0;
 }
 
-/**
- * enum pci_tsm_req_scope - Scope of guest requests to be validated by TSM
- *
- * Guest requests are a transport for a TVM to communicate with a TSM + DSM for
- * a given TDI. A TSM driver is responsible for maintaining the kernel security
- * model and limit commands that may affect the host, or are otherwise outside
- * the typical TDISP operational model.
- */
-enum pci_tsm_req_scope {
-	/**
-	 * @PCI_TSM_REQ_INFO: Read-only, without side effects, request for
-	 * typical TDISP collateral information like Device Interface Reports.
-	 * No device secrets are permitted, and no device state is changed.
-	 */
-	PCI_TSM_REQ_INFO = 0,
-	/**
-	 * @PCI_TSM_REQ_STATE_CHANGE: Request to change the TDISP state from
-	 * UNLOCKED->LOCKED, LOCKED->RUN, or other architecture specific state
-	 * changes to support those transitions for a TDI. No other (unrelated
-	 * to TDISP) device / host state, configuration, or data change is
-	 * permitted.
-	 */
-	PCI_TSM_REQ_STATE_CHANGE = 1,
-	/**
-	 * @PCI_TSM_REQ_DEBUG_READ: Read-only request for debug information
-	 *
-	 * A method to facilitate TVM information retrieval outside of typical
-	 * TDISP operational requirements. No device secrets are permitted.
-	 */
-	PCI_TSM_REQ_DEBUG_READ = 2,
-	/**
-	 * @PCI_TSM_REQ_DEBUG_WRITE: Device state changes for debug purposes
-	 *
-	 * The request may affect the operational state of the device outside of
-	 * the TDISP operational model. If allowed, requires CAP_SYS_RAW_IO, and
-	 * will taint the kernel.
-	 */
-	PCI_TSM_REQ_DEBUG_WRITE = 3,
-};
-
 #ifdef CONFIG_PCI_TSM
 int pci_tsm_register(struct tsm_dev *tsm_dev);
 void pci_tsm_unregister(struct tsm_dev *tsm_dev);
@@ -213,9 +165,6 @@ int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u32 tdi_id);
 void pci_tsm_unbind(struct pci_dev *pdev);
 void pci_tsm_tdi_constructor(struct pci_dev *pdev, struct pci_tdi *tdi,
 			     struct kvm *kvm, u32 tdi_id);
-ssize_t pci_tsm_guest_req(struct pci_dev *pdev, enum pci_tsm_req_scope scope,
-			  sockptr_t req_in, size_t in_len, sockptr_t req_out,
-			  size_t out_len, u64 *tsm_code);
 #else
 static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
 {
@@ -231,13 +180,5 @@ static inline int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u64 tdi_id
 static inline void pci_tsm_unbind(struct pci_dev *pdev)
 {
 }
-static inline ssize_t pci_tsm_guest_req(struct pci_dev *pdev,
-					enum pci_tsm_req_scope scope,
-					sockptr_t req_in, size_t in_len,
-					sockptr_t req_out, size_t out_len,
-					u64 *tsm_code)
-{
-	return -ENXIO;
-}
 #endif
 #endif /*__PCI_TSM_H */
-- 
2.43.0

