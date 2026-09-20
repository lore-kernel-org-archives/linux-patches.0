Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B663A3C76BB
	for <patches@lists.linux.dev>; Sun, 20 Sep 2026 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789920858; cv=fail; b=PIHTdLk+N5xFVTAd+CLTI7TRl7v543OxwcqPxug1DbpuLj+WdZvvHfX2nVShsEDLR/n3ToObcD9llSUlv5tQFJgIgGAptlrxHqZYKYgrI+ORWoPAJsHYkH8gTht8DPmUCbaBvJvWAzqruQzNblQWEXEe7fWsLz7mgMkCukEukpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789920858; c=relaxed/simple;
	bh=qyC5L8EcMRVKSbvmyQwCzX8QNE6ChV3s4gB4o4sWIWg=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=Nfm0ibhwCV/wJPO2UlUTziobvmeHCrcxgWm38gwEX16vL3jqsSg8O65Rq27chwSf6W5iT4BlEwPw/oC6fWY9HP1bTmz7AafK+V2td3CnbvZLjNUFcVgGNDVt/J0VjmtHDUw/zeFp6IFb7skIL1zhZbsSN9BQXNDa2EPneWKZDGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UzsG2K15; arc=fail smtp.client-ip=40.93.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UzsG2K15"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wdlw0vhMbiFyKNQHfnuZDZxf7RgBo7ALH1vBVNBnLun1JGMvrFBFej9BBQRpykwsUJPYHsrjfHrkzZhncngl3aro1f7UVMNdkJEft1ZvrOCS5Z64fIJ53eCePjmlVCtVplxjdEY8NrDFgWtzozH0NtaCat7GS6oZbqTfSPYxAG++IKpqr0YpQAp+A2K0/Aumsj7aSpMW6owIocU6HtSTdQgXbxWv0p5mTAR0QzPyQoVGztFk5HS9NfTV3iMsJa96bYCl90Qe52QD0sTD1r7tdcMn0fQyXfRmcWc7pRfpSKQPug3jTLJmhsO6F9kRLnIifLGQKdeKnpTAiLvr1lbnkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySYQLRN54lmLc0y2WZgg19qCleV3OJIHxxthbP+rkEA=;
 b=jVDy5s7WyWGl+D3VAQAI45BcSbTj0ouZ5AuQqvggGCdg395PnF22WUBfTlwGidselNcnRLhOfHqxWzIDzHoWmMMJZsZd+Q6Ceg5qdgONMxkIoKtqoiD4U7aL4sF8Aohgz9v+R31N0jpNbm3PWxYDaCVoRpV85jpPjjXpVZOUjQcIAafGFUKw/px7RBIWoQqIoWjULtNsYnCDUOXMHbJoOzs6jeHnSD+CFnTcuG/nRrPkNNYh/PmiTuS+tZd1hvSUGgKIl6knGopM8s60YxjAzDNEEW6ZX8rz3rjSvjMsOS20hc6BUrkmxfigODOYP4nUhR0dm2IgD8aGl0iqFL/vtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySYQLRN54lmLc0y2WZgg19qCleV3OJIHxxthbP+rkEA=;
 b=UzsG2K15/SVLGhsepR8gb4QnLfxvEoijefTC3FS6vHKXCFAi+9cXzEHcc88H62DvdTGPXNVKlydgD+DWpArGct6bJhegeL2gL9dKtw7u4SuMvdEsgaoEVSV/OmnrCWrkjyAD19jorPLZVG07JxJbMWfKLcL04vt+nUEslXomFV3kQds7iKWjPNXK7QRVuw4P1F1H4uyhCyfcKp7saxRQQ/JjWx9YeEiVcUh2KAzjF6OfCtW87g9/diVolNJpb5KfqUujshy2b4heQMdYeNg9th1jXGbl1yrMoqLjj1G1T8eMP1F7ZskgFEcTApD5ULCvmUHDTUijjEA6dgXNqwqQlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6161.namprd12.prod.outlook.com (2603:10b6:208:3eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Sun, 20 Sep
 2026 16:14:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Sun, 20 Sep 2026
 16:14:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Sep 2026 12:14:10 -0400
Message-Id: <DLK9ZIXNO1HT.3B6K7O0U849Y0@nvidia.com>
Cc: <patches@lists.linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, "Barry Song" <baohua@kernel.org>, "David Hildenbrand"
 <david@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang"
 <lance.yang@linux.dev>, "Vegard Nossum" <vegard.nossum@oracle.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
To: "Harshit Mogalapalli" <harshit.m.mogalapalli@oracle.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
 "Sasha Levin" <sashal@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 6.12 0472/1102] mm/huge_memory: use folios memcg inside
 __folio_split()
