Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0BB12C53C;
	Mon, 25 Mar 2024 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711376496; cv=fail; b=BkdO19+tj9JdDTd85XLQm92yW0qt2Zn3Flm0ry2ooP0MqRZeKB8TgZx7ZyZfbluSV1zabZhASFinGTG5jbTYM9kY59JUpr85K5xro2GNWThY28fPnDFz96t2S4ACKHNHEVwvBkh8m9h8eXeZ6N66Qfl51/lCDrt/GaIP1MXJpFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711376496; c=relaxed/simple;
	bh=RAqI2qksyAhWBL9Kv+mp8RMmDRTZl5bnkBBPQMypAdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XPr6s9KmnwNrKql6Wh6lGXTTAtptIo0aW01EpRaArC3SeDdwQNReXo4p3f+AeJHQ2901pmwxcAzrx1vtPHxS3ZdWmfUCmckqSwUt8FvIrlAfnHsNZIURWWbcZJ/d825dqyp/18HQgs1LscfIN64LHtRZY2xcT4H6pcnrQVQnPrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l8BgL81A; arc=fail smtp.client-ip=40.107.101.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l8BgL81A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+l4AAgHC4WLKGk6OU0SkTdmeAK1k2tqBgkYupND/td1m38Ib1RfDUEZi1AWswsl75tb5EqF91xECPYsX71CNGg0z3EEVUPy3/JmmCsvM6YMqbFHJhUmkK9X53jHsIiTCF4IYMFROhVqC7iMenMh3KAljoTgTkpyK9XPsGcbLUMEmJUjmDz7rNEqnD3lVR0fgLktdrg8XlYrnij7jP+SQG0IwH78XICR+qZOFKU5kc5HQoFcmyXENREuo0BBlghWr6kCxTiDxvSSCm37oVykFNn5EfAEN9o2PToZ/8s6ZkhHetbZbjR6/jYeZqAH7vZVbwTCxDR8etQ2aL/jHLEYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+6spG5pikvNTn8dlzpydH7REIFQrsX/zVczuuBEDEI=;
 b=SSgTa4cG4N9hhfcqcm79P5/b/vgCsh5gyPnwcMlJqtXD3grLzaM2RiHGX5LWEKBurHO5mEmoElFnGQTHQPKJDyTgHOybilvA7wymdvyxxsXdR7ponYkpOjYM6G1P+eACoBKnqepUQ7Aq8XBVFvwpsVPcZHy8pYNw3JZ0zt3Np1gWcRvZOCjvSsN73KK5mZQeykx2HJ+30frIONRoC1RDrzAf72zLZoYGO68VcT5jsc61KtrVfyyeLdBkOif6p/NkqCL9j/SJdTFSO9r5CsmmhpCBf5mgm33Aai1nZD6k253Ew1BH71owtdwxiLSHhkA3GccssJz4y8iUn4d0UOjhCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+6spG5pikvNTn8dlzpydH7REIFQrsX/zVczuuBEDEI=;
 b=l8BgL81Ap1sK6l1nTi3SHM9s58MzT9Y0ueoMe5vlRIkUiDCM1QpPFJWPalzBRTfLiG9RGyRzPZnJpXY5yf2rsIFKJfA0aEeYTCYRRmw+UBInlG6byaXjLv/TW6PMItgGVzpjJLIK+3yU/MGnpbFgbTxOgGMBQhf1dbISOntv9p0kMRBZLTjTs0DiDHNDBJRwVEWtKstcJUiphpCBJ++u4Ray0iGhpoZw2nyPPpFwJOyBShmWDr9oMHICmH1hjRUdenSlb9Ia5KO8lweW9VVO/t145RJvifB0Z2G1Jx1JI8EbdlJz7YCIpKA+kjigpzL6s40SS/yKi9dZoF/X9Cg2Dw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV2PR12MB5894.namprd12.prod.outlook.com (2603:10b6:408:174::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 14:21:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 14:21:30 +0000
Date: Mon, 25 Mar 2024 11:21:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 08/27] iommu/arm-smmu-v3: Move allocation of the
 cdtable into arm_smmu_get_cd_ptr()
