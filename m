Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE272239E8B;
	Fri, 13 Jun 2025 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749822393; cv=fail; b=Z5eNcw0od9S6zE0YMlNRCUmT+R5l8wmIWOJSEIGccfRLli7s7QDwht/dN8GBHLEXnxbY2IVXUPxq6TqQo3YGU0dRPH1pyP3QVlBm8kdrWPWd1YnjysT/IpkG6afQXrj0H9TCKh0FEBFxeOXEtdgjKU2w4c3WRSbNeOLUx1tCkdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749822393; c=relaxed/simple;
	bh=9DtY5PZXAX9tst7t2WRQvg+zT9X3mSoWXTpGwC+ejz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cKzFEXtMgeeZhWwKL7JlewSttPHzlVgpSeVZy2M7w35iPxGvyArBFGI7mvj+6lm/0f6x4Vn7KLezE9UPiPCfw3IPwY6zqKO42otS8UYZXX8BatvD3sM6DEgb5cZSJFWw/6dXaG5V1jtbHU4TaAXbZ1CIJG1kWJxjmSy10QN3fWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UThgrH9t; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UThgrH9t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZUt45Ta36pN6/AGjV7yxc6vbAl92fqV9FB05YhJvbEyMxeaJK4Eu+FlsRuYMQWW/YlpR0IoMk30eeZoUzi/HGY8QmiQgJ71/x8oBqaR149YtR7IF3nFc7C33ldF+t/aAtGqB+hHStiZyL/1qoo3iW1fluW16NDdxDQ0mus2o6FmU7cWmSkVpi2aKSGkgvvRQ7q/DPszbXWBdoMH+0seHHYyzP/O/mhviIfRle9mGJEKBDCBDFli7VJIVnnT+aZthMLflpqmQrGSgw2LKDR+rMs2gOL+lfKKlmpm1w0dnW1+mrSEBhPqfWQMNKVmcAmLFAsG8UzZUnXjXJJF+Xn4GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaESmomvaaoJnkr82OhQWHlefvNvETdUS1ygJWAxn+U=;
 b=VZLxaQooRyUv7LxTmFxxrI4RE2GgBduMfjE9ch6rG9SsKYdbAZa1++LFVgHjGmhMe8eaLOzBGq5lKJATDRZ23+Acr69YFwOJxNYGR2NQUHCJpvQIwEAvG9EFos2Z0Y10YoYWLBrd3SSNE1XqnWOkasxQR25CT9Ckio8fKcG35kxu9GB5N0LqUO10l5aT4/5aI+xIdvmPTo99FgifVOnPF4AqsOWNNy4/chz21j98AuiOsGsV8Hpc2F4waCF3LcXd95fhkXRnEm0a1sLrVDE958pKWWkx+mgRt9G5888OrTP/yQMj+ASWlOd0GhVIi9jjvz3McJcw/67dh9Ml30JRrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaESmomvaaoJnkr82OhQWHlefvNvETdUS1ygJWAxn+U=;
 b=UThgrH9txEn8mMWSaoHPxT+Cc0mfsLUvJFKba/MSawzigUYjEKbdi2H+2c1OdEMkVKccnSDBs4NMlzU+sDaOR0Z1h8Fd69D8HgEGirBOOVUUW7j6LZpTC2V77QIKXbMEBd4aHsjzkeSo/+02W/i7FDfg3/U/TyS28tubIoEIOqlOaUJYrr1EfBUYijetF0JOWLIWBXY2ddT2tbxruTaZllnwDMSllZ4WVNd+7Y34oxnoQvcuSUCeRUUA5wK8uYDCpGlE4KtggASILQjuxaKQHgGq6FhqnvhF4uvHlWC9op38Vli5GiBiD194ZHn8BVCD0T8OgyHFzwPwsJr/5Kb94w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9221.namprd12.prod.outlook.com (2603:10b6:510:2e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Fri, 13 Jun
 2025 13:46:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:46:26 +0000
Date: Fri, 13 Jun 2025 10:46:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 10/12] iommufd: Move _iommufd_object_alloc out of
 driver.c
