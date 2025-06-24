Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43771ACEC7
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 02:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750733047; cv=fail; b=MfhLk6ZsbyN2UcsnROM7+zR5QM1dOp4BPW7cb7LqETmCcxFHGN6hmDZthk5qJTWlRkDBNMw2XIOtwOBdZ83jiBoPsEekOcUEsWmZdcqJUoOL1fRf5X2MUsqEeXr5IQ2UI3AmY9wKe9tKdGLpuPwhFZx172KYb8Gv3A6E8st6QV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750733047; c=relaxed/simple;
	bh=YGu4LSm26OxMjgdmnPEJPol+A1nTDxPgpr+0ruEgAa8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F0ry3rUVOTeW7xtY17RRpQDoqrhlG1v+RLEYcCqNBZcPj0d5iFxK08LNeLf8KQACXJs2Sr22e0iz9HuZBW3PeYWo7Ix3WQVpY8IbmAgn0HrqJLhF+r9sLxhVNdZK+zhQcoYr4pF4tKnBFGa4R0F/WAezXu5A+HP6DZp1pSuz8eQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OReduJoW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aiHJohVR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OReduJoW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aiHJohVR"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NLfeq2030690;
	Tue, 24 Jun 2025 02:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lFFaf+iie2FF5rQgZwu/Ny6jpy65tPyD2g0N1hUUfnI=; b=
	OReduJoWdrS4lpchaDJRB9hnYzvQQMMU4KDfFxzgUFe7GbS/vrAu7eIqo9Y35GO3
	hIqf0Avb0DqTqV0TfllA7cCuxUkUZKp6YYrX3LTzyG60xdnsqV0+8MJE5Xv1kkIj
	6Np4N9mpFtFIFn/rhm/1h9Lp53P6LafWLYNCCxG+K+jYXmDG7m4G43louplOlTW2
	zRLSDOyeqcY8c6Hr8pBHjGloJGqh5KyHQ3UR6Z9VCQjgadh00dwT5CzW77vzVSUH
	+GV+6yz/fd6YZI7AZVAAPo1I5RWEp1GkzqHXX/PiR1OEnRsKUPPL0/YpGVDoFXQ9
	T8UZVD9tBG1cxQtcZ5ANEQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8mv2y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 02:43:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55O2BMV6024338;
	Tue, 24 Jun 2025 02:43:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehkq2wex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 02:43:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kEa+j6fE+D7oFw9n9HQNNMGsZ8Wpju4h4Tr9zkNkMH1+mTxVsUVHcM8PEjfyD6mU1Pu8ds5yvOZnjBmROBElT4Orx6Y+cudEvxVCYwjxNkn+FJMqtriNft+kw3FZXGkgDl9FCq3Ksq0I0M3EpMk/sZNX1gviHhKz4UfevGSogSRiKILFCtYFsaXN6yMraReMjaL23pArsptDGjnHSI0GPTKa+YlM2HMivtNnxju0rAWza2aljlxH9cAlxw1FcYMhpEjFB3153zVvrVmnJryis4OnrMD8CYzTs5tE2eiQclyvMQA9SOLjpZS1nvsNYDnd4SXE0WTn0Yg7tamHcnlVeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFFaf+iie2FF5rQgZwu/Ny6jpy65tPyD2g0N1hUUfnI=;
 b=uKmOMaVqtJCrBJdwgYswtk7BAI76SmpJanPyUmm8Z4ykto7mDly4zFvyJXxeYiWJO1NxiZWm5oImMDR2+EAqFC6gRhAiaoTpxEXnnL4b4ZC+qwvf7RmZzq0amUg8mC6r+Cj0cld8tDJiaLiBZs/jiK+LhEV4P0Mt22Pftz580xizUXP6MLuspnpXMOoLhrPrzZ9NA5xQXXvvM4e82ByM39vKi7VYjDZf7LQNCP1ZUn2wwyPh5TsFKbgnvgYSkyqDqeu9FtvQuLrOgbC2MFacn7eEVqpXluBfJzKEAwvF8wNwylHTbDDGhiRY08vxKA5PdEgHr4eNQZvOZLJih7AwvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFFaf+iie2FF5rQgZwu/Ny6jpy65tPyD2g0N1hUUfnI=;
 b=aiHJohVReiip7xk5KhWRRKUgCtOfqGSzMjIDYU9x4hT3otWXrjoNFH6Hz17HDcuZ9YciAWOCr3hoH0KH/L0mdmPgeL32V2j4rZzciimyL29PeqL5EHhIL5pUM3/S4DY4G7YzbOCCRbm/ouYWTL+pY6CHleS9HwQCRgYvETYHRjU=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by PH8PR10MB6648.namprd10.prod.outlook.com (2603:10b6:510:220::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Tue, 24 Jun
 2025 02:43:43 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.8857.026; Tue, 24 Jun 2025
 02:43:43 +0000
Message-ID: <2cc18a65-9053-4517-95d0-32e6c0f6c625@oracle.com>
Date: Tue, 24 Jun 2025 08:13:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250623130611.896514667@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|PH8PR10MB6648:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ac8bcf-53df-444a-6d9d-08ddb2c8ef4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlpWYmRNZ09HSE1ucHVZc3ovK0pHQ3V5ZTZEZFptSWg5Rmt5eUswaWtFSmhD?=
 =?utf-8?B?TmRqV2xUekJ4dWljUGs5Z3ZXY0FlZ0tVRFpmbWJPMXdCWDc3UzY4VkhCeUQ4?=
 =?utf-8?B?dERZenY5UzkveWxJM0lFT0tKQ1FyK2ZWSU9OR0FaL0dIa0ZCSnlDcFFNSFVo?=
 =?utf-8?B?dGNiYkM3UXpPdFNjeWpQNC9pV3VMNFUvb292Q1VFYTV2N3R2M3B1NERKaGpw?=
 =?utf-8?B?S3pKUkNQMkNjUnpZUHFOWVQzTldwRVZoSEtzK1NsMjJJbGdZTUh1RUZWRk5h?=
 =?utf-8?B?bU5tUlZjZWdTc2lwb3R4Qlp5SkJKQlovOThETy9yQnNIUk9INVZCU2tlREZI?=
 =?utf-8?B?U0FKSENqQm91RmRwL3FZMERacDhKRzY3cW9BeXY0djNLZkpKSjZjd1JERVNl?=
 =?utf-8?B?ejVUbDYwWFpQZDJhcDl2M0ZJWmc0Q29uSm1YS0lkM1ZIUWZEOFRueGpxYmVT?=
 =?utf-8?B?YXlDMHhEQ2NBajhNVE81dDVBdGpFNnFwMGtxME5ZMEF4bmxsMG1UL1dORnd0?=
 =?utf-8?B?dVVMM1E2U1dUU3BuM01TTVdKWTE4eU1YTUpDMWpCMFFDU0c5OGpKNklqTGVj?=
 =?utf-8?B?NTQ2VEVocTR3ajh2QmtKaUpFZGVlVi9zNHRpRitsa3BJMWF2YmE0VEkxSVk2?=
 =?utf-8?B?ekV6Q1FCZ1JwSTZrZ3hWVC84UzdyakkrdTRXYVZKc2dWUktSRFRFOVo5NG44?=
 =?utf-8?B?WGxBTmhUc1hSWXBHK1ArS2d1clNtMlEzSThGL0V1aGtTT0FGdm1FTzRCdGhM?=
 =?utf-8?B?eEtBdEV2cmpVcjR5b25HK2hiSmo1Y2YwL3dOdzRON1dpKzFoTGhKRU9jcjll?=
 =?utf-8?B?dVdOT1JCM1ZxcEdmdER4V0pPVlFSaUh6UTdNcTNmSmpSTWtVamRxcEFvS1pB?=
 =?utf-8?B?NmlZaHNudTRXcGgxNEFlTDB6OTJhUWVvYjk4cjZLVUlobncvcUhLR3VHL3JO?=
 =?utf-8?B?bkNjS3NkaXpxdlNmRWowYnVEbjhLcUlmdG1kc1dVS2xENi8wZDloUG5mU3dV?=
 =?utf-8?B?RngwVjhQMkFid0tCbHZFbnl6dDB4Nm5KNmlTZ04yaWVQOFJyRjNkdmlralFW?=
 =?utf-8?B?R1hZRk0yTGxiNUdtOHRTM1VTdFRPYUlJMWtBMnM2R2hBNTlkcStWY0ZJL2Vv?=
 =?utf-8?B?QWh6OFZzZlJ4UUZudXBpUGFoNTlKeG9Qai9rSkFKaDI2TVZqNGc2S0Z0bHho?=
 =?utf-8?B?RUcyOWZQTmVuMm54UmxOVGdCVGRReVM5bnVrZ2cyTTg4UnQyM1hVNVdTSkdI?=
 =?utf-8?B?ZURKQkFCaWFrbzBZZTU3SjJoWVUxTWJ6aHJvMVEyQncvMG5RN1ZvTUZma2hZ?=
 =?utf-8?B?TjB1TzhEVndWVVlpcnIwSm52MG1oWmFwc051Z2ZBRDBMejdObUlpdHlhQ2h5?=
 =?utf-8?B?cnNmOWk4T3UzaFhCNmRLRmtETWZ6R3B3dXlIc09vVmNHZVdOME9tZnJRaEdF?=
 =?utf-8?B?c3hwcTNKaXZWcFUxSW56M0d2T25UMkdSWnQ2d1M1ZTVtcnNBbExaYXNpcEFC?=
 =?utf-8?B?aDIyS090TGx1MzlSZk1NcmJQaGZZSytBMTJpcTVndU5EVUJPMThzL08wQ0Nu?=
 =?utf-8?B?cFU3Ykt6d2lIYS9rVXFKdEZJUVRVZHRpOG0wS0FVMFZHL3lTeERmaTV2ak5C?=
 =?utf-8?B?cGlJV1pWTzIzS3gyQ0FaeUNIQzc0OThUUWpJUW5MRmZRRlNSZzJLZWgvSUJn?=
 =?utf-8?B?QlJqdHNsWUVQMVR3THZEQ1VKNCthZzB0aE5qbHFwL1hLZXh2bklJVlQwUFQ0?=
 =?utf-8?B?dWVwSUl6MUVKRVF6dDB0MGN6VGFoR3lWVGVtdHl3Q0k4bTFJaVJlOVdtaE5O?=
 =?utf-8?Q?WteJuL8Gmt9FrJ9m2jNpAv97snu1KzJMw2AEU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHBuMEtrdnc1akdVa2w0VmVnVG4yZktvZmlMMXppd0JLZnM0bkVtQm9zRVJy?=
 =?utf-8?B?VjJwL0YwclZjbmVYb2xwRy9hQUY1Zmxkak82MTc0ZWErWHVYNTRGc2VjSUt3?=
 =?utf-8?B?dEdaNzlsbGIwVEtqNlNKYU9nMVNJNkZoclU4cFAxaEU2YkFSVkhrM204SmU4?=
 =?utf-8?B?QzBpc0s1eFo1d1hQZDVVanJBa0pMMERTVzUvNzJ6Rkk3SXN2NUlEeWJWSEE1?=
 =?utf-8?B?Sm0rUThlUVA2emR2T1E5dnJSYUNZdFUwQVlCN0JVNVhFVXkwQ0tYTmphYUYw?=
 =?utf-8?B?ZW01NEZrZFcxWDB0UDdCRHZaanU0ZDJ2dDhpRUx4bForb1FYYW5hYUxPU2FQ?=
 =?utf-8?B?dUd5S2ZzRHg2TENZUlI3UWtRNWVzSUFXNUxEc1Bra0VRaHFEV1UxNXlncG5h?=
 =?utf-8?B?a0tZb3JJaUUxc2U3ZEdocjZKL1h5SGcwd2pkR3NQTy9VbE5Jc0xwcUJOQWU1?=
 =?utf-8?B?YTIzbjJsUkZydG9HZ0dRTnBRcGI5azZQRG50RjUwdkNsa05SUitvOE1DMW5s?=
 =?utf-8?B?VWRtUXBuT2Zjd2VvSk1YK3lhcWNrbGI4dGM1NmMrZ2pDeDRwMlZjZTdzc3lL?=
 =?utf-8?B?SkVwUFZNUy9vZmpRWGhjYU5iSHpkU01wWXRQQVFGSFBxNktYWTJpcHdjSERi?=
 =?utf-8?B?L3hjcE9sa3kzV2xTN3JPM2pwT3hwT3ExTnlTU3VWUXZIYm1VQjlLenpRSVFp?=
 =?utf-8?B?eDk0b2s2aXZLbmRsUzRBcDRzcnhjOFV4d2JRY2RSQkJsSTdjclcvUzBjcG02?=
 =?utf-8?B?Q2U0L1k4WEkrZU11blJhQnMyaDBQbjRKcG44NUUxdGtqSjM1NXM4QlhiUlF0?=
 =?utf-8?B?Mms5QmtmMDgyeVR6ZzhtQzFKSHVKNUYxdWhIL0xnanVmcEVBWHJyYUNIU0VB?=
 =?utf-8?B?WTN0TU8ydGJLWmt0eGZ2SGlWVEJDSjRDenN1K1RBN1FzUjdMbG5vR3BDQjFx?=
 =?utf-8?B?NzhlQno1MUNDbmJDT0FHME56RC9MWGxsY3hzS0pCYnBDS3RYR2dCWFVWV2FN?=
 =?utf-8?B?ckVZbkZ1cFJ4bnRteDNPam1nUFhadEhqZWUvQ2hha29udW9OMkNEcFB2QWtF?=
 =?utf-8?B?OXl6amE0cXk0MVUzNjZLYzAvNjZUREhCUXBnUlQrQS9Vd1hCYnRScXo4U1Vx?=
 =?utf-8?B?d21BU2c4Qk5IYkUvZ0cxbDJ1TE9zeU8vTUQ5Q2VyODIwYm5odkovbnJMMlZ1?=
 =?utf-8?B?dzd1RTV1MHVYOGlFdXptaUVOVG41TWNzM1pyNnMxRUtOZGExVkhVQkFzMytv?=
 =?utf-8?B?UHJJT2RXU3I3R1pnSU1FcHk5V0U0Z3FncXd5TktNankvejMrOERMZVlERzZS?=
 =?utf-8?B?ckF1azNRUkFqZjlqZVN6NG4wbHVwVVE3QUN3OTNXRUxZNEFmWUFuUGxvbFZ4?=
 =?utf-8?B?dXR3Z0NBbkpkV2JYSnZoWUdWZkNxaWNnQ1A3YTlsUTErT0VuSVAxRktMZzdN?=
 =?utf-8?B?RWhIbDBLbk5hRXVORWszVGVQVk9SRlB1aERGRjZqQTFhZXh0MURHSElhQ2NX?=
 =?utf-8?B?ckNrc09uMGh1MUlSVHYxUkpnVkNDbEhTODBKR2ZDaXRXSC9TMGpKSFVmeEZY?=
 =?utf-8?B?NGlHNWJBcEZVbit6QkZaWWE3OXpsK1pJczJGdUhOZjB2MlZYNUVkKzhxUzd3?=
 =?utf-8?B?RVl4VDM4cUxyWXVja3h2czZBckJ6RWkxSnlFNzBvSzFkWEhiNVV2YWR3dHdH?=
 =?utf-8?B?Uld1RHdNdUROc3pjWXQzOTJsM0xRbk5mVzJSUmZ5djdBZThrQTgrays4K3N4?=
 =?utf-8?B?RUtVTVVYRngrbXVsSDlCbDR0bG1MVmZxQTNLd2pxVk1CcUtMRDY4VkhNL3RC?=
 =?utf-8?B?NVZlUmF4ZEJWQmF1TFVFRURSTkdKM2xIWFVpbHVCYWQvWkk3bEQ1QXVEZHgz?=
 =?utf-8?B?SExxL1Nnc1JyczdlTzlwSlUxR0FLamkrNmJpK2FOV3JHVlM4aE1NOTdtWjA2?=
 =?utf-8?B?NnZ1R0lvbkQwelJyZ3VkU2ZPUytkNXp4R2ZtYnl0OVlRL0Z3MkNvdGJZZzFB?=
 =?utf-8?B?MkZsYWVjaEx2NUJWbzRvMnMydW5ISG55NVlJUmtXRWticTJJaUtHOW9ubTZ3?=
 =?utf-8?B?ZnVBNG02OGpNY3pUSlVEV2lnS2haRGFVOUgxYjN4MnE0SHUyOFliTHkwTHRX?=
 =?utf-8?B?ZXlPZUVXSVR3RlZLbVFFNFQvdlluMDFXemhEV05UcU5raC9vVzUwWUdHWWl2?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ITIcQMimvVbdUOQDiZNgsyNm1tJ5ZLwB0Lyz6GAFnk6GcYQkfWDmt6Up5Q5ShIrhZ6iim7edoXInSZ4f18tFAEKZ2bBrTSqwYIc94NGhyCeui2lkhvX1Y82ggRQxMe9YDAzrHqOHIJrCgNby6nkVmHNQYZHb+2iedIZYhegoVPlVHY/Jf1phNY3OMv0vp+j+YfiiqiIyJBi0YYxY9U871Tz5JMUaM/F6fFyPA74coydm+2EQSQL94zC0n+F3Ksp2HBpArL21Uifl18uv1o89DKvofcgv1qOzMPAVqoYLXvm4CRgrc/tQnLKuSWhdZ7Skvz0C797pAJ5po0QQ9DUroB/yu6OYxVe9kNv+O6uz0P/5sS0/GV2VLyZaE8hyPLMnxT7rVVO+ANKVFOzA+LhUTVNVeKym08KgOjKbwKgZUYPYqqIDXa1gK2d7pYbWm1NF4y1gk6vO8DXnaR3ZIR0YezHpI3/EX4IS+BXN91v6m+w7WBooTFq04JdPG1fkLdZeCov4tGKRV8uFEFINoJXFRAx8l1+9t5J9vKOlqRXaqHHR2ONVYzeQH0KIT6iYBj08zvDa3SBGLIjCNMwqH1zbpk07gqzfO7XGyVFqmnqb8Wk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ac8bcf-53df-444a-6d9d-08ddb2c8ef4f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 02:43:43.7149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51H9g642KS3to9BJpExiH0rDgVKM5JVeSkkT6TnUYUIgGIna5l7D9uWY8Ib67QcQvJQPolKWygiFt8obUP8akB3TMlG8+e48NIiSQw38adc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6648
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_01,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506240022
X-Authority-Analysis: v=2.4 cv=IcWHWXqa c=1 sm=1 tr=0 ts=685a10e4 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=JCbkYDn2s9hrs8J9IaYA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: WCesAQL5nJmzS6zSCpPRTvfClw2r4YjF
X-Proofpoint-GUID: WCesAQL5nJmzS6zSCpPRTvfClw2r4YjF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDAyMiBTYWx0ZWRfX6VNmNmQyansV sBdvf++JfqHzP483h0WSUMgbNwSav2J42jQuwbnFNLdA/ry/qI+yKaPF0TPE1CAf1G5TSljT0eO EJ5geb3rdNEkGN2OGQiUwK5OO8lzBhFTcW1/raC5ILat4YEywmvjwp3kiBL5xcxW+uCSiE3q6Ml
 vPhYnUPAKo//k0v/YBA1CRBECO1oitnM7KSxisiSYiZh/PtZ8MwENRolcX4BY8EZQAT/O06sxaI /+e2QbT1eYUN3oRoDtxaRCJRzPdZ/HncdRLs+nSwwn5lIAnZV9j9YSDabm839vtdOgUvTUALE6o b9jHCZ1HC1HRKsX1R9UDVgW7APNI5F/vmTty9ml9/BgO1I19GXXIT+XuFLZBHgo+wcdONJuBN2Q
 Xoe7nRXP6jElrMl65lg9DJuxCIwB70VBkPk9O5+mXXtCLD/CAo7BB/mMBifthjHVrpF30M0g



On 6/23/2025 6:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.295 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.295-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> Oci7wlG9Try5cW6Mi3FC_yBkazaBjR_SJ0ISRVbrMpExOb1_m8pENdTdKIFSIDvYkza0JCMRYtBv_NRWNJkol0plSg$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok
