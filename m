Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBBC1AF4ED;
	Fri, 30 Aug 2024 17:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725038168; cv=fail; b=tBWpSclZStTjceaZWUsO9Y1yITfO+daYbRL3Cp4OcS3RbuCc5MkHvdqp/in/DUx/VUB/8/HtpighGefndK4LX9mR8cFdjTFxslxraxvpfOUguRm7tAO2SADyuKEU4QXGDXyyoHS7AtTh7fp6+iJFr1YZHyfUM4aVGNS0kV/mcU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725038168; c=relaxed/simple;
	bh=zIdos9Qoid//dnJDxUfnm8DrXIcbOt1v3IrofHM5k80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PIvAy8lbQSiH46sao010oVBSn8NQx44HTy3GHZWnK3jDA6HpYSVMskK/raoHyj6qmK4XIy2WqLQLUs0KONH8YbRuLSWkAJfY/t+KRLHBdB/bX3mQcDWdwXty1OxReBnembQdswWc5ycIHIgt2N91G0CXXNnAGEIL3HlQfxNDX3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gizWebzO; arc=fail smtp.client-ip=40.107.102.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gizWebzO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZNVlqv3QPkOyvNyYLwGfgxGFuWAI4T1a0FTMUebmEIy6hKbtHjygHLuohLkVXXnThdDYhm6iqgt9YUqHN/1dfzBWSQQMmFOYY2VnBfyBx5BOGEVYanIFUebN7YgpUtbdYwCTyPprKVi8pnUWSGM3dU6qmrX1Miy2KSJc9VAVj5ye4XPcwIhV3eSwIBlzvyBpsIQrIXc7LwMTep2xOMcKN6bLrOPI19/31D64xaiW6finNg944P3Wyf/5nykqueUWPBCr8EtitZcBuqNu4TJnIQTXEPpivmGLNbldUv34sSlfkdeezIghEo5NvVgguBI3+RF7OfasqJD2vK+EYgYnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mStQqLxyi1GaGdOljMNeyLli2umQ+/mTws+AqcWarBI=;
 b=MT4ds0suNGFjtdAfbei9jDISLhlMCwGmgtaItK0zIHjNnZbjtvB9KmHDYrHB95nZ47IlaUgZCEnkSNgb2SQQeMVwBQqXpvxwLvDlXC6mcPKE938dv8LEji0zi49rMEaUQNajOhUqTJcAJrf6z4Ysa1gy5NzEC8uG+L0VLNfuXYeIvO4wPDFrxTx7CvBA1TOzJF5hl+thC6Kq46SKfkz+7/QcxjQIH1Z/t7r6pqm7AiIb2PaCcdbsUKNoHWnsgwYit8Xw9MnLuvu7i/37YyvP3/Ec0UXbDjPVW2s7+WNQLYtte45tuYp7tYPt+OypsqcbSrrrcWJNhkRhmBOKxbT6/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mStQqLxyi1GaGdOljMNeyLli2umQ+/mTws+AqcWarBI=;
 b=gizWebzOpUBdYJZthkCTxa/qNtSz0PrvOoR/lEPORYVx8ohjVBj6N9+3NIrl3jtVB09mgwDMY/wxRaX7vvtExMPiGMnN/F/zA9T2Mc310Wu+hSVcOsUIIq8RJi+/ekmKFvaOBg72zCpyfzTrIDWvvnuxoz+QfLVVzCwz1EVUo1j7sXfPcs3k8657XBQ/l+/Fa3xRS6Ml+s1WtQW8PpchjXe0bRJxi1QS0oK0L/6ZlQD6ZDTE02eoEmOjn3Igu85rSEf4C3z/xoOFD3sScjBU8FOrM0y49hV+dnYJA21RI5G28P8qkobnSEqowvS5icIdCw2Q13vIvsb1chnq6NKnGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB7760.namprd12.prod.outlook.com (2603:10b6:208:418::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 17:16:03 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 17:16:03 +0000
Date: Fri, 30 Aug 2024 14:16:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <20240830171602.GX3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtHj_X6Gt91TlUZG@google.com>
X-ClientProxiedBy: MN0P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::7) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: 13765d00-4252-4955-0108-08dcc9176d19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pn38AvR9YnIx21YO+8iZclaHJ5qe8fXP4tBh6XbEXjKfVmMCYdyLMsLhFB2u?=
 =?us-ascii?Q?5YArbKJjfezeduKcpuqeU3DdVIH7i0uMhiLeJ7RgfqKhm7JefxqFH5QTxoFV?=
 =?us-ascii?Q?Wwi6/XDXLwgX0p8XQCh4TqUiJfRHNEqMZZDazVpLsIW49st/3yhGv0F5Vhn8?=
 =?us-ascii?Q?EQ6EaMPcVbIpTqkNeNgujl85r/C6ay/zKryd4MaXLUjiM/qPzgfz4HghK8q9?=
 =?us-ascii?Q?MvnXaS5Ah5o3LbknCqvNTwrVn9405Csm9yanhub65vyVY2KZwI3tdrKrPuY7?=
 =?us-ascii?Q?0w3ZRsbym4kP2xXx2kdGQ46OfKe1H3hthh/fwdtRZ3U98eNqxaMpOpKig0Jk?=
 =?us-ascii?Q?It0GUZpFLGv86AZ3jhWIRJXalI1lW0CKHdhwDz8Te8RYaUx4mN1aIqvxZlJa?=
 =?us-ascii?Q?oqq+n0NLdqqJ+BnWqfsFB+ETg6rkJiilxDytFWONCWFjg6C15uxoqR91cv/m?=
 =?us-ascii?Q?Cn90A+1Mxq5fq2x4aSUOX9CSks0QmodZo8eXaoktxmYTABWELFwQzj7sxvsq?=
 =?us-ascii?Q?BrFFpxMA9Qy9dwe8SuPxnLlg3tsViVrN9q9bEwK7qRMjipHE+7jC1HpAWh/3?=
 =?us-ascii?Q?CsAoqMPjaoLECjgbWLAPw99UX3ZCbhW2YsNYR9NhD/7Lwh0g+nXaxNMqkp6G?=
 =?us-ascii?Q?bSJ+lbAKRGGArZOcjAKU4rqngHcrYjdBaVFQ8mGWfllUJkjjj0dom0ToybRs?=
 =?us-ascii?Q?qGkXIgkTqmi4lR+RYZxtuUsy2XH9pNmzCTTCiyCJkXStkflHow1ImS0vtLk2?=
 =?us-ascii?Q?A3eSDexxaR4nhVpvPKlOLFz6zcFLBIM2+94A87tcC+KwOUFkRaOogW6WvN0r?=
 =?us-ascii?Q?qOZ0mB8ti35ZQa+YcuFAWm7X5LwZ6ui19wdotPKlUofPJpbO3IRcXCMyI5Q1?=
 =?us-ascii?Q?PS0MdU4lfXWOJLP0aSyuL91vWtr7t2t0vdySVXF4yT09lftL/Qh4xPtSNEvQ?=
 =?us-ascii?Q?VACSQrpR2pockLYDvrYTAz2/O/FP0gcWdgDz+8t+Afv7L9hDNVjBspc7WhCn?=
 =?us-ascii?Q?1iEaZbGg9Irn4Y+mMspbTmpGUlGfmlYEguV7hgFYaGx+0D8BPT+AhMK1WjPN?=
 =?us-ascii?Q?/aVs/kgwLC2CAWaWvNA58xZ0iybEI8IOyaiUlv+a257556zRKIHpEaVZolsW?=
 =?us-ascii?Q?FxLle1LoPRryM6T3k0fVfZ1d/YySkfIC4nnciynKjt0iVhvJzrprrFxH59F3?=
 =?us-ascii?Q?lO73gxKyjG+KkXSIhXt/4CwSN7cwOYh2ca1xloz8vE6cxdH4oVjD/Zy1SbM8?=
 =?us-ascii?Q?BjeG6S0l0wAVWusDwqn6XrYPJGehvR1Ql7IBsWWmF3xVex/H1kT9Jar0p4zH?=
 =?us-ascii?Q?eWFExwjrXV6HFN5kmv/dSRiAO7Snqhsz7orKj3t6ewe+zw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RVCxHbUaGfqnY/I1xQwIX11YAtzJWM1zot62zYYP3LB8ciMbJ7+veg23wvMn?=
 =?us-ascii?Q?56V34h2m5poYtd7aSy35VwOg/sXySPu9h30aB748etuumCfRkkJyI1UbwNj3?=
 =?us-ascii?Q?vRSHawrKYP4BpyMdDNFmcnIMQdfngThzeq6T5Typ21R7KVPZe8FUTU9rXEw9?=
 =?us-ascii?Q?m11h3MmOMAAaFOUIwcUm7g60FxlyVJn7NBjh9UoW7Q1nHmq/eoB4zSWwYdNj?=
 =?us-ascii?Q?kHsbBYVNEiOyhSLskvFMw7Sy4pXgULHYSAdQ/+9862XVvni7H/a357uScEQG?=
 =?us-ascii?Q?30G0szjyNp/Ee440Q9Cvoq952W4vHIABsOon/QG6sjm6z9auhdbwhF1xCLZx?=
 =?us-ascii?Q?vEE1Beeigx5h422HYV81tsf1X4wBkVyPj0VZw9E/yGK39/UOEw72B0nyUrAK?=
 =?us-ascii?Q?GreFjTWFp5bjWAb7Zbf+vBNHH1VwZkh6T46Oc2dW/6w7V58alJy4KBgXo8nY?=
 =?us-ascii?Q?Q6LVa/Lc/MsJMSS/OwyVTuHZ2OX5oGy8oLwEUsgFpKZYKevHIoSfNmZ+4vzG?=
 =?us-ascii?Q?z09M0IzW5sGgDEJbQWBOsg6Er0TgToQkkQetlKqOVvM0ntIKXOeL/fW5sDuP?=
 =?us-ascii?Q?Hf2wOAd4gs5CNwpyqmELQ/3Avfvf+1ljpxRRqa4TSoUf/YgXqzVy2QOLDZ2I?=
 =?us-ascii?Q?Bo1jQh6351jb1MHCiMi6qn3acWyaWkmrf2sQ6SOgzav1FYzNzjAI/IOhPN5H?=
 =?us-ascii?Q?31/ZQN+Zz0QCBBrv9t4Ygtq/HvnBE7j3XhMHwW0m3CUe6pT6ILb54rsxxsUj?=
 =?us-ascii?Q?c8VY1SCQO57FB2lXKPxa9KSZZ8GtRtDrTCJYYmS/IW7895LEELHG8ctRZrey?=
 =?us-ascii?Q?R84aIBkRachnBm3A7lm1YTq/7VwhUZ93jn/sMp2pfSCjpjne1fttLeaNutLB?=
 =?us-ascii?Q?3OUhFEryRH8NfwoVD1h4aeeWojs7s4f/nZK8bRO6q8xEjDW7VBTkFeGo9SJj?=
 =?us-ascii?Q?pQr5aJcJ+3ZgzfSV5sHTlQXq45EyxQNU2JTMz/4sqBGR0IMIp1b5H58xv8jH?=
 =?us-ascii?Q?3Xp9nYH0vw+1g75sX6gsIekb7tfAJlrQJ0C5U+NeTocC48IYF26nhlSu777L?=
 =?us-ascii?Q?Enz1mcECT+LetXkHtSdxJYg0Ax8t8T10ZDj2essTtkXhrKNpeikPQUqDAwB6?=
 =?us-ascii?Q?bbSWvDG38Kk2SSIBqDJw8aUSYz+x0dlygwudc2YIXx1UnDmDG2457auJpulT?=
 =?us-ascii?Q?GRjxbp5j/osghKkr+iLXYLYSHHqkvcxV/qfmGea1NkYY06veZPuNOlCd0uab?=
 =?us-ascii?Q?hyGfJiyvAFBPzNmmifAUT/5Zj/Q7c5cPi4/ulhNOaGUhQwhXQL9mpe5OWBqI?=
 =?us-ascii?Q?ACVfqjFSMlAXYZVSdSStvhsB7AjHNVzzeBDVkchR1+fiNaQBdDFKyPixoJWG?=
 =?us-ascii?Q?HKT8IaFB/JQa5fB/YD2mGsv7tK+YYC1PlJJWv2o2flFIZEi6r+TaHWJsMNVy?=
 =?us-ascii?Q?TdfU8zuJLQ4eNkdU/uPl3FCi/pTJx4KcynnTt7V4iQLkXdRHpzKoA7AGLcAR?=
 =?us-ascii?Q?7B+zSFT5Oryh3cwx0QO+NvSuC4qw11lPHlczlikAbwL90XR5FZYH6ZX7DU3U?=
 =?us-ascii?Q?+RJQKqjJWrfw27GUZmtX9+OggfrqO4VvQlf7qsgu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13765d00-4252-4955-0108-08dcc9176d19
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 17:16:03.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EPOIRcE2eC8Lg4kiOJtsbRB2FL/wOoLumliOMwBKtQpYdtVKpHxed+p0AYai32P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7760

