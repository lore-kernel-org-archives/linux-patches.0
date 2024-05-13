Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3477214265;
	Mon, 13 May 2024 06:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715582208; cv=fail; b=VzmPFyW9NPBspWGHmefxXvYDiPd0cRMR2U8iOlNNda7DZ1IU1RsbZMUOXqT2n7JEbvLaGqR2RTO17Bgv7HrwUvqJqL3LlTTynxbvy3fb9uVVzDZ6T1mqQRK4e2wyjKMC5lJZVjfvHmp7B/8W37ushxYJ/4DUHXeAtlsdaDWK0Qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715582208; c=relaxed/simple;
	bh=3M1gcxMRI9ycw4hT8WqlDuYVpMbyCOAL4lvYReCkoO0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ldONijz7yeJcGFi/MhktIXSy7gINh9JWuSwI0PH9FyJrb+/yRt4hlUQgUwSa42HI37kUxVCtHL9npw38yOEkZ7gZaeTVKrzvXi+0aBokDhcHZ+GTe3nFiF/ZWTCFcWP+l25TBWYfYjO1kJU5lvReYGYJLJLi3VvOn+wKAwPLk2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hCsTG1Wv; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hCsTG1Wv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cke0TtEFPW0f6nWdUE8wqajt/Ee0bqt4jcNeFYbg8FPyZdWcysulqwQttyxA/yWQhtG1pu6dQf4TVJNaxIGX6piMndBe5fHrgCT551xk7XVQ+rlXV90rQZCHgOx/HghSgoW3YiXKwQywuvTxR2ZuzXo6lY1sgR3uSQzvEKySoMsamo7QKabetWc4ENUl7lGdM5w3yDKUE/QVDFDULE7cydePJS2pz1+xgJ9Ux+r+cWmg76ya34LXAJ++4ehjcBDMLs0jW7J4A4Qmmusass9mfxoUO1QGjFstLEKTj9ZETMljUWxyvQTGxwsGHoTmkM0I3haL3s3g9L8xOI1hC8FQmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hy3LcB/LcjjqG+iwDgM4TRIwjfexSZJkt7aKF/lOgo0=;
 b=PvNWSoOUyB1dAr0c6/wCirFt8ooV8FP3MHLJWIYKTmolIx68b9J8FFqUKH8xhFQvn6rNRPiIGz0b6kWrCU5YAg4wY3fqSdXAxErl2YXzFeat4Qu4ZjPPivCEVU7PPw2iUDaZ96U63rfxDXam1qGFcU/StSxvhtm3pJZIZ+drTgucXYfzxyEAkWwa6FLndHrXu7uekn0f6vNeouTnpKbujcTUPyYQauLrQrTv4t3neCKhhGP/3AyCLnYpOEyAM/7a/c2K0cjFsRHaH/5LQ0JadNr3GLNG3chumJ1qVD9xAyHoPR965JfkdtBhAPFcSXfxGhGYGVHp9AsFWfUNEDkMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hy3LcB/LcjjqG+iwDgM4TRIwjfexSZJkt7aKF/lOgo0=;
 b=hCsTG1Wv7UwyEzVdiCWy+NPmP+VYojRJXtWkHkG8PuiyW0Zi8V/lds5q5DTM2JpZg+HrZNWfZ3kf/PPGkYX3RF2K5qSQI8zy/sBO+vBv3+CK8TyjDMpoIKfK2cJuwbzYJNnyZgyqX0XjMgS/w/Og7r2h/VHJhb9AeCKS6r/bXExx3srZS6TO62yus92+VqdykZLtNLaeznsLFsjrFlWLsDyJ9WQa+i3nia+p12wELBbMV1IFwxtqDBjIgvCbKorZYnHSPpuiuIciAz/Bt3LUJPZspM0WNK0xbin3hINR3rl8EJQHpuEENaWhmm8ozYJWbv7quQCJ0rMA/n5NPKYWcw==
Received: from SN4PR0501CA0070.namprd05.prod.outlook.com
 (2603:10b6:803:41::47) by CH3PR12MB8911.namprd12.prod.outlook.com
 (2603:10b6:610:169::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Mon, 13 May
 2024 06:36:43 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:803:41:cafe::35) by SN4PR0501CA0070.outlook.office365.com
 (2603:10b6:803:41::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.22 via Frontend
 Transport; Mon, 13 May 2024 06:36:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 06:36:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 23:36:35 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 23:36:35 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 12 May 2024 23:36:32 -0700
Date: Sun, 12 May 2024 23:36:30 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 08/14] iommu/arm-smmu-v3: Make SVA allocate a normal
 arm_smmu_domain
