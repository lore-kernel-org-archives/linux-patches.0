Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B25E2F6560;
	Tue,  7 Jul 2026 23:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783466482; cv=fail; b=hu8UaTYKWmg9aRrq4PnBM1amY8ZWZz1ElbpYcc2pQqZ/tYABUWG7R2DtOOUtK9utfYxJ6uNz5sqwkF5t3Rfo1KbHFW5XdeLTQp4caDvJC+4ALBehJTC/S0452d2oiAGljVfjsdFKziB1CTQOrL/BaDbk9MAZhETajiU9UVVIXJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783466482; c=relaxed/simple;
	bh=WDjHXvlwLb+1kte82056yIwMO37JhhmrS/l8THVVbrU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZe15zUoBq3eAIAHCQkUwOF336EXT40uQyAQjBW9tQbwwbePX43zxtfCMUVGO5+v26+oNXoTvU/hfI3CZou+ycq6VoREMyuSgVruvWIvxOEiFzndTfYCJWFI3FyWRMcAJewJ8W5mPBUj1gHaotNDp1Hj8AAvCJL91Dd1unYXy+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MJVXSIIT; arc=fail smtp.client-ip=40.93.194.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MJVXSIIT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xwQAtDmS37WMbERAjxGEN2N3r4dCAFS1jdd0PkZcjBfOxJAZUo2J/0upU610js4NpRwQkGLdnOkMNApIHZtHJTuMjGtoOTLIZviTB0U99K5C6qDh2v0EViykQ4UfUxTpylA/cS89fxcXfyqU+ty0eSWr27RrCPBmoIrEfvAbNVDoKmYManTolMGsoqRtxYu19T7ElsJi55wKQS42Q6nbZ3eRWTihdLkawZFOxMFBIl5aNMh+iJcRPtTkA0mjVUcfWpLDTVKQS+LB5ek37xaXdbT7UyxfoZT7Fg16oy8x10ZbyoV/IlQSsiVOTf5BXPx6xl6H1ImSyRsOPFLVBXYKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPzJYV4MenTb6H58/PRwldHbGmCjqD0WywXAdTUmfOY=;
 b=V5c1VKZS5veSeCDnKSaTOSmZaYXkLil7tMYVsDNF4NkTzn9UVoeCLyQwmvorl6rH4SDYZVxYdKb70fezBk7/rIg8y+DxBb8UiCGYM7th99dL1Y/SdA6XvgCJsNRREnYvwcQwlHYfFV8YbtgpZNWHIM/Q8DEFuBgFKJtylfrz4/E5y2rbyG1QThBndZPDxZ1d252ToS6vofA/X6lflN+ZlyrKslpMqhGNtNQ/JERccrK95KcHKg5rRTn4VgVmE2NcBupxmyU7OHZm3egzS0LIbKM7d8ZrVvxYDEyj5hC/mSOQX3JEUD797FDRczb7MScQKFUxQyJAU+1RxJ+14iIakw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPzJYV4MenTb6H58/PRwldHbGmCjqD0WywXAdTUmfOY=;
 b=MJVXSIITLhplcXw9okkiGpDZ6N0O9CbbM5iGis8rTSF5xp86Fx6Q1UgyW61dPd9bdVqkaesKBz1GmJvpoTAaGE3To/sL3Fb5ncXuWQgJbuHIwHSefAyN4bg5vMU8nX+NWQ0le5vJr/lVXDsmXxIJCu7KRqwZXpyeu2RN2yxqieLJQJ7GXSzUm3rSHNTV+YOViWic4WWUYQiAshX40gKB4KIztxo1hf/jAl8tkIgKKziBChC/exinQZqRdsm68iOo4Su0rjoO8B6x9nBlN/ujmk38oFOOm6fHbxSgRBKvP4sLokdyZuJjaiq4kvzgnLFJ+4aR7+zji1tjzukTzyonCQ==
