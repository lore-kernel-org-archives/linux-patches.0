Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2083.outbound.protection.outlook.com [40.107.100.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9F124679B;
	Thu, 12 Jun 2025 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736029; cv=fail; b=Uo/FABhixqKe+6ojC32v8LltyPnN3eoxt6IUBOYfDQm5maKwvhDtbQIOhSbGlPTegtXgEuNEGJm05n004coaqaEZrRmk8dLM1FC/E6QgimHBU1dVaUEIvYNhVOf3iV2FMFJCXzRmBHmUByILtVMJVfS6Nv2IciY513giH3tadRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736029; c=relaxed/simple;
	bh=QFNstW0rdqs7HXSG9IbX+h9+npbfwbathyyEPs9r5ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qGVrQ9he3m3tlNuvjHtlOO8RYx83ZCwxMItrjg4gdZ3cN4f4+Tt01ayDDtNsUJ7iUxeclNZLUeLfu1z40aTj0dVnvQJswKEa6Lxk2l5OnAVCz+4iZaYUuSh2Tl7jTIZCpm3gYsVzrlF0fopSbPeTw68p0QuX3IJP1ezba9j+P8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jCt2akRi; arc=fail smtp.client-ip=40.107.100.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jCt2akRi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D6vXUAfAX8RhBZsyuynCf6d+2tsAAkS6WbIXWSUhiwrpchmcI1KrsRAOUpqmv8hO6dtTz6puLRS0h0u4paWUCkia8oGQj7YXCIQ7cu/u+zUM4BeR3gQznv146X93vHiY+MTlBG34JtAMuI+4BlyWslauPUuuYS01ur3khXP9UVYj2IWYTrvj8KgeWezDwEknaGBkAaNjSXDVtzd9lP91HztzEsWykrX02h7Lvck842BQYqndV1nvapmdeoEnUQx4tm53oD++tbdnQeb0/LJ7k5I1xi8mnavr3o6hTfu7ERUmsDb5Pp5YfMLpTn4AS1ZZByNow841dtfmd/teSkfLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQlz1ddM1Ayb7fUsDwkXFOJruu6iZZuiFERMhZzq83k=;
 b=uBTWzjFj3a2iS9PdRDvau0kKwEsxALrIAGNcjFPDK7vMo+WtjMhLhsaJ4B8eAKocPNYM/y70ZgUEL2eDih3dmA7z3F6pynw0OLaVPffir2+qDqD9HyhytjQzvgm9askMmKnjpZ+GxG2F6i7ynrgNMEcGmzT9w8JrsX2L/sxT2j9o8XIM3y5+6JU0lwmwcLEyCj6PWsfNJxUvjpALOhqkiJRKuPFxeDhmtTDUPohnFwUBfOaNp6LJyatAn0Gqc4yrjdqCjbAcT0x9rbSzMQeNXAUYOad1Lza3jfwP5C5s8E/VXo9YxjR1Lu0yBb76mujVET2IF36xpheja8qG4NFxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQlz1ddM1Ayb7fUsDwkXFOJruu6iZZuiFERMhZzq83k=;
 b=jCt2akRiZVqZFa6ys62SLHPZCYe0+PKmak4hi43T7rZMg4Gc/eKPjH5JKfazytVS8f1ZTVkStBUQ/gg2oxWNMwx04Zwlz78S6r2iEyy8BlRrYwgqsFluyYbPZbWqXIu7WCKxNdAQXVvyMCUsc9lEctuNvEiGBpzuIceWBw2toiC1reLAyemaxmaHBXfkJNRn126CJ67+Nuhpimij4wYVwgbfnu/gh/OhgEAp7vuPBfjUqaAvdiDU+4gS8JrjTXzJdLnFM7O4NBRTQhJoehzRTyqt1Cvc6ZCW+rS6T0m30j151OjE/dnR/FDfhHRLns4h2VZaLnPH3ZEZ5S5l9E134g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB8796.namprd12.prod.outlook.com (2603:10b6:510:272::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 13:47:04 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 13:47:03 +0000
Date: Thu, 12 Jun 2025 10:47:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 7/7] iommu/vtd: Split paging_domain_compatible()
Message-ID: <20250612134701.GT543171@nvidia.com>
References: <7-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <39400661-9f18-4ba3-8cb8-d56ef548c9b0@linux.intel.com>
 <20250610235125.GP543171@nvidia.com>
 <da8a6938-c45f-4923-af52-1a34702f1b0a@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da8a6938-c45f-4923-af52-1a34702f1b0a@linux.intel.com>
X-ClientProxiedBy: YT4P288CA0027.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: 566c63b5-08e2-47d0-ccae-08dda9b79cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/cjllb9aNG0sLRdXPBjHb90u1360Hsm35oVEqgbQpMf60evf/XMa9UvICu3X?=
 =?us-ascii?Q?aOp63FimrwBuo/BVwHfgb9mGXOjvwS7dBz6h7D8vVXJu2TV/o2Fq2Wa7Sf1U?=
 =?us-ascii?Q?CxAymDEVybM7+JsxXcQZqeRF8RMrSZNPHho/jrkmbEHVXbvvkefw0ZgI7fC+?=
 =?us-ascii?Q?/eM2jy8AW0HcIkQqTYydT0ptB0FtpZEOZektq/Y6c0vyRfPGlFsAeWVjYzhN?=
 =?us-ascii?Q?5BbR6FeXaGQidpdLOq0DCdOE2tIOopZp68mc8krBUjx/163a+Q//xMTUX+tO?=
 =?us-ascii?Q?LMYg9lqMT/JqDWuRe0m8EwjEubShyB3mwI1Tn6aPuUXqVZXRrmEDj5tDQqor?=
 =?us-ascii?Q?JVLFc8fuVHFQHGYZMwiK2zIpydv9B7hHcxTQ5VNViwRRYCBQ+tA17ApMXhoR?=
 =?us-ascii?Q?iGGU5jvr4hbjWVOsjSG2/sAl3eFWzJWitRuRApXvDg5iiCneDmc/U4St9837?=
 =?us-ascii?Q?LvwEluLZVkWHX4BcYRemZx+sf8czCyrIjZEaqXrJ75Lm0cigwImSs6DtTnyC?=
 =?us-ascii?Q?0B+NPdvswgT1kKwURMGeM02TdK0urEC4a1N3of+S7Zuu4eun8swxOuSDK4jA?=
 =?us-ascii?Q?O6q+HdKQpzlAzibEUujbo/k9PfLqamHrSdphyg300Pu40qj+JF4VNG3TgsE6?=
 =?us-ascii?Q?qQ/RWJeTW3ZlWydpOBsP8O/cEwVG6/hYmynJq5tcgloaSwWq/88+FrH9qdto?=
 =?us-ascii?Q?vLZpRHVAwwKcZE6DofOy6hHKdiGSuYIdPe1C4mJtWP49mBX7bsmnTkTClhmQ?=
 =?us-ascii?Q?6A2yOeQGSdSq0oeEhEW6dCjGCa8MjMaqhnwxRxXU+SfqyI26Z3gtzZ1D/DC6?=
 =?us-ascii?Q?gX9rrs3fhS3MMp+LE/DETTCIgzxBVs6M13hQjiZAuRL/BlvFp7vhHj4pizDC?=
 =?us-ascii?Q?Q05y4eH4MUXEkLBKoffGolxZ32WwgvU5P6jR2RHrJJr6XN/Z7cNwIUozW76Z?=
 =?us-ascii?Q?THskbP15kqcodOhtlyVDoVzxXvil390mhEI5EanqbShlSsX6X23oQ6up73ym?=
 =?us-ascii?Q?7UTtPJbXmHHU3rN49sk2tFkumjSpB4Vb6kz4TACqZTxFB5IKH3YrYh8raDCr?=
 =?us-ascii?Q?uQISCAJ0LpuHSCJMzz7s7oHt+SeywMMKf1QrPfByhdPEtTxSOYWaZw2A6Q3x?=
 =?us-ascii?Q?W2zcBIjH1IJugy8EMDDEpqsoOkt/fLl/QAlIa68qqEb/1pTEyj6Om9Fws4KO?=
 =?us-ascii?Q?NK4lSQe4Qi8cXMxm9huK2OW1Ni1KAuLEP0nmLRriCDA+XRqx/TSRTJilbpLH?=
 =?us-ascii?Q?eMDzdjumdFkUFTxK7mp/MCkNs2HZnM/DeQasjDyjJ1czzqm7SI0i/QXEoA0a?=
 =?us-ascii?Q?9xrADsix2+XhtyYazxGZjK5T03XHhvVzQoF2LiF1Ndr0M1FHp3p3OLH0Q+8K?=
 =?us-ascii?Q?taL73DvuevucpHz1IJ7lRwZsLLagBn8GjHJHvnBPalfADmqZow=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xqhA3c6U8Ypn8GSyEeJjlUND+dSJ7urIpZYmYP3WrVcNbYZmVG59kEgDoZ6I?=
 =?us-ascii?Q?RD8GBxfQ41KAtKeZugXi4qKkDeCzbi+aLVypJNDVGiWIhx/hyOosqARMA1lt?=
 =?us-ascii?Q?6OCVXvkNScaqGQmjVe4qTHKSmourXihA95wVPvySXWgJPCUXerekPSLasYjk?=
 =?us-ascii?Q?QEdPVBNGF3gvRQwufBTU12BUMKD1AKy9CX3X0TUczoR9Nt5RASgobTJyPFX8?=
 =?us-ascii?Q?HLIrYZLkKoJbTo57MpFwbBSh5rZAlCosgATx9pE6La0yqbSZuFFj+uQvIQmd?=
 =?us-ascii?Q?rSMC3ourWQsWaqEtMdiKHAaG2E0NgU6MDAag5LeS6GVRn9XzcRnA+9OGQzZ/?=
 =?us-ascii?Q?eBym1OAxYBA6Lnv0iJJb5C/fE759PjdGPaiQ54Z+SwfXsWWs3p7MklOzfAvv?=
 =?us-ascii?Q?D5tPu2syFzueq3DXIyNvxQJiKDcx6rewMegN7tFStmcJNyr0DQUM3zxr58m8?=
 =?us-ascii?Q?XcTmBAL+9L0vm2VuZPNQ+wx8kpT5FqOLhbl2IZNdxLr2FPQzWqAgK6glP5kJ?=
 =?us-ascii?Q?ZZTP20cenS4qY148tHo8PYm8zdSJaLad7j7RFPpWJYPNoDHmpn/AUuR8j668?=
 =?us-ascii?Q?lrse3Ka4RIVEi3gCxrtT0hwOz3bg7E0+ngmVdBQQjLMnPL6fIRudIUPlV5oo?=
 =?us-ascii?Q?p6kzYJ4vM4a/I1k6FDidwG41nF6ym08WQUiYD+CJ/rzleo8LQNeLUdasODnq?=
 =?us-ascii?Q?rm+IDkLEIkGPJswR+1hs/dMDYeFB4vRVL+q+oA1IllWDxjrBEgR9RLkOm6Bi?=
 =?us-ascii?Q?EA5AczewCgyFfkPy/VcVTgnt2B0q6hjtgJKYMcaz9RjcTRXUIjAV8ylWI33L?=
 =?us-ascii?Q?GUM5FCLJRMHvx9n5eTf2e+PTy/i75h5Ru+Rdnsj0Mkm1Lvp8SGeYXZNXrUcJ?=
 =?us-ascii?Q?TlweZ5LTMqWNx9RL2exK3nHdh0jXYzWzqDKjt2f8Z7r0ZFbO9aWWuje4BlOF?=
 =?us-ascii?Q?r9B4g/1UPTA4oFAdc52o0gVa8k6LqYQ6zqWqAgZHJHLeptNaZ7VwlwmBzqFP?=
 =?us-ascii?Q?pim2ymrhshhxII2HsRVHUhu2UdJSUAORP6CzBj/lLYUO2HGJtXFtscdAWsgG?=
 =?us-ascii?Q?YjEsgWyBevrSvNzvZlwR1IPSNiVdzzD+gh1AlX8TSHx8x06ls4Z9zXVMM5+s?=
 =?us-ascii?Q?7DHJjX13qauD/zcEMxNy84PGndOkt0d4LSNT+zsDkiig2Fa90j8b7WaRDds6?=
 =?us-ascii?Q?Gw4d9mBzhjzJBKgE2Tka4TxopZyaPaqVqCWZRqJwckSDNqTKqtg69ECKk9+V?=
 =?us-ascii?Q?rAFikK+ysX+ctuQd+7wBIPnZeLyEBRzlHbEf60mzm2tYXMUXBDds6IYGz65J?=
 =?us-ascii?Q?IPXJO+kF0hvzMevUclFnWTtuXXdH/DuwZOOvVjV1/ksVEo0KyOT9o8DYJq/y?=
 =?us-ascii?Q?1vVpHO3o5NcjvuHP25Y+/kpsGiMwPrkNXY2ZZx/toLW7AwxUrRGcijSoaQO/?=
 =?us-ascii?Q?0xvRf7g0yPukLuaobFSRv4GaKvlxnUW9JDBXpmWNgeP84L3d/A3c/n6mxjrK?=
 =?us-ascii?Q?uCZedr54j2XvmiELF9jybUd4vdCFtwE6191bBz1Dgjm82FFDnJ5mVbkynQao?=
 =?us-ascii?Q?YI7hHGO5A7wpTjk6xfh+cSEH+OqiEL7TPeHk7V9i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566c63b5-08e2-47d0-ccae-08dda9b79cef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 13:47:03.5992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afuaa2891OolVMY0giM//zi5Bi+tbFTmrWE4U+8SKzdgehtVpT/9RlHv+hk+9iyq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8796

On Wed, Jun 11, 2025 at 12:50:11PM +0800, Baolu Lu wrote:

> > When this was first done that was harder, but now I think we have
> > enough infrastructure to do it easily..
> 
> Yes. I can follow up with a patch series for broad discussion if you
> don't want to include it in this series.

Please, I'd rather keep this as is.

There is also a problem here with AMD, it turns out only its V1 page
table can support disabling no-snoop, the v2 page table cannot and
there is nothing like the PGSNP there.

The iommufd side assumes that if a device supports coherencey then all
paging iommu_domains support it.. Maybe a creation flag can fix that
also?

Jason
