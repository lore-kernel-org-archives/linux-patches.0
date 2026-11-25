Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594453;
	b=IGzi5GwH4YtDKpfWWrizpbT5wSwSaevFa8ubhT4EV91JZ/K4CX3pfK/pBRKSIBOL/IJg
	 ojpsL54h3FoeE/yfxJoahaqpDsQBUJ6d45O8jZSRgFWFQZObZzF5UidP4ly2r8wORtTyv
	 McFQyTmwjWlv+1rdfkxIz5QpisZ6o00JYz12det/EoOVoBOy0SvueDib5b2k3iyHGY2Ki
	 1apDXR8U6G0aFZu0Jcdsn6MlUirh+d6razEMkpWOOsV2EPcKzD2hXwv70uI3HDr2bYVAj
	 nvXY6mDKp6DoLM0ldZkQwgRGU3kUjsB6uc5nC9u6EtQZ6xP9ort4DAVYbnQQZV18PKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=b2+WTLeN3ZTPMpF2B7zgSS4pQdhcz6W8PlTvzyK6kOU=;
	b=lrn/W1kBC/+WKKMTZadvxclxzB/ckqFhOfITHK0Q2XtRvi/KG/MuMSoD70N9Hkgg9AT0
	 tFMbJ1/n8RRBl+BsRHItkYFZtLOO3QnuWFF2DZum5Yxvs1uXm5OLPkZCQzT1+fyMsP3Ar
	 YxGuUNhLRigwPdbMeMGlLrKa07lghzR3ZYrWzxWr/7cX7MV3tEh9N7MyiReWkp7fd5RHc
	 cO68Ga7iLWOV8gkmKKsTRsZ+O61znNrnobpN8zlVsz/SkFIQ+zQWYP8gzQWxJijeZ4Bck
	 OovFtHgDe8Aw91quw/snUZTKGeKebPnx8KkTvzb8CPBdYl9UPXy4KupkpYVP6QA9A2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MMIQUTZt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9815606A31E;
	Wed, 25 Nov 2026 08:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MMIQUTZt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2001F000D1;
	Wed, 25 Nov 2026 08:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594453;
	bh=b2+WTLeN3ZTPMpF2B7zgSS4pQdhcz6W8PlTvzyK6kOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMIQUTZturWyurWYcK3nSoKdM1IyCp8ch0cByn26jdy7x69HX4ymaZsFJeYZ0+IQD
	 2C68PJu4so2Z1rccMSaBdo/7T/lnNd2DhJpw8s7voMibBJHb1Qd9+QRr8UA4xM0jwT
	 yQVeH5+4CfrSfZvWFb+WMdpMnJA48CYgiS/c5Ppnryc98qNwpdHhhW0zGi5YWlWy7W
	 LoZ799/D1IYHEII3ApI5DUyiC6VU0qOTbuXnTSHblWAijzDwGyK7HDshQSb5+loyaL
	 lBk/PyLKG5r4+4CFWj1HyxfRhfD9/lcTdcoJQQ4lzRBMwFTHF7pMsS5Tetj4TmKlvv
	 /f3ataziksQOw==
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
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v10 12/18] iommufd/viommu: Select vIOMMU operations before allocation
Date: Wed, 25 Nov 2026 13:41:15 +0530
Message-ID: <20261125081121.379481-13-aneesh.kumar@kernel.org>
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

Physical IOMMU drivers currently provide the vIOMMU size and
initialization callbacks through iommu_ops. The initialization callback
then selects and installs the corresponding iommufd_viommu_ops.

Add iommu_ops::get_viommu_ops() to select the operations from the
physical device and requested vIOMMU type before allocation. Move the
size and initialization callbacks into iommufd_viommu_ops. The core can
then validate the selected operations, allocate the driver structure,
initialize it, and install the operations.

Convert AMD, Arm SMMUv3, Tegra CMDQV, and the selftest backend to the
new interface.

The current code requires a valid parent HWPT before calling
viommu_init(), which selects the vIOMMU operations. A later patch adds
an operations flag indicating that a vIOMMU type does not require a
parent HWPT. Selecting the operations earlier allows the core to check
that flag before deciding whether to look up and validate a parent HWPT.

