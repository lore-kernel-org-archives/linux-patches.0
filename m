Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C4137C3E;
	Tue, 16 Apr 2024 19:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295723; cv=fail; b=MAswqFEaq7PGLCpY+LAbC6gsXY4exhbi7346h/DZr+GoR/nLlp0HxK866fQPmCFQ9t1c3gVQtbv7FXAWw+FOMZLythqGZ8KsNPtldcpU0AlzZs//WqliWxcla3rEKGdTV8HBeRZjE/EzzTT8CWsIEb2yetBl4RYptwcHmwyEPDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295723; c=relaxed/simple;
	bh=x6OwHk0PAKqJUuS+92961EHxq8Ekv4tJkWfK62ewrtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ui0PqsIbD22vxdKznSwqb8+vnlm3u9cq0Aico26h9irMt6B7Yun0dx59plspbHNOjVS749GwUejkIUpEM3KMh7u7QbMg2U8wu7prCcdqCAQsriEjBEFx5aPYQ0GYWjc0J6UEZf+F2042qHN7bYiyOd2XCetODVAcQOpMzZtnNEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sfnap4cf; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sfnap4cf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEO0EPMIvPXR9r33BfSMQiz2yavseXXWdxezdNz5CDVQ9XDccoKyUHJ27tg/v8AB00ewd/QqJ4E9tPqLYcmFTSqcx7fXbVUoydRYwHfvBP4YOMLaJr0G0v3a5nMk7CWowdiksAdEJB1jgPwk4SI0QqvFAEJZ530KzSCJnX9v0izO9cxADpT6le+oEnxGLwpLHBJMEuzWQhYjVctMDhfTEeh6foE4rIMi6pZDQMRuXE3WugL7d/Mc+m8Wyc3f9HcC7agbA+MprVURx076H3pj6n7xsiW48oxbASJOTtAEYGTcQNJfeFGRBM/n+gGr2vlQk+Da9/9rCmTt+Qup/0K9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOU9y0taWgsvl7bx0IEajZ8bxIn0NmHVI4xahM58xpY=;
 b=DGdXRVN3D3Em4fuhNlhAA3uu88g7JeLnqw/3pIdsLd6L6eU5jCkl34VQhR6/KrsdNMpQYwwyk3y/Nk6fC2RQ/RH+LixXdEpgKPhaIFU7fxI5TrGaBPoZCDHOrcaEYoQ+DsSsWvuVs1Iur4665PNmrgfdh3NSW+s9eD+8dxaVRwxh102CSsursrFXQjBRqqjSpET7hE4ef3KQV2zBe8JX3JlVug2zQoqm7zzZ4VMJG1fAkCsMtY5mnQnxvlt8F4S556yilsv5FKpBMb2yua1FdQpeopZYUHpIxyqgV88AiML/Lc8UYDhWg4+RQ7YghIzpwe0R+VdmaEvgfk7vHEYBGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOU9y0taWgsvl7bx0IEajZ8bxIn0NmHVI4xahM58xpY=;
 b=Sfnap4cfvJd8OA/zD4S/yNje3kJUVEv4wpE/PlsaEFQNS+b4knyf5CIZHOW1HTJjEySK5PtFtqSl1IedP6xYMPHqKLTTpsldbt1pb2DYhOrYHYNkogVh9YBLqAHQy4Ivpbvx3Ll8vUYGIHf2ok3NkvT/gR4G5a1q0Z+RDzkpWrpcxPD6T2DMV3Z9FDsgTCylEdy80JBpfC2CDxJkZbwHplwmnYJnTPn9NQIPFh0AkiF2QYyjoOu8sDI7HrP7iKM1lDDIGWkvaNywpCkM0IKIP0DF1ag+9ibShuIbDpfPlfkcWP4l6k+255eRA+Poo6Y6p8LcEIpeMC4Ui65/OHdpxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:24 +0000
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
Subject: [PATCH v7 2/9] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
Date: Tue, 16 Apr 2024 16:28:13 -0300
Message-ID: <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:806:120::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 93e007cc-a767-4fcc-870c-08dc5e4b6185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bpDbzDFij36Qf5DxX3Kj5V2Ne1nreqiJQ7c78IFyxPEigUIMwJ1thXo2ncC5U6ZgjC3WKIYBJo05vweDEXi6/TRfEKyGsYvdAkM2c62WG1RN1G9rIwjFEZ1grACbmghAm+uE08qXh/Nq3nXYkLTKulIthdj3mD+QAfPbftgIlsWg3OweIfqI7XIUooudHwKfjHn0fSFswI/bFHEUZCuBwFeGg9LNo2ac55606hFZk6TUEDp8WiptTJJIVW3+rQkq6UwkkVtdit0swiNiD5U5wUMRJSEOVrUo4Pyiyu+uOK8w8z2wXp9yH8yEq18OM/yOifMDDY2Gaqjsam7/bR3lBzzBQQiV0LL7WUu3n9r58Fe2Nbmq6y8iD2trTm+t1dCvalSGUXM37qgFXKR86hl7T0SxksXNVjvyRD8q20KNyT01uBtmeIQfs+j6XT2cQfitxTL1NJDsZifljcI2uMClPQGuaH9nr9ydVtzAp0H4Boyj/KQvNmX2KR5hVqoTlpnT7TIKGBhjoT+NP9rLCTbQCKrrsfq63IIjhYqFbYbOtcSPcmyd4jSPYpL9775iUnPNOoG6bNZTvSEV/xxjz2AGKfdZecyW3mRyDjKhumzAxchrRijQwhuKkdjFg2LJynsf6FmO9jQLtcVSv1UwziBjg0wMqwbxORbtF1Dof+ZZbEQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jd1+wBq+VcaBrW8M9mfSjjaYtLLaFQtmYydD+sy0jp/6FQNyy4S+My3Pcpal?=
 =?us-ascii?Q?6ioTIxX5u0LnrphM98kfLhDGSJtHIK4fsj93mmmvMQayGxCSY5jqi1k1X2OL?=
 =?us-ascii?Q?SOlUr33edzovWY+3YSuKra/TTL6V3zK61VuEBcFwfTdGTy499yP5xigSNwqW?=
 =?us-ascii?Q?VkaSVFFRFOFb3sFHYotPBi7sbeaZVpJ6Wz8qiFEFYmufp/Gl8OBtft8UE3d/?=
 =?us-ascii?Q?DTUl1wJ8L/TM80zxU9pFPKzF4z07gRCWhIJrlTRAF1tVNPvIQ27x5dbFKZK2?=
 =?us-ascii?Q?ghA7Yg9iaE2/U/UwibuWCEmBnc3NnrBm7GRjo+adQL4y2dZj+HNruyLud8c+?=
 =?us-ascii?Q?XiWaR0DcWwx457qnW9i7L08kn2ObBlOfk0JaDmHBu2dXErccpOVJntnvaQsy?=
 =?us-ascii?Q?cNJnUe/LcUk+UmDUdLYuQcKYifk1f7qGn78WDLhfl1/+qbHpEBxqwjnc6gjc?=
 =?us-ascii?Q?xkY3Ii/FM7BMUmWY3q3Op6cTWMOZl900vxLvrTMEuFVthGsj2U1QmlEUUfFl?=
 =?us-ascii?Q?n9ShBvwc27KyfxywphAVDgM+asLGFRMh4AmPp4Zucy0btglOTyToBMKmMdRq?=
 =?us-ascii?Q?LWL9UXJRjtzpxdBZQ0lEj56DRLXmKRIv/A21IbD9+SzPT8ZMcvhXn/+pTA/U?=
 =?us-ascii?Q?W3YyX246g30O7FJTM5RlY3fDu3YP+7z4mxOvkoKThc+PB/Dy9X2J8Ld58SEh?=
 =?us-ascii?Q?zsmW5okVTkytqUmHNo6ZTwYV/OQGaoPk1TW8WXKbDLP+WC/KBeRRWO+ftXJk?=
 =?us-ascii?Q?H14MlN4fPPmWn9w+8qM1yUV/1fI5rSmglZa3AUtYEi6RM96pMaxO8IXmX50T?=
 =?us-ascii?Q?WBmLOJHQizRsO6OQb+H5fO8hdKKopIn8ixmzp8mh6J3qWPuVk8IQWXUkwp7G?=
 =?us-ascii?Q?aJ39deQxYipunpGsEIo5iJQHs4ypEXn9WeT/BqochQbsN2Kfz/nr0lOthD29?=
 =?us-ascii?Q?Srw9Wnh/++JZOLBdY+rzRbX0v0FkCa/9Qh9I/ZtUnXMuCIZ75VpLuCfJj+Fy?=
 =?us-ascii?Q?saT6vQhr0Vm5+kmQM6bEmhaPgw/gxymBf+HFUy8/Ppznagh3QliAW+aks4am?=
 =?us-ascii?Q?gmOG2KEi0ra1kp4z7JT9upZC41FmsnjB6pWsIm/nmqgc51r2Ji/XdbqU7F2l?=
 =?us-ascii?Q?PYcxdJh9901dbjEI+/Z6u+9L7HUreseq8lYs0i/lUJHKazTNom5TmkABwRcu?=
 =?us-ascii?Q?Tt0om4JuF4kXJAL/mNSSmHpWMiXTObnRKql2H9/99zhGoq4x2kXGVGn2hC5h?=
 =?us-ascii?Q?JRaz1Fa8RvBnhXlhz2K4pzWtYjSaGljYdTU98MX3W6/P8NFDB98RKHFVvPVO?=
 =?us-ascii?Q?FJDbEI+gAiRdqPFk381X3vyeSYZyqd5KEuqeQ584vWje15JjRcPQXby9OoPi?=
 =?us-ascii?Q?ztG1dHepRDz3lhXYXb63Dh0f16eE4TS2NsXbqTUbeE/wvM3IJphMcwDUzMlB?=
 =?us-ascii?Q?7xOhu78LUX9Dj8Jhpu8m6nJhQ4hsrbhaeE53tRu3L0GRxy84bpNbPAxj+71I?=
 =?us-ascii?Q?+d1hZjJ2isymEepbhLsHip2BNmF+aNZSjj3GdjdX7sbPhdXJYXzyhXpwEw2N?=
 =?us-ascii?Q?F4f+0Lx+Wk6839UQaXW4/zOvY/wddb7clQESJfru?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e007cc-a767-4fcc-870c-08dc5e4b6185
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:23.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etH6iGvtLLogTtk+yaU9oFC2hPmbFf5vmyx6cV9+GENSNA1L1y6WHdqNtbGEKbJ/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

