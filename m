Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C488718FC6F;
	Wed, 10 Jul 2024 13:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720619495; cv=fail; b=pJ1DxKqRzszeHhFnnhQqHM4+MdQqqVxCFpYGrrKfa5dn4i9I8ooRsVGnH5vlK0I8v0URuijZXzFmbbkfERZB92af53HkALitvzeQa6ulelkppxasOl1G7m/Oh5WTSuGU0qAflLYbZuQraG7oTl13KBHNZFG221wFYHoRUTpMVvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720619495; c=relaxed/simple;
	bh=paBzzFYN9QXpzGWUOdlC+2VR8y9oFMKmE44VKOZ7YC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D5cCjmZ5urntGphjAtxTH+330IIVh/oH7bbDW4Cl7s01QCKV46VOT+Mi7N2oLxyRq2ZG6cFW0FPw3va3kR/L13RQlh8TeBT1YskwLsH15wnGQYV6RV72Xjk1wZbo37ItdunqTYBIk/Pc3dfLslsHMuQutP/ay7MtdQjIi1npgMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FQIOgHJB; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FQIOgHJB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xas+hbUs+u2xT5ZI57QZVtO7u/J2hYLkUZ5AHxWt0obAf6GPRQDbZ4/xci8gpoWo9kZ8c418QoIYSA4FIBBotBTiOSeDbe269ldkqd92N0FDrth1JUe5AAL/d9OrFRzVETpz/bHjSwd0Xy0ShUiOo6nuRS3DSu6l9yl+YpWb9wuRH//iIl0Qp3Gaq0iNuEClMHjdfrh6+uuQBJW9P0wmGFz3YqkNRQoop0bRoXkcFVhIIeZJWsD8Kq1oa2e4ax9uir3dlgZBgv00nfIdiatZqsufUxIYaWsI4j1JJcG76Zx4AACTeQXvO7WwGLEAFc644xT12/PwgFXhUpiRlxlaMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amqyYZ9ou5oA/yXhhg36TOcVzfhnrMZsYD8oW9hk7/A=;
 b=UDAUve6LbYaXicCdfdkQ24aQmzU+Bsh33aCBrBVFz4KXWs2ZfrM6ACRnQnx4boznbaYMoWNUulaWQX3n0unLJ9rSy4e500cv0ff/3H6cqvN4wsUoKqTS/SRC0rF6hrIkPL9QMpuCF4IacljNzPoosgg7Ku03sP4mxA3viBpGg12234UxBcHc6ascFqcHsj6fgxpx+RtoGTEWU01Dj+3d0rZy9ojtSZ+JJfm/x7vChs/QgVIwUP0EDSwXoGLfPLsqityeF7Q9dVy0PAAt9C/vhX57BVbog0eSewPHWjIm2WBXcrS+os8mbO8k7LsgHz87+AMc6QfufQHVcZPTIoEmig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amqyYZ9ou5oA/yXhhg36TOcVzfhnrMZsYD8oW9hk7/A=;
 b=FQIOgHJB2TH6vZMB50rCjCn4/dDg+9dSNw8/8rmqsGcx5fKP05L+1Q/TD1O8iKX08nYuppdS21NHRGaH8y3eB4kxQn7aQLv6aelJfMsNqQlWZwoqqb68aLvqYe/i4CxNXxMN+Rq06e4uQ/Nvs4nftQaKUqdtfaW3f/q7V9ExSqGcsWMD7i/+WPka4llUilcYT9qokVuoRXi2z/UzZEYDpJmrfhO9YsWUsqC0eyBMCmkKRew3OJYaru7v8Cwhtm4SFzqAo3q/UbEjFS8t2hjcmFAHuSpw4tfQVmyNRtwqf87MMHZB4kao1pvuRDTFuFG3pZH6bh+P7OSA8/PCgs3ZbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8337.namprd12.prod.outlook.com (2603:10b6:930:7d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 13:51:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 13:51:27 +0000
Date: Wed, 10 Jul 2024 10:51:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Kevin Tian <kevin.tian@intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] iommufd: Require drivers to supply the
 cache_invalidate_user ops
