Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EA8366806;
	Tue, 27 Jan 2026 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526801; cv=fail; b=uCPIr/QzbEEUEeLV+90fy2fganNrHBBws94sb196m0Fmk84+7jWubw56XY6AfhjcRDDMN9I5FP1uj/JW266aCu+yVx3Wrmj8DHJQRQOACeej6dU+VO7sVb2HNO5a4z4GMH9xwM2ghR5BhRcs3U3JAIAtTGYU5mF4nYcqKtiNXPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526801; c=relaxed/simple;
	bh=zyVUdQZ58uD+HqW1UB6y3qOFzqO+pUV2Y4qvEE50b8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oZPG7CKXv15CW3unl5YWvo9IWTzGCJl1pKSPuElJKu1uMtOqVnNZXp2NRJdUAOZO2OrUbgp11c0UZFPpImhOMMfZ+EpzhfOkYF0vylMxeTJwxEVtFNxOfwHdZQZlB/RcoOKWkoa2n141qENsjeVKPw/aj4g/1s87rcJ1qlmSVcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QUjjXaes; arc=fail smtp.client-ip=52.101.52.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QUjjXaes"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xozyk04RwCuuEL2fyRRhSuWmzQmKvaH6PSi+gUiYVs/b39J+OVjsIuFofoCGfimmNNf7UxjgF+D3pkkgnJS1Yod/z9G1wyPFrZQsKicLrIXHOgpGu8Wc948Sf2c4P8UhFvSmARnwVdeIgNIANFHxgPvkU0R42KSodiBUSaFDixIOE7ayrppuW9U2qSiTVGoYulCGkCALaFDh0phhA4VHmAoDgfI2kBIHesZM+g7XDaI5DxeqYCBeAZkzAd6nT1uZiwkkRhpUM/kmPYF3VEYtDAoN+zYoylcw2F7OETRwnwWBp+Jp6pH56LERRVChj62STTx/v1CnApx++x6BmdDYJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+F/t/G8rvmQ4QkSwwIoFdCO6ZvTfBOKdh7XaSfBTV/0=;
 b=eceOOXyRyEG9xJ0Muev5IJ7lofFX4uAZR9Bh27Dd37sbzlk5PUppNq6J0v7CItWJtLC4PbuRdqgc2Hm+MSof57lCnOS6srWZ55ArHUCTRMPz9BqZo5Jun06wuAYfWT2GVPkA1QhTV3hz054CqNNKoMYlOH5wrxRq/f0aFuThk6U9+K9Q01h00Wru6JX19hEKaZ200RPxkh7jedXFSV4D/mqmFmY4in/K4GHrTZetMNenNMC0ajHIFAwGf60QvPiaq/9t6lCD+qKUJZW1MFlMh1OWM2JENtaIzPn9kk+Juu9nxlQtBkWqfkFXbI+Arc7Q+z+dppSmPQz3Ac9VH0OPFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+F/t/G8rvmQ4QkSwwIoFdCO6ZvTfBOKdh7XaSfBTV/0=;
 b=QUjjXaes/kDqveGP3EcywS/RJZaquJKCLrWSeSIoICejklLttoKxqOq3YRykDXNQEdo+ak9i5ND9mne49jCj7E3e1iLV7wARjjS6Izqgp9Ts7CNpjiB5Tuf1uILmHqakZB84lsiiqbAgJ99caUz00EpDd3MpdRVFqlLqt5WWKj4quxveLS3Z9jwz2m9VNitFeeE7/rzv/d3SQVnpNnb2A7JQ59aZ7x2ILFBxW/9RLK+wwKaymncuGT+VAofRbWtuQHt8ISD3wsutcyR6m2l3mWDnQ6dwjHyDottK3kzlOJDgeZyyYnAL0xE3ieaND9SXCSZbJ858kYcDvrZk5D8VBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6412.namprd12.prod.outlook.com (2603:10b6:208:3af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 15:13:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 15:13:14 +0000
Date: Tue, 27 Jan 2026 11:13:13 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 08/10] iommu/arm-smmu-v3: Introduce
 INV_TYPE_S2_VMID_VSMMU
