Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786E2252287
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 11:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766143; cv=fail; b=i0J/eyKL1sA8hM6pjGKS9mu+69p2+I/jCKDvbAS8kzymF9xYgtL/chpQYjX9qM29pWJ0airxiP3VuOqhnpDv963I8L3TCYLH0qh6otIBc6FhF4kzjsRB2m8fUnSIUIMvgN1EebBaCcMONihnkFFNHPlpQwUQrTlkoKTePR2tK9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766143; c=relaxed/simple;
	bh=B61rLqZikvazOWAx9iDk6/TjBf0fD5NYByz17zrC1ao=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a4RqBbjGGBwacrphTOu0iQ5iXSBPh5+awIaLHmX377TCNsJS5NwuYt/mIfRnWdyNvVn+gGRHUpqEB5sZFIFvmmBV1vL/T97nxDu9yjM7sj2aZ2z8VJhoagozDcA/nyEP78A6eDCpSBHQ5YrEAWXHMfR62V3ZacJVr4r8KttZzik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NXDBY1kK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0Gvkg5y7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NXDBY1kK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0Gvkg5y7"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O8iclX028875;
	Tue, 24 Jun 2025 11:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GP8X69B5TJIP+elWDx8+rGTlwbP3NMoaqIplm1NAleo=; b=
	NXDBY1kKHQx3AsFimyhGpFd+hz45kiR9Se2w3S8/a31veco6/2pYQbNWTI7XYqQJ
	D5KxFXdWyX0BPTXI6WFRw8o7qoTG9xT1ZeaOUeastHPIRPuOD4mE1YdQmF6R9T39
	3zImsgMCV3+n3Zo0LqOBaFWJHGpqPapPJXEtk68VPQrkWsYzwY0t7YQLD78nZn+D
	EpLZrdyNMJYIdIlCLZIOhtus8mYjUbgNJt91rgbZ1n5AHS1nOXBYRZziRIZAwbje
	BBncM0+COz8SHT8VeEDGfP95jAGf9D2XkHzQm3S/CqQhHhcbjR/OSpmZtnXVWn0V
	1nVlpf4GB+3RCaqac8F9pQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds7uvy1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 11:55:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55OA0eiK005809;
	Tue, 24 Jun 2025 11:55:25 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2065.outbound.protection.outlook.com [40.107.96.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq3j3br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 11:55:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpvW6zEH20Xp6cZYnvj2pn8d2iWzq0aVDtxKga+4Nmht6j52bICiXYhonAiTgTCV/5txzny2NjArMgTKFuVZLKDQhX2gg0/HEvCjarc25xKt68IpWlOsEbtpVORgSNHM+2+L5cZ7NE6WUXUU9GntjUqOUhm8gbugDWjtFF2lvN0h2s1FrsoUb8TtZIEywD7EmPfRa+eE8ZBeS4X5L1bvJ+fW/SrKAbu5rfl7NVwCbBtsRsamysAMruK6ZBlWJr7mfxAsiiBVRTC9YUSTzSbadvfSzmMgZs/fgM3grDg1/lHMC2git3NLN0J35m4p6iVlIxYf9rZmIE6QFKNcRldmfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GP8X69B5TJIP+elWDx8+rGTlwbP3NMoaqIplm1NAleo=;
 b=MoOTIzLKOFF4CcP+XtspXb6f0prSrBPNksQioSD9Gf0hciwufBeKqtN1RQyIhKZv0TDLLk7F76iWsQS02zNn4HKgzewtKTMW4A1of4tPUTVQey3+oaa3wlbhslEug2a60bMEEYeBm7V5NtoBqVpO35LFJ7Nv/MZ3pLTLS08TuKIXqgBhkOwoq4j2SJh54I1cNlrQlOwn15sn42LiHur+F03qGemJDDPCvmQifTQ6R4HOjMeWH+ps2ldHYy3qK4T9NHrdqfb/5wGRbZ2KvkVYJ06E/NWPOssX1wH21Oapwi6wfSbDH85u/qyihEylZNsVSpRqK32cQbHIPu6acPVbZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GP8X69B5TJIP+elWDx8+rGTlwbP3NMoaqIplm1NAleo=;
 b=0Gvkg5y7ab+9K20uBFWAmek9q/stt0sTH275kkbF0H9uJJKsvodNAjP73A9DsAZso1NeqlTbyv9DlQnG3GqgIFsFcL9HqmWLGp3fCDTBLitoSP9H5LfsBike/zWvHgKuqnAD2EV90szqTpxw0datxD9Wl9yyKx7Zi/lckA8Gc/s=
Received: from BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17)
 by PH7PR10MB7784.namprd10.prod.outlook.com (2603:10b6:510:30a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Tue, 24 Jun
 2025 11:55:20 +0000
Received: from BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c]) by BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c%4]) with mapi id 15.20.8857.026; Tue, 24 Jun 2025
 11:55:20 +0000
