Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086513F0AA3;
	Thu,  2 Apr 2026 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775148697; cv=fail; b=Xz+MY9P8GQQlgav16Mhklc9zqZMS/MG+XVRW0biAsJqFZdy03a7L2n2x7pyBaPVXGtPV/B7TB93IzOGETZGUnJpt/XrELiqZPNUthbf54+zEh3PZNhmia5qXJugl/QgaAfL/ZcuczdDuVTvgjLRc6CSecfJEFJdhpmtDOyehstg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775148697; c=relaxed/simple;
	bh=5wVxDKSI8dIeJDQd13lwYInamtzVRF476Ri78XCc2BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Fov7cJgnXv6FuaPbM/7xONtUFlBd+8dc/eE3XzRVFqz6gg/92nXnG3/mAOqU74DQPJ4sZGpacXJhhCxDCh5HPKNSUn3JDqVQidPd6ymA+ESZ/+5PFG+ue99SJK2BoF53TjaVMFULDboanAe3W6rmM+vPZxObtNi/zelh/fPikqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fQDyJAqS; arc=fail smtp.client-ip=52.101.201.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fQDyJAqS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YxVgv/a5FBKUEMGOwAyZZQ+/9ATFx1rxCHbK2fXsszMd9I/Oz6wFdYMxcbYVQtn6EiB/jPzdYvI+48gmNFm8xJmpGwW3sIPfr48J4p4SIsyz7E+sVJ2/exJaZ2RSqmV0NyFyU75LNGqT37xZZOU4xBcUZ470ocPBo15lmjphKmUBei4RtYQSsWTiDlFbVg94oV8joP+XdJ+yDL247JUk6rRgka4NZ1tAf2R1x1DRbw92b4LZsXLxrSXkWAYWGfDvVXF7lHyrmIJNawZ3TCMszvGZlUULsKlGjI5DinhIRcabdSseEKa9eNm3/ecMuHcgD0PyOHwdCtO040OD0U8Czg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBizT6dITzOWs3PxefUJhuMVHGKPHsRS7LDlIgolVHA=;
 b=T2GzLxBtOdF1SM6L0TtHSIZXsj/HYSzYP2UWfIpXDUOgfGbDpXHEV6UD30Yxm1pKG+4WGmD5PIxcRvGKo2WoptfHQYiAIAYKZYpprwqUgAkGACcI6T8ratzPu9IvynuGB0D2SxYMsK6ueGB+ONhe9txfS9Tr81ORwzS7MBJcoqb+kMEGQUgT48nsBoZtMG80TmQqF1oLuHKx+Z3umgdtXzl98FUw8tIm3WJOZd2Nqbli55rzLRSV9Hh12RqOEOrh9t6AP3hKyBvSEuEMf2AYh8b4RQrdT/d3DKDP3Ckvn7cpqwUnB8mAlv/bRiyOqTpZSqrmH9XdnDEkQR3xpozsfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBizT6dITzOWs3PxefUJhuMVHGKPHsRS7LDlIgolVHA=;
 b=fQDyJAqSkJyMHoiYKTaK32SJvdJQCDaUpLB7molXDt67shG25G/IDhdZMnvZBUNJYdR3eqkPuRY45T6410bkmzo5QUud2JAe7GqdT8nVqPalZCO9CjUCOj1lDWp9+y/mc2qxOgBBOPjIpjcxpGQ9MyRjEXyL6MIdbFSymTUTbhzTvnlypWSXvbwF7y2SRmEBU9nKYAPntiYaZaiClSO/iQw0Mf4/titxp/Bm+gy28cgzf7/iMt/uAkTwH4Z8xGgBI4zlnj89tAwNVgHLCOg9Ffm9IOLxNun5+3oqGRPOojh0hEzDYrwpggrJRYtoNWqu1FmXrY4Oxpgw//ZBN2v9fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB7918.namprd12.prod.outlook.com (2603:10b6:a03:4cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 2 Apr
 2026 16:51:25 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.017; Thu, 2 Apr 2026
 16:51:25 +0000
Date: Thu, 2 Apr 2026 13:51:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Neal Gompa <neal@gompa.dev>, Orson Zhai <orsonzhai@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Samuel Holland <samuel@sholland.org>, Sven Peter <sven@kernel.org>,
	virtualization@lists.linux.dev, Chen-Yu Tsai <wens@kernel.org>,
	Will Deacon <will@kernel.org>, Yong Wu <yong.wu@mediatek.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Jon Hunter <jonathanh@nvidia.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v2] iommu: Always fill in gather when unmapping
