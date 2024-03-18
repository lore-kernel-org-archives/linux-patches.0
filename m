Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7054E5579D;
	Mon, 18 Mar 2024 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710785649; cv=fail; b=KLT5+umM4T8NEKVfVwzlcBnwSjoxzBpkMp4phIw3v/8FQ0fm9M6f/WsePspDpjr2AHzocleR0RV5Zc2UroliaFMRy+Ux+QLFZwQIKLdF3/whivx5n3eqB16DLsylHk6A5iHbqedd7TNC5uLaxhb+BbCC2Ym2ArHS5vGuAWQItLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710785649; c=relaxed/simple;
	bh=Hyni4yD/Aazrc1+jZzmDKHX5sxns8tdBGboMYVn0Tlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ja5y9w8Hq2b0m9UOkGZUAH72BGd8Qx0MI568W9TN/0tnE1ocE/Qp4SgKdF8ezWpoaPpgT2/fwmUBqzDaSLIfCeEtkRi2DHOJOipP6xCS3PTujEtDFFfh617QnbRx4tGe3J3Hq8Z0f8BXkAdAj2znOjomaueLJegNiMTDKLGeDA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GLoPEYqH; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GLoPEYqH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQVJ/3VQdunkLqorjRXofeRdRa2NFEDbi8H/pxBrKsoXuYjUta0qn+pHuRFOwpNmGKcU3w57uv8wMRJkqTLC1UY6dJp7glx86E2iSp1yIg+omX52bSS+cCXwBWdxFr0M1ChZ4jMSs/uKPitcWWEEqZ4TL7z/1GDyC86P62pOK5zKgohIUjCh6QRZL4LBV/dLMnMuuKIacycUeC46EbocIruOB9UNPpPkIGHai3GZMNplyPgDHsPbjNn/QthmL9apcQlWov99wVBQdOfMf3a+hZ4APl03RY3fKEICDMhGajXWO1NhqXoOea4Z3I+aP4Owi1H1hD7VX3xdoR3PQZo8jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKFuD4U2zKKLgFprRgJhZCGA4zcAfKY5p98HiWrJOVQ=;
 b=k7oSEc+9VGqAWhHl+Bx4C2UNCOCQ3v7mYKxb2Yl/RHOWRUHAE8xm5x4N0zem7awAn+yX5s4P4p+f7ezxJWYzSU7pp2WEsiLGUWg9sIGH0sYzRTKgWlIGZMy42JArxC60I8m6QsVrH4Mced8UzWHpbCMeg6X9H7/cTbrYSOjAN+gDwTL8/bvxOIK17ELCBN4BaELm+geDCW0fez9aUGJ9EdWLuMxf4K+Qm/N91P7TnVEUUIc2YkDAVHP6FBrOPPPKnJA+2iB2PLvvA9A6OnSmUqEEhqZByIQtL7Pax9q/TUv6KBNzly1eNEYdUS3HNk7bgyUABbieujuOf/RLchCnqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKFuD4U2zKKLgFprRgJhZCGA4zcAfKY5p98HiWrJOVQ=;
 b=GLoPEYqHy2W9Oioplex3UCKK4eKeoDL0jR+mEdUFK1kNK7MkkxPq7dvYgPIn/ne/cEltP6G8I4hDq/yrx/YRKUn/01Ix2Eod0Jn4UgGwn03l8SeLd3ZC152JJuVcy3Muzd5eF/QZ2cDruOSzAasIfyPDr/x8HYtUVXzTGoSUjYf8oQNvvJzfASfU/GnfhcdnVL7i6PqcF2J0yc1ka74H1d23SXFf0utxBj3g0/moIUCEuUNN5O5vgIV1Vu0uKR1ZVHDXzh1Yxm6h7xzIpl64HYH6M4FuB2y7COL1YEfxVnrNdGEk2OgtUpak+smNTlTOeNbRsxsWltrLZbOal7bQIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB8608.namprd12.prod.outlook.com (2603:10b6:510:1bc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Mon, 18 Mar
 2024 18:14:02 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 18:14:02 +0000
Date: Mon, 18 Mar 2024 15:14:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 09/27] iommu/arm-smmu-v3: Allocate the CD table entry
 in advance
