Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4113233EE;
	Thu, 23 Oct 2025 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243771; cv=fail; b=fByiYxS+eZANzmO+njRrSnTpCbxVhSBsfJRF/oPb5SkyOzjvFnOm7mdtCV9ekBVx94wpsFW5Hhw/d/sY25nwMEgazrhgqEiYKEAr6JG08N18rsJehMChn0EadCkWW/EzOpNj4GDIUF2gpVqDv8mN6lUgmEYvOBv7b+bIxwGIVgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243771; c=relaxed/simple;
	bh=UTwgG6fEDCxWDfTwST/6aS8SQJ3lfocOQ//Hfz8NmLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c5Bjqh0Yxa2hx9n4tYINZ1mOHiteYKCQF4lqDPUUFVCSPBWkK+BIYq/UOpmq8YL2X8mtIV038lfIxmTEhnB8ZGUi5U1RyoebmYt5UwiRT56u9Ka7ovY19zH8u3eTkxtYTcyUoXEVn6pCJpXfHaufA30wl1P4s3UFHa+LeRcWRDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eqqMbrSR; arc=fail smtp.client-ip=52.101.46.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eqqMbrSR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKdaXIPSDrAw2AcBTJbe6hgXjrm9PARwLgj9I9pcA04/Z/18j9quD3ZpY4ZJE+9txy3SDMLI3sawLZsEUnWR7xoYohoMvafwoTdhk1BnsMNTgvbzKVNOZA3MiNVmDRv47A/Q27JYLKPHrt7DMG2bBSdhrJnrMcNsYeZsgr1JBw7Al/y65WHDwPZ35cvudI+f1E+4jmwTX/EPKQmr4rXoLSJZnvK49zBOEqrV7bec7NzP33Zcb5aTm1LUT0/seb3hoDate540boddM519i73xgJ6Gdsm30/c85d4QuDlr6fXEeKXEac8O62Vql5x1oyqBPNqbAhbhBCxE3Lybk/giNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWrfsMKRRSMcpwgFCp2ALUy3DspZ5qmG67biaIj/Ha4=;
 b=OLUR4J2fhxxiw4ZTevewefMuD2FqpsE9TeyVjRTpsJXmTO/HHZyYw9ZXvKShqf///bdf3aTPWxYhkIZFegbCRm5Qzmy46UBvdm5tp8dSSzNjy7BX9eO2vIae2qvcfqyGO8a4CAOBHnxEkkcYTocow4RWdDzznYPwOnM3Zbq+sJP6UgqOa/eznlGKI1qDcmNiNpCnjujqMipKQTvLFQFApFTOqdCFT82G8v1DW61oBiM5Gy4CV3rpcQf1RBv01MfHuiViOd6VTsrFXLe/LuN0qmws+T54ssTV8odHVgAr0MkW/NU7YhvODMJWJVM+4XgAoLDRlmfoRFR++LuZdcdLrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWrfsMKRRSMcpwgFCp2ALUy3DspZ5qmG67biaIj/Ha4=;
 b=eqqMbrSRA2ykR15YIk7F55uSyZqXP9huWtU6qbHtJAkcr1YEsrTAtiA0LLWSMHHCVOxqoZNLa26hTKd+HZgcFwPjvCV9I1jPAGwCuDolD4r2XvnapaVHlbSyjYT7BNqU95qljV1lw+kIKzBNMqcYWggVVBqCHHlgre0xc0F3Jqrgn+O5qWfKxFPS22j+mTVxa7ILyiKS2lnb5sCqatcPtk7BryLfcrqfcGZ1frZclm4l5r1orcALPRX9C3xL+Xni+CffIRNLJbZgPkO68f8g4nXMl5+l3qXVJVlvszOdvj6B7xS2JjY3j7Jzolw6qiikjAU0QpLDjm8wBili2VgUYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:42 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 05/10] iommupt: Add the Intel VT-d second stage page table format
