Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06E32BE057;
	Sat, 31 Jan 2026 00:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769819255; cv=fail; b=jv4N+fl0s7qxt2orgCSE0KsG16/Y/IHQsIwiBNcTPWfD1rbR0uKhJLf/f0Twxgg79ONYC2rk90Qcc+Dv5PA5xtxWS7cB4NlzntK3F+nlR5ysmo7pemV+Nzm6ZpUBaP/PES8WvW7wSEUnfBkn2ExMF4jmczfgPRp+SdVKDnqYFwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769819255; c=relaxed/simple;
	bh=wfFE7s54dgzkF3kxvfANokIGlbBwSXwsKM+5iux+bTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eClsSjxvl+3YYTt7Altrd4Jbo9PTHjDaHAbuY17FU5vtYZzGHV7ZjmOJK9a4z00Z7YmRvQ4w719seaAlj/7CzijEmF5YfRugAP6l079IXhp9mFC4pdjftu0c9Z1AowezIuYEHn1ASLZBJnMwsQAJXcq7wOT6VdDQ+B4FJeoSDOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=STCh54Fy; arc=fail smtp.client-ip=40.93.198.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="STCh54Fy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzywlGqns1Lj6ANSdmy43aIZiD18gldiH1mrsH5oJdycUte0YH0zhLygaYZCIT6LJwiZD6VEfcX5vF/yNRH0YYVh8Mxm+gHhhF7WYtuJjzcEl+MuTAPnSlvHLrtAv7FiFfbZjzMWahdI64PeCskXYERTUdzAxN+RGL7F7BuSi4rvxhHra4Pe/fEkvK+DfmjpJvUM1vU6lUMd3KmdcQe+uQA9WZFA/eKnB84Uo4LqNQT4C6wn2CEimT3kIPwcJDYWvA2ZYsqQjeLBrxffDgsR0ZiZeu+iLUkX6dq/t3LjAHFcGBBrfTWg5ZnvMAZ8e47TfQqo0YuV7r37dTCAFfd4DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfFE7s54dgzkF3kxvfANokIGlbBwSXwsKM+5iux+bTo=;
 b=tzRZuikX3LKDUnbCi4p0rrPz+SOKnjZ14ek54macI1Tr10rDT5vx1udrJZM6H028BAUf2e+w5e7teiP6g2t9D37YP4a0Pmvoey//NvIrLzADU2rGokIGX4SCCb2VG0EKRX2rf3qPlqGZncOt6j0OXawbavanM7pbIBfRio5E6XxeMNFh67eaghp3Mjw7HzkTuElpiM25glxmvtTROk1xNq4RlHyno8sO3Cohrm75BoXRKqygPHLnljmp9DBdP9ATjnUGnaa4ya7gHqYFperBbTcpJZUYNZVuBqy4vVtsHt26AbkHODYabsbTXIfMtoZ5EmrSd4+hp7H67FRlWXOmjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfFE7s54dgzkF3kxvfANokIGlbBwSXwsKM+5iux+bTo=;
 b=STCh54Fy8mWF43QlVhgnZ6vJz+MRTpQcK8ESiR95SQ51mVUpjr3KQBj+uJ/raFTE2s8G5euzMVhu8ahY1SpvN9LBcWmb+A4xnxCFcC0M8O64KC0TQOvQD/hogiFCAJ3Dg8PAhPfcnoPk38Z9FqwAX+mrCGsHckFvhVFMBB2N/5D8oFjfjX0tqV9amtqCywuqXS1LkRCET3KZjrzcHWpbBN4F3P7g29oYTPfKlVKmrlv5R0leeyW0BpzF8sCvultWVLYzWkLnRX0+QynbGrXNY7aQiCBuAQ4QGhOJhA5mPcDchjxGRC+77wppceEudQS7suTcpfPjmc4SUWUEa2Ahtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4150.namprd12.prod.outlook.com (2603:10b6:610:a6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Sat, 31 Jan
 2026 00:27:29 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Sat, 31 Jan 2026
 00:27:29 +0000
Date: Fri, 30 Jan 2026 20:27:28 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Vincent Chen <vincent.chen@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>, lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
Message-ID: <20260131002728.GM2223369@nvidia.com>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
 <20260122153134.GO1134360@nvidia.com>
 <CABvJ_xgSbK3omxT7XGJ0N7oEva6dQAJwZxRhsBqi44BRNZ3G5Q@mail.gmail.com>
 <CABvJ_xhY_4ADOsVVbjhkBm8U1mKVOSwzKMfBw5mUsJe=kkUiLg@mail.gmail.com>
 <20260123135234.GW1134360@nvidia.com>
 <b1b220be-fd5e-4f83-8f5e-7d5282be39f9@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b220be-fd5e-4f83-8f5e-7d5282be39f9@arm.com>
X-ClientProxiedBy: MN2PR12CA0004.namprd12.prod.outlook.com
 (2603:10b6:208:a8::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4150:EE_
X-MS-Office365-Filtering-Correlation-Id: 400c5bf3-1641-46a9-5abb-08de605f848e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nMbcu2HpUvaNUAkvmK/GXzJVoNqENzq4zzkL9eVYgvxv5STMODXeFKFzlDYn?=
 =?us-ascii?Q?6BIlND+ySXlsrS8WD5P+WL+NGCvUjtadiX6AOXPLXK/Aqu/gOhilVCCxG34B?=
 =?us-ascii?Q?9+1VLAAGivQ81JkRbVKlURXGmNfMSna6gKjQui06k1V8jp3Qui5yuK+a9L6P?=
 =?us-ascii?Q?sRs+A+QY1GCg0QQqBTQaJXBoVRvelrjrdpz7TfJDD+emvdtv5bnqfdAxGT3J?=
 =?us-ascii?Q?TbTUiJHFCSKm2xrhDWUMTpFIuO5r+Yz+tOVCm+d6ZkzFBUZhMyfC0sYnef1u?=
 =?us-ascii?Q?Q+oMW1FEZ8Mj8/ibBGFOe6r/H1J1GI3DlV7YSyRsYd3ibDJAYhnbzWTnJdhD?=
 =?us-ascii?Q?qzCoN+AnKO0FmxEMJF5QjtvSZAarMSrrsRm3tR6IOTM29YC0wr9JfAq94kJp?=
 =?us-ascii?Q?oGgrve+onn7E4cdZIvYeozAwUzhykLZp9An3RXCaBrya9bZUFBlPwkop8vxz?=
 =?us-ascii?Q?NJ/TUBw6cG1w0HV3MbS9hqk0smCsBhoECVbkt7OPk776YqQCwB99g2zlPqpg?=
 =?us-ascii?Q?w7w5E6otYdHO5BjcifOlioI1ZjytOKb9Pd+RG41vOCz831G/6hTEAy0mpCI4?=
 =?us-ascii?Q?sO4OBB6O9kdLmZ/ZaJ1o9tvtX3iY++LYB120cs0ARA2HL0kj179lqg7xoD+D?=
 =?us-ascii?Q?g/kbi9++526/YoqEMdH+/iIloRmA8poyzmWc2lwhe4LNgwnBFUmdfAEdFbkQ?=
 =?us-ascii?Q?PoExJMhfs3eeOoZtQ4q2+cp4pyi68ngxDAyTvoQpeibIeolYQmEi8wOeKdBb?=
 =?us-ascii?Q?azZZDqSc+9cAuK/Xrvy/N4HYBE2aAI/KTzgKy0Tt5f1IIvur4kpT6M9nfCkA?=
 =?us-ascii?Q?omWk9Ej+akg9HHByUH8PBAJ3rsd3GxHD87sguv7Sp8Vg//lkDc9FeO4R8hOB?=
 =?us-ascii?Q?GuP1pckaNDYo7S1pxdmhk76Cr+IjtGTVVFxtDN/h4S6gwwPB7/DFs7H71UsM?=
 =?us-ascii?Q?BbXKWUG5rjIoy1QAjfoJbwHPZy/TTlLKH0Fgzjhha7byxjIbfHlFOzTnXyCb?=
 =?us-ascii?Q?Cq0f8OlKTE91eerAG5hScAupPz3I+apxTHPFhGRmB6ranvRszm1l04XFzZpd?=
 =?us-ascii?Q?y3ldZ+s1oQYVCvA95k4wDAk2clZ9T3O5Eh91orO3RJ/cbqXZXRugHBj2EmTW?=
 =?us-ascii?Q?MPCv2C+B85vvNKcXaVrUiqmjec+NEfvmmJMvvJctg/3kLLN0VmBd4Zs9vDzJ?=
 =?us-ascii?Q?Tjaj/+9iM+DSZsSg9nseMeVW8AiJsiEB78650cX4gleyBp28aulFm2o2N0yH?=
 =?us-ascii?Q?80r6dFf6klBP8myLjhZTqK7K5kVRN4ZZe/2/E7VqYGQ33GMKcrffey4Y2VaW?=
 =?us-ascii?Q?rEUxz2NwXgpkdtMxz9vJ0+57VHeqwG0AY+r6D8fr7yZe/1+dBN67H9POeEYD?=
 =?us-ascii?Q?VNtKn3LwSY8F5Ak7NCRwFSrzHOG4Wfq+55gHJ/VawyWjT/mxWlJSutTtE8zQ?=
 =?us-ascii?Q?FrEt/v9+38TF9iE10PyG92XHbRgbByB2CANwg707BswgKSivOJc+WvkrP3mN?=
 =?us-ascii?Q?7mXF2rOM/vEGG5BWVsjAZ3kiDY7c5f1RM2gYXMq9k1nAzmydDPBu421fHCdY?=
 =?us-ascii?Q?68PdLBMSldmD3Wjl2X0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kV20XQplqdWSuBVFzsSYIe0f9AdPeT/eS7PKmBDZWMwcVNQc4hFmyiRc5NgP?=
 =?us-ascii?Q?L4bQlSDmXZFyxyMEHcZN3GPYk0YIGsA2140IwubipF58MI4lz14VBlYYb2cC?=
 =?us-ascii?Q?ozx5b6T6P+/SSfSycF/0ar2uzTOnW2Jh84Qf2w83fbWowGYJMqLnBjcpQtwS?=
 =?us-ascii?Q?KDVvXXlo3vUgdxYGQDFvqLOoHtYHG3rzxtNDnGgiFPfbvW94ZTm2OkQDfNLL?=
 =?us-ascii?Q?/TkO5zQrtVRUDM85x73LykOaLLPo7CIf0FmmWneC0c6PD4jlF2W7GKsUVgHH?=
 =?us-ascii?Q?HVXjVy0pDlD+UjJabmz1RHxkEstb3dyVQHBEjemDcRuXQ+sCMuHP+/YstB4Y?=
 =?us-ascii?Q?DRu14dppCqJmeAwsP8GzJ7+zb6AlzAf87Tn6Lktbg4lLoXgpbDB7oD9Q9wL/?=
 =?us-ascii?Q?x1YxqJXMFBSnnYIkl87IyOa9yiLptQBEvqG7MDQriNgROk0bfCFCHX7RFqng?=
 =?us-ascii?Q?NIQbzt8rsgcjSrBZfzBt0FSziA+3twWGGPdkwv57N5/J/Du/+zyKy7zdDl4O?=
 =?us-ascii?Q?avUu59RVoo9wR8AV+kUyvG3OBAkU6bDBoGXHm8MFjs0QE0pDetEtyXznaPjL?=
 =?us-ascii?Q?Wu6MYtzo1zmSkc3HdoYL2ziKiWuoFnMUa6u9c9RB56zfYCxU0pnQWWtycP3d?=
 =?us-ascii?Q?z+t2m+3XhHmGzUVpsf2avlY/OZmhpbQSZGzmN4tD12+EepCis18CTPaPYM5j?=
 =?us-ascii?Q?7iocbUNCthPn4tOJjZrRyTPMQTZPM2fKvUJJrW1aWK0vMOey1BRiK5GBi0CY?=
 =?us-ascii?Q?E33K4tkSARdltxsFp3lqumEQzmm9b/FZB3fLgjncDmdx3hduGVMPEl5Ko9kj?=
 =?us-ascii?Q?vU63YKkS4d10kOqbkLi6IDfBvPwsUbERdP946nhuiGVYMLgnYnB/i/SVR0nR?=
 =?us-ascii?Q?8rs6fEt59gzbNvH/uNvixOubPT4TSFr8xn79HMgobUuSFqvEzWwndh4kJ7eF?=
 =?us-ascii?Q?rTqUQ2bdFA3XatKa4KWhYvv0SIqNQUw2bj1Q+LEIIuaaKEndF5cKweJjSSlz?=
 =?us-ascii?Q?h5uBD2i9pl/Djf77Eoo9Welw3+EhQChfpdEzr9LPiY1nBs6KNkQoD3n7N4IM?=
 =?us-ascii?Q?q6WOr3DXvWAfUgDtVj6s+FrCj4uDdk1AmQ1Jc3HxpXbvK4UA0SxTHIgApg4l?=
 =?us-ascii?Q?aOif0UwZuunEojMvvYuN0JQMVRX4NNePjhIv4VvaB1bf7SOzjP8Q6JspPXbw?=
 =?us-ascii?Q?FQil4IBboRt+di24ORzkkEHvdI7+T9bOuGnZlEmoHVjx/3woW2dAEtu38f4F?=
 =?us-ascii?Q?BweV+bQfj8uqU5M26Q8347MWLyUFvrmXbRNpGjkVGT6/k9PiQJoppGdFimRp?=
 =?us-ascii?Q?Fs0evrOQ10xVyjiLhLYHAmBKKh+96ZyqJfOF1YBmh+DHuoRBx8ymA7JFovv7?=
 =?us-ascii?Q?nI32q4Oj9HgVwSRqnUV01qGatCiJFYbJ5FYOhCFTY+2pfGgrTe/NTqSK+I7v?=
 =?us-ascii?Q?Aboho1YHhYeTppD5a5toJ9NLgwPfSpHdcwhqPE0hc8lgHZbemVmemZeaRWhZ?=
 =?us-ascii?Q?1xWwASwc6JhfjK2jGPBjEOlOQ6aZ1gUnAFcLs6PTD+4LqckJpct95GS6Aag1?=
 =?us-ascii?Q?OuzVQEhCcpI8zTAIz1Asm6z46QRmfo5HhJnxVsGPZ2fNxNwLTN6VfYS85Tp+?=
 =?us-ascii?Q?Zqdp5aeKKxKXQd/qWh9zfOw1xwQlo7hp+n5FlnQ6ghYQ2NtVcynfw25zsBb0?=
 =?us-ascii?Q?x3tJd65zHSb3TwthccDvYNaicENDyKY1XwSG+NueF/iU82/mjBxy75DSvtPP?=
 =?us-ascii?Q?RtIc+ghewg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400c5bf3-1641-46a9-5abb-08de605f848e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 00:27:29.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tu98PW2Pz1WGUM5TQpkfgcfG71Kus7XybpePzGaDStLm74stgghdlJYT2HCc5/n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4150

On Thu, Jan 29, 2026 at 11:21:53AM +0000, Robin Murphy wrote:

> The driver does not advertise IOMMU_CAP_DEFERRED_FLUSH, as the existing
> pagetable code has never implemented the conditional TLB maintenance
> optimisation that makes it meaningful. Mind you, I don't see any reference
> to iommu_iotlb_gather_queued() in generic_pt either, so I have no idea how
> that's trying to do it :/

Well, correct me if I've got it wrong..

DMA-FQ always does flush all, so the goal is to eliminate redundant
flushes from within the page table logic itself.

DMA-FQ requires two functionalites from the page table:
1) use gather->freelist to avoid a HW UAF (iommupt always does this)
2) avoid internal calls to iommu_iotlb_sync()

When the gather reaches __iommu_dma_unmap() it discards any iova range
inside it, queues the freelist, and queues a flush all. So any flush
implied by the gather is removed by the core code.

iommu_iotlb_gather_queued() should be used in the page table to
supress any internal flushes.

iommupt doesn't have any calls because it doesn't have any internal
flushes. It calls iommu_iotlb_gather_add_range() which blindly updates
the iova and never flushes.

The one call to iommu_iotlb_sync() is only for the para-virtualization
optimization of narrowing invalidations. It would be nonsensical for a
driver to enable this optimization and offer IOMMU_CAP_DEFERRED_FLUSH.

But it is a good point that riscv pagetable may not have supported it
before, but it does now, so we should probably add
IOMMU_CAP_DEFERRED_FLUSH. I'll send a patch next cycle.

Jason
