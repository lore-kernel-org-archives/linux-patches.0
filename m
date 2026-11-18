Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060974;
	b=p8QU5cvCjtB28ofiFFCcnqBNDrFM5M+24E+R9sNRtVvd4HipfsqiK97YimhegrqjAs0z
	 b/MhA7b7KVIF1YNqomjhlwamRPXGUmgMnSEIv1M11bc6qnwdiI/SODWnd0aCnjdGlDfSR
	 jEAyxPLWNKUHeUYdqFR7axh6bX8zZlholyn5i8JMYHuBeNU8vZ4iUZ0xznTif5Okfkyo9
	 kbmdFq+0NyOQSzyMCfnTiB/E7bzskUgwT8VWgGrDgBsCJ1FILV4gUjwzykC4jkDC7F4+1
	 IVM0RomOCxvI8FKUdx3LsNdVzZV71bx+5NUDdegTh54T//R8n7WcDK3DdSAuNHTodtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lSpTAcQEMXp11no/4wwI/qrjRu5zfC4g7tGCr8Nm7uA=;
	b=BNqtugGXdD9xwIsk49ssiVvFKj59BuM2uP9PDUCiNP+a7JGvyXo2xYm2V+XxUDJUX6WP
	 4K1ejmMetPiVbHooAdYoCJtqe2wBXt+dsTctZo3HkV9hZ08hAZeHNslAr0h04+k0+jY6L
	 4ODGze+hcSjNyQLN/mNLtXoMvFRkOTyUBSBo/g0aLef1X6kgG4liudXRdRnkJq6GtTMbJ
	 8EMzTceZlM3VKDgNMQkqC/YGo5xfX5za8526jc0mmkgTZ5Wv2aELuW6CUPfYmex/mrSlx
	 qAk9RRzfoZ5GCf7lkwrJhrD5a3fx6VHiV/nZ1nPCSBB/6FDKUaFGIzhL/YPmLzHtG9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2ZT/PC4+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCABC606A325;
	Thu, 19 Nov 2026 04:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZT/PC4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD161F000C4;
	Thu, 19 Nov 2026 04:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060974;
	bh=lSpTAcQEMXp11no/4wwI/qrjRu5zfC4g7tGCr8Nm7uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZT/PC4+1U1jpiV1TXSTfkruSUG3z/e5ZcIJR/pAlrkLQJa2YAB1CTlNUgZb3AHAO
	 JCjmkyW7yJBe7+dswes8G20GejdGL15d7ezakBRwh24aez4JsripN9vLXlXkvPpdah
	 ORw2L2VUHMJGG5ZnLhh9AO18ybXeUiS+GxAzpVSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	Guo Kaijie <Kaijie.Guo@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1374/1848] iommu/vt-d: Report more information about invalidation errors
Date: Wed, 18 Nov 2026 15:56:52 +0100
Message-ID: <20261118150017.046768695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 6ca69e5841f01ccbfa45e56577e1b33e14e53504 ]

When the invalidation queue errors are encountered, dump the information
logged by the VT-d hardware together with the pending queue invalidation
descriptors.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Tested-by: Guo Kaijie <Kaijie.Guo@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210318005340.187311-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 754d07b940c4 ("iommu/vt-d: Fix IQE handling to cover all descriptors in submission range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c  | 68 ++++++++++++++++++++++++++++++++++---
 include/linux/intel-iommu.h |  6 ++++
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 9b6aa97be7b51..79f593bc8288a 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1199,6 +1199,63 @@ static inline void reclaim_free_desc(struct q_inval *qi)
 	}
 }
 
