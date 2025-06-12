Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8F93596B;
	Thu, 12 Jun 2025 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748360; cv=fail; b=OQPxpoWrdQpD03vUxe4i967QpPzca8nEDZf81+IBfUdsp/IoMbbAJ204W5ii/FfIolKxs5nlEdwFmo1h5WD9hSmLxQ7IrjkMrDDnT7oHcWhcNAhcJBDFVpxb7VVeLI83qxbvS+t+LA+9ZHQnWNbUBD+/Ws/PfuoNvVQb35911k8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748360; c=relaxed/simple;
	bh=Y5KFvLvaOvOrAxQ0pb4PChss8eZF+cNWI/B6YL8SH48=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFNSIPv28kh638//21Pm4ybqVYqWkxfhAuM1LdlxMfON6ZhzV/YEXHmFk+B+eVWilhV6qj2xkCdXwBezIkg7vGPnkAhpxz0lymcL6ez+Go2Iroptdw7UgKTQ2bvVPvaTK46705/WIVDl/1gyWGGHrXowi9AhmE+V2MushsHewT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d0hYFc/+; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d0hYFc/+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQ8KsBPXtydW322Rg3DmSMT3ioT3so1s6CN5LEqV4BhDiJ6n4MrnRWEeeTLIlY7fRXnfzkw6gPxukBi1g9w1YqJSpBzWhMKogjeboeJN20KjPpfsBAym5ls1AT5LNUcmAmC+Twp8zT32+bxrDMGiqWWl+xncaGmP56ThFI/VioF8BclsHsC3MGFcJiAg52nAV/zHLTspcAz3QBbvihgIcKpXkSnywu8FFsJW058PDJ4Iasdw+ixi5RgYQyMwoAOKO09S4CFjnHpQoo/5KPqLzFk6tcI+yHYAzN+jHetl0VKaM9qXLL652ewfMlHbE/8MHwOoVYTXH5lRVHt2wuaTJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZEyKYvqRAOKJtPzvcn8mArkO4WkedPDszFyvIVlRF4=;
 b=ArKTDyoFuerbtZRAktClL8EbgBgeYB0XNtMJBMLDc1kufzpztZHF5C/I9LzhrXH2b5tUgYpkQrhLwIe1YUxVmNTmkL9PCvgzS5c/jjIGU1fUMEsL9sZLAzva2leYc7pu0PdRKcLsT2UcMa4TiHHk3Bg9PMPzaNokftPI3fud035B7tI6sc8iwPKgXoLqGZVLyH4TAlLqcVmCQ4b3Z3mbE8tiA4Oof6HsZ55E6PEhXmUopdM+k9SS4twR2uTazZ43ogHfcmYjXig2HcP5IhREQ3EUq/XPUf13sCvx6fifIld9EoVEz0U84PYgCNM5sNl+LjSW6Jl32sEHpzDLQlXbpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZEyKYvqRAOKJtPzvcn8mArkO4WkedPDszFyvIVlRF4=;
 b=d0hYFc/+sTT5zJ8gf4jrKSNKA+/GvBeR/NuuuM0EGMEJAByfTh0zr+LbCJhxPhP3nji+3F2Cuxg8bLwmOMyINHC8LP8QOIVzL1RnxBxW7DXT+WerRIoUzWUp0ro3S/02CeI4K5hrkIVnNpJxh9+p4urZUK6KlScSfKPDkqe4zwgdOI9qQ9gJWDeMy3Ozw075K+RyhHnJbkFmff3FFJxUqV5xWB6r0CVOrjbpK3ocLq8IteJrtykyo60lJhyaKDPIGecjLORnWWoTLI7RanT9OjtJsZL/IKHQawIOzTqbwTS+yanAPWpFb32HwgYlupwwd+AYQGzvarezgyP3zXtsyQ==
Received: from SA0PR11CA0070.namprd11.prod.outlook.com (2603:10b6:806:d2::15)
 by PH7PR12MB6956.namprd12.prod.outlook.com (2603:10b6:510:1b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Thu, 12 Jun
 2025 17:12:28 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:d2:cafe::30) by SA0PR11CA0070.outlook.office365.com
 (2603:10b6:806:d2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Thu,
 12 Jun 2025 17:12:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 17:12:28 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Jun
 2025 10:12:10 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 12 Jun
 2025 10:12:10 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 12 Jun 2025 10:12:07 -0700
Date: Thu, 12 Jun 2025 10:12:04 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>, "praan@google.com"
	<praan@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 06/12] iommufd/selftest: Implement
 mock_get_viommu_size and mock_viommu_init
