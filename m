Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1CE6D1C5;
	Tue,  5 Dec 2023 19:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pegYqDLf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrjXIxNK5m3FN4bbfn65c12Ys1zwwc7636hsKlnU73aMFvxnmmz7EZKkbG7jQnQHz9/R8Iyle/tkTuvjuWLnE8iH6MtgGOIlTMBCw4uGOc7hKo/VcMU/P0kcDfhyHuOJ+w/DFOKKXRpK3bwqy4XibTwsWdBSv2mp8DWx7CTY+qUljqc6wi19Vo6q0wD8PIvg1k2rWPzRJLsqtHb0k2d17tSED2ZGvtKJrrFFs7qRqC8LrS749vKBaNq/QRcVD3sWJsvsvqPqOuTdMNbcBUOlLCMoBQJd9fw7QupETPVFrlg0q8i4Ts8xX698jA8PCWGlLRo3LxUy4MhTPnXno9Uf6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dg8V+OAhek6zXi2+rVrCY18eyZ06iQ6unxFiN6ZL4ak=;
 b=gQG9mP6iCzxQZHvIs54mXnjIuYf/L6y0w2A2Hz82LIPPBX7/V4u9Ff7Wi4GUO7jHgFFa1B6pBpdUIa5s9tpiglfrDSD2fi5f1CqAIjV8VFzpV2BiVdqqGmbxRO7HERYAeCWO/j17+o1fGAdJv1SPWp1v/5ViUelE9eWAonOoC+2tQpZV564KxxIB1ne+x+72pLVLnMWQYZGwnmmFou3+TKgGZn4dbHefbeP8a+Xqi4HjJvwahhjBNUEIwLJytmqphX50MMFdzdvAHJB1WZM47C/X/Onq4NdZndqQiAWg70lni46HOuF0ff4HkNUYLRCl0z+Jhygr9ax5dLScBKJDgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg8V+OAhek6zXi2+rVrCY18eyZ06iQ6unxFiN6ZL4ak=;
 b=pegYqDLfjmoECO814Bu+rDfwK8sulvGnXCHvnQFN6S3FhFp3gMKd1cwbR2jrqov6sN6ONRRXN2+ys5cMjKnClYU0ErcythzoiZa6X1wXOLr9YUnAc4eXyyuckoJZ0+ILoSg3syrzQ7MTzfeB0n0cAih4V9rJhmJBdF/1Lu5g0KDZxiGosj0mMInwbwhQ4uxcLT5fa6vMnxLv/piXATXnKCyQ3nJ9nljgHf3E2RNG+GRwn4c7HpEDK1skUgfnteoYrvFcRYTWnSl1Z84JWvmzqX7YdkFM3tsIVtDxcK4VPlnwE8KJuBp3UMf7l5AnLrvLx1mcTO83hh9dC1QAEKQjnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:59 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 06/19] iommu/arm-smmu-v3: Move arm_smmu_rmr_install_bypass_ste()