X-Mailer: aerc 0.22.0
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151551.542102472@linuxfoundation.org>
 <70fbd5c6-2903-47e5-9627-4e028be7a858@oracle.com>
In-Reply-To: <70fbd5c6-2903-47e5-9627-4e028be7a858@oracle.com>
X-ClientProxiedBy: BN1PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:408:e1::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: 56359846-6f08-4d93-da31-08df173234ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|10067099003|6133799003|5023799004|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	BFX4h3DbSEBA7t9rskReFnTvPp1gQc21qgNid5rEVbXR2IKHqnCSkEjXBB2oV/cJ4tfse0UtpBKuPbZD7E3f5GgvIwoZjnIYeTC57lnJZVh+1mNdIl5jqMPibyl459f9hV5eBRRI2WWYoL1nxnxiVFHX1X4we6sa688nH0gJJCiMQ6L+MCJDEgXKV+DcXHc2GAn7cbsof9M9QknFGgrEGIQv+gibMs9nQgI280gPBWypqoSVNGuY1jCKI4B+9S6v0oJVmkpI6YWfwaYy3H4obz/aY1zFws02613ZE4gDdeThDz1dslLkYWE+8LJWxx6ciMF1GYEE8oHMjyQNRBnYdic2F9CsST4Izgqji8p/NlLLzLR4foBy8wyWK3zia6CPesbLKMnXZ2945ZEjk8Nn05EuAw0XQrUCrZErG/ERrb0XWQUXkM5oUOti2uPovJ/JpNZf0LOJWV0PSzEeimEFsfx/e4jmxcrZOpkj/hxBkeYTW9wGPJlNT5QKm/qqKE2T148oq7uyVooUgOLi5OvPU7GHrEwFkdy9+XRLSSh7l27LLSTt+k+bgJ6fxDweBTSiTgZwK+6WgVPUnq70b6eW0S+L8j+5VfL6EGjgZo+Cw+dB6jvjyyrtkYMuhD2HKog2u3pVuLRE8N19YpEcQQEivG2CGO8wyXifADJTULLtcl4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(10067099003)(6133799003)(5023799004)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OG1ydDg3K01UYlF2bUFGeHVUSDVpa1JCRFdUR01Xb00rUE9KanFpd1B0SWpI?=
 =?utf-8?B?aHhjcVdBeXlycGNDd2dYQUNMeUM5M0x1ZFp5bjVsY2hHclBpRVNqZXFvQnFO?=
 =?utf-8?B?QVFiSm5SNzNkbWUxSjVaS2Y0TWVLdC8vcEUydnNlakdPd2lQOEhPZFdIWjZn?=
 =?utf-8?B?S3hzWGpvWUZ5OTJjOTM4WEtMMEtTcnJVYTRWaWI0a1lQbzV2UGpna3pNUTJ6?=
 =?utf-8?B?TjdCYWU4N0NpRFVnSng5M09XNlRoWTBWcHVSMDEwWkRLblp5MzVJU3o0QmN6?=
 =?utf-8?B?K0JrbFBVRXNVQkF6dHgyYmI5SWpUV3JrZmtvOTRQdHNzU1pLN2JYbzY0S3NC?=
 =?utf-8?B?RURPSEJzQTRHWkpWS0QxRlgrRXVzRm56em9LUXE5SDNud0UwSzZXU3RIN1Ry?=
 =?utf-8?B?RjYvNUZmZERCU2t3YStuTDRWVEFkdGFTQ1MwbEppYi9DOTBaWE9vdDRZeGFV?=
 =?utf-8?B?QzlOa3c2VXJCanZzZC95aEU1SzBBcnFkaVl3bm1tRHZabUw3WW52SmpQNy9F?=
 =?utf-8?B?OGx3bmF5clNkcFM5dnZnN1dFVWhyNDIyeFFEVXJNMFh6T0luemtJL2g3ZTZD?=
 =?utf-8?B?RGxMMDczcnIxd1lIbmRLQytOOU5hSFlrM1NnMEh3LzRUQnFyY2x6Y1M5Y2w1?=
 =?utf-8?B?eTZydk9WZkNWZG1sTE9JbFdJdWdITTZ4T05wNlNkejN5NWFXVCtoTDBPTFhY?=
 =?utf-8?B?RDBSYnJUdzFFWVBNN0NUZjlVdmFGUHRTTHRMdTBUS1doTWE3SHBEbmVjSTJi?=
 =?utf-8?B?VGowbnh0b3lWQjdVU0VmSXV6MXNwNE5tSm8vMktIM084a0dvYlZ2NzEvSTVM?=
 =?utf-8?B?dGJjbVlUVHZMNHo2d2xsT1VSQyszVGdKb2lPOXFLQ1ZiQkdoYmgvekVrYXpY?=
 =?utf-8?B?SjdNaFBxSWxoUGs5QmFUSmtncGltYTNuSFhQT2k2YTZkQmpXeTNablN6VURR?=
 =?utf-8?B?Ly9wRlBMdXhtMjBGZXpoZmp2TjNpS2lkcGFZSTFQczhobTVITkJWMy9RSVlo?=
 =?utf-8?B?S1cvU0k4SVRGekQ0ak5KTEorNEtXWE9oaGEvR1d1bWhib2NoNTdreS8xaVJK?=
 =?utf-8?B?dWdoeXJaUFlicUVJVEg4bVZpODdMNHFFOWp0Z0dCQlc1Z25OUm9Bc0d3d1k4?=
 =?utf-8?B?bHRNbUlYam5wWm9jeUFSWXlydWh3VUtYeG1QbVJjTXZXVVkrVnlqZDIzb1lK?=
 =?utf-8?B?Y3NhKzcxSHVSVmdqUk8vNEVSZG9LWGxHYktpWlZBWUwzaE5XZTRmSi9KQVFB?=
 =?utf-8?B?Sml2N3BEYjE5NUJBZGNRSExhbTZhWFNMR2dEYnFiZVZVRkkzd1pzZllIWE1j?=
 =?utf-8?B?RDFnVGhZOHVVWGtvUWZLQ1hVZmE3dFZvUWZ6c2YwcmZJZW9STjI0Wk8wbkNW?=
 =?utf-8?B?M1RscmxNY1Z6VW8wc1hCWGIrM3BJdnBKL0ZtR0ZCSHA4U3hpQTZKSEtwV0pO?=
 =?utf-8?B?dWw3Mkt0MzlsQjFKRXgyTTcvay9PREl6N3B0NS9Md29KR2Z1ZnAza0R6M0lE?=
 =?utf-8?B?WERWRmtKcEhtNEFaSllwbkcxOVFuQXB3SENSS3lBY21zMk1GaWpBWm1LL3pz?=
 =?utf-8?B?RWJmQTR2cjJ5UVphb0F0ZUhsa21aQkZ4Q1I4THh5TlIrTHR6YXFXYmJmQ2Z6?=
 =?utf-8?B?eTVYa3VsZ0tSN2FUNkxyMjBZd3ZBeG1hOTVzdVg2OTd5bnFRZEdHMk11OWpI?=
 =?utf-8?B?cE0zRXlheVZkR1hOUXBGUUxPN21tRlZYdEVxQ3N1TDF6MGJLZ2tYd2EzYThW?=
 =?utf-8?B?RDhyR1pKeVhkZWt5Y0hUQ1NuQkJpWnA2MWZxS2lUbHY5QXZ6N3gzd2Q4M3hV?=
 =?utf-8?B?d3BWTXBtUDlFVDhMTnlUZ096cjkvdWJRMk1WZzlSZVp4aEtQeUVFME9sSzl6?=
 =?utf-8?B?K2Yyc3dSdmFDZ3JtYmRqWS9DcExOQVd5Q2pQM2hGTUhKV0poMkJ5THk0NHps?=
 =?utf-8?B?NnNTWVdOem1qNmFmOGpVeXVaeFFGTHA4TVZ2QWVEczQ0M2JMdDBZZjRVd28w?=
 =?utf-8?B?dDZNZTcyRzVHWTlkemd4OGlrWjIvZFQwZnhPdnNwQWczNmxIMVNIR0ZlQTJz?=
 =?utf-8?B?L2JoSy9zaVNSQ1hvc3NublhTQ3lHaE5MTVhVc3I4M3drZ1A2MHRPd2M3Nmdl?=
 =?utf-8?B?dWxkY0Jld2pzajRZZGoxSVBGQlVlWklzR0JsNklQVWJtbkxSWXJXME5LQ1Br?=
 =?utf-8?B?YzVDYlNmaWRMYzlGaTRCMGg5b1Mvc0s2MkQwZHl2elUzTCtEUmdSOWJ4bXdR?=
 =?utf-8?B?dG14WFNKZGtmU2tOY3Q5SEd6d0FjbC9SRjNkYmcxa1RVd1Rpb2M5bktBVDBq?=
 =?utf-8?Q?10xQOcmLleC7QEWU1y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56359846-6f08-4d93-da31-08df173234ed
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 16:14:11.5126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUiMiA7xMF+Ho+ug6ZkDRJ6pJ64DvC1TK8yAxAdS7WSiZwnJn7Qoj+gKtJXFIKHj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6161

