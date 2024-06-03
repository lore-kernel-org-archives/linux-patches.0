Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F404113BAC3;
	Mon,  3 Jun 2024 22:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453905; cv=fail; b=LfsLwPlMnzVEQjMl564YiID7aMADEe4X+mJ7FabpdA17+MW4hN1Jz50pWv9balaewGRJ/PNyml12HUXpaGHq8knJSVlZ33l9f5i0etD5iqSFvzKW2VVqb+kJSEdRbbqLaTBdBSvs6O1EPWWZmdXsQeq6auqr7UDewlo2PhWYIkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453905; c=relaxed/simple;
	bh=mWyyUP/DpE+wB8mJon71SrDu71PbkrJ/rNAA3GMnq5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tdD+tkRfb2zQhD++QiKayQn7UA4hW3lK8y2nLuEpvzeXJP8ikDivhRtfdAKYGLP1rsGZP2YlH30kL+EF5mVn95oC9ZADXAAuXpnpgwfmXlny0a3rvjsqGdlrS/Z78lo91czz+tA7bImv9umFXWfUQQ3CpUzxIShhjakWOtIHS2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Iibe4ElA; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Iibe4ElA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+QsKinjQ1aNOnc4jwUFng9fMEevqVkQ+LQmQ5evRFD1SxHRJVJufHdNGj9dhSBIeBCF2rzSqc+ijpD8P3HNE8LXqroZBOO8Dc4ZwUivLqrTJQxn/Yb/MPU33UVitez2BUsDu/T6TCZ84IMGuxfJ7jm9IpWIALUGUjXwTZTBb3gwQ6l/P2GdL4KaoYaqp0D6u8JHXWEjGQZrWpKsMscZbkBawOJbwu4H9CbYsQAKnCGRG5CRMgojq+J6K4ys/lIK8yz6xoZdmdn8PetRS7Jn+rNRFNQqDL8fDNxyufsW4TdG2fZuU9ZultX6NpGuHP4h+1Fp71CIGBVBxFiPXo9Shw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kJMQ9BilAOqpV19Fj3qu+WByFe+BHkWI0tph5bvXPE=;
 b=LrfXcGMajKjcc0PVp7ZgFt9BZChac5rKNqTaU39TUWQjcC9l476bRVVBfJ7in6NpClLU8uopnp/lWw+s/p+ugqaX9k71v/KAs2XsPdHnPzbonxzV7A8QS8NtYaygK0TI3nCnJUIfLgwH24dBUrafzdf0Svo9AD8rOBrVUE87bTcBbe9qjmoMeO/HlLqAGyHtl4qKocCqzDp2oPP3Z4Q34JcfVWTW6qpyk3yrhsyQK05kNgz5eKElOMd+Rmhv49lUtQtC8RwzHXq07qnbrUNyN+jbnFpHandmBq3wbosd8NV32mDLnR5u9NuEluQEPMpR8m7VzMeDN5DcsSzwkKeFrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kJMQ9BilAOqpV19Fj3qu+WByFe+BHkWI0tph5bvXPE=;
 b=Iibe4ElA3M0zq6V4o0n8/feNLTCrWiLRDvLE3RmSK1ehXAXhdIKfK6aEwICJLSnzOhtW1n67M9iHvXQdGngfHK8XatsfVpFtL6ZysyiLrECCAOfFS0o4PXrPtN94A3Ksw+d09y3m3XCBL81+wd2/R80veTUay0qwOhjC9IwHh3BKaWNcgsAj6DBBdhG3QrsCxmpItkEVzx+QmziumEonZ2s8dkOd+YHS2ayrICYxy2aVuVtKRY0QdTj9V82zEtJD7+us2MUcndA3VAtH2/Sm13kphyueq+jA+S79U8X30C82/6tHkdmxsTQ7Tk6+opEdAaXNKe3MwPLi4DneGpsClg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:37 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:37 +0000
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
Subject: [PATCH 1/7] iommu/arm-smmu-v3: Split struct arm_smmu_strtab_cfg.strtab
Date: Mon,  3 Jun 2024 19:31:27 -0300
Message-ID: <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:208:239::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: a87ca2e6-e346-4518-cc13-08dc841ceddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dOKXSl8lWAoQhohRu+ERO42ikNR12VVqQAWTznkQlX91uDI9krc0ftPNsJSv?=
 =?us-ascii?Q?n9kWjvC6Dt8kIz4dfs74ivXP+iyxowMaNSJcIch3dKSh22HMBt2m5M8FAw4K?=
 =?us-ascii?Q?5Svqu9gwVnRMmUsS1Hypn1aAv7oTByX3oraQjInl8CmEWSLc0AZ9LvVbIQj9?=
 =?us-ascii?Q?dXllnxzSyKNdf9KP5S+cpoqCcT0xGJEb40LsdQxxmLbpUKMwe9oB3EfcTQOk?=
 =?us-ascii?Q?WDxgchGUa8siyHYiHQ8gCGb7bg7BbV2jKd+71FL7ILxgwVQjQcdugT7CHX9n?=
 =?us-ascii?Q?gPoU4I4VzvMOhAzJbhklMvbzrVBX1AcRkBF91ULoCawq7hByGs8NiKFaDdC4?=
 =?us-ascii?Q?AtJiGX70LrVIKqYrld04t5oNp+0oGvJg+GRObqLhfKfwBYuTn7l1vPLeIoN4?=
 =?us-ascii?Q?v8wFf/WjNNBrYeuNWGlRMQQRd+Rt69JJLxIT4P1lfEv23oULsd2zSpRLdSuB?=
 =?us-ascii?Q?yD7jwakGH4VAIY0sVb4ZN5B87uNdH715PfT3CYkPZKkbWVFZU/n2aGJjuL53?=
 =?us-ascii?Q?XePtiURuuor/1WaA5pfXH6qTOFGrL9l+Mxa364/SNDABtB3pd8IZh/KvTccY?=
 =?us-ascii?Q?S//n49EfcQZiSf8uGv4nl1EWlbDJatYqvQfk8o+M97/GmYDu5JeIYisWGkop?=
 =?us-ascii?Q?wKQwbwTb3LPYrHxP+ZdpogvefFGvHwrSitMCKC1/6nD9LS6PAQIvhO7o6fDk?=
 =?us-ascii?Q?hi7fcWltosi9unS1D6SKeXhZcqddOSXXGxiKzc8V9vUBzpgcFJnuGkmmZN1E?=
 =?us-ascii?Q?EFz9q+sZzivpN9qJ7tI/SyBH/7AlHhqt6Cq+ufGhS8O158e0aTIOxTfexBot?=
 =?us-ascii?Q?FH+1Oa2Svw2/oMBHkRWDwWIfNaC/Ycjg/E3Q+ZzDmMl8fq0udAEAb2CJsrRZ?=
 =?us-ascii?Q?YXMoTh962VMaRbyErbCTwNIvWo1Mr1YjIXRQSWEercNxyk4y6vFD11F60uzz?=
 =?us-ascii?Q?ZBXuX7JMhi0qkfUa/lsQPZBRtgAM0BQaLhzlHPmtv1otSIeqiLnz59794Yn7?=
 =?us-ascii?Q?+yvJG7D/lKXpq2xhhpYpbYPOknh7b8d5czNtYWoP6GDEUZ80CrWwibha8CJs?=
 =?us-ascii?Q?SIXhY+NxNxVr6AEgc1LcLxsqtfpiDynPC4phlKvdcAC1qKerBABZQ/1dLj4D?=
 =?us-ascii?Q?/1Z5r2xVnx3A/fpYteG4WVuFBXQHU4haeDJWVrgOsxHo5AvkaTgS2J0/1qrC?=
 =?us-ascii?Q?kQdXbM1mV8WPxREk1/vWIY4YE90qVK3FK3CmeU2gsumsK0eHcLITFYsFb4ET?=
 =?us-ascii?Q?LZlRi7IZIUG4hTY/04ofXdwRMosHFEApXS8cT1r4OA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vxyHIx77FLUCJ6cJKnSp9BtFHmSE2yBQNLiVEvQDm+1tWpOVolqgvimUKFse?=
 =?us-ascii?Q?t2+9BTf3gQpJGnvdO2Tv/Of+5ozqVwUsBgZRzsRTbzKwzonp/o9ceYcUsQ2s?=
 =?us-ascii?Q?QFKllWrd6Ih3J2cqmeBadJgBNKEsrfCaVsGF36bTiDf00OSoBjqxcSGqgFwR?=
 =?us-ascii?Q?0vju4OlqmV8sU+vJQmbxWl9IGXQoMyOCDkwhjMbiqlbe5PNElBNH0yWqAd3i?=
 =?us-ascii?Q?weMWgwNlVFBDJiTbJhojhMZK5z3/DzUbC6iXXVLIyitBgCi1G28YQiuCoere?=
 =?us-ascii?Q?XJptntNRIDowFovmCgpJBDQS0NE/wOm1oq3F1G8joySwfMyjmNEU2R/ZOLaK?=
 =?us-ascii?Q?cpNDFKceYm+/hKwURmX0FQ6Ocf3rJgAGYdlKAdx2MtbzocZUg9xoefhrwEre?=
 =?us-ascii?Q?niJGYfeFCiLKtYLawwQdyPd2RFpCrWCUt9xQm08ODU7Vw3QN1EVDpv4livlC?=
 =?us-ascii?Q?UoV7RgT2LmnhFedvnFuSLPQDDJlqqFp7fdPY6OLNDY1u+tPT6ZrJy01XYJEH?=
 =?us-ascii?Q?lwszCt/4cC4/JoqDaMtqctXnt5hFzyAHGSErlZwvy0LE7zeIxk4ufIqI6fHg?=
 =?us-ascii?Q?3A/Gl9IBpxIZGq3f3pa3727ZAJy/7/k2mc4+Pu0goddh3lWc1MgV1IA5O/o7?=
 =?us-ascii?Q?FYzgL8R8jcZRti4RougkhwpQk4C4PwOfDaJtyw2C9f0fcmdQu0Y2+JGobLdn?=
 =?us-ascii?Q?LnKepsKB1AdnjABE+tr7b3PxBDO3r2UNe90RnEJAyBpv6x1iAJ1mUOIGDsu1?=
 =?us-ascii?Q?nK3Zx51JlLw5nLBpj5BIhS4M7hY89HkCMrE5CP2De8eYjKb8cYrndKn5f1yH?=
 =?us-ascii?Q?txWklqLcklyY374SvB1aJYLj3axoy0C4Aa1QjyULVVQLxKFbSbpniOq80r5e?=
 =?us-ascii?Q?gUqUtbMJ/QMUQH8HNsaszvvvWtaBcm8YHlo9SDR9ninHrZz/DmV2NjC39TAg?=
 =?us-ascii?Q?nC6DJx/1h32mTC59qvPh/QaQQ5ygA1xNOnbeozgPRXiT5XB1wjxTu+4t+MAr?=
 =?us-ascii?Q?siY9Z37qkefIu3YBKyX/cQS3tunt+nVDHwFtOEB107gCQL7vkQWujUZR4L51?=
 =?us-ascii?Q?vk0IKcUfCh9LguKO8trfmA2pHktA5v4ZBKOfqTWnKFJV1iGInyHHEyKtyCE8?=
 =?us-ascii?Q?gcM/nISBAnqAUTK3PTZqz+e5S2y35URFB/yPiJ/SB8DRE6FzTVB5ECQjbdHo?=
 =?us-ascii?Q?udZSQuMnu6bAbuOrq0QcOVME9ImCwyAnou0D7iOwGFEeLTN8a8h41jO16Xpr?=
 =?us-ascii?Q?HE/3fY1Zhbq/hmh8++7pOovPLO2ro8Pm+xF2HtdByH6ga9NiU6YG8HxOl5xe?=
 =?us-ascii?Q?Y94PJ2oZNspyTKFMUWn/lBo5+VlNGoTVNB6zEVSQofFupQtmqQRGCd2nqoke?=
 =?us-ascii?Q?J8MOsMZpeSMLX3xhiVWjnsSpIBoCDIrVa0pXNSruwNWWoFxCbHTyGfVdZuZC?=
 =?us-ascii?Q?T9zpjkS9qpaU7gk2pYb5QGa4UTQGiDX9oHOy9JpVma7Y1MvH6DO1kg0YetCf?=
 =?us-ascii?Q?X0MUlPrCRscrHRtqZrE16QbulyihE7C0Hrv9LlQcBpPm9Mfi5CAe9+bsDqHb?=
 =?us-ascii?Q?H6OCpJC7uA5xHgo/KeY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87ca2e6-e346-4518-cc13-08dc841ceddd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:36.5713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6k/E+GQRpoUBuxL+5ClNNm+bBX0dUhhyAj2jWyzQHOZWioYXxZBmOcM7QEDSmsi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

