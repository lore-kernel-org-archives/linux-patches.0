Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2072.outbound.protection.outlook.com [40.107.102.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B2C14A0BE;
	Thu, 22 Feb 2024 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708615055; cv=fail; b=ZP2SQT/LjLhQmaB+93PBSzZcNFH57wv61qDv/PjG6tTAT2EeAKFfriRhV0I7BvVTiozIW9MZHalQT1De4zdMJP+fPKY7Ux22yLczch79X6vlL79tlz3vO6N+S200J48URa0n4ba2B/IIJUwh4+JgQU15IRFeU7XyuVput6pkXIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708615055; c=relaxed/simple;
	bh=8J3aj1xZMEvTsPdpM3uejNO9Yw8wikxEKoyynY6tmUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hO52tcQb8c8kwhzsYExcRVnsz2fZM0+d8kTPpBtV3Ks10e+iUFe08HD805w2NekkmW9GNwLt17bhJ3pIqVXqUeG7LgnXmaw/W6zG8NiDpLLGACzqk9tOMJkaDzvcIEhc2VjyZZ1cj0bAyQwirGx6tABmLFiWiVohwFQG4HP2JFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ctA1WHMb; arc=fail smtp.client-ip=40.107.102.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ctA1WHMb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgEJsjR/zKNThVYCDXntu8Mlq1BezlPtKp9kkPc4CXcw2EqmlgjSpnEKNrfi2TBGi/FmhMtUwTQLdWBNCVSv8miDSsKcswam241d0zBIYM8nH9dxUu7bFO4UeHHYfInLpuZ9GyZCyk3m8c/3KpHAHMx9Tx/JuazO+8SQ/yU7lmN3zxK7BhAPvbEtEL1CtNGMuRNVKdBvPqYm6LpI9Vm+VRNoO83Khp2/vTMLXy43kukYSKNyuBDBlPo+vvOGTuELAeT72/RcREZt2YXOzrZQqOmzuIQtjCmTP+4PMUl1W6OANCl/stgu6PP9XWuCTBdnkkRS3+mteMkTH7j3l/37kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfeudMeoQQcrcCKwx1qEQHhhHTPDv7dI9I1S5jFBcS0=;
 b=XMpQOeZjftGbdMGDbkAQhQPIwY33aZEtHQUWJWSJZIZKVeUDA8Ov4oGx0I3uPdkQvKD9LZqV/qJFQolqRqCNsfNAIDvscsWjohQgIhP912AHv68M/S9EDlPpf6tAhcIPq15QiwtNwWuacAZXz4MLg9brTohVjjZSWlRkhaqeTL6bJXuMAncAw5O4Neu0acBvxldUA7Trpwpec94JMPTmNOoZxmA0mqhraKB9LbElJ8gCMzJoNxVa0H4yibB9AYFIl5h6TkULiuiPDzz5UIr9atFd3UVb8NC1aozfLaA/+FV/Y3VynF+FjPm6TBoqC5OSsSS0Hpr1brjPybwXdtnxOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfeudMeoQQcrcCKwx1qEQHhhHTPDv7dI9I1S5jFBcS0=;
 b=ctA1WHMbwPGyNEhZ1Hzbf5FtTFdwHvBuN1YnmryMA9l5/xRT8rC1nZAXccVnRUHZvpfbOppbwfoKwX/WJ67T5Yxe1UPDyvcv5EtPQp38A/0v6GyWpLwrfIkrPq79mO4kLaML6PFdXp+QXUbVdXHKreOPSS+RFeDUh7U35kHc7YrhkUJCXy95D+Yg18y5S6wHWxan5PM8TXnzRCuPwGK7Gq/8YnmeBEOtItGTLFdJhECpRbcteKIExphRN8FMLws9/0r7y7E63jrYobhNG15aRhYcGioKpRfmumAgFkhpw3d2JD4LR4xSjXOEEaEyEy6QMNLt61A5TsMJ13m7qYhjug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Thu, 22 Feb
 2024 15:17:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Thu, 22 Feb 2024
 15:17:30 +0000
Date: Thu, 22 Feb 2024 11:17:29 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240222151729.GB13330@nvidia.com>
References: <0-v3-11978fc67151+112-smmu_cd_atomic_jgg@nvidia.com>
 <CABQgh9F3dWpE+2g14qq=fhdRNWgs4huBOgiDTQXQXuG=UzNv-g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9F3dWpE+2g14qq=fhdRNWgs4huBOgiDTQXQXuG=UzNv-g@mail.gmail.com>
X-ClientProxiedBy: MN2PR22CA0020.namprd22.prod.outlook.com
 (2603:10b6:208:238::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5380:EE_
X-MS-Office365-Filtering-Correlation-Id: 0592ab8c-36cb-4481-e07d-08dc33b96341
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bKtzJs7cHZwT3f/bKT4nmU6C1iwf+h3Bg74gfWFOWLRmtWLbcFN0RqydeYZAb2YuJfo/Qj9v3/oydJ3W4VlPBcW3fVgyzKZF5hmWJ/zSKkISavP8DehFIfQjCp00I52By3/SMgEBWvumjosgHZ13jaKzUnR3llK4mmR1LIymq8N+vFo/fZkJsJHuSrxhz69Qw8K9HP++VtPTBt+ih9QzHCUFshvFVyjXCicswekMm98G9TbchGzMJM6/lnHwxJ/Yb9zUK7Wqfe1rFcSXjNFWCWi+PyR5wB/Cu/t25ardfsU69qJzGqFjQIYzy589cbdCGCyIxO6WZZ2t27NZwWS8gGMBCTr4uDOUcIgB99obYPiKOFyS2BxhgldRwTZfzYi+Ik34MFfvR8YJOozc4LA9Qi7Rl/B1748r666z6I45pXj0oN5DMAklM1YOUgWSywIdz+9jlnRKRKiV0UkKj87174iriQjDyWs47Ub2iFp8FaexxD3lgr2Zg+z2H+VXj/OOIvQEMQ5j8vAEgLuk+DpXN595l2P+02srrvL50CMkEb/AgjzZfPG2uHTZUHw4aGC+Mkq62ScN6i0Sea5Sff9kzQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kM6livAkueNuOT+vKdPdnaHIO2RUU4UorA4UnI6Pg9zKGkjol7+w+NeOcYaY?=
 =?us-ascii?Q?PgFtAcy4lYe9YkU2AvB6hvpT3rPoM3PQnRCyis42O+GfA+i/FexP55amNuFJ?=
 =?us-ascii?Q?kElAs2rfsXxmjmFPbl38HxEEr4ADtz/yuh35eb18XXPdQ1TTkfJgKg28wWIl?=
 =?us-ascii?Q?cTI/552NJPgRfYAvi9RH+aqL87Oaxz9QrmQZV486w37arvFc085rxLOn2soq?=
 =?us-ascii?Q?lLkCvw9m5LTp/MVbC37OVIvGbkalbFe7WufC9+xlXS/W7OQQWFoapgOS3uiN?=
 =?us-ascii?Q?wdSa15Z5FStYBuOm7Ntz8BFgWaRcfWOsBbeqFbX2eMc6U+35EqpjcWXmmnIC?=
 =?us-ascii?Q?lRjZ1ERnQesBXv7kNwQRYgRWjRT9B4Ati4oEWdgzI3CqOj5oYN+Ka4jFZ4wl?=
 =?us-ascii?Q?TjNA7WEuE1nOfZnR3z4W9Z+4sb+EVwsqALajFK6cPi8AphzkIpx8jL+kGvPN?=
 =?us-ascii?Q?LdQID5YJ4hUfj506Fou7Moh9T8bF5IZDV9N5MDpwGCvlZSaMYF36a9BR8Od8?=
 =?us-ascii?Q?MqSBmNG49bojqsQQDi7dOmNxvOiquSf9riWzp5hW8l+hXJSO07Bqp2Jd7Wju?=
 =?us-ascii?Q?HYzYUX6Y9FetVKUytIx9pkMOpf5HwZ4+1fluLxJcy/5wZwxg8kIJlr8XHe4i?=
 =?us-ascii?Q?T9ILwZdZrd4h9dJgL4fSXdpJucgjCkayJ8M/KKG+oq8lQL9QnNzDvIUyhP6W?=
 =?us-ascii?Q?ZDVimgfCiMp7VJGQ4Z9mAzxiCSa3YA4qRDXYSNSPVCgGdNF68OSZPGyZwFe5?=
 =?us-ascii?Q?N4v1uP8wVAEasEcM+wv/++k/dRdSfHpZT3YkKOxRht2MUHlEFwTrQl2BgmyK?=
 =?us-ascii?Q?T7RYnwPqRaownU1mSCg1FiluRfB3FFzr0dVjQ9mfLc93MpKJdBNIKPvTqX8k?=
 =?us-ascii?Q?xsyLb2d2THXRE+d6w738PFGJLs8FtmLccfpe1Nie9imtu5bXJ1d2dcxm5Kdd?=
 =?us-ascii?Q?WcKiXuUNJ8unmvqq5QRGllAecgG3ROZIcOzDkjlmKDhhjHoly+NgOdX/zDvc?=
 =?us-ascii?Q?NuvL1+I/ZZMsdKgl9nmcDh4z95adhlDYlKW0Heke/5T8eKyJkVmztTvArqU6?=
 =?us-ascii?Q?kcF6WkZASXroOZB9J1y/Ae5Nslq7QTrwbAcUD01hulCPe8epsS06DT8EOfsA?=
 =?us-ascii?Q?uZw2dk2nhDjt/L0sD6QcXkopBhZojKoRfLf2W9itYfO8i19J2LeUixyFmJUl?=
 =?us-ascii?Q?DuvlKGguBhMlVPqW+kOJc/DHmRivBbYjX2kV47MPvXnKMHJLDcyvRY+cTpSN?=
 =?us-ascii?Q?edHwP7IZ9MsUworfWuXCI6udsLiGYOu1usRPtYd1UsZ2Ft7+cAVsK/S4Q8lY?=
 =?us-ascii?Q?m5KcXTDZQP37WWhjRkTecIsVZ6DXT2Svl+Q+x6nPag7/XnE6Y80TMtuN0QNt?=
 =?us-ascii?Q?7lduUX+4ARkxbnjxfRkZbP0ifxf/sTkys0hXHMwgDiS/auLQ3LeWnwGz9eUH?=
 =?us-ascii?Q?0nIDBbvMytdHxVm2SDesq2d86XEXpWWe4/xxb9wDC3ce75pwFBTIoE6KDAMg?=
 =?us-ascii?Q?t8WPOJ+6N7/R2KHnQ3S+8LhrXHvyq8/OTVsSj5+tSClIwmPvaUUykYEtoNIa?=
 =?us-ascii?Q?YeJMTTblL8bTJqsew3Aabnt0/QiCVVeJYfAsZcVl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0592ab8c-36cb-4481-e07d-08dc33b96341
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2024 15:17:30.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04eefa+oMsWcefcdjxIQhwiaXJUiQC7iFSk9/rF1ocD9VIewUV+LpuyKG7AYmyQM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380

On Thu, Feb 22, 2024 at 10:38:39PM +0800, Zhangfei Gao wrote:

> > I suggest taking these two patches as well which will further help this code:
> >
> > https://lore.kernel.org/linux-iommu/12-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com/
> > https://lore.kernel.org/linux-iommu/2-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com/
> >
> > Michael should check it, and Nicolin or Shameer should do a quick sanity check
> > on their SVA HW.
> 
> Just tested on SVA HW, and NO issue.

Great, thanks for checking!

Jason
