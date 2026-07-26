Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ACA2BB13;
	Sun, 26 Jul 2026 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079558; cv=fail; b=SOVVNKwvCnZoL7MIGARbVBZJBXOqjiH+/3y6lDRC1rHJz9o1BniiatSTsjfG39wyymQOzn4xoySCGquRsdPerAyPN0kg53CcFsrPO/1FLJwv99koquD4oIX8tPCgmNz5ps2B72zLNPB1cKSY30aLzhvf0qHZP54uxyzIZmNua+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079558; c=relaxed/simple;
	bh=8NRtR6RGAKtoc/fj4aixg7q5DGKZ/jxaRDeOIJ/0ojY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b+hLSOOW918TKn3BkW0YrKNcnMdP049chuWSnLh6LJTvb+Ta3tjyVk5K1TxRgdjuuuesEJIo89+ksRHWOT1MsZDC72hg6GzMhLalPybNUUhfVlcym3jQtr2Y+uOEu4cqO7DL+9pErPnWmALEKgnH1XoxjXO0UTz66+caDvOgHVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XcLzyts0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xL/ai6/H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XcLzyts0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xL/ai6/H"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QEVQe44094492;
	Sun, 26 Jul 2026 15:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hpWrkROm+wh1h4LPLQKHcHTodDaLJoYeB9xyE08PCns=; b=
	XcLzyts0ttuFls3LeQHPh1rykZtIHMUr9WK1NvM3wuSYrtjpN+mSB5gncRx6Tix9
	8WzOEyzqR0HnVkAjFP6gJt4yg/g8RTZdjVsyLPW5TBoNZR41Ol0+PaEp9LEyy3wO
	C1Xl+shsh3FlctO+tQjVckLbIYkK911lKNciHPMGLwW1U+NqTrR3tO+GfYUNyHQo
	3AOMzy0p7pY0DGM8yiuiEco7SWMPNoG9DA6gfJ4K+QrqZKAWGts8IULeiD+q+Qwt
	iQOK0wnpWa1vgC4sTFrRX2l75DtT6b6HJFcsI4Cb7Se2hT1Gk3XuW4WOWhev3qtg
	aVdEO4X2898tNW2f2aNbAA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xrucb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 15:25:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QFKOJe038999;
	Sun, 26 Jul 2026 15:25:46 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6mk3eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 15:25:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FmoAi6x9gcYHSwT18ol8LOFJjnCHZ6cW8jepwRUSX4EWytfBBjHTP8nkhMs/Q5yMfzNFfFhycy3OpZwx0AmXOaFwOf9tcmNjnPmu3KKdY/QcG65BF5xUPN7nq0NKrgu73v/WRSfSHJUAdIIQpyq19+QBvzKWkRWGWp9sVIwVqp+ULvYS4fIVXOQr2/cZE1ZNUu0O7gifrOcmiD8S2pcxqUWWvejK6dip+/UG78HvW0C0LlH9LvdShfRvMt0WBICQi4CwzW3THVyyXZwG1EklWcuJbKoZCtEOj6VB56h092uTF3ypEb7ArlAzMQscfrALPaBfDuHCuwAUgkK9jzFWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpWrkROm+wh1h4LPLQKHcHTodDaLJoYeB9xyE08PCns=;
 b=E+5R21xxeVvaPXhtKlWWX1YFioZ4A2mSVDAva9dQ0q86PUf9ZE5I3wavdcsm4oQs0OMwRoyz++kQU+kCRul7h1pnIS7eaUMXrnfAZMJDGV2CVuXxS4tlbECuEbUu2daT523IAS1AYSHXv2OVK+aOEtPgzJlByNO8wD46glyscj+nbyqsSovEhMzeIW4fTZysR+JYWicmmU21eP2Z55CgRH00ofaJoasEJsWi9A/bJkQiqEMKL2RHaIGjYILKiZSlfO1GeAGLPSv0C3a0Z+D7nYuTQ0fmIBwwHJWcYLgzs8hlm08IGttiuZZ4LXS0SWfqwF6wSVxH0wAbpGQlYQeloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpWrkROm+wh1h4LPLQKHcHTodDaLJoYeB9xyE08PCns=;
 b=xL/ai6/HDuuWpJF56qhB2xq1KEAHg1j/wnp/s+zUUPAk4rVFGk6nxlw6IfEcClJ3e1h3ViVjmD00sSIp6pAmklw6tOW831x/oHnghY7xhj27QLl86RsgPPubTDN/PMHyoezG7E2frWMAc3+cE/7BIX5zyuRyeW6M9+peiPuG9kY=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CH2PR10MB4360.namprd10.prod.outlook.com (2603:10b6:610:ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 15:25:43 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Sun, 26 Jul 2026
 15:25:43 +0000
Message-ID: <5e26bed9-8f32-4193-a2fd-49db35b9ddbc@oracle.com>
Date: Sun, 26 Jul 2026 20:55:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1139/1276] iio: pressure: Remove redundant
 pm_runtime_mark_last_busy() calls
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        vegard.nossum@oracle.com
References: <ae4d5ec1-9e10-4230-85f7-88b99028ff17@oracle.com>
 <20260725192000.stable-0008@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260725192000.stable-0008@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0418.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::13) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CH2PR10MB4360:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af7f86f-1f37-4f09-1b91-08deeb2a288a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4GAtQL2+d8JBbtIKbs5pNIvu/YalQz2VdAu9+FyTr1WZOFEL5RpbqNYE9S0OXYH383E14+T9oXSdraOGp5YoyGTVi9Kt7na3N+bwSWIuXlFERP7JX5hsk2auzyNnDgJqjv1hzPYQrew8Y+36nR171VTuzjDiv/nTqMZMHpGhlnMqQaOnuDJPMWN76aQ+bre2pkibEC80wxYIH3mX4JBcPnw0plxTAhii9sr77oGosk/sj4zRkF8FYKAubK6nRQ+GYg4h2T60+krNd0HUxKWQ1zi8cWtJ+LUasruKSL4Tnl2uWiAWHkjUmNdrMFettUYmvV1Dzy27+c05LO16zsgdvbvEcD55ym93S/DqxurfluS31dVoxoDFOfot6lWrCgT6Ylz89U1JHYBwFc74Vy4+QEj9SFxAcbYLBx0yboxmTTcdXzNtTZG8Pz5fs/6MB3gQ5J7hLR6E/Pq/sZESdmnDTvAKYcGnrAaRTMPhvyDKFieRiQS6OGsYKS7l8hX3Y24zZpF0+KFLx8WekSsGHveA1JgeIsVIpNLg0/hxtbh2+1/z7ozoZ1C+zU9uAAZfPcr/BynYYUlct98PMBGL3k4xngy6pr2qv/2aM3IBz7rdcI5Ctjz1vCo7/O8u1ouwyCkOoj+D/PD2gxguWlbBvlg7ztU2nhx/OhBfFwEapNjCTvA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnY2S1gycWhUUkt6UlFJRTFmNHJvdlF0VzJEZ1IvZTVLUmlpT3pNQTQ5NDVz?=
 =?utf-8?B?KzRQNTFqVWlxY0NQMVlpQzRoVFVBLzVFL3M3c01TNC9ydXpZMjJTWDArZFpj?=
 =?utf-8?B?ZGJsQW5KRGN6K0laT3J2dDlsMEJXQWwyakhkSFJzTVJ4S1cwcllBdUs2K1hM?=
 =?utf-8?B?bnVsZkNsTXNyOEYxR0lwWTM3VysvbHVvcW1PNTZWMDBnZVhZczEyTWIrS0lD?=
 =?utf-8?B?MEJLZk04dlhDZUNqTzQzV1A4aFgrS3dSdFB4aElFcUltVGhjWlIvR21sM2ZY?=
 =?utf-8?B?SGlwWDBFUHRJc3BtL3MrRFBtWjRlMHpZWG0vdTltNkNnVTRIcWorV0lHOXNY?=
 =?utf-8?B?WC9acXlIRFBoQ20zTFhaUXpzSWxkMlQ1RkZKVTdwZXZaVElqUWRGNklMZloz?=
 =?utf-8?B?azA1aVQ4WGtQL3VsbHhuUFB4eDFMcTFKQnU5NzVRaEJsM253SGtTSXlJRldm?=
 =?utf-8?B?WkRqQWNmR2ZaOEhsVlQ1d0ZQQU4vNFlEdVBZOHlBNFErcjFjeWFSV1BTYjV2?=
 =?utf-8?B?S0JDNUZIT1NoU2diV3B0RW5scGEyZjlOcUhYU1BCcDVFeHhIcCtCTnF4cXVE?=
 =?utf-8?B?RnprRnljdXZ3VVJTN2VlMjlYWWtLYXpPUXIza1RMeldaSUJIN0NWdUFvbWk2?=
 =?utf-8?B?b1hkTEZ0cG9nWnpQTjRueWZnUVZxRHFpeFp3VUpIc2FnVmR4aitwdm5uNU9W?=
 =?utf-8?B?UHRSY21ud0FRdDhqTXVFSlJYRHcxUGlURHJ6WnJwenZXVmxGVXlOVU5FVU5T?=
 =?utf-8?B?YWZpK1FOd2tRQ3Y2Y2N0aHE3OTJwcUYwb3lkRlNxLzNFU1NrL3lQbUEySm1J?=
 =?utf-8?B?cDQ3L0Y2U25hNmRTWnlBaDJXZTBtZHNrV2g4VExEbzZNa010UjFZak0rUmF6?=
 =?utf-8?B?VkJzOHluczY1S1Y5c05xL0RHV3Ewa0JtYis3amxsOUhmYUR0eXYvQXE2cGF1?=
 =?utf-8?B?S2Y3ZjhPamxPamo5UExjcG15ZGJGbEkxbURYdlo3cGM2MS9mcVZydXJiWlNE?=
 =?utf-8?B?UUVydmpINnpGcEk4QUNqMk16UHR6RExTL1J4bXNWS2tTZWNpaG1DTTZuUTk2?=
 =?utf-8?B?bklVQk9qRDFhc1BjL2NrMTZaaStyRkxNMDhyTGhiMzcwdVFZUW0rbnA3SFN2?=
 =?utf-8?B?bEJUWFFDS2dNZUtOdzF4R1FhM0pTaEZXTnZINThBNm9nbmZmNU9mdC9oOE9J?=
 =?utf-8?B?bEFwRWhEVVIxN2MvSUZHTXVubU5lWkJ2b015QUhwd2p1QmcwY2N4aVBFTmI1?=
 =?utf-8?B?TU93dDdXOHplUjJNWWpMV0s2endVeXRZditWTFhZbFFHOVlDQTYvak81TGpz?=
 =?utf-8?B?ZUYwTWROL2ZxejRMS1NYQlE4MlpLQXhLTUk0aWV3S0QvRUxmYVpCY2g5Rllj?=
 =?utf-8?B?VlcySVp4VzNQNkE1WTBlM0Q5VXJnT2tjZ2RxSnZ4dnRVYUM5Z3VmSWZvbHMw?=
 =?utf-8?B?WHcvUU9vbFIvUDl1M25uNHY4c0NjV0V0TDd3dU52Q2EvWmptSlhoeWpoMXFX?=
 =?utf-8?B?MzdyWFpJQyt1TXJWZ2g0SkJNVkh1RHA1ek1ZOWFpeDJRMGR5aGpQeElwb21W?=
 =?utf-8?B?RUx0b1N6bkRNbjljNnFKTi9HalB3dVN2UEJVTnJIVUJMU1RZdyt1Z2xCdG1C?=
 =?utf-8?B?ek10REdKMFZGWUZXakN2TEdidGNmZk1EcVFUc3RCQmFDaVpZSzg5dlplUXZ3?=
 =?utf-8?B?NjJtZU0yQ3M1RTVzUHBWb2R3QU5NZGxtU3VFVXVoUnZYMlB3VldBSEFQWXZM?=
 =?utf-8?B?dHVycE94ckVXWGJIQWVoeVJ5UmYzWk9DQU82TkpXR1pzeFlsc3UxeU9nek1n?=
 =?utf-8?B?bFloZE9yYXpLTHp4NFB6VkVSWGM1WFVLdFZWbUNRWTNPaThNMHVjMFNQUUs2?=
 =?utf-8?B?R3pqY1ZpMlpQSC9PY0p2M1VXSExwNEJlLy94cU1JY1N3SFZiMHJuZDJSZzlW?=
 =?utf-8?B?Z2xtSktmaGpqRWF1a2M0Z0kvZVBXYXB2N3Fic01nQi8wNkdJcmFjcjFLam1j?=
 =?utf-8?B?Z0Q0dkQxTDBrR0VVMlpaV2dlLytqWC93SEVVNmdIbDZZK3BGVkd5Y0dOemFN?=
 =?utf-8?B?SEw4Q2FWTENWYkZnOW5EekczejVRNmdhWkt6amdYaWRuOERNMGd0Nm8rOTdL?=
 =?utf-8?B?WExMd2c0blVJOFJVa1hKaGRpWExiWnpTZHdKYXE0OFpJSjMwNDkxSE5EaDZ5?=
 =?utf-8?B?TzYrTTIyV01yZTNjTzU5Tmw3VjArTnhjYzRrRkIvQVVWK3JpUWgwWkg3b0V5?=
 =?utf-8?B?QUJMY0JSNytMUitsaitRWjlKcE9Td29PWUJiU3lucWRQRXBjdDFwQk9rNytj?=
 =?utf-8?B?ZlZzZ0VIMjdMQzJnRGk0M3F6cnl6TWNBMVdCSFdoWkNGQ3ZCbnhOdkNkTTdN?=
 =?utf-8?Q?/5qhfV0kqQ90rwSBUDVTAtR5EOnIrPQinFiXj?=
