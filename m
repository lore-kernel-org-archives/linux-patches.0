Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2B31DF994;
	Tue, 23 Sep 2025 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758636618; cv=fail; b=PSTQ6vzRhrWVs/N5bnDR+J9r8SepbvaFrzvZfbU9aOXfWkuSeIzIJNq6Lzr+Jx914w9IBb6EZHQe9wcsmPIkc2rnBH/AbhHlQ+fvfQzhdn6Az8HCNghPvtTommokY30+/GLNvg480MJVSfzGjGvuUE/zYtG8eKYE4TkQEsiqECw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758636618; c=relaxed/simple;
	bh=wjd/3LFqzH4dHnyXlVqO0o3XkHM2Lzc0U2pSiVaONDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fZ7esNbE2mBVcrLKvlUYmR88rRjsCtdD8fQZnDVWtmMSNSeESZ+b3G/IVw2ATSnMMWruC1a5QYNjOSiSHk0/xroYq+mbUih5qFVsCs1NFN0LDqEu/GDkmxt9WtAiZExVkyP/jTEfq+7aLwloNGRq4NQ2oP9V17AckssKAiDaNDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=doN/3bLE; arc=fail smtp.client-ip=40.93.194.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="doN/3bLE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LgTnmObU2VzzLAhQ1lpINtsM+7uT4VJHVFG+17vYxkoIBd1kZUW+y+MxA7WVXzQ/SdhqloSLbYsSpudVd2++5ePV7oeAXkjfZbQ/MdTSRfVxl+Z/g7pMvDl6YOTIxDqzDCGQsb5yvtyIwW+/+5/2HRWne0qE4o/hkBirHnzceYBBEa8gfYZ+Y5wHTZyCcaunXVm/8TZ185I9vg7ryeGJpUoxWpxkqvWhdxL0wpUiQqSt0JghI2W2mORb4qeV5xjGxbsWSjpKAtUmPLoGG2tJsJEYhJ2VsU3kd88X6otOMUa5IePFQsCB8d5Xk9bdowbyOa1RkcwWXwC8zeNKXE9V5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJ88hGJqMsTCjGZCCfZIlz6oDNM6d8AdjmE/F8u0T3Y=;
 b=D8lBLuCzZBKZKxo+o1dkD7JEjNZgeZinEd8jy/6GqgK6D4DGbG1G4pYOXd5h1U5OZLkG0VMtH2S0LJeApAZRvzn/15PTnmj9o+ZcytmhjYE9bzWEbGA8qkOeBktw7a386zBvid+RWVUktU9Wh7EIu6btBjAQzON5GcFVqHyVlktR6M3EMvkv747NgcjpIis5AluavaoJrgeYq7utVUBZYSgXifWihWP+lMpo7FRURWvSlR1M9V4xIHYNLmdKhgEmh6kn0CXsfuDS7d7VV4oEHSEB93kn2iLTh6229TAJwjqhnubRW4oObVyxJZsmk89bSZ90n8qVrLsZ819eZdwjwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJ88hGJqMsTCjGZCCfZIlz6oDNM6d8AdjmE/F8u0T3Y=;
 b=doN/3bLEwAuaCxhaqLBXwH36IIVB83D4uEwFR3yA6SvShd6H7s3SRXMRDs5k3rdiS84kQ8WjlzLCqVS6crurGX9TFTiwOloALQdJ/mNoiUJ0QNHFTxgBX/3WbI0WPNCfcW90EAS3OH2c7bXO3qro8enkjT8tY7PiagrA47+wtT9PUXIueOkuf7myCfW5RRJoPnkKarbiAQAcxLMkkwtXi617GLXcgSMblcrJEcwaRuOoxz2gP2/35A8A9URTJOJcsTF131FTHRbn9wcfxAWOnuMKMFjGoJXFU+TLas7K3gQdGp7t2F4pShZkuI5+yrLmp9NBMiMAkEUZ/29QPPomPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 14:10:12 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 14:10:12 +0000
Date: Tue, 23 Sep 2025 11:10:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes
 to the page table
Message-ID: <20250923141010.GN1391379@nvidia.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <79da2a28-3c05-4afa-90d8-dfc664f101b1@linux.intel.com>
 <20250922144216.GA1391379@nvidia.com>
 <5f7f2727-f1ba-413e-89de-958256b0002d@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f7f2727-f1ba-413e-89de-958256b0002d@linux.intel.com>