Message-ID: <99c4f6ad-8861-4e4a-9db2-06ddcff2b7e6@oracle.com>
Date: Tue, 24 Jun 2025 17:25:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        hargar@microsoft.com, broonie@kernel.org,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250623130626.910356556@linuxfoundation.org>
 <807b87ea-a46c-4513-9787-56b2dfb4ae32@oracle.com>
 <2025062407-species-whole-8103@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2025062407-species-whole-8103@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To BY5PR10MB3828.namprd10.prod.outlook.com
 (2603:10b6:a03:1f8::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3828:EE_|PH7PR10MB7784:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb11c2d-0807-4e2f-b592-08ddb315fe95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUkwZUpGU3dYeDhNdTQwdWFPRWl0akVnWkJjaGxCV0ROK1ZURFE5eGtOZzhD?=
 =?utf-8?B?MXZZRjRDSkR0NGtBTXVMbzJ1M1VyaXRKTkV4dGdHS1hzVHpKcG85Q0Y0R0Q5?=
 =?utf-8?B?V2RsTmhiOHFKaTVReEhqSkxOaUJhOWNkb3V6dzl0VEF6bVBZM01tVkMwWVp4?=
 =?utf-8?B?d3VvVUNGZStaV0QrcC91R01SS1VQRURGb2hQb2pCZ0JWL2tUeE1xQklRb01q?=
 =?utf-8?B?bEhYT1hRUktIaGoxWTArVXRlRW1oQnNKUlZqN052aFhBU2wwVDZraGFxTHBp?=
 =?utf-8?B?VGd6RUdXMytmQStLd2VkYjE0OFRuSUxnYi9jSitmbi9obmgxZ1VLS1kwWlNU?=
 =?utf-8?B?WnNUNmxrZjNaMFM0UmdNRUxsMXd6c29FdGlwZ3dxYzF2V0tXcVFXZkVOb2RP?=
 =?utf-8?B?VDNMZEFXd2tLMjV5M1BjbUwxQU9wNWphN3lhZVNCTlY3V3hEVjhTRnEzeDBW?=
 =?utf-8?B?RTZBczNaNHY5UG9wYlZKVkp1RDFzSFlCenkrakhkbFEzdFdVZjNHQzJEODY4?=
 =?utf-8?B?UHlVd3VYY2Y2RlpUU1BOUnRyVmV2L0QwTzlIV2JzMjZ6TkZrV0M4QnMxMTcz?=
 =?utf-8?B?WW5jUjhPZFd6QWUya21iUGk1Tjg5SThmNGJFbHUrWHNHSE5kV05sUVBvLzVL?=
 =?utf-8?B?eWQ1UlpmVFErNUFGb3dxTjhaK3lCMEthNVk0cW80NlRqV0hHQ1dkTEVBdmJ4?=
 =?utf-8?B?YVBTWEdaU1BJTDN3c1ZLOWpCQWsyK2dNb2JZc2R6dE14Mk1zaG1Dc0VTWHhz?=
 =?utf-8?B?eDFLZVE3L2NjNWZNdzZrRkVPemx6REVlbjR5WUQ4K1R0ZjlyY3JWcmZlV0dQ?=
 =?utf-8?B?UFdKUS9RRTI3am1BL0NMWWtPY0E1SlBUYWsydjRRRVdBcFA5a2FCQzZnNS81?=
 =?utf-8?B?WXdUWGFtTXN3aU5OM0Q0Vkc4SVdtazlGaUFNZCtyZ0VwMUFJU1B2S0VZbE5S?=
 =?utf-8?B?QkNBclI0UXRoTzBRbnRxVnY0cGFwWFZCYnRDL2RUTUgvWGpOZVJVSGlkUjZJ?=
 =?utf-8?B?d3hyMnIrZis1bmh2KzJJZGQ3bkJDZVlQTTFDNkI4VlhqejQ4S0JSWS9CR2NY?=
 =?utf-8?B?QmlYRHJMbEk0TnJTbEo5akVaYjNxQ0Vod1kreHJQb0pESEdLMnZneDVEQ29Z?=
 =?utf-8?B?cHNldHhPM1F1Q2svRjA4a0xudnRNdVV1c3hiN3JmZG5TQjFDNWJMYWhUazVI?=
 =?utf-8?B?SGRaVGJ5a0NOOWRKcHVWelhSMjZPTllQV01TRzZFRTVEOXc1LytlQ2RJSzF4?=
 =?utf-8?B?M0ZiNHZWaG4yc1JMUVp6RkxWbWphaUZGMWdmM2V2Y1d3Z1dWbFR5TTR3WVBP?=
 =?utf-8?B?WTcvU0RxVWprTTZYMUxXa1JZb1BiZ1VyY2ptbnBHWlpQZ21wN0lZVGJXclcv?=
 =?utf-8?B?WG1UVU1NUDJoYWxFNll1Q25KZi9iSnFURHh5S0ZXcStGWGtyd0dDT2Nmb2hZ?=
 =?utf-8?B?Y0RGUzk5bmRnWGorbXhCaTdaZ1p2L25MUE94ZUZST3FNL3h3aCtHZjVCVnVW?=
 =?utf-8?B?RURlNWFONTc3Q1IremxxL3ozcHdXM1YxaWV1K2dtRVg1a04zM1o3VFJGazVZ?=
 =?utf-8?B?akpVaEpHcHQ2dE1pNkdVU29XV0NwOXVPcFkwVGhiRytMU1hER3lCUnNSMVNC?=
 =?utf-8?B?ZFhjWlNkOUhIZGtsMVBKdlM2cUhObC9Bc0FpMWtEVWplUDlqKzArL3AzUnlS?=
 =?utf-8?B?SzVnVEV3OGhBVWkvS2dxRjUyRFFNVGY0NUIwc1o0RlFleDVMd2c4QUxxdFpJ?=
 =?utf-8?B?RjdJSXZqMW1jenpERlUzRmtmeTBGemhhM2V6dUs1ZHh0LzJocFV2VjRibkhM?=
 =?utf-8?B?NkJuTjhkK0xTMXZQWk1YbTJ3a2NpWTIxMmN4Wnl1eDFla1V1WC9vUTRaVEFF?=
 =?utf-8?B?ekJybGJlbFhjeWcya0o2T2xIYzJqeEFqa3IwaGRWQ2lBWklNVXRFbnU1Z3dl?=
 =?utf-8?Q?zo8SsycXVgI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3828.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUR5UStRU0xhY2c2UytDeExWUzUyMk9zdEJJT1U2TnN3Sis5NTlJMWdyd1Zi?=
 =?utf-8?B?NFVOUWlqMUV4VFhiaWkvdEphNjExTHVDd1dvdklQYlN4YXRQTHNiQlBxQlNj?=
 =?utf-8?B?Q1REM1RMYTlRd1FCSk5MWXBjMzZscmh4bnRQZk9ubStXRElGelhhWDkxeVpE?=
 =?utf-8?B?UlNkWndYSzA3US95UEZ5UEtYWkM2R3o0ckFMUUZab0pydkVOT2lUOENQTE9p?=
 =?utf-8?B?Tm00NDF4eG9mN0M0MXJsayt1OTFXeDRPSmtnM3J3d3ZDdjF6REFhTlF1Ry90?=
 =?utf-8?B?VkFqdGN1dmlUZU83OUpPK3FsUktKL3pzN01qazRHTFNFZE9mVW10VkR3R2Z1?=
 =?utf-8?B?dnJ3cFNKRnpjYVRjTGptaU85MFJ0eVV2MnhudVlrYzlCcGhaSHRHdkc1czRZ?=
 =?utf-8?B?SzNHdDd3SDF3RktUL2MvdTNQZWhiUVNjZUNCMTk2YitpbU1UMThRMy93dk1r?=
 =?utf-8?B?SjBMenIrb1F5bFVCSElrZ0hOZlBGK3k4NitKYnpCb0sxeWd1SzIxQ3hacW54?=
 =?utf-8?B?SVE1Z045ZnM4MDBicXEvMmZDbGJZeFBhOGRUaXFyWUgyczBLV1FBV296b1E1?=
 =?utf-8?B?NTg1WnNnQ3dOVGxRaithb3E0Z0w3NHBTTmpRbkNyVjh6VndzczJTWVFvOG02?=
 =?utf-8?B?amowMzZGeHFqS1RaUDNlYlJrOXVNVDlEMWNBbm9LdDQ3OTJnSStEV3pyM0ZG?=
 =?utf-8?B?bUFUTTduZW56VjlSYkt5eGNFaTJIWGRjbkpJQlJ5eVFVQ3JYVTM5amtPQUVQ?=
 =?utf-8?B?RVo3VGlKZG82M2FzUFRSUFdjU0dycUhQYk1NUVRtdGZQa0laaGVzRFNRMFk4?=
 =?utf-8?B?UUYyUlVhcW44VExYSGNHLzF1Zks2ZUJrK2l1TnFRdU5rSnJTcVhseCtpem16?=
 =?utf-8?B?NHEvbDZLUVU1V2wxUGwxTElvNyttQjJqS2I0QWgvOGE3VFFKYW9nTjlaZFVj?=
 =?utf-8?B?Rmh5dmFOeGlPM2VDWXE0Q1ByV01KYXg3bDc3TzBjNzEwZGRBbERXTm51Nm5H?=
 =?utf-8?B?OTd0MjloSFp2YW5XbjJka1ZFU3EvbGg0cGZwTHBVU1REVzM5SnB6V1NKSk1D?=
 =?utf-8?B?VHRVa1oyeGg2YTRNdjJyYzdGeU5GaGxEczQxbnBoc0g3Y1RPTWg5UXRkaTdk?=
 =?utf-8?B?WUVtYWVLWk05dGxlVHAvZFBFZDlmSllidXdyVmFZTy9oUzI1dVFuaytZbmw0?=
 =?utf-8?B?UW5ONUNIUWsvOEFta1o1cGRxYmo2bXlvOXNyM0ZnM2YvSnJZaTBVS0R1dEZW?=
 =?utf-8?B?Z1llZVRYUFJMWWFTeHRQM0dRWDVyM1lBRm8rd0dHVmtuSjhLZmFDazVFaDM4?=
 =?utf-8?B?TDFHdHdXalFSWjgvRDFybk5oMFdNck1YbFdCTnVkNytPRkJQUVhjcVIrWFN5?=
 =?utf-8?B?SEFoYytEV3VBd0dDNFlFV0tjVkNtVnVCS1k1R1A0Slc0NTAzSDY3MTFWQVZQ?=
 =?utf-8?B?TWc0ZVFadUZXMGdVVU5JRDhBRENEVlIwbGNvbFR0dUlmbzMrRVE2UXdNQVJ4?=
 =?utf-8?B?NzR3cWN2VU1RK0FrUENSNHpXSjJPVSs5dE1Xc1JHVzZmN2g1V3ovTklrK0l6?=
 =?utf-8?B?SVBBaUs3N0luemlPYTJWVUdLWUhYQTZWclM0U0NOdUQ4aHMwNDNRQ0hENW1p?=
 =?utf-8?B?RWV2SVJzR3pIMS8wRUNPMDk1a0tLR2JwL0pOS0xtOUl3Zmk2dFJlUmYyS0Vo?=
 =?utf-8?B?ajkyV3k5SzhsdVpHaDdzdXFYb1J3ZER3NjBOQk52S3NxTFE1YklRdUFTYytP?=
 =?utf-8?B?SjhYTU11bVMxYUM2UFZUQzBOalN3SFhPdU9TcXRodldHQ3k2SUd1TlpLUXht?=
 =?utf-8?B?WlJ6NDhWTHhPWk9aOU05aUlRTUlnZ3dlR3E5VVF1UW1kQ0Z1TWJSbm9oTndm?=
 =?utf-8?B?MnpLTGJnL3pndG1tSlIxU2lYaEI5ZkltS3lUY3JmWUVUMFNpSVVrZmtycVVy?=
 =?utf-8?B?TUdmQ0ZiTTZNNkd2YkllekZ2RVR2OGoxaXQxMEJMNkF4U2lQRVNyaURjb1Nn?=
 =?utf-8?B?VzFibHB0eGtMc0lpTU5UMER1UjJ6TU9tQ3BwTHBKcHhQU3VxRUN6U0JYWUFz?=
 =?utf-8?B?N0tJcGhpUlFqeGlsL3V0SWdMU2E2Z09jTXVMMzBqNWFTVXFCcG9nbWRBc0M1?=
 =?utf-8?B?QzI5T3M4OEcvclBueUxNL3hWT2RxcXhkOFU2aDB5MHBoR0Nla1RJUFRnaU9W?=
 =?utf-8?Q?kgag6igEJgm75qqdUkMrs60=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AsdrCALyvIjvvACddZQt1SBn7BlTzdJ2puHcYmIOGVESXulPtBvuZpzoc7Ha08Zm3TOon6tEmiyhULIAp/1d/7TCrDtN5bQa4qGNY9niCyXoKRIanF5WGJV5r2yxDkX6xjrKsLQNWTTA+dWJn0X3zOUqJda8k4wHiOtio1hB98mnNOOwAdu7ojwfVKS1UIx4+KRLK9W++0KIqSH3CJgZC+8CV95AF9wmSrDVoyy5L4kBrXr9B5xpMOrEa+OBM8/4oDydFDvwEhK46+XsD7iAzIybkXvPk6prQrJYxtFvp3OvXwhBKHBTP8MHo6IgwHhi3kKe9mYo8LVKUY3C0FZ6JxiOJPA/N+GK4gEDLAWnw36h8tJKLaWU5h7uljsqgmvDNKmjOW4MdKiJufosGvYYqvIEDmfkC6n6tG7Xt2WiRi+leb+l+rQqek6VfERbZx8Bi7oxD9q1y9giTBmvv/5P4rBDIgb0TqYT42iF3D/JYZc11Fk5BxwwfrfnhaUcaabDieciouNMy2lX0EwrpwHBdTjTMPOzf9duPMgO2oB8pr7scwbnbBHEga0fsfxwHHZ6xfsNFvhdFAu0E3eZ/BHyKYejoYO0qcLT0kP9vDsYVFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb11c2d-0807-4e2f-b592-08ddb315fe95
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3828.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 11:55:20.7460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4JDABJWolnlD0ZsFBM4wRWcf09yoyFythxEx5XjEsKFqar37neRveFsufaBDvF/Wn3EgviABgcgTzAei0Cp4GFfKPI3k93T2YRHjPVFwkfabtMIs85J65WSv72DPJK8k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_04,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506240100
X-Proofpoint-GUID: ycATiy_Db5bnxgb6rcnwTKLE4gV0GRXh
X-Authority-Analysis: v=2.4 cv=CeII5Krl c=1 sm=1 tr=0 ts=685a922e cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=1GVTVQ1JiL--I6H4vVYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ycATiy_Db5bnxgb6rcnwTKLE4gV0GRXh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDEwMCBTYWx0ZWRfX3gfYBdgkSIYZ O/3PHT2xUwIZbtWZcOzbxrmc8NpnS899kab2rvoBU9CACey8/Ei5OKgQI+kiE3Dhapdg8Og6xwx Wyi63RPvnCqDMD1sFyP3j8Yx7uPKa6z+UI5HFCbXYc88Dc1D6iI9v07wt7KXmhqQZubjdIBBY1w
 H4i0KPGntuwtxB3Rx01qIRH+y56jGoY3CUik5Cxe0QNzz5XJlBKAFAo4w/l/YFOa6vf0sz0s+5w mQvVxdMfkLaycRWvexYuP1C9akzKVNz21Ep0lMmnrt/3hPY8jeiFhV1Lu7XfP207y+G5J7Th2/8 T3X6A6pcnEY3tVYdagmS5o5wojEGZcYs/pp+fD/c1I1mQL/ItI9FwCGs+pdOQAdhSxdisGExmbL
 dlMLuqp7wazCf60nubSEG0B9gNXhRcQJspgVqqDlifvvMlZzvyslXETspU7lkN8dMgplbKin

Hi Greg,

>> Build issue:
>>
>> In file included from main.h:14,
>>                   from cgroup.c:20:
>> cgroup.c: In function 'do_show':
>> cgroup.c:339:36: error: 'cgroup_attach_types' undeclared (first use in this
>> function); did you mean 'parse_attach_type'?
>>    339 |         for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++) {
>>        |                                    ^~~~~~~~~~~~~~~~~~~
>>
>>
>>
>> BPF tool build is failing:
>>
>>
>> Culprit looks like:
>>
>> commit: 27db5e6b493b ("bpftool: Fix cgroup command to only show cgroup bpf
>> programs")
>>
> 
> Odd that 6.1.y isn't failing as well.  I'll go drop this from all
> branches older than 6.15.y for now.
> 

I did test 6.12.y and 6.6.y but not 6.1.y.

So didn't report 6.1.y - but the issue is there as well.

Let us not drop it from 6.12.y greg. Why ?

The problem is because this commit was missing in 6.6.y causing the 
build to fail. but this commit: 98b303c9bf05 ("bpftool: Query only 
cgroup-related attach types") is present in 6.12.y. So lets us not drop 
backport of commit: b69d4413aa19 ("bpftool: Fix cgroup command to only 
show cgroup bpf programs") from 6.12.y



   mainline        : v6.11-rc1 - 98b303c9bf05 bpftool: Query only 
cgroup-related attach types
   ├── stable-6.11 : v6.11-rc1 - 98b303c9bf05
   ├── stable-6.12 : v6.11-rc1 - 98b303c9bf05
   ├── stable-6.13 : v6.11-rc1 - 98b303c9bf05
   ├── stable-6.14 : v6.11-rc1 - 98b303c9bf05
   ├── stable-6.15 : v6.11-rc1 - 98b303c9bf05


Summary: Drop the patch we are talking about: upstream  commit: 
b69d4413aa19 ("bpftool: Fix cgroup command to only show cgroup bpf 
programs") from 6.1.y and 6.6.y but not from 6.12.y

Thanks,
Harshit
> thanks,
> 
> greg k-h
> 

