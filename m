Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA5B12FF8E;
	Thu,  9 May 2024 11:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715254822; cv=fail; b=kJcs/GyjDztS73WA9EPb2olkBAoMAzLYJI0qOXm+kpwOjrAJTyKF/GOp3FJK2p0oWCOLM0SjMp/zatYPxvvWY4HBKuE4Zc3Jc+Mx6v1sZ0B8cO/BhGZy41jtmuehKC9sKLOBFoTSyhLFFmKRZ9tO+dOurXDtmv7y2TbwYIxXAmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715254822; c=relaxed/simple;
	bh=sPefjhaDEzzH0wzUE0ZGWllD3c+kZItz7PFAnh352nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hwhdW0aMH2JgV95iuHtPRJUghrhC1NCKUpe0MFBeRLOB1ldjSibsW8VG353jIqJuQB92LdsN1dxcuYiXTRyVhtnxlsjjX8v/YYOxW64+t1nFu0TcT36S25B576xDKDcX1Vqyzo3OaVSfUWySa7GGat0tYUKZeAqo2jIreWFonzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mNED7gZF; arc=fail smtp.client-ip=40.107.243.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mNED7gZF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIe3rYalH9KBzZlH7ug95MoyfNcweoafRO4WZ18keFm9JUNhipEvLUcPDnNwJ787k4VoI2jFYIXO56XjtAMLyQ8j63WwH0qZAKMt4q2pKtnD/CTQaxTzlXj4QzAfM7L0wouXEyI916kX7x3Vsx9HGBOC84n0ZzyBnDXe6/jl7WJYaKzwuHzncbe75ViQo8MQRh/o3vaM/4XZR2BS/pA/zvWhwTE7utPwcfWPZ3tLCaHca81kS/mfD7FeRL4rCZLAqpXEyTuXKbOh3rhS1r2tHSlI24Pmyfd8+vHJu284D0NcBH2c7eJAoOQsCylC5B3I5qWUd9bcg7zChKyvVS3SlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJnTIm8UVLhf7DguRKmHXUSx0SX9O7xlo0WmLQDjqMQ=;
 b=GuoI9y5ZkA1kj942wgnFkyeTFb857Jv/ERzvNbRkHiHDOH3izHbDMwP8IHnq4lDJs3M9IuWsQJO166UEgrhlo1uQNr2jPo6sWCBFvOJeagt/mQiGUs+kiZXRYCMtzm9Wij8/vGNKLh+AN3601KMBlKO3YspoUS1mKZ1oV/qYoTkZTUg6RHV/GcVUIeazWz7DIiPMDrkLMQ51KqlpvHZd7gcLvgJt3ifCuo8FgghczeuVfa0dJwqEncwgpCsTZYAwKtdFF8vsctDliJnWEUA2IrI7XAvo5Hye5pRE1mgUd6JaJD0O97dwNaMQThy9jiIFN5N2MuoG+6YbniYOJAXBYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJnTIm8UVLhf7DguRKmHXUSx0SX9O7xlo0WmLQDjqMQ=;
 b=mNED7gZFD0m27b8c5OvShKnuMEj3mYIm9KKjR5fWey82R3dVqw4sHLQTUwwAeV3qLinNynqGu2nuVQhNoEX4sTmsjU++s7NdJjTD0ngFhnTweC3Oe8C7wWsMIEjizpl7LIzkxQR1Lsh2jms4dpe/290pjZIAkd2C3A0NvS+2eQ9vE7fKgRRjFs6KG+LHaDg1lFhbIkgIVeWmkJKCwp80Xcr3nrltKtnfrLGy/tlo+O22wq3xB5F6oZSFzYmOXtO4zOGi6tHoFjb1y5uPt/nItxr8OsWzb9YCk39HBEUZUV8LE82HyOSqI3FJvGoAlBp9XUxPKG+bizN9u+3rcBlKMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9143.namprd12.prod.outlook.com (2603:10b6:408:19e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 11:40:16 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 11:40:15 +0000
Date: Thu, 9 May 2024 08:40:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v9 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <20240509114014.GO4650@nvidia.com>
References: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <smzgwi3nbkt5ws2psvh6hzygaelalfviv425q6igherxp52tga@6x5u45gvorrj>
 <zgyiqgym6tf6dkxa6bxzfgexjojwhteqjmuxmed3twejpeoy2i@ortfllwylmpp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zgyiqgym6tf6dkxa6bxzfgexjojwhteqjmuxmed3twejpeoy2i@ortfllwylmpp>
X-ClientProxiedBy: BL1PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9143:EE_
X-MS-Office365-Filtering-Correlation-Id: db9d96ce-55e7-4f24-b854-08dc701ccb4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yew/euNG1jekPYBc+XfMlKs9EVM9EZ7XqGEGkuSu3EjYtF8X+4Y8KnzvzCMS?=
 =?us-ascii?Q?xJXqcamK3u+qmVUvlzs2LAHXjBWYANTQm37AobhoVjE3/I3WwfRP93TQ3FMa?=
 =?us-ascii?Q?+Nzf/k6sFQ9QIH4L4hFGxBbuGXpo9yUS8gG6L8hgaxDwybSQvpdgmZc6xDK+?=
 =?us-ascii?Q?z8oxJGh0xKfQEXBrGRKJEH9KzxinC12Rx3Pu89Tvjtw0wF6u5gW5iJgNUVtR?=
 =?us-ascii?Q?WTONha5qjOvi+hcpJzr2GkhPdaJvvGNXtu1CiTX372GE8LGuJQdAS+bfO7r5?=
 =?us-ascii?Q?dIPmm9IODoaMc88Fo1R6RewrWKmka+4ODsuIp4cCaTb1mLyW9h4BA4I47zLK?=
 =?us-ascii?Q?wUPxijzmASUiQ4175kJw3WJ7Yn3q0lWMl4O7DCpTkmUvp84t/T5FTvuK9LRZ?=
 =?us-ascii?Q?fJ/vgGsvkXJp7V3+I+xOgpFpiYB8udzgIM6cABadeqB1HxmU8WofLwK+Fn0y?=
 =?us-ascii?Q?9jwrcH8BU/63KJOBM6VntZW+AiF9cCJItiKi6r+hxTBVp8pKIvxszhkbQc62?=
 =?us-ascii?Q?DKzeYyjZKkvnZovUqxZEOOQ7owb4sf45BF6TbO9ARUqCjWEf5dDkvv4WLieN?=
 =?us-ascii?Q?g/Opc6oW/dNbmUhw5jtF45pMaHRt3CeWvHOX0W63G0HQbXlkhUdQnP46Hw9N?=
 =?us-ascii?Q?srVGh+fWzBwGXrBFKBrUqRkK763Jkh8pR1By2ZDS7CpJJhTG/b48XAGblvm0?=
 =?us-ascii?Q?5xOgP9CKh5oUIeDdnSFTM5LtBEn4BsLYfJLFhaA0/Y4uqdl+3YyY6/HpTP6N?=
 =?us-ascii?Q?PsjKI7rp8xueakFF6sMmoaIJSExPmBwSlTKtK1L2UtIXh6A5HfLIpUsJYnmK?=
 =?us-ascii?Q?P3qNwu+5C2SKscdl2+a1BNygnJzqo6x9c7DOCUDCnTFcJoEyM6WhSNySYiX0?=
 =?us-ascii?Q?XjFlo2WqxHcf3cCyfGkr2DWoJfvLEAtNKbPze8qlXN9HGW+Own9Qq7z4F5jz?=
 =?us-ascii?Q?Wfmetzb/qu+zpkV7jseh1V48iIqUpoMiqrGwBvcLLGkVJ0yn8tBQNc4SDhfk?=
 =?us-ascii?Q?06GnF8TNZLys5MBDGHff9+vt6mKM+b0YTx8g6VJ4zRB0n+TUmuirzJRA7DFf?=
 =?us-ascii?Q?02GXarb2p848e/m/49TPjhYVQNVvjesLwP1RePES9XEHVD/3iHD9KCfoQYjh?=
 =?us-ascii?Q?yQPX6IGLrtkTD/yPFMG8pLCLcG1wyfgF6eHdegXTpf7Oiy10WqCDMTiWOrdS?=
 =?us-ascii?Q?+ldkZlR2pxgJMYjLi1kx+z9T0OExmGNVzGvZOyVo2wclWKSvOZuXukgVMJQp?=
 =?us-ascii?Q?TtdeevhjgwaTN7jhZ0CTgV+tkrT14JWrn8SCyYM2Ew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j3m3gj/8etIVDy6dtwtG8y8qqde4jKYtif2DoI3hfwZVNq8NFaCcY/G0yKCb?=
 =?us-ascii?Q?h7nuj5ochIzLcFnDsy4RbOaFlFMFljncteJdSJKIdPzxzwo5YB75ifP5OKQ7?=
 =?us-ascii?Q?PHaZXce6O6rwstrRLqO04V6cbEpTpQaCsQsS9ngAmU8OiKBKW9mLjwe+NhSl?=
 =?us-ascii?Q?GGxdWWWdFONc1MEBLkbSfjeH/v+tTUmvUDwHk9R+oVeQon29wc3D/tMxNO/B?=
 =?us-ascii?Q?l7cmt8sVOMx8Mu7ZCdvsGasFdEDzwY75qa3U2Fr0SqYMuAaCm7GnvapLAgx/?=
 =?us-ascii?Q?Ka0f7Xf9P+nBLmc6tgaaVZDyy7t1zA4heu+8C6lHF4BuwpVkeTBIMoQDf8Z/?=
 =?us-ascii?Q?bPKCmRUfQVvXROdY8bEmbJ9WeQ0OXjYXTTpbMGi9ipXzATdgHepPk43CbdiV?=
 =?us-ascii?Q?QSHxO/wqbrBEatvD/skaNMf+1iv/r//Kb0RKD6fO/fo00+gjAX5khATclGu8?=
 =?us-ascii?Q?ewO/GGh/l4txc/V9rGOWhWk9QcGnoNKxeGNT7X0wYEidpUKvH93eEb70W3Xp?=
 =?us-ascii?Q?iAoiOnrgG5XKpyRMFBgG9oXF1TGQhMqdtaFGYaDNNzMX8ieMqqsYGwzit9Zy?=
 =?us-ascii?Q?VTx/2s4JcUL4pI+gVbUp4CK5Kkvz6pVutBiWWYsws7Ji+CXX72bN/24DlFds?=
 =?us-ascii?Q?VZtc0LZO7jJmVSbgSsrbM8lFnXJKCW1y4X1KAqoOJ5lqviIf2lM+7BKe4Y3U?=
 =?us-ascii?Q?lxSu/7f9a8InTm4RcTSjGfAsVQk9Ob9f+cU9vH/QP5NhgiTmIReIi4yIhHVI?=
 =?us-ascii?Q?RDy1kuUlIOYst0HSalxWcGmiDJM8nL62lK9P4v7V5JfxjgzdJSOE/M7CMSLe?=
 =?us-ascii?Q?92+5IqfD0SJdlzeThRrb8fCT1ZIwvbOkaYrUtzVSitVMUNukV3msTWGizUO2?=
 =?us-ascii?Q?WuMNoKSGe2uI3o8v+4ruUGl7UaagMJruyjE7Z9wQq3u48GxJRKQPmSVdGYJS?=
 =?us-ascii?Q?vCrYTfhEpkpxNHOFey5NFwawst0+i62/td5Fslis3mXgD2LpY3S9gsCG/ZQn?=
 =?us-ascii?Q?SkzK2pQll4fFEG8xFykrK+GAkOMSYlt4mLEPyRB2LVg/tV+b3yrXO4KCVOZw?=
 =?us-ascii?Q?zvCerr8lQArpSjWGt+2n2CpI0SU2JZSr5sjG8SkRX7DfbBp5CVODqcw/uP5/?=
 =?us-ascii?Q?2lE2J11XBbc5mTGiwco8HewHB+f5iaVMYPHDkIkv0Rowce/zAgGbqWfm5rju?=
 =?us-ascii?Q?hjeekoh6qQz6ltF9InTCfEAaL0bKOlJAT7H4bMuHxLaIvK28XuaK8On8Go4q?=
 =?us-ascii?Q?/lTeI7O6Qxy1SnnBQ7a8melx6qGWrAp3Ath41bMGPKoC5C1bn6sC0V2349fd?=
 =?us-ascii?Q?Bv/i2U2zOWC3ay9WEHE8r0AlkuPs3Ew3uizCpC9brh3XBXb7KwYKVJ7VtAz2?=
 =?us-ascii?Q?NItLPfiONEdTFiWXpyOUgs6cEGwWYEkJrL/iQKTseTTssm/IewZxeCHzRHbi?=
 =?us-ascii?Q?bORJszp7QlDvvbhz9nDnDssTHBZfC+TQbWN5K7FJ72AJLAN386b66Sijmzij?=
 =?us-ascii?Q?iZ2DZpbMhxMOtJygH6bwbSXidinOz+WPd082AJDTjWK39pD+mNwxuabOLmBm?=
 =?us-ascii?Q?VTqA5StTSF3O/jmfKJwTo7Uc03FMaMhM5gH22Kts?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9d96ce-55e7-4f24-b854-08dc701ccb4e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 11:40:15.3923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3Rg6IQ6hXlq6qZdbXo1DZfjYxuf3qo2gidHhBm3uaZIE9xlt+cupXf9zXAbDQ7Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9143

On Wed, May 08, 2024 at 07:21:10PM -0700, Jerry Snitselaar wrote:
> > Should this be 'depends on KUNIT=y'
> > 
> > Seeing ld complain when building it on top of the rhel kernel. I'm grabbing a system
> > to verify that it happens with joerg's next branch as well.
>
> And I see you and Will are discussing it already. Ignore :)

Indeed, if you have a perspective what your distro would like please
share in that thread

Thanks,
Jason 
