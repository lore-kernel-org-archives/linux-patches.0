Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AAB839F9;
	Wed, 21 Feb 2024 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708535215; cv=fail; b=VpeXXNnIRz37rmNs6NpS3yuHuw+JYTo+ud1H2W39VvLHf9DpgH8uXBr8mEH0hgt6oMDwYtr0NdL1jkGDSYo61BMlpBdDqyiZ+Z8NXBysewIu9Z3KVnCeHki8q/xQX3R7HLTle6JyW6lPYzQkmzsnhygkmHTk7abrvQyrM8R7mrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708535215; c=relaxed/simple;
	bh=YCVqAp6xE/kYNCXhv9GrD7UTqSDRcNpQ0CzW50CIVAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tm1ebHTWksmQvkRmXT2rqXTuWw/uEZfBSddTniJTB33x6pwIgF67n9/Es895aqY7ToM7GsHqdMaAK+8YguoMZhiamP6Lo29IVI2AQh/4GtWkvkXlR4iyzgvaLpscB8gjpvIPp+ZIXVpwYOxVb5KpMlPUQmE6u8q1WCjxGqH4c9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KyXseVeo; arc=fail smtp.client-ip=40.107.95.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KyXseVeo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApUYYTchEdljdR2wKNfPLp1Nrnv+KIGqliAF73N4cQIMpQLee8D4km4Q3IxAW1X31zH4jpD1gNOf5JG4pyHrDWirO7Loas08b4yWFG7fGLzg7icyZbmlZEjkVN9lbuAZEhX82YlTD03T+qWzEqrG1S+najKkWuWocg85w/vz2A6x/Uerq323+lcExVMsJlLDBqeS77p6TOLRoVSC/AQXYtvme1klYbEhHGfu3nTdd1PXhGuRg/dLt1BV0i9PHJfazIfo0LoAgbiy7aBVX0Ycet0/m8tefBugxcaDOcQ+Tyf2VRiy5x4ug2FyKl0EQYSn2/hCiFOI7q5EkSyxNHq+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gvR0iughaKPbifpQgkz9ZEG/s0q9O9mUi1J6jeOuBdE=;
 b=OtSdoCGj7kJ5MoKh4ktPj/ucSWzhnzvQJZrmKJq2kUt7pafm17HkGKLlXhyiGV/14NgF3ohea+xoXDkEZQMv4ccWtlqcfVPahHYMWXXn4n2bpiZWRkgUa9s156TyPxRgE0ne9ZU1KSqYCDw7ONQNT9F0KqoSL7MWbxeDWgdqSqjkbGNRIN/r6xl5QslSVhDDNGwQM8bzYOt4B3thOEYPAALNIH6dRMklYm4N9ZpByYeRp5SbjuZULtFWeZWow3eH/Zpgf2oXsR4guiPNjeQqxZBSLagAjTxsOk3UlBIapH4KlkxzLonoM84FLnyzCQMG+YpaJU4Fad+ul2cgut91Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvR0iughaKPbifpQgkz9ZEG/s0q9O9mUi1J6jeOuBdE=;
 b=KyXseVeoEjjr0xud0VNrCpYjvWzP+oGdxd8Z9dg0YTb7Y2aoslZ9ieIQiCSGIZSX9tDNaN28Ka/ckaKQZV4egBS+NbMkap5HDOYsy27JL29lBQiAZm3flx7G7t/pX12uOyslED1gq3ARV0pDG+DAF8u125LOMk5F6motwqr4EU+DdB3mdtKbHg1QiKO3I0MFb75XNh5Qzx5IvxnB5O2e0cF5UuDhF2CBIguBw3DvllduRhO1RR6S4LzgYBlEMa2rMfl3oqlPj+/cUaZxe6wjaPUFr2cLTxLs+ETgug6PXWEV4mnvmkK/3AyWLh/OJ2WeYxhOrDQJTcZb5qeo+I4+tw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8829.namprd12.prod.outlook.com (2603:10b6:a03:4d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 17:06:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Wed, 21 Feb 2024
 17:06:47 +0000
Date: Wed, 21 Feb 2024 13:06:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240221170646.GX13330@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <20240221134923.GA7362@willie-the-truck>
 <20240221140818.GA2635804@nvidia.com>
 <CAKHBV25XrwOXyrYkjLZ7=5sNoFsM8VPS=HaJupswu6QDZ02LcQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV25XrwOXyrYkjLZ7=5sNoFsM8VPS=HaJupswu6QDZ02LcQ@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:208:329::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8829:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c355c5-ff58-4f0f-cb6a-08dc32ff7cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eqB/s023KhClPu0fegR98RjNCLMhUgHnfw2ijLk2OOvDnRRWrivyIKv83/KxLtDTaMxceMZ1GQhSLqVwgMwG0UQrBqlzxmTMnOGpzMd75qDdzbrwXIPpgv8lbSzaEXLpMHliSRm3hZoyQL858FaCrxyysp0QOzHM3DcyiO3htAUDsHW37msy2MujuuK60vnLh3QFfx/eUbmO4l03HOAa6zE+prZukrHGQEjpepPe5FDncqQyP326GnwIMU2eeeElUyTFbDxV7YIXG0HlHTYpo11n+dKnA0ZM903WDJ8btN7AjnMHCPJog72+iai/x9QFyad6GlV/6m3JtB801Ufzx4A+QTN1LVOwF/SbCCCyyf0L61oljxEGfaryf4ByMbu8BL4MUxh8u5hR+fGfD6rjHD1yi/aVkEBTB7QOcnWBca3aUvEcAqtRqRrzd1nOhtHBvhloxMa2G0f0flhARUAt+dpakljPWnhAOoVMO//buuoZxVRtqbTvQ4ITLKCun3EGXnb93jRKPob0NfqR6DjNOa2DexzHXN+YZciMD7ltzE4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wu3OwkS0OIgugBFAf8UZBZSt7Xx65b4wHJAxV+pqF1vdqW/vVHIHY0sUkFAW?=
 =?us-ascii?Q?coqkANOpCDvBz8cQ9NEuAOnhutkbv+/QSRKyfLngZvoYDH57n+KWTPFRzw4N?=
 =?us-ascii?Q?kePQbjXEeMf+NNaX7IuJm2+xeXz4hW4pjbzN3dq6sfUqBJAIwhRsYUnLTL0F?=
 =?us-ascii?Q?ydT/RA3eWzxHJiEjE0QCZ1SJwon/oUzHRy2MjhMYQBfJVyyPjs52B4fYVq6f?=
 =?us-ascii?Q?fIHiAlzPtsbZ+49AhzwH5wqS3kKYChdTQ8UJjTT71MAHcWvpz+MkVcA6mCE1?=
 =?us-ascii?Q?djDVGCtkWacIA+P7JTOUZMz1Wqdo381AbjJ+UxADE6FHTOreZl5EpWH/wcA/?=
 =?us-ascii?Q?ZWPQ82E/BoMI6H1/+ohVkFj7oxkcTWPZcqFlQjng9AuEsv50UgDTKWkTImNE?=
 =?us-ascii?Q?IxudfG5+VDKISP7SNlEwRo2g9vPHlLX//vBwmUxeQpYWugEN6XU7K/4i9hCZ?=
 =?us-ascii?Q?O+4bFAWUf+TLj926kIeLBSunYmb4IG+m+U29SE+rP6m6li1PACd10CoYKQGe?=
 =?us-ascii?Q?gYq92c65qny8Yg0MXUq4c581LlgiQqC4mdaJ6/08f7rGP3xwpCUM7ndpDeEk?=
 =?us-ascii?Q?/ADZPd4+KB90Zoy3EX4jCnQlASHbKXljg816GqAqK61whLUVho/HvdhEDj6M?=
 =?us-ascii?Q?/lfQUFCAHM2qVR7SbQKU6QdwYw6Cw/G6zL0jMPWWji/EoRoF3oVQa/ybaknZ?=
 =?us-ascii?Q?w6vMvK3sm/Do/sbTMzsrGl5YRS8H7ed/FypDam/2K4PUMzJV78+NJGR3t+dL?=
 =?us-ascii?Q?RTu59yZQssr/UMFg6Z9SoOCHuSeBIv43BApeGEszERIlgyL2dy70cKdpkv4j?=
 =?us-ascii?Q?FAvDUeV2ktfos20GaNMo1L60TXR+GNL7kqay+nIwr6rw9wVGEiKymQSUKrdP?=
 =?us-ascii?Q?KM+KKl9VN/FLWEGtn/7WV1bC8OPQc/vT4su2+9RWylBONIRPiZEo4D2o3f98?=
 =?us-ascii?Q?MW8jdbFi+gqgSjuUDVINqHA4EHEedOEKH6aSDqvzaTv4ijZbnrzGTATfoR4A?=
 =?us-ascii?Q?+WFtwVI5ELHqEfXoH2zDbwczUyDjME2OrcX4Iwih+OJuJOe+Bdk8sfjU/GXv?=
 =?us-ascii?Q?cp31g6icd/qJZVWrPYkqV1DW4xPlVPHIfQqXFdKBa7vskMOeyXMEgCPKbM4g?=
 =?us-ascii?Q?urwmOgR259sBlLfMvaeHKm0s6TTv/YCpwecQ87fO6QvdQd2oxLaiy5h/rzmO?=
 =?us-ascii?Q?BSWGGz1yosp+gbhsBbV1JxU6+AELnrD5q7hG77LvNXjBsN5g/dQe1gK4ysqh?=
 =?us-ascii?Q?KyejcIQjtd224Im5PwdqwKoLMadhw4ZR36bHTpbAlT5U4iuLhOntBRCQMBPN?=
 =?us-ascii?Q?2sPKjQcK6Bf1xhCI1DDScSnAn9t6wHgB3UT95uJGBvlCiFivKSTwGN0t6PQx?=
 =?us-ascii?Q?QzSmf9lRrAJ5IPXngbVV1IqLA+1qknSNWv0u4j9Z79eHz25hIAxxUV+JziNo?=
 =?us-ascii?Q?aQ/gJFBUUH0T7sdcjusn0TfpIiq6Uv4mgeHgEGMKKs6FVVRjztMYrHPDpgXI?=
 =?us-ascii?Q?j3YyWzv/DKXNLJoQf1ErAr/nakTYXS649AHJGqUqy6UhjKfs9FInzpzpNp25?=
 =?us-ascii?Q?/okf1uNrFAQnSnDVBqOGVeHd1voqNuD0ylvJuwVq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c355c5-ff58-4f0f-cb6a-08dc32ff7cb7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 17:06:47.1390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1HQan61wMfbZ++t3tcBVGwH6a+tXhYmNe0rBrW1ZiNs0Ic3PKHlrG1iHB//j+sz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8829

On Thu, Feb 22, 2024 at 12:19:06AM +0800, Michael Shavit wrote:
> I think the simplification here is in the first if branch of
> arm_smmu_write_ste. With Will's proposal, we only perform a hitless
> update if there's a single used qword that needs updating.

The normal cases like BYPASS -> S1 still require updating QW[1,2]
before updating QW[0], and the reverse as well. That still needs the
three entry_set()'s to process the same way. 

From what I can see if we did 1 bit per qw:

 - get_used becomes harder to explain but shorter (we ignore the used
   qw 1 for bypass/abort)
 - arm_smmu_entry_qword_diff becomes a bit simpler, less bitwise logic,
   no unused_update
 - arm_smmu_write_entry() has the same logic but unused_update is
   replaced by target
 - We have to hack something to make SHCFG=1 - change the make
   functions or have arm_smmu_write_ste() force SHCFG=1
 - We have to write a seperate programming logic for CD -
   always do V=0/1 for normal updates, and a special EPD0 flow.

All doable, but I don't see the benefit in aggregate..

Jason
