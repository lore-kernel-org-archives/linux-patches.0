Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA371CD13;
	Wed,  7 Feb 2024 05:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707283664; cv=fail; b=eDQoyaAUOHPdyfMcIvO9T9UDNatlK2U/df2wifKUxDY6TD5r7Preu1TndktCYSF3/+2sgfJxv1VktlM3+oNhXHzf2UVgt/qcAHO695PsxJEvhV2as7WmvMMa1Gi2G0dVK5Os29z5bYTXWDtTFk+vTSq3wXikrGubY+3HgEgmlu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707283664; c=relaxed/simple;
	bh=Tl9pBjvxJkoc8RcfKTw9UgQYVa3iT1zXK32y7VsSbrE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tM7mKw1U3WoX3WHU9EUPKhWWDs1z3VmX0BpvlBqCfcDDfyN1PlrSTntQ7z76CZQbNM+xAzJlyIRbdauRHb3Na0GYgeNjfyfmyS3yBX7tB+0TynlIoDh3ygW/o58LX6kgQvk7wQnW/cuHMaRoaG9jlDZ3DEYx3trrH+zY5n3qxao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eNkbxGlp; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eNkbxGlp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPuwVBn+sAZZi3iSTT04fDXzRcfB0xPERjuf5+rXO0kxawFAQbcP1hrJHvbaXYvYqmnqmcYJEgrbAj8bR8mifnBmCLEy5UhilJmrx4GUcazFCycCrWJT1052DesDnXGvO4BRcgDHMAGKYGLi2HsNmhZC+z9BONEqBgMrslNxFsi2CH4IhjbKHm9wHIpHKNsSqIUgNsjpTFYpcLU2IRg4ssbJUajQAWGCr5sTHvsiyQ6FmYsnm0+NM3ODm3E3MKh7970PzLs0qwYHx8T2EqJlBixJa2VVGulKrp/vj2ZArNc5jhXMn4E8zUguOXHk6zrw0G0wJXKUd+zSH/zju/AmhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0dwV7HmDAHfOSvQASR/37B7q1RTmCyG4cx4oGQU2sU=;
 b=F+a0BlF8qSYXd9HyigwQrGIDn6s0a6B7eZ4knC8I9bz6pwm48Zx2h8x4/ozRDNrBJDL2lQq5/oxTN36ema4gdGyyHkrAbHQx5Eu2WKwoj/7PX0XmOsPavZNGn4Ub2tOAJBqcQ1rKwRoz6TtoO3VmMhWsKpWfe65Y0Jp96yt/J87n2OjIVr2j1jO8USgJmxOfz2n3CsPKVFiBw2JP7NCJa+8K28f7ktgGVPA1Lqi6fB9b8iwSeknIvHBrCCtzMJRVZf8UnxGUUfYKQpJ3+GKvVbpHRS3lANd8qFiafGqdl5HKhNrqtMMQ2DvP8QrKY5FuUUeJyV0DccMVPqeeIJ0OLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0dwV7HmDAHfOSvQASR/37B7q1RTmCyG4cx4oGQU2sU=;
 b=eNkbxGlpQBlTQUWEZB/e2Q1sKfHpHsq5re8mV9Mib4gWVC2Lw/e4xh/fxXh6zpmQRVgNLEO+2YoCN0irysPydy++n/cNok76RXgoPXuOGVAsYgNGHt8v8BEqrzG1GlEuEqKJhHn0CVb1mxDg8jNppZCaf/afXUAAgx3QGFWOTAYULMaRPFFdcB1PqB8YrD5V24aaYFCVxPaYRQKeYDZqsuROlrwubhoYobentQsoIlPuVxreLHh4n9b8ZTyJa7cNQFEf0zWXVqArQJ+G644GqHl8IgwNx7mb3BoNKKjRR5UwAib7AwxmmA63FpzFEjQsYuZjVCi5y6Tr5TLxrIzQ6g==
