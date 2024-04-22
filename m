Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19537150982;
	Mon, 22 Apr 2024 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713793930; cv=fail; b=OMmhBFJzad/84GK8a52KWhagr07CMIczj3/3b+RFthRgqef9xjT+N9val9BtGXHPZhieUGUsa70VDX8OcmmLSFiNg5lr43KPHrqRoG6N0CKIorhZDfiPO2MzBc5dgFnTTxmFJikbcpEgDt9Fkmkxi9Jiq2SxTuHcMgenkKjvnM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713793930; c=relaxed/simple;
	bh=5XKZJtEjz5ViM1ZKOIyFcqZeEmudp2gpbuDFSldgLFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fKeglraBpKYVDWtsCVQ8Am2dcahIr1pnCLh3THswEq/I3A5xwswOuzxnwOKo4Q2Mn9rQU99G7gdMDqRrbw3XzALe90EHQas8Tp8NqbXWkyQaMMuAfqowux7wUeUvFWFoCSJNYAiWNqV3rIoEzaAcCoroTJ4rCQ1m47THBs3d57w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pqBaNgTs; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pqBaNgTs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrLPCdAuPsncJvwRCrzvIY/p42uECG6mEwvJ0lGRspE2xynGb8UjVh9ysvKTEjtQmOBvu23M+Ao6TLIPaODuQnmURb3obWiilKTZH4hICCbTlMYycZyYgbYxHPCsnyK3zPlBZdJg5QTeUhnrPtlxK7Kn+hANHpBmreS2t6GAwz4AGZc0693WO0YPl+BjtpPJACteSE3ud3e5A4OZBSiGiT0eBsVm72K5TBvs7of32SXlNfUkn98VhA0/c5aanpW8eyWESvBoM2QUS3ftrHo4zqIochzFpt+Hpm5socajXrnXt4ewzGYZ0SzxMuPC3WUbhB9nC4mmf0HV4RGpvph47Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ykzdVki+3aj6IFPlzVIliFKweNJ0EIfdRKtmPVmc/4=;
 b=l47Z1IPo5OYdi0bVD9/ZqaZMLc0Hd60FuxiZveWuu1xmbhyTC9DTHWipqFDfKdGxy9j+qIZhPH168X5pKDGOkCy/R/HHPYSVz4AHunV2rqPsBCXt40XivLgZg2oXtqY49kk+orEGoJrtHO11AXjiYVI4nt/zJXLAqSptgUFuTRgBjYNO33M0JWuXWifVuiV9iYxZ2QhZkwO9VQs9cdYi/4fgnvtUA6Y6a/ayQOwtUaRTHYI5mRzFaN9BKOFX0C1eNUwCQsFv+N1ODlCpgPVgGrdQTUZ0ksK/rLhYG9pj3qXIafp78rZKSaZuW3itfWZq4GidF+UB7IxQz8TxSNA6WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ykzdVki+3aj6IFPlzVIliFKweNJ0EIfdRKtmPVmc/4=;
 b=pqBaNgTs56akxO9Bfiaz01OuOBBS97GLW6m1hsQdpvFyfZC0QQsIlz2IRVmvGrJxbL8e0xO2GwT1+FPqC+bMf/XVu5qtPocOnJfmAvrjDgMY3mt04ZquZZcYWRbm9MjwvQPrjvmT/guexg02qye0KsgMFquZLSlop/e8Nmw0XNmgYX5tGlJSi6Eadazw5vsqnIqBanffYrHsJB0ouSX/y8LqvUoX8IiwERj/HaSri7j7KtHKVspan7c+fLfLy84FiZ4wWG228aYZ7XBnTPz6oMccIBTcTtimYKpy+tbTSGlNVXPjoQHo1SxhFOGK2t4QGpWhNBComG5ti/t0qjOtJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 13:52:05 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 13:52:05 +0000
Date: Mon, 22 Apr 2024 10:52:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 3/9] iommu/arm-smmu-v3: Move the CD generation for S1
 domains into a function
