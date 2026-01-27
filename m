Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010043.outbound.protection.outlook.com [40.93.198.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44012FD691;
	Tue, 27 Jan 2026 03:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769484258; cv=fail; b=lnFrUZzRBKzaZyrLFx4YWY8HlA9015JmuysQOTvQft9OKwLyt7oI02SrvtHijDox0EOs46MceZJLNKjCuON2o8xxrtxhJ9OcOUfnceOgCkFdLaIGQpaU6NR8zK9R3M6QlJzLp2BNZtpbzQ4Gor5cPsRofAR6yevNy39R3Yb/Go0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769484258; c=relaxed/simple;
	bh=oQY+lR4Bi/huv34dqHduSgRaRxT1Gb6rJVkySgbT9ss=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfN82imiIG2Ro0X3KYX+8TgfdS2LjmQhThiUlf1hcXvgDYwwnRk4QuW1ictwp+KnQlbTmSvmAJ+x5HsXSFtjRFOlQGnBfWc8WwbrH0mCrTrtJoyhXod7rhc+a48z+ioePzRj2ySneygQYFbXvhBFTJjPqpuYAyyDuR9OPriNz3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=US6pHhT0; arc=fail smtp.client-ip=40.93.198.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="US6pHhT0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fe1fhJbk9SKUo88gnSvv9eKJrR3UZ1PjQp4zLJs5Ay1l/hHowW38Kxt30c1kXyTtnsKVDhU1aOWJ60cWSaoxXH4zqO4aiSZI93xkWvXxBhZf1UtDYsqFD4ATvM09wmOCtIi9qIwzUK6I2+0NeTk/n7lnBL3luc6m4RKiWdgiku/1aDMR39Ewa/kzzbAVgLRAtsuNbEh2+Z92R6ugAA/SdkWMNUkAJG2FmcgSpQoo0Qe8UNrzlP9kaLVWYjCDeYNceckZ+sRBJcAMW9tsDPD8jHegGK7VoQcc+cRc3mVfffYCtkNtSZ48iDVDelIJfc6/yW3fKZpxANy4qwXUhxgnlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxf/z7IqAvgZJ+FACikaK3VnkkpAahwjbMpV/1mCSEM=;
 b=yLw1x5hYAzZfNylHottKE7xAp74yafDlhX0lCgr7DOwQs107Rqwkj00Z9W5RvuqeY6OvpueclKD4KduDf9LA/I0atRAlx8cbDUVIkSZprgZpoR/59tZDtHtSt+Zu/cRMs7tWh6DwLB8lwWUoD2OlyRbEaUH4cdKRWpB7+RRpud06R4i+wwLQUEThIqha+Xyltbg8Ov6sAjBK68w8zXBrsgVxKDO9U06Mzj5Q6loG59yBNUZ3kNKLSZ3VeAEHGwkEKRpkRr5b1oE8Sg2uv7yAkl/I7tLSaIxpyBKkpRGTLsy7I+ZiZ2tPNFMQ/MN0cgIOKxHxwLL9QBvGHzGVUISjVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxf/z7IqAvgZJ+FACikaK3VnkkpAahwjbMpV/1mCSEM=;
 b=US6pHhT06sTsU9bHwIdN/uKZQVHXZwKK5h1CGBVhbo7OKFxOxd0HtsiLejHDvt41Q/F0huZ49mp5zc0aozTvkQRyCGV4fss9fvjAJxp1H1MbkfKhqZx3BhIoIsBI55eyfG5Ynk1kiUiNB3DVA4BkEkRqGCgs/yFFyVJq4eW5Sd5IyBen2rOS50TwYIxTs+4IzA1qZEjtwEfIivAXso31DbWt45uncxejjGf6/Dtae0AJaxsBF74/OdLl/HSsOCZr38i4nLXnRPyM4fLjcGlscvM+GiW2JJV58z8R92BfI1OrGAG4Xu88NBVQzGltrvFSexG5luGpl0R0fVQ6Pvs9pg==
Received: from BL1PR13CA0162.namprd13.prod.outlook.com (2603:10b6:208:2bd::17)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 03:24:13 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:208:2bd:cafe::4c) by BL1PR13CA0162.outlook.office365.com
 (2603:10b6:208:2bd::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Tue,
 27 Jan 2026 03:23:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 03:24:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 19:24:00 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 19:24:00 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 26 Jan 2026 19:23:59 -0800
Date: Mon, 26 Jan 2026 19:23:58 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 01/10] iommu/arm-smmu-v3: Store IOTLB cache tags in
 struct arm_smmu_attach_state
