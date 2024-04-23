Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637701353F2;
	Tue, 23 Apr 2024 13:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878073; cv=fail; b=Mx32E8GmaRS8cLeoQKeCfrw1JMRFXcHfz1i7k+/n+Ne4gK+AzVIsUZ7vYxErqVgkOISzs2HlTMZUIrCuW8s5FgbeZpW53MCYY5LPJCMjF9y06adoUMXv7m0sbv9KkqMhB2GhxNKwBC8Bptc/jceqONgMAIu1wV9pGDKeuXji0tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878073; c=relaxed/simple;
	bh=oxGR912Tdb5WLvN01leS04cqKxnNnHvxObSB5CNScsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pdosMRMOcnSq537JTkn7LsJ4ZOGD/erhOoLre6kKLctjYz61ksiZPQfJMFVLKz+lw8J4vnfigzP8xLC2T7A0FIuA1LqBUW0VECf89tO40KGlJJf0vy+xGQWbj2OO+apvOpa5oDAlaBHR3LvxhbBK0GtV/tkXgK29ggBSi6buofA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LwfVqJMD; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LwfVqJMD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AF6Yxx7lo670RQa4ENeeK+vix3pr01zksgLXWiT5u5Xv7OVJDlmDyifGspEsO51YqR8X6gjoPC1KgQQnobmT2DGfyzDWEpomgt+ESqpQ7stUgKhgDGttG+6gMwdgzGaQDFXNQzlETn69VccIatGgsL8W8dWv2r3AVEV4nNvpQeZ5BsgKsSPXL/Ss1VEYcGSCSxauitt9MmFIUl2qgWa37VY9Rec8bpDcKKyUz8rwW0dq1mj8dlaARkDhPHYKr2Rp1kvvACkSeFJPlrFY1Zk7uJ/2rkNmr+oPBzkrDMy4WYXRvaDeqeUEsVzhDGJm2h7EZ484Txic8FFFGvh+3KwmSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuOQM+tk1hBYURM7kywp08aMkUjx537isuXThrhYqWA=;
 b=nJ037gln6FVfnlAQPMuV0nFqaffoJmNZNDQjIbizIYTxfMLBJtvN6SAslEpdSqFgyiypjQO6sOqQN0Epr+juIfYsZFdP/ZFile0EVjK860mMf+t9tBZUjQO6GAC0sZHN8v+av5IaeM88Fka5fpw2+Ywb3hlVsYC8MbI/+VLpSnYnMVAs1eMa3w1G4qfNZUxEIkCs/CSk7tT9orct4snWl0jN0U7XvraCrlfe7ZwCeOPeWb4LIQ/e2Pgf3+mCJNvCMDYBx/KKf1ZegRaAXt6ddBhofFLG8F7Oi1WRZ27K9aNGcONlt4dpmGSyBSh2AA1qZjuO2WrSqqKhiQMHSExUnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuOQM+tk1hBYURM7kywp08aMkUjx537isuXThrhYqWA=;
 b=LwfVqJMDw4jjUcB3cd8Sn8NK5gQxBPtyLt1hUZ+riq7MsqdhwCnzDNucZTmB5qb8cIjua4kI5DS+/5/BJDfHybvnMdmTUN9liCF896vmtTL9FJvfQRG109YJlocax2T2oEcul1/UDUxxzSF3oUsYfz7XwqjoQdw6X4h4LeNQpzyqeSktxP5XcLT/UB3yoScBNoLSpBCNE7AjTc5f4zRHYqzAmT8bBHbXJWQN+0X1j+Y+xMHZTzHU1CyrGYjNFATQmdwL8nJ2qVoSO40h+MrCoqt4nTy1iOb82hU7nAwNjfirVdI29WoWcXt4w13/v3VYe1KygFMFFpEn3V9d8l5DPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:22 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:22 +0000
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
Subject: [PATCH v8 1/9] iommu/arm-smmu-v3: Add an ops indirection to the STE code
Date: Tue, 23 Apr 2024 10:14:06 -0300
Message-ID: <1-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0365.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::10) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: b228a9a7-133b-4c12-9e2a-08dc639746bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mfoFow/P8eQPPxwmvNNS/45SODvJcgTAznBpXwr8gRKCm86/glyo8zEy6O1n?=
 =?us-ascii?Q?C4EsUt2tn6ezTIuz+OX71qvtR+r9p1oCL608R0ghxQlNjvMZ7Hq4ixyT+ZUM?=
 =?us-ascii?Q?kIj42vKQTtD3OLQ6ep7oZEWUUyPVtNSWR5oOKMC3XXaUbgOrBA5283na1/gv?=
 =?us-ascii?Q?2eb/NvvGx0Inz2Zm2YpOLcUO/EHuAGGwO95USm8vtZFzJbFm/qKUv8ee4kca?=
 =?us-ascii?Q?OIz+DXgOVyv791r8YUUiBkO9h4bnKoMFN0hkcpf+9wAO2Nc7Rj6g/52sUdIZ?=
 =?us-ascii?Q?ZEWi2JY9GzQX/zUeqnaf2c1FYROZFwj3uUOzBy5x6NawtDVx2u6W23UDxxOO?=
 =?us-ascii?Q?MQ3IjpGyf+J063+hPzwX0OJpAboSj+DgXqKsFiOjf88L5SwTgTfQ9a9DiV0Y?=
 =?us-ascii?Q?fgCa/dC7Yr9vLnmim0ZrW1R3sVRvFEypyjVhQJYOhUnbbXnrNUzbITpObpn1?=
 =?us-ascii?Q?EwzQ8mWvpdIV3u799jfpd/5PScG70XS8rkCwUQzaeov8MY7HQzQengEQrjFP?=
 =?us-ascii?Q?BygQZ4ucfQCYa37k2E0E0FnIBOmN/D+m2ggZQiFk9N8mtyF7v/kwrsDP7cym?=
 =?us-ascii?Q?oRP5IizhponFq5Rj0kB1ZNaZuq5KBWm2BGF+puP8lUOkXaxlL1HzJtZM6KaB?=
 =?us-ascii?Q?PciFE1nYPsw2hacuNbqXq/I9VpJs5jP7w44m5nvHevSxuxhhUmnGWTzzAyGU?=
 =?us-ascii?Q?eoyHIlZ04pWwcfR40AgJrm/FzMGV5apC3Z+pZXh99hDFLXc2eXElo0/powq4?=
 =?us-ascii?Q?KBIku/vHr7llHEFeGMBpO3geivizjUOzVXfB+A2kwWoggo7byengQnEJ16qz?=
 =?us-ascii?Q?QfGOkoyOG0tXhPW2QOftswKfqoUfZlfBhj+0v/1W2Cy+2uPRF6JYjJcK03+Q?=
 =?us-ascii?Q?KqfHVgUhkanxxuwteDkeuVeKGvPtOTjugsfFvpR+fsQyEi4nZc851kPm3Ytk?=
 =?us-ascii?Q?CWUEVgp0Rfv695df+aLWx7bnnvorOqp9zl4XukNgBaO6c9FS8rrVOpxeoE8L?=
 =?us-ascii?Q?KNeZkgEgWwkdEUvGhmRQZgvFZ9FVlsc1e6q6HoVwGhABzTwOC5fOhaP6Rc8+?=
 =?us-ascii?Q?bLqiqiVtoDnDmsz5KZP3CWvSuC1nqYRHQVxiOCs2+Is3BcfEitvBzFYkrVio?=
 =?us-ascii?Q?Tj1ZV94ycwDHy669Z+MzKqVhY0fWfvrh0jJmDduJX5nObgggojU/EX1/eHD+?=
 =?us-ascii?Q?kikZ6We5ue97AWpoaqM8rPCy9yjAz0yyMPhKnHkbmIrVwBkwasdISpzTAqEL?=
 =?us-ascii?Q?5pTpTvwGsKzC8F0Pa9ITC9tId6mH9pPuhLTb2pMqKA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CRorQPGZNoPh/J5GKEd1UQw7V5u99vcN5AOtXLqXbOjmN22po+l4P620MmM7?=
 =?us-ascii?Q?owz4TjXxb5maR9K9o2tUnEWhW3nBtt9eYZXpN/mCfhYe2XphVDzNSRLaArTI?=
 =?us-ascii?Q?OAxpq2K20RxVkIqIgiSLGg03LhFqEJVSvjCzH8zH6UBeMHY13PgjdynPuVOr?=
 =?us-ascii?Q?4CPtN1kNUC/mOvreFgdeZf5zIjU5hZ76NmLXqmANiHQdbUNZWvnSOW5WQT+3?=
 =?us-ascii?Q?mFVuEVh4vLiMjmAthwZ1jt0IyN+2LddWaW3rDzkbyH2yCqm+TjG29ZKVlvWm?=
 =?us-ascii?Q?uCnDxPucgrLB4pNXvS78CgcjQQSB/xT/5D8LXRvr/QFnJFQ4FFxAuXZyuRUa?=
 =?us-ascii?Q?CnCcks8+Hvc2pEAFpb1PdhqF3SNVXOZxBZkTudhiE5EYeTb+dnr4j742h3pZ?=
 =?us-ascii?Q?dMp1R0oj/hdy4xKK99AxTNVlwBncntfg7lLOjwQ7rX7lyzixhG9zDslw8OL0?=
 =?us-ascii?Q?wJyjIRkNCx96NLYdV6L1/d/DENWpDRiW05l7enCZ4hETM10JNM9gFVAI/Xxa?=
 =?us-ascii?Q?VPDIYoG3QMAlZj/MGvMdrbaWnBlQPGMnx+F0axbUjf7F4JcZrfv0EP1Q7YAX?=
 =?us-ascii?Q?uBqBN3C3NTX2YCOMyV+bq6UVPkg1GDwkqfmiNWvN8xAQy8SbKTQc88a4yBfv?=
 =?us-ascii?Q?6JobjgXk+koL8RvauKcv5hst0qNyFpo+aWfyKPvXwTxfvdcU/IpajYqIFr2S?=
 =?us-ascii?Q?rbz2259+9ww5pjt1B8qVMIAYJ+elXaibnbH89UVND38yuEOShS5ViegIB8q1?=
 =?us-ascii?Q?h6lOvymcCSuuzvVxyBMnNj2YseJHoA4ZPS3vOeoq+QMzeUiPHL2NwXxRH0HZ?=
 =?us-ascii?Q?IU0NkcB7dXPDfaiBke3Cx6JcsOXLeGfwNV49utl3Fx0diZxUWV0/jOBSPddY?=
 =?us-ascii?Q?2zZ25mRQFHe0IVepFqm+6JolGxCbtu9IhWr1osKUHifBaz4WclXppk0QkxTc?=
 =?us-ascii?Q?lrz6LEk6leuiMhEwwQkKlsowOKrJm0NOgB1BmB0YpmKaUXPt0tJjVXUUS4+f?=
 =?us-ascii?Q?4/2lyxOXJetkaw3Xo0weanAMUib3f6IjfSu1FimyB7jRcvTwr0l7afh7Tbro?=
 =?us-ascii?Q?xHf44FNODJpaLMysmOylt47uUdVIiekDIEOWkxZIkE+szhuNJ1r9oVSRE+v2?=
 =?us-ascii?Q?AVArj/lj72KTDeDBjm+qdieaOYkYFa2r3IouTB6cXQhC/DRb6Nmqv1yo1zZG?=
 =?us-ascii?Q?rgz1YVFIrjsxQFiZswkdeLm5wubRW1B+16+XHz/CeH6Exv2ikaC6xIXPD/UR?=
 =?us-ascii?Q?7TYgMu3b+M9MdoAqWHQUI0bDSBMeWbvVyuhfjn0MXzm7WytMpjFz8t4Ia/g5?=
 =?us-ascii?Q?oRa3HFTCJzxEUhsaMGlsNlf2DBgb2BVZAYS1AT9NBFD78QqLW64gpzMzELOC?=
 =?us-ascii?Q?2+RRn3GeQcNCr8zXV6hFMMYaVwLCIWMreTg9BqD7hX37fE/WcfutVPrqmiwD?=
 =?us-ascii?Q?KXctb8kTGxMtcOz3inZ9sy993iQVAH1jdSFHtp2SBQsidtJTNM1TRYTvL3QB?=
 =?us-ascii?Q?qOtueaV+RcwioKCGmk45j3WA/LNR/M++K7+ZrBT7/sNUnsXvorLexOfafPRr?=
 =?us-ascii?Q?dYvulkyUspCPcKZoojom1ZMqNZ8KX8dWHs31wuiI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b228a9a7-133b-4c12-9e2a-08dc639746bb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.9248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LjFpx+mbvRIrWO7594VQG2JPldU15LLP24Jy9FJ4oFkySsZ+7iVlH0xTTJYIi/Eg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5672