Message-ID: <20240325142128.GC110546@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf3W3lo8dXZuKbgm@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zf3W3lo8dXZuKbgm@google.com>
X-ClientProxiedBy: BL0PR02CA0075.namprd02.prod.outlook.com
 (2603:10b6:208:51::16) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV2PR12MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: afb07227-07b0-4fbf-2c1c-08dc4cd6dd42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a0658QwjMWQJ6Qo5JJF0O8tzdA+/ZUffHiWBncrEww7vwyMEgztEC0D6X49bAvJNINfEG4VTSYHBjTLES8T7UdoHTW65hRMCcg/Mq7zd58NhIIAnD9xvh7K5ZK5Hv//I1CWEeIY0YNLaCuhTMoujLPtlWabzPMzfHms1H6Q93u902a1/GYjR5gMIjepvPeXcuufIrPMQZE5mE+APQJCEf6hGynjT3ilQkr73fQeE4IzfF9Hm2rntDpM99Hnli5v/Nagoplq8SATO7uyWgpkVkCHxHuYzGq344qp8b2odvyMZiaYJVVJeQcAa1n5cNYT3Xox2O6RA0HYs2eA6qAcK1sxZB/HX55AFS+0psDOzoVTJlWuJfBTao+a2ZIlVMLpeIWrRIvIPW6ECctFRpLu7YTtDF2YfyW681yTSgNK/Ca9nqkR4qeO+npDIrquRX6DkQL0hwrWw14PULOQLJxoFwmPkcJ5EzXhOaMxNqvi+w1Jf2Cssbk5KaghNBJ4nDCjNKeG3CYb+kGw0T27cWs+5QvoE7zUTLldiBOuJ8VIxfEeF9RHTCDeGDXNozwVJapgz2AkqtkICO4eVpC4oZXxobpvzXEBH3KwmJ/wAqW9SuxmtBz4/b7HGih/Nc++LI0J4vhfMVP45z46gxF9mX5SZUtFDaitD2g7UlXirybPLgvg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0xtRFMycmZLSnFObnQvSk9jLzFXcGZMbkFidk5hOEpzTWxlMnUyZmIrb2JZ?=
 =?utf-8?B?aVpyc2x4bGFvNzBJNndIMlhXUWFQRWpzNFdSU2ZkeXcwMlJLVlQvL2VXSXZY?=
 =?utf-8?B?VEFaTWo0Rno5anZYZUZteUNDVS9xa1Y5T2FkU0xka0t5TStwbGloZCtJWXhv?=
 =?utf-8?B?TENYejhaZjNWNW1jOXorSUlocUhUazBrcUpZeFp3VXE2Sjd3QzNYY1pEbzJU?=
 =?utf-8?B?SEpLOUczcXFNbU8zQzdpTlFaU2N4OEJiTEtRWUU5akVycjRRWnlhNFBpNllu?=
 =?utf-8?B?Y3A1endjcmlydnp2RVQ0VGRaWDZBYWp2VFhRM3duWkRBTkU3b1Evc2tWRVBu?=
 =?utf-8?B?Mk9OT3R2SU5QZ0dxM3pPaFhqbjNlL25zb0VrL3pvQlZpSnAyQnB0QWlmaXdB?=
 =?utf-8?B?TjJISTJ0RndjLzdRMHRscTlLdlQ3Mmd6dmxxbjZ0T1BJRFpqTVpNUFIxNlVt?=
 =?utf-8?B?SEhaRDBEZFFrQ1hVdFoveGZwTmxFdmxtUVhGc05UR3BELzd3a3BjTXlrQndt?=
 =?utf-8?B?MGdEcXdPbTVLS29sUXFpRlBQRDZSdUx1T1M2UFI2TmhFcGhDalJJbFlJcGwy?=
 =?utf-8?B?emx3YTdWSE1LRFRVU1ZYUHNPcWJyV2x4bjBlTXBUeTAycXdLb0s0QjR1aXRr?=
 =?utf-8?B?K0dJdjVvYlNJYmFUTmxwbTRmUmhwV2wvMU50MUxaV3lGcWlOT0JOZGI1RUlG?=
 =?utf-8?B?MUgzY2NZRFNoaW5KbXVRS1Avd3RTN21Lbk1mM1BKK1Vkc1kySVFIWG5vV2Js?=
 =?utf-8?B?Z3czcW1pdXQ2QVp1SnF1WVJUOGlDSjBnY0VlUEZJRWpIODc2ZUFvK0RPYU1k?=
 =?utf-8?B?d3MvOHRlZGhUeFR2VXhiYzJZWEl5bnpMeGhwb3kwbDZjM3Jwd2JSb1dlRGx1?=
 =?utf-8?B?d0lrZU1WZnNBL05PREluZ3lwNnV5TXNhMjZFSmxMVmJJbU91RXNkYm1RWFJ2?=
 =?utf-8?B?aVlzOXBHMUhWNzJoRk1nY01WVExuRktxc3R2a2ZMQWpQSG14Z3lzclRMMjBx?=
 =?utf-8?B?c05sLzdrOG9QNk1QbFdrYm1lbWFhcHFQdml5NGZ6cGNsekl1RGlBUjF5Qmk1?=
 =?utf-8?B?OXdDa05SY1lCcXJobzg0YXgzNFVEangzbHFiMHVrZGxKMmRlNERxbys5MHFl?=
 =?utf-8?B?Z2dwbUxhUE5aRTVCNGRXMDh1ZjV3RmdvN0ZFemdzNDZRMGt0eWxGektEdTZN?=
 =?utf-8?B?bVdIalQwUkJ2ODhESlI3L21ucXo1REd0ZDYyRXNzd0N4aDk0cTZJQnlUcWov?=
 =?utf-8?B?OWlRUlFMa2pPT1VURlQ5MW9BSjFIN2R2dHQ2Q1R4SmZDQnJqck04RHE0KzU4?=
 =?utf-8?B?dEI5QlZJTzBSRi96UnU5THpWUjBhK3lCWEdFNDhxdXlGblgzUGVSSWZ1T3Qz?=
 =?utf-8?B?ZGpsN0sxc25vZGJLa1Ara0RKeEZPcnh6V1JvUm5iSDU0OEpjOERsdGFNSUt2?=
 =?utf-8?B?dngwc3U2QnBrQXFCVWNlQmY5L2RNaXhFekJkb0w5T3lnaHRnbVYwQWRRdWFS?=
 =?utf-8?B?VkF0OFRWUFdQZjFhaHNRR3liOGlPS1piU0lCQUVZQ2hOT0NnanVTc3FhaUQx?=
 =?utf-8?B?cHJRUzliWHI3by9GM3YvMGRlb2FGWld1Sm43RVFHTjZvWURvQUttcTNjbnBr?=
 =?utf-8?B?WFBrZ2ZNMkdGeUJuZWI0Y3M2MjROQ0xEazZKUWc0VEk4TWd1djJJRWFydDV6?=
 =?utf-8?B?SG9oTVFyRTd6SXJLMUpreThobFR3V3RQMnZ1Z1gwT25uMC9NZ1c3YlY3YzFV?=
 =?utf-8?B?OU5GMnFnQjRIWGJubjRuVW5EcDYxLzBxYXN1d1RCN0VQbTVzL2lsdlg3c3NY?=
 =?utf-8?B?WkJKSUFsQnVqNTMzNXUwM29DNmpDYVFoWGdGUXl6K2daNjgyZlFwQmF0aWZN?=
 =?utf-8?B?V1VoZ1IzdTJKUEppRTJqbjAxTlZqYlZCQStpNWlCTnNRZWYwQ2YweFQxc3Zk?=
 =?utf-8?B?SHQrSGVlSDJsQUMwZkJXVHVyK2pwL1Z1dkVuY2JJcFBYek1IcnZGS1Y1VFZN?=
 =?utf-8?B?Qno3K2xwcnBlK2dzRmpWdzRUV2ZDZzBsSlFacEtXTERvY243LzVvOXRlRkJj?=
 =?utf-8?B?a3c3Qm96NVhwNnJaU09YTkdmZGd2RW5DNlJ6WXVsQVExMG00MGZLYUdtSlJ4?=
 =?utf-8?Q?bTYzQf1AifPD7Vh+zsnR87/vk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afb07227-07b0-4fbf-2c1c-08dc4cd6dd42
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 14:21:29.9621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zc/OFCYVuUcZBmD68icrYVm3mwg4zQz5IJX5IWIc5LFOv9lNwqR3O9mXygWlwBqg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5894