Date: Thu, 23 Oct 2025 15:22:33 -0300
Message-ID: <5-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0135.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::20) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bee6860-2cf9-45e9-9d1a-08de1261273c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xlWRInEULEMtoTHDkgHKvJ1rXB2CoCgbREE+EGNk0M+Ql/f3lN4/HgwUpZCf?=
 =?us-ascii?Q?XsUwmUiWCkbrKjVq65EropJXwhz03gwc7FmwxtgObElNKyFz6LrDOWKio4Ch?=
 =?us-ascii?Q?zTs2WrgfqlAr1MSdRpEwZFxRmNNr8l+ghAKbNic620z4oiH48S4VMAimH4jm?=
 =?us-ascii?Q?bpsrNDfAdsMJiDvyVE1QHIElMwPBhHJ7kxnuS9M0+xroJYfLQsVj7D+SLruf?=
 =?us-ascii?Q?FocX0ikw4KK24G3xpDJnvf7+sOqNJpfcb8peu3FG9XP0UNQVYU4Ohp/qyh0N?=
 =?us-ascii?Q?fxQNMnLcmMHGjK0ZWvHNW5PJElm/vHZbz/dZbMh4/xi0D4jP7C9Sx+Sog0n4?=
 =?us-ascii?Q?CYivhMWTxNC0yqpgzxlO63TF+dwZPu+iMJtyHqAnsRFagIQFpaC9L3IH07P4?=
 =?us-ascii?Q?HgNloAK1a38v0CGVGFJKe91qTD4EYu4jMoFeamQMUQX64Ge2uYQQoEenARsD?=
 =?us-ascii?Q?m0n4MBluD9ima60nN5mRgYZcdj9ZhV6rxBmbJmpO/f3X7J3fB54PGsfJor0q?=
 =?us-ascii?Q?g53OUT1gQxyUreKPBmSHBi8dO12YbcrUuidW4MoxxI91NlMf1+1/m3mQ1IIL?=
 =?us-ascii?Q?ecUwnPECWe/yhpGLC8h75m1INSbHuUtnRZD+Mr7Re/uKw88Mp/EQeFZ1hPlT?=
 =?us-ascii?Q?YgB56nuktpsvH0BxW9rLVD3E7IQbzanrfzF/VUczdW+SfU5BnXzXg6tjdo+9?=
 =?us-ascii?Q?TMh/mdxThzG4Ma8WdJ04gRVYHkeqe9ynV9wRBhXj+1ZJ7ci4FRWjmjvcEXmv?=
 =?us-ascii?Q?ECh55Ufa4yhWDKQQMGqZVKcIYRZ2PrW1ouuEGP7Ew1bs+kDoIPYr9RjQwGUI?=
 =?us-ascii?Q?guA2ub4Lzuf+9/Kh9Gyuz17xUdA/lw9lAP6j3KTONNi4kvLZKzfTkEhJyXou?=
 =?us-ascii?Q?XYJHxHLyqeZToQl3mS8byb83hxWqAAOZjiHodK8sJPd1POdX1XJB3gGcWbAl?=
 =?us-ascii?Q?KfSX3NlXtjNNQb15gcKKAdbxqii4F/atqgRkvQ76p6b8dHbsy97ICl+0V4Xy?=
 =?us-ascii?Q?fiZIO8EAHq55rQ8MF/QWwdkJZ50Xk3WIbRWPi4INS79rKjOfiRkJ2FRcmvV/?=
 =?us-ascii?Q?ticZsP2jYTvrbn1L3p2ezG4JZKZDgyGs2xGOcEZjiHgs/cLx68lkQ0XqXt29?=
 =?us-ascii?Q?gFKHEQ92EcIquWYJpHmnexUDKTNMQm9SXUvHTIwGRqIo9g2+EhQgyQvkC08N?=
 =?us-ascii?Q?ffp8i3R6JIWtUiIzcrWtSMdxziwbIFirAaoMzAN2QEXR9zkJJuweijykOxSq?=
 =?us-ascii?Q?7Rs5hT5W/7et7wsSY41Jabg+uMLX7B8IdLjQ4VRlXlwuhxEB3kBXnsXzMHUM?=
 =?us-ascii?Q?hHtdgF906t5MOl6Xv0XdUsozFnd82QRIla03+tyj+KNLUTmv9d95MaolG4sP?=
 =?us-ascii?Q?4cIXru4F03GmOAijp+QokGXmfRcqYS6Eu3xY+ufPN/NZZ1JLyFO/VJTep4OY?=
 =?us-ascii?Q?227FqZBwAS0FI3fErnxh9GTewxfzj+xg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OY69Y+mu93GWRG/Y097VrYLL9wtF9+r3cEXrCNv7F06kkzUrAmWYlgmO+sYT?=
 =?us-ascii?Q?HjNCgctgeZCu5tjrAY4JaEtuaZVVZhnJpC/VOssk/fzPtQLygSg1kiNM1jUQ?=
 =?us-ascii?Q?JBEJ38bozkXWBjKiW4xUfqeTuuuNhPjhuwcTEtgx5AEt2YVn7DRJbTKq4QID?=
 =?us-ascii?Q?wYfyRJil/4wr9SmwOA5KATDEYrdmoOdOmKwv64QVTWCTomvI+mgmaE5X24Ns?=
 =?us-ascii?Q?udJ0xEjRF2qPm9W4sKYa6CZ5bNVsstiN0jl4qoxMpyUVJweJVYDudISdubVQ?=
 =?us-ascii?Q?u3uMeYSaPrpyH4W8Z9zD7dm+BzT3tywh24/SothOW4gOuSqwSMa9GTtJqxED?=
 =?us-ascii?Q?B9mg8FOAYn/TGXgC0Hu0XQpZ3Ry6FoBvNKfV1YIuwFzPPiXR75DTSsIsiyWU?=
 =?us-ascii?Q?0ZHHIlLrpjWTC3uUzJce8ec2Xu4XnDVVa4dc5MowMj7HFiknCXLs8I+6V7vO?=
 =?us-ascii?Q?92onycRlBNVEQfr/3TQ8p4id0Fo7NKdEy8I1kMcnyOsyoOL4vZVifAYVW8Tr?=
 =?us-ascii?Q?W80AWOcl8D4Xwo6M9bo/IGVukIPPlShNh9+nc+aKzxnrv6rcRIaK2sAI2Xnu?=
 =?us-ascii?Q?VHJqOztytR1x6Rg7910RBxLdT4C8am70O+dW9CVjM4WuTfgBC8gAxZO7Zce0?=
 =?us-ascii?Q?TlDX38IQnHA6vY6w4qdgymV+LTdgmCEJHcDK24APVzT/AwjvB416vmAJ5/HO?=
 =?us-ascii?Q?WXy5t4Ck4fwuuQbwCM/btaSR+BPOlGX+MGHN+nsBiibRwpMl84q23qX0PM2M?=
 =?us-ascii?Q?aB+LthvJ31Ho9wAEcDJSfyhrRcIpLyxs1vPenORD++PZazR8JjbG2ANHDNEw?=
 =?us-ascii?Q?pB2IoVJs4Q/naLj4bbJA1W6Gde1I6DUzLy7Ww/z7tFIaDEz7MaS7NMWLme/x?=
 =?us-ascii?Q?Iijr9VjfL/wCs0AV/YlVtKtLrbth5PtGxzfotfdYtLS5CPxY9u2QdKoGfME5?=
 =?us-ascii?Q?iZ6kOHz3/qSy4eJc4dxJ1Smsaiu6PP/j5Qg90TjQOnpsIo16y08RBuhBsxeD?=
 =?us-ascii?Q?lmxDMR1+NaMZMcrpU0GhHWLu+NkBkL1wh8dmvHzuOWiYirIqWBmqNYqACB0m?=
 =?us-ascii?Q?HpyRe3Z2Go8onkbcDGsnZkvIQ8GK8sIMuf47FYLN9afNyAibxzqtbXe6cacN?=
 =?us-ascii?Q?hLnlpZlXeuJ3vMB8tz6xpyQBchtvXUjepgD5RJG0LlARWvGabqppJWA4cGz0?=
 =?us-ascii?Q?KCOyMTnjbSs3H6+FlxDibaWXrYYy3XKY5BL4GidT8CWEEXmHUiyC40lTdBim?=
 =?us-ascii?Q?TFBQD+3EEWOcYJpa25coXEuQ3l2y+CxWv7GG6b5KcYYaFdb/x5NEXWWtXhZ1?=
 =?us-ascii?Q?JFB2Fjorv5mynwIuFCFOZ6cpHfwxmEDJ41USOlk6zk7OJAB597+QjO9SmDxy?=
 =?us-ascii?Q?yh6Pe7Yz3e9yQQlScs+XTzZHVNIXCdgG7zHmUVhg6cCIkEUljPxT5szSMF4D?=
 =?us-ascii?Q?fmOzBPkW67lXOLQohrW2doSx9t4cYpyMBR1HNzd4oiJY1WZ5+X4o1Ms9wxR0?=
 =?us-ascii?Q?Ew4Io+7E8iaUoZ/Aeglm6mm5OPBnxWy+4I412FPrBemQta1F84cLBJffMXK/?=
 =?us-ascii?Q?vRXxIgc5jB/ZeBQQ/WPHKt10pGjFV90D+HU1oY2T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bee6860-2cf9-45e9-9d1a-08de1261273c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:41.7798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4tMxzRoftVRuc1LgpoLtmBB8sG04Kd++1OgQT6t+t14Y0kPqGCEARQV9kgTbCbA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

