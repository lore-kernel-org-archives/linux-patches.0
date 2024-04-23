Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4041350FE;
	Tue, 23 Apr 2024 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878078; cv=fail; b=NXt1veuLVnNHDjI+q/X1wrMDXuXOTFRGYM/AG7TXfyctQQJrt5+WWx8CRb3Hdn+ttFCbyHE5h/Gilp0FhyQzragMr7W2U42HMJIp1anvCmtK6WFBIHP2YafjOx3ESOjrEi4OMpsNneO3Ew8as1HYAWkdqeTY9/uN+ASy62ABIQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878078; c=relaxed/simple;
	bh=MLSF8dZsG0k56EDSAlquFRH5xQJvWrzKrySDmFy+JG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ye+J3AHB9aXE3lmZTnB/EeUO+VJfNZOzUxAow0scQjr/kfKGqoYKf18pQyY7coECxWqeSqjJY19CcfNqy2HCKFBgMD82s6q0a3wbjmBmfzrITY6ZVyzJ4eSN8KVnxDE2IjqYE718pNA976Jjex3D6v9TIufPkMkMteYpAglR/NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GFqbgFaa; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GFqbgFaa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrbjDmBia3nNFXw8yymbZuAr/d/lwD6agBe+5PWH3WcPt+KrPRqnt/vda84DEU9m6JnE/aMmVS6HoG1AbWmlogM+14TMOCSvk5srVrwaa+DYyEUn/fB0jLujmlGSU72Ofi1nRY7i4iPBWBUjSGbSie+c6f47+kbRfwOrqcgb4tkvo8jJuoLPT2+x17ZpHqzDx8SbNx48DLZt3whgTMMynqcafZoHRi9audAFALSKOzhowLwoNf17fgd6uVGllrW669FArquTkUMKcodDFMeSiaZebxAVtLtzlQM0LiVbn9bYWIT0hiW19lQs08wcjYmJLkLMSZr6W0XGhi/QIxqS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbvGEvS5saPMgjaSj0nAhSHHwE/FjiJmAdshUAmS+I0=;
 b=FFoWz1WbAJkcHh6GAaNcWtJn+DmIpHJCMCZyfeAcZgLm2dmv12B7f2uk0pDJ5kAPhJ8AIJsezgX2Ol9XgzS9Fs/PCXB3Dn0XcFk0BO7Set2QTPxk+6u9e+830dFTO18zo8WKSTT9CQFmDXhYHvLy03jnE4C4QEXH+Lw8+TJ0UwGEqOxGy6UeZvWiNP6fxQrJ5q/JXjNw6GXFfS8XymjwLo9mhuQqtCAxPFUUqzJf5RFd56LWMXNolt8thLulZ8cV3hQsLHzZTMXrP5MG8fWF3+RVe3ziwcBukkCXt9RiFeJyA6w+rDey3o1UkFCLDbHBUtqDi0qc3w0dJPbNRyxzJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbvGEvS5saPMgjaSj0nAhSHHwE/FjiJmAdshUAmS+I0=;
 b=GFqbgFaaHByvM86lOWy6+Z1ZyEkCYKf00SVE4uFggotMKcRUWZUB6CC9VmqyKNFOekxMdTyddd84WmyuXqKP6QRwPiqNkdDpvGweozZehuWquZVpUnXIEkVgy87WvnpPpa5cBRkznRLcLOqdaOcuO5ec4JPhoCXIq17eUDpKWVvRAwR2oO67BkbBDPbBN8z8jYqjaUI+gbxBdgLck96jSCm0EkV7FadPcwCJnhUUQIkA4WGb/N5elImmNLvcUolFBabDh36txChXXq7LjGXQynSQD9McFEX2Lhue3Iqp/Mni4CANYI/Qx8g6Wb5MXO6eHeUHVbvOJNsSaXtViYsfTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6593.namprd12.prod.outlook.com (2603:10b6:208:38c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
Date: Tue, 23 Apr 2024 10:14:12 -0300
Message-ID: <7-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0374.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 532be7c5-5633-41a4-a00b-08dc63974682
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3HQftNR9ituwVlSLca4s7jnVS6r9aiki5ylb3fmpN8+slh2+GfBjShbwW57n?=
 =?us-ascii?Q?7Os1FhvbdzFlDai//MbGK4K/mMlorMU2Ss1/2tOVIwy2ntp5mqektFBArzSL?=
 =?us-ascii?Q?RrG/fOK04qIdOBmmr4LPevUf6HlMtuR8KvIN+eqBMBL2FyfH3lZiKB4uR2IR?=
 =?us-ascii?Q?ZvsMya/hWhrzFp4yljN4DaC+hPixNGED2dfA/0WhHJwMXJWqiWh1+Koy3I+q?=
 =?us-ascii?Q?3CT02RTE3Y5KCs1R9Jhn0LIhdki3sNzRdSsVk+XOymHqmb3QrwyqkFKfj9vN?=
 =?us-ascii?Q?gU0OO5AY68k/r5hXNmR0XnNrD7t0Xqhk8cEsSSScUDjRUHif2H5By+plpcnc?=
 =?us-ascii?Q?MCgT1i3iuaSTHXRmuLB9+6vLgq46x0gTWjktS72YIpFLOI6OfRLPFlZtKXOY?=
 =?us-ascii?Q?XdqVhsLke5iiLWURMXxNtq+Jk2kF7uF1SL+guk+69RAme2p9CuEoHaGVLcKC?=
 =?us-ascii?Q?NwA8f+njWAgNsOZYYk3eU++yE+uCqm8tviSyNcVhUd6pN1jNJwTx17qwHqWt?=
 =?us-ascii?Q?pfzVi7PThZRbpjXunfWuT+O5ugPVZRepmKHipsrb/ecYTgw2HvhxqnUP4ga1?=
 =?us-ascii?Q?sLNtX/wM9WzMki2oSPoi0VwxYJuQfiqruHu8iDKuzazOzU0vInZzeOnvMZcZ?=
 =?us-ascii?Q?5nfGx2KNOC3v0Wsgu0IbfJjuP5ThWN1PeNkW0i4aX1pEgzNqabyHo4Y34UUQ?=
 =?us-ascii?Q?h2yAbTZpMpL0F2sGnfp104ZHjL6SBDg3DXe7RySbj72RHUI72h9p6Z1xjyMb?=
 =?us-ascii?Q?+p5KvP2Kv+fKooDHwFsAvhUWncpp2L8PY6ImT/uvr48MkgrD4iwDjVWeZrDW?=
 =?us-ascii?Q?PfJffI0haMmLjkU1hQ03/OPDT5y5wHVNaoBs8z72mXCGvVk3V4rdCG28YSnN?=
 =?us-ascii?Q?UwfE0Fr2tLr41pgX9gcFRKgnZkfBXLZrrnjnqBpI0vbu3irY7RcV9Po3G24U?=
 =?us-ascii?Q?JAh/FDETJbXmR6SgrI3N9k+PWlMYEvD9UbkAVBnQZuYsq19IU5ss1vXaToGi?=
 =?us-ascii?Q?wxiEO2RVcxVRBHeunHbmMV7eovOvF/x5gDNCKCtvTrHnXnwsZBJfsA3lQgrq?=
 =?us-ascii?Q?+6425h12Y6W0FLI/fI18h0iaesC3WsPOfctn9YGU0sxiYWYZX0+BuC8Oj3sk?=
 =?us-ascii?Q?5s8aX/VYHSChB79j5Q+sP+O/WOe5Vs4wt1yt0pNYPusNzWXal2iJ7OSlZd9j?=
 =?us-ascii?Q?JbavN2uiQIw7YRxRXZDNuDOyPsc3pwKthcHFFzhmflHqCD7vLzq/frF74iCn?=
 =?us-ascii?Q?qB1/1QTKyGAX8RYHzE8Q/oOZNPxuyAe2YiW1wKntLw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LS5Ac9vBhNzCNyn6TLwu/FVBP1GqyNcK8JCmfVpyCcUqJRFzRFJq6QEXwXt3?=
 =?us-ascii?Q?2ovQsqBmnAFreckX2HgRtdSlpx5V7KgmY4aeYzRmxYcTh4B5wl8+chIKrrNk?=
 =?us-ascii?Q?4opvfWN4wCJGzwVTk7R2/aPEqxR6dsdXd8E0kmWBX3GNr/wX5YKUeR9i7y3F?=
 =?us-ascii?Q?rtD4zgiqld0I1+iSEhgS2BpONY+4GSD4jkzZpij1I4k/02kmeHJxYTf6WhMJ?=
 =?us-ascii?Q?PDgDML2DUcIYNa2rW8vkm5EDNu9BNdkWpaiV4RXm/zNlgOvyW1I6+2mr5vBf?=
 =?us-ascii?Q?G03n9CyrjnhUMb4nzaUvHjby0/Ws4EQbf12cICsZskEqD76cBjYcMVs5E6h2?=
 =?us-ascii?Q?VuFUPYv7js5q8EQy/QdqcdiVhyTE90Nr7O/NxMT4tCVLVG77z9CZJUjSBwUL?=
 =?us-ascii?Q?eUQ9gVcnuOqctpqLWnEu4DVHSrs1dGtPwt16XTVSSwWFE4lS3jdhjWT/trgB?=
 =?us-ascii?Q?SRPNPTqgXst/tQzkOEQY0tswDGzXz0BXS2j2sqa+xnzz23pmbywkcjhe+NHS?=
 =?us-ascii?Q?hmFYDW1GLfVaz8q4dqWbhG/IEJew4v6j7ORHGISZ0pGWgNxBuLcTuywmcf+3?=
 =?us-ascii?Q?1HWUK05G3dBPoUoO7NujFNb8v8ncFukjmwSDZ+LCMwYuZyW8eV3BvMBLRP1W?=
 =?us-ascii?Q?Idu2IxicS8CcPNhoKyNa8LMmni7Aq6fmVemLXB+wriBv4L6lVmu+fbVACdLh?=
 =?us-ascii?Q?3sdCNO1UGS2vdAte4+g7YoBTuNgJQyUpQxtGr5bW7S9Z3cVkUCn3F8V+VePv?=
 =?us-ascii?Q?rTaeyfU3oEPaKkHrlH2YYOeojWYJp8rk+EU9rBJwzgzIMwGzEJf6lZtWCwWW?=
 =?us-ascii?Q?wNW5ieog6d4ifKRN1xhdOVuIM82zwaw+umah6jnjINFIKzIn5xFmslyaluPL?=
 =?us-ascii?Q?VBOLvEd8F8bR/zOrvSKGnV3BNnaDGtWVpLz92AhfRUDTZyx98BSFHdpWj25b?=
 =?us-ascii?Q?icejFrnjB7pCbgR7E4FcnXd2SIuYVOfDsSenyFwY4EaiAaS2j5py19WZ/o0S?=
 =?us-ascii?Q?FoSYtwIfYnm6QC2RGo+Um5cFkE3Y7AYxI4lzYMbA7WY/yJB0ub4Xve7YF6Sh?=
 =?us-ascii?Q?hwKcQ9bag4tMVIw1O8QFqBve5gzCPJz9w/tzntKQNQiP+KJLhZMHgSlv3/aL?=
 =?us-ascii?Q?NQ2+NTOpgFd5XdZT5iopN/UD5tzt3oyoRf3i7+LeFzaJjkaAr6WKALvZn/5t?=
 =?us-ascii?Q?pAyR8nvDvQ3GMjeHlKbVdjah+09tfBnorbsy2qkDssB4H1TYZ9/Du7fLUSIw?=
 =?us-ascii?Q?VzqvZQQY0uH0Ql0tJvBPI91sri5zme9Pbryrbyew7VfPFdC5/uSn8+NpnnWJ?=
 =?us-ascii?Q?NEGJ25tHnpNiCshv0+3wnBhDdDXI4/Vwqtio6g/qL2B57WrL4WXjXVM4XXov?=
 =?us-ascii?Q?Z1E3ITyIiAPCTcz7cQSs7+3TdgcnMNiHZOA6I0/j3y8l/OXCM7vZv84wLEyF?=
 =?us-ascii?Q?62qRed7kfPyL2GRRJo6mbvY35y0DEd63iv+QAkniN2aq3Y+ZttIrBMxMb6l/?=
 =?us-ascii?Q?Pi1pN88lZsYSZtX0qGhzkZeR3HwlOPoImwhqBL8vMXJQ2ZPjHNrUQoEkri5w?=
 =?us-ascii?Q?6lH+5XclPc5CcSoOukXy9P49AdyAnSjV6YxK1a6L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532be7c5-5633-41a4-a00b-08dc63974682
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.5495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRZ/RHN4hFZECWTBs9JjNEUSH58Gt/xzIBp4NnupQvaHEG+pwwdwU556MQaKt0SJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

Pull all the calculations for building the CD table entry for a mmu_struct
into arm_smmu_make_sva_cd().

Call it in the two places installing the SVA CD table entry.

Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
the function.

Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
locking assertions to arm_smmu_alloc_cd_ptr() since
arm_smmu_update_ctx_desc_devices() was the last problematic caller.

Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
the same value.

The behavior of quiet_cd changes slightly, the old implementation edited
the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
entry. This version generates a full CD entry with a 0 TTB0 and relies on
arm_smmu_write_cd_entry() to install it hitlessly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 155 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  89 +---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   7 +-
 3 files changed, 107 insertions(+), 144 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7cf286f7a009fb..8730a7043909e3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -34,25 +34,6 @@ struct arm_smmu_bond {
 
 static DEFINE_MUTEX(sva_lock);
 
-/*
- * Write the CD to the CD tables for all masters that this domain is attached
- * to. Note that this is only used to update existing CD entries in the target
- * CD table, for which it's assumed that arm_smmu_write_ctx_desc can't fail.
- */
-static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain,
-					   int ssid,
-					   struct arm_smmu_ctx_desc *cd)
-{
-	struct arm_smmu_master *master;
-	unsigned long flags;
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		arm_smmu_write_ctx_desc(master, ssid, cd);
-	}
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-}
-
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
@@ -128,11 +109,85 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	return NULL;
 }
 
