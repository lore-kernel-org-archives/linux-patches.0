Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013020.outbound.protection.outlook.com [40.93.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C582A1B2;
	Tue,  7 Apr 2026 01:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775525201; cv=fail; b=bFqp0l0l8Vj9M/WPyShKDsyYWBqdK2tY/0tqnhQD7vmyA+sAuWzmbmBDrBCYnY0moe0SaqLE4j13Nm4o6EjQylIYwMsP85nwjTu+tYcTsHl4g79MlF76qmdDXQdVuN0LVC3yweGrBwrRfGGMUbuRyaddbkYYeI6Pa6ZJI8/pHBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775525201; c=relaxed/simple;
	bh=LY8O5QHN87gJs8lTwMCb6m31OnYg29Ssbcxjk7DPRkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=adHaBONZSAXBSWQ1n8HgJnQnj5RGq9/ol/toutlnaDG9OrWKMNjFZpq89jZkPuSIZ/PkLSWiosJh+yL0hhus1Z4v37Z3TZgh5ZITL2XgnqgsoPUlxnnJbrjc72FwBc+rbP/zMIl6CWBq/EcbsWXDHm/V1DDPRE2IKK5OOW7yLK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dKIihNeU; arc=fail smtp.client-ip=40.93.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dKIihNeU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VXIOe25Tezv4dHca0Mc6k91xm5uDmMMJ1L4R64wDZib3dQ/24a9eIV8VNEbtpGIA7mrea0MCBdRhQRf1uGTZywLKqUJDQyG9yZ0SAb7CRl7LkCSZTTSXYT9Dm90KGrA0cbq9Ztjqp70H2wsAL5zAqYtwMQJVqt8bE7ZW89r+hRgOC9kjSVBpYTBiDxfGXU2rKTjJJjgyCJ/lzj2G9HmvRqoRN2jNR2RYHiocvhyWXykpgu1jtxC6cmMfmZCS0FfDZqvubPPBYCYxwQHqq5kuYif3k8cKCepybkng31LYzFfvUcHiHzD12jP7nIWmBGYKspV3hgoYg9HdvQwJuQ9OMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVXAMvD9jEn0GDEwsvUfvKBsV6EwhDPpgUknbaoisf4=;
 b=MezLwZ8qHaP8vfo0oP25FbKYHOEwfZDJ2eDWqud5wqQGBbriGAstaL6YZCoiaBub79s3viv8AoLrhyHwdbOTxeuocFs4AQUHH+EXzs+HCA38ZIfczE4PZLz2brTa2ubp4Z1Ogz1Lq5s8N+TyJ6ap9Rc7Dro7liyYKv1MoNTKmoDhMzdCyAgtdaU/xJNqPfk9AJT71rY/zw5HAENmhDI/rXCoBmj3Z9MB1KqJMr6j+FJ/kraTJh5nf8a7QC61iQ4Ahoyx6owBNHPTd6GG4XUO/FeokLz1NJOD3MMFZhgB2MKjjC/rgdp8wadNKI1BOCPnioNbm4GaHJS9Z7CUrFSUDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVXAMvD9jEn0GDEwsvUfvKBsV6EwhDPpgUknbaoisf4=;
 b=dKIihNeUfS5czjZJAzut80PuTZafEzi/Glbv9VDIKeRZlEGHmTdL8MFHTjqafW7i2fvGyR9m+yEJGLzETWdlZ76WwsudxYAeYmJsopx0mGuSSTgbZXbgch834TtCPnlyS3thtxGA9GRhs0QhefaIiVkgs1fvoDBtdO0vjfF/ms89zpnR2vHyXJhVpkV0RTDpF5EP8rI5x28oHBmg8R8eFAk6HIWVJQrw58Ibmz9ETsxw6cfF5o46Srp8LDZCHeXAEYYpnm8V6jruunIDv2XU4Lml4DDpBVUqcV8/BgSwugQ4duoCheXdmaU/w5q1DhDvqCIqjxZPL5MKZJkWHrOxrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PPFDA9B3771F.namprd12.prod.outlook.com (2603:10b6:61f:fc00::626) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Tue, 7 Apr
 2026 01:26:35 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.017; Tue, 7 Apr 2026
 01:26:34 +0000
Date: Mon, 6 Apr 2026 22:26:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Wei Wang <wei.w.wang@hotmail.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 1/5] iommu/amd: Simplify build_inv_address()
Message-ID: <20260407012633.GA3357077@nvidia.com>
References: <1-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
 <SI2PR01MB4393C1FF5BDB413E68BD018EDC5DA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
 <20260406133047.GM310919@nvidia.com>
 <SI2PR01MB439366DBDB7EB03CC3729C03DC5AA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SI2PR01MB439366DBDB7EB03CC3729C03DC5AA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: YT4PR01CA0185.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PPFDA9B3771F:EE_
