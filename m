Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2871B423C;
	Mon, 16 Jun 2025 12:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077837; cv=fail; b=np0C8sbTwtM0OndiFiGrpDbRG8LXk2WEl5J13v25MEtRWoY7DLzr8fU3tP5Yl/NnGIGsxwIv28E5a+HlTuYeJGH5s9f/00MMYLix/sB2sQPnMZcaV/rHQ1/AW1bighzim3SMJuEaj8aiwGkekBpCE2OP40ByIgEiMPsVzTwt2So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077837; c=relaxed/simple;
	bh=vj+lOJN0lk/Cr0seZFXy5Z6F4izFtgoCpVCtiP6upDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZSa9W9A1+rnoR+nHnna7VdDh6gDoXMJfp75eJ+x9WJwZWhS7Teeh74PreoqB1k9v1QUka3scl2HTBtJaCNhjvuOdqQfl/fPrkTBdOqwqS44Jz1zF/MtUqo3jidkyHuNY+RE4F1P7qVsFfxvbzmFVCT5M6RtgYbXeP9caOvY86lQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ey/PYb1/; arc=fail smtp.client-ip=40.107.212.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ey/PYb1/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=af1/S8r3g3mKyhvvfbqy3f7yjM0dMCsdzigJA0kDnX3HTtibxiA3SqwKvAcJiKczl+D6kvrCB5JW7QGHKuypztky64hVqVwnBJWt1CeguUCgT6XzJr/WXnaGtlHfeXwXjrrFtUGlsqxKjvkc+SuY625oaFSxtF/UC/BUrjxCL/k4GFdvGpQhhLh9uk7vZqcuuAnB4zfJC/n6rHUdc0hw/I4E+S/0dvS/8TUrpIUYGGa8bpK/YjR+yda8I2RaMOEbLmF0FqSdd6dga8YUw91Y4YudcNdvLDfKzdNZvBQArwYErZu+B8iAvpyP0PAYUjNXGfWMd4KQe+HPOky0s2+vNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODU9k3PMvmMnyqahhmMCnb71KcYvNKwFEBp57Av+tuY=;
 b=GE4/iQE6vEmXzUbvp3RspOzsjSkXgVdp6i/G7YsQv79gB0Z8BWRF+0m+Et8NK6m6y7Frh82ugZR3Q+j+wx1sDiYki3Y1+yHnH5wh/dRSbXsUkDwutCPst3ZnQWyEI1aefbaxMTzIYuOSNpX3U6dG3mGPKxggFToEt7V7rmhSIRfP5vPuHmjvR2peMGEeo0+9JW4M1w/eNiFSaHQHp4Kr1kq6LAC5nSWIDxzvYu7L/OheTGiajw//x6CzOB1fmmsNHEqRH8GS1Hsab7f3ywBaPflbgSsfyQTamRUhEEwPqcWzznMCJ5MdWxpP55KCRkWHKfmO6atpPVZeJ+YuDq/7Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODU9k3PMvmMnyqahhmMCnb71KcYvNKwFEBp57Av+tuY=;
 b=Ey/PYb1/UrwPVCZYDbl9j4FCgMambfiy990tMnJSKpZGH7jDYBxzD+66YlhNCUy4JnexU9ypNrUmbzIah7PSLi9IICbX/NVCxtVXErTBCc5etPLfQC69Ie6EIQWKJvhBzNJmeDWv/CF5SXXcOosRxqtvwIAWEyMW60zj1gjYfxMhKyS63cC2QlGfkB046/3v3K6g50AVcQoykGZcfGcVtRkMrpJKiCUJ3Xd3KOUOyTJjImrfYBA4RoINsBP5LcHY9GHOM5tUaGT9o4E0mds89tQ/G+UHdANsFuZm6YsoIq3f8hu9qr/u3+5DwFdFhMiiBQJ63uwtSLOd5ayuxnxGUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 12:43:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:43:50 +0000
