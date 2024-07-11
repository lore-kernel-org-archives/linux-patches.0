Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62CF15217E
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 23:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720741679; cv=fail; b=GAJsLKkhrr/ZBJiqxFhJVawUYndHR5m6yycwyqdVDNMUfzd3exjO6M8hgTSMo4DKIsdZGzk+wAzmu5MSQ2fJEH5Ganw88WVmUMjI/ctZXSk+FNgggrltqJEpdaziVMs/tQprC9T0CDowF+TNe795yst5ZZm5km0aqD0yC/6QbZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720741679; c=relaxed/simple;
	bh=XBK5MnKHEtdSByi978CdcsbimPLSRikR8K9V3JJexxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Z7ABQvQrKJqMyY7WCkWniWj/fXbQRtONzNIA6D83BgleZ0jl2AMfezOdkCoVWbDo/RTRyLMVw+mkSreWJCLXJLP9NvZ/CUzj+D7XY0T01lSqka4NoqDRlmZ/F3uzYYQ7axwcDi/PnhlPq2+Uh2f+sDdgLVuSyYPMWm7zaDHLMKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LTxytwAe; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LTxytwAe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ktgp0WVDwTZC0t4O5qoGwoK+WoQaEVgpJelZmHEZ6PTgGdbbnDNUg3mrPmWN2dlAm727mCQNzpCE+EhUZT+D3YPMzKt9fwZuKhI3G2erTPZ9abB+2s9e2rMu3mZChkzJlAisTUimTwtlGWm59D8DMresjEHt48yf0StE/+toyt/JTfte5ZZo4bF0g0w9hdM+mh3etC9agsr0soX5iWCQ8fHSHzV5rHyeffjdpjyFDNhl5zaBuEijcBRayje7TA7imoU8SEGQ4mssBzuFDof7HaGGTFTQlNbv0iGOlwbIOrXmCC3DBI9QBcnk4niKlZZttrusgml3kA9a+dbUjXxGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwIlSoDzzkkK96soS51e/CHf6a4uUheBftcmsjmr2A0=;
 b=NojjH0rGHMbPshQPiGe4vcV5G2kuACFRRilCBnjf8FzPc2MTWBw8tMx9tbRvkjTH7xSJr+JcgXXjZNPKAiuOClHImwMM3AR8TGUKRcYW5hKUmAcqeiM1j/2/8L0aiEDVZ9iZxBTH+Fp2bN87llDI95dEndSbchv5nNX8Wg+0I/sTcpooH0FE6hZEbgvInUrv0CRck/3p6D+97YkJ9rW2SbRs37m45JTNtlngJ9ZzwibZbrUVi/Z410GxSH/aqZAzy6Lttg78VjDeRzmnIGc6B6hWSIh7EYxdEYI+5S2fvbTC7NYe2tBZxkRf4pLDY4FHI4B4Q9vI6mB1pnGLInDo/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=cloudflare.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwIlSoDzzkkK96soS51e/CHf6a4uUheBftcmsjmr2A0=;
 b=LTxytwAelamjIhFVO1LHyjuntwXv+cq0TylOT31L2SI7G1EliHRGxSHiWG7dxSdcC+TOzRa/BIEaMoSGffd3R/1WVQDlMGWmlibt7BqIRXV1Hq+DfbnD4nBpwnrqUSwSnIGA8V6S8vF8xFg5DOV+I4k6PXpv3IJeNHsZw0//np4n2M93T5dK2pFu+YxA+9HhNgidquIc5HFu/X3aYBlaGpPvKPwS/yh7Lij3z7wEsXrKRV11Q3K1T2+YV3Qq85PqDFXyAudu05IyjQrT24QFVW3CzzNIQBcBh7r4AOpx54dKNM+1tW58IBZSnEqbLT+Uw0o7Sa3JR6ynrgzIla9Ebg==