Message-ID: <20240710135125.GA1513686@nvidia.com>
References: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
X-ClientProxiedBy: BL0PR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:207:3d::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: 958b1eb1-28a1-469f-c121-08dca0e764ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PuTUExzDU33PIKQKvquDnU6+9Zw86dOb07SvmLJAEynmcgi5sK0TaZWL91hE?=
 =?us-ascii?Q?VFx6xAwAgAOf2wG/Kqq+a5hvWQh9PAlaFYfT7dyZYzVgyEkCMZ3j1tz7jVBt?=
 =?us-ascii?Q?FBG35OEJsj4Ndr08cDjpAVr5aava9pi8PJHbQu4EHPUQRf5OIcT9+A2OK7H/?=
 =?us-ascii?Q?ZVci9kxqPzfgOJznjGqyZ++XSHfrPaF3Zt0/+B3qJcYMMrOXBKVF2S8oyazf?=
 =?us-ascii?Q?gZaDpHJlcrP8G+ElS0HUH3HieZaj3suNQoILBlKb5OSUw0jXIpMZ0e0Yqoqy?=
 =?us-ascii?Q?I7pgke1724fX/wrXHfcOeenpdq2IbNhEq56VMurHzA85O1fjbd0jsEUKHBTq?=
 =?us-ascii?Q?G304COVxiyrxRj0Rp6fUieGIhmWwypMDQePIG9FdW+YkFWZRixRpyKTYEDgL?=
 =?us-ascii?Q?/XafcMF4QGhhL7vvW1/wKjjSrqopiVWoqyly3g2zNwbwx4rAW/sKkeArl9CI?=
 =?us-ascii?Q?1gdobwDqBfiK67ZGglFqSh4ihSecmt0DwU1shMNCBX/VG4RnT1B+iH8M8I7C?=
 =?us-ascii?Q?IyeF4hqYmhGG0Kp6Js6PxmD2hFJzf66a1yQNKDhU5dyUMlpE6eu34XB2qH2A?=
 =?us-ascii?Q?XeSc2f+XZxsUbgHaVmyfVlOkXCtlP4B78fELrVXsXg07wRzPiHSUlZKYkPUC?=
 =?us-ascii?Q?c+JL5Ir/cBErdP8zfRfCWM8/OPBlRoQyDt+lztvfzZg0U0qooXT9qGjJ+00c?=
 =?us-ascii?Q?hRYpvt2ncxLHz5+EY5yy4o/HX5Sh8Fs6Tmr+jOHcmUrTwPaf3xFdLiS9P3U5?=
 =?us-ascii?Q?FgS1ro1GqqAuWB5GGMDsjLbWOG3rN8AejItbrpzt/+98LmneIK2qWI348myU?=
 =?us-ascii?Q?upesbCe2u5hjIjJOWD+G2csKyXvwTYPp9BcbAizsLNywawxY2HyMkaDfq+xm?=
 =?us-ascii?Q?c0jpTa+6zqbwY/AbRlFuz0lVDgOYiFqjVtzrGWMXsBeROuW/UhcCVUCJqxHZ?=
 =?us-ascii?Q?FYvBw7oFcBbeA+exXhXYDQ185uvLm04TWbaO73tH0f0H8ueQ9g9AcwlcDMxr?=
 =?us-ascii?Q?dx+8kNJ/83tzOWKZEPAGdEV/eFUcjX60ZEJSiBYVufHf+BoUMiVotAekbIxi?=
 =?us-ascii?Q?NH+MZO8+ptWt1YGdXBx3uoKZ9dpV79U5OjKSOQDrDixzGgg4p06eYQXbsA5b?=
 =?us-ascii?Q?Hy4umfr3H4a9voj3YiQKkE2w9uXa66r0k/w6+Ihx0f30ygbb74MKNkkY4zRw?=
 =?us-ascii?Q?lXshB2vI7GCKFw9TMlxqj+pwqR8Vr0FmsA5DVV4RdRGs6ZcvAI1SZZ+NauWA?=
 =?us-ascii?Q?62lL9CRdroIJje2Ar4hXysqqRv2QRsp8JzO3cBuVascNoJPomcBX4zaxstAi?=
 =?us-ascii?Q?weZH7OxDhABzN9uZVlC7EwoLRjKrdmoNjfjzNegNQY+jGw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PWVAFrKcTgL15sXzeKMUKO31M0wxfsKxaRU5JSjYhz/ckwzYJDlsCpSM1DPB?=
 =?us-ascii?Q?fFToSxrg7/yQHSCZvS3K+C6rS1izqRTMFL0Bzm5jf63rs+5V/WBA6kKCTMJy?=
 =?us-ascii?Q?xzGD/0OEdYak/ADykMPj8QVv08mbsO1LOMnzps0II08djcmH4DO/17oUUfD6?=
 =?us-ascii?Q?vWLQfli2DMmb1KZtUv+31cJTZUYlk6HOeaXBy4Tz4i6YwNhh/sf0KVtyz1y/?=
 =?us-ascii?Q?sm8xc4SP3CQvqqPUCgMzGxU459hGx+WtIW1+nZ6Zxq+Ilib9pC+O+9kTtVCS?=
 =?us-ascii?Q?QHJlPDdCm3eQFHoYP72J2TqCafb39TOfXZMxAusqAEvHctbwMOKnvIRiNt+F?=
 =?us-ascii?Q?B7q8hpo7pORHEdeCFtVyAgflREAwY53QA+RBKRMBN43gwcUNWFPDJGdcftct?=
 =?us-ascii?Q?rX1+7tY5+LwptzoEI0Op4zqpcUW9irVTz1wguabgQY3tOYu6YIcrvyuY96G0?=
 =?us-ascii?Q?ZtS1mJpdaTwdrtUOnua0Qh11e0XurJ/cQLqZaGN1y9At/GXBMQ1TLbbmnYrT?=
 =?us-ascii?Q?VWD1JT5bN8PoCBQUNHYUqvKe0PJzQ0odYGjDsVZnY7evVoNwycM2pIJ0sEKv?=
 =?us-ascii?Q?mc/t28m7TiEvixbS+IdjxAWklI4/obBRgLJ0SdO+YNtrZ2wLcr6LxMb8Argv?=
 =?us-ascii?Q?yBPhxvucTeZ0HBGPPOO+qZ1WcImP59dxeSld8uvkbNQidMMyVXoJSJs4tRso?=
 =?us-ascii?Q?81lY/RCsPEqtDr1tyxRKgK+7LevCJqxqaURFtWQjzOsLMYswVS0gfBE+Uoj0?=
 =?us-ascii?Q?4h1cOgk54qd0XNK3EoTwcbUT//frfai17eUIkauNH1HpDnjxBq10+yRWfVSL?=
 =?us-ascii?Q?cMyHER3T2vo5jieg4I9QfagJN4IOtfjS5xsPc+SQx4dAAy8KVo7gX9tKYgfd?=
 =?us-ascii?Q?aq7iWTiA/6SfYbWOWrEWuAmwo5O4SRJ4kfZtvB01U1eWrEM5gPncVxNFHT64?=
 =?us-ascii?Q?Z/kuQj2G/eYpw+D35rTzh4lYVyQldJFDcQ2uInDXpJyAEGVP/mUoHiANkSSB?=
 =?us-ascii?Q?yLIU8XeYmzLG2l3amdTkjEbJj8gxO4Ao5UWQqGNqp41NYivaqOpHhmRsoCdB?=
 =?us-ascii?Q?+eLuJxc0xRhTJEui6CCMkaJbsm31qsBnX2NB0fW6w5AZqoCWvH0fB3HfJMLq?=
 =?us-ascii?Q?p8+vnqVmk5Lk7vz0ourahLVM406EHFvF27RaYLl3QjJc5WcYoUmXSp0TS3vs?=
 =?us-ascii?Q?SLIAUi9iyoXnicDu1j0xYm95bmUK/I/GvaOum9em7VLDPE44mTQhh/wAxq3b?=
 =?us-ascii?Q?Yc/vF6f6JHqChY7m2otLYtW4Bz8GcHRPit+B+GkEd3koQar+GVOXYno5/kev?=
 =?us-ascii?Q?iJnenk9/xBT+zTi7HXUhpYlnDSmzVDElSvgLFIkAK/BZjGJZHpwpu6mtwx8v?=
 =?us-ascii?Q?5QESrjHZoC4hfWKbEo+p7Q7gFpVxzASauiEX3hsGKNPmaG0TfMIXSRdkHWeO?=
 =?us-ascii?Q?YmzWkBAWaUzScTq1yKkduM9IREj3VmyRlIZkCH0Ajll9WrvEwqmtE4Coy/Xf?=
 =?us-ascii?Q?/RUzFjpjvyom2FkJARkiTgd0wu8B9sN/7kk9jNQOqx0d5dJWSo2rl0hjEAKa?=
 =?us-ascii?Q?U//hHFSM2hyWmjc+V5769n3VX5Crv44jFZuP8kTe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958b1eb1-28a1-469f-c121-08dca0e764ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 13:51:27.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: um7SnQqhf/MTF1NmdDl+eTvpYyODxCaRfMk/u+gN86Dvl8yElZ99UDB242SAhZPY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8337

