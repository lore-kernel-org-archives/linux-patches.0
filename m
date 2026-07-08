Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010050.outbound.protection.outlook.com [52.101.193.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01691478E51;
	Wed,  8 Jul 2026 18:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536198; cv=fail; b=Xt0oOPMSIwKpWYme1I46P5H+qfiCRxKwzoOFZA2vFf0RgL2B+fBMp4Yj2t01AaMYtoJ4sMGDf2vcCLCCVVSvVZMy1ozi9jPBZwKsB89dOCkSlXYo5kgRUVs+baDou7ecSnkGBSirW1IsQpDfoYWI2QMy1N/g5VyH3ba1rBznizM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536198; c=relaxed/simple;
	bh=e4Eyy9g2VJiosukeWv6qH+1LYNY2MzJunXsApFUcp2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gpx3DLxziR0gYrq1SMiiSiZYR1wAw9VjEU13eEQrrBP3R2xsWM5qmfPs0Fjmzppd6xfuZcwsM9x/p4GW+sUZyBpDeRuHYsvwJvUUQ0fSIwx4ssO0jITrhi9dEYYJzz8K/dbj0EUD3taa/8woLS/yLjU0Ajg3cmfhtNcvl/62lq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cpQXgj+y; arc=fail smtp.client-ip=52.101.193.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cpQXgj+y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fO7XLr+0unb+UYuAI/vebVeoOqSgJdQf0TBmH7a3FaqmpM5Mtd3AGl8AUeTjIwIv/oWuXarfCQJzs4OVdw8NzhJl/H/7huz+IDWnxEunJd7mcJou+K9yFbgOnJ/6HrQizNXPjzB+yQaqlbWdwPgb5jK372sQo1pDEDvkm27AHKvilqXZpFo6KveU3/HzC1iKevV0O9507f7lrUq4AQe3u6ZGKqp7iYYifhvx8rPh/g4REn5jVFVM9Ha6S/8GnfGMmqF85eAfJwzMMRd0JVxrdM/OG0s0AcDv/vu5K5bPd6OtVmJE52seotvAT3TLbhRJ9/IoJHnJBAnzdRzNZvQwHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQPnPRQNSAEHDPy8B1SgYPoL/wE4cEv8SIlpH4fl9IU=;
 b=ZE2808PPpaT3XO84bjkFum4edc9lYBjh4qZu93K/ndpfBJAor55WzC6Iuv2FJa3BKBiIbM1Qqd1BBxJdwD8jRPo1O3DQF5/3G0F1RTCgRkkB3hDRgrszx7oPR1rVcmEBkiTTjRDxZXnWDHlZz3sIdfPULlLTNXzmK4I6t2jDl7l0h1KknLRGkgMR0HND/B4731Q7QclLq3bnrkfgA7FcI+/65IeQ5hzYpjGNrBCTH+4PSdX93TQ2eRHvfVpQucDJI5VGT6vXMdmr9l6DS7lJqWok4lYTH95yH7gpMDo5WIVKU7Am3q8tu4bWsJKvZnSp55SVtEBmZaIj7EyJ8roX4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQPnPRQNSAEHDPy8B1SgYPoL/wE4cEv8SIlpH4fl9IU=;
 b=cpQXgj+yPdsmybukfKe/pA50jLCUNdLvUI6iRTOv9KKXPlDSPhhJKdfVKBSWb9CFd4ufCYfRpPC2Nc0UhIwbSID1i7GEGqQTvpYJ4tF04VVoR+DiVSzAK+DU0wJVRdUpFedsC+QfW+v5LBw+W3zZLl5Q8nclMZszAR95+MfILjiXIw2Ip96jS09kmI6Um00TiVIu4r4InFPdz5u9VXTm2QvkrXfo6LNftxhAOmim1h0XO94PdeFVDR6X1cMqP1ebd9yoOyNR0OA3xtTdDgzKvhsE/YicZAvwLfcHrixXdrO6K0BmgjIfXWfEf5p+PWzlcxspSuf3N9L4BT0xOCIgBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB7921.namprd12.prod.outlook.com (2603:10b6:806:320::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 18:43:04 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 18:43:02 +0000
Date: Wed, 8 Jul 2026 15:43:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <20260708184301.GE422027@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akx5IvI6bi/OPuPe@nvidia.com>
 <20260707161506.GA226829@nvidia.com>
 <ak01pH1Dkq7nzlIN@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak01pH1Dkq7nzlIN@Asurada-Nvidia>
X-ClientProxiedBy: BL1P221CA0039.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB7921:EE_
X-MS-Office365-Filtering-Correlation-Id: 47eb226a-ddd1-4a8b-d2c7-08dedd20bd79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|22082099003|18002099003|6133799003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	bZi1OmNHmM3VpWoa9oaBMF1SteHYeGWHwuRKhFr7KYSFG+dA51kvn8YELClV+2RPIcQk7aObpIsIKwIJoLV6TudF0ygkFY5RvMBtmd3Hhw+usuP+KtzUJ4r239E8AfX2V5u9B+koP7CRnfXFKc2l3NsBis5bMnR+cQr2gwitsdf0R1c4dlxjHNgHLlU66/OBty1iSFFPTUWXdRNteox6xIQgN/ByfZdw46YObsZi80+mKr8wG3n+svGj+7QS/mO1QYRF38az3Fv1KlXfTLKwIWRRfEOszVJUM+53CQGS2ZKy/ckj4ewgr5mC5AIE5oFPcq6JgoVRyUUFyLDH72JNUnwrACtKjnYYaaGtrl7rzlE5aKhY6Y7nrvYPxwZK4cXFOY811y9NmaUBE8TT+27UoiLuJC7bXq3vKeQMpegyIL8Z0VOEp2PdJQ2V6jD+vVdfhCAG5wcrtgD4fJbHWCsu781C0MnW/gh+HpwEE6QQfKQqgGYaIrUnNIkpMcr5eAWmgpXreEi4J8gIliV9h6W7ktzdhfn6RAzwNo+qqsKrhKKDwP2CrTJmpx4SOd/4kqeSxi08mGzUo25w+tP7b1eofBHty9TlUYNamD37q8JPNk5op6q5BQxPO+YlAsNGy5vnH7DzreYJFQoiyR9mrSzsxFvOtZzreLB2tMCNY2AMIsc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(6133799003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gZbDSlplVRzLzmRnzBzIkZOdzb19GwcziyqTxAjjcGeMcoiZkLpzOkBd1RVi?=
 =?us-ascii?Q?mzIX5pA+n6/TALgYt7c6dSUVUye2nG5sqm3hyLkSMsfOZBqM+Byaa2UHXcTL?=
 =?us-ascii?Q?h5k6Vy+u+GwKQAp7VzSFnLHxHV1VmubMm8x16M4DD2vARlwgbuYs44uT/g1e?=
 =?us-ascii?Q?UKMZVvMqD2ol61YFiSLLycRxP6bGoMh9wklYmB5HuxqNkDG8xTUKnoPEJq6g?=
 =?us-ascii?Q?kBLTgvi/c/z3dUQj3C9cuRWPWu/rFR0YailH+88YgiuEQP92ow8cJzqIGX7f?=
 =?us-ascii?Q?6qislVIzhTgb5k8itM3jFoOiMtrUuKwJGHAtpdLK1YleRLJvlwNTve6cvJpu?=
 =?us-ascii?Q?MTXI8hucfqTWCFkZjxr8FGrIGEI3Dzde6oG1ENz9y5Cs+K5rXv0TwHuoJTyt?=
 =?us-ascii?Q?ld/1j5KUSIuNjp2ywMJVOYhX4rmC1dueAWAIOacZ2kHw/bLYB62v5pnPmQVD?=
 =?us-ascii?Q?EjLLuUoyNoNExsVrcqnKGdhQ3JpCA6dTJ5IRCBREoPfBKBydbhSn5+1YYGgp?=
 =?us-ascii?Q?QonIrzVZWurHEuJ+gYZXlGk/kCKF+qOFJcneoGWtc/i1XoRlDOeVjMllqSGb?=
 =?us-ascii?Q?euItO7OH/q7iHKFHN42KiTHEqck90rt3aXE3fPEKQidG7r5U677OvaPejZCD?=
 =?us-ascii?Q?8O3f7MCOPC76zxcHhGTj/jLf6eV9WH2PXONbt4/53n+OGsLQ+nUD9CW3VCft?=
 =?us-ascii?Q?VvaNT+x/Hm0A5p9tShzl1SMxc24L4TyTwP4LL7rTRKapiQdennZWylpfOMQe?=
 =?us-ascii?Q?YzFg+d5mgRqYzLIb3yMClwVeBXa6H1HFVNJ8cDHhHihkxjbIbZsZHZ3Ziaif?=
 =?us-ascii?Q?aL4K2LkJSR5HZOiP7Txw9LsA7vedy7PM7faPs9xO9hKqo2lcZRcKoNCcR1U3?=
 =?us-ascii?Q?rzgV7dDFiTBiQyH27fG9mpcO/OSEnGY/nq3iKCUST5ebiBLWTTh/CLtfRqED?=
 =?us-ascii?Q?Aq6jn8ITGOylpGd/Y7+GiEBREF38hPqWJbUwekeMKYwoYkbTdUtn3nLwX8Gh?=
 =?us-ascii?Q?+ZQd2wNoH3aEL2DLaWOZ8mXVF8CYHPApc7D0HeS1pHww75fIaH+AI2ffopud?=
 =?us-ascii?Q?poGGty9iSgmCPLv3maut3uhnUbABdkp0L4fds6KilhYQ7IkUIMwLQMWve5aU?=
 =?us-ascii?Q?gCRe2pc0QfDbtczN3tbbg7VgmFqIuS4Ixet6WuU8jGxthsMkYNCVHKDCDkQr?=
 =?us-ascii?Q?O2Ww71s1N/RvR/CGmnHlm3z6rWhDXc1ACyRQGCaVdtOKfhBFYB09vhPCyT+l?=
 =?us-ascii?Q?nnpJqPPsTacq24MGtDnIj/e9f+HV+OU2j50K90nYCFeSRUKk6mIss1glhpAG?=
 =?us-ascii?Q?ObOAQ4u7FCHBrgH9zBhUgXbTkddm5Q6cpLbj79FADGN5LyAP2Vm2cRDgVC+w?=
 =?us-ascii?Q?vPoU8lQ18BVFsTYLd7kqg3Ci8TnxD/sd0FSx+fX4OwiYXxyIov2Ovse/O9mJ?=
 =?us-ascii?Q?DitcaYSTO5xtKcRn6x35oxtBi1PB5+ra4DRT8yHc3Fv54r+DNt8isUdsrfg7?=
 =?us-ascii?Q?Y2REBXkcvEbOBXuXYFMJ6QCgJsoq3uIF5ZDx4drUHBsr3JKouPcstKzT75q0?=
 =?us-ascii?Q?1CqkxcbAomf/IMMwl8sgVZNPkyCqmK0MvdB8KEJwdDyoIFYDMpgnxgJ4qjG6?=
 =?us-ascii?Q?XQP/ONEkURguYCiUeci2jC7uylHo+un5EyF3irNQVP6iEwUXzAiltDvOQ5PH?=
 =?us-ascii?Q?J3p2LlbtNNQRNMztyOKFhC3P1e9A4TI6Dxb/omkE/RUBL8gE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47eb226a-ddd1-4a8b-d2c7-08dedd20bd79
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 18:43:02.2308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ksy3ICdtoQdpLWLJlSFPWtboCviX74rf8H2iimeydvgkgyZ+auJloPqq32VDEO8l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7921

On Tue, Jul 07, 2026 at 10:21:40AM -0700, Nicolin Chen wrote:
> On Tue, Jul 07, 2026 at 01:15:06PM -0300, Jason Gunthorpe wrote:
> > On Mon, Jul 06, 2026 at 08:57:22PM -0700, Nicolin Chen wrote:
> > > > @@ -734,7 +734,6 @@ struct arm_smmu_inv {
> > > >  	u8 nsize_opcode;
> > > >  	u32 id; /* ASID or VMID or SID */
> > > >  	union {
> > > > -		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
> > > >  		u32 ssid; /* INV_TYPE_ATS */
> > > >  	};
> > > 
> > > So, union has only "ssid" now. Should we unwrap it?
> > 
> > I thought we might need it with some of the other series?
> 
> I was wondering about that too, but couldn't find in those series
> of mine (smmuv3_kdump, smmuv3_atc_timeout, smmuv3_share_domain).

Ok:

-       union {
-               u32 ssid; /* INV_TYPE_ATS */
-       };
+
+       /* Only used by INV_TYPE_ATS */
+       u32 ssid;

Jason