+static u64 page_size_to_cd(void)
+{
+	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
+		      PAGE_SIZE == SZ_64K);
+	if (PAGE_SIZE == SZ_64K)
+		return ARM_LPAE_TCR_TG0_64K;
+	if (PAGE_SIZE == SZ_16K)
+		return ARM_LPAE_TCR_TG0_16K;
+	return ARM_LPAE_TCR_TG0_4K;
+}
+
+static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
+				 struct arm_smmu_master *master,
+				 struct mm_struct *mm, u16 asid)
+{
+	u64 par;
+
+	memset(target, 0, sizeof(*target));
+
+	par = cpuid_feature_extract_unsigned_field(
+		read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
+		ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	target->data[0] = cpu_to_le64(
+		CTXDESC_CD_0_TCR_EPD1 |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
+
+	/*
+	 * If no MM is passed then this creates a SVA entry that faults
+	 * everything. arm_smmu_write_cd_entry() can hitlessly go between these
+	 * two entries types since TTB0 is ignored by HW when EPD0 is set.
+	 */
+	if (mm) {
+		target->data[0] |= cpu_to_le64(
+			FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ,
+				   64ULL - vabits_actual) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
+
+		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
+					      CTXDESC_CD_1_TTB0_MASK);
+	} else {
+		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_EPD0);
+
+		/*
+		 * Disable stall and immediately generate an abort if stall
+		 * disable is permitted. This speeds up cleanup for an unclean
+		 * exit if the device is still doing a lot of DMA.
+		 */
+		if (!(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
+			target->data[0] &=
+				cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD_0_R));
+	}
+
+	/*
+	 * MAIR value is pretty much constant and global, so we can just get it
+	 * from the current CPU register
+	 */
+	target->data[3] = cpu_to_le64(read_sysreg(mair_el1));
+}
+
 static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 {
 	u16 asid;
 	int err = 0;
-	u64 tcr, par, reg;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_ctx_desc *ret = NULL;
 
@@ -166,39 +221,6 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 	if (err)
 		goto out_free_asid;
 
-	tcr = FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, 64ULL - vabits_actual) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS) |
-	      CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-
-	switch (PAGE_SIZE) {
-	case SZ_4K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_4K);
-		break;
-	case SZ_16K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_16K);
-		break;
-	case SZ_64K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_64K);
-		break;
-	default:
-		WARN_ON(1);
-		err = -EINVAL;
-		goto out_free_asid;
-	}
-
-	reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	par = cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
-	tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par);
-
-	cd->ttbr = virt_to_phys(mm->pgd);
-	cd->tcr = tcr;
-	/*
-	 * MAIR value is pretty much constant and global, so we can just get it
-	 * from the current CPU register
-	 */
-	cd->mair = read_sysreg(mair_el1);
 	cd->asid = asid;
 	cd->mm = mm;
 
