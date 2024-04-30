Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3798C17B4F7;
	Tue, 30 Apr 2024 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497707; cv=fail; b=jHKoXXEqBzwpq3l2gnKZ7MRaRWsrjHjw0/wOpKZ9RhdTYENVNpOafp7uoyPi+PCw46RbMLPH6+8i0WWQwUREDybGYjaDnitLfmVC0A3hLFRt18+Jyq0MAQl+07hOaGl8zNg+t37IY1tI5BahwCGqM7RoKu13GIz7J3hl2BCWPkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497707; c=relaxed/simple;
	bh=dJchllpxwZWUiqLIFBi97P+T2iGb2dhDx05w3tuyMBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JCLLvArdFBJSEYioY/AbNBTU3fpE1VLpiia4yY/oGEjJN/0ZcDe5ImcNpZK4LNeWUyweEWWcHsonG3KxKEEAJ41XqhILJFwk7asaArj6KfGDvGKoX4myq9gSfi597rt0+zliw7NBHD78PkZMXahFzxzzfP6/BdBnaUGg1S9/STw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XMkGetLz; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XMkGetLz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YntBr160H3bNPOb/anPl5IJaRmL92srcw+9zdg4MInLuVIVkpTUkhcAlwE9aWBCaQ6PKff/tgI1OEo8ZCDMchF/mHNPkirquBNyv6HCqWTMD7wB3WEZcYz+VEz0EzQpkeNnAMjHiPkHfgVCojQH5PDf7DzMbldM/FBGFYGfqbq2kfJh+nrhQY5k5XcuvgF2FKdl1mnS5pnIdV7g1cG/SNtUOLvFA+/6/bOfb2EJ1FlmCs0eALVfim3U59d1gJ77Be9Lz80J0/eRw+7n9QfdCtxh1uIEA2hmppePqyX4d5IKNrjHtb8Bs7ZtvRS+GVA9QaAavHZo+Xz0gZ65+podPNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0PSPwTMKz929rCyULVrpInHYArcUbpgRlrKoxMH+xU=;
 b=dEGSQqceM4eQTAwK1Sj5g4sxY0+Dzbh3+4NIpF+YG0XtDEVej6bEfbIQrGSIPWEclgqT/km0sqFAWv9xCp/6wu3KZT8FClk3ZfjULZKSJFEZZhjDoAcb8gezBoQuJPgwdvynbfKNqRSiqh1ejMM6G+z+gR5p+9NvhrMAqKOHzyZHTnuTEZhYPMFTnYdiuW9kaoXJz5u7ThblgIV7cRKVkUblhYcijhqKDqzRu6IlCtvU35ZVhL0xvCp8sR5UYvIJ1Oq41Xb6IaXDIFyt45Zv2dELQjcRjZ35orDXD2E34X9JK5IyySafOwkysjRrpQa0ao3YWJ7PuglRGEw8n6xVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0PSPwTMKz929rCyULVrpInHYArcUbpgRlrKoxMH+xU=;
 b=XMkGetLzilUdzNIrtkhcSB+0BCylb8myAufjCO1JQldsu7aV4KamOY403dmiGGP3760Z/BUYwoHQLIyaISgRUigzzudrqdKZa0pR04hqMckNsMEWtXVaG8LNnQ4+S0NHlomyyNFtJ5LEtnZ/617Q08mDNWm3llmU3pRzYYrJTuGVo6jfbSKXzvv40rF6bLHnLG5Cmipxn/GlaMDZ5EPRFZVicnJUAT7cYySNFxF7qhJaywz3PDiJX5Q0X0EXZ7IXLZuT0CFyCzgvby3Ex0R94NaHyXVbcR10v9AjVi/DNlDvFOA47Kah5xIugNMbDaLqtepb2/40eMT/yATPZ9WEtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:42 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:42 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 2/9] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
