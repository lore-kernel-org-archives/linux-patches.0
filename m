Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795169753;
	b=n16apKOL43OfE7ACuBQ3lDedFiCzEXwK5klzv5ATBngQ9XJewNNDBiajiTHLH1+VN8oc
	 Sst0x442jNEnG31FZyoUHOzUwaG7u9RCUjE+xVK+ozDuGfY9KC4xLM+WCuL7p5SaSrDbF
	 0K8g+VFTzVIyHLTSPnfBz46YhQUYUBNAK2vKq2FAio0BvPAr9/T82ijiR5eY653V2eQPC
	 4wDSJrbczc23reuP5bKvNiC1VEdeSes1HxlGfqbafjaF0rhJmKqL0bIwkmDK2CpnVpnSI
	 CCIrM4Q6C9/4HcZl9862caBo7y5fK4S2t8SDVzzO56gdw4xBj/884GtHuDHK3eY+YAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795169753;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc;
	bh=ciU5m9+tn0qNch8h4NpSpe1gH2V4n6Kx848AkkYs2i8=;
	b=c58lD9O8eX3XezDsxWDRQ5ChycqdNhKb0AzF2ek4L0uGK/hfTWr5uXxSrp/cxvu8Mca3
	 tgayF5/pUyvIR8vdJBIpkUGdIcK/UBJw4S7XIclltEPvksO5sPjVykswv6kHdNXyEYL4m
	 tOSDGQ+LmvUlrcVYM5bDPEt5r5djRUc/K9OnF1gxNPT7i4ln8jBdomz+ddu0KS/6SdUc4
	 iIyOA7muhxwfsqn+VDlE7imybpPzZNFlMvNhsHM8qUUnxQibNKfQZ+Vl3cQaVHwNky+8s
	 RCz9GDByp0rPwdi+/2CIabH8HUcHAshbnkt0TAi22Gao2ERaJstkYcPjdleyTW3hBdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=q3ad3w28;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=qVZoxO+v;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589EB606A320
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 10:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 589EB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=q3ad3w28;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=qVZoxO+v
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK2Lvir2333359;
	Fri, 20 Nov 2026 10:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ciU5m9+tn0qNch8h4NpSpe1gH2V4n6Kx848AkkYs2i8=; b=
	q3ad3w28eIicTRt4wCWVdXXy+ATeiCvjw5pN/4CVYAOt3YZSMBQ3dt/XlO3vVrby
	i/Qml5Qy6yWxv61LBO4RCRBpAovcO6MRKMiZUsrNGejKI0MogJFp0ukyGBxX1aMK
	6SAChaO5X1D1ntTDmCGKGUiiwpbZSc+gjzzyoMMXvPbKjLCXKJAAVgdCTxnFp64N
	4Peb8LhUIWyU8vtoicshQWApzyhDop6A52BjGqVucRF4G5I9j2GUqF01/H2i9+7+
	ipgIXPjdUygV3PCMNI4J1aN7kRkytgedjk0o0LJpfap2BUInKvu+61+FSp+/n8VK
	XuhN87oZsNJcSnmzLau9MQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytscd0t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 10:15:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKACalh4057109;
	Fri, 20 Nov 2026 10:15:48 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2m8d83d0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 10:15:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnI6EzhztBfaORJGcLYdXx+x9fEviFXxUARE4BxabdLBEAycZBJMYV4rTce/f71bvZedK1nV/qJmJaJFfr+dD469ThMrM46NXaFPom1U00tt5IWv1ivFzJv4FusTgBXqM8L946c8VeHymG6HCYpB7W+kfpRaE1au9b2MbII0HqtPHa2mnbI1YqnBgRsxL7izuF4YQdk8Z6hPK3csey1rwp0Qfqhnh/IJcyLViwj5n8U4URhmk0uahO+57/0VnlPO0HI/EtF8iUmxI9KGppECeTG5Sw9eaOUGbptSmMlcHLA8WPgKYN0+Xploqe0UQ9ypGKxueo3Z/5CV+ZWQUdef0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciU5m9+tn0qNch8h4NpSpe1gH2V4n6Kx848AkkYs2i8=;
 b=ouwHlVwdDFFmBwtLrPH24PGQKNNblkrTrJkzF5gbdiKqXdq5m0TOGfjn5F4FyyeCcjCriZEZTHmmhIr/lU+nI3bi01UoaOvk59xJVvbJhZvpAAYNRlOoHbqJ5HHttxIbbRV9yNE+Ro+uSISQyBfHC0VvzzRSS8E7gLriHZHszcJU96wAiOJDGBjG1+z551ZpO5XJx9CVeM5pr6V2MjsLnrvZlvefiTWFchchDAvck+QbzgbXRW8Gzx+rPm80NlFMAoks2RrDl+ih3pXbbZSHkjGsVH7zESARa5mCjXXuROmQWhPXNFtMf3WmHT6X9AhizGkuscIUYVF2ek4dm/A0iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciU5m9+tn0qNch8h4NpSpe1gH2V4n6Kx848AkkYs2i8=;
 b=qVZoxO+v5KNzSHfbKKf3rS8HQsHNUaNY5kvEvm6q6gknlQPZdeCqlRhPNM4TKeCruxtiaObLxgE8WLuZWbbBxMbV2x6TVYrx/3aiMdvovSur/dolBHQcfysj0m5/mwIBNoplHAzbOJfwAoFLreYh6KpFmePsSnSCCP5K5UlrYwA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 10:15:45 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 10:15:45 +0000
