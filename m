Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB9017B50F
	for <patches@lists.linux.dev>; Sat, 19 Sep 2026 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829676; cv=fail; b=ko/h+v6XfrC8woImGxNgD+QD3ePZppb1X/mdTW4ToN51g2pNk1wuYJpIzHW60wYiqzDdMU+4S30slNyi/WwRx6HxzFo5atLKETPQmrmMm5GgVLItZAsZLwD7aYWTgJHMovtLzUSi8pBja6M4WSKbokqtibQptHDQ6k2mZbW7sgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829676; c=relaxed/simple;
	bh=u0GKaIgSXjn2b5SJFl1ygliKX8NGVcbRC8ADgUvn9T0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RazbkRyqGmNOJQnSABJDNjOTwZqNrsuehhV4CQrT4iDEhYNz8y+ivK3oP2GA/r4WM97t+6sVTG5NiI64/zmoKLyl8bO0bZ8NqZQyWxdT8hgatPSblqYDATBzD3Gay1tKOHIlaZ5ZLz3We9C7JHYA36lb4i/A3Vtt+MKDXrkdX7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y64Q36L/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HLWDayEG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y64Q36L/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HLWDayEG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JDqRqq1033884;
	Sat, 19 Sep 2026 14:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nXsTQNuGZ3OCG7v/xl0BTYVYRbrKmW7dyyx8yMkHbOM=; b=
	Y64Q36L/7QSrXGIaRKerhbPY98lVBpqrrfqvoe1x6Uegwl4sOi6Wq9s0e3v32Lqa
	q1RfF6qAu/mt14O9SqdvODwbu+TzLoqNTCwCFRYk7T5z0HRczVb9t6Lzi3TKQL3n
	31AE38xqo8v/0PO/tiLesK9c6pbAW4vVBBNcePvQU5aBUP3+dQuTRGLVtnESOH9V
	tkpR9nfZzs7PDSJapQeJ1a83UW2I/oAdH1oBj9pRhqv7fA2TFk7zQK61LWk/LHKU
	0IhdEKW7Z1L+JAtMR7V2ROCKATWbU18x8okKg12K+lZHh3uS/NOD3aSISAxmLosz
	ehR3QSu2lpsYDVtQXIZdqQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk2107us-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 14:54:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68JEooel031250;
	Sat, 19 Sep 2026 14:54:03 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgumq924-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 19 Sep 2026 14:54:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksRl7Czsqavx2+v55FAHRmTxwGbLAPP0wdo2pkt0Yd0nARikM1hnDmJuEwMPr1Ry/1xnO2EOJKM8mpJyRXHmTyRQhwRK2gafz8ikkrM11WC4TXhZ9cQA6s4LnTWdtkem2lE3WQBNGXEox41UyHFrW7Eb7Md6ENeFTlaIw3JN2k2qooj4aFbOW/Io4OWgcFjcmEYYeh3dkkQijDrljtseXvtafAHBQ+3BxUAat/BpkFfIdtOQurtx1o5Ikyg5bp2EfHyyt13BUyB+sHmKSs5pFGLdNM5dRPbn5BFb9WAYr4piePqUJlzSf3C2iW2P27+xsoKPAKxJGQv9+XJN2GM8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXsTQNuGZ3OCG7v/xl0BTYVYRbrKmW7dyyx8yMkHbOM=;
 b=KXlGqEgq5tSZSrsOWtolJ4uiGR82nCxDUD36jErjCSdqj8c6ygz14EgFeQFg02f4tUPLu0Gku7W108yxK6h0zNOrkGekE+MSdccIy+cnpJRLu9Pz/ShqtcqjhBK1llvCtCjbt5WOXaUS7aCC+5Q9qPzYqK8wOpn3u2IqOmQe6rLdh3dPMN3uYoiTZB+TccT49IvNFvaua+Bho03gPPhqtTfOyJwSr3TgBoZ2L1RfGTiaB66t9wlKhuimOLQUPD1RWwAew3B//UapsxZr2aKJUfhsAQpFEb7MEMQaPmrnCpDLiwSPoFw162IOeS5/A4RoHj9ghB4EJ30DrMjzFnEdxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXsTQNuGZ3OCG7v/xl0BTYVYRbrKmW7dyyx8yMkHbOM=;
 b=HLWDayEGHWA9ywTjRzy6cuFMvpfxJwb1/6TOWvzeqBM1wbpQf4vvf2qBp1S7SbOgfNH6nyV3NuvW0QOuppMulR/VCJzULnOonavJNBNVkAuW7xosGYufNcrme2WIpE3qy5/kGlRo0mzqf1A12aYVYkfuEkKSu2wRcyLeCc+cf/g=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.9; Sat, 19 Sep
 2026 14:53:59 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 14:53:59 +0000