Message-ID: <20260402165123.GG310919@nvidia.com>
References: <0-v2-b24668f107b2+11bbe-iommu_gather_always_jgg@nvidia.com>
 <70a128f9-d6f0-41b6-8fef-e249c0507149@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70a128f9-d6f0-41b6-8fef-e249c0507149@arm.com>
X-ClientProxiedBy: YT4PR01CA0221.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB7918:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a523e2-26d5-4294-88b9-08de90d8134d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nv3eWcfPVgqpwumndzHvGpmiicpJDjcAupVRIpfFppJ2h7nneXAjiVLiFGyeE4haqMRus50NmE12DLDx17tyEnunLBqV8UmPT4tLbrneF0rT/eAV21uGRn/GuBvUFqUsmC1sqhCpuvVNT7VLjmq/FM+unJaz4ODfhfFYcGFmXhekMU0Mcbv/yhEGWNTLNSCvbJ7dctJLsoFVEHdBAaYo1Bs6sgpibI6hiH5bFCd/wlGalQVwCP4wyYb1ei2oo13wmYFHTl17b5UracBRe/KJXNIw/ytFWpS3PwldMhUm+0lBo4KB8bW+S3I5fcZmmYUeZvcHJLaJ9KS4MiWwcDF1ffU9GmRsKc4FbHh7dNVf14pDCqURXkhcPpiYYTZKBoymIaQwV/S47darmEMQlQppF3EgCRVv/U4t9Ggv4XmG9PRBNekTnIrsGNDRcu/HnnWsMktw3VZw0ChZhv75Py//1uwfnJnLadX6ida5RGFhzBc0dHhkNbV3GR+2Q+4FB1tLQuBL3zWxY5WLrTpsS9AfytOh70B2mAlw8DW3SVk2/E5NanfFOZhhjELsEdMXnfy32biCvThZP6+JZS4Qi2vh3LVAwrd6Njs5hbm9nEkugeB1MWsdxlWfxD7pcv7ZJpiKKpARakWf9ltiPzp8iXJrD8qBQNE8u9YyhYIdJtIEYZyjPDCDuDO7VyIOqk8U9HzmRGwJbnp/EOX3+dh6ZCsUpoaDjukpn3QBshEgQFya3gc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pdbny2mjmDm0DkpF0XzFDwQxA68zQu5QwbhUMLKNfLKme00Sg/a6r5XvOfes?=
 =?us-ascii?Q?im0OPbWN1UvQ8UCgyrT1j12USyPoFHyHs/Fx/SkIj6ApzeE2vWV1X0mud7Y7?=
 =?us-ascii?Q?gR00yHrP1ZyNESt8HjZs3pU6/DWjo1vScfe6Uqo/6lEWzhAdfi16MX1eLVwY?=
 =?us-ascii?Q?cY3L78dmNLtarQb4N3GcnqRcKWxKihxU0wTMkv+kK3oQ/vgaVvW7M1jWmtWC?=
 =?us-ascii?Q?KROIBGArjPls1SzS23QiCEukolq4jRYALAskNgWVw/R05nG8YfwdCbNgQvJ4?=
 =?us-ascii?Q?ZRZeGqgChoLIorgKfx/1KOBOP9maqIY4ZJvPdIaLBsIpBimo76uYfGW4r65O?=
 =?us-ascii?Q?pg5X45F++0cejh5ZeyauVHKAKDZgoJdty7fVH1o+nsDSHFV1IMBsh35Ik5yp?=
 =?us-ascii?Q?CPfY+CLr6MMJTiFwgCiIhp74zNzT7oOFlQVfPiLbVgNWmJNXu+lJq5mfaKp1?=
 =?us-ascii?Q?d2a+5NwxpCL9NQzMrAyFCgY/ryZWc5i1XKfftV+i6ZkkbUKRaa/wE8sUcFRN?=
 =?us-ascii?Q?aQ864kCbB5iIcqsGCV19D6LPwCKxnwzTQJrBk1Ks1oqojGYLTv93qphcevcg?=
 =?us-ascii?Q?YjiDyhigMkpDDmb4oMhOYEKFG/AFgcW8S+QlICtl4oOTJsLqOWlMP9N3HAtg?=
 =?us-ascii?Q?AVSRJU+kQ598+yfbKxAYwDEaHYfBhY8luoV5f5mYbqd0cwMn4gm9iLdyQ7of?=
 =?us-ascii?Q?lYK3yx8mLA8LyOSzgQoHSLGy7jd+WgB1B8Oib5nWd4skxBDFuugYKl4wWnwd?=
 =?us-ascii?Q?Wfa4uMj4YFUPNUdVEGjq2DO5u5wFtoEoCs4bzXsctQoBlR141JLOY0wY+RaB?=
 =?us-ascii?Q?eB1vYcjNHXJ+nPbqAsEUIMQ6DQuu/WAns4gZxNzP2K3OF3oKfkkUnJwvcjrF?=
 =?us-ascii?Q?TPF40m68jGlpJndufvibmvEj25qpctsdic6YdnzTh8nIHRZ5nuGBdWQAQZAz?=
 =?us-ascii?Q?cM9/aYtN4qPo+9JWu0m5OPThky/7gOyUbuZAGkowR/2WsxiUHamuV4llEvHJ?=
 =?us-ascii?Q?FcbqvdqlAALlw7JZxzNyCWtmkzF97aLTsB/NmVzOADgg+A0R/Nw/tW0RhZYC?=
 =?us-ascii?Q?HaXILRGz91th53gEY1KibxpohW7jStXl1RLunTbPtO7984Vu4fwI9rWD0+L1?=
 =?us-ascii?Q?0hO5nrr3RMWn1hw4QzWBrL90bWGoikfu+kZd9e0JMsM/hw13s8qrq2BsqUvD?=
 =?us-ascii?Q?OCDsL5gAf2VX3eXswdqaT4CibT9ZneNWIIdVh4LDenzpLxOVocYa3307kj6P?=
 =?us-ascii?Q?yKyYt4JMfbI8YucN9AI+BywLGCEgrfF5TCNIwOgVtHj1KYHBzwvzE3NfC2CN?=
 =?us-ascii?Q?p0CMEOa7JBS/meGYrMSy9hCtBEsiY5ROZuGYTLXuTNoUleY1ZXS4ES5DCQ8Y?=
 =?us-ascii?Q?wGrb3AgZ1wr1hgu8E6NNJH8ood37t/cEW5jDyZW2e9DQuOWiouGE4TWEWn0v?=
 =?us-ascii?Q?x9zXnl+zijnvb8gCzMxm6t1t66xbtu7RMqfgeVHePsDS8B3YRGPiXmafAeOC?=
 =?us-ascii?Q?g/d09J0jN/Ob9A7Jxl2J/8lFhsTjfAEq+jBct5tsYjyByiSxquBn7AKJHz3a?=
 =?us-ascii?Q?6ZapIxGHhDG/msQYrybHwvI/aWpv9ZBOVWaBaVSB33NRPIiMZZKp81JCNV8t?=
 =?us-ascii?Q?zwj//5BOBrS25GQpRohQKKE3wcpsRz1AJ2w9lVnRUXUhqQxxPF37EsLdD7E0?=
 =?us-ascii?Q?qVrkwoV4aVjNm71KJR9mNtY1xHmbhYD7Kqdf9hQrrxGc+9Vh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a523e2-26d5-4294-88b9-08de90d8134d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 16:51:24.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcdTlflq2fhu3zOHc9hj1v+tRAfHusMO9e0IMxmC8dO1XOBn7eHcnxYH4UWKaoji
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7918

