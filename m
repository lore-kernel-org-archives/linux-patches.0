Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795277238;
	b=EVMpH9IsL1jNBBrCbkb5ddfpdOnV44wSoPtMm99Hom+WdV5Woo/bpA2LP2KfrrO9jny2
	 SORizwQNlxM0a52t8NK/EJjrb9U1l7lIteljZLbzlpvhG8j1Vk2fgf0pB0BBIhkJx/K4f
	 n+pglxgoyEFM5iPFxoCyLnulPHHz66P9k7dMMW26fvHGe02Xej/fvy8Q5Tm67c7p+nJ6S
	 IdabvwdPMZuKQ4rvRzWIhdpYMAPizgvGy1c6NN2h2FeN0IRNS8W4UyDtcWVE1mcrHpmxi
	 iR94ka7fpxWVMAwDEzCNjbJb3RRmjs+H1PJmN5+yL9P996lBdKyyY4dFOCbPdRA5lNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795277238;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID;
	bh=PumUfQr/dkVXQx904OhDKa6Er31j6YLGLv4AnhzIpok=;
	b=1ElQiP0RHFtyFYkk8dVrhYurRuyBGlL4/EldLCgI+SequuVvfeJ5rVtp/5H+Fsao9sLf
	 ChNbGd6elNZWI6mztt4ZJ5azRZl2IdLz9gdUgH+ei+cHBUhmJeRHuczx3e2sxpOwFxh0W
	 padETB1TnFOpM/wKoV51U9XnAHXZtQALBEhLT5i84I0yTxUK3+lgonl6/axC+wURKWzwL
	 3OHFvFfJ22hiDkdlvyglFN2gI3C/3mcyym+YjjsPpkSqXno2d34yn+xbpRW2a+VBvEZ/W
	 ZH3KwFP5o1Fnesy8Uhvz3/Uv/0aWD7b9g/XWSCvlJqd5gS3bDq8oaXMG9bUk+qPzLPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=bTTzCqYg;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=lHgIsQOj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA285606A320
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 16:07:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA285606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=bTTzCqYg;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=lHgIsQOj
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALEhlYd2935184;
	Sat, 21 Nov 2026 16:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PumUfQr/dkVXQx904OhDKa6Er31j6YLGLv4AnhzIpok=; b=
	bTTzCqYgr9WjvKvyRLWm9o06B1ubbH/LfqkRTU1K96vmdOA/o5Fc3yBNkJdCOvp1
	F1tkyT36v6vzxJmlPFnCmVc/jYMVHKX6hcIkl85TK/xgEkXvBRieA47rXWU2rykZ
	HMne96EbsuvM9qciZubrxk+DAPMxR0MTGTelKXem3VNVU1hRxScIaEY/Xfzrd74r
	OwYG888dYpWe8OzS6X6gSxDXgT+Y1kQ/4wDcnRPUlU063sVzFrUyXRb0h7WJgKrB
	BEyp7x3Mx+liKwLG7bDdQHxOItnN7NKgtIDwgjlVLHIwxkbbpUcn63h3pRIc4CKR
	wtwnEk80kbHyx+x+KuysQA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t7g8h8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 16:07:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFXUaf2902445;
	Sat, 21 Nov 2026 16:07:10 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011006.outbound.protection.outlook.com [52.101.57.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j38wf5at2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 16:07:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Od0zlAZkWiQiXzey+cSbZFG2H4jqjHqq9KAt+wS32oxREI3gumoRM3bWPqIvosxRUgvxeIB/ZSAV70pUndaT/QitGN1knuo1gBKA9pqYKe7AGhZw0rVNlLB0rQi8kfLxhvSlFts600VQegTW72gwq+17wtIzhe2Y0WFlIADVCKPZknmg/80DzINxf2/PDvZjc4D862KA7vubux3EeHNUW+RJ7xzVEsVQL/6ir/2n2ySVzYj5as0qHOJbNiqSV05BGgLIFkUW1AxA8y0SUnsjXp7FlcvNcKWXWbo1lYPrh5l59LNAc2mCoezna8lKowxRnABuYoEwXLY6nCX4Iuq2pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PumUfQr/dkVXQx904OhDKa6Er31j6YLGLv4AnhzIpok=;
 b=vFFYNsxOrjqT2iujRNhcUAumFMTqLgWpamXdf6/ah/JG0+nxks3XiRtuWn/zgFH3BzaTHCIRoLVlB6MstUIrALjJBb44/aGAuDZaHvj0O579+5eNSJJhF98+iV7NJKPQhlaisyX+T3fiEzAAlFgyWmmrFnS8+h3ANbDA8Pz7j3S6aFvqMG3YGUG++8/ap5vX1qqfRlUQk5LTpVa+V2W1XOIgEkCAyQgefqIol2SNY/Yfd1Qn/CW0PTJzxOt5IRI4wvvmkff5wZ4c0voIqG9PIhx2w2szPJ6au9Lc49nR9c7lq9qFUX2IITRn9TkUPWNiFKPRAdewuE4+fGkXN15bQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PumUfQr/dkVXQx904OhDKa6Er31j6YLGLv4AnhzIpok=;
 b=lHgIsQOjW1H4hWMugFuVe5/YIx/SfzVQgCZ+jTHeMfCTjee+gNcnZp4iYRujNmJXo6BVDiNN4BHa+w4yBnGWHy6xctgvDbUgQnU0+8+8cbQ/yUNz8dvV4RmBLM07NSJ0BdSDxkrokcB1a57dY8vPBQWMhIhbuK8du4AASCTtu84=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH7PR10MB6580.namprd10.prod.outlook.com (2603:10b6:510:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 16:07:08 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 16:07:08 +0000
Message-ID: <9df186ab-8f92-4d14-a5fc-f5fceec4137b@oracle.com>
Date: Sat, 21 Nov 2026 21:37:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1811/2214] ALSA: core: Fix unintuitive behavior of
 snd_power_ref_and_wait()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, WenTao Liang <vulab@iscas.ac.cn>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150123.928813703@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150123.928813703@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0150.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b9::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH7PR10MB6580:EE_
X-MS-Office365-Filtering-Correlation-Id: e1943351-4794-4914-eaa8-08df47e97e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|5023799004|4143699003|261021123027099003|261102130727099003|261102123227099003|10067099003|261022105027099003|261021121427099003|261026140227099003|56012099006|261026121527099003|261009223027099003|261028144727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IiFUj+E/Csqu7cM0m69yLxphrc+VlE5TOB0LIaIU6A4TyzjJFPQ0mN8bsdkGPS7d99x5R3jTvn5CNpo/KnzKjgyZcRmHe0PJEyk5L3NJi1XFbwHlnJBWzLaME5aNmU7CaNdOJbc7cNMEVCOkS1xWDqwHqC/BMbDRKkSXJxw8DNlaedEbEdD0QNRaaNDK2hOV4ITw2moz9/ThPK5M1FmieAJAZi7/AHLcugVLYSRS4mO8pTs/mne0befdSLHjxXWkmJWu2Bzi9RQorGGlNw/TxLmuoy+EoWlgQ96r1fq/nyFxYpqKS/9HJqyl0NoA+BfM/tTrX6btJqwiyeY2s2hsKplvwQgt6dFaEcEsrid/pCzVt4OK0ML57ato5xRsYrRmwXPxXDfA5E7hIqAKXmjqG5/DuD1Za5aO6NKyzF53rKps1crih0c31d1MNFvFTErLim8cfVJFoY/Zp04PSQcxDlJqU3g2nee3XWnIPb21bJbiu/Hj8ifhPZTiICFyBg0FQDQ1H70Sngr/SEEbkh5oh7FNInrd3FYcwXHJDHtuIs8h0O+s41J9WfbmwxuD/7eh+wbzY9Bo1jkbVKhKrJhMGSri9AcXH3qNZAdHKFB2/h4VzHiDqTG7IW+wjSx+9g9N
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(5023799004)(4143699003)(261021123027099003)(261102130727099003)(261102123227099003)(10067099003)(261022105027099003)(261021121427099003)(261026140227099003)(56012099006)(261026121527099003)(261009223027099003)(261028144727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ujl0dDBRZmFEMnVWeUFCQStwelBjejdDUk5xSUF5aGlxak5LWCtiZzRZemRB?=
 =?utf-8?B?ZGYrYXZyak5nYk8zZjRWQnVRU0VsMUZsSm9GSFZYSlAvY0RmU2Qrc3ExMzRy?=
 =?utf-8?B?T0IyQnhxS29iKzUvVFoxejNrZlArbmg3anQvTzhsSkFWRWFQOXZlTkFja28r?=
 =?utf-8?B?REQ1Y2NJb3BnM0pkSjBaSTlGRmZTRFNVR1ZGcEpURWZWNFhIbHY5NUZ3a2tj?=
 =?utf-8?B?T0JEYXBURGhJeXJoSWJqU2tVdlREQVZSK1d3UmdkZk9nM05YcmVtenR6bjNL?=
 =?utf-8?B?MkNYQTI5aVBFY0kweHNjY3paVUlTTTVzRXp5Y0lMbE9MZlZMVHdhR05ZbEVp?=
 =?utf-8?B?eEdLU1Z6VFN5aEU0dmFNelN1NjdONXdFU0pWUUd5U0pOcjJQZy9Sa0FoNlk1?=
 =?utf-8?B?aURBVHRSVjAwNEt3R3VzUmtkb2w5bCs2dkZDMEpLb1Mvc2tHRmErNFptUFZv?=
 =?utf-8?B?cFJKcWVWbG10TXREMEhsU1JjSTh6UEF4M3N6NmxhZ2Jlb2lmTGlZUzNETXRM?=
 =?utf-8?B?YW9hTW5XZW9MVy9YUzdHZDFrL3JOTndkRmljVzRUSitzOUJ3NjY3ZmYvc3ZG?=
 =?utf-8?B?OE0xcnNKb2V4d0ppMjlVaDBUNWVQMzNHakpkemxUZ1R3TW9EWlJnS1NaOW5l?=
 =?utf-8?B?cDhtbEU1aEZlV3JPOUVMRExwN0g3K29wUUdKamI2N2czaDJHeXpQYmtKYnB4?=
 =?utf-8?B?RUozQkxVdDFzSUExa2N4ak1zWmZMTVA5ME96MjhNK1JNTUV3MzNzVmhLYmtr?=
 =?utf-8?B?SEgzSkZoQkRYS29COUpXMVRiRGlzQU5OS1plSEJqMmEwRVZTa05UMWwxalYw?=
 =?utf-8?B?bUNYYldIczVWRmY5elYwenhaRy8zZ3d3NkVkZWlhZzA0djBDWUhFcjNJZ0I1?=
 =?utf-8?B?UENieGtTUUpWMzViTittZEZjeHBHT2xNMGd0TXpXZFZTbzJjMTBrVGJ2Sk9h?=
 =?utf-8?B?ZW1jTVJNSHhjalhoNFMvZGRtLzB2NFM5WW1hVW9QWS9yR3cydWRnbFp5Skgx?=
 =?utf-8?B?OFpGSXBZTm9obU9sT2FnZ1ZobWxwdnppT3RZUTYyUFJ3c2l2bGV4SFFDenFx?=
 =?utf-8?B?OWpjYk5sYWt5cDJoNmt6OVFtRHdUcmxtYndlUzZKbDlFTXNXa2VJKzg1cWRa?=
 =?utf-8?B?d0lWV1FrYWR3dExVdHB4WkkvMG9iMjJWeGFNNWN1blEzU09QeXMwY1VqOFMw?=
 =?utf-8?B?WWFheWUxYmRaQnAzcUNZYUFZamh3NmlzemxEdm91cW5hMCtuRm5LVUxIQTVu?=
 =?utf-8?B?cTJxVHNFTENCY1Q0WlE2TnJ3cDBwcWhualhzc2tZbE5qU0RHVGk0OEFyaHhh?=
 =?utf-8?B?djFMSXc3MTdydDZvN0dmRFgwWlBncVc2NGs4UTQyV2JHSFQ1MjQ1ckNZWUlQ?=
 =?utf-8?B?S0E0eWtVcENCSk9WYmcwc1FSS2gvaWFLcnQyV1dWcThGNUxYaXhZWTJDUTNK?=
 =?utf-8?B?clQ1Y1pzNFpNR3N3b0ZkTkNXdDdiQ0hUODl4eEhDa21QMGhNN2dzT2pIRmNW?=
 =?utf-8?B?c2lobjdaN0FyblhocjBsOFBmMjgrZWdyYUNBK2ZBN01JSEI4QVdMcHE4c1U2?=
 =?utf-8?B?MjZISDJHa3oyV2tFMjhVWWVIMnpwSWgwNTh3QzU5cktxdW12UzFUQnQvUnFE?=
 =?utf-8?B?YWJzOFBHZ2RjUC9TSFp4VmV1MVJoT3d3VXJHVHdSUnpOVHVMUXJxMGRLbW4z?=
 =?utf-8?B?QkM1Y2ZENitJRi9aMm9FalBWSXlhUHdJMXRtcjZmZFZFWFlBWjVXeTRWT1J3?=
 =?utf-8?B?aUd4OVI2S3U3cXRyVXhOenRuN0s3QXhKUGc2bmFjN2RNRklhRFp2bU1weHht?=
 =?utf-8?B?aDZVdGtMN1VwZXozNlNERHR4UXRhMHV4M0w0ejVLMmZUWG1hWHpnVi9FcXFE?=
 =?utf-8?B?QjBuS05IeHFFbER4c0NsZ3d5aHJqMGJaRFR2SWZsQkcwQTJ0NjB3dzF1WGJh?=
 =?utf-8?B?K1crTHFuZVNLQnRMaVZPNWYyRm1tMGN6VVFzN3FhWktiLyswcU00a0FSY0t3?=
 =?utf-8?B?S0hOVjRyMmpPSVNrVWxObDZFQ21JR2VDQWh5NHgvQmZVajRWaUg1UkJ5SVJm?=
 =?utf-8?B?RmpEYlpMTzY4UGIwQ0lybFAyN2F1WUNZbFlPQm1jN2tuRHpMdjZRVkJJbUs2?=
 =?utf-8?B?QVNTR0gweWdoOGorSzdpNXJGc0p6QlluTHlzaVBmdjRhK2xrNEc3ZGt1MktQ?=
 =?utf-8?B?S3gzc1VMQVpJcHI2K0JhTTJhZFVKQWsyUFp2QmM2VUxoTzVqYWhNY1RVZDFI?=
 =?utf-8?B?QzJWajIrRjB5MkNrQXQxeFRFakF6SUsxK1RoQnB1VlpCNGxhM2xUajZWOW9S?=
 =?utf-8?B?ejBsUEk4ZEptdjB2cW9qZVRnWDNMdW4zWDc0MEtHb0FqR3VoT1dvRFdtRVhL?=
 =?utf-8?Q?pfhyst1Yv2Iv54gjLkYijyOCg9Dr+kKN76t4W?=
X-Exchange-RoutingPolicyChecked:
	oJHXrVyGFgF7PoWPuJFowcx/CLaTJiPWAfGtmg8KjKjjjfkc/72/DuWdJ1voQNo2bXNOahAthjXCDmJqwyzmn+Bu0pylEr893r6kLOyJ0KMNtV1NIUifErvNSR2Fpm/DtcItQhETtO+tDmJ6kZa+IyGkq0wZeywFyTpD+WsKvObJHyU4Bpg/2blqwF4KL+fOvuRML+uLPbCtCXfnEavFa/56hz/V2vOZ1e+nRqvUPDuha6UoAQkNJVKFQSp+47Rp9zOScc22OPmmf6R71u7VpmFi6vuOsn4wI+w9Bb2VtOSuBRR6zU3RVBahi8UCwz6xp0nA5px/awnrFbNdRjKZYg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+eE0gKWUBe5my/Ot6bCCDXzYE9mQSiOIEsrwEXnCqg4Flx3dB2ii9Ied2SWlbfqPJKQCLIBb+j7hyQRMQBu6+2EJPCaYzXB3nAbOlcAGL8nDH8D+l9VeBpIUbgDy0JF0bfhIWs+XwXWhMSL/7PvlcZJvFyhK8gtgKtNLXh/bExFlwtv8IRJFqMe7GkGgdaxTH+6iGSV9jslmTKPoPDcH7tL64ZSCi5Zx4ZqIBpKQdEELTmEZrLkVzQ8aMpsjZ9nSS/o+6+Fvj5b+92S3jRSlqApWLZN3WGMT6NslE7sOowfC2oRAS782ImubGkT+R2JIDMK4ulIK8pH6i5TIlekZqpFBb67UjhVf1mYXjidEzD3VGDmMAZ8wbkUb0VhYVeaxAes+oRQ/+GVx8e9nFjjD1uV90fX1TdXAEOcvzqLNN2lFecIkPIxCyAuTPIBiEB0UVjC8Ea+0L6RpHTU1rgiXlqtR57JC6RETyeP/5yjmKlvufnxaugOflqedulxGJX9n6sieIXZeGCHAvL7kjIB8GSF7uX83ptEyksG3snkHCv6rqWY2vpNmIAQhUkDCOhjXQl6N2oN/lXna+YjTH8/jwy9NOLWYma2SjGivpE4ScVs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1943351-4794-4914-eaa8-08df47e97e22
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 16:07:08.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euqjBAXk9KB6W3qKOFd6G7iN1Urr0Z+khF6zkfpPR9OiUe8PDlauvSPmUsv5yJI0sRfwKTcmj4qBt1SGRvDdTOjpwOELdRLtiIGrh1eLU7Sw2B4iufJqZwbW5R9+0pLU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210063
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA2NCBTYWx0ZWRfX9JLqFNSbmABG
 Gb/CDyAvjGWYGfS8jzdVFt4DJzjWYekouyhPDSmbletFIUpqioB/RmlJF1b34GXWywTsSSwQSE6
 C0pECfmWueUX4okefDJ62TtUlzZhw1WT5ftGdxiEJwnPxikcwD19
X-Proofpoint-ORIG-GUID: 0pwZdZu5Z_qs5UMZ34L3bXGdmrQWRY6-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA2NCBTYWx0ZWRfX7XJAKTcp3+oJ
 VOlQirgRsneKDZcD7SxeZBVt6/MFX5qsRDhFA5NORD3QBXN9Ha5lMK323wNswWtizzSSy41xNx3
 EX3kbild8716mEDUlbRQ/nkU5yTxJ/FujBVWpoP4hXJ1UtR7TNoK5BpjnehIBW54AC0GXh7h+A1
 sxHllaAzRTFwGTkjFm6oUocP+PB55iuPlVILdq3/0F8OW/wuyIEYQACSy/wfBdjkQPugfTKu4kh
 CL5LSXwmxTI/G9i7tKrfXeyTxhCL2sKBENNlp6NJGqlcgNq1P+X9DH/jhCrgOg/DkAO0q0FSJlq
 MR0XBRqlp6LK3GXbb4gDiNd3RaVQlKuF14uwOnmx7blhGUkQUiZyjjF4IBjIYEakL68RJBjOnBG
 Xi4wccvS2TihnhzE+hUvB4mU8HUTU87nip5lIGm+coWQ2nv4TLFKsfoYoUvyxKkBAh/2QsdUayl
 b783bnFytEnHyybQOOTSWceztrzKAjhRJWAN+JLU=
X-Authority-Analysis: v=2.4 cv=Cocq4X4D c=1 sm=1 tr=0 ts=6b01c1af b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=bC-a23v3AAAA:8 a=Q8nEdJANQLrPJ0FpOxsA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12101
X-Proofpoint-GUID: 0pwZdZu5Z_qs5UMZ34L3bXGdmrQWRY6-

Hi Greg/Sasha,

On 18/11/26 8:28 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Takashi Iwai <tiwai@suse.de>
> 
> [ Upstream commit b113a891252c3fa4fab11ec8c2894a22ecaf278c ]
> 
> snd_power_ref_and_wait() takes the power refcount and doesn't leave it
> no matter whether it returns an error or not.  However, the majority
> of callers don't expect but just returns without unreferencing in the
> caller side upon errors.
> 
> For addressing the potential refcount unbalance, rather correct the
> behavior of snd_power_ref_wait() to unreference upon returning an
> error.
> 
> Note that the problem above is likely negligible; the function returns
> an error only when the sound card is being shutdown, hence it doesn't
> matter about the power refcount any longer at such a state.
> 
> Fixes: e94fdbd7b25d ("ALSA: control: Track in-flight control read/write/tlv accesses")
> Reported-by: WenTao Liang <vulab@iscas.ac.cn>
> Closes: https://lore.kernel.org/20260612022121.14329-1-vulab@iscas.ac.cn
> Link: https://patch.msgid.link/20260614090507.772540-1-tiwai@suse.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Stable-dep-of: a69138357354 ("ALSA: core: Add missing barriers for power_ref vs card->shutdown")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   sound/core/init.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/core/init.c b/sound/core/init.c
> index 29d7a9082352d..b3c70ffa295bf 100644
> --- a/sound/core/init.c
> +++ b/sound/core/init.c
> @@ -1138,7 +1138,7 @@ EXPORT_SYMBOL(snd_card_file_remove);
>    * typically around calling control ops.
>    *
>    * The caller needs to pull down the refcount via snd_power_unref() later
> - * no matter whether the error is returned from this function or not.
> + * when this function returns 0.
>    *
>    * Return: Zero if successful, or a negative error code.
>    */
> @@ -1151,7 +1151,11 @@ int snd_power_ref_and_wait(struct snd_card *card)
>   		       card->shutdown ||
>   		       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
>   		       snd_power_unref(card), snd_power_ref(card));
> -	return card->shutdown ? -ENODEV : 0;
> +	if (card->shutdown) {
> +		snd_power_unref(card);
> +		return  -ENODEV;
> +	}
> +	return 0;


Hi Greg/Sasha,

I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, e28afa34b037 makes snd_power_ref_and_wait() drop
power_ref on shutdown failure, while control callers still drop it
again. The error path decrements the reference twice.

In sound/core/init.c, snd_power_ref_and_wait() now drops it before
returning -ENODEV: (Code spacing adjusted.)

     if (card->shutdown) {
         snd_power_unref(card);
         return  -ENODEV;
     }

But snd_ctl_elem_read() in sound/core/control.c still drops it after
either result:

     ret = snd_power_ref_and_wait(card);
     if (!ret)
         ret = kctl->get(kctl, control);
     snd_power_unref(card);
     if (ret < 0)
         goto unlock;

Upstream (b113a891252c) returns on failure first, in
snd_ctl_elem_read_user():

     result = snd_power_ref_and_wait(card);
     if (result)
         return result;
     result = snd_ctl_elem_read(card, control);
     snd_power_unref(card);
     if (result < 0)
         return result;

A control operation waiting outside D0 when shutdown occurs takes this
error path. The double decrement can make teardown wait forever or
finish its wait too early.

Let us drop this ?

Thanks,
Harshit


>   }
>   EXPORT_SYMBOL_GPL(snd_power_ref_and_wait);
>   
> @@ -1168,7 +1172,8 @@ int snd_power_wait(struct snd_card *card)
>   	int ret;
>   
>   	ret = snd_power_ref_and_wait(card);
> -	snd_power_unref(card);
> +	if (!ret)
> +		snd_power_unref(card);
>   	return ret;
>   }
>   EXPORT_SYMBOL(snd_power_wait);

