Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013079.outbound.protection.outlook.com [52.103.43.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060C7232367;
	Mon, 30 Mar 2026 08:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774857829; cv=fail; b=e7guzY7D8gR54BZC08NuE53eVhDH9pk9h1ZHK942R8HcpD0PCVwsCB4q0nMcAyMDI/2nxuiWNJ6sH0R3yU5/F+sKKp89xIsdGB+bOPEYr36Xlytw8PvmzDCpSEyTuNjJxY49C/jKExcuRI7Qxi10bVXbIH3QvvWQDEJ9qTlXI4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774857829; c=relaxed/simple;
	bh=5J904womhhMpCpy2pfBD2VszQPu8RxsdeLqfwtRTmT0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FpMfhC7ZXdvtPM+kU7CTDVR8FjFwJTR/Z4L/OKYHSmV8rq8KwWEC750kYGLyEDk3PRBlVufZuG0cJa905QifMdeoCGCGGkI1hQ+QlxB6TIPMZK10ingPS7K2yDPQdF0AFFGeow1obZM9Ku4gwTHZhgGu2e/2WQwSTbleFl8O17A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=HZaxnv5q; arc=fail smtp.client-ip=52.103.43.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="HZaxnv5q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgwxFFhz69zkdwOaI92/WFQN/1rf4af8m5uuRGOPnWuLjpRhN5uL0dDze+Di6AV7ZGn4e5gv3dCnnzNV14yL5A5fhil+Qqitm7jNRzxXgNaSh6F5Kquz08xpIqom+w8MJ6ZGnNg5rIGfapNPqYTSgi//v8tNjX4oOsjYPmV/t2p61Y3GNoIW5+pX5fOe/whhZqLOGLFGgYD43B+WA1n207iL3BIP+FftQ5hVF6WMfN2KGBmzrOWrS5dFEUsZ6ZJMNrNhoC2fzmHZq1F0bjEK+T12RTYEYVUT74iIbW8CzRgtUCqvOLPDjlwtAuH91BK2GIkfPr9OahoD8JwewrlMbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OCk3LMEcKxWOu4FZqZYIO9kX5xtX6v7moiVlCb34hU=;
 b=bwrVD789odxr9aljjV600E/PFyiYYHqGvQAsmjUlh85ZcO8TmeL4IFaKHyF4DL7BZPbtL159+kiHPxRouC0mPa8M2BEzX2SYLVIcAgZxrC9wJWGVCPzS+BbK+FibVO0Dc0ueon85Z7/CkJryiEDkDveY1fBSY02D3oi6+Aj26Rjda3ziOvqnagT+RoN8EVKYVia2cQHqvB0Ubfq1QfmaTC97d3taa9NgQl7et9sKlYo3tQ7qlNrfTQXzJuhMalSAHSRyRtlLJs2qifRg/KsvbAAyPi+3zljDVn9zFq2QjAq4sKt/49uzmNbnA/+ootZZfGiNRLjNiG4iLX5CJDa0DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OCk3LMEcKxWOu4FZqZYIO9kX5xtX6v7moiVlCb34hU=;
 b=HZaxnv5q0+n3FIhX9uhV/0WeT6ixetZ/mYRFBbxA9ynxbUiTTp7FggKePhvRCskH3B84QcqXd99ed2/2fxsxlqFmhBznomLiLtyykBoROaNsdB5Kc4jpw0Qe/WNO5DkNDpNg2ZZnu4fyY9SYOn6Kp7Hxuc939TUMkSq6vx+eO1aP/zGbOPBD7KYdjjtzFg7QOUm+vVQAx+cC2o5b4waTSfOf44ElUjgYwG513ga/bFgvkv/JPXvEcT9Tghse7vTvr4wqgnXjr7xiNorBYmiWGh1JBzVY0lKhE3btKwONXYSGnnc0Zp1nnmWxyM6FwANvhIsc1lbZqG1I3Cn9kQxy+w==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by TY0PR01MB5441.apcprd01.prod.exchangelabs.com
 (2603:1096:400:32e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 08:03:43 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9745.027; Mon, 30 Mar 2026
 08:03:43 +0000
Message-ID:
 <SI2PR01MB4393461E48F8CE929313A1A8DC52A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Mon, 30 Mar 2026 16:03:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] iommu/amd: Pass last in through to
 build_inv_address()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <2-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <2-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0048.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::19) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <832d7b80-4bdd-4dd7-a24f-6251cc16ff93@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|TY0PR01MB5441:EE_
