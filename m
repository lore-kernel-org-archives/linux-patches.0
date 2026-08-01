Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21082E03EA;
	Sat,  1 Aug 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785598019; cv=fail; b=AYjhW6IgxxpP9prgcGsbxAr3H6p41XatAltKf0Atx3Q/+C4r3ehhuS3HcQGNcaWlWlUywkzcKVV42uI61Zv0jIvq1GMKIGhNY5y3k6u5YSC6yo3kKUBHtzEmsX7/t8PpcNTHjYUprOGg7mWGW9Vpn/TFNQTP8Rb7a460pi8kYkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785598019; c=relaxed/simple;
	bh=AIjix/yU/PV1cy6cLUDlxlwocGlwWzESK82jFQ+OUhQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K+laX5PbSTL5A+/pfB4rf3tob0uMxE0YaXZAz8OX+QFN0YlR4aMV0H8XIk+Pi67uj/LmgRoabhCHXN/Q65suKWmVp8QiIjAAbZr+BPkSC4Bjj6xwgf0ufsrv0yt2RjgbcjQgkRV0Zdl9JZmS7uS3SW3wNz1gA9rMFL0D8KDBcag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m4hmZhWt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ssiYYWWU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m4hmZhWt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ssiYYWWU"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 671EkCpA2608741;
	Sat, 1 Aug 2026 15:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ugVQolP5CHEeHrQSGeth62+c9IdoIGLSaG3VfUqZW/s=; b=
	m4hmZhWt0sTOStNiFoU/fg/vRYL2HX4Pf+a9M8q0JqrcCWJ0vxBKDfuZhBjFkZlS
	Mzumts1eNsP5Xuug8U9pDalVXubtyjWOyWyLolbxpDgJPC4LHipjmhCw1+Iw+F6o
	6SS2mrorT/vIUfA9Rjp5TMo/vdPTj27JjY5WZzDbEng4JTe5lUMiwRxQwzpAXQv1
	5lLKc49x8IWoCc36DpMAH27MCMD5eyxezkARwRd3pPfGZbH/2XkVtqH/oQ1Bvikj
	+vFR/cZZ3rZEFjTxz9xXAIGN/aucFUh7YO5iqweRosDrLDYc4iUdqQLm9UKRvNkq
	KRMdxIqHLw7mlnM5Gdizkw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p9200b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Aug 2026 15:26:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 671FKWJK040352;
	Sat, 1 Aug 2026 15:26:51 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78qny3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 01 Aug 2026 15:26:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3R2GKeQI1dik4A1Q0g96ihE6eLLU3ngkq9tJM16NLitIYV94l1UyT24sV5IFaJPgYbQiSMQgZpRJuA4AIwHtt9sEzcQmfaYN/gqBdeBfT5nuPhSsmE/mB2qRHLbHeTdkETBSx0Tuu1LDIJNnyjrbqoyIsYlMXgPZZD+bfm0fNlAEdG6qGmVbwDjvZDgyMhH2vkDaJwAyVg4iAmTzPRVwqWnKqdiyR6YY7eXTT98+hjdEg1m/B1rPyOi6Yd+O9mpFOeLeXq1VYwgfGM/rC2FQL/0Am0+2x5AxlhUnzTjOcCFaA9fPC6mSa2xdAGQQ1HIn1WT8hq0UE7Jn93FUlyk0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugVQolP5CHEeHrQSGeth62+c9IdoIGLSaG3VfUqZW/s=;
 b=gzXJXHw2Yt94IcBFf/xTYsOeGnnwXsxiwncwqfqTAAbkSWKLLVeo3zyQTTTs0OrAW2jK414AA1HXSuTc1lajtaryfNBie13CH0tdNH8QEVSY5RNQFqe0+jpKE+xoGEl8eGmfjWYOLnYuLDnsDfivOMWIhCyZ6dkbgMzp3YnbhbDP6cw52gfvWRWSTqcrNr+g+TuV5A5oGVhE9hkObXYEux0PNp4CAjQPfxcbInt9dAWNzERrL7ibGNLxXfFiHHSfS6XE3l17SCE+rEJlOUMGQPUG6+GpPwjKCOJKyKVRmWpHyntg0rANsPnzCgqRJr1XvNwPMOa/hn2lkdJUL3+iGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugVQolP5CHEeHrQSGeth62+c9IdoIGLSaG3VfUqZW/s=;
 b=ssiYYWWU5LFDTrmx/x4gksiTKqQ+Mm3udOTbhB5ohLpetNiNQyI52V1XeFrt1Y3/4s7HXrkKLNFlQy+v5tZYplrVPlauFWtDbG87Qez8BB1CnHnB/V/1XVMC8CHsFaXvOZbK4UaQdP/TilZvWcmzb664595J7jC/tJd0hmyAf7w=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BLAPR10MB4961.namprd10.prod.outlook.com (2603:10b6:208:332::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Sat, 1 Aug
 2026 15:26:48 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Sat, 1 Aug 2026
 15:26:48 +0000
Message-ID: <2eae07c3-848e-4bc8-a444-f8274692f653@oracle.com>
Date: Sat, 1 Aug 2026 20:56:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 528/602] thunderbolt: Prevent XDomain delayed work
 use-after-free on disconnect
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Michael Bommarito <michael.bommarito@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141447.107046386@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260730141447.107046386@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0302.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::19) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BLAPR10MB4961:EE_
X-MS-Office365-Filtering-Correlation-Id: d1e0dd7d-724a-4eef-2ea9-08deefe14d81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|22082099003|4143699003|6133799003|5023799004|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	JYCJzsXU2MijVWnwUEaJ6YnLmvqKQ/pXIxBl3l7UEej2Z1FdLziNoRWAOxCk01rCxTcGicD9clio99981KOjnICnEgea7BMIK17nhugii1wpkPDKP/EYMQBpwrbKSxDwoCjvlziGbauWfwhKaZRrMsVnRqU93UmZuvLONRKY3i5CtN8BvEOfXZcEQJ6G+ilMjRerF5GQawHq97pME5+A2HVVuCafcWcAGtFftrkIz+PDT9IsllW+HpEiAXcW5g/cpK3tJ4GJ1NHp788evNwN9HQ4vI1tsDKj9xoyg+vUDW4ae0fLm29TEI7EUtnDwVVoaff1v0W5zl9BnfPkwW9CxzBCyd61Wr464yqM+ixXOKwm/zsv+XYPZNuedV4wbGMUz+5IZjw5vvosU8cmMHnjsYWt0xGS0g/W//WZZ0r4nYeIbFywNg9wLGkTpFipxQi/fhzX/z5ckz5sOmESaRyKCCDw7EgQE/2D3y1xbnvz1gNWT5keDnFxCccq9kdgZmoaIQY0U3l5P+h3Rc7c2EYuJkMnoP0BWdXbgqwU5ntoaEHDHOmkA5J/PkZE/21WqeOlJw1y0vtacrs71KA1DIKEDr8eBiuEneQNy2H2N7/XMqYLoT+NV0Ynka72xlMjAJcRGGdZAQeniQnLzk8GJDovurEzAkzxwTIHCvXGdC0txOs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(22082099003)(4143699003)(6133799003)(5023799004)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmVZZXNoRzZqQXlCbDA2bzFXQWF0dTd1aFJKakcrajdmRnUyS3Rmdkx5Mjdl?=
 =?utf-8?B?ckNaK1FUbURzTWNkZkVoUU91TnlCNkFJd3JFQ1JlV29zM1poTnhBOGRIaDA0?=
 =?utf-8?B?anRlZ3NHUGRlVHdnMWdDVVI1TFhUdWdQUG1YTEpzQlYxSyttNUhyTGNXZ3RW?=
 =?utf-8?B?MFB2WDVpUjJveURwSnREWEJOUnBOQzNqano5Z2xBTVJpK0dvaklLTDZMMXBZ?=
 =?utf-8?B?eXF0dk1SckNHZ2hTMWpaeXR4RDExcHhWZElvWGVQV04xVmd4SzFVd1Nkdjhi?=
 =?utf-8?B?NWgrd2pzdE9yVXRCSGFLZ2lkcERQRjlZRERKLzNKeWQ0RjhoclFPVTZ4ZkU5?=
 =?utf-8?B?dGdxcE9xRi93Y0ZwK2pvME1vcXJwM0RtSGFCbnk0NzRMQWpJRHNRT3lkKytx?=
 =?utf-8?B?NVpEMjlUckRJZXZhNTF5OGpEZ1dTaCsxbjk3WVlzUGNyanlpSWhtOE5Md0Zj?=
 =?utf-8?B?YTlpcGlPUjQ4R0d3NGlOclJsdkVObGl0Smg2bGdMVjVPMmU1Q2JyV1EvRjRi?=
 =?utf-8?B?QzFSZWJHc28vWHN1c2c4OU81V042MTczOUZiL2VheVAyK09sbi9MVE9xbmtX?=
 =?utf-8?B?SWo1VmhCUWtKOE1GVS91eDZnd1BaK3dFVEc3d1BFWmh3aHZDcjVmdWxPaXRY?=
 =?utf-8?B?VGlrYitFNDZlYmFSc3ZyYm5HZ2NlYTd0WnJpOWpUSk1HRzBwVmIxbnpEdUFu?=
 =?utf-8?B?RGk3T0x2OTRGTS91NjJCYU5Od0c5MEM2NmFBbnhjalQrMzZqMjhSZDE3SGg3?=
 =?utf-8?B?TUFySDY2NHlyVUtZck1WWUZYNGNLcE9TNHhMU2VxaWMwZWE2VHVJb2ZrSFF0?=
 =?utf-8?B?R0U4Q2d2am9hOU1nVXJRMDZGSk1taXhNU2w5NHFPaDlac0FiYlVuK2VxMVdI?=
 =?utf-8?B?UmZhWE9kN01iUjNIY0hvSDh5eG9yT3N1NGR4VzhFMUM5UGtpVHZSNDR0dko4?=
 =?utf-8?B?ZEhJZnZCbnRDUVRXN2psQTVibDA5dEkxSVpndFJKc3lXa3VqOWVyYUJ5MnYx?=
 =?utf-8?B?L0ZXeUZLa0piSG5PMmo3ZWM2SW15empGR0d0bURRL2NvK01HVm9OMktzbHVB?=
 =?utf-8?B?a0hBVkdZK3hXcEF6bGk1UlQwbW5nNnFlbDZZdEtSaTQ2SFlSREhIS3R1dEg4?=
 =?utf-8?B?TldMTEJNbWwvUEVjUXZVdlR0T3Y4dnpDQmNmOC85dXkrZG8yY2VwcFYvdzhU?=
 =?utf-8?B?UTdMR0JPRHczSEFPOS9DdzRoZy9UWG9peklkNFExV2tEQ3ZVS1BXSkhtUTNF?=
 =?utf-8?B?bUFjSklmNTNqa3VaQm83QmhHVHo2K3M5VEJlbmVOWUIyYWwvMk96OGtnckZp?=
 =?utf-8?B?Z3pwVmtwN1dZK1htbkUvcGY2QVZsNFE4SzZhQlNPS3FSYUxDNGRVWnBCY2Ez?=
 =?utf-8?B?eTcySld5QXVTazd6ZDIrMkxyYTJzWTEyK1NFbENubUhRNXpIUXg3MHdZVWc3?=
 =?utf-8?B?MTBBdy9tVHVjWlR4eTVvYURMaERSMTBvN0xIYUFaZ2ZHMzNPdnFXNEE5Nk5R?=
 =?utf-8?B?S3lhYnRYZmtVTmZTQktneForZ3NuK3U0ZWc0SkdOVWdYN2U4cVJXQ0VZQUI1?=
 =?utf-8?B?U3FKd2NBc3dpQmJDVzFSMjREVktnTlErK1pZM05ZSDRqN1Vlc2lRTVNWRnNy?=
 =?utf-8?B?QnlyMnF0ejRyWndJbE9YRFlNVGZjSEpiTzhOWDlCTmpQdGlucW9IaHU2QnpO?=
 =?utf-8?B?bnp2dWhya0dDMHorREtucS9WZ2kyQkFkV2pqdHoyV2gxMzI2WEJnUm1Pa0Er?=
 =?utf-8?B?T3J3L1ltU3p6SXAxK0cwMHJaU25MRUF5S2M5UUZqbkFuRDI0VHdoanNMZDkx?=
 =?utf-8?B?QythZTk1QUMvbStHUndiL0dSdWYyVXN3TWNRUWRQOEs5L3c3VE00dG5IRGxL?=
 =?utf-8?B?UlVMaWxBWDJjR2plV1BuaUoyK05pS0J5ZVFwTTNTWlAyQmM4QXl6MUxhcXQv?=
 =?utf-8?B?Z2hzZjI1am40YjhTOUd1N0VmQkE1YSswWHF4QmtPY2c1L0JxMDZhR0ZaTzEr?=
 =?utf-8?B?cm9ISGFiVjA0WExEM3UxTzhXaE5lb3M4dm4wNG5mR1UyWW1Ka0o1clRJQjh6?=
 =?utf-8?B?bnl2eUthMk56VFlvaUNwM0ZBSEhsbVM3K1B1Si9KU1FKTXgxeXovVWlmdkpB?=
 =?utf-8?B?ekF0czJVYTFreHVvV3dpMGxlNUxFRU16ZlNVblFrQUt1eG9QMWFsb0dWaEoy?=
 =?utf-8?B?UklDUkFjMUdYVjQ2MHJIZWFGcWNDcTQ2UWRLaFB0Z3JrTmFwSkVodW5TNUx2?=
 =?utf-8?B?K2huVm9idFMwZkNHaGVvLzV0NjB2YW9ZY0FkL3djdUUyRG5MOTFYSTBKbXp5?=
 =?utf-8?B?Y3lJN0FGT2kxclFwR1VubXdlUStralpmemJrd2U0VkVINXJQNVRQenN6SWYx?=
 =?utf-8?Q?1hVc9Gy1i+01c8MaZpNKWl75q2hWZ0AMCNnJq?=
