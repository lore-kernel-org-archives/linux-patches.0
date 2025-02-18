Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BF21B9E0;
	Tue, 18 Feb 2025 20:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739909970; cv=fail; b=AKzd1wrb3HXXPrI5taCLmdFW+JHXUivNuOGiIsMOY0sQ2vbtX+pSDxn9jhAnCd90rZaS4bpnM2pUoZbHDjzRF4CahxiicKoBnaex/s8za3eqRbLBgsqlMiTacL2ZT3mjjvqzf06anAiUYf9nbmkjoBDFfPDhb0jbmHJweC/u0ck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739909970; c=relaxed/simple;
	bh=YD+hrS1uT/1cqtLnP4vZ5IkDfcG5T4jsqw2ayFVgOgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fJLL56D8xsMBOTXcTFE/EjPjpCFabD8WoMn4cLeqHaQA7xeKaBLofls4TGv/ehGYRTuCHiRFoCQnxPbAoiXnhfJ7li5DicxKjLlC0btRPfCXnrVCQ5A06zAfRAoVB5vhBC7haPT3mTJjceNR7Kuo8u7lU7kOQJCnoa3y8JWn7+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JMpfqjZF; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JMpfqjZF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwEbliCd+PvYLfhqiNWkn829QDsJY8Klziaia6J6VRZFkVRnVBrG5RLNFfUiUh0QIIW9tvsSsl3if0shhbjbE+z/kjfd6L6ftDlQxpCVvSlXoPOb6e7g2K4l1BWWmY9qCOm5jzBoT+7iO3GUfoTDi1g8Qz4I+b94YssrY1hNGWupSquNkmx4ES6IZKbIFrqJgrief6DJmypUrqAlWI16Eqv0Hhqzk4QMGvklu7OxLHudYAhL+ButEbw0hQCg2r6EAIhCv7BTQ+enARGA54gtWvfqdOicsGMtIY8HWHD0Hqx0lnnNlSZ0o/xfbQ8ayeSJfGFQNXcU5MvBsWeTfgbI7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUByovpRk+ZPzKvUH7cwXnf3mccHjMPsOPK2e1mFlRI=;
 b=O1+vWNUkaaNBXfA7xqPljpFMycqtXuSvF5cuYXUw7geVkT8q7Ez4iAPMfF8EWSexN2ROIfkCYLeVzxYzE5UreGBEJybeOvYliYtlPj7ZbJhw7KLD8ZCN60puIDCec6i5ETHqJA+h7tKFx07Res6MTHzlMzlP6KkeGBRsAg+wcBupAaFmLDimPxcZgJgoqy0O6gtTFOOvqqBpNxn0l0OseCm1VDa5mQWxPPuheN72RpRggMNoZLGVBh9jsGk4Gimykx1sJfDo57ZdK9fD5lFQK41G1+HjxRmooHXIKkFLBoz+ie7/487KVl9Oin6DHjExGbTwrs3aIjUe9W1qADVdUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUByovpRk+ZPzKvUH7cwXnf3mccHjMPsOPK2e1mFlRI=;
 b=JMpfqjZFQsNoU3m8kHcfxgxY7zm7XGGecpPDOlqA+IlD0rRdkjlC9m9SMRWMWGqn3EXVMRx+M8UT0MqedddrChqPe/Iv7U2D9blIUPsMZGYYDAfXoTcft5FLgpQ4lwZ0A8/gq9dx5Cf0hAhtB0hpkt+nJktEReAYSEj9/REpS0s2BkYtEWzM3q8SRjgWta8h0i6ZQddiV0stiMTQTC524XZlSKlE6EcLuYN2fEpZTpWf2nhZgkCqF1yuVcH/LUJWmtmcOL8pQ317j8oX9PM8wJ3iy2pvDHusEqrlbyGLwgTK5JvRO39yG633sugL1DEfYd4Z3jRPLpSwyqOqu9kZug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8330.namprd12.prod.outlook.com (2603:10b6:610:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 20:19:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8445.019; Tue, 18 Feb 2025
 20:19:25 +0000
Date: Tue, 18 Feb 2025 16:19:24 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 07/23] iommu/pages: De-inline the substantial functions
Message-ID: <20250218201924.GJ4183890@nvidia.com>
References: <7-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
 <84fd4500-a12c-40d6-a532-e2956ed1c35e@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84fd4500-a12c-40d6-a532-e2956ed1c35e@linux.intel.com>