On Fri, Jun 28, 2024 at 01:11:11PM -0300, Jason Gunthorpe wrote:
> If drivers don't do this then iommufd will oops invalidation ioctls with
> something like:
> 
>   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
>   Mem abort info:
>     ESR = 0x0000000086000004
>     EC = 0x21: IABT (current EL), IL = 32 bits
>     SET = 0, FnV = 0
>     EA = 0, S1PTW = 0
>     FSC = 0x04: level 0 translation fault
>   user pgtable: 4k pages, 48-bit VAs, pgdp=0000000101059000
>   [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
>   Internal error: Oops: 0000000086000004 [#1] PREEMPT SMP
>   Modules linked in:
>   CPU: 2 PID: 371 Comm: qemu-system-aar Not tainted 6.8.0-rc7-gde77230ac23a #9
>   Hardware name: linux,dummy-virt (DT)
>   pstate: 81400809 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=-c)
>   pc : 0x0
>   lr : iommufd_hwpt_invalidate+0xa4/0x204
>   sp : ffff800080f3bcc0
>   x29: ffff800080f3bcf0 x28: ffff0000c369b300 x27: 0000000000000000
>   x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
>   x23: 0000000000000000 x22: 00000000c1e334a0 x21: ffff0000c1e334a0
>   x20: ffff800080f3bd38 x19: ffff800080f3bd58 x18: 0000000000000000
>   x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffff8240d6d8
>   x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>   x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
>   x8 : 0000001000000002 x7 : 0000fffeac1ec950 x6 : 0000000000000000
>   x5 : ffff800080f3bd78 x4 : 0000000000000003 x3 : 0000000000000002
>   x2 : 0000000000000000 x1 : ffff800080f3bcc8 x0 : ffff0000c6034d80
>   Call trace:
>    0x0
>    iommufd_fops_ioctl+0x154/0x274
>    __arm64_sys_ioctl+0xac/0xf0
>    invoke_syscall+0x48/0x110
>    el0_svc_common.constprop.0+0x40/0xe0
>    do_el0_svc+0x1c/0x28
>    el0_svc+0x34/0xb4
>    el0t_64_sync_handler+0x120/0x12c
>    el0t_64_sync+0x190/0x194
> 
> All existing drivers implement this op for nesting, this is mostly a
> bisection aid.
> 
> Fixes: 8c6eabae3807 ("iommufd: Add IOMMU_HWPT_INVALIDATE")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied to iommufd for-next

Jason
