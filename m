Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CA7205507;
	Fri, 10 Jan 2025 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526913; cv=fail; b=jisFu+8P8X91leaYTKnoWA/xh4qbECp5ClSAn0wNhrL1P6R6Qcll93FhBkqyFUt/YCm++L1YoGITL9ujZNtpcdexdRUsoruJ/QEGB+e9S8feBc40u3eH0s64au3zagy5eiF1TsliWmpw2z9ZXCHErd9Ls/pQQnSBEZayQzyVJ74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526913; c=relaxed/simple;
	bh=mvjJbKe1Dkkn32Jfos8g7UTcqeznkDAGiES6FJ+rNWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KT45QZR1lOMXN/WGN8LtRd+KLTa9mN6MineVilwa328sgVkkttmrVxpk969T+X4/TobvsWrEj8aMe3lhWFLWcIatKs+UZC1/QdGKpDLW1mn22/hYLmZuHUwOVMSVkolWDsympxQBN4VEZG3vL0LUYKIrjToM5BbrH/qA3KSe1wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PsxgBfqZ; arc=fail smtp.client-ip=40.107.243.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PsxgBfqZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atlfWuRlY0UuwjcPE+C5+iSjzzucgou3ofYn1OzaMxs1HPtx25fnrws3XU4OihJjcWrkVL7v6TW+wc9GoObGsK2+jYdYC9B16rf8c4JU2d4T20Tygk7g7lGZ0zBkJWqXIjuN+xZp/fAGM4GGyFY9pePQkf3s8p8ckCb/mARoLfU3pTVWQ+s4u7b1JUlFmzWG9Uo4SWkn3T2Dg+WDEQSVkwvl79t2ax6LvmHTBc2IMfwO4fqWvs99dpO+rlGstGu26WDHLV6IvrxPy246GVNbA9RMppYTJ3BU2mCVWfe7xvcescTxDJiUX2iwYZddm2gSofDTpTC0Pqr3YjBeyFSkNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lm556I7snJ79YmHORxk/lTafiRkW0nOpUd/KPwuGsxs=;
 b=J58l0C8aYmanclcAh8HHV1CpiI7ll4NTWQTgiCsLTRZtBqsF2h3/LxdbRM8UUqnCdXy852qspaxcM7l0TA56Zsxmoy71/CQJ5TJy5lZvqusIwJvEtyKZFfoJl1k9a8UfL8EiYTgrtL/TXcMr4H9o5pUPzTk+pMGsGKTC1zplcpw63524zLkG2KltKemXvEx/ZHnpiNiMBKoEKtrSkAGVnd/YGytuPVtmmJgeb3227Isr8fdu54k9nWeMuUvPDlv61EwBuefo0ziVoU1Hbe1bjWCT0fedZPVIOvAaFL12DpLEhzIap/wgjyb55tH2XB2BjYSEAmOTamIigVMeEq9BNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lm556I7snJ79YmHORxk/lTafiRkW0nOpUd/KPwuGsxs=;
 b=PsxgBfqZxYE1uqxixKkcMztmf8zdhrtiPUMW0GKEtB63LWVqMb0AKbBI8+tiY63CkN2cE8+VxkpVHoRtcTwtuKw2zuul5LislvAsBDsU5lTtJJ+RG2oEbBvoIWaehK0DS4lB9TGoLHGoyFi9rYCoMKeMC8gKJs2v+5dfNfN9WpeDnHrPSlKdjPHhbE+4+d1ziEv+hpDLUQW6o0wh7IprlbV8l3g92VJUfVT/tey/+4XGN//c7LveAyGtg/u5fTlfBNODhRNQiexEMKZv7vF9wQSDicdt/pzWJKFb2ZB0E1EuTABIm+R1i1S4wEn7xHrdDPvKbLNUPy3SuloroSAUDg==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 IA1PR12MB8311.namprd12.prod.outlook.com (2603:10b6:208:3fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 16:35:08 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 5/7] iommu/amd: Change amd_iommu_pgtable to use enum protection_domain_mode
