Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B201552E0;
	Thu,  5 Sep 2024 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725562997; cv=fail; b=a9dxmOlYOpnUUkNTYNNH/uKVh2QSlK4078g2LsXh37mHu63M/quvX66nQxT2/evOUzORLXBAqM3RANMGVw70AtdpJ7BbUhGY9tR4Vq77sZHYWZmY2XMqJndf95E2AM3+kXaufTiEpxnd7W1NnH16BbgjrqUfcYUSpgH/6tCIVWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725562997; c=relaxed/simple;
	bh=NUwF3qhi7sAavRD3/tBJfv0pOlUOF8fPGwvkn5NYPcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vzoa2YmtaCvVxG62O5g9lc70L/iFEixzz9rjvDewv4nyHsUoeezHspVMJ3zFzUSUP79FS1YEcnJOMurR0bnMZjAZ48Nxr17+nfn6ojZAu87dguYbxzFkMlVMy9cPtCbfl/XE3mit7SAv+jgRmVJ3Ot8SxRsDQmjTZLvvAXX9t1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FXGOHw5x; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FXGOHw5x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f7s04rCojP5WpIYb7ndx3vmjD4UGAl2aHlpzaxuO7GdvclRsPkMpgpJCIvSwHtB0wqhge5mwRucrH7iQDWc6vq9yAfSdzyAdr7Iu4I+JHwsqJ4ehFNEjli1HeAbV1OXDF5jUM+4zJ0MflZjFqD4DmZCTawnBTDf5t42lnIqBU/OWWamRYrd5O0bLpOQHror8rcGyCA1FiVoS14FGdjia3M8m9fw3lv3ksdezzH46LEglNlbGGIcq1J7OgDrwHqZGqmEkQrsiSsfeLBypYXODxGo23Eu0nlJbbTrCUnvz6rtW5+YIbjwXTmJHnTXu/AetXHZrrVI11EifV2ZmxXgE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TN0hC0pdKfRCTmByPi/6mPQbyrS+TaBIel4YifZ4R3w=;
 b=XzyRxbZIKiPQnZsH4yetirC6KiYzCb94S3aLcLDfPQQnJ1mWXmjLksHn8Z6ttBI533xT0pvljDKK/2z6PfWtiFi09vOil7zlcFiID7WQoFTf1DlFwf5HzzxF9CtFNcd4IpBdzirS9vBZxufdMKfi3dDh5VgebqNccegR38OGxrw/4YqEVY1uTcdzjSlX1kImDv+VbGEyRn163wBL/Vcybg8WI2o4kWBqknINSzFbFEf17jwB+p4T7eLZN4mmppHY8uxo4TroDM/zjRRyjEQgywPGvO3Xyx1ypLxzmU6fLYvrLa/t38ogqfXBftbep9VVBUMWX9Fl4VzB3/K8YarB4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN0hC0pdKfRCTmByPi/6mPQbyrS+TaBIel4YifZ4R3w=;
 b=FXGOHw5xtLnVsJzUQLDK5eJneH3N0A59yKhOLKeJNX0YBogg2BsC5Nj920V+3DOUxLeptsFYgArytjB0EbbVSXk4K4WYDSqu7tyF9xzwCzpiqFuJCVjUJ3vx1mTPd8q3ABWfcjlBQLQQH2fLeQjnIw5WZcqn9xOq8aLyFBrc4/d1uqO31ZUQ4D5+ouxDJaK7qEMR90tQpapVKLjhFZXJttZhuNDJZEfdvEWQcg6m9ieZkYfqcFPXSZJRXnJm/3zNjelWO8qOMRigklu+pXX7erb7vJkUwsm3ca608bPCafduPmhf7wivbpOykQQJn03DbtCS342BBtQEo+25zZKr2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB8850.namprd12.prod.outlook.com (2603:10b6:610:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Thu, 5 Sep
 2024 19:03:11 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 19:03:11 +0000
Date: Thu, 5 Sep 2024 16:03:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>, Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	syzbot+16073ebbc4c64b819b47@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] iommufd: Protect against overflow of ALIGN() during iova
 allocation
