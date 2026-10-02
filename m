Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CF13C76BE;
	Fri,  2 Oct 2026 21:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976178; cv=fail; b=Gw7og7kkQOQqkqT13CpnS6RQ4lUFqL5McrgA1ocCGJjvA5P5Lk3QMw5+BRrmQP/7iaC9NqZdB+I3WRgJNEvBtWzNIW3XAPeaq2BhiKnZ4TFg4OcW4aoPaxGbiKhh/DavSDg+nlJtCt29D+Hl/592JqC+eQHpvcvJAwIbR3SBT+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976178; c=relaxed/simple;
	bh=ClqbeFRlT22tYT91qvg84Dc0U5hGIW6g6o8tL8L1YgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OeKFdiasLtKFF3rLNRFFadoP0sNNmuGppdvyYWpzI8scpryXLJ0yg0NpE4II+Oa3RNd4Ra4zza2+D27koOToBi6GZZR7EX9rW53LGdBejAS1zQj3E/GoX2BB6mu/i3UHRSvXkANl9HITLkURs2sm5IF49Xr2Mtc7jpeX1aFO6W4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Uwu4kviH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VhgHr+vH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uwu4kviH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VhgHr+vH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EbffY3283815;
	Fri, 2 Oct 2026 21:22:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=crsAu/Zr0xkrn2pmq74cJvzr/0ZCEs3+Rbiln9QCrjo=; b=
	Uwu4kviHmQQtq7SG52kwQ6t3TnHWfMQOUzJ6wR/rze7RXg8eC4GczoiGHqSQgLeW
	LPTAlKAruPR9cqiK3SMWSkrHJimSluQHu/lxD94L1LnRqMAXQF2JdEXMivecC1yH
	NH+WaHTu36BFD9L7RXZqlS19ygYAp7gOwaQ75kD/pEtwJ+ff+ploxT6eo4H49X6d
	rtUIhlPK1/vyuYZb3DI2Uk6Ja5n6cZ8TalGXuVZnxQ5FMToKwT5eClaVILEamK6H
	RvvhoAeewUG6OfVAhbCANq1m4FRs3NiFdpBsJFW9zuDvINQYDy8exkjYpxjMgxLw
	FQjZq/GvJ9N8s91DqB6QUA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4u2mkdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:22:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LK1uX022153;
	Fri, 2 Oct 2026 21:22:47 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gg70h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:22:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ivpcut1XTwYiiUGcD6Oi4+pXarBRoMuL80+MQ675GMvy/osybFjbYTNvWpjF98C8mDrYvXe1Dq8QAAg7z+Tb8mSbKi0C+CyzctZMcsMr2ofdMWrN0dGEbDrytN3rSltQ789rjUBUQWUeo860qOGy7B8W1xa6x6/vAD/RgERj/xJ32UWGq4SpoOc25FFTTNNdgWvE3tlxQKCWOjI1P/SvCjQlV+tdevVB6GFbDV4P/buhpQcU75/G1tr6hbXNxZ2g9Ydc6UA/I82fmto51LoJl4JEis9XcPZUSqbAcbVfNm9e5G5V2D/DkX72vr30TrmUtKaT4WtCmV3Ai+MhkSbheA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crsAu/Zr0xkrn2pmq74cJvzr/0ZCEs3+Rbiln9QCrjo=;
 b=iX4VyMM75/wCdz6A9vYHFPA1R27eeb+/H7qHscG0KlgH67Op2iB3moexKsV2h/uthz0f3XaO9/pacTyJ2sTVgs7GgukfAwVy86nNNmlkYVkqkwobF93F+EvtvhYl2W2qtXMO4TWGMxjsYPMOwa408Rp7mK/01BzYgxPQXRfow9ZF8h2sC+b9WFlFtBZyTHnT0/NXJdpHYVQEctRnLA5CLBvVbOlIG7aIYSWTCG2lRG2GM2uVFEvVv15z1JlwWdjrX17BIWZuLq0/kgfLOkpz4CkZDwdyMs6H5WPd7WaqQ4AxSaFq+P1g6N0wObVYSvjF8v30hsHb1l5G5WYJ1yhpsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crsAu/Zr0xkrn2pmq74cJvzr/0ZCEs3+Rbiln9QCrjo=;
 b=VhgHr+vH+IWKPCuiXd2hmnji6BIIVst0Dd3cazv2B+kMBWOB8Wy+DmsL12RxRZEKhk7ev69PDwBoQh5uZrVyvjlh0oIknSoNZWxHLAJrNRj8qxYGzevLav0kYkb10QSuvOp9fho4bMgO9gAGm7oU9zU2WjQdvPwedd/A5QXrYjY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ2PR10MB7788.namprd10.prod.outlook.com (2603:10b6:a03:568::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Fri, 2 Oct 2026
 21:22:41 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:22:41 +0000
Message-ID: <051245f8-42ee-4046-bff9-5fd2dbeaf807@oracle.com>
Date: Sat, 3 Oct 2026 02:52:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 064/752] rds: filter RDS_INFO_* getsockopt by callers
 netns
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Allison Henderson <achender@kernel.org>,
        Simon Horman <horms@kernel.org>,
        Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>,
        Maoyi Xie <maoyixie.tju@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152359.544074072@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152359.544074072@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::21) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ2PR10MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: 9536ef66-d3a2-43a8-2d68-08df20cb4a7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|56012099006|5023799004|4143699003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pzohVUjnrlHLB2gkwCSwZyJPG/Ofl6FxuZS50aHrGCFBcvz4bKmvic4j/6dcC/nlxN0VMawj36D7JZk+YySLrEGs4qnoWH3xXcQppBawgk6TeJQPliQgSU1YjJM1S/JcZgU95V1CT6HAPGcjj8u5skGctKV2RdvciASdBi4FYeDcW2IVb5g/HMtoznbbmnynH2ZoOO2cVjpUxi5AYMIckBtu+CNR6VrJWY8j8K+m3j4aKpZb2jfddGKyan+e1vvzTcfuIIljBbHm7CyUTZ7Hrme8q4XSPzCHZnq+O7mRDFsNxaWO6U4hLhpNj/Z3Gug2aLcSLdaasEj24iBKCl7R9fo1xis/V2STIFbeNifQ3Wi3rg+Fpuxg0L/uXcKfYrEX9ZkfaWcAyOvr3Fg8domCwxA9REQxRsH7n/95Hhw3irpArOnegCr6wbuQhg0C8juZzLJikL35DrnyC2DERM6Hw0S30dIbAk1JhxB9xLY9XXfJFoWpItSRfFhgOaIOqo8kTOc9risjX58Cf5i05DHby9kXrDbxIV8nKDsvxV6lKIJyB6lv8zzTnKzEpHngavN52svi5Xwba87TPMWBUwfXtYWOUzT3HX4NsCEHZVczdpSQfW3rUD8YMnQ6z3LQlOII
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(56012099006)(5023799004)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjlEZ0orYkJ4Q01LWTFaMnYxUkpETlhGMVRaeU5Hc0NYWlo0WHVWVFFOYTJt?=
 =?utf-8?B?eEU2cHEvUzJjZWRuRjhPK25TL1NOL0N6aXhXZHhFb0doY0FadktSa1BwYzlK?=
 =?utf-8?B?ZlBrTjVtei9hN0JUWGRaSDBVNHZzWEJhdHZFbEVPK21MaC9uZUVrTWh4OUxL?=
 =?utf-8?B?RVlqeFR0Q1lidlhhN2Q5NXZwMURnbGxVWDRoenM5eDU5Zkd0aDNkellrR1E1?=
 =?utf-8?B?c3gzbEJMUE5VdjhZN2dRcVlELys1bVBoTDFyd21abkR1c3J4VnVlbTBEU0pH?=
 =?utf-8?B?ODhucWYwVmRJTGNzQ1VsVnFJL3VrN3J4aXpDMFNlQk1Kb0cwNFNsVmdDdTRq?=
 =?utf-8?B?SWl4dTBkeUdGLzhSUHlnSmNsMGZpUnZiOHRYd2tRQnczSmRvYWxVSUdSWHJP?=
 =?utf-8?B?cVRsa0VsYiswanRXTGMvVE1NT3I0M2lkTjUzaTdTMEZRdFVydTJ3ZEtBMEZ4?=
 =?utf-8?B?VXRCZkhFVGFQcFp0YWlGSGtqcXlMTUJPczZnQzBDQjRocmh0QlVHVFJOZ2pK?=
 =?utf-8?B?YVNiQTRkYTR5TlM4ZG84UktUK3pTVjZpRmxnR3Jvcm1tU2dFNzZta0c0Ui9L?=
 =?utf-8?B?cWc2YVA2ZlZDNW9sbmNlaG1XdDBqdXA5TkZ5SDhlV2lKREJCU1VDYmowQitj?=
 =?utf-8?B?cnFKMVR5bHJVdVJPZzNmRjdWb2RYTHNWSWhUUVZzUTMxRWRSMmh6dVIzRHd5?=
 =?utf-8?B?V21QNkl4dUwrTTJoZTIzNFJXMURiTDliYVpXVFgzODJONzBtelM2WDExR2Rl?=
 =?utf-8?B?SmhKMlNpaVVWWW16QkVHU3hqRDIyL3NoRGVCUEZnOXg1SWM5NFdYV1V3ZzhZ?=
 =?utf-8?B?SDdWcGlwSVVJWnBvL2FYbFE3SStLRlNBS2FhUWE5ZWhmaXJNRXhYSklmVkZY?=
 =?utf-8?B?RDFrQjVWaXpsZFVxbWkrV0p3TFlSRktidGszbGJ2WkJqYWk4b1NoTW4vVzF1?=
 =?utf-8?B?RjQxS2ovRktTZEJCTDNvSzlyTWpPZDVkZnFBNWF6UkVEV2R0cHdKa2FHaFpC?=
 =?utf-8?B?MXlEcitmWlhVMUpPY3E5YS9CSVFZQlRQSUlyRG9ucDdIYnlKbm1rQTc2eStF?=
 =?utf-8?B?elNiTWhITnNURXZ0TTNRUnJ5YWJXTmYxaFN3MFppNk5XMkZlbStLSVEyVGo2?=
 =?utf-8?B?YmMvWGsxd05xVVlhVU9oZVk0RHRjRFhyK3l6c2FDNUVTYWZ5NWxhZEtJK0I2?=
 =?utf-8?B?S1VqQkdrQ2p3S3FvTnp3T1BpR1VKYXo2RXF6elRpTzEyTFFCakxHRldVZkhw?=
 =?utf-8?B?OTh6QVlFUXNLOFZnbXI0WWYxZzBBQ2dBZ3J6b0VwZWw3SWE3dGdMTmNiZFc0?=
 =?utf-8?B?YTFCeXREcHBUVFVobHBGTG5hZEt3Vk41cXRJSjRNeTZJVkZNSTRDNlpvTFlK?=
 =?utf-8?B?aXBkUWJTRFRMcjRkK01zZXorV3RiTnBUYlR6Tk1HSENpQ2dqVzd1WVdMZEEy?=
 =?utf-8?B?NjBXbU8vZjVUSElKaUpvd2o0WW5FbE1hcGthSnhrRlhveTZUdFdhd0JlLzgw?=
 =?utf-8?B?b1FtakE3T2FRRjh4eXRKVU9zc2h2Y25MM2R6QzFGeVBMZnhmNzV1RU9kU0ty?=
 =?utf-8?B?RFFBbVRPVDkxVEJSNjE3K244TnRqUk5hQkVSK2R3bExpekRQS3Bwczc2SERC?=
 =?utf-8?B?WVlrRFc3bFhLZ1Q2eFc2V2NQMU0zOUc1T1FNQzVvcjVjem5pNnR6NGwyWXph?=
 =?utf-8?B?TVRWY2J6VEFLNE1wc01aT3lhNkJBVTZZVTVoSW9NUWhsSUZ6QzdYbFhhNkhm?=
 =?utf-8?B?dU44S2ptSnMyN2d4d2FkUFZ6cjNMaVF6VTJsT1E5aXQ3cTVJNTA5WElhK29F?=
 =?utf-8?B?WDBGeE00N1lRazg1d1pPekZUd0tSUnhEQ2NWd0tia3RvOTJJcHVaejZyWmV4?=
 =?utf-8?B?MnNOaGsvTTlGc0l3YUNZUXFPc1RUT1Z0VzFmL0ovUXVGMHV5KzBNZzJmMGw5?=
 =?utf-8?B?NDlpbU8rV05GMTByaXUycGVvSWdiT1RtTjV0dnhGOHZnczZPQllrVVdFblIz?=
 =?utf-8?B?cDlMWmN3MFk4aWVKQ3RTb0tGc2hCM3VCNEdtMU81a0M2eHF5SGlkVE45NEpR?=
 =?utf-8?B?c25jSFBqdXpGRnc4T2xTN1hwZHNpWlAwVGFRU25ZOTQ5UTU0dHdMTWowTzhU?=
 =?utf-8?B?cWF0UWVuMGV0WXNQZFNPRmMwMTRmR0ZubC9uQzNmOW16WnlNMDR3TnVXOGxB?=
 =?utf-8?B?V01wczBNclFzSkxYMENWMkRJZzMxL2VQRmo0UHVnVTFvak13UE9CV2IvY1Fp?=
 =?utf-8?B?S2djOWZDM1kvY0xHWGdIVWx0Sk5zaXdxS3l6bzdjTEpHWTc3Y0p1UlplQjBq?=
 =?utf-8?B?UGNDYXNOL1paZERrTkttWWlGOENhMG03WGcwT2FaTFVWK0pWZTkrV2NxZ1VS?=
 =?utf-8?Q?9X4svrvSPuQ+KodI40sJ+ATVEcIiHNab4lgF9?=