Date: Mon, 16 Jun 2025 09:43:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 06/14] iommu: Introduce get_viommu_size and
 viommu_init ops
Message-ID: <20250616124347.GV1174925@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <3ab52c5b622dad476c43b1b1f1636c8b902f1692.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ab52c5b622dad476c43b1b1f1636c8b902f1692.1749882255.git.nicolinc@nvidia.com>
X-ClientProxiedBy: MN2PR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:208:23d::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH1PR12MB9670:EE_
X-MS-Office365-Filtering-Correlation-Id: e6511ab9-7fc5-44a7-ea57-08ddacd37147
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cA2nMBSnu/0PRLw+eIxWnbal+WMXMAsTJJ5l7P+pM3D0KIKrQXt/EjYvzgBc?=
 =?us-ascii?Q?xlQ8JrB1b2owRDGT81SKx44I94tBiPGdY4Ol1uIGFXn2DIIzBt2zg4qEVE8h?=
 =?us-ascii?Q?txJWg8YHjRpFZs9P4cAkzTTBGrfSGQJjsSUVvwpVApuHGJ0ZTtdxzbkDJquX?=
 =?us-ascii?Q?C8mR2laEaiT0+HQzkCFZPLOIL4Rn57gmd9FSmpuIEzyRS/1+oc49hsjZ/yK6?=
 =?us-ascii?Q?QyfH384zxlXS2cF03wxGmbilo744jhaBPNM3hHJ8vQ93ucs8hKE7MazzuxPC?=
 =?us-ascii?Q?UI78s3xsEP0asC2ZVAvkCQjQHM+C3DTsYkozNjP6RuvTm8TWsSzLQl2E7lxb?=
 =?us-ascii?Q?fYJhTC0TzfaKpz0Oy0Zhdoym/yiARSJbu0lBRqHskD48S/DT0VHoGI4CU+e9?=
 =?us-ascii?Q?H/pYNvt8EIuBvF6K22vr7th9mM4uF8V3xlGb2pJ1WIYtqctFTOMFM0V2bC+D?=
 =?us-ascii?Q?FpgV0eKLJmHHwK6meeYOoREFuNz2vG9VWRutW/OjT0FxXS0tUrlhZUzkkiZz?=
 =?us-ascii?Q?N2jzc7aON/aCu0U+/3OD8ijrSCC2QcJfamgs5sCWUctiIMVhQfLbdaiEhzqj?=
 =?us-ascii?Q?w8l2ZcDMsXJL05lhob0q/kXrFG9ehKor9d4dc3J71MLU81gKmOMfl/NPAQtV?=
 =?us-ascii?Q?c3lV4chX0plpAPq9cTfDte7omlb/oEeVAlJ7bBSg4n0nkU+xj8UAgLjioi4q?=
 =?us-ascii?Q?s6o7n4/XochSZEoxRC1T9Msvj+3vLkSYOkWFlZArF2MpAVcNfSWeJx1+NdMV?=
 =?us-ascii?Q?wwFewkGnJUkhS/4BF3OEQ4EJx5QMMllXVhbs/SQJ9QUOp5V2rFaxoa2OSeN9?=
 =?us-ascii?Q?73wHhpbjxD4nHAqwbkUVSJT7Ej4speO8UGg0jzw7ZB62/hegdqTmJHs074CW?=
 =?us-ascii?Q?/1pw8b9sTL20LgGqJgcruk+CWWsFon4F1Xe0Zg5apKSJQDGzC/J4KYqOfI8Z?=
 =?us-ascii?Q?5x7PR0cHGCByFrz09vlOsYwrMbXQj5fTSew1Jye7+gKLSygshzp0Up5g8bj0?=
 =?us-ascii?Q?xMwGDoLQHLLv5GTGmWUXavB6Y1Gg56MX4pbZ1pbfLkgmrBwLd7G+/5KBOQjL?=
 =?us-ascii?Q?6DtA6m5nvBBc7/dWPmIp6DH7DcZsUnUmXgl1urG8h1lzJbRLVtAxsHWmIFjn?=
 =?us-ascii?Q?d+XCvnRjAG+A0ZLqSLW2PyxlzY6RbhrXkb70Yqmk5fj/HZo+Zc2tl2+9yruU?=
 =?us-ascii?Q?GcpD54yN0TD5RMMJCknHTeVQogRki5vfq0Uk4Dy+MrjFNCEXvhd+FpMtb0FH?=
 =?us-ascii?Q?kCbzxj0rn02UlboWYpLN7gzWkGOeGeTXZ6Hl8Ywsiiq0elxmmw5tMr0YqoO4?=
 =?us-ascii?Q?WhCJgyVs04Oh3/PmxuhooajLmqnKoHTV4XrHcHhZ9ulxx+v6oqktmGZpQEVB?=
 =?us-ascii?Q?iIRYP1pO33OaZFmWoJ4Ibsma0XG+W9BZBygvBkE5I/cjenbd7w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ul0A8Y8EmPoEhSQLGj+TXMMTVoroV44VMeMaQPdPkejC/rsPlDi5XCO1WwqS?=
 =?us-ascii?Q?Cz5iQXEBr5MHHtjL3KF8e70WIBELds7YUgypScVnJV44EYR4OaBACldIolNb?=
 =?us-ascii?Q?nascn/s93onHZejDKI462ohxC3Lhdk6FD0cZLJLvJ1MKokp6bc8veithMCXG?=
 =?us-ascii?Q?hZJmtzH1Dw8/GW/ITn75nc8Rs23GiDMCQpuPy0Eano67qwf5F4h2CcxGJXmk?=
 =?us-ascii?Q?33jbUgKuCVeqD2FWJlZx65fCcS1jVbpI3kkN1k5Q92tq08vT3ZeAvVHpZQky?=
 =?us-ascii?Q?xx+j1Xkg0ALMNhA6FA9ZpCKLJ36FAE3Aczk2qmWtSnTqHb1OmSJ7C4lSRZxV?=
 =?us-ascii?Q?76hp8UXr8ELmnQSNbA6tlaehjCOv7EZ1iw64FRN2gdujPJY31x3rxSO/Vo65?=
 =?us-ascii?Q?UwnuSHBR5WHER0U90/B4rQLZrk0x9amieme76ud2CHQvtEdn3eVQpmCvxNhV?=
 =?us-ascii?Q?81y5H4MF/Mo9qyAD3udMQpo4C9tfpNGhW+nV+kslNfhvdO1YDozyA9w82sim?=
 =?us-ascii?Q?qNr1NBsDVDClhuvG+u6IS1+v+PEBiCY2bw44qT5ynMa3HUvShsjoeZKGtIa3?=
 =?us-ascii?Q?NsN6w3vhBVOI81GRrTvu7sNLEOK8E2ipNa+qXvIyLoV27LjNU3pQ0YbXStAC?=
 =?us-ascii?Q?rMpngDDQpyKDRwLwFfJkmkuW7Wt0wQVker3dZt+GCiZpeqyfGR2kmUNuhCJc?=
 =?us-ascii?Q?E9UEMfJSOHlhIDYMuNHG2j9X1PM0+mCPVKcwgmyjWvwjGe7bsHFY42z44pqf?=
 =?us-ascii?Q?f+wLXlQdV8IQY0GYGgqI0WfIGF8l3DwP2+U8tP3xLSQ2EId7rz/iGud6JqRn?=
 =?us-ascii?Q?zd7M+03GOgejoPLyMqSXE/2unSLPDrN1AP5spWOllVzw53QDCTt4DCA2pblE?=
 =?us-ascii?Q?31bDoYtaZ97YMR6KnsxIZwOXUCpqabgq/okK6EOHVhZGwEJIn9NfciuKdaC3?=
 =?us-ascii?Q?2cJxXPN2bU6vlo0Ai36iCQXmvwcrNmy4UBA2ZiCmCHIypAQGUrzP/LzGVi3x?=
 =?us-ascii?Q?3eJ7AxlIRAvT0X6pHVCob4gmN3APkzHzu2uqsT2Tmoh5RdSykUynnVVgD03V?=
 =?us-ascii?Q?UNFO1weJ5EXflBWsy3tXc60NyWyWphiBqbBvWcKGk7slKwfBmZavyVwYXAuz?=
 =?us-ascii?Q?16G1daCH1JqnMP2sATM1E8ZJ+TEBk5WcZZ9W87EzAc5EaqQeSQf/aSVJLNS6?=
 =?us-ascii?Q?82hvQ4qQ1dsx5e/zWRU2/RVRyK7D5Eec+wv46ijgJT1+dzGYrCb1x2D0tMxa?=
 =?us-ascii?Q?NIFtcc6pjnYM0cIQTw2SN0JAJqAG4swGy6FvZ1wALmE08rDEYo5sIjOIjVQn?=
 =?us-ascii?Q?mDYInvsCoXobx3Znwjs1+OfYscUTcCTbhIM9y4PZ7q7kKMpOpI3kfarSQjGz?=
 =?us-ascii?Q?93aR5BoquTVZo6uAmOJ2pWAUpTVdNLeYC+/rQMLJRNfrkHDHLYJqj/WaOyHD?=
 =?us-ascii?Q?3iYslsF0C0ijAhx6JvK7/MXCyBHHf6YDgfsS5xRUjUbI6XvH3A4PNMsh+42f?=
 =?us-ascii?Q?ZmJqP6rsrBXnAljWEbhtJNmsbQH/yxFJp4CaWQrFYaZVoYPtI5XW9Yf5hWOK?=
 =?us-ascii?Q?hu+KtPZ+dUTVxo6D0b4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6511ab9-7fc5-44a7-ea57-08ddacd37147
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:43:50.0090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frR06l6oqOBI/G2t4pdMgoY08IEg0Du2vBxeFFbVWi0Oz8LPzF9DTuq9XiDlVqRE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9670

