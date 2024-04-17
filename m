Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCCF184D;
	Wed, 17 Apr 2024 07:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713339468; cv=fail; b=B/G9S3V0wU+DoINKJ/ddsduQ8LqAgrFChNCeD9bep4W0j78KKL83HTdpLT+okepK2km9704XwXvlX1xB0MsRsCFa/LLRUw6oRPT7nGIGXKZiut+Yx80HVMpH+92AuVkZhELS3keMiPiQOCVHeLLZwvW4RhZvtycBoWc9OaQcObA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713339468; c=relaxed/simple;
	bh=ngD5u2CzrdnHCpsgqOnO3iSY5ODiTt0vUJqu0lSJsxg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGBHXdrclBgEOFAuBkw9n791bp/0OIxvC5Vy6zozqC5gsPC0OrzAWHbiJBvxpY7jVmDS+D/170p0m2UDp+kiSFbnUqSGz7cRjOPMTtYseBFLXxZ/Ryx3/pD+Zw80OwfI/zSHVaR/CHK86Ktj8HnGnNWo+on3mYIRk6epHN77onA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kJ+uJCSx; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kJ+uJCSx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9E5PocJ1/EOXZObVMm/mi5syM9smU63qDChxPnVNx0mncln/uM5hbRQJgam8AV7u54h6Y73puXFfRX3ZTzQ/SvZYPfjoQc+z97oQf6Hr4xao/5whhYcMTot6rixdG+/zEt8MWavfzAIOXliqLr54roZ5PXWNW8C2tj3CKLrX6hJ6Yhzh5pY7slpkfCyHWUo9vx9agaEKRNGESOAtDSkaSS1vOxY8jAODV3LOPMDR9/A8yCX846aLNMPXmRAF/OJwLMpXIsCR0HulO2cvtVgHduFfEGHZxBeu7+XorTznJa0mPDBkWEgWbFq25kUyPL9zOZiKA+H+bTFTmlU4I+LzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+BFtTS+UgOJ8cjKQmcYkt5zpLIicpERrOO2f/K1nu4=;
 b=bkx0NptimteyG//aWCPv/YTMUiJZDjNRaZ5grY+kBk3NLwUrczfZjSiKVhlYxCia2WHr+k8WI1UhUs2ZbcHZ2u1ABhZmo0IbIpnMVMOKaeUuGZXV2Fg42Iw9b4SL9IAvrmIphR2v/vWnHPedXnH3ve5MAbe1ZNM+ge8FG6ihMTtULTB9rwOFQVISNur3aS4KYeFlQu0eF07+MXlOClYIH+oAhOYoOzZODIlCYHQRH3mIoN5NoA0foaqzUP2GooYf1G/4yMpy5bLFVT5zdHbyITG7sx9Oo6Q3SbE9U3huhtXWKp6uUSMkk/Wrte24WdDgvYNJ78R6HRbZDjv9MfZcCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+BFtTS+UgOJ8cjKQmcYkt5zpLIicpERrOO2f/K1nu4=;
 b=kJ+uJCSxWheRSlaoEr8MTBFpMIabw8o4MUGU8J74+BkxCKTCHCNGNt5bxiqn7Y9cd265GzMkqKLvwbOXEsnK4NGvj8eN2WyXHN/i7osKjqi30stdfYv5qkosnfLpPyuKbhJHj8dm/XOpTzo43FEdO6OEkElprzgo9/eb0CLcGkGG9G2AQSpC/VsMYVgydwKMtmOKUP00q3IZxBYF+f/Hb9K64UrH+gAVXIJleVZe1B28s3xbYpq9p7kclPgXzyTcL+SV00Iz9lfba2Cp3BBbQXCsQX8b6OUjtaxIXRy8HMeev1YZ24hmb0lmSAel2C55wL+fUs2ePUZa+r+d27cCKA==