Received: from MN0P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::17)
 by DS0PR12MB8504.namprd12.prod.outlook.com (2603:10b6:8:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 23:21:15 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:208:52b:cafe::1f) by MN0P223CA0028.outlook.office365.com
 (2603:10b6:208:52b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.9 via Frontend Transport; Tue, 7
 Jul 2026 23:21:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 23:21:15 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 16:21:00 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 7 Jul 2026 16:21:00 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 16:20:59 -0700
Date: Tue, 7 Jul 2026 16:20:58 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support the DS expansion of
 RIL's SCALE
Message-ID: <ak2J2gLgXD7WJbfv@Asurada-Nvidia>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <8-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|DS0PR12MB8504:EE_
X-MS-Office365-Filtering-Correlation-Id: 619bb7ab-4b58-4358-2560-08dedc7e7117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|1800799024|82310400026|56012099006|4143699003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ih6Fzo+rB/u286eW1HPPQxxxaN9KxuB0UY+LwuDm0kcaKB818hRmmV6VjFMbYT/fJfJATY+fK0dIXrbQh0q8MiFrP2pyu3zxdNo7ta/CqIKnlG4X+yMhMIRwLpA/uirsjSOsPa1eDgKFaaYRYUvj21QaTpuIcN3gqYVTnwaA2rQvqBeoicENrfw+eQFHvNZOh138l5IYZzcHkpXfZeA1MEhoIKFSU3qCJEk3Gk8e9kFUdl/o7cwR0+P57q67sbxOWiEepyJTEqlnm2lWp+KD0cfxgcTQfljfRwdI87OlqOE3AnmxlGuBd6T9MMaWPf853Tu/Sl+I/jN1cOaQcup+vH8yI54dAvBtNGu5OS1/t3axvExSBtkrFGfmg76rl23OZokLKCdn4Ikgi/512ieqIwBwKhdjm01PNVoiU2NlRsD0AWle9MpKcFl6X5lHJwWv7I3OtX6Uq05i7tCJXwMQdbdJgKkWQJy1FdKREST6YaBWnMI89dXZrcavumlt4hgfxN+MW+FJcsz0ZjaM1kdweDcmiR/3rb/x13vqrPi4/ZMP6K65F+BxCaaEI3Sfcsy3sdo9gEZiDHJTuJNM2JSoBdLgzoApDJq9ekYjDg8Ckbn6bzDpCBcGApgUlHFlE0jHySE7PuzfsbNey17IRChRBxsCDJGp294tZxJ7X68+CjYJWGJo5cRIhI5iXgiSyoLOk8Jdp9H+ZcSYUSfKNSWK0A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(1800799024)(82310400026)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M1alDuiBNP0VcOnGIsTEwiXua/JVcVGv8NLdnCJE6q9kc/0OakLiEiwIcEksTeZFOamW73/6c2pjrXp7lK7Y6whcyQgOIj9mh4EDCEaQs7bWRAcQlc9ZM1vJNvL433mYGyAbF9bC9YhlZscSkRHiuAOXY+GZKKHuTGhqQSLjrTs/SylcDeakegbqGFkqZaXPIUceoAHodSSJwTd/vx0koM3sUyheD+uniBl6VP05grDdiH0mVOR9WY0ji58IsL27fhV5lbfKxqUE/6ZeDbevkNSAZDPp+9OHT8CiZ2HGVqERFQ5+GMqPCGwDqzCvaq9Ye7lRYdFVeQXL2AuQvws0lQt81UfUx9XD7d7NHwg8hGqDnGA3X6wdNxFYM2dXoC5Q8I3rZ4RL9fcZkrjdqO46lh1CJr4y/zmSpp3b/ZfobQr4sMued4WYoK0MSa56OJhw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 23:21:15.2632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 619bb7ab-4b58-4358-2560-08dedc7e7117
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8504

On Mon, Jul 06, 2026 at 01:26:45PM -0300, Jason Gunthorpe wrote:
> If DS is supported then SCALE can go up to 39. Detect the IDR and compute
> a scale max that is compatible for the entire invs list.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> @@ -5235,6 +5242,9 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>  	/* Maximum number of outstanding stalls */
>  	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
>  
> +	if (reg & IDR5_DS)
> +		smmu->features |= ARM_SMMU_FEAT_DS;
> +

Just a note here:

This somehow conflicts with my iommufd_invalidation_loop series
where we sanitize user space commands, because the driver would
support IDR5.DS. So, one of the series would need a rebase.

Nicolin