Message-ID: <aXgvzoPJDej7HEAm@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <40ecdf7e0766004c5d3a4bd086cb22cf08254237.1769044718.git.nicolinc@nvidia.com>
 <20260126204443.GX1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260126204443.GX1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 178ec019-53c4-4b4f-f28c-08de5d538b03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/rxcIDOMT9bgaC5uE1rAMMxwS8/ITUhRLDsxU4KM8tKfUHs5VsS6VqRKW4a8?=
 =?us-ascii?Q?K/jeTojTtQx5Ui9WF08zRT0TxPf8CK1hUCYyc/urrbzW425U5tU89q6owov7?=
 =?us-ascii?Q?ufuuFdoxZWMbnIwlFeQREonDhyQt2r5n7WmxOn9Z+FzXE7mJ1Wtn6QtD22n4?=
 =?us-ascii?Q?rhyQBrmMBWmhuNzJ/WG+sDrVMkH+zeC0Yjo+ksa5XmSv9dhrF6BdDUidFinc?=
 =?us-ascii?Q?72uejs4I8vZxAOS9YRT/zuKwP49qn6/M/u1SeXqtl67OAMlVtDIzLPAMlGnj?=
 =?us-ascii?Q?rcF/1T7k7dXJbVUoIXUa0E9oaSp1d1oo+NmNtOFBtt2egU6yfXRE2lyFd/FB?=
 =?us-ascii?Q?Jq4sSisfYwW36u/iK69psOWRfNfjv1xInz2ZYhetKHYym7IRcO4MkDgmDiVv?=
 =?us-ascii?Q?BEIPnfowQXRleamTUsu6SmfiO7gCxMzCLrv7e49D77EQMj6kDaovwPPyyJaO?=
 =?us-ascii?Q?w9yE/kMYu6Wctzhxr++EcUwkq7O2Ggn84I14KiaV12WuuEspUOiNR5qbnhWU?=
 =?us-ascii?Q?L5Wm4+cWwXvuoRUtmwUpGqtbn/lJ1D+PoLsc8i7tc2wL4a01ZP3Iy82cgcG0?=
 =?us-ascii?Q?R1cPGDW3jkp5sPWJHZf7qCrHstyTmcv5tD37oF8w2Sn6uASK99uuTath5YpE?=
 =?us-ascii?Q?bQVuaxjBvdOeTYBsfly+CyrxZjGdPNWRmmnPBLkJeJ1jjJ0Wh0bPpZzMmP5d?=
 =?us-ascii?Q?NKGkA/lQi+ppuL65gN02a5j6MBD63o7mEoV4SaTM8TXpYYMY5U+dzAGyWswY?=
 =?us-ascii?Q?0JTNEpDDgUZgF5DeWdA9x5agI1e/d+7LGSwa55gVaHFnZo6kYLZMGQn0qukZ?=
 =?us-ascii?Q?YcVlz4WOFkfcnAKkSdDTR1MmVk11bpUhovpiVqMUuNu/F/0j/2/K7k43+tms?=
 =?us-ascii?Q?F3SSsiv6mi26QDf8Q1Qy14HgeXFE8sDhL4E8g9++GBbwaYb+A8JnFbFcCA0F?=
 =?us-ascii?Q?XGqYsQQCEw+4ariuwjZN2FI5H4Q+xj5RUeBng3CaH8+lJTqDZvuRsinrUdjy?=
 =?us-ascii?Q?+WGjkxmeSsDemS5VLnusJ33eH47wS1aAnQEeT8X6nMR2NQ8zF2oxlhFfW/iZ?=
 =?us-ascii?Q?Uv6Lxn6039OClfACYCVv6Mk4Zw73E9HnRYpLB+2IyycVrM9WYwRGqaA49HbG?=
 =?us-ascii?Q?zv91K5yzlW2rg0sHKVnrP/xdq67gcCdE6gkFzWrbSPJ2p9iqOeCes/0T/xVb?=
 =?us-ascii?Q?2ZvTeLRrEsve9vNJugYaQn3nU5fLnrRny0xRr6tqMF0r+OmFxW1EqaDS8LCZ?=
 =?us-ascii?Q?/ObPkw34BCQ3aLtP8JxivjWyWRIA4RpxXuwWR5ERqRkKDDhfRb6PVb4QT2Kg?=
 =?us-ascii?Q?wR02RyOl9JRQSxwGia427XxmvAT8YKN8cUgZrDLwjS/xMro5SBzQ6e4S400+?=
 =?us-ascii?Q?WKLIul2niweDC9IbiLlIuKXB4Je1D0TZpkRR93bcf2lRi00T0z806VjE1ObX?=
 =?us-ascii?Q?Tsqi1yTG1KJc2kzdBI1IjjuvcZ4Y/UXg7igq5rVTLy8CO5qM5qMKmlrOt250?=
 =?us-ascii?Q?VGmObS4BImxVS4B3zcDAaMYi9XB0KZcigoux0cwGZLCEwhf4zUZ6W9YrzpPq?=
 =?us-ascii?Q?GWPpmWnllxDCh5bA3SBw5MW5+pMSaV+qF1GINjLJfrCsmRAo+8lk5nzxmrxd?=
 =?us-ascii?Q?LKi1chYUR4X05miuPNsZHDPV0krFVu1WCZOh821mcwDQrJQfkuqnd5xVNb2J?=
 =?us-ascii?Q?/OFdAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 03:24:12.7219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 178ec019-53c4-4b4f-f28c-08de5d538b03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128

On Mon, Jan 26, 2026 at 04:44:43PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:19PM -0800, Nicolin Chen wrote:
> > +int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
> > +				  struct arm_smmu_device *smmu,
> > +				  struct arm_smmu_inv *tag)
> > +{
> > +	/* Decide the type of the iotlb cache tag */
> > +	switch (smmu_domain->stage) {
> > +	case ARM_SMMU_DOMAIN_SVA:
> > +	case ARM_SMMU_DOMAIN_S1:
> > +		tag->type = INV_TYPE_S1_ASID;
> > +		break;
> > +	case ARM_SMMU_DOMAIN_S2:
> > +		tag->type = INV_TYPE_S2_VMID;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	tag->smmu = smmu;
> > +
> > +	if (tag->type == INV_TYPE_S1_ASID)
> > +		tag->id = smmu_domain->cd.asid;
> > +	else
> > +		tag->id = smmu_domain->s2_cfg.vmid;
> 
> Would be tidier to move these up into the case

This will act as a fake allocation path in PATCh-3 and eventually
get replaced with a real allocation piece in PATCH-4. So, I wrote
like this in a transitory manner.

I can add a line of comments to clarify it.

Thanks
Nicolin
