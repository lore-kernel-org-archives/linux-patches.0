Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A3012F5B2;
	Mon, 26 Feb 2024 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967262; cv=fail; b=pfnOvYgfkUEL1yuymcLgdf4vOdXxKap3wEV7KmUajN4GkjpeMe4YSNCNOsIk5JEApRosUBkBAO8tVap5aF/QPRfSdtcoZeB0R/HHaiQ4RM5lORCHJ8F9BGVdSBY48Wy4cy1L/LW0gBRzHaNzBBLWNEp+pWlB/l1nrxVtsaWfJdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967262; c=relaxed/simple;
	bh=ThxKpzqBDD9K3ByddkUs/gapa/6YmvhOKaXIijd1el4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ETCX3PSP16qaa7rAaXs3w3RZw81+CcR8+Jx87TlJBYuvIVOihaVoOL4JSUbP4Y3/hUhPemqFJMr4ztUhzG4F2x3W1lCU5zV+zEI6Rw9QYxEN3cM5zQVtpbc+ywyCugkd06ptcJ+hqI+if4LqBLylNIjFA2rBGOVlDaxlC5D77zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DNRjIswp; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DNRjIswp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BC/pqbE2MQ8pc5oAxDl7qZo1Zecx/EZVV/Gn47iSaxcLT8H3ELGM2AKLz2eg30EkL7u0XtYYK5izF3JWKwsZQ4klo1NWim3UjbXaVMkdz3jI9/y5yiQfqSR0lL21SbGfu3zbb14u5iwfA4v/nA1AWV/Z991P5nTQp8rAN49E7pp7dGVzdOrbtw20swpg1R07d3nGHXhVlsSGsH2S/E5rIKlQTjqt5cPTLjcz3/6CLtPD3mn6hLSyEuo2w7AMbvRPAghKRIxpKhz+eXVxggFsIP9kTbuy1s+GGqcjUmQuctF/Jxp/Jv1ciFnHicnx0W0xwhSnZpdMS8QfROF0AT0AJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StRJq5aimsZUjZHxbJehWYgdwTVyadidAX6VEVeAfao=;
 b=IsyyDK45cJUFLyFmGLH+bpyV5NK7qCkpNsMkjB+bVNfAnYJWi7gV1DJ0G55R/BGpxly+G70eGMgWR5n3Wm8ovVc2TIuPYErGJrmNaiyTSwBQNrqJ2lC/mE1J/iOAeN+D/STvK8M2wb93YFfTCiMrgUjgLQCm1/KcorsYUXpIYMtK9er39uyZHj/h/e+US78rkygjQVWd/uPwcWrnNZN8uN3inWv/SWF5O/nJEAw8Jul/AjKe8olXQlDgvSxqt6On8ucRLpfmngJPdVGua55wwlgm6dgShHGo3xMJKbDuvUCH54aumdS2MCApJnG7y/j7cl/5517g/XBEk2hr61nEDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StRJq5aimsZUjZHxbJehWYgdwTVyadidAX6VEVeAfao=;
 b=DNRjIswpbIM87pTDezxJvKCCjXmXe7RhSzRxxRTUXVEY+Ui+Cxlmy+PA7c/05cZFDzy19ulDtEcPnmPOslnRdY8H6X2woM0toaw01wiWesBvk/+rv/k6PUTTOXUMtX80sl6cZCsg4XCZYaUhlrLXyDegBDFi/GVRkjangDoBgIts9vdmYv42951NzBmyLPD2PLLpe1dzSZ3VNEJWQxZLgaf2swcis2f9cM+IAOs5AgYXp1jtlriZ+/4+WtB+ZJRkr++MwQCB8JRQKsLr7btW+4S5X7XAikXBXHTOQSt0rndLV+hu5VBkvbxxiHa1T+Q8MvlqGAocZk+xTT1QQdII8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:32 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 06/16] iommu/arm-smmu-v3: Compute the STE only once for each master
