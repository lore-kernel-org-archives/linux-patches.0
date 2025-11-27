Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D2223ABA7;
	Thu, 27 Nov 2025 23:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764287655; cv=fail; b=m6mq0ynCiy2VEnXZ6MeK6xI5hmveocNv5aSEXTXx4AKjxjNx1LlIvceXheNw9WlcFlHxHk+7lqmfU6gGTl5HwrJvWg4JjDO+gSEPkL8mHSpZBS6EzixXLXnWiMQOlObIHlgNb51W4ctzhTGQ82GVKqDKUAlGTPDDzj6JA6hWhkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764287655; c=relaxed/simple;
	bh=1S68Ds5UXfxJg4L7M+AnxW42TfyL0iIrp9+R5B53e68=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Eip1cwnPnetIPZOBejwa3fD+j78XOWICyeoccPVj8B/tn0YDUV0iZxK31chNy3aId/YqQu8ebu/gluEiyY5KHneoshDNO/B0GTHO4Z3SCbuprviQtYVm6pTJexae1XTgr3OSkMzcR2xo2C9haUcBqiXJy8tRUhsYuCtuQqKst0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nMTNegTO; arc=fail smtp.client-ip=40.93.196.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nMTNegTO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mbmzXhoEc3lQvZbdNUrcmjPE2QjhiF/dHcKVtJEurXAI+3ex2wSX8QSpMt9VJN3mET+fSywNHESGZ2jlphlamAvN2xYUSqvgwI19ISavuz7YsgjtyQC35cxjU1knebNGYyO8DMObdNyzbisGskJPbJMBRrthen/WUrDdyehNlti+bPyTGNcmJjLd6WilssXntqXwG9XGoHERzO86Pj3D+a6NgzKmL9j1SFqltv/RrHjIPZWmKnoWacoqnUtHmTUjeN74QjF8KYQbPxnLFJrZcRvWgh1CAa/cxwrVar5W5Nfn6/ndxJmsS23r2Ty106joLO/+NMaDz3grwj/9BGCgvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOb1KWOXRLOAr3w+EkRijcE0F7jl0a6PGFE/Y0enrLI=;
 b=h1zJ7PjQfT24z2jgszCl0uFnJrTSkiVUBE6ngzuKq7femcPXXIbwxjWXrsRi+w3SiKVN/hiMEuGwMj1gAD54Zs9eF4Pyv2OWEipRQvcw6TwyyOQ+3tnEbQTCQUvsmAPAbVeJzAhrfxaoB4LiE06QFLGLY57dbwZNvVUvpuOZBkNd7gbfYN9VNtCkMCClfayWI9XheJ3q7Go1sKyGg6k08+pCf8+bUd9P+eIGMxz9LaW8nVJqAbyUTFOjiUtDmVZTo0uTvyx5p2dU/a/dTdev/+s0DIKXMvXf8rIgTFU3RJHAwxwXS7gJwshJg7sNgCO+zE3kkW+V414v10w/SgKHFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOb1KWOXRLOAr3w+EkRijcE0F7jl0a6PGFE/Y0enrLI=;
 b=nMTNegTOFFTtWhk7/YeDXVzwZR846CUPAl+C57jq43IOWx6DT05u68RO3AYn2W8Ej5EvTLHA84tMg0YU5oQ8xXpt9Loa/pIrkrSioZgA+Kn6Lznz5S1Ru7InL5qcxFukiQDA/F24uWPmN02J/v4iPDUK/KvdxcyABpah2bGNOVw6859uKMkRI8oRMdQzGQHK9ofKAgp1zqhdDNFHlqhGWhPISVRV3ANxHBzYxkni+qmAB6ClUNlFsqYzDEJ+Sib55kmbqe7P45T4T1ZmCLQUURdGhtgECaYggYIr6Ddere3PVrVL9UNax+Bj6xNWizL+zybTeZm6z1Jo4ZrGeYq1cw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.15; Thu, 27 Nov
 2025 23:54:09 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 23:54:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Calvin Owens <calvin@wbinvd.org>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 0/2] Fix VT-d when the IOVA limit is small