X-Exchange-RoutingPolicyChecked:
	qb8fJZBoilA7oED1abAt3LQqTbkD03996tHxrgBMMPRkuRPUzBgP1vV9L3BEfgOCtJg7WYaMeU3u975eeFxyXMCV+d8c1KnyAzHOND6D3m1O3NHcrh6BgWoYjfCwEMlStjK9VqZX0KYNZSgQcVYW3DakpQnkEBf06Ko1vGZRmr8OYoi1vInrO2CZNPsoNjpxxoaDCPE3EjmwZs/A3AqTm3Kb0fpElNtye9FxE7uUQ1e/NcSsIAukH7zBjigNPGMv5RntTZ8GWL8IkH2bMOH2rq1DgFLoNgt3L01GZNagoKjZwcmsu+84wzgkKKDlKbtVwUl1WOAdInL0GqDz59ByJA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q7s4S0dkLfs+nr5H4rkF6LXAYVUARkus4LCl32RTLK9IUpIEtR6zrvmyAOz8+bo4kun85TN3S5N3Wu30moGg57Dhfg6couPYoK7SUc/cdYhphamnC0sX5dO6ATvcDW9qiShjfDIZebYVEDmg/8pI5ki5zE9XHgp3x3D+3XE0rhJEHzQBqyYjjPzJnBy0mGJf/1bShJMObd8EPP9z67m8txs2sSavkCGq5XwrKM6y/zu8gMjPFEH8xnl+/2Zjzqql2IAGJMzozzUqU5lfMESuVXZe2YSEZi8H8f3XD0YrbNsuCpNdr0PlfwUpWxleKBjLo0y01u8csTsfmQB4AUe8VzuiOlUeGg/b5ubSy7pDq1pxesN0DhqlBQK607B9PoQO6GOawm5Kyki4seVZUj8ukE84K5wE+nW6MWjsxXZCJuZDgPU/J7Jn2K6sPn3QrwCFdjU68KF61z1vk9ZOnxyn4SmgHbbPip4AHZoE9ll3c68rh6ECI7J1+jkel3KT3aQS37Ai9cjz5IvISL+6wwHjQ2kKh7T2Ki5FJMt56d+ReMjtP+tg0IN30HVZx9a0MMK6AkZXRHpN6c0p688zUGk8mDDeX4Z2YTpxzDrN3W1V2fI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9536ef66-d3a2-43a8-2d68-08df20cb4a7a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:22:41.1428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9sCeEJI5AOvlffvPIYfC/MfG9ESolag5ToruW6JWkrd3TlQLtuylQnl8UDmQB3yw2STODRF6QZ1seOKr2/ColnpVyUu9vnPMqvaq2mP1onFaJqXod4lDAjPeuE5m6a3u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7788
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610020085
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfXy6QKo2meJ5zD
 AVDR6iXUgiFNlRWVThmf+xQsoHz2eQxkXx7l9d8BN034bKj73mztDE7YILlvURTXcn5baHSrZfz
 F9ZqNOMygzkpeSHXzsb+qEhqi7xxYgSIPlwth6YHIpOLxZn6FVV/
