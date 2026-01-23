Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010019.outbound.protection.outlook.com [52.101.61.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F35A2EA15C;
	Fri, 23 Jan 2026 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177661; cv=fail; b=ctfJ+Npt/4qcfa8pa4MBkt0Hvrw7u1WpZ8tv9UwjluQOx+4Q5xmNdf1HOSnyZvAOpHyMg2zdsxYJu9I9znELXuFkf6veLg3c8xKK2AOnts7Tf9oxo7T3QbuIgXSXGM1jWLVGgOXLSybi2GthqGl+7h8ZeugMNwl0q4ASKV84/ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177661; c=relaxed/simple;
	bh=ohFKlxaV+cyZ1nAxM4Y1bfaPzLZ23tFvPrjvTp6isdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sLGU2ad0008GEsJjHIg3Z67S9I/TsRxLMQlnOYcPfJ0J8wDeUeHOfAh5eNWbmonJwfuRN8qA5qP56KDxEoCWn7qc/y5PHIvMjjkfdk1cvJqQOUOVTujHHAvgp0NldrSesipog8VLaQzOYevdcUeMIvlFeoCW1lBIOM5QbvQsjnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eaIEZWfu; arc=fail smtp.client-ip=52.101.61.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eaIEZWfu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v0ryZZhQENkqDtW+s9dDpPvzMkPeUix/Tv/CNjefee/9+TMez96Su0un4TQokjN8W+/rcJOTP+qzXCvt2Km+ySnbKdKE8mJ6I9xyLuIAFMjVEJyFMseamwgoI8tpBeTv54F8Iq+3cJsaPW4qlPy4/Slb/JfCjbK9DuuJCWyePNkmh0qQXjQnvXmz8j/Eng6vTfoAeKjjS/f+T4BEeiHuMD+X2ZCOKLcs+XX4QV1N5V9uclstVB+jJWd5X3f7Gpy5gzXHSYrlfhA5cXO9cWtI2cgD6xuQn4lvpAR4F14kXagOPIG8E4pLK3ekA3Ts1nX+cVHcESgF28BhJOTLJuJKIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Z6KZ8XT6KwiAxJH/iDVTq8GZVbYy9yyPGKJth60ecU=;
 b=ybygWo0iBFBMPBO3M6xVYqyH0SjD5fcfkb7wdr7zCN4ZrqC7G/MzX3G+b696bzT+FIv4WFk+3FVzht2eKFLMJkyvRzZy98TxQndbzlLCYYJGd/MyXjpnkRurrMcvo1skY8diiYD6TPu2nLRIjTQbc549eTRd+D7Nj45/8+zkkQS7ru1u+gVm70V8ZXiaLLasFQyLRW0KtLOMW21u/AQTRZfSaTS68F70XC1DaBWNTMycC33fIXa3XDnCBI/KWE51DtCwuXeq6fWF+s5LI1rk2LXOXaXeZ4XGGnepnxQd6NTylrlfJej9v3jo61AtFscOwDWq/7rkWEV5sKP7Y8WAEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Z6KZ8XT6KwiAxJH/iDVTq8GZVbYy9yyPGKJth60ecU=;
 b=eaIEZWfuFpagnKcqvD392i/pnCYaRdJGzXkytpUa1XqST5s0/Ibmy9xxd70pUTVyw/RZcohftdfU8oOG2K7M8H9p89IRQ4i7gomjlnWF8BYkJHGXfGKr7jdGz+zizxFc53d3+cn5am5G3gxscDPlCHqq8YpPKvsndkVl3VLGDjMwlc2AZu/ptCa8f00zKKtEVqXSKeLhi8eWTleVCbl87mHSKGbBYxslK6zRvBjBkcKt4ZwQhv/0PdyAZfL8RCRo6U0qB6ATF/LNl5XcDW0x7X37J9mVny5mCgRmHxAI1JWYIikgRH3R329znEA7+V7Ox2PcqoRrg5Zrcdg2Ugp8PQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB5930.namprd12.prod.outlook.com (2603:10b6:208:37d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 14:14:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 14:14:14 +0000
Date: Fri, 23 Jan 2026 10:14:13 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
Message-ID: <20260123141413.GY1134360@nvidia.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <e0514ec6-b428-4367-9e0d-cfb53cc64379@amd.com>
 <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
 <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
X-ClientProxiedBy: BLAPR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:208:329::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: 715ec137-d7db-435f-678c-08de5a89b022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?djnKixu09rsaIAwz2+8/NpJxcpMin/GqUJsJAKPeWce7ktq+PYehQssQ9BTN?=
 =?us-ascii?Q?KDIxtcb+IFdhnmFdTjsR5epKuAPyvGO3kM7l8ZPvlkJvkgTwAveJrH/lFLpc?=
 =?us-ascii?Q?6z5NLmMExVwK2J/3CYLlkBIFiaHIFH9XSFrWTq+nVZQ/ZIASzoR1nAtmy5fz?=
 =?us-ascii?Q?Q4cYCS2gQgWkR+kMDtDmqT32qNhw3m6iv2Vw113sA54hD9Ikt91/iu/HHAIl?=
 =?us-ascii?Q?LpQr0/S37W4TeEOuXLDhYXDdw5j9iAqhqnZJ4WFPWg1Hz/CBW8sEvqOPYNGm?=
 =?us-ascii?Q?1Mij1GyK7STF+BYl4IeEhSlbr8LTZ3QG2BLQGkhDSj2PkaklZ8M0w+TuHMfs?=
 =?us-ascii?Q?qYGcL4IJwkRXEm2YAck0boryRayDcp+AmKEDryhA/l3zcIGL9HaGH0iZ2iA8?=
 =?us-ascii?Q?HV20UAt/7ecVunPi8rpMD9zarJoP0AXBcTvszkZ03ccoglKPy1/XbjK6b903?=
 =?us-ascii?Q?I1IpKyU5yGKpszvSWRf0xrJZIWk1hZeQi5K1SEnS1TWdF+tvQOqxY1QroE40?=
 =?us-ascii?Q?pxZ35jaypzjXt7r/DgfWtiN5T/qZubi1h9NBAqvvYEY9NrgsWz4EL3lLLzKG?=
 =?us-ascii?Q?vTe6X8cHo7iUN+wR8mYf0HRMF+lQZsSTV2TxJDkpQgvpukJ8AduCy3WMuqtR?=
 =?us-ascii?Q?9RIIQQLL1NDu6dugSzTuoCO1/stbsXAJjAzuWZIvsMaMkEah4b02KvW66q0I?=
 =?us-ascii?Q?EQXxB1W7rCHsaxDXHXYaH0D5oV536yUX5OEmSmeqpRVpgQYlkgMJP6rd3PoP?=
 =?us-ascii?Q?8Ww/XtcQnaIGaPvZeQ7C5cXkxp55eurWz++ZUI6JxNPa8Wj8qDd06qKk2AfR?=
 =?us-ascii?Q?JwgNRexdIxQf3EyrX1MT/1hOvIUWpFwLeEbrLpS9Vkz3wcLmxMmjg6M0D6mm?=
 =?us-ascii?Q?M5zEpu1M/15P37OAV5X80uveSeSIBE5XUrH4VL8+sKZl3HAsDTT1qmT71l0h?=
 =?us-ascii?Q?xINd1ZJLKNV2QE/wR+3N7yJBILOqcsd0wtlV6y95hxFjWWLN3G0PmTwUIdQV?=
 =?us-ascii?Q?t5OWagxyhPHQHTKDlHGV0/nmdNiqEIx6yiXaBcOBPXVxCzosLTdEt/WyfpQ/?=
 =?us-ascii?Q?K2jwC9BSjNLNmOjH3YOBzpwbwauDWRLB/tJrpaMf55gRnUWEAV0tBm90XO4u?=
 =?us-ascii?Q?RaAO9kqA/9aqfaWjRgMNr3QWV9yDM4w8Go7trgKzmoHazLASKo1Y2NLfmU7X?=
 =?us-ascii?Q?RLexqRFMqzkWlez2YKtVQ45peGBsKYlqiV/8VxjuLxRjyli3jysKyDcq5dqO?=
 =?us-ascii?Q?THjgwb5vL6feCoTdAt/D9qlL8+h9opD3wkdK6+8DHtfzyO8ZDOmecdJuarpa?=
 =?us-ascii?Q?U+VrALdQuayQbnJuG8r2Xc4aSkoT84tQOEgN0FJoaPwLtnAsIs+WifqHPB/u?=
 =?us-ascii?Q?ghi3knxeiIPL56jRTQ1TG7JD52CykUq4ZdEytzvq65HPTwh/FnD9m47tjCmL?=
 =?us-ascii?Q?jd5H90VljSH6ScZ6PxwFPrwcrUsqBhuJ7kvSpwA5kxjLWjVmcASduMyK0j6o?=
 =?us-ascii?Q?CEO6TVMhIt5aA6uDDLFKa01vEIGG1tFpqtGRyoA7HpB5AbUbndvQehVW7YTv?=
 =?us-ascii?Q?DKXnYQ3uDtA0ijnUu88=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z3cTF7DanGOdS+E81B8rIsDiiV4r+ruaWbba7pvj7d65yTOLJK1BHKAJHRuj?=
 =?us-ascii?Q?6bqh7NsVIl6jVTRbnZ3ICvml6X3HxK2Qxb4g+zwkL3PYrMUOvrp0kl5Wm91+?=
 =?us-ascii?Q?mZLaYlNNoZJ3ey5yIvez6AY6MA8QcWAVW2fQJbeETDK+mptfrOT4X0dXUcgw?=
 =?us-ascii?Q?rn1bIMlfkviF9/DbTiQzluYHMMFmEiRh+b3am7LtyWWGTzeHzj2C/jrFn4bP?=
 =?us-ascii?Q?GrM9NzdeZM0+N0EUtEP4e2GEypGX1OzGM6AOc6URRzjoX/A/jAwEl/+WRbkQ?=
 =?us-ascii?Q?td+SQlq851me52dPkNrwPIrntQsTM+WtT2+kpZ9tIajTucZSnCVHNdcpfY9M?=
 =?us-ascii?Q?wiIOLjMMvO7COzeXM9bWiE6PUJak18TNZxvo3a5HHNCHyFu+lORGtb75oap6?=
 =?us-ascii?Q?wBzk1dv/1c8sfZEgNaaRIHazvgc2pEzSU3BDyp85Wn61oYOXzqMfdL6DRUdQ?=
 =?us-ascii?Q?SSFT30qtnYLAzd+lkZtMoOs9e/eriP/OiWWiQoeiCNgELxznZNxeDq2uGOMy?=
 =?us-ascii?Q?d9NnVBAanF5fNItQaSFrRy9WnMwPeWGrsI5ledMYXoDnIE48qV6GXDGsp81t?=
 =?us-ascii?Q?u6m2XR1sRu+6Ac/oz9k1JxZvrNgxK9KDRNMbDV9CNvIeJGx3+AK7cJjS2TBq?=
 =?us-ascii?Q?s6qe4zwMZvszniLDy9kF2/IuA0v5Lq0kVeK4dEYim2lU34HFXH9t9S+oqshd?=
 =?us-ascii?Q?UBOFq5h54XR5y6U0tFygJ1YNdaga97XbmX+d+YTai8Dw1ktyMX/1vSOAq4UY?=
 =?us-ascii?Q?3SPdbLO/J632s0LOSysNwDeAB50FZ7YF7Ft92oC9liRIv2BQ/sDZLzhA12hX?=
 =?us-ascii?Q?dfNQCIDhGLkcJxawUk0XdzYGKnzNRIylP6X15qXwoJeJyjMy4gYKXIPlekas?=
 =?us-ascii?Q?uFCYy5yJT8YZL2j7U54G0pMXlTsld9Zt6dgaPRFbVUUVeo0k6YG8VQNjFi7s?=
 =?us-ascii?Q?PeAe2++DlT4Pj6Ph5cNJD2l6+1/E/hg06hTUO+5MltDk3+TosG3Up1ytaOMg?=
 =?us-ascii?Q?ncavvmfTDVNGDJB/3VPd99/ReNeBxT9K6PssxVlkYT/Gc/lQj7G4l9VhHpMm?=
 =?us-ascii?Q?aBwkqTpYYh2jSueq05+pb7Y7SlGhC0mgQvOmeMzs8VsuFfE1YbPrXBW9V3s7?=
 =?us-ascii?Q?7s2TQ9307CbVFANw/fXxAGVrwY7t1qRHD7wQeF/Auradn61t/tq2tPTOHa/d?=
 =?us-ascii?Q?FoIvBPKcuIi4zOVWT7gMD50iSL3KygeJRFU613esC91A+AmJZ4cbuuBybGN1?=
 =?us-ascii?Q?YcpdHJQWcFN6SJUQNDYsJ0H2/nBp4p4+n4n++HEuGTrJh+2O4ecMJBs9wQPf?=
 =?us-ascii?Q?+IsndYEvfTzuexbUNSqoC4gJRnEJV8AzymwFrU0F7YGP4ApkYQ7QVA1k2Svd?=
 =?us-ascii?Q?jLVpbbJs67rsHpee2RAVIe9hV8W7Ir8q/6wGk4vrgpduM+rdTQJOo4OC+X5u?=
 =?us-ascii?Q?r3XAtYwo4KFOnSSxiBVsn2WQP0kMIcp4Gu94dMeepgC5ri7H/5262kbOb67L?=
 =?us-ascii?Q?SjEU4ysvzYb67PceDadYoYj7PfBtHqVZjBS60pGsmNP1ud4k2oC1m3yzr8P8?=
 =?us-ascii?Q?eka8kkpzqPoJP2yhlV1w7gCBIXhlkBLaC6FLkRjeDNIHHxjJDtX6OPvsQX+g?=
 =?us-ascii?Q?FrzUeWMpFmTIXQJEIlcKXR03dIkL1krnFUoplWK7gDjTIxsJ/79lRCL3tVFi?=
 =?us-ascii?Q?fAD468JensICPyE689oPudfOG+LbLsTJahJLICBt5iuN1Odg6ibVHjQ6up8X?=
 =?us-ascii?Q?37LOGwzU1Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715ec137-d7db-435f-678c-08de5a89b022
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 14:14:14.6554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lovQvKrTVLX1qcdCjhE8G4awzbVue/utJA2ONKOvFWEQJt64Fy6RCVjvL0Ze/6G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5930

On Fri, Jan 23, 2026 at 12:07:26PM +1100, Alexey Kardashevskiy wrote:
> > > Got it. Interestingly the HW actually does that, almost. Say, for
> > > > =2MB IO pages it checks if RMP==2MB and puts a 2MB IO TLB entry if
> > > RMP==2MB, and for 4KB..1MB IO pages - a 4K IO TLB entry and RMP==4K
> > > check. But it does not cross the 2MB boundary in RMP. Uff :-/
> > 
> > Not sure I understand this limitation, how does any aligned size cross
> > a 2MB boundary?
> 
> Sorry, probably wrong wording. SNP allows a guest page to be backed
> by only a 4K or 2M host page, IOMMU always rounds page size down to
> the nearest 4K or 2M boundary. 4M IO pages can work with 2M RMP but
> not 4K RMP.

Oh so it doesn't actually check the RMP, it is just rounding down to
two fixed sizes?

> > ARM is pushing a thing where encrypt/decrypt has to work on certain aligned
> > granual sizes > PAGE_SIZE, you could use that mechanism to select a 2M
> > size for AMD too and avoid this.
> 
> 2M minimum on every DMA map?

On every swiotlb allocation pool chunk, yeah.

> > Then why was I told the 4k page size kernel parameter fixes
> > everything?
> 
> Because IOMMU becomes 4K only and there is no huge page support in
> the confidential KVM yet (well, in the upstream linux) so page size
> mismatch cannot occur.

Ok, but you say when RMP has 2M pages then this doesn't work?

> > What happens if the guest puts 4K pages into it's AMDv2 table and RMP
> > is 2M?
> 
> Is this AMDv2 - an NPT (then it is going to fail)? or nested IOMMU (never tried, in the works, I suspect failure)?

Yes, some future nested vIOMMU

If guest can't have a 4K page in it's vIOMMU while the host is using
2M RMP then the whole architecture is broken, sorry.

> > > > > If I get it right, for other platforms, the entire IOMMU table is
> > > > > going to live in a secure space so there will be similar FW calls so
> > > > > it is not that different.
> > > > 
> > > > At least ARM the iommu S2 table is in secure memory and the secure FW
> > > > keeps it 1:1 with the KVM S2 table. So edits to the KVM automatically
> > > > make matching edits to the IOMMU. Only one software layer is
> > > > responsible for things.
> > ?
> > > Does KVM talk to the host IOMMU code for that (and then the IOMMU code calls the secure world)?
> > > Or KVM goes straight to that secure world?
> > 
> > Straight to the secure world, there is no host IOMMU driver for the
> > secure IOMMU.
> 
> QEMU will try mapping all guest memory and will call the host for
> this, or it won't, on ARM? No IOMMUFD in this case? Always
> guest-visible IOMMU? Thanks,

iommufd won't deal with memory maps for IO, the secure world will
handle that through KVM. The viommu and stuff is still optional and
would be controlled through iommufd.

Jason
