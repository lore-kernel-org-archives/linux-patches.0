Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795267574;
	b=u3CZd2HhOpxDLgPB+63XSnWjT6+8QRGQk7Q9CEDYRQYs1QZA9R+L5QtR1m21haFOLOk7
	 FyJrzKnCXVB36b3jm1Qv87n/oVr17GD+YkmJtUUwHDguzWhBC/VfBcaKN3ytBKy28ZuPc
	 JaGAaT1XikE2m7i0ljTQxxl+lc8ITY9Sd1sxQjhEXEsQIQdXKFQuHDga5IfEBFMkSSP8v
	 o9RpEHz5dTWiLdhlNk++VeN90/GH2nTj6cGX4SRTKUsiC46dj8SUNUEcoG/bmv3fMMxJw
	 nnUN9//pjGZLv9RHPx8iDGZNVR8n3uk3NOeu8W9bI8S2EdGCBqXxaZYotRgUVEVZlPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795267574;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID;
	bh=tPnqgvFCwMmJ4MHzaJ6X5JLO2/YKyz6gyWkvZc4PpEg=;
	b=bH+IyAECi1wisSAYnWlEHhVHwzDqRRuFvpZuXXpwXrp0VdwOm8RL88vbmxIfGZYhDqU6
	 EieFDkwW0Mv6As8r6WV9hVekXIARJjjsfq1NU8Ty9zTNVRCkkVmhxoFm4trhbvfMvRc53
	 QM4eVCSTQi7UgWKvSb0QQ3CzhzkyZiCZ7gmyiZCs0P+2tBG4jbVYiuPyyCTL0LTU9ARUp
	 Sso7hnihVRKapV6nh7RzCEqtH2IcraTi8/ncLa/jNf0WyGfp2uLJyTkaCBd+UggALLR9F
	 dkF/9YrqXakC1qvurK2emdtyoGebeqU72vIuYGDNPh8IbBOF1D0OIY3N1S+/yaJnbKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=nIigFKPf;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=GAyXBeye;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A4606A320
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 13:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D2A4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=nIigFKPf;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=GAyXBeye
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCpp3w502420;
	Sat, 21 Nov 2026 13:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tPnqgvFCwMmJ4MHzaJ6X5JLO2/YKyz6gyWkvZc4PpEg=; b=
	nIigFKPfF3e1Ds7MWMgNxv3y9Dep8U09fXxJmGUYJHRyXS3/zVkX+YvEzSzeer14
	yJlbRCgxvoLbLkjzB6EglOpKmFv7y5odgrvDvr1pjR8QZFHwc0pkvYwcmxSSIajI
	gNaYfteba/NsKCoYK+EkWYAjcaVkXa/9ml2Pp7Vx1mechl+3/V1edeJ6piV16A1h
	mKagSV4d5KLMGEHhqSztCzsWHivhfyJAp3NivmcBdhSu4UTfmZvlarh4UIUOxjLQ
	qIf8k5IT7f35lm+AbVnp1evs0lkGXZeyK1DfP4xvSeq7uuQ7J9qQfTQw4Casv+2m
	kLIgsyTt4W/xs4jxKPrJAg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34r6r6k4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 13:25:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALD2vPI3777953;
	Sat, 21 Nov 2026 13:25:41 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011025.outbound.protection.outlook.com [52.101.57.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j31qybtv2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 13:25:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/fhRYUEk0vmqO39hBP/JZ/dfyWPai/0mgq9D5VxgUoxofVopnlhcr4gFzdyMhQqq16WTj/cm6yHTda/aoGXqMMWHUjZ3jdQrw7S4Jl3BSxDQW5WpcpN0MfqoIOYXH4/7NIPQVy1Y52yC5E5Npe5vda3mbS7mdCYFWwegOp55JHTw3xcPTb8V9c5hxZJMLAEmqBDGOLVPtBn9iZTUtxQCQGdvHnyra2fyo9JxT2Ny7EJ2PIJjzi+0UNQmJYbtezp8A/mDWYoxoBBM8RBmNAWHUzchFf7Cmf1J0VU7ScLpl5lEOWNAEYcE82LBLovSgznCFauIKh11FKakmc4Asq3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPnqgvFCwMmJ4MHzaJ6X5JLO2/YKyz6gyWkvZc4PpEg=;
 b=fhoUKbU8BR8KKGEAYvcjrvlEmpUG1la2GWOyuQbzuYMYMBuiNnvD2KcKIfdH1aqKt3hR4y54T/EAJBdXbG4BOQ8AE1yA3RMGfdkoNF3sYONTgWZmlREgFwnvX8ZevxgKcPB3t0mnvIO1PD66+vCeOdVdVDUAsYFTvOUbdIsmoSpJRAi1dq+oKwLMw6p6FfhU3t4RtVnDEJt1lLts6mBltt/QW5M6LGyP6JNKg+uKHLZ/YGMGfoLD99eEeo54a0W983WE/RLtxAsvEQRT+mxc5JUhtjOT8NW3zKexHwNPYIg17qxeeR7Z64QqEaipzQLtW/2zrTaTsSnC/hvu8F6itw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPnqgvFCwMmJ4MHzaJ6X5JLO2/YKyz6gyWkvZc4PpEg=;
 b=GAyXBeyeIkBw2hod4bsU3z1DTx8BAgRC2qBgFUxQWHunA0uCRcFJYnXMGBRYVDrp7buYCPDrlWQP39SJB6OX0+RP0hTZr9IYtLjQmUdPc0QpdRmKporL8H8enbkrL73SKE5cE6xV7lYd5Kl0IE+RXV5LSGG4J3g3fGuCX8FQBE4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CO1PR10MB4467.namprd10.prod.outlook.com (2603:10b6:303:90::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 13:25:37 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 13:25:36 +0000
Message-ID: <f6984afc-c689-48b9-89e2-950408695005@oracle.com>
Date: Sat, 21 Nov 2026 18:55:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0621/2214] mm/page_alloc: do not boost watermarks in
 kdump capture kernels
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, hbathini@linux.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: patches@lists.linux.dev, Yuanhe Shu <xiangzao@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Brendan Jackman <brendan.jackman@linux.dev>,
        David Hildenbrand <david@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
        Zi Yan <ziy@nvidia.com>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150036.223618798@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150036.223618798@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::9) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CO1PR10MB4467:EE_
