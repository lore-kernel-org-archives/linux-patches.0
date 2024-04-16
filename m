Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E686EB65;
	Tue, 16 Apr 2024 22:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713306012; cv=fail; b=ZLoK+jVlNr6xM1ZL96RSo0XI4+zxNySx2HzmEtlMzWgSC5UL9g+eu5RzU+MZuG2ZLF2SkXDAKsiErDUG/vMf9iZ0XGg9cSrPDSurHqpLjfHYDBMji5UM9J3AGi4U3AB88tVz4rMDKWY64ZjUXkVazBVdab1mIZvy7bOkTmIzYJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713306012; c=relaxed/simple;
	bh=vepyWYTPbRwGscwNc5njmd6/z9NGGPsOzFlBK1K0Y+0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QL03SxEeV3i/92CJugH9FkrV+XWWfQA6S7bQIO+QxuTwMD/5Og2zzB97+UrHtfH7it6gUsSMpOc8tHlEKzX2QPIuKvYT5LwVP6bfuiwTy9e74SYUdM68DxCK5z+d6S64mpoQHMoEqmDjRSCUw3/gNXY/150pW270LblGdbuDFRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CgThqi6T; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CgThqi6T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+yPmCGlUJv0C19ven1qz8ws/CrQLsFtULaA06SfR4XldpWA8qnD6BAD6UAy+wi4JX65InCEc87usXD7GBlLOLvczamp5F9g5QtXtycfrlp63oQ/dD593ctRqK4lECGX48GUT61UvHUOBPJaS2uREPQhRRbZz773s1v9H+2NWhUi3kLeAjtS7bsTMD2DUxfQnR4ibI7WKIp1e1My0J+k5kl9p2Ze53c8rERBk4drZOLJMc9mM/VFwlRbLd/0e9ogaQwLha7/529UB2jSKSL41bp7OnMEnfyp5fKtcfcZDMP5VOnSaWJPnTJeLkD0ZjRNsBZKqCNsLeamYDOo936oZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsT/jrGJPAaoNbtXK6NhPg70O0Q+6RBykIwLWP884II=;
 b=R5MEoIDDi6rX15CfG3KBEDz5wzw/iM2WrJfGbB80JP7EMIiDZEaXHP8KJzLpmuXYoe2AzxsyT1r/t1VJC2p5VGrVP7a38IGQL1wjTJNeq+tWsD7wsZDNYAtPDUJDqe9NzfZdqjILnaUo1P1zu/GJnD89gMkjduC8jvWPzbtOixi4GztxcPT5UU1111GFzUbw3A+X0LlqWpXNmJX5lTfjwKnQBMRSVS+rOTHv6fhno6ZhJEhnx6PjOqpdnz1Y33cN0PNVEUc0hq0NSX84TPwbynDGirVUdfboe/d7bPr+0Zupd8upc5KgYcEw1eZ8oQ5T7hWd0T0OAAjMiWeoncKA9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsT/jrGJPAaoNbtXK6NhPg70O0Q+6RBykIwLWP884II=;
 b=CgThqi6T+XjU1m8aQFWZoHYwUXR7smJGCpvUxfpUONiOhYHlAqW5sNvrNGpd/JhjyZCMQVVcidRFRS1jwyJKsTVLywXAVgLhIQs8OvT4r4rX4hOmWdg5wMzUIYG+bxFTD4e8lN23oM7FGmidBv2zuNtdv9Cph6RH8+6kcKzwdzH8EdxU1PYUb7Rvr7/Ux/NNFGprPCAQpIuK86Kks10UCbhELjrFDAlh4iFG9BhgDPqV536tw3aozJFgbuqwcs/mMky+AgOnrPE3NtcyGkzpHNfhnv+LWWHNK8hQONPp3YrTZ/phdbsdwJaNU7Od8Ju2QcHIQwL4aGVbbjBD7kW3nA==
Received: from BL1PR13CA0397.namprd13.prod.outlook.com (2603:10b6:208:2c2::12)
 by PH7PR12MB7844.namprd12.prod.outlook.com (2603:10b6:510:27b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 22:20:03 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2c2:cafe::fd) by BL1PR13CA0397.outlook.office365.com
 (2603:10b6:208:2c2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.19 via Frontend
 Transport; Tue, 16 Apr 2024 22:20:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Tue, 16 Apr 2024 22:20:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 16 Apr
 2024 15:19:47 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 16 Apr
 2024 15:19:47 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Tue, 16 Apr 2024 15:19:46 -0700
Date: Tue, 16 Apr 2024 15:19:44 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Message-ID: <Zh75gHPYizRpwENJ@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|PH7PR12MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef38b71-e188-4751-3d20-08dc5e635bd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QUDgYr8GC+RVYrk9ZhKpPr/fynM5AROd7yuQjQt3FSo4M/C2qS4DbYZFDhzdYoghqyLyKdrVRNlzNFisBH+H4Ehhzs+Vhzc2XgC9E+AuhTwfmS+S3dRuvQ3nldoQJSUnxvfKMDg3B+gA75TioC47YNmbAKJSZBoVND1ByaUVlivZpqo7VWR8fCAV1Fk3O1Nd7AblPqBL/e+qZ60pCMa05yzXt4l0SZlWah/QyG8Eji77q1/kKkiNxREASNbcfAhFlyFYLm4iZoqZLDjP2AaByaJkxwTUwz/xiA97Afgj7XDeW7Fmvwf2aKPiv7njJFXecdUn2YkHnfod0burLpGWgDqRJOw8As06B94Kxt8nKkxxLIkmFe544V88x53h+uAnYy8gVGIooV9kfNftp889sf/HlOqFwN4nM7v3K9ZsvsQvswJsswnPT80bF6gZkye1eLILPqIDI6y6qRBZJ0S4lxVE91RZpJBgGtednmIeUMAUBJUqkRCV0ZalM+n9qY/WgExPPpvc5hZE8PfBzQJBD3VTSp5NLAT25v3MZ3hWYxM7Gq8Cy2APfCKkptRpFaSIM5W3JLwDGZEkAqegU5SQuGvimhuwvEXrX5D/wAlHetf8bklUsA57Gtd4X6L3b/WuFmEhUUNlqUcY/TnCGOkU90h9zsJ+wbESRveUSTeiPS/ErUni25P8MqJSeOd3Hu3GBVXLPAfSk5N1XQFhqGyNVl4NldTwdSc2T1bU3wQELHD4JzggUqWjn4n67oeNi3/e
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 22:20:01.3564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef38b71-e188-4751-3d20-08dc5e635bd8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7844

On Tue, Apr 16, 2024 at 04:28:16PM -0300, Jason Gunthorpe wrote:
> Only the attach callers can perform an allocation for the CD table entry,
> the other callers must not do so, they do not have the correct locking and
> they cannot sleep. Split up the functions so this is clear.
> 
> arm_smmu_get_cd_ptr() will return pointer to a CD table entry without
> doing any kind of allocation.
> 
> arm_smmu_alloc_cd_ptr() will allocate the table and any required
> leaf.
> 
> A following patch will add lockdep assertions to arm_smmu_alloc_cd_ptr()
> once the restructuring is completed and arm_smmu_alloc_cd_ptr() is never
> called in the wrong context.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