Message-ID: <70fbd5c6-2903-47e5-9627-4e028be7a858@oracle.com>
Date: Sat, 19 Sep 2026 20:23:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0472/1102] mm/huge_memory: use folios memcg inside
 __folio_split()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Zi Yan <ziy@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151551.542102472@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260917151551.542102472@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA2PR10MB4506:EE_
X-MS-Office365-Filtering-Correlation-Id: 30328b24-8bb0-4ce0-58c3-08df165dd635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|6133799003|56012099006|5023799004|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	HjuOVwJ1eG4R1lfFQDV9VzsP/AAiEaUVAweqBs9tUMJ/rpfJJEEMSZ0cjk5dZAesRCKESiqZ4QRilL9izZdDdzZiBOm3lZZoyA7gR5b+2TQMkh55rJTbU8pKpNYq89i/0qfFv1zB5pfjkqfp3czXN74vt+6oZXA4kUO3hvaeyNDPKg24xPxdhJzDZLzEKg0xI8A5GJRBJC6S8TlUp5QpeDxjH3ky4to/gUB1Pdzgo1k3XqSQzOaW0vpYHguP4Pqo4B/i2hEOKaZrZmPFP0FsCNWrRJUEcpCrtkCOGPbA7q+WhzRBH7NBWIqy28Zq6PsEMC/LYbkbMw5LLoCh+Qxfpkrx6Py1CrW4okxK44qGqDP4NWgmAQlRSOwoabmsqy33Oebd3/D43k2jhBg0q5cKw+/C9z/iBQD5s/j1ZQ6vUwzZ3KN9MWLeDclUAtmTZRQVRtDwvK9asFF6u9n2qCRN0NJpnU3x8RFCmFdj+vJGiZ68Z9s+XnqqCrR/eWILO0ubvlnLjRparO5O0NiE9sKrSdJU+e6SehALMP4X/JfESqXfTo0Mwp0eg50Y1glKt4IEFsJ3/DGfCs2EuYZkF5KGWSDExm7iQ4ufg+880wDsFOI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(6133799003)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkcvWDJGSnVhek00OW8xY242bk9VR0V5TWhNU0Q4RHduVFRqUTVCRTVYV2hz?=
 =?utf-8?B?L2VHa2FVVnUxQVB3WTNPbVYwZGhVRGxEVW1Wc2RuYUs2dUk1ZWhZVUVudlo2?=
 =?utf-8?B?NmRUS3JzOXhqczNsVVRiL0VHdXJjUGRibFJ3SGkrdnpmNU1oNGRsTmhjUmho?=
 =?utf-8?B?Q29mbjg2ZWt3MWtSS2U0MTBLMnh6NkpDbXpLclhGUnJXV0NmZ3NsVnNBUjBW?=
 =?utf-8?B?QXExSTh5WVVid1V4VmNtR3VDbzJUY0JjUkN3SlFkeXN0U2lRdnMrU2VUc3RX?=
 =?utf-8?B?andPNVdIaGxVT0l6bFViM05kRXNsdTAzUHlKZ3hFYVRQc0N2VHI5MHR2aktF?=
 =?utf-8?B?a08rVHJWS0gwb2tkNTJyY28rdUlpYUtZVlhnbTFFVklJNlVGeG54NkNUV3dw?=
 =?utf-8?B?MGlhR0t4VG5oOUFMTmxNamVDTFA0TTQ3YUxXZ211anNKSnZ3SjM0K2Vudi9h?=
 =?utf-8?B?TmN0RkRuelk4Z2ZDU1ZWMTFKWTQydk0wQ3B3aUZuQmRjM0RCMTExbm9EVWFJ?=
 =?utf-8?B?SDd1S1BCODdIWmRiM1RIZlgwc1JoVm1BTjZZTWNsOTFrYmxXeWRJRlRYMFZn?=
 =?utf-8?B?ZWVGZENyY0lpWkdkNHFTbklJTGx3WFh5dWhTM01nR0N5ZUtSYjlUSFVmSmFY?=
 =?utf-8?B?STM1N2FtNERaVG5aeEVpWWJvRGVVbmN0SFZkRlZNRE5xOS81VUx5SkJSU3Uv?=
 =?utf-8?B?REdNN1IwWkpOT2JEbGxqNXJEMWt2S3hVT3FoaGgyOVRUQUZvTVhkNUNNV1N5?=
 =?utf-8?B?bWQyclNYbllEN3hyOGVyRzg4eEJwWnBNaUtDM3RrdGcvVDRDbW1jN3dnckVH?=
 =?utf-8?B?ZlVGTzRrNWpDZFV3dThFVEJTZXBqYXNXbFY1WHZhUjNjL1JjTG1TeGV6ZXIy?=
 =?utf-8?B?SFg2bUZ0b1NYOVM1M3NhaHNYbmROcGVQZmFXaEV4UXBGSDFkZDFCL3FmVFF2?=
 =?utf-8?B?emx4bHlFNHUrZVd2bFhwWFp4Q3ZCaWo3UlFJSFQ2WTBGa1doQ1ZINWZXY05D?=
 =?utf-8?B?YmVwdDRwbEZydlcvOGtzNUkybnNoaXNpbzN0VUJsVzVIVUg5K0N2eThjazVT?=
 =?utf-8?B?NUQrWktRK3ZybE1oWlBYWllNY082V2pRV1EyWVEveTN6S1kxUS9zZU1Gdm52?=
 =?utf-8?B?RXF4aWk0dWRKRHlpVkFBRHhBSjlZT1lsaThEZXBTOUhVZGJERlM3WjIvWmdX?=
 =?utf-8?B?VjFNbUJWMzNyWlNSNjljdGVEbzkvaFhYOEZGZWZ1Mm56MlAxeEw0K1pzT2FP?=
 =?utf-8?B?RTc4Mlh6azdsVUgweHhBQkVsLzRwQjY4S21zbXdRKzZOV3c5RHVDS3NNNEcv?=
 =?utf-8?B?anZhNllXUUhNQkpoTlZ2alZHbVp3cWVBeWdKNHdnOXlEL0h2RUJUYjFEaElJ?=
 =?utf-8?B?dFFkZjlnR2kvdVZSaENSTStXSk53T2FFcU1vZDdOM1B3UjVMUEl1YUg5VGJs?=
 =?utf-8?B?YUtydzRhcVdrV1FDVDZTNm9yZm9veFJzTGJJb1lGU3ppU1hBVmdHcmNKRGZi?=
 =?utf-8?B?b2ZOdkNlZ2hYQnVnczRGcTFFYS9IaVVvTUZNbTREVDZLMDBkR0JPWkhuaXFl?=
 =?utf-8?B?R1k1bzdSSWJNdHlRdCtvSFdVczJTTDZlY2V0TWRLTlR2cUo5Y2lEb2pINlpJ?=
 =?utf-8?B?RnJTT3NDQy80Zmh5MG5peW5uTTl1MGx6bHpiTko0R1ZFbTNBWVVVRmI5U3R0?=
 =?utf-8?B?TUhMYU54dTBDQ2s2eFFIYWdNVURIU2lhZU12NzZ2T1g5K2JyZzQ1VjdnYWZQ?=
 =?utf-8?B?NW54Wk9vbktqcjBzNDVaazFSbmlZUDdINTZtdzlEVldmVnJTSERTTDJBQjlY?=
 =?utf-8?B?bFFPUkhYZURJbzVSQUNkVGVQa1hVdGhYUDVlaFJPSWErd01jMm5WbXVWbTJE?=
 =?utf-8?B?MVFENVlRMVUxOGF4TWpFckxhL0xHbitzRlp4T0FCekRIVFFtS1FJSTFhVWlL?=
 =?utf-8?B?dHFVZVlKSnMxMzRrLzBnTzJLMnY1VytYWFh2M1NHUzdjYXlLaWdFSGNWQ3Jx?=
 =?utf-8?B?VVdCU05xRGZuYk5sSzJjZjBZYWlacjdkZHllUUg2bVpnY2ljcC84azkyb1gw?=
 =?utf-8?B?dUx2ZDVXZWZtZmM3cjZkSTRUbjRnQnhNQm5XZWE4WERVM0xqY1dUb3BIdDZY?=
 =?utf-8?B?R0d5R2F1ekk1cTAzVmhiRnVLS1BZQm5RTmM3cGtCN2ptUUs5cFQyVnc3NTNn?=
 =?utf-8?B?YzlFMkNOUWpEUXQ4Z3BYaHZMdC9JZHI3RnoveG1yK3E3QVo4NEVPbXJ5YTRB?=
 =?utf-8?B?MmZnZllBRnU4N1cvNjRVR0FKcTVxSCtDYm5tWUdlWUJhak95a1krNDI0YTJx?=
 =?utf-8?B?Z2dDRmJYZmhVR0dwbi9RVjloaDQxSFJKK1VhWm5HQklWSkt2NThqSzQzVWwz?=
 =?utf-8?Q?LuTB114KXib8aQW+ViRbsg9zjFLUYZAtDarLR?=