Received: from SJ0PR03CA0291.namprd03.prod.outlook.com (2603:10b6:a03:39e::26)
 by DS7PR12MB6215.namprd12.prod.outlook.com (2603:10b6:8:95::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7270.17; Wed, 7 Feb 2024 05:27:40 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::48) by SJ0PR03CA0291.outlook.office365.com
 (2603:10b6:a03:39e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37 via Frontend
 Transport; Wed, 7 Feb 2024 05:27:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Wed, 7 Feb 2024 05:27:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 6 Feb 2024
 21:27:25 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 6 Feb
 2024 21:27:24 -0800
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 6 Feb 2024 21:27:23 -0800
Date: Tue, 6 Feb 2024 21:27:22 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Joerg Roedel
	<jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>, Moritz Fischer
	<moritzf@google.com>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 00/17] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <ZcMUujkhNkhEpOSP@Asurada-Nvidia>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|DS7PR12MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c034bbd-ef32-4643-7121-08dc279d805c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rLsrpCWYRJkJb2tYx2JGqJ9fOQRORRgFUD9Wk1dyBz/o/amUMQkaJxmtAIJvdbQXJZCaA92+u7KmVm0ie19cfxa3FebnY8jlNbUV+kHwmnKLVYqjgJJq8XSjPAl6juYq0SkPzdm59fgTZMdlEEfjGpZLlZaJfRB1ML1boznyH1nzwSb5cFfB6BO0M6eOgepFTN3ouJ0gGQ8ccdwA1+mOaKL103deLOoZHw5t8SMwwUsH9bBezcOxx6gpBRY1Ar2VMJrrtde4fAouXKsYmHMFHcrrZXYQKYSRcDbtSU39aePMOOw6Dtjyl00m6dLp6lIdxH0g6WbexuMMQUKxDi5lR+blG+eXfJHY/R3UdJ2ThDpYWeBYvbxlniqxxHdbV3NLH3VzTYlm9DwIj85gV6EY5Zs5ccQid5Mfg2J7ssGXIZQhNuI1BY6wY7ACYwlm70vCYHp0yXgsJWYF6EXoJw+zMh+pvMF3QvVgOykz8RlCKQToWIYqVO4q9C4xmJ0kfFo2gXmF7ZEEl+NzvyHsky+qms7HhgcJu3U7T41dCxDHbiWR4MaFGSN1xVpeISKJ0JbV0wDeKwwatrpLwDa5TXQAVnMSCWQwTSNNtGL2ITM+QXoEayUzvzkwtiNFnbt/tU42ztg4lNc7iruxLkG0AimtE6D3eH+GFV9ar3lGnqDMSn1NLYK/4OpjZraG1o0UvmAGeCCL3OalfYtwaoqoySYx5xHxfh4wisd0T4VZdAMUeOnfVS3PdvMlXv6UiBsImrfONa3a+clnbmGlK7FiFi88xQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(39860400002)(376002)(230922051799003)(451199024)(82310400011)(186009)(1800799012)(64100799003)(46966006)(36840700001)(40470700004)(26005)(336012)(478600001)(86362001)(426003)(36860700001)(9686003)(33716001)(356005)(47076005)(966005)(55016003)(40480700001)(7636003)(83380400001)(40460700003)(82740400003)(316002)(54906003)(70586007)(4326008)(8676002)(70206006)(5660300002)(41300700001)(7416002)(15650500001)(2906002)(6636002)(6862004)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 05:27:39.6345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c034bbd-ef32-4643-7121-08dc279d805c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6215

