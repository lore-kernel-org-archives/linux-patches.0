Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438EA2FE56C
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 10:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764586527; cv=fail; b=mHtcQ78NlOloBFY39RubFDXmVev4xFmIjqyHVcbQXDhkArRZ9ESPjh0fBfEYUb3nr96k8oLQeB8MNTFVmZ4P6S23VCVxV9JONAG2nOdYkV89ZR7qRESYROjzcmXztHCicLpekNmP+wurMvUGhK5INgj151Jjhu98R5b7xvt/g4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764586527; c=relaxed/simple;
	bh=U5S6LKpxRsvXgqx7sR3ixYA5EDl0LZ+IO52NEr6DgZc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nrWxyvKVVL5Wa42qRVUg0J3mGKWNOrjU0N0tQ/gbmSNtb3CKGyUnw5VngevwGWvcG7btsReu3/zUQFJ7P5wzgdNliZqffFdQEiWdSf4+CQErGCCvYMB7GSrmYjKJfcKTN6G1lpgH3KSnv9goyx1GNU+T3tz/PGZpynltDvzgZLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=exMgoilO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OulNa9O6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="exMgoilO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OulNa9O6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B17gxq81545849;
	Mon, 1 Dec 2025 10:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gOps2IBtLzwMRAnM7jlwCaMB1IBhopyPwe6NcjJwtgQ=; b=
	exMgoilOstY09pQAJj5CZmL5yeihSx3/NAFjI/qqDPj061vGa4zLJMRQQwW4t9fu
	2LTGbgxS616XE56h4EurPdAxo0ZGYIyG3yas0Hfg6ggbjvP2Rfar9MkMWZ9HZsQL
	IsCqF/YptDknbHk/fixdTp+Zm9GDKVrJ4H7usVtT24EMx+RolBT6htOZZzy/s6tO
	aQXzsfJfB2RhJ3xZVw1KwfWOhVKndXmf/st7+8zjMsICTxyVrDxmS/NJ9HIACeJZ
	AOiNkePnXWU2vyvUFkqVXeWXhEFpjsXuthGk99MxULmOyMZEuFEyTSq6e3BICADv
	BO3PXc4RU0lcnFiQdKegJg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as6v389yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 10:54:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B19rLfL028885;
	Mon, 1 Dec 2025 10:54:54 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010047.outbound.protection.outlook.com [52.101.201.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq97uudq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 10:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vJ8k6YUfnqbhh210UfJBh81cmRC5FTBaN0WN7KXrPSvWNB9RHe9n6Mw+4DKqTHBKecZhOm871LIyovGgqwxYUnHuWhI8jOjMv4zSg3qK7I8s89xfDxbxuaxUxZZUgp9TuEEtqb98kfiQWwbdT8vqfFLTDaHCim01JO7tvJzo6asJpmYDeizQER43xnV+wyheh550MsbI1qF5PrNn45ms4uuvHLsN25fDyuCiuaWqkfvbreBPAf92dlGAand7MsWMxX8+kY0vXAMz/pOgnQtkKB0BonFaAcBoPOy80NIfDcsdP4W17uECQQTMDvhwcv+mZzUOTeD3VUreL3c/Sd6X0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOps2IBtLzwMRAnM7jlwCaMB1IBhopyPwe6NcjJwtgQ=;
 b=UgAG4+zQwYrGY+574G9LiJ0mIwTeoG1zOzinrtLwQy02u4fPtCnOUEguqinovhbb71V9pnd9btaRCGJPeA21Eyb6vVt+HGXktSAQy1YKiFv3IiOdYmrowpf0QKIYMKdMi6EJ3uTNU04g5Icydy9R1oulV8Ud95vOFdb8orKyQdWqZIeSJSLA0EQm/gMp7p4j8Z0g6wKimOX9l7EHBSNDKsSMPn1wluViq4gtXQNozcldkL+Iotih4FdZ9xyaNeee4jzSuoRM446XdBCo/CaqdngbEvRQJmNmW8A7n72mEg8/YYQaw4T+XMNmNLWY0VJqnU5wWkrENScUTnKoDFwZaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOps2IBtLzwMRAnM7jlwCaMB1IBhopyPwe6NcjJwtgQ=;
 b=OulNa9O61+jJOVKV1j8bHAmYBWt+B9qEsOk7lCPtygAxAMqD2UlvMLCJAT9WHTySaVcV8go+Q3+J95YKRRwXr6MnDx+94FGy1PuseQbSyW8lMSW35Rh3vKMwWPWYlKyaEBHQaL/w1JXDaZydd5NMxXPxEjTC47x5E94hfMBIpoU=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by CH0PR10MB4923.namprd10.prod.outlook.com (2603:10b6:610:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 10:54:50 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 10:54:50 +0000
Message-ID: <684e6f8e-fc90-47ef-9fcf-8b73052caa4b@oracle.com>
Date: Mon, 1 Dec 2025 16:24:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/112] 6.12.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251127144032.705323598@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::13) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|CH0PR10MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b240ca2-a6b9-459d-b083-08de30c80d06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NU5hSHNCYm4rTXhkaG5xR1d6clpoaVZGbExZU1dsM0hJSTA4elgzc3MvYk1C?=
 =?utf-8?B?and5VXF3L0RiQVVGalIxY05CRlZiZkhMMjJRY00vbDIzZTcwUlB0aFlHSVN6?=
 =?utf-8?B?Z3FiUGRNdlNzSmtqeVZwN1lXTjNLNG01bm5nZnRIR2hxbWJYeXNCWXdLSkRO?=
 =?utf-8?B?VVNhTmcyV0lxRmhHdTNDUDVEbzBReGVidVVUSDdibEpiRTlKZWNNbWhGR0pZ?=
 =?utf-8?B?cWwybUxaWTdGRjU1Vk5aam1aN0xkQ3VXTEozZ3RuSFpvOUNLWlVpaCtJakJ6?=
 =?utf-8?B?bnVkMFBMa3o0T3ZPTFpRTVpTeUJkTXBOUlNJMFBqZ3hHWkkzaHIzOTFzWUd3?=
 =?utf-8?B?OWY4SGJHNmJEcjVqZHlXS0I4bU95d2tRMFlxcHFPbTZybElmclJkc2tRSnB4?=
 =?utf-8?B?UjVac0N6U3RNNDZOcDljZjNrYmNCWkVxaFpmSzhwWEdLc1ZGU1lpa1UvQjFL?=
 =?utf-8?B?QmhuWFpzOUdiZ0E1ajcvNzhobmc5UnBZR0lENUFZdGEzWXlVenptclhQMzFk?=
 =?utf-8?B?a2F3MUNOdllPNHRJVzFQQnc3bCsvMzNHTm00SEJ0dkZXTmUvZDcyZ0FqbjNX?=
 =?utf-8?B?ODd0Z1dMdkxKZjlPQ2w2MnRvamtsenl2MXNrNnA2RUErMUJNMDhDUktxeWZx?=
 =?utf-8?B?a2l3MFNmNzkvKzUyVnJnVWF6bDNpRU5sc1FUelU3VkVOWmVpZlJYNWNFZG1B?=
 =?utf-8?B?ekpXRDgxajgzNWNmSTNHTERpSm5RcmI0MHBSUU5FYUJKTlppYmlvTVVxdGVi?=
 =?utf-8?B?cnJjV096c1ZDTWFHSnFRQnp6TTludVIzMjNWL0djeVNNTEtaNlN4RVl0aHha?=
 =?utf-8?B?UHJFa0FSVTNsVDhjSmt3ekQ4VGZ0Vkk2MGpXbStaYWpZSmxheVFHOEpkWGQw?=
 =?utf-8?B?TFdWWk9LL2xHYnZha3NML1Fod2JlcGc5MnhZUHhwN3BqWmZpK0Zqem9aTTdS?=
 =?utf-8?B?QWdKY2RhSEk1b2RreEcvNUdRNE50cXdOb1dEZ2JqanpMNXdVM3Bsb1ZMRFhQ?=
 =?utf-8?B?OGpZYlZUZzBjcy9DdnF0OEJLKzB6K3FTWGtheDYzNURmZlB3TUFBQmY5YzFo?=
 =?utf-8?B?Y2QwOFBzcis0VTZLdGlqVlJOa3IwWGM2RHhBZ0JOTHRRRjFBbWxmeUZYMyt1?=
 =?utf-8?B?anZkSzNOQmdHQUY1ZG1WRnJvZmFwTHplcWozby9pRnRqWkZUbXpreGxMSmt4?=
 =?utf-8?B?NXNOeXVZbDhwdmxYVlVEdTBFQVdkZzJvMkRPQldnT2J4RlhkL1BiNjB3SGF0?=
 =?utf-8?B?WW44MWhvWlh1OWJwQkcvRWdoSlByaHJRczhNYkp6ZGcwOU00ZDZMS3crRjgz?=
 =?utf-8?B?LzVMdi9lOWdkdTVBcVRGR3ZEWGdNQWF2Ull2SkxuYyt4NmVvNHZRZkJzMG1Q?=
 =?utf-8?B?cWRhcFNzYlhsVkVqSGJKd3pBN1R5RCtPbmdDWFp6UVYrd3JhUHlhQUVyWXhy?=
 =?utf-8?B?dkxPU1ZqbWM3UDZON1pkZU14U3hkZGdzV1hyMGxwQWxBWHQyNjZkRE4zdE4z?=
 =?utf-8?B?QUtzVEJ3ckVUeGxTamgvQmwwL3dMYklMei9XSmJZRHdPQjg4RGYyU3IzR2Qy?=
 =?utf-8?B?U0xlOVJHWCsxcEZ3Y2dYL0RJY05XMWFYa2tlRUw3RWNEV1F3TjhEMCtxblda?=
 =?utf-8?B?aHkvY3g1Vlk4NVh5VmFGK2FiTytXV3p3dTg5anFVUGIxd3ZyWlFWQlpwZ3h5?=
 =?utf-8?B?dFFmQmRSVjQxV0VUKzkzbGNlSEt4NVJ2Z3Y4a2VVT0cvWS9GY2M1dzdBZFhq?=
 =?utf-8?B?RFkzZktlWDNIMmhRMDZ3bzZFazdyZGpsNzY5N3psL0hwOTZJNlc2NCtCS29L?=
 =?utf-8?B?TTNQRkVVZzBSNW5YRU9wODRzOUpOdEJKd2lSNzkxUStRMXlUMVNLYUN5T0g4?=
 =?utf-8?B?NVhwRTFaajBBTURZQU45WHRGTmd6T3c4Q1NzVk5ZUEVXR0lFTEtRZllSaUwx?=
 =?utf-8?Q?6N5yRWy1r+EYvZ+QnjdJU6FRAs2Rz4+f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0N0aXBzVEpwdWg0UENRMUF0eHpkL2d6ZUNDQUkrNXVsODZVUndxZzduM3U1?=
 =?utf-8?B?cFZYdFpsVGVMdXNiR3pEWlFMOVNjTUFkS1dzSHBJNXIyK3NyaGhpOFhzaHZX?=
 =?utf-8?B?dTZnS3RSY2dXeXRDQ2R0OTQvNXF5OUJheXplbGlPYjlQdkY2NDBwUW9QVWhY?=
 =?utf-8?B?Q29lUUNQNFhJSG5wQk9ubW11OXpkRU5JMm9xUHh4ZDNHbTRnVFZmUDRIZGR3?=
 =?utf-8?B?YUVtRFI5M3d0Y2NLajhXZE9YampzRThFcm1CcmFpYTBPbCtidnBSdVpSc1Bt?=
 =?utf-8?B?M1NLcllVWmVIV0IvNTUxQlVtclJvQzAvaGxBdjk0QWZkQ2swV1hSYXJVcVZB?=
 =?utf-8?B?ZC9YcUg2OTZGZUkxV2xSckFyUzR6ejV1RC9laGFycy9KTmpUQldGdThyUDZo?=
 =?utf-8?B?MDZmNU5lNiswTjM4LzdxY045OUd3TmY1ejlxMlBLbm02TjhoNW5LVTh1aXI3?=
 =?utf-8?B?RVhMSGYvNG1iTm9qWXVLWFljU2k0RHRaeUh6N0IrendOVytGTlRpMzA4L01J?=
 =?utf-8?B?QWRWZXkycjMrN2FmcFZFSXo0aGZQQ3RaNjZQaGZLeU9GaGNqRjB0c0JzUUpP?=
 =?utf-8?B?M0lMTEYwYXo5UzdkTHVBeWt1bnMxcjN3aGdkQlpJVlZab3JsQ29Na041cDE1?=
 =?utf-8?B?YjF2eGh4dGlUQitYcUF2aG5PcW0xbW1QZGF1UHduTjVkSHROVVRDbE0zNDZM?=
 =?utf-8?B?N29qZ3dVV1VVOGRqMm5BRm5ocUNSa211OUM3MG45bXFUT2VLOHNySnNXRWVr?=
 =?utf-8?B?L3RIeFdXaEx2eHNVai9RczRaYnNrUTJ3ZDA2NFdzUVdCVXhmMFBNTEFEYTM1?=
 =?utf-8?B?YllRMHp6YlN6NjFNa0owT3F0V0w0QjBOdkl0L1BjZTNSZDlETzM2N2N5cXBC?=
 =?utf-8?B?eVlubU56TGFJSWMyMXU5SUxKL1MvalU0LzRuSitEcERvTW5VTy9rYXhPN1VN?=
 =?utf-8?B?elMyTWxvT2xyZm5KRXMxR1ZmM3BRTjVETkxvU0NzVm1lZ3NGbG11T1JnMFNH?=
 =?utf-8?B?OUlpdU5NZG1ZYlNSclMxS20zaXdPMWRWSnEzVUFzNU9oTFA3aURiazc4VDZQ?=
 =?utf-8?B?NXdqN0E2NlBVeUpoS2J3NjZmY2N6K0JZazRZbjY5S0pzNjJ3a05kUlJqeXBn?=
 =?utf-8?B?blBTcDhSVWR2Rzg2OEdGSTF0UjZFdUh3R0EzWWpKakx1Mm9FVlBQWllaUVdr?=
 =?utf-8?B?eC9aMkJYZ1U3bTVEMDdqNGFmakxucFU0bS9ucm0vdmFjaTFwSWxCQTBsRlRE?=
 =?utf-8?B?QnRsODdRd0NuUWFaSzVNOTFBemNvdWowd2hMUzZMTmhwY0poQ1JZeGFlSEp3?=
 =?utf-8?B?Tk5jOGNNd2hUeFRtWERsRVZ0UTZKc0huRFR2UGR5eld5Sk9RN0JSUFVmb0tY?=
 =?utf-8?B?b3VnZkphUUw4M2Q1TFIwWGxKbmRwQ1lNUGI4YUFMQkdocjNpcVlzcGd0VHFE?=
 =?utf-8?B?dzg2dThOREdiOXRqazhuOHFWYUQ3YURMV2xUS1ZQeDZrQWRYWkVNY0EwTWF4?=
 =?utf-8?B?R0hMMFlMbjhiQmt4VjdId2tLZFVXbWhkQlNhSlVkbTJyazdaejRIcG05Mi9O?=
 =?utf-8?B?dVNFN2RpeEluck5OQmEzSjlIQ3VwNnZrSHpJTVdpKzAyam52UDFMak5hTjlH?=
 =?utf-8?B?cU9CM05GNkpZa2NGOFY5ME9OeVZycjlGUGxTcHloYWJrR2RUanlWaGU5YS9w?=
 =?utf-8?B?QlFjd1AycGxzUkRvTDhiWTEyTktQN2drWWVyNWJqOHF2YzhQaTg5UlRtWURN?=
 =?utf-8?B?a0xjUlVCbGEyVURJMmlmS2l6bThobU9xVTlFTlpSZHpmV3ZCWEMxN2VkdWlP?=
 =?utf-8?B?UVFFVzBYNnJWcGlqYk82SHY1SktXb3JzWS9NK1RFalpsYVU0QjBock1mWWIv?=
 =?utf-8?B?bStQQjZoU1o4WGtIZEVGZCt6REM2T0Z5SG1lRmlXeHdZdUEvNXEwRm1qQjhF?=
 =?utf-8?B?cE84MEFqM2NtZzh3djlPbDQzRCtNdHBkQU00NnBEQWk0NDJQdnlYQkwrVTQ3?=
 =?utf-8?B?UVpkTGU5a1ZaeERSM3FidnFWQWxRL1duVjNRbWhWcGdVYzZvSkNsSEVCUXoy?=
 =?utf-8?B?cTN0bThHNW81dXBrak93clpCcEErNmdLeldOWnd6OWhieWVjSEhDRkZkRHky?=
 =?utf-8?B?MGRWNzByUjE5MXA1aE5pR1oxaElaek1QeHp4NjB6emZDRkpXZ1ZzbVo0K1h2?=
 =?utf-8?Q?Vg0Z6fy+PLFUOr4V9qP3Fcc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3KHTw0bhj/dtb7sRH6H987mjYXGjOwbNt5J+Kig6XbhgiVXEpAD1U1ssM4qvhkazsvf87/MGX3lb9j5CaVHLQDCtz7fJCsBLE3fD7pNklhfLe1rneHmXggRerQopdmknsKvsfGBsl6+0M3pFveO/NzdZKnj4FQL9EuP+QN50iSDWPIr3Un1ww3rGwkVW4vDCUP95J+P9LXIV8nC2BqnMho1wy0R4N6bd8gHj+6K+cWPsEoGsbtIgasMwZaZyzPhN1ivwCkjy9QxajPdCJTzo7Qo6bagTtSkdnSIWA6jO92mdpR7/APgXTHz8xpSwxBp+N0TNJlGvnmNplJXYfvbvK3SmTYqCFuEVu1k0kSgN/nQqGp09i4Zn5T1WYJfa4wAgn7zbE3o7ljf4eDz+H1HJul3hpdswZUQ8Wt33NkIqmzaGhvWIf7DAMxRfJDV4yO2yYvsG8+G7royaYz2kU2dJgar2jyqo6lSa19HKVa49L1URBgvgBTf29G3bmiooVDyBUP/Zna3ZjQCQ+hidzCdM8dw45F2ehHLn/58ATjiRWA0cPKwbM5jJTOkql/wRNQb/o0n0vUw1wJfQPL2iH1aQBnSeYb5wU72fu2PZgRi+d4o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b240ca2-a6b9-459d-b083-08de30c80d06
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 10:54:50.5568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXuTJ5emZCQ50aG7HbQV4MPh4Glo0IFtlbn5jlqpt7Ly0CMwoa+H6tMqljiC9UDz17vlPOCaujkvaert629pze2iXQzN/+25oZlbHIpp9knqtNwakFxya0hKS66IpcJM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4923
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010088
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDA4OCBTYWx0ZWRfX5IUevMYnikZv
 BEZWl6nmGbgvwgx/LWueI2FPwRaLiv1gwLWMpd2vyO2XHzn5gNp1Eow90EwPTbSlOnF5i4Yw+Vi
 G9/aXuSWU4eQGpHMXalWQsXOh/JVrEVcdq6FajpAOYYehJ4fwdaKt7H3QH1+S8B1yRQJDhJJriW
 Wi/xhFu9hSH3a5G1Lzh4Fr8yN0jfJDFMs9uoTkjzABY7H456dDuUc+kH48hNwt8ZNFOJigG6c21
 XPEe8zHWU7+q+26QmjtpsMFULYcVVaX6bp1Bk93f/971kWEikwug0lp3BLAcyFp3k7U7U9ITOB0
 e+OT6Zckqf+V1UyIkB36Ne0vdnzbIzNNu9qW6Ved0xheha8Hzg25JhynRvgHYHAv2BElVD38e+q
 sxffdjsGC5ipPBnvy5J/Bcg6QlDtbA==
X-Authority-Analysis: v=2.4 cv=fqjRpV4f c=1 sm=1 tr=0 ts=692d73ff b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=XxOI6gUC3NoPyDhgGR0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: E8W3WAlUnh_t7Pbaa55843BCJdN6_dq_
X-Proofpoint-ORIG-GUID: E8W3WAlUnh_t7Pbaa55843BCJdN6_dq_

Hi Greg,

On 27/11/25 20:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.60 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

