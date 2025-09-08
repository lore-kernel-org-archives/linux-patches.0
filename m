Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A82E1746;
	Mon,  8 Sep 2025 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357185; cv=fail; b=ihRlz0Wu9naOLAp+lL20KpJ8F3vuwpduYp6/DUEqmWaNd1PBFt3SQxOnIpyE35mqSaBwQy5/PUCIXqp/foYr1HCnIDdezcesh8GV1RClNfSEy1ZecEbHHgLLrpr40lP59/MMiyBDHOwdghyOF2Xcg8n/PqidyUy6hHm2ghG7h5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357185; c=relaxed/simple;
	bh=d54A+KkISLQVDUJxOreDuMe0VEKGKm3fdkfDgG1sjtg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdBFMulQmy5z1WXPuU2RgsRSA+DfWq4sp370ui6h4xWd1pK5iHW9cSJJO/WTHJJQVlTCVf5rqqTgopJoq62rkIWaFPWZbGvqQ0dw/mLtJ+ppXJFQQF3Q2LoeYLyBdzeUdOfWB77eB+Qlyr3FwqGA62foee+nGNJpS20bj6RJKfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hvPb7nko; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hvPb7nko"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=imMEB4FRJfs8PaFSqdtxzDE1ntamWrOz2IuDPyxAlhBGSIoPVO1Ddnu/SRO9n9PgXXoHprDJH+MxqFWCsd1HGm2qZgESZdLy+sZksxg7MIRnDPMCb0qnlyN9ODOG/xbYQhYmsa0530//Id8u394kIvOjm3sKayciUEl8RFIRn20XoXqoot7GmWOcjm8UG+hT/jc+bnOLQr8U+WoZOS51EmaMw/GkSmxnaVcpszVBVj70OGmrfvO+zCrMGOQd5Khe/PPrWgAA4DOsJPPkPiRpeA7BCNEWkrdnVsDaGjOEczJ4IVAa537TC5QrzrEWWEkH3iYzccRMr3ib8CAeR25cXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mq+8ESmA2jrfpQZOjprCU5gaKWY1crGMxvXWMhJyF9s=;
 b=Yz8fUgTvHKAGSWgSDJBQd7PlxYWo6yDkKnwXLUPkHpKmdSrisBMRLyoaYfrpM0yHGc0DDLclMIwky9RMZ7dwHHkEN8twayN4tEGPern5A1IoNCQyfHtCLAMNpifodUb2WByAKLEN1vyXogoLDK3aA3BxFTPhhua/g6+kptrOvfIIu6W6uv4up02rwRWYXCrw1OxLBpW6LNXfO7NqP8lcIkELnPf0XtSvOxaew979KJEGFacW/PZKYMFNC/0k5q3wE9vX7ZQuXuQjEs1uILaLJHdzkVGrKRTEfQpE307hCsjWoQWrufasdJCn+dsJ0HTx97zLahxUsK6IHrmELzqTuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mq+8ESmA2jrfpQZOjprCU5gaKWY1crGMxvXWMhJyF9s=;
 b=hvPb7nkoG/AP3RDj9m+a5Aab0aTZTylUWFGePtEwhAKRRS20QC/IhQiVOFlzsuJMytAMJ+uoY8POQM+VP8vNK655oVEhTR1SBKLD7tjSVXnKvyjugVAbZ4d0sYQGGJfs0HQ42uK6cky4D77gFnKcnC3PeRINN54KQwcSrnm4cDuZS4kAeeoBmRjuo1ox6rflgbYjAnvSyu0q5U601XZ9ETvQHUDFUL8C+/2o9imEcVh6Ijt1OjY0fx+qYHNRDetdvZTfykKFLzKyF3dxDf/V5WXKc/Mh9ohFzihw1ki1UTaB0np4AIWPDKh2lUwhwgZy4S9SFU0BpTHpS/hjvnfX8Q==
Received: from BN9PR03CA0285.namprd03.prod.outlook.com (2603:10b6:408:f5::20)
 by DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 18:46:17 +0000
