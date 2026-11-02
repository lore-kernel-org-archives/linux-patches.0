Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793630077;
	b=Tnlc5I0rxTrLJNO4+rdp/na6dfylBE8WtlLdIrP7Hose1BvfXKpyIkUTCx7XcjeKJGXh
	 U4I9HkPLVbsPc1PvaJ57MjXUSqde7ff9MxSsOdx8McpkWb/oNBLFjLB6+bP/sb8RCmC7f
	 N6HJyqLgrMs1rUgrU7gBR+iKodeV1WyOpEWgtWY7FizLKk+NybkeENPFiyh12S+vIjVVP
	 fSg+/j3K/Np+Sn9VL7FOH+NsMDaejnjYp3x87Ko8N8N2X67d3utHL5KMi5R4ofa4efpDP
	 IXGfZ9HOYrezzpIf5vQKNG1X+Lod/PyDWe35eSmikZvFThT3bVDjfq7xiny+qgz1Yow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630077;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=lbskhWKo7SJ+/nWE+q8G4ds/sA/PEX5/Gei4+WgGXE4=;
	b=ElGx1agRnIWlZ8XMvuJiEZ9PU9bOZG+KsvszHRzDRDJQ6ybuznkMb+9VeDRx1R12+5Qv
	 GZ3ocwcQaDadzNJdIJeho2DZIdNCVH2XQ+y7bIaq3AFBU4KK8xuSrIKei+/Tauj7uuqmt
	 FHBSts08Jwes1NwMYDUeabP3S15yYvd2XCcXNz43w2ib3uGANlDpZXn91Uyk3BPmJq3S3
	 WFb7dAzq5CziFO/EaJs1ElrruUlGms8FYv5nZ5ACYofr1EZZllwZKxYr509mdPo4BDJx9
	 xUE9QL8ovKA6PbLTi5gLlwrl1vpUEsUffoNRcv0YDo7wd+IqS0UO8seIgv5e7UbXEVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SkXKPFJz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.65
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012065.outbound.protection.outlook.com [40.107.209.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5990606B1FE
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 14:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5990606B1FE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SkXKPFJz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6QDKdT9RigvT+gkuCTs0PFMxc7WmSJQHau+O0U/ABf8eG5H7N6g73ROAygUduNDNtOJJQT8KeX/JeMfJz9bsATRdLpDUHxm7IoNAaL1vb7ciaO0fQAZNhMmFLah6cSzJb0pBuuo5CE03lVuAKnYHpzHiVVTG+WfZAhrIys4TwJ7xiMOYj+vmfTzw5SbfUPRZkYMob8+7/cdna+3cNli+nea3drVa4KRH3c0hzkZ5e8Csov9zrtFSHFa9V6XQaG3UwLmkbkfZIXQwsq56lNmb0+EBA/32Vv2s0RbdyCVQq5GMiicb5Aiiv/mQ6l0/jKKc2jbtd8oOJIXQtZtMLvpWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbskhWKo7SJ+/nWE+q8G4ds/sA/PEX5/Gei4+WgGXE4=;
 b=JSr2etTxfCTpzviRc1yK3e6xHBLvJtAk9k1a1a7asAtUNyVGmkRD2oC7kEApBLr8OuGzzfK7bZ0j4MOup1OWu5hcN6gpEKQREWDfSZXVdWfabRUShvv5AerrqBrag8WFwHoSwJPSoRB3CHX6OyaXUmnjQMGBdyL21JJ2xEMTbX3HLUqbdahAObNIugZH9UjaqfOCf41EwbhMFOy/MOP+zDyLC3fzmF/A+ZH3PUqT9H4mWGlezy12z2dydoivFSR38uPJiLaEETIRSmM7auBUFkC5/yJRPYvoXCmvdgqlyMr8pffiAbG6owjmetQnedbDou2clYf2VRoO+17VM2XB+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbskhWKo7SJ+/nWE+q8G4ds/sA/PEX5/Gei4+WgGXE4=;
 b=SkXKPFJzgaxsi4gJ7nVdLcfxBestR0G0vVZs9GIn5NXGt301uewjIvMBcz/yWtG0GGEHPuFJ5xS3cCWaEO+R2RblVxSHa875hY3Ariy9Ub5gj52meLXKCK2zNS1QOXR4Tqe7C6Cu9Lqg2vqX3vdguUkdzJuIKg961voY+Ab4JAHSeh7tAEKcF0alR33EdWLzxX7eK6MXKVEfMy+CYD2FBYruuUVsOXTwHFQ0kRPH41QdD0MbBUYKWGcQGlAK+K6KIPtifuo28qEoiAmV55duscGTTxM+Vz+ZGvib5xu2WYrr8VynO5wkycLpWn/hPzkKO0HFvOJJcAxCBuz3NwhWtg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by CH3PR12MB8993.namprd12.prod.outlook.com (2603:10b6:610:17b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 14:34:13 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 14:34:11 +0000
Message-ID: <6051255d-96cd-41eb-878b-a4e2e6ccdd7d@nvidia.com>
Date: Mon, 2 Nov 2026 14:34:04 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20261029073135.159947193@linuxfoundation.org>
 <b85e0697-d669-4b14-859f-52ee295264e4@rnnvmail201.nvidia.com>
 <80816b31-948c-45a8-9f98-4cc55f5bd530@nvidia.com>
 <7e927599-10b7-44f4-828f-e50c0caf5f27@nvidia.com>
 <2026110101-carnivore-harsh-fe38@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2026110101-carnivore-harsh-fe38@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::14) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|CH3PR12MB8993:EE_
X-MS-Office365-Filtering-Correlation-Id: 665311ab-f091-4021-fdba-08df38ee5c71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|10070799003|18002099003|22082099003|56012099006|10067099003|261009223027099003|261022105027099003|4143699003|11063799006|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	pw4Ngjy5iaecyhbqSpXmCF4enFjzXHwrFDhvETFdAEuO3WtGrFepiEPGeBGv4KQZ3X6cHToEl2lu/AHuQhIBmBGyqg3cVz5EQ9ddI26QWuWg6nhVX2AR8Ay+/F4y95pK5WjwM2mSMG7oDMf3YEqKMNIwQoXvklqR0/Dwxmck4/8uXjyI7+/gDdB7TFXVAathEIuFMX06QZypiW0CA81uSWojZ327JTWlnILMfGCjwJTO8qnJ5Xen2Bs3CudXDkEkmcA7UFotbaU+FG3IRKWSx8LOuqxjxTa7bmKx6yVA8/rBXRCMqlD90trrCDzPyf1MVDeHi4Xs6eZIT/jqbsw6hgYd7WepPJeYCeElvocJATwex5ElQ10oaX6C3isIn9mkGZ/rnTSDULdWj+JT3/y2VF70+O5G1Bl8DJy3iiLBduUTkXv8353Ao47XD1B4Qu/7UKPvISZMEO3ct/LADDV2bBwAx/LL4ltIMNYIfUo4VvOHEz4zeoejDZKkb1CGF1nu3agmiHWM5Qk9Yf6KuEUC6rzEwvBx3UkKxPaREZt+JJkYrH6v10zECVnC+c/OyZtY7FseCvcH0iL275obzhaWxW2YrEEcyy7l80S0JwW3Knx7CJVSWnszrNMQHR5b/SJDQtmOXTfspeCYHWc16yQokqMKrq5aovu5aZoMl6IH1Bo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(10070799003)(18002099003)(22082099003)(56012099006)(10067099003)(261009223027099003)(261022105027099003)(4143699003)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXI1eEdPYVpFOEpQQzNSSXJDTm9uaVI1Y0lySEt3VEh6RlExK0dxTytlVmxU?=
 =?utf-8?B?MDlkVmxtWjZpOUM3ZVQ2Vnk4bkwrRkdDVXRCa3pzMk1XQUw0cDdqbjQ3UHpJ?=
 =?utf-8?B?dGhMT2s3cmN1WlZPbFVBQW1hdHBnZ3hEaVB0R0F6Q3hRK21iTmxpZ3dnaXkz?=
 =?utf-8?B?OXdObnlaL3lrZVdvem1mK0V2Zk4wdWdVdHhBdEtMSDFDTVcyVXd3anpPb2JG?=
 =?utf-8?B?UlNHQ3VaRUZVcStSUTFoVEhyWVYwQUx4ZzFReThrYmd4elRJR2pUZTdNSWFT?=
 =?utf-8?B?NUQyQkJxeFpQWmRONnJVT0xwSG5ldk1pMndDNFV4ODAvZlE2a2cwR3FJc0Vy?=
 =?utf-8?B?UDExWmwveHpIdTMrS0Y2aGtzSm1QV1BsUG4xdVhYbVhnejh4SUt4Rmdkb0Iy?=
 =?utf-8?B?M1luTGJvb3Y5SUNsQXRraHlMM3B6bWZrNmw1VmFxUWs0SWNNbnZRWVIvV3RN?=
 =?utf-8?B?ZERkQzRyU2p2NkV2ckVxSmpoZm1zazh5bkhLNnl5aTBzbjA4Z2dMb3NxZEM0?=
 =?utf-8?B?SkJsc01yS1ZrU3BzT2lyT1Z4VWYwNC93RC9KZDYwbkFKQngrTUxQeUlBQVhM?=
 =?utf-8?B?VmZLS3gyMkQxZ3RMUjl6TlI3L2Z2RVR0SGxMSWQ0TUp6RGttREQxRTZybFBK?=
 =?utf-8?B?OFVCUGkyd2FsdjM2cFRldU1WcG1oZ0FzMExjYXFvOThxTDQyajIyd2J3YW5q?=
 =?utf-8?B?R0NCaTIvNUJQVFlTSjdSbVBjeHNNREF6M1dqN2Z3NnhLTG5NcTlZUnFpTWNT?=
 =?utf-8?B?RkFieU02U0lnVkRWcS9YLzRkMlA3WkhaMStGYk1hYWZQR1VZYlNJWEp3V2do?=
 =?utf-8?B?b3F1K1VRd0s1QjhUNCt3aDZsYlBCaVVVYzFVYzE4MFpXR3NiUzFSbWFocksr?=
 =?utf-8?B?c2lPOHgrMU9lSGQrc3BtRmRHQnQ3YUd4UmQ2OXN5OGlxK2dqMlN5K05iR0Vp?=
 =?utf-8?B?bHAxdm84bFdkd0lnL3FPS2ZEZmRwelI4VU1aLzNuUnIvR2svWGtmVEJMSlBa?=
 =?utf-8?B?dU50RlBPUU4zeVFaNWtodWlGMEJ0ekxqNHhoeW1JamtZQmt1M0lMVWZyQkJn?=
 =?utf-8?B?T0E1SnltSFRyVWRiS3BUSGlJL3hiTkhkaDQ2UVJsYnpYY0RSeDRJVTJwYlEx?=
 =?utf-8?B?UC9UNlZVdEY4REtsN1gyWjdNOWZ1eUM2WHFkVStGbmZseExqQVhVOWlXd1pw?=
 =?utf-8?B?Tlk2M25OcndWQkRnUThLejV1OHNhYTVqcjMvMmJoeWxya0wyZjZnYlFOOURE?=
 =?utf-8?B?ajZCcC96Mis3d2JkdzlRL3N6TFJldXRNaFlVN3JtVEIvbWZ3SHBiZ3BqcVB2?=
 =?utf-8?B?N2RsdDA1aUMvNzhsNDJncWEyRkFEVTFYOVBpemRmUDVodXVjZkloWkxxd2tH?=
 =?utf-8?B?WENCTExuVU9UUlgvUllONlBuRlJjejlTZ3ZWRFFGMWFoNlBBRitHQWMzWDJj?=
 =?utf-8?B?emIxL0x1Q21uN2R0WHFrUEE1ZW1nTGxKQ0M3ZXVMb0NCWDN5SWpzNmx0Q2lI?=
 =?utf-8?B?K2tNa3JIMFhIUURmZXdJY1FjbzlFKzNyQ0x3QUk4cVFrVDRWQ1RCYjcwWG5Y?=
 =?utf-8?B?YmwwMlFPQjhQTlI4TlRPK3VZZDZSbFYyWDNNb1dVbU1rM1ZIeGthWVNPNnBY?=
 =?utf-8?B?UDFIaXBENGVTUFFvS3JWVlczdUVRbmllMDZFRHFVbE5KR3I1WER1WndRMlZ5?=
 =?utf-8?B?amI1eitoUURJVVAzL3g5ZkFqZzdxclFCUmZOd0FIcTJjNktvUU40TE1pWStW?=
 =?utf-8?B?ZjF2M2FhUlpsREN2bHNQeWtndnNYY3REbW5oRTU3Y1QzdzhEbXozRW4ySE9W?=
 =?utf-8?B?L1IwR0hlb3JERE1QTWNzekFXaVgxRVd3dnNicVRqbXpyMHdEd2dGWXh5Y2g2?=
 =?utf-8?B?OXlDak92RXROZjRXVnFvQzVJaVUyN3g0TzhOaUMrWEs0d2MxaVVqQzB5ckpK?=
 =?utf-8?B?N1kwc0tvbFlqbUtjMVhDamhoaVBPcllNUWZ5bk9pNjRNUHM1T2dBU09BV1FY?=
 =?utf-8?B?bDJhRlVXclV5amRuSENWUFJ4SW9GeThVbnFuMkUrNTdHd0hXU3RQMm83dGZX?=
 =?utf-8?B?V0Y4UEdkMENSeE9pcUYvWTUxR0o1cEtjMCs4N0p3elVYUjdHeWNZZExCNDF6?=
 =?utf-8?B?SDRWL1h0WSt0WEdwUXNCczY4cStTdmEwTTB5djdZcjZCeU4vaDN2U0Yvd3ls?=
 =?utf-8?B?NWtZWXlFZkxSQlJDUDlmQ1k3Y2NTaStSWVFVd2FQZ1NscFRhVERHWlNyZ0F6?=
 =?utf-8?B?a1BrcXlmanBYUC81SlgxZFAwNWRudFRBYjdqQzlXZXQremxBWEl1c2RXVGhS?=
 =?utf-8?B?cXhVblRhZnpxZFVQQkEzWjZtTGpodlo5ZEV4UWMyWWZZM2duNE1UMzVtVGd5?=
 =?utf-8?Q?MJiJFpNoXxFm2B4rFbAnj1MZC7RnspswxPd+Ud3zAU1Xq?=
X-MS-Exchange-AntiSpam-MessageData-1: H1Ncx93+sOu5bw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665311ab-f091-4021-fdba-08df38ee5c71
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 14:34:11.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7V2zC7Qil0ceEN1Dgkd7eDRB2aJfveQBid77YWm+CwwulfZyb0Ey/Eyap1niTrkjR6FpZxp8LacVmcRkivOMow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8993


On 01/11/2026 13:22, Greg Kroah-Hartman wrote:
> On Sat, Oct 31, 2026 at 02:41:43PM +0000, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 31/10/2026 09:26, Jon Hunter wrote:
>>
>> ...
>>
>>> On 31/10/2026 09:24, Jon Hunter wrote:
>>>> On Thu, 29 Oct 2026 08:33:04 +0100, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 6.1.191 release.
>>>>> There are 1879 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc2.gz
>>>>> or in the git tree and branch at:
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Failures detected for Tegra ...
>>>>
>>>> Test results for stable-v6.1:
>>>>     builds:	9 pass, 0 fail
>>>>     boots:	28 pass, 4 fail
>>>>     tests:	83 pass, 7 fail
>>>>
>>>> Linux version:	6.1.191-rc2-g3b00df762ebc
>>>> Boards tested:	tegra20-ventana
>>>>                 tegra30-cardhu-a04
>>>>                 tegra124-jetson-tk1
>>>>                 tegra210-p2371-2180
>>>>                 tegra210-p3450-0000
>>>>                 tegra186-p2771-0000
>>>>                 tegra186-p3509-0000+p3636-0001
>>>>                 tegra194-p2972-0000
>>>>                 tegra194-p3509-0000+p3668-0000
>>>>
>>>> Boot failures:	tegra186-p2771-0000, tegra186-p3509-0000+p3636-0001,
>>>>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000
>>>>
>>>> Test failures:	tegra124-jetson-tk1: pm-system-suspend.sh
>>>>                 tegra20-ventana: pm-system-suspend.sh
>>>>                 tegra30-cardhu-a04: pm-system-suspend.sh
>>> I am looking into the above boot and suspend issues and will let you
>>> know what I find.
>>
>> Bisecting is pointing to the below commit and reverting it fixes
>> the above issues ...
>>
>> # first bad commit: [26c5e136ba4e94ad708333c9bd34039a1de397b0] net: stmmac: protect updates of 64-bit statistics counters
> 
> Thanks, I've reverted that one now.

Thanks. It turns out that there are two issue here; one causing the
above boot failures and one causing the above suspend failures. I had
thought it was the same issue but now I see that suspend is still failing.

To fix the suspend issue I also needed to revert ...

 commit 3d64d18bdd1b2a6bd4af1176a596736b233606be
 Author: Rob Clark <robdclark@chromium.org>
 Date:   Mon Aug 7 10:11:40 2023 -0700

     interconnect: Fix locking for runpm vs reclaim

The above commit is dependent upon the following and so I had to revert
the following too ...

 commit da051a8d3d67bb039a26bac02f439c316ac0151a
 Author: Mike Tipton <quic_mdtipton@quicinc.com>
 Date:   Tue Mar 5 14:56:52 2024 -0800

     interconnect: Don't access req_list while it's being manipulated

So to fix all issues, I needed to revert 3 commits in total (commit
26c5e136ba4e94ad708333c9bd34039a1de397b0 plus the above 2 commits).

Jon

-- 
nvpublic

