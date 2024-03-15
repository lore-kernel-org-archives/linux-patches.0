Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE3F1A38DA;
	Fri, 15 Mar 2024 04:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710476594; cv=fail; b=gu4As27s1T8Vt5t12xEygCW7REiLXfeN/7XQaILRJT5jpnct9hYTiXl/2JGoMppyq/a2wb0sFNOW9+bJz7FZ30DcxmuRxkz/sm5sMAMetu1nATBNW6u9d5P6IgCQwOIwOqfftaYYN75kABcdh18jo94dL5+tBHAUTh20rpwWHuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710476594; c=relaxed/simple;
	bh=L2plvn7BwST8pItt3zSQwBjd6TVkETb9k+48dTN7tuY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENZHHrzHRHycFVG2ZzDJeo6zG5Wl6+MrRFOHyJWocaFhNusiCsj+7Q/8Br76CxWIP3QFqzAmV9HUzJhYDmKWMCbqG3lwh3NAPtlBXgj5oJDu/VoHiS90vy1g+ZDoyV3/jz7bJ8TuEn7E11gJPxpLqursgmcIbw0okz0qcslD4RI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JU1jpKO+; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JU1jpKO+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5NweaXN8r5WAPFUvR5kJqAD4sC2iSvq40FloAt8Osb6v0Ff9lPePErq3hEQuUPYSvULpUevjmwWeUspV2V3ew7I3RRk5rWjV6kqvFcITiOiOk3Whx8NdCaQLs6pnVZ+c8Ly9qOW2XTQEcmsbgTQczhoxuuizvLPZWGsV2wRn/IM31w2wRF/R0tvCD4sLozMdamlEQkNHizzgrTOG1nL+t+KqtPZi7dLys/a8Bb3AK7TNt6RUSSBXQd1ka4vta5PWKQ68DOgWTiMjo6JUfpg5BIsqwhAqgW/i635vW6lnckSadm0t/kNNhgJAUXLoy8Nqv5Kwja8sgDyzlsUWSy96A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nloowUB7IOru7zEucvr2dthI6RCkBuT6rAtAOIRSzTg=;
 b=iCfdIc4czzsuw99QpDHOG2c8sYJ/kPkR//crg40c8QmqhWEhdBcxzf9PT/tPkphv0CoB0AWhANY0WV7sboDZvmf2vs/H8bnC+hmkHKtlpU8PAUPDVtOhrcWsoT/TAMPi7XEwkMRELDZQXUJCPlKfHKwMFgx8dWRFFumOwU1RP9CRW+g+fzkH4SjVC+ElxCFgyfu+EIybuOxmYceIDVGrotHM9Vdn38IjqSCk3n0bd1TpH1eeSr4cjtfyxb6jU2po8nXz2iiLeQTvLIkjLd5RINK0Yc99lxZy9G3FE8Bt5E0DxBXqEfeaKwgiWOxHySNerJKAIDK1E04PfM588qT8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nloowUB7IOru7zEucvr2dthI6RCkBuT6rAtAOIRSzTg=;
 b=JU1jpKO+JAA1cTz+B6F/h2SXlgp3xyyurPu+2k3Iqx6um8GL1/r+RgRJOfQAHoY2y/OI+6bG30IxLIxqLeK5viN4ntRxJfZlo+gy0uaBp2XkWeM+aVta/5pKql4kbouYFMkWHEMCpUxE8c82XN3YH8nqz+KXXvltpSYfKCSWTc6PeXUBCqsWzKimcU4ImpYHGGDfgQXtoxlM8wfRTzL34PMcFDF0xjWiPJIJ7+k3PA5Au4IXkPtZXX84DCWUx8M0Wqalc/zaNMW2gqj1y9GFWXeTpU5CuUx/bPq2IeHUKB83qSsk8cDlvSSH6nUWy5kZDEDiau6JMBo/MJ/egMFzDQ==