X-Exchange-RoutingPolicyChecked:
	VVPj83SFkpL5TbqFqkPsma1UwEhrq3UyRrBzkoqYPx0xmalmxK81wWG8Sd+B6qIySrOowvR6vTLEoAQYjX9hpDy3MU7hiRTefwcJb++t/jmbgm+jfwbWqRRBea+XNGI+UgR0XIB8cTBMW/2LmzqM3ap1HpSCnGcTKwTEiLRvzWHJR8PnObMlHtlftyjEvRilc3UNTzjg+jbMiGchMEtOsBK7HEtosdfPg2juwz1+cNpZFlw9aT+3LbTmYomec+9l7F/dbGZbnniEACO7bT2A3UKQ8f2a83XFOd+6Zfsspz3iciLZyy5jJg9wAy1x8xfhOnonrLO+W5G5Eauu6fBTvg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YOIAF/LnhuKdoE8C2whdPhO9+xXKQjtqwrn2Sey61ws3uI/63zd/yvzLF9p09OpstaY0eH8rSmH9LZwjSqcEZnKAZ8vHJsv6UvSk3r5pqvMTROKS8XYDF6lxR8l502Of9KFQ0oLSW3BwzBVfYi0OllSv3U9U6fODD9EbQSdxnnsE+SK5EnepX/0a3w1V9cs3eJASeH+Wvv5YPo2YGyWKHt7jLMOzbnrt3lPznU978NAChPLBckgB6HfRY74KGHHKH+6NbdeVEtDNvmExpLB/jIVJzkFvMDhz4X8XC4kK5GaFP75paRZbGId3pOPqlTPaL98T4PP0FQQHdIZVHwvYHrCXsv0h15hSHnI2YvELyQl0gHPGzZj8xs9hFHeux504LchFvVETf4wWmqiqm0z0GM9hMZ2Edwd7w1d4MFkXn3dH0Wwp2UbquSjPbz92bWqeOasxL2iQ3oU0YKkw4LzTsufiS71aTojcvDId000tEDSSTh2snL+DPvMvOGiwj9Wzb7Zr5LYGzOchG1Yxu4NJ33oV8NQs4M+b8NQdBu5cWvvPkiIA05SecTu0GvhUTiBdxAUanz77eeWqqEGhwKKoKDew4bYHHyGzFu+5kY0WXCk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30328b24-8bb0-4ce0-58c3-08df165dd635
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 14:53:59.2467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1quccP4tyCLKU/eTgwsa+xMrPtLaY/nnEMJRJT4e2slbgN3WVzErNo6DWu89RPtuRF5NMW0hfOwLH4Y+yV6EzlqhdZAwOzNdPwIchQGOiGysDrCIQa1evyU6EJy83QS0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609190216
X-Authority-Analysis: v=2.4 cv=APP6TA4N c=1 sm=1 tr=0 ts=6aaea20c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=Ikd4Dj_1AAAA:8 a=c92rfblmAAAA:8 a=ufHFDILaAAAA:8 a=SRrdq9N9AAAA:8
 a=7CQSdrXTAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8
 a=HtRnRJ-F7A44mE0QWx4A:9 a=QEXdDO2ut3YA:10 a=GvGzcOZaWPEFPQC_NcjD:22
 a=ZmIg1sZ3JBWsdXgziEIF:22 a=a-qgeE7W1pNrGK8U0ZQC:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIxNiBTYWx0ZWRfXx394sXtls6Fy
 eC1vW+clYu3DtHeRAbixSICIKEVd/agurCrFuHdajkXe0urCRJ+P8qTEoczzSTP1ByzN5tKgql6
 nuDH3VcQeFjyrnF8VerHLL96LJBLvIORvcHaWamjFbKqJmYqzm0R
