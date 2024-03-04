Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022117D3EA;
	Mon,  4 Mar 2024 23:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595872; cv=fail; b=l276sSX/7v/kjkW7EsTJeHi8seaSCYjU5N/oTtQMXyeDKpP9i03uoQ6fkbKv+BGaZMgYCEytQYCe5yBcwbBqI7AWSYoJPGNnRoY7yNk/3YCrdoDP8q7NaBfEm8dvcV3M7d7BtJxu3dBWzzVYVNL7L595U9MgyDZooutA1Ezn6bc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595872; c=relaxed/simple;
	bh=qaRrSPdaM9F9BHFZIhY1JHh9aC974urgvKzNi57EvGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DyA/Z/1mfqCXmiZDqIJ/0DPCrQ3U1H+bnzeSIWAkQxZpI8wzKWejj7NiAXUmfTS01HfY/x9AhastVOJakRUlRML+3zafNWzMy64q9Ymsqi54V+Cg/Y6HKNorr0/O4ZO7an8xUkpjbFHSmGD7awUIPbx9lg3Isnag+Pj83p5o7OY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N5FJ9FF/; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N5FJ9FF/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ct56x94CXbuzs26kv9sA4J8EZY/2hYPnx5XoEY+Oi+SET6X1ALVPfQ0Rr0kFu39yxbMZNYcm3VigkOfm6Ao5bmBSFd6tLxW6nj0CnYLD7zw+IXXzH0z2Gt5BmT3SmxWpOFuFWnmPibFb9wKfNwbEYeNLUAwtzq4BZ1ssVHKGUaFljoatBlkX+4PAgIX1GRb0GZ2jCCsK0K9CdjgS/BngjUWWidRo0WvbzpiXAP3cIgLphnAbFyfmqUxVRUolDYtncKCi4iJuIOAl7UkAe2oorU4Bue4Y52IDF+tdKkHKsKTXeRh0z4BnEkyKkCO8oZ7QeHuYO+VyOA5eQlbCXJy9fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsXgEMkucgCR5lZhtWTE8+SWV0OxYMjdgI/3A8k59wc=;
 b=GxgMraxdAzPNz1PauoSH855cfwgJQItj0CpT7AOZoV1nbb7tZNga1WKx4Lp1bL0M8ML5JUqR8gnxptXyZNG4Ytg8UJXh+NSlTGJg8oDNXqj5bF0rlTlZNxVtrp2VgMfbE36xuWqY0ac6WZ6GguJGgNoqlxToPgseC1EOdGCyDU1OrtaloRbaK64Y/RdRFcis71Iq7DyMtZMt5VpmZ2Y1k1fEg8XoQHGLUb7qh4roQpr3zEthQSoYDlXlD7rdpDadKd+t1whYPIwtSeP+/pdsMbydyrP4IvbmzUibD93tkQqD/UrK07h6st6D69OCAzFb6gLp2QOkZaOXD5XZXjgo5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsXgEMkucgCR5lZhtWTE8+SWV0OxYMjdgI/3A8k59wc=;
 b=N5FJ9FF/4NwO+YABRGbf9M/3lTZjacnShIBuqwADmm7ngHPrxW5jw3V//qDjZjRiVWdyQ4c8/8sxy/MyMePtnqiJ7WbxYO6/k1hlMGhnYsxCKPyfzGCyLTlloTeQkqerFQMJ/mrh/ozWfQOhS9HL21ubx8+EBvGpQla1481+ID944c2qJca80ab0feS/uz9tIic+a7exsXd3G6YbFjeo6X8Exy+ky9usH28A4kQiVkDH130MamwYhSnBH55B2u8+dzFS2h2zz2HB5+odeqqerzxdrPEYkG5KbhgFph3qrWpw4nhejf1jU+Ex91PAnnArg5YbX8q2to5+eoP9zCATDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:20 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v5 04/27] iommu/arm-smmu-v3: Add an ops indirection to the STE code