The VT-d second stage format is almost the same as the x86 PAE format,
except the bit encodings in the PTE are different and a few new PTE
features, like force coherency are present.

Among all the formats it is unique in not having a designated present bit.

Comparing the performance of several operations to the existing version:

iommu_map()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     53,66    ,      50,64      ,  21.21
     2^21,     59,70    ,      56,67      ,  16.16
     2^30,     54,66    ,      52,63      ,  17.17
 256*2^12,    384,524   ,     337,516     ,  34.34
 256*2^21,    387,632   ,     336,626     ,  46.46
 256*2^30,    376,629   ,     323,623     ,  48.48

iommu_unmap()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     67,86    ,      63,84      ,  25.25
     2^21,     64,84    ,      59,80      ,  26.26
     2^30,     59,78    ,      56,74      ,  24.24
 256*2^12,    216,335   ,     198,317     ,  37.37
 256*2^21,    245,350   ,     232,344     ,  32.32
 256*2^30,    248,345   ,     226,339     ,  33.33

Cc: Tina Zhang <tina.zhang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig      |   1 +
 drivers/iommu/generic_pt/Kconfig           |  11 +
 drivers/iommu/generic_pt/fmt/Makefile      |   2 +
 drivers/iommu/generic_pt/fmt/defs_vtdss.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_vtdss.c |  10 +
 drivers/iommu/generic_pt/fmt/vtdss.h       | 292 +++++++++++++++++++++
 include/linux/generic_pt/common.h          |  18 ++
 include/linux/generic_pt/iommu.h           |  11 +
 8 files changed, 366 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 5265d884e79cea..2f9b6060e3b983 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
 CONFIG_IOMMU_PT_RISCV64=y