On Tue, Feb 06, 2024 at 11:12:37AM -0400, Jason Gunthorpe wrote:
> The SMMUv3 driver was originally written in 2015 when the iommu driver
> facing API looked quite different. The API has evolved, especially lately,
> and the driver has fallen behind.
> 
> This work aims to bring make the SMMUv3 driver the best IOMMU driver with
> the most comprehensive implementation of the API. After all parts it
> addresses:
> 
>  - Global static BLOCKED and IDENTITY domains with 'never fail' attach
>    semantics. BLOCKED is desired for efficient VFIO.
> 
>  - Support map before attach for PAGING iommu_domains.
> 
>  - attach_dev failure does not change the HW configuration.
> 
>  - Fully hitless transitions between IDENTITY -> DMA -> IDENTITY.
>    The API has IOMMU_RESV_DIRECT which is expected to be
>    continuously translating.
> 
>  - Safe transitions between PAGING -> BLOCKED, do not ever temporarily
>    do IDENTITY. This is required for iommufd security.
> 
>  - Full PASID API support including:
>     - S1/SVA domains attached to PASIDs
>     - IDENTITY/BLOCKED/S1 attached to RID
>     - Change of the RID domain while PASIDs are attached
> 
>  - Streamlined SVA support using the core infrastructure
> 
>  - Hitless, whenever possible, change between two domains
> 
>  - iommufd IOMMU_GET_HW_INFO, IOMMU_HWPT_ALLOC_NEST_PARENT, and
>    IOMMU_DOMAIN_NESTED support
> 
> Over all these things are going to become more accessible to iommufd, and
> exposed to VMs, so it is important for the driver to have a robust
> implementation of the API.
> 
> The work is split into three parts, with this part largely focusing on the
> STE and building up to the BLOCKED & IDENTITY global static domains.
> 
> The second part largely focuses on the CD and builds up to having a common
> PASID infrastructure that SVA and S1 domains equally use.
> 
> The third part has some random cleanups and the iommufd related parts.
> 
> Overall this takes the approach of turning the STE/CD programming upside
> down where the CD/STE value is computed right at a driver callback
> function and then pushed down into programming logic. The programming
> logic hides the details of the required CD/STE tear-less update. This
> makes the CD/STE functions independent of the arm_smmu_domain which makes
> it fairly straightforward to untangle all the different call chains, and
> add news ones.
> 
> Further, this frees the arm_smmu_domain related logic from keeping track
> of what state the STE/CD is currently in so it can carefully sequence the
> correct update. There are many new update pairs that are subtly introduced
> as the work progresses.
> 
> The locking to support BTM via arm_smmu_asid_lock is a bit subtle right
> now and patches throughout this work adjust and tighten this so that it is
> clearer and doesn't get broken.
> 
> Once the lower STE layers no longer need to touch arm_smmu_domain we can
> isolate struct arm_smmu_domain to be only used for PAGING domains, audit
> all the to_smmu_domain() calls to be only in PAGING domain ops, and
> introduce the normal global static BLOCKED/IDENTITY domains using the new
> STE infrastructure. Part 2 will ultimately migrate SVA over to use
> arm_smmu_domain as well.
> 
> All parts are on github:
> 
>  https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> 
> v5:
>  - Rebase on v6.8-rc3
>  - Remove the writer argument to arm_smmu_entry_writer_ops get_used()
>  - Swap order of hweight tests so one call to hweight8() can be removed
>  - Add STRTAB_STE_2_S2VMID used for STRTAB_STE_0_CFG_S1_TRANS, for
>    S2 bypass the VMID is used but 0
>  - Be more exact when generating STEs and store 0's to document the HW
>    is using that value and 0 is actually a deliberate choice for VMID and
>    SHCFG.
>  - Remove cd_table argument to arm_smmu_make_cdtable_ste()
>  - Put arm_smmu_rmr_install_bypass_ste() after setting up a 2 level table
>  - Pull patch "Check that the RID domain is S1 in SVA" from part 2 to
>    guard against memory corruption on failure paths
>  - Tighten the used logic for SHCFG to accommodate nesting patches in
>    part 3
>  - Additional comments and commit message adjustments

I have retested this v5 alone with SVA cases and system sanity.

I also did similar tests with part-2 in the "smmuv3_newapi" branch,
plus adding "iommu.passthrough=y" string to cover the S1DSS.BYPASS
use case.

After that, I retested the entire branch including part-3 with a
nested-smmu VM, to cover different STE configurations.

All results look good.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
