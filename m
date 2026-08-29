Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230657083C
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 20:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788036466; cv=fail; b=fSDUG7jv1xayEvybsZvakmdxdONN0alCaLOyq64eAOk+GWke8paP9z7iLssDl9C2Ku276A0X877JRkBlx4lr6gITafFbd7Zby6l9/pGIccFPh7GVQaf8sIKUMngrgyzkkXvi8yVv9WrIns/PqZHOjJOail5NyLwS4MvFdaZsuX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788036466; c=relaxed/simple;
	bh=NvFbSCVK64BLFuJtx14XRnzxkQJD3DMALgwht6aVstM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aUKK9yMF5NdfdRPL8jPJdFhJOHTbTlp6BmLs20khEhN18nJfXNVMtrYRFLH+FwGS2oQZMpF5EMmvFT3GjbHh1+9p6Q+xpOQyDqhN3QNMGHKorHQllks0bHMmO6WW+txcMJDkqjnVxTnV21tZDWAjGyFlYVQNZvVfw7xbCGes2mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=evz101qj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ebw20d6X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evz101qj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ebw20d6X"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TKU2Kk2965268;
	Sat, 29 Aug 2026 20:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bcLOQqL5bkCwmXVtm0TCPVHxX+oT8s9nodhekAET+Fg=; b=
	evz101qjgxMFIoro9YzMic3j6F3ljUsdkM5n+2K6mL1EHSJNt+6gUOAoQ0KT4QjT
	M5NQAwmTgM7U5BLWO2sVWbWUF1wboAQjkKXTIqgvwLkshcY0+5gWSemVZBrXjsA5
	9ieIEzD4bG5CDbfNzne550e0rWWnMHk0NpCs35tRWB11+eR1zR4EE8w3kXGRW5iI
	/8yHt57Md3HAbMlxU7Pmrx8dLs/eNwMQ6sPNkD540qGu5pbyj0soUcGKpWJHG+z0
	CQnI+8s8LaxXg2beuhUFM+sqqBQSH5JDuycLR2wyMBQ+bJkRnejH2Nc8AzqEPgua
	IQ6WCOShxlKlUq5LXv8/IQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqfc0kx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:47:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TKjTik017104;
	Sat, 29 Aug 2026 20:47:40 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010036.outbound.protection.outlook.com [52.101.61.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvn7x10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:47:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=chfaC6jUdoFDx4hxTQLv4HORpobgaN/+SfPXpryNRY+w5OmAVNOkH/XVG2ENpIAkb5bxgA+5m0G3MB5YUwreO9JDoULV0PGR5lRKyn+XYxSJGEYq3YS8HHp/I1wF29aN68Wsaj/9MCwAIHqGjFXA3kl+NF/rxVch1TrTIghHCa4EjKGK9+JgcbrQ4I7WIEIYKNcd1SMzCnVa9zTrVL4oS6aj15qC6+N+1zREzbG70+oDF1Ta52HfgYFUQNyJFAq3Ena9mnW5p14bsm6pJiW9Cr+LTAPF0zrmAT8ON1dtyoI83yXB6vL+QbP6M6cvZBLeZmIffgjNy1N4spwO7AeAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcLOQqL5bkCwmXVtm0TCPVHxX+oT8s9nodhekAET+Fg=;
 b=zDJ0hDjdxwIeX1YrXQ7J5FgPcIMN9ttkfXCpPzM2JSZOD6nV3vfhgpc1RtNohZK9orshWKZXs1Qu2rrHUXqNCVFEX0SxyAfbh7dGQdy9IqvnNiZqeqG6MOREJq7WovK7QrrbeN7cDk5iUUqOELhLOy8Zr8xaL+0AnM36IfahMOynfykEo6SIRxCgWQLbdUYAbzLBa/q7Zi+4k0JztkK9G/3Jc33WRe8md7ZeQQrZm3ZhMv7AzgmVCeYxn2fBFqi6uTeTdUzWyo1/izDBk6rm5Iuh5yagd3x9AkO2GBOofFBB+YVuPt2FtNu2vPaGqE7AJtEg7QHQIbvLprwieSIvgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcLOQqL5bkCwmXVtm0TCPVHxX+oT8s9nodhekAET+Fg=;
 b=ebw20d6Xf/TFE8QOAkauPd9/e2WqlQPhPpdRegsUBelj8sUXImH/WWuLGkw4gFZImKy6WNfyyRFaVlyZdYUn/NxUM6Yvy1CPE4mAI+nQACjpLwg3hYJz3BF4QPERx7vWshb1jAA9FBylTd4PmMkimi4KL98kuNx6KE5CuV9KB9g=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA0PR10MB6915.namprd10.prod.outlook.com (2603:10b6:208:431::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 20:47:37 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:47:37 +0000
Message-ID: <e0c06969-1c39-4f19-a61f-1e0524d2a6de@oracle.com>
Date: Sun, 30 Aug 2026 02:17:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 120/272] smb: client: use kvzalloc() for megabyte
 buffer in simple fallocate
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Fredric Cover <fredric.cover.lkernel@gmail.com>,
        Steve French <stfrench@microsoft.com>, Sasha Levin <sashal@kernel.org>
References: <20260820145231.229664293@linuxfoundation.org>
 <20260820145234.864039109@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145234.864039109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0004.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::18) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA0PR10MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 13846b9d-c038-493c-ca85-08df060ec28a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|4143699003|6133799003|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	KYQrj9i5NCWEmc0zPoMkVtD8onKO4RuyNlXiktipfZDIWzjiHPNR3BmLqTA/ElhoX5DucaVUER2iXMtlQT8V8Rbjz++0DH2fy5UCUGavMBI1AAm6W9MCSsZKHLGlFk4wFAUygtGz5n237IjRt0gF5If5joL+awAnLTyW1IrENwc7+g1QrTpzrgtULam+UgqgtITBvOxWj4VbGZn+Rs9z1IIqdUyqWZninAW+C3+TCCjKr0VobzHgfftZxWS+R988Su50uSSfhJoIKay2tTTDP7gKLl8KWBTC/VO0W9GJzT3XP3d7PfXC+bM0MV7iBd4O10i0acUhSwGjb88agh4YpEqo8c91i1aOdpRnUuORoLmXHK5BVMSB9pNMFTDE+eKSh7W6lgH4yo4CluNa2OePZaZKLg4fyw2klC29I23nCsDDlh/lKgNqwp4YL0PgPNh2Cb71OoZJouAuAaPl7T6UdvX8pxiqjbSY9kI/VhmawBqlvMwBeNDwnG3Bw6He5Ol9lK7YDUSmiD2mZnktkGUAO78c26KtXtp7s2Scncj1tljCwgM2rK65tULONdFIDZL6eA5igAwCmHIYkOouZfhLAGiW/IZ7xjy+5kqZPxQXPSzxC40GyF/ZG3D2DBLvIq+ioDKSwmdSEWvFNPOensq6LxUlnZt6tdhaJd1WonUkgcQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(4143699003)(6133799003)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlhxNkVUK0pXTFZXZkJDRkJyZjVDNGRzckt3MXVkY2ZPR0FLc05xblVLSllF?=
 =?utf-8?B?aEhVWDVGZVB4Q0VCcjdmOUpNTFhNN25tYlE5bVpJRDRMM2RncndXOGF3M0Jj?=
 =?utf-8?B?eDhoeDVYamUvS0RjZ3R0T2xTc3llaGM5US94bkk0N0xmL1hHMURxT0tBRnFh?=
 =?utf-8?B?VG5NUGpScXNGcGNBbzlodUsyOGptdGM0WnVicDJYcTVMdEN3WEhieXB6elJV?=
 =?utf-8?B?NGR4dTgwWXhwdjlQdFlhTk0yaDAvRTVsaXhRRlVXTUxQQnJySDlZL0x3a3BX?=
 =?utf-8?B?MzNEMEJPS0YwUUpzRGx3eWY5dnM1YVNtVEFTem03Y0xCeUg4bGNsQ3o5R1Iz?=
 =?utf-8?B?c0RtbGZqb0pTMkNEU1Y2Z29LeUErRmxYSGNsWXlzbnIyWmdGd1B5QXFnVHh6?=
 =?utf-8?B?WjJNVFpML0RGRUJRZVdWMHR4dktqTWZ5UW54dk5nV0I3QXZBcVZNMHU1Y2xU?=
 =?utf-8?B?ZTRHNlNJMGIrdUtPN3BVd2FJK2J5SDhpNVQzcjdZQzlVOG04aGgzbHlPM3My?=
 =?utf-8?B?OW9teTVlUmVKaUJNRExaMDdVZGVVU09kaFZFWWExeUQvZTRMTHI3VWFhcUxM?=
 =?utf-8?B?Skc4ODM2M09yaStjaTRZYVhmNzA2ZVJ3a1RkWU1vTHQ0SThDbmpwODlqRzNV?=
 =?utf-8?B?R2hnUVZFa3JZbDkzTzFXRGRRN2lWT1RZNExsdmRhU1FBUXhZckw1ZEFpNHdM?=
 =?utf-8?B?R05RQXJUa2J4REF6UUNNVmtOTGlyTEppdG9ZaFZwRWJNSVFxczR5TWplRmht?=
 =?utf-8?B?Sk1ZNnZRT0t3N3FSelVYZmg0NFZkTW95dU81RU10aVErdkFZU05nSmxta0ta?=
 =?utf-8?B?NUV5SVNVbmcwWkVna1dOaG1YYWdFTmExd0ZLNVRvUWxBRTA4ZkE0TGZOSzMw?=
 =?utf-8?B?bEd3cVl2T3F2VElUb3NWOUorWGhmdkt4QXlCTC9JcTNnS3RUYjN5NzJOWDFO?=
 =?utf-8?B?L2hkQTRxOVRlSWxkUWxlOWxrY1lXZ3NqYmRValluZUl0VzNzbHAwSG9JOW5L?=
 =?utf-8?B?azY5TFFkM0hFbWI4anh4eDdZRU5ldExqYlFYQ05MSkY0OVdPL0FXODJoYkRi?=
 =?utf-8?B?STQ3ZmgvMVBNaUQwSDBFSzJiRlo4cEdSRnhzcFYyRjdIVG9JSjRsVmEybGUw?=
 =?utf-8?B?bEZxTjJjbnV4MlJQWjdUVzc0cnlTS3pQc1poRlIxSEhRdmYwWktlOTE3eDZM?=
 =?utf-8?B?dFB3a1JEQmRYR0pORzd3L0prM1VmSU9CMXFCZEdvYWFpU0ZTRnl5b1pHd3oz?=
 =?utf-8?B?SmdKcVRSLzFlZU5JWldBMzJEdi9zcE5hOW54alpTTzJ5MGMwM3B2TGNoOFhO?=
 =?utf-8?B?WHhlRmNBY0pxMWVUQVFRNG1sWHpJd1BFYVpnbE1mMHNmK0k2RHVVRnhCcWgr?=
 =?utf-8?B?cFdsVThsUlVEWUFRd0tSQUp6dUprd0xoOFpqOTl1SVJuQTFMSGtBU2UwbFJD?=
 =?utf-8?B?S2hOQzJBQ1U4WVpIOWZocU5XMTRMM0pnb2lUTXlIWThxUVJMZCtXK3czMzBy?=
 =?utf-8?B?aVE4TkY0c1Z3cEdzOFViZGdFYlpJT1QyNHlQS2lsV3lVT1I1RWlha3BsTHVo?=
 =?utf-8?B?YjdTeUhENEJsZzB0NlRRWmlBRmRWSmdIRXBWTDdSZTFRY3JKcHJ3SkNzcWp1?=
 =?utf-8?B?M1JQMjM1YTRUdXkxNUJ3Zll6UXQzbzlBRzhpK3lLTEk0NEdnMVgrUm94cU9l?=
 =?utf-8?B?bnRXSi9kZjV2L1EvNXZYRmErbC84N0M0ZzlYTW9TY2h2QS9lY0RtZmVmbHB1?=
 =?utf-8?B?bldMWEpUSkZMRTArUnptOXREZGNFb0REeVcyaXo2TFFDd2NoNnAyYnN3RjN4?=
 =?utf-8?B?bUxoaWl0M0UxaWFManhtNGU0QXZYR21sY3pEd0UyS0x6V3Q1Y1VSa1U2ejhk?=
 =?utf-8?B?dkpXbmJ4VC9jRDdVOG9XdHJtQ2RKWmk5am5KcXgxaS9idnF1Q3VPallpVHBl?=
 =?utf-8?B?b2dqY2JnbjR4MEVWNlJGNCtHdWlxcDBjRUsrNTQ0MWJvQmNmVXl4WUM3c01T?=
 =?utf-8?B?dHNXZkFCNm8zNno1a1B0S2lMTXRTd1N6Tkp4MXB0dDNDMkZ2c1EydWF6UVVo?=
 =?utf-8?B?RzlyLzFpQUMvY2NvRUJPeTF1endmdVdTaW10TCt1VDhtUm1qOUVNVHFGSUht?=
 =?utf-8?B?Uno5UXhGVDFENFZvK2lTbDZoS1M1bU9HOUttMWlPa2lWOE5HaW5KZWp5TWRV?=
 =?utf-8?B?VFlFQXZNT3VubTcyNkhySW4reHJETUVmMGZTbFNJTFlaa3hiUjlCQ1E3SGJ4?=
 =?utf-8?B?Si85eUVuQy9vWWRHaVd2KzFwWExDZFFxMHVxZHVJYktJMVI2SE54amJBOFNj?=
 =?utf-8?B?NzYyczN0N1FuQnlGNkEwRUl2ZFY3akVtNWtUZFZ0RloveFZCcmtoRDZ5cXM2?=
 =?utf-8?Q?pFZWcn/PwU9637e5DXBUU3pLTU9J2WIcHFe3+?=
