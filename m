Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC6236D;
	Tue, 11 Jun 2024 00:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065894; cv=fail; b=twA+uz7Rk5t47QeOAflcTH+TK1PMCQ1WMEeYsnHIFMs0wT0KeSTnPgALAm5ZoRdVU9RrQ6YuFuGDoWbZMZ89LsGoLZOFusdm3PhPfd2fv7lHUSd1R4JKACFqOY0ZNOvwHhohE7mjr8Y3/bpDwvfkRjdi/FCSgVbmfj2R9QLtBnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065894; c=relaxed/simple;
	bh=fkzKJns/4GCrl4nQAWUJVIUK0KT6l2HeDaDUd9z/8Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uLKgqxOMGkPhmI3lLPu6yglLgHAl/u6iYRPaTSvnlyCjytoGt8oX3EHBCaWlSqxjs2eoZ4wllgx5H9wGaTZy2JQXG4KPzKjfY5k4Zd+yESbFe72qCuJqJeAMnVxaTGriOhMT/oLOmTXJ7ZrdZpAkFVT4kHPa0tn1Fi6WWIbwUTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GgvJN/AQ; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GgvJN/AQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3wa5WRz/Am+oCObsEbARwUOnS8upmmnY6O8I3lfX0U/CMmxfKynk2UV6+i/SU1MUEe1xeOWh+6IGEMvSMuEFC7m3k4RNYtBpG5TTh/IX2rpWkrMOwvGysEsVtMLuCqjxpJhKD0ojmL1uw/MLRxUxOuI3H5m+iIoNrON+jqNF+2wySEwRRRGMpJKJBo/I8HosqTHbj/JM6B6x2DkWnSoOBePrHEnJSo3Ww99qUBTqQ3ojlLmS1vdvufC3yCakHZsZQKP3CHJJGVCL/3kZCM48CU6XlMD9iyNAtqsKMLM4jed1UFrqZYnJOOybvI2skhERfXD9b86ApUMlXX2EjYSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGBoX46GEwVxp49l1OKu7+S0xbj6faopuERfQ6HizIk=;
 b=idDx8jy0TevZ7kGWN5mAYsVsCNFv9wS5jThwRSfpGqvHaYBjK8QQKppPPLrfwTtjX3oc/hfQbjd+Izyu7r9W3R0VnWWpfTDAJyNTNsTAel6Z8z38/aSZZCrbIOd/2IqL0jrrfe9ChiMOKPnm8lEtO5kcshBpigubTHOAINue5oCmc/3PcxgieOTFfCuOmg+RH0MuxhcJUsVm/ampoRbxEFq7tWKg7qGYIVhIfT1Jb+FivLbKlmioN/H4kNFehBVCKNS9LKjzLWNBvUMSmWSDbSbksXgftX4tNUesOyQTjVzUdm793RlzSxG3sQ4MfcnExJslkcYWGV5xXhSMNOJGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGBoX46GEwVxp49l1OKu7+S0xbj6faopuERfQ6HizIk=;
 b=GgvJN/AQB/XJ/ziYABbaJpX1rKhpKpcpppBAhKwarKdAhbcJPVu/oYIatGqJ59tfM1Sxw/qX1jSV7sq8RXsHgBtdCF1z6DLgQIifwsS3GEBsuDZIesnHRLkkxXE4ksqmrmvu+0u4Ez8mkwrYGIWWOJnwurB1GjQBCY+3pVkoE0lYJ9QILSzof/v560DvRKf0WLJvhHiF1HqrTU2MEUNGsoBak00s0oLhrsDi1GA8PxgmpsMUdiYWpWXTgkOGzT7pBGxosYgWtmUYNxas0g2VK/7h0Ec7DZnUiARN77Uv6SOObio05QWLXR6BJTwN916XDWzhu2Qcw503bYpiC9rnkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:25 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 04/10] iommu/arm-smmu-v3: Add types for each level of the 2 level stream table
