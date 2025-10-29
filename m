Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD9D2F619D
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761730700; cv=fail; b=GXh78+5A5JmZZN4TVCUYjOHMBqUvK8FW/hcmNKXO2g18OOAJX3DqftWOzv4ZAlDEyn/BRc7Pdpc2b2ag7xxXD6b+oRMYSf8xlnMvBpW9nGhKJyK/jXxHikzi8spqC8eQyuJrtvHsLnj5J/lm88x0iKlRjjbOuO+a/ofwMGDWMq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761730700; c=relaxed/simple;
	bh=4d5ICsUKWyoa5WN7vF1yPA7sSqjG3Gvx8fBEdjLYpso=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=blaToMXQ5s9tLvSkf1t3tKkoLCfFyUciTr3bC+fcZdBYpxiFgDtXTMszE12Sod5bQd5JfSO4f1fomZzG870oRMbCMMZ8aBn7Vp31U1HZZJbjWWQf5j4BNyuI566urA4QbBQ9L0Wy6sGLPucrrV1WZqS3iynhFaoHDT0DatqvtCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g2As7TvG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cfZpwzeM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g2As7TvG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cfZpwzeM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59T7gbb7030864;
	Wed, 29 Oct 2025 09:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qmJ4ZWrhzzjDppp1eDLF0BfdvsLsXPcStkhVPf2YD+g=; b=
	g2As7TvGt0nRoZTiq0I0NVsaje8V73Mk5l6OuSvN1+dP33F7/okfkYtHoGthAWa/
	Zktoic3T+tL/vscLhyShzG2pa3rP0t3x273ASm8Y+V4DbwbvrOjALvATQL1pBLer
	rD8XHq28cfv+kyXGPx0yV0EAsEGdsQBlcZAMf27We2410jAQrgt/OkhMOtE+z90b
	lZYRuaxknRt9eGJgFkIg2v7yVsWSEL7XbPZD1H4uvP03zchM+8QIEJ8bxhLwaUMP
	b4fuM96Y6ueZ2VdSeRO4bOIP3B4vTJFwAfWSrV2uvsCirNkpsUo/QO3I9jdWKA4L
	P6LqMtyu8BmxcnyYKCcfIA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3cbtgf3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 09:37:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59T7XpBE016684;
	Wed, 29 Oct 2025 09:37:53 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34q7e9b2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 09:37:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EBZnyjU8lviyS/K/BXl6HMBbnmTOdAhYmlQNPQGX9kh6HmSCUjILEF1ZxrbYLOa3Y8RGQdbb2CDdJSGZv3pt38sydZ39v6ZGj57LM209tI8GUyBdcM/lYhrYq+lkXDSohVJoNtX5Ycb4iqh7L4RtivAHTuIwGOYETkoqXMHHzMVFaCg9IzCT4kqjSCpq2m+pyKQMQQcWAlcLCUzOcfFRzTUrLlpr1vjveO54jn6FuaSqybQAEVx24Ey9Qt+TzwhDgFHjsBnjMCXfr5Ct/N+7U8TLYq2xMmDtmTnefCSfV1ke2HXqhua59Q/q9ht7zys68wkv1jDO3aqq2GsijlIE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmJ4ZWrhzzjDppp1eDLF0BfdvsLsXPcStkhVPf2YD+g=;
 b=UyCvawvHvpfeiNqT2aZF+jR4fPWJIOd14mJYxgBAyi0Q8fYwChELlN2/4WYVvX91KuqjOpJcrNkJgfdcvRYpj/UxhhMtybFiKjIpZKPKv/d2Hc1w0kwRON0IaNEl52xteJOR9pi6rTudZXpKstl7RbyCnGtUz38u6SspUeHniaTeACxLo/iMjXNqLto7Da2E/XS7Iu8ilkuqYHb5hl9FkEwf9samtxqNy89CbX0vVzgC13w6bpMfsWRTkXPA5agl6U4qWUd22sYTugRsksEZNYFo76AVEpUCy0fByDa/QV64vKqIvvlsz2KD30WJDxKLOsvkikPQJbytXX7bkZwkYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmJ4ZWrhzzjDppp1eDLF0BfdvsLsXPcStkhVPf2YD+g=;
 b=cfZpwzeMib3yD/EIj8Lic5PjvXaTu/Awre2xUCfOtYz/iEHEhppoza5Y7fepHBu1fOzuZHpNU4vUk15JYrsPoY7rrPF30bP4thRDvUehVD1RFa5y1R1+kEbKTTtq82NAD7e6+0VvkWzCYvkJAiDd1A7uwmfeJi3F2TPM9vUvEnw=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by CH3PR10MB7164.namprd10.prod.outlook.com (2603:10b6:610:123::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 09:37:50 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 09:37:50 +0000
Message-ID: <f1fe096c-7bbd-4c13-8b40-710935d35c5c@oracle.com>
Date: Wed, 29 Oct 2025 15:07:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251028092823.507383588@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::10) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|CH3PR10MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: aed1a940-bc05-4a82-4cc2-08de16ced34f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmdocmlzYjVNZXl4dHRGUTM1REptOGhHOWpNNVdFclJOWWlZY0t3MEtXbnBk?=
 =?utf-8?B?MjJneEVFV1RCM1I0NkwzRWdxRS9PbWIrU1Vycm91ajJCdUg1UGZXbGFIMzN3?=
 =?utf-8?B?Ui9jUlpQWWlmN1lTN0pSMjVtTi9DRS83UFdNVmVCRld1SW9UTU11RTEzcHZ5?=
 =?utf-8?B?bkRoM1pqTHJnSlFKNHlMbkVrT2R4QnVFUlV6c2MvbmxuV3UrY0NNVmtaK0V0?=
 =?utf-8?B?c1N5TTdyN0FYREVLazFCSnU0aWdiSXZqVGZscHEvRGxkTm1rZENyZDVuUU5C?=
 =?utf-8?B?SzlJcW5VOE45c2VjMWF0eUY5YlRONGM3NkdtV3kwRzhjUVdzRGxLRE1qL0Fw?=
 =?utf-8?B?N2loRW9nQXB4YlZ0c09uNWZRRnpXSjlKeENWU2psQTc4cEdEM1FWMWNVbndN?=
 =?utf-8?B?K1JZbktTazhybUtHU00xckg0WHJOWVE3c09nT0RucDlyckErRUtvQkJQdTlz?=
 =?utf-8?B?bWhpL1BMVWR0UStqWFhQZjhNeWlJakRnd1BJSWd1dnB2YXREcFg0VUNGbVYy?=
 =?utf-8?B?YU0yWFc5K2ZTQno4N0doaGpLWlM1VWZxVW56T1habWVDRGpwOXp5cVM2WnZn?=
 =?utf-8?B?dzVjTU5jeWEwamt0Mit0eEFSelk4Z0dzaENuNU9nMFAwSTB4K0pJalJ4alhJ?=
 =?utf-8?B?cDVqdDVnMHNQbFZXMjBrMGJtOE1HWHhIRDk1TTd6RlRNMTgwT1o1V3BRbkJ6?=
 =?utf-8?B?aG1ScW42L0xHQ2xnMkpqUG84TGxVSDliVUFtMTJhd0o2TE53aHVRQUhuOHNH?=
 =?utf-8?B?UmIzYVVkQmh1NkpYVmJVTUNKNEpQd0pXbkNVRXdXNGxjNmF5MnRUYmlxVGdx?=
 =?utf-8?B?OXFZdUJXMU8wZWJadlgzdkhFc2ZwWWFrNHRMd3V6dG9Sa3czY3didFB1QlJh?=
 =?utf-8?B?QmtGbXVCSDg4d0JGdzJPMEZqOGZXd1JrS1JpQ2ZhYlczc0tOek8ybmQ4dDJp?=
 =?utf-8?B?Zkt2OWdRSnFmdnRMV1FTS3NpRjlJSzhLV1B6WnJZdkRENW9VcWJuN2xueFhK?=
 =?utf-8?B?UzVOSmJsZmtPYW91NGxHTUJieWdYQ0k5U05uLzVybncyWlgyYWc1VCtuZDFD?=
 =?utf-8?B?RkJ5SjdxWEltU2xiSUJZdkszWDZDV1V0Wlgzcks5Uzh1TklsVEtQaGRJWTZO?=
 =?utf-8?B?KzJiVEFPcnBBTmc0dWFDemRYelQ0dmc0K2U0U0cyVVM3eUlRR1psWHJJUHVq?=
 =?utf-8?B?ODFhU1RnUVNCcGY2TTd0OFVkUFRZN25uMklqamlXQy9uZVluUXoyWEFVRXBE?=
 =?utf-8?B?RlJSYWwvS29idWNIVFlRNUc2RFNveUFhcFIrUjBRNENYZmtZVGdqY3RZdHIr?=
 =?utf-8?B?enZpOHZ6Q3dWTFh0Q3NTcC9SYmN2L1c2bm52N1JQQUNUOXUwMDJwYjZOdWUy?=
 =?utf-8?B?UGttdGhWUDdRU3h1SnN6d1hRR2x2QTdTbGJQRU1ZOGhablMzbEFQd3d4V0lH?=
 =?utf-8?B?SGJKWW5ZRFA5MmQ5Z1ZTRlF5OFVUUXUzNVdiMmwxUjNUeXZZRUFkL0NIeXcx?=
 =?utf-8?B?bGgwaCt1emxpUXcyYjhNWHFsdU9qZzF2U1ZJUHVNdFpsZkNQcUxZN1B2d3RC?=
 =?utf-8?B?Y3k3UVNNa0FLQ05ySkorcDFpUWtLV2tCcUx4UC9XTVUySEhLNE4rNW1yNHVY?=
 =?utf-8?B?QWpwZmNQdVB2cWNwUm9jOHJTRTlrMGYyRXJWVGM0dUJ1eXV5Q3JXclJKYzlV?=
 =?utf-8?B?cE1XT0F4Ym44dHZxRlY4VzY4dFpDVGRPMDkrelRCTmE5VldERmE0VGQ2Z3lv?=
 =?utf-8?B?VEt4akJJWGRRODBGQTBTY3g0K2dncmwxdFIvT2JWRVB0MlZmWDg2UDd5eUE2?=
 =?utf-8?B?ODRtcXVHLzd5U3haWUh4WUhWYU9VUGlpNEJlUlFIeHcrOEZBamZDWGxaR2Zz?=
 =?utf-8?B?c1gyNHBCMkFabjRVK1BLanpHQzd2ejE3UE1yTjlwQ1JBOFBXbnRSTGN3VnJz?=
 =?utf-8?B?akFVMjUxNjlBZWhoZGYxRjhLK2trcGtOUmVlTnVmWHB4bEN6NVd4L1RhSGFp?=
 =?utf-8?B?QUR6NnlYdHBBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWJlZTROUERGMkhSclBYVjFLZFpxYXlmZkV1WVVqSFVySzVSYStDbkowZFdS?=
 =?utf-8?B?Z29uRkJ1NFI3UjV0RVIzVy9CWjkwOVZQaGZGeHdHWk9acXhpQkhoU1RkZWdo?=
 =?utf-8?B?TEI0U3V3L2pSVTFIUFYyM1lQNlFWWFBaZUJRSVdwQ1NBL2NCSTB3d1RxQWho?=
 =?utf-8?B?SlE0bmlUeG9JQ01pRmIvdHVtMFdxVW9va0NWT0QzamFpM085SG1ia0RYMHRD?=
 =?utf-8?B?QmJuanZWVGRWQ3RxZU9YSmZ4OEVpdkZBYzlMZS9JVk1nb1VzNlIzSjN5Q2x2?=
 =?utf-8?B?MlYybGFhSkpOSWVDSmZnTVlhdEtpeU9DazF3dkR2bzFKK0NlYTM0enNaRWZk?=
 =?utf-8?B?MlUxWnNac0tIOFJrdW4yVStJNzVvczl6QTk3WFRtN3RrSGsvUERIc0REcmJH?=
 =?utf-8?B?MForVi8ycDhmbkp6aU13ZU15K3NpN2xYLzhpOWJ1VDdoci8wTjVmRHRzQXFF?=
 =?utf-8?B?alV6YlZUZCs5aHRneVJlZVo5MEdmZk14WUtxUlBtbnJ0ZGo5dUt6OGJHQmhN?=
 =?utf-8?B?VFdVMWJXYzVnV0tZcytTZDNvai9sK2w1eTZaUVdmV1RwclIvVW5jMHYxSEQ1?=
 =?utf-8?B?MExYZEYvMjdsSnBkV3pjZ1pnNEY3Q09kbTlDMzBCbmw1b2xnYkN3ejhKS0g3?=
 =?utf-8?B?MXdHMnI0YjJzZFBjK01pb2QrQUJzckdsWHVWbTBIcTlzZTFMRTRnRytTMHBD?=
 =?utf-8?B?aVNnekdCUGZqVDQxVExhVzJUc0VzK3NQa2YvbzRaVnZvTVU5ci9nZzhMTUc4?=
 =?utf-8?B?S3FzakJQazZzZWwrNVdyUFlCWGtYT2xYcmxWd01oS3FoNnZCcmZHVEwrYVZQ?=
 =?utf-8?B?NjA3S1QyVkI3N1NON0tYVldlcW8rakVHS1NvWnREMzRBZEIreFVCNkg2L01o?=
 =?utf-8?B?WmpiQ25JUlRDT3VSMjBTWUVDUHA0SzV1cW9QWVR2YWk0WWhnOVVxeGUzQzBu?=
 =?utf-8?B?YXFDMk9teGZ0czE5U2w3Uk8xRklqTHNaSmYrUnYrM1FlQ3VWTVJIVXhFV1pG?=
 =?utf-8?B?dDRPNno4dlJ6NDJtTnROWTJCZ1I3bC9Zc0tBY29SM1NDVGY1eW5WdkdyQnRZ?=
 =?utf-8?B?R01xdDZoa0E3UUlhMVhNeC9yN3hIZmc5dmtFbUY1YVpHM2RWWmlrMGpBdEpM?=
 =?utf-8?B?SVJjVk5xcU55ZXRTbWRrNnFXS0pUT0dqUFNkOTNNUWZBbWNHZlA5cHVCWFVV?=
 =?utf-8?B?NFdNWFg3cFJWMklZaHlCRzhnMC9IK0Ura295NjJqcjBQeHIvVWVRcWM4YzFE?=
 =?utf-8?B?S1RXeldpdUV4OFVGaUhrWXd4c3kvaFA2Qk96cDQraGxpU3lKcnhSSVlDZEtw?=
 =?utf-8?B?LysrL0Z3eGdid21Uanp1SlMydmhJY2U2dnorTC9FRldwMkxYVnF0QVZaakIw?=
 =?utf-8?B?cis4V2d0Q0dGNitZUWFXSGpWNWpvdFRHRzlhUFdtaTFYQnpXNFl4VFBSclVu?=
 =?utf-8?B?RnhEMytsQ2llVnRJblorYWplRlduT1BNY2czUE91eTMrV05SeHArbS91LzJQ?=
 =?utf-8?B?NlpsOUN2WjZTYnRxaVQ4em1tUGFHam93SjJiOUIrdTZ1NXo5T2U3b3p2K3By?=
 =?utf-8?B?MlZDUE10MDl2ZG5yN2gzSHppT0VwZWR6c1k3Q2hxejNQbUs3TnJyTExLdkoy?=
 =?utf-8?B?akMwOU9STitCL01qeW9MZ0VGOVhjTytTN21QK1QzbWlubU80UlNsMnBTSTRr?=
 =?utf-8?B?Vm9rUzNFSWdYd3lPS1h6UWFVMWJQVjI4ZmxpTzF5UFdRVlZ6bGZqeHNRU3hN?=
 =?utf-8?B?MFZSNmMySVhHV3E3OVZnTWhMajNtajJTTW4vMmFKTlQwQ0lBQzk5ZXVSUWNE?=
 =?utf-8?B?OGRhRHh2ZnBNKzNwenp3cGNOeStKVzc4bFFTRHMzekZJd3NVc2RCQnc1R2dH?=
 =?utf-8?B?cEZic0hsTVdTSmtGRGp6R3hmeXFGd1MrLzRNWFRhR2x1VW5kd0RJNVBHUm5m?=
 =?utf-8?B?MDUyUzlNRFUxUWM4d2Nvc3BOSFo5dGpZQW1JaFJqczVObHk5Y0JZbkUvTk9o?=
 =?utf-8?B?QzRLaGJEaVZNNk1kcVRsenZENWpLL3ppVGtMVzI1ZVFKQk12VlA4Ti93NWM2?=
 =?utf-8?B?M1dhbWdBNXk4UTRYbFZHOWV0b3pNYkxtTitKb2pCc0VmckdnSU05OGNmcVVO?=
 =?utf-8?B?cjdnNm1ndU1uU3dxQld0dEM2cFUyNVYwbENOM0UrNFZCdXlyUFpMZ1ZadFNu?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	enz6plzVmzQHqbBeLS/MN6+d7SkBT+77C7p95I+fDExdEOZOBkelkcYEeaiglIziflqPshw0RdEAobbkpwNg76uxfCCEcm8MMqVwjGbgUcENxaOyBgf59Npa7V6zCTRFieRxgFi6yF5w3lr5pp6wmuXqZe2p/DFrexjJgLlE9HOB5nzLULBgoLuFeq2STDFQiA4z1rY8EGzbc/5zqr3Z599qKVCPtrVa4ZUVL6R1nYUicZh/Tosoi4QDLKwQBtyiFTeDKlmGUDEAz0OdQSv/cTLkGmQBx4oRQahopmIoz9e4TDwBnIOgbUxWweER/dwgfNe1ODKUgvEpYPNEtoDxnC8lVlm2leDevp93T71f7M7gBJdpUXMXVj7EqZRSCvW7SmeDE0YpWrpQwK0aD0CN3wyd72ETgAdl7XBES7dEkwQOg6SoIa19mT4X0GZp/sRQ1qorX6XKnRbR6ST2iqXOReKKE3Srj5A+zyVdfer//gF0ybb7YYDDmYIEQl675+Ljb6rXKNOAtdCDbpCkqX5wtBY9ecZraGmKGveUhImoTCHK1a2c5NraiDmyfPCZbIKlW/QCWezqbkrI2R/CDZCLT4XKbDz/2eGieoVzQFZL+3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aed1a940-bc05-4a82-4cc2-08de16ced34f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 09:37:50.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XU+oUuJz9CgQ0ytOg2e2dhj09ZR+f6ysQHOo2cvZTrXfOynTJjiyPoBBEV9ObP5k5Ep2qtgxr3/6CEojYVHVTyRCYv3z8kXdHEVAcWZNGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290071
