Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7782D7D2F;
	Mon, 26 Jan 2026 20:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460289; cv=fail; b=qpFyB5+OCRPd6ygf95f8wAUdu8WbXhrYnSwekV4MwAgZw8Eod5MkbHWwfK6penTr9CiVvAVwGS/qLYWmUQ5907th8akZfppnhNEfq8LKq9npfagCseDUWhZnELaBESSHaKNeUfdAOhXOAbNozu9HFWfLOBvhJHoiR4pfpnmNw2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460289; c=relaxed/simple;
	bh=ZY0hBTdsNS7snwLhMBacqtRsN6tr5zBSF7ZNd7ln6Qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Fb6j7ZfbwtplUIaXySyVgR81p0CqX2mg68s2vSTIvtsMDO5ZHSX2I90PwuWxIzcjZktZYClD4AX0wnhAy+E8nMcJo04yWHrhwzVWiBqkO1sMANvOBA8bpIAdz2V5nV5Rqkz8ZhJnAx8Sg0eGgOoqv+yL9PA9p8JMntXrlAWrlNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WPyOHoHl; arc=fail smtp.client-ip=52.101.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WPyOHoHl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMRuK9hgmkqS+Wp4DQoW5xhCmNMvj5d4bhGwbb45yqSCT/LKUKnwTkD5cFVYvjexT7/ZzV2NNsdojDvhxCRLbj1IAjg2JArYR+KOPNTbvs7KJyNHMGkvKl7VHnxhWF2nS+wfKmCr/MoE58ohJpdrcx1EA2L+PNTXv7z0RNwtlUSSZJILUiNOJL1nMeqSNOyTq61K5Cmz1ZLvM9gA3K9y/Tetvkzcl0HN64AkpWiKHBvk/fktvwUeCtHrTITLZnXaUgcP+XNSkXdnj0TMYwaM6SMzVVF/OdkXeTlBmfmKrh5TCxPyMi04dtVSmyaC3oR1K8iRIijfsvLdt5ekE67bUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYrE4Ts0lNF6kIt+MKIW3LxE1Ei4b3bOtu7ftNGI6vk=;
 b=iUqj9UOrBqN98Shzs0iwRAFaTUsHDOH9cB/Hf3J9IdMeQt5XpkKE1uyEZDWxfR890o2tz4nOJTnKjmJF4IimSEl2PsqqUvjq3qOpU4wTcn1tzLstBJYYJh5K7a2jOxnTDiXRdWQET6p+12WxNs88rr9fimKWoQq9VSAHhK6TJ9DReuCF9sQpOlSDyTMvuC6Q4ZAb7vmHch6/ZQPFzg8hwT3b+9XqFYE2h756J7CzIy9gzILnXNcZpxh8p3syA8A69OnPoBN54xvzhNcwlk4GMrZZykmfk3beJAIdH8DYuTaHoFF8dbmjSBom19W/ArbOS/h38AoWFdniRX8uPgmyUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYrE4Ts0lNF6kIt+MKIW3LxE1Ei4b3bOtu7ftNGI6vk=;
 b=WPyOHoHliu8wqYM9U/TkdgURb0QwUlYsYcvm7M/2VlUjImejwVV6u4oX4to/yLa37eWvv1IvIDM2D7Qn1muoMAEmnFuevowsZpfoBj4IxMrQyDPXKfgFgw0z1+lOq/buQI8wESTP3L/LoOYGwQLFEbnKhoQlNRF0tsJkhzizTlHSloAvYv/S4MiERnGAKw7wzfNC0G6l2qbp4nvPV4EkAV0br4xb9tLWlyV7pytj164I998PfyL8f9WrtwjZGmgRSr1Rv2rn4NicmVQBySENvbPGMLr/Sdio2czch9ZQLwYwDdsaY/Em8uj38C1GrW+rlkupZnyL2frE6YlOF2vWpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6234.namprd12.prod.outlook.com (2603:10b6:208:3e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 20:44:45 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 20:44:44 +0000
Date: Mon, 26 Jan 2026 16:44:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 01/10] iommu/arm-smmu-v3: Store IOTLB cache tags in
 struct arm_smmu_attach_state
