Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011048.outbound.protection.outlook.com [52.101.52.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814E8392839;
	Thu, 22 Jan 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769095904; cv=fail; b=nY1GQWRQYne9jif3iC+M8DMhLlfMvtZ2OXPpg8diDPxqRnMX9RviMSGzyb8UWZafeH4EVSJGwQgYTJbyawORVFdMMGWTx/3PzLldDQXs2yYNZubb1DaE84jXea3eEXcXvOTqwx8JWJR2YiqwRgZbXvSU65ZrgEPBmiA0MIk+m8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769095904; c=relaxed/simple;
	bh=gy1ESw+ip0X0U/bgCf8wBjP5nUck63BqxD885scPy8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nd7P2YTW7s7AMjN8WupT//1msMUmekzlA+0DfwkQFkfsy69TdKkFWi0XQSOXSxTNpSgKWn0vy3d4KuoFUHYgIdu3vG2N4J6Z77tWjuctQiF6jyky9bxZA+qcoQ4fPwwFoYYrYtWufDxoAb5XsIWZk9PYY+tX6y4bCjs4078KUyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AKYz8+16; arc=fail smtp.client-ip=52.101.52.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AKYz8+16"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAWWM7xiaCzawsPIZAB0bCB0cvMc8AfhsHHNRH5HHWbXxx4SP1FeM+yTUHHhfAjA2b5ubeHtrWjLyo7wV9pV6qnOr8g1YedThAjnqJX58zhu8WqVK/SRnbf3/6Mvqpa3+M/44mMCPB28bW3tJ4e15txbwPrH8tlMN5ciwkLZI4sXlVp0XBTVYf9Kw93yQqLF4OdRxGjcd3xSIJQNleCe5tD3ExPZLsWRbADlTbGU8Vc1kO/ZGQbzDC1VdXzgRG/2DHIj6QZ5vSzLcBFgIMKux1Sad/yTOlpGDuObpGnr6PnbFbm9sK2aJmkOgs6ZE00QWEgUcxskhPiTxYdzdSolrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pEk2sai9C44hkv2b+3leqH1g7YoEpzQEbY0FBYHFfg=;
 b=VzM0sc1KFgo37i8wd04G8mQ+ZseapYP4xFontbVVKd+dW7Aa5rOD2PgOVc0FOBqvWtAMcY6XvUMqcuSLu2hLV+4UrJGCTB9ly+pP1h4uBVE/1/S0xZThyYE8QzrS5ntiYKfngEynkfHkJ46Ae22MjQPrHFnLJ9DMhMmh3mlRC9/wWa6ZGowbwDQowI3iDUleMKJdUB4gnvl8zFyZrcvvDgVmNIem7dHUKo0YKDhpsanng9WSVKkpXsoPFW3gaJXJPbGS8flODw/apNfnBb1Uhxmtg6ps4DRDR1zfRS75vKx+64pvdfaVXdVn9f3o/CfdoUL/xcdOT6+jMhvVt1Tdrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pEk2sai9C44hkv2b+3leqH1g7YoEpzQEbY0FBYHFfg=;
 b=AKYz8+16m81+jwK0aYOrJIVCbwLen9nCID2oqEczZVkHCSnwrHBHXtrQumfNScFUVGe9Zw/+3nlLA1gcOEEzsrNZt07PLWW5T2DiPrDK1bFfoyQvmk5fK77iEukqgPogE6LIMw3XgG6lSUSW7+XS6slee7BPrDloTKGSLvZm8JEoZUauIdjmnMURDiZ1weDPWLQzf/VTqtdXfeSRnIxAzt+tSdyjbBRWXnGexAJ3c8weR3ACPUcyJf/83HVVGEFuKp7U6yifO125lzzSaiYivSeYo8G/HL5EicSBMJYV7QzNwkXJo3/8b9OTWGFczQ+fO+EVEgtMGL3Pu6c0p8Ea4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB9346.namprd12.prod.outlook.com (2603:10b6:8:1be::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 15:31:35 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 15:31:35 +0000
Date: Thu, 22 Jan 2026 11:31:34 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vincent Chen <vincent.chen@sifive.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>, lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
Message-ID: <20260122153134.GO1134360@nvidia.com>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB9346:EE_
X-MS-Office365-Filtering-Correlation-Id: 885c674b-4c01-4a0d-0846-08de59cb5403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?icf2Kl9Udm8Lzst60Fl9IIn+3CBnNxtE7QtqKDqp4pCEXEiyUqaGefKVx1IU?=
 =?us-ascii?Q?MyLmZQHGftRWFJ4NOuSCV7AjJUlYSfnbGOder4tuspiziW1ii5bOgYm2etN7?=
 =?us-ascii?Q?nTYAlv943eik+EY+0fX22IxSyfk/5oBt26jBb+fhq8aQfZ9J4iNu/EEwlPGz?=
 =?us-ascii?Q?n5Mv8KaTTVrH6nKfZFn9UZNK9kFXeUmmp9IN3hSB43VQeNHJX0JRO6yrr379?=
 =?us-ascii?Q?hTiX/NnXHDkCHIaesL9iO68UcXhmY2kPpvBcB3QZqK8mjQJWcMGvXn59hG27?=
 =?us-ascii?Q?DhwY98n/c+sP7WfM9inzKVTxH2xTwo+F4BJBlrj6vUdhEoJDEEZgIOiqhiTQ?=
 =?us-ascii?Q?KUEVUnrL2Fi79GtFY1xfQiLvJG2gZzPYNF07jKx6fBW14FyFWUDpfUnQ0fau?=
 =?us-ascii?Q?PVGw73d31BIAzv6PiksCs8cQGXMz1Zc/4mm9oBSeBU4Y2MMi7jJUTLNNNa83?=
 =?us-ascii?Q?pOu/2vzPf1oo87GEMgKTmgEDnAUN9zq2xIZUI0MV1fVpGr3YnXQLcl1EvPZ8?=
 =?us-ascii?Q?//utLpFLPjZHAigJx97Yfy3XhqryBt9sCGJAiP0nbVPDc20aI8QgUsJ+lBss?=
 =?us-ascii?Q?g4teMPfe0E6ui1PBsuK1ycUbdB0hSksGM0PvokuqrcuRv0KuKe5emXIC3Q3h?=
 =?us-ascii?Q?ywIGa0b1KoViC6xOTAbb8w50Ha/42FzhVMfKY0Y+xxmYGUKhtFCpzGY+2hJ5?=
 =?us-ascii?Q?FG8F7x1iKPWgKobTCbZVKy1CzGkDAkoW48DwxYsS312hBrTA3bbFXO5Dfg4O?=
 =?us-ascii?Q?FXLDW/LigZUAv3fu8hXJowT4Yym9PS9EZQ5pk0kLYkRo0vg068bQdzH8lX6Y?=
 =?us-ascii?Q?05LUM4hmEEb9hrf7Y1F6WdaVJBlCPxDJ6vpePgElKMxu5wu+587b5COVDI5x?=
 =?us-ascii?Q?1U3euGt1xfQKv/7SXGA/A3B3WFfo4t13SCsu1Cs640hzTZmaQPY9EVF1Ysr2?=
 =?us-ascii?Q?IindSgRX/RnljMc4a2yFujdAC2RSHtIbps8nJZiiLeir8to+Wl7unq8FvuGm?=
 =?us-ascii?Q?DmFTlP/A2hUztNyV1s/fXnOvdVRuBUUr0syNS3yMhueLxweHZZGwQelBp/ad?=
 =?us-ascii?Q?w39qy9DyzyKaEBsvAA2NEEz2nMkyLXispxA0ENafmVlg7gtoSUQhVDhjis8i?=
 =?us-ascii?Q?Ruz+4f0/dFtD60PBqUBCPv5qBH+3SRRbWXCFWm/jr130xOzRarqGBnKcmuzm?=
 =?us-ascii?Q?g8EmAdZohuA723b/aECca8sn+UJTGpfHmWAkbtcABrS5fOn9JW7ZWNtax0jY?=
 =?us-ascii?Q?5/VdVZIXl1UgfsqaM1pe4aqzyKvdhEZ0n7OYOfdBvkl64B1i0VO6NkAg0dQh?=
 =?us-ascii?Q?Ho7DlOD7REezvlx8rEYHqDCMx9d3N2ynXEesB4HbF/QVyYBGtfNuCkncDpB1?=
 =?us-ascii?Q?oVP0fKZpW7I2cfkVV3lZ2dqnH9ZeOc/OoOQKrIadMcAgv2WltO7zyHhVa0wP?=
 =?us-ascii?Q?qsWa7le2VVTdA7LhEvHt49sDStm5/XwSH93YoPuyNWIQsYpJQ+2LC9RQAeF4?=
 =?us-ascii?Q?uoSDjB/Oqd3Pn/K9SNUm1YDeQeHo9XAE5ylm83384xLH0Uh+aE9ERnipiwMY?=
 =?us-ascii?Q?i8mAONCvdpALo0ZMRCI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RtHlPVxjA3aVonGhWpHuymdHf0ZypcEGG4XXAwAKcS3mH4DCjOloNYQIzP3N?=
 =?us-ascii?Q?n7iI23jVPfcA+trAOZdrTzQTbykl18u2Hf79KdRWznU4A+TTbphJXx3HMIvL?=
 =?us-ascii?Q?mCYsdeCRxNa5apUkNce1O3JAESoMPnOPiDM4VnuaS3zWiMG7Ap0wBAl4Vje1?=
 =?us-ascii?Q?gHTpWSm6IQPhugwdV2GT4u5ptiIPDGiJabmOv+bcoFTSM0H3jsHTE3WDkZNe?=
 =?us-ascii?Q?ug1SKZE3QJJEsGgyU3Xww+yVRJ5T/nUwjF86J2b2AnGC7hAm6kBJ4eyZlrII?=
 =?us-ascii?Q?2sXPu54wPL/5rVcK33Cth3PqOZbGLoTzU/g3ofIu28GAzwxepTSq8XkNhCd2?=
 =?us-ascii?Q?V41bnYf592M/o9BDDY2DNcnoMkRPLcztSfRHkzd6LxgfvEvK61DnxVk0tDVt?=
 =?us-ascii?Q?myTW8WDwGwdLSNPBhXx2cL7kApd+fo2Ytfn7YzIyN+jYsduzF52Wfx43rgjt?=
 =?us-ascii?Q?W3tftIMsxYv9em/OsokFUsvWwz438LFx898MWfrHhHDlB0gEmPjwzeYMRd2E?=
 =?us-ascii?Q?C3XVtNx71l5ALoo77SI/vT49OQXqTRHLniUqFeltqSc4yYoWMQZKDCop4bEG?=
 =?us-ascii?Q?WD/gmaUTAxQ5IiS87m4OZFcX58unnI0/zNt84TLrohseb9ZjJkgT9hMZ8tv4?=
 =?us-ascii?Q?QDhhG35Y4h+Ima/k9yKRMMwOYlCr9Cg8ClRd+EXQT9aBpY2xf00g9UILpiX8?=
 =?us-ascii?Q?sqfUW25RUIqAbZO7tyPA7shEsvP4LE26/sHZ0ZBN2vJfuxfqn46QJWUvp00C?=
 =?us-ascii?Q?dhD3Sz82rlX8dQXyU8UeAlY8A2oXVV+9tUA6vAyBLpPooO27eJC07ayet5Vk?=
 =?us-ascii?Q?DLpgrOGDOeKfkbUp1h3oU61Df9zss2G9x1i7Upsi5YuIJzCIcosbON7kPjf0?=
 =?us-ascii?Q?DhqEXeRVeR71tsYYIBUrD0pN37PtQbp+NWucTjVbfRjv0uE0SNlPgVQRZMK9?=
 =?us-ascii?Q?qle5coXRdEyhk47mb0dGFaCD/ql89bbKd4WBBx0AFbXCLcd+zC3cqUZefun4?=
 =?us-ascii?Q?BVkAitkG6Hblr/A3UepphwRvs8WBBS+eB8jH3kWZTTelOah9MjfZja9xRBBM?=
 =?us-ascii?Q?UPXJaZSGvlGQvVLd8dc5Fq3K9/PfbsquMog2CE4n4YDAX1zhkEKhP73yOyBC?=
 =?us-ascii?Q?iOiyM49x5dnFR1RpdTMXh6Q0TUSqiW2pN5e2Btu7HeiB0PwHMB+st6NqlIwf?=
 =?us-ascii?Q?HcNpq0yDROn24d2jYxVKH/7QkB718a2HYYL7U2PzPAUMGhT4YxAgYHa2SgJE?=
 =?us-ascii?Q?MGwskZz9Cmoc0Gy9g6dtqFNgJu1qlHCJ0VUO3Ek4IwEFCudz53nbzpiYKdrQ?=
 =?us-ascii?Q?KLyoPLo4+tsRBPUGVEyTKRLnVYZ+6MisLKUUWxOnt6ebo127zyn6cDYOCen4?=
 =?us-ascii?Q?f5kbfizkmwZJMSw02ibprUC6waIiNpFBTMHoTleF71zl9H9JR+yuVAR5GRs9?=
 =?us-ascii?Q?LescFCnw7jhdIu4GnpqHP5ef9w+yhYxsg3R8rbzkBfyhfvIVUx2vnRc/W62x?=
 =?us-ascii?Q?FmlYZe2s898zBIo0dIx5Njx65VqPT9iuQsrhg4v9U0jeho2j4qZ45nlb1XP6?=
 =?us-ascii?Q?fyS/i27tGUNHk0tWUXuMIDAM9NMPpFNe/X/E/YuEH9os6woG92sYWY2bYsoz?=
 =?us-ascii?Q?fTo3X52JeNxDVUbhEESgI5IFhB934uip6I3liH0D7UNrVQA6goC7C2v0czKx?=
 =?us-ascii?Q?JKjw+JOwEwfPZyApO0cefQfRh//xt8A0F+0IeYlvyvjgvMOBOk2eLWdgN+Lh?=
 =?us-ascii?Q?kppF2y8tvA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885c674b-4c01-4a0d-0846-08de59cb5403
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 15:31:35.7576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0TfzOMWL4nji3xphH8x+wTTX7489Y3MP4mOrudC7ucskjKzQqSqAcPUWzRoDQLH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9346

On Thu, Jan 22, 2026 at 09:46:47AM +0800, Vincent Chen wrote:
> Hi Jason,
> 
> I tested this patch set on my side with the QEMU-virt machine.
> I used the following QEMU command for testing:
> 
>   $QEMU/qemu-system-riscv64 \
>     -M virt,aia=aplic-imsic,aia-guests=7,iommu-sys=on -m 8G -nographic \
>     -bios $OPENSBI_IMAGE \
>     -serial mon:stdio -serial null -nographic \
>     -device e1000e,netdev=net0 \
>     -netdev user,id=net0 \
>     -cpu rv64,v=true,vlen=256,ssdbltrp=true,smdbltrp=true \
>     -device '{"driver":"virtio-9p-device","fsdev":"share","mount_tag":"host0"}'
> \
>     -fsdev local,id=share,path=share,security_model=mapped \
>     -append 'console=ttyS0 earlycon' \
>     -kernel $KERNEL_IMAGE \
>     -gdb tcp::6234 \
>     -smp 4
> 
> The boot log shows that the e1000e is successfully added to IOMMU group 1:
> 
>   [    0.752808] pci 0000:00:00.0: Adding to iommu group 0
>   [    0.753279] pci 0000:00:01.0: Adding to iommu group 1
>   [...]
>   [    0.763212] e1000e 0000:00:01.0: enabling device (0000 -> 0002)
>   [    0.765241] e1000e 0000:00:01.0: Interrupt Throttling Rate
> (ints/sec) set to dynamic conservative mode
>   [    0.868120] e1000e 0000:00:01.0 eth0: (PCI Express:2.5GT/s:Width
> x1) 52:54:00:12:34:56
>   [    0.868740] e1000e 0000:00:01.0 eth0: Intel(R) PRO/1000 Network Connection
>   [    0.869087] e1000e 0000:00:01.0 eth0: MAC: 3, PHY: 8, PBA No: 000000-000
> 
> In this environment, I used iperf3 to verify that the e1000e functions
> correctly. The result shows that the test completed successfully:

This is great, thanks!

Can you confirm that the iommu was set to translating for this test?

$ cat /sys/kernel/iommu_groups/0/type 
DMA-FQ
$ cat /sys/kernel/iommu_groups/1/type
DMA-FQ

?

Jason
