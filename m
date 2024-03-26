Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2107.outbound.protection.outlook.com [40.107.92.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2876113D89D;
	Tue, 26 Mar 2024 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711491013; cv=fail; b=dAeMF5Ue9ElrTBFM/uBvDxT6Z8DgX3h+2SMfO2uQ/Hj2EOp3eXCFzSPDaJUMpAuHI/tPL/ZlN7qMAj4SD5SFz+MeRknsrmpjbPdq2Zkgx8IpVRL7haln5I+1KNR7XDHK6I+N+DKzuTrv31aWN8P+Xw+43yRU7Uw4mo9XpDyuJs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711491013; c=relaxed/simple;
	bh=X3AIBQDa8IUCQO79Vr8Y6a8plfhw8v12yU1lkLmdwvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kJ/2bUlokNHJud4PhoFNLeEa+j6/O7Yb9L9HGQchAlcQxQLduJGFIuOI3e0YAivv0y/udNDUeWLrMU0y73DevSBjy3dm194r4DWOS5wYx6ZZCpx+WhvyHmbGNeheJkgTMnnKzikEqhurnkYg7XlM6UX6KZrBuAM3Faxd43hWHJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BvRqqGmB; arc=fail smtp.client-ip=40.107.92.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BvRqqGmB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ei3i0B9m2l8HLny7/sor1VX4rT4MxItZEnkjsvWykmfqXZ2fiqxW+PqrvB6X87samYZXEIMyvTjt7z9kjaPsG5gH8wgKiZz5opTdMIfmgM/3Lf9jfNTDtwyLyp064luSiIRq+By1PfVUDMq7/YidlsVZtWkK68hJTAacDSz2Jg5jvp8ijEvu0JO7t87CHO4J5ilwJnCWKeZs73Q7YH0Dnbsxl6FB+gPy5jAQ0fXFiiap/COjU8VjNCnX7AF73XMDUwmw+hF8VqwAuI2giTe8JIkTm902BXPaBuwcPRMS7kXJrT58ys+xfyffRdn0EawxPo0tJW5ITVMr7ct5t2O23w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCAIDolwQkSAM1L+DEKERe3em5E79N6DswA0RmqRcO4=;
 b=BzKBzwEl5OxtSCbvusYC/J+j5GJmqTCpUIlLV6zb9bUx+2h10Oj+Xk9DqK2uGRCukg0R0wefXKQx0/xwUVrsdHz5+IkYMMkgLp7QeHqGIUqbw2OEw3TNoFdqmwB9Fnv0aiELoWL0lQN2Tw37XUFeA6eeoYeYVy70CKecNpE6+LDR7+qObPZrf1DFEOq1BPTcAAXP7l6BTarAYeR1ritLCqg9u90z3CiYKaqWlLSaCp/2wTvJJYaA/efePbpsxdC6dc0dfpxK09eKv5Q6L3rbO9b2a3MW2qyj8pb7f36qd8Uy1Hsj7H27+s2TEUkAwTNzOm4/Qtv6r6jwSVw977KzSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCAIDolwQkSAM1L+DEKERe3em5E79N6DswA0RmqRcO4=;
 b=BvRqqGmB3B6QaGP9fyocp8MRW8/NBViGKhhzdD6b6K8jF5Hie50DardhX47fDSyhLc9PaN0zEePWuGGa+La8gw6bOP1A1gbwUo35ji4PuBEn7C2AU+mSGf25QqIMAj5J+hxWqgBpvYdo3Gwf4lJzft30gacvi9gXy4jZHnGeFxgX4Wy0nj0gPFf5JzRkYY6iP3YggUbimXAM1Jyv3LqpwQmuumIs+6lWFvfRxhmyxFw2hAmEwMdi5Yr0Kq8aJDauv82uGwJHoERI+04o9d6zwWuBNBUQR77cG6OcKUxYRy5cTYrgFB8K1IKZnaB2Z4M+N59aM0eUBNoMWQFOhMglLw==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 22:10:08 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 22:10:08 +0000
Date: Tue, 26 Mar 2024 19:10:07 -0300
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
Message-ID: <20240326221007.GA946323@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf3EhA5ZBNwF2XOr@google.com>
 <20240326183016.GK6245@nvidia.com>
 <ZgMcqr6427vk8ei7@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZgMcqr6427vk8ei7@google.com>
X-ClientProxiedBy: MN2PR01CA0026.prod.exchangelabs.com (2603:10b6:208:10c::39)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4356:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zpy8SdoJQwKeq8a4UuTbIxu2QO8xHzIE9Qat9NizAG2ZUoQyRudiHnRk9C21abCrWjKjQouBfZzavvmNuNb5v0Am1H8ZQr4DcMHaBljYe9EwkrI74wnYi6Zq/RggiNf6gV+nX+5RNgAU5WCoxSeGKExMg/cUHoqtn/loOy+nxsUwUJFLdVEE4fQ2q3EEpgf0N5VDsufKVLG6KDHlSkaTXAUgayAr77iV7iBLE5eFR5Sp5wepEjKKknYi9l3zRDQEAg67arsJXdWUW8V7d893ewcCgIAIT45G2G/VyBZAUWP50NeQU8pUOErXfb37ansLtlTEgAfhdb+Qhq4MmhvYKHjEJ3Ota7+whAtPJ1QhNj3xvtUIOQdEFs1XjHde2E3QAT9k6lT9ZI6c9Dq40nimzKKoDCr3hkqMQ13oTHHL9pVlNE3uvsR1IAgTFErarevQG0JXTxxtr/nOX4tByejAgiM3TgiQGxndLGkzbpsdjagugi6cED+nkb7jgeVFYnSUX6Y/o4rrquJavCu3UfZfMP98FrzItzeGlFe0tW2JThLDzNvUCz2+ilLRWqvAuLQzVEstLdPOzjKcuDgIUvCoVV7p0idu5/jh4H5CeAilU0s6165YaGsNhEbVf2TR4y6m5CKHFOagqBXHuGg28Ole8kDkyDDECdIn/fxhi794VTk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?My9OV1E1MFkxTDh5QzBsNE9teGV3VTVteU45dWEwN2h4cjF1WlZnS1dYWWxV?=
 =?utf-8?B?aTNLWlludjczSElVcHpJSW41TFlrekNXV0xwVGJOcEpxWEpRaGQvbHVIRDJG?=
 =?utf-8?B?OWRMdTljdGxNUGN6YlNUYUNWbzN3V0xFSE1CcXFUTDBrdHZBUDNna2l2Y1VV?=
 =?utf-8?B?cURqN2hydEt6ckZVbWpHSkdrYURQUDVxRTlOU0xGaVRaY2tCVUN5SkJMQVlN?=
 =?utf-8?B?Mk8rQ0NTOEhRSmVQZ2RYZHlWa25hekQ0MndzTHA4TVd4ZGNaZjQ1eXRNVVFI?=
 =?utf-8?B?ek0xMzdkVm95cDFKTUhGZnRsM056ckpHSmpxS3NrMzJPeS9WMkQyN1dtSWsv?=
 =?utf-8?B?TzIzUC9EbFhEOHZ6WHFNWHFMWjVTL2M0OWNha25GTmRtNCt6c3ZnYkk0UWZi?=
 =?utf-8?B?RE9KRkFvOFI5YmV4UFJqVjJndExkV1A3RDZkOGVZc0hTeW5ucXZXdFQ3azlG?=
 =?utf-8?B?bktMMG55VEFoTVVUckloYzhDM0R6NHgzZTY2T205ajZleHQraFBBdEFCRHAy?=
 =?utf-8?B?cWpoU3NFU2FYanFjZjBZU3FkN1JzOVlKK1VtRkpmSVZiMWh1QjJvY2JFbmU1?=
 =?utf-8?B?elNpQVFQMHVGUkUyNnM1c1RoRFArVkRZRS9LM1MvR2VuMDM2cFR5dzZmZ20r?=
 =?utf-8?B?VDUwdTFPTW8wSDJHKy9hTkVhWkVBd2NOdzBHT2dBRjhZMXFYZ1E4dTh1Y0N4?=
 =?utf-8?B?ejdHcUlvelpjK3RMdnFTUU1vVWdTMnR3M0RKSUFSald0RXE2RnhVVGRXbUt5?=
 =?utf-8?B?L2Rnd0drVXpPZ2poeHNTR3lEaTdRcmdJdXEzSVJHVG5PZHZtQjdhbU9NMTcz?=
 =?utf-8?B?YU5ycmROZ3JuTmJIazVUVWc3YVZzQ3drVzNUakNCQ2tGaDFucFFUOTlYc0sw?=
 =?utf-8?B?dFBRR0Q5enBqYWpLdW8wcWZoWm5kOFVhQUVZRG52TTFzQWFtY0xwUXI5UDg4?=
 =?utf-8?B?QXpocXVqYkJGa1IzbVhsYmhrN0d0RzVkWFN5dGQvN25sZy9KWGo2WktTN0VR?=
 =?utf-8?B?dlhQMmxNZEo5WUlMTnNUQjhMNnVjc3FjQXpYdmYxQkgyUnN5QzFIakxEOUtr?=
 =?utf-8?B?MWNHNWFYU1J2TUFwaXdRcE5rdUFsUWlRTTM0TlI4VE9SWDN1aVd2ZGlRVS9L?=
 =?utf-8?B?VW5CbXVWVkxqQmNIeEpyN05xVXNGM0g2YWlYWVcwZDYwZ3B6dmdXd2dGRks5?=
 =?utf-8?B?dTZxRFU2ODFrNDVKcjNRWXFXVXZkU1FtSCtzWlAyczFKRGtvN2gzME9JWEpU?=
 =?utf-8?B?ZW9mK01jd0s2Sm1xNk1BeDNTOUlsRktvZC81V2Vhendab0tVRUZPbktmcEky?=
 =?utf-8?B?UzRod0J5Z1FFQk15VVc0bWpVeXFxVTc2ZG84cENjajExMkdCSmNOTEZ4YUtJ?=
 =?utf-8?B?aEZQRnBQbFFHVnQvSzNGSFNMOGZNVVM5djlZcHV6bUk2MC9lajN6T2UvZnlt?=
 =?utf-8?B?cGd1ZDhhVEFMYW1YOXdYVmY4dFFQU2tlZ21YQzI3Y1hCQ0J4Zk0wUm9GZHV3?=
 =?utf-8?B?RjBUQ3dNYlErK0pEQ3A0aVZKUUdJNitKalNWekJRdHBzcjZDeWYyZ3dYYTVk?=
 =?utf-8?B?SzZKTFJ3d2FoNUhxRCtZNW9zMWh0S1g5SG80ejhYRFVkVHFQeGRYOUwzM2Rw?=
 =?utf-8?B?cm5PSm9DZ3Q5aEpZV3lJYjFicDhRSHJKMGZuNkVLazArSFZ3OCswYk8rZCsw?=
 =?utf-8?B?bHpTcDk1dDIvMXNtdTY0aVdrS3hDeFErRzF5RlZnVDNmcklhZ1hOVHhLRURS?=
 =?utf-8?B?OWlncmNGU3Z3bEVyRDBPOFVZVEd6Wmx3azRMTTVjbjJaM1pnRENjVFh4TFps?=
 =?utf-8?B?NzEwY054WXZsR2hwV2RnSWpSN1dLU0tLeHhJVkxQVFcyZU8rdHBXRllBVEow?=
 =?utf-8?B?c2FDeFVERTZKRithMDRuaTlKTUdhSW5kN3BlL1lxOTJ3clBEWi9wMzQ4L05O?=
 =?utf-8?B?ZklSRnB6cWd2Ri95NzVrbGxRb1NEamxZMEtUZmQ3dVZ4VmdBNER1TkVnRk1q?=
 =?utf-8?B?YUhVR0MxWkpHVG9GWlk2MUdURVE2RGFQM0RkYytUR1ZmZTNTWEJMc1B3S1dP?=
 =?utf-8?B?ZUVZVi8vbjBMdTcyQ24rSXJtRWJOV3MrMEdTUWY0OFFiVUkxeUJQM1U3cXNs?=
 =?utf-8?Q?IagnMedRpW+Tshei6pRI+SX/I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca9cab0-69e8-4ba8-a3c6-08dc4de17faa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 22:10:08.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwS6oPx2/qCDdWFB5J+Nk09YRWONYh+F0wolXFs7rEr9t51n0Ih7Su16Ua32Z7f6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4356

On Tue, Mar 26, 2024 at 07:06:18PM +0000, Mostafa Saleh wrote:
> On Tue, Mar 26, 2024 at 03:30:16PM -0300, Jason Gunthorpe wrote:
> > On Fri, Mar 22, 2024 at 05:48:52PM +0000, Mostafa Saleh wrote:
> > > Hi Jason,
> > > 
> > > On Mon, Mar 04, 2024 at 07:43:49PM -0400, Jason Gunthorpe wrote:
> > > > The SVA code is wired to assume that the SVA is programmed onto the
> > > > mm->pasid. The current core code always does this, so it is fine.
> > > > 
> > > > Add a check for clarity.
> > > > 
> > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > ---
> > > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > > index 2610e82c0ecd0d..347c2fdd865c1a 100644
> > > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > > @@ -581,6 +581,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> > > >  	int ret = 0;
> > > >  	struct mm_struct *mm = domain->mm;
> > > >  
> > > > +	if (mm_get_enqcmd_pasid(mm) != id)
> > > > +		return -EINVAL;
> > > > +
> > > I am not sure if that is needed, the only caller in the tree is the IOMMU code
> > > and it does the right thing, as that check is removed later anyway, I don’t
> > > think this patch adds much.
> > 
> > It really should be backported, when we get drivers that do other
> > things it creates a hazard. I've added a fixes line.
> 
> Maybe I am misunderstanding the case, but AFAIU, the only caller for this is
> iommu_sva_bind_device() which is the function populating the pasid, so this
> condition should never hit with the current code.

Yes, but iommufd is going to break this soon.

> And Linux won’t backport new drivers, so there is no need to do that?

Heh, you never know what -stable will backport and the distros are
quite a bit more lax. Seems nicer to fail quickly than get all
corrupted.

Jason
