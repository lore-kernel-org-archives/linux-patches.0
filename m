Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F9331A61;
	Tue, 14 Jul 2026 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054790; cv=fail; b=Bf3DXijRhzSGbRaXAO7a+ahxxcpAv+SmT/jgvjye1gf5mx9GWN9Q0PqdI4E55CoJtO9RoE2gfmrgKeSI1j0fNIDfn6F8zT6d1kjWX3YfJWGlPPqs52jwLyTbfb2q83ggxfkLXixID8olWxNNnRNqB6cENclirXkHXh1aSpTm2RM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054790; c=relaxed/simple;
	bh=UZF4yfMBxmNl9+9u2SuI4Q+2Q4SkvVw13xWFTyIiI4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pyPy1CPOBMrCpMfK+O78KxX0Kn55uiwUAdU30ro6NS6wDo8Z1sGexb1Qd0BkW6mTAbTJ43YQbxQiHY/20TC/8jovn0dRbqOyp+67EjqZr4KTAn6TiKVETa2M0bSfrUsJwfr4q0BLV462SaYQBts+mUoL3XoKWat/HarcLFOrABI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AuOIT5/e; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AuOIT5/e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brRUxEWAkV01YN7rZp/snlfXksOcGMrY/WCoMtuzj7c9xFgWnn1s5O3nZuEsCGiUfqz8xnPHjc6o8yXwIfvKJGVl8Ebmp36nQg0FuwyXCQhDwp5vNFAp1zONxclbc9TphdZwZXPDIqiZdNs5wbLu836G+16cEg1HLo/Djyg+U9XyL7+XcYmgtXl3/1YGXdSpj/VKKG0fem/Vj7TNaxt1xVbvvbdAai9FS4M0URGg+8TbOemKZQhrL4AtalAgw8vjTUm6Nb4pAYR2lkFLckCYx4mZ6RU7BGvYA3j2gvFKdzX+kWRxf3aEyIKRcTeQDDUZlp5w6FQKdOldq0bR4fwjYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uw0xHFAYFMadYNJJsdMjrBuN2vIGsZwgTY/Yf9dwaiU=;
 b=mQZa4RJ+9/SgDWKrpxnleXAJNEJpemYgnc4PPT2tU+iy1W+m6bUF6AGBJc6VG5KPfDa2cY/TPDAWFVM6BnKtLv9C+dOMbrsG3vJwzgCJ4CCXE6FHS4wIsQwzy1Y+K3FY9h48b0+y/N9MNHurpqeFeMoJ5Z1tbFolO1XSS8zBexpmekmGOQVUk4ZmtL8ArncycAo9bXfVLYCNQLZcIMGyBX/R9Y5IyZCBIRW2Ihcvct0X03BTwnApnF3APstEvRYZJ1NUhY7OIG67JbtiflyhhWer5JKtVzf+buZ7BM7aSaZ9ccYnDcEotJT+mino+nTpWFFHPKgmA36IE4vGrRAVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uw0xHFAYFMadYNJJsdMjrBuN2vIGsZwgTY/Yf9dwaiU=;
 b=AuOIT5/eoVbt0Av6MOgLzE6unInmX1fdZEMei1VGaFtmjl00P/wYnJorwx8FpOhdH51WF8A/kdeYtha9PFnCdKuBFqD5wdxMy4dKt8fNFAxogbRP3Et0d1b1f4WQnqdRWhs6nNY/oFCwDKufj5BTEKdyuvUNfKz98TCxC8P9+Rk3kuSeaXa7rKljCKHpkqvUO/QwYTObCjheC8lVxfEoUzPa7tiShmGFrMOgeQgo8mlbwhkb7ss3NvIzFgw1GpZp7z00ahqJWdbDW6+sHozn3knTZ5d97n2v++HQcTBVu0wYVjX1lkuNHl6e8hptWHBVhukr+bSjspRXSkMGiJmDvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 18:46:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:46:17 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Tue, 14 Jul 2026 15:46:02 -0300
