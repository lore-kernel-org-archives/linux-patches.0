Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFAD18FDBE
	for <patches@lists.linux.dev>; Thu, 10 Oct 2024 12:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728562413; cv=fail; b=YGKaX7axkjXD5tlOM1rqNwuk1lCvjql4CUwuVzezAGiOWxcuxFk1xOyeIAmb74LqYwHZ0zAKptZeLN0Vk54/pw4OvWlHW0gzrDQvk4FBXZvWFnKuDKHYskOgYZbgk9o/STFPugJytlho0EEaelDnSKO4mwvLWPZGeO0T1PnS5h8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728562413; c=relaxed/simple;
	bh=ZIbh0ypctmORtodIHUarrefNdfGG4VY0w1EBY6ghW0M=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OjxTQwVoQ1S4BF7mPElUlsAQDQSxEWB49CE3F5hMiPKywj9GPYV3Gcz8ygAsfmvUUTohdv4jY+So9qGntc+nqEM9CNijjL69xUdZFBiiVaaBf17nITfZ8ef8zbrUbq55G+1T67skMwAzYN1w+dFjjB5XUK1whnwnhm9KNlGjnaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xjx55TL4; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xjx55TL4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QwLtkOKSLMeR3faWqrvjlQsPczI7irzRE0h2hnzmOnjNAoun4N2yWvqgpZWWlQLOae7PmX0Ds93MnRwfE6IRkyXzEZwBsqPGcYyiLrMjhzpKU4mf4ZWSJmCnmXo07gl1SvOlTE8QbV7Fev2wwqp3yGcNtpgheKXnrc4Hg8QT2jUe9BKOVR+ztNqpxbhMcTSwssaH+sl4AEkwRSykX++9gOTqg/ZU+Z6ZXw1OdOuVhoz/+OYT4V7HBU229i5l5vFmMEpsgtI5dvsT9JylOVxOe3Tw+QEhjePwiwXw2YMVwg3UKkls/i8V5CxLqRTh9sBvlUXMFe5aCFzoqtvu1BzPsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNavtihgrKbfDd1sFH7d6dyR8DRAgw8j+ANSnOgPik0=;
 b=wCt4gPLZoUhTIHaceX3UIZxLhRXijHXb71miY1Xz3/iszvQv7PqiQyQ13hbu/iENwahdHF8y4NrfZd1AK47hOqANGYDugs3vzsRlZSyPxsG7b00uRfNLx7x80KMUB70EvyorjcsiEx+gp8+Q+Ti7cL1yNTQDXITQkfP5jye9uQA9JysieEhYFIraW0RPc5Xs+PrhZ4g/EtTFlPT7nOHvsefPtJKzHJqQDW+Y3M3zijysLLy5FanPQzRchzntMa3mooOWq8jDR5jcC8DDkBFyzBV7XZNjrLf3f5esHiCEtLA2Vl7il/WLRfCfuCWrwg9vMFQ7WE01YlfEtcW0VGsisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNavtihgrKbfDd1sFH7d6dyR8DRAgw8j+ANSnOgPik0=;
 b=Xjx55TL4OVcH2qlX6T9fWJv65IJKR0dNZliDQOHxZ3l3TNloXzyx3y1OpcpBrXThfVr682MQrlQYsebKbwuZjuR6Vip8zd/iYsblZYTxQtKUEkf7hNzWYilGYg6qb/HMD399IbTk618TgcH+KFdqJ6N34n9vH/EXd4KdeuoLWT74pnnDiqYSxv4v4Jjd562ntnkMl8QqFKuSIlT50AYNXaPrzFMYA5Ym/4QChESXKLLLIXK4K0J5+IFvsG29e5/0UTZnbDtTt4b1QLjUNVZazx5xj5cqCIOFP12SqQfwMPNe0eFRxnYTFH+nAlfk/qBoJ9PUyoWFwapgXYHe8SfKNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by MN0PR12MB6054.namprd12.prod.outlook.com (2603:10b6:208:3ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 12:13:27 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 12:13:27 +0000
Message-ID: <effaee0c-8147-4122-9b99-87c95b06ea66@nvidia.com>
Date: Thu, 10 Oct 2024 13:13:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
From: Jon Hunter <jonathanh@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241008115648.280954295@linuxfoundation.org>
 <50b64beb-ba52-4238-a916-33f825c751d9@rnnvmail201.nvidia.com>
 <Zwb8t7ngmnVYV9_m@sashalap> <125a37ba-095e-4149-b65d-f318fc45a085@nvidia.com>
Content-Language: en-US
In-Reply-To: <125a37ba-095e-4149-b65d-f318fc45a085@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0575.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::7) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|MN0PR12MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: 23d8f37d-36eb-4930-50f8-08dce924f21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXpKVFhvU0xoY2NmVzdySXV5enp2L081Y21COTROMWxFMllGankrZFRRc0dS?=
 =?utf-8?B?bVptM1NFMnlsVkVKWE43Zlp5TjJpaHErRGxkQzJST29VYk1GaUJneGpPdlFq?=
 =?utf-8?B?a3pUYnpTRVo5aHVjYXFVK05NSlhxOEhvS1FnOWxvNnpjY25IRGllMEcxcmdX?=
 =?utf-8?B?YmdPRXYyd2FpN09PU3NMdzBNK0xOODVzWGJFSlFJam9ZWklmZmthNVJwelN0?=
 =?utf-8?B?ZDBKZzFsdmFxSEh0aUJVeUduSUp3aU9KUjZHUHRLVkMvS0dmSmRNeG13ak43?=
 =?utf-8?B?WnNQYjduK0hXTzZiZm9mMmZMT3ZGT3FiK2kxMFY1cHBEUitLWXZjQW9pazVr?=
 =?utf-8?B?M0xub3ljQy9WSmxDdkpBa3VnamhReHNZTHVZZEo3YVZrS2dhVmQ1dThITXFy?=
 =?utf-8?B?TlVHcnZjYXVPckZTMHRBa1dIRmtyU2NNZGVRTUM5cXRySm5uSWVlUFR6Z3hT?=
 =?utf-8?B?U1A3elMvV3NpalZ4cHdHVVVYaVRjakNIYWxNeTdpakJtUGVLdzBGUWdKTkRw?=
 =?utf-8?B?dHZXZzcrMTJRVndVcVRybEk2bTc5dmpVRnRGT28wck5BcUcvYUhldkZIVkhW?=
 =?utf-8?B?N3RjMi9uYnVwYjhCNFZFRkxEVlh3VnlsdGlSaEdXR0RyV3JuNFV6dGhseCt3?=
 =?utf-8?B?RytiMHIyazdIaWMzaDEvcjliaGQ1TG1RTVNFdVJMOW5YU2pLUXc2bkZCODFs?=
 =?utf-8?B?SU5sVlV2R0dXa0ZiTnRkQldOMDhzUUJEdjcvOUNZaFBoUll0WjN5VDU0MmpX?=
 =?utf-8?B?Z1R5TkZEMjdDY2tXckIzRlVlc0ZHc09KV1h2M016YVBBMjd4YkRHczRCRFJI?=
 =?utf-8?B?aURuMzNpWUZyWXpMVmpENGNjS3BSK1pWWS9qdXl5dmorOVAvSjJBSCtubnEx?=
 =?utf-8?B?TXAvYW1uTHRYdDdQM0xrNEEyaWxPbHBwcDNYWitPb0RWbWk0WWg0QTd3ZnNs?=
 =?utf-8?B?Mmwvd1FHVnZ6L1AxMGI5TURONmhyOTQ0VThQc0dNb3VUT1VoYSt0SDdWTGVs?=
 =?utf-8?B?dm5IQ1c1SEd6YklKOVRLcFZQMVBFUjNyeHVZWWoxRDRLSDluV3FMOVp6U25t?=
 =?utf-8?B?eDFqc1c1N0Fva3JocFdobzBhR2VEZUMrMU1GTDdtN21ZNlVRL1JXU0YzY2Rp?=
 =?utf-8?B?RGtFMElDU1F6WVBrWm5kQlRnWlhvU3V3YzhBK3pTVnhaMDJYMXoxdGoyWHBw?=
 =?utf-8?B?Mks2cTVvOFpXZ3picHpLZ2xGYk9pVUlRcUhpTEhOSEtQNWh0MzVlTkNPMW5I?=
 =?utf-8?B?SGFOVHFXWVYzSGk5SS9JUElwNzk5SFZzQlBoN1pJZ3FXU2N4RDRhcmI2SlZR?=
 =?utf-8?B?TlJOTFJYZnJSVjMxN3FPRlh5TDE3RG1VOWh1b1dISzAraUhHeW9PVXE2T2F6?=
 =?utf-8?B?SXdRdERXc2Y0aVptaUJFc0ZjTnFxcnRRK25rbXJYcGJaWjBqdnpYeEhrSEdu?=
 =?utf-8?B?eHBQY2RIQXZRazdiTTBFUW92Z0xWMnYwVEowYTRsUXFFamJ1ZldSbG9tcml1?=
 =?utf-8?B?VEErVzNCMW9UNGNWL2lsdm9wLzFvUWNyRVZpcUorclVKUU1VSkxnWUd2a2wr?=
 =?utf-8?B?MHNlbTVwam1iL1FYZHRzZi9XSGphVnpUQkhySGtuRktMeHdkZU42cVJZNER1?=
 =?utf-8?B?NDRNZENXcDVBRE5UVzV6SlN1SC9nOUtiR0trMVBqTlRvZFJuRXhFS2YyOUdx?=
 =?utf-8?B?dkg1MFpNSzR6LzFtblhOdkJFc0U1bFk1djhiZDd5UnMxZU1USGRQWVR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmhJR0hOdFl4QzRyZWZMUytXV0kyVVJJL0s1T1ZCc3RyOEpnSURZdjNnbnhV?=
 =?utf-8?B?OEo3RDU3V25hK0RUeHlrckFtSVhwdHJFaWpCdjF2NWdiMmpUdTZvNGd4V2lk?=
 =?utf-8?B?d1ZzalpSMDhYaFVUOTIrTHQzRHhTYThwWlk0UVpzb1BJVDh2c09uSElsM1Z4?=
 =?utf-8?B?L29kZ20vQld4TWlwa1p2VkNzSnFXTDM1UG43bk8zN0p2dEZPd0VOelVQbDFs?=
 =?utf-8?B?UXJ5Rjc2UkFZWnNUMnVxZnk1OUQ4MzJISXBKZDF2cXB3K3dJMU5XZWNLOVdB?=
 =?utf-8?B?NCtZWTNjcnp1NFFZb0lqWDE5cXFScjExWm5mbW5xQy9uOXc4WUxXbnZxU24v?=
 =?utf-8?B?T2E2dTJENWZjWktIUFVEZnVsaWcxdWpzZWFISXpubS9HSmpzQXVDNXovZDJK?=
 =?utf-8?B?NEN2eDdqa2lRTDIwQ3lSNVo4UXpzeHZGWE9hU2NlRTdPUXNKd2g5Yy95OFps?=
 =?utf-8?B?WGdPWmlnNWFvK0FJaHRIQ3haMlVvaFAveG80Uy92bEZsRjBUdTUyN09IM3FM?=
 =?utf-8?B?MGFXdjVCNmJQVkthbzZneEExNVljYzJySmE1dzd4ZUdlNlRWVWNqRFltUDRy?=
 =?utf-8?B?YnRSM3VtaUZMY1p2TWRDSnAyL1paSENoYWRmUFV6b2RXTzhZMkdQWTM2dTRT?=
 =?utf-8?B?WHJseHZoZlhhVFZJNVhKVjRRb0dHZEJGaWNFVnk1VGpYcndQanBsR0g3RmhG?=
 =?utf-8?B?V1lYZ2RDY245SkNxU1RQL3gwcUcxTzdibzFxZnUxd0VUN0xYcGdMZENFZ2hJ?=
 =?utf-8?B?SnoxVlo5OEZldm94dnlleUU3N0F1RGUzTWZjaFJLZTVJWWtvV2k2UXg3T2hU?=
 =?utf-8?B?QnlVTDZPVytjeStPZlhVem9vTUExcDVIcEdzOEJtL3l4by84b0p0TklOQ1U1?=
 =?utf-8?B?YUxxNTFEV09Lc0lqWEFJcUo3cFU0ejBnMUdXL1gwWXg5VnpMYjVrSmlSWjlJ?=
 =?utf-8?B?YnEvU3FoNzlRbjlWcmxJVG42a2RYcmVSWXpqUTlPbTJDeXg4VjhNR1NPdERn?=
 =?utf-8?B?WWE0SHZFUjRFZW1FR1FvWCtjc1V5NWk0UTc1Q2k3R04veExFN1RmZjJQNE9q?=
 =?utf-8?B?VTBvZm1QaUR1OXltbHp2eTl3cFcrN3M5WWc0RUJSZFpEcnArRk5aQzdaaUVl?=
 =?utf-8?B?VmVFMy96MUExY05la3lVSFNLVnVlOWdQcWx2TUpGYThwWXlvZk4wWlNkSWF0?=
 =?utf-8?B?aHlWVXVBOHVmMFRTM3J5bTM4eXJPSnRqRlhuend5MWhWZVdYTS9mNStDUzRW?=
 =?utf-8?B?SGlBS0JvNGFia3FxYzdlKzJUdll6SlMyNEdFOGNobWFQc0hFNTk2eEtvcXdX?=
 =?utf-8?B?cTJMQUcyRzBtZmZNYS9yTktNNmM5L05mazFjWGhQTEY0V2I0WUxxSE9jUyta?=
 =?utf-8?B?ZnVUczRaWm9HSXAwMTlRcDNScGJ1NWErMXQwK2orSWRrQ2ZSN1Erd2tNMnlq?=
 =?utf-8?B?ajZBOHdlU2tsQUdQc252R0RHSFF6VFQ1L0VRMVFTN0Z1aWgzZWFvbXJiS2Fi?=
 =?utf-8?B?aDVqSE9WRHJwTStXOTR5amwvck96SzFpc2ZwY0lLbjFPSGdCcytoK0hCM055?=
 =?utf-8?B?SFR0V3oyaWpRaEZpYTBNRW85eldLaWdFbElRMUlmNWVwSXdhQXZiSFp4Tm84?=
 =?utf-8?B?elFRZkZ2UjQrTXRpY1o3K1NJOWxHd3JhdThEbk5HV29KMlF5aGF1U05DdjhB?=
 =?utf-8?B?OFRLS1djUTdwaks5dUx0ekxUZTZ5TGJMcjNHdFFUOTZmV0lhS3FOZFQyeWlI?=
 =?utf-8?B?c0t1MHVpWnhZbXdRVFpKMXRwRnhjczBZOWczRCtIbkVEYTFjcS9DV29CZERk?=
 =?utf-8?B?bnZBY2NwZDlGV2xVcWQwSmE5SU4rU29nZ05IWjFGbWRVd2JULzU1MklOcGNP?=
 =?utf-8?B?dmdIOENPYkNWS2QwQlZ2eHIvVVYyVVZCRDZtWmlEZnB1R0NCb29wYTIwdHlT?=
 =?utf-8?B?VzhkMlgyaDE4dE1aaWtCdGlia0htd253RVZDamNDakUwQ2hKUm5sQTFSVEQ4?=
 =?utf-8?B?clZjUGxkbC83aUxMajhFbEVsLzdJNFFNRU1Eb3RjMWhBNTVuM1Z6eTZCYjhm?=
 =?utf-8?B?RzU0M1ZTdXNWMU1JeDM1dFQ0U2hUMVZaT2Z0Uml4cUx5QWpmVFEzQmtaVll4?=
 =?utf-8?Q?ilLYLBeDeaOZYAptr4sXgdv96?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d8f37d-36eb-4930-50f8-08dce924f21f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 12:13:27.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZQuXmP/mkwmEHrJy0Q8CSfHSucAZ3Kg8Rj825QoSZtJCrMcnUZg1k2/npi6jR2f8t0BBPfsUbjtmflceHwOrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6054


On 10/10/2024 11:40, Jon Hunter wrote:
> 
> On 09/10/2024 22:59, Sasha Levin wrote:
>> On Wed, Oct 09, 2024 at 07:58:55AM -0700, Jon Hunter wrote:
>>> On Tue, 08 Oct 2024 14:01:03 +0200, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.10.14 release.
>>>> There are 482 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
>>>> or in the git tree and branch at:
>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> All tests passing for Tegra ...
>>>
>>> Test results for stable-v6.10:
>>>    10 builds:    10 pass, 0 fail
>>>    26 boots:    26 pass, 0 fail
>>>    116 tests:    116 pass, 0 fail
>>>
>>> Linux version:    6.10.14-rc1-gd44129966591
>>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>>                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>>                tegra20-ventana, tegra210-p2371-2180,
>>>                tegra210-p3450-0000, tegra30-cardhu-a04
>>>
>>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>>
>> Did this one not fail on the same cgroup issue as 6.11? we had the
>> offending commit in all trees.
> 
> 
> I did not see any failure there. However, same tests are run and so it 
> should have. I can run it again to double check.


I doubled checked and I don't see warning with this kernel. Odd.

Jon

-- 
nvpublic