+static const char *qi_type_string(u8 type)
+{
+	switch (type) {
+	case QI_CC_TYPE:
+		return "Context-cache Invalidation";
+	case QI_IOTLB_TYPE:
+		return "IOTLB Invalidation";
+	case QI_DIOTLB_TYPE:
+		return "Device-TLB Invalidation";
+	case QI_IEC_TYPE:
+		return "Interrupt Entry Cache Invalidation";
+	case QI_IWD_TYPE:
+		return "Invalidation Wait";
+	case QI_EIOTLB_TYPE:
+		return "PASID-based IOTLB Invalidation";
+	case QI_PC_TYPE:
+		return "PASID-cache Invalidation";
+	case QI_DEIOTLB_TYPE:
+		return "PASID-based Device-TLB Invalidation";
+	case QI_PGRP_RESP_TYPE:
+		return "Page Group Response";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static void qi_dump_fault(struct intel_iommu *iommu, u32 fault)
+{
+	unsigned int head = dmar_readl(iommu->reg + DMAR_IQH_REG);
+	u64 iqe_err = dmar_readq(iommu->reg + DMAR_IQER_REG);
+	struct qi_desc *desc = iommu->qi->desc + head;
+
+	if (fault & DMA_FSTS_IQE)
+		pr_err("VT-d detected Invalidation Queue Error: Reason %llx",
+		       DMAR_IQER_REG_IQEI(iqe_err));
+	if (fault & DMA_FSTS_ITE)
+		pr_err("VT-d detected Invalidation Time-out Error: SID %llx",
+		       DMAR_IQER_REG_ITESID(iqe_err));
+	if (fault & DMA_FSTS_ICE)
+		pr_err("VT-d detected Invalidation Completion Error: SID %llx",
+		       DMAR_IQER_REG_ICESID(iqe_err));
+
+	pr_err("QI HEAD: %s qw0 = 0x%llx, qw1 = 0x%llx\n",
+	       qi_type_string(desc->qw0 & 0xf),
+	       (unsigned long long)desc->qw0,
+	       (unsigned long long)desc->qw1);
+
+	head = ((head >> qi_shift(iommu)) + QI_LENGTH - 1) % QI_LENGTH;
+	head <<= qi_shift(iommu);
+	desc = iommu->qi->desc + head;
+
+	pr_err("QI PRIOR: %s qw0 = 0x%llx, qw1 = 0x%llx\n",
+	       qi_type_string(desc->qw0 & 0xf),
+	       (unsigned long long)desc->qw0,
+	       (unsigned long long)desc->qw1);
+}
+
 static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 {
 	u32 fault;
@@ -1210,6 +1267,8 @@ static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 		return -EAGAIN;
 
 	fault = readl(iommu->reg + DMAR_FSTS_REG);
+	if (fault & (DMA_FSTS_IQE | DMA_FSTS_ITE | DMA_FSTS_ICE))
+		qi_dump_fault(iommu, fault);
 
 	/*
 	 * If IQE happens, the head points to the descriptor associated
@@ -1226,12 +1285,10 @@ static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 			 * used by software as private data. We won't print
 			 * out these two qw's for security consideration.
 			 */
-			pr_err("VT-d detected invalid descriptor: qw0 = %llx, qw1 = %llx\n",
-			       (unsigned long long)desc->qw0,
-			       (unsigned long long)desc->qw1);
 			memcpy(desc, qi->desc + (wait_index << shift),
 			       1 << shift);
 			writel(DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
+			pr_info("Invalidation Queue Error (IQE) cleared\n");
 			return -EINVAL;
 		}
 	}
@@ -1247,6 +1304,7 @@ static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 		tail = ((tail >> shift) - 1 + QI_LENGTH) % QI_LENGTH;
 
 		writel(DMA_FSTS_ITE, iommu->reg + DMAR_FSTS_REG);
+		pr_info("Invalidation Time-out Error (ITE) cleared\n");
 
 		do {
 			if (qi->desc_status[head] == QI_IN_USE)
@@ -1258,8 +1316,10 @@ static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 			return -EAGAIN;
 	}
 
-	if (fault & DMA_FSTS_ICE)
+	if (fault & DMA_FSTS_ICE) {
 		writel(DMA_FSTS_ICE, iommu->reg + DMAR_FSTS_REG);
+		pr_info("Invalidation Completion Error (ICE) cleared\n");
+	}
 
 	return 0;
 }
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 142ec79cda84f..8b70f929bb737 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -20,6 +20,7 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/dmar.h>
 #include <linux/ioasid.h>
+#include <linux/bitfield.h>
 
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -80,6 +81,7 @@
 #define DMAR_IQ_SHIFT	4	/* Invalidation queue head/tail shift */
 #define DMAR_IQA_REG	0x90	/* Invalidation queue addr register */
 #define DMAR_ICS_REG	0x9c	/* Invalidation complete status register */
+#define DMAR_IQER_REG	0xb0	/* Invalidation queue error record register */
 #define DMAR_IRTA_REG	0xb8    /* Interrupt remapping table addr register */
 #define DMAR_PQH_REG	0xc0	/* Page request queue head register */
 #define DMAR_PQT_REG	0xc8	/* Page request queue tail register */
@@ -126,6 +128,10 @@
 #define DMAR_VCMD_REG		0xe00 /* Virtual command register */
 #define DMAR_VCRSP_REG		0xe10 /* Virtual command response register */
 
+#define DMAR_IQER_REG_IQEI(reg)		FIELD_GET(GENMASK_ULL(3, 0), reg)
+#define DMAR_IQER_REG_ITESID(reg)	FIELD_GET(GENMASK_ULL(47, 32), reg)
+#define DMAR_IQER_REG_ICESID(reg)	FIELD_GET(GENMASK_ULL(63, 48), reg)
+
 #define OFFSET_STRIDE		(9)
 
 #define dmar_readq(a) readq(a)
-- 
2.53.0



