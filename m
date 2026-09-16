Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE424DA9C9
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 20:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591168; cv=fail; b=uMplLiaETwfT7LtD4PMl2tVITETDpERulUdhPY1Igjqw+fpZQ3IKpcxZBRRtyLS57XtgIBrSILR+Ca/iM/WohiX6Cc/Tjzr1USuysZpFgMOQ+KabrMNzJWvWlT2QlzVsST2IEPIotlPjGsncWBulTI6hG87dVJnvkurm5ZHAi8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591168; c=relaxed/simple;
	bh=VlR6GUaeKokrmhf6a1LJRwjmUoKI6qwpFVL9t4fkkI4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dJRcWx+T5a5u7rnocAsylX/rCd+lMh3eNTlaUXNrrt6hIzl0LCL24DXEtsDtlqPlA4MTOL/QN61K9jo3Ba7Q5O3KVhpMxMuANa3aWBT+93wkrVwcfKTY/owmP22liNJ95CCyD4uvRqCOUGKDIP7NfaqybCYSwu8463evpLM5tos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U+ryx1tM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EZYPYwuA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U+ryx1tM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EZYPYwuA"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEBsdK568321;
	Wed, 16 Sep 2026 20:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ibNAwYP9ybSOTbBdo3iS9xL6A3SZCtU2yq2prvSt3bE=; b=
	U+ryx1tMr7O+8/2cKNEvDaXz9YVfk3vgNWhvW0LLslTp28SEvySvtUt1O7La48k1
	AmfftvtzY+o3sa9fk3oH51QKEZDcC68Q3Yo23RbEAR67DRmO8XUPuG+zZ+c5p/ht
	2xGXeeti+2QA/5v7PvKVup5HIRQaLS1zMt/+w9Y8+G1pahTFk0UIqIdOkAI0Ux+o
	2TqBrOxyYVbXkGbwqQYpiyrwhNsGsTTDt/PzDF2PVSGtdiXszUBX2HS2EPeQRR7j
	8rlyTHz4UfVyvuR7j4Gq7k7rssZE+KL6syGh6mZABOCh2hsCEk8AxMN8F/kITk2c
	8Ga5KMUtrl0qVGrjAKPqeQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gqqvq968y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 20:38:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GKZQKK039652;
	Wed, 16 Sep 2026 20:38:55 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6r8juk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 20:38:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dZywz51tydysupOuu17jJkY0jEO+3uTH/2LZdQEFi7GIrdVUJheTwbT7mLtlHkFuR5qqnVImeILG+uwvh0NMe/dXeCyoIT77Z70hSW/AMyrKZY6n11svBRLpDa1qIv6LySCu3jDgM+ehtpEwZ9/dL5d2WkxQF36RKq8LqEftYNYW9alDvUUWm2EQLTwL//KNWNKkckayWabXw/6O57I/oOsCFgpnWkz3YwZ78lBHxAt72j6Yg3kS5mnzAf3zlJk+s5OLCva2snd0NP5/yLzgO9Lgi+LWYHT9r9XZ/IPc5SDBdiOI9LG1QlllWSfoi/kLBBKP9+VewZtwl/7hCDKynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibNAwYP9ybSOTbBdo3iS9xL6A3SZCtU2yq2prvSt3bE=;
 b=wduobgbJd+B7/WqGbTQXFhfTxpImE/cIF4ipXKBfMJ3ahn3GcodFdA5dLP6B8jS+2irUVq/w50ew6+Bc7NTfyK2wISBb1urbDsQkLXhJ/JP3IWo/AKjVAB6xfltxN3+0xz1/j5Wx4JgdHev0WwA++5uvyWej8CUSVV2oR0YeWXCT3gfpnkOn0z3hKnRGDvvYrAG8l/58wA0EDsNKWqPt4OkN9iwIyLcTy4RxDdABr8B5uGhJnmzmaLfJ3rimygTB7WrCeC4hHDj0AlgmAsUmryMZ9eapkwi6qo0hvn/63L/esAKP2bJnij6/2OarE6+Kwz3XvOIr1e8bdhkrN+JYtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibNAwYP9ybSOTbBdo3iS9xL6A3SZCtU2yq2prvSt3bE=;
 b=EZYPYwuA4kslxOfaXn5juWYrgnnF/4cuHnZV36b9006GLhqmztpEp0luuqNoFWazeHLvQ4sHilmymzwKo10vAlEp63XRNNrUMtWuNcnslSgC2N/ry0ljs88r1D4DscqKA4RnyXGLItVTU70Dkzi5rJsj+p0zk7Oo8h3zkfLBmCw=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA1PR10MB964822.namprd10.prod.outlook.com (2603:10b6:208:5ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 20:38:51 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 20:38:46 +0000
Message-ID: <daf8a1e4-2df8-4093-b035-b1885063017c@oracle.com>
Date: Thu, 17 Sep 2026 02:08:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0191/1376] media: em28xx: fix use-after-free of
 dev_next->devlist on disconnect
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com,
        "Jiangong.Han" <jiangong.han@windriver.com>,
        Hans Verkuil <hverkuil+cisco@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <58d2f55d-4194-4e47-98fd-f61d4f4a66b0@oracle.com>
 <daily-reply-20260916-0025-re-em28xx-devlist-revert@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <daily-reply-20260916-0025-re-em28xx-devlist-revert@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0388.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::17) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA1PR10MB964822:EE_