This is being used as both an array of STEs and an array of L1
descriptors.

Give the two usages different names and correct types.

Remove STRTAB_STE_DWORDS as most usages were indexing or sizing an array
of struct arm_smmu_ste.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 +++++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  9 +++++----
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ab415e107054c1..6b4f1a664288db 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1661,8 +1661,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	if (desc->l2ptr)
 		return 0;
 
-	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
-	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
+	size = (1 << STRTAB_SPLIT) * sizeof(struct arm_smmu_ste);
+	strtab = &cfg->strtab.l1_desc[sid >> STRTAB_SPLIT];
 
 	desc->span = STRTAB_SPLIT + 1;
 	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
@@ -2409,8 +2409,7 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 		return &cfg->l1_desc[idx1].l2ptr[idx2];
 	} else {
 		/* Simple linear lookup */
-		return (struct arm_smmu_ste *)&cfg
-			       ->strtab[sid * STRTAB_STE_DWORDS];
+		return &cfg->strtab.linear[sid];
 	}
 }
 
@@ -3225,17 +3224,15 @@ static int arm_smmu_init_l1_strtab(struct arm_smmu_device *smmu)
 {
 	unsigned int i;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	void *strtab = smmu->strtab_cfg.strtab;
 
 	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
 				    sizeof(*cfg->l1_desc), GFP_KERNEL);
 	if (!cfg->l1_desc)
 		return -ENOMEM;
 
