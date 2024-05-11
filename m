Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57B512B95;
	Sat, 11 May 2024 03:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715397173; cv=fail; b=SO8vaNGBwHsiSH4wzOoIZ+wSQ4tkFbYWNB91IWxTxxFXg1S5U5Ft5xoBpU/K85Ze0+dKx0J3wCpc+HtZL+mfCfKIr3dBg6IK3bbssEPx9CCSkpBlfVYShc8AGeqdF7IsCd2c6g+AjEByAOI212v981sNZHjeeeH2nIiS0h4+0J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715397173; c=relaxed/simple;
	bh=35KKhEkkZZFmhEJHaH0436GDsTGNHGxXl35CRefo6ws=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBjew0oLHyvtglEzvMr+Pjbt/9RgW8zHW3nS31ChYtd6QEENw/yPfdXkYKLRj3ljx3aFJEktwi+BFIY3j+NCWgcwJSZubs2SlmyYGcGAaEs10g7QiyPpdEbAOCTn5Kt31vyqEnsrjwnAXOsrGOLDSvFCpHdzhwcsMZcYBNOzqJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D4mOrF9b; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D4mOrF9b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gq1R3Yg+dfBip7SIn/PLNsvaF18kYgv7IMG0SJl3n/tpgtKXtLLJH+ASMR1PNHqji6V5XLv0nJWZnw4ULmYkb2Gs05aNvLnTzpMR9s6NI/kLdlUqd99AmYN0b3fWV8rEb9WYqQv6qh14rN++kQ3WWlIWOJIAfL7Ua3ZzfnxVqCXv5TVGEMektTuxK45x5/R7fmOaUcADVIqPV0Eau5QSZUMVumQy8/LgPvSgVGZzKfhQVR0X0nVV5MIizqBnahfDw2gZaeixypGG7fbKtQXOzH0WpMlJHrAqBMDq8m2A7zJIH8tcuaoCxBP9PHpnMnc11SoecatRubo/w4+mA4MItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhNQaZE3pkTBUF5ZDfVzT/tkG9+VTWH99l/MZlyraBo=;
 b=KqttpSReHViEqCmPdQt1G4LumhkccCgRNpkfdaO7u8/foNi/MCgKsUhAlDujW6/YOb5N6I3WxCnT5yR7Iv5GO2HSUCUh8lLuW23hVKEmtb+M0jgBioX186ywhedAGZtI1msFqrco1ONNpkZlsHiDLqbiy9mbQIiJLPKw9TadNrSWilWgh2yhw01j3dfn/eT2cbzM9haEBtSn2htzMtHngmqjYtzFtKypSwt/fEmwE0q1yG7Vc0atjtxlHsmu1yvPbEVhDkZpnhmdtML29z9Il3G94I7nGCgn0ok7OUC5b/2hjB7/koEGT+qHXU+78ZpWDchnVWMKcLJiJSTpxDfWZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhNQaZE3pkTBUF5ZDfVzT/tkG9+VTWH99l/MZlyraBo=;
 b=D4mOrF9bGXUh7R7UCUQjRI03VLQMCiy+X1wDo+vyMy2PJv0TKmRD1RaT8kgN919uYR9Trm7crDdIZDZDyyfOkDdPDmBHpASy07G1RM9fRnovqxQadOdQdbyOQUkxdaNK6FTARcWCmUMPRlC1YDWYXWIpoJ5/1dsHMu/vrhgc/2XGzaPqR29A0pGDaGNiBXdS3Mw7dSrdVR8dN88aO/8Ndt8F2jNd9NPoEr4AwdFxfj/3y37m9sh/GuVOdC4wyHEmt1CBpwA8U3NE1/d0vzzJTbDW0ga0/OB41rGpSn95PoD5GN1m+/++QHGn3F8G8aZIEphzIXHqEWcOEmpbeY6ldw==
Received: from CH0PR03CA0092.namprd03.prod.outlook.com (2603:10b6:610:cd::7)
 by SN7PR12MB7274.namprd12.prod.outlook.com (2603:10b6:806:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Sat, 11 May
 2024 03:12:48 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::c5) by CH0PR03CA0092.outlook.office365.com
 (2603:10b6:610:cd::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Sat, 11 May 2024 03:12:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.18 via Frontend Transport; Sat, 11 May 2024 03:12:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 10 May
 2024 20:12:47 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 10 May 2024 20:12:47 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 10 May 2024 20:12:45 -0700
Date: Fri, 10 May 2024 20:12:42 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 03/14] iommu/arm-smmu-v3: Make smmu_domain->devices
 into an allocated list