Date: Mon,  4 Mar 2024 19:43:52 -0400
Message-ID: <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0025.namprd12.prod.outlook.com
 (2603:10b6:208:a8::38) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 77460ef5-3cde-4ca5-aad8-08dc3ca50105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sxyIt+ZZzpimVFKYIdPUV/MamVOs/+LIhaA2mmeIGT9yQrnKhxzwVDPvkrGBeVfA34OibMv2jqmsTQRBQOYeZKsIMZ8IXT4Z9gLAFKZ9B74Gmv+oPrxNT+9ANMJDzdd49cZEsRTr0F+gMvXr2c462HwQGoZo+EDl+DHP3g+eKV+e5mz6FVtsZ3h3arg7xxmjysAmocNdzLTVYzsJhUZpT1MqFDcI6IzW9O+Rj9R9L3cB3mOBb7lVcBNAZ4WNc0Q5/yT63P7PEhgViGeVtcNC3ELzT4Em5eHsq3aNNyLX3+pDnb0VPezDkeVNid5IYMR/L1bxY2gg7Pz78FQqKm28G8Kh/n1zgeIQglllTz4f38ldl/L11mq/eAd8JFI6sHcBU9ivZI9bWKgBy1HLH515E0Vbur2HkKjGJfehxkRM9eZuVikcGGdxSlhOnJHi1Zv0JmwPNyz6Eo5qVFu9aQj1H2EYIDYbgI1d0U+SR4OjmuK+aekpjB//UqAHnOjkuGJz/1rDURaYUZnS1m+rdxSXLQgw+rWdhjx5fh3/yTkGOJV+QOBmyQZ7U8cGOV3YgJTdN2mgcVux0Fn7nXccWG5mUHrwOUBXrjnHlalH0SqfgxKlZebUiBSuEkFdv5IpYHpLOH1pE8bHx2MYkUI6ZMEi8NFltE+LLQTU6v4vMf0/NEY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r1LAEDV/nmvgSCajF4YZ43idG8vd9cU36WS6eQtJZ0XRyFeqLGFiq2WXRU+b?=
 =?us-ascii?Q?WuAr9PkJe1TnTE7C6QMhkZjhP7vVe5vaSjnE5rIiX3aw+g+YFsUYXrrT/wHN?=
 =?us-ascii?Q?GH0Hv1nMrZnbJ3ZGQ5jJdb/2Ji25wOcrKkiId5teQq917PplsQ4otne2RY5X?=
 =?us-ascii?Q?l8MM7mp/GaEtMcrWa7cpGF2/U3xnHajg8CbLh5usI4gJsCGrcSqjEDMn8wDw?=
 =?us-ascii?Q?q2g6JWypY/0iouNVYkk/g4olSWTOYUdgIP2VYXdrNvQ2PKrJkrAulrqj0kwh?=
 =?us-ascii?Q?DP73C9Z1XkEjhPVAUkiP8HGSk1CSj1CBY/+DAD+FDu5t++vrJ7irYEnSSacD?=
 =?us-ascii?Q?3pVBuaFyqSeUs0lagqiKW6StTd2dMmn5plOIeKZ451vnYSlspKFkQ0xFdpri?=
 =?us-ascii?Q?umG3u6K2h7/pEAgs3V+8oy/vrm49DaH2zllSPuuF/shLORCgRnwbLWMYvODA?=
 =?us-ascii?Q?9mMM8pO6GwMoZNFFU3Go3OovtpmopTSSga2MXcyKkSKhshYHlynuBIYgkDtq?=
 =?us-ascii?Q?epkQ5xGfJcP1wjn68xh9IXYdUuQgH/vI6xU5xeiEA1ZwawcwhxGODf+SaUxi?=
 =?us-ascii?Q?fJuN3gc2zjaAEcudeP+Mr6rgn1FvzuM3KyPS1L61FmVVqlC7A3fipfN4chUv?=
 =?us-ascii?Q?KoL3b6hW3Fa+R7DoNsYAplvafGDfU3H4TTOpPC3qKQap0GLph/KeuSTPqyQ7?=
 =?us-ascii?Q?NovXnzpogLoPWjxeT0aAXf4OxILMAYw84q3z8mC+XB/PpqxEAbJg2KdGvkGZ?=
 =?us-ascii?Q?kCV9skSQ4latQbDrjdzZRrNW/rhFZPOCUkGe0/dQC3UnN+Ugs0EXr77KUyLS?=
 =?us-ascii?Q?YLrr4t8v8hkaFP62LfLxQpgLvIHYZ/VMkvwKh6L/GHAZeYO944dK4N+9VEfb?=
 =?us-ascii?Q?lMbjRkkOPDzJQ5Fpl3jlCRMNB75205fU4bM8ptLhGyPDNyAnMOlYFJyk0ezP?=
 =?us-ascii?Q?fNhjjuUWS7ZigECBQAjR+1I+t30GcPzJytZUon5paPm1czWAwvEKbrA1Kywi?=
 =?us-ascii?Q?0ZtRfNn/nzMfv4HAw6jxfcgOlqM43MRgxmeaBWPTBKjQIbZXNCAPuzLOjjoO?=
 =?us-ascii?Q?aer3ELIxA4siMeU5zXCW8rdwvtJ+NQrupEnt0ivthfduYyRS06i1DVXY+X6k?=
 =?us-ascii?Q?B/2bdQ0oBWM/ZfmOlYb0Fdt2gIC+3AVLqTIQPuyZ76i0HgoGDFaltSTgY88B?=
 =?us-ascii?Q?eaar1P7FyiEWH9RhS1gFo42q/lsL0dxnXIgco5LTiE+/XFZVvfOJQVuNcqda?=
 =?us-ascii?Q?+UvZjXPhysT8LF8hs5oiC4uVk/+t1qyfzxPbO5od9kNCcORRud3R3irdjeiY?=
 =?us-ascii?Q?5SBAd/O7+XartpNgEL37RAEBJQ3kgO84mYo3mMtAErbn0PH7JONbkxl9t6NV?=
 =?us-ascii?Q?k/DJbERtbup/ZLo20KUlLZ2tlHp2Asf0BkU8DLyMe+RZkxZRNHPiayCevY3d?=
 =?us-ascii?Q?SzVXdDgZ/rqZEjeu04xBRDKPedz5u1b9RHfKW8EuYH2oRGaskIuNtMQn7ER8?=
 =?us-ascii?Q?N7Ie+tSu9TMucoj7NecUjlK2+SBAKqkpBrMHZNvkS1PWl0rDoXNeUlJhr7cO?=
 =?us-ascii?Q?O4/z5OXcfe9hqKp1xMyXm3JH3YKFmDjFV1/CJ/V7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77460ef5-3cde-4ca5-aad8-08dc3ca50105
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ioGC1l9tMiKIJ+JlRuCBZ6SdUe8irYvSDBgtstK/H9Z6yslsZMvjj09QSstXbXUh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

