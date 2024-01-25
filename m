Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B56171AB;
	Thu, 25 Jan 2024 23:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227062; cv=fail; b=M0f7zzPIFLnDMxuDHJN4X2nr5in7IHBYwzdDHOEgFpFDV/Zw+ZqmlseCsJ3BXq8ouZPYEn6NpPcyQZ0shCbMpGLAdIXuVS5dHgSyaLEw8xbGZG9iflMy984vu3z2W/FvaYDGawZuAz0sBvd6/1D24KygOqR5fTQhc3dojFaSTZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227062; c=relaxed/simple;
	bh=x0oJ1j2dTunr0d8ZbZiX6bgUpV5KFeKUy4w5mGVzC+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i2N3IYSPky4OScRKOicQk/YpA+H4ML+Otkl7XHUAS30wW0swiJ79Iyva5ozHuBFgjEHK4ye+VmZ83nKzHSkVb70D6thbGoelzwG7Aj5C/+6M4ByqyhB0mZ24cecmJQLb1i7cu2Wd779sIUSp+HkZmuC3ksLWs28LLmXF6S0HkbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cVolLkQP; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cVolLkQP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNGjWwUMA5/SDu7rHoenPLLvzpbPLiKFSpyJHaAWz/6em+tPwFO07gTrrn3C3i7E/MOcQVhnbZdU7jULN1Zb3Mugexi5WKRxq4l0MPsCxe96i3RrJNqf0CbqETFhuJNRh9FaxID7Mh45USdL04emYNaUidwApW/kK0UEAZ2d5UP+MIihES+hnUbqx/oX56vjCSzyYsbXmP3ow7hJIGrap+f0bmqO/oBFMZ/PFZOJOd3LrhbycGYMdyuXwMN2LDNsMlXsUSodixy/L71deEHxBk4seQbtuNnUo9cL5PgoitcRP/GQqSVTEZzIj4uRiJKbZ3bvLRGI4de+1+BWaOXTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VScJwSKYuH/PLSG5Eur7OXgttwJojTfNlgE+Ap0b6lk=;
 b=ZZMSYsdLgnEeHySlbFjavzBV8Pym7jtWgoWZrkvunA5TWYutqi3y2BJMkYeycwo87ZitLcbHTTQsqKfIR1DCBoR1vVM5eWj2uEQ0SBlXTmwyB+KjDyn5GypszVoj5flZo98JnGfVXQQvN+xLajezOsael/AHCyammDlqKsmgoThp1KJsRENpxapRDlRJuHAv4aYC1I7UOn8nqbDTfz6p8iH2KJKYyvTbgo/WbWVcxn8RZGQ6MGXPHUsdS7PQeryZwGVF04O6B4nhgbUjmebKTwM5a9bkz374G7m0EkQUMmGapfnL9NwaLhjxsVAA5zj2wMpAo5Lo0mnGjFFNEEwXiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VScJwSKYuH/PLSG5Eur7OXgttwJojTfNlgE+Ap0b6lk=;
 b=cVolLkQPQD6OM8/MxIiZgomjC9fZvrjQxxfS5nvIJSnnPi6ZRX4YtWhsffPLETp8rfyyUfx+e+yC+/bnI0hQf0ShOqolvRBGKCy6OKhWlYLqF1hUFbNN44BTfnVm1T2MnhPWF6rxfZOTyv5tkj6Tw5qVG4gjny3wBJezmCnn/ZfvfMXH/5rULlrMxVJTf+M/UdNnnQL9fHrpocuJ/xFmknohnER9jZvw2zRJ0Tz1lKqH0lxaL/adXcYqSBUc7a2h7IqzFwS0NpV8H5JshjTMQblEt1HMVOHZ2l5MuDszLkgi64lHH9Fa42Oa1icuSXUFI1oO9xlG/GdCbNcUNUcvaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 04/16] iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into functions
