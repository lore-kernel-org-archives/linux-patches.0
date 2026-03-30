Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012061.outbound.protection.outlook.com [52.103.66.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF53A0B26;
	Mon, 30 Mar 2026 07:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774856367; cv=fail; b=LChVLWaoCs0Y0OU+GYU8o9EVRW1vGyJa4vy9xpwN3a56+9NXSvXhAFIR03OVIqH6u6YY00PavFx0eebfWxi6ARVCr+gP+8Yf33NPLdlvR1fDSpW2Dfc+pCEkGrgzDv8Odk7c6gZAekXXB2RMfNPhIWXlFmxBKwt/bDeWptQ6za0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774856367; c=relaxed/simple;
	bh=8zxHu/jsVvuQQGiIZKMl5WrmATgHuWAGp6Eq8CcgjR8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jmj76tBM7BI+YFcoKS9AiaqZ28xxcwp/uvRIY4hpVrKuFuZlzwWweSZwEO8GX/AweoNAwa5uD+rSF0uO8YL96DYpjyPoO85j3AseVIIpNXV3mOcNhRbB6fgoEUUBnin6RMyf0YrFodmDCyph2rEFYtpvM4Qaxd2etJ7vNP2Cs+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=KJrJimsb; arc=fail smtp.client-ip=52.103.66.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="KJrJimsb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWE2BQtBGNIw4bDhsFj+BSIOVrthentSLsMXDTCBzH5PUcal8bnAKxyfGN0LpunyrS4L+oQsd96A1UmuHCO/qG6pEM0kZFvApyTA2mSQatNfT43nCVtXGbxkfYH7y4ZT6kkO3ksHAROFWJNSueUgnW3Os7dkPlsi3jbmD71S+aQFru3fJhsW7dP3KvgWY9yiLsU7VMVYiQVObu+rzW+9IPFTN8DdkkmEGDFNu1iGuj/PiWMEEZCteuwc/eaHJWL0mEmKS9m3rSjvr4Hd8VZpJjgud/B0K/O9cadOi0/Zxd63B5+kxw+fwSeMNB4LtHY/OEvvj1Kq1pjgXN4xFoaCww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nYaYhpUi0QHHEPfRG/O2MxEu1SlZCead8eJYv0kfH0=;
 b=tDddAaVVVGuWLz5UpiSddFUnNZkdwNcIkI/uU8mamEZKbVRyVZlnMGgKIeijwQgMhzaXDkXLZo2hPW6T/RPnsGnb5wWB1xOJVqAjxjn4ruI2pbQNkHlzGYIbA6GC6AIu10zpq/0ek+hm/5IjMFQaQntEgQU0UcVzlMcDC62caX7lNWLKc7kNaarfuf6ptM77rHrtvF5cdbbA8An7246gUX1pTVdEF1gsLxw+PWqG1D1TxKM5QVUtLgj3phXNu76Qh0WvTiPxVxcFqoOTfj5aZAc3FABunnJJcYuTVY44km2tNldoAb67r6Xm8TaNv/oQ1/bi1Wr/MJb7y09CnSEGRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nYaYhpUi0QHHEPfRG/O2MxEu1SlZCead8eJYv0kfH0=;
 b=KJrJimsbOaYhB7S+9wmecCq45uK30Vybkkzki1wEs06xLexPbd8fRHF9jjczhFsjOWlCO4dLTGTfLaQ3ybk+jb63xWlLwJIZ7RmjVs9L6hIdhAOWzF3k7AIUTxCvkbenZTiSYVzhwc7vvvW1YR7KcTX5713CT7Kc2a/VqW8xDTtreYCdLk1HEjP/GiPr5vm+tVr4BWnSq4Ydo8hnNEqX/54a9HVScpoAp/B+Ao26Gy2h9Y4Z/xw+BT15Y/IFAGPCJVVABx6hz0otbSFO6HmSxjBw0XJvIH9tFiMF+VGEFftqBmHvxnYBbXrBFNOSyWTivam92ZDuNS6ei4iQgTf/YA==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by TY0PR0101MB4144.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1bc::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.27; Mon, 30 Mar
 2026 07:39:21 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9745.027; Mon, 30 Mar 2026
 07:39:21 +0000
Message-ID:
 <SI2PR01MB439395C17C83A66A3E614470DC52A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Mon, 30 Mar 2026 15:39:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] iommu/amd: Simplify build_inv_address()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <1-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <1-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0057.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::16) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <f76a7b5a-8f4e-46b0-bfd0-f69ddf931e66@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|TY0PR0101MB4144:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d48c24-2888-44d4-3b4d-08de8e2f74d4
