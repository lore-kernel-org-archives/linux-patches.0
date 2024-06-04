Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E7EA32;
	Tue,  4 Jun 2024 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460173; cv=fail; b=TvhbXzskPn55naEpfTl/REj+JCS1IWiWOnD205cauIpbXvQUzrhBQHqGWXjgOII1l2izWh6h+GohAVu8Fmbdbxn1Bicb+FbITm7l8+KqY9Y+ZdcJgxhJ9Wrj+h1B0aLdgAZJWEQJSeltYHm8xRFM9QM6MSHQohNR4wy7qUdZoDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460173; c=relaxed/simple;
	bh=kpNU9WqigfMRhwy4ISgM45KeXNsGZ2bZQythul+5Ink=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rVluH2GFSf4RhD0ayiiWDzSJUiqU/V5Lp+WdWXFK5h/7unahsJ5uVrue34AEFdpB5oEjkXX+qbq0BWNTLlltLl7ZluEUM+RA3LH8iAS9/BXOAmxiW/U1MZyqIesulywiI+ebyi4W9bOQjjQudC1tnypabQYpLNwXTZdJ32wIgK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ah1fC73A; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ah1fC73A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SobPOetwL4LQ16TN4l/ODjgs7kjn/NrS64FtagdMGSf1hP3GkWeIb2vYRAToRkZtYDfzlwmvNPzJB3OIeRLxvDJw+JEusnfvCAFDnmeazYruQM8om8F8HmLBFPb/lnir1u0uoukgHyg+bMRf3yvjTvBNlzZMrEk4BvS0BrqLoUrSopXS24JrJuDPWQCJ/ChvJ9Ugo7Fjb1FfwtaOVpseUiv5FMMMWGRaAJWfacuylyk2UXISTuhNmfrj2ARezKBjZp3DES10qVsbKK0nSCiY+OzcsigjAFF3c/toM3Xooe99hat09LSQtfghl7FKnK/Gsl2dtrFaIAIb/7sx+aKtGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruK9xLbDf+EHyfO+ItDfSn2PL0RAG5FtKdpPgajNoiM=;
 b=mxjfTsaMgr2jeSAd2jK6xxFI/bmgs/B8H+9tcUOZw7oW+MbWP/Utiu7IDzeT5kR/ggxCzuZ4UpoCcKFD7xvQUfzWH3oZhcCGvQd4s7jiwV0X0iChy0dbSi3/sfnoLZ05jlLARX0NIc1BbCU5p7KdSiioWK7xXXhdlmtFLAdTeinHU4+5UCbY1hEus7kwm0WUYQFPZ48EoqgtMWKD2vs3MZyw54iSxE/LoFgmLOhtcMUQyWadfSaZlk5j6/zsr2TVn3bJBKj3qTRIrE4T9jaiYhZvAgS9c4oRccqrXS8WMY4Sy4Uy+fag6fFBs591+kbScdqbyGEB15qCJEo3x8zU6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruK9xLbDf+EHyfO+ItDfSn2PL0RAG5FtKdpPgajNoiM=;
 b=ah1fC73ARqzPplPuvgP9ZOZqT+8Eoq5lH9dGLGjnO0hchFW/wlmgHfEOE6cfihz68ZZAqqYijsDyw7PbA+jyvF9w2Hnnh/jwRaVVVB+Dd7znQH02nJWXd5XY+24PI+OCV+ugUPyXuU4Tvd52oKoWGDeV+ckp1UoJPqYTJllSKSlo8dBfBfzvXivLRwYt4jVShuwt+WppLkQteZwBQbG0xDRdAyMYtNoXMTPTmw6/iy8s2gbw9AFY94+xrZI6zeOdh5eJr1cwmzLTVaTVw0dqpjIjCmEnVW0osCKPs6IGo/g9wgmsqxpjgrh148YxtkB9IL7UvTmtQr/H5efLBvQR9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 00:16:04 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:03 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 06/14] iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