X-Authority-Analysis: v=2.4 cv=W9itxhWk c=1 sm=1 tr=0 ts=6ac020a8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=bC-a23v3AAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=dUjEn1sKAAAA:8 a=ULGFQktSz1etR_z_PxwA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=rkhrtuWP_DuLOKr0WJex:22
X-Proofpoint-GUID: Q-qT4or7BjL-o1qibG4zcHN6K6-Rz22a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX4MmBsQm4cVin
 IGu48l1z1Kon9GtX7p9wJBZFPH+Pofy4TGyxUMyw17gufWO1mP4I2umEpfFyzgOpfAnSxR8TB9B
 uoYFyJrlJ+e7tqaqbHTCLzYzAIzvWpzAEe7WZEa5b9aZ810hQgbIk1hBMvMNhmgpVUVzW/2rBsR
 +wT//5qyKS+GEs+8+8kKqIIxWr1QME2EdjNjZkEnLhuRkgbnM+IUWlczWvJIJlruLGWeVWlp6Vr
 bX5KmqmRUWe5Q09WdOiVMyc010EkxzW56pfJyLqBNP/V3S5F1ww3+tNMWQWJ/+BjByFSdBf4Hj4
 aDEtKtmseHHvX2SPwL6mABBNgLAzjj5emKBApegQFnigBRecvkkPZcriG1o8G18eTDSJ86PLXoX
 glbP44YStHCs/OKXg0ebfN1QzcWQEaAllH/c2GlR5gKF+pHXBfxSSC4UpCNtY/q6RHm3PjXC1hh
 55VfLv8Ti/0RMffJnjQ==