Date: Tue, 30 Apr 2024 14:21:34 -0300
Message-ID: <2-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:208:32e::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 90f85db0-51fc-4c90-5d21-08dc693a0105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kjVtH45K1ccQRLRTKGbD4qMcl/T9up9bIRtg8ec8uYHsK5QeqUmIrCXsuLt3?=
 =?us-ascii?Q?b2RZVvpTGguWi1WlkzOLXOBCQzik3j3Q62/AAoLQIS+5oirp+iQIAK/455YO?=
 =?us-ascii?Q?AlssYTwBcVzi6VBOVT1YXNVxixMVOsIdblTbC0rLvYg0D27IibcYJZrLGXzX?=
 =?us-ascii?Q?Pqpi3abKhA0NjwOrxchI4hU5jMT5SKXToHIMc4dBobFNdcsW3wRcpHxixXYA?=
 =?us-ascii?Q?orcHyOpl4lwlC48RxGT5xWXLS9jfAGNbyaxKJV5VSlM1uBIHlWsNKh6zo5dH?=
 =?us-ascii?Q?rWIbL2KcHWldFt7vzPUADWG9lFUMrR1lkTJGreiWjlu/cuJ4/RO8MDMArOkv?=
 =?us-ascii?Q?Ig1G5KNL8uJQMyZn6SuDAMs5ARqCbJ+ubdtlckWgJWxWP3vPCoQ0cnRZ5Fuw?=
 =?us-ascii?Q?pXkZ9tPaeOcC5d0mRaxQJXp/4Kl0gcWvLdgwjExRDbrEYkeIjkjAZyHSqXGw?=
 =?us-ascii?Q?EVUqwzliDVj0mZWgZLBj9d5yCHkyiZqVWNNmUIZtvbdIuzJUaDMTjSBQCSHi?=
 =?us-ascii?Q?MvkFoXQe1PJvHj9aTK6JQQGsEy13jILAlMpsYo6wL0XtNJKdgpovMFURdUGZ?=
 =?us-ascii?Q?W5Kd97BCsk16VZuGghbIAFnugaz6t6TKcTC6vwUwpl3GJCQ8rhpMF8lgCqq9?=
 =?us-ascii?Q?udgBU+yFfBPQVEucFqjSqPUJowMh+E1pmsWNKIEhcY0mqdJ8LAAyywNS8dpv?=
 =?us-ascii?Q?MDQVJMWfdqEGxoAC6FwCXgsEDzH07V8DPMUmYHvUp1HG9hhlmgxKq9GPlpha?=
 =?us-ascii?Q?//WLJ9wl979/cmFPubas5RRKA0he4dxk3n9SyOc+wycJItcoTAqEVb67BFtF?=
 =?us-ascii?Q?Td6o6uQrnrRAq7sYvUf80IV9iPvlCDXAXuOP/QzL3cCCeZcM/4T3ut3W/4eI?=
 =?us-ascii?Q?zBuNYc/0mL3DWVF/CRE6AitBGbg2UTZEeYaOTO13K/UWH4LfzJcfiCOrJZS0?=
 =?us-ascii?Q?CprV6YbF2mFo0l6heJ4kj4m1OkEP9PNx1XshlJ6j2W+3vxvExDGgeMacz6L5?=
 =?us-ascii?Q?1QS5Z/wX0qm63eEB1uWZ6M2CAhljuSIjl3nlj1Bn3N5B5By8wg14vpp7Hg/b?=
 =?us-ascii?Q?50ahadg+f5PYsAc2t5DjAqAxNiK6oco4zezwOCFo/MIhfEnv/Fx0b1DXE9V6?=
 =?us-ascii?Q?DF/YZHEv7XCRt6moQzfq1K+P/XSWNPdNmiRLIeSDoWS1SKzX05tNzdmXfhgr?=
 =?us-ascii?Q?A8wuMYW1TxKnF2pO0U3Kio7BraKc+ZMQFkJqqsS1xa2tE7rYIOPN9E3TmTQF?=
 =?us-ascii?Q?x85jEjqAlpr9p97imz3upFBqn2FJh8M8G2MHmHzvpQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?trP1GRP74cznjEoJP+TqoeJjmNQ+OngzB/a4zX0ghdbfrkA8XZ0L/T1FCJ+P?=
 =?us-ascii?Q?X3U/DGOd5VS6WqbczV+oEivLDQBQwvMOabZOm6S5P4votQmsmWlsARyw3SMO?=
 =?us-ascii?Q?I8GSr9sKdVLQSyeCLjjU3+Xd6ZrFFeZeFhboTKluOrd7TSqjeSRgqSfif/JV?=
 =?us-ascii?Q?a5RBDJcVm2DNbbLZhSRUMOE4u5Lpy5jwe70ZWZfRNMwm+TMNzAH25uaR3w41?=
 =?us-ascii?Q?QJYGEsaaVjXgo3Z4QCeAwNEZS0QIkYLbVdZj0DYu+2dYPG2fF1uEQtFN32LV?=
 =?us-ascii?Q?7U9mofh1cbzBc3rgvj64/sGiTnGcyjL9SW23vnZYFl7aPKwRoJZNsbMYUw5e?=
 =?us-ascii?Q?RPwwIiMSETGmv/qP89TJixx9hMN/kHWuzBU9iP3ySbaRP5w67bRs4XLWF8Q7?=
 =?us-ascii?Q?0wWcL++OxJ1w9Yd2KUpsQSRsl7Kr5Ks7ZqQsjjKDL1kF3bk2Wc/kP3/TxqJa?=
 =?us-ascii?Q?CyIbPbZ6fShIFsAiiz7/Ir1zm9PHH+jnKMJozy6Q7vIB183tUK0T2WuvzaKg?=
 =?us-ascii?Q?0IVWPJw98z5rIxoBI4H0zjQDc1hn2BC7KRVHFA18wnk8xZn2CU6ktZFUv4iR?=
 =?us-ascii?Q?r3G2JAClIWA7Kfgg9iSeT/wU9wtoCO9eTezA9b4C9mTafb8HAJfRd0pNK+Fq?=
 =?us-ascii?Q?dKMuMmKqSecR1Q4H18SPTfg9IXjkLmvTz/dDTZ6+UcQgF0YUf8TS6gpnojA1?=
 =?us-ascii?Q?9tvJke1DN1ppH7oaXg/MdjzHWjYKOWTHrZyVQFul8QA+xxJx3rDOC+jNM3ll?=
 =?us-ascii?Q?j4RIENlHqVyZT2wyNDk5yZafqPT9CVUuBw29zjV4XIOdnTGKr/aorwDo7I7B?=
 =?us-ascii?Q?shb8mSRuEJ51F0Qp5a2XD/pbIeSsjDbm644H+JXkIMbJg/WzmpBPFSmc5jiy?=
 =?us-ascii?Q?nP8glH+ObbPFepuys0YGT5NeKJ54fd7Tq4uMScaqIenMQ/FIKSjMuZY2BNbB?=
 =?us-ascii?Q?5/KMUKbqrS9XXvVIeP7Q4pyOxXFyT2IVuXtZVTwq+M7gEkLOAC/qbTrPyDh+?=
 =?us-ascii?Q?kp/st9vn3iLip6V14cph8+yKlowVTLzdaBmhsnIxku8WAYLC3c/lcoPgkSpW?=
 =?us-ascii?Q?xEScFeV8x6pwDGF+O/sizNncK3NggYcEpjlp+uk8Nh3n+hnnLfLrgWc8bHdu?=
 =?us-ascii?Q?ZdS9+3/fNC62vW5NZyx2hySQzuYpoCQPCzYRSG+dzjyAqXnpYS08nM6F7K9I?=
 =?us-ascii?Q?9+zdh2cNM5IJKuN5Pqt52o1l8ppb3ulwE4Kw5G/6KDmDkGxGmWH8U28RXFU4?=
 =?us-ascii?Q?sl43IPU8qnA4qc+r9PVK/et+ZkCSEPOE5ZnMGVkeNmaTX0lj5nK7AYqsSKTf?=
 =?us-ascii?Q?MSgKtq0fLuRKRshvcBHC3ldM4vDn+xPtrdYG23DYfgujz9SuVxUKskKUWCXV?=
 =?us-ascii?Q?Lw7QFYuw5Ya64/ueV0hmxsfAjqsUPmfRhsBwQXhpI0iSd8aZblmB0OB7VRlM?=
 =?us-ascii?Q?PnQs88OF28VXE2iZJY/ylwxEXleSXr3dyVVu010xPuIRCWzbIcZigsqZjiYM?=
 =?us-ascii?Q?gj/Omw7AaBb8rrmKnEYQxk1/JMcCsZXO57z3mIwDa3uH2iKNrM/8DKAqSJ4q?=
 =?us-ascii?Q?YSEJgENj4evBbfkmrOk5sgOlBVU4aeaqcKd7iv5f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f85db0-51fc-4c90-5d21-08dc693a0105
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:42.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjZ7QG0vBAic+seBuuaAnNyGFZ7Zgpa1OPMBgl+LQIOXCslXAS4g8qeqWuPI/JHa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

