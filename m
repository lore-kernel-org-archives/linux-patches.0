Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A201913B78D;
	Tue,  6 Feb 2024 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232392; cv=fail; b=G85Ail/0xamjvXpxsCz/2n3Q+BlJguTVk+WchYpDt+EboCAOn0BmrHXeSzSNeP/xx2mPWFtyuW9LUIRnkwF8h7L4R7+rXY73jYQdEX5JIqGXcMBJBC+odwHEccfPr7ojI7zszkGwBuzSStPSxOIPGRYgGd4XBCB63uEZ9rf0zHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232392; c=relaxed/simple;
	bh=/o6G1hO1EGXUvw7ku7WVvkCW5gZ8xadQJbQ08wtKxY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rFYeFO2uzG7CHS9X8FS1LhoaoZ0ahKIJL8N/WI7gFqCWkTLqM6KD/G6pk0qy3YKZIfRSVxJEv7MWoJLuZO0HUffHVZRH8erlYBgMItDpKomsy6a9MaRQinviTrvuTvEPUbQqV1gGQdrXszrV4iB3nMEKmTacKvOhMynxwtDEW9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=doRbDtcV; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="doRbDtcV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkpq93f+rJlteNq8VEShUIlG7UjLR+Ipc0NjT1v6P3JxPv+KJlTMOUpF8gv+9N29gHPLaWS+TM3C8rDZOXTkzqGcqTaC2M/KruIEYcTxGEXpgsnHNKP8ZjUTqiEqHNNj2+L4pbaVKKlz391uQYsI9Yds2CctynRc+RKbZiQCmF+HANiGea75hutqEFv6cwnOS1XErBbdwl5QfIyV2QnQLfZQ7OnDskoTn5T3pKXIziAb2Cy7AMof8Bo/QCMbDpTE/lcYbdOAOedBDdQ03tSeDqSPrsdniUZFpXqceVgBhnInP3ZPFyKYHZVEyQSu+Kt0bCJHt0fkCrMPbm+qjOHqKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UM/ppWWIu5pAtBD0apLAHYEv4grf7RF/g6mQ9fRdN7s=;
 b=YgQzqHn0851jn/ysNuRNrE9wIp0STgdelnvMS7iV7XIe4ZnM6gsdyeikiq0SFHVuTaWy/awaKU2S6VYoItGKzXprhuqXDg+R5uF7yWS0h3FcVghU37t3nJC8Luv5CFwd/CODkIIj656k8iliqqxj6AHhPu+qnH3dNInsAIyBlcVyR9Ys8Jno460aNwYsR10y/OHjEDToZlB9vc5DaZuJGZxuhZI+o5EE7yiMO3Rz86piWGEKrF0onos/aLlAvEOwZV+FQtSXNHMJ4Z0paxOtTIfx467Xv+xnL7Rkz7Do3vy7Ts6QG+zcR7o8SJGCe4cpURcLRxMRHy7JyrZZMVVTQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UM/ppWWIu5pAtBD0apLAHYEv4grf7RF/g6mQ9fRdN7s=;
 b=doRbDtcVLJ16Hkm1/jNUg3hvCviE8M4HnuM32DKOPa2pNNlAq9MKGVcLOvHNzgANZBcMZVokfaBd+YC5eRZclzRBqfypJdA6z0HbyeLcRWB6/ebj/T4OHfRKvzu3vrTTsHO29mBxOxhbOZhSrsMsKkgDcBryObSx+iqWBzDQWnOyjTcAz/aOoJauMk0WloO8Ec2MKWw8ty4/qOZm8r2Y1pxKsvkvdOCsHAyNzDXoV2WKSfhSCHoPvOssP98v/OGJKYF0C18xlU/9p6RpS9MFD91NM1MkZ++Ebx8zyB7FaLu5AQ0RcOEtMBhVvWqJ44NGJkg1fL547WnOjTuJXSFeHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:02 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 09/17] iommu/arm-smmu-v3: Put writing the context descriptor in the right order