Message-ID: <aEsKZNh4ow53d7hW@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
 <BN9PR11MB52760F8C5A8B6331CE5588778C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52760F8C5A8B6331CE5588778C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|PH7PR12MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: 1af374d9-2cb4-4340-a78e-08dda9d44f33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q4oJdF+gKTamMNqsNzML7QbLU1zHpLFEozYRVgO9ezGIVGvhjxP23gmSSM8X?=
 =?us-ascii?Q?LXLb3xkEDrh+AaewZVdgZprO1cs7LfaZ7aWh1J/OfK/mJRmulQZr1wf5FEFj?=
 =?us-ascii?Q?po+meD7jx2VJF4rWcUEN6jPB0iUXbwpCEANcNb0+wYzy/91qTKcREzAhi879?=
 =?us-ascii?Q?WRUd8I3g5pwP4TmxA41mIf3Y2BlrxNYIzxlTlp0U9pYJgMVvTXwY8gCyKlRk?=
 =?us-ascii?Q?rl0VCRqCsmHhVHEtvuGS23afiQIRWKNqAHZ595Ofe/GTqHAhbdXvF61XtsdA?=
 =?us-ascii?Q?vcyzaBNyC42F5D+ZaLAjSAK6zqBFE7fjxV+Af2Gp9PlzbtuIt+jRFmisTZno?=
 =?us-ascii?Q?Cb/yDv8qoNlYNsaokEZ2nWSw161tMeYiF0JHazQFoODptbbcm0D4pnq1Dbt2?=
 =?us-ascii?Q?RNA2ktK+skwrOd+5Tta9Ar4JhSCYCAfs6ufNclGwM0jkOBZzioVz/YBWURpi?=
 =?us-ascii?Q?ePaMFoARwRY7+swb2JYICpmoz1rZdo4sVgl9OjcPhKC+hq5NwuCFPPcC8UNG?=
 =?us-ascii?Q?/9s51Gl3zZ+jK/uXiNS8UYI+vkV4/3dyKrIALVhjNbXhQvpnWIt1KVaddmny?=
 =?us-ascii?Q?ITDLeXUJG6TVei50WAYQAC1wJ4pF8wRRPYvu52njo6srxoI8Tir22PiP8kaN?=
 =?us-ascii?Q?xRQ8aHgic+efHhapPNniIAb+ln5/uiMMzTrLm2HAmY9QbolOJuCVuR+WRNtJ?=
 =?us-ascii?Q?fpWLsBxZvkgRZIMz2Zwccx5zPEBi2NtUhUbxD/Ck+haj3l/GyOVR6j+V4XeC?=
 =?us-ascii?Q?LJh4l3uCpeTsLyPmJOcQu03QLYpObjnFZNsTni9STDO1rPZj1nCWeB5J1Wcy?=
 =?us-ascii?Q?vw+9Afrr6Oi3uD+lACxVuGJ3McDA1Qj9+rvdZuBUpX+cg6bE2nBfDwdvtYla?=
 =?us-ascii?Q?dqDCzNJxHfHUQe6eN2pl0b4uWtDk71SvP4lFE4y+OWdEHcs4lr0S3kJRy0JH?=
 =?us-ascii?Q?ogbPYFQCabvL4gr0KM/7tQNKmD3q4YOL+tAiDDqVqfYr5w18toENBqe2/K7H?=
 =?us-ascii?Q?UZS8S5b8/aHjdf6itej60FDIlt77lYILyWgcApqpjfrcvqiGszcbgdtJilio?=
 =?us-ascii?Q?GbYW964bWfgB2gRvAKxso7rOJbml0p2hiT1Hffjfu2H2QGq8ox1DQUIQnb/0?=
 =?us-ascii?Q?N5+yv/nwkfBkuLr+6fy1SLqb72jGdBOt8lCz8osACLuk0/IBh9llmLdlWyEX?=
 =?us-ascii?Q?q4pOapAN5nyhzYhwH+45uXldtH2mxjemTp0nJqrDktcBKUyTmiSnCGAxiysI?=
 =?us-ascii?Q?2Iwkx3Z+p6HPQo/jKP8xo4fM8Sx2vOmv2/5lRXkOdVCWFJ/mhr31d8O/KgMM?=
 =?us-ascii?Q?i2bqPy2RfBMUt2Xmle2tkqlDsRo28o4MBr8dXDWlbjfniV497UMOuz0Nvsaz?=
 =?us-ascii?Q?oRyDKNU0Gly6/FV5IRBtFpTbNt67tNvkTWTyJZTnOY9g8FU0WKfhBsDNbmQ9?=
 =?us-ascii?Q?JxdiEFpiD1rUXa1N2tDimVy1hMhK5Rsu0IrwJ21twKCx7iQlE3tRulUVbfg/?=
 =?us-ascii?Q?murhKBICRSqJo/4M4j5K/m/enqIBafNi+qnW?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 17:12:28.1910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af374d9-2cb4-4340-a78e-08dda9d44f33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6956

On Thu, Jun 12, 2025 at 08:17:19AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, June 10, 2025 1:13 AM
> > 
> > Sanitize the inputs and report the size of struct mock_viommu on success,
> > in mock_get_viommu_size().
> > 
> > The core will ensure the viommu_type is set to the core vIOMMU object, so
> > simply init the driver part in mock_viommu_init().
> > 
> > The mock_viommu_alloc() will be cleaned up once the transition is done.
> > 
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> btw I didn't see where mock_viommu->s2_parent is set in the original
> code. Is it a bug or oversight?

Looks like that was missing.. But it shouldn't trigger any bug
since mock_nested->parent doesn't have any meaningful value in
the code..

Perhaps we should think of adding some use case out of it. Or,
we'd need to clean it away..

Thanks
Nicolin