Date: Thu, 27 Nov 2025 19:54:06 -0400
Message-ID: <0-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0061.namprd16.prod.outlook.com
 (2603:10b6:208:234::30) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a7b3136-46d1-4680-c447-08de2e1041fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eEuuySspRg/7HHQxCZY9jbEz6twNtuTk5Y3bAkky2Nrhjq0MGICQkbEQJ/Fk?=
 =?us-ascii?Q?zcdMroHENvgeHBFb717Tc9kRGQ4sEds8OC8CA+zVDUBpYUV3rcktoEKAN6/n?=
 =?us-ascii?Q?H1pPEAPNtxQ6rHEPVps6dZjIzh9fMOx9XNHKPzSbZYrmhfVr4NUnl4WwzvY9?=
 =?us-ascii?Q?vxW8v388GfslI++S121LP0CV0cVZhPpahUcm7DprGfnq1DRuqI1eXefIUZyN?=
 =?us-ascii?Q?jUIDg4zUTQYvf3n/A91VwHqfb3SL2tv2gy0kzxBbbu1aoNBeVA5EN3U0N6Vt?=
 =?us-ascii?Q?UcrDCJtipRy5QbOcxtGhZukwljdFrFSe3jR3MbjpTAIGuUVF1T5P5zJBMnib?=
 =?us-ascii?Q?Nf476aR0MAH6alV1DLzOigLOzn66jT19KRDO9FsSmnPnzwKCUeMAV9Mfqdg9?=
 =?us-ascii?Q?wm+e13WDKex8rf8/eoSmVm2MB5MRpjVOj/HQ+eXw6oGJ9BoImsbViXs7+KDP?=
 =?us-ascii?Q?WtOG4KuGygCKNXOYIVBGnY/VfFNSMJhT/WFNXeia1u42V3kgnOxyyAIvmYWj?=
 =?us-ascii?Q?4L6xFBMpeyzJJMbgcBJy28JK2Ue7UwLgLm8sM+xHs/a3pUQMJcfRNa2xii+B?=
 =?us-ascii?Q?Nc56UxoKIFYckXbGiGEcVvn/HYgHO754e7x6W60ZpR7EbxvI6cNJ1WwCf7N4?=
 =?us-ascii?Q?xnEG43WrkbTGwzjpRWZWZ9nwKGWW6TuzQwwpePXzvWGmLNq5sNitUBUZVsdG?=
 =?us-ascii?Q?cQOgaNRL3UFFKSpQIAkC91V7VDYsizUBwdAVjCf5/hVpEAFTO7yYXvqK5E3J?=
 =?us-ascii?Q?bgZORf7jvTGH/+o2db1M43Ck4bpooT4P+ootcY/w2NGL0wkwMlxR+u7XTyGu?=
 =?us-ascii?Q?/+Lhx0XJjYCc6z1jMNFtxj9C26P07MnSY4rBvNPWtZayByZU7OTQMmE6n3Jf?=
 =?us-ascii?Q?02l/hlGFqPd3fbult3O7sunmBn7Zba6ywqbx44mEyx5QZop6/iWhuMiiBadq?=
 =?us-ascii?Q?EImYRgFaqRJaJ87FfZbuxqKlIleMAO6CY9U/kvrdclGwvN2X8LeEIgarAZlx?=
 =?us-ascii?Q?KASjl40oAQMJAxS0x2+Xuc9xlPDhPTBUQD0Bz4Ros/KY2OM0Pj1pV0whSj1P?=
 =?us-ascii?Q?bHox9iMYODJq9Fsxefq+NzJsS+ZSEmWBc36vQwpibtd9m/cqc+hbTxpBMak7?=
 =?us-ascii?Q?ZLBq7ASiAIO/eH9X9jjwEHINJu99CcuTl0RtnvEvaB4HMXPM58I45rlZv2jb?=
 =?us-ascii?Q?e9dsuYaSQetOmgthHikOOh9JIHSE3z6FaVnCqNNiHoLuwxOPvD7nUrisc651?=
 =?us-ascii?Q?evC1Uuxnvkm8TCFTnKVbXU/jD4DmwHhnNYCF4nAa7A0gBYHxTsEr4OklULuS?=
 =?us-ascii?Q?i51hw3PVsnUw64OIB3hJ77OH8l9jJwvDU4K3Ne2KkMyFuBMZahT1JUUfOD8W?=
 =?us-ascii?Q?dni1U84Ig0ELIyShOTBFXvBY21ikIML9oOGkafHe20PwELn0IK5gZ/ryha5T?=
 =?us-ascii?Q?kPew/Lz2ZK70ruPUH7rp5WyxvuxlH1E2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Frz/F8jeOrU3EFGPjv1IlpNU5nlqP1b+vYfCC3iJB9aVHlFG6z9Vn1ZXulzU?=
 =?us-ascii?Q?FPQndpc0wfEtFRvZQxAgPq3u+dK5C4ohdb9dm6uthkmr2W4IonHdb+y/odww?=
 =?us-ascii?Q?LSSvweYxHBVKqTZV/IuPykcOMDCDpJmxVQie6DURYGv6IsQnk3Rlcd8ABtvb?=
 =?us-ascii?Q?31PbHPgVpxuWbeJfoTY7rpJfECyEBQpZ/ZO0mrp6iP/zBRdtwLvzls2QIvVG?=
 =?us-ascii?Q?VYZ0io5JCB1DzCZ8MpXEMh2LZXW0hTOQvoHtWAT5wfre1NvOtBuFnZrNQ+nI?=
 =?us-ascii?Q?7JPUUxppV7cPcsjzjMc0Vif44k/ru0wdidqTedawlvmo58JKGkg0Q9RUxwdt?=
 =?us-ascii?Q?q0Uk+hfSI/C4yJlFppADEFo6vBEO208vavWDkAe0S+Ss/eAXsc/IWl9wBJd8?=
 =?us-ascii?Q?80RRoiDoHunUukIbgJOjcVSu0nHGo2DiKj5ZM5Z4Pz6Ivnbj9H1Mc1NnZcXP?=
 =?us-ascii?Q?ehUU3SmMlBJTaFLVrrkBjjSPU1qjLo3IdTWsGKggei6Z5lg58nXdzIhiTx5T?=
 =?us-ascii?Q?wj5Sju8gXlCsal1rMNMiqRrg/cEBLCHPb5MM+2cDB3eedyqXeBUS16npvod0?=
 =?us-ascii?Q?J7HZ1eXf9yoDWDRT89HE/F4QMZJap4zqWrelDBzoUDpKM06F3EGSS7f/PPWd?=
 =?us-ascii?Q?8r9ZXPX4Z66ghvGh7biGdzjLrcuLlCufY/QQ03NZnhNGsFE6U+9gHUE2Rr19?=
 =?us-ascii?Q?K0rSAuzbksQV1STrAXGyEUktsy3B4zsGLTeK1F9EsnGfNpMDSxvbLqGorogs?=
 =?us-ascii?Q?HkI2WtwopGGwK5k1qxXhf2BYTxwWDB5eqtkyKXb316g+5sLfa3y6RRyZZD1b?=
 =?us-ascii?Q?1O8+OhVoGZFDT2lacFTcBn1NcztbcMTbVOZGQsYekG6d7+CWDmUwlvPMCV/l?=
 =?us-ascii?Q?URuLAL+sB/+KMxYeppIpGe0EsK0xaejCof0HaZUX5xr0Ytm2RfjQBq7Vf/mR?=
 =?us-ascii?Q?aPL8szZGPS5PD1b+Or7ZmdnvLnT1NLHzCk3g+vBH3CqSVE0jSWUtPq5VfXRs?=
 =?us-ascii?Q?mb4HPFOk9ho/cXsUQiQ0+NZQattx3Tu+Y4QIJan4SKhkA8UlqlVke/4HQSEx?=
 =?us-ascii?Q?fcs2o03c/hHE+o78V1GniZzUKAhmN8EpaNITIFilgNvz+o/JrntibOD1aw+M?=
 =?us-ascii?Q?j2+Jh5zxxuEM+MrMp57NgR0BzvOrx0Bi/FfTtKAwRzMSCYKHSn1aXlv5zD7Y?=
 =?us-ascii?Q?quIZ6sYW5DI1rcOIEmk7ZMYTfUfjO7EujVH7cs+SkdctRNBTH3hh/DD2Smq9?=
 =?us-ascii?Q?Ztf63PGmLHNcgFpqet1UgwePFxLQ0TxVXOBrjCjU45C8HydKn0z4kzW0n91F?=
 =?us-ascii?Q?r65lXOx27FLzi5nUtVhovUNWiecGMOw2+L2FBdc5dagDw2pn4BKvfOxnwWGn?=
 =?us-ascii?Q?PuD+dDXO7TkKJ3cVSM0Yz0dBJufy688GBA2U/5nG7TW2iEszb0lVdkZBxoTR?=
 =?us-ascii?Q?p1zdhbWJSucVNDv1UtdfqIdFSVsLU6IWHDhjoi/6xrk3h9WVIIpKmQ+Rln9U?=
 =?us-ascii?Q?KEDBzoaUkGNXc4up9FfwKNjRJJJUyXPnuBt/t2foWt7o6FDBm3tM769NJoiY?=
 =?us-ascii?Q?wpkM5Zs6P8eaXtWVjpA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7b3136-46d1-4680-c447-08de2e1041fe
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 23:54:09.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qk5iCsIJHjzkNu4T9/hZIOdfXZM5j570YcxK8mXsFSXgaQJMQXq4Ori8Fsa38o9s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926

