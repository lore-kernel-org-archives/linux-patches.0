Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215925;
	b=pAAke8wJgHs+HV9c8s2njcNicOIpFofAlpGteHROoypBGxetKUbWX4cF6bmfk9dR0qvU
	 dgM/TBVbZg0dGKZdpF1UYM944O9yRG7JGciPfFr7uTzq1vm03mU9EhG6eSpHqv3T14ABr
	 cGDryFjXCV7vDpyMMouklcr3uee/2Uf3ypEotHLfQUX+VLwxKoWGSDuL4KLuOKAiKRUGT
	 ewZaUx4MfKQvUJ+aU6K/yAMX+yRLEcTMpmVRfRlUz433ZyA7Ro8CPvq/NMsWmS73aPsXp
	 cv6aACXIYtWql+R6QZ1LVqWofR93VC9218kjMUCQWsW66urP+HFhOhS71P61HhEb/8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3h2JuEet1A5KNpdHrYVcq9Cu5PAi8aCmLxztT36ohSY=;
	b=nrr+sfXdy+IBwc9C8ZFrzkg9JnzSATjG5g9ZEM+AiWVGZb5AwD66LhdWnYH2s0MbJZCr
	 A1pSRQX7aMNe7wzIZGg6aGVoj4Lm1fUt07AFPfnGdHKLVscvqCl6+xlQYIAvIpdzDGmu0
	 7UyXUh4iivecM1kACzeuZCvqro7NWdh4Ea7Bj8lHXJTvejY+H1Ji6DSzZzwgIc8YUfbzV
	 Q0tsa1gt/aaqFANw1vpR0ps5/RJrZizJrhP3/iehdK3XNApffGCniVQS4Q/zCd5iKRk+6
	 01e9mDgA/wgYBLLCMECC8uDbA6wHtL7+igsaxpDl+OZBGR80JOjGfNA9CANlSR5YH+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zwRQ/IgO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0629B606A31A;
	Wed, 28 Oct 2026 19:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwRQ/IgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4921F01825;
	Wed, 28 Oct 2026 19:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215924;
	bh=3h2JuEet1A5KNpdHrYVcq9Cu5PAi8aCmLxztT36ohSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwRQ/IgOQLau/S7J3Wyka6nKt+M1PLvrlM93DNW5rrOblYHdT2lvXvbJIbQ7J0jyn
	 syBj4+9AbXC31UvFb3WQBUT9DdrD4jJr9K2PxGgq+qacGBXBsyXUdxhw2YdiX9srUM
	 fInthlmjUl5ArpKhOzVdrR52UAS11POCuiFwxgys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>,
	Tony Zhu <tony.zhu@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1381/1887] iommu: Add max_pasids field in struct iommu_device
Date: Wed, 28 Oct 2026 17:57:57 +0100
Message-ID: <20261028170530.873145011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 1adf3cc20d693569ebee90fd91fa34b0570fcd6f ]

Use this field to keep the number of supported PASIDs that an IOMMU
hardware is able to support. This is a generic attribute of an IOMMU
and lifting it into the per-IOMMU device structure makes it possible
to allocate a PASID for device without calls into the IOMMU drivers.
Any iommu driver that supports PASID related features should set this
field before enabling them on the devices.

In the Intel IOMMU driver, intel_iommu_sm is moved to CONFIG_INTEL_IOMMU
enclave so that the pasid_supported() helper could be used in dmar.c
without compilation errors.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Tested-by: Tony Zhu <tony.zhu@intel.com>
Link: https://lore.kernel.org/r/20221031005917.45690-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 607432b2618b ("iommu/vt-d: Force requesting ACS when tboot is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 1 +
 drivers/iommu/intel/dmar.c                  | 7 +++++++
 drivers/iommu/intel/iommu.h                 | 4 ++--
 include/linux/iommu.h                       | 2 ++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 33f3c5e6b3320..a4e4849c1c8e5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3623,6 +3623,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/* SID/SSID sizes */
 	smmu->ssid_bits = FIELD_GET(IDR1_SSIDSIZE, reg);
 	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
+	smmu->iommu.max_pasids = 1UL << smmu->ssid_bits;
 
 	/*
 	 * If the SMMU supports fewer bits than would fill a single L2 stream
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 47ac10fb76db3..75eb4bd5ebb74 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1106,6 +1106,13 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	raw_spin_lock_init(&iommu->register_lock);
 
+	/*
+	 * A value of N in PSS field of eCap register indicates hardware
+	 * supports PASID field of N+1 bits.
+	 */
+	if (pasid_supported(iommu))
+		iommu->iommu.max_pasids = 2UL << ecap_pss(iommu->ecap);
+
 	/*
 	 * This is only for hotplug; at boot time intel_iommu_enabled won't
 	 * be set yet. When intel_iommu_init() runs, it registers the units
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index c99cb715bd9a2..5116105671727 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -480,8 +480,6 @@ enum {
 #define VTD_FLAG_IRQ_REMAP_PRE_ENABLED	(1 << 1)
 #define VTD_FLAG_SVM_CAPABLE		(1 << 2)
 
-extern int intel_iommu_sm;
-
 #define sm_supported(iommu)	(intel_iommu_sm && ecap_smts((iommu)->ecap))
 #define pasid_supported(iommu)	(sm_supported(iommu) &&			\
 				 ecap_pasid((iommu)->ecap))
@@ -799,6 +797,7 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 extern const struct iommu_ops intel_iommu_ops;
 
 #ifdef CONFIG_INTEL_IOMMU
+extern int intel_iommu_sm;
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
 extern int dmar_disabled;
@@ -814,6 +813,7 @@ static inline int iommu_calculate_max_sagaw(struct intel_iommu *iommu)
 }
 #define dmar_disabled	(1)
 #define intel_iommu_enabled (0)
+#define intel_iommu_sm (0)
 #endif
 
 static inline const char *decode_prq_descriptor(char *str, size_t size,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2bfa9611be672..780b688e4e043 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -322,12 +322,14 @@ struct iommu_domain_ops {
  * @list: Used by the iommu-core to keep a list of registered iommus
  * @ops: iommu-ops for talking to this iommu
  * @dev: struct device for sysfs handling
+ * @max_pasids: number of supported PASIDs
  */
 struct iommu_device {
 	struct list_head list;
 	const struct iommu_ops *ops;
 	struct fwnode_handle *fwnode;
 	struct device *dev;
+	u32 max_pasids;
 };
 
 /**
-- 
2.53.0