X-MS-Exchange-SLBlob-MailProps:
	9IecXKUgicB5Y5xtj3Bi4po1AHQXatGhDzGQHov1GVHjHOsPSnFFDTU5OcGW5w5SoXcZ/k3x2WhtJeUkI5WooRZYghVdyz2RAGo/CGmCrTUo17KbsOhVnnf3+IbwkkSKyeTNaH7OU8WyOGdkOLxJqPsgb75jgDrpZZvcFuC3B/QU9C/xXXbC6ihd2YnPAaWEzWj1vW2PUA5YTcE3lDB0FPaVhcBGiOxWjggtTk2bg82Y0PFoc0dqux0H97IbzMs0MSG6rVUwwZClY39QYjKsKES6h7xuPUgQIKUb71LoJ1GtPx4GSMTncnpKznEMA2CagI2Vld95c4TscBuVQLooBttZf8Ldj8FiTtTFCSzkPslDCDom3/t1yLDS1KEnkZo55wbhj0ZzxIz6nJXoNiyzHJSi23TlBrifE9UkpKxs+OlxDO9Aj7HLiwFe2yTUp3RU0BruK/EgZa5BERBWj9+mbNlYvQGO2fmFbwSFUZKvL62RmC71u1LS++zYzpBnurIYWrSjgLxHGK4fjZrpNiTdc08Mka+YAEBOKVSJSAX4BkdiByW4antwpqOWWjdQ1ZbLH0FtT9L4Gk/ejRgWmYpzmHVBU+fTO0cGPZitpqU4fXHGVxCa6UFQKd2JFVBJibDmufYVSk2AZeJUrWZzh3YIozUIpiZdNqGSgIY13hL4Z1UWDNH9fWbgTWS+5Nt+tz/GTZjspclmdkX2FQlxj84noIWFsGNqxN/VkKagP65czNGPIvEDsGV5lQ==
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|8060799015|23021999003|19110799012|15080799012|7042599007|6090799003|5072599009|461199028|51005399006|37011999003|440099028|3412199025|13041999003|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0h3M1BtRWdPb2NWY2pZcEMyNXhtWFVXSkpldnRmdlc1MDZ2YXBRa3h0THVX?=
 =?utf-8?B?Y1FqcGNraU9QUHBtRk1LM0xXOHBxQXNXQnN2Z3ZUbWd4U3A4RndRcUl0L2F0?=
 =?utf-8?B?Y2RQTVpYeEl1V3ErMnNXVmk5eXZHZW1TTHpxcERYWnBUTHp2eHNLQXl5blBn?=
 =?utf-8?B?b0NkTDBvWXhaem1UZ1lMWlBxS2lnbDFMWmJ1SWlpNk82T1lBL0p3YnJBd1Ni?=
 =?utf-8?B?Si9nVnFaeXJTejlRT0NLelVFeTdMOWR5VkI0ZWJDbmpkL3VpMTZFVnBKeFVw?=
 =?utf-8?B?MGE0RjN6VDNod2JKL09CK1RtRXh5SFJzSytQeUpuajZ1ekdQQStpVDBVT0hx?=
 =?utf-8?B?V3pSdXVjd01UYkpWa3gwUlA3cG5Qd0VhVXA3NnRNa2VHYUdLSC9SSmpZOXNq?=
 =?utf-8?B?Ti8zcUxVNnFuVU15ODFJdXRac0ZuQ3A4aVBTL1IraHZJYlM1MmlvcHQ0bjZO?=
 =?utf-8?B?OXFYcko4VzJObVhHdE9VNVhKYWc5MnRZZk85MStyejdpNnM5aTlkbHIyaDRs?=
 =?utf-8?B?VmpSSEdKbDFSUzVicTNENG9veFpLNmZSaVZFL2FzVnFrUzl5L2h6WUpTUG9i?=
 =?utf-8?B?bURmc3Y4a1FWY2RpaE1wN3hMWmRPUzFJQkdIWXZWWGFzZ0JLaDdPcnltcnlh?=
 =?utf-8?B?b0ZIR2JMOU50cmthRFFiL1owNXBtZk9DY0ltYUN5Tnh1YmpkckxxWFVnSmR6?=
 =?utf-8?B?VVB4VW50dDFJSTRXZ1FQQzMrV1ZsRmY0RG9XdWxlZmtWVmYvRVR2QWh6WThD?=
 =?utf-8?B?SkpCSHNoSTd5LzFEVCs3S0VQbzAyNHlLcURlT3NXUEVjQ1hFTFNrbGM1aGRF?=
 =?utf-8?B?aFVoRXB0MWQxaEV4ckFZSjRoSTVialdKYXFnNm41aUc0TkJQY2twTnVWZmYy?=
 =?utf-8?B?bEJCTnd4QUxGZVhhS1NLRWtMbjJqenFMaC9WRkU4ZW84WU9NZlQ1b0F2b2V0?=
 =?utf-8?B?Mm1KMndmbDFOaUppeFlYK3ZRUEFqMVR5NEQwSUhHS1NPV0gyQ3FhWXk2SG5U?=
 =?utf-8?B?NU85SmMwQk9vRllwUEFQQXVpdzNPRmpjV3VaLzlBUEJ3Q3BjNDJrSUh0VGor?=
 =?utf-8?B?c1J2S0REVHBVbEJWSFpMWmQ0SmhJNEJYLzhRSXByVndGUDJSZTF0QlJqSWJo?=
 =?utf-8?B?WjBmMTFJZUN5S2FZTXJ0RHoyQUh6Q3MzNkwrcjZjRUllQi80UTEvOVRFVUZK?=
 =?utf-8?B?ekJZZ1R4Qm9jUUtVNHZwMnRJMk1aZDRzS01CTi9sNGora3Q4YnJFVG01UmlN?=
 =?utf-8?B?MFNDUGhFNFh5S3k2Y3NjSUlCMXd0M3NkbGxBd3EwVVNjRW1HT3VhMU9Ic1RQ?=
 =?utf-8?B?MFBQZXhRcTlyWFQ0Unp6UUx3YWY2TmpwSEttUlhtYjEyYnY2Z3d5L2F5TkVl?=
 =?utf-8?B?R2JnV1pwNlpRcmFFL0tTU0FLM0lZY1RCK0ZmSjZjWFZzWC8yVmV2ak14Uyty?=
 =?utf-8?Q?7FC8f5ud?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ck90OE5ZQWo2NE82NnZtNTNJejJBOEVjeTlHU29qQkhKcE1JNUxoVEYwUURB?=
 =?utf-8?B?SXlwN0lwOGd6UkVIQmZhc2FOWm1WWFhadmgvYkJ0NFJXOE1pa09HYmc2UlM1?=
 =?utf-8?B?Zkh0SjZTeHg2SkdWTFJET0lQa1o1QW1OSkF5TmRZeVp6ZEE1UWVrcCs4NmYr?=
 =?utf-8?B?cEZDODM5VWc1Q2lPdk03QTYvcTBoc2o0MGdOdGlWUVQ3RFV4TExjazhwYjFD?=
 =?utf-8?B?S2VKOTZyaFUwNGJjSWFucExMZm4yVUpDRW9VNURBN1p1VHBsWjVSbjc1UU9r?=
 =?utf-8?B?aGxuYmNZRlRqQmVaa0FEMFUvZ0ZCNlAyMUgzUnNzMncwRFM5bTNFZTBpdXdC?=
 =?utf-8?B?TEpwaHRzVzJWdDk0cW4zQ3VtR1BtR2FQYUlJNmVpdHplK09SV3pVOXM3dTdW?=
 =?utf-8?B?U3haTlg5TnA2SlJtZ0ZZMmNWa3pGbXlRbWQzUGdKNTdTWExjK2EzaTVndGo0?=
 =?utf-8?B?aXJkaXZ4ZHFiNFJjNkNRUDcxbEFVb245TlNQYU5kOHNQZ2lnTjhtdExpWGRB?=
 =?utf-8?B?em0zTFY1Q0lRaG5jallua3dmaE4rT1dJYkhRamRENkZqeTVJRWRhZUdJc29t?=
 =?utf-8?B?LzgrNk9uNzhVN1lZNks2MDZqcEdFSkJSOWpjQVhaTngrZHZQSmdjM3cwbmk3?=
 =?utf-8?B?YkIrYWpyWVEwZjhwNWlXL3d6dFhwMVhxVXB4RjAvTjlzMzBjVFBUNGhXMDN4?=
 =?utf-8?B?WDIvb3FMZ0NwZEpnTW9pS1NiVGMyampBY1RuM2JEWHRDdllFRm4ySktkWEJk?=
 =?utf-8?B?K2NzN2VPT2kxMHc5UHQrS2RVcHdjV3BSc2dXV0pjaVZwTDNHMFRnVVZDWSt6?=
 =?utf-8?B?d1lYUE8vSzBWRjJKSmlKQktmalYweVYvQ0k3WGQwenE0aWhOaldWcDNMVk5D?=
 =?utf-8?B?R0lITVZ4QVZCNEtJWTlobE1zWVp2TUlGQ01SbU5UekhKd0JwMG83SzgzZG0v?=
 =?utf-8?B?T3BUL1BQSWxpMWZnR0RQWWNrT2hueWx6Um5GYTV4NEJFV0hwbzZYenpZN2hr?=
 =?utf-8?B?aEduSmYrYjRlRTJya1RSdlYrWmpKMURMTWY0VVByRnI1L1pDeHViUG1iR2Rr?=
 =?utf-8?B?akY0NG1Vc2tHQ2VVR0N3ak1rS08wMzhzQUtxZFJDQVFGdUI2b0laRWtrR0xa?=
 =?utf-8?B?T0pBc0xkeE9CZTkvZW5NZFNTTFBQUlFDRFIyUnJKQjZ6L0VwTlhvR204bi9C?=
 =?utf-8?B?b2VURmljRkZRVzMyTkhvWFV4TElaK0hLT2JROS9QSkxweEMzRWE3czRBcDda?=
 =?utf-8?B?bnl2dnEwZlMvSXBqMk80WGluY1o0Qi9sRi9lbFJnN1lhNlRiREFsbGJMd1lp?=
 =?utf-8?B?Wkdtb0U2SnlrbWRlNTFZUnNFK2ozc1JqQkN4TzZsZm9RV2Q4NU1ITEo4MDBP?=
 =?utf-8?B?WUxNTFdGb2VrOEdvK3hLb1pRUE01TWdoMDEwc3ptWVFmaFlqL0tRSG0vU2Mw?=
 =?utf-8?B?ZjQvVUgyTDJ1aHltMVBqVU1QV1JtcEpFT1lWblltS2JTSVdnSkxkMmtuM2NG?=
 =?utf-8?B?eHBmQnpDYnRqYVZEK210a3llOWozWitKRm5RektrMTQ0Qk9IYWZlYnhiWWpW?=
 =?utf-8?B?MW5WNW9ab0M4MDJSK2tTdkFOOHJJclVrUFpoajRma0dkd2RXUWdrQkYreXcw?=
 =?utf-8?B?QmVxS3hyWmg4ei83L2ErSVc4UWNGalIzKy9IeFFkWDIvM2R6WHB5dTFxbUJV?=
 =?utf-8?B?cXFOcTVxL0owQmF6ZVdPOEpldzBhMWZFemJJWDVvSFE2UHFQNWlWRkV2NnpK?=
 =?utf-8?B?MDgxMTQxTWpGbnJxTXZ2S3UxNkNnd3NEYjdXUE1uVEZjYjM0N1VPaWZLUUti?=
 =?utf-8?B?SC9SanZzY3gvZ1J4eW96aHNONmNsNlBDaGtTcXJHQUVXOVczaE5TWDE3UVpr?=
 =?utf-8?Q?5eciQMKAX8Uz0?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d48c24-2888-44d4-3b4d-08de8e2f74d4
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 07:39:21.6639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR0101MB4144

