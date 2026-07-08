Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF6E3ACF01;
	Wed,  8 Jul 2026 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783474932; cv=fail; b=kcq5w4kfzhGJRZeoC9xKQCMxvdV0QPgpoplcrtWDT/vLUWiyNwZRYn/b/eL0oCoekspMq/lOLLXUwcTgqWG3/pjPvKNxpDzLrWjE8OW7ta8MgsrBMIrNknK++qa3LhTG1wvQ5hVfe2nCb1GxSH7gzkkBG2LTlAGOEysJa4ID0GA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783474932; c=relaxed/simple;
	bh=jwu4l9jp2BJXMiNsnmqBcwMBSybdxgVnxzjYm0FQTs8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pMi4q/fn1et7NiWfScdD77Mm3ZiZ6Li8xgROBJdyLgvq2h6kE/tU32KVTk6bv1ck9zc0+/62Vh8qZWZC8iWDFolmhWqSTIwJeQXJN0myGDzd+f8b7/KBq3za6VymD/l1YQInkes/ASg+iOc2yu3nt9jzL6vFAMASdEfX43ipU1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NZrPnClK; arc=fail smtp.client-ip=40.93.195.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NZrPnClK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVdIKJs+QCvd8TAe8RfV941jrk+LPghTTHg9ydlU+nFzwBTCLz4WH2X+t7TaBU0wJLln/gmztODPBXXJMpX4vKVH213m00I+89j2pRqMKzwuHrV5+2NWB41yH8Svrf0zRYG5oVl1uIjfytsR+8iSxnT5GBALNBEqom62aT+1lsSf2VoaTainmPanZmUrV0dPkaPhPaggdIYwnmXYlCkql0vTpSlkONm5vDjhJR4ATGOD00Nc/gsZ1OuReEfBLCWF+FwifKzuww+dv3Ba5eRmlSIQMik+1+F660Dl9iZ9LIdXVMKdp2cWWYEQqdVedXb+1LVQx1l77x94IxFz2HA8vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yClgSqN6XRF0GKugnCbKN5v66Tb2R1f2qpw2RwZVkWY=;
 b=WejgrNy5OYOabDDZsJrZCoiUeIKW/fKPpiAG+8+GG2f/8s2RP7P/ypbIVAiBSZZYVj2ooud5vtrsswIDrudGqu5Pf+l6Jcz+lpHU9tZwOsM25KIJBjIpcsNSoTWm/Xim3ZEjYdVdtW9TxnMxOfzpnPktFPnTkGCicJIdKcpzaqruGQQDh0F7wjoURNc7hyoy0ymD0hpBIA4urYRVaVqqKAWd/IXtJ8wdRdgtMmPkBczZ66ebQg+JZeYY/l4wKvWi1q16pLLiHRd9TYstUcZgmYxVEiPPZxZBAsw2mWZqlCw7vglpwuiR5bmX3p5mkF7oX42bCk+mkU5rfsDrbT5CMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yClgSqN6XRF0GKugnCbKN5v66Tb2R1f2qpw2RwZVkWY=;
 b=NZrPnClKrDdykK7CsdBpLQp/JUlBv5uT0vIY0Cfq/Xyc1kCNsicsVCQInfNljOD+ybGBbK5aV4zFaUrAAtK8pGYTjZ2FjrSZ+QSYJ5euUJlzQkGuY4aB7u5drDLXUqpN091t0WB8RqmMbPHOyNsw/vum5vvMXkb4Ghw6IQbHeC90fqPhRlm1eG+5H5mVkSFseGZwMD6+NfB7gj0OkQ02UdFB+S5bFxCYx7emvjCI8zgSCcoS1fF0kTjPMorTZTTWd+GKdERc/0yjZJn5MNdMoJ8X7oKb3ltmw2YS5cKJ0GWxubjlL66LrcRiJZnHfZ0D2nraK44uYrLtpAb2K+8EGQ==