X-MS-Office365-Filtering-Correlation-Id: b8dc0989-1d08-47ca-1849-08de9444b4e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|3613699012|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wexegoGsIxIleZdaN8KZN6Im+CPxZsO+u9/dKeSQVBRIn3MXqC9Qa41asg45HH+iRaFMjY+goZ+E12PulQnkLNkpCv0PVc93dOGcKhI3auJgVUflOl30f1a21IiZZOno8PMZVz2XB8TMzz+y/bfalpaNNed/81DHixYJL+9OUnFvKKeAR1Sv0IZILBKcC9l2TTFUTwGdfBeUIJUF5rp8OTIstP1jpThKciv7FkVOmRv5vl12n+RsINMnWBEJ8Ru6s/Fg1yJ70cmU30Mz3Q+x73EGsX2oF/s7zytr8Y5y7sgTTRUnx1gpsnqkEt2K9LUBtv6HSmtrICq4NK7K6VBM14KrEkwEWI5yVMp6mxnQVoO7T2FwcJhVN6BHpYGsYTGZFcugU2S/w7oFOMzgshUKd3t7Y7tPC72dN1Pw6CR/dJ2g9VpaJ43zk8CfojZR587xuVptFaqjDZFpAvU4BYoHu3OrhIJa2EQmBBqqvqVL8noBUg1rTZcwr/wXA579mVcRG0qTWy+ZEZsKxpbQ5i+ntjhEnWJzs7DTytAmxfuI96/aXgraQvXMBVXG2jbLiyslWJXzFDfWxrABloWtdSwlDv0a8Niw+NGHt4ARt+PFVyoeCNqHUo8dMxuVrxJEWTjxibljYaAtLxgzsCKM9yEODYhWwrtbjbyUTzNeFAg8KmLYhCrOPRudpQcbua+BuCBfyXJ7q71+D4ZwTuK068/uLSBg4nO7mRI68A50ssmUvIA8qkpx2x4VKx483USeH8aX9m65EVp5SNBETEWiW4Fs8gv7DwaNBkPIsYqwNIww6pw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3613699012)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M25BT05EWnFyd0M2U0FkVnFxOUVCVkZMUFlBVmttRXByVmVIWU92VXNRU3VP?=
 =?utf-8?B?aFpkR3FGZWhYeER4Vmdza0JkMUZ3d0FJaWRMekt2NXRienNaZ3RIaXZ0bXFq?=
 =?utf-8?B?c0dzNWxocCs4bE05ZjJrcmJxOTJqcXRKaFhpTkpjQTkvK1EyZ0JjRzc5MWtH?=
 =?utf-8?B?NDdiNlgraE5NejFFQ0xBakFDQXhJQVNBQ3FTdEtRMWEvdXRSLzVoblk0TXhD?=
 =?utf-8?B?Z0lseWJzN0gzQ0JQOFJJcHdZZHRHcG5Za1ltQVZCbWJGK2JpVy95Yit0bFBN?=
 =?utf-8?B?QXRMT2pFVGUyMU5FcWRIUFBtdjhFU3dZemZsMSs5Z1lzMFAxMnZQdFVQeXBw?=
 =?utf-8?B?SmtvNmNHbngvOFlBSEtBNlF5TDNWdm11SFkwSmV0aUNVWWtqWnJtV3BJM2Rq?=
 =?utf-8?B?akVEQm5ScjlicElzZFZrQWpZYTF2ajd4ZlB5ZnhaVHluWHppWHNxU05RWDll?=
 =?utf-8?B?b1I1S0c4Rm1mSjJjVllBQzU3Tjh5MWJOUmFQWkwvZlI0QVlwYUoweHhOUTAx?=
 =?utf-8?B?TDB0WFRCMHhVNjNIdU05Tk9EWVhPN1h0S1QreUJTWEh0enpSalRaUnNNVXZm?=
 =?utf-8?B?TmpsbDFDVDR5S3pEZXVjZ3prSXBRSWFYUWlNU29ta2pCd1RoMUZiUnJudUVS?=
 =?utf-8?B?WjM1dDNYZmdoc1JzY1NXdTc3SSt5VGhWSHRzeHVCY05XQktTNVYwdlhReHBr?=
 =?utf-8?B?ZWlOcjlGVVh4VkR2Rms0SEZEeGwvRFZwK1FvVHl0L3hZSGYxdkhJME1kVmxG?=
 =?utf-8?B?a21TSUtKNkRkZWFuaFRaci9iWkwyOE81SDZ1N2U2UUhPa3R3bW95ZnVaM3R0?=
 =?utf-8?B?STBleXJQU2VoaUhMbW9PYSt0WUluekxsUjJWWjBQMFZwWlV6WWFaY0IyakZY?=
 =?utf-8?B?UVcxWnpmSDVjcjFpVkhkTngyYkVTb0g0Qm1LREJ0Njh1cXcrdWZHMXVFTE9I?=
 =?utf-8?B?T2RBN2ptbnN5ZEJFeTJ6OHZXV0xLbTVVbXlYZy9aUjFHa1RPN1dqeThDNFRI?=
 =?utf-8?B?R0kzTmtQamp1RXB3cGNmL2grQTVjV281WWt1RytuWTV3VUZlS2Z2SHFXbUIv?=
 =?utf-8?B?dWozNzdIMHN0a040bVJPSlJmUzlaejRiVDF0TVp6N1JjdWg0bHhWaHhTWjVF?=
 =?utf-8?B?LzZLdDAyL21MZlFOUVNPcFhZd2IrMUlDQkNSZ1BHM2xydXl4NXZ6MUtINWgy?=
 =?utf-8?B?b3dFWlAySzJhY1BKejVkMndDaUFGTWZ4anM0RjV1SWVZRDNERFlpN0ZpUXN6?=
 =?utf-8?B?M3VwZ1YwQURhTVNrTEdOd3ZUUXpxTWtoTzg4ZG56cmJITFNtTW5tbHdoNG5v?=
 =?utf-8?B?aXVoUnNvc09TR2hxWGRqQ1VEeFJHeTA2UWMzKzlIOWFMNzZ0Y2Y1bU5xSERM?=
 =?utf-8?B?a1RMVFNZd3h0N0ZpTHVyTTA3OXNPYTVpb2JkUDdzT3pVWGJUN3AxcjFZSTA0?=
 =?utf-8?B?SDZ3UmVsMDR3YUh5V1hZTGhsbnVsNUxITnNQR2xIUFd5SmNrSkhPYnFvdkNY?=
 =?utf-8?B?R0t2KzV6R3ZaeWJZN3V3elBjK0RCY25FTTBSdzJzSEVROTk2MEpYVUd2Z2Zh?=
 =?utf-8?B?aVZjRFNxc0kxZjZNNzcrTlMxbVNtbllQc3dDZWltREJrZ1hzeTZJYm4xa3Ix?=
 =?utf-8?B?aE1QMDcweUFVZVNsWi9aV0hiSTZRZ0VId01xWTJDWnMzV2U0c1d6SCtpVjQz?=
 =?utf-8?B?ei9PTnBCNU4vdVZjeTNibWdSQ2RYVkZTTHhkcTc4WC91K3BFT0xKMWZjYWVn?=
 =?utf-8?B?RXBvRzFsaWxiYUV6Wk13UFBhMlllWG82SXpGQXFSVXZxZUxqMDZHSkVlYzhH?=
 =?utf-8?B?Ty9tWENGTmJYK1M0Wm9xZGFJVjdKeFZORHZmWGtxaTYvM3huOEQrcXN6eUVx?=
 =?utf-8?B?Y3h6WkxNUEpZblhhbk1KVkRpWjZ5a29FckVKM09OOVlDbjU2c3VkSTVldkpN?=
 =?utf-8?B?UVdGWnQzTlJaUFphRHl2d3RRY2tWWjM5U3lacEl3bFl5cDhiNmFtOFBUNmlT?=
 =?utf-8?B?aXZqc3cvWFhSNjJnaXl4aVRHK0hSUkFIS29aQnhHYUU0NEtHWFFIalRldEVo?=
 =?utf-8?B?VFJvekdtS1hIVVRVd1ZXcm1nVTFtT3hVcXB2RDI5ellSZ0VKR1R6NXMzTXpa?=
 =?utf-8?B?UkNuTm1LYVdLUm1HdXJYZU1Vcm5UWExHVkhBdllFVmhOek1BZmllTGNHRDMx?=
 =?utf-8?B?TndZNWszZWN0eVFSeTBDSDdqc0dFNnc2RmlLYURHMU1aeWNEOTQ0cFVkczFj?=
 =?utf-8?B?WkdCY2VCTjZITlBBaElwWTBoN1p3ckxySjF3dHdHQXArckpnVEhXdzV3SlZE?=
 =?utf-8?Q?hlONtX9g73wOLRGFl9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8dc0989-1d08-47ca-1849-08de9444b4e4
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 01:26:34.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mErwdMVKNe8Im3c/YHrYkgbgmA1nK5okQD0W20QRBWcR9vYE/t1qLJN2cs0uqXoj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFDA9B3771F

