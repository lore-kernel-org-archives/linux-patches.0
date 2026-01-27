Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011034.outbound.protection.outlook.com [52.101.62.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1DC35D603;
	Tue, 27 Jan 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526534; cv=fail; b=ncLRDwCFHrYD1AbKsTSD7QKdx33l7MqO5se/jgm1otIL+U6iy/e0TLHHCqgJqlHEXewdHfqzlNM4WUqFFB1+eh6Qgik0OkziLmeaPD+iw2enx8Q4LxBlSn2kWZinIAspHrJm0U0AcgD5gBfUH7Gr5Lhtf+chBk2uAp/GtUC1adA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526534; c=relaxed/simple;
	bh=SwnWduOXt09xzKf7PWdo1m2GkkSr7s9Ubb3V+2ujdyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kACLDC3oj1o737dVa9oUGPOtF1RoPxJfJRU36OBW4AanOwZpOiyfK5tt7yzp6nV7hZeXMvWXrEOYfRpPjYxZtmow16mNXGrYmDxRsJNxJHWcnPwFsBN2Okx5nqzKMNqNEOif8L/FIYdkhoAIpTtaCVhcIuF9ghLntW/eu6mtc1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bRVAUYIF; arc=fail smtp.client-ip=52.101.62.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bRVAUYIF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDSdALs5MNrR+bm4hNY+fhoXzLwF/caKUYdcxpUkcvcKQy50zldwIWPCflJKNGJFqqQPB8xC9IDEEx3poa/Fx/xll0grcuq4e9GpAtcCPd7eYFfY2jnJgpC8zppC89uHdgCHhYUDyOxO7m9cQOhr4oxOQD8ohPGYIRohctzijPDP5bVgJ8GbnnNNMXVrMFJyYJinQp168ACm9ZGq3T94F88KZxDlVcy+06UlwvUJm3rOxuDjVI9zpaZQ274NaclBg7CmTHtpCJRQdRMhEAgoZ0zO/ib20t342lHVdnxpBiRWE/NByo0nigzGyZEk3fnDV+96D2i3ote6S/0TkZIG8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2babtF7ooebO14DpKN8o4x/SKFLxlPlN7o39up2dbM=;
 b=MuKG5/Z9PiCTrTuKLfjfhVWFtkIHvotLnFaWM0CNYlXQKxCtI363nJ2ZFO5vYbrtYkZu+MmfMro9JnImwIuFrL/SD0CoN2KAQaaYOlNIW9mDXepuPevff9xiEDFPfUuESN5FjKQPkrUZxIKks09rr3YJUcSYvI9I+TSYHoaNBRuLOjx1dwHQl52BkTPKjd44mgMN23oZcha9/nFs8wMX+lqVVwrrG/h6cmWuZcV+nE0n2uvpKDGU6ZnjiBIzoOb3j+MxHL2txCPU9eDXJuhQGW8Jh4SynPfTgWWH9vwUdeytxoRNURhuKl513INSa5p0wKn92UygXkWWCgqKMcHjrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2babtF7ooebO14DpKN8o4x/SKFLxlPlN7o39up2dbM=;
 b=bRVAUYIFiHpGJEyxo9/CvL3ULro/aLAJv/7ekDfEWU8ZN+RjLozZOY5FxICHR9xWQBK0/3hYs76PNrDww0CVgC/q1Pf+eFa7pqAPw/A5tjc0K1MIzGmzN10XSu0TQm/LkJ3/NeOXL32wN1LNtxdKr3g0zyd/nAteZRTr8synRa6JUVs+punNExJCwgiA2k9sJbdTaPgqbuT53n6yOQFqaiEQTuhMv3DJNLR4SrnKrrKwPpVl2cz3HwdniVLMEQfKolpuBM4fd3XpAWtpxgxsisvzpe/jh0UK307abi8+ELeVHe5KNKUBq8CYt+nYMoKGP3l79DjeG1WqLz2gsMHn3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB6688.namprd12.prod.outlook.com (2603:10b6:a03:47d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 15:08:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 15:08:49 +0000
Date: Tue, 27 Jan 2026 11:08:48 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 01/10] iommu/arm-smmu-v3: Store IOTLB cache tags in
 struct arm_smmu_attach_state
Message-ID: <20260127150848.GG1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <40ecdf7e0766004c5d3a4bd086cb22cf08254237.1769044718.git.nicolinc@nvidia.com>
 <20260126204443.GX1134360@nvidia.com>
 <aXgvzoPJDej7HEAm@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXgvzoPJDej7HEAm@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR20CA0058.namprd20.prod.outlook.com
 (2603:10b6:208:235::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca0508a-236d-4319-1645-08de5db5f96b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dKIbAJ9Tqm0B/eItRFvU1MO4A6SVV+lEBb5GYnDwuXUrBm0Q/rtWnaqi+tdX?=
 =?us-ascii?Q?YeEM9bMGMhnQItZpg7VCd/pzA/LmvD4AqHWcFQ74GAEoCmQiRMcPHyU7exCu?=
 =?us-ascii?Q?Ia/RznMIiqMJ60JscodHhwg75Ri+I0dpbyXzYUxnSXS0uDEwjXQuGOiHstnc?=
 =?us-ascii?Q?zOz/SxQqpVyL4vzCNZxLCfgXstk7uMscgx+Ifn6WJ35ycGuOMVd7lz4pG2d7?=
 =?us-ascii?Q?XW7vhid1WvKWJr+VHZTFG6chHQUP0jZT+luJONgrvhU7TErIOtBrwHJZjZ2g?=
 =?us-ascii?Q?4eoKuaBZCr2SpRRUNORzQ+c7WlOv89kpLF9vxc90GKxCuT7QTHwIvyRSQzw/?=
 =?us-ascii?Q?FF/5/aMGRsxzwlBQZySMLu9t/N5ZaVlbBHm6+RsxlNPtFWGnLtEzF5yClNnr?=
 =?us-ascii?Q?B9XeFGHuJHQD6Bi56UwmiZdKo86VR1a+ITP42if+UeOkgqQeeNMAxxG2yui1?=
 =?us-ascii?Q?eDi7YSTYx8oC7LvXdX/S9c4MvHyrowizfMMaPrZD+39jpaynSgvi0YOUnhua?=
 =?us-ascii?Q?7tw7nioZ6brnwDKWIWuG/rasC6Ffdr0tbrd1471zgj3XE5BKRGK4DRWqBRNr?=
 =?us-ascii?Q?upgf1FznAsOVe6YR01L8YF1uQCIGFBswbWVsf8szdpvtmDv/M6JRINV1BIqU?=
 =?us-ascii?Q?kHRxaaKUaBZEm8D5fNC8rbHDiytd8VjGMSfu6UedWEXiE7ZVBWKmwRzuET4B?=
 =?us-ascii?Q?KyWw/Psjyy5uq9ibJtstXwdKe8DVb3p/Qea0wKTTuj0X8eLXy7qmqasqVuEv?=
 =?us-ascii?Q?5/jxvXr2s2T418FPTVn7RhJYfPGxJSACRmeAqbLH3xHHJaiC9BVEuwzh4kuM?=
 =?us-ascii?Q?GBKQs/3mJpFxExRPtIArGMVZo3rsmm1qVNc7MPA77GxVfsJ5TBR0hs+/tCyW?=
 =?us-ascii?Q?ILkjV1XFo7zho4vyQfh/M35ei7g4m+Pm+E0SOj+Z/Dar2j6JgYLwKUgR6MyR?=
 =?us-ascii?Q?b86dxFPu2dHEgsPLme1Ig30E8jZaeqDnZKUjTTkoqhvKRZCrFc3lQtMUYFWh?=
 =?us-ascii?Q?vtVXV5CrOgm7w/jtY9lU1LB+opvV1QV3RsIg1INQ+p0X+oPDabDRGDUSBZrt?=
 =?us-ascii?Q?Mhj5evioKNhNvODLD3SgA7HiTOEyJs/nWbDqZso+6Npg8U5yshtMzEfTSP7H?=
 =?us-ascii?Q?xBC5bMByEcN1GObDyScel/kNYSvU6eLwlSLzGwB4w7TsBRg/E+or+HeBvNIi?=
 =?us-ascii?Q?svtLDOwOuK87Nw1hUjW0v59ZYyfmUPfnyYwSqGLJVnFQBfC3P6LwRRIBeSUw?=
 =?us-ascii?Q?v0v08Rm4MdKqumIiMQIMXKBsX6ycE3evsXYQgyd6CeFXgkvlXbk2jDT40fDW?=
 =?us-ascii?Q?U3tzoIBJZ4rCAztcpzjgsufK95augyT1zpz3AZnu+OBwCLUrwT4g6hyxTdcu?=
 =?us-ascii?Q?840/fo0VtSoi+cRJtU07K106cgtCHxgspbkMobhZrPwH3mcvVWvKsbhPNMK6?=
 =?us-ascii?Q?CLMeJWa+3JUYAqlnxjD/KjbWgedW02Q5dz5+HvnKIhaExdoMAMwNOlhBEals?=
 =?us-ascii?Q?7yopkZJYG8fVEKxt1hiLhFellc6YbmJZi8q+x09KB9+UprJE9IEs4KmRYVsU?=
 =?us-ascii?Q?4EeJHKKYfnnhmMK8xE4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3k3wH4xRizlMlj+7o/pfB13snwy95qXOR3Yt+36vrEx6FZGpyKESyDA3quIm?=
 =?us-ascii?Q?YY0pif4yxo2ufooefQnNPZRmFZF/TzVLWhBtjxH9Gg2hkiphVS1fgBOD3GHo?=
 =?us-ascii?Q?NZZ/T84yzZWt+kX5DWtnSd1FImICWtofgBXVYWf7b12Iqy64mzmejDRqC2vH?=
 =?us-ascii?Q?QhJdLAaM8t7/WFZtC2FbRJRLGtDlWBcrRDzn0mxmFgls4A6EniBvUYf95egU?=
 =?us-ascii?Q?uYpGqTEyxBsl/Vsqc75qVviKIgxRDltB6hlId8ii6+oKg4/FDaaPtgaL/usR?=
 =?us-ascii?Q?aMyCN5Lq5VdA6jO//llVkZnlkoFQMarRQ6MAjrgm8nHUi2lqDhnzyYPtqcVk?=
 =?us-ascii?Q?W2vyqbiNPsdPFuppn0SexbtAtTsA+Ew4mh2ftVYRnFSncskpKQnpfxYTE5Ec?=
 =?us-ascii?Q?rwwOUo+VLB9vzLgxvMLw/DC509gQ0uvUPB4Kjh18yniU0xox1Lav1PpMlQQT?=
 =?us-ascii?Q?APz4Nbb6bi6UAHausSCwp/irv3+KJcc053wjG6HQLzfBevzSTHd8Oh7Ry8kq?=
 =?us-ascii?Q?i+zSugiF73fi0DzP/uxB12lMiLPFOqW6/mCNE0IvNJ3WVoAsCXK9J0bmSi5T?=
 =?us-ascii?Q?jku10bn9uOMe+/N0wGzsYWNVYc/Egukc18XxuEpmcve0gyMrbY5MR7j0x1yJ?=
 =?us-ascii?Q?fOcFi/Bz2tyTstPt23hB2auFrgxNO4pjApni6aJnxxVTiMb6+mSFqjk8RVIo?=
 =?us-ascii?Q?iZ2ZL3imouscU7zNpAURby/M2gdhHjBhWkFC3NnO+72+HNJwzUxuIwsrPkI1?=
 =?us-ascii?Q?qqv39GE2B8PmIHjuNNn4zximamBI7TWUZpj/HkWi+nusLwy9g7MQBpVk05Gz?=
 =?us-ascii?Q?rERTBfkgRRrsYfF3wzcEc84cD8FtwgLjBoJWwqtYQS/yjVNgMTCTdl39mYkK?=
 =?us-ascii?Q?Tm5C1Rw8mXyFkK9vTbbTHViYejyQTPyMsmAe7ly2V7Lgr9rrz+wBHlQj8BCo?=
 =?us-ascii?Q?ciep938ch0rpgml8RY0RVVmoDFBLDD7gpjentbnBLcBXCc4Yt6VM/DQou9Qg?=
 =?us-ascii?Q?L8zO7VSCn/zxjj/ShQQmd3chPsx0iiylxmbsYclGKW/Q6bwGbgdpRP8hN0YH?=
 =?us-ascii?Q?pruteXzZLQHuqrx+AOw5pP0SrO2UUQj9suCfdZJBcqLp/i7iS9k0igQNSaa+?=
 =?us-ascii?Q?/w2FfeYu7f1resiJfSEPdftQ4j9d1H3D7PvdBFsbqfSFb6kiw9w8I/yUFwC3?=
 =?us-ascii?Q?rFZ2PdZ9jNKa+SSQMgYGn+lNmP62UcbJAEHyh5slAYix7eBftWbp6rJKk9IA?=
 =?us-ascii?Q?40fra0qp7mFaI/+TNm4RJIaf452uFfZxoehY7BM3yaN+ll6KG12zD9JNpllo?=
 =?us-ascii?Q?c3mPb7YBI1VRYADi26xGWC7rBeZX6b2QVnfxpsYV56u5fqqej1nn/fLED2K5?=
 =?us-ascii?Q?kzzGWGtU2jBz8oAMR3m8zWyt7Afw0z5qgEHcfMnwy0VQekPcxcUkmZw6l1XJ?=
 =?us-ascii?Q?GAR0I2ZbfjFDtn70MRZGGwkFC3Rco5J55Ca0nKfDhtyq7Z56GkGfnjsST0gL?=
 =?us-ascii?Q?WaojkuOcgl4j/AQZRgkS4UTpIqETWFh+1RpZcQLJlI59ukkGSEqWWw3oBPYr?=
 =?us-ascii?Q?APsrmZrlsw7OdW/jXuAniMzk3ULfve/mWWEx1THgHdA9j9HY8lsM4njlAsp1?=
 =?us-ascii?Q?N6fArvTxgdQ9lTvWAwon3gvG44gbVlKMtMRShGcLmA/YZ/ecxCmdmX90N8i0?=
 =?us-ascii?Q?y2jFFsuIHiu/8EFvgCcxZQKvX0t9Z8oyp2hhhuBnKQ3zGnCx/CszbkWRQxJa?=
 =?us-ascii?Q?35AECejAkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca0508a-236d-4319-1645-08de5db5f96b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 15:08:48.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MV4sDnOlfiHkQmwguxtNconuHm5amEIIYlXvJ8bu9b+2CT6QpUe7oWaxmS5iguJc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6688

On Mon, Jan 26, 2026 at 07:23:58PM -0800, Nicolin Chen wrote:
> On Mon, Jan 26, 2026 at 04:44:43PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 21, 2026 at 05:24:19PM -0800, Nicolin Chen wrote:
> > > +int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
> > > +				  struct arm_smmu_device *smmu,
> > > +				  struct arm_smmu_inv *tag)
> > > +{
> > > +	/* Decide the type of the iotlb cache tag */
> > > +	switch (smmu_domain->stage) {
> > > +	case ARM_SMMU_DOMAIN_SVA:
> > > +	case ARM_SMMU_DOMAIN_S1:
> > > +		tag->type = INV_TYPE_S1_ASID;
> > > +		break;
> > > +	case ARM_SMMU_DOMAIN_S2:
> > > +		tag->type = INV_TYPE_S2_VMID;
> > > +		break;
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	tag->smmu = smmu;
> > > +
> > > +	if (tag->type == INV_TYPE_S1_ASID)
> > > +		tag->id = smmu_domain->cd.asid;
> > > +	else
> > > +		tag->id = smmu_domain->s2_cfg.vmid;
> > 
> > Would be tidier to move these up into the case
> 
> This will act as a fake allocation path in PATCh-3 and eventually
> get replaced with a real allocation piece in PATCH-4. So, I wrote
> like this in a transitory manner.

I'd still write it in the nice way, you can remove the lines later
when you add the allocation logic.

Jason
