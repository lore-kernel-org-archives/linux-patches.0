Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149742E9743;
	Fri, 22 Aug 2025 20:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755895535; cv=fail; b=NSbHSum3z1/yFVMpT7hGXGdSSkLoon5IOiMFtBQJR93aF7fxB6x4LTc+VfUxiMjZpQGmbXAX3DWVhCFw9aK58bOcqAqeyZ8m7fDHtdZjt8AFl5wo1r5bfaaOfbDslrC6YqM5f3PfTxgMq0n/GwaXw0yEECWCgZnmllMOFgboJhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755895535; c=relaxed/simple;
	bh=kfCfh2pgEXWBnBDBSMMt3bpq/ukTyyp1eSBSgC6IKrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SLAQcTBEDk3DUWyMwT2f9eeJ5EKruR+rQrYAZ/rebGP6S78spTpB5mpEBWLntimUJavcnTqRMSRsWSnFo4K5jXcoux5ZN4+NCiNtFOa337Q0n8TE9sJ6w1Ml5m3yP4VI22uG4y0rLaEH8RwizutvcyKQFo4TbhqL3EpOVG3Z808=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S6pOU6ws; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S6pOU6ws"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PPtFokaou3VJxO7UIgpvOnitDtVPUZx/6AQE0PCh2q5YpUOlyezYdjkainfiCxsgaQAMP+MiFF6cau0+CU7NvZFXNzt7s6lijF0NVprmbI9x+8ePMxUssTMy2npmfManDPMXvPG/rE8ncChcovjsTqiA09oqu/O8mBMju3eGcRiUixhuf+3D0OGvbyhM1i99h/KQ2xSjnHkfOPZsycN13xJx/CtwWE1A1lfNdGdj4AJIOMO11heoW2P9aboTEarpuNjF3qx10v4VUk9UPY9vsC0y+0TbHOjvFSoKiQtggeyX2FSsUSSN2o3LnWoJBlkquf9PcfFmUO16W2lRi4u4aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEYQzaQivqPdYJPWIxdCv2ge9iXBE0PxsiivJUX5uqU=;
 b=CywAVJzeNuhHsqoarNTHnxP6+fR7gs7c0Be0AwXqlo5pfjlx2do/rteYH+JXTGzjVjR1aWhiav3ZEodW7qVG9eNUY4RCiifHI7BbrzFD9AkNmQ3VBfof1AuVH1GUKYsT74/AnL5+A7oSH1Rz/stzRoDI6md/645oWRHAXfxLVGiO9AYhwpfR8YTdzmy+yN2h7Dixk997wy/BU2Myy3vu5CfzjrbWFWN8F3sdNje5BjmfXtSyR5rbzR7mIQXT79WK07lTqgnr1GgdHL7ArS2VSQvfXSWuDa59uM/1CXM1xmoL2FPNOn+3AFJWWX9Oauy/Eo/Hmr1Q+UvlPiBPw1lbIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEYQzaQivqPdYJPWIxdCv2ge9iXBE0PxsiivJUX5uqU=;
 b=S6pOU6wsb1AoFdDSLpou4BOeQpsCkyFetCwSkTHQLS3xToZVUUEA3N4NQL68pahgsrdO5qy0/EEpQR6O79Lk/Ea7+AloTnTo2Z/Kw1mjtKUiX8G+Z+0Si+U20i3Nc0QqxKD8IRiCc8J6SthegZGaAaCj5pUE001/bYHTvvbd0qQUMvUN/GgsQu1Wkp9GCNxfjSixKzMj0QFPedvPJ7dRdfjQqx1eTOM6Yor1ls7vGZDlIuqE11b7nptD39X2oHUmkq7Qxln03F07GZrl9JOQ+DgEdFG+XgbTkwwGDcVa75hI95MGFWd73YK3DP2P8ix4nOgBndyMPOolFFHZ97PfOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW5PR12MB5599.namprd12.prod.outlook.com (2603:10b6:303:194::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 20:45:30 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 20:45:30 +0000
Date: Fri, 22 Aug 2025 17:45:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH 3/9] iommupt: Use the incoherent start/stop functions for
 PT_FEAT_DMA_INCOHERENT