Received: from DS7PR03CA0193.namprd03.prod.outlook.com (2603:10b6:5:3b6::18)
 by SN7PR12MB8604.namprd12.prod.outlook.com (2603:10b6:806:273::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 07:37:42 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:5:3b6:cafe::e9) by DS7PR03CA0193.outlook.office365.com
 (2603:10b6:5:3b6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.24 via Frontend
 Transport; Wed, 17 Apr 2024 07:37:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Wed, 17 Apr 2024 07:37:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 17 Apr
 2024 00:37:22 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 17 Apr
 2024 00:37:22 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 17 Apr 2024 00:37:21 -0700
Date: Wed, 17 Apr 2024 00:37:19 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA
 into a function
Message-ID: <Zh98L/vNPugu6JbV@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|SN7PR12MB8604:EE_
X-MS-Office365-Filtering-Correlation-Id: 189c837a-ed91-48ab-d683-08dc5eb143ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T19a6+I77FrOHD4yzf8b/IIImg/+1mq8MAry/kXRXhIafNO52JpTzyk/U2SiGMamEWUpOBsG0yw9pGV0SLMZ0n3p5cKH72jDR9NG/nlvDG9JxCbNpkmCzXKvlJQ8z0XTVwCqOt0OrBhDgSA7IMYwH9FohUeMKeCyZ6dEmRlkEAUIYxKAsyEKQ3H8KSJyV1UIwuqc0bO/s/a4RKSnF3he0hER2tP9ghXV+LVAXmQeMPGl2faKNdfqMk654NyRHK9I/GJiPJDDgzWE8yiHztbcUMJfeO1XO7cNXEcM7BbhQwFbk+19Tq4j5bD09GP9qyhOPSISXvhWCM8+mrHFjohH4RFdIHRiZA6Mqlw8zNbXF8W0xvG/2s7tQ88gCvvSlGpRt3W+Ghfw1LxK5HPktxyMrYuc0behXDJ+8c69k6O/WMFZBJLlh/D/aWnzqBVNnfINX1vtNkm3DCOkTC1tzDYpovj1QCpmhvpMr11otjeuU2ASZy8RCzGmu06yv8/sOv8D59bivTwWdWgKmnbmBoe7nUOziNnPcIUnwl/fpLmyIqQKQp6bmDaaeUhG7hwhC7+FsMnntOyFUKeCJs9wGC0QDnD0a+ecltiNYcBHEAwvRQrDX6V3FWk31v1IP5dmO0ruGZu+Hwph2OGxDzb/+cdT1qvXOHVOqGAsFIH/tgFwU5dOffXYr5LhEe7enDEJ3vpncb4b58hV3/blyF/YIswQHj86W5HIQNFoftPqFBKbQdG92SXGXjR4yqTtpYIaIyyK
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 07:37:42.0153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 189c837a-ed91-48ab-d683-08dc5eb143ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8604

On Tue, Apr 16, 2024 at 04:28:18PM -0300, Jason Gunthorpe wrote:
> Pull all the calculations for building the CD table entry for a mmu_struct
> into arm_smmu_make_sva_cd().
> 
> Call it in the two places installing the SVA CD table entry.
> 
> Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
> the function.
> 
> Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
> locking assertions to arm_smmu_alloc_cd_ptr() since
> arm_smmu_update_ctx_desc_devices() was the last problematic caller.
> 
> Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
> the same value.
> 
> The behavior of quiet_cd changes slightly, the old implementation edited
> the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
> entry. This version generates a full CD entry with a 0 TTB0 and relies on
> arm_smmu_write_cd_entry() to install it hitlessly.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

> +static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> +				 struct arm_smmu_master *master,
> +				 struct mm_struct *mm, u16 asid)
> +{
> +	u64 par;
> +
> +	memset(target, 0, sizeof(*target));
> +
> +	par = cpuid_feature_extract_unsigned_field(
> +		read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
> +		ID_AA64MMFR0_EL1_PARANGE_SHIFT);
> +
> +	target->data[0] = cpu_to_le64(
> +		CTXDESC_CD_0_TCR_EPD1 |
> +#ifdef __BIG_ENDIAN
> +		CTXDESC_CD_0_ENDI |
> +#endif
> +		CTXDESC_CD_0_V |
> +		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
> +		CTXDESC_CD_0_AA64 |
> +		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> +		CTXDESC_CD_0_R |
> +		CTXDESC_CD_0_A |
> +		CTXDESC_CD_0_ASET |
> +		FIELD_PREP(CTXDESC_CD_0_ASID, asid));

This is set for the new "quiet_cd" case too. IIUIC, it is used to
ease the switching back to a normal CD, i.e. mm != NULL case?

Thanks
Nicolin
