Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635793B71B7
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 06:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789540556; cv=fail; b=V++sMLmnVTYbyb9TOesEdC1lH3/IzCr2IOUCcc3jkTyynaiqLK/KBXVbDocixEdyqw8U2rs3bOc1IWUuVoG0RQlJxnuAXYPKdOC/QTPZzPZUNgeTQs3RpOoR9uO/g6wa4nVF6gXdQgUMuqA+C4M9BIGBczvWcDdacdIjfRE8vLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789540556; c=relaxed/simple;
	bh=fV9eScW0ELwG8vad/rMpbYx1gzjSx8w+AiHIJ8Rafm8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=snocv8e+IrjdsZtd/0/dErk1GKLBSST+mfb3BC5zNWrSQAzETdU08icGBf32ZVjDHLoftjjZBJLHcjBdtLX7X0+KosLck1xjZEJhfwULRyp9j0rYgzHk0/qpCh0E88xaGhMK9/h82WAdZg4U2LzIL+BQxqeZsvZ5MSIc0drjRb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZFUUH6jR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yYXEBRfE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZFUUH6jR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yYXEBRfE"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXq1M1308074;
	Wed, 16 Sep 2026 06:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KnrqlkEC6eVoJV89uSIm0yHi2p+I6j0Kns4Xx5h1kSg=; b=
	ZFUUH6jRuF1mM+5GvmXVxUwewVmykLBLJhQ1MsUm/JWaxv0d825lvEWfX5ABvEfd
	vAQHvDKymBJPnws2Ap7HvnrApvB6fJnEm952H1CClaKOwDWv++i3bMfWmOT7W3nt
	TM5/KIi1kPV256q/4G9EYw1oy2ZKVv/IcnB8+3iJXtStOSDG3fi/OCn1bSmtQ1xv
	5KIquXueuVbM8grFeonv34WPH4EcTjzNLAdipzH5a1UehNBiGTwptuHk360/ElrD
	3XXHpmx2AkndAx5J8v2gw55MW93U4k8VuNtJCg7h1EMHLstrUw34kY/FyRnNYCAN
	kQKWhhNfS4Exqr0s+erOUQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn952r9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 06:35:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G6ZYV5031048;
	Wed, 16 Sep 2026 06:35:43 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q6svw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 06:35:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DGwPqQpj8CCOoSaASq43UzumozD5wlELUn77fbQP04j08848KYFa13yhPYocVSkZObuvdxQIWhbZfPZYN/dHoIITEHxc6MEfECUpXWwefJaD4uE9mlOOuX6ET8We40p3TqDX39ONGW8+UBZ3tEqs/tjG/vY1kIsvZ+bHqYxvR6r7Lujjd/2whNDB/OOj5Ca2ArNW7eGwmN9dtvl3UjwO81xBUiwPRb6l0paDyK69cOfPX2lYAmWu+KqP+ZqbMlNxPDMpqYJSmv27WKU195HK67+LhrwqlqrE/E0w+RQh59P3VjnXDlVPhILFAV5zzizAAKkoMFHFD8rKEhaLPmVUoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnrqlkEC6eVoJV89uSIm0yHi2p+I6j0Kns4Xx5h1kSg=;
 b=bHW7UaogXopu3AkLDuLk1TMqAEQMm56dp0tFPNxfAtRW947GdALTO5dhaIoQCCktEWHqkilcAsgv4ryHRyHkM6LqNymPlh2U8FLx0SMXQaOCywHO+r6oHPY6LPDOIhZMUNswtfkTBnEeLdEyZ2mWCKXg7W3NCctGV0vJb0YGjPUNFTeSzByCjOiGa/6USvWNQNy+yPT84C3wXccI5p1Be5ttS7OUlYxO/iDY2qRljZdN325xkaEBu4vgal4brO4Kwa3YfdqUqChrT+rzJD3mVTx1m37Q+5oTYv5n91gwcWTHKOyubetCq/NcP2ppOq+hyTFOH0PAP5obtz7YF/6vyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnrqlkEC6eVoJV89uSIm0yHi2p+I6j0Kns4Xx5h1kSg=;
 b=yYXEBRfEpjC+pxZSEpcrPHO6i+oEfcaMRyexdxJ30sva6WU1qcN3qEkBtDB7Q2Uj4pRjtJCC8vNAEE4DvfIA1o2S7oTLKiqkBel12ZwJqgVhnP2/ML2c3spGlRltgiM5TAcFAacybUEvMmJ4+eRwhj1qIvmTRoGMfA/l/IV42no=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MN2PR10MB4141.namprd10.prod.outlook.com (2603:10b6:208:1df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 06:34:34 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 06:34:32 +0000
Message-ID: <f80a9a46-930b-4c62-81b4-20cca6726e84@oracle.com>
Date: Wed, 16 Sep 2026 12:04:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0069/1376] mm/mempolicy: fix sleeping allocation in
 alloc_pages_bulk_weighted_interleave()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Gregory Price (Meta)" <gourry@gourry.net>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        Alistair Popple <apopple@nvidia.com>,
        Byungchul Park <byungchul@sk.com>,
        "Huang, Ying" <ying.huang@linux.alibaba.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
        Zi Yan <ziy@nvidia.com>, Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065609.097044562@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065609.097044562@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0010.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::18) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MN2PR10MB4141:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0625e8-b28c-4e33-82c6-08df13bc9162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|18002099003|22082099003|4143699003|10067099003|56012099006|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info:
	QVUPlgymA3taOYMBQjlEDew7QKBTNtRcl/aHixibRuZJM23lktoW39gBEtRxkSmqVIgC5dWDQCCR23WkBpBQKRTFLVMdka1y8cukMF/ia03ljKz6aFcaXW60TF+purDCm1ZYMIVh6NxT5htEHe7xDSmgmA6a0HD/0tY4WSi4ZybO71qoua3Kd8pj49DuFOiL0OiTmqxVecW72upPt5+ehti2EMQMQAnHNxQ74BqzglMjVU8lcTM6HkVy2H9n9VofgAhF2PRdsxLIQX4qyIrC/i9UpGj3VycrFtO91I5vEPKhZAzDaFtavjZDJVvnKDyDrw/QGFiU2DSnumQGBDJeCTO0QEvquyL5ZSXtn+q9jXbJt6NsvCtSCLnY6OgNDSybtNfD7TEGk43NWPM73Jw6t0yZYcjLza08b8cyeoqTrMjjDwURoDb+bNMEIrEHLTVCT5Q/oEIKnJXtQKn1Z4xxQPmj75BRmb/Y/LddIxOCpEkdsFWjwW2ySg+wmzV99gUET8eiguXUzzgKiGgt6zoyAHgK9Z2LWkqf8yTwCZ91eXV1Syk1PZ30sSvuEX5Bcgku6Z8xeQWozsiRk9vm/RJ3Hn6KamyuDDsbjPtmP5mOvP8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(5023799004)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckdQM1BxVXZHYzh0czZHc2NUM1hHeXJySWJKVUJuU01lWXFXTWl5ellkZ2Jz?=
 =?utf-8?B?UkhWRGN5aHRXQ2p2LzFvalFSd0pIOVYrYURUS2tNVWR0ZFNZSk1RdExwQjBZ?=
 =?utf-8?B?UTcrdVJxd2pxcGE3ZU9hcmQwWGdpcjNyMXRFdGJiNmJ1S3MrNzUwVHpQanpB?=
 =?utf-8?B?NTNoaWw3VzVHWmg3bmMxc2pqNlRSczVuT09nbE1vZUtJUUhyQ1hjYk84U3RV?=
 =?utf-8?B?RGxBR3ZCeTc4d08yU2pXWHBoMWJMNXhmRTNRY1dOalFxZDVsM01qWU9XeUR5?=
 =?utf-8?B?SDd6R1hIVWdQbDFTbC9PTm1SZW10L3FqVzJkNXlYV3Q5UzdseWdYVWZZRGtw?=
 =?utf-8?B?WHpnMnVyVDZrTk9vSFdicGtEZjZQTU5xNi8wTGFJUUpoaFFkRDVqYUFXaWJO?=
 =?utf-8?B?RVE4VVNudFl5Qlo3TzdMZGhTOTA1RlFZbWRyQ1lrcHlidm95SFQ4VWlzUWlI?=
 =?utf-8?B?bEFjV0M2SWlQbGZSUkE1VHNrdUFQWmtLbC9pVDlLdlVzSGtwdm1mQng3b0hk?=
 =?utf-8?B?ZU1LeUFBdUFQMDRDSVBCVUYyS3ZnU0o3c1VYVWNwaW44Z2NNUHpTaTE2TFpx?=
 =?utf-8?B?bXhrcTUzMHdjM2ZpWlgrS3VIZC8zdzdOODRhYWt6T01hcmpYQlFnM1FZM3kz?=
 =?utf-8?B?TkFCVzRTdnVDUjdFdlUvVXgwT0pCTTUzWGgzTi8rQTBlaUVIOWk0eDM5cy9T?=
 =?utf-8?B?c2FuQUhzRFVhK3BLWXl4SEw5WDE0M0t0WkVpTDU1ZERBUXlsckRWcVdWcCtF?=
 =?utf-8?B?Y082dFpZeWxRUXVzV093S3ZKZFpXdjlKWlVwYjIvNmdWRnFIaVZPT2piY1pj?=
 =?utf-8?B?NGRpTGxDcjNmelZsYVhWZDVOSVUyMkRSb3FuVEx6Qmg4Z25scG9tdWtSeTNK?=
 =?utf-8?B?eUJLUVR1YUtPTmRDeFBoWGFUamhQWkllNWRqa0VlV3NXdE1MVElMdDNPSTVs?=
 =?utf-8?B?ZFdmUGFDVkU2V2xScHNBRldRY1VaaDFqc2JvQ3hQWHNIa2lBQkwzUXppbkdn?=
 =?utf-8?B?ZU4zMS9HdXI1YURuZXZhVnZHaWx3ZnkwQzJ1K2YwVXdyWjRMVHdFOHpCNkwy?=
 =?utf-8?B?VWc4RTNjVk9pTUtDdGdISE1Xa1h3U2R4Q0JJT2hjaTlhMURyWXlRamR1SVBN?=
 =?utf-8?B?RFlVY0FoMkRDKzFGcDVuK0NxSkJtRHlTekpRc09WTmVmY0FNSHkwbTVNUkIz?=
 =?utf-8?B?ZTFjVWNGb1BRNHQvckRaNm50MFN2SjhsS1NoRGlZRFR0NnR5dXpoRmpRaWx4?=
 =?utf-8?B?QXRvYjZNa2NWLytPak1ZV0NmdEhmWm1TVEZOS3ZwbGZObXUxSytvbEZIYUJU?=
 =?utf-8?B?YlkvYmdnSjFiZ1FTYnBYUHVOWEEvN1BIZUlHQTdySmtna3J1VHo5R0ZFWlli?=
 =?utf-8?B?OTcxbDZpeXRUL1k0bjhyQ3I1M2VvaVdVRWVpa1pKRjdLSnY5Q1JrK1pZcnY3?=
 =?utf-8?B?VHZDbjEzeE04UE0rUk5XejV4NTJqa01EbzZlT25IMlB0QTM3OGFqekNOQ3hW?=
 =?utf-8?B?UjFRR1FHbHRDQjA2TlZkWGxGdjFDbzhpcGlNTUhkUGgxUUdqb2g0NEFYVEVo?=
 =?utf-8?B?UEgybExBdFg1NmE1Ym1xVkRzaUt6bWxrS2JJTjdOQkJWSWNRa3h6VDhJc1lG?=
 =?utf-8?B?L1FHV1B6U05hZE9PeHNKTTA4eVgxNTU0SWFkaWV0Y2tUV2RsamIzZGJJMWth?=
 =?utf-8?B?WEVoYnVleGFpRkhDbnpOMEpMOGZDaFEzSlZYOUd6UE5mazdKWFJoQUhBbEM1?=
 =?utf-8?B?eDdLQXJ5VlhEMFFsZFRzWk9HYUNFenlzMCtpSThNMjBLNmpWZ2x4bWlOeWlz?=
 =?utf-8?B?VXdLUkZDeDhxU3BVcDNRUlNSN2pCSnhOZ3grb1JOQUQ3ZmFyd3hrSjZGeHZS?=
 =?utf-8?B?WnFnNmY4VFhqMHRFcDRSYkE2dDBSbzM5MFdCaWRtSGFKT2NjNEY1cHAwTDcy?=
 =?utf-8?B?cFJ5aldmTU8vRFR6dlovUkI0QU1HdjdxUUpHYUJYOXZXNUVxODRyZzE3OU10?=
 =?utf-8?B?bGdRNVUvR2xZaE5ld09YTHpIZ3Q4MUt1OWNmOW9mZnptSmlrKzFWenl0TmNx?=
 =?utf-8?B?cTNnaDVPWEpZQ09idzduYkI2OVVJSDUyM1d3WjFxd0NyR0I5eWtvdFJIU0tP?=
 =?utf-8?B?YW5QNkNWNjJjUTVzY1ptOGF3L1ZSdTRjaVlSblZ6MmNjbE5EcVZvTEZKamg5?=
 =?utf-8?B?b1FMbytmcW1kNzM3RlZiZmxISGFrZnhob0krTHpSS3FTOXNhdVVVak5vV2NQ?=
 =?utf-8?B?V0p2eHRKWnFGUDlQNlhUa2J2aTUybTZZVERkUG9NK0s4TldkK0tZV0NNc0wv?=
 =?utf-8?B?Zm9mUW50VDNhMlNUYkswWFo3VGxNMHo0OEtvaWthZ1F4dHFmZVgxUFU3M1I4?=
 =?utf-8?Q?aJdxpvnlsdSi/aXVjM10Fm77fn8z8U6dkno4h?=