Message-ID: <2-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:408:e6::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 36515700-895c-41db-8b5a-08dee1d82c51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	sm3pbeNj0lyyVQiO5IJlWoUZPuVUMsK5GZVkn2E71vhTVwg3u8gRIDLQMPdsd7L2T7IfZAKviMPfphWRiAMpyp3zO+MT6Gg9zUYK5XVxtvIa0gczdO7z03FuVBxWJOnZEb41DZbAxsZhupXzwiPyL6FRfvS8BMskBMJPJiuK6JO5g2t9Q6rHAfdJk6w1FY9BSx/JdOi7Tlbf5EwcWBEFL5hXshc4SftG82l6BSkJ9RZN+YyJuRkIkI4qYKo1LUNCxR+1xfZev4cPnEadZiWDJNotUO7KEvcsBjm6HKvETdxvI4yAcoactq2ufRR+BzrIK9vGZivtUlCdmsl0udyhUivNaMTeKzlCdFTxWx2gmdGGEkshEjNNUdp63kd3dJGLgkg8aTJrSHx6EVp1YzsmQKFRRmUzUs1wOGkq4UAQ9qP0y8FHmfBqNOA/Se+ee2WmwNnfYbRM9w1Fyy3CsbA/w67GJT0me8W+CzJEhiGEIy8fdt41LmghuwhPtsqNn1mGU3Lf0Xzu4HuhtfTPMAn0dGxzRlpcHbL8VjessaGV3+7t53+Syjrf5x1taiBmkrPWmidZyey11Kh8e6oayI4yspU2UwdjfDyBqo/57BUAriZUA9vJK/1juxZJNfNJaYV5nZqQZAnYfZE+ebDtgg30GZ5ahJ7ydH60SAkfcw2oHjo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RkBPjViZaqYKNHr/EMAQTBSfDkpKwJDRgc2Ytp4CTRt8bUD97iG0Oj0d76MQ?=
 =?us-ascii?Q?Ik3nUDMmjtkDkD7oOiD9+M3gDH3B/HSDz3G1F5U44rLVMmA/BFdvJUL97q/V?=
 =?us-ascii?Q?yDFn4Twz7kFs2+5Vz8ACLlTAcG9xeZNq8HYiABFD+aqoIk2s/tFlzTZYGhew?=
 =?us-ascii?Q?mY8amrT5QAGq0yMErzXssZPjMC5xH5ABHDOxP3jyz4WPakCw+0aPA2aNmouf?=
 =?us-ascii?Q?Uuvm7Fc3Bfe0kepkt5kjOhADcvzonRqhmaxl9SdQabCKkEp6pg2uzl0pYVLD?=
 =?us-ascii?Q?E6a7wCNj+0VG5oxeamPycC09pdHFya7kgd6XCeWbmFVnd4a4GoC72e95cHi4?=
 =?us-ascii?Q?xzXJ/wFa/Bub3JAbBAQkIOXlqyUTbUYTHa/h76BzmZsSoR0TVIDiACyfsjlp?=
 =?us-ascii?Q?nx330VriC412Zh0PZp08NM3T0vqXh6ChkFbi7Bevjlej1/2KBnFAPAnRr8SL?=
 =?us-ascii?Q?LBzJIJCiJYd+6LJt82/7qxDEJOdSJ9YVr19py2ZXZBVRUTO97U5WvJy/CGWR?=
 =?us-ascii?Q?+rh4Klw5vZ80lLl0MfDjQrymVmAPwmtWCXYLRVCHJ9g5M5nV1jADhTcbsyoz?=
 =?us-ascii?Q?mYQV52VHL2zFLMR8dtKvDesp7gsghPTnN+Ae5e08VXIx/O9MS9LmzfDvkLSZ?=
 =?us-ascii?Q?izAI1SisFPG5UaZ1PchyOrhGqOYOaWicjdQC5NZ7jHnd6VxOSbrMFB1Qey+M?=
 =?us-ascii?Q?m4ZM5jLHXhYrkZb4+GzqO9zihM7LuG8gNlQT22kKKDl9QVL++bN32GFE6g+n?=
 =?us-ascii?Q?38Q3tI/habF8amAeVEJlxNVP1BteuEu2i8e3GxloYkob2HB5n6UbPa9ZHLJ1?=
 =?us-ascii?Q?IENMkAbiLLBxLdqwviPUz9yeMynentTl3Uixc8BbYrnyJ4weA0SmbozC09v2?=
 =?us-ascii?Q?lk1XVvFzzWGttcGzPXuARtvSInabe9A0u1JJtyPNEXW2sxLm6XTPHeQb1Tdd?=
 =?us-ascii?Q?k5uFYevTGyX+LATq47zEckD7CSCvSEL6COIwV8AFtvChiahAj+smYyPPWkP9?=
 =?us-ascii?Q?TJkbfnrrfsUar+yKPc4MctnwjZTfJfRoGBYoRHMIwDF8x0E4Ox0nEoZm/g2i?=
 =?us-ascii?Q?PZ1qJ9ChwMP5HPJ6QAom3lIgKGe7k+jXNowLatvi0cnIp6NDwSUOCEBN45V6?=
 =?us-ascii?Q?TlgW1srKX5DU3vH/pIQRyjxQOAH1zoxKzkfQnCvfNARF7QuTFmEaOmfreTpJ?=
 =?us-ascii?Q?t9QM0J2R/tNYVobJsNc5SKOZEpD7kbxs6+/+qmMHJPEmCCiIFnqzygbLqCEa?=
 =?us-ascii?Q?Esfy285Hh+h7Bff1QnT7m/m0hdDO8qK6B3SuvXQGoLlm4A4AwBoGhdcXzfcG?=
 =?us-ascii?Q?nwvXXdB42x507VAATcaohMp9NIVIZOJq9WW++fB4QPfnWxLBh/8W3X5HSZz+?=
 =?us-ascii?Q?+C6UT2g4mLPep/BH5HNS8YgRdF62ltr0rABZ5G1jGDMjV+puKS3xNRLZX0KS?=
 =?us-ascii?Q?p4uzJ5yGCUgLHgZ/ny0mI4fzqzbZM7OnHj8odO3MhzetmCHc0LYYSAbtygSE?=
 =?us-ascii?Q?JCSV9ChnJN7RKpHgTxWihiTm2tQBJCYgMj9aYPzY2lpc0/Q2427jaydjh9mj?=
 =?us-ascii?Q?QtAkB+o4FyuaUc7IoX5ueZOjGUKuP6h/yui0t6pmakI1kSwcnOLFoCT+3bZa?=
 =?us-ascii?Q?HLTtsW6C4TsMc540p+jBPhmQGVBbWHf8R07k9GKP/iSYbeqy83Geon40wco8?=
 =?us-ascii?Q?lYgY7x00V5g0YTRDXv/Je4rgNQ3Sbq/5bhhAxzUjtpOaeRWM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36515700-895c-41db-8b5a-08dee1d82c51
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:46:10.8527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGOKHxnXZrZQBpQ6L/IS5QU9QjSw2vV2gbtClCNc8dlZWTD4aUDQ5doYA1+LEP6Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