X-Proofpoint-ORIG-GUID: HZZoAqec_c_4DcWYNjO_Xbv2EMXiM_Jt
X-Proofpoint-GUID: HZZoAqec_c_4DcWYNjO_Xbv2EMXiM_Jt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIxNiBTYWx0ZWRfX0bRSN/9ovVNP
 rabXk6/v8AarfVchscoK9oUfhvz7kTVRL1NtNSZqfPvHEwfGyApntDoVpFVvzKlt1fWiOK1rqp6
 B/9Xeqa+tsMUjHI5iVsaY4dOzl4dmEOV7S1shywNKpdYQ806uIZAE4VWvPIN9afLU5/7fjT6NZ+
 8fqexo/CT6qNUcLa1Yqz6OquRLjes+Zll9wiF7o9Jb8TvBU4h+uiVBq6qK/Wy5WxCUZvxzFfr0C
 Mmxf5ghyUA1izOxTa84K+w+ICb9rZjB1oWbgqtI28Zfn3FCJUreUiPGjJ6vTP19Zx6c4M+Tfls4
 3tmQoELUMBKJrIXcYz40NKcjx83PazC73SlPfwEYRWhhj6HJu1OSFpPp/VBQPNFqCgBmZUn1rUG
 uEecNgVm70ABx4+hIZ6H7GdQmGZ0vcOsWjnlbvmv04h5WwC7ZMtv4txbcC/zpPd9Nr2iBGTydEz
 6iJKcrZV28aGgwLhZ4DCFxLKR4rxG5U9JynGh5Sg=

