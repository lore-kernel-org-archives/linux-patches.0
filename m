Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4942417F3;
	Mon, 13 May 2024 08:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715589113; cv=fail; b=sZsgctcDrzgIUhs9q9sYn4WVqd9Jwf0J1DS+RL9ZXxwSH6+yPvOkSch7n5YDxcP3IyE5yETnyCBfQAV3c42AvP6keSK3DI6f0WFY4uf3COiJBiMtfmGfK9yy0xfZC3Sf1bETF8pXThbKNR1sIbZlDc0e/Pr636F/eN8/XZcaKxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715589113; c=relaxed/simple;
	bh=hA/Wn/7e4rHMHxTQZMREuaQYLQdbZKVVSjXzLbHqocg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBrfjOBcKuDpbyIZSz71wsLteJKqdNsKzYgu517zsoHDrlXie5FS0dVHZTYopVEUz+yDoS9o/ocSKUjuC2xg98Qwu419MSDEZIBtrU1S4b/iVFeU+NGJqIfshgCl9fdvH7kM6d4k1DTP3OKZKff6dp2RYaNE4Ii9kH+Y+ZSraHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XaZv6gUu; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XaZv6gUu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1wP5dl3CwcstLhvcoCWu/9ef3MU0QbJoUdoqne2xuHk8IZHRN7B7zC+1QdnB5ZjYRBrzI9o8jB67gCh6WdoQVFt9pfFHfQnQkO5RrmCzKi0nN5CAZiBP/9/6SGwXow1TXjOKhucSk80cxevuBJTxioR99PY+tSqgNCM8QE8ElIxtWbf0i2f755wn0X2qwUjKN4VlyhqbHUY7LyszUuysp4Em3dwSibs3cb3CphjECg1rWLdBWO3XuYq3oaqpCVVl2GkYT8edHIyXEvjSx5zoOxIIIyYNbuqrhuqrNTgvUWIBuxyOkblP7npBc9i7oyt8kYPwN2hWUek71zpVFfSvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YBQMhQhlU8iU1Uu0KYGoFKZgtYZuIm2BzcOamSHDI8=;
 b=BzcdIosGfThrNjzQr0pmxEV1UbmuSscUVMtqZ/YB0RP88oRgVKwb0mkITnQM95misuolRlconQHnqAZBegRlPHyY9/Oo5w+LUDEM2sKsBvio8l4+yOns8HVgSOp16R8LjmJGY2e2pet3yuFQW696CcKWBDsl711DM3OgO6IT6+uKR985CRB22f/WRjLeZCAk+PGySsMWuRIkofe/eHnvfTGWMisLlTxr0rIHKnO9B/D0CfShTBnsv3McTe5RYLB4U11s5jR+lW90Hc/xIzpMpeApiB3VvG2Of2sqYbNVbEPLhcAOjpHUFsJvyaH60WJ4lh+iT/Byc10OQGsDqHV5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YBQMhQhlU8iU1Uu0KYGoFKZgtYZuIm2BzcOamSHDI8=;
 b=XaZv6gUuVE4OH15VD+ED52z8zZ2xS2KAPBpMC3Js6J2TtagqkxkEuWreFMyQxL+PXxCmXAAX/u/kvWFJppQgp7kdHSptzo98gAbXFDdlEbHL+LxExfd43tC3iis5JyuYViSwz+Itv8pJ7yKE7Y7fPlDDoXZJ/FAziHIAEM9ri0uB3fthRDQOttfV9b5UbpOnyDAs3MBqXgXIVNyujOuX9tWKLg1P6B9SypbAreh+PXiAKbvN2ZFYMx8d/IvYa2DS4JkeZIZhGIi5iFx/dMUO9MyztKDqDWakNVf6y1iCrL6d1EPCziOZRfz1INQFRyChALWza4/o7Pym8iUFoq7qOQ==
Received: from MW4PR03CA0360.namprd03.prod.outlook.com (2603:10b6:303:dc::35)
 by SN7PR12MB7321.namprd12.prod.outlook.com (2603:10b6:806:298::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 08:31:49 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:303:dc:cafe::bf) by MW4PR03CA0360.outlook.office365.com
 (2603:10b6:303:dc::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 08:31:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 08:31:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 01:31:37 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 01:31:36 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 13 May 2024 01:31:34 -0700
Date: Mon, 13 May 2024 01:31:31 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 13/14] iommu/arm-smmu-v3: Allow a PASID to be set when
 RID is IDENTITY/BLOCKED