CD table entries and STE's have the same essential programming sequence,
just with different types. Use the new ops indirection to link CD
programming to the common writer.

In a few more patches all CD writers will call an appropriate make
function and then directly call arm_smmu_write_cd_entry().
arm_smmu_write_ctx_desc() will be removed.

Until then lightly tweak arm_smmu_write_ctx_desc() to also use the new
programmer by using the same logic as right now to build the target CD on
the stack, sanitizing it to meet the used rules, and then using the
writer.

Sanitizing is necessary because the writer expects that the currently
programmed CD follows the used rules. Next patches add new make functions
and new direct calls to arm_smmu_write_cd_entry() which will require this.

Signed-off-by: Michael Shavit <mshavit@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 ++++++++++++++++-----
 1 file changed, 67 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 196aeaf280042c..3504c25de4306b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -55,6 +55,7 @@ struct arm_smmu_entry_writer_ops {
 
 #define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
+static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -1230,6 +1231,59 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[idx];
 }
 
+struct arm_smmu_cd_writer {
+	struct arm_smmu_entry_writer writer;
+	unsigned int ssid;
+};
+
+static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
+{
+	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
+	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
+		return;
+	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
+
+	/*
+	 * If EPD0 is set by the make function it means
+	 * T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED
+	 */
+	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
+		used_bits[0] &= ~cpu_to_le64(
+			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
+			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
+			CTXDESC_CD_0_TCR_SH0);
+		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
+	}
+}
+
+static void arm_smmu_cd_writer_sync_entry(struct arm_smmu_entry_writer *writer)
+{
+	struct arm_smmu_cd_writer *cd_writer =
+		container_of(writer, struct arm_smmu_cd_writer, writer);
+
+	arm_smmu_sync_cd(writer->master, cd_writer->ssid, true);
+}
+
+static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
+	.sync = arm_smmu_cd_writer_sync_entry,
+	.get_used = arm_smmu_get_cd_used,
+};
+
+static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+				    struct arm_smmu_cd *cdptr,
+				    const struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd_writer cd_writer = {
+		.writer = {
+			.ops = &arm_smmu_cd_writer_ops,
+			.master = master,
+		},
+		.ssid = ssid,
+	};
+
+	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -1246,26 +1300,34 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	struct arm_smmu_cd *cdptr;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr = &target;
+	struct arm_smmu_cd *cd_table_entry;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cdptr = arm_smmu_get_cd_ptr(master, ssid);
-	if (!cdptr)
+	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	if (!cd_table_entry)
 		return -ENOMEM;
 
