Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793630114;
	b=KjZY1s8LHge6GRz+MVTW6hymUXZNiT5D2tSIFicsnn+kqYb2kTi1igvL6+TQYUoPgZFS
	 +wrvgdhnyacWIwAEZPaz6Ed3D+634LdSJl6jRXSiuvG5jsg8NXskvxtLucVG/uCxx91Bb
	 8fC9gumQUM1vOgEQssdRKr6KPRShTCqzTk8JglZqZnjObADroRsZdnEFiIbDQlTWGVgiA
	 6yO+8Sh6DaNKuqO5fpkti1wsl/h8BOZBqybdZiMMXa32JbpoKiW51/EqazGf1Y55+TpZe
	 F4zOduKTWz6ZiRfVo84P5BeVqSdFhtdp5cdn7yu/l7IVYc/juPvscT1qjsAZt8zRV4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630114;
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
	bh=rupN/sT29C4eU0vKuIj8zAM9Gi0NaOKcPrh3qaoT1Hg=;
	b=Sjh9U6rHqFmzqD+JyDSC65CwEvnYz+GF0rubclCzodEruHXPaWcJxT1VT3HZsZn32iDZ
	 AHBaswZs2jb0HI3EYbRaqViddhlK9Q6nDPMTkrOsMyz1a0dfXA10j6inxwfrHL+2aU8bU
	 59TrJeuXD61Z2Gdtemdv34Dkeqfr8AVh2NkFtPy8TBzSgYKLgE3t3780EkRSyHicLIrNt
	 jvnipTqdv0bLQTS4dFv4jdUvtguZtIh8v90lvrOBwhjAdZn36EFpKIA6OkhWkfMiRNmo+
	 03Aj0cjSH7oWrywwH7T17D6jMa5AAwUDLIxkSqJMHZ7GXxHakj0FQ7PaZJruRgH7RHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=f8iO9D+6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.1
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012001.outbound.protection.outlook.com [40.107.209.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8C96076707
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 14:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B8C96076707
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=f8iO9D+6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gKKb8vL8FQOqcHRhDrquBwnzwaQMYBYO7VTwjKKEJfdjfnXEs3pXfRhxvfOxdHzfiAPwqO5kiysYQ2xl+kR2NcSWdyKkC/thp4p+xQDggd7uBDdq4L/ElIUGydD7MWNS0TdxP6QJ0KoGRb6vnrit5X2mx3yElpOLz5P4DW2bHDVD6ssca7+zH6V53jOCjs+HQxXzr2D1tOLfDKrfEHNUeMfmpZ33T+gjIbkA/S5GxN11DYy4q6vmkiE/Xa/W9TGcIxSux3ElH44kcB7ol7rxRsw+aeGJvvPlRA4uy9uNrsJ81CQNLonrixwI3JKgKy8m0nqQwQJvfHmacNbPrnJS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rupN/sT29C4eU0vKuIj8zAM9Gi0NaOKcPrh3qaoT1Hg=;
 b=hGe0zcpLz4j3KXFD4aGX9YsORS90Mga315ZIzdiz28pj9pCnpAuBCOOuq/2IeIG1pKiSPQ69qSTe+jSnKOWjrGwOX3QQRkdzxJ/Uziz+lMm4CKNZ+qKN2/twwgvEO/jJHSPSkF408XBb1LByR2rLuS6ejl76a5MnfFV6WRCz5PNdJX4acdhAeDOUD2ImysDzrCB714UyGcoZWa2j9v3Z5cx+7QAYTL9A7oJB6YbQbFNW7aHqBoRKDvvHMBm75wvh0P7cg3wAVVsFrs9Vj05VVw06DmHuRuEZzmlCQXDe9dmJOXdxIZ+uC/t3dIxmZO2JljYd8DtmHvioglTssxOuFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rupN/sT29C4eU0vKuIj8zAM9Gi0NaOKcPrh3qaoT1Hg=;
 b=f8iO9D+60O6xNth7IoMDY6lZHL1E9qDiXe6ceCurQ86Hdo5bGBXI7nBck31rlQKK2P8MUtB74YYSc9+te10bv3uWx31uZ3eAjUwJj+CnwkVXv/jCCNXXgyRtWOnSRwXtjPwfkwZnDDB4XQf/HTgm+BlwS8P7vnEUGgn5b3lcOzaq29W9i30Usxds/uFl3OBqHDDJsR5ogLN2XIftDf5z0+lJGa6tuv6gh5AI3wpEZXkyTZKzfVaaMAZr0qOUbTv5j3BeM0ONS588pwOl3TszJ3IR8zI07dYajNj+uH0WIFuOih06FKxpVGl4lV7tT0DqCHwunvFAfNK8V4T6Fuc3iQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by CH1PPFDA9B3771F.namprd12.prod.outlook.com (2603:10b6:61f:fc00::626) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.35; Mon, 2 Nov
 2026 14:35:07 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 14:35:06 +0000
Message-ID: <8fd15777-fc45-4293-8255-c8d3d28a8156@nvidia.com>
Date: Mon, 2 Nov 2026 14:34:59 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <7e927599-10b7-44f4-828f-e50c0caf5f27@nvidia.com>
 <2026-11-01-1-daily-reply-0001-stmmac-tegra-6-1@kernel.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2026-11-01-1-daily-reply-0001-stmmac-tegra-6-1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::30) To PH8PR12MB7110.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|CH1PPFDA9B3771F:EE_