Message-ID: <20250613134625.GF1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <2ebd4bcbd404039d4faaf840dc52d7c44f672016.1749488870.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ebd4bcbd404039d4faaf840dc52d7c44f672016.1749488870.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT1P288CA0014.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::27)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9221:EE_
X-MS-Office365-Filtering-Correlation-Id: 8af21141-a3e0-4c17-0ef6-08ddaa80b155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CQdBUGHvPI0F5/gNziPRRfIEBw1H1DrgweyhrC1K9C4Ov7/Xc+AIJS+fFz4T?=
 =?us-ascii?Q?r/7EBUeH4pBCPE+SNx7radnBx324oMu8KZsIK/rF1HaTDC1nTj0JJBUiHACv?=
 =?us-ascii?Q?0xZHQx9wrAE3EDYaWc1aSmKmq4cfGg7NojCmgPuH1dPmQXHGChUu1VIe5jKD?=
 =?us-ascii?Q?4m7/6/+SqQF0Q+SdljnISL8gL5Wsp/CTJL18ZXoxRwhbVSfL9HtCXt++7CRw?=
 =?us-ascii?Q?ITvAdmVdmwL3Od1eSePI1aM5XdS0MDsgn52VIc5OmJGQY1naxLF4Gm4ZGoue?=
 =?us-ascii?Q?0nuEJ/z83ugEBGZFXTm7XRa+ya3tb3VxFpVCXSKh0ZcpE9k1n0adCgZVfMLC?=
 =?us-ascii?Q?fcvO2/fC835tp5s/fTFOFXCI9zBm5qv47U4YMQrhtV4404tSTLlMmbOVhvD1?=
 =?us-ascii?Q?IvtdBuf7slTEQzs5+2MSeQW/daNIp8hE5Q2TLpZcOGkzZR37JidMMhLTaaPl?=
 =?us-ascii?Q?JO41JwAIwcXbBHkRwdnswQDc7JR0lfg5OjDXlvD+EeUkOn3rXlP11CPVASTh?=
 =?us-ascii?Q?tqXRrBb4eohK7YfyA13B+YVEuxE9+Z7ZrZHiQtHGp69ZUWsd47lxjHljhmxA?=
 =?us-ascii?Q?siT3MfhxTqSt+4ZobFl4Bam4IJmWwCDxeeTjJ4I/Xraueu7IQJKKC6hO+Vyt?=
 =?us-ascii?Q?UuEH/KhQwEfEQW2DWPGbcdx2GpyjZfZmpiI8MVbybaGNopFWDvCu7GQ5irMT?=
 =?us-ascii?Q?5dweFDoYprnHLD7C67oXlxNGHhfPC8W+UDB35IWVGaOXXqS+OtLBKZ5MuU1m?=
 =?us-ascii?Q?aXUcblSGjjuXniulEeIotcCS7bQTqXZ42TuYyenj4pp4yZfZTNy3Piqo0r/3?=
 =?us-ascii?Q?ogVhtxIRujHhqg4bf/3peNzittA4AgmP3xmEEcGLNlz+mQoiybeOD2EWfAja?=
 =?us-ascii?Q?8uIZUiyL92OrKU/wlDuXYpKVZ/3NNGzpFm1ZFF4sEzTWtQjyximH9KYuZISP?=
 =?us-ascii?Q?3iuzpko/ezYQI8d9ruCfPmoo0b47RV1nQneuL2JoS2VniGa3DyONsBjIQUgC?=
 =?us-ascii?Q?tnf5pcMNYPwnrDMZpqx8lvQGhtpCuuaQl9RJOKoRvkMVPBMkYyxsCDLzLLBn?=
 =?us-ascii?Q?lL+pVsmoglb2rvOur7hUXN/EjQStyd+MxOoRKc0x2mswBJobkEs9GqNAA/k5?=
 =?us-ascii?Q?zex2h8u37p1DTP3isW+TtULAKyw7RVnXCaiGcnPKfVU87mTjW8ET7EmaXQyv?=
 =?us-ascii?Q?SnhmwDsWGxML/s8ctZmIFfuFfFdUDKk33R7cZjzRsqH9wrokbtSboBUo5/UH?=
 =?us-ascii?Q?1y2pFNyMPV/IQHgFMMS4zoyPaPIkd2geghKtlJSQp3gfRY/zaq5dQhjcIpCG?=
 =?us-ascii?Q?Ln0B/0/VjjIigebz5yKncXt8kz/2bDV2qGcfcuEyZAtht2YiopSy+J0yDPcU?=
 =?us-ascii?Q?ENI+wA7QQ1qiB4qWdKh15VShHyJ0AcjgIKDaIJBMofuv0wPnVuvJCTJLV2Xg?=
 =?us-ascii?Q?6g16wuXEC0c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+AZQK9BR+za8EgIdzQCXqe/VRe1Jm8BQ0fzuPr7/9YGYwGOtThXhpCl+IAVy?=
 =?us-ascii?Q?Jw9cLflw6dELysFE2hB6D7pWPyRBcHOdWF6cJxB8iw4bpogGkBzmZLAwmeZY?=
 =?us-ascii?Q?bmckZJF4LL9ABhD7SAzSIdBg4OhMpQgK2j8lP0FVoeomV6ATbPY9eamV7/xT?=
 =?us-ascii?Q?rcjCr7UgF5C7eb9y15QEDCLX1JSKNWy5cQDTRS70rV3lUKmloxedlevX4blR?=
 =?us-ascii?Q?KNqpBv2BY0g41gqhe5Htcxl86+kc9WvuOQSwHywEAVQ/RfZOIIkxSDOLXJp2?=
 =?us-ascii?Q?2Cl0SYQxwRTA6dRe9NLfedPsWsQxYqIgcu+hm+ppH1l5cIT1k/BewNBcnIVa?=
 =?us-ascii?Q?+AVlPj7HD+WHp35TZVth/mJ7MijsaNpNZdkW8NsKtM5NEFx918d5SZv+8gt7?=
 =?us-ascii?Q?rMwCF4B6eiaw5VHnq1Rv247KTNKHKRYqjJ4egg960DpBoTiNbxeF7y4zB6d5?=
 =?us-ascii?Q?k/pBxfxPYVolOJLCQzteIi36gwQxBK47awymByOEJtzppaTfDwPR0PRjx9T7?=
 =?us-ascii?Q?+ZBOxYxahj3n4rcjfxq8gfWOAE+KC/d1bOrOBs+PXdGbdrQ+VKLgCZeJDG43?=
 =?us-ascii?Q?borxwU7uGvEbuYd7PlQCUgKYwNh9V1f9e8wXiauYcdN8drYYZ8d2iYLzI1LN?=
 =?us-ascii?Q?Ztg2CarTfEIaa5QwXbVkYG0PWVZY/zF0CgmYhpSRSTufgScosX81Cn0aJWqU?=
 =?us-ascii?Q?ldd+oDMIWCUHDdEFPeEqmaUoIP9zTviIaCGHQxdgrLoNel57BNZ9WJj+IUyz?=
 =?us-ascii?Q?ycXavmH2Mvj0FGXJgAJfYdcz28/H5tzCHGj+IpDPpUhSjHweiJCsKHjYU4pn?=
 =?us-ascii?Q?nbuhn2ga+SM1gXwSYCSxlDrVBXHtJjCEEES8YtwnBwcWGmtwbGerCqn7CjQ8?=
 =?us-ascii?Q?JU5Jurq6NchQC5xQOwHwm15lCkBnXweD4LSamBES0a7zIpWM0KacdpqueTES?=
 =?us-ascii?Q?9tdg91Alr5lj6+eMGchOYVSiwoIokxfE2B4XX+zMJQV6Rn9Dysrur6bpt57v?=
 =?us-ascii?Q?5uQydYS/40i9ivpcd89EOJLAnX/qY93ewpHrkylBBIEp6HQU4D3BQfMGei8X?=
 =?us-ascii?Q?PfBGfrnYm2uChjMfAiPg+XadJEU8q9Eu9eQ166RrhslPZFTEV92ftol7dKYS?=
 =?us-ascii?Q?Vb7cd5UADziw5nd0SS3tyVVUBw7yAQ5xDWiOatPgFyNbPVBxHUDCHh7Y1C4x?=
 =?us-ascii?Q?skeFy97ticLYydWr/htOIoagcwrsH0R7rjOy1DBDt5ZepvzQrRM0v+UWD5Sd?=
 =?us-ascii?Q?CDEPAmCCURteb/AU6IuRI5jmGUr1LK9EyGe+CsERqFZXxUQtRLX+ULGtJS2C?=
 =?us-ascii?Q?YH9nNaPFge6Oq5jNcsJuHXOBc0TFrIztpmPwsk9far2eNf/OagnohHd3CSGE?=
 =?us-ascii?Q?eemwZdQ6JBtMxx/5r7dFWTdsqYTC/CAvbp+5KQJfEYqmVq3TdMdsq+ZBTFsH?=
 =?us-ascii?Q?YESfdc/1MIuEjVSpmUkCTlsb/tcpTdSKuWzrtjMUZt2Yr1FjhDH516tb51vL?=
 =?us-ascii?Q?Gh827RY/h5gRbhzHDLZt2Z8mxnanY5MNgSAO7JR7wVAYhpNGTVVvl9u2UOsa?=
 =?us-ascii?Q?nYiS9DfrfN8FJPCLzz6iInHDFHwzgRiTqQ8FiXDc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af21141-a3e0-4c17-0ef6-08ddaa80b155
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:46:26.9158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPk6SyfGNY1B32ntqZMamnWnb6ttyLxTLnYFV+JcdHuEtnSnD3iWSUSB4Gyogpku
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9221

On Mon, Jun 09, 2025 at 10:13:33AM -0700, Nicolin Chen wrote:
> Now, all driver structures will be allocated by the core, i.e. no longer a
> need of driver calling _iommufd_object_alloc. Thus, move it back.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>    3024	    180	      0	   3204	    c84	drivers/iommu/iommufd/driver.o
>    9074	    610	     64	   9748	   2614	drivers/iommu/iommufd/main.o
> After:
>    text	   data	    bss	    dec	    hex	filename
>    2665	    164	      0	   2829	    b0d	drivers/iommu/iommufd/driver.o
>    9410	    618	     64	  10092	   276c	drivers/iommu/iommufd/main.o
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h |  4 +++
>  include/linux/iommufd.h                 | 10 --------
>  drivers/iommu/iommufd/driver.c          | 33 -------------------------
>  drivers/iommu/iommufd/main.c            | 32 ++++++++++++++++++++++++
>  4 files changed, 36 insertions(+), 43 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