Date: Mon,  3 Jun 2024 21:15:51 -0300
Message-ID: <6-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:208:32a::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c4021ce-a84a-4e55-6b71-08dc842b84ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oH8cakvVHxT9FJfe6uUDI0Y/Vr+9ASb0LF8+MYNieaZNiOzJb5NMJ9MdcUuQ?=
 =?us-ascii?Q?wrz8JNPm8AirYAQsKLMD+mZef0tOvrSK5774dd4u0te7M1mbmA629xFvVoGu?=
 =?us-ascii?Q?I8USIxOzvYLenkpN5EOIU6WNHW4viRsw1GG+fyWiXGBIjICTdWcx49yG6jRD?=
 =?us-ascii?Q?jdJUMSqJo+1qG96kdUAnX9W47ll3kuv93VYscwORnkUI1zHlILVbEzqN9LVP?=
 =?us-ascii?Q?hCLw6+V5f9VltKj8q1S05MfYjrHCcQt3Nm32CWvNCvd0UGhTNk34j2WbYYoS?=
 =?us-ascii?Q?MB7IuGYh0yb2cGfmt/LNy5UFA7jkn20BOPj7SPy/XSsTK7iTFkIO40U7U3C3?=
 =?us-ascii?Q?kNjuUoACjfYiPwyYr7B5p1FN5l+TY+uO5+EFCRsqulLCz9JaHpexazVsF362?=
 =?us-ascii?Q?1vlYo+n/GRHRygYbRvwcJxn5cmzJp3kWK40l8/xrF0uALkH+BrGedURdYtGH?=
 =?us-ascii?Q?oLzHhF8iCrpaxZVA2dI6lQglHUM7a6wKWP25BHDAew9tzGVXsKGCAN15xjT/?=
 =?us-ascii?Q?C804j0QWe3eApLAPtP5jpVRAYOlfXkHdh9928u+kLXMuUPiBevKPLx3BTm1h?=
 =?us-ascii?Q?AP/XRj2KaD5WxnEc0YZN++hLdE1nguE5iWfO1V/g57AfohFmeBH+d8LrWkPD?=
 =?us-ascii?Q?bV4RyVViYjQczHVPkpW+k7pdCJ+U1Mf8uEcpfXo0pYhGQlOs2XNCxjGxmDhn?=
 =?us-ascii?Q?DgZL32kHiK8vzIfm8Z7/SzOR3cfHhJ5tj6Smx+OgU1+JNAAZZiDIi6c9E+9P?=
 =?us-ascii?Q?F3v2HeIqF4RLIARd//qU1ll+t6zojECsSmVcKkMQRBdGq4BFh5HhznD1bqq0?=
 =?us-ascii?Q?3d1UXJExWwFhmI3widqbQDinxgIFv8EZcP/X3peeUvH8jXUW+SIsPrxBE08w?=
 =?us-ascii?Q?D9OZ9krRlD1HYyet46kafyJt4OOfgsk6fulkMumVat72HpQK4vDgt1Aa8VnZ?=
 =?us-ascii?Q?q+hOA4MfG6JjEakU3TYOwI0Ue3G0cmQQkBkK8IkWqFFIJ8daoutHssW+xLZK?=
 =?us-ascii?Q?bXX0ulI6rkfFTsAQT7U8Cgxrxnr6Rczib16iECHkvGJHqQXmiIaus5p9q1W5?=
 =?us-ascii?Q?76NITCI/dqPrWSbBBH4iUtQfOolmHimetiydVEdO6MyMZZnQgqzFTC9l+fwU?=
 =?us-ascii?Q?lA1zfV/B4psvOwDJYzXQ4jl4kVxUBLCcXhVGRCIP6QQtW8Kg/VQMoSFLXXAM?=
 =?us-ascii?Q?C35mg7YfcDtJmoaLpA+8wPbDnddsrKSrvfV5tL4+308WKs51bnuuFGl1GJKs?=
 =?us-ascii?Q?PSn2tLC19rEVccCj3RsfIlQ09p3eHRXQI1MOCfsLXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hlxcE3HLfRqgTND1ENKwbz4W0WM/HVeBPS+07qEMqNZt2si9MhPGOolmp+mD?=
 =?us-ascii?Q?8mbL4LnEEAULKNF7+UE3wguhNfjlkF5sd1ZLKSoEwwDZAVbBqqikVVLHtLJz?=
 =?us-ascii?Q?P0RE8D5nmGRKYowwKk/N43quUt05a1PQgKpWd7ixfnkFDsME8wmrc771k63u?=
 =?us-ascii?Q?MpzSscHYLF54VxW+5Ez/2YG/gopJuZpEcIqzUM+JlxgQdvW2kaxrcn56Poq2?=
 =?us-ascii?Q?sUWA6q2BP1E9phjruU0Lr7IYB01TNI/xjMP5wpqd6aDQGXQUERewrow99Pt7?=
 =?us-ascii?Q?WAITWRRIucK5KJSb5LxUTvEkz+VU8x+q9SFBdkRXzp1BYjGs3dae4ZG1SoNV?=
 =?us-ascii?Q?FM+v8CqQybYLabadQAFIRFCRWr93fwTC3XaEo2UtuVm1uhkzjjw1MO3CRBUq?=
 =?us-ascii?Q?ReJwOyZ3T4OUUnU2gHpiwZX/aZ44BPssC6p2bUjcZn/MzTGUlRBUJXenkmy5?=
 =?us-ascii?Q?kDya5sb7skgs2P7kn6I8Wps2bh0zRsWZERezGQws1LSw2qtUrjYbIrCrWbcH?=
 =?us-ascii?Q?wladxQEid5w8kxXJliMSSwLwyVNvrwyXPeQ9ReZhG81MVBW3rBYewrq2XrzN?=
 =?us-ascii?Q?nX4SJzSC0vNS0InBEnYUM7cvSoNXyFBOEZDja20FjeIjqxWbulI25cQfxMLp?=
 =?us-ascii?Q?jTxDo7NOd1ymt/RCnuE2FwfFoJTaq+sUzILc3/9L8NQojpyTPRvTNJUGqopx?=
 =?us-ascii?Q?VRwk0l6X/TNeonXImCxunxMkXXOHcfNrSYOM5CFBLsZKtbUgnyAJf1UR2hA+?=
 =?us-ascii?Q?LH11jVoxmAS37FPDyTeZsb/2xDofjlEbQnQXJM22n050IRPuU3UsJbEY3Suo?=
 =?us-ascii?Q?9AjEapRx3OV4nlwXYg1bbbcYrqllX/xxGmxxyDV3sp7FKBdaR0HIEq4beOxg?=
 =?us-ascii?Q?3bgP7TWDC59Z4+ZaoVUIkoSlJ5nvou29A2gw8wuZbncWkp1ppwel4HXozC0k?=
 =?us-ascii?Q?jyDI4SK+N6naiDeL6R/VbmaBXZJ+NJktmSfVzgHWPiShafw2FfNusUiQmPz6?=
 =?us-ascii?Q?8PDydvYkiVD2BWr9hGiD+RFpy61ISvZoAdU1sMgrFAQlLeQtWts914u3nGSG?=
 =?us-ascii?Q?vvVsPcCI16816j0ccJn7Kg6NoUGCF6DkYPyGk8erU8ZezUaBgf8XSRmd+8dr?=
 =?us-ascii?Q?BdqjLOwKs2AsyFs7/ONaQIVB46Dzp9dh+VF1ppxI3v53St2dI8hI1WcbdXMl?=
 =?us-ascii?Q?W8bY6WRqeECGcM/FheARx4rBsMA3Tzmiux5IqBdFapmTIhCDb2Nrnv1f2u7b?=
 =?us-ascii?Q?ierX97R/sK6JrXhSzWFWNfJ0Pu0yAO/1cJlqy9RvMoAh22p3D109iJARvDVY?=
 =?us-ascii?Q?EaPZp9iykADgC5KISrbBvV/tKNrhF5gLTSz8T08eizjcNhzwNyfpMNGUHJFn?=
 =?us-ascii?Q?kRMCrmK1/os8GwIyBWEvKNT+B8HXBNp/JLfJGS9xpwk93oCon15BQC4YJWax?=
 =?us-ascii?Q?edaWc5rwg1af/uFvO/Y3oK1Uoam25fIMdyIg7dXTmOr7C19IV188pfhxkLNK?=
 =?us-ascii?Q?6r4RBGhoFyerBItfpQybo/srtmIlmOAksDPYmNRhQgQf7UTrOIpWE+O0wGhb?=
 =?us-ascii?Q?/UC9pu/phTwln+6RKgw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4021ce-a84a-4e55-6b71-08dc842b84ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.5855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJSmsLtUpF09mtI0+WszpsXHzP0WBKqKA53znWQJe70BN6JhS3r/jz6nTEKKe1AI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

