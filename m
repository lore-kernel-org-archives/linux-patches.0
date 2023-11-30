Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A388262B;
	Thu, 30 Nov 2023 00:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mye/6Joa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiHSgsLFS5dpjuDNwmU5ZYBUTiGSlODZlenN+rDwfBTx1cpkWYrEvl02J7mCcV8Bm6kxOh6lrGrhpBnS4Pdz/Eozb9Nh2HIIHO1R5C+aYElqWJl4uLGa/ZPaz5WNgH24Mwp5e3aNE5KWtDF75Kh+zDQsogOtg47aT9sUb6W49PEcOymiKl+tQz5Q9vLqQlhYdWHmh+UYk4Mj/D1ks/9oJsQKOX4a7vvxVBLkN1CgcrLsY58S52lSxdyrrOl871X45VRrAo5uIcNMRL/wKFeWk5yuSA2zsUcJxR/pV7i7QCurwAw5I/jApELPRzRF0urZ3t4R1fL6wGARlzjDi3WbQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjoUrd1T9VI3umfzovSLL7Ep3GMMa2dIJKaOQZvZOX8=;
 b=BYolFq3xqGkWkL7z7BrPrdWmwoR51E6Ik4DCQk320eeNPwVTXgVioPWhUi2wt1SYo66wjcp820nC8oku4iFys4uwPIzq8ca7QzyJAdEKrqnki9TUzrRdzdnOufBp2/tgJM4PC0P8pBEDBQdoGSBp2PQ9p1UwuBAl1EIM0NlNEZu7B4zNji3HP8Gth1HDBW4LQXf7Aoqn8M+WyyTbOwaxuxUH0qtzU6ORWGQWFWQYCa9drq1E4XEdkCQkU7N5J4Bre/pmzsNQE8EZVTA+sEat24wEFMlLUVmZj445SQ223zaw6GFo4848ZZPeOjkDAerjhDyhPjCqU+CI++ZZTcHJmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjoUrd1T9VI3umfzovSLL7Ep3GMMa2dIJKaOQZvZOX8=;
 b=Mye/6Joa08KedvdAtIR8MEmbJ77IB83QAvDYPFjf2VVgQv4ZPbvJ8Ypb0tJ5SJDr2uezANYfjFRgpeTXGj36xX3GlDu7RITCqSay98mBF3SuCjaepSkkZZFdAgOFCmvkCepa4z1U1jOJCfPi2hVV/GZwmOAckVZRtbi1K4IqWaZGfWBjzvJc9KOA2uaZU5ZI7EBN/vTctOhi0ySOTsz3BWSAWq1q5CbQ4UzHI/qMRIg0dp8RfOXDW95UuZrwrLFMMNpIk2le7QVv48lJW3/tPHMipludHVwhZJhs01pnWGrauVJLm35IN8cxyw+pzt/p/8MluVqXyb+9p2dQcgzpLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6228.namprd12.prod.outlook.com (2603:10b6:930:20::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Thu, 30 Nov
 2023 00:37:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.015; Thu, 30 Nov 2023
 00:37:24 +0000
Date: Wed, 29 Nov 2023 20:37:22 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	syzbot+7574ebfe589049630608@syzkaller.appspotmail.com,
	syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH rc v2 0/2] Do not UAF during iommufd_put_object()
