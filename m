Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD26830EF7D;
	Fri, 17 Apr 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776427037; cv=fail; b=kuE11UBHEt0qjM5YLsXBTA3PT3hT/lv1wbL3RRhvfUFg1u8w8FGoajupNBGg65OydkWOv5SBPHinVqTuDPKugFmkkWEc0FJ/MBruP+p6j1fSlAo6PajA+PSuJmCnheuJNPZLxwwAPnhRxjBlLeEldKm5KnpQlo6T1JUhXZPle3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776427037; c=relaxed/simple;
	bh=/5ERHWxblCxFpIPMQPQ5fSpqHoF7Ew4rRJGtdrwj8Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yo9uS3/qtFlRr1swf4c/14SiamjGad92CLSY+MngeMYwAQ8Fr/oGNNDfOHqsIz84Wus3Y8xTKXz1qhK5MnMDgPbAM/cD1lgQXcmvY8/dMxinAzW48dxazrMyrAA+M1mJu04+h+MkX1eSXGtgoPYMsD+6Un1mP6fRNJTTyJY2Z48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YzywxMTb; arc=fail smtp.client-ip=52.101.62.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YzywxMTb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DtY5ev8/NU1GIwifmgx3vnJVPJ5sAcNg9Xr9gc45eiJ8q5wl/gRpHCrDMCi0IS67iFqm96emFPw9kkJEDBUw76KEIR9/6fmCX3jKryKd4/ffm0/V/mVqRptQsDqQeo0JKwsS9Jqc9QfPpjejCJNbbx1K8OZF3cGpvGXRvJbb2+RJhvTzJPZarxMhNE3nMfViX4R20+m4aSmWaLq4B8U+Rm3fOIt3z4SgYGcRyE02Jvm1V7Rkhc1jqZZAbJMEa/puRUOSnjkyLBKzkGS+YU+U3Tz1/uSUDv+fCHCRYJ6TKAG0hlE/HYvWvUJD6brKvoE21Bnr1I0cM6HzJR05crnfsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUWs8aOyp+Nox9a2JYO9wSODxswdXIdlbSpuml7VAgE=;
 b=Vup2tsi1N+NRKSW/aq6LBsGSoM0/wFOtuVxsQRP1MXFIviQoOh2o0GPt47IaQqXQuXKd0YIbxnFbytssxdR2RDds4lRczXGpWxtMdHgSgu4hP9HZZMTixunlhKF9miBUXFEWz9VQha+S+FXmdjAEzk5C4V1TONfAeMcYBCIQYPOoIRGzve9K/DtX3fwNz+eV0UcvXiD3liQTxGeAbTfawsmZ8zaxhd7m+JIefjGWrEzS6i17lOkzBGvC69yV011GgrPQXhV2pN8uTFuv9jSp5O0YZZhLMK+BMalLS1MyYaQmb+rnrSHF3y/3uj9oZhENJAlC3QBg/+MxSDK7S9I5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUWs8aOyp+Nox9a2JYO9wSODxswdXIdlbSpuml7VAgE=;
 b=YzywxMTbB6xPksr0ZB+yZksW93fucfxXjF5zmLmFQTt7dhmfeHe7D7J0aZvvfJ6c6O0V5BJLeHeQd6o45NFo1TCAVsWA2MI+bypGdie1KcLiFm6N8+IXNGFlsBiGI62fd98IQnQ+UdbUyg4DE5S9biMHBcRdUaHotpYUo03pODof+ASQzOZLhaIkbbDugZNJXpX99GlE0chNQ1MbjUj6L/qD3obE3Vz16ZGaGf1Z1AXpGHrQr9EaBfr0V5oKuHakCvm9nE0K/Cj4y4sn1bCGrTqgkRx83VaIIclJZ+w/JonQGEVUP67MGTJolEq3mXkZNXy/9cO+W3RlnD4HRrUHIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6308.namprd12.prod.outlook.com (2603:10b6:208:3e4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 11:57:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 11:57:11 +0000
Date: Fri, 17 Apr 2026 08:57:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, joro@8bytes.org, josef@toxicpanda.com,
	kpsingh@kernel.org, patches@lists.linux.dev, robin.murphy@arm.com,
	suravee.suthikulpanit@amd.com, wei.w.wang@hotmail.com,
	will@kernel.org
Subject: Re: [PATCH v1 1/1] iommu/amd: Don't split flush for
 amd_iommu_domain_flush_all()
Message-ID: <20260417115710.GD761338@nvidia.com>
References: <20260414233607.GK2588311@nvidia.com>
 <20260415003046.2275802-1-wnliu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415003046.2275802-1-wnliu@google.com>
X-ClientProxiedBy: YT4PR01CA0035.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 513c13d1-a566-433b-4c1f-08de9c787553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	62b6lE2OxuUqfdfcH+Bev+47wectZQ/s0rLCEfG0iYlz8fl55qVKz8cQls73fjB+J5o3CgEQwR8mADNa/XEHK5Kv+NhXzEPmIVyaQNou6gDD3O901rsYOzzoltFEvKTx3DzmTLqYMhz6dfI62HF3ma93zayk8o5U5UVE4hOaaNexOOW4NgWXe23ExywcGpQzt521YU8MWlWlyw6a36Nz5gXRBYZS4jrGIhlukfLbpYVJKlgHWbGH6JebYm7LTeuebqbsca7UF3NxkvazPCWAB/hG2JRmAq/Gt586+0Tn4XN3ThO46xp1PU1LtoNVWbO7ntEX9eE9AbtB/dMM8i/BwYuN8io8SQE0UHNvndQ88wLcWaQlChDKE2btZIlmoDFs6kBoYiSnwFNJZdDefoe0egmYJjnDFnDwnQy0R9RtBRdGYJLuL/+LpXQGd+wjiW4a41R2JBMyQsKWi7MIKKpLJloTzfi0TCCjjSlmaXugJPmi00gCwXkf+axhR51VIYnKgy/xS0QmQikHTpzXXvukbWD1yOAV0IoactQlUG17Q9kcjfSdVwJCt3X6Ddfqm+vUjWslpARCWBkU9TAHcZKHt7YbOLwmzTIc1UBPvN/wRBspVan1Woh/c97g+s9L2vhDX25SQ2FWq6nm8mpTH2vlNtslyFVomc0GC5WcqS5gb4Q763hjUhx0KXoosB+zSmnvYpUp0SI+7oMdXr+LC0fOIbKaPVSkb+MChwpd7Q+Qw9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FISHd/eBDNsav5mhJ+DbhSB3k86SdJedzmk7XM91BzoxSPsIoFQQFmTlc/zU?=
 =?us-ascii?Q?f6JxQ9FQIsb4PsrDS//gSXz1VBspd3ym5NdCuCmwTJsolEMOvDh8bVCWCbAI?=
 =?us-ascii?Q?D6n9bapMMpAi4aCX2mtg5Ytp0e4jNAMEfN0Y7jdsGAknFtSy2TwiBpLov4cV?=
 =?us-ascii?Q?JJj9aZyj03BruKMcKjopqZvaodN2PJOGVRakSUc5DHFYmqrLU4hXZZoZ3wxM?=
 =?us-ascii?Q?dAiHho7C5k/8Wzi/HgbEQA5f9QQ8KKf4OsvQSUPyzIbQ6p+13MPF75QxsrU7?=
 =?us-ascii?Q?I4HTdxnO3MB1vhvC9T4/IwYieK7j5YcZzeKETYuzurP8va/mKBSrUs81TN21?=
 =?us-ascii?Q?j2RnBkIOJefWjRD9qqQtwHFEKn+pNn7XdZOmSkNeNCb3oRTyFMEKgoyRCmCv?=
 =?us-ascii?Q?l9/TD9PYUrS+ro916r93iEUgO/GxaLeGBIf+rzseiYOAp0Rz4DLKIcCvkSus?=
 =?us-ascii?Q?YI5yF+1XQHxzqi5geZVqroVqyAss7MFB9CAOPqr+/PZVmTgOnhBEser3n7HN?=
 =?us-ascii?Q?4IYyNIBqOBAgsYCVvYwbUP0tFDhwBnEhY0OnjOq/eAo2yn4BSy6h+agNy/iW?=
 =?us-ascii?Q?q7GBeD08LE3za6gzHxlwZRLLBj4DIetNNA90BCl87UPFdr5LLPiMEOVp6Kf1?=
 =?us-ascii?Q?Jz1pL+9TFEAt8J94VZZUGPGAMEnA2GsiP032BtnxlHTYXDgnr396CBEJOOig?=
 =?us-ascii?Q?H5bOXlQgVKEUSYTtPEjz/deVeLRg/Sc+vnWHr18zBmqitC1QNv5z6W6peB+G?=
 =?us-ascii?Q?RRLeLtyuQzU8FiOpnkAnOuKZpOCauAvh1wVYdiWYpC/OugAIcx/Yv8H4fq9c?=
 =?us-ascii?Q?z7F/FnVwLEK/12SLVIjwtMF3A15PTnsVlKdYAWs5JrFFCBFDQfnfnKySsnmp?=
 =?us-ascii?Q?KE0lYWzHux/2FiW0aVsgwyeMmEA9YY8yHdGLv5mG4Z9y2crLzJj655RguufS?=
 =?us-ascii?Q?BpdXLrfK8U2ipbXDIjTfrHKGgobF4P9y2eBZbBoCUZvujMtepqe9oRRngQea?=
 =?us-ascii?Q?Cor7BEJmyyRP0ZlOKvBggBAkzHjTj8I7KZWdxARVLVAoe1qWw2rFA2gC/lD1?=
 =?us-ascii?Q?8xM7g3BtZyvmGd783xZT+Os3h9bfyNTnxAE/gX5TYeF8hsY1dOxjwyBLlmUW?=
 =?us-ascii?Q?58zCF91BZNy115NYbgCn7JFIkRM6V2z/2XGMNNHBNb72XrIr3uuOB3yppyxj?=
 =?us-ascii?Q?MCPIfCDIvszIPrWqAx+HykLx5BhJ9qi8KEMRxRRO1nrgiifq5BNaRH3F9oOc?=
 =?us-ascii?Q?BRElHNz3wrJO/fMt6Sj1aVFJzvcMbyR8BKF8cmFUsS/5dje0o7Qxj/9oUojB?=
 =?us-ascii?Q?uBVDWEhPdwuJFUQ8qCRt3WyzDofyqEj/o59uNB4OVdZxtTaFWSUnig3KUThC?=
 =?us-ascii?Q?cm4CuCF0AntUN5oAxOrMtFcSDHl20ehnuRU+e6N/4ufRZyhE7jZLt3TTUtrY?=
 =?us-ascii?Q?ZcEeOzoJaSBiOAKU3by/PvnTNxm4cXC2W8lbf6vMH5fBVlV7DRhxJ/nikoav?=
 =?us-ascii?Q?zs7t8Fo3gqVFkkEFtCHk+OVGhb8RNcw3r8OREQ2Za43y6DJDcUqxLba+23EQ?=
 =?us-ascii?Q?rFoDG22e2jCT9CwDdnX/OlGcGF9TL7f/3araMVs/jXCSga3MAo+tmWmbcVXC?=
 =?us-ascii?Q?JJs7nJ9ti3RgBXNCA/nO02svxJc+/92aAn8hzWF0f+jTgb9PPCSusjdEFU6T?=
 =?us-ascii?Q?GbYDny+UKuyyMXIIMMOyAYR/KGgUDzIDZ4bMjeTFKx87BMps?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 513c13d1-a566-433b-4c1f-08de9c787553
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 11:57:11.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZcE+/toWSDO2+5e+2QstdzLcjzow9hZvI/N0E20Nh6zktoBfU46h6K/ku+eFXiB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6308

On Wed, Apr 15, 2026 at 12:30:46AM +0000, Weinan Liu wrote:
> We have observed multiple full invalidations occurring during device
> detach when we are done using the vfio-device.
> 
> blocked_domain_attach_device()
>   -> detach_device()
>     -> amd_iommu_domain_flush_all()
>       -> amd_iommu_domain_flush_pages(..., CMD_INV_IOMMU_ALL_PAGES_ADDRESS)
> 
>       	while (size != 0) {
> 
>           -> __domain_flush_pages( flush_size /* power of 2 flush_size */)
>             -> domain_flush_pages_v1()
>               -> build_inv_iommu_pages()
>                 -> build_inv_address()
> 
>          }
> 
> build_inv_address() will trigger a full invalidation  if the chunk
> size > (1 << 51). Consequently, the guest will issue multiple full
> invalidations for a single call to  amd_iommu_domain_flush_all()
> 
> Without this patch, we will see 10 time instead of 1 time full
> invalidations for every amd_iommu_domain_flush_all().
> 
> Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")
> 
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>  drivers/iommu/amd/iommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