X-MS-Office365-Filtering-Correlation-Id: b8e71181-f7f4-494e-0b6a-08df47d2edc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|6133799003|18002099003|22082099003|261009223027099003|3023799007|261021135927099003|261021123027099003|261021121427099003|261026140227099003|261026121527099003|261022075727099003|261022105027099003|261028144727099003|4143699003|56012099006|10067099003|261102123227099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	Nupa1kBPxfsBo4yEIB211aaBYzj/wMp7Qh+7cSdmqoGIRkIswm4QDUacNAkpx4JFyO1FbHqSOAC4FibdWFkCVZ2Qxja0GYIa+Y5B7m9+Ue0Wfpw9iN2SE1xpIhr72SWVwEjqRnTnquq9USH7i1+hjL9TlRgevmsv894iFhmIR2Z+seKO3JoC4e8w5YKwcI/qDpVck1akiADNtn8okw5+uhhqMNbhgnYzPXVcbeQFIrogGkByeyB2w6vzgI4rJ7b+R2sVl0+2RlDvE8uGgnzIJbqR2FeYkXfhPvuVtmW8XNzteRa6uDzDZpFzGYOlR4aYCQK8YGrxhbrwMbDyN+jeRAyTmkdJAhHf5hj1E/z13O4oK1Slm3412iMwtrbG9Bz8SlL46Tpguc2+z+hiw4MwFj7yYY1Wxhnsr/kAlnK9ThsM/wBwP1LtJVqrKMHgAGDTjKREcdlWnp4XzEvEXDqyzMbDHMuFup0Nk1Bx8tOHFWMfHWmWtMMVVqa2ImpKcD++by1EhbVqo6orcFXQoNNoXPW+pKCykfN92y5Fm692FnXni9PK2Gi8DWT83B3y2aNSWZEsoH7Y7RU+dnhhQRgLxqULMUESNIZHd0aJkEYGH7Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(3023799007)(261021135927099003)(261021123027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261022075727099003)(261022105027099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102123227099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enp2RlNMN2hvaG1ZVmNQTEdKMGxVei9HdTVUMnhOcVdpdy8vRWRjTVc2dkNL?=
 =?utf-8?B?aHl4VllhNzZZZ1g2NDIrU2pGZk1WY3pCUGtzTEhjNXRRQ3htVk4yKzFVay9w?=
 =?utf-8?B?WFBHQ2pCOHQwQ1J5YjIwT0FSZHBCSEd3TG5WSXpoZGpPVm1QR3VLaThMUU5q?=
 =?utf-8?B?YnBpTlNoZTh3eXAydldFOW9wdUdwWnJjdFNjMkFTMlZCWVVHZTdpSEhlVnZo?=
 =?utf-8?B?UHJueWtBSjNhT25wVllpbWE4Y2lwK2V5M1JlSzRpTFB1MDUvVWFyaEZvaGRV?=
 =?utf-8?B?SzF0VTNRTFhndkt2N0ErQ2tpUllhck5pZlF2UmI3SnZkbmlvTnNERG1oUFV5?=
 =?utf-8?B?N2piUVAwMkVLL2dqZzdhb296c2dYMlUvL2ZjWCtYSFdhNVFhMnBaeC94TkxQ?=
 =?utf-8?B?M0Vpcm1PcVF5Y2FEeUlyVkZvblhHaEpvLzJGWmhTMGVMcWROTjN6REtFUEYw?=
 =?utf-8?B?YW9UVzJHUzRBRHBiRmxHUklyRG94NnVjRFhsSDFvblFjRVZXU2xxenNnRnNU?=
 =?utf-8?B?UE9pRkVjbTJhaG1IaWE2R09ZZlVEM3A2Z3kzUlVDb0x6NTJ3TVFQVUpQTFFn?=
 =?utf-8?B?SUNrSXlER0NpOHk1MHhaVlQ4bE5UeE55RnNOdTJXUWk2cW5sZjdIM2JiWUVG?=
 =?utf-8?B?NlBDRjgzYnJUWXEyWlptenlSdlFZNGhtOVh6bVlsK0I4TjdPa1UxbGs4MG5v?=
 =?utf-8?B?bXptS0d3MTFRQVJDczdORGNRd2JEaWR0Q0IrQmFDNkowdVlJWG5xem5wRmlY?=
 =?utf-8?B?UjNYaUR4ZmdXaGhPUlE0V3FBNmdKdkNCYng5RDA5YmgyQWVlQ3dUTU00MURm?=
 =?utf-8?B?cnhzQXVOMGhFcFpmOCtZOE5wRDRuaUkvNjF6V0Rqd3hHZjd5WDYzQU1kUkpP?=
 =?utf-8?B?VEhMRUpETEZPVHEvOGtRRzFrYW8zTUNRMUpkcEluTDlTaldIbWJZZjlOTmZy?=
 =?utf-8?B?Y2FLSGJHUGF5bjUvZ3h5YjFvWFJ6YVJBay9nQzZ3S1FzbGVOcGhodnliWGxy?=
 =?utf-8?B?ZE1yTDVYTllrNE1ycDhMU0gxWThBM0VXM1o4OGpVeFZwSVd2K1Y3MjBFZjlw?=
 =?utf-8?B?SS8wRSsvQjQvSTIrbSszd01FUmtoMUhSSG1JYVZGMVk0L216WDEzUUVhSldP?=
 =?utf-8?B?TDZ0WFJGditFTWtrWlYvVHhHT2JyLzR1QnZsMSthaEpza3JlQ256bVFrRnN3?=
 =?utf-8?B?MW9DdHR4dStDVTFzWjAxa2VXcGQ3NncyQTEzKzRlb0lZa2ZmYVpEWE5VNE8v?=
 =?utf-8?B?aDhPSkczeXFtZXJUTHpnRDd6NVl6VXFQbmNqR1dhdGZ5TyszMFE3S2pSd3ZX?=
 =?utf-8?B?NVQ3d3Ixc1MwelRhZWJHRUFuR09HcjJ5VElUT3JkdExNOUZWU252MGcrZVpa?=
 =?utf-8?B?TU9HOTdDeGRONHA2MXB3NmwzN3hXbDB3eGJZMEkzdXhBZFVNd0N0RmFPY2RL?=
 =?utf-8?B?U3FnaFNoczZpelhwRnhoR2lVV29TMFdSZlphTEl0NDcrZEFLVzEwYk9TWDcy?=
 =?utf-8?B?UHppZGsranYwSGNXS2FjU1JUemh5THV5d1U2QmtWblRaeEZacFlzKzhTOGdS?=
 =?utf-8?B?Mnl1cWJVOUhPMG9LTklWQlJkZE9adTIwSFdSWGNjUjFRRWh4SmJSTXNyWVZv?=
 =?utf-8?B?N2xmNjN0SG5BOUU0WFlSRmU0L1NoalU2MDk4QW5LTVVNeCtSdDUrdUhVY08x?=
 =?utf-8?B?RVZRK1VXKzUzTlprVExHRStSME5DS20wbXU1dTlwUStrV2lVZWpQQVAxMENZ?=
 =?utf-8?B?L3RQRFd3bExSaEdYdjhMTWE3T0xrTnlOenI2M1MySlBWYTl3S1VZcjJVOEVS?=
 =?utf-8?B?ZmMrSzlPRVJ3SGRSc2E2Yks5cGp4TkxrTit2ME1sYU4vVU5MTXkvbFBUcG8r?=
 =?utf-8?B?RGNZSU9PVHZRb1BUWkxqWmdqb2xPSm8vc05lL1FxcXhWVnMzcUdXYlRMTzRV?=
 =?utf-8?B?OGJRdk50VDlXdnBXVHIvVDBwdFFCSzNNQkFYSE53OG1RQm9aUlZRWW8ySmp4?=
 =?utf-8?B?Y25XNERGSTNRbnluWmNRdzIzV1MzY1JkQVZQM09WK2FIakJIMk9hcXJKM1JR?=
 =?utf-8?B?eFZaQWlUV3duRmo1S0piMlE4bW5BSVRNVWFmTVlQa0c1ZVVGbkswMVBCbmpJ?=
 =?utf-8?B?T29IeWU0eXBCQW1CNEpGRHBGUUZqckk5NjhrZktvcUpUdmZSb2pGS2pOZVFs?=
 =?utf-8?B?YzUrT2pGSnhzZnRYVFRyRDl0Z3ZrVGZCbHFqTjNoalh2T2ZQN1hpZTU0RE1j?=
 =?utf-8?B?aDhXTGp3ck1RY1ViZHlKY1d6U3hnQ05lYlZGMFNFZnMwMTdMcU90VFJMTmU0?=
 =?utf-8?B?OURXdEp6bkpDc3VvRzc4N1BjbFN2M3BPSDFTUnhMMmxEbzQ0OUczbExCeTdL?=
 =?utf-8?Q?HMEKLeIcNWBoxxFk=3D?=
X-Exchange-RoutingPolicyChecked:
	FzcNOSl3BejL8J1KkclzJoBiL2bq1n9Q21dQm7Uo1WWDMQR61n7URISuX5rh0wlouO425TXxXjjERFe2ZAUfAxxZpLGyZLNcUk7AD7hOKRywDHpM1b2bz5sLcTKd8OW/iR1k1l4RxL2CAP6Ec0JgfZWe/WYnUhYcpmvP2UDXC/MlLBbEdGs13SmVvN8rQ+KsN56vtXcqymhzX1Y1MB4NjyYN2+/o9w2eyF0MpD6jw0v1wdj1Io6LXRSM62yKhTo8kPZrzFX8zSBJB/Y2gZ5hWe6hNl81gDfWNwhgo6FELx/BcvHpMhfSDpBDzDzHT/BI4VwQGeQMNq4ed0rXp/WXiw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n6hR7sFPIk+DE9btkslpUEPa0x2S71wbUzVbpjl7QziTwbyXxnMlfM+81WikOJO1H7n117DsY1rT6Xqn81sEkD+wEqA3pJmS9vcLk4XkBkWbnSrccmpGsAcPWkQPoBslu3W+2RyQTEXJn59l2wQrvtXsYyjWZghDec/0RGbZdUWb5uw2HUAuC+P052AVlWyZCoBVnygg+d+YjxzSGVNuyqcH0vmMbwYKMWCxqMV7HWC03YW1CxodXkn8ygNpHb2rf2of7pgsHYV0mBpWlN4hnxR5f4nhWfRTKWs/rMohmXJzB97ozIjetDgtdROhAqG+fpn9qRuZUD4TRLK4zO38GEzXYxsw3fEBuG7yKBl/CqYa7tjnz8PeUiWpIEd34qApXT2JZWcT5T0W7u1d8d4vfK38JTXtYtZ9pTBbNH+FE11uKtL9drxltbV85SQq4e47m++5UZhoaGdEHMD4LHjTlL8ubbUXEaeOiSDV7wO+d3oBW05h1MuERCcrH/eiVCJoT4wkn859ALWqX5BzuTq+FOSK2u6UBJDfAxo86PgLxH9oGmufK3Uh4Zzp8uAvajbC8/5Bswf1CUrLV1vWc/PKPUQOj3bKpnlcHqgPN1lUquA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e71181-f7f4-494e-0b6a-08df47d2edc3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 13:25:36.8355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYvc7eS4l2CdVkNl1kBQVBC0Hee5B/M8wfjgnUlhM2C6RCPJvqF4y1ANFkaRczhRtXeRu+jNjuIoCjcyo4VQykHi9+1xYdn0PrK2c1uMMQhpkbkhUNp/rjO9wnlvzySm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210053
X-Authority-Analysis: v=2.4 cv=M5bYuCws c=1 sm=1 tr=0 ts=6b019bd5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=Z4Rwk6OoAAAA:8 a=ufHFDILaAAAA:8 a=yPCof4ZbAAAA:8
 a=R_Myd5XaAAAA:8 a=iox4zFpeAAAA:8 a=1XWaLZrsAAAA:8 a=Ikd4Dj_1AAAA:8
 a=VjHLBOUH5hRGT17idMYA:9 a=QEXdDO2ut3YA:10 a=HkZW87K1Qel5hWWM3VKY:22
 a=ZmIg1sZ3JBWsdXgziEIF:22 a=L2g4Dz8VuBQ37YGmWQah:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfXzfdQ5mDNIAxN
 2IR70AnK7Qbb0/gtLya8QHHqzojv9852avSwU6/PEvqMyebEsdvvhMROyaoiZzsnjZggeTdmDcB
 7iEMwwGaeTh3eLcYKKjP/lQPqDrPADTtRLtPlDWi/wD/wmZtXdpapln5f63j+OShckr3xhg2AE3
 wxWyGxMFHeht+Qj1aktXe8uPELskc+oDMkOtccxbBFly6ByGXQpdtNo7EHxzo9f34ye2VF0ZLnJ
 JbomoATj6fWqAHHfgaw4gMq2JrSP4OpF8iX9NhOnrPfh0YC33nx9Oywrgvh9klv6isvWZAx97Qf
 kTdHSovhH69EM3taRVALuHBRCI0nYP6PraqmSRBJ1npnQXxX7vKaHjGeOPvjAIAX9kX9wwZqubR
 j0KQt1Je13SrmHXFQ8RQxCNqOqD6VHEp84qZr5TXVIB620u0JMzxmzXdajj9vv+cFyffIYQF+rz
 IklttpipllCnvDGztyA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfX4CvLZFnExIGR
 nqlzHvrQ5UmfbahIZP6sJyuQ6/I9+uR9YZM90O2bft+VC2mL9o19XlyRJqrJ1M9cKgmmI3n2djr
 T46Erznbc5uFDjDK+TpnhJZGpk3JtuX5BQi2FwXQfHG4V+AwUM48
X-Proofpoint-ORIG-GUID: EmjZEOZkI1m01oNaNgv3cXI1Vq3OzjFd
X-Proofpoint-GUID: EmjZEOZkI1m01oNaNgv3cXI1Vq3OzjFd

Hi Greg/Sasha,

On 18/11/26 8:08 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yuanhe Shu <xiangzao@linux.alibaba.com>
> 
> [ Upstream commit 331f94007d79b3c02d3098eea469a92aea3efc2c ]
> 
> A watermark boost is not confined to one watermark: wmark_pages() adds it
> to min, low and high alike, so every watermark check sees it, including
> should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH attempt in
> __alloc_pages_may_oom().  Once the boost exceeds the memory still free the
> allocator gives up and invokes the OOM killer, and a capture kernel that
> is still booting has nothing to kill: the boot panics and the vmcore is
> lost.
> 
> Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
> (pageblock = 64M) and crashkernel=512M, running a distribution kernel
> based on 7.0.14.  A high order UNMOVABLE allocation fell back to a MOVABLE
> pageblock while the capture kernel was still in do_initcalls():
> 
>    Node 0 DMA free:68096kB boost:65536kB min:68160kB
>    low:68800kB high:69440kB managed:479168kB
>    Out of memory and no killable processes...
>    Kernel panic - not syncing: System is deadlocked on memory
> 
> The zone was not short of memory.  Subtracting the boost gives min:2624kB
> low:3264kB high:3904kB, so the 68096kB still free sat 17 times above the
> high watermark and the allocator would not even have entered its slow
> path.  The boost supplied 65536kB of the 68160kB min and by itself put the
> zone 64kB under water.  It is that large because boost_watermark() clamps
> it with max(pageblock_nr_pages, max_boost); watermark_boost_factor alone
> would have allowed 5824kB.
> 
> Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
> tried to protect capture kernels, but it infers them from the zone size
> and skips the boost only below four pageblocks.  arm64 64K pageblocks were
> 512M then, so the guard reached zones up to 2G;
> CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
> to zones under 256M and lets this 468M zone through.
> 
> kdump is a property of the kernel, not of the zone, so test for it
> directly.  A capture kernel exits within seconds and never uses the
> fragmentation avoidance the boost buys.  Normal kernels are unaffected:
> the size based check still covers their genuinely tiny zones.
> 
> Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does not
> cover this window: sysctl.* parameters are written through procfs by
> do_sysctl_args(), which runs after do_initcalls() where the panic above
> happened, and watermark_boost_factor has no early_param of its own.
> 
> Link: https://lore.kernel.org/20260916112545.3707893-1-xiangzao@linux.alibaba.com
> Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Henry Willard <henry.willard@oracle.com>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: <stable@vger.kernel.org> # v5.0
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   mm/page_alloc.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cfbfd6309c250..396961cdf93be 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -53,6 +53,7 @@
>   #include <linux/debugobjects.h>
>   #include <linux/kmemleak.h>
>   #include <linux/compaction.h>
> +#include <linux/crash_dump.h>
>   #include <trace/events/kmem.h>
>   #include <trace/events/oom.h>
>   #include <linux/prefetch.h>
> @@ -2612,10 +2613,17 @@ static inline bool boost_watermark(struct zone *zone)
>   
>   	if (!watermark_boost_factor)
>   		return false;
> +
> +	/*
> +	 * A kdump capture kernel exits before a boost can pay off, while
> +	 * the raised watermark can exceed the memory left for the dump.
> +	 */
> +	if (is_kdump_kernel())
> +		return false;
> +

Hi Greg/Sasha,

I ran an AI-assisted backport review, and the finding looks correct to me.

Verdict: lets try backporting b098f1c32365 ("powerpc/fadump: make 
is_kdump_kernel() return false when fadump is
active"). ?

In 5.15.226-rc1, this backport disables watermark boosting during active
PowerPC fadump because the older is_kdump_kernel() also returns true
there. Upstream excludes fadump from this test.

mm/page_alloc.c:

     if (is_kdump_kernel())
         return false;

The difference is in is_kdump_kernel() (spacing adjusted).

5.15, include/linux/crash_dump.h:

     return elfcorehdr_addr != ELFCORE_ADDR_MAX;

Upstream (331f94007d79), arch/powerpc/kernel/crash_dump.c:

     return !is_fadump_active() && elfcorehdr_addr !=
         ELFCORE_ADDR_MAX;

Active fadump also sets elfcorehdr_addr, so the generic 5.15 helper
returns true for it. This newly disables boosting in that case; the
parent had no such early return.


Thanks,
Harshit

>   	/*
>   	 * Don't bother in zones that are unlikely to produce results.
> -	 * On small machines, including kdump capture kernels running
> -	 * in a small area, boosting the watermark can cause an out of
> +	 * On small machines, boosting the watermark can cause an out of
>   	 * memory situation immediately.
>   	 */
>   	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))

