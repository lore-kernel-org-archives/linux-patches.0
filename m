Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE0227450
	for <patches@lists.linux.dev>; Wed, 28 May 2025 04:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748404936; cv=fail; b=tM9c2wm+7X78tlznz58e7eG8vt9BjnHY49qMAgv/SoN/hM/jplmYQk1cGfNO3wxrJ/vCZjayx9k8VdtOicVhOQMQnIth136EveZGtL/avXZV8maCsHmvHM16Q7UO/kaKCyDLMExiEP5ZRDhl2FZgz379IWlaptKwcTHTewBJi84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748404936; c=relaxed/simple;
	bh=zTzbPMrDubV9vxv7MADelM52ZMoAuui+3aT51mbOMIA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P/rEiO+Hxcv5PoWgK23UAj44NFFMSuxqUGjRufF1UU95sUnvK4ndwIoBDCzQ+jmUe6EgFRAntS1kWZGhIg6HW2lt3LPUrnABClyctlbZCxHKz+1Mqx9pGV3gD+89TlE0FI8Fz+1q4kEYJYyPN454k3bBj/4BPwZXSQu78nmSpz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=psBiXhFQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mB8bwiqa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="psBiXhFQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mB8bwiqa"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1gepb011615;
	Wed, 28 May 2025 04:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RrkHLW5LcYmLZg2HbYHi/LkxMnaQFhBUsF7SLZQvH1w=; b=
	psBiXhFQaEUDbJ27pCXhZmW5L5QybFcQorkSFNlqBwOBkk2C+vX42kpaanwrwNxq
	ehaFM63xgL/FG1TwsM17dg3UzaC9sxyU1hXt6hO5zyN96U32UPLbWLcqXMv5eLx9
	mIJUxwlx6gKHP38uD8ZIiIKVNnLhVAnkXREvS/oE/4oyQ6f2AsCRLriBJkdU4V6d
	8WKL66zS9ibyPSt3yFJX4neNnZLIJqau37THnIaUJAO5TKei8zReDuZ7BSRJlDYj
	Z1XgY2WtXXLEHW9/RweNayfU1UEiWgEVIaWydl9p13K+CooVaix3Us8AEJYDmjVO
	18aWaAU0QxY1Wpf1kraczw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v3pd4t73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 04:02:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54S2uUlA035717;
	Wed, 28 May 2025 04:02:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46u4javwy9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 04:02:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfS4rhc3yu64LmJoJsPibLcrmnwWqm8ujZHVqDOOXXVcmSyXgQyQAeYhnutXGj1tdceLqvCC3nf9qX4OYUiuxReRteEf8WabYGAa+1RlewLEW9/en35kzf72Ve0eV+6GWTTEOb0mOOQzaFrG/uqfsACoApWs0Hs8xZDJ/e41LaeBMvkDOFmZkCGvYompFsegn64IdUUM+Kftxzueg4eDCvtmSwx6k7asCteB9SDxtXJgXj7T1TvUYV7ZHvyD3eRggkvvdNf0lZZ1j6GAp63mkYdI7sfN2lrg54Qi2OXrGNCt+vijRL4rkrRTLyZOLGk4bdumWB/OshEqmMn+QCv1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrkHLW5LcYmLZg2HbYHi/LkxMnaQFhBUsF7SLZQvH1w=;
 b=bMCyoEGGk8BvpMmE29UfdF3hZpRKHpdIJC0C+H6ffcLGTCwKriqD3xH1xQ4JJBIvqHAeymDwbozTpY40AlFGBbte/vWClU3CFgNnM601Q0+q6NvC25zVPIVaHkPyqqH9i525eYLqRPZoUfmlVK/wMQHOQ7K3cyHoZFxa4KVTLhuIE1PuLrsrIHM2gfkvCm/LTH16Il4YJDf/+iDK2emodRhjj4rjx/S8ga/QEtdAmUJSuCYSh6z/N6BArEwBO7toYB1MEBDeQWW60GyuipS76O4dEnkuaiZPWJWqch4k6Z3elfX05go9wbSMMX718GmNVzPq9v5y9tPLzbnRENkWFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrkHLW5LcYmLZg2HbYHi/LkxMnaQFhBUsF7SLZQvH1w=;
 b=mB8bwiqamsvp80K8mx4R7gI0xPaSPw8vKUf1GAvhtb8LOtPOHAK+PF9iUGxgIelcaRMONmj05qU4fpUbHMx+VE2qbbxaAjYcPfjcbIjxeCLvtt9S0xe1D4edxp18RcwU+SAiNZdGQJCFd+6GTCic5ZivG5PEozoGtsKAHpR1SbI=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by LV3PR10MB8036.namprd10.prod.outlook.com (2603:10b6:408:28c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.32; Wed, 28 May
 2025 04:02:00 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8746.035; Wed, 28 May 2025
 04:02:00 +0000
Message-ID: <ec85a299-e371-40c1-8597-2660a34728bb@oracle.com>
Date: Wed, 28 May 2025 09:31:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250527162445.028718347@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|LV3PR10MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 10969d38-fede-48a1-62ef-08dd9d9c657a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0JzTnhiOHQ1ZTNVYVhHaTVDdWw3RTVOM3YwS0FTSHZTUVUvM3ZQd01UZTl6?=
 =?utf-8?B?dGpjZG9kR0NtNVpCQTlRZHMwQmQySnJhUkVTQkhiQTBpcjU5aUhaZ2VkazJ3?=
 =?utf-8?B?SFExZzMxcm0rOEVmVU44cTBUMDluY1VIL1o5VkVjVGlaS284cDJPNklvc3pK?=
 =?utf-8?B?aktKTTFpN0ZSZDNXMGFGaGp0YnFuOXZoMHZxUHBuWHd1cXd5dVlPT0hyN3lV?=
 =?utf-8?B?d1VOMXpNZlAxOU5PUjZ5VU4rSEozTGw2dlBjVS93dHVoRk5jL2xxYmRqdDlZ?=
 =?utf-8?B?WHh4Ty9SUkVWb3M5em1WUklTSVI0VTFiWElmYk1xVGxOTURrcDRGQkIrUE45?=
 =?utf-8?B?UFdDbXl5UXJJRkZVYmUxRkZtMkt1TjNXUEpqNjMwd1A5aVFPYmFyOFNXb3l0?=
 =?utf-8?B?eWJXbHBQOFFZOEYwd3pubE5xMVR1VER2UnFkU1pUNmo0WkZ2azZ0cjJIWks3?=
 =?utf-8?B?WWpMYlF1VG9Ec2ZpZE10VWdLd2NSZ0EvQWJDVi95YVZielJtbUNtVFJBVHZB?=
 =?utf-8?B?UW9ORWttb1hxekJ1VldBUk1XR3g3bUpqeUlsMnVGbkJUYzVmRUw5Rng2TFpH?=
 =?utf-8?B?bTVJTEtBeU9EK3ZEb3N4MGs4MEdLUUxBRTRuUnc4N002Y01kVmpXWUxuTlcw?=
 =?utf-8?B?R3N0RDA3djkwd1M5QXBJSk1KSjBONTdteWVnL09ZVWxaNTQydmlwTU9EOS9i?=
 =?utf-8?B?bG1DS2V0emRlUjNVWGkyd3laU3JKREZHczk0STFoQi95MDRkay8zblczQTVJ?=
 =?utf-8?B?ZDhXb3ZyQWkwcHNCYlZMRzlZSi9tVVljUlEvNFhSQjl2S2EzcjUvTUNZZUVY?=
 =?utf-8?B?SkcvckJCTWszblNVN2ZUckZCdVNBNWVKTGlHRGxBNGh4Wk1JQWxYRG1IQ2tC?=
 =?utf-8?B?emRkYWZYL0VvYXZRNFljbTVHQlJYOWl0dWYxOVozZmtXbmQvdUZyTVJGT3FM?=
 =?utf-8?B?MXVSclpZYzJLSEZuN0pSbUc3YXR6MHlMWHZGVk13QlZla2JibHZrRnhYQlhm?=
 =?utf-8?B?SjZ5RUc0M1JQNlB4MTdSUEZWc1VpeHFUdHRkMjdEYWh6NUZQU3UrSnNUM2Vl?=
 =?utf-8?B?ZEsybWZHaGlvNkd3NFErMjNWaGxTV1B5SzhueEpRdHZKc01reVQ1NFlqSC92?=
 =?utf-8?B?WHliVklYZ1FQOEgvb3hoZlpoaDVwclRCdGNTdHNIMnhGQWtMcXBEaElRWFh0?=
 =?utf-8?B?ViszZENkSTQzQllYaHJha3pINUlPWTdEUTZNRkZPSkptaVlLaTR6Y24ydzRi?=
 =?utf-8?B?a0V5WEdiWS8zUHpWam9jT2hBMmNIdU1mcFV4U3BRK2lVNnV5eXI3WGtqWjhS?=
 =?utf-8?B?M083OTNYMWk0aHhQSHZiREg4d3UwdS8yR3draUhVWHJFY3VDREJjTkFwa0ov?=
 =?utf-8?B?Rlk1RGJ6QURzd0Y4b3ExcmovYnExM3hVNjFxWWV4UC9TRkxhSVFNZm8vL3J5?=
 =?utf-8?B?OEp3ZjZ3OTJkYkhqVDh0d1NnWmYyRFloWFZWdEFrOEQ3RVFNSmZIMHB5ZHFI?=
 =?utf-8?B?Wm5LMGhQbWYzanZkWFhtN29pM0REdVAwNlVqN3NiT0xqd0V3S0tWckgraEMx?=
 =?utf-8?B?T3hRc2plUUJSVEcwU0gwWUo5bGtCcUNLQVozVmpBSng3dndTR2ROOGJSYjVy?=
 =?utf-8?B?RWlGcW5oaGhIQjMxLzZuQ0ZET3lzWXcybUVRSExESXJYeEZyVEo2dmllYmRS?=
 =?utf-8?B?VWJ2MG9RTi9kOXVPdmhvTkUzQzVUa1pMdkk0bVNjZzU3blBONDBlUnpJY3B6?=
 =?utf-8?B?T1UySDlzZlRDQy96eGhkVkNrVWo2czN2K2VTRVFaMk5yT2NmOVAwb1hNT1lw?=
 =?utf-8?B?SjZQVkx6OUUzbnkzRWUwOVlnZ3ZnRVNjSERpUXY0Mk5USVp6UmppQWlFcE16?=
 =?utf-8?B?VHMyZU1aUnp0aUxFS2R0QXF2ejdmUk5WZDZYYlc0ckZ5cTVuMm12d01RcWIw?=
 =?utf-8?Q?GjHMoaxJQ7g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnJJYmFNQTdFSVpIRlFDRVpmUHlKM0Z3b1Y4cWsvbGdNcXBLWXllWTJkNXZm?=
 =?utf-8?B?MzVHbHlqeTgrNnhxWkRKbXRuUU43RVlmZHdGTWxzVjk1MTIwbEo1NlZPOEdx?=
 =?utf-8?B?eWRlZHUyUUhpKytwcHpqcWd4dUhpcUJ2OTFaTGp0aEhZeTJuS2FseHQ5T25E?=
 =?utf-8?B?L0tKcmJnSTNhRXg1eG0xVWc2STNmOG9ueXFEdzQ0RnppTFlPWmRLNFRkVEhD?=
 =?utf-8?B?Y0VZSDdzcGhNa3FKeW0yUmN6SWVhVENGd0x0cjdoV1Z0Y3FhL0VMOERIY3lF?=
 =?utf-8?B?Tmxpano0YlRpUzNHQ1BQa0s2cjVta1RhTFpwbE5tK1pSSlF2bHUyYThYV1dr?=
 =?utf-8?B?L1ZxbkovK3AyRWx5Skh6RkZ0ZnMzVnVYczErd1YzODh3MkpJMlpxNFNna2VP?=
 =?utf-8?B?cmdDR1I4QVJHK3c0ekpFNGwvb2VnVzQ4bjZJU2UxZTdEQmpTaHNLOW9scDRp?=
 =?utf-8?B?QzRXSSttRytpUzBqZEJycnMrSGNzTkNxOVhzUDVoZ2dOcE9LcEMrZjlqcUdJ?=
 =?utf-8?B?UGxMei9ic1lmcld1QlZYSnNCOHlhM3FDQ1d5cmFiRkM2ZmpTY1FELzNMYjM3?=
 =?utf-8?B?bGFERTRxd1RRN1J6MmgxSTJ5RnU4SEFYV1NGaitZVGVBK2RXNU9YbHpKb1VG?=
 =?utf-8?B?MnZxQWNoVWxjUitmV1lNQndRbVVqYThUTDVkeTY2c1pLMzcyaFA5SVNod0Qv?=
 =?utf-8?B?VjNrODljbkJXNzRmK2dtczRidXhncnY2eUJJbXl4TjJUeVdUNDFMT096a1Ur?=
 =?utf-8?B?V1RIRGdmcm4vclEyeUpUcTA4dDlRTmlQV1doU2dxNkdjemJsekdvdG5lMHE3?=
 =?utf-8?B?V1NEVktIemdpLzZuT1BQbUdVcW1RVnYrS0pBaXFyVlJ2VWJ6Nm9NYW9KcnFx?=
 =?utf-8?B?V0FBbldLMHM3c0sxemNrOWkwc0tWUXhFWHBiN3phM3ltMldFcUdvWVdWNnNU?=
 =?utf-8?B?am0reFdqbERjbXNuNTQ4YU9KSGUydFdicm12dVVMdkFTNlNWK0U0aUJYN1I4?=
 =?utf-8?B?dlR1ZU15VXh0NENidmNoVEZDQWE3aGJsVnZjN1IrYng4bEtVTzJmUFlLV2VY?=
 =?utf-8?B?bXllM0Ntd3pVRWY3YVlXUXVLUDBpamsxS09ZWjhrNXhydkFKU0EvalJZR1VE?=
 =?utf-8?B?UmdoakFrbmNwaEdhSXZwbnRDNm5VRnRqdWNYVjYvZzVtV2ErUDZLWE1vWVln?=
 =?utf-8?B?ZUpCVDBSUTlsaEdycEw4SzVQR1ZqUElXTWRCeS9ueTFIVVRlRHB0UHVEbkMr?=
 =?utf-8?B?OVJFR0g0U0E3N3NhWC9FRk1mQkVJOTZWMm5HUE9DODJQNzNVRUJkcDNtekZQ?=
 =?utf-8?B?SnB4WFhNTWR1VVBYQjVqcmd3bGM4VEVzbU5mb0plNTZWQzhsb3E2L1M2RmE5?=
 =?utf-8?B?WWtKVW1hbm5ucDUxclVZOStiSTR6V3lLUm9xeHZFOE9UVGlFMitsRjE1R0hB?=
 =?utf-8?B?T3Vqb3lQSEF5K3owako4K2hpS09KM0g5Y2hVbkVCK0tqb2hDQnRMY1FwK0l5?=
 =?utf-8?B?YlQ3Yjc2Q0VLRGhKNXpQWU5JZEdZQ0ovZUd2eHc3bXZvdzNQMlJhMCtFd1h4?=
 =?utf-8?B?UU5RcE9GSnFZQnNhSjN2M21FNjVob2htNzR6Q01Ka241NUNheTAyWkdIQ3p5?=
 =?utf-8?B?Y3h2ZExoeEdFM2RRdFkzQTF2NzVPUkhONXB4c0tlbmZ1bkwzQk5tR3o3ZFk0?=
 =?utf-8?B?YUNuSFpiVFpRMk03ZXVhUUlOTHJicndpUHdqMHVZYW1yZDZNNERJOEQyRUtU?=
 =?utf-8?B?UDkvL21GVklDTjk4QTNIanpnNU5jWWVGNGRGK1ptTHNNaFppYUljVnZ6TTRM?=
 =?utf-8?B?ZWFmK2NNYjVRVXR5LzNQY2xkK3FUVmFiaXJvVEo5eGJybTIzZ1IrZnNBc0Fm?=
 =?utf-8?B?WWVocXMzUzR0N05sL3RXTURGWndNeFFFTzVmVW1hRE14VzRnbHV2ZzdabEdV?=
 =?utf-8?B?VEp4SThRcC9XQ2FuMjJsdS9qeE1VMERlaVpuRXMvYkFNMVd6STc1ZE9VdCtp?=
 =?utf-8?B?Z2x1cTVMWmpMeGd6dDJGckgxNkc5OXllamJhMU4xZlVHZHI1L3VjSUpCUEg1?=
 =?utf-8?B?NFp3THA5cEszU2xZNjNjSXJ1UVRFYTBGSVQzMUhPcTNrdllPRTBoVXRKcVNP?=
 =?utf-8?B?NzNGWGRvL1VrVVRVYUkwbjhnMmo1SUFoRGplblkrSWNPNDd6bUdJd0Jyb00y?=
 =?utf-8?Q?nIRYQ4wROZ+TqQRVgxmq6Ec=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3xmptb/PFJuCKevAZbfX10H71iGBxFuz9kGc2+BwhTsXy6kQyzEQMiGgyxqS4JBcEhHkAKL47F2TNGnEenb/bbCDhE2BaRGGH1dAOtD/QBwZu2SwSfQSEvo68KvMVj3ElYHd1O09S2YORAe8VPJoSyvSeV3c3VqACwsv9i8wrKHMoof1nOAC81B6FKkd+9XY22GVh1qJMSSunXwqAxyuEuQ+bRN2qhW1n7l5EOLMMqh4C0xMGOeaGa62iEzkxnw1yXCV/LipMmxV3bj1HQ0XoM+3pz/vFS5t0QTIZiak7C8SLOhuL3WOSD0niA3VhDauTWLgDK2i5xdqHbhvGJatOzCEub43sGec830LPSR4WAArUMHrKJsE3KdM4ovAckbRDyRX7bAtvMJN/U8odwckx2CPUfwvGifIsH4CklbY4C6TV7OopZPvCgEFPYzaIZ0m2wUlfLuqSrGqmfiGAY3msI/BUuLRaI6W3FYS9FRloQ4qT2G5aVgl57FZ8QwHrUV4UUfE6eJ/GeV+e04LboJ62P4Kl/ZswyWlMuF/GFdT0/kHHHBL6MioyIMZNhSPqQCpBM/94QSxJQN/i+e6swKF803rAwY62yXS6OeIrpwTgJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10969d38-fede-48a1-62ef-08dd9d9c657a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 04:02:00.2982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7nXINZxb2qvfpDoS1Qpdhmmm9I2NDxmAazWXvWJ3NMFCVXdrm1MSbUAgRo7gyI0CegcJcjkvGEHX4g1P86UfU4ADBhZgFS/0LZNGSP5aEJRTKLC40f1GYF8zEppKN5Vv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8036
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_02,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505280034
X-Proofpoint-ORIG-GUID: vhbIbn-o0QBmVUl1PbSOg7dnAYanwia3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAzNCBTYWx0ZWRfX7u6jWV0hKM+r KHXxNzP3Gm5IcD+bALqxgjxVyTcW27VtmtA87yIH+1gwVgrAC5YNA1H1s+wJs3YlwWDEjGsvg1a qvuMUrVYc6wnR/aCAR9fxRKviNtyog53Z7tm9dOKwVougFlY94VTCcok/SaRSKDIadzz5UppDtR
 GzYPdfNjn4zZ1ltXrc1KP3V+psIDa/Q+kdTbqbTriRbNlknLP6gQ/D6EPFeOFNWr9W2gPiCDjX8 eMsbJjGeR2zXt/YYlbGAZmw7RYd6cCDcN178eC5MeoJtMPQ99Vda5whV3hmh18MQper9OWBwYjz t4/dobrdojJpErM+WIV3RuRJKYNdQ2iYxLDP+bZxAFmejFmM30VRDW3EC+82iDvBU0/liRda0uL
 c6dD0mTBXIuxHDqfzsp6Lrzycv2PDR3mrsFgS+60EVJIzVqd6Utq5saLXi/qiG1CeB4z73iZ
X-Authority-Analysis: v=2.4 cv=UZNRSLSN c=1 sm=1 tr=0 ts=68368abc cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=5E2gbQE8QDOJjfjLMUMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: vhbIbn-o0QBmVUl1PbSOg7dnAYanwia3

Hi Greg,

On 27/05/25 21:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