Date: Thu, 25 Jan 2024 19:57:14 -0400
Message-ID: <4-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0032.namprd11.prod.outlook.com
 (2603:10b6:806:d0::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dbe8329-2820-4a30-d8bd-08dc1e0162fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tkQWNLtJECFwVnMI7LMz89ejxspyUccV7/SX1u4x+YkVNwtZTz7CVHmz9Ae/rxhdvK9aWb826RnjvDjmc7VhYCvHUVW6iuNCQvkptadSnZY1sgAUUApWyFDYxE/H5iTHRzqfzxW4aXf95b74bJcNXWugo03TrEaGOnKMlH0S6UdNgdPFxEak01zXxTskg2sd+41U0FzkxvvVQRpnKKtJC1XHunAI48IyyiV89LVMt7g1KXyw8fV4k1UgwSNP9WbtX3NDcIuZamUnRrCUpIdAFQko8QVk2piUffJKmcr0FXdgqhVEcV3UXwASCUTc7uxr+XKZxS6hcmQgf9N2Yi3ZyFxnpsn+Dmrd015LY8+wDNmlHLCZ88y+ouNbbfXsvoTecLrCMCwSq31f2kz6McbiKhAo5IOrC0R4pIK4RrethzZqaO6AcG9Z/TRnCDSWyI+OmQ0DYctIDPVScDxNOEmCnMEZuNzwe1sMLnRzt6U4YVEiXLxBZKLaitQfXx3d2k4nnuSsYz4fIPsASVeMuroupU4YTLJbsy5dQ3cswQ9ZLVmZCU58gYMUwfkZoB8d+7mEDyxvDf58lOnI0lamxpjptW47JHwe8sxHNLyDX9gPO0dzD9wvfCkJtUwNpHqRPSBpygbi7L+QIljeWJCPI4plPA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hiUGw6JrjLzphdHcqyqzPLc+bu0Kpa+W8m/oH/9T9FdqguSk5b5IK77fcv7E?=
 =?us-ascii?Q?gaLSaohHRcYabnOAajBEHG4AmM+Gb791cIcfDmmxFqGHPUeNngZxA8ZdCAzQ?=
 =?us-ascii?Q?W94IkMv9VWXmzGXlpoB1waFYYbdaFPUawmjycDYUDs33U4oXdj40ADsKvWa7?=
 =?us-ascii?Q?YrZsUB2sJvLGsb06G4Fm4c0+RYucZ37uoPfKU+gi1rlBU0m9GWwUdbWNNuSQ?=
 =?us-ascii?Q?R7t67rgTFFM9vRCLredIlDJAww8c+Jrxs7XYLQJS2tRykn/bpMyTLxIyh/aQ?=
 =?us-ascii?Q?6QdQX6HfgMpQ01ZmGX6O4F9HGHjuoPTrO3rRAXz2VvTO2u37WWUUUiNp7XoO?=
 =?us-ascii?Q?nb4GkgVMc4LumMNgkMeY/iCKIgPmFPnT7mob1v98CIU61zZkfJxaNWqfEfvg?=
 =?us-ascii?Q?DVdBZoge9EASBBjZ283fhPkWtqDBtSzS10MSSX9hPA59QYorKgahENHJpoAs?=
 =?us-ascii?Q?+qCJqE4KvP5xaNgQ9F06sM7R6fMvQei/xz/G0CtNLZPIhq4KVlCrVYXatK2K?=
 =?us-ascii?Q?A1+K9IFIDvjptEoj6uqrzcyEhdGIR7BSsR57P3pD/WF3A5UqTUxvZzpLR6rn?=
 =?us-ascii?Q?gy7MEWhGvxIgMVDmmVMyvmTD235ATvkJNGxk1ywAXVsMzXDpfxpLjOs4uEcE?=
 =?us-ascii?Q?6IXrb3Du/dC1IMtANd6EPqNu10bHuJiyJBiEfaS4vmFehAr2UcpAAwx2/DUR?=
 =?us-ascii?Q?x1PSZFBd2OSWiqN1D7pbhzqZSKdiigtBdx1nFrrMp5o+SWM2anr2i09ifkiu?=
 =?us-ascii?Q?fss5+AcE3O5wYKRq9/pDVnbOLHokxEwXZVzkoSObzDypUWXvpRX1irOtjkXw?=
 =?us-ascii?Q?HnGUybUxe9sEatlcrg8nNxBa1z2zsckz6aFeIHtyQatRt20q94KlouOcCBaO?=
 =?us-ascii?Q?CHg7rLXJBVRkPk9BE1iNDUh8sM/KqxbmcWq5HWsEhH96UWbjTuufRwF+OXRt?=
 =?us-ascii?Q?V35AjETv7ytx7AsWd/SHnTJQSW/0/Bs7th16nBxtjVBscplBVfJwo6V1700Y?=
 =?us-ascii?Q?ptSkjtEwA3ohW7D5gunaov5Q0W3SvlAYC2UQWvunIiasS3g0s7Ee9qIoo5dm?=
 =?us-ascii?Q?dbARA3GfrCHcnebi4QQOD1lInZEZOerfNYElFvvOQcPhupAtj6AymHi48Wvl?=
 =?us-ascii?Q?r933bXAx3GZEuYzaCkhHU52qY7NDD9Ix4Lt73S+2+QpW9D2IMY0BLf03o6OE?=
 =?us-ascii?Q?nfM80tVPvzy5BDRuaDOFNlpuXx7hPmVMphh/G5kery2dXm8fAKFjCXkKM3NR?=
 =?us-ascii?Q?NzAXbg2FooraDbLXUY3zg0M1a7iwv2ewFehrXXBLpnPsIASsDKLSyl84SM5d?=
 =?us-ascii?Q?xLWdzY6a9abBGGV0xKs303HEv9py7Ory2Ih5ZaNKwIhEVykUsY/L8ALYvNw4?=
 =?us-ascii?Q?M6A3+6LP0O5cgfK/NiNIqmpDdvCHWYxiAQ5CTtd1Yvq/Cp96Dqdu88HAhSYi?=
 =?us-ascii?Q?fs2+nIJ5EnhHdc+2GBNRLLEElHU2/Zsu05ftj95OmOCyvZkvLYh93bfXfsvc?=
 =?us-ascii?Q?9Dxxo72nKqHaUD5WOlqEK/8KG6w5QhKO7q/Mzw/AB7P0QZmKXZ5l3SnOcwOt?=
 =?us-ascii?Q?GNNbEFhEovZLOWcwBg5o4I97/mftd5ASWQss2H9g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbe8329-2820-4a30-d8bd-08dc1e0162fa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:28.5307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wc2TXSO2f0/hydp1N8vLhm0rNZg0JQIb+AJ3D2xwfn+dqLFSdDnYymAqM3rvoSeG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

This is preparation to move the STE calculation higher up in to the call
chain and remove arm_smmu_write_strtab_ent(). These new functions will be
called directly from attach_dev.

Reviewed-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 115 +++++++++++---------
 1 file changed, 62 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index df8fc7b87a7907..910156881423e0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1516,13 +1516,68 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
 }
 
