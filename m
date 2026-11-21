Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795267824;
	b=bal4PcFI3Ewus4sp3IKRqy5iVN5JjU5x5q1bukLPoepwJV9MReXV7mKI3t9eU8opvaFj
	 G9JPmiB776vvo1gQBikRWtNivERv2EKjBlNU9DeMpuPppKNZA2qYijh5dPsTH3DCkcuqV
	 oKIduS26P4r3B/amSk7Iyc6TjMQrmZohsm/WMnxpueobfpvCrhdXb/TSalVtYoqwcbNoI
	 iVmaJS0jIRb7eAEvUwSjWT8PO8aaGgJ2Cx5q3xJafm/1DMiz8xXyew1o4MwhUoaXWT9Wk
	 mxEe9KeK4cIq0rynOufwWcbPCMkaKcnjHMWflnFOO/kO32w/z2GTz+cP2Q6/HyuJubw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795267824;
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
	bh=oqwULVS8LtvCG85qZy0IqYiHnK5jNMIbmanCJdWgaNU=;
	b=HZTev2CfPivn2eDWxYr8vHpNLDC6E5q7VnUr00EKKPKRFrWfWkv2OsWFbAlHDXZ/lpEk
	 S+nF3B/FG5NGsRin/V4P+1xcpV8dusX6F0FgOAyCCTnTX0QVbX7dja81jH5IXvj0XTm3a
	 pT8NlWrkgoO/hmX3DoBcdP4OvQnylZ1PTxEGpwQo+aGd5iCBsG8sLqRuIqWLpJCAqmApA
	 /ae9BGPRp0alebweIEpGY0oCp6ZUF4fVrkseXJNKMixW3/OhYOsrg6k35bGPxZwMmfDiq
	 vUVSzOG0abGBKIJSpfnCEpDzhjyKjSsqbsWX3ONvItZRBjSWgMmq4lIQoC+YAZ03HQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=ZW82gx6V;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=M0iK1aKs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D988606A32A;
	Sat, 21 Nov 2026 13:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D988606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=ZW82gx6V;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=M0iK1aKs
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALBxT1x1985491;
	Sat, 21 Nov 2026 13:30:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oqwULVS8LtvCG85qZy0IqYiHnK5jNMIbmanCJdWgaNU=; b=
	ZW82gx6Vjbcgy+JJyBp/gm7fnKigYnvoMyLH9X1VMThhjJilj0dIkJ9OFQPShreA
	yG7RcWn73q+kGeHIzuYv1cuXw6+XJOCECHSN+UNfIg6epUz7cD4/a2Hy/LzycFVV
	MrR7BQ21+3q8cFHD/MrEGD6p+Ye/j+v68H8UqoJnZ39A+XaKDkGceroS0+yoqYui
	7SA4qxwREwYOUcBOJf5g3Vs9jPrI1n00VOawBfZKJrqLnNSkt0v9a4R335l4M6KF
	4Z8z046nDGBcNV1MnmEE/6mE9gZCW91HQmQTwogTWqtZ7EBL7k4MCaFmlyBAzLG3
	/YYcnFVPsZKT6kKRP+cqAg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t50708-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 13:30:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCHl9d309383;
	Sat, 21 Nov 2026 13:30:10 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010016.outbound.protection.outlook.com [40.93.198.16])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j39jgan5s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 13:30:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JUN7TBeR5JUc9ZhZLIBrybRFBx1cWYkb2sItVVt2cPkFAeLhhm3mjGPDNQ8FeHxlEfUPRLuTXz3DKc5ub8Ba5VOr9kIu4ml3GW2fDcYkKmo8L+AwV/4uUKtUSfqMpVo73KzS/TuDMAEc0wnlcPBwG7k/lIzk6SIv/qQ1L/Rzoyc+ZjH3H9wejG+tFQdzgMpzhd6XSXjD7lx73zh19zQBX+o5GoRpukpDfxqxonDsVFg1X6tbV9UtoEjdQCdnFNP74A+69tcVV0G1H3VvyCSIDbzqnTQ8yNlriEji91590xV2yfYP+JNwO1YqGg1d+Qzj5BLy/9e6quVaqe8mAkdFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqwULVS8LtvCG85qZy0IqYiHnK5jNMIbmanCJdWgaNU=;
 b=QRV0KlAXeUWRKJB14gU4+J7KtX81Jegor6l7Ka8baYVABlMuuJaTAtrA1Z5g1N58CK6OpwxxB4c+8JBfJ9WU+dU98GSyGVzz3RIdsibwAoCcOj06iaQ6YSFwAIAzzOBYZahsXga3wHuUBXR024YxunxYBExOO1GXCfw1KQGoq/6nBTFxsk9d3A5LU44MfZ2fvma8h/oWQzE7ppicTSGT7QeAdYzGBf0aMODhuoycrmWUCKAQqBLIKSza6NTd4tvrQMxoMTEw4S+ieqilxMU7ZZiitKjRKf0VKENQvIyU4Gc66hpyHnwYNoz4p8ccRqkMN3IYe+AFZh8JaoSpE9OTVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqwULVS8LtvCG85qZy0IqYiHnK5jNMIbmanCJdWgaNU=;
 b=M0iK1aKsB/JwtNpnMG51RaXyN978CeKSSshL46IRoQi7z09rPPkun1tgfNfh9XeMh1wZBC+HXLQN48GwSI7/7/G6TS+hq7sO5vmBytoES1nMPTwyPk6lOEx6iZ/C2aUIFqvceankKpqXZv4YizIAe1lCKv6sqejs3I5y0Sx/HHs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CO1PR10MB4467.namprd10.prod.outlook.com (2603:10b6:303:90::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 13:30:07 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 13:30:07 +0000
Message-ID: <7917cf01-8390-42da-9110-b0ac64ed01c6@oracle.com>
Date: Sat, 21 Nov 2026 19:00:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0674/2214] drm/amdgpu: require _PR3 for BOCO
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Luigi Lauro <luigi.lauro@gmail.com>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150038.771283640@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150038.771283640@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0206.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 59771906-7d5f-4479-e37a-08df47d38ea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|261009223027099003|261021123027099003|261021121427099003|261026140227099003|261026121527099003|261022075727099003|261022105027099003|261028144727099003|4143699003|56012099006|10067099003|261102123227099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	4Zb0eIIQKj7590b3QJJHlDSwA8aDudybquqsQjIks0HPuWM6cl/iRp8g1QDNmJVmrFqopgpjoiU483Is7IVDWQ2NmqPkHmdfpxwTlekAvWbqnQkjqfH53rReL6qep7LbJVsdEBBKhtGJ1cPMqaa5JBbe+4IBqKxubn0szt/iV8HrPerevg0t6ZACXuuuE8nnSPiByGLG3vh65hxW6KZBs/s4rmQNbCtiDn0nwzS1cp3JodSSI0xfhsMQNl4P5ct6BC1WjQP8vyquW/XaTfpG1GzkHiTPmFjTtSTEGZzENvIgqJ5Ezdl5vLcpurRqhO6MYCfyflUFAjYjCAHVc9afDweOhiowC5p4lDhwxG4shEo7RtSERHZfMq4/+p6INtU9QXoywf9o5Af46XiaocVUFL1yTik5+6U7cVzL8AUjtJrjEoASLITsjNY5PTreY6pVmEXLT/qsm4Zvsg3DSgOJ49/TeniNi6XzOwsl99xjaijTQ1vS+3NQGV8ZEEz/pTLkPz6W2XQqa0L3CSvDBvYXy6QEuqmrlFSG4J9xUZicctptGq7+75KNF62+QS9TZRzSjeX+1/ssl7+Lrd539OTFd0WhDzz2XsUw9YLuONONGA0/odw7Hutlw/oiTi+EqKdN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(261009223027099003)(261021123027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261022075727099003)(261022105027099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102123227099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDhGMFZTUnd5YS93TFZEcHIrY29OdTdWWkVmSkYrbmhmU1BLZVNiRU5GUW80?=
 =?utf-8?B?V1dmWnYzYnFxbFIwMzdWcXB0MUpoNVRXdTExRFVKK1BPMjhyWDRUMFB6dVBs?=
 =?utf-8?B?TmVZalhlM0pIYjNhMnhSTTh4OVlaRXdnUkFsWVI5dXFuVldzZ0tLbnJQbmtI?=
 =?utf-8?B?NWNsUHhnS3JFSTI0TGxWUVlJSHIySG5lSnBYS0NQRVZzZ1B5cU9DaGJ5U0FL?=
 =?utf-8?B?QThUZDB1cXRlbFZPcFNXSHpVNnZFZ3h6MHZEVGVETGN3cXpielVwcENFb2RY?=
 =?utf-8?B?NWRsZklNNmpxdXJEQVFYYld0TWxpaE84N1l3Z2ZadmwvSnBWYURWWjBrWkM5?=
 =?utf-8?B?RndYLzcvekE0YkVkVlFaRWpFYjJheGozRitkamw3c0x5T0kwK0ZHNUVoWE45?=
 =?utf-8?B?a1NsckllQmRGL1M0aDRwYVlUMDNKaGkzakhlNndWK3gzbFBRZlNBZGx4NEw3?=
 =?utf-8?B?UWtMR1BPRnpzdmRaNmZCZzl6VzR1SXVNUTlXdXNpVGVESFdiM0FGTnRoK3RW?=
 =?utf-8?B?akhDQzN6TTVVdlVHNHFjNWwvMjU4Sm1yZk5sSEFZVWo1Z3RDSWwwQVJxVlNZ?=
 =?utf-8?B?SEVWK21kM2FpdUNoSG1hYlUxSGkzUTUzdTA1ME9PUXIzWm1aaXIvRHE0N3VC?=
 =?utf-8?B?YlUwVjcwd3ByTWc0dkk2emxXdDRER1QxbVV1TURpQlAvOGN0UDd3YXpSUk91?=
 =?utf-8?B?ekhaelN5RE9vLzM1VTUzWWczcVRNNnRXbDRla3ovVExhdXcvSlFxWFF0OHFO?=
 =?utf-8?B?b2lzMkE1RUZSYmh6UUZVYWFnVlJmbWRZNDhUQmI3RExERDhTdXlObUZDZThO?=
 =?utf-8?B?L0dxR21uN2FRdVZXR0FwR2tEZWg1clFMTEQyNmpIbStsd3o0U2ZzR3p0a3dL?=
 =?utf-8?B?ajlWY1pSSE55ZDFVdXZLTEx3QWJLZlpKbDhVZTVuYk5rR29iMURKQ1Z1eVVM?=
 =?utf-8?B?bXF2QXNtV2ZCWGhDellJc2x0TG00OUQ2V2NhUDNtaGFTc21mTGV2c21ERW01?=
 =?utf-8?B?VXlCVWVWUEFzSDVKbkVPNmY3bEVvL3AzRXhlUi83YUJMcHN0bS9TNlhGbVBo?=
 =?utf-8?B?dFNZK3ZsMTBhUkJ4aWNPL3pYcmJHZTFmWkJJbUFObTczbUMyYUQ4UDdGMDVE?=
 =?utf-8?B?NkVCV1FtYUoxaXdLYmxLY29hSXAxQXJtd1RvWVFDNUhOWGczVlQvV1dWd2xj?=
 =?utf-8?B?UzBOd1lkajVPQXF0VkFwRjBtRTJUTnBmZHJlS1dhYTJVRjB3N0J5VHYwNU5I?=
 =?utf-8?B?K3Ewdk5rUkRwVlI1bzNFRnRYbnpJOXZRUHlVOVdDV1pJa1lLbnNWa1BET3B0?=
 =?utf-8?B?eGhnZGNSOEtGeW5RbWhqUm5KbDZKK1VkZVI2WFBRVEpHRUoxYUJYVm1yZEEy?=
 =?utf-8?B?eGxyRFc0Z0dCcnQ5cHd3WCtxbnphOFFnSjBuR2FzMk5XVkpQdzhESVJsdlhI?=
 =?utf-8?B?elJyU0RENXpxdDRXd1UvY3VjYVYwa3hsWVBYNFgyNkxCak5qMTZZUHFjS1lB?=
 =?utf-8?B?cmZrS2Rnbjd4SlVKOXVKcWtOQTFVQ0dnRnhicUtob1ZIandpZS93UTRYQjE3?=
 =?utf-8?B?RmRLY0hCT3BWTENDSGVwM3RTZFQxM1Y1bDhsdExEYkhVU0t2RlhlTGFSMTBM?=
 =?utf-8?B?L21SRVl0aGxaWVFSWndGRit2Y0VQZUI5WVNrajJvNHhVV0huSWNxTnlxVUlI?=
 =?utf-8?B?ZlNLQWJSbUxYRGhrM2ZPS1lsRVd6TE4vaFFMY0FkYUQzT3JVcWRsbVBOK3hs?=
 =?utf-8?B?VER1MXR4c0RPYmFWa29CVzVNdUpJSFh3SEF2RnEwajlSNHNiRUxDUVRWbGR2?=
 =?utf-8?B?MUpRZ3FRcmlNZ09SR0VQUmJjRExmWllrcjdDTllpTEVCODQ2cDd0cmxPY2dQ?=
 =?utf-8?B?V1U3TjVpUGRJYTlrWExHRTc1M0ZRUFQ0dk9ON2lvaGJLVEI3cDd6RnRlcUd5?=
 =?utf-8?B?bVI5UkszWjIzWkR6dGxweFh4N3k1cWRWclo5WE5OOTRXNmlvRVRxMEdQY3Ex?=
 =?utf-8?B?bG1lNnQwbzR5VHJ5RGZ1NDVuOWhCQnJIZzhGOTB1MnpMdGZmd3VhdHhQM0sx?=
 =?utf-8?B?YVZ5bHgzK3B5L0R5VGJPNDRIbHpCem9OUXl1SWtnSWRoVnFCdFNNckdidkxP?=
 =?utf-8?B?M3lxakNPR2xuQWNmM2pabzNqZmRLVUI1RG93MGhtUGs4S3EyZlkwc1liaHpi?=
 =?utf-8?B?djRrVmJER3VidHBJRXdNNS9yOHo2RHEzSDB1SC9jbG55OUlUVjdtaFZVSnd5?=
 =?utf-8?B?dHpKd3ZMcWx6cEJEWFVjRnBZZTZzaTFLdTZqWVB5TmdwditDLzd0eGpiU05z?=
 =?utf-8?B?SlBtN3NXYnVZYzVWaVRUUitiNmY4elRDSGwyREM2VEd5WkFmeUY2YWpaN2lS?=
 =?utf-8?Q?ntQ7wR/hNnReoz3Y=3D?=
X-Exchange-RoutingPolicyChecked:
	Al2pIkYMXcrkcrpqnlC+QhQxRz1dOteoIuWgM1JuscFOTccxSDnjXdYKLdqnB1RXDyQSlpUin1y3ePbn/9wElokdNw4635SDEB2Q2MIYMpYJnXpj/whLWWi48V8OlXvikTFpvpzhmN+1PyRLacKUcnfecVqor9Thgw/DdIQgI+E71URglAcfELgep1Qrc21fk/DReImeKCqv37YDfbBTkdnreSntAcWlZoo/bvOTihJ/73LfH8juPqD0t0YH4dbbW0P07zlDU/oRovrDbmlWqYgZL8WUQqiVVS8TBMA+embyvnAJaJ4U5j4G49qSQNlcQG4slwt0pFBAF3ahM4kE9Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z3w8F3xYdGFBcFVXoTGkZcXIyu3ll7ZBEqXLZ7ApgnG4pANhu1vZZ4hipyIu8z9pO90VgL7VgiJdYs9lPwTo+K64b7BgzaAAjxGeVSviAT0mJGYSc9gUWY4//aDOnEmZ1MIxldSDOyKA8zGxTfUXCJy41MuIt5oVGnyH+Pq3y+/oEC8Ngf7lyAJbTfQqgukuPFDF1gF0o7NtX55F+ibCOthigVvKoW/Ar30EK2seMt2LPqdnk6bNyc/YZDBibla2hnTeIxeab7doyx2dOJQ2BKAc2XO0PkjE+VA4YFSbBY46Q5ISFpQngdZZ/m2NW2D5nDopQncd0Qy2k+Z9VjHVGR8c/jMaVwkJIfpkFbzVvV+LQ+qmTtTnR8k4DjkRQZn+aGlJGdj7qR8j3jhrBVgMa1imtCvu7PKZJNsi7PeU7JSZK7V3x710CfbfHIa13fu5kXTKxpr6Ud7QOIml0fEdSt4riWVBJzEdqjncKcBeQkmqqNbrEdV9xMGGk+sihBQd9j3pWZUCaKVGpG7zufxwBjVNz6SOeWMEfkrCU/qOqyWHwKtYD5ldDmX7bjYhArHTeT3O6VmEZudKgjgGmeFWMtSDjin08+FJOa8ywtXVM5s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59771906-7d5f-4479-e37a-08df47d38ea6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 13:30:06.9757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCkvX3SBdlOQ5oiSL+CSdJ7LX3mXHCK5DusiFDgBvj4F24N9O8VOIAZLsR9r021T8YCK7YdETE7BIYbZY6jCyLPmYUhfkre/wC0BAZsEGUt8D6aSTCz6yJiqD9VIFp7R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210053
X-Authority-Analysis: v=2.4 cv=dJIzC+Zb c=1 sm=1 tr=0 ts=6b019ce3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=e5mUnYsNAAAA:8
 a=pGLkceISAAAA:8 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=3xI8cquujar_PK4I0sQA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=Vxmtnl_E_bksehYqCbjh:22
X-Proofpoint-GUID: pVKs39_mJCFBzPBBiCA5-pCSJDe7-m45
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfX1HUk5f0gv/Ah
 DUenxRJyoTXBdnlqz6LK1mBDarVji78rBNRa7HAUvyXpltyujretEzHvzd3t+jsUzBpaCHPMjkm
 bH7bc+6fxo+/tsZ0IH7ZdNyBRshQXPaiu/unL2aemRCi8BwxhKTtywrIAVWgAc9KtUzjy0WcIvr
 842W9aXUjNC8gW9Htrn4g/pfyRStFwvy5Uu61xXKsNeCIf2HSDEgOu+pERX5ITdKZS4/IqmcOst
 i9fYuGJFlu0H0wAimIAdGHRzGIgk8yySFQaaIsNemb2ALaCnatGTznXa7zIIaBpnOZtkm9LfBs+
 3qbOQdG0ODAyr9ART5XaCOlLOJ2WOka+G2xiRjDIpEcCm7FVoKPTGiu3gCR/EqofEV7ViEpR/Bo
 etIED/go99aXWUnqeuKxwblKWnTTogtI55DfoIL8LA9eTbuZDal7pBU/ZYUpZqNDATATCJJbKM9
 IrnQ6YRjWUBxeysiXmw==
X-Proofpoint-ORIG-GUID: pVKs39_mJCFBzPBBiCA5-pCSJDe7-m45
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1MyBTYWx0ZWRfX7JhXlX865TiT
 rveKZ326nknREcwYacd/ycrQOmG0NCep+vkGQv+KuuxmBnNEYwE09wBjIFpwxGZwgKJFHup5BLx
 C2teoLpiIFdH/V+UTwBmmSROHDeIs/W07FBPMjlSdjM391MYdhX9

Hi Greg/Sasha,

On 18/11/26 8:09 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Luigi Lauro <luigi.lauro@gmail.com>
> 
> [ Upstream commit 28f3d169f162ca7e803c5a1f7e1bb55bdc915d1c ]
> 
> amdgpu_device_supports_boco() returns true for an AMD_IS_PX device on a
> system with a hybrid ATPX method even when the device has no ACPI power
> resource (_PR3). On an APU mini PC with a discrete GPU attached over
> OCuLink, the iGPU's ATPX method reports hybrid graphics, the dGPU is
> flagged AMD_IS_PX, and runtime PM in auto mode picks BOCO:
> 
>    amdgpu: ATPX Hybrid Graphics
>    amdgpu 0000:c6:00.0: Using BOCO for runtime pm
> 
> In BOCO mode the driver leaves powering the device off to the PCI core,
> which can only do it through _PR3 on the upstream bridge. No device on
> this dGPU's path has _PR3, so when it runtime suspends the card stays
> powered, with its fans at about 700 rpm.
> 
> Require has_pr3 for BOCO, as the function's description ("dGPU with ACPI
> power resources") says. The same card then picks BACO, which powers it
> down:
> 
>    amdgpu 0000:c6:00.0: Using BACO for runtime pm
> 
> This only changes systems with a hybrid ATPX method and no _PR3 on the
> dGPU's upstream bridge, where BOCO cannot cut the power today. Tested on
> one such system only, an RX 9070 XT (Navi 48) over OCuLink with a Ryzen
> AI 9 HX 470, with the change backported to 7.2.9: the stock module logs
> "Using BOCO", the patched one "Using BACO"; BACO runtime suspend powers
> the card off and it resumes cleanly. Not tested on a hybrid laptop or a
> Thunderbolt eGPU.
> 
> Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5980
> Assisted-by: Claude:claude-opus-5-5
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Luigi Lauro <luigi.lauro@gmail.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 1a039805354a44aab7abb2a6e685212d48b17a5e)
> Cc: stable@vger.kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> index d94d02844c64b..5f9fa4a7caa69 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -255,10 +255,8 @@ bool amdgpu_device_supports_boco(struct drm_device *dev)
>   {
>   	struct amdgpu_device *adev = drm_to_adev(dev);
>   
> -	if (adev->has_pr3 ||
> -	    ((adev->flags & AMD_IS_PX) && amdgpu_is_atpx_hybrid()))
> -		return true;
> -	return false;
> +	/* BOCO needs a platform power resource (_PR3) to cut the power */
> +	return adev->has_pr3;

I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this can disable BOCO on hybrid GPUs whose _PR3
power resource is on the link partner but absent on the root port.

The backport makes has_pr3 mandatory in amdgpu_device_supports_boco(),
but 5.15 still checks the root port when setting that field.

amdgpu_device.c, amdgpu_device_ip_early_init():

5.15:

     if (!(adev->flags & AMD_IS_APU)) {
         parent = pcie_find_root_port(adev->pdev);
         adev->has_pr3 = parent ? pci_pr3_present(parent) : false;
     }

Upstream (1a039805354a) checks the GPU's link partner:

     if (!(adev->flags & AMD_IS_APU)) {
         adev->has_pr3 = adev->link_partner &&
             pci_pr3_present(adev->link_partner);

If _PR3 is present on the link partner but absent on the root port, 5.15
leaves has_pr3 false. Such a GPU previously passed through the
hybrid-ATPX fallback. Removing that fallback now rejects BOCO and can
also disable runtime power management.

Maybe we should take this commit: c21487ce5fa1 ("drm/amdgpu: Adjust _PR3 
detection") before relying on has_pr3.

Thanks,
Harshit
>   }
>   
>   /**