X-MS-Office365-Filtering-Correlation-Id: c8a576a5-e5da-4dd3-2c19-08df14328103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	h3uyzG4hmAKHYSiN2fX7QPdvMdJj0C3QdNDwWQ6GUfkM4qk2uODGWugtqGYn4BU2oTLRgxAX862ZdS5/QACWkoQnsRs9SmPd/Bbx8OzCHD7R5hxaq18ccVx1aKle96RPWJ0mFl0lJ89yD2YFa6nCdHnulKLB0a/VJn9Q/U7r8FKNc8CTaRyJoupCCg2URb0s+XhFrdssRoBnCiUk+MiZwgc3JS4y8beKc5qo/4JpwFAylUujzWePGlsNQZUhVs8RgWc+uBJ02CIMPBoy8IQ/qpjPKBc7BPcedCWgnws96aDtOJ98Bt/E5Oe1MNYarpOtdV1j4jOJeZteuYTNiRSWeQCgtzkQR6crJjUOIgHet3ONL0iorS2J5IHJKARL+wjzTJMBaPQ0fbIXki/T9yUM9MqLXeriG6I3X/hLq6OgEDusXiN00B1cHBOfMefk8NywUst8TVACN+gfeKCAuYQh/JR2QGObkeyG5ZiRuzzJ8Cil40F3LaaIamnHlzUY6kaBSFgGWMyxmuTPxyTqt39941liFT7GvmzmvoQGVUKVVA5/uGs11gDtnclt5IogWmteR7uEPW73VJdjKz+l/CrgYhY3p9Ju3uYmLVqYPOfS0MC9J99dd8EcjNFZoXTt9f/9FC/xWUmFeJ4qcMDdjbq4nxbeyBGBkLlnflWegF8fzww=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXl0a0hvL2p6NkxxcDR1UWpWa1d0QXJqY0MyQ29LSVdKN0JQRHgyTEptaTBi?=
 =?utf-8?B?dzhUZWlGMjhXNzltL3I5U1RrdG8zQ3NLYU1tZmdsSUhNUkxVMmd0aGJQYVg4?=
 =?utf-8?B?QTRBYUNvZ1JLRE9uMDRHUWVUbFY5NHpDd2tLNGdDcXNHdlk2R2ZaK0g2eURy?=
 =?utf-8?B?S3ZmQVZ5blBoeHlYcGp3eFNPUXN0SS9Ha2FWUmUzdmdJUjNBNVhJSjdOMmFt?=
 =?utf-8?B?VFFJWmI2d0pkekR3U0VtQk1Cdk1oT3R4Z0lhcWdqMGdTY0lwYktLMnlEL2JR?=
 =?utf-8?B?QS82VDJOaExXbG1VR3phL0YrazR6aVZGMFNzVllGd3lQRERsK1JsVGRLdE9k?=
 =?utf-8?B?QWZMUURMZERPWTZSYVdSNG9BY1VxQlNPVHg5clMrVUJlUmh4RU8zTldIQWRH?=
 =?utf-8?B?N1gwWkJHelBuci80OVByVVNtcjFVUFVCOUJlZGZFZG5KbmJYSDJZVGc2dlBz?=
 =?utf-8?B?U3orVkZPbjZzRWVVZ2NlSGZWNFpoWnJsK2p6OTBCc2owVW5lYmp3ME8rZmNM?=
 =?utf-8?B?Ylh1RTVKWFpVKzZjYVErZm1oK2F3Vmx3SVZGNE9Yd3hvWS9LYm9lVHhscEkv?=
 =?utf-8?B?T3BQWGcvMElrUkFmUEU3NEIwQkxLU3A0LzNPakYwdEZObzVHSXgrNzJ5QVJk?=
 =?utf-8?B?ZzFMY0RaMGdoL1VTblZGM1pjZ2RNTVBKVFdJcEhJbUlZeFkrOUs0Q1l5UUNG?=
 =?utf-8?B?U0xpakYyUzhYeWZKamo0M3VWeVJUaFNZNnJPMEdDcDJEamNXTlhqSm1LbFh3?=
 =?utf-8?B?OENDZUg2cCs5aG1HbngxN01GQjlkRFZJVWtzbndyTFZ1M01LUGg5cFRGVWRl?=
 =?utf-8?B?S0pqYWNvUXNtRkVLcmlQTDU2eFRqdmVTSHNLV1laell5MCtkQ3JnalYxN0VU?=
 =?utf-8?B?VmN6bnduYThJZTZHVEZWZHoxT0dQVHRBYktQWkQ2Z0pibHE0dVF5L0UzRlFF?=
 =?utf-8?B?dThWWStWRXBUVDdYMmhMV0xKVEFDdTF1eVRjNGZzT1Y3RlY1c2x6S0k2Z0I2?=
 =?utf-8?B?REFjbVI0UGlPbnRJb1lhc3krUWV3RCswdVJ0WVg0blBWS3ZJYXhKajNxSkRq?=
 =?utf-8?B?RVh2QzlsbzVabW9aUE9KYlVWNnU3T1N5c0VFZnBzaG5lVzRObEtpWnRUV2R0?=
 =?utf-8?B?T245UHhKMGlUYVJMSEI1R0tDYVUzZkdZcFl6TzNhZDIwV0pVcFBiODdOeXZF?=
 =?utf-8?B?N2ZoQVFFTlZ5NXBjcS9wdmU4aTlqdWlyR2Q0SENtY1g1M1VSYXAwTWZPanM4?=
 =?utf-8?B?V09lNTJ2bnNPZElScjBPaFhLc0xWRzFkUmhJdXYyb2NQUVcxOXlHYVZnM3hq?=
 =?utf-8?B?K0FuZmxNVkdKNWxSMU1rY2tZUDRpcHdnOG12VDY0aXVHUFVDQ0crTEdrakpC?=
 =?utf-8?B?MHFkN3dmdGErODdaT0l4c3U3NHRiRjJtdXY4L2pBY0ZQdVQwSGpRYTJReFFE?=
 =?utf-8?B?NTlkMVhDNXlkaUJJaVJiSy9Oblcxd2FQRmZONitOMWlBZ1AvK1gyS1N6Tmhq?=
 =?utf-8?B?bFJyL29vZVZsUmdKVUZtTUN6V3RKR1VmcDBZd1VUbFBPdkJWODdsOUpuRkZ2?=
 =?utf-8?B?YnExS1ZWRWZNOCt1U05xY0JPTWdTaEM5MGhnMmxDdnh2dWxkRHMwK3ovTTNI?=
 =?utf-8?B?NzUrMXFBK3J2WVQ4VkUzSEZaUVU1YTlXRTF6aWFyeTJScmFIVWVrZlNoZ0Nq?=
 =?utf-8?B?YVlSVjZ6cmIzUWR5Y0J6QzgrV1c3VkZka1hhMWVJaGZhaDkwKzN4WFZZWDdj?=
 =?utf-8?B?Q25rK2JuOEZsdURkSzk2VzlLSnFhVE1KUmZWZlQ3Rm84TmRjYi92L2RtZHpu?=
 =?utf-8?B?RzBQS0VmRThBRHJHRVV4bXplMko2NkIzNGVwVTJ4N05iTS95UGFiK1JUOXVQ?=
 =?utf-8?B?NVV6a09SMFNLVHlkM283LzBkQXg1anc3NDFXcE5iUkpsWkdsTjFkWUk1bTdG?=
 =?utf-8?B?Y2UwTFRpajlUZmpuY2FJVVFQVnkxL1dKTnByOTFWdHZZbHRxSDZtWHR4UVFT?=
 =?utf-8?B?OWIzdkt0M1pMVUdlUGxMaVRlajV6bGlSMGIzenhiY0dBUmtPMTk1TThKVGI3?=
 =?utf-8?B?MDJmQStsc3RaaEtOdjV1MmVqenVBZ1k0bmNuQmw5Qk1Md2VIY2l6aFEyQXJI?=
 =?utf-8?B?Tkp4SXRJd0xuWW0rbWFSVHpUUHJNU0pzT0tMMzhZdWw4VFRTb1hrb21INk43?=
 =?utf-8?B?dVI5d09aOGZtMEdDT3l4UnFmMVdIdFNpck81SEpnemU2WFBTVC8vcGpPeFNs?=
 =?utf-8?B?U002b2d6UTBNSS9MUmU0SlA1Z0pmbXpzSURCSUNWRE9aY3I3dmpjeSs5OUVp?=
 =?utf-8?B?SGVqNmdRcTUyZ2J2bVVSOGUrQ09CajJCVDYxbjhhb0J4Z3Y1b0kwbThkWmZG?=
 =?utf-8?Q?wP36P+3PFKt0EIz/kRj4YXedKLhu7yII+Mi9M?=