On 3/27/26 11:23 PM, Jason Gunthorpe wrote:
> This function is doing more work than it needs to:
> 
>   - iommu_num_pages() is pointless, the fls() is going to compute the
>     required page size already.
> 
>   - It is easier to understand as sz_lg2, which is 12 if size is 4K,
>     than msb_diff which is 11 if size is 4K.
> 
>   - Simplify the control flow to early exit on the out of range cases.
> 
>   - Use the usual last instead of end to signify an inclusive last
>     address.
> 
>   - Use GENMASK to compute the 1's mask.
> 
>   - Use GENMASK to compute the address mask for the command layout,
>     not PAGE_MASK.
> 
>   - Directly reference the spec language that defines the 52 bit
>     limit.
> 
> No functional change intended.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/iommu.c | 50 +++++++++++++++++++--------------------
>   1 file changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 528ebdd26d71c9..28308759bb3e4d 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1267,39 +1267,37 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
>    */
>   static inline u64 build_inv_address(u64 address, size_t size)
>   {
> -	u64 pages, end, msb_diff;
> +	u64 last = address + size - 1;
> +	unsigned int sz_lg2;

Would naming it shift (or order) be more conventional?


>   
> -	pages = iommu_num_pages(address, size, PAGE_SIZE);
> -
> -	if (pages == 1)
> -		return address & PAGE_MASK;
> -
> -	end = address + size - 1;
> +	address &= GENMASK_U64(63, 12);
> +	sz_lg2 = fls64(address ^ last);
> +	if (sz_lg2 <= 12)

then could use "if (shift < PAGE_SHIFT)" here.

> +		return address;
>   
>   	/*
> -	 * msb_diff would hold the index of the most significant bit that
> -	 * flipped between the start and end.
> +	 * Encode sz_lg2 according to Table 14: Example Page Size Encodings
> +	 *
> +	 * See "Note *":
> +	 *   Address bits 51:32 can be used to encode page sizes greater
> +	 *   that 4 Gbytes.

"than" (seems a spec typo)

> +	 * Which we take to mean that the highest page size has bit
> +	 *  [51]=0, [50:12]=1
> +	 * and that coding happens when sz_lg2 is 52. Fall back to full
> +	 * invalidation if the size is too big.
> +	 *
>   	 */
> -	msb_diff = fls64(end ^ address) - 1;
> +	if (unlikely(sz_lg2 > 52))
> +		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
> +		       CMD_INV_IOMMU_PAGES_SIZE_MASK;


The spec mentions "Address bits 63:52 are zero-extended.", should we 
enforce it:

-#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS        0x7ffffffffffff000ULL
+#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS        GENMASK_ULL(51, 12)


also for the returned "address"

>   
>   	/*
> -	 * Bits 63:52 are sign extended. If for some reason bit 51 is different
> -	 * between the start and the end, invalidate everything.
> +	 * The sz_lg2 calculation with fls() ensures that:
> +	 *   address & BIT(sz_lg2 - 1) == 0
> +	 * Therefore only the 1's need to be added. 8KB requires no 1's
>   	 */
> -	if (unlikely(msb_diff > 51)) {
> -		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
> -	} else {
> -		/*
> -		 * The msb-bit must be clear on the address. Just set all the
> -		 * lower bits.
> -		 */
> -		address |= (1ull << msb_diff) - 1;
> -	}
> -
> -	/* Clear bits 11:0 */
> -	address &= PAGE_MASK;
> -
> -	/* Set the size bit - we flush more than one 4kb page */
> +	if (sz_lg2 > 13)
> +		address |= GENMASK_U64(sz_lg2 - 2, 12);
>   	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
>   }
>   

