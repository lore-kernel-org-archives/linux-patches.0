Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C1E209F3E;
	Wed,  5 Feb 2025 18:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738780805; cv=fail; b=FseC3kE+Bu29cBgn05H6VfrR5Kb75c4YMzGA0LhxyCu52+cMJnxOBEzKlK/dzySkpDIxXhd15aRhuQwpZg0ercpFvZP/ArI+pekDj686AJelZ8zuVYzLz9UZogYeHMBGxadA7uy+mlwUGlaDVtHPMzLcskMrgrQlzsSHj/gm71c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738780805; c=relaxed/simple;
	bh=iWR3bQ7MdIod0VMlYfp2ceNzJuBsaLGj4in/tWFxF0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u0GPZUv3lz38U3yK6Z58bvrKuE2liIbzODjtfp/I+AY+yOZGlPe4mWH1MlY26NgPaTyeis3O7lqp+t6SY3QEEUMQ+OtY0nt3LFsC2sOdfrbcnGTqpjSM95FIzEOalK78DJ2YjqQHP4T8jiF3tX2kGkCmnbT3+9W7IVTIQfE1LK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J21qvWLA; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J21qvWLA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eF4w/7R49wqUQiZAZvs2gWuMzTFtFF7C8a+9lXi56Bz3mf6jCOeWvTQOKw8tqSepM3TVBCpIoLCx0kgiRJy/UGU6LVwOSb/fsAwTcoW1YKK0tvB/Y4y9gx/LtQE9GUucrpaG06MUyo973gIWaKMtkEIu/UONBymHUWR+27GuNFNHCYm2IElmXnxapSoFrDDnPYtqDvGX9OfEWrUZxOj8oCw648nIYrBvX0HL1udRDUZbC20s1D/kZ0i7LZlHPYqCOC3Vh6F19K/xs3WW9FIKdb/tbLTYGql3Zdk0Q4QQvIp0nugjX0vjogO6uWXR4uzOEufsF+wEwb1yaihYGN4DuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWR3bQ7MdIod0VMlYfp2ceNzJuBsaLGj4in/tWFxF0M=;
 b=d7RA6Ue1TwHe1F/8WHL4bFCHXYMOQ2Q50tEJ5QCVZ6R1Qhm4Kf+INYQN7utRu9OlNB0g6RbwYk+oaAdQhbNnYVtfi4F+5QrU9EGO1jSvQ/tGvKPYdg98V9k/zTvTe6cjq51NmMYGYRuQr+cAGlCWmzMRmdKzQ+CFosWq6CUuEviKDKleXmDpEs9QruCtP3WuHh950X+7g8B9e0q1Te+ROdPWXbraJcjMepsQ3lCe6kQZgKFTb6iKuXA1Uj74UGZCflsNn+JXkp6cM7Bgl/EX3lPAS8jE0VQ7Roh1Sity+ATaXvhBXERJl9F4851tO05Pyhbq8gKJNet3OF6OSTe4Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWR3bQ7MdIod0VMlYfp2ceNzJuBsaLGj4in/tWFxF0M=;
 b=J21qvWLAjTEnB8YF/4B/zZPqRuOOgtsp1eOzbF5yPcAo5PBhh++S2wi/Yxgk09qq3LdfvFr52bcUOVXtJlHgaP/2wuQj1BkGPm8M6dBuFVYzcsh1c/XO7mNxYFZ6/JsovHEtsPMaEALlPphlZs7ymfy+sq7WnII8zvB95qlucTU8NGmMq64YAJOeS1+yffLMReJfDcneew90WfoqR1jrzyYZ40eGVuZV9yzmW40/T+A/ms4g5XokoGEfzzcLP1+GrdYjiqXsbDnDCDloo2zPu94GHyCd+RmvGPCzlvWtAawHrQfvNEvaQPQH0yIp2xghSDRIAHrwZT1KXW/rBS0pRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9201.namprd12.prod.outlook.com (2603:10b6:510:2e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Wed, 5 Feb
 2025 18:40:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 18:40:00 +0000
Date: Wed, 5 Feb 2025 14:39:59 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
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
Subject: Re: [PATCH 18/19] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
Message-ID: <20250205183959.GE2960738@nvidia.com>
References: <18-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
 <23d4c47e-a00c-4f15-ab42-303bd2aca032@arm.com>
 <20250205161017.GB2960738@nvidia.com>
 <78707443-7525-42d4-a538-cb0c67cbeb55@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78707443-7525-42d4-a538-cb0c67cbeb55@arm.com>
X-ClientProxiedBy: BN9PR03CA0706.namprd03.prod.outlook.com
 (2603:10b6:408:ef::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9201:EE_
X-MS-Office365-Filtering-Correlation-Id: 18629847-806f-4015-d13b-08dd46147ef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ey8FH3mh3YZ2rdJLCS4wj4nacfmJobD34NF4dW2M0FCNMtAhEWDOQ5mfSLGt?=
 =?us-ascii?Q?QVISt9gXUjwSl6FR7+yPiDEtJy7E0pSdBeLbn5W5PrrSxqEWrgEfGhUstKX4?=
 =?us-ascii?Q?bp3TecENSEhR/x5tpwW+VoLOX+1mQ0d4ml+G3trY9fFZIG8edIR0iUd0GpA5?=
 =?us-ascii?Q?ElthAcESTukazLEHo2Jlt8JVNNbRtsff5y870SJWgqr/hRlQTTYnaw73vkt8?=
 =?us-ascii?Q?6AEpy/xinZJt1WadRYnIEmonfYbQyVZim/J3PWTsCxFzp0iun5PoamhUZHhY?=
 =?us-ascii?Q?VtGu9rnRA1wIO7hBt1eC+bNW9HrnYrDhxduSUBuYHq2XGVMYbdS7VxQmRYPy?=
 =?us-ascii?Q?tZnRgJpnpg4gr8UFAVYSvv2AJvOYb0cTn/4RzM0ii2Ntvk0lqHSwStW1DbrD?=
 =?us-ascii?Q?83aY4oHOC8TbVd8gwTFf610fEJUx8M/Ejmuhb8g4jxtinRfHvrNMz1g8XTEW?=
 =?us-ascii?Q?klBLCW2kYsSOPa9297jUat7zXlOWGiSJAWDGv+yAYOhRBvyKWysMSqfcc1SX?=
 =?us-ascii?Q?2CfDXJu3OTacRL5CePY+cAg4TcYZmEe+s14vLCmPBP+aVNvoBqfzZW3XGjVT?=
 =?us-ascii?Q?pLqgXkqrmyXlK0VkndvXokzOfunNafXTc9zcRjHDBJQC3tRRndes42xMzru/?=
 =?us-ascii?Q?5mzBThqq7cx/FF7eIaMTa/uViV2JtNQFWa8p4muqTmX+e8jlozDp0H8rE8CB?=
 =?us-ascii?Q?L6+HwKbYgDs1n6KtPURHjNNWJxpvX7kgcqafDwQyO2ckcNEGak0r97wUJNtr?=
 =?us-ascii?Q?BHvdjIaPqXCs2U/YEzIPJDd62h0EtEZj9qHlCqpIr3lqDDM20cNU2RF0meV8?=
 =?us-ascii?Q?9XHy4gRy9RDVzw3stUYJvQ88Isj26u6VGbY3Dvsw2UVrTkdva+Pe4+cDqLMg?=
 =?us-ascii?Q?xR3JJX3TCjszr1lt8DhIxCnAlltKwjwlFe0JLzTOPP46yZtT0JugybfS11NB?=
 =?us-ascii?Q?MxVlVObj+t78/Mw7IyhZ5EoZt3EJnedQQNWskrgeUCHUGCCp9rCaYDXWdf7M?=
 =?us-ascii?Q?RVZ6sdfL5caiwyAOc7SxqlNAFOx3AZYnQC0k1kzQj47pFnRn6D9deTpg1LKf?=
 =?us-ascii?Q?hsZi+eocdzSJAcrl9HH50G0ZXUQMTDXZ0Tu8V4Ftr+DuRp5x9R+R6L2txOd0?=
 =?us-ascii?Q?YinyVo4znfo1ZvmLzTtoQaIfnVUlMmZ/GWFFJz20JiNS/3XWaKwslnGZp9Zc?=
 =?us-ascii?Q?eZNS3PdHVAhiMWfwQ54nD1LWKfrloS01koH9N47Ee8VTNZFGgnndz7CF2GBm?=
 =?us-ascii?Q?U2jjLWhVzKtFgrdtEBcAHx8lOZS/3loqxpSJ+WqJTdzojtNsttzg5XEY6Wzj?=
 =?us-ascii?Q?VfV5JN3p/P31EwM8PTZU2cP/I5wNr4oOeAtcA3xnhbnIi0FOShWe2vxcoTVU?=
 =?us-ascii?Q?nYgYTELDjCNLagPw1bDgWCZK3whr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fv0QfMKYmfqJSq1eK6ZcvlT20S50YLT9DabTx/aNPPQ3En8sk8t8bq6ELdQ6?=
 =?us-ascii?Q?kGFVRWQ88rjtGvbHNItR1cyGi27mrVRtask2lxjiIEF1oAgdNKBnKBfmoI2B?=
 =?us-ascii?Q?QrrwBedEYZDZG66oNk+LsR8K+3XBtMZakVzQ1k/KNcT/OCHU7RfLFvfjnJvl?=
 =?us-ascii?Q?3Oxi66CyGLXuuuuBWimg4M8H6IjmmqoimCNRKYkn9iZtLamEwPjnLy/She06?=
 =?us-ascii?Q?6yYmdOwNirX24Bxz2eZ9WBSF7ol8ReSXnWL/lfeIt1OtYh+Tz2WLk97Vn/3V?=
 =?us-ascii?Q?/bXbThuO5t85C7pa7y91Bb25CX1gES+XZfqaP3xCKXAB6pLp7cUsvRZas3rt?=
 =?us-ascii?Q?AiXz/hIxINEZALGoI3RIowU5qGtZg4QQrTUqJa0T9H4P5Y7mvXLx6N2dqxE7?=
 =?us-ascii?Q?5y0PTPwg3YkvO6MLfnTOEDDI3kOHrYfwetjJOpmQO96ID7sr2edOfGrqMQRO?=
 =?us-ascii?Q?Ij73uzcTRNUzC+mtbfQj4Ap3RZxNRKVtX1GsnpRnWqiq6x8ZK7eh0YYWrgR1?=
 =?us-ascii?Q?hM2FBKV6y1VPfFgQYGekabKkhi9OHLXaCywVv42dQu8Xv9wSHb8cm6Di5IkD?=
 =?us-ascii?Q?JvZ69El9q//JyYEZGqgNHJJJBCiFrNqex8w1purfGok/A7+oZpPGEhmxPEPz?=
 =?us-ascii?Q?za1KqP8dRi6nHWuyZaxVFNVZR1efP0Q3U39+CzMUUuOfiYmEmoTFOA61LdjH?=
 =?us-ascii?Q?LC7K3Re0T0hw7s4nnQBHDsGPdOeH0t1BMtAnRB1azagY5s7LvNyiB0QiGtBm?=
 =?us-ascii?Q?fGjv6MUSYHBTgoGaluR5jWY6wwuq7SrxG3AwmezZeIrhzt+q8mUzpngQlLKE?=
 =?us-ascii?Q?HiLTVn9/jJ1QXdV+YJ0d6UBF7t7yHyTf7sOvpY3x+lxdvGc3NwTG4PiuewbZ?=
 =?us-ascii?Q?dBQRJLEtpAnFP/4hX8R+AHNpxUPhcmtoJPHAqqcZLvu5ykrZiVAQ7Kk06v4j?=
 =?us-ascii?Q?utX1SVTvC5OL3EmUPviCGq+dLn3J4g/tkB9+6hHy1YHE+iLk8+mBwTyNZX05?=
 =?us-ascii?Q?wY1fUqjGcQMTtZA4WrzzXbKb1YUsFAHN7nlmeXQtNg+yKm9eMA7bwJZEp0Vu?=
 =?us-ascii?Q?tDXe45bDNtWPnlf37omba1lIzVc+I7xrR0T6t4kLohUJOynDI2tOuhdY+/tF?=
 =?us-ascii?Q?l3IVtMmVosm7uirprKUzxP/sk6zuNqzLCFelHYqDBWrbdg92n108Oq2n/LJH?=
 =?us-ascii?Q?VPN10nn4aPuMzYpGQf83JX7OQ5iisXBm7jtnFgLChQoEzJgAwe212qpjxsXC?=
 =?us-ascii?Q?BjQ2BPM6j13KCHZhpj2czDyKZzsdswYXi/hNQ78eErEVbw0r8KrQPon+Efqw?=
 =?us-ascii?Q?mbhFrqJEDMvKZ+vlwmLIXSVdYgXgOEMeZpgrMsP5snZq+Zp5hHAxYzl8x086?=
 =?us-ascii?Q?t91W0oG8xVbm3TeIb1Hg7/3x2kbthvnud/2xEafAOXxrjuowabEskvsKev67?=
 =?us-ascii?Q?+F6hBtcjtnuT31dwc9L2r+T4tUUdSf/edlKYLHg5HaY8hb+DcAS8girMpPAl?=
 =?us-ascii?Q?8ZJG4LXZq8WGh47n0X5UeLeHwzYldwTVr9xcDAChRJxaiyxCU9wfiDQMRSlX?=
 =?us-ascii?Q?rJCQgNSVf8AtTLwDzMaCv7dFNz6NeC5o355tVae6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18629847-806f-4015-d13b-08dd46147ef9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 18:40:00.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pewDtukbRZOsvzU1AoOmQSZ7b9Doc/j58qM1lsqeiDhJowc3qHN+ib+LaH+rjHmT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9201

On Wed, Feb 05, 2025 at 06:03:54PM +0000, Robin Murphy wrote:
> But what's the benefit of having extra stuff capable of turning a constant
> into a different constant that doesn't represent anything we
> actually want?

The API is inherently log2 based, like alloc_pages() is. You could
make the same argument that alloc_pages() should accept a size and do
order internally too.

> We still end up doing more runtime arithmetic on lg2sz within the allocation
> function itself to turn it into the order we ultimately still need, so that
> arithmetic could just as well be get_order(size) and have nothing to inline

Okay, sure it isn't fast path or anything. It just seems weird to
start out with a lg2 constant value in most callers, shift it to a
size, then ilog2 it back to a lg2. There are few places that don't
have a compile time lg2 available.

Jason