Message-ID: <20240318181400.GH5825@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZfUdDpwWYf1Ht4T0@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfUdDpwWYf1Ht4T0@nvidia.com>
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB8608:EE_
X-MS-Office365-Filtering-Correlation-Id: 139eb556-5c1a-4b3f-ac26-08dc47773084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	26WvFUfOSIjo2wVYiQXhujdNiLTj6nKCRcFlpYmIM8bAFf7Lu+CUzI85P05z9H3K3yevV9fhsT+rMXCBVBvOk+qHjhCORl0ne91LNDRBgZrB3hoOFTNL+HSEI2LjiT5U49INFmqBjn2pZAgEPdTGr+9ZN/Q6/XYwuKwJnSsL7s7JosTVXQ87CCIiaS/Irz0L2nEKb1CI1JF7FJGC5nFpsamlBGPPQm6GrDrdgYIDEmyijUO4fVFucS6t0/xijUiu168bLjEbnP6J76i+jTD1qQNOejwvZ6Fxn1DoPepwu2uDjW4GgvY+qTZp1ZLg26WPAIrY2XBQ3vk8LSSJDzLEeaKENwvDaOnzXglKORtw075rAHPm7Oi4c/xfSbc40xYXFAVdTUvAmruxhDfZOWk6ZrMG41l5Th4sBg66igg58+RFMDZ5kcwfd6lOMRHAh2BAFJAmnpqCWODs6IHDc+4FbfQaS+AFEDDGaC7WBjGoUK0xUQAbvuDi1OF6StzeX6wZJenKEOL9ppiNn6or8kBrfPuI2PcKxMhHmTphbLwwAK7SKQGmoSt/IrOcIFtacz5PV2IwqJx9HuHn15D20tpn8nvDBqrTZuYJGynNcPChRbgHNPALmAssZ0kgtvCf3HLpcopiV2YuPvXvAB86Zksvpf8bGvt3JIMrD4UYBWvLm5o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tiNJj9rkwI07abrJ+hvQNevGGrzVdEXT1hv7B3MNU+ghvDMgBjGTC5JaeaF/?=
 =?us-ascii?Q?Gw2DF9iJfX/jCZFeQ6PZFWyL9kA/RwKZJABZevGYRcGc46LkXSoWXvhVFyn0?=
 =?us-ascii?Q?kWdCd3skhFEG1MWhGqaMQLMxQPAYH2ebRSPFQ+kEixfliU6UBF3DkfVbLGQ7?=
 =?us-ascii?Q?TpkdS5r6hFLw3Zsy9Zb5mB5dshBEUUeuypjOXNq+Zoxoz/3mj+iB/qGWoKO3?=
 =?us-ascii?Q?q9ETXCskPBCVm4x5nxbMzQViIbCL8WXlGEMNtxScGInT19mHaUb3IEiRRTAK?=
 =?us-ascii?Q?9KHqV4QRqGeAZznm2VK+dxgCgZwrhM/v8WfAbP9W1n/zO6actEGta8tSCiPt?=
 =?us-ascii?Q?0jFRO6/KnLszlivEC4fS9LzCTX4vm5oMYjS+OnWVuYiRLoZp/6Zij4vxIlek?=
 =?us-ascii?Q?5qwWuTBP17fWjN97N3eUEWmo/7qGWV7nEnwCyawlal7FHmY5cpAixr6IBziZ?=
 =?us-ascii?Q?gp59Ld7gdmJRyjh3WfxiznR30UTieR7+J/stIhX1t2Gumymv3Axn1/wXijvj?=
 =?us-ascii?Q?2s96GTsADkhm03j5eFn69R2D8QaHBzamKVFAWfN72EEu4dEpd0exkmk5UUsp?=
 =?us-ascii?Q?qwSez4q5vzQQSPt1jQVkwtqQXMEgjuFkMEcz9o3O/gFRdtRwvK9WD3GA3Tmq?=
 =?us-ascii?Q?3BcSGDK/YoJSlrCZsZN/fhLmnrtbk56fzzbVBxVnqW39N2a1pR4sw5UT/Y7j?=
 =?us-ascii?Q?0p2tEobp2/CM3x06kBO7sLFXY0xJUVygas/GLtkO+5Ke/kbBJx03P5x7mDke?=
 =?us-ascii?Q?ue1bVZaXVxo1WZRwPi4ZeBS1w/J5vrsErSAVIFLPuBJa3BFFU33OkdQ9NYU7?=
 =?us-ascii?Q?L/vKJL7jdPU27s02DlI1gcllGVcub0cc1ZTwwY7kzpaZEWAkXm+CB9cwaHXV?=
 =?us-ascii?Q?B36r68j3F5+cR6ou8G1zUv3IcFM/FvgSNSgcUIjE6QD2jpHe0ivjQ+376Z7y?=
 =?us-ascii?Q?uHgAQoDX0F7RFDsD1pyPC54yGeD4vZ937aIcrjnyU6PuFyOvLrIZrhZvnVsQ?=
 =?us-ascii?Q?LdiNpzfQZ+KJjLTO7yXdIICgM8zfSJ5ybt+UNtZ6ITGcp7k8eJrF1NLzlCGQ?=
 =?us-ascii?Q?I90AnC8I/iYwi84fCuing3cN0SW3SunUr5F07KPswlWIr24GD6A1fSlmf4G8?=
 =?us-ascii?Q?O1z3BhGLBMoEljeUnql3+Ehfu3fluYsprmXzOLEzh5r+X3liVTi/SernG5Vi?=
 =?us-ascii?Q?EaTK1n+W3S17fkXOH0j7eQ9HoCzUMmGS9CtP5xZAu9tv7qKmUO0aV6aO0sAA?=
 =?us-ascii?Q?u2OWd/TPUuk5Bb/4EZIhpjU8veh8iaZDpzQDMXhYvD0VLiQm8ikSA9s4EBoO?=
 =?us-ascii?Q?gorGExgmbUL1CDtgBmkKYBbfdWWHM2XhGLc4Ev19u43VnHKNkhy5rxb15w6M?=
 =?us-ascii?Q?aTMm5tDPlCTMjRThbdlexsh0sNgo4y9HJwxkBZMkWRksSLShof3tPv5m/J1F?=
 =?us-ascii?Q?Pqb+toMami+dwMAwhlNVsoIuC6oEzUf2UwT3ecjc21oqazuJE9151ImUgQYd?=
 =?us-ascii?Q?TH57Z2r3rrjG+f97M8syndGOoC6jC8hZuN6Q9D1RuDL31IYBBnGNw2I5mGm3?=
 =?us-ascii?Q?kMayGBkWxb3o2MWqGnU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 139eb556-5c1a-4b3f-ac26-08dc47773084
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 18:14:02.1984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5smTt6NOgmsIU0o5WrZLKdI3EVOPYE/To5iJBY8EWDz4BV6q9MsHY3jlTiNwuDjA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8608

On Fri, Mar 15, 2024 at 09:16:14PM -0700, Nicolin Chen wrote:
> On Mon, Mar 04, 2024 at 07:43:57PM -0400, Jason Gunthorpe wrote:
> > Avoid arm_smmu_attach_dev() having to undo the changes to the
> > smmu_domain->devices list, acquire the cdptr earlier so we don't need to
> > handle that error.
> 
> I should probably mention this in the other patch, yet PATCH-14
> adding arm_smmu_attach_prepare() to this function doesn't have a
> rollback for CD table allocation. I assume we're fine with that?

Yeah, I think so. The CD table leafs are never freed by anything, so
even if you did succeed to attach a PASID and then detach the leaf
will still hang around.

If we care we could try to clean it up by consulting the PASID xarray
and checking if the entire leaf is unused.

Thanks,
Jason