X-Exchange-RoutingPolicyChecked:
	g5RSbgnqjRwOpVb9e6WswHrlA5kkUbF+EPkzlo9dSUi+NoY+VVttL+IltpGTcMhM2bobKqY3n2j1oP2vB7Bwtl/c7skkzs9nTH+tNc+VMNr5VXwyMLU1djYSsqypqlTlF+Okv4dNZADy86WRjvcubMp9WmFXj9vvacKARKlS559iEY8iJHx/edXLbspPo599IPQAyo+z0FzY0l4PDNoQX+7mGSuUnt1NLOO6YgLnHCEtJhcXoed7ZpNvDOve/mH8zQkzgCfHKQH/pK4k4vLpI8m9FKiBTBTAzUATSM1+z/uDTgAsoPv148bCydDMY/op+Z1I0Qb3Hls0K68J4JQ9yw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wW7Obd/rpJ5XUvSY32AbyKTOe4bMJzWyQiaVPVpS1QI0PXuSSa7REquGGMGaalbAGij46cXRrgxLH9mD48Zw9xS3JoGPUJZICybRCgT0LGvzAOsiy06hnhcGXeitM/g6aebLc5PF+0LJAU6j2A0OafjLIr0PnLmKRtm7ByBbJ55q/xGOE7J7ZGas84YLABiEqGqgVsSgdMK6Iq45h8nOnY+b1aHBRqSU4SCKg7aj96/0Dh2J/u9QauE70EzYIiWhQQwcxIaswpjYIkgZDC01LZ7UiGTmBmuLQPa+kUtDwA/GyX1X/aXaZl/uAtCwq/0DN4OhyxTemG9H7FVXGu1kTzKD/HcG5IXD68aAb0SjViW4WKQqPvfOmqewDnkmI/NqKJKjkOyjzFxZoBgCMLRpYtlQKmwYsDtMRvkKNg6U3jKJ79kGn3ua6t5/pdt9vWWTO2/ZFdhwwMwCQ7smoHgZsHXwjsn0geFYwSi2IWleXj0qOlKGx4/nceJ1pevE9A7CHB42k6DlLkKWc8Ml+xGhZ+8jYpgQTKk6jUF8bO18BTkVk5znl04OROGjoSzycxS1rvtVbWxZS+VK1IHyNEk8j0YKK7JKX55VTMqpjSMykWY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e0dd7d-724a-4eef-2ea9-08deefe14d81
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 15:26:48.1274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fo8cBjFxcklbP3m14Xju77n2aQvOWKWarSculJYsgi8NZdzh9D/CvnaMioaKeKEwZh4iimYKBjG9K6IRZ6t+lxn/KkM/v9X6wRx6Uf5lLXeHv8Sb9FvE527QiphR4VYy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-01_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608010124
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDEyNCBTYWx0ZWRfX/h9ZywqEGNDS
 6p6MWVUmuhTLyi40y5vcM4qOAXVDRKo/RJM2cSmGQx+OUWNQRrogp+L+b8Ppu/lukRpAsQLQP9y
 hj97gdielyrCCgYVGNz5uPCU8iTzSANoJyoDwFQ8ZkT7tCiaCtqY
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a6e103c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=ODe9uk77vCX_pbRvk70A:9
 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-GUID: WxAcdAnGI526hi1aDK1YaPwboA4H8sOX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDEyNCBTYWx0ZWRfX1jDtuV5c4ciL
 k6Oj87UeqDzjcMiTMw8wIHE+U1VYhSDHEWCbaguHcIAx5ROgXQeXeyeABfGt3H5jOjoqRM9OlBi
 dAkVHRy85H6mzK0ycdJ/dwSowTQ8TfyS0fl5RkeUsW8hS3c3//kwq/iO2OC+P/Oy5BDvxPUCYRh
 zgEm0+z2WSHmbturY7M9Va0IUclzVcHgdsuqEDQwrae/rmckaTbOWuN1gebUdSujd7t2zdD0Sez
 6CI7RTv0MPa2LnEzBydf3geSbt57SCR0+bD6kUg8VplFagkaRnKBC1bEg0tV+33CA67HdQ9RHy6
 rpfHyYN4QW8EKpmDd8cZwk/9o/NOeVpxoLoaYA0PmSeo73sFFkFOUa+ZCCjn233YXmHCe+nWDd2
 W8UmXwOVpUhgiIZX/0dJEDUu4UG9LkZ7g/naCK+3dB8M7YlNSpr6Hq76ARR9l5irmF5Gqf0QfPq
 9jxyeWi8H9GXdRu3wwfbJNyqZNxaxMpA4mVbG2Qk=
