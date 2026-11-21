Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795275733;
	b=zRyZagrCNKtT3K8BL8JA6bvdGhYlmOCigB9rGdGVZqf7NBLsk2PHrWwhaLBxNJrTYJ+x
	 kzsV1Dvttba9tvb8HwGlMFo7dQqbWlLQB+Yj6BUt399ALM5LoEzVnX+tlQ9dADq0RTRom
	 FTlfkigEg3TVzC0bIStkVyVo6uQ1M1pfa/axhngri2OIXJx40AUnu3ZX9ze4N9Gs3rrbi
	 4fHTNKxI+vJPwnsOguPQvCFSFnIiOlc1xxMs0W3+L5V8GtXvjTK8OC6XimDw98IAnwq7x
	 2I2zNPItmQRoAqfeykYLV3VczaosuEjyb24yMm0iNUqEnqWz03sRr7cBPSf625ehB1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795275733;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info;
	bh=hUqg8kER6+SaMXn3EsMiYl2OOox43wBm5iwx2S6Z3iY=;
	b=HW8cEJSyu4LQo3uedJAXDvCZzrM7gbdR5ZtUF0vzMmhsMcW1dwes+6g77iJIu0FXmD0L
	 eJc/0V/T5xoU+fkA4hYlsMM/HUvRwu07tVcS4YcjJ+JjwSJ20WMd14LSZx5lq1Wp2046J
	 Czj30PPO1hIrpyx7XjHfNNZMSAYG0c8vuxwv/GPo/9qiPoJao8dV2gtd/fSQTVIjPJzUR
	 mv1IfXoVYMGpt8DIC66EePa6ltDPrUfJe2+RNSSTJnN9eRfgo3z9tu1eZehNL9EsuUzp4
	 X4orxse5qipbEHFOfoGuqquIHlI1E9bJ88+77QoDe3Ot2oNSAd/QWU+oVhdQasAm9zw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=UmAzbgZc;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=BGs5+8MR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03D1606A320;
	Sat, 21 Nov 2026 15:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F03D1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=UmAzbgZc;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=BGs5+8MR
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFU2ox2328227;
	Sat, 21 Nov 2026 15:41:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hUqg8kER6+SaMXn3EsMiYl2OOox43wBm5iwx2S6Z3iY=; b=
	UmAzbgZcg2s/lp6mVPCJhYl3HeRzWFCEGpE1K3EMBXW3mSNL970YJQpn5+cszSxK
	PhiTd2lFojy0AeATcNdscSbkVXqGPNLZekplsRBgohPP2FGLbi/HaNR6ik3tRec5
	8z7qRRXfxRPk6uMI+LAMkXOKZIudRo8QI+q3PvNPpqkatCVSeeeGhHmzJ1rfTanE
	EnAkhBKKu+nhFXDKXMUAm/4DMPXXq4p7Lxsw05TLdcWf+2kEjgNls0BCh9fOYuta
	DaQ9QHHxBKRTjYN2wj8fBHoFZJ0IW/ctzVE65+oqTPitMhbSF446jiwvqDJtjm8w
	a82tYTzkt7sIYUvUpc2Psg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t508jv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 15:41:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFXMas2828255;
	Sat, 21 Nov 2026 15:41:57 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j39pbm5f3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 15:41:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDnKAOovO8xmH4APh9zgk2pxz4LrsDUe46pGMWdwYMNdY6Axbh28EBml2wOvZ4FmZ8pOTuGUoHCRIApvv0OTl5i4M8KTCFQ+Zbs6v+jlZm4rvvaM2hv8T4tvsR83vUT9fk5410iqEnKfu1FEmSgyPs1rEZ/1N7Ptt1w6FIrBc25L56bbRKUYHasHUBPIn32XcgtAROX2zcHWdhNNLPmLJF0/qI+aOaq1YDjyw7tgnfkDvgvcU9JTX8nC7DvzRhd0ZzCCSLDtp29m3vriDNR9Um/dkAfZvbXPS6FZ3iJ0h9R+7PxbHys2Dqx2DaCxH3MVcd7BRW6uSLAk2uyORCD22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUqg8kER6+SaMXn3EsMiYl2OOox43wBm5iwx2S6Z3iY=;
 b=zU20O6VxYQRHsdq6ZbEcU/aXX7cPZuw5t2USC5mGIx2SF2muJpd238HQYHYLfiKzxND6ual8e8CKEIzfnqLqtr0dHCbq9WfnDE5mklzRSE73K5q6dojYNoZiO79CKAN26yvIImznSHZqA65rMxY//rWJrkBQxNE9y76qtnVcVBh/pBHeipmfLe4SvL4e77OERciYfvDXXbVt/Xp/dxA+xEFLt/a4pfRSw7ek2TTgE8c136Ah2d6qS+NhjOg1a02E7ZQgkrvj9MFTzNhHV61AsftD9MRBQae5euv3GUPJif7xYBIdGD+5ZVfqv/W9zgTFWIzkL+Oxaweh/uZwBAsoXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUqg8kER6+SaMXn3EsMiYl2OOox43wBm5iwx2S6Z3iY=;
 b=BGs5+8MRIBQSAOoMe4EVKZ16LktYMtba4DyBnU4ZSRBwl9yfJvfK9cJks3WOV+sPYm5J6wydh7hMnOIV4gjUIbhJ/DQ54X6/697v5Vt6LKF3sq92zRevYZtgxVcCX+yxEsbt/Eppmx5QWYGpK6wgzO7aENq1oNQEX9FabyhnVZ0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SN4PR10MB5559.namprd10.prod.outlook.com (2603:10b6:806:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 15:41:52 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 15:41:52 +0000
Message-ID: <1df2aa0e-0cfc-4d21-85a3-d74e4ea83d3d@oracle.com>
Date: Sat, 21 Nov 2026 21:11:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1289/2214] drm/amdgpu: Only enable HDMI audio if
 display supports it
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        renpanpan <renpanpan@kylinos.cn>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150103.128986610@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150103.128986610@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b8::13) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SN4PR10MB5559:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a07f0cc-e6f9-422d-0e9d-08df47e5f694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|261028144727099003|261021123027099003|261026140227099003|261022105027099003|261021121427099003|261022075727099003|261102123227099003|5023799004|56012099006|4143699003|10067099003|18002099003|22082099003|261009220027099003|261009223027099003|261009223327099003|261009221727099003|261009221227099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	f29gJ0jE+z+8QiUQXIOCn8sj+o8lTVbL8VzGtzKh3E7ZHmeahnhlZWlfE9lkNV39oMUxgNookKQPjZ3gBHXgT4Hhse3Bh2ohA7Mgwjc3wBRxSARpr00f3o8nM9OFPMGYf9raVsAXSy098G45BtGXF/SX3p3gXM0J/wcOl8QF+6is6aZQok76QTC7ST+Uu3xqiR1cQ7WJgla6Tln9aFK9t2Vtuv75LPPF3bMww4v5TFPCennkgjef4KpWzrmx8IXUUroEdhelgCziYxZpEjFIWGdSx8JPfsXeMPCY/5lgVdLtu966/P1j58vBvE3ukfyI2YjZ/LPKKsCa0kfchM4iN4IjLLSK5HM3pGijSoNdNXMQxQ12uUQEgVx2J4WQWpvZAkzbGaMRmUOd6Ns3kMC/NcEl3XiJ+8mpLAd9iOwazVGoWoG4qUhOr5G64j0hA1A5QSfPac/QCmAj0RQfDlKLOkM+yCDSQHZrD6ZE/0eVUDqTt73/TnXVQFhPcKFitUwlcEdZfD9+yhxpVMc5oSnn8ny+niFdlLb5XAds2jR3MuL/A0dgyxY4FjBV48T9xcipGfBG/Tp9z5gJ4oDE0sYCjxoY1jBKDrem5J1MvrYwgyzrH6jF7XYMltjAo3YgJc1Uk1WBZSwCPtAYIguFADWM2SV1VzMxufRcwVH2w1gr/ak=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(261028144727099003)(261021123027099003)(261026140227099003)(261022105027099003)(261021121427099003)(261022075727099003)(261102123227099003)(5023799004)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(261009220027099003)(261009223027099003)(261009223327099003)(261009221727099003)(261009221227099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1VJZVZLNDdXY0dYS0JCV2ZVL1RwMmFsUzJHbXFIZGhnMEt4SDQ2TVNwaW5w?=
 =?utf-8?B?RnE0OEFzZ2lucWRmejBRUzdDb05zMUlXb3FtZUlhRHJLWG1BVElKWjlJc3lB?=
 =?utf-8?B?K1JKLzVndjFZU1g2QU1rZ2NqMERGYWhlaHZraEpSeDUyc096Q3FsN0NON2wz?=
 =?utf-8?B?ai85Q2JaVnB1eFQrS2IzTk1kWmYzMEkzWHFBQWdoLzlLU2NoSXliRmZZYm5x?=
 =?utf-8?B?ZVlWaHliWnRyYTRZZm9oVHZBQlFsbTVKbkcybWsvV0RKZzZBK1lHTzhuLzN1?=
 =?utf-8?B?d0p0cFcvUjY5TVRVQmdQUTRjY0N6RFJaRFllT0l3ekpTQWYyZHpzbVBwNklD?=
 =?utf-8?B?eGYzU05aQSs0aFhrQjRWbTBrUklLUEllTm9jRjdoaytwdExiSjNsNHB6WEtx?=
 =?utf-8?B?aXFoeEx5RkdtazVoN2E0dWFHTXJrQjRESXRNMG5vV0FCU3BjRzkxYUF3alM3?=
 =?utf-8?B?ZnowcmFFc1NrLy9FeGY1SzlyK3JoajlyalIxQ2dORlNIOGhxcVpkalRzNFA5?=
 =?utf-8?B?NU1tS0NQN2d6Q0UyYnVsUGVBczBHWUM4bElDc1lHMVlMTHZYNEdMUFJjeVRS?=
 =?utf-8?B?OURjcjVTN2tKTUZCbmZoY0NoeVh6R0l0amVnMXRQZFBVWit0S1kxZVgvbXUr?=
 =?utf-8?B?SFJkNTVzTUd3ZHlJVGVtTHRuS2piVGhFRjhkWGNDeU9tbStOTnJzbjVYWkxU?=
 =?utf-8?B?R1h0NGdBZ1JEQmRNa1NTUmYvMk45MnZaUFpXYVlybC9GbGtCZkdvM2ZMc3c4?=
 =?utf-8?B?MDU4aTkwcEdZSk85U0ZPK0ZYNmNLNTNnM0liMUJYUkR3VWtaalVyVDFsbWRW?=
 =?utf-8?B?Ry9nR0Y4Q3Q2a3VDeVRTQUQ3azYzeVBYMXByMk85Sm9zOHZrTlp2YXl0Ym82?=
 =?utf-8?B?cnZSWUREWWU2RUtkSU5lYVZPZSt3TVVqN0gya0FHd2FmbWlqUzlXRmRCUGlx?=
 =?utf-8?B?UkpJNVpod0FvVnNkYyt1TGFxTThLc2FKb2l0ZzhZdzdhQTIvQWVoOW1zN3Ja?=
 =?utf-8?B?UFhZWXp6OGwwYTRvRlVUdE52VWdkZmJwVE0rOVVEZTYvS0xFNGN3SWhOa2JT?=
 =?utf-8?B?ZWlPQVRJM2sweGFPdDhuMzIxNTdtL2RFei9sc0JQZlNwVm5hckIrVEdLUmZ3?=
 =?utf-8?B?WmV5MWFOeW5jMm9sc0ZPWWJYVEU1d1ArbWwvRjhKSlR2ZkpJUnAvenA3andH?=
 =?utf-8?B?cUNTRE1hOXlpdHVGWkFudWlsYkdZMzBycXM3cnR3WDF6ZzEzMHNvOW84Z2h6?=
 =?utf-8?B?ZXZZeXIvNHRSNzJOQUJiM1RSbDFxd203bUNlOFVndERzK2JHMXI1bDJrcEVl?=
 =?utf-8?B?OVBaeDJxa3JmZXF0VG9uMEhMRmMrZzB3VGFZenoyTHdoUG1KSzQwSE5CSEtR?=
 =?utf-8?B?L1dpZkp2SWR3VmxsdTl0V3p0VXVBMkxIZFJkTDJSMVpXcXRGSEhwdEFiZlZZ?=
 =?utf-8?B?dk1YSXVkL0dQUW54b0hwZ3BJdGVrMnprRU5rdkNFR3lCazFWaGxoZ0U2bTUx?=
 =?utf-8?B?bzdEN0J6dnljRGlwd3lCZmE5bWZXWXNNL2lpaitiYzdsTTBiZkpPWGJLL3Fx?=
 =?utf-8?B?RU1VaHRrM1lCTllsTG5iWGhXOXhZamthMldLQjVwenhJcjduYlNWZWp6UFhR?=
 =?utf-8?B?YnJXRVhiSks3S2VKQjJmYXN1b01zTWVTQWRLbktmRmdPNk5ZYjlKd3drSmov?=
 =?utf-8?B?ZGhSZVJtV0hVZElveFFheGtlY1llSTluL2NTZ1hqZHVrcE15UGhDelpPUzRz?=
 =?utf-8?B?QXNiRDc3SjFzclBsbmUreVJINy9DRmtRRlExRHFYZjUzTlNpbnpDVzgvbkRW?=
 =?utf-8?B?UTVWaEhqSGFyZHNUSnRiY2ViTGc2V0ExMTJaWDhnSFJBZU9FMjhXQUptZ21w?=
 =?utf-8?B?Y25CblBxU1EzQlkzSE5VQk54c3pIQno3eWtlK01pc3Eva2ZJekRQUjdYRkNx?=
 =?utf-8?B?NzJleEgzMHJKTVlsTGo3ZitxYmE3SHVzaDU1U00yc3FxbHVSa2ZDV0wyYVNT?=
 =?utf-8?B?a0tJbkhmc3VhbWNDbCtONTVPaVNzWUpIMWp4L01VUk92MWRSQ1J3ejE0QVMr?=
 =?utf-8?B?eXMrZE9mVkN2SCtjcENmZEZVQjVaTlF0RVJnT3BqTUlvbGoxMmVRV3dBT25t?=
 =?utf-8?B?VHhWRk5RdnM3SHhYdGZZZW9QaTdnOVJQTU91K2J0TmlLV3JpMDA4NXYwOGhV?=
 =?utf-8?B?MGZvM1dNYmFsem1LeVdFNGt3elBjd3FDODdwSzhqcEppOGRlUlp4ZEFsM2JD?=
 =?utf-8?B?KzRHNVhZc3hRZTRRb2FCSFNFN0poN2dhYW9kdXFWenNVeVVXVGNnaEtleEZN?=
 =?utf-8?B?a2lJTkY3Ymh0R2xkUGRvUnlPRHRzaDQrbHpIcGg4dHYvK2RIdlk5OUMycitq?=
 =?utf-8?Q?JqaZ59HvkF2JivPWlPj38BIc1YmyxKM74F8v4?=
X-Exchange-RoutingPolicyChecked:
	UuuCIoiUSJR2+wOIzgSOHNoYNsYTR/Pi24xHyAiQnNWX0C8s4P6bkJRmUmOpp2sGbj6mx5U19C+cxFSWafnovrq7JNvMFhldgnwyqQrdDLkPl37om5CDJUlD1vlSYFNSqnTjJWhizLriVUpACLeXHc7zYJqNbzuw2VfAUS19OSBtRFecoxaM9tfQetnefI0l1xkTeWdLSYRp6p3+G3HR6Qv8gIVg07jicSj1TVth0ClErUM/z5Oi1g9Kw7fJrPTWYikOF1o3o2Go/R7woZTygh5GBVo5kBTamK+ZO/mYP+zNU72zkAKgt9DQSUMpKtdqC/rhI0oYTnwDrtF0Jmk/Nw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VUHZVlPAykI5dR3R/ouiSTJwREaWdxH1VfzbW8YufWBLYQNt3vt2JdlU9GEKXE5Ye4kpSd4Z0XBOPhdotPWtM5IyG5fTUvvHnsjdEz/JsESVXM6hW2PY36kohSlyeLjq07YtrTt4ewNVnT04FIEa5NmtxBRD0bDW/RZqP2vXdoDZAxzdSNgGKj4xLxkcn1BGdd9PKZIEJOjcE9//3UeNBJF0C3zKkDgD+vsiO8QswRgN22IdldqYeGV/O/EePAByBSnHjR1Wd/K7qOyrFrbNkQXJQe6mYCoxUkKNTw71YxVF7UsRmQRQ+SfUot05QWdcuNV8rFcehXstZeP7a5VgwmGxODpVDU0Ys/dAvf/X73oG8z7yDD/NcW8H7KfAXLWJ0Tu98DkiiMlgyAhPIMXu2s2qrl/6EBVmOuk4qQfD2BWnCFJ0i1/5fZci9R8ZPr1DtXD16j/eIY95XdG+bls3oPr5NilRMlhMOlJrazGGR70nfoTwC/Ueql0VcTcu7DHL+XnvmMJYwMTvoPr0ZLgW+q4QMDO9KGMYzKiV1wEPqtH9qA8o0yFAYe2i5G+HX/qXzEZiUY4cMBN7Riyj45WVHSUsFv5wC1hapckoq1+Gb0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a07f0cc-e6f9-422d-0e9d-08df47e5f694
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 15:41:52.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PiG3aM8C+SAOYS9oj0v7CtbY5xtoyV7grq/EX2L4YMoCdLpKEml2ngdVAyYeBwiU8ZMOmxJA4Dmawq1aXaJ9e6/anOeVLdgeTBeuoBvnPmRG+nS6s0trWUtQsxDIDc+i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210061
X-Authority-Analysis: v=2.4 cv=dJIzC+Zb c=1 sm=1 tr=0 ts=6b01bbc5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=zd2uoN0lAAAA:8
 a=VwQbUJbxAAAA:8 a=u56hqi7jsX8yg3cP7pcA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Proofpoint-GUID: f2p8QsPMbT2FKqsN1RbhsabPjrLvz-Zd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA2MiBTYWx0ZWRfX3lGLgwcH4+K7
 HpDiYPu1Hts17uVUVRtJCZEMIoSB5rvIxpNhYmkL/+sgk4VH6FlbkFPwO8uZC6RfQqP1vt5a0ZN
 wovzNt8Tnn0vnxuLGynVCuKMwbZxvhVVOFsSx7eQXxFqzBlgMJ/eAngbQec8GJ8h9qMACogqxYO
 HPzuKx5Pvv4oGueNRwYifa4kYyu9d+T2VcOZxb9HATz/hRjYpyaNV3IOWyFRuAErZc7XtawpwbB
 tWC5krCaUAi8Tk3MSvqXj4to9EPdTaWx8QG3LN33P4bXqJi1mMIPmPoaQgnmUC91Q6JZX4ldeuZ
 RsMpYwmLPvoC56znLsraqP6mhNLbOQgWbl5xkKqa15W1snHoBHXLDMaKK1ukZIp4OWvgRR9eWr5
 xj0LBWPf46Qsy7rdDJPiWHysLQMjPzbLe5HtePFrOzsaUwQjUpgrx/22Zc1Jl9RbuwCik0RTtW/
 o18+G7zjBASMmQJJhb5ewRxV+TO3IKehO/bl6Qv4=
X-Proofpoint-ORIG-GUID: f2p8QsPMbT2FKqsN1RbhsabPjrLvz-Zd
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA2MiBTYWx0ZWRfXy/1yTA3ovE/3
 eVENdT5PY+MaDStCwTh6swo5+uKSQFqAatm6HSDb3XkF5Wj8ih7eVt6ag3UT/SNLFYsZ8A2uCTZ
 uqpTzX7ck6NnGeU2P2JZ1AWD3V8Zj6TGacepXwulizsUcirPheN/

Hi Greg/Sasha,

On 18/11/26 8:19 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: renpanpan <renpanpan@kylinos.cn>
> 
> [ Upstream commit 0de95c96655c8a12df62e47871016f49e5cd8618 ]
> 
> The amdgpu legacy DCE audio path (dce_v6/v8/v10) unconditionally calls
> audio_enable(pin, true) at the end of afmt_setmode(), regardless of
> whether the connected display advertises audio support in its EDID.
> 
> This causes a phantom HDMI audio output to appear for displays that
> have no audio capability (no basic audio bit, no Audio Data Block in
> EDID), because the GPU sets the AUDIO_ENABLED register bit, which
> drives the HDA codec's ELDV pin sense, making the codec report the
> jack as audio-available.
> 
> The radeon, nouveau, and dw-hdmi drivers all gate audio enablement on
> display_info.has_audio. Apply the same check to amdgpu's DCE
> afmt_setmode functions.
> 
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: renpanpan <renpanpan@kylinos.cn>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 842a45c68e0355eea47796551c8761c0c77e8ce0)
> Cc: stable@vger.kernel.org
> [ sashal: Replaced unavailable connector->display_info.has_audio checks with drm_detect_monitor_audio(amdgpu_connector_edid(connector)). ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/dce_v10_0.c | 5 +++--
>   drivers/gpu/drm/amd/amdgpu/dce_v6_0.c  | 5 +++--
>   drivers/gpu/drm/amd/amdgpu/dce_v8_0.c  | 5 +++--
>   3 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
> index 0b872bc71b70d..d77daf89a9dd9 100644
> --- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
> @@ -1738,8 +1738,9 @@ static void dce_v10_0_afmt_setmode(struct drm_encoder *encoder,
>   	WREG32(mmAFMT_RAMP_CONTROL2 + dig->afmt->offset, 0x00000001);
>   	WREG32(mmAFMT_RAMP_CONTROL3 + dig->afmt->offset, 0x00000001);
>   
> -	/* enable audio after to setting up hw */
> -	dce_v10_0_audio_enable(adev, dig->afmt->pin, true);
> +	/* Only enable audio if the display supports it */
> +	if (drm_detect_monitor_audio(amdgpu_connector_edid(connector)))
> +		dce_v10_0_audio_enable(adev, dig->afmt->pin, true);
>   }
>   
>   static void dce_v10_0_afmt_enable(struct drm_encoder *encoder, bool enable)
> diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
> index 5e21eb88b2e71..429c97751e5ca 100644
> --- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
> @@ -1702,8 +1702,9 @@ static void dce_v6_0_afmt_setmode(struct drm_encoder *encoder,
>   		dce_v6_0_audio_dp_enable(encoder, 1);
>   	}
>   
> -	/* enable audio after setting up hw */
> -	dce_v6_0_audio_enable(adev, dig->afmt->pin, true);
> +	/* Only enable audio if the display supports it */
> +	if (drm_detect_monitor_audio(amdgpu_connector_edid(connector)))
> +		dce_v6_0_audio_enable(adev, dig->afmt->pin, true);
>   }



