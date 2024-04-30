Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D680E17F370;
	Tue, 30 Apr 2024 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497714; cv=fail; b=G9x9u4CrhbDdoV17VVyHfKzgD752FYbn6WEXNHU/ShF4nUW8gc1vPdSxkFDfLJVxDpJC+uB5QcW4mNEvE1jd6pDQ+tzQqqGOO68ktSJa52MCaVAzqUuu3WPMIE1ThIRjGFI027sl3jBmX+88GjsaWmMu2cBXRGvb7MqY2B6eTBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497714; c=relaxed/simple;
	bh=Q36Tn0kT8dQc7iqRzlBDJ7xayL1Rqp9tDg66uNxC3C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JsdSMiH+a/wlTS185lsUVXfxvl6CL+2S4z8UmAyzVwxTYK1KlJ21qKP6EyNl64EKiLwIz91UQOeVb/qWBSl05gjlwVdT3EHv9yyf2lR8U5F4nC1SUX+tcsiZPnYgMd7cExUo0qh3KH0BVAWHHOWxnAargtO3h/GWMu3cr4s0NUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G+fWmkOu; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G+fWmkOu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqXmDn8Gk8ufhFSkbXJMsG0ftkOadP0BxUYd/FhdlJgJ3a2puAN8bYMo37gEhLkAtAXoShNmkxG2cp3gqLOdiEi4GWULT854FNrb3nTioYmGzUBHGE1w/bFgM0A4EQ3Kg4MV8CkCFRR/nKAhsR7WuetKiiwa3WlcudYxf4Am+SQ183VAUn3XjCTwntFQr+xp32I0d3HOa5bR3B05Ykx7egWGw10wDGREVbNuaeqOAjYOpQbYKYHt5AUy9avlcx0TtNdxLbw1bOAQ8GDCDYN/h27Pi97xHigWEkFltYa8fBxmusCBi1kDLoTvBsgtAvhXKd536EnrK+Evjf8iL1S3Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NXyUR/KFc6V0DsyTcvLnSk//4Fu7kVY7vCq8LiQfQk=;
 b=fQozcMziF55X7hauoWL6pZLm3fdyX3fZXvqeYp9Gst0sCzsbZ+LlNroH7cRhAijaSAe6Wd2vlZJhAut3nwkOMRn+e97slonMgaIUjgL995f3+5EYsjvhZeEEHrBd38ss6XHH+Wc+Dns3Fm9KaGG2jdLJCBFifbm8YRQx1KhIPIMl3gt62ChxE53S9DC0eHTyajBpCqZ2tZ/Pt+VgA1jOH8+YbiVrQHCibDWkp6GRFGU4rrw1abW3vAJzOXZlZ8NT9HUzlwCAnQrAOQ5v6U1V6xCwXGD5noCLfVvFV2fFGqe596XmfF79Js9uow0kc+GbyTW2U5+LtCoKbmi5cUVjxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NXyUR/KFc6V0DsyTcvLnSk//4Fu7kVY7vCq8LiQfQk=;
 b=G+fWmkOuYAzTBnXubFp5ASXtswAFQFXXyR7p1Zv9cOhK0ENgLq3JefgzTjIdtvUhb3s6x7wHrcI8yW2r/FYMXq4j0SuY7zfUhXkiD54VrZr9GdqBfoMb+sk+wiY+Rn47NdfaNMtm+o1x8B1lC3mVrVLQoEM2G9Plb62kQKPmU9HNvKRa0DvnzgDzEi8axgzhKKt7zZtfSOCfI2PU6bSpupZeah62mEkB8OK2UVuhrCeOXmn3MepBXHsM9RGFzwSQ9GjVr+rDSl2giV5mUKHNQkAGhFCsi1puR5m8V/Zwrjn4Dn0GXncmxKw7DChvjUyUDzYzT0MiNPj8nobHeo2+AQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:45 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:45 +0000
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
Subject: [PATCH v9 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
Date: Tue, 30 Apr 2024 14:21:39 -0300
Message-ID: <7-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:208:32e::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 9444d65a-de30-4862-7d46-08dc693a0126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xvXGF0En2MmDdaEYWYO5EAkWSJA/OTiPHGE5oxmRrahhyuuFRW5FJ9E1Xj8t?=
 =?us-ascii?Q?RKRwBOwXW846jY0hAy48Hg+CiFhs0C6wgSwUIA5d/jdaW/OXr9KUYvbNVgUF?=
 =?us-ascii?Q?5P3BJEiTw9qzyyocQnsLHnLQIN9vWegbi3Rjqx5Xzc5b95Z/MXmVcaQJNVL5?=
 =?us-ascii?Q?F7WH1bdDMiAhCWZw7RPmEYNvHU8GSKGozAALo3bnNh4ehSC/nUrafYYo2wkN?=
 =?us-ascii?Q?VFgdAv6R4kR7crjHPPzsnDWdg7L5hLKvBbtr0lWJhRmFAesRxna8qhWUKV6c?=
 =?us-ascii?Q?sIKEbpKg9KWxfIqrGFRFzoOKz6jf8oAjYXOhjLKqxuziUTVTqxrvFB+rOWgt?=
 =?us-ascii?Q?OjkuEn/txp7EoVmWm8myy5j9+0TE1gGDkipkXqaz7wbQ7Whnn02Lr/SKPzCo?=
 =?us-ascii?Q?7Zt4Ef4tzAP7KrPgFCVtfXTgy7aW74wsSmqV4gs69J5gs4Js1mJDIjMova1Q?=
 =?us-ascii?Q?6WNPH25rTEcHWyMXGGQWCqgub/u8iPAYVa+qqE4d3wqfZZVwgDYBchdshILE?=
 =?us-ascii?Q?jqp/dK2Rncmz7cNUK/Jtl1jFmkdv8y8GtdkvXkiRf4rnItfZFqmCKpRIE2lb?=
 =?us-ascii?Q?EO/VFL4bcsaGb0RPtrFPglym+2Y1p04DF5+O5LbXrcCkhCcJSXe/1ZFanhd1?=
 =?us-ascii?Q?zUwFYCBjkKChVUF9yu9xn7Eo0zCfacmgBBxISHHkmYD5VCFn+82kJuKCwgj5?=
 =?us-ascii?Q?9fga+DBvXYNCf9MpgZISN3Fgwe/mZgWRn/mjz2NenS+aZu8JYX3eodLKX+XB?=
 =?us-ascii?Q?6PhfGmO+omtyItMzApIB545I+6+BVPHzLPiKK61LKqIzOBmt8usWyZDA3sUU?=
 =?us-ascii?Q?Bi9xJk3uPrNTXhJRXM3Nof3ZRvazQqWn6RJAFhf3c5QeXjdq2hmFA67oCxSU?=
 =?us-ascii?Q?GRSM7TS148XsB3tcMaeMkHcEL+BqxTqIaPkcIJV7/bQ1pT4w/5EDA0a5tauz?=
 =?us-ascii?Q?QNjudKaB0jjCKY1Nxw0dIN+PFUigs7TreFcL+O45PzcrdPEv2105xuM79Onz?=
 =?us-ascii?Q?0nV+MoGkRgNqlTVx3wyTqXs2GmbP3LrNGWxFc5YEDwyRkhUPNqKOKtYlgc81?=
 =?us-ascii?Q?MLeriUZYpvljgoYssNPgs5sGw+riv0E8ZrQDGdEW7Bc4x0hMf34ESNw76PnR?=
 =?us-ascii?Q?FjlbQC0N9gQtl4r7inhIvsaZU/yjQV7z1XQuQSrybWfjjTWTCwqb5soN1RI+?=
 =?us-ascii?Q?23d50Xb5qeE0cE9bCjTKBdKRh6AL3pqYmRKXKrAnx3UNqA8EbVaOJJ8wNmC9?=
 =?us-ascii?Q?NcIKZG5xG0c1lS3/J4n9tKXLYyKSps4hTCBSbi3bUg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?24W14yEwcaQ+3KctYOjoyjumgWHPqYve2lY5c4vpN3o3btfItPR3gPa8PsSq?=
 =?us-ascii?Q?Wth18XC1lTvMXkXwP/7DxiGTk3luEr3xqb5OMOYl8aAvcPxiehmeFf+SzlLf?=
 =?us-ascii?Q?2MjxvcdJCf6P7+k29Iz3uUK2rw16iUhYEU/8AxR/bMftn6l6IBYHFKD/vjjW?=
 =?us-ascii?Q?iYaPcS8WlQ2pH63buD4zVxfJbTkAPJTuJD4tpt+CA+u4R7A1O9jhXEYRBy4T?=
 =?us-ascii?Q?06cvIyjCV2h06XwJPyz/judl1o4xeNhB0W17TpIiACARwNVk2FW2McXB34MF?=
 =?us-ascii?Q?82o5QrYjNDvaM4IrSEnIHSAu7RR1+PVRO2zjQvhUDCUGcpc+gD5cswNjuOkR?=
 =?us-ascii?Q?CVPgIiA7hjynT1UAuzl8j+fASWmAxBgYVippduX/XZcw6NWiUVHljYqjLYyR?=
 =?us-ascii?Q?l15YjWT725fcRSJfh8VxiXPSLZ8FQfSzqIH3tNTmERuaVE0IhNwD7rJSIU7U?=
 =?us-ascii?Q?sNXpJkcw18wdA9ZyS4g4kyYYfv3i/93JDYuES3O1tyaY9S/nRNjKl2c4QtoV?=
 =?us-ascii?Q?DLlOzE1ozN7RL2djuwn74XFx8OviZvvPQQUG6Cgv7evNeM90oorGfFrprBWC?=
 =?us-ascii?Q?rRi3DBFYeJkFbR3oII9MPjLtDJHf5aZX19xUhMYJYbAiY9dvUG8mmuQ0uI+5?=
 =?us-ascii?Q?PPfdKmbG4hohjn1xGh7VPkwulYr8RTYqgR7CnRAEHsUl0e8UOGZWUUEIuDsY?=
 =?us-ascii?Q?QFJ1m6qWLzn7cT5mqKP3tNKZ0cevT5AHXI2Wd1+jNgw+XQqiIQprqdWB4iZ8?=
 =?us-ascii?Q?Yy0ncQ9pytEO6DKV6/z8LAuCNeotYy3hHtlS2XwTO1N44dY8S8gkSdBU0ooj?=
 =?us-ascii?Q?3aE69j+eCGD5xtGsv/TR90I/CLVrYCXWQApzND9hu3YU8lH1bGwNr9HiuVCw?=
 =?us-ascii?Q?sr34kUnoXuotR58c+FJr8nUEjC0TVr09VfPLGdpFlP+VWO0dxxN7tc2XUFos?=
 =?us-ascii?Q?p4DROkf73jcuhVF773ATME+9memlBQx+nfkmXTlyGBedyAsos7B+2HstU8s1?=
 =?us-ascii?Q?91RUAQKV8txzEYh8ntACsrG+//qW434iTqN41jILtC2+ox3YqTbCCsxdmkTd?=
 =?us-ascii?Q?3CG5oMdssd3REqiCFbV+XA6XvZeWFw2AQNFmE78ZMr47AGeATa9dytaMTYTk?=
 =?us-ascii?Q?loBD4iSDV8DFvh3YuRA3XyJrRxn/OQOsSWVWnexJ+aO0O+weqCKjVqVH34ud?=
 =?us-ascii?Q?KHyAX99AFZOy8ko7fSEoHFPg2ci01OcLCTB9sV6WuFkgc8ymqnIrXgEJj6Dm?=
 =?us-ascii?Q?X5xfclOmVvtO/OvCpEUYYik6cQ/pjacVvPL7pES50wplHL5tHzu5I55JqI7n?=
 =?us-ascii?Q?X40XFPHpYgq1D4IYZfGCtuDd20zQGeTi9oTfypH2U5kJGuNa/7oabT4Dz6A9?=
 =?us-ascii?Q?lW0LAMSMVlM/dUvXnpXqI7KML+d4hDuvzZmu36OQKSeW3aJy5LoOr6btBclj?=
 =?us-ascii?Q?xPYOtMBRtXX3gxC5Xl3FiqeZuBzeYlWbGU8gOH7iTzqkj3bdyoOCSk8VkZE0?=
 =?us-ascii?Q?Fm6G5Wkh0Y/7O2fwFIIUiX6l3bd4/6PJ3iXPD0vxYIMp3ghrZY+lNjX8TVAo?=
 =?us-ascii?Q?llrHXe76iCv7HSgbVA5ji6D2hHb4JsXQdU1aKJMF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9444d65a-de30-4862-7d46-08dc693a0126
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:43.1787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8MueHRrEvduCq9UjSoaGGT8gfkuEKt3yULEr1fIluGDIQRjP9jHJVw+aETXdnmWF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  87 +---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   7 +-
 3 files changed, 107 insertions(+), 142 deletions(-)

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
index d0ab49300acde9..f021268dab4763 100644
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
@@ -1346,75 +1343,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
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
-		val &= ~(CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
-			 CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
-			 CTXDESC_CD_0_TCR_SH0);
-		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
-			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
-		val |= CTXDESC_CD_0_TCR_EPD0;
-		cdptr->data[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
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
-	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
-	return 0;
-}
-
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
 	int ret;
@@ -1423,7 +1351,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	cd_table->stall_enabled = master->stall_enabled;
 	cd_table->s1cdmax = master->ssid_bits;
 	max_contexts = 1 << cd_table->s1cdmax;
 
@@ -1521,7 +1448,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
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

