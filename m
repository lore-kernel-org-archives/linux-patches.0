Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9826443E40;
	Thu,  1 Oct 2026 19:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790883358; cv=fail; b=Mya/na5RPFhQiqihC+L343ZoAmXhrPCKnKHPCDSnrBItf7sNP3tW6doUxggHm8wkgJX7Hy+DYq1UmWt8FuJfIbuA3J7adpsRSw9+UoXtdJoTfsjrGHGmRGJn1bylQhBYy+86VNbo1e4APSoY6zXnABsBVKbdH9YY6Nioh3KlBSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790883358; c=relaxed/simple;
	bh=6r6fwvbxiO6OAs2NXYUbWRsK0kBRp41sD/yrpmjpGp4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=elKlRIND4MhzwLgRyOmUcs4kXHJJrKTHBk8r+DyrHDcEXvZuHa0qZySLewZiEPJqrH0ITUsMcLi6+tMelSRny12x/WVjsAjArxKPP0eRbLPvYaqDLRNSkgHllVqSqZquk1ywIhg0B6mA0KKwqtlPLa98xxCZ1Q02KVjLrWdEJhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I+KjlOds; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Inw1ie/c; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I+KjlOds";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Inw1ie/c"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691FtlbG3360015;
	Thu, 1 Oct 2026 19:35:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lN6ryFp32eO0GRox2spJyGBKMnz9yuyoK3sTQXcwU80=; b=
	I+KjlOds50wgI2grT3e+nPqgNr+xswrq9ZEA/NZQpl/1AauJQd4tW5L2Rp7EASPz
	/bXezBkdLvhqEd1Ha8jrKMoRYGKmECwf7latDE/gyVqz7QCHhUvtAfdPgH4RU7Jo
	Xzwy68jy51g/Arbn3mkHKDQyKmAdoXBO6miCvBNAfXd13bt8fC1186XtZSLubfq2
	L+HoVrsz9E5hbBF8pU245G/8ldxU7pzovYoXXYlPxm0C8pykbJeL768lCbj54p1g
	CuVRi4LuKfm3d/LLDbEZobzGgSlIun2y1s9jBUBV39VjT+vgldDKzhiByRDHzdMx
	qwWHVRBFQbiWhBv/JeverA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4myj7ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 19:35:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691JZgVb037596;
	Thu, 1 Oct 2026 19:35:49 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011045.outbound.protection.outlook.com [52.101.52.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gt6wkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 19:35:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wAsnURx1m4vLwA9kREG4ibjveMgAULoGEhwEqZKWR/hokAg4hytlij34AAwoLth+QuV5uNSqMl0JLPNCa6vASU/+K1hMMjrlNPIEJs0AWRKxCpg0Nj80v8eO1ZryfZgdhmg3DHcOP3mz0OUSQGt5vyltqGMtBrIpCGdOLQ+VRe0z0xdh1b6LgCEA+Wq4QqW5TlOXD2u/0KB/F/SJiIPWwf2O+z2HXvGjxFjDytScICEIS7/v3Jk0gS3GfwzfYDYE0X4TZ9s+/BwLbWUsAq4KtLff8ejilK4ls4CLcu6ywTAkSve/A+Xt5dQXJcZIXhoiGrjkIBn7VW6HtNcheTYMFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lN6ryFp32eO0GRox2spJyGBKMnz9yuyoK3sTQXcwU80=;
 b=FF3fAA5FySk6KVJkaVvo3Z6idaEkKfbLKrYLaBaST1J4XLzqEjsd5OwsZpaT7h3IVuoy8Y1EcknVIxhnw2ZbE0md9I0Vyj8MP8Opra5ohlotqFxCP2kTyd16e+cW3gN9EUAKD33zVm/XlXslxLoeGFGHns5QLj1btA6WZZ7i8l0XC5/xT68CyPMf3hul60MaA8jWJy/aNNBtTsHXhSwejTaGWUKPxypj2mDb9X5Tde2j/4/xgcRdVPSL9hTcUfqGzggp+yCHqUTou994Q+MVnLDBjjCr4UUBMhQjvzkDiTwgO7xbjaRClq7CDUTGbAyq/MbcbJM8/zLyadvi871vAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lN6ryFp32eO0GRox2spJyGBKMnz9yuyoK3sTQXcwU80=;
 b=Inw1ie/cCW29QFSTot69qm4LTD2W50ucj8jJzC+HVKJAEW/qL/BGAnk/3aEcRFs2ynxGZnYaFYvazgDZCwcTMhT2WLc55ONfz8SKj6NKxGJLjEYCFM+/3u9T4OTj48Ccbt0qt/SHrrgnjUwl9JjoUoC44cQJF8ChmnVPqI/ne5Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 19:35:05 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 19:35:05 +0000
Message-ID: <1fabd24d-724d-455f-8cc2-2e42c2dbd2b3@oracle.com>
Date: Fri, 2 Oct 2026 01:04:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 098/877] neighbour: Convert RTM_GETNEIGHTBL to RCU.
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152416.851103679@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152416.851103679@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ac::10) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 25981d01-5469-4c1f-3d56-08df1ff317e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|6133799003|260925022911599003|260925021311599003|10067099003|260925021911599003|4143699003|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mSpdpp+JYj4Uspj6msIDQvXQJeBpeD61/kcsmtS0uJYpz7ZIC2lDDCogzntrotoTOt92Dzl9APqzBXyPMsEPagbHr6Rx2rZRXTpUxR5JqMPqLcNd91j2PvWb9srk21dvRMdxyLYMVF3QVHETOrpC+vumMSsPwDut4eJwLJvecTxZR7x49jBTM1OJhDdXXQSQ3SGciHk28V1uOXWxIcO+efy4WmL64i6WG/KwD8i7McLDEDqAxQdBCxHezRDZ+3fyoH+ghTdjZufYyTmg1G/AXPYoJaccGv9JuuAwEY3FDgOuub4r0dSVfKC6qMMYuxg8RuUxTpTNKmz75CLE3NgGuvbAcVTpjneQDFN4rXi/Ygv8EtqcEgiGJtKnTllXVkMyaJM36MfZiztiKXyX3MoZbVhGEKBJx2BrBbMWggn4u+hEqKnh7VOJ2MGGRHAQ9gIZGJKFP5493GpJaIxXdQEoiJ05vBEVhxRht8kjzoVTwyUb70AbzxYE9w9FvrcD9bwqpVbJD5H5PeInRbG1007tN5bawspSlErTF2RLgjkiIVWgx9xuaktaqksSMEjJx+Fi9Iyuh7A6aU5IUH8kAMb08DrMI6ZQwCWZbtBvBEv0RqNUQw6BSMy+7wDbEIayhMEX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(6133799003)(260925022911599003)(260925021311599003)(10067099003)(260925021911599003)(4143699003)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGIrM1V6bFNOQ0tFM2p6YjNwZW54bXVpa2hWaGZUSlFZU1RwdWNIYTNLcUlP?=
 =?utf-8?B?cEJzQVVCNUJWcDBXeHpsZXhMaGdIYUNwZ0h1dlVia1Y0S01HMVFSQy9ISjZv?=
 =?utf-8?B?OURLV1c0Z0hmUjdPZEdsNlF4OVhtSmtjSE52UmJtZW8zUVIrL3E2L2FhMDZr?=
 =?utf-8?B?YXVBeUtLbUFCM0lqdEZncE9qTGlvczhQZGRkS1loWkl2TnNiUFBtZ2RZMkdt?=
 =?utf-8?B?S25sZ3N5TnNlVXhYL2FmTkhINXVJQ1RFc2tPUlJrbFVrNnFjWTFVc0Y0bENn?=
 =?utf-8?B?RHQ5SjFXNnNDd2N1RHFGZGd5dkFQeFhhZnI3TVZmckhLbG5sR3dwWWNaQ1ha?=
 =?utf-8?B?T0VRWWF2cjcyTW9NVlNZanlLdFg0Z3pJMEFpT1ZzVVZ3ajMyMTJ3WXdEQ1k1?=
 =?utf-8?B?T1hDQmV2bjhFZXdUd005ZzJDalFGeE1wUUlzZENvZjJsTHp2ZFg4Qm5vZXhZ?=
 =?utf-8?B?bHo1MmVCcXZOaXJYWTllcUxFVmExbEc1OHhGVkJSSHc3Nmg1ZHdXL0g3Z2Nt?=
 =?utf-8?B?ZTBTcWlpMWc5SElUc3JuUU5yRUF4aStIM3hoMFNkamR6UVZRdld1QVdZQ3hE?=
 =?utf-8?B?WEkzYlRnOVR1aEwwU1piK0RESmpFaFRwZ292clA0TllvVzRwTEplVjZoZk5z?=
 =?utf-8?B?VytOTDl4WnBxaER5bnBGdnNTUVp4Z3BlVWZmWGxWMHNLMWxIZk0vTVZjeUww?=
 =?utf-8?B?WEZiNElNNERhajJ0WXZkRXlXbWxVQ2FIS2cwbmp2ejYwZUZDQXAyb2t4TW9J?=
 =?utf-8?B?TGNMekl4cHRzM0JoeG10RjFGd2xKcGdlczcreUVINmJzbnM2RlAzdWZ6Skxt?=
 =?utf-8?B?OENwS1pkTXlqMEF6QVV4VnBlYUFLelR4QjZxTUJibjV6bU55RXFqeVlrMzVq?=
 =?utf-8?B?TTdBQVV3bDlUdXZNTzhOWXJSamRTdGlLTXpXYXh1SnUrL0dkNG1LTjhXWTMz?=
 =?utf-8?B?ZDF0RFdraVdScGZJVEhjamJNTHlGVlUyRDlXYURiZ1FsbkExU1Y2UGh2emtV?=
 =?utf-8?B?L3BXbVlTVEZrMGNKQlFLblVoNVlpN1F5VFdvYVEyZjJ1TWYwZzg4QmxuL3Vk?=
 =?utf-8?B?VVpDd2p5bHpPakdTOXBGTUJjbFpXRzhQdjRRQWRiYXprelhLbWM1NUl5Z2NC?=
 =?utf-8?B?VWtHSk1KLzZXOFZQaXBiZ0lLV2Ria3dRZVJDRnRBb0ZnZ3hydVZJYTNnakxh?=
 =?utf-8?B?YVJoT3RlUHVqOW1rekFxVk9UQmg4bWVGVTVJd3Y0S3o0NmxPNDJhZGwxcUx4?=
 =?utf-8?B?dFNpazJubEJMQWczb0FFYjBCTkN0S3ArWm1ta09paXRkK3JIM0p3TEVJZ05n?=
 =?utf-8?B?QmJXL3JxL1BiWWh1VXY0ZnJ0d3ltenhnTVFRREhCcW04bTQ0VkNvTU9IbGVs?=
 =?utf-8?B?bnFHaVdCdHR3UGZYQnlRbjB4V2dXL0dodjhNTlhBekZPRlZkV095Y01DVlFF?=
 =?utf-8?B?aEx6bnN1Y21QaTRmUzcrVUJBdjB2U0lISjJ5QVBsMVlHV1RqUFAvZlNUd05u?=
 =?utf-8?B?K2tOR0RDdzJzZ2dXMlZQNmxwZnptQytVbGpCRlV5NFp4aEFFeG40bkQyUjR4?=
 =?utf-8?B?RmFXVUIyeitpR2VzcXZWYXVqRHdPQ01rZktwd0F0TnowdnliY1E2Y0ZTcm9k?=
 =?utf-8?B?UWxGbnN0cHhZRTE4a3h5bHl0MnR0ZGMza21zL1VQZjZRT1UwMVh0dVI4ZEdE?=
 =?utf-8?B?Uk5Yc0lOQjFqdkEwSk5QQnBxV2wwTy84WEFvMFZMcGpQYk1Sd242dk5zK053?=
 =?utf-8?B?QStmQVY0cWp6SVdRS1VHNWhvcFZJVzA5Z0thRlYwbHdrN01qNlJkL0lSQms5?=
 =?utf-8?B?Y2tXRFBnUU9ob0MyN3ljYUNlYTRWM016c29laGVjQ1lHQlNJV2xUaTVRZ3RU?=
 =?utf-8?B?Y0ZjNTJOQkJJSGFucWRDVjUrdGs3QUdKMkR2ZE5qT0RWVTA3MW1FL2Y0T0dQ?=
 =?utf-8?B?dnl2dktPQ0dEMU1EUVJ5THgxVVNlam1uMElPSmVRaXRsaGEyalNFdndVWG1i?=
 =?utf-8?B?eHFzMmczN2w3Q2RFcmhmZ2NieHpTSUc0cUZrdEFEeUI0amhmd3VCUFRkcmRl?=
 =?utf-8?B?bXBxakMzaGwyVW9SQ0VlZDlyZXY5djBFLzcvSlc0dUFQb3o5STg0djNMR0d2?=
 =?utf-8?B?c21Eeiswc0tjUXZXL0ljZk5oYy9DcEpscUFUajd6RytKNUUyczNnS01vMmZa?=
 =?utf-8?B?QmZwV2NGaWRyaWh6b05YUW1zN1VEOExmQ2o4eUZsVDNmMWVtREVXR2RtczdC?=
 =?utf-8?B?Tk1uVTlZWDNTcXBtM2w5VkM0OUloQ3ZheXhxN2xReWNTc0d1V3hXZlVWbGF6?=
 =?utf-8?B?MWVEQ2EwSG9IZVdoS3QzUitoNlVLRlNYOG42RVJJSzdFWi80TUh0QVVNN2tG?=
 =?utf-8?Q?ZYb24ugTbcUv1kEeza2UOyB4TTkdUIE9mnTFO?=