Date: Mon, 10 Jun 2024 21:31:13 -0300
Message-ID: <4-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0015.namprd18.prod.outlook.com
 (2603:10b6:208:23c::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: e27f5516-5a93-4a06-a931-08dc89add18c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/8bVC7BgDfG7PBkdqKuxKftyEOY/D0yjpUx6ZD/o62/mP8feo1usddaiXJmr?=
 =?us-ascii?Q?AjrYN4yAoGsVsQF3sq9Yc57QLCwntEgPPCxpmxp6aB1cRPaVCSXENmkousoZ?=
 =?us-ascii?Q?BzV/34ciTRK0+yx3jcg4J11j6yEiWLBWWxVHu8eOb5C2JzRIv9332mVHsRPk?=
 =?us-ascii?Q?3O+ooMskGr0uRtcHEgstMaBPM8jCIRo21/SXeNMrbvFb6yxtTp4LNjFoTDGT?=
 =?us-ascii?Q?yquUaJassjniNNUhVZLe6CvAOKSs98zF1mJdFCySOqo0lfAtC4X/xga30dLA?=
 =?us-ascii?Q?2Q3Ybr/hFooAVDR3hFnSCRT2g63vQf+8QoQerSICgq6n7/Z1+omv0Xah6ddd?=
 =?us-ascii?Q?Z+sRyO9cgUWNeMX5w2Jn3FlQGTJRHMM4RFxhcAsNgF5hSlbPBJ7JrzVoI6FI?=
 =?us-ascii?Q?r47dKLqAf3kJo8fysVBAOB4hfgGG4+XpDbgtzRxg+3A1Tm/GCqkBNtA1B3lI?=
 =?us-ascii?Q?PzUbMsVNaiNqe5rRrqC5NWSEZYEh9/iMTuiwic1I0G2TDcxWGR2CfW/vfvcl?=
 =?us-ascii?Q?5bU9BgSZcUrlWxg9vV0b76xNWeQLZw4MqpkSTuH/gpY6Z3VHlLQfn3hHB/au?=
 =?us-ascii?Q?0Ffj/eBmhpWzN5Bte8L3bL7j9B1YGwCWUDSp9M+7IWPT+GmW0TEQBYVU4D82?=
 =?us-ascii?Q?/kX8H/EJ6vbuQbP2qDLsDR5oMb63sJ+yruRjGmUiBjJ0jcHjBMMINw4H6K/I?=
 =?us-ascii?Q?QQMPHMyDZ5MG/NK3m5HcjdGWlogkOe5Qy1lCgboxmnl9vwchSp2QUTDuccld?=
 =?us-ascii?Q?p+zzXeN9n+35+n6ikOEhVXDRudsKGPc6rd5nrsJmdQo+SxuMFdRqelD6C9Us?=
 =?us-ascii?Q?qDSkbvFbglnJ9IpcCL0DERMeAQV+ysNylvUUD3A/8h9gt32xpsSbVZvrV9AX?=
 =?us-ascii?Q?utgHh01vH0PgoSwttx+t1P63ADiZqkEkRSWME+m0j4qdZACEnNktwkDtYwcB?=
 =?us-ascii?Q?nxIZPCmTbaTvaJtB7sxmrHQ8YEeY9gpKu5UaBp4nxjZD77g18v0tp8O2KrUc?=
 =?us-ascii?Q?J4LCnOLWyKJf+rCHYdEdVmw5v/mLNdruJ5/JTZKHR0Vb5dGm/pQZmSczdupo?=
 =?us-ascii?Q?VF1uIpmkyC7p683TN0btHrtmD/f52lRsmnwHWu2xaQ3qbEW0znbzwewziCr1?=
 =?us-ascii?Q?aReL224XRrBnB82EHg5MoNwEzMj5yvNhS25PZg2ehvmfIPXQ2FFzqTrvX6Pw?=
 =?us-ascii?Q?k6HznKJgd6FuulJqSwY6T7CqESvbRh6tymewHgDAcMl+NUN8j6005uh9sivs?=
 =?us-ascii?Q?2A8FI6M7c9cRTXFwAfYa5hsiWoL8N8j2oUqzyZWrXhz/9OItq8n2IKSdCiVq?=
 =?us-ascii?Q?fL/0xDEethYhavR1lV5xXUY4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fjnHJmLq7fZNAJZLkWYJktP5SjXXTK84t2N4Xlp/VHTfmbQZlfjn3qE0ffwx?=
 =?us-ascii?Q?x0e3PqzbQv69RnHCEtygujtuplReJw6jZaPvQr0Gg6VCITgJFUi8LbE7aMTD?=
 =?us-ascii?Q?1Iex+NFVMBF9IArv81WmaER1KLlDQge2lDKsQ2jqYSehX8Wn+Y3l8exkh8P+?=
 =?us-ascii?Q?hYNmojmmKBdaReNC/8klxwRTl9njJlSrNSn20foQgjKXzTU9bwKZt0AkPesf?=
 =?us-ascii?Q?ASs0q8VHEs//CWzq4YLguxSPSQURbGYWGp967S8oofRKdXnjU6OT+X6t/L4o?=
 =?us-ascii?Q?pvDuk8zUbne27CtkwJE7OZrLG8ZRriFP6ZMU4dWfwTkPMnDUKZiv70vLDSEv?=
 =?us-ascii?Q?Ax/t+3ws3+yslk0dOuzXY/RwxuVfkxK9uTwnkoHKA+B9EHQLj+oazwpfXjZm?=
 =?us-ascii?Q?P6II9KJ64/wKvFlxjp/4wc/ak50/BamMjZL7+in1HqD4actj0mBACsu9kyHu?=
 =?us-ascii?Q?phqsctpj4r27vLbRJFu/aTF4SoaGmya1BeRtAJT1VmpXW+XhHaZ9SL9inxM0?=
 =?us-ascii?Q?nk8LEDOJz8snqziBlxggYwmn4toJzMffJxMCF4DFNcyUxtv9ndQDkxZptV5G?=
 =?us-ascii?Q?hzI2aY9+IOujJk2RdAvyCNb1F/W8ziF7NmXJtjZiauZxVboNPu1s87jQKqM6?=
 =?us-ascii?Q?+IIsNI+WVE/a8XEh1upsajvHbCFio5QNCgtSuWdVdLvOf0ZaeLmmYhEvGMdm?=
 =?us-ascii?Q?iIbV36U6p/wdP4rfu2EqZDlCHKyZWZ8F4/lqispO4nLsFvs00lvh7bDtQu0I?=
 =?us-ascii?Q?+Dc1IY2Lc0aKSVskZpuao0w8dMXTlbDlpkd4SYik20Bua2JEYkWE8/wgfKLT?=
 =?us-ascii?Q?iLuLQ54p3X5govuK8I2IMcUPXjGf+xlUDregABHcwozCbSqodf29ahxMHz+i?=
 =?us-ascii?Q?mLzs1EvMW0wOwi9XFbltCBLKAb6nMlb2MONaPW89ermROkaSb4ROFdLrXYpv?=
 =?us-ascii?Q?NKoC0NcEO7ERmgKWyrVDjOI1f+OzvbALeEsNrulYN5Rfhpstyl3QSePRehvj?=
 =?us-ascii?Q?mtHISeEOxpIIHMbNo3WQa60mz+TYevuh5jt46jr9jbPiGONLXobH4Zpw5HWN?=
 =?us-ascii?Q?hvFAumPe78fR/XErYVPaxq+G7/VOOj/vcjC7hOh+8lhcVjaz7QoBap7GqXcG?=
 =?us-ascii?Q?Dx9Lyr5JN5L7V/9yDYWblPlDS2g49wXWNuq4/ojGomMQ7R6Wr36Qmf6+95lT?=
 =?us-ascii?Q?JjD0h9Px05aqiUhqgwqruNANgHGvbuWIoPLHsPq6Cxq8NcFMrDcGwwYFdpL2?=
 =?us-ascii?Q?RWv6R6lRSSIEc7Vxpyu8cc0YRtGyJXq4C58o+5Oq2rUGxilhJDlt+UBXUb7A?=
 =?us-ascii?Q?dV1GIEfI8lBgVIoyNi+mbYlbiCW9m8eQFJmXVw5RvTpZxbOQzQqbDAAEx0Af?=
 =?us-ascii?Q?hIs3CZvkOvNhbKDstmrh1j+GWW+P4038LCaMXSe/tjdhflXmMtTZ8Ub16IDG?=
 =?us-ascii?Q?pMgo6o7r2auxqEjg75kiARv0GLN0s3OBcDFxE7wH6+TRpOuhwSTKPabwnnfh?=
 =?us-ascii?Q?V8iftvJpJETqdXCGBVx7jYtYZ/Mb6bhYr1CChk39L81eitcxE6kB67wuY/Wv?=
 =?us-ascii?Q?9FtM32LJKtv7miQZ8w4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e27f5516-5a93-4a06-a931-08dc89add18c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:21.8763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IeDmoA27rwN2kfFm1xxAy9+U6rUW73ud4Ek2Sa8FmylKg8X97CzEuRKj+xP02yio
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

Add types struct arm_smmu_strtab_l1 and l2 to represent the HW layout of
the descriptors, and use them in most places, following patches will get
the remaing places. The size of the l1 and l2 HW allocations are
sizeof(struct arm_smmu_strtab_l1/2).

This provides some more clarity than having raw __le64 *'s and sizes
computed via macros.

Remove STRTAB_L1_DESC_DWORDS.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 10 ++++++++--
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 07b797ad832801..6643594121a2b2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1447,7 +1447,8 @@ bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
 }
 
 /* Stream table manipulation functions */
