Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEC34A0C
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 06:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738391485; cv=fail; b=dZEJjUsmTGtpN9pPU26gOUILpQ+GZLsoruvNlxPhhCQqXRo9P6KCVjYQFOE0ghDAEgVQlD2Q5R/ubQNdUfnh+HdNtzmRYdQ0R/c+DUBJwGE4JUyEzqGIsRcdiaNMSUdpD2RojRy5wBPbTcRae3erxK7ujHKjohLJAiESgPFoMSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738391485; c=relaxed/simple;
	bh=VKEZnuu/CeX3gwiTmPAW1V3euOy4VC4Zf9R+Ffi4C6w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WvLdw6pQ8k+U5bDyDKuE9TBYiJJCsXJhjruQzdfla4D6gz14qcYL0uAdg6JQmb53p1mj+xC5KgDcW7uoMBCvsgL4aPulMwlYsFAaoCQb01SJmdQfUEwtmZy9ntAcvh3bnnJGNFM2VliHY3W0FczIHuiJutSMbzKDHcoty7LuBsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AT7srJ17; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vsF2DQXp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AT7srJ17";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vsF2DQXp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51168fUT019019;
	Sat, 1 Feb 2025 06:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=WGTcGtpMkP+JO160i8DDJsdfAXJFd0tnpsnYVLZ26Ro=; b=
	AT7srJ17dnZO73v9Sd+jARiP2n9Dfg+jgjwqwA5f9EZ3ZZIwi4pjPRh0S1YLLK4E
	s+/jXJhyQwJMaClDi+vPhMDSmyY2kkLCVfXXMz4+JgBt0xBmaRrH7ZzE2vwuztoM
	rmm0JXU/5i43VauMRltYO+AvmXOLVyCxI0iXYTFJV5meeUwsqBax7driqw4kaERM
	ox1meGW2WKBa6+Lnf8ALvM1segdlXPOKvHZS8uWrtONJx1gNSzRpVRDU3BAgRc1r
	w0csCR3N+H2aglYmS8b3vXLk8YhliPGKagaENtch84mtyNLsX0gnR3CfwRWxDU3U
	/Gu+dJkhoYWeEc6rMPjFCA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44he2bg0eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 06:31:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5114s2K4028080;
	Sat, 1 Feb 2025 06:31:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44ha25m99y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 06:31:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdhpXhEZqe6qS0XA8giDCFkcQ6A3hgdVyABwC5AZo7T9O5qW1qKBDWKZkwNAGnNtvQ+9SpZO9wbJpaKaIoiQ/KYXoOVN93wUV+aMwpqy27xLy2oCuj4cjfhcfNzRhJl4Kki9eUvK6v6yWZInWLSihavyTPreB3yBtZaU1kz3jPlGuWSfZKCz0ZDl0wDMPxbp3UolW71HK3u8zTQ1/7jGLDOLN6sPkR5dtPjQljUmmx+6nWbWit6inDp9duhtZi+HRcLrrD5q0z4zLzMyZaJxRRNrwWf8TFqVsIM98j2h0+8HaeuCe7BjMo9/WAkNkdho77EenHuCX8/J5Tgh/NuK5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGTcGtpMkP+JO160i8DDJsdfAXJFd0tnpsnYVLZ26Ro=;
 b=ggfUWrwnDoudovV9HBR4P0968pScrdG5XX1+SssDeCDn6gMxOSSZTltXDdjylGYU4Ai/Wk9twbBLc4iXXhRg0H1Lut6/afhPerC/Pa+6oWWj/KwmQvsjgH9pISXrvcZS1cKr8CqiC5SiILr0m0p5FfHGafoXj2FQWexPX9xQNDO8sSuPm/SdIJIlXEEZb/lBTGB0qh6Ucxxl9wZ4vQiA7dmSbftO2wdwN5iiyxvSlR7LUKp+Dz9ZHFHgALMsy676qjEsFBBqzJZiMRj4eMw85rpCbTVou5kaopGreRa/yKByjdI1QW4bZmlzunTNttFYDyceh/5IzJIiNh0XdyRJjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGTcGtpMkP+JO160i8DDJsdfAXJFd0tnpsnYVLZ26Ro=;
 b=vsF2DQXps04kuSPvr2H42CCIp+BYMSaH2rcqzQISWGdcA5ylbYxDe6khHLLGKhZRbxm5XaCfk3g14+gW/JDV8D2/BF+RUZ5euotby6LM8O8aakJ6COwIX4DPDtQIFUjU6N8i/UuRmb8hMyP99XUBD23zz+Y4L/+toX7CkgjY9os=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by DS0PR10MB6774.namprd10.prod.outlook.com (2603:10b6:8:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Sat, 1 Feb
 2025 06:31:00 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%3]) with mapi id 15.20.8398.021; Sat, 1 Feb 2025
 06:30:59 +0000
