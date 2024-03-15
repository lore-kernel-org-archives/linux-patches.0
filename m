Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D52ECA4E;
	Fri, 15 Mar 2024 03:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710473928; cv=fail; b=SMI39RxWlTsqf2jOJ+laIg349DwxT9KXBHS30/JYfNb+C0n4EmGTOZnfI5C43aq/K+VqorSVog42birCmIpwJVjIdYDkJG0FrTZVY295AvS64A+2Ocx5/6zREpsaFEPxO/BNg9Yr9iD0I8qGawYqUf+aFTtof2HEtfrzFQ2GKKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710473928; c=relaxed/simple;
	bh=VwgZ+DW4nJj/RtnbRCmC1VHNFGq7xO7AR2k1rp5SZEg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaXAyta2PbxMU5rim8MhfsOrRI3rgz4g8Cpxp2xOCXHSlwsuLTcHRl0/EsIujwUs+2iNQlKkUbBf9idx6vj77LqlxJEKDMcu6Cvat672lH7/sQshVw84U9YHV2PNxa0cV+isOVNhXMvLCrMKMuhSG6hGKNkbj+3h0FaDPESG/mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DPtbxpNo; arc=fail smtp.client-ip=40.107.220.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DPtbxpNo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BobACi730pL7Ih/Frd14RumEhsQ1SJKhPLywRHoHyCB4zWmT+7Rg4uC9A7SowcaKP+cFFpesA8rcvuXPj6HwtTLfhOg1YN4ySZrDq4GL3+8sjENhuSnvERccv/To/YwQ3EPYisdGPbZXtSnm+239OZxhQFTzXKEvD2JgHAD2ykWpcl6A9S/P+9/Q4Qk/u1D2B3GmgzDwnABkM5ssJ50PYnxf3twp5KcvXvWwUZ/AxpOdg9MsFae49de6ntVWXZEqCTdOWNn/yc0sJBmKO11KlLfzy9JVPFMVJjALaOIvxiGn/e3MVYKbV/kgqAGzRcjwglF6efm9v+NqznUnAILcwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEmys+ZX+zeFeE0v7go9rI4F1OaBvXg2rC1YEaWBljk=;
 b=j47TlHkU9ehEyp3QeJuNg9GeT59rssxlNRMMQVLSYE08sOoRiaZ24Nb6RxNlNlcnXrWucX1scnHMUlEFt7Tcyrrg4sD4rWVy8Ad+gImNoxGPvr+S2dtUg/qgYF5NJ3niJlaDiVnSRmMq2IeENorkGE/o3Lap9oJ0GTO3F+gPy/4EaVypLEnEuy4051saoQiktddODkBXYflnNBuW1c5Wc0qlTK+Eu3jVKJHzgVONsVQ4dxyJCxwPnMlfCNwnFXLEEb37G74RqwxISt/MyvGbe6wur+0n02zR2dxD1H4gb7Dn8ZGbLCuqZPDcdi2xJm1HF+LIcDhwdcrLx6+UE/ts9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEmys+ZX+zeFeE0v7go9rI4F1OaBvXg2rC1YEaWBljk=;
 b=DPtbxpNobOTuKJoJ+5h+FHGoMsjzbhOghmqP+SJhR9UAhqYH8w/tRvP1tE6G3yKnQggFJuBCbB6z9u2hZDIPItLDVCs0C4La49Na42xRYbYjy2pfkJMmFcLJ4CGXCX6XE5LiHs+E5XQXwcqW0S2zbe9QhHtTyrIEFKyXkVQUInqPydVP3DOFFPxtmLMkVJdhTHNbLmXjPPvWzLd3JsYJe1BNRYlkZnpk5+bMsuZ4XeCFNBuVh2+peEN3mdTcIUlWyOw89C6C3i+kbJMjAz3Iok1gWhK3yOTrufH+Wfu8Jcq5fo54AMCGKPDqkVhYAMSrQexHfZvRVRGhgGqpunCgcw==
Received: from SA1P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::24)
 by BL1PR12MB5947.namprd12.prod.outlook.com (2603:10b6:208:39a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Fri, 15 Mar
 2024 03:38:42 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::dd) by SA1P222CA0029.outlook.office365.com
 (2603:10b6:806:22c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21 via Frontend
 Transport; Fri, 15 Mar 2024 03:38:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Fri, 15 Mar 2024 03:38:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Mar
 2024 20:38:36 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Thu, 14 Mar 2024 20:38:36 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 14 Mar 2024 20:38:33 -0700
Date: Thu, 14 Mar 2024 20:38:30 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 01/27] iommu/arm-smmu-v3: Do not allow a SVA domain to
 be set on the wrong PASID
Message-ID: <ZfPCtmyN1v68UOha@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|BL1PR12MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: abd7b16a-3de0-4924-2e0e-08dc44a16900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ewOmDpvAEw44pwW3iQNGC2zfV2tLhkASyA8QQ8GYNYNbViuS9UNF8T+HE8g8MywKJcRVmumTO6aXlfg36UDEhM+OkGOaeqioZPt1Lx+3HNngv84PdufoymtRfpbqDIcRLDD4Fw+bdsPUPFSZjw3gzdYWZRQmLy5HNzicdGEnpzK5vG7Ge801fnHMwYN40B9zAx8dpq5xQVdVMZ4aWxrMOMwzCCPXYdUssvKUKTbDquQw2RVk6wxUB3rp67RnOTbkm+ntkTGV+qSveF8QCCpNXF7zmqtkEsuAbf2aJ6aOHNhEnaCvUkhMQSYsDNyIcbjvSHkR8Tj9vYRCD2QU/Npaq/ez2n+UFv6HgJ0F/UA/7PHYmxwPuVbrZcdsMexFEKKzNtQvJMLWmJhjwnrt5at3yrWVa389rZYRNLV8v/VmhUQNBC6gVFf9eHdUA/fbA1B33yDrLnji3iEmJzos4Q1RRK+TUION0LZIo/0vxAv6XeIFUzJt+LMM3Yn2sh6dyLaNYzDkLDWpsR6Nfc8C53Zu+cL7f5R4km0F3lBtg/eB60bhrr+UiFgiSe/3MJ4VsLHqgxrL9Bx2TixJYiNjD4BmScxHn3Y+10KDDuDdCdQ8esNuLcw8l5/pbnnWtKGe7ddn3DoTrntb2my9T+hLoCZuZH1qxRcWRK8TiN+veFfDWdnronKp6XMUO1TF709Qn9yEUFR7ir6Cy1uNYlDUCVP5nGmHJGlZE5NDCPuyUgs18Lqqmpz7/pgzbQwrgNccA5hl
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 03:38:42.0560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abd7b16a-3de0-4924-2e0e-08dc44a16900
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5947

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:49PM -0400, Jason Gunthorpe wrote:
> The SVA code is wired to assume that the SVA is programmed onto the
> mm->pasid. The current core code always does this, so it is fine.
> 
> Add a check for clarity.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 2610e82c0ecd0d..347c2fdd865c1a 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -581,6 +581,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
>  	int ret = 0;
>  	struct mm_struct *mm = domain->mm;
>  
> +	if (mm_get_enqcmd_pasid(mm) != id)
> +		return -EINVAL;
> +

This seems to get deleted entirely by a followup change. Is it
added here to ensure a 1:1 mapping for git-bisect?

Thanks
Nicolin