Message-ID: <Zj7iKtyWV6tAEo0L@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <3-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|SN7PR12MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d2c49b-dcb9-4835-ed10-08dc71683c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|36860700004|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0f9yWE7AxAGahEBoNFJ+9VGmt6/2YKHmi6NflTu4z9QIjYEeifWcCgnu4WRX?=
 =?us-ascii?Q?+hq3enaYs2mf0c0chNNp5+Jeov/S1ealESDkhko+ezk66Tvb4G1YkG+9IQHW?=
 =?us-ascii?Q?5PGsnL6/F6mv0vohS1U36acn7T4y9fCOEqMRXPH46SBlUBPcLBTqaplnMEyQ?=
 =?us-ascii?Q?KOLFTI6NNzzhYD+19o5aD42goZKzNzXK1YFfKZPROskSha7QnjA4oFIDVPtE?=
 =?us-ascii?Q?pelsQEiuFrndu9wOR8B6+ynH0y7Jy3fd8++o+Jcwn5Z/y9iLn0x+YLzR1G31?=
 =?us-ascii?Q?ZGbYknwwDmBLd4TvcWX/8OQUzTRbKqQ3RH+sahehrR3t3JLLIuUd3RjANAeu?=
 =?us-ascii?Q?wWe10a/TWvngIeS2dUMLN4JW5CM/BxySIGY6WX6f4ONsZvVZzxDChW5L25bg?=
 =?us-ascii?Q?rqhRrzkstW0EWKvE/JPQv3aFWWZS/Fx029iMZiBHIVWABiDXRsDOxADpNDNy?=
 =?us-ascii?Q?L9tk2a3t2POj6ph6Ls2PWvTAfnpAYJ8SBUnpy+M8as9tCfYVFGPSLU01nYwc?=
 =?us-ascii?Q?5x26AwGPD2LgfNxPxAYjF5LemczeJ9IE33IxMTCBQRe4gzkif85iX3/NeTRK?=
 =?us-ascii?Q?nFGjHtVdg76JWaR7wrpGtEJPEsoMK8e3v52J1HR7n4EfAD/Znm/vpp3gxSBR?=
 =?us-ascii?Q?Q69/7FQJ+/NWb2tVNOy7l4zwui21cgq5cdkT7CxyyFn745hUl1TZzZiT59os?=
 =?us-ascii?Q?88KbXdLN6sFDCuzPiPOMHBs6Upntrs0Ke9yPEHi7j4WEyBvfFjYDpdtMJTfb?=
 =?us-ascii?Q?KL4OTafz8VtYEbQ85EWR6Z5JfPMTBxf/KSfRind6hPEUz5JtSnr6297ByJru?=
 =?us-ascii?Q?kP5BMxMgWa1kGt5oE+yeoN3p3uqYp4uqtmmXGdj/8Br/KtW6ishw7Tp+XOPD?=
 =?us-ascii?Q?mo53JzduFRfMXUoldi1t6Jkooqqdhx86Agzu9s9gG69JQoMPKWTlrXS7Xt31?=
 =?us-ascii?Q?QTfx7ynoBH4QHzD918liQFn9wZiH9Kppvk+3FlcHpoAe/rOU8O/s02KKJVNl?=
 =?us-ascii?Q?ef/I2iCxxPddgX7aSMDXsamZ69qS7p8QUv4u5NGca3fxAHmmAvjed1Ql/p5t?=
 =?us-ascii?Q?+zkWW5svdc+XLj4jtKeyIYHqIJQmGTd627b8rQIcx4DAXX1eJ6zNCPH3lMuk?=
 =?us-ascii?Q?Je/LjBXLu2a0hbwZDFC++Slwr3g7XW3Ft3oJlqjWJKA/1VMuTiiznL6WymBN?=
 =?us-ascii?Q?IHBHK8AwInXyMEIkvjw4vw/Ke1Wv2LvDwjFKzmB5zk2U/phfA3689pra7K8C?=
 =?us-ascii?Q?22dk0eAJvgy9U54uURd9sf63CwitANrljXaYEJkdi/Wti9scs5IuE6RkslrT?=
 =?us-ascii?Q?EaBgcerRQnYhYJkA1naMxNAX+blgYw8vupsYmy4a1Pbzwb3ai7Cu25vmyF/U?=
 =?us-ascii?Q?hwkf8UY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(36860700004)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2024 03:12:48.3169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d2c49b-dcb9-4835-ed10-08dc71683c76
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7274

On Wed, May 08, 2024 at 03:57:11PM -0300, Jason Gunthorpe wrote:
> The next patch will need to store the same master twice (with different
> SSIDs), so allocate memory for each list element.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