X-MS-Office365-Filtering-Correlation-Id: 362bc05c-4d5c-47e3-be93-08de8e32dc2f
X-MS-Exchange-SLBlob-MailProps:
	WaIXnCbdHrPy8Gg0T1tV+ubdyTLMpos/1zIduhWrySWWMEHN5z+Z8xLUSoTuryLwqibMT6VIbNKtan7h9s+PB0/uy3Erozv/7GBWxo2nv5gNFu28eQqDpEArVIRMd4j00MdWxJ2yx5LozXWWzNh/xOCxKo25H/b+9sZ87DvyW8CFEyA3XhSnwwPDL+5t1in18I3uArrYggXegYGHcSXnK+Pj0yFIS9e3ySIjYdjdWC66GuIa14lfw6M5Etttcy4592AuqR+YwdSq9Baj6Zq7N1yCY0Uu60QjtoRQrOJYTLCPc3ZCFT6rnFbB368ByA3ByghKhC9DWjQNVu4QUvUCkyC2l8OeCMcxGDQXG6CqakflQo9G2uQFyOsxDKeQ329TUaArTya6qfDolfJ8HYIyDJbFhzeO4wRqldWZ2N6UcKMzAuE8Di9uQ0kQgBPhE5joggXSl5wUOyDfKCrd/JaUMlSH1iqqTTLyjmUeb4qGqko98YGIClgPRzZUz5HiV96pqKtFqNnoIer2QkU5NOAVlo1BpIn75WPZxTVsgKsLtpJZC7Etp2ylxPIOHAfDzCMvRr/ZSsr5cjyYt7bNM3dDJzwke38xKBJs40BgJMx+RaBOqp7jcoAkMjbBndm4R+p+9xXdYEMaugsJsqxq/g5gmsf+GeB6vP+D+8GMyD5RyGjue+80CgThqqWPY1lUruISSQXV6WziVy5Q+uQDIBy6m1/t2LpM0t5eRSuxCS5DVK7Goy7yKxcnx5+Dr2hSVXlUyfv2YurIx28=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|461199028|23021999003|41001999006|19110799012|51005399006|37011999003|6090799003|8060799015|5072599009|7042599007|13041999003|40105399003|19061999003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUpDcDV6SUpOODJ1VnExL1g2aU5sbmJBT1JYdlhIK0tYd2VLajF0SWU2Vksz?=
 =?utf-8?B?MW5yOFlpQzIwUUZLSEk4M0FwaThKeDcyOXFDWUlRNXRyRXFmUVFsRTJjZyt5?=
 =?utf-8?B?UlQ5dzI0bEQxR3d6ajRDL0swWnQvUmY2SWVkNm9uek1aYXIwNndjSFNlRSs4?=
 =?utf-8?B?NFlETllDT0lwU1NyRHBPY204WVJQdTAyTGkxQW81MVZuSkg4SU41M014N3Vm?=
 =?utf-8?B?OFN1blphNGp1VlpOSDNqMXFKS0U2cXl3dXA5NFdtOFdKcVdYY1JqcThtSjF2?=
 =?utf-8?B?SW5wd0RoeEZ4STJBYXd0UEdza0F1bGQ4bmYyRzF5SDcyVkJhK2hxeklVLzFB?=
 =?utf-8?B?ZzRIaTB3YTFTcmhPN1ZNWGs4Wm1qOXhlbEJEdUVycHkyTHhhNlE5T2FRTzBm?=
 =?utf-8?B?bDF1M2RTYUZkYTA2RWM1Z2dvQTl3S1FnTjgzaVJNeEUyY1M3YWtybGlNM0FZ?=
 =?utf-8?B?Y1NCRnpKbnV2UlBIaXI0NEdRUkwyczBPQlJ6OXY5VzNKa2NxdEc1anhxYUt6?=
 =?utf-8?B?M1pMTmlvVUR4ZHFOeUpjOFNHWTd5WUE4bXUxRnAvM1hkU3pRUmg2OGRFL21R?=
 =?utf-8?B?cENzc0U1WG1vZis1dlNXZUcvUW1FV1ZNb0N5UXlicW12Q3EweG10WWExc1lw?=
 =?utf-8?B?RjFvMFhrbXZ6cGtxb20yTDNaZHVwR203NS9mNGkwK3NmWHV1ZFNEMmMxaTdW?=
 =?utf-8?B?SGsxdUhNTURGN014bndtdytHSGE5ZkhHQXMzaFVLYU9yS1lLVGhCeEY2TVBX?=
 =?utf-8?B?dzJ0dTJvc3p0dUNpTllQWko0aWVVb29Ia3ZvTTdNQjJOaU02WHo0QTVSM21I?=
 =?utf-8?B?QkkyR1A1cWZkSVovcVduVkFQaG5sc1dKRlVNY3d6ajU5ZmUyZ1V3YnpDUTZw?=
 =?utf-8?B?VzJkRVZ5QU1hakR5R3RrRTVyRDZsWXM0OG93TXpnZXVndGxWYnBnRHM4TUx5?=
 =?utf-8?B?Z1lhUlZ4VEU0Zys4RGsrcVhjRXRxNWpWWFRndWRvKzBmVHF6dWM4YzNvNWlo?=
 =?utf-8?B?SVhCbmhZRGNOL2h0N0h3QmRGUnhHdmpLZWljci9qcVEvSGZBT2tCeU45S3dm?=
 =?utf-8?B?YXZHNXBkbklMUWVXS1FvNzVhbjROL0QrU1A5blpUZFJETUx5bzA0SXJxZEJi?=
 =?utf-8?B?RUdad0ZCdW0rZWV2dm03Tkl1bEVHME8xTVpTbUxTTmVUOGVubDJCSlNTZUxp?=
 =?utf-8?B?YUxLczFyU01EWWxLRkQ2VjN3UDExcEk4SlRnUk1wUUJNN2JyQ3U4czVDRlRY?=
 =?utf-8?B?ditPRFljRks1Q1F4VnN3RU9LYXh5cHh4c3hhUXhac01lMDF4ZUQyMlUyVWx2?=
 =?utf-8?B?dVFzYUVPRkJJQ245N2xEcjdwWkl4b0U2MmRBcUJaaDJzc0M4NEJEeWRiYzJx?=
 =?utf-8?B?TVpNeW9RWTVBRHgxclZFOG1kV1ZuTWY2ZEtQb0haQkdJL3A2SWllV054aWpM?=
 =?utf-8?B?Ri9WTGtKZ05lY0x1NGNic2hUcms0d3Y4bitEczdRPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzZCbXFkMVc3ZnRTTjc0Q1p2ZVpCcWpXSGp2UEJwL0tOMGNCb0xrbzRrK3hO?=
 =?utf-8?B?d2F5aEVXNlMrbGw4MWNycXdpNFNIUHNkbU1xdzU0NVFhdzJNeHNaTGg0aDdN?=
 =?utf-8?B?YWJoTzRXTURMTkhieGVCZmpoNEFydXFHYUVHVEx6eFFtU3RNNUtRbmNFcUVs?=
 =?utf-8?B?SmZsZXJ1QXFSTUJlU1EvaHo3WFdQM0hiTkU2dTZiK1FPRFFQeHp3T1I2Tlps?=
 =?utf-8?B?M1crdTB3eWVEbEhGTTVKNzBzSGNCakNOdDdIT3BwV0VEZlczYXlWeEV5SjAz?=
 =?utf-8?B?UzhGYnB2MzdxUDU5LzVEcmtaY0ZBYUppMVdVczF1M1p4NU9iVnFvemllQmM3?=
 =?utf-8?B?ZDNYdmZZMGtHeE1SZ1hIa3crNjRmaUhIbGg2RXk1WTZhUzhhbVBDRW9YbG8v?=
 =?utf-8?B?WDNUNWl2NVRFOXdrUnZzL1V4M2RqL0t6M0VQYkRKUHJVRXNHTzdnWmdzdS9X?=
 =?utf-8?B?YVNJNk91WGU5bHRNNUcrMmtLTEl4U3QzSlN4MlM1UUJkOTIxV0txQlpiS3Ja?=
 =?utf-8?B?NTRLV1lSSFNBNk9keUR6VzhxQmRaOFFEWHYzczQ2S2VoNVpBQ2xha0FHNWxn?=
 =?utf-8?B?bGRYbXM5MW8vUlBnSFVKUlo5RjRyOHU1ZmhpUTlkNFFLcFpMN2Y4OG81RGFE?=
 =?utf-8?B?S01GU014b1EvOHdsY0d2NFVrR2FkTnVpd0RkcEd0SEIyT3gwbWduT2g0S0pp?=
 =?utf-8?B?MDRpOTJybVNqUUJqNmpNbDM2MkdPWDhXZDZUV0lzRFI0K3pabndsM1BFb1Q1?=
 =?utf-8?B?cmxiS0tyMXBpeHVKalo2enE0ZW4rKzRMckdBd0tHSkFmakJ0Uk5ueW54YWY4?=
 =?utf-8?B?MUg0MDBPemM3UEtzNDdickFrbWVwV0FoaG1pVEZsZmlobWZVek01S3VVUVZF?=
 =?utf-8?B?SGRyN254MlRwdUxNMGtONGxVZHVacTZwKzdLYm9OSWltakM0QktENXZEbVRW?=
 =?utf-8?B?QU9Pc0hHSVdqaFAxNm9zd2lqRE93VWRKcFl6SkZiTnZGMyt5OTg0M0t5UU1R?=
 =?utf-8?B?ZnpBSmxKV2x3SUpvU0VOUGRMdTJJd3RCSHFHT0ljOEd4K3VOc0dRRFBkVnFK?=
 =?utf-8?B?OXJodnFBbk5OSWVPek1IQ2xCRTdtcGYzRWFZaVl6Wkl2OEt6NnlDNUdjVzMy?=
 =?utf-8?B?QWFjc1NRdEIraytsYi9NMjdDeG9QRE1vaFpsdVI2cFpmZmJlNDFRNlpJUGhS?=
 =?utf-8?B?aFJhaTFIUFNieHRVZGcwdzgrZUxJNnhGTlkwYnNNWEN1OXdjdHJkQ0lySlpp?=
 =?utf-8?B?SHpEQ2VRQVUzYTZHODN6TUgraExaenpKOGp6TVhQVHJzdVY0aVlUOUp5SFZ4?=
 =?utf-8?B?bHZ2YnRIMGkvSGRTY2wyUlZLc1BiWk9INUMyL3IwNkJ3SnlhQkU4bzY5Qllv?=
 =?utf-8?B?U0ZlbTFpcmVob2RCdmtDdVAxMERHNWU2eE83UnFrNEVtNC9meXNPR1RFQk1q?=
 =?utf-8?B?bFY1dHZYV1hyL1JUbGQzMWxpR01xdG8xeGFKRnA5WVpEZ0RrYU1ZaWFsa2Rh?=
 =?utf-8?B?K2M2eDlwKzRCdGFWK0ZVeExJU3psckVmMFdBMk82L2czNWxPL0JYWHhaWE5Q?=
 =?utf-8?B?NTR1QTIyS01iekFRYUErMW5Ic05JdVVCRkx5VHF0TWtvV3dUdnN1K2FnUkxC?=
 =?utf-8?B?UHVrT3NsR1Jybi9pbmFNeGtydXFCVy9vcEZ0Q2VUM1RRM000Q01jb3dTSE5N?=
 =?utf-8?B?MDMrd2RRNHpwWnJhZDlTNDU1SGxqditDd2p1TkgxNkplL24vTFZMSmZpcHlT?=
 =?utf-8?B?V05JYS9hd3ZMU29jd2RWRkV4ZE1vUExkamZpVWVEY3FmdTEvWUxtY0hYRVNC?=
 =?utf-8?B?T25XSWZjMlZ0N2x6aWtaZGpFbnVzd3VHc2poa3lUTkJlZS9XcEZjeVovZjFW?=
 =?utf-8?Q?ws43EmBb4HCDy?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 362bc05c-4d5c-47e3-be93-08de8e32dc2f
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 08:03:43.6210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR01MB5441

On 3/27/26 11:23 PM, Jason Gunthorpe wrote:
> This is the trivial call chain below amd_iommu_domain_flush_pages().
> 
> Cases that are doing a full invalidate will pass a last of U64_MAX.
> 
> This avoids converting between size and last, and type confusion with
> size_t, unsigned long and u64 all being used in different places along
> the driver's invalidation path. Consistently use u64 in the internals.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/amd_iommu.h |  2 +-
>   drivers/iommu/amd/iommu.c     | 56 +++++++++++++++++------------------
>   drivers/iommu/amd/pasid.c     |  2 +-
>   3 files changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
> index 1342e764a5486d..ef4ebecb003494 100644
> --- a/drivers/iommu/amd/amd_iommu.h
> +++ b/drivers/iommu/amd/amd_iommu.h
> @@ -90,7 +90,7 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
>   void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   				  u64 address, size_t size);
>   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
> -				     ioasid_t pasid, u64 address, size_t size);
> +				     ioasid_t pasid, u64 address, u64 last);

Using “addr_start/addr_last” or “start/last” would be more symmetrical 
and intuitive.
