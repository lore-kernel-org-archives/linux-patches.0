Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87CF1FC0ED;
	Wed,  5 Feb 2025 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778399; cv=fail; b=DSkELaKNCAH2CDWf9V4WjNZPPPbLNXyqruDY/VzJq3IL8qIpQkjIU+KyQYouJc4put3qt2MDa3KJoH2GXizuVwPznsFjIwlDl4jUHAO5aUTt/F7MSByY4wMOSrlCv0wIjS9SBomSx/ljCEOO4AVwaTLvOg8NKvR9QKLQwzoVnRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778399; c=relaxed/simple;
	bh=MqEgJ8ksaovOGR/VZELSMMooO2u3ra/PlkScP3cohco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y2X1YkhSWXxNdRMgY4tabslxo272PH7K24crFXRQqk3yokXygYsOwGq3vdnoZeIHbKOS777I4qj0rRfPJ/3+3S1qJrcV56zhxnbLbE1lg6aA8MKbZiSvYYyCfT1dCV3/D194r3HErMk/fDAQ5QEQQUsYU9eX0zGOFXg1h+/2ROI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h+v5k+so; arc=fail smtp.client-ip=40.107.95.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h+v5k+so"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q5ooXZzIN9zCqq5aLwNF3SPLRjb2PfppCMRUVZOxwwcx5/Fo9+xrDFhm6IHZit2fITbvHU5ZOPfSfTUdeFMF/eFXhF1fee3i5elKUU05ZiWe3YbDOyPW1iC831KIl7cw2OxzFCGzM/+PtYD259evcOeHGnW3v6YJ5NBZ4M13AYOGtWVntzqZhDs6iWCuj6WmHTOwgvLTaAeBYVis0eQG2Jiwb+1cV6Wiej08VofoWJ9X4nHeOS0DCPf+bjrGB60rOno2bKy1PmI2vkRYAFhYy75MttqN4mNYoag8Fck5w+Yrw34yePjNSZWvnlt4sy+T2KSVFyFZuSIvRpIljHd0Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2yHKtpQI9m3vUwXOhfbeXswLVWhx1E7YoyWVZ0Fh9Q=;
 b=FJaG1tAcC7Hoj+YnUS06nkSm+cIDRApMnypP4FRj0KuAeHUOnOrV3iBKZOSm9HOmyfqeFnC6TzDCntNC+CyKqQ51mAANL8Pwr9FbA/BIjITZ0Kexv9n0O0bcvJnTMMMVgVkgvKF+LFcrMR1JwDK6trCVDYhTlopV+xO4mTX4iJ87MgGS9GkXObjTpR0t4TFt7iUKRKuciD0hxeDKreH9XRHE7Qj8vf/zwLOqgKLwec9FhSgw1qGKSUvyH6nJ5Ngl3n6/WkqkSzvJeGEsyuxsq3768TB1jDASTAtvN1RgUbC6Vqa3oH/J4mmsiJp3mAZRo/aU04eW6KYc7fSYwcteMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2yHKtpQI9m3vUwXOhfbeXswLVWhx1E7YoyWVZ0Fh9Q=;
 b=h+v5k+sonQ6enjKRVJW4ICjib/BPD5grJq7oLwieq7O9sW1f21TwD9CC4Xwr+3TWbBdzjq3bwiyHJAkEsUbOB58gEzhtwitfuRu83fJGmtNVwjDlZwkjLHzKpVXluxK1VObVs2aXRo1sLIqti2EYjGpY+5YdYKhPGKGL/IgtR2vszO7vBXxrhwnbcsDFmmpUVIId/ERBcQLQk+ATEVQE/7XUpZK1ihxz31ofmJEMsBmyEhU6rCGxylF6bhLwiE3O8pDGT1ZRpcObXkL8mfaP6c9Crjr67cPyG1kSRfoOMSN4HOxhEsMk5JsaPDdwGb4ZaK8403X1sFYWEAda1UcPYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6985.namprd12.prod.outlook.com (2603:10b6:510:1bc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Wed, 5 Feb
 2025 17:59:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 17:59:54 +0000
Date: Wed, 5 Feb 2025 13:59:52 -0400
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
Subject: Re: [PATCH 16/19] iommu/amd: Use roundup_pow_two() instead of
 get_order()
Message-ID: <20250205175952.GD2960738@nvidia.com>
References: <16-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
 <f8d73cd3-f85c-49c3-8b37-4eaad0255860@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8d73cd3-f85c-49c3-8b37-4eaad0255860@arm.com>
X-ClientProxiedBy: BLAPR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:208:329::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6985:EE_
X-MS-Office365-Filtering-Correlation-Id: af149b38-9b2e-45f8-ac3f-08dd460ee4d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5QJjDzw4wYSu+OqYaLQ3ZjecdkMs2N6hptSwHEda/g7LFHEha/4n8ltdWX4M?=
 =?us-ascii?Q?guIGcPwrsqnXXIVzz2ZaMIy4b8ug6lINotcrifiqNqPMX+0wfGhQk/0SmpPt?=
 =?us-ascii?Q?7zpfQDsfYyCkA7WinUE+mmv8n0mX31Ki1bnC3+qpycSFr33zQlZ/3S3aFu/q?=
 =?us-ascii?Q?3RDOg5n5M5NnpuQhRhO2QmuGnCuqA1Re/qE9+jJCjw4C59rgzfdSsS/k8vLR?=
 =?us-ascii?Q?JjUadptRMCGFZJrhH1ZiMDh5w9DwqFtX1RgSefglbHYPjxIRbdlf0mAZzhfC?=
 =?us-ascii?Q?teVLGjEr2WG7BrFjeMa0QPG5EPs/yXqePNjuuHf/S4aQcjYZ9AXSgUrlJS8I?=
 =?us-ascii?Q?xqQcw+gzCmLaejEj2yK1SE1/OKyM3LreI8My7whdXwZPeM8RWGQUOjxm0xHD?=
 =?us-ascii?Q?VSy8devN/t9K+Y4kltGOkdNBwYsytCcAOaC0Dxrya2ida1dJltIUCxRmzpru?=
 =?us-ascii?Q?IBwd5UxDEe3GHxuBC2z0yUokMKZebcB/GbX/D+4tcITMnB8uNVMq57j0LJD3?=
 =?us-ascii?Q?w7xUVAj1Lh6kU0uvBtphFEeVBgSGSgLmO6w6wATX5gUgxzDzmzLKLg4BBT9a?=
 =?us-ascii?Q?lp2JzMF/gYLmPWZTUvemZtveyt490pxrxFBm40V6Pky8/f/S59MYBcYZejW/?=
 =?us-ascii?Q?yzIjIM/kMmfoZv3g9JGXhKsbvvJ7qcjItNnfrouj47Tj2YiSiU4MvNllypRI?=
 =?us-ascii?Q?h7ct/ZPWRPcc2RcZTvt/i7J1SEfDJ50+hnteKpP8t9DEPtkcypxCITpLVd4/?=
 =?us-ascii?Q?U0JmYP1zN+ezPQMWs6F1+b6zWlRiqcyqY8LdGxwzMhOTy2khDkkj+AFAAQOj?=
 =?us-ascii?Q?XrJ3LuWVIspru+OKEGkXNEJE1pNGz41UP6nhvyVwxcbof36VhBv+Jbd8lCt4?=
 =?us-ascii?Q?DY0Umb/MtlMbooOWcdgf5eGYd+1esy5SB6dKEkP6PNMkdxSQLQvs95CSGU2K?=
 =?us-ascii?Q?v5X01WJgcKNaKbLSyuJNPdoZAoCPo9jjh3CpkFTF7WCVWd8jGDuXR5bNBDQL?=
 =?us-ascii?Q?/la9WkkqkZMizS6HSO8EEyhKznQ2kscldSzt3R3ZnKNweTa5v7A/6cXdi2CQ?=
 =?us-ascii?Q?Ffj0VLSanvN+vzzU74SNRmOsL1nf8Juwmk8el86+setlwlH4pUDM+xPORIos?=
 =?us-ascii?Q?tbJ50j4TgfsHfATd1RehOjaihw2++TcF/Izrt4AuxxkndNZYTLV0W/GEpDkd?=
 =?us-ascii?Q?EK06mp1xSldyILptRwQhPvuANf48a5iK/NxR6R5TpN2y3Cy3zpeHxAKfj/je?=
 =?us-ascii?Q?aXPYMFiEH5VUtKPZBimROtOGVmezkusZSXzprDZZnW2t78VJ6u9vhUzAKeDL?=
 =?us-ascii?Q?q5y7R/dy+hZtJnYidh/WMfTo0ztb4084XU5sq14ocMjF2Kjlkor8mEjSEZ+y?=
 =?us-ascii?Q?YGM7i6bNYWT+H6yjxVAlSw9UQ57O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I6/pcEVimQUPPOKWMW/x8zeE3I40LGTsoW9JRCiOU2BzKlPrN97DChfkotTl?=
 =?us-ascii?Q?oVbhQXbA4JrY3uGdF4d6uyJzPDs2ZS9qG1VxNK5+x7Qc7r2FqOxpiofTiv9k?=
 =?us-ascii?Q?3QRkO2UtgdPWAvF4dAnKgm9rNoAkVwJI3BSg6Ev21MAZbRXRUiDBE6BbVopx?=
 =?us-ascii?Q?FQOs+Lh+xQ0dSwTTicaYOl43gnK4+v2udQeGeppA14zriAdEP+ytdjmF6hzb?=
 =?us-ascii?Q?k/aQWFyFQHEhsl04L0QBiTK+BAo1iyo1kH924PBmUdfB4uhKO2cYbb1gaa/h?=
 =?us-ascii?Q?t6dH5Ceem6yeJmzHsu3ooTwCWNIB3QQfsDlPjkniR/GWyCn6EgPF6E1tI7eH?=
 =?us-ascii?Q?KabAINkNNtUEdOZM/khQb9ir4dYwqDxiaBu2AxzpNLs/qEER40GUR9/u6UcJ?=
 =?us-ascii?Q?xj6/Bd8GAf9pgBEWspf1PIlJHd0PXsxKO1MyTzuUQ09DFgA08pKLYF3Q1DAV?=
 =?us-ascii?Q?GxgpMY5sMVmh3eQvMRbdoB0u9oPSTVY5X4pTr9b+tbF4zNG7wvS6bncyek43?=
 =?us-ascii?Q?hXbxed54ZpIE1+vHuffS8wvBuoIuJQB5541OLrLdh+3jijpigLvHlUFW6WII?=
 =?us-ascii?Q?WUA+zlvd8+uo1BIxiEY9pYFa7ux6nESaygg4EcrX891hoWHTNpPC2IS2y0Hs?=
 =?us-ascii?Q?k1coO4X4z5yIZN9ddguIhFbGkDfNmmUoHa5ka2Qp6dsg/NfovnRCjKYN1Ugw?=
 =?us-ascii?Q?XyEzv56jpxJYA6KhKAjViajvxqT9797LfF3vlUKympvyL7glR/bFdq8pTipK?=
 =?us-ascii?Q?kQb08CGi0NF8vHbRVczPWzdPAdJp7WuQAK8eAxGnGE+jpr0122vSb7GjbkrE?=
 =?us-ascii?Q?lnUqR5e/2WxKzmZ6V+jIQEiMV4tcBMO0sFdnKLKThXq0byw0becoyAQi1td5?=
 =?us-ascii?Q?aQ2xzSfia5dyRDHUcqplpuG2DmgPJti7eSpY5v0GvWY5yIybQEH5qT/owv05?=
 =?us-ascii?Q?opwfwgeaMl+VU7kmB19c2tIQFd1xaDeVTSfQMyy/gGMjAJeGMta6vYx7Th9b?=
 =?us-ascii?Q?OWTVG7MSQAKsmxuN8W9vd+rxv+Yc0KZXvmmhtonLKWNS53iACYtq0dDUz8aY?=
 =?us-ascii?Q?Cyf/ilRGkmHDp3STr2/crho4Wnv9ahzk9djsYTrLTxbvJ2rbl8KhzYvk5QmW?=
 =?us-ascii?Q?CiN0Rk52F2EyhSpRPq5Vor9qCqH1UHcNxDieQwO3Y2srB7WSAYm2DE/dKPDj?=
 =?us-ascii?Q?3FN/rU8Ps8jhv9Ti+NR6HSeWs7imgnE52Tzf16jc6wqc2Y+ibgdNXxPLdWMw?=
 =?us-ascii?Q?M0hgTmex7x4rpTj33pO3G42eo3v5uEkItdCT9QR5k83yBRLaEY1bHJIfoRpK?=
 =?us-ascii?Q?85atU7ZoTOcIKHu3lN+I4jDHnfU2eTDuxlGyYOmXvhdiAVrJZkmkNLebtlL2?=
 =?us-ascii?Q?efIcIw9bGV5uFgKjfOTyjQDdWyvDxrA+W8R7Om2u3au+9KVJ40aTURFw4hWf?=
 =?us-ascii?Q?i4dBSYeRYQaCqxGYNvkKFaE8kwGqGAc8F7KIqSd5TcDitvwd+llj4Fl5GrHz?=
 =?us-ascii?Q?bn14sgHNkcAOuTSS5wVH47snffYsNkuAVj9ZA6XofEXhWcufAwB2drEaUzgY?=
 =?us-ascii?Q?1wETC471IB9IwJzPMlA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af149b38-9b2e-45f8-ac3f-08dd460ee4d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 17:59:54.1214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ml+PxoXwEE2ObiRw40kPzIaKFael54H8AcZOGBzaNTwv4+ADmcl8uXeX6pep886i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6985

On Wed, Feb 05, 2025 at 04:11:00PM +0000, Robin Murphy wrote:
> On 2025-02-04 6:34 pm, Jason Gunthorpe wrote:
> >    1 << (get_order(x) + PAGE_SHIFT) ==  roundup_pow_two()
> 
> ...unless x < 2048, which does seem possible here if last_bdf is
> sufficiently small. 

Yes.. I was thinking that sub page was what this stuff wanted however
I missed:

> but I do wonder about the use of dev_table_size in
> iommu_set_device_table(), and whether this change might break it, or
> whether it's already wrong for that case and this might actually fix
> it...

Indeed, the spec says 4k pages here:

 This field contains an unsigned value m that specifies the size of
 the Device Table for this segment in 4 Kbyte
 increments. The size in bytes is equal to (m + 1) * 4 Kbytes.

And it certainly has to be algined, so it does need a PAGE_ALIGN()
around it.

I'm going to add another patch to change rlookup_table and
irq_lookup_table to use a simple kvzalloc(), they are not used with HW
and just need to be some simple CPU memory of the proper page size,

Then do:

-       pci_seg->dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf);
+       pci_seg->dev_table_size =
+               PAGE_ALIGN(tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf));

To fixup the HW memory.

Thanks,
Jason