Message-ID: <20240422135204.GC49823@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <3-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLd45atbrZ6hBtL@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZiLd45atbrZ6hBtL@google.com>
X-ClientProxiedBy: BL1PR13CA0408.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA0PR12MB4464:EE_
X-MS-Office365-Filtering-Correlation-Id: 096b9294-51d0-412b-9b4c-08dc62d364e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yk9rT2lUOVMyam5OY21YOXBocjlYMXVXdFpPdkJjd2RDNEhiN053elFuUzhK?=
 =?utf-8?B?N0dXNXdlM05sOUFGeGlEWitMSUNvWmxNV0RTSndxZDNxZVFlUG1iYzFqQXZE?=
 =?utf-8?B?MmEydlozZ2kzdDBXeFRwWUtXempPMHQ1NHhjeFExUWVGNjdyT1Z5SFRoTVI1?=
 =?utf-8?B?ODlrcHRRNm1sUm1wbGRpZlhlUWNGUW16WTZyTUV2NzgraW5mOTZkcy85aFRl?=
 =?utf-8?B?SGw4RWFZdHhHUnVEUXhCTWcvc29lVnMza1ZLWDk4ZkZLeUtMNy9DTUlNNGhy?=
 =?utf-8?B?Q0srOG9EMTMycGhBbWFmKy83L1NWZHFpb2pHdUM3OTRDcG13NDNIckhVV21B?=
 =?utf-8?B?ekorMllLbTJWNWJBWlhtZmdyR1dGbWdibEd4MkEvQjcxS0E5ZEx2ZEFZRVpD?=
 =?utf-8?B?VzB5UVJ4YnA4NCtYb0QzaGhrdk1lNnRWRUdJWEd2MDl5ci9hajRYc2JiVFFH?=
 =?utf-8?B?UVdmT3ZZbFdzQkgrRnJDaTJBWHR5TEtYMC9BUjRnZE5yMW1UT2UrQXZvSXYz?=
 =?utf-8?B?RG5HN3RzSmFsS3l4MzFkZmtkc2RiSHJ2WHJYMENTY2h6M0hnclk0YmpmclJN?=
 =?utf-8?B?VlVyVWFSR2VyV2VtTUUrVFBrY1pxenZaZXlPYVl4a2VFSzVicm0zaStJTDht?=
 =?utf-8?B?VTlOd2VubzdneFVVcUFaT1B1bUtkSzVaR1JocmJHTEd3clJya0t4cEkrRDhH?=
 =?utf-8?B?SlVmajcvbnpqYWRMeWdFOW1idVorQm00OUlxcTlTTHRycU9EdU1TOWRmQ0JS?=
 =?utf-8?B?WXBYbEFxTkVaNnNLWG1xRWZ3RzNjcjdyK2lLZCtXNjJmWkhGZkF5WE1zdmZT?=
 =?utf-8?B?d0c3U3RrYVpzRmpUbnNIcWRFSFptKzhUMDdvcFQ5ODdTcVdsaW9ZdmVodHk0?=
 =?utf-8?B?L3dSM2JJUEwzdUpIdzU1M0ZOUnNHZkRScmpjVC9WMlRMRzFPYkZtUkpTRWtN?=
 =?utf-8?B?MmpCY0V5OFg2eEVzU1JvR0MwSytBUnZxZTdXYXpDR25IbTVjZmxVa0ltZ3FM?=
 =?utf-8?B?OFNBcFF5UFZhTHdpejUrOWxaaldWRDVUVjJ2U0UvbWdvZGluNUhzaVNKeFF4?=
 =?utf-8?B?SHE2ZWxGbXJjKzFJanh5dmJ5RVp4S2JRTGQySS84bnVtVWs4SmRKeFlvUkRm?=
 =?utf-8?B?UlU1Y2lkRzdBTUNSNjcrS0FJT201UlVXelM1Y05XZ2ZvVFc2dHYrRXhaUTFF?=
 =?utf-8?B?OE9WQXljLzltL0dvSERXZ0pBMDBkSWNsbTl3RDNTd1lUWnpjdC9IOUdFV3kr?=
 =?utf-8?B?UTZ3UVNsMVBqNGlXMVA3WGwzRzhlZzhwa05yTEF3Uk10a1RrdWJ0ek5MMzNh?=
 =?utf-8?B?RGxkeHV3SkpJRHdKbklXQTlSWlE0dExiRXdNOGwrbjAxaUMrMGorL0tHVEh6?=
 =?utf-8?B?YU9pWUgyMUlublQyd1VWektJQzBNUTdydUdLVWhtVU9yN0tkOFpsVVRjMmY0?=
 =?utf-8?B?S2N5a3FjdUNQT1ZIRHMzV2NtTFI5bjA5MnU1TWFtSlQzZjI0bkFkb0Q4elJi?=
 =?utf-8?B?MVM1cEVkcnFTZzVLQ24vK2QyelFUeUlFRGt4Nmc5WXM3blp0MHZrM2JSamhS?=
 =?utf-8?B?c3QvcHFnVVdjbE5zRDJrOXJRV2RHY2ltK2RFRFYxZzF1SUw4ZGZEenhaTHJp?=
 =?utf-8?B?bU94NlZTU2QwbWVNd1FQdDloSkxTNVM1ZXNqYXJBOWVETXpBZEhiSldZSk1o?=
 =?utf-8?B?RW9mTFVNOHlhMXE3TGNTUUlHbmJCZjU3YUh3RGRiR1BXQjZEUE1nY1dBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qkt3SkxBdkFsNW9pcDMzaUdMNFdtbWx3aVhLZEx2L1VCcXN0SzVSeXJSZVdG?=
 =?utf-8?B?RzFyWEVJbGJtaWZ2czhXdTZjeFhucVM4WVNwbUc0TXZsa0c2a0h6bUtEK25Y?=
 =?utf-8?B?UmxkSmkzUnRNajZsdjBoL0VJS3FGMmlxcVcrRW1PRkt3a3Vaa2I0T09NNkxV?=
 =?utf-8?B?L2h5eWVxSXVzTmp5SXRmSGkyY09wc2RxODExVjZiaStIOWRVQVdpekFCV0dt?=
 =?utf-8?B?R0JZb1c2VHA3MWRoa05FQkExQjBYT1VIeDVNL0NxazJ4RVBPWmhGYUVnMm9I?=
 =?utf-8?B?QjJtZ1JuUzFWRWdnVzJSalhyMitYZy84WEZJdnpjTmlDR3lHUXFDbnNmRUN6?=
 =?utf-8?B?Um5laVRmZmRYdzY0ZHdoRmkveDJVcElHbHIxZU52anBSb1h0cUtPamZoV1c0?=
 =?utf-8?B?Vm9aNmdiZGRwTHJvaVZYTGkxaDdhbHp6MXVYRVZLMDZaUzB5anNwMGN4QS8w?=
 =?utf-8?B?TlpUNDN6aTJ4c1NUeU52M3A3UldjTWlIU1BaN29BM3FIQXkrSHBOOS92dEZs?=
 =?utf-8?B?bzRKdlU0RVZCUDZiSURraGxEbkxSWEpPczBOOWM3bkRxeDc1VFErbWZWOERO?=
 =?utf-8?B?dy91ak1ZZUFGTHUzUXdvMFBSMzJnQXdKVTNhODVtTXhsQjhWOHdldzVzRFpD?=
 =?utf-8?B?azV5SzNsRFRzT3psUUxrb1dGbTdiNSsvaU1tNHNBTzNpYXdmTlEvbXh3Zmkw?=
 =?utf-8?B?VWk4RGp4YTVJdmhTZ3VZaDBXTlZJUmZneWdzZ0g2SGFabVRURXRmclFVU2R2?=
 =?utf-8?B?SHdWZCtWNlk2aGFTa21Eb3I0enl3bmxmK3g5ci8wRG1kYkR3c25jMzF4Qjg3?=
 =?utf-8?B?UWRubUtCNXBNNGRQR1RVa242eWpVMnlNVG5wZE1oSWZkaFRYYTlOc0p6M3JN?=
 =?utf-8?B?VVR6Q3g4bWY0OUJ3K0hUWEV2WTlIcEVUNy9IWU5BY2FkUDN3L3huRTZESElG?=
 =?utf-8?B?emJrbjJZcjlOVmZieU5uT2p5T0VWb2gxVTE1MFZJVFdUK2NpcUNQcG03NGNl?=
 =?utf-8?B?bXRWQkpNaVhyM0xFTmx6N2hMMTF3bnAvUUJnSTJjZllLeERQWDNBbnBzWCtk?=
 =?utf-8?B?SGJSeVRWZnAvSUo5QzZiWExEaytVb2tDelBnUkZjQWZMVkw4N0NMMEhnK0Rv?=
 =?utf-8?B?YWQvV0E2R1phRjMwOXRkUDRKTlJ2bmFhVUp5aThvdnVMQXAwRWJXT1U3Wk80?=
 =?utf-8?B?V0ZZejJnbUVwYmFZTVlJUDM2VGIzcm1XMDhnNHViR1h2S3JwdWw0bnF6U2pN?=
 =?utf-8?B?ZHpxOGNMNmI5RDB5Y1ZmdWt2dGszSTEzRUVFY3k2SEV6OHcwV1hMbHFUR1Bu?=
 =?utf-8?B?bnhiYVVZdjdxbEhRc3k3Ymp5MkZ5dUVBcGdaamRoeENqQXgrSWc1bkdkdFNS?=
 =?utf-8?B?ODZ2YVpOUFozekZQNjYzZmNEQlVBZTNQUnZhbjdFRHhMd2J5dEpTcExTNnhF?=
 =?utf-8?B?cFIyOVZKZlJyM0pEWUExRlREQ1Y4NFZRV0xGdGFTMXFuOE51UGhtWlptWS9Z?=
 =?utf-8?B?amNLUVhHcnVqRk1aVzlFT2dUdVU2VU56aHorQWh5VVRtUCtOK2l2U3p3WXRj?=
 =?utf-8?B?ZGNKQlNseVgwY3BmMG9HUFJkL2Rjd2pERWx5SFJuOGVjeDBlV1RJdTIxejFw?=
 =?utf-8?B?WFhEd0UzaHA3dmxRTHFpNmtJWndYNDhQYjlWZDd5RDhHdU9uTEFGc3Z0akt1?=
 =?utf-8?B?WWVMbHI3OE02b0VCOUszMEVRZmR4ZUlDRmFjUXNITFluR3lzNS9IMU85VGpx?=
 =?utf-8?B?a2dvdGNpMkNJaFdqYzRMVGZNQmZPbVNnWEpHaUllRWlaVVZNMFRIdzY1TnRL?=
 =?utf-8?B?ZG91T2JjT0FlZGt2Z1lWTnVaYXlQZTBiT1ZZMmhnSEcxaVlUc0RzMjhTR2hC?=
 =?utf-8?B?TmNPdmdSVE1sc1lpdTFkQ3FLK2sxalVQSSs1aTlJY2c4Qi95S2ZUM0xYQmxC?=
 =?utf-8?B?R1ZVRzc3NXRJTUhkczlTNU55TU1mTWZkQ2sxcUlVYlhsNTU5SlJYMHhZZHpL?=
 =?utf-8?B?TWRSYkZHYW9VUHNscnMzaTU1c3pqcmhaZzFpeGFyMW15TS8zQzQwWmM1Zmxj?=
 =?utf-8?B?Y2NsZ04xK2grUmQzUG1OZitIdEVPTW1EMUlYejVDZFdtbWpOMWNxRlhST0Rk?=
 =?utf-8?Q?NO9gIkMgLQkztioJ2+vz5YQGC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096b9294-51d0-412b-9b4c-08dc62d364e4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 13:52:05.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1LEAm8S+p0BjA8LYp8C2SEl28SM3xSV7k1/J09ax8sNZUjsJ9MljndBAWrr7Uwr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464