X-Exchange-RoutingPolicyChecked:
	JqOVui3Vfdk2j0YkoYpr08IJAQao5Rq41FR6I23G7bGsj9eAjXtFBY8sCBTez2IAD6FTkiY0mVJXieSNjqCW/J+ywODlz2ZO6cySU0sIKHFjmuIAElllW0UQzPbrtqfEfr5NTbL0mB4TzBkFyp6DMiSBlTXqi8he+GT0lUolR2Xr8JsS7LWW8mSNUi80qIMTuPzDy6eK9vOYmloj/6PwCv8wLzb6o206HIFYnVREvu/6Z03cx+yx9OqDBHPGwhucl1gDjaNaTbce2srG+wQfwf92e1g5bQf3EtTrwzqS0Hqgr6dotf8FgcZLsDS9Wnzn9bWuL7dIyxEtW6dxN/39hA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gfQJthYMaFvypsSL8I/rqR/m4WiOPajhv+6xJW3stmMw+hunKcx52p9z4FboB525awOkeyL0329xo9S8+8Mc3yoQfRfmRp0Lf5DSkgE9qJT4RQ2AflNUf56M/ql0+kYxC5dlge0C9GnfIINOd5TITKH4rsNwk5Q/wqyqJLbdJb6AGDxTtLFo0kdWMi4itS4+OznfQomq1fcKtWRmH2dBgtJWLwUASYT9b9NezHuIatJbcuk0hUrgm6ocMd0qiG3hCrbyl01uKo4EagB8B8Z4yaF9zGmOd4vApwJSjnmYp5qBvL1zaSEM9m0dj+j3RlYg+CRJyJBJhxnrW6F61/e6OtO8/3RsNe1DDatLOtwncXanlAQl3YnAhjr8802fNgOiTP6XvxzwGT4W0ELcgxqrgXhUZsyuADd7+g5dRTUfU0EG7Oftp7nPzN3uGAgIReCrDEflIcypbE8+lx61o4GT/Uh4q8Tre0j1AJMArAK0Gf7fhQOsoP6PT2LiT1WEzShODUkQTZRpy7rjQKJkgD4+ZRbjJoOmMkAgjmOAnlqDLl2ON4PQcZlOqMSWUwMTvqAysurF3yLb1VPKj80XSf7HY1bHqIsiOHUq4hEUoriY0D8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0625e8-b28c-4e33-82c6-08df13bc9162
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 06:34:32.7720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAq+7FjYZqW5fBae1WdRNSs6aHQKX0zl8Zj3+isU0+OPfzBrpgX2gcLoRvTsJyWlFyYqrPz6/203Azz8VxfpPddkd++L+wkDlo4OjIc0Vy7lfWx71YrCB3Ha0kYGENlr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160083
X-Proofpoint-GUID: zIYqPpdaADiPmgzhbJoOsS9dTfj5OEkr
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA4MiBTYWx0ZWRfX7pAoaSduaPZ6
 h6wOpRvz7eNox/9zPaK+Y9sOW8tktD3TR35TYMkUOsZHWG6q1fAh1nA8wQdWBkw9IJt1ehiGTc0
 VMldnjRPOtm4atzSwWz25cyL4SxWYAI5lV+7gmqdQqh5e8/EMJZp