X-Proofpoint-ORIG-GUID: Q-qT4or7BjL-o1qibG4zcHN6K6-Rz22a

Hi Greg/Sasha,

On 30/09/26 8:48 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Maoyi Xie <maoyixie.tju@gmail.com>
> 
> [ Upstream commit c96a5209dda666004b8ee1ed7f0d493d09a4f200 ]
> 
> The RDS_INFO_* family of getsockopt(2) options reads several
> file-scope global lists that are not per-netns:
> 
>    rds_sock_info / rds6_sock_info,
>    rds_sock_inc_info / rds6_sock_inc_info        -> rds_sock_list
>    rds_tcp_tc_info / rds6_tcp_tc_info            -> rds_tcp_tc_list
>    rds_conn_info / rds6_conn_info,
>    rds_conn_message_info_cmn (for the *_SEND_MESSAGES and
>    *_RETRANS_MESSAGES variants),
>    rds_for_each_conn_info (for RDS_INFO_IB_CONNECTIONS)
>                                                  -> rds_conn_hash[]
> 
> The handlers do not filter by the caller's network namespace.
> rds_info_getsockopt() has no netns or capable() check, and
> rds_create() has no capable() check, so AF_RDS is reachable from
> an unprivileged user namespace. As a result, an unprivileged
> caller in a fresh user_ns plus netns can read the bound address
> and sock inode of every RDS socket on the host, the peer address
> of incoming messages on every RDS socket on the host, the peer
> address and TCP sequence numbers of every rds-tcp connection on
> the host, and the peer address and RDS sequence numbers of every
> RDS connection on the host.
> 
> The rds-tcp transport is reachable from a non-initial netns (see
> rds_set_transport()), so a one-shot init_net gate at
> rds_info_getsockopt() would deny legitimate per-netns visibility
> to rds-tcp callers. Instead, filter at each handler by comparing
> the netns of the caller's socket to the netns of the list entry,
> or to rds_conn_net(conn) for connection paths. Only copy entries
> whose netns matches the caller. Counters (RDS_INFO_COUNTERS) are
> aggregate statistics and remain global.
> 
> Reproducer (KASAN VM, rds and rds_tcp loaded): an AF_RDS socket
> binds 127.0.0.1:4242 in init_net as root. A child process enters
> a fresh user_ns plus netns and opens AF_RDS there, then calls
> getsockopt(SOL_RDS, RDS_INFO_SOCKETS). Before this change, the
> child sees the init_net socket. After this change, the child
> sees zero entries.
> 



