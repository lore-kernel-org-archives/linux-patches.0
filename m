Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139073B8405
	for <patches@lists.linux.dev>; Sat,  1 Aug 2026 04:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785557150; cv=fail; b=dxjxvH4wb2FlsvKmqDqr4a5DPI1l5JIOX0XJhZ/lHVYxKwauYcbq607vapzz1nldOWGFM7iOto+7TV1wovgdmuvBUKpXTqgN4DtbuxgERzSm+eR14mMFnA9dIoAz7K/fiMM6CQ5paIZDCb5TUpeVL2Hv1bCLkSonpKCreYKGGu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785557150; c=relaxed/simple;
	bh=ZR3MLHFTa5eHjuY6lbhjpyV1faeBAWiNTxRIoy2Qqxo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eJM/V/5HaJytSaYoWFLb4wCRO53BN+cfjO1JBOU+rJuxiv9FAS+4sjWKO9WGGuwf4CLBMdhFo7c7FtuYippfwDaZsDfsGHUP5vFm+oom1hG5se7ViNwHT00/f2gT7qEX7HdlgMs+qT/bjErMz+bLf1PACIgpnK+rYb0lwZ4soeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DVCwQUMC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JtoOXD7O; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DVCwQUMC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JtoOXD7O"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6713PP7p1380769;
	Sat, 1 Aug 2026 04:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4dmN8wnRZTcrUgzPH/2cqEwzijFlqoIfb+QpFYdFaUo=; b=
	DVCwQUMCucKzVhAvfCA7dVv371Tu4M9xFkplaZgTrQmw1nAQSMFkWjfXz9H+cYSo
	8V/yk0rAIw9D73Yy2bVflpyLMkuveO/+A2nMejx0r3tZIpRRxTJlbrCUGMGk5W7t
	h2iN828MR6KFDuDFZu9lZvznsWTZMo9YZAR6yRK4MmsaGqD05H8KkLHDTQlI9lMY
	3mb+rZB0kcVMgWSL89hAzcaip2Ledts1ureRtatpoNza/mgfyC7W1q5O8UQVR2Ks
	SGeQe59UJ58DABv0fgCj7hhYv0K3OGKckvuHimzTxfDD+viJ2/xqFEaXYJSjttjt
	oeMiP6pyqcN437Vt63l1bQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p904yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Aug 2026 04:05:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67145Xep039285;
	Sat, 1 Aug 2026 04:05:39 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010008.outbound.protection.outlook.com [52.101.61.8])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78q2qra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 01 Aug 2026 04:05:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JyZaG4xB+bo7pBs+yoDRqwtlzpgApaiuWHUT9ryOZP2sFF+2H/oX7SBz/AsXqDy3C2yK1KUiiAeKTYGcdGZYlPNy2CvjX2/gsskKbkivdpdoC76YtHlkjATZEiwhVN+fd8cULTrnPs/kQBlwIue0lQ2TqhKGuRcbYWpIA/C6efZfnTF+glq28TOETDrE2NK41TV706iM0xZwwXGjCgYA1qdhUr2hdgfrriOLMxgy2eU81Xv3KBWZOFFdSikGsF2sGEfGcxFwhGD3lj4tR3th1IMCNkg8CGFdV5OGasK5Vxit5kIWigDEJWw4nMJHlf4XcfKK50DZaTfNDX3mg9fgiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dmN8wnRZTcrUgzPH/2cqEwzijFlqoIfb+QpFYdFaUo=;
 b=UMl+9UdeSnqheVaUltL/iGGV9dnNR9cz2jym6Y3+5rQmJQcS9p4H147uHcTEwLj1oGsMU7LWjtSml2D4ahGxgAQaWVpciowVjSwhQ92yTglPnkWpINXdkS9xaI5hvOJoilCOjE4XcGW3bv+0vxsfLUKJBsn9LpK5aplVPADsoA6mNJSp+DFlJo22EAdg4Y7BAWeDEdGIaItPE9iX2U4ItZwz/Ri27HerbUcc22hfe1vsOQJMK+2hpWqXA5edwQDHObjB2qUnrK7KX3nbOwd/dyvCuFzHENAvFSblhiFDapZqJnCtF+Xik5CXebXNNU98MLFz7fkORu//GQu1QZGqGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dmN8wnRZTcrUgzPH/2cqEwzijFlqoIfb+QpFYdFaUo=;
 b=JtoOXD7OCiLFdKF1SR+GIpDKa1A9c87MvCGy+z6xiYUcEUSTwr7H4Wnr3iRdnOJXiiqC2JC8UILOQZDumWHaSzQCkHqPzZCYQ0VT+lEGA5pCNl9jajrDSyFBQAghErW3IH75cpg1dfgbUz9lcO1Z2GrJnqmQQzuOCbW+HB6gjOA=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB6500.namprd10.prod.outlook.com (2603:10b6:806:2a7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 04:05:35 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Sat, 1 Aug 2026
 04:05:35 +0000
Message-ID: <5d2e3444-62ad-43b9-98a8-446bec467699@oracle.com>
Date: Sat, 1 Aug 2026 09:35:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 469/602] i2c: davinci: Unregister cpufreq notifier on
 probe failure
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Haoxiang Li <haoxiang_li2024@163.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Andi Shyti <andi.shyti@kernel.org>, vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141445.818442273@linuxfoundation.org>
 <88a84d94-8c1a-4ec5-b985-f5a7b2e29b26@oracle.com>
 <20260731223023.7d4a4ed464940f55@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260731223023.7d4a4ed464940f55@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0031.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB6500:EE_