X-Exchange-RoutingPolicyChecked:
	rsvDQy+67L/PM2C1MhWA33uW2wvhbMDD4t7mfqc9HoqCkl4ZXiyA3NrKPFvoFY3YhxEtX92SeCGzytgnd5x17jQb18e17e6oV0zl+agMxPWOqMNqPKKF9SBTzsE5V16O2N4UcTbTS2lyRr2dRzxBbBBFo5/VZxlIW4qiA0N8nz4lPx7CJ5/7vDx05IFfpwOckwqxScOPAeyDW5oLOuW/ALLskti5jBNyGq987yFFcnlg29tSFFMCQ88wsOuQR9+Cd+I/1Ig5MHRzVpCtXqO/hUg+KE9voN4Xd9spT+xM6VNk+S+XWPD8TSkHjkGEKfrCRkXAe/+jkNHJvfui30T15A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cV9zwotnq7pq6N/uWOC0yW2xSN7DvQzEDYeTF4j6sxkMtS5vNyxmnHa1y7uO+PHCrmMBX9pjQvxdricC44fQK1KDA4AE5QsXYy687ULtYi/Nt75Fy+JkKan+7ibmn/MseLDWvSWYn+YKp4cXqsbqaLFhPEd+B1ne1mXnXXVyAzIPxXxPZFb4vmp08zr2x378JmSngjZVLeWk094cnlbq6K2uFj1m4L+pO4McmXkJxIhTZR7f7+riRvsNJON4WP9vf2y8UTV0Jad9bnCODvlowfn3EN5rHro1eawdOWQYwnNrWlvdQY1dcoA5dDwMeaz+wKBQ5sq1fVjEJWZFL0E03NxUv0hLo8pj50wOMSCmqJZTZrWX6CHtsg6zSddvZyncYuKj4CS1gPgOM4wJExZZ+d6BEz4IP67AF03Hu+YtqTmcgPqWWNxiiO4MG8kD1kJ2Q08NZv6Rk7Xxd0Re9tb3Z3aQBbFPaWNYVTd9U8eDF11PyID7yd6C/hT6WCbzSsX38dP+nUwe5JBBagLBm+UXPgVSDGFN2Dbkd9S7c5cPdyNWE0viEIWm/oP+D2F1Zzy2Y1BjQmQU36SCr3DZZTXyYgQZUh7lur92gnRUlLOuSXU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13846b9d-c038-493c-ca85-08df060ec28a
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:47:37.3784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+LXJKmuwu/goKBtmvJaoRQNhfvAdnMo6leFVZH564x6YRuAvJeGRP4QtJGw/s6ZFk1S1np3dl9fiWKSVAbg/qa2XlViz0V41vexqZGZmc7zqOVDF3NDNc85H4zD2Qx0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608290180
X-Proofpoint-GUID: 9P-adueoClyGBL8cDZ_5fV_Qz9Rm_aGU
X-Proofpoint-ORIG-GUID: 9P-adueoClyGBL8cDZ_5fV_Qz9Rm_aGU
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE4MCBTYWx0ZWRfX6qf+Lz5U19Gu
 dJIMi6krSv1fNbLecVvYsf+8yEPy5oVSzWNFypYslrcx8mLNZ7dGaRtb6V830ux5DoJAhQcgH8a
 n7bxhLfQV9OncSH+RKN1pItSFg7kPST1wKRBMkcNgH/9eftCij2Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE4MCBTYWx0ZWRfX091rR7Xsx5he
 za3FtauE/x07WfNJ2ikmurpS1KFrzJmgE2II3fzjkk6wNgJtIXbOkMdSp8iFKahrrb2tAwzk26T
 2MBHAssNqNTI7iWcdSSNiZcIDi5k/VChF/xwogNsvab2rGDByIdTP7LHvtWBWfzyrqLCVPPUxAj
 KIHRT9OxCiQFNtjorrhqjGuZyaKM0BNDQb5PcD8bWNEdg0Fpx8rj4x3Wy4eq+pcSOlgykG3xUt8
 uPk1xBwzgB8f/O6GvpQr/WF6vI4dA5ryLMl32N4ZtT9cBg9RLPflrZAFUIhCZmTgH4tLmdxGqtC
 v3xqGgCBF6sYbbb6r9PWPl+KizrYq1LBccOwJg/xbys76rswK5oU/bvaotXfvFiRp+ZSfIkv4Jy
 lMCqLeiP+lXY1hq5F0RYfdVADUOJEPSFdfERfyam3SpWslwCQEt0OMAzI/FBc8o6HByvk6snU1a
 Uy8xw8C1eVdsKgSuBNeYa7w7eM9JbzmN9gRgu+Hg=
