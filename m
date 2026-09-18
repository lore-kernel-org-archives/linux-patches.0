Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285637FF6F;
	Fri, 18 Sep 2026 20:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789764043; cv=fail; b=TDF6/dPwKi7YymdDB8bzIaCu7nU6BqH41Cg6tsEPdria0gFP7TnSIsfHbbN2bqdM86YhURIcW53IqxEeQBq1fmwp75rB3Rl2XwrrZ81UI1ObZhnkIvrV3DFDlkuGp1B9sLowFIcp4rDzKPvOeRG1aHjdmDLySkr/kitJbmUkKDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789764043; c=relaxed/simple;
	bh=l9oPqWr9EXsbEWlrxV0F5wwB0REOPE1lV25XYMhUu20=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pHt4MENzblQf7iBmsN4DrDrdKL785gTlHzST8X2itQhasdz7XbDdiVggK/WTeBvSqgoRwpTB9bBsZ1BFIQsKJ1tH0wppTtO6u8kR7rCWKVGvrGFj3turvUWQHyObQXKXkFsAe8E4E9FZse7ykqD51nr7vpPXaq+C1CSG+zjvuJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gV7NElQQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d0h//OzG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gV7NElQQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d0h//OzG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IJS2H93537914;
	Fri, 18 Sep 2026 20:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s284J2LZfF39u5ZycY11vKY8byMQEdJ3FWVu0StTJCo=; b=
	gV7NElQQCL1JIDuyOBHOKQgx7XrLzd0jVc1cy0XRtP4G6Ls9pFUKyi6AWI7QeoIu
	/jiCa8rQBIJcUDQpsOq/FqXjtauzMQOBAl02Uk2CiDbMrmAiAKMx0f6+e2J8lNzq
	zAc1xs+bI2lS1HPFhBKZirHT6ke/etqx16gNDtSghLmfLeWtjOh3eQyqjh61o1Zo
	qiGzRZ0I9sMiS3YzyOcMu7hBaPETHVfNhevaVaLJxlC2QYQQZBaO3cUD/OqYKnz5
	g/SpyW485SPejRJq0tcVnfp/vbmIB198AUTpVw4DwjwOXh1YZ0jyphq+DW8Njtby
	4rNRyEHT3kiQZ1SVK6Ag6g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwh1t971-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 20:40:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68IKeTVv017024;
	Fri, 18 Sep 2026 20:40:37 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010015.outbound.protection.outlook.com [52.101.46.15])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6ty5at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 18 Sep 2026 20:40:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MW7h2kD6Ai2SwtqOtz5boLRpkNBj9lT3VW4U4xucyQGqh0Nk/aoZLZ29Iv8BahlooV2PEL/WWQNtbnw+6schEGJW03qmNDqwC8fYbwb3p6ue5lO/PzZTkS9kpc4v1yNf+wpOFMzPUj+t0r+4p1sT902WsL3Dsib09N0w9s3yk6xY3UmHkqw00PPqF9WLCNbWoEdLJdd2kllzop/BAH0//aOwjqAKKlmRlR8xwo4a2iKXxJ/xiQyZR0phPup7REHPidz6RyGla7opqJASRPxLxHvYrauU4eRdiOiMMc4D9IIfYa+6PHchtEv1qB3WXtTTsQGUOSoT7x+yzbkgNGhfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s284J2LZfF39u5ZycY11vKY8byMQEdJ3FWVu0StTJCo=;
 b=yAUh2m2SS7m6PyG29LxAwsKFmiuUuE/9SpwFVHXR0x8P9w4TIZDK2QcW6T5SWVpeISzoH3uvx3AQM31ryzAlKua1yf5SOW7IbwKKsSMtcDvCk8aUdcUxPLCt1T6hFPgnicR/t+fll9lRRvvbP4/zYrwah3SQcPr7IU5arLyZJHp5fqGeZ8Rqa3EP6JHNK6OBY3Cr2t+WMt5FGAD6Jd5LgjqvJVHbXROdm0Yl+l+EgVITJU6VYsQhDXFLaRoguPzzPcwg+Qf0BJ0tyYyyLaPdoDcRWxu6egsIbaWlfBhH550T+kIjG1rXl42Jjal3+9wTFZOEZeftXO9q+k76HH9uhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s284J2LZfF39u5ZycY11vKY8byMQEdJ3FWVu0StTJCo=;
 b=d0h//OzGRCqhLlNaOwq4gPwOJOXTGMD4yTXChGwmeyJwoc/K3Nym7ZkWC7NT0LoxNtuo0F++ug2x0sRCJ2+OGp3rDuwyPQ8RhPROXSZzAHe8xJD7HrzXo3nalSDbMBRturmQubKaGwe3qFcM/sdSVpkER+TbkgytX5i77UhKccs=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 20:39:40 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 20:39:40 +0000
