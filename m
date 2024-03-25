Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ABE1586D3;
	Mon, 25 Mar 2024 14:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711377309; cv=fail; b=Tdgz8d6WRW1ak0byWhvUg5Z/ZEImMOs4L0JTkv2qaZRI5Yo9tcHVHmOZIjyz4mJIAGwbiTOOKz8ChMf4MLAqWTAvXJJjsPu9Pjl+twLQu/zaazw5L2A2E7JTivT/a07oO3gFMWKn1JdxAvFHQQeElOHg4UC3hwwO5L4umR8W9Fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711377309; c=relaxed/simple;
	bh=2EozqDoSSjDOEtwMhKT1P0kh7r4TofXHpsKr13sxYJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=japgPgdHT9z+TsUa74ouIrUPo2+Z3vKVeHJtCuv/tAW7GSN2a7C7TrMIyJUUmDzDNOrdfkjCDto1RV6vUJRyX1EAmcBzVA9M6eCTdjj77tXZYtw2G3/7lvF7d6ZhB33wRF4m8q8hZM046YSTnkrLOjwA4qzlgiRyF1MXxHLJtDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I84pieBx; arc=fail smtp.client-ip=40.107.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I84pieBx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP6kqLRzb9FZC3Iew7BGp0FZkaV9SCuPUQilZxlUuSv761iibWEEWthCwyaU+tsH5l6kYYHc8ZsSpySdcuaKM8wh84yFRZ07yiwB8zjCqAdmV0E/0zCSWFIR+X1rpYaz3954cc/rCl7DWQS20JmBfDJARiku0M9uUZevYaAE2Waof9wYpb/hYFDZVto4s8+cGHa+d9y0EBPx6qXaC95dUQGu1nY8BCtTd97rSknS/2H8LbVgbYPUSiKcFEo8RsSSEf1Yt+8PAK8dBP2nUrcr79wUIZmSunLs9KjY4LlTaFBJVOp65Z3wf2ove4nUcuU7pXFWP3Ji8HwsVL9SinRF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZ4CZrbiuZbStbUJr7tchfzKRM01AQ9Vy/cVyDkcqH0=;
 b=FvBNOEQa3ttEWWJWm4d13+UdtKALohbh0u2L4hZhfpPlvLu115Tjg4pyOV0erd5nIVcfC5gZMvBtznWp3Hjkz2qJx6teYQeXeiLFYqPStYNsd9F4z39xla5V7eQcuysNbTwn5KFiZU7Uv+dmsL6gKTopGQLR7G+HOtWTzrsO4d+PP3HVM0jnwDYxp205dXfMnSiIRvAvT3RQA4/qLngATxI8J7qDqRISewHxjRfhS1qfubA40IfmIP1yp/EVt7BScW3F/qQnPDhSH0xn5Baiq3lE9jCy6xdGvS8ZSxR1kybCvhAk1OnY1Zpz11UFkUB9WBpejNDzXEYKmNtSCvZOQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZ4CZrbiuZbStbUJr7tchfzKRM01AQ9Vy/cVyDkcqH0=;
 b=I84pieBxD+AtC4NskYA6haTwV6Q+avbABqF0pZjv4VZBR+CB9X5WrB2NMpLP67XNk7gfvlqAKJbhjOq7PB90G4g28xv6jaahKk4Qkbp30PNPFHIZpQoW2kzJ6gUw9czdOTMqQScpHwmYrvw770T/5j1hK/qmGurrT4DQQnhcbBxo6sm3Ih9TO7vf4FQy25YyF+0L6kNQJe6fNzyVsptopHR5Ngct2AbT+qH5043Ik2jmjCUfrrN12ha1Qw6l3by+DVpzhvC+9HcIt5mJsTCvNuA1TdJIwZ/hbgujLUMjgATT4dZ2vGxoUxOad0+MoDKPmHfjZ+KLG3xJ5+ZAEBQ33w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB8452.namprd12.prod.outlook.com (2603:10b6:8:184::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 14:35:05 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 14:35:05 +0000
Date: Mon, 25 Mar 2024 11:35:03 -0300
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
Subject: Re: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Message-ID: <20240325143503.GF110546@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7bPOtRg9tLSOKT@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf7bPOtRg9tLSOKT@google.com>
X-ClientProxiedBy: MN2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:208:234::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: 0efb370f-d563-4fdd-4ec5-08dc4cd8c317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r5vkSC80oBx+C0GvFOK2wcLFLUJUl+Jcz8+H7PXvrnyeFXf36PTxtjWvMoF0A1OXbYc/xunBcLRoMb1hduvPcUJzmwDUcik7dnwRCYycaF9BN/c7BNPOKqRewJZHROX26tN+vidQaVKy789bEQfCCzjxnzk7OBWVxblmwSf6uIhmqT3WY8gTbJ+2Jfb/3McMpYm6IquBHArit5zMJxhcKiHF1M/256DONCeAYuUxPX3+G2KDKWjVeVhS9laGUoQ5R/JrLSZedZxaq6d1b/Vq4fGMxEWzt5zFigsf+mtQuwdbZdok4kzJdxk5v05lGCIPAv84CKULf0/wtmLuFnbhImLu9AIF73kCtYZvOctcCS3K7eGVTy4ebXGlRDWc9MksUs11obAkzHOxU9D7MgwvSLifX0WDd0EaHFOHzjO/bJIVHsLaDGoZboS6ZHv8BYS8WDs5wCj8D04mnrzoVlX+bjqjiIWSZAlw/fJa9LVc+ZFJc1DReAd1IyZBeyJwiuHm2vpSPHo8hDLUOsq5nXIxcB0KbzaBJJL6MnvOuDUHQf4Z9/MtXZUxOsjqsE3ljItK1cV8ENazSDDhxqDZ79vadrLroYhkD5yKX+McAQThXvtUw8THhEaZpL1lbt7dfJlbLKLGnf1OUzK0slooe+wLuY43ftiz/X7smmVOn6mfBnA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HH/9Ii2pWSGffWL/sblZqaWKHReVkGdD5mbQYfjRcgBhYG6f5fjdgzVN004q?=
 =?us-ascii?Q?eyyvRv/K8bKlj88HSTkir0AAVq5X4WJCt1rjuoJo0Htv7woJBdsKQPPpuGQx?=
 =?us-ascii?Q?OuxYltjnDLbuzQOUPJyy1awnVHPRmx2lid6/Yl804TVc35buBKNgo6DAcwko?=
 =?us-ascii?Q?h15EtlVCNZuoShAahfFdSDgjn2kxMvxjgy4A16QVRYDUQ4SINcgpcOLZRU92?=
 =?us-ascii?Q?KULPJjKjreOLkQgzqaPtXR/DYRGeM3cj6fNwAx+Sfk9StRyc5msRq021cIJ0?=
 =?us-ascii?Q?G5X5LlFCSPD3WTQlXYUDlcPkLAvzlJgLiVCv8q6RNpC7CCigJXu2W3UdikYp?=
 =?us-ascii?Q?uy2RclM+jrTs5JcDo84tBKCD+XY2owCHg+s6Dk82XcRu8ybMpdIW9fPKh4vW?=
 =?us-ascii?Q?bOhaSwWPq2jOpSUPmPOL6qfZSIG8b03utr//uE5GB6aabqxSBfBkje/Stvbs?=
 =?us-ascii?Q?rB3wSyG+gD0tEcxqmBr3MNiBEtCzxZs5RUkrD6czg9twKNw+uKmc4K4wouqC?=
 =?us-ascii?Q?qdeTOPoKEEaaUKEkc+8bkw8BP0YJ3VRrPm2skgZe77CAAHBinUaIa+0a60Tu?=
 =?us-ascii?Q?UaGbBkpxH9jBFGrbUPoqjK8GllQbSCveKdwsSerbZi5wHWV1PVM2nkgW7YM6?=
 =?us-ascii?Q?iDaD/ivjVt7INQ4qFhKqF4Q1tWqpRMVBVZlMS0hfA9a6TnEIoRiLILYgLI1S?=
 =?us-ascii?Q?s5GrxPJ4t3zH7K5+tXF9+gEFj4TEncvPkXz9BuOgc4e6w1HlaL4y/y9ReYNm?=
 =?us-ascii?Q?IajSm4b8KNgtGiJ02rK1Ju0FcqyPAsU3f2r48+U+rViRWju3lrWTYNqTs2GQ?=
 =?us-ascii?Q?zYjftwZByH5rWjn74J/aOlF4enQLFms+Wc+/vjGbISYqRPVDmuFcVqIseyPl?=
 =?us-ascii?Q?z6S3ZDE7nsvhdXhI7HbGzpz7QiOOULIzH70SaVTgAnnGoW5l/Vx8W3+Ps+sv?=
 =?us-ascii?Q?PK3CKXDweStYSYHm96G/FMUYMWFnMHyHtkcLC3qRITCmm7k6J7qHuz1ps2fg?=
 =?us-ascii?Q?dOCY7MmH1CjYyGJNQcH4LaEeH5ZTp0dpcSjbU5FsO1rQ0oBSvG5lTBkpl8XV?=
 =?us-ascii?Q?VuNlDB7eSrQRqCGufsxM4atSomWP9ELYQHTy62XdgB6IBMpybTnK3LWEnvLT?=
 =?us-ascii?Q?F0twHl7Tz0e264L5x82EzohsaxfIww4XtYjIkzU9DM0j22Sf0QojmeYKU5ag?=
 =?us-ascii?Q?JYzMSwvZ1JCkdSKZNvXV28ifK2cmO9vHrEeyfOU9GY7/zmOpg5ImCCkOAn2j?=
 =?us-ascii?Q?6Ox9PiRr4PjQHQhirPReWgyKjTKiBQ1qJSF88c2v1aLxYGaOY773vGHqrECj?=
 =?us-ascii?Q?ty8Aql6EIr3yJHVy4Fngn7MTCc7lkHvwOPk/e2RFma2VCYn7Vdz1VF4hPP54?=
 =?us-ascii?Q?QVuP7KED62UBEGfbBagvRk5inrUNhVrxn5iA+t1tisAJuA1p8OhcabyvpMw4?=
 =?us-ascii?Q?hiitSisUbo7D5GINKiiwAV5uCQ4reruRy0kyU2J3g9pRY6XbQUgEoVF1IA+2?=
 =?us-ascii?Q?UKzl/CCmcKJ5rk3y8fwPqqjoUrcR/QgPtqKMOwIjJ4e5kJn+wNjiokyC4o5M?=
 =?us-ascii?Q?o8X4MueG4aqW1qOkxGiBuC2Etw9vzyOj6jWFLfV3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efb370f-d563-4fdd-4ec5-08dc4cd8c317
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 14:35:05.0915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glHgObDwV8KFHFiOSd+hhZAkWvzloT03V+ptv4tLyID3p8LlD+MV67p+bmGQY5PL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8452

On Sat, Mar 23, 2024 at 01:38:04PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Mon, Mar 04, 2024 at 07:43:48PM -0400, Jason Gunthorpe wrote:
> > Continuing the work of part 1 this focuses on the CD, PASID and SVA
> > components:
> > 
> >  - attach_dev failure does not change the HW configuration.
> > 
> >  - Full PASID API support including:
> >     - S1/SVA domains attached to PASIDs
> 
> I am still going through the series, but I see at the end the main SMMUv3
> driver has set_dev_pasid operation, are there any in-tree drivers that
> use that? (and how can I test it).

Not yet, but some will be coming. Currently only Intel driver supports
it, but Intel HW has other problems making it unusable..

A big part of the effort here is to enable the platform ecosystem so
devices and drivers can use it.  Moritz has access to a device that
can exercise this, though we are still working on it.

> >     - IDENTITY/BLOCKED/S1 attached to RID
> >     - Change of the RID domain while PASIDs are attached
> > 
> >  - Streamlined SVA support using the core infrastructure
> > 
> >  - Hitless, whenever possible, change between two domains
> 
> Can you please clarify what cases are expected to be hitless?
> From what I see if ASID and TTB0 changes that would break the CD.

Right. For CD it is only the SVA mm release flow, setting EPD0.

Jason