X-MS-Office365-Filtering-Correlation-Id: b9af1bbe-b11c-45b5-0fd2-08deef822359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|5023799004|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	nJk1BLKdGj3reyEvezOVY2LxsDI76tyr8QbVYY3aCPRYtqoPdxnpcvMu0Ik/4oRcXRATqGzU46CoKrMjieVYvn+23M4t3U6hVzeILEVWCfWic2AkBsTgZmSzof8VilA6IiBG1TMBAZhIzj/ItervbIM62KsRSp/yg7TQmv+bjdl2l3SRI3zS4zvdlnHZJWlfxNLxpTWxbbagVTi4kUOOp8rxLAJX6oRfF2L5gKjlxfP72Qt8UzZO0XJcuZc3eBeVcJ9fA/R7cTqNLnhVt+w9Nu6WIPMFZKmE35psCaXykQHo69wkkbmnSEEptkiK/00ooxeTyZeWUKW5oxouPWRHF70tcpQnHQ8OighwG8y9e4eeSvZ1ALawWMncKrBNzf2qCcenFvUJY9h+H4KVrg5CUUWVCkl7yiXwN36tMLwDCHE8gGBV7zHEbzTLwaK/Y1sVNkFvbWnn+LnraBXSUkR6RepSvOAK3GYh8/IwuvfeQ/FmxRZpYMY4O707FJOAbpKpCks6mgOnt1QcQEPLSII+8uWinS/PQ0VISNF3v+qNb06x7aNfsQtVjPNOmxZ12HchF7p5m1sCOB2U+Jrx3Y3cuKU0dSyTwjUFgC4ylYfiUlEDjKLGqp+MatHXZ6AKLUYqfpJ9H/RINQrw91H7iNQS/4nS6PQeZwW35sbdfUZyMGc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(5023799004)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmdIN3B1UXR1RitIZ21jM1ZjSG91R0xtckZENDVrWTZNS2xNNEQ0eXA4b0Nn?=
 =?utf-8?B?ekVPVEhkSVk1TjdKRFhWRHNBM200MW1yQnBvWmlmUXBDWS80MFlKemJjTVQ2?=
 =?utf-8?B?UmtwMEl6ME1kUWVFaDAxOUhUZ29talFSZkdza0RtQldjWDRSZFZwQ0tCekxS?=
 =?utf-8?B?NU1HaE5takFETVZxWm8yb0RDMlhYU3ltdE9iZDMzMVVzeFZpSGt1dnhtWWJK?=
 =?utf-8?B?NVNtdWkxVHZMQUt4Z3Q2QnF6c0JPbHdOT0ZCcFU4ak5QUklDWm5hY3lNZWxZ?=
 =?utf-8?B?RWtGMlZGVWZ1bkI5bVdqNHUxQmIrY1ByUnEzTWVTbGlTVGlvb2d6NTNVT25C?=
 =?utf-8?B?c2dMa1R4KzNCdVpQWUwvclVVMHFSUUt1TXZvamh2VHRCMFVYbG1JY2xRckYz?=
 =?utf-8?B?T0VaZE1zeDduejhrbVhnUzJQalhuZkR0Tmc0MTNZVHNITjRJR3Iwem1WdWVu?=
 =?utf-8?B?dkg1a3hzcGdIUVNvcHZEbGl4Y2tJWmRuWTBKRnBRd0lhelhIMTJrUDFXRUlL?=
 =?utf-8?B?MGpsQ3hKSThGblA0UVNDMEZUMW5iN3dEaXhBdXRHWnlkV0N6ZStQSGhPNWRl?=
 =?utf-8?B?NjlYWWRsTnNoNHNGRGdpa2hwK0VacDVoQ2h2UWM5SkpQaTFPQTlSaWtJL2ts?=
 =?utf-8?B?QU54R3ByR1Frd1VtMTQ3SVFBcWtBUUgrU3dpV0laK1o5ZmhmeUhjZVFLYkU1?=
 =?utf-8?B?c0U0dWovZjRMYVhWb1EwenhCbGJOM3lucWJJQnk2WHB4aFFlbGF3S2RaVXRC?=
 =?utf-8?B?alZhSGo0aGFFOHRVWmVKRWhtMXdwaml0TExTbisvL0hHUG9qbzJGeGlmZnAx?=
 =?utf-8?B?RDNJbWxIYVRPK1VUOGhTTnU4VG56ZmY0eWtXQ2tPcyt1K2xybzRkRmpETGNX?=
 =?utf-8?B?Smt4a2FtRHMvbXlSNE55cnhNcHdWSzF4bWNyVlBGaG9OVkl4VmFLYTRWUzR6?=
 =?utf-8?B?Znd4TXIvcWpqTmdKZnRSRUM1YVl5ZHpSQnlaWGNJajRKWmpNanh5Y1VtdFZp?=
 =?utf-8?B?c0xFTmZkcW1oZUsyZ29kODlPZFVYLzdmTld3bVQrL2dHZDIzOFhnYjBDeW5T?=
 =?utf-8?B?eTkrL0tia2xtTTRQdUh2YzlsNnd6djBYdlBWMnNPRlZpdUVWdFJDdU9WZk9s?=
 =?utf-8?B?dGtvbGRBalZNS2VQWmRKcFFjdStYWjZUZWlGcHNqVGpSQWhhMEhDdkRpZlBx?=
 =?utf-8?B?bEhWc3hLdkpSOFV2UE9IbmJJNjA0ZnU1WlZJY0NteVhUclVlMlhvRUlLZU5N?=
 =?utf-8?B?cStlUFMvZWpscjQ0RzZOd1laMm9iQkNVaDN2VWNaZHN3eUtaQXBwdmU3WUhz?=
 =?utf-8?B?TlFZYzJPYmo0ZC8zYXdKOGdiN1d5S0NyK25lbnFjdEZMWWFTVVNQODdBYU9Y?=
 =?utf-8?B?d2dZOUlzenBpOUlVaW8weithaHdnaVV3K3dhTE43TnIvdDV1elBFR3luMWpO?=
 =?utf-8?B?MDhyMmIwMTdXaXQxd3RsbHZxbGlXb3pTSnpubVVHanBXZVJ6ZnIyLzRDUEdv?=
 =?utf-8?B?NU04eTMrZVA4eFQ4QmltdDRhTkd3a1Z6bWY2OUlKUWlKVVg5QWtGRExpTGZa?=
 =?utf-8?B?bjB4aTFuMSt1dFZEa3AvZnVodEpJRGlxODdiN0N5SlBNekxJUno1SlhEM29S?=
 =?utf-8?B?ZWFDM3RFazY3TmFUZWE2cmhVSm1OQ2hHY0REK1VFVTdXalhuSERUdjJQenEx?=
 =?utf-8?B?SmFKd3Q4alRUQjhmelFnV21SLzM1MzdiTmROakM2eVFJMkw3WUpoREwzQW5l?=
 =?utf-8?B?alRabGtmMGFSSWROSFQreXVnNlpmN2N1Y1JvRzF5OC9RY0s4UnY4akJOZVBZ?=
 =?utf-8?B?SzhDaHhzSmU2WWFQS0JObGhoRkY4dGlBS3YvenFKbENjUktxRG1KUHhMR2hs?=
 =?utf-8?B?YzVDWWZ5N1lLWVhDaVNTTTdLdXhFNW96cmRBQ29IQjRqeG5QRkxmU2xLTnl0?=
 =?utf-8?B?SlI0TVllVUVTTWczR3RaZkFQRlYwa3JyMEtHWkVRbFBvM2MwaHIvd2Z4WFhN?=
 =?utf-8?B?OWxubUxvTVVER1YzSTlZemY0WGVVSUk1ZjYxajJzZ3NUaXN5OGxkUnlXdTZV?=
 =?utf-8?B?dEdzeXhLQUpnQkt4S3NLN3NQWEtKcmwzQmhLa0x2Z29VUCthbWRTZ0xNbXZn?=
 =?utf-8?B?U3ZkV3JPWVZ1TlNiRHczWTFrZGhmVkVPUFZLTVlQU3F5TDh3YjQyRnFlb0Vx?=
 =?utf-8?B?MGZMMXAyVWp6NXc4dTloS3hBVnN6NXRSZXJEMlpYdDJUenkvaWV4TEREbEVT?=
 =?utf-8?B?bjIwaFJNRHVSbWh2bVArbHBLaFJRUHRuVDlZeUtDckx4QWZyTDMxUFhKekRQ?=
 =?utf-8?B?ZlVzS1lXR1NVVE5XakZBd0lHRjc2b0g0aEFKMnVvVCtxYVhEN1Qyai9XZUp4?=
 =?utf-8?Q?8XAnfYD4pdHUp6hUIT3y+3UwlQ7TvTXZYIm+O?=