On Sat Sep 19, 2026 at 10:53 AM EDT, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
>
> On 17/09/26 8:36 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me k=
now.
>>=20
>> ------------------
>>=20
>> From: Zi Yan <ziy@nvidia.com>
>>=20
>> commit c299a2285d9d8bda4da024455de65e3d00de6f17 upstream.
>>=20
>> Patch series "Honor XA_FLAGS_ACCOUNT in xas_split_alloc() and charge to
>> folio's memcg", v3.
>>=20
>> __GFP_ACCOUNT is needed for xarray node allocation accounting when
>> XA_FLAGS_ACCOUNT is set. Commit 7b785645e8f13 ("mm: fix page cache
>> convergence regression") fixed a workingset regression with it.
>> xas_split_alloc() does not have it and needs to be fixed.
>>=20
>> In addition, based on Sashiko's review[1] and Johannes' confirmation[2],=
 to
>> charge the right memcg, folio's memcg needs to be active during folio
>> split. Add that before adding __GFP_ACCOUNT.
>>=20
>> There is no workingset convergence regression related to missing
>> __GFP_ACCOUNT in xas_split_alloc() and the impact to userspace should be
>> minor.
>>=20
>> This patch (of 2):
>>=20
>> During a pagecache folio split, an xarray node allocation can happen and
>> needs to charge at folio's memcg instead of folio split invoker's memcg,
>> because for example folio split can happen during reclaim and reclaim's
>> active memcg might not be folio's memcg.  Switch to folio's memcg at the
>> beginning and switch back afterwards.
>>=20
>> Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_allo=
c-v3-0-38cb3ff325c5@nvidia.com
>> Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_allo=
c-v3-1-38cb3ff325c5@nvidia.com
>> Link: https://sashiko.dev/#/patchset/20260727-add-gfp_account-to-xas_spl=
it_alloc-v1-1-9fae6bf64838%40nvidia.com?part=3D1 [1]
>> Link: https://lore.kernel.org/all/amtcBZ-_QVRgCd6b@cmpxchg.org/ [2]
>> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Liam R. Howlett <liam@infradead.org>
>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: William Kucharski <william.kucharski@oracle.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   mm/huge_memory.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>=20
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 6fc4e1fb88ae6..1a76a21724d40 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3420,6 +3420,7 @@ int split_huge_page_to_list_to_order(struct page *=
page, struct list_head *list,
>>   	/* reset xarray order to new order after split */
>>   	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order=
);
>>   	bool is_anon =3D folio_test_anon(folio);
>> +	struct mem_cgroup *memcg, *old_memcg;
>>   	struct address_space *mapping =3D NULL;
>>   	struct anon_vma *anon_vma =3D NULL;
>>   	int order =3D folio_order(folio);
>> @@ -3483,6 +3484,13 @@ int split_huge_page_to_list_to_order(struct page =
*page, struct list_head *list,
>>   	if (folio_test_writeback(folio))
>>   		return -EBUSY;
>>  =20
>> +	/*
>> +	 * switch to folio's memcg as xarray node allocation can happen and
>> +	 * needs to charge to it.
>> +	 */
>> +	memcg =3D folio_memcg(folio);
>> +	old_memcg =3D set_active_memcg(memcg);
>> +
>
>
>
>
> I ran an AI-assisted review of de480d1cd9ed and I think AI report is vali=
d:
>
> Upstream has:
>
> memcg =3D get_mem_cgroup_from_folio(folio);
> old_memcg =3D set_active_memcg(memcg);
> ...
> set_active_memcg(old_memcg);
> mem_cgroup_put(memcg);
>
> 6.12.y has:
>
> memcg =3D folio_memcg(folio);
> old_memcg =3D set_active_memcg(memcg);
> ...
> set_active_memcg(old_memcg);
>
> The backport instead passes the raw result of folio_memcg() and never
> drops a reference.  That raw pointer provides neither the css reference
> required by set_active_memcg() nor the helper's root-memcg fallback.
> Both get_mem_cgroup_from_folio() and mem_cgroup_put() are already
> available on this branch.
>
> The backport uses raw folio_memcg() without acquiring the css reference=20
> required by set_active_memcg(), and therefore lacks the matching=20
> mem_cgroup_put(). It also omits root-memcg fallback. Both helpers=20
> already exist on 6.12.y.
>
> Maybe we should replace the folio_memcg() use with the upstream=20
> referenced get/put pair ? Maybe lets drop this and get it backported=20
> correctly next cycle ?

No. 6.12.y backport is correct. The same reason for 6.6.y backport[1]
applies here:

|> Before commit f1cf8d2f36dc3 ("mm: memcontrol:
|> eliminate the problem of dying memory cgroup for LRU folios"), like
|> v6.6, a charged folio take a ref on its memcg. During split, the folio
|> is locked, so will not be uncharged. As a result, its memcg will not go
|> away.

Commit f1cf8d2f36dc3 is introduced in 7.1.


[1] https://lore.kernel.org/all/aqMDyxhGXZyhcm5H@cmpxchg.org/

>
> thanks,
> Harshit>   	if (is_anon) {
>>   		/*
>>   		 * The caller does not necessarily hold an mmap_lock that would
>> @@ -3629,6 +3637,8 @@ int split_huge_page_to_list_to_order(struct page *=
page, struct list_head *list,
>>   	if (mapping)
>>   		i_mmap_unlock_read(mapping);
>>   out:
>> +	/* restore to caller's old_memcg */
>> +	set_active_memcg(old_memcg);
>>   	xas_destroy(&xas);
>>   	if (order =3D=3D HPAGE_PMD_ORDER)
>>   		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);




--=20
Best Regards,
Yan, Zi

