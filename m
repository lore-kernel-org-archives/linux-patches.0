Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011069.outbound.protection.outlook.com [40.107.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76D93BF68F
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787744000; cv=fail; b=SRUWXphLMq1v9oVKcIXaEXS7eeR9NMVDDjHjmVweEcSJoGCD5YXfNynJ27opCtbKgml7XOkmKqAJj0rnbu5s56n+3h7LmvfCvP5No+AsnfPS+g77KWGPNoqAAwYn060yphaXFFYNMv5VNMb9YeYstPRK31cowOxInXmSozuoNaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787744000; c=relaxed/simple;
	bh=5YRArHk2X5tul8f4lUcO7YZIcx2x+RT+0RlHefSbTyw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=isJmN+pRfcUuFZ6efO+TW0CBa+8c9PMrzVo/lGdISda9eYUvn0mBSaCrfg3u33h7lrenHXD/db3yHMvtRUoVXkjXBh3vFgCav1p+yxQhKwYHrncNcT1h9EB9J2drqyb52E/FjI9hSijQuqyKPfaOIc8uXpnFlC4yy3WFRhPt77o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TYZrZOpd; arc=fail smtp.client-ip=40.107.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TYZrZOpd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WTfPn79NbY7YgTY51VLPqlDudDJCSdRR8FGrPtk+d0dR9RvbmI48kLVe7wiilIRjwRpwKkrOtzAgintrf3HRgHfzsMVDuRNPsNqjMBG07cAOLHUSKRrmYjFG+QGD90RtvEzStkIJCMZyY1GGFw7nxjHubFwavjXNPphaLCbMgVhtGAWWOqznud+3GJui9wgQ8XJqJj/qodfaU3f4CLRkZg5C42+DOIG+g22cQCRqPo03ZqAkQsIPcIFZzj0KUp/7oAe/SL3YWdGOmZtQR2GwKaapcG9utyg2+zcRL47hau1BeE6WzBQ6i8mP6hJEXTE8zj/KrV7JS0zNM4TW41HSXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=USL0AjDU9h/WqRHVMrW94+Y7FuuECP5naYh/Zawnkhw=;
 b=uL/T7OLb5oJYWoy7IGqJfoQyJr9D+fB/89jAjWYaca30ncTZ5d9E5lfyuKq9hGAqzjNnaeVeco7uYcA2NnCMICeQlYqP8VD96KwJ15aQc6BOu0oVeudwTq804LZ/1DI5aL/V1c0DBibQWWE2PVZ/E6pq3wuYpYUT+Ry27b7rGHtkMY4/FvT3xwaW/wayiw38eoGL3lUPiEK1DCsLtr6eSuj75iMfQCqlGQ3NyLft6wR9c0yQNfPcL/4dLLwOyCWu3Kzoi3QmLOUwSEO2C/87WZ9+FcbgIQVgedzqCbwBf6up40NHb/oicVrNeEKTI4/k3TQ6r+9ddlQiC/G0IO6zpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USL0AjDU9h/WqRHVMrW94+Y7FuuECP5naYh/Zawnkhw=;
 b=TYZrZOpdyRpCUpiM+0YuwK+jT8OyuUviYJwOpxdj9I7vqi+AqqH0w5ypyMMqRoz4SciwqoCyqFvssFflEOPmmXY5diiDNMm7zxgE26FBNTX+NlAL9O+D3Aru5YTrj9iH0vJP/eTqogbCSlq62+ZlZzu+TgKbBbcN3J59lFU7I8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL4PR12MB9505.namprd12.prod.outlook.com (2603:10b6:208:591::16)
 by IA0PR12MB8225.namprd12.prod.outlook.com (2603:10b6:208:408::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 11:33:14 +0000
Received: from BL4PR12MB9505.namprd12.prod.outlook.com
 ([fe80::73aa:eb8c:a86b:5a83]) by BL4PR12MB9505.namprd12.prod.outlook.com
 ([fe80::73aa:eb8c:a86b:5a83%5]) with mapi id 15.21.0360.008; Wed, 26 Aug 2026
 11:33:14 +0000
Message-ID: <80abfa09-5b23-4522-9ff8-649588d8eaff@amd.com>
Date: Wed, 26 Aug 2026 17:03:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0019/1611] iommu/amd: Use maximum PPR log buffer size
 when SNP is enabled on Family 0x19
To: Usama Arif <usama.arif@linux.dev>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Borislav Petkov <bp@alien8.de>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Joerg Roedel <joerg.roedel@amd.com>,
 Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
 samuelcrossley@gmail.com
References: <20260813132447.3396830-1-usama.arif@linux.dev>
 <20260814193000.12@kernel.org>
 <0a97021b-7fdf-4e29-b59d-d9fe07c6c409@linux.dev>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0a97021b-7fdf-4e29-b59d-d9fe07c6c409@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::15) To BL4PR12MB9505.namprd12.prod.outlook.com
 (2603:10b6:208:591::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9505:EE_|IA0PR12MB8225:EE_
X-MS-Office365-Filtering-Correlation-Id: bd31e95f-fd07-4ce3-28cb-08df0365d0ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8Nmcb2hQ8NpSN0WpDB0243Ubwc6Aeep93cy/Jd1JNYELIemxEKD/Y9IVmTXarX3rb3FSXSPvX4LReJOiivbdN2CS//hw7RGYdoYxnHeGD18M+o7zxHaD4m2M3LJuJRpgdCk1/GobnbktBzJcqMicDk/WEikavEuvPVt2C4975ee+5eePEiIWhUG8yglHMezv+DjaP1N7GrfMFFBwwGVGbW9Lh/TDOU2N1HS6PYLDgk0ZqvurarbzfZpuW8Ot8mZSOMKGtXYFpRHM/RXWT2Zinso0ybpcDOqnrLjh5CVXX0voPOpvg3pFZePZWRXpppsba2nSJdy7o2C9PQUCdJqrjSaLqksUFDyVcBsSmu/guw/5ck0nzbD3xiSQHqI0BiTi3STmvY9EXC/V9qL78ozRma+XCHpp6TG+GqPbqRP6hvSF8borkhmEGUZmnDvJvUO0aBcdEi/Ku3Nd0kUz/AwuHPGhDnymLJaqFwjxQpffJMJXHMLqqlCLd09FUlpF2eD2TehzIoF/5aujdL+atjeSQ0PIKYfLLjusvCJD74tcBACUUsLjSdFjVUnuigVbnNQfacvpoUn7t2kxcT4Zdsd88WKqbAdubNkSiiWrXvtl1h84en7Ct1gdF/jp0udCaCDUFLq3g5wa3Dv/+7IZvHnGl1/ImJb1P8qNBiHXzriE+Cc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9505.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckcvelVZclQzczNKcWhHUllESUh6alIyZk1vcDhYeDRwQ2Q2RkY2T3Z2Z3p0?=
 =?utf-8?B?NkpsWUEweFFxMXNXKzdTUTNUckhaOUgvbWxMZVNIcGo4SnlBQ0JTMUNMSWZj?=
 =?utf-8?B?ZW9GdjlwMWk1LzJ4eFRuRU02Yks1V2hTYTdmZmFEY0ZtWnF0amV4eC9pVGda?=
 =?utf-8?B?QTErc2VKcGxMZ3NMT0xrUjJ6bVpxU3hYYTNNQWxhYjhiZFhpK04zUTFTbnF6?=
 =?utf-8?B?YmkyS1VFNWNiK1loMG11Rk1VajNFdFhqZTVEaWJUVzc0aFBlem1kaWdvZ082?=
 =?utf-8?B?UmpEMHFkZ0RJQmwzZ3lPQ2pBMGJRNUM3ak5saklJczNuVE1vK2ZjMFU3cCs4?=
 =?utf-8?B?bm1XQnVFR0N3NE12ZDFxb1ZBdDhFcUpWa013QW9MOHlnVkZpcDBQMjRSaFAy?=
 =?utf-8?B?V2c2djRNNG94QzNIblVWdndESWRDK3BrQTVvOHdMK2d5OHRjdWpJR0pTeW9n?=
 =?utf-8?B?YmxHbDZYcU5ub2ZoOE0yL3Jadm5nNzhyRE5iU2pzRm9CaXdXcHY5SDQ4WXhK?=
 =?utf-8?B?OGJYQjRIRHVvMHZETmwyRHl1ZHZielFEd0xIYkNoNzNoSlFPb1R6c0M2ZzRF?=
 =?utf-8?B?L05KYUMvNEFUMEV2ckp5RVZFWlFlWTErZzNxUlJxMDNjcWFRTWZUb3E3dEVC?=
 =?utf-8?B?UUt1bFVuRE1FTkRnMmZuOXplMFh5cnBZbG9JcEdoZkM3MUNIZnlFSnF6OGM1?=
 =?utf-8?B?RHp1cUViK3RwUjJiMm9waXY5dWFaamdGV2g4eVl0Y3l1ZXl6TmtqTHJpTGtM?=
 =?utf-8?B?YXdvQy85NmRsanJZVnBrT0NSR0JvMVlNeDYwM2FlU3NPNTBjTmkxNWhTRnpJ?=
 =?utf-8?B?Yjd2S3VMQ0VXS2Znais2NXJwTlk0TnpOSWhoL0RUQ05uUUE5V1diWmR6M28y?=
 =?utf-8?B?bG9wbnNEdURHRjJDbXRjYlZOaUFKaHBwcFlJTWpIbnYycG55dmhxZTloN2FQ?=
 =?utf-8?B?azdQcER2d2pkN3grRnlrR200ejFWODFiZkluOHhDc1JkeDk4cWFXMXRWNFg1?=
 =?utf-8?B?WHZMcEFoM3htb3Y5b3VOV0hvcGN5dHBDMUVySzZlVTkwN2tnaGRzRCtESzRW?=
 =?utf-8?B?bkIwd1FROWFpUzJzR2FWckU4UGVGY1RvdEI2WElsbldkcEh5VkNTNWxxb2F6?=
 =?utf-8?B?N0czWXVkTm1oUndyRkVUdS9jeTRYaWdYTWN1dnJuVFhVa2lqOUFtMUZVSWly?=
 =?utf-8?B?NkpvQUpCTEowdnRJQklJc2l0VXhMR0crNVFCbEwycnl2Tzd3ZDloczFMc25j?=
 =?utf-8?B?Q3Y4aGpFMlUyR3ZGZHg5V2RWNzgvOXFLcGZMQUtIaUJrbnFGTkFEZjdTUUho?=
 =?utf-8?B?MGhFajRXUDlMSXVTNndqOXJIbGxlVHpwRDd1ZVNVVStKV2NsYTcvcXNMRjFw?=
 =?utf-8?B?WWNXN2lFR1krS3B3Z3JTamdXYkc1bXdic2Vib0xNSzE1ell1QVpzTkN1cUV6?=
 =?utf-8?B?VDNiOU9UVDVOd1dUZDhZOWdlbk9DeG9SUHFqUlBUZEpPMVQ3NmtMQzNHZEVn?=
 =?utf-8?B?Y0ZHb0tTUVIwMlRWeHJSYXhPS2FmTmpVckdSYis3WDFkdk0rN09DZDk0dWZI?=
 =?utf-8?B?OEJuQ3hmdTluUmNxRlJNeTV4RG9OdjE4NVF5ZGNyZDN1ZFFzWjBTVmU4K2xU?=
 =?utf-8?B?UEtoU2Q5aVlOejNOd2U0aS81WkxWNktsSE1qRjVhY2lNMEovd1ZjWks1Zy9O?=
 =?utf-8?B?WHB4NnZVN1hBbWh0cGRmM0JvN2l5WmtnSnRhY0V1Qm9ReHVwTXVCbVYwZ1Ns?=
 =?utf-8?B?Uk5Vdmw1MnFJMVNyd3FJeTVMUHluekhHaVZuL2lQZ28yMnVTMkhHWFVlUmVT?=
 =?utf-8?B?NmhnZ1hXd2Jaa0RWTFlBdnJIYjcvc2FVaWhSdDlwZzRCOU5jNDY4K2tLNzVQ?=
 =?utf-8?B?dkFyZnBhRm1YTEVObGYvRDF4LzRkcjZxOWZCUWhETnhOY1BMWUtnZFppWkRx?=
 =?utf-8?B?T3luWjAwM3JZc2MvQ2RZSXU0M1NBNHVnNTdnOHFqK2FkOFBTcG5FV3lpcGph?=
 =?utf-8?B?N2gwYWZoT1JtY0JyTmZIMHlmbmxvV2M2bTVKT1FjVmd1emdpcGZZeE1kZVBm?=
 =?utf-8?B?amtTN2hJZkE1ZXBDcFdUclU3d284dUJ0enhjSjVyL25DQkJXcU1vZkl5SnVv?=
 =?utf-8?B?RG1DSUdGUDZDM0JBNk9oT3Evdm1waDI3L2MraUMrSUZYR3dtU2MzaUU5ZlNa?=
 =?utf-8?B?Sm9NQzY4eS92T05UdW5rbGY4M1orWEdNNmF2VkZqditiWVJ0ZWdNTG9sdFBJ?=
 =?utf-8?B?Q2pLQnFEanBEYS83YWNUNmtEV0JQbDRQcXdzbHlQb2VIKzdCVTl6NlJCM1ZV?=
 =?utf-8?B?MnQvL3RES1JZeFlqVTJ2OXhUOXY2ampNK1h5dUVaZElPRzZHN25mdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd31e95f-fd07-4ce3-28cb-08df0365d0ec
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9505.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 11:33:14.4767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEVFrwG5kOlXPNki/CLz0C8/uQVKkF7gCZFiJ/k7IuPAMH4hBWI5fju/Jn8Gmf3kcbQzvCIpFeNfffDMRJawFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8225

Sasha,


On 8/15/2026 5:33 PM, Usama Arif wrote:
> 
> 
> On 15/08/2026 03:33, Sasha Levin wrote:
>>> I have raised this in [1] but also raising it here, this series seems to break
>>> kexec on Milan hosts.
>>>
>>> kexec starts working on SNP hosts once we do:
>>> Revert "iommu/amd: Use maximum PPR log buffer size when SNP is enabled on Family 0x19"
>>> Revert "iommu/amd: Use maximum Event log buffer size when SNP is enabled on Family 0x19"
>>>
>>> on top 6.18.43 release.
>>
>> Does the kexec hang also reproduce on v7.1.y, or on mainline? That would tell
>> us whether this is the code itself rather than anything specific to the 6.18
>> backport, and it decides whether a stable-side revert is the right remedy at
>> all.
>>

We have investigated this issue internally and confirmed its FW issue. Since its
CVE fix, I'd recommend upgrading the FW.

Hence no changes required in stable/mainline kernel.

-Vasant