Prepare to put the CD code into the same mechanism. Add an ops indirection
around all the STE specific code and make the worker functions independent
of the entry content being processed.

get_used and sync ops are provided to hook the correct code.

Signed-off-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 176 ++++++++++++--------
 1 file changed, 104 insertions(+), 72 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 79c18e95dd293e..196aeaf280042c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -42,8 +42,19 @@ enum arm_smmu_msi_index {
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
+	void (*get_used)(const __le64 *entry, __le64 *used);
+	void (*sync)(struct arm_smmu_entry_writer *writer);
+};
+
+#define NUM_ENTRY_QWORDS 8
+static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -972,43 +983,42 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
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
@@ -1017,57 +1027,55 @@ static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
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
+	for (i = 0; i != NUM_ENTRY_QWORDS; i++) {
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
 
@@ -1097,24 +1105,21 @@ static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
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
+	__le64 unused_update[NUM_ENTRY_QWORDS];
 	u8 used_qword_diff;
 
 	used_qword_diff =
-		arm_smmu_entry_qword_diff(entry, target, &unused_update);
+		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
 	if (hweight8(used_qword_diff) == 1) {
 		/*
 		 * Only one qword needs its used bits to be changed. This is a
-		 * hitless update, update all bits the current STE is ignoring
-		 * to their new values, then update a single "critical qword" to
-		 * change the STE and finally 0 out any bits that are now unused
-		 * in the target configuration.
+		 * hitless update, update all bits the current STE/CD is
+		 * ignoring to their new values, then update a single "critical
+		 * qword" to change the STE/CD and finally 0 out any bits that
+		 * are now unused in the target configuration.
 		 */
 		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
 
@@ -1123,22 +1128,21 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
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
+		entry_set(writer, entry, unused_update, 0, NUM_ENTRY_QWORDS);
+		entry_set(writer, entry, target, critical_qword_index, 1);
+		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
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
+		unused_update[0] = 0;
+		entry_set(writer, entry, unused_update, 0, 1);
+		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
+		entry_set(writer, entry, target, 0, 1);
 	} else {
 		/*
 		 * No inuse bit changed. Sanity check that all unused bits are 0
@@ -1146,18 +1150,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
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
+			entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS));
 	}
 }
 
@@ -1430,17 +1423,56 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
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

