Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795479117;
	b=TncVN/Pxgcrsk0KAhDGg4+YzK5O2ndWZ0KXhmXMjP4lACmebzE8tlZEGWnE7cEjg4ShW
	 tVJxikZwYOqhwbxRUvk9cYNLtsEmsYnaou1JqIWWS5evm4hiyXbNHY6AgPD3dZ4wonBeb
	 XMPiR+IRtKceAH07eb/TO4aSL+CCYw/d5izQlG8y9b6cHwp7BQsiNlm5PprgvlNkiXNng
	 BoH7GiqbzCl6S40kcoS1D4/73XycUnEs+RvVqYhiF1/XLDus3yd9bSJsr6ACZ84JU2Jaj
	 gAE8738cOHE9sVc3edOQZKrk2TEXoI5PTyC97Zx0Tzd4ca/XFazOaBYHoHdYJxHCdvQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795479117;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=oNumITvty2WbcFY0w46/FLwiDIqEGFQWNae6TTgfk5E=;
	b=dXXUFT7515ZWarqhG4OKlLTXFct/jgPx+IQYUMncM5bZICARovGZrWuNdPxhCHHg59jS
	 XTVaDrsiFvAdhQkOgKFRtjvU3sUIbqzQDallfMkQmbjVBbaTQ0XtIkJckcLWgsGpUAn8c
	 EnxcbU3Ji+iN5g6axkCcRlLkw8UBU0Kxc07E44OcAxBv7FXV6KMezao3AXjArB2gmGNHk
	 9UBl7M+5gZ02IMQRA5lccccMhBKRD/ZG/gNdqpujWDZHrPcp6kqKZMZtdEyyQs79+110C
	 VCIeNtkJZawOYdol7Lt59FgLUMZDcBEg/Kb9beXlL0JKH4Hs4F/dIj/jbsCYLSIB44Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=U2nqzp0s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.56
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD5606A31E;
	Tue, 24 Nov 2026 00:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68CD5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=U2nqzp0s
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMqAQwEvuKtKejkorimOHpvadN0TGjEwjMkl8M1f8cXvZvJyuyRxKmf9fj/slvt7YZhBWSNLE2m6CaDd8mjtmOxFxQ3VKik4JTggmTVrDja+SLvfYQCnc6N0gFcf/7GylvjrNfBzjaeNCOeNf9kKSKu4CSiEsqC7DTwnQDD4ITJwnEn+i9jsW6i/pRomyDZICL8q4Gjmt50VWZqVy/BgUllZIQQmqAYRJROEV1j8a35UEU70/nViQRzq/HSqMZuk5ksMQ5tLCB9YI1FG08tNdDfRMRCfTGnv90yypbVqfL9Dl3poIo55zJCLRZmxT/pLy91HPLeiyz/oFla4KK8QxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNumITvty2WbcFY0w46/FLwiDIqEGFQWNae6TTgfk5E=;
 b=OUHZ4Y0f9sLI7tz5ozg1ly0incG4t31FISd/cwTNZ3U6x5fdpnZQKs6xerSnNFRB5aiZxMaAr//5RL1tWooylMcs06fVPBU94aHGdkPFLnQESr8X4ICTHMgJ2xAV2yB0eTxTYYBKXXA1qkJK/eznsZX16hTwn3Ope4rZaonFyzYDZJrSNapgASTSdb0yw/KIgXTowj8eh39n/BS24LV83FVlb6k/vuZ3N/yReaUs0WUg3tG0UwJpwqWLaUKAiTnVfmlHl18WCKg8CbvsN83pchum1czGjaodoZzk1g/Z62k41hfV8ezWPDQF02LVcLJdq3ukZBS5jVa9fxRM8CaA5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNumITvty2WbcFY0w46/FLwiDIqEGFQWNae6TTgfk5E=;
 b=U2nqzp0sd0NNtkQWwV0KoKPfxaMR4j2QC7eoE7iGYZNRR8HV9fIkoehp5nA5VBDTzGs8szrOsnTfASyjTUauQwEKc+MBRk7yx2MZ0acRB7V1XhdY8sgC4ymXwRjlR95xWrpqBRR5XlKkp220m+eZm0Vhus/s7wLRPstLomWdVOE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by DM6PR12MB4041.namprd12.prod.outlook.com
 (2603:10b6:5:210::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 00:11:53 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:11:53 +0000
Message-ID: <f377271d-353f-4c8e-94d5-98159a66ab28@amd.com>
Date: Tue, 24 Nov 2026 11:11:49 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] PCI/TSM: Report active IDE streams per host
 bridge
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev,
 Dan Williams <dan.j.williams@intel.com>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-2-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261123083337.2731019-2-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0175.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::26) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|DM6PR12MB4041:EE_