On Fri, Mar 22, 2024 at 07:07:10PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Mon, Mar 04, 2024 at 07:43:56PM -0400, Jason Gunthorpe wrote:
> > No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
> > able to return an entry in all cases except OOM
>
> I believe the current code is more clear, as it is explicit about which path
> is expected to allocate.

I think we had this allocate vs no allocate discussion before on
something else..

It would be good to make *full* allocate/noallocate variants of
get_cd_ptr() and the cases that must never allocate call the no
allocate variation. There are some issues with GFP_KERNEL/ATOMIC that
are a bit hard to understand as well.

This is a bigger issue than just the cd_table, as even the leafs
should not allocate.

> As there are many callers for arm_smmu_get_cd_ptr() directly and indirectly,
> and it read-modify-writes the cdtable, it would be a pain to debug not
> knowing which one could allocate, and this patch only abstracts one
> allocating call, so it is not much code less.

> For example, (again I don’t know much about SVA) I think there might be a
> race condition as follows:
> arm_smmu_attach_dev
> 	arm_smmu_domain_finalise() => set domain stage
> 	[....]
> 	arm_smmu_get_cd_ptr() => RMW master->cd_table
> 
> arm_smmu_sva_set_dev_pasid
> 	__arm_smmu_sva_bind
> 		Check stage is valid
> 		[...]
> 		arm_smmu_write_ctx_desc
> 			arm_smmu_get_cd_ptr => RMW master->cd_table
> 
> If this path is true though, I guess the in current code, we would need some
> barriers in arm_smmu_get_cd_ptr(), arm_smmu_get_cd_ptr()

Both of those functions are called under the group mutex held by the
core code.

The only valid condition to change the CD table backing memory is when
the group mutex is held. We now have iommu_group_mutex_assert() so an
alloc/noalloc split can call that test on the alloc side which is
motivation enough to do it, IMHO.

I will split the function and sort it all out, but I will still
integrate the cd_table allocation into the allocating version of
get_cd_ptr().

Thanks,
Jason