Calvin notes:

=======================
A Skylake machine has problems with strict translation on next-20251124:

    pci 0000:06:00.0: Adding to iommu group 18
    ------------[ cut here ]------------
    WARNING: drivers/iommu/iommu.c:3055 at iommu_setup_default_domain+0x268/0x2f0, CPU#2: swapper/0/1
    CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-rc6-next-20251124 #1 PREEMPTLAZY
    Hardware name: ASUSTeK COMPUTER INC. WS C246M PRO Series/WS C246M PRO Series, BIOS 6101 06/26/2024
    RIP: 0010:iommu_setup_default_domain+0x268/0x2f0
    <snip>
    Call Trace:
     <TASK>
     iommu_device_register+0x126/0x200
     intel_iommu_init+0x2bf/0x580
     pci_iommu_init+0xb/0x30
     do_one_initcall+0xad/0x1c0
     kernel_init_freeable+0x238/0x290
     kernel_init+0x16/0x120
     ret_from_fork+0x1ba/0x1f0
     ret_from_fork_asm+0x11/0x20
     </TASK>
    Kernel panic - not syncing: kernel: panic_on_warn set ...
    <snip>
    Dumping ftrace buffer:
    ---------------------------------
     2)               |    __iommu_group_set_domain_internal() { /* <-iommu_setup_default_domain+0x25e/0x2f0 */
     2)               |      __iommu_device_set_domain() { /* <-__iommu_group_set_domain_internal+0x6d/0x140 */
     2)               |        __iommu_attach_device() { /* <-__iommu_device_set_domain+0x6d/0xb0 */
     2)               |          intel_iommu_attach_device() { /* <-__iommu_attach_device+0x1f/0xe0 */
     2)   0.140 us    |            device_block_translation(); /* <-intel_iommu_attach_device+0x19/0x80 ret=0xffffffff81b5e980 */
     2)               |            paging_domain_compatible() { /* <-intel_iommu_attach_device+0x24/0x80 */
     2)               |              paging_domain_compatible_second_stage() { /* <-paging_domain_compatible+0x47/0x170 */
     2)   0.137 us    |                pt_iommu_vtdss_hw_info(); /* <-paging_domain_compatible_second_stage+0x29/0x1a0 ret=0x1 */
     2)   0.530 us    |              } /* paging_domain_compatible_second_stage ret=-22 */
     2)   0.907 us    |            } /* paging_domain_compatible ret=-22 */
     2)   1.653 us    |          } /* intel_iommu_attach_device ret=-22 */
     2)   2.157 us    |        } /* __iommu_attach_device ret=-22 */
     2)   2.528 us    |      } /* __iommu_device_set_domain ret=-22 */
     2)   2.954 us    |    } /* __iommu_group_set_domain_internal ret=-22 */
    ---------------------------------
    Rebooting in 10 seconds..