X-MS-Office365-Filtering-Correlation-Id: fbc07a2f-325d-4c89-3c45-08df49bf8b79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|261009221227099003|261009223027099003|261021121427099003|261026140227099003|261022075727099003|261022105027099003|261026121527099003|261028144727099003|4143699003|56012099006|10067099003|261102123227099003|261102130727099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	kJaH0R2kvM1qEwBpymwmmxFDXuQfzRztG/ejMRstQL1JEvRbUmGLiAvfN2UBT2A9w/NoEHmwhET/X2RKtN6M8P2gt4MOBdQD8H/4an1Fez/XD8qnekOJtod/wEe2qLbeoN8rHV9k5AqtN6LPDURHFCvD3aSZlQfK5anGWuZ/FvAvZjNvoEVQ6D6h1c1yYw+xu2Zl14qbbAMJo3/YWxN/LOO8GU815DeUHQc234aL77/jlc65nCEVmfCmQifNoaUnlT9fZFDcqIuuQzlvAGKa8Hw2rdz5VjmcqD6JMU9BsGOAjQ0rJnlZOoFrftjgi845yU+yVwksXGQ0D4SHPmAPe7a3KWhklIYGx/tcVIc0pmdy5W0LOFeEgt8MSJHq5z8Dtzn2qZOU6ysaTqB8z2xSS8aQiY01QbI28EayzxFmlUUS7t0fCxvHnOU31jtYlWpdcTjBZP5DXt3WROMH6MNACUku8uziubAi4YVElu4PyFIpL7IFAaGstDfajP59oQDccKv2TAsYaC13V4SzhzU3of068QeVjZjRwIyTFcEBbJF1OsMKm9j1VNYlWTMInpv7pVagC8ZDzYwCoeNY9DmJ9cQ33+/C0dl6A654d0oLHm6h/7ru5LhzC8Sq8UAafxMb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(261009221227099003)(261009223027099003)(261021121427099003)(261026140227099003)(261022075727099003)(261022105027099003)(261026121527099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102123227099003)(261102130727099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFEyWFFSSGRxajA0RG81bFRxalFWNmdQeCtYMEh3cW53dnF4aTF1WHVxU0ll?=
 =?utf-8?B?TWNmZWVyZlo2OUdUc3FwRzZCK0Vmck1wTnhMMEZCVmQ5SWplTkx4Mlptb1Yv?=
 =?utf-8?B?eXFLQXJhWVRvempGWjV2S0ZGSXp1NnZqQ2xHQ2RpUU15dCtuV1h6Y21LNXRv?=
 =?utf-8?B?S0xIZHp5SXREUzE1c002T1JaQ09tQW5PRktBdzVkK0xUVUU1MkJKT0F6c2Fa?=
 =?utf-8?B?OUJObGpBZ2Qza1FucmdxYmsxeTBkZHJsSjRIaHczTGROV2tUNTJWZXZ5Ni9U?=
 =?utf-8?B?SCtoc2JuQmZiRFhPK0VHc09XckN3anZyYjNiSEo2dkZCWGFrcFNnNUtZTUlH?=
 =?utf-8?B?dDNCL0JwbERkdCtUQXJTTXovT0NPQnlDR2ZpdDhpbHVZUjMvMFhzMURJankv?=
 =?utf-8?B?anFFZEVvZ3ZBWUNxL3d3aGZzRXFtcHZIVktmY0xyN0dvUFhTV3YrUmhpSG5x?=
 =?utf-8?B?Ulpzd1M1RVJpVy9JQmNLVHNMazJPVkVzcys3UUJzN2YvakY0eFN3T1Z4Z2la?=
 =?utf-8?B?VVBnZTZ4aHNFOFl2Y0JEMFBaZGhnK0lXTHNoVnlSKy9OTjJYQmlrNXdoZGpQ?=
 =?utf-8?B?SVFWSk5OcUNuaUNKTjhBVm0yYVg0UC93Y3NhWGwzUm5SNXJjOUJyamRlVHhz?=
 =?utf-8?B?R1FjU2Q4dmFxOVJsQWFVVTY2aVA1UmFmczdWbDl4VFlxOTMzQ0V5eU1Oc2ZG?=
 =?utf-8?B?bG5RWW9kTG81Q1pINUN0OUV0QTZJemdMYTY0dlpIak5iSGV0dmFUMGtHV2V6?=
 =?utf-8?B?eGxHanZRMWpYaHoyZ0ZPYThKZ3NEWlQ5K21yZTBzVWlrSXFyNnhtczlnK3dh?=
 =?utf-8?B?c3YxdnZlL09OTzNRd204TUJLTzVFVEk0ZmN4d2VhUDdrS3RRRVIwcWFRUXZm?=
 =?utf-8?B?Und4djdKcmlpcm0wY3VlTWxaQXlrZC9FZ1UvTDAyUXAzeklnZ3Azc1gwa2hJ?=
 =?utf-8?B?eGNFa0lucXo4ai9kVEl3cTJWaHA2S0ZPaUh0RStVLytzNDd4d2RyRGhXOXBW?=
 =?utf-8?B?TmQvc0xndnNzZ2oxRzJRYzZtblVsdEl4Vk1pekQwVVlrNjBTREpzWUwrR3VV?=
 =?utf-8?B?OEMwSWhkbnRmT0ZjQ3ZqSlMvMEs1S0VJU2RPSUkwUTJHSExRQWZtOG41QlZL?=
 =?utf-8?B?cExGdUZweEdlRnA4WTNwWmt0Z3o1bWN5SDVGVGE3THZOSC9KMjFCRzV5VFYw?=
 =?utf-8?B?VEdZZE41VGV1R3p1NEt1cGZaenZnOHorM3RHL0o5RVFGM0FycWRsMXp3R0pH?=
 =?utf-8?B?Vks0WUJ2NG9JV0JESFhUbkxKdFR5alVNUzlTUG8wSmw3K1lCMlV5ZENNSTVs?=
 =?utf-8?B?U0tPUnh6ZkxxZEpvODRmaW5jS0ZhQkxKT05TQ2dKY2hlWEppWlBNYjhsdU9j?=
 =?utf-8?B?b2NyWktTa3VKMitRSFRKdEhLSmF4dm1TMllJeXRHT2VxcTRMbUhVT3NtTDdo?=
 =?utf-8?B?S0pjY1Z5WDJqUk1GOXdmdkNQdkZaUjg0K3FQSHk2MUFBdzNIZXRBTGRwWmdw?=
 =?utf-8?B?Q2ZCSFdrZVFHQlhuUVY0QXoxL3lZWVdBb3NnbXdWRURoTzU0czJUa1dQTERX?=
 =?utf-8?B?NThCQUhIMkVTRmVWMW43VkN3RDEyMFhtOFQrUzJ3UjI1NGdrbW10MnI4YTky?=
 =?utf-8?B?RFNCUmZjNlJWQmwrbFFKOU1ET3JqckhDZGxSMytlSzM3c2NDMkQ1NU1HVlBO?=
 =?utf-8?B?dDBBVmVDWFBhY0RqeHFZaFN3N3VxRitEeWtBdGI3VmhpRGwwSjZTRGttWjUr?=
 =?utf-8?B?dk9hRjRuWDNEeTAvUDVrRjAwU25sNXZCdFdDMzRMV2RiR0FXM0JhTEUrWndJ?=
 =?utf-8?B?L0IwQllvVThrRVZuWFg3SUpHOWY2cWFqUWJWazlFTkhOZ1pwT1cyeHRXRUo4?=
 =?utf-8?B?cy9Fd2R2M1hZS2R4b0xrQm83WXd2WlcvVzJHclhpZFlXUGZ3NWNlOGY1Y05w?=
 =?utf-8?B?eWthMjUxVE9rRGNnNzB6UTV6ZkpMSXZ5ei9hV0NwLzdoQ2hYZDZTdXQ0S3NX?=
 =?utf-8?B?YmRKbjNBa0E4Tkk4RmNlNVkwNWhieERmQ3lDdWw1NXNYODZQRzJYQmx4Nzkw?=
 =?utf-8?B?bjg1Y3VFU0lrRmJCZDk2bGFDYm9Pdk4yN21hVGZVaEN4QTdrd0JWbEdQVTlp?=
 =?utf-8?B?YURxbVlhZWZnUTR5VnoyVGFnUEw2WDZRcFVsMThSMXk2amtFT3BHcVRCTHBo?=
 =?utf-8?B?eFM3MTdOV1NROGk3OExJOGJhbFlCbkVtYzF1TFRuL1FKZUxEc1pBWU9OajVy?=
 =?utf-8?B?dmh4d2g2UHZXb2k5d0xIZVBmQStzV3IwWDd1TmM1YW5hRTQ1eWt0WEVJYzdn?=
 =?utf-8?Q?Ndy4OTpmGynDDPIwVj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc07a2f-325d-4c89-3c45-08df49bf8b79
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:11:53.8247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFJjCH56/LftZMvva6KdQh+NjOIDWv5OdBTGOIlWYs6/C0T9wPSXGWvHqwVMD4lT05Kj0qE6tjV9uHK39q2cXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4041

On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> The first attempt at an ABI for this failed to account for naming
> collisions across host bridges:
> 
> Commit a4438f06b1db ("PCI/TSM: Report active IDE streams")
> 
> Revive this ABI with a per host bridge link that appears at first stream
> creation for a given host bridge and disappears after the last stream is
> removed.
> 
> For systems with many host bridge objects it allows:
> 
>      ls /sys/class/tsm/tsmN/pci*/stream*
> 
> ...to find all the host bridges with active streams without first iterating
> over all host bridges. Yilun notes that is handy to have this short cut [1]
> and from an administrator perspective it helps with inventory for
> constrained stream resources.
> 
> Link: http://lore.kernel.org/aXLtILY85oMU5qlb@yilunxu-OptiPlex-7050 [1]
> Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   Documentation/ABI/testing/sysfs-class-tsm | 13 ++++
>   drivers/pci/ide.c                         |  4 +
>   drivers/virt/coco/tsm-core.c              | 95 +++++++++++++++++++++++

I'll take to the tsm tree, thanks!



>   include/linux/pci-ide.h                   |  2 +
>   include/linux/tsm.h                       |  4 +
>   5 files changed, 118 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-tsm b/Documentation/ABI/testing/sysfs-class-tsm
> index 2949468deaf7..1ddb8f357961 100644
> --- a/Documentation/ABI/testing/sysfs-class-tsm
> +++ b/Documentation/ABI/testing/sysfs-class-tsm
> @@ -7,3 +7,16 @@ Description:
>   		signals when the PCI layer is able to support establishment of
>   		link encryption and other device-security features coordinated
>   		through a platform tsm.
> +
> +What:		/sys/class/tsm/tsmN/pciDDDD:BB
> +Contact:	linux-pci@vger.kernel.org
> +Description:
> +		(RO) When a PCIe host bridge has established a secure connection
> +		via a TSM to an endpoint, this symlink appears. It facilitates a
> +		TSM instance scoped view of PCIe Link Encryption and Secure
> +		Session resource consumption across host bridges. The symlink
> +		appears when a host bridge has 1 or more IDE streams established
> +		with this TSM, and disappears when that number returns to 0. See
> +		Documentation/ABI/testing/sysfs-devices-pci-host-bridge for the
> +		description of the pciDDDD:BB/streamH.R.E symlink and the
> +		pciDDDD:BB/available_secure_streams attribute.
> diff --git a/drivers/pci/ide.c b/drivers/pci/ide.c
> index beb67b8fb5c5..19f61f957fb4 100644
> --- a/drivers/pci/ide.c
> +++ b/drivers/pci/ide.c
> @@ -11,6 +11,7 @@
>   #include <linux/pci_regs.h>
>   #include <linux/slab.h>
>   #include <linux/sysfs.h>
> +#include <linux/tsm.h>
>   
>   #include "pci.h"
>   
> @@ -370,6 +371,9 @@ void pci_ide_stream_release(struct pci_ide *ide)
>   	if (ide->partner[PCI_IDE_EP].enable)
>   		pci_ide_stream_disable(pdev, ide);
>   
> +	if (ide->tsm_dev)
> +		tsm_ide_stream_unregister(ide);
> +
>   	if (ide->partner[PCI_IDE_RP].setup)
>   		pci_ide_stream_teardown(rp, ide);
>   
> diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
> index 696c1abfece7..f07e68dcf6e1 100644
> --- a/drivers/virt/coco/tsm-core.c
> +++ b/drivers/virt/coco/tsm-core.c
> @@ -4,11 +4,13 @@
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
>   #include <linux/tsm.h>
> +#include <linux/pci.h>
>   #include <linux/device.h>
>   #include <linux/module.h>
>   #include <linux/cleanup.h>
>   #include <linux/jiffies.h>
>   #include <linux/pci-tsm.h>
> +#include <linux/pci-ide.h>
>   #include <linux/pid.h>
>   #include <linux/sched.h>
>   
> @@ -273,6 +275,98 @@ int tsm_unregister(struct tsm_dev *tsm_dev)
>   }
>   EXPORT_SYMBOL_GPL(tsm_unregister);
>   
> +static DEFINE_XARRAY(tsm_ide_streams);
> +static DEFINE_MUTEX(tsm_ide_streams_lock);
> +
> +/* tracker for the bridge symlink when the bridge has any streams */
> +struct tsm_ide_stream {
> +	struct tsm_dev *tsm_dev;
> +	struct pci_host_bridge *bridge;
> +	struct kref kref;
> +};
> +
> +static struct tsm_ide_stream *create_streams(struct tsm_dev *tsm_dev,
> +					    struct pci_host_bridge *bridge)
> +{
> +	int rc;
> +
> +	struct tsm_ide_stream *streams __free(kfree) = kzalloc_obj(*streams);
> +	if (!streams)
> +		return NULL;
> +
> +	streams->tsm_dev = tsm_dev;
> +	streams->bridge = bridge;
> +	kref_init(&streams->kref);
> +	rc = xa_insert(&tsm_ide_streams, (unsigned long)bridge, streams,
> +		       GFP_KERNEL);
> +	if (rc)
> +		return NULL;
> +
> +	rc = sysfs_create_link(&tsm_dev->dev.kobj, &bridge->dev.kobj,
> +			       dev_name(&bridge->dev));
> +	if (rc) {
> +		xa_erase(&tsm_ide_streams, (unsigned long)bridge);
> +		return NULL;
> +	}
> +
> +	return no_free_ptr(streams);
> +}
> +
> +int tsm_ide_stream_register(struct pci_ide *ide, struct tsm_dev *tsm_dev)
> +{
> +	struct tsm_ide_stream *streams;
> +	struct pci_dev *pdev = ide->pdev;
> +	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
> +
> +	guard(mutex)(&tsm_ide_streams_lock);
> +	streams = xa_load(&tsm_ide_streams, (unsigned long)bridge);
> +	if (streams)
> +		kref_get(&streams->kref);
> +	else
> +		streams = create_streams(tsm_dev, bridge);
> +
> +	if (!streams)
> +		return -ENOMEM;
> +
> +	ide->tsm_dev = tsm_dev;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(tsm_ide_stream_register);
> +
> +static void destroy_streams(struct kref *kref)
> +{
> +	struct tsm_ide_stream *streams =
> +		container_of(kref, struct tsm_ide_stream, kref);
> +	struct tsm_dev *tsm_dev = streams->tsm_dev;
> +	struct pci_host_bridge *bridge = streams->bridge;
> +
> +	lockdep_assert_held(&tsm_ide_streams_lock);
> +	sysfs_remove_link(&tsm_dev->dev.kobj, dev_name(&bridge->dev));
> +	xa_erase(&tsm_ide_streams, (unsigned long)bridge);
> +	kfree(streams);
> +}
> +
> +void tsm_ide_stream_unregister(struct pci_ide *ide)
> +{
> +	struct tsm_ide_stream *streams;
> +	struct tsm_dev *tsm_dev = ide->tsm_dev;
> +	struct pci_dev *pdev = ide->pdev;
> +	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
> +
> +	guard(mutex)(&tsm_ide_streams_lock);
> +	streams = xa_load(&tsm_ide_streams, (unsigned long)bridge);
> +	/* catch API abuse */
> +	if (dev_WARN_ONCE(&tsm_dev->dev,
> +			  !streams || streams->tsm_dev != tsm_dev,
> +			  "no IDE streams associated with %s\n",
> +			  dev_name(&bridge->dev)))
> +		return;
> +	kref_put(&streams->kref, destroy_streams);
> +	ide->tsm_dev = NULL;
> +}
> +EXPORT_SYMBOL_GPL(tsm_ide_stream_unregister);
> +
>   static void tsm_release(struct device *dev)
>   {
>   	struct tsm_dev *tsm_dev = container_of(dev, typeof(*tsm_dev), dev);
> @@ -290,6 +384,7 @@ module_init(tsm_init)
>   static void __exit tsm_exit(void)
>   {
>   	class_unregister(&tsm_class);
> +	xa_destroy(&tsm_ide_streams);
>   }
>   module_exit(tsm_exit)
>   
> diff --git a/include/linux/pci-ide.h b/include/linux/pci-ide.h
> index ae07d9f699c0..381a1bf22a95 100644
> --- a/include/linux/pci-ide.h
> +++ b/include/linux/pci-ide.h
> @@ -82,6 +82,7 @@ struct pci_ide_regs {
>    * @host_bridge_stream: allocated from host bridge @ide_stream_ida pool
>    * @stream_id: unique Stream ID (within Partner Port pairing)
>    * @name: name of the established Selective IDE Stream in sysfs
> + * @tsm_dev: For TSM established IDE, the TSM device context
>    *
>    * Negative @stream_id values indicate "uninitialized" on the
>    * expectation that with TSM established IDE the TSM owns the stream_id
> @@ -93,6 +94,7 @@ struct pci_ide {
>   	u8 host_bridge_stream;
>   	int stream_id;
>   	const char *name;
> +	struct tsm_dev *tsm_dev;
>   };
>   
>   /*
> diff --git a/include/linux/tsm.h b/include/linux/tsm.h
> index 0996b888df21..866a71478d3c 100644
> --- a/include/linux/tsm.h
> +++ b/include/linux/tsm.h
> @@ -162,4 +162,8 @@ tsm_viommu_get_ops(struct tsm_dev *tsm_dev, struct device *dev,
>   	return NULL;
>   }
>   #endif
> +
> +struct pci_ide;
> +int tsm_ide_stream_register(struct pci_ide *ide, struct tsm_dev *tsm_dev);
> +void tsm_ide_stream_unregister(struct pci_ide *ide);
>   #endif /* __TSM_H */

-- 
Alexey