On Fri, Jun 13, 2025 at 11:35:18PM -0700, Nicolin Chen wrote:
> So far, a vIOMMU object has been allocated by IOMMU driver and initialized
> with the driver-level structure, before it returns to the iommufd core for
> core-level structure initialization. It has been requiring iommufd core to
> expose some core structure/helpers in its driver.c file, which result in a
> size increase of this driver module.
> 
> Meanwhile, IOMMU drivers are now requiring more vIOMMU-base structures for
> some advanced feature, such as the existing vDEVICE and a future HW_QUEUE.
> Initializing a core-structure later than driver-structure gives for-driver
> helpers some trouble, when they are used by IOMMU driver assuming that the
> new structure (including core) are fully initialized, for example:
> 
> core:	viommu = ops->viommu_alloc();
> driver:	// my_viommu is successfully allocated
> driver:	my_viommu = iommufd_viommu_alloc(...);
> driver:	// This may crash if it reads viommu->ictx
> driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
> core:	viommu->ictx = ucmd->ictx;
> core:	...
> 
> To ease such a condition, allow the IOMMU driver to report the size of its
> vIOMMU structure, let the core allocate a vIOMMU object and initialize the
> core-level structure first, and then hand it over the driver to initialize
> its driver-level structure.
> 
> Thus, this requires two new iommu ops, get_viommu_size and viommu_init, so
> iommufd core can communicate with drivers to replace the viommu_alloc op:
> 
> core:	viommu = ops->get_viommu_size();
> driver:	return VIOMMU_STRUCT_SIZE();
> core:	viommu->ictx = ucmd->ictx; // and others
> core:	rc = ops->viommu_init();
> driver:	// This is safe now as viommu->ictx is inited
> driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
> core:	...
> 
> This also adds a VIOMMU_STRUCT_SIZE macro, for drivers to use, which would
> statically sanitize the driver structure.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h   | 15 +++++++++++++++
>  include/linux/iommufd.h |  6 ++++++
>  2 files changed, 21 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