Date: Mon, 26 Feb 2024 13:07:17 -0400
Message-ID: <6-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0006.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: aee38f8e-a26f-4675-fa1e-08dc36ed6a4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pMmJm9tz+TWped58ZFI8DNsTvU9YPF6DXO45eGCvTGfp4RhB/uWrUIa1myw46jbsCrmGqpO4dMx4/kh21rddm9BwKjhtMGnOwhTvnag6D0YpxsrUUsHk4wXeA3epMEGChEFolPLS5KllcE7jxcEw7GNlnIwvgWVenjpA9xSGsLCsDg02J1o1++QiicGiXicyHjpR0V1yOVRKhew+KW5ClsHbbPqJqj1+FBdxyenMtYCQFNX2wExzVxnm1lVSlupER/FU6weWaTnmEK+yFMJeERUEmRC4Q3R1/cw5CR9+CN9X1zGtGYDXfYLXFV+S5DmsGTnCahXSclCcQvHY05+FERdHUqq29S3vrlv6pQOhkaUzmmmZSVS/WmVVNtA8dH9PBuLKtZ3nHLxtXlDSH0KQYgb8cD4+lXRKyGR5P98tXMVjbOfHPd7QPOw43DUhMSDXL2ykODEFrhQjBR3zaHXA+aLI+HOqqlUnFkap+wSRdMc2+6pGKr6Rtgfr3bDmuATz5DsLd9tSIXKPpISh4SDqGzsSxNLJgmEeQaedyXo/LaLk5VjaTJj8oSyknaAkGBXJoH14n6F74rJMs82Kg4Ykr0KJY98Qr6kPu6Fqi5NRq2pjaMsACXrSBAxoMQHJTSG2qGIwQOwNw6Qf8ScpOn0e3w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bbYS0FiUgVA49IeMRppCBw5RyzJr6HUVJ4mLJIzVJiBPNkDEkEhOYBsDStWh?=
 =?us-ascii?Q?eoDsRjVcqwgBbh18VyQuQR4qC13GLXFbW0Cqd7V4PmB9b3Vex19oS4Fd8/U2?=
 =?us-ascii?Q?RGAAmkOGzyfoqEUg9248q+BvmYI8kIv/KWv9IWG65qqG+U+2QmdVjW5O++88?=
 =?us-ascii?Q?Ll1bBpk46YnFl8GWHIxRliRrXKYyD7tYG2hn1myWV72aX7HeYz6m4j4mEVtb?=
 =?us-ascii?Q?VFh3u1YaS7UuslVbUp9VQhqLzZkFWG3N5ezHdIsLkoS/MhkpS2a/MQZ0IsQt?=
 =?us-ascii?Q?3ozCVNW/WrL69OSG35PJrT8tktYnXEHesuA47xkWReLKxfO4/vWiLUUbcD7h?=
 =?us-ascii?Q?FZSrGjHkUq51HoT1UiyQiNyN2GRoIWNOUTEV6L/hNfUf3Zm8o6RzoPhojrfY?=
 =?us-ascii?Q?+zNRvjWn7h35tRXtrqmt/wT02BGtda+91h52PTef4ysbf0fUVZMahXOoLhwN?=
 =?us-ascii?Q?xPDZvdB33cKeT7IR1ktyFZc37uUTzBfAIQ9SZvoRpCKWvKDAE+MbaQJcxoke?=
 =?us-ascii?Q?M2fN9AkxaGbyILG2RPaqmnvaCgpEyXIbTBJbH5ULsZa9gv3tKlT7Xc/wOCWo?=
 =?us-ascii?Q?zbDcHGILQhPckYbDO+qc2Tx2rCS0pKJy3yXyNLhDW5LHcASljFdULJ0AQtqJ?=
 =?us-ascii?Q?KNh8upqwmITAeQ/Ek/k3T03UTdj9M6n7DcXCDYxlrEGtdf8OF2GttoOlbFoU?=
 =?us-ascii?Q?je8tjIP8gY4M0ankB2BzyOuetkk1ebMDeNPxbgbhhYPrbn4+Bc3Gr/XGqw15?=
 =?us-ascii?Q?HL76BIXb4ix9pb2V1pd5aZd2b+rWzn5yZhq2IzP+H4IPM36ri5yhFIY6T4zc?=
 =?us-ascii?Q?8upOtfgumJcyWC5IoN0trNvM4KDherRjpvqz9T8+9sbjmbzlG9o45GWWmG50?=
 =?us-ascii?Q?UY7Y3A+QDVsJAwp5trbfzqilXWCgHLVdZd+jzwLCvFBLVHRjLO5uaW57x5kL?=
 =?us-ascii?Q?/xqaj/Wrefbd7EY40Gf5AlP30foG8zNrRtrjCLeHpRav+4JFSG9QiWQ9YMu0?=
 =?us-ascii?Q?5inO0anT1hUIXt5MrC7fW67SWSLa514z674Nb0hVu9qAar+f5Fpl23PJaLgp?=
 =?us-ascii?Q?L6nWDIoMk2TA3JfwkKBUX7KrSJwby7OI9goDnDO3Ucw3AyCPi+7KLuxWjFY7?=
 =?us-ascii?Q?jF+hULWiYriv9UE13Id3jro4q3N9Bp2c4T9oP/mx9l85Uo/6K0A1o6n2TYUz?=
 =?us-ascii?Q?T150SoAfGOV1Jxi5lbZiIvcOIj5zSFX/jdCiNCnncwMPvQXiyXYKRyInJfEA?=
 =?us-ascii?Q?eGnjrusTKfbpKV6FjkD+nOT3lXQTnnexZNV2YxMPJh1ajtsQ4HE+26MsQxRn?=
 =?us-ascii?Q?+OcMUUFHbKAEtaruPWzrX4RP2Hr0mZgRQy5l6TPIlUAzPITBJ0QTXEDio5Ma?=
 =?us-ascii?Q?fgGgt24T03rU6vh6E2JBKovPKYRJivLnWw4Z7zfcw85NyZaozhrsC844DynA?=
 =?us-ascii?Q?g9F1vWumEu0Zdebfo3h2ktG3rZh0WnK8/ECjLuzliQuTfQZdmYAp1CJ2D1Hm?=
 =?us-ascii?Q?B+jfbAP6wCsMoxbCJgzTXQhgGhwbcpcshGVZDFdkr51AMFDnjiuGguRH0hOP?=
 =?us-ascii?Q?TfSp8ywJE/miK0g9s2wkU51hCRQypKYXR5OFWwTH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee38f8e-a26f-4675-fa1e-08dc36ed6a4e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:29.9342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7rjbnR2cBPyLW/ys0SQrb2WWX4EEETr7t11lIIBdmMMtdtR7KmyQa2b70q5ya5y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

