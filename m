Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E01F127B7B;
	Tue, 26 Mar 2024 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477823; cv=fail; b=HznTY1rWvRUezvWafUMPmjEagYqLgEPp9yZJ5Px6BXorj4TDgmDy/BSlZ9P1UpcePy86Ee4BltJGHuQbQx5LyZf9xFNpFbdILzWMSpNvB0SieGnrcidJbMsVW8oDQi7X1/BM6lE2CTxeYDBHcG/8HnyKa8Bfk89Up0Dye2Sjc4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477823; c=relaxed/simple;
	bh=MeGEhZAXY9eRoYQ/Zq5fjXu3RqwywuK3HxwdSeweQuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eG9QhVKV4kq439VrPXmfRjM/W9IcMuFjFzV9VpnYWTm75Pf888tBSi+3RRsKJoBKb9m1TaG7MX74wngw0iDJlno/oRO898T5Z4rLH8UaHK35WLux9Wc8s1M0T1HS3FrY0hbccvX7mneMKwriAauVcKQRoVb30nfkyFY/as2jwHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K3QvQ/3o; arc=fail smtp.client-ip=40.107.220.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K3QvQ/3o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSA0tccYkqYW3dK8EzaNewA+E25taYVkozaAceN86rX2ecJblDUjeCUZ8Mf0IhAqZjyW2TMXpzZuz/MWKzRTTEWVnebryQGLfELzl5pK2D8X3r+gxsgqAV2VdJxs+t+Gv0//4/d0Zuuycfl2Kk2d1NzqFmdLhNsccw47eJZgAVgLcFLqz1GWagR5GUpc+dUA+FWRU5B5TSJSpl5Y/zpH7y1ul5mqgB0NdfQ3/BWHtRct5OeWqgBXm21c0pgP+PX/N2TnjsrxhdxXaYR7ZaV+ZwQPB1PlU/WHRm8I63Zi7blpRpHwcnIIToHUKcctnX4miCrR7wfzfE1vzH0dcviYJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n02xFviIdnMAB9nDwMXkTEH0hf+yPaldXy1NghAB1w8=;
 b=gJjFLjvbxpRhp3te37gju+FflVLxSrII4rm5B3k13uiCiIV3n1cRi5n5BkjHsRPaosBLb3Wo1GYMkqgJZ5SOlfNxx2ozPsHs+NGG1ydaYCbHbZpA4aHzfFZc0u5IYToo56/mWSeD1rzhrq7nDJM7Zxm9B6V7OQxLNMPrPyJYK7UsuCLrM65H305BkHu4cYf3BdKmoJUnuD6HHAP1h5H/tp9cxVkOA+/GQtiH1jfpHRKcK0qmrXhmXHnROdeAF48wwexRA20uEf9kBRSkqvazmssSqa44tikFSX1z4h23pKMK7gsyXI7U94WLtjKmDQSMp4qATeS/XyPVW03FSJJOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n02xFviIdnMAB9nDwMXkTEH0hf+yPaldXy1NghAB1w8=;
 b=K3QvQ/3oMzXUJuLaXEH9IXSkX/nxfxOKedd4UWBaoUquc3WBNFIt9qbDb6hmspKs66K2n1uaEY0Yxj2/kTsxq2LcRO23kiPJ+VUVRbiIcD3zc/C93inEHotqOopPRjdU9nR0wm5zIy0cMJ9aMJEm6Jg3CBIf47XSyqxUfSO+h1Ln8xq0jncyZHA9EXsczZM+Aro0NRZOIEpD0rb0JusAj649Uncni/OAV15VI0ZiZShabAixuNTVVDeboEd3HfF5TK4mI4QdIqPrc6BggW1Quy/PcpLUectzdbcqehitx+pMbotHWq9KWPQXKRmrRxjCluLGKAc7IHyGDxKwWdD+mg==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CYXPR12MB9388.namprd12.prod.outlook.com (2603:10b6:930:e8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 18:30:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 18:30:17 +0000
Date: Tue, 26 Mar 2024 15:30:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 01/27] iommu/arm-smmu-v3: Do not allow a SVA domain to
 be set on the wrong PASID
