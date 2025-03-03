Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EDB21CFFF;
	Mon,  3 Mar 2025 17:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021334; cv=fail; b=qbzP8blY8WgNNp50YIGhw1Cye7guvoZti2lIPowTtxu9/Nqa86bV11UqJ6DnwQ3xoaksqNo3phsQ1TaeDUiL775h8eQraNQfYeM0o8FMcrDTtsoYqbXn44N1ijvBr0CbVkbUdveX/W5vpKAhAekd9PNeam1bbcS97YXIkAyhxLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021334; c=relaxed/simple;
	bh=94wSBvwz2RtQL7V9OzNqmm+QFdLB4oYUxnvmpQfuIG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CKCE7e/ynUQQg4rs0BgZu5jmo2TSEfdebEmO0kyl9li/NHZE7AiW6jDvewpXmJNeYaFmI2C0sGoTmHSUC203MqVmrm/2krfelwazuc0cp3ysTHmuN9GsHNvfVubSUNurNhS2NTjdoZ7DsOTeya8Tw1dVKku01O+1pfswM34cmb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KAlao/qI; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KAlao/qI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zx2ShuEl0tOrH1YBVV0OqoVEexrozA2m1xoRHU4iEbp4yjupDHfXxCMWFcxsVutRUIxroW0278x5+iZ9N1DPOoVTMBYBCSAyLbvvyxSDwFBoxQ4xeyFasqYnh91VlZNtnaUBym/hLL7BQgvj43tB//rEgtv6yPlC1Wfu+HJGrDAdlO68cJjqNimQK4uAhjks6hp33u+h50Z+u9pD/3F8ZDIC94dS1rjD+BqkhRSvbavZ/UJoy/JTPWLxym/5ypTNVQ+s+o4qfGgQRjzu0zP92G2YEeqhuS86QE+ESJP0ofzFnC6qFl7ncXPVKEocxg3CovEBQQFWTtavMKxWSk9jSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07B2E61Z0kNe5nZ8bxWtRKpTBGgwHIHCwTKgn87WVNU=;
 b=Y4JasNG7aCGQl0PipHZ1HUCmo6WExcgl7+Kx7a+JuEkfLWASdBdxuT35JZJ8ayBitGywGqk/M2ptIB21UsRy1/3WHzRKoU9FmHEjGVMPXjW816JsqACCsxOpHwJIyPXhp2AIH9xrS1PPZGfyumuUWGzwOICbPqfh5xXiIb0D1b6nQRR4t7HXfPrcyNuGAFc8dyOlOWYj82kcYRG6Vg7n/nN08UesS0jRJsZiFDv6S0X3sJZWbMOBVe0PUuoo9Ee2RVlE+nNWxNS12OOzxBUcDZBVh+5Tgd9U4T8DmmoRUxQrLTVIZMA0KbvR0OOfhT7Qg+fNEXigfD7JwGmfCXorPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07B2E61Z0kNe5nZ8bxWtRKpTBGgwHIHCwTKgn87WVNU=;
 b=KAlao/qILOraAuj5LTMBxZKAc81jaQRHXCP6LXp1LIvOJCjQv3CzKaJtKAvzJpxrnBZcJYLRLzlHr6s5IcaJ31U2yhJiMcAgjzwmCRpUZRB0jdtWV7+Ugw4/eMObJkZI9LCmpuqsGzbeZtRsPQ/GY50I/Kq4Exfcvoz6GwbN3Iv3R3wTAigfqa3rsUNDol9bIWk7wICx6F21x3P3Kwq55UdWo3qHwlXaBbeV6xvu/OYSjlLbU8N/OuMUG1+6p6q0rAPx+a7LHf59CCeK4c3qZokV+PHCyT65eSD9rLU7oGcC9cC0l8ymcqh0PPmq+xsUc7VfArKa85ik3uh+HAfc6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB5956.namprd12.prod.outlook.com (2603:10b6:208:37f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Mon, 3 Mar
 2025 17:02:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 17:02:09 +0000
Date: Mon, 3 Mar 2025 13:02:08 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250303170208.GA133783@nvidia.com>
References: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
 <3-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
 <20250303152143.GA2083810@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303152143.GA2083810@myrica>
X-ClientProxiedBy: BN9PR03CA0602.namprd03.prod.outlook.com
 (2603:10b6:408:106::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: fa66a6d3-3956-44c4-3fb7-08dd5a752255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q0lLwH/EqbdxASY6O5Bw1qLmKd7bVYxx7tAkSDfZ2qpvnT341TEoELjZuX6I?=
 =?us-ascii?Q?uLVAX0PXxVS0nRFXiGmGfs0ToVdqtIxcMKCS7mAaSjyt1MB4jPzMSDiJoVTR?=
 =?us-ascii?Q?gjeTg19AHZZKv9TXY9S+tZjiL/i0s2eQsD2xeC8Q4ZZu5Lb/V+NjuUy5uLb7?=
 =?us-ascii?Q?mJkZb5A2Cm8Fn61qaP6D9gPdH9zNv7S5JLBCyxz4M0kGgw2uP/2Y4zUgt0As?=
 =?us-ascii?Q?8sLAKprNVD0WvH198zniHTii3Yg0Or8sgPJAtQO1R78mIlyif6//627HIlKo?=
 =?us-ascii?Q?jdWTgfCyYgHurzSws0JYbCBUkkcPVOL4I9MZDNCGwOlDhRETF6hutw951gtt?=
 =?us-ascii?Q?AMhG4/Ns5Nf4Bf5SLDP7BFvh5w2LTY4Yhum6Kgjcgv3070VJtRxXmOG4M6w8?=
 =?us-ascii?Q?m1gEIlry1WHs1tvLeFsSGgtLKEqM2kXb9vsDyC4CuuMBoyL4FaFBfaacXysK?=
 =?us-ascii?Q?qlFFRJE1cB+vV4xOB5mbhcp0auF8m8plLiLOZm9yll7+bqz0IT4BS1Tk9VfD?=
 =?us-ascii?Q?4/Oa56ABOBIMy0xTPx+hXX0ihuwupxl8ZzpYVwvuY9UeGSiAcIUCmkUe9jTU?=
 =?us-ascii?Q?4ONPzPZ5GmjqbjbHlHhTm02EH1JZLIG7AiZtaqF10c/oi40JbtmS7keN/wJe?=
 =?us-ascii?Q?0uczyERoKH0rGAd4AM1v6q59kq6hf7KcncBa38Im6MjRxlVfWF0QerirdjMj?=
 =?us-ascii?Q?spRBno3xLi9H7IVMq+A0Zt/2pp+HelOYxp+GoBgRjuaUNA1W2zJTwynxJdR+?=
 =?us-ascii?Q?vAey9FSLdJxdv2Jgl+BHiq7hyikhco8IMs2AAuTSXsSN4D9No02giJEeO88v?=
 =?us-ascii?Q?F07qKBEPQhB2oTLPqo4mH6slUn5S9lTIt1sho8xAsN+cZMmpStthHKO/Dcs2?=
 =?us-ascii?Q?BkXmmRiyp9/3DE9etfz6dQs2xfu9wV5mLc+zvL1g5EwY+xTX3ORTO/RaCCIU?=
 =?us-ascii?Q?rFZ+8X981SzvP02aLEPstsz9Cc4W1fx51xwN5fTvkc8EHWurInGa8rODzm57?=
 =?us-ascii?Q?/YTT0GhjsjCqkFvWCf8AiTwfSo68+gKVyJFe1JQZ5OV2m7iuXPt9QRzOSOb3?=
 =?us-ascii?Q?n0C4zUUa+TNmDxutQzs1p9disytrVSyUi+ioKH9q8x97+p/uyR0qPddk2FYs?=
 =?us-ascii?Q?vgaAbZlStCOOFb7YJ6lEdQkX7PLea5poRnksdYlv7hOYHoH3nZ5lkOp37rC2?=
 =?us-ascii?Q?lriyFCnCOU2DlyTT5xgWyAFah/3PgIox8KuN1vX+nDfk5TgWwqss41EaY73R?=
 =?us-ascii?Q?Yh8g5BCEMETEbB5k2ShcGvTz9MWzfFZuDfmXkuOF8mdQo7MZYaOXl2Fz5A8m?=
 =?us-ascii?Q?d+Zfebr3pTvcdq6eCMU45vYdIlMVtiFPCp/iT/pzUI9y1UVqW3e7rZprMImS?=
 =?us-ascii?Q?h9Z3w6n1/YKrBcGkW3dI2LZvjrp4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LIo+sGOMNnmh1PmZBZ5jMKZ1lYK5D5kg4uWse9/dVqJMnjnN1gisDEF8Pw3R?=
 =?us-ascii?Q?BR0S2GnFd8o9gzHTriZjqBCilezYkyW0P30zelQTkNTjSyR3ZVcoppJKEFuG?=
 =?us-ascii?Q?U4Nv/Ac17a15qOkFCjQKLFW8jOmXhCay/jX+9jTKFz984iDqEphlC/Yk4CsK?=
 =?us-ascii?Q?4LokaeRBKCHtDPOwzMwTuQdfKMy53bXZODlBeZnCJvoWFxtQSf2vCa50FSTC?=
 =?us-ascii?Q?MQcmmhSG25VY9p3H1j75NYWsXYAsMqRmjEt/iX5IQ9Dkh17l4kt3QxVG1SZL?=
 =?us-ascii?Q?e32RKzS7xPe54Rw8h1LrucTBQriJivLMhjJM4LPKf0aq435817/iaRZVIbm+?=
 =?us-ascii?Q?vhS7a9mX8x84B2UtbVZKd+bp5G53soXXLoKcl2qz4Mxd6QkiqutultDh3ihd?=
 =?us-ascii?Q?04GoCY8OUleePknbMPevmXENPUIOk0iGmZKu2OKMlqmDEXgYMDIvReXd8Y8C?=
 =?us-ascii?Q?izTsfHDowjyT0Vgcvcm9hae8y6MSqbKdhxP+sWuPkKE/cYzwnRx2SSY0ftIb?=
 =?us-ascii?Q?4HqUvR8owul0AY3Fp7Yx+m2RsD5e8Jv8kb47hR14j8dMYQQY2j89FSstNWbC?=
 =?us-ascii?Q?6k23ryhzTNl9OiSQO4hKtXqD7TSrWcZUZfwDVzwCE2FNbAWv01IWSvDxgI30?=
 =?us-ascii?Q?5nuU8aPpaJX90aByIMXed2jXEq+3cEvwOpbazZpUcfN5z+6P57JwWHyzj6N6?=
 =?us-ascii?Q?hzZ8XOU2KCCqyzgEb/tXTEQp7AUF7voa0rZBR2uBhh2+jRWuO2D8Ub2FEkhI?=
 =?us-ascii?Q?wAEJJcXESjpWihny0QzN5zXZUIIo2tOkxV9NzhsrHnxyhrJR2x0r+qrB4eDC?=
 =?us-ascii?Q?8npJSIPVh6gUc5F3ChU78M7S6gQiIiBNeLxzhyitp4selZO73oXJ2J3p7QaT?=
 =?us-ascii?Q?E/DumEWBmlF/uFQPQG9wAfJJPhqPHCKCquE/y8X3BPb/ayhi4WM7+Yy0Pzbc?=
 =?us-ascii?Q?vPCqpYO48FbvO4Bt+rqBal05nSfjKxiMmDwyHk13bnGES2RZ8tfTp2M4QzKU?=
 =?us-ascii?Q?I8e4wRrI7hAvGKOVo4PVn0EcJiSLZIwUjwrlQhAEUeJuT5AioGVWfvle7vZu?=
 =?us-ascii?Q?+3OZW5poAwD4jj+qan7IbO5pnnkRzL2FHOKtvrT/Tf0AG7yfowlAo4b+z1OA?=
 =?us-ascii?Q?FDHGIRDFmNEIJPo/mQbFgAgf/CotT8CbuUGYStJJmH7FyMDHKgbMtp6NFYm5?=
 =?us-ascii?Q?0IAzSu8PUCnI/HGESP8NkOz61pV7mS1DIcG9hMLRcB2AQmKJvk4e9aIK8bI3?=
 =?us-ascii?Q?JDIxFNmi4L+Bo3P84rizkcmywJv5M+VcXjd2/WfaDhzviY3oVKqEsc+u7n8e?=
 =?us-ascii?Q?R+fv43TUEgsn2i2H3iJSt9coDvfIjhuZBTIPmnvlmfC7Y+EMRPztM/PAeQbc?=
 =?us-ascii?Q?O8nYiGkfvNTybfqokZqg8LbqZKs3crsPJSjpvdjDgXlAx1xNtLGVYEgw6Gvo?=
 =?us-ascii?Q?Z5DuUEnU/B2ewG4pv67WrcT58K0ml2rpxf9Yyj64CArWj38e6J+z4uCofYJ1?=
 =?us-ascii?Q?Q5YNchKpcEK6HB1RCYfjw9cfr//W7nBSuANwuKWMyubb8KI2QC7V5bF0S3EH?=
 =?us-ascii?Q?GgEmJesKs7wCXRO8HjU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa66a6d3-3956-44c4-3fb7-08dd5a752255
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 17:02:09.2180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/LAz6CbZcsQcLttRcyn0RP4OZULZ4yCsRLbaHG9l9BYyd5ck2VaXbAVEpG0d1SM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5956

On Mon, Mar 03, 2025 at 03:21:43PM +0000, Jean-Philippe Brucker wrote:
> On Thu, Feb 27, 2025 at 08:20:01PM -0400, Jason Gunthorpe wrote:
> > virtio has the complication that it sometimes wants to return a paging
> > domain for IDENTITY which makes this conversion a little different than
> > other drivers.
> > 
> > Add a viommu_domain_alloc_paging() that combines viommu_domain_alloc() and
> > viommu_domain_finalise() to always return a fully initialized and
> > finalized paging domain.
> > 
> > Use viommu_domain_alloc_identity() to implement the special non-bypass
> > IDENTITY flow by calling viommu_domain_alloc_paging() then
> > viommu_domain_map_identity().
> > 
> > Remove support for deferred finalize and the vdomain->mutex.
> > 
> > Remove core support for domain_alloc() IDENTITY as virtio was the last
> > driver using it.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> And my tests still pass (after fixing the build issue on patch 2)

Yeah, my mistake, my tree has a different fix for that in a followup
series :\ I will resend it

Thanks,
Jason