X-Exchange-RoutingPolicyChecked:
	nRi3hYfZtf0YbMzaSEdJtGngqKP7ejFwEtqSCHSFJMUvFTmoaqCmqckrEIrOCDePLyxuf+g4/lPyckbaWdm7+xHtjiBnGzdfMqg6LHvwysuW2NYefkjsEJ8k5w1GzoBTGu1o7z13HILK8a6Aon1ykzfBpL7meZM8LjlsgdgA0BL+nC3pCMTkM/bIIKTFcV93z+kqFV/GyAkOcVyefBM9sOxk8Dh7or0e+2rzp7UTVUaqTETKWCQu7tA6r8pnEJaqP5Bam7SWLmPFjFlmFt2qFxjACC24WCh7YTf5LFCY13hCWuloSPNJ6PEFTGXbcuWWluCNlL3XKCTvFqjZv8izbw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bnLd0XQgYDPIllj5XQhTMQlGdUOfdlF0EbVVwd0x4ehktCYrtgyOgOE8xNv7WjdemIEKQF+4cKzC58toGFOlJwcncTQCfVl08gLJNV7iWuBgBtW/HBI60PAZ2fuDJofdfL6QWvTIqzgQX2oONkfQeKbFJq9hEbGK8oeJbPe38LoPkJh1emZsTjFV8R0CFJnJj5Om9u54XQM/M9kWiK/X4ZIug2EyEsMPbR0Lit2qD8hF5K7ja51M3MY4zTFcWVyCPpflCvVLzF9zKVWb0DP2cMsl5ucPeTrZFWdHbj0QfJW3nbDxMU1JgNz2lxs8B7uB8q7ZWwfnBAxkwyI0neh0rdSPRuEvr3AVxYTKEhzQXN4c6GeF/KgTAR+J06gTZdqfTY4w1vaQNfPAHDrHaiMOTWiU2eBaKefthEsimM6YOvUctpBqu76K7FQHhDQ3WhcV+v7iW+T0xNnzzbVqbzxi7ryTH3b3Hwpllw/Uy7W03WVMuVLj5Zc+I0KzUSNuyet78/N+dWoSAuNL1Uz+JOnqkyv8nZ/VXr/e46QHIU4e8o/hQjPpKtHuzGy8i7P3Ahtr5AsYF1B/AOpsu10BgiC+HzkLIdb2/a9GGQOSSHASQ8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af7f86f-1f37-4f09-1b91-08deeb2a288a
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 15:25:43.5438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6HfLn86mr0VcKjUjbEXXG9eTdUcVzbcAyhYIh8Pei7NlD0gGU8uSJuDFY2puSYVnbxgE3CfHdFOG2pQXnnY9y3fG2K6Og1zevcfKwretPz4bUhPxE/bSvKhvW+zbZ6t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4360
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260156
X-Proofpoint-ORIG-GUID: H_31dj1JbL8om9rcWxWagE0DPO8IRTdo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE1NiBTYWx0ZWRfXxXCdEp0MtR48
 hcrwJ2NZqHojo0jgvlXbo231UOIRY57sBSKIwTBJpQEtMFdaEhKAgBvTONva8eyzV7e6XRixwJF
 vxfaJ3oxivSKU3Mo1fXltAisSkYhIjcpF3bzeEURnictFRPX1AR1qb3flld5Y2BtsY61F9lXSJJ
 /nhRGr9m+U4dw8aLZaiZuZLdk7hpG54vyhg21vB4osTLv1JoOH7DWZRGOly7mbm+D1U4U1ntizT
 X9564u5jIywCMouL1c17/MksLXBjtjrt38z+gB+0AQERDh/J2rk8ft6RdGgAdUsSqiAl7949yMD
 YpTDFBHgORgheuilXmleIi7O2WMVMS8b0mvcz1/PN0rHHSaDy/VK735Kvej9DJtc6/3Y0udjpi0
 wzhSPcXZ6moKwfCj5F1TPSOMSUd8dIsBMCHuoCiJfo3XW+P5P5vI5dMr5ViQkqwsBCD022sIIlI
 XC0Qb+WcwBocHo4QrZV9X0rCnIOpQJMxlHv8UVvY=