+static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
+				      struct arm_smmu_master *master,
+				      struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	struct arm_smmu_device *smmu = master->smmu;
+
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
+		FIELD_PREP(STRTAB_STE_0_S1FMT, cd_table->s1fmt) |
+		(cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
+		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
+
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
+		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
+		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
+		((smmu->features & ARM_SMMU_FEAT_STALLS &&
+		  !master->stall_enabled) ?
+			 STRTAB_STE_1_S1STALLD :
+			 0) |
+		FIELD_PREP(STRTAB_STE_1_EATS,
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+		FIELD_PREP(STRTAB_STE_1_STRW,
+			   (smmu->features & ARM_SMMU_FEAT_E2H) ?
+				   STRTAB_STE_1_STRW_EL2 :
+				   STRTAB_STE_1_STRW_NSEL1));
+}
+
+static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
+					struct arm_smmu_master *master,
+					struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS));
+
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_EATS,
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+
+	target->data[2] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
+		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
+		STRTAB_STE_2_S2AA64 |
+#ifdef __BIG_ENDIAN
+		STRTAB_STE_2_S2ENDI |
+#endif
+		STRTAB_STE_2_S2PTW |
+		STRTAB_STE_2_S2R);
+
+	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+}
+
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
-	u64 val;
-	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
-	struct arm_smmu_s2_cfg *s2_cfg = NULL;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_ste target = {};
 
@@ -1537,61 +1592,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1:
-		cd_table = &master->cd_table;
+		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
 		break;
 	case ARM_SMMU_DOMAIN_S2:
-		s2_cfg = &smmu_domain->s2_cfg;
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		break;
 	case ARM_SMMU_DOMAIN_BYPASS:
 		arm_smmu_make_bypass_ste(&target);
-		arm_smmu_write_ste(master, sid, dst, &target);
-		return;
+		break;
 	}
-
-	/* Nuke the existing STE_0 value, as we're going to rewrite it */
-	val = STRTAB_STE_0_V;
-
-	if (cd_table) {
-		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
-			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
-
-		target.data[1] = cpu_to_le64(
-			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
-			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
-			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
-			 FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
-			 FIELD_PREP(STRTAB_STE_1_STRW, strw));
-
-		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
-		    !master->stall_enabled)
-			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
-
-		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
-			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
-			FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax) |
-			FIELD_PREP(STRTAB_STE_0_S1FMT, cd_table->s1fmt);
-	}
-
-	if (s2_cfg) {
-		target.data[2] = cpu_to_le64(
-			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
-			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
-#ifdef __BIG_ENDIAN
-			 STRTAB_STE_2_S2ENDI |
-#endif
-			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
-			 STRTAB_STE_2_S2R);
-
-		target.data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
-
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
-	}
-
-	if (master->ats_enabled)
-		target.data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
-						 STRTAB_STE_1_EATS_TRANS));
-
-	target.data[0] = cpu_to_le64(val);
 	arm_smmu_write_ste(master, sid, dst, &target);
 }
 
-- 
2.43.0

