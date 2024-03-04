Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8FB7D3EF;
	Mon,  4 Mar 2024 23:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595879; cv=fail; b=QnGoaen2Iwb0ksSdFbvsvK0HJbOoh/agYRORWAf7+mjkfQhSFU1dfgwBwhjN0a3UGhsJiI/Ur63y1kiKjvIL8cx3sedNbElKwJCVmWzvZY7tbAmpJfQY+peHuCnCToE+fJOzPexEUCk7OwynLJ+WB6m0l3w/m3Et+5dbiAwU87A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595879; c=relaxed/simple;
	bh=tdn4rviUd0SccZkL80Wgbnnrn3IVyhvMY6L0jbvGr0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h8dNVFUh4F2kuNSIWq6Ln+48Q4JuUYLUPQjxnWlvxRXry9MPT4HE47WwJazhNv51gVBSD1fGwNGdy7TK2N0jV2yKVFyBl3cIrA2J0rbLzmI7g11z6dhHO29DT73ap2gvQxQti/tNAi6Nr3smTcgyii8yWGsBJW0LoYK+svR3/+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=URF1582w; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="URF1582w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlP6N9ZGru3xc8Z52UlA92/1aWlFrB2jNSPOW/tm/yq+nANEGLcrBSNDAV+jscbc0mgNPcD+UHQmQh/bRUYPwq8J+n4hSAuZK9MY4NKKwv79kgdZIz3BLg8LtfQrPrVME/Nf4cvYqg5bcb4Aozn1i2Q48Eb+xC/8Wn4cRZR9KP3JM6cBMqV9vwKidCGgrABKbAZ7osRMR0tZSVOmMM3kpfR5MmRX+Asvao6bfIpUotlveZPYrdYkghq8gGXDNgmBRYm3LMkoH6CoHbf3UtU3WAhUDjCvOzVi1jo7iuADUv2J18FgVNrhaDgHhYWKq8UWk760xNpg/KD1+ypejsb6yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dM3axHpkFBC/TBzyBeaVwI4FrKRtUW3DwChFeh3ASk=;
 b=Ntmomwcd9AQ4P9OAtWYYwgIz3I0ZJB7a3lMMdNK5tXWg/G06TP3xAlC9Ah/KFQCGxnTkFHPI9sLV8D6YOooeXy3z2pua4EuGASZfuoPleyvgWJPKGQpqfL3gWWZB0Bamc6Q3AERWooun5aYchZ/A8ex8FAUkPXiSerCPTC98PLBGXv4cIVdP8sszdrkc6bjg8vszWnYAi6bZrq+odov0ktCqlSTruerHSikqS3jANgirQGfFwJR2b88OpOVnvOHFuAwnwHFq/cW+20dNeMoT3SmYqkJmPwg15TkTml+dvFZbPO5zgZFXvG06+6LNf9u/GgcT4W4IZtmG1FSOt11TOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dM3axHpkFBC/TBzyBeaVwI4FrKRtUW3DwChFeh3ASk=;
 b=URF1582w/SmdM8V82x+9GsqH1t3WaA0bfyhzRfGfsD5eTI3f4PdlkcxWuqofyKQz+s+/0cVrtW90KtnyiE8wAoubRWl2r5i0QNg4bhQH0tqkWllksbpbvEkCldRcXaczObiea8s6rqHdzHuwKygjH/XAIlWrB4Hogb+SaCgIbEIczkXNgRVke1n1SK+uZOD6t7TMeplwdtS90r0RO2eJ02qlbNS6D5dM3FhnFalbIfe+d4W5HZNdgO9J7HaibnqQxZW1ft+napeaUPFYpG6K8cPWkVwUn4pWvvLkJmqmcO49LiMEqpf07Qcq02d9+EwS2oeVBv3qgKsDuEcqVpREag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:25 +0000
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
Subject: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
Date: Mon,  4 Mar 2024 19:43:53 -0400
Message-ID: <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:208:a8::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 458e0238-4ef3-44ef-1b57-08dc3ca50223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z8KCWieEy7n3NrMiF3zCXII1o/Z9RabLbu9sLWOywjWBeG5le1bIMykne2x7j295uw4m52pTL88Q3MiVeGE7/hBzORZ2BgF1c/icC6GhtKLafvqEn9/EViln7Kuu66kZiqHvlbmVw7FoYgjJ/l+KebURBTkEq2sIsKjyaxf2jOErNbslZveF0vv+w6UDJJsCp5t/J7yWT81xwyDY06yacVK40CvsU0a7zhpVpvi4cwkqDGxaT48FKd1byPQk/0H7dVKU4MQ1mPR4b/X5Ohe9Ob07VMitqE44WeH4IPEeU4acsFy3l1ZUK6e41gRX00+4vsthGVbyyZdCw9mXzzdSWrHWLbJH3oaOwid1fx5LM/9nCCVpovcpBJ74sf7H3xvFzAE+2MYee7BwL57nLiGD+aeJqIT2VyQY1OsxrAHs9Hkx3AbJCk4fc/obP3DzfNiBr57ajYnzsGo1xLs+sSUq1P0gMLFPModGIjfLm8hyxJ59VYrku4SaQuD1ptgbCsc6pB0mIJiC4U5WM+VQwF34bft/iL7TJIVFjUnOdTHD3Mg+nHnIrg4vpL84Qu4IkBbIMnIbkAlECKtpheyX3oWLx4FVBdlY8jSR1Havec5QBOwaec8DvUetXFPVb0pCWXAV0qSFmKEuiRmm6NRUc+Jurtb84Ge0GUvw7CpWmA/bmZ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7lcj9lZ5Sh+HJCK2fV1+FI6BcQpDgsszWBmBVv22AZb+8fw/FHMy/A/CFHT3?=
 =?us-ascii?Q?SaYurrQeDRg4fqWFeKAStT/Kp53cd7gcG0UvLbIwpr2CI/j4YabDy9CGzhCh?=
 =?us-ascii?Q?Fb0GbY32o51ZKBoC7Fv3wL7hkr2Qgg3AZcMsTXZeiec073y33i+H0oe/70/L?=
 =?us-ascii?Q?Tq/+d/HLDCFddHIiDyGm2vbxO+dBHaZFLcvGX7NcG2bGvqGeQ1OZuKWGb2dd?=
 =?us-ascii?Q?dhVSk/BK9bOf35QjXgbAMfa9qRZScbfG4jz1vpsm10JW0l0sjYhaGkBqYrOk?=
 =?us-ascii?Q?EbnmHtIzxQQhmzBRSeu5WplcJFp/ut4+wy1VLWam4mkg7pviW/1bBQ7A90v0?=
 =?us-ascii?Q?2wX+9Q5uePIjfZn1ZVkEo8MtPhxfU+pzi4szs4Kwe5hF1HE5LTQbZrpOd3aZ?=
 =?us-ascii?Q?wMMoJ5WvnaXd2u0TxQRuQFQOA0TtbOVlsfreqhaI0mnrdlqnobz8vGllSFHK?=
 =?us-ascii?Q?kXm1SfndQ9d0/AHv3tmuSETFRfWPkxcdLv2Hs1vsi29nmUb8aSfiRDzqiET8?=
 =?us-ascii?Q?hwt5fflw93MY0NiSw9aQHYQCnmZpWf/WaOmeMepyMth9VnYHIYbVxhr9py3G?=
 =?us-ascii?Q?zQcz0TMz80oBsV5oQNffOl30HL4ZvkZ8F8jP8XZQ4W7HUnfjavfIn6VcQxEY?=
 =?us-ascii?Q?bOvEax7R6Mv0u+4OLsr1bMa8VrAghMNC0DNZboxGSrXakdK2DjTNXxVDK8Fn?=
 =?us-ascii?Q?heIvK6o2HUU1lrVAGNxz54oayP5ayI2M66AaDpgZcnqBztPeQX68AuDlsnOh?=
 =?us-ascii?Q?UsbTweXuAWb+LpLI8egHsTWi/wFepjPXT7dUCxL0syoy0Jb4EHLOjdsXL7c2?=
 =?us-ascii?Q?xUmnxVxWOlgOXhqCRbROWRA9B6ESe4KhUzDvARAtMEFdiWCHggSlq5OKj3XK?=
 =?us-ascii?Q?gAiVy53DLtfUdQ6A9dsDfl3qDbroe+mpwjKs6ALSoDgkN8ShPMA48P56lAty?=
 =?us-ascii?Q?fVXjglDeJA/fsrh3BEe+nk6tzoijX7VX/6xrDQcNz9LqtjvQ3bTKKt8XV28e?=
 =?us-ascii?Q?5Gu2eo8zkgxO+LvSmsfdwGJFKQ+CUBXZbSsUrtQZb9Qb6pFFoV3O7iLN7qGR?=
 =?us-ascii?Q?DbteE4lHM7u5MkJy06jiNMjrR4/0Dfqnbqqj0Yn7I4srCn5MQ9TwY2tnPfqG?=
 =?us-ascii?Q?UV6cGzFXWyWLAW8tVgrZCWyrsnEN4t78Oi7s9OiliUoMs4jXibLsf8nXmSFZ?=
 =?us-ascii?Q?okHA+zWWwLlGc7ihOk+I8grRDPYDlvmxQh7GL+Ccrz0zK0kZpCwyAObHv+W3?=
 =?us-ascii?Q?F5F37X9XRwSVqb2i9a9qZ9j5/v1LFAd6hetbT3Fr3TRPwjM3RH3UhGPDlhFW?=
 =?us-ascii?Q?+l6CvZYySBVMRHqSlcQK6v+9Xirkj3frgKJFXA/S7X/atJdoikTOYGZb9Q2V?=
 =?us-ascii?Q?X+zY7ZrajFzbJmgifXdkXd0kJu3XHeoMF6u4ecQawVrThy+xJr5RmGw/DHsI?=
 =?us-ascii?Q?M79NGCnEEKPtCV+wrjyG/2ifL7SVtrk8JKVEPebaHjZPtvyTSf9KtmALLi7u?=
 =?us-ascii?Q?PrvvpGRfT3rrdn4aA3HwA8K0fLRjWW/qDOVV8gDtAvZAUaa4oEhgjUQT2+iv?=
 =?us-ascii?Q?v8Zplim2S333dzR1FqYs1UV8dzxByCpl5kZ90P5E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458e0238-4ef3-44ef-1b57-08dc3ca50223
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:18.3674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hj1ikY8WD48OwQbU9sRriyl4eL6TToqDTs/vYv5XOWr/w/zpNX0OEoYUZd8HmU12
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