X-ClientProxiedBy: SA9PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:806:28::24) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM6PR12MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: e0274527-7d0b-4d7d-90b0-08ddfaaae979
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LpX5/Za1f5Qa21pPn0fo+aJsTK1Eqt6TboB9MWWqexawhT4670G1UwkSJXpr?=
 =?us-ascii?Q?nN+1clnMebhN2Dj1UUiZQafpYz4RDuL0WyiOsiUUMBpu5Vn8swc6yvGQlAvv?=
 =?us-ascii?Q?xUmgfxIJIGhTujlP9/yvDgcf5ohqMWbKR++LFZel+7taYl3CYNdQRH1PBY4y?=
 =?us-ascii?Q?zoQhLNOnWiDYaYt2K8j2NUNdvtpwQ4auIy/e6HZHjXi1CGGiIQ8tr6Pt9uA7?=
 =?us-ascii?Q?6JxfrQpS1wY3BOF6x6EfAN2+JSkKGa107J2DkVprCHAaL3Mk79dJWt6X64UO?=
 =?us-ascii?Q?ulWN2uoL1+bjnhRZqIiv4+7d/g+iXfjrMLEYHk7qWU9zoqEsnyerdTM6yeGG?=
 =?us-ascii?Q?G3l/7xuAogSYSvJ/wBZn/KnBKBwxS6ZRXvjKSXHb8drDAxoUI0Gli3CKIuaT?=
 =?us-ascii?Q?P+utVrIoxcTq/qqeBpXTgbby1spBTzZLO/fW86tccundNz6O2WkJ7WL8Z3/e?=
 =?us-ascii?Q?2m/Wq7zldPL0nG2O5YELogXCxxUD5Tw9/zyMPzFNYT2hNdRZ4fjS802/xxs8?=
 =?us-ascii?Q?/9prq88XMXI1Qm+I5ftbvJUhdAIkyJ9LRQ9BxMQoASZcyy+kUoUsTcDiNe2s?=
 =?us-ascii?Q?1tP3plbABbw4b6BE9FKwscCkDTIbttJkN4yrhjcNI6w3fWCL+PIrXlLRdncX?=
 =?us-ascii?Q?ajFMMY5nsnq205ojk86Ae3Jh03oZT8D8QVriIkCqiZT22yfO5EEEI5MdN6z9?=
 =?us-ascii?Q?QV5TKyev201xbAmacrMK6SsyHcvp8+N21rd++R88IdCupuEJds+q8MwQnCR6?=
 =?us-ascii?Q?iN1VZUbNGQRBa/ror3zu0posov0ZRhKRa0+cNA8J24J5adwhVdOTo4A37TEF?=
 =?us-ascii?Q?VN8HMCoyQ5ZFYf3GAQHB2QZPdPueeeOZwnjGLukPZkCCmdhlWQagEeaxYH6q?=
 =?us-ascii?Q?6DMKMaqWuDAg/AuSnUm3RxZMT0jO/SAQrEG3xM4iOdFwIseijVFb4JgLcNeg?=
 =?us-ascii?Q?/IkozVqCUdHRkWcX0zTKNWN0SGlyPsb3ZKDTJFJBYXRCJPZnLhlPeFZfHmLN?=
 =?us-ascii?Q?fbXQZhQNQOkBu8xOPQBtvKz8V1peI2RvmLKDsd9pQ3KQVaIbG5BDW2zYJboS?=
 =?us-ascii?Q?bi0MKoqNF626oUrsR9pmE2LivsDmpWxG3AM1qkhJURPkNmFrdiX9cfaONXbY?=
 =?us-ascii?Q?T4BYgGF+eguWQ5myXo3ctVaizkrQrQPXZVOz1Px6QZxzoKoBGeS+3vLIP4q9?=
 =?us-ascii?Q?Y3SmBIvojJJTfQFIf20JO3z1TXyICHPm+f8Fl/JRxLUDE14bcsdc/FhserNv?=
 =?us-ascii?Q?2ZnuCEVG/VGUax4h3Hv03N4A6NeFDka1E4XpyF+Ojq1aM+keKySkvmIXCGvb?=
 =?us-ascii?Q?v4CLBKCYDs/Cgb9Wn+HtGGW6PFHUWlIwkj8oZWSCKT+W1ckECTsDYvqN//jB?=
 =?us-ascii?Q?Ax/OhrjzagpTEJ8CYwBVwtVvX4cSDmD2pJW0S3tbkXjwDTiFSHwobWTx2abu?=
 =?us-ascii?Q?/ACIyD+gbNg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fIGFguPxPBIFDbTz1trODhj0iaBwltHQnOIINL4f9g+fMyQGZk7/yi4yk6Ko?=
 =?us-ascii?Q?sAMKTdmLVKxoUJwDrxd1kB4F4D2as8zlAvmXhDGGqMqLUbvguzjyK/hbDc3+?=
 =?us-ascii?Q?FwM1ppUfBg73Q/D8yvEK2SYp8n32luxkZ62kMfKnr0fyhM2DIuVcqB1mM55U?=
 =?us-ascii?Q?l9rUHOd+qR5U5CezNcsAMdJYWEzL7ML3sJm+5Nei3npi2ogmmeTYLblDDBoG?=
 =?us-ascii?Q?dpnkLz/hV6FI9s+/AZgmL3i3UI4h5wvuRnQU636AiWrrqXwuw5bB/OBcurP1?=
 =?us-ascii?Q?SzZZZhIwaHY/zeTl95mKb7TnN2Ed7MUehiurm8U+1VDohpMjiXTcIRNy3uHe?=
 =?us-ascii?Q?MO1Zc6SxarWM6PBkUUgEKVFv3ah2TxgaIaD4h5Xk8v1Pj+OhDWpVF7Afp5ra?=
 =?us-ascii?Q?FBq8P2dVDhNck8idn9n3Yp7pDVkVyz2uvhYQ3X1lFg+cJh9H4eXwhcNGJeaC?=
 =?us-ascii?Q?CBqdLw39nnL/3XWEMqjQGBLDJEC1J2xd4OKb29QJ+K6FjWW49XhXNxgRPMXT?=
 =?us-ascii?Q?kbsNx8ZtJO6vSNg0q9eaV6JRrVwZ/XfU2TUXHr4QBOscDbzHk0jJtU4hyIAi?=
 =?us-ascii?Q?RC3X7ibGsEcsAm18un/W3db3ltbinTI4q8VYpMCUpcTzn5HrjWG3FhHc+hTF?=
 =?us-ascii?Q?PkbI/qgbWE8Yiud0ARg9tpx49g14X1o/nNOmh+RRcoKNRFLUaPWghv0x/zuU?=
 =?us-ascii?Q?RLWp7eXBRzZxUjPo+d9APAw9Y0dPNAEpGntb8WfJzvcMSCvwFu4kDjXal0kj?=
 =?us-ascii?Q?GW/ULBFCpxjScMKDaS55Pzy+62v9vN73+2o0FSuufAFSqNllyOmqUopvC6Sa?=
 =?us-ascii?Q?2OmSEhaGzwBZbYCwWC9MZh/r48Iozw6QAxl4zkO88G6Dz3Op4KjREYur7EwW?=
 =?us-ascii?Q?0+MQDRFJdjy0iK2Z1w+9e6U41CqcCRg+fNPpUWGqxOpx8RoxHbnYbnrbb8wK?=
 =?us-ascii?Q?knZarwFxZB6OVnvQFlHwjBQPe+EKHuZOJ+ZFwtfUh+zqqfuNGLQPnS8sIMIP?=
 =?us-ascii?Q?lhKVNqdLdiXkOrhB3eAEX6kiCYfeRyPyC4gjVBq5zO0JKD1KwfiFQacDNez+?=
 =?us-ascii?Q?CULhj2K+7HW2acQnZ+8/TfhmlJ8Zv10J6/SQKB062BLFEQflWFOT7FX/ysJ1?=
 =?us-ascii?Q?/eFJzXFo0R8f8wIZ5bMWjPzDh+KsjzSX9MSP9NMlRfbxPeQCjtrR59VspdB0?=
 =?us-ascii?Q?ODCJGNRF+sM8FluEXCMzjugW52xdOJB+44Og3NDfnIkrBga/Suzfg59Ep1su?=
 =?us-ascii?Q?iJnpcy5RTSqYBR3AlH0JL7c25QAYpSqmpKyfM7uNBtU7EK1Z9HrLo1DjxB4d?=
 =?us-ascii?Q?us3/yvhn+kAAa4bmmbix2WyYfiA8RRJkWvfclrYc+086+154FfxEXkMEdxXG?=
 =?us-ascii?Q?9PVUxzSDjnkk6+LfFsNaQhIjYJiH91yy8Rp5iqv0RRk5jHcTQkudHJd5WDLp?=
 =?us-ascii?Q?C4BdaL3bcRvYBedjPvvmYqWw+fQkc9vqXd2G3drMu5NNPzXupO2mPu4VFME0?=
 =?us-ascii?Q?J0BQrH03c2opqIK3dP2QK6bNFW/Gp5qlA7BC2XIHB3yuLiFvnDDquDlJs/vM?=
 =?us-ascii?Q?THiufvnKZfuanzUp7OPEr1Z/yi0wblcAMYfpsth/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0274527-7d0b-4d7d-90b0-08ddfaaae979
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 14:10:12.6506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlmtYL7T/whPmr+5AgjGuTcnxHxFMOTXkU2KMZq2Vzi/ea1bWToB5RKVQK27grGK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385

On Tue, Sep 23, 2025 at 10:17:49AM +0800, Baolu Lu wrote:
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index dff2d895b8ab..563ded2eb3b3 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -3370,7 +3370,7 @@ intel_iommu_domain_alloc_second_stage(struct device
> *dev,
>         if (((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) &&
>              !nested_supported(iommu)) ||
>             ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
> -            !ssads_supported(iommu)))
> +            (!ssads_supported(iommu) || !ecap_smpwc(iommu->ecap))))
>                 return ERR_PTR(-EOPNOTSUPP);

Also in the compatible check function!

It is an existing issue, please send a formal patch?

Jason