On Fri, Apr 19, 2024 at 09:10:59PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Apr 16, 2024 at 04:28:14PM -0300, Jason Gunthorpe wrote:
> > Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
> > and reorganize all the places programming S1 domain CD table entries to
> > call it.
> > 
> > Split arm_smmu_update_s1_domain_cd_entry() from
> > arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
> > chain separate from the unrelated SVA path.
> > 
> > arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
> > attached to RIDs and refreshes all their CDs.
> > 
> > Remove the forced clear of the CD during S1 domain attach,
> > arm_smmu_write_cd_entry() will do this automatically if necessary.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Reviewed-by: Michael Shavit <mshavit@google.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++
> >  3 files changed, 76 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index 41b44baef15e80..d159f60480935e 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -53,6 +53,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
> >  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> >  }
> >  
> > +static void
> > +arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
> 
> nit: shouldn’t that be arm_smmu_update_sva_domain_cd_entry?

No, that actually was my same confusion too when I was first looking
at this. The logic updates a *S1* domain's CD, it doesn't touch a SVA
CD or a SVA domain.

It actually has nothing to do with SVA, this is part of BTM support to
change the ASID in already programmed S1 domains.

> > +{
> > +	struct arm_smmu_master *master;
> > +	struct arm_smmu_cd target_cd;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> > +	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> > +		struct arm_smmu_cd *cdptr;
> > +
> > +		/* S1 domains only support RID attachment right now */
> > +		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> > +		if (WARN_ON(!cdptr))
> > +			continue;
> > +
> > +		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> > +		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> > +					&target_cd);
> 
> Case ARM_SMMU_DOMAIN_S1 has the some code:
>   arm_smmu_get_cd_pter => arm_smmu_make_s1_cd => arm_smmu_write_cd_entry
> I’d prefer if that was abstracted with the SMMUv3 driver and it provides a higher
> level API rather than exposing these low-level functions in the header file.
> But no strong opinion.