Message-ID: <20260126204443.GX1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <40ecdf7e0766004c5d3a4bd086cb22cf08254237.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40ecdf7e0766004c5d3a4bd086cb22cf08254237.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0071.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6234:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ba85bb4-3097-460b-0909-08de5d1bbcd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aK6vEZ8niWLt4OAvuliW3iKnki3HdUiVrIh2nqMhOpZ6HN1+aivSPvvSkP/d?=
 =?us-ascii?Q?//ahNde/AKTZHCbQcreHrzH48EECkWK2gO392szg5sMbUCYI6xN0bX3DDEoe?=
 =?us-ascii?Q?8FdAKNwXKcAj/zz1o38ILmkXbJ/Ykz3h9ecugX+9dwRq09r8gKp4/DItb3xw?=
 =?us-ascii?Q?xl3B/PkNnk9jG5D+fCCQCt075PlMMNiDRMbSF66yQxtFzv8P5GEy8Uz8mUsn?=
 =?us-ascii?Q?eU+v6x0Lcb2Ybr+QwWAlHVEFdU2sijl09lf+7XiwoEwcYdWEfipf9f5ql3nV?=
 =?us-ascii?Q?3eJZrHu2AbcdD+G1EutQwVDS1vufn4HZ8wrcg3MTP1662BgVKicoH6LixGcl?=
 =?us-ascii?Q?mOY48rvNBne6nV3q3S18DTWk8HLcOriiCi7/RkqhbnyQMyaAspdj73KRTm+K?=
 =?us-ascii?Q?33rTwWyHZjUnCuaQnBFJfYCb6hBA06lxp1W+7sJGhK4u0mcK7Rwhtx1j0pXF?=
 =?us-ascii?Q?qY56nHnMRHrRK+8/PtMN95f0M0OhphYLOzQsFtuShiJFCSBCbVWarZ9CGFeh?=
 =?us-ascii?Q?4R6+tab3J4Dt0fAcJucnTiMgZSXUmg7TfWhO1/6Y84W3soXDRXU2TwtpT/B0?=
 =?us-ascii?Q?0jL5nD/Nx8yTdC9+EU/WIVBMkL2moNb2UEnSmZy7R87qpQPQ5OatxWiN/4EX?=
 =?us-ascii?Q?W+fUxxOj2zsJwPtYcl9Z/71FqU3+96XW2hwvvDLjXiF8qEXQZVpx6bvAWMaK?=
 =?us-ascii?Q?DPa5Qn4MjzAGiHD3QUb8+vvYeef3MmSWu8ruPzt7aYwHCA+j4IPix+nJiXeS?=
 =?us-ascii?Q?NzIiN1/68f7lwvCvNRxiLYSE45rS4dTAJZG0AmsQtsuPopTgfB2fVlhsg569?=
 =?us-ascii?Q?lBL3KX1gsSBEtuZ2+Eiv/HwCncTeIlwFk0heKL4I5sRibLCSUr4SJ54wZWWz?=
 =?us-ascii?Q?FGFQHLGbvyFueRregaIocaLkZ7fuWPqKpA3cQQbGpuMf44G5uDIOYHwvrZ6s?=
 =?us-ascii?Q?qXv0WlYodreSc7ES5sHE1okMvMJysY3q0KGfRBZcr86gVCS5crPBPmXWBXGz?=
 =?us-ascii?Q?7fMbmYJJfZvCGu+pIremZZzTpwqFl5ZsC+Iu4UjYflYQ2d7Yr5AEeGiKWjAY?=
 =?us-ascii?Q?hHlUEG9QUqRJbC0eRPr19KOESU1katz/Iuv2Ht525sUwdty6uFCU6sFUFbiW?=
 =?us-ascii?Q?4PHBvaGDbISf0hSlL2pX5XX5EDqaQMZbedVGNCPENjfuHbCTNHfhgc6suef8?=
 =?us-ascii?Q?Jz2k9MVlLs7oju57NViwfTwjpLde/i4R3Tsh6GXwzg0pPxpMB5MdTumtyG+G?=
 =?us-ascii?Q?Y9m49Mo+rQyIC4Hv7wbUIalE+IybpE4/ByIh3vXT5bCvW5uGCnAItFmYsu5l?=
 =?us-ascii?Q?ZO33m/sCnYPeO+McFVItiL8+xNLJO6112TopGACJEOJckqaz24mIs2q1ykka?=
 =?us-ascii?Q?8L2pOq3kcqRch8lWKfvfH4CN5X6ODDZlQMlA7Ub7DmhbHp2fErx1zB6swjY1?=
 =?us-ascii?Q?JTUmNmmtarevG4b5D64AR8RkN+6Rmkxm+v+OMEHe0klvxUYRHcGzTL0SEi9Z?=
 =?us-ascii?Q?nE8mj9+hLAO9UBmentBfJekTZauxRhYP8/9c7m1+Vcy3dWWgb8AlSlX35MND?=
 =?us-ascii?Q?ZJK1Z9nQBpsEXc1hzJw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tPiv0wsU3d05XRlnVxMOVgau4PbsVxy+Uvk88RHe2j9jzqVGzbU/r0pe4IaZ?=
 =?us-ascii?Q?bUIUG9/CF5DPwmlWtHCaVnBTlV2WgwgBzJ1uOweg/tvFN5VOPvjPvoyB4fzM?=
 =?us-ascii?Q?iJz4ZcvMeGH1feYCgbW75LUud3kTTh11STgbKPP0ncgAQt4dx9vCUcBLgR3R?=
 =?us-ascii?Q?ISYMmgF/msVh86gH0GYtiadhEWcC+vGJXoD46Psp2hSvKj6C2OCs/TQoIPvr?=
 =?us-ascii?Q?CKXXvDbhjtU8awslkOReLZfRzborcyUgYFOwWCAmMLUq1myMUV5keU8yLOkV?=
 =?us-ascii?Q?gqnpgv8XSM8QIZU7S/YsDDqtUsDi/28GPoKw85bfqreNHuqyanKn9agbRAFE?=
 =?us-ascii?Q?sDm+eoKWc5cIUb/4oZ80pO2WGEc2PIZOJ06Uhn3/+oZKWBN1emdRMi71jE8p?=
 =?us-ascii?Q?aQo0S9OY3+v64J0QztgBriUhjnbDWL9QvCxx26SG1vZ11x0V1AiMdwPEDbzH?=
 =?us-ascii?Q?6Mg9PxvOoiBJWCkJ+HiRxROBbzSbGpg16N4vwulOxG2Al/0c01gO+eEA7ACU?=
 =?us-ascii?Q?5vbZNc8HO8ud9y/CfAxa9FMmeAWeFOLfOmUg+uh7VCoXVYRBnHyPwwwcXnXc?=
 =?us-ascii?Q?mf31mlGSFGk0LcwC5WiyWJ5Szw0GGxEv8TYqV2sCGWn+Jv/COX3OEkwTXMSx?=
 =?us-ascii?Q?IS9GPwMTjUfAkPP4vxEiJLwATtcmp1flVyP8+E325gzdIiXcIm8N+acr20mp?=
 =?us-ascii?Q?naJqKci4x/ILl7YwbyRMtfzoI/CplE303Hs1LSKFLJRlgzRKmrO8KfcXrBMf?=
 =?us-ascii?Q?EVdaT/JxHBtj2NwKne3v+Uhjn3Kviljtar9URdLs9iTKwR7O5o/U8lsUAmy9?=
 =?us-ascii?Q?qwJSDCpv0nXf+RoHVxHNfHfr+k7WzDwkuh1mS/34CgCpmuC3Hovl6znaoAQ3?=
 =?us-ascii?Q?84ZqdfZApE5wruAE+GsB9e0kzPvEaAMt/3l8BgtRGD9MZak1hA49XwfI2WDp?=
 =?us-ascii?Q?4X6gpAm21GvOHmwiwC/nZf8lew932zj3mLo6q5CZVRR3qNEh56TuHqTabKGB?=
 =?us-ascii?Q?47C29tl8qnGipSrzDL59AD2fJEpQIBiNkxDDXKUtA3bmG9UDDAkMv1Okv8I2?=
 =?us-ascii?Q?6J7YVeJexkzAc/uwgRN0v5zHbUrWarIMt05ahKuWCJ0oYS4KKgSvoNJdnxwy?=
 =?us-ascii?Q?SmAvjsuaLEjOqvRgQqXtqlS/7wryBmRxHFSPpUbUH/x1j5ZP4lZWgOPV6gal?=
 =?us-ascii?Q?gm/0bffObFdWAjxGGiSU+WpXioKiidSiOAAfA/o0I6Z3MQ+PI7ili1a7XQW6?=
 =?us-ascii?Q?BrMW2BymFGohc6AnuH9Q5CYNDDoVgvBy6z4DuHC9meSqQgx+K6kuEvkYXfnK?=
 =?us-ascii?Q?KOYO35wYFTSCpeLl/Av9WYryJESkyx2sfR/eA/XhLvPGU7Lt+n29Up7V3b1T?=
 =?us-ascii?Q?u0TKhEG9eQ2+a0EkyrZ4A1HJw58HwxIwfkOURBepc8ZILsAdcq44kWEExk0Z?=
 =?us-ascii?Q?a+3eLtdPfbFdY3ZgBPzwfCgwH4wWXVHQcaBpTLH56BO8rzGW2z8Ub0wFDc7q?=
 =?us-ascii?Q?48rjRiS+xndWVeIfM4qYe4EgQTglOdjJSP5o5exnY4CuWVrBPYVFMtrs3/06?=
 =?us-ascii?Q?QcjsdwyrW4GIeoBL7W3jx//Ogg8IWIgJZY254b8kFbWObx8YSyxQL5qV2bYD?=
 =?us-ascii?Q?tmCYARRkvW6a0N7aBtPSewL23SaDnMk1+jq1twsYo7+3aoz+AVIM3gQ462Lk?=
 =?us-ascii?Q?M1IUN35w8rtvMOARJszU8rN+qDrqWIGViy8ADc0MaffX5ng1aon3dZg4iiJf?=
 =?us-ascii?Q?NQLmwXNNIQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba85bb4-3097-460b-0909-08de5d1bbcd3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 20:44:44.8694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEZz+O+/hpcwzCngSM9WLVsVSIdk1Ip6FutDBP8LtFWaVlXaIb2LRE7EqDQp0u7h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6234

On Wed, Jan 21, 2026 at 05:24:19PM -0800, Nicolin Chen wrote:
> +int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
> +				  struct arm_smmu_device *smmu,
> +				  struct arm_smmu_inv *tag)
> +{
> +	/* Decide the type of the iotlb cache tag */
> +	switch (smmu_domain->stage) {
> +	case ARM_SMMU_DOMAIN_SVA:
> +	case ARM_SMMU_DOMAIN_S1:
> +		tag->type = INV_TYPE_S1_ASID;
> +		break;
> +	case ARM_SMMU_DOMAIN_S2:
> +		tag->type = INV_TYPE_S2_VMID;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	tag->smmu = smmu;
> +
> +	if (tag->type == INV_TYPE_S1_ASID)
> +		tag->id = smmu_domain->cd.asid;
> +	else
> +		tag->id = smmu_domain->s2_cfg.vmid;

Would be tidier to move these up into the case

Otherwise looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
