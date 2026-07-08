Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012043.outbound.protection.outlook.com [52.101.53.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB2C883F;
	Wed,  8 Jul 2026 00:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783468971; cv=fail; b=M2+7CroqvzVO+oWmHe0GqKS1qfrFhwjg0PRWo4dmNuV3nt1NInVaQktz4fd6933o0BwISnB5BZPA9sC7a3NnxbTmKiCAlTvGD0hBXERcYTxzSIo0Qb007z8rrH19oNvIsErPFiv8DcRuK+6qZ8dlUjoMPxgWBy7clrLu6Jo6sFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783468971; c=relaxed/simple;
	bh=zki2opvOLmOZu2vTD+zt4wgHrPi45tKoO0h88z+FckY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fF+WMRlWt3LrhJokVbje/MXlpnwMBy2xakhZHQuFe6uIpYCLqUJAP/S7Z6vzNNCBq869MFU+4LOXCOuYyAl156dmVPiBWTjBrRVHZEvg5ZBc8mhceH1qTO6dMK1r3AdLb2Zn+BJJORyqjeNT5ZM21RtNxPY0dXYW8eaxNN95DwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RAUcMhKz; arc=fail smtp.client-ip=52.101.53.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RAUcMhKz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyetgS6AU1KO89drJqfP++7UHxi803oFnvBLBDPscDL97+vNLVtlq9ROyw/gCVOB5WCN4W/xumZGKphKgqddXJE4bxbBFA2GnmtlbsRpReSFFkw0NUFU6hNUVZIZxGQjoXxaiYfWTaX2GAFtOEDEDriqIVUWJh1EqvntIJBKzidCMrj9waW3Hm4zqCmSzhVEsfoBEOw1rFqubEXMEHZjiJS5Fph/Y5UqPwek4bHEnvOOIvQX8ErnwEwP67r2W8dhhRi1RnQV0c2LBA+AuHg2RxLGeVRqcCxbOruHLGyyGGY30J9YYui5Cp6AE1EK9VqlaJ7dXOMNa9UCBaFzGnSa2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPAh4g5xfm+pZabA95MAeuWbv5K3dfSwnaWDbSVhEJk=;
 b=Fi/Sm3iCOG1+IZn386dE/V7chbEMxejPO9OH6q1MejVQy9VjA3cbMHdz4RopLDAKoc0i+Dj6BLa9r0oEQvDv9YbQ0oYVtxcbuF3e0IcRWuWsQqFX5VYaPWQp8KsERGnSPUrzDmn+kF4mqHfIpSMLq1ioAX/CUJX8x2obnBkmp8Ii+tiBBiM5LElqjS7LkcDFTLnwpcD5jMARgTI76MepYiXA+NE8J2tVmzNerctmTiaplOY4UdnWqc1Nz9e+N39BxAlSugXD5c3PorUfyj4sjLR+a/FPYSwJZkJc65J2ZuH4KG95A+FwuAaSiqi5ms3y1SOF3p222utcAO4b1RI+0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPAh4g5xfm+pZabA95MAeuWbv5K3dfSwnaWDbSVhEJk=;
 b=RAUcMhKzRtl+OwEMiuvRdpp8YsoENy1IBanoP4MBW0PAnZ7iUGlKSatry9irLqJAH57X/V4UM70AmDPPG9pWWACHs+0uiCchWTSF0YSqXVtDxmH7KY974KNpZKdnJwB87A7IdCO54QalE/CnZlfirz/37MoVj2G/Tq1OwInYeBYOhraLINcyoP2gbOYhEJJaZPXKZWbhKncimD/rB7s4CNttOxg+GZKC9/t8QNB5MWQpVQQBCFLrPs3JjUM8w37mG8P5yfXWiSxf59a9xQT9H8hlXtb7/H3KNmkABA6FboKzLzipK2fYfoNJ5KuPaqqeTDvJaAcwOHWfxVt8gUmhUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB6607.namprd12.prod.outlook.com (2603:10b6:8:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Wed, 8 Jul 2026
 00:02:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 00:02:40 +0000
Date: Tue, 7 Jul 2026 21:02:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support the DS expansion of
 RIL's SCALE
Message-ID: <20260708000239.GN220801@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <8-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <ak2J2gLgXD7WJbfv@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak2J2gLgXD7WJbfv@Asurada-Nvidia>
X-ClientProxiedBy: BN9PR03CA0945.namprd03.prod.outlook.com
 (2603:10b6:408:108::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB6607:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d787dbc-6476-4eaa-46dd-08dedc843a14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|3023799007|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+FwTiljE5ub3cwQKT01A5EMw2vfQEJQRUef7bAncIc3S0J46mQU/CsLjNzZkh9NUJ2C3bGlTLAciwxqM1BhLnnmPCK1oX9tyNfE3cj1WopyupLZ3LSsYCRktn+sk+vshJYqT+zAlIgo7/HkLkwqU4LNwc9qfwfM578JGuicXruC5zGqSjgSLFsPFDf2HG0xxFHlg3y9Cfofhh8ujzWYqDca9nNDIkdYhpK1HY8AsZMidDci/LEdIZgjgIrsSy1a+/whmL4XZWrv8f6fE/jdiggoxnjufSZlQsRUigSnWyZ6VkB316nxc+YJXkkXFH/Tpb0N4LRykYtIJaJL5LkZ2O5Qi+dkoda5Y0lD2DW8iYX3WWuhtlS8tmvKA62NgKqHdF1fSQplkd1uNuNCWwhl3ggrj72gpLPVZLSJJrJ7A/55ZcghUEstw/Ab+V/wEJMHgQK93ACX6RjgavMT32irQLQdYIq8dg92vJZfKRF8HPiNrklh8vjW3sHgxALGXdmizJYEQjU3kgcHiGt6vw2wVGqMVf86lPEZWy1f06aKxMgDNP0hALPYHMrQHtWOLAMyes4WiD2RtUpHK8sZihJU2NSBxI6lw4QlXl1f2kyvim/xz1KDttqeiutikfDq9d4Y6VRK5PS31LPUZUMjgDGhCkiaoq4G5PAXGfEMH5VoU/+Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(3023799007)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qi3SwctwuHvsKqSiq6mK2vmWP0YAuL0Km8FDB6+x/GXJtTc16Ekdeiqlzb0f?=
 =?us-ascii?Q?/C8kjz28tlFGQ5J1ZY921SJPz+reyjTHPCb1dvpa+vnwtXEseiXX5EpTd8oo?=
 =?us-ascii?Q?kGVXABgNN+0qy0rtggr+yBE3AKVQ00Hcj1/sxDVW0JzKDApYnMDb+OF//MzY?=
 =?us-ascii?Q?efEtUA0yIicIwvJjEzjdze6IgMpEalwE+fSPWozebJvPabobhNlcxFz4h1mj?=
 =?us-ascii?Q?PnwNhDXFIwh6zP0hg+6QnvJtcIIOZdsyHO6Wnn7hBp+CDkbkcjQfT2/H+54G?=
 =?us-ascii?Q?XfDf9ILzS99k+MMS8YOZjW2rVVXFwL6K3bJfqxx05J4lOzY14Z+ef8Bz3K8Z?=
 =?us-ascii?Q?h2O32+KocIrBEZQWMHMsp633iXeHaeGPGVAMAJy9iP1oPtKQaX5bIMN+RCtD?=
 =?us-ascii?Q?307q523xFOgiXHw8nTVDaQhPY/OTI44H7brucJjI43DIP+mx599cXxsC6GRH?=
 =?us-ascii?Q?w2bk0ELcT1VdLGobJIWBIc+Qkea89wV5+osLRIeM3/XxJLu6zU+bgAOqRYeI?=
 =?us-ascii?Q?WVCq/UKdYoG6icLXyAq6po+/dROWeqHfZ/sKSS/bFDjLyhyBZghbRQmNvSfx?=
 =?us-ascii?Q?mnSNW1GDj9UI0tASDCQ6+Guswa6eFexmdtUWqTa3EDz9of1pewuluHwnkN0Q?=
 =?us-ascii?Q?XtxrOd672FyHdOx8NKUosOIU+UkKiNvfCluyV8r5y5VTrJCj00T0lKCqx1ef?=
 =?us-ascii?Q?goQ5P0xLGQ39Dc7Gz3AROQzBesp5Kcdi88b/z3RcEfWhT81VC2zQLK3lyqzI?=
 =?us-ascii?Q?PO5aD7reGxrNaQZ9h5PhZ3yaRcbo099Fke7eaDOvmEWxx2LH+nO+GwFkqOF9?=
 =?us-ascii?Q?q15qLPqJXoyYGwxhH3YtxSY0Fh8RgKOmC1TEQw0IWxoEAtFHXFqNaHvNqQLx?=
 =?us-ascii?Q?GGQmo730dPvqr3sy0HPKnKOU0jx5oYB9dyZKJoqLd3mbCltWBGr3XpsAkWkn?=
 =?us-ascii?Q?Jj8fO1npUhg5KJ/gMgdEhidPikH1C3e4AHaJHogHMHCgx9+HCnnm/CldPzZw?=
 =?us-ascii?Q?haU69xXgIb8S/DzgqMMqK4r/fAG18gcJumDIecklIcgtk1fcnJVJpJA0YUhv?=
 =?us-ascii?Q?rW4JZakyMGOcjQsX10yNWlcZ0yezosEh8xKOJfdFUzjI5JLv9Giw+WEiGof+?=
 =?us-ascii?Q?1GXTsqHrAj/LVYWHNU5N267mBrMzZRvxVN2i35UgmdlgbV0L5mR1AgbwNN9P?=
 =?us-ascii?Q?HFORez5mo1j6lKqQBMz+HpHPcABxYmnckp0F3ojfMvGeSGFPHIxIy2JrDca8?=
 =?us-ascii?Q?83L2xMZ4fkWw6W316OSZUe5lTJ4hNYZN1R0RkDIbxcBR6EZYAZ8UKQTAifS1?=
 =?us-ascii?Q?xjKYeNp7Phw+6spKBtq7O9PmvVg08dKl++f7KfJh1swNuvpAyabnZgw8Mskj?=
 =?us-ascii?Q?JDpv/cxLMOr2cYaNJbfI86JiamidFXjrMZ/UpwKZsoPKIIGYJGQ7dYHNBaDt?=
 =?us-ascii?Q?VpV4mQXhrkE5ClWkNi2icT4MgNfFAplWKae4nJDYcIiZHtEpaYCOxPo0XPwK?=
 =?us-ascii?Q?9SX+if7w3+LDh+cvJh6SSQ/9EUGpVynARDpxaCvWKnupOogqH1OuXF/eZIlc?=
 =?us-ascii?Q?PciTVPOr+tZElEyrlfjzeJOYZK/MTuCcCOZjuUZlaHQzVxe5niGlcB1Fuw1e?=
 =?us-ascii?Q?ou50Cak/kytUn6UBwU1hAkBctfuHPKvA0jgUqBS85vpKvS0+9ahtOZt2w/Za?=
 =?us-ascii?Q?6MB/MYpnnJLCnAf+ZHDI9w1bU7fddR4nIw1ZQ12GoTjYUYz2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d787dbc-6476-4eaa-46dd-08dedc843a14
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 00:02:40.2559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IiqMIBr+ifoef+V4onABYGaU1D7OfkCHGFB/XNzcc12gmejHZVEfgZEzEcccQfdC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6607

On Tue, Jul 07, 2026 at 04:20:58PM -0700, Nicolin Chen wrote:
> On Mon, Jul 06, 2026 at 01:26:45PM -0300, Jason Gunthorpe wrote:
> > If DS is supported then SCALE can go up to 39. Detect the IDR and compute
> > a scale max that is compatible for the entire invs list.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> > @@ -5235,6 +5242,9 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
> >  	/* Maximum number of outstanding stalls */
> >  	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
> >  
> > +	if (reg & IDR5_DS)
> > +		smmu->features |= ARM_SMMU_FEAT_DS;
> > +
> 
> Just a note here:
> 
> This somehow conflicts with my iommufd_invalidation_loop series
> where we sanitize user space commands, because the driver would
> support IDR5.DS. So, one of the series would need a rebase.

Oh that's an interesting one. So if you add strict validation it will
technically break DS, no VMM can set DS to the vIOMMU as then it would
face invalid SCALE which the kernel will now block.

Maybe these hunks need to be included in your series, I do expect it
to go first, and we should try to validate fully.

Jason