Message-ID: <ZkHP40H2xeE3cyPB@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <13-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <13-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|SN7PR12MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5c1dba-4fc6-459c-919a-08dc7327221f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|7416005|1800799015|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9x5Ulfu8lOEXT1NKetzZ/gR/xJMyx0HF79GrwPr44Do7uTwb4wGAtHEXF9Dm?=
 =?us-ascii?Q?dIcHymFIFzrSnRJOZ0NjMrgyYCTMyKpNRk+1kzhfOSDwxkc44ooI1WAkWThP?=
 =?us-ascii?Q?QDzU7bPgZgJWruPlxcOnnnvjxIX5sDABCG2uOluoYRj9cjC7JwvDgo/yQTL+?=
 =?us-ascii?Q?aqKaSqRq1HL4VtODSXWdEdQbUpEDa4PCAZA5xwpl5ErGkfC90nLqJokjwICK?=
 =?us-ascii?Q?BpLksH1dzcsjAmkbnIKHvUA4S3p0yNYN+3zcQkKLzdTWuyv5JSCfPDJZwR4K?=
 =?us-ascii?Q?EpIrWKvnHjpEU2UoT55953na/VRoUyXshC9+e/OG9VEsA9/+rk60Tyzb0vsT?=
 =?us-ascii?Q?+K0VRzQJxJjqMg4k2pHgtyIJhzYilfERTbyJtybB5Ki+VPXRCdXOvW0M9Iew?=
 =?us-ascii?Q?4lpNJwYW3YUEOAyZM7mGP7yH4Fcl7Q/qCguQvi7OLHIxN/Yxz5Z2Un71mLT6?=
 =?us-ascii?Q?whfiIh6HROA9BN+3M8sBli09tNRRH/oVVyavyKvU49krBjEod1UejtpRnGBv?=
 =?us-ascii?Q?yFe3ctiX4FTSxlA59pB8LaqtcZVOUsv5tyjIoc+5XowGpbuKpz8BC7vws4R+?=
 =?us-ascii?Q?MURBkuHqDjw1WbFQHWXecRqHcpexLnekl2PY4OpOLkAtgU61pdWPzyJ8IzQt?=
 =?us-ascii?Q?fpFHVxHNlYWNa8FqZRokZ+1DITMHbVVQaPNIHl2haKX7ZZqze8rzvo1oKMyn?=
 =?us-ascii?Q?XUd529rC1dPCas9ywIHVjSh1DtXv85GlObANY7MDEc0hk0bkwhL/qCgCEpNr?=
 =?us-ascii?Q?P6qZvtJtgLFcT0wa0DT9saVV4V2zu0nF5igctgwobHj5rujXhphyg6ZA+GRU?=
 =?us-ascii?Q?/r4HE9Y9IDXM4qMYHUcDoitEbZZNlKH6EerB2nkzByBrXQ071uXfSADm49xT?=
 =?us-ascii?Q?q9OmEzT5NYCw0+zfRnRhCjX159pTUEr2tB9MSlB+b2L3DCyj30LjJeEvpoyO?=
 =?us-ascii?Q?h6ahBqgGURTnrSn7H832/97cSElCHXsEUNi6VkXheQUnnoTW/0pM+4mqyeCr?=
 =?us-ascii?Q?85RLfIqPLV4iXdu3RLAdtnMajLbwSJhW5e5MA9lOMtVcgwk/Q4SsImy+MXcn?=
 =?us-ascii?Q?qLZA+b4mPMZOrzfMdYh+o5E8l3I6Wfp0O8hxnZYotwLb0T+7ybkr4vw6MML/?=
 =?us-ascii?Q?VdZr72T7MpoGbPVGEEwaPu1Hmn3WwigQ6v7M9x3HxCVyjdbV/mHSNIcIXDte?=
 =?us-ascii?Q?bZWENF7KxuQbDRewYFyFAmw+XW8kMkoDFAXtvvqStIr2s+Qdsu/6v1yTtyV1?=
 =?us-ascii?Q?o0IJsBFLPxaYznGzSyWU8Jtnd7En6Uvr5s5EONHrBsq3KS3x57E+O/QDVd5t?=
 =?us-ascii?Q?Ubegxof1cY+ulzZcXdklkrzE2UbwT1tX8S9KSm6oayWWmUPHVVMlyqykK+So?=
 =?us-ascii?Q?bo6uR8e8akyyKxRmM/H49ZDT8QBR?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(7416005)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 08:31:49.2087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5c1dba-4fc6-459c-919a-08dc7327221f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7321

On Wed, May 08, 2024 at 03:57:21PM -0300, Jason Gunthorpe wrote:
> If the STE doesn't point to the CD table we can upgrade it by
> reprogramming the STE with the appropriate S1DSS. We may also need to turn
> on ATS at the same time.
> 
> Keep track if the installed STE is pointing at the cd_table and the ATS
> state to trigger this path.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 49 ++++++++++++++++++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +-
>  2 files changed, 49 insertions(+), 3 deletions(-)
  
> @@ -2819,6 +2851,19 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
>  		arm_smmu_atc_inv_master(master, pasid);
>  	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
>  	mutex_unlock(&arm_smmu_asid_lock);
> +
> +	/*
> +	 * When the last user of the CD table goes away downgrade the STE back
> +	 * to a non-cd_table one.
> +	 */
> +	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
> +		struct iommu_domain *sid_domain =
> +			iommu_get_domain_for_dev(master->dev);
> +
> +		if (domain->type == IOMMU_DOMAIN_IDENTITY ||
> +		    domain->type == IOMMU_DOMAIN_BLOCKED)
> +			sid_domain->ops->attach_dev(sid_domain, dev);

Should we check against sid_domain->type instead?

Thanks
Nicolin
