Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013046.outbound.protection.outlook.com [40.93.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2022B33F8C1;
	Tue,  3 Mar 2026 13:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772543067; cv=fail; b=iBIG0l73AubJsibx7KeHlJqt93DXYnm08OUsexAdUC5vy272dhiqBPddCvuuXbQLPzMuE9Xxo0lemWOahH2xXc0UOYQrLQSdsDflu+7k++JMTTViuNIaKo7B9sj9olFKOmXBzQfK1kcXtPYpyU9Fr8tQntH+SyLmCrCsWr+dkrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772543067; c=relaxed/simple;
	bh=gyreQ9uw2qAT0J9zQpHkGxqIZdQay+skxvW8owpuLvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JfdOQVxhy/ua2yT5CaFwkNLZa2L80KJF9gD7TUkXY3AcGYIFUJ/OSHNgBuDuNGG+RWRLCADWAOZTUcy0qhUhXGVqYdRGThJ1kCbpcSLpgfrw3Tr69AscdqSKQLDK4RCDcIha6mwphTMGobykve9nPSOLXpbkLvzkt/tp3GRbLD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HSWIQ+be; arc=fail smtp.client-ip=40.93.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HSWIQ+be"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DuSxHNUjF4NWFD1/z0BMeMoytOsYVXzF1w8Q+/hf9nh92KL8pW8r2VDn47tm4ZfZ6P4SQsa6JppGc2Hhm00TUDO9XyTXFXeCM0J3GcE53d4aPN1offwD5Ghv9jurdqbz9UNIgH8AdMG1vnCXzJ5yIasrUzGZorZuhZsCel1Cf0DLJklBcOHiM5l7VZTHTj1Tl6ho28vkInXaBwU6N2pjRKTA65sia+JfnSK9+3SslA8DAQap9QvxF7PWtWDKF+eZqK0IB0AZ1ZXZvwl1e848E00461dl7l3KdZB7HdjhgEPa5kfqokWmk7YqMAYvvf7Vi+OcxkKPUgGb8EXMpE7bMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+ykOkCHoE8/8wMmdGXRwh4IqcJxA/2xfN6wxt66BeE=;
 b=aIO14sIX0jQ1p7q9Y9BIkRaHv0PZDR3f/pM1VhTZ+7ug0J4odIfHkrRr92Nkdj4/8ojNmpQjEkDdbUOHGlKSseN9Bchw1f3E2G0+baApFJxnC7G3nWupbzi5qw1dfG9S8QqUPtWDuZ+BI9fxz8X74ZG5UF6NzkvLpQ1Yp5i7H+6djYNwVTX7ZfbH4+QQEgcQYsAMszdd7xTiDTLuKjn7Gjsf6r6d5BoerkVZyqxOuZf9LkQWCS6WsHoOrkNUT61Eo2Axc/tJb3D+b8DM5vdIPT6mVFovdUq4gRvXgXINyLjcU8ORQtnnGafU8JLJgW4COpTDt/UI4rC6hdr4CljPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+ykOkCHoE8/8wMmdGXRwh4IqcJxA/2xfN6wxt66BeE=;
 b=HSWIQ+beencN+tG4+jf9IPbFzlJphOdqNP/9SoTpt/u5NGKfF2DxkEm4HOF0LNbjIr41UFAQYrzVJ+3lzAIVaHu3os+Y8cQyXo5bLO9GEDjuoroUoG9v91Gzx7EkPVS+OoLbWztXEfDREDMhxdAIKUJ8d4UxJt7/9HWQQlF3DzAFdpsAVgbTDHsqEJjM5DGIW+2RHU/S4vfqdZOBHpx6FjRUlw3YRM1RjhBop25+zRYt2GzjsUcipIKNouXk6BHbpRsKeVvc/UioJ/Oxnzqd1Mzm5DgGLWJ1+biR78KxiBagRUJGDlzsCquY+9BHJ9DTMmN2uzZryfhpvUmu0do3jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB6944.namprd12.prod.outlook.com (2603:10b6:a03:47b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 13:04:21 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 13:04:20 +0000
Date: Tue, 3 Mar 2026 09:04:20 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
Message-ID: <20260303130420.GB972761@nvidia.com>
References: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
 <13e28ac2-a4d6-466a-aef2-7b3d7d9167bd@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13e28ac2-a4d6-466a-aef2-7b3d7d9167bd@arm.com>
X-ClientProxiedBy: BLAP220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB6944:EE_
X-MS-Office365-Filtering-Correlation-Id: a7205fe2-4580-448f-b100-08de79256289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	fpNVZhZS98WPiQZ58slMbytnWFczaxNwTqnJBXplcV+qHO7HkQFruA0pN6DHQW9kMVbNThr/UxOFJke7lxda4EBANgqgZ4sRNV+ePMfMWz845h8fbuoFtV0SkfUOhVn8YgU9vpiUEXwmHc2k8kyd0Si60wVEqO5+zrndCraaTh7juj5RHF8WVTrLgZH5Y/4rWLigMcBRLCsErTGmvcr/N0kH/DhuKAFpe1BySgO6Bd4OywZcrZqrfTRaS1H328J9Nn+sHK7sGovwPUVU8xxFKmnnxa8F3xTGwiQagMRm3KELukZVCq3eGkJHjRL4J2u9nHtQoysna+rez/km2mpFtTGok3Ss+mJ5Nz2mJhoXinWsLiyD0v9EtzQnC+B6LIN7Zr/yTxlegxE9aTwUoiWRWCjlHooZNJ9MFI/HyDBaECELwR10i1BmQmcabTAaJl7CSd7Dqyf63e40xgvhxkE/y9sXscbKMyS/9/e8j1unTkrD28OfV1cTRKlXh5diAWW36I2PjU3pv0EG2K4gvMTfQvMPjCmu6UcNks407InDHl58IEAu8jgwQhJA1wBHrq4Mz9h6jm/Ln4njZGQImDS4xIvZNHmzFZJBVuWnSu9DpmZfArTgfRpYwAw1GgAxcAJ4f72xnc8VH824CT+vZanVg98/VJdwE8vpb8oOIdUpzGFoIEJwELBFUqrIOU9LYkDNd9xVSA+LSWMleni8KHMQnOOE3QOHMHxA+oIUhP+AEhc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yB0bN+4M1RxT8O6+1gpuNVc4Se8u4QZfGI2938QUFplw4uIAGmIKl05D3oGY?=
 =?us-ascii?Q?Dl0O/U1nRbwwYsDjGVKEIwK9CYWSaZLRWcLA5b6UKpn+7Izbtouh28xUu3Rq?=
 =?us-ascii?Q?1tplPiW8Bq7N/e90xxAlwptqO8BctSoE4NkLb5+jKlrPYF7L0o8UFtxbsKKZ?=
 =?us-ascii?Q?czoE3YsMR0+BrZ/70oPAp3JCRq5Oh8bDk/paZrs/Uz+7dFGTx5Axy5kDocV9?=
 =?us-ascii?Q?9nXR+xYLYrjNnj3Lsrlxs4+A2M8ZSLBkRS0dGruDeUQF3iKcK+kphTSHXkpj?=
 =?us-ascii?Q?nPTZnrDZZ7JOBQwLIOXKROTma0k/oLdHZmC03hcZJ7G3tzTe80D+NH2AKv3V?=
 =?us-ascii?Q?TwC98Znc/7GOcq8pVwZCOZp60kJOTE0KNPdn+YMmAOy+hVQT3HWYzIqeBdx7?=
 =?us-ascii?Q?kT4jey8GvC1lggDPi4eb0t6u1G9/KR3ppd19fVcJv++VFNdsS5tshjpAHu5u?=
 =?us-ascii?Q?qOr7vKEZZApRLaihIO/9xqvTPqD9uo8rIV57jBmbvcuqSXirnku7hanH7F3L?=
 =?us-ascii?Q?0YcGl/tyrVY9YyUSZ2WVXl/KMaGQsxh+ICi118afLi0XtAjYeMKjs0ULhDcI?=
 =?us-ascii?Q?DwqnvdE7PdzXx+WfWj9oLF0Jxj4X7vk4h6oXNkaFmZHLbEXCKrTEvelwAY2n?=
 =?us-ascii?Q?dE3UWlcs87J/w++oymHK+Es2zicCPMgXqLASv9Szz7RrGEUexnD2NQvY6/0H?=
 =?us-ascii?Q?qmuXVCSQS1tcdzOq5J8EbGnI2vCti9rzWtAFRG0Y5xVHSa3N7lr47+nkiYWh?=
 =?us-ascii?Q?fDGz7rpmLO8yIxG6ouCn1xjpI1KhXYyNPi3avBdSHZHWYMGrHOoTC0snNiPW?=
 =?us-ascii?Q?u7PuLveehVdZlPxX1KUZkp/bN8t1NUNFsBxTPdBIyH+zUVvDyR7PA08anz2D?=
 =?us-ascii?Q?RH4AG5DkqOzEPOtTBo5XYgNhQEK6/NIPyR0rPphXbZPQ1LODK0bLroi2Fcec?=
 =?us-ascii?Q?5rD7I3bNR6I3FvuOcr7ftyPowaVmLF15Y4CxLiIUlGolZZx24qlOdIhesw3c?=
 =?us-ascii?Q?hNwM9WGuJDqk1WJ53iso5eaBp0kS+zGSH0SvZz+awzn6ADsHmLW4t3bSDOBM?=
 =?us-ascii?Q?5436tfJ/sNKuDPXV9VOZOednTc4Rnvh2XbNLJ9e+M1FFWM9bbke6/vfULOLb?=
 =?us-ascii?Q?YqjKrbjGl6lw8d0sa2YcZYAs0Rt2P0qEt7fUN/8rzJcwDz9XOjPDLw1DD19F?=
 =?us-ascii?Q?/6b1QRVXksPXGFi6c7tjUvJGxvgqGJmq7Vr24uMxfpiQZ2EILTn8puKCycWQ?=
 =?us-ascii?Q?N6j9GY+DglGcHBBMYEXdKNnnigqqXaGXKR+04N4y1Z7jNsR1hgBdbbFTDWgS?=
 =?us-ascii?Q?srP6PO1WeivZ7K5hH88USu3ooAcNmJyZnYgDv0lRlpFsbjxUt9N9OdljIor6?=
 =?us-ascii?Q?1+wQlGJGxg+XnbMdqmRjw512nOZRUjPpBnXCJ3sVquk8I2Ta3YWbG6q6aBwv?=
 =?us-ascii?Q?Qdkg7vru2SZLtn7a0nyUMdhGGqlJpf1Uhs0UwYnytw1ckgwEk3N/Q1Fr9IxG?=
 =?us-ascii?Q?t0Fk+z7Ya3opa+BgVs5HS9b64aeTV/2npL59xSxzWe49Tk8BG54dNqNzhsQQ?=
 =?us-ascii?Q?5PwPOAVAgnUScYVexLRn4lMtH8Gx/HXka2L+mRIeasig+UybDPujt41SlqBf?=
 =?us-ascii?Q?uC79ySu0RstgIfM8zLGh3nojYQ1Ih2jh4aoZhNEH7VS91tqlTvIkVun/RkDn?=
 =?us-ascii?Q?etL2xTNvalL8leKxQMq+gowHPu+x9S+NFP9/LQrDsauSvczZEDY7rzSNAONt?=
 =?us-ascii?Q?KCVh2S9H3g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7205fe2-4580-448f-b100-08de79256289
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 13:04:20.8586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8nOTd4ddDkJ4wUtYP0w5ZWtz+9VhSF18DF1pgffet5TgYOQdH60dDYx5gfvOKEV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6944

On Tue, Mar 03, 2026 at 12:53:28PM +0000, Robin Murphy wrote:

> > Further, there are several callers that can trigger empty gathers,
> > especially in unusual conditions. For example iommu_map_nosync() will call
> > a 0 size unmap on some error paths. Also in VFIO, iommupt and other
> > places.
> 
> My instinct is still to tidy up the 0-length unmap case(s), but I guess
> iommu_iotlb_sync() is itself also a public API where being more robust
> against erroneous usage is no bad thing. 

I also wanted to do that but found enough problematic cases I lost
confidence I could reliably catch them all..

> > -	if (domain->ops->iotlb_sync)
> > +	if (domain->ops->iotlb_sync &&
> > +	    likely(iotlb_gather->start < iotlb_gather->end))
> 
> Elsewhere we just use "gather->end != 0" as the "non-empty" condition; how
> concerned are we about defending against more-intentionally malformed
> gathers here?

I choose this deliberately to protect the driver, a malformed gather
that is 0 sized, or negative sized looks like it will have Weird
Things happen in drivers.

We could further classify the < and WARN_ON the malformed cases, but I
don't want to pass negative sized gathers into drivers. We'd probably
also have to de-inline the function if more is added. Do you have a
preference?

Jason