Message-ID: <8d1be42c-3ecc-498a-a4b3-3c9ed2f2bafe@oracle.com>
Date: Fri, 20 Nov 2026 15:45:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0819/1756] perf/cxl: Dont share the overflow
 interrupt, and keep it pinned
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, sashiko-bot@kernel.org,
        Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang <dave.jiang@intel.com>,
        Will Deacon <will@kernel.org>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150042.180974967@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150042.180974967@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0263.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|BLAPR10MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d4bd770-7151-47e9-d6e2-08df46ef3d7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|6133799003|18002099003|22082099003|13003099007|56012099006|4143699003|261022105027099003|261026140227099003|261026121527099003|5023799004|260925021311599003|260925021911599003|261022075727099003|261028144727099003|261102123227099003|261021121427099003|261021123027099003|261009223027099003|260925022911599003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Sm5PItMh0W5KmaGqirIhzmaH8OVNde8+C9GszuMIrESuw9EA/PagvfHNIroXPKHa9v3ancIz+YJbgSWEE6sz6Wac1TZJliVtTGa7kJr7Y5zBoA6ClSrEnVY9qL6I9bbzTi+Vmx1WA7mM6btR0wknE454ctkNqBMglLMyi1Y2hUWMIdJbla7FLHeO29hFTCqCLNVW4S1VB7TZ+X55YDWrKaSdmj0U2gZe6elYuRZB/zg3vaM6oMXPXKY5jxBzwJonsfnyeORY3nYbjBg5FegSLD3e+gJUzZXRQskYDZGIjOTic9ZgCaPea9O8SvdSNksafEJz2lP6k+Fr6nzkDcREGBistLicKtGnl+mdVdBIHkTtt0FUPZa2xSn77usgm3UDpejML/RjYD24jkNGd1FJahuaBBmZdLfuh25vNH7CEP7N2M0bCneFeoKsBv9yVFy5RAn9FtbV/aV0lE9aKkf4vOa20A/gq9mSSkcehHdehf7gNvOtraH0WxEePdNSgKHgDb2IW6ABJBdloAis/RdeARdPmvjw+zdatPrx3DhcOEdeLiCtr0y6t3AscUzWSvycTlX/Y10SHItm8a++++hbazwCAuC+2vGOOF42J82aB7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(13003099007)(56012099006)(4143699003)(261022105027099003)(261026140227099003)(261026121527099003)(5023799004)(260925021311599003)(260925021911599003)(261022075727099003)(261028144727099003)(261102123227099003)(261021121427099003)(261021123027099003)(261009223027099003)(260925022911599003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0k0WUZUOEdia2VsY3pIT3EvZXdEMDJ3TmY4a1BJM3FGeE1OOWNNcTdIc3hF?=
 =?utf-8?B?SERQQkQzWENwa2ZrVGQ1bE5yS1hOZEdJQlZlN1BJYzNZeXlLQ05tREVnTjdM?=
 =?utf-8?B?OW9id25objJuRXJSdTlxKzdoMlg4Z0c4MFhja0dDeE1DT2c1SGNhbTNmNGFZ?=
 =?utf-8?B?bEpuYUUrdU1GQlcyTUN3NUwxMkpYcEt5K1pzSGdwME5CZXNiM2o5dTJCSXI3?=
 =?utf-8?B?RTJYdTlQTlFKMXc5SkV0eWdVSkc4VE0yRzBhNDBOZGwyMDdLRmhmZ0R5SHpU?=
 =?utf-8?B?d3prdktrU0JLMWE3VmlER1YyV2dwTHNPRldTUSs3L0pkU0ZXNFVTcTBLMXM5?=
 =?utf-8?B?dVBWUFNwVXUrT1NYSE5mUm5heDFRSnVSNVlnc1VXMllUZzFGYkRkYkRRQmRs?=
 =?utf-8?B?SmtWaTBOV2srdENNMWhOb0twMHVoL1ZCSzdjQzgvTzFLdURnZHhzUFVnNm1E?=
 =?utf-8?B?eTlRQXVCMEdscVNQVEN2N3RpZWE4U0ZobjZXOEdGaHQ1K3Q5R1JvWkVRUGtQ?=
 =?utf-8?B?ZkduVkZJMVp2ZVRCTy9pMWd2Qk1scU4vZlVObHlBTmxmWEZyUTd1RC82RTVF?=
 =?utf-8?B?M3VSYXd1V2NZRU4rZXJBdkZMcDhyS0ZweUIrNTF4dmxhV2trdmRyNDlQOFZ4?=
 =?utf-8?B?U1F3QzFqMW5vT2FITkljaG5NaFNiTWVSMzF6VWZMNUdaUFlya3E1RENTRFpv?=
 =?utf-8?B?dUhWWDdCc1gzUjQxSzRLOE1VUytNcllZQjhkSDlMVEJWVWtqaFVMSzQwdTgx?=
 =?utf-8?B?V3kvREFXWlluZmMxVXNLaWpQY2pMRVpQOVlyTmNnV0pETitoVVhjOThRd1hw?=
 =?utf-8?B?ZU50UnRLclR1Y0RNWlJJblk5d2xZVHYwR0VMUmc3V21BT3Zyc1FlMk5rVUcv?=
 =?utf-8?B?U3B1eTlwYlJYU01leC9EaVFJTGtoMWkwdDdJc1I3UDRacXpvUmw1dGhGV2Q4?=
 =?utf-8?B?NlQyWkdLU1lNNXQ4dXQwZlVRRVdBTkVqWGdjY3BTQmFjTVRVMUVjSWtsd2E4?=
 =?utf-8?B?Rm5qNzkrdUJHbEV5UnpMeFpScmhLN3QrdjE1MjB2UDdWSktEV1c3Z2doTHV4?=
 =?utf-8?B?S1FFcUxIK0tyOHR1c0RQeDlJOGprL1ZFdFJuczhoZE5yaEJtb1N6WUQ4dWdo?=
 =?utf-8?B?UUw3bUppcDJRUGczTkRKTXhPV3ZYRGJvMTVPWHFuNTVDQmI0ZmVGN2F1dHFN?=
 =?utf-8?B?N3lMOU1MeVcvdm9FVXY5dnB0VERZVG1qVFN2SGNKTk1WV08wdDFvWHRTMmtF?=
 =?utf-8?B?cERPTHdyVklia1pxeldaSW1ZSlh4YUpXZDJxQnRBV3F4dnh5MUY4Wmg2UVJp?=
 =?utf-8?B?S01aZWZtUERlZFovV1V1ZUt3MDhHOExvNmFaTzV2VEtGbUlDNHFOYzJUV1Mw?=
 =?utf-8?B?Ni8vaFVwaEMxWUZ3aHdBdjEvVXRZUW05aFJZempFTkNMc2p1V3ZUM1Nvcy94?=
 =?utf-8?B?aGZwQ2hyalFocXVaSCt6bWRXd2FSY0lYTDc4Z05GSi9sVWJSU0ZPNU9PeEdJ?=
 =?utf-8?B?N2R4T1pybG54cmJFaXJsbkJrZElGeVIzL2l0UXJ5TzFTellRK2p2RWhrOU5N?=
 =?utf-8?B?TUlCNlpwTmVGa3FkOTJXY1kvWlcxVDExMkNtZVNQYjdpQm1XVldrMldzeU1o?=
 =?utf-8?B?VzJzWXpHMDArSnMrK2hpSm9uUEN1d2x0VEJUR0pHLzhaN0MxL3JTRUxOSDRC?=
 =?utf-8?B?aEE3WFJFYTBYYTJHODV2bVV1Rk9NbUdyNFJHc2llYkR3bFp0T0ZreHF5SS80?=
 =?utf-8?B?V3Fuc09KRlFHckFPZGJYQXR0aHlXellYRkVWUHQ1bE03Z0F6TW5mVCtML0hu?=
 =?utf-8?B?MlB3c2R4MXc1MlVKUGh3YXhWNldmYkMrTlJ5VFdkS3NzdzZRRzMzVzZ2ZVRL?=
 =?utf-8?B?Q0JOQjZtaHZmeEtULytmT0d0T04rU2JRNzNQck1tY0V6MTZPU3V5TTQvZ2Zv?=
 =?utf-8?B?TUx2WGw5ck56SnVDdTlTV0RleGEzbmNzSGMvc1ZKeFFUeE1zbzNIZWVmOXdl?=
 =?utf-8?B?dVV4YkxtVXY3eFZCNFE2L3VpZUpSampCRVlkVnJRV3lHVjQ3SS9jcmt5MVky?=
 =?utf-8?B?OWFLcTJHQW40VFhKOWVkRUkzMUo3M0hJYXFWL01ndWdhT1BPaENyUWJnTEQr?=
 =?utf-8?B?S2Q2ckZHb01DRnZhWGdmOHovMWtLN0RiUGFNYUJnRlo3ZE9WbThmM29DZktM?=
 =?utf-8?B?T3ZXTUNOWTJhUElRdFFPcDRHd2pLcUxUSTB1Z2F6cEJoelU2MmlDMVFOaSt4?=
 =?utf-8?B?dGpFbmZWRVhMenFManV6eFN1MnVBTmxlOVNkaGJhV2xIMVBXZzNEd0ZOUDNi?=
 =?utf-8?B?U0JtOWxkb3FMSHdQYmFhVE80Y3h6OVRFdjVYTVRMNVFFUE1KUzRid085bTk2?=
 =?utf-8?Q?vAlAZiglK4STtmPE=3D?=
X-Exchange-RoutingPolicyChecked:
	m374nwLsX6H78wjcoqqfV6zBP2lf22+f2H5rrqlMLMvF4CI3n83DYbNgvtS9kgogqiulXyKOZRUPFGHc0bPyrEv/tqFiPK7FiTIrTxgW3/71rY2Tuz0A3z8/b5elgDTyk56sCxoon0+EtaV88rbKRbY1ARjHUhy9hTomrm3oLGvjo0mU0UnBAn2phasyXbj2GxgZHvnkhIfomIsMNsC602EgB/bTYbL9gzyumbwWcgDWIKkYf1mwZq2ON3SSgaY7ntnWqddNF1LpvvjcoL8hEueQSWOd0Vt0FiICaGyfdm/0NeZk+XMVKd8+Lg5psMqkqno7my7xK1quJrg8gYu+wA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	frLDEZBFZdFzsXNFHtjLPSQm1EiMqbi4y+sHXA4VxWU+DypKT9sPhq4Z9KgDZ+hTv+1psR07LcBWyGArRn5RQfWsQ5hFMVsp2baSorGaK6qjWIQeRdq+XcoHiiC7GStppXHoBd2DIMzx072sS6dqguP07ip0GUrdmlo1H0oc8TJbFy76fvzy0fJRHpFpE9wCN79vO+DfMaRzeSETG3jtG4ZCg7I/PtsbxOTPsvlc77gpju3MMGYbMrIevbXK/UcvgcF9gjV+AZBwybSA+DrO+Qyttg/R+HYjyHByhgalurPeaj+19eKtDjJiLtfp9xYv818Zia8AXfKlOqV820nilINQ9hP7F4FdNTbeojEv1bzCECgQdYy6Px2DAcFJpYpULHGYTxVtbvLzrXYmmpt9UdN0dcom8MEOr5DJ43nKnZ9royti9TIza5vE3zWphbL/yC30bQAFP1HEpqaZycml6gHtoNwX6fnHO3cVVe2wlJVF8hVqVCJkrE2yc9Z/60dXkhEtP0zuFjqK8uv4GEOa9kyvpeiq7dAzMQ4Y62c2Q/FpK03t1fnW70bB0O0pLp3n18WeVCP6olOOEaZwfHb8Dg1ntBlqY+OxUkPmBi/3ySs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4bd770-7151-47e9-d6e2-08df46ef3d7f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 10:15:45.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nLaWuaC2ofuebbqaOohDNyQvF7EONxfu7rb+4S3eahQyGedAh6RZ2WbfZitd1ggWXD+jvKJYPvaRbwoT3BGGRTFNP3xCeBIZEvavT+q4Qjl+u30C8d5+ftNS3CkOiqjn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200040
X-Authority-Analysis: v=2.4 cv=LIvz05W9 c=1 sm=1 tr=0 ts=6b001dd5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=c92rfblmAAAA:8
 a=R4ayLD03AAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=2WKo8kFYC20T3B52q9sA:9 a=QEXdDO2ut3YA:10 a=GvGzcOZaWPEFPQC_NcjD:22
 a=qJlm0-shE6CLU_iKUWNr:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0MCBTYWx0ZWRfX5ljHhbUxYgsX
 LWjjnIMMK5VNLobnP73otx1KK4b9yLfwJEWRQeyJ0+J6sIiyiIF2YsBUtzaLZ/36pSlxCVKhW2Z
 xhdb3494KWgejbi3Mg9W7YaZhuznHGPUBpqTFNBJL/u/NEB0VIny
X-Proofpoint-GUID: NR5E_GiksDTQHpy05B7ddpKm05OGd-yc
X-Proofpoint-ORIG-GUID: NR5E_GiksDTQHpy05B7ddpKm05OGd-yc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0MCBTYWx0ZWRfX1gCzQCEi/s6p
 3qlQU7JQbRoyFo+xk4imiAYN9rtp38T0yp7cRHNA1T3MH5uPZVYD0siph4PxupvPdRvI/Tc46f+
 bInm9ERwMas+vXjXgi9srceFKSNomyv770b7FBM9N68Tih/adkqTOdFJtmjqFDRnTIThpZKcKb6
 KWle5sHaXGNkuKydrX1vggYUga832t+Ch2aoU5chtXQGxi0YWIjrdiNfjIOavtm5Npd8YMujhZp
 F6lVMO4aQ7OXPwJbrM+rCB6k9tzYjPsFCQcghKvB97Cjx/Ep/jlvTG+KnUzxsnFliFBlhr4FiDl
 G68hk16Ga3ZMjiUIK2B6RvjdJ7JWT13u8xkcFaS/E0d0ofhyizMiiskLQV6OakDz4hfFDRQ48cR
 bUb5DaVeeoVsAariAHIq27PLlL4FjFYRA+PLrVmVOOcmPaUwQwGi570tWSu9zVsSVpzQI8idSdQ
 eRf1Ph64zQsIQ9JsgePyFScVRYM7BbBbD0Fk9HYI=

Hi Greg/Sasha,

On 18/11/26 8:19 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dave Jiang <dave.jiang@intel.com>
> 
> [ Upstream commit b899fd3487b0d4066d60ebcf5b73e77c9617de54 ]
> 
> The PMU pins its overflow interrupt to info->on_cpu in the hotplug
> callbacks, but requests it with only IRQF_SHARED | IRQF_NO_THREAD. Without
> IRQF_NOBALANCING, irqbalance or a userspace smp_affinity write can move it
> elsewhere, and cxl_pmu_irq() then runs local64_cmpxchg() and local64_add()
> on hwc->prev_count and event->count at the same time as the managing CPU.
> local64_t is only atomic against same-CPU access, so the counts corrupt.
> 
> The flag alone does not fix that while the line is shared. __setup_irq()
> only acts on it for the first action on a line, and a co-owner has no
> reason to want our affinity - it would keep taking the interrupt wherever
> its own points, running our handler on the wrong CPU.
> 
> Drop IRQF_SHARED and add IRQF_NOBALANCING. The spec only recommends a
> distinct Interrupt Message Number per CPMU instance (CXL r4.0 8.2.7.1.1),
> so a device may put several on one vector, or share with the mailbox or
> event log. Such a device now loses a PMU rather than silently miscounting -
> and only the PMU, since the preceding patch adds the CPMUs after the event
> configuration.
> 
> Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
> Reported-by: sashiko-bot@kernel.org
> Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
> Assisted-by: Claude:claude-opus-4-8
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Link: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/perf/cxl_pmu.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
> index 09b9eca802525..f8195774213c4 100644
> --- a/drivers/perf/cxl_pmu.c
> +++ b/drivers/perf/cxl_pmu.c
> @@ -779,7 +779,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
>   
>   	overflowed = readq(base + CXL_PMU_OVERFLOW_REG);
>   
> -	/* Interrupt may be shared, so maybe it isn't ours */
> +	/* Nothing overflowed, so the device did not raise this */
>   	if (!overflowed)
>   		return IRQ_NONE;
>   
> @@ -882,7 +882,14 @@ static int cxl_pmu_probe(struct device *dev)
>   	if (!irq_name)
>   		return -ENOMEM;
>   
> -	rc = devm_request_irq(dev, irq, cxl_pmu_irq, IRQF_SHARED | IRQF_NO_THREAD,
> +	/*
> +	 * The handler must run on info->on_cpu, so the interrupt cannot be
> +	 * shared - IRQF_NOBALANCING is only honoured for the first action on a
> +	 * line, and a co-owner would keep taking the interrupt wherever its own
> +	 * affinity points.
> +	 */
> +	rc = devm_request_irq(dev, irq, cxl_pmu_irq,
> +			      IRQF_NO_THREAD | IRQF_NOBALANCING,
>   			      irq_name, info);

I ran an AI-assisted backport review of 6.12.y and the finding looks 
correct to me.

Verdict: lets drop this until we have a prerequisite commit.


In drivers/perf/cxl_pmu.c, cxl_pmu_probe(), this patch removes
IRQF_SHARED:

   -   rc = devm_request_irq(dev, irq, cxl_pmu_irq,
   -                         IRQF_SHARED | IRQF_NO_THREAD,
   +   rc = devm_request_irq(dev, irq, cxl_pmu_irq,
   +                         IRQF_NO_THREAD | IRQF_NOBALANCING,
                             irq_name, info);

But drivers/cxl/pci.c, cxl_pci_probe(), still adds PMUs before
configuring event interrupts:

       for (i = 0; i < pmu_count; i++) {
           ...
           rc = devm_cxl_pmu_add(...);
           ...
       }

       rc = cxl_event_config(host_bridge, mds, irq_avail);
       if (rc)
           return rc;

If a PMU claims a vector also used for events, the event request
in cxl_request_irq() cannot share that exclusive interrupt:

       return devm_request_threaded_irq(dev, irq, NULL, thread_fn,
                                        IRQF_SHARED | IRQF_ONESHOT,
                                        NULL, dev_id);

The resulting -EBUSY propagates through cxl_event_config() and
aborts cxl_pci_probe(), losing the memory device as well as PMU
support.

I think this needs 28b2b667f48f ("cxl/pci: Add the PMUs after
configuring events").

Upstream places cxl_event_config() before the PMU loop, so the
event IRQ is reserved first and a conflict only fails PMU probe.


Could we take the prerequisite first ?

thanks,
Harshit

>   	if (rc)
>   		return rc;

