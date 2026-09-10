Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010015.outbound.protection.outlook.com [52.101.61.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C73E3C5837
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 06:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789022601; cv=fail; b=jpmsG01HyYv6DgA7pWchTiWlbfPSEBnMdy0lTPUV9qa7zuBaa37yQ1xUCusAyA0G60PClH3ebfT8uFd5Xk17g8rfXRbA4MzY95firpOg6U5JUM26XKAoh6VSx+eBlFl2EfYCRxQbyzi43IfN5P3q3Ku/ExPLjOvTtk/k0IBPp2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789022601; c=relaxed/simple;
	bh=aV6eXFYuyQAWSYBWm0clrgWw2bOY7k4SL+XVrJaXIms=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H3d5UMdVQgUwQX8ZoilwMIm7TBxA3bHY7bzCHur6DfAU3Qpp9pqeFEt6gKZl6qUldyUdf7GftM/8Bbr4/JdEQ9EXm7AwcHVRae3oP5gsvjj8eKm7eSY6kb0jbvGPGSdbwS8qz3FIYO958BGrupeQy6c4OVUf6LuEOIMFizKjcIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com; spf=pass smtp.mailfrom=altera.com; dkim=pass (2048-bit key) header.d=altera.com header.i=@altera.com header.b=u1zXpjtc; arc=fail smtp.client-ip=52.101.61.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=altera.com header.i=@altera.com header.b="u1zXpjtc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gn23RHRnYwor5scpIOF+RnhQH9PktCO3AyW64M1IiYkFNTCJXDOxO24eTSLBczMiqYIwQVU74isz3nNjUdPbTXQcZtkhzIquAREH4ulNqmN7y5yg1ZwSOeqXQAJreB8RwHAbJfcIQc2/y1+sLPoU29EpiMP2rUbHAX+W5Cy7TPd2OFcDn22F7Dz429ElnCkgETCIcELp+dLyO6fCH4j6stt/SyGpP2frc+d/ZdE03uJaUf3Brfl5qQZTrNfU6UHsUTS1O4PpVrkHtSvM37e76mQ/m829rs3ZDnjbIf8INkY0gHAQMt8u7iLCriNxN8ttXS7tSTeqBxehONSUIZYZew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QplZBtKzAoLsdZf59Mhs4ANaqwzn52fo71OXV+xdlNQ=;
 b=GSoGukN9yH2eflWayfg6lLCTRInMYLjPstHp9dTYNyqsipEGPxHj851AKeoCdwNbXOke+nrKBqy3lW7OdDHXNlOXJL2i4u0OJGprE602bLOd61Ee6dUBGTzJ74vJFqZ5bNsIavRlRYAeDk9pGzEShdnKsRkCyBFad4cW8136YppPz6ANRFEqZeKN8/jNotE68NuNMdjKVt1iVFr/YfSpGgYc2F90Ay2GkPmG4sCVqRH2o3VWO0zok8loLpNVj0E6JxwhVSMe+Ei4CTfH6pTfaRrRnphcN4D/N1dnu88i4pHpc/pY0SFOWPxqihe0E21c5+/1vJOKvGcRRi0LaKtvsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QplZBtKzAoLsdZf59Mhs4ANaqwzn52fo71OXV+xdlNQ=;
 b=u1zXpjtcdCBIuXgsv+3sbmnERl5EIl9ncWN2OK56cwnMsRuBaCbb0WgkPeC1216q+ie36z8vnACK/pXpjuAurGrEL/Uojd1tHv8KCC2Zt3Ur+eLjofREW1cqYWLnoSgLGbDnADfau+Cw9Me502mqx/VwyI+IOXgYLZmJ+u1zICDGVgN1H4XHXsaZzz4wWRQiyJj4n6bH1wrAmGy2PM1733iGxJw6KL13GnsgOu23lBEJ9SszSQAZsAuok0IyAhmJszQ/dsQaF7/m10P7L/GYi9nTIzFUiTexf+PJEpuyl7wubx+t5oocRCVwAaXQISBpB/KPT5buMVmxiYzlZSGPFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from SJ0PR03MB5950.namprd03.prod.outlook.com (2603:10b6:a03:2d3::20)
 by MWHPR03MB989455.namprd03.prod.outlook.com (2603:10b6:303:29c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 06:43:15 +0000
Received: from SJ0PR03MB5950.namprd03.prod.outlook.com
 ([fe80::53a0:bf93:6b6b:de01]) by SJ0PR03MB5950.namprd03.prod.outlook.com
 ([fe80::53a0:bf93:6b6b:de01%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 06:43:15 +0000
Message-ID: <ba6e3c46-7758-4fee-877b-a08988fcab4f@altera.com>
Date: Thu, 10 Sep 2026 14:43:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 364/456] firmware: stratix10-svc: fix memory leaks
 and list corruption bugs
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <34cef7ad-8730-4a49-b6f4-8307adc1e36f@altera.com>
 <2026-09-08-daily-reply-0005-stratix10-svc-mutex-bounce@kernel.org>
Content-Language: en-US
From: "NG, TZE YEE" <tze.yee.ng@altera.com>
In-Reply-To: <2026-09-08-daily-reply-0005-stratix10-svc-mutex-bounce@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To SJ0PR03MB5950.namprd03.prod.outlook.com
 (2603:10b6:a03:2d3::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB5950:EE_|MWHPR03MB989455:EE_
X-MS-Office365-Filtering-Correlation-Id: b4008f61-3e88-4c90-ce86-08df0f06c9f5
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|22082099003|18002099003|55112099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	67HofXAI/GOXDkktLwEUjAgEXKtYcHvJ0yOljG2Kq1U/8QoIaQA3UCsEwDZQd7SF97GaSupegr13nuztmI2E6h+7ndb7rZ6cPT0lzzVWFeXv2YZd5C6FlB4ZdUubPTjB03a1RnNYhI3l+Ve2CtIDBppo5qWizOyK7hCf3ADPFasIhqE4T4FnYoJI3Jmpl93pQPNWhs8J2tyRY65kBElDkepjGbjSrKHCKRki8+xonrU0SIKPfzxL2wD5TK9Q3M6b1BoJ/5WhHwNtwWrIZYLsv2e2YthWzcO3hAWr6J/n/ud4pAxX4/qyjQXRgfpZ/VCgknsF/FdJD/WvznRyLiwMm0Em9DseK3Nqps2O2h3EL1DHGDC68PChiw+6joZXjh9zmbE0cXaEv+UbVvgXXZSoQ8FQzT3KPLN3ahmsLQY30QBBJ8F6AvsKlQ/C/44GMg//zflI8EIhfE7Kd+pkST9d4Hw/VKg9sBrm+d+fxLrfZ7lBog31QHIm962ZvghohbDRy9b5r0pkpZZFMTjwpJfIMIfORXGmwJ5OMM8PDB9O9xVxrdsOYo0CIZPmFDqyjnfFOASiVO22PLWh+J4CoHMBPQ8KuPCNkZ3NyiIr/GSiCKPUOGU8pcfNBHuhKWi8ISUykfvhdfdiPrGZ2p6SHblyeNPB7cz27yx9DLQgKc7HgC0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB5950.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(22082099003)(18002099003)(55112099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW43Umc1L2pENndqc3BmWVRlQ010elNZd001T29TSjZHU2pFcjdkS2F1RW9h?=
 =?utf-8?B?aTY5aVNzdzcxOFlzSGpQcThBS2U1alI1bjlvK0g3aXBuTU9GRFV5d0RmUnVS?=
 =?utf-8?B?UjZBNDFTSjNKd3AzY3M4a1NPZDFDZ1FqOE50RmxZK3k4N3hZekxJRENiOEMr?=
 =?utf-8?B?TisvZm1JQThFM2N2SGJHYWlRUWZFUDZzYU5IYzdyLytDS04wT2tLZjRlSDVW?=
 =?utf-8?B?VStrRXdtWEtsZXJFN21PS1kzakp3VWFiekV0OWNXMzRvVGRoTWwvZzlTcHli?=
 =?utf-8?B?SzhpbzFWWURaeDVkT2hRWXFpRm9FVXJaWThEbXZyVDZCeFZhN3JsSHZMbWpC?=
 =?utf-8?B?R3dwNWNFTUNlYUdlNFlla2JCYldob3Qyd25LK0dGNUp3YnhSaEJYQzMreTc4?=
 =?utf-8?B?RHhwODEwVzZzWTBOUzJVenREME9XWm1Vc01aZ2ZLLzNFSm1sWEVoaDNPOVlp?=
 =?utf-8?B?SmdNby9BYXEyYWhsQTBvdDdWb3gxdHl6WDB6aWdybk5SV2xrWm1NL2d1NFFD?=
 =?utf-8?B?RW90QU5VSWFkdE4rd2kwdEo3b3JJdkhrSXI4MWpsT3F3ZmlpaDRVRWF4amJ6?=
 =?utf-8?B?TXFYck5EMzF2NUJQeXcvaFRQQTh4YWJNN1VOdUtGb05MRmw4aGVNUmJoVFU2?=
 =?utf-8?B?TXNrTldaYThueWlxUHViRDZ0RHNwak9uMXZ2LzRYN09ma01zd012Q2NPWDFu?=
 =?utf-8?B?VUErbXo3THVISGo2bndueUoxUUFGQzA0Qm80eFgvRlN0VFZCRmswRUw2dkJa?=
 =?utf-8?B?ejU0RFpiRmwvNGVKQlNiMHh5WGx2M0Y4UkgyZnJad1c4Q21Ka1ZZLzUyTWpD?=
 =?utf-8?B?Q01TdGxpWmROVWpyaUFFRTM0YlhCcmNITndJcHVyc2QxTGV5KzJ0RnZpME5n?=
 =?utf-8?B?cTV5U0cyTENkMTIwcU1OWWZGQ3JtUGpkbmdwQXZHam5nWEdGdElERFFlVDJL?=
 =?utf-8?B?ZjQ4M01tRTFsenNKMFNjL05SUnpLTDNzcmo1MXpYVG1LZzNWQnB5R0RXdXE4?=
 =?utf-8?B?alB6a3R1bForTUVZckdqODJZblMvR2dhVGdaNys5dDFwUlJaNVV0ckNtTFgz?=
 =?utf-8?B?bEpiUmN2K2J3WU1za0U3MkR0SDFrcWdOeVFGTTZOQ3E4RTFROUVIWFcweEJw?=
 =?utf-8?B?Z1Yxd1FPWURoaStSellHUkI5ZTB5WEdlTjd6S0tka3NsSHc1OW5IclN1QnJZ?=
 =?utf-8?B?OUg2UWxwRGs5QzIrOUYwdExHdzU5MmNTTTU3L25EN1lOdXBMbTN3OWUvS3lM?=
 =?utf-8?B?Z3dqVW5MR1ZuRkdwYTR3M00wRkx4RFlHTk5PSVhjWGFta1J0TlA4aFE0aVhh?=
 =?utf-8?B?ZEtWUjA3d094S1d4WW1GUnpqY2l1RXZtRUx6YzZHSTZRRmFlMExobzgyVGhD?=
 =?utf-8?B?SWxBSldoZW5IbXVuMkxBVC9xbm9PNXFjV0djd1pvOGtUNnNLL3A0c3JneXRR?=
 =?utf-8?B?SVVwYzdzTWMyNmM3T1BabE5vcS9qcVd1c3F6cElzbkk2N21wd29INElJUUlq?=
 =?utf-8?B?TmUzMzV4NS85b0V6U2lQYlVLNUZuZDdFRm5xTmdqakIrdFVubmk4NkJ0aEJx?=
 =?utf-8?B?ZUdVUGJ0bDdYSmJTcGtKYXppRkpkamNaK1hob0VQN1RUMDlPOWdlQlRXZytX?=
 =?utf-8?B?NTBHM09ZU2V6Q0ozWkF0NE9Hbk51b0VLU2ZHa2d5TDkxbDROdkx0OG5IWDF1?=
 =?utf-8?B?VEd3TGtyYVZvTUYvNTFQSG00dE5Ua2MzMU1CemNWN3JFbkRYNnc1NTdhVGwz?=
 =?utf-8?B?aG9Tb1k0Zm9jZGs2ZUZFYU1JNkFqNkZBZFMzc3l4Zm1OM3grREdUS05TcTVM?=
 =?utf-8?B?VWhPZnh1cEpWazMwVUFEeS93UFVFYnEzYWlkY2lMT1ByR3JRdTlWNjluNFBI?=
 =?utf-8?B?NUozRXBvU1lMQjdTNUkzMVNmSU5MZzJtaUdTWThqaDdtOC9iUVVaQy9QMkxP?=
 =?utf-8?B?YmtHY0w2VnYwN05VWGJHNmNEaVZTcFVLbmdYZ1pKbDVraDRPUjF0MmNpbnJ0?=
 =?utf-8?B?M2xNYy9HR0pDRWdKVUpMVU40SGtaK0wvRUordFdLSkRUcXpHOWZFTGpwb2Yv?=
 =?utf-8?B?RjhIeDlpcmZGMkhkTDRSV1kwbWVYUnRXbDFYSTVvVEl5cHF1Qm96UXN5aVlv?=
 =?utf-8?B?Z0tqYVBXeSs4NmJpazdYOUptNVp4T2lraHU1VWNyaFQwSEdXYkUvTlkzZEgz?=
 =?utf-8?B?TncxRllVQ3g3YlhXd3NkZHpGT2dpK1pmOHJHeXE2RndHakQ1T01meTBDOG5E?=
 =?utf-8?B?TFhsLzJpYlNOTFFKYWRGaUdXdHZXR25zMjdJSVQvWTVwTUY5UXhhZUFxQ2tV?=
 =?utf-8?B?aTNNL2FvL3pFZlFGekE3ZWZDb1R5MEFQSmxManpVdjZhQ21iMEdtZz09?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4008f61-3e88-4c90-ce86-08df0f06c9f5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB5950.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 06:43:15.0006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2zUBa+VI6tRgV6nsZggzNyhOkDx2OcAYzMC52Gyj7BsAuI1vSMBhWRxBczoF4/22Iwp/BRQ1Zq35HvXhD4OaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR03MB989455



On 9/9/2026 6:39 am, Sasha Levin wrote:
>> Agreed to apply this to 5.15y:
>>
>>     firmware: stratix10-svc: Add mutex in stratix10 memory management
>>     [ upstream commit 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ]
>>
>> Tested on an Intel Stratix 10 SoC Dev Kit (arm64, 4x Cortex-A53),
>> v5.15.220, with KASAN, DEBUG_LIST, DEBUG_MUTEXES and DEBUG_ATOMIC_SLEEP
>> enabled.
> 
> Thanks for the testing, but the cherry-pick build-breaks on both 5.15 and 5.10:
> they're -std=gnu89 with -Wdeclaration-after-statement, and upstream's
> guard(mutex)(&svc_mem_lock) lands after executable statements in
> svc_pa_to_va(), stratix10_svc_send() and stratix10_svc_allocate_memory().
> cleanup.h's guard() expands into a declaration there, which is a hard error
> under C90.
> 
> Could you send a version that places the guard() among each block's leading
> declarations instead, or takes/drops svc_mem_lock manually without
> guard()/cleanup.h? Happy to take it from there.
> 

Hi Sasha,
I've submitted backports of 85f96cbbbc67 ("firmware: stratix10-svc: Add
mutex in stratix10 memory management") for both trees:

5.10.y - 
https://lore.kernel.org/all/893f8169cc68d614ee36efc9151cc60d0f82872e.1789009964.git.tze.yee.ng@altera.com/

5.15.y - 
https://lore.kernel.org/all/dc0e2d1f4c4f722f5528197c4835f64442561397.1789011103.git.tze.yee.ng@altera.com/

Thanks,
Tze Yee