CD table entries and STE's have the same essential programming sequence,
just with different types.

Have arm_smmu_write_ctx_desc() generate a target CD and call
arm_smmu_write_entry() to do the programming. Due to the way the target CD
is generated by modifying the existing CD this alone is not enough for the
CD callers to be freed of the ordering requirements.

The following patches will make the rest of the CD flow mirror the STE
flow with precise CD contents generated in all cases.

Signed-off-by: Michael Shavit <mshavit@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 94 ++++++++++++++++-----
 1 file changed, 74 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bf105e914d38b1..3983de90c2fa01 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -56,6 +56,7 @@ struct arm_smmu_entry_writer_ops {
 
 #define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
+static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -1231,6 +1232,67 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
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
+static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd used = {};
+	int i;
+
+	arm_smmu_get_cd_used(target->data, used.data);
+	for (i = 0; i != ARRAY_SIZE(target->data); i++)
+		target->data[i] &= used.data[i];
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -1247,17 +1309,20 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
 
@@ -1279,13 +1344,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
@@ -1299,18 +1357,14 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		if (cd_table->stall_enabled)
 			val |= CTXDESC_CD_0_S;
 	}
-
+	cdptr->data[0] = cpu_to_le64(val);
 	/*
-	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
-	 * "Configuration structures and configuration invalidation completion"
-	 *
-	 *   The size of single-copy atomic reads made by the SMMU is
-	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
-	 *   field within an aligned 64-bit span of a structure can be altered
-	 *   without first making the structure invalid.
+	 * Since the above is updating the CD entry based on the current value
+	 * without zeroing unused bits it needs fixing before being passed to
+	 * the programming logic.
 	 */
-	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
-	arm_smmu_sync_cd(master, ssid, true);
+	arm_smmu_clean_cd_entry(&target);
+	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
 	return 0;
 }
 
-- 
2.43.2

