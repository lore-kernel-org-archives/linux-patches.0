Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795282892;
	b=JYrUbY01Tm799LmwTYy23wzNTFZoWSOSigDPC19WWiyOShRG3reISXYwTDZ6/F6a9tyg
	 2ZVzqNG52IQRGMFMwOdddt0wvk4q4tzBSSKkDC6cFGoYsJ838Z/EppjFuIrBwgBt9NsXJ
	 04qAAbQKMb1YSCheACBBmny7CQse25yuUv95yCXR5QtlnXE7WlNwFTSUC9j8ZFFtBv9Hk
	 Mbr7QucDtXl6SBIsgOUSqsEbWeM+PLn7LJi7o8+/HBN/fM1lKtAORE62e4WKR7s1d62/1
	 Ls3w9o01JHpjlwCTlT+vUmCDA4Q6GLgafund+IlHT3vzNgDhy+odlX+bqezxJfW5Haw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795282892;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc;
	bh=DB0QRA8zcpMWYGIeFbwwAkFSxlh0Q8OTcuZO9FiZP9Y=;
	b=vn3tVmsxQ5iZnR6qqttiTRiwf4S0jySckse/q9gveheztoXPS9q65hOXWurdcMJ4FN+6
	 nT/dVaP1mR9Fm/bU2ePuGEUCS0HK539aYsd+sf4yi/KyWn39ZzXM3CkuoKSWuKhY3h1I8
	 vJgFdQBh9kFNh5JoPgXYVfwfk8jbKDTxFBsTkgiP153m1/0f7mYo4qep4kAzeULirY7Il
	 aXhWisncKFPLgJtq7q2BbePDtfJDOSOfEfKq4HymN8g460TsURI80R7jKGvfp82T/0Fee
	 S1x4//jd0DYLyxVyog5TcwRrvosNo4Tn46RJuzenH6xN8fhFXP87Ps9e692Bulpq94g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=JhAZ0yPX;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=waA+kxD5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463D7606A32A
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 17:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 463D7606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=JhAZ0yPX;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=waA+kxD5
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALH1ohW1598157;
	Sat, 21 Nov 2026 17:41:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DB0QRA8zcpMWYGIeFbwwAkFSxlh0Q8OTcuZO9FiZP9Y=; b=
	JhAZ0yPXkvXPlapHRPc012XTZuWy1+DHBwruM9XK/NHOZoKzouvZcVXSoIi6H65T
	AtaMxGxb9U6g7LmE2CjUsX+w4stkeQY3QGK38+cOU+EGHYy1U4+d7yQX1qHthK/W
	zbaZkKvx3W1afoiD34gMbw27KsYqfwkfsZPzJ9r7q1x7hbq0p29rCq0wbOTXXVqs
	gLIjCqR7v6VCHVQ4+921NfScFn2BLr4YL7+mIemRR6rRLRh2Qj24y70gjzjsjX7f
	UiUiycweYd6nq9L6+zNL9uo9COs7Tg5WyvbXY2GVRtreru2h/5TJMjZYnLli6q9I
	PfzXJ5agd/pOs1OCA+TD5g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34rp8a95-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 17:41:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFXR4P2828343;
	Sat, 21 Nov 2026 17:41:27 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010001.outbound.protection.outlook.com [52.101.193.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j39pbnmp0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 17:41:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1+N4NV6s7R5npW1lWl6H782idtsfyERgE9zDNzl4bWsAbXpiOLkzkctRgqbHBppzm3DqwgNKUPS4iAgZYIr6Myh1CTiTfwDXg0ELY04Vib0Wtgw45YI8kgn2qcpwnv6M6QhokMIguy8ET7eTbaNG6P2RXL5+H2L1FGAXgo5KGJH9HvMtilDo3twGIcgov2uoAn3UAdmG5hLxbhmtSfsvwuXjM8b6s1fILcb6t+YIjkXZbWFJgpn0q+F96OydkLrDWObP9/8Ax0ijw19FuaQj1iezWXwVNS2Mu5mC2H/FZGpF5DpWfanVVTPVC0qah5HkG2I0V5Op2qjJxydsvG1tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DB0QRA8zcpMWYGIeFbwwAkFSxlh0Q8OTcuZO9FiZP9Y=;
 b=OxlH7Iek9Xs7O0WA6F+TGOmIhWSOj0eCAldCmYpQ98NOl9M3T7PO1GAXORqqxOkx42wq2qrTas/+tnmR1GDlSzStJqEpAufPFjtsA/ljoEkgO9BRCcZ2aXDxDiLVfv5Pqe2IpdcRYO42MZ4mBXhuNbIb77Zc+3TAbxh7mbaITJ/0j2wrkMDJwbjJ9XPKAcXFJyjXH+vsj0ddOlf0nmuCO3jR+52lnHciN4Fl5i2N9FybxBpG6sLofbGLWp2WqNbn4uyjoFjMOhUkTEQmGy61fGhm+uS61S7TcD357XDWBt09WEL/F/TH/5b9RtrFLvYm1k6/YBlV4Oh2iJpROaxqLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB0QRA8zcpMWYGIeFbwwAkFSxlh0Q8OTcuZO9FiZP9Y=;
 b=waA+kxD5fCz6/aJGgXVV8ctz2hhHA4QRb0kYFxtEs5CaLGC6IffI9xThrD03RLgZ4f74t1UbPqugFEkRut/1hflzHF+rlTxQkZzR9g8vv4TGakXwvkEtcbpL0XPgTVBEc72bRctgSXt0CBX2Gf3zgXzTNKbg2S9AVClD0O3k3vo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by AT6PR10MB776698.namprd10.prod.outlook.com (2603:10b6:170:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sat, 21 Nov
 2026 17:41:25 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 17:41:24 +0000
Message-ID: <866e1857-f714-4150-b3c2-12c0c3573d41@oracle.com>
Date: Sat, 21 Nov 2026 23:11:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1964/2214] RDMA/rxe: Create AH index and return to
 user space
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Sasha Levin <sashal@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150129.505298374@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150129.505298374@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0199.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b2::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|AT6PR10MB776698:EE_
X-MS-Office365-Filtering-Correlation-Id: e3c7d9c7-13c9-4ca4-6a54-08df47f6a9b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|18002099003|22082099003|261009223027099003|261021123027099003|261021121427099003|261022105027099003|261026140227099003|261028144727099003|4143699003|56012099006|10067099003|261102123227099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	4uO9mETlavQLcKrMaIX/L0xRtHU5+YeF+Bk0r++41kY/mQp2xADBXM7wfDu36RoSeKu6wc4jrm6fpW15+Q1CLK0bmcpWpg0URvACwCruWLEnHRHX/5lL4TnOIgwQHe+kSoG6lrlVGtOcRQs+ilmmMz25mfJBfetMxgltzYUwJg2YnDKZLh2DcmTLF23/sjA4d4XM7Kpb9deCGqIFPmNXnU2WT7yQG5YUUpL7sM/N1mrFY+veF+fsACRAKy95Zou2Q2pu5dZXzNsHNFzNm5AzIn8l0pNdfewbkOAtmdqJsueZGX2ojkLj3OJnMBvul45E5gD6Pf45RAw887JC9Xu9OypbOu+YtT4Ga2Si544jMFQ4t0UEJ5IFy+Ue9eG+4zP1eWA6oVCMNkw+Z789yL0L1Q7xTEQT2cE8a6uhy2qPXLb+Py2j99DZQCaaXTfnRnc3b1GkT640G41Dl4Hr8o6w0RuLwMEEftNwbom1/oJl0uLWrQRmu0Zwe65/J3ceSsM86VOsTU/9SILexKKXNE6byfzOaJJDJrQr/Ni4aIt/tRprX7y6aEdYtutS5qO+NF3AZm2KiDYe3nM/PFM2JYN+WOz+Ii4jqJPoahwg/KjudVXF2mUKOmELNG48piZbeDnh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(261021123027099003)(261021121427099003)(261022105027099003)(261026140227099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102123227099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1FIUzZlTldXUmxsa2dremYzdklZS0gxeXEzc1lUMVNBMi9ldTV2NXpQQmdO?=
 =?utf-8?B?eDFnQkpNenFEY1NBVDlCQUJpZThQd2t1T3hhSkNKOW9XZHpxSWpRWmp4VjBN?=
 =?utf-8?B?T0RWUUJuQ0w0T0U0SEc5bU5RdUFFQXBGMTZOaFp2bUdRUkVObjhmUE8xUEZw?=
 =?utf-8?B?dEhtNExPeUVEdDRpU1JpWi9DU2c5MENXU0pUeUhkdWJ0YTBTNzZGWkNQSmdE?=
 =?utf-8?B?QnhtUXBDUHhCME03OERNVGJ3MWhuN1NCYzV0azRJYmlSSlQ2YkVSWHdoM2J5?=
 =?utf-8?B?RlRWdmJWOU91TjVkNFE5Ris2c3pNdS9MLzk5VzVkcENBV0ZEUGFZSGc1eEdL?=
 =?utf-8?B?SERWd20yTmFWSGxmaE1VTk5tMzBYcTY1WlBYMlowV01KblA5SUl3UVRmQTA3?=
 =?utf-8?B?UzlIWUNQalZ0RU16VmZ2aUFoRG0wcHVSdGg3OGQvQkVvcjRYakthM2xrV3dp?=
 =?utf-8?B?SzFuQkp2R3lmNDJ5OWhSUkhpZzh3aTcxRkdDdWJEVGlaL2MrV2xkbWVuMis4?=
 =?utf-8?B?dXlvVURXQWpvVWJ5S3lIelErSVcwcDhMdVpxOUZWYVFUeUJvL3BjR0JUSE5k?=
 =?utf-8?B?SC9teWRPL3Rmb2ZJeTd5VUVOcDBibm12M1Y1elk0WXFFNUFPTmhCTnRvTFVp?=
 =?utf-8?B?b054SkRqeHA4NFlkSTNRbmt3ZFh0N1NIUldvamc0cEYvOG9VdWNvcXJaRHp4?=
 =?utf-8?B?R2d3Tlo2RldmazZPV1pEdi9LaWJoRzh5eTQ5V0V3YmNqRWZ2SVYycWpvamtw?=
 =?utf-8?B?b1pRNjBwQjVEeFlXSDlWYmVveGpISUJXK01USFNOVktYUzUvcWpnSE9PRXVO?=
 =?utf-8?B?SGJ3QlRwYlFRWXliYlFmOEEwY2ErMkZhQXNFWFUvcnB2Z1d0ZS9OcWxWSjRL?=
 =?utf-8?B?TG03emVTU3RiMThjWW1aN0pQem4za0FnL1FxMEtpL25jaFFlTS9IbmRubUJI?=
 =?utf-8?B?MVJnZzg2QmUvdktUcVIyb2t5RFFvbUowSXh5VlVuWUdJVUI4QmlPb2RpbVVW?=
 =?utf-8?B?amkyZ1M4WXcySHdwOXlSV0xmeUt0Ukh4RHNNeS93S1cwekY1V3VyckxZbTlv?=
 =?utf-8?B?bFRKc3R2S1RXTTJkVVdSNy9aMzFoU0FBdFVoTnRaaHJSeEVRa2cyOFpoNXNl?=
 =?utf-8?B?alZBRHZHT3lXaEtKSmVzRHlib2FldUZ1Y3hrVllvWXlpY0RhK3FvVnZkYjhs?=
 =?utf-8?B?clRIcndheGhRMHBxYWovUDVWK3hxNGRHdjlBaHZsWTVSRXFnZjJKbk8wL2Nq?=
 =?utf-8?B?NTNtdUY0czBUSmx4djROSFJENjBnNXJrOHlBTEdZc09FTWxQN0tTYWZ1aDZP?=
 =?utf-8?B?VElXNnFCVkpFUUNPT2lmaEllRTNtYlBhcm56UjZyZTBPMDBrWk9Kc1NibGRC?=
 =?utf-8?B?TDFLb2JxSmc5eEdmeW5xbWt4alUrbFBTN0tjYTVKOXJhY09aOTVSV3pkeXRy?=
 =?utf-8?B?ZnJjRlRRM0tkcU1sNG5Gb0VwQUMvYUNBNFZscElEeTBldkFPaytSUTJWNG9t?=
 =?utf-8?B?MGZBVEY1MjV4bzMzMy9qN1hqZEtGdFlHdEgrS2YvczN4MFR2N3FkRUpOZkto?=
 =?utf-8?B?Y0l1TzA5QlBYMHJoZnhWTUJEaDFhR1pYbGVFVzBHZXJoajFpejloWFd1aDVr?=
 =?utf-8?B?ZVhzbnpwU3pKWlRySUlIMlpyVDRBQlhtSTVCM0pvSHpZcWJsaVZiRk5iNjNi?=
 =?utf-8?B?MUdCMW5nN2JwT3FmNXcrSUFaM1VSckhNa3dBZjVzeGdWTzJtOC9scTloOGYv?=
 =?utf-8?B?MzZITzBEMUYvYmw5SzdsL2Z4YkNPU1NxWS9GR1ozNDhyWVNSekdkRFkrbG1j?=
 =?utf-8?B?MCttdmt0OGlHcWlzT00xS3dGQjlGZmVlUW1RK1FkTGNld1hCT0JwZVRIOFN0?=
 =?utf-8?B?aE9FcUp1aEwwcFh2WHo3b2JndXV5UFdZT2w1WDkra0Zqa0ZXczZaenpUdlVt?=
 =?utf-8?B?RjBKc0JTbHZMaGFOQjRZSVdOakczQnl2Qi9JMFA4N050VjB2ZzM5ZFA1UU1J?=
 =?utf-8?B?UlpjOUtiRUhFeXVBOS9kZE1ycG1JY2ZMR2wxajAzM3VUekNtcldaV0paa1FR?=
 =?utf-8?B?SVRqc21kTDgxK2tKTlJqYjBBRjBjYlV2VUE4WWlBeU9aVXVLMXN0RXc4RDh2?=
 =?utf-8?B?WkhGTHJWUG5GN085eFpOVU1zYzJGdGJITy83UDBFcVlYUEhiK1NMSlpzWGhZ?=
 =?utf-8?B?MFhqeEQ1amVHREVxd1JmZFZ5ZUZDUi8zT2lGSmxXVE4xLy9Bc0ZJaW1mdVQ2?=
 =?utf-8?B?ay8vR1ZlRTRrMktvTmhRdnJEUTRUNWFCbjcxVldzdHkyL21ueXM2WkZHVEZH?=
 =?utf-8?B?aExFejl3ZG9KNlQ4b0tQR1BobVZkK2lYUlBVOWhEVUJjMVk0RE03bGZGT1U4?=
 =?utf-8?Q?xOYBop5nBWixCkh4ZN/3vbJni14pHtz5jhcXA?=
X-Exchange-RoutingPolicyChecked:
	VAnhzs7091wzDcqHJGjygcYarngMopSDLsv3DQsjGe6tZ5p1k0DXtJHDNQh29h6SD1BnjZTX7MfL5CuoDf7q1u3ON0URg9rfJLqEXz/xZ6KYVc2NPS7cMAh3gXzOSjAPU7OLsGlMzBt6DWRFww9YFGv6waCWPb2Qyc4WZ1nTf0Hx4hq7vrvPWo+tbz2HqZ2fWgXNIFk/mA7a7IbMVH45qeSidJNye7TmGCPoL3eOg1KyzSGW3uTKVB041sEeDmdVMcr2NYDoy5ffOFI+0PYfP2qYunqiP8KRYqKhJpzEAOYRuZkuTYKvKnFs/yLuwYetvskAFPSXiZsgWT35NEjpKQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	623JSKwsYH67xG09eKPl7vSBb86zS9QAjes0c/3FYWbiDyvnAc88U4Iy5zfrAsZk0gEvlk7Cln7xWC06hNJVEujDJAV2+cwhbOc45pdcNsMX/xsBrnaE2yT9q25M2yXJt1bxTDcptXM9n3yrFvRzE/zATQvIZtUjJaZcJF1mGWh+6XBc50ZiRKhdQ0fLxQkN6N6kiqTIFFoelnjhTv5V5P5cRC0JP9YyYs624NYguPI9IYorjm4uSzJc7Xf9u8cIS0Vpsv/QejUtl2m5ehQRzSJ5PYeoXqzxvDQlOF45Ua/EvWuCJc9mv5fByV/uKGm3ghRwTMsA+MGI1OQLAZPJrhe7bRTel57+JxEYF+hGWW18cdOUo1yRWt3YE969cRRIdSNSfLgVDVStxlxmRSRBIZzmP78Xm0RvMq/lqEb1JCCli3MWh6hiS0+QBO/9Stqb+XixBZLJ1PkL8aaht1U68RrYt8NyEdSqDr4tosWRFLi716JgoRCB3eFX/pawfw5c6W0IT6Hi9l931jws3IaFsXG3QPk4fEGRzvOClGq++Wh42cM07Lv3hEAeern8kDB9agQCdN7cegFpVktMKW0fKAFQyw0PNQo9qQr9J5xL31o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c7d9c7-13c9-4ca4-6a54-08df47f6a9b7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 17:41:24.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgiWxpbS/gk3H7MqM29NPQw7r77Z7MyjKB/9QWjgAYTlfA78X0evbwC5nYlMbGdeu1C6kTaqruG3fM+d7GIPZdq7zGZrxGQxSiv4IbcNSzfKfXgp/9ZnX+uWMmqATsM2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT6PR10MB776698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210070
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA3MCBTYWx0ZWRfX2x8OGTflj7t7
 tFWeOx3YAvFt88a+Mim63R9KMvamUh9duCrNnMt7JVxooeIcPViLafPpN75ErBnWttg9giuDlUo
 sk4AG5HQGv3IqzeXKnNvcJnsqYglpxbg1JfhVvGJy1f+apSPgOYb
X-Proofpoint-ORIG-GUID: TbkSdH5ezLoou7Ank6I-TIVmEbnsWwNS
X-Authority-Analysis: v=2.4 cv=IpCL47/g c=1 sm=1 tr=0 ts=6b01d7c8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=5q5riC3uh6OTCl6NXt0A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Proofpoint-GUID: TbkSdH5ezLoou7Ank6I-TIVmEbnsWwNS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA3MCBTYWx0ZWRfX4zzJHZMpMH0k
 s8elIKzF7kQ/pfqlvLI2o3ieGqWHdSx4zT4S5k8lYE6enUBEFiVYiEA3YjqOUTF8glFqqkOQZfe
 yf+/BUl/vmY+VtAHWx3TRiZeKC/O1TNTvna9vAkuuyqJRx8FgwJ1Wo6J0W0qcffY4YQRBWzs7Xi
 6dRXrx3BHbTnW8qm/B5LgkktRZqm/p5+ZvSirWsnWOiclJOwYG7e6ZXjSf5ZQtVKD1/oMSZKk03
 WKW6TR8YWslawneXrgqaAnaO86LxOTDQus8j+Zqw0t8Gts40nJPeac1Jyr5cmirDqMnHBWV4bUp
 N+hCV3lENDah+jo2STOMFV4NnP4m2e8PxUsQN6lakC2DKqdR1D/QRRDZPladybXTmiX70zJCnp4
 wW3UVKKV/F9SnNFKVTWen/dnnv/Xg4WnfrPLtsiP2D5Sz4/q4EwGnA7mx8GWV6Lg5nuVlrDrDel
 O0Dob8Qbr8YQe/KRMRSm1qhxzNdWEeFijn1gNr9o=

Hi Greg/Sasha,

On 18/11/26 8:30 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bob Pearson <rpearsonhpe@gmail.com>
> 
> [ Upstream commit 73a54932100375ba94b31710f1e3f1234f23be0b ]
> 
> Make changes to rdma_user_rxe.h to allow indexing AH objects, passing the
> index in UD send WRs to the driver and returning the index to the rxe
> provider.
> 
> Modify rxe_create_ah() to add an index to AH when created and if called
> from a new user provider return it to user space. If called from an old
> provider mark the AH as not having a useful index.  Modify rxe_destroy_ah
> to drop the index before deleting the object.
> 
> Link: https://lore.kernel.org/r/20211007204051.10086-4-rpearsonhpe@gmail.com
> Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Stable-dep-of: 47a9c0338f2e ("RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/infiniband/sw/rxe/rxe_verbs.c | 31 ++++++++++++++++++++++++++-
>   drivers/infiniband/sw/rxe/rxe_verbs.h |  2 ++
>   include/uapi/rdma/rdma_user_rxe.h     |  8 ++++++-
>   3 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index d3aef42aaa38f..fe5c890ccb8fc 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -161,9 +161,19 @@ static int rxe_create_ah(struct ib_ah *ibah,
>   			 struct ib_udata *udata)
>   
>   {
> -	int err;
>   	struct rxe_dev *rxe = to_rdev(ibah->device);
>   	struct rxe_ah *ah = to_rah(ibah);
> +	struct rxe_create_ah_resp __user *uresp = NULL;
> +	int err;
> +
> +	if (udata) {
> +		/* test if new user provider */
> +		if (udata->outlen >= sizeof(*uresp))
> +			uresp = udata->outbuf;
> +		ah->is_user = true;
> +	} else {
> +		ah->is_user = false;
> +	}
>   
>   	err = rxe_av_chk_attr(rxe, init_attr->ah_attr);
>   	if (err)
> @@ -173,6 +183,24 @@ static int rxe_create_ah(struct ib_ah *ibah,
>   	if (err)
>   		return err;
>   
> +	/* create index > 0 */
> +	rxe_add_index(ah);

^^^

I ran an AI-assisted backport review, and the finding looks correct to me.

This backport commit adds rxe_add_index() to address-handle creation 
without enabling the AH pool's index bitmap. Creation reaches
find_next_zero_bit() with a NULL bitmap.

The new rxe_create_ah() path calls rxe_add_index(). Pool initialization
allocates the bitmap only with RXE_POOL_INDEX set.

drivers/infiniband/sw/rxe/rxe_pool.c, rxe_type_info[RXE_TYPE_AH]: (Code
spacing adjusted.)

5.15:

     [RXE_TYPE_AH] = {
         .name       = "rxe-ah",
         .size       = sizeof(struct rxe_ah),
         .elem_offset    = offsetof(struct rxe_ah, pelem),
         .flags      = RXE_POOL_NO_ALLOC,
     },

Upstream (73a549321003):

     [RXE_TYPE_AH] = {
         .name       = "rxe-ah",
         .size       = sizeof(struct rxe_ah),
         .elem_offset    = offsetof(struct rxe_ah, pelem),
         .flags      = RXE_POOL_INDEX | RXE_POOL_NO_ALLOC,
         .min_index  = RXE_MIN_AH_INDEX,
         .max_index  = RXE_MAX_AH_INDEX,
     },

The parent did not allocate AH indices. The required pool setup remains
absent at the reviewed range tip.

I suggest: Supply the indexed-pool setup from 99c13a3e2965 ("RDMA/rxe:
Change AH objects to indexed"), including the flag, bounds and maximum
count. Or drop this for now.

Thanks,
Harshit

> +	ah->ah_num = ah->pelem.index;
> +
> +	if (uresp) {
> +		/* only if new user provider */
> +		err = copy_to_user(&uresp->ah_num, &ah->ah_num,
> +					 sizeof(uresp->ah_num));
> +		if (err) {
> +			rxe_drop_index(ah);
> +			rxe_drop_ref(ah);
> +			return -EFAULT;
> +		}
> +	} else if (ah->is_user) {
> +		/* only if old user provider */
> +		ah->ah_num = 0;
> +	}
> +
>   	rxe_init_av(init_attr->ah_attr, &ah->av);
>   	return 0;
>   }
> @@ -205,6 +233,7 @@ static int rxe_destroy_ah(struct ib_ah *ibah, u32 flags)
>   {
>   	struct rxe_ah *ah = to_rah(ibah);
>   
> +	rxe_drop_index(ah);
>   	rxe_drop_ref(ah);
>   	return 0;
>   }
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
> index c852a9907bad4..446d14903cec5 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -48,6 +48,8 @@ struct rxe_ah {
>   	struct rxe_pool_entry	pelem;
>   	struct rxe_pd		*pd;
>   	struct rxe_av		av;
> +	bool			is_user;
> +	int			ah_num;
>   };
>   
>   struct rxe_cqe {
> diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
> index 2f1ebbe964345..dc9f7a5e203ae 100644
> --- a/include/uapi/rdma/rdma_user_rxe.h
> +++ b/include/uapi/rdma/rdma_user_rxe.h
> @@ -99,7 +99,8 @@ struct rxe_send_wr {
>   			__u32	remote_qkey;
>   			__u16	pkey_index;
>   			__u16	reserved;
> -			__u32	pad[5];
> +			__u32	ah_num;
> +			__u32	pad[4];
>   			struct rxe_av av;
>   		} ud;
>   		struct {
> @@ -170,6 +171,11 @@ struct rxe_recv_wqe {
>   	struct rxe_dma_info	dma;
>   };
>   
> +struct rxe_create_ah_resp {
> +	__u32 ah_num;
> +	__u32 reserved;
> +};
> +
>   struct rxe_create_cq_resp {
>   	struct mminfo mi;
>   };