Date: Tue,  6 Feb 2024 11:12:46 -0400
Message-ID: <9-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:208:160::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d032be7-de04-4f45-79c5-08dc2726189e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4VoyJUJaSaeCnKPFYFw3kqlG5aaKu4XN4qtRqhFxa8VKoY2Buhn3yG1lMd1W7pDxIAnEORd6bTXh/fD9PfkfKuzF5aTEvMAQ21V3Ufo5kZ4lZdFBz/fciEvDrOJHtPwpexL+tRJ8ySSIvZBQ9Mk+OvlEDdj23Geyz2PLDmzAxugQs6NahxlD879XjxiM6njsdE4fZB0qBHg9+07KDoHz0OCeapeF3cFj1/NTW1RCxWHzZeAZFTg3dediAeHoUTaTRhCoBJaeQdF9QBsFqEKb7COAGQ+xAx1+yg0MYhp1mesUJ+A9MPbte3DElaPso+RV3OapCEsyf0uQDt/6fTia4ttzuv3lkNp1DlH9FoaMuJGsUqTc1Y4Vd1Fnv1KCeTcXwcj3ri8+lZFCU803QRaaJYY/eHF7GRz23T0uVRGIgmSnJcRJqyzOD5bI4c31rJ176uFJqqgmdrS4dc6BxV66VglDdysx3jgCPBUjMJBShckeZBrmEhAO+AuqEMBEAY35YzBMh742KYh486FbfhhlBzqVKEPqMvzbzwjZuIwOrj4ye44/i+UuG2SdPqwlLOr5s+R6dhiT9RVIo0BkAP9b4/Kpd6c/srUooFj2pr9cL8k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001)(66899024)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MIH4ovvasTh8gOhpEcX6J/IKZoc8/8cLRs4G+gELNoQZdzDxt8MZm4tm+eW6?=
 =?us-ascii?Q?w9CURuCwk4qKuA3vMb67rJkKgonGAjL0GZtzGt5dt5EMBCXfZ3lgKtjfTjhI?=
 =?us-ascii?Q?Z/Wl/zKCOzNotSv2f2yBZukRuzrnEE6XEP7NTWDPYv0rcvvHN3DYHr5VeL6M?=
 =?us-ascii?Q?/ePRZkaI8hlvIjb+WaMZjtgxusiiFduDlbZnVcpx4SY95s3hP0bnJCx46Ast?=
 =?us-ascii?Q?MnE4bjxcUBR2Ec7eZRRXBOV7OrTg6P2HS6scNtWFdBuduXTJlZKzk8wzG3tp?=
 =?us-ascii?Q?opHm1lr26PZvk3yG/r2WGpjzS2mX+ATPSh4TZpzNb3dl5l79CUkmDYyzaL6y?=
 =?us-ascii?Q?gJTxd9zd6nYJpN89i7hWIwCnCR4D9nRP7RbFz295Vl219NAQlDT2pq/BEQzW?=
 =?us-ascii?Q?DIt8OBmjtddDr8mhvs5SCMkX5xhTVdismnexs/UDkJojPf2kiKIcx4Qs8C/m?=
 =?us-ascii?Q?74oz8jgBBswe3J677x1qP4uzsOwZYKT2lqJ4AA+rHtEPI5D0LWHmMbLBLmky?=
 =?us-ascii?Q?Gpf10Nwu4lPNEC1O1QNB3Uri3PwBZSpm7CUZ3bMo6qrQ43LQhUpbrnWTGZf7?=
 =?us-ascii?Q?E+7BIpYo5CRp4kyOhjwBHzO1lseEJYNsYaRGIJaa21SeXgRsal7HQ6uBd/5p?=
 =?us-ascii?Q?q2DuFsOD2m2YUQS5fiPVZSh1HQMDCec95IMxJAlCWf04R0eUet/uA/DKNG8Y?=
 =?us-ascii?Q?I9tyR9lvcEEID1istv20Mcu1QDC3L7Vc14OrwCmbfDHBUaWYq6m71hK8V9p+?=
 =?us-ascii?Q?ZXPYdlRGsaC5gLCgU148IGfHGGIcaB8AEBNIzvg2M4P2YK3mxBvh/Vo6EnAk?=
 =?us-ascii?Q?lOXoEv8N00eYt5i8LorsFWMcIpyhYkBHhHqVkaOcak4nspMvlBOVp8M3C5Lv?=
 =?us-ascii?Q?ksn7byBA2W4EKzMTY4aVbamLXxGVAp1LepuDwgOvMes5vqG7FzSb+OMLkjZ0?=
 =?us-ascii?Q?RHU4b7wV/fxWLP2Bk0kY8iD6nX694DaKw2iBlNuauhYCe73eaMzAmmBIGyoj?=
 =?us-ascii?Q?THNWhUqkzGXRjZs0vK1etEE5c/VFN6myD7QFARJjF5qLPLVsi7KFgTA7j9+B?=
 =?us-ascii?Q?N9eeH/cmK6PVVXzmAeRxd3so3kqu1MHuceZ1Vc9M59lJ3/biIsWLxDyrRx9G?=
 =?us-ascii?Q?R1DbeKWzzqh41bgIuhXxnPx6kF/wghQ14yXL1+mrnGvL2JtAfYnWRZ2ZIObh?=
 =?us-ascii?Q?Zlab+WcggfBJzFAH27SJBC/FQ+Phu27SpWuDlFZeNCOUHlBWu7BVTQPIME1i?=
 =?us-ascii?Q?b9xM+cOmo0JdawbAawLEH1C6SPbJeyLtRHGRUfsLTVJjDs2v4Xw8mz/ON3XM?=
 =?us-ascii?Q?kZoi3d/FckJiK/Z7N8dlEmjWx7WMhah4hdBLXnQpOvQCRE9EjIBV3dkAh2KP?=
 =?us-ascii?Q?B/3RWLc4FjJyw35SZguUDoDsn6D3YeZ8hHyBlnhIdZeJmZ6hcuY0YUXjASKP?=
 =?us-ascii?Q?cPB6dYdloSvqdXOYf72BDC4yj4ulwl9AR3kEDRhw/o8URX4jmdK7x2+89QMS?=
 =?us-ascii?Q?CPZKYFEj16iBvXqrKySHV/CxbkYvVwr9KI4PIshG9l96lJb8acKdmVvMZV85?=
 =?us-ascii?Q?OAQILGDpCquVtJHHI/y8sjxOxHC2UIP36zkqQ+WD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d032be7-de04-4f45-79c5-08dc2726189e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.6387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmDnbubN437alRQQZvgsfbRdH4VhVDyyT2efCqlDauQMO5bJBun/wDsQNHITj9li
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Get closer to the IOMMU API ideal that changes between domains can be
hitless. The ordering for the CD table entry is not entirely clean from
this perspective.

