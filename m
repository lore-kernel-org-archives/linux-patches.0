Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2338745C5;
	Mon, 29 Apr 2024 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714402552; cv=fail; b=DpoVGxBmr1O6EvLtfMVZKqDDOhv9vcfCUuYRv3pNxHRBJOQAwBkAsU35QAPlG7O/oimGDfBsPRc6IR6YWDnFW2MbkDhK28yYkJyNkiFTxXRK91duBsdk+uMtfbyeG16XsAy5x6LVuzh0nUHEtfOlRbhfFxiINFjtrSE45akHYV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714402552; c=relaxed/simple;
	bh=LUI2Oyva0tYPVMM8aZ/AJYiNoxFptRGWOw03tF4D5O8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fwx3s0uPlMktpoTCLjE3A2cY/G2Hna3Aw1Pukk2A1f8vrrgCDLYdJZl2blhT1LqCrjAQ5hZjwoZPJQgqGgKO4SSmc6M8ymrbzu0Hdz9UnEh28+/yPy7sxyiN2pqQ/lbHaQcUupcOhPUCVfAqXlwYN7t18FvsLw1+pAIDFKUuhZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bzaEQJRr; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bzaEQJRr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMcEMe6vVz7uia2Tl1uMIZxYAKSG0AG9mqpEZru0SJlMjUWf4a3R2XYVCvL06bTfFBm1PHbANfXR08GH+tdYcLRmxJhT1PDwsJI+FahgpaEENTwCKdkRJH7r50gIhg3mRO4tJa1e5nXKlq9xBLYQRWvA1RzinVvdxS/KaQbh6yyXi5i5hZFPulSqKd8062kPkjW4SxcyAeD8FYzzZBAge6VlUi0D6tiMja6cngrvmuWpzahUiCF30m6pLtfmdaH+Log104tO2LVvJehPcyl9KIhgDJqZKoRlYiKW1JdbJJohnc19pdKbaMqDY8JVb20SXQWTLH2BDcW9MlaxTWvdGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ub4evBFXHnaTaO2w835iIq/6CogMSOAv4uQjOXWnt1M=;
 b=GuaZ2L6H3wE+h6P6Nmuv+ppbkcd5xdZLqePehkvmmfeRa8ilAO2DYkBF3y/Rq8wefi6nf6VyctzgTj9CTA7BS2a7GGOOwJ8PWEJyVmplViYprz2APa3pCyOmGJoZ04jsnGss7fdVJi9Ipb3XU9XRuxaV39Saexnm0KhlCO2L+inQeoyoejSI5dlBRrp44r+yLQPdf8kF6w2fBQOm/6K30E6vGS6Xq772GkOLb7+LRy0V65hGm6TqiB/D7A4jpsekBw35gSScbB1oQp7yahzyz94APJVft1Vp3M/knQvCBODvyhCC37eQyv+fWURqNvKk7wnyv+dun9vmsrXf5knsfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ub4evBFXHnaTaO2w835iIq/6CogMSOAv4uQjOXWnt1M=;
 b=bzaEQJRrH+Di/Y5b9S866usxPuq4d1vfWSrpEoUGAzR65TNl1L65IlDZlHNE6RnOniS2rgcvJQxvLVcNAiB89LEUk2ZcrhYKW8ad97CVeJyh8/wpKLFwnhyR8rDxcddGrzUCReKZU7UJVPhvaN9Y0iD7ohtKzg20EJylHu2/556QiAdr/qtMEQweu6j2vjot/gZFpCyy/ALZuaymw3TyRSRNfu+zB72qb4BLPxieLiJ4C+Xt7ax8db5p8P5XJ8vQe1PRyvBnGClyJkbnIXcmwT/XEYlR9/pPzg8VSVqrp3SgiXaGHLzTA8ecStx5VRqWFwGBSqsjV0RSVzqiMkxBlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4233.namprd12.prod.outlook.com (2603:10b6:5:210::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 14:55:47 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 14:55:47 +0000
Date: Mon, 29 Apr 2024 11:55:46 -0300
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
Subject: Re: [PATCH v7 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Message-ID: <20240429145546.GG941030@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLerRK1pXvt-HML@google.com>
 <20240422142053.GD49823@nvidia.com>
 <Zi15-dcNj6E0k4jK@google.com>
 <20240429140137.GE941030@nvidia.com>
 <Zi-y_kgb34l0rrRU@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zi-y_kgb34l0rrRU@google.com>
X-ClientProxiedBy: BL0PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:91::30) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4233:EE_
X-MS-Office365-Filtering-Correlation-Id: 08fa7f8d-cc77-4134-0ac1-08dc685c742c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVRrSXZ6aGZvYU14SGI5U29vUGRPS3lPakhvc2Y4bDdodjFvNWdoaFo4ME03?=
 =?utf-8?B?d2RhdEZkTDBVK2hzV1VoNFh4dGRkVjBtdncybWdIYS9KZUVKREVVOGpZVUZT?=
 =?utf-8?B?RFlQcWNjRitDL2FEeksweXRyMGZvZXlyRUprZmRnUS9IMUFteURMRWt6c1ps?=
 =?utf-8?B?WGQ2UE1VSkNmK21rTi9YTVUzUllOWlZsV0dGMFVpY1F6ZEY1QWVINzBBV21N?=
 =?utf-8?B?ZDEzaXZPUWM0YVBVR1M3S2d4UmRtWVBjdnhjQWIzcGk1M05lMEpuWFNlby9Q?=
 =?utf-8?B?K1NmMXpjaFJNWXkyUlo2YzhKUStSRkNvM2Q3eHhrQjd0VnZzcXg3MVZtTnJG?=
 =?utf-8?B?TEtqN3lYVHBHUDVxbTVZY2NZR0Z3NW4yV25WSlZNRENsQ1pVSjB1anE1dHdT?=
 =?utf-8?B?OXU4UFJxRm9TaXY1MXp6S3kzQ0JJa3hWZGkyQk1jY0pLM0NGVUxoNGZCR05j?=
 =?utf-8?B?TExwakQvQzJDc0Z1QnFjMm1jckNNeXZpMVN1dGU3b0FONzR2QWlXcXhWSFJm?=
 =?utf-8?B?eTdTZW96MlVhWVhMUnREbGNpcmpPZTZuRGlrUlNRNVhaSjJQV2NNM0xFTkNC?=
 =?utf-8?B?b096YThvVE05M1U0eVR1cUNHTERjRWlNZUlzaHhGaHNnWHhINEZjeklDbXJB?=
 =?utf-8?B?dEhvZjh3cUwxc0YxY29ZZlVOdzRINHRCN1A2aW5nckdkczB4ZURvbXBOb2Jp?=
 =?utf-8?B?MTMrT3R0b2RZcytlWGhGRGlSK2JyYVhKeXpjUlZPUzF5YjNPdUFtTzVZOGlB?=
 =?utf-8?B?bjNiS3JDYUZhS0JVN3R2WUpHZzkrZVllcEE0cXhNYWRkZjBneWFnZmYvMnBt?=
 =?utf-8?B?UHlLTnNFTXkrWm1hSnh6MkJueUk1YWExbzJoQ3pKUmJ6M0l3eXhmdjRNeHla?=
 =?utf-8?B?K3hUaklHMmx1STlxQjFHdGJwb0JvbFNRVGNZWm0vRktqVStSVnR2dEczbXY0?=
 =?utf-8?B?aVUzc3FIa25hbHAyZWVtSjBSY1hNbGMwRENaNVVacjZ4cXVuTTRRQzFEc0pj?=
 =?utf-8?B?dFN0N3FzclhEMmtUSVNuM2xLWS9jVTl1cjVuVkdJS0Rwbko2QitySTlpQlR3?=
 =?utf-8?B?ajNLWHN5WjcrSFRTMWw4VjdUanNNTFJxZEFWUE9Qdy8vZGFkTFgwVnE1cDJs?=
 =?utf-8?B?Y2tKbVBoTjJJbXIwQ1RaUHl4NC94L25DbkpzRkUrbHgzTHNZdytoRjdBSTNa?=
 =?utf-8?B?WlBNRENLazN5eEpsM2dpdTQyQ0podFVVdlRYVWhSekpUSDVXeWxaV3FmV25y?=
 =?utf-8?B?ZFV4ZmZoOG4wdGVNUTEvTDVtb09mYjFqSEpNM1FkNXVxOXlZbmJHR0wrWDgz?=
 =?utf-8?B?VUxBR0RIbzd5THdmWmJuRStjamY1eHpKTFp0MkREVmJNcmdCL0R0NXFJUFMr?=
 =?utf-8?B?SWZxTWtHK0RQVkF3NlNnT0RuZldCRzN2dExtRi9DcE1idlQxWDNyemJRdHJE?=
 =?utf-8?B?N0NENmRuN0kwWnRrUEdoL1NqbytsaDcvUnFXNkhjVW1XT2oyV3ZmWEZjSmVW?=
 =?utf-8?B?U2dRZGIzMVBFSllzZ1lwajFjRmFCamRzZWRMRU84MmVyQ2xOV04rZUVibkZS?=
 =?utf-8?B?aEJMSTJaNGc1bDJwemlNWTBYaDIrT3pOMy9uSTk1ZFFhRjVMYTU5c0plZ2s1?=
 =?utf-8?B?S3d2NzhPcUxDbSt3NXNJeXNORmJITlR6Zll5ZDFVdUNsYWsxYkhXajRPa3Rq?=
 =?utf-8?B?Q2JDNVl4K2tYSGhhdy8vVDdKaHRNN01VOE5sNkFrVDN1dmRjUDRxNWxnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEt4UEZnRi9WWS9ZZEw2b1dsVWppSUphaXIwSVA1UkRrRDhPQ3ZodUdhMFpC?=
 =?utf-8?B?c3RlNDNDVkp0ZXcxLzJYVmlEZlh1bG4xUEdEZG1NaStDMDRyRjJuTXlKcCs0?=
 =?utf-8?B?NlArMll2YnE3b2ZLWW5tTkY2Qyt0WENvOTlnQUsvUFBSUkpSaVdORFhOL293?=
 =?utf-8?B?VEl2NGFPQ0JKRW1xRUMzcjJkL3FGSnFUdDRHaUdXeXAwTzhmRGhoYThFU2tC?=
 =?utf-8?B?elVqbjR4VGJYTjdqREsrSlhnSlRlMDNicXF6c2sva2dtTUJ3QW5zSzI1U0dN?=
 =?utf-8?B?RXMwTmJFZWhXTDhaWittVnBzZFBYb1pQRnBRVjZKeW40SUIrNWZHa2wrbDUz?=
 =?utf-8?B?bXhzV3FEK1dIc3hKK1pmNzd2MWg3SWEzY2VNZnJjWFZ0OVh3dWF2S3pJUFYr?=
 =?utf-8?B?eE5PRjcyQjBGN0Fnekg1VnM1TGVQdHVJVVdZQmcxZGUzWi9EbUpSYmovY0lM?=
 =?utf-8?B?anZ5Q0grcG9DK29kY2RVb2tPOWNFd2ROWXc3dE5YQTgvVGNPTDBMNjZIVXds?=
 =?utf-8?B?dk8yVGF1V3RQQzVKdGhESkZGTkFjOWR3dTJ1VlBnTFFJM3gxZmtRd0NWOVF1?=
 =?utf-8?B?Zi9WeWQxRkdpYVgwcjhMTEMrQm5lcVVoaVR5aHFjZGlTNUFCdWc0WXd1RWFx?=
 =?utf-8?B?ZThrTWJqckx1eURBWG9yd1pFbW1wZEVlQmN4SS9KMkMzRDdCN1NDRFp0Y3NM?=
 =?utf-8?B?S0hqWjJleVJub0R2by9rL1IyV2pnc3BQRmZ1cGpIQS9BdUtFeGhPaDZCL2Yv?=
 =?utf-8?B?RDlrMjF5akkreElOOEUwSUtPbEYrTTNHcmd1NklneFBRS05ncVMyUlEwWnA3?=
 =?utf-8?B?bStvUGJWb0lxRzB4Lzl5ejVRSFI2T3FMdzZ2RGhzeStYQkF2cFMzcEFFV0o1?=
 =?utf-8?B?aUtKaGdmN3FESG1qMnFBUEc3Tkh4dkxEUm80Q2EvTHhaSXlPUVI0VytJckxq?=
 =?utf-8?B?SFhpdVI5elJnY1c1dTdlK3hmWXNIL0pCZXI4NTNwM01KdEVHaDlUaUw2OWdr?=
 =?utf-8?B?UDliRVgzYnQ4ZzE2aTlqZitKN0FjQ2NUWHc5bGZjSTFKcVg2eFZtcXlNb2o5?=
 =?utf-8?B?Z3VpbWdHQWQvVlpIK3BKY004aG9hbHlhc1NXRlZDZ0k5YXlhcmJvNnc2VE5R?=
 =?utf-8?B?d0tTM3BSRndPeHJHbEJ5WWFrZGFHejdkUWZxUWNCUWlQb05OUXVvdGFBRDhn?=
 =?utf-8?B?bDdFRHhwbXJRSnZMaXB6VFRMMVdCdkJrbTRKVDg1ZFpZc0M2WmVvVHFHZi9j?=
 =?utf-8?B?WnN3MDNsRmdmV1RjYnF2Q2I2VG43ckl6RzY1VWFBbEJqMXl5b0drUkcxYTN1?=
 =?utf-8?B?YkJnY3gyN2RaYzN5TEQyZy9QK0xJRndjY05IUVZQTksrWDY3R3ExajVGRFJT?=
 =?utf-8?B?TXF6UkVtNmVWWmFKTkRsTVA1bjhWNXJiUUJabGJXNFVOTFdncElvekozV2l3?=
 =?utf-8?B?UjlNUDllcmp4OENodXYxS1Q3ZW9uVTd0YTZqaDJNRDBRRTZFMXhWSnlGdGJP?=
 =?utf-8?B?bWZkTXNCbmZKTFZldm1WQXg2MzBQS2FzeXBCZVpRc2NaUDVGeDEzangvd0FX?=
 =?utf-8?B?VzBIUzV6VjZ6RlRiLzVOSDh6SWVkWHh0ZXlRSmxNcGV5cEpKSDZtSW1hT1U3?=
 =?utf-8?B?Q1piN0Vtam1LNndZVGhJL2ZYNURNK0hjdllXRzZpMUxpcXVSZHFEWGwycm5t?=
 =?utf-8?B?T0IzUHV1Z2xVNHBueXZMeDlZNTkzZ2Vkck5mT0g0WCtYRllNRVIwcEhPbmZ5?=
 =?utf-8?B?aVdncnJzYTRiZnBTZUJQVzViTlR2cy83WE1YYi84d0xtaUhqL1NBaGJYVTNN?=
 =?utf-8?B?OXZXZHhtdld2eTFmNWttOGJ4OHR4Z2FlN3VwQU9VbzdMSUMyZ2dsVTFPMU1Y?=
 =?utf-8?B?b1VxWTVTbEcrNGRuMTNUWmtLMmU5cmg0aEVncEIwenBXL2VFQUVQS09VNFd3?=
 =?utf-8?B?WmFFWm1FejdHVFJPOG9GWmFsTHRidWx2OEVGOTdWMUh6R21NaHJGVVVQRFdF?=
 =?utf-8?B?YnRkNW1Nd0poVEF4cHRqVUtyWkhtakhBMVdtcFBMTFMvZkJtS2hSdURRbWxn?=
 =?utf-8?B?MytZcTJuNFE1MTlxdkhkM1RhL0F5Z1E5THlJOEtIUnF5a0sxZGs1UUZxcng0?=
 =?utf-8?Q?ssp5nU4YkfY5lGEsAv590VKVd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08fa7f8d-cc77-4134-0ac1-08dc685c742c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 14:55:47.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+2mi8boa8z96L4PqC2H8VNa0bcM0u0aW6qj/b1Hmc7GhXXSjShDCkb/v7W0Zon2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4233

On Mon, Apr 29, 2024 at 02:47:26PM +0000, Mostafa Saleh wrote:

> > > IMO, arm_smmu_alloc_cd_ptr() should only allocate leafs. And inside
> > > arm_smmu_attach_dev() it calls arm_smmu_alloc_cd_tables().
> > > This makes it clear which path is expected to allocate the L1 table.
> > 
> > The PASID path sometimes has to allocate the L1 table too, why
> > duplicate the allocation code?
> > 
> > What is different about the L1 vs L2 that it should be open coded?
> 
> I don’t think it is a big problem, but my main concern is robustness,
> for example a small erroneous code change might trigger allocation for
> L1 table from a path that shouldn’t,

A few patches more we add a lockdep, so a wrongly placed allocation is
*very* likely to hit the lockdep. If the lockdep satisfies then it is
not going to cause a functional problem.

> and that might go unnoticed as
> this function will allow it, leading to memory leaks, 

Any cd table memory allocated by arm_smmu_alloc_cd_ptr() is reliably
freed in the arm_smmu_release_device().

> or other issues that might be harder to triage later, instead with
> limiting which path allocates which level, would return a NULL in
> that case and fail immediately.

All cases that need to allocate a leaf need to allocate the L1 too, it
is artifical to make a distinction between them.

Jason