-	for (i = 0; i < cfg->num_l1_ents; ++i) {
-		arm_smmu_write_strtab_l1_desc(strtab, &cfg->l1_desc[i]);
-		strtab += STRTAB_L1_DESC_DWORDS << 3;
-	}
+	for (i = 0; i < cfg->num_l1_ents; ++i)
+		arm_smmu_write_strtab_l1_desc(
+			&smmu->strtab_cfg.strtab.l1_desc[i], &cfg->l1_desc[i]);
 
 	return 0;
 }
@@ -3267,7 +3264,7 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 			l1size);
 		return -ENOMEM;
 	}
-	cfg->strtab = strtab;
+	cfg->strtab.l1_desc = strtab;
 
 	/* Configure strtab_base_cfg for 2 levels */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
@@ -3285,7 +3282,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	u32 size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
-	size = (1 << smmu->sid_bits) * (STRTAB_STE_DWORDS << 3);
+	size = (1 << smmu->sid_bits) * sizeof(cfg->strtab.linear[0]);
 	strtab = dmam_alloc_coherent(smmu->dev, size, &cfg->strtab_dma,
 				     GFP_KERNEL);
 	if (!strtab) {
@@ -3294,7 +3291,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 			size);
 		return -ENOMEM;
 	}
-	cfg->strtab = strtab;
+	cfg->strtab.linear = strtab;
 	cfg->num_l1_ents = 1 << smmu->sid_bits;
 
 	/* Configure strtab_base_cfg for a linear table covering all SIDs */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1242a086c9f948..4769780259affc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -206,10 +206,8 @@
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
-#define STRTAB_STE_DWORDS		8
-
 struct arm_smmu_ste {
-	__le64 data[STRTAB_STE_DWORDS];
+	__le64 data[8];
 };
 
 #define STRTAB_STE_0_V			(1UL << 0)
@@ -612,7 +610,10 @@ struct arm_smmu_s2_cfg {
 };
 
 struct arm_smmu_strtab_cfg {
-	__le64				*strtab;
+	union {
+		struct arm_smmu_ste *linear;
+		__le64 *l1_desc;
+	} strtab;
 	dma_addr_t			strtab_dma;
 	struct arm_smmu_strtab_l1_desc	*l1_desc;
 	unsigned int			num_l1_ents;
-- 
2.45.2

