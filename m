Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012002.outbound.protection.outlook.com [40.107.200.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E659F1EE7B7;
	Wed,  8 Jul 2026 13:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515938; cv=fail; b=n7eYBXG/BVZxzcJ2dWa+wNiAW6EGiXbaN+qPOWBl5TxDKPEzmpe5Esshse0RhGdU4iOE76wH9/L83qKIlM/zmrOLLW5of+7Vur9mINH9n/Rw70Inxu85DWoCIQl98ijdR0SaxabVrna8YijVKLKCTaZ5MHPeuKu4/2nj8lwoYwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515938; c=relaxed/simple;
	bh=N4BtVeeosIG2x1si7O1IJK3km5VDtnnn6jIyErfCX68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hyvqj7ljGASsRm2wDoM0UewXvbJS+mURF/L0Oue44jWePcUWTsZV/aFj+k498rJBq4BVgdOlcF7fnCsOR2TQP57f/elyLvtGmu9pXQouBpyZQ2fkvBJc/qHNYlpkry8kKiphQeixjapz7AfQpVrL3qtZfUSGSajPtoW5eGkwb1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MRvps2gS; arc=fail smtp.client-ip=40.107.200.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MRvps2gS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMtkJ5eLcOy6po2g0WotYN9s0MjZrS65txuAes3XIiQtjfXtzD/9M6AHv+poaBu1iyE2RNbNoZXO6iUyDOpZzWO7TlpDLnLrOTopBIgbzUHSpvpUtEfXGPNRuEMXLkuptBuA2q8X1iJi06F2GPFfThQyTaqlwhsiq4jTm1aVeI90T2U7y1DwJLXzmvcQBQ7qaPAnZ3Q0gY7FATmaKTRkZQ8hKFc0+JYNh4hqoZBg2aGFnou2DL+chAQ0bqXTV1Ta21JJxm/IqhxHpeXqecnvCx/DXI+SjZDG7C+q3VOhKUAX0upOSiFhvcSVDH7G7ojJkLhVqC57Fg8YAi9Rno9LMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UiiG3O7C7E8Y187yZCWZJCROxDGCT070jn0XR7ExXyU=;
 b=SiKdo2I+3bWYayBdicx2YwBxbUY02hihZy3dhabMVZ9Gpa/4fl7IxSYrrcL5rCRQ3DaN3F+iLqdEZp6mqNczB7FD0hd57wXRIp96IMHQAcjA0whTnEQB+G+Bgg7f9cmdn1KO4AgoV4qdeXPrHkSpaNti/VOT0sFrQu2MI3e6hWZiGDP95h1R2KvtZDjbXfWBihk3XDM+BhGWt1tWDD+9ks59U18c49gRql5w4/P47xDnFQy2eX+RBsXITShTqAuklt9uRoSOtrtRKzYI8EiLjHb4YDm7Uj6xUnwc/Hsa2VfCrzLwuQEa8gTasHOgqLNNe3jWzIHSJWmDAXOoMVbTUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UiiG3O7C7E8Y187yZCWZJCROxDGCT070jn0XR7ExXyU=;
 b=MRvps2gS1LbJx2CxTYv6AYajVW1TxWY6KGp8K6hF4GQQ9QmVRmKVDm6WDxWYzEcLyng2I7XAAYDcjxPqIYz1Y8xVfPswvcsEC+Ib2zJSX+/IQf15qMtyiawV+Jrd9cIFnC0GPilZsX9a/iks4bj+RwsjQL5OLO/BNeikFGzOjszm/9i3Tukz2q1/I6KpGWbwh8ZZQRrIO9hg1mCVjJi6xK8H/mmWiYPXKlkFAZnQ3DUvt1JzHHio8WofhARAqrknA4r1Kr3m6kW7CxQCblmpMbboLKC/JpnfpQefGBB9Q16iEoUHdWmQQVyTDw+eBUNHghsgT6TjdaZUrC4ekoicWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH0PR12MB7488.namprd12.prod.outlook.com (2603:10b6:510:1e9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 13:05:31 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 13:05:31 +0000
Date: Wed, 8 Jul 2026 10:05:29 -0300
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
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support the DS expansion of
 RIL's SCALE
Message-ID: <20260708130529.GO220801@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <8-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <ak2J2gLgXD7WJbfv@Asurada-Nvidia>
 <20260708000239.GN220801@nvidia.com>
 <ak2xnfGDSnITiEjk@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak2xnfGDSnITiEjk@Asurada-Nvidia>
X-ClientProxiedBy: YT4PR01CA0474.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH0PR12MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: c2c5d020-4f52-4950-3cec-08dedcf196bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|3023799007|6133799003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	FOl7sIzKOxx4j9YONPsdsCuBHimAJlRguvYnO7qpBx3KzMSyNS5dtfoPr1D3scueFRuUTakWAq3ViYjeBFRQIJG8R2yX4CTb+JhgKSyoDOhX9aCVjZeaV3NO1/utLh76aCoOviz0Ixxklubco8LCaiPOOG6heGhoXGGSo7+qMYd2I9dsgeRG+2Yzp6Gnvu7xB5i/CUJ1CaQkGRyBdblj2WhXh+VxTxG5ZZqYmJX+SSoM0YsGy9xoN351l784MTvnsbjLc1vTopgaeOEg6XkV6Yh6RXhPbkE2zr3eTS37+hJCYa5yhtMf46FCmTZe2GiJ+UekrEEo4uHWkuH7Kdt+K7j5qhzRJvS1ty9qUbSzqi7USxcnnjCUCYbZw4iIupI7yJFFnW6GV/IbAajWB69IIYsrHZFDlXA573us3Z7tVN12fhgjLbHm0iIMMlQi7sh2lsOaY1Cj2IGtR74kEYFwrdEJTKydAp1k6qOQcBiKI1F6v8QuSdX+38er4M/QT79lEvShwltpSBLd59b6m3PMF+jQ1/B4qhXzMInHyhMgYXvJnj6+5P/wNkB0qwo5CCphrYQifeekOQeVow9u81CTcgUQAoBvFB5LB/N4IYCjEXGB/JArfCeNC1sPP32TjUuGk8yY6glMlnH19CUNKM3E2QB7cdTd78vMudqqd//YguQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(3023799007)(6133799003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HNSj9N/VdS2A1NFa7m4AyQLn39uhFqRRlSadq7YQrlFuc+Vi5p6Qnoh8Ylvs?=
 =?us-ascii?Q?KT/TspXrQmmbbmTyeeLkLprseCL0kcZ55F++7OYSCXucSkaYI0A9tzsDwghm?=
 =?us-ascii?Q?4GGUfRU2/Xn6LBVSsLDi2fxh2fTbEoUzvM4kOmNJ8DhMeXN6z5jacsAeBeMI?=
 =?us-ascii?Q?UEK9d8rhu4sBVTiXr7KSNCdU/VQ4uMrOJS5puCGkOFE3CTsvWKgohTOkpagG?=
 =?us-ascii?Q?Y89p24bqt/bfhKw9CdmWQcr8O6p9GSxRrlsDdwSk3lCJ66JaThMH7UPBU1e+?=
 =?us-ascii?Q?Reluri4YI7v/hYAUpxaUMcgpG3lIctAoj8ps0g6TYl/qqU58gldj2ZPULpEU?=
 =?us-ascii?Q?YWWYBi77T/jK1Rg/Gc1HBR9JTljMV7iXmT/2BWOoyOnlvIC0DMqQg4ZK/bOF?=
 =?us-ascii?Q?Za8kwKcDz/THspk4M3Y5gRbENP64+RenefvYKUDHggDkOl92qd1UEjX2Rh6G?=
 =?us-ascii?Q?oM4o8SEjNGnPqZy6HrF7BD97rt4wgxKKeTsY1IT3c1PRpdNwGBXm0PBgwLSJ?=
 =?us-ascii?Q?Qa56uG7E3vUvsD/8Tt8NWG+LIe27c4k0q6CnAZ52MTGPERloRRltgPGAgSD5?=
 =?us-ascii?Q?qxN31zJGG5WvIkDvHnLgb2dSeZPX1m7XK+BPQkO8oUzAjAMnk4jCssuWx11h?=
 =?us-ascii?Q?ZofJPqb+dZwt+tfu60hbAlfVjB5C3kUkKXOxbkfy6OeGQRoUVSlh6gZI4A8l?=
 =?us-ascii?Q?DryCHqNb480qu2VlJg1wjk2uEn8VveaSoGrBJJLKqHJWZhRlrXXPqQ4fHx6D?=
 =?us-ascii?Q?0FgC+H7bWQ5djRm8/nqcXhAsVsACtNN5mcTb5ZztjUEYR3UslucoDkuwb4Qy?=
 =?us-ascii?Q?jgVe0WrkkDvemUqha1W5wfe/t5Tpmar0B5lNjh25gqweULEb+bo8JXi47erL?=
 =?us-ascii?Q?qlxUUIenK0BefHcd/6GpO0tbG70RXiTRxBCy6jc0xelc6xFgnUNQVhYByKEf?=
 =?us-ascii?Q?sR1vFzdsbQ0dMK/qPAd5xzyzc/wHf68sHRnKRy6SRk5DIN7a2CxPPXlwanNh?=
 =?us-ascii?Q?R39N4LmvnleSM0X0nXyIr3J34wmNO+1eqlWNt0u4o/9rmUGoRaF74bBi097J?=
 =?us-ascii?Q?jbCEXE0vz5FeMrvtqWxfSc5S/4Sc0V8WBhcZ4RqDzNkNDMiDck+AUuMttrUq?=
 =?us-ascii?Q?Uj5xiAbvmoZ4gigFB+mlG9XMs9L6FECs0gmFr4Xr2Bq/glpKfPXyM8x33u38?=
 =?us-ascii?Q?jFD7aP3Qm+iZkwQHeHzrTfKmXVBJ6dDJI7W9uSasLVAKusl/4yZ8Xh3zQ1oR?=
 =?us-ascii?Q?rv1JxuhUI+xipJZFbdio2GoYuYJRIdWfoK4P3saoNd4zCBWyB7u4QjqPcDEL?=
 =?us-ascii?Q?rIDKTb5TWaOxghwsuLSQrcUneLEs9tiLusi2w1dWaYZDbSp//nEbVl1ZPALT?=
 =?us-ascii?Q?K4kMC2PhetPLADs65s65cnEMdGTJeeAyBbhlGZywDFr8YI9lWpWaMABaONuU?=
 =?us-ascii?Q?Ls6LwkSWvFXVN6tyraPQLcXnHjBepbesuF1SgEAk+326zgoxQKCuJMaXMy+7?=
 =?us-ascii?Q?8vw3biHNIqghDDyJ0ZpA5Zg7CmaZ+BSpAHciQ3vIeJcxTQsUTzTYmMxG16rQ?=
 =?us-ascii?Q?q2+jYnHcWNr9kNASdCGoqdFAZ1xfbeS/G6bHk6CkMOJNUnHM3Is2Uz9oi3Zg?=
 =?us-ascii?Q?OUc6JqXuj5oI0njix/BzgUBmkddzNJ8OiaQjoL5KWeeqGU23dauRkqtgT62C?=
 =?us-ascii?Q?DQrIwMDwVjLLXztbNNAT2lMtbXkLwIj313wPAn+frAI1LWrZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c5d020-4f52-4950-3cec-08dedcf196bc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 13:05:30.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wocz7QcR7udcdsZqh9d5q27+aysvz/xiywSDOH6JZIaff/uF0a+U55hwFdyT83wt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7488

On Tue, Jul 07, 2026 at 07:10:37PM -0700, Nicolin Chen wrote:
> On Tue, Jul 07, 2026 at 09:02:39PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jul 07, 2026 at 04:20:58PM -0700, Nicolin Chen wrote:
> > > On Mon, Jul 06, 2026 at 01:26:45PM -0300, Jason Gunthorpe wrote:
> > > > If DS is supported then SCALE can go up to 39. Detect the IDR and compute
> > > > a scale max that is compatible for the entire invs list.
> > > > 
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > 
> > > Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> > > 
> > > > @@ -5235,6 +5242,9 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
> > > >  	/* Maximum number of outstanding stalls */
> > > >  	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
> > > >  
> > > > +	if (reg & IDR5_DS)
> > > > +		smmu->features |= ARM_SMMU_FEAT_DS;
> > > > +
> > > 
> > > Just a note here:
> > > 
> > > This somehow conflicts with my iommufd_invalidation_loop series
> > > where we sanitize user space commands, because the driver would
> > > support IDR5.DS. So, one of the series would need a rebase.
> > 
> > Oh that's an interesting one. So if you add strict validation it will
> > technically break DS, no VMM can set DS to the vIOMMU as then it would
> > face invalid SCALE which the kernel will now block.
> > 
> > Maybe these hunks need to be included in your series, I do expect it
> > to go first, and we should try to validate fully.
> 
> OK. I can take the minimal DS part into my series.
> 
> One more question to confirm: there are other fields like DS, which
> are defined in the spec but not supported by the driver. Should we
> expose them via hw_info while rejecting them via user cmds?

Yeah, we decided long ago to expose all the IDR as-is. Userspace needs
to understand what the conditions are for including a feature in the
VIOMMU.

Something like DS could have reasonably been concluded that the IDR is
sufficient since kernel always supported it since iommufd support
came.

Some things will probably need kernel flags to indicate the support
is there

Other things might just work out of the box (like a PTE or CD
feature).

Jason