X-Proofpoint-ORIG-GUID: zIYqPpdaADiPmgzhbJoOsS9dTfj5OEkr
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaa38c0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=hSkVLCK3AAAA:8 a=Z4Rwk6OoAAAA:8 a=tHa68p0SAAAA:8
 a=Ikd4Dj_1AAAA:8 a=ph6IYJdgAAAA:8 a=SRrdq9N9AAAA:8 a=pGLkceISAAAA:8
 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=uH0djw7WOSwRAS8SnRQA:9 a=QEXdDO2ut3YA:10
 a=cQPPKAXgyycSBL8etih5:22 a=HkZW87K1Qel5hWWM3VKY:22 a=ufIsyHvWW7FwcMbVRpPq:22
 a=ty6LBwuTSqq6QlXLCppH:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA4MiBTYWx0ZWRfXzGjvI9PGKkCW
 wBXKpFyuaz9emaM3KOqs+IUg+4y3iZcJV4bZRs6eLL4RQjZLMrXS+n5md+ip9GdumfWg4ZD6osj
 iFVPRGNyJapDjD3Hq5TW1OxFnV6qbYiEhr9XKlK4q5OFoVgecy6GhPzw5znEIuB0LlUaoKWDgNm
 d4+FpiXqSkn1XWsu81QgBpFTBH13oevutAtWuGLXoxSY+ty7VqATnIQ9p0BKmbi5UxbWaqwh+ss
 +kAop5ZmCS0cPEVk6BCFEs7vDV67cPLBlQIh6QRoMOQvVVIhsP1CWqxEJyxKHQlMeA9lSsFOrDC
 uyz6pQXqMJrHfJQ78L1RL5Fuuoue5e9aIss55GucXBP2Kf0trlJ3lIdivp5UhsC/z5Tz28u9YV4
 X2NysluZhPi0AKmbSEFboeNG0aAN2Mx61YJkjXQIpRA5Ut+6D8uH7KD3VXstLV44BwfvgPc0eJX
 PP3+6dHwYaHwUAXa3TLetpxVialJj94beMoC+i0w=