It is only slightly the same now, and it will keep getting more
different as the patches progress. For instance "Make
arm_smmu_alloc_cd_ptr()" makes them call different alloc functions.

Later on this code will handle a SSID too.

I don't think of those functions as a lower level API, ptr/make/write
is the API design. We have different versions of each of those
functions. The call site needs to string together the right sequence
of three operations for its specific context.

At the end this is an atomic context working on S1 domains with SSID -
there isn't another case exactly like this.

> > +void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> > +			 struct arm_smmu_master *master,
> > +			 struct arm_smmu_domain *smmu_domain)
> > +{
> > +	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
> > +
> > +	memset(target, 0, sizeof(*target));
> > +
> > +	target->data[0] = cpu_to_le64(
> > +		cd->tcr |
> > +#ifdef __BIG_ENDIAN
> > +		CTXDESC_CD_0_ENDI |
> > +#endif
> > +		CTXDESC_CD_0_V |
> > +		CTXDESC_CD_0_AA64 |
> > +		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> > +		CTXDESC_CD_0_R |
> > +		CTXDESC_CD_0_A |
> > +		CTXDESC_CD_0_ASET |
> > +		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
> > +		);
> > +
> > +	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
> > +	target->data[3] = cpu_to_le64(cd->mair);
> > +}
> > +
> 
> IMO, patches to handle CD = NULL and quiet CD should be introduced first so it is
> easier to follow as now there is duplicate code in arm_smmu_write_ctx_desc() which
> is dead and makes it a little harder to review, but if reordered,
> arm_smmu_write_ctx_desc() can be removed in this patch so we can see how code moved.