Prepare to put the CD code into the same mechanism. Add an ops indirection
around all the STE specific code and make the worker functions independent
of the entry content being processed.

get_used and sync ops are provided to hook the correct code.

Signed-off-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 172 ++++++++++++--------
 1 file changed, 104 insertions(+), 68 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c60b067c1f553e..b7f947e36f596f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -48,8 +48,20 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
-static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
-				      ioasid_t sid);
+struct arm_smmu_entry_writer_ops;
+struct arm_smmu_entry_writer {
+	const struct arm_smmu_entry_writer_ops *ops;
+	struct arm_smmu_master *master;
+};
+
+struct arm_smmu_entry_writer_ops {
+	unsigned int num_entry_qwords;
+	__le64 v_bit;
+	void (*get_used)(const __le64 *entry, __le64 *used);
+	void (*sync)(struct arm_smmu_entry_writer *writer);
+};
+
+#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -982,43 +994,42 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
  * would be nice if this was complete according to the spec, but minimally it
  * has to capture the bits this driver uses.
  */
-static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
-				  struct arm_smmu_ste *used_bits)
+static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 {
-	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]));
+	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
 
-	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
-	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
+	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
+	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
 		return;
 
-	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
+	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
 
 	/* S1 translates */
 	if (cfg & BIT(0)) {
-		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
-						  STRTAB_STE_0_S1CTXPTR_MASK |
-						  STRTAB_STE_0_S1CDMAX);
-		used_bits->data[1] |=
+		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
+					    STRTAB_STE_0_S1CTXPTR_MASK |
+					    STRTAB_STE_0_S1CDMAX);
+		used_bits[1] |=
 			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
 				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
 				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
 				    STRTAB_STE_1_EATS);
