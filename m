Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118DB1836EC
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027089; cv=fail; b=rWxkAM9vpAr/0AO0819xltOH5VpITMQT+LQzY6EmI79pBXnoIlM9zS9bfaYLB9cTuTHIMKJ5h+DdhF87RuR9dHd3vqoIsEo/E+MLVY17xVWvnU77MUmrhWwIXBkxvhlC5lw20HWbbg2XIq6HZSFT9IvejYDxm5NNyOLXOf1tsgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027089; c=relaxed/simple;
	bh=OvRH4YRZmLKvZoq05YF747f2LLo89MqA9Vy7zW/bgwQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PI3EljUiuCGWmGDgNXLWUjr41M2cuhcEhujYXwa6nul052sipEJRzXFXOzcULxXyaHR1DMpSa0P6B/g4NDK2KjdYld9Kz7yedUWBNQPbEDpW2eqhlRuYF2qlJXoTt2cScGBLzBS61FtI/bC8AiS7mjSVLi5Wp70XVrs6dXQTw9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kf0Wyoth; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f+tzKiot; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kf0Wyoth";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f+tzKiot"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463FMUGn025155;
	Wed, 3 Jul 2024 17:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=5TxZ1d2kv4Di8x72cMxhlu32bMwS8kvx0HSpEEXOseE=; b=
	Kf0WyothnZM1QACXGAWwmcTLeBs4Heo6N8wY5JNtL48txc0nC4gc2/1EFLvkCtk7
	05bqGPn7fGWFrRZqVRKrtrKFS5O5TltGD5DOerIyaWHgbt5Ojs9Wr4bp0o+tmvne
	lvYriYiB3dNrPMZoNN9+Z9WRqUn7UuJuW71rsX9JbAYK4XsQJGV0RwRKf9t1+jpG
	gPldaH7MkQSGVru5/wm4XRxGGesONxD6oUGpTac5Kp8/dHJE2zvkmrrxJVH6l3Ir
	LFaDV/GeUGgVBFLMY7sRpk+8CDbaANqfGuimEoHRxKbaApbwoep4ETftPp3l6jvw
	dwzHdpdC3TovLVlMduTlPg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4028v0rr5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:17:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 463G5Wp8010207;
	Wed, 3 Jul 2024 17:17:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qftmnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 17:17:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdIV/fuJjD1XHQICgeGGn3MP/B5LGeon5SqDSu+IT71cMAGHnrEJoYEwgEIr9MI22CnxdyAX6gpRd7ZlT1h62IFzs5r2quZaDqUohPZ50Xh57Tcc+RBU3I2BwWHX3KmdQu/pm/9xyZbstakFnS62rdmfzapA7n/Tx3u50dYFsFR/4pKn3hm66H6u48MNM9rWO7BWV3TB+jz9vG7S6JkwUCvs83DBTL7gHTyM2mc7O27hfR0FFDNxZhpCr3wpUjNtEbQaLvEbL0g4Q9+o/WAZ94KMB52/DI5nhSjxZFDWPSdJE3MsInjE/0DEpp+GJispzoXo4BxuU1dEsjwpK7nf5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TxZ1d2kv4Di8x72cMxhlu32bMwS8kvx0HSpEEXOseE=;
 b=Uvdrs7oPvTRfmULegRGSW/y9O0Md6nHkzze7ao90UOEyA59VINUBSvmSgDEhwXkx3pNIczIhHheJTbOnhOOKj74nOCZ9AScKTB0Pv8fqPZXVppMSDRH3LmELx6entusMuxZxEZqugIhdjUT9LpjHcyeooAbboiKgkZQ0T/+RADjJUNbOZDg86E/1uKdwwlXym0rxNFl3kFup4HZA7Vv2Jc69k5mlbj7pcvBmIHi93pofiCitFUnps/i/7FLrM/DFSjMQiP/OgOsUiODLoF1ADwBRbXiiDQbzy6uZoRA2a1/TfKEbzcgKKyAyTVuKrYPSEXFbk0U0pP2UxmUUJzoZeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TxZ1d2kv4Di8x72cMxhlu32bMwS8kvx0HSpEEXOseE=;
 b=f+tzKiotzUBqyKqOvkXo8OrQ6eYuHdpmNYrd79DUS4mzmV21UaNrmx/TV77KX0VFSB+j8kAssx6RlA0fChXvL6jzziSXAI8GDbtW3rz0FSS/IZlkeXQ21uJHJj2tOW0z4WiCyNRrNkdaoUYwgqn4eaUQaiMqAcYJkoCR+swqPk8=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CO1PR10MB4802.namprd10.prod.outlook.com (2603:10b6:303:94::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28; Wed, 3 Jul
 2024 17:17:44 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7698.025; Wed, 3 Jul 2024
 17:17:44 +0000
Message-ID: <4e3bda08-7a47-4898-a7e8-4a8ecd64eff3@oracle.com>
Date: Wed, 3 Jul 2024 22:47:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/356] 5.15.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240703102913.093882413@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::14) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CO1PR10MB4802:EE_
X-MS-Office365-Filtering-Correlation-Id: d6fe781d-b848-4be1-9f20-08dc9b840d41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?bEc3R1F3OUphdysxSWt0cTVNVjBMUmorYmNaZklkbExlN2tmZjkreUhmSWFN?=
 =?utf-8?B?cGI5WCtuV3B5eDA1cHY5ZnFGVE8vMjA2NU4vWU9LWGFDQWVsNXhxOVlLaHo2?=
 =?utf-8?B?TW4vMjZqcFRWM01veGFSYzh3NC9NSlRoM3ByQ2VHTlIzQkJiNVRIUDZEeTMw?=
 =?utf-8?B?a2JRSFowYWhqL29pRUxMWUZZeS9EaXNhSjFCazVBZjVrWjZFSGdjSm45RlRr?=
 =?utf-8?B?WldWOVNCNTZ2dytwS2R3LzBUSTM3R0N4bmt3NlJFUzZCakJVVXJxM2F4OFlP?=
 =?utf-8?B?ZXNkVDMwZksvWkt5Z1F5a0I3Wk5aR2NXclRyZHE3TWZRalJZTkhXdndjWFJR?=
 =?utf-8?B?cXZ5UWJYM0pMR0N5cFFRa2VQa09RajNDR2RJUVhOeXlzeFV1TkFQM0RnUDQ4?=
 =?utf-8?B?c25MM2hNQnFVM2JzRmVoaG81d204M2xkSlQxc3c2a09FV0RXQ1RHUnVLMXZ0?=
 =?utf-8?B?OFg1UDJLLy8rWXZvek1pdjJnRkdDTDhub0crR0ZlY2tpaE53SGwvNzlxT2Mz?=
 =?utf-8?B?eUtiZkNac3NNb0xMS2FIdVpTVmpoQ25wL3FXbmFDaDJKTUp1VFFxYUUzdHVF?=
 =?utf-8?B?d1JXcVVrRmpRN2Zwa2FUN0dRYjJyYVYxQmhsT1R1M29jNERpNGZiTW1hdjk2?=
 =?utf-8?B?WlFkYThJQ1dDOEZtRHJUSzlKRTF1bFJzSEc1akxqKzBwcVdpeWhSTGU5YWg1?=
 =?utf-8?B?QXhmMC9JMTlLQ1NDZkFqam5qZkFoUklDSWVGcFNVODQ0NUpYbm4zTFJVcU45?=
 =?utf-8?B?a3BhUlZQSUNNbGgrMXhhRGc0aW1Ydk5ZNVd0ZGlTUGg3eG50RTBoTFgrdUVB?=
 =?utf-8?B?N2RKVXc2cWJmWmFXT3BBVStpTERQZzdTQTluenYyUy9sbStKRmZybHZDVmJ5?=
 =?utf-8?B?cktYUUI2dXg1dmtUZVUzN1FVaEdxMUhPdEtzUkhyTHdqTTVtTm55bjArMFd0?=
 =?utf-8?B?dzZFVk5oM1ZRVmUwaitUblFaYTdhSjhsdEMyS3JreW1uYTVhb1lEdng2QVB6?=
 =?utf-8?B?cklEWWlvUEZwdEpxVGJoL0lvYUdJYTc5eXlQTWp1aXdTRnVnZVZtRkt5UU1B?=
 =?utf-8?B?T052R1p1RlQ0NjRSMUFMT3UwUHhoRGtxTVVYNUZIdTJvZnNNTkViMTJTZGtm?=
 =?utf-8?B?NFRDVWZLWVRzVmRxNXBkaS9BVUR2WTlneGZyMm51OWVydVQ5aG5WNjBKeHRM?=
 =?utf-8?B?MVdtNHViL3VrMGFrRHhBVGtKLzBhRjJxNEVldlJETVJBYXgxNHVBMmRoS3ZI?=
 =?utf-8?B?UytkZDM3aFB3aXJKQXp0K0hIR1g4UEV3VXV3ZHJPTFRVdndhZVp5KzJyUmVq?=
 =?utf-8?B?RnZnWUowWTVvd1dQNytNZHVqZUQ4S1RLajFwMDhRaXBVU0hqTFplWmtIUkxh?=
 =?utf-8?B?ZGJZZEtkODFJWDVhK29tNmY0QWJFUTRhTzhyM1J5bEQ4aGhadmlyRDFTVUQ0?=
 =?utf-8?B?YjcrdnNsV25pc1JaVERaRy9FWkp6MVIvaXdwZ094V1F0U2hIRDdwd3lFSExC?=
 =?utf-8?B?SmdGalA5R0tFWXBzYzZqTE5KTXZQUFdRa1lLQnU0RkFwRmZNa2pCWXhqaEhO?=
 =?utf-8?B?cUtGTVhWZndoM251dzQ3V05IK0ZQTXlvSWhxeEVFUVg3bmhSTVl0MmNjaFU3?=
 =?utf-8?B?VEJvN0xzaEVmSFJLWFhEOTNMcUJEN3lzdmZiR1o2bkUzNTdIK3BueVZCWGlN?=
 =?utf-8?B?OXpvd2F5cDRqRjdkNVdvWDNJd1FEQnd4RlJ3U2hCalJMUktFdlErRis3TFhC?=
 =?utf-8?Q?2ZrSmkvxSX99mHX4QI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cm9kUjZqQ1RwL0tzWWozTlA2Vy9YaVUxRWkzNGhYd215bUhISC9vUjQrS2FD?=
 =?utf-8?B?N1EvdW1aSVplNllaNXQ0bkdzWWVqYS9BangzWnB5T3dJNHR4d09vaVNTRlFv?=
 =?utf-8?B?eVhCeGVTdHRRWTNRRlZsSnoyNW40WkdrTEp6YWtSL1daTzdnbHhIamR5Qk9Q?=
 =?utf-8?B?YnBSdENRVHdadURNVHpuR0Rhejg3a25OT0hkY3A5NXJLaTVicG9ReldsN0Fj?=
 =?utf-8?B?Ym5uc29JbVdod2Y4SHd4Mjd4L3ZUSzRDcGRNS1BYWmx3b3pkOGdWSFhSenBj?=
 =?utf-8?B?bEphVW1INjBhckVNcGlnZUhsaXZVWExURnp2UzdUR0xVa2dlMHJTNlhUcnVn?=
 =?utf-8?B?M3dITU1WZFh4b0svWVVLNTdYb0c5SXlldmp3NC9xVkxBL3U3R3h3M21UeC9O?=
 =?utf-8?B?Rm5EUkxnekJXUDExTjRDcXMzUE5Ra3RwZ0N4ZnVKSGpBWE56OXI3RHFDVDZu?=
 =?utf-8?B?TWlpSjllUlNqWGpOMndOMGRoRjN3akpqM2xsczNYOWZxK2Z4b09xNklWaDkr?=
 =?utf-8?B?K0o4ckMzUWlacVVYZ1dxUzFmSTY0Q2dWM3ZBdnFpV0ZiTjZSTmd5MkdHS1FG?=
 =?utf-8?B?b1FjMEtjUXVBWmhFVDl2NktVdU9YcTNWaStUQkNGeDJsUFNzVXRUUCt3SG9n?=
 =?utf-8?B?OHdWZXhpMzBzSG4rdkJaRFVVVmZ0T1o0TVdHbWJnSHgvTFhRbUUvQXZHMk9W?=
 =?utf-8?B?eGdiUGplV3MrZksrbWczZEF2UmJjT2d5OXJ1WXVJQmFlYVZmcVFKZG1UdjNx?=
 =?utf-8?B?cC92NzhJTDlaRVMway80eGVrU1RDYTgvSytLRlNlV25pSFJ6RWpYWTFDMFRG?=
 =?utf-8?B?UFVqT25tMGJ2QXlCbkNpN213WU1La3AxRGVwS3k3UzdDT1lZNHhhRW55eTZT?=
 =?utf-8?B?OXVyckhZVGxYYXg5bk9WT05wZGZWWFJJenVocUtrMjh6akllYURxU3BuVUZX?=
 =?utf-8?B?ZGdZN1lxajhQN0EyMTdVWUFVZGZDNTh3VnRMVXMraTdEenUrbFdBQWpRd21k?=
 =?utf-8?B?WjREeFVyR3lpVGdMUDdFaTY0UGVxNUdhc0pXZlU1a0VpcUlza21HcSswV2th?=
 =?utf-8?B?ZmxodnlYQWs5NkxLNjVSTVJlak0zYzM0YW4xc2t0QUpFaEVFNW1KTnpGdStO?=
 =?utf-8?B?bldoYnZ1QTQrRkx4QjRrV2VXRUQxZ2wvV2dVRmxIM2p2QXVvb2dZRExuWVBG?=
 =?utf-8?B?TG5JemMvRXl5M0l5ckJQam56dXlVUmxEZ0U1eUg0OXRTS1BQcWhpbXRpQ1RM?=
 =?utf-8?B?enVSMDBBeER1cTdpT1NJYkRRajd6Rm1KU1htMW9yZVRZQVB4ck5aVFdRMWxm?=
 =?utf-8?B?RDZyUXVNYWdLbDNvcHlsRkNMTGhZejI4bEdOZWxwM2M3VG1ZS3UyVThPQmZ0?=
 =?utf-8?B?UE1VZGZvQVZhNE9EdHVuNVNPN0dNV1JPZnNqTktNTVVOSWpiY1RJVmM0TVBq?=
 =?utf-8?B?Sk1FdUpLR0puT2FpVEhrcFZWZHU1MnNJUi9oTUNLajA3MFN2SmZHR0hRR3V5?=
 =?utf-8?B?dk5qNy9rdHNQOHdKMUV6ckJ6Sm5oQ3c1VjJENjhEaTJ4anJwbzFkSkpoR2Yr?=
 =?utf-8?B?VzdIbkpmWDdXTTRCSzdSS0dabG5WS3VvZzlRa0JNbHZyZnhsempicmllYWtK?=
 =?utf-8?B?elpackFjaUVUZStLLzRkZTF6WERNK083YjV3RzZvUFFFVW5sc3N5cm5Zd2l6?=
 =?utf-8?B?dFYyTm1OeHd2SnE2ejRSeXFyRGRyUlEzSjZIRXNlNDFNaXg4Nlc3QlMxa0Za?=
 =?utf-8?B?bm5jUXpBckxUVHk1aXM3MzMzWVM3eWtWMFBndTJEczJ4ZWFTUmdoTGVOSndp?=
 =?utf-8?B?UXZiOTMrLzlUWnBKTWVXN0ZFZDNjandhbEJxNSt6L0hsOGJtaUVDTXMvaWxX?=
 =?utf-8?B?UGhVVjBZUzN6OExwWGRsUTVTdkJhQ1NmVGd4ei9xRW5xeVJzQ2RpZGVUMXAv?=
 =?utf-8?B?cnBPalVGd0RjS0lTK1VYTm5BRWNkTkFFOFR4THRkVkJ4ZXpOSGQvUkExeUQ2?=
 =?utf-8?B?clFYT3NRUmdkL0Q1V1VtTUJIOFV5dzVYT0dJQ0Mzb3cyeDVJSXRjZldmUUps?=
 =?utf-8?B?eUtBTkFxUTJha2JGMkRKbGRVVXl6T3N3R2RQektGVjhibmk5dVg5Q2NSM2RN?=
 =?utf-8?B?ZW5JUitCM1p3K0VuZTVQeURZdTM2SlFwTHN0UWk5MVVTaGxBME95WlNtTzYx?=
 =?utf-8?Q?6O1qA+zcccjVZlkicILeALM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	xi5KOj6cdwJWsESA7EfN44W8LPIO88Y7fYboRlNDAdbUTsGjbNJwhlRysYCORM11Q5ktAcz3OE0TtuVA3S+1brJ2SwxpD/Z/ElJDf9RgapPJqyC6XVQj8iqE5TeGjWxz5/VHIk/dZaBctuL5Yc+afZ8dml8GiRUO0t71HvZLb3VS1F92yLMqJIY+DqQrcM/TiTPUN3DoXsIutnNS7zN9XBp4OcUX8Mew/M83jGwicGrMzYncKkDkHh2exaEO6ZZl0JQT9iBnll5jo7WNGPqWgijVmlIu3mKL2Ix0xQcOyBqxaAWkd3CnvDIAKr99bycTk0sfmB9IxFNFdpDL8qzLytULXokWDetH2f62X7T2MMo6ppCF5Shi0b517FkTKz8gl7yMhbd/MuUA9U2OzKRhrmQJGzRZI+Dok01XHiFccP8eD5rF5hw5fFiU1En5732FezOKQck0kipynEjQIf2Iaps66GqegT3IT/Yw5Uf4FIu4Jpp7WuewoPbLUv1t4TDqo+YuKNlJ11faOH0hT15phOX+TXIl4Y94ZzFmH4PmFj7gXOnYLzH96NcizIJcb56SUwgcMwSThdv/b/C8fCFPER7EC7jSzwElQXha1YTAcf8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fe781d-b848-4be1-9f20-08dc9b840d41
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 17:17:44.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jlTyxx7weB8BMKmHUOpyRa++f64rdUXH8ZY1TexAoIaQpdd7E33l/ZU8eq2rTOKipM85OcpEh5mQGJf8qFM047XvalAtWdUO740DfttvLqGx4UqZq+NSsH6jUaXXI+Zj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4802
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_12,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407030128
X-Proofpoint-ORIG-GUID: nizdzE8h3gLtUBSAYJqc0uCo0Ijod7NO
X-Proofpoint-GUID: nizdzE8h3gLtUBSAYJqc0uCo0Ijod7NO

On 03/07/24 16:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.162 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:09 +0000.
> Anything received after that time might be too late.
> 

Hi Greg,


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