Hi Greg/Sasha,

On 17/09/26 8:36 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Zi Yan <ziy@nvidia.com>
> 
> commit c299a2285d9d8bda4da024455de65e3d00de6f17 upstream.
> 
> Patch series "Honor XA_FLAGS_ACCOUNT in xas_split_alloc() and charge to
> folio's memcg", v3.
> 
> __GFP_ACCOUNT is needed for xarray node allocation accounting when
> XA_FLAGS_ACCOUNT is set. Commit 7b785645e8f13 ("mm: fix page cache
> convergence regression") fixed a workingset regression with it.
> xas_split_alloc() does not have it and needs to be fixed.
> 
> In addition, based on Sashiko's review[1] and Johannes' confirmation[2], to
> charge the right memcg, folio's memcg needs to be active during folio
> split. Add that before adding __GFP_ACCOUNT.
> 
> There is no workingset convergence regression related to missing
> __GFP_ACCOUNT in xas_split_alloc() and the impact to userspace should be
> minor.
> 
> This patch (of 2):
> 
> During a pagecache folio split, an xarray node allocation can happen and
> needs to charge at folio's memcg instead of folio split invoker's memcg,
> because for example folio split can happen during reclaim and reclaim's
> active memcg might not be folio's memcg.  Switch to folio's memcg at the
> beginning and switch back afterwards.
> 
> Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-0-38cb3ff325c5@nvidia.com
> Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-1-38cb3ff325c5@nvidia.com
> Link: https://sashiko.dev/#/patchset/20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838%40nvidia.com?part=1 [1]
> Link: https://lore.kernel.org/all/amtcBZ-_QVRgCd6b@cmpxchg.org/ [2]
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Barry Song <baohua@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: William Kucharski <william.kucharski@oracle.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   mm/huge_memory.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6fc4e1fb88ae6..1a76a21724d40 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3420,6 +3420,7 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>   	/* reset xarray order to new order after split */
>   	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order);
>   	bool is_anon = folio_test_anon(folio);
> +	struct mem_cgroup *memcg, *old_memcg;
>   	struct address_space *mapping = NULL;
>   	struct anon_vma *anon_vma = NULL;
>   	int order = folio_order(folio);
> @@ -3483,6 +3484,13 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>   	if (folio_test_writeback(folio))
>   		return -EBUSY;
>   
> +	/*
> +	 * switch to folio's memcg as xarray node allocation can happen and
> +	 * needs to charge to it.
> +	 */
> +	memcg = folio_memcg(folio);
> +	old_memcg = set_active_memcg(memcg);
> +




