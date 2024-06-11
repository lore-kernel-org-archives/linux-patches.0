Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481757E782;
	Tue, 11 Jun 2024 03:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718075569; cv=fail; b=jNQEI95CBHjR+zBv+vpyBmOLuXSAsy4mSrMN8yu/JFGtUVduV7IOV+N7cVnEPNqSBVKPRU7r2RoG25Usscnch5puf1SW0x4UB5KY6JilcCPc10/5F919csNsfL/G77cYgtAFGaEhIg7cc4+yaNUM8i5jM9ORjnayyLlDiAoy7R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718075569; c=relaxed/simple;
	bh=Ofut7BAQrbY3l1UePrAKFdbWNtaT1rpHoWu3ci7VmQQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hm0RnnX8WCBufU8N1WIonOd6BKHj2IRKMiuFrmi3368bjaya+0C7qQupEcYLuF0jAGRQJdrrDVNsUGdvcD3n8QapRNcsxT8oXT8v/P2xt+DdaymQg+RXFHoDIl/NnqzRQsLWbn9/gnwATusPEANT2tIJwn18bcLJzWnx+ASgZgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U5klVDQ5; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U5klVDQ5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuHVwfOd25NqYTIfocaaVhS8N+DOr4aJaH8HLFf6v/vXBgWJTy7xUEqWQ66kZBVi0vioiJzDRbFG0XgQccxiOJQ2Adq1l29kE7aurKneAO32rWNHfAiHY4x7kLYsL4rs3E/ZcU5QfGAbnXKhkF3KSCQybcNcdKthiQQ/YOd2kS9A85pyoowMhIx4zZe1pGUusQF0qfj1v2pUYVodYIRmk348tgoRZ4dS3ADyi0yTIbwqCe3DfII2NZen23PImaJbbHTK2FzVLPepwpvkI4g/smkMus/0bkahh2Ry3oQygmG4j1dwJAra8L7hrlaO/nNKnbu/5OzKd7h/prziYt0qkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6N74u7bE5+T1/XRc8SEdXfK0fRcDxoyvpLxhHEjYfU=;
 b=SbDQHaewX1TZJkbn91n4HcV25EKiR6YW+k3WkVJQBEGPf/ShkRTNS9wlnlW7R513/smxFMwWUhCHAYEGOHy8/hYvjQS+i+zIPI2RsMRhWrohxx+BoiGYQ4g+EmiGShjU8PRCaVGi7cEjkIaLmlnQJTIp7tF4pWWmK9os9LW2afkVzbx8HV+gkSgSHRgmyLv77c2MfAZLmhwJhzlV01QtmPknPBT1UEDGkPLCVRp6gb1olqe6j4dG2jz5fnWjdNmv5VWrDZqiFj+qX2RbVP4d/8tda0Cf0VRdv5khDb/9LuDmbhECEuX44e2UXCfOfm/zwqHV766X4Tc+1LBs0QWR/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6N74u7bE5+T1/XRc8SEdXfK0fRcDxoyvpLxhHEjYfU=;
 b=U5klVDQ5joHAlrXSOvUQuRpqi7emdSFM8yJwRMBWvcnfSlm9hB63cg8NIeGdLbKSODa1o4toZVghj1sMbJKZlf+COR5Sm8sMPNi3Tld+NCxn5/DgAbhulOGX1X2DgPsikcPUEfrI7HTqNACicZiwAynfGTPSBOzLwS9WgTAJX4X0cx7tkMlmZrKaD+2uz2idUUf83HzIZqKSZzDR0AA1PVN+F/GiTKpx25PhJlBX5YWsTzt1C9klZ6rV7fIiYmp2WvgNKGOQyDrP5g9TIMW4AZEmBxoneToK7/WXHhCJvSLuIqHazXukDUDq2RUBWedGno/7zRkTfr8RDPAsh7VdaA==
