Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011046.outbound.protection.outlook.com [40.107.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95491217F33;
	Mon,  2 Feb 2026 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770046201; cv=fail; b=g3+imxygS8xHLH+SpIGvNc4X6BQuWL81yoeE7JCUAZ1JiO3xl7CudduWijoGq4PZVodqCVe6VYPYupKrO2F/FzatMETZEvQZiHI2mg+n69jIkknAWkPqaa0t3zpsV9/Q0NabuB2jJaFeYdWnBIpZ8AJE1F++VZOhwVMU17F1tLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770046201; c=relaxed/simple;
	bh=BbuqM9MSTUT1ExeiYFTkJLAoNh84JgLT1PJ4rfVX+bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nsqpWzmKOfJ1FcCsGmrJIBGtnyODKg4WAQ6pRs3JF9DuPUOoE05ujMZwQrxA8i9o+2b/7dnJfjOqTc7H9nNhtcW/CoibOvLGDhjsf06UaUDGx4Lx0HjXaFzx3t00OubuwaYsv0SvU9VQ7ZZ7aWFAGFi8h0GLpUOxqE9EfUvF8vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YoboTJx9; arc=fail smtp.client-ip=40.107.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YoboTJx9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u5yMCGZGAKKOn7Xa+Xh1/Z1YeMamTfpFp5LMveflUZrby4EGPUVyaaMQPuiQXiqEHWL12F6+0DNybndCvQAqkEdUCs0wYLabk09vGP3hBkC7a5QrWS5GO+eIpzXR8Qha04uBWaviepnrleUbJbgIiYtQnYmPM0yreFcadFK50V2+5kyM/vEJ3/jwbMAqcRtYr+AY6TZJFXA+nCIZM4FMrFQ1kGVPAC+KZhwNHxrI90GHLjXObjLAOrdW8Z0KbgdqzVqb5smcHtpOs6Yyro6YOmKFyCHiEypH3WU7Gk9g5npRKc7+HdfPr/5podYwuvZ6i+D+3f3hqEX6zEIIb9Y+Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbuqM9MSTUT1ExeiYFTkJLAoNh84JgLT1PJ4rfVX+bg=;
 b=t0mtDuneg/+BWPKe7dajYOEcSqz5ByYSUtyVLaobqeQiSGzVGSP9VPXD2TXcOF9dMgB4SqhFKsFntn2MFa/dMT8lMkSI+uLAr5iC93ZbMVmvYt6nKlAYPC+fyY/mpE7UEtr4yUnvJGpy6aNyalE7Whelk7XDSVFN2rR749IZ2E4boi75TaJe6GbHPZWlmSIy13ltBp8FfeVlI7bTUbFWsg/ubUWcfruGSa7UQP5DvcbrE+M2jaj0+fTiPZ+ygc2D1TFqwlR8MHVPRCA1dj2N1qwn1k3QBdgr9MUmfYWSAxIJ6o6knbLjp7gPy8lOtsAsQpRiLmQG6FZFFZzuhN1lWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbuqM9MSTUT1ExeiYFTkJLAoNh84JgLT1PJ4rfVX+bg=;
 b=YoboTJx9L5dabKgk8BEqOEerrZ1tBHj+v/oC8oY7oHN2b578wpiW+PdJq1Tvmb+ZM4T1t7ZVrk8KSCHXLRhXjhA711Ll5Z1qgBRNzHKKWTpxsDGXNukmwI7oNhUbBEjwCtxX0yUyQXpwEktLB5zSDlXt6ScHwaaQGHZ96c5lyCoXPi9aqs4BeVqb3H3lkJXP0QIbyhV1k6QTvbwrmM6rYrXSUL4NaLmniouYgsEq5ZMyYht80kCfbKP6yrrnpl+XGgV6kjcf4D5KuJYffycB58z7JipRXLj/Rj0emHGQRe1KxubLFuknaaFAjWREJ6Wvu2gq1LwqKgf9TtU6Z/T4cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7911.namprd12.prod.outlook.com (2603:10b6:806:32a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.14; Mon, 2 Feb
 2026 15:29:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 15:29:53 +0000
Date: Mon, 2 Feb 2026 11:29:53 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Tomasz Jeznach <tjeznach@rivosinc.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	lihangjing@bytedance.com, Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev, Paul Walmsley <pjw@kernel.org>,
	Vincent Chen <vincent.chen@sifive.com>, xieyongji@bytedance.com,
	tjeznach@fb.com
Subject: Re: [PATCH v3 0/5] Convert riscv to use the generic iommu page table
Message-ID: <20260202152953.GQ2223369@nvidia.com>
References: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
 <CAH2o1u5-VuEUJp2MNb41uxQJk=SR1uZbQkiqQWoLBj-+GXTVkw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2o1u5-VuEUJp2MNb41uxQJk=SR1uZbQkiqQWoLBj-+GXTVkw@mail.gmail.com>
X-ClientProxiedBy: MN2PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:c0::30) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 1368a1ee-aa27-4c6c-b5de-08de626fe9db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uE/WkvohaGX6kT4sZcrhm5hl5tUIXbWar0GsjrAh6ryIf6QMAaG8EvenjjIp?=
 =?us-ascii?Q?yZfGxJLmdcOMUt6DTRAr1ps5+9BP7e1636CxOcDopNCOsyio3XHdrMhFRd1I?=
 =?us-ascii?Q?EMpTJ3ZmlUPsFs3M6urflNmfOOlvS/pX0K/SvWVrW4W4V3cdkWLSWjfab80H?=
 =?us-ascii?Q?BJhnfIEt9CX/4Xyj3/j5JfsubpE4ZtfbtOqS94uaGtA9ElxH7z0NdyY0gwna?=
 =?us-ascii?Q?CM3fyvTKQu6IfSjIAj1kGgAHlbr9dIXchEzgQt7rH5LzoSjqCZs0RRfvtDiC?=
 =?us-ascii?Q?QLgfwGzEZwW9Rec8XIsczFGaLzjjQs0bZPUdEJzUpGkC9O+KWQekpPyYJj44?=
 =?us-ascii?Q?dX5XBL7AndyT/qFOTxxr4OJwBYNBcO06wnqyzJjnR79/y7kCWAwxyMZCJUAa?=
 =?us-ascii?Q?DXqq4vRgkY4PfuLfpJMe7q64mIOHpzsKD4Vvpv7RJE7jfhkSux9BOzTrKC/I?=
 =?us-ascii?Q?rSZuKvDqXZ9vG38MC2KVo/R0ma0e/1XdwHS36rrzs69+HnoT0bkGoNNg00Y1?=
 =?us-ascii?Q?TI6aDky2RwCHDZyzZhNbAuwXJraNd4WWIaOISKPhP9DMtmEpWsdOANVUhduK?=
 =?us-ascii?Q?dKyjEBNvuHaQkMMuU19n0AL317VJsYu8WvpuKS7t1aIioyAFozbsvTJXzKLq?=
 =?us-ascii?Q?zjPJPvv0awcnKML45cr7J7cM5J9QcmCakhsIuTJgyoJ2zwC5YmPNKG3xgziE?=
 =?us-ascii?Q?k5tvKeGq4+VkSRLk48Ri4Jf4NM4xfRCNWv5U9maYtCoJDtLcayaRyHUDgLOT?=
 =?us-ascii?Q?M7XPJ0VHeuLU56sX6oB/eQdrZZcOMB9/9qsH3BMNv8QAeZiOcq9TXQVk48WN?=
 =?us-ascii?Q?41TIlL5pVfsUXi2V7ZXnXY9ZQzlil8fvS7FDnIkMvLvd58aoVMd3BmLqitj4?=
 =?us-ascii?Q?g45o11yj/+7qz11j5npMqKQn2sdCvkte1M+/Me71ng77vw/A7+zITQrZj2yO?=
 =?us-ascii?Q?vyXepgA4864EH1gT2oo3E1WGqeYwe7WBaMcwn9i7nCWtVI5gi6vBx3GHvk/L?=
 =?us-ascii?Q?YAAFZB04nAlEJXkSFzzbjEwPUusGG5EuMdsy9orT1I8pQ3EINtH6iJQQ+Hgl?=
 =?us-ascii?Q?1IXJUeEQNdrmsdVXzysRECvGLEnq4gzWgnot9NkAETEmQoDon28mts+HdyBf?=
 =?us-ascii?Q?NTltfo5cWj83FAkftUrYYEOiFpqr/ozLfAOXXKL25iPj0KgBeem6dOWotTQG?=
 =?us-ascii?Q?86V1rVYzgvnyQHYeeMwd6/tyeYre7LtCB56/NckkEafswcEamVOQSoEEQ9Ep?=
 =?us-ascii?Q?06ABhnzedMxMPmpz68FDuHoUhEKZrMjS7xBNkEeY72gZW/qr9rRDbrkPjUGz?=
 =?us-ascii?Q?1ozmreBUaUA188PGiHr6n6dkwSNlP+3tbPN/b18K74rMiybDF8PBQGw2Nbx9?=
 =?us-ascii?Q?pDsfUiOXxVTcwiec4mmoPfFAYAXR4ySqcs4i0g7YFnZY3DtnA3OsyYYv/YFi?=
 =?us-ascii?Q?oRJsijLyrtp84RtxObmsF+nhUzlgMX+uSUs5jap+jRyTLbxDTWtfcKOQFvj1?=
 =?us-ascii?Q?c5wR4krTWH0Qn0YXIsuvahwqphlQckhwCAiJptjdV7p9FFEwXmJlF0XS2Mlm?=
 =?us-ascii?Q?XIwd36QgmujhOSClVPQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TaOGMB40wtRcH0cLO8atDI3nVLhuDxNO9bKRnR5NH9KFiktC83kACsp9Q+Fn?=
 =?us-ascii?Q?tyOMQ3hLCCTeLawFeUFlsWBMx01XA4J0SP6fECVWotFX2gRa/G0AYOXfxzuR?=
 =?us-ascii?Q?DWk5RMaGFCrIJuDDvQcoU+udtZwvnxiPGbzS0AObPwp7UVsDT3atSAZSVLa1?=
 =?us-ascii?Q?W/SoF0TgLEZQpaYyeQSUkbPvIQjd8Em+BrYzFuqvRfjSzwW/qkfxI5Z/QlcT?=
 =?us-ascii?Q?AK6NLBqJeYsOMLassaxpnbFo5EvRPI7YrxVrjjkiITeBiQVZ3FdNynlaJYty?=
 =?us-ascii?Q?+vGJzLVfQEp8FrxWM96qy1FWYqyInwHWMBBtyIdqzSw3vKP1wrhUFtOxBgud?=
 =?us-ascii?Q?G5BWVkK1lrnsOjCxXIXO85W9E7l/U8jnA3sG4d/J9EL10dWfDsQG7xvqgICq?=
 =?us-ascii?Q?kgfQQROe8LnICTNAh5cv4yw5ZwMQUEVTe4PbL5Y/3kJN8RnmYB3Rm0MCXWfy?=
 =?us-ascii?Q?2/5lcAkic2NzsmAC9De8via1D61cQ+XsYHLjNuM9dAmd/G56FqXWAY2XSHwq?=
 =?us-ascii?Q?T+d9eekzkklYfFfLftKxTNnb9L0vbYXowlfsxw4M7+N26SnFmkQaVoWmGCf2?=
 =?us-ascii?Q?73oAsDb/5wObPRNkMe5tsg7ftVMdtMZRKpM9omhIc20nEj9ABmAMyn/9oN+x?=
 =?us-ascii?Q?UEM6VHl9GSl5ndUZ1phyBnmHAjHkbcKs8XsokCLolYG03ttxLcyeWzxnj09b?=
 =?us-ascii?Q?Tt23aSbmiyqkxeUp72YbDUCqdfHy9rmkmZsG53jYQvudMOauFoFIa3Zh4Ayb?=
 =?us-ascii?Q?vMXgGJrK6jNUVjeYTU7y2HNPPVKEBnFOg39kQo512FKdDYPE4tYe/PvzK1xq?=
 =?us-ascii?Q?P3KU4SYhEgNBYVgi4hIxOMK6qXASpVO2iSexrQA2B8Jepbcvqj9keJ/H34HT?=
 =?us-ascii?Q?DaUG3os2L/qgmswkleyv/AAQOFIwycKRVUATB9uX6o1WMF3PKgBdGvuL9Swx?=
 =?us-ascii?Q?VjWtwE7jAgs1FCj8N5GgG/j4IuWQSv8idgzPE+5KbzFz4Uq1c3KW7wcfJPlU?=
 =?us-ascii?Q?8SqWvvI5oazibw7e5793KjCKP1zUXmFxwC8gABVaXn7DusT8tNop1j6wVmb2?=
 =?us-ascii?Q?sifvd+EfYZcWJgDTmrPsD0nvFcCAX3KKODsxQxDkIEyn58qoAh1fmIxto/HZ?=
 =?us-ascii?Q?E8QF2/J5d98l2dSOurBI3QqkoznbJwDKLvXBJBqGVftYZCEqW2GR7yLNOHzS?=
 =?us-ascii?Q?jyaoZncFLjmV1/HAx0hPFMN5SlxovOpkhGWi/BB7zOQF0YazH5vJdXAIvuBP?=
 =?us-ascii?Q?ZjzTem2ku2GCRMMz7vv6pfRIIlIL5bgqZPUZOAYXKvDrNh+IFwoYkdyTDCOU?=
 =?us-ascii?Q?xs1ddzfTOFnsXCfMhVJs8hjaAQF5A3+vXfbIPGU6IE/Fq8nfaSY8IwgZKEav?=
 =?us-ascii?Q?Q4wrC6n02Qsgh4TPwETcxcisl1FpvNlbbwuhKc0MuXoHlfVcJLIrByv54vxW?=
 =?us-ascii?Q?9EfQHDDliyzNeijmXi/ncCp31DpeuYcgnwazdXqFdWlBFKY+iwWdupeCjfxh?=
 =?us-ascii?Q?GxMWyIcdQAoOHrjOi/ByEEZTtwEXmfMoEKbWGFNl315AE9acAXdrYeaTMLO/?=
 =?us-ascii?Q?AkiFtYN9QcAb/CXTCtdqu9E4ysuVBigawbapPe0C9YCfx8vAH39JxOBDJTOx?=
 =?us-ascii?Q?nI8yYMpcjQiv3x4I2n1OiXO8mrsbWx+6kPo/27oEEVUt4orrXpMEkJXgz/co?=
 =?us-ascii?Q?qVyNG3KTrSjnsN47Tz0ppRqa443jqdMxjGX5dEHWY/ydLScpc/icFGF7n0mn?=
 =?us-ascii?Q?RlxfHF7RuA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1368a1ee-aa27-4c6c-b5de-08de626fe9db
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 15:29:53.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPoP0YtPBOXmsiWP5QWUWkpycDhewG3cOOf/+wHglfLsWGvkRQDWI3lBpVjtgO8R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7911

On Sun, Feb 01, 2026 at 10:01:55PM -0800, Tomasz Jeznach wrote:

> All tested, run with NVMe / NICs. No issues. Some minor performance
> changes (positive or negative depending on the workload). No issues.
> Open issue on QEMU RISC-V IOMMU model - SVNAPOT support is missing.
> I've made a local change to fix it, and will post it soon.

Thanks! I was wondering if the failure you reported was SVNAPOT
related, good job finding that qemu is not following the HW spec..

Jason