The failing condition in paging_domain_compatible_second_stage() is:

    /* Page table level is supported. */
    if (!(cap_sagaw(iommu->cap) & BIT(pt_info.aw)))
        return -EINVAL;

This happens because, for many domains on this machine, MGAW=39 but
SAGAW=0x04: that claims a 39-bit maximum address width, but also claims
to only support 48-bit/4-level paging, which seems odd.

Before the GENERIC_PT rewrite, the kernel only looked at SAGAW, so this
machine has been happily running for years using 4-level paging.

Now, the kernel refuses to use 4-level paging because MGAW=39. But SAGAW
claims not to support anything else, so we hit the -EINVAL case above
and fail to initialize.

If I force 4-level paging, everything works. If I force 39-bit/3-level
paging, nothing works (lots of bad context faults). So it seems like the
machine really only supports 4-level paging despite the 3-level MGAW.
=======================

Which is not a possible condition that was considered when this was
made. Allow VT-d to pass in the top level of the page table as well as the
max vasz as seperate things. This lets it setup something compatible with
the HW.

This is happening because VT-d doesn't quite fit into the architecture we
expect on Linux where the IOMMU driver should be reporting its full page
table capability as an aperture and bus width or addressing limitations
should be attached to the end point devices as a DMA mask. Instead VT-d is
putting the device limitations in the iommu as well.

Jason Gunthorpe (2):
  iommupt/vtd: Allow VT-d to have a larger table top than the vasz
    requires
  iommupt/vtd: Support mgaw's less than a 4 level walk for first stage

 drivers/iommu/amd/iommu.c             |  7 +++-
 drivers/iommu/generic_pt/fmt/vtdss.h  | 19 +++------
 drivers/iommu/generic_pt/fmt/x86_64.h | 17 ++++----
 drivers/iommu/generic_pt/iommu_pt.h   | 14 +++++++
 drivers/iommu/intel/iommu.c           | 58 +++++++++++++++++----------
 include/linux/generic_pt/iommu.h      |  4 ++
 6 files changed, 73 insertions(+), 46 deletions(-)


base-commit: 6b99b135be1b79230acb88865abef6fb0fba35bb
-- 
2.43.0