Message-ID: <51f57a9f-3960-4d8f-b6a4-26ca6985f35a@oracle.com>
Date: Sat, 19 Sep 2026 02:09:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 424/935] bpftool: Update btf_dump__new() and
 perf_buffer__new_raw() calls
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20260912065526.833703348@linuxfoundation.org>
 <20260912065536.549009682@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065536.549009682@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::9) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|BLAPR10MB4852:EE_
X-MS-Office365-Filtering-Correlation-Id: bf67c1c5-c26e-451e-7886-08df15c4f655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|6133799003|3023799007|22082099003|18002099003|10067099003|4143699003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	mzJdBllczv0vA8vxvQ003FRrLfHX+eGcRlO/wAA2CUay+AXlhZgdFWyFnCXJEJVw6M3GFwrEPmxFE5hIzNfhsZQ2HvcidU9EvKvaAlJda0+1t69zPEFyYSDhBDeoeXGQaqGjNttUE8RX7HA0AgevHEqORC0sY8v4wBbQc8T3eEmaX81dBiY7u580RU+uXFSWSt1ZHKRBypL9nHprhT4GmaPfgM2znFI+jwYK6aMBJU7c3mQfyDEbrOcQcN3jcLPRXexEQMGyjaaPIKYCdkPTPiz8F1XQfGjKbzzLY5PssErt//BUW3vMSiPPP0sSwlnGW2hAPRerpHlyFh6H2K1o7m/OnXj1W3MTGyUqkNBBG8t5eOxcHjJaGkWLkghTkT8fiV/Vr+GL8iKRNa5s4ijuq2wHuB/cu83Ur9KHR7Yvjs7SIfVxSiFRPf2YRWcLXnt50ELWk0vrWtSHQ1oXp8oUcVYXehXj0Pr2SOo91eMt/b36zQ9VrMTubTnUgCfMJh7BK7SHtmGM+dLRND6plikKr9msJ2f/FU7ETSqraKq7XS2yDBw/x7AUfynVpKpygANWfYAmwalHcSrpXY/Qe/fLA4ETb9WaIXx5gST1UHDm+tCpQgp6rgz21nczGfg57ZGcVm/Vs1QWcSq3t8Wwt+d29tGvEylWxnJXOJe6bxvr1iw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(6133799003)(3023799007)(22082099003)(18002099003)(10067099003)(4143699003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFNPbVVOT0I0V3U2TUJjc2JkNGF2NTZtdFlWR25QanA4NXorRHFxbEpRT1BH?=
 =?utf-8?B?bWFTMzdIMU94ZGprSVJXK0pqWHFJNy9NQnRBZEhCSFpvQUN2OXNEcVdKUGVR?=
 =?utf-8?B?S3diR09GK2JhN3dlTUg0NHR5SUY1eUJzU1B5WmRIQ0E1dkN2MW5mTHYreUsr?=
 =?utf-8?B?WjFXalo2SjBTVlBlcEhEWDNOUy9BWGQyci9LTlJlRWNETHJWNGhVV0ppNE5j?=
 =?utf-8?B?VUsxOVdhYko3KzVPb3dpRDVvTEdldVJ1N1V1UnVRTG9NTUM1Y0xzQy9manZz?=
 =?utf-8?B?QW83R29Yc296M0F5RWVtUnlBcGVOMTRKcUVjYU5LY0toMzhDR3phclpaMnRN?=
 =?utf-8?B?YlhtK1kvLzNTY1p1dDZNNEs2Rks3SmRlcWNUT3ZBbnRUcG1JWGFVRHg2MS8y?=
 =?utf-8?B?UGxvNy9ORUVUVVVMRitnQUsxbGp3L2VwY2hGZTQraFVDaVFtY2JCR01ubTYy?=
 =?utf-8?B?bHBUL1orYWgwbzhMRzZPTmlLVXZERWN0STVBaGNKUnYrSEFZUEJMQk9HejF2?=
 =?utf-8?B?ZGZZdmo5eXVpU3V1VHFtSWZPVU5OTjBwbVhpaGxVUmkvZU1CY1lCK0xGZ2ds?=
 =?utf-8?B?MGFmTlRTQnB0dzBxdExOMlcrR3ZiMUViNkN3N1JVenowd05SVDNYS2dSR0ZI?=
 =?utf-8?B?dzR3MjAvbmVBUnlzNFMzRzUxMnQ1aGh0Z2dRaTM0VXREdHlremZGNFBQZ1Bn?=
 =?utf-8?B?Y3hmUTlWditsMm9MeVhrbVRDaG85Y2lEY0hvajExZ2hFT3ErV3k5YUhVSndG?=
 =?utf-8?B?SFk1WmVXUVNTNHR4ekxCdTBsZmdoVVY0Z0RYZUljd053d29nZm40N3hjU1dh?=
 =?utf-8?B?RGgvdFJmcjgrMkhOL25nSFF4UHVaV3dKYnhhVk1uV1gvNzQ0QUYrWDcyK2Vl?=
 =?utf-8?B?V1pjVFJvU2hjT2FrKzk2VHJwaVBJMUNHZGlTY0hrT1h5MXhYb09lbmNDemZ4?=
 =?utf-8?B?QTFZOVpaSXhiMk9Vc0k0eTE4MWVSZVhiSlVOelJLOGdsQ2pWS0tPWGFPOU1x?=
 =?utf-8?B?Y1ZRUDVkaHZOcmltZ2hWd0dDUG14SHBFb205aWs1a3hVdzBPcDkrNlQ3M1l4?=
 =?utf-8?B?QWx3WjFqcmJZdENKSi96TzQwU2l1WTJMREJJNFFvTVZqem1BN3kvN3lzcEZW?=
 =?utf-8?B?NUZoc2xxSWJEMUNLaXJrNjgwc3hNUU1vc3Y0S0U0aWVqbXZ2bWd0bkZJQ1FE?=
 =?utf-8?B?eE5odTIvd1UyTlJ2Zlh6S05kbVZjamVlUWJaazNqSHgwdFBEM08xelg0aGtM?=
 =?utf-8?B?MloxVEduY3ZlOCttUE9jU1E5UklmUHAvZElSM0xaZVlHL1VWYTdudUdxZHRv?=
 =?utf-8?B?eVBzUXlQclVONVUxd3BBQXB4N2hldWFyQkk3azlGYWZBN1pqOEhwUHUxSFJ3?=
 =?utf-8?B?Ujg2Vm1WRDl2NGxKdUtjc3M3Z0xRQmlMZG9LVUtGTzB4cm1TNC9icW9hNkxB?=
 =?utf-8?B?T0d0dmxlTUVhZUlyOGNLeWN4YlRQSzIza3BGbWFwVUdnSlJqbndPbG9uN1dm?=
 =?utf-8?B?UWpKcHNEaUhzVk50WHBvaTFFOXpoVGNpVFRPaDIzY0tZb0dBMlo4aCt1eldJ?=
 =?utf-8?B?QXhBQ1U4bVpzMnRkM1BNWEdXdEFiNFNtRTJ1dHcxTWhPOVB5RHJSSkIzYXgr?=
 =?utf-8?B?cUxDTDg4OXo5ejhGbmdtaEVoZ1BQemVWVzY2OU5oblF3NThNYy9KQWRDSlNx?=
 =?utf-8?B?SWQrK2RuajZqd2Y4Y0ovakpobVBxTkRjWTZmdDd4SDJ5Y2g4WFZoSzVFbitW?=
 =?utf-8?B?Mi9WYllYc3RDTGlvREtZRzhTTkczbE9jWnJWd1hEK2lZZHNNK1JXOTNJRktQ?=
 =?utf-8?B?anNpcytBSDZqb0hnZEo2MVJCRjhoZXZzdnZkY3hoTDVNelRDM3R1NTlLYzNm?=
 =?utf-8?B?N1RlWlhHaHIxZFRIdzNnZWhsQWJEdExJNVpDcjZrR1FjYlJ6dUtkVVdsUEJC?=
 =?utf-8?B?dTJMZmpZSUNtQkwzcGp2dmJsWlp0NDZFcHhHRDBPZzU4NnNFNGp5SU5vWDYz?=
 =?utf-8?B?SWcrUkZyQTNCZDFaci9qTmk0eVJXYzlrSlg2MGZ4OFBza2pXYXVkanltNDNR?=
 =?utf-8?B?OUYwRDFMekpOM3EvR01zRkcxaHZUZjgwdi9xK2lESHJtSlJxdEc2cXBEVGFV?=
 =?utf-8?B?eGFLRkNObi9EMWxOUzFWaDlBSUpXemN4Y1NZVzRGYlYxTWtKdXFyRjRQRlMz?=
 =?utf-8?B?U0hJVlNpK1loWi9BcWRxV203a1F4bUNsclBhcVNOS2FhN0FFS2orVzFWKytY?=
 =?utf-8?B?NllWMEd0M2c3NThBWDFhbXVkR21IekcyUDkvWlZJOXVvV09rcVlJZnlFMUpT?=
 =?utf-8?B?ZXBNQ0twbGJweGFEcVM1Q05HZW1KYURMb3F1WEFNbDZGQmVBWmQ0SW03Skhr?=
 =?utf-8?Q?z48gI8f0DezhwhRX0dmQXo93I7bmP12ZXmBEE?=
