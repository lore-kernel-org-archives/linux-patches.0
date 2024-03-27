Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F244E14901E;
	Wed, 27 Mar 2024 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711549688; cv=fail; b=gVNmOqnMZRbyUyGQBwVubsBXVXJ9Hzo9vmJCKYi3pZTFZ6uSPaUjYP6BR8cCBlTV2EwG2sS3jS//xJ0Vc5R6kW9ri++lwUek7/+ISRtK3cNM/JqcRoME6ta4lapXltiBvt43HOCPnbNpdfcWgp+RnfhtSHnOzTYFS79EmoPxZRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711549688; c=relaxed/simple;
	bh=LUZIt6YgCu3jRpdhAGNhr4D0ojbzXPpIvmbZttyJc4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N29HRiHuaG34jWjfg9DVhCaImQ1WckW5H6zMZmQCZwWHhSw892sdIKuCgDRlNSjPztoQPrVTZTOdcYUs2cXaSozyEixBnOyfho3VFIJ4jvcANpo2YZpdG20p5MgDmNARDR6PrB7UjlV/AIpSaAvXfISaTKNNFlotLoA7IYH7EOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ppffGWeG; arc=fail smtp.client-ip=40.107.101.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ppffGWeG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mriz/BIFAzQ8MLFWqEVL3gC3YCxw8Mv1AWjj//gTt2msLENXKWvQJR74M8p/Jzay2uYGaOvFw6Est681KzQs3zDGfmohdmdHgAPGrvY4bL1ULzX+KkBHAh9RGQSkvuN8KKthQXRwjA8MgKY2UXSUoysB1uoyj0oe8ZwNVZ/FKjszsxKJqkI/mTkFKRsmPbUGbqWpUqLE0PpdV3aBl7nbSylSEfh6Zz2GC8Rr30ijhsrPREHdLS+P9DOY5ETbZ1zHMIYE1rztcNdlkb7eLcGlw1Mx4nbB//1FBLcqrgmboboQRXPgO7IB5YcaeNkgLvtU2kflb/cSbVYPuEBdO668vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeOz+ShnIU3dNVRo2rQ/T/7OIne+TEbZpsxHFGvpm84=;
 b=ogZm0r/rljGCM42EsvYow7MNn4LgYwXnvg5YW2LgZVaMxiX/bDusEwwxR5mOzRngYI5CwluKtqK2DJ/cbqD7dNmFVvx4UBK7ZKCs8aEPKR7DR9f9bbNFrR/iRJZ8tgpESKT3wVAWRc/lYT5VGkIul2RkqHdcyOKfSr+gJvx/ZYe/vO9IfftdT5O5b9YoNMBX2EJK2oTWGJh+d3odQQvUPfSXEy1YXjiNNMbEghp+0FaUIc4+hB7ROu0UvDM4d9UkqZ1PAOlqGwrwidroecoFYrYUwK80jNw68PCnCTsip8UJK6Vcx97TvbwxH5F5W/w2/Gsuo1XKBcd3FPuKeuGB/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeOz+ShnIU3dNVRo2rQ/T/7OIne+TEbZpsxHFGvpm84=;
 b=ppffGWeG/XLjyhbfzC1wNQ4U+IDiCFWIFmrDHL1jatjxZ4ucm6OLw8eDQCroUL3J7XRXdrpusT6ixFpgH0DsHYk40a1+k8JK5mZFSL5DsOQXJ7kwe2ozOyI2s4mAHcFn7vvAhiuyFTS/5/Wn3Qtm0S0p/niYdEqtpJwDryBV+hjnEqMk2tvhS1IuSCwbA6xYDH63hTT582jLndBayDGO4L2OMFE9Df8zjpuVl4aH8K5s1724LoTgmD71rFYk+Uguu0nf4wVdy1woZc7O5pk6CkmQG4HNv4qZbQRKwmIYec3HCiVlkCvMSp1vatzkayJAjSOecfqHjI59M0b5DILptQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB6774.namprd12.prod.outlook.com (2603:10b6:806:259::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 14:28:01 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 14:28:01 +0000
Date: Wed, 27 Mar 2024 11:27:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tony Zhu <tony.zhu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH rc] iommu: Validate the PASID in
 iommu_attach_device_pasid()
Message-ID: <20240327142759.GH946323@nvidia.com>
References: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
 <e8e0f7cb-b4a7-433f-a204-73dc0a976246@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8e0f7cb-b4a7-433f-a204-73dc0a976246@intel.com>