+	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
 	if (!cd) { /* (5) */
+		memset(cdptr, 0, sizeof(*cdptr));
 		val = 0;
 	} else if (cd == &quiet_cd) { /* (4) */
+		val &= ~(CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
+			 CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
+			 CTXDESC_CD_0_TCR_SH0);
 		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
 			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
 		val |= CTXDESC_CD_0_TCR_EPD0;
+		cdptr->data[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
 	} else if (cd_live) { /* (3) */
 		val &= ~CTXDESC_CD_0_ASID;
 		val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
@@ -1278,13 +1340,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		cdptr->data[2] = 0;
 		cdptr->data[3] = cpu_to_le64(cd->mair);
 
-		/*
-		 * STE may be live, and the SMMU might read dwords of this CD in any
-		 * order. Ensure that it observes valid values before reading
-		 * V=1.
-		 */
-		arm_smmu_sync_cd(master, ssid, true);
-
 		val = cd->tcr |
 #ifdef __BIG_ENDIAN
 			CTXDESC_CD_0_ENDI |
@@ -1298,18 +1353,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		if (cd_table->stall_enabled)
 			val |= CTXDESC_CD_0_S;
 	}
-
-	/*
-	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
-	 * "Configuration structures and configuration invalidation completion"
-	 *
-	 *   The size of single-copy atomic reads made by the SMMU is
-	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
-	 *   field within an aligned 64-bit span of a structure can be altered
-	 *   without first making the structure invalid.
-	 */
-	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
-	arm_smmu_sync_cd(master, ssid, true);
+	cdptr->data[0] = cpu_to_le64(val);
+	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
 	return 0;
 }
 
-- 
2.43.2