Message-ID: <ee9d7995-2f8d-4fc9-a654-ee110e43e401@oracle.com>
Date: Sat, 1 Feb 2025 12:00:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/24] 5.15.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250130140127.295114276@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|DS0PR10MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: d736fe95-5d56-4d96-e066-08dd4289fdb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0RHUDUzdnhkQ2ZoS2JZdEVVZ1BHZVpIVVZxMlBmbk8rNmxaanFrTGRycU5z?=
 =?utf-8?B?TnY0TDlZNmhzNlVpVDhWYzBqWVNtSXBZb3ErdWxGdlZhRjBSejlCYjI3SFpT?=
 =?utf-8?B?bTBkcVdFNVloWFA1amxIT1B4YVdNVDRabW5QVDk0enQvV3QyV2ZXQWRzYUtG?=
 =?utf-8?B?VzJySUdXblFHN0ZxYVh6WllhTExzdU9oS0VmdHpQSDVEM25ZaFcyNkt5TUpl?=
 =?utf-8?B?a2VGR1JKcUk4N1IwUktzZHVBeWhQSHhVUENGSWIyclZTWk9uQTFoUS9RUDNF?=
 =?utf-8?B?ZTkxb1I4S3BCV0dWdXdhcnNCWGlmMkRCTy83eUd3Nmx1VmhZRlR2SEh2b25F?=
 =?utf-8?B?bDNVOWkxVVhjRi9hNi8vN2FNSUlDNjF6L0R4Y1FZZjQ1Z2VqaTB5ZWlDSkFo?=
 =?utf-8?B?V1AxTDFKUVlFYlVRR25ueW5tQ2pSY3piS3pLazZSOCtvS0didDYvY2VCVHMr?=
 =?utf-8?B?b0IzTlI2TlhpcDNySUVud29VQnYraXJEUUxLNFhjTjBLRE5ON2pRWmRPdVBV?=
 =?utf-8?B?UFVmc28vSVFSdk5nekd3ajJQTUlQTG1SUDB1SjNiaEdJcEY5dGN2c3d2Ym40?=
 =?utf-8?B?bkJwL3YvTTIvaVp2azRkNTlXbHIvdDdaM2R4RCtYU2NTZFh0Wkg2Z2ErQ3V1?=
 =?utf-8?B?a1BPbzB2b090aWk3aVJUTG84YzhwVmFBZDI4R005YWs2V241K3N6bGFHU0NX?=
 =?utf-8?B?K0YreUhwTkcxMENHYy9LSFZGQzgyWFV3ZUNnZW9OaFFrT3lhL1RualVJS2tX?=
 =?utf-8?B?M2NlR254dThwZExjYXRYTWc3T29VNDdYL2dBSkxBdXJneVNJQWF4MmpwRjU3?=
 =?utf-8?B?OXV3VlMrRjdLS1IzUEtxbmt1aGgyekU0NTZvK0FmVldRU2gzMXNHUjVmb05l?=
 =?utf-8?B?OXVGRGZJMEI3b1ZXRFhIOUlSalFzRnhaVnBkckthTmhQMmpRZ3ZoNGZuQmZt?=
 =?utf-8?B?THBSaVVKQ0RGMkF5emVvT3RXRkVCKzRZcGtkMkh1Qmd6aERid0tERVZqcytR?=
 =?utf-8?B?OU9hYklubVFQVG5rUzlFb1BoQzdVVkF2Y3h1L2FGc3JpK2F5c0VVME44bU1W?=
 =?utf-8?B?VVRnT2diVjZBempSNzg3ZFh6ejFXekNVc1Y2MU1uTkhlRW90NFNaelRVbkxh?=
 =?utf-8?B?cnp1UFZLdGRieTVxcnJkajhQK0gxZElHVTJ4bkhqd3NZV2ViaDRyNWpqRGJE?=
 =?utf-8?B?dldNcmpuU0FDT1lvSjVYVy94UzNPcjBRdit3MytzbW9pODB2WUtFNDhBRkU3?=
 =?utf-8?B?RFdhTStDNnZKakhES1Q0ZWQ4Q0JJTi9kUWoyS2pEZFdxV0RKWEZ1RC9vN1lG?=
 =?utf-8?B?STkxeDlTbThVbE5EbHVyc0RXdjUzWnMxaUQwRGxpZ2tXbERjV0tLMUwwNFhu?=
 =?utf-8?B?TGNiMFZwcHQwdlVVeFpxa1VpeHpQS3gyZmdYM3pGZUNTY2VVY25LQnpFSXhM?=
 =?utf-8?B?SCtZOUdNcnpaSFMyVkcvdXNtTkI1NFRlVW4yem16SFZJRUZPUGgvNHBETnpX?=
 =?utf-8?B?M3M0dW9MZVhyZlRrSlhKaE1DYjhRMFdHV1NpSFM3cUtTN1VzcWRNRWtCS0cv?=
 =?utf-8?B?YlJWc2VsMDY1YXk2Nk1oWG5zL3g4QjJ0UERmQXZLMXVMa2tlMlIxN2o2TURI?=
 =?utf-8?B?TVgvUWsrTFI4NFJxV3BHSjdqVU1IS3o0V1Q1YTNUU29BcWl3YmUrZ1cyc0FH?=
 =?utf-8?B?TEFKbVNEK0JTcGNFMnNUZzNrbzFnOTdDUkNUTytZWjFVTnBXSGdNWU5NcWNt?=
 =?utf-8?B?U2I1cStsSU05SEp4QkFQUFRuWFN6VUpKd3Z2dUpORmU1NFl4SnhqTldxOFg5?=
 =?utf-8?B?eHgxeUU5dElCdGsvaWt5NGMwaHA5NndVTmhCa08zZTFIaFlpRi9hclJIKy9U?=
 =?utf-8?Q?jNiTmuQuik3cE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGswN1IwUk9LV1JrdndRQzNBcGtQTi9YTnA2bXYxcW9zdjRldWVCeUZlb3hG?=
 =?utf-8?B?dmt1N3dpUGloVGU1K1NoMklaYlRJS2NoNXdCWXhKVXV0NURVcVdSaUIxOE5t?=
 =?utf-8?B?UVUvUUZwOVUxNmJlU0g0ZGpsaXFpNlFGMkFBbFIwMkZsczE5YllpcUFnSDdq?=
 =?utf-8?B?L1pqUGd6UGxiTVFwekF5T1ZjbkNYRXdKT3JhcnZoNGxUZGhMc09xaWRPa0dM?=
 =?utf-8?B?eHRFbTd1ZFpzeEdDZ1huRG0zN1lhaUZPSGlwaDJiRjNLT1VNbURGeXo1QWJ0?=
 =?utf-8?B?YmFKRFZtUWdjcWFUUGVVdjdrRUw5QVFiQmhyT1EwcVdOa2V0a1RuQXgwaWxl?=
 =?utf-8?B?dDZHY0kwcS9LZHI3bGVxTmVzV0lJaFl4MnVoODNuV29sOEh4eU5nUmMzTlFP?=
 =?utf-8?B?Z3REdkRoUUpNdThQYnNlOG0zUTZ2bHpQUlhqZkJZVVB6dHJQT2h1RjBUU3gr?=
 =?utf-8?B?anV1ek1jZmEyd1cvRHMzaEcvNGV3NlRQVjYrQVR4Z2hCRFFrZ1hadzhGbmNE?=
 =?utf-8?B?bFZORlZ4cE9SeVFNRW5QNXNNWERZK3VxRXFSczh5SEFPek9CZFYrLzdkV2tN?=
 =?utf-8?B?aWMyWW5hWmZoTjhpMHNkMGkwb2svWDNJbzdoRitFL0l5azQ0T2ZBOTl4Q2VV?=
 =?utf-8?B?cFdyeXRZeFIreWJkM3oyNnRIQUljd0dvcTU0YmlUL0h0eGk5Q2NzR2taS1RF?=
 =?utf-8?B?U2NabmU1N3FueW1GTXRGL3plMWtJZlBCbU8rM0QvU1c3UVEveFFDeUNuSUho?=
 =?utf-8?B?Yi96YUorM0cxNGIxd0R2dUFXd2hXeWJpUEZCeE1BTEdwbTVCYzNMRHZhR0gw?=
 =?utf-8?B?UFJxTHpGQVFEUktTLzdMZVhVVHpvYk4zQ0VmSEN4OS9yQzl6YWRKMEIxLzVr?=
 =?utf-8?B?VEFoTVYreE1xUVl1SUV4VDNpYlhUK0NXdmlkUHoxenl1Nit6M2tQNW9rK3dj?=
 =?utf-8?B?NEZUZUEyQXdQdElOT0RJOTBJeWVXbW5DZWprWU9NbTVMMWJVSkU2UHdnL1NJ?=
 =?utf-8?B?Sy91aTdsQ3A5Tm5CNlFqa0tCb1pKWkh1a01hV2ZpRGoySFdFMXRZM3JBdjFZ?=
 =?utf-8?B?TDYzaDZDY0RUdCtaRkg5djMrTjVGMHFRMk5LVnBMZVpicWgxT2xMUmI4MVVB?=
 =?utf-8?B?TXdWTVgrWWhnQkYrbnNmc1RMMFhLeVZlaXpZWEkrQXhFaE1ld1VPUEwwdy92?=
 =?utf-8?B?NlJORExva1pqSnFNZjNkZlBxelZFYlV6WGRScjhURjdEM1JaTytYVW56RGtE?=
 =?utf-8?B?SWwvNk1GMk9CNkZDYWFkS2R4TEFzbElHNzE1dDJCNjBtdWRiUlU2Nkl5VWV4?=
 =?utf-8?B?YlhOQUxFU29kc1dLRnNra2Mxb1dKbHRlcFE1QVB0K3hmUGhRellJVThqS2tG?=
 =?utf-8?B?SHJoZzM1ajJOb1VpZjlDWCt5WmVJVnozd2VveThYR0EyT3BsNnM5Y1pYTG9N?=
 =?utf-8?B?QUU3azQwcFpTRWdhWGxuekZOQzM1dWp2VHcrbXJnS3pDQWl5bG04Wk1lUW9I?=
 =?utf-8?B?Q2FPTVR3ZHFGSTlZMkhtdEJyemIyT0lkR1l5ZTJJc1VSZXd1cDNGV2xIMnlD?=
 =?utf-8?B?WWIzSG8vQXdpWUpNWTk0S0UrQmcrNExlS0RCY1FHaHV1TEFpTDVDOWNVdHlk?=
 =?utf-8?B?TlJvakhGMmEwZjFoRTc2ZllIVXhQTWg1ekNRUTY4UjQyRUpGbUt0UmRBRnpV?=
 =?utf-8?B?d01xSC9rSDVVZ05KcWttZDBxRSswV05keHVCUFdjU0dEd1NUTE43anVqUXNH?=
 =?utf-8?B?Z3U1U3ZtVFZsR3Byd0NtNUY4U2ExaDFzYkh3NnhZbVhrTnRYT3VuUmdHYmZU?=
 =?utf-8?B?Ly9acnAyN2pOb0JUQ2lUWTZBS2Uvbi9WZnlpTWxYalNsZUlBaUtwa0lwZ3Ax?=
 =?utf-8?B?MkxGVXV6cWRSd01qYmN4M2JFZTdFYmJRTklGUUtzNHZwOEFzeTZKYVk3THo3?=
 =?utf-8?B?aEhNekEvamRYN04rbFZhY3NCYWZOVVlvYUxzRmVDT2Z2bEJkaUkvNXZYR2ly?=
 =?utf-8?B?SFJMRGNZdWRBcVRRTmhkaVRwUTFNb0FRUkxmbkhqUjNGeHVta0I5aDNnOCtz?=
 =?utf-8?B?aFpPOUhsNGdWQk1kTklQTkNOdDZXcmxuY2pJaU9xMXpMNGhwb3R6RXVUaDc4?=
 =?utf-8?B?dXJpeG1BbU9WdjRsUVJHeSs1dHNsREluaTV6WXU0YWtVdWFRMFkwS1JqTlgr?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NNn8/c+8j/Lw9nr2nbaCAs3tMZX5xljZ63NhlTaJkA1q3VBxEcv+4dvPcyrxjiZF0/NTRPE28LSrS5KT3kgS6o1Qxou+GqktiM5FrZDB3brZV4kbwmtU1NZkGYEXCQl8T+Pt9zfkXUsaPJO9ARgNtSWbhjTY8x7Pde1CTGrP5BSy8Ron9Za28GGUh95gKFAXdJIlNSndu868GSy/ytDZz9WKPmSOkg+tB4ZK9Tc+t2BfE8gkeP6lzPwaCuP2HWko8aeqxrvraooWYX3cEXMCOSkWFJJL5AoCRpbPCc9i2CsCynMOwvb0OPDVOKv+Qvl4r7dmckHigwa1RaD7e9xYuY9dV/pomba0+tdIM7KLQxINn2k4KXia8t39s0Juqwf4zDP2ec3PdGf/a5Lpz9QYHsx76P0oT2nbTxxgdNPuskoDRFXKok/fOxXYb3aM2c6BH0NWS7D3fLxePgPZnp8DtK8OuhKgcwm0sV4LN7DYY4Sodt4y5VVEGLzL7HpCT9L/9lqnHxe9VzRl8m3g6BhI/bzmP4s4DPwK2DrM+l6quc07QLlUH8MEUZLseEBEXjZ8rv82JmXKnngzvApOEsgws4P5i7sff53Kreh+eXtmulY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d736fe95-5d56-4d96-e066-08dd4289fdb1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 06:30:59.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgdZznSezT1JPYM0i7I3FY9Mq/z50fmOzsWVyBJH47o1hnidvs4mXdg65YJ08vX7VE7Pcyq95E11HzUOpTzcVK5+wUZLDwZNe+HEEHYMyEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_02,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502010054
X-Proofpoint-ORIG-GUID: ONp6yuukLaH-hIPH58dqAQd_RRkHKk-i
X-Proofpoint-GUID: ONp6yuukLaH-hIPH58dqAQd_RRkHKk-i



On 30/01/25 7:31 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.178 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
No Problem seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>
> thanks,
> 
> greg k-h

Thanks,
Vijay
