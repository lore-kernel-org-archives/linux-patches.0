Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795275336;
	b=0c19rtvSg+bo2AiecrUOtu13w8N/T0ZA2rdK0WMmMXpQJumEWuBmVh/H3UqbByethZfs
	 v2ZJmXoFd9bOzmMysnaZQLMSXJF7sow2W8PmA5IH4U3YwT+fLhduP7MX6vCX4pgJeyH09
	 0YCR1eMpoM9CRWCRd/vCOJ0/CiZoyuTK12KPgVTvpJBj9ZOOOQbvo7fRc8TY1tP+h7zBP
	 9b963Fa9tI6QI7JrBDxzfzGow8kWmwkxnz3SCmoZuHfp3nvOwp6BLX0epAA2f8qyTZVOK
	 awEdLBiaxnjT7QzbGhNf8axXdYJtC9fatXm/oSBDqdzklivJ0mTWd/1EsmczhoQSgyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795275336;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc;
	bh=dNaE+tA9+RJtiKaqQBYAx3F2MnPERIp+CZXIiIOH04Q=;
	b=BeR339qDMYccFq3LjJCZj0hWt++1NYr2DtranxJQGDMYSC+VHN7n6zzQyAkIUZrStvCa
	 cm0epOKb+YRSQV7grM1IuT+jfWvq30T0rZEF+OfGKXehpAe+JZO45Ve1BqMSo64WBZAhY
	 BR7wkJxN0xexcPH3LWs7ogk6chFIh0+pvbQ7DbMC4OAEFGRPtzm9hQr4yeT1WFzRWKsH2
	 z/+Rxk813jf9e5Uxuv4cZIqAAnehESR+IaaclXLCI0+t++qDpsNVlOHBjqsNzi7X9fHKw
	 3rIGxkVlyHJGHfDQicTd26e6xmAvM2883Xv1GZ+xX1BmR01OVRBLdGk5CKOT3+7X+KA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=I1KVpKGX;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=Xjojhns1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63285606A32A
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 15:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63285606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=I1KVpKGX;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=Xjojhns1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALF2Rf0508545;
	Sat, 21 Nov 2026 15:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dNaE+tA9+RJtiKaqQBYAx3F2MnPERIp+CZXIiIOH04Q=; b=
	I1KVpKGXc+2MvICjvyIA+2+xEVkY6J0DLSU2xOA7zooWGW3qH3ZK0kusD+XZDBir
	0XV3oc1WdzO0WTPzdTKFy/dk0AQNXNO6DjKidDPELsgZuXt1KHZtFidT5di18S5L
	ONgm220FX10OxV2iGQd9fTpxYBKjwpkCIdlC4cGfYg+zA32oqWmGg1I1LYVgperX
	S6TNV89GUd3SgO+x8O+yhtYxq6Tf4l5v9cO/ZrnTZwDmTrxCkznU/5uWWoeHjmbq
	S2kzhaPagUfMkB/h4X9yEnMtq+aDOuFeh1pHWO0D1UHZABdEGuPpQoi9Q+5hO6yI
	s+CUxXaKnCUJynqADxK3pg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34ts882y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 15:35:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFXeao2828472;
	Sat, 21 Nov 2026 15:35:29 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j39pbm313-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 15:35:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QEpRi4zABuSx/0VNewk0WCpWRBMingjBMVUjQmDNu75cll1gV2/w6e7RxRsg02HH5ZU0v193XOnS7FFGBImLL340F7wneYPP4Z4Oc7uKkQxvEuJxWRaMhgTG+kL71x5nVISwgxCYnznSnnMOqwGjbkG+CGrixRafNNHnhj2WLLF2/catWBLYler2Be97wz0ejuYeUj9YYDqN9fe1JlgGrFtl021fixXb45alSKL86Y80qyAiTumSOTxX9om4+DsyaAi1izMqSncw9ng9zMVar4tcFPQPXP3m5qIBvF+5Xg+za+WO8RKTuap5+Jz+HlrnproSfqeSfPexUHgYtmAbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNaE+tA9+RJtiKaqQBYAx3F2MnPERIp+CZXIiIOH04Q=;
 b=agOE7b20xJawFhHpfy9r7cnQj+0uZTXuam2s9d2gYfjoiLiJj/+WkeLlmIrHgNQ5V9lf43qN0fdr3CLh0pEzvNEzVi/iUfmbj0DfTsSXyjAygzj4JidyRewrdumDs8zJe63mT342R6Nt0Y/e59mAJ1oG9xhI+43X7KuI4g4aiCOvFZEnDH5dOzepc5uh17MLsdAwyTb+znvA8EZeC0wWxcMBFx3w8s9N7x+ue8+tNZRiFejrWhKDdIJiAp7MUl89doCzLqcc32ksBBSz5arxRHZLSNSRcRbc28ZiDTDuyxFGFxTpUU5NrQKTx65rEhvcOc7SbzVNDvk3uJklbk+WLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNaE+tA9+RJtiKaqQBYAx3F2MnPERIp+CZXIiIOH04Q=;
 b=Xjojhns1WbehnZtS7JGvapsMAswafPdb9QlcETC0T4rWgOJhpB2Y/N65ityc50zPtRvaSMvxs1c+amHkafhtj2H9C2qTya2arWPgPRy41idphgVGFVz4NLByR5CVLYjGZqVkNYrQ5ofNAY954YJUqe4rpLQFX/rtbNVVhZsJQXw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by FT1PR10MB180751.namprd10.prod.outlook.com (2603:10b6:170:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sat, 21 Nov
 2026 15:35:26 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 15:35:26 +0000
Message-ID: <6389e16f-c7ec-4bd9-aa46-9abf015fb19c@oracle.com>
Date: Sat, 21 Nov 2026 21:05:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1213/2214] inet: frags: limit the truesize of a
 reassembly queue
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Kyle Zeng <kylebot@openai.com>,
        Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiayuan Chen <jiayuan.chen@linux.dev>,
        Wang Zhan <wang.zhan@smartx.com>, Paolo Abeni <pabeni@redhat.com>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150100.329194686@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150100.329194686@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|FT1PR10MB180751:EE_