X-Exchange-RoutingPolicyChecked:
	a6o/AXkMlCTHIrQL4KS7nxbkBxUXSgx27hqI3dvf2uqVH3apk881MNFtM24+TUvAp6L03CxzBDIqmcsLRRShhjfhD9ZobJSepDMxkl97Q0MDBAbd22eLr3LCzOXOh/HxN/RVmMSvHV4254CrQOvVx7vL9FieETPyVUQZF+1b3yVjwN04OfESF6j0XKPM9aOczUP24cYl7mi3mFrW5Y2b/9ziboB+VVdj+AR8/Z4IbD0F5HJG92ytnuleOPvmUtDgr0DANbQRERrZMl4CIg/qQG4/g0TTTM9L07MqgDyJn6JlFeTjwV84f+k5M5x8UVe5zORhDM6s6HQMF0f5bNJz7A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sw07zIVJQWsGqkj0Hk/3uUhfwxlIzIjPB7DuP170vmexHMQTEIvGY0p42SsRrG+91bq8eAfD1Iy1IyuXxfPKOHo9DBsWH/N5ejxz8WUdNRIACyc3QlwTdUQQkKHBkqHtZx8kE6rzNmEyIPZrC7VqI6zbOmrV9z7MmrxYmQE9wzP1FuCqIbWotHPOQlcw/UvFLNNuAAmvuQYOajuzrx8Y/iNOQPeI2AWxhMQ0ArEnLzkb+8iSHGxRlGE7Qft1LFrZtSKfcfLdJiO5l8MZTTQSlQDGxFCkP+lJzaRQp1u7YkadNIE12EFTZnLAhqTVKo+5lv5WiAaHKWc4V8M+RNjewVUERZ7VkA8pdMIYbCFOnlIjsODIYPY9B4z1/v2d/JQWd906OfkZzabLXxwkF2QPbtmVgpUcsAV1qAKHI6EmDOkGNQWq1iMxGSJH+D4FgPEXE5GehYIOe28JfcHwXI5+HLUcd7OucEpit5kyDAavlhXQlmwHYEeEgo/3uI2STKqh2fpNPArT47q2B75hikGUVhRkPAuNDSO2vIgJ72M5b3sjxinmQJ7WO6ozPdrA8mLzHC9rggyBP1JUiJtHw4jK9CrermFIvTdLg7V32YAUFCA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25981d01-5469-4c1f-3d56-08df1ff317e3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 19:35:05.1011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BA0OF0nx1uI9HynXZyYR3D/s1LU6UZW+l55/unURq+mKvcD0hkm38+v6qCs+yJyeym77iBWXY0lxa4URvmqqm/Cu0+JHu/bxHInYEwzKPbNVt/Vfnhcymzok2fAhz2kg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010078
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA3NyBTYWx0ZWRfX/428BlzIsDjy
 bBmdXZl69T4EJyOKjY06T1NEulvkzEdQowRhkRt/N5QR5+O37y422YTnrCSb4dHXabGD/PzWCOc
 TZGw/Wb2oZSJ2h27JUxEuLSyazXG94hiZrkGxiT/KTIgqSnmyGF6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA3NyBTYWx0ZWRfX698Nu6yFcxPC
 7nwkwOgdl4ItsSWuvHfd2Yx1hUnzFAHOULBpvNWKls5mSliMQrDBH76fsT1DzxPjolY6PsosaKU
 8UVfRgGaerYmKniLShLGxWDjTciUgx15XZbxpT2Kr0o3MqpKnXxlpqdZ6SaziqOjTDmsBn2mI72
 jlHJGt5YS9q/RZ4Tt0OSM4C/uT4Iz346rPk8LRLVOoK2PG5aOHZndKHmQD2ifI1d8uintNQte7m
 s/lMTju5bq+fMnFMEAm8Ka7EGcpmUKx0rNCaGNvvpcQ99vO6AersYmy38Wwb5dKz4i58503b5nL
 4EHlE0WvlBdnwXO8tcO4BRmV5skBHkjvQtnsjdRRsmPG4OIeXm913qBSXDpKzrU0V3BDy6Rm6Xa
 uI3BV6KngtEon6lISD8f4yaWrlsF8dcbWTp0ERfDIraqdN+DaQ3ztRflxA0c8sg34ByhsFb2dXr
 tBPc3z7qITh0M8BLKLQkp6l767XRTXNBiWF/A2hM=