-static void arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
+static void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
+					  dma_addr_t l2ptr_dma)
 {
 	u64 val = 0;
 
@@ -1455,7 +1456,7 @@ static void arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
 	/* The HW has 64 bit atomicity with stores to the L2 STE table */
-	WRITE_ONCE(*dst, cpu_to_le64(val));
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
 struct arm_smmu_ste_writer {
@@ -1660,9 +1661,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	if (desc->l2ptr)
 		return 0;
 
-	desc->l2ptr = dmam_alloc_coherent(
-		smmu->dev, STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste),
-		&l2ptr_dma, GFP_KERNEL);
+	desc->l2ptr = dmam_alloc_coherent(smmu->dev, sizeof(*desc->l2ptr),
+					  &l2ptr_dma, GFP_KERNEL);
 	if (!desc->l2ptr) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
@@ -1670,9 +1670,11 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr, STRTAB_NUM_L2_STES);
-	arm_smmu_write_strtab_l1_desc(&cfg->strtab[arm_smmu_strtab_l1_idx(sid)],
-				      l2ptr_dma);
+	arm_smmu_init_initial_stes(desc->l2ptr->stes, STRTAB_NUM_L2_STES);
+	arm_smmu_write_strtab_l1_desc(
+		(struct arm_smmu_strtab_l1 *)&cfg
+			->strtab[arm_smmu_strtab_l1_idx(sid)],
+		l2ptr_dma);
 	return 0;
 }
 