Message-ID: <20240326183016.GK6245@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf3EhA5ZBNwF2XOr@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zf3EhA5ZBNwF2XOr@google.com>
X-ClientProxiedBy: BL0PR0102CA0064.prod.exchangelabs.com
 (2603:10b6:208:25::41) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CYXPR12MB9388:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2ndFIzdPAYTMqZnSvFLA5+a3Mab2uRANmur5goDjmevaVxSnk79tABhIGkCOeeNj3/DKZ4bFnVizrXhfsfwcNn0OZ7JE4nH0YsGbTti3jjUpH+/+QhB5B7vIYSS4sLwC+jXwS/ZtiVTWaXHr+EH/IpOxH/AAexE9IIO3WNxtNjJzFlSTyxt9ZK2+jd6q/qZ6/6IiVvuGPtQFBWIa1yW32Pj5XuXHNNOpIgXi6fwCu8tpZaTwhspxWIfUXr29bvAqr9zH1KGohRNfgI/AIPDsNn7x+D1NBWdnkAqhRFo3GY2jdlcB9QRkcCEqsJuqfnNR1l1hYz7w4uvzud8O9zd9yUmlcpDf9POuy1WUKWbL+GRyONK3S9kwFn+Oiq4Kgf3v8IFAi3XMd0S9wkO4fmmsmdC4zwVJZzONmLl2YiqlFsA5blAjPrXWtZ1JS07R7C1NPPhgdrKS+MuqhnbcvRjGjdUg+mdZmAstuKMW2CNApWH5MeA8WHrKoAjsCYNLnc9FpNwJxXkTNfXB9sTF8hibmvy684Y1EQpJY9qeM/Jf7kWdAlJ4OI9XgAJj99LIYg77c40VbjUOrNzTVxKBrewVCSuDF333Wmp1MdHapRS1qdw51umsYFx6YWkCVjwDv1V5s5dRI0vzfrFVLrvW9ZloMTblrH94ior6cWhNt5yEH14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWpoQUkvQi9PQkJ4a3k4b0NSYU5BLzk1ZlZXNjFOMDgxbnlFcndZTXFBRm9J?=
 =?utf-8?B?MXhNeS9Vdjl6aHpPUFNOcy9McUFJVHZRTlNndlcraGUzVjlSZnFyVW9jRGxw?=
 =?utf-8?B?SzR4MzNDcTR0L1hrTDFQbEI4RWhhQ1dIeW1PbUt5dThqWUwrS3pleXFtSHhs?=
 =?utf-8?B?aG91OHRDUldKMUJSZUl3dTQ3aFByV0I5ckU3bEpyVmY2ckhKQXhSZ2lraU10?=
 =?utf-8?B?akxDTjRtQ0FKMU5KcDE3VjhGcmtQTFZ4aU1yVVpXaHZycjZxZzVTNGZEVFE0?=
 =?utf-8?B?aEFMcTRFTGFEYVlBSm85RzlrWHJ0Nnd0K3ZpWHVtUm9Sc1hRNldUS1oxMitj?=
 =?utf-8?B?QVNlZHpSdGwzL0RsT25TaGpZd2M4RlhRU1dsdmdwVE1JdnI3MXliTmlSUFl4?=
 =?utf-8?B?Z2VicjlndW0zOEF1Z2VScnZHMngzR0tTSTc5cVN1TUhFUlIrc1dZaDZ4aEth?=
 =?utf-8?B?Qm5Hc2xFRy8zVjcrVm8zdE1vTnpBZENtS2t2NENBMnFIeFRYNUREblhONmxi?=
 =?utf-8?B?dURHS2tSQmtseXR0dDRZSzZkZDliSm5hYUxyOVBhYjhtdXJUeXdkdXpiZWY2?=
 =?utf-8?B?YTdaWTRaSllDTzU1aStTS2czQTJXM1hNU09ZcnJNZmxCVEQreVpDUEN5S25B?=
 =?utf-8?B?MXJycERmcExTcVp0Wi9WTzl2d01nSzJwV0pRb25xZXJWd3hXZHZGR0lpanB5?=
 =?utf-8?B?QXBoRlE5QUE3ZzRibjZOcitYazh6NW55N3hTaTlVQmRpeVpkMS95azhyRmly?=
 =?utf-8?B?YkI5T0dOYzJmQnRER3RFQ2VtcWY3Z0lXaTBqbzAzRnlTNkFsNUh1UEhTYm8w?=
 =?utf-8?B?YUdDR1hBcmZhOGxxa2g3TmtRVTdqbEVUazVhZm9rSWJzU2R4SDZJejY3ZEU2?=
 =?utf-8?B?KzNJNWxTNmFaS0tHVEEvUy9TQkRHRUEvbDJpNjQrWHZ3SHZod29lT1lTKzl4?=
 =?utf-8?B?UTNtbCszcnFOdUxJSGpubGhDcWYxYzN6TE1peTd4S3BzR0YveC9XVldwV0Rz?=
 =?utf-8?B?NG1CMnNTd2d5eWlCMEpobEtLMnZSTHJpRG5kVFFIRkp3M3A1Nmh0VXpKUVU5?=
 =?utf-8?B?bzJJS3lvREgrcnlpWU1DNk1nT3ZxS3NGMjhMek1YTitWTExQTVFTMXRjUjNZ?=
 =?utf-8?B?SnRQMXVVMHd1VHFHREdoK2RWUm45alFOb0dzYzNYczUrNVlyZ1NTOVlBTTBv?=
 =?utf-8?B?YUF5R3JhaHZjUjgveGZXZ0xVSjF3ME9GcVF5RGlNQUdYbjVEd29PV0dEWlNQ?=
 =?utf-8?B?aTFGNXVzV214RE1mZ3pMRElJbUErTlRJTk5aN2lnQjk5REE0RVNpOE5KTlJh?=
 =?utf-8?B?UUx0SDl1eGVZeHZhbHN0Z0NoRXFJWE5IVU50MVhaQTV3My9IK3BwVm9XTDNn?=
 =?utf-8?B?c0Q3QjFpSHZZNENPWVFzRXhXMEU4ckxzbmxUeHdWVUpmeG5uZHdzSElRZkdZ?=
 =?utf-8?B?TGJaUVVRbWYrSi8xNzlvQlN0WXZyS3BmK3RnaUhZU1Z1cGxCL09hT25KUmFy?=
 =?utf-8?B?cUJsSzdwWW9hZkR4MklaMkZ2RWgyYmZaczJlNzlkOGUrUVdkS1BZSDNlU0t6?=
 =?utf-8?B?cEZEaFVZV2JUeHdNbTZDWXN6NUJyUjZtNG9oQXdNQzRrcGZyQnc1VU9BOVpG?=
 =?utf-8?B?VHJNZE04KzZISUp2ajM4ZTlZV2NTNTMxKzNSd3hVc2dvdDNBem85RmRzdXdM?=
 =?utf-8?B?ZVVqRUltWlNKTTlESlpBdDF0S1RodlNyU0RLcExPRUZhTXlBMk5rUnB3U3hY?=
 =?utf-8?B?MWFZaVhIV2tlUmJvQlA3VGFCbzl6eDlIdGJxUGF4aE1WSEljZlJYUE5XZThi?=
 =?utf-8?B?b2p2ZThZSUV0MWo2TTdFNzExem4vTDZYQTJFcWFGWDN4NXNNaDI2NnRJRnB4?=
 =?utf-8?B?QkxzcU9GZ01iUFo4dDErT1NNSGlXbmNUMjF4REZ2MVQydTBGWi91cHJvRWhJ?=
 =?utf-8?B?WER4SjE5cmZRZkh1MGN4YU9KNzV1Y1lyZG9Md1JZVVlxaHg0ZXdOcCs5MTJp?=
 =?utf-8?B?eXVjVVdVb3hRRFdIMFZndTEwK21UdVRJUHZpaGgzeW90ODQ2R2prMU1TTVdt?=
 =?utf-8?B?WHRyVXRrQXYyWDlBWSsza0dJVGw3dUhoeVhpeUphSmVaZ1BDSjlPK3ZPdGtG?=
 =?utf-8?Q?byVWEheSMkMA1YTBHjKQUVJO7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9f9604-4499-4d36-0dff-08dc4dc2c94b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 18:30:17.6810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eI+yyLvoTDk5TayJ1n1kvaO5o1ZGYZVu/vNqDKA2gak9kOEWFX3aWhO3ltD7rAzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9388

On Fri, Mar 22, 2024 at 05:48:52PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Mon, Mar 04, 2024 at 07:43:49PM -0400, Jason Gunthorpe wrote:
> > The SVA code is wired to assume that the SVA is programmed onto the
> > mm->pasid. The current core code always does this, so it is fine.
> > 
> > Add a check for clarity.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index 2610e82c0ecd0d..347c2fdd865c1a 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -581,6 +581,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> >  	int ret = 0;
> >  	struct mm_struct *mm = domain->mm;
> >  
> > +	if (mm_get_enqcmd_pasid(mm) != id)
> > +		return -EINVAL;
> > +
> I am not sure if that is needed, the only caller in the tree is the IOMMU code
> and it does the right thing, as that check is removed later anyway, I don’t
> think this patch adds much.

It really should be backported, when we get drivers that do other
things it creates a hazard. I've added a fixes line.

Jason