X-Exchange-RoutingPolicyChecked:
	RXUhlYSJf4YawY9V54pW+H5cDfy2smFhDMua9Y5VbcnIcgimk1FjsryrpyPurZU5qJzbcwDFQpwvFpTCgQdFByf3N3730RCMODYJRCoxLjtUJvxfgWMjCXizBqhNVTreDpqi54f7Donp3yslmhkBfOHb9+qTOrpC3grcDrUUJNl05UWYSRLR4j77ERHxK0JMzBTcoyNOPeUaMdA+7joKdPgjXNkznPd164Aw34CB7TgliFRpvxAaWW3b7OxIMsJRm9TG6WZ+vmkbbvL4wsgksea/r/kl0ZVzWuT28PFpXZBkNooIDqXqzyvnwKIJtTTp00pEolu89qfOv5tP/agSmA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SepioZggRUjyPhEgZoKm9XEMOi/kQ2ukWr5SEGVb7Qcdlq6XvPemjC47JTK5DlQp6qvlajfjR5JXIkj+jdq66+WSh2upb5HN3rSFjT6pIy3FR2iAmqhCSjVxkjAgzgSkO/twxXXNfDUeXXSAxHuYIB8L0HwO//BIhpv5aSRRuD4xEZjn5rWr0hAy1B870NgWsUaQx4mAJ/M5cBit7AG4U+jjtjukU/jDks4hqws63ZM+cj3+lwo+QCMOJeHXN139BWUy5j5rjz0dL4/TswEiuQ2Y/zwL+CEU3FbG37xuwBmaDOmYvZikgraSp5+ny0Urc+9P5LkvCY7biT66tbN5mnkzUXYnurvp36Fs/1baSlog8mmuAqhPix5zze61B2+i9rWnNqQJvUlsj/lzzylPTWNAARwGv1BXw41ZsY3N8pTpnNCKds4jo+Nxje+yhpsbV51byZB3xoEOud/Mvsp4ZPbbtmBRRNIsY1zXHgebzUr0hZyqXKhiKSoC7dBJ6hd017bhT6ET2ZzIv6ruU9j0ZxIxW4dCl6k3R/KRAik5dc5r8uhjWGIbtAz9FI4mLwL6z54He4qqAzn64Tf15+5VCOtWY8DByGDF+eCsupsLKTY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf67c1c5-c26e-451e-7886-08df15c4f655
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 20:39:40.3133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDO4d0Q0ckYWJxh6AKBhHVgUhvLgqfWl9Cong+p87H6Xc52WcBY+oV/d/X0g6bzmTmUitNsbak/fIs1/aVxzemcpzkN5PUt58cHlvAlDwtXGN+0Ma9NBvGWIU+PwSq7h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_06,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609180298
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI5NiBTYWx0ZWRfX+rcMdAiY3O8Y
 +PviaZGPfPO5KRUqE3vvUcrBYfKX5KD7eTtLNsUP1direzf5ttGN/qq7Ho2aVaTj29QtehQDz+I
 2DMAqRXTLCAISElhLJLexfjE1RBYJemxgeU/Vzte2jiESO7iqOWjlCZ9XGcgu8wl1hQz31uJHql
 4szJSqNnDaP6vjHQh1FiKVKUjzdg/KG7e4WnyR/MRtiIIK63AD2T6aMJbe+y1m6F8IrAVEMyue7
 q2s2UU4lLwPmOQvzb+4Snbo9cqEAK5mIjFvd61U1tzCFvhUCHLe1u5xs/KvhmUR5NFngcJw7JDB
 X2qdnb2V2pcHXaRrfUZdWpKt06LOXioWEcwjHNl3I1jwi6ghSpZftikjwcNZuW3JVn0aYAZo42h
 u9JbR0LeJ+Y1HQfoKlPy55KgqfJanRK06Qy2lLnoAHYt9od1H5IlLIL035UaLW+/oKhiwz9LL1V
 XyPYtNyzQmYIQwjsmp7MpCqTczItDIXVyGFra3Cw=