@@ -2411,7 +2413,7 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
 		/* Two-level walk */
 		return &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)]
-				.l2ptr[arm_smmu_strtab_l2_idx(sid)];
+				.l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
 	} else {
 		/* Simple linear lookup */
 		return (struct arm_smmu_ste *)&cfg
@@ -3224,7 +3226,7 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 			 cfg->num_l1_ents * STRTAB_NUM_L2_STES,
 			 1 << smmu->sid_bits);
 
-	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
+	l1size = cfg->num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
 	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
 				     GFP_KERNEL);
 	if (!strtab) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 95c3ac8613da79..1418f21f5db6a0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -201,7 +201,6 @@
  */
 #define STRTAB_SPLIT			8
 
-#define STRTAB_L1_DESC_DWORDS		1
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
@@ -212,6 +211,13 @@ struct arm_smmu_ste {
 };
 
 #define STRTAB_NUM_L2_STES (1 << STRTAB_SPLIT)
+struct arm_smmu_strtab_l2 {
+	struct arm_smmu_ste stes[STRTAB_NUM_L2_STES];
+};
+
+struct arm_smmu_strtab_l1 {
+	__le64 l2ptr;
+};
 #define STRTAB_MAX_L1_ENTRIES (1 << 17)
 
 static inline unsigned int arm_smmu_strtab_l1_idx(unsigned int sid)
@@ -591,7 +597,7 @@ struct arm_smmu_priq {
 
 /* High-level stream table and context descriptor structures */
 struct arm_smmu_strtab_l1_desc {
-	struct arm_smmu_ste		*l2ptr;
+	struct arm_smmu_strtab_l2	*l2ptr;
 };
 
 struct arm_smmu_ctx_desc {
-- 
2.45.2