I ran an AI-assisted review of de480d1cd9ed and I think AI report is valid:

Upstream has:

memcg = get_mem_cgroup_from_folio(folio);
old_memcg = set_active_memcg(memcg);
...
set_active_memcg(old_memcg);
mem_cgroup_put(memcg);

6.12.y has:

memcg = folio_memcg(folio);
old_memcg = set_active_memcg(memcg);
...
set_active_memcg(old_memcg);

The backport instead passes the raw result of folio_memcg() and never
drops a reference.  That raw pointer provides neither the css reference
required by set_active_memcg() nor the helper's root-memcg fallback.
Both get_mem_cgroup_from_folio() and mem_cgroup_put() are already
available on this branch.

The backport uses raw folio_memcg() without acquiring the css reference 
required by set_active_memcg(), and therefore lacks the matching 
mem_cgroup_put(). It also omits root-memcg fallback. Both helpers 
already exist on 6.12.y.

Maybe we should replace the folio_memcg() use with the upstream 
referenced get/put pair ? Maybe lets drop this and get it backported 
correctly next cycle ?

thanks,
Harshit>   	if (is_anon) {
>   		/*
>   		 * The caller does not necessarily hold an mmap_lock that would
> @@ -3629,6 +3637,8 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>   	if (mapping)
>   		i_mmap_unlock_read(mapping);
>   out:
> +	/* restore to caller's old_memcg */
> +	set_active_memcg(old_memcg);
>   	xas_destroy(&xas);
>   	if (order == HPAGE_PMD_ORDER)
>   		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);