X-ClientProxiedBy: BL1PR13CA0237.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: 99fed556-9030-4855-4ecd-08dc4e6a1b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i6sJfAl6lw5XUCPsXGtnsygi7RJJ/MgT9kf/ONtikC04ctagW1nO6LwR1DClLMziyTOmMAY4+U6bxexmbrbfn8aqYK5eXL7apbK6MHTqQbyf7obXaksaHcXsDL/KNefcNnflTutkIyYQDL8slORleBfzzi5ZstIiUDUMmActan+U7WOPxmfL/2+jBnp3UigIbZikgb8KhoblaJpwYQaGet3pK8lDM3jER3rboh9DtQew+mx+Qw5r2M5ZwYRqFc571rrDNWGOvctYIzUsJNfyvaxWIswZLrH0+Q5dkHhZNPvkXRLt0KAYk9uCdvY8BlXIHR38LJtxSTSTCaqkILx8uKVJw911rOuABd/Ep69vkKY9Yt4lasXqz16nEYWPXTrqn/1bzag/E+O1wciCo39BD3bN15cJYyS21W3qxq67+AiVIz7cwrFvscuSKTzy4sAyr/ZFrOG5+b79KNhLLutVEU6inJJFKNVISeP1oZE9poXEFIojz6GUd+/13ll5rP4E2FT6jJCEZS+WePh6DveuEMYA/IVyKpPM61k8iTL5ZLzR5ZBouPvpQVWUJo/6qvpPbt16+dnyRbbXRBrC/3fmJWZ+8tny4onz/uin6u28nwrEBk7RDp6rKETbaDlxXBCFjPqlnPNMQc8rs+X86sP3jsTQXEOPmdOm1yZbCltQNFg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+X/HSJixfFGkV72RBQPJMLUZPmX5H6746aRB6pLUn8IuhTNeMCDE2LrV9ZvL?=
 =?us-ascii?Q?ZLlmWlxogSxr2SL+5S55D0Cfqs7Dbs7TdCzSfNoMeyGR4lX8p83HejDBtz5z?=
 =?us-ascii?Q?xy3FB8mx0sTc+zBYlP4QRrV9SMZJ6zQmv/bggrzWR9DVXo2jlVrl8FJVt9h4?=
 =?us-ascii?Q?HbWV8bAE/Jy4qYvBafBUiBOdItyHQ6OKKeSNV2e8DSSVH2yrZK+WVH8em6ts?=
 =?us-ascii?Q?fmSx5QuDY1Y0CLqnfHc4rghU+vV6q3zhcqLmYKWFtctNp3CO5nGnEC329YRt?=
 =?us-ascii?Q?haEEKrNPmD7mxww43jlrPmZZCn4e2PRHJVcv1/eFZE/QNKGt3N9Sp169cTBD?=
 =?us-ascii?Q?Qzv5SAlpAxnMPaqYDiL/XWvwGUSyST8J8kDmbAXFk0k163AZQ010N4TUdnYE?=
 =?us-ascii?Q?BEKbzvP9yxm+nlo6R4pW78q9TA2kA0BtIDDWadn6wWaHfaEgm861bmXvmFir?=
 =?us-ascii?Q?hhegeU20WiqgbaTsRHUNGK77yXO0QouWToP5z7TPvFjs+35L58BOeEtlabTa?=
 =?us-ascii?Q?EVgunvsXXrHWmXSL+OLlS2zszwFWpnABhLrjIOmIraMc/9p69laPwDAhH3l/?=
 =?us-ascii?Q?1aYj+fDOudYhGt8KMxn8Z/lNlV/PuKL2IShbKxnw2FX4xNo8ePY7VkBDukHV?=
 =?us-ascii?Q?DHS2wY8ILiWmP3Y+DOZQ+3mYQf+oyQUl2EJOVxLTiotI4hiRB5IzGVaqj7m2?=
 =?us-ascii?Q?VoxpTBipzWqI6nj45iS63Wqo/uxkf4pGX87DYySrKoOKi9ASTlqTVe7LB6Aa?=
 =?us-ascii?Q?1O7RwVYKn0/vMSuAV+qpzIn5xkG5h3FBwtsHKMbGgTXhzK23tTdhXQFZosSL?=
 =?us-ascii?Q?UeD2KKb3Zvt2yUpxCbCPPAXjPbyXywUfd6gBkP6ssOTTeNS554LoBmJyd1H+?=
 =?us-ascii?Q?QZND5GNzajX0u0jkmwzQFfb0SUd6bjyveKjv71CvZ/8WZmOVVjSFOWlFc4YS?=
 =?us-ascii?Q?MTCsnE6oDRNTtYqqc4FmsJfgPeSu7eLFlZLCLpz51VsNQohGTezKIWXa1TvA?=
 =?us-ascii?Q?1Pvajq5P58Jx8HMKun93lfS3QgYqQPX3d6XNoxzTV/e/Kf0eJ+w/7txpqHGJ?=
 =?us-ascii?Q?3DOKuA8/waNsCzYJz0njegNH2U/ipwTI/W64vdbE/GJ1BVvgZphYu5nzw1Bg?=
 =?us-ascii?Q?KRc4iCY8ggz29ioNWHJfgQAThPhUOSiveNp/sNFmosOR9lSKx0kbYYoMLdqT?=
 =?us-ascii?Q?SUTJhRrWzmD1xBYM9t/gqb87YNFhmpQYhSf4xBpFVuIu35K2ODcCU4JF5ZJD?=
 =?us-ascii?Q?bnZvWVeVhGOUYU5xFPohm/HQVrhIFX3IYIORLUwPHGA7PLMzOZbrraaqkEwq?=
 =?us-ascii?Q?O4gn8Zi7fa3dXTB9m+BzSBYY7qkXPDvah5OB295EZF1LsNtVrAUJi+6CFFVk?=
 =?us-ascii?Q?AZ+yWiDRmN7obpLlHxTI1FTXjmpzTZghsuznhQLQR5av21CnjGh1Zsba7+ST?=
 =?us-ascii?Q?sAYLUGOIllGJS/f6E/8GudlD6BoWaaQUx53h3P8GjPx/us/BGeAhkSf/wB7h?=
 =?us-ascii?Q?LkF6FlqJCG5ZPYQKGqj4vAn1/k5EDMzehdLwrJjxqTw4KGaqXTpLxkpNw+BU?=
 =?us-ascii?Q?r5aSLJSQhQx+LfJnWrI1QdPEGNOJkol/+OrwDnF7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99fed556-9030-4855-4ecd-08dc4e6a1b33
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 14:28:01.0907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7m5LUTrVwF1t2EX/DbkmA9me6Ojiy1+oKIc97StCH7i9nLh6xXTustk77mJ0HBX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6774