X-Authority-Analysis: v=2.4 cv=a9gAM0SF c=1 sm=1 tr=0 ts=6a93456c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=ag1SF4gXAAAA:8 a=p4Llcvx4qed9mO_3HWIA:9
 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101

Hi Greg/Sasha,

On 20/08/26 8:25 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Fredric Cover <fredric.cover.lkernel@gmail.com>
> 
> [ Upstream commit 806c00c23e3ce8eae397a40ced536ef88ae4e012 ]
> 
> Currently in smb3_simple_fallocate_range(), a 1 MB buffer is allocated
> using kzalloc(). Under heavy memory fragmentation, a contiguous 1 MB block
> of physical memory (an order-8 allocation) may not be available,
> causing the allocation to fail.
> 
> This failure was observed during xfstests generic/013 on a 4GB RAM
> test machine running fsstress:
> 
> fsstress: page allocation failure: order:8,
> mode:0x40dc0(GFP_KERNEL|__GFP_ZERO|__GFP_COMP),
> nodemask=(null),cpuset=/,mems_allowed=0
> 
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x5d/0x80
>   warn_alloc+0x163/0x190
>   __alloc_pages_slowpath.constprop.0+0x71b/0x12f0
>   __alloc_frozen_pages_noprof+0x2f6/0x340
>   alloc_pages_mpol+0xb6/0x170
>   ___kmalloc_large_node+0xb3/0xd0
>   __kmalloc_large_noprof+0x1e/0xc0
>   smb3_simple_falloc.isra.0+0x62b/0x960
>   cifs_fallocate+0xed/0x180
>   vfs_fallocate+0x165/0x3c0
>   __x64_sys_fallocate+0x48/0xa0
>   do_syscall_64+0xe1/0x640
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   </TASK>
> 
> Node 0 Normal: 3375*4kB ... 7*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB
> 
> Since this scratch buffer does not require physically contiguous memory,
> switch the allocation to kvzalloc(). This retains the performance
> benefits of kmalloc() under normal conditions, while gracefully falling
> back to virtually contiguous memory when physical allocation fails.
> 
> Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> Tested-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/cifs/smb2ops.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3736,7 +3736,7 @@ static int smb3_simple_fallocate_range(u
>   	if (rc)
>   		goto out;
>   
> -	buf = kzalloc(1024 * 1024, GFP_KERNEL);
> +	buf = kvzalloc(1024 * 1024, GFP_KERNEL);


I ran an AI-assisted backport review of d1bc345f6229 and checked the
finding against the 5.15.217 SMB Direct path. The kvzalloc() fallback is
not safe in that older transport implementation.

Upstream already maps KVEC iterators page by page with:

         if (is_vmalloc_or_module_addr((void *)kaddr))
                 page = vmalloc_to_page((void *)kaddr);
         else
                 page = virt_to_page((void *)kaddr);

5.15 instead sends the write kvec through:

         sg_set_buf(&sgl[i], iov[i].iov_base, iov[i].iov_len);

sg_set_buf() uses virt_to_page(), so if kvzalloc() falls back to vmalloc
memory, an SMB Direct mount gets an invalid scatterlist page, and 
CONFIG_DEBUG_SG can BUG before DMA mapping. The vmalloc-aware path comes
from e5fbdde430171175f32094c8059eea0d0e2487ae ("cifs: Add a function to
build an RDMA SGE list from an iterator") and 3d78fe73fa1239 ("cifs: 
Build the RDMA SGE list directly from an iterator"), neither of which is 
in 5.15.

We should probably revert this for 5.15.y. Thoughts ?

thanks,
Harshit


>   	if (buf == NULL) {
>   		rc = -ENOMEM;
>   		goto out;
> @@ -3803,7 +3803,7 @@ static int smb3_simple_fallocate_range(u
>   
>    out:
>   	kfree(out_data);
> -	kfree(buf);
> +	kvfree(buf);
>   	return rc;
>   }
>   
> 
> 
> 