X-Proofpoint-GUID: 8OgqPDvFVnUtYznv00qoMh9kXw07R0RJ
X-Authority-Analysis: v=2.4 cv=DZmCOftW c=1 sm=1 tr=0 ts=6abeb616 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=yXjzR7piOFnY5nZrscMA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-ORIG-GUID: 8OgqPDvFVnUtYznv00qoMh9kXw07R0RJ



On 30/09/26 8:46 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kuniyuki Iwashima <kuniyu@google.com>
> 
> [ Upstream commit 4ae34be500649ec452ac1fc2748958683ad9b55d ]
> 
> neightbl_dump_info() calls these functions for each neigh_tables[]
> entry:
> 
>    1. neightbl_fill_info() for tbl->parms
>    2. neightbl_fill_param_info() for tbl->parms_list (except tbl->parms)
> 
> Both functions rely on the table lock (read_lock_bh(&tbl->lock))
> and RTNL is not needed.
> 
> Let's fetch the table under RCU and convert RTM_GETNEIGHTBL to RCU.
> 
> Note that the first entry of tbl->parms_list is tbl->parms.list and
> embedded in neigh_table, so list_next_entry() is safe.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://patch.msgid.link/20251022054004.2514876-4-kuniyu@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Greg/Sasha,

An AI-assisted review flagged a reader/writer mismatch. I independently
checked upstream and 6.12.y at f4ffa8dc360b.