On Wed, Mar 27, 2024 at 10:14:45PM +0800, Yi Liu wrote:
> On 2024/3/27 21:41, Jason Gunthorpe wrote:
> > The SVA code checks that the PASID is valid for the device when assigning
> > the PASID to the MM, but the normal PAGING related path does not check it.
> > > Devices that don't support PASID or PASID values too large for the device
> > should not invoke the driver callback. The drivers should rely on the
> > core code for this enforcement.
> 
> I agree it is reasonable to enforce it in the core. But I'm not sure if a
> fix tag is needed or not. As far as I know, intel iommu driver supports
> attaching both the SVA and DMA type (PAGING) domain to pasid. Intel iommu
> driver checks the max pasid in intel_pasid_get_entry() of
> drivers/iommu/intel/pasid.c.
> I'm not sure about ARM and AMD side, if the two drivers only support SVA
> domain, and have the max pasid check. Then fix tag may be not necessary as
> all the related paths are in good shape on the max pasid check before this
> fix. :)

Ah, I could not find the max pasid check in the Intel driver.

> > Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   drivers/iommu/iommu.c | 11 ++++++++++-
> >   1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 098869007c69e5..a95a483def2d2a 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -3354,6 +3354,7 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
> >   {
> >   	/* Caller must be a probed driver on dev */
> >   	struct iommu_group *group = dev->iommu_group;
> > +	struct group_device *device;
> >   	void *curr;
> >   	int ret;
> > @@ -3363,10 +3364,18 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
> >   	if (!group)
> >   		return -ENODEV;
> > -	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
> > +	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
> > +	    pasid == IOMMU_NO_PASID)
> 
> perhaps this can be a separate patch as it means this API does not support
> NO_PASID attachment.

It never did? For something like Intel you can't use this API to
change the RID's domain, it would break things. It is all the same
topic - missing PASID validation.

That alone is worth the fixes :)

Thanks,
Jason
