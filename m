Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F784A32
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 08:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761638439; cv=fail; b=KoBQXb6OBB98888oQlaHgRVxRVeJq5AoYIjVLts0Sdu6H1ZeAxXSM5yNoOnAqM5S6MKbBfHgSW7VWF8BFJiIzioVzIIDmEYfSxZ67FRgPUVGMILWYxoQTjKN12f/PZ/HuBEhMvdyexfRH53IqpuypTORGEpzznOX9LujsI3QYdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761638439; c=relaxed/simple;
	bh=kiyuB0MjfPG3SrD5BcMOSqjtGnNYqah/yrc/GJCpGH8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nmUyZQyE4RM9Cv3MVR9FmeC5kzaBHpnQETpv7ne7on1uI1QEeANTsgpWRgOgVXANKEgsApYeWrzbeRA0rPVfglxb20wMqAu4CIdJy3yMEYt4HjarmgNDYSTZ98lS3aNyXySSXqaiAFOji8bSjBZV96yXioVNpQWxWCepUi5Txm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZABSPQC3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aI62S9qf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZABSPQC3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aI62S9qf"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5NFu2031227;
	Tue, 28 Oct 2025 08:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ueinKP+e1Xa5zBhWbEZfHx/8YB4dBb3Tn7POvVxpDyg=; b=
	ZABSPQC3E4SOx2zn4a/svEWc+2YGW+jL2GPMyA9K+qhU2P4lkaKIpUrppsM41Tnq
	Bq8G+wJ6tpTQGOSvXisDe7PdnRg1MImolOKrwveL6QEf2Upzl59McNmrcz7mamqk
	ZBYOSRJY27QR75TzsesInXvAsvDlR+bJjoijVzVyJAIWtxZWw0hO7qvioS6eArCg
	OA88S3dy3hzFp3KVo3SXmVbv1OfMvGnOMet0F8xn9tUMoxn5RQ91AA/CoqsSb1KX
	F2A7tCU/M1F/wHN7PcrlkWeU60ElRpOm2kzZJapdC3zn301B9Op7mCGv6IEc6H8i
	8JFQwIeIXDpPe9Zl6BoxTg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a2357jv16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 08:00:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59S63nnZ037454;
	Tue, 28 Oct 2025 08:00:07 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011003.outbound.protection.outlook.com [40.93.194.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n07uuxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 08:00:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLeWTb+c66WfiukefFlcCAEP/3motwWI8dnEfboHnh6ZPySNrYneBvcko8Py3ZupAi8wMHn2wEwOFc4pcinNKIoGwMzOM7GihFLY8BfK5yiHghYirksYEcp0nO/jiVyC+Frkgldpk34UJ/xSMQF6uZY0i65Sgl+mKeIEgjumrfhfP+lEd498vZS+2vEwj7rL9Jy7NQgFyu6dG3qXgTqHzPNHHQey+7DK2eAviV3Z5pJuCCIb+i9slZsCE8xXmJT5yv7w9J3csNHTr6JxuFh8vZLFDL55HJK2WHEynHbYbrE/HeQJ4JHQvE61euLgebsBYza49kUfnHjL2RvLGkrbjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueinKP+e1Xa5zBhWbEZfHx/8YB4dBb3Tn7POvVxpDyg=;
 b=XkfIrj3Noke3gJXI191HOmtRaF62jcmsPkh0itFhcoLR401fgyvEdlZljryi9uEr571E3DCgla1fcwnI64Dw4Kdr7ulpes/72SwwzgrBfF33pYxkZT36Wj4xNOgk0b0XoZr4+6nJWCt0kkRwYhjXIk24VrR6y3FOmG3xAJGChiMXHMESi/IxACzYotawVsNhzy5i5adSuMZ0GbBSvhreyo1a/wsjZO6n7FZHAqecD7pTeOU+rc5hD8c5WXXMJqp4kPH6AumPATLuEHFESES+2UuhicmuXraqH/5ldhbU/teYO4428keiX7nmjHAhYEPk/tZNWPhLlI+naTPUF/0cYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ueinKP+e1Xa5zBhWbEZfHx/8YB4dBb3Tn7POvVxpDyg=;
 b=aI62S9qf34i8V0SGHtwafnmCWcdydKGGmnGFMm6363VWaJGubaC55q1JgNEA8fR0we+uaAz+m24i8ROoCLAGo9/bzZ3b1e+mrqN/eoKLNPWZbGd2pkt8uR5bto3JGGfYe4DLk46n3yqwMJZm0/bJ+eNKV/8TiK8ukk2p50gs2lo=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by PH0PR10MB4695.namprd10.prod.outlook.com (2603:10b6:510:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 08:00:03 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 08:00:03 +0000
Message-ID: <449f32e8-bfab-45f3-be84-5b995e9f8f89@oracle.com>
Date: Tue, 28 Oct 2025 13:29:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251027183453.919157109@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0327.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::11) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|PH0PR10MB4695:EE_
X-MS-Office365-Filtering-Correlation-Id: cbe4ffe4-7725-4afc-dec9-08de15f8002f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEVwZk84WWNXNG9pZjZBOXptRlF6U0RzNWNpTkdtajRySTVEemN3d1lmMElS?=
 =?utf-8?B?a1g2cFFxdTdYMDAzSEVRTHVtWmFGKzYzOElsaFh3eWp3b3RmS3ppRGpFdXRN?=
 =?utf-8?B?UUxlN0V6dW9NL2NpeStPRGYvQU9NaGExc2s2cXZzc1RtUmIzR2NDOEdjMXk2?=
 =?utf-8?B?UTdTS3lVdVJSVkx0V1RsLy9KWjRPSG5saWZGUTNIbmgzSFlyaGVxVWtZcXhh?=
 =?utf-8?B?bGF5SWFJVmdUOUtVOTdabktVcE9xd3dibnM4bW14MG84OWlZT2xGa1J2VzZY?=
 =?utf-8?B?N0YrVVVLTGhRSXBDSVdEc2RIa2xmbmlRaC9oY3RGNEdnZmUxaHlxbGdQVDdC?=
 =?utf-8?B?Z2M5SGRGVllaS3NaM2tRaHJ4ZWdJK2krV3NnZ0ZLV0c2bHRqTmVMTHIvV3kz?=
 =?utf-8?B?amYvZHM0cEZZTys4eDlVdzd0eXlRc3ozRnhnRHpremozTE1ISlcrTHpuK3lH?=
 =?utf-8?B?TnExNDdWbytDYjZwbWZYdjdHcS9sOEFsWFdaYlZDUHBIeTdibTlLMkJjU21u?=
 =?utf-8?B?eFQ4SjNvaVkvaFJ4azlmcHI4bktySjdoZWs5ZEU5eGM3dFZkOVF4c09yNFpD?=
 =?utf-8?B?cDlUeXdPYk95QUFPd1Vnd21RMUkyVjhGRGh1L1RVY05QL2lKdzdMVWo5NkVH?=
 =?utf-8?B?cGZ0b0FmaU9mdXUxQ0FkcWQ3UEFqTzdRbUpjRy9acDFFTmdlR1l5K3hIZ2Vi?=
 =?utf-8?B?ZTZGQ3M2cWMxR3d1ZFFaUEMrVFFoRVZOQlpBL0I0MEpRcllSMFpxeHg2RzZl?=
 =?utf-8?B?VFZ2ZkJEVXh4S1RhdW1ub2VXUVUvbTV1T2x1bmE3M2xYVmlJS3RhSk1oSnJD?=
 =?utf-8?B?cnNhVkNXdkVpRnVYakM4T2JxRk8rK1F6YTRVUVVRY0FQTkF3dVdTd3NmVlhr?=
 =?utf-8?B?VTJ3aGZaWWVNZWVGT0lPUXgwbndhS0pJbDFybkRxaGJTOWlZcDl1N3A4Lyta?=
 =?utf-8?B?MVhMbloxS2FCLzQ3QXdTUE1vdm10NzFkdU5maTNWZ1pQR05pK2oyT1ViK0R6?=
 =?utf-8?B?OXp3OHQzZ2o5RnIvb3lZaml0T0xxaHV6OVN1TlNkbVJYTUpQMHR3ZmMxeEVs?=
 =?utf-8?B?YnhOWldHY1BXRXBQYkduYk5WUE90TXVGSTJTWlVpZDN4bmJXMlhsTWhITGla?=
 =?utf-8?B?ejE0VTZrRitaMG9HTjFpZkU4VmRQVFRxK0lOd2RxZW1ENVBBbEFtb3JxRkxZ?=
 =?utf-8?B?MFN5S1l6MjVrdGNidzVWcXdBQ1orcG02QzBZZTZLaGhkbVI4KzdsYmdZeSs1?=
 =?utf-8?B?UnFreFVhNUZzd2dOTWUrMVZ4Y3FaOHFCSEV3Z0VodXlJMy92djRJbG00OUVm?=
 =?utf-8?B?L1ljM2JzSU93S2Y3TEZNODJWY3ZJaUJhSFpiZGpTcENweWdLNytmaFNWR0o2?=
 =?utf-8?B?dm96YWFnU3hYdHJaWUlVV3lNQ3diekJxWVRlcGFlSmNiN0xoMWxQTHlOZktU?=
 =?utf-8?B?QmQxMk5DbUQ0UDh6a1BWZVJQTjBJSThlcVoyMEdMWGdVVEFob29Pa3hLalZa?=
 =?utf-8?B?azRZOVRHcTE0MHVrdjhPRFM0b2JoU1lHUzJ4ekJkVlhpZHN2WUlwa3hEV3c0?=
 =?utf-8?B?dEJxdkFManRNNjZxV3E5b1hLanExaFhpb2JhVE52M2pjTDB1N29USndDcWZ5?=
 =?utf-8?B?S2pzVUNQeXpTaVhrNUNPcHQ4NEg5UzVCaG44Z29qMFNQeVQyQ2tIeW9sS0Ju?=
 =?utf-8?B?M3RzSytDc012UFNLQlVCQWlpQkxXM3JxcklrcXJMVE9BdVR1ejQ3a1c2OHNo?=
 =?utf-8?B?dEZ0dUt5b1h3RWxEeHM5Vm53S1ZKT3g5Yk0xL290SS9tb1lBd0FZMGxXWGJr?=
 =?utf-8?B?d0JFdlZvZnU0aGo0VkFra1hzOTBoRW5kdDRrKzgvR01hMmdrMDh1RWE1SWFh?=
 =?utf-8?B?V0lYNGFmZktGRytJTkIvZTRVSVJBejA4WXZncUZUSzBqSHVLelNldnZJY3pJ?=
 =?utf-8?Q?wOLoCJhTrKhjU597RWyl+HfG11x1gega?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHFxNTk0cTc0cDdvZTlReFd0aVlnL3R0NnBpa1h4RkM4Rm9wNHhxb3QzYkty?=
 =?utf-8?B?blc5YU1iaVljcU82NVJTUnNKcnNYWFZoN0dicWJvRFRSUFMwTnV5bzRSUWF4?=
 =?utf-8?B?bHROd2lBcGc1WjRyRXV1WWRpWXRaT0pkQVZsZy9OOEJJQlp5WHN2dzJJanlJ?=
 =?utf-8?B?WXkvai9Ea2FVSnY1VVVQMTJaampFTmpYMTlHeVdtU2E0UGl4MU4wem1XSUp1?=
 =?utf-8?B?eW1IRXJDTGZQcWs1ZC9uTjBTREt3TkMyR084bWs3RWwwS2x0RUx4UC9FK28x?=
 =?utf-8?B?Sk9hZDBCSUlNQmM1ZHpDZW1HUlQ1cUcvUCtyUXhmc2JieklnenYzcjBlUjRH?=
 =?utf-8?B?cGkrWW9PMmNoMDVKWXB5QUhhMDF2NUVjdWpZUXpYeFcvc2NTTmNwMG1WaUxL?=
 =?utf-8?B?Y2tnNXBtSDRzbXVUR3ZwMFpGc2dSYmRTM0lTUmZhVFBwWW1QR0h2MGt0Y1NI?=
 =?utf-8?B?bVR5S29TSCtaZEIxWHF3ZXNXdi85WkNtV29oYXgxcmJuM1VmUVJVdUxoMnVI?=
 =?utf-8?B?ZWhLRVJoalYrbjNITG1uZDU2TUNZZHZWOHJOY2hLdEhZMmNoVWxLSit2aTdo?=
 =?utf-8?B?Q0xzYU9XS3laVU5pS2dXU1VWaGIvNWIrS1EvYUQ5d3RtRmRQYlZESTlrRzEv?=
 =?utf-8?B?aXVwRk9JV2gwTjY2aEVBNlBXM1FmNTNaUzVjNUdmekRnR2JRNTEybStIdk5t?=
 =?utf-8?B?Y25oOElpS3dGK3YrWWZtenlyZWR5eGdaRC9ON1RXelRNdkRTTTlkY0hlUkk1?=
 =?utf-8?B?b3l0ODEyL3dFZUVTU2NIYzArYlMvSHd6L0FZT2FKVjE3YzVNTVUvNUdQV3Fy?=
 =?utf-8?B?NENHdjdnR1lndGF2ZjhOeitXNmRKdGxqTEt2cCs3L3R6VnNLSEFlYjBVaGd2?=
 =?utf-8?B?bmRIN2ZtUTZkVVJFbzJuZjdsRGMycWZPYy9WSndOUmJTc2Z4U1FIckJoR0Ro?=
 =?utf-8?B?K2FkdllHSTFnMlVxRDV4NVliNXlTYUhxZ1V4UFRhOWVaVFZMVjRmSFJGVXBh?=
 =?utf-8?B?UGFUWjExWDdaa3ZudTVOdUQzVzJMaEVzUzVzL3BNdzcxYnJGZkxyUGI0NVdN?=
 =?utf-8?B?L1FrZ2dSL0ExMVRhTVdsU0JQK1hORHJtNWNHM0M0U3BkWjBxekk0bGwrckhC?=
 =?utf-8?B?a08zVWhJV0hUc0V5cHNQWFF3WUdwMWt6Z1hTQklLU1BybEg5TGgyYXpZUXpT?=
 =?utf-8?B?UmVSZDNjWENIN0NjU2lpbkdBWmZYY3VWTVFsRkdGNmFWbk9QV1dYU2p6RjJX?=
 =?utf-8?B?WFBteWx6QmRrQ2RRdHlNSzlBSm0vRVhGQmhKdjBFV0thUlo0VUlnT3dhZStq?=
 =?utf-8?B?OE5hdVhReHd5eG5xTXdILzFsNU9MSFNPek5WT1BjQ1poc085cFA0aXloR2x2?=
 =?utf-8?B?S3cyL2ZmY0NHYVlPMnNaSDEvbUhyYjc4czN6d3gxajZldW5XUEd4UGoyTjlS?=
 =?utf-8?B?U3NFcEVqU1ppYm9Qd25LUjREVEt0TTJwQnRCRDhsZ1ZFMXl0U2xMaE5ITVdL?=
 =?utf-8?B?K2wrblViMlcweW1uMUphbURkVGhkcTQzbUtGVkRZdVg2YmhkTFlDN0duVlJz?=
 =?utf-8?B?d3JvN0FMa20xSnZTYXp3UVAzZnJ3endncHZxaVVOL1BqUWJYNFFGMm1ESnVR?=
 =?utf-8?B?c2NyWWs3NmtET1lYT210L282b1pGYTJXNXUzSmR4b0ZuWjZrL3RmL1BURTN6?=
 =?utf-8?B?Sk5UKy9vK29TQk1jUktSakUyaGIyeTFVYXVTcUNTc1VaTFFmNTZOZEo4SjBn?=
 =?utf-8?B?ZUVFdWlZTnJoUHFUZy9zYjIxOGFTa3JNZU52NExBVXpyc1RkVjdBYUU4UzJS?=
 =?utf-8?B?dlpIT3hIR3VsQU5PQWY5RlVXQ2hYS2RZQWg5QW5hVFNUVzNQRlIvOHJOR2Zn?=
 =?utf-8?B?bjNuaG5Ja3J2VHhIMzZQb3R1SFNWaWhIOGZjZjlmaDQ4T21oWkVEMVhxM0pQ?=
 =?utf-8?B?MjhwVCtFSkhZKzJsU1JhSTlMTTBoUGtIdEYvTkdqbkJEeVV2VGxreFFEdUhJ?=
 =?utf-8?B?N0F2eldib0FOaHI4TUJuN2E1Y2FrdDA0TS9aT2dmSkFEWjFKWTU3WEFtS1Qv?=
 =?utf-8?B?UFJKUEdydkEzZjJXd0JvRXYxc1A0Uy9MR0V2NnNUTnVjTU5uWDgxVE5qWVdI?=
 =?utf-8?B?WS84aDd5cDRsYjBxeWs1ZmlLaC8rRHJRYkllK2lzVzE4ekswRnZXTjBlcmtv?=
 =?utf-8?Q?C9QYzvnrt/3EsHhziVQGVyY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ETzuYa5IZOKCBAE9+Q/TJqkPTj2sdoio9VOkz13zDGNNmqiTMQHuNMiJS6zlsrtB1HB/YQMj7altVlbG/yFiXtUUOURIu/V53C5oQd9Ki/YciGO+lbmqesW3/JQ4cMZo3QYyc9oLv1w/zmqEgN3jGH5yvlOu2V/J/LUpcBCAg5YpKVTyA0+g/hE3X+qNaGsWBWo/ANAZQ9Crry1DA3sax976uXvYHpEjTPs1HjKtVbZ7+92UZ86Cofs0hfOmL/cJM4rpV0SnuclPB58SMrv09+sn4PrVo/NE2KBnmElK9d5YJZ3CXH4RGsuTCI4PzjVESsF6Cu6nENpxsOsb9xh3ykGx59nBAjIzwP/8xqxUABfML2oNYVflPx9sLBOke4nN6XOlRuW+/+xVdr5Ry+Daf8lUviimbjOv0sBfXYg00OSsSbRGiVJVEzBDbMSSfi+KPzQCbHJkZL3fggOqisuwp+t6tnNORoHogKk04eA3hgsQuUhHsTS3ik0EXuEtIG0H1ejL6W8V/gAhHvVWf4jfb8kgAg6lYpQA4dULYZ7+KCZ9v3BRFAg7chD0JsxuKWm76x2W+gEajZmd71podfpyqWRfgcKqO6If9ilFe7Jj3Hs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe4ffe4-7725-4afc-dec9-08de15f8002f
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 08:00:03.5336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSfsNOx/F39lV9uysuoQSrQSm+O9hJj0uz1FdkInXsAzglPRGWbAUkB9DLm90u/efTzP56+WXMoWgvNtWc3IZNT2PaH1n9jpUCMMizI6OvuYDoDSNl/3vpOMkl847K2r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280067
X-Authority-Analysis: v=2.4 cv=Bt2QAIX5 c=1 sm=1 tr=0 ts=69007808 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-GUID: G5Yhy_L2xVymDVdyYWT8bk6gtfqVFNBu
X-Proofpoint-ORIG-GUID: G5Yhy_L2xVymDVdyYWT8bk6gtfqVFNBu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1NCBTYWx0ZWRfX+kL8MLjDIttP
 ZhVSuFr5hZLduuqTaQ6z/HeQnwPwlPcFdnXVrH6762ov8wotfqRVIk0hYK7jYHt2iw1Kbf0RYXs
 URp+x8UWr1seGHrRMWXx8m3Ukm9RXqMHyLh3xEl3H62wCrQLV+TEeOZgZuXMgK6PtzdvUNSXWOQ
 0vu2oJCyw8K2kDhMfVQxsQM/AgPSViTu4kP7y1PXclvJWjVssZ3QCyRbyD1TytPOuqYG2u8yQcK
 uUxgaTFljMxtGChNPGCM2+y01QAf4uw5lJTRRCGdk9v9qAyZ8rm5KahcX9Dx9kIr06YspPLf5fA
 A1QW5brMii6kACkTKDt3f7Tgs+2Z2hF6XTKE+uwFxfQ0fMoy/8KMF4B7ae4gLvFadKDOErb4SRk
 zF/BsumPNhBb15Ry6sP5nKEs+6zFzg==

Hi Greg,

On 28/10/25 00:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