X-Exchange-RoutingPolicyChecked:
	hjKSej5oVNv6mDYY4iUho3wNxgRZxKmduUOOQ03+NC1k1akdTPcG5ROv5tEgY5KF/omAaBunEmB/viB4yCNd7t/jrAIMT7cruwMilWghQSh2VHZ7ZVeDgiAoX0GyN+Ql3Q5IYvjs44GX0E4KqHs7XMDuIiIk5ZQxO2a9HGYdQJs48xn7mGzTGbhlSTraTqzrXJfkPYz8i4y7aT98pmTrpfPh9vBmhQIEcYpRU7DFVVoOgF0rFk/hV7zihk9kmCxNa5j7ZV3D3l3O7EH8UnjdL0ID/aRVqG6gtm8SMjTD9MURT7118yuA3zaXbJcoBxpIyvluUHoTakcwGFUT/Zb+3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hwmBiifHVK5idVgCySfbu7obkg9vhrOcmzeW/qyFkpuyNeB9757g6CKkxXnkslQhO7v13s9rb0Mps8M0joBL8HTvPNrtAg2a1QKKGexUUXzLFYv1Wroh9Q39VpHO+TfjHNhs2CirTPf7R3NK18ZNm5HoMyLWruWZLJEvqjMRF4kfgbutqtEiOnrdvTz6BoHphr7SvL1o7lxP+43O6Qq8o1Fa8WpbVq+LZ0VQQxMKeUOqxshywu3AbyFsNzUBcx5GnWML8m8Tg3uCLfNXUPe9Of8k5nZoPBptd2VBhMrlYvZtZOLzl78xro9Yt4YIiOMe+sD8JkrmdIBe3HqpLAbKbRJ8/9AvaOUN7HPY+TUDHM4idGxlxnORX4pGaSwq778X/8mfdWkNWL2KGpzDswzjMxvZHTsz2jO8ltHFgnjFm+pVl/IdUu30EabasVot2E/e2P8IcLZFCdvQk6tB/HrlSW9VQf1avGuRzbEWZbQKlO59yjemkO5WKUQMVZf68HxCOH7+R3iKcVS708A3q6NVCeGbOz0u+XSMCHFip0Kw8Jy7kZ5LfaReAbYSEdXdIPP3FVp6BflVUvZrzNC8st4PnsT7ib0xLSPmrsK+ie/Kz/8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9af1bbe-b11c-45b5-0fd2-08deef822359
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 04:05:35.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZo7QLxhXYOsiNx51XCuHGi9UHVjJhyEzwbDEDnz87nSJZnB5lddwimGrGAoBpSldQtUDoYte8+FganoJL/vds4sDFf48PK86zGK68vkwSmSQSm8l1Ry6acEeh/VV2vs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6500
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=961 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608010023
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDAyMyBTYWx0ZWRfX4kPQqs27D6C7
 EwH6Gg0MI+Q0AqbLhlkh5vbWKKrSmyvjRnzmM7sFX9hA5TgOwMJrgp6cwr1w1fixpoXYtYjwB+X
 nmUPYaQ7kjz/nHR1K4PqxXeBLIXPXgT6tNObcnApEOkC9emC7voY
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a6d7094 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=X5U9zs7zzGcm0ku3_mIA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 a=zZCYzV9kfG8A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-GUID: -HAwX31Sf7oJdgL6oFuqpmhZIl0nRwX_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDAyMyBTYWx0ZWRfX67gSHVEq9V4h
 hiInEnVuyg0GEDaeMg4BgzONujEM3JgmNIbw7bivhqgIWvlViv8w+vVwnAgwO+tPJwHmeaXKZ2/
 2zMYlyZBFo3xVl1xeGTh6NPA7amJla2QFWAFXNxb3xU6InEVn/s7CplwYcoWppUABJJBfElgifd
 1DNcgKTiNmHD5L6xdhyYNlduvGrijBWRDn96lj6vEKX3X3NXyB9tdpoWPtCUStIgnhFEZkgMECP
 /rZ3NnHzlFt0DlzVx2B1dRXKo7WgAKwaPlJcf+Io/tIwugpd06mOIJsSif6MHgZNPZjz8ZTwcwE
 bgqyckclvTwhBxD2GKj4rkVPnvFDQSuSzp9lzDt4ZrFTRQF5zmqUZiCrlLq4Hh4qO8Xz2n7ntBX
 wZwecuRZBoLBmW4Smn8fDGzy5wtbScGMFriWqiFd7P2B9XKKM1gP0+rfz60+f6mDotSjM9JdZg7
 +55fwAOLPXfVuPOdz/Rh7EWPGAObBTZYe8T8GTzQ=
X-Proofpoint-ORIG-GUID: -HAwX31Sf7oJdgL6oFuqpmhZIl0nRwX_

Hi Sasha,

On 01/08/26 8:09 am, Sasha Levin wrote:
> On Fri, Jul 31, 2026 at 10:40:53PM +0530, Harshit Mogalapalli wrote:
>> I think this backport is incomplete; I think route both GPIO failure
>> branches through err_cpufreq:
> 
> Both IS_ERR() checks are inside "else if (dev->pdata->gpio_recovery)",
> and nothing sets gpio_recovery in either tree - dead code.
> 
> They also used "goto err_unuse_clocks" before this patch, so it's a
> pre-existing gap, not a regression. The patch fixes the
> i2c_add_numbered_adapter() leak; dropping it is strictly worse.
> 

Yep agreed, thanks fore checking sasha, just that it is unusual to do 
that. Nothing to fix, thanks!


Regards,
harshit
> And since b04ce6385979 deleted the block in v6.14, there's no upstream
> commit to backport for the rest.
> 
> Thanks for the review.
> 