X-ClientProxiedBy: BN0PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:408:ec::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a43b2d1-a06b-41ce-c277-08dd50598a24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/fVDSu0Qoskr1uloYn1tJun7uVLTptq+lh155XjPVdaGbjQqAOon7HGW6xmb?=
 =?us-ascii?Q?J0bJq4rDNdlHbMaGdXxnAlMWkRH/LApujlXEZaCTjaJTrP6DExwrgf/5/Laa?=
 =?us-ascii?Q?pC6k6zrknpba/bf8yat2oTLdSQnL82ICnnUpOMJMj3AEqnHH6cias65Rard1?=
 =?us-ascii?Q?k3XF5eEz/0mB8oUWWavZIH4Yl/Hq6RTOFmmWbkA8P3mUo+BlLUex7gdDrK/5?=
 =?us-ascii?Q?Qcu0U1NwijwDYsDCzWy+gSy+OZUGbU0mT42tLXV45m9ttxVJkbb9jo47OaN2?=
 =?us-ascii?Q?1EiddyZBQwI5HtB59FUvTDCtsSDQhEjEn9Bm00AV/deijPc5UsL4enY6Iyn0?=
 =?us-ascii?Q?JXjFmX/I4ZUEk+hY5qhB3nnFUbaJPJ/LL1rO7c2hMDJdVOODpvdtpgjfs45x?=
 =?us-ascii?Q?K4atFPsZqxSnMV32K0kliF+QP2FZNf6+uyKvVAa+PzO0cGZ6Wj/50u5XMErv?=
 =?us-ascii?Q?+K8qho1YOJYPi3gOKO+R2e8l37MiDNJc8pzlvfKtv3tkYoB+msKFuJHbjMDa?=
 =?us-ascii?Q?7Zk8qwb0KPqlfKxxjX+dGEc9ThogLyLviL4MM3zA0/oJ8MnyDO52sVRPh+F+?=
 =?us-ascii?Q?fS5T3ajJvnFheroek/L87erICtJ/XZ0mtcql49v3aZn3tKYoKsp+ZAZEGdqc?=
 =?us-ascii?Q?MH1eEfAjlveafYUCmIehe3ju9dOm8P9AS6Lgi3Xep6n+U5y24ucxDcKkXiUU?=
 =?us-ascii?Q?HS+dueSWMCuewXhHKukrr6FAuV3hoMVGT0KCDH/nQ1AjeGC/XAEokIrhkaz0?=
 =?us-ascii?Q?rRMeqZdyitrwEcz3vkum/YlElVuMyPV+g2eT1fi0elFPQX1E4taQOGSiP08b?=
 =?us-ascii?Q?Mw1WeuElTZIIAiCjKKKXR9Q5qhZEpDbP0GQP7PBlIuZBL0Pq5rX1k+7FYo1X?=
 =?us-ascii?Q?ioEjIciRiwOfAEKheJKq2Y1kmuC1I68Oluy+inUAMi8i1NoyoX2WGjBf6uDD?=
 =?us-ascii?Q?BytA1aijN76CxCqnDRAdgMbrmsZvves+UDgP0gtG0k1GMH8suYDoKMe4GR/f?=
 =?us-ascii?Q?Y7TSiJbZot/gtc65SAeLY+gMiyQRK/fBE2CTK6nrfbsjcluo3gSM6KoAirjh?=
 =?us-ascii?Q?NnUZiSxzb8uFpn9lGQjwnzoew8Sb+WL4uwLqvIlM/OyG+geVy+Y2ThsZGH6n?=
 =?us-ascii?Q?wOt9Xmocx7A4QCyQUaPHaAQ0O6D3Cr4KrVYWetdit42ADMUb0XfHhnfDPrHv?=
 =?us-ascii?Q?l48RJKw8Y2dxgWd0UEZ3WFREa8EJmlZ90EIFEmj4Hbje6GJwajHuI6qyp9yk?=
 =?us-ascii?Q?qYGsPhZpUDLNrJJI2dBj3XtnaUKs71YNFutvkHu5O/CRcF9QXvK3DzkkxZlA?=
 =?us-ascii?Q?w0dbCf6vB0vG+Y8k1bQbFDrisjT73277xByymZvb8ozryMNRm2ExDoxOk3fS?=
 =?us-ascii?Q?V/lkVDr7EtlhFOXGaa4VcPtMjd3B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ABkYNvLoiaaDIBnbsa8PjbxD6AWZTJrZlQvUA/KOoOAWmPuGTJLhnOKlxk4n?=
 =?us-ascii?Q?DuRxBmu+7vnXTbfy7b/fDU+F/jixxGkXl9iCaa2K74ULMjDIzCGBRYUXo51q?=
 =?us-ascii?Q?BA+bqVL5b9mEsNS31Wg6vVsBuHiQYt3ol/UfuOPVsOGVMEImXlT0LiyMKoda?=
 =?us-ascii?Q?9CAScS3BxB5Sk7rAaqfEi2hMyoVsz66Au9Ujw8uSr+Vn8etFi5cXOPphOw3A?=
 =?us-ascii?Q?5KvdW8R/ZA9hkdLFhisScG8hVnZKwKz9ijhW5cXVLcEwmF3nmbpHj3akMGv4?=
 =?us-ascii?Q?ycq0ib4Hex6W+6aEQ/D5BFfxfeHnbooBAomwMub8GPeorxBKDC54ExboDaIe?=
 =?us-ascii?Q?/e/ataHdbkX1WbzWHfGfX3T+oGh+IUdZf+NrqAyYYwQ5JWjQ3CpYBqu1hKkU?=
 =?us-ascii?Q?1DZfui3U66d9xkNzfxMJEc/GWmzE+fr3qUC43pPEmTI2PVmdWS58uw73zz7v?=
 =?us-ascii?Q?ZaAiy6bGREc8G8DqDn5PFs94y8D+WWofGuw4x11Se0BKsnvL+DH6zhc+BK9W?=
 =?us-ascii?Q?f5jcuhTmnm/MLgtTT8NAe13NEcQCicGBXehIqan17SqDlATvfELT2PSMVA1s?=
 =?us-ascii?Q?J6aQgomiXzYP/JDx1hfNQXF8yIjsf9US5GHA5mKPgJH1V5DfpYAJjEnqqD0c?=
 =?us-ascii?Q?cfBQ6jRkF5cvTw2SDG8Wcbc1qFDCn8ayzh81VYq+xS/Yw73o8lsopatIo07f?=
 =?us-ascii?Q?xO+5IseBuH/G80K1E5K1SyT4YsM7jpydRz8LU+rlXOE3naKJGdaPpb40QoYr?=
 =?us-ascii?Q?Qbw23+EIhdmnWSIvjA5l8UgtS4wYQutYmoTQglhSIqy1QXGOzBFbrMHgiYTE?=
 =?us-ascii?Q?nrPAVA+orcQjseaC1IenHHJoznFKM/HJUQm4xk7d1LtXHeeJn0++JMqsXBtJ?=
 =?us-ascii?Q?0BEMFd+SL/NnBrzgQySoh1CKy3AsKfpjjNdKOzz8iFUEUZD7DPm3bSoUvAi7?=
 =?us-ascii?Q?r7yrqK6om0txEsJ1VQvOtMFThp97J5JmWLJ0fo7CmVkl+RYqrJnc8Uz7T0kD?=
 =?us-ascii?Q?rL8u8sZOAdYMJTiUZOabIFHP9BacX9kxZXuA21nKkzTbNev5VUG56MU85vZz?=
 =?us-ascii?Q?s6NciHHR4ZUYjjJ2LYloM3FF/WgIDVeEvppRIBKpR6xFPQn5S1739taGLEnX?=
 =?us-ascii?Q?1GvFCojXH2jEAAG7sOwDnU8O+AeV2bwh6vaOWFs/x9T5YDm9aSrrYVUdUUW0?=
 =?us-ascii?Q?rY0OVKwDm/SoGsp6qfj8NTg4LO31B5P3vE9vPguISFtve+bZWTNppDlMsqXE?=
 =?us-ascii?Q?yIGsx/ukmzOl5kVrmmBbxKpcjEop4jNZ+97mpvzdctXQZfozp/577eKukA/d?=
 =?us-ascii?Q?Wr/JAWg3Oxlcl19zvuw8evzhsiBisJleYn/HYh4PW329JBQv4DIpZB3I78/U?=
 =?us-ascii?Q?kmw7a1407nhfj64N3KdYunJDgzMJ2Qa1yAN/RY0OFosADismcvHplVIhe3AB?=
 =?us-ascii?Q?GvOCy48saEwD5Q3mwTtaTnrQsRV7iXLor8UcWkPY+nAh/N893xY4dtv9siy7?=
 =?us-ascii?Q?MyRrJynijclZ+qQZjB5g54668+iczBH68Mb5evEsQUkEjT15DwHzKyjbi0Fl?=
 =?us-ascii?Q?0EsJo+dWniJNoyT46VZ9SPTOLFVSn6Y34wMY8tkM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a43b2d1-a06b-41ce-c277-08dd50598a24
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 20:19:25.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECWm1PtQstLWDhtw4A4lklwW89vV1aVz7xIZWZYoHWx7SPS1DQ0lpO3P3UWCiWT2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8330