@@ -276,6 +298,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	mutex_lock(&sva_lock);
 	if (smmu_mn->cleared) {
@@ -287,8 +311,19 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * DMA may still be running. Keep the cd valid to avoid C_BAD_CD events,
 	 * but disable translation.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid(mm),
-					 &quiet_cd);
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd target;
+		struct arm_smmu_cd *cdptr;
+
+		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+		if (WARN_ON(!cdptr))
+			continue;
+		arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->asid);
+		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
+					&target);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
 	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
@@ -383,6 +418,8 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 			       struct mm_struct *mm)
 {
 	int ret;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -409,9 +446,13 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 		goto err_free_bond;
 	}
 
-	ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
-	if (ret)
+	cdptr = arm_smmu_alloc_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+	if (!cdptr) {
+		ret = -ENOMEM;
 		goto err_put_notifier;
+	}
+	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
+	arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
 
 	list_add(&bond->list, &master->bonds);
 	return 0;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3039b01e3fbe6b..f021268dab4763 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -83,12 +83,6 @@ struct arm_smmu_option_prop {
 DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
 DEFINE_MUTEX(arm_smmu_asid_lock);
 
-/*
- * Special value used by SVA when a process dies, to quiesce a CD without
- * disabling it.
- */
-struct arm_smmu_ctx_desc quiet_cd = { 0 };
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -1200,7 +1194,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
 		  CTXDESC_L1_DESC_V;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
@@ -1223,12 +1217,15 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
 }
 