X-Proofpoint-GUID: kb3QuQpIyUFyUcYqX8yYpuzkwAPbpJ6t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAzNSBTYWx0ZWRfX7va3f17jnMeP
 v9sew4203Q+2E7OPmrujCYOy4YJQwZfbSG9pyuOJtUH0gLxugpzJ7MYpx9vAip8v6VbNawwMCkp
 1lHVL8Z2ovXJKZ9BTazyO+R6N90JRTl/lnlxOsXoqfnzIfj5z+jsWw4Cob1Eh9ROPocXNPvyUbS
 kRy8TsZYVQLl8Mge7Jli/9+yMmtgd7GzfR1/TFVO4RHq6oqWxBriyGHLF8btMrv9fmez4L745Qz
 S6hebGnxn5e78z515LqwJ/3XBfTk/pQoL34w9g0EsTzhYa0IEt5fI/gCuogwvqfIBv4cVOkRqIV
 Z+D7rafOGyzsU27CPP5wZFMASk3CiYBQwrhOPkhW4jPMFFqI0G+vJPkahefapyxLkNVAQNaHGBH
 2xU9poLuEn7JIa26tJ0plwhU9+4PbrvBm9b9VytLskM6YCPMNMc=
X-Authority-Analysis: v=2.4 cv=A8Nh/qWG c=1 sm=1 tr=0 ts=6901e073 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=uzRmThIOWYV87ePo_20A:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12124
X-Proofpoint-ORIG-GUID: kb3QuQpIyUFyUcYqX8yYpuzkwAPbpJ6t



On 28/10/25 2:59 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Oct 2025 09:28:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.196-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>>
> thanks,
> 
> greg k-h


