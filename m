Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510003438AE;
	Fri, 29 May 2026 09:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047237; cv=fail; b=TI8EOUK+oHxByoLJAHZXaPLrq1gjoX6EGAdRvlIcqzMXada3VZXdMXH4fGnZr0x+Uju+b0da64wuw2U3wQvmFoDVGIjcvrgO1SbdlwlCvaRXsfQwyAB6lbfJyGVk+xCzFiFBWpUeliIDW2ZaAJFL82UAt55Se5AY9yeUMto8XmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047237; c=relaxed/simple;
	bh=q4g1xOOHhtGzLCkVnS3AXZsyzW8Vz8hkRw3OrxPy1lU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jSm6569ft5XmZNbI+Dt0269T2Oic/xjHNEFvT5/So+a5XzpLmtqqfqD5lK7XKzLFAumchEuAFR8M1RGfieFzf5jmLcNTp1ozdQcirQGZb2B8HEYweH2jSebIj+Q6nPPwziTPBpqN6Qm1VQEmmktnrdRjUoeG0iAFmz6YCypmRfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qv/u9tRd; arc=fail smtp.client-ip=52.101.201.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qv/u9tRd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nNUChw+gGJDKIKU5wWILypm+MvW5EZWTl+UJI4PE2Oj8iSLUX556ez6bobp6vWh5/3cZkgChewFqjTy07ZpN0NkZm39eUsJU7HCjpHbE/9f4RPz1ePQJfY962z3p5ukvKQv0zGsX/QdPfbxaeKmc8MpsgW1JwwrPduppM6fdA+u4z28EwEZvQT2azYGV+bS9FZr+diql19/iQKklTHwSs9JeCnpEeZLZzltzrzO0t5vMFveFwRehn0KHp8ydRj99QT50RNQR2nBs+Q4hbZ4ag8LF1Im+uevk2vHKNWF6NnhjqGNU5jN7L0zYwsaPEzF8Q5H5LbsPR7TpPm/DoxvPQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CH4XyYIeUM0dRRvVaxsGAaleWfiWsyuaIRUlRZOFxIw=;
 b=G2B5YG/6EeOthyhXWLfdD7+kt0OM6hH5AYoFXt6g3g8VIeMIlVzXH9DS3H/TrTU/TYuCNEak8hCHbqg6Kl42WqC3kam75QpLyOtxVstjMM9BhZLdfZpF9LI77W7hF7YO+2BBealq9QDy+PPIMhSKkl8GU2Q58tZywrdE0Iwe0NHDnOL+iulNuYnDtV7tVYBmTldAqxIGvbLjJwdXXAFsX+R2KBvz0AJes6jxdtrgA5Os6bNDEAQuJxkPKIlo+YN4fFUYaDrvOGhIGiS4RFeyMe542H46nbzF30XltFEcXC7Osu8FEE8+uGyXwxj/ZjopnVHqORmoHaME2TS5qalNzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH4XyYIeUM0dRRvVaxsGAaleWfiWsyuaIRUlRZOFxIw=;
 b=qv/u9tRdrm1PRianwRyznsl4tPveobbnmsvgUxYoe5KbkqKVMgITENQj6PQedEhjc4soiwI1XdO50hwWJDy4mIs+685wDRn/7rciDixBgs3YzjSO4cjD9TWO8+LmdjNY1280QGOAE34P/ZQgD4/2dHWsEhOotQQVi60qW5I7Nj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB5766.namprd12.prod.outlook.com (2603:10b6:8:75::12) by
 DS0PR12MB8317.namprd12.prod.outlook.com (2603:10b6:8:f4::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.15; Fri, 29 May 2026 09:33:52 +0000
Received: from DS7PR12MB5766.namprd12.prod.outlook.com
 ([fe80::222:966a:d65d:d08e]) by DS7PR12MB5766.namprd12.prod.outlook.com
 ([fe80::222:966a:d65d:d08e%3]) with mapi id 15.21.0071.010; Fri, 29 May 2026
 09:33:52 +0000
Message-ID: <4cc8368d-3972-47c6-bd60-7fc8b9c7be3e@amd.com>
Date: Fri, 29 May 2026 15:03:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Improve the invalidation path in AMD
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>,
 "Srivastava, Dheeraj Kumar" <DheerajKumar.Srivastava@amd.com>
Cc: patches@lists.linux.dev
References: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1cf::6) To DS7PR12MB5766.namprd12.prod.outlook.com
 (2603:10b6:8:75::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB5766:EE_|DS0PR12MB8317:EE_
X-MS-Office365-Filtering-Correlation-Id: f3ba039e-d8ab-4c1e-3714-08debd6564fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099006|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	AlRCG3K+kdUILDw8Hu+gdRYmVHfXxuWnciH9KIjBnVpZes0RBVWbJ2ZTDY4vY4BkvYIoyCNgbn3DfAnlfkgRASJItNmnGtNQq/I7TKrQFg/tKnPOyczohaFL99UvnWhY2/CD+ToYjGHkGYncpQgkdqXETblrIlTuHUsPpkhDO9AqyrCO2aJh9HOXXWRkQLz8HN/jc3gruWfP1+ZakpNeXK4BCJ0PT4xnziyL8bYbf196KTpZpQJPSJhdLfuZ3zHDItyhZUGiE6EnCo46iS1ZFLHd+5sP0a5Z8oHLCxIJVLyCQayRA+rKJx+tOq39ok2+fw1hj+bmRAe96qQuKPsNa6bXmLgoThqo0nb/yyi4HWiNdM9BRgry8oqiWIzBjA6qYuozh6WXveERiHZRmBMgSRihLjYB+sjDgerzFY2Lmw0JTKFFynAuI5oH2/tDK3gDn3OUhJQLJgTSMdugXoDxctpO+j+Dz624UKU4PsOrkHMX05xpf6V+jIGK/5I1A4cP/oHI4vma/4ScshUkvJYCwBDexo+vEnwv+e/2DojgD8skGFAb4zcy4jPsQ4Xzc1VOZUf+VxqtGqAH797JO2d5dHhT6lrMaQtFLStXWrBGfyLYjq5hv99Uxl/reWofi20t1DBWxAl/EwRe0ETJwlexsEnsydPzI1989JmzqiDb0nlJJ9bjO9kg6zwiIE7Dr+hF/KvoODssCdUMenO9VzvFyg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5766.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099006)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1pZaCs2bkEvOU9ESzkzVGphQmt6aUNacTRWeU5aZGFvT0tHR2p2ZXpDK1d1?=
 =?utf-8?B?aytHOEpPNDN3Vzl4ZlYvelVqVjRjZ0cwSnNPZENkN1RxbElFU3d3YkUzVEth?=
 =?utf-8?B?OWM1WllsL01OWno3V3hpZEhncFpIMXRHdnZ2R3c5Z3lEamczU2pqZTRpK01C?=
 =?utf-8?B?a3RjM25NRWRiK09SVmNscWVzd3I3ZWYyU2Q4VFhzWUpJSXBtNjRub0s4SlRZ?=
 =?utf-8?B?eEI2Vk1LazVHU1dweGR2dGcvaFJzdEd3Z25aTmtjaDZGaHBLZHpmcExxcE1N?=
 =?utf-8?B?NTN2SkpIdTNHN3BlVDZlTVFsNVdLaUFOLzR6QXBTOHFkWVphQmJqMjY1emlO?=
 =?utf-8?B?amc0SUJtNnpsR01PYlBha1ZFdTJPbE5hUVNweFdPMkhXUmpqOUo3VitSekE5?=
 =?utf-8?B?TXVCMDdYVGZSZ05KYzdSSmdsRGJsSkMvdXFhbHVvVnpkRDJLQmxPRlp4QXRR?=
 =?utf-8?B?dW4vRExzbHlMMGJHUzNOL1MzSFBYV3R3YTdlbU8zR21jWjZ1NW5yUU9WVTV5?=
 =?utf-8?B?UFJ5c05mRGVjV1JoMXRsd0t5SEczaEFmYmJGRm93QXlqUDdIY0Joc1dqTzRq?=
 =?utf-8?B?QktYaHVuN0NOZEtLMXlId0RaOXUrbWJHV0ExZTYvdGZOejFESTdiM2oxUjJr?=
 =?utf-8?B?ZFdOYmluaTUxVno3VWFhQ3NKUVhJb1k3U0VwYjlrbU9ac1RBUHQwTTh2NU1P?=
 =?utf-8?B?MzlqWWJNbHlCY3JTdTFKRUtON1F5Y3puZytOeG9rbHRyL0x6aEFEOVR1c2NB?=
 =?utf-8?B?ZmlqS1JLc2RtTEQ0YkRlSkNMTGYxdU9jQzIwQmpZdFhDUDhnYjlSZXRKeFk4?=
 =?utf-8?B?RDJmOVRKWit1Q21LbXBDbDYwRmVRNTZvT2hPQ0EzMngyMVpQR1UwNFNUMmpP?=
 =?utf-8?B?eEtNdU9IQU8zRnpERzFmcE5EMUF0YTNFbnNKRndLRjdRem9rQmdtaFpHang3?=
 =?utf-8?B?M2hhWHlrUlkyN0lxVCt3WFNuQmRnWGY5WmQzMzR6a280TkplYk1nTnBWbER6?=
 =?utf-8?B?Y3VLSmlKM3ZrTkl5aktVS1BqSTIvSTU2MGR6b3Q1emVoSndRNm1zTkh5Wmhy?=
 =?utf-8?B?UlNmbXdvTmcwK2ZZejVQbEIxdGVzSDJUVWZaNzF2aG1LVTJkaWYrcTFtdkZn?=
 =?utf-8?B?L3JDdVYvY3FoUVdtd2RQcWlVZkVNWGtjdXpNeUw4dXRYSFFzMHg4TFZMdGN4?=
 =?utf-8?B?Y2Q2ODBBSWNkZ3o3c1JhdkkyZjRqNWRUQTR5dGhKU0lVYnFQYXJySjFidncz?=
 =?utf-8?B?K1NRTTdOcXdKRjIybHlWRGdnZkFKcG5pQlB5NU9wSDVFUGRYZVJybEh1NmxF?=
 =?utf-8?B?LzlFVVRyVDNvYWxuMmFncHZKcmV3QXEwb2xXWFlNNXFudmhoQm0vcmc5OW5r?=
 =?utf-8?B?cmxqT1piMW9rZGo1MXpkZXMwMDM4ckp5VkUvYTNabCtxS1RvTWJjSDhtT0Ra?=
 =?utf-8?B?ZmtPbnFkU0FyNEQzVkRzRHlIQUdtdnVENXh4YUFDM3BzWWZJM1hZeTFUcDY4?=
 =?utf-8?B?bGh2aXVRSFYwRHVsMTFRb1piK1d3TFJsdGpjQklDLzZZTmVqalI5d0lHTTRo?=
 =?utf-8?B?b2ZDOFBCZm9lWDU1UDV5NG9HcEw4R1pFRndPTGNyZmFmcmtYV2k1T2hDV3VB?=
 =?utf-8?B?RE9DU2NqQ3c0di9XRWR6VUxKYlQ2NVp1aWdTcDdjMWpmdWtGNFZidEd0YWlX?=
 =?utf-8?B?NWFwdEVYRllpWXJJdWNMQ2N3dUpmbDlEQ3RqR090dDc3Y0M5NmhDWkxvQlVK?=
 =?utf-8?B?M0R1cENubW5XT1MwUE9abE44enlRYnNvWkFQVjNiQTRLQUtQd3RHZTRMVzRy?=
 =?utf-8?B?aGx3MUZVeDVOZVdxVEJyUWM2bjVjcXkyb0ZkNDc3dnFtakZtWm4vekh1RlFC?=
 =?utf-8?B?QVl1K2JJVlQ5WS95dElyK0lwYTBmOE9CeXI4MWV3UjRVVnFoaDdRencva01M?=
 =?utf-8?B?c1djaXZQQnJRcy9VUjFMN0tTRE5PMnhqb0FVKzBKOHhYam10Z0tNOHNEaHRp?=
 =?utf-8?B?V2lINEp0ZFZheUNSYUdiUE9ON1dBMU1PSW1jNVZ2S000ajNmNFl2bk84bXN4?=
 =?utf-8?B?TFBGZTBZY29ncnkwTHZzSDR3akNHTUN2bTdZT1NTemFYTHlMMVVqeEpXMzJC?=
 =?utf-8?B?clBzT3FtWGc3TTBrYVNQbHdMN1dIN21UNndETU5jNHV0M29EWDMwQWZNYTJ4?=
 =?utf-8?B?Um56Vjd6NTErN05QTnZwZC9nVzlvMTdpVGwvbmlwY1dWdDlXTyswMERaVERl?=
 =?utf-8?B?ZVFzNFM0UzlIeTR1UGZVbWRIRnFjVEtUU2tEeHZmcmdyN0RhZFVCcURKRUV4?=
 =?utf-8?B?Ukwyd2NndERiVjBIYUFXdHpodUk5a1hVTitCNDBuQytGaWpwaUZEUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ba039e-d8ab-4c1e-3714-08debd6564fc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5766.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 09:33:52.1129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 179ClqVrgBw2qBhENLmJzCzvYeu4btcF5nMn+ueZLj3MNSkgDAS2/YhpNI/yg/iIYCcRCRkn8BcERSTc9IYoIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8317

On 3/27/2026 8:53 PM, Jason Gunthorpe wrote:
> Auditing this path reveals some unnecessary complexity and some
> confusion around end/size/last and types that may cause issues at the
> ULONG_MAX limit.
> 
> First, fix up the call chains so that the gather start/last is
> retained faithfully throughout. This avoids converting to a
> start/size, and avoids various type conversions along this path. Fix
> everything so the theoretical cases like start=0 last=U64_MAX work
> correctly.
> 
> Simplify all the calculations for alignment/etc to use trivial bit
> maths instead of the complicated versions. These are all intended to
> be no functional change.
> 
> Finally, add support for PDE=0, deriving it from the gather. PDE=0
> allows the HW to avoid scanning the page directory cache and
> supporting it should improve performance.

For this series,


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

@Joerg,
  We are running regression tests on this series. Give us couple of days. We
will let you know the test result.

-Vasant