Date: Fri, 10 Jan 2025 12:35:03 -0400
Message-ID: <5-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0360.namprd03.prod.outlook.com
 (2603:10b6:408:f6::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|IA1PR12MB8311:EE_
X-MS-Office365-Filtering-Correlation-Id: d684cd16-0f0b-40e8-02f2-08dd3194bde3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5fmzrSVeEGWotB/6AlAHv2q67LwHIRHQbJ5A4Ywrhj5B+wb0ubseejfsC5ao?=
 =?us-ascii?Q?bEMkMBnllRZ0t/k0jW8E2lkYF7qF0u/29sig6zrFvGixXp9LuTJUsckJcS2d?=
 =?us-ascii?Q?xFDrdoJg4RdAVnP/QjKObYnNaV1ZUkW8hysPYQfw3+78uSdjA+DDUZia22La?=
 =?us-ascii?Q?MpVBXGdZbbHCBLv6NPv9D/Pgi8sIobHjsYdMZQAGozPo/lCbAibM9MC0ZfJI?=
 =?us-ascii?Q?RGVm6gur7jtS0jXoW6dCfNc4VyJSFLthFSVUYqroIcYJ+5MQXolT8CeDIUih?=
 =?us-ascii?Q?td6D3fReiYnWNvQFJesHNEyo8ArB7/B5FBrSoO7TuI4ih7BaNlL7vWgmcz6r?=
 =?us-ascii?Q?Ry0+2fIbPjqR5jSjvUShik2R/ogz6c91O7kwYDu/qXb+J13sGQDAZUtiCA/J?=
 =?us-ascii?Q?pCoyLBczCD/L09jSviWYnqJnDmSOY18O75TxH7yQL+U/fhhbF+trxH1vca63?=
 =?us-ascii?Q?Wu4KljQxTBHb8PxGxhil/rxyiH+A8G0qkvNBH3Q6ipW1hpyBCSUybGAETzAB?=
 =?us-ascii?Q?nTAttsjNCnly29dufZKNjsgcc9+6CGkiPClpWa/339/z9FE81YvBKvDsJDno?=
 =?us-ascii?Q?hQlwI+ea16ZIbqv2jk+zIgp9pA1c+gnRk3KjISALQxiP4xt4fWU+ogR5bt3u?=
 =?us-ascii?Q?Db7SQMbsrMaurykb/mjciGC942K5o8Mz8XlZCMRUd7lYorKVfl6mymwchauk?=
 =?us-ascii?Q?RH7wypcmMlpy8wKMw1n+UrFiw973pifIjBJ/3/gTpp6JgePKs7WWbUSLCmMv?=
 =?us-ascii?Q?ZYcZJf12IhtmSwM+hY+pPfNFzCuieSxOovQKg6ZRspWonWlAXSCpDiDt2Pm+?=
 =?us-ascii?Q?XMHT7zC/mIpeAQoFMTfg3PzTIom78uFjWnGuLkAO5LZaXJohcXqA0pTIjY9o?=
 =?us-ascii?Q?eYjIaF75LBemvhPtsEW5lKmWy/zbDolkdMq2PitQKL1/3kWPb0E7bp/qEA2p?=
 =?us-ascii?Q?lRMDij8R7zZJedAnDAIpAzt0IfPwnhMDdmLAF4hLBu88TffNo+hEir22HtP/?=
 =?us-ascii?Q?DQJ/9hZkhDTqT6yycxxqghrmtPWPOA2rxlUtfD2mEzRdkRwONVq18dEupABg?=
 =?us-ascii?Q?p/a6IKVwyt/Y7x178zcEmKlUOgEKTYYr4vcPuRL6sywa90rq/DmonWwaLFff?=
 =?us-ascii?Q?wG1Pcxk3YmpK9/VgjEN4iGb/7/1dzzrf0H8rb0LpksXMF+tItXT1lTmJ+kAo?=
 =?us-ascii?Q?wNk45yEnarTjoSX54IZOe+uJVjg5JRknd/Qf9zNoG6+LzxkkXHjsO5faQ3HR?=
 =?us-ascii?Q?IqsSaJW3ql1On6GuqRWQXzMRXq28+wk1T9Ec7PjZa69XrD5frzYkqNCFgZDg?=
 =?us-ascii?Q?59qpx1gtbF8xXcTXbzHTcURhy8sLXh4F8AilFDZ1UJAYLUfcZ0CpBoz+B7YD?=
 =?us-ascii?Q?kdIM3QxnTXyZ59jY8tde36KRhT4i?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rX1NWZLjs4PeSFLoDQqkGL+FW3FDTZqwY8aimz/EpwwyPbRgOsu8+CgAmh6c?=
 =?us-ascii?Q?U7eZhEvoe9GNO2smAcULtLINfoYlcZkmsRUmGJGjwBBKiuxrOrekF44x1Qnq?=
 =?us-ascii?Q?LUDhhQWd7XnqGdWTxJDygqR+vgcdATFOPkxB6VRV5Mz5MvPHHfuoc6I6JSNH?=
 =?us-ascii?Q?5Iezxb49Mdyr0t5bh9w413hLSwhNQMuzchyKwxDaS3kBavpdHK1hP9qpe5+B?=
 =?us-ascii?Q?QsJgE9u8PxMixnof9FRoFvqtcywORNfn52+ABu0leHi1K6Umx9oPeqgqJurs?=
 =?us-ascii?Q?oEDXNK7vZ335b92sCqkMullscUJO5b7/sGcPYL021GDVvtq8ShbMj5FwCigz?=
 =?us-ascii?Q?FworRmEcU7fypUbqJBWsLKnlVaU/nr0iIBhTigGUid6zNbh1dkh4l10MEC4A?=
 =?us-ascii?Q?9F7bgOXxKSv4W8bxwnyhvdghWnpbNSQhZTXlexL869Opo5p5arXYDHrBEaPQ?=
 =?us-ascii?Q?mR3oTwwyJ0f15OPodfgVj/5LK7eEuXHkgvnHNXrTygezlElyoKnupmRpgRBg?=
 =?us-ascii?Q?qD+WzciqmMpZbd1bVkgLvNawiImLWZeFBOr2jKMg2ymQcTAJmKBhujX83Len?=
 =?us-ascii?Q?PZaKtj9HOkKAb/59h/2tUuOi5jOx+0tsMXqBHZiUTALo9UZXf9kkEscIpmmG?=
 =?us-ascii?Q?Do+kMDALlY76Au62nH4dC5ivUBUdmnwxhQtv+GtSQf8hgNrGU+tNxVxPGSR2?=
 =?us-ascii?Q?MpQKdlZGAJSq2GfqsH+Ncy1Inn+ECmYc9eZiG0y59TLLTwxnjX5A2UFC8oO2?=
 =?us-ascii?Q?WYd+x/LnijQL3O6sWH4+MmWvtK6m1vlBMQSQ08L26KIRUByE6t7XFLSD8Xmw?=
 =?us-ascii?Q?FIms9qdmLrnnaHHYiiCHdJ6IjOSzmtDlSUCPKFLTAaMM0iNVPnJ087M9Lj2M?=
 =?us-ascii?Q?+go2qolWcPoZgPrlAkY8N2wz8FT8AGRw8stqXYdyZBEi7rHMh9QC1LQsMvvg?=
 =?us-ascii?Q?TmhEEujhhKOcwHd33yOQEPY8Lmg483kEMw1YrltqhxAa2EI7rZT86LoVJGlV?=
 =?us-ascii?Q?EodjrTBQmGsQ2dMQ+UgqryJ74O0E2R0iCg+q5oPmjokH5W9E1TiyOf4jVUgA?=
 =?us-ascii?Q?a0SfeqhilwnnORjI46mMS2qp4nZwUJ62Spr6pe6tGBBH033TPPaCxTdfjKHe?=
 =?us-ascii?Q?7mUtd/7wT/FVL7dckMcim1gcJg3nxYkEbnr6Afp+yz2mt5lJbXhbZc2g/jpV?=
 =?us-ascii?Q?sXP//DQMpZMyVwEP+RKO5qgvUY2C/sZahvCFRQWS7w5f8HofNxkWqesrylRq?=
 =?us-ascii?Q?TuDrrePM1oTOtYeMS1wCyNVOKKZRA0/MRwAF9CPBXwPtxKZYuOiLlS7MPyJi?=
 =?us-ascii?Q?Kx25aK3sbHJX0SS/bmnbW9LxaTX0HapM9L1dJzLWM7w9CiETvXNTAdi1y7i7?=
 =?us-ascii?Q?qst5NHF6snkua9QBxODSebfdJ4yTK+iP9wvm3WQiUwgjCJgEKeFZhGlUKjJu?=
 =?us-ascii?Q?RlQBq3BRxgRTRSwK78KF3yBoTAQOeVXn0jUP4X7Vc1ko8GPD52r33pgkTC6/?=
 =?us-ascii?Q?ctgK36I9EBpwQMkYsX0uvEd6pM4MASzFpB62gVulG+2ClgS38MgWW0NfnaF7?=
 =?us-ascii?Q?wq6N0FTbH7ZN7bklExJ5FnlSI0FEh+J1Ly/Zj/um?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d684cd16-0f0b-40e8-02f2-08dd3194bde3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:06.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+VSkN2DFKXd293j1H7geNuac4B/ghDxTTY+KhIeEJESP+5YBDnAY8J9a3ofMoVt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8311

Currently it uses enum io_pgtable_fmt which is from the io pagetable code
and most of the enum values are invalid. protection_domain_mode is
internal the driver and has the only two valid values.

Fix some signatures and variables to use the right type as well.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/init.c      | 14 +++++++-------
 drivers/iommu/amd/iommu.c     | 34 +++++++++++++++++-----------------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index d6f4cf8235992d..0fb0c8392b5307 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -40,7 +40,7 @@ void amd_iommu_disable(void);
 int amd_iommu_reenable(int mode);
 int amd_iommu_enable_faulting(unsigned int cpu);
 extern int amd_iommu_guest_ir;
-extern enum io_pgtable_fmt amd_iommu_pgtable;
+extern enum protection_domain_mode amd_iommu_pgtable;
 extern int amd_iommu_gpt_level;
 extern unsigned long amd_iommu_pgsize_bitmap;
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 9db8fd1275bed9..1d0a82ab9c1c6d 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -152,7 +152,7 @@ struct ivmd_header {
 bool amd_iommu_dump;
 bool amd_iommu_irq_remap __read_mostly;
 
-enum io_pgtable_fmt amd_iommu_pgtable = AMD_IOMMU_V1;
+enum protection_domain_mode amd_iommu_pgtable = PD_MODE_V1;
 /* Guest page table level */
 int amd_iommu_gpt_level = PAGE_MODE_4_LEVEL;
 
@@ -2164,7 +2164,7 @@ static void print_iommu_info(void)
 		if (amd_iommu_xt_mode == IRQ_REMAP_X2APIC_MODE)
 			pr_info("X2APIC enabled\n");
 	}
-	if (amd_iommu_pgtable == AMD_IOMMU_V2) {
+	if (amd_iommu_pgtable == PD_MODE_V2) {
 		pr_info("V2 page table enabled (Paging mode : %d level)\n",
 			amd_iommu_gpt_level);
 	}
@@ -3082,10 +3082,10 @@ static int __init early_amd_iommu_init(void)
 	    FIELD_GET(FEATURE_GATS, amd_iommu_efr) == GUEST_PGTABLE_5_LEVEL)
 		amd_iommu_gpt_level = PAGE_MODE_5_LEVEL;
 
-	if (amd_iommu_pgtable == AMD_IOMMU_V2) {
+	if (amd_iommu_pgtable == PD_MODE_V2) {
 		if (!amd_iommu_v2_pgtbl_supported()) {
 			pr_warn("Cannot enable v2 page table for DMA-API. Fallback to v1.\n");
-			amd_iommu_pgtable = AMD_IOMMU_V1;
+			amd_iommu_pgtable = PD_MODE_V1;
 		}
 	}
 
@@ -3208,7 +3208,7 @@ static void iommu_snp_enable(void)
 		goto disable_snp;
 	}
 
-	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
+	if (amd_iommu_pgtable != PD_MODE_V1) {
 		pr_warn("SNP: IOMMU is configured with V2 page table mode, SNP cannot be supported.\n");
 		goto disable_snp;
 	}
@@ -3485,9 +3485,9 @@ static int __init parse_amd_iommu_options(char *str)
 		} else if (strncmp(str, "force_isolation", 15) == 0) {
 			amd_iommu_force_isolation = true;
 		} else if (strncmp(str, "pgtbl_v1", 8) == 0) {
-			amd_iommu_pgtable = AMD_IOMMU_V1;
+			amd_iommu_pgtable = PD_MODE_V1;
 		} else if (strncmp(str, "pgtbl_v2", 8) == 0) {
-			amd_iommu_pgtable = AMD_IOMMU_V2;
+			amd_iommu_pgtable = PD_MODE_V2;
 		} else if (strncmp(str, "irtcachedis", 11) == 0) {
 			amd_iommu_irtcachedis = true;
 		} else if (strncmp(str, "nohugepages", 11) == 0) {
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e2d2cab4f8324b..4ccf373e315da1 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2476,32 +2476,30 @@ struct protection_domain *protection_domain_alloc(int nid)
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain, int pgtable)
+static int pdom_setup_pgtable(struct protection_domain *domain)
 {
 	struct io_pgtable_ops *pgtbl_ops;
+	enum io_pgtable_fmt fmt;
 
-	switch (pgtable) {
-	case AMD_IOMMU_V1:
-		domain->pd_mode = PD_MODE_V1;
+	switch (domain->pd_mode) {
+	case PD_MODE_V1:
+		fmt = AMD_IOMMU_V1;
 		break;
-	case AMD_IOMMU_V2:
-		domain->pd_mode = PD_MODE_V2;
+	case PD_MODE_V2:
+		fmt = AMD_IOMMU_V2;
 		break;
-	default:
-		return -EINVAL;
 	}
 
-	pgtbl_ops =
-		alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl.cfg, domain);
+	pgtbl_ops = alloc_io_pgtable_ops(fmt, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
 		return -ENOMEM;
 
 	return 0;
 }
 
-static inline u64 dma_max_address(int pgtable)
+static inline u64 dma_max_address(enum protection_domain_mode pgtable)
 {
-	if (pgtable == AMD_IOMMU_V1)
+	if (pgtable == PD_MODE_V1)
 		return ~0ULL;
 
 	/* V2 with 4/5 level page table */
@@ -2513,8 +2511,9 @@ static bool amd_iommu_hd_support(struct amd_iommu *iommu)
 	return iommu && (iommu->features & FEATURE_HDSUP);
 }
 
-static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
-						  int pgtable)
+static struct iommu_domain *
+do_iommu_domain_alloc(struct device *dev, u32 flags,
+		      enum protection_domain_mode pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
@@ -2525,7 +2524,8 @@ static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	ret = pdom_setup_pgtable(domain, pgtable);
+	domain->pd_mode = pgtable;
+	ret = pdom_setup_pgtable(domain);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2563,13 +2563,13 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		if (!amd_iommu_pasid_supported())
 			return ERR_PTR(-EOPNOTSUPP);
 
-		return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V2);
+		return do_iommu_domain_alloc(dev, flags, PD_MODE_V2);
 	}
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
 		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V1);
+			return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
-- 
2.43.0