X-Proofpoint-GUID: H_31dj1JbL8om9rcWxWagE0DPO8IRTdo
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a6626fb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=urm8ib6psiVbIBoXfAQA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12114
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE1NiBTYWx0ZWRfXx1Aa2TzBxW3a
 W3XMmmWhXvpNYhDot7EvaCkznSj6w8hlyBEL4qM22blv37R8m0Q9y+JKBMBQ2cqEhspcZIB6nSH
 o5FRUn5uD7htbU/meLK3B3Aa3btAJU+scdu61kUxhYPywGx2Qcvr

Hi Sasha,

On 26/07/26 5:34 pm, Sasha Levin wrote:
>> I think 6.12.y misses commit b3db492e8335 ("PM: runtime: Mark last busy
>> stamp in pm_runtime_put_autosuspend()"), so this backport probably is
>> not be complete.
>>
>> Lets drop this from the queues [...]
> 
> Your analysis is correct: without b3db492e8335 the last-busy timestamp
> is never updated on 6.12, so removing the explicit
> pm_runtime_mark_last_busy() calls would cause premature autosuspend.
> Since this cleanup was only pulled in as a stable-dep of the mpl115
> runtime-PM-leak fix, I'll drop both from 6.12 for now and redo the pair
> properly on top of b3db492e8335 later. Thanks.
> 

Looks like we already merged it so a revert and redo ?

thanks,
Harshit

