Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE15429B781
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750694435; cv=fail; b=YvA+e56irnqVoDrqod6Ot0MV9uhOqoyZYu4ZjeTtRtbeEkP4L0mAGtxxINEhRG96LSE4q34xaFykNFpH3gniYrz3dhS6wiREvoXwq0pG45KswL5E9zDUxc5ZPRSx+pu4Ckcm+3drK7ybIvHP2L/J4975kNBFA9R3y+cPPtf58s4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750694435; c=relaxed/simple;
	bh=vj7EhL9rCiZ0j/1XscigRB5ltoPEHhJcSMaGPrt5u+s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hYi3JZMqoA/Is6qjP57gJwibX3dLQraN7i055Sorl/YtPB1ZxcYlL0wC0hFk4KFfQ+Z0Iec0Rm5M65l2yiKMIYL5F978ji9CwURlwUDJ2pe+pniexOkdPAkXdI+3qhuE/ykw/JxcQincjZ6VoaAIUsrqT0995bMi3onJkxZrk7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gk273A8U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b/3zLl01; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gk273A8U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b/3zLl01"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NCie1P027450;
	Mon, 23 Jun 2025 16:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GeksbJTa7Mb/SQbGt2Wk6lBvLPj5T4mdYPs7JN+klG0=; b=
	Gk273A8UZe1JlVknvD/LNcjw2tuSFyUjL0KZ5MNj09F0Kq2BewUBFJQLDjXDTRUZ
	TwrOVEub2+W4s1Wktt0ZNIiUyOWBaIBeYB06Lj+dAGtj5K8mkJtWoFvSVgYo9MXy
	TTLrwb7F8HiozenCCkCcBPkEDYLs7b5VwpWphvOmVHG/i0fiaAroXxvRI7gY3AlK
	EiZMvyFt0BQ0Fia3+o+cZZuNwMCJQpJmy/2MwUVFTZ+muC8DjhbzwYcYV9+NeTBD
	AjDOZ0Ty138D3qo5n2A25aCk5FGdilirDOkc26U8LfLE3Ay4e6/aGVZuirRNKW+s
	fFQZDpzCSjmctc52m4f0yg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds87u3c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 16:00:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55NFBBIJ005022;
	Mon, 23 Jun 2025 16:00:12 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2078.outbound.protection.outlook.com [40.107.96.78])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq2hdjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 16:00:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c1qaSL1zgDFHJL4qduC35keqVbRyeb2fZKQi7tKAjlErDb6MrcBPgvo3K7UO5hpnSIz4+WCwOEBfZPp77jx/VgoXBxipY5BDCHIKG/jLlne0x5ppU2922rCeQQLnM+PEDHvvPf+oqWf1bIAGHraG56B/etI4iDYD60sg8ANJkxF+Qxw2pYZEwlaCI8KHII1usYfzutEtsAaGUoswDg6a7bAfD2CjqdQu1ieNhlIuLNq3K2nFVPgfnbpBR+mY8IK0ayp0TFOdtZNs+wpo5PvclVZD6XFyLPw3A6CjrKJEWTvkWetmMwCbSIwuNxM665sn//zAFwoL+8lqdEvISmS5Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GeksbJTa7Mb/SQbGt2Wk6lBvLPj5T4mdYPs7JN+klG0=;
 b=S5TM0IYhJWXrhbXiMAHN6ucpA/KCE4S5BJy7V64UZnzD6skNji/cu5Bu+W8QvVBIAqVMHuvf4PydmzkjTz2TWQPD17yNgnuQbvpTwOIxai91lpJd5us47q7C2tfkQhGOVD5uqDbXK4RkmE+5noyGSXgUT/knMtiTzLIy9EgJwrW1DcTP0/cILiRJwpKmUdJ/+W71sFX/fePZxYwoKCKjJqi3zIyu3B4V4HzTW0SLXb+EnqINh+Wn21ioch7lgnDIfFEP994DQ3lX+bQJ9/ti4Xw9F4mdO3UPOytDeShdnqY8S98Jref8hiMTLfUQYIm91Yog6hzHeEyDDpZvzaZ+4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeksbJTa7Mb/SQbGt2Wk6lBvLPj5T4mdYPs7JN+klG0=;
 b=b/3zLl01e51r42v7YfTxTSJYOz2lxDmU8kKZUF9ynCMkvBz38VSDIBJzATLWV2WByvAkYPvb0WxRWIqCe5e9Ax0y3FAhai5eQ/iUkxc2No+Gdux+bM0abWOpoEhg/F02kZKIdJiCNrU9MVIgvqr9bhAFKU5E/hoaPjgTXtWKG7I=
