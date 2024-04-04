Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2100.outbound.protection.outlook.com [40.107.220.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6C8128830;
	Thu,  4 Apr 2024 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712239481; cv=fail; b=klhpYjIMBQ6aifZau7izMLA2mblbBC3FhVVaii7FE80v9Mks8NHNx6aXnGrQRUI9BSkZgUbflwKPsB5QdBXrG3+6wtGlBqGsFgF7cw86IqW5bqqtMkaP8m1WSuzCOvS2P+iiJWi050orQkyjo1muFgNpsklunyXqC46STM+b/IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712239481; c=relaxed/simple;
	bh=G4iVHUxbvxXeBLIUZ7BrbjSjL32iplXvGqi5wfxPrE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B1qIXJGBWwZvQNKgPOydQmzy4ZrTZKJ3H6Oj5P+HZnVSzrbICUGmyWUKO8oaSn01WIFOovkO67WxU8cgoQSYiZsyIxBseQ8hDmChV9Syi/1/KG2avyYvjadUw7K0haTNYLo8UbyvuBhJs4hdAEq+8oDCKZyy/0nhZGHwfQMyN4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q02WfX7z; arc=fail smtp.client-ip=40.107.220.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q02WfX7z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnU027/j0h8Yujp/luxHYeHeJCoEsTAnsc//JE19JtgDaVu59vZT0DPEVhu3ZiBa7ElaPdAzZX2Kj//Z6r8EMTuv2UAmvs0YGAjegAQBPuPJ+yUy/fO9OZPsF0mSyDJ/1E+eo9Ova6aerxPrdYXXHIgbp+mFt70bnNLGQ5Xp9i2Dud43YEye1Rt9n+hoILeDB36+KvI/NvUZ4ImA4rhvIn3y08eQ6P9EVj0ctoH62YFkIn7jxc6+KcitPxfNv32Xvs4520Gf44GbZTazMhMyWokgjb9WPFKav9pE6hySkmqY7KI9HONRNxX3WxU/0Ne19WGOcbD9GRrA6NNFT493AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXsSpobf2poXOLILtez9/LHBEzVXaE0m1a1JR0hM2DU=;
 b=WrGOVc1S/0G9ARiRtxwuh4O9lnJ+oyx1XyZQ6qaYPXB4IcxbTdr7XpmS1/UOyLPsgHPphdZhrYm1SUXxmWh3HRvSt4h4KVZ/zMcQzN78PunaNB4wqL2fEu65ByuPcB2qu47mw1Uwl/nK7HCHaqgrTWeMZmaOWWnRj/ttt339PRd3DSFdXwSGHN9lG37DorINg04On2jsX2OYneZckP7i8nhE3t/Fvm4Vt113AGnZkdLrxeVLJyOGsbIYzdV06ZwdSZgjZlWDvLPSFqBAXBdVDyBG4TjgeswiEKKUzfDtJxzAXdE7TGcxUGjHoIXTF1cxx70rBf2xg/xiGchE0pJ6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXsSpobf2poXOLILtez9/LHBEzVXaE0m1a1JR0hM2DU=;
 b=q02WfX7zubyuOHz8scHsR9YwO9XT+edlHNQgFI7lhWbVvh43rsrnrYgCtQbbkO/mmymeS2F6Lapmg5DPxcGU5QUF+evxttw79ecB4IueF7pmfAKIdh96TWvJcu/GIG9qd8lTVTSKh29qsMQRCnit6o9IfwBpmGmpb07xJGB340ZBLrSokNKUcnusKrpKqKjzVqIjLjzbWIgxMapCgNs2cqmgsdJc5tPmnUuSCxNvbRg/rGUNEh7wrXTsdkEKquV42XdtCCY4lojS/D5jAbBmRD1Kima4Vt09ezj08qp3d0Q/1hlmGYsDunXpCeb3PbA/iAq97f4e9VAR/UcvAU7zKg==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ1PR12MB6362.namprd12.prod.outlook.com (2603:10b6:a03:454::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 4 Apr
 2024 14:04:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.042; Thu, 4 Apr 2024
 14:04:33 +0000
Date: Thu, 4 Apr 2024 11:04:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Tony Zhu <tony.zhu@intel.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 03/29] iommu/arm-smmu-v3: Do not allow a SVA domain to
 be set on the wrong PASID
Message-ID: <20240404140431.GK1723999@nvidia.com>
References: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <3-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZgVuErNrG9EcbPbX@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZgVuErNrG9EcbPbX@google.com>
X-ClientProxiedBy: SA9PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:806:27::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ1PR12MB6362:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gekwlVBUXnMILLU3EElgItxiKIzbcPpubQZ66bMDu80ETypaUsASpb5ToCDABSueS99S3ZC1axueiHAzB7Intu0S71h9L1vlmUwvYbbi07Nay6nojjSew/UD+0h9n/pCX0WebI9w7rUhnp/Wx3h93fbArmR6JLfUtWhdujWjDI0p0HjtvEkORlHOUOavXRgg8CZzjk8kDtGy5ETLlcHtZxwkTQeaKzcvnIuWvnN4nQaJnE57G3RW8cZYAy1N83GKvUUHINMYnr37JDssUUn6daOk/jVbqnMd0IMyHIzpYxeF2x4WE0Hun9/du6WxMZqgzJRYrU1VGxYTVd7EtFBpIRNqFyM71J+h5GjXGIcxZNcPJZ4g2zHNn3LXfSDMN/KJs2cs+J2Q00OWPnrnWW4O3ps7L7LsBjpz3QM4d+8EVLuMXcuUwQITrqN+LVWFnbK0qvN8iMF/qNLQeTOIeoGZ9TnM23B5AXY0IChJ8Gav1W++81ijgWcCDG3jY4DMw8lqI1rWumf5d55qGosE4joxGSqLCyIQuipEae1Zjt7qt9LPEyo1LOdb+AV9ShH/smc+MuOg/myFkFAouTHVs+9c96JJh14SWi7nKqslnPEHi+Z600GchQqkR3egKbvaJLAsO+VJQg8R8kyP/yu6xaIJjRFCekWpjLfQ5+PSjd1MeoA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wkd3a0kvbDIxeWlCNm5NT3NrYzVUQmU0VlRmRFNLQ3hqZm44VEM1QTAxTFRZ?=
 =?utf-8?B?Mk4xK09McUpoWXE1MUVCVHhJV1NMT01iaXRqc0VVZkxXZU1BTTJZQWE1NEVE?=
 =?utf-8?B?a1EzT0Q0a05FL2svYTVubTk1MzdvbTFnNlpPaUxHdFEzblluVXdsb3NKSDFH?=
 =?utf-8?B?TExyNjNFSm1jemtGb3hvOEZ3ZXU5cUNleEFGRFFJVTFSTy9ZMjlwenFmTnZV?=
 =?utf-8?B?ZlJNMzV0ajhWd2JXczFCY2VtUVcxcTJJeE13TlFNUjdWTW1HdENLT2Ntd1BX?=
 =?utf-8?B?d05ZU3VDU29PMi9WdDVBeTRKUGp4ekE2bUExdW5Tc0UrcHhNWFllUHVPM3lr?=
 =?utf-8?B?dkxObURWbW5pM2hMT00wWUF3M1pJN1hydkl2NGV6RURqYjE5QzBZUFEzNVdy?=
 =?utf-8?B?MTRxSjB5aWhtVGYvS2RLTEVMUUxqK3M4SUFwM3RvZHpnSGFiMmJuOHdJRkw5?=
 =?utf-8?B?Uzc0eTlPZWdoSnhpT01QUy8vMnE3SmdwT2plY0h0dW5Oa1VwNi9uamg5UldY?=
 =?utf-8?B?UW1jUGduVmZ1aVU0d3RBbllYL3BjZmZWcFlSYkgvWWNaN2w1MkJRS1dJWnFm?=
 =?utf-8?B?QTFYZ0orZDdlVlFBMmlpQ2lKUUxpSk9NcmhqZHRjYjJRRjhYeHRhMmkvQ0ZJ?=
 =?utf-8?B?QjZCbGtsT043SHpzeGszemRlUHVnOTBKbVN6bEFOMHRHTWQvTmJ3dzZuQ1pq?=
 =?utf-8?B?V2d6eWJjRTVqSTg1dGkxaVpVVVIzYWpzdHVOaFplQTVidWc2dHl4LzNWbktP?=
 =?utf-8?B?SU1PY0lZNmZIeGd4WTZhQ3EvUEpGaVVraHB3WlRWVmFwd2Jta1A4aHdxNEhH?=
 =?utf-8?B?cTl5MVQzV2M0TGtNR3hBcUtQc0JlVjNZSW5BcEU4RXcrM1lybHF5dVkzV1Vj?=
 =?utf-8?B?emxtd2VMbVNnQTJleXdSeXc5RDNFUVVxY0Q4RkVTcElnaHByTTUvY0hCNGhl?=
 =?utf-8?B?WUZaK1ZtdGlYYi9xL0hEcFFUcmtNRlgxUDB0RFhFM1ZpbTN4bnl3aks1anN0?=
 =?utf-8?B?dEZabkNHM2dJcHdHQjVOVDA3Q3pGdHNrM2lNSXU1N0hzNnJiaWJDK1Fpclhp?=
 =?utf-8?B?dmhYRWp4R0JUL1ZwOEJNaWtTQ2pialVCOHBiRmlzc0pHRGo4b24xY1RNTmNr?=
 =?utf-8?B?VkMyV0g3aGtnRS94VjF5RFlvcGhlNWhacjNUdjAvSHFpdlZ6S1d2cmRpemZr?=
 =?utf-8?B?c0xDbmM2dTRFQmE1SlNSdU8wSGxOMWVPMFMvaVZOTE5ISkxZNTF6bmhxK2Jo?=
 =?utf-8?B?RU93S1VvQzlqUlpFdjJtT1ZURmNLNGZSdC9nd2JlRXcwTFJ2WjRERURzUUYx?=
 =?utf-8?B?NkhQRytiVk5jU1RYQkpCUCtiS1BvYUdwN0d2aUVucDhBMnE4ZTVaTnJhK3Ra?=
 =?utf-8?B?NTRvSjZjRXA5SEdrWDcyNlJKWWJBWDJzbTNpR0lJRklVWWwxaGFZMHpGOTU5?=
 =?utf-8?B?dWRmR1J6Ly9qVGZtSkhoTWdRbmEySzIrWVFJV29CeG4vOTJNb0JtSmV4M3Ju?=
 =?utf-8?B?Um81ajNDcjBORVhMQmJ1MDg2b2E3Sy91TysyMys3Vnh5QzdzYU5SR1NBdnNC?=
 =?utf-8?B?NmlJY2JmaHFBOFZhRE01ZzJkdDdDcGR4WkU4QlI5WFZMNXpvNnRzeXJ2Ynd2?=
 =?utf-8?B?WHBkd01DVjl0Nng3YkhpZENDVXlOaUVHQ05RMlZrdTZjNC92NkxNQVNwRkJI?=
 =?utf-8?B?WFN1VUlzc05XODdwL1Myc2t5RHN3QzAwbmcwUHV3RitpUHFsUWFXRklpTVpK?=
 =?utf-8?B?WFI3UGtEeWZtY0JIcENmNU9QRG1nMlF5V3NOWWMwcTltMnhQN3ppLzU2SHg3?=
 =?utf-8?B?VEdFUTArUkRZZm9yZkQ1OU5MQnBJVCtVTERMcE56dE8yTWhxdE1id1dGc2dB?=
 =?utf-8?B?cmxEMVZaZC9pMVlxVzRJeGo4L05nL0U4TDExb0xha2Q3blg5R3R1VHc0elpl?=
 =?utf-8?B?cEFvOFNTd1AwZ21PV3pZUzM5TlBEeldFYlBQN0RmbHBBelUrdG90OU8xbUp6?=
 =?utf-8?B?NW1DRXdMcFZZVGFWWFBYaklJbXNpbVlScW41RkhHWDR6cHJ2UjFEYXZtSm00?=
 =?utf-8?B?dlVQUjhmeHFSbGtzTkdnRExWL095eFNDT3N3Q2VzZGN6bUg4enp3VlVIM2cy?=
 =?utf-8?Q?HihTsx26029v7VWxTp8ruaVna?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc5373a-8c63-4512-5304-08dc54b02770
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 14:04:33.4184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzztSKcUfv9/GYX9VdXsZR/4lToqJ21QtPQKzhonPL0GZKQq8krIvPc/7eiYHnK/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6362

On Thu, Mar 28, 2024 at 01:18:10PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Wed, Mar 27, 2024 at 03:07:49PM -0300, Jason Gunthorpe wrote:
> > The SVA code is wired to assume that the SVA is programmed onto the
> > mm->pasid. The current core code always does this, so it is fine.
> > 
> > Add a check for clarity.
> > 
> > Fixes: 386fa64fd52b ("arm-smmu-v3/sva: Add SVA domain support")
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Reviewed-by: Mostafa Saleh <smostafa@google.com>
> 
> I think there might have been a mix up, this was patch 01 in v5,
> I didn’t add a tag on it. I don’t have a problem with the patch.

Oh yes, it is somehow my mistake, sorry. All this tag annotation is
done by hand :(

I also didn't intend to re-send the first two patches, they are going
to be in rc3.

Jason