Received: from MW2PR16CA0062.namprd16.prod.outlook.com (2603:10b6:907:1::39)
 by SA1PR12MB6894.namprd12.prod.outlook.com (2603:10b6:806:24d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Tue, 11 Jun
 2024 03:12:44 +0000
Received: from CO1PEPF000066E8.namprd05.prod.outlook.com
 (2603:10b6:907:1:cafe::d) by MW2PR16CA0062.outlook.office365.com
 (2603:10b6:907:1::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.24 via Frontend
 Transport; Tue, 11 Jun 2024 03:12:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000066E8.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 03:12:44 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 20:12:31 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 10 Jun 2024 20:12:31 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 20:12:30 -0700
Date: Mon, 10 Jun 2024 20:12:29 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 09/10] iommu/arm-smmu-v3: Add types for each level of
 the CD table
Message-ID: <ZmfAnY9uY7g6QkcQ@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <9-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E8:EE_|SA1PR12MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 0960bc38-0baf-4436-44a1-08dc89c45cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FhgcXFAg3TjDETx/FW6R6QvYBLZxvzBzvHVnuhU6paXZJ+wrCAcwcDU0i1xF?=
 =?us-ascii?Q?UBkUDSKrmkHBHV64Cq8c6EkHyz00e4FoT6rucWcxmaIUX7gL9J6GH7jwgp7F?=
 =?us-ascii?Q?SouG5cgc2R2EekX1/IWbdAwSXO4Y9Qn5zYBQdpW1nNxfpKxObpfwmsk0UM93?=
 =?us-ascii?Q?oz1iAIPhHo3eS3cO9rQdixXsOab4R3Jkixgn7YBKz+tvHsJF5dIKpq0vl0Vw?=
 =?us-ascii?Q?PCyy44R6zFJv3EQuI0yr/E1hwMbQ9CSPhTCI9z0TUnlQX2fZUkzzASpfX1Ke?=
 =?us-ascii?Q?ZT/43AQixCmgaGkHeEX+znvDDiQMuRX5kvQLgmUwO/saKiZNNJOHnrulvGOh?=
 =?us-ascii?Q?eb4xj7tsao+5BtU0Af7yKBTdlxV3+46fynuT3oOYC+h5BvGmFDn6ENBU0hFj?=
 =?us-ascii?Q?OU4W3vPAWr8KeNUZBoYZKuskMsY4R4/8EbtKehm1pI27T+pDdiLfMmJNVBTe?=
 =?us-ascii?Q?A/0xCxDtSohfIduglaxx0Cmx9DQSJ/hzkdEKpxEGquQlWk7g23PvQa84TYcK?=
 =?us-ascii?Q?TiKoVRp2BZtPQ8kN2eOSd1s/aWml8Xl73/WwNWzp1wKogGvfNQCgWXjvTtDe?=
 =?us-ascii?Q?ZTL7XG7KoBtlsIdBJ+f5u1r3tTjHaKS+NwqCknx3zeVO0IPPGu3kVYLWd4GY?=
 =?us-ascii?Q?9n9rkUxGxJiPc8FVsfLaBdy4anS1beLJORwC8l6bWXwKxzAQK2O6sPwHObub?=
 =?us-ascii?Q?D4c8qDqWb/Qyd1+oMurvPkaX5ygQ7KGSy0jim4l8ZckFqtXHNcCh85iEFXYF?=
 =?us-ascii?Q?cqFMZW+D3l51QCduJcaeZDI/Yt397mkyLjWoLh6v0Y39nW8sJ3aLml3quq6b?=
 =?us-ascii?Q?EOBxttLF0U3rz4BlyPmklKr/HlHWnFxSVMqclkEIOmFu+5fmYbZijCbRDGd+?=
 =?us-ascii?Q?j4oWiwfSCk0YP7TOR08708xMVHl9kK95EiR1oKuPdl2sfIqkkkeNQT/BhPsL?=
 =?us-ascii?Q?YRNd5pylSxobw1qz/dAhQ0TwRbD7Ho+YlQmla8WRRMq4VvwOHzyAta7Gro+6?=
 =?us-ascii?Q?s5WUZgkw5UG2mPznM0iejFfKRWPReVicyoVeNdXA5aWw30Tcx/RRF6U9MgJw?=
 =?us-ascii?Q?QXZTeqFHq9itgRrNBA8UIuF5yxcGK8FuWA5AVRvHhcdmuJu8f4W6TTEbI1dP?=
 =?us-ascii?Q?CoMosc0jBcBh0YpjZv0lD5O3QYmen7u/PNAVDaAeLd66dHrjOOGloCXaDbVJ?=
 =?us-ascii?Q?VjG5gtapcbGOMPkd5+mt+VsjAn1+PKDpNnhQ66Jt3/7kHPap64GFDQr7gpqM?=
 =?us-ascii?Q?vxPCSGYl047ScZjv6rcdqH0A6DFmyRBN+Zt4Rl1G48KbxXHGfsVgfdOn3SKH?=
 =?us-ascii?Q?7s8MdmwyiUt0RZbkm6IyhMS9jprznrO+PymaNWeTibrO4rq4uCz0BN5UGMcb?=
 =?us-ascii?Q?SLzgf+DHpfsBFI59TDiIEI1pruPDHMY7WmqQ4rRwfId1IHsABw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 03:12:44.0441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0960bc38-0baf-4436-44a1-08dc89c45cad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6894

On Mon, Jun 10, 2024 at 09:31:18PM -0300, Jason Gunthorpe wrote:
> As well as indexing helpers arm_smmu_cdtab_l1/2_idx().
> 
> Remove CTXDESC_L1_DESC_DWORDS and CTXDESC_CD_DWORDS replacing them all
> with type specific calculations.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