Received: from MN2PR05CA0049.namprd05.prod.outlook.com (2603:10b6:208:236::18)
 by MW4PR12MB6922.namprd12.prod.outlook.com (2603:10b6:303:207::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.22; Thu, 11 Jul
 2024 23:47:54 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:236:cafe::f6) by MN2PR05CA0049.outlook.office365.com
 (2603:10b6:208:236::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Thu, 11 Jul 2024 23:47:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.17 via Frontend Transport; Thu, 11 Jul 2024 23:47:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 11 Jul
 2024 16:47:33 -0700
Received: from [10.110.48.28] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 11 Jul
 2024 16:47:32 -0700
Message-ID: <e56645ca-bce2-45ee-9b5a-d398a881da49@nvidia.com>
Date: Thu, 11 Jul 2024 16:47:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 046/139] selftests/net: fix uninitialized variables
To: Ignat Korchagin <ignat@cloudflare.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, Willem de Bruijn <willemb@google.com>, "Mat
 Martineau" <martineau@kernel.org>, Jakub Kicinski <kuba@kernel.org>, "Sasha
 Levin" <sashal@kernel.org>, <kernel-team@cloudflare.com>
References: <20240709110658.146853929@linuxfoundation.org>
 <20240709110659.948165869@linuxfoundation.org>
 <8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com>
 <dfe78e1b-eaf9-41e6-8513-59efc02633fd@nvidia.com>
 <CALrw=nHVvVNA5M7=jAspdcOnmDFz=zL6axC6vv6j=t1HbsaO9Q@mail.gmail.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <CALrw=nHVvVNA5M7=jAspdcOnmDFz=zL6axC6vv6j=t1HbsaO9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|MW4PR12MB6922:EE_