X-MS-Office365-Filtering-Correlation-Id: a10223d4-d8bd-4166-63c7-08df38ee7cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|10070799003|23010399003|376014|366016|18002099003|261026121527099003|261009223027099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	jw4I44JIf9Bmdm+VCaHcJ/pHb/yZ+mWJJn8zX85Lopav4Y54NdteZETTglXu6jiuqZbVM2touQCH3VmLkJIF/FMprTJHZaMIfk1bhHrMU5E6ULm9lxWI809wRHFJWRwGOw3jKM7r4OsQQi2Vaf77BYZSr1WAsWG6HFRcx7hSYtxsEnyQn+2kYoUEKkPRuNEYwGWTWoFFEGzhVPnEuN/jI+zO3+78aHYn/AfgbUEY03LcL9oPL1w2sW3CDmw8xuSK2bEZE63mLbjmKrFurID2/ziC1ugKU7cKAthehLR/wTq2w6hr/+LAJh0x/jFqA3CdOdhLKv0JxxiCOrJWOu4m8xoWabtRwD+CjnOWI03nKk7jVSl418OhlKz9AteZLmv+/RoYjBdiTS9OzShY7HjwRRLQ7CZskP1FBhjSXjhPVYPRua7vLGcAsp8xQgX6TVYqatTc64Q7RIlhPluwnmx7+GTWY8xQ60S4NmiiniWzbwILZY1yuyiOqb68IpY6wNCr0ONUAC+lU07VPJKQZmdMzEmA/vFgdBi2w5pyKtZX0w0C5adk6fSxxQS819AgBOHdZZCGJ8VIM1No/8IORWJFgkH898Uquuy6PZ5ZkiWtDRZwvIoOJqpe/jkpg7X7y9myIU8WMoBa+Ck4U7tfMW2htO7kwpp1buggk938FtSnjk0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(10070799003)(23010399003)(376014)(366016)(18002099003)(261026121527099003)(261009223027099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEc3ZXNVdWJZWGdiYnc4eTNENzRHei9mYmRkMEU1c2p3bDdraVlHOU5jWHZP?=
 =?utf-8?B?clpWMW5LY0xPaGdBS2Q0bU91T2FkMnpieit3MmVKRGZMOFpOWTBUT2o4QWdK?=
 =?utf-8?B?aHlTR1JWYlRlMnBiMURweHFWWEFXbzNNSHlad1lIVFlrV2Vzb1JWM3E3TW1Y?=
 =?utf-8?B?QU0wQXlsQ1gzVlZydFRaejR5eWlhTGdSODJUTXRYcFR6OVBMUmtwUnpYcVRH?=
 =?utf-8?B?SGF6Vmhxc2gvNEFyZ3REd28vRDhVdmJUZHNZelNWb21nSzROV0EwckFVaVVl?=
 =?utf-8?B?TTdWZmwweEFWYSs3NmJCeHVhdjMrcDZaZmpneEpCblRva0twUTJUdXMrY2FD?=
 =?utf-8?B?TDludlZJeGZxcUZFZnFabTJkelJzbFM2RlVQdVAweWtIN1AzazFQUmhhV0R2?=
 =?utf-8?B?aDZFT3NCa2JBQmczMWtvZWpwTW0yTE1saDYwa3dKZElOQmlKaTZXUEFmR29l?=
 =?utf-8?B?UnVZdFUwalZCSnZHYkF5V0pnL2NQNzJNcC9Ybm5XdGhsblFkK29KdzVXQTZm?=
 =?utf-8?B?emZBdXh5V1BSa1N2Vktyd3kwSi9KQWhRTVhNbTlyY29WYkZ0RmVxL1pQTlRh?=
 =?utf-8?B?RWhyRHp4VUNybis1aWY1eEN6RTFhbXpUTThUbjRnVEhEdnFhZWpxMkEwbzFp?=
 =?utf-8?B?ZVFlOWx0M05pbUJjYUkza3AxSGIyb0l2OTQ2N3RtN1JJckg2MS9TNnAzdndj?=
 =?utf-8?B?RHRmRVhTQ0FXYUJjNkFqNDJwd3RoeXM2c1pub004VWNscWdoVmcrWVJ2eW8v?=
 =?utf-8?B?OVlXZEU4Q0ZQaERCKzQ3aUpQWGN3aVFjTmdKdGUrQkwyMXVkSFhNdXVONkdy?=
 =?utf-8?B?aWlnSmJLNnN6MUF1RlZ6ZURYNXBiVGxiOGUvRTlwOTUrNTBST2h0RkQvS3Ni?=
 =?utf-8?B?WS9oWlcyeG4raEdqVDg3N3pQb1RRcWUveDlLR2VleTl6ditESC9sdWkwbXJY?=
 =?utf-8?B?bGd4SUpZS1FBYzBnaC9RQ0plQVNFanNydDhmN0JBQjdPdnJJL00vSWVsREdE?=
 =?utf-8?B?bUVKZW4wNE1TZWJaYUh0SlhsRmRDVWswdGNCSW5YdEJyYytkWW4yZmNDdEIv?=
 =?utf-8?B?REdPQXE0YXM5KzhtQlZDQk5STThmU3NWQ01XcEJoQXlqUEdhQysyUFZzSlRs?=
 =?utf-8?B?S0ZCRm94Vk9TTDAycmg4eVpRWW5IUDBObkFYUTVrNGc0Vkd2TFJMVjduVlBi?=
 =?utf-8?B?VS82MUdjRkZ1QTNkYmRiSXZlOEFhQXFNNFI5UUtLNjlnclN6dG9FY0ZpeTIy?=
 =?utf-8?B?blN4RFpUMDl6bm4rMStvSlJzOU9VTTFDMEl3ZVNRWU1QbExPcFI4RFgrcW1p?=
 =?utf-8?B?ZG1vY0JqNHhyWVQyNjJNUmVKVnloN016ajdSeVQvbXNsN3JCcS9RcEFGYzRM?=
 =?utf-8?B?VFZtVVVkSldVQXJmQm5GYm91eEhEYjlxTFM3QVJDNlRQWURISXlxdWZmQ0VL?=
 =?utf-8?B?emxFaVNtNXU3b2ZsMFJPNmRiMnJNSENwczJZOW81b29IcDlmMmltZis5Mjk5?=
 =?utf-8?B?SVZzTUVVaVdoVTF4RDdhUnlvWTFpb0FjWlhNQy9uUVlpKytCQkMydVcvcGRZ?=
 =?utf-8?B?K0tkcUFJcnNMMXhnQXZjdW8zbXVRSnF1U3B4UlhTU09ueTlzbVN4UE5ZU3gw?=
 =?utf-8?B?MUZaaGQwN2hSNmJ1VDk0L3hWN2Fld01QS3hWZWl6RmI4K0p6ZjMxQkZ2NlRK?=
 =?utf-8?B?Vi9JVFdqbWRFS1FsanBiaHpnMkNubzN2OGU4Sm5UVWRyNjJ5YjczTzNjUGtm?=
 =?utf-8?B?MXVpdDlnR0E4LzFTWWJkd2lXNWJwS0gyYWNOY2ZtZ3VIbjg3N0NyVWpPY3hT?=
 =?utf-8?B?bVF0TVU1VGlDam5VTmQzVTFqdDVlR09wQ1VKalAyYlBtcW43bGI2MTlJejhy?=
 =?utf-8?B?N0VidWwvSFVPM01VdmFQYnZmL3VtY0VkT0dHdG9Zekp3OThpNm5VbnJJYXVZ?=
 =?utf-8?B?ZVNPMzlaa0ZQNGV4V21DT3k0amQ5Undta1Znbm9sT1ZxQlNLVi9jZEltdkxk?=
 =?utf-8?B?bTI1U0ZrUFMxN2lCR3RLWDlHd2VqRjBpc2g5NVBacGkvQUZrQ1FhUlhJNjZ5?=
 =?utf-8?B?VmplYksxN2JGZVVUTDcwelV2eHAwN0YvYmo5eDR0L04vL01MVGhyS2tyUGVT?=
 =?utf-8?B?YmwxeHY0Rlc5cTJSOEpsdEI5ckd6RWwwYkNicnFkMmRmWGVpWXRRU016MlJ5?=
 =?utf-8?B?QkZUSm1ZM1NFdmF6Z28wZTZVTGdseHdRdTR2a0lnTTFYa3NZRUtMcE1xUG9B?=
 =?utf-8?B?OXpkdkpHQklBbmNCOFhTMU5RaDF4ZFcva0FCUlFzMUk5WFVXNHN2Z2dXdm1X?=
 =?utf-8?B?NHpNMlk2OHVBNXRTSnpsbnliNElWK2g3S3R1OGt4dFFhT1hTa1hUc0k3K01r?=
 =?utf-8?Q?40O4U+WODNlPjuA6XVQ84T6jQKN0ROX9zSBf9SDSeCyFL?=
X-MS-Exchange-AntiSpam-MessageData-1: 5L8O6Ei/em0QLA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a10223d4-d8bd-4166-63c7-08df38ee7cda
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 14:35:06.3548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHX4071HiOHZSjIS6FDrC91m7pzKsi6pn+rDw8IJCC/A7akIZviGwsRFXLf2hgqT+whBzbGWQU/ZeK2N/dLl0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFDA9B3771F


On 01/11/2026 14:43, Sasha Levin wrote:
>> Bisecting is pointing to the below commit and reverting it fixes
>> the above issues ...
>>
>> # first bad commit: [26c5e136ba4e94ad708333c9bd34039a1de397b0] net: stmmac: protect updates of 64-bit statistics counters
> 
> Thanks for bisecting. 6.1 is missing a prerequisite for that backport.
> 
> 38cc3c6dcc09 ("net: stmmac: protect updates of 64-bit statistics
> counters") allocates priv->xstats.pcpu_stats in stmmac_dvr_probe().
> 6.1 does not have 2eb85b750512 ("net: stmmac: don't clear network
> statistics in .ndo_open()"), so the memset() of priv->xstats in
> __stmmac_open() zeroes that pointer on every ifup, and the first DMA
> interrupt on a dwmac4 device (Tegra186/194 EQOS) dereferences a NULL
> percpu pointer.
> 
> Greg has queued a revert of the backport for 6.1, so this goes away in
> the next 6.1 release. 38cc3c6dcc09 can come back to 6.1 later together
> with 2eb85b750512.
> 
> Could you test if adding in 2eb85b750512 fixes the issue?


I confirmed that that does fix it.

Thanks
Jon

-- 
nvpublic