Received: from BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17)
 by MN6PR10MB7544.namprd10.prod.outlook.com (2603:10b6:208:46c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Mon, 23 Jun
 2025 16:00:09 +0000
Received: from BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c]) by BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c%4]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 16:00:09 +0000
Message-ID: <807b87ea-a46c-4513-9787-56b2dfb4ae32@oracle.com>
Date: Mon, 23 Jun 2025 21:29:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250623130626.910356556@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::35)
 To BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3828:EE_|MN6PR10MB7544:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a0a024a-4f11-4d02-077b-08ddb26f076e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFQ1QTFKN0NZR3lTWmlJZXovT0lBK0pyZURpWUN4bmVIcnZ4bVNuU29FMEEw?=
 =?utf-8?B?cFdiTHl5dkU2WE16ME1CUHlQdlR0alhXK1hnclVqQ3FmaVgweG5xOGd2N2FG?=
 =?utf-8?B?aklSdDh2enV5UGJON3VMMG95SzhMcjRHVkd0Uk9vZGkvOVNHeEgxNFVZak5r?=
 =?utf-8?B?UjFWTXY5eDRNSWpTcUVGeG5hT3BPSzhpQ0s0aXdKR2VHdmxKSEYyMFIvS0ht?=
 =?utf-8?B?eC8ycFhoTzBVNkdHbDAwdmxnZXVINDRNWTU1L2hXYmJ6SVdFbnJIVGN6WG15?=
 =?utf-8?B?STJEMDNUOEpyZFZCVXdvUjBNVTVYU202dU05QU5YTkJrYVBiVVJ2K09MYVpG?=
 =?utf-8?B?UlliTW5mRGV2aHNhbWFRTWxhOHVJbVpKcjd5VVNPZXZSMzFQOFJCT0x1U1dD?=
 =?utf-8?B?SkZRYVpmYzJud0JEZExScGxQZ09jMjhEMHFIN25oYVZSQlZqTjRIc0tSdzE0?=
 =?utf-8?B?dElZUnd4Wk9XMGh0VkQwRFBZaXB5Z3cwMUxyZjBNOUJUdTRaTElmM0crc3Ux?=
 =?utf-8?B?ZkhPQ3dLMjFyTy9rOUZ2NU9yWGYwTnZsNmZZOUFmek9xcE90NmhEaUhEamNW?=
 =?utf-8?B?Wm1lWVdQZ2dXYWZ0ZTBjZjduMUJtTE1uWEt0NGQxSEphV1ZTaDdRSGk1dEhB?=
 =?utf-8?B?eHkxeVNDeXhjMmFnUXlJMUNjYnRVQU42Z29nK2pWOEQwVm9xN1VMbG5jV3Zp?=
 =?utf-8?B?T21aZG1adlBMRkxYQXhFd3JLeHlnSjRyd0NGeWtGRHFKTkxnazQvTU8zcG5K?=
 =?utf-8?B?VjdnWEFCUmV1S0NvQjlobEZDKzNGWGZDTE1jdWVkRGhqWXp4cFRGSVRkTVUw?=
 =?utf-8?B?U2JPWjhkMGtIb0ZyZ0RRcFFpZUZBK0VVeFRXYVB0ME04cmNvbFBDU0g4VWdB?=
 =?utf-8?B?OVdIR0h1c3VtSUF6bnZnRVI1RlR3Nm1zc0FrcXRWc2lqQld2SkdKVS9CclI4?=
 =?utf-8?B?SXlkRnhrU0tueXRGNGEzNm5id0VBL2JJSnA2WkhjRExlRlMrVDBkQ1Rsb3Ba?=
 =?utf-8?B?dTlHNForYnR4a1Nrd0hkM2p0VmdCTDdEOTlISm5xWk1SSUZZTjZCci9HRWwx?=
 =?utf-8?B?czdYaFdnUytVeVVybnFOeG1IRE1QbGI4ZEdTaG5xMzRoc2l0c1RjWHFpVUl1?=
 =?utf-8?B?cHg1UStlc3dKMnB4d0ZZLzBlTzJxTDhoQVlIZ3ZDeXp0c25KdDJYNGRQbkls?=
 =?utf-8?B?eGIxTzZJWXZ2b1pIZkpDSERicXUvSm9OeWRzSjlheFlpWldJL0NRTUd4d21m?=
 =?utf-8?B?VnFsbGtucUFGcEVMbDhYU0dlRzM0dTh2M1NEakN1WEtYSG9CemxEQlh2c1NH?=
 =?utf-8?B?dVBSdlY5UHBQZG5Pa2dmWTVNYXdvbEdyZGRqRDR0emxhNURxZUg4SFJOZUdk?=
 =?utf-8?B?Q3VwamhqNGRlR3BkclpiMGNEVEpXQzVjNVBJMWtpMFVZL0NDN3BENmlWenBy?=
 =?utf-8?B?VzQ3YlFxcHN1R09FQU5GQUZZU1BaVWNGYzdFQ0xNaTlKSTliZGpDbFQ3eVZF?=
 =?utf-8?B?RGtnVFZLWHV6MGJZRSt0cGhoRHRZZDBVaHk4SXowQXhDVGZLZ3NGNFgrTGc2?=
 =?utf-8?B?bVAwMjNwdEQ4YVFwVE1jSTJhZG40NFJsakQ3M1B3b3ZqbjRTNFk1cmlWN1BG?=
 =?utf-8?B?YUowNXRWSjBPNnYzSzNOUGtCNHFSNXA0RjhUQTNpRnYyVjZSRG1TZ3VKa0pp?=
 =?utf-8?B?aUoxcDRYUkRmSmxqRTJwamF4b1pQVEFJOERYQ29ldXdic3VqUU5uM1NkL05Z?=
 =?utf-8?B?RjBiUzRWLy9sdmhzV0JmOW5HeUsvQ2d5czJNZEZhOFpxeEJpNDdla2duaWp3?=
 =?utf-8?B?YTcvZnVBU0Vxc1lZdm5qUUJJMDF0WEpOVXVwYXBtQzFqQzNYbjRISEZHcjVy?=
 =?utf-8?B?ZXJoSU9VU0pMRW9RVWJMcFJpUCtESXYrRUJxS0JHN1V6S3BxUnc4azR2TVMz?=
 =?utf-8?Q?I+w7ju6WcdY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3828.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWNPQjRmcWxMTU5vTFNES0hjdDRuMk5nSmkwRnNaYWpkQ2g4Nm9ONDBFQVFl?=
 =?utf-8?B?YlJWSlNLT0MxSlFLVWFNVkFhWVNnOEVWREIyN3ZXb2x3aXZCZUd3L2J5RDA3?=
 =?utf-8?B?YmFPdWxCT0RKMWVYSlNFN2p5cXNzT3Jwai9GdWZUZ3J4dXJ0U1QyRnBZQ3pi?=
 =?utf-8?B?enVpTjA4SGlDeHFLdHZMQVBJYUJrRnAzdElWYy9sWjJXNmduOElLcEJzbklu?=
 =?utf-8?B?ekdjdEFGeWVQak9LVGhSSTlMMWtWSU9yMzBHQ0hmMnRjaEorOXpmeXdTd0g5?=
 =?utf-8?B?YytRUHNFT3R3dWhqdkt1ZTdYbExndmVJY0hNWmZoUk55aVF3S1VtSXRvaTV6?=
 =?utf-8?B?RTJsWGVLWExWK1dpeC9zd1hKZFJGVjNWL0lRVExkTmVJY0ZVMkgxRDRrMnBj?=
 =?utf-8?B?Q0JONDcybnkzaGRTV1J5TXFkdjQ3d1J4NUc0NkQwUUxVU0tFUzFXNU9XT2ds?=
 =?utf-8?B?b09jN2diSllFeXVxckVoQmVFYzdCcW14eWh0Z2NWblhjMHVSODU4NkUxUzR4?=
 =?utf-8?B?N2NCVU52cktuaHNGVGhXSFlYUE5LRGgxdkJBVkl5L3IxRFl6ZXRxMUV6NW1N?=
 =?utf-8?B?MTFvcWI1OVUzNVh5UDk5MlpMU3RDYjZsY2dIdnZjZ3R1UXc2cS8wekF6cWMw?=
 =?utf-8?B?YWNBbDJxSzcyQy9pNGxFWi9yeGkxNEp3c1pQZWxEK1JaR3ZyT3RIMTdhSlBa?=
 =?utf-8?B?SElPbmFIQ3ovcmhKc3hLelZ0KzNUTTVEcWZKUWV5MDA4bHYwMFhxa0dhc3ds?=
 =?utf-8?B?QmVPYm1ib3FYYnRKWlpqaWEvUkc3SXNodWdBSDIzTDc4WlA4UTh1QVBONEdo?=
 =?utf-8?B?akxqbGxJZmhtQnFsbmM5ZE8yT0pray9hOUNDeUJJL2hLSGxsZnBJQTMzR3dZ?=
 =?utf-8?B?WmN4d1FnYmdIYjZMSFFETFhGK0FueWE2dUlPcUlCOTFHWUdEbzFzejRqZ0Zo?=
 =?utf-8?B?UnRXK2orUzJBZmRqZ01LbkNhSE5CaWVVT3JkWnhuSXFqL1B5RVh2Sms2VVEv?=
 =?utf-8?B?cmRQRU1zdEdRTkw0cTJIUHB4T0ZoU3U2emJETGQ2a3RyWkFHSjZBS3VNOEZp?=
 =?utf-8?B?MGNVU21ZeFZIK2w4ekQwYllPbVB2WlZTMStLNjVNcGZrSkRpL2I5aS9FNzVt?=
 =?utf-8?B?RTk3TEdjYkI0OU52QytFY09aajQ1UG5YSW9RYUxueEVaeVM2RVd6bWQ0a2FM?=
 =?utf-8?B?OHBZRDFlSmRhUjF4YXl4aHFtRXlucTh2S2YxMmZLbDhxa1pqZHBjSjVXaWw4?=
 =?utf-8?B?eWFwQkthR2ZveHVUMTN4OHBXNytWQ1YwWGNGek5QM2J5TGlYeUhMSDNzOVVD?=
 =?utf-8?B?MVJuM201WXhpN2xTY2lndHlkSE4xaWNiWVkrelV3TkJ1djl4YW5OY3ZvMlkv?=
 =?utf-8?B?V1MwWDYyb09sUmR6SXJwWHBHWWttN3BCcU9lcFl4MENHN24vdEFHNVVacG41?=
 =?utf-8?B?RXRyN0locHhzdEZqeXQ2QlJnM253ZVUwRWlVenNrcGRHWDhtd1JqMnEzTHNx?=
 =?utf-8?B?U1M2eTVmamgzeEdJTUdTYzE3azgwRkVpQ2ozc0FoTVcvVGR2VjhMZ1hSaTFJ?=
 =?utf-8?B?WWtQbmMyeVFZaDE5V2dEM1EydWdWQW5lQktzM0RxUTlhV0JaeWRLbllZTTNz?=
 =?utf-8?B?SmUwa0MvSHo0eGw4ZllTTmU5ZWw4QmIzczRxN1orTzVRam1iZWdFZTFZVHpE?=
 =?utf-8?B?bWN4bGNrWkl4VDdwQnk5U1BCZ2pzYTNxdDVicnQ1WWNPa3MxdFZ4NzIvd3N1?=
 =?utf-8?B?cGd1MHI1Sm9OSEdCVzlGek5PalE0ckVaY0x1bHRXUmgwb2lZSmRMbFJtOWVI?=
 =?utf-8?B?ZWpJVVQzTHZWSlY2RWZDTmpKSEVKUmRTdEl0REEreEgvVXZjVWVBNzlkK2JW?=
 =?utf-8?B?WGhNci9SRkQyOEZIT0RnZUQ4TVU2WkFMcXdNZUdvaHBwYzMvQmJkSUVwOUpP?=
 =?utf-8?B?cHpLMDdVRUV5bnppMVFkc3FoRWhPbG5RU2QvMDNlMFlveVpaSTVVV05EdmRz?=
 =?utf-8?B?aFZpMjM5MVhYY3NHNm5maUhDS2wzbFdnZWFaODRkU20xODJnWjlDSEpMUTBL?=
 =?utf-8?B?K3FJWVdOV3F5TzZQQ0JmRWtxYXMrd1piSHNPSWltQTBoUWVTMTBUV3N4Z2U4?=
 =?utf-8?B?V2xNeGtBMHpGVE5KTmpyYkFWOWhGaTcvMlk0bmdiejhYNnl2Z3JzRlRPMkox?=
 =?utf-8?Q?l+1SReUJ/15ygVd28TbbJQA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/zkZLJCUA3KywteHYUwu4fvHZGNzQ0LR0ciJxVI6zVhVTjpExmmOLZ8VbqUmLsepVy26lB11gBk3hlm8VtrqibSvVT0lM8R2d9tuPhw/1VONZXDS87YeorMA1PlW/nNbv5nMEcGn+RYmbqcqbze7cNl9fEN6k1O/6RYwSaJyYl8pj5MOBIjkuCrm2OyP32LcYy//ZaIO1Bl2kCMeIV+I8yyB9VFM6+irfIU6s0Vo9t5UcvpvV5Y2MALD5vSWc8GQkdeKSQRfGhmpAtUyygcuPd/bLPgIZ+FpD8Xs7uggYbQHN3rAQ25pZ/M8LD04+qwLobLIyAeP17IvptHDZ5+6rCRsECw6rAsWkIRilCPtayAPMoK+iQhsafe63PlKrpv0xD6KEPuT4aBIXQ49n5xd8Zq9exLIb5bPOVG4hhhVSctZJFDF6ZLm+y4sGXM+9tQqRKG6dl1/xAh9NM2ZBEQDVwCh+x7CLlxz4ihtofXXIDatP3XXxsyyGb9w5d3pGJbAFZu10Y4KLJSnkfbNey5Yl88bHUCkYBV5Cbr6XN+pMSa0z0IgwjKfSiVP/CzET20aWGse0qKyydcg3x0IgDxOL6bVPteOE7GZey9FHwAWbxY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0a024a-4f11-4d02-077b-08ddb26f076e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3828.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 16:00:09.7200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9GpWDOtRIwrfUfczKAzF5n6pKK342sWKYG3flV1ZLULbGvEPdANK2xBM0FvKJJgmhNwRxqyZmJ85EpTb2sGQrzwyMWmSB/U9SCtSRwBpk64ePs/R0JSIhDAVoiwKU+0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-23_04,2025-06-23_06,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506230097
