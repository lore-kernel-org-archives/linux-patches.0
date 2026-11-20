Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795166523;
	b=oXHMq1zQQx149DQbNPiuIQQBEobhx1pVMeo61lpOIry2egsqXZP20w4S4bnuEdlbtwv1
	 cyg3SH/8JradZ9YtXVrVORgQp5kE+WGgzWzOldZeMSP+LPrbmdxRrxwZuHqYU7sAWPUW/
	 4xr7rKEfozNI7onWqjdM9cChDgOw9zh4nXnY3tPXoEL77mdLzcPBfxTPtOWNldL5/D1KM
	 cViP5EBIo+KPvE/6DMX822rpKz1rpoDDmcdYMpukZxYPuTDdyGwtyXsHo0GaCDA0b9j51
	 IDTL4IBVo4pFqn9p7yLyKGp4jFQEr+IIG4gkJgLaXSvPIH99bk20L7+TNyX6UiHGypA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795166523;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID;
	bh=ZppyLx8y6me5gNfWUFoMw066QMm3bwne1RWt8PcUCL8=;
	b=0aFCP0DGDHcoJTj+Wq2FJroS5kPgvmx/RyQGk5m70Rilas7EzbDb41Wg1BreNrcmQ508
	 qZd0oLOzHguQXFiCNZNNtbiVvDJWpQLKODYXd/U6RLp52CG4Nu8jN1H8QN5vQAI39mkbu
	 6w6jOEqL98NewS1WiaQSe7wKJ7GJdE/Pi7ykXtlod/+3zK0EBJEqvyxKbfvl9Maio/4xu
	 vclmaueUu6iH7GLhIrAYEY/0nrDfc76VUbEXHUC2a5VOepnOlVITq+ulHIjw+ibhS/keH
	 dudyJ68d/cDlaK8cT0qZg1gCV35+TfGpTTll5iJMvO8gDTwKr5fC9JsER+NV+wKqmUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=VCWOjWVm;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=OcWS8Y6k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30DD606A320;
	Fri, 20 Nov 2026 09:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B30DD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=VCWOjWVm;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=OcWS8Y6k
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3oItH4078748;
	Fri, 20 Nov 2026 09:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZppyLx8y6me5gNfWUFoMw066QMm3bwne1RWt8PcUCL8=; b=
	VCWOjWVmu38pXHetnxySNj3FFUg2Z6JCbzIxRu7xhFz6ISoYJ6bfhGFffoAyYdd7
	p2LRO2FIoTIBAJIbMHxSPzyxvUcVQVEjihBYFQcAWhTH/H0RcmPZRT4BUwOEXJ8V
	O8WEVuD4cHZoM/srSVdL7rXk6ltB9jbp0hlUQMFEfz5QBOMaQU4A2xLgSjNjR619
	WE41GNynGJJ1EiacQDmpIEwYgM5SWmMilC89IJ1IkVGASyqgop39miTWSfZ6MNbP
	9KFmZh9haJIOXC84cBcbKOLsWrIcZip/2ThmqURHdxe8V3q9Q1DcxoQgLVXDTLIt
	NtD2WceMAKJHGSxSLJgwDw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytrcdkv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 09:21:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK7eIdD2970414;
	Fri, 20 Nov 2026 09:21:57 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010019.outbound.protection.outlook.com [40.93.198.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2hksmcpt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 09:21:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pXsX8UT21j31x9sShehoD67U5HylwGv9SxYsOeu5S+Ll+Xj3/lcQRNqT0+E1JayLC9gutN9WFg13zzGb8pmDDymFjsX+pp0m2IEJ2ShEL3m6jJ/lRBFIHIKZyr/9GZLM0crrWI2fBqp6E3saH4h5+knnYa2uyhsmwwGET8fNDUteh+Ol1mYpqUib9taQ1/ufXQ70CiK2AGQrGf/cJT342GjogsjAnIP6k+a8De5WPSua/yRemdRc5Ft46AkpxUMQtNl9SGzwLwKxfoiZIYWjpcNWVeSAGXhNu2T2OknLEG8ADDdH9DYOcsh6ITJU1V+QcFeDt/AlO/F5latRm8VXrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZppyLx8y6me5gNfWUFoMw066QMm3bwne1RWt8PcUCL8=;
 b=D0xxVv1yPJzzjRIw1HLl2kMtCLfICeP6Vjxg+PhcKatVufmQnOheLA0eoju2MpfmfYx9cqCn3+PD3tvmBDNstIqwJZd7ayvpF49S8DwdUGT75ONfzUykivmhBL+zwYMmVnOsB2T5H6/yHSgPPJzZzG9AQoPH+SN+K1FFNpGMtZFE/DHapZrO73LDJ7mnn2ZGGGaq4bq04q1eY7f/BrcdTj4iEEYvikKCBXQVrTzulbIG/z+BZarNMomKNSVAxa+xJCqh9O9cceWcn5ys1UFQc9mmbRdB+frUcWlV2Xj0ZoR6K5AL/q6phpUTfnbdVcEeZ0L4QWK5A+TsF3irIy+oHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZppyLx8y6me5gNfWUFoMw066QMm3bwne1RWt8PcUCL8=;
 b=OcWS8Y6kp892dt9PoVaWomnmzTv7dk9wdqAV0BD4Hv95ULK8A4x0/m1VU23K7coWt5412Y8TcyXG6gxO5z23E9ieIuj1BCsOhbH9LIl9+znmZMGAxue4Gnm7nFPvhwngPMh+64lXSUee3GpO8jIcfmOaCFEvPUGagO5SyoHpavw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV1PR10MB161780.namprd10.prod.outlook.com (2603:10b6:408:513::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 09:21:55 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 09:21:55 +0000
Message-ID: <4d03745f-1cd4-4280-965e-c6527f3f3c07@oracle.com>
Date: Fri, 20 Nov 2026 14:51:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0810/1756] power: supply: bq24190: Remove redundant
 pm_runtime_mark_last_busy() calls
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150041.869799943@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150041.869799943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0679.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::12) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV1PR10MB161780:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d380c8-a601-4513-9aba-08df46e7b833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|261022105027099003|10067099003|261022075727099003|4143699003|56012099006|261009221227099003|261009223027099003|261021123027099003|261102123227099003|261021121427099003|261028144727099003|261026140227099003|261026121527099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	joWZL8wHFd4S/Hr7lM2DAu6jRccXQSbLRrBqE+DdE+F7EwUIklpX0d57JJk9tzqCvwclxhJ+2XthhMOYRzCLOuPDIE2uo2YdtpxM+nahn7IcJZ/GxzuZX4cSfldCQdpF6R1eG/K7aglNn3tSGenRt0p/AMCn9aXqpVcgcR/xOzbAmt7o6+f6solpNe8kuD/UOt0T7mlNV8mEfFsNn+Z4LYGNpor3RjEhwTxvoJzptTeJqQGGKyMjI55SbYi9b3YjIS7qhElXnaZrOpNRmsjSBIC+B5s5YwnvmSgT6OszPQ9WxTO+EB1G7Nt+/LdI0WfrxpQEqBBnQd3mClZ8Bd8zMzMFfW0Y9cyEnJLqYuwdpy22/JXUEIGntXKc61ntpASQjjfF86w3p5Vs5QRIoblGJxJbwnLeyS3hAt14TLAaUl7c68eOL3G4NkXSHUkRWOZrOPa2woORrigR+HTlEToENPIK4+eAoUpHwHHNxqj/nnEVQ9AYUVJb8ipJDCzbHPRYB6YHyFbrkHXqehla5+hoB/QXAGMK/I2HW1R6farTCuHgpNLvxF1riEh3pygGteWXHCFtBOeXtAXryywB4rsuFd2aBSr9CsMrd3r5Nn3Iv1bcmpaqgbRUr7z1mJv1QibY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(261022105027099003)(10067099003)(261022075727099003)(4143699003)(56012099006)(261009221227099003)(261009223027099003)(261021123027099003)(261102123227099003)(261021121427099003)(261028144727099003)(261026140227099003)(261026121527099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFFBNmdrTjBSb3l3NEhWL1JqV29MbU1uNFc0anhHcXRQUTNEYjNDTXhGQVFm?=
 =?utf-8?B?bjhDSTVoVVRPZHlEZ1RoS09zY0RtWmtMWjNVYjhHeGRiNld3aVNIc1JTSTFT?=
 =?utf-8?B?ck91TS9pMnA3anl0UFhCWkdIeFFuakt3NUw3Mmh0K1Urdis3WEJkZlBod0ZP?=
 =?utf-8?B?bFAxVlhOTFdKTHcwTll1SXhTWUNXeXJYeTJ2aGZZeVBnZDRpVjI3QVp2NGlL?=
 =?utf-8?B?MXdoanZ0WG52ZERwaC9TYjhRcHV4cG4wMWpkZ1dIWCt6Tk9TRTVTWmZRYUhy?=
 =?utf-8?B?M0ZYdlFObHdMeFQ4b1FWbUpQRDI2RjNVZnpZRHJTVG9SekF1TkFNM1BOTXdH?=
 =?utf-8?B?VS9VQmZZaHhNbEFXVXJFMUVMcVNURHM5RisrbzlmTWxIS244eVVJNjZXcmta?=
 =?utf-8?B?RDZJZVJvelprUXN1Q1NrK2VHSXllOE9HN1d3RUpmbVpKUjl1cUtBYTI3Nld6?=
 =?utf-8?B?bWtIdXFrK05WdWt6NWtNenVWYy82SVlQSWdDTEpyTjJtN3lDbEdpMDZNdmdE?=
 =?utf-8?B?Q3dMRExxUjMvM0NWdVJBcUk2UFk5SHRac2lteGFRWVJSSzlYVUwyc1MyN2d0?=
 =?utf-8?B?Smk2ZGt0RkdNSGVtUjVqanEwb1NDNjNmK1QzdUFrV0JJdEplY01lendZbjNa?=
 =?utf-8?B?QVNUR1FaVXdoWmQ5OXFYUUEzWC9ZZEJNUEludHhYTHoxa09tckxPZmNmNG9W?=
 =?utf-8?B?MlgvMEdIaDdKSHVVMU9iYm80S0gvVGJoQ3lhT3FhamNQUXR5b3NmMEJPQzhI?=
 =?utf-8?B?cURyc2tCdDNTTjd4YzZRUEh1bkRxenE2UWRlbmFuV1YyVnBXVkYwUmdETmE5?=
 =?utf-8?B?TWZEc1NlN2hDL2hqYUY1WlM3aWpiTXo2NFQrS2MvNm5sRlNPckdIMWpoZk9x?=
 =?utf-8?B?cFRIMFd3MjBPNU1kSk9VcDlrYzFzUEdlZ2dvMXJnU2dzRGptNU5IZlZXMG1j?=
 =?utf-8?B?QXRJWjNlaDQ3bE94STBxaGdZTmxrRUtxOFh0RTVRRzArSDVLbU5wTVNJWU51?=
 =?utf-8?B?UURLak40UWdvMTlXNnU2TVlSRWlMQ3l4N0lVUHJVTTNES0p1aGl3QUVudlQy?=
 =?utf-8?B?RXEram9EdkJIMjk1TWQ5S3NxOFZSOFJmQmNUNmdQdFRXcmxxWWpxUmtWYzlo?=
 =?utf-8?B?TnRiaUh2SzVSQ1ZqTGZtODl3OWphYm9CellUNWtDTFBKQi9OaWZFSUZicEhG?=
 =?utf-8?B?My81WWkwaVY1Qm9GRkhNWHRMQW1rZVlpYTdZM2EzLyswQkNaU1ZwZjFGSzd4?=
 =?utf-8?B?c1ZjUW5QRVBWMm5jT1dMNU0yNC9hMm82aGV4b2RJT0Q0Yjd4RXdpYTRRUy83?=
 =?utf-8?B?WE9Qd3ZQM0tVeGMxMXFYTUwwdmZxNy9DUnBuUzY4cU9URXBoYlA2R1pkZmVr?=
 =?utf-8?B?QmRlRGU5cmttWmd3NGRmYUljKzBGd3ZtTkhwWXRYTFpHam00SHh0WGNjRlJr?=
 =?utf-8?B?Ylo3TFd1NFpYVS9CSkI0VyswY3RHY201NmJUeG1MOXc1dDBsR3ZsWW0xZzNy?=
 =?utf-8?B?OXRLVFN1WFhTQ0hRb0Q5T2VQRmlOZkdiWC9CczVTaUFkcHdBMHZadlpGMWky?=
 =?utf-8?B?M01XRDVyaERGNEJPaEUwWkFEeVdMeW5mLzNhWXpyaTFiMWcyelFQRUpFanRp?=
 =?utf-8?B?U3hZaGxtR05pVGxBUlBZbFk2ZlhNWUIrMmpwOXg0V216ZUpqSGdlejZRS3Rv?=
 =?utf-8?B?RGRKSEVSUGNRSnN5bjBMYlNwU0ZOQjhVbUs5RGpjcjA0Qk9KcjlodmdNV2o0?=
 =?utf-8?B?Zm1UZzFrRlRTb0o4N3A3NURyK0pWV3d5UlhWNkZJTmNqQ2I5czZmUXJaRE1t?=
 =?utf-8?B?bVI5RDBLQjRBZHR2MGlPL3IxWCtybTVpL3VKcmR4MzE5eWxyVVMrbVVSM3Qx?=
 =?utf-8?B?TGsydUhyaU1ObEpoWTluSmJwZUpLekhjaFBvNkxQYWtjQ3dsMXFCYTd0NjBR?=
 =?utf-8?B?Q2s2L3lmSHllNk1EdG1LTUdNaUx3VkpDSnc4TVRtd3RQdnVsaFBmV25iNE5V?=
 =?utf-8?B?aUhJZko4TjIzSzNEVWxFbWZhUTFDbWNoa004NXRvTlAwLzlKY0lVWDROUGow?=
 =?utf-8?B?eHNCbjR5V3JlcERXam5ZSng2alFtWGcydFAxTUQ4TFRRTUtPMmxuWldlZDNV?=
 =?utf-8?B?dHJEbnBmdTRVY3hsa2pwRVYzVFlOZ2ZyV2ZPWWN3ZXI0Zm1kbnV0ZXJWYUZt?=
 =?utf-8?B?RFdmSTN6RGoybjhQL3o4VUZVbXROamQvTEszMlVpWU1CRWY3bytxTEY0aDIz?=
 =?utf-8?B?RTlYRnVOVmpnbFNpRE9NRVdrdnVhaStsSUV4RWg5R1BCdWo4TTdwK2NRbGJR?=
 =?utf-8?B?eXlkQjcvUHZDbmo5UnQxU2VDN3FSR2NhVUhvbFJjWjN1dFd6VkVEMXB1R29X?=
 =?utf-8?Q?LmlY58prU2kehFNc=3D?=
X-Exchange-RoutingPolicyChecked:
	Ep4hTxAeRScvENgBNt1tV1pz5ITCwaZLS+pznvn/exd5dprH/9ObaHmy/hnAvSziYJJdZBfRmPz7o2+8wkAPc4W5pgJz6dwkji8QvsNGUNE56SlpSZPFXytXDfwYj6TciGIE75aXw7iEXLKXWQj4m5/2P5qnXVz207HR8oCrCsl/B0kIlAE8N9207BzpQtKNBTpbhcx8842U/Cf+eZPXc0HJCmelquhXb830hAuUanmtvWLG3mOxqvddKqq98HybUQo2tR4oxwBbcdSW3aCoBvnzfHSw6OOK6QUhCqn721O6i7Fw4oiLH62dH2ZmscQtil3ouP6Ra9GHXVT0AE6Ukw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z7qXHUFRNYJ0vrUoWnKnKT/weLCN6uvMkEKFJbpZcA/hdBVnmtddnIxefRlczw2HMElfIj6FeabR31GljYLvla9x1s61mH6JcRw/NcYF5vlDx2EnQ93Dnav0p8Vz6qxkP62XucVljbANjpoXQX/wxsX5VJIy2BX1QiZyFQzTy4lN0ggXA92DH7Ri+/9IIfypUENdArOp7yx/URVG7tTwan2b8w24CAevkcUh25jWYUoevn6fmrWYh/BClovfRVF+7f7jSIW4D9/nPV/YAAvqtKr3BCmKcO0WaVz4JafuWpUCT9Ty9prx0l5J/8Of6+1xF+dRtSlSIXchOQadrLmZex9hJ9jBAHgMcLXGENXNWkj0xDX+KvC83qgi5uVPWkW9EeySzFJUfmacTe9dcbFQ7YcPHiUYeR7T+dzkXaMpMzT0Nza8DddnkQiKKVTMHxt0zlrLvUjisdk8vkOsVWuyCViRgXqt/R7/xbD9gB5APyHEBpSBkjsuk1dM9ELeizftz8/JdUQf4nwwpJzDGlK0whdoIw5WO+KVLkCjqexC8syhuDExMb+FY8iSfRxHpF+iAzxHolVL0rQsFFWjcR9k28nL8QlJWN0nlDMazsfazFA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d380c8-a601-4513-9aba-08df46e7b833
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 09:21:55.4497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NUzdLwXXthuU1FuFnzERHV146aStfcwJk2yGuH3WtquGaG4cUaSdaS5QePvHTmJJl+VxARJVjep8kcanyZmfyF6RcDfmsU7gHI/eAygTASuWsu6F9zioFIpUXA3D2auW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR10MB161780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 bulkscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611200036
X-Authority-Analysis: v=2.4 cv=f+Ldl+yM c=1 sm=1 tr=0 ts=6b001136 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=QX4gbG5DAAAA:8 a=xG9xdk2M0TmoXJ-MWSEA:9 a=QEXdDO2ut3YA:10
 a=AbAUZ8qAyYyZVLSsDulk:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12100
X-Proofpoint-GUID: P6tytlfL4FQJCPCAH5gDgNV_tv48loc_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAzNiBTYWx0ZWRfX4HsMyAJbsWRP
 10pA391n5ulNTISyYTPfY6nLnwhnwCB+hSlIhOBkRc2x9wtMFmy1vB2avcsbopHfu8c5ZcJ+kuO
 crHhuiZFF3iHhpxV2W92Xa1SBQoZOfGrbtqoX0Bdl3n10zyIvQ4LeraJph6znwYH/C5wtPNGm6t
 tVRz/b1ntDUAObVg0/1Wx6f55ZNCpBrypR/EhwkwRKwzrLt9k4mDqGTw/hqDdZsVnlZcTSC01oG
 rF2wkjieP2CRFyekFTc4NuKC1xtXFNQc/K+wBiqOgDla2RoSb/+BvLioEigdvws4D7pfywVEfJI
 tqFO8ueE0n20z25K5clbg9XyQS6gdm4zfLbIXw8AVASaLQ7qMCmwiA4syjJoXk9aUlwTuvfIF96
 BYSCT9TRv7PG9otR6joECIAUjON252fN8tHf0rwyYcjIcg0fHxwFzmXgWyzqmyX+EAbxOo7e6tI
 E05o2FmawzuFgbhMwyeaiC/xdGxjTneYUocNdbWw=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAzNiBTYWx0ZWRfXyt4PUJ47bMmc
 C1eSkTx3XQP4SuNSwc/uaVZXduw3niWnWwsIJFTZaAYJIHXrOBiaXvIDtTgqTzk8UR4WnMBpj9K
 iGy05rxPMxzzAZhRYYq2XNfpEdBkSP9OwqVJMc0fm9/Vpqgby9xh
X-Proofpoint-ORIG-GUID: P6tytlfL4FQJCPCAH5gDgNV_tv48loc_

Hi Greg/Sasha,


On 18/11/26 8:18 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> [ Upstream commit 2453753f395e68af947d9ac6ce37bf0eb40f7123 ]
> 
> pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
> pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
> to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
> pm_runtime_mark_last_busy().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Link: https://lore.kernel.org/r/20250704075442.3221283-1-sakari.ailus@linux.intel.com
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> Stable-dep-of: e0844bd22a9f ("power: supply: bq24190_charger: don't reset registers across system suspend")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/power/supply/bq24190_charger.c | 14 --------------
>   1 file changed, 14 deletions(-)
> 


Ai assisted backport review has found an issue for this backport. The 
finding looks correct to me.

Verdict: lets drop it until we have the prerequisite I think.

The removed pm_runtime_mark_last_busy() calls are still needed
with the 6.12.y runtime-PM helper.

Before this change, the driver did:

       pm_runtime_mark_last_busy(bdi->dev);
       pm_runtime_put_autosuspend(bdi->dev);

Upstream can remove the first call because its helper includes it:

       static inline int pm_runtime_put_autosuspend(struct device *dev)
       {
           pm_runtime_mark_last_busy(dev);
           return __pm_runtime_put_autosuspend(dev);
       }

But the 6.12.y helper does not update last_busy:

       static inline int pm_runtime_put_autosuspend(struct device *dev)
       {
           return __pm_runtime_suspend(dev,
               RPM_GET_PUT | RPM_ASYNC | RPM_AUTO);
       }

An access to an already-active charger therefore no longer
refreshes its autosuspend deadline. It can suspend sooner after
that access, potentially immediately if the old deadline expired.

Upstream's helper change is b3db492e8335 ("PM: runtime: Mark last
busy stamp in pm_runtime_put_autosuspend()").

Could we retain the explicit last-busy updates in 6.12.y rather
than take this cleanup without the helper change?

thanks.
Harshit


> diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
> index 35611eca057e1..08ba33a1aae6b 100644
> --- a/drivers/power/supply/bq24190_charger.c
> +++ b/drivers/power/supply/bq24190_charger.c
> @@ -502,7 +502,6 @@ static ssize_t bq24190_sysfs_show(struct device *dev,
>   	else
>   		count = sysfs_emit(buf, "%hhx\n", v);
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return count;
> @@ -533,7 +532,6 @@ static ssize_t bq24190_sysfs_store(struct device *dev,
>   	if (ret)
>   		count = ret;
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return count;
> @@ -560,7 +558,6 @@ static int bq24190_set_otg_vbus(struct bq24190_dev_info *bdi, bool enable)
>   	else
>   		ret = bq24190_charger_set_charge_type(bdi, &val);
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return ret;
> @@ -603,7 +600,6 @@ static int bq24296_set_otg_vbus(struct bq24190_dev_info *bdi, bool enable)
>   	}
>   
>   out:
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return ret;
> @@ -636,7 +632,6 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
>   				BQ24190_REG_POC_CHG_CONFIG_MASK,
>   				BQ24190_REG_POC_CHG_CONFIG_SHIFT, &val);
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	if (ret)
> @@ -673,7 +668,6 @@ static int bq24296_vbus_is_enabled(struct regulator_dev *dev)
>   				BQ24296_REG_POC_OTG_CONFIG_MASK,
>   				BQ24296_REG_POC_OTG_CONFIG_SHIFT, &val);
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	if (ret)
> @@ -1373,7 +1367,6 @@ static int bq24190_charger_get_property(struct power_supply *psy,
>   		ret = -ENODATA;
>   	}
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return ret;
> @@ -1415,7 +1408,6 @@ static int bq24190_charger_set_property(struct power_supply *psy,
>   		ret = -EINVAL;
>   	}
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return ret;
> @@ -1673,7 +1665,6 @@ static int bq24190_battery_get_property(struct power_supply *psy,
>   		ret = -ENODATA;
>   	}
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return ret;
> @@ -1704,7 +1695,6 @@ static int bq24190_battery_set_property(struct power_supply *psy,
>   		ret = -EINVAL;
>   	}
>   
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   
>   	return ret;
> @@ -1852,7 +1842,6 @@ static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
>   		return IRQ_NONE;
>   	}
>   	bq24190_check_status(bdi);
> -	pm_runtime_mark_last_busy(bdi->dev);
>   	pm_runtime_put_autosuspend(bdi->dev);
>   	bdi->irq_event = false;
>   
> @@ -2160,7 +2149,6 @@ static int bq24190_probe(struct i2c_client *client)
>   	if (ret < 0)
>   		goto out_charger;
>   
> -	pm_runtime_mark_last_busy(dev);
>   	pm_runtime_put_autosuspend(dev);
>   
>   	return 0;
> @@ -2247,7 +2235,6 @@ static __maybe_unused int bq24190_pm_suspend(struct device *dev)
>   	bq24190_register_reset(bdi);
>   
>   	if (error >= 0) {
> -		pm_runtime_mark_last_busy(bdi->dev);
>   		pm_runtime_put_autosuspend(bdi->dev);
>   	}
>   
> @@ -2272,7 +2259,6 @@ static __maybe_unused int bq24190_pm_resume(struct device *dev)
>   	bq24190_read(bdi, BQ24190_REG_SS, &bdi->ss_reg);
>   
>   	if (error >= 0) {
> -		pm_runtime_mark_last_busy(bdi->dev);
>   		pm_runtime_put_autosuspend(bdi->dev);
>   	}
>   