Upstream neigh_parms_release() in net/core/neighbour.c has:

write_lock_bh(&tbl->lock);
list_del_rcu(&parms->list);
parms->dead = 1;
write_unlock_bh(&tbl->lock);
netdev_put(parms->dev, &parms->dev_tracker);
call_rcu(&parms->rcu_head, neigh_rcu_free_parms);

6.12.y has
net/core/neighbour.c:

write_lock_bh(&tbl->lock);
list_del(&parms->list);
parms->dead = 1;
write_unlock_bh(&tbl->lock);
netdev_put(parms->dev, &parms->dev_tracker);
call_rcu(&parms->rcu_head, neigh_rcu_free_parms);

neightbl_dump_info() now uses RCU, but list_del() poisons the removed
node's forward link. A reader can follow that poisoned pointer despite
delayed free.

I think 6.12 should take 06d6322280d95757cef1e3ee0fc62c644629523e
("neighbour: Use RCU list helpers for neigh_parms.list writers.") and
35d7c70870338aa6a367b9e4ed528914320b0be0 ("neighbour: Annotate access to
neigh_parms fields.") before this conversion, retaining the later dump
fixes, thoughts?

thanks,
Harshit> ---
>   net/core/neighbour.c | 23 +++++++++--------------
>   1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 50a18ae55409e..d38c309e7fa61 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2131,7 +2131,7 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
>   		return -ENOBUFS;
>   
>   	if ((parms->dev &&
> -	     nla_put_u32(skb, NDTPA_IFINDEX, parms->dev->ifindex)) ||
> +	     nla_put_u32(skb, NDTPA_IFINDEX, READ_ONCE(parms->dev->ifindex))) ||
>   	    nla_put_u32(skb, NDTPA_REFCNT, refcount_read(&parms->refcnt)) ||
>   	    nla_put_u32(skb, NDTPA_QUEUE_LENBYTES,
>   			NEIGH_VAR(parms, QUEUE_LEN_BYTES)) ||
> @@ -2183,8 +2183,6 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
>   		return -EMSGSIZE;
>   
>   	ndtmsg = nlmsg_data(nlh);
> -
> -	read_lock_bh(&tbl->lock);
>   	ndtmsg->ndtm_family = tbl->family;
>   	ndtmsg->ndtm_pad1   = 0;
>   	ndtmsg->ndtm_pad2   = 0;
> @@ -2210,11 +2208,9 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
>   			.ndtc_proxy_qlen	= READ_ONCE(tbl->proxy_queue.qlen),
>   		};
>   
> -		rcu_read_lock();
>   		nht = rcu_dereference(tbl->nht);
>   		ndc.ndtc_hash_rnd = nht->hash_rnd[0];
>   		ndc.ndtc_hash_mask = ((1 << nht->hash_shift) - 1);
> -		rcu_read_unlock();
>   
>   		if (nla_put(skb, NDTA_CONFIG, sizeof(ndc), &ndc))
>   			goto nla_put_failure;
> @@ -2252,12 +2248,10 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
>   	if (neightbl_fill_parms(skb, &tbl->parms) < 0)
>   		goto nla_put_failure;
>   
> -	read_unlock_bh(&tbl->lock);
>   	nlmsg_end(skb, nlh);
>   	return 0;
>   
>   nla_put_failure:
> -	read_unlock_bh(&tbl->lock);
>   	nlmsg_cancel(skb, nlh);
>   	return -EMSGSIZE;
>   }
> @@ -2276,8 +2270,6 @@ static int neightbl_fill_param_info(struct sk_buff *skb,
>   		return -EMSGSIZE;
>   
>   	ndtmsg = nlmsg_data(nlh);
> -
> -	read_lock_bh(&tbl->lock);
>   	ndtmsg->ndtm_family = tbl->family;
>   	ndtmsg->ndtm_pad1   = 0;
>   	ndtmsg->ndtm_pad2   = 0;
> @@ -2286,11 +2278,9 @@ static int neightbl_fill_param_info(struct sk_buff *skb,
>   	    neightbl_fill_parms(skb, parms) < 0)
>   		goto errout;
>   
> -	read_unlock_bh(&tbl->lock);
>   	nlmsg_end(skb, nlh);
>   	return 0;
>   errout:
> -	read_unlock_bh(&tbl->lock);
>   	nlmsg_cancel(skb, nlh);
>   	return -EMSGSIZE;
>   }
> @@ -2531,10 +2521,12 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
>   
>   	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
>   
> +	rcu_read_lock();
> +
>   	for (tidx = 0; tidx < NEIGH_NR_TABLES; tidx++) {
>   		struct neigh_parms *p;
>   
> -		tbl = rcu_dereference_rtnl(neigh_tables[tidx]);
> +		tbl = rcu_dereference(neigh_tables[tidx]);
>   		if (!tbl)
>   			continue;
>   
> @@ -2548,7 +2540,7 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
>   
>   		nidx = 0;
>   		p = list_next_entry(&tbl->parms, list);
> -		list_for_each_entry_from(p, &tbl->parms_list, list) {
> +		list_for_each_entry_from_rcu(p, &tbl->parms_list, list) {
>   			if (!net_eq(neigh_parms_net(p), net))
>   				continue;
>   
> @@ -2568,6 +2560,8 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
>   		neigh_skip = 0;
>   	}
>   out:
> +	rcu_read_unlock();
> +
>   	cb->args[0] = tidx;
>   	cb->args[1] = nidx;
>   
> @@ -3882,7 +3876,8 @@ static const struct rtnl_msg_handler neigh_rtnl_msg_handlers[] __initconst = {
>   	{.msgtype = RTM_DELNEIGH, .doit = neigh_delete},
>   	{.msgtype = RTM_GETNEIGH, .doit = neigh_get, .dumpit = neigh_dump_info,
>   	 .flags = RTNL_FLAG_DOIT_UNLOCKED | RTNL_FLAG_DUMP_UNLOCKED},
> -	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info},
> +	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info,
> +	 .flags = RTNL_FLAG_DUMP_UNLOCKED},
>   	{.msgtype = RTM_SETNEIGHTBL, .doit = neightbl_set},
>   };
>   