-		used_bits->data[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
 	}
 
 	/* S2 translates */
 	if (cfg & BIT(1)) {
-		used_bits->data[1] |=
+		used_bits[1] |=
 			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
-		used_bits->data[2] |=
+		used_bits[2] |=
 			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
 				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
 				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
-		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
+		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
 	}
 
 	if (cfg == STRTAB_STE_0_CFG_BYPASS)
-		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 }
 
 /*
@@ -1027,57 +1038,55 @@ static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
  * unused_update is an intermediate value of entry that has unused bits set to
  * their new values.
  */
-static u8 arm_smmu_entry_qword_diff(const struct arm_smmu_ste *entry,
-				    const struct arm_smmu_ste *target,
-				    struct arm_smmu_ste *unused_update)
+static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
+				    const __le64 *entry, const __le64 *target,
+				    __le64 *unused_update)
 {
-	struct arm_smmu_ste target_used = {};
-	struct arm_smmu_ste cur_used = {};
+	__le64 target_used[NUM_ENTRY_QWORDS] = {};
+	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
 	u8 used_qword_diff = 0;
 	unsigned int i;
 
-	arm_smmu_get_ste_used(entry, &cur_used);
-	arm_smmu_get_ste_used(target, &target_used);
+	writer->ops->get_used(entry, cur_used);
+	writer->ops->get_used(target, target_used);
 
-	for (i = 0; i != ARRAY_SIZE(target_used.data); i++) {
+	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
 		/*
 		 * Check that masks are up to date, the make functions are not
 		 * allowed to set a bit to 1 if the used function doesn't say it
 		 * is used.
 		 */
-		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
+		WARN_ON_ONCE(target[i] & ~target_used[i]);
 
 		/* Bits can change because they are not currently being used */
-		unused_update->data[i] = (entry->data[i] & cur_used.data[i]) |
-					 (target->data[i] & ~cur_used.data[i]);
+		unused_update[i] = (entry[i] & cur_used[i]) |
+				   (target[i] & ~cur_used[i]);
 		/*
 		 * Each bit indicates that a used bit in a qword needs to be
 		 * changed after unused_update is applied.
 		 */
-		if ((unused_update->data[i] & target_used.data[i]) !=
-		    target->data[i])
+		if ((unused_update[i] & target_used[i]) != target[i])
 			used_qword_diff |= 1 << i;
 	}
 	return used_qword_diff;
 }
 
