Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012051.outbound.protection.outlook.com [52.101.48.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806BE314B60
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 19:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764790851; cv=fail; b=HV2HFM4gtdwkQ9mvOcoW/Gf/MJ64L1AN0hvyalzd3GLQxXizaN2BSLTBMOolRteSlThoXh00nDRqTWGdkfMCA/RO7iIodUjIcSMhJ55CFBamoDbq3+DuRYOYpIx/873ZItOUOeFHM7Qrayxj+0+kFNC6dmGViVdGFbmSOqVTrgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764790851; c=relaxed/simple;
	bh=OvVuwJeNEHGZqFgzZHs6qO9BXCdDKPM30wRDhuOQU8A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hbM5rD4+yqRSkZh5MJxFnxGToMlzxa5uU00A4K+oAH7DnklS7sXFMjvOco75zrfg0SZct7xcPdaQVhujC5SgcDMr2TVNZuDvaS7r6fVlkhvb8J95VsdlS27QIAV2YSPrL9jgJsB9f5b5qMau8y9owjTIKUOFVOR5xBNdwE4eht0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uF8yo6SI; arc=fail smtp.client-ip=52.101.48.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uF8yo6SI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGiu9Bp04bstVYzhqbcojWUzeocacZbvsGVuk39Orcdmf53qBhpV3AKEI6e+L8SXCOs0RVyiiBkQ6YTdoH6jyQv7gSOayPua56GLO3nesIIGqN1SfeyKbGQUyfraI3CCjQdg4yRb8I62YmpvpYww9aLfmtED+LF4LQnkonPKod3scjMWCLz5t6L4ezw5Y6v6/LLct+7a+KvHDgStjRyp9+rA6+r4+1e6yRy7i7JwsBPRLSRUW54hAJxPaDrNgvyTKep3cqJAsnBT3sSrdKVQHyJdvatHpRbocTFnZImSfp0Rm3w+oXg2LHVi5zmwQzNi9wSmDmCc2PYBbUlXFSwO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OnbbPA/iAVkI5+nVr0PeMUxZabAu+lKZm081izKJCY=;
 b=cwo3L+NdUuFuzUVLJanDIaA28eaZ2Vxa7Wcv/SIXhANcZihfKHcNPn5Owg+z20OWdM2z+iwZBoaFM8hmor5FUoueMzev2F3QSvK4pog1SALs42wxLgvbO9jMn4ntdqUVmKu+WKt6cOpyBmr5eEbzidF1odlf+k6+nFNCml+jBReBjD0Isn7LHr8WJjljJXBPbDHLo1e5N2c5olQe7B9CknZUgSfjMQ9XFwRxCmlmK65bftj9qxKN0JeZA90dTcyprxqCxd56DIc7l4uxjkZ6GD9F4KLasSvan2MwEJJDSveYdTXUu6EGQm+ny15NxzJ9wCWDCcBg2lGlTmrlSBdGsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OnbbPA/iAVkI5+nVr0PeMUxZabAu+lKZm081izKJCY=;
 b=uF8yo6SINTmu1/1yT3drT4g/4ursGc5g8s8Q7b/nWUbNPDQazXQGMviwVyLXSgTU/bO2MpBkIP8fKOvJ3UytcRmZjUKuWYfiR9BUgAwIB/a5EVoHOU0FFfDv5KQ6O2uU4/0JSta5criVwRElMTIXbEHA+5gQYkkIYv/XvU9OviZ0RddZ0ms1WNcD1ChsJASdKELdzxX8RitlCKsJHj2Hm5q0ra6mJddJYV9p4iDtufpPThDfoFqNiAQzhNNRaZ7E9xcNJ1ymwCW6R2lnyZhM4YFFmx2D4dRlquQJC8vRYJBXI+uf7Tqvq+GHOm+f6sSW5IJN9LvZr/Cn514H4vH4wA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SN7PR12MB7452.namprd12.prod.outlook.com (2603:10b6:806:299::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 19:40:42 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%7]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 19:40:42 +0000
Message-ID: <71a92d82-e941-4afe-a712-0a4d4c80ddfd@nvidia.com>
Date: Wed, 3 Dec 2025 19:40:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20251203152414.082328008@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0382.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::9) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SN7PR12MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: ede90628-d4af-4a69-94c6-08de32a3d840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T01rYnlqSjJ6a0k3dFpvajd3bk5mdHhENEYyNFNmSUZURGhGMHc5enM2N0hp?=
 =?utf-8?B?WTUzNDJqRU84a3YxZFJiUjFHcWxoVEhBTUt6eWdvTlpBZUgxUnU0U1NuNGhi?=
 =?utf-8?B?ZWNteGh2d1JLaFhNbEFsMjVJakxxQ09UUEVPNm5IeVVJWWtaU3dvQ3hIL3M0?=
 =?utf-8?B?emtySWd4a2hTTXVnR05CQXYyUG5lL21mRjBiTks2NmRmNEh5Z1RWSEZFeDly?=
 =?utf-8?B?QXovT3NPb0I4VHAvTFRDTnZ3M1NJSHhWTDBYVTF5OTE2UjYvdStoQitXdGVB?=
 =?utf-8?B?TG91TkZBRCsvQkc4QVJlNzV4NGg5SG9zbDFRUmQycThoZ2pCNlM0NGhscVdO?=
 =?utf-8?B?ZkQ3VnZacktTMTVVNTBMV0lrSFc0OTB0UGF6eTN6SGtCQmdlandZcHNUMTBj?=
 =?utf-8?B?dW9KLzErSDVtN1hjTU9WSE9CL1NVL0pNWk92MnVvR2NtSExZTFFmVkJzU1Ex?=
 =?utf-8?B?Q0taNlpEZS9idGp2Y0F3LzV3cml1bFZZV1dCRFJPQ1FzZ1M0WnhYNkNET29N?=
 =?utf-8?B?eVdmemhsR3BrNWNjOGIvcm9vcUh2VmlqdVp3UWdYYmVFY3dWSkVDN0pNZDZx?=
 =?utf-8?B?MExpQ3VSMFZmUUtiOWI5K3dQbjlNN1g3akd0OUxNL3RzYkFPcDU1UUlyaGFh?=
 =?utf-8?B?cXpwTjlhK2VaY0VXbStpbTMxR205NTdUZmhmWUpsVS9uZW9LcU1kNTlObjda?=
 =?utf-8?B?TlczL29EM1RMODBLR2NqT0Z5aGIrU1ZaOWlieDl3aDdSZE1OZ1RYNXhKRkNo?=
 =?utf-8?B?SE5TTHVNemk5OU14SHZZZ2VBc1BSdktWT24yWTY2NUoyTW1SZGZCRWNjTS8z?=
 =?utf-8?B?T2lCakVxS0ZaRDNWaSt1c1Y5UkZGZ2JLT2hQSi9nd0Y5VGtzTzcrQkxsVkxM?=
 =?utf-8?B?YmQ1ZytyQllCeUFZWUtpMk9PL2hTUmp0UWMwTGwrSjU0K0I0d0REbDVvT21X?=
 =?utf-8?B?bHc2d1FvWHNiMkFwWjNpOXNaWDNSQjI4SWVtQWcrM2pjRnJsQVN6YzVBeitI?=
 =?utf-8?B?M3lWWm5CNFNUQW1BZnFMRnFub056ZUpuRHdVUUt1RXZ4dzltQ1lBeEg2RVMw?=
 =?utf-8?B?bjR5WU5XZVRwNllYVlRmK2lwT1ZRaEhWOTJBWmNVRVdQU1JKR05teGlaWC9p?=
 =?utf-8?B?R2ZCc2h3VWdjQ3pYTEZ6TktMU0NnVXVNRFRVY3JOZGc5Rlk2N25sMEl4L0tE?=
 =?utf-8?B?ZHA4eVM0UlNDTElsTlVGZ3Y1OU5sUGJ6WEdBSEllTlNtemRmc0ZjcFdnbmtE?=
 =?utf-8?B?bys5S21TakpwZUpwaTg3QmJjaDQ1TFlOUDVXeFU5WFRyaHVYajlMRlQ4dnlF?=
 =?utf-8?B?a1ovQmF4M09zSnBBbXMxanNJVlJ0cDVJTC9iVmVub1RKMlc3V254N2FWV1lo?=
 =?utf-8?B?VFNtWGtaVmROcGlBRXJtMWJsOTZZSXBFMHlObGFlSFM5OTAzZkx6dkcxRVhW?=
 =?utf-8?B?OXZ0M1B2OVFBVElHdGFZcGhJTElhTDE4TlMvcFg0WUhSOWtFdjBxRk5maDV1?=
 =?utf-8?B?UU51aml1WFdOaDdsbzVETHJZWnJyaXM1TG9UUU56TkEwWEJvNThCUEs3U3F0?=
 =?utf-8?B?UnI1QVl2Z29hT0J4bUh6ZlEvRkdON3Q2Ym0wUlFJeUNqbWFiZ1hxbVBoZWRl?=
 =?utf-8?B?QThHbkxoRTBXaHF6V0g0Y3JLTkFqWlQ5ODdpTjZpcW1DamE3QmpnVVVzbkVy?=
 =?utf-8?B?L2hyREZycnpqZXM5NEhDSk5KZDk0WGlhSHdzQXgraWl2MURUZmhueWkwRXVX?=
 =?utf-8?B?cnAxZGtNTUdab29yRFBRV1BYMUdmSnZHdHJYRFFVdzY1L1c1aEVJbGE1OG01?=
 =?utf-8?B?cWVDQm1qTlpxNHJBQlRyc2tUb0tmYXNab01qMmZQVTVvMTlvS2J2U1BNN3dX?=
 =?utf-8?B?bmNyRGdvVDZkYUtELzkwUzhUSk5RQlhONS9CWDhrd0hFOHZDNlJQNmkrR1pq?=
 =?utf-8?B?RVlySVNuVlRNNmN6MzZZYnFVWnJwbFg1UnRWUjBmbDlqbkdyeSs5RU5ReVBi?=
 =?utf-8?B?QW1qSDdpZzNRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkEvajJHMlJwaEdlRFZINnA3R09sNnlvUUNkV1oyVHRrcjJ5VnJIR2tLaS82?=
 =?utf-8?B?U29rNUl4SS9VTU5RRlBoUnk3WlhpNnJ5dXM1YXhpMTBtSXhtYmt1VWFYSjJS?=
 =?utf-8?B?UklZOVkwcHkyaEpaV1M5UVVTTDA4ay83T01WS281c3J6UjQ4ZGhSR0grRjdz?=
 =?utf-8?B?QzJBOHBDaEtISUdjTmM4ay9QNTh4OHR5cHEvZFdBK1UwRTNFM0tlelFsSWFF?=
 =?utf-8?B?NmY5eEZHcWpaSzVXejhLb2ZwNnV5TEcwTkNrR2RBSnBBRmVJbGtXbHhzNXdE?=
 =?utf-8?B?MHJJSmhIYWtIR3dPYWk1dnRUVytCTThYNzRYeHZJSWhBVzZrOXoyZ01hSDRm?=
 =?utf-8?B?Vmw2clJzK2VvMUh5U2JnZ2tLRlhaWE80Zjdha3R1QVNYV1ZSNWNHT2Z6Nzl1?=
 =?utf-8?B?c20ydmZiSjYybFUza1BCeUlEYW8zbGFkMlJpK3IxME14S0VUQUxrOFQwcnJR?=
 =?utf-8?B?Ly9Zemd2dWhCYmJzV080MExBejV5Ni9SUzJCQnYxUkVzdjd6RFU5bkYvcHVr?=
 =?utf-8?B?U2loNGo3VGpQWWhmdzB1dkV6N1kzYjl1UDFOOGFtRXg5YTczaEpSQ0laa1JL?=
 =?utf-8?B?UkovOTFIbWp1V1crbVlObGxQeHhDc09TSE9YN2lwbVg4SUxhQTZYR2hIcnZD?=
 =?utf-8?B?K3lRWEh0b3RyYVVYKytPbWtZcCs1eFI2dlpvNGZrU1kwRlJ0Z0hxckJjN2c4?=
 =?utf-8?B?YUtQMDArUk9vWDlsOFZJeXRyODhlZnBDbGd4ek1idFo4YXdFbEM1bXZqakky?=
 =?utf-8?B?MU5tdDljdXJoZEZNQ0NIRlZNalBMVUZNa01SN1pWUkV4bFQyWVptUUR5dEdT?=
 =?utf-8?B?dE4ycE55a2ZYd24wUFF1dkRwY3d1dGNPNlhid3lJbnB2SFF6UUd6N1M2RG1m?=
 =?utf-8?B?QjNjK2hVTUZxZkptQktHdHpDR3VkYS9nMmxEYmsvMlFSYlZPeXFtT0ZtbnZK?=
 =?utf-8?B?bHdDZGUxR3JuWXJaUE1uZm91bUlTM3R1UDZMNWtqZ1JhYmJmMEF6VEdIQndF?=
 =?utf-8?B?SWdnaGZGMTlJN2Nla1RBRWlvempESGVFQWNWbEsxSGlzZEtTaEZxRm43N01t?=
 =?utf-8?B?RFozV0wxVytJdzhEOXlkN3crbUxEbDdNYkhoT3JUV3VHRVkxRndLMWdXWkFm?=
 =?utf-8?B?MkMvNHI1a0xKdGs2dU9jOFh6TmlqdGFXem1mS0dQenlSQkNlS1E1YjJpSWRp?=
 =?utf-8?B?M3QxOFRmZjd6NHk4ZzU0Z296NlZXWG5pYzJMY0JrZVQvbjJQLzMvK0FiUm9R?=
 =?utf-8?B?K3BhTU8vYzN1NGIrUEhGQ2YvWngvbkhPUnZEYVFFbC9Gdml4Ymp4ZzNiRS82?=
 =?utf-8?B?ZHNyWWsyM3lkY1V4SEF5VDNyMTJhVXFsWU56MmluU2p1bmpTWFQrRmN4K3JU?=
 =?utf-8?B?U0VTRGpidTRJVVZxL0EwcjAxc20rK0d1Ryt3WWszbGZBZGNBUXdQNHlxbmh2?=
 =?utf-8?B?WUdsejJZeHZ3TEE1VnBaaWxTMHltYTZtNHFoaHdDMGhYT1ZnRmRYME9rdTdk?=
 =?utf-8?B?THJsK3Q5VHVaSmtlUHFSK0NWUU9tMXhaNHRxNFV2enZTdzczWk05eHcvUHhF?=
 =?utf-8?B?dFZqd3RDMEpDSzdTNlgxY29PQW1qVDFZRm9OZE9sc3ZMb2lJN3Jva1E0bGwr?=
 =?utf-8?B?NjZsMkJpQTFxRlAzc0tJbHJpS2VKYm5aUjlzeFErQXZJUzRhQW9FTVEzSTlr?=
 =?utf-8?B?cXNCc28zc0xxdmV5bXVYN1ErUWVMMW9wam9Md2xKUEVjUTFNYkJmeVJBcDlH?=
 =?utf-8?B?MVExclVkZC8wcGtZY2hZZjZUa0NuV1JJcCtwblNYdUo5YS9LeHE3SGcxUVVF?=
 =?utf-8?B?dW1FblIxeFhSYUpWdW0vaXk1ckRsNDd6ZHBOU3BzMzRzVEZVR2gxMG9RY2dI?=
 =?utf-8?B?TG1zNHlZelJDNURYeWUxRTZjZFJFdVRSd2J3R0R1Qk5qdkVZWW41OTVFVTBL?=
 =?utf-8?B?MGNWZ0Q3ZU52eU9FWEhaZitDNGZNUGNla2RBa2VrTkQ1VVpPYlNSbkYvT2Yx?=
 =?utf-8?B?QXRabWJKYjZTbGJvbzFmbGpNb0VwQnhzOGxwVWdnVjA2ZU55VElrSVNmTVZI?=
 =?utf-8?B?Z2ZFUEZFL0VvNDFiNFZzazlDZDZkd1dKQzBNTFpHRGh5MXkrM0pmT1FUQkl2?=
 =?utf-8?B?U3pyZ2VQVzV1Rkd2VDAvUStMQ2llSWU3U0Z6VmxDeENraTZDTFFLZVBRcWY5?=
 =?utf-8?Q?y4BvIMdOukJvANf+ehd0Yk7JvZzH288LZSQ03cYWBthG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede90628-d4af-4a69-94c6-08de32a3d840
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 19:40:42.5407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFVYXsR8S1WKog3bWMUUwrRFpJkTvHNyTL0zMQd0iSe+Dn0VqBcRfSKDtEMdj1Fmck4W7Knl1LBRhSjpUvu6Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7452


On 03/12/2025 15:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> 
> Vlastimil Babka <vbabka@suse.cz>
>      mm/mempool: fix poisoning order>0 pages with HIGHMEM


The above commit is causing the following build error ...

mm/mempool.c: In function ‘check_element’:
mm/mempool.c:68:17: error: ‘for’ loop initial declarations are only allowed in C99 or C11 mode
    68 |                 for (int i = 0; i < (1 << order); i++) {
       |                 ^~~
mm/mempool.c:68:17: note: use option ‘-std=c99’, ‘-std=gnu99’, ‘-std=c11’ or ‘-std=gnu11’ to compile your code
mm/mempool.c: In function ‘poison_element’:
mm/mempool.c:101:17: error: ‘for’ loop initial declarations are only allowed in C99 or C11 mode
   101 |                 for (int i = 0; i < (1 << order); i++) {
       |                 ^~~
make[1]: *** [scripts/Makefile.build:289: mm/mempool.o] Error 1


Cheers,
Jon

-- 
nvpublic