When switching away from a STE with a CD table programmed in it we should
write the new STE first, then clear any old data in the CD entry.

If we are programming a CD table for the first time to a STE then the CD
entry should be programmed before the STE is loaded.

If we are replacing a CD table entry when the STE already points at the CD
entry then we just need to do the make/break sequence.

Lift this code out of arm_smmu_detach_dev() so it can all be sequenced
properly. The only other caller is arm_smmu_release_device() and it is
going to free the cdtable anyhow, so it doesn't matter what is in it.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 ++++++++++++++-------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 340f3dc82c9ce0..2a6ac0af932c54 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2575,14 +2575,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	/*
-	 * Clearing the CD entry isn't strictly required to detach the domain
-	 * since the table is uninstalled anyway, but it helps avoid confusion
-	 * in the call to arm_smmu_write_ctx_desc on the next attach (which
-	 * expects the entry to be empty).
-	 */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 && master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2659,6 +2651,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 				master->domain = NULL;
 				goto out_list_del;
 			}
+		} else {
+			/*
+			 * arm_smmu_write_ctx_desc() relies on the entry being
+			 * invalid to work, clear any existing entry.
+			 */
+			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
+			if (ret) {
+				master->domain = NULL;
+				goto out_list_del;
+			}
 		}
 
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
@@ -2668,15 +2671,23 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		}
 
 		arm_smmu_make_cdtable_ste(&target, master);
+		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_install_ste_for_dev(master, &target);
+		if (master->cd_table.cdtab)
+			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
 		break;
 	case ARM_SMMU_DOMAIN_BYPASS:
 		arm_smmu_make_bypass_ste(&target);
+		arm_smmu_install_ste_for_dev(master, &target);
+		if (master->cd_table.cdtab)
+			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
 		break;
 	}
-	arm_smmu_install_ste_for_dev(master, &target);
 
 	arm_smmu_enable_ats(master);
 	goto out_unlock;
-- 
2.43.0