Currently arm_smmu_install_ste_for_dev() iterates over every SID and
computes from scratch an identical STE. Every SID should have the same STE
contents. Turn this inside out so that the STE is supplied by the caller
and arm_smmu_install_ste_for_dev() simply installs it to every SID.

This is possible now that the STE generation does not inform what sequence
should be used to program it.

This allows splitting the STE calculation up according to the call site,
which following patches will make use of, and removes the confusing NULL
domain special case that only supported arm_smmu_detach_dev().

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 57 ++++++++-------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d2fc609fab60ab..6cdf075e9a7ee7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1558,35 +1558,6 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				      STRTAB_STE_3_S2TTB_MASK);
 }
 
-static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
-				      struct arm_smmu_ste *dst)
-{
-	struct arm_smmu_domain *smmu_domain = master->domain;
-	struct arm_smmu_ste target = {};
-
-	if (!smmu_domain) {
-		if (disable_bypass)
-			arm_smmu_make_abort_ste(&target);
-		else
-			arm_smmu_make_bypass_ste(&target);
-		arm_smmu_write_ste(master, sid, dst, &target);
-		return;
-	}
-
-	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
-		arm_smmu_make_cdtable_ste(&target, master);
-		break;
-	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
-		break;
-	case ARM_SMMU_DOMAIN_BYPASS:
-		arm_smmu_make_bypass_ste(&target);
-		break;
-	}
-	arm_smmu_write_ste(master, sid, dst, &target);
-}
-
 /*
  * This can safely directly manipulate the STE memory without a sync sequence
  * because the STE table has not been installed in the SMMU yet.
@@ -2413,7 +2384,8 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	}
 }
 
-static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
+static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+					 const struct arm_smmu_ste *target)
 {
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2430,7 +2402,7 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
 		if (j < i)
 			continue;
 
-		arm_smmu_write_strtab_ent(master, sid, step);
+		arm_smmu_write_ste(master, sid, step, target);
 	}
 }
 
@@ -2537,6 +2509,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2550,7 +2523,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	arm_smmu_install_ste_for_dev(master);
+	if (disable_bypass)
+		arm_smmu_make_abort_ste(&target);
+	else
+		arm_smmu_make_bypass_ste(&target);
+	arm_smmu_install_ste_for_dev(master, &target);
 	/*
 	 * Clearing the CD entry isn't strictly required to detach the domain
 	 * since the table is uninstalled anyway, but it helps avoid confusion
@@ -2565,6 +2542,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -2626,7 +2604,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	list_add(&master->domain_head, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret) {
@@ -2640,9 +2619,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			master->domain = NULL;
 			goto out_list_del;
 		}
-	}
 
-	arm_smmu_install_ste_for_dev(master);
+		arm_smmu_make_cdtable_ste(&target, master);
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		break;
+	case ARM_SMMU_DOMAIN_BYPASS:
+		arm_smmu_make_bypass_ste(&target);
+		break;
+	}
+	arm_smmu_install_ste_for_dev(master, &target);
 
 	arm_smmu_enable_ats(master);
 	goto out_unlock;
-- 
2.43.2