Message-ID: <20250822204527.GD1405994@nvidia.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <3-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <BN9PR11MB5276D23F19A7C8AE247A93F18C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D23F19A7C8AE247A93F18C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW5PR12MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: bf833802-8f3e-47fd-6d23-08dde1bcd512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oBHMuITY58a9sGT1O1jquAEWAy0swPqhEhezSrXnF9PiVc+gn9xsLn1NoX9O?=
 =?us-ascii?Q?0wnv8n/CsoummWxx/J3vSNicU8fJ5mgDxEnM2MhnQwRSP8VcAoxKavn/FwmX?=
 =?us-ascii?Q?97ZDjM/GxfXpmRIzhqw23NINjjN3SS3/USYtjnfq3zpVJw+lhkjPzvB1MbJ/?=
 =?us-ascii?Q?vjE714wyeOlJpL0up44VR6UZmCBG5lihlTHq+Z3dBBm6O5jXvFJlByUWIgii?=
 =?us-ascii?Q?D310Ti8OJdNZEoTAdSwTKFrcK6LvsaTkMY2zTnT+4syURUWsCyqpFSbNmW2D?=
 =?us-ascii?Q?MUi4KS2L6FocuEzMBt/m++CaVxMcxC5FGlwyhKvg9v9ihblVqBgs/UkUbcmx?=
 =?us-ascii?Q?Rir3T8ueZUrofmUeG5oRFga7Q0cNm6KaQCB0RImvT5UvD/NqtrQBwxZH6EdJ?=
 =?us-ascii?Q?wrMljlqXXnaTqvufkjELCje4zj3/TbzMDlmcdcvXM6SqlRUM07/uRgViOZ4A?=
 =?us-ascii?Q?ZvFtFSH/7tYCK4T+jFbLd1OJsaA/vzGUyzb6e+kzSYdl3IeqNZcJBzjxxeCP?=
 =?us-ascii?Q?XWlLrAOSSvvRct6WWA4jQL0mYG/a1XYoKdIH9SVODsB9KSTrpnIjPIWWTR1h?=
 =?us-ascii?Q?ORmRG62Fj8zzpmqOSt1W/n1wIGXklm+Rvfe7Jd5MCbIxQ1N2DTblfJAJvZ8G?=
 =?us-ascii?Q?Poz0y7dStB4gluPWarI3OXz/SvVpRpOlOD9ncjG7zO043umK//nlr8EkWnD9?=
 =?us-ascii?Q?4+cho3QM/qRcZAB5rcnc5MiRzxEdoVBZDE+1QbKHWugDI0ZKZsoDvexxN9A2?=
 =?us-ascii?Q?t9SbDIXEShpup6mag/p1q9HJNgTRiljorWRMg5VjWIoIQJvJwvl3wj3H7FX6?=
 =?us-ascii?Q?gPGicOhy0QRIyrgRCV2I4pt9eXXKIVjmrcG17Tbe5B1C9vlnTcFVk2eI48av?=
 =?us-ascii?Q?Rx5wOaPCzdGsZV0GqGAJexn34O5JOXAEN1g7lAkZtvrl3EgFD1Z3bV+WulWH?=
 =?us-ascii?Q?MlkxakCf1lnviEztReOZvNmcWpq/Ie6NKiKraEo1FR3/uRzw31TuCU0ooUOY?=
 =?us-ascii?Q?fgMHcYC+0c9En7ogw3Ug9KfmP6uUfnv6EkK/IsT22kVXH0mB1GOelbYfYMNN?=
 =?us-ascii?Q?q07h2/ciZc28mHbxg1yhU/OiEWS8fRuqd9Tv8JGnBs0ok0VgGfzsFs1JbU60?=
 =?us-ascii?Q?cepPz/Z0G5XZHjdmCi5KTvfd0k6oFsPERYqKs1H8QNhlI5KHJQLvElRMmFfl?=
 =?us-ascii?Q?8ofnMyX86p8t9itDPsLfuUNlc/ftb6jRkh5dAbv4YKZBhbsaWO54X4wRFaqM?=
 =?us-ascii?Q?+68zDrw4tY84w+DUq4LIk2HEihEsYze1+UnsZNRJ+gdt2x0DGbxqiHH3iiQy?=
 =?us-ascii?Q?URuoDwkPyk1U3RPFEcz6FVf9u1nKNy2q0/yNm/mZkfL9fqZoLFid40ppw87H?=
 =?us-ascii?Q?BrYUyf2+WawVzy1khZ2bj8wsdMQUq1ed/6A9JB8K2aLGOV6hrP0cD3Nkh+d2?=
 =?us-ascii?Q?E0s0y6ZkZIc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QdJOmgzjUyp4LnRCVP02+2XWYypmDPPlGbWJs3+u0+QEwFS9JS6YjiSUQQmM?=
 =?us-ascii?Q?+76uCEI4YQblxpYi355uDjeYnfWJ05gj4qcQXWrMZ4NE6e1TN0vE8iTlIlMY?=
 =?us-ascii?Q?IHfbGTPOBxJYMJpqosmJW8lSXEmQxFZYAUw6jEg3ngxNJn8uNpuFdagA1qph?=
 =?us-ascii?Q?MxCSTPqE6bOTVLzDP832KV/5q/tweDUYu60e6ykP8mtJWR8y2Z+QN8pNzzYK?=
 =?us-ascii?Q?oFmDHSiX5H1DI7nZ7KtNBirlsk40kJviTIwSc503Guw0xod51+GGU50uqITy?=
 =?us-ascii?Q?7+JoN9kEV2JY+BDMSeIUcmKJpYXmf8Kk300+Mj244H0KG3CL4IA0v5iNaXzB?=
 =?us-ascii?Q?NzCC849rpfEZJbRiHMYFnKVRH4DYYmaRh9EOD28QlHafP+bP2NJ3HghPh3Mt?=
 =?us-ascii?Q?nkLVFd+83Ds1RgT2cJ70WxEinZec8P9jNuJvifltv/HvRcqxhu2scH1Q44OO?=
 =?us-ascii?Q?orc/x3tIWeqVbfP2V7/FYE5LlQpTC0hA9yhOH3BndaEGchpENvQScwUEaG2U?=
 =?us-ascii?Q?5NNrE9J2iFd1t0U+pWf6Mkb6ZGCVKHBF38ucm3180VUuBLhxWv3DqZk+rq42?=
 =?us-ascii?Q?OXg2qa/HyT5g2V76Hhsqa1HYbXV750z5zLI/YxfwZRjAXT/Ntu9V8snjUdOC?=
 =?us-ascii?Q?GhG5jvip9q8oRdEqeqVRum2ej5nHFcemu2CL1rAB6bYORzCki1tJDOmNSePz?=
 =?us-ascii?Q?TO12uPYJ6vx0+JokNT6ZvMXym60mLBhAKV206O7ZBXIlafJneM4Q2B52IPcq?=
 =?us-ascii?Q?5e1LLODUqPQgKHpd8BbABd5gCswhWyvoEyScurvWO0fCrTo/D0Lz11Tkm6WQ?=
 =?us-ascii?Q?YFRIJJohuCQQ2Pbx0Tlq2shGPRTxDCU3q7pC7WjUNLvIbEctSYaEzY/dgsVl?=
 =?us-ascii?Q?Lhus3G+WhBJjmXq9lLHSUyIgNDyV6BdhOBI0TWwH0Iknnz3FybFzyH4lTYR3?=
 =?us-ascii?Q?Cy+D7la/3ZPJCw8VmHJMxF1vX4CatMOlp44aMWPypsI/tphe7u9iQovegDXh?=
 =?us-ascii?Q?NeypSBklP7Ql8ItqtW6jDyJacEU0XvbbcJTyrN3s9pPVk2EQwqFCl66thPrV?=
 =?us-ascii?Q?JGOhWSPv8lVxEIyZAUEtqeGi+xf13TqWokoYXyJFaOwEJcx8q0vhG0Zfpc4M?=
 =?us-ascii?Q?z7kVUqML7wQ1l4izV7OrP+Z9Gf4P7dzfgEDjfQs6g12igJ/0BmePVWKIBaHr?=
 =?us-ascii?Q?aJX6asSLqNWw2NOBsXa16eg+ykc5Ur4ERkMqqQ3QA6xhL1sdshLn4jSsBli8?=
 =?us-ascii?Q?7sb9ULjnmcLkD6FTNMKcxvKBYEXN6DqRkq7fUvHSDo4NXaJXmYIuoaYcULH2?=
 =?us-ascii?Q?Y/wwodBph3uerHaXM+iGEznS7+HCIiTvcpHSexbq+zk+8ITuVpPgv5DTy52q?=
 =?us-ascii?Q?0O66Dr1lXFLYjZG+p4Z75P3CQESri9tcq/RW+3Kh9Y1hEaKWQ7ardx2JPUp/?=
 =?us-ascii?Q?95ihWVjnm7RKGJK3g9Hp3ud0/ly26U6AOl76MqMZJnvsElNY+vdFLOZW2WQq?=
 =?us-ascii?Q?TT7UDseAuQxivT1ZU7BvY4KbzbKPy3mn3uojtAR2qE/IjmQw3CU3EX+OaJ7w?=
 =?us-ascii?Q?1vQeYtHoqCLof1r15LfeVkmrMTZnHxUfmvj2AD4O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf833802-8f3e-47fd-6d23-08dde1bcd512
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 20:45:30.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mRr6uSHpkxL7ePdctKT4iadaeRDUncZwvqUqmTC3j5BBLHkA/1meqGhYOV9olcK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5599

On Fri, Aug 15, 2025 at 11:35:46AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 17, 2025 3:58 AM
> > 
> > @@ -57,6 +57,12 @@ struct pt_iommu {
> >  	 * table walkers.
> >  	 */
> >  	int nid;
> > +
> > +	/**
> > +	 * @iommu_device - Device pointer used for any DMA cache flushing
> > when
> > +	 * PT_FEAT_DMA_INCOHERENT.
> > +	 */
> > +	struct device *iommu_device;
> >  };
> > 
> 
> It may be worth pointing out that a page table could be used
> by multiple IOMMUs but we expect all IOMMUs sharing the
> page table to have the same coherency attribute so here just
> record the pointer to the 1st connected iommu device.

	/**
	 * @iommu_device - Device pointer used for any DMA cache flushing when
	 * PT_FEAT_DMA_INCOHERENT. This is the iommu device that created the
	 * page table which must have dma ops that perform cache flushing.
	 */

?

Thanks,
Jason