Received: from MW4PR03CA0093.namprd03.prod.outlook.com (2603:10b6:303:b7::8)
 by SJ0PR12MB5662.namprd12.prod.outlook.com (2603:10b6:a03:429::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 8 Jul
 2026 01:42:04 +0000
Received: from CO1PEPF00012E61.namprd05.prod.outlook.com
 (2603:10b6:303:b7:cafe::8f) by MW4PR03CA0093.outlook.office365.com
 (2603:10b6:303:b7::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Wed, 8
 Jul 2026 01:41:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF00012E61.mail.protection.outlook.com (10.167.249.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 8 Jul 2026 01:41:58 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 18:41:25 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 18:41:25 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 18:41:24 -0700
Date: Tue, 7 Jul 2026 18:41:23 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <ak2qw/dFEixxY/Uj@Asurada-Nvidia>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E61:EE_|SJ0PR12MB5662:EE_
X-MS-Office365-Filtering-Correlation-Id: 106c5f17-3756-4452-1a4d-08dedc9219e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|7416014|82310400026|1800799024|376014|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YUG/oAWbKSPGtGRu10OCo5MXwN4NiiMWbYu/Qm5D6XLPkNiluBbEpk13NPYem6u6+mbxo5y3Z1m8cLhdshA91ganXMSeypZgyJYnGVBme5hyK5iT0XnP5J/4kANow7NKU8mEaHEblNvTuJupD2GE3BPbnpRkMICrau6hs9q3nKGE7Zxc29HsgvAPPYWyuaYKdymqhHECFnt6P27sMu5nzlzPcnKQLKTnXtMbd8ToY0s7q8XIXK3ze7TxK9ZMWQDMXr6yoU/3wTdsgGslgBixT4na9vs9I0Zrc1UmcOWvG5T9iTfkPUB2Vz90ZEDSOG2ifFFYhkWBYD+pWMzXpkge3jNtYQhwiCdHpPmIv0Q1pNxh+sfX23st23C1NYsrVCBcDPPmupwYHdnKxzlQ04yzycVMwvPHiqAyLEmJJOeFt2uuzuT1iwk5cnSn+rtOU76/HAmY5CSk0Ymdyj8MAhxbDG5d2CQm8ILo/yoEGMoGFasUPt5nUGGnMplx5PRmtQfTGVvrP0WFHuycaqRCDObqiZvALvgn56vGChMx8JY4Ljers7G5wRXuqcJbDpie3ogKuwx9dG9LFIxtrazuR6EAB6PYBaOe+plQXD1vcf9PPGPRpzlLcFJ+2zu0JGUH7nJl3OzT2cekUw2iq2cptYPuKyje7pdgg7Fiigb+blrgM3ex0YCiQ53hps/mWkgNG3QyivA+uxcGI12Oq2kNB6hoDA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(7416014)(82310400026)(1800799024)(376014)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7DimH9W+PyByGhb1IOECtDKhvKTpbwNyxK+5tKkTvZfecNxaBhnpKIT7gc/G08J7y/U2zULtm72KXRj7dWChuSsDUrejspQx3JVYJzei3Nt9c7JOHl/Om5KgkW7Vsmbtu3U34dyBZaTHdo867DFfuwdmeIKzF90nzi+fMS1hW9vKwAcLPlIa+ibpfbtpeTyPsM0DmfsUNa2uMF/7cMn3bCdBllK+0kyskg43wSiMy7/3XbcphUDqCZbITsZQb5K1rIeWjUUH9jmIWtroaunBA+IMjYdikL3ZviehF12ygCYManwZWwQyrkwVbJn+RKjVtO+9bhK7tCIol1rQUq4hqo8jiag2hVvmXUc44IZqyGaANDk5m8DrCUxHjFhLIygDmsUqB0sx1kbV8bRAmU7eAMIueto5/XYrKg9vqp77uFUk6OAKMHvWt3+cIX8pMZgA
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 01:41:58.9780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 106c5f17-3756-4452-1a4d-08dedc9219e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E61.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5662

On Mon, Jul 06, 2026 at 01:26:44PM -0300, Jason Gunthorpe wrote:
> @@ -2331,8 +2331,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
>  	 * This has the unpleasant side-effect of invalidating all PASID-tagged
>  	 * ATC entries within the address range.
>  	 */
> -	page_start = tlbi->iova >> inval_grain_shift;
> -	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
> +	page_start = tlbi->start >> inval_grain_shift;
> +	page_end = tlbi->last >> inval_grain_shift;

arm_smmu_domain_inv() in the header passes in start=last=0, but
it's supposed to flush the entire ATC, right?

>  static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
>  				struct iommu_iotlb_gather *gather)
>  {
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	unsigned int tg = smmu_domain->tgsz_lg2;
>  	struct arm_smmu_tlbi tlbi = {
> -		.smmu_domain = to_smmu_domain(domain),
> -		.iova = gather->start,
> -		.size = gather->end - gather->start + 1,
> -		.iopte_granule = gather->pgsize,
> -		.leaf_only = true,
> +		.smmu_domain = smmu_domain,
> +		.start = gather->start,
> +		.last = gather->end,
> +		.leaf_levels_bitmap =
[...]
> +			BIT((ilog2(gather->pgsize) - tg) / (tg - 3)),
>  	};
>  
>  	if (!gather->pgsize)

pgsize=0 is checked after ilog2(0).

Thanks
Nicolin
