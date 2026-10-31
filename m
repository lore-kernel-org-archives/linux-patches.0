Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793438801;
	b=xoDmQn2r6052y0Jx4MHRfryu61ewguuA86dj6od0LdEZHayLw6taT/aGxVUHtKC6vVRt
	 MmqYHYV2PnlyoEiPc2tUqDHvlAgpTiRJeK3rpJoITHBKKwXvJPenJODA23UvMfHcpzojK
	 GF/OdsfGzUxw1OaOHOEL+k2DabeuqvjNqMU3MSGLDC9GA7p1uBWAC0JHFSBswPuHp/xV2
	 fv9ixWR4cq+AEyNICEw2pcRHzWdVzQ2EzOS8Y+aMlI1ElTRXH+jC6iordw0Lttcmvcxg/
	 Rv7SWB1nkg7HDWEpRoue3PbA+ihrCZG2AswD7IMiuQ6ZnSGHuSYV0M9RzH6EiLMpyuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438801;
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
	bh=UNxKSJLkMXzmpkPDAv6i9Ygc6x3gD7Jp38/QcgPVnMk=;
	b=MK6xiFRVjd4339zwBD/tFq0KwR2d0QUUW//sq+BFx4UVZT92tgVU+9ZzFZLeQqml01dD
	 JazMvToYAWFXL1BzR0U/+WKlBmInuioylInh9HGC3gGg9iY3NrNRWEhA8iYGwtHbBA39O
	 WyFLJ08ikae1b1+IK3dYxxqKc8McKKRFodw1BwxxubgQMlNFWPC5+bq78TXPuvqm2Blh8
	 JFSxOJmPmWqu2rEzUrnn4yXxxMuvuwGnlnWrV6EIAyFreuP5KRNxLl9LUBYUKcF3H2aT1
	 7uKiu75z3hNFpZfdNGpQGYJ0NDrbA6Pq8S+D2DlM0US8o2VFk5Hlo4CsiTgULGFoJfg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YeGgWKUm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.3
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010003.outbound.protection.outlook.com [52.101.56.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A226606A31C
	for <patches@lists.linux.dev>; Sat, 31 Oct 2026 09:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A226606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YeGgWKUm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcSVAvGQSAAu2wB4dtaYPq3wdbmjzYpzNfDT4WO0vegt9/4n+mlAgx/M7zWfVXzyTyLZuIRjmGwm5I1LcsjF9M0K7SbYXjshvoV7e8hh90QaqsWlpdGM7szBibzJvVoHUMk7jQhkeQF6eccgz5X6sYE6DhYCvpH6QSP6LNexF9Tg2LgbHjNfRHeE+7ZiRAVC+CKFAAg9DkT2eGJ2pNeyO8yqR/I+SwiHiUS8WSpfCDywuUROfXXG538k5AamrzFx6Ae1UuKPH+jyFHB0VjBKWJx/aFh1PFOjywF60npmC0kkqWyCSOrXKa4rVOiYx00FsL65iucxTqtVrYcW1gERWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNxKSJLkMXzmpkPDAv6i9Ygc6x3gD7Jp38/QcgPVnMk=;
 b=GdOjcE0kmYYCgOrnwGzYp+KoWM3JPqDERwZxrCJwotVjF2LBPi2Umbv1RQpJQ0nHb/JddghQx9x6k4Ft8+bSb5pYx8cLdcr43Vj7NWL1J6AAqgIF6BmppiYQXwjGZMhUALjDU5qrKtPKFX+L10eHndkYSXmtq08u1aGZVH6z03cqsMejmOD0liwNuwqbrQYWjXRKDOLoJNZ4At78BTukgpGPC42MAWzLbBRz4avnbKDIQLfgz7haNNC1GQH2mbq4P3dQB6APbiGIVvqvTkzjvC4fXdJmEDx60jGFarktCPeylrVm002maPs2O2KZT/KcqgR+0c3A7Lz7WkijJG2d5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNxKSJLkMXzmpkPDAv6i9Ygc6x3gD7Jp38/QcgPVnMk=;
 b=YeGgWKUm74VsFTY9t2tIVDNDHhu5jEgmMwcmzB4SkRmB37hIfe6++q9h++Od1nBSRY7GZ4M+OmcunQ4q/2zllGwYwqoXmxXgB+E5s77r9lvGV6uJAtukgf4jtggnFJlEqFeaWsZMkfyMCsFGvuZ19ozrAJvbR059Sv3m/BWYAlFYg4Ap9Nw+eGptedygXHiUAqwyptWlpox9o0xG18T1WMJTCNZ9xPD/tm5AzCy3+6wFOxNuMu/FtnEmYjTLQAr7fvfmM1VjvFWXhY5kgwkUUe5qnvqu6VLnpJ3rK1cdE/Y5iDEtxOZWWUyTGLXV8inTPY7ezofW4WGy1nFtW1sUYQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7106.namprd12.prod.outlook.com (2603:10b6:806:2a1::7)
 by FT1PR12MB222952.namprd12.prod.outlook.com (2603:10b6:170:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 09:26:35 +0000
Received: from SN7PR12MB7106.namprd12.prod.outlook.com
 ([fe80::7a85:58cd:4146:bb1]) by SN7PR12MB7106.namprd12.prod.outlook.com
 ([fe80::7a85:58cd:4146:bb1%4]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 09:26:34 +0000
Message-ID: <80816b31-948c-45a8-9f98-4cc55f5bd530@nvidia.com>
Date: Sat, 31 Oct 2026 09:26:08 +0000
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
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <b85e0697-d669-4b14-859f-52ee295264e4@rnnvmail201.nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::6) To PH8PR12MB7110.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SN7PR12MB7106:EE_|FT1PR12MB222952:EE_
X-MS-Office365-Filtering-Correlation-Id: df25c9a8-8791-4b0d-deb6-08df373103f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10070799003|10067099003|261009223027099003|261026140227099003|261022105027099003|261028144727099003|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PPXCcY4JqcXICDMtsgwstzTo8W6LR5EBwgEC1nRt3P06l4bxh3GKB/hxi8Eq24UluhuJ3sAuED7JOnPtlNpopQcsn7p3uJChS+vJTGom9mow3pSy4EMzO/BLsuhgG79cIliRmFD1rQKoHhYZKUnSknUqsnRklb/YHIqCjnY+nuEMijSE/PSaRcpDtf91d5/+S3afoRWfkxLLwn9ZCJLgph1pH1ruomy5lLF5mCs7nd8hC9Pu/l9pcN4sPLugxXZiRVzuBjAhSkOSct4j2Tcc88VA5KKz+ZwhAyxdT2133yfg4LG80g9vJB96SHXxhZ3zCX1Hq0zXn2HW5EE9UGRMzgH4iGYX/6MlAF56N/qzJQnPBWsE1D8y8BoQoV+rbOgCEcgR+Nt/MZxJ7Xy9mBsaHOH+wZkU/gzGGqBjUbZAglKcpdu+dH8AJ0W9rOKZzXSyipfq/dSwtQDTvcXFo1HgoXZgjgd46o9b9QxxO8ad4fPV+BXPezap4oQ0a0hqlHg+xC8hGV5O1OWcQ+HL8vLquImbAqqa+Q+OsNM/egST4kFfH3BdvIVLaXAXQEY5cu0VDNsxZ/X3PYz1csJLSqlOhFHDUqD5cAKW9gyeg7APnNRAZCjnieYSa8TTV/gBD1nsDg31VB2Tj4TcFydX9RLMtS5tNL6ZIoG5m7yHOwm34Hg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7106.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10070799003)(10067099003)(261009223027099003)(261026140227099003)(261022105027099003)(261028144727099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlVqcnJOaXpObmNwanZDU0xDUWhBbFFlR2pkVGFPOTZPbWJpK3Jvb3BBKzU3?=
 =?utf-8?B?bngwa1FEeXVLOXZiMGJsVU4zVWdrbThDN2d5NXpMUXV4TnJQZjdQSHhHT3Fq?=
 =?utf-8?B?MUdrM3oyNWlaSitHd3NoZllhUW40Z012anRSQlVnSTMvbmFITkNqWlg0Y2pz?=
 =?utf-8?B?NVA0ZmRjY1d2MnRpVmxURTlwOC9PRklqYVl6LzNBb3F1c3FZZWxyVUQ2UG1Q?=
 =?utf-8?B?SHNhY0Vya2t0ZW9vdTB3OUYxd1NRVlUya2hUYThQd3FQd290UW40RjBIQXV3?=
 =?utf-8?B?dm9NbEk5RTNkczNic3pqMjBTNjFWWWdGcnc4QWpZL1NkNkc3aVE3M3VjZkdp?=
 =?utf-8?B?V3dwMW1tMDd0MU4xTGowNFJpRUlCNzcrbW43aVJHVmllWmlsT0p1amNWM1Zh?=
 =?utf-8?B?S21CMkljaDUzZTBoT0RsRU9VdkZZZDBhRWJ2QUJ4SzlCZnRVWldHZnlkVWlK?=
 =?utf-8?B?MmEzNzVHa0huZEdKalBpUTZWc0wzYnVzdUVRcWdFb3Q4QjBBa0VUck9TNFNh?=
 =?utf-8?B?QzBaejlJcHdCbHlJVFF4NDNMZnBQRGl0bVg1UnFMSUdtTlgwQzh3VzFXZ2RR?=
 =?utf-8?B?Q3JubkNVTUIrTExhaUx3ckxmYTlLWGY2Y0c4WDdwNFhoZzYyWUYwT1VGcHNN?=
 =?utf-8?B?b3E3STRPTzFjUUVUNXNGd3BoYmNuUE5rUVV1eG9RR3V0SjVIRUtBRFZwMHJR?=
 =?utf-8?B?d2lyQ0R2L0JJR1dTcDRUTUlFVFVjaFVvTTVlTk9NV2tobHVsZFYwR2puTDQz?=
 =?utf-8?B?OXZrZFBLWllxZW42RTQ0UjFUWTR2TWNrY3pEbUJia3VnRlJuRlFWSVJzNHhO?=
 =?utf-8?B?NjdEY2VXZTZXQUF4Q2JpL05XRlhYYzBBem5ndk5VaHBFUVV3bG1va2dUWUE5?=
 =?utf-8?B?ZlpCVzJhYTlSZVdYellLZWd5d29KMk5lalBXTW42dG9nc01Gdm9iL1BUcGp0?=
 =?utf-8?B?bU12TFp4WnduTUdBTndqNWhaZk5ZWkFhc2lyYkJ3TkFlakxBUzdTZzNrU0Na?=
 =?utf-8?B?VEZRNkZEK0NNeVJCY1pCbmduZzlmSWR2TGV2RDZhK3ZkTjg0dG9qMUFjM3p6?=
 =?utf-8?B?and0dkNmUDZUZFMyK3Yxc2t6aHpqUng1ZFRlV2lyZ3BFaU1lT3F0M0RiY3Yw?=
 =?utf-8?B?VTNBZHl2c3FLc1RDMGhpcURHN1llSlpQNjVjeFk5N2JwdC9qaFdvM1hKdmpR?=
 =?utf-8?B?NjRHK1lpVWtjUkVYWW5GLzFHV1RQa0NwSjkwanB6cTkyeDkxdW9MSUxXYUJx?=
 =?utf-8?B?OUF2ZlRxUk9oYXFTSzBFTGNDWSs1L0wzQ2E1WVZnSThQaFRPekp6M2JPZVE3?=
 =?utf-8?B?ZFhPR3JKRUZ1MVNHbUQ4WlovRGpNNG90czhIOVNlQ280NG5QN01wZEpDV1ZI?=
 =?utf-8?B?Y2Q5RjhBTSs2QjUvNDdUdE5pSEx0Q1VURnlnL3FnSGYyNXBRZExkMDJYcE50?=
 =?utf-8?B?QTJSNyswa25vaTdPR2doWFNQQmxnc1pxUWJzNFI0dzNObDhOSDRuR1ZFd2sw?=
 =?utf-8?B?TVVzMUROOVoyZXM0UDNVZXNDY2JteFJVQWYzbDlzeGlIeGdwc2E1OFNOZHpV?=
 =?utf-8?B?QVlDRnhQRUdkaE9rZDVoc2Vzb2FJelphcE9lbXpjTTVua1Y2alBXajFjeERI?=
 =?utf-8?B?ZFNvZzkzMFZ0L2ZMVytVNEtZL2xvMjRBMEZ5K3ZqOUVTc09BSmsxMkd2Wkta?=
 =?utf-8?B?d1hJNkl5YktwbzlSL2FjTXVOYlFWOTY4QVBPb1NWUTFaamNFckNLUktXeER5?=
 =?utf-8?B?SEt1QmdoQmN4QzBicXpwWE1pNWpMYkd2VmpROG1ET05LRU9LTzlTaWRGU2NH?=
 =?utf-8?B?OWFteDA3dzNzVFIydFBuRko0a2lhRWJ0VjkxYTBQUlJCbmRGK1pMTUxXSm1l?=
 =?utf-8?B?RmczQ0JWcHZuMTlnYnVOUFJGK3ZRZFk1VFFUSHRPclJBZDFNRGhmNFR5M3pE?=
 =?utf-8?B?SGhQNXU5QlMrM2dtREJiUEQreHkzTnN5N2wvaEt5TnJFU1NiTmVJbUlpRXIx?=
 =?utf-8?B?TjcwOU1lekJTS2k2YWF5WjI0TmZXTEJRTXpsUjFkcHNidFphZFI1V2htSE5q?=
 =?utf-8?B?YUtzU1c0b3FQQmNWNEZuZGJGTDF5ZTBJYUp4TnZhN0ZCc0NNT3NSK2RXSjJV?=
 =?utf-8?B?SGp3ejhSanpaSkVmRll6Qno0THN2TldsK1JYaFB3dGdyZC9pakcrRGxwTk9S?=
 =?utf-8?B?RlU1R3dLaG9wVUwzT203aERiemhlclpvWW92RDFuZVVyK21LcGpHREpOOC96?=
 =?utf-8?B?LzZheVZuT0VlOXdTUTJZQUwxanFybGg5cjhJdW0wdnIwS2o3a2tMeFY1VzZ3?=
 =?utf-8?B?MTIvaDlaakcxalVOQ21odUJQeW1rMzZtTk5WNURPNE1lYmNoQnIvRGRJVXBz?=
 =?utf-8?Q?BAR8kAe8Ymf+csttI9P9q/3008hkhLqi+/VDjPCndfhc7?=
X-MS-Exchange-AntiSpam-MessageData-1: kokGPx5Ip+5pLw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df25c9a8-8791-4b0d-deb6-08df373103f5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 09:26:34.3110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k/ltrUyepxOIl3nOmz4imB4dtSzXcmUVFZCYDm2XdFW7z6OMGDq0VWFako1CQHTZXLMGBeRzCkOQm4xcyFYaPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB222952

Hi Greg,

On 31/10/2026 09:24, Jon Hunter wrote:
> On Thu, 29 Oct 2026 08:33:04 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.191 release.
>> There are 1879 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.1:
>     builds:	9 pass, 0 fail
>     boots:	28 pass, 4 fail
>     tests:	83 pass, 7 fail
> 
> Linux version:	6.1.191-rc2-g3b00df762ebc
> Boards tested:	tegra20-ventana
>                 tegra30-cardhu-a04
>                 tegra124-jetson-tk1
>                 tegra210-p2371-2180
>                 tegra210-p3450-0000
>                 tegra186-p2771-0000
>                 tegra186-p3509-0000+p3636-0001
>                 tegra194-p2972-0000
>                 tegra194-p3509-0000+p3668-0000
> 
> Boot failures:	tegra186-p2771-0000, tegra186-p3509-0000+p3636-0001,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000
> 
> Test failures:	tegra124-jetson-tk1: pm-system-suspend.sh
>                 tegra20-ventana: pm-system-suspend.sh
>                 tegra30-cardhu-a04: pm-system-suspend.sh
I am looking into the above boot and suspend issues and will let you
know what I find.

Jon

-- 
nvpublic