Message-ID: <ZkG07g5z15BAaE0F@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <8-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|CH3PR12MB8911:EE_
X-MS-Office365-Filtering-Correlation-Id: 25406976-ac83-4603-5863-08dc73170df6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|36860700004|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MkTCanvoRcVsNxdEnc90VRMKVT1wTIJk0FKUfZLT82H4Vi25m3156ZFPfCBj?=
 =?us-ascii?Q?gWcHNpyd5ILwGDo80cw4CQZdpzZ46M/bBQYEG/vs39tBnh43CvzocCWxUvtQ?=
 =?us-ascii?Q?eDI0vwjGNfpVFiXkwPQJM7inU7FvAFGdz5i0hwPQsXv55QjowRUO75WQxK1R?=
 =?us-ascii?Q?zFpMRuWfQJBCQ8AnQ2kcYbB9PyXSEa2q0BtwRMMXWGU4s2ErM2Dbhisp2JoV?=
 =?us-ascii?Q?nCQOvHn7NxOzKlFgdl91ZngS1cE7lOgBhTC6h6COK2uTyNkbja7Js2DA/dzV?=
 =?us-ascii?Q?9u+zma/J6qTBnbeb0pdNAKpFmTpRW83V+QPg6DTy/Mt9s9DxMhjVVMYm17DX?=
 =?us-ascii?Q?h/LGoNX6sh3e9fg65yPr4nSCE+D1SzE7bFLG1uf5KDQuEl88C71SRxXvwIod?=
 =?us-ascii?Q?3PqKtifKsKJ5kG+jiWvQ6Y9+bGg9RG9sJpSuPE4rOR44Kvq/I7doKIJSkygl?=
 =?us-ascii?Q?R01AffX/OpCaHimAUnBPWrvKiS/wEEB86TW5wEHUvM4P3D/BbzJ9mwg7Max/?=
 =?us-ascii?Q?pajzDh6NR8dA5XnSx/L5sTABIQ0MyU4Mq8DzexER5IqrxEhqFSCIYD28bsMa?=
 =?us-ascii?Q?6gXhN1prb1uO/GbnTY+qcozKC6mrxHK4LATD4AwThlr4TCFnGxTaO7InxEah?=
 =?us-ascii?Q?CZHnp0n+T0yz7amMSQi0HvQFqyzlOXzO7USEtT7mql2ibgJjdJpEGOxmIf7r?=
 =?us-ascii?Q?RFHyvhn6UkKN57b2BW43zYJ4WDhN2zlKvIpLyaYFDTx6o0YTfb87Rp+vz91P?=
 =?us-ascii?Q?yJOM318GE90WguW8XB2KtixDCdjTQVMmg7hUH/uRUFhqpun/i9zMR3A+v+Ml?=
 =?us-ascii?Q?2YCOa1GTElwkYGiUoc6bC5Gq5MgEecWfzMeCLKPtXJS86BYORNBDLGitcfCW?=
 =?us-ascii?Q?6mHz3nwztSZB+qbhGt9n02dqwgCICbqCDqWTLSwwsXSxaE21KjcJsBijoY7M?=
 =?us-ascii?Q?6CyUquyazmjyQp6Uko95HgrQ33GW+r8576FKUyRf3BxLzkVjB3UCTRUkEip2?=
 =?us-ascii?Q?sQV57KPFo/HgyzB+vyJ6+KEJrD3aL5iJNFYVTIULP0zVQ7+cR5L8SAjP5O0r?=
 =?us-ascii?Q?8V9B6rbdRD/ESSMxoEUW8v2o149nwRWDRfoJLjZloKuhqWJ6ZjQXdhVXUSzh?=
 =?us-ascii?Q?ISanQeUc1I37oh1dZip54kdfP4TOizNkVZsmur/uECowtNsFd5W+xRWFlbSB?=
 =?us-ascii?Q?3I7Us7p4k1mxX4hq0cU2XNdwMf0MU9rLj7HaRb7B/PE+bri3h7DaF3fKWEiv?=
 =?us-ascii?Q?+Sa1xuM6MDV5sObrKhryW0XZlRYY4+9VSg5K7q9+lZm24aDbMn+4w9kIDb7l?=
 =?us-ascii?Q?2rKozhf3mamEVYXRd7Ln8SJov+Gup58vlrKWebH4oBjsH0jBWBSmsBrEuP94?=
 =?us-ascii?Q?1wQ/jgqj3EVuHcTXLLYHGft29MY6?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(376005)(36860700004)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 06:36:43.4051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25406976-ac83-4603-5863-08dc73170df6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8911

On Wed, May 08, 2024 at 03:57:16PM -0300, Jason Gunthorpe wrote:
> Currently the SVA domain is a naked struct iommu_domain, allocate a struct
> arm_smmu_domain instead.
> 
> This is necessary to be able to use the struct arm_master_domain
> mechanism.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
