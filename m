Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4931AA1C4
	for <patches@lists.linux.dev>; Sun,  4 May 2025 11:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746359712; cv=fail; b=i+a6B9nRYHSAW9LbEYX+CPHnjVCvD/4XIo/h5Iso51d4SlnmnoDG37k5O+18TJdhTbDKOR5HN9bN5awt3lEQfQbG0kwBzc2xfezpj+FsU/mxpDdGKnSLaOsG2cluA+o3JMWAGt3PBx3o8VMSLccadz7thJ0d4fzBPl3urtKmqLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746359712; c=relaxed/simple;
	bh=p85bmDTeyx67bzpN2gTsJZT+FcEYBmiGpBbgeX7minw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WRqXBlSRdKwhq3Vjq6HU8bUB6Gi1XXn68C8pA+3P57uYjcNp4hPe5mFB2MnLBdnh+326ICeOqVe+EfD8U+CZTm7IF0koX6BksAlZPIFmlNZ6lrW0M0etVYesWUBdNJxZx6dVKzGhWeG6rnrUpnY8TPdhIvl8ytwUyWzG2Or8fNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N3bg8SOU; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N3bg8SOU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xS9wBCQSfICR9MWLSgkvePlYfPL5OrHvsH/7GP+aTy8Nbf3NyV/lVIwkK70VVbtri6W/sioA9vSOT/ueJYfTbDa/4eJ7JZzJ5v9lPtyqSGmTo3Ow89mzwrHFwcUA0Zd4Q5mEVSijAWwTIdrx02OKQ6kSFdF4YtmLN/dthOpHv4kdVmbRxNAO8aHCU9Kga7eDegq4NZ4qNIk4A55KkUhl96FET+nPrZrl8adEPD99LPUm+nxusbmtcvOq1rHGgk2vWwb/Q4M3FjI3IqFVMLX0LxZD6BYMy4LgySP2NGG5z8yTn9GIZrbUxry/xpHFE2dffMy/2yF39MqK5jfm2EU33w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rh+/eTwBJqiAJknNu332ZBfgVf24osQNZeBWLJTeq0=;
 b=U+H7Ab+g+mj+NT0zw5wbuHrk/i+ubxNw44VdxbM9MKt8fkRWazMQXF+qEO27itqnJyOmfDkqU3stFFuWVlsT+RQ6okPEDsCfrlxLomSaDKcl6+EszDtovr2bnZe5/8DTRZvOZdn5R/ED8hL5SRwjAsJrqyg3gGcbhHvkulCNs7/QWzQ7r3lU1ljih4d7L/y3PBOvNqBq+ch1BFsnEMnFIJ8CDkWcmc2CaJREJrF56Xms8X884OKMKS1TMirTHlAlpOIStD3ocKfwO0yPpKcEgscm5A7gdA2DrtK9bVTZ363O+mFPlf5Fl8zpwXBt9d34LAS7QAt+LLaNr+3baoRSug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rh+/eTwBJqiAJknNu332ZBfgVf24osQNZeBWLJTeq0=;
 b=N3bg8SOUu+GBZk7bOhpTqMeRIKySZhO0cdwpzhezTv8fkfyqOZl5p7lQocWxQUL4D9zQ+tDageiLXdFlP8UNDaBvwR8twvOYd9dlnLpZY5THERJl27Isn1jkYz4CcHqqhdHEeN+P2jN2Vy2erF18oEsThmtS9s9VwbztZBRpuJVJErWd0NnLBPzZpSaQ3NrkWCkSNuv+uAVDhSwjDtVgrGEsc9bruYWOsiE9LCKAYiswhj5h3+LuMgqYwR5mChnQ522U+pX6varwja3Q1fHV0PmHVVAYXZ7sKANKPmKbKpVT3NDO53V8nC+wTMZXe8SkACcG+jnMFi4iLO8cSMZjAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9)
 by DS7PR12MB5983.namprd12.prod.outlook.com (2603:10b6:8:7e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Sun, 4 May
 2025 11:55:05 +0000
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b]) by SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b%4]) with mapi id 15.20.8699.026; Sun, 4 May 2025
 11:55:05 +0000
Message-ID: <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>
Date: Sun, 4 May 2025 14:55:00 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling
 UBLK_U_IO_NEED_GET_DATA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ming Lei <ming.lei@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161124.815951989@linuxfoundation.org>