Message-ID: <20260127151313.GJ1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <58bda77b3965ca6d8871ca242f01bb50d2baf75b.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bda77b3965ca6d8871ca242f01bb50d2baf75b.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: IA1P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6412:EE_
X-MS-Office365-Filtering-Correlation-Id: dd06152b-6f1d-473a-1c8a-08de5db69770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NgPhrO4L9H4xtNvw3KrMp6t9I4M/qR/MEXMfqJdjMKtFFA30dqKWYywX8p4l?=
 =?us-ascii?Q?rjyMqWVzknI8pZLo/Ku5WuOzOu7fq1hc+ZvUJAGFVyINW0or5sD09iEJ8FMu?=
 =?us-ascii?Q?jUiMb3Rof5zoB2slYoeKVd5pcoYa/m4x+wZ00LewZimMrIk2gmdelIysLJwd?=
 =?us-ascii?Q?zn5TnW4o4p4OWqbyCn0RnyN6dEmYvcnS0Y7UhabxTVOr8Vhvm09tV0J9ljTf?=
 =?us-ascii?Q?0YrI0G7nC/2dPcyT3KOEOPxOfKZGap68nV1SUEITbqiHpzYtmYj+4kfGstcS?=
 =?us-ascii?Q?qpoYj99IW4iLRPWKsLUQ+faS+ECOuimKtomkmbXLwBC86hecXZjSnTYPS1Wb?=
 =?us-ascii?Q?Xn1DWJDbeTxD+ylOqHv5NW7ozTmjOwW4Q+pw+ZW6AbKPmRHEPY5cKJ53B+Vb?=
 =?us-ascii?Q?bW7JDENTyHI9jD6mmEmjCR7DfYv6zDvEWPDc1GQjxyHC8I+yMJwAIU7K/0XL?=
 =?us-ascii?Q?unxZUwScE5ABhVHW7pdL9Jp6AG4C+sCtO9H98U2XaLZq40qSEFmeYbPn7nHb?=
 =?us-ascii?Q?OCzKteXTVGcUPvb9vFvdzIVVD+FLduKUoiT0ZbVC7c4s0e9bH9bC+U05Cz3A?=
 =?us-ascii?Q?HGj3GocNzNtHcAqZA95cLKEd1QrqMmFweYjFCd6CfWyy6pyhZs2TB2hMjEuh?=
 =?us-ascii?Q?t15wxt7UsERA1SLxrIJFUVwxhGvXaatsV1qQEUDIOwAgaeL4ETSgwRDZgKYH?=
 =?us-ascii?Q?wmu6+BLStl8diQJJCduhkj3NCvjcLosGOpym/5wM013MD1Z292XBdR2gFiBx?=
 =?us-ascii?Q?+MpUebBhdknPB74mM/Vb1uMx5WW4SMZmtxSlXg4/4GLu4F6hgNjILnRIZPgc?=
 =?us-ascii?Q?9pBdHMLIIUE1/RADeFZAX4q0KHQMHqLgVSwAkBGFtQqTc1UMvjmni9yxbUik?=
 =?us-ascii?Q?Rk4MU7AvWv6ILFqVHcKXcpLinMlfPQtz85XZsI7Jj5Scv8GknuK7wRxa0hWa?=
 =?us-ascii?Q?5VxNXsTvjOtTnZvRMucGLowdkG9E/nbbtjrzP0Vvn+p6gUYQwKJVG/XAjSLo?=
 =?us-ascii?Q?sCIqsZchfAZw8OuHxJxJpBZoZAoAwC26oCnCTzr3+IQ+N3StaCIUmbMFph3e?=
 =?us-ascii?Q?b8KFWbFash45hARPV+vdKns/jAC2Qn+vlgPGsZVmEa1R9l86Hd7ES4qJNohw?=
 =?us-ascii?Q?A3ef8MtBT8yHfceo8UWCcGypdFOalHLJfig6zkwtzdYWny3EppKcMr9HXXh8?=
 =?us-ascii?Q?vvakuB00m1iEkPblSiyj8HA+oVE1YijEC+Itmu/osGS7AmJRWAa7rFLlfrF3?=
 =?us-ascii?Q?oOTrwyhSpl7fm2pftQd1z5Tkhf3zKUYmxAy2Kov96/cG/HcJuNCGHh8qwPgX?=
 =?us-ascii?Q?+HoXyWI67Anx8IhYNyN+VaJw5JgGgTr7gmc4kbzO2GmAz0fuvtsi/llCm8Y4?=
 =?us-ascii?Q?NtkWf+3Q2GMoenM843R/J5MBb7Ub4Kz/6HvjTpCCZgYyqQC5GQNieB5Eigih?=
 =?us-ascii?Q?79gWcZuyyEUD5a2ZSf/w5UQlKgiZwmE86pXYETuQMdZlAm4G6H0PbrL6Df9r?=
 =?us-ascii?Q?rxKTcJkR+yFq20C9sBqwL0NGRVCSN8DLXI1Om4UWjmQUPLCCuhOgcSUcdtzM?=
 =?us-ascii?Q?4372FsrbAzjmTartj1rb6ZUS2xkUW8m7XS6u0VXckFTedddl7j/pMWvl44+l?=
 =?us-ascii?Q?xxx4J4vzKhVlbJhV+uUvx24=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Ekm1sAWMjpR+oXeXGon+3lDoLVB8nCB/Bq52cAJNFfe5mfrp1UPwHWnoDhN?=
 =?us-ascii?Q?swxzxQjM24xDG7cjNEPH75dulDknYikiPKbkhgOPGZgxR/ZBmy9TZcOqZS++?=
 =?us-ascii?Q?5nS/P6OVNHZ6MdtBrC9tGTflRHKjev/H3+d6UTglKsE7j0BFN07r8T9MxU90?=
 =?us-ascii?Q?LzUZnJgqPvFs0E4JhX0++8pq15+00AxouorFrJMht9ymZFYtIZDiUBqY7dZS?=
 =?us-ascii?Q?NRP2oA4IRj8orRR//ZA7TTod6e4wTHYuO87OEHS2QmBNameBBCLZjyapL9n7?=
 =?us-ascii?Q?5VtSOkeOiGJGlCCAgNt/UBs9zUtS7s7rNV0EfscZUArHeu+aR+/lCfdwD5HW?=
 =?us-ascii?Q?hHiaTI7VgH5ops2tYu2Kj/40N7TmVEXmGg+pmjszbFhEatR3wL7L76D6akAD?=
 =?us-ascii?Q?UDf88Zi8o8YqdClO8gyDDCInX1Olp58Lp7EFBle/d5WtGhSyqZ6wHBCTz+Cm?=
 =?us-ascii?Q?ZDUpXDQKOx7u+Qa4et3rpgKiFmXZI5HKK5N78cdbRRJ0F8xu+J4soVcQvX2R?=
 =?us-ascii?Q?30b8AglPTAZ2++oGpcX7aB5v+kfrkak6Nb5YxMYOGeGVc0xkyyuBSTAGCzwE?=
 =?us-ascii?Q?jw3BpNFUjk7udWs06yyRPz46id2Py/KzN5tabXoR2ypU1nYuXCk4nQPI9jhy?=
 =?us-ascii?Q?ncOfCtwiVJkuyDUAafu3+IepmgAS/U19z03vij5UulA+5JShtJuuFIBOznWQ?=
 =?us-ascii?Q?/0sC0lOBCxCLSEnbflHTlmv+hhRwpypmL/yUV9Vh1xe9Oo9L4+zMv91bcw/5?=
 =?us-ascii?Q?z5G/07s639wNybnGBkqISM4D+pX6bFkC8FmgE5UgRVNfAMCNxwo429+QidqV?=
 =?us-ascii?Q?NNMpq6J2+rnxnSFqO1DAqTc+CTVB+CpxSwKc3XHf/aji9dZTCk9vXJ/f39ev?=
 =?us-ascii?Q?pOxSNCZLu2LqAmXtMo7zVVKSFGohx+CoUlZEu/8ndseIHBctDK4A8vErgyYg?=
 =?us-ascii?Q?Ies26ieqcwiOMbPh+E4wNaMo8Mt3E88gQKiQisWMG4LomamZ7K1wttqLYPue?=
 =?us-ascii?Q?/J1WG+KFPx2MxYVh+sNB9vCKj5wET2n7210icNQYkwJWZ1mx/3cSFCDbztKl?=
 =?us-ascii?Q?90Vhre29BY6hfeXFf5rG/N+rCdlfRhMmW9aGUi/Fi+VhXYjUj4NBEepG+orV?=
 =?us-ascii?Q?WgTX2iUYm/Yy6+6AQ8pAM4peJmH7/16XG7h1PVjs2fzzZJ+WvKuCmRK//vxj?=
 =?us-ascii?Q?fZOIS25B0cN4Yll6hZLlbwfU/7dLvlLuVez2x1kMv6CAhMSkkNGBY+Vgz7s5?=
 =?us-ascii?Q?81MIASouotIWBN6D7KELF+rB5DHLkcBmKkXGj+Ts0G2ep2ycpvn6806DvA8R?=
 =?us-ascii?Q?rwp4vLa1kO6xk8bUdzVHykmPCvsznoljXwhkgM6QPWk8ku+pOI1mxYIip8dM?=
 =?us-ascii?Q?SArg9pGQ2oyVwtmg+6SUy0unwaPjrTcTM+cmVwnwB+yW1zc7FBQaXIeVZdwg?=
 =?us-ascii?Q?38lylITG3XcynkfDFDY2FW8PJUb6ew8hoB5D2H+UZtc5MK55e46Cj5tNYHfN?=
 =?us-ascii?Q?skUuqhci4r/TFGDspVCclfJ9Kz9vHGnYpfQCWGgeUiTud4/J9nlBXfMvQYmC?=
 =?us-ascii?Q?idHFvBdqiMfpAhzn21jPXcCwJewEmdM7QwTME15OX/wWb4vSQmCN/932xPyV?=
 =?us-ascii?Q?5XK5V4JX79TXU9DtbzO9vtiFi6NZdI3peccF6dJmcXP7gZ2PwxPGwhJrG6t8?=
 =?us-ascii?Q?YDAHR71ovOKDB3nEhnoucwHnJnAXSHTlMaaErhdE6c9ntMQQLCVJOjDjyICS?=
 =?us-ascii?Q?J1mDy2TzjQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd06152b-6f1d-473a-1c8a-08de5db69770
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 15:13:14.1997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+bzLREnx57vJR8pTdrrpHo7YdZMCyqwE3PQSVzkT44737JHlsAatbpVbU9+GbSM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6412

