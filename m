Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011012.outbound.protection.outlook.com [52.101.62.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02C3199FAB;
	Wed,  1 Apr 2026 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049426; cv=fail; b=BbIH+PDax0NRp0xq6HJY90uLz3yxAp464fgx2zKwVdJU4Gdl/IXFVqvOqovR3/etwjnotKWtwMZz/w07FgPXcw4vu0RPL4Xx9BHHgIHsiH8FAfqX8Eg474P+x48h5C02VZPtDVS8fjtSxeazk5zStSuaURASAtme07HkzlpnxYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049426; c=relaxed/simple;
	bh=A71EJeHK82gmawfNt+xjU1R1VJA5yr8/UbkEcyR90l0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K07xEhgYsIVrOlJ0qIJWc9V9+a8l3mGC7LDlGfc6QYNcvZRWza0/FhBmflehzDS/hjtzlX4i96adOrCI+OGn7EIkMVGFb9Pn+RzuVbrrODeuCNQN1BpTCXEvB2CEM7P7F2rswEzCZd+hvG/IDuwINCladrP+167/BABJh7aRAnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XTSYW16v; arc=fail smtp.client-ip=52.101.62.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XTSYW16v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3s31/e/Bo9KMOnbr92DQISengR11b2MLt87Y0w0gNIICZj1T6jN7mgvjRdhuyY7MGbdFpMEq4jerA6yym0+pksKfmRt7/oCb0qnfqpii28yLPiFkHOmPMkol06imb7XijNM6adZ9Jah6s0SyFZb+F4Zi2CteJ1WpajFDt5GoegDmLpkIZnNlAOKyetx4cc8wJ28h3+Jt6X9sU9I7NctWvgfZVD64ggggF34V+WkwSZ7hVG/d95NRBTPuelfJ3jU3vJOE+euRbPC6Y3sG/UfsP+ruwIi6ZKRzWVQhpRjQYLsLjnli5dwUngkAt3EeefcsNT7pG8pk876zpicNAO5ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FebBRm0Evf/JKBiOQtqkOOyrLf/OeTKaN8rxVxYCAE=;
 b=xlT84N7FOspGK94Q39vPvDkHcntoalaphOQciR0T1OIJPE5oKnWmctkI25YHr6RWDAR9MnbWPukREtIGBAvv/1HZWVNIDsbTwXypWQSZAYco4t5aS9UdcduGHeKsBAhWn8YVMxI8N8jcsNLrdNSdK0Jd8Nz4+K+Y1ogKk/SCBrBl89Y3l9HLMGYzm7cV0n0Q4UCJ+U+iqSIHJ91+EW1yNUinNzHrLirQpfWoKtFlt8pakWXKjY6cjLpBuSubR5WHtQcQmHB/V3c2VCf77UQ6JQxUVQ01/10T+bvn2d2vBg6RPRTW9Nug0I53aW4DgKFf00LeZiVP9Z8HTwYoMgb0jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FebBRm0Evf/JKBiOQtqkOOyrLf/OeTKaN8rxVxYCAE=;
 b=XTSYW16vM2Dm346ys4h48gcVan+HnTIUNrWAi06/c7ZCTmOMHZUn14u31AAlOk3N36chWQIjNnl0NyyjzCLLSRtbeyi5y5It9rttcRtEIl/XGcQ3RzYipcu7mAa7LRuxfa4mSVXB60P6OFOu6I3MjpJrIhWbOO8nMTD/idOPdfaPlTg5cbc+iIHqx8F1olxvkQ97T1aWmYdGGr99lzYH7d77ci2N+xrABb4PNDBf+dYkRyKHe2BZqf+SYEnJT2dVavE744fp1OYxx22wFk1afQ+Hi0N9zDUy7AY/9954DpNJFhbG7N9J2OIf7cUvx4ZVvadmFw0zxzxU6ZGjwvQzVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6151.namprd12.prod.outlook.com (2603:10b6:208:3c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 13:17:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 13:17:02 +0000
Date: Wed, 1 Apr 2026 10:17:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Wei Wang <wei.w.wang@hotmail.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 4/5] iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS
 match the spec
Message-ID: <20260401131701.GB310919@nvidia.com>
References: <4-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <SI2PR01MB43937CDC4673E9C79398A094DC50A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SI2PR01MB43937CDC4673E9C79398A094DC50A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: MN2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:208:23b::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: bebc2891-82d9-4dbe-ebc3-08de8ff0f648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	2KI6tjGt6qOWAVudp70bi6wYnfjqsHkDJRnsyGhCLOhH0n/h7X20QcoxeGSkbuMTvTC3iHlzd2IEwxQGXYSgoRU0Foo+jmGtOrsqwQrUj9syHYS1WQ6/zoSMDdg6tByV/oqzM05FwMMKqjjpMrwR5/pN5bDCh1Zr0VqKtnxvdBd7R73Iv2Rpqe+aM4OIJX+9iMsYFncmM5O7SwZElRrD8O14FVFcvJKE5IUmPtN0F074mAciZ1fsBGD+oNhUF36jmcimDuV3fKK7xZJy+FHvD/HA2YfKCYucqDQW2a7Vev0kpW64X+6vJ7BGbG+DE//xLO55eFAk+ey3BPgWA1+fyoGVOMiZW19nYhPF8teKeK+TQq2j/AJjMu/50nXLIxwSFPeEzBqWfUCxM7M+3wK96BmH5/Jm/o+o3ACpSSlSS15ESw7XLS0KF/gVVhWiCMBssLbeh50X8jXKSTHO+rFxs2FHHaQw3Ypm9NwiigKGLZ3uRyOF1j2wLWaEWCrJMP6VuHf6e7pcCs4Pq2VPUAwrH2L3lXo3sE0L7M5oFzNNvEcitcdvNv0hzX5d3/sf6yPJ40gAWcD1WwQr2ZgkA9ifAkWG1AWvfUMIztnyTMEFZLwank8jq5KqOIcanTi39H7kfabVhPZUv7xGBFbkCoqsmo/wklwXkZ5+R3ycOfHkrAzmhnJ8m7/5zVZb00St/LpX6z7njOAzWzzEpwt7AO2fldnC/Ts7KO+UVT9q4XLAwN5BwhKHy7VoVs3UMR8KtEeqSFFCvgSrF3nVfSz3yF4U3ewhQNrMopHINABh94aSIcI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ECzPnuWS1Jb8XtHW8k4sRk/Z49afkckCaMB7SYUHr9ZmCbWNCFEY0zO1FWmV?=
 =?us-ascii?Q?pKC8KPi+ryJWU8B9v5VenPE0wx6x0E4n13fIV8e0yHOcftsdgy091YArtj80?=
 =?us-ascii?Q?IE9aGCFJPInmZqQaDv1wCb0tH1KEQ0cJPkvRsYA9gkbyZo/4KRLLOhK3/S/J?=
 =?us-ascii?Q?YkKxVHIvIlEIFOSrKYLLYOBajZuyhEhjBe0YNZNiYzgRbTogYhKVHCQrJw1n?=
 =?us-ascii?Q?v4msJT8EJDA26Gfl+CwZfrxFVwbtLeLkAlXTdYS7DpXVDPWONWo3ZznNu+wi?=
 =?us-ascii?Q?rvcaMVuLIatvbQ3vXS5XlJAYoTuKBf33E4EjVstbpmRkNAUUjPwp3ux4Es3b?=
 =?us-ascii?Q?A1n45rrcZz4LQlhgSfG4EqNJCjefg4s9B39oAHxFCMAgIhNKuqkt8RJGonJk?=
 =?us-ascii?Q?hHdOkFfr8B0jBNVy0RkY7GiLJTSwxs23J/ArSc8XtHeNTd1TBPvUZpLZ4tCb?=
 =?us-ascii?Q?zPZ5hQPrBTKioSl3SwORlWJgOX1b/4xeJwGM7w+eSEsBKKVZlQn2MunKSDJQ?=
 =?us-ascii?Q?pvKAtlbG5vjLs13INIlRHROJJEhhB9vEyWOeTMaiZ4l3kIQk3nGkil6T5UmV?=
 =?us-ascii?Q?PWKWyNVGfgkW7DTZmNVdYs+jcePPTwUzNs+G1ERZhMqpnc4/v+3dChrLeVac?=
 =?us-ascii?Q?9+d9Dv2JbIrTe4GjtyfL3Us7Xd7jsMtqoYp6aj179vGJUFqoh5ETcliqGp7R?=
 =?us-ascii?Q?DBeLlO1ROQJosk216f9CBh+fS/uoM4Giat0flTvA0YsCGyvkmF2KWPl+2tPF?=
 =?us-ascii?Q?WQoXp7gLivl2wZHrbVvTqL/XMq7k0iUH2OpZHBCoXSGOqeTNlD0zDLe0p69e?=
 =?us-ascii?Q?YZvHCK1OZNicBgz0iatlyQxsvcgXUcPwxR6wq71C+fy/he5RLTxcRSTgXiHw?=
 =?us-ascii?Q?1S/5MBXkhAaEq99d7SnLnzMMhf4YWt1Ay5/e4PSkbbXP/BRSU4qZscPhrpbv?=
 =?us-ascii?Q?mV8hvyXSAkloHMBiWgwVIfWSoQbVyl8ObDIXqKnB0U0CwEjVa8zdAos03Go9?=
 =?us-ascii?Q?1KKh7BDeBZrntUY3TQrdTgYI6+vo+HsHp3lKAtgg/EvTNB6soZZTCuSvp9nH?=
 =?us-ascii?Q?AYWtkPmOSHlaxeMLZ+g1wiCpMEgunGRLUKWm1Yb19ITAQxp0t6wps+kfou/e?=
 =?us-ascii?Q?xbyIUd5vTxP+5PplaO1GH8MZZEnifykPbYVBavk7gRbogQSQ/48zcT61VbfJ?=
 =?us-ascii?Q?NxYTUQLQt0LpvENgRU9ZSKgClGhAWxl9sLIZm938DIWFXvFta5q+UYGDSQLF?=
 =?us-ascii?Q?a8lHicP6layXRQcIIXjesTPZUit3LcCfynZ4E2Lp7hSX3NmVNaN+rV4M7/aR?=
 =?us-ascii?Q?EL7H02hAE2sxkCzgWuzwttXuiX1zJP4eiHJPCWWC9gQsngPJt3pSEWjKkCIe?=
 =?us-ascii?Q?KUUi1SKD9i4JT7C0t9mXnyCfVHBfXGDMN0hpsZfm/0QEJmGO1KMAABvo/peb?=
 =?us-ascii?Q?FMpDajzkry9iX4SJ2UwrjHQ0TLgxJ5I4tZekkJy9JBkbARIhHuB+JZHfEqBg?=
 =?us-ascii?Q?z26eiDqaj7ZGZP8j+PXzYz8je0/F9qrEShpQ2fVeEJnvml4xeSBFWKFhjf+6?=
 =?us-ascii?Q?nVQgwnUpGI9c84oAlac7rF11YAVHqWPNW6bQFsokXBCC6MTBQ1Z2T1ZMJ78+?=
 =?us-ascii?Q?pJZYs4BuioFCA8IGhDetwe1kXaD+01AlH4sddHUyWAlE2e3eQ0TTOB88NXJC?=
 =?us-ascii?Q?x/395FaSCpvSyJOX0WsccW+IotXNiZ4uK1RRK5hfQz1bqZJo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bebc2891-82d9-4dbe-ebc3-08de8ff0f648
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 13:17:02.2009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2bERpZzoEYmoFLxhdmcPFnmFJzIl4B8LsoI93N9V8r7JNyjtaU4odRZMfDHLsf+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6151

On Wed, Apr 01, 2026 at 02:42:52PM +0800, Wei Wang wrote:

> > diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> > index c685d3771436a2..c239c5fbe47461 100644
> > --- a/drivers/iommu/amd/amd_iommu_types.h
> > +++ b/drivers/iommu/amd/amd_iommu_types.h
> > @@ -221,7 +221,7 @@
> >   #define PPR_STATUS_MASK			0xf
> >   #define PPR_STATUS_SHIFT		12
> > -#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
> > +#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7ffffffffffff000ULL
> 
> 
> Nit: Using GENMASK_ULL(62, 12) here might be easier to read
>
> Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>

I left it like this because it is the raw value the spec has:

 2.4.3:
 
   The IOMMU invalidates all translation
   information associated with the DomainID for both nested and guest levels when S=1, PDE=1,
   GN=0, and Address[63:12]=7_FFFF_FFFF_FFFFh.

Thanks,
Jason