On Tue, Apr 07, 2026 at 09:15:40AM +0800, Wei Wang wrote:
> On 4/6/26 9:30 PM, Jason Gunthorpe wrote:
> > On Mon, Apr 06, 2026 at 09:18:19PM +0800, Wei Wang wrote:
> > 
> > > > -	msb_diff = fls64(end ^ address) - 1;
> > > > +	if (unlikely(sz_lg2 > 52))
> > > > +		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
> > > > +		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
> > 
> > I was looking at Ankit's series and thinking this is slightly better as:
> > 
> > +	if (unlikely(sz_lg2 > min(52, BITS_PER_LONG - 1)))
> > 
> > So a ULONG_MAX gather will trigger full invalidation on 32 bit as
> > well, though it shouldn't be necessary it seems a tish cleaner and
> > matches how vt-d ended up
> > 
> 
> I see the value in matching how VT‑d handles this. I’m slightly concerned
> that adding the BITS_PER_LONG check might imply that AMD‑IOMMU supports
> 32‑bit kernels.
> 
> Unlike VT‑d, the AMD IOMMU driver doesn’t build on 32‑bit at all. From
> Kconfig:
> 
> config AMD_IOMMU
>         depends on X86_64 && PCI && ACPI && HAVE_CMPXCHG_DOUBLE
> 
> config INTEL_IOMMU
>         depends on PCI_MSI && ACPI && X86
> 
> Given that the 32‑bit case is unreachable for AMD‑IOMMU, keeping the
> existing check might actually be clearer?

Ah, I didn't remember that, it makes sense. Let's leave it then

Jason