X-Authority-Analysis: v=2.4 cv=a8gw9VSF c=1 sm=1 tr=0 ts=68597a0d cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=rUD6_5gfAf9ZWoZ_SH0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDA5NyBTYWx0ZWRfX2T9bYl+zfUkJ wnUn1qwBHOagnaL4cWBzjzIwtlt13U8skFOX6TT7WVaccPhbDtYH+BMfq1xfaf5t4eM/RrqLDLL SqB5+6LbVR9ZXC29nKyy3RNvEdLJtwxtMTCGLge/RTvWkIZo+v2XfKumW9CyARlculuZSJVsy1K
 yVrwCaCwGjdiuglacpxCqssh+lstKe7FO35Qy2IQNd6KDQeVx8TW11JdPfOHpwDN5sno2RxmhEH TZTsTyKkzCELdamu50PBwq5xukUDBw4Yr2w+ai2fgaRu5yEb1Hii8MO8uZfTDN79IQFfw4L/7al zGRiS/XwNXxgQfWkWhPs+trY5lj3ZAeakGlmm/wdp7LhQEBWg1QHTfmDs9lpGHRkDRy/8r7oFew
 cpKRjRIT2qiO1jF+EChX1ifege9WQ9UfKQEDmpprII171jFnXx9C2DnfGXeuRs2oaqaqNgue
X-Proofpoint-GUID: HBJSCfvoii_VsArn-HEj3UudhinmXgnj
X-Proofpoint-ORIG-GUID: HBJSCfvoii_VsArn-HEj3UudhinmXgnj

Hi Greg,

On 23/06/25 18:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> Anything received after that time might be too late.
> 

Build issue:

In file included from main.h:14,
                  from cgroup.c:20:
cgroup.c: In function 'do_show':
cgroup.c:339:36: error: 'cgroup_attach_types' undeclared (first use in 
this function); did you mean 'parse_attach_type'?
   339 |         for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++) {
       |                                    ^~~~~~~~~~~~~~~~~~~



BPF tool build is failing:


Culprit looks like:

commit: 27db5e6b493b ("bpftool: Fix cgroup command to only show cgroup 
bpf programs")


Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.95- 
> rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