arm_smmu_write_ctx_desc() can't be removed until all of S1, clear, SVA
and quiet_cd are converted. No matter what order you pick there will
be some weirdness.

The duplicate code "(1) and (2)" is also still being used for the SVA
domains, it is not unused until patch "Move the CD generation for SVA
into a function".

The only dead code here is the ASID change. So I'll brung this hunk forward:

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1328,14 +1328,11 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
         *
         * (1) Install primary CD, for normal DMA traffic (SSID = IOMMU_NO_PASID = 0).
         * (2) Install a secondary CD, for SID+SSID traffic.
-        * (3) Update ASID of a CD. Atomically write the first 64 bits of the
-        *     CD, then invalidate the old entry and mappings.
         * (4) Quiesce the context without clearing the valid bit. Disable
         *     translation, and ignore any translation fault.
         * (5) Remove a secondary CD.
         */
        u64 val;
-       bool cd_live;
        struct arm_smmu_cd target;
        struct arm_smmu_cd *cdptr = &target;
        struct arm_smmu_cd *cd_table_entry;
@@ -1351,7 +1348,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 
        target = *cd_table_entry;
        val = le64_to_cpu(cdptr->data[0]);
-       cd_live = !!(val & CTXDESC_CD_0_V);
 
        if (!cd) { /* (5) */
                val = 0;
@@ -1359,13 +1355,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
                if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
                        val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
                val |= CTXDESC_CD_0_TCR_EPD0;
-       } else if (cd_live) { /* (3) */
-               val &= ~CTXDESC_CD_0_ASID;
-               val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
-               /*
-                * Until CD+TLB invalidation, both ASIDs may be used for tagging
-                * this substream's traffic
-                */
        } else { /* (1) and (2) */
                cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
                cdptr->data[2] = 0;

> Otherwise:
> Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Jason