On Fri, Aug 30, 2024 at 03:23:41PM +0000, Mostafa Saleh wrote:
> > +/**
> > + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> > + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> > + *
> > + * @flags: Must be set to 0
> > + * @__reserved: Must be 0
> > + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> > + * @iidr: Information about the implementation and implementer of ARM SMMU,
> > + *        and architecture version supported
> > + * @aidr: ARM SMMU architecture version
> > + *
> > + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> > + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> > + *
> > + * User space should read the underlying ARM SMMUv3 hardware information for
> > + * the list of supported features.
> > + *
> > + * Note that these values reflect the raw HW capability, without any insight if
> > + * any required kernel driver support is present. Bits may be set indicating the
> > + * HW has functionality that is lacking kernel software support, such as BTM. If
> > + * a VMM is using this information to construct emulated copies of these
> > + * registers it should only forward bits that it knows it can support.
> > + *
> > + * In future, presence of required kernel support will be indicated in flags.
> > + */
> > +struct iommu_hw_info_arm_smmuv3 {
> > +	__u32 flags;
> > +	__u32 __reserved;
> > +	__u32 idr[6];
> > +	__u32 iidr;
> > +	__u32 aidr;
> > +};
> There is a ton of information here, I think we might need to santitze the
> values for what user space needs to know (that's why I was asking about qemu)
> also SMMU_IDR4 is implementation define, not sure if we can unconditionally
> expose it to userspace.

What is the harm? Does exposing IDR data to userspace in any way
compromise the security or integrity of the system?

I think no - how could it?

As the comments says, the VMM should not just blindly forward this to
a guest!

The VMM needs to make its own IDR to reflect its own vSMMU
capabilities. It can refer to the kernel IDR if it needs to.

So, if the kernel is going to limit it, what criteria would you
propose the kernel use?

Jason
