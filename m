Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010070.outbound.protection.outlook.com [40.93.198.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1CA3AEF27;
	Wed,  1 Apr 2026 13:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049237; cv=fail; b=e83QiXNW4fAaSGbN3oycCwGP3mmHc0PB/g1er0a7rE26Nd+g9f5A044ptCjg3rB7427aEEgyB2pxQnNaEixFwn7Xmrw3HWK6xPV3gcdI7nz/VfjfsKkLg7ChtKnVXS9lB/tsjowAP2X8RFfDao0kRwi9CtT0+37/NJCilrq2a8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049237; c=relaxed/simple;
	bh=sppYTsdKVgKVefqT0+q0p1JyZ7RhfcDAC2Jw8gERA0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qlG2LDKwWzSzjPnVGYh9Q98mb1D5Fno3K8PoThDZfrsTWeOMZcFqkBVvY1hRg6VJIw6CsV0h+2ZJRt/WnaEzuwOlSsKu7tmio3X9mE6DCgursXcxwYo6nhqai6oGHM5qLL5gA/XuYsbk4B3lXFzhDdt3wLI077Q7jBfyAV0yYjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m8F3tocW; arc=fail smtp.client-ip=40.93.198.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m8F3tocW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHKygzuvgo7PyLkWysiS+QzroS5K6Ivc1WazHvXqRkeKBBp5i3Ij4jiTS8QSo/qnecTOIJdzfbNh9jdpR5LzcXKj1NuoK9GCK1Zn4meo1kKMJpc5Ntbb8RGQfnUSqdJsQxsMdOiM6l5dzipUfQCSm1Bvx8FGU/NNRW8pX/F3tq4lNdNPEUV7gTAzV9ZfhBhU540rghgrzWvNYJuu5pmJdbKlVVy0SQB176Yb4vaJ/yaejPXSbCHIAjJJng2X6Sl+wZWknqxjRRGEdHp5U+wjcr7r4NNq346XPwddmMXQ2jpVlBHn+qRtQ8QlNV/PpoGr8pWOkVlT5xWN5qUGoHgb3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNNVviel+c6YPXMci5P+Z9kD6fa7qPfHdRPL7eodw/Y=;
 b=aMfFK1nckSOjBwU97yCx4fvB9gLJ5rTWYMPlq5uTI/gCqnCgsOS45BDdWq++e88828JjiSIJ3ILvDwd7YdeyXcMckmiwF3fmhKm+9ap8soGSZihBa0Jd8XKNyE3BHcGKUG+QjpdiTbk8BCtlnzZPrGiBANVTHj3vqtaPGBDMcOxTVH8clz8BgOTOS4iU+W3knRuKQN9ThDUUiF/ttXpS5uiN5usA1LWxLoRH6ArmNEMZshj3QxDmqmTNae2aPgAXJd2lDn3/7D4/focdl7y0X1AsXi66ZUrnGP60k6lVRDVupdHfQZ8lQzPB+cnoCWq18NMEkPrhdnw7YF0o3yGIDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNNVviel+c6YPXMci5P+Z9kD6fa7qPfHdRPL7eodw/Y=;
 b=m8F3tocW9kLplXuX5v+vejWZf5Gj4UBTPit41eWyGVW3qAQVwmkwEYsBUUCym4mpMSjGERY/x2Axrp7fGKsOdTtxEnPHvHpjFsdD1FnLXTVNiDiiMIniubJynqdtVKm6bVU+8bsjTwGT+IjV+82GD/RmhZk8AAOLDOiQ/d8P6GMYyoOUkgslq2aRv4cYQDbiVT3crjg2wkYAxTfX0jpeR5Rr++xnTRbzDYjTWcLMAATk69uEGhWwfcDBNuJC+rj8wiBLecgVOsn89I5kwkWE05ZhYV9OAlX9p+06eEZKL8zfxf8WFoYfGHsI6LaU5EGGHWikPtZTsGKGGtCDuxUVcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB8242.namprd12.prod.outlook.com (2603:10b6:930:77::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 13:13:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 13:13:50 +0000
Date: Wed, 1 Apr 2026 10:13:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/dma: Always allow DMA-FQ when iommupt provides the
 iommu_domain
Message-ID: <20260401131349.GA310919@nvidia.com>
References: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
 <ce5c6be3-0a59-498b-ac0d-eb0dbc1530f6@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce5c6be3-0a59-498b-ac0d-eb0dbc1530f6@arm.com>
X-ClientProxiedBy: BL1P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: d33afc36-2a78-4109-4f7d-08de8ff0843f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3Anptb4QqgFm+JYXUyhAU8BDCw+IM2ijKsdBPI/MqboaP6I2Or73qEuBDXot3wFViCRlirHKO4Ku57exXu/qXtEkW8e4Q1BNO3xF7IXqGWCJRH/F3mQUqZICN/4sNTEvzSe36OsJ2hqPjO4Ut3vuEjhTEv/G9wIz7Mlb+/jOvnfGlG6NX3KOEOnnH6cfv77HqPonQkN87bg2AiqEpAwSJCqSQaIFoR3xRumo2gKfPX9GeHyNW4pl1x74VTKWLTonh1om1DE+1iSQBC9v/zTbAJQLlW+4iNHDlFSla0+Rr9lalbx6ckGW4GAED49BmCN/A1ZBtufYGaPYpJY6IhuRa3eqrG1s5Ir85Y7QVJ2p7dB/YW3d60v9JeMW797+9qOiYGPYAO1/BSwj7p2EBImQidLklg1qXrSl8jRluSUqC9RZE3uAdkldMsNbDP0bvrRP/V4oVihMqkAE3AcLzkechlt1PcTr+ofngReWvCm/rR6lQrcFwXfODK/TdXwYNmhBkwmtObZnObJcxtzGo62VxQ6iNXeiPT/uzFzi3GouSYgnaEeinoOClGjweERSOztcdpnWDFwNtQlf1zPUMciWNL/8vidYkvZIophGhtC7yFFhPubPj4GHeVrlP6iTbi4ptsDnfyVZS+FFH61qgCW+2hykJCyRWnnqSbTuvDlLbabS3UhxswMEYxgw3903trjGtjHAPWEAkUBGv29z/BI42tsQ2Hk1W762f3xYYtPFG38=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?roAxOOlzbGjIgG+FrkaK3mo7Kd+hbrNEtCG9ZbXbW94ITFt3AsryC8macd/C?=
 =?us-ascii?Q?relqauVRAlTechJVuRksOZY+TjCsWtROis63/27fxGwVSm1n7AA39j8foVod?=
 =?us-ascii?Q?K12zfTnE1nzwbooxRMToptw/+h2bsOjZDvJ5KOnTNdcQR4rnmE6kD1sToOcz?=
 =?us-ascii?Q?iGnrxVHgwTacgQZTJYkJzWYMAqxCePfH7m+HjuSBKkwygmEeYpEwS7eMYz60?=
 =?us-ascii?Q?9EuLKGXEaAgCwW5OfTICiAublYY9+eFjhudc7i4oQfqKeH1mpuTQiQGxWfj8?=
 =?us-ascii?Q?z7x/xn52SyrzoL0uuY+fi7J+g2bdvizw8cvb9AoKCWdX/9KL9O4jVw1Jk3Wr?=
 =?us-ascii?Q?GRpeqy4/gWrhjypOZbMQroxfbN/hE9eyziFd8lOy2+ZpcDkUEptUlwHu19EM?=
 =?us-ascii?Q?NMND8lNYf9Yv99D0/vB0O7nOvBgkTnxY8CMtINVZ4gqjYvSPqmQAsFuoXuQ7?=
 =?us-ascii?Q?OWFvNvJICK0NUi3TFtJ37r5g8tEPCf5l1zUNi8v4UdZlDQCJBiAPEphebtjg?=
 =?us-ascii?Q?VXIWKKCJXF/RBd60LoJ3pXtEWpe0pI6JR+mvO+a02Wd4mwejc2PWqCbblv0T?=
 =?us-ascii?Q?MnPnGShPWAijvSqMuLI8nh2ZWMLcV31tm0vedx0W/I+neGvmDOhsu+Iw28ZN?=
 =?us-ascii?Q?X4TLtBDTbZJIE+4O5C6rXC3wuaJZKxNt5GPc5EBDT31dNz6lsNQjBZ28ApFE?=
 =?us-ascii?Q?wQg1TYP1BtxeqKvN3XdDVbtLahflPrWjXj6aJ0tEuprovLvuU9u4wtTfd5wu?=
 =?us-ascii?Q?9ubJVscVYYn0aG6ChUZRR7pF/Q8JBkig40qiht90IyyRBtGD43Nus1kMP2+d?=
 =?us-ascii?Q?CPbRVlmHdIlJ2NXZxguusEWvLPo1m29Szl8tYHOcDgGQ9X2b6UxW11TbU3DQ?=
 =?us-ascii?Q?8G84L92Q/oA3ZVQlLCA+ZIKlRx35trG8tiwvgyEcqP4x4cj8ENMouAxc1N51?=
 =?us-ascii?Q?XGcHO7Et+DbaSYgOQAk0VpT4dwtH4cLieYGCSJuX7vW7kPMVC5PlPTd4HQ7D?=
 =?us-ascii?Q?aPyHnnvvkAbVjFD5PLw7dzuDfrDC5DirqJQ8SH0+VVWTAsUSAxRGvc6Jq/jw?=
 =?us-ascii?Q?14BE3HiQGNgXj1vwXzmHhOfhyIU4BJBI40ab+sQ64tPpMZeWc0K2uHVuaVbW?=
 =?us-ascii?Q?IAbKrZL7eW1HG7hB2rAtVUX1JLHES2NUISRs3FzpOATUSR2boYyUDAle8LRH?=
 =?us-ascii?Q?zTwmw6po1vTSYWk46y3tPhcxwoHeyGDlOjki7bLOuRhd34BpjSR/l/Xh52DF?=
 =?us-ascii?Q?uhd2Na1eQ5DRs1ca92YDFPNYJ5ROtTmc3WnXPltlWCPOEGaqE4Hhn0/94D6C?=
 =?us-ascii?Q?AcDn0wihHaTC8De49gUGPSergpIhGQAvMhKWpmG3Ud3NWMRymJ0vdEB6Kp9y?=
 =?us-ascii?Q?ojcZSQEKQfIWrBNLliqb95bRE5wWaw5EhhNZS+qJO3aPFmyhENvMo+Q4Krxu?=
 =?us-ascii?Q?oB7/nR6GZc7upCvthtxBPmXPtUVi3eCjh+kGVJysu/LerzLkE4wzKPFplMbU?=
 =?us-ascii?Q?sRcugMrZCyouBPAgos96QzJLkmazLwxZLxWvfn/Ay2IbI+nrIuzYyH49zTYv?=
 =?us-ascii?Q?ebcNogjhEPYd4vU8tVsXsw8DMuYnPFNAOLWptsVY1EVzsJmw0FXdv5ltjvff?=
 =?us-ascii?Q?MqkXINHehpyYBVNltZfB0O45aY8QhP60rKXGdx9z1kmU/h/KanBQHfJGrBeE?=
 =?us-ascii?Q?FrYaWOdIMyeceRhCB7uqeso8CknAyU7E2UVDumumFeIgD5FK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d33afc36-2a78-4109-4f7d-08de8ff0843f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 13:13:50.8245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnpbBpfE7JKW+a3XralJg6hYcY7lFg+0+2ang+GQfyRnQW2Gj15cSFNOde25eXwx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8242

On Wed, Apr 01, 2026 at 01:53:05PM +0100, Robin Murphy wrote:
> On 2026-03-26 7:30 pm, Jason Gunthorpe wrote:
> > iommupt always supports the semantics required for DMA-FQ, when drivers
> > are converted to use it they automatically get support.
> > 
> > Detect iommpt directly instead of using IOMMU_CAP_DEFERRED_FLUSH and
> > remove IOMMU_CAP_DEFERRED_FLUSH from converted drivers.
> > 
> > This will also enable DMA-FQ on RISC-V.
> 
> I'd much prefer to just add the cap to the RISC-V driver so it's obvious,
> rather than deliberately introduce a fiddly inconsistency. Besides, having
> iommu-dma poke directly at driver-specific internal implementation details
> seems exactly the kind of layering violation you're normally the first to
> object to.

I don't view it as a "driver-specific internal" - generic pt is part
of the core API surface. It is fine to have it and the core code be
coupled together. So I don't like bouncing through the driver to get
information the core already has direct access to...

Like the map/unmap flow run differently now for generic pt and I think
we will keep building things in. My intention is that generic pt will
be mandatory to access certain new features and functions.

But I don't care so much, we can't eliminate IOMMU_CAP_DEFERRED_FLUSH
entirely, this would have just contained it to the para-virt drivers
that can never use generic pt.

> Note that IOMMU_CAP_CACHE_COHERENCY is also arguably a property of
> generic_pt, in as much as all its users are default-coherent with
> IOMMU_CACHE implied, but again RISC_V doesn't report that where AMD and
> Intel do.

Hmm.. Currently generic_pt doesn't have any idea if IOMMU_CACHE is
supported and working in HW. All the implemented formats ignore
IOMMU_CACHE entirely, they use IOMMU_MMIO to build any any non-caching
PTE.

SMMUv3 will be unlike the other three and needs
IOMMU_CAP_CACHE_COHERENCY.  IDK if ARM should be writing non-caching
PTEs for non-coherent DMA, it doesn't now..

RISCV does seem to have some gap here.

Jason