Date: Tue,  5 Dec 2023 15:14:38 -0400
Message-ID: <6-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a0bcfa3-059c-4d28-be95-08dbf5c675d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cbjyhkuqySC509SCzfTs0j6CXk780+tudRkC02nvPACM/mANZNqfod0ISjVyXwgHf90UecZuhMOK8PjscbZrm4/3R4XRUJ8qZzKYjoacEH2fxAELzMx1lOeUfYjJR5ZAzxQioCyLANGMULmGZxJucWyIi6iVWC7xvU0MHkz2R0KAEe+Cn7ePDjHlLjF+S2CPvw9+gI2vXLja5R9FACa74chwKg+Sfv+2j0lj7lCiXEV3Ase8rvh0Cnk2Ph59V8QZME72OMaByx772Tepw90aoba8PCkSD4h+3tGfLjjY4/aqfKS2WO3JKxHRP35sCO9fV8vrK0jvfh6mpJW5gIqZVRv8qn2sqq8E9r2X87UzTTSC/DaYK6QV8/NNYJ+gpqI0X2P6aqWByNOilZWtEPG40pk797ZdV0BHGHxdc19PllrboZbh9EarCHLszj8RpzsZ2tLAmw9/hw+Akjo2l0ppe5uykQMdYab0CE8ETz3x/IpVFI4CPAHl4taaAGzXjjIkh4Y4l8du8v0x+Jnio7lRzSJSpSsnzORc2c8vR+MCMyEXboVbddejXXEqkuYe4+nT/rvmJ5KNr7uNxpbWzE0fyYcH28WGt29pZ9SGxCQjtcs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?utiL6dv3bGFA/opGA5kPeiiI2ugpR41pjryxhlh0BsSfiQjLdzoreqH4gPad?=
 =?us-ascii?Q?FCQHNuOswXd6aHGiJM8Ej0zransOSawOnEln9sJYej/3e8xjpK8Egeh75W5k?=
 =?us-ascii?Q?fjzV+gZKBB5Ty22IDOITjLGMWM6BNeQg8hroPSIM3cU4ZOTCpjGWURzLEGxa?=
 =?us-ascii?Q?qONGtm6Z+fW3Kbo046rp2RQiA96Gii/ZNvOJLtPM3xzIRDeuIhZ/9KDjcGgf?=
 =?us-ascii?Q?918sXg8/MoXndbM8YUEKAdnmYAiuzHlNRRp5anjP3kt1B6QV9hHMJ/TG1UFy?=
 =?us-ascii?Q?+kuZ8PA04qTTwOtJQyWPZWxvyvNVJGfRmHiKgH/r7JwU6mTaMrI+ddAAVeAh?=
 =?us-ascii?Q?iaXwmYl6HntiusxTS3rhPADLEqhiqqysiUUIkP1BuAGh4cW9M2t1BPbFtmrN?=
 =?us-ascii?Q?F/euYiUsVC1we3MzEbPAfuiMDBFRcERAV5jgLbuoVcj6jmskZny4iLVl4py+?=
 =?us-ascii?Q?SH/k2BzSK8aXkJkyJIuuPG5PEpwWR7Jp637MyuK+nVsLNyM9TjfFUMdx/iLn?=
 =?us-ascii?Q?dLi1fNm08oU5pjVhjQ0tkEvFyeopuJOpDWQgFkK0+QAUTlwmgqNPHIVNsZU/?=
 =?us-ascii?Q?q1OkC94z9UWuvqR8gC2HV60y1KiGexlB7QFJz+UtSxRXsTIaoXrq52BmMGX1?=
 =?us-ascii?Q?f9NYCauEMh69VykSm9Lsf7hQfxoA6KQv/JUuVe+nWZ+EvJb9fMgPoGUisHWz?=
 =?us-ascii?Q?pxLcjGVooxCy7PDgOekB0RxURuxY8Un+XwYoPlrQRt5phIquk9kl+V+CSz3+?=
 =?us-ascii?Q?FdQ5g+SD5G/AMpdvPhKYGGkE/0IymGqmwo8eeM/Z4R6Ox+po9eY1SCzR0UHo?=
 =?us-ascii?Q?XkP8NJddVUTd/ppnXNllLW8LGzaprVc6zQv2/Ls0/Qos8GYwUDAP5E9i1KDp?=
 =?us-ascii?Q?fYj0eSE6FMRfm7MLd1mnFh2C7HL8L8+NehikeyH2VcaUO/RylTnQvIo5SLlf?=
 =?us-ascii?Q?6kb8Qxz4xRy1pVP9mKyVVn/Dba1tCivgYLJHEjTFhq5j66fXa9iIVTez42kC?=
 =?us-ascii?Q?ajaQbGnkcLQSPnQBAPbCUROUq3+nik8ZaRRz03CQ5aLXpkjrSiHv42pKtAjh?=
 =?us-ascii?Q?Sc7DXtgGDugJePdUMoMbBRjh8woEmHZ8uwoVwtP36sp9KrOqTcmAvkQi6SoZ?=
 =?us-ascii?Q?4LoSsbG6Sa8+sEPCWflcS+q06me5wHsJC3XMILZ1LEZEjiZqeTbA16s/RWgB?=
 =?us-ascii?Q?5ouTZz6Kyctthdeqwq2SMMZDNICoFMFibISGxPpN3ny556+tsuR/BGUSfZl1?=
 =?us-ascii?Q?ZyaPhjbTXt4c2OM6FtZV8KGqPhnmGXNaLoi5BjMvJ8uDJCGk9kBXXqrHG4YR?=
 =?us-ascii?Q?kPNjA8JHI0aIgvi2xJIyhKVqfM6I2u7LI9Zz3npO9/UumUOQfusORfnRRvo2?=
 =?us-ascii?Q?70Umg+4/DDSpRc52okRy5vRDkQYBOZrugRFqyltuaEVX8DeHf6clvxypONVA?=
 =?us-ascii?Q?dq+5eypBM+9fBHsgkOE8jIivs/aVg6hM2etwUKucL/uWQgYz7AZIfXmq05p3?=
 =?us-ascii?Q?WaMpvAEWjI8G9XVJuA5+JGtzgfh0zfGo/AmXJzeoaug5uk2N/Py6wheKvqmJ?=
 =?us-ascii?Q?Q5zuGp4J7phSpMaOZN/syzJwoEkG+5K/0CDg/gMy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a0bcfa3-059c-4d28-be95-08dbf5c675d1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:53.3076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFy0bin0S2RXYsEiOUNMQbYaa2+jnRHr+/UTVHCqbtQmtJbI+WK4P7yE4uCE0X0P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Logically arm_smmu_init_strtab_linear() is the function that allocates and
populates the stream table with the initial value of the STEs. After this
function returns the stream table should be fully ready.

arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
ensures there is no disruption to the identity mapping during boot.

Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab_linear(),
it already executes immediately after arm_smmu_init_strtab_linear().

No functional change intended.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0a4bf1cbe42293..95c78ccaebd439 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -86,6 +86,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ 0, NULL},
 };
 
+static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
+
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
 	int i = 0;
@@ -3201,6 +3203,9 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	cfg->strtab_base_cfg = reg;
 
 	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
+
+	/* Check for RMRs and install bypass STEs if any */
+	arm_smmu_rmr_install_bypass_ste(smmu);
 	return 0;
 }
 
@@ -4014,9 +4019,6 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	/* Record our private device structure */
 	platform_set_drvdata(pdev, smmu);
 
-	/* Check for RMRs and install bypass STEs if any */
-	arm_smmu_rmr_install_bypass_ste(smmu);
-
 	/* Reset the device */
 	ret = arm_smmu_device_reset(smmu, bypass);
 	if (ret)
-- 
2.43.0