We no longer need a master->sva_enable to control what attaches are
allowed. Instead we can tell if the attach is legal based on the current
configuration of the master.

Keep track of the number of valid CD entries for SSID's in the cd_table
and if the cd_table has been installed in the STE directly so we know what
the configuration is.

The attach logic is then made into:
 - SVA bind, check if the CD is installed
 - RID attach of S2, block if SSIDs are used
 - RID attach of IDENTITY/BLOCKING, block if SSIDs are used

arm_smmu_set_pasid() is already checking if it is possible to setup a CD
entry, at this patch it means the RID path already set a STE pointing at
the CD table.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++++++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 674884a8fe25ba..e7cd1ddc03517d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1289,6 +1289,8 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target)
 {
+	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
+	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
 			.ops = &arm_smmu_cd_writer_ops,
@@ -1297,6 +1299,13 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 		.ssid = ssid,
 	};
 
+	if (ssid != IOMMU_NO_PASID && cur_valid != target_valid) {
+		if (cur_valid)
+			master->cd_table.used_ssids--;
+		else
+			master->cd_table.used_ssids++;
+	}
+
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
@@ -2734,16 +2743,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	/*
-	 * Checking that SVA is disabled ensures that this device isn't bound to
-	 * any mm, and can be safely detached from its old domain. Bonds cannot
-	 * be removed concurrently since we're holding the group mutex.
-	 */
-	if (arm_smmu_master_sva_enabled(master)) {
-		dev_err(dev, "cannot attach - SVA enabled\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2759,7 +2758,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr)
 			return -ENOMEM;
-	}
+	} else if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
 
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
@@ -2832,7 +2832,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 		.old_domain = iommu_get_domain_for_dev(dev),
 	};
 
-	if (arm_smmu_master_sva_enabled(master))
+	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f4061ffc1e612d..65b75dbfd15914 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,12 +602,19 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	unsigned int			used_ssids;
 	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+/* True if the cd table has SSIDS > 0 in use. */
+static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	return cd_table->used_ssids;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.45.2