X-MS-Office365-Filtering-Correlation-Id: ce724766-2fc1-46e3-43b3-08df47e510ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|10067099003|5023799004|4143699003|56012099006|261021121427099003|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261009223027099003|261102123227099003|261028144727099003|261102130727099003|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oMLBCWWqamALLeY5Y5yamLN4Iu8ckyJ5yQw6/Fubz1f/I/W7FM8XlAcFZAnLlhy+9Ij7Exkfukv7tTDS2umPl3fDLVn0irf/aZVu9DhXMQ2L8W/6WTpAjBZm5xH6tpDiWe0Lu6l6A/v4L+3EbNi+rfAww4+zNHteyA5rKiys9BI+yWNxLw3JbdtzJKj4ccWQgfMQnryMpn953fYCkZRtiLoUkB9aG/mn/Hs5lMZmjmJoX+R2wRe0VlyzdKHavKikQOy0OZXE5T+sMARHkuGgNn1viMWM1+4WpNEz2IgomZV8Yne9iigssDxEWvVQwgBO+9bfMi6G3RModuNYRiSi4iRYBoZCSWsW11tLXSwVsnB92VWeb7Noxn0lm04GHvalkFKQx1DcU8X5lhnoYAzhkAAeBbI4f6nvw4xknsAHHKRqSqoBITv8ktA2qwg6AHaru4IE6gh/lyo+nwBRYz9b8pERq4+eXR29g49rvQ2heYH2etmChYdtTGVJmt6zSCeQkGwwV9HkeoB+LX2ROCeTfvgG9j4YctfFfGdOzxZnzBW7nBwyAZPgex5SrMYixDi072sdbjF+JbLtN8U/0pHn2evFIecCNcPar0gGQx+/GKPcPo93aDuh0Rcc+yWy6wRs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(10067099003)(5023799004)(4143699003)(56012099006)(261021121427099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261009223027099003)(261102123227099003)(261028144727099003)(261102130727099003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlFBaW0zSGtmT05TYmJ3dDFFREJWd29zclR6M3RRUlBuT3IxNVhnVUoxRUhF?=
 =?utf-8?B?MERtWTJmNFVHNFhnb09NRTAwNVFnREZJRzQwMmh0V3hhS0IzTisvYlFEVHk3?=
 =?utf-8?B?ckMyczF1dHJMZDJZN0Y1WDFzcGNVazFFV1ZmTzBKblF1R3g3SThxMUlNWWJx?=
 =?utf-8?B?OEovWHdxQmxiODlkTmRBZm5KZDhVdkZydWI3MXplbkUwVUovakpZOUMxV3cy?=
 =?utf-8?B?RkRIVUpFaGdGdFR4bU1mRWJBVXZSMjlCdUVaNE80TjVMUWpCL09KdnV4Zklh?=
 =?utf-8?B?RFdxdHpYM3E4OENxK1Fqc2liUWEyZU5sa242ZHZpM01PZGRIY29ocUd0Wk5G?=
 =?utf-8?B?NGFqTTJESWhWYTUxTnI5enJDRzdqWEtINUFxUFpQbXlLc05lZnJ1RXR5NEhZ?=
 =?utf-8?B?NnVQMnp5NUpJdHhwRWV5SnlHeExGQXlCcTF2WWFUUEZPQ2VMVGJ6dUtKaFBP?=
 =?utf-8?B?UjN5RXlma2IwZGhJRThDNFV6SmowM1dGZW5ZR293WGNRa29CMmNJOXN1L3pG?=
 =?utf-8?B?Y0N1RUFQZnRnMkFaQktKdHkzMTJLV0M3WGRPYzlGRnRURGRNMkxmUE5LY0N0?=
 =?utf-8?B?QzNydjZrODJyRU9wUkZFWWVOU1VRZ0Nldmp3emNiN0tDODdnd2lOZmcxRDJ2?=
 =?utf-8?B?aWttUzlhemZIZ0VvZzVRNXhiNEN3Q21xNW5hZDJ6aHVKM1dPY2RHSVZ6UFZa?=
 =?utf-8?B?ZGpYQmNwMU5ianlzYldtb0VRUDBBU2xDeitRSElNRkxIMkt5UEwwZGphQllZ?=
 =?utf-8?B?dHZXTkpDa05DOEo4aWRwV0xVYjFlK29oalZBWFNMQUdvemtwblEybUhHSDdD?=
 =?utf-8?B?TTZQNUhVUG5FdWl4cm5XYUxJZFpzQ1l5TG5xaDAva0R2WDZHSEV5Wk0rZ1F3?=
 =?utf-8?B?VzhFOFMweGRhUkNOcUtPRUpZZHpFa3ZZSTE3NndDdUpXdDlySUZzNzhDT1dO?=
 =?utf-8?B?OGVyZWJwb210MjVmclQvcWdOY1RkOGh3OXlnNnVGMjNCUXdzRGlmRUt4dm1u?=
 =?utf-8?B?bk55bjYrMUtPLzVmVUpBRU8yVnBiUnJMc3pZUDhsdnhJVmswczZCdW5mVlZK?=
 =?utf-8?B?Q0RzcHBuazg0VHE0dzhzRmI2QjFJUnExb3JzQ3owU1dacXUvcnB5UVlrNFBT?=
 =?utf-8?B?eGdLdzB6WjhSaVlLbE83NmFSaDFWSUxaYXdBZGMydWRoUEZhcXlXZHhVbzZU?=
 =?utf-8?B?bkNLckM3NVlmeGYxVVl4NndxcGYxcEpjWVBnN0lKeS9ScHJxWGxEdHBMUk05?=
 =?utf-8?B?Skd3aUZmR2p4dlJIT2twd2ZXMkdSaHhLQ3JQWTJtdi9RWVl3djVkUktkbkdB?=
 =?utf-8?B?RjR3ZGMzNWlaSE5aOXlzN0paazFoMVROcUNUSURYTjN6R0FjWHRJVWsvRjgr?=
 =?utf-8?B?WUZVQXZ3WTRlNkhxQUxiSjBMak1xR3ZsaWp6VHlxRWRrbXlLSFhBRlFsN3M5?=
 =?utf-8?B?Y3ZCOEwyb1ViSjRORkFpM050TU5GbzR2VkorQklHZDBqa3RBY2NyeDFxMk5V?=
 =?utf-8?B?bEJnYWU5YmxadHkvV0pERFFHQUlXaUJwM2F1Nm1CYmdVc3ovM2RyOUhoUHNx?=
 =?utf-8?B?TmozU3FkSFAyNnduOE9hb0ZtOFpwdHp3dTc5cmczcXIvbnROWFd1OXJLT1BL?=
 =?utf-8?B?eTlaY3NpNWl2cEk1VkFJbmQyQzJSa05SNjNZY2VhQ1EyeStxY1d3bFJEaEtn?=
 =?utf-8?B?NjJQLy9FRXNTUk02VXFzQkVqMTBaVU9MVWFQWHBxMTJ3K0cyZUhPUHBMTHlr?=
 =?utf-8?B?THF0K2FZbVdrNjZCSWl5cDB6cGdQa1U0OWdiVmpQNUxOV0JHeGhyWk9QTk9B?=
 =?utf-8?B?QUw4cDA5UVdxaEgyNHU1dmw5NHZobFdjNmRycEU4UFQrQVNIQnQzMHFGMWUv?=
 =?utf-8?B?QU5XY0JYbHJFbHhTT2pISTkybFFwZDZzSGJQa3Z4M2xpY0Y5NEJmdXMzbWNS?=
 =?utf-8?B?UkZjYmQ0b1B6N3hSdkhZdHdsaitEVVkzMDJxbFdZeHpCUTk0VksvRFd2ZDFk?=
 =?utf-8?B?R1FsUGsrRVhzRjFFVGVOUnVtTHNyUE9nczVVTXN4b2VSWEw4Ri8vSVVQdEFZ?=
 =?utf-8?B?bVhDTjdreHVoR09QVmNMelpDeUVjcjhoRkFWaXNJYUU2NWdTdTJmODV0SWI3?=
 =?utf-8?B?bmpsK2U2bTkwZTN3MzhOOVJxbm42WjA3V1ZBM1pYZHRLTnB1VUJKaXV4U2Vt?=
 =?utf-8?B?WkVHdTBDVDIyeXdmVFh6MWQyWDBHeUtDYlFvWWlJbjhsbUJLbHFmYU1sSG4r?=
 =?utf-8?B?eDNLTjdMR2M1eXlpejhmdWpiS0JzWjdpQTFWemZXSS9YZUIzUEN5QTdDQUZt?=
 =?utf-8?B?bUFneUlIUE1GQktUUFRDdnR2NFNXb2QxaGhKa0FOdUJMb0R5VUE4Mk9HRUFM?=
 =?utf-8?Q?kUWCh06PBKZn/VYh5YcG7o1dMurXAW7mrb/Up?=
X-Exchange-RoutingPolicyChecked:
	SuOyVC0WWljwnS4AedRbSAlX41u4ikhhuXFERj+bdm7MhVV2rfc8YAlGu5UuhQIglCP7H/6srbnm3QZNYuFHsJOcZahIfYMeVT20uGw38n4gP5WmfIsd0gBBxUhZpVH4i20NMgUxgvZP2TFa4KzGkO0JIDvOTbrcsvtiq/Yqxsc9KqgIvF0qG6ZS7kFGrOAvOpeTvHG/CfSPgkaeIQLTdmCwuALsMsk8/0bCtLD3J/eRCCyKbRFkvN1erMhBAU0yJaGUSFrbctMy3wB5615auNq4w0OQJrLzyZTtf975BONH2eruSWldpDVnrvBH+fQC1EugOjr9ifb+Op1trJNq5w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UZ6w9GKMRgiaImnaBwW1ZCMbbK3pM+3hLQEw4pg5NDrCNeflWN+OtMQXRSkkrYfMuUpi+3Wtt4i7Ls5BeRkXJPby4AV1hrRgbB5bSmnlMsCa/Z+XwZ+jv2JgdhzPXYDF+09Em7+EBe59wW6pDiW0F3u49Ak43jcQPUY5L/XNdH4FiNLchQPzZem9nl7t4GTZZkncrN6Cb6Dr14vQa7WeqbcDteLUhOJH5ERMlqkCoG53Cfmdqurca0LUisP22TBCIhDaceF0qdatly4WQKKKjXOSB+FlWnkeFxwct63R8ZXCINwwz/WMK2huYQeSa9j6xU+KJJRjmbmLwJnZKoQvZSFcy/X/fzfWtOTDi7IADstf6x6ZAb0eRe83BiApy2z5NIL/0cXhitQvZGDne8Zpnrj5xH6JX6M6pk6pbeLyBK/wfnDOI9NPIzh5f4vHvuv2c04fF6GxVnjMVtd+JwUAPMVJTvcwL1PDPUieacUfVdkD/+TiiGFy34Vd9CnHSps5JiVkRSYpmwlX1Qu57pNj0/m+ErzzHi9H0eKMjCMmLOfBLIa+oy4ZYuvQi+QMErVNrw7XtL0ShkszcMLmgkC1Bx+vT6Jz5iEHctoUfEwAH7o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce724766-2fc1-46e3-43b3-08df47e510ba
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 15:35:26.4711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9maSaFi450RtQP4OQXdWbgkkG+9riwLAgh1uBS4KqEU0vBYViHqTcgHFrnlQw5y928RDqZ23ybu8IdXLQMJL6oZVWNtU29S51LbfmvvWXO6k1gc2RyL7dK+17xh3uNz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR10MB180751
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210061
X-Proofpoint-ORIG-GUID: egQk5lWy3xpIgRoNEQKh0pgSCWGtvc1_
X-Proofpoint-GUID: egQk5lWy3xpIgRoNEQKh0pgSCWGtvc1_
X-Authority-Analysis: v=2.4 cv=YP8KWhGx c=1 sm=1 tr=0 ts=6b01ba42 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=LG5T7v2SAAAA:8 a=Ikd4Dj_1AAAA:8 a=YOhUVxJuAAAA:8
 a=20KFwNOVAAAA:8 a=05i2wL_Fj_YP-8mxkwwA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=ChOrQ5FjrQQUR65FPv4f:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA2MiBTYWx0ZWRfX4SpGoa7K2XRP
 UZU8q4bCtwACPeFVA14dDZUt8jT85DiKasnRUKFx8OWLmIhnY/gk/hcXHvhXd/0BWnAONtizx/q
 FhZLkgpzvaZiyOrCs8Bbi8PGuArJkhLApL0uACw50P1JXGCpacg+
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA2MiBTYWx0ZWRfXzggKoM984l9v
 md6AWJL0qL7A7sUwMT6rXhvO6MZlx/ghib9U/nJFFtEZ6VlASFCEGSAtpOJ7tFH1Aka1NxPOPPE
 nqWQGK6YdlrRXcXe5z00jLjyqUazcs+KKSxAQqPzqNjYkIBTd2IW/qMO4KR7hgE/6rX+EkYt2cW
 o9EUyiewp/ixPCFhg9YSKfmM9rj1dzxaV7FQWLQqFG5q5aCSvuXOylGDc5SFxDnjZu5CzJNxqMT
 e/c/8PyFodDmB4PIB1/0PIUxo0uuBAypRObMPh3jq1Cg0oWqhOh47WBL2e6c1zwQ0TKKLyPqTXl
 l/dpy5Xd2BNGFcvEWD98rzYLXmY1oSrDcXh91Zqr5VqMG8aLooI/bq3QIDnOwxfGmR4ltrjEyX8
 Z0Ooph8gWPWUFYeVNhcgPyiONJV/to1gGLeMRauTjojaW9dw8Y3pTz3Yw6QcfviilmkQUIMMcax
 j+lvBBq2uR8UawUkaQUi6uVxTIYppnqP2X7vyt0k=

Hi Greg/Sasha,

On 18/11/26 8:18 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eric Dumazet <edumazet@kernel.org>
> 
> [ Upstream commit 3ae20e4697eb969104fe4b1e98a675f0100382b6 ]
> 
> The truesize of fragments in a reassembly queue is only bounded by
> the per netns ipfrag_high_thresh sysctl, which has no upper limit.
> 
> inet_frag_reasm_finish() sums the truesize of all fragments in an int.
> If this sum reaches 2^32, it wraps, and the final sk_wmem_alloc
> adjustment of the socket owning the reassembled skb can cancel its own
> reference, leading to a use-after-free of this socket.
> 
> This can be triggered from an unprivileged user/network namespace,
> raising ipfrag_high_thresh and using padded TUN packets, which keep
> a large truesize after being trimmed by ip_rcv_core().
> 
> Track the sum of the truesize of fragments in each queue, and refuse
> a fragment that would make it bigger than INT_MAX / 2. Callers kill
> the queue on this error. This bound is far above the needs of
> legitimate traffic.
> 
> Fixes: 18685451fc4e ("inet: inet_defrag: prevent sk release while still in use")
> Cc: stable@vger.kernel.org
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Cc: Florian Westphal <fw@strlen.de>
> Signed-off-by: Eric Dumazet <edumazet@kernel.org>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Tested-by: Wang Zhan <wang.zhan@smartx.com>
> Link: https://patch.msgid.link/20261030081225.2575462-1-edumazet@kernel.org
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> [ sashal: moved the truesize reset from inet_frag_queue_flush() to ip_frag_reinit() ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/net/inet_frag.h  | 9 +++++++++
>   net/ipv4/inet_fragment.c | 4 ++++
>   net/ipv4/ip_fragment.c   | 1 +
>   3 files changed, 14 insertions(+)
> 
> diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> index 63540be0fc34a..0114941b4c873 100644
> --- a/include/net/inet_frag.h
> +++ b/include/net/inet_frag.h
> @@ -72,6 +72,7 @@ struct frag_v6_compare_key {
>    * @meat: length of received fragments so far
>    * @flags: fragment queue flags
>    * @max_size: maximum received fragment size
> + * @truesize: sum of the truesize of queued fragments
>    * @fqdir: pointer to struct fqdir
>    * @rcu: rcu head for freeing deferall
>    */
> @@ -92,6 +93,7 @@ struct inet_frag_queue {
>   	int			meat;
>   	__u8			flags;
>   	u16			max_size;
> +	unsigned int		truesize;
>   	struct fqdir		*fqdir;
>   	struct rcu_head		rcu;
>   };
> @@ -174,6 +176,13 @@ extern const u8 ip_frag_ecn_table[16];
>   #define IPFRAG_OK	0
>   #define IPFRAG_DUP	1
>   #define IPFRAG_OVERLAP	2
> +#define IPFRAG_TOOBIG	4
> +
> +/* Max sum of the truesize of fragments in a queue. This keeps the sums
> + * done in inet_frag_reasm_prepare() and inet_frag_reasm_finish() well
> + * below INT_MAX. Legitimate traffic stays far below this limit.
> + */
> +#define INET_FRAG_MAX_TRUESIZE	(INT_MAX / 2)
>   int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
>   			   int offset, int end);
>   void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
> diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> index 6e6b46ebfc407..fb5973ffe4d67 100644
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -384,6 +384,9 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
>   {
>   	struct sk_buff *last = q->fragments_tail;
>   
> +	if (skb->truesize > INET_FRAG_MAX_TRUESIZE - q->truesize)
> +		return IPFRAG_TOOBIG;
> +

I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this commit makes oversized fragment queues count as
overlaps in IPv4 and IPv6. The new size limit works; the defect is
incorrect ReasmOverlaps statistics.

The new fragment-size limit returns IPFRAG_TOOBIG. The older IPv4 and
IPv6 callers count every nonduplicate error as an overlap.

net/ipv4/ip_fragment.c, ip_frag_queue(): (Code spacing adjusted.)

5.15:

     insert_error:
         if (err == IPFRAG_DUP) {
             kfree_skb(skb);
             return -EINVAL;
         }
         err = -EINVAL;
         __IP_INC_STATS(net, IPSTATS_MIB_REASM_OVERLAPS);

Upstream (3ae20e4697eb):

     insert_error:
         if (err == IPFRAG_DUP) {
             SKB_DR_SET(reason, DUP_FRAG);
             err = -EINVAL;
             goto err;
         }
         if (err == IPFRAG_OVERLAP)
             __IP_INC_STATS(net, IPSTATS_MIB_REASM_OVERLAPS);

IPFRAG_TOOBIG reaches the unconditional increment even though no
fragments overlap. This result is new in the backport.

Let us not drop this but somehow deal with fixing statistics later.

Thanks,
Harshit

>   	/* An IP fragment is never a GSO packet, but an untrusted source
>   	 * (virtio_net_hdr) may have attached GSO metadata to it. Do not let
>   	 * that reach the reassembled skb, whose head keeps the first
> @@ -446,6 +449,7 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
>   
>   	FRAG_CB(skb)->ip_defrag_offset = offset;
>   
> +	q->truesize += skb->truesize;
>   	return IPFRAG_OK;
>   }
>   EXPORT_SYMBOL(inet_frag_queue_insert);
> diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
> index 5cdc65a5c010b..00dff2c866154 100644
> --- a/net/ipv4/ip_fragment.c
> +++ b/net/ipv4/ip_fragment.c
> @@ -263,6 +263,7 @@ static int ip_frag_reinit(struct ipq *qp)
>   	qp->q.rb_fragments = RB_ROOT;
>   	qp->q.fragments_tail = NULL;
>   	qp->q.last_run_head = NULL;
> +	qp->q.truesize = 0;
>   	qp->iif = 0;
>   	qp->ecn = 0;
>   