On Wed, Jan 21, 2026 at 05:24:26PM -0800, Nicolin Chen wrote:
> A VMID held by a vSMMU is required to setup hardware (e.g. tegra241-cmdqv)
> during its initialization. So, it should be allocated in the ->viommu_init
> callback. This makes the VMID lifecycle unique than a VMID allocated for a
> naked S2 attachment.
> 
> Introduce an INV_TYPE_S2_VMID_VSMMU to accommodate this case.
> 
> Note that a second device attaching to a nested domain associated with the
> same vSMMU instance will have an INV_TYPE_S2_VMID_VSMMU and reuse the VMID
> held by the vSMMU. Devices attaching directly to the nesting parent domain
> will have an INV_TYPE_S2_VMID and shouldn't resue the VMID from the vSMMU.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 18 +++++++++++++++---
>  2 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 386ac75879c0..8365660282d5 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -656,6 +656,7 @@ struct arm_smmu_cmdq_batch {
>  enum arm_smmu_inv_type {
>  	INV_TYPE_S1_ASID,
>  	INV_TYPE_S2_VMID,
> +	INV_TYPE_S2_VMID_VSMMU,
>  	INV_TYPE_S2_VMID_S1_CLEAR,
>  	INV_TYPE_ATS,
>  	INV_TYPE_ATS_FULL,

This should be moved earlier and probably some of the hunks merged
with the patch introducing the vsmmu vmid.

Jason