-static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
-		      struct arm_smmu_ste *entry,
-		      const struct arm_smmu_ste *target, unsigned int start,
+static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
+		      const __le64 *target, unsigned int start,
 		      unsigned int len)
 {
 	bool changed = false;
 	unsigned int i;
 
 	for (i = start; len != 0; len--, i++) {
-		if (entry->data[i] != target->data[i]) {
-			WRITE_ONCE(entry->data[i], target->data[i]);
+		if (entry[i] != target[i]) {
+			WRITE_ONCE(entry[i], target[i]);
 			changed = true;
 		}
 	}
 
 	if (changed)
-		arm_smmu_sync_ste_for_sid(smmu, sid);
+		writer->ops->sync(writer);
 	return changed;
 }
 
@@ -1107,17 +1116,15 @@ static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
  * V=0 process. This relies on the IGNORED behavior described in the
  * specification.
  */
-static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
-			       struct arm_smmu_ste *entry,
-			       const struct arm_smmu_ste *target)
+static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
+				 __le64 *entry, const __le64 *target)
 {
-	unsigned int num_entry_qwords = ARRAY_SIZE(target->data);
-	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_ste unused_update;
+	unsigned int num_entry_qwords = writer->ops->num_entry_qwords;
+	__le64 unused_update[NUM_ENTRY_QWORDS];
 	u8 used_qword_diff;
 
 	used_qword_diff =
-		arm_smmu_entry_qword_diff(entry, target, &unused_update);
+		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
 	if (hweight8(used_qword_diff) == 1) {
 		/*
 		 * Only one qword needs its used bits to be changed. This is a
@@ -1133,22 +1140,21 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 		 * writing it in the next step anyways. This can save a sync
 		 * when the only change is in that qword.
 		 */
-		unused_update.data[critical_qword_index] =
-			entry->data[critical_qword_index];
-		entry_set(smmu, sid, entry, &unused_update, 0, num_entry_qwords);
-		entry_set(smmu, sid, entry, target, critical_qword_index, 1);
-		entry_set(smmu, sid, entry, target, 0, num_entry_qwords);
+		unused_update[critical_qword_index] =
+			entry[critical_qword_index];
+		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
+		entry_set(writer, entry, target, critical_qword_index, 1);
+		entry_set(writer, entry, target, 0, num_entry_qwords);
 	} else if (used_qword_diff) {
 		/*
 		 * At least two qwords need their inuse bits to be changed. This
 		 * requires a breaking update, zero the V bit, write all qwords
 		 * but 0, then set qword 0
 		 */
-		unused_update.data[0] = entry->data[0] &
-					cpu_to_le64(~STRTAB_STE_0_V);
-		entry_set(smmu, sid, entry, &unused_update, 0, 1);
-		entry_set(smmu, sid, entry, target, 1, num_entry_qwords - 1);
-		entry_set(smmu, sid, entry, target, 0, 1);
+		unused_update[0] = entry[0] & (~writer->ops->v_bit);
+		entry_set(writer, entry, unused_update, 0, 1);
+		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
+		entry_set(writer, entry, target, 0, 1);
 	} else {
 		/*
 		 * No inuse bit changed. Sanity check that all unused bits are 0
@@ -1156,18 +1162,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 		 * compute_qword_diff().
 		 */
 		WARN_ON_ONCE(
-			entry_set(smmu, sid, entry, target, 0, num_entry_qwords));
-	}
-
-	/* It's likely that we'll want to use the new STE soon */
-	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
-		struct arm_smmu_cmdq_ent
-			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
-					 .prefetch = {
-						 .sid = sid,
-					 } };
-
-		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+			entry_set(writer, entry, target, 0, num_entry_qwords));
 	}
 }
 
@@ -1440,17 +1435,58 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
+struct arm_smmu_ste_writer {
+	struct arm_smmu_entry_writer writer;
+	u32 sid;
+};
+
+static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 {
+	struct arm_smmu_ste_writer *ste_writer =
+		container_of(writer, struct arm_smmu_ste_writer, writer);
 	struct arm_smmu_cmdq_ent cmd = {
 		.opcode	= CMDQ_OP_CFGI_STE,
 		.cfgi	= {
-			.sid	= sid,
+			.sid	= ste_writer->sid,
 			.leaf	= true,
 		},
 	};
 
-	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
+}
+
+static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
+	.sync = arm_smmu_ste_writer_sync_entry,
+	.get_used = arm_smmu_get_ste_used,
+	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
+	.num_entry_qwords = sizeof(struct arm_smmu_ste) / sizeof(u64),
+};
+
+static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
+			       struct arm_smmu_ste *ste,
+			       const struct arm_smmu_ste *target)
+{
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_ste_writer ste_writer = {
+		.writer = {
+			.ops = &arm_smmu_ste_writer_ops,
+			.master = master,
+		},
+		.sid = sid,
+	};
+
+	arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data);
+
+	/* It's likely that we'll want to use the new STE soon */
+	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
+		struct arm_smmu_cmdq_ent
+			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
+					 .prefetch = {
+						 .sid = sid,
+					 } };
+
+		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+	}
 }
 
 static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
-- 
2.43.2