On Thu, Apr 02, 2026 at 04:59:29PM +0100, Robin Murphy wrote:
> > @@ -666,9 +666,22 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
> >   		/* Clear the remaining entries */
> >   		__arm_lpae_clear_pte(ptep, &iop->cfg, i);
> > -		if (gather && !iommu_iotlb_gather_queued(gather))
> > -			for (int j = 0; j < i; j++)
> > -				io_pgtable_tlb_add_page(iop, gather, iova + j * size, size);
> > +		if (gather && !iommu_iotlb_gather_queued(gather)) {
> > +			if (iop->cfg.tlb && iop->cfg.tlb->tlb_add_range) {
> > +				iop->cfg.tlb->tlb_add_range(gather, iova,
> > +							    i * size, size,
> > +							    iop->cookie);
> > +
> > +			} else {
> > +				iommu_iotlb_gather_add_range(gather, iova,
> > +							     i * size);
> > +
> > +				for (int j = 0; j < i; j++)
> > +					io_pgtable_tlb_add_page(iop, gather,
> > +								iova + j * size,
> > +								size);
> > +			}
> > +		}
> 
> NAK, this is insane.

This quite an optimization for SMMUv3 so it doesn't have to fit into
the ill fitting add_page api. What is "insane" here?

> If you'd rather make gathers mandatory for all drivers than fix it in the
> core code, then for goodness' sake just add the trivial one-liner to the
> handful of .unamp_pages implementations which need it, 

Do I understand this right, you want to not touch io-pgtable and
instead the unmap trampolines will fix the gather like mkt is doing?

Jason