X-MS-Office365-Filtering-Correlation-Id: aea08232-dc12-4033-bf05-08dca203e23f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmRyYU1ZNnp1NmNCb2RlQk1wQ2krN0EvdEhoZ3BiMng1d01MdXFpTUpjcFpx?=
 =?utf-8?B?eUtuZTBlaXRaZ21MSHZpaThVTzQ0QlQ3ZHR6a2JLcjRmeVYvOU9TWGRxYU5h?=
 =?utf-8?B?ZnNtZ1B3SnhqVERzL0J6MkpaUGFYdENmWjY4eHlzRXQ2dUo1RGw4TGkzSG5O?=
 =?utf-8?B?Mys1bWRwelhqb3RGazEwbFJiNjNWbW9WSmxTQUVMeHZwTHRmODZ6ekVLTThr?=
 =?utf-8?B?UDFObUc2Y05qdlhEd2xKZDN4Y0FZcHpKOHFqR1dtejhRbldUQm5GTkxBeDU3?=
 =?utf-8?B?NHFidjRNaUwrUjVvMi84NEFBVGNqd1JpQURYMWV6cS9Ya25BUEFKbVRDVEdJ?=
 =?utf-8?B?Zlc1Smpudm5qdjN0bm1FRGVSTkZaRk9XVVBBaXFUK243cG51eGFaNng5alVI?=
 =?utf-8?B?aVNpdEp5cXNMeGFQd01jbkZWeDQ3c2NzY29qRlpVTnU0SDJWYmpxR3NvSVN6?=
 =?utf-8?B?V1M5Zzdmc2hiMFVpMVR5UHhlaHo2UVlOWWdLandGaUMwMFFlTTE5SU1XMkgv?=
 =?utf-8?B?dlBOeHFLQ3VZTExVc1hqSkpia3BzV2hlSlZZTGZtb2pSYTNjOGN3R1VpWS9K?=
 =?utf-8?B?eHMvcTgyc1hYenBTSXA3dmJnS0tKMG9FT1ZieHNFbVJvcTJSK1djOVdVWkkx?=
 =?utf-8?B?QW5BcjB6S1N1TVNpZFhQSHJYemxsT25tQU9LUmJBanQ0clR1VHNHaGRhSTUz?=
 =?utf-8?B?WFUyODY2MTJqL0pTamwxeEgvN0hoYXc1bEttdjA3VHdRUWdVZVFCOWxsODRB?=
 =?utf-8?B?WGxIejF5SDlpckE5NHpjcWNxOGMxV2ZicFhJbUN6a1JFU1ExWlRlc0l1UEh6?=
 =?utf-8?B?a2NRTCtaTHB0dnZpLzJPMHBma2FqSEpCTllQYnJxcWxKblRkUnk2WmhOcUZ0?=
 =?utf-8?B?TmJZSExGY3V4WG1pUWMwQnZCYkZGaGZwYTRhUjdGdVk3cC96dGUrQk5xb2Vl?=
 =?utf-8?B?SENQc0ljelo1VXdmVUh4K1h4TXZ0MS9GSXIxSXFZMWpEdDNBR040QjFibXRo?=
 =?utf-8?B?V29WQytSd1ZNZkFNOHBuQVVkVWZmTWN1QUNsQ1g1V0pSWXNneU4yWGNvOU5l?=
 =?utf-8?B?eWtNUlBUTWNaQ0trc0lKeTN0WWFvYnJ6ZDljWTVYcjduZjdsWCtTak5aTkVk?=
 =?utf-8?B?SUYvYjQvczdCWm5NWmV2MEpkaG0rK0lDdmNRTXRQL3JDQWRZU2p2OXJxbUJn?=
 =?utf-8?B?ME9oMnRZVUFCYnlzT2s3WERtTGM2MDFGV1dWUkZqcm9USVRrTi9MWU5QcWpI?=
 =?utf-8?B?RmZPVmgxbWlpd0g5TStOMjNERHFta3loTFQ4VEdheGxYQ3gvV3BscytXV1F6?=
 =?utf-8?B?cHErOXVsYlhzTjdXaFp3aldrUkFBUTVYUVNxcHlNeEd6OEszcSt5dDZHS2dR?=
 =?utf-8?B?K3J1TklSdnFhZldxQjFMTTdtWWJmc0JQSHVSTWhTcjFrL0o5Qm5TT3Z4MmJR?=
 =?utf-8?B?dENhejdCRDNQSzRHUWhWVU5yaFFidVVZK2lBYjI3WWFSU2NlVkhnR25hS3hZ?=
 =?utf-8?B?cWZlRVkxTzRDb2lydXFaTmVnTDhPTXJnVzZVbzBtRU5LU2srUmNiNnc3NGJK?=
 =?utf-8?B?NWRYeXFGLzhxMkg2UE9HczhZVHdnSUFJN29GOXpVWGlhcHQ1NXdINzNqU2Qz?=
 =?utf-8?B?UlcxYmhBc05TRUQ5cXpzMkhkdm9SbjZoaDNWM2JoRU54aUEyNG9JVXNZS2pw?=
 =?utf-8?B?eVNYbG1IaDFBcXYwOFJHcVNWWXFGV0pXN1FvOEV3YUZ2a0M2Y25KR2dQdEFK?=
 =?utf-8?B?UFB6dnExeS9XUzVCbTRuaGFUNWg5TGJQTTFCYVlwVG1ybkZLcVRkVElNbHM0?=
 =?utf-8?B?K0p5WjV1eWFuSk1IeWZHMnpTb0c1YlhheFFBb2IyejgxM096aTdFanZZaURH?=
 =?utf-8?B?WEpkRzZqaFRTZlJ6M0pKaEtWMHA0SkhGaXM3OTVWc0k0SHJyVUdyZkw0WktG?=
 =?utf-8?Q?z2lcl+blLYW6gu0698X4/QJ5iaM9YC2P?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 23:47:54.2322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aea08232-dc12-4033-bf05-08dca203e23f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6922

On 7/11/24 2:18 PM, Ignat Korchagin wrote:
> On Thu, Jul 11, 2024 at 8:16 PM John Hubbard <jhubbard@nvidia.com> wrote:
>> On 7/11/24 8:31 AM, Ignat Korchagin wrote:
>>>> On 9 Jul 2024, at 12:09, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>>
...
>>> This breaks selftest compilation on 6.6, because opt_ipproto_off is not
>>> defined in the first place in 6.6
>>
>> Let's just drop this patch for 6.6, then. Thanks for noticing and analyzing,
>> Ignat!
> 
> We noticed on 6.6 because we run some selftests for this stable branch, but
> by the looks of it the patch needs
> 4e321d590cec ("selftests/net: fix GRO coalesce test and add ext header
> coalesce tests")
> so it will be broken for every stable release below 6.8
> 
> Ignat
> 

Oh right, I see that these are already applied to -stable, so we'll need fixes
for each. I'll put that together, then.


thanks,
-- 
John Hubbard
NVIDIA