+CONFIG_IOMMU_PT_VTDSS=y
 CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index dd12699fcbc9c8..42b40526d5e079 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -52,6 +52,16 @@ config IOMMU_PT_RISCV64
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_VTDSS
+       tristate "IOMMU page table for Intel VT-d Second Stage"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for the Intel VT-d's 64 bit 3/4/5
+	  level Second Stage page table. It is similar to the X86_64 format with
+	  4K/2M/1G page sizes.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_X86_64
 	tristate "IOMMU page table for x86 64-bit, 4/5 levels"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -67,6 +77,7 @@ config IOMMU_PT_KUNIT_TEST
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
 	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
+	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	default KUNIT_ALL_TESTS
 	help
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 9c0edc4d5396b3..6fe95fc8466523 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -5,6 +5,8 @@ iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86_64) += x86_64
 
 IOMMU_PT_KUNIT_TEST :=
diff --git a/drivers/iommu/generic_pt/fmt/defs_vtdss.h b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
new file mode 100644
index 00000000000000..4a239bcaae2a90
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_VTDSS_H
+#define __GENERIC_PT_FMT_DEFS_VTDSS_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct vtdss_pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs vtdss_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_vtdss.c b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
new file mode 100644
index 00000000000000..f551711e2a336d
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT vtdss
+#define PT_SUPPORTED_FEATURES                                            \
+	(BIT(PT_FEAT_FLUSH_RANGE) | BIT(PT_FEAT_VTDSS_FORCE_COHERENCE) | \
+	 BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE) | BIT(PT_FEAT_DMA_INCOHERENT))
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h b/drivers/iommu/generic_pt/fmt/vtdss.h
new file mode 100644
index 00000000000000..d9774848eb6f7f
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/vtdss.h
@@ -0,0 +1,292 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Intel VT-d Second Stange 5/4 level page table
+ *
+ * This is described in
+ *   Section "3.7 Second-Stage Translation"
+ *   Section "9.8 Second-Stage Paging Entries"
+ *
+ * Of the "Intel Virtualization Technology for Directed I/O Architecture
+ * Specification".
+ *
+ * The named levels in the spec map to the pts->level as:
+ *   Table/SS-PTE - 0
+ *   Directory/SS-PDE - 1
+ *   Directory Ptr/SS-PDPTE - 2
+ *   PML4/SS-PML4E - 3
+ *   PML5/SS-PML5E - 4
+ */
+#ifndef __GENERIC_PT_FMT_VTDSS_H
+#define __GENERIC_PT_FMT_VTDSS_H
+
+#include "defs_vtdss.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_ITEM_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 4,
+	PT_GRANULE_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+
+	/* SSPTPTR is 4k aligned and limited by HAW */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(63, 12),
+};
+
+/* Shared descriptor bits */
+enum {
+	VTDSS_FMT_R = BIT(0),
+	VTDSS_FMT_W = BIT(1),
+	VTDSS_FMT_A = BIT(8),
+	VTDSS_FMT_D = BIT(9),
+	VTDSS_FMT_SNP = BIT(11),
+	VTDSS_FMT_OA = GENMASK_ULL(51, 12),
+};
+
+/* PDPTE/PDE */
+enum {
+	VTDSS_FMT_PS = BIT(7),
+};
+
+#define common_to_vtdss_pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_vtdss, common)
+#define to_vtdss_pt(pts) common_to_vtdss_pt((pts)->range->common)
+
+static inline pt_oaddr_t vtdss_pt_table_pa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
+			  PT_TABLEMEM_LG2SZ);
+}
+#define pt_table_pa vtdss_pt_table_pa
+
+static inline pt_oaddr_t vtdss_pt_entry_oa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry),
+			  PT_GRANULE_LG2SZ);
+}
+#define pt_entry_oa vtdss_pt_entry_oa
+
+static inline bool vtdss_pt_can_have_leaf(const struct pt_state *pts)
+{
+	return pts->level <= 2;
+}
+#define pt_can_have_leaf vtdss_pt_can_have_leaf
+
+static inline unsigned int vtdss_pt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 vtdss_pt_num_items_lg2
+
+static inline enum pt_entry_type vtdss_pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!entry)
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    (vtdss_pt_can_have_leaf(pts) && (pts->entry & VTDSS_FMT_PS)))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw vtdss_pt_load_entry_raw
+
+static inline void
+vtdss_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			    unsigned int oasz_lg2,
+			    const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	if (!pt_check_install_leaf_args(pts, oa, oasz_lg2))
+		return;
+
+	entry = FIELD_PREP(VTDSS_FMT_OA, log2_div(oa, PT_GRANULE_LG2SZ)) |
+		attrs->descriptor_bits;
+	if (pts->level != 0)
+		entry |= VTDSS_FMT_PS;
+
+	WRITE_ONCE(tablep[pts->index], entry);
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry vtdss_pt_install_leaf_entry
+
+static inline bool vtdss_pt_install_table(struct pt_state *pts,
+					  pt_oaddr_t table_pa,
+					  const struct pt_write_attrs *attrs)
+{
+	u64 entry;
+
+	entry = VTDSS_FMT_R | VTDSS_FMT_W |
+		FIELD_PREP(VTDSS_FMT_OA, log2_div(table_pa, PT_GRANULE_LG2SZ));
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table vtdss_pt_install_table
+
+static inline void vtdss_pt_attr_from_entry(const struct pt_state *pts,
+					    struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits = pts->entry &
+				 (VTDSS_FMT_R | VTDSS_FMT_W | VTDSS_FMT_SNP);
+}
+#define pt_attr_from_entry vtdss_pt_attr_from_entry
+
+static inline bool vtdss_pt_entry_is_write_dirty(const struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+
+	return READ_ONCE(*tablep) & VTDSS_FMT_D;
+}
+#define pt_entry_is_write_dirty vtdss_pt_entry_is_write_dirty
+
+static inline void vtdss_pt_entry_make_write_clean(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+
+	WRITE_ONCE(*tablep, READ_ONCE(*tablep) & ~(u64)VTDSS_FMT_D);
+}
+#define pt_entry_make_write_clean vtdss_pt_entry_make_write_clean
+
+static inline bool vtdss_pt_entry_make_write_dirty(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 new = pts->entry | VTDSS_FMT_D;
+
+	return try_cmpxchg64(tablep, &pts->entry, new);
+}
+#define pt_entry_make_write_dirty vtdss_pt_entry_make_write_dirty
+
+static inline unsigned int vtdss_pt_max_sw_bit(struct pt_common *common)
+{
+	return 10;
+}
+#define pt_max_sw_bit vtdss_pt_max_sw_bit
+
+static inline u64 vtdss_pt_sw_bit(unsigned int bitnr)
+{
+	/* Bits marked Ignored in the specification */
+	switch (bitnr) {
+	case 0:
+		return BIT(10);
+	case 1 ... 9:
+		return BIT_ULL((bitnr - 1) + 52);
+	case 10:
+		return BIT_ULL(63);
+	/* Some bits in 9-3 are available in some entries */
+	default:
+		if (__builtin_constant_p(bitnr))
+			BUILD_BUG();
+		else
+			PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit vtdss_pt_sw_bit
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_vtdss
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->vtdss_pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, vtdss_pt.common)
+			->iommu;
+}
+
+static inline int vtdss_pt_iommu_set_prot(struct pt_common *common,
+					  struct pt_write_attrs *attrs,
+					  unsigned int iommu_prot)
+{
+	u64 pte = 0;
+
+	/*
+	 * VTDSS does not have a present bit, so we tell if any entry is present
+	 * by checking for R or W.
+	 */
+	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
+		return -EINVAL;
+
+	if (iommu_prot & IOMMU_READ)
+		pte |= VTDSS_FMT_R;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= VTDSS_FMT_W;
+	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_COHERENCE))
+		pte |= VTDSS_FMT_SNP;
+
+	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_WRITEABLE) &&
+	    !(iommu_prot & IOMMU_WRITE)) {
+		pr_err_ratelimited(
+			"Read-only mapping is disallowed on the domain which serves as the parent in a nested configuration, due to HW errata (ERRATA_772415_SPR17)\n");
+		return -EINVAL;
+	}
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot vtdss_pt_iommu_set_prot
+
+static inline int vtdss_pt_iommu_fmt_init(struct pt_iommu_vtdss *iommu_table,
+					  const struct pt_iommu_vtdss_cfg *cfg)
+{
+	struct pt_vtdss *table = &iommu_table->vtdss_pt;
+	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
+
+	if (vasz_lg2 > PT_MAX_VA_ADDRESS_LG2)
+		return -EOPNOTSUPP;
+	else if (vasz_lg2 > 48)
+		pt_top_set_level(&table->common, 4);
+	else if (vasz_lg2 > 39)
+		pt_top_set_level(&table->common, 3);
+	else if (vasz_lg2 > 30)
+		pt_top_set_level(&table->common, 2);
+	else
+		return -EOPNOTSUPP;
+	return 0;
+}
+#define pt_iommu_fmt_init vtdss_pt_iommu_fmt_init
+
+static inline void
+vtdss_pt_iommu_fmt_hw_info(struct pt_iommu_vtdss *table,
+			   const struct pt_range *top_range,
+			   struct pt_iommu_vtdss_hw_info *info)
+{
+	info->ssptptr = virt_to_phys(top_range->top_table);
+	PT_WARN_ON(info->ssptptr & ~PT_TOP_PHYS_MASK);
+	/*
+	 * top_level = 2 = 3 level table aw=1
+	 * top_level = 3 = 4 level table aw=2
+	 * top_level = 4 = 5 level table aw=3
+	 */
+	info->aw = top_range->top_level - 1;
+}
+#define pt_iommu_fmt_hw_info vtdss_pt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_vtdss_cfg vtdss_kunit_fmt_cfgs[] = {
+	[0] = { .common.hw_max_vasz_lg2 = 39 },
+	[1] = { .common.hw_max_vasz_lg2 = 48 },
+	[2] = { .common.hw_max_vasz_lg2 = 57 },
+};
+#define kunit_fmt_cfgs vtdss_kunit_fmt_cfgs
+enum { KUNIT_FMT_FEATURES = BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE) };
+#endif
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 3f80a3889ecc30..5e583a3f2d1f5f 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -172,6 +172,24 @@ enum {
 	PT_FEAT_RSICV_SVNAPOT_64K = PT_FEAT_FMT_START,
 };
 
+struct pt_vtdss {
+	struct pt_common common;
+};
+
+enum {
+	/*
+	 * The PTEs are set to prevent cache incoherent traffic, such as PCI no
+	 * snoop. This is set either at creation time or before the first map
+	 * operation.
+	 */
+	PT_FEAT_VTDSS_FORCE_COHERENCE = PT_FEAT_FMT_START,
+	/*
+	 * Prevent creating read-only PTEs. Used to work around HW errata
+	 * ERRATA_772415_SPR17.
+	 */
+	PT_FEAT_VTDSS_FORCE_WRITEABLE,
+};
+
 struct pt_x86_64 {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 574e5f46200b74..114ede8cee3d57 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -273,6 +273,17 @@ struct pt_iommu_riscv_64_hw_info {
 
 IOMMU_FORMAT(riscv_64, riscv_64pt);
 
+struct pt_iommu_vtdss_cfg {
+	struct pt_iommu_cfg common;
+};
+
+struct pt_iommu_vtdss_hw_info {
+	u64 ssptptr;
+	u8 aw;
+};
+
+IOMMU_FORMAT(vtdss, vtdss_pt);
+
 struct pt_iommu_x86_64_cfg {
 	struct pt_iommu_cfg common;
 };
-- 
2.43.0