On Sat, Feb 15, 2025 at 04:48:04PM +0800, Baolu Lu wrote:

> > +#include <linux/gfp.h>
> > +#include <linux/mm.h>
> > +
> > +/**
> > + * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
> > + *                          specific NUMA node
> > + * @nid: memory NUMA node id
> > + * @gfp: buddy allocator flags
> > + * @order: page order
> > + *
> > + * Returns the virtual address of the allocated page. The page must be
> > + * freed either by calling iommu_free_page() or via iommu_put_pages_list().
> 
> nit: ... by calling iommu_free_pages() ...

Got it

> and
> 
>  s/page/pages/g in above comments?

There is alot of historical confusion here because it was all designed
around alloc_pages() which allocated a list of contiguous pages that
could be subdivided. When this moved to GFP_COMP and later to
folio_alloc() the subdivision is no longer possible. So it is not
"pages" at all anymore, but a single "[compound] page".

So the module name is called "iommu-pages" but aside from the free
list functions everything else acts on a single [compound] page only.

If you think about it too much it makes no sense but I didn't want to
rename every function. I tried to keep it so that "iommu pages" was
part of othe module name, and function designators, but the comments
talk about a singular [compound] page

> > +static void __iommu_free_page(struct page *page)
> 
> It's more readable if renaming it to __iommu_free_pages()?

Ah.. Well, it captures the module name but nothing it does acts on
multiple things, since it is internal I used the other name

How about I rename it later on to:

static void __iommu_free_desc(struct ioptdesc *iopt)

?

Thanks,
Jason
