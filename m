Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CC822625;
	Mon, 22 Apr 2024 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713795666; cv=fail; b=FG3CPL7EkYk41QfpfH7nrJrdDhcTrY5rBI+U9dkTEDWbPGBM0/bfcW7BoWjKQCk1KN/+xYLtGypzh6gfDjHrkQPBF36wWtSCS/WAPa18h9erARc9+7vi3sWGlS2bRGl3ihYi/1M8At+TizN72191n6ImOhoPP395xEAqR5XLTu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713795666; c=relaxed/simple;
	bh=udSJaSkwtJCCphPzBH0HXixwNz3v1/cwU8WEAobrrz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=svCJXmyMRSbWs/gXy1cxYwWB8W/BKAgxLnnV9qFwq80lhyKnbF1Ik9Rxb6c7kbs2jWkmsbk57jlTdmXh93nnF7ur8iaCuVie516DMXSXJWpoZdcygLuC1sXbCXDlq7KuB63geaKyVMvy4L65DlQf1B3dKOK+Ylbc3j95CDoS92Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SfKiEzyR; arc=fail smtp.client-ip=40.107.102.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SfKiEzyR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cz0PNN/Az0VfVIk7f1MicGOD5F9WnJncuFJZcHevj0mpTx8CiHV5IId0VHpBR3c8xmN1fKMm9FFOIYfioVvJHHMP6eneS3sAFer5dt42kjVG8c5aV18ou7mPX34fuadqb4OkGWhvq0akEEx2p41cnVgWLxjd7+3/lAVg6yVo7UVySwFn3+tBmmcsXar++nJIEWkbVUQD69gMyPET3h4p76pkKUkLvuF1RgzMY6xbM6yKXvvgYDxV8VnSgLW47rx7SGhkf3LIbpsHVPAgxbnDz2aM6PQ8fwyR90zStdZ/jaRahRyP3mkyycTZ0/b+UIahS5k5dKfFu7a1QyVAky6TmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skMBJs9AvKIFwsPmoOvo5bw6/7NhVcGPOltUHpsiDvk=;
 b=bnkYOG4tplHDGKtAkupyQa8LEDzOVdcO3Uzuwo7tai5sbEHmTxXx1IrxG78E8DdZPQ1EnWY5hl3Cdv7N2qDXFh8iBSfYQDEe/fXXUrUtgMerAI4TqQzgLccqvOLn72hm63PUXu0mDLvxXm8/z9nQE04kjoXbo4zGhwbuW+L70SwoTxE7iREkT5Y1cl983bx77zDICzNg2TA9WM9kk61oXgqtK8jKXnrBr2sbm7JUdVWHz97BPGn0uE7M+xx2WAEKiA1p5tSn/fTjhMT550Mkzu1ulqhK3bXRqdZCDz4DJ7vWZGsqvzTF1fspzrBko0aX6RWL0S2ap1c9rEb6fA5iqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skMBJs9AvKIFwsPmoOvo5bw6/7NhVcGPOltUHpsiDvk=;
 b=SfKiEzyRy1dIHxPSyXZGortRXtS+nqyQybbxx7ezCbKTC1jms+PECngY9Al4/FcC97rJF4ICWv97GxcB4G+E37imlW0DpMo0Z89od+0s4bHjv2hjA5IW4Ab4J/PIhqTk7uqYGyys77JTUbCX3k3fZVrSMdhY+LZDQ8XKVQ3j/Ekq+ExZmEPBUaB2PbQf1aOz341GJU5V+Hd/VhYLE2Sj4uba3IwU3seBuHm0Oe8YmHOyfMtdSLgU4lrhPgk7SREpuegWJ1KJiamZdI+dFxi3srhVcNGt7Nz+lIQEsIkGWuvSpvNMs82nj0uiHw54APINAzMoUbqF1u/c0xkA/S6LtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB7833.namprd12.prod.outlook.com (2603:10b6:806:344::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 14:20:54 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 14:20:54 +0000
Date: Mon, 22 Apr 2024 11:20:53 -0300
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
Message-ID: <20240422142053.GD49823@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLerRK1pXvt-HML@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZiLerRK1pXvt-HML@google.com>
X-ClientProxiedBy: BL1PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB7833:EE_
X-MS-Office365-Filtering-Correlation-Id: eb4bab73-779f-4910-84a5-08dc62d76bcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlA2L2RFakthaDIwN1JYaUIydjVNUnVCbk9pdEpodDFyMWNrZnZyMVB2RWVu?=
 =?utf-8?B?ZXN0SU05T0szRHI1cWprQlVLbStpend0c3B1aWNOL0FlZDZYSHlOOUhzUmdE?=
 =?utf-8?B?VnE5dlhYOHlQNHZLenVHOCtZNHJlNTFjR1RQMnkxSG9vNkJucXZMS1lsZ2Ra?=
 =?utf-8?B?c1Bib1NoZFhRRDRNYkUxSTZBSU8vMTQwQXd6WnJRUGN5VGxENDhYeEd5R2dW?=
 =?utf-8?B?ckNCVlQ5cFdab3kwVXdXV3g0R0RMZzlnR0FMaENEMjZUTmMzeU5hZitMUFNM?=
 =?utf-8?B?QmI2RGFKYjBSZlRtTTQxbkpwSEpYWE8rT3laeDJ5RmhrRXpzM1J0QlFnNUZo?=
 =?utf-8?B?MDBmVmxFdk16aHI5U1hVTUNPL0dDRHh6U2xtSnhUVVQ1Nm9DejNKYTREblJq?=
 =?utf-8?B?d2xyRUtsQ2xBdW10emw3bHJQME1OdHJkQW5JQ00ycUx3aW8yV1NMcGJHbmlu?=
 =?utf-8?B?cVYwQTF4Vzh1bm1lc0ROcjArS3hjWGw3ZnBtMTBPL0NlQXBlSE1rbGFMajJV?=
 =?utf-8?B?aWE0bGVkeHZGWWU4bTRQYW5kaEZsVS82ZlBuR2drNStiN1FFZEtHdEJlWEhZ?=
 =?utf-8?B?dkRQeEtMR0tzRUlJMklJa3BrMEpCeExoQWpjYTRRb2dOdGJabWdsL0lTYzBR?=
 =?utf-8?B?aHVTSldDbVg2d2MwbjRnZXJpTmNYalRycjBsWno2eXV6azJJZlRkS1JhMVN4?=
 =?utf-8?B?bDZUTkN0cnpqbUZDeTVXOUlaV0o1NW9qVVZzOE9UcjVsT25VK2MwS0MvdWlJ?=
 =?utf-8?B?WU1xaU1LQzNDVmRYR1p6YTNqTUdOTW1CZ0ZwUVZqUXltd2lINTZSa2NQS3pp?=
 =?utf-8?B?UXZnUFZPQ0NiNFlVU3FEa0dwSUQzWDNXR2ZjckNKM21GeFhFeEpiWUtKUDZi?=
 =?utf-8?B?SERtYStrN1JSL3lGekRaZW5iRWRaSFlEUHorTnpLUUFMT0JldjhISTMzUlhW?=
 =?utf-8?B?UnFQTnlGbnowaUFRMTNlSHIrSldQNzZLeWFWSTdPTTZ1Rkx6MnlQTE4vbVFE?=
 =?utf-8?B?QkQvYkNjeElLcFBnR1cyL0NCeXAxSzNaT1ByNTNybWlqcWc4M29sVExxc1pa?=
 =?utf-8?B?dTBFZDc3cDdwaWZ4blNUNVZGclVCdGZkYTNPdzBOZExYZ3dVMzNqWHpqVS9H?=
 =?utf-8?B?SUFibXVmc2hOTWhja0NpVjZ4ZHhpU3lFN1UvRFFDZ3piRjJZNUdCanZGT25H?=
 =?utf-8?B?czBPRUZiZk5JZUx1eVQxUTlKSkx2c2hYbGtBNy9acWhIQkJPR3ZqVVpYVS9m?=
 =?utf-8?B?Z1NEOUZCN0ovNkM2cWtwTStxbGt2U01ZMFFTS2FKZ1pmQkFvU1JvMGRsUXkr?=
 =?utf-8?B?SEFpejhjMFRtRXZ6aG16NEFCQ2x2am1zc3V6Mk15UXQxQ0RVejBrZ01Xb2s5?=
 =?utf-8?B?dHZ4RXY2MytUWkQxVzRyVHNaZ3drS0tDMmxMNGdKNGxYVzN2TkhEOW5Sa1Nt?=
 =?utf-8?B?VDhNVmloOHlOOTBBRjFxNmhOd1Nxak84OVpSRGlIQXVEUlh2aGg5ZWhNeGE4?=
 =?utf-8?B?bmRCRWc5UWZDZjhsMFFlMHVkNHpYTjlqZFpjMUVqdHRDKy9Wd2xPTGpKaDB6?=
 =?utf-8?B?MjlJK3FKUkpwKysybDBKUUQvc2dseW1neHZuNVZkcXFwMjVYZVVIaXZvbEth?=
 =?utf-8?B?OVNmeWpaUnJuS2ZVVE1mWlVYYnNNZURSQlc0c2dJa3hRRW5iT1FzbUYzUWVS?=
 =?utf-8?B?YXlucGt2MmFQSUEwK0tYWThaOFg0ckxBSkxXblhyUWRIMldITVJJNkFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zm1ISDRKZHQ3YndZbXpaU3JwMzlDTER0bFAxLy83L2kxM2EyZDhGblI2aUlN?=
 =?utf-8?B?RDRMem9EVGdJK0VYbllORk5hZzV6RGxQTDZtemsxSU5Md3VQcDhPV0xBUWo3?=
 =?utf-8?B?SUlnUlpmZEVZcmlzT3psSTRSRDE2SllVM3NPS3lEaldwUVpOUUxQSXJ3UmZx?=
 =?utf-8?B?RmtwV0xRSTRBV1hrYWtqaDJLVHVja0dMcjVxVFpyTHY4Ry8yVnlUWVJLUG9i?=
 =?utf-8?B?NkR6NVdYaGphb29BRW1nc3BxbTllYUROQkxSNVAzNlVDTEN6RzVVTFkwR1Yw?=
 =?utf-8?B?NGdRQWpJQmlnT3FQbkdhdEZTWkh1Sk1EWmRJL1BLdjg0bVh1Y0RXN09jaWw5?=
 =?utf-8?B?Y2lnNHE5T2RERzRZeFVDcXNNTVpkT2Q0RDVwejlNckVqbW81cnZqOVBSYmM4?=
 =?utf-8?B?aWRMekFPTUJOYWwxQWlhek9IMHIrakxZUm1sWUpqTHVmeFlrRXpHQVV4UlFN?=
 =?utf-8?B?RW8yL1ZFdFJZRUdtZlJEWDJOcjBQaGppV1Vnc29VUnJra0lJOVRwUWxubWpS?=
 =?utf-8?B?VjNCQnFHNjVraEQrdkxNMXRLUjJkN2FnaUp5TW4wa1N6a1JKb25nLzd1YXc3?=
 =?utf-8?B?bmFBRHBkazg5MnhteDZJRCtzMXhUaG9GbkNLRGZSeWk1YTNkMTdXak1UYU9j?=
 =?utf-8?B?N25za2U1Rk9ieEVpbWY4dHI5Q3VGNGtXQU9DSVlWSjZOR29RVWZ6ck9TUDRL?=
 =?utf-8?B?K090RE9SL1R4S2xZNmZSSXFDK005KzdsZ1ZPQis3dUh2S2ZJdDlTdzBoZkI1?=
 =?utf-8?B?Ny9BSHFiWkVFb0xSRWsvcDlySlB1cVFNd3pET0ZsMFBQakRtR0FQSCtIbDk0?=
 =?utf-8?B?ZUVyNTBjZUMvL1hFZHdKQ0V4Tmw1NWMyR3U2dU81eW1rR3NvNkdQZ0FLK3JQ?=
 =?utf-8?B?SGNLWjJ6VlN3YW02bmhac3MxYUg1VlNWbE8rc2JUUlJkYmNwVXdzbE5jY0JM?=
 =?utf-8?B?N3grNzZPbU5janExNnNGWEVNUTNPajZXY1cxMCsrdWhWeU9OSUlEbjN6Wm1D?=
 =?utf-8?B?U1dEU2FTQnp1bnIySkJNMjBUekpSSjAvbjQ1NmYxOFJVQzJrY3YwMkFZMnpK?=
 =?utf-8?B?b3p6TGNjTExTY3BCVnEzU0FIOE9PR0M1aVBFUmxocmR5ekpkRE8wU29kS0hV?=
 =?utf-8?B?SGRDUk1pQ2ZJcmcwUTRPUDRsT2Q0MTVuNlVRTndXeS9vdEtiaWgxbHZRZmVY?=
 =?utf-8?B?eHFzKy80ZUpTaVc4OUNvTGNTRGxXUWtTd2g1UStKMkZJM285U3BKSk1lZ1hV?=
 =?utf-8?B?RnlEaWNkdVNLeVUxQnU1TTNDSEJkd1pxcllEb0JOY1pVSngxYk1qRG5JaG9S?=
 =?utf-8?B?YkladzBmZXZTYmU3MmhUcVNmUUNhWm0yWkdUN0hOWmpETTBBQ0hFY3V0cWVm?=
 =?utf-8?B?MGVhMnZCWGlTL1l1R2dQTGtoNG9JelhwMDkzMG51ZE5ZWmg0d1dGWFFyTnh2?=
 =?utf-8?B?NDJjeUQ2QnZzNFMyVHpMRE95MzlGU1VkV0xudEJEenNQaXZ2Zjd0UTB5T0xq?=
 =?utf-8?B?YXlGZzNSdmowNnFwQTQyRUNEb1dNZXc0VWFDVitkT0tkNCtoNW40YW9BaUU5?=
 =?utf-8?B?T2NrTHhhdEQ3RzNaQlVPV1hzaEF0emY5ZFZTeVQ5UVV2TytYUUYvWE9NeWZR?=
 =?utf-8?B?eWRvbVVkcGxtcDJQNzhycEhoczZTWXBFQWZIdUtOMXBuQ1NjNU44ZHhvZ0NL?=
 =?utf-8?B?RXhLdnUrRVJmSGN3b2UzVklMdFJtWTM2bDFueXBJRUt1VVcyZ1JubUtzK0Fh?=
 =?utf-8?B?Y0NwZTBqL1RZQ01wQTVCM1RkUzYrWkNQSTUzaVB4cThIUUxZSERTZ0tjSHJL?=
 =?utf-8?B?U1kwQUh1K0Z5SjNack9pb3cxUDYrSlBiLzhYeVFra0dMV0xvWmxZVnE3QXZ0?=
 =?utf-8?B?YzRaZ1AycjQveTQvZnorZ0xTUkNwQzgvOGZKMERLSjRtNlZrQjFpbi95Rmxs?=
 =?utf-8?B?L0FzeWs3T3A0dlA0WGF4RmZJRTM2TCtGaE9QZi9TUmJOV1duQmJ0dEFTZ3Vj?=
 =?utf-8?B?VEd5QmtyamVVcHcxcjdJWkVUTG5PbDk2N1pjR0ZGSFplWHdTd3dtYTNtUVhT?=
 =?utf-8?B?UlFiSU1KaVJWV2VCSzVvZm1LMmFmTW5zeW0yMll5YnVIV3l6NFNRSGhVS2Vn?=
 =?utf-8?Q?eJmtWKOf+AkVduMhBQ1/7JuM0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4bab73-779f-4910-84a5-08dc62d76bcf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 14:20:54.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVNqXq3JFCtpyb86NpOke0BiKA8F59TAAXxY3JGms8vPlipCW+0XN5sjMQNk5R20
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7833

On Fri, Apr 19, 2024 at 09:14:21PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Apr 16, 2024 at 04:28:16PM -0300, Jason Gunthorpe wrote:
> > Only the attach callers can perform an allocation for the CD table entry,
> > the other callers must not do so, they do not have the correct locking and
> > they cannot sleep. Split up the functions so this is clear.
> > 
> > arm_smmu_get_cd_ptr() will return pointer to a CD table entry without
> > doing any kind of allocation.
> > 
> > arm_smmu_alloc_cd_ptr() will allocate the table and any required
> > leaf.
> > 
> > A following patch will add lockdep assertions to arm_smmu_alloc_cd_ptr()
> > once the restructuring is completed and arm_smmu_alloc_cd_ptr() is never
> > called in the wrong context.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 61 +++++++++++++--------
> >  1 file changed, 39 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index f3df1ec8d258dc..a0d1237272936f 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -98,6 +98,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
> >  
> >  static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
> >  				    struct arm_smmu_device *smmu);
> > +static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
> >  
> >  static void parse_driver_options(struct arm_smmu_device *smmu)
> >  {
> > @@ -1207,29 +1208,51 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
> >  struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> >  					u32 ssid)
> >  {
> > -	__le64 *l1ptr;
> > -	unsigned int idx;
> >  	struct arm_smmu_l1_ctx_desc *l1_desc;
> > -	struct arm_smmu_device *smmu = master->smmu;
> >  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> >  
> > +	if (!cd_table->cdtab)
> > +		return NULL;
> > +
> >  	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
> >  		return (struct arm_smmu_cd *)(cd_table->cdtab +
> >  					      ssid * CTXDESC_CD_DWORDS);
> >  
> > -	idx = ssid >> CTXDESC_SPLIT;
> > -	l1_desc = &cd_table->l1_desc[idx];
> > -	if (!l1_desc->l2ptr) {
> > -		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> > -			return NULL;
> > +	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
> 
> These operations used to be shift and bit masking which made sense as it does
> what hardware does, is there any reason you changed it to division and modulo?
> I checked the disassembly and gcc does the right thing as constants are power
> of 2, but I am just curious.

I generally prefer the clarity and succinctness of / and % instead of
hacking up bit operations that the compiler will generate
automatically anyhow.

If bit extractions should be used it is better to wrap it in
FIELD_GET() than open code it..

> > +static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
> > +						 u32 ssid)
> > +{
> > +	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> > +	struct arm_smmu_device *smmu = master->smmu;
> > +
> > +	if (!cd_table->cdtab) {
> > +		if (arm_smmu_alloc_cd_tables(master))
> > +			return NULL;
> >  	}
> > -	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
> > -	return &l1_desc->l2ptr[idx];
> > +
> > +	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
> > +		unsigned int idx = ssid >> CTXDESC_SPLIT;
> 
> Ok, now it’s a shift, I think we should be consistent with how we
> calculate the index.

Sure. Change that to / will make CTXDESC_SPLIT unused except in
computing CTXDESC_L2_ENTRIES so that can be simplified too:

-#define CTXDESC_SPLIT                  10
-#define CTXDESC_L2_ENTRIES             (1 << CTXDESC_SPLIT)
+#define CTXDESC_L2_ENTRIES             1024


> > @@ -1357,7 +1380,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
> >  	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
> >  		return -E2BIG;
> >  
> > -	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
> > +	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
> 
> The only path allocates the main table is “arm_smmu_attach_dev”,

There are two places that allocate the leaf, arm_smmu_attach_dev()
(for the RID) and arm_smmu_sva_set_dev_pasid() (for a PASID)

At this moment all the paths are relying on the above to allocate the
leaf. The next patch makes arm_smmu_attach_dev() allocate the leaf
itself. A few more patches also makes the PASID path allocate the leaf
itself, when the above is removed.

> I guess it would be more robust to leave that as is and have 2
> versions of get_cd, one that allocates leaf and one that is not
> allocating, what do you think?

I'm not sure what you are asking? We have two versions. One is called
alloc and one is called get. That have different locking requirements
on the caller so they have different names. I would not call them both
get?

Thanks,
Jason