Temporarily disable AMD vIOMMU allocation by returning NULL from
amd_iommufd_get_viommu_ops() while the vIOMMU interfaces are being
updated.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Thierry Reding <thierry.reding@kernel.org>
Cc: Krishna Reddy <vdumpa@nvidia.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-tegra@vger.kernel.org
Cc: iommu@lists.linux.dev
Based on original patch by Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com> (For changes in iommufd/viommu common code)
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/amd/iommu.c                     |  3 +-
 drivers/iommu/amd/iommufd.c                   | 18 ++++++---
 drivers/iommu/amd/iommufd.h                   | 11 ++++--
 drivers/iommu/amd/nested.c                    |  4 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 38 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  7 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 16 ++++----
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 25 ++++++++----
 drivers/iommu/iommufd/selftest.c              | 32 +++++++++++-----
 drivers/iommu/iommufd/viommu.c                | 32 ++++++++--------
 include/linux/iommu.h                         | 20 +++-------
 include/linux/iommufd.h                       | 14 +++++++
 12 files changed, 133 insertions(+), 87 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 41ee4ad1dcf8..2b318d8c82a0 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3265,8 +3265,7 @@ const struct iommu_ops amd_iommu_ops = {
 	.is_attach_deferred = amd_iommu_is_attach_deferred,
 	.def_domain_type = amd_iommu_def_domain_type,
 	.page_response = amd_iommu_page_response,
-	.get_viommu_size = amd_iommufd_get_viommu_size,
-	.viommu_init = amd_iommufd_viommu_init,
+	.get_viommu_ops = amd_iommufd_get_viommu_ops,
 };
 
 #ifdef CONFIG_IRQ_REMAP
diff --git a/drivers/iommu/amd/iommufd.c b/drivers/iommu/amd/iommufd.c
index 52300b867c1f..dcbe80fcb8c7 100644
--- a/drivers/iommu/amd/iommufd.c
+++ b/drivers/iommu/amd/iommufd.c
@@ -32,13 +32,21 @@ void *amd_iommufd_hw_info(struct device *dev, u32 *length, enum iommu_hw_info_ty
 	return hwinfo;
 }
 
-size_t amd_iommufd_get_viommu_size(struct device *dev, enum iommu_viommu_type viommu_type)
+static size_t amd_iommufd_get_viommu_size(struct device *dev,
+		enum iommu_viommu_type viommu_type)
 {
 	return VIOMMU_STRUCT_SIZE(struct amd_iommu_viommu, core);
 }
 