Received: from BN3PEPF0000B06E.namprd21.prod.outlook.com
 (2603:10b6:408:f5:cafe::2e) by BN9PR03CA0285.outlook.office365.com
 (2603:10b6:408:f5::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 18:46:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B06E.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.0 via Frontend Transport; Mon, 8 Sep 2025 18:46:16 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 11:46:00 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 11:46:00 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 11:45:57 -0700
Date: Mon, 8 Sep 2025 11:45:54 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv1 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based
 arm_smmu_domain_inv_range()
Message-ID: <aL8kYo1cHHNg1H3N@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <8c4c5aec144f65cfd1fcef2eafb395876dac97ec.1755131672.git.nicolinc@nvidia.com>
 <20250827184923.GC2206304@nvidia.com>
 <aLvs8WrxEHpykCT/@nvidia.com>
 <20250908153911.GC789684@nvidia.com>
 <aL8ePHvQ25LUU81J@nvidia.com>
 <20250908182404.GH789684@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250908182404.GH789684@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06E:EE_|DM6PR12MB4058:EE_
X-MS-Office365-Filtering-Correlation-Id: 0823ee2d-3ba6-4a9a-5451-08ddef07fe66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yfLBmfWPqqUhGic3ZSy4sAa6f5q2eFtLOM2fjBa1aQPyfsA6Rc6ZKk2Wg/4/?=
 =?us-ascii?Q?kfIQh6DCddHa13O+XoLu/1EJDtgqJqIIOi7M1ex9rWaRBc40vgXc/dR/npce?=
 =?us-ascii?Q?HmagAUSDbAGUQHl4/sANnrCPePEVsVIgHOJm8tOaUckbL+aPpI87rapUQXux?=
 =?us-ascii?Q?m+IxBiJBsV/+BYNXKkEvQEwQF7hd9M/sNa+0QMYtuxrL+gjeuxC3Ag4ONePV?=
 =?us-ascii?Q?wnq9VVzp8v3N5rO3CpXKI9q2sBRqhSWG+Lc7myq1ycO2SyVXdC8uRSjAq2sX?=
 =?us-ascii?Q?yYFppAYuC+DJ3hLesCNGeu3EWb/RA/4soZCdf6le5ducx4SFNGg+iDGEN3WH?=
 =?us-ascii?Q?8Xy7K9+Fhfz9yx04ZY7a40zMH/bAnk7xqXQNCTRCbrQXxoNvYI3m1T30l/pk?=
 =?us-ascii?Q?CZBGQlOMQ1Qjdq9z1qfi5AJTDB4w7c/C2QXKLpKALI9LZIkuNtI6zHcSyMEF?=
 =?us-ascii?Q?fQ9omWnhRm++YCA4srdAeozsBepQXCNCI6oHSoc8i80CbElbXzcppJvC+/uV?=
 =?us-ascii?Q?AwN5yt1bt9RwZaOREigU6oyMNoMMVViMGJFMwTssXBF10iGneRbAHd5sSVP9?=
 =?us-ascii?Q?Aib7RoxRGcCMy5aLndmj6o824cPNU6UJmMa4Igou4SW7l+ka39LhvVJN8f9o?=
 =?us-ascii?Q?v8GlBq02hZZuzCP7omSMMoRI0qsI834+BIbp65qTRGhfPx/00JKGfjuZKd4J?=
 =?us-ascii?Q?/m+MweZgFJ6JPBvW7p2TN759XjkdqxZBsEMgyx+a26YKLc2bseABqYe/DRGd?=
 =?us-ascii?Q?1uWJKo1uY6ccCKFHzd0hBSAj8v0bbg0lN7fMJkRG6p2GxXAJ7w09VSm/QvLN?=
 =?us-ascii?Q?DhSffPhk6lUCTRGffSoOa6dzaU4mPLvOsfjOarBXLm3KuXRcR87pMCaEQM5U?=
 =?us-ascii?Q?TnsQLcJAeKiIeXNH/bDqtFTC9gA6F7xtexeT118NTj+XoMc6+7vPJZSEP6MK?=
 =?us-ascii?Q?bN9HybF177P05jOyQQk6ujC1Rvbhjf7SrTZzq3ZfGuRIQXyPKA0051t+UK7T?=
 =?us-ascii?Q?bywprZiQ/HrLHmcIsWBm71gE4k8ndNpiDVBquwx626yidTRTkbQYcRpjKnvO?=
 =?us-ascii?Q?ZIkyIt3uzXeJFaaWuiRYtOHhDykuLeTqmqJ3gxElKJ02b3/Ml0EBVnW2bwQJ?=
 =?us-ascii?Q?VJTRdBmax65FdrJjpZkXuDKp4Ip8KGmlG68JqkXWKQzZJoDn+SuMb+IrQ4L3?=
 =?us-ascii?Q?D5Ir9W5KsXJPXYFLliq3e02HmhSMJYcj3weiTGqSGPGpCGZItNyjzazOUk9X?=
 =?us-ascii?Q?h3K6euEEQ0QC0hrDqz2sO2HH6DVnmrx2X3m00sh4/S/hC8vXBNBWBGftAhLc?=
 =?us-ascii?Q?630IcfHBsPF19orHCVGHeFJIJC7qyY+iyMQCumJY6A6sKgBKBSzlWQUdAYVH?=
 =?us-ascii?Q?KQVIoEi00HMvppwsyrlTOvfZvVFTk7mS+Ysn7czD5cm32TPLTigDBzIsNYq1?=
 =?us-ascii?Q?I3qQuRi+2HrRD1SvOne6UiQHN4p00A53tWsYmsrvK/7kgcLkU+nXXlkgeUgl?=
 =?us-ascii?Q?bB/Rdtu1qZoZwN9aH3vk8vzv/w4HvoGLjLxLolvH4zzZlcfu38bS8fYe3+e/?=
 =?us-ascii?Q?uLxOxxQSKjja7OovK1E=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 18:46:16.6653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0823ee2d-3ba6-4a9a-5451-08ddef07fe66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058

On Mon, Sep 08, 2025 at 03:24:04PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 11:19:40AM -0700, Nicolin Chen wrote:
> > So, would it be better to just always take the read lock, while
> > applying the ATS condition to the writer side:
> 
> No, the whole optimization is to avoid read side locking on the fairly
> common no-ATS case.
> 
> Always taking the lock destroys that.

OK. I skimmed through the lock_acquire(). It seems to be a bit
heavier than I expected. Perhaps this is the part we wanted to
avoid.

Thanks
Nicolin
