Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012020.outbound.protection.outlook.com [52.101.53.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310473624D4;
	Mon, 30 Mar 2026 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774884697; cv=fail; b=ef4lWkb4jdcI77nqeLZkV8rI85fWDzSLV6TApPgEr7A7Zbw7HwMC3YzDF90JQShcSzjQOjZkrOfSBENTFxVya38lh0eOM1AZkRAAgWdLnUsuyIbaGDxp7Rb8ygILhCegy1o9bLXltT4SrxRF5MDcwb4vegnWORuEtUNqm/eRxH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774884697; c=relaxed/simple;
	bh=lr5CBRazs/SHnZmXs5cHJBLg/RD63iUvHMv7pvrWv70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hQojFgQs8hels7y4caj5+YTqf8bR1tVr/CVOc4Db0trg+qKXG3+7z0Xj4D048lL/MAnnqIhP9qDO9y6o1TdTJlsWDv0PBvESJ0q5DfYWevXUkKctSGn38jr4ndyyj32mtBan8N01wXSubxczCoITzNGXMC6oMyhJtsMXryu5+PQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=on1R1PpT; arc=fail smtp.client-ip=52.101.53.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="on1R1PpT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yt/G+RKI8p+3M8pbnqqP7AcVdTSD/faiGAMWOI6KW+3aGnAAiOs/AqDuMPC/02eiTd2+e9n2S9YRbNMPXiHMFYR/e3lK2tdaHl+jltIKbPNnJBd05w1soc4oSE2bSEwPDGXBvt/iOz7dw9CkrRzaHyqWEdf1yb5yxYEYNIPvBH9MWafclL0S6WKwPrTe3ony+L5cyJpJ/hnGQmreDI+GDF3/v7eGl4Pl4ReuafoPfVQxWmv05dG0CGWvPtercki13JS5wEtCCaA34bty87dXLQs+Mu4FDZL79gLJfZ2melp72qCNCTT+802XIVnpbdoA0XEiiYsdpXC9/ZYF/AQ/iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hdb0xqIv8KV1ncFhGaYqGVJSyjuDc+Skqs2vuVVmOn8=;
 b=ByHnF7W31TPt/ZBZ4ecOGFQ+40vOjctCpUr9eTCpfsNAF4wNcVJ2Jpxy4wBpqzLHdjOa1szXcVTzmdSyS+OF++UdwB/NH2IfNv6kdMdAKhY9JlBK5ohfhdFyYpzcrsiERZDRKp/TypV8w8wqCxdB1XBtfB3FxD1uVouwVLDlCMWm//6y8imOXn9oeOYnNy08VWUQGXrjqRjDXZ4fS/HK1V2XKQR2UKQ+TjmCeB0taAKgt3D0Gku+ejEpXmPa9gTiuwc7fJE2hPkZ+mEz4IstgAUVtXUdbO7KETDNdTJDHmJB0FlIJt560w/nft92pqQk7NjNA1hlsfNXeNPSyZo6zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hdb0xqIv8KV1ncFhGaYqGVJSyjuDc+Skqs2vuVVmOn8=;
 b=on1R1PpTF+Xvin+bNp7SFY/gH2QAwemznGR1r9nIX2uh1FEalIGCfBpHZZOF1sDlYHxNvmVUk+fyzFfIIVIOHVN+mk7oIr1V6CJAsqSn3u/4y3Y7zn7SI5OYWNCryQbHCyd9vWDmqCZgKjuYQ/qkM+Mv2a7RdZ/2CDZqwGQ9I8IEatoV0xmEtCEtJEAFl9YqG192HP7O66Rcd7g9OiGgl0RCvY80lQosw5roxTen/c5qMfYf96Fe9opysGR/W4zClgJmpyEm3eS7ZDE4UYCjQ+QLc2k2iJQG73yNTzPi+peBEC3MIrZT1oiueTTJvSmVS+dlo12bK2Q1pa0BRJAGww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9692.namprd12.prod.outlook.com (2603:10b6:408:295::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 15:31:28 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.014; Mon, 30 Mar 2026
 15:31:27 +0000
Date: Mon, 30 Mar 2026 12:31:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/4] iommu/intel: Split piotlb invalidation into range
 and all
Message-ID: <20260330153126.GU310919@nvidia.com>
References: <1-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
 <ef82f6be-fecf-469b-9df0-88a7a004923a@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef82f6be-fecf-469b-9df0-88a7a004923a@linux.intel.com>
X-ClientProxiedBy: BLAP220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV8PR12MB9692:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb79f97-c5c4-433b-bda4-08de8e7168c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VMooq8pM5PAJc7POvJ70ZTeQeeLrtRoWJj7mtNP7RztW2E4GgG0eTzV+3Wfm9C9xHwc/Vk/SOwC6+Gs/MLHd4J7gWZqlUutOI2a4Igi+r6+JXfSAOD7gxrLDt6Ycsgk8+b81e0PU7ZCK5s0NnDD33kMuOm8wpHXygOReOh1Qxxo4C9bBzQQjNE6bXG+zG00n05LOcSyKK8QBqu98VoEtqI5C36/xyiJw1vt4iI/23VXNa9KqMGY2XVYhEmanFTOFvIBCXCSxoq2zHq1kUEFv7pSjRBFxnM7ehhF38bxkBR8PaX7xKdjqRonIhnlj4XLm+JPdkL7b7l9c/epqhPKWCM4paSIhjukSgVsaJyktRGPwSuUgjyBTqti702Z/GjwWE2hWosAYoYwKueaCNsG6BHMlOP+T1gJmVkfm+Ack1rMDPu6TrqLoIBes/1pJocySxTflC5yBd/bGIFRflUW4vBWqAnSQpt2DDPgLC0kG53fcBFeeyHhf9wJrz02Ehx1HFE7rikcDAM/3BTwSBHrSPcJHJlEzcwx9BwBjYve5+wqchn9SwYH5FI/gdlyqUjNC6ZgnZMaslLa6o9P6p5SQ+JmFM39rTIOiqjO8xbS+ejeHSixSuwPa4D6OiQy9Uk++6lORiM1V3gaFd/0FedVUHu0OKn2TCEo9lJWvI7/TfTaWuY6wBXAj+j8JjOeZmMvQbuGXiO835xXk9ZRMJMf4GcBSCSIWUVkkg//OO4OKyRw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NIQQMxO0mGGLRgTX4hcl9eSxUxduClZsvHrG/z5yBNTwFXEs95MSo/+3gUpv?=
 =?us-ascii?Q?ZCw/VoQqUTNEBNo/c1ki/FZtpZ5n+RPGuJ/Q2YCKncoW1IxZMxec+qlgTtYt?=
 =?us-ascii?Q?aBCH9tz862icSJpJKTP1Pt81+7lSjF1pWVqztO4EwW0UwQbTdDsmPg/TXo1x?=
 =?us-ascii?Q?89HJOVlh1RlZm3OnXA0I1N3ADJpyHCMxHiLSltPx7mmCjsmfTvHG2FRJzWsU?=
 =?us-ascii?Q?MhJHesga/n4yqwemEv2P3JsNLDs/scTDWrIG61ODvqNpKISuEGLs//iNN3A7?=
 =?us-ascii?Q?x1Lw5BlWMd/YvN7m5CM++NauOJDxpwU5c3xErULOFbNheiWg/uwnZvrOuWOb?=
 =?us-ascii?Q?oJE4WWhGljFWBZ2XSo0j2C/+I1g51FwAb6QzkYR+i5YnncJF+x94NwCxVJHt?=
 =?us-ascii?Q?hGJ+dd6PYkUk7yTY18ZslIwOnwJ/8AOSI5xt86ykwsRenknaBYx1YZccj2PW?=
 =?us-ascii?Q?oSpltrw3Oer4r1nqHT7f2wPkp2FE99RZ1PvHTqSvvMSnwwqEegqjB0bwVeGz?=
 =?us-ascii?Q?9aKsLAag5niO50VkIYsjn5bJMpwrOtzOSOTjx/rHOHTboGgpmp/Iyp6inCO+?=
 =?us-ascii?Q?6SguFeQwnPCBFq29QB8m2N/LOTG5d4cxphOkz7JdIlcwW9XGMN/UL4ta+3HB?=
 =?us-ascii?Q?+4oAGKRojLpNRNmDQTHjb4zxLHGPu4TThOh8blEgjbUB3penCEQYHkGQTWtA?=
 =?us-ascii?Q?Qt4mKTy6ARamdQ9EX3mKDTxdiy/Pc8YK58jPdDSZJz7G+MI1cK9Wja4el4+2?=
 =?us-ascii?Q?LSgAZCDw9yxf9eW2up4GMdUnSp1lT30y3nZ23UMECPcPUAellGNuJFVuRLt4?=
 =?us-ascii?Q?dVwU7JLShhKLig5lihFZ6+MVw1h/S7jVRGNu83o+UoquQ7bLrDuzcdX4ITBc?=
 =?us-ascii?Q?YSxV8iZTH/IJcJQknLyDNeSuRt6tnuq+7vpbKNZvgSVlQ4Gf9aKShWzMJNi5?=
 =?us-ascii?Q?7K+Y2qtoZcDAgfO+1zYqdm52U0XiqQI+fJZ75AmL3W2DDqwVBnoSM0zxJkgq?=
 =?us-ascii?Q?agKOUxr3MMp9/W1k5Za74rFxoPqP2OV6DwjYqAbm7qmJfp0ksH8dZq+GZDNT?=
 =?us-ascii?Q?fGDSKU7liMRx3o2C8EFNu+iQNso0tMtqErMdXd62NTp8xxdWPhJqRBZ33Oge?=
 =?us-ascii?Q?9F3BzUGC6BTolnjRawIr2ldzhWDqoKw4oCBKGaaA8jvxbJBX4DqMzIhED4eN?=
 =?us-ascii?Q?X7lt732CtYJ7EUDFpvGYA6wPBdrvXOZTJ/d5276Y6JJi3uV3WhY8P3VRw0Wy?=
 =?us-ascii?Q?0Qv4bvVu7T5CpLG5kqHnAmd6gTOfqsi3+1eCC6LkMltEhg9ZyDHiX9YkKxkZ?=
 =?us-ascii?Q?U+gjT0BNFp1kkSPPMrlamVUPlg7u+YMv6qGvUVO/vdF5QiMUPxYLKN/mn3Xt?=
 =?us-ascii?Q?dBBy8cawuLxylu9yR7snef+DIxdFmahzl9wx3QCOvOixsWcJGED/whHuaMnR?=
 =?us-ascii?Q?/SVZSe/SWm1X6Ur0iDhzph7UvybGiYOR1TQQMZQPuxZu2d25LV8dng+lJ5zw?=
 =?us-ascii?Q?tiTUICTId+dfQAAJM/g4wwIkEZd+xSQkJCZ11u+xDShon3Q5hI7+pK+Jhplo?=
 =?us-ascii?Q?lr1CpMextEI/DBvRD8VUEvFowzul9I2Z9V+tN+GJUqWGBCH8tVNyn0U2eriM?=
 =?us-ascii?Q?oN9AoOKSg6kE2xqmFHiUFaMM9ke1/8Rh1DEOt3i/ZnKLpbGFPWorGYgawQlh?=
 =?us-ascii?Q?oHI5kEqVX/4i1Y9vgIIc3xQwd8AqQUFPKSMxjqkb+jKJcKbg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb79f97-c5c4-433b-bda4-08de8e7168c4
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 15:31:27.5182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cEZM1BUBtInPT2XxFteXWpnuJTfYV53bLyoWE6qiespQ1Xgyg7KzcdGLtUx/J4Mm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9692

On Mon, Mar 30, 2026 at 02:39:50PM +0800, Baolu Lu wrote:
> >   static void qi_batch_add_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid,
> >   				u64 addr, unsigned long npages, bool ih,
> >   				struct qi_batch *batch)
> >   {
> > -	/*
> > -	 * npages == -1 means a PASID-selective invalidation, otherwise,
> > -	 * a positive value for Page-selective-within-PASID invalidation.
> > -	 * 0 is not a valid input.
> > -	 */
> >   	if (!npages)
> >   		return;
> 
> The WARN_ON(!npages) logic is removed from the previous
> qi_flush_piotlb() (see below ...). Could it be added here to keep the
> "npages != 0" check?

The later patches remove this check entirely so I don't think we
should add a WARN_ON then remove it again..

> > @@ -1168,6 +1166,7 @@ void qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
> >   void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
> >   			u16 qdep, u64 addr, unsigned mask);
> > +void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid);
> 
> [...]
> 
> >   void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
> >   		     unsigned long npages, bool ih);
> 
> qi_flush_piotlb() has been removed by this patch. Therefore above
> declaration should also be cleaned.

Ooops that hunk got into a later patch, I shifted it back

Thanks,
Jason