-int amd_iommufd_viommu_init(struct iommufd_viommu *viommu, struct iommu_domain *parent,
-			    const struct iommu_user_data *user_data)
+const struct iommufd_viommu_ops *
+amd_iommufd_get_viommu_ops(struct device *dev, enum iommu_viommu_type viommu_type)
+{
+	return NULL;
+}
+
+int amd_iommufd_viommu_init(struct iommufd_viommu *viommu,
+		struct device *dev, struct iommu_domain *parent,
+		const struct iommu_user_data *user_data)
 {
 	unsigned long flags;
 	struct protection_domain *pdom = to_pdomain(parent);
@@ -47,8 +55,6 @@ int amd_iommufd_viommu_init(struct iommufd_viommu *viommu, struct iommu_domain *
 	xa_init_flags(&aviommu->gdomid_array, XA_FLAGS_ALLOC1);
 	aviommu->parent = pdom;
 
-	viommu->ops = &amd_viommu_ops;
-
 	spin_lock_irqsave(&pdom->lock, flags);
 	list_add(&aviommu->pdom_list, &pdom->viommu_list);
 	spin_unlock_irqrestore(&pdom->lock, flags);
@@ -73,5 +79,7 @@ static void amd_iommufd_viommu_destroy(struct iommufd_viommu *viommu)
  * struct iommufd_viommu_ops - vIOMMU specific operations
  */
 static const struct iommufd_viommu_ops amd_viommu_ops = {
+	.get_viommu_size = amd_iommufd_get_viommu_size,
+	.viommu_init = amd_iommufd_viommu_init,
 	.destroy = amd_iommufd_viommu_destroy,
 };
diff --git a/drivers/iommu/amd/iommufd.h b/drivers/iommu/amd/iommufd.h
index 62e9e1bebfbe..0d8e7c0902cf 100644
--- a/drivers/iommu/amd/iommufd.h
+++ b/drivers/iommu/amd/iommufd.h
@@ -8,13 +8,16 @@
 
 #if IS_ENABLED(CONFIG_AMD_IOMMU_IOMMUFD)
 void *amd_iommufd_hw_info(struct device *dev, u32 *length, enum iommu_hw_info_type *type);
-size_t amd_iommufd_get_viommu_size(struct device *dev, enum iommu_viommu_type viommu_type);
-int amd_iommufd_viommu_init(struct iommufd_viommu *viommu, struct iommu_domain *parent,
-			    const struct iommu_user_data *user_data);
+const struct iommufd_viommu_ops *
+amd_iommufd_get_viommu_ops(struct device *dev,
+		enum iommu_viommu_type viommu_type);
+int amd_iommufd_viommu_init(struct iommufd_viommu *viommu,
+		struct device *dev, struct iommu_domain *parent,
+		const struct iommu_user_data *user_data);
 #else
 #define amd_iommufd_hw_info NULL
 #define amd_iommufd_viommu_init NULL
-#define amd_iommufd_get_viommu_size NULL
+#define amd_iommufd_get_viommu_ops NULL
 #endif /* CONFIG_AMD_IOMMU_IOMMUFD */
 
 #endif /* AMD_IOMMUFD_H */
diff --git a/drivers/iommu/amd/nested.c b/drivers/iommu/amd/nested.c
index f1c7987fc585..a4d856689e57 100644
--- a/drivers/iommu/amd/nested.c
+++ b/drivers/iommu/amd/nested.c
@@ -90,7 +90,7 @@ static void *gdom_info_load_or_alloc_locked(struct xarray *xa,
 
 /*
  * This function is assigned to struct iommufd_viommu_ops.alloc_domain_nested()
- * during the call to struct iommu_ops.viommu_init().
+ * during the call to struct iommufd_viommu_ops.viommu_init().
  */
 struct iommu_domain *
 amd_iommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
@@ -198,7 +198,7 @@ static void set_dte_nested(struct amd_iommu *iommu, struct iommu_domain *dom,
 
 	/*
 	 * The nest parent domain is attached during the call to the
-	 * struct iommu_ops.viommu_init(), which will be stored as part
+	 * struct iommufd_viommu_ops.viommu_init(), which will be stored as part
 	 * of the struct amd_iommu_viommu.parent.
 	 */
 	if (WARN_ON(!ndom->viommu || !ndom->viommu->parent))
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index e68b46485095..ab02e8b72ab6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -533,20 +533,29 @@ int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
 	return ret;
 }
 
+static size_t arm_vsmmu_get_size(struct device *dev,
+				 enum iommu_viommu_type viommu_type)
+{
+	return VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
+}
+
 static const struct iommufd_viommu_ops arm_vsmmu_ops = {
+	.get_viommu_size = arm_vsmmu_get_size,
+	.viommu_init = arm_vsmmu_init,
 	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
 	.cache_invalidate = arm_vsmmu_cache_invalidate,
 	.vdevice_init = arm_vsmmu_vdevice_init,
 };
 
-size_t arm_smmu_get_viommu_size(struct device *dev,
-				enum iommu_viommu_type viommu_type)
+const struct iommufd_viommu_ops *
+arm_smmu_get_viommu_ops(struct device *dev,
+		enum iommu_viommu_type viommu_type)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 
 	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
-		return 0;
+		return NULL;
 
 	/*
 	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the exact HW
@@ -554,7 +563,7 @@ size_t arm_smmu_get_viommu_size(struct device *dev,
 	 * any change to remove this.
 	 */
 	if (WARN_ON(smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
-		return 0;
+		return NULL;
 
 	/*
 	 * Must support some way to prevent the VM from bypassing the cache
@@ -566,19 +575,20 @@ size_t arm_smmu_get_viommu_size(struct device *dev,
 	 */
 	if (!arm_smmu_master_canwbs(master) &&
 	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
-		return 0;
+		return NULL;
 
 	if (viommu_type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
-		return VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
+		return &arm_vsmmu_ops;
 
-	if (!smmu->impl_ops || !smmu->impl_ops->get_viommu_size)
-		return 0;
-	return smmu->impl_ops->get_viommu_size(viommu_type);
+	if (!smmu->impl_ops || !smmu->impl_ops->get_viommu_ops)
+		return NULL;
+
+	return smmu->impl_ops->get_viommu_ops(viommu_type);
 }
 
-int arm_vsmmu_init(struct iommufd_viommu *viommu,
-		   struct iommu_domain *parent_domain,
-		   const struct iommu_user_data *user_data)
+int arm_vsmmu_init(struct iommufd_viommu *viommu, struct device *dev,
+		struct iommu_domain *parent_domain,
+		const struct iommu_user_data *user_data)
 {
 	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
 	struct arm_smmu_device *smmu =
@@ -593,10 +603,8 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 	/* FIXME Move VMID allocation from the S2 domain allocation to here */
 	vsmmu->vmid = s2_parent->s2_cfg.vmid;
 
-	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
-		viommu->ops = &arm_vsmmu_ops;
+	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
 		return 0;
-	}
 
 	return smmu->impl_ops->vsmmu_init(vsmmu, user_data);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 100b34f07032..62dd769f1f6c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4597,8 +4597,7 @@ static const struct iommu_ops arm_smmu_ops = {
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.page_response		= arm_smmu_page_response,
 	.def_domain_type	= arm_smmu_def_domain_type,
-	.get_viommu_size	= arm_smmu_get_viommu_size,
-	.viommu_init		= arm_vsmmu_init,
+	.get_viommu_ops	= arm_smmu_get_viommu_ops,
 	.user_pasid_table	= 1,
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
@@ -5761,8 +5760,8 @@ static struct arm_smmu_device *arm_smmu_impl_probe(struct arm_smmu_device *smmu)
 
 	ops = new_smmu->impl_ops;
 	if (ops) {
-		/* get_viommu_size and vsmmu_init ops must be paired */
-		if (WARN_ON(!ops->get_viommu_size != !ops->vsmmu_init)) {
+		/* get_viommu_ops and vsmmu_init ops must be paired */
+		if (WARN_ON(!ops->get_viommu_ops != !ops->vsmmu_init)) {
 			ret = -EINVAL;
 			goto err_remove;
 		}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bb048e08d613..d93388e8eefb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -931,7 +931,8 @@ struct arm_smmu_impl_ops {
 	 */
 	void *(*hw_info)(struct arm_smmu_device *smmu, u32 *length,
 			 enum iommu_hw_info_type *type);
-	size_t (*get_viommu_size)(enum iommu_viommu_type viommu_type);
+	const struct iommufd_viommu_ops *(*get_viommu_ops)(
+		enum iommu_viommu_type viommu_type);
 	int (*vsmmu_init)(struct arm_vsmmu *vsmmu,
 			  const struct iommu_user_data *user_data);
 };
@@ -1321,11 +1322,12 @@ struct arm_vsmmu {
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length,
 		       enum iommu_hw_info_type *type);
-size_t arm_smmu_get_viommu_size(struct device *dev,
-				enum iommu_viommu_type viommu_type);
-int arm_vsmmu_init(struct iommufd_viommu *viommu,
-		   struct iommu_domain *parent_domain,
-		   const struct iommu_user_data *user_data);
+const struct iommufd_viommu_ops *
+arm_smmu_get_viommu_ops(struct device *dev,
+		enum iommu_viommu_type viommu_type);
+int arm_vsmmu_init(struct iommufd_viommu *viommu, struct device *dev,
+		struct iommu_domain *parent_domain,
+		const struct iommu_user_data *user_data);
 int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
 				    struct arm_smmu_nested_domain *nested_domain);
 void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state);
@@ -1337,7 +1339,7 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
 int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
 			       struct iommu_user_data_array *array);
 #else
-#define arm_smmu_get_viommu_size NULL
+#define arm_smmu_get_viommu_ops NULL
 #define arm_smmu_hw_info NULL
 #define arm_vsmmu_init NULL
 #define arm_vsmmu_alloc_domain_nested NULL
diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 710a4c694b94..83968116615e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -892,11 +892,15 @@ static void *tegra241_cmdqv_hw_info(struct arm_smmu_device *smmu, u32 *length,
 	return info;
 }
 
-static size_t tegra241_cmdqv_get_vintf_size(enum iommu_viommu_type viommu_type)
+static const struct iommufd_viommu_ops tegra241_cmdqv_viommu_ops;
+
+static const struct iommufd_viommu_ops *
+tegra241_cmdqv_get_viommu_ops(enum iommu_viommu_type viommu_type)
 {
 	if (viommu_type != IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV)
-		return 0;
-	return VIOMMU_STRUCT_SIZE(struct tegra241_vintf, vsmmu.core);
+		return NULL;
+
+	return &tegra241_cmdqv_viommu_ops;
 }
 
 static struct arm_smmu_impl_ops tegra241_cmdqv_impl_ops = {
@@ -907,7 +911,7 @@ static struct arm_smmu_impl_ops tegra241_cmdqv_impl_ops = {
 	.device_remove = tegra241_cmdqv_remove,
 	/* For user-space use */
 	.hw_info = tegra241_cmdqv_hw_info,
-	.get_viommu_size = tegra241_cmdqv_get_vintf_size,
+	.get_viommu_ops = tegra241_cmdqv_get_viommu_ops,
 	.vsmmu_init = tegra241_cmdqv_init_vintf_user,
 };
 
@@ -1289,7 +1293,15 @@ static int tegra241_vintf_init_vsid(struct iommufd_vdevice *vdev)
 	return 0;
 }
 
-static struct iommufd_viommu_ops tegra241_cmdqv_viommu_ops = {
+static size_t tegra241_cmdqv_get_vintf_size(struct device *dev,
+					    enum iommu_viommu_type viommu_type)
+{
+	return VIOMMU_STRUCT_SIZE(struct tegra241_vintf, vsmmu.core);
+}
+
+static const struct iommufd_viommu_ops tegra241_cmdqv_viommu_ops = {
+	.get_viommu_size = tegra241_cmdqv_get_vintf_size,
+	.viommu_init = arm_vsmmu_init,
 	.destroy = tegra241_cmdqv_destroy_vintf_user,
 	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
 	/* Non-accelerated commands will be still handled by the kernel */
@@ -1312,7 +1324,7 @@ tegra241_cmdqv_init_vintf_user(struct arm_vsmmu *vsmmu,
 	int ret;
 
 	/*
-	 * Unsupported type should be rejected by tegra241_cmdqv_get_vintf_size.
+	 * Unsupported type should be rejected by tegra241_cmdqv_get_viommu_ops.
 	 * Seeing one here indicates a kernel bug or some data corruption.
 	 */
 	if (WARN_ON(vsmmu->core.type != IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV))
@@ -1364,7 +1376,6 @@ tegra241_cmdqv_init_vintf_user(struct arm_vsmmu *vsmmu,
 	dev_dbg(cmdqv->dev, "VINTF%u: allocated with vmid (%d)\n", vintf->idx,
 		vintf->vsmmu.vmid);
 
-	vsmmu->core.ops = &tegra241_cmdqv_viommu_ops;
 	return 0;
 
 free_mmap:
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index b17cca7096b6..c6a1126cf8ae 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -767,7 +767,19 @@ static int mock_hw_queue_init_phys(struct iommufd_hw_queue *hw_queue, u32 index,
 	return rc;
 }
 
-static struct iommufd_viommu_ops mock_viommu_ops = {
+static int mock_viommu_init(struct iommufd_viommu *viommu, struct device *dev,
+		struct iommu_domain *parent_domain,
+		const struct iommu_user_data *user_data);
+
+static size_t mock_get_viommu_size(struct device *dev,
+				   enum iommu_viommu_type viommu_type)
+{
+	return VIOMMU_STRUCT_SIZE(struct mock_viommu, core);
+}
+
+static const struct iommufd_viommu_ops mock_viommu_ops = {
+	.get_viommu_size = mock_get_viommu_size,
+	.viommu_init = mock_viommu_init,
 	.destroy = mock_viommu_destroy,
 	.alloc_domain_nested = mock_viommu_alloc_domain_nested,
 	.cache_invalidate = mock_viommu_cache_invalidate,
@@ -775,17 +787,19 @@ static struct iommufd_viommu_ops mock_viommu_ops = {
 	.hw_queue_init_phys = mock_hw_queue_init_phys,
 };
 
-static size_t mock_get_viommu_size(struct device *dev,
-				   enum iommu_viommu_type viommu_type)
+static const struct iommufd_viommu_ops *
+mock_get_viommu_ops(struct device *dev,
+		enum iommu_viommu_type viommu_type)
 {
 	if (viommu_type != IOMMU_VIOMMU_TYPE_SELFTEST)
-		return 0;
-	return VIOMMU_STRUCT_SIZE(struct mock_viommu, core);
+		return NULL;
+
+	return &mock_viommu_ops;
 }
 
 static int mock_viommu_init(struct iommufd_viommu *viommu,
-			    struct iommu_domain *parent_domain,
-			    const struct iommu_user_data *user_data)
+		struct device *dev, struct iommu_domain *parent_domain,
+		const struct iommu_user_data *user_data)
 {
 	struct mock_iommu_device *mock_iommu = container_of(
 		viommu->iommu_dev, struct mock_iommu_device, iommu_dev);
@@ -827,7 +841,6 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
 	mutex_init(&mock_viommu->queue_mutex);
 	mock_viommu->s2_parent = to_mock_domain(parent_domain);
 
-	viommu->ops = &mock_viommu_ops;
 	return 0;
 
 err_destroy_mmap:
@@ -854,8 +867,7 @@ static const struct iommu_ops mock_ops = {
 	.probe_device = mock_probe_device,
 	.page_response = mock_domain_page_response,
 	.user_pasid_table = true,
-	.get_viommu_size = mock_get_viommu_size,
-	.viommu_init = mock_viommu_init,
+	.get_viommu_ops = mock_get_viommu_ops,
 };
 
 static void mock_domain_free_nested(struct iommu_domain *domain)
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index a3a22b0e7c37..472381b96a8e 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -33,7 +33,7 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	struct iommufd_viommu *viommu;
 	struct iommufd_device *idev;
 	struct iommu_device *iommu_dev;
-	const struct iommu_ops *ops;
+	const struct iommufd_viommu_ops *ops;
 	size_t viommu_size;
 	int rc;
 
@@ -49,23 +49,26 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		rc = -EOPNOTSUPP;
 		goto out_put_idev;
 	}
-	ops = iommu_dev->ops;
-	if (!ops->get_viommu_size || !ops->viommu_init) {
+	if (!iommu_dev->ops->get_viommu_ops) {
 		rc = -EOPNOTSUPP;
 		goto out_put_idev;
 	}
-
-	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
-	if (!viommu_size) {
+	ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
+	if (!ops) {
 		rc = -EOPNOTSUPP;
 		goto out_put_idev;
 	}
-
 	/*
-	 * It is a driver bug for providing a viommu_size smaller than the core
-	 * vIOMMU structure size
+	 * It is a driver bug to omit the required operations or provide a size
+	 * smaller than the core vIOMMU structure.
 	 */
-	if (WARN_ON_ONCE(viommu_size < sizeof(*viommu))) {
+	if (WARN_ON_ONCE(!ops->get_viommu_size || !ops->viommu_init)) {
+		rc = -EOPNOTSUPP;
+		goto out_put_idev;
+	}
+
+	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
+	if (!viommu_size || WARN_ON_ONCE(viommu_size < sizeof(*viommu))) {
 		rc = -EOPNOTSUPP;
 		goto out_put_idev;
 	}
@@ -104,16 +107,13 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	 */
 	viommu->iommu_dev = iommu_dev;
 
-	rc = ops->viommu_init(viommu, hwpt_paging->common.domain,
+	rc = ops->viommu_init(viommu, idev->dev,
+			      hwpt_paging->common.domain,
 			      user_data.len ? &user_data : NULL);
 	if (rc)
 		goto out_put_hwpt;
 
-	/* It is a driver bug that viommu->ops isn't filled */
-	if (WARN_ON_ONCE(!viommu->ops)) {
-		rc = -EOPNOTSUPP;
-		goto out_put_hwpt;
-	}
+	viommu->ops = ops;
 
 	cmd->out_viommu_id = viommu->obj.id;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ef5043752a36..f27064917df7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -46,6 +46,7 @@ struct iommu_dma_msi_cookie;
 struct iommu_fault_param;
 struct iommufd_ctx;
 struct iommufd_viommu;
+struct iommufd_viommu_ops;
 struct msi_desc;
 struct msi_msg;
 
@@ -669,16 +670,8 @@ __iommu_copy_struct_to_user(const struct iommu_user_data *dst_data,
  *		- IOMMU_DOMAIN_DMA: must use a dma domain
  *		- 0: use the default setting
  * @default_domain_ops: the default ops for domains
- * @get_viommu_size: Get the size of a driver-level vIOMMU structure for a given
- *                   @dev corresponding to @viommu_type. Driver should return 0
- *                   if vIOMMU isn't supported accordingly. It is required for
- *                   driver to use the VIOMMU_STRUCT_SIZE macro to sanitize the
- *                   driver-level vIOMMU structure related to the core one
- * @viommu_init: Init the driver-level struct of an iommufd_viommu on a physical
- *               IOMMU instance @viommu->iommu_dev, as the set of virtualization
- *               resources shared/passed to user space IOMMU instance. Associate
- *               it with a nesting @parent_domain. It is required for driver to
- *               set @viommu->ops pointing to its own viommu_ops
+ * @get_viommu_ops: Return the vIOMMU operations supported by @dev for a type.
+ *                  Return NULL if the type is unsupported.
  * @owner: Driver module providing these ops
  * @identity_domain: An always available, always attachable identity
  *                   translation.
@@ -729,11 +722,8 @@ struct iommu_ops {
 
 	int (*def_domain_type)(struct device *dev);
 
-	size_t (*get_viommu_size)(struct device *dev,
-				  enum iommu_viommu_type viommu_type);
-	int (*viommu_init)(struct iommufd_viommu *viommu,
-			   struct iommu_domain *parent_domain,
-			   const struct iommu_user_data *user_data);
+	const struct iommufd_viommu_ops *(*get_viommu_ops)(
+		struct device *dev, enum iommu_viommu_type viommu_type);
 
 	const struct iommu_domain_ops *default_domain_ops;
 	struct module *owner;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index d1fd7888fc91..5f5c67b24134 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -148,6 +148,15 @@ struct iommufd_hw_queue {
 
 /**
  * struct iommufd_viommu_ops - vIOMMU specific operations
+ * @get_viommu_size: Get the size of a driver-level vIOMMU structure for a given
+ *                   @dev corresponding to @viommu_type. Driver should return 0
+ *                   if vIOMMU isn't supported accordingly. It is required for
+ *                   driver to use the VIOMMU_STRUCT_SIZE macro to sanitize the
+ *                   driver-level vIOMMU structure related to the core one
+ * @viommu_init: Init the driver-level struct of an iommufd_viommu on a physical
+ *               IOMMU instance @viommu->iommu_dev, as the set of virtualization
+ *               resources shared/passed to user space IOMMU instance. Associate
+ *               it with a nesting @parent_domain.
  * @destroy: Clean up all driver-specific parts of an iommufd_viommu. The memory
  *           of the vIOMMU will be free-ed by iommufd core after calling this op
  * @alloc_domain_nested: Allocate a IOMMU_DOMAIN_NESTED on a vIOMMU that holds a
@@ -190,6 +199,11 @@ struct iommufd_hw_queue {
  *                      does, it should set it to the @hw_queue->destroy pointer
  */
 struct iommufd_viommu_ops {
+	size_t (*get_viommu_size)(struct device *dev,
+		enum iommu_viommu_type type);
+	int (*viommu_init)(struct iommufd_viommu *viommu, struct device *dev,
+		struct iommu_domain *parent_domain,
+		const struct iommu_user_data *user_data);
 	void (*destroy)(struct iommufd_viommu *viommu);
 	struct iommu_domain *(*alloc_domain_nested)(
 		struct iommufd_viommu *viommu, u32 flags,
-- 
2.43.0

