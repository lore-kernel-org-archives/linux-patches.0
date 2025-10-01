Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC18C26F2BF
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 10:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759314314; cv=fail; b=rzPAQqkUh/yQkXgfYxjkIGet0o0gU2jxF2kLDvK1S1yyNqXEyL/xdjgPCIfYDz8czb+ofHRxFVzEwsYLQ53zX/a2OooR1euRXAzPSf8CiIf3E4667tXebD3cHQtcOF2W7gFeTF6prHRGa0K6AcnIprc4QKriNb3qVl2j9YiJ46U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759314314; c=relaxed/simple;
	bh=GCJ2XITB1qNaq0GOqSppZZgiNhtn01w7gP8PsPETnkY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a5ahyudZEIEnuQpF+RTLpGeA9bk9WrwTtrXnDPNOd1+ZhwRBlLdbPOD0Wb4HTeSGBnHfDKdn/zRC40WATwPmA7fvxfffTPF8X6znzvn50h9wRflOk7wlkK8pKpo7YSmbxS0uUUWphCM1tnN3rjhB/XsC2KSxIqNhGe+WtGI5dSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fF6D6QJP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XVkFqLA5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fF6D6QJP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XVkFqLA5"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5917NHXA032028;
	Wed, 1 Oct 2025 10:24:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YrMYdawFetbs9GaXrVscxjnPe3jOuXzul/C0Dkn61to=; b=
	fF6D6QJPcuGngNQJAdJH4IzGeBx3mCj0UnkV0LItZUUr7XOkC9x/fBCK29JwYHKa
	9AjdvGfpbylL/P2gFjoA8fpJQ9+kXbV4o9Gq+AHeln0C2JjtqbCWTxT66F+v/au7
	8PemUib1PQ3EZSSsINOo6P+NPEF09uCjwGhACecPJ0zc6au2NBfS5Hr6UljmaxDJ
	pPEBHbTtIR3OViyA83aTv34ahX0TJ4/q32E9uDKtTGrQp7Uc3LNPNpMuXOCuXZx5
	axPAP3s9qFWBHcujQFVApEyhxZQ+IvqN6IVuH8brZK6L1Gj+8Kx2rtg9pm2Y9S7s
	wPSowFUBBVGK4RqHpFM+pw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gmf1s5w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 10:24:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5919ppsT036099;
	Wed, 1 Oct 2025 10:24:53 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012054.outbound.protection.outlook.com [52.101.43.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c993wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 10:24:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VXCj5zCxZE5yWUbN8+3gdzhbewzVT/X5RhBjMHEluYDbsRPD5xtU9m6Xag7HkT0LEk1WpTTL92/5h/d81NvL/hH95dtek9+0FtzmrJJwqlfZzv/HJ7hWZduNiid6ac4T5Dny93LoH4t090oh8khoPjJ72zgYs1UdXUNh13A/k2UulvhqwwB91sEoSAnIdD3qTIGyGgt0vTbIZonEL7N8SMypoLcIuHL6O7xkxD6/QjDYJe4Lyh5vwb7P8tTNvI/KqFkJuLVPKWvXSxjDshdygxjSt2/8PvNKaUvcctExXnIuYkPOh8+VjsHJL75nAgTrD2c0ORmMmEcav02JKwTHzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrMYdawFetbs9GaXrVscxjnPe3jOuXzul/C0Dkn61to=;
 b=jTJM7+IMcZbRuvZJ+5qVcOBLSnr3WTHjZkqlICcB+bVEKjmtvUxj0PRxiYLNFSUXyqatSSTUBfQl6H4MnXOaQXepw7eG+tPJReTaJTNYtonJq9RSzQxCeqXescLclA1BjGHLvWldVOXQlJrefWGni+fo2uQJ/8gynTVwDv9ldakqzAhyQBqK40qsSWqgSpRVIRrx8CwGWM3GF/sSCmr2X/1dnjnMOg+HNCjDZs6+CNWT5WhgaPFBkn1Y3Le84xOkkFHVNtEwH/RcJoAWFeI71Ca+p7EABPeBozJsnSlm0+94cNQVRlu4l96YtF2e95mI5ISqOrA3ciwG8kQcoAvndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrMYdawFetbs9GaXrVscxjnPe3jOuXzul/C0Dkn61to=;
 b=XVkFqLA5d8TmjhUdStLgITWGOVK4NXfDgw8bKpsUo2yhlnhdn4o4GVdqWJVKSetJeDwjySV7OOwbTUrTuNWLH6SH1VQSuek3lIUPuZ7pui0ghTBT9Nry5aohtmqbLTrfJvKzjHZtaTlzfvVeX0epr1t2158xHnTpTVsdauI5VuU=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by DS0PR10MB6775.namprd10.prod.outlook.com (2603:10b6:8:13f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 10:24:50 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 10:24:50 +0000
Message-ID: <c2943ed5-d739-4dbe-b231-ec10d4e169c5@oracle.com>
Date: Wed, 1 Oct 2025 15:54:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org
References: <20250930143827.587035735@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0306.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::11) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|DS0PR10MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: 526ac3d7-fb3b-4083-44a5-08de00d4c063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlZTUDFwYmROaGsyYnlpUGdwanNWTHRlZVUxVUFQRU9VR21lK0lCR0pYcVpL?=
 =?utf-8?B?bUVscUpsNlliODd6MGZYRndwMGUxZHluWEN0UXRyM3prUGpNL3RTcDQwQ2lZ?=
 =?utf-8?B?NVhlQ1NnUGZBZG5MbHlYam1nRVB4WWxocUxtdEUrVktUVlh3T3JaT1hDeXI1?=
 =?utf-8?B?K2hBOWgwY1BnZEZzaElvSVRxYTFRVG1DVFBYK3hBeWFmQWhlOHRlOHdzYk01?=
 =?utf-8?B?em5MRmJCby9mb2R5WnhCYUFzakl3Y3RacmRicXUxOS85YVZSOEpUamdJc0dI?=
 =?utf-8?B?eDVxc3d1Q1FlUTRzUU9YK3JKSDZSQlY1YStlTnhXMjR4QTJwbFp5OG5SREJw?=
 =?utf-8?B?dGlod1lzZFNTTEQxN2dlRlBpcWNMOTZpYUdjMGpadHZuOERFWWhtYjE0aWUr?=
 =?utf-8?B?S1pYdlNINTl2MHBPWjhwTUVJcnIvVWNCWFJ6eW0rUStzRU1jOUFGMXVxR1Zj?=
 =?utf-8?B?Z0lrcDdBWHhGT0YvRTFWSTFJM2FsSWJKM0cramh4U1NjaUYybUV3SlZldEVj?=
 =?utf-8?B?eGtWc3Ixb09rTDhQZVRWT2hRTzZPcGRwenhPVnlXYjJXRE1YVzh2d2lBbHJo?=
 =?utf-8?B?VXdKWXJ3YXpaUllDemdEVHhUbU9OdXdJS215dDBWSDJ2MGRiTnNPczFUVkEv?=
 =?utf-8?B?NlZjV0dTSXIySFBiZWhjWGhTVFVvUGV1cG04UlRNaWNZUjZzRGJnOHZMY0Vv?=
 =?utf-8?B?bjByS0h6azBhTWRidUllREh4dU5Lcmh3ZTdVV2YwUkdGclZhd05IZkVSYXcz?=
 =?utf-8?B?dy9OVXp2Z2xkdG1wMVE5VXM0VGpZbEZZMW1jU21mMEVqZVFjRE9PSWxZYW9H?=
 =?utf-8?B?UEdZbjNIK1Ric21ob0t5K0V4K0JPSVJJR1ltbzlZSlBwd1o1WlAvZkZPTGhk?=
 =?utf-8?B?RUc3RHJLRE84VXNXd01MUk8wYmVqbmV0VElnY1g3bzFJcUo1SG9UUHo2dkJ1?=
 =?utf-8?B?Q2F5THRqQWdzcmlOaU1ma3E1VlAydy91YWtkSDFic2xWSEJnemprOGRiK1ow?=
 =?utf-8?B?bjJwMkhOMVlDOFpvVnIzTzhIeDlGQUN0Um5QYnBYZkU4NGI3UENBZStMU2tr?=
 =?utf-8?B?Q2tCTkJCTjhicUVabmJhdEFOaUJzMDZncFJuTFNsR3ZEUmVjUEd2YzlENXdE?=
 =?utf-8?B?S1FkS0RuSU5hMElUanFxWnJiR00rdzNYS1E1MUw3aWdtem4vdGlpZmhjUTJj?=
 =?utf-8?B?TTBVUVBQTFJSa1NRWnN4bWFUdk5DMUxPdkhRUmpMR1Q2MXVkNXczVzVxTUNU?=
 =?utf-8?B?TU5FU3Q2OXZ3MWdDNXYvT3k0ckhZbFBLdHhVaHJzNW90VUEra3MvWlRITU51?=
 =?utf-8?B?ZVdCMHVQNTlhNWo2c1QxZEloZVFEbjhUZlA1L2NDTjlVV1J6UUxwd09kci9m?=
 =?utf-8?B?b1lGdFhQdUJWV3JmZzQ0NGJVT1c2dExKS1Ivem5PUlNNMms3MStIRjVEN2xu?=
 =?utf-8?B?dVozNEhUMHdkcmNUUjIzNkFsTWlINGh3Rll5cTVYVWFhbmxiOHlpNDNXS0s3?=
 =?utf-8?B?UXVwVHVWYUlqNGVGd29sN0M4SVRsSjRPSFNZb3NxdlB4Nk1LM1Z0d3dsV2hj?=
 =?utf-8?B?WWF4UDN4SllUM1U4ZGhodW9QSC92NVhkakhGNVhGRThGKzl2SHpaTnM4ZjF6?=
 =?utf-8?B?dlBjQWlJYjBYSEZXMGJCY0oyczVLelgzWjcxazRRUDlKajZ3UjZnSi9CeitE?=
 =?utf-8?B?d25ENmIwOTZKY0JIVTI4aUo1a1FvUUk4YjA2RFpGRm1CeWhHYTlMNDdUNExD?=
 =?utf-8?B?THRnZmt4NXN3SWYvYkRSbTB6a0VLa1llaHFjaE5PVVRIK3VSNmlUOFJzdUhZ?=
 =?utf-8?B?cE12V0ZRUFM2a0srQlZUUXV1VWY5MWdlbi9qM280RlNhSGI0Tk11RU9jTU1T?=
 =?utf-8?B?U0VSQXk4Y0tIUVFrWnY0K1IwQ1RRakFYaCtjUTdWQlNjNGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUdYOWh6NXNVbmVkeHJQT1M4Z1R2VWxxUzQ3MFhXeUxHUy9SWW41WWsxamNE?=
 =?utf-8?B?Ry9QaHJkUUJnMUcrQXhxRUlLcWQzUEkzdlg2aS9oOXlzSnhCU05TN0w5d3V2?=
 =?utf-8?B?NndyekloNS9pZjlJdDFqSHdSRHdkaGo5cEd4OE00WlZJeHVPdzlnQmpCNEhy?=
 =?utf-8?B?U2ptMlh2dXBVdkF6blE2UEZjN3RYY2ZPMzdZRFJMS0lyNHNrbVc5czRPZ3M0?=
 =?utf-8?B?MjdLR29GTi9va2NjSWhsNDhFekNJWXR5Mml3dVFrazZHNXZwOW1SSUVvcEVH?=
 =?utf-8?B?MnVQRDFiRE9tQUFWcE8yWTVuRjlVS3dESmN1ZW1RcFdxZFEzYjNhbE9GWml3?=
 =?utf-8?B?b0Uyb0k5SXNwMmFodHhJRXUyb0ZDRGJhUU9nQnVhR0JVUjNhNjZIb2IrbEVl?=
 =?utf-8?B?TVFrbEk3L2J1dVRydjFlZXE4bjRla3FYTmRCVmU0NnJIWEEyRXROUVVtNVdv?=
 =?utf-8?B?a2I3QWd5cm5jSHcrYS8zeXFwa1JlaFNkbE5YRzF5YXJyT3dGQm5weGdQM1dT?=
 =?utf-8?B?bS9vdXduUUo3ck9QMGtYWmdzNG8rNDhVQ3VSRlNNNTZqMWlvWWI4Um1zb1lh?=
 =?utf-8?B?MEkwUjdKbWVBSlA5RUg0V3YxT1BCV2hsRThkU29PSXhVYVNnNHR3eVVPYzVx?=
 =?utf-8?B?QUVEem9SSEY2U3ByMmpISS9qbHhycHZvRUR2U0VqOEZwNVdxK1RxQU1GZUVB?=
 =?utf-8?B?Wkt3T3BXS0Qzcnprd20xaE5kSVYrTW42WXl5YnFnemYvUHV1SXFkVDJESmhX?=
 =?utf-8?B?dS90YTg1elBtYi9JSjMxQ1RVWHNnclF1RGZSRnhtZi91RjBiRWFWcXlNRVBU?=
 =?utf-8?B?emFMUStMWjFKcENNbWZjZ1lMYkVlNGowN2JjRjRjWnhIbmRyMXJPZmhSQW9x?=
 =?utf-8?B?bXltWG8zM1dBWUMzUTZUbUE2TTJ5cE1DSXljU3BQOUtJam0vVmEvMFM0Ky9s?=
 =?utf-8?B?TndrMS9VQ3kxUWlOS0JvUW11cStsVWFKYlZVd0pFWVlIS3RyZFNMclpLYkJX?=
 =?utf-8?B?MmZBNktrem8zMkFSQk5MemdwazlHVkF5b016Z3ZBR3NTVkVscmNick12TjJN?=
 =?utf-8?B?NWM3VDBxM1FESTBKcFk5QmtnTmRwa08zeVNxNGQ2TmQ2WnRXakI0YXE3ZVRX?=
 =?utf-8?B?Y25tOVFROE9Qamtzb3RYL2N0aUFvQzJyMGs2WkRMcmVUUGdUa0tQRE8wVWJN?=
 =?utf-8?B?a3pwVzE0MWpqaDBoeS9xdkFaWFEveWJTdXhyekwzN0hWZCsydjVFVDdlSTdv?=
 =?utf-8?B?UUtKMjFzOGcyak14QkRCbmoxV0dtblFTcFVaYXdlazNPV3hrRW1ZemErOC85?=
 =?utf-8?B?SThUUjJWVXhZZVNRMlFYSW5ZQTFaRHZXNEN3Q1NqOW5SR25UYlVudnVvZDJ6?=
 =?utf-8?B?YWQwMDBIS0YvaHU5NW5SamRiNUQ1RkRvOE5LZWhVNTFQbkNRUkVMa3M4RWF2?=
 =?utf-8?B?TWM2SjdleFlLeDFaWUtyT0lhOWNLWWsyT0ZucHVibks2Y2hLUlYvS3VyWkxw?=
 =?utf-8?B?TkNJR2JqUGxqWGorZXZZU2ZQSWVEakIyZUZ4OG1obDFlNk1TUmwxYlBEcUgx?=
 =?utf-8?B?bkNWbDRjck94RktmMEx1eGhFR014b0V6U1BEL0FhWjdncVVxZkcvbndWZU1J?=
 =?utf-8?B?VENtZW5LWUVLcW5jU3FBb2RLdDBxeVE0cmNuVWRmVlpyRXp4dlRXQmtTWnZS?=
 =?utf-8?B?aFBMMjI0MG5NckZrdW9IanlTUExMK2E1WVlOMkx5RXJlblJDZHloMHNwM2x5?=
 =?utf-8?B?b0pVWFN1ZytOeDgrYnZFbU5MdVNyellLMzJGOU9NYndNSC9MUmZpUVB6QWd3?=
 =?utf-8?B?N1RsaG9sYkUyaG9MWURhQTgzbzNtNWtZd0VUczc2VUlJOU1QVVdTN0x3c3JE?=
 =?utf-8?B?cng5ZVVSMlRrTVRaY3hoVUhKdzlLdEFHbHNFZno3QlJkUFZMbnNPUHdaN1Y4?=
 =?utf-8?B?MUpsMzhqQlVOL3BRckhyOEdlN2JwNUJibnA3S0hUUzVHOW03b0JRc0VqbEhw?=
 =?utf-8?B?TFZJalBCUmNXMVo5L3lBZ0ZLd3NnanZzOG0rZVBDVVV4djFWVkJKazZWUDc0?=
 =?utf-8?B?Rnc4cHdGdm1xemhQMnNGYWtkNGtmRmo2T3ltaUNtZnl4RlFMVDFac2lZcVRP?=
 =?utf-8?B?SENoT0hTdiszNXdYWDdZVmkwMTFMWkJaR1JaRmltaDJzOWMrYzcvZ0VCTWZG?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sRbYYz1GHLkFcew5ChFKvWf8OKirI07ZDyazAW90eHfpYztHHAWalcx94xSxvjk91qMKY6dxST2vVFEmwTjx1A0X67uZNOrxbY90AY+aKwUlBqVhLF650G4MFbUiMbKSuMm9XgjWth29y1SO+offE6yHX5YVS64EQ17NkBCgK+wW/MXbvw5fTLsdbN6evIyPKsjQ/b2IjsXZ6J9TvV61r0GNVuRgpejZVh0hPE5EdHwnZ4zuc2rQ2OohcfGxMDaLAAJeUuWNcbuSlcywBS8OB/t6Z7lynsWuQLYsK5JXl5BBA0hmTXIGB541tWOt3BGzOvA7RHUSigh6Qw5rYM7cXghmri+wzK1c7G2hyPKdGnYXWplfhSN2Bb//5j7sObbf89xcDmUGYwOGWXN/VXyi65YmQJc2mDcNK+M7eKt/XVvioJXuw0WiMf7QGmFHU7EMxCcwhrgtj5TvqgSrk/P4J6gM/ahVHMH16uUsjfG2LYuy2HjPBSwDdvKqxBv58s4/033/PeTmHH8jlj1HejXoMWeINJbis04IPlGwAjgyAMEhJfUcTYeSooSPg4ozM0jg/2wBPvIqNF3Mie8sJsTt/4JU+1Osopu3VcEJa2qCKso=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526ac3d7-fb3b-4083-44a5-08de00d4c063
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 10:24:50.2603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjbr/wIrRg+J36HrzilbI10D4Asog+FX5aKKE5+PWwrZvPqrtOPxwM7GMljX4S+HhNaisL3JlPaNrqzpaI282UflMzZq+SaNGM9mTSmf3qM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6775
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510010088
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2NyBTYWx0ZWRfXw6fG0/nPhNm8
 S3A1YN6NX4cv+d0GcH6o8dpRqfIOuYzB7ZaN/5Dpsf1ahyWuqkMMjkZd/48DV9f9i88q/UgxqiG
 CKkhwwX1xgAsulfgx0sRbkk+0DWt24gbH7qTNFQYyTQVtDyFmH5YHx8swIZdCDDr5ZrjbTUgscV
 KGe6keRw84HOVAYrAEtDa7N06/xBPUbxcm0t7mFiUcupsi1izYwizOVkMpBcBkuIL470NWaFAZU
 e1xjQ3wU2MBl2kdOq8rhg4pYh05novnOw2lVpeLjQoCfxNUWJO383Jnyl9fLndqbbj8JsjeVWQ0
 E3OdqVD2ANVOAUymtacWL+LN7Zk2/V4gH05UY604j6/SCEB6jcXdneEu6ExLuGxfvvpkF4Zgh6I
 bD8IY/me6j+V1RDATaHh8PszDr2jjA==
X-Authority-Analysis: v=2.4 cv=K/cv3iWI c=1 sm=1 tr=0 ts=68dd0176 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=xsW0gKulYEkIjypDXGAA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: UGN-dOU1_iJiShq-6VTZcrrBTVOsSzGO
X-Proofpoint-ORIG-GUID: UGN-dOU1_iJiShq-6VTZcrrBTVOsSzGO



On 30/09/25 8:15 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.194 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.194-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>>
> thanks,
> 
> greg k-h