Message-ID: <20231130003722.GA1395235@nvidia.com>
References: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
X-ClientProxiedBy: SA1P222CA0140.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 0159d956-30de-4c39-00bd-08dbf13c8588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	t4W9CnAvhznPKjrcuDPnEbUNl4/U8BErD4/2OOJrg/tmMi2KGPPul8Zaa2uKubnluPZG7L3QoCm+bs8cowY0QpbWnTFmdN+DJGlHiVHaFjmLVxCgR5sEn4IAZPLuWBMDSNMkwz/lRbF9iVXmvMfE17qDF3/O3+uXWakAU0UboPvH8nmH4ygDMTkSgrdmDS/+lzvTnetg+NKEwGrzayBQ7nRC91U7LnnGZ7dAjQYJmdUdjQt16tUsipf0+SM2hgwEU46l1rtVCcrm39iE/Kl7PwWwf7l6fus5sOoTCvhXCDKIfOYb+tZ4gj5OwmXAxILRkaZtnackWbAxGOM4QhXbpB/HSd4Vmiy623kV6nHTMD/yzVxJRzuGrVLHAXvG4GvV230Z/RT07DoPW4AKop6EAaXeCEFcw7VlUWgZMdPD9STJtwy/UNgr21yb4aqzZalDC/Q4rRh+mDRkdcrSnKu+F+Rs4YhYrw222XD9rWyE48j3gNcS793eJkP/p1t2GvyjlAD7cHcUc6tx8aEkTWbu6s2IC+PF/a/uYHtHYdlSSU7o25dcn7DMVwXZGr17/pjoMpsfygVxtiu5dL7/h4VrtOiRYGM5H7rFG8I40VKa82H26vnaF441zXNycJI5p9yl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(136003)(39860400002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(86362001)(38100700002)(36756003)(6486002)(33656002)(478600001)(966005)(54906003)(66556008)(6916009)(316002)(66946007)(1076003)(26005)(66476007)(6506007)(5660300002)(2616005)(6512007)(4326008)(7416002)(2906002)(8936002)(8676002)(41300700001)(202311291699003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z2xc2w41fMyzCH66+td32LPrI5ap+CUPnLafPtYZ/lPVDHF4NZHtKgXsp9wB?=
 =?us-ascii?Q?jxiZuFvf6frvOdyPPWF71oU5Z2XQvlY9eoyNRlFzCBozYo2f2cOl/qvQLIjr?=
 =?us-ascii?Q?HR+yIJ+h24v5Voxh0a2fjAg2A5BL2TIp4gtKn7tKeDw/tP3geXPnn95kdC77?=
 =?us-ascii?Q?UiGzXVrLTHwJe6Zfhv7331bnok/TVBMeeJQ0xhS5aqN+aIbk7NCCQim4xv9n?=
 =?us-ascii?Q?uriDMxIYQ6D9xfX7c6smNRH2LknorgIy67ECcnj5rPRP0JUXmKHmboDygXAE?=
 =?us-ascii?Q?xXV5ybzmAxYmyyIU3f2qlWWrs/cZcHtf89BzCgy0qcth7R6nwc6SGba/EE9+?=
 =?us-ascii?Q?19k+iUeGMoc2w3GZM7NCYuYBKDI9H6QXl+T0uReKCamlwwoXWXH1qNUsHRjj?=
 =?us-ascii?Q?3XpvW+PVwebwLML60Ec4TG1/iAdCau+ysYlovMGFDOVcBcKw2gbhdfChS/KI?=
 =?us-ascii?Q?GShqG8eH56HOPTqaRJTHTsYUvzaK/nOTgJH3kZZoungP/5uL2/Rn5bZDBpor?=
 =?us-ascii?Q?gQlevHZ6T0hvGTPVHdxCR6EVl/17eNEa7OC1rUANGARqud4yKhpjsRumsrDr?=
 =?us-ascii?Q?13I6ydvwKlo0l6KqeuwhC0GEG2ljdPFKTTjmHLnkOXs7PCrApnawCH/NUsrm?=
 =?us-ascii?Q?ymhj7G2gOuTkykxajIZppKWN4v06oxJhNzZDI9tZ4vQv5fJfCRtbB8Vld4Py?=
 =?us-ascii?Q?a8dRUoAfKFD8DGs23puSPJaTByts75DV9KZgszR+vxWVxj8h42h5KTWxyJrm?=
 =?us-ascii?Q?JAEGjf2mwGXZgrf3b75jtFnFnY1B1wsp7479lNbh8dFc+TB5f5+oE2lb1tkC?=
 =?us-ascii?Q?I01E184RsIosCFwtsfpVG71G0FZldSj/uREqZKcPgGozY2pfs1eqSb9J2psM?=
 =?us-ascii?Q?HbrPLuQkYA6ebIBdqa0nupIlXePyBAnaWNjHl7LAWyzq0H5sL57qvEP6L1aR?=
 =?us-ascii?Q?y+j+Jj+Q/hgs855dD4v8JPXMhdd5egARoeUbZfMJsy3SMx/HhAiAjL8qZcjO?=
 =?us-ascii?Q?yA44YSwWlqTwErWVmbAx45SZp/FQ4atQBb955ht5cuUdxok1jFwZHp6ElzO8?=
 =?us-ascii?Q?quJIRFCvfiZf9lHkMvJokn12t6wYqf9DGdAfT+5P+ICInuhkBWyo+bG0BpQz?=
 =?us-ascii?Q?sN7l1fuZBa+IoA5ag0LGeRAWRI6AKRejcTB6J5krP9e/02bpVKXrNF20rB9C?=
 =?us-ascii?Q?Fy52QLdxMdq3R7yDnXedsH7gLl642IFWVMkZO6D+a/H8yH5mP+nbkxHn0WwY?=
 =?us-ascii?Q?YNs+z/N94+JLjGbodjWYG/1yNrTQhxx4sTXtv49ril3X01PV5HDHvCAWXX/t?=
 =?us-ascii?Q?l4iTiCLxJg+m3bA+lXHURSkmu1IPjQe+HV8LgI2uOSMzrgeJTHi3WBhIH1JU?=
 =?us-ascii?Q?2oieydNFI2D6clyKmVKZMM+HTwR1k8aD0eWmBvXODkxdq635teysijYGx3Yd?=
 =?us-ascii?Q?YHPkRbVwni844MK8w8ix+M/DcJLRWcafWfp6gneFDOPXFMCHvPGhwFTl2QJs?=
 =?us-ascii?Q?S1/ANVgCAiQsOBdM7ikdP5oMkq8XjS8LwhVBjliRlENS8TUO2zzJzGtEXEPx?=
 =?us-ascii?Q?QvQhecNVo9kxuUG+Pl2lzjLSBNDDbU/tQPVKxfaT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0159d956-30de-4c39-00bd-08dbf13c8588
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2023 00:37:24.4685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXa5JM1ZjSBFTEXCtTPfwL3JZyMxDOKDb8O63kbn9+VRWgdSiI9cNFKhE50px9zm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6228

On Wed, Nov 22, 2023 at 09:13:17AM -0400, Jason Gunthorpe wrote:
> The mixture of kernel and user space lifecycle objects continues to be
> complicated inside iommufd. The obj->destroy_rwsem is used to bring order
> to the kernel driver destruction sequence but it cannot be sequenced right
> with the other refcounts so we end up possibly UAF'ing.
> 
> Fix it by using two refcounts and a wait queue to sequence the destruction
> process.
> 
> v2:
>  - Use refcount_inc_not_zero in both places in iommu_lock_obj() for
>    robustness
>  - Move the wait_event_timeout sequence into
>    iommufd_object_dec_wait_shortterm()
>  - Consistently dec users on the bug path to give close() a chance to
>    recover
>  - Change the order so if users reaches zero then we clean the xarray and
>    then unlock. Wait for shortterm to reach zero outside the lock
>  - Make iommufd_object_remove() non-static and use inlines to call it in
>    the various cases
>  - Comments
> v1: https://lore.kernel.org/r/0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (2):
>   iommufd: Add iommufd_ctx to iommufd_put_object()
>   iommufd: Do not UAF during iommufd_put_object()

Applied to the rc branch with the comment updates

Jason