An AI assisted review flagged the RDS namespace-filter backport. The
filters match, but the upstream socket-publication guarantee is missing.

Upstream c96a5209dda6 initializes the socket before publishing the TCP
entry under the list lock (net/rds/tcp.c:193):

     spin_lock(&rds_tcp_tc_list_lock);
     tc->t_sock = sock;
     list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
     spin_unlock(&rds_tcp_tc_list_lock);

5.15.y publishes and unlocks first, then assigns the socket
(net/rds/tcp.c:235 and 243; intervening code omitted):

     spin_lock(&rds_tcp_tc_list_lock);
     list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
     spin_unlock(&rds_tcp_tc_list_lock);
     ...
     tc->t_sock = sock;
     tc->t_cpath = cp;

A list reader can see tc before t_sock is assigned and dereference NULL.
The new size check accepts buffers sized for the caller's namespace
that the old global-count check rejected. With an unpublished socket on
a visible entry and another namespace's entries in the list, the copy
path can now reach the NULL socket with such a buffer.

I think 5.15.y should take d2bfdbb69cf87676981b1043010b6224d84c6d3a
("rds_tcp: close NULL deref window in rds_tcp_set_callbacks"), adapting
the counter context and retaining the namespace filters; thoughts?

thanks,
Harshit

> Drop the rds_sock_count, rds_tcp_tc_count, and rds6_tcp_tc_count
> globals. v2 used them for the size precheck and lens->nr; v3
> replaced the precheck with a per-ns count from a first pass over
> the list, so the globals have no remaining readers. The matching
> increments and decrements in rds_create()/rds_destroy_sock() and
> rds_tcp_set_callbacks()/rds_tcp_restore_callbacks() go away with
> them. Reported by the kernel test robot under clang W=1.
> 
> Suggested-by: Allison Henderson <achender@kernel.org>
> Suggested-by: Simon Horman <horms@kernel.org>
> Reviewed-by: Allison Henderson <achender@kernel.org>
> Co-developed-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>
> Signed-off-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>
> Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
> Link: https://patch.msgid.link/20260520084236.2724349-1-maoyixie.tju@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/rds/af_rds.c     | 59 ++++++++++++++++++++++++++++++++++-------
>   net/rds/connection.c | 13 +++++++++
>   net/rds/tcp.c        | 63 ++++++++++++++++++++++++++++----------------
>   3 files changed, 104 insertions(+), 31 deletions(-)
> 
> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index ca1b52372ab29..9165d054e8e35 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c
> @@ -43,7 +43,6 @@
>   
>   /* this is just used for stats gathering :/ */
>   static DEFINE_SPINLOCK(rds_sock_lock);
> -static unsigned long rds_sock_count;
>   static LIST_HEAD(rds_sock_list);
>   DECLARE_WAIT_QUEUE_HEAD(rds_poll_waitq);
>   
> @@ -82,7 +81,6 @@ static int rds_release(struct socket *sock)
>   
>   	spin_lock_bh(&rds_sock_lock);
>   	list_del_init(&rs->rs_item);
> -	rds_sock_count--;
>   	spin_unlock_bh(&rds_sock_lock);
>   
>   	rds_trans_put(rs->rs_transport);
> @@ -695,7 +693,6 @@ static int __rds_create(struct socket *sock, struct sock *sk, int protocol)
>   
>   	spin_lock_bh(&rds_sock_lock);
>   	list_add_tail(&rs->rs_item, &rds_sock_list);
> -	rds_sock_count++;
>   	spin_unlock_bh(&rds_sock_lock);
>   
>   	return 0;
> @@ -736,6 +733,7 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
>   			      struct rds_info_iterator *iter,
>   			      struct rds_info_lengths *lens)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct rds_sock *rs;
>   	struct rds_incoming *inc;
>   	unsigned int total = 0;
> @@ -745,6 +743,9 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
>   	spin_lock_bh(&rds_sock_lock);
>   
>   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> +		/* Only show sockets in the caller's netns. */
> +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> +			continue;
>   		/* This option only supports IPv4 sockets. */
>   		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
>   			continue;
> @@ -775,6 +776,7 @@ static void rds6_sock_inc_info(struct socket *sock, unsigned int len,
>   			       struct rds_info_iterator *iter,
>   			       struct rds_info_lengths *lens)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct rds_incoming *inc;
>   	unsigned int total = 0;
>   	struct rds_sock *rs;
> @@ -784,6 +786,9 @@ static void rds6_sock_inc_info(struct socket *sock, unsigned int len,
>   	spin_lock_bh(&rds_sock_lock);
>   
>   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> +		/* Only show sockets in the caller's netns. */
> +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> +			continue;
>   		read_lock(&rs->rs_recv_lock);
>   
>   		list_for_each_entry(inc, &rs->rs_recv_queue, i_item) {
> @@ -807,7 +812,9 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
>   			  struct rds_info_iterator *iter,
>   			  struct rds_info_lengths *lens)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct rds_info_socket sinfo;
> +	unsigned int copied = 0;
>   	unsigned int cnt = 0;
>   	struct rds_sock *rs;
>   
> @@ -815,12 +822,24 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
>   
>   	spin_lock_bh(&rds_sock_lock);
>   
> -	if (len < rds_sock_count) {
> -		cnt = rds_sock_count;
> -		goto out;
> +	/* First pass: count entries visible in the caller's netns. */
> +	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> +			continue;
> +		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
> +			continue;
> +		cnt++;
>   	}
>   
> +	if (len < cnt)
> +		goto out;
> +
>   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> +		if (copied >= cnt)
> +			break;
> +		/* Only show sockets in the caller's netns. */
> +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> +			continue;
>   		/* This option only supports IPv4 sockets. */
>   		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
>   			continue;
> @@ -833,8 +852,13 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
>   		sinfo.inum = sock_i_ino(rds_rs_to_sk(rs));
>   
>   		rds_info_copy(iter, &sinfo, sizeof(sinfo));
> -		cnt++;
> +		copied++;
>   	}
> +	/* A concurrent rds_bind() can change rs_bound_addr between the
> +	 * two passes without holding rds_sock_lock, so copied may be
> +	 * less than cnt. Report what was actually copied.
> +	 */
> +	cnt = copied;
>   
>   out:
>   	lens->nr = cnt;
> @@ -848,17 +872,32 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
>   			   struct rds_info_iterator *iter,
>   			   struct rds_info_lengths *lens)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct rds6_info_socket sinfo6;
> +	unsigned int copied = 0;
> +	unsigned int cnt = 0;
>   	struct rds_sock *rs;
>   
>   	len /= sizeof(struct rds6_info_socket);
>   
>   	spin_lock_bh(&rds_sock_lock);
>   
> -	if (len < rds_sock_count)
> +	/* First pass: count entries visible in the caller's netns. */
> +	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> +			continue;
> +		cnt++;
> +	}
> +
> +	if (len < cnt)
>   		goto out;
>   
>   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> +		if (copied >= cnt)
> +			break;
> +		/* Only show sockets in the caller's netns. */
> +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> +			continue;
>   		sinfo6.sndbuf = rds_sk_sndbuf(rs);
>   		sinfo6.rcvbuf = rds_sk_rcvbuf(rs);
>   		sinfo6.bound_addr = rs->rs_bound_addr;
> @@ -868,10 +907,12 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
>   		sinfo6.inum = sock_i_ino(rds_rs_to_sk(rs));
>   
>   		rds_info_copy(iter, &sinfo6, sizeof(sinfo6));
> +		copied++;
>   	}
> +	cnt = copied;
>   
>    out:
> -	lens->nr = rds_sock_count;
> +	lens->nr = cnt;
>   	lens->each = sizeof(struct rds6_info_socket);
>   
>   	spin_unlock_bh(&rds_sock_lock);
> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index cd41f83863c89..beecd408e93ab 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -540,6 +540,7 @@ static void rds_conn_message_info_cmn(struct socket *sock, unsigned int len,
>   				      struct rds_info_lengths *lens,
>   				      int want_send, bool isv6)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct hlist_head *head;
>   	struct list_head *list;
>   	struct rds_connection *conn;
> @@ -562,6 +563,9 @@ static void rds_conn_message_info_cmn(struct socket *sock, unsigned int len,
>   			struct rds_conn_path *cp;
>   			int npaths;
>   
> +			/* Only show connections in the caller's netns. */
> +			if (!net_eq(rds_conn_net(conn), net))
> +				continue;
>   			if (!isv6 && conn->c_isv6)
>   				continue;
>   
> @@ -660,6 +664,7 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
>   			  u64 *buffer,
>   			  size_t item_len)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct hlist_head *head;
>   	struct rds_connection *conn;
>   	size_t i;
> @@ -672,6 +677,9 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
>   	for (i = 0, head = rds_conn_hash; i < ARRAY_SIZE(rds_conn_hash);
>   	     i++, head++) {
>   		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
> +			/* Only show connections in the caller's netns. */
> +			if (!net_eq(rds_conn_net(conn), net))
> +				continue;
>   
>   			/* Zero the per-item buffer before handing it to the
>   			 * visitor so any field the visitor does not write -
> @@ -705,6 +713,7 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
>   				    u64 *buffer,
>   				    size_t item_len)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct hlist_head *head;
>   	struct rds_connection *conn;
>   	size_t i;
> @@ -719,6 +728,10 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
>   		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
>   			struct rds_conn_path *cp;
>   
> +			/* Only show connections in the caller's netns. */
> +			if (!net_eq(rds_conn_net(conn), net))
> +				continue;
> +
>   			/* XXX We only copy the information from the first
>   			 * path for now.  The problem is that if there are
>   			 * more than one underlying paths, we cannot report
> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index f66cbf0b9895f..f6bbde2c34776 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -46,14 +46,6 @@
>   static DEFINE_SPINLOCK(rds_tcp_tc_list_lock);
>   static LIST_HEAD(rds_tcp_tc_list);
>   
> -/* rds_tcp_tc_count counts only IPv4 connections.
> - * rds6_tcp_tc_count counts both IPv4 and IPv6 connections.
> - */
> -static unsigned int rds_tcp_tc_count;
> -#if IS_ENABLED(CONFIG_IPV6)
> -static unsigned int rds6_tcp_tc_count;
> -#endif
> -
>   /* Track rds_tcp_connection structs so they can be cleaned up */
>   static DEFINE_SPINLOCK(rds_tcp_conn_lock);
>   static LIST_HEAD(rds_tcp_conn_list);
> @@ -109,11 +101,6 @@ void rds_tcp_restore_callbacks(struct socket *sock,
>   	/* done under the callback_lock to serialize with write_space */
>   	spin_lock(&rds_tcp_tc_list_lock);
>   	list_del_init(&tc->t_list_item);
> -#if IS_ENABLED(CONFIG_IPV6)
> -	rds6_tcp_tc_count--;
> -#endif
> -	if (!tc->t_cpath->cp_conn->c_isv6)
> -		rds_tcp_tc_count--;
>   	spin_unlock(&rds_tcp_tc_list_lock);
>   
>   	tc->t_sock = NULL;
> @@ -200,11 +187,6 @@ void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp)
>   	/* done under the callback_lock to serialize with write_space */
>   	spin_lock(&rds_tcp_tc_list_lock);
>   	list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
> -#if IS_ENABLED(CONFIG_IPV6)
> -	rds6_tcp_tc_count++;
> -#endif
> -	if (!tc->t_cpath->cp_conn->c_isv6)
> -		rds_tcp_tc_count++;
>   	spin_unlock(&rds_tcp_tc_list_lock);
>   
>   	/* accepted sockets need our listen data ready undone */
> @@ -232,20 +214,37 @@ static void rds_tcp_tc_info(struct socket *rds_sock, unsigned int len,
>   			    struct rds_info_iterator *iter,
>   			    struct rds_info_lengths *lens)
>   {
> +	struct net *net = sock_net(rds_sock->sk);
>   	struct rds_info_tcp_socket tsinfo;
>   	struct rds_tcp_connection *tc;
> +	unsigned int copied = 0;
> +	unsigned int cnt = 0;
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
>   
> -	if (len / sizeof(tsinfo) < rds_tcp_tc_count)
> +	/* First pass: count entries visible in the caller's netns. */
> +	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
> +		if (tc->t_cpath->cp_conn->c_isv6)
> +			continue;
> +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> +			continue;
> +		cnt++;
> +	}
> +
> +	if (len / sizeof(tsinfo) < cnt)
>   		goto out;
>   
>   	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
>   		struct inet_sock *inet = inet_sk(tc->t_sock->sk);
>   
> +		if (copied >= cnt)
> +			break;
>   		if (tc->t_cpath->cp_conn->c_isv6)
>   			continue;
> +		/* Only show connections in the caller's netns. */
> +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> +			continue;
>   
>   		tsinfo.local_addr = inet->inet_saddr;
>   		tsinfo.local_port = inet->inet_sport;
> @@ -260,10 +259,12 @@ static void rds_tcp_tc_info(struct socket *rds_sock, unsigned int len,
>   		tsinfo.tos = tc->t_cpath->cp_conn->c_tos;
>   
>   		rds_info_copy(iter, &tsinfo, sizeof(tsinfo));
> +		copied++;
>   	}
> +	cnt = copied;
>   
>   out:
> -	lens->nr = rds_tcp_tc_count;
> +	lens->nr = cnt;
>   	lens->each = sizeof(tsinfo);
>   
>   	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);
> @@ -278,19 +279,35 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
>   			     struct rds_info_iterator *iter,
>   			     struct rds_info_lengths *lens)
>   {
> +	struct net *net = sock_net(sock->sk);
>   	struct rds6_info_tcp_socket tsinfo6;
>   	struct rds_tcp_connection *tc;
> +	unsigned int copied = 0;
> +	unsigned int cnt = 0;
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
>   
> -	if (len / sizeof(tsinfo6) < rds6_tcp_tc_count)
> +	/* First pass: count entries visible in the caller's netns. */
> +	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
> +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> +			continue;
> +		cnt++;
> +	}
> +
> +	if (len / sizeof(tsinfo6) < cnt)
>   		goto out;
>   
>   	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
>   		struct sock *sk = tc->t_sock->sk;
>   		struct inet_sock *inet = inet_sk(sk);
>   
> +		if (copied >= cnt)
> +			break;
> +		/* Only show connections in the caller's netns. */
> +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> +			continue;
> +
>   		tsinfo6.local_addr = sk->sk_v6_rcv_saddr;
>   		tsinfo6.local_port = inet->inet_sport;
>   		tsinfo6.peer_addr = sk->sk_v6_daddr;
> @@ -303,10 +320,12 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
>   		tsinfo6.last_seen_una = tc->t_last_seen_una;
>   
>   		rds_info_copy(iter, &tsinfo6, sizeof(tsinfo6));
> +		copied++;
>   	}
> +	cnt = copied;
>   
>   out:
> -	lens->nr = rds6_tcp_tc_count;
> +	lens->nr = cnt;
>   	lens->each = sizeof(tsinfo6);
>   
>   	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);