Hi Greg/Sasha,

On 12/09/26 12:11 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> commit 540e583b66d6402bf556fde5e53c817a54c1afe5 upstream.
> 
> syzbot reported a sleeping function called from invalid context splat in
> bucket_table_alloc().
> 
> When rhashtable_insert_slow() rehashes the table under rcu_read_lock(), it
> calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).  If the bucket
> table allocation uses vmalloc, __vmalloc_node_range_noprof() invokes
> vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() with the
> passed GFP_ATOMIC flags.
> 
> If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
> alloc_pages_bulk_weighted_interleave() is called and currently hardcodes
> GFP_KERNEL when allocating the temporary weights array, triggering a
> might_alloc() splat in atomic/RCU contexts.
> 
> Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
> zone modifiers like __GFP_HIGHMEM) received by
> alloc_pages_bulk_weighted_interleave() to kmalloc() instead of hardcoding
> GFP_KERNEL.  Since the weights buffer is immediately initialized in full,
> kmalloc() is sufficient.
> 
> Link: https://lore.kernel.org/20260821170407.3721004-1-edumazet@google.com
> Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   mm/mempolicy.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2438,7 +2438,7 @@ static unsigned long alloc_pages_bulk_ar
>   	prev_node = node;
>   
>   	/* create a local copy of node weights to operate on outside rcu */
> -	weights = kzalloc(nr_node_ids, GFP_KERNEL);
> +	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);


I ran an AI-assisted backport review and I have checked the issue.

The patch correctly propagates the caller's GFP reclaim flags, but it
also changes the 6.12 scratch allocation from kzalloc() to kmalloc().
Upstream does that only after e341f9c3c841 initializes every weight
through the new auto-tuning state. That change is absent from 6.12.

On this branch, a NULL iw_table is the normal default. The copy is
skipped, and the code reads each uninitialized byte before converting
only zero values to weight one.

Upstream code after e341f9c3c841:

     state = rcu_dereference(wi_state);
     if (state)
             memcpy(weights, state->iw_table,
                    nr_node_ids * sizeof(u8));
     else
             for (i = 0; i < nr_node_ids; i++)
                     weights[i] = 1;

Downstream 6.12.y code:

     table = rcu_dereference(iw_table);
     if (table)
             memcpy(weights, table, nr_node_ids);

The downstream NULL-table path leaves every byte uninitialized.

I suggest retaining the GFP fix but changing the allocation to
kzalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK). Thoughts?


thanks,
Harshit

>   	if (!weights)
>   		return total_allocated;
>   
> 
> 
> 