X-Proofpoint-ORIG-GUID: WxAcdAnGI526hi1aDK1YaPwboA4H8sOX

Hi Greg/Sasha,

On 30/07/26 7:45 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Michael Bommarito <michael.bommarito@gmail.com>
> 
> [ Upstream commit 2c5d2d3c3f70cde2565d7b279b544893a2035842 ]
> 
> tb_xdp_handle_request() runs on system_wq and queues
> xd->state_work via queue_delayed_work() in three request handlers:
> PROPERTIES_CHANGED_REQUEST, UUID_REQUEST (via start_handshake),
> and LINK_STATE_CHANGE_REQUEST.  Similarly, update_xdomain() queues
> xd->properties_changed_work when local properties change.
> 
> Concurrently, tb_xdomain_remove() calls stop_handshake() which does
> cancel_delayed_work_sync() on both delayed works.  Later,
> tb_xdomain_unregister() calls device_unregister() which eventually
> frees the xdomain.  Since commit 559c1e1e0134 ("thunderbolt: Run
> tb_xdp_handle_request() in system workqueue") moved the request
> handler off tb->wq, the handler and the remove path are no longer
> serialized.  If queue_delayed_work() executes after
> cancel_delayed_work_sync() but before the xdomain is freed, the
> delayed work fires on a freed object.
> 
> Add xd->removing that tb_xdomain_remove() sets under xd->lock
> before calling stop_handshake().  

let's remember this.

> Each external queue site holds
> the same lock and checks removing before calling
> queue_delayed_work().  This provides the mutual exclusion needed:
> either the queue site acquires the lock first and queues work that
> the subsequent cancel will see, or the remove path acquires the
> lock first and the queue site observes removing == true and skips
> the queue.
> 
> Fixes: 559c1e1e0134 ("thunderbolt: Run tb_xdp_handle_request() in system workqueue")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/thunderbolt/xdomain.c |   26 +++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
> 
> --- a/drivers/thunderbolt/xdomain.c
> +++ b/drivers/thunderbolt/xdomain.c
> @@ -905,6 +905,19 @@ void tb_unregister_service_driver(struct
>   }
>   EXPORT_SYMBOL_GPL(tb_unregister_service_driver);
>   
> +static int update_xdomain(struct device *dev, void *data)
> +{
> +	struct tb_xdomain *xd;
> +
> +	xd = tb_to_xdomain(dev);
> +	if (xd) {
> +		queue_delayed_work(xd->tb->wq, &xd->properties_changed_work,
> +				   msecs_to_jiffies(50));
> +	}
> +
> +	return 0;
> +}
> +


I have run an AI assisted backport review and it spotted an issue. I
have taken a look, and this backport does not contain the fix described
by upstream 2c5d2d3c3f70.

Upstream adds a removing flag and protects queueing, for example:

     mutex_lock(&xd->lock);
     if (!xd->removing)
             queue_delayed_work(xd->tb->wq,
                                &xd->properties_changed_work, ...);
     mutex_unlock(&xd->lock);

It also sets xd->removing under the same lock before
stop_handshake() cancels delayed work.

The 6.12.y commit still has:

     if (xd)
             queue_delayed_work(xd->tb->wq,
                                &xd->properties_changed_work, ...);

and no removing field or guarded request-handler queue sites. Its diff
only relocates the unchanged update_xdomain() function, so work can
still be queued after cancellation and run after the xdomain is freed.

So I think this is incomplete backport ?


thoughts ?


Thanks,
Harshit

>   static ssize_t key_show(struct device *dev, struct device_attribute *attr,
>   			char *buf)
>   {
> @@ -2480,19 +2493,6 @@ bool tb_xdomain_handle_request(struct tb
>   	return ret > 0;
>   }
>   
> -static int update_xdomain(struct device *dev, void *data)
> -{
> -	struct tb_xdomain *xd;
> -
> -	xd = tb_to_xdomain(dev);
> -	if (xd) {
> -		queue_delayed_work(xd->tb->wq, &xd->properties_changed_work,
> -				   msecs_to_jiffies(50));
> -	}
> -
> -	return 0;
> -}
> -
>   static void update_all_xdomains(void)
>   {
>   	bus_for_each_dev(&tb_bus_type, NULL, NULL, update_xdomain);
> 
> 
> 