-static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
-						 u32 ssid)
+struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+					  u32 ssid)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	might_sleep();
+	iommu_group_mutex_assert(master->dev);
+
 	if (!cd_table->cdtab) {
 		if (arm_smmu_alloc_cd_tables(master))
 			return NULL;
@@ -1346,77 +1343,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
 }
 
-static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
-{
-	struct arm_smmu_cd used = {};
-	int i;
-
-	arm_smmu_get_cd_used(target->data, used.data);
-	for (i = 0; i != ARRAY_SIZE(target->data); i++)
-		target->data[i] &= used.data[i];
-}
-
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
-			    struct arm_smmu_ctx_desc *cd)
-{
-	/*
-	 * This function handles the following cases:
-	 *
-	 * (1) Install primary CD, for normal DMA traffic (SSID = IOMMU_NO_PASID = 0).
-	 * (2) Install a secondary CD, for SID+SSID traffic.
-	 * (4) Quiesce the context without clearing the valid bit. Disable
-	 *     translation, and ignore any translation fault.
-	 */
-	u64 val;
-	struct arm_smmu_cd target;
-	struct arm_smmu_cd *cdptr = &target;
-	struct arm_smmu_cd *cd_table_entry;
-	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
-	struct arm_smmu_device *smmu = master->smmu;
-
-	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
-		return -E2BIG;
-
-	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
-	if (!cd_table_entry)
-		return -ENOMEM;
-
-	target = *cd_table_entry;
-	val = le64_to_cpu(cdptr->data[0]);
-
-	if (cd == &quiet_cd) { /* (4) */
-		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
-			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
-		val |= CTXDESC_CD_0_TCR_EPD0;
-	} else { /* (1) and (2) */
-		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-		cdptr->data[2] = 0;
-		cdptr->data[3] = cpu_to_le64(cd->mair);
-
-		val = cd->tcr |
-#ifdef __BIG_ENDIAN
-			CTXDESC_CD_0_ENDI |
-#endif
-			CTXDESC_CD_0_R | CTXDESC_CD_0_A |
-			(cd->mm ? 0 : CTXDESC_CD_0_ASET) |
-			CTXDESC_CD_0_AA64 |
-			FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid) |
-			CTXDESC_CD_0_V;
-
-		if (cd_table->stall_enabled)
-			val |= CTXDESC_CD_0_S;
-	}
-	cdptr->data[0] = cpu_to_le64(val);
-	/*
-	 * Since the above is updating the CD entry based on the current value
-	 * without zeroing unused bits it needs fixing before being passed to
-	 * the programming logic.
-	 */
-	arm_smmu_clean_cd_entry(&target);
-	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
-	return 0;
-}
-
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
 	int ret;
@@ -1425,7 +1351,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	cd_table->stall_enabled = master->stall_enabled;
 	cd_table->s1cdmax = master->ssid_bits;
 	max_contexts = 1 << cd_table->s1cdmax;
 
@@ -1523,7 +1448,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
 	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c5c55d3e281865..5540609069fcd0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -608,8 +608,6 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
-	/* Whether CD entries in this table have the stall bit set. */
-	u8				stall_enabled:1;
 };
 
 struct arm_smmu_s2_cfg {
@@ -748,11 +746,12 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
-extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
+struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+					  u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
 			 struct arm_smmu_domain *smmu_domain);
@@ -760,8 +759,6 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
-			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.2