Content-Language: en-US
From: Jared Holzman <jholzman@nvidia.com>
Organization: NVIDIA
In-Reply-To: <20250429161124.815951989@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI0P293CA0011.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::11) To SJ1PR12MB6363.namprd12.prod.outlook.com
 (2603:10b6:a03:453::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6363:EE_|DS7PR12MB5983:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ed37dd7-9e89-49ad-3745-08dd8b02826a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGxLS1ozckVhWWJQM1U5QUt5MHJHblBEWi9kaHl4R2dOU2FlSlR4WGtveW1Q?=
 =?utf-8?B?cVR4YThCdlBWYUUxZXc4akF3TW81MlZJVkpCUXpGZlZ4WW93eE1aQk1OR0to?=
 =?utf-8?B?dG5vSyt1Q3dETDNaWXhlTlFzYTJhcWpnTEVreTFkMkIxRzZHZE9ZclFDaEc5?=
 =?utf-8?B?M2laaDcxa3NFT3Z5MVhVWFZoM05wREJ3ckoyaWZlRnhmUGFGYURSV1BXZG04?=
 =?utf-8?B?MGNleDRVaVk2Tjhkc05KQUVVMFFZVjB2ak1YMmlsYitNQWJlMWVNTEcrRzJy?=
 =?utf-8?B?QStscnJrbVlLWFRiaWdMb3hMY3lXT28yOTVmUEc0MHptZ1lFTGNsckpkL2xj?=
 =?utf-8?B?Y3lCNi9iVEdaclZTVi9kSEw4T1FwbjRudUw1aTFKeHdnTERqYjlQcVhNZTBz?=
 =?utf-8?B?SlhKamF1MU1ya2lhdGE1VU43L0xkUmJLdVRDc29HRzBGVHJNRGVaNU1RRjRU?=
 =?utf-8?B?YmpiYk5lbnFmaGczaEJxMWVYZ0tHTmt2c3JwZWJ6SWRGMEZOdCs1ZkV5QUdw?=
 =?utf-8?B?aG8zZ09NZEFDUDRaVHZiSWhraVBIdkF6OEtJbjFqYzBRenVva2RpTWlkdVRl?=
 =?utf-8?B?TzFTK2pFV2xJOENiME9pT0plRS9MbHpOT29GVXR6WlZMUEQ2a3FpbVhwSi9r?=
 =?utf-8?B?bnl3ODFjZDUwYjJvVlQ5WWIrTnhxVWwvc3Zjam9nRzB6aUNpeFVpOWVZV1Ez?=
 =?utf-8?B?RGRhNlVIZUh3ZGV3SE9VU1h0aGJrczQ1aEU1bkpjcG4rYmV3bVd6WC9hTHg2?=
 =?utf-8?B?Y0dWQXVhOC83S0V4NXlHY2d0Y1VucElCeUowUTByTHBOUm9PUTlpOUtRSUo2?=
 =?utf-8?B?ZHkyMklLSXJrb2oxVmZyYm9XUlZCNXZrSzJQd0srSnpvbDhxQmdnTDR0SmJq?=
 =?utf-8?B?WDMrQ0l5Zm5PU25JUGw0bHBWajlSeGFwVG1ITmNlbko3QmVrUGZVSlY3b2xJ?=
 =?utf-8?B?SFVwbHcrUFdHdTJ6cWoxM1Q1ZjZLUWpRelk0QVJYR1IxS0lNWm94WTFBOHdx?=
 =?utf-8?B?ei9LeU05cjVldzRUZ1d3SHk3TENWTlFxaElBanRHY0NOWUVaRkVleVBzQlVK?=
 =?utf-8?B?dk5ucms2Y3lTU3ZFb1FxWXg3dFNxdUd4K2FHaE1WRmd2Mlp2c3kzSUxVbjhT?=
 =?utf-8?B?RjlmOXU5U1hSUkZ6VUdjMVkrTzhZVWFJelp4KzVkRVRvVVIzU0g0bUx6aDVZ?=
 =?utf-8?B?QnZYY3ppc0p3dTFYNEZwVy9KLy9lZzlUWE9LWC9tYmFGM0FuaTFhT09nd3lZ?=
 =?utf-8?B?VVB1bEhhVmRxVzM0S0ttZ01XWTBwQlFpdDBSZVNUdG4xa0RXSFdWUURnWWpS?=
 =?utf-8?B?azFTK2MxS0h6bS9KSE14WGtiZmVISkpmdGtFRzdyakxaSGNockVpWmdnYVFm?=
 =?utf-8?B?aXlGcmpKRFFkeTM4bjE3amJaWDZHQXplcWhjcmxjYU5YdGg0MUJ3K01rNVY1?=
 =?utf-8?B?TlUwd1VtNjdlVmFEMC94T3NwdG9RcDA1eFNJY2NCZGYwTllwUHpIWlk1WjdC?=
 =?utf-8?B?UWxvdFdpczBkYXorUkthcXN2b1hnQU9FSUkwMHFHYjNmclAwbTM5QzAyYlVS?=
 =?utf-8?B?ditpRzA1MnUwTDJld1RuazB2Mlkwb01CNGRHcC9PckFnZzZtUExJVEljeWVs?=
 =?utf-8?B?ZEhBelJvZVpCSnUrR2NyQmNmQWZKV3M3Z2xURDBadi9LajlTMGhVaXRuNEJ2?=
 =?utf-8?B?WFNNMnpVaHE0MENZQ1F5N2ZGdkR1R2FscVdwcGZ0QmpoSUdpMU8vZUtDNHpB?=
 =?utf-8?B?L25KSEVyWi9JaURPSDFYb3ozTEhBOHFLSTRUN0xrSk1oa0Y0MUNrdm9hcDls?=
 =?utf-8?B?dkgvaW15S3dKT0xKMCttaEpXdGx5ZzR6S1MweVhvczZ0RmJGN3pPdmtmcVpF?=
 =?utf-8?B?VGNxUmRESHZURS9kME9VSGhmaEhRVU55SFFkL0tYTEZGWkYzcVl0WFMvRHZn?=
 =?utf-8?Q?SfABguL/g2M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6363.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVZCZ0cya3ZvalV4Um5qQ3NvWXRjZmU2VXBuTDkveU1lVVh1Z1JXV2dlckdj?=
 =?utf-8?B?U1pobzBOZVVZcDdJMnJlQlpiVnFEMXdKUWE0Y2dKdHp0Q1JSVnhuUGV2cmpM?=
 =?utf-8?B?Y3V2dCsyeVgvTG1CVHJUOVl5VVlqSFlWU2tURWQybTVrcXpPYjVwd2hveEho?=
 =?utf-8?B?dFZ4L0FjbGdSZXVSZ3pFK0JDWGc4cWdJOVZxanlZcDNwUmMyZ25kOXJaYWhE?=
 =?utf-8?B?ZUJTeTd6THNHc2JCaUpXbHpld3NrZWJ2c2NGYjVFeVVzSmc3ZllleHB3Zm43?=
 =?utf-8?B?aldaRm8yM2NOazZZR0lHa2tzdXlmOUxRQkRmbXY5Uys5Y3pySXRXZlhFWHhU?=
 =?utf-8?B?b1NlT2pvc0FYb0F4Sk1kTFNPblFhMVNFR1M2aW0rbEVyT3ZJMWZuZTFTMmhh?=
 =?utf-8?B?eDBFbVZ6N0lVNE1UTDV1TnNuN1VmV2xpcnFpSlh0bGhKalRsdFVDdnhBZXVM?=
 =?utf-8?B?UEtPNGljejBKZWpQVmdkT2MvbFgySVlmU3h3REJnUTRuK1cxVjVjQStBSmV0?=
 =?utf-8?B?c21BU3JoK3h1ZDZ0eTcvUnZZQnRRNTQrWWtKMXpVcmJLRTR5OWhXdVVhM3hQ?=
 =?utf-8?B?MnB1UmhOcU5vZVhSMnBDSkxiSzgrbTY5OENwamprRzVYckQ5VlIzRHluR1or?=
 =?utf-8?B?VjNwcG9GYk0wQUN4N1dpVWk2akZZcWN5MnlpQ1dOdmhDNVFlSW8vNitXdXBR?=
 =?utf-8?B?UWxxcFNTbW9Za2NBUStUN2p6bHduUTRGTXBOMmN1NExjbUdGRTFZVWl6NTIx?=
 =?utf-8?B?Z1phdmt3UndyenBhTWpLSFcwL05TMXBBY1NFRTl0ZjA3cVREQzMySy92cEY4?=
 =?utf-8?B?eGYrRUR0Rk92clpIZ3VyNFBXOUx1UHBCUWpZelY4MjdZYzk3UmJ0d3I4TTBN?=
 =?utf-8?B?aDdTZkxtMEdGQ21YdW95aSttNU1rWmNSbHV3Uk9LYVF1NmpyYTRrTGNEY2g5?=
 =?utf-8?B?TUtiMEw3ZGQ0YnVBNFRHQmJnTTBRMGZUQUg0aXo2elFENXBheElyWHE5azVH?=
 =?utf-8?B?Qll5Q1Zlc3JPUjZxc005WjZ1eUJxSU84VDdvNXdXOUh4M2FHN2IyWkwyRVNB?=
 =?utf-8?B?VktmRG9vODJEODJoVUVqWFl0cldxaVFJT0dKUytobjUxa1J1dFlvY1BMWHJY?=
 =?utf-8?B?bGFrb2RJUi90VnVlcWVnQ05wcnY1V0ovTnVNazlwVkYxQjU4VHQ5aUMrKzVR?=
 =?utf-8?B?c1puOVFDTDZSVm5RdnU0WjdHdXpQT3R1eWRqc0VsYk9HSlVkcWdVc1IxdzNl?=
 =?utf-8?B?cVpFb0tlbm1VMUxtZ1FDT0o0d1NhbnRPa0JYYXNJT1lmRVBDa0NYaFNOUlVj?=
 =?utf-8?B?Z2pDRDE5cWhEcXRwNnBMOHZnSncyaU9aWFlPdWpzR1RxNGlhYk5QQ3JIMXBW?=
 =?utf-8?B?RmtDd1F6NEdWc1lZREhWaVlLeEJYRFoyLzhaek9hMEJwTVViU01KeDRibm9D?=
 =?utf-8?B?ckxkM0R2SkVZZW90TzJpSzFjMTk5YXBCN2xTaHBqYVRzUE5BRG04U0hGTWVs?=
 =?utf-8?B?RHFKYkRxN2tnYkU0NU9udk9tVzlrWkNGV0xteHI1THp6SW04V0NHZzY2RUpK?=
 =?utf-8?B?QjRDbjZzZnpldlZyTWJmSmxIUnpZeWZYSUxMb1QwNVVPWFFITzMvSFd1Qm9T?=
 =?utf-8?B?OTFOQm16d1VEdmpWMXg1OHBDYzVmRGIvSDAyY1BEcTEyRXYzdEw5ME0xdFI2?=
 =?utf-8?B?RWcrZkVUWWdCeG9nQmR2dllMbnpWKzZtK1p6dThtNXkwRTVhck9CTElCWGJ6?=
 =?utf-8?B?NDRJL01ET3NDeHFkVlc2WHloZGtrSHFOWC9TcXExeXc5NGJNR2pJd2JNRnhv?=
 =?utf-8?B?T05WS1NjTUgyMWRYbGJsZERNUnJrb01meWt2Vm1FZjYrR0Q0Tm1ScFduUGZG?=
 =?utf-8?B?MkVzV3k1cGw2SGlQcWUveWJVcGdDZHJDeUN0dnlMMEtPV1FBZ28vbW5COVNi?=
 =?utf-8?B?VGZKbFhJOVZ1bFpmdE02aFV4M29QbFVzYzZuNW1TRXRRbVREQXpJeTlZWlYz?=
 =?utf-8?B?L2xrWENDZXpjY3pOMmZxQkUwdmZPbU5MNjZJd0luRWtING9Pa3BXOHNranJI?=
 =?utf-8?B?M2hYZGM0NytzWFUvbXpJTnd1Z3FCUElLMjY0Nys3bE5MRVFXVVMyVXVxbE9Z?=
 =?utf-8?Q?SWife2/d8KuFXsYH1+stYFmwI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed37dd7-9e89-49ad-3745-08dd8b02826a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6363.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2025 11:55:05.4053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9MufaYSRBOZUOD2iwc/gHA70FCoWLqiNO3s34kratVn09HWniNwysvu3zxdJN9116kNiyndd9vSxi42NyXupw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5983

On 29/04/2025 19:38, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ming Lei <ming.lei@redhat.com>
> 
> [ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]
> 
> We call io_uring_cmd_complete_in_task() to schedule task_work for handling
> UBLK_U_IO_NEED_GET_DATA.
> 
> This way is really not necessary because the current context is exactly
> the ublk queue context, so call ublk_dispatch_req() directly for handling
> UBLK_U_IO_NEED_GET_DATA.
> 
> Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
> Tested-by: Jared Holzman <jholzman@nvidia.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/block/ublk_drv.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 437297022dcfa..c7761a5cfeec0 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
>  	mutex_unlock(&ub->mutex);
>  }
>  
> -static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
> -		int tag)
> -{
> -	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
> -	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
> -
> -	ublk_queue_cmd(ubq, req);
> -}
> -
>  static inline int ublk_check_cmd_op(u32 cmd_op)
>  {
>  	u32 ioc_type = _IOC_TYPE(cmd_op);
> @@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>  		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
>  			goto out;
>  		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
> -		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
> -		break;
> +		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
> +		ublk_dispatch_req(ubq, req, issue_flags);
> +		return -EIOCBQUEUED;
>  	default:
>  		goto out;
>  	}

Hi Greg,

Will you also be backporting "ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd" to 6.14-stable?

Thanks,

Jared