CD table entries and STE's have the same essential programming sequence,
just with different types and sizes.

Have arm_smmu_write_ctx_desc() generate a target CD and call
arm_smmu_write_entry() to do the programming. Due to the way the
target CD is generated by modifying the existing CD this alone is not
enough for the CD callers to be freed of the ordering requirements.

The following patches will make the rest of the CD flow mirror the STE
flow with precise CD contents generated in all cases.

Currently the logic can't ensure that the CD always conforms to the used
requirements until all the CD generation is moved to the new method. Add a
temporary no_used_check to disable the assertions.

Signed-off-by: Michael Shavit <mshavit@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 101 ++++++++++++++------
 1 file changed, 74 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b7f947e36f596f..237fd6d92c880b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -57,11 +57,14 @@ struct arm_smmu_entry_writer {
 struct arm_smmu_entry_writer_ops {
 	unsigned int num_entry_qwords;
 	__le64 v_bit;
+	bool no_used_check;
 	void (*get_used)(const __le64 *entry, __le64 *used);
 	void (*sync)(struct arm_smmu_entry_writer *writer);
 };
 
-#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
+#define NUM_ENTRY_QWORDS                                                \
+	(max(sizeof(struct arm_smmu_ste), sizeof(struct arm_smmu_cd)) / \
+	 sizeof(u64))
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -1056,7 +1059,8 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * allowed to set a bit to 1 if the used function doesn't say it
 		 * is used.
 		 */
-		WARN_ON_ONCE(target[i] & ~target_used[i]);
+		if (!writer->ops->no_used_check)
+			WARN_ON_ONCE(target[i] & ~target_used[i]);
 
 		/* Bits can change because they are not currently being used */
 		unused_update[i] = (entry[i] & cur_used[i]) |
@@ -1065,7 +1069,8 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * Each bit indicates that a used bit in a qword needs to be
 		 * changed after unused_update is applied.
 		 */
-		if ((unused_update[i] & target_used[i]) != target[i])
+		if ((unused_update[i] & target_used[i]) !=
+		    (target[i] & target_used[i]))
 			used_qword_diff |= 1 << i;
 	}
 	return used_qword_diff;
@@ -1161,8 +1166,11 @@ static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
 		 * in the entry. The target was already sanity checked by
 		 * compute_qword_diff().
 		 */
-		WARN_ON_ONCE(
-			entry_set(writer, entry, target, 0, num_entry_qwords));
+		if (writer->ops->no_used_check)
+			entry_set(writer, entry, target, 0, num_entry_qwords);
+		else
+			WARN_ON_ONCE(entry_set(writer, entry, target, 0,
+					       num_entry_qwords));
 	}
 }
 
@@ -1242,6 +1250,59 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
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
+	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
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
+	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
+	.no_used_check = true,
+	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
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
@@ -1258,17 +1319,20 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
 
@@ -1290,13 +1354,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
@@ -1310,18 +1367,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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