I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this backport gates HDMI audio on a detector that reads
only the first CEA extension. It leaves the pin disabled if audio is
advertised only in a later collection that upstream recognizes.

In dce_v6_0.c, dce_v6_0_afmt_setmode() uses: (Code spacing adjusted.)

5.15:

     /* Only enable audio if the display supports it */
     if (drm_detect_monitor_audio(amdgpu_connector_edid(connector)))
         dce_v6_0_audio_enable(adev, dig->afmt->pin, true);

Upstream (842a45c68e03):

     /* Only enable audio if the display supports it */
     if (connector->display_info.has_audio)
         dce_v6_0_audio_enable(adev, dig->afmt->pin, true);

The 5.15 drm_detect_monitor_audio() path only uses the first CEA
extension it finds. Upstream's display_info.has_audio includes later CTA
and DisplayID collections too.

DCE v8 and v10 have the same change, maybe we should provide equivalent 
audio detection before using this gate; upstream uses 0374ffa507d8 
("drm/edid: parse display info has_audio
similar to is_hdmi").

Thanks,
Harshit

>   
>   static void dce_v6_0_afmt_enable(struct drm_encoder *encoder, bool enable)
> diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
> index f3b0642f9d9d2..dc72c04d9b7f7 100644
> --- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
> @@ -1667,8 +1667,9 @@ static void dce_v8_0_afmt_setmode(struct drm_encoder *encoder,
>   	WREG32(mmAFMT_RAMP_CONTROL2 + offset, 0x00000001);
>   	WREG32(mmAFMT_RAMP_CONTROL3 + offset, 0x00000001);
>   
> -	/* enable audio after setting up hw */
> -	dce_v8_0_audio_enable(adev, dig->afmt->pin, true);
> +	/* Only enable audio if the display supports it */
> +	if (drm_detect_monitor_audio(amdgpu_connector_edid(connector)))
> +		dce_v8_0_audio_enable(adev, dig->afmt->pin, true);
>   }
>   
>   static void dce_v8_0_afmt_enable(struct drm_encoder *encoder, bool enable)