X-Proofpoint-ORIG-GUID: kbBQYlSBaugah3m8xRvkasAkEOZFN1Qk
X-Proofpoint-GUID: kbBQYlSBaugah3m8xRvkasAkEOZFN1Qk
X-Authority-Analysis: v=2.4 cv=HPhWhYtv c=1 sm=1 tr=0 ts=6aada1c5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=bUgwCH_c-2nVBFg_E-YA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDI5NiBTYWx0ZWRfX8Y9PitiIItsn
 HgxtaoNgxumwQRq/7acMWXfcL3oS+7ZpDDxD0XulQw+rTVaVXO3hpwXi4ozciL06YzVNGXGM9Vj
 U23Sl5qS4WiKvL5XcrEwMaxrcCKjlIv26jIZCfQIcXEwQB42d59e

Hi Greg/Sasha,

On 12/09/26 12:27 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Andrii Nakryiko <andrii@kernel.org>
> 
> [ Upstream commit 164b04f27fbd769f57905dfddd2a8953974eeef4 ]
> 
> Use v1.0-compatible variants of btf_dump and perf_buffer "constructors".
> This is also a demonstration of reusing struct perf_buffer_raw_opts as
> OPTS-style option struct for new perf_buffer__new_raw() API.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/20211111053624.190580-10-andrii@kernel.org
> Stable-dep-of: 66d7e39e49b0 ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/bpf/bpftool/btf.c           | 2 +-
>   tools/bpf/bpftool/gen.c           | 2 +-
>   tools/bpf/bpftool/map_perf_ring.c | 9 +++------
>   3 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index f7e5ff3586c9b..d4c7cd3025171 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -410,7 +410,7 @@ static int dump_btf_c(const struct btf *btf,
>   	struct btf_dump *d;
>   	int err = 0, i;
>   
> -	d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
> +	d = btf_dump__new(btf, btf_dump_printf, NULL, NULL);
>   	if (IS_ERR(d))
>   		return PTR_ERR(d);
>   
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 07fa502a4ac15..25efbb868e9ea 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -197,7 +197,7 @@ static int codegen_datasecs(struct bpf_object *obj, const char *obj_name)
>   	struct btf_dump *d;
>   	int i, err = 0;
>   
> -	d = btf_dump__new(btf, NULL, NULL, codegen_btf_dump_printf);
> +	d = btf_dump__new(btf, codegen_btf_dump_printf, NULL, NULL);
>   	if (IS_ERR(d))
>   		return PTR_ERR(d);
>   
> diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
> index 825f29f93a57a..241dd3bafd24d 100644
> --- a/tools/bpf/bpftool/map_perf_ring.c
> +++ b/tools/bpf/bpftool/map_perf_ring.c
> @@ -125,7 +125,7 @@ int do_event_pipe(int argc, char **argv)
>   		.wakeup_events = 1,
>   	};
>   	struct bpf_map_info map_info = {};
> -	struct perf_buffer_raw_opts opts = {};
> +	LIBBPF_OPTS(perf_buffer_raw_opts, opts);

