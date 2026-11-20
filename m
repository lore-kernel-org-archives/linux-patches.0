Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162735;
	b=CrO7gIv2jgQZwjYXXR31ohyOOyjO/7P8dng11zP3CmFQ2+NqaPt8iO54NKmdNFKNzxVv
	 VvCVSvYeXEH/mlY0hGW3QDtSnrg1LTA6nFe9V+WuAPYdVI9YMcXXh7lfhITZXVUzR+V/n
	 gP7wVCggHjQ2fBBTWqNF6IFh/k3GAsW7Yir59e8ISOITXJq8U9TswXDUbVWZHuRtWWj5A
	 FmhJCJdIor5QACCospB/TJxPYYN24TQnZCOmko3B9nTD/ja04zZwfsCxB0n2ZVodMYFsu
	 LJzLI21egM9k4rXOzyKb7NE4tyHqReHk0f0Ik2i2mSYWRQJ1fhrt9AehD+OXJmrkwew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162735;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis;
	bh=+cYdB3y2Z3Iu3wWSk+uCZum3wG79bOr9FjMLVV4+HVY=;
	b=0Ul8p0LhZI86+VEXO4/2znb0kSWVo7VOww+ZwG3OJ1wlllR+2tWViL7PzE2rpUg/5yUJ
	 ccGmQ8eQ4oC7MF1d3GtnYlBu74WWP0DqB3hUhXgZSOeBauaebpDX0U/efYG1gMAbnQJK7
	 K8uB5x7NTLGESksffc5WnEB1JaBEnf0B/O80dW2um6Oq7KVSkvNbMTVilp8hewjJB7fKO
	 M52te+fpywnUfjdLhqkCXc58f1c2bNPFrghH++KTm0SKz94ww3Q3Fo9MKXm8IdJvxZmht
	 sXcH0M6D9x15ZFBr0n8psWlRzclgCtMqA/9T5shikkk+T0vr1zm4Kj3vPE3Px0geJxg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=NK7RuTDy;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=UVnHYQQI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2504D606A32A
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 08:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2504D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=NK7RuTDy;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=UVnHYQQI
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3emFm1659080;
	Fri, 20 Nov 2026 08:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+cYdB3y2Z3Iu3wWSk+uCZum3wG79bOr9FjMLVV4+HVY=; b=
	NK7RuTDyJVB0z+fomtttS703lwY45j07q2RHfLVIXexxYopoCKTevKKxS8irmJeg
	qvA4RO0ZNVtqim+w8FIVZOCfGQ1twQkO1nI9PjiYQOAoOM95Dv14tlGyvXcyemf/
	6Tmpa5JJ9FJNDeU98cU3ztYoDB8K7jmnG0y427uIZ1RwhIaldWOXhBP8aiwawmIN
	ZHKodouPbZOjn5qQi3N17+7aoxrBvQWL8zW0+T3uOPdTYyUfdePbX57hQwjyh6Py
	Gd/r0zoyYVhpextjM6FOqhBycciVXJfctcb/2/u6m4kUcfuIw2ixBDZvK5oYGKqS
	RVXQEXCPtCeEyQMeCllxhg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytq4ag9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 08:18:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK7eDpf3685767;
	Fri, 20 Nov 2026 08:18:45 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010043.outbound.protection.outlook.com [52.101.193.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2gd356e8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 08:18:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q52d5qihdiQDz4mk5kIEB2QUDG45SKvW5hekiJIxlslWInz2NFOHDMpRU/nHYg6g//jNh/FzsEbXNGosJC8gUbeX6GGga9QCcwCT17LJ6XWH6rj/Wx3iL4Vh62TA0gq/xK99ehq11YjiZuP9hW27yO0hu63uTD/3vAvoEPnP/ug/tFahb6RkFk9+tJEYT+dK7ocop0XHQA/kW8pYhkmpNgbz73eXid17a9mEmf86ilx0At/oiASrRPqZwoPmX27feNSZ42mRqGy4ceeKnRyJsBpdAH/8jPhotP9OJ8bNxExDVBXtz7pDb/8KHePbruOUP2I/1n55nGjd7UoY3ko9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cYdB3y2Z3Iu3wWSk+uCZum3wG79bOr9FjMLVV4+HVY=;
 b=dM8IavcZKWkbzq7HP5fAn4jg7Q8C3NYbDvmhiBV1z3jiAqMysYox7pLowHsDk/ezO/5Ta4heytVuCyj0EUc9qik3+UVrwUaa+8VpAqi0lmzgb26mFbPx6fayyDnx+rITEDYSGW3Tmr0BYAHGGbYLeZ90wTiKbR2m7XRTO3jjbxOU48UpdKXbpGZMSx+07wdprHrQ59UVwXBm7/DIJ1TAe3cRbop2OAq4DOUVvgJ5EVPN6BYK0lJWZdM72JzF0uQv45Vh0N/FaWteBU7MLLsmYJzPh7dtDky2HNW97a7xmsxICrxAQlUNdxDqUZ5Fk0PZNc87b5nQXcfCImTg601w0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cYdB3y2Z3Iu3wWSk+uCZum3wG79bOr9FjMLVV4+HVY=;
 b=UVnHYQQIm2DQU1ZbhexvVdBJsTKzahOLgF1iGYiRosWRIp84KxxGNIuyjSMCvs4R/bLDwjAenHGFOQWaAAWSb68LiBBqbJCK4Wem9Vn+DRstGN94ITqFQtZxTh+S1J1vpTYIjKDCIVSU/SXlRpBBXtkkA9P2hH6/w9KQbW7vIZQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS3PR10MB997724.namprd10.prod.outlook.com (2603:10b6:8:346::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 08:18:43 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 08:18:43 +0000
Message-ID: <550600da-5349-4cfb-8706-3513923c19af@oracle.com>
Date: Fri, 20 Nov 2026 13:48:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0373/1756] HID: i2c-hid: Unfollow the panel on
 shutdown
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Douglas Anderson <dianders@chromium.org>,
        Justin Yeh <justin.yeh@mediatek.com>, Jiri Kosina <jkosina@suse.com>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150023.330438572@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150023.330438572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS3PR10MB997724:EE_
X-MS-Office365-Filtering-Correlation-Id: 6afb29c9-d740-4582-c336-08df46dee387
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|5023799004|4143699003|261009221227099003|261009223027099003|261021121427099003|261102123227099003|56012099006|261026140227099003|261028144727099003|261022105027099003|261026121527099003|261021123027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Mi4+scGVx5XKD8mnC3As/8GLeNgG8BSHJQ1RY8FJDRxfwHLxhgE0dG96wDXIlphdqstWqUlmStIgHUgOrcNAnEund0AfYQ0HQHxJ4IxAVvET5VTnDrc4YYAZN4gAX6ljIIk43uDTTnxyfcsdYyPdZych1bd4jjMSxWo2s+mcpjhUrIdi5fWRuWoq4roCS3eQoKNOxy9YL6RTRfQvWzWEeKunOBOa18ZfyiQlwV/HYuFVczCECl3CHh8bMZAiQOXBqARaoMcvBdSHm+olXS51uYqc+dsflc40T65eQIdcmzLg1raLc/gWc/dpr22pJjAf6b/OZ9qUCT+ZN05zAX7nFP/9xFy5KWLHygqKK0ViiANPHzSidWDdDGWuWsjRWjrI/XMj3KxrcAbpMQ9hNcIvERP5XutXWY4Ti7ijwYhMWjYj6rHqPcVr1JuEUgwzc3Gt+8TlprzKLRbZja2XTv4h6SDy9T3w1DvyVWg1+RtOoPd20cT2qx0xcIjhu6Fua1vbJJvCcW6EdEU/ls0jvNHwrMD3fFj36qoTvbTDmUe9Fp/K5+N2kFkXW6wXNt/asNnAcusyNa20ru+i04uT7gcRSc/f/pcKDcRxx51wegXIIMvWmfC5k4W0prUcTMqZcLolkjnvpZYV4p/qkS+1pxnP7ptLCg0NzLggPXg/kbWKqNE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(5023799004)(4143699003)(261009221227099003)(261009223027099003)(261021121427099003)(261102123227099003)(56012099006)(261026140227099003)(261028144727099003)(261022105027099003)(261026121527099003)(261021123027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEM3bEM2SnVDOUFNQWhOd25RcVo5NGR2UU5EM2NybW1kaDM0aWFuRkJFb1hs?=
 =?utf-8?B?cHNGbEdOQnRtZlNxRzRLcFNJU0dscmlRWEw5eUZ3RWFld0wvWVJyN0M2QThw?=
 =?utf-8?B?YWRSSzV1c2FDYVhpNjFHL1JRc1g4eFlpODBlam9ZblFkRWdXVlREbi9VYzBs?=
 =?utf-8?B?ekc4QVF0N3FtaG1tdHlEczZ4dmgwWmR3SXhCZHNDTGE5Vmp0TFlZaFNqaUdz?=
 =?utf-8?B?TUZwWDZEME5DVVlBNFZFQmpjTmYyMWZmTTI3aTgxNkFqZ0VOT0MyRUNuV1hS?=
 =?utf-8?B?MUNMUXBHYTZKbEZhM0FKU1hGbFFacXoxdkEzQlNCNHJpbEJzeWN1K2hiRVBL?=
 =?utf-8?B?a3AxZ1ZXZmZNeGwzSldUdzVyNkRwN1ZmdFhNdzZKQnFGRlFZZUZ5UE0rbU1h?=
 =?utf-8?B?RjJpUzVFWlM1QnNiZ01RQy9TamR5WmZTM0ZxempuTXlPVlE1TUgvaTVXQWV1?=
 =?utf-8?B?THdPdWpYdjZRaHQ1OXVsYVowTlRkOWp3b1VXRExOYTV2UG12QTFCaGZ3L2Ew?=
 =?utf-8?B?enVKeHZ4UERuUkROSUt4c3hDelRQQUdXNnoxSGpBQ1p0Z2grR2kyZlpUVFdY?=
 =?utf-8?B?THdJTnMwRnNKMHNvWlYwUnV2U0hDUktmWVpGQWxhVlloeFJNYnVjbGxPOVVl?=
 =?utf-8?B?b0Y0cVhRSlVBcFdCcjdDMkVzNHRxWGxkZE4rQS9PRndjMG10VnFkdFZuVGNP?=
 =?utf-8?B?UE5zK3o4M2o4VjRXUzdqeW82SXlYWFNjc05SQ1lEY0dtOHBqRFVhMXBiSnBD?=
 =?utf-8?B?NGFIb05mWkdCS2Z5am51K3dIN0p6b3ZPWVV1YUZiOU9CcGFFalp0T3dWNEJG?=
 =?utf-8?B?S1FJQ29TcTlZZ2NXcUdTZGdJZ2dnVG5EYlhKbkwxNjNSZWZCUFd0S1FPQ2ZH?=
 =?utf-8?B?SnY5eno4Zjdzc3NjbEhGZkNwMm9FdDVZamtYV2QrS3VSOStiWWxIUk5YNHVz?=
 =?utf-8?B?Nlp2VDdkUFhpcktEK242a2dxaFZXNWRoVWd4SFp2T1VmdnQ1STJsenFQSEtt?=
 =?utf-8?B?ZG5kVEFBcjdNQ3V0a3YyR0p1OVI0ZEY0L0VhWVROQXJXbTRxWnNLK2tMYmQz?=
 =?utf-8?B?ZVF4dzNSSVVhQnZRL3Z5eE13YkNFVG5GR21UTDFUbHlCNE1DbWc4eVhzb2pJ?=
 =?utf-8?B?MkVqNHJwL0F3MnRRd3BJTXY2c0diWGJ0Rkx0dUl5M2cyemw5OW1walQ3eFRi?=
 =?utf-8?B?QXNMMElqYmhSL0hYWjUxQ1BwamZoZ09Nd3JWVlBnSlVhaVEzeVlvMmRMdzA3?=
 =?utf-8?B?a3I3WDBHbmZxTjlIVFBDTFdTQTNQMDB3ODNFT3VIWU1mb0haWU92b0oxSlVk?=
 =?utf-8?B?U0paOTU0amhKd3JMbXhTdGNnVE5XRkRzV2N6NnFXZXR5c1BYV1phaTUxMlZp?=
 =?utf-8?B?NENLWjlydkhHWmlBYWlQUThic2ExKzlleXVIT0NxcFVLd3FrVkQ1L0RMRmVL?=
 =?utf-8?B?cDVPeFBtSm0ydXd4TnRWT3g0RlVucXhCZ3l6aldYVUVtVW1IT3ZMS2x5ZkJm?=
 =?utf-8?B?blU1UjMwWUJTVWpGM3Fva21LRVY0U1JQVGFGSWdmUVNFMmpuTW1tdEViWCsx?=
 =?utf-8?B?U2x3NWNTc2dXRHhDM0ZXenh5c2oreGZMTW1WcHlOU1lEVFNmVk9ubC9jeDR6?=
 =?utf-8?B?anI3WUY3bUNwbGlzZXpXRE9KWkdnSkFNdFNmOUQ3eE1iR1BQRndZdWU2ekxt?=
 =?utf-8?B?Z3EzU1JLQ285MUJpNHI5TzFyQnlTYkFiaGpDODRwWk1ER1UvYUtXdlJIZHJq?=
 =?utf-8?B?UFo5eEZFS1YvcUpsb1NLQThQd0VSU0VZM2twdlppUmZ4ME9pR0NyWEdTOEx2?=
 =?utf-8?B?TlM3ZGhUSm5VemREcnFySVVTWlBkQmlzbVEraHRHTVkzaVZyU3VHKzVMeElM?=
 =?utf-8?B?elVpdkJ1TmVYTDJwbTkybFFQMHpmRHJPOWpCWWk4bWpWM3pBdXYwbUM2TjRa?=
 =?utf-8?B?T3FQMDlZT2FGTmgwU2llM3VYVjRqMHFGdmMvOFVGODg4VXBGVG12cVZkWTJR?=
 =?utf-8?B?MWhlLzBXR1QzWWlVN3ZhSTkxQVZnRkY0all1ZEMxdVRickUwRFIrY2ZXVFRz?=
 =?utf-8?B?OUZ2QjhHSUZzSmxyZlM0bTlJL3hHSmN3UnRmQXc2WFJFcVFaWFAvSFJ3eTJC?=
 =?utf-8?B?elJPQ3M3U0NESGhEck84SStyZklwVE9aaVlKeTB1bHFKUjYzcXFKNWlkVktl?=
 =?utf-8?B?OGxYTytSbUk2aWw5bmVLb0g3QThPNUdYNS9PcVlPbmhFVnBpNUI3TnIrNm9p?=
 =?utf-8?B?Q3A2Vk0wZDlKLzNoY3cxb1E0UVdSKzF1TlJ0TVZLNWt3cUphSFI0dW8veHJM?=
 =?utf-8?B?RjNNeDJTRUwreXhMcnRRa1A3TG51cE9TcjdUQUQ5eGNETE1INWdRWloyVmQ5?=
 =?utf-8?Q?vrRQyYGbhKLbGi9M=3D?=
X-Exchange-RoutingPolicyChecked:
	MXCot3Nb7YvQ5+26atVB5mOAEe91/T6GBVAAtNgwI5Rx/TKIoKcd91dnrnIJ6wTDJp927euxVt/BFk7JtQ8JLrU4LxVFeKPgk1/EyWJLFrVt18srp9IephK5xhxsLow+Ho2qyeY2du9SmoFScx5+Lizt9GCGhOXJw+uCwCFKSAxwgcTcADBmrvK9Nz1ivENfTBHKMG+lQU/I+jc/tDa44nPt4mBJg9COntH0vdV8acgPbfOI9bjE+hpbY5RFW3IbW5gMRsbLAe4RiFyGENwviksdpbNmDg8c2IPhehP3BfnRfsVtfz8cX0lz2jKnor1Bp/M828r9rjdHtw2K2D/XmQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eAhM1IySf235TJup33aGISkoY4XyJ03FFGEQxGB6ywYJ6FqE6r2BWSXRLsjKLjFOmyUHsGpER1KtTPjozPTz8cMU0vtMjx2bknAJvm3jIrgBVyvOjBRFqUNI8Wa6VX1lpa7GXx3nijm4W/t4N4C2eUr3TLY7Xy2A2pW6dsvzzh/yuvVK3H9swvy83hTgfjbJfkuycD7BJTMNZCrhIZDzNTMPa60hZkceSS4jM9au3FAXZXTWQU83ssIf6QzC4PAVbtmlcepdr95htAt6BURzW04wpa45kaHaHcqxYSCcRCl9AMcQBibNoCVJ3ioVMfN0yLZu3tSt2pYyzin+/YReCfasNR6Nkc6qukRxncY/jk4clsF2RjyrUGxsHbcQ6NjCtb5KNeTlaX9XnwK5FQmj/a8rPJiGMqblUPIq+encS8n7Wvj6wN/7LiUxmKC1feA+P/iezyRdgu13eZq3sQgOR3AyerZJH7U15YqwvwyQphCte4cMHrHqkKDYKHVM5AVdWRjPY8rpS8sr8dQm1DCG2qKZFlVn9B0vAHl/Ym5ECV9Untu8obNuHF4kFj5zDV7/fxhq0LFIiKqv4dPwgt2Kp7RKiUz103c9RclYffQfY58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afb29c9-d740-4582-c336-08df46dee387
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:18:42.7917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZ2LATAEj/z9kPGt8MmZEQ5IPCsyCBKkRwSM4GklNsfT4zG9XZps6NqLSU7Q9h8LorUK6Td1YjXIxlOi8kgktZsxdz4TjYyU/4MJrjGlGB+tuo8zMGPtd1scrOT0vgG2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200032
X-Proofpoint-ORIG-GUID: ZJtYMMfzr74UUyS_v_d1Wv0_qSq9PzPT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAzMiBTYWx0ZWRfX6kp8kdAta56K
 88ayFeVF9hlsQN89vtEfksBfHiDU+i09W1zOxnwi8FK7E+GL2kbQEZNOdoaMlNzK0PytUeMeYmf
 UEw7X/GHfkI9eXdExJhZQxqnwRQGWhmSJY9BueOXYK/n+rI7qP6f
X-Proofpoint-GUID: ZJtYMMfzr74UUyS_v_d1Wv0_qSq9PzPT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAzMiBTYWx0ZWRfX1C/x9Q2c5tNx
 2uhrhP0+2PRudesOqVVsuTwm1jo6EzV0pIwvskNyyQTpMdFNFJRoNCLh98ceSrSxARU6MjV+twX
 ADNQUU1/G+M2jtQkB4hnO93tf/DRmt5S/omtMzri85eBdCFK7M7dGDqRbXU8FW12PenYi0yExtP
 0qa7lK0nSsnNyhBxlNWATZoT1Vu8iRHMzQz0A4Gr5bfKig+fSU5/y7wbEUhIBSkj34Gc97XcGOP
 VuO+ivuuR4AdqcfSsh/dVf4iMAfsru5XsBGHOUdBkN4jTylOXGkQ7gxI2yFZ24bVjMFByKLpGYT
 MrLsm3FQvuNBwgpd28XwwqDtzcYovKjjcGDNjP+MO7Sq4cdMI6s+ijUAGnQocdRZ6ZYez8CeNL3
 A/d7upVHyl0nTLwZjEksnWH6j6oaqDAgpZA5jRK+e8v4FRYdD6eXS1PRdin93Ok8VbBoCI313bY
 olxFbrjlnKdJSsfZIiQSG/Lei0hJdgpiDCJJMX2I=
X-Authority-Analysis: v=2.4 cv=I+vw19gg c=1 sm=1 tr=0 ts=6b000265 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=mpaa-ttXAAAA:8
 a=cm27Pg_UAAAA:8 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=BhpQLTp8eC3ub0ksRzUA:9
 a=QEXdDO2ut3YA:10 a=WzC6qhA0u3u7Ye7llzcV:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532

Hi Greg/Sasha,

On 18/11/26 8:11 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Justin Yeh <justin.yeh@mediatek.com>
> 
> [ Upstream commit 59fc35a1edbfa5405122d749cf8843da131fd796 ]
> 
> i2c_hid_core_shutdown() sends SET_POWER(SLEEP) even for panel followers,
> but nothing in device_shutdown() guarantees whether the panel, and hence
> our own power, is still on by the time we get there.
> 
> Do what i2c_hid_core_remove() does and just unfollow the panel.
> drm_panel_remove_follower() calls panel_unpreparing() only while the
> panel is still prepared, which powers us down properly; if it is already
> unprepared no transfer is attempted at all. On MT8196 the panel is
> unprepared long before us, so this also drops the ~2s i2c bus timeout
> from every reboot.
> 
> Fixes: 96a37bfd232a ("HID: i2c-hid: Support being a panel follower")
> Suggested-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Justin Yeh <justin.yeh@mediatek.com>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/hid/i2c-hid/i2c-hid-core.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
> index 42212ef2aa0f8..3819612817010 100644
> --- a/drivers/hid/i2c-hid/i2c-hid-core.c
> +++ b/drivers/hid/i2c-hid/i2c-hid-core.c
> @@ -1333,7 +1333,16 @@ void i2c_hid_core_shutdown(struct i2c_client *client)
>   {
>   	struct i2c_hid *ihid = i2c_get_clientdata(client);
>   
> -	i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
> +	/*
> +	 * Like in i2c_hid_core_remove(): if we're a follower, the act of
> +	 * unfollowing will cause us to be powered down. Otherwise we need to
> +	 * manually do it.
> +	 */
> +	if (ihid->is_panel_follower)
> +		drm_panel_remove_follower(&ihid->panel_follower);
> +	else
> +		i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
> +

Verdict: We need to queue a followup fix, nothing to drop for now.

I ran an AI-assisted backport review of 6.12.y, and the report looks 
correct to me.

With fw_devlink=off, the new i2c-hid shutdown follower removal can
dereference a panel freed by an earlier panel-driver unbind.


drivers/gpu/drm/drm_panel.c:
6.12.y 8b7bb3cf6ab7:

     get_device(panel->dev);
     follower->panel = panel;

Original upstream 59fc35a1edbf:

     list_for_each_entry(panel, &panel_list, list) {
         if (dev_fwnode(panel->dev) == fwnode) {
             drm_panel_get(panel);
             mutex_unlock(&panel_lock);
             return panel;

drivers/gpu/drm/panel/panel-edp.c:
6.12.y 8b7bb3cf6ab7:

     panel = devm_kzalloc(dev, sizeof(*panel), GFP_KERNEL);
     if (!panel)
         return -ENOMEM;

Original upstream 59fc35a1edbf:

     panel = devm_drm_panel_alloc(dev, struct panel_edp, base,
                      &panel_edp_funcs, DRM_MODE_CONNECTOR_eDP);
     if (IS_ERR(panel))
         return PTR_ERR(panel);

With fw_devlink=off, panel unbind can leave the HID follower bound.
get_device() does not retain its driver-managed panel allocation, so the
new shutdown removal can use freed memory.

Upstream uses counted panel references and refcounted panel-edp
allocation; the relevant follower change is ac3baea883da ("drm/panel:
find_panel_by_fwnode() return a counted reference").

Nothing to do for this backport, we need to followup with a fix I think, 
this backport only exposes an existing issue with new shutdown path.

Thanks,
Harshit

>   	free_irq(client->irq, ihid);
>   
>   	i2c_hid_core_shutdown_tail(ihid);