Message-ID: <20240905190310.GA3474936@nvidia.com>
References: <0-v1-8009738b9891+1f7-iommufd_align_overflow_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-8009738b9891+1f7-iommufd_align_overflow_jgg@nvidia.com>
X-ClientProxiedBy: BLAPR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:36e::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ce2b0a-f8ce-4e3a-f05c-08dccddd62cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8avtX3Uze+mFrCIJE6kzFypPIk2YNTgMm+FeogDbI9xQ/VrkvATjI6b48fBv?=
 =?us-ascii?Q?ah3NDXRhhjPbfBfUHRmIoofbHwp9XWK/bbRgRVuvL1j67yMqIK017M9UvkpY?=
 =?us-ascii?Q?2H4s9wxnTy5VjhlQI4Fky+3FiptjbsHrtGlllfEngUNU6Bol9rRpuqnT6f9Z?=
 =?us-ascii?Q?ri+5qhwE7rYt8piDV2FZglrjVh53Pxmqtd9v1D3Dstn/yQKwf/ezEFjxD2p+?=
 =?us-ascii?Q?aqHenp0E7d3+5eCbJv32iEQd3kg4bLEC8xLGIeow4Ri7a+2YBCcXTfqzVVhE?=
 =?us-ascii?Q?txHSAtkwfpZK+wiTE6rhRCGslnXZGDOgOB1F9fEr9g/1mF80htWRN3TNIFMk?=
 =?us-ascii?Q?vTViKGCuWykT+T3bCID3JgREIOLSrcyjjz4eWgSiPWGRtVqsOpK0kTXgk1AT?=
 =?us-ascii?Q?78QHEE3Ixmt1KaZCCMPYRswo5Tl/Mn/TTvS5BDIniYiDPmUZi9F7Yd/lBBK2?=
 =?us-ascii?Q?HtOA4xkA1L+Bo9B8v1Qmsrp8cFzWFGveC2m5kbsHruJRvHch+xifRYGvheHy?=
 =?us-ascii?Q?q2YG8zt8KVGGwXc7jpbPFCS7pwFLT6fqpkdSUu6qaQZRm24BG5gh3t3Z+Lbv?=
 =?us-ascii?Q?/JwS2npnmJ61A+rEHBfp/Cmsl9wuZjufCOgJWar5Vpsb5YYmQnrx6BcdH8Go?=
 =?us-ascii?Q?2MUrP//e5ZzwSSktEICvFn3cm0kvykJGxOi0yncEUjL9M0Vn4IKfTeQMLeed?=
 =?us-ascii?Q?stQKOWEG1jioUr+5qlSipwo7Z1z3HrvSauD+6n0vh+PzEwFmUN6A2wfXDnsL?=
 =?us-ascii?Q?4Plj53YWeMvChPB+/E/9KfFkbAsk464DHPwcu1OEekLfU1AONTDTHTa6U8lD?=
 =?us-ascii?Q?kr9UjbsG0Lt9T0/1/Pxwxk7f5/FjOOJpNtcWtBp+reXQeZjvYtNyc+sUPLFG?=
 =?us-ascii?Q?Xdiz/gKDCbW8bF+RkXwZuq8qVb2xw3Js051ntGmZkIj3SbJHCAJSofDD7DDX?=
 =?us-ascii?Q?LYXJT36MNOJFE74vvalATBsoteDaorce52BAil+6GjJlPuRwugwO4ixJfdft?=
 =?us-ascii?Q?YVP443iIaHg1IFKbMgUQMCi9AUOn1NkamFVPYk8yC0nYC+yM6wgJHaBqScIF?=
 =?us-ascii?Q?YRatkGA8HD+kpyYV5m1EH3zX2y06csYkl0Q/OdOsvFq/SXfNNQv8G+CJcBts?=
 =?us-ascii?Q?moGddgu3+kByKv/cyyZj9tFWoxmAQ1d+dRKa+kXk+BZwQMyw5sFQdV1yYX9z?=
 =?us-ascii?Q?6precHp7QZntPeFAKQyh3x3ooDLbagD2EwhMlk6zjpXRVNAO0h/w1hXYdLTi?=
 =?us-ascii?Q?zNLzjkYhZjStO5WoJOVIIDQp4Wcpn7/xrsvv9bu7XKiIHuIEhNoQEpuGJyRh?=
 =?us-ascii?Q?5uBr6RxhvmYjw+YtW8955CorLYlZOPN1zfjnXndT6HitYjPoBu6Ld9W6E1Lg?=
 =?us-ascii?Q?VR3UeOY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LCAdp/ncpr0UtYA7mjkEHhKQ74DocX60BgFVuka3a13x0ZcY/3XF3TWBregk?=
 =?us-ascii?Q?foEfqylzzkZkwdKws0Rf7e26rMnsFciEobcwQ1Q45346v0MI8QbftXTBKOyZ?=
 =?us-ascii?Q?BxYgAlCIArfEVBv36N/H/sTBOoYAJ03gW7Ab5Q9jSFZ3+1+QSqdxn41TE7sH?=
 =?us-ascii?Q?sPZY+E/QR+Y/uLTJlRglFoxwFJrLkbSLPeDTJLXcls8UTPqDiyacD+doLhmp?=
 =?us-ascii?Q?t2Kwkl7HmYwaAbLNi7TCTsH5gjmEn5zRK8+94uVObIIyIOHNdqOCIRRyfynC?=
 =?us-ascii?Q?EXY7+d5l0KOB5YyZCMFlMl9aaTTOSE1/oYkiw3YGius7JpXn2ugz9qaUmtNL?=
 =?us-ascii?Q?y+sk1ki800blch9NAhmlDhXx/fmb3JBy4IU3Erh+R7eZRAzIUmiks2iv2YEe?=
 =?us-ascii?Q?ulTUtNaJbkV+s9ZG6+gqAXvjcuWMAWdEzv38gGE1um6n1adk5NkxfG1Q3PhZ?=
 =?us-ascii?Q?N3kqshoAfrxlVcCnUO0HTw7G5/HzqdqW1wWfLC0Ilzz3EgnKpKu/q7EDGX0U?=
 =?us-ascii?Q?lYsujXQU1EFdvGBq9KtCJPBl4Wnm7UbUD1iIOB+uTlce85nBRwEBFD8atBsE?=
 =?us-ascii?Q?dpVETIGxevcGB1n0yxSeQmJadCMRlk6Hm2u7N37dHQYut7nU1bOEbGa0a1OQ?=
 =?us-ascii?Q?CZzVFaWX2inhgf90cvLpxfSSXsPrA2V8DLHMmUcDD2ZpOc7eQNxZkBkJnnhK?=
 =?us-ascii?Q?t1Pm98seZ1b/OCeFcPVBg0YmFANyLxcB2B+7pAWZsa8B1riri0BnpDeJ+W88?=
 =?us-ascii?Q?3edELpbEARsNqt6oJsKj3JeMHDrIOphCB0KCqq3eeGRSJkoKF4JFPb1mh038?=
 =?us-ascii?Q?qypi47ElJMsu2gfuI523SFwdrpc/Nr2RU+TfR8wEG/RXm4dC/wB+hnYxaAsl?=
 =?us-ascii?Q?TnahN8uF1zqnOZTTj7hDcWE8psVWHynztStFMTeZyRvbC7g9CPPOCzn5wBrv?=
 =?us-ascii?Q?V8DG/MnYTXEvCETS3DfglLaJ7y86WyFIAmXGW4W3xII1LgFf/f8UEvduZ01a?=
 =?us-ascii?Q?tGvXJQraXZgsnXVkq7aKNuUlIEen+iD17ag87giozc46jgJXSXJCvRrqvTUK?=
 =?us-ascii?Q?zGePh6kfCTmPJJPe4XJDW7a/ObWHF5vsvwFjJGUkuEVBhSLoFgAOQWvBMYFB?=
 =?us-ascii?Q?kSvEAtMphP1OATe0qsOm9ovC8zeKDr/nCwO3xEUgZBiEHDtsE9PHBwV/ofR2?=
 =?us-ascii?Q?SGFqaQEgvW/7W4EAazelZBmBtY03Eou9/twy6M5d2+pEtq77U3YgXeRskTpJ?=
 =?us-ascii?Q?8oyrrFqTUpGxz9vLCtmVArS8pUmncMGsSCrZA8bd8WJ0XFM/PHH3wP65NxtK?=
 =?us-ascii?Q?ooxhPM7vCxfOLqgjZaLYUbhScOU947d2JMYrl8PP9kQi8EeQSdZZTzNGT40j?=
 =?us-ascii?Q?IELdhts+aT2yEI9UaKa89vQnzRzRzcC282A1ykXcgLhWPiUDyoKZcXbryYJE?=
 =?us-ascii?Q?kzIWX8x0GxIq8B470aBXCfuvC5xm9WBvNiAm8gajPFSUzzsOtivueelW3fqt?=
 =?us-ascii?Q?qVROXOJNCaXEfLvCh1tWG8Wx/B2METjwXlsa01xYuGhbY0XTM7pQ6f/Cu2BZ?=
 =?us-ascii?Q?X+CU5pqZvzw3dEu6tljGzFxxsPFhEMN9jF1+0Duq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ce2b0a-f8ce-4e3a-f05c-08dccddd62cd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 19:03:11.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNl2NTNioF6QGczOnqI0YAbX4nuXgUnq+1vPbF/6B8XyG2YgKoCUtpRszy/T9+oY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8850