pgsize is a constant property of the domain, it is the base translation
granule of the page table (4k, 16k, 64k) in log2.

Store it to the struct arm_smmu_domain based on how the page table was
created.

Pass it around in the tlbi.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 27 ++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 ++++---
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 1ed8a6f29dc445..5d4dde3d1cfe87 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -334,6 +334,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	 * ARM_SMMU_FEAT_RANGE_INV is present
 	 */
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
+	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 604b165be5fbdd..c567e8749f154b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2398,14 +2398,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi,
-					  size_t pgsize)
+					  struct arm_smmu_tlbi *tlbi)
 {
 	size_t inv_range = tlbi->iopte_size;
 	unsigned long iova = tlbi->iova;
 	unsigned long end = iova + tlbi->size;
 	unsigned long num_pages = 0;
-	unsigned int tg = pgsize;
+	u8 tg = tlbi->tgsz_lg2;
 	u64 orig_data0 = cmd->data[0];
 	u8 ttl = 0, tg_enc = 0;
 
@@ -2513,7 +2512,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2615,6 +2614,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
@@ -2870,6 +2870,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		return -ENOMEM;
 
 	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
@@ -3104,15 +3105,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
-			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
-			  size_t pgsize)
+			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid)
 {
 	struct arm_smmu_invs *build_invs = master->build_invs;
 	struct arm_smmu_inv *cur, inv = {
 		.smmu = master->smmu,
 		.type = type,
 		.id = id,
-		.pgsize = pgsize,
 	};
 
 	if (WARN_ON(build_invs->num_invs >= build_invs->max_invs))
@@ -3164,28 +3163,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
 {
 	const bool nesting = smmu_domain->nest_parent;
-	size_t pgsize = 0, i;
+	size_t i;
 
 	iommu_group_mutex_assert(master->dev);
 
 	master->build_invs->num_invs = 0;
 
-	/* Range-based invalidation requires the leaf pgsize for calculation */
-	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
-		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
-
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_SVA:
 	case ARM_SMMU_DOMAIN_S1:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
 					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
 					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	default:
@@ -3197,7 +3192,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (nesting) {
 		if (!arm_smmu_master_build_inv(
 			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
 			return NULL;
 	}
 
@@ -3208,7 +3203,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		 */
 		if (!arm_smmu_master_build_inv(
 			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
-			    master->streams[i].id, ssid, 0))
+			    master->streams[i].id, ssid))
 			return NULL;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4806a00844d30e..285a67a9a7a656 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -733,10 +733,9 @@ struct arm_smmu_inv {
 	u8 size_opcode;
 	u8 nsize_opcode;
 	u32 id; /* ASID or VMID or SID */
-	union {
-		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
-		u32 ssid; /* INV_TYPE_ATS */
-	};
+
+	/* Only used by INV_TYPE_ATS */
+	u32 ssid;
 
 	int users; /* users=0 to mark as a trash to be purged */
 };
@@ -807,6 +806,8 @@ struct arm_smmu_tlbi {
 	size_t size;
 	/* page or block size of the leaf iopte */
 	unsigned int iopte_size;
+	/* Base Translation Granule of the page table */
+	u8 tgsz_lg2;
 	bool leaf_only;
 };
 
@@ -1051,6 +1052,7 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
 	bool				nest_parent : 1;
+	u8				tgsz_lg2;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.43.0