Received: from PH8PR22CA0024.namprd22.prod.outlook.com (2603:10b6:510:2d1::15)
 by CY5PR12MB6455.namprd12.prod.outlook.com (2603:10b6:930:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Fri, 15 Mar
 2024 04:23:09 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:510:2d1:cafe::79) by PH8PR22CA0024.outlook.office365.com
 (2603:10b6:510:2d1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21 via Frontend
 Transport; Fri, 15 Mar 2024 04:23:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Fri, 15 Mar 2024 04:23:08 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Mar
 2024 21:22:54 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Thu, 14 Mar 2024 21:22:54 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 14 Mar 2024 21:22:51 -0700
Date: Thu, 14 Mar 2024 21:22:48 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Michael Shavit <mshavit@google.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, <patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 04/27] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <ZfPNGPhdhcj6Mq3V@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|CY5PR12MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b050026-ca98-4b9f-3170-08dc44a79e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lQgkKSvepq0yqph2PVM85etjNI+Yj6mai6oUUyGZ1wRziwrxmHnZpIhpsoVofyc6JcfJErYeFxvr4s5afaCtD/ycWEVLN53/2CBhjPW/hi7OCbW/t8u9T+vzq4P87qKBnEtKkfPq/Z2vEzHxICeMu/q56Zo1krWtiNojxXfTDJqdo1CUpCPBrLGJpauAj4AJXnTPNNuKHZh5GlQTR+M1mAtRo21c6r8IGDr52wOmBzfkR4CdyCH3GIhL2UEyF6VDViJsUrw7b5pREibz7tfTObfKhbExsaUXsp2R9T9g/Xpd4x6Zhc1xa2njRbcZDea9dF8wK76HUjdPiNkoqeMW0n35EV2bN5Lf38kr0cq6yOJOmqty6XjQwiqhagUFPQlonzKVAIZvJWOoV5kdjp1znAeZ75fod77JskzTQQXs9tgjkwCcZnOehGQLoYYjmBAsuHEh/SuUR28ZtO3/6rbSVGcjGvT47RY0cOkn2Zd9yRecMt8wAYFB/IwsCsZaXVoW1nlkutwN8ROgAHWKhLXFTjXZ6nSvZpkIvxwIxVVmDT3olVlhKRbf64fd0ug34iQaNyjsX5p7RuA0RYKFaZL0nNvsbnJLrMiYQ+eZRUuqTVDdMwvKiElxiSbMaJfnJqsgn/4245lKxSVnRSgs2S/OLcCIx//V3Rh63RKL59vHsAiGxQDxFuRVhKG1G6W/UpAT+269E/rStprSOLbxoHAoyvL2hTvAe5OzSDUey7QO04mXka0NEDzu8bnWgpmAP/dG
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 04:23:08.8052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b050026-ca98-4b9f-3170-08dc44a79e84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6455

Hi Michael/Jason,

On Mon, Mar 04, 2024 at 07:43:52PM -0400, Jason Gunthorpe wrote:
> Prepare to put the CD code into the same mechanism. Add an ops indirection
> around all the STE specific code and make the worker functions independent
> of the entry content being processed.
> 
> get_used and sync ops are provided to hook the correct code.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 172 ++++++++++++--------
>  1 file changed, 104 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index c60b067c1f553e..b7f947e36f596f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,8 +48,20 @@ enum arm_smmu_msi_index {
>  	ARM_SMMU_MAX_MSIS,
>  };
>  
> -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
> -				      ioasid_t sid);
> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +	const struct arm_smmu_entry_writer_ops *ops;
> +	struct arm_smmu_master *master;
> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +	unsigned int num_entry_qwords;

I vaguely remember some related discussion, yet can't find it
out. So sorry for questioning this, if it's already discussed.
Aren't CD and STE having the same num_entry_qwords in terms of
their values? Feels like we can just use NUM_ENTRY_QWORDS?

> +	__le64 v_bit;
> +	void (*get_used)(const __le64 *entry, __le64 *used);
> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))

And this seems to be just a fixed "8"? Since both are defined
straightforwardly:

struct arm_smmu_ste {
	__le64 data[8];
};
...
struct arm_smmu_cd {
	__le64 data[8];
};

Might be a bit nitpicking, yet maybe the other way around?

#define NUM_ENTRY_QWORDS 8
...
struct arm_smmu_ste {
	__le64 data[NUM_ENTRY_QWORDS];
};
...
struct arm_smmu_cd {
	__le64 data[NUM_ENTRY_QWORDS];
};

Thanks
Nicolin