I have run an AI assisted backport review and it spotted an issue. I
have taken a look and the issue goes like:

Upstream-style code added by the backport has:

           LIBBPF_OPTS(perf_buffer_raw_opts, opts);
           pb = perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &perf_attr,
                                     print_bpf_output, &ctx, &opts);

but 5.15.221's tools/lib/bpf/libbpf.h still has:

           perf_buffer__new_raw(int map_fd, size_t page_cnt,
                                const struct perf_buffer_raw_opts *opts);

So bpftool does not build: LIBBPF_OPTS is undefined and the
perf_buffer__new_raw() call has too many arguments.

Should we revert this and followup patches to this(this is pulled in as 
a stable-dep-of) or comeup with a downstream fix ?

thanks,
Harshit

>   	struct event_pipe_ctx ctx = {
>   		.all_cpus = true,
>   		.cpu = -1,
> @@ -191,14 +191,11 @@ int do_event_pipe(int argc, char **argv)
>   		ctx.idx = 0;
>   	}
>   
> -	opts.attr = &perf_attr;
> -	opts.event_cb = print_bpf_output;
> -	opts.ctx = &ctx;
>   	opts.cpu_cnt = ctx.all_cpus ? 0 : 1;
>   	opts.cpus = &ctx.cpu;
>   	opts.map_keys = &ctx.idx;
> -
> -	pb = perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &opts);
> +	pb = perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &perf_attr,
> +				  print_bpf_output, &ctx, &opts);
>   	err = libbpf_get_error(pb);
>   	if (err) {
>   		p_err("failed to create perf buffer: %s (%d)",