On Tue, Aug 27, 2024 at 01:46:45PM -0300, Jason Gunthorpe wrote:
> Userspace can supply an iova and uptr such that the target iova alignment
> becomes really big and ALIGN() overflows which corrupts the selected area
> range during allocation. CONFIG_IOMMUFD_TEST can detect this:
> 
>    WARNING: CPU: 1 PID: 5092 at drivers/iommu/iommufd/io_pagetable.c:268 iopt_alloc_area_pages drivers/iommu/iommufd/io_pagetable.c:268 [inline]
>    WARNING: CPU: 1 PID: 5092 at drivers/iommu/iommufd/io_pagetable.c:268 iopt_map_pages+0xf95/0x1050 drivers/iommu/iommufd/io_pagetable.c:352
>    Modules linked in:
>    CPU: 1 PID: 5092 Comm: syz-executor294 Not tainted 6.10.0-rc5-syzkaller-00294-g3ffea9a7a6f7 #0
>    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
>    RIP: 0010:iopt_alloc_area_pages drivers/iommu/iommufd/io_pagetable.c:268 [inline]
>    RIP: 0010:iopt_map_pages+0xf95/0x1050 drivers/iommu/iommufd/io_pagetable.c:352
>    Code: fc e9 a4 f3 ff ff e8 1a 8b 4c fc 41 be e4 ff ff ff e9 8a f3 ff ff e8 0a 8b 4c fc 90 0f 0b 90 e9 37 f5 ff ff e8 fc 8a 4c fc 90 <0f> 0b 90 e9 68 f3 ff ff 48 c7 c1 ec 82 ad 8f 80 e1 07 80 c1 03 38
>    RSP: 0018:ffffc90003ebf9e0 EFLAGS: 00010293
>    RAX: ffffffff85499fa4 RBX: 00000000ffffffef RCX: ffff888079b49e00
>    RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 0000000000000000
>    RBP: ffffc90003ebfc50 R08: ffffffff85499b30 R09: ffffffff85499942
>    R10: 0000000000000002 R11: ffff888079b49e00 R12: ffff8880228e0010
>    R13: 0000000000000000 R14: 1ffff920007d7f68 R15: ffffc90003ebfd00
>    FS:  000055557d760380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 00000000005fdeb8 CR3: 000000007404a000 CR4: 00000000003506f0
>    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>    Call Trace:
>     <TASK>
>     iommufd_ioas_copy+0x610/0x7b0 drivers/iommu/iommufd/ioas.c:274
>     iommufd_fops_ioctl+0x4d9/0x5a0 drivers/iommu/iommufd/main.c:421
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:907 [inline]
>     __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
>     do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>     do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Cap the automatic alignment to the huge page size, which is probably a
> better idea overall. Huge automatic alignments can fragment and chew up
> the available IOVA space without any reason.
> 
> Cc: stable@vger.kernel.org
> Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
> Reported-by: syzbot+16073ebbc4c64b819b47@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/000000000000388410061a74f014@google.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/io_pagetable.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied to for-next

Thanks,
Jason