X-Exchange-RoutingPolicyChecked:
	uWh/4QycbDMfXQ/PGpMPqKDnOgt/f25pCbvYIwuxO3AnHxuVKAUqp58tp5Chb+Bjh/+yv67tt52UPuvxgdNRlWeTYt4EJrWprc0WJqqrP+BLXvptt+2SU10lJjYdzw2DhaG59NE4DiziKbAAp4FktH8Csn/vHPQnCcnpFKylRbKKBHeZkM3fg/nlclgyO27qP1brJu9SShpSfA0WnjzEDTxYBBciQgF0FWKxFL4ReWALrlVx/vHZze+lIzuijPOEU1HyDipip636WFuAzNDk6uG62YlI2RcUR59FaAYyjGEIH6V61e2A9DfnxBt3EJzE4Jv+wQTi04vW4C8XHyDdRQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	85XHkjWzDwnyk/30V0C7tdVlfUkvM1KI/7j2n9zR7Epdtv3Bd8nQrIEtDq7Rd2LHEHBRn7M3S+rXC/HzWgqAmYgMZ/1o+TatPHqma3BceLgRN8V87tJwGmemSy4Hydma2kX8NnGPtveZniNOHgzm87y6YXTUYIhky2+/saqDvBpjA581fNWEy6ZKN4/F46ZD4KBZ22xyT+W0qhsQEdVMOGj2RnYoUGVdZPb5KETWBTUZ6djk2twmtd6S8UpCAGM9LaYT75Tzpw7IR0FaYbj0gMMmBWPob+81A5rL4SSM28hKkAnv2A7ZWL8313XWYqDU7eb7qqpEZM35n8VXuQ9ZDCwuu7Gl8Cqep7AC8WvXYLzMmR8uoTLahAS+tjykyvRvP9PFH+WaPRGBm0uXdVravH3XxlbHg9ctNd7MMVJthzctzKbLK1GNnOw+yYT+raGvZbDHQ4+ZEz/ND54/Dc4IIFPrCSKBBOuZdfLmOLq30S1sqnNMe+JBrAfR5W1M5/99FJgLVGW/8OSZU7biggzLH3gCdIdx3G6xXb5S6+Ctn+1dpxe9H/RUBb3WozjXfxPtRdtoUexH6YtvqL5mh7ZLU4BwUqv878q/gtdm1Wm5/v0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a576a5-e5da-4dd3-2c19-08df14328103
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 20:38:45.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uIfE5rHd3Tc5lP7sbGfOpAKjhFFx5aoKRSPuDancX9uxrKT3Svy7sE3+6rCNCa5jt4M0U8BtuEDCT03FZVVtsi1kbQbzMaoBw9GyVSTLXkXaG6KQ0Ya+jL5Gdk+/2vbh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB964822
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxlogscore=898 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160286
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX0TrxGRso/lu5
 7b2bwCOwQu9m/QQUnscfEm07s3qkco5edISE/InB39r956iPnLhuAzuDk7stPfu+yudLJ01034X
 sO1JqemwamUI5dGEwm2y8cvtOW/GXXNvdSaChlU9UTJli1VAM9Li
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX9+NGyHroXo1U
 WDL/bR/p024qA+bbqV9GTrVjmdiWSZUVB/2qu/GzOMkHqmjUm1CH2u4meb2UZaNDix+SNHfqf5T
 zfSFUdVr1Z+5cx7gv17xWGLMF57qhF3f+mP95Y5Ja7lKOIOnPqyl1phbosbSpNij6GgcF6VCLQF
 BCfjMcBIj+xXnFBsG750mvNqvh5a8ka4Ri4C4uFyBGZ9X2PiaUfMJTgmqdnODEF611duWxH2upZ
 smZ9uWP3hTvh1x83F/8ZWFV6tnS/Qp8NEgPRNJ7lbJNqcZRINioOCdvHDb7AFmMEoLkC2lwvjL4
 mYoamOcg4ONHbJDsfUEX0mML1T6Bh2u/c8psSpzZ5D5xn8iJGW5FBJ5yE8Jege8QqOTQWyP/fTU
 gJLAbff5Z4RfuuYRxcE66RiXUJBkfS144LXQ4s2Occ7/E8bJAYliNKFx4SVsXQTHjYeHywq/UWo
 ITr5Q8kqRL8Zk1r7679IrY7vk05zAPu0B42Cz8lE=
X-Authority-Analysis: v=2.4 cv=MpXHeGae c=1 sm=1 tr=0 ts=6aaafe60 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=_qEDd0p6547uDbXRTkQA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12106
X-Proofpoint-GUID: 2CDmstUU-6FECkjA4FeUos0PLL-okrsM
X-Proofpoint-ORIG-GUID: 2CDmstUU-6FECkjA4FeUos0PLL-okrsM

Hi Sasha,

On 17/09/26 12:58 am, Sasha Levin wrote:
>> The new unconditional list_del(&dev->dev_next->devlist) can consequently
>> operate on zero next and prev pointers during disconnect, causing a NULL
>> deref ?
>>
>> Let us revert this ?
> 
> The analysis holds, but mainline has the same defect, so a stable only revert
> would diverge from it and regress anyone moving to 7.3.
> 

Agreed.

> 826915b6b65e ("media: em28xx: fix use-after-free of dev_next->devlist on
> disconnect") wants an upstream revert with Cc: stable on it, and then it
> reaches all seven trees the usual way. Hans, Jiangong, could one of you take
> that through linux-media?

Should I send the revert ?

thanks,
Harshit>

